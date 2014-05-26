Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaEZOlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:41:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43231 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaEZOlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:41:15 -0400
Date: Mon, 26 May 2014 15:39:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, stable@vger.kernel.org
Message-ID: <20140526143930.GL22111@sirena.org.uk>
References: <1401092806-25664-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m2rPPuQqLwid6iua"
Content-Disposition: inline
In-Reply-To: <1401092806-25664-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: s2mpa01: Use correct register for buck1
 ramp delay
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m2rPPuQqLwid6iua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 26, 2014 at 10:26:46AM +0200, Krzysztof Kozlowski wrote:
> Fix the register for ramp delay of buck1 regulator. Buck1 and buck6
> share the field (offset 4) in ramp delay register S2MPA01_REG_RAMP2.

Applied, thanks.

--m2rPPuQqLwid6iua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg1IfAAoJELSic+t+oim98tkQAJSXCuH40c0MhJxQ2vLQqo2s
rrc/vBLdLIOfEEo4BBy5Nn3BzllkHJjmt7kdgxhLKbYGZSvX4gxZkCL1iiUOLOWn
a/mz5OJqQVrK9NK+mJe3B4t34IU4pqc8897UgPtWcKcHkPTeYjK27OKvJUBHD1B+
ZKPjOALiJPA2QaoV1ikZGMl+whreYrJWf43/CmKuUVxnCfPxjSs1Pu6nt1IxW5m/
mQMiNMNKsvKOU7wyRwkV0xDfIajDw3HksgEKxXKYTJHeDZtk0F+ybCooB8IKO+aT
UHkz8GUJb4OTtvydr4U9MEyfqoiUKaHL/kg2WISp+qtU4cpbEOQD9U+t1pXx3hbg
Y7PLoCPmblCGY8pTKvHGHPEMoMTTaR8S1XR1z5OjdMwl6bsnyPVHZVxTBZev1huU
AL1SC0Z1BQxOxg0x50notKelXX1Q6d3tHCZgoFfotKOxIKnhTjDDPZEJXPm32cfj
t3ONLT5tVGusnd+6UZGnMlKP8QZjFXQGar3+D8N2P0RgBTi4YCPwdOS1szFxHeOT
xTegW+BhXJAZrbnDyxbQRlOGkckByNjEkjxISUdHuDRzIMn94/sWlK4G36wULHw0
vfwRRca9tMTR7LESpkuJ1RKiwnReCgiiFHCEX9dmoxTIe6l4asZCOufNzI9MJBOs
uk3y03TLfTGHoJCCaESv
=CZgf
-----END PGP SIGNATURE-----

--m2rPPuQqLwid6iua--
