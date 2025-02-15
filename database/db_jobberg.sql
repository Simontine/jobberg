PGDMP     )                    z         
   db_jobberg    14.1    14.1 1    Q           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            R           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            S           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            T           1262    16672 
   db_jobberg    DATABASE     U   CREATE DATABASE db_jobberg WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C';
    DROP DATABASE db_jobberg;
                postgres    false                        2615    16673    jobberg_schema    SCHEMA        CREATE SCHEMA jobberg_schema;
    DROP SCHEMA jobberg_schema;
                admin    false                        3079    16674    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            U           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2                       1255    16711    fn_admin_login(text, text)    FUNCTION     �  CREATE FUNCTION jobberg_schema.fn_admin_login(_email text, _password text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE

 admin_id bigint;
 
 BEGIN
 
  SELECT _admin.id into admin_id  FROM 
     jobberg_schema.admin _admin
  where _admin.is_active = true and 
  (_admin.email = _email and _admin.password = crypt(_password, _admin.password));
 
 if admin_id is not null 
 then 
 return admin_id;
 
 else 
 
 return 0;
 
 end if;
 
END;
$$;
 J   DROP FUNCTION jobberg_schema.fn_admin_login(_email text, _password text);
       jobberg_schema          admin    false    7                       1255    16712    fn_candidate_login(text, text)    FUNCTION     �  CREATE FUNCTION jobberg_schema.fn_candidate_login(_email text, _password text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE

 candi_id bigint;
 
 BEGIN
 
  SELECT _candidate.id into candi_id  FROM 
     jobberg_schema.candidate _candidate
  where _candidate.is_active = true and 
  (_candidate.email = _email and _candidate.password = crypt(_password, _candidate.password));
 
 if candi_id is not null 
 then 
 return candi_id;
 
 else 
 
 return 0;
 
 end if;
 
END;
$$;
 N   DROP FUNCTION jobberg_schema.fn_candidate_login(_email text, _password text);
       jobberg_schema          admin    false    7                       1255    16713    fn_get_all_candidates()    FUNCTION     �  CREATE FUNCTION jobberg_schema.fn_get_all_candidates() RETURNS TABLE(id bigint, first_name text, last_name text, phone_number text, email text, profile_hits integer, bio text, skills text, interests text, qualifications text, experience text, province text, city text, profile_pic text, resume text, video_resume text, certificate text)
    LANGUAGE plpgsql
    AS $$
DECLARE  
 
 BEGIN
   
 return query SELECT
 
   sc.id,
   sc.first_name,
   sc.last_name,
   sc.phone_number,
   sc.email,
   sc.profile_hits,
   sb.bio,
   sb.skills,
   sb.interests,
   sb.qualifications,
   sb.experience,
   sb.province,
   sb.city,
   sd.profile_pic,
   sd.resume,
   sd.video_resume,
   sd.certificate
   
   
   FROM "jobberg_schema".candidate sc
    left join "jobberg_schema".candidate_bio sb on
	sc.id = sb.fk_candidate_id
    left join "jobberg_schema".candidate_docs sd on
    sc.id = sd.fk_candidate_id
   WHERE sc.is_active is TRUE;
   
END;
$$;
 6   DROP FUNCTION jobberg_schema.fn_get_all_candidates();
       jobberg_schema          admin    false    7                       1255    16714    fn_guest_login(text, text)    FUNCTION     �  CREATE FUNCTION jobberg_schema.fn_guest_login(_email text, _password text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE

 guest_id bigint;
 
 BEGIN
 
  SELECT _guest.id into guest_id  FROM 
     jobberg_schema.guest _guest
  where _guest.is_active = true and
  (_guest.email = _email and _guest.password = crypt(_password, _guest.password));
 
 if guest_id is not null
 then 
 return guest_id;
 
 else 
 
 return 0;
 
 end if;
 
END;
$$;
 J   DROP FUNCTION jobberg_schema.fn_guest_login(_email text, _password text);
       jobberg_schema          admin    false    7            �            1259    16721    candidate_bio    TABLE     �  CREATE TABLE jobberg_schema.candidate_bio (
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
    qualifications text,
    experience text,
    province text,
    city text
);
 )   DROP TABLE jobberg_schema.candidate_bio;
       jobberg_schema         heap    admin    false    7            �            1259    16726    cadidate_docs_id_seq    SEQUENCE     �   CREATE SEQUENCE jobberg_schema.cadidate_docs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE jobberg_schema.cadidate_docs_id_seq;
       jobberg_schema          admin    false    211    7            V           0    0    cadidate_docs_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE jobberg_schema.cadidate_docs_id_seq OWNED BY jobberg_schema.candidate_bio.id;
          jobberg_schema          admin    false    212            �            1259    16727    users    TABLE       CREATE TABLE jobberg_schema.users (
    id bigint NOT NULL,
    first_name text,
    last_name text,
    phone_number text,
    email text,
    password text,
    is_active boolean DEFAULT true,
    roles text,
    created_date timestamp with time zone DEFAULT now()
);
 !   DROP TABLE jobberg_schema.users;
       jobberg_schema         heap    admin    false    7            �            1259    16738    candidates_id_seq    SEQUENCE     �   CREATE SEQUENCE jobberg_schema.candidates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE jobberg_schema.candidates_id_seq;
       jobberg_schema          admin    false    213    7            W           0    0    candidates_id_seq    SEQUENCE OWNED BY     R   ALTER SEQUENCE jobberg_schema.candidates_id_seq OWNED BY jobberg_schema.users.id;
          jobberg_schema          admin    false    214            �            1259    16739    chats    TABLE     �   CREATE TABLE jobberg_schema.chats (
    id bigint NOT NULL,
    fk_candidate_id bigint,
    fk_guest_id bigint,
    date_sent timestamp with time zone,
    is_read boolean DEFAULT false,
    message text,
    sender bigint
);
 !   DROP TABLE jobberg_schema.chats;
       jobberg_schema         heap    admin    false    7            �            1259    16745    chats_id_seq    SEQUENCE     }   CREATE SEQUENCE jobberg_schema.chats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE jobberg_schema.chats_id_seq;
       jobberg_schema          admin    false    7    215            X           0    0    chats_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE jobberg_schema.chats_id_seq OWNED BY jobberg_schema.chats.id;
          jobberg_schema          admin    false    216            �            1259    16746    guest    TABLE     �   CREATE TABLE jobberg_schema.guest (
    id bigint NOT NULL,
    first_name text,
    last_name text,
    email text,
    password text,
    is_active boolean
);
 !   DROP TABLE jobberg_schema.guest;
       jobberg_schema         heap    admin    false    7            �            1259    16751    guest_id_seq    SEQUENCE     }   CREATE SEQUENCE jobberg_schema.guest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE jobberg_schema.guest_id_seq;
       jobberg_schema          admin    false    217    7            Y           0    0    guest_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE jobberg_schema.guest_id_seq OWNED BY jobberg_schema.guest.id;
          jobberg_schema          admin    false    218            �            1259    16752 
   shortlists    TABLE     �   CREATE TABLE jobberg_schema.shortlists (
    id bigint NOT NULL,
    fk_guest_id bigint,
    fk_candidate_id bigint,
    date timestamp without time zone
);
 &   DROP TABLE jobberg_schema.shortlists;
       jobberg_schema         heap    admin    false    7            �            1259    16755    shortlists_id_seq    SEQUENCE     �   CREATE SEQUENCE jobberg_schema.shortlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE jobberg_schema.shortlists_id_seq;
       jobberg_schema          admin    false    7    219            Z           0    0    shortlists_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE jobberg_schema.shortlists_id_seq OWNED BY jobberg_schema.shortlists.id;
          jobberg_schema          admin    false    220            �           2604    16759    candidate_bio id    DEFAULT     �   ALTER TABLE ONLY jobberg_schema.candidate_bio ALTER COLUMN id SET DEFAULT nextval('jobberg_schema.cadidate_docs_id_seq'::regclass);
 G   ALTER TABLE jobberg_schema.candidate_bio ALTER COLUMN id DROP DEFAULT;
       jobberg_schema          admin    false    212    211            �           2604    16760    chats id    DEFAULT     t   ALTER TABLE ONLY jobberg_schema.chats ALTER COLUMN id SET DEFAULT nextval('jobberg_schema.chats_id_seq'::regclass);
 ?   ALTER TABLE jobberg_schema.chats ALTER COLUMN id DROP DEFAULT;
       jobberg_schema          admin    false    216    215            �           2604    16761    guest id    DEFAULT     t   ALTER TABLE ONLY jobberg_schema.guest ALTER COLUMN id SET DEFAULT nextval('jobberg_schema.guest_id_seq'::regclass);
 ?   ALTER TABLE jobberg_schema.guest ALTER COLUMN id DROP DEFAULT;
       jobberg_schema          admin    false    218    217            �           2604    16762    shortlists id    DEFAULT     ~   ALTER TABLE ONLY jobberg_schema.shortlists ALTER COLUMN id SET DEFAULT nextval('jobberg_schema.shortlists_id_seq'::regclass);
 D   ALTER TABLE jobberg_schema.shortlists ALTER COLUMN id DROP DEFAULT;
       jobberg_schema          admin    false    220    219            �           2604    16757    users id    DEFAULT     y   ALTER TABLE ONLY jobberg_schema.users ALTER COLUMN id SET DEFAULT nextval('jobberg_schema.candidates_id_seq'::regclass);
 ?   ALTER TABLE jobberg_schema.users ALTER COLUMN id DROP DEFAULT;
       jobberg_schema          admin    false    214    213            E          0    16721    candidate_bio 
   TABLE DATA           �   COPY jobberg_schema.candidate_bio (id, profile_pic, resume, video_resume, certificate, fk_candidate_id, highest_qualification, bio, skills, interests, qualifications, experience, province, city) FROM stdin;
    jobberg_schema          admin    false    211   �?       I          0    16739    chats 
   TABLE DATA           n   COPY jobberg_schema.chats (id, fk_candidate_id, fk_guest_id, date_sent, is_read, message, sender) FROM stdin;
    jobberg_schema          admin    false    215   ]C       K          0    16746    guest 
   TABLE DATA           ^   COPY jobberg_schema.guest (id, first_name, last_name, email, password, is_active) FROM stdin;
    jobberg_schema          admin    false    217   �C       M          0    16752 
   shortlists 
   TABLE DATA           T   COPY jobberg_schema.shortlists (id, fk_guest_id, fk_candidate_id, date) FROM stdin;
    jobberg_schema          admin    false    219   �C       G          0    16727    users 
   TABLE DATA           �   COPY jobberg_schema.users (id, first_name, last_name, phone_number, email, password, is_active, roles, created_date) FROM stdin;
    jobberg_schema          admin    false    213   �C       [           0    0    cadidate_docs_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('jobberg_schema.cadidate_docs_id_seq', 53, true);
          jobberg_schema          admin    false    212            \           0    0    candidates_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('jobberg_schema.candidates_id_seq', 121, true);
          jobberg_schema          admin    false    214            ]           0    0    chats_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('jobberg_schema.chats_id_seq', 3, true);
          jobberg_schema          admin    false    216            ^           0    0    guest_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('jobberg_schema.guest_id_seq', 1, false);
          jobberg_schema          admin    false    218            _           0    0    shortlists_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('jobberg_schema.shortlists_id_seq', 1, false);
          jobberg_schema          admin    false    220            �           2606    16766 !   candidate_bio candidate_docs_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY jobberg_schema.candidate_bio
    ADD CONSTRAINT candidate_docs_pkey PRIMARY KEY (id);
 S   ALTER TABLE ONLY jobberg_schema.candidate_bio DROP CONSTRAINT candidate_docs_pkey;
       jobberg_schema            admin    false    211            �           2606    16770    users candidates_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY jobberg_schema.users
    ADD CONSTRAINT candidates_pkey PRIMARY KEY (id);
 G   ALTER TABLE ONLY jobberg_schema.users DROP CONSTRAINT candidates_pkey;
       jobberg_schema            admin    false    213            �           2606    16772    chats chats_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY jobberg_schema.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY jobberg_schema.chats DROP CONSTRAINT chats_pkey;
       jobberg_schema            admin    false    215            �           2606    16774    guest guest_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY jobberg_schema.guest
    ADD CONSTRAINT guest_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY jobberg_schema.guest DROP CONSTRAINT guest_pkey;
       jobberg_schema            admin    false    217            �           2606    16776    shortlists shortlists_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY jobberg_schema.shortlists
    ADD CONSTRAINT shortlists_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY jobberg_schema.shortlists DROP CONSTRAINT shortlists_pkey;
       jobberg_schema            admin    false    219            �           1259    16778    fki_foreign_candidate    INDEX     Z   CREATE INDEX fki_foreign_candidate ON jobberg_schema.chats USING btree (fk_candidate_id);
 1   DROP INDEX jobberg_schema.fki_foreign_candidate;
       jobberg_schema            admin    false    215            �           1259    16779    fki_foreign_docs    INDEX     ]   CREATE INDEX fki_foreign_docs ON jobberg_schema.candidate_bio USING btree (fk_candidate_id);
 ,   DROP INDEX jobberg_schema.fki_foreign_docs;
       jobberg_schema            admin    false    211            �           1259    16780    fki_foreign_guest    INDEX     R   CREATE INDEX fki_foreign_guest ON jobberg_schema.chats USING btree (fk_guest_id);
 -   DROP INDEX jobberg_schema.fki_foreign_guest;
       jobberg_schema            admin    false    215            E   �  x��T�n�F>�O1���_Q� (�"h}�뢇\#rI.E�P�KR���K^ �'�,�(R�s�!����7�}���Eemg^A�+�����g�]E��8�VA�*��`ylT;��T�Fx��l����Y&i�G�C�S圔sja���>�
�)m�	i��ih��k�`��d��6�u����0�^K������1f;��S�A�>ϼ9m���� w�:�s-�|����vɋA�� ��A+k��v̧����U���.�h�x��2�C&����Њ������*��H�7gR�:�[�4G
IM���HI��nWK1�Cf���@&�"R���H�H��T�M2I�2=.LJ��Ic. ����$��.�$?~b�
P�p�({�������4b$�w�Pp#��k���nY�P�,�7i}�#���\k��4��㟷�H+��;����J�����@���Em+���U��皕�IU������,��z�^Z�;�� [���0+�u.�(W���{�[�\y����N��1�30��͵l��}.��Q�ct3��ɸ����=o�U�Q6���$'#��,��H}�e�:�)~��Q�y����x��ܶ���W+nS�y:w4��#?�b����`	F�;@ׯ9i�l��E���P��=5��S\�r�a>=���Lgn���-s�簖�y`��ON�<;v�wl��;/#ey�Ϻ7�n�(X$z�2-F�f�Q�M��B<��k�ģT��+�_Gi~��E6��	_v��d�N�V!�:�������z����*�$Y%�����/Vx\�cS��[�	�'���8*p��1�S�#[�z�3)�a��Z�"��/ 䒓�8���}Xsr���Pg�������5�����/�ua�      I   <   x�3�4�4���L���/WH,JU��/�4�2�4JA$Rsr�B�0�ΌLNC�=... �:      K      x������ � �      M      x������ � �      G   �  x�}��r�0�x�9�65F�aN�vbp�@��E��7�,��C���9��>�W����,XLAb��#� ,+�Fj:�j&�ڃ���f��f	x���/�ڜE[�`*�nu����U�^gE�d�3�D�N�<���n�ȩ�V�`��/��B���U��I��k?!� �N�8�aV:�y�ƭ�H3rca1�l�W_q:�H8���mN}Q7�<�r�_G՞�"����uU���}�t�: �����mz�e�W�S�{�٢E�5l{u7~7��p���bq�P�,kٍ�%,��`��pB��p�al'�\Mfg��(�e��#'�=�׎��Z���p��i����x{�\��f!��Q��̛#+�۵]�q��c�]п�Q��$�P֯"�V�E�&����V~$M��JX���VW���{�F꿯mmUm�x��::#���3��d�H�J�$(�:V>M����u���(��#�$�=�-�ҲAU��bw'�ךǡ�0�G��LY��d�g	��P]AD�'����``��t�GPXh��5��e�DVhj"�Z��m�6�V����[��`���F��I��V�X��D)7�
\겘�߁���{1����<#��Ь�^7����%''���m&�:\���q���s���L�:�IjA���H�J�h`d     