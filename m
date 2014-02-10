Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaBJTuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:50:16 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60793 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753695AbaBJTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:50:04 -0500
Date: Mon, 10 Feb 2014 20:47:35 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/8] Add Allwinner A20 GMAC ethernet support
Message-ID: <20140210194735.GY3192@lukather>
References: <1392028554-32545-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ix2jQZQ3wXOip0b1"
Content-Disposition: inline
In-Reply-To: <1392028554-32545-1-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ix2jQZQ3wXOip0b1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chen-Yu,

On Mon, Feb 10, 2014 at 06:35:46PM +0800, Chen-Yu Tsai wrote:
> Hi,
>=20
> This is the v4 of the remaining Allwinner A20 GMAC glue layer patches.
> The stmmac driver changes have been merged through net-next. The
> remaining bits are clock and DT patches. The patches should be applied
> over my clock renaming patches.
>=20
> The Allwinner A20 SoC integrates an early version of dwmac
> IP from Synopsys. On top of that is a hardware glue layer.
> This layer needs to be configured before the dwmac can be
> used.
>=20
> Part of the glue layer is a clock mux, which controls the
> source and direction of the TX clock used by GMAC.

Just merged patches 2-8.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Ix2jQZQ3wXOip0b1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS+SzXAAoJEBx+YmzsjxAgab4QALz+L2NbY+BL4O9QVRu5tee+
uzC7q0Qa3q2T+RC0bJvEoV4t0njYbZ1xUGidrelesi2toWX2+UI5vhcfQeF1qOdF
GyHs9ha5pE5cFYRElKGcrzKgnmV91f97iydbqGbGoJVXcyv+bI0NA5iveHCdJGpj
boRxcBQ4jX9YxBZs/fpVGIkjc9+t+qNX1jGZwcJCsmg8sXuaL4jDZk/mN4zfEpLb
kFaCjG6YJsIsA70w/g5J7Vf+Q3xHRD6NTPAQCLzs/WTCxeRagzPYhx3xDfuuYbaG
km4+0IwWPUvcCv87d9jAfIB+RJ80LULn0CsoFXZEn56ejuM3RFqDIVeZh1egeO1z
iGWZ+Jq2S9SB4Pod81tfXzaDD/uIpZjzvR3tsr0r8IMDVsSPtIlkrZlpDsDR3ecr
aTjvxA7aKBpEeaVlTXSeOe3HE3ZvLfyQJW5W3fXpqZZLDbWUIDXw5XGL47BiTaan
VJDsXP4eIeIyo3LVpXMdeYAYK9LGSfCC79gFW/rxrulOWselMrNxUrXhf+bcM9/1
nVdqhAATsyRUZVv/aC/ZQ+wg43Y66Z9p0tZnx4RINdLtIhcn5RFGwDY2u/JgMG18
oFvZT/XbZ47UhUVzaAK/j/6OY0Q8duMy/avo8RWOIvUwrpMUUfKXf5+VneUsPmDx
/7tUFHwjiJkgoTmlNuUf
=8Sqw
-----END PGP SIGNATURE-----

--Ix2jQZQ3wXOip0b1--
