Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974AbaH1HNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 03:13:20 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:52953 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523AbaH1HNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 03:13:18 -0400
Message-ID: <53FED689.7050901@suse.cz>
Date: Thu, 28 Aug 2014 09:13:13 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
CC: lwn@lwn.net
Subject: Linux 3.12.27
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm announcing the release of the 3.12.27 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

- ----------------------------------------------------------------
Akeem G Abodunrin (1):
      igb: Fixed Wake On LAN support

Ales Novak (1):
      drivers/rtc/interface.c: fix infinite loop in initializing the alarm

Alexandre Bounine (1):
      rapidio/tsi721_dma: fix failure to obtain transaction descriptor

Andrey Ryabinin (1):
      net: sendmsg: fix NULL pointer dereference

Andrey Utkin (1):
      arch/sparc/math-emu/math_32.c: drop stray break operator

Andy Lutomirski (1):
      x86_64/entry/xen: Do not invoke espfix64 on Xen

Anssi Hannula (1):
      dm cache: fix race affecting dirty block count

Benjamin Tisssoires (1):
      HID: logitech-dj: Fix USB 3.0 issue

Boris Ostrovsky (1):
      x86/espfix/xen: Fix allocation of pages for paravirt page tables

Carolyn Wyborny (1):
      igb: Fix master/slave mode for all m88 i354 PHY's

Cedric Le Goater (1):
      offb: Little endian fixes

Christoph Paasch (2):
      tcp: Fix integer-overflows in TCP veno
      tcp: Fix integer-overflow in TCP vegas

Christopher Alexander Tobias Schulze (2):
      bbc-i2c: Fix BBC I2C envctrl on SunBlade 2000
      sunsab: Fix detection of BREAK on sunsab serial console

Dan Carpenter (2):
      igbvf: integer wrapping bug setting the mtu
      RDMA/cxgb3: Fix information leak in send_abort()

Daniel Borkmann (1):
      net: sctp: inherit auth_capable on INIT collisions

David Ertman (1):
      e1000e: Fix a compile flag mis-match for suspend/resume

David Gibson (1):
      netxen: Correct off-by-one errors in bounds checks

David Rientjes (1):
      mm, thp: do not allow thp faults to avoid cpuset restrictions

David S. Miller (9):
      sparc64: Fix argument sign extension for compat_sys_futex().
      sparc64: Handle 32-bit tasks properly in
compute_effective_address().
      sparc64: Fix top-level fault handling bugs.
      sparc64: Give more detailed information in {pgd,pmd}_ERROR() and
kill pte_ERROR().
      sparc64: Don't bark so loudly about 32-bit tasks generating
64-bit fault addresses.
      sparc64: Fix huge TSB mapping on pre-UltraSPARC-III cpus.
      sparc64: Add membar to Niagara2 memcpy code.
      sparc64: Do not insert non-valid PTEs into the TSB hash table.
      sparc64: Guard against flushing openfirmware mappings.

Dmitry Kravkov (1):
      bnx2x: fix crash during TSO tunneling

Don Skidmore (1):
      ixgbevf: cleanup redundant mailbox read failure check

Eliad Peller (2):
      cfg80211: fix mic_failure tracing
      mac80211: reset probe_send_count also in HW_CONNECTION_MONITOR case

Emil Tantilov (2):
      ixgbe: fix rx-usecs range checks for BQL
      ixgbe: fix inconsistent clearing of the multicast table

Eric Dumazet (3):
      inetpeer: get rid of ip_id_count
      ip: make IP identifiers less predictable
      sctp: fix possible seqlock seadlock in sctp_packet_transmit()

Eric W. Biederman (3):
      mnt: Only change user settable mount flags in remount
      mnt: Move the test for MNT_LOCK_READONLY from change_mount_flags
into do_remount
      mnt: Correct permission checks in do_remount

Felix Fietkau (1):
      ath9k: fix aggregation session lockup

Fujinaka, Todd (2):
      igb: Add ethtool offline tests for i354
      igb: Don't let ethtool try to write to iNVM in i210/i211

Greg Thelen (1):
      dm bufio: fully initialize shrinker

H. Peter Anvin (6):
      Revert "x86-64, modify_ldt: Make support for 16-bit segments a
runtime option"
      x86-64, espfix: Don't leak bits 31:16 of %esp returning to
16-bit stack
      x86, espfix: Move espfix definitions into a separate header file
      x86, espfix: Fix broken header guard
      x86, espfix: Make espfix64 a Kconfig option, fix UML
      x86, espfix: Make it possible to disable 16-bit support

Hong Zhiguo (1):
      e1000: fix wrong queue idx calculation

Ilan Peer (1):
      iwlwifi: mvm: Add a missed beacons threshold

Jacob Keller (1):
      ixgbe: fix qv_lock_napi call in ixgbe_napi_disable_all

James Bottomley (1):
      scsi: handle flush errors properly

Jan Beulich (1):
      drivers/rtc/rtc-efi.c: check for invalid data coming back from UEFI

Jan Kara (2):
      timer: Fix lock inversion between hrtimer_bases.lock and
scheduler locks
      ext4: Fix block zeroing when punching holes in indirect block files

Jiri Kosina (1):
      Input: i8042 - add Acer Aspire 5710 to nomux blacklist

Jiri Slaby (1):
      Linux 3.12.27

Johannes Berg (1):
      Revert "mac80211: move "bufferable MMPDU" check to fix AP mode scan"

John Stultz (1):
      printk: rename printk_sched to printk_deferred

Keith Packard (1):
      fbcon: Clean up fbcon data in fb_info on FB_EVENT_FB_UNBIND with
0 fbs

Kirill Tkhai (1):
      sparc64: Make itc_sync_lock raw

Konstantin Khlebnikov (1):
      ARM: 8115/1: LPAE: reduce damage caused by idmap to virtual
memory layout

Lars-Peter Clausen (1):
      iio: buffer: Fix demux table creation

Laurent Dufour (1):
      PCI: rphahp: Fix endianess issues

Lee, Chun-Yi (1):
      drivers/rtc/rtc-efi.c: avoid subtracting day twice when
computing year days

Malcolm Priestley (2):
      staging: vt6655: Fix disassociated messages every 10 seconds
      staging: vt6655: Fix Warning on boot handle_irq_event_percpu.

Martin Schwidefsky (1):
      s390/ptrace: fix PSW mask check

Maurizio Lombardi (1):
      bnx2fc: fix memory leak in bnx2fc_allocate_hash_table()

Max Filippov (1):
      xtensa: add fixup for double exception raised in window overflow

Maxim Patlasov (1):
      mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()

Michal Hocko (1):
      memcg: oom_notify use-after-free fix

Mika Westerberg (1):
      e1000e: Fix compilation warning when !CONFIG_PM_SLEEP

Milan Broz (1):
      crypto: af_alg - properly label AF_ALG socket

Minfei Huang (1):
      lib/btree.c: fix leak of whole btree nodes

Naoya Horiguchi (2):
      hugetlb: fix copy_hugetlb_page_range() to handle
migration/hwpoisoned entry
      mm: hugetlb: fix copy_hugetlb_page_range()

Nithin Sujir (1):
      tg3: Add support for new 577xx device ids

Peter Meerwald (2):
      iio:bma180: Fix scale factors to report correct acceleration units
      iio:bma180: Missing check for frequency fractional part

Russell King (7):
      DMA-API: provide a helper to set both DMA and coherent DMA masks
      DMA-API: net: intel/e1000e: fix 32-bit DMA mask handling
      DMA-API: net: intel/ixgbe: fix 32-bit DMA mask handling
      DMA-API: net: intel/ixgbevf: fix 32-bit DMA mask handling
      DMA-API: net: intel/igb: fix 32-bit DMA mask handling
      DMA-API: net: intel/igbvf: fix 32-bit DMA mask handling
      DMA-API: net: brocade/bna/bnad.c: fix 32-bit DMA mask handling

Sasha Levin (2):
      net/l2tp: don't fall back on UDP [get|set]sockopt
      iovec: make sure the caller actually wants anything in
memcpy_fromiovecend

Sowmini Varadhan (1):
      sparc64: ldc_connect() should not return EINVAL when handshake
is in progress.

Stefan Assmann (1):
      igb: fix driver reload with VF assigned to guest

Vitaliy Kulikov (1):
      ALSA: hda - load EQ params into IDT codec on HP bNB13 systems

Vlad Yasevich (2):
      macvlan: Initialize vlan_features to turn on offload support.
      net: Correctly set segment mac_len in skb_segment().

Vladimir Davydov (1):
      e1000: fix possible reset_task running after adapter down

Wei Yongjun (1):
      igbvf: add missing iounmap() on error in igbvf_probe()

Ying Xue (1):
      tipc: don't use memcpy to copy from user space

Yuval Mintz (1):
      bnx2x: Test nvram when interface is down

yzhu1 (1):
      e1000: prevent oops when adapter is being closed and reset
simultaneously

 Documentation/DMA-API-HOWTO.txt              |  37 +-
 Documentation/DMA-API.txt                    |   8 +
 Documentation/x86/x86_64/mm.txt              |   2 +
 Makefile                                     |   2 +-
 arch/arm/mm/idmap.c                          |   7 +
 arch/s390/kernel/ptrace.c                    |   9 +-
 arch/sparc/include/asm/pgtable_64.h          |  15 +-
 arch/sparc/include/asm/tlbflush_64.h         |  12 +-
 arch/sparc/kernel/ldc.c                      |   2 +-
 arch/sparc/kernel/smp_64.c                   |   6 +-
 arch/sparc/kernel/sys32.S                    |   2 +-
 arch/sparc/kernel/unaligned_64.c             |  12 +-
 arch/sparc/lib/NG2memcpy.S                   |   1 +
 arch/sparc/math-emu/math_32.c                |   2 +-
 arch/sparc/mm/fault_64.c                     |  98 +--
 arch/sparc/mm/init_64.c                      |  27 +
 arch/sparc/mm/tsb.c                          |  14 +-
 arch/x86/Kconfig                             |  25 +-
 arch/x86/include/asm/espfix.h                |  16 +
 arch/x86/include/asm/irqflags.h              |   2 +-
 arch/x86/include/asm/pgtable_64_types.h      |   2 +
 arch/x86/include/asm/setup.h                 |   2 +
 arch/x86/kernel/Makefile                     |   1 +
 arch/x86/kernel/entry_32.S                   |  12 +
 arch/x86/kernel/entry_64.S                   |  77 ++-
 arch/x86/kernel/espfix_64.c                  | 208 +++++++
 arch/x86/kernel/ldt.c                        |  10 +-
 arch/x86/kernel/paravirt_patch_64.c          |   2 -
 arch/x86/kernel/smpboot.c                    |   7 +
 arch/x86/mm/dump_pagetables.c                |  31 +-
 arch/x86/vdso/vdso32-setup.c                 |   8 -
 arch/xtensa/kernel/vectors.S                 | 158 ++++-
 arch/xtensa/kernel/vmlinux.lds.S             |   4 +-
 crypto/af_alg.c                              |   2 +
 drivers/hid/hid-logitech-dj.c                |   8 +
 drivers/iio/accel/bma180.c                   |   8 +-
 drivers/iio/industrialio-buffer.c            |   2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c        |   1 +
 drivers/input/serio/i8042-x86ia64io.h        |   7 +
 drivers/md/dm-bufio.c                        |   2 +-
 drivers/md/dm-cache-target.c                 |  13 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h  |   1 +
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c  |   9 +
 .../ethernet/broadcom/bnx2x/bnx2x_ethtool.c  |  19 +-
 drivers/net/ethernet/broadcom/tg3.c          |  15 +-
 drivers/net/ethernet/broadcom/tg3.h          |   3 +
 drivers/net/ethernet/brocade/bna/bnad.c      |  13 +-
 drivers/net/ethernet/intel/e1000/e1000.h     |   5 +
 .../net/ethernet/intel/e1000/e1000_main.c    |  27 +-
 drivers/net/ethernet/intel/e1000e/netdev.c   |  22 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c   |   8 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c |  17 +-
 drivers/net/ethernet/intel/igb/igb_main.c    |  55 +-
 drivers/net/ethernet/intel/igbvf/netdev.c    |  26 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h     |  48 +-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c |   6 +-
 .../net/ethernet/intel/ixgbe/ixgbe_main.c    |  36 +-
 .../ethernet/intel/ixgbevf/ixgbevf_main.c    |  44 +-
 .../ethernet/qlogic/netxen/netxen_nic_init.c |   4 +-
 drivers/net/macvlan.c                        |   1 +
 drivers/net/ppp/pptp.c                       |   2 +-
 drivers/net/wireless/ath/ath9k/xmit.c        |   9 +
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c  |  25 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |   1 +
 drivers/pci/hotplug/rpaphp_core.c            |  15 +-
 drivers/rapidio/devices/tsi721_dma.c         |   8 +-
 drivers/rtc/interface.c                      |  14 +-
 drivers/rtc/rtc-efi.c                        |  34 +-
 drivers/sbus/char/bbc_envctrl.c              |   6 +
 drivers/sbus/char/bbc_i2c.c                  |  11 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c             |  31 +-
 drivers/scsi/scsi_lib.c                      |   8 +
 drivers/staging/vt6655/bssdb.c               |   2 +-
 drivers/staging/vt6655/device_main.c         |   7 +-
 drivers/tty/serial/sunsab.c                  |   9 +
 drivers/video/console/fbcon.c                |  27 +-
 drivers/video/offb.c                         |  18 +-
 fs/ext4/indirect.c                           |   4 +-
 fs/namespace.c                               |  51 +-
 include/linux/dma-mapping.h                  |  14 +
 include/linux/mount.h                        |   9 +-
 include/linux/printk.h                       |   6 +-
 include/net/inetpeer.h                       |  16 +-
 include/net/ip.h                             |  31 +-
 include/net/ipv6.h                           |  11 +-
 include/net/mac80211.h                       |   2 -
 include/net/secure_seq.h                     |   2 -
 init/main.c                                  |   4 +
 kernel/printk/printk.c                       |   2 +-
 kernel/sched/core.c                          |   2 +-
 kernel/sched/rt.c                            |   2 +-
 kernel/time/clockevents.c                    |  10 +-
 lib/btree.c                                  |   1 +
 mm/hugetlb.c                                 |  70 ++-
 mm/memcontrol.c                              |   4 +
 mm/page-writeback.c                          |   6 +-
 mm/page_alloc.c                              |  16 +-
 net/compat.c                                 |   9 +-
 net/core/iovec.c                             |  10 +-
 net/core/secure_seq.c                        |  25 -
 net/core/skbuff.c                            |   2 +-
 net/ipv4/igmp.c                              |   4 +-
 net/ipv4/inetpeer.c                          |  18 -
 net/ipv4/ip_output.c                         |   7 +-
 net/ipv4/ip_tunnel_core.c                    |   2 +-
 net/ipv4/ipmr.c                              |   2 +-
 net/ipv4/raw.c                               |   2 +-
 net/ipv4/route.c                             |  69 ++-
 net/ipv4/tcp_vegas.c                         |   3 +-
 net/ipv4/tcp_veno.c                          |   2 +-
 net/ipv4/xfrm4_mode_tunnel.c                 |   2 +-
 net/ipv6/ip6_output.c                        |  17 +
 net/ipv6/output_core.c                       |  23 -
 net/l2tp/l2tp_ppp.c                          |   4 +-
 net/mac80211/mlme.c                          |   4 +-
 net/mac80211/tx.c                            |  27 +-
 net/netfilter/ipvs/ip_vs_xmit.c              |   2 +-
 net/sctp/associola.c                         |   1 +
 net/sctp/output.c                            |   2 +-
 net/tipc/msg.c                               |  22 +-
 net/wireless/trace.h                         |   3 +-
 sound/pci/hda/patch_sigmatel.c               | 532 ++++++++++++++++-
 122 files changed, 1875 insertions(+), 632 deletions(-)
 create mode 100644 arch/x86/include/asm/espfix.h
 create mode 100644 arch/x86/kernel/espfix_64.c


thanks,
- -- 
js
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/taJAAoJEL0lsQQGtHBJemUP/3Ue2pEpy9H2jLD6SgxmW/h9
gAIQEUpmX8Qv8cvckymJTsAFe4GPjXPG9GFALRXUZkHb3eOMC1LzvdWMnvi4poJo
CecMPIgUjD81+EFspVFc6hEQfMkA1zs0Bpyhw0JelCTnLUxXLASTn7K54zGuiotO
P+CGysSV9kxDFwqo9JYbLpbOgzVsqZzeVnIZN2OtUmgZQeWSIFkjUhlKP3qfhqEa
dl7JpMiBNB6PejE7MZr3nJWDTE+LEA1ban/LmaO7ZkdFsC9Ki0Omi8QHV/VuOImF
7l+wSOIS4wphHidgOM1DGbFlKHoMEMSja8/O8E3Ls96l5VldHrZ9WzY+JYDVB5Yl
jI37w3mczIuOrCXL6JsemZ+3lFdoJmBISE/SaqPwEXml2/iC2YZerv2f8tSlXr5e
c+lHC7EQryy9IRQeDrgajP19ZwICtSpSlwGfoSamKTHqbNz0yLRV8TubM9eT3RcP
WV29ZzQwvnlzfhcv//aOXd8A5gOxMqhQ1GsjhbPNRdSPRM/yGBk7ClQw5zvpEjph
RYRCRUVoL4CBSxUBNDZSY8REV9691QR6p6hBIo1DVZJLeZ1PbIc6GW0j0liDgWub
kFxENbpNg+xb2sZx0FXTHyPA3sV5sO/Sb0XzEEmqkGiudtNUdY6sFuxjFD2KON4K
YrSyi5O++6AaXOP1+G1c
=ZU5F
-----END PGP SIGNATURE-----
