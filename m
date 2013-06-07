Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab3FGQzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:55:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55450 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3FGQzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:55:24 -0400
Date: Fri, 7 Jun 2013 17:55:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20130607165510.GA31367@sirena.org.uk>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
 <1370622370-19614-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mO3iRf7xCpt3jGtz"
Content-Disposition: inline
In-Reply-To: <1370622370-19614-1-git-send-email-b.brezillon@overkiz.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 28/50] ASoC: atmel-ssc: prepare clk before calling
 enable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mO3iRf7xCpt3jGtz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 07, 2013 at 06:26:09PM +0200, Boris BREZILLON wrote:
> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> avoid common clk framework warnings.

Applied since I happened to notice this on he list but you should
*always* CC maintainers on patches otherwise they're likely to get
missed.

--mO3iRf7xCpt3jGtz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRshBqAAoJELSic+t+oim9ncgQAIbozBmxyetIITYYc3NfK2RI
7o4v5bZttHJcbn8iIQReHRIbqTPVuuXbVfQCKjzNvKuTZqUdTGiHIekerUStX4Jp
0CywJgzHakdy2gZw2YwO0L4TWXA2DKgd8tmCqCslPR3bcTcErhwJuukF1+sSnjGd
08up1FaIVQXSQBUI8ECbzklW3v8Owv2AMow3/NwE9Ggbm1/ZoOOqEs7KmgArVWJd
lgiA0+c+istiOPednVws657uhecbX2UCHOgVK+lnvSOYg+gT0hyqpApJD6Rk9lKr
0E5CrnxbTlzaexv9ZwIaGrbYiZYcY/smal/LBnt0WmPe2S+KWldXpWzNBnr1lO3I
HRIiKWqXV2v/rAEFRyuIiAaKYBWzKAgfqCYHc7IsRsHxpVX8sojfx03HNxNoZp6B
SJmUciTWtK8cwhzRjKVpAUylbDwbvBkWuLJGX9+0Eex2q0SFbVlPzbP8RUgOQTIj
/IF43RuuhLNwCdLuFF8EPZ4lK6KdkY7NvWFA+l44yUD87IPr1hkLWSlgiSToKnlV
d9QgLQss6dmfJ6uiTyIyyjeLTHPU1/0JDKLJAgUblFKT6hAlJ9a3JNshR34ZHqs0
Di2NNdp9350yna7sm2JdJXttPR484e6xBFiJxyO/sPdrlAi/tfcUNPyCA2hrW/Sf
zEL96igI4cfmOgl13Zdl
=mrbU
-----END PGP SIGNATURE-----

--mO3iRf7xCpt3jGtz--
