Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaFJQam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:30:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:28757 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaFJQak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:30:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1009,1392192000"; 
   d="asc'?scan'208";a="545791449"
Date: Tue, 10 Jun 2014 21:41:50 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, dma <dmaengine@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] slave dmaengine updates
Message-ID: <20140610161150.GB25075@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please Pull to receive:
 New Xilixn VDMA driver from Srikanth.
 Bunch of updates for edma driver by Thomas, Joel and Peter.
 Fixes and updates on dw, ste_dma, freescale, mpc512x, sudmac etc

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:
  Linus Torvalds (1):
        Linux 3.15-rc2

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git for-linus

Alexander Popov (5):
      dma: mpc512x: reorder mpc8308 specific instructions
      dma: mpc512x: separate 'compatible' values for MPC512x and MPC8308
      dma: mpc512x: fix freeing resources in mpc_dma_probe() and mpc_dma_re=
move()
      dmaengine: fix comment typo
      dmaengine: mpc512x: add support for peripheral transfers

Andy Shevchenko (6):
      dmaengine: dw: move PM to suspend_late / resume_early stages
      dmaengine: dw: convert to use SET_LATE_SYSTEM_SLEEP_PM_OPS
      dmaengine: dw: went back to plain {request,free}_irq() calls
      dmaengine: dw: enable clock before access
      dmaengine: dw: fix regression in dw_probe() function
      dmaengine: dw: check return code of dma_async_device_register()

Arnd Bergmann (2):
      dmaengine: omap: hide filter_fn for built-in drivers
      dmaengine: sa11x0: remove broken #ifdef

Daniel Mack (1):
      dma: mmp_pdma: add support for residue reporting

Fabio Estevam (1):
      dmaengine: Kconfig: Update MXS_DMA help text to include MX6Q/MX6DL

Geert Uytterhoeven (1):
      of: dma: Grammar s/requests/request/, s/used required/required/

Hongbo Zhang (5):
      DMA: Freescale: remove the unnecessary FSL_DMA_LD_DEBUG
      DMA: Freescale: unify register access methods
      DMA: Freescale: remove attribute DMA_INTERRUPT of dmaengine
      DMA: Freescale: add fsl_dma_free_descriptor() to reduce code duplicat=
ion
      DMA: Freescale: move functions to avoid forward declarations

Jean Delvare (1):
      dma: pch_dma: Fix Kconfig dependencies

Jiada Wang (1):
      dmaengine: imx: correct sdmac->status for cyclic dma tx

Jingoo Han (1):
      dma: remove DEFINE_PCI_DEVICE_TABLE macro

Joel Fernandes (4):
      dmaengine: edma: Add DMA memcpy support
      dmaengine: edma: No need save/restore interrupt flags during spin_loc=
k in IRQ
      dmaengine: edma: Document variables used for residue accounting
      dmaengine: edma: update DMA memcpy to use new param element

Kuninori Morimoto (2):
      DMA: shdma: tidyup callback chunk finder
      DMA: shdma: add cyclic transfer support

Laurent Pinchart (9):
      dma: mmp_pdma: Fix the #dma-channels DT property documentation
      dma: mmp_pdma: Simplify access to channel drcmr value
      dma: mmp_pdma: Fix physical channel memory allocation size
      dmaengine: shdmac: Keep #include sorted alphabetically
      dmaengine: shdmac: Include linux/err.h
      dmaengine: sudmac: Keep #include sorted alphabetically
      dmaengine: sudmac: Include linux/err.h
      dmaengine: rcar-hpbdma: Include linux/err.h
      dmaengine: shdma: Enable driver compilation with COMPILE_TEST

Peter Ujfalusi (10):
      platform_data: edma: Be precise with the paRAM struct
      arm: common: edma: Save the number of event queues/TCs
      dmaengine: edma: Correct the handling of src/dst_maxburst =3D=3D 0
      dmaengine: edma: Add support for DMA_PAUSE/RESUME operation
      dmaengine: edma: Set DMA_CYCLIC capability flag
      dmaengine: edma: Reduce debug print verbosity for non verbose debuggi=
ng
      dmaengine: edma: Implement device_slave_caps callback
      dmaengine: edma: Prefix debug prints where the text were identical in=
 prep callbacks
      dmaengine: edma: Print the direction value as well when it is not sup=
ported
      dmaengine: edma: Add channel number to debug prints

Srikanth Thokala (2):
      dma: Add Xilinx Video DMA DT Binding Documentation
      dma: Add Xilinx AXI Video Direct Memory Access Engine driver support

Thomas Gleixner (6):
      dmaengine: edma: Sanitize residue reporting
      dmaengine: edma: Check the current decriptor first in tx_status()
      dmaengine: edma: Create private pset struct
      dmaengine: edma: Store transfer data in edma_desc and edma_pset
      dmaengine: edma: Make reading the position of active channels work
      dmaengine: edma: Provide granular accounting

Ulf Hansson (5):
      dma: ste_dma40: Maintain spinlock order while handling pause
      dma: ste_dma40: Don't require CONFIG_PM_RUNTIME
      dma: ste_dma40: Convert to PM macros while providing the PM callbacks
      dma: ste_dma40: Fixup system suspend/resume
      dma: ste_dma40: Convert to the late system PM callbacks

Vasily Khoruzhick (2):
      dmaengine: s3c24xx-dma: Process whole SG chain
      dmaengine: s3c24xx-dma: Add cyclic transfer support

Vinod Koul (6):
      dmaengine: pch: fix compilation for alpha target
      dmaengine: sh: make shdma_prep_dma_cyclic static
      dmaengine: sh: fix print specifier warnings
      dmaengine: sh: don't use dynamic static allocation
      Merge branch 'topic/dw' into for-linus
      Merge branch 'topic/xilinx' into for-linus

 Documentation/devicetree/bindings/dma/dma.txt      |    4 +-
 Documentation/devicetree/bindings/dma/mmp-dma.txt  |   11 +-
 .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   75 ++
 arch/arm/common/edma.c                             |   28 +-
 arch/powerpc/boot/dts/mpc8308_p1m.dts              |    2 +-
 arch/powerpc/boot/dts/mpc8308rdb.dts               |    2 +-
 drivers/dma/Kconfig                                |   18 +-
 drivers/dma/Makefile                               |    1 +
 drivers/dma/dw/core.c                              |   58 +-
 drivers/dma/dw/pci.c                               |   12 +-
 drivers/dma/dw/platform.c                          |   18 +-
 drivers/dma/edma.c                                 |  335 ++++--
 drivers/dma/fsldma.c                               |  306 ++---
 drivers/dma/imx-sdma.c                             |    2 -
 drivers/dma/mmp_pdma.c                             |   95 ++-
 drivers/dma/mpc512x_dma.c                          |  342 +++++-
 drivers/dma/pch_dma.c                              |    3 +-
 drivers/dma/s3c24xx-dma.c                          |  113 ++-
 drivers/dma/sa11x0-dma.c                           |    4 -
 drivers/dma/sh/Kconfig                             |    2 +-
 drivers/dma/sh/rcar-hpbdma.c                       |    1 +
 drivers/dma/sh/shdma-base.c                        |   98 ++-
 drivers/dma/sh/shdmac.c                            |   15 +-
 drivers/dma/sh/sudmac.c                            |    7 +-
 drivers/dma/ste_dma40.c                            |  182 ++--
 drivers/dma/xilinx/Makefile                        |    1 +
 drivers/dma/xilinx/xilinx_vdma.c                   | 1379 ++++++++++++++++=
++++
 include/linux/amba/xilinx_dma.h                    |   47 +
 include/linux/dmaengine.h                          |    2 +-
 include/linux/omap-dma.h                           |    2 +-
 include/linux/platform_data/edma.h                 |   20 +-
 include/linux/shdma-base.h                         |    1 +
 32 files changed, 2694 insertions(+), 492 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdm=
a.txt
 create mode 100644 drivers/dma/xilinx/Makefile
 create mode 100644 drivers/dma/xilinx/xilinx_vdma.c
 create mode 100644 include/linux/amba/xilinx_dma.h


Thanks
--=20
~Vinod

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTly5GAAoJEHwUBw8lI4NH0uoP/AkS8W5xEz/BeBTvBX/4YX9B
kb4SycPqZFFrJtCoH3/YekUY1XiXyTyTdUDsH6iuILKzJzJS/0AtIhMDPVA11mha
WenZWX1Vy5toqhvVtwHV/j1klFS0/eauXSf3SxAbqIIDmxdiN0CO4xkKpkRjWNl2
eoWb/qkQwOk06EiBAOLrAB8as73tvrLamlCJbU1qw5aFs/u+HEwHVl2HPETlChdH
HF9heMFmiBFExbxoweyD8Fxy6G1nMQITpD7F5CzI175tAf3/gJQfw+mrGp2U41TH
8znSVSNsCUcC6UXihreVR6JU+wSNyIKuiTPoOksT8t74n3FoFfWdUEleJd4ytE0j
eMhbOcXM/mtaje+rJE1MRJdWReDMjTb2kIjie16Xn8eB2wQoanuH/9/SIGmWCBgj
NDCqUXd/RhdsIfFi0icR4b9e1AcNuFMcKfCX1AWKNoaGay1Fu0E+NlcgkYiQLu0/
5Ni5/cbS52XTvu8KUerm8GXe+5ckFLWUTKA4MVZU06AD1LoQK3ZCSmDaPsmNjPXw
puOShTK655AYOYBfF1LXbXnI5v79Sp3PkWUWFZ8JZeV57+m67ym+V4+mmSwzf0xN
gZ1RWI7rg9C8sX5AnVoQG+Sbdu4Wx3IBbhRZ+Tb7Dff343GrfOlQOw2x36VOG8Zj
urNEoowpZzSnf7AFgDxu
=s2IF
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
