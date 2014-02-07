Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaBGTaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:30:08 -0500
Received: from top.free-electrons.com ([176.31.233.9]:49519 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751319AbaBGTaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:30:05 -0500
Date: Fri, 7 Feb 2014 20:28:17 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Cc: linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH v4 0/5] Add Allwinner A31 SPI controller support
Message-ID: <20140207192817.GN3192@lukather>
References: <1391605507-30981-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zipuvUKAEymKn2g"
Content-Disposition: inline
In-Reply-To: <1391605507-30981-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6zipuvUKAEymKn2g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 05, 2014 at 02:05:02PM +0100, Maxime Ripard wrote:
> Hi everyone,
>=20
> This patchset brings support for the SPI controller found in the
> Allwinner A31 SoC.
>=20
> Even though the controller supports DMA, the driver only supports PIO
> mode for now. This driver will be used to bring up and test DMA on the
> SoC, so support for the DMA will come eventually.
>=20
> It doesn't support transfer larger than the FIFO size (128 bytes) for
> now, I expect it to be fixed in the future.
>=20
> Thanks!
> Maxime
>=20
> Changes from v3:
>   - Rebased on top of 3.14-rc1
>   - Removed the dependency on devm_spi_alloc_master
>   - Modified the pm_runtime code according to reviews
>=20
> Changes from v2:
>   - Removed the select on runtime_pm
>   - Fixed the clock error messages
>   - Trigger the CS manually, and honour the enable bit in set_cs
>   - Convert to devm_* functions
>   - Remove useless clk_disable_unprepare in probe
>=20
> Changes from v1:
>   - Switched to using the transfer_one and set_cs callbacks
>   - Switched to using runtime_pm
>   - Report an error when we try to do a transfer larger than the FIFO
>     size, instead of silently timeouting.
>   - Added a Kconfig symbol
>   - Move the clock ratio change at transfer time
>   - Fixed the PLL6 cell size in the DTSI
>   - A few fixes here and there: typos, etc.
>=20
> Maxime Ripard (5):
>   clk: sunxi: Add support for PLL6 on the A31
>   ARM: sun6i: dt: Add PLL6 and SPI module clocks
>   spi: sunxi: Add Allwinner A31 SPI controller driver
>   ARM: sun6i: dt: Add SPI controllers to the A31 DTSI
>   ARM: sunxi: Enable A31 SPI and SID in the defconfig

Applied patch 2 and 4 to sunxi/dt-for-3.15, and patch 5 to sunxi/defconfig-=
for-3.15

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--6zipuvUKAEymKn2g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS9TPRAAoJEBx+YmzsjxAgZU0P/RbZqBvGe84U+FvJ4aGghWTx
7PHKrlVDFoKYxTGtFf+3Uq3dwxG/NIyIaCQCYcpaHPG8nGRflfZKJALOdul/sJ15
EF5J8oM79UOvKAKSo8alqYIgIrz+HreT7p87Cd67dppu82Q+S/EJSbg2z7x+dxYf
JC5/i+UQRF9fPKhSNaEg7JOuZnJ4+RpbH5MvmfSCmy3yLQ/hxAnC7QMY5n8H2WPM
a9ilT5DBrJhh8iOOf8YBzkfQqyph6o2oHwiBCXa/0aXWj2SrgWFnrAesizNLh7rh
kLDTeS9aoJQAT2vpc1a24F7glkLTQ9HBPTE7smtQ49u/PGDQBxXBfc4kTjwp0nAN
Prs0aw1wsnrxt7Z0ihZIMnLdd0TkSjk4w7wA+Q1YToBiDCChpemzg3Llke5xKbIO
yeRvHPECH4QTDt3xHRxTktDgVbbpsTcjHqYc3fawREArIWn60gE+p+NbIj/oRa/M
3ldRtBbO1OSFhxZzv4UI78DWCxU7NNE6HqVfi9pIWYmmhqCT218OxS53APg0B17T
uduu/uKie2T3aMmJ8q9+Te8lCWcA9avBs5mWiZJMt8pJmfoHV8+1TN1uzsHPZo3d
OLUGwjlDS0nnpfC8EOWr4UogBhNAhmDZ01nBh1Z1jwilnxmFkvcNo0+Yegmkg/He
BqlBjU27SqceJnhlucn7
=/mrJ
-----END PGP SIGNATURE-----

--6zipuvUKAEymKn2g--
