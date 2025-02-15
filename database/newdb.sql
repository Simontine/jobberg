PGDMP                  	        z            jobberg    13.4 (Debian 13.4-1.pgdg100+1)    14.1 -    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    90175    jobberg    DATABASE     [   CREATE DATABASE jobberg WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';
    DROP DATABASE jobberg;
                adelaide    false                        2615    90724    jobberg_schema    SCHEMA        CREATE SCHEMA jobberg_schema;
    DROP SCHEMA jobberg_schema;
                adelaide    false                        3079    90744    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            �           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2            �            1255    91554    fn_delete_account_by_id(bigint)    FUNCTION     V  CREATE FUNCTION jobberg_schema.fn_delete_account_by_id(_id bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 _returning BOOLEAN;

 BEGIN

   _returning := false;

   UPDATE
     "jobberg_schema".users

     SET

      is_active = false

     WHERE

      id = _id;

      _returning :=true;

      return _returning;

 END;
$$;
 B   DROP FUNCTION jobberg_schema.fn_delete_account_by_id(_id bigint);
       jobberg_schema          adelaide    false    7                       1255    91654    fn_forgot_password(text, text)    FUNCTION     �  CREATE FUNCTION jobberg_schema.fn_forgot_password(_email text, _password text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 _returning BOOLEAN;

 BEGIN

   _returning := false;

   UPDATE
     "jobberg_schema".users

     SET

      password = crypt(_password, gen_salt('bf'))

     WHERE

      email = _email;

      _returning :=true;

      return _returning;

END;
$$;
 N   DROP FUNCTION jobberg_schema.fn_forgot_password(_email text, _password text);
       jobberg_schema          adelaide    false    7                       1255    91638    fn_get_candidate_by_id(bigint)    FUNCTION     u  CREATE FUNCTION jobberg_schema.fn_get_candidate_by_id(_id bigint) RETURNS TABLE(first_name text, last_name text, phone_number text, profile_pic text, resume text, video_resume text, certificate text, highest_qualification text, bio text, skills text, interests text, job_title text, experience text, province text, city text, profile_hits integer)
    LANGUAGE plpgsql
    AS $$
DECLARE  
 
 BEGIN
   
 return query SELECT
 
   cu.first_name,
   cu.last_name,
   cu.phone_number,
   cb.profile_pic,
   cb.resume,
   cb.video_resume,
   cb.certificate,
   cb.highest_qualification,
   cb.bio,
   cb.skills,
   cb.interests,
   cb.job_title,
   cb.experience,
   cb.province,
   cb.city,
   cb.profile_hits
   
   FROM "jobberg_schema".users cu
    left join "jobberg_schema".candidate_bio cb on
    cu.id = cb.fk_candidate_id
   WHERE cu.is_active is TRUE and cu.id = _id;
   
END;
$$;
 A   DROP FUNCTION jobberg_schema.fn_get_candidate_by_id(_id bigint);
       jobberg_schema          adelaide    false    7                       1255    91552 &   fn_register_with_old_email(text, text)    FUNCTION       CREATE FUNCTION jobberg_schema.fn_register_with_old_email(_email text, _password text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE

_id bigint;

 BEGIN
 
 SELECT _user.id into _id  FROM 
  jobberg_schema.users _user
  where _user.email = _email
  and _user.is_active = false;
 
 if _id is not null 
 then
 
 UPDATE "jobberg_schema".users
  SET
   password = crypt(_password, gen_salt('bf')),
   is_active = true
  WHERE
   email = _email;
   
   return true;
 
 else 
 
 return false;
 
 end if;
 
 END;
$$;
 V   DROP FUNCTION jobberg_schema.fn_register_with_old_email(_email text, _password text);
       jobberg_schema          adelaide    false    7                       1255    91639 g   fn_update_candidate_bio(bigint, text, text, text, text, text, text, text, text, text, text, text, text)    FUNCTION     �  CREATE FUNCTION jobberg_schema.fn_update_candidate_bio(_id bigint, _profile_pic text, _resume text, _video_resume text, _certificate text, _highest_qualification text, _bio text, _skills text, _interests text, _job_title text, _experience text, _province text, _city text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 _returning BOOLEAN;

 BEGIN

   _returning := false;

	   UPDATE
        "jobberg_schema".candidate_bio

        SET

        profile_pic = _profile_pic,
        resume = _resume,
	    video_resume= _video_resume,
	    certificate= _certificate,
	    highest_qualification= _highest_qualification,
	    bio= _bio,
	    skills= _skills,
	    interests = _interests,
	    job_title = _job_title,
	    experience= _experience,
	    province = _province,
	    city= _city

     WHERE

      fk_candidate_id = _id;

      _returning :=true;

      return _returning;

END;
$$;
   DROP FUNCTION jobberg_schema.fn_update_candidate_bio(_id bigint, _profile_pic text, _resume text, _video_resume text, _certificate text, _highest_qualification text, _bio text, _skills text, _interests text, _job_title text, _experience text, _province text, _city text);
       jobberg_schema          adelaide    false    7                       1255    91564 5   fn_update_candidate_profile(bigint, text, text, text)    FUNCTION     �  CREATE FUNCTION jobberg_schema.fn_update_candidate_profile(_id bigint, _first_name text, _last_name text, _phone_number text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 _returning BOOLEAN;

 BEGIN

   _returning := false;

	   UPDATE
        "jobberg_schema".users

        SET

        first_name = _first_name,
        last_name = _last_name,
	    phone_number = _phone_number

     WHERE

      id = _id;

      _returning :=true;

      return _returning;

END;
$$;
 }   DROP FUNCTION jobberg_schema.fn_update_candidate_profile(_id bigint, _first_name text, _last_name text, _phone_number text);
       jobberg_schema          adelaide    false    7                       1255    91561 &   fn_update_password(bigint, text, text)    FUNCTION     "  CREATE FUNCTION jobberg_schema.fn_update_password(_id bigint, _password text, _password2 text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE

_user_id bigint;

 BEGIN
 
 SELECT _user.id into _user_id  FROM
  jobberg_schema.users _user
  where _user.id = _id
  and _user.password = crypt(_password, _user.password);
 
 if _user_id is not null
 then
 
 UPDATE "jobberg_schema".users
  SET
  
   password = crypt(_password2, gen_salt('bf'))
   
   WHERE
   
    id = _id;
   
   return true;
 
 else 
 
 return false;
 
 end if;
 
END;
$$;
 ^   DROP FUNCTION jobberg_schema.fn_update_password(_id bigint, _password text, _password2 text);
       jobberg_schema          adelaide    false    7            �            1259    91485    candidate_bio    TABLE     3  CREATE TABLE jobberg_schema.candidate_bio (
    id bigint NOT NULL,
    profile_pic text DEFAULT 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'::text,
    resume text,
    video_resume text,
    certificate text,
    fk_candidate_id bigint,
    highest_qualification text,
    bio text,
    skills text,
    interests text,
    job_title text,
    experience text,
    province text,
    city text,
    profile_hits integer DEFAULT 0,
    school_name text,
    education character varying,
    culture character varying
);
 )   DROP TABLE jobberg_schema.candidate_bio;
       jobberg_schema         heap    adelaide    false    7            �            1259    91492    cadidate_docs_id_seq    SEQUENCE     �   CREATE SEQUENCE jobberg_schema.cadidate_docs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE jobberg_schema.cadidate_docs_id_seq;
       jobberg_schema          adelaide    false    206    7            �           0    0    cadidate_docs_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE jobberg_schema.cadidate_docs_id_seq OWNED BY jobberg_schema.candidate_bio.id;
          jobberg_schema          adelaide    false    207            �            1259    91494    users    TABLE     C  CREATE TABLE jobberg_schema.users (
    id bigint NOT NULL,
    first_name text,
    last_name text,
    phone_number text,
    email text,
    password text,
    is_active boolean DEFAULT true,
    roles text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
 !   DROP TABLE jobberg_schema.users;
       jobberg_schema         heap    adelaide    false    7            �            1259    91502    candidates_id_seq    SEQUENCE     �   CREATE SEQUENCE jobberg_schema.candidates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE jobberg_schema.candidates_id_seq;
       jobberg_schema          adelaide    false    208    7            �           0    0    candidates_id_seq    SEQUENCE OWNED BY     R   ALTER SEQUENCE jobberg_schema.candidates_id_seq OWNED BY jobberg_schema.users.id;
          jobberg_schema          adelaide    false    209            �            1259    90811    chats    TABLE     �   CREATE TABLE jobberg_schema.chats (
    id bigint NOT NULL,
    fk_candidate_id bigint,
    fk_guest_id bigint,
    date_sent timestamp with time zone DEFAULT now(),
    is_read boolean DEFAULT false,
    message text,
    sender bigint
);
 !   DROP TABLE jobberg_schema.chats;
       jobberg_schema         heap    adelaide    false    7            �            1259    90818    chats_id_seq    SEQUENCE     }   CREATE SEQUENCE jobberg_schema.chats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE jobberg_schema.chats_id_seq;
       jobberg_schema          adelaide    false    202    7            �           0    0    chats_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE jobberg_schema.chats_id_seq OWNED BY jobberg_schema.chats.id;
          jobberg_schema          adelaide    false    203            �            1259    90828 
   shortlists    TABLE     �   CREATE TABLE jobberg_schema.shortlists (
    id bigint NOT NULL,
    fk_guest_id bigint,
    fk_candidate_id bigint,
    date timestamp without time zone DEFAULT now()
);
 &   DROP TABLE jobberg_schema.shortlists;
       jobberg_schema         heap    adelaide    false    7            �            1259    90831    shortlists_id_seq    SEQUENCE     �   CREATE SEQUENCE jobberg_schema.shortlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE jobberg_schema.shortlists_id_seq;
       jobberg_schema          adelaide    false    204    7            �           0    0    shortlists_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE jobberg_schema.shortlists_id_seq OWNED BY jobberg_schema.shortlists.id;
          jobberg_schema          adelaide    false    205            ;           2604    91532    candidate_bio id    DEFAULT     �   ALTER TABLE ONLY jobberg_schema.candidate_bio ALTER COLUMN id SET DEFAULT nextval('jobberg_schema.cadidate_docs_id_seq'::regclass);
 G   ALTER TABLE jobberg_schema.candidate_bio ALTER COLUMN id DROP DEFAULT;
       jobberg_schema          adelaide    false    207    206            6           2604    91533    chats id    DEFAULT     t   ALTER TABLE ONLY jobberg_schema.chats ALTER COLUMN id SET DEFAULT nextval('jobberg_schema.chats_id_seq'::regclass);
 ?   ALTER TABLE jobberg_schema.chats ALTER COLUMN id DROP DEFAULT;
       jobberg_schema          adelaide    false    203    202            8           2604    91535    shortlists id    DEFAULT     ~   ALTER TABLE ONLY jobberg_schema.shortlists ALTER COLUMN id SET DEFAULT nextval('jobberg_schema.shortlists_id_seq'::regclass);
 D   ALTER TABLE jobberg_schema.shortlists ALTER COLUMN id DROP DEFAULT;
       jobberg_schema          adelaide    false    205    204            ?           2604    91536    users id    DEFAULT     y   ALTER TABLE ONLY jobberg_schema.users ALTER COLUMN id SET DEFAULT nextval('jobberg_schema.candidates_id_seq'::regclass);
 ?   ALTER TABLE jobberg_schema.users ALTER COLUMN id DROP DEFAULT;
       jobberg_schema          adelaide    false    209    208            �          0    91485    candidate_bio 
   TABLE DATA           �   COPY jobberg_schema.candidate_bio (id, profile_pic, resume, video_resume, certificate, fk_candidate_id, highest_qualification, bio, skills, interests, job_title, experience, province, city, profile_hits, school_name, education, culture) FROM stdin;
    jobberg_schema          adelaide    false    206   �D       �          0    90811    chats 
   TABLE DATA           n   COPY jobberg_schema.chats (id, fk_candidate_id, fk_guest_id, date_sent, is_read, message, sender) FROM stdin;
    jobberg_schema          adelaide    false    202   8W       �          0    90828 
   shortlists 
   TABLE DATA           T   COPY jobberg_schema.shortlists (id, fk_guest_id, fk_candidate_id, date) FROM stdin;
    jobberg_schema          adelaide    false    204   AY       �          0    91494    users 
   TABLE DATA           �   COPY jobberg_schema.users (id, first_name, last_name, phone_number, email, password, is_active, roles, created_at, updated_at) FROM stdin;
    jobberg_schema          adelaide    false    208   /[       �           0    0    cadidate_docs_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('jobberg_schema.cadidate_docs_id_seq', 76, true);
          jobberg_schema          adelaide    false    207            �           0    0    candidates_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('jobberg_schema.candidates_id_seq', 159, true);
          jobberg_schema          adelaide    false    209            �           0    0    chats_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('jobberg_schema.chats_id_seq', 31, true);
          jobberg_schema          adelaide    false    203            �           0    0    shortlists_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('jobberg_schema.shortlists_id_seq', 55, true);
          jobberg_schema          adelaide    false    205            H           2606    91518 !   candidate_bio candidate_docs_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY jobberg_schema.candidate_bio
    ADD CONSTRAINT candidate_docs_pkey PRIMARY KEY (id);
 S   ALTER TABLE ONLY jobberg_schema.candidate_bio DROP CONSTRAINT candidate_docs_pkey;
       jobberg_schema            adelaide    false    206            K           2606    91520    users candidates_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY jobberg_schema.users
    ADD CONSTRAINT candidates_pkey PRIMARY KEY (id);
 G   ALTER TABLE ONLY jobberg_schema.users DROP CONSTRAINT candidates_pkey;
       jobberg_schema            adelaide    false    208            B           2606    90847    chats chats_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY jobberg_schema.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY jobberg_schema.chats DROP CONSTRAINT chats_pkey;
       jobberg_schema            adelaide    false    202            F           2606    90851    shortlists shortlists_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY jobberg_schema.shortlists
    ADD CONSTRAINT shortlists_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY jobberg_schema.shortlists DROP CONSTRAINT shortlists_pkey;
       jobberg_schema            adelaide    false    204            C           1259    90853    fki_foreign_candidate    INDEX     Z   CREATE INDEX fki_foreign_candidate ON jobberg_schema.chats USING btree (fk_candidate_id);
 1   DROP INDEX jobberg_schema.fki_foreign_candidate;
       jobberg_schema            adelaide    false    202            I           1259    91523    fki_foreign_docs    INDEX     ]   CREATE INDEX fki_foreign_docs ON jobberg_schema.candidate_bio USING btree (fk_candidate_id);
 ,   DROP INDEX jobberg_schema.fki_foreign_docs;
       jobberg_schema            adelaide    false    206            D           1259    90855    fki_foreign_guest    INDEX     R   CREATE INDEX fki_foreign_guest ON jobberg_schema.chats USING btree (fk_guest_id);
 -   DROP INDEX jobberg_schema.fki_foreign_guest;
       jobberg_schema            adelaide    false    202            �      x��[�n�8�}V��@cjb����e�``;����t��T:� J�$�H��ˑ��#�`>��d6�ss�dU.]@vl�����koR���u]��驠�$�yCX�E��D��aկNY�z�T9��5\G'Э�<�;oM�U�방xS4�9ɪ�A��n��mõLէ)�v&M��)��Ж8�U����2B�m˖g�tA�EZ���a��lM�IQٳ&��k规G0鲖��3�?餻4��i��f���׌�8GO�/�v�T���%+�%¨�4Q��,)�j�*����D�֘�TH�[�V��y�pI�]�T�(fB�(JYN��SB#�{�j�j��c�*oʄ��e�E���D)/��$Q�
�J*�v��Â����9��������0������1�����I�c=���mۈ�2���9.��1�H�:��AIg*���g���t-�+��S��V�,����#�����M��%zCýtU����"�������[����#+*^q���9_v��H�-����}�����K�G)4Jz���d�D$�ac�1���`�ԏ��#w����sҔ�ʱLG�R^��6�����n,׋��!����b뜅OD�0N��;�f��u٭��3+~z�__�;�<����޾!y|����4���;���	8T���bV?����x���ꉯ�+�mN_���ztM�'s��3�XJpG0	m��)d"�U8�p/�W�q��D�E���գW*�!���G,�S���ܬ��qvM��2�V{_���9Rp�rZ��nhԨ�&8�a.�Gׯ^�.�G���o�a�f�p�.�h� �aR����Q����Ő��RtI��=V��i��1(L�%<8X�������m��;����
7Kxfu�+> Kd���ͅPw&�s��꾿�;�/�L�Yf2_۬i<;���Y�.��E�8�J�!m�q��y�ݻq�r��m�I|j6劇a'�UԸ��͎;�绁uw�:\���E�^gi:�a��5�����Ή�T���� b�!�b�u�j��cF��s�: &E1��q)�}�B �s�������d}�?Pě��ʣoũs��~n��?F/x��Y4®R���A��7T��.pE�甋�j� M����q�C�P.�9�F�PC���0q���ph�6�4{��u�␮�J�e�8�u%���t]���P�v�W��r�Dn����Ѳ��a�ļ ���4�iӂh�����q�C��+�{��p�.x�E8��K^�Fla~�����ipM��(q��Oj���w� ��J�DL��菈2��R����F8Ƃ��<�s@*�V�	�Dv��:���S\����f�
�}�X��6e:��J;#)�0GM���73���;��EQ��χ*��\b��]�E����%�*[$$Yv�.�h��[��+ZV����8�շ�(�&m�(h��[��-E.c
�p<�����>��G�\t�����uAE=AhR������ ���S7�9����+�4��=|z��m��%�Bɦ����L?�l�p���Жٱ��I�v՚�D
<�	:�AS��N��bd�˥�&u�eN�&����@�����n��TAW���@����G��վR�y+n����3e��C�QǴl�t���E`�0�]������,����s���X=�}ާU˓%ky�љ@-�*HI�sa��M�v�ly<(�I�ֲhmN��f��kEF (��
��w\@�|��Vn��D�_;�k�7X�kO�R3��7�0�ǀ�n�q7�;ƃp����|s�G��zqEv����yֿ5S�E������)����
M#�u�]_���f=�r|]�s�c��f�CN��ᢴ��u^�u�>9�e�:���2c�Kڨ���k.��șL[�rzNٲϲ��� B�Z3[�eA�w�rCK�7���(v_l~?���+�G���Ր��Ii	�t�%2Uӂ��A�\��h��M�'��֨�5���������B�؂|��v�T6��$U�t�l`�p ����&��|3f�ӘS�I�[��IRH�C��hհz����_�3�q�u]G5��~���j8\���?T���.�� ylrh�~�r71Ա� �@s��kV7G=XF���l��EÂ&�*���,G[�uB�%U�^ҪF	�����T�&�� $/O��T�
I܏War�#	dV��m��%�OS�MZ���w�p3ߙ�g%�hTUUڜ�r�	�ETlj�������
%/a�h���S���w�F�����0�j�kV�v\���7�qA�'z��B	]�?� '�AA~	��d�Ԁ��a�;N�v��}��
�L�=.@
��o[����]ܐ�YU囜���}��?Ү���9.�]��OÜ/Zܽhq̇��u/�ПF�����}bS�������M��?�1��[����-��� c'c`��l	Q.ʈ`=Y��\3�v�2n3Zw��3#-�2iq��@Ǝ��ע=�*�a��s��%�Q���:�)Oeʽ��T�0���)�h)��j �����)#�����S�����	��Z`�s{`ToK .+C��B�נωD�6h(N+Հr*�H�}��.��v���� ��#i��S�>���BR�2��:��h�l�T�W�J`A��,R�y.O�R�y�r3>��p�d�U�� �C3ҧ�#����ܳ���+���.Ti���a����H�G��Z��D�yXV)�m��/�(���N@�Ob��W?@:�7�>�Ӑ�%vqt�սv�ޭ�n	)Ǻ�|����n�4ZޱK�u4��:�eދvY���$m&}���%L_�����w�$I���ʬW��(��7۝�(�@F�tc�V��yC��|���� ��I:T���#�`����[N�͗�o�������r�At �Okv9&-��ϯh�hI�\�V�v`v�9[Q1���٣y���\��C�/{uK5��CSV�ܟ��6���u�5���<�l˔7(�}���Ǔ`��0Q5���ƻ�Ѭ1Z`{��o�{�c����'���.��drm˷w�F��fd]gb��U�M��J&׶{W��C;x�[H�dҮ�K�i�{Rth!zb�����{ێ;�L�k��_��2ӏf��B�3���������K!�{��8�������������]��F����"XJ��l7q���[�t�e�����yB���n�t2�l�������S?�"�D
�2A��g.GӇg.�uaG1�xG�.k�Cb���u��x��-oP��Ĥ�����m�|�ǛA�Y��^߼B�s�|���Bn[����� oF�Yͩ�sb
tF ���]��5U�B�3�ǻ��<y�=W8ֽ�At&T*�=�#�oX��YƗ;1�p���v�bخOM�i)i����|[mt�X�$�w)a�2�B�ԴY�3՛�l��,p��H�25"�g�l�������Ua�lY��q: �0��yf��u�K�?ˎ��{����oB�xPo�s��_�<�	����#{�L."�I��8���N�dO�TwNM���NC�-K���K����lW�oD�IU�;dd؁��_�H�·�zGY�I�r۹��F����=tq��+S�������CF�I �{Y�e^Ѻ�ݰdՀJ?S��;M?}m~��I!'x�v�o���V`-"=�<l�1��O#��ۄI��ͳf':��p���DZ�k��΋xӦ��K#4:�0\�r�>�d��yq�4E0�*$��&�I�kJ�C��EZ��o$uۯA|:���r�m����0	���]��]��Tm��g\����x���yAU��Ωj���S"-gx����rL���(p�d�/c���)����_g
/���F�֌`�s^�y������b�5�T�n�<踮��ۃ��t�lK)Zn3VĞ}�L{����͵�GCB"�w�1�<�m��t6�C)q����F4m�$�Q�I��a)�m����+�MIR�-QH�;�C���ӗ����c?(�7C��wMk�l�؅��6?�� [  ˵O̴"�_�j�����
��f��"�۳�����v(Q�(��"MZ�u�^��,�O����<���EUyS��ŷ2}k��V�S�+F�Xd�*0�ķy���W���?�d}u{#�v��gO7b�q��9{���b��Wq6�8�xO��m}L���LT��?�K$j�T1%Gզ�����3�f�M�.��1��Ԁ_>�C�m��U�y��y���l�3��Q\c��ԩ�5�c�����KSa���[˄d�+2�3c��8��.#�4���S\5k3�Pw;郗���e�%a�W8*LOŘ{�^����V�kY5�N��|�U��V���HV�:�眫2my%w�6DS�ۓ-�T8���{�e�����oߛ���*��4��r�����N`x�����!�"%���W��CV�z��͛8�¢L�"�;�n3��5׶��ڈ�k&;˲sH��D�L��N=��@��/W��$�Vv	N�?��9Hx峉�Ym�h�Z�YY��ԣo� �[p�R�C����������w_��%��:?;<��
<B���L1����&`��G�a�����cwj������|s����!�����Fֻ�G����w�      �   �  x���Ko�0 ��+��ZA|�u�a�Ӏ�{	,h�"�e�I��$���H�������[m�����7�9�G�~���LK{�Z;�x���1�#��Z#�'b����������% ��(䘉����߯�]o	��a�0	*I�(�҄ڶ.�+@�UQ(#x:]��@���5P֠�e��Կ����A����G����V%d�R�tB��P�:0
�T*X(��`� 4pIPh.��8�҅�A�Js�����ѹ�� �^�� ����S�׷��3�r�d)o9]pY�ø�J� p�-�����lS;��B�L-
f�G���A�t�q�1��r��{�W���(D;"�?J�%�X%���^��
ϣ��XI�6g�Ӆ���<��U�|3�he�P�a��O#��b&�9hs��]�d����=�mg��Y,����G�lVBV��:ͣ6�mgGq�P2�jM�Z$�P�1�Xn�Es<�H�{]��4�B}      �   �  x�u��m�@E�bn ���
��H6bK
��>�G�i��7F�/�/��D��#=Qx�+`��4���ð���*��8نX�%�= :�*P�ƣ�Xb�`�!��K�S}�S1q������w�ibM�Q�n@�3Dv��VWRT��b?Q�Ga�Tg�Aə�TC�ue�����@�)1Ѭ���O�Ę܆Ъ�#��d�]
�P�C�����Ү){8���Ѣ����l�]��]Ëj�,��/�큻v����L��>�p�h���@2Y�L������5s�?����Z�	e�}6�\������p�����|٭�c���gR�G$ݺZr����g���a��u*�S}�&! �����$�٠^t2�2Z��?��ږ�`� ����|�sf��>��F���cX��,g[O��.���ۃ����=�IL����˱^�љZ���C:�J���p��"��p~ �a�!      �   �	  x��X�v�J\����sKU%�C���28w#@H=@@|�������1��Ȭ��H���a"�A�'�+A�b�*!)�$�[��9A�I$������^�z��V������YGO�n���5YײI���Z��t�4	���?�R.��2-��M%1��#�i�(�ĸ�п �����
�����r����tw��#����H�aE��#MZ��K|�D���Z���U7Ns�.�m��W�ֲ���B6��N��yo�Ϛ}�M��{(�������_��
�p�x�K}7u��E2�s-	3�j�h�#�y�l�w����ƈ��x�����T�h{�ն�6��.ύ�J�Ꝍ6H�´���㊪TT0D� O�����T0GLӮ�E\����]���p�%��� t_C�CO����c�ݤ�������'�he��{`�E���? }A�a��k���0�^$��_^`Ql���"�/e��(���}���;�
H�	J��@�o���l�3vb��rd�,��V����f��O�W+*��P{�A�4pr߉7l�0��3@5�CH��W6zO~}H��@�:�o�NA�ܤ�K�8�ْ;]8F�Y��n��i��5`zA)�P4�BA�O%<H�
)�$\	�E �#�jT���ܳ����7���Tlׯ�s��54����4�A�*��wv���j�j���%�PE��A��
b@4V��'O��ub�E�@�V���T���.�qD��z���K�'_/&�j���n۫v�Ѯ'O&�9[%-����Z�� (��|m�פh6�,7=�4sE.��a�0F5iw�����M[<��$p'��Y�K��3����HGa�N�G8=�6����*Bi(ZI�3}V�;=n}f�2��Om~����6cwӅ�Ro]M�g���]v��p0AּY���.����G�o��_�`R�@��O��T�K��,��+$A��O���$|'M7'�wr��	�y�n��y�{r�{D'o\L�}�(ף`]v꣄��S�1t��)שb� yJS�T]]�dd�P$6*+U�w���3���{A�E�����0��nf�Z@�sZ�"�Wf-|�mӷ]=Ыo�m��b8��}Q>�8��� �5!�
x���R?IS'�]���n�	A���'&�^x���e3ӭ-�{��@����=ԛ�浃�r_�c���<��y�
S�"B��3�!P�9y�z�d$M�S��0ދ�e-���֢涒� }����ȧ'��+�L�~�h�i0<�=�j�ǖ�&!H���)_p?ʊ���]�o;��*����f�Q���z�e̱��TY��ͷi�l�Zl���AV�C�b����v$�;�H���-�/Kc�0��O��*5��? 3��Bi�p;R��{��8���d�i�i�^񘶻�y�U��rb�Թ�~��*�̖�f��@RQ��gQ�����*�Љ�0�c���ǎ��<���6o�==J��,Y�j��Is7�{�h_�Y��ЯvƲ����}a3�h���|�Ǐ����=_�m	5pȁ1����8(��,�접n�p�؂m�W���Ɩ����W*��J*��`�s�e���J��?����-]�A��&f�����.s����}��p[�>���烑:�+���6��1���!l;�陶_.�E≎K���z���K�`H5����0X�������/�}�����g�&�f,h�Ce?̱[+<��Е��[�n��,�v&�܋�*nV� ����(+�+�����#)�����Aӓ�����w��þ�ڤ�`j���;��N������aS��-����ٻ�\���q�
����˫@�M����MQP�R��?����>���d	�شv˳���b�ƭ�T�r�vq��g�C��N��CF[���� T��\T�2L��0���kb��
n��� �Y��F�Cͮ���X\��E�H�3-�[��jG�w��Z{���-B0�]nl	���*�Q|~{(���]�~�Q���+F,x�>���T�L���f~"�3��[ �|����̊�y�gy3��iu��;����q���S�\n��^�M#�����e� W��@��KV�վ�U
�3�Q����}6�G����Y�s��c�>��;N�F��䉌��5��i��Ѭ�b<�/{��@��1IT?^?�d�d_���'��si�+�'������eE��y#wi��>�ʲL�!�k����4?Ƶ��IK���<qyyZw� A����<��V3N����'��sC������1S�U��&=2��W��e��m�j�6�c�,l�)�N]�I�����q�?]��E�N�~h�+Lʓ(�G���u���]�L�H�~ȟ:z>j]��)��j];7e�֝��o���l��,�#J=�����*���Y�W7�İ#��C	�c',�3S�;���?�Lb�*     