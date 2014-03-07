Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaCGOuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:50:05 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39138 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751330AbaCGOuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:50:03 -0500
Date: Fri, 7 Mar 2014 15:48:44 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux@arm.linux.org.uk
Subject: Re: [PATCH] i2c: mv64xxx: Fix circular dependencies warning and
 compilation breakage
Message-ID: <20140307144844.GS607@lukather>
References: <20140307111858.GB12274@katana>
 <1394199795-5516-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140307142405.GB28943@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zLyS04J6vPP3Ub3W"
Content-Disposition: inline
In-Reply-To: <20140307142405.GB28943@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zLyS04J6vPP3Ub3W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 03:24:05PM +0100, Wolfram Sang wrote:
>=20
> New patch -> new thread, please.
>=20
> > This patch fixes the circular dependency introduced by commit 370136bc6=
7c3
> > ("i2c: mv64xxx: Add reset deassert call"):
> >=20
> > drivers/video/Kconfig:42:error: recursive dependency detected!
>=20
> Please base it on i2c-next. I already applied my patch.
> Your patch fixes the build error discovered by it.

I didn't realise that. I will.

> > Since the reset framework doesn't define dummy stubs whenever
> > CONFIG_RESET_CONTROLLER is not defined, it's the only sane way to have =
a driver
> > that compiles in any cases.
>=20
> Paragraph needs reformat. And please drop "sane". #ifdefs are not sane.
> Fixing the reset framework would be sane.

Ok..

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--zLyS04J6vPP3Ub3W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTGdxMAAoJEBx+YmzsjxAgYMkQAIMO1TZWN9/Y13I67W877Ppa
IXxzpP/jTUBMpegE7wZNBleUjHT26wd06p5FbuFJkewQbSDk4h0ooKnupJfrEaj5
+oEkb430vFKxK5f+8b2soKW7sZJoJ2zYDn6k+jLT0FhOJtbWYo++SicAe24kYosP
E92nDXdOid4dOH/ed5Jam3ySyk7oR57I/LHs/kEu9M931uIgU2oNUl9uRk3HfHkP
Ub40HCiq+xOCoeXvPMFfbJfSbK1Jrt6/8A3JoU4y2g4ZmAkqm4FWlICE5ttF8cZ7
mobdVoMtFt3uvnp4HEXC6H91TLsReChjXYHWVe/Vrzl4hZQZcVM0ATBwsA1VTe5e
mIs/K9RcgL7uRPjU++4PoMCK6PxKm880yBRzJlRCggfuEFDcQ99GRp4RnQ61M1kk
Oj9ek81dbZT3v4LGuBQ0ZLxeeMbdL4rTZqh3iDx3c/Y4wdNRQL4oyG9CjSwqD3DR
BlKIKGWoEvFUzwMPyQePMHopOpoh6cEK490q2Qlqu4+oFP71/ecDgKhskNdC0D2m
jULHwBVZFRxGMUiQxCTZ86+gqA9PNs2dcaSo2NBrReonWqUcj/GO8cdltVvcRzhz
G4jOhwRVyDMUGLy2TNj571A4XXxUjW80Rvd/VFuCUDoyw8lgw8WiKRqVLkwJmRtC
xi7f7PggIlZ33vx8ujb0
=vane
-----END PGP SIGNATURE-----

--zLyS04J6vPP3Ub3W--
