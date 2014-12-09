Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbaLIEql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 23:46:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:6700 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbaLIEqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 23:46:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="426754759"
Date: Tue, 9 Dec 2014 10:17:02 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: linux-next: build failure after merge of the slave-dma tree
Message-ID: <20141209044702.GV16827@intel.com>
References: <20141209144817.2df2eb7c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sfyO1m2EN8ZOtJL6"
Content-Disposition: inline
In-Reply-To: <20141209144817.2df2eb7c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sfyO1m2EN8ZOtJL6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 09, 2014 at 02:48:17PM +1100, Stephen Rothwell wrote:
> Hi Vinod,
>=20
> After merging the slave-dma tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
I did merge the next-20141208 wth this new code and pushed. Found and
resolved the same merg conflict as you :) Feng'd bot didn't
find any issues, so am wondering why :)

Neverthless, I am dropping these changes from next.

Thanks for reporting them

> drivers/spi/spi-atmel.c: In function 'atmel_spi_stop_dma':
> drivers/spi/spi-atmel.c:485:26: error: 'struct dma_device' has no member =
named 'device_control'
>    as->dma.chan_rx->device->device_control(as->dma.chan_rx,
>                           ^
> drivers/spi/spi-atmel.c:486:8: error: 'DMA_TERMINATE_ALL' undeclared (fir=
st use in this function)
>         DMA_TERMINATE_ALL, 0);
>         ^
> drivers/spi/spi-atmel.c:486:8: note: each undeclared identifier is report=
ed only once for each function it appears in
> drivers/spi/spi-atmel.c:488:26: error: 'struct dma_device' has no member =
named 'device_control'
>    as->dma.chan_tx->device->device_control(as->dma.chan_tx,
>                           ^
> drivers/usb/musb/ux500_dma.c: In function 'ux500_configure_channel':
> drivers/usb/musb/ux500_dma.c:124:18: error: 'struct dma_device' has no me=
mber named 'device_control'
>   dma_chan->device->device_control(dma_chan, DMA_SLAVE_CONFIG,
>                   ^
> drivers/usb/musb/ux500_dma.c:124:45: error: 'DMA_SLAVE_CONFIG' undeclared=
 (first use in this function)
>   dma_chan->device->device_control(dma_chan, DMA_SLAVE_CONFIG,
>                                              ^
> drivers/usb/musb/ux500_dma.c:124:45: note: each undeclared identifier is =
reported only once for each function it appears in
> drivers/usb/musb/ux500_dma.c: In function 'ux500_dma_channel_abort':
> drivers/usb/musb/ux500_dma.c:249:34: error: 'struct dma_device' has no me=
mber named 'device_control'
>    ux500_channel->dma_chan->device->
>                                   ^
> drivers/usb/musb/ux500_dma.c:251:6: error: 'DMA_TERMINATE_ALL' undeclared=
 (first use in this function)
>       DMA_TERMINATE_ALL, 0);
>       ^
>=20
> Caused by commit f86999789afe ("dmaengine: Remove device_control and
> device_slave_caps").
>=20
> I have used the slave-dma tree from next-20141208 for today.

--=20
~Vinod

--sfyO1m2EN8ZOtJL6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJUhn7GAAoJEHwUBw8lI4NHU3gP/jwWe+LIkM2VBriu1npunK3p
ge1HaLRpWV4Dpip1LGe6KvhC/IfSn4nZKfupJYCrc/SC/QMlnmaKIQ7c2lHKWllU
KzRn0IfQHviSHdrgw77UqJ4fCg2igym1JKeodHsTpbTiru27mVGcoKXu5+/rAcV7
PxOa2CwqQUE3ogAcsAyslyxu2BKJs7dRifTGu/MeNpC1E3JujOJx1WcL6MmRpNL9
7fPTvb+fPLVjaGGW9Dp2Js+xiSXBtDZ348eLsZMIQkBRKmRAwzeDOmbVnpZIHsjb
iYwwLsHy9iNqNxm1gYmfExk1vCBX5qdnwawzwHKmSY8ldqL8Bdq3iJQPBe2YE9Dl
j2ihhBIyO9l77zDpEFH6gKJG2EywjBR++WGAMOr3iWhC3JIYCI9oDa1xs8KfPqeg
MjqKlODyaDX+aQDQ3DgbyOF+U/i/JcS8RicxUmqEX1PhpOT5zIH/zC7EZJ+nEuXZ
idC9l62LLAiq1yvtvw+5qG3k++uzd1fE7kHkK556vz0siZv7BgBnTi7YN1rfyhql
gHfevEtsfH9nUtskTwr8V3l4Js3VHxQ/saVNwId0PhEWHNaWKZpn/uPNLuQ6dZzl
/5+tyjgXG8WXynCVQCp7ciDkfdSGMGAGrs+HLvvUbehObB9jWtyRQQlTcy0Lh4+m
n2W1Q+8xRMgxxO/nY0W5
=kJC8
-----END PGP SIGNATURE-----

--sfyO1m2EN8ZOtJL6--
