Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaFFKX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:23:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56808 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaFFKX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:23:57 -0400
Date: Fri, 6 Jun 2014 11:08:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Matt Porter'" <mporter@linaro.org>,
        "'Tim Kryger'" <tim.kryger@linaro.org>
Message-ID: <20140606100833.GH2520@sirena.org.uk>
References: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tH81YkO9bF1TqYxP"
Content-Disposition: inline
In-Reply-To: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.213
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulator: bcm590xx: remove unnecessary OOM messages
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tH81YkO9bF1TqYxP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 03:27:21PM +0900, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.

Applied, thanks.

--tH81YkO9bF1TqYxP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTkZMeAAoJELSic+t+oim9nxMP/iueV82jGWduRqLI6zXSxgZp
5kBVkcL3w8dt7PnxdOx8/eWXvNtpLcjLBOaNZSnaHEZ7NphLMQab9XYF45hz2sAe
i4vb4JmVQ16+ECuKJuM9AjOFb0jEu+9LtquosFMFQC3u1b8BAiqy2p5xQ1tF/yTC
vms2x6KwOe12rEUkwI3ZTZhnjP7YeZpjLpwTBBdJd9ShxukKeixsRy2gOitiKTBk
udaQhKhHC9W4m/tjSp4kR8iP0HuIBPQwgndyoKVqelFj4rTikGxFQDwk70Dik9Is
GNJPe5iCdu27m7R9QeCPbSKcjlj6XJIaYETLt0r2rex7QCXDIL1eCVXRDIO8X5D5
tsWZSwhx+xQ8HDQ/sXvCGGinL17zva8dePnAM7V36MZG/7wfo2VS/iiCvlDQJYTy
zDgTYhLi4GWAxswLODaiP1/wrwIZ4nwwFGwSgqmnr/o4c1vX7kEZjKtcU8OjU1H0
donZ3f+r5TDHnUZ6o72RxnQLm7Qie47GqWc+E6jzadVE/qFpxVSNRnlKL4lqm9CR
GyVFtO8BCh7/Fw6S92aAemdcUBKhcugObPxFS+Xu0wD5o2IPnlSQX1kNN+Bnbaux
KPt6jToF5Gvr9y4JBCv5eSVS0ElFFWZuJyxzHQu24gxdGUuElESTRWWaMuByohFM
u1P6t8uVL/U4z01trOV+
=3JKO
-----END PGP SIGNATURE-----

--tH81YkO9bF1TqYxP--
