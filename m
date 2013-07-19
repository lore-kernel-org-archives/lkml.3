Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965582Ab3GSF03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:26:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965456Ab3GSF0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/72] 3.10.2-stable review
Date: Thu, 18 Jul 2013 22:25:17 -0700
Message-Id: <20130719052559.852627424@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.2 release.
There are 72 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Jul 21 05:25:08 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.2-rc1

Richard Genoud <richard.genoud@gmail.com>
    UBIFS: correct mount message

Steve French <smfrench@us.ibm.com>
    Handle big endianness in NTLM (ntlmv2) authentication

Wanpeng Li <liwanp@linux.vnet.ibm.com>
    mm/memory-hotplug: fix lowmem count overflow when offline pages

Michal Hocko <mhocko@suse.cz>
    memcg, kmem: fix reference count handling on the error path

Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: mm: fix boot on SA1110 Assabet

Magnus Damm <damm@opensource.se>
    ARM: shmobile: emev2 GIO3 resource fix

Takanari Hayama <taki@igel.co.jp>
    ARM: shmobile: r8a73a4: Fix resources for SCIFB0

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    ARM: dts: imx: cpus/cpu nodes dts updates

Jason Liu <r64343@freescale.com>
    ARM: 7778/1: smp_twd: twd_update_frequency need be run on all online CPUs

Marc Zyngier <Marc.Zyngier@arm.com>
    ARM: 7769/1: Cortex-A15: fix erratum 798181 implementation

Marc Zyngier <Marc.Zyngier@arm.com>
    ARM: 7768/1: prevent risks of out-of-bound access in ASID allocator

Marc Zyngier <Marc.Zyngier@arm.com>
    ARM: 7767/1: let the ASID allocator handle suspended animation

Jed Davis <jld@mozilla.com>
    ARM: 7765/1: perf: Record the user-mode PC in the call chain.

Theodore Ts'o <tytso@mit.edu>
    ext4: don't allow ext4_free_blocks() to fail due to ENOMEM

Theodore Ts'o <tytso@mit.edu>
    ext4: don't show usrquota/grpquota twice in /proc/mounts

Theodore Ts'o <tytso@mit.edu>
    ext4: fix ext4_get_group_number()

Jan Kara <jack@suse.cz>
    ext4: fix overflow when counting used blocks on 32-bit architectures

Jan Kara <jack@suse.cz>
    ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs

Jan Kara <jack@suse.cz>
    ext4: fix overflows in SEEK_HOLE, SEEK_DATA implementations

Jan Kara <jack@suse.cz>
    ext4: fix data offset overflow on 32-bit archs in ext4_inline_data_fiemap()

Josef Bacik <jbacik@fusionio.com>
    Btrfs: only do the tree_mod_log_free_eb if this is our last ref

Josef Bacik <jbacik@fusionio.com>
    Btrfs: hold the tree mod lock in __tree_mod_log_rewind

Josef Bacik <jbacik@fusionio.com>
    Btrfs: fix estale with btrfs send

Bart Van Assche <bart.vanassche@gmail.com>
    timer: Fix jiffies wrap behavior of round_jiffies_common()

Shane Huang <shane.huang@amd.com>
    ahci: remove pmp link online check in FBS EH

Seth Heasley <seth.heasley@intel.com>
    ahci: AHCI-mode SATA patch for Intel Coleto Creek DeviceIDs

Shane Huang <shane.huang@amd.com>
    ahci: Add AMD CZ SATA device ID

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: wake the queue if stopped when being unmapped

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: fix race in queue unmapping

Jiang Liu <liuj97@gmail.com>
    PCI: Fix refcount issue in pci_create_root_bus() error recovery path

Xudong Hao <xudong.hao@intel.com>
    PCI: Finish SR-IOV VF setup before adding the device

Paul Clements <paul.clements@steeleye.com>
    nbd: correct disconnect behavior

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: xattr: fix inlined xattr reflink

Chen Gang <gang.chen@asianux.com>
    arch: c6x: mm: include "asm/uaccess.h" to pass compiling

Dmitry Torokhov <rydberg@euromail.se>
    Input: bcm5974 - add support for the 2013 MacBook Air

Dmitry Torokhov <rydberg@euromail.se>
    HID: apple: Add support for the 2013 Macbook Air

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / PM: Fix corner case in acpi_bus_update_power()

Lv Zheng <lv.zheng@intel.com>
    ACPICA: Do not use extended sleep registers unless HW-reduced bit is set

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to skip DSDT scan

Lan Tianyu <tianyu.lan@intel.com>
    ACPI: Add CMOS RTC Operation Region handler support

Axel Lin <axel.lin@ingics.com>
    drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq

Ben Hutchings <ben@decadent.org.uk>
    genirq: Fix can_request_irq() for IRQs without an action

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pcifront: Deal with toolstack missing 'XenbusStateClosing' state.

Laszlo Ersek <lersek@redhat.com>
    xen/time: remove blocked time accounting from xen "clockchip"

Zach Bobroff <zacharyb@ami.com>
    x86, efi: retry ExitBootServices() on failure

Helge Deller <deller@gmx.de>
    parisc: optimize mtsp(0,sr) inline assembly

Helge Deller <deller@gmx.de>
    parisc: fix LMMIO mismatch between PAT length and MASK register

John David Anglin <dave.anglin@bell.net>
    parisc: Ensure volatile space register %sr1 is not clobbered

Christoph Lameter <cl@linux.com>
    slab: fix init_lock_keys

Helge Deller <deller@gmx.de>
    parisc: Fix gcc miscompilation in pa_memcpy()

Helge Deller <deller@gmx.de>
    parisc: document the shadow registers

Tejun Heo <tj@kernel.org>
    cgroup: fix RCU accesses to task->cgroups

Li Zefan <lizefan@huawei.com>
    cgroup: fix umount vs cgroup_event_remove() race

Joachim Eastwood <manabian@gmail.com>
    pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status

Jason Wang <jasowang@redhat.com>
    drivers: hv: switch to use mb() instead of smp_mb()

George Cherian <george.cherian@ti.com>
    usb: host: xhci-plat: release mem region while removing module

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: check for failed dma pool allocation

Roger Quadros <rogerq@ti.com>
    USB: ehci-omap: Tweak PHY initialization sequence

UCHINO Satoshi <satoshi.uchino@toshiba.co.jp>
    usb: gadget: f_mass_storage: add missing memory barrier for thread_wakeup_needed

Dan Williams <dcbw@redhat.com>
    USB: option,qcserial: move Novatel Gobi1K IDs to qcserial

Darren Hart <dvhart@linux.intel.com>
    pch_uart: Add uart_clk selection for the MinnowBoard

Theodore Ts'o <tytso@mit.edu>
    ext4: check error return from ext4_write_inline_data_end()

Al Viro <viro@ZenIV.linux.org.uk>
    ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()

Maarten ter Huurne <maarten@treewalker.org>
    ext4: fix corruption when online resizing a fs with 1K block size

Theodore Ts'o <tytso@mit.edu>
    jbd2: fix theoretical race in jbd2__journal_restart

Theodore Ts'o <tytso@mit.edu>
    jbd2: move superblock checksum calculation to jbd2_write_superblock()

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix duplicate if test

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8723ae: Fix typo in firmware names

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Add new USB ID for TP-Link TL-WN8200ND

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix a deadlock when a file is reopened

Steve French <smfrench@gmail.com>
    CIFS use sensible file nlink values if unprovided


-------------

Diffstat:

 Documentation/parisc/registers              |  8 +++
 Makefile                                    |  4 +-
 arch/arm/boot/dts/imx23.dtsi                |  8 ++-
 arch/arm/boot/dts/imx28.dtsi                |  8 ++-
 arch/arm/boot/dts/imx6dl.dtsi               |  2 +
 arch/arm/boot/dts/imx6q.dtsi                |  4 ++
 arch/arm/include/asm/mmu_context.h          | 10 +++-
 arch/arm/kernel/perf_event.c                |  1 +
 arch/arm/kernel/smp_tlb.c                   | 18 +-----
 arch/arm/kernel/smp_twd.c                   |  2 +-
 arch/arm/mach-shmobile/setup-emev2.c        |  8 +--
 arch/arm/mach-shmobile/setup-r8a73a4.c      |  2 +-
 arch/arm/mm/context.c                       | 55 +++++++++++++----
 arch/arm/mm/init.c                          |  2 +-
 arch/c6x/mm/init.c                          |  1 +
 arch/parisc/include/asm/special_insns.h     |  9 ++-
 arch/parisc/include/asm/tlbflush.h          |  5 +-
 arch/parisc/kernel/cache.c                  |  2 +-
 arch/parisc/lib/memcpy.c                    | 79 ++++++++++++++++---------
 arch/x86/boot/compressed/eboot.c            | 20 ++++++-
 arch/x86/xen/time.c                         | 17 +-----
 drivers/acpi/Makefile                       |  1 +
 drivers/acpi/acpi_cmos_rtc.c                | 92 +++++++++++++++++++++++++++++
 drivers/acpi/acpica/hwxfsleep.c             |  8 ++-
 drivers/acpi/device_pm.c                    | 23 ++++++--
 drivers/acpi/ec.c                           |  4 ++
 drivers/acpi/internal.h                     |  5 ++
 drivers/acpi/scan.c                         |  1 +
 drivers/ata/ahci.c                          |  2 +
 drivers/ata/libahci.c                       |  3 +-
 drivers/block/nbd.c                         |  7 ++-
 drivers/dma/pl330.c                         |  4 +-
 drivers/hid/hid-apple.c                     |  6 ++
 drivers/hid/hid-core.c                      |  6 ++
 drivers/hid/hid-ids.h                       |  3 +
 drivers/hv/ring_buffer.c                    | 10 ++--
 drivers/hv/vmbus_drv.c                      |  2 +-
 drivers/input/mouse/bcm5974.c               | 36 ++++++++++-
 drivers/net/wireless/iwlwifi/pcie/tx.c      | 13 ++++
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |  1 +
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c |  6 +-
 drivers/parisc/lba_pci.c                    | 56 ++++++++++++++++++
 drivers/pci/iov.c                           |  5 +-
 drivers/pci/probe.c                         | 14 +++--
 drivers/pci/quirks.c                        |  2 +
 drivers/pci/xen-pcifront.c                  |  7 +--
 drivers/pcmcia/at91_cf.c                    |  4 +-
 drivers/rtc/rtc-rv3029c2.c                  |  2 +-
 drivers/tty/serial/pch_uart.c               |  5 ++
 drivers/usb/gadget/f_mass_storage.c         |  2 +
 drivers/usb/host/ehci-omap.c                | 11 +++-
 drivers/usb/host/xhci-mem.c                 |  4 ++
 drivers/usb/host/xhci-plat.c                |  1 +
 drivers/usb/serial/option.c                 |  4 --
 drivers/usb/serial/qcserial.c               |  8 ++-
 fs/btrfs/ctree.c                            | 13 ++--
 fs/btrfs/send.c                             | 35 +++++++++++
 fs/cifs/cifs_unicode.h                      |  8 +--
 fs/cifs/cifsencrypt.c                       |  6 +-
 fs/cifs/file.c                              |  9 ++-
 fs/cifs/inode.c                             |  5 ++
 fs/ext3/namei.c                             |  7 +--
 fs/ext4/balloc.c                            |  4 +-
 fs/ext4/extents.c                           |  4 +-
 fs/ext4/file.c                              | 14 ++---
 fs/ext4/inline.c                            |  2 +-
 fs/ext4/inode.c                             | 15 +++--
 fs/ext4/mballoc.c                           | 11 +++-
 fs/ext4/namei.c                             |  7 +--
 fs/ext4/resize.c                            |  4 +-
 fs/ext4/super.c                             | 14 ++---
 fs/jbd2/journal.c                           |  3 +-
 fs/jbd2/transaction.c                       |  2 +-
 fs/ocfs2/xattr.c                            | 10 ++++
 fs/ubifs/super.c                            |  2 +-
 include/linux/cgroup.h                      | 58 ++++++++++++++----
 include/linux/nbd.h                         |  1 +
 kernel/cgroup.c                             | 25 ++++++--
 kernel/irq/manage.c                         |  6 +-
 kernel/timer.c                              |  8 ++-
 mm/memcontrol.c                             |  8 ---
 mm/page_alloc.c                             |  4 ++
 mm/slab.c                                   |  2 +-
 84 files changed, 676 insertions(+), 236 deletions(-)


