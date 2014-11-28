Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaK1PcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:32:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42227 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaK1PcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:32:18 -0500
Date: Fri, 28 Nov 2014 15:30:56 +0000
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
Message-ID: <20141128153056.GT7712@sirena.org.uk>
References: <1417146874-5232-1-git-send-email-flora.fu@mediatek.com>
 <1417146874-5232-7-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gnqr8uuXGD2cvyzH"
Content-Disposition: inline
In-Reply-To: <1417146874-5232-7-git-send-email-flora.fu@mediatek.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 6/8] dt-bindings: Add document for MT6397 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gnqr8uuXGD2cvyzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 28, 2014 at 11:54:32AM +0800, Flora Fu wrote:

> +- compatible: "mediatek,mt6397"
> +- regulators: This is the list of child nodes that specify the regulator
> +  initialization data for defined regulators. The definition for each of these
> +  nodes is defined using the standard binding for regulators found at
> +  Documentation/devicetree/bindings/regulator/regulator.txt.

You need to specify which regulator names are valid and how they
correspond to the hardware as part of the binding.

--gnqr8uuXGD2cvyzH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeJUwAAoJECTWi3JdVIfQTOwH/2/ilGREaWay/MZBpgOUhq4w
d+5T2C0fKtkHglE4NTTexGsm/EOjmnizQ4EL9bWi/v0KL7VRldSLLQeutTyapNa8
2Mm1rqfgkq2zkf9N7hel+YoX1rubYv9iA7Nc+F9In5zcye2zB/jxA4/DmJ/LcI6E
yUgqiDipuavtJ8jpg7RUEdpVxQ9AM8Jfi8xFg0QeNAQvMBOP1vRbWqDFts4Uucs9
zF35LJE8vcvIehyPe1aCarL+EfZjMmMPxDVCjR4RuvarnKlOh6Vq6ZhS4pwT1QnQ
uoP+8o72sopVNmd5Z7Q6QGC4A4Ma9shZDko5cDPVdqi1OfbS1Lp4hSZ7mz729J4=
=/fGV
-----END PGP SIGNATURE-----

--gnqr8uuXGD2cvyzH--
