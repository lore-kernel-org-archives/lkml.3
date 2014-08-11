Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaHKF6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:58:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:20487 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbaHKF6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:58:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="asc'?scan'208";a="574818242"
Date: Mon, 11 Aug 2014 11:16:03 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dma <dmaengine@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, vinod.koul@intel.com
Subject: [GIT PULL] slave dmaengine updates
Message-ID: <20140811054603.GB13288@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here is the pull request for 3.17.

Some notable changes are:
 - New driver for AMBA AXI NBPF by Guennadi
 - New driver for sun6i controller by Maxime
 - pl330 drivers fixes from Lar's
 - sh-dma updates and fixes from Laurent, Geert and Kuninori
 - Documentation updates from Geert
 - drivers fixes and updates spread over dw, edma, freescale, mpc512x etc..


The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:
  Linus Torvalds (1):
        Linux 3.16-rc5

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git for-linus

Alexander Popov (4):
      dmaengine: mpc512x: add device tree binding document
      dmaengine: of: add common xlate function for matching by channel id
      dmaengine: mpc512x: register for device tree channel lookup
      dmaengine: of: kconfig: select DMA_ENGINE when DMA_OF is selected

Alexandre Belloni (1):
      dma: at_hdmac: fix invalid remaining bytes detection

Andy Gross (1):
      dmaengine: qcom_bam_dma: Add descriptor flags

Andy Shevchenko (3):
      dmaengine: dw: introduce dwc_dostart_first_queued() helper
      dmaengine: dw: add debug message to dwc_dostart_first_queued
      dmaengine: dw: don't perform DMA when dmaengine_submit is called

Bjorn Helgaas (1):
      dmaengine: jz4740: Fix GPL v2 license string typo

Fengguang Wu (1):
      dmaengine: nbpf_error_get_channel() can be static

Geert Uytterhoeven (6):
      dmaengine: shdma: Add more register documentation
      dmaengine: Update documentation for inline wrappers
      sh: dma: Use defines instead of hardcoded numbers
      dmaengine: shdma: Use defines instead of hardcoded numbers
      dmaengine: Clarify device parameter for dma_sync_*_for_*()
      dmaengine: Remove unused definition of DMA_MAX_COOKIE

Guennadi Liakhovetski (5):
      dmaengine: add device tree binding documentation for the nbpfaxi driv=
er
      dmaengine: add a driver for AMBA AXI NBPF DMAC IP cores
      dmaengine: nbpfaxi: fix a theoretical race
      dmaengine: nbpfaxi: convert to tasklet
      dmaengine: nbpfaxi: don't build this driver where it cannot be used

Hongbo Zhang (3):
      dmaengine: Freescale: use spin_lock_bh instead of spin_lock_irqsave
      dmaengine: Freescale: add suspend resume functions for DMA driver
      dmaengine: Freescale: change descriptor release process for supportin=
g async_tx

Javier Martinez Canillas (1):
      dmaengine: pl330: Check if the DMA descriptor is NULL

Jingchang Lu (1):
      dmaengine: fsl-edma: fix dmamux index calculating error

Joe Perches (1):
      dmaengine: Use dma_zalloc_coherent

Kuninori Morimoto (3):
      dma: rcar-audmapp: enable .set_slave
      dma: rcar-audmapp: don't keep audmapp_slave_config for each channeles
      dma: rcar-audmapp: add DT support

Lars-Peter Clausen (15):
      dmaengine: pl330: Use dma_transfer_direction instead of custom pl330_=
reqtype
      dmaengine: pl330: Remove duplicated cachecontrol enum
      dmaengine: pl330: Remove unused pl330_chanstatus struct
      dmaengine: pl330: Remove unused dmac_reset callback
      dmaengine: pl330: Remove unused client_data field form pl330_info
      dmaengine: pl330: Remove unused next field form pl330_xfer struct
      dmaengine: pl330: Remove unused mc_len field from _pl330_req struct
      dmaengine: pl330: Remove useless xfer_cb indirection
      dmaengine: pl330: Change type pl330_chid from void * to struct pl330_=
thread *
      dmaengine: pl330: Remove uneccessary ccr validation
      dmaengine: pl330: Simplify is_manager()
      dmaengine: pl330: Merge dma_pl330_dmac and pl330_dmac structs
      dmaengine: pl330: Embed pl330_req directly into dma_pl330_desc
      dmaengine: pl330: Simplify marking a request as unused
      dmaengine: pl330: Remove pl330_chan_ctrl()

Laurent Pinchart (5):
      dmaengine: sh: Rework Kconfig and Makefile
      dmaengine: shdma: Make channel filter ignore unrelated devices
      dmaengine: shdma: Allocate cyclic sg list dynamically
      dmaengine: rcar-dmac: Add device tree bindings documentation
      dmaengine: Remove the context argument to the prep_dma_cyclic operati=
on

Linus Walleij (1):
      dmaengine: dma40: add signal documentation to the device tree bindings

Mark Brown (1):
      dma: pl08x: Use correct specifier for size_t values

Maxime Ripard (6):
      Documentation: dt: Add Allwinner A31 DMA controller bindings
      dmaengine: sun6i: Add driver for the Allwinner A31 DMA controller
      dmaengine: sun6i: Remove switch statement from buswidth convertion ro=
utine
      dmaengine: sun6i: Free the interrupt before killing the tasklet
      dmaengine: sun6i: Fix memory leaks
      dmaengine: sun6i: depends on RESET_CONTROLLER

Nicolin Chen (2):
      dmaengine: imx-sdma: Save imx_dma_data into sdmac
      dmaengine: imx-sdma: Add a new DMATYPE for Shared Peripheral ASRC

Peter Ujfalusi (7):
      dmaengine: edma: Update caps->residue_granularity to match with reali=
ty
      dmaengine: edma: Support to suppress the period interrupts in cyclic =
mode
      ARM: edma: Set default queue to lowest priority
      ARM: edma: Add edma_assign_channel_eventq() to move channel to a give=
 queue
      dmaengine: edma: Serve cyclic (audio) channels with high priority que=
ue
      dmaengine: edma: Do not change the error code returned from edma_allo=
c_slot
      dmaengine: edma: Do not register second device when booted with DT

Vinod Koul (5):
      Merge commit 'renesas-shdma-for-v3.17' into for-linus
      dmaengine: ipu: use return value of request_irq
      dmaengine: sun6i: fix build failure on x86, xilinx targets
      dmaengine: sun61: fix warning on bad print specfier
      Merge commit 'renesas-rcar-audmapp-for-v3.17' into for-linus

Wolfram Sang (1):
      dmaengine: inherit debug settings from the subsystem for subdirectori=
es

 .../devicetree/bindings/dma/fsl-imx-sdma.txt       |    1 +
 .../devicetree/bindings/dma/mpc512x-dma.txt        |   29 +
 Documentation/devicetree/bindings/dma/nbpfaxi.txt  |   61 +
 .../devicetree/bindings/dma/rcar-audmapp.txt       |   29 +
 .../devicetree/bindings/dma/renesas,rcar-dmac.txt  |   98 ++
 .../devicetree/bindings/dma/ste-dma40.txt          |   74 +-
 .../devicetree/bindings/dma/sun6i-dma.txt          |   45 +
 Documentation/dmaengine.txt                        |   17 +-
 arch/arm/common/edma.c                             |   31 +-
 arch/powerpc/boot/dts/mpc5121.dtsi                 |    1 +
 arch/sh/drivers/dma/dma-sh.c                       |    2 +-
 arch/sh/include/asm/dma-register.h                 |   36 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c             |   24 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c             |   48 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c             |   64 +-
 drivers/dma/Kconfig                                |   17 +
 drivers/dma/Makefile                               |    6 +-
 drivers/dma/TODO                                   |    1 -
 drivers/dma/amba-pl08x.c                           |    6 +-
 drivers/dma/at_hdmac.c                             |   15 +-
 drivers/dma/bcm2835-dma.c                          |    2 +-
 drivers/dma/dma-jz4740.c                           |    4 +-
 drivers/dma/dw/core.c                              |   42 +-
 drivers/dma/edma.c                                 |   23 +-
 drivers/dma/ep93xx_dma.c                           |    4 +-
 drivers/dma/fsl-edma.c                             |    8 +-
 drivers/dma/fsldma.c                               |  297 +++-
 drivers/dma/fsldma.h                               |   32 +-
 drivers/dma/imx-dma.c                              |    2 +-
 drivers/dma/imx-sdma.c                             |   17 +-
 drivers/dma/ipu/ipu_idmac.c                        |   14 +-
 drivers/dma/mmp_pdma.c                             |    2 +-
 drivers/dma/mmp_tdma.c                             |    2 +-
 drivers/dma/mpc512x_dma.c                          |   13 +-
 drivers/dma/mxs-dma.c                              |   10 +-
 drivers/dma/nbpfaxi.c                              | 1517 ++++++++++++++++=
++++
 drivers/dma/of-dma.c                               |   35 +
 drivers/dma/omap-dma.c                             |    3 +-
 drivers/dma/pl330.c                                |  964 +++++--------
 drivers/dma/qcom_bam_dma.c                         |   20 +-
 drivers/dma/s3c24xx-dma.c                          |    3 +-
 drivers/dma/sa11x0-dma.c                           |    2 +-
 drivers/dma/sh/Kconfig                             |   24 +-
 drivers/dma/sh/Makefile                            |   16 +-
 drivers/dma/sh/rcar-audmapp.c                      |  114 ++-
 drivers/dma/sh/shdma-arm.h                         |    4 +-
 drivers/dma/sh/shdma-base.c                        |  103 +-
 drivers/dma/sh/shdma.h                             |    2 +-
 drivers/dma/sh/shdmac.c                            |   15 +-
 drivers/dma/sirf-dma.c                             |    2 +-
 drivers/dma/ste_dma40.c                            |    3 +-
 drivers/dma/sun6i-dma.c                            | 1053 ++++++++++++++
 drivers/dma/tegra20-apb-dma.c                      |    2 +-
 include/dt-bindings/dma/nbpfaxi.h                  |   20 +
 include/linux/dmaengine.h                          |    5 +-
 include/linux/of_dma.h                             |    4 +
 include/linux/platform_data/dma-imx.h              |    1 +
 include/linux/platform_data/edma.h                 |    2 +
 include/linux/sh_dma.h                             |   24 +-
 59 files changed, 4031 insertions(+), 984 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/mpc512x-dma.txt
 create mode 100644 Documentation/devicetree/bindings/dma/nbpfaxi.txt
 create mode 100644 Documentation/devicetree/bindings/dma/rcar-audmapp.txt
 create mode 100644 Documentation/devicetree/bindings/dma/renesas,rcar-dmac=
=2Etxt
 create mode 100644 Documentation/devicetree/bindings/dma/sun6i-dma.txt
 create mode 100644 drivers/dma/nbpfaxi.c
 create mode 100644 drivers/dma/sun6i-dma.c
 create mode 100644 include/dt-bindings/dma/nbpfaxi.h

Thanks
--=20
~Vinod

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIbBAEBAgAGBQJT6FibAAoJEHwUBw8lI4NHjhQP92EsD7SQBg2O7uqCv7811UbM
NhSQnggBQUgY2NNKPabcMt7MWH78X+gLkfPd3rmxLZP9QBrJMWGwhENxtJYMAfCw
LOcYSo95PiJFxap8cvXX4VT+kaeyTNy1VAKIyczzwg5PDbhVu1nUm00MEs5ipjx0
MNhVwDNaqaBFTJbdOhCkLA1VFKAml1rsaN/k3owKgk05KvPhSNiQDEYIt31vt6jC
9/set83CAHegGZU/kI+E3ayeiGlH/5AzIDPHSoZHTLzqrCA/7veI8W6NxPQ2cTRp
pN3wB2iegF8XO/GbdiuMW8PylPN8rGJGw1qdjs4s0E4jdGbR7z7sm5wqlPSL/Hoj
mH26Fy9csAmpWQl2PEKA5R9tw+ywhyhSTEvIeIxv27kodOiR7z29anyPkZakZlkw
nVIZz5VNim8JSBEZQS8xtPWgP/07ik2IeyIuulDY33sHvYk2ZK1XMIzaLCIwU+6Y
oGO/1hqQZ1ceuxWPOVP6Z8jFzg1+ALruDg/6aZPqZKlp1u9odkwnpAKcGkaOyykn
MPBQUvtyOyp9/hGlgWZvD+YaXqZo7I5s999MLQK40C7duUrW095mpZPCHF3T9one
wqpJNlF6gyyumcAG2CuLdhGlqlm9V53hBGRByqDWVsq7silP0J+0nXFZBGUAacvJ
MMQw7SPMSMgn1UvmJNI=
=2XO0
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
