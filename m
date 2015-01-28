Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764521AbbA2Dok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:44:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38399 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbbA2BZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:39 -0500
Date: Wed, 28 Jan 2015 19:03:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Cc: mark.rutland@arm.com, stefan@agner.ch, shawn.guo@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, B44548@freescale.com,
        Li.Xiubo@freescale.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org
Message-ID: <20150128190342.GE21293@sirena.org.uk>
References: <1422356608-15961-1-git-send-email-bhuvanchandra.dv@toradex.com>
 <1422356608-15961-2-git-send-email-bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UAlHjJyhZOsh4iI+"
Content-Disposition: inline
In-Reply-To: <1422356608-15961-2-git-send-email-bhuvanchandra.dv@toradex.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/7] spi: spi-fsl-dspi: Add support for TCFQ transfer mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UAlHjJyhZOsh4iI+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 27, 2015 at 04:33:28PM +0530, Bhuvanchandra DV wrote:

> TCFQ is interrupt of Transfer Complete Flag in DSPI module.
> EOQ is interrupt of End of Queue Flag in DSPI module.
> For adopting of different platform, either of them is a way of DSPI
> transfer data. This patch add TCF support for DSPI module  in other platform.

I can't really understand what the purpose of this is, sorry.  What are
these modes and why would one choose one over the other?  Your changelog
suggests this is being done per board which implies that it's tuning for
performance but that's usually something that should be done in device
drivers, not the device tree - perhaps the tuning will change over time
as the driver is optimized or perhaps it varies depending on the
transfer.

The code mentions a DMA option as well, generally where it's available
DMA is something that's chosen at runtime based on the length of the
transfer.

--UAlHjJyhZOsh4iI+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyTKOAAoJECTWi3JdVIfQPKcH/3Erd0oqBbMx2yTzxFxA7J+w
KStS/tk19QvU1KJHTUi/CdoTkejfrmG5p8EL8xpfzBz3ZRXO8jnu7ux4hbP5AfoP
tRHFmWrronc4CMiyU/319oWHxA+GZS9mUa6uYncqy6wIuZiYRS1RUVFliNuf0pcr
26P4ScT4MakcnNWh70PDIddzmKZk3MjMksr3iUCp+CHf5cAAYAclyOZ3KQ5xWQsX
SkCpQt5Kb29f7DC7tSbnJQVeff/kJy8Yuxb98kqqsLSSZVvxlj5ctGzZa480wmo/
+lKJFRam+VoljjCZjXVedzAsgibfhoc09Bpue1tAzjwLaOb1VLDqdmteDjG6xJA=
=C6j2
-----END PGP SIGNATURE-----

--UAlHjJyhZOsh4iI+--
