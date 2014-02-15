Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaBOUCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 15:02:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33821 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541AbaBOUCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 15:02:02 -0500
Message-ID: <1392494516.15615.87.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.55
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Sat, 15 Feb 2014 20:01:56 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-tu/mEWmBmotMkekKPm+D"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tu/mEWmBmotMkekKPm+D
Content-Type: multipart/mixed; boundary="=-uW+sZT0tNevTeLiwC7Gy"


--=-uW+sZT0tNevTeLiwC7Gy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.55 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.54 is attached to this message.

Ben.

------------

 Documentation/kernel-parameters.txt             |  2 +
 Makefile                                        |  2 +-
 arch/arm/kernel/traps.c                         |  8 ++-
 arch/arm/mach-footbridge/dc21285-timer.c        |  9 +--
 arch/ia64/kernel/machine_kexec.c                |  2 +-
 arch/powerpc/include/asm/exception-64s.h        |  2 +-
 arch/sh/lib/Makefile                            |  2 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c        | 53 +++++++++++++---
 arch/x86/kernel/traps.c                         | 13 ++--
 arch/x86/kvm/lapic.c                            | 22 ++++---
 arch/x86/kvm/lapic.h                            |  4 +-
 arch/x86/kvm/x86.c                              | 33 +---------
 drivers/ata/ahci.c                              | 15 +++--
 drivers/ata/libata-core.c                       |  4 ++
 drivers/dma/Kconfig                             |  1 +
 drivers/gpio/gpio-msm-v2.c                      |  4 +-
 drivers/gpu/drm/i915/i915_reg.h                 |  1 +
 drivers/gpu/drm/i915/intel_display.c            |  5 +-
 drivers/gpu/drm/radeon/rs690.c                  | 10 +++
 drivers/gpu/drm/ttm/ttm_bo_vm.c                 |  6 +-
 drivers/hwmon/coretemp.c                        |  2 +-
 drivers/md/raid10.c                             | 12 ++--
 drivers/md/raid5.c                              |  4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 13 ++--
 drivers/net/ethernet/broadcom/tg3.c             |  3 +
 drivers/net/ethernet/ibm/ehea/ehea_main.c       |  2 +-
 drivers/net/ethernet/tehuti/tehuti.c            |  1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c     |  2 +-
 drivers/net/hamradio/hdlcdrv.c                  |  2 +
 drivers/net/hamradio/yam.c                      |  1 +
 drivers/net/usb/dm9601.c                        | 34 +++++++---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c     | 52 ++++++++++++---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   | 25 +++++---
 drivers/net/wireless/ath/ath9k/main.c           |  5 +-
 drivers/net/wireless/rtlwifi/pci.c              |  4 +-
 drivers/pci/pci.c                               | 14 ++---
 drivers/staging/comedi/drivers/cb_pcidio.c      | 21 +++----
 drivers/target/iscsi/iscsi_target.c             | 26 ++++----
 drivers/usb/host/xhci-pci.c                     |  7 ++-
 fs/ceph/mds_client.c                            |  8 ++-
 fs/ext2/super.c                                 |  1 +
 fs/ext4/ext4.h                                  | 10 +++
 fs/ext4/ext4_jbd2.c                             |  4 ++
 fs/ext4/extents.c                               | 43 ++++++++-----
 fs/ext4/mballoc.c                               | 17 +++--
 fs/ext4/super.c                                 |  4 +-
 fs/hpfs/file.c                                  |  5 +-
 fs/nilfs2/segment.c                             | 10 +--
 fs/xfs/xfs_log.c                                |  3 +-
 include/drm/drm_pciids.h                        |  2 +-
 include/linux/hugetlb.h                         |  6 ++
 include/linux/netdevice.h                       |  9 +++
 include/linux/pci.h                             | 14 +++++
 include/linux/sched.h                           |  1 +
 kernel/sched.c                                  | 13 ++--
 kernel/sched_fair.c                             |  3 +
 kernel/sched_rt.c                               | 49 +++++++++++++--
 kernel/trace/ftrace.c                           |  2 +-
 mm/hugetlb.c                                    | 17 +++++
 mm/memory-failure.c                             | 16 +++--
 mm/mmap.c                                       | 15 ++---
 mm/swap.c                                       | 84 +++++++++++++++++++++=
++--
 net/8021q/vlan_dev.c                            | 18 +++++-
 net/bridge/br_multicast.c                       |  4 +-
 net/core/drop_monitor.c                         |  1 -
 net/ipv4/inet_diag.c                            | 20 +++++-
 net/ipv4/ipmr.c                                 |  7 ++-
 net/ipv6/ip6mr.c                                |  7 ++-
 net/ipv6/route.c                                |  8 +--
 net/llc/af_llc.c                                |  5 +-
 net/rds/ib.c                                    |  3 +-
 net/rds/ib_send.c                               |  5 +-
 net/rose/af_rose.c                              | 16 ++---
 net/unix/af_unix.c                              |  8 ++-
 net/wireless/radiotap.c                         |  4 ++
 security/selinux/hooks.c                        | 28 +++++++--
 security/selinux/include/objsec.h               |  5 +-
 sound/core/pcm_lib.c                            |  2 +
 sound/pci/hda/hda_intel.c                       |  4 ++
 sound/soc/codecs/wm8904.c                       |  2 +-
 tools/power/cpupower/utils/cpupower-set.c       |  6 +-
 81 files changed, 653 insertions(+), 264 deletions(-)

Akira Takeuchi (1):
      mm: ensure get_unmapped_area() returns higher address than mmap_min_a=
ddr

Al Viro (1):
      ext4: fix del_timer() misuse for ->s_err_report

Alex Deucher (2):
      drm/radeon: Fix sideport problems on certain RS690 boards
      drm/radeon: 0x9649 is SUMO2 not SUMO

Andrea Arcangeli (1):
      mm: hugetlbfs: fix hugetlbfs optimization

Andreas Rohner (1):
      nilfs2: fix segctor bug that causes file system corruption

Andy Honig (1):
      KVM: x86: Convert vapic synchronization to _cached functions (CVE-201=
3-6368)

Ben Hutchings (2):
      pci: Add PCI_DEVICE_SUB() macro
      Linux 3.2.55

Bo Shen (1):
      ASoC: wm8904: fix DSP mode B configuration

Chad Hanson (1):
      selinux: fix broken peer recv check

Changli Gao (1):
      net: drop_monitor: fix the value of maxattr

Chris Wilson (1):
      drm/i915: Use the correct GMCH_CTRL register for Sandybridge+

Colin Cross (1):
      sched/rt: Fix SCHED_RR across cgroups

Curt Brune (1):
      bridge: use spin_lock_bh() in br_multicast_set_hash_max

Dan Williams (1):
      net_dma: mark broken

Daniel Borkmann (2):
      net: inet_diag: zero out uninitialized idiag_{src,dst} fields
      net: llc: fix use after free in llc_ui_recvmsg

Dave Chinner (1):
      xfs: Account log unmount transaction correctly

David Henningsson (1):
      ALSA: hda - Add enable_msi=3D0 workaround for four HP machines

David S. Miller (1):
      vlan: Fix header ops passthru when doing TX VLAN offload.

Eric Dumazet (1):
      net: do not pretend FRAGLIST support

Eryu Guan (1):
      ext4: check for overlapping extents in ext4_valid_extent_entries()

Florian Westphal (1):
      net: rose: restore old recvmsg behavior

Geert Uytterhoeven (1):
      sh: always link in helper functions extracted from libgcc

George Spelvin (1):
      ahci: add an observed PCI ID for Marvell 88se9172 SATA controller

Hannes Frederic Sowa (2):
      ipv6: don't count addrconf generated routes against gc limit
      net: avoid reference counter overflows on fib_rules in multicast forw=
arding

Ian Abbott (1):
      staging: comedi: cb_pcidio: fix for newer PCI-DIO48H

Jan Kara (1):
      ext2: Fix oops in ext2_get_block() called from ext2_quota_write()

Jean Delvare (1):
      hwmon: (coretemp) Fix truncated name of alarm attributes

Jianguo Wu (1):
      mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate su=
ccessfully

Johannes Berg (1):
      radiotap: fix bitmap-end-finding buffer overrun

JongHo Kim (1):
      ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function

Josh Boyer (1):
      cpupower: Fix segfault due to incorrect getopt_long arugments

Junho Ryu (1):
      ext4: fix use-after-free in ext4_mb_new_blocks

Khalid Aziz (1):
      mm: fix aio performance regression for database caused by THP

Kirill Tkhai (1):
      sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entitie=
s

Larry Finger (1):
      rtlwifi: pci: Fix oops on driver unload

Linus Torvalds (1):
      x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround

Mathy Vanhoef (1):
      ath9k_htc: properly set MAC address and BSSID mask

Miao Xie (1):
      ftrace: Initialize the ftrace profiler for each possible cpu

Michael Neuling (1):
      powerpc: Fix bad stack check in exception entry

Michal Schmidt (1):
      bnx2x: fix DMA unmapping of TSO split BDs

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus Sp=
inPoint M8

Mike Galbraith (1):
      sched,rt: fix isolated CPUs leaving root_task_group indefinitely thro=
ttled

Mikulas Patocka (1):
      hpfs: fix warnings when the filesystem fills up

Myron Stowe (1):
      ahci: Use PCI_VENDOR_ID_MARVELL_EXT for 0x1b4b

Nat Gurumoorthy (1):
      tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0

Neal Cardwell (1):
      inet_diag: fix inet_diag_dump_icsk() timewait socket state logic

NeilBrown (3):
      md/raid5: Fix possible confusion when multiple write errors occur.
      md/raid10: fix two bugs in handling of known-bad-blocks.
      md/raid10: fix bug when raid10 recovery fails to recover a block.

Nicholas Bellinger (1):
      iscsi-target: Fix-up all zero data-length CDBs with R/W_BIT set

Oleg Nesterov (1):
      selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()

Paul Gortmaker (1):
      Fix warning from machine_kexec.c

Peter Boonstoppel (1):
      sched: Unthrottle rt runqueues in __disable_runtime()

Peter Korsgaard (2):
      dm9601: fix reception of full size ethernet frames on dm9620/dm9621a
      dm9601: work around tx fifo sync issue on dm962x

Robert Richter (1):
      perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

Robin H. Johnson (1):
      libata: disable a disk via libata.force params

Russell King (2):
      ARM: fix footbridge clockevent device
      ARM: fix "bad mode in ... handler" message for undefined instructions

Salva Peir=C3=B3 (1):
      hamradio/yam: fix info leak in ioctl

Sasha Levin (2):
      net: unix: allow bind to fail on mutex lock
      rds: prevent dereference of a NULL device

Simon Guinot (1):
      ahci: add PCI ID for Marvell 88SE9170 SATA controller

Stephen Boyd (1):
      gpio: msm: Fix irq mask/unmask by writing bits instead of numbers

Steven Rostedt (1):
      SELinux: Fix possible NULL pointer dereference in selinux_inode_permi=
ssion()

Sujith Manoharan (1):
      ath9k: Fix interrupt handling for the AR9002 family

Takashi Iwai (1):
      xhci: Limit the spurious wakeup fix only to HP machines

Theodore Ts'o (2):
      ext4: call ext4_error_inode() if jbd2_journal_dirty_metadata() fails
      ext4: add explicit casts when masking cluster sizes

Thomas Hellstrom (1):
      drm/ttm: Fix accesses through vmas with only partial coverage

Venkat Venkatsubra (1):
      rds: prevent BUG_ON triggered on congestion update to loopback

Wenliang Fan (1):
      drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()

Yan, Zheng (2):
      ceph: cleanup aborted requests when re-sending requests.
      ceph: wake up 'safe' waiters when unregistering request

Yijing Wang (1):
      PCI: Enable ARI if dev and upstream bridge support it; disable otherw=
ise

Ying Xue (1):
      sched/rt: Avoid updating RT entry timeout twice within one tick perio=
d


--=20
Ben Hutchings
It is impossible to make anything foolproof because fools are so ingenious.

--=-uW+sZT0tNevTeLiwC7Gy
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.55.patch"
Content-Disposition: attachment; filename="linux-3.2.55.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24va2VybmVsLXBhcmFtZXRlcnMudHh0IGIvRG9jdW1l
bnRhdGlvbi9rZXJuZWwtcGFyYW1ldGVycy50eHQNCmluZGV4IDJiYTgyNzIuLjFiMTk2ZWEgMTAw
NjQ0DQotLS0gYS9Eb2N1bWVudGF0aW9uL2tlcm5lbC1wYXJhbWV0ZXJzLnR4dA0KKysrIGIvRG9j
dW1lbnRhdGlvbi9rZXJuZWwtcGFyYW1ldGVycy50eHQNCkBAIC0xMzA1LDYgKzEzMDUsOCBAQCBi
eXRlcyByZXNwZWN0aXZlbHkuIFN1Y2ggbGV0dGVyIHN1ZmZpeGVzIGNhbiBhbHNvIGJlIGVudGly
ZWx5IG9taXR0ZWQuDQogDQogCQkJKiBkdW1wX2lkOiBkdW1wIElERU5USUZZIGRhdGEuDQogDQor
CQkJKiBkaXNhYmxlOiBEaXNhYmxlIHRoaXMgZGV2aWNlLg0KKw0KIAkJCUlmIHRoZXJlIGFyZSBt
dWx0aXBsZSBtYXRjaGluZyBjb25maWd1cmF0aW9ucyBjaGFuZ2luZw0KIAkJCXRoZSBzYW1lIGF0
dHJpYnV0ZSwgdGhlIGxhc3Qgb25lIGlzIHVzZWQuDQogDQpkaWZmIC0tZ2l0IGEvTWFrZWZpbGUg
Yi9NYWtlZmlsZQ0KaW5kZXggODQ4YmUyNi4uNTM4NDYzZSAxMDA2NDQNCi0tLSBhL01ha2VmaWxl
DQorKysgYi9NYWtlZmlsZQ0KQEAgLTEsNiArMSw2IEBADQogVkVSU0lPTiA9IDMNCiBQQVRDSExF
VkVMID0gMg0KLVNVQkxFVkVMID0gNTQNCitTVUJMRVZFTCA9IDU1DQogRVhUUkFWRVJTSU9OID0N
CiBOQU1FID0gU2FiZXItdG9vdGhlZCBTcXVpcnJlbA0KIA0KZGlmZiAtLWdpdCBhL2FyY2gvYXJt
L2tlcm5lbC90cmFwcy5jIGIvYXJjaC9hcm0va2VybmVsL3RyYXBzLmMNCmluZGV4IDdhYzVkZmQu
LmQ0NWZkMjIgMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9rZXJuZWwvdHJhcHMuYw0KKysrIGIvYXJj
aC9hcm0va2VybmVsL3RyYXBzLmMNCkBAIC0zNyw3ICszNywxMyBAQA0KIA0KICNpbmNsdWRlICJz
aWduYWwuaCINCiANCi1zdGF0aWMgY29uc3QgY2hhciAqaGFuZGxlcltdPSB7ICJwcmVmZXRjaCBh
Ym9ydCIsICJkYXRhIGFib3J0IiwgImFkZHJlc3MgZXhjZXB0aW9uIiwgImludGVycnVwdCIgfTsN
CitzdGF0aWMgY29uc3QgY2hhciAqaGFuZGxlcltdPSB7DQorCSJwcmVmZXRjaCBhYm9ydCIsDQor
CSJkYXRhIGFib3J0IiwNCisJImFkZHJlc3MgZXhjZXB0aW9uIiwNCisJImludGVycnVwdCIsDQor
CSJ1bmRlZmluZWQgaW5zdHJ1Y3Rpb24iLA0KK307DQogDQogdm9pZCAqdmVjdG9yc19wYWdlOw0K
IA0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21hY2gtZm9vdGJyaWRnZS9kYzIxMjg1LXRpbWVyLmMg
Yi9hcmNoL2FybS9tYWNoLWZvb3RicmlkZ2UvZGMyMTI4NS10aW1lci5jDQppbmRleCAxMjFhZDFk
Li41NDc3MzFiIDEwMDY0NA0KLS0tIGEvYXJjaC9hcm0vbWFjaC1mb290YnJpZGdlL2RjMjEyODUt
dGltZXIuYw0KKysrIGIvYXJjaC9hcm0vbWFjaC1mb290YnJpZGdlL2RjMjEyODUtdGltZXIuYw0K
QEAgLTk1LDE3ICs5NSwxNCBAQCBzdGF0aWMgc3RydWN0IGlycWFjdGlvbiBmb290YnJpZGdlX3Rp
bWVyX2lycSA9IHsNCiBzdGF0aWMgdm9pZCBfX2luaXQgZm9vdGJyaWRnZV90aW1lcl9pbml0KHZv
aWQpDQogew0KIAlzdHJ1Y3QgY2xvY2tfZXZlbnRfZGV2aWNlICpjZSA9ICZja2V2dF9kYzIxMjg1
Ow0KKwl1bnNpZ25lZCByYXRlID0gRElWX1JPVU5EX0NMT1NFU1QobWVtX2ZjbGtfMjEyODUsIDE2
KTsNCiANCi0JY2xvY2tzb3VyY2VfcmVnaXN0ZXJfaHooJmNrc3JjX2RjMjEyODUsIChtZW1fZmNs
a18yMTI4NSArIDgpIC8gMTYpOw0KKwljbG9ja3NvdXJjZV9yZWdpc3Rlcl9oeigmY2tzcmNfZGMy
MTI4NSwgcmF0ZSk7DQogDQogCXNldHVwX2lycShjZS0+aXJxLCAmZm9vdGJyaWRnZV90aW1lcl9p
cnEpOw0KIA0KLQljbG9ja2V2ZW50c19jYWxjX211bHRfc2hpZnQoY2UsIG1lbV9mY2xrXzIxMjg1
LCA1KTsNCi0JY2UtPm1heF9kZWx0YV9ucyA9IGNsb2NrZXZlbnRfZGVsdGEybnMoMHhmZmZmZmYs
IGNlKTsNCi0JY2UtPm1pbl9kZWx0YV9ucyA9IGNsb2NrZXZlbnRfZGVsdGEybnMoMHgwMDAwMDQs
IGNlKTsNCiAJY2UtPmNwdW1hc2sgPSBjcHVtYXNrX29mKHNtcF9wcm9jZXNzb3JfaWQoKSk7DQot
DQotCWNsb2NrZXZlbnRzX3JlZ2lzdGVyX2RldmljZShjZSk7DQorCWNsb2NrZXZlbnRzX2NvbmZp
Z19hbmRfcmVnaXN0ZXIoY2UsIHJhdGUsIDB4NCwgMHhmZmZmZmYpOw0KIH0NCiANCiBzdHJ1Y3Qg
c3lzX3RpbWVyIGZvb3RicmlkZ2VfdGltZXIgPSB7DQpkaWZmIC0tZ2l0IGEvYXJjaC9pYTY0L2tl
cm5lbC9tYWNoaW5lX2tleGVjLmMgYi9hcmNoL2lhNjQva2VybmVsL21hY2hpbmVfa2V4ZWMuYw0K
aW5kZXggM2QzYWVlZi4uYWJkNmJhZCAxMDA2NDQNCi0tLSBhL2FyY2gvaWE2NC9rZXJuZWwvbWFj
aGluZV9rZXhlYy5jDQorKysgYi9hcmNoL2lhNjQva2VybmVsL21hY2hpbmVfa2V4ZWMuYw0KQEAg
LTE1Nyw3ICsxNTcsNyBAQCB2b2lkIGFyY2hfY3Jhc2hfc2F2ZV92bWNvcmVpbmZvKHZvaWQpDQog
I2VuZGlmDQogI2lmZGVmIENPTkZJR19QR1RBQkxFXzMNCiAJVk1DT1JFSU5GT19DT05GSUcoUEdU
QUJMRV8zKTsNCi0jZWxpZiAgQ09ORklHX1BHVEFCTEVfNA0KKyNlbGlmIGRlZmluZWQoQ09ORklH
X1BHVEFCTEVfNCkNCiAJVk1DT1JFSU5GT19DT05GSUcoUEdUQUJMRV80KTsNCiAjZW5kaWYNCiB9
DQpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2V4Y2VwdGlvbi02NHMuaCBi
L2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9leGNlcHRpb24tNjRzLmgNCmluZGV4IDgwNTdmNGYu
LmRhODVhZDQgMTAwNjQ0DQotLS0gYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vZXhjZXB0aW9u
LTY0cy5oDQorKysgYi9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vZXhjZXB0aW9uLTY0cy5oDQpA
QCAtMTYzLDcgKzE2Myw3IEBAIGRvX2t2bV8jI246CQkJCQkJCQlcDQogCXN1YmkJcjEscjEsSU5U
X0ZSQU1FX1NJWkU7CS8qIGFsbG9jIGZyYW1lIG9uIGtlcm5lbCBzdGFjawkqLyBcDQogCWJlcS0J
MWY7CQkJCQkJCSAgIFwNCiAJbGQJcjEsUEFDQUtTQVZFKHIxMyk7CS8qIGtlcm5lbCBzdGFjayB0
byB1c2UJCSovIFwNCi0xOgljbXBkaQljcjEscjEsMDsJCS8qIGNoZWNrIGlmIHIxIGlzIGluIHVz
ZXJzcGFjZQkqLyBcDQorMToJY21wZGkJY3IxLHIxLC1JTlRfRlJBTUVfU0laRTsJLyogY2hlY2sg
aWYgcjEgaXMgaW4gdXNlcnNwYWNlCSovIFwNCiAJYmx0KwljcjEsM2Y7CQkJLyogYWJvcnQgaWYg
aXQgaXMJCSovIFwNCiAJbGkJcjEsKG4pOwkJCS8qIHdpbGwgYmUgcmVsb2FkZWQgbGF0ZXIJKi8g
XA0KIAlzdGgJcjEsUEFDQV9UUkFQX1NBVkUocjEzKTsJCQkJCSAgIFwNCmRpZmYgLS1naXQgYS9h
cmNoL3NoL2xpYi9NYWtlZmlsZSBiL2FyY2gvc2gvbGliL01ha2VmaWxlDQppbmRleCA3Yjk1ZjI5
Li4zYmFmZjMxIDEwMDY0NA0KLS0tIGEvYXJjaC9zaC9saWIvTWFrZWZpbGUNCisrKyBiL2FyY2gv
c2gvbGliL01ha2VmaWxlDQpAQCAtNiw3ICs2LDcgQEAgbGliLXkgID0gZGVsYXkubyBtZW1tb3Zl
Lm8gbWVtY2hyLm8gXA0KIAkgY2hlY2tzdW0ubyBzdHJsZW4ubyBkaXY2NC5vIGRpdjY0LWdlbmVy
aWMubw0KIA0KICMgRXh0cmFjdGVkIGZyb20gbGliZ2NjDQotbGliLXkgKz0gbW92bWVtLm8gYXNo
bGRpMy5vIGFzaHJkaTMubyBsc2hyZGkzLm8gXA0KK29iai15ICs9IG1vdm1lbS5vIGFzaGxkaTMu
byBhc2hyZGkzLm8gbHNocmRpMy5vIFwNCiAJIGFzaGxzaTMubyBhc2hyc2kzLm8gYXNoaWZ0cnQu
byBsc2hyc2kzLm8gXA0KIAkgdWRpdl9xcm5uZC5vDQogDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a2VybmVsL2NwdS9wZXJmX2V2ZW50X2FtZF9pYnMuYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvcGVy
Zl9ldmVudF9hbWRfaWJzLmMNCmluZGV4IDNiOGEyZDMuLmVhMzQyNTMgMTAwNjQ0DQotLS0gYS9h
cmNoL3g4Ni9rZXJuZWwvY3B1L3BlcmZfZXZlbnRfYW1kX2licy5jDQorKysgYi9hcmNoL3g4Ni9r
ZXJuZWwvY3B1L3BlcmZfZXZlbnRfYW1kX2licy5jDQpAQCAtOSw2ICs5LDcgQEANCiAjaW5jbHVk
ZSA8bGludXgvcGVyZl9ldmVudC5oPg0KICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCiAjaW5j
bHVkZSA8bGludXgvcGNpLmg+DQorI2luY2x1ZGUgPGxpbnV4L3N5c2NvcmVfb3BzLmg+DQogDQog
I2luY2x1ZGUgPGFzbS9hcGljLmg+DQogDQpAQCAtMjA5LDYgKzIxMCwxOCBAQCBvdXQ6DQogCXJl
dHVybiByZXQ7DQogfQ0KIA0KK3N0YXRpYyB2b2lkIGlic19laWx2dF9zZXR1cCh2b2lkKQ0KK3sN
CisJLyoNCisJICogRm9yY2UgTFZUIG9mZnNldCBhc3NpZ25tZW50IGZvciBmYW1pbHkgMTBoOiBU
aGUgb2Zmc2V0cyBhcmUNCisJICogbm90IGFzc2lnbmVkIGJ5IHRoZSBCSU9TIGZvciB0aGlzIGZh
bWlseSwgc28gdGhlIE9TIGlzDQorCSAqIHJlc3BvbnNpYmxlIGZvciBkb2luZyBpdC4gSWYgdGhl
IE9TIGFzc2lnbm1lbnQgZmFpbHMsIGZhbGwNCisJICogYmFjayB0byBCSU9TIHNldHRpbmdzIGFu
ZCB0cnkgdG8gc2V0dXAgdGhpcy4NCisJICovDQorCWlmIChib290X2NwdV9kYXRhLng4NiA9PSAw
eDEwKQ0KKwkJZm9yY2VfaWJzX2VpbHZ0X3NldHVwKCk7DQorfQ0KKw0KIHN0YXRpYyBpbmxpbmUg
aW50IGdldF9pYnNfbHZ0X29mZnNldCh2b2lkKQ0KIHsNCiAJdTY0IHZhbDsNCkBAIC0yNDQsNiAr
MjU3LDM2IEBAIHN0YXRpYyB2b2lkIGNsZWFyX0FQSUNfaWJzKHZvaWQgKmR1bW15KQ0KIAkJc2V0
dXBfQVBJQ19laWx2dChvZmZzZXQsIDAsIEFQSUNfRUlMVlRfTVNHX0ZJWCwgMSk7DQogfQ0KIA0K
KyNpZmRlZiBDT05GSUdfUE0NCisNCitzdGF0aWMgaW50IHBlcmZfaWJzX3N1c3BlbmQodm9pZCkN
Cit7DQorCWNsZWFyX0FQSUNfaWJzKE5VTEwpOw0KKwlyZXR1cm4gMDsNCit9DQorDQorc3RhdGlj
IHZvaWQgcGVyZl9pYnNfcmVzdW1lKHZvaWQpDQorew0KKwlpYnNfZWlsdnRfc2V0dXAoKTsNCisJ
c2V0dXBfQVBJQ19pYnMoTlVMTCk7DQorfQ0KKw0KK3N0YXRpYyBzdHJ1Y3Qgc3lzY29yZV9vcHMg
cGVyZl9pYnNfc3lzY29yZV9vcHMgPSB7DQorCS5yZXN1bWUJCT0gcGVyZl9pYnNfcmVzdW1lLA0K
Kwkuc3VzcGVuZAk9IHBlcmZfaWJzX3N1c3BlbmQsDQorfTsNCisNCitzdGF0aWMgdm9pZCBwZXJm
X2lic19wbV9pbml0KHZvaWQpDQorew0KKwlyZWdpc3Rlcl9zeXNjb3JlX29wcygmcGVyZl9pYnNf
c3lzY29yZV9vcHMpOw0KK30NCisNCisjZWxzZQ0KKw0KK3N0YXRpYyBpbmxpbmUgdm9pZCBwZXJm
X2lic19wbV9pbml0KHZvaWQpIHsgfQ0KKw0KKyNlbmRpZg0KKw0KIHN0YXRpYyBpbnQgX19jcHVp
bml0DQogcGVyZl9pYnNfY3B1X25vdGlmaWVyKHN0cnVjdCBub3RpZmllcl9ibG9jayAqc2VsZiwg
dW5zaWduZWQgbG9uZyBhY3Rpb24sIHZvaWQgKmhjcHUpDQogew0KQEAgLTI3MCwxOCArMzEzLDEy
IEBAIHN0YXRpYyBfX2luaXQgaW50IGFtZF9pYnNfaW5pdCh2b2lkKQ0KIAlpZiAoIWNhcHMpDQog
CQlyZXR1cm4gLUVOT0RFVjsJLyogaWJzIG5vdCBzdXBwb3J0ZWQgYnkgdGhlIGNwdSAqLw0KIA0K
LQkvKg0KLQkgKiBGb3JjZSBMVlQgb2Zmc2V0IGFzc2lnbm1lbnQgZm9yIGZhbWlseSAxMGg6IFRo
ZSBvZmZzZXRzIGFyZQ0KLQkgKiBub3QgYXNzaWduZWQgYnkgdGhlIEJJT1MgZm9yIHRoaXMgZmFt
aWx5LCBzbyB0aGUgT1MgaXMNCi0JICogcmVzcG9uc2libGUgZm9yIGRvaW5nIGl0LiBJZiB0aGUg
T1MgYXNzaWdubWVudCBmYWlscywgZmFsbA0KLQkgKiBiYWNrIHRvIEJJT1Mgc2V0dGluZ3MgYW5k
IHRyeSB0byBzZXR1cCB0aGlzLg0KLQkgKi8NCi0JaWYgKGJvb3RfY3B1X2RhdGEueDg2ID09IDB4
MTApDQotCQlmb3JjZV9pYnNfZWlsdnRfc2V0dXAoKTsNCisJaWJzX2VpbHZ0X3NldHVwKCk7DQog
DQogCWlmICghaWJzX2VpbHZ0X3ZhbGlkKCkpDQogCQlnb3RvIG91dDsNCiANCisJcGVyZl9pYnNf
cG1faW5pdCgpOw0KIAlnZXRfb25saW5lX2NwdXMoKTsNCiAJaWJzX2NhcHMgPSBjYXBzOw0KIAkv
KiBtYWtlIGlic19jYXBzIHZpc2libGUgdG8gb3RoZXIgY3B1czogKi8NCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rZXJuZWwvdHJhcHMuYyBiL2FyY2gveDg2L2tlcm5lbC90cmFwcy5jDQppbmRleCBl
NmZiYjk0Li4yMDA2MWI5IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva2VybmVsL3RyYXBzLmMNCisr
KyBiL2FyY2gveDg2L2tlcm5lbC90cmFwcy5jDQpAQCAtNTgyLDEyICs1ODIsMTMgQEAgdm9pZCBf
X21hdGhfc3RhdGVfcmVzdG9yZShzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzaykNCiAJLyogQU1EIEs3
L0s4IENQVXMgZG9uJ3Qgc2F2ZS9yZXN0b3JlIEZEUC9GSVAvRk9QIHVubGVzcyBhbiBleGNlcHRp
b24NCiAJICAgaXMgcGVuZGluZy4gIENsZWFyIHRoZSB4ODcgc3RhdGUgaGVyZSBieSBzZXR0aW5n
IGl0IHRvIGZpeGVkDQogCSAgIHZhbHVlcy4gc2FmZV9hZGRyZXNzIGlzIGEgcmFuZG9tIHZhcmlh
YmxlIHRoYXQgc2hvdWxkIGJlIGluIEwxICovDQotCWFsdGVybmF0aXZlX2lucHV0KA0KLQkJQVNN
X05PUDggQVNNX05PUDIsDQotCQkiZW1tc1xuXHQiCSAgCS8qIGNsZWFyIHN0YWNrIHRhZ3MgKi8N
Ci0JCSJmaWxkbCAlUFthZGRyXSIsCS8qIHNldCBGP1AgdG8gZGVmaW5lZCB2YWx1ZSAqLw0KLQkJ
WDg2X0ZFQVRVUkVfRlhTQVZFX0xFQUssDQotCQlbYWRkcl0gIm0iIChzYWZlX2FkZHJlc3MpKTsN
CisJaWYgKHVubGlrZWx5KHN0YXRpY19jcHVfaGFzKFg4Nl9GRUFUVVJFX0ZYU0FWRV9MRUFLKSkp
IHsNCisJCWFzbSB2b2xhdGlsZSgNCisJCQkiZm5jbGV4XG5cdCINCisJCQkiZW1tc1xuXHQiDQor
CQkJImZpbGRsICVQW2FkZHJdIgkvKiBzZXQgRj9QIHRvIGRlZmluZWQgdmFsdWUgKi8NCisJCQk6
IDogW2FkZHJdICJtIiAoc2FmZV9hZGRyZXNzKSk7DQorCX0NCiANCiAJLyoNCiAJICogUGFyYW5v
aWQgcmVzdG9yZS4gc2VuZCBhIFNJR1NFR1YgaWYgd2UgZmFpbCB0byByZXN0b3JlIHRoZSBzdGF0
ZS4NCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbGFwaWMuYyBiL2FyY2gveDg2L2t2bS9sYXBp
Yy5jDQppbmRleCA0M2U3NzUzLi43NTdjNzE2IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL2xh
cGljLmMNCisrKyBiL2FyY2gveDg2L2t2bS9sYXBpYy5jDQpAQCAtMTI3OCwxNCArMTI3OCwxMiBA
QCB2b2lkIF9fa3ZtX21pZ3JhdGVfYXBpY190aW1lcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQog
dm9pZCBrdm1fbGFwaWNfc3luY19mcm9tX3ZhcGljKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCiB7
DQogCXUzMiBkYXRhOw0KLQl2b2lkICp2YXBpYzsNCiANCiAJaWYgKCFpcnFjaGlwX2luX2tlcm5l
bCh2Y3B1LT5rdm0pIHx8ICF2Y3B1LT5hcmNoLmFwaWMtPnZhcGljX2FkZHIpDQogCQlyZXR1cm47
DQogDQotCXZhcGljID0ga21hcF9hdG9taWModmNwdS0+YXJjaC5hcGljLT52YXBpY19wYWdlLCBL
TV9VU0VSMCk7DQotCWRhdGEgPSAqKHUzMiAqKSh2YXBpYyArIG9mZnNldF9pbl9wYWdlKHZjcHUt
PmFyY2guYXBpYy0+dmFwaWNfYWRkcikpOw0KLQlrdW5tYXBfYXRvbWljKHZhcGljLCBLTV9VU0VS
MCk7DQorCWt2bV9yZWFkX2d1ZXN0X2NhY2hlZCh2Y3B1LT5rdm0sICZ2Y3B1LT5hcmNoLmFwaWMt
PnZhcGljX2NhY2hlLCAmZGF0YSwNCisJCQkJc2l6ZW9mKHUzMikpOw0KIA0KIAlhcGljX3NldF90
cHIodmNwdS0+YXJjaC5hcGljLCBkYXRhICYgMHhmZik7DQogfQ0KQEAgLTEyOTUsNyArMTI5Myw2
IEBAIHZvaWQga3ZtX2xhcGljX3N5bmNfdG9fdmFwaWMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0K
IAl1MzIgZGF0YSwgdHByOw0KIAlpbnQgbWF4X2lyciwgbWF4X2lzcjsNCiAJc3RydWN0IGt2bV9s
YXBpYyAqYXBpYzsNCi0Jdm9pZCAqdmFwaWM7DQogDQogCWlmICghaXJxY2hpcF9pbl9rZXJuZWwo
dmNwdS0+a3ZtKSB8fCAhdmNwdS0+YXJjaC5hcGljLT52YXBpY19hZGRyKQ0KIAkJcmV0dXJuOw0K
QEAgLTEzMTAsMTcgKzEzMDcsMjIgQEAgdm9pZCBrdm1fbGFwaWNfc3luY190b192YXBpYyhzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpDQogCQltYXhfaXNyID0gMDsNCiAJZGF0YSA9ICh0cHIgJiAweGZm
KSB8ICgobWF4X2lzciAmIDB4ZjApIDw8IDgpIHwgKG1heF9pcnIgPDwgMjQpOw0KIA0KLQl2YXBp
YyA9IGttYXBfYXRvbWljKHZjcHUtPmFyY2guYXBpYy0+dmFwaWNfcGFnZSwgS01fVVNFUjApOw0K
LQkqKHUzMiAqKSh2YXBpYyArIG9mZnNldF9pbl9wYWdlKHZjcHUtPmFyY2guYXBpYy0+dmFwaWNf
YWRkcikpID0gZGF0YTsNCi0Ja3VubWFwX2F0b21pYyh2YXBpYywgS01fVVNFUjApOw0KKwlrdm1f
d3JpdGVfZ3Vlc3RfY2FjaGVkKHZjcHUtPmt2bSwgJnZjcHUtPmFyY2guYXBpYy0+dmFwaWNfY2Fj
aGUsICZkYXRhLA0KKwkJCQlzaXplb2YodTMyKSk7DQogfQ0KIA0KLXZvaWQga3ZtX2xhcGljX3Nl
dF92YXBpY19hZGRyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgZ3BhX3QgdmFwaWNfYWRkcikNCitp
bnQga3ZtX2xhcGljX3NldF92YXBpY19hZGRyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgZ3BhX3Qg
dmFwaWNfYWRkcikNCiB7DQogCWlmICghaXJxY2hpcF9pbl9rZXJuZWwodmNwdS0+a3ZtKSkNCi0J
CXJldHVybjsNCisJCXJldHVybiAwOw0KKw0KKwlpZiAodmFwaWNfYWRkciAmJiBrdm1fZ2ZuX3Rv
X2h2YV9jYWNoZV9pbml0KHZjcHUtPmt2bSwNCisJCQkJCSAgJnZjcHUtPmFyY2guYXBpYy0+dmFw
aWNfY2FjaGUsDQorCQkJCQkgIHZhcGljX2FkZHIsIHNpemVvZih1MzIpKSkNCisJCXJldHVybiAt
RUlOVkFMOw0KIA0KIAl2Y3B1LT5hcmNoLmFwaWMtPnZhcGljX2FkZHIgPSB2YXBpY19hZGRyOw0K
KwlyZXR1cm4gMDsNCiB9DQogDQogaW50IGt2bV94MmFwaWNfbXNyX3dyaXRlKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwgdTMyIG1zciwgdTY0IGRhdGEpDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3Zt
L2xhcGljLmggYi9hcmNoL3g4Ni9rdm0vbGFwaWMuaA0KaW5kZXggMTM4ZThjYy4uNjJhZTM3NiAx
MDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9sYXBpYy5oDQorKysgYi9hcmNoL3g4Ni9rdm0vbGFw
aWMuaA0KQEAgLTE1LDcgKzE1LDcgQEAgc3RydWN0IGt2bV9sYXBpYyB7DQogCWJvb2wgaXJyX3Bl
bmRpbmc7DQogCXZvaWQgKnJlZ3M7DQogCWdwYV90IHZhcGljX2FkZHI7DQotCXN0cnVjdCBwYWdl
ICp2YXBpY19wYWdlOw0KKwlzdHJ1Y3QgZ2ZuX3RvX2h2YV9jYWNoZSB2YXBpY19jYWNoZTsNCiB9
Ow0KIGludCBrdm1fY3JlYXRlX2xhcGljKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQogdm9pZCBr
dm1fZnJlZV9sYXBpYyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KQEAgLTQ1LDcgKzQ1LDcgQEAg
aW50IGt2bV9sYXBpY19maW5kX2hpZ2hlc3RfaXJyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQog
dTY0IGt2bV9nZXRfbGFwaWNfdHNjZGVhZGxpbmVfbXNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7
DQogdm9pZCBrdm1fc2V0X2xhcGljX3RzY2RlYWRsaW5lX21zcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsIHU2NCBkYXRhKTsNCiANCi12b2lkIGt2bV9sYXBpY19zZXRfdmFwaWNfYWRkcihzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsIGdwYV90IHZhcGljX2FkZHIpOw0KK2ludCBrdm1fbGFwaWNfc2V0X3Zh
cGljX2FkZHIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBncGFfdCB2YXBpY19hZGRyKTsNCiB2b2lk
IGt2bV9sYXBpY19zeW5jX2Zyb21fdmFwaWMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCiB2b2lk
IGt2bV9sYXBpY19zeW5jX3RvX3ZhcGljKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQogDQpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQppbmRleCA1
Nzg2N2U0Li43Nzc0Y2NhIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQorKysgYi9h
cmNoL3g4Ni9rdm0veDg2LmMNCkBAIC0zMTQwLDggKzMxNDAsNyBAQCBsb25nIGt2bV9hcmNoX3Zj
cHVfaW9jdGwoc3RydWN0IGZpbGUgKmZpbHAsDQogCQlyID0gLUVGQVVMVDsNCiAJCWlmIChjb3B5
X2Zyb21fdXNlcigmdmEsIGFyZ3AsIHNpemVvZiB2YSkpDQogCQkJZ290byBvdXQ7DQotCQlyID0g
MDsNCi0JCWt2bV9sYXBpY19zZXRfdmFwaWNfYWRkcih2Y3B1LCB2YS52YXBpY19hZGRyKTsNCisJ
CXIgPSBrdm1fbGFwaWNfc2V0X3ZhcGljX2FkZHIodmNwdSwgdmEudmFwaWNfYWRkcik7DQogCQli
cmVhazsNCiAJfQ0KIAljYXNlIEtWTV9YODZfU0VUVVBfTUNFOiB7DQpAQCAtNTUzNywzMyArNTUz
Niw2IEBAIHN0YXRpYyB2b2lkIHBvc3Rfa3ZtX3J1bl9zYXZlKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSkNCiAJCQkha3ZtX2V2ZW50X25lZWRzX3JlaW5qZWN0aW9uKHZjcHUpOw0KIH0NCiANCi1zdGF0
aWMgdm9pZCB2YXBpY19lbnRlcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQotew0KLQlzdHJ1Y3Qg
a3ZtX2xhcGljICphcGljID0gdmNwdS0+YXJjaC5hcGljOw0KLQlzdHJ1Y3QgcGFnZSAqcGFnZTsN
Ci0NCi0JaWYgKCFhcGljIHx8ICFhcGljLT52YXBpY19hZGRyKQ0KLQkJcmV0dXJuOw0KLQ0KLQlw
YWdlID0gZ2ZuX3RvX3BhZ2UodmNwdS0+a3ZtLCBhcGljLT52YXBpY19hZGRyID4+IFBBR0VfU0hJ
RlQpOw0KLQ0KLQl2Y3B1LT5hcmNoLmFwaWMtPnZhcGljX3BhZ2UgPSBwYWdlOw0KLX0NCi0NCi1z
dGF0aWMgdm9pZCB2YXBpY19leGl0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCi17DQotCXN0cnVj
dCBrdm1fbGFwaWMgKmFwaWMgPSB2Y3B1LT5hcmNoLmFwaWM7DQotCWludCBpZHg7DQotDQotCWlm
ICghYXBpYyB8fCAhYXBpYy0+dmFwaWNfYWRkcikNCi0JCXJldHVybjsNCi0NCi0JaWR4ID0gc3Jj
dV9yZWFkX2xvY2soJnZjcHUtPmt2bS0+c3JjdSk7DQotCWt2bV9yZWxlYXNlX3BhZ2VfZGlydHko
YXBpYy0+dmFwaWNfcGFnZSk7DQotCW1hcmtfcGFnZV9kaXJ0eSh2Y3B1LT5rdm0sIGFwaWMtPnZh
cGljX2FkZHIgPj4gUEFHRV9TSElGVCk7DQotCXNyY3VfcmVhZF91bmxvY2soJnZjcHUtPmt2bS0+
c3JjdSwgaWR4KTsNCi19DQotDQogc3RhdGljIHZvaWQgdXBkYXRlX2NyOF9pbnRlcmNlcHQoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1KQ0KIHsNCiAJaW50IG1heF9pcnIsIHRwcjsNCkBAIC01ODM2LDcg
KzU4MDgsNiBAQCBzdGF0aWMgaW50IF9fdmNwdV9ydW4oc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0K
IAl9DQogDQogCXZjcHUtPnNyY3VfaWR4ID0gc3JjdV9yZWFkX2xvY2soJmt2bS0+c3JjdSk7DQot
CXZhcGljX2VudGVyKHZjcHUpOw0KIA0KIAlyID0gMTsNCiAJd2hpbGUgKHIgPiAwKSB7DQpAQCAt
NTg5Myw4ICs1ODY0LDYgQEAgc3RhdGljIGludCBfX3ZjcHVfcnVuKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSkNCiANCiAJc3JjdV9yZWFkX3VubG9jaygma3ZtLT5zcmN1LCB2Y3B1LT5zcmN1X2lkeCk7
DQogDQotCXZhcGljX2V4aXQodmNwdSk7DQotDQogCXJldHVybiByOw0KIH0NCiANCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL2F0YS9haGNpLmMgYi9kcml2ZXJzL2F0YS9haGNpLmMNCmluZGV4IGQyOWY2
ZDUuLmY0MDAwZWUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2F0YS9haGNpLmMNCisrKyBiL2RyaXZl
cnMvYXRhL2FoY2kuYw0KQEAgLTQyOSwxNyArNDI5LDIyIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
cGNpX2RldmljZV9pZCBhaGNpX3BjaV90YmxbXSA9IHsNCiAJLyogTWFydmVsbCAqLw0KIAl7IFBD
SV9WREVWSUNFKE1BUlZFTEwsIDB4NjE0NSksIGJvYXJkX2FoY2lfbXYgfSwJLyogNjE0NSAqLw0K
IAl7IFBDSV9WREVWSUNFKE1BUlZFTEwsIDB4NjEyMSksIGJvYXJkX2FoY2lfbXYgfSwJLyogNjEy
MSAqLw0KLQl7IFBDSV9ERVZJQ0UoMHgxYjRiLCAweDkxMjMpLA0KKwl7IFBDSV9ERVZJQ0UoUENJ
X1ZFTkRPUl9JRF9NQVJWRUxMX0VYVCwgMHg5MTIzKSwNCiAJICAuY2xhc3MgPSBQQ0lfQ0xBU1Nf
U1RPUkFHRV9TQVRBX0FIQ0ksDQogCSAgLmNsYXNzX21hc2sgPSAweGZmZmZmZiwNCiAJICAuZHJp
dmVyX2RhdGEgPSBib2FyZF9haGNpX3llc19mYnMgfSwJCQkvKiA4OHNlOTEyOCAqLw0KLQl7IFBD
SV9ERVZJQ0UoMHgxYjRiLCAweDkxMjUpLA0KKwl7IFBDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9N
QVJWRUxMX0VYVCwgMHg5MTI1KSwNCiAJICAuZHJpdmVyX2RhdGEgPSBib2FyZF9haGNpX3llc19m
YnMgfSwJCQkvKiA4OHNlOTEyNSAqLw0KLQl7IFBDSV9ERVZJQ0UoMHgxYjRiLCAweDkxN2EpLA0K
Kwl7IFBDSV9ERVZJQ0VfU1VCKFBDSV9WRU5ET1JfSURfTUFSVkVMTF9FWFQsIDB4OTE3OCwNCisJ
CQkgUENJX1ZFTkRPUl9JRF9NQVJWRUxMX0VYVCwgMHg5MTcwKSwNCisJICAuZHJpdmVyX2RhdGEg
PSBib2FyZF9haGNpX3llc19mYnMgfSwJCQkvKiA4OHNlOTE3MCAqLw0KKwl7IFBDSV9ERVZJQ0Uo
UENJX1ZFTkRPUl9JRF9NQVJWRUxMX0VYVCwgMHg5MTdhKSwNCiAJICAuZHJpdmVyX2RhdGEgPSBi
b2FyZF9haGNpX3llc19mYnMgfSwJCQkvKiA4OHNlOTE3MiAqLw0KLQl7IFBDSV9ERVZJQ0UoMHgx
YjRiLCAweDkxOTIpLA0KKwl7IFBDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9NQVJWRUxMX0VYVCwg
MHg5MTcyKSwNCisJICAuZHJpdmVyX2RhdGEgPSBib2FyZF9haGNpX3llc19mYnMgfSwJCQkvKiA4
OHNlOTE3MiAqLw0KKwl7IFBDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9NQVJWRUxMX0VYVCwgMHg5
MTkyKSwNCiAJICAuZHJpdmVyX2RhdGEgPSBib2FyZF9haGNpX3llc19mYnMgfSwJCQkvKiA4OHNl
OTE3MiBvbiBzb21lIEdpZ2FieXRlICovDQotCXsgUENJX0RFVklDRSgweDFiNGIsIDB4OTFhMyks
DQorCXsgUENJX0RFVklDRShQQ0lfVkVORE9SX0lEX01BUlZFTExfRVhULCAweDkxYTMpLA0KIAkg
IC5kcml2ZXJfZGF0YSA9IGJvYXJkX2FoY2lfeWVzX2ZicyB9LA0KIAl7IFBDSV9ERVZJQ0UoUENJ
X1ZFTkRPUl9JRF9NQVJWRUxMX0VYVCwgMHg5MjMwKSwNCiAJICAuZHJpdmVyX2RhdGEgPSBib2Fy
ZF9haGNpX3llc19mYnMgfSwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2F0YS9saWJhdGEtY29yZS5j
IGIvZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYw0KaW5kZXggYTBhMzk4Ny4uNzJiYmI1ZSAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvYXRhL2xpYmF0YS1jb3JlLmMNCisrKyBiL2RyaXZlcnMvYXRhL2xp
YmF0YS1jb3JlLmMNCkBAIC00MDk3LDYgKzQwOTcsOSBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGF0
YV9ibGFja2xpc3RfZW50cnkgYXRhX2RldmljZV9ibGFja2xpc3QgW10gPSB7DQogCXsgIlNUMzMy
MFs2OF0xM0FTIiwJIlNEMVs1LTldIiwJQVRBX0hPUktBR0VfTk9OQ1EgfA0KIAkJCQkJCUFUQV9I
T1JLQUdFX0ZJUk1XQVJFX1dBUk4gfSwNCiANCisJLyogU2VhZ2F0ZSBNb21lbnR1cyBTcGluUG9p
bnQgTTggc2VlbSB0byBoYXZlIEZQTURBX0FBIGlzc3VlcyAqLw0KKwl7ICJTVDEwMDBMTTAyNCBI
Ti1NMTAxTUJCIiwgIjJBUjEwMDAxIiwJQVRBX0hPUktBR0VfQlJPS0VOX0ZQRE1BX0FBIH0sDQor
DQogCS8qIEJsYWNrbGlzdCBlbnRyaWVzIHRha2VuIGZyb20gU2lsaWNvbiBJbWFnZSAzMTI0LzMx
MzINCiAJICAgV2luZG93cyBkcml2ZXIgLmluZiBmaWxlIC0gYWxzbyBzZXZlcmFsIExpbnV4IHBy
b2JsZW0gcmVwb3J0cyAqLw0KIAl7ICJIVFM1NDEwNjBHOVNBMDAiLCAgICAiTUIzT0M2MEQiLCAg
ICAgQVRBX0hPUktBR0VfTk9OQ1EsIH0sDQpAQCAtNjMyOCw2ICs2MzMxLDcgQEAgc3RhdGljIGlu
dCBfX2luaXQgYXRhX3BhcnNlX2ZvcmNlX29uZShjaGFyICoqY3VyLA0KIAkJeyAibm9ocnN0IiwJ
LmxmbGFncwkJPSBBVEFfTEZMQUdfTk9fSFJTVCB9LA0KIAkJeyAibm9zcnN0IiwJLmxmbGFncwkJ
PSBBVEFfTEZMQUdfTk9fU1JTVCB9LA0KIAkJeyAibm9yc3QiLAkubGZsYWdzCQk9IEFUQV9MRkxB
R19OT19IUlNUIHwgQVRBX0xGTEFHX05PX1NSU1QgfSwNCisJCXsgImRpc2FibGUiLAkuaG9ya2Fn
ZV9vbgk9IEFUQV9IT1JLQUdFX0RJU0FCTEUgfSwNCiAJfTsNCiAJY2hhciAqc3RhcnQgPSAqY3Vy
LCAqcCA9ICpjdXI7DQogCWNoYXIgKmlkLCAqdmFsLCAqZW5kcDsNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2RtYS9LY29uZmlnIGIvZHJpdmVycy9kbWEvS2NvbmZpZw0KaW5kZXggZGE4NWMwZC4uYTg0
MjMxNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZG1hL0tjb25maWcNCisrKyBiL2RyaXZlcnMvZG1h
L0tjb25maWcNCkBAIC0yNTQsNiArMjU0LDcgQEAgY29uZmlnIE5FVF9ETUENCiAJYm9vbCAiTmV0
d29yazogVENQIHJlY2VpdmUgY29weSBvZmZsb2FkIg0KIAlkZXBlbmRzIG9uIERNQV9FTkdJTkUg
JiYgTkVUDQogCWRlZmF1bHQgKElOVEVMX0lPQVRETUEgfHwgRlNMX0RNQSkNCisJZGVwZW5kcyBv
biBCUk9LRU4NCiAJaGVscA0KIAkgIFRoaXMgZW5hYmxlcyB0aGUgdXNlIG9mIERNQSBlbmdpbmVz
IGluIHRoZSBuZXR3b3JrIHN0YWNrIHRvDQogCSAgb2ZmbG9hZCByZWNlaXZlIGNvcHktdG8tdXNl
ciBvcGVyYXRpb25zLCBmcmVlaW5nIENQVSBjeWNsZXMuDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9n
cGlvL2dwaW8tbXNtLXYyLmMgYi9kcml2ZXJzL2dwaW8vZ3Bpby1tc20tdjIuYw0KaW5kZXggNWNi
MTIyNy4uMzEwNDUwMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3Bpby9ncGlvLW1zbS12Mi5jDQor
KysgYi9kcml2ZXJzL2dwaW8vZ3Bpby1tc20tdjIuYw0KQEAgLTI0OSw3ICsyNDksNyBAQCBzdGF0
aWMgdm9pZCBtc21fZ3Bpb19pcnFfbWFzayhzdHJ1Y3QgaXJxX2RhdGEgKmQpDQogDQogCXNwaW5f
bG9ja19pcnFzYXZlKCZ0bG1tX2xvY2ssIGlycV9mbGFncyk7DQogCXdyaXRlbChUQVJHRVRfUFJP
Q19OT05FLCBHUElPX0lOVFJfQ0ZHX1NVKGdwaW8pKTsNCi0JY2xlYXJfZ3Bpb19iaXRzKElOVFJf
UkFXX1NUQVRVU19FTiB8IElOVFJfRU5BQkxFLCBHUElPX0lOVFJfQ0ZHKGdwaW8pKTsNCisJY2xl
YXJfZ3Bpb19iaXRzKEJJVChJTlRSX1JBV19TVEFUVVNfRU4pIHwgQklUKElOVFJfRU5BQkxFKSwg
R1BJT19JTlRSX0NGRyhncGlvKSk7DQogCV9fY2xlYXJfYml0KGdwaW8sIG1zbV9ncGlvLmVuYWJs
ZWRfaXJxcyk7DQogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnRsbW1fbG9jaywgaXJxX2ZsYWdz
KTsNCiB9DQpAQCAtMjYxLDcgKzI2MSw3IEBAIHN0YXRpYyB2b2lkIG1zbV9ncGlvX2lycV91bm1h
c2soc3RydWN0IGlycV9kYXRhICpkKQ0KIA0KIAlzcGluX2xvY2tfaXJxc2F2ZSgmdGxtbV9sb2Nr
LCBpcnFfZmxhZ3MpOw0KIAlfX3NldF9iaXQoZ3BpbywgbXNtX2dwaW8uZW5hYmxlZF9pcnFzKTsN
Ci0Jc2V0X2dwaW9fYml0cyhJTlRSX1JBV19TVEFUVVNfRU4gfCBJTlRSX0VOQUJMRSwgR1BJT19J
TlRSX0NGRyhncGlvKSk7DQorCXNldF9ncGlvX2JpdHMoQklUKElOVFJfUkFXX1NUQVRVU19FTikg
fCBCSVQoSU5UUl9FTkFCTEUpLCBHUElPX0lOVFJfQ0ZHKGdwaW8pKTsNCiAJd3JpdGVsKFRBUkdF
VF9QUk9DX1NDT1JQSU9OLCBHUElPX0lOVFJfQ0ZHX1NVKGdwaW8pKTsNCiAJc3Bpbl91bmxvY2tf
aXJxcmVzdG9yZSgmdGxtbV9sb2NrLCBpcnFfZmxhZ3MpOw0KIH0NCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X3JlZy5oIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9y
ZWcuaA0KaW5kZXggOTdhMDUwZi4uZGRiMjJlNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2Ry
bS9pOTE1L2k5MTVfcmVnLmgNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfcmVnLmgN
CkBAIC0zNyw2ICszNyw3IEBADQogICovDQogI2RlZmluZSBJTlRFTF9HTUNIX0NUUkwJCTB4NTIN
CiAjZGVmaW5lIElOVEVMX0dNQ0hfVkdBX0RJU0FCTEUgICgxIDw8IDEpDQorI2RlZmluZSBTTkJf
R01DSF9DVFJMCQkweDUwDQogDQogLyogUENJIGNvbmZpZyBzcGFjZSAqLw0KIA0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2Rpc3BsYXkuYyBiL2RyaXZlcnMvZ3B1L2Ry
bS9pOTE1L2ludGVsX2Rpc3BsYXkuYw0KaW5kZXggNmQzNjY5NS4uNjFiNzA4YiAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2Rpc3BsYXkuYw0KKysrIGIvZHJpdmVycy9n
cHUvZHJtL2k5MTUvaW50ZWxfZGlzcGxheS5jDQpAQCAtOTE0MSwxNCArOTE0MSwxNSBAQCB2b2lk
IGludGVsX2Nvbm5lY3Rvcl9hdHRhY2hfZW5jb2RlcihzdHJ1Y3QgaW50ZWxfY29ubmVjdG9yICpj
b25uZWN0b3IsDQogaW50IGludGVsX21vZGVzZXRfdmdhX3NldF9zdGF0ZShzdHJ1Y3QgZHJtX2Rl
dmljZSAqZGV2LCBib29sIHN0YXRlKQ0KIHsNCiAJc3RydWN0IGRybV9pOTE1X3ByaXZhdGUgKmRl
dl9wcml2ID0gZGV2LT5kZXZfcHJpdmF0ZTsNCisJdW5zaWduZWQgcmVnID0gSU5URUxfSU5GTyhk
ZXYpLT5nZW4gPj0gNiA/IFNOQl9HTUNIX0NUUkwgOiBJTlRFTF9HTUNIX0NUUkw7DQogCXUxNiBn
bWNoX2N0cmw7DQogDQotCXBjaV9yZWFkX2NvbmZpZ193b3JkKGRldl9wcml2LT5icmlkZ2VfZGV2
LCBJTlRFTF9HTUNIX0NUUkwsICZnbWNoX2N0cmwpOw0KKwlwY2lfcmVhZF9jb25maWdfd29yZChk
ZXZfcHJpdi0+YnJpZGdlX2RldiwgcmVnLCAmZ21jaF9jdHJsKTsNCiAJaWYgKHN0YXRlKQ0KIAkJ
Z21jaF9jdHJsICY9IH5JTlRFTF9HTUNIX1ZHQV9ESVNBQkxFOw0KIAllbHNlDQogCQlnbWNoX2N0
cmwgfD0gSU5URUxfR01DSF9WR0FfRElTQUJMRTsNCi0JcGNpX3dyaXRlX2NvbmZpZ193b3JkKGRl
dl9wcml2LT5icmlkZ2VfZGV2LCBJTlRFTF9HTUNIX0NUUkwsIGdtY2hfY3RybCk7DQorCXBjaV93
cml0ZV9jb25maWdfd29yZChkZXZfcHJpdi0+YnJpZGdlX2RldiwgcmVnLCBnbWNoX2N0cmwpOw0K
IAlyZXR1cm4gMDsNCiB9DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9y
czY5MC5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yczY5MC5jDQppbmRleCA5M2JjZTcyLi40
MTRhNjgxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yczY5MC5jDQorKysg
Yi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JzNjkwLmMNCkBAIC0xNjAsNiArMTYwLDE2IEBAIHZv
aWQgcnM2OTBfbWNfaW5pdChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikNCiAJYmFzZSA9IFJS
RUczMl9NQyhSXzAwMDEwMF9NQ0NGR19GQl9MT0NBVElPTik7DQogCWJhc2UgPSBHXzAwMDEwMF9N
Q19GQl9TVEFSVChiYXNlKSA8PCAxNjsNCiAJcmRldi0+bWMuaWdwX3NpZGVwb3J0X2VuYWJsZWQg
PSByYWRlb25fYXRvbWJpb3Nfc2lkZXBvcnRfcHJlc2VudChyZGV2KTsNCisJLyogU29tZSBib2Fy
ZHMgc2VlbSB0byBiZSBjb25maWd1cmVkIGZvciAxMjhNQiBvZiBzaWRlcG9ydCBtZW1vcnksDQor
CSAqIGJ1dCByZWFsbHkgb25seSBoYXZlIDY0TUIuICBKdXN0IHNraXAgdGhlIHNpZGVwb3J0IGFu
ZCB1c2UNCisJICogVU1BIG1lbW9yeS4NCisJICovDQorCWlmIChyZGV2LT5tYy5pZ3Bfc2lkZXBv
cnRfZW5hYmxlZCAmJg0KKwkgICAgKHJkZXYtPm1jLnJlYWxfdnJhbV9zaXplID09ICgzODQgKiAx
MDI0ICogMTAyNCkpKSB7DQorCQliYXNlICs9IDEyOCAqIDEwMjQgKiAxMDI0Ow0KKwkJcmRldi0+
bWMucmVhbF92cmFtX3NpemUgLT0gMTI4ICogMTAyNCAqIDEwMjQ7DQorCQlyZGV2LT5tYy5tY192
cmFtX3NpemUgPSByZGV2LT5tYy5yZWFsX3ZyYW1fc2l6ZTsNCisJfQ0KIAlyczY5MF9wbV9pbmZv
KHJkZXYpOw0KIAlyYWRlb25fdnJhbV9sb2NhdGlvbihyZGV2LCAmcmRldi0+bWMsIGJhc2UpOw0K
IAlyZGV2LT5tYy5ndHRfYmFzZV9hbGlnbiA9IHJkZXYtPm1jLmd0dF9zaXplIC0gMTsNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vdHRtL3R0bV9ib192bS5jIGIvZHJpdmVycy9ncHUvZHJt
L3R0bS90dG1fYm9fdm0uYw0KaW5kZXggMjIxYjkyNC4uZTIyMzE3NSAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvZ3B1L2RybS90dG0vdHRtX2JvX3ZtLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS90dG0v
dHRtX2JvX3ZtLmMNCkBAIC0xNDQsOSArMTQ0LDkgQEAgc3RhdGljIGludCB0dG1fYm9fdm1fZmF1
bHQoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsIHN0cnVjdCB2bV9mYXVsdCAqdm1mKQ0KIAl9
DQogDQogCXBhZ2Vfb2Zmc2V0ID0gKChhZGRyZXNzIC0gdm1hLT52bV9zdGFydCkgPj4gUEFHRV9T
SElGVCkgKw0KLQkgICAgYm8tPnZtX25vZGUtPnN0YXJ0IC0gdm1hLT52bV9wZ29mZjsNCi0JcGFn
ZV9sYXN0ID0gKCh2bWEtPnZtX2VuZCAtIHZtYS0+dm1fc3RhcnQpID4+IFBBR0VfU0hJRlQpICsN
Ci0JICAgIGJvLT52bV9ub2RlLT5zdGFydCAtIHZtYS0+dm1fcGdvZmY7DQorCQl2bWEtPnZtX3Bn
b2ZmIC0gYm8tPnZtX25vZGUtPnN0YXJ0Ow0KKwlwYWdlX2xhc3QgPSB2bWFfcGFnZXModm1hKSAr
IHZtYS0+dm1fcGdvZmYgLQ0KKwkJYm8tPnZtX25vZGUtPnN0YXJ0Ow0KIA0KIAlpZiAodW5saWtl
bHkocGFnZV9vZmZzZXQgPj0gYm8tPm51bV9wYWdlcykpIHsNCiAJCXJldHZhbCA9IFZNX0ZBVUxU
X1NJR0JVUzsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2h3bW9uL2NvcmV0ZW1wLmMgYi9kcml2ZXJz
L2h3bW9uL2NvcmV0ZW1wLmMNCmluZGV4IDNkNjMwYmIuLmU2ZWM5MjAgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL2h3bW9uL2NvcmV0ZW1wLmMNCisrKyBiL2RyaXZlcnMvaHdtb24vY29yZXRlbXAuYw0K
QEAgLTUyLDcgKzUyLDcgQEAgTU9EVUxFX1BBUk1fREVTQyh0am1heCwgIlRqTWF4IHZhbHVlIGlu
IGRlZ3JlZXMgQ2Vsc2l1cyIpOw0KIA0KICNkZWZpbmUgQkFTRV9TWVNGU19BVFRSX05PCTIJLyog
U3lzZnMgQmFzZSBhdHRyIG5vIGZvciBjb3JldGVtcCAqLw0KICNkZWZpbmUgTlVNX1JFQUxfQ09S
RVMJCTMyCS8qIE51bWJlciBvZiBSZWFsIGNvcmVzIHBlciBjcHUgKi8NCi0jZGVmaW5lIENPUkVU
RU1QX05BTUVfTEVOR1RICTE3CS8qIFN0cmluZyBMZW5ndGggb2YgYXR0cnMgKi8NCisjZGVmaW5l
IENPUkVURU1QX05BTUVfTEVOR1RICTE5CS8qIFN0cmluZyBMZW5ndGggb2YgYXR0cnMgKi8NCiAj
ZGVmaW5lIE1BWF9DT1JFX0FUVFJTCQk0CS8qIE1heGltdW0gbm8gb2YgYmFzaWMgYXR0cnMgKi8N
CiAjZGVmaW5lIFRPVEFMX0FUVFJTCQkoTUFYX0NPUkVfQVRUUlMgKyAxKQ0KICNkZWZpbmUgTUFY
X0NPUkVfREFUQQkJKE5VTV9SRUFMX0NPUkVTICsgQkFTRV9TWVNGU19BVFRSX05PKQ0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbWQvcmFpZDEwLmMgYi9kcml2ZXJzL21kL3JhaWQxMC5jDQppbmRleCA4
YmJhNDM4Li42ZDA1ZTI2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZC9yYWlkMTAuYw0KKysrIGIv
ZHJpdmVycy9tZC9yYWlkMTAuYw0KQEAgLTk5Nyw3ICs5OTcsNyBAQCByZWFkX2FnYWluOg0KIAkJ
CS8qIENvdWxkIG5vdCByZWFkIGFsbCBmcm9tIHRoaXMgZGV2aWNlLCBzbyB3ZSB3aWxsDQogCQkJ
ICogbmVlZCBhbm90aGVyIHIxMF9iaW8uDQogCQkJICovDQotCQkJc2VjdG9yc19oYW5kbGVkID0g
KHIxMF9iaW8tPnNlY3RvcnMgKyBtYXhfc2VjdG9ycw0KKwkJCXNlY3RvcnNfaGFuZGxlZCA9IChy
MTBfYmlvLT5zZWN0b3IgKyBtYXhfc2VjdG9ycw0KIAkJCQkJICAgLSBiaW8tPmJpX3NlY3Rvcik7
DQogCQkJcjEwX2Jpby0+c2VjdG9ycyA9IG1heF9zZWN0b3JzOw0KIAkJCXNwaW5fbG9ja19pcnEo
JmNvbmYtPmRldmljZV9sb2NrKTsNCkBAIC0xMDA1LDcgKzEwMDUsNyBAQCByZWFkX2FnYWluOg0K
IAkJCQliaW8tPmJpX3BoeXNfc2VnbWVudHMgPSAyOw0KIAkJCWVsc2UNCiAJCQkJYmlvLT5iaV9w
aHlzX3NlZ21lbnRzKys7DQotCQkJc3Bpbl91bmxvY2soJmNvbmYtPmRldmljZV9sb2NrKTsNCisJ
CQlzcGluX3VubG9ja19pcnEoJmNvbmYtPmRldmljZV9sb2NrKTsNCiAJCQkvKiBDYW5ub3QgY2Fs
bCBnZW5lcmljX21ha2VfcmVxdWVzdCBkaXJlY3RseQ0KIAkJCSAqIGFzIHRoYXQgd2lsbCBiZSBx
dWV1ZWQgaW4gX19nZW5lcmljX21ha2VfcmVxdWVzdA0KIAkJCSAqIGFuZCBzdWJzZXF1ZW50IG1l
bXBvb2xfYWxsb2MgbWlnaHQgYmxvY2sNCkBAIC0yNTYzLDEwICsyNTYzLDYgQEAgc3RhdGljIHNl
Y3Rvcl90IHN5bmNfcmVxdWVzdChzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBzZWN0b3JfdCBzZWN0b3Jf
bnIsDQogCQkJaWYgKGogPT0gY29uZi0+Y29waWVzKSB7DQogCQkJCS8qIENhbm5vdCByZWNvdmVy
LCBzbyBhYm9ydCB0aGUgcmVjb3Zlcnkgb3INCiAJCQkJICogcmVjb3JkIGEgYmFkIGJsb2NrICov
DQotCQkJCXB1dF9idWYocjEwX2Jpbyk7DQotCQkJCWlmIChyYjIpDQotCQkJCQlhdG9taWNfZGVj
KCZyYjItPnJlbWFpbmluZyk7DQotCQkJCXIxMF9iaW8gPSByYjI7DQogCQkJCWlmIChhbnlfd29y
a2luZykgew0KIAkJCQkJLyogcHJvYmxlbSBpcyB0aGF0IHRoZXJlIGFyZSBiYWQgYmxvY2tzDQog
CQkJCQkgKiBvbiBvdGhlciBkZXZpY2UocykNCkBAIC0yNTkwLDYgKzI1ODYsMTAgQEAgc3RhdGlj
IHNlY3Rvcl90IHN5bmNfcmVxdWVzdChzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBzZWN0b3JfdCBzZWN0
b3JfbnIsDQogCQkJCQljb25mLT5taXJyb3JzW2ldLnJlY292ZXJ5X2Rpc2FibGVkDQogCQkJCQkJ
PSBtZGRldi0+cmVjb3ZlcnlfZGlzYWJsZWQ7DQogCQkJCX0NCisJCQkJcHV0X2J1ZihyMTBfYmlv
KTsNCisJCQkJaWYgKHJiMikNCisJCQkJCWF0b21pY19kZWMoJnJiMi0+cmVtYWluaW5nKTsNCisJ
CQkJcjEwX2JpbyA9IHJiMjsNCiAJCQkJYnJlYWs7DQogCQkJfQ0KIAkJfQ0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbWQvcmFpZDUuYyBiL2RyaXZlcnMvbWQvcmFpZDUuYw0KaW5kZXggMjZlZjYzYS4u
ZmI2NzgzMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWQvcmFpZDUuYw0KKysrIGIvZHJpdmVycy9t
ZC9yYWlkNS5jDQpAQCAtMzA4NCw3ICszMDg0LDcgQEAgc3RhdGljIHZvaWQgYW5hbHlzZV9zdHJp
cGUoc3RydWN0IHN0cmlwZV9oZWFkICpzaCwgc3RydWN0IHN0cmlwZV9oZWFkX3N0YXRlICpzKQ0K
IAkJCSAqLw0KIAkJCXNldF9iaXQoUjVfSW5zeW5jLCAmZGV2LT5mbGFncyk7DQogDQotCQlpZiAo
cmRldiAmJiB0ZXN0X2JpdChSNV9Xcml0ZUVycm9yLCAmZGV2LT5mbGFncykpIHsNCisJCWlmICh0
ZXN0X2JpdChSNV9Xcml0ZUVycm9yLCAmZGV2LT5mbGFncykpIHsNCiAJCQljbGVhcl9iaXQoUjVf
SW5zeW5jLCAmZGV2LT5mbGFncyk7DQogCQkJaWYgKCF0ZXN0X2JpdChGYXVsdHksICZyZGV2LT5m
bGFncykpIHsNCiAJCQkJcy0+aGFuZGxlX2JhZF9ibG9ja3MgPSAxOw0KQEAgLTMwOTIsNyArMzA5
Miw3IEBAIHN0YXRpYyB2b2lkIGFuYWx5c2Vfc3RyaXBlKHN0cnVjdCBzdHJpcGVfaGVhZCAqc2gs
IHN0cnVjdCBzdHJpcGVfaGVhZF9zdGF0ZSAqcykNCiAJCQl9IGVsc2UNCiAJCQkJY2xlYXJfYml0
KFI1X1dyaXRlRXJyb3IsICZkZXYtPmZsYWdzKTsNCiAJCX0NCi0JCWlmIChyZGV2ICYmIHRlc3Rf
Yml0KFI1X01hZGVHb29kLCAmZGV2LT5mbGFncykpIHsNCisJCWlmICh0ZXN0X2JpdChSNV9NYWRl
R29vZCwgJmRldi0+ZmxhZ3MpKSB7DQogCQkJaWYgKCF0ZXN0X2JpdChGYXVsdHksICZyZGV2LT5m
bGFncykpIHsNCiAJCQkJcy0+aGFuZGxlX2JhZF9ibG9ja3MgPSAxOw0KIAkJCQlhdG9taWNfaW5j
KCZyZGV2LT5ucl9wZW5kaW5nKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9i
cm9hZGNvbS9ibngyeC9ibngyeF9jbW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29t
L2JueDJ4L2JueDJ4X2Ntbi5jDQppbmRleCBiYmI2NjkyLi5lMzY3YWIxIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54MngvYm54MnhfY21uLmMNCisrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueDJ4L2JueDJ4X2Ntbi5jDQpAQCAtMTA4LDYg
KzEwOCw3IEBAIHN0YXRpYyB1MTYgYm54MnhfZnJlZV90eF9wa3Qoc3RydWN0IGJueDJ4ICpicCwg
c3RydWN0IGJueDJ4X2ZwX3R4ZGF0YSAqdHhkYXRhLA0KIAlzdHJ1Y3Qgc2tfYnVmZiAqc2tiID0g
dHhfYnVmLT5za2I7DQogCXUxNiBiZF9pZHggPSBUWF9CRCh0eF9idWYtPmZpcnN0X2JkKSwgbmV3
X2NvbnM7DQogCWludCBuYmQ7DQorCXUxNiBzcGxpdF9iZF9sZW4gPSAwOw0KIA0KIAkvKiBwcmVm
ZXRjaCBza2IgZW5kIHBvaW50ZXIgdG8gc3BlZWR1cCBkZXZfa2ZyZWVfc2tiKCkgKi8NCiAJcHJl
ZmV0Y2goJnNrYi0+ZW5kKTsNCkBAIC0xMTUsMTEgKzExNiw4IEBAIHN0YXRpYyB1MTYgYm54Mnhf
ZnJlZV90eF9wa3Qoc3RydWN0IGJueDJ4ICpicCwgc3RydWN0IGJueDJ4X2ZwX3R4ZGF0YSAqdHhk
YXRhLA0KIAlEUChCTlgyWF9NU0dfRlAsICJmcFslZF06IHBrdF9pZHggJWQgIGJ1ZmYgQCglcCkt
PnNrYiAlcFxuIiwNCiAJICAgdHhkYXRhLT50eHFfaW5kZXgsIGlkeCwgdHhfYnVmLCBza2IpOw0K
IA0KLQkvKiB1bm1hcCBmaXJzdCBiZCAqLw0KIAlEUChCTlgyWF9NU0dfT0ZGLCAiZnJlZSBiZF9p
ZHggJWRcbiIsIGJkX2lkeCk7DQogCXR4X3N0YXJ0X2JkID0gJnR4ZGF0YS0+dHhfZGVzY19yaW5n
W2JkX2lkeF0uc3RhcnRfYmQ7DQotCWRtYV91bm1hcF9zaW5nbGUoJmJwLT5wZGV2LT5kZXYsIEJE
X1VOTUFQX0FERFIodHhfc3RhcnRfYmQpLA0KLQkJCSBCRF9VTk1BUF9MRU4odHhfc3RhcnRfYmQp
LCBETUFfVE9fREVWSUNFKTsNCiANCiANCiAJbmJkID0gbGUxNl90b19jcHUodHhfc3RhcnRfYmQt
Pm5iZCkgLSAxOw0KQEAgLTEzOCwxMiArMTM2LDE5IEBAIHN0YXRpYyB1MTYgYm54MnhfZnJlZV90
eF9wa3Qoc3RydWN0IGJueDJ4ICpicCwgc3RydWN0IGJueDJ4X2ZwX3R4ZGF0YSAqdHhkYXRhLA0K
IAktLW5iZDsNCiAJYmRfaWR4ID0gVFhfQkQoTkVYVF9UWF9JRFgoYmRfaWR4KSk7DQogDQotCS8q
IC4uLmFuZCB0aGUgVFNPIHNwbGl0IGhlYWRlciBiZCBzaW5jZSB0aGV5IGhhdmUgbm8gbWFwcGlu
ZyAqLw0KKwkvKiBUU08gaGVhZGVycytkYXRhIGJkcyBzaGFyZSBhIGNvbW1vbiBtYXBwaW5nLiBT
ZWUgYm54MnhfdHhfc3BsaXQoKSAqLw0KIAlpZiAodHhfYnVmLT5mbGFncyAmIEJOWDJYX1RTT19T
UExJVF9CRCkgew0KKwkJdHhfZGF0YV9iZCA9ICZ0eGRhdGEtPnR4X2Rlc2NfcmluZ1tiZF9pZHhd
LnJlZ19iZDsNCisJCXNwbGl0X2JkX2xlbiA9IEJEX1VOTUFQX0xFTih0eF9kYXRhX2JkKTsNCiAJ
CS0tbmJkOw0KIAkJYmRfaWR4ID0gVFhfQkQoTkVYVF9UWF9JRFgoYmRfaWR4KSk7DQogCX0NCiAN
CisJLyogdW5tYXAgZmlyc3QgYmQgKi8NCisJZG1hX3VubWFwX3NpbmdsZSgmYnAtPnBkZXYtPmRl
diwgQkRfVU5NQVBfQUREUih0eF9zdGFydF9iZCksDQorCQkJIEJEX1VOTUFQX0xFTih0eF9zdGFy
dF9iZCkgKyBzcGxpdF9iZF9sZW4sDQorCQkJIERNQV9UT19ERVZJQ0UpOw0KKw0KIAkvKiBub3cg
ZnJlZSBmcmFncyAqLw0KIAl3aGlsZSAobmJkID4gMCkgew0KIA0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL3RnMy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJv
YWRjb20vdGczLmMNCmluZGV4IDFiYzkyN2EuLmQ1NzkzZDMgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9icm9hZGNvbS90ZzMuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
YnJvYWRjb20vdGczLmMNCkBAIC0xNDUzNyw2ICsxNDUzNyw5IEBAIHN0YXRpYyBpbnQgX19kZXZp
bml0IHRnM19nZXRfaW52YXJpYW50cyhzdHJ1Y3QgdGczICp0cCkNCiAJLyogQ2xlYXIgdGhpcyBv
dXQgZm9yIHNhbml0eS4gKi8NCiAJdHczMihURzNQQ0lfTUVNX1dJTl9CQVNFX0FERFIsIDApOw0K
IA0KKwkvKiBDbGVhciBURzNQQ0lfUkVHX0JBU0VfQUREUiB0byBwcmV2ZW50IGhhbmdzLiAqLw0K
Kwl0dzMyKFRHM1BDSV9SRUdfQkFTRV9BRERSLCAwKTsNCisNCiAJcGNpX3JlYWRfY29uZmlnX2R3
b3JkKHRwLT5wZGV2LCBURzNQQ0lfUENJU1RBVEUsDQogCQkJICAgICAgJnBjaV9zdGF0ZV9yZWcp
Ow0KIAlpZiAoKHBjaV9zdGF0ZV9yZWcgJiBQQ0lTVEFURV9DT05WX1BDSV9NT0RFKSA9PSAwICYm
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaWJtL2VoZWEvZWhlYV9tYWluLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pYm0vZWhlYS9laGVhX21haW4uYw0KaW5kZXggYmZlY2Ni
Zi4uMjk3ZjBiNiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2libS9laGVhL2Vo
ZWFfbWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pYm0vZWhlYS9laGVhX21haW4u
Yw0KQEAgLTMwMTUsNyArMzAxNSw3IEBAIHN0cnVjdCBlaGVhX3BvcnQgKmVoZWFfc2V0dXBfc2lu
Z2xlX3BvcnQoc3RydWN0IGVoZWFfYWRhcHRlciAqYWRhcHRlciwNCiANCiAJZGV2LT5od19mZWF0
dXJlcyA9IE5FVElGX0ZfU0cgfCBORVRJRl9GX1RTTw0KIAkJICAgICAgfCBORVRJRl9GX0lQX0NT
VU0gfCBORVRJRl9GX0hXX1ZMQU5fVFggfCBORVRJRl9GX0xSTzsNCi0JZGV2LT5mZWF0dXJlcyA9
IE5FVElGX0ZfU0cgfCBORVRJRl9GX0ZSQUdMSVNUIHwgTkVUSUZfRl9UU08NCisJZGV2LT5mZWF0
dXJlcyA9IE5FVElGX0ZfU0cgfCBORVRJRl9GX1RTTw0KIAkJICAgICAgfCBORVRJRl9GX0hJR0hE
TUEgfCBORVRJRl9GX0lQX0NTVU0gfCBORVRJRl9GX0hXX1ZMQU5fVFgNCiAJCSAgICAgIHwgTkVU
SUZfRl9IV19WTEFOX1JYIHwgTkVUSUZfRl9IV19WTEFOX0ZJTFRFUg0KIAkJICAgICAgfCBORVRJ
Rl9GX1JYQ1NVTTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC90ZWh1dGkvdGVo
dXRpLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC90ZWh1dGkvdGVodXRpLmMNCmluZGV4IDNhOTBh
ZjYuLmNjN2U3ZGUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC90ZWh1dGkvdGVo
dXRpLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3RlaHV0aS90ZWh1dGkuYw0KQEAgLTE5
OTUsNyArMTk5NSw2IEBAIGJkeF9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgY29uc3Qgc3Ry
dWN0IHBjaV9kZXZpY2VfaWQgKmVudCkNCiAJCW5kZXYtPmZlYXR1cmVzID0gTkVUSUZfRl9JUF9D
U1VNIHwgTkVUSUZfRl9TRyB8IE5FVElGX0ZfVFNPDQogCQkgICAgfCBORVRJRl9GX0hXX1ZMQU5f
VFggfCBORVRJRl9GX0hXX1ZMQU5fUlggfA0KIAkJICAgIE5FVElGX0ZfSFdfVkxBTl9GSUxURVIg
fCBORVRJRl9GX1JYQ1NVTQ0KLQkJICAgIC8qfCBORVRJRl9GX0ZSQUdMSVNUICovDQogCQkgICAg
Ow0KIAkJbmRldi0+aHdfZmVhdHVyZXMgPSBORVRJRl9GX0lQX0NTVU0gfCBORVRJRl9GX1NHIHwN
CiAJCQlORVRJRl9GX1RTTyB8IE5FVElGX0ZfSFdfVkxBTl9UWDsNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC94aWxpbngvbGxfdGVtYWNfbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQveGlsaW54L2xsX3RlbWFjX21haW4uYw0KaW5kZXggZTI2OTQ1ZC4uMWI3YjNiZSAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC9sbF90ZW1hY19tYWluLmMNCisr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC9sbF90ZW1hY19tYWluLmMNCkBAIC0xMDEx
LDcgKzEwMTEsNyBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCB0ZW1hY19vZl9wcm9iZShzdHJ1Y3Qg
cGxhdGZvcm1fZGV2aWNlICpvcCkNCiAJZGV2X3NldF9kcnZkYXRhKCZvcC0+ZGV2LCBuZGV2KTsN
CiAJU0VUX05FVERFVl9ERVYobmRldiwgJm9wLT5kZXYpOw0KIAluZGV2LT5mbGFncyAmPSB+SUZG
X01VTFRJQ0FTVDsgIC8qIGNsZWFyIG11bHRpY2FzdCAqLw0KLQluZGV2LT5mZWF0dXJlcyA9IE5F
VElGX0ZfU0cgfCBORVRJRl9GX0ZSQUdMSVNUOw0KKwluZGV2LT5mZWF0dXJlcyA9IE5FVElGX0Zf
U0c7DQogCW5kZXYtPm5ldGRldl9vcHMgPSAmdGVtYWNfbmV0ZGV2X29wczsNCiAJbmRldi0+ZXRo
dG9vbF9vcHMgPSAmdGVtYWNfZXRodG9vbF9vcHM7DQogI2lmIDANCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9oYW1yYWRpby9oZGxjZHJ2LmMgYi9kcml2ZXJzL25ldC9oYW1yYWRpby9oZGxjZHJ2
LmMNCmluZGV4IGE0YTM1MTYuLjNiM2E3ZTAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9oYW1y
YWRpby9oZGxjZHJ2LmMNCisrKyBiL2RyaXZlcnMvbmV0L2hhbXJhZGlvL2hkbGNkcnYuYw0KQEAg
LTU3MSw2ICs1NzEsOCBAQCBzdGF0aWMgaW50IGhkbGNkcnZfaW9jdGwoc3RydWN0IG5ldF9kZXZp
Y2UgKmRldiwgc3RydWN0IGlmcmVxICppZnIsIGludCBjbWQpDQogCWNhc2UgSERMQ0RSVkNUTF9D
QUxJQlJBVEU6DQogCQlpZighY2FwYWJsZShDQVBfU1lTX1JBV0lPKSkNCiAJCQlyZXR1cm4gLUVQ
RVJNOw0KKwkJaWYgKGJpLmRhdGEuY2FsaWJyYXRlID4gSU5UX01BWCAvIHMtPnBhci5iaXRyYXRl
KQ0KKwkJCXJldHVybiAtRUlOVkFMOw0KIAkJcy0+aGRsY3R4LmNhbGlicmF0ZSA9IGJpLmRhdGEu
Y2FsaWJyYXRlICogcy0+cGFyLmJpdHJhdGUgLyAxNjsNCiAJCXJldHVybiAwOw0KIA0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2hhbXJhZGlvL3lhbS5jIGIvZHJpdmVycy9uZXQvaGFtcmFkaW8v
eWFtLmMNCmluZGV4IDk2YTk4ZDIuLmU0MjYwYWIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9o
YW1yYWRpby95YW0uYw0KKysrIGIvZHJpdmVycy9uZXQvaGFtcmFkaW8veWFtLmMNCkBAIC0xMDYw
LDYgKzEwNjAsNyBAQCBzdGF0aWMgaW50IHlhbV9pb2N0bChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2
LCBzdHJ1Y3QgaWZyZXEgKmlmciwgaW50IGNtZCkNCiAJCWJyZWFrOw0KIA0KIAljYXNlIFNJT0NZ
QU1HQ0ZHOg0KKwkJbWVtc2V0KCZ5aSwgMCwgc2l6ZW9mKHlpKSk7DQogCQl5aS5jZmcubWFzayA9
IDB4ZmZmZmZmZmY7DQogCQl5aS5jZmcuaW9iYXNlID0geXAtPmlvYmFzZTsNCiAJCXlpLmNmZy5p
cnEgPSB5cC0+aXJxOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9kbTk2MDEuYyBiL2Ry
aXZlcnMvbmV0L3VzYi9kbTk2MDEuYw0KaW5kZXggMTM2ZWNmMy4uZGM2MGFlYyAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvbmV0L3VzYi9kbTk2MDEuYw0KKysrIGIvZHJpdmVycy9uZXQvdXNiL2RtOTYw
MS5jDQpAQCAtNDQ1LDcgKzQ0NSwxMiBAQCBzdGF0aWMgaW50IGRtOTYwMV9iaW5kKHN0cnVjdCB1
c2JuZXQgKmRldiwgc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYpDQogCWRldi0+bmV0LT5ldGh0
b29sX29wcyA9ICZkbTk2MDFfZXRodG9vbF9vcHM7DQogCWRldi0+bmV0LT5oYXJkX2hlYWRlcl9s
ZW4gKz0gRE1fVFhfT1ZFUkhFQUQ7DQogCWRldi0+aGFyZF9tdHUgPSBkZXYtPm5ldC0+bXR1ICsg
ZGV2LT5uZXQtPmhhcmRfaGVhZGVyX2xlbjsNCi0JZGV2LT5yeF91cmJfc2l6ZSA9IGRldi0+bmV0
LT5tdHUgKyBFVEhfSExFTiArIERNX1JYX09WRVJIRUFEOw0KKw0KKwkvKiBkbTk2MjAvMjFhIHJl
cXVpcmUgcm9vbSBmb3IgNCBieXRlIHBhZGRpbmcsIGV2ZW4gaW4gZG05NjAxDQorCSAqIG1vZGUs
IHNvIHdlIG5lZWQgKzEgdG8gYmUgYWJsZSB0byByZWNlaXZlIGZ1bGwgc2l6ZQ0KKwkgKiBldGhl
cm5ldCBmcmFtZXMuDQorCSAqLw0KKwlkZXYtPnJ4X3VyYl9zaXplID0gZGV2LT5uZXQtPm10dSAr
IEVUSF9ITEVOICsgRE1fUlhfT1ZFUkhFQUQgKyAxOw0KIA0KIAlkZXYtPm1paS5kZXYgPSBkZXYt
Pm5ldDsNCiAJZGV2LT5taWkubWRpb19yZWFkID0gZG05NjAxX21kaW9fcmVhZDsNCkBAIC01MzEs
NyArNTM2LDcgQEAgc3RhdGljIGludCBkbTk2MDFfcnhfZml4dXAoc3RydWN0IHVzYm5ldCAqZGV2
LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KIHN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqZG05NjAxX3R4
X2ZpeHVwKHN0cnVjdCB1c2JuZXQgKmRldiwgc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJCQkJICAg
ICAgIGdmcF90IGZsYWdzKQ0KIHsNCi0JaW50IGxlbjsNCisJaW50IGxlbiwgcGFkOw0KIA0KIAkv
KiBmb3JtYXQ6DQogCSAgIGIxOiBwYWNrZXQgbGVuZ3RoIGxvdw0KQEAgLTUzOSwxMiArNTQ0LDIz
IEBAIHN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqZG05NjAxX3R4X2ZpeHVwKHN0cnVjdCB1c2JuZXQg
KmRldiwgc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJICAgYjMuLm46IHBhY2tldCBkYXRhDQogCSov
DQogDQotCWxlbiA9IHNrYi0+bGVuOw0KKwlsZW4gPSBza2ItPmxlbiArIERNX1RYX09WRVJIRUFE
Ow0KIA0KLQlpZiAoc2tiX2hlYWRyb29tKHNrYikgPCBETV9UWF9PVkVSSEVBRCkgew0KKwkvKiB3
b3JrYXJvdW5kIGZvciBkbTk2MnggZXJyYXRhIHdpdGggdHggZmlmbyBnZXR0aW5nIG91dCBvZg0K
KwkgKiBzeW5jIGlmIGEgVVNCIGJ1bGsgdHJhbnNmZXIgcmV0cnkgaGFwcGVucyByaWdodCBhZnRl
ciBhDQorCSAqIHBhY2tldCB3aXRoIG9kZCAvIG1heHBhY2tldCBsZW5ndGggYnkgYWRkaW5nIHVw
IHRvIDMgYnl0ZXMNCisJICogcGFkZGluZy4NCisJICovDQorCXdoaWxlICgobGVuICYgMSkgfHwg
IShsZW4gJSBkZXYtPm1heHBhY2tldCkpDQorCQlsZW4rKzsNCisNCisJbGVuIC09IERNX1RYX09W
RVJIRUFEOyAvKiBodyBoZWFkZXIgZG9lc24ndCBjb3VudCBhcyBwYXJ0IG9mIGxlbmd0aCAqLw0K
KwlwYWQgPSBsZW4gLSBza2ItPmxlbjsNCisNCisJaWYgKHNrYl9oZWFkcm9vbShza2IpIDwgRE1f
VFhfT1ZFUkhFQUQgfHwgc2tiX3RhaWxyb29tKHNrYikgPCBwYWQpIHsNCiAJCXN0cnVjdCBza19i
dWZmICpza2IyOw0KIA0KLQkJc2tiMiA9IHNrYl9jb3B5X2V4cGFuZChza2IsIERNX1RYX09WRVJI
RUFELCAwLCBmbGFncyk7DQorCQlza2IyID0gc2tiX2NvcHlfZXhwYW5kKHNrYiwgRE1fVFhfT1ZF
UkhFQUQsIHBhZCwgZmxhZ3MpOw0KIAkJZGV2X2tmcmVlX3NrYl9hbnkoc2tiKTsNCiAJCXNrYiA9
IHNrYjI7DQogCQlpZiAoIXNrYikNCkBAIC01NTMsMTAgKzU2OSwxMCBAQCBzdGF0aWMgc3RydWN0
IHNrX2J1ZmYgKmRtOTYwMV90eF9maXh1cChzdHJ1Y3QgdXNibmV0ICpkZXYsIHN0cnVjdCBza19i
dWZmICpza2IsDQogDQogCV9fc2tiX3B1c2goc2tiLCBETV9UWF9PVkVSSEVBRCk7DQogDQotCS8q
IHVzYm5ldCBhZGRzIHBhZGRpbmcgaWYgbGVuZ3RoIGlzIGEgbXVsdGlwbGUgb2YgcGFja2V0IHNp
emUNCi0JICAgaWYgc28sIGFkanVzdCBsZW5ndGggdmFsdWUgaW4gaGVhZGVyICovDQotCWlmICgo
c2tiLT5sZW4gJSBkZXYtPm1heHBhY2tldCkgPT0gMCkNCi0JCWxlbisrOw0KKwlpZiAocGFkKSB7
DQorCQltZW1zZXQoc2tiLT5kYXRhICsgc2tiLT5sZW4sIDAsIHBhZCk7DQorCQlfX3NrYl9wdXQo
c2tiLCBwYWQpOw0KKwl9DQogDQogCXNrYi0+ZGF0YVswXSA9IGxlbjsNCiAJc2tiLT5kYXRhWzFd
ID0gbGVuID4+IDg7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlr
L2FyOTAwMl9tYWMuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDJfbWFj
LmMNCmluZGV4IGI1OTIwMTYuLmY0Y2FlYjMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9hdGgvYXRoOWsvYXI5MDAyX21hYy5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9h
dGgvYXRoOWsvYXI5MDAyX21hYy5jDQpAQCAtNzYsOSArNzYsMTYgQEAgc3RhdGljIGJvb2wgYXI5
MDAyX2h3X2dldF9pc3Ioc3RydWN0IGF0aF9odyAqYWgsIGVudW0gYXRoOWtfaW50ICptYXNrZWQp
DQogCQkJCW1hc2syIHw9IEFUSDlLX0lOVF9DU1Q7DQogCQkJaWYgKGlzcjIgJiBBUl9JU1JfUzJf
VFNGT09SKQ0KIAkJCQltYXNrMiB8PSBBVEg5S19JTlRfVFNGT09SOw0KKw0KKwkJCWlmICghKHBD
YXAtPmh3X2NhcHMgJiBBVEg5S19IV19DQVBfUkFDX1NVUFBPUlRFRCkpIHsNCisJCQkJUkVHX1dS
SVRFKGFoLCBBUl9JU1JfUzIsIGlzcjIpOw0KKwkJCQlpc3IgJj0gfkFSX0lTUl9CQ05NSVNDOw0K
KwkJCX0NCiAJCX0NCiANCi0JCWlzciA9IFJFR19SRUFEKGFoLCBBUl9JU1JfUkFDKTsNCisJCWlm
IChwQ2FwLT5od19jYXBzICYgQVRIOUtfSFdfQ0FQX1JBQ19TVVBQT1JURUQpDQorCQkJaXNyID0g
UkVHX1JFQUQoYWgsIEFSX0lTUl9SQUMpOw0KKw0KIAkJaWYgKGlzciA9PSAweGZmZmZmZmZmKSB7
DQogCQkJKm1hc2tlZCA9IDA7DQogCQkJcmV0dXJuIGZhbHNlOw0KQEAgLTk3LDExICsxMDQsMjMg
QEAgc3RhdGljIGJvb2wgYXI5MDAyX2h3X2dldF9pc3Ioc3RydWN0IGF0aF9odyAqYWgsIGVudW0g
YXRoOWtfaW50ICptYXNrZWQpDQogDQogCQkJKm1hc2tlZCB8PSBBVEg5S19JTlRfVFg7DQogDQot
CQkJczBfcyA9IFJFR19SRUFEKGFoLCBBUl9JU1JfUzBfUyk7DQorCQkJaWYgKHBDYXAtPmh3X2Nh
cHMgJiBBVEg5S19IV19DQVBfUkFDX1NVUFBPUlRFRCkgew0KKwkJCQlzMF9zID0gUkVHX1JFQUQo
YWgsIEFSX0lTUl9TMF9TKTsNCisJCQkJczFfcyA9IFJFR19SRUFEKGFoLCBBUl9JU1JfUzFfUyk7
DQorCQkJfSBlbHNlIHsNCisJCQkJczBfcyA9IFJFR19SRUFEKGFoLCBBUl9JU1JfUzApOw0KKwkJ
CQlSRUdfV1JJVEUoYWgsIEFSX0lTUl9TMCwgczBfcyk7DQorCQkJCXMxX3MgPSBSRUdfUkVBRChh
aCwgQVJfSVNSX1MxKTsNCisJCQkJUkVHX1dSSVRFKGFoLCBBUl9JU1JfUzEsIHMxX3MpOw0KKw0K
KwkJCQlpc3IgJj0gfihBUl9JU1JfVFhPSyB8DQorCQkJCQkgQVJfSVNSX1RYREVTQyB8DQorCQkJ
CQkgQVJfSVNSX1RYRVJSIHwNCisJCQkJCSBBUl9JU1JfVFhFT0wpOw0KKwkJCX0NCisNCiAJCQlh
aC0+aW50cl90eHFzIHw9IE1TKHMwX3MsIEFSX0lTUl9TMF9RQ1VfVFhPSyk7DQogCQkJYWgtPmlu
dHJfdHhxcyB8PSBNUyhzMF9zLCBBUl9JU1JfUzBfUUNVX1RYREVTQyk7DQotDQotCQkJczFfcyA9
IFJFR19SRUFEKGFoLCBBUl9JU1JfUzFfUyk7DQogCQkJYWgtPmludHJfdHhxcyB8PSBNUyhzMV9z
LCBBUl9JU1JfUzFfUUNVX1RYRVJSKTsNCiAJCQlhaC0+aW50cl90eHFzIHw9IE1TKHMxX3MsIEFS
X0lTUl9TMV9RQ1VfVFhFT0wpOw0KIAkJfQ0KQEAgLTExNCwxMyArMTMzLDE1IEBAIHN0YXRpYyBi
b29sIGFyOTAwMl9od19nZXRfaXNyKHN0cnVjdCBhdGhfaHcgKmFoLCBlbnVtIGF0aDlrX2ludCAq
bWFza2VkKQ0KIAkJKm1hc2tlZCB8PSBtYXNrMjsNCiAJfQ0KIA0KLQlpZiAoQVJfU1JFVl85MTAw
KGFoKSkNCi0JCXJldHVybiB0cnVlOw0KLQ0KLQlpZiAoaXNyICYgQVJfSVNSX0dFTlRNUikgew0K
KwlpZiAoIUFSX1NSRVZfOTEwMChhaCkgJiYgKGlzciAmIEFSX0lTUl9HRU5UTVIpKSB7DQogCQl1
MzIgczVfczsNCiANCi0JCXM1X3MgPSBSRUdfUkVBRChhaCwgQVJfSVNSX1M1X1MpOw0KKwkJaWYg
KHBDYXAtPmh3X2NhcHMgJiBBVEg5S19IV19DQVBfUkFDX1NVUFBPUlRFRCkgew0KKwkJCXM1X3Mg
PSBSRUdfUkVBRChhaCwgQVJfSVNSX1M1X1MpOw0KKwkJfSBlbHNlIHsNCisJCQlzNV9zID0gUkVH
X1JFQUQoYWgsIEFSX0lTUl9TNSk7DQorCQl9DQorDQogCQlhaC0+aW50cl9nZW5fdGltZXJfdHJp
Z2dlciA9DQogCQkJCU1TKHM1X3MsIEFSX0lTUl9TNV9HRU5USU1FUl9UUklHKTsNCiANCkBAIC0x
MzMsOCArMTU0LDIxIEBAIHN0YXRpYyBib29sIGFyOTAwMl9od19nZXRfaXNyKHN0cnVjdCBhdGhf
aHcgKmFoLCBlbnVtIGF0aDlrX2ludCAqbWFza2VkKQ0KIAkJaWYgKChzNV9zICYgQVJfSVNSX1M1
X1RJTV9USU1FUikgJiYNCiAJCSAgICAhKHBDYXAtPmh3X2NhcHMgJiBBVEg5S19IV19DQVBfQVVU
T1NMRUVQKSkNCiAJCQkqbWFza2VkIHw9IEFUSDlLX0lOVF9USU1fVElNRVI7DQorDQorCQlpZiAo
IShwQ2FwLT5od19jYXBzICYgQVRIOUtfSFdfQ0FQX1JBQ19TVVBQT1JURUQpKSB7DQorCQkJUkVH
X1dSSVRFKGFoLCBBUl9JU1JfUzUsIHM1X3MpOw0KKwkJCWlzciAmPSB+QVJfSVNSX0dFTlRNUjsN
CisJCX0NCiAJfQ0KIA0KKwlpZiAoIShwQ2FwLT5od19jYXBzICYgQVRIOUtfSFdfQ0FQX1JBQ19T
VVBQT1JURUQpKSB7DQorCQlSRUdfV1JJVEUoYWgsIEFSX0lTUiwgaXNyKTsNCisJCVJFR19SRUFE
KGFoLCBBUl9JU1IpOw0KKwl9DQorDQorCWlmIChBUl9TUkVWXzkxMDAoYWgpKQ0KKwkJcmV0dXJu
IHRydWU7DQorDQogCWlmIChzeW5jX2NhdXNlKSB7DQogCQlmYXRhbF9pbnQgPQ0KIAkJCShzeW5j
X2NhdXNlICYNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaHRj
X2Rydl9tYWluLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvaHRjX2Rydl9tYWlu
LmMNCmluZGV4IDBiOWEwZTguLmI2Y2QzNmMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9hdGgvYXRoOWsvaHRjX2Rydl9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg5ay9odGNfZHJ2X21haW4uYw0KQEAgLTEzOSwyMSArMTM5LDI2IEBAIHN0YXRpYyB2
b2lkIGF0aDlrX2h0Y19ic3NpZF9pdGVyKHZvaWQgKmRhdGEsIHU4ICptYWMsIHN0cnVjdCBpZWVl
ODAyMTFfdmlmICp2aWYpDQogCXN0cnVjdCBhdGg5a192aWZfaXRlcl9kYXRhICppdGVyX2RhdGEg
PSBkYXRhOw0KIAlpbnQgaTsNCiANCi0JZm9yIChpID0gMDsgaSA8IEVUSF9BTEVOOyBpKyspDQot
CQlpdGVyX2RhdGEtPm1hc2tbaV0gJj0gfihpdGVyX2RhdGEtPmh3X21hY2FkZHJbaV0gXiBtYWNb
aV0pOw0KKwlpZiAoaXRlcl9kYXRhLT5od19tYWNhZGRyICE9IE5VTEwpIHsNCisJCWZvciAoaSA9
IDA7IGkgPCBFVEhfQUxFTjsgaSsrKQ0KKwkJCWl0ZXJfZGF0YS0+bWFza1tpXSAmPSB+KGl0ZXJf
ZGF0YS0+aHdfbWFjYWRkcltpXSBeIG1hY1tpXSk7DQorCX0gZWxzZSB7DQorCQlpdGVyX2RhdGEt
Pmh3X21hY2FkZHIgPSBtYWM7DQorCX0NCiB9DQogDQotc3RhdGljIHZvaWQgYXRoOWtfaHRjX3Nl
dF9ic3NpZF9tYXNrKHN0cnVjdCBhdGg5a19odGNfcHJpdiAqcHJpdiwNCitzdGF0aWMgdm9pZCBh
dGg5a19odGNfc2V0X21hY19ic3NpZF9tYXNrKHN0cnVjdCBhdGg5a19odGNfcHJpdiAqcHJpdiwN
CiAJCQkJICAgICBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQ0KIHsNCiAJc3RydWN0IGF0aF9j
b21tb24gKmNvbW1vbiA9IGF0aDlrX2h3X2NvbW1vbihwcml2LT5haCk7DQogCXN0cnVjdCBhdGg5
a192aWZfaXRlcl9kYXRhIGl0ZXJfZGF0YTsNCiANCiAJLyoNCi0JICogVXNlIHRoZSBoYXJkd2Fy
ZSBNQUMgYWRkcmVzcyBhcyByZWZlcmVuY2UsIHRoZSBoYXJkd2FyZSB1c2VzIGl0DQotCSAqIHRv
Z2V0aGVyIHdpdGggdGhlIEJTU0lEIG1hc2sgd2hlbiBtYXRjaGluZyBhZGRyZXNzZXMuDQorCSAq
IFBpY2sgdGhlIE1BQyBhZGRyZXNzIG9mIHRoZSBmaXJzdCBpbnRlcmZhY2UgYXMgdGhlIG5ldyBo
YXJkd2FyZQ0KKwkgKiBNQUMgYWRkcmVzcy4gVGhlIGhhcmR3YXJlIHdpbGwgdXNlIGl0IHRvZ2V0
aGVyIHdpdGggdGhlIEJTU0lEIG1hc2sNCisJICogd2hlbiBtYXRjaGluZyBhZGRyZXNzZXMuDQog
CSAqLw0KLQlpdGVyX2RhdGEuaHdfbWFjYWRkciA9IGNvbW1vbi0+bWFjYWRkcjsNCisJaXRlcl9k
YXRhLmh3X21hY2FkZHIgPSBOVUxMOw0KIAltZW1zZXQoJml0ZXJfZGF0YS5tYXNrLCAweGZmLCBF
VEhfQUxFTik7DQogDQogCWlmICh2aWYpDQpAQCAtMTY0LDYgKzE2OSwxMCBAQCBzdGF0aWMgdm9p
ZCBhdGg5a19odGNfc2V0X2Jzc2lkX21hc2soc3RydWN0IGF0aDlrX2h0Y19wcml2ICpwcml2LA0K
IAkJCQkJCSAgICZpdGVyX2RhdGEpOw0KIA0KIAltZW1jcHkoY29tbW9uLT5ic3NpZG1hc2ssIGl0
ZXJfZGF0YS5tYXNrLCBFVEhfQUxFTik7DQorDQorCWlmIChpdGVyX2RhdGEuaHdfbWFjYWRkcikN
CisJCW1lbWNweShjb21tb24tPm1hY2FkZHIsIGl0ZXJfZGF0YS5od19tYWNhZGRyLCBFVEhfQUxF
Tik7DQorDQogCWF0aF9od19zZXRic3NpZG1hc2soY29tbW9uKTsNCiB9DQogDQpAQCAtMTEwMCw3
ICsxMTA5LDcgQEAgc3RhdGljIGludCBhdGg5a19odGNfYWRkX2ludGVyZmFjZShzdHJ1Y3QgaWVl
ZTgwMjExX2h3ICpodywNCiAJCWdvdG8gb3V0Ow0KIAl9DQogDQotCWF0aDlrX2h0Y19zZXRfYnNz
aWRfbWFzayhwcml2LCB2aWYpOw0KKwlhdGg5a19odGNfc2V0X21hY19ic3NpZF9tYXNrKHByaXYs
IHZpZik7DQogDQogCXByaXYtPnZpZl9zbG90IHw9ICgxIDw8IGF2cC0+aW5kZXgpOw0KIAlwcml2
LT5udmlmcysrOw0KQEAgLTExNjMsNyArMTE3Miw3IEBAIHN0YXRpYyB2b2lkIGF0aDlrX2h0Y19y
ZW1vdmVfaW50ZXJmYWNlKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KIA0KIAlhdGg5a19odGNf
c2V0X29wbW9kZShwcml2KTsNCiANCi0JYXRoOWtfaHRjX3NldF9ic3NpZF9tYXNrKHByaXYsIHZp
Zik7DQorCWF0aDlrX2h0Y19zZXRfbWFjX2Jzc2lkX21hc2socHJpdiwgdmlmKTsNCiANCiAJLyoN
CiAJICogU3RvcCBBTkkgb25seSBpZiB0aGVyZSBhcmUgbm8gYXNzb2NpYXRlZCBzdGF0aW9uIGlu
dGVyZmFjZXMuDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL21h
aW4uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9tYWluLmMNCmluZGV4IGE1OTI2
N2EuLmFkMzMxMjYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsv
bWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvbWFpbi5jDQpAQCAt
MTM1Nyw4ICsxMzU3LDkgQEAgdm9pZCBhdGg5a19jYWxjdWxhdGVfaXRlcl9kYXRhKHN0cnVjdCBp
ZWVlODAyMTFfaHcgKmh3LA0KIAlzdHJ1Y3QgYXRoX2NvbW1vbiAqY29tbW9uID0gYXRoOWtfaHdf
Y29tbW9uKGFoKTsNCiANCiAJLyoNCi0JICogVXNlIHRoZSBoYXJkd2FyZSBNQUMgYWRkcmVzcyBh
cyByZWZlcmVuY2UsIHRoZSBoYXJkd2FyZSB1c2VzIGl0DQotCSAqIHRvZ2V0aGVyIHdpdGggdGhl
IEJTU0lEIG1hc2sgd2hlbiBtYXRjaGluZyBhZGRyZXNzZXMuDQorCSAqIFBpY2sgdGhlIE1BQyBh
ZGRyZXNzIG9mIHRoZSBmaXJzdCBpbnRlcmZhY2UgYXMgdGhlIG5ldyBoYXJkd2FyZQ0KKwkgKiBN
QUMgYWRkcmVzcy4gVGhlIGhhcmR3YXJlIHdpbGwgdXNlIGl0IHRvZ2V0aGVyIHdpdGggdGhlIEJT
U0lEIG1hc2sNCisJICogd2hlbiBtYXRjaGluZyBhZGRyZXNzZXMuDQogCSAqLw0KIAltZW1zZXQo
aXRlcl9kYXRhLCAwLCBzaXplb2YoKml0ZXJfZGF0YSkpOw0KIAlpdGVyX2RhdGEtPmh3X21hY2Fk
ZHIgPSBjb21tb24tPm1hY2FkZHI7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cnRsd2lmaS9wY2kuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcGNpLmMNCmluZGV4
IDQ3YmEwZjcuLjM4Yjc5M2IgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3
aWZpL3BjaS5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3BjaS5jDQpAQCAt
Njg1LDYgKzY4NSw4IEBAIHN0YXRpYyB2b2lkIF9ydGxfcGNpX3J4X2ludGVycnVwdChzdHJ1Y3Qg
aWVlZTgwMjExX2h3ICpodykNCiAJfTsNCiAJaW50IGluZGV4ID0gcnRscGNpLT5yeF9yaW5nW3J4
X3F1ZXVlX2lkeF0uaWR4Ow0KIA0KKwlpZiAocnRscGNpLT5kcml2ZXJfaXNfZ29pbmd0b191bmxv
YWQpDQorCQlyZXR1cm47DQogCS8qUlggTk9STUFMIFBLVCAqLw0KIAl3aGlsZSAoY291bnQtLSkg
ew0KIAkJLypyeCBkZXNjcmlwdG9yICovDQpAQCAtMTU2Myw2ICsxNTY1LDcgQEAgc3RhdGljIHZv
aWQgcnRsX3BjaV9zdG9wKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQ0KIAkgKi8NCiAJc2V0X2hh
bF9zdG9wKHJ0bGhhbCk7DQogDQorCXJ0bHBjaS0+ZHJpdmVyX2lzX2dvaW5ndG9fdW5sb2FkID0g
dHJ1ZTsNCiAJcnRscHJpdi0+Y2ZnLT5vcHMtPmRpc2FibGVfaW50ZXJydXB0KGh3KTsNCiAJdGFz
a2xldF9raWxsKCZydGxwcml2LT53b3Jrcy5pcHNfbGVhdmVfdGFza2xldCk7DQogDQpAQCAtMTU4
MCw3ICsxNTgzLDYgQEAgc3RhdGljIHZvaWQgcnRsX3BjaV9zdG9wKHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3KQ0KIAlwcHNjLT5yZmNoYW5nZV9pbnByb2dyZXNzID0gdHJ1ZTsNCiAJc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSgmcnRscHJpdi0+bG9ja3MucmZfcHNfbG9jaywgZmxhZ3MpOw0KIA0KLQly
dGxwY2ktPmRyaXZlcl9pc19nb2luZ3RvX3VubG9hZCA9IHRydWU7DQogCXJ0bHByaXYtPmNmZy0+
b3BzLT5od19kaXNhYmxlKGh3KTsNCiAJcnRscHJpdi0+Y2ZnLT5vcHMtPmxlZF9jb250cm9sKGh3
LCBMRURfQ1RMX1BPV0VSX09GRik7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kvcGNpLmMg
Yi9kcml2ZXJzL3BjaS9wY2kuYw0KaW5kZXggMzYzYTVjNi4uOWYxZmVjMSAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvcGNpL3BjaS5jDQorKysgYi9kcml2ZXJzL3BjaS9wY2kuYw0KQEAgLTE5MTUsMTAg
KzE5MTUsNiBAQCB2b2lkIHBjaV9lbmFibGVfYXJpKHN0cnVjdCBwY2lfZGV2ICpkZXYpDQogCWlm
ICghcGNpX2lzX3BjaWUoZGV2KSB8fCBkZXYtPmRldmZuKQ0KIAkJcmV0dXJuOw0KIA0KLQlwb3Mg
PSBwY2lfZmluZF9leHRfY2FwYWJpbGl0eShkZXYsIFBDSV9FWFRfQ0FQX0lEX0FSSSk7DQotCWlm
ICghcG9zKQ0KLQkJcmV0dXJuOw0KLQ0KIAlicmlkZ2UgPSBkZXYtPmJ1cy0+c2VsZjsNCiAJaWYg
KCFicmlkZ2UgfHwgIXBjaV9pc19wY2llKGJyaWRnZSkpDQogCQlyZXR1cm47DQpAQCAtMTkzNywx
MCArMTkzMywxNCBAQCB2b2lkIHBjaV9lbmFibGVfYXJpKHN0cnVjdCBwY2lfZGV2ICpkZXYpDQog
CQlyZXR1cm47DQogDQogCXBjaV9yZWFkX2NvbmZpZ193b3JkKGJyaWRnZSwgcG9zICsgUENJX0VY
UF9ERVZDVEwyLCAmY3RybCk7DQotCWN0cmwgfD0gUENJX0VYUF9ERVZDVEwyX0FSSTsNCisJaWYg
KHBjaV9maW5kX2V4dF9jYXBhYmlsaXR5KGRldiwgUENJX0VYVF9DQVBfSURfQVJJKSkgew0KKwkJ
Y3RybCB8PSBQQ0lfRVhQX0RFVkNUTDJfQVJJOw0KKwkJYnJpZGdlLT5hcmlfZW5hYmxlZCA9IDE7
DQorCX0gZWxzZSB7DQorCQljdHJsICY9IH5QQ0lfRVhQX0RFVkNUTDJfQVJJOw0KKwkJYnJpZGdl
LT5hcmlfZW5hYmxlZCA9IDA7DQorCX0NCiAJcGNpX3dyaXRlX2NvbmZpZ193b3JkKGJyaWRnZSwg
cG9zICsgUENJX0VYUF9ERVZDVEwyLCBjdHJsKTsNCi0NCi0JYnJpZGdlLT5hcmlfZW5hYmxlZCA9
IDE7DQogfQ0KIA0KIC8qKg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9jb21lZGkvZHJp
dmVycy9jYl9wY2lkaW8uYyBiL2RyaXZlcnMvc3RhZ2luZy9jb21lZGkvZHJpdmVycy9jYl9wY2lk
aW8uYw0KaW5kZXggNzk0NzdhNS4uYjNjOWM4ZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy9jb21lZGkvZHJpdmVycy9jYl9wY2lkaW8uYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL2NvbWVk
aS9kcml2ZXJzL2NiX3BjaWRpby5jDQpAQCAtNTYsMTAgKzU2LDYgQEAgc3RydWN0IHBjaWRpb19i
b2FyZCB7DQogCWNvbnN0IGNoYXIgKm5hbWU7CS8qICBuYW1lIG9mIHRoZSBib2FyZCAqLw0KIAlp
bnQgZGV2X2lkOw0KIAlpbnQgbl84MjU1OwkJLyogIG51bWJlciBvZiA4MjU1IGNoaXBzIG9uIGJv
YXJkICovDQotDQotCS8qICBpbmRpY2VzIG9mIGJhc2UgYWRkcmVzcyByZWdpb25zICovDQotCWlu
dCBwY2ljb250cm9sZXJfYmFkcmluZGV4Ow0KLQlpbnQgZGlvcmVnc19iYWRyaW5kZXg7DQogfTsN
CiANCiBzdGF0aWMgY29uc3Qgc3RydWN0IHBjaWRpb19ib2FyZCBwY2lkaW9fYm9hcmRzW10gPSB7
DQpAQCAtNjcsMjIgKzYzLDE2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcGNpZGlvX2JvYXJkIHBj
aWRpb19ib2FyZHNbXSA9IHsNCiAJIC5uYW1lID0gInBjaS1kaW8yNCIsDQogCSAuZGV2X2lkID0g
MHgwMDI4LA0KIAkgLm5fODI1NSA9IDEsDQotCSAucGNpY29udHJvbGVyX2JhZHJpbmRleCA9IDEs
DQotCSAuZGlvcmVnc19iYWRyaW5kZXggPSAyLA0KIAkgfSwNCiAJew0KIAkgLm5hbWUgPSAicGNp
LWRpbzI0aCIsDQogCSAuZGV2X2lkID0gMHgwMDE0LA0KIAkgLm5fODI1NSA9IDEsDQotCSAucGNp
Y29udHJvbGVyX2JhZHJpbmRleCA9IDEsDQotCSAuZGlvcmVnc19iYWRyaW5kZXggPSAyLA0KIAkg
fSwNCiAJew0KIAkgLm5hbWUgPSAicGNpLWRpbzQ4aCIsDQogCSAuZGV2X2lkID0gMHgwMDBiLA0K
IAkgLm5fODI1NSA9IDIsDQotCSAucGNpY29udHJvbGVyX2JhZHJpbmRleCA9IDAsDQotCSAuZGlv
cmVnc19iYWRyaW5kZXggPSAxLA0KIAkgfSwNCiB9Ow0KIA0KQEAgLTI0NCwxMCArMjM0LDE1IEBA
IGZvdW5kOg0KIAkJICAgICgiY2JfcGNpZGlvOiBmYWlsZWQgdG8gZW5hYmxlIFBDSSBkZXZpY2Ug
YW5kIHJlcXVlc3QgcmVnaW9uc1xuIik7DQogCQlyZXR1cm4gLUVJTzsNCiAJfQ0KLQlkZXZwcml2
LT5kaW9fcmVnX2Jhc2UNCi0JICAgID0NCisJLyoNCisJICogVXNlIFBDSSBCQVIgMiByZWdpb24g
aWYgbm9uLXplcm8gbGVuZ3RoLCBlbHNlIHVzZSBQQ0kgQkFSIDEgcmVnaW9uLg0KKwkgKiBQQ0kg
QkFSIDEgaXMgb25seSB1c2VkIGZvciBvbGRlciBQQ0ktRElPNDhIIGJvYXJkcy4gIEF0IHNvbWUg
cG9pbnQNCisJICogdGhlIFBDSS1ESU80OEggd2FzIHJlZGVzaWduZWQgdG8gdXNlIHRoZSBzYW1l
IFBDSSBpbnRlcmZhY2UgY2hpcA0KKwkgKiAoYW5kIHNhbWUgUENJIEJBUiByZWdpb24pIGFzIHRo
ZSBvdGhlciBib2FyZHMuDQorCSAqLw0KKwlkZXZwcml2LT5kaW9fcmVnX2Jhc2UgPQ0KIAkgICAg
cGNpX3Jlc291cmNlX3N0YXJ0KGRldnByaXYtPnBjaV9kZXYsDQotCQkJICAgICAgIHBjaWRpb19i
b2FyZHNbaW5kZXhdLmRpb3JlZ3NfYmFkcmluZGV4KTsNCisJCQkgICAgICAgKHBjaV9yZXNvdXJj
ZV9sZW4ocGNpZGV2LCAyKSA/IDIgOiAxKSk7DQogDQogLyoNCiAgKiBBbGxvY2F0ZSB0aGUgc3Vi
ZGV2aWNlIHN0cnVjdHVyZXMuICBhbGxvY19zdWJkZXZpY2UoKSBpcyBhDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0LmMgYi9kcml2ZXJzL3RhcmdldC9pc2Nz
aS9pc2NzaV90YXJnZXQuYw0KaW5kZXggM2VmZmRlMi4uNDVjMTNhNiAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldC5jDQorKysgYi9kcml2ZXJzL3RhcmdldC9p
c2NzaS9pc2NzaV90YXJnZXQuYw0KQEAgLTg2MSwyNCArODYxLDIyIEBAIHN0YXRpYyBpbnQgaXNj
c2l0X2hhbmRsZV9zY3NpX2NtZCgNCiAJaWYgKCgoaGRyLT5mbGFncyAmIElTQ1NJX0ZMQUdfQ01E
X1JFQUQpIHx8DQogCSAgICAgKGhkci0+ZmxhZ3MgJiBJU0NTSV9GTEFHX0NNRF9XUklURSkpICYm
ICFoZHItPmRhdGFfbGVuZ3RoKSB7DQogCQkvKg0KLQkJICogVm13YXJlIEVTWCB2My4wIHVzZXMg
YSBtb2RpZmllZCBDaXNjbyBJbml0aWF0b3IgKHYzLjQuMikNCi0JCSAqIHRoYXQgYWRkcyBzdXBw
b3J0IGZvciBSRVNFUlZFL1JFTEVBU0UuICBUaGVyZSBpcyBhIGJ1Zw0KLQkJICogYWRkIHdpdGgg
dGhpcyBuZXcgZnVuY3Rpb25hbGl0eSB0aGF0IHNldHMgUi9XIGJpdHMgd2hlbg0KLQkJICogbmVp
dGhlciBDREIgY2FycmllcyBhbnkgUkVBRCBvciBXUklURSBkYXRhcGF5bG9hZHMuDQorCQkgKiBG
cm9tIFJGQy0zNzIwIFNlY3Rpb24gMTAuMy4xOg0KKwkJICoNCisJCSAqICJFaXRoZXIgb3IgYm90
aCBvZiBSIGFuZCBXIE1BWSBiZSAxIHdoZW4gZWl0aGVyIHRoZQ0KKwkJICogIEV4cGVjdGVkIERh
dGEgVHJhbnNmZXIgTGVuZ3RoIGFuZC9vciBCaWRpcmVjdGlvbmFsIFJlYWQNCisJCSAqICBFeHBl
Y3RlZCBEYXRhIFRyYW5zZmVyIExlbmd0aCBhcmUgMCINCisJCSAqDQorCQkgKiBGb3IgdGhpcyBj
YXNlLCBnbyBhaGVhZCBhbmQgY2xlYXIgdGhlIHVubmVjc3NhcnkgYml0cw0KKwkJICogdG8gYXZv
aWQgYW55IGNvbmZ1c2lvbiB3aXRoIC0+ZGF0YV9kaXJlY3Rpb24uDQogCQkgKi8NCi0JCWlmICgo
aGRyLT5jZGJbMF0gPT0gMHgxNikgfHwgKGhkci0+Y2RiWzBdID09IDB4MTcpKSB7DQotCQkJaGRy
LT5mbGFncyAmPSB+SVNDU0lfRkxBR19DTURfUkVBRDsNCi0JCQloZHItPmZsYWdzICY9IH5JU0NT
SV9GTEFHX0NNRF9XUklURTsNCi0JCQlnb3RvIGRvbmU7DQotCQl9DQorCQloZHItPmZsYWdzICY9
IH5JU0NTSV9GTEFHX0NNRF9SRUFEOw0KKwkJaGRyLT5mbGFncyAmPSB+SVNDU0lfRkxBR19DTURf
V1JJVEU7DQogDQotCQlwcl9lcnIoIklTQ1NJX0ZMQUdfQ01EX1JFQUQgb3IgSVNDU0lfRkxBR19D
TURfV1JJVEUiDQorCQlwcl93YXJuKCJJU0NTSV9GTEFHX0NNRF9SRUFEIG9yIElTQ1NJX0ZMQUdf
Q01EX1dSSVRFIg0KIAkJCSIgc2V0IHdoZW4gRXhwZWN0ZWQgRGF0YSBUcmFuc2ZlciBMZW5ndGgg
aXMgMCBmb3IiDQotCQkJIiBDREI6IDB4JTAyeC4gQmFkIGlTQ1NJIEluaXRpYXRvci5cbiIsIGhk
ci0+Y2RiWzBdKTsNCi0JCXJldHVybiBpc2NzaXRfYWRkX3JlamVjdChJU0NTSV9SRUFTT05fQk9P
S01BUktfSU5WQUxJRCwgMSwNCi0JCQkJYnVmLCBjb25uKTsNCisJCQkiIENEQjogMHglMDJ4LCBG
aXhpbmcgdXAgZmxhZ3NcbiIsIGhkci0+Y2RiWzBdKTsNCiAJfQ0KLWRvbmU6DQogDQogCWlmICgh
KGhkci0+ZmxhZ3MgJiBJU0NTSV9GTEFHX0NNRF9SRUFEKSAmJg0KIAkgICAgIShoZHItPmZsYWdz
ICYgSVNDU0lfRkxBR19DTURfV1JJVEUpICYmIChoZHItPmRhdGFfbGVuZ3RoICE9IDApKSB7DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvaG9zdC94aGNpLXBjaS5jIGIvZHJpdmVycy91c2IvaG9z
dC94aGNpLXBjaS5jDQppbmRleCA4MjdmOTMzLi4xNTY4NWMzIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy91c2IvaG9zdC94aGNpLXBjaS5jDQorKysgYi9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktcGNpLmMN
CkBAIC0xMjEsNyArMTIxLDEyIEBAIHN0YXRpYyB2b2lkIHhoY2lfcGNpX3F1aXJrcyhzdHJ1Y3Qg
ZGV2aWNlICpkZXYsIHN0cnVjdCB4aGNpX2hjZCAqeGhjaSkNCiAJCSAqIGFueSBvdGhlciBzbGVl
cCkgb24gSGFzd2VsbCBtYWNoaW5lcyB3aXRoIExQVCBhbmQgTFBULUxQDQogCQkgKiB3aXRoIHRo
ZSBuZXcgSW50ZWwgQklPUw0KIAkJICovDQotCQl4aGNpLT5xdWlya3MgfD0gWEhDSV9TUFVSSU9V
U19XQUtFVVA7DQorCQkvKiBMaW1pdCB0aGUgcXVpcmsgdG8gb25seSBrbm93biB2ZW5kb3JzLCBh
cyB0aGlzIHRyaWdnZXJzDQorCQkgKiB5ZXQgYW5vdGhlciBCSU9TIGJ1ZyBvbiBzb21lIG90aGVy
IG1hY2hpbmVzDQorCQkgKiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dp
P2lkPTY2MTcxDQorCQkgKi8NCisJCWlmIChwZGV2LT5zdWJzeXN0ZW1fdmVuZG9yID09IFBDSV9W
RU5ET1JfSURfSFApDQorCQkJeGhjaS0+cXVpcmtzIHw9IFhIQ0lfU1BVUklPVVNfV0FLRVVQOw0K
IAl9DQogCWlmIChwZGV2LT52ZW5kb3IgPT0gUENJX1ZFTkRPUl9JRF9FVFJPTiAmJg0KIAkJCXBk
ZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0FTUk9DS19QNjcpIHsNCmRpZmYgLS1naXQgYS9m
cy9jZXBoL21kc19jbGllbnQuYyBiL2ZzL2NlcGgvbWRzX2NsaWVudC5jDQppbmRleCA2MjAzZDgw
Li5iMjRlMmQzIDEwMDY0NA0KLS0tIGEvZnMvY2VwaC9tZHNfY2xpZW50LmMNCisrKyBiL2ZzL2Nl
cGgvbWRzX2NsaWVudC5jDQpAQCAtNjA4LDYgKzYwOCw4IEBAIHN0YXRpYyB2b2lkIF9fdW5yZWdp
c3Rlcl9yZXF1ZXN0KHN0cnVjdCBjZXBoX21kc19jbGllbnQgKm1kc2MsDQogCQlyZXEtPnJfdW5z
YWZlX2RpciA9IE5VTEw7DQogCX0NCiANCisJY29tcGxldGVfYWxsKCZyZXEtPnJfc2FmZV9jb21w
bGV0aW9uKTsNCisNCiAJY2VwaF9tZHNjX3B1dF9yZXF1ZXN0KHJlcSk7DQogfQ0KIA0KQEAgLTE4
MTUsOCArMTgxNywxMSBAQCBzdGF0aWMgaW50IF9fZG9fcmVxdWVzdChzdHJ1Y3QgY2VwaF9tZHNf
Y2xpZW50ICptZHNjLA0KIAlpbnQgbWRzID0gLTE7DQogCWludCBlcnIgPSAtRUFHQUlOOw0KIA0K
LQlpZiAocmVxLT5yX2VyciB8fCByZXEtPnJfZ290X3Jlc3VsdCkNCisJaWYgKHJlcS0+cl9lcnIg
fHwgcmVxLT5yX2dvdF9yZXN1bHQpIHsNCisJCWlmIChyZXEtPnJfYWJvcnRlZCkNCisJCQlfX3Vu
cmVnaXN0ZXJfcmVxdWVzdChtZHNjLCByZXEpOw0KIAkJZ290byBvdXQ7DQorCX0NCiANCiAJaWYg
KHJlcS0+cl90aW1lb3V0ICYmDQogCSAgICB0aW1lX2FmdGVyX2VxKGppZmZpZXMsIHJlcS0+cl9z
dGFydGVkICsgcmVxLT5yX3RpbWVvdXQpKSB7DQpAQCAtMjEyNCw3ICsyMTI5LDYgQEAgc3RhdGlj
IHZvaWQgaGFuZGxlX3JlcGx5KHN0cnVjdCBjZXBoX21kc19zZXNzaW9uICpzZXNzaW9uLCBzdHJ1
Y3QgY2VwaF9tc2cgKm1zZykNCiAJaWYgKGhlYWQtPnNhZmUpIHsNCiAJCXJlcS0+cl9nb3Rfc2Fm
ZSA9IHRydWU7DQogCQlfX3VucmVnaXN0ZXJfcmVxdWVzdChtZHNjLCByZXEpOw0KLQkJY29tcGxl
dGVfYWxsKCZyZXEtPnJfc2FmZV9jb21wbGV0aW9uKTsNCiANCiAJCWlmIChyZXEtPnJfZ290X3Vu
c2FmZSkgew0KIAkJCS8qDQpkaWZmIC0tZ2l0IGEvZnMvZXh0Mi9zdXBlci5jIGIvZnMvZXh0Mi9z
dXBlci5jDQppbmRleCBiZDhhYzE2Li45NGI5ZTMyIDEwMDY0NA0KLS0tIGEvZnMvZXh0Mi9zdXBl
ci5jDQorKysgYi9mcy9leHQyL3N1cGVyLmMNCkBAIC0xNDQ4LDYgKzE0NDgsNyBAQCBzdGF0aWMg
c3NpemVfdCBleHQyX3F1b3RhX3dyaXRlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIGludCB0eXBl
LA0KIAkJCQlzYi0+c19ibG9ja3NpemUgLSBvZmZzZXQgOiB0b3dyaXRlOw0KIA0KIAkJdG1wX2Jo
LmJfc3RhdGUgPSAwOw0KKwkJdG1wX2JoLmJfc2l6ZSA9IHNiLT5zX2Jsb2Nrc2l6ZTsNCiAJCWVy
ciA9IGV4dDJfZ2V0X2Jsb2NrKGlub2RlLCBibGssICZ0bXBfYmgsIDEpOw0KIAkJaWYgKGVyciA8
IDApDQogCQkJZ290byBvdXQ7DQpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9leHQ0LmggYi9mcy9leHQ0
L2V4dDQuaA0KaW5kZXggMjJjNzFiOS4uNjhiMTYwMiAxMDA2NDQNCi0tLSBhL2ZzL2V4dDQvZXh0
NC5oDQorKysgYi9mcy9leHQ0L2V4dDQuaA0KQEAgLTI3OCw2ICsyNzgsMTYgQEAgc3RydWN0IGV4
dDRfaW9fc3VibWl0IHsNCiAvKiBUcmFuc2xhdGUgIyBvZiBibGtzIHRvICMgb2YgY2x1c3RlcnMg
Ki8NCiAjZGVmaW5lIEVYVDRfTlVNX0IyQyhzYmksIGJsa3MpCSgoKGJsa3MpICsgKHNiaSktPnNf
Y2x1c3Rlcl9yYXRpbyAtIDEpID4+IFwNCiAJCQkJIChzYmkpLT5zX2NsdXN0ZXJfYml0cykNCisv
KiBNYXNrIG91dCB0aGUgbG93IGJpdHMgdG8gZ2V0IHRoZSBzdGFydGluZyBibG9jayBvZiB0aGUg
Y2x1c3RlciAqLw0KKyNkZWZpbmUgRVhUNF9QQkxLX0NNQVNLKHMsIHBibGspICgocGJsaykgJgkJ
CQlcDQorCQkJCSAgfigoZXh0NF9mc2Jsa190KSAocyktPnNfY2x1c3Rlcl9yYXRpbyAtIDEpKQ0K
KyNkZWZpbmUgRVhUNF9MQkxLX0NNQVNLKHMsIGxibGspICgobGJsaykgJgkJCQlcDQorCQkJCSAg
figoZXh0NF9sYmxrX3QpIChzKS0+c19jbHVzdGVyX3JhdGlvIC0gMSkpDQorLyogR2V0IHRoZSBj
bHVzdGVyIG9mZnNldCAqLw0KKyNkZWZpbmUgRVhUNF9QQkxLX0NPRkYocywgcGJsaykgKChwYmxr
KSAmCQkJCVwNCisJCQkJICgoZXh0NF9mc2Jsa190KSAocyktPnNfY2x1c3Rlcl9yYXRpbyAtIDEp
KQ0KKyNkZWZpbmUgRVhUNF9MQkxLX0NPRkYocywgbGJsaykgKChsYmxrKSAmCQkJCVwNCisJCQkJ
ICgoZXh0NF9sYmxrX3QpIChzKS0+c19jbHVzdGVyX3JhdGlvIC0gMSkpDQogDQogLyoNCiAgKiBT
dHJ1Y3R1cmUgb2YgYSBibG9ja3MgZ3JvdXAgZGVzY3JpcHRvcg0KZGlmZiAtLWdpdCBhL2ZzL2V4
dDQvZXh0NF9qYmQyLmMgYi9mcy9leHQ0L2V4dDRfamJkMi5jDQppbmRleCBkMGI4Zjk4Li45OTk1
Yjk5IDEwMDY0NA0KLS0tIGEvZnMvZXh0NC9leHQ0X2piZDIuYw0KKysrIGIvZnMvZXh0NC9leHQ0
X2piZDIuYw0KQEAgLTExMyw2ICsxMTMsMTAgQEAgaW50IF9fZXh0NF9oYW5kbGVfZGlydHlfbWV0
YWRhdGEoY29uc3QgY2hhciAqd2hlcmUsIHVuc2lnbmVkIGludCBsaW5lLA0KIAkJaWYgKFdBUk5f
T05fT05DRShlcnIpKSB7DQogCQkJZXh0NF9qb3VybmFsX2Fib3J0X2hhbmRsZSh3aGVyZSwgbGlu
ZSwgX19mdW5jX18sIGJoLA0KIAkJCQkJCSAgaGFuZGxlLCBlcnIpOw0KKwkJCWV4dDRfZXJyb3Jf
aW5vZGUoaW5vZGUsIHdoZXJlLCBsaW5lLA0KKwkJCQkJIGJoLT5iX2Jsb2NrbnIsDQorCQkJCQkg
ImpvdXJuYWxfZGlydHlfbWV0YWRhdGEgZmFpbGVkOiAiDQorCQkJCQkgImVycmNvZGUgJWQiLCBl
cnIpOw0KIAkJfQ0KIAl9IGVsc2Ugew0KIAkJaWYgKGlub2RlKQ0KZGlmZiAtLWdpdCBhL2ZzL2V4
dDQvZXh0ZW50cy5jIGIvZnMvZXh0NC9leHRlbnRzLmMNCmluZGV4IDNlOGZjODAuLmJmMzVmZTAg
MTAwNjQ0DQotLS0gYS9mcy9leHQ0L2V4dGVudHMuYw0KKysrIGIvZnMvZXh0NC9leHRlbnRzLmMN
CkBAIC0zMTgsOCArMzE4LDEwIEBAIHN0YXRpYyBpbnQgZXh0NF92YWxpZF9leHRlbnQoc3RydWN0
IGlub2RlICppbm9kZSwgc3RydWN0IGV4dDRfZXh0ZW50ICpleHQpDQogew0KIAlleHQ0X2ZzYmxr
X3QgYmxvY2sgPSBleHQ0X2V4dF9wYmxvY2soZXh0KTsNCiAJaW50IGxlbiA9IGV4dDRfZXh0X2dl
dF9hY3R1YWxfbGVuKGV4dCk7DQorCWV4dDRfbGJsa190IGxibG9jayA9IGxlMzJfdG9fY3B1KGV4
dC0+ZWVfYmxvY2spOw0KKwlleHQ0X2xibGtfdCBsYXN0ID0gbGJsb2NrICsgbGVuIC0gMTsNCiAN
Ci0JaWYgKGxlbiA9PSAwKQ0KKwlpZiAobGJsb2NrID4gbGFzdCkNCiAJCXJldHVybiAwOw0KIAly
ZXR1cm4gZXh0NF9kYXRhX2Jsb2NrX3ZhbGlkKEVYVDRfU0IoaW5vZGUtPmlfc2IpLCBibG9jaywg
bGVuKTsNCiB9DQpAQCAtMzQ1LDExICszNDcsMjYgQEAgc3RhdGljIGludCBleHQ0X3ZhbGlkX2V4
dGVudF9lbnRyaWVzKHN0cnVjdCBpbm9kZSAqaW5vZGUsDQogCWlmIChkZXB0aCA9PSAwKSB7DQog
CQkvKiBsZWFmIGVudHJpZXMgKi8NCiAJCXN0cnVjdCBleHQ0X2V4dGVudCAqZXh0ID0gRVhUX0ZJ
UlNUX0VYVEVOVChlaCk7DQorCQlzdHJ1Y3QgZXh0NF9zdXBlcl9ibG9jayAqZXMgPSBFWFQ0X1NC
KGlub2RlLT5pX3NiKS0+c19lczsNCisJCWV4dDRfZnNibGtfdCBwYmxvY2sgPSAwOw0KKwkJZXh0
NF9sYmxrX3QgbGJsb2NrID0gMDsNCisJCWV4dDRfbGJsa190IHByZXYgPSAwOw0KKwkJaW50IGxl
biA9IDA7DQogCQl3aGlsZSAoZW50cmllcykgew0KIAkJCWlmICghZXh0NF92YWxpZF9leHRlbnQo
aW5vZGUsIGV4dCkpDQogCQkJCXJldHVybiAwOw0KKw0KKwkJCS8qIENoZWNrIGZvciBvdmVybGFw
cGluZyBleHRlbnRzICovDQorCQkJbGJsb2NrID0gbGUzMl90b19jcHUoZXh0LT5lZV9ibG9jayk7
DQorCQkJbGVuID0gZXh0NF9leHRfZ2V0X2FjdHVhbF9sZW4oZXh0KTsNCisJCQlpZiAoKGxibG9j
ayA8PSBwcmV2KSAmJiBwcmV2KSB7DQorCQkJCXBibG9jayA9IGV4dDRfZXh0X3BibG9jayhleHQp
Ow0KKwkJCQllcy0+c19sYXN0X2Vycm9yX2Jsb2NrID0gY3B1X3RvX2xlNjQocGJsb2NrKTsNCisJ
CQkJcmV0dXJuIDA7DQorCQkJfQ0KIAkJCWV4dCsrOw0KIAkJCWVudHJpZXMtLTsNCisJCQlwcmV2
ID0gbGJsb2NrICsgbGVuIC0gMTsNCiAJCX0NCiAJfSBlbHNlIHsNCiAJCXN0cnVjdCBleHQ0X2V4
dGVudF9pZHggKmV4dF9pZHggPSBFWFRfRklSU1RfSU5ERVgoZWgpOw0KQEAgLTE2NDIsOCArMTY1
OSw3IEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgZXh0NF9leHRfY2hlY2tfb3ZlcmxhcChzdHJ1Y3Qg
ZXh0NF9zYl9pbmZvICpzYmksDQogCWRlcHRoID0gZXh0X2RlcHRoKGlub2RlKTsNCiAJaWYgKCFw
YXRoW2RlcHRoXS5wX2V4dCkNCiAJCWdvdG8gb3V0Ow0KLQliMiA9IGxlMzJfdG9fY3B1KHBhdGhb
ZGVwdGhdLnBfZXh0LT5lZV9ibG9jayk7DQotCWIyICY9IH4oc2JpLT5zX2NsdXN0ZXJfcmF0aW8g
LSAxKTsNCisJYjIgPSBFWFQ0X0xCTEtfQ01BU0soc2JpLCBsZTMyX3RvX2NwdShwYXRoW2RlcHRo
XS5wX2V4dC0+ZWVfYmxvY2spKTsNCiANCiAJLyoNCiAJICogZ2V0IHRoZSBuZXh0IGFsbG9jYXRl
ZCBibG9jayBpZiB0aGUgZXh0ZW50IGluIHRoZSBwYXRoDQpAQCAtMTY1Myw3ICsxNjY5LDcgQEAg
c3RhdGljIHVuc2lnbmVkIGludCBleHQ0X2V4dF9jaGVja19vdmVybGFwKHN0cnVjdCBleHQ0X3Ni
X2luZm8gKnNiaSwNCiAJCWIyID0gZXh0NF9leHRfbmV4dF9hbGxvY2F0ZWRfYmxvY2socGF0aCk7
DQogCQlpZiAoYjIgPT0gRVhUX01BWF9CTE9DS1MpDQogCQkJZ290byBvdXQ7DQotCQliMiAmPSB+
KHNiaS0+c19jbHVzdGVyX3JhdGlvIC0gMSk7DQorCQliMiA9IEVYVDRfTEJMS19DTUFTSyhzYmks
IGIyKTsNCiAJfQ0KIA0KIAkvKiBjaGVjayBmb3Igd3JhcCB0aHJvdWdoIHplcm8gb24gZXh0ZW50
IGxvZ2ljYWwgc3RhcnQgYmxvY2sqLw0KQEAgLTIyODgsNyArMjMwNCw3IEBAIHN0YXRpYyBpbnQg
ZXh0NF9yZW1vdmVfYmxvY2tzKGhhbmRsZV90ICpoYW5kbGUsIHN0cnVjdCBpbm9kZSAqaW5vZGUs
DQogCQkgKiB0cnVuY2F0ZSBvcGVyYXRpb24gaGFzIHJlbW92ZWQgYWxsIG9mIHRoZSBibG9ja3Mg
aW4NCiAJCSAqIHRoZSBjbHVzdGVyLg0KIAkJICovDQotCQlpZiAocGJsayAmIChzYmktPnNfY2x1
c3Rlcl9yYXRpbyAtIDEpICYmDQorCQlpZiAoRVhUNF9QQkxLX0NPRkYoc2JpLCBwYmxrKSAmJg0K
IAkJICAgIChlZV9sZW4gPT0gbnVtKSkNCiAJCQkqcGFydGlhbF9jbHVzdGVyID0gRVhUNF9CMkMo
c2JpLCBwYmxrKTsNCiAJCWVsc2UNCkBAIC0zNDkxLDcgKzM1MDcsNyBAQCBpbnQgZXh0NF9maW5k
X2RlbGFsbG9jX2NsdXN0ZXIoc3RydWN0IGlub2RlICppbm9kZSwgZXh0NF9sYmxrX3QgbGJsaywN
CiB7DQogCXN0cnVjdCBleHQ0X3NiX2luZm8gKnNiaSA9IEVYVDRfU0IoaW5vZGUtPmlfc2IpOw0K
IAlleHQ0X2xibGtfdCBsYmxrX3N0YXJ0LCBsYmxrX2VuZDsNCi0JbGJsa19zdGFydCA9IGxibGsg
JiAofihzYmktPnNfY2x1c3Rlcl9yYXRpbyAtIDEpKTsNCisJbGJsa19zdGFydCA9IEVYVDRfTEJM
S19DTUFTSyhzYmksIGxibGspOw0KIAlsYmxrX2VuZCA9IGxibGtfc3RhcnQgKyBzYmktPnNfY2x1
c3Rlcl9yYXRpbyAtIDE7DQogDQogCXJldHVybiBleHQ0X2ZpbmRfZGVsYWxsb2NfcmFuZ2UoaW5v
ZGUsIGxibGtfc3RhcnQsIGxibGtfZW5kLA0KQEAgLTM1NTEsOSArMzU2Nyw5IEBAIGdldF9yZXNl
cnZlZF9jbHVzdGVyX2FsbG9jKHN0cnVjdCBpbm9kZSAqaW5vZGUsIGV4dDRfbGJsa190IGxibGtf
c3RhcnQsDQogCXRyYWNlX2V4dDRfZ2V0X3Jlc2VydmVkX2NsdXN0ZXJfYWxsb2MoaW5vZGUsIGxi
bGtfc3RhcnQsIG51bV9ibGtzKTsNCiANCiAJLyogQ2hlY2sgdG93YXJkcyBsZWZ0IHNpZGUgKi8N
Ci0JY19vZmZzZXQgPSBsYmxrX3N0YXJ0ICYgKHNiaS0+c19jbHVzdGVyX3JhdGlvIC0gMSk7DQor
CWNfb2Zmc2V0ID0gRVhUNF9MQkxLX0NPRkYoc2JpLCBsYmxrX3N0YXJ0KTsNCiAJaWYgKGNfb2Zm
c2V0KSB7DQotCQlsYmxrX2Zyb20gPSBsYmxrX3N0YXJ0ICYgKH4oc2JpLT5zX2NsdXN0ZXJfcmF0
aW8gLSAxKSk7DQorCQlsYmxrX2Zyb20gPSBFWFQ0X0xCTEtfQ01BU0soc2JpLCBsYmxrX3N0YXJ0
KTsNCiAJCWxibGtfdG8gPSBsYmxrX2Zyb20gKyBjX29mZnNldCAtIDE7DQogDQogCQlpZiAoZXh0
NF9maW5kX2RlbGFsbG9jX3JhbmdlKGlub2RlLCBsYmxrX2Zyb20sIGxibGtfdG8sIDApKQ0KQEAg
LTM1NjEsNyArMzU3Nyw3IEBAIGdldF9yZXNlcnZlZF9jbHVzdGVyX2FsbG9jKHN0cnVjdCBpbm9k
ZSAqaW5vZGUsIGV4dDRfbGJsa190IGxibGtfc3RhcnQsDQogCX0NCiANCiAJLyogTm93IGNoZWNr
IHRvd2FyZHMgcmlnaHQuICovDQotCWNfb2Zmc2V0ID0gKGxibGtfc3RhcnQgKyBudW1fYmxrcykg
JiAoc2JpLT5zX2NsdXN0ZXJfcmF0aW8gLSAxKTsNCisJY19vZmZzZXQgPSBFWFQ0X0xCTEtfQ09G
RihzYmksIGxibGtfc3RhcnQgKyBudW1fYmxrcyk7DQogCWlmIChhbGxvY2F0ZWRfY2x1c3RlcnMg
JiYgY19vZmZzZXQpIHsNCiAJCWxibGtfZnJvbSA9IGxibGtfc3RhcnQgKyBudW1fYmxrczsNCiAJ
CWxibGtfdG8gPSBsYmxrX2Zyb20gKyAoc2JpLT5zX2NsdXN0ZXJfcmF0aW8gLSBjX29mZnNldCkg
LSAxOw0KQEAgLTM3NTQsNyArMzc3MCw3IEBAIHN0YXRpYyBpbnQgZ2V0X2ltcGxpZWRfY2x1c3Rl
cl9hbGxvYyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLA0KIAkJCQkgICAgIHN0cnVjdCBleHQ0X2V4
dF9wYXRoICpwYXRoKQ0KIHsNCiAJc3RydWN0IGV4dDRfc2JfaW5mbyAqc2JpID0gRVhUNF9TQihz
Yik7DQotCWV4dDRfbGJsa190IGNfb2Zmc2V0ID0gbWFwLT5tX2xibGsgJiAoc2JpLT5zX2NsdXN0
ZXJfcmF0aW8tMSk7DQorCWV4dDRfbGJsa190IGNfb2Zmc2V0ID0gRVhUNF9MQkxLX0NPRkYoc2Jp
LCBtYXAtPm1fbGJsayk7DQogCWV4dDRfbGJsa190IGV4X2NsdXN0ZXJfc3RhcnQsIGV4X2NsdXN0
ZXJfZW5kOw0KIAlleHQ0X2xibGtfdCBycl9jbHVzdGVyX3N0YXJ0LCBycl9jbHVzdGVyX2VuZDsN
CiAJZXh0NF9sYmxrX3QgZWVfYmxvY2sgPSBsZTMyX3RvX2NwdShleC0+ZWVfYmxvY2spOw0KQEAg
LTM3NzMsOCArMzc4OSw3IEBAIHN0YXRpYyBpbnQgZ2V0X2ltcGxpZWRfY2x1c3Rlcl9hbGxvYyhz
dHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLA0KIAkgICAgKHJyX2NsdXN0ZXJfc3RhcnQgPT0gZXhfY2x1
c3Rlcl9zdGFydCkpIHsNCiAJCWlmIChycl9jbHVzdGVyX3N0YXJ0ID09IGV4X2NsdXN0ZXJfZW5k
KQ0KIAkJCWVlX3N0YXJ0ICs9IGVlX2xlbiAtIDE7DQotCQltYXAtPm1fcGJsayA9IChlZV9zdGFy
dCAmIH4oc2JpLT5zX2NsdXN0ZXJfcmF0aW8gLSAxKSkgKw0KLQkJCWNfb2Zmc2V0Ow0KKwkJbWFw
LT5tX3BibGsgPSBFWFQ0X1BCTEtfQ01BU0soc2JpLCBlZV9zdGFydCkgKyBjX29mZnNldDsNCiAJ
CW1hcC0+bV9sZW4gPSBtaW4obWFwLT5tX2xlbiwNCiAJCQkJICh1bnNpZ25lZCkgc2JpLT5zX2Ns
dXN0ZXJfcmF0aW8gLSBjX29mZnNldCk7DQogCQkvKg0KQEAgLTQwNTIsNyArNDA2Nyw3IEBAIGlu
dCBleHQ0X2V4dF9tYXBfYmxvY2tzKGhhbmRsZV90ICpoYW5kbGUsIHN0cnVjdCBpbm9kZSAqaW5v
ZGUsDQogCSAqLw0KIAltYXAtPm1fZmxhZ3MgJj0gfkVYVDRfTUFQX0ZST01fQ0xVU1RFUjsNCiAJ
bmV3ZXguZWVfYmxvY2sgPSBjcHVfdG9fbGUzMihtYXAtPm1fbGJsayk7DQotCWNsdXN0ZXJfb2Zm
c2V0ID0gbWFwLT5tX2xibGsgJiAoc2JpLT5zX2NsdXN0ZXJfcmF0aW8tMSk7DQorCWNsdXN0ZXJf
b2Zmc2V0ID0gRVhUNF9MQkxLX0NNQVNLKHNiaSwgbWFwLT5tX2xibGspOw0KIA0KIAkvKg0KIAkg
KiBJZiB3ZSBhcmUgZG9pbmcgYmlnYWxsb2MsIGNoZWNrIHRvIHNlZSBpZiB0aGUgZXh0ZW50IHJl
dHVybmVkDQpAQCAtNDEyMCw3ICs0MTM1LDcgQEAgaW50IGV4dDRfZXh0X21hcF9ibG9ja3MoaGFu
ZGxlX3QgKmhhbmRsZSwgc3RydWN0IGlub2RlICppbm9kZSwNCiAJICogbmVlZGVkIHNvIHRoYXQg
ZnV0dXJlIGNhbGxzIHRvIGdldF9pbXBsaWVkX2NsdXN0ZXJfYWxsb2MoKQ0KIAkgKiB3b3JrIGNv
cnJlY3RseS4NCiAJICovDQotCW9mZnNldCA9IG1hcC0+bV9sYmxrICYgKHNiaS0+c19jbHVzdGVy
X3JhdGlvIC0gMSk7DQorCW9mZnNldCA9IEVYVDRfTEJMS19DT0ZGKHNiaSwgbWFwLT5tX2xibGsp
Ow0KIAlhci5sZW4gPSBFWFQ0X05VTV9CMkMoc2JpLCBvZmZzZXQrYWxsb2NhdGVkKTsNCiAJYXIu
Z29hbCAtPSBvZmZzZXQ7DQogCWFyLmxvZ2ljYWwgLT0gb2Zmc2V0Ow0KZGlmZiAtLWdpdCBhL2Zz
L2V4dDQvbWJhbGxvYy5jIGIvZnMvZXh0NC9tYmFsbG9jLmMNCmluZGV4IDliOGMxMzEuLjgxZmVi
MTcgMTAwNjQ0DQotLS0gYS9mcy9leHQ0L21iYWxsb2MuYw0KKysrIGIvZnMvZXh0NC9tYmFsbG9j
LmMNCkBAIC0zMzc4LDYgKzMzNzgsOSBAQCBzdGF0aWMgdm9pZCBleHQ0X21iX3BhX2NhbGxiYWNr
KHN0cnVjdCByY3VfaGVhZCAqaGVhZCkNCiB7DQogCXN0cnVjdCBleHQ0X3ByZWFsbG9jX3NwYWNl
ICpwYTsNCiAJcGEgPSBjb250YWluZXJfb2YoaGVhZCwgc3RydWN0IGV4dDRfcHJlYWxsb2Nfc3Bh
Y2UsIHUucGFfcmN1KTsNCisNCisJQlVHX09OKGF0b21pY19yZWFkKCZwYS0+cGFfY291bnQpKTsN
CisJQlVHX09OKHBhLT5wYV9kZWxldGVkID09IDApOw0KIAlrbWVtX2NhY2hlX2ZyZWUoZXh0NF9w
c3BhY2VfY2FjaGVwLCBwYSk7DQogfQ0KIA0KQEAgLTMzOTEsMTEgKzMzOTQsMTMgQEAgc3RhdGlj
IHZvaWQgZXh0NF9tYl9wdXRfcGEoc3RydWN0IGV4dDRfYWxsb2NhdGlvbl9jb250ZXh0ICphYywN
CiAJZXh0NF9ncm91cF90IGdycDsNCiAJZXh0NF9mc2Jsa190IGdycF9ibGs7DQogDQotCWlmICgh
YXRvbWljX2RlY19hbmRfdGVzdCgmcGEtPnBhX2NvdW50KSB8fCBwYS0+cGFfZnJlZSAhPSAwKQ0K
LQkJcmV0dXJuOw0KLQ0KIAkvKiBpbiB0aGlzIHNob3J0IHdpbmRvdyBjb25jdXJyZW50IGRpc2Nh
cmQgY2FuIHNldCBwYV9kZWxldGVkICovDQogCXNwaW5fbG9jaygmcGEtPnBhX2xvY2spOw0KKwlp
ZiAoIWF0b21pY19kZWNfYW5kX3Rlc3QoJnBhLT5wYV9jb3VudCkgfHwgcGEtPnBhX2ZyZWUgIT0g
MCkgew0KKwkJc3Bpbl91bmxvY2soJnBhLT5wYV9sb2NrKTsNCisJCXJldHVybjsNCisJfQ0KKw0K
IAlpZiAocGEtPnBhX2RlbGV0ZWQgPT0gMSkgew0KIAkJc3Bpbl91bmxvY2soJnBhLT5wYV9sb2Nr
KTsNCiAJCXJldHVybjsNCkBAIC00MDYyLDcgKzQwNjcsNyBAQCBleHQ0X21iX2luaXRpYWxpemVf
Y29udGV4dChzdHJ1Y3QgZXh0NF9hbGxvY2F0aW9uX2NvbnRleHQgKmFjLA0KIA0KIAkvKiBzZXQg
dXAgYWxsb2NhdGlvbiBnb2FscyAqLw0KIAltZW1zZXQoYWMsIDAsIHNpemVvZihzdHJ1Y3QgZXh0
NF9hbGxvY2F0aW9uX2NvbnRleHQpKTsNCi0JYWMtPmFjX2JfZXguZmVfbG9naWNhbCA9IGFyLT5s
b2dpY2FsICYgfihzYmktPnNfY2x1c3Rlcl9yYXRpbyAtIDEpOw0KKwlhYy0+YWNfYl9leC5mZV9s
b2dpY2FsID0gRVhUNF9MQkxLX0NNQVNLKHNiaSwgYXItPmxvZ2ljYWwpOw0KIAlhYy0+YWNfc3Rh
dHVzID0gQUNfU1RBVFVTX0NPTlRJTlVFOw0KIAlhYy0+YWNfc2IgPSBzYjsNCiAJYWMtPmFjX2lu
b2RlID0gYXItPmlub2RlOw0KQEAgLTQ2MDAsNyArNDYwNSw3IEBAIHZvaWQgZXh0NF9mcmVlX2Js
b2NrcyhoYW5kbGVfdCAqaGFuZGxlLCBzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KIAkgKiBibG9ja3Mg
YXQgdGhlIGJlZ2lubmluZyBvciB0aGUgZW5kIHVubGVzcyB3ZSBhcmUgZXhwbGljaXRseQ0KIAkg
KiByZXF1ZXN0ZWQgdG8gYXZvaWQgZG9pbmcgc28uDQogCSAqLw0KLQlvdmVyZmxvdyA9IGJsb2Nr
ICYgKHNiaS0+c19jbHVzdGVyX3JhdGlvIC0gMSk7DQorCW92ZXJmbG93ID0gRVhUNF9QQkxLX0NP
RkYoc2JpLCBibG9jayk7DQogCWlmIChvdmVyZmxvdykgew0KIAkJaWYgKGZsYWdzICYgRVhUNF9G
UkVFX0JMT0NLU19OT0ZSRUVfRklSU1RfQ0xVU1RFUikgew0KIAkJCW92ZXJmbG93ID0gc2JpLT5z
X2NsdXN0ZXJfcmF0aW8gLSBvdmVyZmxvdzsNCkBAIC00NjE0LDcgKzQ2MTksNyBAQCB2b2lkIGV4
dDRfZnJlZV9ibG9ja3MoaGFuZGxlX3QgKmhhbmRsZSwgc3RydWN0IGlub2RlICppbm9kZSwNCiAJ
CQljb3VudCArPSBvdmVyZmxvdzsNCiAJCX0NCiAJfQ0KLQlvdmVyZmxvdyA9IGNvdW50ICYgKHNi
aS0+c19jbHVzdGVyX3JhdGlvIC0gMSk7DQorCW92ZXJmbG93ID0gRVhUNF9MQkxLX0NPRkYoc2Jp
LCBjb3VudCk7DQogCWlmIChvdmVyZmxvdykgew0KIAkJaWYgKGZsYWdzICYgRVhUNF9GUkVFX0JM
T0NLU19OT0ZSRUVfTEFTVF9DTFVTVEVSKSB7DQogCQkJaWYgKGNvdW50ID4gb3ZlcmZsb3cpDQpk
aWZmIC0tZ2l0IGEvZnMvZXh0NC9zdXBlci5jIGIvZnMvZXh0NC9zdXBlci5jDQppbmRleCA4NGY4
NGJmLi5hY2YyYmFmIDEwMDY0NA0KLS0tIGEvZnMvZXh0NC9zdXBlci5jDQorKysgYi9mcy9leHQ0
L3N1cGVyLmMNCkBAIC04MTksNyArODE5LDcgQEAgc3RhdGljIHZvaWQgZXh0NF9wdXRfc3VwZXIo
c3RydWN0IHN1cGVyX2Jsb2NrICpzYikNCiAJCQlleHQ0X2Fib3J0KHNiLCAiQ291bGRuJ3QgY2xl
YW4gdXAgdGhlIGpvdXJuYWwiKTsNCiAJfQ0KIA0KLQlkZWxfdGltZXIoJnNiaS0+c19lcnJfcmVw
b3J0KTsNCisJZGVsX3RpbWVyX3N5bmMoJnNiaS0+c19lcnJfcmVwb3J0KTsNCiAJZXh0NF9yZWxl
YXNlX3N5c3RlbV96b25lKHNiKTsNCiAJZXh0NF9tYl9yZWxlYXNlKHNiKTsNCiAJZXh0NF9leHRf
cmVsZWFzZShzYik7DQpAQCAtMzk2MSw3ICszOTYxLDcgQEAgZmFpbGVkX21vdW50X3dxOg0KIAkJ
c2JpLT5zX2pvdXJuYWwgPSBOVUxMOw0KIAl9DQogZmFpbGVkX21vdW50MzoNCi0JZGVsX3RpbWVy
KCZzYmktPnNfZXJyX3JlcG9ydCk7DQorCWRlbF90aW1lcl9zeW5jKCZzYmktPnNfZXJyX3JlcG9y
dCk7DQogCWlmIChzYmktPnNfZmxleF9ncm91cHMpDQogCQlleHQ0X2t2ZnJlZShzYmktPnNfZmxl
eF9ncm91cHMpOw0KIAlwZXJjcHVfY291bnRlcl9kZXN0cm95KCZzYmktPnNfZnJlZWNsdXN0ZXJz
X2NvdW50ZXIpOw0KZGlmZiAtLWdpdCBhL2ZzL2hwZnMvZmlsZS5jIGIvZnMvaHBmcy9maWxlLmMN
CmluZGV4IDg5ZDJhNTguLjVlY2ZmZmUgMTAwNjQ0DQotLS0gYS9mcy9ocGZzL2ZpbGUuYw0KKysr
IGIvZnMvaHBmcy9maWxlLmMNCkBAIC0xMTYsOSArMTE2LDEyIEBAIHN0YXRpYyBpbnQgaHBmc193
cml0ZV9iZWdpbihzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBp
bmcsDQogCQkJCWhwZnNfZ2V0X2Jsb2NrLA0KIAkJCQkmaHBmc19pKG1hcHBpbmctPmhvc3QpLT5t
bXVfcHJpdmF0ZSk7DQogCWlmICh1bmxpa2VseShyZXQpKSB7DQotCQlsb2ZmX3QgaXNpemUgPSBt
YXBwaW5nLT5ob3N0LT5pX3NpemU7DQorCQlsb2ZmX3QgaXNpemU7DQorCQlocGZzX2xvY2sobWFw
cGluZy0+aG9zdC0+aV9zYik7DQorCQlpc2l6ZSA9IG1hcHBpbmctPmhvc3QtPmlfc2l6ZTsNCiAJ
CWlmIChwb3MgKyBsZW4gPiBpc2l6ZSkNCiAJCQl2bXRydW5jYXRlKG1hcHBpbmctPmhvc3QsIGlz
aXplKTsNCisJCWhwZnNfdW5sb2NrKG1hcHBpbmctPmhvc3QtPmlfc2IpOw0KIAl9DQogDQogCXJl
dHVybiByZXQ7DQpkaWZmIC0tZ2l0IGEvZnMvbmlsZnMyL3NlZ21lbnQuYyBiL2ZzL25pbGZzMi9z
ZWdtZW50LmMNCmluZGV4IDIzM2QzZWQuLjNjZWFjZWQgMTAwNjQ0DQotLS0gYS9mcy9uaWxmczIv
c2VnbWVudC5jDQorKysgYi9mcy9uaWxmczIvc2VnbWVudC5jDQpAQCAtMTQzNywxNyArMTQzNywx
OSBAQCBzdGF0aWMgaW50IG5pbGZzX3NlZ2N0b3JfY29sbGVjdChzdHJ1Y3QgbmlsZnNfc2NfaW5m
byAqc2NpLA0KIA0KIAkJbmlsZnNfY2xlYXJfbG9ncygmc2NpLT5zY19zZWdidWZzKTsNCiANCi0J
CWVyciA9IG5pbGZzX3NlZ2N0b3JfZXh0ZW5kX3NlZ21lbnRzKHNjaSwgbmlsZnMsIG5hZGQpOw0K
LQkJaWYgKHVubGlrZWx5KGVycikpDQotCQkJcmV0dXJuIGVycjsNCi0NCiAJCWlmIChzY2ktPnNj
X3N0YWdlLmZsYWdzICYgTklMRlNfQ0ZfU1VGUkVFRCkgew0KIAkJCWVyciA9IG5pbGZzX3N1Zmls
ZV9jYW5jZWxfZnJlZXYobmlsZnMtPm5zX3N1ZmlsZSwNCiAJCQkJCQkJc2NpLT5zY19mcmVlc2Vn
cywNCiAJCQkJCQkJc2NpLT5zY19uZnJlZXNlZ3MsDQogCQkJCQkJCU5VTEwpOw0KIAkJCVdBUk5f
T04oZXJyKTsgLyogZG8gbm90IGhhcHBlbiAqLw0KKwkJCXNjaS0+c2Nfc3RhZ2UuZmxhZ3MgJj0g
fk5JTEZTX0NGX1NVRlJFRUQ7DQogCQl9DQorDQorCQllcnIgPSBuaWxmc19zZWdjdG9yX2V4dGVu
ZF9zZWdtZW50cyhzY2ksIG5pbGZzLCBuYWRkKTsNCisJCWlmICh1bmxpa2VseShlcnIpKQ0KKwkJ
CXJldHVybiBlcnI7DQorDQogCQluYWRkID0gbWluX3QoaW50LCBuYWRkIDw8IDEsIFNDX01BWF9T
RUdERUxUQSk7DQogCQlzY2ktPnNjX3N0YWdlID0gcHJldl9zdGFnZTsNCiAJfQ0KZGlmZiAtLWdp
dCBhL2ZzL3hmcy94ZnNfbG9nLmMgYi9mcy94ZnMveGZzX2xvZy5jDQppbmRleCAzNDgxN2FkLi4x
MGNhNWU1IDEwMDY0NA0KLS0tIGEvZnMveGZzL3hmc19sb2cuYw0KKysrIGIvZnMveGZzL3hmc19s
b2cuYw0KQEAgLTY1Myw4ICs2NTMsOSBAQCB4ZnNfbG9nX3VubW91bnRfd3JpdGUoeGZzX21vdW50
X3QgKm1wKQ0KIAkJCQkubHZfaW92ZWNwID0gJnJlZywNCiAJCQl9Ow0KIA0KLQkJCS8qIHJlbW92
ZSBpbml0ZWQgZmxhZyAqLw0KKwkJCS8qIHJlbW92ZSBpbml0ZWQgZmxhZywgYW5kIGFjY291bnQg
Zm9yIHNwYWNlIHVzZWQgKi8NCiAJCQl0aWMtPnRfZmxhZ3MgPSAwOw0KKwkJCXRpYy0+dF9jdXJy
X3JlcyAtPSBzaXplb2YobWFnaWMpOw0KIAkJCWVycm9yID0geGxvZ193cml0ZShsb2csICZ2ZWMs
IHRpYywgJmxzbiwNCiAJCQkJCSAgIE5VTEwsIFhMT0dfVU5NT1VOVF9UUkFOUyk7DQogCQkJLyoN
CmRpZmYgLS1naXQgYS9pbmNsdWRlL2RybS9kcm1fcGNpaWRzLmggYi9pbmNsdWRlL2RybS9kcm1f
cGNpaWRzLmgNCmluZGV4IGRlZjgwN2MuLmMzN2ZkODkgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2Ry
bS9kcm1fcGNpaWRzLmgNCisrKyBiL2luY2x1ZGUvZHJtL2RybV9wY2lpZHMuaA0KQEAgLTQ5NSw3
ICs0OTUsNyBAQA0KIAl7MHgxMDAyLCAweDk2NDUsIFBDSV9BTllfSUQsIFBDSV9BTllfSUQsIDAs
IDAsIENISVBfU1VNTzJ8UkFERU9OX0lTX01PQklMSVRZfFJBREVPTl9ORVdfTUVNTUFQfFJBREVP
Tl9JU19JR1B9LCBcDQogCXsweDEwMDIsIDB4OTY0NywgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwg
MCwgMCwgQ0hJUF9TVU1PfFJBREVPTl9JU19NT0JJTElUWXxSQURFT05fTkVXX01FTU1BUHxSQURF
T05fSVNfSUdQfSxcDQogCXsweDEwMDIsIDB4OTY0OCwgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwg
MCwgMCwgQ0hJUF9TVU1PfFJBREVPTl9JU19NT0JJTElUWXxSQURFT05fTkVXX01FTU1BUHxSQURF
T05fSVNfSUdQfSxcDQotCXsweDEwMDIsIDB4OTY0OSwgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwg
MCwgMCwgQ0hJUF9TVU1PfFJBREVPTl9JU19NT0JJTElUWXxSQURFT05fTkVXX01FTU1BUHxSQURF
T05fSVNfSUdQfSxcDQorCXsweDEwMDIsIDB4OTY0OSwgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwg
MCwgMCwgQ0hJUF9TVU1PMnxSQURFT05fSVNfTU9CSUxJVFl8UkFERU9OX05FV19NRU1NQVB8UkFE
RU9OX0lTX0lHUH0sXA0KIAl7MHgxMDAyLCAweDk2NGEsIFBDSV9BTllfSUQsIFBDSV9BTllfSUQs
IDAsIDAsIENISVBfU1VNT3xSQURFT05fTkVXX01FTU1BUHxSQURFT05fSVNfSUdQfSwgXA0KIAl7
MHgxMDAyLCAweDk2NGIsIFBDSV9BTllfSUQsIFBDSV9BTllfSUQsIDAsIDAsIENISVBfU1VNT3xS
QURFT05fTkVXX01FTU1BUHxSQURFT05fSVNfSUdQfSwgXA0KIAl7MHgxMDAyLCAweDk2NGMsIFBD
SV9BTllfSUQsIFBDSV9BTllfSUQsIDAsIDAsIENISVBfU1VNT3xSQURFT05fTkVXX01FTU1BUHxS
QURFT05fSVNfSUdQfSwgXA0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvaHVnZXRsYi5oIGIv
aW5jbHVkZS9saW51eC9odWdldGxiLmgNCmluZGV4IDMyNjk3YzEuLjRiYzk0NDUgMTAwNjQ0DQot
LS0gYS9pbmNsdWRlL2xpbnV4L2h1Z2V0bGIuaA0KKysrIGIvaW5jbHVkZS9saW51eC9odWdldGxi
LmgNCkBAIC0yNCw2ICsyNCw3IEBAIHN0cnVjdCBodWdlcGFnZV9zdWJwb29sICpodWdlcGFnZV9u
ZXdfc3VicG9vbChsb25nIG5yX2Jsb2Nrcyk7DQogdm9pZCBodWdlcGFnZV9wdXRfc3VicG9vbChz
dHJ1Y3QgaHVnZXBhZ2Vfc3VicG9vbCAqc3Bvb2wpOw0KIA0KIGludCBQYWdlSHVnZShzdHJ1Y3Qg
cGFnZSAqcGFnZSk7DQoraW50IFBhZ2VIZWFkSHVnZShzdHJ1Y3QgcGFnZSAqcGFnZV9oZWFkKTsN
CiANCiB2b2lkIHJlc2V0X3ZtYV9yZXN2X2h1Z2VfcGFnZXMoc3RydWN0IHZtX2FyZWFfc3RydWN0
ICp2bWEpOw0KIGludCBodWdldGxiX3N5c2N0bF9oYW5kbGVyKHN0cnVjdCBjdGxfdGFibGUgKiwg
aW50LCB2b2lkIF9fdXNlciAqLCBzaXplX3QgKiwgbG9mZl90ICopOw0KQEAgLTg4LDYgKzg5LDEx
IEBAIHN0YXRpYyBpbmxpbmUgaW50IFBhZ2VIdWdlKHN0cnVjdCBwYWdlICpwYWdlKQ0KIAlyZXR1
cm4gMDsNCiB9DQogDQorc3RhdGljIGlubGluZSBpbnQgUGFnZUhlYWRIdWdlKHN0cnVjdCBwYWdl
ICpwYWdlX2hlYWQpDQorew0KKwlyZXR1cm4gMDsNCit9DQorDQogc3RhdGljIGlubGluZSB2b2lk
IHJlc2V0X3ZtYV9yZXN2X2h1Z2VfcGFnZXMoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpDQog
ew0KIH0NCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L25ldGRldmljZS5oIGIvaW5jbHVkZS9s
aW51eC9uZXRkZXZpY2UuaA0KaW5kZXggOGM0M2ZkMS4uNGIwNDA5NyAxMDA2NDQNCi0tLSBhL2lu
Y2x1ZGUvbGludXgvbmV0ZGV2aWNlLmgNCisrKyBiL2luY2x1ZGUvbGludXgvbmV0ZGV2aWNlLmgN
CkBAIC0xNzE5LDYgKzE3MTksMTUgQEAgc3RhdGljIGlubGluZSBpbnQgZGV2X3BhcnNlX2hlYWRl
cihjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIAlyZXR1cm4gZGV2LT5oZWFkZXJfb3BzLT5w
YXJzZShza2IsIGhhZGRyKTsNCiB9DQogDQorc3RhdGljIGlubGluZSBpbnQgZGV2X3JlYnVpbGRf
aGVhZGVyKHN0cnVjdCBza19idWZmICpza2IpDQorew0KKwljb25zdCBzdHJ1Y3QgbmV0X2Rldmlj
ZSAqZGV2ID0gc2tiLT5kZXY7DQorDQorCWlmICghZGV2LT5oZWFkZXJfb3BzIHx8ICFkZXYtPmhl
YWRlcl9vcHMtPnJlYnVpbGQpDQorCQlyZXR1cm4gMDsNCisJcmV0dXJuIGRldi0+aGVhZGVyX29w
cy0+cmVidWlsZChza2IpOw0KK30NCisNCiB0eXBlZGVmIGludCBnaWZjb25mX2Z1bmNfdChzdHJ1
Y3QgbmV0X2RldmljZSAqIGRldiwgY2hhciBfX3VzZXIgKiBidWZwdHIsIGludCBsZW4pOw0KIGV4
dGVybiBpbnQJCXJlZ2lzdGVyX2dpZmNvbmYodW5zaWduZWQgaW50IGZhbWlseSwgZ2lmY29uZl9m
dW5jX3QgKiBnaWZjb25mKTsNCiBzdGF0aWMgaW5saW5lIGludCB1bnJlZ2lzdGVyX2dpZmNvbmYo
dW5zaWduZWQgaW50IGZhbWlseSkNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3BjaS5oIGIv
aW5jbHVkZS9saW51eC9wY2kuaA0KaW5kZXggN2NkYTY1Yi4uZmU3NmE3NCAxMDA2NDQNCi0tLSBh
L2luY2x1ZGUvbGludXgvcGNpLmgNCisrKyBiL2luY2x1ZGUvbGludXgvcGNpLmgNCkBAIC01OTAs
NiArNTkwLDIwIEBAIHN0cnVjdCBwY2lfZHJpdmVyIHsNCiAJLnN1YnZlbmRvciA9IFBDSV9BTllf
SUQsIC5zdWJkZXZpY2UgPSBQQ0lfQU5ZX0lEDQogDQogLyoqDQorICogUENJX0RFVklDRV9TVUIg
LSBtYWNybyB1c2VkIHRvIGRlc2NyaWJlIGEgc3BlY2lmaWMgcGNpIGRldmljZSB3aXRoIHN1YnN5
c3RlbQ0KKyAqIEB2ZW5kOiB0aGUgMTYgYml0IFBDSSBWZW5kb3IgSUQNCisgKiBAZGV2OiB0aGUg
MTYgYml0IFBDSSBEZXZpY2UgSUQNCisgKiBAc3VidmVuZDogdGhlIDE2IGJpdCBQQ0kgU3VidmVu
ZG9yIElEDQorICogQHN1YmRldjogdGhlIDE2IGJpdCBQQ0kgU3ViZGV2aWNlIElEDQorICoNCisg
KiBUaGlzIG1hY3JvIGlzIHVzZWQgdG8gY3JlYXRlIGEgc3RydWN0IHBjaV9kZXZpY2VfaWQgdGhh
dCBtYXRjaGVzIGENCisgKiBzcGVjaWZpYyBkZXZpY2Ugd2l0aCBzdWJzeXN0ZW0gaW5mb3JtYXRp
b24uDQorICovDQorI2RlZmluZSBQQ0lfREVWSUNFX1NVQih2ZW5kLCBkZXYsIHN1YnZlbmQsIHN1
YmRldikgXA0KKwkudmVuZG9yID0gKHZlbmQpLCAuZGV2aWNlID0gKGRldiksIFwNCisJLnN1YnZl
bmRvciA9IChzdWJ2ZW5kKSwgLnN1YmRldmljZSA9IChzdWJkZXYpDQorDQorLyoqDQogICogUENJ
X0RFVklDRV9DTEFTUyAtIG1hY3JvIHVzZWQgdG8gZGVzY3JpYmUgYSBzcGVjaWZpYyBwY2kgZGV2
aWNlIGNsYXNzDQogICogQGRldl9jbGFzczogdGhlIGNsYXNzLCBzdWJjbGFzcywgcHJvZy1pZiB0
cmlwbGUgZm9yIHRoaXMgZGV2aWNlDQogICogQGRldl9jbGFzc19tYXNrOiB0aGUgY2xhc3MgbWFz
ayBmb3IgdGhpcyBkZXZpY2UNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3NjaGVkLmggYi9p
bmNsdWRlL2xpbnV4L3NjaGVkLmgNCmluZGV4IDMxMmQwNDcuLmMxN2ZkZmIgMTAwNjQ0DQotLS0g
YS9pbmNsdWRlL2xpbnV4L3NjaGVkLmgNCisrKyBiL2luY2x1ZGUvbGludXgvc2NoZWQuaA0KQEAg
LTEyMDAsNiArMTIwMCw3IEBAIHN0cnVjdCBzY2hlZF9lbnRpdHkgew0KIHN0cnVjdCBzY2hlZF9y
dF9lbnRpdHkgew0KIAlzdHJ1Y3QgbGlzdF9oZWFkIHJ1bl9saXN0Ow0KIAl1bnNpZ25lZCBsb25n
IHRpbWVvdXQ7DQorCXVuc2lnbmVkIGxvbmcgd2F0Y2hkb2dfc3RhbXA7DQogCXVuc2lnbmVkIGlu
dCB0aW1lX3NsaWNlOw0KIAlpbnQgbnJfY3B1c19hbGxvd2VkOw0KIA0KZGlmZiAtLWdpdCBhL2tl
cm5lbC9zY2hlZC5jIGIva2VybmVsL3NjaGVkLmMNCmluZGV4IGQ5MzM2OWEuLmVhODViMGQgMTAw
NjQ0DQotLS0gYS9rZXJuZWwvc2NoZWQuYw0KKysrIGIva2VybmVsL3NjaGVkLmMNCkBAIC0yMTg5
LDYgKzIxODksMTAgQEAgc3RhdGljIGludCBpcnF0aW1lX2FjY291bnRfc2lfdXBkYXRlKHZvaWQp
DQogDQogI2VuZGlmDQogDQorI2lmZGVmIENPTkZJR19TTVANCitzdGF0aWMgdm9pZCB1bnRocm90
dGxlX29mZmxpbmVfY2ZzX3JxcyhzdHJ1Y3QgcnEgKnJxKTsNCisjZW5kaWYNCisNCiAjaW5jbHVk
ZSAic2NoZWRfaWRsZXRhc2suYyINCiAjaW5jbHVkZSAic2NoZWRfZmFpci5jIg0KICNpbmNsdWRl
ICJzY2hlZF9ydC5jIg0KQEAgLTY1NjYsOCArNjU3MCw2IEBAIHN0YXRpYyB2b2lkIHVudGhyb3R0
bGVfb2ZmbGluZV9jZnNfcnFzKHN0cnVjdCBycSAqcnEpDQogCQkJdW50aHJvdHRsZV9jZnNfcnEo
Y2ZzX3JxKTsNCiAJfQ0KIH0NCi0jZWxzZQ0KLXN0YXRpYyB2b2lkIHVudGhyb3R0bGVfb2ZmbGlu
ZV9jZnNfcnFzKHN0cnVjdCBycSAqcnEpIHt9DQogI2VuZGlmDQogDQogLyoNCkBAIC02NTk1LDkg
KzY1OTcsNiBAQCBzdGF0aWMgdm9pZCBtaWdyYXRlX3Rhc2tzKHVuc2lnbmVkIGludCBkZWFkX2Nw
dSkNCiAJICovDQogCXJxLT5zdG9wID0gTlVMTDsNCiANCi0JLyogRW5zdXJlIGFueSB0aHJvdHRs
ZWQgZ3JvdXBzIGFyZSByZWFjaGFibGUgYnkgcGlja19uZXh0X3Rhc2sgKi8NCi0JdW50aHJvdHRs
ZV9vZmZsaW5lX2Nmc19ycXMocnEpOw0KLQ0KIAlmb3IgKCA7IDsgKSB7DQogCQkvKg0KIAkJICog
VGhlcmUncyB0aGlzIHRocmVhZCBydW5uaW5nLCBiYWlsIHdoZW4gdGhhdCdzIHRoZSBvbmx5DQpA
QCAtNjYyNCw2ICs2NjIzLDEwIEBAIHN0YXRpYyB2b2lkIG1pZ3JhdGVfdGFza3ModW5zaWduZWQg
aW50IGRlYWRfY3B1KQ0KIA0KICNlbmRpZiAvKiBDT05GSUdfSE9UUExVR19DUFUgKi8NCiANCisj
aWYgIWRlZmluZWQoQ09ORklHX0hPVFBMVUdfQ1BVKSB8fCAhZGVmaW5lZChDT05GSUdfQ0ZTX0JB
TkRXSURUSCkNCitzdGF0aWMgdm9pZCB1bnRocm90dGxlX29mZmxpbmVfY2ZzX3JxcyhzdHJ1Y3Qg
cnEgKnJxKSB7fQ0KKyNlbmRpZg0KKw0KICNpZiBkZWZpbmVkKENPTkZJR19TQ0hFRF9ERUJVRykg
JiYgZGVmaW5lZChDT05GSUdfU1lTQ1RMKQ0KIA0KIHN0YXRpYyBzdHJ1Y3QgY3RsX3RhYmxlIHNk
X2N0bF9kaXJbXSA9IHsNCmRpZmYgLS1naXQgYS9rZXJuZWwvc2NoZWRfZmFpci5jIGIva2VybmVs
L3NjaGVkX2ZhaXIuYw0KaW5kZXggNWI5ZTQ1Ni4uMzdmM2YzOSAxMDA2NDQNCi0tLSBhL2tlcm5l
bC9zY2hlZF9mYWlyLmMNCisrKyBiL2tlcm5lbC9zY2hlZF9mYWlyLmMNCkBAIC00ODQ4LDYgKzQ4
NDgsOSBAQCBzdGF0aWMgdm9pZCBycV9vbmxpbmVfZmFpcihzdHJ1Y3QgcnEgKnJxKQ0KIHN0YXRp
YyB2b2lkIHJxX29mZmxpbmVfZmFpcihzdHJ1Y3QgcnEgKnJxKQ0KIHsNCiAJdXBkYXRlX3N5c2N0
bCgpOw0KKw0KKwkvKiBFbnN1cmUgYW55IHRocm90dGxlZCBncm91cHMgYXJlIHJlYWNoYWJsZSBi
eSBwaWNrX25leHRfdGFzayAqLw0KKwl1bnRocm90dGxlX29mZmxpbmVfY2ZzX3JxcyhycSk7DQog
fQ0KIA0KICNlbHNlCS8qIENPTkZJR19TTVAgKi8NCmRpZmYgLS1naXQgYS9rZXJuZWwvc2NoZWRf
cnQuYyBiL2tlcm5lbC9zY2hlZF9ydC5jDQppbmRleCA2YWQ0ZmIzLi5mNTdmZGE3IDEwMDY0NA0K
LS0tIGEva2VybmVsL3NjaGVkX3J0LmMNCisrKyBiL2tlcm5lbC9zY2hlZF9ydC5jDQpAQCAtNTA5
LDYgKzUwOSw3IEBAIGJhbGFuY2VkOg0KIAkJICogcnVudGltZSAtIGluIHdoaWNoIGNhc2UgYm9y
cm93aW5nIGRvZXNuJ3QgbWFrZSBzZW5zZS4NCiAJCSAqLw0KIAkJcnRfcnEtPnJ0X3J1bnRpbWUg
PSBSVU5USU1FX0lORjsNCisJCXJ0X3JxLT5ydF90aHJvdHRsZWQgPSAwOw0KIAkJcmF3X3NwaW5f
dW5sb2NrKCZydF9ycS0+cnRfcnVudGltZV9sb2NrKTsNCiAJCXJhd19zcGluX3VubG9jaygmcnRf
Yi0+cnRfcnVudGltZV9sb2NrKTsNCiAJfQ0KQEAgLTU4Nyw2ICs1ODgsMTkgQEAgc3RhdGljIGlu
dCBkb19zY2hlZF9ydF9wZXJpb2RfdGltZXIoc3RydWN0IHJ0X2JhbmR3aWR0aCAqcnRfYiwgaW50
IG92ZXJydW4pDQogCQlyZXR1cm4gMTsNCiANCiAJc3BhbiA9IHNjaGVkX3J0X3BlcmlvZF9tYXNr
KCk7DQorI2lmZGVmIENPTkZJR19SVF9HUk9VUF9TQ0hFRA0KKwkvKg0KKwkgKiBGSVhNRTogaXNv
bGF0ZWQgQ1BVcyBzaG91bGQgcmVhbGx5IGxlYXZlIHRoZSByb290IHRhc2sgZ3JvdXAsDQorCSAq
IHdoZXRoZXIgdGhleSBhcmUgaXNvbGNwdXMgb3Igd2VyZSBpc29sYXRlZCB2aWEgY3B1c2V0cywg
bGVzdA0KKwkgKiB0aGUgdGltZXIgcnVuIG9uIGEgQ1BVIHdoaWNoIGRvZXMgbm90IHNlcnZpY2Ug
YWxsIHJ1bnF1ZXVlcywNCisJICogcG90ZW50aWFsbHkgbGVhdmluZyBvdGhlciBDUFVzIGluZGVm
aW5pdGVseSB0aHJvdHRsZWQuICBJZg0KKwkgKiBpc29sYXRpb24gaXMgcmVhbGx5IHJlcXVpcmVk
LCB0aGUgdXNlciB3aWxsIHR1cm4gdGhlIHRocm90dGxlDQorCSAqIG9mZiB0byBraWxsIHRoZSBw
ZXJ0dXJiYXRpb25zIGl0IGNhdXNlcyBhbnl3YXkuICBNZWFud2hpbGUsDQorCSAqIHRoaXMgbWFp
bnRhaW5zIGZ1bmN0aW9uYWxpdHkgZm9yIGJvb3QgYW5kL29yIHRyb3VibGVzaG9vdGluZy4NCisJ
ICovDQorCWlmIChydF9iID09ICZyb290X3Rhc2tfZ3JvdXAucnRfYmFuZHdpZHRoKQ0KKwkJc3Bh
biA9IGNwdV9vbmxpbmVfbWFzazsNCisjZW5kaWYNCiAJZm9yX2VhY2hfY3B1KGksIHNwYW4pIHsN
CiAJCWludCBlbnF1ZXVlID0gMDsNCiAJCXN0cnVjdCBydF9ycSAqcnRfcnEgPSBzY2hlZF9ydF9w
ZXJpb2RfcnRfcnEocnRfYiwgaSk7DQpAQCAtNzE5LDYgKzczMywxMyBAQCBpbmNfcnRfcHJpb19z
bXAoc3RydWN0IHJ0X3JxICpydF9ycSwgaW50IHByaW8sIGludCBwcmV2X3ByaW8pDQogew0KIAlz
dHJ1Y3QgcnEgKnJxID0gcnFfb2ZfcnRfcnEocnRfcnEpOw0KIA0KKyNpZmRlZiBDT05GSUdfUlRf
R1JPVVBfU0NIRUQNCisJLyoNCisJICogQ2hhbmdlIHJxJ3MgY3B1cHJpIG9ubHkgaWYgcnRfcnEg
aXMgdGhlIHRvcCBxdWV1ZS4NCisJICovDQorCWlmICgmcnEtPnJ0ICE9IHJ0X3JxKQ0KKwkJcmV0
dXJuOw0KKyNlbmRpZg0KIAlpZiAocnEtPm9ubGluZSAmJiBwcmlvIDwgcHJldl9wcmlvKQ0KIAkJ
Y3B1cHJpX3NldCgmcnEtPnJkLT5jcHVwcmksIHJxLT5jcHUsIHByaW8pOw0KIH0NCkBAIC03Mjgs
NiArNzQ5LDEzIEBAIGRlY19ydF9wcmlvX3NtcChzdHJ1Y3QgcnRfcnEgKnJ0X3JxLCBpbnQgcHJp
bywgaW50IHByZXZfcHJpbykNCiB7DQogCXN0cnVjdCBycSAqcnEgPSBycV9vZl9ydF9ycShydF9y
cSk7DQogDQorI2lmZGVmIENPTkZJR19SVF9HUk9VUF9TQ0hFRA0KKwkvKg0KKwkgKiBDaGFuZ2Ug
cnEncyBjcHVwcmkgb25seSBpZiBydF9ycSBpcyB0aGUgdG9wIHF1ZXVlLg0KKwkgKi8NCisJaWYg
KCZycS0+cnQgIT0gcnRfcnEpDQorCQlyZXR1cm47DQorI2VuZGlmDQogCWlmIChycS0+b25saW5l
ICYmIHJ0X3JxLT5oaWdoZXN0X3ByaW8uY3VyciAhPSBwcmV2X3ByaW8pDQogCQljcHVwcmlfc2V0
KCZycS0+cmQtPmNwdXByaSwgcnEtPmNwdSwgcnRfcnEtPmhpZ2hlc3RfcHJpby5jdXJyKTsNCiB9
DQpAQCAtMTc0OSw3ICsxNzc3LDExIEBAIHN0YXRpYyB2b2lkIHdhdGNoZG9nKHN0cnVjdCBycSAq
cnEsIHN0cnVjdCB0YXNrX3N0cnVjdCAqcCkNCiAJaWYgKHNvZnQgIT0gUkxJTV9JTkZJTklUWSkg
ew0KIAkJdW5zaWduZWQgbG9uZyBuZXh0Ow0KIA0KLQkJcC0+cnQudGltZW91dCsrOw0KKwkJaWYg
KHAtPnJ0LndhdGNoZG9nX3N0YW1wICE9IGppZmZpZXMpIHsNCisJCQlwLT5ydC50aW1lb3V0Kys7
DQorCQkJcC0+cnQud2F0Y2hkb2dfc3RhbXAgPSBqaWZmaWVzOw0KKwkJfQ0KKw0KIAkJbmV4dCA9
IERJVl9ST1VORF9VUChtaW4oc29mdCwgaGFyZCksIFVTRUNfUEVSX1NFQy9IWik7DQogCQlpZiAo
cC0+cnQudGltZW91dCA+IG5leHQpDQogCQkJcC0+Y3B1dGltZV9leHBpcmVzLnNjaGVkX2V4cCA9
IHAtPnNlLnN1bV9leGVjX3J1bnRpbWU7DQpAQCAtMTc1OCw2ICsxNzkwLDggQEAgc3RhdGljIHZv
aWQgd2F0Y2hkb2coc3RydWN0IHJxICpycSwgc3RydWN0IHRhc2tfc3RydWN0ICpwKQ0KIA0KIHN0
YXRpYyB2b2lkIHRhc2tfdGlja19ydChzdHJ1Y3QgcnEgKnJxLCBzdHJ1Y3QgdGFza19zdHJ1Y3Qg
KnAsIGludCBxdWV1ZWQpDQogew0KKwlzdHJ1Y3Qgc2NoZWRfcnRfZW50aXR5ICpydF9zZSA9ICZw
LT5ydDsNCisNCiAJdXBkYXRlX2N1cnJfcnQocnEpOw0KIA0KIAl3YXRjaGRvZyhycSwgcCk7DQpA
QCAtMTc3NSwxMiArMTgwOSwxNSBAQCBzdGF0aWMgdm9pZCB0YXNrX3RpY2tfcnQoc3RydWN0IHJx
ICpycSwgc3RydWN0IHRhc2tfc3RydWN0ICpwLCBpbnQgcXVldWVkKQ0KIAlwLT5ydC50aW1lX3Ns
aWNlID0gREVGX1RJTUVTTElDRTsNCiANCiAJLyoNCi0JICogUmVxdWV1ZSB0byB0aGUgZW5kIG9m
IHF1ZXVlIGlmIHdlIGFyZSBub3QgdGhlIG9ubHkgZWxlbWVudA0KLQkgKiBvbiB0aGUgcXVldWU6
DQorCSAqIFJlcXVldWUgdG8gdGhlIGVuZCBvZiBxdWV1ZSBpZiB3ZSAoYW5kIGFsbCBvZiBvdXIg
YW5jZXN0b3JzKSBhcmUgdGhlDQorCSAqIG9ubHkgZWxlbWVudCBvbiB0aGUgcXVldWUNCiAJICov
DQotCWlmIChwLT5ydC5ydW5fbGlzdC5wcmV2ICE9IHAtPnJ0LnJ1bl9saXN0Lm5leHQpIHsNCi0J
CXJlcXVldWVfdGFza19ydChycSwgcCwgMCk7DQotCQlzZXRfdHNrX25lZWRfcmVzY2hlZChwKTsN
CisJZm9yX2VhY2hfc2NoZWRfcnRfZW50aXR5KHJ0X3NlKSB7DQorCQlpZiAocnRfc2UtPnJ1bl9s
aXN0LnByZXYgIT0gcnRfc2UtPnJ1bl9saXN0Lm5leHQpIHsNCisJCQlyZXF1ZXVlX3Rhc2tfcnQo
cnEsIHAsIDApOw0KKwkJCXNldF90c2tfbmVlZF9yZXNjaGVkKHApOw0KKwkJCXJldHVybjsNCisJ
CX0NCiAJfQ0KIH0NCiANCmRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvZnRyYWNlLmMgYi9rZXJu
ZWwvdHJhY2UvZnRyYWNlLmMNCmluZGV4IGQ0MGQ3ZjYuLmNmOGI0MzkgMTAwNjQ0DQotLS0gYS9r
ZXJuZWwvdHJhY2UvZnRyYWNlLmMNCisrKyBiL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KQEAgLTYx
OCw3ICs2MTgsNyBAQCBzdGF0aWMgaW50IGZ0cmFjZV9wcm9maWxlX2luaXQodm9pZCkNCiAJaW50
IGNwdTsNCiAJaW50IHJldCA9IDA7DQogDQotCWZvcl9lYWNoX29ubGluZV9jcHUoY3B1KSB7DQor
CWZvcl9lYWNoX3Bvc3NpYmxlX2NwdShjcHUpIHsNCiAJCXJldCA9IGZ0cmFjZV9wcm9maWxlX2lu
aXRfY3B1KGNwdSk7DQogCQlpZiAocmV0KQ0KIAkJCWJyZWFrOw0KZGlmZiAtLWdpdCBhL21tL2h1
Z2V0bGIuYyBiL21tL2h1Z2V0bGIuYw0KaW5kZXggZGRmMjEyOC4uM2E1YWFlMiAxMDA2NDQNCi0t
LSBhL21tL2h1Z2V0bGIuYw0KKysrIGIvbW0vaHVnZXRsYi5jDQpAQCAtNjc5LDYgKzY3OSwyMyBA
QCBpbnQgUGFnZUh1Z2Uoc3RydWN0IHBhZ2UgKnBhZ2UpDQogfQ0KIEVYUE9SVF9TWU1CT0xfR1BM
KFBhZ2VIdWdlKTsNCiANCisvKg0KKyAqIFBhZ2VIZWFkSHVnZSgpIG9ubHkgcmV0dXJucyB0cnVl
IGZvciBodWdldGxiZnMgaGVhZCBwYWdlLCBidXQgbm90IGZvcg0KKyAqIG5vcm1hbCBvciB0cmFu
c3BhcmVudCBodWdlIHBhZ2VzLg0KKyAqLw0KK2ludCBQYWdlSGVhZEh1Z2Uoc3RydWN0IHBhZ2Ug
KnBhZ2VfaGVhZCkNCit7DQorCWNvbXBvdW5kX3BhZ2VfZHRvciAqZHRvcjsNCisNCisJaWYgKCFQ
YWdlSGVhZChwYWdlX2hlYWQpKQ0KKwkJcmV0dXJuIDA7DQorDQorCWR0b3IgPSBnZXRfY29tcG91
bmRfcGFnZV9kdG9yKHBhZ2VfaGVhZCk7DQorDQorCXJldHVybiBkdG9yID09IGZyZWVfaHVnZV9w
YWdlOw0KK30NCitFWFBPUlRfU1lNQk9MX0dQTChQYWdlSGVhZEh1Z2UpOw0KKw0KIHBnb2ZmX3Qg
X19iYXNlcGFnZV9pbmRleChzdHJ1Y3QgcGFnZSAqcGFnZSkNCiB7DQogCXN0cnVjdCBwYWdlICpw
YWdlX2hlYWQgPSBjb21wb3VuZF9oZWFkKHBhZ2UpOw0KZGlmZiAtLWdpdCBhL21tL21lbW9yeS1m
YWlsdXJlLmMgYi9tbS9tZW1vcnktZmFpbHVyZS5jDQppbmRleCAxYjAzODc4Li45NmM0YmNmIDEw
MDY0NA0KLS0tIGEvbW0vbWVtb3J5LWZhaWx1cmUuYw0KKysrIGIvbW0vbWVtb3J5LWZhaWx1cmUu
Yw0KQEAgLTE0NDEsMTAgKzE0NDEsMTggQEAgc3RhdGljIGludCBzb2Z0X29mZmxpbmVfaHVnZV9w
YWdlKHN0cnVjdCBwYWdlICpwYWdlLCBpbnQgZmxhZ3MpDQogCQlyZXR1cm4gcmV0Ow0KIAl9DQog
ZG9uZToNCi0JaWYgKCFQYWdlSFdQb2lzb24oaHBhZ2UpKQ0KLQkJYXRvbWljX2xvbmdfYWRkKDEg
PDwgY29tcG91bmRfdHJhbnNfb3JkZXIoaHBhZ2UpLCAmbWNlX2JhZF9wYWdlcyk7DQotCXNldF9w
YWdlX2h3cG9pc29uX2h1Z2VfcGFnZShocGFnZSk7DQotCWRlcXVldWVfaHdwb2lzb25lZF9odWdl
X3BhZ2UoaHBhZ2UpOw0KKwkvKiBvdmVyY29tbWl0IGh1Z2V0bGIgcGFnZSB3aWxsIGJlIGZyZWVk
IHRvIGJ1ZGR5ICovDQorCWlmIChQYWdlSHVnZShocGFnZSkpIHsNCisJCWlmICghUGFnZUhXUG9p
c29uKGhwYWdlKSkNCisJCQlhdG9taWNfbG9uZ19hZGQoMSA8PCBjb21wb3VuZF90cmFuc19vcmRl
cihocGFnZSksDQorCQkJCQkmbWNlX2JhZF9wYWdlcyk7DQorCQlzZXRfcGFnZV9od3BvaXNvbl9o
dWdlX3BhZ2UoaHBhZ2UpOw0KKwkJZGVxdWV1ZV9od3BvaXNvbmVkX2h1Z2VfcGFnZShocGFnZSk7
DQorCX0gZWxzZSB7DQorCQlTZXRQYWdlSFdQb2lzb24ocGFnZSk7DQorCQlhdG9taWNfbG9uZ19p
bmMoJm1jZV9iYWRfcGFnZXMpOw0KKwl9DQorDQogCS8qIGtlZXAgZWxldmF0ZWQgcGFnZSBjb3Vu
dCBmb3IgYmFkIHBhZ2UgKi8NCiAJcmV0dXJuIHJldDsNCiB9DQpkaWZmIC0tZ2l0IGEvbW0vbW1h
cC5jIGIvbW0vbW1hcC5jDQppbmRleCBkZmYzN2E2Li42MTgyYzhhIDEwMDY0NA0KLS0tIGEvbW0v
bW1hcC5jDQorKysgYi9tbS9tbWFwLmMNCkBAIC0xMzY4LDcgKzEzNjgsNyBAQCBhcmNoX2dldF91
bm1hcHBlZF9hcmVhKHN0cnVjdCBmaWxlICpmaWxwLCB1bnNpZ25lZCBsb25nIGFkZHIsDQogCXN0
cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hOw0KIAl1bnNpZ25lZCBsb25nIHN0YXJ0X2FkZHI7DQog
DQotCWlmIChsZW4gPiBUQVNLX1NJWkUpDQorCWlmIChsZW4gPiBUQVNLX1NJWkUgLSBtbWFwX21p
bl9hZGRyKQ0KIAkJcmV0dXJuIC1FTk9NRU07DQogDQogCWlmIChmbGFncyAmIE1BUF9GSVhFRCkN
CkBAIC0xMzc3LDcgKzEzNzcsNyBAQCBhcmNoX2dldF91bm1hcHBlZF9hcmVhKHN0cnVjdCBmaWxl
ICpmaWxwLCB1bnNpZ25lZCBsb25nIGFkZHIsDQogCWlmIChhZGRyKSB7DQogCQlhZGRyID0gUEFH
RV9BTElHTihhZGRyKTsNCiAJCXZtYSA9IGZpbmRfdm1hKG1tLCBhZGRyKTsNCi0JCWlmIChUQVNL
X1NJWkUgLSBsZW4gPj0gYWRkciAmJg0KKwkJaWYgKFRBU0tfU0laRSAtIGxlbiA+PSBhZGRyICYm
IGFkZHIgPj0gbW1hcF9taW5fYWRkciAmJg0KIAkJICAgICghdm1hIHx8IGFkZHIgKyBsZW4gPD0g
dm1hLT52bV9zdGFydCkpDQogCQkJcmV0dXJuIGFkZHI7DQogCX0NCkBAIC0xNDQyLDkgKzE0NDIs
MTAgQEAgYXJjaF9nZXRfdW5tYXBwZWRfYXJlYV90b3Bkb3duKHN0cnVjdCBmaWxlICpmaWxwLCBj
b25zdCB1bnNpZ25lZCBsb25nIGFkZHIwLA0KIAlzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYTsN
CiAJc3RydWN0IG1tX3N0cnVjdCAqbW0gPSBjdXJyZW50LT5tbTsNCiAJdW5zaWduZWQgbG9uZyBh
ZGRyID0gYWRkcjA7DQorCXVuc2lnbmVkIGxvbmcgbG93X2xpbWl0ID0gbWF4KFBBR0VfU0laRSwg
bW1hcF9taW5fYWRkcik7DQogDQogCS8qIHJlcXVlc3RlZCBsZW5ndGggdG9vIGJpZyBmb3IgZW50
aXJlIGFkZHJlc3Mgc3BhY2UgKi8NCi0JaWYgKGxlbiA+IFRBU0tfU0laRSkNCisJaWYgKGxlbiA+
IFRBU0tfU0laRSAtIG1tYXBfbWluX2FkZHIpDQogCQlyZXR1cm4gLUVOT01FTTsNCiANCiAJaWYg
KGZsYWdzICYgTUFQX0ZJWEVEKQ0KQEAgLTE0NTQsNyArMTQ1NSw3IEBAIGFyY2hfZ2V0X3VubWFw
cGVkX2FyZWFfdG9wZG93bihzdHJ1Y3QgZmlsZSAqZmlscCwgY29uc3QgdW5zaWduZWQgbG9uZyBh
ZGRyMCwNCiAJaWYgKGFkZHIpIHsNCiAJCWFkZHIgPSBQQUdFX0FMSUdOKGFkZHIpOw0KIAkJdm1h
ID0gZmluZF92bWEobW0sIGFkZHIpOw0KLQkJaWYgKFRBU0tfU0laRSAtIGxlbiA+PSBhZGRyICYm
DQorCQlpZiAoVEFTS19TSVpFIC0gbGVuID49IGFkZHIgJiYgYWRkciA+PSBtbWFwX21pbl9hZGRy
ICYmDQogCQkJCSghdm1hIHx8IGFkZHIgKyBsZW4gPD0gdm1hLT52bV9zdGFydCkpDQogCQkJcmV0
dXJuIGFkZHI7DQogCX0NCkBAIC0xNDY5LDE0ICsxNDcwLDE0IEBAIGFyY2hfZ2V0X3VubWFwcGVk
X2FyZWFfdG9wZG93bihzdHJ1Y3QgZmlsZSAqZmlscCwgY29uc3QgdW5zaWduZWQgbG9uZyBhZGRy
MCwNCiAJYWRkciA9IG1tLT5mcmVlX2FyZWFfY2FjaGU7DQogDQogCS8qIG1ha2Ugc3VyZSBpdCBj
YW4gZml0IGluIHRoZSByZW1haW5pbmcgYWRkcmVzcyBzcGFjZSAqLw0KLQlpZiAoYWRkciA+IGxl
bikgew0KKwlpZiAoYWRkciA+PSBsb3dfbGltaXQgKyBsZW4pIHsNCiAJCXZtYSA9IGZpbmRfdm1h
KG1tLCBhZGRyLWxlbik7DQogCQlpZiAoIXZtYSB8fCBhZGRyIDw9IHZtYS0+dm1fc3RhcnQpDQog
CQkJLyogcmVtZW1iZXIgdGhlIGFkZHJlc3MgYXMgYSBoaW50IGZvciBuZXh0IHRpbWUgKi8NCiAJ
CQlyZXR1cm4gKG1tLT5mcmVlX2FyZWFfY2FjaGUgPSBhZGRyLWxlbik7DQogCX0NCiANCi0JaWYg
KG1tLT5tbWFwX2Jhc2UgPCBsZW4pDQorCWlmIChtbS0+bW1hcF9iYXNlIDwgbG93X2xpbWl0ICsg
bGVuKQ0KIAkJZ290byBib3R0b211cDsNCiANCiAJYWRkciA9IG1tLT5tbWFwX2Jhc2UtbGVuOw0K
QEAgLTE0OTgsNyArMTQ5OSw3IEBAIGFyY2hfZ2V0X3VubWFwcGVkX2FyZWFfdG9wZG93bihzdHJ1
Y3QgZmlsZSAqZmlscCwgY29uc3QgdW5zaWduZWQgbG9uZyBhZGRyMCwNCiANCiAJCS8qIHRyeSBq
dXN0IGJlbG93IHRoZSBjdXJyZW50IHZtYS0+dm1fc3RhcnQgKi8NCiAJCWFkZHIgPSB2bWEtPnZt
X3N0YXJ0LWxlbjsNCi0JfSB3aGlsZSAobGVuIDwgdm1hLT52bV9zdGFydCk7DQorCX0gd2hpbGUg
KHZtYS0+dm1fc3RhcnQgPj0gbG93X2xpbWl0ICsgbGVuKTsNCiANCiBib3R0b211cDoNCiAJLyoN
CmRpZmYgLS1naXQgYS9tbS9zd2FwLmMgYi9tbS9zd2FwLmMNCmluZGV4IDU1YjI2NmQuLmE0Yjkw
MTYgMTAwNjQ0DQotLS0gYS9tbS9zd2FwLmMNCisrKyBiL21tL3N3YXAuYw0KQEAgLTMxLDYgKzMx
LDcgQEANCiAjaW5jbHVkZSA8bGludXgvYmFja2luZy1kZXYuaD4NCiAjaW5jbHVkZSA8bGludXgv
bWVtY29udHJvbC5oPg0KICNpbmNsdWRlIDxsaW51eC9nZnAuaD4NCisjaW5jbHVkZSA8bGludXgv
aHVnZXRsYi5oPg0KIA0KICNpbmNsdWRlICJpbnRlcm5hbC5oIg0KIA0KQEAgLTY5LDcgKzcwLDgg
QEAgc3RhdGljIHZvaWQgX19wdXRfY29tcG91bmRfcGFnZShzdHJ1Y3QgcGFnZSAqcGFnZSkNCiB7
DQogCWNvbXBvdW5kX3BhZ2VfZHRvciAqZHRvcjsNCiANCi0JX19wYWdlX2NhY2hlX3JlbGVhc2Uo
cGFnZSk7DQorCWlmICghUGFnZUh1Z2UocGFnZSkpDQorCQlfX3BhZ2VfY2FjaGVfcmVsZWFzZShw
YWdlKTsNCiAJZHRvciA9IGdldF9jb21wb3VuZF9wYWdlX2R0b3IocGFnZSk7DQogCSgqZHRvciko
cGFnZSk7DQogfQ0KQEAgLTgzLDYgKzg1LDM1IEBAIHN0YXRpYyB2b2lkIHB1dF9jb21wb3VuZF9w
YWdlKHN0cnVjdCBwYWdlICpwYWdlKQ0KIAkJaWYgKGxpa2VseShwYWdlICE9IHBhZ2VfaGVhZCAm
Jg0KIAkJCSAgIGdldF9wYWdlX3VubGVzc196ZXJvKHBhZ2VfaGVhZCkpKSB7DQogCQkJdW5zaWdu
ZWQgbG9uZyBmbGFnczsNCisNCisJCQkgaWYgKFBhZ2VIZWFkSHVnZShwYWdlX2hlYWQpKSB7DQor
CQkJCWlmIChsaWtlbHkoUGFnZVRhaWwocGFnZSkpKSB7DQorCQkJCQkvKg0KKwkJCQkJICogX19z
cGxpdF9odWdlX3BhZ2VfcmVmY291bnQNCisJCQkJCSAqIGNhbm5vdCByYWNlIGhlcmUuDQorCQkJ
CQkgKi8NCisJCQkJCVZNX0JVR19PTighUGFnZUhlYWQocGFnZV9oZWFkKSk7DQorCQkJCQlhdG9t
aWNfZGVjKCZwYWdlLT5fbWFwY291bnQpOw0KKwkJCQkJaWYgKHB1dF9wYWdlX3Rlc3R6ZXJvKHBh
Z2VfaGVhZCkpDQorCQkJCQkJVk1fQlVHX09OKDEpOw0KKwkJCQkJaWYgKHB1dF9wYWdlX3Rlc3R6
ZXJvKHBhZ2VfaGVhZCkpDQorCQkJCQkJX19wdXRfY29tcG91bmRfcGFnZShwYWdlX2hlYWQpOw0K
KwkJCQkJcmV0dXJuOw0KKwkJCQl9IGVsc2Ugew0KKwkJCQkJLyoNCisJCQkJCSAqIF9fc3BsaXRf
aHVnZV9wYWdlX3JlZmNvdW50DQorCQkJCQkgKiBydW4gYmVmb3JlIHVzLCAicGFnZSIgd2FzIGEN
CisJCQkJCSAqIFRIUCB0YWlsLiBUaGUgc3BsaXQNCisJCQkJCSAqIHBhZ2VfaGVhZCBoYXMgYmVl
biBmcmVlZA0KKwkJCQkJICogYW5kIHJlYWxsb2NhdGVkIGFzIHNsYWIgb3INCisJCQkJCSAqIGh1
Z2V0bGJmcyBwYWdlIG9mIHNtYWxsZXINCisJCQkJCSAqIG9yZGVyIChvbmx5IHBvc3NpYmxlIGlm
DQorCQkJCQkgKiByZWFsbG9jYXRlZCBhcyBzbGFiIG9uDQorCQkJCQkgKiB4ODYpLg0KKwkJCQkJ
ICovDQorCQkJCQlnb3RvIHNraXBfbG9jazsNCisJCQkJfQ0KKwkJCX0NCiAJCQkvKg0KIAkJCSAq
IHBhZ2VfaGVhZCB3YXNuJ3QgYSBkYW5nbGluZyBwb2ludGVyIGJ1dCBpdA0KIAkJCSAqIG1heSBu
b3QgYmUgYSBoZWFkIHBhZ2UgYW55bW9yZSBieSB0aGUgdGltZQ0KQEAgLTk0LDkgKzEyNSwyOSBA
QCBzdGF0aWMgdm9pZCBwdXRfY29tcG91bmRfcGFnZShzdHJ1Y3QgcGFnZSAqcGFnZSkNCiAJCQkJ
LyogX19zcGxpdF9odWdlX3BhZ2VfcmVmY291bnQgcnVuIGJlZm9yZSB1cyAqLw0KIAkJCQljb21w
b3VuZF91bmxvY2tfaXJxcmVzdG9yZShwYWdlX2hlYWQsIGZsYWdzKTsNCiAJCQkJVk1fQlVHX09O
KFBhZ2VIZWFkKHBhZ2VfaGVhZCkpOw0KLQkJCQlpZiAocHV0X3BhZ2VfdGVzdHplcm8ocGFnZV9o
ZWFkKSkNCi0JCQkJCV9fcHV0X3NpbmdsZV9wYWdlKHBhZ2VfaGVhZCk7DQotCQkJb3V0X3B1dF9z
aW5nbGU6DQorc2tpcF9sb2NrOg0KKwkJCQlpZiAocHV0X3BhZ2VfdGVzdHplcm8ocGFnZV9oZWFk
KSkgew0KKwkJCQkJLyoNCisJCQkJCSAqIFRoZSBoZWFkIHBhZ2UgbWF5IGhhdmUgYmVlbg0KKwkJ
CQkJICogZnJlZWQgYW5kIHJlYWxsb2NhdGVkIGFzIGENCisJCQkJCSAqIGNvbXBvdW5kIHBhZ2Ug
b2Ygc21hbGxlcg0KKwkJCQkJICogb3JkZXIgYW5kIHRoZW4gZnJlZWQgYWdhaW4uDQorCQkJCQkg
KiBBbGwgd2Uga25vdyBpcyB0aGF0IGl0DQorCQkJCQkgKiBjYW5ub3QgaGF2ZSBiZWNvbWU6IGEg
VEhQDQorCQkJCQkgKiBwYWdlLCBhIGNvbXBvdW5kIHBhZ2Ugb2YNCisJCQkJCSAqIGhpZ2hlciBv
cmRlciwgYSB0YWlsIHBhZ2UuDQorCQkJCQkgKiBUaGF0IGlzIGJlY2F1c2Ugd2Ugc3RpbGwNCisJ
CQkJCSAqIGhvbGQgdGhlIHJlZmNvdW50IG9mIHRoZQ0KKwkJCQkJICogc3BsaXQgVEhQIHRhaWwg
YW5kDQorCQkJCQkgKiBwYWdlX2hlYWQgd2FzIHRoZSBUSFAgaGVhZA0KKwkJCQkJICogYmVmb3Jl
IHRoZSBzcGxpdC4NCisJCQkJCSAqLw0KKwkJCQkJaWYgKFBhZ2VIZWFkKHBhZ2VfaGVhZCkpDQor
CQkJCQkJX19wdXRfY29tcG91bmRfcGFnZShwYWdlX2hlYWQpOw0KKwkJCQkJZWxzZQ0KKwkJCQkJ
CV9fcHV0X3NpbmdsZV9wYWdlKHBhZ2VfaGVhZCk7DQorCQkJCX0NCitvdXRfcHV0X3NpbmdsZToN
CiAJCQkJaWYgKHB1dF9wYWdlX3Rlc3R6ZXJvKHBhZ2UpKQ0KIAkJCQkJX19wdXRfc2luZ2xlX3Bh
Z2UocGFnZSk7DQogCQkJCXJldHVybjsNCkBAIC0xNjMsNiArMjE0LDMxIEBAIGJvb2wgX19nZXRf
cGFnZV90YWlsKHN0cnVjdCBwYWdlICpwYWdlKQ0KIAlzdHJ1Y3QgcGFnZSAqcGFnZV9oZWFkID0g
Y29tcG91bmRfdHJhbnNfaGVhZChwYWdlKTsNCiANCiAJaWYgKGxpa2VseShwYWdlICE9IHBhZ2Vf
aGVhZCAmJiBnZXRfcGFnZV91bmxlc3NfemVybyhwYWdlX2hlYWQpKSkgew0KKwkJLyogUmVmIHRv
IHB1dF9jb21wb3VuZF9wYWdlKCkgY29tbWVudC4gKi8NCisJCWlmIChQYWdlSGVhZEh1Z2UocGFn
ZV9oZWFkKSkgew0KKwkJCWlmIChsaWtlbHkoUGFnZVRhaWwocGFnZSkpKSB7DQorCQkJCS8qDQor
CQkJCSAqIFRoaXMgaXMgYSBodWdldGxiZnMNCisJCQkJICogcGFnZS4gX19zcGxpdF9odWdlX3Bh
Z2VfcmVmY291bnQNCisJCQkJICogY2Fubm90IHJhY2UgaGVyZS4NCisJCQkJICovDQorCQkJCVZN
X0JVR19PTighUGFnZUhlYWQocGFnZV9oZWFkKSk7DQorCQkJCV9fZ2V0X3BhZ2VfdGFpbF9mb2xs
KHBhZ2UsIGZhbHNlKTsNCisJCQkJcmV0dXJuIHRydWU7DQorCQkJfSBlbHNlIHsNCisJCQkJLyoN
CisJCQkJICogX19zcGxpdF9odWdlX3BhZ2VfcmVmY291bnQgcnVuDQorCQkJCSAqIGJlZm9yZSB1
cywgInBhZ2UiIHdhcyBhIFRIUA0KKwkJCQkgKiB0YWlsLiBUaGUgc3BsaXQgcGFnZV9oZWFkIGhh
cyBiZWVuDQorCQkJCSAqIGZyZWVkIGFuZCByZWFsbG9jYXRlZCBhcyBzbGFiIG9yDQorCQkJCSAq
IGh1Z2V0bGJmcyBwYWdlIG9mIHNtYWxsZXIgb3JkZXINCisJCQkJICogKG9ubHkgcG9zc2libGUg
aWYgcmVhbGxvY2F0ZWQgYXMNCisJCQkJICogc2xhYiBvbiB4ODYpLg0KKwkJCQkgKi8NCisJCQkJ
cHV0X3BhZ2UocGFnZV9oZWFkKTsNCisJCQkJcmV0dXJuIGZhbHNlOw0KKwkJCX0NCisJCX0NCiAJ
CS8qDQogCQkgKiBwYWdlX2hlYWQgd2Fzbid0IGEgZGFuZ2xpbmcgcG9pbnRlciBidXQgaXQNCiAJ
CSAqIG1heSBub3QgYmUgYSBoZWFkIHBhZ2UgYW55bW9yZSBieSB0aGUgdGltZQ0KZGlmZiAtLWdp
dCBhL25ldC84MDIxcS92bGFuX2Rldi5jIGIvbmV0LzgwMjFxL3ZsYW5fZGV2LmMNCmluZGV4IGI0
MGQzZGEuLjQ4YTYyZDggMTAwNjQ0DQotLS0gYS9uZXQvODAyMXEvdmxhbl9kZXYuYw0KKysrIGIv
bmV0LzgwMjFxL3ZsYW5fZGV2LmMNCkBAIC01MjIsNiArNTIyLDIyIEBAIHN0YXRpYyBjb25zdCBz
dHJ1Y3QgaGVhZGVyX29wcyB2bGFuX2hlYWRlcl9vcHMgPSB7DQogCS5wYXJzZQkgPSBldGhfaGVh
ZGVyX3BhcnNlLA0KIH07DQogDQorc3RhdGljIGludCB2bGFuX3Bhc3N0aHJ1X2hhcmRfaGVhZGVy
KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQorCQkJCSAgICAg
dW5zaWduZWQgc2hvcnQgdHlwZSwNCisJCQkJICAgICBjb25zdCB2b2lkICpkYWRkciwgY29uc3Qg
dm9pZCAqc2FkZHIsDQorCQkJCSAgICAgdW5zaWduZWQgaW50IGxlbikNCit7DQorCXN0cnVjdCBu
ZXRfZGV2aWNlICpyZWFsX2RldiA9IHZsYW5fZGV2X2luZm8oZGV2KS0+cmVhbF9kZXY7DQorDQor
CXJldHVybiBkZXZfaGFyZF9oZWFkZXIoc2tiLCByZWFsX2RldiwgdHlwZSwgZGFkZHIsIHNhZGRy
LCBsZW4pOw0KK30NCisNCitzdGF0aWMgY29uc3Qgc3RydWN0IGhlYWRlcl9vcHMgdmxhbl9wYXNz
dGhydV9oZWFkZXJfb3BzID0gew0KKwkuY3JlYXRlCSA9IHZsYW5fcGFzc3RocnVfaGFyZF9oZWFk
ZXIsDQorCS5yZWJ1aWxkID0gZGV2X3JlYnVpbGRfaGVhZGVyLA0KKwkucGFyc2UJID0gZXRoX2hl
YWRlcl9wYXJzZSwNCit9Ow0KKw0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbmV0X2RldmljZV9vcHMg
dmxhbl9uZXRkZXZfb3BzOw0KIA0KIHN0YXRpYyBpbnQgdmxhbl9kZXZfaW5pdChzdHJ1Y3QgbmV0
X2RldmljZSAqZGV2KQ0KQEAgLTU2MSw3ICs1NzcsNyBAQCBzdGF0aWMgaW50IHZsYW5fZGV2X2lu
aXQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCiANCiAJZGV2LT5uZWVkZWRfaGVhZHJvb20gPSBy
ZWFsX2Rldi0+bmVlZGVkX2hlYWRyb29tOw0KIAlpZiAocmVhbF9kZXYtPmZlYXR1cmVzICYgTkVU
SUZfRl9IV19WTEFOX1RYKSB7DQotCQlkZXYtPmhlYWRlcl9vcHMgICAgICA9IHJlYWxfZGV2LT5o
ZWFkZXJfb3BzOw0KKwkJZGV2LT5oZWFkZXJfb3BzICAgICAgPSAmdmxhbl9wYXNzdGhydV9oZWFk
ZXJfb3BzOw0KIAkJZGV2LT5oYXJkX2hlYWRlcl9sZW4gPSByZWFsX2Rldi0+aGFyZF9oZWFkZXJf
bGVuOw0KIAl9IGVsc2Ugew0KIAkJZGV2LT5oZWFkZXJfb3BzICAgICAgPSAmdmxhbl9oZWFkZXJf
b3BzOw0KZGlmZiAtLWdpdCBhL25ldC9icmlkZ2UvYnJfbXVsdGljYXN0LmMgYi9uZXQvYnJpZGdl
L2JyX211bHRpY2FzdC5jDQppbmRleCBhMDZkZWNhLi4yMTU3OTg0IDEwMDY0NA0KLS0tIGEvbmV0
L2JyaWRnZS9icl9tdWx0aWNhc3QuYw0KKysrIGIvbmV0L2JyaWRnZS9icl9tdWx0aWNhc3QuYw0K
QEAgLTE3NDMsNyArMTc0Myw3IEBAIGludCBicl9tdWx0aWNhc3Rfc2V0X2hhc2hfbWF4KHN0cnVj
dCBuZXRfYnJpZGdlICpiciwgdW5zaWduZWQgbG9uZyB2YWwpDQogCXUzMiBvbGQ7DQogCXN0cnVj
dCBuZXRfYnJpZGdlX21kYl9odGFibGUgKm1kYjsNCiANCi0Jc3Bpbl9sb2NrKCZici0+bXVsdGlj
YXN0X2xvY2spOw0KKwlzcGluX2xvY2tfYmgoJmJyLT5tdWx0aWNhc3RfbG9jayk7DQogCWlmICgh
bmV0aWZfcnVubmluZyhici0+ZGV2KSkNCiAJCWdvdG8gdW5sb2NrOw0KIA0KQEAgLTE3NzUsNyAr
MTc3NSw3IEBAIHJvbGxiYWNrOg0KIAl9DQogDQogdW5sb2NrOg0KLQlzcGluX3VubG9jaygmYnIt
Pm11bHRpY2FzdF9sb2NrKTsNCisJc3Bpbl91bmxvY2tfYmgoJmJyLT5tdWx0aWNhc3RfbG9jayk7
DQogDQogCXJldHVybiBlcnI7DQogfQ0KZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Ryb3BfbW9uaXRv
ci5jIGIvbmV0L2NvcmUvZHJvcF9tb25pdG9yLmMNCmluZGV4IGI4NTZmODcuLjFkOWE1MjkgMTAw
NjQ0DQotLS0gYS9uZXQvY29yZS9kcm9wX21vbml0b3IuYw0KKysrIGIvbmV0L2NvcmUvZHJvcF9t
b25pdG9yLmMNCkBAIC02MSw3ICs2MSw2IEBAIHN0YXRpYyBzdHJ1Y3QgZ2VubF9mYW1pbHkgbmV0
X2Ryb3BfbW9uaXRvcl9mYW1pbHkgPSB7DQogCS5oZHJzaXplICAgICAgICA9IDAsDQogCS5uYW1l
ICAgICAgICAgICA9ICJORVRfRE0iLA0KIAkudmVyc2lvbiAgICAgICAgPSAyLA0KLQkubWF4YXR0
ciAgICAgICAgPSBORVRfRE1fQ01EX01BWCwNCiB9Ow0KIA0KIHN0YXRpYyBERUZJTkVfUEVSX0NQ
VShzdHJ1Y3QgcGVyX2NwdV9kbV9kYXRhLCBkbV9jcHVfZGF0YSk7DQpkaWZmIC0tZ2l0IGEvbmV0
L2lwdjQvaW5ldF9kaWFnLmMgYi9uZXQvaXB2NC9pbmV0X2RpYWcuYw0KaW5kZXggY2NlZTI3MC4u
NmJlNWU4ZSAxMDA2NDQNCi0tLSBhL25ldC9pcHY0L2luZXRfZGlhZy5jDQorKysgYi9uZXQvaXB2
NC9pbmV0X2RpYWcuYw0KQEAgLTExOSw2ICsxMTksMTAgQEAgc3RhdGljIGludCBpbmV0X2Nza19k
aWFnX2ZpbGwoc3RydWN0IHNvY2sgKnNrLA0KIA0KIAlyLT5pZC5pZGlhZ19zcG9ydCA9IGluZXQt
PmluZXRfc3BvcnQ7DQogCXItPmlkLmlkaWFnX2Rwb3J0ID0gaW5ldC0+aW5ldF9kcG9ydDsNCisN
CisJbWVtc2V0KCZyLT5pZC5pZGlhZ19zcmMsIDAsIHNpemVvZihyLT5pZC5pZGlhZ19zcmMpKTsN
CisJbWVtc2V0KCZyLT5pZC5pZGlhZ19kc3QsIDAsIHNpemVvZihyLT5pZC5pZGlhZ19kc3QpKTsN
CisNCiAJci0+aWQuaWRpYWdfc3JjWzBdID0gaW5ldC0+aW5ldF9yY3Zfc2FkZHI7DQogCXItPmlk
LmlkaWFnX2RzdFswXSA9IGluZXQtPmluZXRfZGFkZHI7DQogDQpAQCAtMjA5LDEzICsyMTMsMjAg
QEAgc3RhdGljIGludCBpbmV0X3R3c2tfZGlhZ19maWxsKHN0cnVjdCBpbmV0X3RpbWV3YWl0X3Nv
Y2sgKnR3LA0KIA0KIAlyLT5pZGlhZ19mYW1pbHkJICAgICAgPSB0dy0+dHdfZmFtaWx5Ow0KIAly
LT5pZGlhZ19yZXRyYW5zICAgICAgPSAwOw0KKw0KIAlyLT5pZC5pZGlhZ19pZgkgICAgICA9IHR3
LT50d19ib3VuZF9kZXZfaWY7DQogCXItPmlkLmlkaWFnX2Nvb2tpZVswXSA9ICh1MzIpKHVuc2ln
bmVkIGxvbmcpdHc7DQogCXItPmlkLmlkaWFnX2Nvb2tpZVsxXSA9ICh1MzIpKCgodW5zaWduZWQg
bG9uZyl0dyA+PiAzMSkgPj4gMSk7DQorDQogCXItPmlkLmlkaWFnX3Nwb3J0ICAgICA9IHR3LT50
d19zcG9ydDsNCiAJci0+aWQuaWRpYWdfZHBvcnQgICAgID0gdHctPnR3X2Rwb3J0Ow0KKw0KKwlt
ZW1zZXQoJnItPmlkLmlkaWFnX3NyYywgMCwgc2l6ZW9mKHItPmlkLmlkaWFnX3NyYykpOw0KKwlt
ZW1zZXQoJnItPmlkLmlkaWFnX2RzdCwgMCwgc2l6ZW9mKHItPmlkLmlkaWFnX2RzdCkpOw0KKw0K
IAlyLT5pZC5pZGlhZ19zcmNbMF0gICAgPSB0dy0+dHdfcmN2X3NhZGRyOw0KIAlyLT5pZC5pZGlh
Z19kc3RbMF0gICAgPSB0dy0+dHdfZGFkZHI7DQorDQogCXItPmlkaWFnX3N0YXRlCSAgICAgID0g
dHctPnR3X3N1YnN0YXRlOw0KIAlyLT5pZGlhZ190aW1lcgkgICAgICA9IDM7DQogCXItPmlkaWFn
X2V4cGlyZXMgICAgICA9IERJVl9ST1VORF9VUCh0bW8gKiAxMDAwLCBIWik7DQpAQCAtNTk4LDgg
KzYwOSwxMyBAQCBzdGF0aWMgaW50IGluZXRfZGlhZ19maWxsX3JlcShzdHJ1Y3Qgc2tfYnVmZiAq
c2tiLCBzdHJ1Y3Qgc29jayAqc2ssDQogDQogCXItPmlkLmlkaWFnX3Nwb3J0ID0gaW5ldC0+aW5l
dF9zcG9ydDsNCiAJci0+aWQuaWRpYWdfZHBvcnQgPSBpcmVxLT5ybXRfcG9ydDsNCisNCisJbWVt
c2V0KCZyLT5pZC5pZGlhZ19zcmMsIDAsIHNpemVvZihyLT5pZC5pZGlhZ19zcmMpKTsNCisJbWVt
c2V0KCZyLT5pZC5pZGlhZ19kc3QsIDAsIHNpemVvZihyLT5pZC5pZGlhZ19kc3QpKTsNCisNCiAJ
ci0+aWQuaWRpYWdfc3JjWzBdID0gaXJlcS0+bG9jX2FkZHI7DQogCXItPmlkLmlkaWFnX2RzdFsw
XSA9IGlyZXEtPnJtdF9hZGRyOw0KKw0KIAlyLT5pZGlhZ19leHBpcmVzID0gamlmZmllc190b19t
c2Vjcyh0bW8pOw0KIAlyLT5pZGlhZ19ycXVldWUgPSAwOw0KIAlyLT5pZGlhZ193cXVldWUgPSAw
Ow0KQEAgLTgyNCw3ICs4NDAsNyBAQCBuZXh0X25vcm1hbDoNCiAJCQkrK251bTsNCiAJCX0NCiAN
Ci0JCWlmIChyLT5pZGlhZ19zdGF0ZXMgJiBUQ1BGX1RJTUVfV0FJVCkgew0KKwkJaWYgKHItPmlk
aWFnX3N0YXRlcyAmIChUQ1BGX1RJTUVfV0FJVCB8IFRDUEZfRklOX1dBSVQyKSkgew0KIAkJCXN0
cnVjdCBpbmV0X3RpbWV3YWl0X3NvY2sgKnR3Ow0KIA0KIAkJCWluZXRfdHdza19mb3JfZWFjaCh0
dywgbm9kZSwNCkBAIC04MzIsNiArODQ4LDggQEAgbmV4dF9ub3JtYWw6DQogDQogCQkJCWlmIChu
dW0gPCBzX251bSkNCiAJCQkJCWdvdG8gbmV4dF9keWluZzsNCisJCQkJaWYgKCEoci0+aWRpYWdf
c3RhdGVzICYgKDEgPDwgdHctPnR3X3N1YnN0YXRlKSkpDQorCQkJCQlnb3RvIG5leHRfZHlpbmc7
DQogCQkJCWlmIChyLT5pZC5pZGlhZ19zcG9ydCAhPSB0dy0+dHdfc3BvcnQgJiYNCiAJCQkJICAg
IHItPmlkLmlkaWFnX3Nwb3J0KQ0KIAkJCQkJZ290byBuZXh0X2R5aW5nOw0KZGlmZiAtLWdpdCBh
L25ldC9pcHY0L2lwbXIuYyBiL25ldC9pcHY0L2lwbXIuYw0KaW5kZXggYjVlNjRlNC4uMTQwZDM3
NyAxMDA2NDQNCi0tLSBhL25ldC9pcHY0L2lwbXIuYw0KKysrIGIvbmV0L2lwdjQvaXBtci5jDQpA
QCAtMTU1LDkgKzE1NSwxMiBAQCBzdGF0aWMgc3RydWN0IG1yX3RhYmxlICppcG1yX2dldF90YWJs
ZShzdHJ1Y3QgbmV0ICpuZXQsIHUzMiBpZCkNCiBzdGF0aWMgaW50IGlwbXJfZmliX2xvb2t1cChz
dHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCBmbG93aTQgKmZscDQsDQogCQkJICAgc3RydWN0IG1yX3Rh
YmxlICoqbXJ0KQ0KIHsNCi0Jc3RydWN0IGlwbXJfcmVzdWx0IHJlczsNCi0Jc3RydWN0IGZpYl9s
b29rdXBfYXJnIGFyZyA9IHsgLnJlc3VsdCA9ICZyZXMsIH07DQogCWludCBlcnI7DQorCXN0cnVj
dCBpcG1yX3Jlc3VsdCByZXM7DQorCXN0cnVjdCBmaWJfbG9va3VwX2FyZyBhcmcgPSB7DQorCQku
cmVzdWx0ID0gJnJlcywNCisJCS5mbGFncyA9IEZJQl9MT09LVVBfTk9SRUYsDQorCX07DQogDQog
CWVyciA9IGZpYl9ydWxlc19sb29rdXAobmV0LT5pcHY0Lm1yX3J1bGVzX29wcywNCiAJCQkgICAg
ICAgZmxvd2k0X3RvX2Zsb3dpKGZscDQpLCAwLCAmYXJnKTsNCmRpZmYgLS1naXQgYS9uZXQvaXB2
Ni9pcDZtci5jIGIvbmV0L2lwdjYvaXA2bXIuYw0KaW5kZXggZjVhZjI1OS4uZjk2Yzk2ZiAxMDA2
NDQNCi0tLSBhL25ldC9pcHY2L2lwNm1yLmMNCisrKyBiL25ldC9pcHY2L2lwNm1yLmMNCkBAIC0x
MzksOSArMTM5LDEyIEBAIHN0YXRpYyBzdHJ1Y3QgbXI2X3RhYmxlICppcDZtcl9nZXRfdGFibGUo
c3RydWN0IG5ldCAqbmV0LCB1MzIgaWQpDQogc3RhdGljIGludCBpcDZtcl9maWJfbG9va3VwKHN0
cnVjdCBuZXQgKm5ldCwgc3RydWN0IGZsb3dpNiAqZmxwNiwNCiAJCQkgICAgc3RydWN0IG1yNl90
YWJsZSAqKm1ydCkNCiB7DQotCXN0cnVjdCBpcDZtcl9yZXN1bHQgcmVzOw0KLQlzdHJ1Y3QgZmli
X2xvb2t1cF9hcmcgYXJnID0geyAucmVzdWx0ID0gJnJlcywgfTsNCiAJaW50IGVycjsNCisJc3Ry
dWN0IGlwNm1yX3Jlc3VsdCByZXM7DQorCXN0cnVjdCBmaWJfbG9va3VwX2FyZyBhcmcgPSB7DQor
CQkucmVzdWx0ID0gJnJlcywNCisJCS5mbGFncyA9IEZJQl9MT09LVVBfTk9SRUYsDQorCX07DQog
DQogCWVyciA9IGZpYl9ydWxlc19sb29rdXAobmV0LT5pcHY2Lm1yNl9ydWxlc19vcHMsDQogCQkJ
ICAgICAgIGZsb3dpNl90b19mbG93aShmbHA2KSwgMCwgJmFyZyk7DQpkaWZmIC0tZ2l0IGEvbmV0
L2lwdjYvcm91dGUuYyBiL25ldC9pcHY2L3JvdXRlLmMNCmluZGV4IDE3NjgyMzguLjlhNGY0Mzcg
MTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni9yb3V0ZS5jDQorKysgYi9uZXQvaXB2Ni9yb3V0ZS5jDQpA
QCAtMjA1OCwxNSArMjA1OCwxMSBAQCBzdHJ1Y3QgcnQ2X2luZm8gKmFkZHJjb25mX2RzdF9hbGxv
YyhzdHJ1Y3QgaW5ldDZfZGV2ICppZGV2LA0KIHsNCiAJc3RydWN0IG5ldCAqbmV0ID0gZGV2X25l
dChpZGV2LT5kZXYpOw0KIAlzdHJ1Y3QgcnQ2X2luZm8gKnJ0ID0gaXA2X2RzdF9hbGxvYygmbmV0
LT5pcHY2LmlwNl9kc3Rfb3BzLA0KLQkJCQkJICAgIG5ldC0+bG9vcGJhY2tfZGV2LCAwKTsNCisJ
CQkJCSAgICBuZXQtPmxvb3BiYWNrX2RldiwgRFNUX05PQ09VTlQpOw0KIAlzdHJ1Y3QgbmVpZ2hi
b3VyICpuZWlnaDsNCiANCi0JaWYgKHJ0ID09IE5VTEwpIHsNCi0JCWlmIChuZXRfcmF0ZWxpbWl0
KCkpDQotCQkJcHJfd2FybmluZygiSVB2NjogIE1heGltdW0gbnVtYmVyIG9mIHJvdXRlcyByZWFj
aGVkLCINCi0JCQkJICAgIiBjb25zaWRlciBpbmNyZWFzaW5nIHJvdXRlL21heF9zaXplLlxuIik7
DQorCWlmIChydCA9PSBOVUxMKQ0KIAkJcmV0dXJuIEVSUl9QVFIoLUVOT01FTSk7DQotCX0NCiAN
CiAJaW42X2Rldl9ob2xkKGlkZXYpOw0KIA0KZGlmZiAtLWdpdCBhL25ldC9sbGMvYWZfbGxjLmMg
Yi9uZXQvbGxjL2FmX2xsYy5jDQppbmRleCA5OWE2MGQ1Li5mNDMyZDdiIDEwMDY0NA0KLS0tIGEv
bmV0L2xsYy9hZl9sbGMuYw0KKysrIGIvbmV0L2xsYy9hZl9sbGMuYw0KQEAgLTcxNSw3ICs3MTUs
NyBAQCBzdGF0aWMgaW50IGxsY191aV9yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0
IHNvY2tldCAqc29jaywNCiAJc3RydWN0IGxsY19zb2NrICpsbGMgPSBsbGNfc2soc2spOw0KIAlz
aXplX3QgY29waWVkID0gMDsNCiAJdTMyIHBlZWtfc2VxID0gMDsNCi0JdTMyICpzZXE7DQorCXUz
MiAqc2VxLCBza2JfbGVuOw0KIAl1bnNpZ25lZCBsb25nIHVzZWQ7DQogCWludCB0YXJnZXQ7CS8q
IFJlYWQgYXQgbGVhc3QgdGhpcyBtYW55IGJ5dGVzICovDQogCWxvbmcgdGltZW87DQpAQCAtODEz
LDYgKzgxMyw3IEBAIHN0YXRpYyBpbnQgbGxjX3VpX3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2Ni
LCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAkJfQ0KIAkJY29udGludWU7DQogCWZvdW5kX29rX3Nr
YjoNCisJCXNrYl9sZW4gPSBza2ItPmxlbjsNCiAJCS8qIE9rIHNvIGhvdyBtdWNoIGNhbiB3ZSB1
c2U/ICovDQogCQl1c2VkID0gc2tiLT5sZW4gLSBvZmZzZXQ7DQogCQlpZiAobGVuIDwgdXNlZCkN
CkBAIC04NDMsNyArODQ0LDcgQEAgc3RhdGljIGludCBsbGNfdWlfcmVjdm1zZyhzdHJ1Y3Qga2lv
Y2IgKmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCQl9DQogDQogCQkvKiBQYXJ0aWFsIHJl
YWQgKi8NCi0JCWlmICh1c2VkICsgb2Zmc2V0IDwgc2tiLT5sZW4pDQorCQlpZiAodXNlZCArIG9m
ZnNldCA8IHNrYl9sZW4pDQogCQkJY29udGludWU7DQogCX0gd2hpbGUgKGxlbiA+IDApOw0KIA0K
ZGlmZiAtLWdpdCBhL25ldC9yZHMvaWIuYyBiL25ldC9yZHMvaWIuYw0KaW5kZXggYjRjOGIwMC4u
YmEyZGZmZSAxMDA2NDQNCi0tLSBhL25ldC9yZHMvaWIuYw0KKysrIGIvbmV0L3Jkcy9pYi5jDQpA
QCAtMzM4LDcgKzMzOCw4IEBAIHN0YXRpYyBpbnQgcmRzX2liX2xhZGRyX2NoZWNrKF9fYmUzMiBh
ZGRyKQ0KIAlyZXQgPSByZG1hX2JpbmRfYWRkcihjbV9pZCwgKHN0cnVjdCBzb2NrYWRkciAqKSZz
aW4pOw0KIAkvKiBkdWUgdG8gdGhpcywgd2Ugd2lsbCBjbGFpbSB0byBzdXBwb3J0IGlXQVJQIGRl
dmljZXMgdW5sZXNzIHdlDQogCSAgIGNoZWNrIG5vZGVfdHlwZS4gKi8NCi0JaWYgKHJldCB8fCBj
bV9pZC0+ZGV2aWNlLT5ub2RlX3R5cGUgIT0gUkRNQV9OT0RFX0lCX0NBKQ0KKwlpZiAocmV0IHx8
ICFjbV9pZC0+ZGV2aWNlIHx8DQorCSAgICBjbV9pZC0+ZGV2aWNlLT5ub2RlX3R5cGUgIT0gUkRN
QV9OT0RFX0lCX0NBKQ0KIAkJcmV0ID0gLUVBRERSTk9UQVZBSUw7DQogDQogCXJkc2RlYnVnKCJh
ZGRyICVwSTQgcmV0ICVkIG5vZGUgdHlwZSAlZFxuIiwNCmRpZmYgLS1naXQgYS9uZXQvcmRzL2li
X3NlbmQuYyBiL25ldC9yZHMvaWJfc2VuZC5jDQppbmRleCBlNTkwOTQ5Li4zN2JlNmUyIDEwMDY0
NA0KLS0tIGEvbmV0L3Jkcy9pYl9zZW5kLmMNCisrKyBiL25ldC9yZHMvaWJfc2VuZC5jDQpAQCAt
NTUyLDkgKzU1Miw4IEBAIGludCByZHNfaWJfeG1pdChzdHJ1Y3QgcmRzX2Nvbm5lY3Rpb24gKmNv
bm4sIHN0cnVjdCByZHNfbWVzc2FnZSAqcm0sDQogCSAgICAmJiBybS0+bV9pbmMuaV9oZHIuaF9m
bGFncyAmIFJEU19GTEFHX0NPTkdfQklUTUFQKSB7DQogCQlyZHNfY29uZ19tYXBfdXBkYXRlZChj
b25uLT5jX2Zjb25nLCB+KHU2NCkgMCk7DQogCQlzY2F0ID0gJnJtLT5kYXRhLm9wX3NnW3NnXTsN
Ci0JCXJldCA9IHNpemVvZihzdHJ1Y3QgcmRzX2hlYWRlcikgKyBSRFNfQ09OR19NQVBfQllURVM7
DQotCQlyZXQgPSBtaW5fdChpbnQsIHJldCwgc2NhdC0+bGVuZ3RoIC0gY29ubi0+Y194bWl0X2Rh
dGFfb2ZmKTsNCi0JCXJldHVybiByZXQ7DQorCQlyZXQgPSBtYXhfdChpbnQsIFJEU19DT05HX01B
UF9CWVRFUywgc2NhdC0+bGVuZ3RoKTsNCisJCXJldHVybiBzaXplb2Yoc3RydWN0IHJkc19oZWFk
ZXIpICsgcmV0Ow0KIAl9DQogDQogCS8qIEZJWE1FIHdlIG1heSBvdmVyYWxsb2NhdGUgaGVyZSAq
Lw0KZGlmZiAtLWdpdCBhL25ldC9yb3NlL2FmX3Jvc2UuYyBiL25ldC9yb3NlL2FmX3Jvc2UuYw0K
aW5kZXggYmY3NmRlYzcuLjY4NmZiMWEgMTAwNjQ0DQotLS0gYS9uZXQvcm9zZS9hZl9yb3NlLmMN
CisrKyBiL25ldC9yb3NlL2FmX3Jvc2UuYw0KQEAgLTEyNTgsNiArMTI1OCw3IEBAIHN0YXRpYyBp
bnQgcm9zZV9yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IHNvY2tldCAqc29jaywN
CiANCiAJaWYgKG1zZy0+bXNnX25hbWUpIHsNCiAJCXN0cnVjdCBzb2NrYWRkcl9yb3NlICpzcm9z
ZTsNCisJCXN0cnVjdCBmdWxsX3NvY2thZGRyX3Jvc2UgKmZ1bGxfc3Jvc2UgPSBtc2ctPm1zZ19u
YW1lOw0KIA0KIAkJbWVtc2V0KG1zZy0+bXNnX25hbWUsIDAsIHNpemVvZihzdHJ1Y3QgZnVsbF9z
b2NrYWRkcl9yb3NlKSk7DQogCQlzcm9zZSA9IG1zZy0+bXNnX25hbWU7DQpAQCAtMTI2NSwxOCAr
MTI2Niw5IEBAIHN0YXRpYyBpbnQgcm9zZV9yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3Ry
dWN0IHNvY2tldCAqc29jaywNCiAJCXNyb3NlLT5zcm9zZV9hZGRyICAgPSByb3NlLT5kZXN0X2Fk
ZHI7DQogCQlzcm9zZS0+c3Jvc2VfY2FsbCAgID0gcm9zZS0+ZGVzdF9jYWxsOw0KIAkJc3Jvc2Ut
PnNyb3NlX25kaWdpcyA9IHJvc2UtPmRlc3RfbmRpZ2lzOw0KLQkJaWYgKG1zZy0+bXNnX25hbWVs
ZW4gPj0gc2l6ZW9mKHN0cnVjdCBmdWxsX3NvY2thZGRyX3Jvc2UpKSB7DQotCQkJc3RydWN0IGZ1
bGxfc29ja2FkZHJfcm9zZSAqZnVsbF9zcm9zZSA9IChzdHJ1Y3QgZnVsbF9zb2NrYWRkcl9yb3Nl
ICopbXNnLT5tc2dfbmFtZTsNCi0JCQlmb3IgKG4gPSAwIDsgbiA8IHJvc2UtPmRlc3RfbmRpZ2lz
IDsgbisrKQ0KLQkJCQlmdWxsX3Nyb3NlLT5zcm9zZV9kaWdpc1tuXSA9IHJvc2UtPmRlc3RfZGln
aXNbbl07DQotCQkJbXNnLT5tc2dfbmFtZWxlbiA9IHNpemVvZihzdHJ1Y3QgZnVsbF9zb2NrYWRk
cl9yb3NlKTsNCi0JCX0gZWxzZSB7DQotCQkJaWYgKHJvc2UtPmRlc3RfbmRpZ2lzID49IDEpIHsN
Ci0JCQkJc3Jvc2UtPnNyb3NlX25kaWdpcyA9IDE7DQotCQkJCXNyb3NlLT5zcm9zZV9kaWdpID0g
cm9zZS0+ZGVzdF9kaWdpc1swXTsNCi0JCQl9DQotCQkJbXNnLT5tc2dfbmFtZWxlbiA9IHNpemVv
ZihzdHJ1Y3Qgc29ja2FkZHJfcm9zZSk7DQotCQl9DQorCQlmb3IgKG4gPSAwIDsgbiA8IHJvc2Ut
PmRlc3RfbmRpZ2lzIDsgbisrKQ0KKwkJCWZ1bGxfc3Jvc2UtPnNyb3NlX2RpZ2lzW25dID0gcm9z
ZS0+ZGVzdF9kaWdpc1tuXTsNCisJCW1zZy0+bXNnX25hbWVsZW4gPSBzaXplb2Yoc3RydWN0IGZ1
bGxfc29ja2FkZHJfcm9zZSk7DQogCX0NCiANCiAJc2tiX2ZyZWVfZGF0YWdyYW0oc2ssIHNrYik7
DQpkaWZmIC0tZ2l0IGEvbmV0L3VuaXgvYWZfdW5peC5jIGIvbmV0L3VuaXgvYWZfdW5peC5jDQpp
bmRleCA5MzM4Y2NjLi5lZGRmZGVjIDEwMDY0NA0KLS0tIGEvbmV0L3VuaXgvYWZfdW5peC5jDQor
KysgYi9uZXQvdW5peC9hZl91bml4LmMNCkBAIC02OTYsNyArNjk2LDkgQEAgc3RhdGljIGludCB1
bml4X2F1dG9iaW5kKHN0cnVjdCBzb2NrZXQgKnNvY2spDQogCWludCBlcnI7DQogCXVuc2lnbmVk
IGludCByZXRyaWVzID0gMDsNCiANCi0JbXV0ZXhfbG9jaygmdS0+cmVhZGxvY2spOw0KKwllcnIg
PSBtdXRleF9sb2NrX2ludGVycnVwdGlibGUoJnUtPnJlYWRsb2NrKTsNCisJaWYgKGVycikNCisJ
CXJldHVybiBlcnI7DQogDQogCWVyciA9IDA7DQogCWlmICh1LT5hZGRyKQ0KQEAgLTgyOSw3ICs4
MzEsOSBAQCBzdGF0aWMgaW50IHVuaXhfYmluZChzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3Qg
c29ja2FkZHIgKnVhZGRyLCBpbnQgYWRkcl9sZW4pDQogCQlnb3RvIG91dDsNCiAJYWRkcl9sZW4g
PSBlcnI7DQogDQotCW11dGV4X2xvY2soJnUtPnJlYWRsb2NrKTsNCisJZXJyID0gbXV0ZXhfbG9j
a19pbnRlcnJ1cHRpYmxlKCZ1LT5yZWFkbG9jayk7DQorCWlmIChlcnIpDQorCQlnb3RvIG91dDsN
CiANCiAJZXJyID0gLUVJTlZBTDsNCiAJaWYgKHUtPmFkZHIpDQpkaWZmIC0tZ2l0IGEvbmV0L3dp
cmVsZXNzL3JhZGlvdGFwLmMgYi9uZXQvd2lyZWxlc3MvcmFkaW90YXAuYw0KaW5kZXggNjE3YTMx
MC4uNjA1NDlhNCAxMDA2NDQNCi0tLSBhL25ldC93aXJlbGVzcy9yYWRpb3RhcC5jDQorKysgYi9u
ZXQvd2lyZWxlc3MvcmFkaW90YXAuYw0KQEAgLTEyMiw2ICsxMjIsMTAgQEAgaW50IGllZWU4MDIx
MV9yYWRpb3RhcF9pdGVyYXRvcl9pbml0KA0KIAkvKiBmaW5kIHBheWxvYWQgc3RhcnQgYWxsb3dp
bmcgZm9yIGV4dGVuZGVkIGJpdG1hcChzKSAqLw0KIA0KIAlpZiAoaXRlcmF0b3ItPl9iaXRtYXBf
c2hpZnRlciAmICgxPDxJRUVFODAyMTFfUkFESU9UQVBfRVhUKSkgew0KKwkJaWYgKCh1bnNpZ25l
ZCBsb25nKWl0ZXJhdG9yLT5fYXJnIC0NCisJCSAgICAodW5zaWduZWQgbG9uZylpdGVyYXRvci0+
X3J0aGVhZGVyICsgc2l6ZW9mKHVpbnQzMl90KSA+DQorCQkgICAgKHVuc2lnbmVkIGxvbmcpaXRl
cmF0b3ItPl9tYXhfbGVuZ3RoKQ0KKwkJCXJldHVybiAtRUlOVkFMOw0KIAkJd2hpbGUgKGdldF91
bmFsaWduZWRfbGUzMihpdGVyYXRvci0+X2FyZykgJg0KIAkJCQkJKDEgPDwgSUVFRTgwMjExX1JB
RElPVEFQX0VYVCkpIHsNCiAJCQlpdGVyYXRvci0+X2FyZyArPSBzaXplb2YodWludDMyX3QpOw0K
ZGlmZiAtLWdpdCBhL3NlY3VyaXR5L3NlbGludXgvaG9va3MuYyBiL3NlY3VyaXR5L3NlbGludXgv
aG9va3MuYw0KaW5kZXggNTg5OGYzNC4uYmNmMWQ3MyAxMDA2NDQNCi0tLSBhL3NlY3VyaXR5L3Nl
bGludXgvaG9va3MuYw0KKysrIGIvc2VjdXJpdHkvc2VsaW51eC9ob29rcy5jDQpAQCAtMjE3LDYg
KzIxNywxNCBAQCBzdGF0aWMgaW50IGlub2RlX2FsbG9jX3NlY3VyaXR5KHN0cnVjdCBpbm9kZSAq
aW5vZGUpDQogCXJldHVybiAwOw0KIH0NCiANCitzdGF0aWMgdm9pZCBpbm9kZV9mcmVlX3JjdShz
dHJ1Y3QgcmN1X2hlYWQgKmhlYWQpDQorew0KKwlzdHJ1Y3QgaW5vZGVfc2VjdXJpdHlfc3RydWN0
ICppc2VjOw0KKw0KKwlpc2VjID0gY29udGFpbmVyX29mKGhlYWQsIHN0cnVjdCBpbm9kZV9zZWN1
cml0eV9zdHJ1Y3QsIHJjdSk7DQorCWttZW1fY2FjaGVfZnJlZShzZWxfaW5vZGVfY2FjaGUsIGlz
ZWMpOw0KK30NCisNCiBzdGF0aWMgdm9pZCBpbm9kZV9mcmVlX3NlY3VyaXR5KHN0cnVjdCBpbm9k
ZSAqaW5vZGUpDQogew0KIAlzdHJ1Y3QgaW5vZGVfc2VjdXJpdHlfc3RydWN0ICppc2VjID0gaW5v
ZGUtPmlfc2VjdXJpdHk7DQpAQCAtMjI3LDggKzIzNSwxNiBAQCBzdGF0aWMgdm9pZCBpbm9kZV9m
cmVlX3NlY3VyaXR5KHN0cnVjdCBpbm9kZSAqaW5vZGUpDQogCQlsaXN0X2RlbF9pbml0KCZpc2Vj
LT5saXN0KTsNCiAJc3Bpbl91bmxvY2soJnNic2VjLT5pc2VjX2xvY2spOw0KIA0KLQlpbm9kZS0+
aV9zZWN1cml0eSA9IE5VTEw7DQotCWttZW1fY2FjaGVfZnJlZShzZWxfaW5vZGVfY2FjaGUsIGlz
ZWMpOw0KKwkvKg0KKwkgKiBUaGUgaW5vZGUgbWF5IHN0aWxsIGJlIHJlZmVyZW5jZWQgaW4gYSBw
YXRoIHdhbGsgYW5kDQorCSAqIGEgY2FsbCB0byBzZWxpbnV4X2lub2RlX3Blcm1pc3Npb24oKSBj
YW4gYmUgbWFkZQ0KKwkgKiBhZnRlciBpbm9kZV9mcmVlX3NlY3VyaXR5KCkgaXMgY2FsbGVkLiBJ
ZGVhbGx5LCB0aGUgVkZTDQorCSAqIHdvdWxkbid0IGRvIHRoaXMsIGJ1dCBmaXhpbmcgdGhhdCBp
cyBhIG11Y2ggaGFyZGVyDQorCSAqIGpvYi4gRm9yIG5vdywgc2ltcGx5IGZyZWUgdGhlIGlfc2Vj
dXJpdHkgdmlhIFJDVSwgYW5kDQorCSAqIGxlYXZlIHRoZSBjdXJyZW50IGlub2RlLT5pX3NlY3Vy
aXR5IHBvaW50ZXIgaW50YWN0Lg0KKwkgKiBUaGUgaW5vZGUgd2lsbCBiZSBmcmVlZCBhZnRlciB0
aGUgUkNVIGdyYWNlIHBlcmlvZCB0b28uDQorCSAqLw0KKwljYWxsX3JjdSgmaXNlYy0+cmN1LCBp
bm9kZV9mcmVlX3JjdSk7DQogfQ0KIA0KIHN0YXRpYyBpbnQgZmlsZV9hbGxvY19zZWN1cml0eShz
dHJ1Y3QgZmlsZSAqZmlsZSkNCkBAIC00MTgxLDggKzQxOTcsMTAgQEAgc3RhdGljIGludCBzZWxp
bnV4X3NvY2tldF9zb2NrX3Jjdl9za2Ioc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qgc2tfYnVmZiAq
c2tiKQ0KIAkJfQ0KIAkJZXJyID0gYXZjX2hhc19wZXJtKHNrX3NpZCwgcGVlcl9zaWQsIFNFQ0NM
QVNTX1BFRVIsDQogCQkJCSAgIFBFRVJfX1JFQ1YsICZhZCk7DQotCQlpZiAoZXJyKQ0KKwkJaWYg
KGVycikgew0KIAkJCXNlbGludXhfbmV0bGJsX2Vycihza2IsIGVyciwgMCk7DQorCQkJcmV0dXJu
IGVycjsNCisJCX0NCiAJfQ0KIA0KIAlpZiAoc2VjbWFya19hY3RpdmUpIHsNCkBAIC01MzcyLDEx
ICs1MzkwLDExIEBAIHN0YXRpYyBpbnQgc2VsaW51eF9zZXRwcm9jYXR0cihzdHJ1Y3QgdGFza19z
dHJ1Y3QgKnAsDQogCQkvKiBDaGVjayBmb3IgcHRyYWNpbmcsIGFuZCB1cGRhdGUgdGhlIHRhc2sg
U0lEIGlmIG9rLg0KIAkJICAgT3RoZXJ3aXNlLCBsZWF2ZSBTSUQgdW5jaGFuZ2VkIGFuZCBmYWls
LiAqLw0KIAkJcHRzaWQgPSAwOw0KLQkJdGFza19sb2NrKHApOw0KKwkJcmN1X3JlYWRfbG9jaygp
Ow0KIAkJdHJhY2VyID0gcHRyYWNlX3BhcmVudChwKTsNCiAJCWlmICh0cmFjZXIpDQogCQkJcHRz
aWQgPSB0YXNrX3NpZCh0cmFjZXIpOw0KLQkJdGFza191bmxvY2socCk7DQorCQlyY3VfcmVhZF91
bmxvY2soKTsNCiANCiAJCWlmICh0cmFjZXIpIHsNCiAJCQllcnJvciA9IGF2Y19oYXNfcGVybShw
dHNpZCwgc2lkLCBTRUNDTEFTU19QUk9DRVNTLA0KZGlmZiAtLWdpdCBhL3NlY3VyaXR5L3NlbGlu
dXgvaW5jbHVkZS9vYmpzZWMuaCBiL3NlY3VyaXR5L3NlbGludXgvaW5jbHVkZS9vYmpzZWMuaA0K
aW5kZXggMjZjN2VlZS4uN2IxODMwYiAxMDA2NDQNCi0tLSBhL3NlY3VyaXR5L3NlbGludXgvaW5j
bHVkZS9vYmpzZWMuaA0KKysrIGIvc2VjdXJpdHkvc2VsaW51eC9pbmNsdWRlL29ianNlYy5oDQpA
QCAtMzgsNyArMzgsMTAgQEAgc3RydWN0IHRhc2tfc2VjdXJpdHlfc3RydWN0IHsNCiANCiBzdHJ1
Y3QgaW5vZGVfc2VjdXJpdHlfc3RydWN0IHsNCiAJc3RydWN0IGlub2RlICppbm9kZTsJLyogYmFj
ayBwb2ludGVyIHRvIGlub2RlIG9iamVjdCAqLw0KLQlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7CS8q
IGxpc3Qgb2YgaW5vZGVfc2VjdXJpdHlfc3RydWN0ICovDQorCXVuaW9uIHsNCisJCXN0cnVjdCBs
aXN0X2hlYWQgbGlzdDsJLyogbGlzdCBvZiBpbm9kZV9zZWN1cml0eV9zdHJ1Y3QgKi8NCisJCXN0
cnVjdCByY3VfaGVhZCByY3U7CS8qIGZvciBmcmVlaW5nIHRoZSBpbm9kZV9zZWN1cml0eV9zdHJ1
Y3QgKi8NCisJfTsNCiAJdTMyIHRhc2tfc2lkOwkJLyogU0lEIG9mIGNyZWF0aW5nIHRhc2sgKi8N
CiAJdTMyIHNpZDsJCS8qIFNJRCBvZiB0aGlzIG9iamVjdCAqLw0KIAl1MTYgc2NsYXNzOwkJLyog
c2VjdXJpdHkgY2xhc3Mgb2YgdGhpcyBvYmplY3QgKi8NCmRpZmYgLS1naXQgYS9zb3VuZC9jb3Jl
L3BjbV9saWIuYyBiL3NvdW5kL2NvcmUvcGNtX2xpYi5jDQppbmRleCAzNDIwYmQzLi5jZjBkNDZl
IDEwMDY0NA0KLS0tIGEvc291bmQvY29yZS9wY21fbGliLmMNCisrKyBiL3NvdW5kL2NvcmUvcGNt
X2xpYi5jDQpAQCAtMTg0Niw2ICsxODQ2LDggQEAgc3RhdGljIGludCB3YWl0X2Zvcl9hdmFpbChz
dHJ1Y3Qgc25kX3BjbV9zdWJzdHJlYW0gKnN1YnN0cmVhbSwNCiAJCWNhc2UgU05EUlZfUENNX1NU
QVRFX0RJU0NPTk5FQ1RFRDoNCiAJCQllcnIgPSAtRUJBREZEOw0KIAkJCWdvdG8gX2VuZGxvb3A7
DQorCQljYXNlIFNORFJWX1BDTV9TVEFURV9QQVVTRUQ6DQorCQkJY29udGludWU7DQogCQl9DQog
CQlpZiAoIXRvdXQpIHsNCiAJCQlzbmRfcHJpbnRkKCIlcyB3cml0ZSBlcnJvciAoRE1BIG9yIElS
USB0cm91YmxlPylcbiIsDQpkaWZmIC0tZ2l0IGEvc291bmQvcGNpL2hkYS9oZGFfaW50ZWwuYyBi
L3NvdW5kL3BjaS9oZGEvaGRhX2ludGVsLmMNCmluZGV4IDdlYmU0YjcuLmZlYTY4OTUgMTAwNjQ0
DQotLS0gYS9zb3VuZC9wY2kvaGRhL2hkYV9pbnRlbC5jDQorKysgYi9zb3VuZC9wY2kvaGRhL2hk
YV9pbnRlbC5jDQpAQCAtMjYxOCw2ICsyNjE4LDEwIEBAIHN0YXRpYyB2b2lkIF9fZGV2aW5pdCBj
aGVja19wcm9iZV9tYXNrKHN0cnVjdCBhenggKmNoaXAsIGludCBkZXYpDQogICogd2hpdGUvYmxh
Y2stbGlzdCBmb3IgZW5hYmxlX21zaQ0KICAqLw0KIHN0YXRpYyBzdHJ1Y3Qgc25kX3BjaV9xdWly
ayBtc2lfYmxhY2tfbGlzdFtdIF9fZGV2aW5pdGRhdGEgPSB7DQorCVNORF9QQ0lfUVVJUksoMHgx
MDNjLCAweDIxOTEsICJIUCIsIDApLCAvKiBBTUQgSHVkc29uICovDQorCVNORF9QQ0lfUVVJUkso
MHgxMDNjLCAweDIxOTIsICJIUCIsIDApLCAvKiBBTUQgSHVkc29uICovDQorCVNORF9QQ0lfUVVJ
UksoMHgxMDNjLCAweDIxZjcsICJIUCIsIDApLCAvKiBBTUQgSHVkc29uICovDQorCVNORF9QQ0lf
UVVJUksoMHgxMDNjLCAweDIxZmEsICJIUCIsIDApLCAvKiBBTUQgSHVkc29uICovDQogCVNORF9Q
Q0lfUVVJUksoMHgxMDQzLCAweDgxZjIsICJBU1VTIiwgMCksIC8qIEF0aGxvbjY0IFgyICsgbnZp
ZGlhICovDQogCVNORF9QQ0lfUVVJUksoMHgxMDQzLCAweDgxZjYsICJBU1VTIiwgMCksIC8qIG52
aWRpYSAqLw0KIAlTTkRfUENJX1FVSVJLKDB4MTA0MywgMHg4MjJkLCAiQVNVUyIsIDApLCAvKiBB
dGhsb242NCBYMiArIG52aWRpYSBNQ1A1NSAqLw0KZGlmZiAtLWdpdCBhL3NvdW5kL3NvYy9jb2Rl
Y3Mvd204OTA0LmMgYi9zb3VuZC9zb2MvY29kZWNzL3dtODkwNC5jDQppbmRleCAyODVlZjg3Li5m
YWZiNzZmIDEwMDY0NA0KLS0tIGEvc291bmQvc29jL2NvZGVjcy93bTg5MDQuYw0KKysrIGIvc291
bmQvc29jL2NvZGVjcy93bTg5MDQuYw0KQEAgLTE3MTQsNyArMTcxNCw3IEBAIHN0YXRpYyBpbnQg
d204OTA0X3NldF9mbXQoc3RydWN0IHNuZF9zb2NfZGFpICpkYWksIHVuc2lnbmVkIGludCBmbXQp
DQogDQogCXN3aXRjaCAoZm10ICYgU05EX1NPQ19EQUlGTVRfRk9STUFUX01BU0spIHsNCiAJY2Fz
ZSBTTkRfU09DX0RBSUZNVF9EU1BfQjoNCi0JCWFpZjEgfD0gV004OTA0X0FJRl9MUkNMS19JTlY7
DQorCQlhaWYxIHw9IDB4MyB8IFdNODkwNF9BSUZfTFJDTEtfSU5WOw0KIAljYXNlIFNORF9TT0Nf
REFJRk1UX0RTUF9BOg0KIAkJYWlmMSB8PSAweDM7DQogCQlicmVhazsNCmRpZmYgLS1naXQgYS90
b29scy9wb3dlci9jcHVwb3dlci91dGlscy9jcHVwb3dlci1zZXQuYyBiL3Rvb2xzL3Bvd2VyL2Nw
dXBvd2VyL3V0aWxzL2NwdXBvd2VyLXNldC5jDQppbmRleCBkYzRkZTM3Li5iY2YxZDJmIDEwMDY0
NA0KLS0tIGEvdG9vbHMvcG93ZXIvY3B1cG93ZXIvdXRpbHMvY3B1cG93ZXItc2V0LmMNCisrKyBi
L3Rvb2xzL3Bvd2VyL2NwdXBvd2VyL3V0aWxzL2NwdXBvd2VyLXNldC5jDQpAQCAtMTgsOSArMTgs
OSBAQA0KICNpbmNsdWRlICJoZWxwZXJzL2JpdG1hc2suaCINCiANCiBzdGF0aWMgc3RydWN0IG9w
dGlvbiBzZXRfb3B0c1tdID0gew0KLQl7IC5uYW1lID0gInBlcmYtYmlhcyIsCS5oYXNfYXJnID0g
b3B0aW9uYWxfYXJndW1lbnQsCS5mbGFnID0gTlVMTCwJLnZhbCA9ICdiJ30sDQotCXsgLm5hbWUg
PSAic2NoZWQtbWMiLAkuaGFzX2FyZyA9IG9wdGlvbmFsX2FyZ3VtZW50LAkuZmxhZyA9IE5VTEws
CS52YWwgPSAnbSd9LA0KLQl7IC5uYW1lID0gInNjaGVkLXNtdCIsCS5oYXNfYXJnID0gb3B0aW9u
YWxfYXJndW1lbnQsCS5mbGFnID0gTlVMTCwJLnZhbCA9ICdzJ30sDQorCXsgLm5hbWUgPSAicGVy
Zi1iaWFzIiwJLmhhc19hcmcgPSByZXF1aXJlZF9hcmd1bWVudCwJLmZsYWcgPSBOVUxMLAkudmFs
ID0gJ2InfSwNCisJeyAubmFtZSA9ICJzY2hlZC1tYyIsCS5oYXNfYXJnID0gcmVxdWlyZWRfYXJn
dW1lbnQsCS5mbGFnID0gTlVMTCwJLnZhbCA9ICdtJ30sDQorCXsgLm5hbWUgPSAic2NoZWQtc210
IiwJLmhhc19hcmcgPSByZXF1aXJlZF9hcmd1bWVudCwJLmZsYWcgPSBOVUxMLAkudmFsID0gJ3Mn
fSwNCiAJeyB9LA0KIH07DQogDQo=


--=-uW+sZT0tNevTeLiwC7Gy--

--=-tu/mEWmBmotMkekKPm+D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUv/HtOe/yOyVhhEJAQrFxw//UJ1yW1Rbp6RNEaDBWwiMlRHK3vil8mWy
8RrG3H6rJ6XR3ZHeLquCWdzqphaYctaMoV6U0VLhrSZHVgou+a48EoXDXsYGYROQ
r/C4jkR6vZ3w3nAlmTjUv6q8xvJqa2Hox2ONEtU2CcsoP6lapvfPHg+CkV8JSFy0
YKxg58t7Or5Gy343Y+nH+K9uNDcE3UZdp537WSU1t3PqK0uHETUSOXSguDOrYABF
uzK1D3Tc2Tw4IIE8nfO+W521fJ/+dpv0fKY7YFmf6O3FrIYnit1lHxwYb0F770BY
avfzKw4fNh5WjckBYmJp6faj8UrnYG/cDjDXaSlHJGZxysB0s5LFPFEJoerVp9Md
yzxRLHOaDkeFcWlbYSh6OlAJS4kWL3yL3pvL5+z7QE5RoFC4qyrg2MKCfRnaN/I1
+zmBmZOvL8xOQokrYWnYKb078D7fF98Zl5LXNfaqZxvfzQQ61+DfBDL5a9CzAc7e
z4eAt5DGlb/lMb1t2tzHp0Is7USaodC8Eu7j9eqElQu3/1MFqNUuzP9ODSRqW0XB
v3oabA1Jkot2KRz6kYvapq9yMPD7DliAYhZa6bi15tvpitqUSmX0K5A0qc73kQQX
u+qlJvi3XvAnUwiQ9d0JnKDnX+vhwQ87TckSOCYWTAnpXutB2i+xQAb14sF4rAg1
ICOg0dA3GpE=
=OKlZ
-----END PGP SIGNATURE-----

--=-tu/mEWmBmotMkekKPm+D--
