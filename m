Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3AUEaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 23:30:07 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56345 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3AUEaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 23:30:05 -0500
Date: Mon, 21 Jan 2013 15:30:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: linux-next: manual merge of the security tree with Linus' tree
Message-Id: <20130121153002.1f7f9ff1b46532a44704c6c0@canb.auug.org.au>
In-Reply-To: <1358737823.2406.114.camel@falcor1.watson.ibm.com>
References: <20130121131230.9f79cf5dcd8a8ac069594111@canb.auug.org.au>
	<1358737823.2406.114.camel@falcor1.watson.ibm.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Jan_2013_15_30_02_+1100_AFUr0FgtZ6+bHhP5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jan_2013_15_30_02_+1100_AFUr0FgtZ6+bHhP5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mimi,

On Sun, 20 Jan 2013 22:10:23 -0500 Mimi Zohar <zohar@linux.vnet.ibm.com> wr=
ote:
>
> Sorry Stephen, the merged result should look like what's contained in
> linux-integrity/next-upstreamed-patches:
>=20
> int ima_module_check(struct file *file)
> {
>         if (!file) {
>                 if ((ima_appraise & IMA_APPRAISE_MODULES) &&
>                     (ima_appraise & IMA_APPRAISE_ENFORCE)) {
> #ifndef CONFIG_MODULE_SIG_FORCE
>                         return -EACCES; /* INTEGRITY_UNKNOWN */
> #endif
>                 }
>                 return 0;
>         }
>         return process_measurement(file, file->f_dentry->d_name.name,
>                                    MAY_EXEC, MODULE_CHECK);
> }

OK, I will use that version tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_Jan_2013_15_30_02_+1100_AFUr0FgtZ6+bHhP5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/MRKAAoJEECxmPOUX5FEm5MP/06LXDCg/Wx5zkVC7boA2eNa
AlJazRx0YEiE4WSFumrAkkUfKgxkZvHNhGVstdteIeYDc9X+8QSS3v73U5oWLoF4
5Uc4OJF/2JiR/UBwjcu5OppF6lCYt8Z2qWjylYLZdJJdmrShro3kzFH20Te2L+PR
5KJgfGLshX6GAC1MKIbx8c8nmeVHs8hj0O/PVM052RWupXqjRF7MPRSWhaXT5nnq
AC6buaUJD0upvryFj9ovavVufmAa5KaoCwfXjvsCL9zwZRd3rJt7CYsZOL6lnnbB
1N6FrEUOMLpKnz3c4sJ+3mrkuZ9JbuEetO2HoPwdRqoLODG31oQx5GwCT8J0ds5q
k8+VStBMURP65o2SjjmFqjRs4T3C2K/Ht62Ylh0nPJHsOlmKBJ//EPEacCniHiLY
AGtc2bGUqH+/MwF9ovZXtP+6MT4xTqVfmHrBHpzQE8dsIImJp7TSrFXE5/aoR6uv
2z/2D0H/7wKd7zHyxGoX9JUaLDgxAx4aQkug6jKnwM7AdLj5FVfmf2fwf1rHIz6W
arhVefaWvOqMyvyi1zcEMQWwFwUV/hXQOxkYXmBph/62ArsJ1qLbySJiT5Im8dR6
af6zu1srBP9VF0NxHdFuF8Gp+2UuuqksejmVbUB2BDPtxspPU4nJLr1Wpb2BDd9y
I66keKXx25mJihbgoUpT
=fDbT
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jan_2013_15_30_02_+1100_AFUr0FgtZ6+bHhP5--
