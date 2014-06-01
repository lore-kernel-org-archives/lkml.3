Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbaFAK5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 06:57:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49694 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaFAK5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 06:57:07 -0400
Date: Sun, 1 Jun 2014 11:56:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140601105647.GD5099@sirena.org.uk>
References: <201405270027.20092.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2mUf73N0HmzM2Naa"
Content-Disposition: inline
In-Reply-To: <201405270027.20092.sergei.shtylyov@cogentembedded.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] of_regulator: use of_property_read_{bool|u32}()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2mUf73N0HmzM2Naa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 27, 2014 at 12:27:19AM +0400, Sergei Shtylyov wrote:
> Use more compact of_property_read_{bool|u32}() calls instead of the
> of_{find|get}_property() calls in of_get_regulation_constraints() where
> possible (note that of_property_read_{bool|u32}() were already used to read
> some properties).

Applied, thanks.  Please use subject lines matching the style for the
subsystem.

--2mUf73N0HmzM2Naa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTiwbsAAoJELSic+t+oim9XL8P+gMJLlRSzir+b0aQrnVeg/eQ
AcU6yH8vK9phKYWuFIXEU1RUmrRTEAkJ83p2LDgOMTYRFmKQm+5akHO82/fDHSIL
675UZOxyG1mjQhidcKxHZ3cQho/tK/ABshVbF5IgkrV9V2i0uSiOH7KPNg5dETf8
cdEiY1KH8SOcq4iwyq8AwJXSJ8jqS/paWqkgdZgXBpP+iQI5R118q/Ra2aA0EcCs
ghLltK/wW0bueIHiQHAImFXlGxnlvTWwv7ch8U4F4FoqtS1qSFjZ4QQIH1QkURyZ
2vBccC25aQToIH7kMHqO4T/4KqXrILR5NhHtuTPt3TxHfMCVtguTrn4A26nQJkfC
dtM6Pwg979o9BFKJ/JQjTSYqFONf13Gi0ixxRey/niJ2pw8dtOY5hREZN3+UdjQi
/ZyOmsYFMvJwjTHB9aNVpeYWSH5LvGa/h1TPQuv8G9GnvoZwhVH3qgk1Pls1z5Nc
eKEn+SqL1w1WmJDv3gNrVNxWgs1WDvWv551KhYgVgCFWooWSsQelJTotY4fPm2vB
YwXOu7x4MDdoTbxybQK7gSt2QuwfM4bH7ynnzMIi7mVbUr1iDG2+3IEK/QcX/Uk9
l3JJlQVAYORv57tnE1YPc/hOsvC5Vac7C7UVBKjX7W6Mpc0qZSuRMnzLwEtRNoWz
F/PBD3CclA+lJUZhgw3R
=fxr1
-----END PGP SIGNATURE-----

--2mUf73N0HmzM2Naa--
