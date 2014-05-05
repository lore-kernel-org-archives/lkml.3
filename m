Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaEEM2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:28:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40867 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932128AbaEEM2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:28:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 00/50] 3.12.19-stable review
Date: Mon,  5 May 2014 14:28:31 +0200
Message-Id: <cover.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.19 release.
There are 50 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed May  7 12:27:29 2014
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.19-rc1.xz
and the diffstat can be found below.

thanks,
js

===============


Ajesh Kunhipurayil Vijayan (1):
  jffs2: Fix crash due to truncation of csize

Al Viro (1):
  __dentry_path() fixes

Alexei Starovoitov (1):
  openvswitch: fix vport-netdev unregister

Aravind Gopalakrishnan (2):
  x86/quirks: Add workaround for AMD F16h Erratum792
  amd64_edac: Fix logic to determine channel for F15 M30h processors

Bodo Stroesser (1):
  ipmi: Fix a race restarting the timer

Chew, Kean ho (1):
  i2c: i801: enable Intel BayTrail SMBUS

Claudio Takahasi (1):
  Bluetooth: Fix removing Long Term Key

Dave Kleikamp (1):
  sparc64: don't treat 64-bit syscall return codes as 32-bit

David Ertman (1):
  e1000e: Fix no connectivity when driver loaded with cable out

David S. Miller (1):
  sparc64: Make sure %pil interrupts are enabled during hypervisor
    yield.

Derek Basehore (1):
  backing_dev: fix hung task on sync

Emil Goode (1):
  brcmsmac: fix deadlock on missing firmware

Eric Whitney (3):
  ext4: fix error return from ext4_ext_handle_uninitialized_extents()
  ext4: fix partial cluster handling for bigalloc file systems
  ext4: fix premature freeing of partial clusters split across leaf
    blocks

Hannes Reinecke (1):
  tty: Set correct tty name in 'active' sysfs attribute

Helge Deller (1):
  parisc: fix epoll_pwait syscall on compat kernel

Hidetoshi Seto (1):
  Btrfs: skip submitting barrier for missing device

Ian Abbott (1):
  staging: comedi: 8255_pci: initialize MITE data window

Ingo Molnar (1):
  drivers/net: tulip_remove_one needs to call pci_disable_device()

Jan Kara (1):
  bdi: avoid oops on device removal

Jay Cornwall (1):
  iommu/amd: Fix PASID format in INVALIDATE_IOTLB_PAGES command

Joe Perches (2):
  usbatm: Fix dynamic_debug / ratelimited atm_dbg and atm_rldbg macros
  printk: pr_debug_ratelimited: check state first to reduce "callbacks
    suppressed" messages

Josef Bacik (1):
  Btrfs: fix deadlock with nested trans handles

Kamlakant Patel (1):
  jffs2: Fix segmentation fault found in stress test

Kieran Clancy (1):
  ACPI / EC: Process rather than discard events in acpi_ec_clear

LEROY Christophe (1):
  powerpc/8xx: mfspr SPRN_TBRx in lieu of mftb/mftbu is not supported

Lan Tianyu (1):
  ACPI / button: Add ACPI Button event via netlink routine

Li Zefan (2):
  jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
  jffs2: remove from wait queue after schedule()

Mark Tinguely (1):
  xfs: fix directory hash ordering bug

Mikulas Patocka (2):
  dcache: restore error on restart in prepend_path
  user namespace: fix incorrect memory barriers

Mohit Kumar (2):
  PCI: designware: Fix RC BAR to be single 64-bit non-prefetchable
    memory BAR
  PCI: designware: Fix iATU programming for cfg1, io and mem viewport

Neil Horman (1):
  x86: Adjust irq remapping quirk for older revisions of 5500/5520
    chipsets

Oleg Nesterov (3):
  pid_namespace: pidns_get() should check task_active_pid_ns() != NULL
  wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE race
  exit: call disassociate_ctty() before exit_task_namespaces()

Oliver Neukum (1):
  ACPI / sleep: remove panic in case hardware has changed after S4

Paolo Bonzini (1):
  KVM: ioapic: fix assignment of ioapic->rtc_status.pending_eoi
    (CVE-2014-0155)

Paul Gortmaker (1):
  sparc32: fix build failure for arch_jump_label_transform

Peter Hurley (1):
  tty: Fix low_latency BUG

Petr Tesarik (1):
  /dev/mem: handle out-of-bounds read/write

Rusty Russell (1):
  virtio_balloon: don't softlockup on huge balloon changes.

Sergey Dyasly (1):
  ARM: 7840/1: LPAE: don't reject mapping /dev/mem above 4GB

Tedd Ho-Jeong An (1):
  Bluetooth: Add support for Intel Bluetooth device [8087:0a2a]

Wang, Xiaoming (1):
  net: ipv4: current group_info should be put after using.

 Documentation/i2c/busses/i2c-i801                  |  1 +
 arch/arm/mm/mmap.c                                 |  6 +--
 arch/parisc/kernel/syscall_table.S                 |  2 +-
 arch/powerpc/boot/util.S                           | 14 +++++++
 arch/powerpc/include/asm/ppc_asm.h                 |  2 +
 arch/powerpc/include/asm/reg.h                     |  7 ++++
 arch/powerpc/include/asm/timex.h                   |  8 ++++
 arch/powerpc/kernel/vdso32/gettimeofday.S          |  6 +++
 arch/sparc/Kconfig                                 |  2 +-
 arch/sparc/kernel/process_64.c                     |  4 +-
 arch/sparc/kernel/syscalls.S                       |  4 +-
 arch/x86/kernel/early-quirks.c                     | 15 +++----
 arch/x86/kernel/quirks.c                           | 37 +++++++++++++++++
 drivers/acpi/button.c                              |  4 ++
 drivers/acpi/ec.c                                  | 21 +++++-----
 drivers/acpi/sleep.c                               |  7 +---
 drivers/bluetooth/btusb.c                          |  1 +
 drivers/char/ipmi/ipmi_si_intf.c                   | 46 +++++++++++++---------
 drivers/char/mem.c                                 |  6 +++
 drivers/edac/amd64_edac.c                          | 14 +++++--
 drivers/i2c/busses/Kconfig                         |  1 +
 drivers/i2c/busses/i2c-i801.c                      |  3 ++
 drivers/iommu/amd_iommu.c                          |  4 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |  1 +
 drivers/net/ethernet/intel/e1000e/netdev.c         | 20 +++++++---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  | 14 +++----
 drivers/pci/host/pcie-designware.c                 |  8 ++--
 drivers/staging/comedi/drivers/8255_pci.c          | 34 ++++++++++++++++
 drivers/tty/ipwireless/tty.c                       |  3 --
 drivers/tty/tty_buffer.c                           | 20 ++--------
 drivers/tty/tty_io.c                               | 23 ++++++++---
 drivers/usb/atm/usbatm.h                           | 14 +++----
 drivers/usb/gadget/u_serial.c                      |  4 +-
 drivers/virtio/virtio_balloon.c                    |  6 +++
 fs/btrfs/disk-io.c                                 |  4 ++
 fs/btrfs/transaction.c                             | 14 ++-----
 fs/dcache.c                                        | 10 +++--
 fs/ext4/extents.c                                  | 40 ++++++++++++++++---
 fs/fs-writeback.c                                  | 31 ++++++++++-----
 fs/jffs2/compr_rtime.c                             |  4 +-
 fs/jffs2/nodelist.h                                |  2 +-
 fs/jffs2/nodemgmt.c                                | 14 +++++--
 fs/xfs/xfs_da_btree.c                              |  2 +-
 include/linux/backing-dev.h                        |  2 +-
 include/linux/printk.h                             | 16 +++++++-
 include/linux/tty.h                                |  2 +-
 kernel/exit.c                                      | 21 ++++++----
 kernel/pid_namespace.c                             |  4 +-
 kernel/user_namespace.c                            | 11 +++---
 mm/backing-dev.c                                   | 16 ++++++--
 net/bluetooth/hci_event.c                          |  8 +++-
 net/ipv4/ping.c                                    | 15 +++++--
 net/openvswitch/dp_notify.c                        |  7 +++-
 net/openvswitch/vport-netdev.c                     | 16 ++++++--
 net/openvswitch/vport-netdev.h                     |  1 +
 virt/kvm/ioapic.c                                  |  2 +-
 56 files changed, 430 insertions(+), 174 deletions(-)

-- 
1.9.2

