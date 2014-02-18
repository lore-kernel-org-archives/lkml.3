Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbaBROUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:20:07 -0500
Received: from top.free-electrons.com ([176.31.233.9]:45352 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754609AbaBROUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:20:04 -0500
Date: Tue, 18 Feb 2014 15:15:32 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>,
        David =?iso-8859-1?Q?Lanzend=F6rfer?= 
	<david.lanzendoerfer@o2s.ch>
Cc: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 2/8] clk: sunxi: Implement MMC phase control
Message-ID: <20140218141532.GH3142@lukather>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
 <20140217100221.15040.47203.stgit@pagira.o2s.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CEUtFxTsmBsHRLs3"
Content-Disposition: inline
In-Reply-To: <20140217100221.15040.47203.stgit@pagira.o2s.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CEUtFxTsmBsHRLs3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 17, 2014 at 11:02:21AM +0100, David Lanzend=F6rfer wrote:
> From: Emilio L=F3pez <emilio@elopez.com.ar>
>=20
> Signed-off-by: Emilio L=F3pez <emilio@elopez.com.ar>

You're missing your Signed-off-by here too.  Remember, for every patch
you send, your Signed-off-by must be there, regardless wether you're
the author or not.

A commit log would be very much welcome too.

Now, down to the patch itself, I remember Mike saying that he would
prefer adding a function in the framework instead of hardcoding
it. Mike, what's your feeling on this? Would merging this seem
reasonnable to you as is, or do you want to take this to the
framework?

> ---
>  drivers/clk/sunxi/clk-sunxi.c |   35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>=20
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index abb6c5a..33b9977 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -377,6 +377,41 @@ static void sun7i_a20_get_out_factors(u32 *freq, u32=
 parent_rate,
> =20
> =20
>  /**
> + * clk_sunxi_mmc_phase_control() - configures MMC clock phase control
> + */

If you don't go the framework road, some documentation on what are the
arguments it takes and what it's supposed to return would be great.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--CEUtFxTsmBsHRLs3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTA2sEAAoJEBx+YmzsjxAgCMkQAI2kyBm+/uq0g4rIozLMUInV
exoluhSH0iqlEXJh6WK7/gAAPsR1NvQeYmzmblKR2QcmeQed3xIQ2iLl4VT+b8e6
lMZLmxWgJzZNZpDiIQFFZv32KtvkY5thUqAemhgK1NPB4m0VoAPhtHZTi32NSuTN
zG5a/YlCtXFqZKbpx81caPqrmwgFFTHGur/DS70MXRSYDmukq0FW3tNpZ28e+d62
lZi3SdAy1TBJJ535XDnskdF7s9BDdmt7IdXXekLw7Qfz4Eu63thD1+DsO0qLayd4
GYuOlWN1CYDNp0UwFNVQNhnfrDLx+NjsA+HK7UJbcRrCe24zqLujulaH9IdOKrj8
tUa4m6q2mzhPCdFvCNzmefnjq4W3XYsEgAdAWaj95IEWY9IAD0lj5dUsow8wKq8Y
aV/L37+I35tZznE3z87E/kZH70lzR7tE73bVBuX9vtiLRbWKjRUgqS20GKURxx4y
jAdmD5c0CtmI0vBBqtIwQGN520iQKjOs60vqJyZC5G0B1nFZ8/iRa0K7Sew/8wBp
uMqzW3YDlJMxZMHUJ3+1DdbW5KT3k7uVk3pvAh40PG0LuQrCpIzKM4We/GlakVDB
yL/V1m7erqJJDfB6Gb5Fyq75UqEHDt1er63XIcmAspVwFYs4EnqBR8wAAaDhDE+h
hGq4rhGkLqiLUI9B2Efa
=YYKH
-----END PGP SIGNATURE-----

--CEUtFxTsmBsHRLs3--
