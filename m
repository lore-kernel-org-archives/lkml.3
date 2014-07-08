Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaGHIOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:14:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52304 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaGHIOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:14:50 -0400
Date: Tue, 8 Jul 2014 09:52:47 +0200
From: Mark Brown <broonie@kernel.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Message-ID: <20140708075247.GP30458@sirena.org.uk>
References: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
 <1404745893-6379-2-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iq/fWD14IMVFWBCD"
Content-Disposition: inline
In-Reply-To: <1404745893-6379-2-git-send-email-iivanov@mm-sol.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] pinctrl: qpnp: Qualcomm PMIC pin controller driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iq/fWD14IMVFWBCD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 07, 2014 at 06:11:30PM +0300, Ivan T. Ivanov wrote:

> +struct qpnp_pindesc {
> +	u16 offset;		/* address offset in SPMI device */
> +	u32 index;		/* offset from GPIO info base */
> +	u8 type;		/* peripheral hardware type */
> +	u8 subtype;		/* peripheral hardware subtype */
> +	u8 major;		/* digital major version */
> +	u8 num_regs;		/* control register count */
> +	u8 cache[QPNP_NUM_CTL_REGS]; /* control register cache */
> +};

The device uses a regmap, why do you also need to open code a register
cache here?

--iq/fWD14IMVFWBCD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTu6NMAAoJELSic+t+oim9saIP/0oLJNJPxAmPXzslNwnalws1
dH6/C01z73n6Ly8bMLB5ClNOO8257cYBDnTc8Rl6Mfcg7IfWUm8JgDs7mmY2Fudc
poGjYZvQo54FEbq7Bqtrg/TzsG7sWIoW6KtldO5DShEGrVeiegrkeKcahpPp9UJq
r7/sJXe/jVeXzh/bkhuqWkIt7C+7LMJ4VsoMLeoddcDoPE1magXMQIDHnTeja43H
qFnq4U6qMUEe84PKC3zFYaUstaq6O9AGzZIUOvdSDw7PNsuWMopOxJBiqnvaf8Sa
34CIFocHmHiQDxo9j28+R22MjSnqI6fwNsRne9b0aQGcBBHubI7erUOBFtsTtYaQ
jACm/srVFRPMq9f4L05b4GI8sp9szW+0wjYBPNWTdAze5cLeeoYAMVaEnqZbcE+9
PBfiekB5Ohj8yaeQBu2I8DSxkXzQbfX5eK8bQ5y1qJf+qOHGwLIv+GQxD1aOcuAo
ifV5YvZtwRptn3eKTjbcCxnJuF4w4qd36ZXhop676WgnRGRAGEKxD5unbTPTFSqy
oB6uZdUymUrQg5fJHXUsdFzMavRTqOQOWnwhttbwsGjkhY1SdLHLdiwozz7w4W8+
wl9qstyMXezvvc8GR3A5qlyuIm0Fu+f9FPWkQLVaLomlYN/f40fGacySKD02UKhj
TYGrx9U/LjbQAwMfH4EY
=7nrv
-----END PGP SIGNATURE-----

--iq/fWD14IMVFWBCD--
