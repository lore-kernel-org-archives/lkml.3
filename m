Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaHNTdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 15:33:10 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:56448 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbaHNTdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 15:33:07 -0400
Date: Thu, 14 Aug 2014 13:33:03 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benoit Taine <benoit.taine@lip6.fr>
Subject: [GIT PULL] PCI changes for v3.17 (part 2)
Message-ID: <20140814193303.GA1063@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's another change I'd like to have in v3.17-rc1.  It's a mechanical
change that removes uses of the DEFINE_PCI_DEVICE_TABLE macro.  I waited
until later in the merge window to reduce conflicts, but it's possible
you'll still see a few.

The original discussion (subject "Replace DEFINE_PCI_DEVICE_TABLE macro
use") is here:

http://lkml.kernel.org/r/1405697232-11785-1-git-send-email-benoit.taine@lip6.fr

Bjorn


The following changes since commit c8d6637d0497d62093dbba0694c7b3a80b79bfe1:

  Merge tag 'modules-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux (2014-08-10 21:31:58 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.17-changes-2

for you to fetch changes up to 9baa3c34ac4e27f7e062f266f50cc5dbea26a6c1:

  PCI: Remove DEFINE_PCI_DEVICE_TABLE macro use (2014-08-12 12:15:14 -0600)

----------------------------------------------------------------
PCI changes for the v3.17 merge window (part 2):

  Miscellaneous
    - Remove DEFINE_PCI_DEVICE_TABLE macro use (Benoit Taine)

----------------------------------------------------------------
Benoit Taine (1):
      PCI: Remove DEFINE_PCI_DEVICE_TABLE macro use

 arch/x86/kernel/cpu/perf_event_intel_uncore.c        | 10 +++++-----
 arch/x86/kernel/iosf_mbi.c                           |  2 +-
 drivers/block/mtip32xx/mtip32xx.c                    |  2 +-
 drivers/block/rsxx/core.c                            |  2 +-
 drivers/block/skd_main.c                             |  2 +-
 drivers/crypto/ccp/ccp-pci.c                         |  2 +-
 drivers/gpu/drm/ast/ast_drv.c                        |  2 +-
 drivers/gpu/drm/bochs/bochs_drv.c                    |  2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c                  |  2 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c               |  2 +-
 drivers/gpu/drm/gma500/psb_drv.c                     |  2 +-
 drivers/gpu/drm/mgag200/mgag200_drv.c                |  2 +-
 drivers/gpu/drm/qxl/qxl_drv.c                        |  2 +-
 drivers/infiniband/hw/qib/qib_init.c                 |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c          |  2 +-
 drivers/mmc/host/dw_mmc-pci.c                        |  2 +-
 drivers/net/arcnet/com20020-pci.c                    |  2 +-
 drivers/net/can/c_can/c_can_pci.c                    |  3 ++-
 drivers/net/can/pch_can.c                            |  2 +-
 drivers/net/can/sja1000/ems_pci.c                    |  2 +-
 drivers/net/can/sja1000/kvaser_pci.c                 |  2 +-
 drivers/net/can/sja1000/peak_pci.c                   |  2 +-
 drivers/net/can/sja1000/plx_pci.c                    |  2 +-
 drivers/net/ethernet/3com/3c59x.c                    |  2 +-
 drivers/net/ethernet/3com/typhoon.c                  |  2 +-
 drivers/net/ethernet/8390/ne2k-pci.c                 |  2 +-
 drivers/net/ethernet/adaptec/starfire.c              |  2 +-
 drivers/net/ethernet/alteon/acenic.c                 |  2 +-
 drivers/net/ethernet/amd/pcnet32.c                   |  2 +-
 drivers/net/ethernet/atheros/alx/main.c              |  2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c      |  2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c      |  2 +-
 drivers/net/ethernet/atheros/atlx/atl1.c             |  2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c             |  2 +-
 drivers/net/ethernet/broadcom/b44.c                  |  2 +-
 drivers/net/ethernet/broadcom/bnx2.c                 |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c     |  2 +-
 drivers/net/ethernet/broadcom/tg3.c                  |  6 +++---
 drivers/net/ethernet/brocade/bna/bnad.c              |  2 +-
 drivers/net/ethernet/chelsio/cxgb/subr.c             |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c      |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c      |  2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c  |  2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c          |  2 +-
 drivers/net/ethernet/dec/tulip/de2104x.c             |  2 +-
 drivers/net/ethernet/dec/tulip/de4x5.c               |  2 +-
 drivers/net/ethernet/dec/tulip/dmfe.c                |  2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c          |  4 ++--
 drivers/net/ethernet/dec/tulip/uli526x.c             |  2 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c         |  2 +-
 drivers/net/ethernet/dec/tulip/xircom_cb.c           |  2 +-
 drivers/net/ethernet/dlink/dl2k.h                    |  2 +-
 drivers/net/ethernet/dlink/sundance.c                |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c          |  2 +-
 drivers/net/ethernet/fealnx.c                        |  2 +-
 drivers/net/ethernet/hp/hp100.c                      |  2 +-
 drivers/net/ethernet/icplus/ipg.c                    |  2 +-
 drivers/net/ethernet/intel/e100.c                    |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c        |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c          |  2 +-
 drivers/net/ethernet/intel/i40evf/i40evf_main.c      |  2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c            |  2 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c          |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c        |  2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c    |  2 +-
 drivers/net/ethernet/jme.c                           |  2 +-
 drivers/net/ethernet/marvell/skge.c                  |  2 +-
 drivers/net/ethernet/marvell/sky2.c                  |  2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c            |  2 +-
 drivers/net/ethernet/micrel/ksz884x.c                |  2 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c     |  2 +-
 drivers/net/ethernet/natsemi/natsemi.c               |  2 +-
 drivers/net/ethernet/natsemi/ns83820.c               |  2 +-
 drivers/net/ethernet/neterion/s2io.c                 |  2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c       |  2 +-
 drivers/net/ethernet/nvidia/forcedeth.c              |  2 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c |  2 +-
 drivers/net/ethernet/packetengines/hamachi.c         |  2 +-
 drivers/net/ethernet/packetengines/yellowfin.c       |  2 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c             |  2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |  2 +-
 drivers/net/ethernet/qlogic/qla3xxx.c                |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c     |  2 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c         |  2 +-
 drivers/net/ethernet/rdc/r6040.c                     |  2 +-
 drivers/net/ethernet/realtek/8139too.c               |  2 +-
 drivers/net/ethernet/realtek/r8169.c                 |  2 +-
 drivers/net/ethernet/sfc/efx.c                       |  2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                  |  2 +-
 drivers/net/ethernet/silan/sc92031.c                 |  2 +-
 drivers/net/ethernet/sis/sis190.c                    |  2 +-
 drivers/net/ethernet/sis/sis900.c                    |  3 ++-
 drivers/net/ethernet/smsc/epic100.c                  |  2 +-
 drivers/net/ethernet/smsc/smsc9420.c                 |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c     |  2 +-
 drivers/net/ethernet/sun/cassini.c                   |  2 +-
 drivers/net/ethernet/sun/niu.c                       |  2 +-
 drivers/net/ethernet/sun/sungem.c                    |  2 +-
 drivers/net/ethernet/sun/sunhme.c                    |  2 +-
 drivers/net/ethernet/tehuti/tehuti.c                 |  2 +-
 drivers/net/ethernet/ti/tlan.c                       |  2 +-
 drivers/net/ethernet/toshiba/spider_net.c            |  2 +-
 drivers/net/ethernet/toshiba/tc35815.c               |  2 +-
 drivers/net/ethernet/via/via-rhine.c                 |  2 +-
 drivers/net/ethernet/via/via-velocity.c              |  2 +-
 drivers/net/fddi/defxx.c                             |  2 +-
 drivers/net/fddi/skfp/skfddi.c                       |  2 +-
 drivers/net/hippi/rrunner.c                          |  2 +-
 drivers/net/irda/donauboe.c                          |  2 +-
 drivers/net/irda/via-ircc.c                          |  2 +-
 drivers/net/irda/vlsi_ir.c                           |  2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                    |  2 +-
 drivers/net/wan/dscc4.c                              |  2 +-
 drivers/net/wan/farsync.c                            |  2 +-
 drivers/net/wan/lmc/lmc_main.c                       |  2 +-
 drivers/net/wan/pc300too.c                           |  2 +-
 drivers/net/wan/pci200syn.c                          |  2 +-
 drivers/net/wan/wanxl.c                              |  2 +-
 drivers/net/wireless/adm8211.c                       |  2 +-
 drivers/net/wireless/airo.c                          |  2 +-
 drivers/net/wireless/ath/ath10k/pci.c                |  2 +-
 drivers/net/wireless/ath/ath5k/led.c                 |  2 +-
 drivers/net/wireless/ath/ath5k/pci.c                 |  2 +-
 drivers/net/wireless/ath/ath9k/pci.c                 |  2 +-
 drivers/net/wireless/atmel_pci.c                     |  2 +-
 drivers/net/wireless/hostap/hostap_pci.c             |  2 +-
 drivers/net/wireless/hostap/hostap_plx.c             |  2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c               |  2 +-
 drivers/net/wireless/ipw2x00/ipw2200.c               |  2 +-
 drivers/net/wireless/iwlegacy/3945.c                 |  2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c             |  2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c              |  2 +-
 drivers/net/wireless/mwifiex/pcie.c                  |  2 +-
 drivers/net/wireless/mwl8k.c                         |  2 +-
 drivers/net/wireless/orinoco/orinoco_nortel.c        |  2 +-
 drivers/net/wireless/orinoco/orinoco_pci.c           |  2 +-
 drivers/net/wireless/orinoco/orinoco_plx.c           |  2 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c           |  2 +-
 drivers/net/wireless/p54/p54pci.c                    |  2 +-
 drivers/net/wireless/prism54/islpci_hotplug.c        |  2 +-
 drivers/net/wireless/rt2x00/rt2400pci.c              |  2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c              |  2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c              |  2 +-
 drivers/net/wireless/rt2x00/rt61pci.c                |  2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c           |  2 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/sw.c          |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c          |  2 +-
 drivers/net/wireless/rtlwifi/rtl8723be/sw.c          |  2 +-
 drivers/pci/ioapic.c                                 |  2 +-
 drivers/platform/x86/intel_ips.c                     |  2 +-
 drivers/platform/x86/intel_scu_ipc.c                 |  2 +-
 drivers/ptp/ptp_pch.c                                |  2 +-
 drivers/rapidio/devices/tsi721.c                     |  2 +-
 drivers/scsi/BusLogic.c                              |  2 +-
 drivers/scsi/be2iscsi/be_main.c                      |  2 +-
 drivers/scsi/csiostor/csio_init.c                    |  2 +-
 drivers/scsi/isci/init.c                             |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                 |  2 +-
 drivers/scsi/mvumi.c                                 |  2 +-
 drivers/scsi/ufs/ufshcd-pci.c                        |  2 +-
 drivers/video/fbdev/hyperv_fb.c                      |  2 +-
 drivers/video/fbdev/i740fb.c                         |  2 +-
 drivers/xen/xen-pciback/pci_stub.c                   |  2 +-
 sound/oss/kahlua.c                                   |  2 +-
 sound/pci/ad1889.c                                   |  2 +-
 sound/pci/ali5451/ali5451.c                          |  2 +-
 sound/pci/als300.c                                   |  2 +-
 sound/pci/als4000.c                                  |  2 +-
 sound/pci/asihpi/asihpi.c                            |  2 +-
 sound/pci/atiixp.c                                   |  2 +-
 sound/pci/atiixp_modem.c                             |  2 +-
 sound/pci/au88x0/au8810.c                            |  2 +-
 sound/pci/au88x0/au8820.c                            |  2 +-
 sound/pci/au88x0/au8830.c                            |  2 +-
 sound/pci/aw2/aw2-alsa.c                             |  2 +-
 sound/pci/azt3328.c                                  |  2 +-
 sound/pci/bt87x.c                                    |  4 ++--
 sound/pci/ca0106/ca0106_main.c                       |  2 +-
 sound/pci/cmipci.c                                   |  4 ++--
 sound/pci/cs4281.c                                   |  2 +-
 sound/pci/cs46xx/cs46xx.c                            |  2 +-
 sound/pci/cs5530.c                                   |  2 +-
 sound/pci/cs5535audio/cs5535audio.c                  |  2 +-
 sound/pci/ctxfi/xfi.c                                |  2 +-
 sound/pci/echoaudio/darla20.c                        |  2 +-
 sound/pci/echoaudio/darla24.c                        |  2 +-
 sound/pci/echoaudio/echo3g.c                         |  2 +-
 sound/pci/echoaudio/gina20.c                         |  2 +-
 sound/pci/echoaudio/gina24.c                         |  2 +-
 sound/pci/echoaudio/indigo.c                         |  2 +-
 sound/pci/echoaudio/indigodj.c                       |  2 +-
 sound/pci/echoaudio/indigodjx.c                      |  2 +-
 sound/pci/echoaudio/indigoio.c                       |  2 +-
 sound/pci/echoaudio/indigoiox.c                      |  2 +-
 sound/pci/echoaudio/layla20.c                        |  2 +-
 sound/pci/echoaudio/layla24.c                        |  2 +-
 sound/pci/echoaudio/mia.c                            |  2 +-
 sound/pci/echoaudio/mona.c                           |  2 +-
 sound/pci/emu10k1/emu10k1.c                          |  2 +-
 sound/pci/emu10k1/emu10k1x.c                         |  2 +-
 sound/pci/ens1370.c                                  |  2 +-
 sound/pci/es1938.c                                   |  2 +-
 sound/pci/es1968.c                                   |  2 +-
 sound/pci/fm801.c                                    |  2 +-
 sound/pci/ice1712/ice1712.c                          |  2 +-
 sound/pci/ice1712/ice1724.c                          |  2 +-
 sound/pci/intel8x0.c                                 |  2 +-
 sound/pci/intel8x0m.c                                |  2 +-
 sound/pci/korg1212/korg1212.c                        |  2 +-
 sound/pci/lola/lola.c                                |  2 +-
 sound/pci/lx6464es/lx6464es.c                        |  2 +-
 sound/pci/maestro3.c                                 |  2 +-
 sound/pci/mixart/mixart.c                            |  2 +-
 sound/pci/nm256/nm256.c                              |  2 +-
 sound/pci/oxygen/oxygen.c                            |  2 +-
 sound/pci/oxygen/virtuoso.c                          |  2 +-
 sound/pci/pcxhr/pcxhr.c                              |  2 +-
 sound/pci/riptide/riptide.c                          |  4 ++--
 sound/pci/rme32.c                                    |  2 +-
 sound/pci/rme96.c                                    |  2 +-
 sound/pci/rme9652/hdsp.c                             |  2 +-
 sound/pci/rme9652/hdspm.c                            |  2 +-
 sound/pci/rme9652/rme9652.c                          |  2 +-
 sound/pci/sis7019.c                                  |  2 +-
 sound/pci/sonicvibes.c                               |  2 +-
 sound/pci/trident/trident.c                          |  2 +-
 sound/pci/via82xx.c                                  |  2 +-
 sound/pci/via82xx_modem.c                            |  2 +-
 sound/pci/vx222/vx222.c                              |  2 +-
 sound/pci/ymfpci/ymfpci.c                            |  2 +-
 230 files changed, 242 insertions(+), 240 deletions(-)
