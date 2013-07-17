Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3GQIK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:10:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44228 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3GQIKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:10:54 -0400
Date: Wed, 17 Jul 2013 09:10:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20130717081041.GZ22506@sirena.org.uk>
References: <1373986995-23899-1-git-send-email-b.brezillon@overkiz.com>
 <1373987782-24463-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KC8n6y+EC4k2kdZR"
Content-Disposition: inline
In-Reply-To: <1373987782-24463-1-git-send-email-b.brezillon@overkiz.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 5/7] spi: atmel: prepare clk before calling enable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KC8n6y+EC4k2kdZR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2013 at 05:16:22PM +0200, Boris BREZILLON wrote:
> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> avoid common clk framework warnings.

Applied, thanks.

--KC8n6y+EC4k2kdZR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5lF9AAoJELSic+t+oim9RB0P/261TNyK0PuboNo5w2NuYvl7
uY6UJn8GaYswXWuniSh4vMEyXD/AwBsf0F4GGuXIUIxggemzx1+G9oA3iNRSECFq
CXwYkSie39fe+R1QvDyWknfRlGytlCTbVanmluSV7jcwgJnQDqApcFXSD8QINSQy
oVus5c6LDPCiMwe+cr6A5eyeUQ2BIyywV91IOjKH1aYh5jxiv9GZBVpHdOTXdWZZ
o+J4BStG0/zm3yjB5TMvjaKsBCTEXlEnxiLNMzd0oL8tde1mg7r+PtmSVmNdReFd
F7oHVyWsbgUc57Bt7nk4hVXiJUYPOubkQczyeijFMlPVUv0Ftx5FsZkfvzs3sus3
NEe9Xu6vQRU88qSBsF2X7C80G/DCFtj3YY5T5TOMr9fjUipkNaEOxZ7uHgHJjRTl
H4jjzQsrJIgi816pD1dtN2r4T69aUZ8TAVVK3v2LpPussfXrFiOcAfa8mB89hiCF
E9NiaWnx7YzmuLyJmNUEQgNcQFArViMqe3Swdu8X4SxWa/6tZ0CILMXeZVF1CKnl
ZiPvHNkidZN+enB+ar8wI2EhP4DB9awUSXrPXY/J/b+WDT4ORS8Fr6WbYm9a4wLe
ZDV93T3GchTdI4tODrqC9r5z+JilHJ8PDCo5MfdqXqLBXHTc1wbtgMLaud63Ln2D
AXHfO8CQIjFK2vkKh5sH
=KKaN
-----END PGP SIGNATURE-----

--KC8n6y+EC4k2kdZR--
