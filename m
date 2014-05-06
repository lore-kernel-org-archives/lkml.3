Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaEFPmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:42:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbaEFPmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:42:14 -0400
Date: Tue, 6 May 2014 08:42:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.3
Message-ID: <20140506154213.GA13661@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.3 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/spi/efm32-spi.txt |    4=20
 Documentation/sysctl/kernel.txt                     |    1=20
 Documentation/video4linux/gspca.txt                 |    1=20
 Makefile                                            |    2=20
 arch/arm/Kconfig                                    |    2=20
 arch/arm/boot/dts/am335x-bone-common.dtsi           |    4=20
 arch/arm/boot/dts/am335x-evm.dts                    |    4=20
 arch/arm/boot/dts/am335x-evmsk.dts                  |    2=20
 arch/arm/boot/dts/am335x-igep0033.dtsi              |    4=20
 arch/arm/boot/dts/am33xx.dtsi                       |    4=20
 arch/arm/boot/dts/armada-370-xp.dtsi                |    1=20
 arch/arm/boot/dts/exynos5250-arndale.dts            |    1=20
 arch/arm/boot/dts/omap4.dtsi                        |    2=20
 arch/arm/boot/dts/omap5.dtsi                        |    2=20
 arch/arm/boot/dts/tegra124.dtsi                     |   13 -
 arch/arm/include/asm/div64.h                        |    2=20
 arch/arm/include/asm/futex.h                        |    6=20
 arch/arm/include/asm/pgtable-2level.h               |    1=20
 arch/arm/include/asm/unistd.h                       |    1=20
 arch/arm/kernel/machine_kexec.c                     |    7=20
 arch/arm/mach-omap2/irq.c                           |    8=20
 arch/arm/mach-omap2/omap_hwmod.c                    |    3=20
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c          |    4=20
 arch/arm/mach-omap2/pm.h                            |    2=20
 arch/arm/mach-pxa/include/mach/hx4700.h             |    1=20
 arch/arm/mm/Kconfig                                 |    3=20
 arch/arm/mm/mmu.c                                   |   10 +
 arch/arm/mm/proc-macros.S                           |   19 -
 arch/arm/mm/proc-v7-2level.S                        |    7=20
 arch/arm64/include/asm/pgtable.h                    |    8=20
 arch/arm64/include/asm/unistd32.h                   |    2=20
 arch/s390/include/asm/atomic.h                      |   70 ++++---
 arch/s390/include/asm/bitops.h                      |   41 ++--
 arch/s390/include/asm/ccwdev.h                      |    2=20
 arch/s390/kernel/ptrace.c                           |    2=20
 arch/s390/kvm/kvm-s390.c                            |    3=20
 arch/sh/kernel/dumpstack.c                          |    2=20
 arch/x86/Makefile                                   |    1=20
 arch/x86/boot/compressed/eboot.c                    |    5=20
 arch/x86/boot/compressed/head_32.S                  |   14 -
 arch/x86/boot/compressed/head_64.S                  |    9=20
 arch/x86/include/asm/cpufeature.h                   |    4=20
 arch/x86/include/asm/xsave.h                        |   16 +
 arch/x86/kernel/ftrace.c                            |    2=20
 arch/x86/kernel/ldt.c                               |   11 +
 arch/x86/lib/hash.c                                 |    4=20
 drivers/acpi/acpica/nsrepair.c                      |   25 ++
 drivers/block/mtip32xx/mtip32xx.c                   |   88 +++++---
 drivers/block/mtip32xx/mtip32xx.h                   |    2=20
 drivers/clk/clk-s2mps11.c                           |    2=20
 drivers/clk/tegra/clk-tegra124.c                    |    3=20
 drivers/clk/ti/clk-44xx.c                           |    1=20
 drivers/clk/ti/clk-54xx.c                           |    1=20
 drivers/clk/ti/clk-7xx.c                            |    1=20
 drivers/firmware/efi/efi-stub-helper.c              |    6=20
 drivers/gpu/drm/armada/armada_crtc.c                |    1=20
 drivers/hv/connection.c                             |    5=20
 drivers/iio/adc/at91_adc.c                          |   26 ++
 drivers/iio/industrialio-buffer.c                   |    6=20
 drivers/iio/light/cm32181.c                         |    1=20
 drivers/iio/light/cm36651.c                         |   22 ++
 drivers/infiniband/core/cm.c                        |   17 -
 drivers/infiniband/core/cma.c                       |   26 --
 drivers/infiniband/hw/ehca/ehca_cq.c                |    1=20
 drivers/infiniband/hw/ipath/ipath_diag.c            |   66 ++----
 drivers/infiniband/hw/mthca/mthca_provider.c        |    1=20
 drivers/infiniband/hw/nes/nes_verbs.c               |    2=20
 drivers/infiniband/hw/qib/qib_file_ops.c            |    3=20
 drivers/infiniband/hw/qib/qib_init.c                |   25 +-
 drivers/infiniband/ulp/isert/ib_isert.c             |   70 ++++---
 drivers/infiniband/ulp/srpt/ib_srpt.c               |   16 +
 drivers/media/dvb-frontends/m88rs2000.c             |   19 +
 drivers/media/pci/saa7134/saa7134-cards.c           |    4=20
 drivers/media/platform/omap3isp/isppreview.c        |    9=20
 drivers/media/usb/em28xx/em28xx-audio.c             |   22 +-
 drivers/media/usb/em28xx/em28xx-dvb.c               |    3=20
 drivers/media/usb/gspca/sn9c20x.c                   |    1=20
 drivers/media/usb/uvc/uvc_video.c                   |   20 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c       |    4=20
 drivers/media/v4l2-core/v4l2-dv-timings.c           |    4=20
 drivers/mfd/88pm800.c                               |    3=20
 drivers/mfd/88pm860x-core.c                         |    6=20
 drivers/mfd/kempld-core.c                           |    7=20
 drivers/mfd/max77686.c                              |    4=20
 drivers/mfd/max77693.c                              |   12 +
 drivers/mfd/max8925-i2c.c                           |    9=20
 drivers/mfd/max8997.c                               |   18 +
 drivers/mfd/max8998.c                               |    4=20
 drivers/mfd/sec-core.c                              |    4=20
 drivers/mfd/tps65910.c                              |    4=20
 drivers/mfd/twl-core.c                              |   10 -
 drivers/misc/mei/client.c                           |   76 +++++--
 drivers/misc/mei/client.h                           |   18 -
 drivers/misc/mei/hw-me-regs.h                       |    5=20
 drivers/misc/mei/interrupt.c                        |    3=20
 drivers/misc/mei/main.c                             |    3=20
 drivers/misc/mei/pci-me.c                           |   30 ++-
 drivers/pci/host/pci-imx6.c                         |   47 +++-
 drivers/pci/host/pci-mvebu.c                        |    2=20
 drivers/regulator/arizona-ldo1.c                    |    7=20
 drivers/s390/char/con3215.c                         |    2=20
 drivers/s390/char/con3270.c                         |    6=20
 drivers/s390/char/raw3270.c                         |   10 -
 drivers/s390/char/raw3270.h                         |    2=20
 drivers/s390/cio/device.c                           |    3=20
 drivers/scsi/arcmsr/arcmsr_hba.c                    |    7=20
 drivers/scsi/qla2xxx/qla_os.c                       |    6=20
 drivers/spi/spi-dw.c                                |    7=20
 drivers/spi/spi-efm32.c                             |    3=20
 drivers/staging/comedi/drivers/usbdux.c             |    9=20
 drivers/staging/rtl8188eu/core/rtw_recv.c           |    4=20
 drivers/staging/rtl8712/rtl871x_recv.c              |   13 -
 drivers/staging/serqt_usb2/serqt_usb2.c             |    2=20
 drivers/target/iscsi/iscsi_target.c                 |    4=20
 drivers/target/target_core_iblock.c                 |    5=20
 drivers/target/target_core_rd.c                     |   14 +
 drivers/target/target_core_sbc.c                    |    3=20
 drivers/target/tcm_fc/tfc_sess.c                    |    1=20
 drivers/tty/hvc/hvc_console.c                       |    6=20
 drivers/usb/core/driver.c                           |   94 +++++----
 drivers/usb/core/hcd-pci.c                          |    2=20
 drivers/usb/core/hub.c                              |    5=20
 drivers/usb/core/usb.h                              |    2=20
 drivers/usb/dwc3/core.h                             |   39 +++
 drivers/usb/dwc3/gadget.h                           |   12 -
 drivers/usb/gadget/atmel_usba_udc.c                 |    6=20
 drivers/usb/gadget/tcm_usb_gadget.c                 |    2=20
 drivers/usb/gadget/zero.c                           |    2=20
 drivers/usb/host/ehci-tegra.c                       |   23 ++
 drivers/usb/host/xhci-pci.c                         |   17 +
 drivers/usb/host/xhci-ring.c                        |   67 +++---
 drivers/usb/host/xhci.c                             |    7=20
 drivers/usb/host/xhci.h                             |    2=20
 drivers/usb/musb/musb_core.c                        |    5=20
 drivers/usb/musb/omap2430.c                         |    2=20
 drivers/usb/phy/phy-am335x-control.c                |    9=20
 drivers/usb/phy/phy-ulpi.c                          |    2=20
 drivers/usb/serial/pl2303.c                         |    3=20
 drivers/usb/serial/pl2303.h                         |    5=20
 drivers/video/atmel_lcdfb.c                         |    6=20
 drivers/w1/w1_netlink.c                             |   25 +-
 fs/ext4/ext4.h                                      |   17 -
 fs/ext4/file.c                                      |    2=20
 fs/ext4/inode.c                                     |   20 +-
 fs/ext4/page-io.c                                   |    5=20
 fs/ext4/xattr.c                                     |   23 +-
 fs/namespace.c                                      |   11 -
 fs/nfs/nfs4proc.c                                   |   19 +
 fs/nfsd/nfs4callback.c                              |    4=20
 fs/nfsd/nfs4proc.c                                  |    9=20
 fs/nfsd/nfs4state.c                                 |   13 -
 fs/nfsd/nfs4xdr.c                                   |    9=20
 fs/nfsd/nfsctl.c                                    |    5=20
 fs/nfsd/nfsd.h                                      |    2=20
 fs/nfsd/nfsxdr.c                                    |    2=20
 fs/nfsd/vfs.c                                       |    9=20
 fs/ocfs2/buffer_head_io.c                           |    2=20
 fs/ocfs2/dlm/dlmrecovery.c                          |   29 ++
 fs/ocfs2/namei.c                                    |    2=20
 fs/pnode.c                                          |  198 ++++++++++++---=
-----
 fs/pnode.h                                          |    3=20
 fs/reiserfs/dir.c                                   |    6=20
 include/asm-generic/word-at-a-time.h                |    8=20
 include/dt-bindings/clock/tegra124-car.h            |    6=20
 include/linux/bio.h                                 |    6=20
 include/linux/hyperv.h                              |    4=20
 include/linux/mount.h                               |    3=20
 include/linux/sunrpc/svcsock.h                      |    1=20
 include/rdma/ib_cm.h                                |    1=20
 include/uapi/linux/libc-compat.h                    |    9=20
 include/uapi/linux/videodev2.h                      |   10 -
 include/uapi/linux/xattr.h                          |    7=20
 kernel/sysctl.c                                     |    6=20
 mm/hugetlb.c                                        |    1=20
 mm/internal.h                                       |    1=20
 mm/mlock.c                                          |    2=20
 mm/page_alloc.c                                     |   89 ++++----
 mm/rmap.c                                           |   14 +
 net/sunrpc/svcsock.c                                |   16 +
 sound/pci/hda/patch_realtek.c                       |   98 +++++++++
 sound/pci/ice1712/ice1712.c                         |   15 +
 sound/soc/codecs/cs42l51.c                          |    9=20
 sound/soc/codecs/cs42l52.c                          |    8=20
 sound/soc/codecs/cs42l73.c                          |    6=20
 sound/soc/soc-pcm.c                                 |    3=20
 185 files changed, 1417 insertions(+), 832 deletions(-)

Aaron Sanders (1):
      USB: pl2303: add ids for Hewlett-Packard HP POS pole displays

Al Viro (1):
      smarter propagate_mnt()

Alan Stern (2):
      USB: fix crash during hotplug of PCI USB controller card
      USB: unbind all interfaces before rebinding any

Alec Berg (1):
      iio: querying buffer scan_mask should return 0/1

Alexander Usyskin (1):
      mei: ignore client writing state during cb completion

Alexandre Belloni (1):
      iio: adc: at91_adc: Repair broken platform_data support

Andrea Adami (1):
      ARM: pxa: hx4700.h: include "irqs.h" for PXA_NR_BUILTIN_GPIO

Andrew Lunn (1):
      ARM: Fix default CPU selection for ARCH_MULTI_V5

Andy Grover (1):
      target/tcm_fc: Fix use-after-free of ft_tpg

Antoine T=E9nart (1):
      video: atmel_lcdfb: ensure the hardware is initialized with the corre=
ct mode

Antti Palosaari (1):
      media: em28xx: fix PCTV 290e LNA oops

Axel Lin (1):
      spi: dw: Don't call kfree for memory allocated by devm_kzalloc

Beomho Seo (1):
      iio: cm32181: Fix read integration time function

Brian Austin (3):
      ASoC: cs42l51: Fix SOC_DOUBLE_R_SX_TLV shift values for ADC, PCM, and=
 Analog kcontrols
      ASoC: cs42l52: Fix mask bits for SOC_VALUE_ENUM_SINGLE
      ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE

Catalin Marinas (2):
      arm64: Do not synchronise I and D caches for special ptes
      arm64: Make DMA coherent and strongly ordered mappings not executable

Charles Keepax (1):
      regulator: arizona-ldo1: Correct default regulator init_data

Christian Borntraeger (1):
      KVM: s390: Optimize ucontrol path

Christopher Covington (1):
      ARM: 8007/1: Remove extraneous kcmp syscall ignore

Dan Carpenter (2):
      SCSI: qla2xxx: fix error handling of qla2x00_mem_alloc()
      SCSI: arcmsr: upper 32 of dma address lost

Daniel Mack (1):
      usb: phy: am335x-control: wait 1ms after power-up transitions

David Cohen (1):
      usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM

David Fries (1):
      w1: fix w1_send_slave dropping a slave id

Denis Turischev (1):
      xhci: Switch Intel Lynx Point ports to EHCI on shutdown.

Dennis Dalessandro (1):
      IB/ipath: Fix potential buffer overrun in sending diag packet routine

Felipe Balbi (3):
      usb: dwc3: fix randconfig build errors
      usb: musb: avoid NULL pointer dereference
      usb: musb: fix PHY power on/off

Felipe Franciosi (2):
      mtip32xx: Set queue bounce limit
      mtip32xx: Unmap the DMA segments before completing the IO request

Fenghua Yu (2):
      x86, AVX-512: AVX-512 Feature Detection
      x86, AVX-512: Enable AVX-512 States Context Switch

Florian Vaussard (3):
      CLK: TI: OMAP4/5/DRA7: Remove gpmc_fck from dummy clocks
      ARM: dts: omap4/5: Use l3_ick for the gpmc node
      media: omap3isp: preview: Fix the crop margins

Frank Schaefer (1):
      media: em28xx-audio: fix user counting in snd_em28xx_capture_open()

Greg Kroah-Hartman (1):
      Linux 3.14.3

Gregory CLEMENT (1):
      usb: gadget: atmel_usba: fix crashed during stopping when DEBUG is en=
abled

Guenter Roeck (1):
      mfd: kempld-core: Fix potential hang-up during boot

H Hartley Sweeten (1):
      staging: comedi: usbdux: bug fix for accessing 'ao_chanlist' in priva=
te data

H. Peter Anvin (1):
      x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels

Hans Verkuil (4):
      media: videodev2.h: add parenthesis around macro arguments
      media: v4l2-dv-timings: add module name, description, license
      media: v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32 support
      media: saa7134: fix WARN_ON during resume

Heiko Carstens (1):
      s390/bitops,atomic: add missing memory barriers

Himangi Saraogi (1):
      staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to =
integer

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_devt

Hui Wang (1):
      ALSA: hda - add headset mic detect quirks for three Dell laptops

Igor Gnatenko (1):
      xhci: extend quirk for Renesas cards

J. Bruce Fields (7):
      nfsd: revert v2 half of "nfsd: don't return high mode bits"
      nfsd4: session needs room for following op to error out
      nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
      nfsd4: fix test_stateid error reply encoding
      nfsd4: leave reply buffer space for failed setattr
      nfsd: notify_change needs elevated write count
      nfsd4: fix setclientid encode size

Jan Beulich (1):
      x86, hash: Fix build failure with older binutils

Jan Kara (1):
      ext4: fix jbd2 warning under heavy xattr load

Jean-Jacques Hiblot (1):
      PCI: mvebu: Fix potential issue in range parsing

Jeff Layton (1):
      nfsd: set timeparms.to_maxval in setup_callback_client

Jeff Mahoney (1):
      reiserfs: fix race in readdir

Johannes Weiner (1):
      mm: page_alloc: spill to remote nodes before waking kswapd

Julius Werner (1):
      usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb

Junxiao Bi (2):
      ocfs2: dlm: fix lock migration crash
      ocfs2: dlm: fix recovery hung

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 ho=
sts

Kailang Yang (3):
      ALSA: hda/realtek - Restore default value for ALC283
      ALSA: hda/realtek - Add support of ALC288 codec
      ALSA: hda/realtek - Add headset Mic support for Dell machine

Kazuya Mio (1):
      ext4: FIBMAP ioctl causes BUG_ON due to handle EXT_MAX_BLOCKS

Kees Cook (1):
      usb: gadget: tcm_usb_gadget: stop format strings

Kinglong Mee (1):
      NFSD: Traverse unconfirmed client through hash-table

Krzysztof Kozlowski (12):
      mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dum=
my error
      mfd: 88pm860x: Fix possible NULL pointer dereference on i2c_new_dummy=
 error
      mfd: 88pm860x: Fix I2C device resource leak on regmap init fail
      mfd: 88pm800: Fix I2C device resource leak if probe fails
      mfd: max77686: Fix possible NULL pointer dereference on i2c_new_dummy=
 error
      mfd: max77693: Fix possible NULL pointer dereference on i2c_new_dummy=
 error
      mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy =
error
      mfd: max8998: Fix possible NULL pointer dereference on i2c_new_dummy =
error
      mfd: max8997: Fix possible NULL pointer dereference on i2c_new_dummy =
error
      mfd: tps65910: Fix possible invalid pointer dereference on regmap_add=
_irq_chip fail
      iio: cm36651: Fix i2c client leak and possible NULL pointer dereferen=
ce
      clk: s2mps11: Fix possible NULL pointer dereference

Larry Finger (2):
      staging: r8712u: Fix case where ethtype was never obtained and always=
 be checked against 0
      staging: r8188eu: Calling rtw_get_stainfo() with a NULL sta_addr will=
 return NULL

Leigh Brown (1):
      ARM: dts: am335x: update USB DT references

Liu Hua (2):
      ARM: 8030/1: ARM : kdump : add arch_crash_save_vmcoreinfo
      hung_task: check the value of "sysctl_hung_task_timeout_sec"

Lv Zheng (1):
      ACPICA: Restore code that repairs NULL package elements in return val=
ues.

Malcolm Priestley (2):
      media: m88rs2000: prevent frontend crash on continuous transponder sc=
ans
      media: m88rs2000: add caps FE_CAN_INVERSION_AUTO

Marek Vasut (1):
      PCI: imx6: Wait for retraining

Mark Brown (1):
      ASoC: pcm: Drop incorrect double/extra frees

Martin K. Petersen (1):
      block: Fix for_each_bvec()

Martin Schwidefsky (1):
      s390: fix control register update

Martin Svec (1):
      Target/sbc: Initialize COMPARE_AND_WRITE write_sg scatterlist

Mathias Nyman (1):
      xhci: Prevent runtime pm from autosuspending during initialization

Matt Fleming (3):
      x86/efi: Correct EFI boot stub use of code32_start
      efi: Pass correct file handle to efi_file_{read,close}
      sh: fix format string bug in stack tracer

Matthew Wilcox (1):
      ext4: note the error in ext4_end_bio()

Michal Simek (1):
      usb: phy: Add ulpi IDs for SMSC USB3320 and TI TUSB1210

Mike Marciniszyn (2):
      IB/qib: Fix debugfs ordering issue with multiple HCAs
      ib_srpt: Use correct ib_sg_dma primitives

Miklos Szeredi (1):
      arm64: __NR_compat_syscalls fix

Mizuma, Masayoshi (1):
      mm: hugetlb: fix softlockup when a large number of hugepages are free=
d.

Moni Shoua (1):
      IB/core: Don't resolve passive side RoCE L2 address in CMA REQ handler

Mugunthan V N (1):
      ARM: dts: am33xx: correcting dt node unit address for usb

Nicholas Bellinger (4):
      iscsi-target: Fix ERL=3D2 ASYNC_EVENT connection pointer bug
      target/iblock: Fix double bioset_integrity_free bug
      iser-target: Match FRMR descriptors to available session tags
      iser-target: Add missing se_cmd put for WRITE_PENDING in tx_comp_err

Nishanth Menon (1):
      ARM: OMAP4: Fix definition of IS_PM44XX_ERRATUM

Oleksij Rempel (1):
      media: uvcvideo: Do not use usb_set_interface on bulk EP

Paul Gortmaker (1):
      hvc: ensure hvc_init is only ever called once in hvc_console.c

Petr Mladek (1):
      ftrace/x86: One more missing sync after fixup of function modificatio=
n failure

Quinn Tran (1):
      target/rd: T10-Dif: RAM disk is allocating more space than required.

Roger Quadros (2):
      ARM: OMAP3: hwmod data: Correct clock domains for USB modules
      usb: gadget: zero: Fix SuperSpeed enumeration for alternate setting 1

Russell King (1):
      DRM: armada: fix corruption while loading cursors

Sam Bradshaw (1):
      mtip32xx: mtip_async_complete() bug fixes

Sebastian Ott (1):
      s390/cio: fix driver callback initialization for ccw consoles

Serge Hallyn (1):
      xattr: guard against simultaneous glibc header inclusion

Stanislav Kinsbursky (1):
      nfsd: check passed socket's net matches NFSd superblock's one

Stefan S=F8rensen (1):
      ARM: OMAP2+: INTC: Acknowledge stuck active interrupts

Stephen Warren (4):
      ARM: tegra: remove UART5/UARTE from tegra124.dtsi
      clk: tegra: remove non-existent clocks
      dt: tegra: remove non-existent clock IDs
      USB: EHCI: tegra: set txfill_tuning

Suman Anna (1):
      ARM: OMAP2+: hwmod: fix missing braces in _init()

Takashi Iwai (2):
      ALSA: ice1712: Fix boundary checks in PCM pointer ops
      ALSA: hda - Fix silent speaker output due to mute LED fixup

Tetsuo Handa (1):
      ocfs2: fix panic on kfree(xattr->name)

Theodore Ts'o (2):
      ext4: move ext4_update_i_disksize() into mpage_map_and_submit_extent()
      ext4: use i_size_read in ext4_unaligned_aio()

Thomas Petazzoni (1):
      ARM: mvebu: ensure the mdio node has a clock reference on Armada 370/=
XP

Tomas Novotny (1):
      mfd: twl-core: Fix accessibility of some twl4030 audio registers

Tomas Winkler (2):
      mei: fix memory leak of pending write cb objects
      mei: me: do not load the driver if the FW doesn't support MEI interfa=
ce

Tomasz Figa (1):
      ARM: dts: Keep G3D regulator always on for exynos5250-arndale

Trond Myklebust (1):
      NFSv4: Fix a use-after-free problem in open()

Uwe Kleine-K=F6nig (1):
      spi: efm32: use $vendor,$device scheme for compatible string

Vlastimil Babka (1):
      mm: try_to_unmap_cluster() should lock_page() before mlocking

W. Trevor King (1):
      ALSA: hda - Enable beep for ASUS 1015E

Will Deacon (2):
      ARM: 7954/1: mm: remove remaining domain support from ARMv6
      word-at-a-time: avoid undefined behaviour in zero_bytemask macro

Wolfram Sang (1):
      media: media: gspca: sn9c20x: add ID for Genius Look 1320 V2

Xiangyu Lu (1):
      ARM: 8027/1: fix do_div() bug in big-endian systems

Yan, Zheng (1):
      nfsd4: fix memory leak in nfsd4_encode_fattr()

Yann Droneaud (4):
      IB/nes: Return an error on ib_copy_from_udata() failure instead of NU=
LL
      IB/mthca: Return an error on ib_copy_to_udata() failure
      IB/ehca: Returns an error on ib_copy_to_udata() failure
      IB/qib: add missing braces in do_qib_user_sdma_queue_create()

alex chen (1):
      ocfs2: do not put bh when buffer_uptodate failed


--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTaQLUAAoJEDjbvchgkmk+7lcP/1jl6y+FFaMX412GhG1ZYk0W
cGB3aqZJFl58lYtRbpgZBkab6GeCwmFHHeGWyXv4wA/6NAzso4kW/uffGV4KpEyV
wX06YECU0mwptW4Vs1Orqcz8+rW+tILxItYNXPq1Juzsw/aWOxzUWW75czWoSNjZ
RWtB4sgpAQX4qbEVzyHxhCCk+QNwJ7VFJ7f4WuvGP6fKu3ilWJ57nQLOU4pqBUf2
IIBf/hpYkAE+pwsgx5qlekRp3EpxnP0acksjh7h+PSkO5SfWtudkEfgMAAaLvUTD
4bOzhm36qnE7B+01gBOGnaPVZunIiywkPxPclEXW4ohMtmb0H1d9AYHNRtVh/Op1
9Wvjy3vu1HOiaDTQ3IdOmm+5GmjSJfOsqFrgT3y5VA2JFh84w9AaWmV4zsax6u7k
YuF23i80FIE0xsNCOmqqaIONU5nJf2R3IAHSODug52dLiiuCq5rIpNT0Wg6Taorx
Yl4Iv3q1VTIVESiU19f1fb/ZEY13Kejgy05vNNWVQDDd9JH1V5mMaX4QOydVLP/4
XuF7tj73rr2WGQYcX/9jmynVuIx7YXwJ2egs62VKsNPb9hs/LJVUlVADHVuBxXn7
59UDiOQuaeQCxmYX5Sqa7oyfi1yjL8/T3jj0BXjXpLzNwl12KgsPrdEE109aHkJZ
nieGLn0tCES3oyR98Jxk
=i9rz
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
