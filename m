Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087AbaKLERY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:17:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaKLBVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:21:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.17 000/319] 3.17.3-stable review
Date: Wed, 12 Nov 2014 10:12:18 +0900
Message-Id: <20141112010952.553519040@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.17.3 release.
There are 319 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Nov 14 01:07:52 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.17.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.17.3-rc1

Olivier Gay <ogay@logitech.com>
    HID: add keyboard input assist hid usages

Dave Chinner <dchinner@redhat.com>
    xfs: track bulkstat progress by agino

Dave Chinner <dchinner@redhat.com>
    xfs: bulkstat error handling is broken

Dave Chinner <dchinner@redhat.com>
    xfs: bulkstat main loop logic is a mess

Dave Chinner <dchinner@redhat.com>
    xfs: bulkstat chunk-formatter has issues

Dave Chinner <dchinner@redhat.com>
    xfs: bulkstat chunk formatting cursor is broken

Dave Chinner <dchinner@redhat.com>
    xfs: bulkstat btree walk doesn't terminate

Jan Kara <jack@suse.cz>
    xfs: Check error during inode btree iteration in xfs_bulkstat()

Dave Chinner <dchinner@redhat.com>
    xfs: bulkstat doesn't release AGI buffer on error

Chris Mason <clm@fb.com>
    Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error cleanup

Grant Likely <grant.likely@linaro.org>
    of: Fix overflow bug in string property parsing functions

Andreas Färber <afaerber@suse.de>
    ARM: dts: zynq: Enable PL clocks for Parallella

Yijing Wang <wangyijing@huawei.com>
    sysfs: driver core: Fix glue dir race condition by gdp_mutex

Wolfram Sang <wsa@the-dreams.de>
    i2c: at91: don't account as iowait

Grzegorz Jaszczyk <jaz@semihalf.com>
    irqchip: armada-370-xp: Fix MPIC interrupt handling

Grzegorz Jaszczyk <jaz@semihalf.com>
    irqchip: armada-370-xp: Fix MSI interrupt handling

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    regulator: max77693: Fix use of uninitialized regulator config

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - fix mute led problem for three HP laptops

Anton Blanchard <anton@samba.org>
    powerpc: do_notify_resume can be called with bad thread_info flags argument

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/powernv: Properly fix LPC debugfs endianness

Dan Streetman <ddstreet@ieee.org>
    powerpc: use device_online/offline() instead of cpu_up/down()

Robert Jarzmik <robert.jarzmik@free.fr>
    ARM: pxa: fix hang on startup with DEBUG_LL

David Cohen <david.a.cohen@linux.intel.com>
    pinctrl: baytrail: show output gpio state correctly on Intel Baytrail

Al Viro <viro@zeniv.linux.org.uk>
    fix breakage in o2net_send_tcp_msg()

Hans de Goede <hdegoede@redhat.com>
    samsung-laptop: Add broken-acpi-video quirk for NC210/NC110

Hans de Goede <hdegoede@redhat.com>
    acer-wmi: Add acpi_backlight=video quirk for the Acer KAV80

Jan Kara <jack@suse.cz>
    rbd: Fix error recovery in rbd_obj_read_sync()

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    mm: cma: Don't crash on allocation if CMA area can't be activated

jens stein <jens.s.stein@gmail.com>
    drm/i915: Ignore VBT backlight check on Macbook 2, 1

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix GMBUSFREQ on vlv/chv

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Do a dummy DPCD read before the actual read

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: remove invalid pci id

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: dpm fixes for asrock systems

Michel Dänzer <michel.daenzer@amd.com>
    drm/radeon: Use drm_malloc_ab instead of kmalloc_array

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm: disable ulv support on SI

Sinclair Yeh <syeh@vmware.com>
    drm/vmwgfx: Filter out modes those cannot be supported by the current VRAM size.

Jiang Liu <jiang.liu@linux.intel.com>
    x86, intel-mid: Create IRQs for APB timers and RTC timers

Kirill Tkhai <ktkhai@parallels.com>
    sched: Use rq->rd in sched_setaffinity() under RCU read lock

Felipe Balbi <balbi@ti.com>
    usb: gadget: function: acm: make f_acm pass USB20CV Chapter9

Felipe Balbi <balbi@ti.com>
    usb: dwc3: gadget: fix set_halt() bug with pending transfers

Ben Hutchings <ben@decadent.org.uk>
    mtd: m25p80: Fix module aliases for m25p80

Ondrej Kozina <okozina@redhat.com>
    crypto: algif - avoid excessive use of socket buffer in skcipher

Sylwester Nawrocki <s.nawrocki@samsung.com>
    media: Remove references to non-existent PLAT_S5P symbol

Jan Kara <jack@suse.cz>
    mm: Remove false WARN_ON from pagecache_isize_extended()

Andy Lutomirski <luto@amacapital.net>
    x86, apic: Handle a bad TSC more gracefully

Mathias Krause <minipli@googlemail.com>
    posix-timers: Fix stack info leak in timer_create()

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
    mtd: cfi_cmdset_0001.c: fix resume for LH28F640BF chips

Karl Beldan <karl.beldan@rivierawaves.com>
    mac80211: fix typo in starting baserate for rts_cts_rate_idx

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: fix memory leak / bad pointer freeing for chanlist

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: (regression) channel list must be set for COMEDI_CMD ioctl

Imre Deak <imre.deak@intel.com>
    PM / Sleep: fix recovery during resuming from hibernation

Imre Deak <imre.deak@intel.com>
    PM / Sleep: fix async suspend_late/freeze_late error handling

Peter Hurley <peter@hurleysoftware.com>
    tty: Fix high cpu load if tty is unreleaseable

Imre Deak <imre.deak@intel.com>
    tty/vt: don't set font mappings on vc not supporting this

Jan Kara <jack@suse.cz>
    quota: Properly return errors from dquot_writeback_dquots()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    PCI: Rename sysfs 'enabled' file back to 'enable'

Jan Kara <jack@suse.cz>
    ext3: Don't check quota format when there are no quota files

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    Revert "iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate"

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dvm: drop non VO frames when flushing

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: configure the LTR

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: BT Coex - update the MPLUT Boost register value

Will Deacon <will.deacon@arm.com>
    zap_pte_range: update addr when forcing flush after TLB batching faiure

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix crash on unknown operation number

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix response size estimation for OP_SEQUENCE

Jason Baron <jbaron@akamai.com>
    cpc925_edac: Report UE events properly

Jason Baron <jbaron@akamai.com>
    e7xxx_edac: Report CE events properly

Jason Baron <jbaron@akamai.com>
    i3200_edac: Report CE events properly

Jason Baron <jbaron@akamai.com>
    i82860_edac: Report CE events properly

Christoph Hellwig <hch@lst.de>
    scsi: set REQ_QUEUE for the blk-mq case

Tony Battersby <tonyb@cybernetics.com>
    lib/scatterlist: fix memory leak with scsi-mq

Jan Kara <jack@suse.cz>
    scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND

Hans de Goede <hdegoede@redhat.com>
    xhci: Disable streams on Asmedia 1042 xhci controllers

Oliver Neukum <oneukum@suse.de>
    xhci: no switching back on non-ULT Haswell

Konstantin Khlebnikov <k.khlebnikov@samsung.com>
    mm/balloon_compaction: fix deflation when compaction is disabled

Jan Kara <jack@suse.cz>
    lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcontrol: fix missed end-writeback page accounting

Johannes Weiner <hannes@cmpxchg.org>
    mm: page-writeback: inline account_page_dirtied() into single caller

Wang Nan <wangnan0@huawei.com>
    cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.

Yu Zhao <yuzhao@google.com>
    mm: free compound page with correct order

Andriy Skulysh <askulysh@gmail.com>
    sh: fix sh770x SCIF memory regions

Dmitry Kasatkin <d.kasatkin@samsung.com>
    ima: check xattr value length and type in the ima_inode_setxattr()

Sylwester Nawrocki <s.nawrocki@samsung.com>
    usb: Remove references to non-existent PLAT_S5P symbol

Johan Hovold <johan@kernel.org>
    USB: kobil_sct: fix non-atomic allocation in write path

Hans de Goede <hdegoede@redhat.com>
    usb: Do not allow usb_alloc_streams on unconfigured devices

Johan Hovold <johan@kernel.org>
    USB: opticon: fix non-atomic allocation in write path

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: handle a skipped data phase

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix device_del() sysfs warnings at disconnect

Felipe Balbi <balbi@ti.com>
    usb: gadget: udc: core: fix kernel oops with soft-connect

Adel Gadllah <adel.gadllah@gmail.com>
    HID: usbhid: enable always-poll quirk for Elan Touchscreen 016f

Adel Gadllah <adel.gadllah@gmail.com>
    HID: usbhid: enable always-poll quirk for Elan Touchscreen 009b

Oliver Neukum <oneukum@suse.de>
    HID: usbhid: add another mouse that needs QUIRK_ALWAYS_POLL

Oliver Neukum <oneukum@suse.de>
    HID: usbhid: fix PIXART optical mouse

Johan Hovold <johan@kernel.org>
    HID: usbhid: enable always-poll quirk for Elan Touchscreen

Johan Hovold <johan@kernel.org>
    HID: usbhid: add always-poll quirk

Adel Gadllah <adel.gadllah@gmail.com>
    USB: quirks: enable device-qualifier quirk for yet another Elan touchscreen

Adel Gadllah <adel.gadllah@gmail.com>
    USB: quirks: enable device-qualifier quirk for another Elan touchscreen

Johan Hovold <johan@kernel.org>
    USB: quirks: enable device-qualifier quirk for Elan Touchscreen

Johan Hovold <johan@kernel.org>
    USB: core: add device-qualifier quirk

Torsten Fleischer <to-fleischer@t-online.de>
    usb: chipidea: Fix oops when removing the ci_hdrc module

David Cohen <david.a.cohen@linux.intel.com>
    usb: ffs: fix regression when quirk_ep_out_aligned_size flag is set

Robert Baldyga <r.baldyga@samsung.com>
    usb: gadget: f_fs: remove redundant ffs_data_get()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: musb: dsps: start OTG timer on resume again

Thomas Gleixner <tglx@linutronix.de>
    usb: musb: cppi41: restart hrtimer only if not yet done

Hans de Goede <hdegoede@redhat.com>
    uas: Add US_FL_NO_ATA_1X quirk for 1 more Seagate model

Hans de Goede <hdegoede@redhat.com>
    uas: Add US_FL_NO_ATA_1X quirk for 2 more Seagate models

Hans de Goede <hdegoede@redhat.com>
    uas: Add NO_ATA_1X for VIA VL711 devices

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
    spi: pxa2xx: toggle clocks on suspend if not disabled by runtime PM

Alexander Stein <alexander.stein@systec-electronic.com>
    spi: fsl-dspi: Fix CTAR selection

Ray Jui <rjui@broadcom.com>
    spi: pl022: Fix incorrect dma_unmap_sg

Jack Pham <jackp@codeaurora.org>
    usb: dwc3: gadget: Properly initialize LINK TRB

Roger Quadros <rogerq@ti.com>
    Revert "usb: dwc3: dwc3-omap: Disable/Enable only wrapper interrupts in prepare/complete"

Cyril Brulebois <kibi@debian.org>
    wireless: rt2x00: add new rt2800usb device

Canek Peláez Valdés <canek@ciencias.unam.mx>
    rt2x00: support Ralink 5362.

Dan Williams <dcbw@redhat.com>
    USB: option: add Haier CE81B CDMA modem

Daniele Palmas <dnlplm@gmail.com>
    usb: option: add support for Telit LE910

Oussama Ghorbel <ghorbel@pivasoftware.com>
    phy: omap-usb2: Enable runtime PM of omap-usb2 phy properly

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: add quirk for control-line state requests

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: only raise DTR on transitions from B0

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: add device id for GW Instek AFG-2225

Perry Hung <iperry@gmail.com>
    usb: serial: ftdi_sio: add "bricked" FTDI device PID

Frans Klaver <frans.klaver@xsens.com>
    usb: serial: ftdi_sio: add Awinda Station and Dongle products

Nathaniel Ting <nathaniel.ting@silabs.com>
    USB: serial: cp210x: add Silicon Labs 358x VID and PID

Peter Hurley <peter@hurleysoftware.com>
    serial: Fix divide-by-zero fault in uart_get_divisor()

Stephen Boyd <sboyd@codeaurora.org>
    serial: msm_serial: Fix kgdb continue

Lars-Peter Clausen <lars@metafoo.de>
    staging:iio:ade7758: Remove "raw" from channel name

Lars-Peter Clausen <lars@metafoo.de>
    staging:iio:ade7758: Fix check if channels are enabled in prenable

Lars-Peter Clausen <lars@metafoo.de>
    staging:iio:ade7758: Fix NULL pointer deref when enabling buffer

George McCollister <george.mccollister@gmail.com>
    iio: as3935: allocate correct iio_device size

Lars-Peter Clausen <lars@metafoo.de>
    staging:iio:ad5933: Drop "raw" from channel names

Lars-Peter Clausen <lars@metafoo.de>
    staging:iio:ad5933: Fix NULL pointer deref when enabling buffer

Fabio Estevam <fabio.estevam@freescale.com>
    iio: adc: mxs-lradc: Disable the clock on probe failure

Robin van der Gracht <robin@protonic.nl>
    iio: st_sensors: Fix buffer copy

Michal Hocko <mhocko@suse.cz>
    OOM, PM: OOM killed task shouldn't escape PM suspend

Lv Zheng <lv.zheng@intel.com>
    ACPI / EC: Fix regression due to conflicting firmware behavior between Samsung and Acer.

Jiang Liu <jiang.liu@linux.intel.com>
    ACPI, irq, x86: Return IRQ instead of GSI in mp_register_gsi()

Jiang Liu <jiang.liu@linux.intel.com>
    x86: ACPI: Do not translate GSI number if IOAPIC is disabled

Zhang Rui <rui.zhang@intel.com>
    ACPI: invoke acpi_device_wakeup() with correct parameters

Al Viro <viro@zeniv.linux.org.uk>
    fix inode leaks on d_splice_alias() failure exits

Cong Wang <xiyou.wangcong@gmail.com>
    freezer: Do not freeze tasks killed by OOM killer

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: Correct BYT VID values.

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: Fix BYT frequency reporting

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: Don't lose sysfs settings during cpu offline

Matt Fleming <matt.fleming@intel.com>
    rtc: Disable EFI rtc for x86

Bryan O'Donoghue <pure.logic@nexus-software.ie>
    x86: Add cpu_detect_cache_sizes to init_intel() add Quark legacy_cache()

David E. Box <david.e.box@linux.intel.com>
    x86/platform/intel/iosf: Add Braswell PCI ID

Pali Rohár <pali.rohar@gmail.com>
    cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy

Gabriele Mazzotta <gabriele.mzt@gmail.com>
    cpufreq: intel_pstate: Reflect current no_turbo state correctly

Dirk Brandewie <dirk.j.brandewie@intel.com>
    cpufreq: expose scaling_cur_freq sysfs file for set_policy() drivers

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix vm page table block size calculation

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: use gart memory for DMA ring tests

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix speaker allocation setup

Paulo Zanoni <paulo.r.zanoni@intel.com>
    drm/i915: properly reenable gen8 pipe IRQs

U. Artie Eoff <ullysses.a.eoff@intel.com>
    drm/i915: intel_backlight scale() math WA

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau: fix regression on agp boards

Brian Silverman <bsilver16384@gmail.com>
    futex: Fix a race condition between REQUEUE_PI and task death

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: prevent bugon on race between write/fcntl

Darrick J. Wong <darrick.wong@oracle.com>
    ext4: enable journal checksum when metadata checksum feature enabled

Jan Kara <jack@suse.cz>
    ext4: fix overflow when updating superblock backups after resize

Jan Kara <jack@suse.cz>
    ext4: fix oops when loading block bitmap failed

Darrick J. Wong <darrick.wong@oracle.com>
    ext4: check s_chksum_driver when looking for bg csum presence

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: move error report out of atomic context in ext4_init_block_bitmap()

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: Replace open coded mdata csum feature to helper function

Eric Sandeen <sandeen@redhat.com>
    ext4: fix reservation overflow in ext4_da_write_begin

Theodore Ts'o <tytso@mit.edu>
    ext4: don't orphan or truncate the boot loader inode

Theodore Ts'o <tytso@mit.edu>
    ext4: add ext4_iget_normal() which is to be used for dir tree lookups

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: grab missed write_count for EXT4_IOC_SWAP_BOOT

Jan Kara <jack@suse.cz>
    ext4: fix mmap data corruption when blocksize < pagesize

Jan Kara <jack@suse.cz>
    ext4: don't check quota format when there are no quota files

Darrick J. Wong <darrick.wong@oracle.com>
    ext4: check EA value offset when loading

Darrick J. Wong <darrick.wong@oracle.com>
    jbd2: free bh when descriptor block checksum fails

Marc-André Lureau <marcandre.lureau@gmail.com>
    qxl: don't create too large primary surface

David Daney <david.daney@cavium.com>
    MIPS: tlbex: Properly fix HUGE TLB Refill exception handler

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: ftrace: Fix a microMIPS build problem

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: cp1emu: Fix ISA restrictions for cop1x_op instructions

Aaro Koskinen <aaro.koskinen@iki.fi>
    MIPS: loongson2_cpufreq: Fix CPU clock rate setting mismerge

Aaro Koskinen <aaro.koskinen@iki.fi>
    MIPS: ptrace.h: Add a missing include

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix APTPL metadata handling for dynamic MappedLUNs

Quinn Tran <quinn.tran@qlogic.com>
    target: Fix queue full status NULL pointer for SCF_TRANSPORT_TASK_SENSE

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Disable TX completion interrupt coalescing

Joern Engel <joern@logfs.org>
    qla_target: don't delete changed nacls

Vineet Gupta <vgupta@synopsys.com>
    ARC: unbork FPU save/restore

Anton Kolesov <Anton.Kolesov@synopsys.com>
    ARC: Update order of registers in KGDB to match GDB 7.5

Vineet Gupta <vgupta@synopsys.com>
    ARC: [nsimosci] Allow "headless" models to boot

Petr Matousek <pmatouse@redhat.com>
    kvm: vmx: handle invvpid vm exit gracefully

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Handle errors when RIP is set during far jumps

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Emulator fixes for eip canonical checks on near branches

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Fix wrong masking on relative jump/call

Michael S. Tsirkin <mst@redhat.com>
    kvm: x86: don't kill guest on unknown exit reason

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Check non-canonical addresses upon WRMSR

Andy Honig <ahonig@google.com>
    KVM: x86: Improve thread safety in pit

Andy Honig <ahonig@google.com>
    KVM: x86: Prevent host from panicking on shared MSR writes.

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: PREFETCH and HINT_NOP should have SrcMem flag

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Emulator does not decode clflush well

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Decoding guest instructions which cross page boundary may fail

Quentin Casasnovas <quentin.casasnovas@oracle.com>
    kvm: fix excessive pages un-pinning in kvm_iommu_map error path.

Paolo Bonzini <pbonzini@redhat.com>
    KVM: emulate: avoid accessing NULL ctxt->memopp

Dan Carpenter <dan.carpenter@oracle.com>
    media: vmalloc_sg: off by one in error handling

Axel Lin <axel.lin@ingics.com>
    media: tda7432: Fix setting TDA7432_MUTE bit for TDA7432_RF register

Tomas Melin <tomas.melin@iki.fi>
    media: rc-core: fix protocol_change regression in ir_raw_event_register

Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
    media: ds3000: fix LNB supply voltage on Tevii S480 on initialization

Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
    media: imon: fix other RC type protocol support

Frank Schaefer <fschaefer.oss@googlemail.com>
    media: em28xx-v4l: fix video buffer field order reporting in progressive mode

Frank Schaefer <fschaefer.oss@googlemail.com>
    media: em28xx-v4l: give back all active video buffers to the vb2 core properly on streaming stop

Antti Palosaari <crope@iki.fi>
    media: m88ts2022: fix 32bit overflow on filter calc

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: siano: add support for PCTV 77e

Frank Schaefer <fschaefer.oss@googlemail.com>
    media: em28xx: check if a device has audio earlier"

Paul Fertser <fercerpav@gmail.com>
    media: usb: uvc: add a quirk for Dell XPS M1330 webcam

Maciej Matraszek <m.matraszek@samsung.com>
    media: v4l2-common: fix overflow in v4l_bound_align_image()

Ben Skeggs <bskeggs@redhat.com>
    drm/gt214-/kms: fix hda eld regression

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/bios: memset dcb struct to zero before parsing

Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
    drm/tilcdc: Fix the error path in tilcdc_load()

Josh Boyer <jwboyer@fedoraproject.org>
    drm/vmwgfx: Fix drm.h include

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915: Do not leak pages when freeing userptr objects

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Do not store the error pointer for a failed userptr registration

Emil Velikov <emil.l.velikov@gmail.com>
    drm/nouveau/gpio: rename g92 class to g94

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    drm/ast: Fix HW cursor image

Jason Gerecke <killertofu@gmail.com>
    HID: input: Fix TransducerSerialNumber implementation

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544

Andreas Bosch <linux@progandy.de>
    Input: alps - fix v4 button press recognition

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - add noloop quirk for Asus X750LN

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics - gate forcepad support by DMI check

Mikulas Patocka <mpatocka@redhat.com>
    framebuffer: fix border color

Mikulas Patocka <mpatocka@redhat.com>
    framebuffer: fix screen corruption when copying

Prarit Bhargava <prarit@redhat.com>
    modules, lock around setting of MODULE_STATE_UNFORMED

Alexey Khoroshilov <khoroshilov@ispras.ru>
    dm log userspace: fix memory leak in dm_ulog_tfr_init failure path

Christoph Hellwig <hch@lst.de>
    Revert "block: all blk-mq requests are tagged"

Mike Snitzer <snitzer@redhat.com>
    block: fix alignment_offset math that assumes io_min is a power-of-2

Lai Jiangshan <laijs@cn.fujitsu.com>
    drbd: compute the end before rb_insert_augmented()

Mikulas Patocka <mpatocka@redhat.com>
    dm bufio: when done scanning return from __scan immediately

Joe Thornber <ejt@redhat.com>
    dm bufio: update last_accessed when relinking a buffer

Jens Axboe <axboe@fb.com>
    blk-mq: fix potential hang if rolling wakeup depth is too high

Olaf Hering <olaf@aepfle.de>
    drm/cirrus: bind also to qemu-xen-traditional

Roger Pau Monné <roger.pau@citrix.com>
    xen-blkback: fix leak on grant map error path

Vitaly Kuznetsov <vkuznets@redhat.com>
    xen/blkback: unmap all persistent grants when frontend gets disconnected

Michael S. Tsirkin <mst@redhat.com>
    virtio_pci: fix virtio spec compliance on restore

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    power: charger-manager: Fix NULL pointer exception with missing cm-fuel-gauge

Stephen Smalley <sds@tycho.nsa.gov>
    selinux: fix inode security list corruption

Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
    pstore: Fix duplicate {console,ftrace}-efi entries

Alex Williamson <alex.williamson@redhat.com>
    iommu/amd: Split init_iommu_group() from iommu_init_device()

Alex Williamson <alex.williamson@redhat.com>
    iommu: Rework iommu_group_get_for_pci_dev()

Chris Ball <chris@printf.net>
    mfd: rtsx_pcr: Fix MSI enable error handling

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    mfd: ti_am335x_tscadc: Fix TSC resume

Vignesh R <vigneshr@ti.com>
    mfd: ti_am335x_tscadc: Fix TSC operation after ADC continouous mode

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Prevent pivot_root from creating a loop in the mount tree

Richard Genoud <richard.genoud@gmail.com>
    UBI: add missing kmem_cache_free() in process_pool_aeb error path

Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    UBI: Dispatch update notification if the volume is updated

Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    UBI: block: Add support for the UBI_VOLUME_UPDATED notification

Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    UBI: block: Fix block device size setting

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/topology: call set_sched_topology early

Daniel Borkmann <dborkman@redhat.com>
    random: add and use memzero_explicit() for clearing data

Thorsten Knabe <linux@thorsten-knabe.de>
    um: ubd: Fix for processes stuck in D state forever

Kirill Tkhai <ktkhai@parallels.com>
    sched: Use dl_bw_of() under RCU read lock

Ilya Dryomov <idryomov@redhat.com>
    libceph: ceph-msgr workqueue needs a resque worker

Ilya Dryomov <idryomov@redhat.com>
    rbd: rbd workqueues need a resque worker

Al Viro <viro@zeniv.linux.org.uk>
    fix misuses of f_count() in ppp and netlink

Al Viro <viro@ZenIV.linux.org.uk>
    kill wbuf_queued/wbuf_dwork_lock

Al Viro <viro@zeniv.linux.org.uk>
    missing data dependency barrier in prepend_name()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat mode

Christian Vogel <vogelchr@vogel.cx>
    ALSA: bebob: Uninitialized id returned by saffirepro_both_clk_src_get

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add workaround for CMI8888 snoop behavior

Dmitry Kasatkin <d.kasatkin@samsung.com>
    evm: check xattr value length and type in evm_inode_setxattr()

Dmitry Kasatkin <d.kasatkin@samsung.com>
    evm: properly handle INTEGRITY_NOXATTRS EVM status

Peter Zijlstra <peterz@infradead.org>
    perf: Fix unclone_ctx() vs. locking

Dexuan Cui <decui@microsoft.com>
    x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE

Andy Lutomirski <luto@amacapital.net>
    x86_64, entry: Fix out of bounds read on sysenter

Andy Lutomirski <luto@amacapital.net>
    x86_64, entry: Filter RFLAGS.NT on entry from userspace

Oleg Nesterov <oleg@redhat.com>
    x86, fpu: shift drop_init_fpu() from save_xstate_sig() to handle_signal()

Oleg Nesterov <oleg@redhat.com>
    x86, fpu: __restore_xstate_sig()->math_state_restore() needs preempt_disable()

Ben Hutchings <ben@decadent.org.uk>
    x86: Reject x32 executables if x32 ABI not supported

Jan Kara <jack@suse.cz>
    vfs: fix data corruption when blocksize < pagesize for mmaped data

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: fix free log space calculation

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: fix a race condition

Eric Rannaud <e@nanocritical.com>
    fs: allow open(dir, O_TMPFILE|..., 0) with mode 0

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fs: Fix theoretical division by 0 in super_cache_scan().

Mikulas Patocka <mpatocka@redhat.com>
    fs: make cont_expand_zero interruptible

Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    mmc: sdhci-s3c: fix runtime PM handling on sdhci_add_host() failure

Roger Tseng <rogerable@realtek.com>
    mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response

Stephen Warren <swarren@nvidia.com>
    mmc: don't request CD IRQ until mmc_start_host()

Roger Tseng <rogerable@realtek.com>
    mmc: rtsx_usb_sdmmc: fix incorrect last byte in R2 response

Peter Griffin <peter.griffin@linaro.org>
    mmc: sdhci-pxav3: set_uhs_signaling is initialized twice differently

Fu Zhonghui <zhonghui.fu@linux.intel.com>
    mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: adau1761: Fix input PGA volume

Liam Girdwood <liam.r.girdwood@linux.intel.com>
    ASoC: Intel: HSW/BDW only support S16 and S24 formats.

Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
    ASoC: tlv320aic3x: fix PLL D configuration

Daniel Mack <daniel@zonque.org>
    ASoC: soc-pcm: fix sig_bits determination in soc_pcm_apply_msb()

Daniel Mack <daniel@zonque.org>
    ASoC: soc-dapm: fix use after free

Daniel Mack <daniel@zonque.org>
    ASoC: core: fix use after free in snd_soc_remove_platform()

Ondrej Zary <linux@rainbow-software.org>
    libata-sff: Fix controllers with no ctl port

Scott Carter <ccscott@funsoft.com>
    pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE Controller

Guenter Roeck <linux@roeck-us.net>
    Revert "percpu: free percpu allocation info for uniprocessor system"

Trond Myklebust <trond.myklebust@primarydata.com>
    SUNRPC: Add missing support for RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Don't wake tasks during connection abort

Benjamin Coddington <bcodding@redhat.com>
    lockd: Try to reconnect if statd has moved

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    stmmac: pci: set default of the filter bins

Ben Hutchings <ben@decadent.org.uk>
    drivers/net: macvtap and tun depend on INET

Ben Hutchings <ben@decadent.org.uk>
    drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets

Ben Hutchings <ben@decadent.org.uk>
    drivers/net: Disable UFO through virtio

Tom Herbert <therbert@google.com>
    gre: Use inner mac length when computing tunnel length

Or Gerlitz <ogerlitz@mellanox.com>
    mlx4: Avoid leaking steering rules on flow creation error flow

Or Gerlitz <ogerlitz@mellanox.com>
    net/mlx4_en: Don't attempt to TX offload the outer UDP checksum for VXLAN

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    ipv4: Do not cache routing failures due to disabled forwarding.

Anish Bhatt <anish@chelsio.com>
    cxgb4 : Fix missing initialization of win0_lock

Eric Dumazet <edumazet@google.com>
    macvlan: fix a race on port dismantle and possible skb leaks

Eric Dumazet <edumazet@google.com>
    tcp: md5: do not use alloc_percpu()

Haiyang Zhang <haiyangz@microsoft.com>
    hyperv: Fix the total_data_buflen in send path

Sathya Perla <sathya.perla@emulex.com>
    net: fix saving TX flow hash in sock for outgoing connections

Karl Beldan <karl.beldan@rivierawaves.com>
    net: tso: fix unaligned access to crafted TCP header in helper API

Thomas Graf <tgraf@suug.ch>
    netlink: Re-add locking to netlink_lookup() and seq walker

Ian Morgan <imorgan@primordial.ca>
    ax88179_178a: fix bonding failure

Jon Paul Maloy <jon.maloy@ericsson.com>
    tipc: fix bug in bundled buffer reception

Li RongQing <roy.qing.li@gmail.com>
    ipv4: fix a potential use after free in ip_tunnel_core.c

Vasily Averin <vvs@parallels.com>
    ipv4: dst_entry leak in ip_send_unicast_reply()

Li RongQing <roy.qing.li@gmail.com>
    vxlan: fix a free after use

Li RongQing <roy.qing.li@gmail.com>
    vxlan: using pskb_may_pull as early as possible

Li RongQing <roy.qing.li@gmail.com>
    vxlan: fix a use after free in vxlan_encap_bypass

Jiri Pirko <jiri@resnulli.us>
    ipv4: fix nexthop attlen check in fib_nh_match

Alexei Starovoitov <ast@plumgrid.com>
    x86: bpf_jit: fix two bugs in eBPF JIT compiler

Paolo Bonzini <pbonzini@redhat.com>
    KVM: emulator: fix execution close to the segment limit

Rabin Vincent <rabin@rab.in>
    tracing/syscalls: Ignore numbers outside NR_syscalls' range


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/boot/dts/nsimosci.dts                     |   2 +-
 arch/arc/include/asm/arcregs.h                     |   8 -
 arch/arc/include/asm/kgdb.h                        |  32 ++-
 arch/arc/include/asm/processor.h                   |   9 +
 arch/arm/Kconfig.debug                             |   2 +-
 arch/arm/boot/dts/zynq-parallella.dts              |   4 +
 arch/arm/mach-pxa/include/mach/addr-map.h          |   5 +
 arch/mips/include/asm/ftrace.h                     |   4 +-
 arch/mips/include/uapi/asm/ptrace.h                |   2 +
 arch/mips/loongson/lemote-2f/clock.c               |   5 +-
 arch/mips/math-emu/cp1emu.c                        |   4 +-
 arch/mips/mm/tlbex.c                               |   6 +-
 arch/powerpc/kernel/entry_64.S                     |   6 +
 arch/powerpc/platforms/powernv/opal-lpc.c          |  59 +++++
 arch/powerpc/platforms/pseries/dlpar.c             |   4 +-
 arch/s390/kernel/topology.c                        |  18 +-
 arch/sh/kernel/cpu/sh3/setup-sh770x.c              |   6 +-
 arch/um/drivers/ubd_kern.c                         |   5 +-
 arch/x86/ia32/ia32entry.S                          |  18 +-
 arch/x86/include/asm/elf.h                         |   5 +-
 arch/x86/include/asm/kvm_host.h                    |  16 +-
 arch/x86/include/uapi/asm/vmx.h                    |   2 +
 arch/x86/kernel/acpi/boot.c                        |  16 +-
 arch/x86/kernel/apb_timer.c                        |   2 -
 arch/x86/kernel/apic/apic.c                        |   4 +-
 arch/x86/kernel/cpu/common.c                       |   2 +-
 arch/x86/kernel/cpu/intel.c                        |  17 +-
 arch/x86/kernel/iosf_mbi.c                         |   2 +
 arch/x86/kernel/signal.c                           |   5 +
 arch/x86/kernel/tsc.c                              |   5 +-
 arch/x86/kernel/xsave.c                            |   7 +-
 arch/x86/kvm/emulate.c                             | 293 +++++++++++++++------
 arch/x86/kvm/i8254.c                               |   2 +
 arch/x86/kvm/svm.c                                 |   8 +-
 arch/x86/kvm/vmx.c                                 |  24 +-
 arch/x86/kvm/x86.c                                 |  38 ++-
 arch/x86/mm/pageattr.c                             |   2 +-
 arch/x86/net/bpf_jit_comp.c                        |  25 +-
 arch/x86/platform/intel-mid/sfi.c                  |   2 +
 block/blk-mq-tag.c                                 |   4 +-
 block/blk-settings.c                               |   4 +-
 block/scsi_ioctl.c                                 |   3 +-
 crypto/algif_skcipher.c                            |   2 +-
 drivers/acpi/device_pm.c                           |   2 +-
 drivers/acpi/ec.c                                  |  25 +-
 drivers/ata/libata-sff.c                           |  20 +-
 drivers/ata/pata_serverworks.c                     |  13 +-
 drivers/base/core.c                                |   4 +-
 drivers/base/power/main.c                          |   2 +
 drivers/block/drbd/drbd_interval.c                 |   4 +
 drivers/block/rbd.c                                |   5 +-
 drivers/block/xen-blkback/blkback.c                |   1 +
 drivers/block/xen-blkback/xenbus.c                 |   6 +-
 drivers/char/random.c                              |   8 +-
 drivers/cpufreq/cpufreq.c                          |  23 +-
 drivers/cpufreq/intel_pstate.c                     | 110 ++++++--
 drivers/edac/cpc925_edac.c                         |   2 +-
 drivers/edac/e7xxx_edac.c                          |   2 +-
 drivers/edac/i3200_edac.c                          |   4 +-
 drivers/edac/i82860_edac.c                         |   2 +-
 drivers/gpu/drm/ast/ast_mode.c                     |   4 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c                |   2 +
 drivers/gpu/drm/i915/i915_gem_userptr.c            |  31 ++-
 drivers/gpu/drm/i915/i915_irq.c                    |   5 +-
 drivers/gpu/drm/i915/intel_display.c               |   5 +-
 drivers/gpu/drm/i915/intel_dp.c                    |   7 +
 drivers/gpu/drm/i915/intel_panel.c                 |   8 +-
 drivers/gpu/drm/nouveau/Makefile                   |   2 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv50.c  |  22 +-
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |  14 +-
 drivers/gpu/drm/nouveau/core/include/subdev/gpio.h |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c     |   1 +
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv92.c    |  74 ------
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv94.c    |  74 ++++++
 drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c    |   4 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/priv.h    |   4 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |  12 +-
 drivers/gpu/drm/nouveau/nv50_display.c             |  18 +-
 drivers/gpu/drm/qxl/qxl_display.c                  |  16 +-
 drivers/gpu/drm/radeon/cik_sdma.c                  |  21 +-
 drivers/gpu/drm/radeon/dce3_1_afmt.c               |   4 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                 |   6 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |   6 +-
 drivers/gpu/drm/radeon/kv_dpm.c                    |  19 +-
 drivers/gpu/drm/radeon/r600_dma.c                  |  21 +-
 drivers/gpu/drm/radeon/radeon.h                    |   2 +
 drivers/gpu/drm/radeon/radeon_cs.c                 |   2 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   2 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |   4 +-
 drivers/gpu/drm/radeon/radeon_vm.c                 |   4 +-
 drivers/gpu/drm/radeon/si_dpm.c                    |   2 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |  60 ++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  16 +-
 drivers/hid/hid-debug.c                            |   6 +
 drivers/hid/hid-ids.h                              |   7 +
 drivers/hid/hid-input.c                            |  12 +-
 drivers/hid/usbhid/hid-core.c                      |  26 +-
 drivers/hid/usbhid/hid-quirks.c                    |   5 +
 drivers/i2c/busses/i2c-at91.c                      |   2 +-
 drivers/iio/common/st_sensors/st_sensors_buffer.c  |   2 +-
 drivers/iio/proximity/as3935.c                     |   2 +-
 drivers/infiniband/hw/mlx4/main.c                  |  10 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   4 +-
 drivers/input/mouse/alps.c                         |   4 +-
 drivers/input/mouse/synaptics.c                    |  22 +-
 drivers/input/mouse/synaptics.h                    |   8 +-
 drivers/input/serio/i8042-x86ia64io.h              |  22 ++
 drivers/iommu/amd_iommu.c                          |  27 +-
 drivers/iommu/iommu.c                              | 163 +++++++-----
 drivers/irqchip/irq-armada-370-xp.c                |  23 +-
 drivers/md/dm-bufio.c                              |   5 +-
 drivers/md/dm-log-userspace-transfer.c             |   2 +-
 drivers/media/common/siano/sms-cards.c             |   6 +
 drivers/media/common/siano/sms-cards.h             |   1 +
 drivers/media/dvb-frontends/ds3000.c               |   7 +
 drivers/media/i2c/tda7432.c                        |   2 +-
 drivers/media/platform/Kconfig                     |   6 +-
 drivers/media/platform/exynos4-is/Kconfig          |   2 +-
 drivers/media/platform/s5p-tv/Kconfig              |   2 +-
 drivers/media/rc/imon.c                            |   3 +-
 drivers/media/rc/rc-ir-raw.c                       |   1 -
 drivers/media/rc/rc-main.c                         |   2 +
 drivers/media/tuners/m88ts2022.c                   |   2 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |  11 -
 drivers/media/usb/em28xx/em28xx-core.c             |  12 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  15 +-
 drivers/media/usb/siano/smsusb.c                   |   2 +
 drivers/media/usb/uvc/uvc_driver.c                 |   9 +
 drivers/media/v4l2-core/v4l2-common.c              |   9 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c          |   6 +-
 drivers/mfd/rtsx_pcr.c                             |   2 +-
 drivers/mfd/ti_am335x_tscadc.c                     |   5 +-
 drivers/mmc/core/sdio.c                            |  12 +-
 drivers/mmc/core/sdio_irq.c                        |   4 +-
 drivers/mmc/core/slot-gpio.c                       |   2 -
 drivers/mmc/host/mmc_spi.c                         |   1 +
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |   7 +
 drivers/mmc/host/rtsx_usb_sdmmc.c                  |   7 +
 drivers/mmc/host/sdhci-pxav3.c                     |   3 +-
 drivers/mmc/host/sdhci-s3c.c                       |   4 +-
 drivers/mmc/host/sdhci-sirf.c                      |   1 +
 drivers/mmc/host/tmio_mmc_pio.c                    |   1 +
 drivers/mtd/chips/cfi_cmdset_0001.c                |   2 +
 drivers/mtd/devices/m25p80.c                       |  50 ++++
 drivers/mtd/ubi/block.c                            |  25 +-
 drivers/mtd/ubi/cdev.c                             |   4 +-
 drivers/mtd/ubi/fastmap.c                          |   1 +
 drivers/net/Kconfig                                |   2 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   1 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   7 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |   4 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |   7 +
 drivers/net/hyperv/netvsc_drv.c                    |   1 +
 drivers/net/macvlan.c                              |  10 +-
 drivers/net/macvtap.c                              |  16 +-
 drivers/net/ppp/ppp_generic.c                      |   2 +-
 drivers/net/tun.c                                  |  25 +-
 drivers/net/usb/ax88179_178a.c                     |   7 +-
 drivers/net/virtio_net.c                           |  24 +-
 drivers/net/vxlan.c                                |  15 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  24 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h           |   2 +
 drivers/net/wireless/iwlwifi/mvm/coex.c            |   4 +-
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c     |   4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h    |  35 ++-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h          |   1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c              |   9 +
 drivers/net/wireless/iwlwifi/mvm/ops.c             |   1 +
 drivers/net/wireless/iwlwifi/mvm/tx.c              |   8 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  16 +-
 drivers/net/wireless/rt2x00/rt2800.h               |   4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |   6 +
 drivers/net/wireless/rt2x00/rt2800usb.c            |   1 +
 drivers/of/base.c                                  |  88 ++-----
 drivers/of/selftest.c                              |  66 ++++-
 drivers/of/testcase-data/tests-phandle.dtsi        |   2 +
 drivers/pci/pci-sysfs.c                            |   8 +-
 drivers/phy/phy-omap-usb2.c                        |   6 +-
 drivers/pinctrl/pinctrl-baytrail.c                 |   2 +-
 drivers/platform/x86/acer-wmi.c                    |  11 +
 drivers/platform/x86/samsung-laptop.c              |  10 +
 drivers/power/charger-manager.c                    |   5 +
 drivers/regulator/max77693.c                       |   2 +-
 drivers/rtc/Kconfig                                |   2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |  11 +-
 drivers/scsi/scsi_lib.c                            |   5 +
 drivers/spi/spi-fsl-dspi.c                         |   4 +-
 drivers/spi/spi-pl022.c                            |   2 +-
 drivers/spi/spi-pxa2xx.c                           |   7 +-
 drivers/staging/comedi/comedi_fops.c               |  18 +-
 drivers/staging/iio/adc/mxs-lradc.c                |  12 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |  15 +-
 drivers/staging/iio/meter/ade7758.h                |   1 -
 drivers/staging/iio/meter/ade7758_core.c           |  57 +---
 drivers/staging/iio/meter/ade7758_ring.c           |   5 +-
 drivers/target/target_core_device.c                |   3 +-
 drivers/target/target_core_pr.c                    |   6 +-
 drivers/target/target_core_pr.h                    |   2 +-
 drivers/target/target_core_tpg.c                   |   8 +
 drivers/target/target_core_transport.c             |   3 +-
 drivers/tty/serial/msm_serial.c                    |  22 +-
 drivers/tty/serial/serial_core.c                   |   2 +-
 drivers/tty/tty_io.c                               |   7 +-
 drivers/tty/vt/consolemap.c                        |   7 +
 drivers/usb/chipidea/core.c                        |   1 -
 drivers/usb/class/cdc-acm.c                        |  20 +-
 drivers/usb/class/cdc-acm.h                        |   2 +
 drivers/usb/core/hcd.c                             |   2 +
 drivers/usb/core/hub.c                             |   3 +
 drivers/usb/core/quirks.c                          |  10 +
 drivers/usb/dwc3/dwc3-omap.c                       |  15 +-
 drivers/usb/dwc3/ep0.c                             |   4 +-
 drivers/usb/dwc3/gadget.c                          |  19 +-
 drivers/usb/dwc3/gadget.h                          |   2 +-
 drivers/usb/gadget/function/f_acm.c                |   7 +-
 drivers/usb/gadget/function/f_fs.c                 |  42 ++-
 drivers/usb/gadget/udc/udc-core.c                  |   5 +
 drivers/usb/host/Kconfig                           |   4 +-
 drivers/usb/host/xhci-pci.c                        |  18 +-
 drivers/usb/musb/musb_cppi41.c                     |   3 +-
 drivers/usb/musb/musb_dsps.c                       |   4 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  12 +-
 drivers/usb/serial/kobil_sct.c                     |   5 +-
 drivers/usb/serial/opticon.c                       |   2 +-
 drivers/usb/serial/option.c                        |  10 +
 drivers/usb/storage/transport.c                    |  26 ++
 drivers/usb/storage/unusual_uas.h                  |  28 ++
 drivers/video/console/bitblit.c                    |   3 +-
 drivers/video/console/fbcon_ccw.c                  |   3 +-
 drivers/video/console/fbcon_cw.c                   |   3 +-
 drivers/video/console/fbcon_ud.c                   |   3 +-
 drivers/video/fbdev/core/cfbcopyarea.c             |  13 +-
 drivers/virtio/virtio_pci.c                        |  33 ++-
 fs/btrfs/file-item.c                               |   2 +-
 fs/buffer.c                                        |   8 +
 fs/dcache.c                                        |   7 +
 fs/ext3/super.c                                    |   7 -
 fs/ext4/balloc.c                                   |  12 +-
 fs/ext4/bitmap.c                                   |  12 +-
 fs/ext4/ext4.h                                     |  13 +-
 fs/ext4/extents.c                                  |   6 +-
 fs/ext4/file.c                                     |   2 +-
 fs/ext4/ialloc.c                                   |   7 +-
 fs/ext4/inline.c                                   |   3 +-
 fs/ext4/inode.c                                    |  46 +++-
 fs/ext4/ioctl.c                                    |  13 +-
 fs/ext4/mmp.c                                      |   6 +-
 fs/ext4/namei.c                                    |  45 ++--
 fs/ext4/resize.c                                   |   5 +-
 fs/ext4/super.c                                    |  32 +--
 fs/ext4/xattr.c                                    |  38 ++-
 fs/jbd2/recovery.c                                 |   1 +
 fs/jffs2/jffs2_fs_sb.h                             |   2 -
 fs/jffs2/wbuf.c                                    |  17 +-
 fs/lockd/mon.c                                     |   6 +
 fs/namei.c                                         |   3 +-
 fs/namespace.c                                     |   3 +
 fs/nfsd/nfs4proc.c                                 |   7 +-
 fs/ocfs2/cluster/tcp.c                             |   2 +-
 fs/pstore/inode.c                                  |   4 +-
 fs/quota/dquot.c                                   |   2 +-
 fs/super.c                                         |   2 +
 fs/ubifs/commit.c                                  |   8 +-
 fs/ubifs/log.c                                     |  19 +-
 fs/xfs/xfs_itable.c                                | 250 +++++++++---------
 fs/xfs/xfs_itable.h                                |  16 --
 include/drm/drm_pciids.h                           |   1 -
 include/linux/blkdev.h                             |   8 +-
 include/linux/hid.h                                |   1 +
 include/linux/memcontrol.h                         |  58 ++--
 include/linux/mm.h                                 |   2 +-
 include/linux/of.h                                 |  84 +++++-
 include/linux/oom.h                                |   3 +
 include/linux/string.h                             |   5 +-
 include/linux/sunrpc/xprt.h                        |   1 +
 include/linux/usb/quirks.h                         |   3 +
 include/net/ipv6.h                                 |   2 +
 include/scsi/scsi_tcq.h                            |   8 +-
 include/uapi/drm/vmwgfx_drm.h                      |   2 +-
 include/uapi/linux/input.h                         |   7 +
 kernel/events/core.c                               |  54 ++--
 kernel/freezer.c                                   |   3 +
 kernel/futex.c                                     |  22 +-
 kernel/module.c                                    |   2 +
 kernel/power/hibernate.c                           |   8 +-
 kernel/power/process.c                             |  40 ++-
 kernel/sched/core.c                                |  19 +-
 kernel/time/posix-timers.c                         |   1 +
 kernel/trace/trace_syscalls.c                      |   8 +-
 lib/bitmap.c                                       |   8 +-
 lib/scatterlist.c                                  |   6 +-
 lib/string.c                                       |  16 ++
 mm/balloon_compaction.c                            |   2 +
 mm/cma.c                                           |   1 +
 mm/huge_memory.c                                   |   4 +-
 mm/memcontrol.c                                    | 105 ++++----
 mm/memory.c                                        |   1 +
 mm/oom_kill.c                                      |  17 ++
 mm/page-writeback.c                                |  43 ++-
 mm/page_alloc.c                                    |   8 +
 mm/page_cgroup.c                                   |   1 +
 mm/percpu.c                                        |   2 -
 mm/rmap.c                                          |  20 +-
 mm/truncate.c                                      |  56 ++++
 net/ceph/messenger.c                               |   6 +-
 net/core/tso.c                                     |   3 +-
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/gre_offload.c                             |   2 +-
 net/ipv4/ip_output.c                               |  12 +-
 net/ipv4/ip_tunnel_core.c                          |   3 +-
 net/ipv4/route.c                                   |   1 +
 net/ipv4/tcp.c                                     |  59 ++---
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv6/output_core.c                             |  34 +++
 net/ipv6/tcp_ipv6.c                                |   4 +-
 net/mac80211/rate.c                                |   2 +-
 net/netlink/af_netlink.c                           |  39 ++-
 net/sunrpc/clnt.c                                  |   3 +
 net/sunrpc/xprtsock.c                              |   4 +
 net/tipc/link.c                                    |   7 +-
 security/integrity/evm/evm_main.c                  |  16 +-
 security/integrity/ima/ima_appraise.c              |   2 +
 security/integrity/integrity.h                     |   1 +
 security/selinux/hooks.c                           |   2 +-
 sound/core/pcm_compat.c                            |   2 +
 sound/firewire/bebob/bebob_focusrite.c             |  62 ++++-
 sound/firewire/bebob/bebob_stream.c                |  18 +-
 sound/pci/hda/hda_intel.c                          |   4 +-
 sound/pci/hda/patch_realtek.c                      |   3 -
 sound/soc/codecs/adau1761.c                        |   4 +
 sound/soc/codecs/tlv320aic3x.c                     |  13 +
 sound/soc/intel/sst-haswell-pcm.c                  |   4 +-
 sound/soc/soc-core.c                               |   4 +-
 sound/soc/soc-dapm.c                               |  25 +-
 sound/soc/soc-pcm.c                                |   2 +-
 sound/usb/card.c                                   |   9 +-
 virt/kvm/iommu.c                                   |   8 +-
 341 files changed, 3006 insertions(+), 1524 deletions(-)


