Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbaGYCX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 22:23:26 -0400
Received: from ozlabs.org ([103.22.144.67]:39062 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022AbaGYCXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 22:23:25 -0400
Date: Fri, 25 Jul 2014 12:23:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20140725122317.4f96c131@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fmNidk6n=By4cXhtBMYjdoO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fmNidk6n=By4cXhtBMYjdoO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64 allmodconf=
ig)
failed like this:

drivers/hid/hid-picolcd_cir.c: In function 'picolcd_init_cir':
drivers/hid/hid-picolcd_cir.c:117:6: error: 'struct rc_dev' has no member n=
amed 'allowed_protos'
  rdev->allowed_protos   =3D RC_BIT_ALL;
      ^

Caused by commit 0dd0e92836cc ("[media] rc-core: remove protocol arrays").

I have used the v4l-dvb tree from next-20410724 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/fmNidk6n=By4cXhtBMYjdoO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0b+aAAoJEMDTa8Ir7ZwVxcUQAI5ZlB/lcf55VdRdFyqFtRWZ
EvBwbCF4CdTXdA1BrU7uoli+FB+c29gbVkPqAIXbgD8143WOt+tIe2B3/bBlrnVz
Dhu3Gsmmx+KIbsHaClhATFDz7dg6ZrkUi9mkUmOeTgZpIWlWI5yqAOshxR0Fd3XY
T8Jk7oh1OSagdUY/M+KrD/dyQTFqUGGRRSEnt7puruHSsbUKi8v/JRxr1ug0ar9G
y/39bSQldQHebhSpTWgylcz+QRfMSrz3Qv5lUs0GuF8DoOxhosaxED5bX5sjDFfX
FEZ4mormihHITKK4WZQjyXKoUDxeZ4wRxicKQCoL2Uzml1ET7Ls9VJw11TB7OXot
FrcUABPRA1OgGH0cY/TPlEvOuJiAgEihMT8LiVBLQ8gLM5EL5l4WNWP7zjDKwuvw
WxO2bA4ksFAwAEg0iBmt7b7Dhn+U7G1JFK7kG1W63UmolhDWXyVzPHbF3GbjdSEt
gint4x4mfnIDsmK8hSsRTdwuSBeLi6SRg7jt3JM6xPpBkvBLI07qSKW6UNAp/FxE
UhV6BsEy4hAcKTqq+CBbFEEYe74X9B4apMtml902yH+db4QAlSWR8H4f04MWT5nU
qOHSD3DgKgQtqVKM8TaVXxXnm4JQv5gRpYAmMxVG2BxQNlb7cknByt9cqZERRFNo
y1H9d9eav7LFrw8vhZvO
=/x6h
-----END PGP SIGNATURE-----

--Sig_/fmNidk6n=By4cXhtBMYjdoO--
