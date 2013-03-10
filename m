Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3CJWe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:34:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64664 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3CJWey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:34:54 -0400
Date: Sun, 10 Mar 2013 23:34:50 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, swarren@wwwdotorg.org,
        rtc-linux@googlegroups.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] rtc: tegra: set irq name as device name
Message-ID: <20130310223450.GD4743@avionic-0098.mockup.avionic-design.de>
References: <1362852588-13362-1-git-send-email-ldewangan@nvidia.com>
 <1362852588-13362-5-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wULyF7TL5taEdwHz"
Content-Disposition: inline
In-Reply-To: <1362852588-13362-5-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:lfy9B4VBJyoO3z+6e9oXYXIjRhzr8/D5q0NxTeWCO0d
 K4jN34+aday+jA50/oLtupZ12mKzbOeZfSte58Gg/Um8BPQ3v8
 YUxiqhRJL3qll+vJXCUt4ha4bodbIIUBnIeSD5SqQVu0Q6HwnM
 dFV4LlQMGOpbysqP7Yb+afV9lpf+A3z+H9lKmqAaXHodyvR2sR
 KTSOFR/s2JXpIQ3W6RAZf8/m0iNCcUXiJLuggh21XQP0g1HJ/m
 IIzMeqKXFrVDPOPaU9rkxcFB15gij7aJMNB6SrNEUZIUhgtEvP
 zCdHPrHZ3GTBNG1rn99tvX1On2CmleTpUD/u5sgOfvL1+yyKZ0
 qxmS7BGfMWJuIS5zx3K3gzgFfoXm1OAm19cy8V4NONYGEqRV6g
 wMnZUNzkcMq8Is8CORjcE/Yr1qPfOiBMWj9wAP4V5r/435nOs9
 cMimI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wULyF7TL5taEdwHz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 09, 2013 at 11:39:48PM +0530, Laxman Dewangan wrote:
> When watching the irq name of tegra rtc, it shows as "rtc alarm"
> which actually does not reflect the name related to driver.
>=20
> Passing the device name to have the irq names with driver name.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/rtc/rtc-tegra.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--wULyF7TL5taEdwHz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRPQqKAAoJEN0jrNd/PrOhCuEQALz4iobtxdV3YLjx6TzcaUnL
ajWmK/D4m4QzKLJO1uvdfHmFVVfiZiWaYOdtZ24Y2P97r3QRzRhaQub9eq/S3uIw
gHRo3Y1S6HqOlnWZkqNbx8FdhUMyIBb6vx4hEd2NRWE5bkqEJGI50x7NRqLZZ2in
pjxRQy/3LYG9MnuepP9xbl5yppCEXLBu1qIfpd53rKl1CvV+g6Izlaf8aXoFz9eT
3FqBKsyraruIunF28xw8JUCnezdlTs5ttFzQ9xh/0EWuHeJCw7JT0F3C4go24PU/
sNcp0Rs1yv06+E/yn4quDJ4vCoKwIEiIgDZOwBkqENgDqIb3n1TucV1AziRvtjMn
gNhiBborob6HWo7NOkUefkap4vkwZi0c76rdz0MHWsimTwSmNUC54NEmckTSKT0B
MZlAco9igY3hpSmW3pYtlqQ1Jvrrd/KC6YD+zLI6/ekveTBe2/7J0gRMbFc5AxtV
Z4eFrXNMEZYVOGnY5mWQl9FEsms6RbMUWVYfutb6CWfVQqYxEhg8Tw6pXlhwCVDG
T9AhnmYmbEVCJcdOZTOhUt377bxkfkH2AnGRVCToUwVxDZSZU5bImACncrAbo9tr
4CNeLRrsVC21ugNPPcsf5wyQhYf4jPoS+5Tx6iEOkjVsiDGJpP3TGgbnVh3Ik0U+
Ha6Su7S46LPz2lniOjOg
=IeHx
-----END PGP SIGNATURE-----

--wULyF7TL5taEdwHz--
