Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965848AbaKLBuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:50:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964953AbaKLBuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:50:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 000/123] 3.10.60-stable review
Date: Wed, 12 Nov 2014 10:16:06 +0900
Message-Id: <20141112011718.985171261@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.60 release.
There are 123 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Nov 14 01:17:00 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.60-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.60-rc1

Ilya Dryomov <idryomov@redhat.com>
    libceph: ceph-msgr workqueue needs a resque worker

Chris Mason <clm@fb.com>
    Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error cleanup

Grant Likely <grant.likely@linaro.org>
    of: Fix overflow bug in string property parsing functions

Yijing Wang <wangyijing@huawei.com>
    sysfs: driver core: Fix glue dir race condition by gdp_mutex

Wolfram Sang <wsa@the-dreams.de>
    i2c: at91: don't account as iowait

Hans de Goede <hdegoede@redhat.com>
    acer-wmi: Add acpi_backlight=video quirk for the Acer KAV80

Jan Kara <jack@suse.cz>
    rbd: Fix error recovery in rbd_obj_read_sync()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: remove invalid pci id

Felipe Balbi <balbi@ti.com>
    usb: gadget: udc: core: fix kernel oops with soft-connect

Felipe Balbi <balbi@ti.com>
    usb: gadget: function: acm: make f_acm pass USB20CV Chapter9

Felipe Balbi <balbi@ti.com>
    usb: dwc3: gadget: fix set_halt() bug with pending transfers

Ondrej Kozina <okozina@redhat.com>
    crypto: algif - avoid excessive use of socket buffer in skcipher

Jan Kara <jack@suse.cz>
    mm: Remove false WARN_ON from pagecache_isize_extended()

Andy Lutomirski <luto@amacapital.net>
    x86, apic: Handle a bad TSC more gracefully

Mathias Krause <minipli@googlemail.com>
    posix-timers: Fix stack info leak in timer_create()

Karl Beldan <karl.beldan@rivierawaves.com>
    mac80211: fix typo in starting baserate for rts_cts_rate_idx

Imre Deak <imre.deak@intel.com>
    PM / Sleep: fix recovery during resuming from hibernation

Peter Hurley <peter@hurleysoftware.com>
    tty: Fix high cpu load if tty is unreleaseable

Jan Kara <jack@suse.cz>
    quota: Properly return errors from dquot_writeback_dquots()

Jan Kara <jack@suse.cz>
    ext3: Don't check quota format when there are no quota files

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix crash on unknown operation number

Jason Baron <jbaron@akamai.com>
    cpc925_edac: Report UE events properly

Jason Baron <jbaron@akamai.com>
    e7xxx_edac: Report CE events properly

Jason Baron <jbaron@akamai.com>
    i3200_edac: Report CE events properly

Jason Baron <jbaron@akamai.com>
    i82860_edac: Report CE events properly

Jan Kara <jack@suse.cz>
    scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND

Jan Kara <jack@suse.cz>
    lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()

Wang Nan <wangnan0@huawei.com>
    cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.

Hans de Goede <hdegoede@redhat.com>
    usb: Do not allow usb_alloc_streams on unconfigured devices

Johan Hovold <johan@kernel.org>
    USB: opticon: fix non-atomic allocation in write path

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: handle a skipped data phase

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
    spi: pxa2xx: toggle clocks on suspend if not disabled by runtime PM

Ray Jui <rjui@broadcom.com>
    spi: pl022: Fix incorrect dma_unmap_sg

Jack Pham <jackp@codeaurora.org>
    usb: dwc3: gadget: Properly initialize LINK TRB

Cyril Brulebois <kibi@debian.org>
    wireless: rt2x00: add new rt2800usb device

Dan Williams <dcbw@redhat.com>
    USB: option: add Haier CE81B CDMA modem

Daniele Palmas <dnlplm@gmail.com>
    usb: option: add support for Telit LE910

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

Lars-Peter Clausen <lars@metafoo.de>
    staging:iio:ade7758: Remove "raw" from channel name

Lars-Peter Clausen <lars@metafoo.de>
    staging:iio:ade7758: Fix check if channels are enabled in prenable

Lars-Peter Clausen <lars@metafoo.de>
    staging:iio:ade7758: Fix NULL pointer deref when enabling buffer

Lars-Peter Clausen <lars@metafoo.de>
    staging:iio:ad5933: Drop "raw" from channel names

Lars-Peter Clausen <lars@metafoo.de>
    staging:iio:ad5933: Fix NULL pointer deref when enabling buffer

Michal Hocko <mhocko@suse.cz>
    OOM, PM: OOM killed task shouldn't escape PM suspend

Cong Wang <xiyou.wangcong@gmail.com>
    freezer: Do not freeze tasks killed by OOM killer

Jan Kara <jack@suse.cz>
    ext4: fix oops when loading block bitmap failed

Pali Rohár <pali.rohar@gmail.com>
    cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy

Jan Kara <jack@suse.cz>
    ext4: fix overflow when updating superblock backups after resize

Darrick J. Wong <darrick.wong@oracle.com>
    ext4: check s_chksum_driver when looking for bg csum presence

Eric Sandeen <sandeen@redhat.com>
    ext4: fix reservation overflow in ext4_da_write_begin

Theodore Ts'o <tytso@mit.edu>
    ext4: add ext4_iget_normal() which is to be used for dir tree lookups

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: grab missed write_count for EXT4_IOC_SWAP_BOOT

Jan Kara <jack@suse.cz>
    ext4: don't check quota format when there are no quota files

Darrick J. Wong <darrick.wong@oracle.com>
    ext4: check EA value offset when loading

Darrick J. Wong <darrick.wong@oracle.com>
    jbd2: free bh when descriptor block checksum fails

David Daney <david.daney@cavium.com>
    MIPS: tlbex: Properly fix HUGE TLB Refill exception handler

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix APTPL metadata handling for dynamic MappedLUNs

Quinn Tran <quinn.tran@qlogic.com>
    target: Fix queue full status NULL pointer for SCF_TRANSPORT_TASK_SENSE

Joern Engel <joern@logfs.org>
    qla_target: don't delete changed nacls

Anton Kolesov <Anton.Kolesov@synopsys.com>
    ARC: Update order of registers in KGDB to match GDB 7.5

Vineet Gupta <vgupta@synopsys.com>
    ARC: [nsimosci] Allow "headless" models to boot

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

Quentin Casasnovas <quentin.casasnovas@oracle.com>
    kvm: fix excessive pages un-pinning in kvm_iommu_map error path.

Axel Lin <axel.lin@ingics.com>
    media: tda7432: Fix setting TDA7432_MUTE bit for TDA7432_RF register

Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
    media: ds3000: fix LNB supply voltage on Tevii S480 on initialization

Frank Schaefer <fschaefer.oss@googlemail.com>
    media: em28xx-v4l: give back all active video buffers to the vb2 core properly on streaming stop

Maciej Matraszek <m.matraszek@samsung.com>
    media: v4l2-common: fix overflow in v4l_bound_align_image()

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/bios: memset dcb struct to zero before parsing

Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
    drm/tilcdc: Fix the error path in tilcdc_load()

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    drm/ast: Fix HW cursor image

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - add noloop quirk for Asus X750LN

Mikulas Patocka <mpatocka@redhat.com>
    framebuffer: fix border color

Prarit Bhargava <prarit@redhat.com>
    modules, lock around setting of MODULE_STATE_UNFORMED

Alexey Khoroshilov <khoroshilov@ispras.ru>
    dm log userspace: fix memory leak in dm_ulog_tfr_init failure path

Mike Snitzer <snitzer@redhat.com>
    block: fix alignment_offset math that assumes io_min is a power-of-2

Lai Jiangshan <laijs@cn.fujitsu.com>
    drbd: compute the end before rb_insert_augmented()

Joe Thornber <ejt@redhat.com>
    dm bufio: update last_accessed when relinking a buffer

Michael S. Tsirkin <mst@redhat.com>
    virtio_pci: fix virtio spec compliance on restore

Stephen Smalley <sds@tycho.nsa.gov>
    selinux: fix inode security list corruption

Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
    pstore: Fix duplicate {console,ftrace}-efi entries

Chris Ball <chris@printf.net>
    mfd: rtsx_pcr: Fix MSI enable error handling

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Prevent pivot_root from creating a loop in the mount tree

Richard Genoud <richard.genoud@gmail.com>
    UBI: add missing kmem_cache_free() in process_pool_aeb error path

Daniel Borkmann <dborkman@redhat.com>
    random: add and use memzero_explicit() for clearing data

Cesar Eduardo Barros <cesarb@cesarb.eti.br>
    crypto: more robust crypto_memneq

Al Viro <viro@zeniv.linux.org.uk>
    fix misuses of f_count() in ppp and netlink

Al Viro <viro@ZenIV.linux.org.uk>
    kill wbuf_queued/wbuf_dwork_lock

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat mode

Dmitry Kasatkin <d.kasatkin@samsung.com>
    evm: check xattr value length and type in evm_inode_setxattr()

Dexuan Cui <decui@microsoft.com>
    x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE

Andy Lutomirski <luto@amacapital.net>
    x86_64, entry: Fix out of bounds read on sysenter

Andy Lutomirski <luto@amacapital.net>
    x86_64, entry: Filter RFLAGS.NT on entry from userspace

H. Peter Anvin <hpa@linux.intel.com>
    x86, flags: Rename X86_EFLAGS_BIT1 to X86_EFLAGS_FIXED

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

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: remove mst_mutex

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fs: Fix theoretical division by 0 in super_cache_scan().

Mikulas Patocka <mpatocka@redhat.com>
    fs: make cont_expand_zero interruptible

Roger Tseng <rogerable@realtek.com>
    mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response

Ondrej Zary <linux@rainbow-software.org>
    libata-sff: Fix controllers with no ctl port

Scott Carter <ccscott@funsoft.com>
    pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE Controller

Guenter Roeck <linux@roeck-us.net>
    Revert "percpu: free percpu allocation info for uniprocessor system"

Benjamin Coddington <bcodding@redhat.com>
    lockd: Try to reconnect if statd has moved

Ben Hutchings <ben@decadent.org.uk>
    drivers/net: macvtap and tun depend on INET

Vasily Averin <vvs@parallels.com>
    ipv4: dst_entry leak in ip_send_unicast_reply()

Ian Morgan <imorgan@primordial.ca>
    ax88179_178a: fix bonding failure

Jiri Pirko <jiri@resnulli.us>
    ipv4: fix nexthop attlen check in fib_nh_match

Rabin Vincent <rabin@rab.in>
    tracing/syscalls: Ignore numbers outside NR_syscalls' range


-------------

Diffstat:

 Makefile                                        |  4 +-
 arch/arc/boot/dts/nsimosci.dts                  |  2 +-
 arch/arc/include/asm/kgdb.h                     | 32 ++++----
 arch/mips/mm/tlbex.c                            |  6 +-
 arch/x86/ia32/ia32entry.S                       | 18 ++++-
 arch/x86/include/asm/elf.h                      |  5 +-
 arch/x86/include/asm/kvm_host.h                 | 16 +++-
 arch/x86/include/uapi/asm/processor-flags.h     |  2 +-
 arch/x86/kernel/apic/apic.c                     |  4 +-
 arch/x86/kernel/cpu/common.c                    |  2 +-
 arch/x86/kernel/entry_64.S                      |  2 +-
 arch/x86/kernel/process_32.c                    |  2 +-
 arch/x86/kernel/process_64.c                    |  2 +-
 arch/x86/kernel/signal.c                        |  5 ++
 arch/x86/kernel/tsc.c                           |  5 +-
 arch/x86/kernel/xsave.c                         |  7 +-
 arch/x86/kvm/emulate.c                          | 99 ++++++++++++++++++-------
 arch/x86/kvm/i8254.c                            |  2 +
 arch/x86/kvm/svm.c                              |  8 +-
 arch/x86/kvm/vmx.c                              | 17 +++--
 arch/x86/kvm/x86.c                              | 38 +++++++++-
 arch/x86/mm/pageattr.c                          |  2 +-
 block/blk-settings.c                            |  4 +-
 block/scsi_ioctl.c                              |  3 +-
 crypto/algif_skcipher.c                         |  2 +-
 drivers/ata/libata-sff.c                        | 20 +++--
 drivers/ata/pata_serverworks.c                  | 13 +++-
 drivers/base/core.c                             |  4 +-
 drivers/block/drbd/drbd_interval.c              |  4 +
 drivers/block/rbd.c                             |  2 +-
 drivers/char/random.c                           | 10 +--
 drivers/cpufreq/intel_pstate.c                  |  1 +
 drivers/edac/cpc925_edac.c                      |  2 +-
 drivers/edac/e7xxx_edac.c                       |  2 +-
 drivers/edac/i3200_edac.c                       |  4 +-
 drivers/edac/i82860_edac.c                      |  2 +-
 drivers/gpu/drm/ast/ast_mode.c                  |  4 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c  |  1 +
 drivers/gpu/drm/tilcdc/tilcdc_drv.c             | 60 ++++++++++++---
 drivers/i2c/busses/i2c-at91.c                   |  2 +-
 drivers/input/serio/i8042-x86ia64io.h           | 22 ++++++
 drivers/lguest/x86/core.c                       |  2 +-
 drivers/md/dm-bufio.c                           |  1 +
 drivers/md/dm-log-userspace-transfer.c          |  2 +-
 drivers/media/dvb-frontends/ds3000.c            |  7 ++
 drivers/media/i2c/tda7432.c                     |  2 +-
 drivers/media/usb/em28xx/em28xx-video.c         | 10 ++-
 drivers/media/v4l2-core/v4l2-common.c           |  9 +--
 drivers/mfd/rtsx_pcr.c                          |  2 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c               |  7 ++
 drivers/mtd/ubi/fastmap.c                       |  1 +
 drivers/net/Kconfig                             |  2 +
 drivers/net/ppp/ppp_generic.c                   |  2 +-
 drivers/net/usb/ax88179_178a.c                  |  7 +-
 drivers/net/wireless/rt2x00/rt2800usb.c         |  1 +
 drivers/of/base.c                               | 88 ++++++----------------
 drivers/of/selftest.c                           | 64 ++++++++++++++--
 drivers/platform/x86/acer-wmi.c                 | 11 +++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c              | 11 ++-
 drivers/spi/spi-pl022.c                         |  2 +-
 drivers/spi/spi-pxa2xx.c                        |  7 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c | 15 ++--
 drivers/staging/iio/meter/ade7758.h             |  1 -
 drivers/staging/iio/meter/ade7758_core.c        | 57 +++-----------
 drivers/staging/iio/meter/ade7758_ring.c        |  5 +-
 drivers/target/target_core_device.c             |  3 +-
 drivers/target/target_core_pr.c                 |  6 +-
 drivers/target/target_core_pr.h                 |  2 +-
 drivers/target/target_core_tpg.c                |  8 ++
 drivers/target/target_core_transport.c          |  3 +-
 drivers/tty/serial/serial_core.c                |  2 +-
 drivers/tty/tty_io.c                            |  7 +-
 drivers/usb/class/cdc-acm.c                     |  6 +-
 drivers/usb/core/hcd.c                          |  2 +
 drivers/usb/dwc3/ep0.c                          |  4 +-
 drivers/usb/dwc3/gadget.c                       | 19 +++--
 drivers/usb/dwc3/gadget.h                       |  2 +-
 drivers/usb/gadget/f_acm.c                      |  7 +-
 drivers/usb/gadget/udc-core.c                   |  5 ++
 drivers/usb/serial/cp210x.c                     |  1 +
 drivers/usb/serial/ftdi_sio.c                   |  3 +
 drivers/usb/serial/ftdi_sio_ids.h               | 12 ++-
 drivers/usb/serial/opticon.c                    |  2 +-
 drivers/usb/serial/option.c                     | 10 +++
 drivers/usb/storage/transport.c                 | 26 +++++++
 drivers/video/console/bitblit.c                 |  3 +-
 drivers/video/console/fbcon_ccw.c               |  3 +-
 drivers/video/console/fbcon_cw.c                |  3 +-
 drivers/video/console/fbcon_ud.c                |  3 +-
 drivers/virtio/virtio_pci.c                     | 33 ++++++++-
 fs/btrfs/file-item.c                            |  2 +-
 fs/buffer.c                                     |  8 ++
 fs/ext3/super.c                                 |  7 --
 fs/ext4/ext4.h                                  |  5 +-
 fs/ext4/ialloc.c                                |  4 +
 fs/ext4/inode.c                                 | 24 +++++-
 fs/ext4/ioctl.c                                 | 10 ++-
 fs/ext4/namei.c                                 |  4 +-
 fs/ext4/resize.c                                |  2 +-
 fs/ext4/super.c                                 | 13 ++--
 fs/ext4/xattr.c                                 | 32 ++++++--
 fs/jbd2/recovery.c                              |  1 +
 fs/jffs2/jffs2_fs_sb.h                          |  2 -
 fs/jffs2/wbuf.c                                 | 17 +----
 fs/lockd/mon.c                                  |  6 ++
 fs/namespace.c                                  |  3 +
 fs/nfsd/nfs4proc.c                              |  3 +-
 fs/pstore/inode.c                               |  4 +-
 fs/quota/dquot.c                                |  2 +-
 fs/super.c                                      |  2 +
 fs/ubifs/commit.c                               | 10 +--
 fs/ubifs/log.c                                  | 19 +++--
 fs/ubifs/master.c                               |  7 +-
 fs/ubifs/super.c                                |  1 -
 fs/ubifs/ubifs.h                                |  2 -
 include/drm/drm_pciids.h                        |  1 -
 include/linux/blkdev.h                          |  5 +-
 include/linux/compiler-gcc.h                    |  3 +
 include/linux/compiler-intel.h                  |  7 ++
 include/linux/compiler.h                        |  4 +
 include/linux/mm.h                              |  1 +
 include/linux/of.h                              | 84 +++++++++++++++++----
 include/linux/oom.h                             |  3 +
 include/linux/string.h                          |  5 +-
 kernel/freezer.c                                |  3 +
 kernel/module.c                                 |  2 +
 kernel/posix-timers.c                           |  1 +
 kernel/power/hibernate.c                        |  8 +-
 kernel/power/process.c                          | 40 +++++++++-
 kernel/trace/trace_syscalls.c                   |  8 +-
 lib/bitmap.c                                    |  8 +-
 lib/string.c                                    | 16 ++++
 mm/oom_kill.c                                   | 17 +++++
 mm/page_alloc.c                                 |  8 ++
 mm/page_cgroup.c                                |  1 +
 mm/percpu.c                                     |  2 -
 mm/truncate.c                                   | 58 ++++++++++++++-
 net/ceph/messenger.c                            |  3 +-
 net/ipv4/fib_semantics.c                        |  2 +-
 net/ipv4/ip_output.c                            | 12 ++-
 net/mac80211/rate.c                             |  2 +-
 net/netlink/af_netlink.c                        |  2 +-
 security/integrity/evm/evm_main.c               |  9 ++-
 security/selinux/hooks.c                        |  2 +-
 sound/core/pcm_compat.c                         |  2 +
 virt/kvm/iommu.c                                |  8 +-
 146 files changed, 1029 insertions(+), 421 deletions(-)


