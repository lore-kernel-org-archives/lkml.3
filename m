Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab3KMF4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 00:56:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:5719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab3KMF4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 00:56:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,690,1378882800"; 
   d="asc'?scan'208";a="432533582"
Date: Wed, 13 Nov 2013 10:30:17 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Florian Meier <florian.meier@koalo.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        Martin Sperl <martin@sperl.org>
Subject: Re: [PATCH] dmaengine: Add support for BCM2835.
Message-ID: <20131113050017.GO8834@intel.com>
References: <527D1DDA.2040004@koalo.de>
 <20131108181743.GR2493@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <20131108181743.GR2493@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 08, 2013 at 06:17:43PM +0000, Mark Brown wrote:
> On Fri, Nov 08, 2013 at 06:22:34PM +0100, Florian Meier wrote:
> > Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
> > Currently it only supports cyclic DMA for serving the I2S driver.
>=20
> Adding in Martin Sperl who's been looking at DMA with regard to the SPI
> controller (which will want non-cyclic mode but I guess there's a lot of
> shared code).
Is there a plan to add a library in SPI for dma ops, on lines of what is do=
ne in
sound?

--
~Vinod

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSgwdgAAoJEHwUBw8lI4NHrV4P/iBW7SdKykUvv5lB6ZJzQHSd
jVSeXWxhazFdnDCdL7ZuBCcyw/ntuXjvd8/qDTGv0b8DzIuGj4aulNH8AeETnkqs
5vVrdydONihL762FcFjFCpBEvRwOfvTaO2Omp0v5z4oiaE2ijTB7BtX5MLWA3YZp
llbTauhmSJbjynOju3PBcbBPFXGua9KKQeL3eYS82PUIOMW/vI6XDO4V0hvSLkpv
qqySDcai22jBlcEkexw71hgf89BAY9W8x1sJGTkJLK8z4ekB5sqrHe+kBJJRzzLr
X2MAjxbMl4NaEbKuGSLRAei/LA75qrBfVxEIHPzBJG6jcsNWyjhxeDvZI47Rphnq
8vKhZapjfWbl6/zUMVZ2flmOdIIzgjfgF9KEhb/EzANalScNYy68xIy11aa5bIs3
L3yEEl7wMo/dvqa1i8R4eh95rlkcgGWedJGYWyjqUGlab1RKLwtQlwr+WVHh+ouy
d/Yb+PY3nCp7S/xjlMoGoumxeya6DsC2vclD3TZP07d7OekgwiwyrWhsAeCsqPDV
5rm+qoJgiuny4HfGDi55njmk+GHm/SJyvypDB4zDcuWGHqxI90XgAWwOtSG0JqHH
iXu7ZsTpq+0maF9/J4tMKYnY5EXDHn+i3upNO5ttl8GQrQjd0hKG4BSJpmF7uKSJ
yCfB8iZLqEePCJXXNpQF
=WRDa
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
