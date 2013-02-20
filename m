Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935498Ab3BTNeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:34:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59840 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935090Ab3BTNeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:34:12 -0500
Date: Wed, 20 Feb 2013 13:34:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] spi: tegra114: add spi driver
Message-ID: <20130220133409.GF2726@opensource.wolfsonmicro.com>
References: <5124CEF5.3060605@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sDKAb4OeUBrWWL6P"
Content-Disposition: inline
In-Reply-To: <5124CEF5.3060605@nvidia.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sDKAb4OeUBrWWL6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 20, 2013 at 06:56:13PM +0530, Laxman Dewangan wrote:

> spi_clk = devm_clk_get(&pdev->dev, "spi");
> spi_clkm = devm_clk_get(&pdev->dev, "clmkm");
> spi_pllp = devm_clk_get(&pdev->dev, "pllp");

> and call clk_set_parent(spi_clk, spi_clkm) or clk_set_parent(spi_clk, spi_pllp).

This also seems like something that ought to be factorable out, ideally
it'd all Just Work(tm) with the clock framework but...

--sDKAb4OeUBrWWL6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJNCNAAoJELSic+t+oim9ScAP/1ZGZpOPzPHDhIlJkmGvDnwG
+EwyN9RUfuhGdLzIK9i8S0VR+TXZ84GnL8cksFehESdf1tXk9lCrRYm1z/FKcQbd
cszjaBNrT7jDiqVaPcX7gPCYN8bFYtVrfKpSsfzWkuPFw+cIXkNr3YRpsMQ1nLBG
6EjPbI50w3yXC/jPf+i64zF9Jp2tkh9TDr/CtBjQPzKCS/hC120AdkZ9Ao89AZBk
/LnW/BiOWwBPnQe2SzuaXqtykDAj7jAQg3MxwxIq47BW9+lxBrRuPgzdAx9iXKei
okks80TssvaoxnzVsmTY1EJzrv4F0XGp3qnPX8r0y/a8TCfojnIl7uQWbFTJRpJe
c1fk8njZW/B1rnrR3TKJKGa67wesY3Rgu8cCeY+B5LeusOdSW/BWy/i8iLMch5HE
CtAKKeDg7cK71PvAQh84eppOO0Le67mwrfrsjcNrGbunAO75WvAuplBsggwluut3
fbaHlco4PYf+0l3JsuXu1kBpQAYTNfgMtIZkM/6RK4P7uJuJjqrQOfBRiAD0fry9
3O4/pGitgYQgnm8GO/3eLVF7pesltHidLQnOmIbvtMAv7KW5BjQtzBUjpa1w99QZ
idaWMtZk0N8SBq1knr3Hza/9z9ibiE6i5GGsLV3K/ANLyf5T40mgelp+G5J0NjJY
X8pPI9Pb3heyicNTr0eq
=RNEx
-----END PGP SIGNATURE-----

--sDKAb4OeUBrWWL6P--
