Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3LWBkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 20:40:18 -0500
Received: from ozlabs.org ([203.10.76.45]:56727 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab3LWBkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 20:40:16 -0500
Date: Mon, 23 Dec 2013 12:40:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dong Aisheng <b29396@freescale.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: linux-next: build failure after merge of the mmc tree
Message-Id: <20131223124005.d65bea8edf00419a371be64b@canb.auug.org.au>
In-Reply-To: <20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
References: <20131213125716.f432c59bf8782a489400a5a7@canb.auug.org.au>
	<20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Dec_2013_12_40_05_+1100_cpHkv1umPhiYefx/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Dec_2013_12_40_05_+1100_cpHkv1umPhiYefx/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Dec 2013 13:28:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi Chris,
>=20
> ping?

ping again - I am still getting this error.

> On Fri, 13 Dec 2013 12:57:16 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > After merging the mmc tree, today's linux-next build (arm
> > multi_v7_defconfig) failed like this:
> >=20
> > ERROR (phandle_references): Reference to non-existent node or label "pi=
nctrl_usdhc4_1"
> >=20
> > ERROR: Input tree has errors, aborting (use -f to force output)
> > make[2]: *** [arch/arm/boot/dts/imx6dl-sabresd.dtb] Error 2
> > ERROR (phandle_references): Reference to non-existent node or label "pi=
nctrl_usdhc4_1"
> >=20
> > ERROR: Input tree has errors, aborting (use -f to force output)
> > make[2]: *** [arch/arm/boot/dts/imx6q-sabresd.dtb] Error 2
> >=20
> > Caused by commit fc4fafac9656 ("ARM: dts: sabresd: add usdhc4 support").
> >=20
> > I have used the mmc tree from next-20131212 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Dec_2013_12_40_05_+1100_cpHkv1umPhiYefx/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSt5R5AAoJEMDTa8Ir7ZwV2GAP/RV0uYcbmJiTTz5q1qw5HKpC
JGlbcCKibaUDijNc5P0lyWAaWeiTzP8i3V5dzQLuChr42RjFQ8muWYXtv/RAhkj2
U281TuElymWF5zbJ+/Aqc8LFr1RdzWa1vFt00aAKfjVWViHC+XySn/c/6bBrUSh/
9Uy1al7wXldvPMxDpDpNNkI0pT/vRZDqtW8UuWqMA7GcC36pu14QzHS/1+F/qh93
1RrGFrO/inelRKLWpZxpD9cXFvomp4UD+Ohy4wqJaK/Spf/cHN+GqqlhkMgvTB2L
BOyeQDbbbkzvTt8vRb4dta+Nflz8xVIq9tZte8PHve6ROKKI87GNcOf+zHcgvOqO
t2zW8W4RoTAGPtQLKlUKgh4wwpNejEywww/SdERhtQ1uXrOosMvQ7IhiV3AJ6WYU
oyiyf670iAcXX94ThuGAWDGXLNgJrvuUyf8aDOXxYjfFZ+eADqVV2q/6RlMa8eox
DSCH87V86rlP2RXtGzPMoznA3wIlNLokurJHOLtvL3ZyjZKZDg6yfv3JrSLmZI8n
2qYlKIaVZ/z0NUDdEgKsyBpSzz18ay6ZlrJPUL1FtG7+/ZBQYlY1UzlFCdsBN9mi
sy6TJveVTRsU3FGIYtefCeWxDtn6IOaTIbJHDRUIGMewp/fhi4acQ4W2zLPQp4NI
uvJppDUnu5lvSOmgfq2G
=sJgc
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Dec_2013_12_40_05_+1100_cpHkv1umPhiYefx/--
