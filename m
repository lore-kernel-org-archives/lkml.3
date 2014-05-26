Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaEZPjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:39:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43357 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaEZPjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:39:40 -0400
Date: Mon, 26 May 2014 16:39:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Message-ID: <20140526153919.GY22111@sirena.org.uk>
References: <1400498061-1071-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e/XVYMvPYdBe01jS"
Content-Disposition: inline
In-Reply-To: <1400498061-1071-1-git-send-email-alban.bedel@avionic-design.de>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: tps6586x: Prepare supporting fixed
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e/XVYMvPYdBe01jS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 19, 2014 at 01:14:20PM +0200, Alban Bedel wrote:
> Add the required definitions and macros to allow easily adding fixed
> regulators. This required for the TPS658640 that doesn't allow setting
> the LDO_RTC output voltage.

Applied both, thanks.

--e/XVYMvPYdBe01jS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg2AkAAoJELSic+t+oim9QPwQAI9OfjvFHn0Zfp/xtAxlYc4Q
+46aWAaw5MOidI9HXdBCek3b5TZLeo5n1R1Ce9CJJLxumfvow03+Nb5GeeexNiB2
/knKqygWJDZmC8BrGAiTuK3PFJEw4mu+Jevl9UV8oAglpZTSDe4mGnD2QTsYVbCO
HEZ0C6XNAZq575tPzWSd3A0cW0Ja4AldjWrGEF5+slazLo1gQm+oNOn1WwDcPaoD
/UHLVb9BvY4wIEoDUgzo8ytD/T1bUrXX7otBBlV5oxikmPWNspR6x3AW9tknfLaa
AEyugPSQyFvyLi5iviFrPzzhpoveYLWb2IvL+aFvI2NuLcof06oXnVSroZBLLtCW
C/TGZDZ2rZJdiirL7WXK7xN/onuV1U7FWdSAsWsmDKG6JkjCh1LW5lLEfrM3dYKx
0SrBa0kTy6QX1MDtNh/rOAHdMKxF9W64mALXQz0lQbIj8R1RsB02mSN0QwelvgGM
NUFszEyfP0yLxwxeEnFdEjCfIDbYbdLH/1d5Tj5p/5zVdF23/eMGpSYwYEUxY1Fr
ps6ai9U0lHWRP4oK7xFmh4TRR/hIHI2gPCcl7QqfjPLwowMhPtalYapGyl5d/Eh2
tcFoCR5q1wA2RkPANYHgzIzBVJolyGruuiCdHl4yg135dNrhy4jFVwLJSX3o236+
OF0XPthu+9PLK1Jrez6a
=HojI
-----END PGP SIGNATURE-----

--e/XVYMvPYdBe01jS--
