Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaBKQHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:07:00 -0500
Received: from mail1.windriver.com ([147.11.146.13]:40497 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaBKQGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:06:55 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>, <stable@vger.kernel.org>,
        <lwn@lwn.net>, <konstantin@linuxfoundation.org>
Subject: Linux 2.6.34.15
Date: Tue, 11 Feb 2014 11:05:22 -0500
Message-ID: <1392134722-25859-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.34.15 kernel.

All 2.6.34 users are strongly encouraged to update.

Please also note that this is the final release on
the 2.6.34 line.  So you really need to start thinking
about deploying your upgrade plan.  The 2.6.34 is EOL.

The updated 2.6.34.y git tree can be found at:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.34.y
and can be browsed at the normal kernel.org git web browser:
   http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.34.y

Thanks,
Paul.
---

The following changes since commit c12a2ff7096edca9f610ef813253c1bceeb2800d:

  Linux 2.6.34.14

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux-stable.git tags/v2.6.34.15

for you to fetch changes up to 5878e067ecac4bd2320e933ec485c01190a5b881:

  Linux 2.6.34.15 (2014-02-10 17:31:40 -0500)

----------------------------------------------------------------
This is the 2.6.34.15 stable release

----------------------------------------------------------------
Al Viro (1):
      vfs: missed source of ->f_pos races

Alan Cox (1):
      x86/msr: Add capabilities check

Alan Stern (1):
      USB: EHCI: go back to using the system clock for QH unlinks

Alex He (1):
      xHCI: Correct the #define XHCI_LEGACY_DISABLE_SMI

Alex Williamson (2):
      KVM: unmap pages from the iommu when slots are removed
      KVM: lock slots_lock around device assignment

Alexey Khoroshilov (1):
      net/core: Fix potential memory leak in dev_set_alias()

Allison Henderson (1):
      ext4: don't dereference null pointer when make_indexed_dir() fails

Anatol Pomozov (1):
      ext4: make orphan functions be no-op in no-journal mode

Anderson Lizardo (1):
      Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()

Andi Kleen (2):
      MCE: Fix vm86 handling for 32bit mce handler
      Fix install_process_keyring error handling

Andrew Worsley (1):
      USB: serial: ftdi_sio: Handle the old_termios == 0 case e.g. uart_resume_port()

Andy Honig (2):
      KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME (CVE-2013-1796)
      KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)

Andy Lutomirski (1):
      mm: Hold a file reference in madvise_remove

Anurup m (1):
      fs/fscache/stats.c: fix memory leak

Bart Van Assche (1):
      Avoid dangling pointer in scsi_requeue_command()

Bernd Schubert (1):
      ext4: always set i_op in ext4_mknod()

Bjorn Helgaas (1):
      Driver core: treat unregistered bus_types as having no devices

Bjørn Mork (1):
      USB: cdc-wdm: fix lockup on error in wdm_read

Brian Foster (1):
      ext4: don't let i_reserved_meta_blocks go negative

Chen Gang (1):
      drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory overflow

Chris Mason (1):
      Btrfs: call the ordered free operation without any locks held

Christoffer Dall (1):
      mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED

Colin Ian King (1):
      USB: echi-dbgp: increase the controller wait time to come out of halt.

Cong Ding (1):
      fs/cifs/cifs_dfs_ref.c: fix potential memory leakage

Cong Wang (1):
      net: prevent setting ttl=0 via IP_TTL

Dan Carpenter (3):
      x86, tls: Off by one limit check
      USB: kaweth.c: use GFP_ATOMIC under spin_lock
      mtd: cafe_nand: fix an & vs | mistake

Dan Williams (3):
      libsas: continue revalidation
      SCSI: libsas: fix sas_discover_devices return code handling
      fix eh wakeup (scsi_schedule_eh vs scsi_restart_operations)

Daniel Borkmann (3):
      net: sctp: sctp_auth_key_put: use kzfree instead of kfree
      net: sctp: sctp_endpoint_free: zero out secret key data
      net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree

Daniel J Blueman (1):
      Prevent interface errors with Seagate FreeAgent GoFlex

Darren Hart (3):
      futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()
      futex: Fix bug in WARN_ON for NULL q.pi_state
      futex: Test for pi_mutex on fault in futex_wait_requeue_pi()

Dave Hansen (2):
      hugetlb: fix resv_map leak in error path
      mm: fix vma_resv_map() NULL pointer

Dave Jones (1):
      Remove user-triggerable BUG from mpol_to_str

David Howells (1):
      keys: fix race with concurrent install_user_keyrings()

David S. Miller (1):
      tun: Fix formatting.

David Ward (1):
      net_sched: gred: Fix oops in gred_dump() in WRED mode

Denys Vlasenko (1):
      coredump: prevent double-free on an error path in core dumper

Dmitry Monakhov (1):
      ext4: online defrag is not supported for journaled files

Eddie Wai (1):
      bnx2i: Fixed NULL ptr deference for 1G bnx2 Linux iSCSI offload

Emese Revfy (1):
      kernel/signal.c: stop info leak via the tkill and the tgkill syscalls

Eric Dumazet (13):
      inet: add RCU protection to inet->opt
      tcp: allow splice() to build full TSO packets
      tcp: tcp_sendpages() should call tcp_push() once
      tcp: fix MSG_SENDPAGE_NOTLAST logic
      tcp: preserve ACK clocking in TSO
      net: guard tcp_set_keepalive() to tcp sockets
      netem: fix possible skb leak
      net: fix a race in sock_queue_err_skb()
      netlink: fix races after skb queueing
      softirq: reduce latencies
      net: reduce net_rx_action() latency to 2 HZ
      tcp: drop SYN+FIN messages
      drop_monitor: dont sleep in atomic context

Eric Paris (1):
      inotify: fix double free/corruption of stuct user

Eric Sandeen (2):
      jbd2: clear BH_Delay & BH_Unwritten in journal_unmap_buffer
      btrfs: use rcu_barrier() to wait for bdev puts at unmount

Eric Wong (1):
      epoll: prevent missed events on EPOLL_CTL_MOD

Eryu Guan (1):
      jbd/jbd2: validate sb->s_first in journal_get_superblock()

Eugene Shatokhin (1):
      ext4: fix memory leak in ext4_xattr_set_acl()'s error path

Geert Uytterhoeven (1):
      sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()

George G. Davis (1):
      udf: fix udf_error build warnings

Greg Pearson (1):
      pcdp: use early_ioremap/early_iounmap to access pcdp table

Greg Thelen (1):
      tmpfs: fix use-after-free of mempolicy object

Hannes Frederic Sowa (1):
      ipv6: call udp_push_pending_frames when uncorking a socket with AF_INET pending data

Hans de Goede (1):
      usbdevfs: Correct amount of data copied to user in processcompl_compat

Herbert Xu (1):
      bridge: Fix mglist corruption that leads to memory corruption

Hiroaki SHIMODA (1):
      net_sched: gact: Fix potential panic in tcf_gact().

Hugh Dickins (1):
      mm: fix invalidate_complete_page2() lock ordering

J. Bruce Fields (3):
      nfsd4: fix oops on unusual readlike compound
      svcrpc: sends on closed socket should stop immediately
      svcrpc: fix svc_xprt_enqueue/svc_recv busy-looping

James Bottomley (1):
      fix crash in scsi_dispatch_cmd()

Jan Beulich (1):
      x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.

Jan Kara (9):
      jbd: Fix assertion failure in commit code due to lacking transaction credits
      jbd: Fix lock ordering bug in journal_unmap_buffer()
      ext3: Fix fdatasync() for files with only i_size changes
      ext3: Fix error handling on inode bitmap corruption
      ext4: Fix fs corruption when make_indexed_dir() fails
      ext4: fix fdatasync() for files with only i_size changes
      ext4: fix error handling on inode bitmap corruption
      udf: Fix bitmap overflow on large filesystems with small block size
      udf: Fix data corruption for files in ICB

Jesper Dangaard Brouer (1):
      net: fix divide by zero in tcp algorithm illinois

Jiri Kosina (1):
      tcp: perform DMA to userspace only if there is a task waiting for it

Jiri Slaby (1):
      serial: 8250, increase PASS_LIMIT

Johan Hovold (6):
      Bluetooth: hci_ldisc: fix NULL-pointer dereference on tty_close
      USB: whiteheat: fix memory leak in error path
      USB: mos7840: fix urb leak at release
      USB: mos7840: fix port-device leak in error path
      USB: garmin_gps: fix memory leak on disconnect
      USB: serial: fix race between probe and open

Jonathan Nieder (1):
      NFSv4: Revalidate uid/gid after open

Jozsef Kadlecsik (1):
      netfilter: nf_ct_ipv4: packets with wrong ihl are invalid

Jun Nie (1):
      Bluetooth: add NULL pointer check in HCI

Jussi Kivilinna (1):
      crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent data corruption

Kees Cook (9):
      HID: validate HID report id size
      HID: pantherlord: validate output report details
      HID: provide a helper for validating hid reports
      HID: zeroplus: validate output report details
      HID: LG: validate HID output report details
      gen_init_cpio: avoid stack overflow when expanding
      exec: do not leave bprm->interp on stack
      exec: use -ELOOP for max recursion depth
      fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check

Kent Yoder (1):
      crypto: sha512 - Fix byte counter overflow in SHA-512

Konrad Rzeszutek Wilk (3):
      xen/bootup: allow read_tscp call for Xen PV guests.
      xen/bootup: allow {read|write}_cr8 pvops call.
      ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled

Lachlan McIlroy (1):
      ext4: limit group search loop for non-extent files

Larry Finger (1):
      b43legacy: Fix crash on unload when firmware not available

Lennart Sorensen (1):
      USB: serial: Fix memory leak in sierra_release()

Li Zhong (1):
      Fix a dead loop in async_synchronize_full()

Marcin Jurkowski (1):
      w1: fix oops when w1_search is called from netlink connector

Mark Ferrell (1):
      usb: serial: mos7840: Fixup mos7840_chars_in_buffer()

Mark Rutland (1):
      clockevents: Don't allow dummy broadcast timers

Mathias Krause (24):
      rose: fix info leak via msg_name in rose_recvmsg()
      llc: fix info leak via getsockname()
      llc: Fix missing msg_namelen update in llc_ui_recvmsg()
      iucv: Fix missing msg_namelen update in iucv_sock_recvmsg()
      ax25: fix info leak via msg_name in ax25_recvmsg()
      atm: fix info leak in getsockopt(SO_ATMPVC)
      atm: fix info leak via getsockname()
      atm: update msg_namelen in vcc_recvmsg()
      ipvs: fix info leak in getsockopt(IP_VS_SO_GET_TIMEOUT)
      net: fix info leak in compat dev_ifconf()
      net/tun: fix ioctl() based info leaks
      xfrm_user: fix info leak in copy_to_user_state()
      xfrm_user: fix info leak in copy_to_user_policy()
      xfrm_user: fix info leak in copy_to_user_tmpl()
      xfrm_user: return error pointer instead of NULL
      xfrm_user: return error pointer instead of NULL #2
      Bluetooth: HCI - Fix info leak in getsockopt(HCI_FILTER)
      Bluetooth: RFCOMM - Fix info leak via getsockname()
      Bluetooth: RFCOMM - Fix missing msg_namelen update in rfcomm_sock_recvmsg()
      Bluetooth: L2CAP - Fix info leak via getsockname()
      Bluetooth: fix possible info leak in bt_sock_recvmsg()
      isofs: avoid info leak on export
      udf: avoid info leak on export
      dccp: check ccid before dereferencing

Matthew Garrett (1):
      xhci: Make handover code more robust

Mel Gorman (2):
      mempolicy: fix a race in shared_policy_replace()
      x86/mm: Check if PUD is large when validating a kernel address

Namhyung Kim (1):
      tracing: Fix double free when function profile init failed

Namjae Jeon (1):
      udf: fix memory leak while allocating blocks during write

Neil Horman (4):
      crypto: ansi_cprng - Fix off by one error in non-block size request
      drop_monitor: fix sleeping in invalid context warning
      drop_monitor: Make updating data->skb smp safe
      drop_monitor: prevent init path from scheduling on the wrong cpu

Nikola Pajkovsky (1):
      udf: fix retun value on error path in udf_load_logicalvol

Nithin Nayak Sujir (1):
      tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mode

Niu Yawei (1):
      ext4: fix race in ext4_mb_add_n_trim()

Oleg Nesterov (2):
      ptrace: ptrace_resume() shouldn't wake up !TASK_TRACED thread
      wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACED task

Oliver Neukum (1):
      USB: cdc-wdm: fix buffer overflow

Paolo Bonzini (3):
      block: add and use scsi_blk_cmd_ioctl
      block: fail SCSI passthrough ioctls on partition devices
      dm: do not forward ioctls from logical volumes to the underlying device

Patrick McHardy (1):
      IPoIB: Fix use-after-free of multicast object

Paul Gortmaker (2):
      Revert "percpu: fix chunk range calculation"
      Linux 2.6.34.15

Paul Moore (2):
      unix: fix a race condition in unix_release()
      cipso: don't follow a NULL pointer when setsockopt() is called

Pavel Shilovsky (1):
      fuse: fix stat call on 32 bit platforms

Roberto Sassu (1):
      ecryptfs: call vfs_setxattr() in ecryptfs_setxattr()

Romain Francoise (1):
      x86, random: make ARCH_RANDOM prompt if EMBEDDED, not EXPERT

Samu Kallio (1):
      x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

Sarah Sharp (3):
      xhci: Increase reset timeout for Renesas 720201 host.
      xhci: Reset reserved command ring TRBs on cleanup.
      xhci: Don't write zeroed pointers to xHC registers.

Sasha Levin (1):
      phonet: Check input from user before allocating

Shawn Guo (1):
      kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()

Stanislaw Gruszka (1):
      posix-cpu-timers: Fix nanosleep task_struct leak

Stefan Hasko (1):
      net: sched: integer overflow fix

Stephen Hemminger (1):
      bridge: set priority of STP packets

Sven Schnelle (1):
      USB: CDC ACM: Fix NULL pointer dereference

T Makphaibulchoke (1):
      kernel/resource.c: fix stack overflow in __reserve_region_with_split()

Takamori Yamaguchi (1):
      mm: bugfix: set current->reclaim_state to NULL while returning from kswapd()

Takashi Iwai (1):
      ALSA: seq: Fix missing error handling in snd_seq_timer_open()

Tejun Heo (1):
      cgroup: remove incorrect dget/dput() pair in cgroup_create_dir()

Theodore Ts'o (2):
      ext4: lock i_mutex when truncating orphan inodes
      ext4: avoid hang when mounting non-journal filesystems with orphan list

Thomas Gleixner (1):
      tick: Cleanup NOHZ per cpu data on cpu down

Thomas Jarosch (1):
      PCI: Add quirk for still enabled interrupts on Intel Sandy Bridge GPUs

Tirupathi Reddy (1):
      timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

Tommi Rantala (1):
      sctp: fix memory leak in sctp_datamsg_from_user() when copy from user space fails

Trond Myklebust (2):
      NFSv3: Ensure that do_proc_get_root() reports errors correctly
      kernel panic when mount NFSv4

Tyler Hicks (3):
      libceph: Fix NULL pointer dereference in auth client code
      eCryptfs: Copy up lower inode attrs after setting lower xattr
      eCryptfs: Properly check for O_RDONLY flag before doing privileged open

Vyacheslav Dubeyko (1):
      hfsplus: fix potential overflow in hfsplus_file_truncate()

Wang YanQing (1):
      video:uvesafb: Fix oops that uvesafb try to execute NX-protected page

Weiping Pan (1):
      rds: set correct msg_namelen

Wen Congyang (1):
      tracing: Don't call page_to_pfn() if page is NULL

Willy Tarreau (1):
      tcp: do_tcp_sendpages() must try to push data out on oom conditions

Wolfgang Frisch (1):
      USB: io_ti: Fix NULL dereference in chase_port()

Wu Fengguang (1):
      isdnloop: fix and simplify isdnloop_init()

Xiao Guangrong (1):
      mm: mmu_notifier: fix freed page still mapped in secondary MMU

Xiaotian Feng (1):
      fix Null pointer dereference on disk error

Zach Brown (1):
      fuse: verify all ioctl retry iov elements

danborkmann@iogearbox.net (1):
      af_packet: remove BUG statement in tpacket_destruct_skb

stephen hemminger (1):
      netlink: wake up netlink listeners sooner (v2)

 Makefile                                       |   2 +-
 arch/x86/Kconfig                               |   2 +-
 arch/x86/include/asm/pgtable.h                 |   5 ++
 arch/x86/kernel/cpu/mcheck/mce.c               |   9 +-
 arch/x86/kernel/msr.c                          |   3 +
 arch/x86/kernel/tls.c                          |   4 +-
 arch/x86/kvm/x86.c                             |   5 ++
 arch/x86/mm/fault.c                            |   6 +-
 arch/x86/mm/init_64.c                          |   3 +
 arch/x86/xen/enlighten.c                       |  18 +++-
 arch/x86/xen/xen-asm_32.S                      |  14 +--
 block/blk-core.c                               |   3 +
 block/blk-exec.c                               |   7 ++
 block/scsi_ioctl.c                             |  52 +++++++++++
 crypto/ansi_cprng.c                            |   4 +-
 crypto/cryptd.c                                |  11 ++-
 crypto/sha512_generic.c                        |   2 +-
 drivers/acpi/processor_idle.c                  |   3 +
 drivers/ata/libata-core.c                      |   1 +
 drivers/ata/libata-scsi.c                      |   6 +-
 drivers/base/bus.c                             |   4 +-
 drivers/block/cciss.c                          |   6 +-
 drivers/block/ub.c                             |   3 +-
 drivers/block/virtio_blk.c                     |   4 +-
 drivers/bluetooth/hci_ldisc.c                  |   6 +-
 drivers/cdrom/cdrom.c                          |   3 +-
 drivers/char/ipmi/ipmi_bt_sm.c                 |   4 +-
 drivers/firmware/pcdp.c                        |   4 +-
 drivers/hid/hid-core.c                         |  68 +++++++++++++-
 drivers/hid/hid-lg2ff.c                        |  19 +---
 drivers/hid/hid-lg3ff.c                        |  29 ++----
 drivers/hid/hid-lgff.c                         |  17 +---
 drivers/hid/hid-pl.c                           |  10 ++-
 drivers/hid/hid-zpff.c                         |  18 ++--
 drivers/ide/ide-floppy_ioctl.c                 |   3 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  19 ++--
 drivers/isdn/isdnloop/isdnloop.c               |  12 ---
 drivers/md/dm-linear.c                         |  12 ++-
 drivers/md/dm-mpath.c                          |   6 ++
 drivers/mtd/nand/cafe_nand.c                   |   2 +-
 drivers/net/tg3.c                              |   4 +
 drivers/net/tun.c                              |   6 +-
 drivers/net/usb/kaweth.c                       |   2 +-
 drivers/net/wireless/b43legacy/main.c          |   2 +
 drivers/pci/quirks.c                           |  34 +++++++
 drivers/scsi/bnx2i/bnx2i_hwi.c                 |   3 +
 drivers/scsi/libsas/sas_expander.c             |  47 ++++------
 drivers/scsi/scsi_error.c                      |  14 +++
 drivers/scsi/scsi_lib.c                        |  13 +++
 drivers/scsi/sd.c                              |  13 ++-
 drivers/serial/8250.c                          |   2 +-
 drivers/usb/class/cdc-acm.c                    |   3 +-
 drivers/usb/class/cdc-wdm.c                    |  25 +++++-
 drivers/usb/core/devio.c                       |  10 ++-
 drivers/usb/early/ehci-dbgp.c                  |   2 +-
 drivers/usb/host/ehci-hcd.c                    |   8 +-
 drivers/usb/host/ehci-q.c                      |  82 +++++++++--------
 drivers/usb/host/ehci.h                        |   3 +-
 drivers/usb/host/pci-quirks.c                  |  22 +++--
 drivers/usb/host/xhci-ext-caps.h               |   5 +-
 drivers/usb/host/xhci-mem.c                    |  10 +--
 drivers/usb/host/xhci.c                        |   5 +-
 drivers/usb/serial/ftdi_sio.c                  |   4 +
 drivers/usb/serial/garmin_gps.c                |   7 +-
 drivers/usb/serial/io_ti.c                     |   3 +
 drivers/usb/serial/mos7840.c                   |  11 ++-
 drivers/usb/serial/sierra.c                    |   1 +
 drivers/usb/serial/usb-serial.c                |   8 ++
 drivers/usb/serial/whiteheat.c                 |   1 +
 drivers/video/uvesafb.c                        |  11 ++-
 drivers/w1/w1.c                                |   3 +-
 fs/binfmt_elf.c                                |  19 +---
 fs/binfmt_em86.c                               |   1 -
 fs/binfmt_misc.c                               |  11 +--
 fs/binfmt_script.c                             |   8 +-
 fs/btrfs/async-thread.c                        |   9 +-
 fs/btrfs/volumes.c                             |   6 ++
 fs/ceph/auth_none.c                            |   6 ++
 fs/cifs/cifs_dfs_ref.c                         |   2 +
 fs/compat.c                                    |  10 ++-
 fs/compat_ioctl.c                              |   2 +
 fs/ecryptfs/inode.c                            |   9 +-
 fs/ecryptfs/kthread.c                          |   2 +-
 fs/eventpoll.c                                 |  22 ++++-
 fs/exec.c                                      |  25 ++++--
 fs/ext3/ialloc.c                               |   8 +-
 fs/ext3/inode.c                                |  17 +++-
 fs/ext4/acl.c                                  |   6 +-
 fs/ext4/ialloc.c                               |   8 +-
 fs/ext4/inode.c                                |  17 +++-
 fs/ext4/mballoc.c                              |  12 ++-
 fs/ext4/move_extent.c                          |   7 +-
 fs/ext4/namei.c                                |  26 ++++--
 fs/ext4/super.c                                |   2 +
 fs/fscache/stats.c                             |   2 +-
 fs/fuse/dir.c                                  |   1 +
 fs/fuse/file.c                                 |   2 +-
 fs/fuse/fuse_i.h                               |   3 +
 fs/fuse/inode.c                                |  17 +++-
 fs/hfsplus/extents.c                           |   2 +-
 fs/isofs/export.c                              |   1 +
 fs/jbd/commit.c                                |  45 +++++++---
 fs/jbd/journal.c                               |   8 ++
 fs/jbd/transaction.c                           |  66 +++++++++-----
 fs/jbd2/journal.c                              |   8 ++
 fs/jbd2/transaction.c                          |   2 +
 fs/nfs/nfs3proc.c                              |   2 +-
 fs/nfs/nfs4proc.c                              |   1 +
 fs/nfsd/nfs4xdr.c                              |  11 ++-
 fs/notify/inotify/inotify_fsnotify.c           |   1 +
 fs/notify/inotify/inotify_user.c               |  39 +++-----
 fs/splice.c                                    |   7 +-
 fs/sysfs/dir.c                                 |  16 ++--
 fs/udf/file.c                                  |  35 ++++++--
 fs/udf/inode.c                                 |   4 +
 fs/udf/namei.c                                 |   1 +
 fs/udf/super.c                                 |  14 ++-
 fs/udf/udf_sb.h                                |   2 +-
 include/linux/binfmts.h                        |   3 +-
 include/linux/blkdev.h                         |   3 +
 include/linux/hid.h                            |   8 +-
 include/linux/kvm_host.h                       |   6 ++
 include/linux/mempolicy.h                      |   2 +-
 include/linux/page-flags.h                     |   8 +-
 include/linux/socket.h                         |   2 +-
 include/net/inet_sock.h                        |  14 ++-
 include/net/ip.h                               |  11 +--
 include/net/sock.h                             |   4 +-
 include/net/udp.h                              |   1 +
 include/trace/events/kmem.h                    |   4 +-
 kernel/async.c                                 |  13 ++-
 kernel/cgroup.c                                |   2 -
 kernel/futex.c                                 |  17 ++--
 kernel/posix-cpu-timers.c                      |  23 ++++-
 kernel/ptrace.c                                |   2 +-
 kernel/resource.c                              |  50 ++++++++---
 kernel/sched.c                                 |   3 +-
 kernel/signal.c                                |   2 +-
 kernel/softirq.c                               |  17 ++--
 kernel/sys.c                                   |   1 +
 kernel/time/tick-broadcast.c                   |   3 +-
 kernel/time/tick-sched.c                       |   2 +-
 kernel/timer.c                                 |   2 +-
 kernel/trace/ftrace.c                          |   1 -
 mm/hugetlb.c                                   |  29 ++++--
 mm/madvise.c                                   |  16 +++-
 mm/mempolicy.c                                 |  39 ++++----
 mm/mmu_notifier.c                              |  45 +++++-----
 mm/percpu.c                                    |  46 +++++-----
 mm/shmem.c                                     |  10 ++-
 mm/truncate.c                                  |   3 +-
 mm/vmscan.c                                    |   2 +
 net/atm/common.c                               |   3 +
 net/atm/pvc.c                                  |   1 +
 net/ax25/af_ax25.c                             |   1 +
 net/bluetooth/af_bluetooth.c                   |   4 +-
 net/bluetooth/hci_sock.c                       |   1 +
 net/bluetooth/hidp/core.c                      |   2 +-
 net/bluetooth/l2cap.c                          |   1 +
 net/bluetooth/rfcomm/sock.c                    |   2 +
 net/bridge/br_multicast.c                      |   3 +-
 net/bridge/br_stp_bpdu.c                       |   2 +
 net/core/dev.c                                 |   9 +-
 net/core/drop_monitor.c                        | 113 ++++++++++++-----------
 net/core/sock.c                                |   3 +-
 net/dccp/ccid.h                                |   4 +-
 net/dccp/ipv4.c                                |  15 ++--
 net/dccp/ipv6.c                                |   2 +-
 net/ipv4/af_inet.c                             |  16 ++--
 net/ipv4/cipso_ipv4.c                          | 119 ++++++++++++++-----------
 net/ipv4/icmp.c                                |  23 +++--
 net/ipv4/inet_connection_sock.c                |   8 +-
 net/ipv4/ip_options.c                          |  38 ++++----
 net/ipv4/ip_output.c                           |  50 ++++++-----
 net/ipv4/ip_sockglue.c                         |  35 +++++---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   8 ++
 net/ipv4/raw.c                                 |  19 +++-
 net/ipv4/syncookies.c                          |   4 +-
 net/ipv4/tcp.c                                 |   5 +-
 net/ipv4/tcp_illinois.c                        |   8 +-
 net/ipv4/tcp_input.c                           |   6 +-
 net/ipv4/tcp_ipv4.c                            |  33 ++++---
 net/ipv4/tcp_output.c                          |   7 +-
 net/ipv4/udp.c                                 |  24 +++--
 net/ipv6/tcp_ipv6.c                            |   2 +-
 net/ipv6/udp.c                                 |   7 +-
 net/iucv/af_iucv.c                             |   2 +
 net/llc/af_llc.c                               |   5 +-
 net/netfilter/ipvs/ip_vs_ctl.c                 |   1 +
 net/netlink/af_netlink.c                       |  26 +++---
 net/packet/af_packet.c                         |   1 -
 net/phonet/pep.c                               |   3 +
 net/rds/recv.c                                 |   3 +
 net/rose/af_rose.c                             |   1 +
 net/sched/act_gact.c                           |  14 ++-
 net/sched/sch_gred.c                           |   7 +-
 net/sched/sch_htb.c                            |   2 +-
 net/sched/sch_netem.c                          |   6 +-
 net/sctp/auth.c                                |   2 +-
 net/sctp/chunk.c                               |   7 +-
 net/sctp/endpointola.c                         |   5 ++
 net/sctp/socket.c                              |   2 +-
 net/socket.c                                   |   7 +-
 net/sunrpc/rpc_pipe.c                          |   2 +-
 net/sunrpc/svc_xprt.c                          |  10 +--
 net/unix/af_unix.c                             |   7 +-
 net/xfrm/xfrm_user.c                           |  15 +++-
 security/keys/process_keys.c                   |   4 +-
 sound/core/seq/seq_timer.c                     |   8 +-
 usr/gen_init_cpio.c                            |  43 ++++-----
 virt/kvm/ioapic.c                              |   7 +-
 virt/kvm/iommu.c                               |  28 ++++--
 virt/kvm/kvm_main.c                            |   5 +-
 214 files changed, 1619 insertions(+), 876 deletions(-)
