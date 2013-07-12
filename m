Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3GLDgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 23:36:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51850 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756475Ab3GLDgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 23:36:08 -0400
Message-ID: <1373600160.24446.74.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 6/8] MAINTAINERS: add stable_kernel_rules.txt to stable
 maintainer information
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 12 Jul 2013 04:36:00 +0100
In-Reply-To: <20130711221931.994089526@linuxfoundation.org>
References: <20130711221931.216612791@linuxfoundation.org>
	 <20130711221931.994089526@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cNseQr3fHcu0iDSMfz0L"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cNseQr3fHcu0iDSMfz0L
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-07-11 at 15:20 -0700, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> commit 7b175c46720f8e6b92801bb634c93d1016f80c62 upstream.
>=20
> This hopefully will help point developers to the proper way that patches
> should be submitted for inclusion in the stable kernel releases.
>=20
> Reported-by: David Howells <dhowells@redhat.com>
> Acked-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  MAINTAINERS |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5725,6 +5725,7 @@ P:	Vincent Sanders <vince@simtec.co.uk>
>  M:	Simtec Linux Team <linux@simtec.co.uk>
>  W:	http://www.simtec.co.uk/products/EB110ATX/
>  S:	Supported
> +F:	Documentation/stable_kernel_rules.txt

You've applied this in the wrong place for some reason.

Ben.

> =20
>  SIMTEC EB2410ITX (BAST)
>  P:	Ben Dooks


--=20
Ben Hutchings
Reality is just a crutch for people who can't handle science fiction.

--=-cNseQr3fHcu0iDSMfz0L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUd95oOe/yOyVhhEJAQrJ5xAAxxtkGKu0VALqQO8pcpbdDK2cqcl9BtPG
el8LWu7VB51XC8jeHnIUewoEtewunwDgqK9z9T+EHLctA5MM3gW3V5R5dpor5Zu4
bdCuPkv3xabyBJ8sLi+DQzBHA14VESThnaifOd9DNwfHr4PWgiWIw0P6Zdds2NvS
5TzyAW/Zu1iheIy6AtmVU8Nh+c9E0GV6zQfB2sR5tFh/J2BxpZWdHE/0XDSaoQZ0
BOh6xlYrU7bx05WyW7n4FrpbE/NzsXU5nNX+tcK4m7uEy2H1pxE9AFzaXiS2BOmy
OFfh/WHwP7yi3tE5idJ+BMjDqEJ+RkDrP84XbCnqjrweSsyL1wrhp5J3BN51KzFZ
3KEhuAK+z1Zz9/EdNiEwj+0abIxmHYATYk3uIqPIESR9YNdjK4iuAxq2JNllyNYM
okdZjUFQmYbnAys+xU6FeayhTOsWvFPKZyfSSHbLr7M8s6p+Pk/6WQRKfFXts4ap
kZapEbKCmpkrdgXwkL6oNsOMbCp+UzYW1ibxwnB85BovNPRuvm45BAqZpLtKpJB1
tyrLfTFiiZcfxSxcyglvbVJ5OLAkzyUpTdiawJ/grxVB0N4+IQgywZaXYluI9NbN
W9fKHEQvK/P6vkQYkWug82JgdvGoo+Le/cDgMGKSVTQg/7z2dgwyGCpYn6oJEqI+
alOTm2uE5OE=
=b2nP
-----END PGP SIGNATURE-----

--=-cNseQr3fHcu0iDSMfz0L--
