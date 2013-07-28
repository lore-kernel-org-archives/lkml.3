Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3G1DOv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 23:14:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33292 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab3G1DOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 23:14:50 -0400
Message-ID: <1374981271.2476.0.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 06/79] net: Swap ver and type in pppoe_hdr
From: Ben Hutchings <ben@decadent.org.uk>
To: David Miller <davem@davemloft.net>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Sun, 28 Jul 2013 04:14:31 +0100
In-Reply-To: <20130727.175541.1879192128080680197.davem@davemloft.net>
References: <20130726204721.849052763@linuxfoundation.org>
	 <20130726204722.608161811@linuxfoundation.org>
	 <1374940708.13555.37.camel@deadeye.wl.decadent.org.uk>
	 <20130727.175541.1879192128080680197.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-zJEjhscTEb69nzOADJF3"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zJEjhscTEb69nzOADJF3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-07-27 at 17:55 -0700, David Miller wrote:
> From: Ben Hutchings <ben@decadent.org.uk>
> Date: Sat, 27 Jul 2013 16:58:28 +0100
>=20
> > I'm not so sure this is suitable for stable.  It doesn't seem to be
> > helpful to either userland or kernel code.
> >=20
> > In the kernel, we were checking that ver =3D=3D 1 and type =3D=3D 1 thu=
s this
> > wasn't hurting us.
> >=20
> > If userland does anything more with these fields then it's probably
> > already working around the swapped fields.  It can work with both old
> > and new headers by doing:
>=20
> It's up to you, I would rather have the corrected version propagated
> as soon as possible.  But that's just me.

Let's see what Greg thinks.

Ben.

--=20
Ben Hutchings
All extremists should be taken out and shot.

--=-zJEjhscTEb69nzOADJF3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfSMl+e/yOyVhhEJAQovMhAAsbFORQIrlgto9DtoqMmPkaaiIc2U2Ppm
MeXw6GMBTKzkXaUcFPqt283ZPUcL00bWSa3RUGS3+5+hDuXvDFp4ICvq5LgAVYd2
njXUTtQCTwQfux+Fz7jE0VUK9EH1xeZF6r4BRxfp0kxE90jsqRVgaVbFPe8o9DdQ
G9VOPq9e9n8jVB72KJIRvRtPuNLedIkE8INT9OnAgfYRBIXYZ/ypnK4C0NBOZR2j
SL0luu/qzu8vK6rCcqX5v3Jq0Kh2abKv4a83qCX2OoImvPkKZ+mYXL0RtoBbxZCG
7jCHi6LaASWYS2BsDGCUuVvCkYE40Hk32ij3LT87rFYye2c/CvY3+Z8ueb3qhNv6
I/7LD00fDSmfAK0OzQE5RRv378HEgfAd0XM86c1Ps/9QLKOU9LoaTy03iCxtA+Ea
XotULhHUlIAlx2Kb4fk+SKJkSHtNi7CQ6b++vBSPOKx7wFS1fqZJodcXY2Q95u0d
BLFd1LpEAOTqfUJzmGPyvbbPt77uztVXy+Bb2b7mEHQQWVmBkL2RHXtcRGZPuKpT
/U393iix26Lb8+ytfaXavYUB9RipJQ7zWAWVs309oM6akB+WYD4S61D1MR03wIzb
KxhwXORzle9XkhM2wjB7q8gbCJTMy4SD4a0nDR0eIQMWFqbHQy6rNBK+6G/7uggx
pQAgeA68Ni8=
=uM5y
-----END PGP SIGNATURE-----

--=-zJEjhscTEb69nzOADJF3--
