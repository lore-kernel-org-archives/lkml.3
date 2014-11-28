Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaK1Pdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:33:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42247 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaK1Pdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:33:40 -0500
Date: Fri, 28 Nov 2014 15:32:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>, Andy Gross <agross@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Message-ID: <20141128153237.GU7712@sirena.org.uk>
References: <1417146874-5232-1-git-send-email-flora.fu@mediatek.com>
 <1417146874-5232-2-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h6kYMYtSOeQy+8K8"
Content-Disposition: inline
In-Reply-To: <1417146874-5232-2-git-send-email-flora.fu@mediatek.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/8] soc: mediatek: Add PMIC wrapper for MT8135 and
 MT6397 SoC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h6kYMYtSOeQy+8K8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 28, 2014 at 11:54:27AM +0800, Flora Fu wrote:

> +config MT8135_PMIC_WRAP
> +	tristate "MediaTek MT8135 PMIC Wrapper Support"
> +	depends on ARCH_MEDIATEK
> +	help

> +#include <linux/regmap.h>

This uses regmap but doesn't select anything from the regmap framework
so won't build if nothing else selects regmap.

--h6kYMYtSOeQy+8K8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeJWVAAoJECTWi3JdVIfQwpwH/jhaBBVFupIaYovNOJgAAlMB
Ze4RkJr8udwxRbsc9SkKGlsuAheMAOrCyD4+WH6XkcV1BOZMPqs5ws3rPoL7LqWQ
/anX75lfyi+M3ecezhN/zJunrqgnvVq/4vuWhGYWu6KUPYl8A+2N91AoCqiBkBJw
Zet3DQXb6dM9wYGioTPtUlbFQqX4jhVOIDI8hmUOmvU457CNY9VTpnM2IGnPjN2D
kETh1vziy17G2j2lp+uSfy6Jn8w/IG0d/JS1YseqW5un7BXjbrn3taCylVR6Q13H
BfD7DXvxbGEWEPQhIPz5CjAlvp15+SdhVArJfheixpNcuGTXgMu7VL0FObTugQk=
=J1lX
-----END PGP SIGNATURE-----

--h6kYMYtSOeQy+8K8--
