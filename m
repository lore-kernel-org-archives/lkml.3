Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132AbaLLEmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 23:42:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:49056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934065AbaLLEm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 23:42:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,561,1413270000"; 
   d="asc'?scan'208";a="646454907"
Date: Fri, 12 Dec 2014 10:12:44 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, dma <dmaengine@vger.kernel.org>
Subject: [GIT PULL] dmaengine updates
Message-ID: <20141212044244.GL16827@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w/VI3ydZO+RcZ3Ux"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w/VI3ydZO+RcZ3Ux
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull to receive dmaengine updates, main features this time are:
    - BAM v1.3.0 support form qcom bam dma
    - support for Allwinner sun8i dma
    - atmels eXtended DMA Controller driver
    - chancnt cleanup by Maxime
    - fixes spread over drivers

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git for-linus

for you to fetch changes up to a9507ca3fb90987db5c6cc385885782cb05d4967:

  dmaenegine: Delete a check before free_percpu() (2014-12-09 14:56:55 +053=
0)

----------------------------------------------------------------
Andreas F=E4rber (1):
      Documentation: devicetree: Fix Xilinx VDMA specification

Andrew Jackson (1):
      dmaengine: pl330: Correct device assignment.

Archit Taneja (3):
      dmaengine: qcom_bam_dma: Generalize BAM register offset calculations
      dmaengine: qcom_bam_dma: Add BAM v1.3.0 support
      dt/bindings: dmaengine: qcom_bam_dma: Add compatible string for BAM v=
1.3.0

Chen-Yu Tsai (2):
      dmaengine: sun6i: support parameterized compatible strings
      dmaengine: sun6i: Add support for Allwinner A23 (sun8i) variant

Cyrille Pitchen (2):
      dmaengine: at_xdmac: fix software lockup at_xdmac_tx_status()
      dmaengine: at_xdmac: fix a bug in transfer residue computation

Jassi Brar (1):
      dmaengine: pl330: update author info

Jingchang Lu (1):
      dmaengine: fsl-edma: fixup reg offset and hw S/G support in big-endia=
n model

Jingoo Han (3):
      dma: imx-sdma: remove incorrect __init annotation from sdma_init()
      dmaengine: sirf: Add CONFIG_PM_SLEEP to suspend/resume functions
      dmaengine: k3dma: Add CONFIG_PM_SLEEP to suspend/resume functions

Julia Lawall (1):
      dmaengine: ste_dma40: fix error return code

Kiran Padwal (1):
      dmaengine: Remove .owner field for driver

Ludovic Desroches (8):
      dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller dr=
iver
      ARM: dts: at_xdmac: add bindings documentation
      MAINTAINERS: add entry for Atmel XDMA driver
      dmaengine: at_xdmac: prefer usage of readl/writel_relaxed
      dmaengine: at_xdmac: remove chancnt affectation
      dmaengine: at_xdmac: fix missing spin_unlock
      ARM: dts: at_xdmac: fix bad value of dma-cells in documentation
      dmaengine: at_xdmac: Add DMA_PRIVATE

Markus Elfring (1):
      dmaenegine: Delete a check before free_percpu()

Maxime Ripard (13):
      Documentation: dmaengine: Move the current doc to a folder of its own
      Documentation: dmaengine: Add a documentation for the dma controller =
API
      dmaengine: pl08x: Remove chancnt affectations
      dmaengine: bcm2835: Remove chancnt affectations
      dmaengine: jz4740: Remove chancnt affectations
      dmaengine: fsldma: Remove chancnt affectations
      dmaengine: k3: Remove chancnt affectations
      dmaengine: mpc512x: Remove chancnt affectations
      dmaengine: omap: Remove chancnt affectations
      dmaengine: sa11x0: Remove chancnt affectations
      dmaengine: sh: Remove chancnt affectations
      dmaengine: sirf: Remove chancnt affectations
      dmaengine: sun6i: Remove chancnt affectations

Michele Curti (1):
      drivers/dma/pch_dma: declare pch_dma_id_table as static

Nicolin Chen (1):
      dmaengine: imx-sdma: Add a new DMATYPE for SAI

Prarit Bhargava (1):
      dmaengine: ioatdma: fix dma mapping errors

Sascha Hauer (1):
      dma: imx-sdma: clarify about firmware not found error

Sebastian Andrzej Siewior (2):
      dma: cppi41: wait longer for the HW to return the descriptor
      dma: cppi41: add a delay while setting the TD bit

Srikanth Thokala (3):
      dmaengine: xilinx: vdma: Check if the segment list is empty in a desc=
riptor
      dmaengine: xilinx: vdma: Allow only one chunk in a line
      dmaengine: xilinx: vdma: icg should be difference of stride and hsize

Stefan Agner (1):
      dmaengine: fsl-edma: fix calculation of remaining bytes

Vinod Koul (7):
      Documentation: dmanegine: move dmatest.txt to dmaengine folder
      MAINTAINERS: add Documentation files to dmaengine entry
      dmaengine: at_xdmac: fix usage of read, write wrappers
      dmaengine: xdmac: fix print warning on size_t variable
      dmaengine: xdmac: fix print warning on dma_addr_t variable
      Merge branch 'topic/at_xdmac' into for-linus
      dmaengine: clarify the issue_pending expectations

Yoshihiro Shimoda (1):
      dmaengine: shdma: fix a race condition in __ld_cleanup()

kbuild test robot (1):
      dmaengine: at_xdmac: fix semicolon.cocci warnings

 .../devicetree/bindings/dma/atmel-xdma.txt         |   54 +
 .../devicetree/bindings/dma/fsl-imx-sdma.txt       |    1 +
 .../devicetree/bindings/dma/qcom_bam_dma.txt       |    4 +-
 .../devicetree/bindings/dma/sun6i-dma.txt          |    2 +-
 .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |    2 +-
 .../{dmaengine.txt =3D> dmaengine/client.txt}        |    0
 Documentation/{ =3D> dmaengine}/dmatest.txt          |    0
 Documentation/dmaengine/provider.txt               |  366 +++++
 MAINTAINERS                                        |   10 +-
 drivers/dma/Kconfig                                |   11 +-
 drivers/dma/Makefile                               |    1 +
 drivers/dma/amba-pl08x.c                           |    2 -
 drivers/dma/at_xdmac.c                             | 1524 ++++++++++++++++=
++++
 drivers/dma/bcm2835-dma.c                          |    3 -
 drivers/dma/cppi41.c                               |   12 +-
 drivers/dma/dma-jz4740.c                           |    4 +-
 drivers/dma/dmaengine.c                            |    3 +-
 drivers/dma/fsl-edma.c                             |  191 +--
 drivers/dma/fsldma.c                               |    1 -
 drivers/dma/imx-sdma.c                             |    6 +-
 drivers/dma/ioat/dma_v3.c                          |   35 +-
 drivers/dma/iop-adma.c                             |    1 -
 drivers/dma/k3dma.c                                |    4 +-
 drivers/dma/mmp_pdma.c                             |    1 -
 drivers/dma/mmp_tdma.c                             |    1 -
 drivers/dma/mpc512x_dma.c                          |   13 +-
 drivers/dma/nbpfaxi.c                              |    1 -
 drivers/dma/omap-dma.c                             |    2 -
 drivers/dma/pch_dma.c                              |    2 +-
 drivers/dma/pl330.c                                |    7 +-
 drivers/dma/qcom_bam_dma.c                         |  231 ++-
 drivers/dma/s3c24xx-dma.c                          |    1 -
 drivers/dma/sa11x0-dma.c                           |    3 +-
 drivers/dma/sh/rcar-audmapp.c                      |    3 -
 drivers/dma/sh/rcar-hpbdma.c                       |    3 -
 drivers/dma/sh/shdma-base.c                        |    4 +-
 drivers/dma/sh/shdma-of.c                          |    1 -
 drivers/dma/sh/shdmac.c                            |    2 -
 drivers/dma/sh/sudmac.c                            |    3 -
 drivers/dma/sirf-dma.c                             |    5 +-
 drivers/dma/ste_dma40.c                            |    1 +
 drivers/dma/sun6i-dma.c                            |  122 +-
 drivers/dma/tegra20-apb-dma.c                      |    1 -
 drivers/dma/timb_dma.c                             |    1 -
 drivers/dma/xilinx/xilinx_vdma.c                   |   13 +-
 include/dt-bindings/dma/at91.h                     |   25 +
 include/linux/dmaengine.h                          |    3 +-
 include/linux/platform_data/dma-imx.h              |    1 +
 48 files changed, 2416 insertions(+), 271 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/atmel-xdma.txt
 rename Documentation/{dmaengine.txt =3D> dmaengine/client.txt} (100%)
 rename Documentation/{ =3D> dmaengine}/dmatest.txt (100%)
 create mode 100644 Documentation/dmaengine/provider.txt
 create mode 100644 drivers/dma/at_xdmac.c

--=20
~Vinod

--w/VI3ydZO+RcZ3Ux
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJUinJEAAoJEHwUBw8lI4NHOSsP/AlxZScLRZT8MOsHKxVVPmRg
CfkgFMV/pWPZyh3J5SkvrorYdNc6UnUa67pzOETBb9tUzeCdqMlHmX8C0Cs/J4YF
wW+MsykMRd6CQZIEcQcEFfzmf/vxHYDbXZAO+qduCsKnHWQqqtUgJX8SidLTexht
aS+HrSP8fxtnjwmlyd0/FW4UdnhQpt28sLT3hoaz5H2SFVOThCOnzDxiEIRZ2Xzb
mFVCwITGooxSZ2owxq14QOwWvBGaIh9jscPjMr/mj9WvwU8EbkzpPLN8mja90Oal
LhX43V3VaJrWU3rQAj3VNLSyJF+Fg1nxxIIRHd6eAJHfMa2lDWGQ6UEKUpo4klJ1
GKGheuwd6DBc/jT9F4fwy2FEn19Qh+NCkdfRFiMpTyJBKkhHZrOQkpwgzZTC/POz
cCVsegswWTZ1WwEPvPLxoScWu823falQDdgDHPRqhkOgij3kwJVpmO2efdTYtiBP
TbQ3s8SvS5cpGoE5lo1zsDIEypHKFVY+HBYvQl5eFhFjwtwDm1YXP1IqxM/271yb
D895os9STaGKp/Epf/ePWo8B+CqYf/uRpcgwBVWtz6A4UIuXeR5ghNRHbNudufL+
UJ9d/u2QQA0nORSy34p1skkgn39DP4TCwBluIZ7y6EsK+e+CXA23dzd4tXXgOMJI
yfDpBWae6Sm6e3+PSNzj
=w6w5
-----END PGP SIGNATURE-----

--w/VI3ydZO+RcZ3Ux--
