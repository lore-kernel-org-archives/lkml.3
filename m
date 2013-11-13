Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab3KMVuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:50:11 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50485 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750874Ab3KMVuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:50:05 -0500
Date: Wed, 13 Nov 2013 22:45:54 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-kernel@vger.kernel.org
Subject: Re: [linux-sunxi] [PATCH 2/2] ARM: sun6i: Add SMP support for the
 Allwinner A31
Message-ID: <20131113214554.GC3538@lukather>
References: <1383471013-21695-1-git-send-email-maxime.ripard@free-electrons.com>
 <1383471013-21695-3-git-send-email-maxime.ripard@free-electrons.com>
 <1383583997.8826.123.camel@kazak.uk.xensource.com>
 <20131108084056.GB26440@lukather>
 <1383906355.3189.77.camel@kazak.uk.xensource.com>
 <20131110100312.GI26440@lukather>
 <1384188485.19117.90.camel@kazak.uk.xensource.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline
In-Reply-To: <1384188485.19117.90.camel@kazak.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2013 at 04:48:05PM +0000, Ian Campbell wrote:
> > > Anyway, once I get to the point of being able to do something I'll
> > > coordinate with Marc etc and figure out what to do. In the meantime I
> > > think having the kernel do the bringup (like this patch does) is
> > > sensible. It's very likely to be what we want to do in the absence of
> > > any instruction to the contrary (DTB or otherwise) in the future anyw=
ay.
> >=20
> > Yep.
> >=20
> > A part from the discussion on the approach, do you have any comments
> > on the patches themselves?
>=20
> I know approximately diddly about how one is supposed to bring up these
> processors, but I did correlate what you were doing as best I could with
> the A20 manual for the registers and it looked sensible to me, modulo
> the fact that I was looking at the manual for a slightly different
> processor ;-)
>=20
> Not a terribly strong statement, sorry.

Fair enough :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSg/MSAAoJEBx+YmzsjxAgO9YQAKF/7iV8CRHoQRL+rW+1YhCj
CDuuRdQrlJ5mKhkGzGKa5/h8V70LJH+M7Auxh8Q2413q6AERNMaICbvb8KURWF6K
rrWb6cUTPjBEaygKMO7ZivdPKuRlBidbqW/9307gZ9qWulf6Rtv9+liOL6RuAOJl
UVbCWvuh3ROGwWSJdrKNQgPI2iSndc62xlO02a3doi1jg0NbkY1YHxrMfDfPmhtD
lokcdmPP5Nsxq3AeMM6lCQGPk/MkTMoSeTdFvHfVBk3hd91PLYx7F7cpeWJr9tZQ
HrwtmgVhAsfmMTEsJR2FnoWcEVgBRAS7AXHRhQHZhsiJHDWtsVKbqtAEMK0sczvJ
Cs6yXQrmFHyyIKYcloDPXtbv/cKlWJEp0OyrMjFBWnDck2/v4IfcnUY88LZeH4L/
pCCOzxw8wb72jMFd+tBqOsSXRboUvBjlP4xppw7V9QX9JH4GLyC9Mt/C2xmEtp3M
CkLuToC4qYmtNB/78/OwnfjQdjXM5uNalZGX5kzkIK0yVKVB9lpXIBeoOEvjARxZ
nXtTmyg1Y3D9M1Xtb8U0Ee+ezQv7unCFDQZwHici4LFNL39TN2bYLlFuuTM5UlIf
sWULz7I+FHITxH1s/3cEO/7wLSn2yYxxPFfeIBobocImmXf4v39lFVKjj6pfk8VO
/sW/j+v3pfAHcsgymnaS
=7yYM
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--
