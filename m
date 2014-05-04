Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaEDPlO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaEDPlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 000/158] 3.14.3-stable review
Date: Sun,  4 May 2014 11:38:29 -0400
Message-Id: <20140504154029.975081050@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.3 release.
There are 158 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue May  6 15:38:47 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.3-rc1

Aaron Sanders <aaron.sanders@hp.com>
    USB: pl2303: add ids for Hewlett-Packard HP POS pole displays

Stephen Warren <swarren@nvidia.com>
    USB: EHCI: tegra: set txfill_tuning

Stephen Warren <swarren@nvidia.com>
    dt: tegra: remove non-existent clock IDs

Stephen Warren <swarren@nvidia.com>
    clk: tegra: remove non-existent clocks

Stephen Warren <swarren@nvidia.com>
    ARM: tegra: remove UART5/UARTE from tegra124.dtsi

Julius Werner <jwerner@chromium.org>
    usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb

Theodore Ts'o <tytso@mit.edu>
    ext4: use i_size_read in ext4_unaligned_aio()

Theodore Ts'o <tytso@mit.edu>
    ext4: move ext4_update_i_disksize() into mpage_map_and_submit_extent()

Jan Kara <jack@suse.cz>
    ext4: fix jbd2 warning under heavy xattr load

Matthew Wilcox <willy@linux.intel.com>
    ext4: note the error in ext4_end_bio()

Kazuya Mio <k-mio@sx.jp.nec.com>
    ext4: FIBMAP ioctl causes BUG_ON due to handle EXT_MAX_BLOCKS

Martin K. Petersen <martin.petersen@oracle.com>
    block: Fix for_each_bvec()

Al Viro <viro@zeniv.linux.org.uk>
    smarter propagate_mnt()

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    clk: s2mps11: Fix possible NULL pointer dereference

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    ocfs2: fix panic on kfree(xattr->name)

alex chen <alex.chen@huawei.com>
    ocfs2: do not put bh when buffer_uptodate failed

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: dlm: fix recovery hung

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: dlm: fix lock migration crash

Serge Hallyn <serge.hallyn@ubuntu.com>
    xattr: guard against simultaneous glibc header inclusion

Liu Hua <sdu.liu@huawei.com>
    hung_task: check the value of "sysctl_hung_task_timeout_sec"

Mizuma, Masayoshi <m.mizuma@jp.fujitsu.com>
    mm: hugetlb: fix softlockup when a large number of hugepages are freed.

Vlastimil Babka <vbabka@suse.cz>
    mm: try_to_unmap_cluster() should lock_page() before mlocking

Johannes Weiner <hannes@cmpxchg.org>
    mm: page_alloc: spill to remote nodes before waking kswapd

Matt Fleming <matt.fleming@intel.com>
    sh: fix format string bug in stack tracer

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Add missing se_cmd put for WRITE_PENDING in tx_comp_err

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Match FRMR descriptors to available session tags

Sam Bradshaw <sbradshaw@micron.com>
    mtip32xx: mtip_async_complete() bug fixes

Felipe Franciosi <felipe@paradoxo.org>
    mtip32xx: Unmap the DMA segments before completing the IO request

Felipe Franciosi <felipe@paradoxo.org>
    mtip32xx: Set queue bounce limit

Alan Stern <stern@rowland.harvard.edu>
    USB: unbind all interfaces before rebinding any

Daniel Mack <zonque@gmail.com>
    usb: phy: am335x-control: wait 1ms after power-up transitions

Michal Simek <michal.simek@xilinx.com>
    usb: phy: Add ulpi IDs for SMSC USB3320 and TI TUSB1210

Paul Gortmaker <paul.gortmaker@windriver.com>
    hvc: ensure hvc_init is only ever called once in hvc_console.c

Felipe Balbi <balbi@ti.com>
    usb: musb: fix PHY power on/off

Felipe Balbi <balbi@ti.com>
    usb: musb: avoid NULL pointer dereference

Felipe Balbi <balbi@ti.com>
    usb: dwc3: fix randconfig build errors

Huang Rui <ray.huang@amd.com>
    usb: dwc3: fix wrong bit mask in dwc3_event_devt

Wolfram Sang <wsa@the-dreams.de>
    media: media: gspca: sn9c20x: add ID for Genius Look 1320 V2

Florian Vaussard <florian.vaussard@epfl.ch>
    media: omap3isp: preview: Fix the crop margins

Hans Verkuil <hans.verkuil@cisco.com>
    media: saa7134: fix WARN_ON during resume

Antti Palosaari <crope@iki.fi>
    media: em28xx: fix PCTV 290e LNA oops

Malcolm Priestley <tvboxspy@gmail.com>
    media: m88rs2000: add caps FE_CAN_INVERSION_AUTO

Frank Schaefer <fschaefer.oss@googlemail.com>
    media: em28xx-audio: fix user counting in snd_em28xx_capture_open()

Malcolm Priestley <tvboxspy@gmail.com>
    media: m88rs2000: prevent frontend crash on continuous transponder scans

Hans Verkuil <hans.verkuil@cisco.com>
    media: v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32 support

Hans Verkuil <hans.verkuil@cisco.com>
    media: v4l2-dv-timings: add module name, description, license

Antoine Ténart <antoine.tenart@free-electrons.com>
    video: atmel_lcdfb: ensure the hardware is initialized with the correct mode

Hans Verkuil <hverkuil@xs4all.nl>
    media: videodev2.h: add parenthesis around macro arguments

Oleksij Rempel <linux@rempel-privat.de>
    media: uvcvideo: Do not use usb_set_interface on bulk EP

David Cohen <david.a.cohen@linux.intel.com>
    usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM

Igor Gnatenko <i.gnatenko.brain@gmail.com>
    xhci: extend quirk for Renesas cards

Denis Turischev <denis.turischev@compulab.co.il>
    xhci: Switch Intel Lynx Point ports to EHCI on shutdown.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Prevent runtime pm from autosuspending during initialization

Roger Quadros <rogerq@ti.com>
    usb: gadget: zero: Fix SuperSpeed enumeration for alternate setting 1

Gregory CLEMENT <gregory.clement@free-electrons.com>
    usb: gadget: atmel_usba: fix crashed during stopping when DEBUG is enabled

Kees Cook <keescook@chromium.org>
    usb: gadget: tcm_usb_gadget: stop format strings

Jeff Mahoney <jeffm@suse.com>
    reiserfs: fix race in readdir

Russell King <rmk+kernel@arm.linux.org.uk>
    DRM: armada: fix corruption while loading cursors

Miklos Szeredi <mszeredi@suse.cz>
    arm64: __NR_compat_syscalls fix

Will Deacon <will.deacon@arm.com>
    word-at-a-time: avoid undefined behaviour in zero_bytemask macro

Matt Fleming <matt.fleming@intel.com>
    efi: Pass correct file handle to efi_file_{read,close}

Matt Fleming <matt@console-pimps.org>
    x86/efi: Correct EFI boot stub use of code32_start

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 hosts

Andy Grover <agrover@redhat.com>
    target/tcm_fc: Fix use-after-free of ft_tpg

Nicholas Bellinger <nab@linux-iscsi.org>
    target/iblock: Fix double bioset_integrity_free bug

Martin Svec <martin.svec@zoner.cz>
    Target/sbc: Initialize COMPARE_AND_WRITE write_sg scatterlist

Quinn Tran <quinn.tran@qlogic.com>
    target/rd: T10-Dif: RAM disk is allocating more space than required.

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix ERL=2 ASYNC_EVENT connection pointer bug

Dan Carpenter <dan.carpenter@oracle.com>
    SCSI: arcmsr: upper 32 of dma address lost

Dan Carpenter <dan.carpenter@oracle.com>
    SCSI: qla2xxx: fix error handling of qla2x00_mem_alloc()

Mike Marciniszyn <mike.marciniszyn@intel.com>
    ib_srpt: Use correct ib_sg_dma primitives

Moni Shoua <monis@mellanox.com>
    IB/core: Don't resolve passive side RoCE L2 address in CMA REQ handler

Yann Droneaud <ydroneaud@opteya.com>
    IB/qib: add missing braces in do_qib_user_sdma_queue_create()

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/qib: Fix debugfs ordering issue with multiple HCAs

Yann Droneaud <ydroneaud@opteya.com>
    IB/ehca: Returns an error on ib_copy_to_udata() failure

Yann Droneaud <ydroneaud@opteya.com>
    IB/mthca: Return an error on ib_copy_to_udata() failure

Yann Droneaud <ydroneaud@opteya.com>
    IB/nes: Return an error on ib_copy_from_udata() failure instead of NULL

Dennis Dalessandro <dennis.dalessandro@intel.com>
    IB/ipath: Fix potential buffer overrun in sending diag packet routine

Jeff Layton <jlayton@redhat.com>
    nfsd: set timeparms.to_maxval in setup_callback_client

Kinglong Mee <kinglongmee@gmail.com>
    NFSD: Traverse unconfirmed client through hash-table

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix setclientid encode size

Yan, Zheng <zheng.z.yan@intel.com>
    nfsd4: fix memory leak in nfsd4_encode_fattr()

Stanislav Kinsbursky <skinsbursky@parallels.com>
    nfsd: check passed socket's net matches NFSd superblock's one

J. Bruce Fields <bfields@redhat.com>
    nfsd: notify_change needs elevated write count

J. Bruce Fields <bfields@redhat.com>
    nfsd4: leave reply buffer space for failed setattr

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix test_stateid error reply encoding

J. Bruce Fields <bfields@redhat.com>
    nfsd4: buffer-length check for SUPPATTR_EXCLCREAT

J. Bruce Fields <bfields@redhat.com>
    nfsd4: session needs room for following op to error out

J. Bruce Fields <bfields@redhat.com>
    nfsd: revert v2 half of "nfsd: don't return high mode bits"

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix a use-after-free problem in open()

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    iio: cm36651: Fix i2c client leak and possible NULL pointer dereference

Beomho Seo <beomho.seo@samsung.com>
    iio: cm32181: Fix read integration time function

Alexandre Belloni <alexandre.belloni@free-electrons.com>
    iio: adc: at91_adc: Repair broken platform_data support

Alec Berg <alecaberg@chromium.org>
    iio: querying buffer scan_mask should return 0/1

Alan Stern <stern@rowland.harvard.edu>
    USB: fix crash during hotplug of PCI USB controller card

Jean-Jacques Hiblot <jjhiblot@traphandler.com>
    PCI: mvebu: Fix potential issue in range parsing

Marek Vasut <marex@denx.de>
    PCI: imx6: Wait for retraining

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    regulator: arizona-ldo1: Correct default regulator init_data

H. Peter Anvin <hpa@linux.intel.com>
    x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels

Petr Mladek <pmladek@suse.cz>
    ftrace/x86: One more missing sync after fixup of function modification failure

Fenghua Yu <fenghua.yu@intel.com>
    x86, AVX-512: Enable AVX-512 States Context Switch

Fenghua Yu <fenghua.yu@intel.com>
    x86, AVX-512: AVX-512 Feature Detection

Jan Beulich <JBeulich@suse.com>
    x86, hash: Fix build failure with older binutils

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8188eu: Calling rtw_get_stainfo() with a NULL sta_addr will return NULL

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: usbdux: bug fix for accessing 'ao_chanlist' in private data

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8712u: Fix case where ethtype was never obtained and always be checked against 0

Himangi Saraogi <himangi774@gmail.com>
    staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to integer

David Fries <David@Fries.net>
    w1: fix w1_send_slave dropping a slave id

Tomas Novotny <tomas@novotny.cz>
    mfd: twl-core: Fix accessibility of some twl4030 audio registers

Guenter Roeck <linux@roeck-us.net>
    mfd: kempld-core: Fix potential hang-up during boot

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: tps65910: Fix possible invalid pointer dereference on regmap_add_irq_chip fail

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max8997: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max8998: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max77693: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max77686: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: 88pm800: Fix I2C device resource leak if probe fails

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: 88pm860x: Fix I2C device resource leak on regmap init fail

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: 88pm860x: Fix possible NULL pointer dereference on i2c_new_dummy error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: sec-core: Fix possible NULL pointer dereference when i2c_new_dummy error

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: ignore client writing state during cb completion

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: do not load the driver if the FW doesn't support MEI interface

Tomas Winkler <tomas.winkler@intel.com>
    mei: fix memory leak of pending write cb objects

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390: fix control register update

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/bitops,atomic: add missing memory barriers

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: Optimize ucontrol path

Sebastian Ott <sebott@linux.vnet.ibm.com>
    s390/cio: fix driver callback initialization for ccw consoles

Axel Lin <axel.lin@ingics.com>
    spi: dw: Don't call kfree for memory allocated by devm_kzalloc

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: efm32: use $vendor,$device scheme for compatible string

Lv Zheng <lv.zheng@intel.com>
    ACPICA: Restore code that repairs NULL package elements in return values.

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add headset Mic support for Dell machine

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add support of ALC288 codec

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix silent speaker output due to mute LED fixup

Takashi Iwai <tiwai@suse.de>
    ALSA: ice1712: Fix boundary checks in PCM pointer ops

W. Trevor King <wking@tremily.us>
    ALSA: hda - Enable beep for ASUS 1015E

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - add headset mic detect quirks for three Dell laptops

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Restore default value for ALC283

Andrea Adami <andrea.adami@gmail.com>
    ARM: pxa: hx4700.h: include "irqs.h" for PXA_NR_BUILTIN_GPIO

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: ensure the mdio node has a clock reference on Armada 370/XP

Liu Hua <sdu.liu@huawei.com>
    ARM: 8030/1: ARM : kdump : add arch_crash_save_vmcoreinfo

Xiangyu Lu <luxiangyu@huawei.com>
    ARM: 8027/1: fix do_div() bug in big-endian systems

Christopher Covington <cov@codeaurora.org>
    ARM: 8007/1: Remove extraneous kcmp syscall ignore

Andrew Lunn <andrew@lunn.ch>
    ARM: Fix default CPU selection for ARCH_MULTI_V5

Will Deacon <will.deacon@arm.com>
    ARM: 7954/1: mm: remove remaining domain support from ARMv6

Tomasz Figa <t.figa@samsung.com>
    ARM: dts: Keep G3D regulator always on for exynos5250-arndale

Florian Vaussard <florian.vaussard@epfl.ch>
    ARM: dts: omap4/5: Use l3_ick for the gpmc node

Mugunthan V N <mugunthanvnm@ti.com>
    ARM: dts: am33xx: correcting dt node unit address for usb

Roger Quadros <rogerq@ti.com>
    ARM: OMAP3: hwmod data: Correct clock domains for USB modules

Nishanth Menon <nm@ti.com>
    ARM: OMAP4: Fix definition of IS_PM44XX_ERRATUM

Florian Vaussard <florian.vaussard@epfl.ch>
    CLK: TI: OMAP4/5/DRA7: Remove gpmc_fck from dummy clocks

Suman Anna <s-anna@ti.com>
    ARM: OMAP2+: hwmod: fix missing braces in _init()

Stefan Sørensen <stefan.sorensen@spectralink.com>
    ARM: OMAP2+: INTC: Acknowledge stuck active interrupts

Brian Austin <brian.austin@cirrus.com>
    ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE

Brian Austin <brian.austin@cirrus.com>
    ASoC: cs42l52: Fix mask bits for SOC_VALUE_ENUM_SINGLE

Brian Austin <brian.austin@cirrus.com>
    ASoC: cs42l51: Fix SOC_DOUBLE_R_SX_TLV shift values for ADC, PCM, and Analog kcontrols

Mark Brown <broonie@linaro.org>
    ASoC: pcm: Drop incorrect double/extra frees

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Make DMA coherent and strongly ordered mappings not executable

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Do not synchronise I and D caches for special ptes


-------------

Diffstat:

 .../devicetree/bindings/spi/efm32-spi.txt          |   4 +-
 Documentation/sysctl/kernel.txt                    |   1 +
 Documentation/video4linux/gspca.txt                |   1 +
 Makefile                                           |   4 +-
 arch/arm/Kconfig                                   |   2 +-
 arch/arm/boot/dts/am33xx.dtsi                      |   4 +-
 arch/arm/boot/dts/armada-370-xp.dtsi               |   1 +
 arch/arm/boot/dts/exynos5250-arndale.dts           |   1 +
 arch/arm/boot/dts/omap4.dtsi                       |   2 +
 arch/arm/boot/dts/omap5.dtsi                       |   2 +
 arch/arm/boot/dts/tegra124.dtsi                    |  13 --
 arch/arm/include/asm/div64.h                       |   2 +-
 arch/arm/include/asm/futex.h                       |   6 -
 arch/arm/include/asm/pgtable-2level.h              |   1 +
 arch/arm/include/asm/unistd.h                      |   1 -
 arch/arm/kernel/machine_kexec.c                    |   7 +
 arch/arm/mach-omap2/irq.c                          |   8 +
 arch/arm/mach-omap2/omap_hwmod.c                   |   3 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   4 +-
 arch/arm/mach-omap2/pm.h                           |   2 +-
 arch/arm/mach-pxa/include/mach/hx4700.h            |   1 +
 arch/arm/mm/Kconfig                                |   3 +-
 arch/arm/mm/mmu.c                                  |  10 ++
 arch/arm/mm/proc-macros.S                          |  19 +-
 arch/arm/mm/proc-v7-2level.S                       |   7 -
 arch/arm64/include/asm/pgtable.h                   |   8 +-
 arch/arm64/include/asm/unistd32.h                  |   2 +-
 arch/s390/include/asm/atomic.h                     |  70 +++++---
 arch/s390/include/asm/bitops.h                     |  41 +++--
 arch/s390/include/asm/ccwdev.h                     |   2 +-
 arch/s390/kernel/ptrace.c                          |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   3 +-
 arch/sh/kernel/dumpstack.c                         |   2 +-
 arch/x86/Makefile                                  |   1 +
 arch/x86/boot/compressed/eboot.c                   |   5 +-
 arch/x86/boot/compressed/head_32.S                 |  14 +-
 arch/x86/boot/compressed/head_64.S                 |   9 +-
 arch/x86/include/asm/cpufeature.h                  |   4 +
 arch/x86/include/asm/xsave.h                       |  16 +-
 arch/x86/kernel/ftrace.c                           |   2 +-
 arch/x86/kernel/ldt.c                              |  11 ++
 arch/x86/lib/hash.c                                |   4 +
 drivers/acpi/acpica/nsrepair.c                     |  25 ++-
 drivers/block/mtip32xx/mtip32xx.c                  |  88 +++++----
 drivers/block/mtip32xx/mtip32xx.h                  |   2 +-
 drivers/clk/clk-s2mps11.c                          |   2 +-
 drivers/clk/tegra/clk-tegra124.c                   |   3 -
 drivers/clk/ti/clk-44xx.c                          |   1 -
 drivers/clk/ti/clk-54xx.c                          |   1 -
 drivers/clk/ti/clk-7xx.c                           |   1 -
 drivers/firmware/efi/efi-stub-helper.c             |   6 +-
 drivers/gpu/drm/armada/armada_crtc.c               |   1 +
 drivers/hv/connection.c                            |   5 +-
 drivers/iio/adc/at91_adc.c                         |  26 ++-
 drivers/iio/industrialio-buffer.c                  |   6 +-
 drivers/iio/light/cm32181.c                        |   1 +
 drivers/iio/light/cm36651.c                        |  22 ++-
 drivers/infiniband/core/cm.c                       |  17 --
 drivers/infiniband/core/cma.c                      |  26 ---
 drivers/infiniband/hw/ehca/ehca_cq.c               |   1 +
 drivers/infiniband/hw/ipath/ipath_diag.c           |  66 +++----
 drivers/infiniband/hw/mthca/mthca_provider.c       |   1 +
 drivers/infiniband/hw/nes/nes_verbs.c              |   2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c           |   3 +-
 drivers/infiniband/hw/qib/qib_init.c               |  25 ++-
 drivers/infiniband/ulp/isert/ib_isert.c            |  70 +++++---
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  16 +-
 drivers/media/dvb-frontends/m88rs2000.c            |  19 +-
 drivers/media/pci/saa7134/saa7134-cards.c          |   4 +-
 drivers/media/platform/omap3isp/isppreview.c       |   9 +
 drivers/media/usb/em28xx/em28xx-audio.c            |  22 +--
 drivers/media/usb/em28xx/em28xx-dvb.c              |   3 +-
 drivers/media/usb/gspca/sn9c20x.c                  |   1 +
 drivers/media/usb/uvc/uvc_video.c                  |  20 ++-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   4 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   4 +
 drivers/mfd/88pm800.c                              |   3 +-
 drivers/mfd/88pm860x-core.c                        |   6 +
 drivers/mfd/kempld-core.c                          |   7 +-
 drivers/mfd/max77686.c                             |   4 +
 drivers/mfd/max77693.c                             |  12 +-
 drivers/mfd/max8925-i2c.c                          |   9 +
 drivers/mfd/max8997.c                              |  18 ++
 drivers/mfd/max8998.c                              |   4 +
 drivers/mfd/sec-core.c                             |   4 +
 drivers/mfd/tps65910.c                             |   4 +-
 drivers/mfd/twl-core.c                             |  10 +-
 drivers/misc/mei/client.c                          |  76 +++++---
 drivers/misc/mei/client.h                          |  18 --
 drivers/misc/mei/hw-me-regs.h                      |   5 +
 drivers/misc/mei/interrupt.c                       |   3 +-
 drivers/misc/mei/main.c                            |   3 +-
 drivers/misc/mei/pci-me.c                          |  30 +++-
 drivers/pci/host/pci-imx6.c                        |  47 +++--
 drivers/pci/host/pci-mvebu.c                       |   2 +-
 drivers/regulator/arizona-ldo1.c                   |   7 +-
 drivers/s390/char/con3215.c                        |   2 +-
 drivers/s390/char/con3270.c                        |   6 +-
 drivers/s390/char/raw3270.c                        |  10 +-
 drivers/s390/char/raw3270.h                        |   2 +-
 drivers/s390/cio/device.c                          |   3 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                   |   7 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   6 +-
 drivers/spi/spi-dw.c                               |   7 -
 drivers/spi/spi-efm32.c                            |   3 +
 drivers/staging/comedi/drivers/usbdux.c            |   9 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c          |   4 +-
 drivers/staging/rtl8712/rtl871x_recv.c             |  13 +-
 drivers/staging/serqt_usb2/serqt_usb2.c            |   2 +-
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/target/target_core_iblock.c                |   5 +-
 drivers/target/target_core_rd.c                    |  14 +-
 drivers/target/target_core_sbc.c                   |   3 +-
 drivers/target/tcm_fc/tfc_sess.c                   |   1 +
 drivers/tty/hvc/hvc_console.c                      |   6 +-
 drivers/usb/core/driver.c                          |  94 ++++++----
 drivers/usb/core/hcd-pci.c                         |   2 +-
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/core/usb.h                             |   2 +-
 drivers/usb/dwc3/core.h                            |  39 +++-
 drivers/usb/dwc3/gadget.h                          |  12 --
 drivers/usb/gadget/atmel_usba_udc.c                |   6 +-
 drivers/usb/gadget/tcm_usb_gadget.c                |   2 +-
 drivers/usb/gadget/zero.c                          |   2 +-
 drivers/usb/host/ehci-tegra.c                      |  23 +++
 drivers/usb/host/xhci-pci.c                        |  17 +-
 drivers/usb/host/xhci-ring.c                       |  67 ++++---
 drivers/usb/host/xhci.c                            |   7 +-
 drivers/usb/host/xhci.h                            |   2 -
 drivers/usb/musb/musb_core.c                       |   5 +-
 drivers/usb/musb/omap2430.c                        |   2 +
 drivers/usb/phy/phy-am335x-control.c               |   9 +
 drivers/usb/phy/phy-ulpi.c                         |   2 +
 drivers/usb/serial/pl2303.c                        |   3 +
 drivers/usb/serial/pl2303.h                        |   5 +-
 drivers/video/atmel_lcdfb.c                        |   6 +
 drivers/w1/w1_netlink.c                            |  25 +--
 fs/ext4/ext4.h                                     |  17 --
 fs/ext4/file.c                                     |   2 +-
 fs/ext4/inode.c                                    |  20 ++-
 fs/ext4/page-io.c                                  |   5 +-
 fs/ext4/xattr.c                                    |  23 ++-
 fs/namespace.c                                     |  11 +-
 fs/nfs/nfs4proc.c                                  |  19 +-
 fs/nfsd/nfs4callback.c                             |   4 +-
 fs/nfsd/nfs4proc.c                                 |   9 +-
 fs/nfsd/nfs4state.c                                |  13 +-
 fs/nfsd/nfs4xdr.c                                  |   9 +-
 fs/nfsd/nfsctl.c                                   |   5 +
 fs/nfsd/nfsd.h                                     |   2 +-
 fs/nfsd/nfsxdr.c                                   |   2 +-
 fs/nfsd/vfs.c                                      |   9 +
 fs/ocfs2/buffer_head_io.c                          |   2 -
 fs/ocfs2/dlm/dlmrecovery.c                         |  29 ++-
 fs/ocfs2/namei.c                                   |   2 -
 fs/pnode.c                                         | 198 +++++++++++++--------
 fs/pnode.h                                         |   3 +
 fs/reiserfs/dir.c                                  |   6 +-
 include/asm-generic/word-at-a-time.h               |   8 +-
 include/dt-bindings/clock/tegra124-car.h           |   6 +-
 include/linux/bio.h                                |   6 +-
 include/linux/hyperv.h                             |   4 +-
 include/linux/mount.h                              |   3 +
 include/linux/sunrpc/svcsock.h                     |   1 +
 include/rdma/ib_cm.h                               |   1 -
 include/uapi/linux/libc-compat.h                   |   9 +
 include/uapi/linux/videodev2.h                     |  10 +-
 include/uapi/linux/xattr.h                         |   7 +
 kernel/sysctl.c                                    |   6 +
 mm/hugetlb.c                                       |   1 +
 mm/internal.h                                      |   1 +
 mm/mlock.c                                         |   2 +
 mm/page_alloc.c                                    |  89 ++++-----
 mm/rmap.c                                          |  14 +-
 net/sunrpc/svcsock.c                               |  16 ++
 sound/pci/hda/patch_realtek.c                      |  98 +++++++++-
 sound/pci/ice1712/ice1712.c                        |  15 +-
 sound/soc/codecs/cs42l51.c                         |   9 +-
 sound/soc/codecs/cs42l52.c                         |   8 +-
 sound/soc/codecs/cs42l73.c                         |   6 +-
 sound/soc/soc-pcm.c                                |   3 -
 181 files changed, 1411 insertions(+), 826 deletions(-)


