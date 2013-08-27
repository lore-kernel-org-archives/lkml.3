Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3H0BHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3H0BGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:06:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/74] 3.10.10-stable review
Date: Mon, 26 Aug 2013 18:07:58 -0700
Message-Id: <20130827010424.535365435@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.10 release.
There are 74 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Aug 29 01:03:56 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.10-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.10-rc1

Kent Overstreet <koverstreet@google.com>
    bcache: FUA fixes

Kumar Amit Mehta <gmate.amit@gmail.com>
    md: bcache: io.c: fix a potential NULL pointer dereference

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: fix waiting for hw ready

Tomas Winkler <tomas.winkler@intel.com>
    mei: don't have to clean the state on power up

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: fix reset state machine

David Vrabel <david.vrabel@citrix.com>
    x86/xen: do not identity map UNUSABLE regions in the machine E820

Radu Caragea <sinaelgl@gmail.com>
    x86 get_unmapped_area: Access mmap_legacy_base through mm_struct member

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "x86 get_unmapped_area(): use proper mmap base for bottom-up direction"

Roland Dreier <roland@purestorage.com>
    SCSI: sg: Fix user memory corruption when SG_IO is interrupted by a signal

Anton Blanchard <anton@samba.org>
    SCSI: lpfc: Don't force CONFIG_GENERIC_CSUM on

Martin Peschke <mpeschke@linux.vnet.ibm.com>
    SCSI: zfcp: fix schedule-inside-lock in scsi_device list loops

Martin Peschke <mpeschke@linux.vnet.ibm.com>
    SCSI: zfcp: fix lock imbalance by reworking request queue locking

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: disable L1 Active after pci_enable_device

Stanislaw Gruszka <sgruszka@redhat.com>
    iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL

Terry Suereth <terry.suereth@gmail.com>
    libata: apply behavioral quirks to sil3826 PMP

Dan Carpenter <dan.carpenter@oracle.com>
    Hostap: copying wrong data prism2_ioctl_giwaplist()

Anthony Foiani <anthony.foiani@gmail.com>
    sata_fsl: save irqs while coalescing

Anatolij Gustschin <agust@denx.de>
    usb: phy: fix build breakage

Daniel Drake <dsd@laptop.org>
    drivers/platform/olpc/olpc-ec.c: initialise earlier

Vyacheslav Dubeyko <slava@dubeyko.com>
    nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection

Vyacheslav Dubeyko <slava@dubeyko.com>
    nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error

Wladislav Wiebe <wladislav.kw@gmail.com>
    of: fdt: fix memory initialization for expanded DT

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Invalidate TLBs for the rings after a reset

Rafał Miłecki <zajec5@gmail.com>
    drm/radeon: fix WREG32_OR macro setting bits in a register

Christian König <christian.koenig@amd.com>
    drm/radeon: fix UVD message buffer validation

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/r7xx: fix copy paste typo in golden register setup

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: bug-fix NULL pointer dereference on failed attach

Nicolas Pitre <nicolas.pitre@linaro.org>
    ARM: 7816/1: CONFIG_KUSER_HELPERS: fix help text

Will Deacon <will.deacon@arm.com>
    arm64: perf: fix event validation for software group leaders

Will Deacon <will.deacon@arm.com>
    arm64: perf: fix array out of bounds access in armpmu_map_hw_event()

Nicolas Ferre <nicolas.ferre@atmel.com>
    ARM: at91/DT: fix at91sam9n12ek memory node

Sekhar Nori <nsekhar@ti.com>
    ARM: davinci: nand: specify ecc strength

David Vrabel <david.vrabel@citrix.com>
    xen/events: mask events when changing their VCPU binding

David Vrabel <david.vrabel@citrix.com>
    xen/events: initialize local per-cpu mask for all possible events

Daniel Drake <dsd@laptop.org>
    x86: Don't clear olpc_ofw_header when sentinel is detected

Dan Carpenter <dan.carpenter@oracle.com>
    VFS: collect_mounts() should return an ERR_PTR

Jussi Kivilinna <jussi.kivilinna@iki.fi>
    zd1201: do not use stack as URB transfer_buffer

Joern Rennecke <joern.rennecke@embecosm.com>
    ARC: [lib] strchr breakage in Big-endian configuration

Chuck Anderson <chuck.anderson@oracle.com>
    xen/smp: initialize IPI vectors before marking CPU online

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Check module functions being traced on reload

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing/uprobes: Fail to unregister if probe event files are in use

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing/kprobes: Fail to unregister if probe event files are in use

Oleg Nesterov <oleg@redhat.com>
    tracing: trace_remove_event_call() should fail if call/file is in use

Oleg Nesterov <oleg@redhat.com>
    tracing: Change remove_event_file_dir() to clear "d_subdirs"->i_private

Oleg Nesterov <oleg@redhat.com>
    tracing: Introduce remove_event_file_dir()

Oleg Nesterov <oleg@redhat.com>
    tracing: Change f_start() to take event_mutex and verify i_private != NULL

Oleg Nesterov <oleg@redhat.com>
    tracing: Change event_filter_read/write to verify i_private != NULL

Oleg Nesterov <oleg@redhat.com>
    tracing: Change event_enable/disable_read() to verify i_private != NULL

Oleg Nesterov <oleg@redhat.com>
    tracing: Turn event/id->i_private into call->event.type

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Add check for NULL regs if ops has SAVE_REGS set

Oleg Nesterov <oleg@redhat.com>
    tracing: Change tracing_fops/snapshot_fops to rely on tracing_get_cpu()

Oleg Nesterov <oleg@redhat.com>
    tracing: Change tracing_entries_fops to rely on tracing_get_cpu()

Oleg Nesterov <oleg@redhat.com>
    tracing: Change tracing_stats_fops to rely on tracing_get_cpu()

Oleg Nesterov <oleg@redhat.com>
    tracing: Change tracing_buffers_fops to rely on tracing_get_cpu()

Oleg Nesterov <oleg@redhat.com>
    tracing: Change tracing_pipe_fops() to rely on tracing_get_cpu()

Oleg Nesterov <oleg@redhat.com>
    tracing: Introduce trace_create_cpu_file() and tracing_get_cpu()

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    tracing/kprobe: Wait for disabling all running kprobe handlers

Namhyung Kim <namhyung.kim@lge.com>
    tracing: Do not call kmem_cache_free() on allocation failure

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: adjust firmware D3 configuration API

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: bump required firmware API version for 3160/7260

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: unregister leds when registration failed

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: take the seqno from packet if transmit failed

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: don't set the MCAST queue in STA's queue list

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: properly tell the fw that a STA is awake

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: fix MCAST in AP mode

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: correctly configure MCAST in AP mode

Samuel Ortiz <sameo@linux.intel.com>
    NFC: llcp: Fix non blocking sockets connections

Nicolas Ferre <nicolas.ferre@atmel.com>
    ARM: at91: at91sam9x5 RTC is not compatible with at91rm9200 one

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    ARC: gdbserver breakage in Big-Endian configuration #2

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    ARC: gdbserver breakage in Big-Endian configuration #1

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: Try harder to resolve _ADR collisions for bridges

Jeff Wu <zlinuxkernel@gmail.com>
    ACPI: add _STA evaluation at do_acpi_find_child()

Johannes Berg <johannes.berg@intel.com>
    mac80211: don't wait for TX status forever

Dominik Dingel <dingel@linux.vnet.ibm.com>
    KVM: s390: move kvm_guest_enter,exit closer to sie


-------------

Diffstat:

 Makefile                                      |   4 +-
 arch/arc/include/asm/ptrace.h                 |   2 +
 arch/arc/include/asm/syscall.h                |   5 +-
 arch/arc/kernel/entry.S                       |   4 +-
 arch/arc/lib/strchr-700.S                     |  10 ++
 arch/arm/boot/dts/at91sam9n12ek.dts           |   4 +-
 arch/arm/boot/dts/at91sam9x5.dtsi             |   2 +-
 arch/arm/mach-davinci/board-dm355-leopard.c   |   1 +
 arch/arm/mach-davinci/board-dm644x-evm.c      |   1 +
 arch/arm/mach-davinci/board-dm646x-evm.c      |   1 +
 arch/arm/mach-davinci/board-neuros-osd2.c     |   1 +
 arch/arm/mm/Kconfig                           |   9 +-
 arch/arm64/kernel/perf_event.c                |  10 +-
 arch/s390/kvm/kvm-s390.c                      |  21 ++-
 arch/x86/include/asm/bootparam_utils.h        |   4 +-
 arch/x86/kernel/sys_x86_64.c                  |   2 +-
 arch/x86/mm/mmap.c                            |   8 +-
 arch/x86/xen/setup.c                          |  22 +++
 arch/x86/xen/smp.c                            |  11 +-
 drivers/acpi/glue.c                           |  95 ++++++++++--
 drivers/ata/libata-pmp.c                      |  12 +-
 drivers/ata/sata_fsl.c                        |   5 +-
 drivers/gpu/drm/i915/i915_reg.h               |   2 +
 drivers/gpu/drm/i915/intel_ringbuffer.c       |  12 ++
 drivers/gpu/drm/radeon/radeon.h               |   2 +-
 drivers/gpu/drm/radeon/radeon_uvd.c           |   8 ++
 drivers/gpu/drm/radeon/rv770.c                |  12 +-
 drivers/md/bcache/btree.c                     |  23 ++-
 drivers/md/bcache/io.c                        |   2 +
 drivers/md/bcache/journal.c                   |   2 +-
 drivers/md/bcache/request.c                   |  13 +-
 drivers/misc/mei/hw-me.c                      |  14 +-
 drivers/misc/mei/init.c                       |   3 +-
 drivers/net/wireless/hostap/hostap_ioctl.c    |   4 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c   |   5 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c       |  12 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h  |   4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h |   8 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   |  11 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |   6 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |   1 +
 drivers/net/wireless/iwlwifi/mvm/sta.c        |  11 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c         |   6 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c     |  10 +-
 drivers/net/wireless/zd1201.c                 |   4 +-
 drivers/of/fdt.c                              |   2 +
 drivers/pci/pci-acpi.c                        |  15 +-
 drivers/platform/olpc/olpc-ec.c               |   2 +-
 drivers/s390/scsi/zfcp_erp.c                  |  29 +++-
 drivers/s390/scsi/zfcp_qdio.c                 |   8 +-
 drivers/scsi/Kconfig                          |   1 -
 drivers/staging/comedi/drivers.c              |   2 +-
 drivers/usb/phy/phy-fsl-usb.h                 |   2 +-
 drivers/usb/phy/phy-fsm-usb.c                 |   2 +-
 drivers/xen/events.c                          |  13 +-
 fs/bio.c                                      |  20 ++-
 fs/namespace.c                                |   2 +-
 fs/nilfs2/segbuf.c                            |   5 +-
 include/acpi/acpi_bus.h                       |   6 +-
 include/linux/ftrace_event.h                  |   2 +-
 include/linux/mm_types.h                      |   1 +
 include/linux/sched.h                         |   1 -
 include/linux/wait.h                          |  57 ++++++++
 kernel/trace/ftrace.c                         |  89 ++++++++++--
 kernel/trace/trace.c                          | 173 +++++++++++-----------
 kernel/trace/trace_events.c                   | 198 ++++++++++++++++----------
 kernel/trace/trace_events_filter.c            |  17 +--
 kernel/trace/trace_kprobe.c                   |  42 ++++--
 kernel/trace/trace_uprobe.c                   |  51 +++++--
 net/mac80211/mlme.c                           |  15 +-
 net/nfc/llcp.h                                |   1 +
 net/nfc/llcp_sock.c                           |   8 +-
 72 files changed, 811 insertions(+), 362 deletions(-)


