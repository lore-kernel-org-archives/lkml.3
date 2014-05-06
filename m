Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbaEFPlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:41:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbaEFPli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:41:38 -0400
Date: Tue, 6 May 2014 08:41:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.39
Message-ID: <20140506154137.GA13595@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.39 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/video4linux/gspca.txt           |    1=20
 Makefile                                      |    2=20
 arch/arm/boot/dts/armada-370-xp.dtsi          |    1=20
 arch/arm/boot/dts/exynos5250-arndale.dts      |    1=20
 arch/arm/include/asm/div64.h                  |    2=20
 arch/arm/include/asm/futex.h                  |    6 -
 arch/arm/include/asm/io.h                     |    8 +-
 arch/arm/include/asm/pgtable-2level.h         |    1=20
 arch/arm/include/asm/unistd.h                 |    1=20
 arch/arm/kernel/machine_kexec.c               |    7 +
 arch/arm/mach-ebsa110/core.c                  |    2=20
 arch/arm/mach-imx/mm-imx3.c                   |    2=20
 arch/arm/mach-iop13xx/io.c                    |    2=20
 arch/arm/mach-ixp4xx/common.c                 |    2=20
 arch/arm/mach-msm/common.h                    |    2=20
 arch/arm/mach-msm/io.c                        |    2=20
 arch/arm/mach-omap2/irq.c                     |    8 ++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c    |    4 -
 arch/arm/mach-omap2/pm.h                      |    2=20
 arch/arm/mm/Kconfig                           |    3=20
 arch/arm/mm/ioremap.c                         |   10 +-
 arch/arm/mm/mmu.c                             |   10 ++
 arch/arm/mm/nommu.c                           |    6 -
 arch/arm/mm/proc-macros.S                     |   19 +----
 arch/arm/mm/proc-v7-2level.S                  |    7 -
 arch/arm64/include/asm/pgtable.h              |    8 +-
 arch/s390/include/asm/ccwdev.h                |    2=20
 arch/sh/kernel/dumpstack.c                    |    2=20
 arch/x86/boot/compressed/eboot.c              |    5 -
 arch/x86/boot/compressed/head_32.S            |   14 ++-
 arch/x86/boot/compressed/head_64.S            |    9 --
 arch/x86/kernel/ftrace.c                      |    2=20
 arch/x86/kernel/ldt.c                         |   11 +++
 drivers/block/mtip32xx/mtip32xx.c             |    1=20
 drivers/iio/industrialio-buffer.c             |    6 +
 drivers/infiniband/hw/ehca/ehca_cq.c          |    1=20
 drivers/infiniband/hw/ipath/ipath_diag.c      |   66 ++++++------------
 drivers/infiniband/hw/mthca/mthca_provider.c  |    1=20
 drivers/infiniband/hw/nes/nes_verbs.c         |    2=20
 drivers/infiniband/ulp/srpt/ib_srpt.c         |   16 ++--
 drivers/media/dvb-frontends/m88rs2000.c       |   19 ++++-
 drivers/media/pci/saa7134/saa7134-cards.c     |    4 -
 drivers/media/platform/omap3isp/isppreview.c  |    9 ++
 drivers/media/usb/em28xx/em28xx-dvb.c         |    3=20
 drivers/media/usb/gspca/sn9c20x.c             |    1=20
 drivers/media/usb/uvc/uvc_video.c             |   20 +++++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |    4 -
 drivers/mfd/88pm860x-core.c                   |    6 +
 drivers/mfd/max77686.c                        |    4 +
 drivers/mfd/max77693.c                        |   12 +++
 drivers/mfd/max8925-i2c.c                     |    9 ++
 drivers/mfd/max8997.c                         |   18 ++++
 drivers/mfd/max8998.c                         |    4 +
 drivers/mfd/sec-core.c                        |    4 +
 drivers/mfd/tps65910.c                        |    4 -
 drivers/misc/mei/hw-me-regs.h                 |    5 +
 drivers/misc/mei/pci-me.c                     |   30 ++++++--
 drivers/s390/char/con3215.c                   |    2=20
 drivers/s390/char/con3270.c                   |    6 -
 drivers/s390/char/raw3270.c                   |   10 ++
 drivers/s390/char/raw3270.h                   |    2=20
 drivers/s390/cio/device.c                     |    3=20
 drivers/scsi/arcmsr/arcmsr_hba.c              |    7 -
 drivers/scsi/qla2xxx/qla_os.c                 |    6 -
 drivers/staging/rtl8712/rtl871x_recv.c        |   13 +--
 drivers/staging/serqt_usb2/serqt_usb2.c       |    2=20
 drivers/target/iscsi/iscsi_target.c           |    4 -
 drivers/target/tcm_fc/tfc_sess.c              |    1=20
 drivers/tty/hvc/hvc_console.c                 |    6 +
 drivers/usb/core/driver.c                     |   94 +++++++++++++++------=
-----
 drivers/usb/core/hcd-pci.c                    |    2=20
 drivers/usb/core/hub.c                        |    5 -
 drivers/usb/core/usb.h                        |    2=20
 drivers/usb/dwc3/core.h                       |    6 -
 drivers/usb/gadget/tcm_usb_gadget.c           |    2=20
 drivers/usb/gadget/zero.c                     |    2=20
 drivers/usb/host/xhci-pci.c                   |   15 +++-
 drivers/usb/host/xhci.c                       |    6 -
 drivers/usb/musb/musb_core.c                  |    5 -
 drivers/usb/phy/phy-ulpi.c                    |    2=20
 drivers/usb/serial/pl2303.c                   |    3=20
 drivers/usb/serial/pl2303.h                   |    5 +
 drivers/w1/w1_netlink.c                       |   25 +++---
 fs/ext4/file.c                                |    2=20
 fs/ext4/xattr.c                               |   23 +++++-
 fs/nfsd/nfs4callback.c                        |    4 -
 fs/nfsd/nfs4proc.c                            |    9 ++
 fs/nfsd/nfs4state.c                           |   13 +--
 fs/nfsd/nfs4xdr.c                             |    5 +
 fs/nfsd/nfsctl.c                              |    5 +
 fs/nfsd/vfs.c                                 |    9 ++
 fs/ocfs2/buffer_head_io.c                     |    2=20
 fs/ocfs2/dlm/dlmrecovery.c                    |   29 +++++---
 fs/reiserfs/dir.c                             |    6 +
 fs/xfs/xfs_da_btree.c                         |    2=20
 include/linux/sunrpc/svcsock.h                |    1=20
 kernel/sysctl.c                               |    6 +
 mm/hugetlb.c                                  |    1=20
 mm/mlock.c                                    |    2=20
 mm/rmap.c                                     |   14 +++
 net/sunrpc/svcsock.c                          |   16 ++++
 sound/pci/hda/patch_realtek.c                 |    8 +-
 sound/pci/ice1712/ice1712.c                   |   15 ++--
 sound/soc/codecs/cs42l51.c                    |    9 +-
 sound/soc/codecs/cs42l52.c                    |    8 +-
 sound/soc/codecs/cs42l73.c                    |    6 -
 106 files changed, 560 insertions(+), 284 deletions(-)

Aaron Sanders (1):
      USB: pl2303: add ids for Hewlett-Packard HP POS pole displays

Alan Stern (2):
      USB: fix crash during hotplug of PCI USB controller card
      USB: unbind all interfaces before rebinding any

Alec Berg (1):
      iio: querying buffer scan_mask should return 0/1

Andy Grover (1):
      target/tcm_fc: Fix use-after-free of ft_tpg

Antti Palosaari (1):
      media: em28xx: fix PCTV 290e LNA oops

Brian Austin (3):
      ASoC: cs42l51: Fix SOC_DOUBLE_R_SX_TLV shift values for ADC, PCM, and=
 Analog kcontrols
      ASoC: cs42l52: Fix mask bits for SOC_VALUE_ENUM_SINGLE
      ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE

Catalin Marinas (2):
      arm64: Do not synchronise I and D caches for special ptes
      arm64: Make DMA coherent and strongly ordered mappings not executable

Christopher Covington (1):
      ARM: 8007/1: Remove extraneous kcmp syscall ignore

Dan Carpenter (2):
      SCSI: qla2xxx: fix error handling of qla2x00_mem_alloc()
      SCSI: arcmsr: upper 32 of dma address lost

David Cohen (1):
      usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM

David Fries (1):
      w1: fix w1_send_slave dropping a slave id

Dennis Dalessandro (1):
      IB/ipath: Fix potential buffer overrun in sending diag packet routine

Felipe Balbi (1):
      usb: musb: avoid NULL pointer dereference

Felipe Franciosi (1):
      mtip32xx: Set queue bounce limit

Florian Vaussard (1):
      media: omap3isp: preview: Fix the crop margins

Greg Kroah-Hartman (1):
      Linux 3.10.39

H. Peter Anvin (1):
      x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels

Hans Verkuil (2):
      media: v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32 support
      media: saa7134: fix WARN_ON during resume

Himangi Saraogi (1):
      staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to =
integer

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_devt

Igor Gnatenko (1):
      xhci: extend quirk for Renesas cards

J. Bruce Fields (5):
      nfsd4: session needs room for following op to error out
      nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
      nfsd4: fix test_stateid error reply encoding
      nfsd: notify_change needs elevated write count
      nfsd4: fix setclientid encode size

Jan Kara (1):
      ext4: fix jbd2 warning under heavy xattr load

Jeff Layton (1):
      nfsd: set timeparms.to_maxval in setup_callback_client

Jeff Mahoney (1):
      reiserfs: fix race in readdir

Junxiao Bi (2):
      ocfs2: dlm: fix lock migration crash
      ocfs2: dlm: fix recovery hung

Kailang Yang (1):
      ALSA: hda/realtek - Add support of ALC288 codec

Kees Cook (1):
      usb: gadget: tcm_usb_gadget: stop format strings

Kinglong Mee (1):
      NFSD: Traverse unconfirmed client through hash-table

Krzysztof Kozlowski (9):
      mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dum=
my error
      mfd: 88pm860x: Fix possible NULL pointer dereference on i2c_new_dummy=
 error
      mfd: 88pm860x: Fix I2C device resource leak on regmap init fail
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

Larry Finger (1):
      staging: r8712u: Fix case where ethtype was never obtained and always=
 be checked against 0

Laura Abbott (1):
      ARM: 7728/1: mm: Use phys_addr_t properly for ioremap functions

Liu Hua (2):
      ARM: 8030/1: ARM : kdump : add arch_crash_save_vmcoreinfo
      hung_task: check the value of "sysctl_hung_task_timeout_sec"

Malcolm Priestley (2):
      media: m88rs2000: prevent frontend crash on continuous transponder sc=
ans
      media: m88rs2000: add caps FE_CAN_INVERSION_AUTO

Mark Tinguely (1):
      xfs: fix directory hash ordering bug

Mathias Nyman (1):
      xhci: Prevent runtime pm from autosuspending during initialization

Matt Fleming (2):
      x86/efi: Correct EFI boot stub use of code32_start
      sh: fix format string bug in stack tracer

Michal Simek (1):
      usb: phy: Add ulpi IDs for SMSC USB3320 and TI TUSB1210

Mike Marciniszyn (1):
      ib_srpt: Use correct ib_sg_dma primitives

Mizuma, Masayoshi (1):
      mm: hugetlb: fix softlockup when a large number of hugepages are free=
d.

Nicholas Bellinger (1):
      iscsi-target: Fix ERL=3D2 ASYNC_EVENT connection pointer bug

Nishanth Menon (1):
      ARM: OMAP4: Fix definition of IS_PM44XX_ERRATUM

Oleksij Rempel (1):
      media: uvcvideo: Do not use usb_set_interface on bulk EP

Paul Gortmaker (1):
      hvc: ensure hvc_init is only ever called once in hvc_console.c

Petr Mladek (1):
      ftrace/x86: One more missing sync after fixup of function modificatio=
n failure

Roger Quadros (2):
      ARM: OMAP3: hwmod data: Correct clock domains for USB modules
      usb: gadget: zero: Fix SuperSpeed enumeration for alternate setting 1

Sebastian Ott (1):
      s390/cio: fix driver callback initialization for ccw consoles

Stanislav Kinsbursky (1):
      nfsd: check passed socket's net matches NFSd superblock's one

Stefan S=F8rensen (1):
      ARM: OMAP2+: INTC: Acknowledge stuck active interrupts

Takashi Iwai (2):
      ALSA: ice1712: Fix boundary checks in PCM pointer ops
      ALSA: hda - Fix silent speaker output due to mute LED fixup

Theodore Ts'o (1):
      ext4: use i_size_read in ext4_unaligned_aio()

Thomas Petazzoni (1):
      ARM: mvebu: ensure the mdio node has a clock reference on Armada 370/=
XP

Tomas Winkler (1):
      mei: me: do not load the driver if the FW doesn't support MEI interfa=
ce

Tomasz Figa (1):
      ARM: dts: Keep G3D regulator always on for exynos5250-arndale

Vlastimil Babka (1):
      mm: try_to_unmap_cluster() should lock_page() before mlocking

W. Trevor King (1):
      ALSA: hda - Enable beep for ASUS 1015E

Will Deacon (1):
      ARM: 7954/1: mm: remove remaining domain support from ARMv6

Wolfram Sang (1):
      media: media: gspca: sn9c20x: add ID for Genius Look 1320 V2

Xiangyu Lu (1):
      ARM: 8027/1: fix do_div() bug in big-endian systems

Yann Droneaud (3):
      IB/nes: Return an error on ib_copy_from_udata() failure instead of NU=
LL
      IB/mthca: Return an error on ib_copy_to_udata() failure
      IB/ehca: Returns an error on ib_copy_to_udata() failure

alex chen (1):
      ocfs2: do not put bh when buffer_uptodate failed


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTaQKxAAoJEDjbvchgkmk+CYkP/05oo4Y2tTTEXrNKnC6oNUqq
r6wB1Y5v9lNumxKCVHDSN56fPQGlZKw3sufJH5TYpOVZgat02HDf3t1QZH7UclWS
Oxq7ka91bB83KMM36r10fnyUBsUHZQLB1Oz2w9XwPQrSYmJY/GvbBq/84zmI1ubv
CtKi2MmMTmZcjbBu8Mi9ernRAh5AG5oM0QuLP4IjmtTQ9Q/tLk1aQhk+XKjdIV6W
FtGc7TuG4vVlMJEhwrvi8DXzqdZamjWbBoEZnrS4+DCnaBkFJsn2zwZWF+5YEN9i
0jdTNxe11OtTDHZ9coCA9g+VGA7Qe74gQimGt4j0eJJ2E84G+NVvx47FJj+uvBI5
a1ZpcHtSP2T3AhWa78eexTisRTC78AGGJ/h3lDWpiWefViGfyusupAafVzBOcv5K
JG+R8gpEwAg56BiB6xUhL4CiDfJfgjj0kfzaYOX79CF23j/fz8ebJnY861HaJmTO
3MTeR0L5jiHhffOIKp0L44BhhqI+HnteWLKQ51IBACN10noiaI+ru9GmqhBTdpXK
FGiBTESUH0M4AM9sF/Jbd4pMeZERXX1YTIhoJnt3i/84X3JGo2ywecuKaP2ZpmtJ
Tl//dxKvXXrdECCET9S/zCvyRHNZh12XYUyBZlnpPMwuYZuTaX92dhXGtpMipVOi
hIvi2LAjI+R3GVXHrHHB
=TKky
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
