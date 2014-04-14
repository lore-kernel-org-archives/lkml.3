Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaDNUnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:43:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32992 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaDNUnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:43:50 -0400
Date: Mon, 14 Apr 2014 21:43:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        timur@tabi.org, Li.Xiubo@freescale.com, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, rob@landley.net, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org
Message-ID: <20140414204331.GE25182@sirena.org.uk>
References: <cover.1396432924.git.Guangyu.Chen@freescale.com>
 <12898efab7a5907e6ed1c438a486692f59ef9d8b.1396432924.git.Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TXtjXAp+Y+VkYOQB"
Content-Disposition: inline
In-Reply-To: <12898efab7a5907e6ed1c438a486692f59ef9d8b.1396432924.git.Guangyu.Chen@freescale.com>
X-Cookie: Are we THERE yet?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] ASoC: fsl_sai: Add clock controls for SAI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TXtjXAp+Y+VkYOQB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 02, 2014 at 06:10:19PM +0800, Nicolin Chen wrote:

> -- clock-names : Must include the "sai" entry.
> +- clock-names : Must include the "bus" for register access and "mclk1" "mclk2"
> +  "mclk3" for bit clock and frame clock providing.

This breaks compatibilty with old DTs - it just removes the "sai" name.
It's OK to deprecate the "sai" clock name but you need to keep support
for DTs that only specify that, there's no code for that left in the
driver.

--TXtjXAp+Y+VkYOQB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTEhwAAoJELSic+t+oim9Mj0QAIwQBL/SGdZ+n6vV3Z5XflLP
KzUVEG4ODRrVYCLwZIcYLz6wQyqAEq/KcT+gZkB3hysZ0xSm+WzF8Dmpt5BUEIhr
VaQvN/CzlliLwQvCYWPI0U6tQiAY76eI7TEMOaqt2qqU/R0uIAVO+KdqWyurJ31X
3bhgUznDpPo6sVaxf5ngAM4dgxmHFWR+UsDFOzV7EzGbkvllT8mWya7mPPT+Iyod
YD204C0qsU9KKSrPJ0MUr/u3xZdURiHCBgHlVXP+KNn+8Du8q0fuYlnKa7daecPz
y/8q5tYFFUDjhQtjdtZoBHSp7/rvp4JiY0LtC3YuVo12EDHMipVzd1lZUDan2O1o
vFcl2GZ8iJYJMGzsLZtVpHF8vId9X5wt34FOSxt1G0DVwzHuEGeHhovE0jLUDRLr
y6JSL8VgULXGm88qmn+orOAqBlOj82sK8gdaP8jGaxC8qNhcXvbZiVRfZ0bgR4pl
reOocP9N+rx5oU9kUzDHM1lnl23Nywy5+mqxcpuknZU0uGTRFRMQuOV6xxLYSF/e
d4IziBZ0KTeoKp7dD5i5XbGfR5zlSfFT8BI5OOTOX5GtBg3Zxo95thk3bBG72zWs
D70sxZ9T3uzYLaTC65KkGxF+a3PX7eIcB14EzsqPc8js4L4Bjpz/nioyj9gL9kSt
Rx4C13U/4otoTh6EcCMy
=NkVo
-----END PGP SIGNATURE-----

--TXtjXAp+Y+VkYOQB--
