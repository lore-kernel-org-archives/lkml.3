Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbaLBRwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:52:17 -0500
Received: from libra.uberspace.de ([95.143.172.171]:49948 "EHLO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaLBRwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:52:13 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 12:52:13 EST
Date: Tue, 2 Dec 2014 18:39:57 +0100
From: Matthias Beyer <mail@beyermatthias.de>
To: Pieter Waegeman <pieter@1ago.be>
Cc: klmckinney1@gmail.com, gregkh@linuxfoundation.org,
        tapaswenipathak@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: Fix tab between spaces in
 InterfaceMacros.h This is a patch to the InterfaceMacros.h file that fixes
 an added tab instead of a space. Found by the checkpatch.pl tool.
Message-ID: <20141202173957.GJ2314@fu.hfu-open.fu.hs-furtwangen.de>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <1417541149-18697-1-git-send-email-pieter@1ago.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NGIwU0kFl1Z1A3An"
Content-Disposition: inline
In-Reply-To: <1417541149-18697-1-git-send-email-pieter@1ago.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NGIwU0kFl1Z1A3An
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pieter,

as far as I know, this driver was removed from the source tree. Please
update your local copy of the kernel.

--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

On 02-12-2014 18:25:49, Pieter Waegeman wrote:
> ---
>  drivers/staging/bcm/InterfaceMacros.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/staging/bcm/InterfaceMacros.h b/drivers/staging/bcm/=
InterfaceMacros.h
> index fedb794..67e7b62 100644
> --- a/drivers/staging/bcm/InterfaceMacros.h
> +++ b/drivers/staging/bcm/InterfaceMacros.h
> @@ -4,7 +4,7 @@
>  #define BCM_USB_MAX_READ_LENGTH 2048
> =20
>  #define MAXIMUM_USB_TCB      128
> -#define MAXIMUM_USB_RCB 	 128
> +#define MAXIMUM_USB_RCB	     128
> =20
>  #define MAX_BUFFERS_PER_QUEUE   256
> =20
> --=20
> 2.1.0
>=20

--NGIwU0kFl1Z1A3An
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUffltAAoJEJi+S08gyg+Uo7oP/2O6IVq3PJ9juQiRVvV0NQyo
ZFbg1pjSk3DkBd1oDCWlkpm0IJD9Wrzr3vmKLJJAYpqNt4v2zY1lY0sA7/Jbnze6
MSDVmLiiq37dqCdDsxiZD/V3MyDQTHbCUljdlrcrzyys0vfbkTyq3xRXmirrgyVU
HGpl2vBpX8Jz6k1y8Hc1AhTXhyQMhhnskM6NHzd31Qldi7mQrky8tsJEs+7r04wm
38pHxgbRRcyKn1TqVEjMVNM1m73a4eogHelBda1Sp944un77v5GHhJK0fhARN4Io
tD/A+QhNbkkXvRLhajJb/+6TB2GXzHjQ2ibTknk61GgbpyM4LqkY9jFIPh8eGiJ+
aNDdnX1DD+kr9r3vxKu2QMHp6F5nx2bUtqCrJjovXtiNLe2fEm8swPfvnREE5Pff
eVIkqLRFbrHkP8WyEo5OVyWUGMzYoFYhgAa/hBip1FiLfd7ZAs3d29wwN6u93N1L
B1eUCrYnkvzfcs4QyUvIeeZ4nbAwn0cRLQwkaOII6JPTccjNJmGq3gt3gWSqkVoH
DIJByl7z3iLqvflehDEVhYpU/BvDQBnsAsmbVrsIwU2mqKux0QQq+VkjnRP7cLZe
hoJFBdCZ66B6TWiJV1qJ00AkKHjH+UUM5h65IOLjT20OBb8CjeU0fxB+fRFJGht7
iowPahSMafGMroDy8Bjh
=Aqv+
-----END PGP SIGNATURE-----

--NGIwU0kFl1Z1A3An--
