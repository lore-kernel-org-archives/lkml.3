Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbbAHRFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:05:06 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33816 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932263AbbAHRFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:05:03 -0500
Date: Thu, 8 Jan 2015 18:04:09 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, dmaengine@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: tegra: add slave capabilities reporting
Message-ID: <20150108170409.GW7853@lukather>
References: <alpine.DEB.2.02.1501060640220.28771@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HxEkdbCoFEDbFH5U"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1501060640220.28771@utopia.booyaka.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HxEkdbCoFEDbFH5U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 06:44:56AM +0000, Paul Walmsley wrote:
>=20
> After commit ecc19d17868be9c9f8f00ed928791533c420f3e0 ("dmaengine: Add
> a warning for drivers not using the generic slave caps retrieval"),
> the Tegra APB DMA driver causes this warning during boot:
>=20
> WARNING: CPU: 0 PID: 1 at drivers/dma/dmaengine.c:830 dma_async_device_re=
gister+0x294/0x538()
> this driver doesn't support generic slave capabilities reporting
>=20
> Fix by setting the appropriate reporting structure fields that are
> passed to dma_async_device_register().
>=20
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Cc: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Laxman Dewangan <ldewangan@nvidia.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Alexandre Courbot <gnurou@gmail.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--HxEkdbCoFEDbFH5U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrriJAAoJEBx+YmzsjxAgvksP/2o1c/5D1p4WnXYYFW1f99aZ
Ht4nr38/LZ+n2O8UOMQdz3Sy4BLFI+9Caht1KWES3BA/hXXa1KRcnwiMD5qleCAj
aLrt3w8NmtxmweR2UUOO7HyrAjBBEI7PqPw0XagRQtxaHkXqm1+0ZLN+n0hDIQzj
jc0kWzArtbG5dDH9LeE+dnp70TOBQtXBKlS3/nlVFBWJR7JoVc9BbgG/4Ir0lMs4
O4EpPU0yr3Pyir/0ViRqLxBGSGHGTS7XewjK/+/pBGMT6sJgqCnQnNPdDS+8VnfV
S652EI6Tt/RK952yWA6WxMS9tDOLhks8loU8PKdHRxnHf1e1rWApNzkhOcn2Ale4
1i//lTv8iWOnopTX/99KghNq83Ha5e5nbJurMeS+W+0V9/WAtvovCifNHoKJQMxu
5xtNKWONZByV6+k1QaIT3fYScIWkfYjxJSVFxyrIj7g4p6YSgkXZv5Cs7+2t4eb4
HRb6Tcdt5XKkG6apmsTTXCGMYacuTPotP1Tt3qj0Dhmsm6s+YY6Sh4T5OwBwOgei
kWJmem6MbymzCp0Xj/o6bdn1PWVffZQykkI5jMuKPjwPDD4le9QUxNC0ULDttihj
LkETEGHLItmdr/U4S6LvbrQKLHVHNOxNk5cEPOEv5ZSJYdg85JnXguEO27h2vCjN
LBedy1+7YokoSPihmkSu
=ciJk
-----END PGP SIGNATURE-----

--HxEkdbCoFEDbFH5U--
