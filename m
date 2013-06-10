Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3FJKeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:34:12 -0400
Received: from 1wt.eu ([62.212.114.60]:36225 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab3FJKeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:34:08 -0400
Date: Mon, 10 Jun 2013 12:15:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Linux 2.6.32.61
Message-ID: <20130610101557.GA3235@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.6.32.61.

This version include backports from the 3.0.y branch up to and including
3.0.80. The following CVE IDs were fixed since 2.6.32.60 :

    CVE-2011-2695 CVE-2011-2699 CVE-2012-2390 CVE-2012-3430 CVE-2012-3552
    CVE-2012-4398 CVE-2012-4444 CVE-2012-4461 CVE-2012-4508 CVE-2012-4530
    CVE-2012-4565 CVE-2012-6537 CVE-2012-6539 CVE-2012-6540 CVE-2012-6542
    CVE-2012-6544 CVE-2012-6545 CVE-2012-6546 CVE-2012-6548 CVE-2012-6549
    CVE-2013-0228 CVE-2013-0268 CVE-2013-0349 CVE-2013-0871 CVE-2013-0914
    CVE-2013-1767 CVE-2013-1773 CVE-2013-1774 CVE-2013-1792 CVE-2013-1796
    CVE-2013-1798 CVE-2013-1826 CVE-2013-1860 CVE-2013-1928 CVE-2013-2015
    CVE-2013-2634 CVE-2013-3222 CVE-2013-3223 CVE-2013-3224 CVE-2013-3225
    CVE-2013-3228 CVE-2013-3229 CVE-2013-3231 CVE-2013-3234 CVE-2013-3235

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.61.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.61.xz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.61.gz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/ChangeLog-2.6.32.61

The updated 2.6.32.y git tree can be found at:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
  http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y

The tree can be browsed on the gitweb interface:
  http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/?id=refs/heads/linux-2.6.32.y

  Testing status (build/boot, OK/FAIL, otherwise not tested) :

         ARCH  |         CONFIGURATION
       --------+-----------------------------------
               |  allmodconfig     other-config
        x86_64 |    build:OK            -
          i386 |    build:OK            -
           arm |    build:OK            -

Thanks to all reviewers, Moritz for the long list of security fixes, Ben for
the careful review and to Greg for the final packaging.

Willy

---------
 Makefile                                       |   2 +-
 arch/alpha/kernel/sys_nautilus.c               |   5 +
 arch/arm/include/asm/signal.h                  |   1 +
 arch/avr32/include/asm/signal.h                |   1 +
 arch/cris/include/asm/signal.h                 |   1 +
 arch/h8300/include/asm/signal.h                |   1 +
 arch/m32r/include/asm/signal.h                 |   1 +
 arch/m68k/include/asm/signal.h                 |   1 +
 arch/mips/Makefile                             |   2 +-
 arch/mips/kernel/Makefile                      |   2 +-
 arch/mn10300/include/asm/signal.h              |   1 +
 arch/parisc/kernel/signal32.c                  |   6 +-
 arch/powerpc/include/asm/signal.h              |   1 +
 arch/s390/include/asm/signal.h                 |   1 +
 arch/sparc/include/asm/signal.h                |   1 +
 arch/x86/Kconfig                               |   2 +-
 arch/x86/include/asm/pgtable.h                 |   5 +
 arch/x86/include/asm/ptrace.h                  |   5 +-
 arch/x86/include/asm/signal.h                  |   2 +
 arch/x86/kernel/apic/io_apic.c                 |   9 +-
 arch/x86/kernel/cpu/mcheck/mce.c               |   9 +-
 arch/x86/kernel/efi.c                          |   3 -
 arch/x86/kernel/msr.c                          |   3 +
 arch/x86/kvm/x86.c                             |   9 +
 arch/x86/mm/fault.c                            |   6 +-
 arch/x86/mm/init_64.c                          |   3 +
 arch/x86/xen/enlighten.c                       |  18 +-
 arch/x86/xen/xen-asm_32.S                      |  14 +-
 arch/xtensa/include/asm/signal.h               |   1 +
 block/blk-core.c                               |  14 +-
 block/blk-exec.c                               |   7 +
 block/scsi_ioctl.c                             |   5 +-
 crypto/cryptd.c                                |  11 +-
 drivers/acpi/processor_idle.c                  |   3 +
 drivers/ata/libata-scsi.c                      |   6 +-
 drivers/base/bus.c                             |   4 +-
 drivers/char/ipmi/ipmi_bt_sm.c                 |   4 +-
 drivers/firmware/pcdp.c                        |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  19 +-
 drivers/isdn/isdnloop/isdnloop.c               |  12 -
 drivers/net/bonding/bonding.h                  |   4 +-
 drivers/net/r8169.c                            |  30 +--
 drivers/net/tg3.c                              |   4 +
 drivers/net/wireless/b43legacy/main.c          |   2 +
 drivers/scsi/bnx2i/bnx2i_hwi.c                 |   3 +
 drivers/scsi/mpt2sas/mpt2sas_ctl.c             |   7 +-
 drivers/scsi/scsi_lib.c                        |   2 +
 drivers/serial/8250.c                          |   2 +-
 drivers/staging/comedi/comedi_fops.c           |  13 +-
 drivers/staging/comedi/drivers/comedi_test.c   |   2 +-
 drivers/staging/comedi/drivers/das08.c         |   2 +-
 drivers/staging/comedi/drivers/jr3_pci.c       |   2 +-
 drivers/staging/comedi/drivers/ni_labpc.c      |  35 +--
 drivers/staging/comedi/drivers/s626.c          |   2 +-
 drivers/staging/vt6656/rf.c                    |   3 +
 drivers/telephony/ixj.c                        |  24 +-
 drivers/usb/class/cdc-wdm.c                    |  23 +-
 drivers/usb/host/ehci-hcd.c                    |   8 +-
 drivers/usb/host/ehci-q.c                      |  82 +++---
 drivers/usb/host/ehci.h                        |   3 +-
 drivers/usb/host/pci-quirks.c                  |  12 +-
 drivers/usb/serial/ftdi_sio.c                  |   4 +
 drivers/usb/serial/garmin_gps.c                |   7 +-
 drivers/usb/serial/io_ti.c                     |   3 +
 drivers/usb/serial/mos7840.c                   |   2 +-
 drivers/usb/serial/sierra.c                    |   1 +
 drivers/usb/serial/whiteheat.c                 |   1 +
 drivers/w1/w1.c                                |   3 +-
 fs/binfmt_elf.c                                |  19 +-
 fs/binfmt_em86.c                               |   1 -
 fs/binfmt_misc.c                               |  11 +-
 fs/binfmt_script.c                             |   8 +-
 fs/btrfs/volumes.c                             |   6 +
 fs/cifs/cifs_dfs_ref.c                         |   2 +
 fs/compat_ioctl.c                              |   3 +
 fs/eventpoll.c                                 |  22 +-
 fs/exec.c                                      |  25 +-
 fs/ext4/acl.c                                  |   6 +-
 fs/ext4/ext4_extents.h                         |   7 +-
 fs/ext4/extents.c                              | 106 ++++++--
 fs/ext4/inode.c                                |   8 +-
 fs/ext4/mballoc.c                              |  12 +-
 fs/ext4/move_extent.c                          |  17 +-
 fs/ext4/namei.c                                |  26 +-
 fs/ext4/super.c                                |  17 +-
 fs/fat/inode.c                                 |   2 +-
 fs/fat/namei_vfat.c                            |   9 +-
 fs/fscache/stats.c                             |   2 +-
 fs/hfsplus/extents.c                           |   2 +-
 fs/isofs/export.c                              |   1 +
 fs/jbd/commit.c                                |  43 +++-
 fs/jbd/transaction.c                           |  99 ++++++--
 fs/nfsd/nfs4xdr.c                              |  11 +-
 fs/nls/nls_base.c                              |  43 +++-
 fs/splice.c                                    |   7 +-
 fs/sysfs/dir.c                                 |  16 +-
 fs/udf/inode.c                                 |   4 +
 fs/udf/namei.c                                 |   1 +
 fs/udf/udf_sb.h                                |   2 +-
 include/asm-generic/signal.h                   |   4 +
 include/linux/binfmts.h                        |   3 +-
 include/linux/blkdev.h                         |   4 +-
 include/linux/kmod.h                           |   2 +
 include/linux/mempolicy.h                      |   2 +-
 include/linux/msdos_fs.h                       |   3 +-
 include/linux/nls.h                            |   5 +-
 include/linux/page-flags.h                     |   8 +-
 include/linux/sched.h                          |  11 +-
 include/linux/socket.h                         |   2 +-
 include/net/inet_sock.h                        |  14 +-
 include/net/ip.h                               |  11 +-
 include/net/ipv6.h                             |  12 +-
 include/net/transp_v6.h                        |   2 +
 include/scsi/scsi.h                            |   8 +-
 include/scsi/scsi_netlink.h                    |   4 +-
 include/trace/events/kmem.h                    |   4 +-
 kernel/async.c                                 |  13 +-
 kernel/cgroup.c                                |   2 -
 kernel/kmod.c                                  |  89 ++++++-
 kernel/posix-cpu-timers.c                      |  23 +-
 kernel/ptrace.c                                |  71 ++++--
 kernel/resource.c                              |  50 +++-
 kernel/sched.c                                 |   3 +-
 kernel/signal.c                                |  21 +-
 kernel/softirq.c                               |  17 +-
 kernel/sys.c                                   |   1 +
 kernel/time/tick-broadcast.c                   |   3 +-
 kernel/time/tick-sched.c                       |   2 +-
 kernel/time/timekeeping.c                      |   3 +-
 kernel/timer.c                                 |   2 +-
 kernel/trace/ftrace.c                          |   1 -
 kernel/trace/ring_buffer.c                     |   2 +
 lib/genalloc.c                                 |   2 +-
 mm/hugetlb.c                                   |  29 ++-
 mm/mempolicy.c                                 |  37 ++-
 mm/shmem.c                                     |  10 +-
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
 net/bridge/br_stp_bpdu.c                       |   2 +
 net/core/dev.c                                 |   9 +-
 net/core/sock.c                                |   3 +-
 net/dcb/dcbnl.c                                |   1 +
 net/dccp/ipv4.c                                |  15 +-
 net/dccp/ipv6.c                                |   2 +-
 net/ipv4/af_inet.c                             |  16 +-
 net/ipv4/cipso_ipv4.c                          | 113 +++++----
 net/ipv4/icmp.c                                |  23 +-
 net/ipv4/inet_connection_sock.c                |   8 +-
 net/ipv4/ip_options.c                          |  38 ++-
 net/ipv4/ip_output.c                           |  50 ++--
 net/ipv4/ip_sockglue.c                         |  35 ++-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   8 +
 net/ipv4/raw.c                                 |  19 +-
 net/ipv4/route.c                               |  17 +-
 net/ipv4/syncookies.c                          |   4 +-
 net/ipv4/tcp.c                                 |   2 +-
 net/ipv4/tcp_illinois.c                        |   8 +-
 net/ipv4/tcp_ipv4.c                            |  33 +--
 net/ipv4/tcp_output.c                          |   7 +-
 net/ipv4/udp.c                                 |  21 +-
 net/ipv6/af_inet6.c                            |   2 +
 net/ipv6/ip6_output.c                          |  40 ++-
 net/ipv6/reassembly.c                          |  74 ++----
 net/ipv6/tcp_ipv6.c                            |   2 +-
 net/ipv6/udp.c                                 |   2 +-
 net/irda/af_irda.c                             |   2 +
 net/iucv/af_iucv.c                             |   2 +
 net/llc/af_llc.c                               |   5 +-
 net/netfilter/ipvs/ip_vs_ctl.c                 |   1 +
 net/netfilter/ipvs/ip_vs_xmit.c                |  33 ++-
 net/packet/af_packet.c                         |   1 -
 net/rds/recv.c                                 |   3 +
 net/rose/af_rose.c                             |   1 +
 net/sched/act_gact.c                           |  14 +-
 net/sched/sch_htb.c                            |   2 +-
 net/sctp/auth.c                                |   2 +-
 net/sctp/chunk.c                               |   7 +-
 net/sctp/endpointola.c                         |   5 +
 net/sctp/socket.c                              |   2 +-
 net/socket.c                                   |   6 +-
 net/sunrpc/rpc_pipe.c                          |   2 +-
 net/tipc/socket.c                              |   7 +
 net/unix/af_unix.c                             |   7 +-
 net/xfrm/xfrm_user.c                           |  15 +-
 scripts/Kbuild.include                         |  12 +-
 scripts/gcc-version.sh                         |   6 +-
 scripts/gcc-x86_32-has-stack-protector.sh      |   2 +-
 scripts/gcc-x86_64-has-stack-protector.sh      |   2 +-
 scripts/kconfig/check.sh                       |   2 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh     |   2 +-
 security/keys/process_keys.c                   |   2 +-
 sound/core/seq/seq_timer.c                     |   8 +-
 sound/pci/ac97/ac97_codec.c                    |   2 +
 sound/pci/hda/patch_realtek.c                  | 329 +++++++++++++++++++++++--
 usr/gen_init_cpio.c                            |  43 ++--
 virt/kvm/ioapic.c                              |   7 +-
 205 files changed, 1800 insertions(+), 819 deletions(-)

Summary of changes from 2.6.32.60 to 2.6.32.61
==============================================
Al Viro (1):
      PARISC: fix user-triggerable panic on parisc

Alan Cox (1):
      x86/msr: Add capabilities check

Alan Stern (2):
      USB: EHCI: go back to using the system clock for QH unlinks
      NLS: improve UTF8 -> UTF16 string conversion routine

Alexey Khoroshilov (1):
      net/core: Fix potential memory leak in dev_set_alias()

Allison Henderson (1):
      ext4: don't dereference null pointer when make_indexed_dir() fails

Anatol Pomozov (1):
      ext4: make orphan functions be no-op in no-journal mode

Anderson Lizardo (1):
      Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()

Andi Kleen (1):
      MCE: Fix vm86 handling for 32bit mce handler

Andrew Morton (1):
      kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER

Andrew Worsley (1):
      USB: serial: ftdi_sio: Handle the old_termios == 0 case e.g. uart_resume_port()

Andy Honig (2):
      KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME (CVE-2013-1796)
      KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)

Anurup m (1):
      fs/fscache/stats.c: fix memory leak

Ben Hutchings (2):
      Revert "pcdp: use early_ioremap/early_iounmap to access pcdp table"
      signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_restorer

Benjamin LaHaise (1):
      ipv4: check rt_genid in dst_check

Bernd Schubert (1):
      ext4: always set i_op in ext4_mknod()

Bjorn Helgaas (1):
      Driver core: treat unregistered bus_types as having no devices

Chen Gang (1):
      drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory overflow

Christoffer Dall (1):
      mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED

Cong Ding (1):
      fs/cifs/cifs_dfs_ref.c: fix potential memory leakage

Cong Wang (1):
      net: prevent setting ttl=0 via IP_TTL

Dan Carpenter (1):
      telephony: ijx: buffer overflow in ixj_write_cid()

Daniel Borkmann (3):
      net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
      net: sctp: sctp_endpoint_free: zero out secret key data
      net: sctp: sctp_auth_key_put: use kzfree instead of kfree

Dave Hansen (2):
      hugetlb: fix resv_map leak in error path
      mm: fix vma_resv_map() NULL pointer

David Howells (1):
      keys: fix race with concurrent install_user_keyrings()

Denys Vlasenko (1):
      coredump: prevent double-free on an error path in core dumper

Dmitry Monakhov (1):
      ext4: online defrag is not supported for journaled files

Eddie Wai (1):
      SCSI: bnx2i: Fixed NULL ptr deference for 1G bnx2 Linux iSCSI offload

Emese Revfy (1):
      kernel/signal.c: stop info leak via the tkill and the tgkill syscalls

Eric Dumazet (8):
      net: reduce net_rx_action() latency to 2 HZ
      softirq: reduce latencies
      net: guard tcp_set_keepalive() to tcp sockets
      inet: add RCU protection to inet->opt
      tcp: allow splice() to build full TSO packets
      tcp: fix MSG_SENDPAGE_NOTLAST logic
      tcp: preserve ACK clocking in TSO
      ipv6: make fragment identifications less predictable

Eric Sandeen (1):
      btrfs: use rcu_barrier() to wait for bdev puts at unmount

Eric Wong (1):
      epoll: prevent missed events on EPOLL_CTL_MOD

Eugene Shatokhin (1):
      ext4: fix memory leak in ext4_xattr_set_acl()'s error path

Francois Romieu (1):
      r8169: incorrect identifier for a 8168dp

Geert Uytterhoeven (1):
      sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()

Greg Thelen (1):
      tmpfs: fix use-after-free of mempolicy object

Hayes Wang (1):
      r8169: correct settings of rtl8102e.

Hillf Danton (1):
      bonding: Fix slave selection bug.

Hiroaki SHIMODA (1):
      net_sched: gact: Fix potential panic in tcf_gact().

Hugh Dickins (1):
      mm: fix invalidate_complete_page2() lock ordering

Ian Abbott (9):
      staging: comedi: ni_labpc: correct differential channel sequence for AI commands
      staging: comedi: ni_labpc: set up command4 register *after* command3
      staging: comedi: comedi_test: fix race when cancelling command
      staging: comedi: fix memory leak for saved channel list
      staging: comedi: s626: don't dereference insn->data
      staging: comedi: jr3_pci: fix iomem dereference
      staging: comedi: don't dereference user memory for INSN_INTTRIG
      staging: comedi: check s->async for poll(), read() and write()
      staging: comedi: das08: Correct AO output for das08jr-16-ao

J. Bruce Fields (1):
      nfsd4: fix oops on unusual readlike compound

James Bottomley (1):
      fix crash in scsi_dispatch_cmd()

Jamie Iles (1):
      CVE-2012-4508 kernel: ext4: AIO vs fallocate stale data exposure

Jan Beulich (1):
      x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.

Jan Kara (7):
      scsi: Silence unnecessary warnings about ioctl to partition
      jbd: Delay discarding buffers in journal_unmap_buffer
      jbd: Fix assertion failure in commit code due to lacking transaction credits
      jbd: Fix lock ordering bug in journal_unmap_buffer()
      ext4: Fix fs corruption when make_indexed_dir() fails
      ext4: fix fdatasync() for files with only i_size changes
      udf: Fix bitmap overflow on large filesystems with small block size

Jay Estabrook (1):
      alpha: Add irongate_io to PCI bus resources

Jean Delvare (1):
      kbuild: Fix gcc -x syntax

Jens Axboe (1):
      Revert "block: improve queue_should_plug() by looking at IO depths"

Jesper Dangaard Brouer (2):
      net: fix divide by zero in tcp algorithm illinois
      ipvs: IPv6 MTU checking cleanup and bugfix

Jiri Slaby (1):
      serial: 8250, increase PASS_LIMIT

Johan Hovold (4):
      USB: whiteheat: fix memory leak in error path
      USB: mos7840: fix urb leak at release
      USB: mos7840: fix port-device leak in error path
      USB: garmin_gps: fix memory leak on disconnect

John Johansen (1):
      ptrace: Fix ptrace when task is in task_is_stopped() state

John Stultz (1):
      2.6.32.y: timekeeping: Fix nohz issue with commit 61b76840ddee647c0c223365378c3f394355b7d7

Jozsef Kadlecsik (1):
      netfilter: nf_ct_ipv4: packets with wrong ihl are invalid

Jussi Kivilinna (1):
      crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent data corruption

Kailang Yang (1):
      ALSA: hda - More ALC663 fixes and support of compatible chips

Kashyap, Desai (1):
      mpt2sas: Send default descriptor for RAID pass through in mpt2ctl

Kees Cook (5):
      gen_init_cpio: avoid stack overflow when expanding
      exec: do not leave bprm->interp on stack
      exec: use -ELOOP for max recursion depth
      signal: always clear sa_restorer on execve
      fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check

Kevin Dankwardt (1):
      fat: Fix stat->f_namelen

Konrad Rzeszutek Wilk (3):
      xen/bootup: allow read_tscp call for Xen PV guests.
      xen/bootup: allow {read|write}_cr8 pvops call.
      ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled

Lachlan McIlroy (1):
      ext4: limit group search loop for non-extent files

Larry Finger (1):
      b43legacy: Fix crash on unload when firmware not available

Lennart Sorensen (2):
      r8169: Add support for D-Link 530T rev C1 (Kernel Bug 38862)
      USB: serial: Fix memory leak in sierra_release()

Li Zhong (1):
      Fix a dead loop in async_synchronize_full()

Lukas Czerner (1):
      ext4: Fix max file size and logical block counting of extent format file

Malcolm Priestley (1):
      staging: vt6656: [BUG] out of bound array reference in RFbSetPower.

Marcelo Tosatti (1):
      KVM: x86: relax MSR_KVM_SYSTEM_TIME alignment check

Marcin Jurkowski (1):
      w1: fix oops when w1_search is called from netlink connector

Mark Rutland (1):
      clockevents: Don't allow dummy broadcast timers

Mathias Krause (25):
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
      udf: avoid info leak on export
      isofs: avoid info leak on export
      net: fix info leak in compat dev_ifconf()
      dcbnl: fix various netlink info leaks
      ipvs: fix info leak in getsockopt(IP_VS_SO_GET_TIMEOUT)
      atm: update msg_namelen in vcc_recvmsg()
      atm: fix info leak via getsockname()
      atm: fix info leak in getsockopt(SO_ATMPVC)
      ax25: fix info leak via msg_name in ax25_recvmsg()
      iucv: Fix missing msg_namelen update in iucv_sock_recvmsg()
      llc: fix info leak via getsockname()
      llc: Fix missing msg_namelen update in llc_ui_recvmsg()
      rose: fix info leak via msg_name in rose_recvmsg()
      irda: Fix missing msg_namelen update in irda_recvmsg_dgram()
      tipc: fix info leaks via msg_name in recv_msg/recv_stream

Matthew Garrett (2):
      x86: Don't use the EFI reboot method by default
      xhci: Make handover code more robust

Mel Gorman (2):
      mempolicy: fix a race in shared_policy_replace()
      x86/mm: Check if PUD is large when validating a kernel address

Namhyung Kim (1):
      tracing: Fix double free when function profile init failed

Namjae Jeon (1):
      udf: fix memory leak while allocating blocks during write

Nicolas Dichtel (1):
      ipv6: discard overlapping fragment

Nithin Nayak Sujir (1):
      tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mode

Niu Yawei (1):
      ext4: fix race in ext4_mb_add_n_trim()

Oleg Nesterov (9):
      usermodehelper: introduce umh_complete(sub_info)
      usermodehelper: implement UMH_KILLABLE
      usermodehelper: ____call_usermodehelper() doesn't need do_exit()
      kmod: introduce call_modprobe() helper
      kmod: make __request_module() killable
      ptrace: ptrace_resume() shouldn't wake up !TASK_TRACED thread
      ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()
      ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
      wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACED task

Oliver Neukum (1):
      USB: cdc-wdm: fix buffer overflow

Patrick McHardy (1):
      IPoIB: Fix use-after-free of multicast object

Paul Moore (1):
      unix: fix a race condition in unix_release()

Peter Korsgaard (1):
      scsi: use __uX types for headers exported to user space

Petr Matousek (1):
      KVM: x86: invalid opcode oops on SET_SREGS with OSXSAVE bit set (CVE-2012-4461)

Romain Francoise (1):
      x86, random: make ARCH_RANDOM prompt if EMBEDDED, not EXPERT

Samu Kallio (1):
      x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

Shawn Guo (1):
      kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()

Simon Horman (1):
      ipvs: allow transmit of GRO aggregated skbs

Stanislaw Gruszka (1):
      posix-cpu-timers: Fix nanosleep task_struct leak

Stefan Hasko (1):
      net: sched: integer overflow fix

Stephen Hemminger (1):
      bridge: set priority of STP packets

Steven Rostedt (1):
      ring-buffer: Fix race between integrity check and readers

Suresh Siddha (1):
      x86, ioapic: initialize nr_ioapic_registers early in mp_register_ioapic()

T Makphaibulchoke (1):
      kernel/resource.c: fix stack overflow in __reserve_region_with_split()

Takamori Yamaguchi (1):
      mm: bugfix: set current->reclaim_state to NULL while returning from kswapd()

Takashi Iwai (3):
      ALSA: hda - Add a pin-fix for FSC Amilo Pi1505
      ALSA: seq: Fix missing error handling in snd_seq_timer_open()
      ALSA: ac97 - Fix missing NULL check in snd_ac97_cvol_new()

Tejun Heo (1):
      cgroup: remove incorrect dget/dput() pair in cgroup_create_dir()

Thadeu Lima de Souza Cascardo (1):
      genalloc: stop crashing the system when destroying a pool

Theodore Ts'o (2):
      ext4: lock i_mutex when truncating orphan inodes
      ext4: avoid hang when mounting non-journal filesystems with orphan list

Thomas Gleixner (1):
      tick: Cleanup NOHZ per cpu data on cpu down

Timo Teräs (1):
      r8169: remove the obsolete and incorrect AMD workaround

Tirupathi Reddy (1):
      timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

Tommi Rantala (1):
      sctp: fix memory leak in sctp_datamsg_from_user() when copy from user space fails

Trond Myklebust (1):
      kernel panic when mount NFSv4

Vyacheslav Dubeyko (1):
      hfsplus: fix potential overflow in hfsplus_file_truncate()

Weiping Pan (1):
      rds: set correct msg_namelen

Wen Congyang (1):
      tracing: Don't call page_to_pfn() if page is NULL

Willy Tarreau (2):
      x86, ptrace: fix build breakage with gcc 4.7
      Linux 2.6.32.61

Wolfgang Frisch (1):
      USB: io_ti: Fix NULL dereference in chase_port()

Wu Fengguang (1):
      isdnloop: fix and simplify isdnloop_init()

Xiaotian Feng (1):
      libata: fix Null pointer dereference on disk error

Ying Xue (1):
      USB: ftdi_sio: Quiet sparse noise about using plain integer was NULL pointer

danborkmann@iogearbox.net (1):
      af_packet: remove BUG statement in tpacket_destruct_skb

