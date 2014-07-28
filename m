Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaG1MAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:00:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38415 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751598AbaG1MAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:00:04 -0400
Date: Mon, 28 Jul 2014 13:56:53 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the slave-dma tree
Message-ID: <20140728115653.GF3952@lukather>
References: <20140728121856.56d0162e@canb.auug.org.au>
 <20140728071622.GY8181@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vA66WO2vHvL/CRSR"
Content-Disposition: inline
In-Reply-To: <20140728071622.GY8181@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vA66WO2vHvL/CRSR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 28, 2014 at 12:46:22PM +0530, Vinod Koul wrote:
> On Mon, Jul 28, 2014 at 12:18:56PM +1000, Stephen Rothwell wrote:
> > Hi Vinod,
> >=20
> > After merging the slave-dma tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/dma/sun6i-dma.c: In function 'sun6i_dma_dump_chan_regs':
> > drivers/dma/sun6i-dma.c:203:2: error: implicit declaration of function =
'__virt_to_phys' [-Werror=3Dimplicit-function-declaration]
> >   phys_addr_t reg =3D __virt_to_phys((unsigned long)pchan->base);
> >   ^
> >=20
> > Caused by commit 555859308723 ("dmaengine: sun6i: Add driver for the
> > Allwinner A31 DMA controller").  Presumably missing an include file.
> >=20
> > I have used the slave-dma tree from next-20140725 for today.
>=20
> Thanks, Feng's robot also gave such warning. SInce maxime didnt send any
> fixes it, I am applying below to fix this.
> We shouldnt have used __virt_to_phys here

Thanks for taking care of this.

>=20
> --x8---
> From: Vinod Koul <vinod.koul@intel.com>
> Date: Mon, 28 Jul 2014 11:57:25 +0530
> Subject: [PATCH 1/2] dmaengine: sun6i: fix build failure on x86, xilinx t=
argets
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> Since the driver defined COMPILE_TEST, it gets compiled for different arc=
h's.
> The driver uses __virt_to_phys() insteadof virt_to_phys, so replace it
>=20
> drivers/dma/sun6i-dma.c: In function =E2=80=98sun6i_dma_dump_chan_regs=E2=
=80=99:
> drivers/dma/sun6i-dma.c:203: error: implicit declaration of function '__v=
irt_to_phys'
>=20
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--vA66WO2vHvL/CRSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT1jqFAAoJEBx+YmzsjxAgJjcP/1MFzXQqdZl2alzedsCwIDdc
SWvqXJuUuxDM6m7Pna1YECs5ltxku0Lpv5o4XpX1tCKx01Xdx7kOrvOh+3D4ytLd
AIZmUfXs+wB0fTYAMvbWZfsj82ell+fF53dlyIUTqdSdE1TK3TE8nPTDcCy+Ryek
F/TuhYPJxFIOMYYwWcDQrTrPb4iowa5IsXGDYMs3XMFmCRbmA7TzuxQE7FMqLICK
GHniRJU7CC+Zd4oHymam27SjJwmeq9YHIFzz6cV+GuixBPCCwbBFf15ywJw6bAL0
hynGI6076yKUJUx3HfZGOlTsPR1upd+PnNScXwubYDQ5vTa22HD/OwFOG25IM8Vt
xsRbJmRy1nBibF4AqtgHHDlcQ03njyYu1Zf3Z+mb9E7ta9Fs6rcCCHwuhDLra7Yw
DfIp7Y6nyMIgufeltPVlIjhXsZ92Ty4NMT4Zeib96AOAnEFXZ0QT/OSnw+RgDWJI
aEvcDo7wmzJRIoVI3YLoRV2oVAFmkS2sDw6FNSJ6mV5IBgOKOd/WNoMYGqizHf56
p6gm+L0pd2A0cbKnurPjVa0MHnKjv3m0kbsaAjOrdQdxKPc7EnYQL6z3Xclglgei
GPmMml2IdOck3tdNZABDrflRMzVJ9ctQENCKkhAnzmNEdLJthDI30yVLtDIDgVsE
/O+nVJcAUkbmOabvPSKg
=+kEU
-----END PGP SIGNATURE-----

--vA66WO2vHvL/CRSR--
