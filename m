Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3AKDsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 22:48:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39125 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753561Ab3AKDsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 22:48:08 -0500
Message-ID: <1357876077.4514.7.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 004/123] b43legacy: Fix firmware loading when driver is built
 into the kernel
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 11 Jan 2013 03:47:57 +0000
In-Reply-To: <20130109201458.942583904@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
	 <20130109201458.942583904@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0l0OOtQIWMmiPWHIUFvu"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0l0OOtQIWMmiPWHIUFvu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-01-09 at 12:34 -0800, Greg Kroah-Hartman wrote:
> 3.7-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Larry Finger <Larry.Finger@lwfinger.net>
>=20
> commit 576d28a7c73013717311cfcb514dbcae27c82eeb upstream.
>=20
> Recent versions of udev cause synchronous firmware loading from the
> probe routine to fail because the request to user space times out.
[...]

This has since been fixed in udev, and the kernel can also load firmware
directly.  So is this still worth doing?

Ben.

--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

--=-0l0OOtQIWMmiPWHIUFvu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUO+Lbee/yOyVhhEJAQpQqA//TP+G1/JfgKiUXscg/09P7NIprFPRmWH1
UncYUt3XGYfZyuZLvpHqRYyJ4K1cGmg3hPNt8OOfbCUbYzyZh6A2gZ5wAyBLFmYn
PeSl4WuR3l68H1Y5WvMYY0R6sJehAalmG/yyya+CEmRyYSipdrrBYBLVAm2jArVX
+KSRdxhelAAoX2SnsfQy+JSRGoNmhU8J5ObahZM8Zq858tdD5nyhIpTwa6iSA2jz
F9/lfCeKL1wZZtxnKq8F3AVZk35UAKzmWK7dtSiAN5ZpHnQpRa/ELscEBe9kPlwm
o7BlIGXaNr60c4AIgFAVdClRbk4IhOGM1etE53320cDFhWMeYhnLKjybAsN+efYn
e5WOxT+xR/4NfluMK1g07DOTv0FfW2+g87j5twdMNEBRhDyf3q1hLJSDCSrGi5wX
7879zhfjKXVZCtwK75qeOfWBIm80X6+aXB/h4RL2u4VQFXQYgCS1rUMu/JTpf9GW
GYU6YXyWup7+UUIqr9aUSH6uqZ5SOHCGqRn6jVWdPWU6cpVDPq4FTBfA0co5DxWd
J4o4vdoBce4qTC8zXv9GiDoOKiPYd7nXnLKp0zoGi6/Vv83WGLHoAU5QF6rtC24k
HYuDtwYyMQD5v26z837cAhUZq5ERhPHNbxkdGpuHz7dGbq/3QtJ1lSJQLsqHAwVc
/zZsc9N8bDI=
=6E8P
-----END PGP SIGNATURE-----

--=-0l0OOtQIWMmiPWHIUFvu--
