Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaI2TWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:22:14 -0400
Received: from omr2.cc.vt.edu ([198.82.141.100]:51390 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbaI2TWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:22:12 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Harsh Gupta <harsh.gupta@st.com>
Subject: Re: [PATCH v3 6/8] phy: miphy28lp: Add SSC support for PCIE
In-Reply-To: Your message of "Fri, 26 Sep 2014 10:54:15 +0200."
             <1411721657-9924-7-git-send-email-gabriel.fernandez@linaro.org>
From: Valdis.Kletnieks@vt.edu
References: <1411721657-9924-1-git-send-email-gabriel.fernandez@linaro.org>
            <1411721657-9924-7-git-send-email-gabriel.fernandez@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1412018368_2318P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Sep 2014 15:19:28 -0400
Message-ID: <15685.1412018368@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1412018368_2318P
Content-Type: text/plain; charset=us-ascii

On Fri, 26 Sep 2014 10:54:15 +0200, Gabriel FERNANDEZ said:
> SSC is the technique of modulating the operating frequency of a signal
> slightly to spread its radiated emissions over a range of frequencies.
> This reduction in the maximum emission for a given frequency helps meet
> radiated emission requirements.
> These settings are applicable for PCIE with Internal clock.

> +		writeb_relaxed(0x69, miphy_phy->base + MIPHY_PLL_SBR_3);
> +		writeb_relaxed(0x21, miphy_phy->base + MIPHY_PLL_SBR_4);
> +		writeb_relaxed(0x3c, miphy_phy->base + MIPHY_PLL_SBR_2);
> +		writeb_relaxed(0x21, miphy_phy->base + MIPHY_PLL_SBR_4);
> +		writeb_relaxed(0x00, miphy_phy->base + MIPHY_PLL_SBR_1);
> +		writeb_relaxed(0x02, miphy_phy->base + MIPHY_PLL_SBR_1);
> +		writeb_relaxed(0x00, miphy_phy->base + MIPHY_PLL_SBR_1);

I'd feel a lot better about all these magic numbers (and the triple write
to SBR_1) if the Changelog or something referenced where they came from....

--==_Exmh_1412018368_2318P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVCmwvwdmEQWDXROgAQLtMg/9H+nmmSKkfoI/tNnOeYX/CReNoesUCvSd
1z2hck+7206Yq5efMlrUV0SZ051iL+ak0XESDhzHccn1q1pcSQZjmgMEQDCrFbTP
Dfl7Eb2Wn5aqd8DMyNcBoEzzV51iAJi2rtVGKh6KhT7/A2QdmkFTlmNZrgz12ZuS
qUfFsRIpGqmHRsu/T73bC2ICdrP/uBlpi93GspYEWo4cyRqOD6gB1EsgldNP0l5J
5J7aRoKcd2omQckVzkR3lSFzo1vh+imC1cULNT5aAQ0p1xvQgKQP4E+o4qlrOw8j
mM85s80fw5VaAi4eqURWCyIoo8DVX8NP5qLD/3TgDyBttTCLMFPbAiR9FGjzsjtJ
k3HB/PZsUiJhO5Fy/2T5k6vwgGSk+qq132rG583gtBU8dHk9hUQULF7WlOGpmPya
0xX/xr/+bceHefr8sZddUicvtvuCkhvbFZciMm731nwFfQYtSEOlImpEVVtM1FrF
KQ19Mi952EFxRANDSKHeOGPhQcUv/qKF4fnw5okV/lc52u+6c2a35Kri+sy50Ai7
iNLRliCvWDIV5L72VdrVAcL0IZOJRwiH+xlTvpg89NygHhfJgTaIWi6E+fEXgvHT
yA8zEEH9KNEnTTRdxE0GnJzX5MzTjsAJHjdqWzimfYmKli6yH5R/gHkoCWhhXQR6
AFTrrAya2p8=
=1oR7
-----END PGP SIGNATURE-----

--==_Exmh_1412018368_2318P--
