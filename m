Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaIPRlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:41:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45466 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaIPRla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:41:30 -0400
Date: Tue, 16 Sep 2014 10:41:12 -0700
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Frank.Li@freescale.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20140916174112.GU7960@sirena.org.uk>
References: <1410398324-15284-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="saqwZB8dd8xoGD4q"
Content-Disposition: inline
In-Reply-To: <1410398324-15284-1-git-send-email-b38343@freescale.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6] spi: spi-imx: add DMA support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--saqwZB8dd8xoGD4q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 11, 2014 at 09:18:44AM +0800, Robin Gong wrote:
> Enable DMA support on i.mx6. The read speed can increase from 600KB/s
> to 1.2MB/s on i.mx6q. You can disable or enable dma function in dts.
> If not set "dma-names" in dts, spi will use PIO mode. This patch only
> validate on i.mx6, not i.mx5, but encourage ones to apply this patch
> on i.mx5 since they share the same IP.

Applied, thanks.

--saqwZB8dd8xoGD4q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGHY3AAoJECTWi3JdVIfQjyAH/idzcyENZCv5XYBmBARGjcLd
VBO8sU5OieN4U5/bq2TyDzVW4vRP0BfBoQ2PQZec5N1UcYnWAsfjupzGC1yvGAqK
mq9OAe4J5qihlwNLg+YNn9AHTGEcBJ+UKmJE+Y3KhS58wIGiLYq3YVfb9hyflVla
6gQ9Wjmqc3uNtRvvr3sey8/19B+7i0Lr8vlUyBM751I7nVUZPOy26YoHsNc1QS82
WgX7QcmB4WpUeUtQ4nxFrrq8jxi+dexrU5HHcuqOa+wqA8SNeQbdREdUekn5N+Mf
IdI7X1I8KtOTpbFF9fF/eHT/h8PwInhuCvgBc76KNRAZOLGYFileVkn8pg9HcbU=
=5iX7
-----END PGP SIGNATURE-----

--saqwZB8dd8xoGD4q--
