Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaKQXco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:32:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45528 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKQXcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:32:42 -0500
Date: Mon, 17 Nov 2014 23:31:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Message-ID: <20141117233158.GD22111@sirena.org.uk>
References: <1416210027-5562-1-git-send-email-flora.fu@mediatek.com>
 <1416210027-5562-5-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zbGR4y+acU1DwHSi"
Content-Disposition: inline
In-Reply-To: <1416210027-5562-5-git-send-email-flora.fu@mediatek.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 149.254.182.38
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/7] dt-bindings: Add document for MT6397 MFD
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zbGR4y+acU1DwHSi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 17, 2014 at 03:40:24PM +0800, Flora Fu wrote:

> +		pmic {
> +			compatible = "mediatek,mt6397";
> +	}

This looks like it's missing a closing brace and is just generally weird
(having a subnode like this).

> +- regulators : The regulators of mt6397
> +	regulators {
> +		regulator constratints.
> +		refer Documentation/devicetree/bindings/regulator/regulator.txt
> +	};

You need to define the set of valid regulator names and how that maps
onto the physical device, look at other regulator binding documents for
examples.

--zbGR4y+acU1DwHSi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUaoVtAAoJECTWi3JdVIfQ8kgH/izzeNVKV3wqoRUD+YlTtGJv
axaLPulZTC3jXb8nQ9F+zo4oRlpvPayFWViGTsKmDapYOw6AiCaIXUq3MG1QJc9g
9VE21l99zXeYVmVoTjUlYIaUBbHqHi/9OVutgLJE2DeCyTPv+HMCBdFmE4jM889T
E3buJd7WMIruoH9IXWZO2dGS8KvpyCWANPL7SzulSwaOgQ2mKb8rqCkFEC+NurgX
usjyGaC5Wv4eqHhX58O9taFL8lqOxfUQfkLuX6sxE1K9Z3vqEpyuaJ8hP2C92f+Y
+yGJdmf8tmUBEU75CoxipeUKPsViJsKdW/DVBznH9/JlTu7/L5Xo9LkbkPkwQ1o=
=BJY6
-----END PGP SIGNATURE-----

--zbGR4y+acU1DwHSi--
