Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940Ab3ECJmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:42:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39979 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3ECJmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:42:22 -0400
Date: Fri, 3 May 2013 10:41:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: swarren@wwwdotorg.org, grant.likely@linaro.org,
        linux-rpi-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <20130503094140.GN4945@sirena.org.uk>
References: <1367496810-5400-1-git-send-email-laurent.navet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vDEbda84Uy/oId5W"
Content-Disposition: inline
In-Reply-To: <1367496810-5400-1-git-send-email-laurent.navet@gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] drivers: spi: bmc2835: use devm_ioremap_resource()
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vDEbda84Uy/oId5W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 02, 2013 at 02:13:30PM +0200, Laurent Navet wrote:
> Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Applied, thanks.  Please use subject lines that match those normally
used by the subsystem.

--vDEbda84Uy/oId5W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRg4ZQAAoJELSic+t+oim9EL8P/R9rwcW06Xsij3wBvm25H+Uj
rN9CB13D1LcPIxNlO9lIsaW5qXZfsl82UHYXomYblK5FeLoXvtC13iY/dqTwAKZi
vYI1VHxeNlmiUbb1PMS5aNa4NUiJ1WSRUPCTzHmEjfCO3Lucy8wIQkGvgfBZhTi8
xbbAxwtf/EALdycyyy28uipvneQ0eIeCdsER/NBBB3oGtpfi3NXxBYv5ARra702w
PsO+ra0nfread7ljbEcbKkHJ8rU1JCyQ/BplD9bRmkZLG/BdsuhOm8DGnmfQs24g
waA5Y4J/Yd+y5yF4UmVAtOT3719TIBEZv9oLQYTeWP/9Jqbi/gGYvsfu7ZdSNTv/
I+CiMQJVT7HDapSdQg+HKWDEzcNuooT2AgwG2ryT6lXHnT5DYjTWubxivoxw2Cvm
Ow0mfXeYg+BqvJrhP9/lt33RIHKTORRYN1CW5Gm6waScXOzYzD2PodblfUzWPmJh
LDIYieyPxzv0I6eVN9lZz2t56QZN3+kxfQiuG30USMXiUNd7/OcN2TVLXnfZWItE
q5PicdhqaXo9jevKhA05JLdPEv2NSigeeu8dO/MrwDtmPopq+9VZEZ1BaAZJUo3/
bszAI3bIuMGaJAZrKe2p3IdqvTPAxUlOG+v/dNpL3pqasu7nZqjTBkzgF7qNvlkx
CLJQKM3a4Uk5LEU4zLDk
=prgh
-----END PGP SIGNATURE-----

--vDEbda84Uy/oId5W--
