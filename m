Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128AbaD3QdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:33:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53322 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934073AbaD3Qc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:32:56 -0400
Message-ID: <1398875565.11833.17.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.58
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 30 Apr 2014 17:32:45 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-buPf7p6NDjCE3suCtI0l"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-buPf7p6NDjCE3suCtI0l
Content-Type: multipart/mixed; boundary="=-67qpOVkXRt0sObi/8NgV"


--=-67qpOVkXRt0sObi/8NgV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.58 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.57 is attached to this message.

Ben.

------------

 Documentation/video4linux/gspca.txt          |   1 +
 Makefile                                     |   2 +-
 arch/alpha/lib/csum_partial_copy.c           |   9 +-
 arch/arm/include/asm/futex.h                 |   6 -
 arch/arm/include/asm/pgtable-2level.h        |   2 +
 arch/arm/include/asm/pgtable.h               |   6 +-
 arch/arm/mm/Kconfig                          |   3 +-
 arch/arm/mm/mmu.c                            |   8 +
 arch/arm/mm/proc-macros.S                    |  19 +-
 arch/arm/mm/proc-v7.S                        |   7 +-
 arch/mips/power/hibernate.S                  |   1 +
 arch/sh/kernel/dumpstack.c                   |   2 +-
 arch/sparc/Kconfig                           |   2 +-
 arch/sparc/include/asm/uaccess_64.h          |   4 +-
 arch/sparc/kernel/pci.c                      |   4 +-
 arch/sparc/kernel/syscalls.S                 |   4 +-
 arch/x86/kernel/cpu/mshyperv.c               |   6 +
 arch/x86/kernel/ldt.c                        |  11 ++
 block/blk-core.c                             |   2 +-
 drivers/char/ipmi/ipmi_bt_sm.c               |   2 +-
 drivers/cpufreq/powernow-k6.c                | 147 ++++++++++++---
 drivers/gpio/gpio-mxs.c                      |   3 +-
 drivers/gpu/drm/i915/intel_display.c         |   6 +
 drivers/gpu/drm/i915/intel_tv.c              |   9 +-
 drivers/gpu/drm/radeon/radeon_display.c      |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c           |   5 +-
 drivers/hv/ring_buffer.c                     |   2 +-
 drivers/infiniband/hw/ehca/ehca_cq.c         |   1 +
 drivers/infiniband/hw/ipath/ipath_diag.c     |  66 +++----
 drivers/infiniband/hw/mthca/mthca_provider.c |   1 +
 drivers/infiniband/hw/nes/nes_verbs.c        |   2 +-
 drivers/isdn/isdnloop/isdnloop.c             |  23 ++-
 drivers/md/dm-thin.c                         |   2 +-
 drivers/media/video/gspca/sn9c20x.c          |   1 +
 drivers/media/video/uvc/uvc_video.c          |  20 +-
 drivers/mfd/88pm860x-i2c.c                   |   6 +
 drivers/mfd/Kconfig                          |   6 +-
 drivers/mfd/max8925-i2c.c                    |   9 +
 drivers/mfd/max8997.c                        |  18 ++
 drivers/mfd/max8998.c                        |   4 +
 drivers/net/wireless/ath/ath9k/xmit.c        |   2 +-
 drivers/net/wireless/b43/phy_n.c             |  14 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |  24 ++-
 drivers/net/xen-netback/netback.c            |   4 +-
 drivers/scsi/isci/port_config.c              |   7 +
 drivers/scsi/isci/task.c                     |   2 +-
 drivers/staging/serqt_usb2/serqt_usb2.c      |   2 +-
 drivers/target/iscsi/iscsi_target.c          |   4 +-
 drivers/target/tcm_fc/tfc_sess.c             |   1 +
 drivers/tty/hvc/hvc_console.c                |   6 +-
 drivers/tty/tty_io.c                         |  20 +-
 drivers/usb/dwc3/core.h                      |   6 +-
 drivers/usb/gadget/atmel_usba_udc.c          |   5 +-
 drivers/vhost/net.c                          |  20 +-
 drivers/video/aty/mach64_accel.c             |   3 +-
 drivers/video/aty/mach64_cursor.c            |  22 ++-
 drivers/video/cfbcopyarea.c                  | 153 ++++++++--------
 drivers/video/matrox/matroxfb_accel.c        |  38 +++-
 drivers/video/matrox/matroxfb_base.h         |   2 +
 drivers/video/tgafb.c                        | 264 ++++++-----------------=
----
 drivers/virtio/virtio_balloon.c              |   6 +
 drivers/w1/w1_netlink.c                      |  25 +--
 fs/btrfs/disk-io.c                           |   4 +
 fs/btrfs/transaction.c                       |  14 +-
 fs/ext4/extents.c                            |  21 +++
 fs/jffs2/compr_rtime.c                       |   4 +-
 fs/jffs2/nodelist.h                          |   2 +-
 fs/jffs2/nodemgmt.c                          |  14 +-
 fs/nfsd/nfs4proc.c                           |   9 +-
 fs/nfsd/nfs4xdr.c                            |   2 +
 fs/nfsd/vfs.c                                |   9 +
 fs/nfsd/vfs.h                                |  10 +
 fs/ocfs2/buffer_head_io.c                    |   2 -
 fs/ocfs2/dlm/dlmrecovery.c                   |  29 ++-
 fs/reiserfs/dir.c                            |   6 +-
 include/linux/sched.h                        |  20 +-
 include/trace/events/block.h                 |  33 +++-
 kernel/auditsc.c                             |   4 +-
 kernel/exit.c                                |  15 +-
 kernel/trace/blktrace.c                      |  20 +-
 lib/nlattr.c                                 |  10 +-
 lib/percpu_counter.c                         |   2 +-
 mm/hugetlb.c                                 |   1 +
 mm/mlock.c                                   |   2 +
 mm/rmap.c                                    |  14 +-
 net/8021q/vlan_dev.c                         |   3 +
 net/bridge/br_multicast.c                    |   6 +
 net/ipv6/addrconf.c                          |   5 +-
 net/ipv6/icmp.c                              |   2 +-
 net/ipv6/ip6_output.c                        |  18 +-
 net/ipv6/mcast.c                             |  11 +-
 net/ipv6/route.c                             |   2 +-
 net/rds/iw.c                                 |   3 +-
 net/sctp/sm_make_chunk.c                     |   4 +-
 net/sctp/sm_statefuns.c                      |   5 -
 net/socket.c                                 |   4 +
 net/unix/af_unix.c                           |  17 +-
 security/selinux/hooks.c                     |  36 +++-
 sound/pci/hda/patch_realtek.c                |   1 +
 sound/pci/ice1712/ice1712.c                  |  15 +-
 101 files changed, 870 insertions(+), 580 deletions(-)

Ajesh Kunhipurayil Vijayan (1):
      jffs2: Fix crash due to truncation of csize

Alex Deucher (1):
      drm/radeon: call drm_edid_to_eld when we update the edid

Andy Grover (1):
      target/tcm_fc: Fix use-after-free of ft_tpg

Ben Hutchings (4):
      nfsd: Add fh_{want,drop}_write()
      Revert "alpha: fix broken network checksum"
      Revert "isci: fix reset timeout handling"
      Linux 3.2.58

Christopher Friedt (1):
      drm/vmwgfx: correct fb_fix_screeninfo.line_length

Dan Carpenter (1):
      isdnloop: several buffer overflows

Daniel Borkmann (1):
      net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk

Daniel Vetter (1):
      drm/i915: inverted brightness quirk for Acer Aspire 4736Z

Dave Kleikamp (2):
      Revert "sparc64: Fix __copy_{to,from}_user_inatomic defines."
      sparc64: don't treat 64-bit syscall return codes as 32-bit

David Fries (1):
      w1: fix w1_send_slave dropping a slave id

Dennis Dalessandro (1):
      IB/ipath: Fix potential buffer overrun in sending diag packet routine

Emmanuel Grumbach (1):
      iwlwifi: dvm: take mutex when sending SYNC BT config command

Eric Dumazet (1):
      net: unix: non blocking recvmsg() should not return -EINTR

Eric Whitney (1):
      ext4: fix partial cluster handling for bigalloc file systems

Felix Fietkau (1):
      ath9k: fix ready time of the multicast buffer queue

Gregory CLEMENT (1):
      usb: gadget: atmel_usba: fix crashed during stopping when DEBUG is en=
abled

H. Peter Anvin (1):
      x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels

Hannes Frederic Sowa (1):
      ipv6: some ipv6 statistic counters failed to disable bh

Hannes Reinecke (1):
      tty: Set correct tty name in 'active' sysfs attribute

Heiner Kallweit (1):
      ipv6: Avoid unnecessary temporary addresses being generated

Hidetoshi Seto (1):
      Btrfs: skip submitting barrier for missing device

Himangi Saraogi (1):
      staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to =
integer

Huacai Chen (1):
      MIPS: Hibernate: Flush TLB entries in swsusp_arch_resume()

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_devt

J. Bruce Fields (4):
      nfsd4: buffer-length check for SUPPATTR_EXCLCREAT
      nfsd4: session needs room for following op to error out
      nfsd: notify_change needs elevated write count
      nfsd4: fix setclientid encode size

Jani Nikula (2):
      drm/i915: quirk invert brightness for Acer Aspire 5336
      drm/i915/tv: fix gen4 composite s-video tv-out

Jason Wang (1):
      x86, hyperv: Bypass the timer_irq_works() check

Jeff Mahoney (1):
      reiserfs: fix race in readdir

Jens Axboe (1):
      lib/percpu_counter.c: fix bad percpu counter state during suspend

Jiri Slaby (1):
      Char: ipmi_bt_sm, fix infinite loop

Josef Bacik (1):
      Btrfs: fix deadlock with nested trans handles

Junxiao Bi (2):
      ocfs2: dlm: fix lock migration crash
      ocfs2: dlm: fix recovery hung

Kamlakant Patel (1):
      jffs2: Fix segmentation fault found in stress test

Krzysztof Kozlowski (4):
      mfd: max8997: Fix possible NULL pointer dereference on i2c_new_dummy =
error
      mfd: max8998: Fix possible NULL pointer dereference on i2c_new_dummy =
error
      mfd: max8925: Fix possible NULL pointer dereference on i2c_new_dummy =
error
      mfd: 88pm860x: Fix possible NULL pointer dereference on i2c_new_dummy=
 error

Larry Finger (1):
      rtlwifi: rtl8192se: Fix too long disable of IRQs

Li Zefan (2):
      jffs2: remove from wait queue after schedule()
      jffs2: avoid soft-lockup in jffs2_reserve_space_gc()

Linus L=C3=BCssing (1):
      bridge: multicast: add sanity check for query source addresses

Linus Walleij (1):
      mfd: Include all drivers in subsystem menu

Marek Vasut (1):
      gpio: mxs: Allow for recursive enable_irq_wake() call

Matt Fleming (1):
      sh: fix format string bug in stack tracer

Matthew Leach (1):
      net: socket: error on a negative msg_namelen

Michael S. Tsirkin (2):
      vhost: fix total length when packets are too short
      vhost: validate vhost_get_vq_desc return value

Mike Snitzer (1):
      dm thin: fix dangling bio in process_deferred_bios error path

Mikulas Patocka (8):
      matroxfb: restore the registers M_ACCESS and M_PITCH
      framebuffer: fix cfb_copyarea
      mach64: use unaligned access
      mach64: fix cursor when character width is not a multiple of 8 pixels
      tgafb: fix data copying
      powernow-k6: disable cache when changing frequency
      powernow-k6: correctly initialize default parameters
      powernow-k6: reorder frequencies

Mizuma, Masayoshi (1):
      mm: hugetlb: fix softlockup when a large number of hugepages are free=
d.

Nicholas Bellinger (1):
      iscsi-target: Fix ERL=3D2 ASYNC_EVENT connection pointer bug

Oleg Nesterov (1):
      wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE race

Oleksij Rempel (1):
      uvcvideo: Do not use usb_set_interface on bulk EP

Pablo Neira (1):
      netlink: don't compare the nul-termination in nla_strcmp

Paul Durrant (1):
      xen-netback: remove pointless clause from if statement

Paul Gortmaker (2):
      sparc32: fix build failure for arch_jump_label_transform
      hvc: ensure hvc_init is only ever called once in hvc_console.c

Paul Moore (1):
      selinux: correctly label /proc inodes in use before the policy is loa=
ded

Peter Bostr=C3=B6m (1):
      vlan: Set correct source MAC address with TX VLAN offload enabled

Qiang Huang (1):
      drivers: hv: additional switch to use mb() instead of smp_mb()

Rafa=C5=82 Mi=C5=82ecki (1):
      b43: Fix machine check error due to improper access of B43_MMIO_PSM_P=
HY_HDR

Richard Guy Briggs (2):
      pid: get pid_t ppid of task in init_pid_ns
      audit: convert PPIDs to the inital PID namespace.

Roman Pen (1):
      blktrace: fix accounting of partially completed requests

Rusty Russell (1):
      virtio_balloon: don't softlockup on huge balloon changes.

Sabrina Dubroca (1):
      ipv6: don't set DST_NOCOUNT for remotely added routes

Sasha Levin (1):
      rds: prevent dereference of a NULL device in rds_iw_laddr_check

Takashi Iwai (1):
      ALSA: ice1712: Fix boundary checks in PCM pointer ops

Vlastimil Babka (1):
      mm: try_to_unmap_cluster() should lock_page() before mlocking

W. Trevor King (1):
      ALSA: hda - Enable beep for ASUS 1015E

Will Deacon (2):
      ARM: mm: introduce present, faulting entries for PAGE_NONE
      ARM: 7954/1: mm: remove remaining domain support from ARMv6

Wolfram Sang (1):
      media: gspca: sn9c20x: add ID for Genius Look 1320 V2

YOSHIFUJI Hideaki / =E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E (1):
      isdnloop: Validate NUL-terminated strings from user.

Yann Droneaud (3):
      IB/nes: Return an error on ib_copy_from_udata() failure instead of NU=
LL
      IB/mthca: Return an error on ib_copy_to_udata() failure
      IB/ehca: Returns an error on ib_copy_to_udata() failure

alex chen (1):
      ocfs2: do not put bh when buffer_uptodate failed

lucien (1):
      ipv6: ip6_append_data_mtu do not handle the mtu of the second fragmen=
t properly

oftedal (1):
      sparc: PCI: Fix incorrect address calculation of PCI Bridge windows o=
n Simba-bridges


--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-67qpOVkXRt0sObi/8NgV
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.58.patch"
Content-Disposition: attachment; filename="linux-3.2.58.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vdmlkZW80bGludXgvZ3NwY2EudHh0IGIvRG9jdW1l
bnRhdGlvbi92aWRlbzRsaW51eC9nc3BjYS50eHQNCmluZGV4IGIxNWUyOWYuLjkwYWFlODU2IDEw
MDY0NA0KLS0tIGEvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9nc3BjYS50eHQNCisrKyBiL0Rv
Y3VtZW50YXRpb24vdmlkZW80bGludXgvZ3NwY2EudHh0DQpAQCAtNTUsNiArNTUsNyBAQCB6YzN4
eAkJMDQ1ODo3MDBmCUdlbml1cyBWaWRlb0NhbSBXZWIgVjINCiBzb25peGoJCTA0NTg6NzAyNQlH
ZW5pdXMgRXllIDMxMVENCiBzbjljMjB4CQkwNDU4OjcwMjkJR2VuaXVzIExvb2sgMzIwcw0KIHNv
bml4agkJMDQ1ODo3MDJlCUdlbml1cyBTbGltIDMxMCBOQg0KK3NuOWMyMHgJCTA0NTg6NzA0NQlH
ZW5pdXMgTG9vayAxMzIwIFYyDQogc245YzIweAkJMDQ1ODo3MDRhCUdlbml1cyBTbGltIDEzMjAN
CiBzbjljMjB4CQkwNDU4OjcwNGMJR2VuaXVzIGktTG9vayAxMzIxDQogc245YzIweAkJMDQ1ZTow
MGY0CUxpZmVDYW0gVlgtNjAwMCAoU045QzIweCArIE9WOTY1MCkNCmRpZmYgLS1naXQgYS9NYWtl
ZmlsZSBiL01ha2VmaWxlDQppbmRleCBjOTJkYjliLi5kNTliMzk0IDEwMDY0NA0KLS0tIGEvTWFr
ZWZpbGUNCisrKyBiL01ha2VmaWxlDQpAQCAtMSw2ICsxLDYgQEANCiBWRVJTSU9OID0gMw0KIFBB
VENITEVWRUwgPSAyDQotU1VCTEVWRUwgPSA1Nw0KK1NVQkxFVkVMID0gNTgNCiBFWFRSQVZFUlNJ
T04gPQ0KIE5BTUUgPSBTYWJlci10b290aGVkIFNxdWlycmVsDQogDQpkaWZmIC0tZ2l0IGEvYXJj
aC9hbHBoYS9saWIvY3N1bV9wYXJ0aWFsX2NvcHkuYyBiL2FyY2gvYWxwaGEvbGliL2NzdW1fcGFy
dGlhbF9jb3B5LmMNCmluZGV4IDFkMmVmNWEuLjQwNzM2ZGEgMTAwNjQ0DQotLS0gYS9hcmNoL2Fs
cGhhL2xpYi9jc3VtX3BhcnRpYWxfY29weS5jDQorKysgYi9hcmNoL2FscGhhL2xpYi9jc3VtX3Bh
cnRpYWxfY29weS5jDQpAQCAtMzczLDExICszNzMsNiBAQCBjc3VtX3BhcnRpYWxfY29weV9mcm9t
X3VzZXIoY29uc3Qgdm9pZCBfX3VzZXIgKnNyYywgdm9pZCAqZHN0LCBpbnQgbGVuLA0KIF9fd3N1
bQ0KIGNzdW1fcGFydGlhbF9jb3B5X25vY2hlY2soY29uc3Qgdm9pZCAqc3JjLCB2b2lkICpkc3Qs
IGludCBsZW4sIF9fd3N1bSBzdW0pDQogew0KLQlfX3dzdW0gY2hlY2tzdW07DQotCW1tX3NlZ21l
bnRfdCBvbGRmcyA9IGdldF9mcygpOw0KLQlzZXRfZnMoS0VSTkVMX0RTKTsNCi0JY2hlY2tzdW0g
PSBjc3VtX3BhcnRpYWxfY29weV9mcm9tX3VzZXIoKF9fZm9yY2UgY29uc3Qgdm9pZCBfX3VzZXIg
KilzcmMsDQotCQkJCQkJZHN0LCBsZW4sIHN1bSwgTlVMTCk7DQotCXNldF9mcyhvbGRmcyk7DQot
CXJldHVybiBjaGVja3N1bTsNCisJcmV0dXJuIGNzdW1fcGFydGlhbF9jb3B5X2Zyb21fdXNlcigo
X19mb3JjZSBjb25zdCB2b2lkIF9fdXNlciAqKXNyYywNCisJCQlkc3QsIGxlbiwgc3VtLCBOVUxM
KTsNCiB9DQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vaW5jbHVkZS9hc20vZnV0ZXguaCBiL2FyY2gv
YXJtL2luY2x1ZGUvYXNtL2Z1dGV4LmgNCmluZGV4IDI1M2NjODYuLmFlZmQ0NTkgMTAwNjQ0DQot
LS0gYS9hcmNoL2FybS9pbmNsdWRlL2FzbS9mdXRleC5oDQorKysgYi9hcmNoL2FybS9pbmNsdWRl
L2FzbS9mdXRleC5oDQpAQCAtMywxMSArMyw2IEBADQogDQogI2lmZGVmIF9fS0VSTkVMX18NCiAN
Ci0jaWYgZGVmaW5lZChDT05GSUdfQ1BVX1VTRV9ET01BSU5TKSAmJiBkZWZpbmVkKENPTkZJR19T
TVApDQotLyogQVJNIGRvZXNuJ3QgcHJvdmlkZSB1bnByaXZpbGVnZWQgZXhjbHVzaXZlIG1lbW9y
eSBhY2Nlc3NvcnMgKi8NCi0jaW5jbHVkZSA8YXNtLWdlbmVyaWMvZnV0ZXguaD4NCi0jZWxzZQ0K
LQ0KICNpbmNsdWRlIDxsaW51eC9mdXRleC5oPg0KICNpbmNsdWRlIDxsaW51eC91YWNjZXNzLmg+
DQogI2luY2x1ZGUgPGFzbS9lcnJuby5oPg0KQEAgLTE2Myw2ICsxNTgsNSBAQCBmdXRleF9hdG9t
aWNfb3BfaW51c2VyIChpbnQgZW5jb2RlZF9vcCwgdTMyIF9fdXNlciAqdWFkZHIpDQogCXJldHVy
biByZXQ7DQogfQ0KIA0KLSNlbmRpZiAvKiAhKENQVV9VU0VfRE9NQUlOUyAmJiBTTVApICovDQog
I2VuZGlmIC8qIF9fS0VSTkVMX18gKi8NCiAjZW5kaWYgLyogX0FTTV9BUk1fRlVURVhfSCAqLw0K
ZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2luY2x1ZGUvYXNtL3BndGFibGUtMmxldmVsLmggYi9hcmNo
L2FybS9pbmNsdWRlL2FzbS9wZ3RhYmxlLTJsZXZlbC5oDQppbmRleCA0NzA0NTdlLi4xY2I4MGM0
IDEwMDY0NA0KLS0tIGEvYXJjaC9hcm0vaW5jbHVkZS9hc20vcGd0YWJsZS0ybGV2ZWwuaA0KKysr
IGIvYXJjaC9hcm0vaW5jbHVkZS9hc20vcGd0YWJsZS0ybGV2ZWwuaA0KQEAgLTEyMyw2ICsxMjMs
NyBAQA0KICNkZWZpbmUgTF9QVEVfVVNFUgkJKF9BVChwdGV2YWxfdCwgMSkgPDwgOCkNCiAjZGVm
aW5lIExfUFRFX1hOCQkoX0FUKHB0ZXZhbF90LCAxKSA8PCA5KQ0KICNkZWZpbmUgTF9QVEVfU0hB
UkVECQkoX0FUKHB0ZXZhbF90LCAxKSA8PCAxMCkJLyogc2hhcmVkKHY2KSwgY29oZXJlbnQoeHNj
MykgKi8NCisjZGVmaW5lIExfUFRFX05PTkUJCShfQVQocHRldmFsX3QsIDEpIDw8IDExKQ0KIA0K
IC8qDQogICogVGhlc2UgYXJlIHRoZSBtZW1vcnkgdHlwZXMsIGRlZmluZWQgdG8gYmUgY29tcGF0
aWJsZSB3aXRoDQpAQCAtMTM4LDYgKzEzOSw3IEBADQogI2RlZmluZSBMX1BURV9NVF9ERVZfTk9O
U0hBUkVECShfQVQocHRldmFsX3QsIDB4MGMpIDw8IDIpCS8qIDExMDAgKi8NCiAjZGVmaW5lIExf
UFRFX01UX0RFVl9XQwkJKF9BVChwdGV2YWxfdCwgMHgwOSkgPDwgMikJLyogMTAwMSAqLw0KICNk
ZWZpbmUgTF9QVEVfTVRfREVWX0NBQ0hFRAkoX0FUKHB0ZXZhbF90LCAweDBiKSA8PCAyKQkvKiAx
MDExICovDQorI2RlZmluZSBMX1BURV9NVF9WRUNUT1JTCShfQVQocHRldmFsX3QsIDB4MGYpIDw8
IDIpCS8qIDExMTEgKi8NCiAjZGVmaW5lIExfUFRFX01UX01BU0sJCShfQVQocHRldmFsX3QsIDB4
MGYpIDw8IDIpDQogDQogI2VuZGlmIC8qIF9BU01fUEdUQUJMRV8yTEVWRUxfSCAqLw0KZGlmZiAt
LWdpdCBhL2FyY2gvYXJtL2luY2x1ZGUvYXNtL3BndGFibGUuaCBiL2FyY2gvYXJtL2luY2x1ZGUv
YXNtL3BndGFibGUuaA0KaW5kZXggOWI0MTlhYi4uZmNiYWMzYyAxMDA2NDQNCi0tLSBhL2FyY2gv
YXJtL2luY2x1ZGUvYXNtL3BndGFibGUuaA0KKysrIGIvYXJjaC9hcm0vaW5jbHVkZS9hc20vcGd0
YWJsZS5oDQpAQCAtNzQsNyArNzQsNyBAQCBleHRlcm4gcGdwcm90X3QJCXBncHJvdF9rZXJuZWw7
DQogDQogI2RlZmluZSBfTU9EX1BST1QocCwgYikJX19wZ3Byb3QocGdwcm90X3ZhbChwKSB8IChi
KSkNCiANCi0jZGVmaW5lIFBBR0VfTk9ORQkJX01PRF9QUk9UKHBncHJvdF91c2VyLCBMX1BURV9Y
TiB8IExfUFRFX1JET05MWSkNCisjZGVmaW5lIFBBR0VfTk9ORQkJX01PRF9QUk9UKHBncHJvdF91
c2VyLCBMX1BURV9YTiB8IExfUFRFX1JET05MWSB8IExfUFRFX05PTkUpDQogI2RlZmluZSBQQUdF
X1NIQVJFRAkJX01PRF9QUk9UKHBncHJvdF91c2VyLCBMX1BURV9VU0VSIHwgTF9QVEVfWE4pDQog
I2RlZmluZSBQQUdFX1NIQVJFRF9FWEVDCV9NT0RfUFJPVChwZ3Byb3RfdXNlciwgTF9QVEVfVVNF
UikNCiAjZGVmaW5lIFBBR0VfQ09QWQkJX01PRF9QUk9UKHBncHJvdF91c2VyLCBMX1BURV9VU0VS
IHwgTF9QVEVfUkRPTkxZIHwgTF9QVEVfWE4pDQpAQCAtODQsNyArODQsNyBAQCBleHRlcm4gcGdw
cm90X3QJCXBncHJvdF9rZXJuZWw7DQogI2RlZmluZSBQQUdFX0tFUk5FTAkJX01PRF9QUk9UKHBn
cHJvdF9rZXJuZWwsIExfUFRFX1hOKQ0KICNkZWZpbmUgUEFHRV9LRVJORUxfRVhFQwlwZ3Byb3Rf
a2VybmVsDQogDQotI2RlZmluZSBfX1BBR0VfTk9ORQkJX19wZ3Byb3QoX0xfUFRFX0RFRkFVTFQg
fCBMX1BURV9SRE9OTFkgfCBMX1BURV9YTikNCisjZGVmaW5lIF9fUEFHRV9OT05FCQlfX3BncHJv
dChfTF9QVEVfREVGQVVMVCB8IExfUFRFX1JET05MWSB8IExfUFRFX1hOIHwgTF9QVEVfTk9ORSkN
CiAjZGVmaW5lIF9fUEFHRV9TSEFSRUQJCV9fcGdwcm90KF9MX1BURV9ERUZBVUxUIHwgTF9QVEVf
VVNFUiB8IExfUFRFX1hOKQ0KICNkZWZpbmUgX19QQUdFX1NIQVJFRF9FWEVDCV9fcGdwcm90KF9M
X1BURV9ERUZBVUxUIHwgTF9QVEVfVVNFUikNCiAjZGVmaW5lIF9fUEFHRV9DT1BZCQlfX3BncHJv
dChfTF9QVEVfREVGQVVMVCB8IExfUFRFX1VTRVIgfCBMX1BURV9SRE9OTFkgfCBMX1BURV9YTikN
CkBAIC0yNzksNyArMjc5LDcgQEAgc3RhdGljIGlubGluZSBwdGVfdCBwdGVfbWtzcGVjaWFsKHB0
ZV90IHB0ZSkgeyByZXR1cm4gcHRlOyB9DQogDQogc3RhdGljIGlubGluZSBwdGVfdCBwdGVfbW9k
aWZ5KHB0ZV90IHB0ZSwgcGdwcm90X3QgbmV3cHJvdCkNCiB7DQotCWNvbnN0IHB0ZXZhbF90IG1h
c2sgPSBMX1BURV9YTiB8IExfUFRFX1JET05MWSB8IExfUFRFX1VTRVI7DQorCWNvbnN0IHB0ZXZh
bF90IG1hc2sgPSBMX1BURV9YTiB8IExfUFRFX1JET05MWSB8IExfUFRFX1VTRVIgfCBMX1BURV9O
T05FOw0KIAlwdGVfdmFsKHB0ZSkgPSAocHRlX3ZhbChwdGUpICYgfm1hc2spIHwgKHBncHJvdF92
YWwobmV3cHJvdCkgJiBtYXNrKTsNCiAJcmV0dXJuIHB0ZTsNCiB9DQpkaWZmIC0tZ2l0IGEvYXJj
aC9hcm0vbW0vS2NvbmZpZyBiL2FyY2gvYXJtL21tL0tjb25maWcNCmluZGV4IDY3Zjc1YTAuLjRl
MWVmNmUgMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9tbS9LY29uZmlnDQorKysgYi9hcmNoL2FybS9t
bS9LY29uZmlnDQpAQCAtNDU4LDcgKzQ1OCw2IEBAIGNvbmZpZyBDUFVfMzJ2NQ0KIGNvbmZpZyBD
UFVfMzJ2Ng0KIAlib29sDQogCXNlbGVjdCBUTFNfUkVHX0VNVUwgaWYgIUNQVV8zMnY2SyAmJiAh
TU1VDQotCXNlbGVjdCBDUFVfVVNFX0RPTUFJTlMgaWYgQ1BVX1Y2ICYmIE1NVQ0KIA0KIGNvbmZp
ZyBDUFVfMzJ2NksNCiAJYm9vbA0KQEAgLTY1Miw3ICs2NTEsNyBAQCBjb25maWcgQVJNX1RIVU1C
RUUNCiANCiBjb25maWcgU1dQX0VNVUxBVEUNCiAJYm9vbCAiRW11bGF0ZSBTV1AvU1dQQiBpbnN0
cnVjdGlvbnMiDQotCWRlcGVuZHMgb24gIUNQVV9VU0VfRE9NQUlOUyAmJiBDUFVfVjcNCisJZGVw
ZW5kcyBvbiBDUFVfVjcNCiAJc2VsZWN0IEhBVkVfUFJPQ19DUFUgaWYgUFJPQ19GUw0KIAlkZWZh
dWx0IHkgaWYgU01QDQogCWhlbHANCmRpZmYgLS1naXQgYS9hcmNoL2FybS9tbS9tbXUuYyBiL2Fy
Y2gvYXJtL21tL21tdS5jDQppbmRleCA5ZTI4ZmRiLi4wODJmYTE4IDEwMDY0NA0KLS0tIGEvYXJj
aC9hcm0vbW0vbW11LmMNCisrKyBiL2FyY2gvYXJtL21tL21tdS5jDQpAQCAtNDI2LDYgKzQyNiwx
NCBAQCBzdGF0aWMgdm9pZCBfX2luaXQgYnVpbGRfbWVtX3R5cGVfdGFibGUodm9pZCkNCiAJCW1l
bV90eXBlc1tNVF9NRU1PUllfTk9OQ0FDSEVEXS5wcm90X3B0ZSB8PSBMX1BURV9TSEFSRUQ7DQog
CX0NCiAJLyoNCisJICogV2UgZG9uJ3QgdXNlIGRvbWFpbnMgb24gQVJNdjYgKHNpbmNlIHRoaXMg
Y2F1c2VzIHByb2JsZW1zIHdpdGgNCisJICogdjYvdjcga2VybmVscyksIHNvIHdlIG11c3QgdXNl
IGEgc2VwYXJhdGUgbWVtb3J5IHR5cGUgZm9yIHVzZXINCisJICogci9vLCBrZXJuZWwgci93IHRv
IG1hcCB0aGUgdmVjdG9ycyBwYWdlLg0KKwkgKi8NCisJaWYgKGNwdV9hcmNoID09IENQVV9BUkNI
X0FSTXY2KQ0KKwkJdmVjc19wZ3Byb3QgfD0gTF9QVEVfTVRfVkVDVE9SUzsNCisNCisJLyoNCiAJ
ICogQVJNdjYgYW5kIGFib3ZlIGhhdmUgZXh0ZW5kZWQgcGFnZSB0YWJsZXMuDQogCSAqLw0KIAlp
ZiAoY3B1X2FyY2ggPj0gQ1BVX0FSQ0hfQVJNdjYgJiYgKGNyICYgQ1JfWFApKSB7DQpkaWZmIC0t
Z2l0IGEvYXJjaC9hcm0vbW0vcHJvYy1tYWNyb3MuUyBiL2FyY2gvYXJtL21tL3Byb2MtbWFjcm9z
LlMNCmluZGV4IDMwN2E0ZGUuLjhhM2VkZDQgMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9tbS9wcm9j
LW1hY3Jvcy5TDQorKysgYi9hcmNoL2FybS9tbS9wcm9jLW1hY3Jvcy5TDQpAQCAtMTA2LDEzICsx
MDYsOSBAQA0KICAqICAxMDB4ICAgMSAgIDAgICAxCXIvbwlubyBhY2MNCiAgKiAgMTB4MCAgIDEg
ICAwICAgMQlyL28Jbm8gYWNjDQogICogIDEwMTEgICAwICAgMCAgIDEJci93CW5vIGFjYw0KLSAq
ICAxMTB4ICAgMCAgIDEgICAwCXIvdwlyL28NCi0gKiAgMTF4MCAgIDAgICAxICAgMAlyL3cJci9v
DQotICogIDExMTEgICAwICAgMSAgIDEJci93CXIvdw0KLSAqDQotICogSWYgIUNPTkZJR19DUFVf
VVNFX0RPTUFJTlMsIHRoZSBmb2xsb3dpbmcgcGVybWlzc2lvbnMgYXJlIGNoYW5nZWQ6DQogICog
IDExMHggICAxICAgMSAgIDEJci9vCXIvbw0KICAqICAxMXgwICAgMSAgIDEgICAxCXIvbwlyL28N
CisgKiAgMTExMSAgIDAgICAxICAgMQlyL3cJci93DQogICovDQogCS5tYWNybwlhcm12Nl9tdF90
YWJsZSBwZngNCiBccGZ4XCgpX210X3RhYmxlOg0KQEAgLTEzMSw3ICsxMjcsNyBAQA0KIAkubG9u
ZwlQVEVfRVhUX1RFWCgyKQkJCQkJQCBMX1BURV9NVF9ERVZfTk9OU0hBUkVEDQogCS5sb25nCTB4
MDAJCQkJCQlAIHVudXNlZA0KIAkubG9uZwkweDAwCQkJCQkJQCB1bnVzZWQNCi0JLmxvbmcJMHgw
MAkJCQkJCUAgdW51c2VkDQorCS5sb25nCVBURV9DQUNIRUFCTEUgfCBQVEVfQlVGRkVSQUJMRSB8
IFBURV9FWFRfQVBYCUAgTF9QVEVfTVRfVkVDVE9SUw0KIAkuZW5kbQ0KIA0KIAkubWFjcm8JYXJt
djZfc2V0X3B0ZV9leHQgcGZ4DQpAQCAtMTUyLDIwICsxNDgsMjEgQEANCiANCiAJdHN0CXIxLCAj
TF9QVEVfVVNFUg0KIAlvcnJuZQlyMywgcjMsICNQVEVfRVhUX0FQMQ0KLSNpZmRlZiBDT05GSUdf
Q1BVX1VTRV9ET01BSU5TDQotCUAgYWxsb3cga2VybmVsIHJlYWQvd3JpdGUgYWNjZXNzIHRvIHJl
YWQtb25seSB1c2VyIHBhZ2VzDQogCXRzdG5lCXIzLCAjUFRFX0VYVF9BUFgNCi0JYmljbmUJcjMs
IHIzLCAjUFRFX0VYVF9BUFggfCBQVEVfRVhUX0FQMA0KLSNlbmRpZg0KKw0KKwlAIHVzZXIgcmVh
ZC1vbmx5IC0+IGtlcm5lbCByZWFkLW9ubHkNCisJYmljbmUJcjMsIHIzLCAjUFRFX0VYVF9BUDAN
CiANCiAJdHN0CXIxLCAjTF9QVEVfWE4NCiAJb3JybmUJcjMsIHIzLCAjUFRFX0VYVF9YTg0KIA0K
LQlvcnIJcjMsIHIzLCByMg0KKwllb3IJcjMsIHIzLCByMg0KIA0KIAl0c3QJcjEsICNMX1BURV9Z
T1VORw0KIAl0c3RuZQlyMSwgI0xfUFRFX1BSRVNFTlQNCiAJbW92ZXEJcjMsICMwDQorCXRzdG5l
CXIxLCAjTF9QVEVfTk9ORQ0KKwltb3ZuZQlyMywgIzANCiANCiAJc3RyCXIzLCBbcjBdDQogCW1j
cglwMTUsIDAsIHIwLCBjNywgYzEwLCAxCQlAIGZsdXNoX3B0ZQ0KZGlmZiAtLWdpdCBhL2FyY2gv
YXJtL21tL3Byb2MtdjcuUyBiL2FyY2gvYXJtL21tL3Byb2MtdjcuUw0KaW5kZXggMTlkMjFmZi4u
NDNjNjk4MSAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtL21tL3Byb2MtdjcuUw0KKysrIGIvYXJjaC9h
cm0vbW0vcHJvYy12Ny5TDQpAQCAtMTYwLDE3ICsxNjAsMTQgQEAgRU5UUlkoY3B1X3Y3X3NldF9w
dGVfZXh0KQ0KIA0KIAl0c3QJcjEsICNMX1BURV9VU0VSDQogCW9ycm5lCXIzLCByMywgI1BURV9F
WFRfQVAxDQotI2lmZGVmIENPTkZJR19DUFVfVVNFX0RPTUFJTlMNCi0JQCBhbGxvdyBrZXJuZWwg
cmVhZC93cml0ZSBhY2Nlc3MgdG8gcmVhZC1vbmx5IHVzZXIgcGFnZXMNCi0JdHN0bmUJcjMsICNQ
VEVfRVhUX0FQWA0KLQliaWNuZQlyMywgcjMsICNQVEVfRVhUX0FQWCB8IFBURV9FWFRfQVAwDQot
I2VuZGlmDQogDQogCXRzdAlyMSwgI0xfUFRFX1hODQogCW9ycm5lCXIzLCByMywgI1BURV9FWFRf
WE4NCiANCiAJdHN0CXIxLCAjTF9QVEVfWU9VTkcNCiAJdHN0bmUJcjEsICNMX1BURV9QUkVTRU5U
DQorCWVvcm5lCXIxLCByMSwgI0xfUFRFX05PTkUNCisJdHN0bmUJcjEsICNMX1BURV9OT05FDQog
CW1vdmVxCXIzLCAjMA0KIA0KICBBUk0oCXN0cglyMywgW3IwLCAjMjA0OF0hICkNCmRpZmYgLS1n
aXQgYS9hcmNoL21pcHMvcG93ZXIvaGliZXJuYXRlLlMgYi9hcmNoL21pcHMvcG93ZXIvaGliZXJu
YXRlLlMNCmluZGV4IGY4YTc1MWMuLjViZjM0ZWMgMTAwNjQ0DQotLS0gYS9hcmNoL21pcHMvcG93
ZXIvaGliZXJuYXRlLlMNCisrKyBiL2FyY2gvbWlwcy9wb3dlci9oaWJlcm5hdGUuUw0KQEAgLTQ0
LDYgKzQ0LDcgQEAgTEVBRihzd3N1c3BfYXJjaF9yZXN1bWUpDQogCWJuZSB0MSwgdDMsIDFiDQog
CVBUUl9MIHQwLCBQQkVfTkVYVCh0MCkNCiAJYm5leiB0MCwgMGINCisJamFsIGxvY2FsX2ZsdXNo
X3RsYl9hbGwgLyogQXZvaWQgVExCIG1pc21hdGNoIGFmdGVyIGtlcm5lbCByZXN1bWUgKi8NCiAJ
UFRSX0xBIHQwLCBzYXZlZF9yZWdzDQogCVBUUl9MIHJhLCBQVF9SMzEodDApDQogCVBUUl9MIHNw
LCBQVF9SMjkodDApDQpkaWZmIC0tZ2l0IGEvYXJjaC9zaC9rZXJuZWwvZHVtcHN0YWNrLmMgYi9h
cmNoL3NoL2tlcm5lbC9kdW1wc3RhY2suYw0KaW5kZXggNjk0MTU4Yi4uM2E2NTI4YyAxMDA2NDQN
Ci0tLSBhL2FyY2gvc2gva2VybmVsL2R1bXBzdGFjay5jDQorKysgYi9hcmNoL3NoL2tlcm5lbC9k
dW1wc3RhY2suYw0KQEAgLTgwLDcgKzgwLDcgQEAgc3RhdGljIGludCBwcmludF90cmFjZV9zdGFj
ayh2b2lkICpkYXRhLCBjaGFyICpuYW1lKQ0KICAqLw0KIHN0YXRpYyB2b2lkIHByaW50X3RyYWNl
X2FkZHJlc3Modm9pZCAqZGF0YSwgdW5zaWduZWQgbG9uZyBhZGRyLCBpbnQgcmVsaWFibGUpDQog
ew0KLQlwcmludGsoZGF0YSk7DQorCXByaW50aygiJXMiLCAoY2hhciAqKWRhdGEpOw0KIAlwcmlu
dGtfYWRkcmVzcyhhZGRyLCByZWxpYWJsZSk7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2FyY2gvc3Bh
cmMvS2NvbmZpZyBiL2FyY2gvc3BhcmMvS2NvbmZpZw0KaW5kZXggODc1MzdlMi4uODhkNDQyZCAx
MDA2NDQNCi0tLSBhL2FyY2gvc3BhcmMvS2NvbmZpZw0KKysrIGIvYXJjaC9zcGFyYy9LY29uZmln
DQpAQCAtMjQsNyArMjQsNyBAQCBjb25maWcgU1BBUkMNCiAJc2VsZWN0IEhBVkVfSVJRX1dPUksN
CiAJc2VsZWN0IEhBVkVfRE1BX0FUVFJTDQogCXNlbGVjdCBIQVZFX0RNQV9BUElfREVCVUcNCi0J
c2VsZWN0IEhBVkVfQVJDSF9KVU1QX0xBQkVMDQorCXNlbGVjdCBIQVZFX0FSQ0hfSlVNUF9MQUJF
TCBpZiBTUEFSQzY0DQogCXNlbGVjdCBIQVZFX0dFTkVSSUNfSEFSRElSUVMNCiAJc2VsZWN0IEdF
TkVSSUNfSVJRX1NIT1cNCiAJc2VsZWN0IFVTRV9HRU5FUklDX1NNUF9IRUxQRVJTIGlmIFNNUA0K
ZGlmZiAtLWdpdCBhL2FyY2gvc3BhcmMvaW5jbHVkZS9hc20vdWFjY2Vzc182NC5oIGIvYXJjaC9z
cGFyYy9pbmNsdWRlL2FzbS91YWNjZXNzXzY0LmgNCmluZGV4IDNlMTQ0OWYuLjZkNmM3MzEgMTAw
NjQ0DQotLS0gYS9hcmNoL3NwYXJjL2luY2x1ZGUvYXNtL3VhY2Nlc3NfNjQuaA0KKysrIGIvYXJj
aC9zcGFyYy9pbmNsdWRlL2FzbS91YWNjZXNzXzY0LmgNCkBAIC0yNjcsOCArMjY3LDggQEAgZXh0
ZXJuIGxvbmcgX19zdHJubGVuX3VzZXIoY29uc3QgY2hhciBfX3VzZXIgKiwgbG9uZyBsZW4pOw0K
IA0KICNkZWZpbmUgc3RybGVuX3VzZXIgX19zdHJsZW5fdXNlcg0KICNkZWZpbmUgc3Rybmxlbl91
c2VyIF9fc3Rybmxlbl91c2VyDQotI2RlZmluZSBfX2NvcHlfdG9fdXNlcl9pbmF0b21pYyBfX19j
b3B5X3RvX3VzZXINCi0jZGVmaW5lIF9fY29weV9mcm9tX3VzZXJfaW5hdG9taWMgX19fY29weV9m
cm9tX3VzZXINCisjZGVmaW5lIF9fY29weV90b191c2VyX2luYXRvbWljIF9fY29weV90b191c2Vy
DQorI2RlZmluZSBfX2NvcHlfZnJvbV91c2VyX2luYXRvbWljIF9fY29weV9mcm9tX3VzZXINCiAN
CiAjZW5kaWYgIC8qIF9fQVNTRU1CTFlfXyAqLw0KIA0KZGlmZiAtLWdpdCBhL2FyY2gvc3BhcmMv
a2VybmVsL3BjaS5jIGIvYXJjaC9zcGFyYy9rZXJuZWwvcGNpLmMNCmluZGV4IDMxMTExZTMuLjY1
NmI1YjYgMTAwNjQ0DQotLS0gYS9hcmNoL3NwYXJjL2tlcm5lbC9wY2kuYw0KKysrIGIvYXJjaC9z
cGFyYy9rZXJuZWwvcGNpLmMNCkBAIC00ODcsOCArNDg3LDggQEAgc3RhdGljIHZvaWQgX19kZXZp
bml0IGFwYl9mYWtlX3JhbmdlcyhzdHJ1Y3QgcGNpX2RldiAqZGV2LA0KIAlwY2lfcmVhZF9jb25m
aWdfYnl0ZShkZXYsIEFQQl9NRU1fQUREUkVTU19NQVAsICZtYXApOw0KIAlhcGJfY2FsY19maXJz
dF9sYXN0KG1hcCwgJmZpcnN0LCAmbGFzdCk7DQogCXJlcyA9IGJ1cy0+cmVzb3VyY2VbMV07DQot
CXJlcy0+c3RhcnQgPSAoZmlyc3QgPDwgMjEpOw0KLQlyZXMtPmVuZCA9IChsYXN0IDw8IDIxKSAr
ICgoMSA8PCAyMSkgLSAxKTsNCisJcmVzLT5zdGFydCA9IChmaXJzdCA8PCAyOSk7DQorCXJlcy0+
ZW5kID0gKGxhc3QgPDwgMjkpICsgKCgxIDw8IDI5KSAtIDEpOw0KIAlyZXMtPmZsYWdzID0gSU9S
RVNPVVJDRV9NRU07DQogCXBjaV9yZXNvdXJjZV9hZGp1c3QocmVzLCAmcGJtLT5tZW1fc3BhY2Up
Ow0KIH0NCmRpZmYgLS1naXQgYS9hcmNoL3NwYXJjL2tlcm5lbC9zeXNjYWxscy5TIGIvYXJjaC9z
cGFyYy9rZXJuZWwvc3lzY2FsbHMuUw0KaW5kZXggODE3MTg3ZC4uNTU3MjEyYyAxMDA2NDQNCi0t
LSBhL2FyY2gvc3BhcmMva2VybmVsL3N5c2NhbGxzLlMNCisrKyBiL2FyY2gvc3BhcmMva2VybmVs
L3N5c2NhbGxzLlMNCkBAIC0xODQsNyArMTg0LDggQEAgbGludXhfc3BhcmNfc3lzY2FsbDMyOg0K
IAkgbW92CSVpMCwgJWw1CQkJCSEgSUVVMQ0KIDU6CWNhbGwJJWw3CQkJCQkhIENUSQlHcm91cCBi
cmsgZm9yY2VkDQogCSBzcmwJJWk1LCAwLCAlbzUJCQkJISBJRVUxDQotCWJhLGEscHQJJXhjYywg
M2YNCisJYmEscHQJJXhjYywgM2YNCisJIHNyYQklbzAsIDAsICVvMA0KIA0KIAkvKiBMaW51eCBu
YXRpdmUgc3lzdGVtIGNhbGxzIGVudGVyIGhlcmUuLi4gKi8NCiAJLmFsaWduCTMyDQpAQCAtMjEy
LDcgKzIxMyw2IEBAIGxpbnV4X3NwYXJjX3N5c2NhbGw6DQogMzoJc3R4CSVvMCwgWyVzcCArIFBU
UkVHU19PRkYgKyBQVF9WOV9JMF0NCiByZXRfc3lzX2NhbGw6DQogCWxkeAlbJXNwICsgUFRSRUdT
X09GRiArIFBUX1Y5X1RTVEFURV0sICVnMw0KLQlzcmEJJW8wLCAwLCAlbzANCiAJbW92CSV1bG8o
VFNUQVRFX1hDQVJSWSB8IFRTVEFURV9JQ0FSUlkpLCAlZzINCiAJc2xseAklZzIsIDMyLCAlZzIN
CiANCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L21zaHlwZXJ2LmMgYi9hcmNoL3g4
Ni9rZXJuZWwvY3B1L21zaHlwZXJ2LmMNCmluZGV4IDY0NmQxOTIuLjFhM2NmNmUgMTAwNjQ0DQot
LS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L21zaHlwZXJ2LmMNCisrKyBiL2FyY2gveDg2L2tlcm5l
bC9jcHUvbXNoeXBlcnYuYw0KQEAgLTE4LDYgKzE4LDcgQEANCiAjaW5jbHVkZSA8YXNtL2h5cGVy
dmlzb3IuaD4NCiAjaW5jbHVkZSA8YXNtL2h5cGVydi5oPg0KICNpbmNsdWRlIDxhc20vbXNoeXBl
cnYuaD4NCisjaW5jbHVkZSA8YXNtL3RpbWVyLmg+DQogDQogc3RydWN0IG1zX2h5cGVydl9pbmZv
IG1zX2h5cGVydjsNCiBFWFBPUlRfU1lNQk9MX0dQTChtc19oeXBlcnYpOw0KQEAgLTcwLDYgKzcx
LDExIEBAIHN0YXRpYyB2b2lkIF9faW5pdCBtc19oeXBlcnZfaW5pdF9wbGF0Zm9ybSh2b2lkKQ0K
IA0KIAlpZiAobXNfaHlwZXJ2LmZlYXR1cmVzICYgSFZfWDY0X01TUl9USU1FX1JFRl9DT1VOVF9B
VkFJTEFCTEUpDQogCQljbG9ja3NvdXJjZV9yZWdpc3Rlcl9oeigmaHlwZXJ2X2NzLCBOU0VDX1BF
Ul9TRUMvMTAwKTsNCisNCisjaWZkZWYgQ09ORklHX1g4Nl9JT19BUElDDQorCW5vX3RpbWVyX2No
ZWNrID0gMTsNCisjZW5kaWYNCisNCiB9DQogDQogY29uc3QgX19yZWZjb25zdCBzdHJ1Y3QgaHlw
ZXJ2aXNvcl94ODYgeDg2X2h5cGVyX21zX2h5cGVydiA9IHsNCmRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9rZXJuZWwvbGR0LmMgYi9hcmNoL3g4Ni9rZXJuZWwvbGR0LmMNCmluZGV4IGVhNjk3MjYuLjRh
YzQ1MzEgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvbGR0LmMNCisrKyBiL2FyY2gveDg2
L2tlcm5lbC9sZHQuYw0KQEAgLTIzMCw2ICsyMzAsMTcgQEAgc3RhdGljIGludCB3cml0ZV9sZHQo
dm9pZCBfX3VzZXIgKnB0ciwgdW5zaWduZWQgbG9uZyBieXRlY291bnQsIGludCBvbGRtb2RlKQ0K
IAkJfQ0KIAl9DQogDQorCS8qDQorCSAqIE9uIHg4Ni02NCB3ZSBkbyBub3Qgc3VwcG9ydCAxNi1i
aXQgc2VnbWVudHMgZHVlIHRvDQorCSAqIElSRVQgbGVha2luZyB0aGUgaGlnaCBiaXRzIG9mIHRo
ZSBrZXJuZWwgc3RhY2sgYWRkcmVzcy4NCisJICovDQorI2lmZGVmIENPTkZJR19YODZfNjQNCisJ
aWYgKCFsZHRfaW5mby5zZWdfMzJiaXQpIHsNCisJCWVycm9yID0gLUVJTlZBTDsNCisJCWdvdG8g
b3V0X3VubG9jazsNCisJfQ0KKyNlbmRpZg0KKw0KIAlmaWxsX2xkdCgmbGR0LCAmbGR0X2luZm8p
Ow0KIAlpZiAob2xkbW9kZSkNCiAJCWxkdC5hdmwgPSAwOw0KZGlmZiAtLWdpdCBhL2Jsb2NrL2Js
ay1jb3JlLmMgYi9ibG9jay9ibGstY29yZS5jDQppbmRleCBhMjE5Yzg5Li5lYzQ5NGZmIDEwMDY0
NA0KLS0tIGEvYmxvY2svYmxrLWNvcmUuYw0KKysrIGIvYmxvY2svYmxrLWNvcmUuYw0KQEAgLTIw
NzcsNyArMjA3Nyw3IEBAIGJvb2wgYmxrX3VwZGF0ZV9yZXF1ZXN0KHN0cnVjdCByZXF1ZXN0ICpy
ZXEsIGludCBlcnJvciwgdW5zaWduZWQgaW50IG5yX2J5dGVzKQ0KIAlpZiAoIXJlcS0+YmlvKQ0K
IAkJcmV0dXJuIGZhbHNlOw0KIA0KLQl0cmFjZV9ibG9ja19ycV9jb21wbGV0ZShyZXEtPnEsIHJl
cSk7DQorCXRyYWNlX2Jsb2NrX3JxX2NvbXBsZXRlKHJlcS0+cSwgcmVxLCBucl9ieXRlcyk7DQog
DQogCS8qDQogCSAqIEZvciBmcyByZXF1ZXN0cywgcnEgaXMganVzdCBjYXJyaWVyIG9mIGluZGVw
ZW5kZW50IGJpbydzDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL2lwbWkvaXBtaV9idF9zbS5j
IGIvZHJpdmVycy9jaGFyL2lwbWkvaXBtaV9idF9zbS5jDQppbmRleCA5MmNlMzAyLi4yNjNmODk5
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9jaGFyL2lwbWkvaXBtaV9idF9zbS5jDQorKysgYi9kcml2
ZXJzL2NoYXIvaXBtaS9pcG1pX2J0X3NtLmMNCkBAIC0zNTIsNyArMzUyLDcgQEAgc3RhdGljIGlu
bGluZSB2b2lkIHdyaXRlX2FsbF9ieXRlcyhzdHJ1Y3Qgc2lfc21fZGF0YSAqYnQpDQogDQogc3Rh
dGljIGlubGluZSBpbnQgcmVhZF9hbGxfYnl0ZXMoc3RydWN0IHNpX3NtX2RhdGEgKmJ0KQ0KIHsN
Ci0JdW5zaWduZWQgY2hhciBpOw0KKwl1bnNpZ25lZCBpbnQgaTsNCiANCiAJLyoNCiAJICogbGVu
Z3RoIGlzICJmcmFtaW5nIGluZm8iLCBtaW5pbXVtID0gNDogTmV0Rm4sIFNlcSwgQ21kLCBjQ29k
ZS4NCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvcG93ZXJub3ctazYuYyBiL2RyaXZlcnMv
Y3B1ZnJlcS9wb3dlcm5vdy1rNi5jDQppbmRleCBiMzM3OWQ2Li4yYzZiNjcxIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9jcHVmcmVxL3Bvd2Vybm93LWs2LmMNCisrKyBiL2RyaXZlcnMvY3B1ZnJlcS9w
b3dlcm5vdy1rNi5jDQpAQCAtMjUsNDEgKzI1LDEwOCBAQA0KIHN0YXRpYyB1bnNpZ25lZCBpbnQg
ICAgICAgICAgICAgICAgICAgICBidXNmcmVxOyAgIC8qIEZTQiwgaW4gMTAga0h6ICovDQogc3Rh
dGljIHVuc2lnbmVkIGludCAgICAgICAgICAgICAgICAgICAgIG1heF9tdWx0aXBsaWVyOw0KIA0K
K3N0YXRpYyB1bnNpZ25lZCBpbnQJCQlwYXJhbV9idXNmcmVxID0gMDsNCitzdGF0aWMgdW5zaWdu
ZWQgaW50CQkJcGFyYW1fbWF4X211bHRpcGxpZXIgPSAwOw0KKw0KK21vZHVsZV9wYXJhbV9uYW1l
ZChtYXhfbXVsdGlwbGllciwgcGFyYW1fbWF4X211bHRpcGxpZXIsIHVpbnQsIFNfSVJVR08pOw0K
K01PRFVMRV9QQVJNX0RFU0MobWF4X211bHRpcGxpZXIsICJNYXhpbXVtIG11bHRpcGxpZXIgKGFs
bG93ZWQgdmFsdWVzOiAyMCAzMCAzNSA0MCA0NSA1MCA1NSA2MCkiKTsNCisNCittb2R1bGVfcGFy
YW1fbmFtZWQoYnVzX2ZyZXF1ZW5jeSwgcGFyYW1fYnVzZnJlcSwgdWludCwgU19JUlVHTyk7DQor
TU9EVUxFX1BBUk1fREVTQyhidXNfZnJlcXVlbmN5LCAiQnVzIGZyZXF1ZW5jeSBpbiBrSHoiKTsN
CiANCiAvKiBDbG9jayByYXRpbyBtdWx0aXBsaWVkIGJ5IDEwIC0gc2VlIHRhYmxlIDI3IGluIEFN
RCMyMzQ0NiAqLw0KIHN0YXRpYyBzdHJ1Y3QgY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGUgY2xvY2tf
cmF0aW9bXSA9IHsNCi0JezQ1LCAgLyogMDAwIC0+IDQuNXggKi8gMH0sDQorCXs2MCwgIC8qIDEx
MCAtPiA2LjB4ICovIDB9LA0KKwl7NTUsICAvKiAwMTEgLT4gNS41eCAqLyAwfSwNCiAJezUwLCAg
LyogMDAxIC0+IDUuMHggKi8gMH0sDQorCXs0NSwgIC8qIDAwMCAtPiA0LjV4ICovIDB9LA0KIAl7
NDAsICAvKiAwMTAgLT4gNC4weCAqLyAwfSwNCi0JezU1LCAgLyogMDExIC0+IDUuNXggKi8gMH0s
DQotCXsyMCwgIC8qIDEwMCAtPiAyLjB4ICovIDB9LA0KLQl7MzAsICAvKiAxMDEgLT4gMy4weCAq
LyAwfSwNCi0JezYwLCAgLyogMTEwIC0+IDYuMHggKi8gMH0sDQogCXszNSwgIC8qIDExMSAtPiAz
LjV4ICovIDB9LA0KKwl7MzAsICAvKiAxMDEgLT4gMy4weCAqLyAwfSwNCisJezIwLCAgLyogMTAw
IC0+IDIuMHggKi8gMH0sDQogCXswLCBDUFVGUkVRX1RBQkxFX0VORH0NCiB9Ow0KIA0KK3N0YXRp
YyBjb25zdCB1OCBpbmRleF90b19yZWdpc3Rlcls4XSA9IHsgNiwgMywgMSwgMCwgMiwgNywgNSwg
NCB9Ow0KK3N0YXRpYyBjb25zdCB1OCByZWdpc3Rlcl90b19pbmRleFs4XSA9IHsgMywgMiwgNCwg
MSwgNywgNiwgMCwgNSB9Ow0KKw0KK3N0YXRpYyBjb25zdCBzdHJ1Y3Qgew0KKwl1bnNpZ25lZCBm
cmVxOw0KKwl1bnNpZ25lZCBtdWx0Ow0KK30gdXN1YWxfZnJlcXVlbmN5X3RhYmxlW10gPSB7DQor
CXsgNDAwMDAwLCA0MCB9LAkvLyAxMDAgICAqIDQNCisJeyA0NTAwMDAsIDQ1IH0sIC8vIDEwMCAg
ICogNC41DQorCXsgNDc1MDAwLCA1MCB9LCAvLyAgOTUgICAqIDUNCisJeyA1MDAwMDAsIDUwIH0s
IC8vIDEwMCAgICogNQ0KKwl7IDUwNjI1MCwgNDUgfSwgLy8gMTEyLjUgKiA0LjUNCisJeyA1MzM1
MDAsIDU1IH0sIC8vICA5NyAgICogNS41DQorCXsgNTUwMDAwLCA1NSB9LCAvLyAxMDAgICAqIDUu
NQ0KKwl7IDU2MjUwMCwgNTAgfSwgLy8gMTEyLjUgKiA1DQorCXsgNTcwMDAwLCA2MCB9LCAvLyAg
OTUgICAqIDYNCisJeyA2MDAwMDAsIDYwIH0sIC8vIDEwMCAgICogNg0KKwl7IDYxODc1MCwgNTUg
fSwgLy8gMTEyLjUgKiA1LjUNCisJeyA2NjAwMDAsIDU1IH0sIC8vIDEyMCAgICogNS41DQorCXsg
Njc1MDAwLCA2MCB9LCAvLyAxMTIuNSAqIDYNCisJeyA3MjAwMDAsIDYwIH0sIC8vIDEyMCAgICog
Ng0KK307DQorDQorI2RlZmluZSBGUkVRX1JBTkdFCQkzMDAwDQogDQogLyoqDQogICogcG93ZXJu
b3dfazZfZ2V0X2NwdV9tdWx0aXBsaWVyIC0gcmV0dXJucyB0aGUgY3VycmVudCBGU0IgbXVsdGlw
bGllcg0KICAqDQotICogICBSZXR1cm5zIHRoZSBjdXJyZW50IHNldHRpbmcgb2YgdGhlIGZyZXF1
ZW5jeSBtdWx0aXBsaWVyLiBDb3JlIGNsb2NrDQorICogUmV0dXJucyB0aGUgY3VycmVudCBzZXR0
aW5nIG9mIHRoZSBmcmVxdWVuY3kgbXVsdGlwbGllci4gQ29yZSBjbG9jaw0KICAqIHNwZWVkIGlz
IGZyZXF1ZW5jeSBvZiB0aGUgRnJvbnQtU2lkZSBCdXMgbXVsdGlwbGllZCB3aXRoIHRoaXMgdmFs
dWUuDQogICovDQogc3RhdGljIGludCBwb3dlcm5vd19rNl9nZXRfY3B1X211bHRpcGxpZXIodm9p
ZCkNCiB7DQotCXU2NCBpbnZhbHVlID0gMDsNCisJdW5zaWduZWQgbG9uZyBpbnZhbHVlID0gMDsN
CiAJdTMyIG1zcnZhbDsNCiANCisJbG9jYWxfaXJxX2Rpc2FibGUoKTsNCisNCiAJbXNydmFsID0g
UE9XRVJOT1dfSU9QT1JUICsgMHgxOw0KIAl3cm1zcihNU1JfSzZfRVBNUiwgbXNydmFsLCAwKTsg
LyogZW5hYmxlIHRoZSBQb3dlck5vdyBwb3J0ICovDQogCWludmFsdWUgPSBpbmwoUE9XRVJOT1df
SU9QT1JUICsgMHg4KTsNCiAJbXNydmFsID0gUE9XRVJOT1dfSU9QT1JUICsgMHgwOw0KIAl3cm1z
cihNU1JfSzZfRVBNUiwgbXNydmFsLCAwKTsgLyogZGlzYWJsZSBpdCBhZ2FpbiAqLw0KIA0KLQly
ZXR1cm4gY2xvY2tfcmF0aW9bKGludmFsdWUgPj4gNSkmN10uaW5kZXg7DQorCWxvY2FsX2lycV9l
bmFibGUoKTsNCisNCisJcmV0dXJuIGNsb2NrX3JhdGlvW3JlZ2lzdGVyX3RvX2luZGV4WyhpbnZh
bHVlID4+IDUpJjddXS5pbmRleDsNCiB9DQogDQorc3RhdGljIHZvaWQgcG93ZXJub3dfazZfc2V0
X2NwdV9tdWx0aXBsaWVyKHVuc2lnbmVkIGludCBiZXN0X2kpDQorew0KKwl1bnNpZ25lZCBsb25n
IG91dHZhbHVlLCBpbnZhbHVlOw0KKwl1bnNpZ25lZCBsb25nIG1zcnZhbDsNCisJdW5zaWduZWQg
bG9uZyBjcjA7DQorDQorCS8qIHdlIG5vdyBuZWVkIHRvIHRyYW5zZm9ybSBiZXN0X2kgdG8gdGhl
IEJWQyBmb3JtYXQsIHNlZSBBTUQjMjM0NDYgKi8NCisNCisJLyoNCisJICogVGhlIHByb2Nlc3Nv
ciBkb2Vzbid0IHJlc3BvbmQgdG8gaW5xdWlyeSBjeWNsZXMgd2hpbGUgY2hhbmdpbmcgdGhlDQor
CSAqIGZyZXF1ZW5jeSwgc28gd2UgbXVzdCBkaXNhYmxlIGNhY2hlLg0KKwkgKi8NCisJbG9jYWxf
aXJxX2Rpc2FibGUoKTsNCisJY3IwID0gcmVhZF9jcjAoKTsNCisJd3JpdGVfY3IwKGNyMCB8IFg4
Nl9DUjBfQ0QpOw0KKwl3YmludmQoKTsNCisNCisJb3V0dmFsdWUgPSAoMTw8MTIpIHwgKDE8PDEw
KSB8ICgxPDw5KSB8IChpbmRleF90b19yZWdpc3RlcltiZXN0X2ldPDw1KTsNCisNCisJbXNydmFs
ID0gUE9XRVJOT1dfSU9QT1JUICsgMHgxOw0KKwl3cm1zcihNU1JfSzZfRVBNUiwgbXNydmFsLCAw
KTsgLyogZW5hYmxlIHRoZSBQb3dlck5vdyBwb3J0ICovDQorCWludmFsdWUgPSBpbmwoUE9XRVJO
T1dfSU9QT1JUICsgMHg4KTsNCisJaW52YWx1ZSA9IGludmFsdWUgJiAweDFmOw0KKwlvdXR2YWx1
ZSA9IG91dHZhbHVlIHwgaW52YWx1ZTsNCisJb3V0bChvdXR2YWx1ZSwgKFBPV0VSTk9XX0lPUE9S
VCArIDB4OCkpOw0KKwltc3J2YWwgPSBQT1dFUk5PV19JT1BPUlQgKyAweDA7DQorCXdybXNyKE1T
Ul9LNl9FUE1SLCBtc3J2YWwsIDApOyAvKiBkaXNhYmxlIGl0IGFnYWluICovDQorDQorCXdyaXRl
X2NyMChjcjApOw0KKwlsb2NhbF9pcnFfZW5hYmxlKCk7DQorfQ0KIA0KIC8qKg0KICAqIHBvd2Vy
bm93X2s2X3NldF9zdGF0ZSAtIHNldCB0aGUgUG93ZXJOb3chIG11bHRpcGxpZXINCkBAIC02OSw4
ICsxMzYsNiBAQCBzdGF0aWMgaW50IHBvd2Vybm93X2s2X2dldF9jcHVfbXVsdGlwbGllcih2b2lk
KQ0KICAqLw0KIHN0YXRpYyB2b2lkIHBvd2Vybm93X2s2X3NldF9zdGF0ZSh1bnNpZ25lZCBpbnQg
YmVzdF9pKQ0KIHsNCi0JdW5zaWduZWQgbG9uZyBvdXR2YWx1ZSA9IDAsIGludmFsdWUgPSAwOw0K
LQl1bnNpZ25lZCBsb25nIG1zcnZhbDsNCiAJc3RydWN0IGNwdWZyZXFfZnJlcXMgZnJlcXM7DQog
DQogCWlmIChjbG9ja19yYXRpb1tiZXN0X2ldLmluZGV4ID4gbWF4X211bHRpcGxpZXIpIHsNCkBA
IC04NCwxOCArMTQ5LDcgQEAgc3RhdGljIHZvaWQgcG93ZXJub3dfazZfc2V0X3N0YXRlKHVuc2ln
bmVkIGludCBiZXN0X2kpDQogDQogCWNwdWZyZXFfbm90aWZ5X3RyYW5zaXRpb24oJmZyZXFzLCBD
UFVGUkVRX1BSRUNIQU5HRSk7DQogDQotCS8qIHdlIG5vdyBuZWVkIHRvIHRyYW5zZm9ybSBiZXN0
X2kgdG8gdGhlIEJWQyBmb3JtYXQsIHNlZSBBTUQjMjM0NDYgKi8NCi0NCi0Jb3V0dmFsdWUgPSAo
MTw8MTIpIHwgKDE8PDEwKSB8ICgxPDw5KSB8IChiZXN0X2k8PDUpOw0KLQ0KLQltc3J2YWwgPSBQ
T1dFUk5PV19JT1BPUlQgKyAweDE7DQotCXdybXNyKE1TUl9LNl9FUE1SLCBtc3J2YWwsIDApOyAv
KiBlbmFibGUgdGhlIFBvd2VyTm93IHBvcnQgKi8NCi0JaW52YWx1ZSA9IGlubChQT1dFUk5PV19J
T1BPUlQgKyAweDgpOw0KLQlpbnZhbHVlID0gaW52YWx1ZSAmIDB4ZjsNCi0Jb3V0dmFsdWUgPSBv
dXR2YWx1ZSB8IGludmFsdWU7DQotCW91dGwob3V0dmFsdWUgLCAoUE9XRVJOT1dfSU9QT1JUICsg
MHg4KSk7DQotCW1zcnZhbCA9IFBPV0VSTk9XX0lPUE9SVCArIDB4MDsNCi0Jd3Jtc3IoTVNSX0s2
X0VQTVIsIG1zcnZhbCwgMCk7IC8qIGRpc2FibGUgaXQgYWdhaW4gKi8NCisJcG93ZXJub3dfazZf
c2V0X2NwdV9tdWx0aXBsaWVyKGJlc3RfaSk7DQogDQogCWNwdWZyZXFfbm90aWZ5X3RyYW5zaXRp
b24oJmZyZXFzLCBDUFVGUkVRX1BPU1RDSEFOR0UpOw0KIA0KQEAgLTE0MCwxOCArMTk0LDU3IEBA
IHN0YXRpYyBpbnQgcG93ZXJub3dfazZfdGFyZ2V0KHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9s
aWN5LA0KIAlyZXR1cm4gMDsNCiB9DQogDQotDQogc3RhdGljIGludCBwb3dlcm5vd19rNl9jcHVf
aW5pdChzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSkNCiB7DQogCXVuc2lnbmVkIGludCBp
LCBmOw0KIAlpbnQgcmVzdWx0Ow0KKwl1bnNpZ25lZCBraHo7DQogDQogCWlmIChwb2xpY3ktPmNw
dSAhPSAwKQ0KIAkJcmV0dXJuIC1FTk9ERVY7DQogDQotCS8qIGdldCBmcmVxdWVuY2llcyAqLw0K
LQltYXhfbXVsdGlwbGllciA9IHBvd2Vybm93X2s2X2dldF9jcHVfbXVsdGlwbGllcigpOw0KLQli
dXNmcmVxID0gY3B1X2toeiAvIG1heF9tdWx0aXBsaWVyOw0KKwltYXhfbXVsdGlwbGllciA9IDA7
DQorCWtoeiA9IGNwdV9raHo7DQorCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHVzdWFsX2Zy
ZXF1ZW5jeV90YWJsZSk7IGkrKykgew0KKwkJaWYgKGtoeiA+PSB1c3VhbF9mcmVxdWVuY3lfdGFi
bGVbaV0uZnJlcSAtIEZSRVFfUkFOR0UgJiYNCisJCSAgICBraHogPD0gdXN1YWxfZnJlcXVlbmN5
X3RhYmxlW2ldLmZyZXEgKyBGUkVRX1JBTkdFKSB7DQorCQkJa2h6ID0gdXN1YWxfZnJlcXVlbmN5
X3RhYmxlW2ldLmZyZXE7DQorCQkJbWF4X211bHRpcGxpZXIgPSB1c3VhbF9mcmVxdWVuY3lfdGFi
bGVbaV0ubXVsdDsNCisJCQlicmVhazsNCisJCX0NCisJfQ0KKwlpZiAocGFyYW1fbWF4X211bHRp
cGxpZXIpIHsNCisJCWZvciAoaSA9IDA7IChjbG9ja19yYXRpb1tpXS5mcmVxdWVuY3kgIT0gQ1BV
RlJFUV9UQUJMRV9FTkQpOyBpKyspIHsNCisJCQlpZiAoY2xvY2tfcmF0aW9baV0uaW5kZXggPT0g
cGFyYW1fbWF4X211bHRpcGxpZXIpIHsNCisJCQkJbWF4X211bHRpcGxpZXIgPSBwYXJhbV9tYXhf
bXVsdGlwbGllcjsNCisJCQkJZ290byBoYXZlX21heF9tdWx0aXBsaWVyOw0KKwkJCX0NCisJCX0N
CisJCXByaW50ayhLRVJOX0VSUiAicG93ZXJub3ctazY6IGludmFsaWQgbWF4X211bHRpcGxpZXIg
cGFyYW1ldGVyLCB2YWxpZCBwYXJhbWV0ZXJzIDIwLCAzMCwgMzUsIDQwLCA0NSwgNTAsIDU1LCA2
MFxuIik7DQorCQlyZXR1cm4gLUVJTlZBTDsNCisJfQ0KKw0KKwlpZiAoIW1heF9tdWx0aXBsaWVy
KSB7DQorCQlwcmludGsoS0VSTl9XQVJOSU5HICJwb3dlcm5vdy1rNjogdW5rbm93biBmcmVxdWVu
Y3kgJXUsIGNhbm5vdCBkZXRlcm1pbmUgY3VycmVudCBtdWx0aXBsaWVyXG4iLCBraHopOw0KKwkJ
cHJpbnRrKEtFUk5fV0FSTklORyAicG93ZXJub3ctazY6IHVzZSBtb2R1bGUgcGFyYW1ldGVycyBt
YXhfbXVsdGlwbGllciBhbmQgYnVzX2ZyZXF1ZW5jeVxuIik7DQorCQlyZXR1cm4gLUVPUE5PVFNV
UFA7DQorCX0NCisNCitoYXZlX21heF9tdWx0aXBsaWVyOg0KKwlwYXJhbV9tYXhfbXVsdGlwbGll
ciA9IG1heF9tdWx0aXBsaWVyOw0KKw0KKwlpZiAocGFyYW1fYnVzZnJlcSkgew0KKwkJaWYgKHBh
cmFtX2J1c2ZyZXEgPj0gNTAwMDAgJiYgcGFyYW1fYnVzZnJlcSA8PSAxNTAwMDApIHsNCisJCQli
dXNmcmVxID0gcGFyYW1fYnVzZnJlcSAvIDEwOw0KKwkJCWdvdG8gaGF2ZV9idXNmcmVxOw0KKwkJ
fQ0KKwkJcHJpbnRrKEtFUk5fRVJSICJwb3dlcm5vdy1rNjogaW52YWxpZCBidXNfZnJlcXVlbmN5
IHBhcmFtZXRlciwgYWxsb3dlZCByYW5nZSA1MDAwMCAtIDE1MDAwMCBrSHpcbiIpOw0KKwkJcmV0
dXJuIC1FSU5WQUw7DQorCX0NCisNCisJYnVzZnJlcSA9IGtoeiAvIG1heF9tdWx0aXBsaWVyOw0K
K2hhdmVfYnVzZnJlcToNCisJcGFyYW1fYnVzZnJlcSA9IGJ1c2ZyZXEgKiAxMDsNCiANCiAJLyog
dGFibGUgaW5pdCAqLw0KIAlmb3IgKGkgPSAwOyAoY2xvY2tfcmF0aW9baV0uZnJlcXVlbmN5ICE9
IENQVUZSRVFfVEFCTEVfRU5EKTsgaSsrKSB7DQpAQCAtMTYzLDcgKzI1Niw3IEBAIHN0YXRpYyBp
bnQgcG93ZXJub3dfazZfY3B1X2luaXQoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3kpDQog
CX0NCiANCiAJLyogY3B1aW5mbyBhbmQgZGVmYXVsdCBwb2xpY3kgdmFsdWVzICovDQotCXBvbGlj
eS0+Y3B1aW5mby50cmFuc2l0aW9uX2xhdGVuY3kgPSAyMDAwMDA7DQorCXBvbGljeS0+Y3B1aW5m
by50cmFuc2l0aW9uX2xhdGVuY3kgPSA1MDAwMDA7DQogCXBvbGljeS0+Y3VyID0gYnVzZnJlcSAq
IG1heF9tdWx0aXBsaWVyOw0KIA0KIAlyZXN1bHQgPSBjcHVmcmVxX2ZyZXF1ZW5jeV90YWJsZV9j
cHVpbmZvKHBvbGljeSwgY2xvY2tfcmF0aW8pOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3Bpby9n
cGlvLW14cy5jIGIvZHJpdmVycy9ncGlvL2dwaW8tbXhzLmMNCmluZGV4IDM4NWM1OGUuLjBmODEx
NGQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwaW8vZ3Bpby1teHMuYw0KKysrIGIvZHJpdmVycy9n
cGlvL2dwaW8tbXhzLmMNCkBAIC0xNjcsNyArMTY3LDggQEAgc3RhdGljIHZvaWQgX19pbml0IG14
c19ncGlvX2luaXRfZ2Moc3RydWN0IG14c19ncGlvX3BvcnQgKnBvcnQpDQogCWN0LT5yZWdzLmFj
ayA9IFBJTkNUUkxfSVJRU1RBVChwb3J0LT5pZCkgKyBNWFNfQ0xSOw0KIAljdC0+cmVncy5tYXNr
ID0gUElOQ1RSTF9JUlFFTihwb3J0LT5pZCk7DQogDQotCWlycV9zZXR1cF9nZW5lcmljX2NoaXAo
Z2MsIElSUV9NU0soMzIpLCAwLCBJUlFfTk9SRVFVRVNULCAwKTsNCisJaXJxX3NldHVwX2dlbmVy
aWNfY2hpcChnYywgSVJRX01TSygzMiksIElSUV9HQ19JTklUX05FU1RFRF9MT0NLLA0KKwkJCSAg
ICAgICBJUlFfTk9SRVFVRVNULCAwKTsNCiB9DQogDQogc3RhdGljIGludCBteHNfZ3Bpb190b19p
cnEoc3RydWN0IGdwaW9fY2hpcCAqZ2MsIHVuc2lnbmVkIG9mZnNldCkNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9kaXNwbGF5LmMgYi9kcml2ZXJzL2dwdS9kcm0vaTkx
NS9pbnRlbF9kaXNwbGF5LmMNCmluZGV4IDJlYThhOTYuLjI3OTk5ZDkgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9kaXNwbGF5LmMNCisrKyBiL2RyaXZlcnMvZ3B1L2Ry
bS9pOTE1L2ludGVsX2Rpc3BsYXkuYw0KQEAgLTg5NDYsNiArODk0NiwxMiBAQCBzdHJ1Y3QgaW50
ZWxfcXVpcmsgaW50ZWxfcXVpcmtzW10gPSB7DQogCS8qIEFjZXIvUGFja2FyZCBCZWxsIE5DTDIw
ICovDQogCXsgMHgyYTQyLCAweDEwMjUsIDB4MDM0YiwgcXVpcmtfaW52ZXJ0X2JyaWdodG5lc3Mg
fSwNCiANCisJLyogQWNlciBBc3BpcmUgNDczNlogKi8NCisJeyAweDJhNDIsIDB4MTAyNSwgMHgw
MjYwLCBxdWlya19pbnZlcnRfYnJpZ2h0bmVzcyB9LA0KKw0KKwkvKiBBY2VyIEFzcGlyZSA1MzM2
ICovDQorCXsgMHgyYTQyLCAweDEwMjUsIDB4MDQ4YSwgcXVpcmtfaW52ZXJ0X2JyaWdodG5lc3Mg
fSwNCisNCiAJLyogRGVsbCBYUFMxMyBIRCBTYW5keSBCcmlkZ2UgKi8NCiAJeyAweDAxMTYsIDB4
MTAyOCwgMHgwNTJlLCBxdWlya19ub19wY21fcHdtX2VuYWJsZSB9LA0KIAkvKiBEZWxsIFhQUzEz
IEhEIGFuZCBYUFMxMyBGSEQgSXZ5IEJyaWRnZSAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1
L2RybS9pOTE1L2ludGVsX3R2LmMgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF90di5jDQpp
bmRleCAxMjA0MWZhLi5iMjIxZjJiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUv
aW50ZWxfdHYuYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfdHYuYw0KQEAgLTE1
OTksOSArMTU5OSwxNCBAQCBzdGF0aWMgaW50IHR2X2lzX3ByZXNlbnRfaW5fdmJ0KHN0cnVjdCBk
cm1fZGV2aWNlICpkZXYpDQogCQkvKg0KIAkJICogSWYgdGhlIGRldmljZSB0eXBlIGlzIG5vdCBU
ViwgY29udGludWUuDQogCQkgKi8NCi0JCWlmIChwX2NoaWxkLT5kZXZpY2VfdHlwZSAhPSBERVZJ
Q0VfVFlQRV9JTlRfVFYgJiYNCi0JCQlwX2NoaWxkLT5kZXZpY2VfdHlwZSAhPSBERVZJQ0VfVFlQ
RV9UVikNCisJCXN3aXRjaCAocF9jaGlsZC0+ZGV2aWNlX3R5cGUpIHsNCisJCWNhc2UgREVWSUNF
X1RZUEVfSU5UX1RWOg0KKwkJY2FzZSBERVZJQ0VfVFlQRV9UVjoNCisJCWNhc2UgREVWSUNFX1RZ
UEVfVFZfU1ZJREVPX0NPTVBPU0lURToNCisJCQlicmVhazsNCisJCWRlZmF1bHQ6DQogCQkJY29u
dGludWU7DQorCQl9DQogCQkvKiBPbmx5IHdoZW4gdGhlIGFkZGluX29mZnNldCBpcyBub24temVy
bywgaXQgaXMgcmVnYXJkZWQNCiAJCSAqIGFzIHByZXNlbnQuDQogCQkgKi8NCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kaXNwbGF5LmMgYi9kcml2ZXJzL2dwdS9k
cm0vcmFkZW9uL3JhZGVvbl9kaXNwbGF5LmMNCmluZGV4IDYzZTcxNDMuLjMyOTFhYjggMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kaXNwbGF5LmMNCisrKyBiL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2Rpc3BsYXkuYw0KQEAgLTczOCw2ICs3MzgsNyBA
QCBpbnQgcmFkZW9uX2RkY19nZXRfbW9kZXMoc3RydWN0IHJhZGVvbl9jb25uZWN0b3IgKnJhZGVv
bl9jb25uZWN0b3IpDQogCWlmIChyYWRlb25fY29ubmVjdG9yLT5lZGlkKSB7DQogCQlkcm1fbW9k
ZV9jb25uZWN0b3JfdXBkYXRlX2VkaWRfcHJvcGVydHkoJnJhZGVvbl9jb25uZWN0b3ItPmJhc2Us
IHJhZGVvbl9jb25uZWN0b3ItPmVkaWQpOw0KIAkJcmV0ID0gZHJtX2FkZF9lZGlkX21vZGVzKCZy
YWRlb25fY29ubmVjdG9yLT5iYXNlLCByYWRlb25fY29ubmVjdG9yLT5lZGlkKTsNCisJCWRybV9l
ZGlkX3RvX2VsZCgmcmFkZW9uX2Nvbm5lY3Rvci0+YmFzZSwgcmFkZW9uX2Nvbm5lY3Rvci0+ZWRp
ZCk7DQogCQlyZXR1cm4gcmV0Ow0KIAl9DQogCWRybV9tb2RlX2Nvbm5lY3Rvcl91cGRhdGVfZWRp
ZF9wcm9wZXJ0eSgmcmFkZW9uX2Nvbm5lY3Rvci0+YmFzZSwgTlVMTCk7DQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9ncHUvZHJtL3Ztd2dmeC92bXdnZnhfZmIuYyBiL2RyaXZlcnMvZ3B1L2RybS92bXdn
Zngvdm13Z2Z4X2ZiLmMNCmluZGV4IDM0ZTUxYTEuLjkwN2MyNmYgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL2dwdS9kcm0vdm13Z2Z4L3Ztd2dmeF9mYi5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vdm13
Z2Z4L3Ztd2dmeF9mYi5jDQpAQCAtMTQ3LDcgKzE0Nyw3IEBAIHN0YXRpYyBpbnQgdm13X2ZiX2No
ZWNrX3ZhcihzdHJ1Y3QgZmJfdmFyX3NjcmVlbmluZm8gKnZhciwNCiAJfQ0KIA0KIAlpZiAoIXZt
d19rbXNfdmFsaWRhdGVfbW9kZV92cmFtKHZtd19wcml2LA0KLQkJCQkJaW5mby0+Zml4LmxpbmVf
bGVuZ3RoLA0KKwkJCQkJdmFyLT54cmVzICogdmFyLT5iaXRzX3Blcl9waXhlbC84LA0KIAkJCQkJ
dmFyLT55b2Zmc2V0ICsgdmFyLT55cmVzKSkgew0KIAkJRFJNX0VSUk9SKCJSZXF1ZXN0ZWQgZ2Vv
bSBjYW4gbm90IGZpdCBpbiBmcmFtZWJ1ZmZlclxuIik7DQogCQlyZXR1cm4gLUVJTlZBTDsNCkBA
IC0xNjIsNiArMTYyLDggQEAgc3RhdGljIGludCB2bXdfZmJfc2V0X3BhcihzdHJ1Y3QgZmJfaW5m
byAqaW5mbykNCiAJc3RydWN0IHZtd19wcml2YXRlICp2bXdfcHJpdiA9IHBhci0+dm13X3ByaXY7
DQogCWludCByZXQ7DQogDQorCWluZm8tPmZpeC5saW5lX2xlbmd0aCA9IGluZm8tPnZhci54cmVz
ICogaW5mby0+dmFyLmJpdHNfcGVyX3BpeGVsLzg7DQorDQogCXJldCA9IHZtd19rbXNfd3JpdGVf
c3ZnYSh2bXdfcHJpdiwgaW5mby0+dmFyLnhyZXMsIGluZm8tPnZhci55cmVzLA0KIAkJCQkgaW5m
by0+Zml4LmxpbmVfbGVuZ3RoLA0KIAkJCQkgcGFyLT5icHAsIHBhci0+ZGVwdGgpOw0KQEAgLTE3
Nyw2ICsxNzksNyBAQCBzdGF0aWMgaW50IHZtd19mYl9zZXRfcGFyKHN0cnVjdCBmYl9pbmZvICpp
bmZvKQ0KIAkJdm13X3dyaXRlKHZtd19wcml2LCBTVkdBX1JFR19ESVNQTEFZX1BPU0lUSU9OX1ks
IGluZm8tPnZhci55b2Zmc2V0KTsNCiAJCXZtd193cml0ZSh2bXdfcHJpdiwgU1ZHQV9SRUdfRElT
UExBWV9XSURUSCwgaW5mby0+dmFyLnhyZXMpOw0KIAkJdm13X3dyaXRlKHZtd19wcml2LCBTVkdB
X1JFR19ESVNQTEFZX0hFSUdIVCwgaW5mby0+dmFyLnlyZXMpOw0KKwkJdm13X3dyaXRlKHZtd19w
cml2LCBTVkdBX1JFR19CWVRFU19QRVJfTElORSwgaW5mby0+Zml4LmxpbmVfbGVuZ3RoKTsNCiAJ
CXZtd193cml0ZSh2bXdfcHJpdiwgU1ZHQV9SRUdfRElTUExBWV9JRCwgU1ZHQV9JRF9JTlZBTElE
KTsNCiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHYvcmluZ19idWZmZXIuYyBiL2RyaXZl
cnMvaHYvcmluZ19idWZmZXIuYw0KaW5kZXggODEwNjU4ZS4uZDAxZWRmMyAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvaHYvcmluZ19idWZmZXIuYw0KKysrIGIvZHJpdmVycy9odi9yaW5nX2J1ZmZlci5j
DQpAQCAtNDg1LDcgKzQ4NSw3IEBAIGludCBodl9yaW5nYnVmZmVyX3JlYWQoc3RydWN0IGh2X3Jp
bmdfYnVmZmVyX2luZm8gKmlucmluZ19pbmZvLCB2b2lkICpidWZmZXIsDQogCS8qIE1ha2Ugc3Vy
ZSBhbGwgcmVhZHMgYXJlIGRvbmUgYmVmb3JlIHdlIHVwZGF0ZSB0aGUgcmVhZCBpbmRleCBzaW5j
ZSAqLw0KIAkvKiB0aGUgd3JpdGVyIG1heSBzdGFydCB3cml0aW5nIHRvIHRoZSByZWFkIGFyZWEg
b25jZSB0aGUgcmVhZCBpbmRleCAqLw0KIAkvKmlzIHVwZGF0ZWQgKi8NCi0Jc21wX21iKCk7DQor
CW1iKCk7DQogDQogCS8qIFVwZGF0ZSB0aGUgcmVhZCBpbmRleCAqLw0KIAlodl9zZXRfbmV4dF9y
ZWFkX2xvY2F0aW9uKGlucmluZ19pbmZvLCBuZXh0X3JlYWRfbG9jYXRpb24pOw0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9laGNhL2VoY2FfY3EuYyBiL2RyaXZlcnMvaW5maW5p
YmFuZC9ody9laGNhL2VoY2FfY3EuYw0KaW5kZXggZDliMGViYy4uNmVlYjg0ZCAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9laGNhL2VoY2FfY3EuYw0KKysrIGIvZHJpdmVycy9p
bmZpbmliYW5kL2h3L2VoY2EvZWhjYV9jcS5jDQpAQCAtMjk2LDYgKzI5Niw3IEBAIHN0cnVjdCBp
Yl9jcSAqZWhjYV9jcmVhdGVfY3Eoc3RydWN0IGliX2RldmljZSAqZGV2aWNlLCBpbnQgY3FlLCBp
bnQgY29tcF92ZWN0b3IsDQogCQkJKG15X2NxLT5nYWxwYXMudXNlci5md19oYW5kbGUgJiAoUEFH
RV9TSVpFIC0gMSkpOw0KIAkJaWYgKGliX2NvcHlfdG9fdWRhdGEodWRhdGEsICZyZXNwLCBzaXpl
b2YocmVzcCkpKSB7DQogCQkJZWhjYV9lcnIoZGV2aWNlLCAiQ29weSB0byB1ZGF0YSBmYWlsZWQu
Iik7DQorCQkJY3EgPSBFUlJfUFRSKC1FRkFVTFQpOw0KIAkJCWdvdG8gY3JlYXRlX2NxX2V4aXQ0
Ow0KIAkJfQ0KIAl9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2lwYXRoL2lw
YXRoX2RpYWcuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9pcGF0aC9pcGF0aF9kaWFnLmMNCmlu
ZGV4IDcxNDI5M2IuLmUyZjlhNTEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcv
aXBhdGgvaXBhdGhfZGlhZy5jDQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXBhdGgvaXBh
dGhfZGlhZy5jDQpAQCAtMzI2LDcgKzMyNiw3IEBAIHN0YXRpYyBzc2l6ZV90IGlwYXRoX2RpYWdw
a3Rfd3JpdGUoc3RydWN0IGZpbGUgKmZwLA0KIAkJCQkgICBzaXplX3QgY291bnQsIGxvZmZfdCAq
b2ZmKQ0KIHsNCiAJdTMyIF9faW9tZW0gKnBpb2J1ZjsNCi0JdTMyIHBsZW4sIGNsZW4sIHBidWZu
Ow0KKwl1MzIgcGxlbiwgcGJ1Zm4sIG1heGxlbl9yZXNlcnZlOw0KIAlzdHJ1Y3QgaXBhdGhfZGlh
Z19wa3Qgb2RwOw0KIAlzdHJ1Y3QgaXBhdGhfZGlhZ194cGt0IGRwOw0KIAl1MzIgKnRtcGJ1ZiA9
IE5VTEw7DQpAQCAtMzM1LDUxICszMzUsMjkgQEAgc3RhdGljIHNzaXplX3QgaXBhdGhfZGlhZ3Br
dF93cml0ZShzdHJ1Y3QgZmlsZSAqZnAsDQogCXU2NCB2YWw7DQogCXUzMiBsX3N0YXRlLCBsdF9z
dGF0ZTsgLyogTGlua1N0YXRlLCBMaW5rVHJhaW5pbmdTdGF0ZSAqLw0KIA0KLQlpZiAoY291bnQg
PCBzaXplb2Yob2RwKSkgew0KLQkJcmV0ID0gLUVJTlZBTDsNCi0JCWdvdG8gYmFpbDsNCi0JfQ0K
IA0KIAlpZiAoY291bnQgPT0gc2l6ZW9mKGRwKSkgew0KIAkJaWYgKGNvcHlfZnJvbV91c2VyKCZk
cCwgZGF0YSwgc2l6ZW9mKGRwKSkpIHsNCiAJCQlyZXQgPSAtRUZBVUxUOw0KIAkJCWdvdG8gYmFp
bDsNCiAJCX0NCi0JfSBlbHNlIGlmIChjb3B5X2Zyb21fdXNlcigmb2RwLCBkYXRhLCBzaXplb2Yo
b2RwKSkpIHsNCi0JCXJldCA9IC1FRkFVTFQ7DQorCX0gZWxzZSBpZiAoY291bnQgPT0gc2l6ZW9m
KG9kcCkpIHsNCisJCWlmIChjb3B5X2Zyb21fdXNlcigmb2RwLCBkYXRhLCBzaXplb2Yob2RwKSkp
IHsNCisJCQlyZXQgPSAtRUZBVUxUOw0KKwkJCWdvdG8gYmFpbDsNCisJCX0NCisJfSBlbHNlIHsN
CisJCXJldCA9IC1FSU5WQUw7DQogCQlnb3RvIGJhaWw7DQogCX0NCiANCi0JLyoNCi0JICogRHVl
IHRvIHBhZGRpbmcvYWxpZ25tZW50IGlzc3VlcyAobGVzc2VuZWQgd2l0aCBuZXcgc3RydWN0KQ0K
LQkgKiB0aGUgb2xkIGFuZCBuZXcgc3RydWN0cyBhcmUgdGhlIHNhbWUgbGVuZ3RoLiBXZSBuZWVk
IHRvDQotCSAqIGRpc2FtYmlndWF0ZSB0aGVtLCB3aGljaCB3ZSBjYW4gZG8gYmVjYXVzZSBvZHAu
bGVuIGhhcyBuZXZlcg0KLQkgKiBiZWVuIGxlc3MgdGhhbiB0aGUgdG90YWwgb2YgTFJIK0JUSCtE
RVRIIHNvIGZhciwgd2hpbGUNCi0JICogZHAudW5pdCAoc2FtZSBvZmZzZXQpIHVuaXQgaXMgdW5s
aWtlbHkgdG8gZ2V0IHRoYXQgaGlnaC4NCi0JICogU2ltaWxhcmx5LCBkcC5kYXRhLCB0aGUgcG9p
bnRlciB0byB1c2VyIGF0IHRoZSBzYW1lIG9mZnNldA0KLQkgKiBhcyBvZHAudW5pdCwgaXMgYWxt
b3N0IGNlcnRhaW5seSBhdCBsZWFzdCBvbmUgKDUxMmJ5dGUpcGFnZQ0KLQkgKiAiYWJvdmUiIE5V
TEwuIFRoZSBpZi1ibG9jayBiZWxvdyBjYW4gYmUgb21pdHRlZCBpZiBjb21wYXRpYmlsaXR5DQot
CSAqIGJldHdlZW4gYSBuZXcgZHJpdmVyIGFuZCBvbGRlciBkaWFnbm9zdGljIGNvZGUgaXMgdW5p
bXBvcnRhbnQuDQotCSAqIGNvbXBhdGliaWxpdHkgdGhlIG90aGVyIGRpcmVjdGlvbiAobmV3IGRp
YWdzLCBvbGQgZHJpdmVyKSBpcw0KLQkgKiBoYW5kbGVkIGluIHRoZSBkaWFnbm9zdGljIGNvZGUs
IHdpdGggYSB3YXJuaW5nLg0KLQkgKi8NCi0JaWYgKGRwLnVuaXQgPj0gMjAgJiYgZHAuZGF0YSA8
IDUxMikgew0KLQkJLyogdmVyeSBwcm9iYWJsZSB2ZXJzaW9uIG1pc21hdGNoLiBGaXggaXQgdXAg
Ki8NCi0JCW1lbWNweSgmb2RwLCAmZHAsIHNpemVvZihvZHApKTsNCi0JCS8qIFdlIGdvdCBhIGxl
Z2FjeSBkcCwgY29weSBlbGVtZW50cyB0byBkcCAqLw0KLQkJZHAudW5pdCA9IG9kcC51bml0Ow0K
LQkJZHAuZGF0YSA9IG9kcC5kYXRhOw0KLQkJZHAubGVuID0gb2RwLmxlbjsNCi0JCWRwLnBiY193
ZCA9IDA7IC8qIEluZGljYXRlIHdlIG5lZWQgdG8gY29tcHV0ZSBQQkMgd2QgKi8NCi0JfQ0KLQ0K
IAkvKiBzZW5kIGNvdW50IG11c3QgYmUgYW4gZXhhY3QgbnVtYmVyIG9mIGR3b3JkcyAqLw0KIAlp
ZiAoZHAubGVuICYgMykgew0KIAkJcmV0ID0gLUVJTlZBTDsNCiAJCWdvdG8gYmFpbDsNCiAJfQ0K
IA0KLQljbGVuID0gZHAubGVuID4+IDI7DQorCXBsZW4gPSBkcC5sZW4gPj4gMjsNCiANCiAJZGQg
PSBpcGF0aF9sb29rdXAoZHAudW5pdCk7DQogCWlmICghZGQgfHwgIShkZC0+aXBhdGhfZmxhZ3Mg
JiBJUEFUSF9QUkVTRU5UKSB8fA0KQEAgLTQyMiwxNiArNDAwLDIyIEBAIHN0YXRpYyBzc2l6ZV90
IGlwYXRoX2RpYWdwa3Rfd3JpdGUoc3RydWN0IGZpbGUgKmZwLA0KIAkJZ290byBiYWlsOw0KIAl9
DQogDQotCS8qIG5lZWQgdG90YWwgbGVuZ3RoIGJlZm9yZSBmaXJzdCB3b3JkIHdyaXR0ZW4gKi8N
Ci0JLyogKzEgd29yZCBpcyBmb3IgdGhlIHF3b3JkIHBhZGRpbmcgKi8NCi0JcGxlbiA9IHNpemVv
Zih1MzIpICsgZHAubGVuOw0KLQ0KLQlpZiAoKHBsZW4gKyA0KSA+IGRkLT5pcGF0aF9pYm1heGxl
bikgew0KKwkvKg0KKwkgKiBuZWVkIHRvdGFsIGxlbmd0aCBiZWZvcmUgZmlyc3Qgd29yZCB3cml0
dGVuLCBwbHVzIDIgRHdvcmRzLiBPbmUgRHdvcmQNCisJICogaXMgZm9yIHBhZGRpbmcgc28gd2Ug
Z2V0IHRoZSBmdWxsIHVzZXIgZGF0YSB3aGVuIG5vdCBhbGlnbmVkIG9uDQorCSAqIGEgd29yZCBi
b3VuZGFyeS4gVGhlIG90aGVyIER3b3JkIGlzIHRvIG1ha2Ugc3VyZSB3ZSBoYXZlIHJvb20gZm9y
IHRoZQ0KKwkgKiBJQ1JDIHdoaWNoIGdldHMgdGFja2VkIG9uIGxhdGVyLg0KKwkgKi8NCisJbWF4
bGVuX3Jlc2VydmUgPSAyICogc2l6ZW9mKHUzMik7DQorCWlmIChkcC5sZW4gPiBkZC0+aXBhdGhf
aWJtYXhsZW4gLSBtYXhsZW5fcmVzZXJ2ZSkgew0KIAkJaXBhdGhfZGJnKCJQa3QgbGVuIDB4JXgg
PiBpYm1heGxlbiAleFxuIiwNCi0JCQkgIHBsZW4gLSA0LCBkZC0+aXBhdGhfaWJtYXhsZW4pOw0K
KwkJCSAgZHAubGVuLCBkZC0+aXBhdGhfaWJtYXhsZW4pOw0KIAkJcmV0ID0gLUVJTlZBTDsNCi0J
CWdvdG8gYmFpbDsJLyogYmVmb3JlIHdyaXRpbmcgcGJjICovDQorCQlnb3RvIGJhaWw7DQogCX0N
CisNCisJcGxlbiA9IHNpemVvZih1MzIpICsgZHAubGVuOw0KKw0KIAl0bXBidWYgPSB2bWFsbG9j
KHBsZW4pOw0KIAlpZiAoIXRtcGJ1Zikgew0KIAkJZGV2X2luZm8oJmRkLT5wY2lkZXYtPmRldiwg
IlVuYWJsZSB0byBhbGxvY2F0ZSB0bXAgYnVmZmVyLCAiDQpAQCAtNDczLDExICs0NTcsMTEgQEAg
c3RhdGljIHNzaXplX3QgaXBhdGhfZGlhZ3BrdF93cml0ZShzdHJ1Y3QgZmlsZSAqZnAsDQogCSAq
Lw0KIAlpZiAoZGQtPmlwYXRoX2ZsYWdzICYgSVBBVEhfUElPX0ZMVVNIX1dDKSB7DQogCQlpcGF0
aF9mbHVzaF93YygpOw0KLQkJX19pb3dyaXRlMzJfY29weShwaW9idWYgKyAyLCB0bXBidWYsIGNs
ZW4gLSAxKTsNCisJCV9faW93cml0ZTMyX2NvcHkocGlvYnVmICsgMiwgdG1wYnVmLCBwbGVuIC0g
MSk7DQogCQlpcGF0aF9mbHVzaF93YygpOw0KLQkJX19yYXdfd3JpdGVsKHRtcGJ1ZltjbGVuIC0g
MV0sIHBpb2J1ZiArIGNsZW4gKyAxKTsNCisJCV9fcmF3X3dyaXRlbCh0bXBidWZbcGxlbiAtIDFd
LCBwaW9idWYgKyBwbGVuICsgMSk7DQogCX0gZWxzZQ0KLQkJX19pb3dyaXRlMzJfY29weShwaW9i
dWYgKyAyLCB0bXBidWYsIGNsZW4pOw0KKwkJX19pb3dyaXRlMzJfY29weShwaW9idWYgKyAyLCB0
bXBidWYsIHBsZW4pOw0KIA0KIAlpcGF0aF9mbHVzaF93YygpOw0KIA0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvaW5maW5pYmFuZC9ody9tdGhjYS9tdGhjYV9wcm92aWRlci5jIGIvZHJpdmVycy9pbmZp
bmliYW5kL2h3L210aGNhL210aGNhX3Byb3ZpZGVyLmMNCmluZGV4IDViNzFkNDMuLjQyZGRlMDYg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbXRoY2EvbXRoY2FfcHJvdmlkZXIu
Yw0KKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L210aGNhL210aGNhX3Byb3ZpZGVyLmMNCkBA
IC02OTUsNiArNjk1LDcgQEAgc3RhdGljIHN0cnVjdCBpYl9jcSAqbXRoY2FfY3JlYXRlX2NxKHN0
cnVjdCBpYl9kZXZpY2UgKmliZGV2LCBpbnQgZW50cmllcywNCiANCiAJaWYgKGNvbnRleHQgJiYg
aWJfY29weV90b191ZGF0YSh1ZGF0YSwgJmNxLT5jcW4sIHNpemVvZiAoX191MzIpKSkgew0KIAkJ
bXRoY2FfZnJlZV9jcSh0b19tZGV2KGliZGV2KSwgY3EpOw0KKwkJZXJyID0gLUVGQVVMVDsNCiAJ
CWdvdG8gZXJyX2ZyZWU7DQogCX0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQv
aHcvbmVzL25lc192ZXJicy5jIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L25lcy9uZXNfdmVyYnMu
Yw0KaW5kZXggYjA0NzFiNC4uMzMwZWI2ZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaW5maW5pYmFu
ZC9ody9uZXMvbmVzX3ZlcmJzLmMNCisrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9uZXMvbmVz
X3ZlcmJzLmMNCkBAIC0xMTgzLDcgKzExODMsNyBAQCBzdGF0aWMgc3RydWN0IGliX3FwICpuZXNf
Y3JlYXRlX3FwKHN0cnVjdCBpYl9wZCAqaWJwZCwNCiAJCQkJCW5lc19mcmVlX3Jlc291cmNlKG5l
c2FkYXB0ZXIsIG5lc2FkYXB0ZXItPmFsbG9jYXRlZF9xcHMsIHFwX251bSk7DQogCQkJCQlrZnJl
ZShuZXNxcC0+YWxsb2NhdGVkX2J1ZmZlcik7DQogCQkJCQluZXNfZGVidWcoTkVTX0RCR19RUCwg
ImliX2NvcHlfZnJvbV91ZGF0YSgpIEZhaWxlZCBcbiIpOw0KLQkJCQkJcmV0dXJuIE5VTEw7DQor
CQkJCQlyZXR1cm4gRVJSX1BUUigtRUZBVUxUKTsNCiAJCQkJfQ0KIAkJCQlpZiAocmVxLnVzZXJf
d3FlX2J1ZmZlcnMpIHsNCiAJCQkJCXZpcnRfd3FzID0gMTsNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2lzZG4vaXNkbmxvb3AvaXNkbmxvb3AuYyBiL2RyaXZlcnMvaXNkbi9pc2RubG9vcC9pc2RubG9v
cC5jDQppbmRleCA0ZGY4MGZiLi43NWNhNWQyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pc2RuL2lz
ZG5sb29wL2lzZG5sb29wLmMNCisrKyBiL2RyaXZlcnMvaXNkbi9pc2RubG9vcC9pc2RubG9vcC5j
DQpAQCAtNTE4LDkgKzUxOCw5IEBAIHN0YXRpYyBpc2RubG9vcF9zdGF0IGlzZG5sb29wX2NtZF90
YWJsZVtdID0NCiBzdGF0aWMgdm9pZA0KIGlzZG5sb29wX2Zha2VfZXJyKGlzZG5sb29wX2NhcmQg
KiBjYXJkKQ0KIHsNCi0JY2hhciBidWZbNjBdOw0KKwljaGFyIGJ1Zls2NF07DQogDQotCXNwcmlu
dGYoYnVmLCAiRSVzIiwgY2FyZC0+b21zZyk7DQorCXNucHJpbnRmKGJ1Ziwgc2l6ZW9mKGJ1Ziks
ICJFJXMiLCBjYXJkLT5vbXNnKTsNCiAJaXNkbmxvb3BfZmFrZShjYXJkLCBidWYsIC0xKTsNCiAJ
aXNkbmxvb3BfZmFrZShjYXJkLCAiTkFLIiwgLTEpOw0KIH0NCkBAIC05MDMsNiArOTAzLDggQEAg
aXNkbmxvb3BfcGFyc2VfY21kKGlzZG5sb29wX2NhcmQgKiBjYXJkKQ0KIAkJY2FzZSA3Og0KIAkJ
CS8qIDB4O0VBWiAqLw0KIAkJCXAgKz0gMzsNCisJCQlpZiAoc3RybGVuKHApID49IHNpemVvZihj
YXJkLT5lYXpsaXN0WzBdKSkNCisJCQkJYnJlYWs7DQogCQkJc3RyY3B5KGNhcmQtPmVhemxpc3Rb
Y2ggLSAxXSwgcCk7DQogCQkJYnJlYWs7DQogCQljYXNlIDg6DQpAQCAtMTA3MCw2ICsxMDcyLDEy
IEBAIGlzZG5sb29wX3N0YXJ0KGlzZG5sb29wX2NhcmQgKiBjYXJkLCBpc2RubG9vcF9zZGVmICog
c2RlZnApDQogCQlyZXR1cm4gLUVCVVNZOw0KIAlpZiAoY29weV9mcm9tX3VzZXIoKGNoYXIgKikg
JnNkZWYsIChjaGFyICopIHNkZWZwLCBzaXplb2Yoc2RlZikpKQ0KIAkJcmV0dXJuIC1FRkFVTFQ7
DQorDQorCWZvciAoaSA9IDA7IGkgPCAzOyBpKyspIHsNCisJCWlmICghbWVtY2hyKHNkZWYubnVt
W2ldLCAwLCBzaXplb2Yoc2RlZi5udW1baV0pKSkNCisJCQlyZXR1cm4gLUVJTlZBTDsNCisJfQ0K
Kw0KIAlzcGluX2xvY2tfaXJxc2F2ZSgmY2FyZC0+aXNkbmxvb3BfbG9jaywgZmxhZ3MpOw0KIAlz
d2l0Y2ggKHNkZWYucHR5cGUpIHsNCiAJCWNhc2UgSVNETl9QVFlQRV9FVVJPOg0KQEAgLTExMjcs
NyArMTEzNSw3IEBAIGlzZG5sb29wX2NvbW1hbmQoaXNkbl9jdHJsICogYywgaXNkbmxvb3BfY2Fy
ZCAqIGNhcmQpDQogew0KIAl1bG9uZyBhOw0KIAlpbnQgaTsNCi0JY2hhciBjYnVmWzYwXTsNCisJ
Y2hhciBjYnVmWzgwXTsNCiAJaXNkbl9jdHJsIGNtZDsNCiAJaXNkbmxvb3BfY2RlZiBjZGVmOw0K
IA0KQEAgLTExOTIsNyArMTIwMCw2IEBAIGlzZG5sb29wX2NvbW1hbmQoaXNkbl9jdHJsICogYywg
aXNkbmxvb3BfY2FyZCAqIGNhcmQpDQogCQkJCWJyZWFrOw0KIAkJCWlmICgoYy0+YXJnICYgMjU1
KSA8IElTRE5MT09QX0JDSCkgew0KIAkJCQljaGFyICpwOw0KLQkJCQljaGFyIGRpYWxbNTBdOw0K
IAkJCQljaGFyIGRjb2RlWzRdOw0KIA0KIAkJCQlhID0gYy0+YXJnOw0KQEAgLTEyMDQsMTAgKzEy
MTEsMTAgQEAgaXNkbmxvb3BfY29tbWFuZChpc2RuX2N0cmwgKiBjLCBpc2RubG9vcF9jYXJkICog
Y2FyZCkNCiAJCQkJfSBlbHNlDQogCQkJCQkvKiBOb3JtYWwgRGlhbCAqLw0KIAkJCQkJc3RyY3B5
KGRjb2RlLCAiQ0FMIik7DQotCQkJCXN0cmNweShkaWFsLCBwKTsNCi0JCQkJc3ByaW50ZihjYnVm
LCAiJTAyZDtEJXNfUiVzLCUwMmQsJTAyZCwlc1xuIiwgKGludCkgKGEgKyAxKSwNCi0JCQkJCWRj
b2RlLCBkaWFsLCBjLT5wYXJtLnNldHVwLnNpMSwNCi0JCQkJYy0+cGFybS5zZXR1cC5zaTIsIGMt
PnBhcm0uc2V0dXAuZWF6bXNuKTsNCisJCQkJc25wcmludGYoY2J1Ziwgc2l6ZW9mKGNidWYpLA0K
KwkJCQkJICIlMDJkO0Qlc19SJXMsJTAyZCwlMDJkLCVzXG4iLCAoaW50KSAoYSArIDEpLA0KKwkJ
CQkJIGRjb2RlLCBwLCBjLT5wYXJtLnNldHVwLnNpMSwNCisJCQkJCSBjLT5wYXJtLnNldHVwLnNp
MiwgYy0+cGFybS5zZXR1cC5lYXptc24pOw0KIAkJCQlpID0gaXNkbmxvb3Bfd3JpdGVjbWQoY2J1
Ziwgc3RybGVuKGNidWYpLCAwLCBjYXJkKTsNCiAJCQl9DQogCQkJYnJlYWs7DQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9tZC9kbS10aGluLmMgYi9kcml2ZXJzL21kL2RtLXRoaW4uYw0KaW5kZXggMmM5
ZGQyYy4uODBmOGJkNSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWQvZG0tdGhpbi5jDQorKysgYi9k
cml2ZXJzL21kL2RtLXRoaW4uYw0KQEAgLTEyOTgsOSArMTI5OCw5IEBAIHN0YXRpYyB2b2lkIHBy
b2Nlc3NfZGVmZXJyZWRfYmlvcyhzdHJ1Y3QgcG9vbCAqcG9vbCkNCiAJCSAqLw0KIAkJaWYgKGVu
c3VyZV9uZXh0X21hcHBpbmcocG9vbCkpIHsNCiAJCQlzcGluX2xvY2tfaXJxc2F2ZSgmcG9vbC0+
bG9jaywgZmxhZ3MpOw0KKwkJCWJpb19saXN0X2FkZCgmcG9vbC0+ZGVmZXJyZWRfYmlvcywgYmlv
KTsNCiAJCQliaW9fbGlzdF9tZXJnZSgmcG9vbC0+ZGVmZXJyZWRfYmlvcywgJmJpb3MpOw0KIAkJ
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnBvb2wtPmxvY2ssIGZsYWdzKTsNCi0NCiAJCQlicmVh
azsNCiAJCX0NCiAJCXByb2Nlc3NfYmlvKHRjLCBiaW8pOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bWVkaWEvdmlkZW8vZ3NwY2Evc245YzIweC5jIGIvZHJpdmVycy9tZWRpYS92aWRlby9nc3BjYS9z
bjljMjB4LmMNCmluZGV4IDg2ZTA3YTEuLjUwOWUyMDIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21l
ZGlhL3ZpZGVvL2dzcGNhL3NuOWMyMHguYw0KKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9nc3Bj
YS9zbjljMjB4LmMNCkBAIC0yNTIxLDYgKzI1MjEsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHVz
Yl9kZXZpY2VfaWQgZGV2aWNlX3RhYmxlW10gPSB7DQogCXtVU0JfREVWSUNFKDB4MDQ1ZSwgMHgw
MGY0KSwgU045QzIwWChPVjk2NTAsIDB4MzAsIDApfSwNCiAJe1VTQl9ERVZJQ0UoMHgxNDVmLCAw
eDAxM2QpLCBTTjlDMjBYKE9WNzY2MCwgMHgyMSwgMCl9LA0KIAl7VVNCX0RFVklDRSgweDA0NTgs
IDB4NzAyOSksIFNOOUMyMFgoSFY3MTMxUiwgMHgxMSwgMCl9LA0KKwl7VVNCX0RFVklDRSgweDA0
NTgsIDB4NzA0NSksIFNOOUMyMFgoTVQ5TTExMiwgMHg1ZCwgTEVEX1JFVkVSU0UpfSwNCiAJe1VT
Ql9ERVZJQ0UoMHgwNDU4LCAweDcwNGEpLCBTTjlDMjBYKE1UOU0xMTIsIDB4NWQsIDApfSwNCiAJ
e1VTQl9ERVZJQ0UoMHgwNDU4LCAweDcwNGMpLCBTTjlDMjBYKE1UOU0xMTIsIDB4NWQsIDApfSwN
CiAJe1VTQl9ERVZJQ0UoMHhhMTY4LCAweDA2MTApLCBTTjlDMjBYKEhWNzEzMVIsIDB4MTEsIDAp
fSwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3V2Yy91dmNfdmlkZW8uYyBiL2Ry
aXZlcnMvbWVkaWEvdmlkZW8vdXZjL3V2Y192aWRlby5jDQppbmRleCBiMDE1ZThlLi5hZjVjMDQw
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby91dmMvdXZjX3ZpZGVvLmMNCisrKyBi
L2RyaXZlcnMvbWVkaWEvdmlkZW8vdXZjL3V2Y192aWRlby5jDQpAQCAtMTI2Nyw3ICsxMjY3LDI1
IEBAIGludCB1dmNfdmlkZW9fZW5hYmxlKHN0cnVjdCB1dmNfc3RyZWFtaW5nICpzdHJlYW0sIGlu
dCBlbmFibGUpDQogDQogCWlmICghZW5hYmxlKSB7DQogCQl1dmNfdW5pbml0X3ZpZGVvKHN0cmVh
bSwgMSk7DQotCQl1c2Jfc2V0X2ludGVyZmFjZShzdHJlYW0tPmRldi0+dWRldiwgc3RyZWFtLT5p
bnRmbnVtLCAwKTsNCisJCWlmIChzdHJlYW0tPmludGYtPm51bV9hbHRzZXR0aW5nID4gMSkgew0K
KwkJCXVzYl9zZXRfaW50ZXJmYWNlKHN0cmVhbS0+ZGV2LT51ZGV2LA0KKwkJCQkJICBzdHJlYW0t
PmludGZudW0sIDApOw0KKwkJfSBlbHNlIHsNCisJCQkvKiBVVkMgZG9lc24ndCBzcGVjaWZ5IGhv
dyB0byBpbmZvcm0gYSBidWxrLWJhc2VkIGRldmljZQ0KKwkJCSAqIHdoZW4gdGhlIHZpZGVvIHN0
cmVhbSBpcyBzdG9wcGVkLiBXaW5kb3dzIHNlbmRzIGENCisJCQkgKiBDTEVBUl9GRUFUVVJFKEhB
TFQpIHJlcXVlc3QgdG8gdGhlIHZpZGVvIHN0cmVhbWluZw0KKwkJCSAqIGJ1bGsgZW5kcG9pbnQs
IG1pbWljIHRoZSBzYW1lIGJlaGF2aW91ci4NCisJCQkgKi8NCisJCQl1bnNpZ25lZCBpbnQgZXBu
dW0gPSBzdHJlYW0tPmhlYWRlci5iRW5kcG9pbnRBZGRyZXNzDQorCQkJCQkgICAmIFVTQl9FTkRQ
T0lOVF9OVU1CRVJfTUFTSzsNCisJCQl1bnNpZ25lZCBpbnQgZGlyID0gc3RyZWFtLT5oZWFkZXIu
YkVuZHBvaW50QWRkcmVzcw0KKwkJCQkJICYgVVNCX0VORFBPSU5UX0RJUl9NQVNLOw0KKwkJCXVu
c2lnbmVkIGludCBwaXBlOw0KKw0KKwkJCXBpcGUgPSB1c2Jfc25kYnVsa3BpcGUoc3RyZWFtLT5k
ZXYtPnVkZXYsIGVwbnVtKSB8IGRpcjsNCisJCQl1c2JfY2xlYXJfaGFsdChzdHJlYW0tPmRldi0+
dWRldiwgcGlwZSk7DQorCQl9DQorDQogCQl1dmNfcXVldWVfZW5hYmxlKCZzdHJlYW0tPnF1ZXVl
LCAwKTsNCiAJCXJldHVybiAwOw0KIAl9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZmQvODhwbTg2
MHgtaTJjLmMgYi9kcml2ZXJzL21mZC84OHBtODYweC1pMmMuYw0KaW5kZXggZTAxN2RjOC4uZjAz
NWRkMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWZkLzg4cG04NjB4LWkyYy5jDQorKysgYi9kcml2
ZXJzL21mZC84OHBtODYweC1pMmMuYw0KQEAgLTI5MCw2ICsyOTAsMTIgQEAgc3RhdGljIGludCBf
X2RldmluaXQgcG04NjB4X3Byb2JlKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsDQogCQljaGlw
LT5jb21wYW5pb25fYWRkciA9IHBkYXRhLT5jb21wYW5pb25fYWRkcjsNCiAJCWNoaXAtPmNvbXBh
bmlvbiA9IGkyY19uZXdfZHVtbXkoY2hpcC0+Y2xpZW50LT5hZGFwdGVyLA0KIAkJCQkJCWNoaXAt
PmNvbXBhbmlvbl9hZGRyKTsNCisJCWlmICghY2hpcC0+Y29tcGFuaW9uKSB7DQorCQkJZGV2X2Vy
cigmY2xpZW50LT5kZXYsDQorCQkJCSJGYWlsZWQgdG8gYWxsb2NhdGUgSTJDIGNvbXBhbmlvbiBk
ZXZpY2VcbiIpOw0KKwkJCWtmcmVlKGNoaXApOw0KKwkJCXJldHVybiAtRU5PREVWOw0KKwkJfQ0K
IAkJaTJjX3NldF9jbGllbnRkYXRhKGNoaXAtPmNvbXBhbmlvbiwgY2hpcCk7DQogCX0NCiANCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL21mZC9LY29uZmlnIGIvZHJpdmVycy9tZmQvS2NvbmZpZw0KaW5k
ZXggZjEzOTFjMi4uYjJiNjkxNiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWZkL0tjb25maWcNCisr
KyBiL2RyaXZlcnMvbWZkL0tjb25maWcNCkBAIC03NzIsOSArNzcyLDYgQEAgY29uZmlnIE1GRF9J
TlRFTF9NU0lDDQogCSAgUGFzc2FnZSkgY2hpcC4gVGhpcyBjaGlwIGVtYmVkcyBhdWRpbywgYmF0
dGVyeSwgR1BJTywgZXRjLg0KIAkgIGRldmljZXMgdXNlZCBpbiBJbnRlbCBNZWRmaWVsZCBwbGF0
Zm9ybXMuDQogDQotZW5kbWVudQ0KLWVuZGlmDQotDQogbWVudSAiTXVsdGltZWRpYSBDYXBhYmls
aXRpZXMgUG9ydCBkcml2ZXJzIg0KIAlkZXBlbmRzIG9uIEFSQ0hfU0ExMTAwDQogDQpAQCAtNzk3
LDMgKzc5NCw2IEBAIGNvbmZpZyBNQ1BfVUNCMTIwMF9UUw0KIAlkZXBlbmRzIG9uIE1DUF9VQ0Ix
MjAwICYmIElOUFVUDQogDQogZW5kbWVudQ0KKw0KK2VuZG1lbnUNCitlbmRpZg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWZkL21heDg5MjUtaTJjLmMgYi9kcml2ZXJzL21mZC9tYXg4OTI1LWkyYy5j
DQppbmRleCAwMjE5MTE1Li45MGI0NTBjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZmQvbWF4ODky
NS1pMmMuYw0KKysrIGIvZHJpdmVycy9tZmQvbWF4ODkyNS1pMmMuYw0KQEAgLTE1Niw5ICsxNTYs
MTggQEAgc3RhdGljIGludCBfX2RldmluaXQgbWF4ODkyNV9wcm9iZShzdHJ1Y3QgaTJjX2NsaWVu
dCAqY2xpZW50LA0KIAltdXRleF9pbml0KCZjaGlwLT5pb19sb2NrKTsNCiANCiAJY2hpcC0+cnRj
ID0gaTJjX25ld19kdW1teShjaGlwLT5pMmMtPmFkYXB0ZXIsIFJUQ19JMkNfQUREUik7DQorCWlm
ICghY2hpcC0+cnRjKSB7DQorCQlkZXZfZXJyKGNoaXAtPmRldiwgIkZhaWxlZCB0byBhbGxvY2F0
ZSBJMkMgZGV2aWNlIGZvciBSVENcbiIpOw0KKwkJcmV0dXJuIC1FTk9ERVY7DQorCX0NCiAJaTJj
X3NldF9jbGllbnRkYXRhKGNoaXAtPnJ0YywgY2hpcCk7DQogDQogCWNoaXAtPmFkYyA9IGkyY19u
ZXdfZHVtbXkoY2hpcC0+aTJjLT5hZGFwdGVyLCBBRENfSTJDX0FERFIpOw0KKwlpZiAoIWNoaXAt
PmFkYykgew0KKwkJZGV2X2VycihjaGlwLT5kZXYsICJGYWlsZWQgdG8gYWxsb2NhdGUgSTJDIGRl
dmljZSBmb3IgQURDXG4iKTsNCisJCWkyY191bnJlZ2lzdGVyX2RldmljZShjaGlwLT5ydGMpOw0K
KwkJcmV0dXJuIC1FTk9ERVY7DQorCX0NCiAJaTJjX3NldF9jbGllbnRkYXRhKGNoaXAtPmFkYywg
Y2hpcCk7DQogDQogCW1heDg5MjVfZGV2aWNlX2luaXQoY2hpcCwgcGRhdGEpOw0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWZkL21heDg5OTcuYyBiL2RyaXZlcnMvbWZkL21heDg5OTcuYw0KaW5kZXgg
NWJlNTNhZS4uMTkyNmE1NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWZkL21heDg5OTcuYw0KKysr
IGIvZHJpdmVycy9tZmQvbWF4ODk5Ny5jDQpAQCAtMTQ4LDEwICsxNDgsMjYgQEAgc3RhdGljIGlu
dCBtYXg4OTk3X2kyY19wcm9iZShzdHJ1Y3QgaTJjX2NsaWVudCAqaTJjLA0KIAltdXRleF9pbml0
KCZtYXg4OTk3LT5pb2xvY2spOw0KIA0KIAltYXg4OTk3LT5ydGMgPSBpMmNfbmV3X2R1bW15KGky
Yy0+YWRhcHRlciwgSTJDX0FERFJfUlRDKTsNCisJaWYgKCFtYXg4OTk3LT5ydGMpIHsNCisJCWRl
dl9lcnIobWF4ODk5Ny0+ZGV2LCAiRmFpbGVkIHRvIGFsbG9jYXRlIEkyQyBkZXZpY2UgZm9yIFJU
Q1xuIik7DQorCQlyZXR1cm4gLUVOT0RFVjsNCisJfQ0KIAlpMmNfc2V0X2NsaWVudGRhdGEobWF4
ODk5Ny0+cnRjLCBtYXg4OTk3KTsNCisNCiAJbWF4ODk5Ny0+aGFwdGljID0gaTJjX25ld19kdW1t
eShpMmMtPmFkYXB0ZXIsIEkyQ19BRERSX0hBUFRJQyk7DQorCWlmICghbWF4ODk5Ny0+aGFwdGlj
KSB7DQorCQlkZXZfZXJyKG1heDg5OTctPmRldiwgIkZhaWxlZCB0byBhbGxvY2F0ZSBJMkMgZGV2
aWNlIGZvciBIYXB0aWNcbiIpOw0KKwkJcmV0ID0gLUVOT0RFVjsNCisJCWdvdG8gZXJyX2kyY19o
YXB0aWM7DQorCX0NCiAJaTJjX3NldF9jbGllbnRkYXRhKG1heDg5OTctPmhhcHRpYywgbWF4ODk5
Nyk7DQorDQogCW1heDg5OTctPm11aWMgPSBpMmNfbmV3X2R1bW15KGkyYy0+YWRhcHRlciwgSTJD
X0FERFJfTVVJQyk7DQorCWlmICghbWF4ODk5Ny0+bXVpYykgew0KKwkJZGV2X2VycihtYXg4OTk3
LT5kZXYsICJGYWlsZWQgdG8gYWxsb2NhdGUgSTJDIGRldmljZSBmb3IgTVVJQ1xuIik7DQorCQly
ZXQgPSAtRU5PREVWOw0KKwkJZ290byBlcnJfaTJjX211aWM7DQorCX0NCiAJaTJjX3NldF9jbGll
bnRkYXRhKG1heDg5OTctPm11aWMsIG1heDg5OTcpOw0KIA0KIAlwbV9ydW50aW1lX3NldF9hY3Rp
dmUobWF4ODk5Ny0+ZGV2KTsNCkBAIC0xNzgsNyArMTk0LDkgQEAgc3RhdGljIGludCBtYXg4OTk3
X2kyY19wcm9iZShzdHJ1Y3QgaTJjX2NsaWVudCAqaTJjLA0KIGVycl9tZmQ6DQogCW1mZF9yZW1v
dmVfZGV2aWNlcyhtYXg4OTk3LT5kZXYpOw0KIAlpMmNfdW5yZWdpc3Rlcl9kZXZpY2UobWF4ODk5
Ny0+bXVpYyk7DQorZXJyX2kyY19tdWljOg0KIAlpMmNfdW5yZWdpc3Rlcl9kZXZpY2UobWF4ODk5
Ny0+aGFwdGljKTsNCitlcnJfaTJjX2hhcHRpYzoNCiAJaTJjX3VucmVnaXN0ZXJfZGV2aWNlKG1h
eDg5OTctPnJ0Yyk7DQogZXJyOg0KIAlrZnJlZShtYXg4OTk3KTsNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL21mZC9tYXg4OTk4LmMgYi9kcml2ZXJzL21mZC9tYXg4OTk4LmMNCmluZGV4IGRlNDA5NmEu
LjJmYTZhMjggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21mZC9tYXg4OTk4LmMNCisrKyBiL2RyaXZl
cnMvbWZkL21heDg5OTguYw0KQEAgLTE1Miw2ICsxNTIsMTAgQEAgc3RhdGljIGludCBtYXg4OTk4
X2kyY19wcm9iZShzdHJ1Y3QgaTJjX2NsaWVudCAqaTJjLA0KIAltdXRleF9pbml0KCZtYXg4OTk4
LT5pb2xvY2spOw0KIA0KIAltYXg4OTk4LT5ydGMgPSBpMmNfbmV3X2R1bW15KGkyYy0+YWRhcHRl
ciwgUlRDX0kyQ19BRERSKTsNCisJaWYgKCFtYXg4OTk4LT5ydGMpIHsNCisJCWRldl9lcnIoJmky
Yy0+ZGV2LCAiRmFpbGVkIHRvIGFsbG9jYXRlIEkyQyBkZXZpY2UgZm9yIFJUQ1xuIik7DQorCQly
ZXR1cm4gLUVOT0RFVjsNCisJfQ0KIAlpMmNfc2V0X2NsaWVudGRhdGEobWF4ODk5OC0+cnRjLCBt
YXg4OTk4KTsNCiANCiAJbWF4ODk5OF9pcnFfaW5pdChtYXg4OTk4KTsNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsveG1pdC5jIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoL2F0aDlrL3htaXQuYw0KaW5kZXggMmU4OGFmMS4uYTBiYTVhYyAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay94bWl0LmMNCisrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGg5ay94bWl0LmMNCkBAIC0xMzkwLDcgKzEzOTAsNyBAQCBpbnQgYXRo
X2NhYnFfdXBkYXRlKHN0cnVjdCBhdGhfc29mdGMgKnNjKQ0KIAllbHNlIGlmIChzYy0+Y29uZmln
LmNhYnFSZWFkeXRpbWUgPiBBVEg5S19SRUFEWV9USU1FX0hJX0JPVU5EKQ0KIAkJc2MtPmNvbmZp
Zy5jYWJxUmVhZHl0aW1lID0gQVRIOUtfUkVBRFlfVElNRV9ISV9CT1VORDsNCiANCi0JcWkudHFp
X3JlYWR5VGltZSA9IChjdXJfY29uZi0+YmVhY29uX2ludGVydmFsICoNCisJcWkudHFpX3JlYWR5
VGltZSA9IChUVV9UT19VU0VDKGN1cl9jb25mLT5iZWFjb25faW50ZXJ2YWwpICoNCiAJCQkgICAg
c2MtPmNvbmZpZy5jYWJxUmVhZHl0aW1lKSAvIDEwMDsNCiAJYXRoX3R4cV91cGRhdGUoc2MsIHFu
dW0sICZxaSk7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3BoeV9u
LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvcGh5X24uYw0KaW5kZXggYjE3ZDliNi4uMDQ5
MGM3YyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9waHlfbi5jDQorKysg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvcGh5X24uYw0KQEAgLTM5MzcsMjIgKzM5MzcsMjIg
QEAgc3RhdGljIHZvaWQgYjQzX25waHlfY2hhbm5lbF9zZXR1cChzdHJ1Y3QgYjQzX3dsZGV2ICpk
ZXYsDQogCXN0cnVjdCBiNDNfcGh5X24gKm5waHkgPSBkZXYtPnBoeS5uOw0KIA0KIAl1MTYgb2xk
X2JhbmRfNWdoejsNCi0JdTMyIHRtcDMyOw0KKwl1MTYgdG1wMTY7DQogDQogCW9sZF9iYW5kXzVn
aHogPQ0KIAkJYjQzX3BoeV9yZWFkKGRldiwgQjQzX05QSFlfQkFORENUTCkgJiBCNDNfTlBIWV9C
QU5EQ1RMXzVHSFo7DQogCWlmIChuZXdfY2hhbm5lbC0+YmFuZCA9PSBJRUVFODAyMTFfQkFORF81
R0haICYmICFvbGRfYmFuZF81Z2h6KSB7DQotCQl0bXAzMiA9IGI0M19yZWFkMzIoZGV2LCBCNDNf
TU1JT19QU01fUEhZX0hEUik7DQotCQliNDNfd3JpdGUzMihkZXYsIEI0M19NTUlPX1BTTV9QSFlf
SERSLCB0bXAzMiB8IDQpOw0KKwkJdG1wMTYgPSBiNDNfcmVhZDE2KGRldiwgQjQzX01NSU9fUFNN
X1BIWV9IRFIpOw0KKwkJYjQzX3dyaXRlMTYoZGV2LCBCNDNfTU1JT19QU01fUEhZX0hEUiwgdG1w
MTYgfCA0KTsNCiAJCWI0M19waHlfc2V0KGRldiwgQjQzX1BIWV9CX0JCQ0ZHLCAweEMwMDApOw0K
LQkJYjQzX3dyaXRlMzIoZGV2LCBCNDNfTU1JT19QU01fUEhZX0hEUiwgdG1wMzIpOw0KKwkJYjQz
X3dyaXRlMTYoZGV2LCBCNDNfTU1JT19QU01fUEhZX0hEUiwgdG1wMTYpOw0KIAkJYjQzX3BoeV9z
ZXQoZGV2LCBCNDNfTlBIWV9CQU5EQ1RMLCBCNDNfTlBIWV9CQU5EQ1RMXzVHSFopOw0KIAl9IGVs
c2UgaWYgKG5ld19jaGFubmVsLT5iYW5kID09IElFRUU4MDIxMV9CQU5EXzJHSFogJiYgb2xkX2Jh
bmRfNWdoeikgew0KIAkJYjQzX3BoeV9tYXNrKGRldiwgQjQzX05QSFlfQkFORENUTCwgfkI0M19O
UEhZX0JBTkRDVExfNUdIWik7DQotCQl0bXAzMiA9IGI0M19yZWFkMzIoZGV2LCBCNDNfTU1JT19Q
U01fUEhZX0hEUik7DQotCQliNDNfd3JpdGUzMihkZXYsIEI0M19NTUlPX1BTTV9QSFlfSERSLCB0
bXAzMiB8IDQpOw0KKwkJdG1wMTYgPSBiNDNfcmVhZDE2KGRldiwgQjQzX01NSU9fUFNNX1BIWV9I
RFIpOw0KKwkJYjQzX3dyaXRlMTYoZGV2LCBCNDNfTU1JT19QU01fUEhZX0hEUiwgdG1wMTYgfCA0
KTsNCiAJCWI0M19waHlfbWFzayhkZXYsIEI0M19QSFlfQl9CQkNGRywgMHgzRkZGKTsNCi0JCWI0
M193cml0ZTMyKGRldiwgQjQzX01NSU9fUFNNX1BIWV9IRFIsIHRtcDMyKTsNCisJCWI0M193cml0
ZTE2KGRldiwgQjQzX01NSU9fUFNNX1BIWV9IRFIsIHRtcDE2KTsNCiAJfQ0KIA0KIAliNDNfY2hh
bnRhYl9waHlfdXBsb2FkKGRldiwgZSk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvaXdsd2lmaS9pd2wtYWduLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1h
Z24uYw0KaW5kZXggOTRkMzVhZC4uNGEzNjk3MyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2l3bHdpZmkvaXdsLWFnbi5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3
aWZpL2l3bC1hZ24uYw0KQEAgLTI0NiwxMyArMjQ2LDE3IEBAIHN0YXRpYyB2b2lkIGl3bF9iZ19i
dF9ydW50aW1lX2NvbmZpZyhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQogCXN0cnVjdCBpd2xf
cHJpdiAqcHJpdiA9DQogCQljb250YWluZXJfb2Yod29yaywgc3RydWN0IGl3bF9wcml2LCBidF9y
dW50aW1lX2NvbmZpZyk7DQogDQorCW11dGV4X2xvY2soJnByaXYtPnNocmQtPm11dGV4KTsNCiAJ
aWYgKHRlc3RfYml0KFNUQVRVU19FWElUX1BFTkRJTkcsICZwcml2LT5zaHJkLT5zdGF0dXMpKQ0K
LQkJcmV0dXJuOw0KKwkJZ290byBvdXQ7DQogDQogCS8qIGRvbnQgc2VuZCBob3N0IGNvbW1hbmQg
aWYgcmYta2lsbCBpcyBvbiAqLw0KIAlpZiAoIWl3bF9pc19yZWFkeV9yZihwcml2LT5zaHJkKSkN
Ci0JCXJldHVybjsNCisJCWdvdG8gb3V0Ow0KKw0KIAlpd2xhZ25fc2VuZF9hZHZhbmNlX2J0X2Nv
bmZpZyhwcml2KTsNCitvdXQ6DQorCW11dGV4X3VubG9jaygmcHJpdi0+c2hyZC0+bXV0ZXgpOw0K
IH0NCiANCiBzdGF0aWMgdm9pZCBpd2xfYmdfYnRfZnVsbF9jb25jdXJyZW5jeShzdHJ1Y3Qgd29y
a19zdHJ1Y3QgKndvcmspDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lm
aS9ydGw4MTkyc2UvaHcuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MnNl
L2h3LmMNCmluZGV4IGM0NzQ0ODYuLjUwM2MxNjAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93
aXJlbGVzcy9ydGx3aWZpL3J0bDgxOTJzZS9ody5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9ydGx3aWZpL3J0bDgxOTJzZS9ody5jDQpAQCAtOTI0LDcgKzkyNCw3IEBAIGludCBydGw5MnNl
X2h3X2luaXQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpDQogCXN0cnVjdCBydGxfcGNpICpydGxw
Y2kgPSBydGxfcGNpZGV2KHJ0bF9wY2lwcml2KGh3KSk7DQogCXN0cnVjdCBydGxfZWZ1c2UgKnJ0
bGVmdXNlID0gcnRsX2VmdXNlKHJ0bF9wcml2KGh3KSk7DQogCXU4IHRtcF9ieXRlID0gMDsNCi0N
CisJdW5zaWduZWQgbG9uZyBmbGFnczsNCiAJYm9vbCBydHN0YXR1cyA9IHRydWU7DQogCXU4IHRt
cF91MWI7DQogCWludCBlcnIgPSBmYWxzZTsNCkBAIC05MzYsNiArOTM2LDE2IEBAIGludCBydGw5
MnNlX2h3X2luaXQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpDQogDQogCXJ0bHBjaS0+YmVpbmdf
aW5pdF9hZGFwdGVyID0gdHJ1ZTsNCiANCisJLyogQXMgdGhpcyBmdW5jdGlvbiBjYW4gdGFrZSBh
IHZlcnkgbG9uZyB0aW1lICh1cCB0byAzNTAgbXMpDQorCSAqIGFuZCBjYW4gYmUgY2FsbGVkIHdp
dGggaXJxcyBkaXNhYmxlZCwgcmVlbmFibGUgdGhlIGlycXMNCisJICogdG8gbGV0IHRoZSBvdGhl
ciBkZXZpY2VzIGNvbnRpbnVlIGJlaW5nIHNlcnZpY2VkLg0KKwkgKg0KKwkgKiBJdCBpcyBzYWZl
IGRvaW5nIHNvIHNpbmNlIG91ciBvd24gaW50ZXJydXB0cyB3aWxsIG9ubHkgYmUgZW5hYmxlZA0K
KwkgKiBpbiBhIHN1YnNlcXVlbnQgc3RlcC4NCisJICovDQorCWxvY2FsX3NhdmVfZmxhZ3MoZmxh
Z3MpOw0KKwlsb2NhbF9pcnFfZW5hYmxlKCk7DQorDQogCXJ0bHByaXYtPmludGZfb3BzLT5kaXNh
YmxlX2FzcG0oaHcpOw0KIA0KIAkvKiAxLiBNQUMgSW5pdGlhbGl6ZSAqLw0KQEAgLTk2OSw3ICs5
NzksOCBAQCBpbnQgcnRsOTJzZV9od19pbml0KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQ0KIAkv
KiAzLiBJbml0aWFsaXplIE1BQy9QSFkgQ29uZmlnIGJ5IE1BQ1BIWV9yZWcudHh0ICovDQogCWlm
IChydGw5MnNfcGh5X21hY19jb25maWcoaHcpICE9IHRydWUpIHsNCiAJCVJUX1RSQUNFKHJ0bHBy
aXYsIENPTVBfRVJSLCBEQkdfRU1FUkcsICgiTUFDIENvbmZpZyBmYWlsZWRcbiIpKTsNCi0JCXJl
dHVybiBydHN0YXR1czsNCisJCWVyciA9IHJ0c3RhdHVzOw0KKwkJZ290byBleGl0Ow0KIAl9DQog
DQogCS8qIE1ha2Ugc3VyZSBCQi9SRiB3cml0ZSBPSy4gV2Ugc2hvdWxkIHByZXZlbnQgZW50ZXIg
SVBTLiByYWRpbyBvZmYuICovDQpAQCAtOTc5LDcgKzk5MCw4IEBAIGludCBydGw5MnNlX2h3X2lu
aXQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpDQogCS8qIDQuIEluaXRpYWxpemUgQkIgQWZ0ZXIg
TUFDIENvbmZpZyBQSFlfcmVnLnR4dCwgQUdDX1RhYi50eHQgKi8NCiAJaWYgKHJ0bDkyc19waHlf
YmJfY29uZmlnKGh3KSAhPSB0cnVlKSB7DQogCQlSVF9UUkFDRShydGxwcml2LCBDT01QX0lOSVQs
IERCR19FTUVSRywgKCJCQiBDb25maWcgZmFpbGVkXG4iKSk7DQotCQlyZXR1cm4gcnRzdGF0dXM7
DQorCQllcnIgPSBydHN0YXR1czsNCisJCWdvdG8gZXhpdDsNCiAJfQ0KIA0KIAkvKiA1LiBJbml0
aWFpbHplIFJGIFJBSU9fQS50eHQgUkYgUkFJT19CLnR4dCAqLw0KQEAgLTEwMTUsNyArMTAyNyw4
IEBAIGludCBydGw5MnNlX2h3X2luaXQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpDQogDQogCWlm
IChydGw5MnNfcGh5X3JmX2NvbmZpZyhodykgIT0gdHJ1ZSkgew0KIAkJUlRfVFJBQ0UocnRscHJp
diwgQ09NUF9JTklULCBEQkdfRE1FU0csICgiUkYgQ29uZmlnIGZhaWxlZFxuIikpOw0KLQkJcmV0
dXJuIHJ0c3RhdHVzOw0KKwkJZXJyID0gcnRzdGF0dXM7DQorCQlnb3RvIGV4aXQ7DQogCX0NCiAN
CiAJLyogQWZ0ZXIgcmVhZCBwcmVkZWZpbmVkIFRYVCwgd2UgbXVzdCBzZXQgQkIvTUFDL1JGDQpA
QCAtMTA4OSw4ICsxMTAyLDkgQEAgaW50IHJ0bDkyc2VfaHdfaW5pdChzdHJ1Y3QgaWVlZTgwMjEx
X2h3ICpodykNCiANCiAJcnRscHJpdi0+Y2ZnLT5vcHMtPmxlZF9jb250cm9sKGh3LCBMRURfQ1RM
X1BPV0VSX09OKTsNCiAJcnRsOTJzX2RtX2luaXQoaHcpOw0KK2V4aXQ6DQorCWxvY2FsX2lycV9y
ZXN0b3JlKGZsYWdzKTsNCiAJcnRscGNpLT5iZWluZ19pbml0X2FkYXB0ZXIgPSBmYWxzZTsNCi0N
CiAJcmV0dXJuIGVycjsNCiB9DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQveGVuLW5ldGJh
Y2svbmV0YmFjay5jIGIvZHJpdmVycy9uZXQveGVuLW5ldGJhY2svbmV0YmFjay5jDQppbmRleCA5
YTQ2MjZjLi5iMjUyOGY2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQveGVuLW5ldGJhY2svbmV0
YmFjay5jDQorKysgYi9kcml2ZXJzL25ldC94ZW4tbmV0YmFjay9uZXRiYWNrLmMNCkBAIC0zNDYs
OCArMzQ2LDggQEAgc3RhdGljIGJvb2wgc3RhcnRfbmV3X3J4X2J1ZmZlcihpbnQgb2Zmc2V0LCB1
bnNpZ25lZCBsb25nIHNpemUsIGludCBoZWFkKQ0KIAkgKiBpbnRvIG11bHRpcGxlIGNvcGllcyB0
ZW5kIHRvIGdpdmUgbGFyZ2UgZnJhZ3MgdGhlaXINCiAJICogb3duIGJ1ZmZlcnMgYXMgYmVmb3Jl
Lg0KIAkgKi8NCi0JaWYgKChvZmZzZXQgKyBzaXplID4gTUFYX0JVRkZFUl9PRkZTRVQpICYmDQot
CSAgICAoc2l6ZSA8PSBNQVhfQlVGRkVSX09GRlNFVCkgJiYgb2Zmc2V0ICYmICFoZWFkKQ0KKwlC
VUdfT04oc2l6ZSA+IE1BWF9CVUZGRVJfT0ZGU0VUKTsNCisJaWYgKChvZmZzZXQgKyBzaXplID4g
TUFYX0JVRkZFUl9PRkZTRVQpICYmIG9mZnNldCAmJiAhaGVhZCkNCiAJCXJldHVybiB0cnVlOw0K
IA0KIAlyZXR1cm4gZmFsc2U7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2lzY2kvcG9ydF9j
b25maWcuYyBiL2RyaXZlcnMvc2NzaS9pc2NpL3BvcnRfY29uZmlnLmMNCmluZGV4IDIxYTY3Njku
LjM4YTk5ZDIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvaXNjaS9wb3J0X2NvbmZpZy5jDQor
KysgYi9kcml2ZXJzL3Njc2kvaXNjaS9wb3J0X2NvbmZpZy5jDQpAQCAtNjEwLDYgKzYxMCwxMyBA
QCBzdGF0aWMgdm9pZCBzY2lfYXBjX2FnZW50X2xpbmtfdXAoc3RydWN0IGlzY2lfaG9zdCAqaWhv
c3QsDQogCQlzY2lfYXBjX2FnZW50X2NvbmZpZ3VyZV9wb3J0cyhpaG9zdCwgcG9ydF9hZ2VudCwg
aXBoeSwgdHJ1ZSk7DQogCX0gZWxzZSB7DQogCQkvKiB0aGUgcGh5IGlzIGFscmVhZHkgdGhlIHBh
cnQgb2YgdGhlIHBvcnQgKi8NCisJCXUzMiBwb3J0X3N0YXRlID0gaXBvcnQtPnNtLmN1cnJlbnRf
c3RhdGVfaWQ7DQorDQorCQkvKiBpZiB0aGUgUE9SVCdTIHN0YXRlIGlzIHJlc2V0dGluZyB0aGVu
IHRoZSBsaW5rIHVwIGlzIGZyb20NCisJCSAqIHBvcnQgaGFyZCByZXNldCBpbiB0aGlzIGNhc2Us
IHdlIG5lZWQgdG8gdGVsbCB0aGUgcG9ydA0KKwkJICogdGhhdCBsaW5rIHVwIGlzIHJlY2lldmVk
DQorCQkgKi8NCisJCUJVR19PTihwb3J0X3N0YXRlICE9IFNDSV9QT1JUX1JFU0VUVElORyk7DQog
CQlwb3J0X2FnZW50LT5waHlfcmVhZHlfbWFzayB8PSAxIDw8IHBoeV9pbmRleDsNCiAJCXNjaV9w
b3J0X2xpbmtfdXAoaXBvcnQsIGlwaHkpOw0KIAl9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L2lzY2kvdGFzay5jIGIvZHJpdmVycy9zY3NpL2lzY2kvdGFzay5jDQppbmRleCA2MGE1MzBmLi5l
Mjk0ZDExIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL2lzY2kvdGFzay5jDQorKysgYi9kcml2
ZXJzL3Njc2kvaXNjaS90YXNrLmMNCkBAIC0xMzkwLDcgKzEzOTAsNyBAQCBpbnQgaXNjaV90YXNr
X0lfVF9uZXh1c19yZXNldChzdHJ1Y3QgZG9tYWluX2RldmljZSAqZGV2KQ0KIAlzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZpaG9zdC0+c2NpY19sb2NrLCBmbGFncyk7DQogDQogCWlmICghaWRldiB8
fCAhdGVzdF9iaXQoSURFVl9FSCwgJmlkZXYtPmZsYWdzKSkgew0KLQkJcmV0ID0gLUVOT0RFVjsN
CisJCXJldCA9IFRNRl9SRVNQX0ZVTkNfQ09NUExFVEU7DQogCQlnb3RvIG91dDsNCiAJfQ0KIA0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9zZXJxdF91c2IyL3NlcnF0X3VzYjIuYyBiL2Ry
aXZlcnMvc3RhZ2luZy9zZXJxdF91c2IyL3NlcnF0X3VzYjIuYw0KaW5kZXggYzQ0ZTQxYS4uYzI3
MzFjYSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy9zZXJxdF91c2IyL3NlcnF0X3VzYjIu
Yw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3NlcnF0X3VzYjIvc2VycXRfdXNiMi5jDQpAQCAtNzcy
LDcgKzc3Miw3IEBAIHN0YXRpYyBpbnQgcXRfc3RhcnR1cChzdHJ1Y3QgdXNiX3NlcmlhbCAqc2Vy
aWFsKQ0KIAkJZ290byBzdGFydHVwX2Vycm9yOw0KIAl9DQogDQotCXN3aXRjaCAoc2VyaWFsLT5k
ZXYtPmRlc2NyaXB0b3IuaWRQcm9kdWN0KSB7DQorCXN3aXRjaCAobGUxNl90b19jcHUoc2VyaWFs
LT5kZXYtPmRlc2NyaXB0b3IuaWRQcm9kdWN0KSkgew0KIAljYXNlIFFVQVRFQ0hfRFNVMTAwOg0K
IAljYXNlIFFVQVRFQ0hfUVNVMTAwOg0KIAljYXNlIFFVQVRFQ0hfRVNVMTAwQToNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3RhcmdldC9pc2NzaS9pc2NzaV90YXJnZXQuYyBiL2RyaXZlcnMvdGFyZ2V0
L2lzY3NpL2lzY3NpX3RhcmdldC5jDQppbmRleCA0YTg4ZWVhLi5hYjVkZDE2IDEwMDY0NA0KLS0t
IGEvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0LmMNCisrKyBiL2RyaXZlcnMvdGFy
Z2V0L2lzY3NpL2lzY3NpX3RhcmdldC5jDQpAQCAtMjM1OCw2ICsyMzU4LDcgQEAgc3RhdGljIHZv
aWQgaXNjc2l0X2J1aWxkX2Nvbm5fZHJvcF9hc3luY19tZXNzYWdlKHN0cnVjdCBpc2NzaV9jb25u
ICpjb25uKQ0KIHsNCiAJc3RydWN0IGlzY3NpX2NtZCAqY21kOw0KIAlzdHJ1Y3QgaXNjc2lfY29u
biAqY29ubl9wOw0KKwlib29sIGZvdW5kID0gZmFsc2U7DQogDQogCS8qDQogCSAqIE9ubHkgc2Vu
ZCBhIEFzeW5jaHJvbm91cyBNZXNzYWdlIG9uIGNvbm5lY3Rpb25zIHdob3MgbmV0d29yaw0KQEAg
LTIzNjYsMTEgKzIzNjcsMTIgQEAgc3RhdGljIHZvaWQgaXNjc2l0X2J1aWxkX2Nvbm5fZHJvcF9h
c3luY19tZXNzYWdlKHN0cnVjdCBpc2NzaV9jb25uICpjb25uKQ0KIAlsaXN0X2Zvcl9lYWNoX2Vu
dHJ5KGNvbm5fcCwgJmNvbm4tPnNlc3MtPnNlc3NfY29ubl9saXN0LCBjb25uX2xpc3QpIHsNCiAJ
CWlmIChjb25uX3AtPmNvbm5fc3RhdGUgPT0gVEFSR19DT05OX1NUQVRFX0xPR0dFRF9JTikgew0K
IAkJCWlzY3NpdF9pbmNfY29ubl91c2FnZV9jb3VudChjb25uX3ApOw0KKwkJCWZvdW5kID0gdHJ1
ZTsNCiAJCQlicmVhazsNCiAJCX0NCiAJfQ0KIA0KLQlpZiAoIWNvbm5fcCkNCisJaWYgKCFmb3Vu
ZCkNCiAJCXJldHVybjsNCiANCiAJY21kID0gaXNjc2l0X2FsbG9jYXRlX2NtZChjb25uX3AsIEdG
UF9BVE9NSUMpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGFyZ2V0L3RjbV9mYy90ZmNfc2Vzcy5j
IGIvZHJpdmVycy90YXJnZXQvdGNtX2ZjL3RmY19zZXNzLmMNCmluZGV4IGFiMGEzZmEuLmIzMjgw
MTEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3RhcmdldC90Y21fZmMvdGZjX3Nlc3MuYw0KKysrIGIv
ZHJpdmVycy90YXJnZXQvdGNtX2ZjL3RmY19zZXNzLmMNCkBAIC03Miw2ICs3Miw3IEBAIHN0YXRp
YyBzdHJ1Y3QgZnRfdHBvcnQgKmZ0X3Rwb3J0X2NyZWF0ZShzdHJ1Y3QgZmNfbHBvcnQgKmxwb3J0
KQ0KIA0KIAlpZiAodHBvcnQpIHsNCiAJCXRwb3J0LT50cGcgPSB0cGc7DQorCQl0cGctPnRwb3J0
ID0gdHBvcnQ7DQogCQlyZXR1cm4gdHBvcnQ7DQogCX0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3R0eS9odmMvaHZjX2NvbnNvbGUuYyBiL2RyaXZlcnMvdHR5L2h2Yy9odmNfY29uc29sZS5jDQpp
bmRleCBiNmIyZDE4Li43Yjk3ZTdlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy90dHkvaHZjL2h2Y19j
b25zb2xlLmMNCisrKyBiL2RyaXZlcnMvdHR5L2h2Yy9odmNfY29uc29sZS5jDQpAQCAtMzEsNiAr
MzEsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9saXN0Lmg+DQogI2luY2x1ZGUgPGxpbnV4L21vZHVs
ZS5oPg0KICNpbmNsdWRlIDxsaW51eC9tYWpvci5oPg0KKyNpbmNsdWRlIDxsaW51eC9hdG9taWMu
aD4NCiAjaW5jbHVkZSA8bGludXgvc3lzcnEuaD4NCiAjaW5jbHVkZSA8bGludXgvdHR5Lmg+DQog
I2luY2x1ZGUgPGxpbnV4L3R0eV9mbGlwLmg+DQpAQCAtNzAsNiArNzEsOSBAQCBzdGF0aWMgc3Ry
dWN0IHRhc2tfc3RydWN0ICpodmNfdGFzazsNCiAvKiBQaWNrcyB1cCBsYXRlIGtpY2tzIGFmdGVy
IGxpc3Qgd2FsayBidXQgYmVmb3JlIHNjaGVkdWxlKCkgKi8NCiBzdGF0aWMgaW50IGh2Y19raWNr
ZWQ7DQogDQorLyogaHZjX2luaXQgaXMgdHJpZ2dlcmVkIGZyb20gaHZjX2FsbG9jLCBpLmUuIG9u
bHkgd2hlbiBhY3R1YWxseSB1c2VkICovDQorc3RhdGljIGF0b21pY190IGh2Y19uZWVkc19pbml0
IF9fcmVhZF9tb3N0bHkgPSBBVE9NSUNfSU5JVCgtMSk7DQorDQogc3RhdGljIGludCBodmNfaW5p
dCh2b2lkKTsNCiANCiAjaWZkZWYgQ09ORklHX01BR0lDX1NZU1JRDQpAQCAtODI1LDcgKzgyOSw3
IEBAIHN0cnVjdCBodmNfc3RydWN0ICpodmNfYWxsb2ModWludDMyX3QgdnRlcm1ubywgaW50IGRh
dGEsDQogCWludCBpOw0KIA0KIAkvKiBXZSB3YWl0IHVudGlsIGEgZHJpdmVyIGFjdHVhbGx5IGNv
bWVzIGFsb25nICovDQotCWlmICghaHZjX2RyaXZlcikgew0KKwlpZiAoYXRvbWljX2luY19ub3Rf
emVybygmaHZjX25lZWRzX2luaXQpKSB7DQogCQlpbnQgZXJyID0gaHZjX2luaXQoKTsNCiAJCWlm
IChlcnIpDQogCQkJcmV0dXJuIEVSUl9QVFIoZXJyKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3R0
eS90dHlfaW8uYyBiL2RyaXZlcnMvdHR5L3R0eV9pby5jDQppbmRleCAzZjM1ZTQyLi40NDZkZjZi
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy90dHkvdHR5X2lvLmMNCisrKyBiL2RyaXZlcnMvdHR5L3R0
eV9pby5jDQpAQCAtMTIyMiw5ICsxMjIyLDkgQEAgc3RhdGljIHZvaWQgcHR5X2xpbmVfbmFtZShz
dHJ1Y3QgdHR5X2RyaXZlciAqZHJpdmVyLCBpbnQgaW5kZXgsIGNoYXIgKnApDQogICoNCiAgKglM
b2NraW5nOiBOb25lDQogICovDQotc3RhdGljIHZvaWQgdHR5X2xpbmVfbmFtZShzdHJ1Y3QgdHR5
X2RyaXZlciAqZHJpdmVyLCBpbnQgaW5kZXgsIGNoYXIgKnApDQorc3RhdGljIHNzaXplX3QgdHR5
X2xpbmVfbmFtZShzdHJ1Y3QgdHR5X2RyaXZlciAqZHJpdmVyLCBpbnQgaW5kZXgsIGNoYXIgKnAp
DQogew0KLQlzcHJpbnRmKHAsICIlcyVkIiwgZHJpdmVyLT5uYW1lLCBpbmRleCArIGRyaXZlci0+
bmFtZV9iYXNlKTsNCisJcmV0dXJuIHNwcmludGYocCwgIiVzJWQiLCBkcml2ZXItPm5hbWUsIGlu
ZGV4ICsgZHJpdmVyLT5uYW1lX2Jhc2UpOw0KIH0NCiANCiAvKioNCkBAIC0zMzIxLDkgKzMzMjEs
MTkgQEAgc3RhdGljIHNzaXplX3Qgc2hvd19jb25zX2FjdGl2ZShzdHJ1Y3QgZGV2aWNlICpkZXYs
DQogCQlpZiAoaSA+PSBBUlJBWV9TSVpFKGNzKSkNCiAJCQlicmVhazsNCiAJfQ0KLQl3aGlsZSAo
aS0tKQ0KLQkJY291bnQgKz0gc3ByaW50ZihidWYgKyBjb3VudCwgIiVzJWQlYyIsDQotCQkJCSBj
c1tpXS0+bmFtZSwgY3NbaV0tPmluZGV4LCBpID8gJyAnOidcbicpOw0KKwl3aGlsZSAoaS0tKSB7
DQorCQlpbnQgaW5kZXggPSBjc1tpXS0+aW5kZXg7DQorCQlzdHJ1Y3QgdHR5X2RyaXZlciAqZHJ2
ID0gY3NbaV0tPmRldmljZShjc1tpXSwgJmluZGV4KTsNCisNCisJCS8qIGRvbid0IHJlc29sdmUg
dHR5MCBhcyBzb21lIHByb2dyYW1zIGRlcGVuZCBvbiBpdCAqLw0KKwkJaWYgKGRydiAmJiAoY3Nb
aV0tPmluZGV4ID4gMCB8fCBkcnYtPm1ham9yICE9IFRUWV9NQUpPUikpDQorCQkJY291bnQgKz0g
dHR5X2xpbmVfbmFtZShkcnYsIGluZGV4LCBidWYgKyBjb3VudCk7DQorCQllbHNlDQorCQkJY291
bnQgKz0gc3ByaW50ZihidWYgKyBjb3VudCwgIiVzJWQiLA0KKwkJCQkJIGNzW2ldLT5uYW1lLCBj
c1tpXS0+aW5kZXgpOw0KKw0KKwkJY291bnQgKz0gc3ByaW50ZihidWYgKyBjb3VudCwgIiVjIiwg
aSA/ICcgJzonXG4nKTsNCisJfQ0KIAljb25zb2xlX3VubG9jaygpOw0KIA0KIAlyZXR1cm4gY291
bnQ7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZHdjMy9jb3JlLmggYi9kcml2ZXJzL3VzYi9k
d2MzL2NvcmUuaA0KaW5kZXggNDc5NWMwYy4uYWUyYjc2MyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
dXNiL2R3YzMvY29yZS5oDQorKysgYi9kcml2ZXJzL3VzYi9kd2MzL2NvcmUuaA0KQEAgLTcxNiwx
NSArNzE2LDE1IEBAIHN0cnVjdCBkd2MzX2V2ZW50X2RlcGV2dCB7DQogICoJMTIJLSBWbmRyRGV2
VHN0UmN2ZWQNCiAgKiBAcmVzZXJ2ZWQxNV8xMjogUmVzZXJ2ZWQsIG5vdCB1c2VkDQogICogQGV2
ZW50X2luZm86IEluZm9ybWF0aW9uIGFib3V0IHRoaXMgZXZlbnQNCi0gKiBAcmVzZXJ2ZWQzMV8y
NDogUmVzZXJ2ZWQsIG5vdCB1c2VkDQorICogQHJlc2VydmVkMzFfMjU6IFJlc2VydmVkLCBub3Qg
dXNlZA0KICAqLw0KIHN0cnVjdCBkd2MzX2V2ZW50X2RldnQgew0KIAl1MzIJb25lX2JpdDoxOw0K
IAl1MzIJZGV2aWNlX2V2ZW50Ojc7DQogCXUzMgl0eXBlOjQ7DQogCXUzMglyZXNlcnZlZDE1XzEy
OjQ7DQotCXUzMglldmVudF9pbmZvOjg7DQotCXUzMglyZXNlcnZlZDMxXzI0Ojg7DQorCXUzMgll
dmVudF9pbmZvOjk7DQorCXUzMglyZXNlcnZlZDMxXzI1Ojc7DQogfSBfX3BhY2tlZDsNCiANCiAv
KioNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9nYWRnZXQvYXRtZWxfdXNiYV91ZGMuYyBiL2Ry
aXZlcnMvdXNiL2dhZGdldC9hdG1lbF91c2JhX3VkYy5jDQppbmRleCAyNzFhOWQ4Li5iMjk5YzMy
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2IvZ2FkZ2V0L2F0bWVsX3VzYmFfdWRjLmMNCisrKyBi
L2RyaXZlcnMvdXNiL2dhZGdldC9hdG1lbF91c2JhX3VkYy5jDQpAQCAtMTg3NSwxMiArMTg3NSwx
MyBAQCBzdGF0aWMgaW50IGF0bWVsX3VzYmFfc3RvcChzdHJ1Y3QgdXNiX2dhZGdldF9kcml2ZXIg
KmRyaXZlcikNCiANCiAJZHJpdmVyLT51bmJpbmQoJnVkYy0+Z2FkZ2V0KTsNCiAJdWRjLT5nYWRn
ZXQuZGV2LmRyaXZlciA9IE5VTEw7DQotCXVkYy0+ZHJpdmVyID0gTlVMTDsNCiANCiAJY2xrX2Rp
c2FibGUodWRjLT5oY2xrKTsNCiAJY2xrX2Rpc2FibGUodWRjLT5wY2xrKTsNCiANCi0JREJHKERC
R19HQURHRVQsICJ1bnJlZ2lzdGVyZWQgZHJpdmVyIGAlcydcbiIsIGRyaXZlci0+ZHJpdmVyLm5h
bWUpOw0KKwlEQkcoREJHX0dBREdFVCwgInVucmVnaXN0ZXJlZCBkcml2ZXIgYCVzJ1xuIiwgdWRj
LT5kcml2ZXItPmRyaXZlci5uYW1lKTsNCisNCisJdWRjLT5kcml2ZXIgPSBOVUxMOw0KIA0KIAly
ZXR1cm4gMDsNCiB9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy92aG9zdC9uZXQuYyBiL2RyaXZlcnMv
dmhvc3QvbmV0LmMNCmluZGV4IDVjNTgxMjguLjdlZjg0YzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3Zob3N0L25ldC5jDQorKysgYi9kcml2ZXJzL3Zob3N0L25ldC5jDQpAQCAtMzE5LDkgKzMxOSwx
MyBAQCBzdGF0aWMgaW50IGdldF9yeF9idWZzKHN0cnVjdCB2aG9zdF92aXJ0cXVldWUgKnZxLA0K
IAkJCXIgPSAtRU5PQlVGUzsNCiAJCQlnb3RvIGVycjsNCiAJCX0NCi0JCWQgPSB2aG9zdF9nZXRf
dnFfZGVzYyh2cS0+ZGV2LCB2cSwgdnEtPmlvdiArIHNlZywNCisJCXIgPSB2aG9zdF9nZXRfdnFf
ZGVzYyh2cS0+ZGV2LCB2cSwgdnEtPmlvdiArIHNlZywNCiAJCQkJICAgICAgQVJSQVlfU0laRSh2
cS0+aW92KSAtIHNlZywgJm91dCwNCiAJCQkJICAgICAgJmluLCBsb2csIGxvZ19udW0pOw0KKwkJ
aWYgKHVubGlrZWx5KHIgPCAwKSkNCisJCQlnb3RvIGVycjsNCisNCisJCWQgPSByOw0KIAkJaWYg
KGQgPT0gdnEtPm51bSkgew0KIAkJCXIgPSAwOw0KIAkJCWdvdG8gZXJyOw0KQEAgLTM0Niw2ICsz
NTAsMTIgQEAgc3RhdGljIGludCBnZXRfcnhfYnVmcyhzdHJ1Y3Qgdmhvc3RfdmlydHF1ZXVlICp2
cSwNCiAJKmlvdmNvdW50ID0gc2VnOw0KIAlpZiAodW5saWtlbHkobG9nKSkNCiAJCSpsb2dfbnVt
ID0gbmxvZ3M7DQorDQorCS8qIERldGVjdCBvdmVycnVuICovDQorCWlmICh1bmxpa2VseShkYXRh
bGVuID4gMCkpIHsNCisJCXIgPSBVSU9fTUFYSU9WICsgMTsNCisJCWdvdG8gZXJyOw0KKwl9DQog
CXJldHVybiBoZWFkY291bnQ7DQogZXJyOg0KIAl2aG9zdF9kaXNjYXJkX3ZxX2Rlc2ModnEsIGhl
YWRjb3VudCk7DQpAQCAtNDAwLDYgKzQxMCwxNCBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfcngoc3Ry
dWN0IHZob3N0X25ldCAqbmV0KQ0KIAkJLyogT24gZXJyb3IsIHN0b3AgaGFuZGxpbmcgdW50aWwg
dGhlIG5leHQga2ljay4gKi8NCiAJCWlmICh1bmxpa2VseShoZWFkY291bnQgPCAwKSkNCiAJCQli
cmVhazsNCisJCS8qIE9uIG92ZXJydW4sIHRydW5jYXRlIGFuZCBkaXNjYXJkICovDQorCQlpZiAo
dW5saWtlbHkoaGVhZGNvdW50ID4gVUlPX01BWElPVikpIHsNCisJCQltc2cubXNnX2lvdmxlbiA9
IDE7DQorCQkJZXJyID0gc29jay0+b3BzLT5yZWN2bXNnKE5VTEwsIHNvY2ssICZtc2csDQorCQkJ
CQkJIDEsIE1TR19ET05UV0FJVCB8IE1TR19UUlVOQyk7DQorCQkJcHJfZGVidWcoIkRpc2NhcmRl
ZCByeCBwYWNrZXQ6IGxlbiAlemRcbiIsIHNvY2tfbGVuKTsNCisJCQljb250aW51ZTsNCisJCX0N
CiAJCS8qIE9LLCBub3cgd2UgbmVlZCB0byBrbm93IGFib3V0IGFkZGVkIGRlc2NyaXB0b3JzLiAq
Lw0KIAkJaWYgKCFoZWFkY291bnQpIHsNCiAJCQlpZiAodW5saWtlbHkodmhvc3RfZW5hYmxlX25v
dGlmeSgmbmV0LT5kZXYsIHZxKSkpIHsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpZGVvL2F0eS9t
YWNoNjRfYWNjZWwuYyBiL2RyaXZlcnMvdmlkZW8vYXR5L21hY2g2NF9hY2NlbC5jDQppbmRleCBl
NDU4MzNjLi4xODJiZDY4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy92aWRlby9hdHkvbWFjaDY0X2Fj
Y2VsLmMNCisrKyBiL2RyaXZlcnMvdmlkZW8vYXR5L21hY2g2NF9hY2NlbC5jDQpAQCAtNCw2ICs0
LDcgQEANCiAgKi8NCiANCiAjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4NCisjaW5jbHVkZSA8YXNt
L3VuYWxpZ25lZC5oPg0KICNpbmNsdWRlIDxsaW51eC9mYi5oPg0KICNpbmNsdWRlIDx2aWRlby9t
YWNoNjQuaD4NCiAjaW5jbHVkZSAiYXR5ZmIuaCINCkBAIC00MTksNyArNDIwLDcgQEAgdm9pZCBh
dHlmYl9pbWFnZWJsaXQoc3RydWN0IGZiX2luZm8gKmluZm8sIGNvbnN0IHN0cnVjdCBmYl9pbWFn
ZSAqaW1hZ2UpDQogCQl1MzIgKnBiaXRtYXAsIGR3b3JkcyA9IChzcmNfYnl0ZXMgKyAzKSAvIDQ7
DQogCQlmb3IgKHBiaXRtYXAgPSAodTMyKikoaW1hZ2UtPmRhdGEpOyBkd29yZHM7IGR3b3Jkcy0t
LCBwYml0bWFwKyspIHsNCiAJCQl3YWl0X2Zvcl9maWZvKDEsIHBhcik7DQotCQkJYXR5X3N0X2xl
MzIoSE9TVF9EQVRBMCwgbGUzMl90b19jcHVwKHBiaXRtYXApLCBwYXIpOw0KKwkJCWF0eV9zdF9s
ZTMyKEhPU1RfREFUQTAsIGdldF91bmFsaWduZWRfbGUzMihwYml0bWFwKSwgcGFyKTsNCiAJCX0N
CiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vYXR5L21hY2g2NF9jdXJzb3IuYyBi
L2RyaXZlcnMvdmlkZW8vYXR5L21hY2g2NF9jdXJzb3IuYw0KaW5kZXggNDZmNzJlZC4uNGI4NzMx
OCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdmlkZW8vYXR5L21hY2g2NF9jdXJzb3IuYw0KKysrIGIv
ZHJpdmVycy92aWRlby9hdHkvbWFjaDY0X2N1cnNvci5jDQpAQCAtNSw2ICs1LDcgQEANCiAjaW5j
bHVkZSA8bGludXgvZmIuaD4NCiAjaW5jbHVkZSA8bGludXgvaW5pdC5oPg0KICNpbmNsdWRlIDxs
aW51eC9zdHJpbmcuaD4NCisjaW5jbHVkZSAiLi4vZmJfZHJhdy5oIg0KIA0KICNpbmNsdWRlIDxh
c20vaW8uaD4NCiANCkBAIC0xNTcsMjQgKzE1OCwzMyBAQCBzdGF0aWMgaW50IGF0eWZiX2N1cnNv
cihzdHJ1Y3QgZmJfaW5mbyAqaW5mbywgc3RydWN0IGZiX2N1cnNvciAqY3Vyc29yKQ0KIA0KIAkg
ICAgZm9yIChpID0gMDsgaSA8IGhlaWdodDsgaSsrKSB7DQogCQlmb3IgKGogPSAwOyBqIDwgd2lk
dGg7IGorKykgew0KKwkJCXUxNiBsID0gMHhhYWFhOw0KIAkJCWIgPSAqc3JjKys7DQogCQkJbSA9
ICptc2srKzsNCiAJCQlzd2l0Y2ggKGN1cnNvci0+cm9wKSB7DQogCQkJY2FzZSBST1BfWE9SOg0K
IAkJCSAgICAvLyBVcHBlciA0IGJpdHMgb2YgbWFzayBkYXRhDQotCQkJICAgIGZiX3dyaXRlYihj
dXJzb3JfYml0c19sb29rdXBbKGIgXiBtKSA+PiA0XSwgZHN0KyspOw0KKwkJCSAgICBsID0gY3Vy
c29yX2JpdHNfbG9va3VwWyhiIF4gbSkgPj4gNF0gfA0KIAkJCSAgICAvLyBMb3dlciA0IGJpdHMg
b2YgbWFzaw0KLQkJCSAgICBmYl93cml0ZWIoY3Vyc29yX2JpdHNfbG9va3VwWyhiIF4gbSkgJiAw
eDBmXSwNCi0JCQkJICAgICAgZHN0KyspOw0KKwkJCQkgICAgKGN1cnNvcl9iaXRzX2xvb2t1cFso
YiBeIG0pICYgMHgwZl0gPDwgOCk7DQogCQkJICAgIGJyZWFrOw0KIAkJCWNhc2UgUk9QX0NPUFk6
DQogCQkJICAgIC8vIFVwcGVyIDQgYml0cyBvZiBtYXNrIGRhdGENCi0JCQkgICAgZmJfd3JpdGVi
KGN1cnNvcl9iaXRzX2xvb2t1cFsoYiAmIG0pID4+IDRdLCBkc3QrKyk7DQorCQkJICAgIGwgPSBj
dXJzb3JfYml0c19sb29rdXBbKGIgJiBtKSA+PiA0XSB8DQogCQkJICAgIC8vIExvd2VyIDQgYml0
cyBvZiBtYXNrDQotCQkJICAgIGZiX3dyaXRlYihjdXJzb3JfYml0c19sb29rdXBbKGIgJiBtKSAm
IDB4MGZdLA0KLQkJCQkgICAgICBkc3QrKyk7DQorCQkJCSAgICAoY3Vyc29yX2JpdHNfbG9va3Vw
WyhiICYgbSkgJiAweDBmXSA8PCA4KTsNCiAJCQkgICAgYnJlYWs7DQogCQkJfQ0KKwkJCS8qDQor
CQkJICogSWYgY3Vyc29yIHNpemUgaXMgbm90IGEgbXVsdGlwbGUgb2YgOCBjaGFyYWN0ZXJzDQor
CQkJICogd2UgbXVzdCBwYWQgaXQgd2l0aCB0cmFuc3BhcmVudCBwYXR0ZXJuICgweGFhYWEpLg0K
KwkJCSAqLw0KKwkJCWlmICgoaiArIDEpICogOCA+IGN1cnNvci0+aW1hZ2Uud2lkdGgpIHsNCisJ
CQkJbCA9IGNvbXAobCwgMHhhYWFhLA0KKwkJCQkgICAgKDEgPDwgKChjdXJzb3ItPmltYWdlLndp
ZHRoICYgNykgKiAyKSkgLSAxKTsNCisJCQl9DQorCQkJZmJfd3JpdGViKGwgJiAweGZmLCBkc3Qr
Kyk7DQorCQkJZmJfd3JpdGViKGwgPj4gOCwgZHN0KyspOw0KIAkJfQ0KIAkJZHN0ICs9IG9mZnNl
dDsNCiAJICAgIH0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpZGVvL2NmYmNvcHlhcmVhLmMgYi9k
cml2ZXJzL3ZpZGVvL2NmYmNvcHlhcmVhLmMNCmluZGV4IGJiNWE5NmIuLmJjYjU3MjMgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL3ZpZGVvL2NmYmNvcHlhcmVhLmMNCisrKyBiL2RyaXZlcnMvdmlkZW8v
Y2ZiY29weWFyZWEuYw0KQEAgLTQzLDEzICs0MywyMiBAQA0KICAgICAgKi8NCiANCiBzdGF0aWMg
dm9pZA0KLWJpdGNweShzdHJ1Y3QgZmJfaW5mbyAqcCwgdW5zaWduZWQgbG9uZyBfX2lvbWVtICpk
c3QsIGludCBkc3RfaWR4LA0KLQkJY29uc3QgdW5zaWduZWQgbG9uZyBfX2lvbWVtICpzcmMsIGlu
dCBzcmNfaWR4LCBpbnQgYml0cywNCitiaXRjcHkoc3RydWN0IGZiX2luZm8gKnAsIHVuc2lnbmVk
IGxvbmcgX19pb21lbSAqZHN0LCB1bnNpZ25lZCBkc3RfaWR4LA0KKwkJY29uc3QgdW5zaWduZWQg
bG9uZyBfX2lvbWVtICpzcmMsIHVuc2lnbmVkIHNyY19pZHgsIGludCBiaXRzLA0KIAkJdW5zaWdu
ZWQgbiwgdTMyIGJzd2FwbWFzaykNCiB7DQogCXVuc2lnbmVkIGxvbmcgZmlyc3QsIGxhc3Q7DQog
CWludCBjb25zdCBzaGlmdCA9IGRzdF9pZHgtc3JjX2lkeDsNCi0JaW50IGxlZnQsIHJpZ2h0Ow0K
Kw0KKyNpZiAwDQorCS8qDQorCSAqIElmIHlvdSBzdXNwZWN0IGJ1ZyBpbiB0aGlzIGZ1bmN0aW9u
LCBjb21wYXJlIGl0IHdpdGggdGhpcyBzaW1wbGUNCisJICogbWVtbW92ZSBpbXBsZW1lbnRhdGlv
bi4NCisJICovDQorCWZiX21lbW1vdmUoKGNoYXIgKilkc3QgKyAoKGRzdF9pZHggJiAoYml0cyAt
IDEpKSkgLyA4LA0KKwkJICAgKGNoYXIgKilzcmMgKyAoKHNyY19pZHggJiAoYml0cyAtIDEpKSkg
LyA4LCBuIC8gOCk7DQorCXJldHVybjsNCisjZW5kaWYNCiANCiAJZmlyc3QgPSBmYl9zaGlmdGVk
X3BpeGVsc19tYXNrX2xvbmcocCwgZHN0X2lkeCwgYnN3YXBtYXNrKTsNCiAJbGFzdCA9IH5mYl9z
aGlmdGVkX3BpeGVsc19tYXNrX2xvbmcocCwgKGRzdF9pZHgrbikgJSBiaXRzLCBic3dhcG1hc2sp
Ow0KQEAgLTk4LDkgKzEwNyw4IEBAIGJpdGNweShzdHJ1Y3QgZmJfaW5mbyAqcCwgdW5zaWduZWQg
bG9uZyBfX2lvbWVtICpkc3QsIGludCBkc3RfaWR4LA0KIAkJdW5zaWduZWQgbG9uZyBkMCwgZDE7
DQogCQlpbnQgbTsNCiANCi0JCXJpZ2h0ID0gc2hpZnQgJiAoYml0cyAtIDEpOw0KLQkJbGVmdCA9
IC1zaGlmdCAmIChiaXRzIC0gMSk7DQotCQlic3dhcG1hc2sgJj0gc2hpZnQ7DQorCQlpbnQgY29u
c3QgbGVmdCA9IHNoaWZ0ICYgKGJpdHMgLSAxKTsNCisJCWludCBjb25zdCByaWdodCA9IC1zaGlm
dCAmIChiaXRzIC0gMSk7DQogDQogCQlpZiAoZHN0X2lkeCtuIDw9IGJpdHMpIHsNCiAJCQkvLyBT
aW5nbGUgZGVzdGluYXRpb24gd29yZA0KQEAgLTExMCwxNSArMTE4LDE1IEBAIGJpdGNweShzdHJ1
Y3QgZmJfaW5mbyAqcCwgdW5zaWduZWQgbG9uZyBfX2lvbWVtICpkc3QsIGludCBkc3RfaWR4LA0K
IAkJCWQwID0gZmJfcmV2X3BpeGVsc19pbl9sb25nKGQwLCBic3dhcG1hc2spOw0KIAkJCWlmIChz
aGlmdCA+IDApIHsNCiAJCQkJLy8gU2luZ2xlIHNvdXJjZSB3b3JkDQotCQkJCWQwID4+PSByaWdo
dDsNCisJCQkJZDAgPDw9IGxlZnQ7DQogCQkJfSBlbHNlIGlmIChzcmNfaWR4K24gPD0gYml0cykg
ew0KIAkJCQkvLyBTaW5nbGUgc291cmNlIHdvcmQNCi0JCQkJZDAgPDw9IGxlZnQ7DQorCQkJCWQw
ID4+PSByaWdodDsNCiAJCQl9IGVsc2Ugew0KIAkJCQkvLyAyIHNvdXJjZSB3b3Jkcw0KIAkJCQlk
MSA9IEZCX1JFQURMKHNyYyArIDEpOw0KIAkJCQlkMSA9IGZiX3Jldl9waXhlbHNfaW5fbG9uZyhk
MSwgYnN3YXBtYXNrKTsNCi0JCQkJZDAgPSBkMDw8bGVmdCB8IGQxPj5yaWdodDsNCisJCQkJZDAg
PSBkMCA+PiByaWdodCB8IGQxIDw8IGxlZnQ7DQogCQkJfQ0KIAkJCWQwID0gZmJfcmV2X3BpeGVs
c19pbl9sb25nKGQwLCBic3dhcG1hc2spOw0KIAkJCUZCX1dSSVRFTChjb21wKGQwLCBGQl9SRUFE
TChkc3QpLCBmaXJzdCksIGRzdCk7DQpAQCAtMTM1LDYwICsxNDMsNTkgQEAgYml0Y3B5KHN0cnVj
dCBmYl9pbmZvICpwLCB1bnNpZ25lZCBsb25nIF9faW9tZW0gKmRzdCwgaW50IGRzdF9pZHgsDQog
CQkJaWYgKHNoaWZ0ID4gMCkgew0KIAkJCQkvLyBTaW5nbGUgc291cmNlIHdvcmQNCiAJCQkJZDEg
PSBkMDsNCi0JCQkJZDAgPj49IHJpZ2h0Ow0KLQkJCQlkc3QrKzsNCisJCQkJZDAgPDw9IGxlZnQ7
DQogCQkJCW4gLT0gYml0cyAtIGRzdF9pZHg7DQogCQkJfSBlbHNlIHsNCiAJCQkJLy8gMiBzb3Vy
Y2Ugd29yZHMNCiAJCQkJZDEgPSBGQl9SRUFETChzcmMrKyk7DQogCQkJCWQxID0gZmJfcmV2X3Bp
eGVsc19pbl9sb25nKGQxLCBic3dhcG1hc2spOw0KIA0KLQkJCQlkMCA9IGQwPDxsZWZ0IHwgZDE+
PnJpZ2h0Ow0KLQkJCQlkc3QrKzsNCisJCQkJZDAgPSBkMCA+PiByaWdodCB8IGQxIDw8IGxlZnQ7
DQogCQkJCW4gLT0gYml0cyAtIGRzdF9pZHg7DQogCQkJfQ0KIAkJCWQwID0gZmJfcmV2X3BpeGVs
c19pbl9sb25nKGQwLCBic3dhcG1hc2spOw0KIAkJCUZCX1dSSVRFTChjb21wKGQwLCBGQl9SRUFE
TChkc3QpLCBmaXJzdCksIGRzdCk7DQogCQkJZDAgPSBkMTsNCisJCQlkc3QrKzsNCiANCiAJCQkv
LyBNYWluIGNodW5rDQogCQkJbSA9IG4gJSBiaXRzOw0KIAkJCW4gLz0gYml0czsNCiAJCQl3aGls
ZSAoKG4gPj0gNCkgJiYgIWJzd2FwbWFzaykgew0KIAkJCQlkMSA9IEZCX1JFQURMKHNyYysrKTsN
Ci0JCQkJRkJfV1JJVEVMKGQwIDw8IGxlZnQgfCBkMSA+PiByaWdodCwgZHN0KyspOw0KKwkJCQlG
Ql9XUklURUwoZDAgPj4gcmlnaHQgfCBkMSA8PCBsZWZ0LCBkc3QrKyk7DQogCQkJCWQwID0gZDE7
DQogCQkJCWQxID0gRkJfUkVBREwoc3JjKyspOw0KLQkJCQlGQl9XUklURUwoZDAgPDwgbGVmdCB8
IGQxID4+IHJpZ2h0LCBkc3QrKyk7DQorCQkJCUZCX1dSSVRFTChkMCA+PiByaWdodCB8IGQxIDw8
IGxlZnQsIGRzdCsrKTsNCiAJCQkJZDAgPSBkMTsNCiAJCQkJZDEgPSBGQl9SRUFETChzcmMrKyk7
DQotCQkJCUZCX1dSSVRFTChkMCA8PCBsZWZ0IHwgZDEgPj4gcmlnaHQsIGRzdCsrKTsNCisJCQkJ
RkJfV1JJVEVMKGQwID4+IHJpZ2h0IHwgZDEgPDwgbGVmdCwgZHN0KyspOw0KIAkJCQlkMCA9IGQx
Ow0KIAkJCQlkMSA9IEZCX1JFQURMKHNyYysrKTsNCi0JCQkJRkJfV1JJVEVMKGQwIDw8IGxlZnQg
fCBkMSA+PiByaWdodCwgZHN0KyspOw0KKwkJCQlGQl9XUklURUwoZDAgPj4gcmlnaHQgfCBkMSA8
PCBsZWZ0LCBkc3QrKyk7DQogCQkJCWQwID0gZDE7DQogCQkJCW4gLT0gNDsNCiAJCQl9DQogCQkJ
d2hpbGUgKG4tLSkgew0KIAkJCQlkMSA9IEZCX1JFQURMKHNyYysrKTsNCiAJCQkJZDEgPSBmYl9y
ZXZfcGl4ZWxzX2luX2xvbmcoZDEsIGJzd2FwbWFzayk7DQotCQkJCWQwID0gZDAgPDwgbGVmdCB8
IGQxID4+IHJpZ2h0Ow0KKwkJCQlkMCA9IGQwID4+IHJpZ2h0IHwgZDEgPDwgbGVmdDsNCiAJCQkJ
ZDAgPSBmYl9yZXZfcGl4ZWxzX2luX2xvbmcoZDAsIGJzd2FwbWFzayk7DQogCQkJCUZCX1dSSVRF
TChkMCwgZHN0KyspOw0KIAkJCQlkMCA9IGQxOw0KIAkJCX0NCiANCiAJCQkvLyBUcmFpbGluZyBi
aXRzDQotCQkJaWYgKGxhc3QpIHsNCi0JCQkJaWYgKG0gPD0gcmlnaHQpIHsNCisJCQlpZiAobSkg
ew0KKwkJCQlpZiAobSA8PSBiaXRzIC0gcmlnaHQpIHsNCiAJCQkJCS8vIFNpbmdsZSBzb3VyY2Ug
d29yZA0KLQkJCQkJZDAgPDw9IGxlZnQ7DQorCQkJCQlkMCA+Pj0gcmlnaHQ7DQogCQkJCX0gZWxz
ZSB7DQogCQkJCQkvLyAyIHNvdXJjZSB3b3Jkcw0KIAkJCQkJZDEgPSBGQl9SRUFETChzcmMpOw0K
IAkJCQkJZDEgPSBmYl9yZXZfcGl4ZWxzX2luX2xvbmcoZDEsDQogCQkJCQkJCQlic3dhcG1hc2sp
Ow0KLQkJCQkJZDAgPSBkMDw8bGVmdCB8IGQxPj5yaWdodDsNCisJCQkJCWQwID0gZDAgPj4gcmln
aHQgfCBkMSA8PCBsZWZ0Ow0KIAkJCQl9DQogCQkJCWQwID0gZmJfcmV2X3BpeGVsc19pbl9sb25n
KGQwLCBic3dhcG1hc2spOw0KIAkJCQlGQl9XUklURUwoY29tcChkMCwgRkJfUkVBREwoZHN0KSwg
bGFzdCksIGRzdCk7DQpAQCAtMjAyLDQzICsyMDksNDYgQEAgYml0Y3B5KHN0cnVjdCBmYl9pbmZv
ICpwLCB1bnNpZ25lZCBsb25nIF9faW9tZW0gKmRzdCwgaW50IGRzdF9pZHgsDQogICAgICAqLw0K
IA0KIHN0YXRpYyB2b2lkDQotYml0Y3B5X3JldihzdHJ1Y3QgZmJfaW5mbyAqcCwgdW5zaWduZWQg
bG9uZyBfX2lvbWVtICpkc3QsIGludCBkc3RfaWR4LA0KLQkJY29uc3QgdW5zaWduZWQgbG9uZyBf
X2lvbWVtICpzcmMsIGludCBzcmNfaWR4LCBpbnQgYml0cywNCitiaXRjcHlfcmV2KHN0cnVjdCBm
Yl9pbmZvICpwLCB1bnNpZ25lZCBsb25nIF9faW9tZW0gKmRzdCwgdW5zaWduZWQgZHN0X2lkeCwN
CisJCWNvbnN0IHVuc2lnbmVkIGxvbmcgX19pb21lbSAqc3JjLCB1bnNpZ25lZCBzcmNfaWR4LCBp
bnQgYml0cywNCiAJCXVuc2lnbmVkIG4sIHUzMiBic3dhcG1hc2spDQogew0KIAl1bnNpZ25lZCBs
b25nIGZpcnN0LCBsYXN0Ow0KIAlpbnQgc2hpZnQ7DQogDQotCWRzdCArPSAobi0xKS9iaXRzOw0K
LQlzcmMgKz0gKG4tMSkvYml0czsNCi0JaWYgKChuLTEpICUgYml0cykgew0KLQkJZHN0X2lkeCAr
PSAobi0xKSAlIGJpdHM7DQotCQlkc3QgKz0gZHN0X2lkeCA+PiAoZmZzKGJpdHMpIC0gMSk7DQot
CQlkc3RfaWR4ICY9IGJpdHMgLSAxOw0KLQkJc3JjX2lkeCArPSAobi0xKSAlIGJpdHM7DQotCQlz
cmMgKz0gc3JjX2lkeCA+PiAoZmZzKGJpdHMpIC0gMSk7DQotCQlzcmNfaWR4ICY9IGJpdHMgLSAx
Ow0KLQl9DQorI2lmIDANCisJLyoNCisJICogSWYgeW91IHN1c3BlY3QgYnVnIGluIHRoaXMgZnVu
Y3Rpb24sIGNvbXBhcmUgaXQgd2l0aCB0aGlzIHNpbXBsZQ0KKwkgKiBtZW1tb3ZlIGltcGxlbWVu
dGF0aW9uLg0KKwkgKi8NCisJZmJfbWVtbW92ZSgoY2hhciAqKWRzdCArICgoZHN0X2lkeCAmIChi
aXRzIC0gMSkpKSAvIDgsDQorCQkgICAoY2hhciAqKXNyYyArICgoc3JjX2lkeCAmIChiaXRzIC0g
MSkpKSAvIDgsIG4gLyA4KTsNCisJcmV0dXJuOw0KKyNlbmRpZg0KKw0KKwlkc3QgKz0gKGRzdF9p
ZHggKyBuIC0gMSkgLyBiaXRzOw0KKwlzcmMgKz0gKHNyY19pZHggKyBuIC0gMSkgLyBiaXRzOw0K
Kwlkc3RfaWR4ID0gKGRzdF9pZHggKyBuIC0gMSkgJSBiaXRzOw0KKwlzcmNfaWR4ID0gKHNyY19p
ZHggKyBuIC0gMSkgJSBiaXRzOw0KIA0KIAlzaGlmdCA9IGRzdF9pZHgtc3JjX2lkeDsNCiANCi0J
Zmlyc3QgPSBmYl9zaGlmdGVkX3BpeGVsc19tYXNrX2xvbmcocCwgYml0cyAtIDEgLSBkc3RfaWR4
LCBic3dhcG1hc2spOw0KLQlsYXN0ID0gfmZiX3NoaWZ0ZWRfcGl4ZWxzX21hc2tfbG9uZyhwLCBi
aXRzIC0gMSAtICgoZHN0X2lkeC1uKSAlIGJpdHMpLA0KLQkJCQkJICAgIGJzd2FwbWFzayk7DQor
CWZpcnN0ID0gfmZiX3NoaWZ0ZWRfcGl4ZWxzX21hc2tfbG9uZyhwLCAoZHN0X2lkeCArIDEpICUg
Yml0cywgYnN3YXBtYXNrKTsNCisJbGFzdCA9IGZiX3NoaWZ0ZWRfcGl4ZWxzX21hc2tfbG9uZyhw
LCAoYml0cyArIGRzdF9pZHggKyAxIC0gbikgJSBiaXRzLCBic3dhcG1hc2spOw0KIA0KIAlpZiAo
IXNoaWZ0KSB7DQogCQkvLyBTYW1lIGFsaWdubWVudCBmb3Igc291cmNlIGFuZCBkZXN0DQogDQog
CQlpZiAoKHVuc2lnbmVkIGxvbmcpZHN0X2lkeCsxID49IG4pIHsNCiAJCQkvLyBTaW5nbGUgd29y
ZA0KLQkJCWlmIChsYXN0KQ0KLQkJCQlmaXJzdCAmPSBsYXN0Ow0KLQkJCUZCX1dSSVRFTCggY29t
cCggRkJfUkVBREwoc3JjKSwgRkJfUkVBREwoZHN0KSwgZmlyc3QpLCBkc3QpOw0KKwkJCWlmIChm
aXJzdCkNCisJCQkJbGFzdCAmPSBmaXJzdDsNCisJCQlGQl9XUklURUwoIGNvbXAoIEZCX1JFQURM
KHNyYyksIEZCX1JFQURMKGRzdCksIGxhc3QpLCBkc3QpOw0KIAkJfSBlbHNlIHsNCiAJCQkvLyBN
dWx0aXBsZSBkZXN0aW5hdGlvbiB3b3Jkcw0KIA0KIAkJCS8vIExlYWRpbmcgYml0cw0KLQkJCWlm
IChmaXJzdCAhPSB+MFVMKSB7DQorCQkJaWYgKGZpcnN0KSB7DQogCQkJCUZCX1dSSVRFTCggY29t
cCggRkJfUkVBREwoc3JjKSwgRkJfUkVBREwoZHN0KSwgZmlyc3QpLCBkc3QpOw0KIAkJCQlkc3Qt
LTsNCiAJCQkJc3JjLS07DQpAQCAtMjYyLDcgKzI3Miw3IEBAIGJpdGNweV9yZXYoc3RydWN0IGZi
X2luZm8gKnAsIHVuc2lnbmVkIGxvbmcgX19pb21lbSAqZHN0LCBpbnQgZHN0X2lkeCwNCiAJCQkJ
RkJfV1JJVEVMKEZCX1JFQURMKHNyYy0tKSwgZHN0LS0pOw0KIA0KIAkJCS8vIFRyYWlsaW5nIGJp
dHMNCi0JCQlpZiAobGFzdCkNCisJCQlpZiAobGFzdCAhPSAtMVVMKQ0KIAkJCQlGQl9XUklURUwo
IGNvbXAoIEZCX1JFQURMKHNyYyksIEZCX1JFQURMKGRzdCksIGxhc3QpLCBkc3QpOw0KIAkJfQ0K
IAl9IGVsc2Ugew0KQEAgLTI3MCwyOSArMjgwLDI4IEBAIGJpdGNweV9yZXYoc3RydWN0IGZiX2lu
Zm8gKnAsIHVuc2lnbmVkIGxvbmcgX19pb21lbSAqZHN0LCBpbnQgZHN0X2lkeCwNCiAJCXVuc2ln
bmVkIGxvbmcgZDAsIGQxOw0KIAkJaW50IG07DQogDQotCQlpbnQgY29uc3QgbGVmdCA9IC1zaGlm
dCAmIChiaXRzLTEpOw0KLQkJaW50IGNvbnN0IHJpZ2h0ID0gc2hpZnQgJiAoYml0cy0xKTsNCi0J
CWJzd2FwbWFzayAmPSBzaGlmdDsNCisJCWludCBjb25zdCBsZWZ0ID0gc2hpZnQgJiAoYml0cy0x
KTsNCisJCWludCBjb25zdCByaWdodCA9IC1zaGlmdCAmIChiaXRzLTEpOw0KIA0KIAkJaWYgKCh1
bnNpZ25lZCBsb25nKWRzdF9pZHgrMSA+PSBuKSB7DQogCQkJLy8gU2luZ2xlIGRlc3RpbmF0aW9u
IHdvcmQNCi0JCQlpZiAobGFzdCkNCi0JCQkJZmlyc3QgJj0gbGFzdDsNCisJCQlpZiAoZmlyc3Qp
DQorCQkJCWxhc3QgJj0gZmlyc3Q7DQogCQkJZDAgPSBGQl9SRUFETChzcmMpOw0KIAkJCWlmIChz
aGlmdCA8IDApIHsNCiAJCQkJLy8gU2luZ2xlIHNvdXJjZSB3b3JkDQotCQkJCWQwIDw8PSBsZWZ0
Ow0KKwkJCQlkMCA+Pj0gcmlnaHQ7DQogCQkJfSBlbHNlIGlmICgxKyh1bnNpZ25lZCBsb25nKXNy
Y19pZHggPj0gbikgew0KIAkJCQkvLyBTaW5nbGUgc291cmNlIHdvcmQNCi0JCQkJZDAgPj49IHJp
Z2h0Ow0KKwkJCQlkMCA8PD0gbGVmdDsNCiAJCQl9IGVsc2Ugew0KIAkJCQkvLyAyIHNvdXJjZSB3
b3Jkcw0KIAkJCQlkMSA9IEZCX1JFQURMKHNyYyAtIDEpOw0KIAkJCQlkMSA9IGZiX3Jldl9waXhl
bHNfaW5fbG9uZyhkMSwgYnN3YXBtYXNrKTsNCi0JCQkJZDAgPSBkMD4+cmlnaHQgfCBkMTw8bGVm
dDsNCisJCQkJZDAgPSBkMCA8PCBsZWZ0IHwgZDEgPj4gcmlnaHQ7DQogCQkJfQ0KIAkJCWQwID0g
ZmJfcmV2X3BpeGVsc19pbl9sb25nKGQwLCBic3dhcG1hc2spOw0KLQkJCUZCX1dSSVRFTChjb21w
KGQwLCBGQl9SRUFETChkc3QpLCBmaXJzdCksIGRzdCk7DQorCQkJRkJfV1JJVEVMKGNvbXAoZDAs
IEZCX1JFQURMKGRzdCksIGxhc3QpLCBkc3QpOw0KIAkJfSBlbHNlIHsNCiAJCQkvLyBNdWx0aXBs
ZSBkZXN0aW5hdGlvbiB3b3Jkcw0KIAkJCS8qKiBXZSBtdXN0IGFsd2F5cyByZW1lbWJlciB0aGUg
bGFzdCB2YWx1ZSByZWFkLCBiZWNhdXNlIGluIGNhc2UNCkBAIC0zMDcsMTIgKzMxNiwxMiBAQCBi
aXRjcHlfcmV2KHN0cnVjdCBmYl9pbmZvICpwLCB1bnNpZ25lZCBsb25nIF9faW9tZW0gKmRzdCwg
aW50IGRzdF9pZHgsDQogCQkJaWYgKHNoaWZ0IDwgMCkgew0KIAkJCQkvLyBTaW5nbGUgc291cmNl
IHdvcmQNCiAJCQkJZDEgPSBkMDsNCi0JCQkJZDAgPDw9IGxlZnQ7DQorCQkJCWQwID4+PSByaWdo
dDsNCiAJCQl9IGVsc2Ugew0KIAkJCQkvLyAyIHNvdXJjZSB3b3Jkcw0KIAkJCQlkMSA9IEZCX1JF
QURMKHNyYy0tKTsNCiAJCQkJZDEgPSBmYl9yZXZfcGl4ZWxzX2luX2xvbmcoZDEsIGJzd2FwbWFz
ayk7DQotCQkJCWQwID0gZDA+PnJpZ2h0IHwgZDE8PGxlZnQ7DQorCQkJCWQwID0gZDAgPDwgbGVm
dCB8IGQxID4+IHJpZ2h0Ow0KIAkJCX0NCiAJCQlkMCA9IGZiX3Jldl9waXhlbHNfaW5fbG9uZyhk
MCwgYnN3YXBtYXNrKTsNCiAJCQlGQl9XUklURUwoY29tcChkMCwgRkJfUkVBREwoZHN0KSwgZmly
c3QpLCBkc3QpOw0KQEAgLTMyNSwzOSArMzM0LDM5IEBAIGJpdGNweV9yZXYoc3RydWN0IGZiX2lu
Zm8gKnAsIHVuc2lnbmVkIGxvbmcgX19pb21lbSAqZHN0LCBpbnQgZHN0X2lkeCwNCiAJCQluIC89
IGJpdHM7DQogCQkJd2hpbGUgKChuID49IDQpICYmICFic3dhcG1hc2spIHsNCiAJCQkJZDEgPSBG
Ql9SRUFETChzcmMtLSk7DQotCQkJCUZCX1dSSVRFTChkMCA+PiByaWdodCB8IGQxIDw8IGxlZnQs
IGRzdC0tKTsNCisJCQkJRkJfV1JJVEVMKGQwIDw8IGxlZnQgfCBkMSA+PiByaWdodCwgZHN0LS0p
Ow0KIAkJCQlkMCA9IGQxOw0KIAkJCQlkMSA9IEZCX1JFQURMKHNyYy0tKTsNCi0JCQkJRkJfV1JJ
VEVMKGQwID4+IHJpZ2h0IHwgZDEgPDwgbGVmdCwgZHN0LS0pOw0KKwkJCQlGQl9XUklURUwoZDAg
PDwgbGVmdCB8IGQxID4+IHJpZ2h0LCBkc3QtLSk7DQogCQkJCWQwID0gZDE7DQogCQkJCWQxID0g
RkJfUkVBREwoc3JjLS0pOw0KLQkJCQlGQl9XUklURUwoZDAgPj4gcmlnaHQgfCBkMSA8PCBsZWZ0
LCBkc3QtLSk7DQorCQkJCUZCX1dSSVRFTChkMCA8PCBsZWZ0IHwgZDEgPj4gcmlnaHQsIGRzdC0t
KTsNCiAJCQkJZDAgPSBkMTsNCiAJCQkJZDEgPSBGQl9SRUFETChzcmMtLSk7DQotCQkJCUZCX1dS
SVRFTChkMCA+PiByaWdodCB8IGQxIDw8IGxlZnQsIGRzdC0tKTsNCisJCQkJRkJfV1JJVEVMKGQw
IDw8IGxlZnQgfCBkMSA+PiByaWdodCwgZHN0LS0pOw0KIAkJCQlkMCA9IGQxOw0KIAkJCQluIC09
IDQ7DQogCQkJfQ0KIAkJCXdoaWxlIChuLS0pIHsNCiAJCQkJZDEgPSBGQl9SRUFETChzcmMtLSk7
DQogCQkJCWQxID0gZmJfcmV2X3BpeGVsc19pbl9sb25nKGQxLCBic3dhcG1hc2spOw0KLQkJCQlk
MCA9IGQwID4+IHJpZ2h0IHwgZDEgPDwgbGVmdDsNCisJCQkJZDAgPSBkMCA8PCBsZWZ0IHwgZDEg
Pj4gcmlnaHQ7DQogCQkJCWQwID0gZmJfcmV2X3BpeGVsc19pbl9sb25nKGQwLCBic3dhcG1hc2sp
Ow0KIAkJCQlGQl9XUklURUwoZDAsIGRzdC0tKTsNCiAJCQkJZDAgPSBkMTsNCiAJCQl9DQogDQog
CQkJLy8gVHJhaWxpbmcgYml0cw0KLQkJCWlmIChsYXN0KSB7DQotCQkJCWlmIChtIDw9IGxlZnQp
IHsNCisJCQlpZiAobSkgew0KKwkJCQlpZiAobSA8PSBiaXRzIC0gbGVmdCkgew0KIAkJCQkJLy8g
U2luZ2xlIHNvdXJjZSB3b3JkDQotCQkJCQlkMCA+Pj0gcmlnaHQ7DQorCQkJCQlkMCA8PD0gbGVm
dDsNCiAJCQkJfSBlbHNlIHsNCiAJCQkJCS8vIDIgc291cmNlIHdvcmRzDQogCQkJCQlkMSA9IEZC
X1JFQURMKHNyYyk7DQogCQkJCQlkMSA9IGZiX3Jldl9waXhlbHNfaW5fbG9uZyhkMSwNCiAJCQkJ
CQkJCWJzd2FwbWFzayk7DQotCQkJCQlkMCA9IGQwPj5yaWdodCB8IGQxPDxsZWZ0Ow0KKwkJCQkJ
ZDAgPSBkMCA8PCBsZWZ0IHwgZDEgPj4gcmlnaHQ7DQogCQkJCX0NCiAJCQkJZDAgPSBmYl9yZXZf
cGl4ZWxzX2luX2xvbmcoZDAsIGJzd2FwbWFzayk7DQogCQkJCUZCX1dSSVRFTChjb21wKGQwLCBG
Ql9SRUFETChkc3QpLCBsYXN0KSwgZHN0KTsNCkBAIC0zNzEsOSArMzgwLDkgQEAgdm9pZCBjZmJf
Y29weWFyZWEoc3RydWN0IGZiX2luZm8gKnAsIGNvbnN0IHN0cnVjdCBmYl9jb3B5YXJlYSAqYXJl
YSkNCiAJdTMyIGR4ID0gYXJlYS0+ZHgsIGR5ID0gYXJlYS0+ZHksIHN4ID0gYXJlYS0+c3gsIHN5
ID0gYXJlYS0+c3k7DQogCXUzMiBoZWlnaHQgPSBhcmVhLT5oZWlnaHQsIHdpZHRoID0gYXJlYS0+
d2lkdGg7DQogCXVuc2lnbmVkIGxvbmcgY29uc3QgYml0c19wZXJfbGluZSA9IHAtPmZpeC5saW5l
X2xlbmd0aCo4dTsNCi0JdW5zaWduZWQgbG9uZyBfX2lvbWVtICpkc3QgPSBOVUxMLCAqc3JjID0g
TlVMTDsNCisJdW5zaWduZWQgbG9uZyBfX2lvbWVtICpiYXNlID0gTlVMTDsNCiAJaW50IGJpdHMg
PSBCSVRTX1BFUl9MT05HLCBieXRlcyA9IGJpdHMgPj4gMzsNCi0JaW50IGRzdF9pZHggPSAwLCBz
cmNfaWR4ID0gMCwgcmV2X2NvcHkgPSAwOw0KKwl1bnNpZ25lZCBkc3RfaWR4ID0gMCwgc3JjX2lk
eCA9IDAsIHJldl9jb3B5ID0gMDsNCiAJdTMyIGJzd2FwbWFzayA9IGZiX2NvbXB1dGVfYnN3YXBt
YXNrKHApOw0KIA0KIAlpZiAocC0+c3RhdGUgIT0gRkJJTkZPX1NUQVRFX1JVTk5JTkcpDQpAQCAt
Mzg5LDcgKzM5OCw3IEBAIHZvaWQgY2ZiX2NvcHlhcmVhKHN0cnVjdCBmYl9pbmZvICpwLCBjb25z
dCBzdHJ1Y3QgZmJfY29weWFyZWEgKmFyZWEpDQogDQogCS8vIHNwbGl0IHRoZSBiYXNlIG9mIHRo
ZSBmcmFtZWJ1ZmZlciBpbnRvIGEgbG9uZy1hbGlnbmVkIGFkZHJlc3MgYW5kIHRoZQ0KIAkvLyBp
bmRleCBvZiB0aGUgZmlyc3QgYml0DQotCWRzdCA9IHNyYyA9ICh1bnNpZ25lZCBsb25nIF9faW9t
ZW0gKikoKHVuc2lnbmVkIGxvbmcpcC0+c2NyZWVuX2Jhc2UgJiB+KGJ5dGVzLTEpKTsNCisJYmFz
ZSA9ICh1bnNpZ25lZCBsb25nIF9faW9tZW0gKikoKHVuc2lnbmVkIGxvbmcpcC0+c2NyZWVuX2Jh
c2UgJiB+KGJ5dGVzLTEpKTsNCiAJZHN0X2lkeCA9IHNyY19pZHggPSA4KigodW5zaWduZWQgbG9u
ZylwLT5zY3JlZW5fYmFzZSAmIChieXRlcy0xKSk7DQogCS8vIGFkZCBvZmZzZXQgb2Ygc291cmNl
IGFuZCB0YXJnZXQgYXJlYQ0KIAlkc3RfaWR4ICs9IGR5KmJpdHNfcGVyX2xpbmUgKyBkeCpwLT52
YXIuYml0c19wZXJfcGl4ZWw7DQpAQCAtNDAyLDIwICs0MTEsMTQgQEAgdm9pZCBjZmJfY29weWFy
ZWEoc3RydWN0IGZiX2luZm8gKnAsIGNvbnN0IHN0cnVjdCBmYl9jb3B5YXJlYSAqYXJlYSkNCiAJ
CXdoaWxlIChoZWlnaHQtLSkgew0KIAkJCWRzdF9pZHggLT0gYml0c19wZXJfbGluZTsNCiAJCQlz
cmNfaWR4IC09IGJpdHNfcGVyX2xpbmU7DQotCQkJZHN0ICs9IGRzdF9pZHggPj4gKGZmcyhiaXRz
KSAtIDEpOw0KLQkJCWRzdF9pZHggJj0gKGJ5dGVzIC0gMSk7DQotCQkJc3JjICs9IHNyY19pZHgg
Pj4gKGZmcyhiaXRzKSAtIDEpOw0KLQkJCXNyY19pZHggJj0gKGJ5dGVzIC0gMSk7DQotCQkJYml0
Y3B5X3JldihwLCBkc3QsIGRzdF9pZHgsIHNyYywgc3JjX2lkeCwgYml0cywNCisJCQliaXRjcHlf
cmV2KHAsIGJhc2UgKyAoZHN0X2lkeCAvIGJpdHMpLCBkc3RfaWR4ICUgYml0cywNCisJCQkJYmFz
ZSArIChzcmNfaWR4IC8gYml0cyksIHNyY19pZHggJSBiaXRzLCBiaXRzLA0KIAkJCQl3aWR0aCpw
LT52YXIuYml0c19wZXJfcGl4ZWwsIGJzd2FwbWFzayk7DQogCQl9DQogCX0gZWxzZSB7DQogCQl3
aGlsZSAoaGVpZ2h0LS0pIHsNCi0JCQlkc3QgKz0gZHN0X2lkeCA+PiAoZmZzKGJpdHMpIC0gMSk7
DQotCQkJZHN0X2lkeCAmPSAoYnl0ZXMgLSAxKTsNCi0JCQlzcmMgKz0gc3JjX2lkeCA+PiAoZmZz
KGJpdHMpIC0gMSk7DQotCQkJc3JjX2lkeCAmPSAoYnl0ZXMgLSAxKTsNCi0JCQliaXRjcHkocCwg
ZHN0LCBkc3RfaWR4LCBzcmMsIHNyY19pZHgsIGJpdHMsDQorCQkJYml0Y3B5KHAsIGJhc2UgKyAo
ZHN0X2lkeCAvIGJpdHMpLCBkc3RfaWR4ICUgYml0cywNCisJCQkJYmFzZSArIChzcmNfaWR4IC8g
Yml0cyksIHNyY19pZHggJSBiaXRzLCBiaXRzLA0KIAkJCQl3aWR0aCpwLT52YXIuYml0c19wZXJf
cGl4ZWwsIGJzd2FwbWFzayk7DQogCQkJZHN0X2lkeCArPSBiaXRzX3Blcl9saW5lOw0KIAkJCXNy
Y19pZHggKz0gYml0c19wZXJfbGluZTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpZGVvL21hdHJv
eC9tYXRyb3hmYl9hY2NlbC5jIGIvZHJpdmVycy92aWRlby9tYXRyb3gvbWF0cm94ZmJfYWNjZWwu
Yw0KaW5kZXggODMzNWE2Zi4uMGQ1Y2I4NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdmlkZW8vbWF0
cm94L21hdHJveGZiX2FjY2VsLmMNCisrKyBiL2RyaXZlcnMvdmlkZW8vbWF0cm94L21hdHJveGZi
X2FjY2VsLmMNCkBAIC0xOTIsMTAgKzE5MiwxOCBAQCB2b2lkIG1hdHJveF9jZmJYX2luaXQoc3Ry
dWN0IG1hdHJveF9mYl9pbmZvICptaW5mbykNCiAJbWluZm8tPmFjY2VsLm1fZHdnX3JlY3QgPSBN
X0RXR19UUkFQIHwgTV9EV0dfU09MSUQgfCBNX0RXR19BUlpFUk8gfCBNX0RXR19TR05aRVJPIHwg
TV9EV0dfU0hJRlRaRVJPOw0KIAlpZiAoaXNNaWxsZW5pdW1JSShtaW5mbykpIG1pbmZvLT5hY2Nl
bC5tX2R3Z19yZWN0IHw9IE1fRFdHX1RSQU5TQzsNCiAJbWluZm8tPmFjY2VsLm1fb3Btb2RlID0g
bW9wbW9kZTsNCisJbWluZm8tPmFjY2VsLm1fYWNjZXNzID0gbWFjY2VzczsNCisJbWluZm8tPmFj
Y2VsLm1fcGl0Y2ggPSBtcGl0Y2g7DQogfQ0KIA0KIEVYUE9SVF9TWU1CT0wobWF0cm94X2NmYlhf
aW5pdCk7DQogDQorc3RhdGljIHZvaWQgbWF0cm94X2FjY2VsX3Jlc3RvcmVfbWFjY2VzcyhzdHJ1
Y3QgbWF0cm94X2ZiX2luZm8gKm1pbmZvKQ0KK3sNCisJbWdhX291dGwoTV9NQUNDRVNTLCBtaW5m
by0+YWNjZWwubV9hY2Nlc3MpOw0KKwltZ2Ffb3V0bChNX1BJVENILCBtaW5mby0+YWNjZWwubV9w
aXRjaCk7DQorfQ0KKw0KIHN0YXRpYyB2b2lkIG1hdHJveF9hY2NlbF9ibW92ZShzdHJ1Y3QgbWF0
cm94X2ZiX2luZm8gKm1pbmZvLCBpbnQgdnhyZXMsIGludCBzeSwNCiAJCQkgICAgICAgaW50IHN4
LCBpbnQgZHksIGludCBkeCwgaW50IGhlaWdodCwgaW50IHdpZHRoKQ0KIHsNCkBAIC0yMDcsNyAr
MjE1LDggQEAgc3RhdGljIHZvaWQgbWF0cm94X2FjY2VsX2Jtb3ZlKHN0cnVjdCBtYXRyb3hfZmJf
aW5mbyAqbWluZm8sIGludCB2eHJlcywgaW50IHN5LA0KIAlDUklUQkVHSU4NCiANCiAJaWYgKChk
eSA8IHN5KSB8fCAoKGR5ID09IHN5KSAmJiAoZHggPD0gc3gpKSkgew0KLQkJbWdhX2ZpZm8oMik7
DQorCQltZ2FfZmlmbyg0KTsNCisJCW1hdHJveF9hY2NlbF9yZXN0b3JlX21hY2Nlc3MobWluZm8p
Ow0KIAkJbWdhX291dGwoTV9EV0dDVEwsIE1fRFdHX0JJVEJMVCB8IE1fRFdHX1NISUZUWkVSTyB8
IE1fRFdHX1NHTlpFUk8gfA0KIAkJCSBNX0RXR19CRkNPTCB8IE1fRFdHX1JFUExBQ0UpOw0KIAkJ
bWdhX291dGwoTV9BUjUsIHZ4cmVzKTsNCkBAIC0yMTUsNyArMjI0LDggQEAgc3RhdGljIHZvaWQg
bWF0cm94X2FjY2VsX2Jtb3ZlKHN0cnVjdCBtYXRyb3hfZmJfaW5mbyAqbWluZm8sIGludCB2eHJl
cywgaW50IHN5LA0KIAkJc3RhcnQgPSBzeSp2eHJlcytzeCtjdXJyX3lkc3RvcmcobWluZm8pOw0K
IAkJZW5kID0gc3RhcnQrd2lkdGg7DQogCX0gZWxzZSB7DQotCQltZ2FfZmlmbygzKTsNCisJCW1n
YV9maWZvKDUpOw0KKwkJbWF0cm94X2FjY2VsX3Jlc3RvcmVfbWFjY2VzcyhtaW5mbyk7DQogCQlt
Z2Ffb3V0bChNX0RXR0NUTCwgTV9EV0dfQklUQkxUIHwgTV9EV0dfU0hJRlRaRVJPIHwgTV9EV0df
QkZDT0wgfCBNX0RXR19SRVBMQUNFKTsNCiAJCW1nYV9vdXRsKE1fU0dOLCA1KTsNCiAJCW1nYV9v
dXRsKE1fQVI1LCAtdnhyZXMpOw0KQEAgLTIyNCw3ICsyMzQsOCBAQCBzdGF0aWMgdm9pZCBtYXRy
b3hfYWNjZWxfYm1vdmUoc3RydWN0IG1hdHJveF9mYl9pbmZvICptaW5mbywgaW50IHZ4cmVzLCBp
bnQgc3ksDQogCQlzdGFydCA9IGVuZCt3aWR0aDsNCiAJCWR5ICs9IGhlaWdodC0xOw0KIAl9DQot
CW1nYV9maWZvKDQpOw0KKwltZ2FfZmlmbyg2KTsNCisJbWF0cm94X2FjY2VsX3Jlc3RvcmVfbWFj
Y2VzcyhtaW5mbyk7DQogCW1nYV9vdXRsKE1fQVIwLCBlbmQpOw0KIAltZ2Ffb3V0bChNX0FSMywg
c3RhcnQpOw0KIAltZ2Ffb3V0bChNX0ZYQk5EUlksICgoZHgrd2lkdGgpPDwxNikgfCBkeCk7DQpA
QCAtMjQ2LDcgKzI1Nyw4IEBAIHN0YXRpYyB2b2lkIG1hdHJveF9hY2NlbF9ibW92ZV9saW4oc3Ry
dWN0IG1hdHJveF9mYl9pbmZvICptaW5mbywgaW50IHZ4cmVzLA0KIAlDUklUQkVHSU4NCiANCiAJ
aWYgKChkeSA8IHN5KSB8fCAoKGR5ID09IHN5KSAmJiAoZHggPD0gc3gpKSkgew0KLQkJbWdhX2Zp
Zm8oMik7DQorCQltZ2FfZmlmbyg0KTsNCisJCW1hdHJveF9hY2NlbF9yZXN0b3JlX21hY2Nlc3Mo
bWluZm8pOw0KIAkJbWdhX291dGwoTV9EV0dDVEwsIE1fRFdHX0JJVEJMVCB8IE1fRFdHX1NISUZU
WkVSTyB8IE1fRFdHX1NHTlpFUk8gfA0KIAkJCU1fRFdHX0JGQ09MIHwgTV9EV0dfUkVQTEFDRSk7
DQogCQltZ2Ffb3V0bChNX0FSNSwgdnhyZXMpOw0KQEAgLTI1NCw3ICsyNjYsOCBAQCBzdGF0aWMg
dm9pZCBtYXRyb3hfYWNjZWxfYm1vdmVfbGluKHN0cnVjdCBtYXRyb3hfZmJfaW5mbyAqbWluZm8s
IGludCB2eHJlcywNCiAJCXN0YXJ0ID0gc3kqdnhyZXMrc3grY3Vycl95ZHN0b3JnKG1pbmZvKTsN
CiAJCWVuZCA9IHN0YXJ0K3dpZHRoOw0KIAl9IGVsc2Ugew0KLQkJbWdhX2ZpZm8oMyk7DQorCQlt
Z2FfZmlmbyg1KTsNCisJCW1hdHJveF9hY2NlbF9yZXN0b3JlX21hY2Nlc3MobWluZm8pOw0KIAkJ
bWdhX291dGwoTV9EV0dDVEwsIE1fRFdHX0JJVEJMVCB8IE1fRFdHX1NISUZUWkVSTyB8IE1fRFdH
X0JGQ09MIHwgTV9EV0dfUkVQTEFDRSk7DQogCQltZ2Ffb3V0bChNX1NHTiwgNSk7DQogCQltZ2Ff
b3V0bChNX0FSNSwgLXZ4cmVzKTsNCkBAIC0yNjMsNyArMjc2LDggQEAgc3RhdGljIHZvaWQgbWF0
cm94X2FjY2VsX2Jtb3ZlX2xpbihzdHJ1Y3QgbWF0cm94X2ZiX2luZm8gKm1pbmZvLCBpbnQgdnhy
ZXMsDQogCQlzdGFydCA9IGVuZCt3aWR0aDsNCiAJCWR5ICs9IGhlaWdodC0xOw0KIAl9DQotCW1n
YV9maWZvKDUpOw0KKwltZ2FfZmlmbyg3KTsNCisJbWF0cm94X2FjY2VsX3Jlc3RvcmVfbWFjY2Vz
cyhtaW5mbyk7DQogCW1nYV9vdXRsKE1fQVIwLCBlbmQpOw0KIAltZ2Ffb3V0bChNX0FSMywgc3Rh
cnQpOw0KIAltZ2Ffb3V0bChNX0ZYQk5EUlksICgoZHgrd2lkdGgpPDwxNikgfCBkeCk7DQpAQCAt
Mjk4LDcgKzMxMiw4IEBAIHN0YXRpYyB2b2lkIG1hdHJveGZiX2FjY2VsX2NsZWFyKHN0cnVjdCBt
YXRyb3hfZmJfaW5mbyAqbWluZm8sIHVfaW50MzJfdCBjb2xvciwNCiANCiAJQ1JJVEJFR0lODQog
DQotCW1nYV9maWZvKDUpOw0KKwltZ2FfZmlmbyg3KTsNCisJbWF0cm94X2FjY2VsX3Jlc3RvcmVf
bWFjY2VzcyhtaW5mbyk7DQogCW1nYV9vdXRsKE1fRFdHQ1RMLCBtaW5mby0+YWNjZWwubV9kd2df
cmVjdCB8IE1fRFdHX1JFUExBQ0UpOw0KIAltZ2Ffb3V0bChNX0ZDT0wsIGNvbG9yKTsNCiAJbWdh
X291dGwoTV9GWEJORFJZLCAoKHN4ICsgd2lkdGgpIDw8IDE2KSB8IHN4KTsNCkBAIC0zNDEsNyAr
MzU2LDggQEAgc3RhdGljIHZvaWQgbWF0cm94ZmJfY2ZiNF9jbGVhcihzdHJ1Y3QgbWF0cm94X2Zi
X2luZm8gKm1pbmZvLCB1X2ludDMyX3QgYmd4LA0KIAl3aWR0aCA+Pj0gMTsNCiAJc3ggPj49IDE7
DQogCWlmICh3aWR0aCkgew0KLQkJbWdhX2ZpZm8oNSk7DQorCQltZ2FfZmlmbyg3KTsNCisJCW1h
dHJveF9hY2NlbF9yZXN0b3JlX21hY2Nlc3MobWluZm8pOw0KIAkJbWdhX291dGwoTV9EV0dDVEws
IG1pbmZvLT5hY2NlbC5tX2R3Z19yZWN0IHwgTV9EV0dfUkVQTEFDRTIpOw0KIAkJbWdhX291dGwo
TV9GQ09MLCBiZ3gpOw0KIAkJbWdhX291dGwoTV9GWEJORFJZLCAoKHN4ICsgd2lkdGgpIDw8IDE2
KSB8IHN4KTsNCkBAIC00MTUsNyArNDMxLDggQEAgc3RhdGljIHZvaWQgbWF0cm94ZmJfMWJwcF9p
bWFnZWJsaXQoc3RydWN0IG1hdHJveF9mYl9pbmZvICptaW5mbywgdV9pbnQzMl90IGZneCwNCiAN
CiAJQ1JJVEJFR0lODQogDQotCW1nYV9maWZvKDMpOw0KKwltZ2FfZmlmbyg1KTsNCisJbWF0cm94
X2FjY2VsX3Jlc3RvcmVfbWFjY2VzcyhtaW5mbyk7DQogCWlmIChlYXN5KQ0KIAkJbWdhX291dGwo
TV9EV0dDVEwsIE1fRFdHX0lMT0FEIHwgTV9EV0dfU0dOWkVSTyB8IE1fRFdHX1NISUZUWkVSTyB8
IE1fRFdHX0JNT05PV0YgfCBNX0RXR19MSU5FQVIgfCBNX0RXR19SRVBMQUNFKTsNCiAJZWxzZQ0K
QEAgLTQyNSw3ICs0NDIsOCBAQCBzdGF0aWMgdm9pZCBtYXRyb3hmYl8xYnBwX2ltYWdlYmxpdChz
dHJ1Y3QgbWF0cm94X2ZiX2luZm8gKm1pbmZvLCB1X2ludDMyX3QgZmd4LA0KIAlmeGJuZHJ5ID0g
KCh4eCArIHdpZHRoIC0gMSkgPDwgMTYpIHwgeHg7DQogCW1taW8gPSBtaW5mby0+bW1pby52YmFz
ZTsNCiANCi0JbWdhX2ZpZm8oNik7DQorCW1nYV9maWZvKDgpOw0KKwltYXRyb3hfYWNjZWxfcmVz
dG9yZV9tYWNjZXNzKG1pbmZvKTsNCiAJbWdhX3dyaXRlbChtbWlvLCBNX0ZYQk5EUlksIGZ4Ym5k
cnkpOw0KIAltZ2Ffd3JpdGVsKG1taW8sIE1fQVIwLCBhcjApOw0KIAltZ2Ffd3JpdGVsKG1taW8s
IE1fQVIzLCAwKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpZGVvL21hdHJveC9tYXRyb3hmYl9i
YXNlLmggYi9kcml2ZXJzL3ZpZGVvL21hdHJveC9tYXRyb3hmYl9iYXNlLmgNCmluZGV4IDExZWQ1
N2IuLjU1NmQ5NmMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3ZpZGVvL21hdHJveC9tYXRyb3hmYl9i
YXNlLmgNCisrKyBiL2RyaXZlcnMvdmlkZW8vbWF0cm94L21hdHJveGZiX2Jhc2UuaA0KQEAgLTMw
Nyw2ICszMDcsOCBAQCBzdHJ1Y3QgbWF0cm94X2FjY2VsX2RhdGEgew0KICNlbmRpZg0KIAl1X2lu
dDMyX3QJbV9kd2dfcmVjdDsNCiAJdV9pbnQzMl90CW1fb3Btb2RlOw0KKwl1X2ludDMyX3QJbV9h
Y2Nlc3M7DQorCXVfaW50MzJfdAltX3BpdGNoOw0KIH07DQogDQogc3RydWN0IHY0bDJfcXVlcnlj
dHJsOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vdGdhZmIuYyBiL2RyaXZlcnMvdmlkZW8v
dGdhZmIuYw0KaW5kZXggYWJhNzY4Ni4uYWMyY2Y2ZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdmlk
ZW8vdGdhZmIuYw0KKysrIGIvZHJpdmVycy92aWRlby90Z2FmYi5jDQpAQCAtMTE0NiwyMjIgKzEx
NDYsNTcgQEAgY29weWFyZWFfbGluZV8zMmJwcChzdHJ1Y3QgZmJfaW5mbyAqaW5mbywgdTMyIGR5
LCB1MzIgc3ksDQogCV9fcmF3X3dyaXRlbChUR0FfTU9ERV9TQk1fMjRCUFB8VEdBX01PREVfU0lN
UExFLCB0Z2FfcmVncytUR0FfTU9ERV9SRUcpOw0KIH0NCiANCi0vKiBUaGUgZ2VuZXJhbCBjYXNl
IG9mIGZvcndhcmQgY29weSBpbiA4YnBwIG1vZGUuICAqLw0KKy8qIFRoZSAoYWxtb3N0KSBnZW5l
cmFsIGNhc2Ugb2YgYmFja3dhcmQgY29weSBpbiA4YnBwIG1vZGUuICAqLw0KIHN0YXRpYyBpbmxp
bmUgdm9pZA0KLWNvcHlhcmVhX2ZvcmV3YXJkXzhicHAoc3RydWN0IGZiX2luZm8gKmluZm8sIHUz
MiBkeCwgdTMyIGR5LCB1MzIgc3gsIHUzMiBzeSwNCi0JCSAgICAgICB1MzIgaGVpZ2h0LCB1MzIg
d2lkdGgsIHUzMiBsaW5lX2xlbmd0aCkNCitjb3B5YXJlYV84YnBwKHN0cnVjdCBmYl9pbmZvICpp
bmZvLCB1MzIgZHgsIHUzMiBkeSwgdTMyIHN4LCB1MzIgc3ksDQorCSAgICAgIHUzMiBoZWlnaHQs
IHUzMiB3aWR0aCwgdTMyIGxpbmVfbGVuZ3RoLA0KKwkgICAgICBjb25zdCBzdHJ1Y3QgZmJfY29w
eWFyZWEgKmFyZWEpDQogew0KIAlzdHJ1Y3QgdGdhX3BhciAqcGFyID0gKHN0cnVjdCB0Z2FfcGFy
ICopIGluZm8tPnBhcjsNCi0JdW5zaWduZWQgbG9uZyBpLCBjb3BpZWQsIGxlZnQ7DQotCXVuc2ln
bmVkIGxvbmcgZHBvcywgc3BvcywgZGFsaWduLCBzYWxpZ24sIHlpbmNyOw0KLQl1MzIgc21hc2tf
Zmlyc3QsIGRtYXNrX2ZpcnN0LCBkbWFza19sYXN0Ow0KLQlpbnQgcGl4ZWxfc2hpZnQsIG5lZWRf
cHJpbWUsIG5lZWRfc2Vjb25kOw0KLQl1bnNpZ25lZCBsb25nIG42NCwgbjMyLCB4aW5jcl9maXJz
dDsNCisJdW5zaWduZWQgaSwgeWluY3I7DQorCWludCBkZXBvcywgc2Vwb3MsIGJhY2t3YXJkLCBs
YXN0X3N0ZXAsIHN0ZXA7DQorCXUzMiBtYXNrX2xhc3Q7DQorCXVuc2lnbmVkIG4zMjsNCiAJdm9p
ZCBfX2lvbWVtICp0Z2FfcmVnczsNCiAJdm9pZCBfX2lvbWVtICp0Z2FfZmI7DQogDQotCXlpbmNy
ID0gbGluZV9sZW5ndGg7DQotCWlmIChkeSA+IHN5KSB7DQotCQlkeSArPSBoZWlnaHQgLSAxOw0K
LQkJc3kgKz0gaGVpZ2h0IC0gMTsNCi0JCXlpbmNyID0gLXlpbmNyOw0KLQl9DQotDQotCS8qIENv
bXB1dGUgdGhlIG9mZnNldHMgYW5kIGFsaWdubWVudHMgaW4gdGhlIGZyYW1lIGJ1ZmZlci4NCi0J
ICAgTW9yZSB0aGFuIGFueXRoaW5nIGVsc2UsIHRoZXNlIGNvbnRyb2wgaG93IHdlIGRvIGNvcGll
cy4gICovDQotCWRwb3MgPSBkeSAqIGxpbmVfbGVuZ3RoICsgZHg7DQotCXNwb3MgPSBzeSAqIGxp
bmVfbGVuZ3RoICsgc3g7DQotCWRhbGlnbiA9IGRwb3MgJiA3Ow0KLQlzYWxpZ24gPSBzcG9zICYg
NzsNCi0JZHBvcyAmPSAtODsNCi0Jc3BvcyAmPSAtODsNCi0NCi0JLyogQ29tcHV0ZSB0aGUgdmFs
dWUgZm9yIHRoZSBQSVhFTFNISUZUIHJlZ2lzdGVyLiAgVGhpcyBjb250cm9scw0KLQkgICBib3Ro
IG5vbi1jby1hbGlnbmVkIHNvdXJjZSBhbmQgZGVzdGluYXRpb24gYW5kIGNvcHkgZGlyZWN0aW9u
LiAgKi8NCi0JaWYgKGRhbGlnbiA+PSBzYWxpZ24pDQotCQlwaXhlbF9zaGlmdCA9IGRhbGlnbiAt
IHNhbGlnbjsNCi0JZWxzZQ0KLQkJcGl4ZWxfc2hpZnQgPSA4IC0gKHNhbGlnbiAtIGRhbGlnbik7
DQotDQotCS8qIEZpZ3VyZSBvdXQgaWYgd2UgbmVlZCBhbiBhZGRpdGlvbmFsIHByaW1pbmcgc3Rl
cCBmb3IgdGhlDQotCSAgIHJlc2lkdWUgcmVnaXN0ZXIuICAqLw0KLQluZWVkX3ByaW1lID0gKHNh
bGlnbiA+IGRhbGlnbik7DQotCWlmIChuZWVkX3ByaW1lKQ0KLQkJZHBvcyAtPSA4Ow0KLQ0KLQkv
KiBCZWdpbiBieSBjb3B5aW5nIHRoZSBsZWFkaW5nIHVuYWxpZ25lZCBkZXN0aW5hdGlvbi4gIENv
cHkgZW5vdWdoDQotCSAgIHRvIG1ha2UgdGhlIG5leHQgZGVzdGluYXRpb24gYWRkcmVzcyAzMi1i
eXRlIGFsaWduZWQuICAqLw0KLQljb3BpZWQgPSAzMiAtIChkYWxpZ24gKyAoZHBvcyAmIDMxKSk7
DQotCWlmIChjb3BpZWQgPT0gMzIpDQotCQljb3BpZWQgPSAwOw0KLQl4aW5jcl9maXJzdCA9IChj
b3BpZWQgKyA3KSAmIC04Ow0KLQlzbWFza19maXJzdCA9IGRtYXNrX2ZpcnN0ID0gKDF1bCA8PCBj
b3BpZWQpIC0gMTsNCi0Jc21hc2tfZmlyc3QgPDw9IHNhbGlnbjsNCi0JZG1hc2tfZmlyc3QgPDw9
IGRhbGlnbiArIG5lZWRfcHJpbWUqODsNCi0JaWYgKG5lZWRfcHJpbWUgJiYgY29waWVkID4gMjQp
DQotCQljb3BpZWQgLT0gODsNCi0JbGVmdCA9IHdpZHRoIC0gY29waWVkOw0KLQ0KLQkvKiBDYXJl
IGZvciBzbWFsbCBjb3BpZXMuICAqLw0KLQlpZiAoY29waWVkID4gd2lkdGgpIHsNCi0JCXUzMiB0
Ow0KLQkJdCA9ICgxdWwgPDwgd2lkdGgpIC0gMTsNCi0JCXQgPDw9IGRhbGlnbiArIG5lZWRfcHJp
bWUqODsNCi0JCWRtYXNrX2ZpcnN0ICY9IHQ7DQotCQlsZWZ0ID0gMDsNCi0JfQ0KLQ0KLQkvKiBB
dHRlbXB0IHRvIHVzZSA2NC1ieXRlIGNvcGllcy4gIFRoaXMgaXMgb25seSBwb3NzaWJsZSBpZiB0
aGUNCi0JICAgc291cmNlIGFuZCBkZXN0aW5hdGlvbiBhcmUgY28tYWxpZ25lZCBhdCA2NCBieXRl
cy4gICovDQotCW42NCA9IG5lZWRfc2Vjb25kID0gMDsNCi0JaWYgKChkcG9zICYgNjMpID09IChz
cG9zICYgNjMpDQotCSAgICAmJiAoaGVpZ2h0ID09IDEgfHwgbGluZV9sZW5ndGggJSA2NCA9PSAw
KSkgew0KLQkJLyogV2UgbWF5IG5lZWQgYSAzMi1ieXRlIGNvcHkgdG8gZW5zdXJlIDY0IGJ5dGUg
YWxpZ25tZW50LiAgKi8NCi0JCW5lZWRfc2Vjb25kID0gKGRwb3MgKyB4aW5jcl9maXJzdCkgJiA2
MzsNCi0JCWlmICgobmVlZF9zZWNvbmQgJiAzMikgIT0gbmVlZF9zZWNvbmQpDQotCQkJcHJpbnRr
KEtFUk5fRVJSICJ0Z2FmYjogbmVlZF9zZWNvbmQgd3JvbmdcbiIpOw0KLQkJaWYgKGxlZnQgPj0g
bmVlZF9zZWNvbmQgKyA2NCkgew0KLQkJCWxlZnQgLT0gbmVlZF9zZWNvbmQ7DQotCQkJbjY0ID0g
bGVmdCAvIDY0Ow0KLQkJCWxlZnQgJT0gNjQ7DQotCQl9IGVsc2UNCi0JCQluZWVkX3NlY29uZCA9
IDA7DQotCX0NCi0NCi0JLyogQ29weSB0cmFpbGluZyBmdWxsIDMyLWJ5dGUgc2VjdGlvbnMuICBU
aGlzIHdpbGwgYmUgdGhlIG1haW4NCi0JICAgbG9vcCBpZiB0aGUgNjQgYnl0ZSBsb29wIGNhbid0
IGJlIHVzZWQuICAqLw0KLQluMzIgPSBsZWZ0IC8gMzI7DQotCWxlZnQgJT0gMzI7DQotDQotCS8q
IENvcHkgdGhlIHRyYWlsaW5nIHVuYWxpZ25lZCBkZXN0aW5hdGlvbi4gICovDQotCWRtYXNrX2xh
c3QgPSAoMXVsIDw8IGxlZnQpIC0gMTsNCi0NCi0JdGdhX3JlZ3MgPSBwYXItPnRnYV9yZWdzX2Jh
c2U7DQotCXRnYV9mYiA9IHBhci0+dGdhX2ZiX2Jhc2U7DQotDQotCS8qIFNldCB1cCB0aGUgTU9E
RSBhbmQgUElYRUxTSElGVCByZWdpc3RlcnMuICAqLw0KLQlfX3Jhd193cml0ZWwoVEdBX01PREVf
U0JNXzhCUFB8VEdBX01PREVfQ09QWSwgdGdhX3JlZ3MrVEdBX01PREVfUkVHKTsNCi0JX19yYXdf
d3JpdGVsKHBpeGVsX3NoaWZ0LCB0Z2FfcmVncytUR0FfUElYRUxTSElGVF9SRUcpOw0KLQl3bWIo
KTsNCi0NCi0JZm9yIChpID0gMDsgaSA8IGhlaWdodDsgKytpKSB7DQotCQl1bnNpZ25lZCBsb25n
IGo7DQotCQl2b2lkIF9faW9tZW0gKnNmYjsNCi0JCXZvaWQgX19pb21lbSAqZGZiOw0KLQ0KLQkJ
c2ZiID0gdGdhX2ZiICsgc3BvczsNCi0JCWRmYiA9IHRnYV9mYiArIGRwb3M7DQotCQlpZiAoZG1h
c2tfZmlyc3QpIHsNCi0JCQlfX3Jhd193cml0ZWwoc21hc2tfZmlyc3QsIHNmYik7DQotCQkJd21i
KCk7DQotCQkJX19yYXdfd3JpdGVsKGRtYXNrX2ZpcnN0LCBkZmIpOw0KLQkJCXdtYigpOw0KLQkJ
CXNmYiArPSB4aW5jcl9maXJzdDsNCi0JCQlkZmIgKz0geGluY3JfZmlyc3Q7DQotCQl9DQotDQot
CQlpZiAobmVlZF9zZWNvbmQpIHsNCi0JCQlfX3Jhd193cml0ZWwoMHhmZmZmZmZmZiwgc2ZiKTsN
Ci0JCQl3bWIoKTsNCi0JCQlfX3Jhd193cml0ZWwoMHhmZmZmZmZmZiwgZGZiKTsNCi0JCQl3bWIo
KTsNCi0JCQlzZmIgKz0gMzI7DQotCQkJZGZiICs9IDMyOw0KLQkJfQ0KLQ0KLQkJaWYgKG42NCAm
JiAoKCh1bnNpZ25lZCBsb25nKXNmYiB8ICh1bnNpZ25lZCBsb25nKWRmYikgJiA2MykpDQotCQkJ
cHJpbnRrKEtFUk5fRVJSDQotCQkJICAgICAgICJ0Z2FmYjogbWlzYWxpZ25lZCBjb3B5NjQgKHM6
JXAsIGQ6JXApXG4iLA0KLQkJCSAgICAgICBzZmIsIGRmYik7DQotDQotCQlmb3IgKGogPSAwOyBq
IDwgbjY0OyArK2opIHsNCi0JCQlfX3Jhd193cml0ZWwoc2ZiIC0gdGdhX2ZiLCB0Z2FfcmVncytU
R0FfQ09QWTY0X1NSQyk7DQotCQkJd21iKCk7DQotCQkJX19yYXdfd3JpdGVsKGRmYiAtIHRnYV9m
YiwgdGdhX3JlZ3MrVEdBX0NPUFk2NF9EU1QpOw0KLQkJCXdtYigpOw0KLQkJCXNmYiArPSA2NDsN
Ci0JCQlkZmIgKz0gNjQ7DQotCQl9DQotDQotCQlmb3IgKGogPSAwOyBqIDwgbjMyOyArK2opIHsN
Ci0JCQlfX3Jhd193cml0ZWwoMHhmZmZmZmZmZiwgc2ZiKTsNCi0JCQl3bWIoKTsNCi0JCQlfX3Jh
d193cml0ZWwoMHhmZmZmZmZmZiwgZGZiKTsNCi0JCQl3bWIoKTsNCi0JCQlzZmIgKz0gMzI7DQot
CQkJZGZiICs9IDMyOw0KLQkJfQ0KLQ0KLQkJaWYgKGRtYXNrX2xhc3QpIHsNCi0JCQlfX3Jhd193
cml0ZWwoMHhmZmZmZmZmZiwgc2ZiKTsNCi0JCQl3bWIoKTsNCi0JCQlfX3Jhd193cml0ZWwoZG1h
c2tfbGFzdCwgZGZiKTsNCi0JCQl3bWIoKTsNCi0JCX0NCi0NCi0JCXNwb3MgKz0geWluY3I7DQot
CQlkcG9zICs9IHlpbmNyOw0KKwkvKiBEbyBhY2NlbGVyYXRpb24gb25seSBpZiB3ZSBhcmUgYWxp
Z25lZCBvbiA4IHBpeGVscyAqLw0KKwlpZiAoKGR4IHwgc3ggfCB3aWR0aCkgJiA3KSB7DQorCQlj
ZmJfY29weWFyZWEoaW5mbywgYXJlYSk7DQorCQlyZXR1cm47DQogCX0NCiANCi0JLyogUmVzZXQg
dGhlIE1PREUgcmVnaXN0ZXIgdG8gbm9ybWFsLiAgKi8NCi0JX19yYXdfd3JpdGVsKFRHQV9NT0RF
X1NCTV84QlBQfFRHQV9NT0RFX1NJTVBMRSwgdGdhX3JlZ3MrVEdBX01PREVfUkVHKTsNCi19DQot
DQotLyogVGhlIChhbG1vc3QpIGdlbmVyYWwgY2FzZSBvZiBiYWNrd2FyZCBjb3B5IGluIDhicHAg
bW9kZS4gICovDQotc3RhdGljIGlubGluZSB2b2lkDQotY29weWFyZWFfYmFja3dhcmRfOGJwcChz
dHJ1Y3QgZmJfaW5mbyAqaW5mbywgdTMyIGR4LCB1MzIgZHksIHUzMiBzeCwgdTMyIHN5LA0KLQkJ
ICAgICAgIHUzMiBoZWlnaHQsIHUzMiB3aWR0aCwgdTMyIGxpbmVfbGVuZ3RoLA0KLQkJICAgICAg
IGNvbnN0IHN0cnVjdCBmYl9jb3B5YXJlYSAqYXJlYSkNCi17DQotCXN0cnVjdCB0Z2FfcGFyICpw
YXIgPSAoc3RydWN0IHRnYV9wYXIgKikgaW5mby0+cGFyOw0KLQl1bnNpZ25lZCBsb25nIGksIGxl
ZnQsIHlpbmNyOw0KLQl1bnNpZ25lZCBsb25nIGRlcG9zLCBzZXBvcywgZGVhbGlnbiwgc2VhbGln
bjsNCi0JdTMyIG1hc2tfZmlyc3QsIG1hc2tfbGFzdDsNCi0JdW5zaWduZWQgbG9uZyBuMzI7DQot
CXZvaWQgX19pb21lbSAqdGdhX3JlZ3M7DQotCXZvaWQgX19pb21lbSAqdGdhX2ZiOw0KLQ0KIAl5
aW5jciA9IGxpbmVfbGVuZ3RoOw0KIAlpZiAoZHkgPiBzeSkgew0KIAkJZHkgKz0gaGVpZ2h0IC0g
MTsNCiAJCXN5ICs9IGhlaWdodCAtIDE7DQogCQl5aW5jciA9IC15aW5jcjsNCiAJfQ0KKwliYWNr
d2FyZCA9IGR5ID09IHN5ICYmIGR4ID4gc3ggJiYgZHggPCBzeCArIHdpZHRoOw0KIA0KIAkvKiBD
b21wdXRlIHRoZSBvZmZzZXRzIGFuZCBhbGlnbm1lbnRzIGluIHRoZSBmcmFtZSBidWZmZXIuDQog
CSAgIE1vcmUgdGhhbiBhbnl0aGluZyBlbHNlLCB0aGVzZSBjb250cm9sIGhvdyB3ZSBkbyBjb3Bp
ZXMuICAqLw0KLQlkZXBvcyA9IGR5ICogbGluZV9sZW5ndGggKyBkeCArIHdpZHRoOw0KLQlzZXBv
cyA9IHN5ICogbGluZV9sZW5ndGggKyBzeCArIHdpZHRoOw0KLQlkZWFsaWduID0gZGVwb3MgJiA3
Ow0KLQlzZWFsaWduID0gc2Vwb3MgJiA3Ow0KLQ0KLQkvKiA/Pz8gVGhlIGRvY3VtZW50YXRpb24g
YXBwZWFycyB0byBiZSBpbmNvcnJlY3QgKG9yIHZlcnkNCi0JICAgbWlzbGVhZGluZykgd3J0IGhv
dyBwaXhlbCBzaGlmdGluZyB3b3JrcyBpbiBiYWNrd2FyZCBjb3B5DQotCSAgIG1vZGUsIGkuZS4g
d2hlbiBQSVhFTFNISUZUIGlzIG5lZ2F0aXZlLiAgSSBnaXZlIHVwIGZvciBub3cuDQotCSAgIERv
IGhhbmRsZSB0aGUgY29tbW9uIGNhc2Ugb2YgY28tYWxpZ25lZCBiYWNrd2FyZCBjb3BpZXMsDQot
CSAgIGJ1dCBmcm9iIGV2ZXJ5dGhpbmcgZWxzZSBiYWNrIG9uIGdlbmVyaWMgY29kZS4gICovDQot
CWlmIChkZWFsaWduICE9IHNlYWxpZ24pIHsNCi0JCWNmYl9jb3B5YXJlYShpbmZvLCBhcmVhKTsN
Ci0JCXJldHVybjsNCi0JfQ0KLQ0KLQkvKiBXZSBiZWdpbiB0aGUgY29weSB3aXRoIHRoZSB0cmFp
bGluZyBwaXhlbHMgb2YgdGhlDQotCSAgIHVuYWxpZ25lZCBkZXN0aW5hdGlvbi4gICovDQotCW1h
c2tfZmlyc3QgPSAoMXVsIDw8IGRlYWxpZ24pIC0gMTsNCi0JbGVmdCA9IHdpZHRoIC0gZGVhbGln
bjsNCi0NCi0JLyogQ2FyZSBmb3Igc21hbGwgY29waWVzLiAgKi8NCi0JaWYgKGRlYWxpZ24gPiB3
aWR0aCkgew0KLQkJbWFza19maXJzdCBePSAoMXVsIDw8IChkZWFsaWduIC0gd2lkdGgpKSAtIDE7
DQotCQlsZWZ0ID0gMDsNCi0JfQ0KKwlkZXBvcyA9IGR5ICogbGluZV9sZW5ndGggKyBkeDsNCisJ
c2Vwb3MgPSBzeSAqIGxpbmVfbGVuZ3RoICsgc3g7DQorCWlmIChiYWNrd2FyZCkNCisJCWRlcG9z
ICs9IHdpZHRoLCBzZXBvcyArPSB3aWR0aDsNCiANCiAJLyogTmV4dCBjb3B5IGZ1bGwgd29yZHMg
YXQgYSB0aW1lLiAgKi8NCi0JbjMyID0gbGVmdCAvIDMyOw0KLQlsZWZ0ICU9IDMyOw0KKwluMzIg
PSB3aWR0aCAvIDMyOw0KKwlsYXN0X3N0ZXAgPSB3aWR0aCAlIDMyOw0KIA0KIAkvKiBGaW5hbGx5
IGNvcHkgdGhlIHVuYWxpZ25lZCBoZWFkIG9mIHRoZSBzcGFuLiAgKi8NCi0JbWFza19sYXN0ID0g
LTEgPDwgKDMyIC0gbGVmdCk7DQorCW1hc2tfbGFzdCA9ICgxdWwgPDwgbGFzdF9zdGVwKSAtIDE7
DQorDQorCWlmICghYmFja3dhcmQpIHsNCisJCXN0ZXAgPSAzMjsNCisJCWxhc3Rfc3RlcCA9IDMy
Ow0KKwl9IGVsc2Ugew0KKwkJc3RlcCA9IC0zMjsNCisJCWxhc3Rfc3RlcCA9IC1sYXN0X3N0ZXA7
DQorCQlzZXBvcyAtPSAzMjsNCisJCWRlcG9zIC09IDMyOw0KKwl9DQogDQogCXRnYV9yZWdzID0g
cGFyLT50Z2FfcmVnc19iYXNlOw0KIAl0Z2FfZmIgPSBwYXItPnRnYV9mYl9iYXNlOw0KQEAgLTEz
NzgsMjUgKzEyMTMsMzMgQEAgY29weWFyZWFfYmFja3dhcmRfOGJwcChzdHJ1Y3QgZmJfaW5mbyAq
aW5mbywgdTMyIGR4LCB1MzIgZHksIHUzMiBzeCwgdTMyIHN5LA0KIA0KIAkJc2ZiID0gdGdhX2Zi
ICsgc2Vwb3M7DQogCQlkZmIgPSB0Z2FfZmIgKyBkZXBvczsNCi0JCWlmIChtYXNrX2ZpcnN0KSB7
DQotCQkJX19yYXdfd3JpdGVsKG1hc2tfZmlyc3QsIHNmYik7DQotCQkJd21iKCk7DQotCQkJX19y
YXdfd3JpdGVsKG1hc2tfZmlyc3QsIGRmYik7DQotCQkJd21iKCk7DQotCQl9DQogDQotCQlmb3Ig
KGogPSAwOyBqIDwgbjMyOyArK2opIHsNCi0JCQlzZmIgLT0gMzI7DQotCQkJZGZiIC09IDMyOw0K
KwkJZm9yIChqID0gMDsgaiA8IG4zMjsgaisrKSB7DQorCQkJaWYgKGogPCAyICYmIGogKyAxIDwg
bjMyICYmICFiYWNrd2FyZCAmJg0KKwkJCSAgICAhKCgodW5zaWduZWQgbG9uZylzZmIgfCAodW5z
aWduZWQgbG9uZylkZmIpICYgNjMpKSB7DQorCQkJCWRvIHsNCisJCQkJCV9fcmF3X3dyaXRlbChz
ZmIgLSB0Z2FfZmIsIHRnYV9yZWdzK1RHQV9DT1BZNjRfU1JDKTsNCisJCQkJCXdtYigpOw0KKwkJ
CQkJX19yYXdfd3JpdGVsKGRmYiAtIHRnYV9mYiwgdGdhX3JlZ3MrVEdBX0NPUFk2NF9EU1QpOw0K
KwkJCQkJd21iKCk7DQorCQkJCQlzZmIgKz0gNjQ7DQorCQkJCQlkZmIgKz0gNjQ7DQorCQkJCQlq
ICs9IDI7DQorCQkJCX0gd2hpbGUgKGogKyAxIDwgbjMyKTsNCisJCQkJai0tOw0KKwkJCQljb250
aW51ZTsNCisJCQl9DQogCQkJX19yYXdfd3JpdGVsKDB4ZmZmZmZmZmYsIHNmYik7DQogCQkJd21i
KCk7DQogCQkJX19yYXdfd3JpdGVsKDB4ZmZmZmZmZmYsIGRmYik7DQogCQkJd21iKCk7DQorCQkJ
c2ZiICs9IHN0ZXA7DQorCQkJZGZiICs9IHN0ZXA7DQogCQl9DQogDQogCQlpZiAobWFza19sYXN0
KSB7DQotCQkJc2ZiIC09IDMyOw0KLQkJCWRmYiAtPSAzMjsNCisJCQlzZmIgKz0gbGFzdF9zdGVw
IC0gc3RlcDsNCisJCQlkZmIgKz0gbGFzdF9zdGVwIC0gc3RlcDsNCiAJCQlfX3Jhd193cml0ZWwo
bWFza19sYXN0LCBzZmIpOw0KIAkJCXdtYigpOw0KIAkJCV9fcmF3X3dyaXRlbChtYXNrX2xhc3Qs
IGRmYik7DQpAQCAtMTQ1NywxNCArMTMwMCw5IEBAIHRnYWZiX2NvcHlhcmVhKHN0cnVjdCBmYl9p
bmZvICppbmZvLCBjb25zdCBzdHJ1Y3QgZmJfY29weWFyZWEgKmFyZWEpDQogCWVsc2UgaWYgKGJw
cCA9PSAzMikNCiAJCWNmYl9jb3B5YXJlYShpbmZvLCBhcmVhKTsNCiANCi0JLyogRGV0ZWN0IG92
ZXJsYXBwaW5nIHNvdXJjZSBhbmQgZGVzdGluYXRpb24gdGhhdCByZXF1aXJlcw0KLQkgICBhIGJh
Y2t3YXJkIGNvcHkuICAqLw0KLQllbHNlIGlmIChkeSA9PSBzeSAmJiBkeCA+IHN4ICYmIGR4IDwg
c3ggKyB3aWR0aCkNCi0JCWNvcHlhcmVhX2JhY2t3YXJkXzhicHAoaW5mbywgZHgsIGR5LCBzeCwg
c3ksIGhlaWdodCwNCi0JCQkJICAgICAgIHdpZHRoLCBsaW5lX2xlbmd0aCwgYXJlYSk7DQogCWVs
c2UNCi0JCWNvcHlhcmVhX2ZvcmV3YXJkXzhicHAoaW5mbywgZHgsIGR5LCBzeCwgc3ksIGhlaWdo
dCwNCi0JCQkJICAgICAgIHdpZHRoLCBsaW5lX2xlbmd0aCk7DQorCQljb3B5YXJlYV84YnBwKGlu
Zm8sIGR4LCBkeSwgc3gsIHN5LCBoZWlnaHQsDQorCQkJICAgICAgd2lkdGgsIGxpbmVfbGVuZ3Ro
LCBhcmVhKTsNCiB9DQogDQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy92aXJ0aW8vdmlydGlvX2Jh
bGxvb24uYyBiL2RyaXZlcnMvdmlydGlvL3ZpcnRpb19iYWxsb29uLmMNCmluZGV4IDk0ZmQ3Mzgu
LjI4MTUzZmIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3ZpcnRpby92aXJ0aW9fYmFsbG9vbi5jDQor
KysgYi9kcml2ZXJzL3ZpcnRpby92aXJ0aW9fYmFsbG9vbi5jDQpAQCAtMjcxLDYgKzI3MSwxMiBA
QCBzdGF0aWMgaW50IGJhbGxvb24odm9pZCAqX3ZiYWxsb29uKQ0KIAkJZWxzZSBpZiAoZGlmZiA8
IDApDQogCQkJbGVha19iYWxsb29uKHZiLCAtZGlmZik7DQogCQl1cGRhdGVfYmFsbG9vbl9zaXpl
KHZiKTsNCisNCisJCS8qDQorCQkgKiBGb3IgbGFyZ2UgYmFsbG9vbiBjaGFuZ2VzLCB3ZSBjb3Vs
ZCBzcGVuZCBhIGxvdCBvZiB0aW1lDQorCQkgKiBhbmQgYWx3YXlzIGhhdmUgd29yayB0byBkby4g
IEJlIG5pY2UgaWYgcHJlZW1wdCBkaXNhYmxlZC4NCisJCSAqLw0KKwkJY29uZF9yZXNjaGVkKCk7
DQogCX0NCiAJcmV0dXJuIDA7DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdzEvdzFfbmV0bGlu
ay5jIGIvZHJpdmVycy93MS93MV9uZXRsaW5rLmMNCmluZGV4IDQwNzg4YzkuLjczNzA1YWYgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL3cxL3cxX25ldGxpbmsuYw0KKysrIGIvZHJpdmVycy93MS93MV9u
ZXRsaW5rLmMNCkBAIC01NCwyOCArNTQsMjkgQEAgc3RhdGljIHZvaWQgdzFfc2VuZF9zbGF2ZShz
dHJ1Y3QgdzFfbWFzdGVyICpkZXYsIHU2NCBybikNCiAJc3RydWN0IHcxX25ldGxpbmtfbXNnICpo
ZHIgPSAoc3RydWN0IHcxX25ldGxpbmtfbXNnICopKG1zZyArIDEpOw0KIAlzdHJ1Y3QgdzFfbmV0
bGlua19jbWQgKmNtZCA9IChzdHJ1Y3QgdzFfbmV0bGlua19jbWQgKikoaGRyICsgMSk7DQogCWlu
dCBhdmFpbDsNCisJdTY0ICpkYXRhOw0KIA0KIAkvKiB1cGRhdGUga2VybmVsIHNsYXZlIGxpc3Qg
Ki8NCiAJdzFfc2xhdmVfZm91bmQoZGV2LCBybik7DQogDQogCWF2YWlsID0gZGV2LT5wcml2X3Np
emUgLSBjbWQtPmxlbjsNCiANCi0JaWYgKGF2YWlsID4gOCkgew0KLQkJdTY0ICpkYXRhID0gKHZv
aWQgKikoY21kICsgMSkgKyBjbWQtPmxlbjsNCisJaWYgKGF2YWlsIDwgOCkgew0KKwkJbXNnLT5h
Y2srKzsNCisJCWNuX25ldGxpbmtfc2VuZChtc2csIDAsIEdGUF9LRVJORUwpOw0KIA0KLQkJKmRh
dGEgPSBybjsNCi0JCWNtZC0+bGVuICs9IDg7DQotCQloZHItPmxlbiArPSA4Ow0KLQkJbXNnLT5s
ZW4gKz0gODsNCi0JCXJldHVybjsNCisJCW1zZy0+bGVuID0gc2l6ZW9mKHN0cnVjdCB3MV9uZXRs
aW5rX21zZykgKw0KKwkJCXNpemVvZihzdHJ1Y3QgdzFfbmV0bGlua19jbWQpOw0KKwkJaGRyLT5s
ZW4gPSBzaXplb2Yoc3RydWN0IHcxX25ldGxpbmtfY21kKTsNCisJCWNtZC0+bGVuID0gMDsNCiAJ
fQ0KIA0KLQltc2ctPmFjaysrOw0KLQljbl9uZXRsaW5rX3NlbmQobXNnLCAwLCBHRlBfS0VSTkVM
KTsNCisJZGF0YSA9ICh2b2lkICopKGNtZCArIDEpICsgY21kLT5sZW47DQogDQotCW1zZy0+bGVu
ID0gc2l6ZW9mKHN0cnVjdCB3MV9uZXRsaW5rX21zZykgKyBzaXplb2Yoc3RydWN0IHcxX25ldGxp
bmtfY21kKTsNCi0JaGRyLT5sZW4gPSBzaXplb2Yoc3RydWN0IHcxX25ldGxpbmtfY21kKTsNCi0J
Y21kLT5sZW4gPSAwOw0KKwkqZGF0YSA9IHJuOw0KKwljbWQtPmxlbiArPSA4Ow0KKwloZHItPmxl
biArPSA4Ow0KKwltc2ctPmxlbiArPSA4Ow0KIH0NCiANCiBzdGF0aWMgaW50IHcxX3Byb2Nlc3Nf
c2VhcmNoX2NvbW1hbmQoc3RydWN0IHcxX21hc3RlciAqZGV2LCBzdHJ1Y3QgY25fbXNnICptc2cs
DQpkaWZmIC0tZ2l0IGEvZnMvYnRyZnMvZGlzay1pby5jIGIvZnMvYnRyZnMvZGlzay1pby5jDQpp
bmRleCA2YjJhNzI0Li5jZmRmNmZlIDEwMDY0NA0KLS0tIGEvZnMvYnRyZnMvZGlzay1pby5jDQor
KysgYi9mcy9idHJmcy9kaXNrLWlvLmMNCkBAIC0yNzMxLDYgKzI3MzEsOCBAQCBzdGF0aWMgaW50
IGJhcnJpZXJfYWxsX2RldmljZXMoc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmluZm8pDQogCS8qIHNl
bmQgZG93biBhbGwgdGhlIGJhcnJpZXJzICovDQogCWhlYWQgPSAmaW5mby0+ZnNfZGV2aWNlcy0+
ZGV2aWNlczsNCiAJbGlzdF9mb3JfZWFjaF9lbnRyeV9yY3UoZGV2LCBoZWFkLCBkZXZfbGlzdCkg
ew0KKwkJaWYgKGRldi0+bWlzc2luZykNCisJCQljb250aW51ZTsNCiAJCWlmICghZGV2LT5iZGV2
KSB7DQogCQkJZXJyb3JzKys7DQogCQkJY29udGludWU7DQpAQCAtMjc0NSw2ICsyNzQ3LDggQEAg
c3RhdGljIGludCBiYXJyaWVyX2FsbF9kZXZpY2VzKHN0cnVjdCBidHJmc19mc19pbmZvICppbmZv
KQ0KIA0KIAkvKiB3YWl0IGZvciBhbGwgdGhlIGJhcnJpZXJzICovDQogCWxpc3RfZm9yX2VhY2hf
ZW50cnlfcmN1KGRldiwgaGVhZCwgZGV2X2xpc3QpIHsNCisJCWlmIChkZXYtPm1pc3NpbmcpDQor
CQkJY29udGludWU7DQogCQlpZiAoIWRldi0+YmRldikgew0KIAkJCWVycm9ycysrOw0KIAkJCWNv
bnRpbnVlOw0KZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL3RyYW5zYWN0aW9uLmMgYi9mcy9idHJmcy90
cmFuc2FjdGlvbi5jDQppbmRleCA4MTM3NmQ5Li4yOTJlODQ3IDEwMDY0NA0KLS0tIGEvZnMvYnRy
ZnMvdHJhbnNhY3Rpb24uYw0KKysrIGIvZnMvYnRyZnMvdHJhbnNhY3Rpb24uYw0KQEAgLTQ2MCw3
ICs0NjAsOCBAQCBzdGF0aWMgaW50IF9fYnRyZnNfZW5kX3RyYW5zYWN0aW9uKHN0cnVjdCBidHJm
c190cmFuc19oYW5kbGUgKnRyYW5zLA0KIAlzdHJ1Y3QgYnRyZnNfZnNfaW5mbyAqaW5mbyA9IHJv
b3QtPmZzX2luZm87DQogCWludCBjb3VudCA9IDA7DQogDQotCWlmICgtLXRyYW5zLT51c2VfY291
bnQpIHsNCisJaWYgKHRyYW5zLT51c2VfY291bnQgPiAxKSB7DQorCQl0cmFucy0+dXNlX2NvdW50
LS07DQogCQl0cmFucy0+YmxvY2tfcnN2ID0gdHJhbnMtPm9yaWdfcnN2Ow0KIAkJcmV0dXJuIDA7
DQogCX0NCkBAIC00OTQsMTcgKzQ5NSwxMCBAQCBzdGF0aWMgaW50IF9fYnRyZnNfZW5kX3RyYW5z
YWN0aW9uKHN0cnVjdCBidHJmc190cmFuc19oYW5kbGUgKnRyYW5zLA0KIAl9DQogDQogCWlmIChs
b2NrICYmIGN1cl90cmFucy0+YmxvY2tlZCAmJiAhY3VyX3RyYW5zLT5pbl9jb21taXQpIHsNCi0J
CWlmICh0aHJvdHRsZSkgew0KLQkJCS8qDQotCQkJICogV2UgbWF5IHJhY2Ugd2l0aCBzb21lYm9k
eSBlbHNlIGhlcmUgc28gZW5kIHVwIGhhdmluZw0KLQkJCSAqIHRvIGNhbGwgZW5kX3RyYW5zYWN0
aW9uIG9uIG91cnNlbHZlcyBhZ2Fpbiwgc28gaW5jDQotCQkJICogb3VyIHVzZV9jb3VudC4NCi0J
CQkgKi8NCi0JCQl0cmFucy0+dXNlX2NvdW50Kys7DQorCQlpZiAodGhyb3R0bGUpDQogCQkJcmV0
dXJuIGJ0cmZzX2NvbW1pdF90cmFuc2FjdGlvbih0cmFucywgcm9vdCk7DQotCQl9IGVsc2Ugew0K
KwkJZWxzZQ0KIAkJCXdha2VfdXBfcHJvY2VzcyhpbmZvLT50cmFuc2FjdGlvbl9rdGhyZWFkKTsN
Ci0JCX0NCiAJfQ0KIA0KIAlXQVJOX09OKGN1cl90cmFucyAhPSBpbmZvLT5ydW5uaW5nX3RyYW5z
YWN0aW9uKTsNCmRpZmYgLS1naXQgYS9mcy9leHQ0L2V4dGVudHMuYyBiL2ZzL2V4dDQvZXh0ZW50
cy5jDQppbmRleCBiZjM1ZmUwLi44MzRkOWExIDEwMDY0NA0KLS0tIGEvZnMvZXh0NC9leHRlbnRz
LmMNCisrKyBiL2ZzL2V4dDQvZXh0ZW50cy5jDQpAQCAtMjM3Miw2ICsyMzcyLDI3IEBAIGV4dDRf
ZXh0X3JtX2xlYWYoaGFuZGxlX3QgKmhhbmRsZSwgc3RydWN0IGlub2RlICppbm9kZSwNCiAJZXhf
ZWVfYmxvY2sgPSBsZTMyX3RvX2NwdShleC0+ZWVfYmxvY2spOw0KIAlleF9lZV9sZW4gPSBleHQ0
X2V4dF9nZXRfYWN0dWFsX2xlbihleCk7DQogDQorCS8qDQorCSAqIElmIHdlJ3JlIHN0YXJ0aW5n
IHdpdGggYW4gZXh0ZW50IG90aGVyIHRoYW4gdGhlIGxhc3Qgb25lIGluIHRoZQ0KKwkgKiBub2Rl
LCB3ZSBuZWVkIHRvIHNlZSBpZiBpdCBzaGFyZXMgYSBjbHVzdGVyIHdpdGggdGhlIGV4dGVudCB0
bw0KKwkgKiB0aGUgcmlnaHQgKHRvd2FyZHMgdGhlIGVuZCBvZiB0aGUgZmlsZSkuIElmIGl0cyBs
ZWZ0bW9zdCBjbHVzdGVyDQorCSAqIGlzIHRoaXMgZXh0ZW50J3MgcmlnaHRtb3N0IGNsdXN0ZXIg
YW5kIGl0IGlzIG5vdCBjbHVzdGVyIGFsaWduZWQsDQorCSAqIHdlJ2xsIG1hcmsgaXQgYXMgYSBw
YXJ0aWFsIHRoYXQgaXMgbm90IHRvIGJlIGRlYWxsb2NhdGVkLg0KKwkgKi8NCisNCisJaWYgKGV4
ICE9IEVYVF9MQVNUX0VYVEVOVChlaCkpIHsNCisJCWV4dDRfZnNibGtfdCBjdXJyZW50X3BibGss
IHJpZ2h0X3BibGs7DQorCQlsb25nIGxvbmcgY3VycmVudF9jbHVzdGVyLCByaWdodF9jbHVzdGVy
Ow0KKw0KKwkJY3VycmVudF9wYmxrID0gZXh0NF9leHRfcGJsb2NrKGV4KSArIGV4X2VlX2xlbiAt
IDE7DQorCQljdXJyZW50X2NsdXN0ZXIgPSAobG9uZyBsb25nKUVYVDRfQjJDKHNiaSwgY3VycmVu
dF9wYmxrKTsNCisJCXJpZ2h0X3BibGsgPSBleHQ0X2V4dF9wYmxvY2soZXggKyAxKTsNCisJCXJp
Z2h0X2NsdXN0ZXIgPSAobG9uZyBsb25nKUVYVDRfQjJDKHNiaSwgcmlnaHRfcGJsayk7DQorCQlp
ZiAoY3VycmVudF9jbHVzdGVyID09IHJpZ2h0X2NsdXN0ZXIgJiYNCisJCQlFWFQ0X1BCTEtfQ09G
RihzYmksIHJpZ2h0X3BibGspKQ0KKwkJCSpwYXJ0aWFsX2NsdXN0ZXIgPSAtcmlnaHRfY2x1c3Rl
cjsNCisJfQ0KKw0KIAl0cmFjZV9leHQ0X2V4dF9ybV9sZWFmKGlub2RlLCBzdGFydCwgZXgsICpw
YXJ0aWFsX2NsdXN0ZXIpOw0KIA0KIAl3aGlsZSAoZXggPj0gRVhUX0ZJUlNUX0VYVEVOVChlaCkg
JiYNCmRpZmYgLS1naXQgYS9mcy9qZmZzMi9jb21wcl9ydGltZS5jIGIvZnMvamZmczIvY29tcHJf
cnRpbWUuYw0KaW5kZXggMTZhNTA0Ny4uNDA2ZDljYyAxMDA2NDQNCi0tLSBhL2ZzL2pmZnMyL2Nv
bXByX3J0aW1lLmMNCisrKyBiL2ZzL2pmZnMyL2NvbXByX3J0aW1lLmMNCkBAIC0zMyw3ICszMyw3
IEBAIHN0YXRpYyBpbnQgamZmczJfcnRpbWVfY29tcHJlc3ModW5zaWduZWQgY2hhciAqZGF0YV9p
biwNCiAJCQkJdW5zaWduZWQgY2hhciAqY3BhZ2Vfb3V0LA0KIAkJCQl1aW50MzJfdCAqc291cmNl
bGVuLCB1aW50MzJfdCAqZHN0bGVuKQ0KIHsNCi0Jc2hvcnQgcG9zaXRpb25zWzI1Nl07DQorCXVu
c2lnbmVkIHNob3J0IHBvc2l0aW9uc1syNTZdOw0KIAlpbnQgb3V0cG9zID0gMDsNCiAJaW50IHBv
cz0wOw0KIA0KQEAgLTc0LDcgKzc0LDcgQEAgc3RhdGljIGludCBqZmZzMl9ydGltZV9kZWNvbXBy
ZXNzKHVuc2lnbmVkIGNoYXIgKmRhdGFfaW4sDQogCQkJCSAgdW5zaWduZWQgY2hhciAqY3BhZ2Vf
b3V0LA0KIAkJCQkgIHVpbnQzMl90IHNyY2xlbiwgdWludDMyX3QgZGVzdGxlbikNCiB7DQotCXNo
b3J0IHBvc2l0aW9uc1syNTZdOw0KKwl1bnNpZ25lZCBzaG9ydCBwb3NpdGlvbnNbMjU2XTsNCiAJ
aW50IG91dHBvcyA9IDA7DQogCWludCBwb3M9MDsNCiANCmRpZmYgLS1naXQgYS9mcy9qZmZzMi9u
b2RlbGlzdC5oIGIvZnMvamZmczIvbm9kZWxpc3QuaA0KaW5kZXggZTQ2MTliMC4uZmEzNWZmNyAx
MDA2NDQNCi0tLSBhL2ZzL2pmZnMyL25vZGVsaXN0LmgNCisrKyBiL2ZzL2pmZnMyL25vZGVsaXN0
LmgNCkBAIC0yMzEsNyArMjMxLDcgQEAgc3RydWN0IGpmZnMyX3RtcF9kbm9kZV9pbmZvDQogCXVp
bnQzMl90IHZlcnNpb247DQogCXVpbnQzMl90IGRhdGFfY3JjOw0KIAl1aW50MzJfdCBwYXJ0aWFs
X2NyYzsNCi0JdWludDE2X3QgY3NpemU7DQorCXVpbnQzMl90IGNzaXplOw0KIAl1aW50MTZfdCBv
dmVybGFwcGVkOw0KIH07DQogDQpkaWZmIC0tZ2l0IGEvZnMvamZmczIvbm9kZW1nbXQuYyBiL2Zz
L2pmZnMyL25vZGVtZ210LmMNCmluZGV4IDY5NGFhNWIuLjE0NWJhMzkgMTAwNjQ0DQotLS0gYS9m
cy9qZmZzMi9ub2RlbWdtdC5jDQorKysgYi9mcy9qZmZzMi9ub2RlbWdtdC5jDQpAQCAtMTI4LDYg
KzEyOCw3IEBAIGludCBqZmZzMl9yZXNlcnZlX3NwYWNlKHN0cnVjdCBqZmZzMl9zYl9pbmZvICpj
LCB1aW50MzJfdCBtaW5zaXplLA0KIAkJCQkJc3Bpbl91bmxvY2soJmMtPmVyYXNlX2NvbXBsZXRp
b25fbG9jayk7DQogDQogCQkJCQlzY2hlZHVsZSgpOw0KKwkJCQkJcmVtb3ZlX3dhaXRfcXVldWUo
JmMtPmVyYXNlX3dhaXQsICZ3YWl0KTsNCiAJCQkJfSBlbHNlDQogCQkJCQlzcGluX3VubG9jaygm
Yy0+ZXJhc2VfY29tcGxldGlvbl9sb2NrKTsNCiAJCQl9IGVsc2UgaWYgKHJldCkNCkBAIC0xNTgs
MTkgKzE1OSwyNCBAQCBpbnQgamZmczJfcmVzZXJ2ZV9zcGFjZShzdHJ1Y3QgamZmczJfc2JfaW5m
byAqYywgdWludDMyX3QgbWluc2l6ZSwNCiBpbnQgamZmczJfcmVzZXJ2ZV9zcGFjZV9nYyhzdHJ1
Y3QgamZmczJfc2JfaW5mbyAqYywgdWludDMyX3QgbWluc2l6ZSwNCiAJCQkgICB1aW50MzJfdCAq
bGVuLCB1aW50MzJfdCBzdW1zaXplKQ0KIHsNCi0JaW50IHJldCA9IC1FQUdBSU47DQorCWludCBy
ZXQ7DQogCW1pbnNpemUgPSBQQUQobWluc2l6ZSk7DQogDQogCUQxKHByaW50ayhLRVJOX0RFQlVH
ICJqZmZzMl9yZXNlcnZlX3NwYWNlX2djKCk6IFJlcXVlc3RlZCAweCV4IGJ5dGVzXG4iLCBtaW5z
aXplKSk7DQogDQotCXNwaW5fbG9jaygmYy0+ZXJhc2VfY29tcGxldGlvbl9sb2NrKTsNCi0Jd2hp
bGUocmV0ID09IC1FQUdBSU4pIHsNCisJd2hpbGUgKHRydWUpIHsNCisJCXNwaW5fbG9jaygmYy0+
ZXJhc2VfY29tcGxldGlvbl9sb2NrKTsNCiAJCXJldCA9IGpmZnMyX2RvX3Jlc2VydmVfc3BhY2Uo
YywgbWluc2l6ZSwgbGVuLCBzdW1zaXplKTsNCiAJCWlmIChyZXQpIHsNCiAJCQlEMShwcmludGso
S0VSTl9ERUJVRyAiamZmczJfcmVzZXJ2ZV9zcGFjZV9nYzogbG9vcGluZywgcmV0IGlzICVkXG4i
LCByZXQpKTsNCiAJCX0NCisJCXNwaW5fdW5sb2NrKCZjLT5lcmFzZV9jb21wbGV0aW9uX2xvY2sp
Ow0KKw0KKwkJaWYgKHJldCA9PSAtRUFHQUlOKQ0KKwkJCWNvbmRfcmVzY2hlZCgpOw0KKwkJZWxz
ZQ0KKwkJCWJyZWFrOw0KIAl9DQotCXNwaW5fdW5sb2NrKCZjLT5lcmFzZV9jb21wbGV0aW9uX2xv
Y2spOw0KIAlpZiAoIXJldCkNCiAJCXJldCA9IGpmZnMyX3ByZWFsbG9jX3Jhd19ub2RlX3JlZnMo
YywgYy0+bmV4dGJsb2NrLCAxKTsNCiANCmRpZmYgLS1naXQgYS9mcy9uZnNkL25mczRwcm9jLmMg
Yi9mcy9uZnNkL25mczRwcm9jLmMNCmluZGV4IGUwNjU0OTcuLjMxNWExYmEgMTAwNjQ0DQotLS0g
YS9mcy9uZnNkL25mczRwcm9jLmMNCisrKyBiL2ZzL25mc2QvbmZzNHByb2MuYw0KQEAgLTEyMjQs
NiArMTIyNCwxMiBAQCBuZnNkNF9wcm9jX2NvbXBvdW5kKHN0cnVjdCBzdmNfcnFzdCAqcnFzdHAs
DQogCQkvKiBJZiBvcCBpcyBub24taWRlbXBvdGVudCAqLw0KIAkJaWYgKG9wZGVzYy0+b3BfZmxh
Z3MgJiBPUF9NT0RJRklFU19TT01FVEhJTkcpIHsNCiAJCQlwbGVuID0gb3BkZXNjLT5vcF9yc2l6
ZV9ib3AocnFzdHAsIG9wKTsNCisJCQkvKg0KKwkJCSAqIElmIHRoZXJlJ3Mgc3RpbGwgYW5vdGhl
ciBvcGVyYXRpb24sIG1ha2Ugc3VyZQ0KKwkJCSAqIHdlJ2xsIGhhdmUgc3BhY2UgdG8gYXQgbGVh
c3QgZW5jb2RlIGFuIGVycm9yOg0KKwkJCSAqLw0KKwkJCWlmIChyZXNwLT5vcGNudCA8IGFyZ3Mt
Pm9wY250KQ0KKwkJCQlwbGVuICs9IENPTVBPVU5EX0VSUl9TTEFDS19TUEFDRTsNCiAJCQlvcC0+
c3RhdHVzID0gbmZzZDRfY2hlY2tfcmVzcF9zaXplKHJlc3AsIHBsZW4pOw0KIAkJfQ0KIA0KQEAg
LTEzODEsNyArMTM4Nyw4IEBAIHN0YXRpYyBpbmxpbmUgdTMyIG5mc2Q0X3NldGF0dHJfcnNpemUo
c3RydWN0IHN2Y19ycXN0ICpycXN0cCwgc3RydWN0IG5mc2Q0X29wICpvDQogDQogc3RhdGljIGlu
bGluZSB1MzIgbmZzZDRfc2V0Y2xpZW50aWRfcnNpemUoc3RydWN0IHN2Y19ycXN0ICpycXN0cCwg
c3RydWN0IG5mc2Q0X29wICpvcCkNCiB7DQotCXJldHVybiAob3BfZW5jb2RlX2hkcl9zaXplICsg
MiArIDEwMjQpICogc2l6ZW9mKF9fYmUzMik7DQorCXJldHVybiAob3BfZW5jb2RlX2hkcl9zaXpl
ICsgMiArIFhEUl9RVUFETEVOKE5GUzRfVkVSSUZJRVJfU0laRSkpICoNCisJCQkJCQkJCXNpemVv
ZihfX2JlMzIpOw0KIH0NCiANCiBzdGF0aWMgaW5saW5lIHUzMiBuZnNkNF93cml0ZV9yc2l6ZShz
dHJ1Y3Qgc3ZjX3Jxc3QgKnJxc3RwLCBzdHJ1Y3QgbmZzZDRfb3AgKm9wKQ0KZGlmZiAtLWdpdCBh
L2ZzL25mc2QvbmZzNHhkci5jIGIvZnMvbmZzZC9uZnM0eGRyLmMNCmluZGV4IGFkZTUzMTYuLjQ4
MzViOTAgMTAwNjQ0DQotLS0gYS9mcy9uZnNkL25mczR4ZHIuYw0KKysrIGIvZnMvbmZzZC9uZnM0
eGRyLmMNCkBAIC0yNDEzLDYgKzI0MTMsOCBAQCBvdXRfYWNsOg0KIAkJV1JJVEU2NChzdGF0Lmlu
byk7DQogCX0NCiAJaWYgKGJtdmFsMiAmIEZBVFRSNF9XT1JEMl9TVVBQQVRUUl9FWENMQ1JFQVQp
IHsNCisJCWlmICgoYnVmbGVuIC09IDE2KSA8IDApDQorCQkJZ290byBvdXRfcmVzb3VyY2U7DQog
CQlXUklURTMyKDMpOw0KIAkJV1JJVEUzMihORlNEX1NVUFBBVFRSX0VYQ0xDUkVBVF9XT1JEMCk7
DQogCQlXUklURTMyKE5GU0RfU1VQUEFUVFJfRVhDTENSRUFUX1dPUkQxKTsNCmRpZmYgLS1naXQg
YS9mcy9uZnNkL3Zmcy5jIGIvZnMvbmZzZC92ZnMuYw0KaW5kZXggNmE2NmZjMC4uMTFlMTg4OCAx
MDA2NDQNCi0tLSBhL2ZzL25mc2QvdmZzLmMNCisrKyBiL2ZzL25mc2QvdmZzLmMNCkBAIC00MDYs
NiArNDA2LDcgQEAgbmZzZF9zZXRhdHRyKHN0cnVjdCBzdmNfcnFzdCAqcnFzdHAsIHN0cnVjdCBz
dmNfZmggKmZocCwgc3RydWN0IGlhdHRyICppYXAsDQogCWludAkJZnR5cGUgPSAwOw0KIAlfX2Jl
MzIJCWVycjsNCiAJaW50CQlob3N0X2VycjsNCisJYm9vbAkJZ2V0X3dyaXRlX2NvdW50Ow0KIAlp
bnQJCXNpemVfY2hhbmdlID0gMDsNCiANCiAJaWYgKGlhcC0+aWFfdmFsaWQgJiAoQVRUUl9BVElN
RSB8IEFUVFJfTVRJTUUgfCBBVFRSX1NJWkUpKQ0KQEAgLTQxMywxMCArNDE0LDE4IEBAIG5mc2Rf
c2V0YXR0cihzdHJ1Y3Qgc3ZjX3Jxc3QgKnJxc3RwLCBzdHJ1Y3Qgc3ZjX2ZoICpmaHAsIHN0cnVj
dCBpYXR0ciAqaWFwLA0KIAlpZiAoaWFwLT5pYV92YWxpZCAmIEFUVFJfU0laRSkNCiAJCWZ0eXBl
ID0gU19JRlJFRzsNCiANCisJLyogQ2FsbGVycyB0aGF0IGRvIGZoX3ZlcmlmeSBzaG91bGQgZG8g
dGhlIGZoX3dhbnRfd3JpdGU6ICovDQorCWdldF93cml0ZV9jb3VudCA9ICFmaHAtPmZoX2RlbnRy
eTsNCisNCiAJLyogR2V0IGlub2RlICovDQogCWVyciA9IGZoX3ZlcmlmeShycXN0cCwgZmhwLCBm
dHlwZSwgYWNjbW9kZSk7DQogCWlmIChlcnIpDQogCQlnb3RvIG91dDsNCisJaWYgKGdldF93cml0
ZV9jb3VudCkgew0KKwkJaG9zdF9lcnIgPSBmaF93YW50X3dyaXRlKGZocCk7DQorCQlpZiAoaG9z
dF9lcnIpDQorCQkJcmV0dXJuIG5mc2Vycm5vKGhvc3RfZXJyKTsNCisJfQ0KIA0KIAlkZW50cnkg
PSBmaHAtPmZoX2RlbnRyeTsNCiAJaW5vZGUgPSBkZW50cnktPmRfaW5vZGU7DQpkaWZmIC0tZ2l0
IGEvZnMvbmZzZC92ZnMuaCBiL2ZzL25mc2QvdmZzLmgNCmluZGV4IDg1ZDRkNDIuLmM3ZmU5NjIg
MTAwNjQ0DQotLS0gYS9mcy9uZnNkL3Zmcy5oDQorKysgYi9mcy9uZnNkL3Zmcy5oDQpAQCAtMTA4
LDQgKzEwOCwxNCBAQCBzdHJ1Y3QgcG9zaXhfYWNsICpuZnNkX2dldF9wb3NpeF9hY2woc3RydWN0
IHN2Y19maCAqLCBpbnQpOw0KIGludCBuZnNkX3NldF9wb3NpeF9hY2woc3RydWN0IHN2Y19maCAq
LCBpbnQsIHN0cnVjdCBwb3NpeF9hY2wgKik7DQogI2VuZGlmDQogDQorc3RhdGljIGlubGluZSBp
bnQgZmhfd2FudF93cml0ZShzdHJ1Y3Qgc3ZjX2ZoICpmaCkNCit7DQorCXJldHVybiBtbnRfd2Fu
dF93cml0ZShmaC0+ZmhfZXhwb3J0LT5leF9wYXRoLm1udCk7DQorfQ0KKw0KK3N0YXRpYyBpbmxp
bmUgdm9pZCBmaF9kcm9wX3dyaXRlKHN0cnVjdCBzdmNfZmggKmZoKQ0KK3sNCisJbW50X2Ryb3Bf
d3JpdGUoZmgtPmZoX2V4cG9ydC0+ZXhfcGF0aC5tbnQpOw0KK30NCisNCiAjZW5kaWYgLyogTElO
VVhfTkZTRF9WRlNfSCAqLw0KZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2J1ZmZlcl9oZWFkX2lvLmMg
Yi9mcy9vY2ZzMi9idWZmZXJfaGVhZF9pby5jDQppbmRleCA1ZDE4YWQxLi40ZjY2ZTAwIDEwMDY0
NA0KLS0tIGEvZnMvb2NmczIvYnVmZmVyX2hlYWRfaW8uYw0KKysrIGIvZnMvb2NmczIvYnVmZmVy
X2hlYWRfaW8uYw0KQEAgLTkwLDcgKzkwLDYgQEAgaW50IG9jZnMyX3dyaXRlX2Jsb2NrKHN0cnVj
dCBvY2ZzMl9zdXBlciAqb3NiLCBzdHJ1Y3QgYnVmZmVyX2hlYWQgKmJoLA0KIAkJICogaW5mb3Jt
YXRpb24gZm9yIHRoaXMgYmggYXMgaXQncyBub3QgbWFya2VkIGxvY2FsbHkNCiAJCSAqIHVwdG9k
YXRlLiAqLw0KIAkJcmV0ID0gLUVJTzsNCi0JCXB1dF9iaChiaCk7DQogCQltbG9nX2Vycm5vKHJl
dCk7DQogCX0NCiANCkBAIC00MjAsNyArNDE5LDYgQEAgaW50IG9jZnMyX3dyaXRlX3N1cGVyX29y
X2JhY2t1cChzdHJ1Y3Qgb2NmczJfc3VwZXIgKm9zYiwNCiANCiAJaWYgKCFidWZmZXJfdXB0b2Rh
dGUoYmgpKSB7DQogCQlyZXQgPSAtRUlPOw0KLQkJcHV0X2JoKGJoKTsNCiAJCW1sb2dfZXJybm8o
cmV0KTsNCiAJfQ0KIA0KZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2RsbS9kbG1yZWNvdmVyeS5jIGIv
ZnMvb2NmczIvZGxtL2RsbXJlY292ZXJ5LmMNCmluZGV4IDAxZWJmZDAuLmQxNWIwNzEgMTAwNjQ0
DQotLS0gYS9mcy9vY2ZzMi9kbG0vZGxtcmVjb3ZlcnkuYw0KKysrIGIvZnMvb2NmczIvZGxtL2Rs
bXJlY292ZXJ5LmMNCkBAIC01NDAsNyArNTQwLDEwIEBAIG1hc3Rlcl9oZXJlOg0KIAkJLyogc3Vj
Y2VzcyEgIHNlZSBpZiBhbnkgb3RoZXIgbm9kZXMgbmVlZCByZWNvdmVyeSAqLw0KIAkJbWxvZygw
LCAiRE9ORSBtYXN0ZXJpbmcgcmVjb3Zlcnkgb2YgJXM6JXUgaGVyZSh0aGlzPSV1KSFcbiIsDQog
CQkgICAgIGRsbS0+bmFtZSwgZGxtLT5yZWNvLmRlYWRfbm9kZSwgZGxtLT5ub2RlX251bSk7DQot
CQlkbG1fcmVzZXRfcmVjb3ZlcnkoZGxtKTsNCisJCXNwaW5fbG9jaygmZGxtLT5zcGlubG9jayk7
DQorCQlfX2RsbV9yZXNldF9yZWNvdmVyeShkbG0pOw0KKwkJZGxtLT5yZWNvLnN0YXRlICY9IH5E
TE1fUkVDT19TVEFURV9GSU5BTElaRTsNCisJCXNwaW5fdW5sb2NrKCZkbG0tPnNwaW5sb2NrKTsN
CiAJfQ0KIAlkbG1fZW5kX3JlY292ZXJ5KGRsbSk7DQogDQpAQCAtNjk4LDYgKzcwMSwxNCBAQCBz
dGF0aWMgaW50IGRsbV9yZW1hc3Rlcl9sb2NrcyhzdHJ1Y3QgZGxtX2N0eHQgKmRsbSwgdTggZGVh
ZF9ub2RlKQ0KIAkJaWYgKGFsbF9ub2Rlc19kb25lKSB7DQogCQkJaW50IHJldDsNCiANCisJCQkv
KiBTZXQgdGhpcyBmbGFnIG9uIHJlY292ZXJ5IG1hc3RlciB0byBhdm9pZA0KKwkJCSAqIGEgbmV3
IHJlY292ZXJ5IGZvciBhbm90aGVyIGRlYWQgbm9kZSBzdGFydA0KKwkJCSAqIGJlZm9yZSB0aGUg
cmVjb3ZlcnkgaXMgbm90IGRvbmUuIFRoYXQgbWF5DQorCQkJICogY2F1c2UgcmVjb3ZlcnkgaHVu
Zy4qLw0KKwkJCXNwaW5fbG9jaygmZGxtLT5zcGlubG9jayk7DQorCQkJZGxtLT5yZWNvLnN0YXRl
IHw9IERMTV9SRUNPX1NUQVRFX0ZJTkFMSVpFOw0KKwkJCXNwaW5fdW5sb2NrKCZkbG0tPnNwaW5s
b2NrKTsNCisNCiAJCQkvKiBhbGwgbm9kZXMgYXJlIG5vdyBpbiBETE1fUkVDT19OT0RFX0RBVEFf
RE9ORSBzdGF0ZQ0KIAkgCQkgKiBqdXN0IHNlbmQgYSBmaW5hbGl6ZSBtZXNzYWdlIHRvIGV2ZXJ5
b25lIGFuZA0KIAkgCQkgKiBjbGVhbiB1cCAqLw0KQEAgLTE3NTIsMTMgKzE3NjMsMTMgQEAgc3Rh
dGljIGludCBkbG1fcHJvY2Vzc19yZWNvdmVyeV9kYXRhKHN0cnVjdCBkbG1fY3R4dCAqZGxtLA0K
IAkJCQkgICAgIHN0cnVjdCBkbG1fbWlncmF0YWJsZV9sb2NrcmVzICptcmVzKQ0KIHsNCiAJc3Ry
dWN0IGRsbV9taWdyYXRhYmxlX2xvY2sgKm1sOw0KLQlzdHJ1Y3QgbGlzdF9oZWFkICpxdWV1ZTsN
CisJc3RydWN0IGxpc3RfaGVhZCAqcXVldWUsICppdGVyOw0KIAlzdHJ1Y3QgbGlzdF9oZWFkICp0
bXBxID0gTlVMTDsNCiAJc3RydWN0IGRsbV9sb2NrICpuZXdsb2NrID0gTlVMTDsNCiAJc3RydWN0
IGRsbV9sb2Nrc3RhdHVzICpsa3NiID0gTlVMTDsNCiAJaW50IHJldCA9IDA7DQogCWludCBpLCBq
LCBiYWQ7DQotCXN0cnVjdCBkbG1fbG9jayAqbG9jayA9IE5VTEw7DQorCXN0cnVjdCBkbG1fbG9j
ayAqbG9jazsNCiAJdTggZnJvbSA9IE8yTk1fTUFYX05PREVTOw0KIAl1bnNpZ25lZCBpbnQgYWRk
ZWQgPSAwOw0KIAlfX2JlNjQgYzsNCkBAIC0xNzkzLDE0ICsxODA0LDE2IEBAIHN0YXRpYyBpbnQg
ZGxtX3Byb2Nlc3NfcmVjb3ZlcnlfZGF0YShzdHJ1Y3QgZGxtX2N0eHQgKmRsbSwNCiAJCQkvKiBN
SUdSQVRJT04gT05MWSEgKi8NCiAJCQlCVUdfT04oIShtcmVzLT5mbGFncyAmIERMTV9NUkVTX01J
R1JBVElPTikpOw0KIA0KKwkJCWxvY2sgPSBOVUxMOw0KIAkJCXNwaW5fbG9jaygmcmVzLT5zcGlu
bG9jayk7DQogCQkJZm9yIChqID0gRExNX0dSQU5URURfTElTVDsgaiA8PSBETE1fQkxPQ0tFRF9M
SVNUOyBqKyspIHsNCiAJCQkJdG1wcSA9IGRsbV9saXN0X2lkeF90b19wdHIocmVzLCBqKTsNCi0J
CQkJbGlzdF9mb3JfZWFjaF9lbnRyeShsb2NrLCB0bXBxLCBsaXN0KSB7DQotCQkJCQlpZiAobG9j
ay0+bWwuY29va2llICE9IG1sLT5jb29raWUpDQotCQkJCQkJbG9jayA9IE5VTEw7DQotCQkJCQll
bHNlDQorCQkJCWxpc3RfZm9yX2VhY2goaXRlciwgdG1wcSkgew0KKwkJCQkJbG9jayA9IGxpc3Rf
ZW50cnkoaXRlciwNCisJCQkJCQkgIHN0cnVjdCBkbG1fbG9jaywgbGlzdCk7DQorCQkJCQlpZiAo
bG9jay0+bWwuY29va2llID09IG1sLT5jb29raWUpDQogCQkJCQkJYnJlYWs7DQorCQkJCQlsb2Nr
ID0gTlVMTDsNCiAJCQkJfQ0KIAkJCQlpZiAobG9jaykNCiAJCQkJCWJyZWFrOw0KQEAgLTI4NzAs
OCArMjg4Myw4IEBAIGludCBkbG1fZmluYWxpemVfcmVjb19oYW5kbGVyKHN0cnVjdCBvMm5ldF9t
c2cgKm1zZywgdTMyIGxlbiwgdm9pZCAqZGF0YSwNCiAJCQkJQlVHKCk7DQogCQkJfQ0KIAkJCWRs
bS0+cmVjby5zdGF0ZSAmPSB+RExNX1JFQ09fU1RBVEVfRklOQUxJWkU7DQorCQkJX19kbG1fcmVz
ZXRfcmVjb3ZlcnkoZGxtKTsNCiAJCQlzcGluX3VubG9jaygmZGxtLT5zcGlubG9jayk7DQotCQkJ
ZGxtX3Jlc2V0X3JlY292ZXJ5KGRsbSk7DQogCQkJZGxtX2tpY2tfcmVjb3ZlcnlfdGhyZWFkKGRs
bSk7DQogCQkJYnJlYWs7DQogCQlkZWZhdWx0Og0KZGlmZiAtLWdpdCBhL2ZzL3JlaXNlcmZzL2Rp
ci5jIGIvZnMvcmVpc2VyZnMvZGlyLmMNCmluZGV4IDEzM2U5MzUuLjgwNDhlZWEgMTAwNjQ0DQot
LS0gYS9mcy9yZWlzZXJmcy9kaXIuYw0KKysrIGIvZnMvcmVpc2VyZnMvZGlyLmMNCkBAIC0xMjgs
NiArMTI4LDcgQEAgaW50IHJlaXNlcmZzX3JlYWRkaXJfZGVudHJ5KHN0cnVjdCBkZW50cnkgKmRl
bnRyeSwgdm9pZCAqZGlyZW50LA0KIAkJCQljaGFyICpkX25hbWU7DQogCQkJCW9mZl90IGRfb2Zm
Ow0KIAkJCQlpbm9fdCBkX2lubzsNCisJCQkJbG9mZl90IGN1cl9wb3MgPSBkZWhfb2Zmc2V0KGRl
aCk7DQogDQogCQkJCWlmICghZGVfdmlzaWJsZShkZWgpKQ0KIAkJCQkJLyogaXQgaXMgaGlkZGVu
IGVudHJ5ICovDQpAQCAtMjAwLDggKzIwMSw5IEBAIGludCByZWlzZXJmc19yZWFkZGlyX2RlbnRy
eShzdHJ1Y3QgZGVudHJ5ICpkZW50cnksIHZvaWQgKmRpcmVudCwNCiAJCQkJaWYgKGxvY2FsX2J1
ZiAhPSBzbWFsbF9idWYpIHsNCiAJCQkJCWtmcmVlKGxvY2FsX2J1Zik7DQogCQkJCX0NCi0JCQkJ
Ly8gbmV4dCBlbnRyeSBzaG91bGQgYmUgbG9va2VkIGZvciB3aXRoIHN1Y2ggb2Zmc2V0DQotCQkJ
CW5leHRfcG9zID0gZGVoX29mZnNldChkZWgpICsgMTsNCisNCisJCQkJLyogZGVoX29mZnNldChk
ZWgpIG1heSBiZSBpbnZhbGlkIG5vdy4gKi8NCisJCQkJbmV4dF9wb3MgPSBjdXJfcG9zICsgMTsN
CiANCiAJCQkJaWYgKGl0ZW1fbW92ZWQoJnRtcF9paCwgJnBhdGhfdG9fZW50cnkpKSB7DQogCQkJ
CQlnb3RvIHJlc2VhcmNoOw0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc2NoZWQuaCBiL2lu
Y2x1ZGUvbGludXgvc2NoZWQuaA0KaW5kZXggYzE3ZmRmYi4uY2IzNGZmNCAxMDA2NDQNCi0tLSBh
L2luY2x1ZGUvbGludXgvc2NoZWQuaA0KKysrIGIvaW5jbHVkZS9saW51eC9zY2hlZC5oDQpAQCAt
MTY5MCw2ICsxNjkwLDI0IEBAIHN0YXRpYyBpbmxpbmUgcGlkX3QgdGFza190Z2lkX3ZucihzdHJ1
Y3QgdGFza19zdHJ1Y3QgKnRzaykNCiB9DQogDQogDQorc3RhdGljIGludCBwaWRfYWxpdmUoY29u
c3Qgc3RydWN0IHRhc2tfc3RydWN0ICpwKTsNCitzdGF0aWMgaW5saW5lIHBpZF90IHRhc2tfcHBp
ZF9ucl9ucyhjb25zdCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzaywgc3RydWN0IHBpZF9uYW1lc3Bh
Y2UgKm5zKQ0KK3sNCisJcGlkX3QgcGlkID0gMDsNCisNCisJcmN1X3JlYWRfbG9jaygpOw0KKwlp
ZiAocGlkX2FsaXZlKHRzaykpDQorCQlwaWQgPSB0YXNrX3RnaWRfbnJfbnMocmN1X2RlcmVmZXJl
bmNlKHRzay0+cmVhbF9wYXJlbnQpLCBucyk7DQorCXJjdV9yZWFkX3VubG9jaygpOw0KKw0KKwly
ZXR1cm4gcGlkOw0KK30NCisNCitzdGF0aWMgaW5saW5lIHBpZF90IHRhc2tfcHBpZF9ucihjb25z
dCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzaykNCit7DQorCXJldHVybiB0YXNrX3BwaWRfbnJfbnMo
dHNrLCAmaW5pdF9waWRfbnMpOw0KK30NCisNCiBzdGF0aWMgaW5saW5lIHBpZF90IHRhc2tfcGdy
cF9ucl9ucyhzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzaywNCiAJCQkJCXN0cnVjdCBwaWRfbmFtZXNw
YWNlICpucykNCiB7DQpAQCAtMTcyNyw3ICsxNzQ1LDcgQEAgc3RhdGljIGlubGluZSBwaWRfdCB0
YXNrX3BncnBfbnIoc3RydWN0IHRhc2tfc3RydWN0ICp0c2spDQogICogSWYgcGlkX2FsaXZlIGZh
aWxzLCB0aGVuIHBvaW50ZXJzIHdpdGhpbiB0aGUgdGFzayBzdHJ1Y3R1cmUNCiAgKiBjYW4gYmUg
c3RhbGUgYW5kIG11c3Qgbm90IGJlIGRlcmVmZXJlbmNlZC4NCiAgKi8NCi1zdGF0aWMgaW5saW5l
IGludCBwaWRfYWxpdmUoc3RydWN0IHRhc2tfc3RydWN0ICpwKQ0KK3N0YXRpYyBpbmxpbmUgaW50
IHBpZF9hbGl2ZShjb25zdCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnApDQogew0KIAlyZXR1cm4gcC0+
cGlkc1tQSURUWVBFX1BJRF0ucGlkICE9IE5VTEw7DQogfQ0KZGlmZiAtLWdpdCBhL2luY2x1ZGUv
dHJhY2UvZXZlbnRzL2Jsb2NrLmggYi9pbmNsdWRlL3RyYWNlL2V2ZW50cy9ibG9jay5oDQppbmRl
eCAwNWM1ZTYxLi4wNDhlMjY1IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS90cmFjZS9ldmVudHMvYmxv
Y2suaA0KKysrIGIvaW5jbHVkZS90cmFjZS9ldmVudHMvYmxvY2suaA0KQEAgLTgxLDYgKzgxLDcg
QEAgREVGSU5FX0VWRU5UKGJsb2NrX3JxX3dpdGhfZXJyb3IsIGJsb2NrX3JxX3JlcXVldWUsDQog
ICogYmxvY2tfcnFfY29tcGxldGUgLSBibG9jayBJTyBvcGVyYXRpb24gY29tcGxldGVkIGJ5IGRl
dmljZSBkcml2ZXINCiAgKiBAcTogcXVldWUgY29udGFpbmluZyB0aGUgYmxvY2sgb3BlcmF0aW9u
IHJlcXVlc3QNCiAgKiBAcnE6IGJsb2NrIG9wZXJhdGlvbnMgcmVxdWVzdA0KKyAqIEBucl9ieXRl
czogbnVtYmVyIG9mIGNvbXBsZXRlZCBieXRlcw0KICAqDQogICogVGhlIGJsb2NrX3JxX2NvbXBs
ZXRlIHRyYWNlcG9pbnQgZXZlbnQgaW5kaWNhdGVzIHRoYXQgc29tZSBwb3J0aW9uDQogICogb2Yg
b3BlcmF0aW9uIHJlcXVlc3QgaGFzIGJlZW4gY29tcGxldGVkIGJ5IHRoZSBkZXZpY2UgZHJpdmVy
LiAgSWYNCkBAIC04OCwxMSArODksMzcgQEAgREVGSU5FX0VWRU5UKGJsb2NrX3JxX3dpdGhfZXJy
b3IsIGJsb2NrX3JxX3JlcXVldWUsDQogICogZG8gZm9yIHRoZSByZXF1ZXN0LiBJZiBAcnEtPmJp
byBpcyBub24tTlVMTCB0aGVuIHRoZXJlIGlzDQogICogYWRkaXRpb25hbCB3b3JrIHJlcXVpcmVk
IHRvIGNvbXBsZXRlIHRoZSByZXF1ZXN0Lg0KICAqLw0KLURFRklORV9FVkVOVChibG9ja19ycV93
aXRoX2Vycm9yLCBibG9ja19ycV9jb21wbGV0ZSwNCitUUkFDRV9FVkVOVChibG9ja19ycV9jb21w
bGV0ZSwNCiANCi0JVFBfUFJPVE8oc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCByZXF1
ZXN0ICpycSksDQorCVRQX1BST1RPKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgcmVx
dWVzdCAqcnEsDQorCQkgdW5zaWduZWQgaW50IG5yX2J5dGVzKSwNCiANCi0JVFBfQVJHUyhxLCBy
cSkNCisJVFBfQVJHUyhxLCBycSwgbnJfYnl0ZXMpLA0KKw0KKwlUUF9TVFJVQ1RfX2VudHJ5KA0K
KwkJX19maWVsZCggIGRldl90LAlkZXYJCQkpDQorCQlfX2ZpZWxkKCAgc2VjdG9yX3QsCXNlY3Rv
cgkJCSkNCisJCV9fZmllbGQoICB1bnNpZ25lZCBpbnQsCW5yX3NlY3RvcgkJKQ0KKwkJX19maWVs
ZCggIGludCwJCWVycm9ycwkJCSkNCisJCV9fYXJyYXkoICBjaGFyLAkJcndicywJUldCU19MRU4J
KQ0KKwkJX19keW5hbWljX2FycmF5KCBjaGFyLAljbWQsCWJsa19jbWRfYnVmX2xlbihycSkJKQ0K
KwkpLA0KKw0KKwlUUF9mYXN0X2Fzc2lnbigNCisJCV9fZW50cnktPmRldgkgICA9IHJxLT5ycV9k
aXNrID8gZGlza19kZXZ0KHJxLT5ycV9kaXNrKSA6IDA7DQorCQlfX2VudHJ5LT5zZWN0b3IgICAg
PSBibGtfcnFfcG9zKHJxKTsNCisJCV9fZW50cnktPm5yX3NlY3RvciA9IG5yX2J5dGVzID4+IDk7
DQorCQlfX2VudHJ5LT5lcnJvcnMgICAgPSBycS0+ZXJyb3JzOw0KKw0KKwkJYmxrX2ZpbGxfcndi
cyhfX2VudHJ5LT5yd2JzLCBycS0+Y21kX2ZsYWdzLCBucl9ieXRlcyk7DQorCQlibGtfZHVtcF9j
bWQoX19nZXRfc3RyKGNtZCksIHJxKTsNCisJKSwNCisNCisJVFBfcHJpbnRrKCIlZCwlZCAlcyAo
JXMpICVsbHUgKyAldSBbJWRdIiwNCisJCSAgTUFKT1IoX19lbnRyeS0+ZGV2KSwgTUlOT1IoX19l
bnRyeS0+ZGV2KSwNCisJCSAgX19lbnRyeS0+cndicywgX19nZXRfc3RyKGNtZCksDQorCQkgICh1
bnNpZ25lZCBsb25nIGxvbmcpX19lbnRyeS0+c2VjdG9yLA0KKwkJICBfX2VudHJ5LT5ucl9zZWN0
b3IsIF9fZW50cnktPmVycm9ycykNCiApOw0KIA0KIERFQ0xBUkVfRVZFTlRfQ0xBU1MoYmxvY2tf
cnEsDQpkaWZmIC0tZ2l0IGEva2VybmVsL2F1ZGl0c2MuYyBiL2tlcm5lbC9hdWRpdHNjLmMNCmlu
ZGV4IDQ3YjdmYzEuLmFlYWM3Y2MgMTAwNjQ0DQotLS0gYS9rZXJuZWwvYXVkaXRzYy5jDQorKysg
Yi9rZXJuZWwvYXVkaXRzYy5jDQpAQCAtNDczLDcgKzQ3Myw3IEBAIHN0YXRpYyBpbnQgYXVkaXRf
ZmlsdGVyX3J1bGVzKHN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrLA0KIAkJY2FzZSBBVURJVF9QUElE
Og0KIAkJCWlmIChjdHgpIHsNCiAJCQkJaWYgKCFjdHgtPnBwaWQpDQotCQkJCQljdHgtPnBwaWQg
PSBzeXNfZ2V0cHBpZCgpOw0KKwkJCQkJY3R4LT5wcGlkID0gdGFza19wcGlkX25yKHRzayk7DQog
CQkJCXJlc3VsdCA9IGF1ZGl0X2NvbXBhcmF0b3IoY3R4LT5wcGlkLCBmLT5vcCwgZi0+dmFsKTsN
CiAJCQl9DQogCQkJYnJlYWs7DQpAQCAtMTMzNSw3ICsxMzM1LDcgQEAgc3RhdGljIHZvaWQgYXVk
aXRfbG9nX2V4aXQoc3RydWN0IGF1ZGl0X2NvbnRleHQgKmNvbnRleHQsIHN0cnVjdCB0YXNrX3N0
cnVjdCAqdHMNCiAJLyogdHNrID09IGN1cnJlbnQgKi8NCiAJY29udGV4dC0+cGlkID0gdHNrLT5w
aWQ7DQogCWlmICghY29udGV4dC0+cHBpZCkNCi0JCWNvbnRleHQtPnBwaWQgPSBzeXNfZ2V0cHBp
ZCgpOw0KKwkJY29udGV4dC0+cHBpZCA9IHRhc2tfcHBpZF9ucih0c2spOw0KIAljcmVkID0gY3Vy
cmVudF9jcmVkKCk7DQogCWNvbnRleHQtPnVpZCAgID0gY3JlZC0+dWlkOw0KIAljb250ZXh0LT5n
aWQgICA9IGNyZWQtPmdpZDsNCmRpZmYgLS1naXQgYS9rZXJuZWwvZXhpdC5jIGIva2VybmVsL2V4
aXQuYw0KaW5kZXggMjM0ZTE1Mi4uZmRlMTVmOSAxMDA2NDQNCi0tLSBhL2tlcm5lbC9leGl0LmMN
CisrKyBiL2tlcm5lbC9leGl0LmMNCkBAIC03MzQsOSArNzM0LDYgQEAgc3RhdGljIHZvaWQgcmVw
YXJlbnRfbGVhZGVyKHN0cnVjdCB0YXNrX3N0cnVjdCAqZmF0aGVyLCBzdHJ1Y3QgdGFza19zdHJ1
Y3QgKnAsDQogCQkJCXN0cnVjdCBsaXN0X2hlYWQgKmRlYWQpDQogew0KIAlsaXN0X21vdmVfdGFp
bCgmcC0+c2libGluZywgJnAtPnJlYWxfcGFyZW50LT5jaGlsZHJlbik7DQotDQotCWlmIChwLT5l
eGl0X3N0YXRlID09IEVYSVRfREVBRCkNCi0JCXJldHVybjsNCiAJLyoNCiAJICogSWYgdGhpcyBp
cyBhIHRocmVhZGVkIHJlcGFyZW50IHRoZXJlIGlzIG5vIG5lZWQgdG8NCiAJICogbm90aWZ5IGFu
eW9uZSBhbnl0aGluZyBoYXMgaGFwcGVuZWQuDQpAQCAtNzQ0LDkgKzc0MSwxOSBAQCBzdGF0aWMg
dm9pZCByZXBhcmVudF9sZWFkZXIoc3RydWN0IHRhc2tfc3RydWN0ICpmYXRoZXIsIHN0cnVjdCB0
YXNrX3N0cnVjdCAqcCwNCiAJaWYgKHNhbWVfdGhyZWFkX2dyb3VwKHAtPnJlYWxfcGFyZW50LCBm
YXRoZXIpKQ0KIAkJcmV0dXJuOw0KIA0KLQkvKiBXZSBkb24ndCB3YW50IHBlb3BsZSBzbGF5aW5n
IGluaXQuICAqLw0KKwkvKg0KKwkgKiBXZSBkb24ndCB3YW50IHBlb3BsZSBzbGF5aW5nIGluaXQu
DQorCSAqDQorCSAqIE5vdGU6IHdlIGRvIHRoaXMgZXZlbiBpZiBpdCBpcyBFWElUX0RFQUQsIHdh
aXRfdGFza196b21iaWUoKQ0KKwkgKiBjYW4gY2hhbmdlIC0+ZXhpdF9zdGF0ZSB0byBFWElUX1pP
TUJJRS4gSWYgdGhpcyBpcyB0aGUgZmluYWwNCisJICogc3RhdGUsIGRvX25vdGlmeV9wYXJlbnQo
KSB3YXMgYWxyZWFkeSBjYWxsZWQgYW5kIC0+ZXhpdF9zaWduYWwNCisJICogZG9lc24ndCBtYXR0
ZXIuDQorCSAqLw0KIAlwLT5leGl0X3NpZ25hbCA9IFNJR0NITEQ7DQogDQorCWlmIChwLT5leGl0
X3N0YXRlID09IEVYSVRfREVBRCkNCisJCXJldHVybjsNCisNCiAJLyogSWYgaXQgaGFzIGV4aXRl
ZCBub3RpZnkgdGhlIG5ldyBwYXJlbnQgYWJvdXQgdGhpcyBjaGlsZCdzIGRlYXRoLiAqLw0KIAlp
ZiAoIXAtPnB0cmFjZSAmJg0KIAkgICAgcC0+ZXhpdF9zdGF0ZSA9PSBFWElUX1pPTUJJRSAmJiB0
aHJlYWRfZ3JvdXBfZW1wdHkocCkpIHsNCmRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvYmxrdHJh
Y2UuYyBiL2tlcm5lbC90cmFjZS9ibGt0cmFjZS5jDQppbmRleCAxNmZjMzRhLi45MmNhYzA1IDEw
MDY0NA0KLS0tIGEva2VybmVsL3RyYWNlL2Jsa3RyYWNlLmMNCisrKyBiL2tlcm5lbC90cmFjZS9i
bGt0cmFjZS5jDQpAQCAtNjk5LDYgKzY5OSw3IEBAIHZvaWQgYmxrX3RyYWNlX3NodXRkb3duKHN0
cnVjdCByZXF1ZXN0X3F1ZXVlICpxKQ0KICAqIGJsa19hZGRfdHJhY2VfcnEgLSBBZGQgYSB0cmFj
ZSBmb3IgYSByZXF1ZXN0IG9yaWVudGVkIGFjdGlvbg0KICAqIEBxOgkJcXVldWUgdGhlIGlvIGlz
IGZvcg0KICAqIEBycToJCXRoZSBzb3VyY2UgcmVxdWVzdA0KKyAqIEBucl9ieXRlczoJbnVtYmVy
IG9mIGNvbXBsZXRlZCBieXRlcw0KICAqIEB3aGF0Ogl0aGUgYWN0aW9uDQogICoNCiAgKiBEZXNj
cmlwdGlvbjoNCkBAIC03MDYsNyArNzA3LDcgQEAgdm9pZCBibGtfdHJhY2Vfc2h1dGRvd24oc3Ry
dWN0IHJlcXVlc3RfcXVldWUgKnEpDQogICoNCiAgKiovDQogc3RhdGljIHZvaWQgYmxrX2FkZF90
cmFjZV9ycShzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHJlcXVlc3QgKnJxLA0KLQkJ
CSAgICAgdTMyIHdoYXQpDQorCQkJICAgICB1bnNpZ25lZCBpbnQgbnJfYnl0ZXMsIHUzMiB3aGF0
KQ0KIHsNCiAJc3RydWN0IGJsa190cmFjZSAqYnQgPSBxLT5ibGtfdHJhY2U7DQogDQpAQCAtNzE1
LDExICs3MTYsMTEgQEAgc3RhdGljIHZvaWQgYmxrX2FkZF90cmFjZV9ycShzdHJ1Y3QgcmVxdWVz
dF9xdWV1ZSAqcSwgc3RydWN0IHJlcXVlc3QgKnJxLA0KIA0KIAlpZiAocnEtPmNtZF90eXBlID09
IFJFUV9UWVBFX0JMT0NLX1BDKSB7DQogCQl3aGF0IHw9IEJMS19UQ19BQ1QoQkxLX1RDX1BDKTsN
Ci0JCV9fYmxrX2FkZF90cmFjZShidCwgMCwgYmxrX3JxX2J5dGVzKHJxKSwgcnEtPmNtZF9mbGFn
cywNCisJCV9fYmxrX2FkZF90cmFjZShidCwgMCwgbnJfYnl0ZXMsIHJxLT5jbWRfZmxhZ3MsDQog
CQkJCXdoYXQsIHJxLT5lcnJvcnMsIHJxLT5jbWRfbGVuLCBycS0+Y21kKTsNCiAJfSBlbHNlICB7
DQogCQl3aGF0IHw9IEJMS19UQ19BQ1QoQkxLX1RDX0ZTKTsNCi0JCV9fYmxrX2FkZF90cmFjZShi
dCwgYmxrX3JxX3BvcyhycSksIGJsa19ycV9ieXRlcyhycSksDQorCQlfX2Jsa19hZGRfdHJhY2Uo
YnQsIGJsa19ycV9wb3MocnEpLCBucl9ieXRlcywNCiAJCQkJcnEtPmNtZF9mbGFncywgd2hhdCwg
cnEtPmVycm9ycywgMCwgTlVMTCk7DQogCX0NCiB9DQpAQCAtNzI3LDMzICs3MjgsMzQgQEAgc3Rh
dGljIHZvaWQgYmxrX2FkZF90cmFjZV9ycShzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0
IHJlcXVlc3QgKnJxLA0KIHN0YXRpYyB2b2lkIGJsa19hZGRfdHJhY2VfcnFfYWJvcnQodm9pZCAq
aWdub3JlLA0KIAkJCQkgICBzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHJlcXVlc3Qg
KnJxKQ0KIHsNCi0JYmxrX2FkZF90cmFjZV9ycShxLCBycSwgQkxLX1RBX0FCT1JUKTsNCisJYmxr
X2FkZF90cmFjZV9ycShxLCBycSwgYmxrX3JxX2J5dGVzKHJxKSwgQkxLX1RBX0FCT1JUKTsNCiB9
DQogDQogc3RhdGljIHZvaWQgYmxrX2FkZF90cmFjZV9ycV9pbnNlcnQodm9pZCAqaWdub3JlLA0K
IAkJCQkgICAgc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCByZXF1ZXN0ICpycSkNCiB7
DQotCWJsa19hZGRfdHJhY2VfcnEocSwgcnEsIEJMS19UQV9JTlNFUlQpOw0KKwlibGtfYWRkX3Ry
YWNlX3JxKHEsIHJxLCBibGtfcnFfYnl0ZXMocnEpLCBCTEtfVEFfSU5TRVJUKTsNCiB9DQogDQog
c3RhdGljIHZvaWQgYmxrX2FkZF90cmFjZV9ycV9pc3N1ZSh2b2lkICppZ25vcmUsDQogCQkJCSAg
IHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgcmVxdWVzdCAqcnEpDQogew0KLQlibGtf
YWRkX3RyYWNlX3JxKHEsIHJxLCBCTEtfVEFfSVNTVUUpOw0KKwlibGtfYWRkX3RyYWNlX3JxKHEs
IHJxLCBibGtfcnFfYnl0ZXMocnEpLCBCTEtfVEFfSVNTVUUpOw0KIH0NCiANCiBzdGF0aWMgdm9p
ZCBibGtfYWRkX3RyYWNlX3JxX3JlcXVldWUodm9pZCAqaWdub3JlLA0KIAkJCQkgICAgIHN0cnVj
dCByZXF1ZXN0X3F1ZXVlICpxLA0KIAkJCQkgICAgIHN0cnVjdCByZXF1ZXN0ICpycSkNCiB7DQot
CWJsa19hZGRfdHJhY2VfcnEocSwgcnEsIEJMS19UQV9SRVFVRVVFKTsNCisJYmxrX2FkZF90cmFj
ZV9ycShxLCBycSwgYmxrX3JxX2J5dGVzKHJxKSwgQkxLX1RBX1JFUVVFVUUpOw0KIH0NCiANCiBz
dGF0aWMgdm9pZCBibGtfYWRkX3RyYWNlX3JxX2NvbXBsZXRlKHZvaWQgKmlnbm9yZSwNCiAJCQkJ
ICAgICAgc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsDQotCQkJCSAgICAgIHN0cnVjdCByZXF1ZXN0
ICpycSkNCisJCQkJICAgICAgc3RydWN0IHJlcXVlc3QgKnJxLA0KKwkJCQkgICAgICB1bnNpZ25l
ZCBpbnQgbnJfYnl0ZXMpDQogew0KLQlibGtfYWRkX3RyYWNlX3JxKHEsIHJxLCBCTEtfVEFfQ09N
UExFVEUpOw0KKwlibGtfYWRkX3RyYWNlX3JxKHEsIHJxLCBucl9ieXRlcywgQkxLX1RBX0NPTVBM
RVRFKTsNCiB9DQogDQogLyoqDQpkaWZmIC0tZ2l0IGEvbGliL25sYXR0ci5jIGIvbGliL25sYXR0
ci5jDQppbmRleCBhODQwOGI2Li4xOTBhZTEwIDEwMDY0NA0KLS0tIGEvbGliL25sYXR0ci5jDQor
KysgYi9saWIvbmxhdHRyLmMNCkBAIC0yOTksOSArMjk5LDE1IEBAIGludCBubGFfbWVtY21wKGNv
bnN0IHN0cnVjdCBubGF0dHIgKm5sYSwgY29uc3Qgdm9pZCAqZGF0YSwNCiAgKi8NCiBpbnQgbmxh
X3N0cmNtcChjb25zdCBzdHJ1Y3QgbmxhdHRyICpubGEsIGNvbnN0IGNoYXIgKnN0cikNCiB7DQot
CWludCBsZW4gPSBzdHJsZW4oc3RyKSArIDE7DQotCWludCBkID0gbmxhX2xlbihubGEpIC0gbGVu
Ow0KKwlpbnQgbGVuID0gc3RybGVuKHN0cik7DQorCWNoYXIgKmJ1ZiA9IG5sYV9kYXRhKG5sYSk7
DQorCWludCBhdHRybGVuID0gbmxhX2xlbihubGEpOw0KKwlpbnQgZDsNCiANCisJaWYgKGF0dHJs
ZW4gPiAwICYmIGJ1ZlthdHRybGVuIC0gMV0gPT0gJ1wwJykNCisJCWF0dHJsZW4tLTsNCisNCisJ
ZCA9IGF0dHJsZW4gLSBsZW47DQogCWlmIChkID09IDApDQogCQlkID0gbWVtY21wKG5sYV9kYXRh
KG5sYSksIHN0ciwgbGVuKTsNCiANCmRpZmYgLS1naXQgYS9saWIvcGVyY3B1X2NvdW50ZXIuYyBi
L2xpYi9wZXJjcHVfY291bnRlci5jDQppbmRleCBmOGEzZjFhLi4zMzQ1OWUwIDEwMDY0NA0KLS0t
IGEvbGliL3BlcmNwdV9jb3VudGVyLmMNCisrKyBiL2xpYi9wZXJjcHVfY291bnRlci5jDQpAQCAt
MTY2LDcgKzE2Niw3IEBAIHN0YXRpYyBpbnQgX19jcHVpbml0IHBlcmNwdV9jb3VudGVyX2hvdGNw
dV9jYWxsYmFjayhzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iLA0KIAlzdHJ1Y3QgcGVyY3B1X2Nv
dW50ZXIgKmZiYzsNCiANCiAJY29tcHV0ZV9iYXRjaF92YWx1ZSgpOw0KLQlpZiAoYWN0aW9uICE9
IENQVV9ERUFEKQ0KKwlpZiAoYWN0aW9uICE9IENQVV9ERUFEICYmIGFjdGlvbiAhPSBDUFVfREVB
RF9GUk9aRU4pDQogCQlyZXR1cm4gTk9USUZZX09LOw0KIA0KIAljcHUgPSAodW5zaWduZWQgbG9u
ZyloY3B1Ow0KZGlmZiAtLWdpdCBhL21tL2h1Z2V0bGIuYyBiL21tL2h1Z2V0bGIuYw0KaW5kZXgg
M2E1YWFlMi4uZDM5OWY1ZiAxMDA2NDQNCi0tLSBhL21tL2h1Z2V0bGIuYw0KKysrIGIvbW0vaHVn
ZXRsYi5jDQpAQCAtMTQ0Nyw2ICsxNDQ3LDcgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgc2V0X21h
eF9odWdlX3BhZ2VzKHN0cnVjdCBoc3RhdGUgKmgsIHVuc2lnbmVkIGxvbmcgY291bnQsDQogCXdo
aWxlIChtaW5fY291bnQgPCBwZXJzaXN0ZW50X2h1Z2VfcGFnZXMoaCkpIHsNCiAJCWlmICghZnJl
ZV9wb29sX2h1Z2VfcGFnZShoLCBub2Rlc19hbGxvd2VkLCAwKSkNCiAJCQlicmVhazsNCisJCWNv
bmRfcmVzY2hlZF9sb2NrKCZodWdldGxiX2xvY2spOw0KIAl9DQogCXdoaWxlIChjb3VudCA8IHBl
cnNpc3RlbnRfaHVnZV9wYWdlcyhoKSkgew0KIAkJaWYgKCFhZGp1c3RfcG9vbF9zdXJwbHVzKGgs
IG5vZGVzX2FsbG93ZWQsIDEpKQ0KZGlmZiAtLWdpdCBhL21tL21sb2NrLmMgYi9tbS9tbG9jay5j
DQppbmRleCA0ZjRmNTNiLi4zOWIzYTdkIDEwMDY0NA0KLS0tIGEvbW0vbWxvY2suYw0KKysrIGIv
bW0vbWxvY2suYw0KQEAgLTc4LDYgKzc4LDcgQEAgdm9pZCBfX2NsZWFyX3BhZ2VfbWxvY2soc3Ry
dWN0IHBhZ2UgKnBhZ2UpDQogICovDQogdm9pZCBtbG9ja192bWFfcGFnZShzdHJ1Y3QgcGFnZSAq
cGFnZSkNCiB7DQorCS8qIFNlcmlhbGl6ZSB3aXRoIHBhZ2UgbWlncmF0aW9uICovDQogCUJVR19P
TighUGFnZUxvY2tlZChwYWdlKSk7DQogDQogCWlmICghVGVzdFNldFBhZ2VNbG9ja2VkKHBhZ2Up
KSB7DQpAQCAtMTA1LDYgKzEwNiw3IEBAIHZvaWQgbWxvY2tfdm1hX3BhZ2Uoc3RydWN0IHBhZ2Ug
KnBhZ2UpDQogICovDQogdm9pZCBtdW5sb2NrX3ZtYV9wYWdlKHN0cnVjdCBwYWdlICpwYWdlKQ0K
IHsNCisJLyogRm9yIHRyeV90b19tdW5sb2NrKCkgYW5kIHRvIHNlcmlhbGl6ZSB3aXRoIHBhZ2Ug
bWlncmF0aW9uICovDQogCUJVR19PTighUGFnZUxvY2tlZChwYWdlKSk7DQogDQogCWlmIChUZXN0
Q2xlYXJQYWdlTWxvY2tlZChwYWdlKSkgew0KZGlmZiAtLWdpdCBhL21tL3JtYXAuYyBiL21tL3Jt
YXAuYw0KaW5kZXggNTJhMmYzNi4uOWFjNDA1YiAxMDA2NDQNCi0tLSBhL21tL3JtYXAuYw0KKysr
IGIvbW0vcm1hcC5jDQpAQCAtMTM4NSw5ICsxMzg1LDE5IEBAIHN0YXRpYyBpbnQgdHJ5X3RvX3Vu
bWFwX2NsdXN0ZXIodW5zaWduZWQgbG9uZyBjdXJzb3IsIHVuc2lnbmVkIGludCAqbWFwY291bnQs
DQogCQlCVUdfT04oIXBhZ2UgfHwgUGFnZUFub24ocGFnZSkpOw0KIA0KIAkJaWYgKGxvY2tlZF92
bWEpIHsNCi0JCQltbG9ja192bWFfcGFnZShwYWdlKTsgICAvKiBuby1vcCBpZiBhbHJlYWR5IG1s
b2NrZWQgKi8NCi0JCQlpZiAocGFnZSA9PSBjaGVja19wYWdlKQ0KKwkJCWlmIChwYWdlID09IGNo
ZWNrX3BhZ2UpIHsNCisJCQkJLyogd2Uga25vdyB3ZSBoYXZlIGNoZWNrX3BhZ2UgbG9ja2VkICov
DQorCQkJCW1sb2NrX3ZtYV9wYWdlKHBhZ2UpOw0KIAkJCQlyZXQgPSBTV0FQX01MT0NLOw0KKwkJ
CX0gZWxzZSBpZiAodHJ5bG9ja19wYWdlKHBhZ2UpKSB7DQorCQkJCS8qDQorCQkJCSAqIElmIHdl
IGNhbiBsb2NrIHRoZSBwYWdlLCBwZXJmb3JtIG1sb2NrLg0KKwkJCQkgKiBPdGhlcndpc2UgbGVh
dmUgdGhlIHBhZ2UgYWxvbmUsIGl0IHdpbGwgYmUNCisJCQkJICogZXZlbnR1YWxseSBlbmNvdW50
ZXJlZCBhZ2FpbiBsYXRlci4NCisJCQkJICovDQorCQkJCW1sb2NrX3ZtYV9wYWdlKHBhZ2UpOw0K
KwkJCQl1bmxvY2tfcGFnZShwYWdlKTsNCisJCQl9DQogCQkJY29udGludWU7CS8qIGRvbid0IHVu
bWFwICovDQogCQl9DQogDQpkaWZmIC0tZ2l0IGEvbmV0LzgwMjFxL3ZsYW5fZGV2LmMgYi9uZXQv
ODAyMXEvdmxhbl9kZXYuYw0KaW5kZXggNDhhNjJkOC4uYzQzYTc4OCAxMDA2NDQNCi0tLSBhL25l
dC84MDIxcS92bGFuX2Rldi5jDQorKysgYi9uZXQvODAyMXEvdmxhbl9kZXYuYw0KQEAgLTUyOSw2
ICs1MjksOSBAQCBzdGF0aWMgaW50IHZsYW5fcGFzc3RocnVfaGFyZF9oZWFkZXIoc3RydWN0IHNr
X2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKmRldg0KIHsNCiAJc3RydWN0IG5ldF9kZXZp
Y2UgKnJlYWxfZGV2ID0gdmxhbl9kZXZfaW5mbyhkZXYpLT5yZWFsX2RldjsNCiANCisJaWYgKHNh
ZGRyID09IE5VTEwpDQorCQlzYWRkciA9IGRldi0+ZGV2X2FkZHI7DQorDQogCXJldHVybiBkZXZf
aGFyZF9oZWFkZXIoc2tiLCByZWFsX2RldiwgdHlwZSwgZGFkZHIsIHNhZGRyLCBsZW4pOw0KIH0N
CiANCmRpZmYgLS1naXQgYS9uZXQvYnJpZGdlL2JyX211bHRpY2FzdC5jIGIvbmV0L2JyaWRnZS9i
cl9tdWx0aWNhc3QuYw0KaW5kZXggMjE1Nzk4NC4uMzk4YTI5NyAxMDA2NDQNCi0tLSBhL25ldC9i
cmlkZ2UvYnJfbXVsdGljYXN0LmMNCisrKyBiL25ldC9icmlkZ2UvYnJfbXVsdGljYXN0LmMNCkBA
IC0xMTM4LDYgKzExMzgsMTIgQEAgc3RhdGljIGludCBicl9pcDZfbXVsdGljYXN0X3F1ZXJ5KHN0
cnVjdCBuZXRfYnJpZGdlICpiciwNCiANCiAJYnJfbXVsdGljYXN0X3F1ZXJ5X3JlY2VpdmVkKGJy
LCBwb3J0LCAhaXB2Nl9hZGRyX2FueSgmaXA2aC0+c2FkZHIpKTsNCiANCisJLyogUkZDMjcxMCtS
RkMzODEwIChNTER2MStNTER2MikgcmVxdWlyZSBsaW5rLWxvY2FsIHNvdXJjZSBhZGRyZXNzZXMg
Ki8NCisJaWYgKCEoaXB2Nl9hZGRyX3R5cGUoJmlwNmgtPnNhZGRyKSAmIElQVjZfQUREUl9MSU5L
TE9DQUwpKSB7DQorCQllcnIgPSAtRUlOVkFMOw0KKwkJZ290byBvdXQ7DQorCX0NCisNCiAJaWYg
KHNrYi0+bGVuID09IHNpemVvZigqbWxkKSkgew0KIAkJaWYgKCFwc2tiX21heV9wdWxsKHNrYiwg
c2l6ZW9mKCptbGQpKSkgew0KIAkJCWVyciA9IC1FSU5WQUw7DQpkaWZmIC0tZ2l0IGEvbmV0L2lw
djYvYWRkcmNvbmYuYyBiL25ldC9pcHY2L2FkZHJjb25mLmMNCmluZGV4IDVkNDEyOTMuLmI5ZWRm
ZjAgMTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni9hZGRyY29uZi5jDQorKysgYi9uZXQvaXB2Ni9hZGRy
Y29uZi5jDQpAQCAtOTAwLDggKzkwMCwxMSBAQCByZXRyeToNCiAJICogTGlmZXRpbWUgaXMgZ3Jl
YXRlciB0aGFuIFJFR0VOX0FEVkFOQ0UgdGltZSB1bml0cy4gIEluIHBhcnRpY3VsYXIsDQogCSAq
IGFuIGltcGxlbWVudGF0aW9uIG11c3Qgbm90IGNyZWF0ZSBhIHRlbXBvcmFyeSBhZGRyZXNzIHdp
dGggYSB6ZXJvDQogCSAqIFByZWZlcnJlZCBMaWZldGltZS4NCisJICogVXNlIGFnZSBjYWxjdWxh
dGlvbiBhcyBpbiBhZGRyY29uZl92ZXJpZnkgdG8gYXZvaWQgdW5uZWNlc3NhcnkNCisJICogdGVt
cG9yYXJ5IGFkZHJlc3NlcyBiZWluZyBnZW5lcmF0ZWQuDQogCSAqLw0KLQlpZiAodG1wX3ByZWZl
cmVkX2xmdCA8PSByZWdlbl9hZHZhbmNlKSB7DQorCWFnZSA9IChub3cgLSB0bXBfdHN0YW1wICsg
QUREUkNPTkZfVElNRVJfRlVaWl9NSU5VUykgLyBIWjsNCisJaWYgKHRtcF9wcmVmZXJlZF9sZnQg
PD0gcmVnZW5fYWR2YW5jZSArIGFnZSkgew0KIAkJaW42X2lmYV9wdXQoaWZwKTsNCiAJCWluNl9k
ZXZfcHV0KGlkZXYpOw0KIAkJcmV0ID0gLTE7DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvaWNtcC5j
IGIvbmV0L2lwdjYvaWNtcC5jDQppbmRleCBkNTA1NDUzLi5jZWNlZDY3IDEwMDY0NA0KLS0tIGEv
bmV0L2lwdjYvaWNtcC5jDQorKysgYi9uZXQvaXB2Ni9pY21wLmMNCkBAIC00OTksNyArNDk5LDcg
QEAgdm9pZCBpY21wdjZfc2VuZChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCB1OCB0eXBlLCB1OCBjb2Rl
LCBfX3UzMiBpbmZvKQ0KIAkJCSAgICAgIG5wLT50Y2xhc3MsIE5VTEwsICZmbDYsIChzdHJ1Y3Qg
cnQ2X2luZm8qKWRzdCwNCiAJCQkgICAgICBNU0dfRE9OVFdBSVQsIG5wLT5kb250ZnJhZyk7DQog
CWlmIChlcnIpIHsNCi0JCUlDTVA2X0lOQ19TVEFUU19CSChuZXQsIGlkZXYsIElDTVA2X01JQl9P
VVRFUlJPUlMpOw0KKwkJSUNNUDZfSU5DX1NUQVRTKG5ldCwgaWRldiwgSUNNUDZfTUlCX09VVEVS
Uk9SUyk7DQogCQlpcDZfZmx1c2hfcGVuZGluZ19mcmFtZXMoc2spOw0KIAl9IGVsc2Ugew0KIAkJ
ZXJyID0gaWNtcHY2X3B1c2hfcGVuZGluZ19mcmFtZXMoc2ssICZmbDYsICZ0bXBfaGRyLA0KZGlm
ZiAtLWdpdCBhL25ldC9pcHY2L2lwNl9vdXRwdXQuYyBiL25ldC9pcHY2L2lwNl9vdXRwdXQuYw0K
aW5kZXggY2Q0YjUyOS4uNzg3MWNjNiAxMDA2NDQNCi0tLSBhL25ldC9pcHY2L2lwNl9vdXRwdXQu
Yw0KKysrIGIvbmV0L2lwdjYvaXA2X291dHB1dC5jDQpAQCAtMTE5MSwyMSArMTE5MSwxOSBAQCBz
dGF0aWMgdm9pZCBpcDZfYXBwZW5kX2RhdGFfbXR1KHVuc2lnbmVkIGludCAqbXR1LA0KIAkJCQl1
bnNpZ25lZCBpbnQgZnJhZ2hlYWRlcmxlbiwNCiAJCQkJc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJ
CQkJc3RydWN0IHJ0Nl9pbmZvICpydCwNCi0JCQkJYm9vbCBwbXR1cHJvYmUpDQorCQkJCXVuc2ln
bmVkIGludCBvcmlnX210dSkNCiB7DQogCWlmICghKHJ0LT5kc3QuZmxhZ3MgJiBEU1RfWEZSTV9U
VU5ORUwpKSB7DQogCQlpZiAoc2tiID09IE5VTEwpIHsNCiAJCQkvKiBmaXJzdCBmcmFnbWVudCwg
cmVzZXJ2ZSBoZWFkZXJfbGVuICovDQotCQkJKm10dSA9ICptdHUgLSBydC0+ZHN0LmhlYWRlcl9s
ZW47DQorCQkJKm10dSA9IG9yaWdfbXR1IC0gcnQtPmRzdC5oZWFkZXJfbGVuOw0KIA0KIAkJfSBl
bHNlIHsNCiAJCQkvKg0KIAkJCSAqIHRoaXMgZnJhZ21lbnQgaXMgbm90IGZpcnN0LCB0aGUgaGVh
ZGVycw0KIAkJCSAqIHNwYWNlIGlzIHJlZ2FyZGVkIGFzIGRhdGEgc3BhY2UuDQogCQkJICovDQot
CQkJKm10dSA9IG1pbigqbXR1LCBwbXR1cHJvYmUgPw0KLQkJCQkgICBydC0+ZHN0LmRldi0+bXR1
IDoNCi0JCQkJICAgZHN0X210dShydC0+ZHN0LnBhdGgpKTsNCisJCQkqbXR1ID0gb3JpZ19tdHU7
DQogCQl9DQogCQkqbWF4ZnJhZ2xlbiA9ICgoKm10dSAtIGZyYWdoZWFkZXJsZW4pICYgfjcpDQog
CQkJICAgICAgKyBmcmFnaGVhZGVybGVuIC0gc2l6ZW9mKHN0cnVjdCBmcmFnX2hkcik7DQpAQCAt
MTIyMiw3ICsxMjIwLDcgQEAgaW50IGlwNl9hcHBlbmRfZGF0YShzdHJ1Y3Qgc29jayAqc2ssIGlu
dCBnZXRmcmFnKHZvaWQgKmZyb20sIGNoYXIgKnRvLA0KIAlzdHJ1Y3QgaXB2Nl9waW5mbyAqbnAg
PSBpbmV0Nl9zayhzayk7DQogCXN0cnVjdCBpbmV0X2NvcmsgKmNvcms7DQogCXN0cnVjdCBza19i
dWZmICpza2IsICpza2JfcHJldiA9IE5VTEw7DQotCXVuc2lnbmVkIGludCBtYXhmcmFnbGVuLCBm
cmFnaGVhZGVybGVuLCBtdHU7DQorCXVuc2lnbmVkIGludCBtYXhmcmFnbGVuLCBmcmFnaGVhZGVy
bGVuLCBtdHUsIG9yaWdfbXR1Ow0KIAlpbnQgZXh0aGRybGVuOw0KIAlpbnQgZHN0X2V4dGhkcmxl
bjsNCiAJaW50IGhoX2xlbjsNCkBAIC0xMzA3LDYgKzEzMDUsNyBAQCBpbnQgaXA2X2FwcGVuZF9k
YXRhKHN0cnVjdCBzb2NrICpzaywgaW50IGdldGZyYWcodm9pZCAqZnJvbSwgY2hhciAqdG8sDQog
CQlkc3RfZXh0aGRybGVuID0gMDsNCiAJCW10dSA9IGNvcmstPmZyYWdzaXplOw0KIAl9DQorCW9y
aWdfbXR1ID0gbXR1Ow0KIA0KIAloaF9sZW4gPSBMTF9SRVNFUlZFRF9TUEFDRShydC0+ZHN0LmRl
dik7DQogDQpAQCAtMTM4OSw4ICsxMzg4LDcgQEAgYWxsb2NfbmV3X3NrYjoNCiAJCQlpZiAoc2ti
ID09IE5VTEwgfHwgc2tiX3ByZXYgPT0gTlVMTCkNCiAJCQkJaXA2X2FwcGVuZF9kYXRhX210dSgm
bXR1LCAmbWF4ZnJhZ2xlbiwNCiAJCQkJCQkgICAgZnJhZ2hlYWRlcmxlbiwgc2tiLCBydCwNCi0J
CQkJCQkgICAgbnAtPnBtdHVkaXNjID09DQotCQkJCQkJICAgIElQVjZfUE1UVURJU0NfUFJPQkUp
Ow0KKwkJCQkJCSAgICBvcmlnX210dSk7DQogDQogCQkJc2tiX3ByZXYgPSBza2I7DQogDQpAQCAt
MTY2MCw4ICsxNjU4LDggQEAgaW50IGlwNl9wdXNoX3BlbmRpbmdfZnJhbWVzKHN0cnVjdCBzb2Nr
ICpzaykNCiAJaWYgKHByb3RvID09IElQUFJPVE9fSUNNUFY2KSB7DQogCQlzdHJ1Y3QgaW5ldDZf
ZGV2ICppZGV2ID0gaXA2X2RzdF9pZGV2KHNrYl9kc3Qoc2tiKSk7DQogDQotCQlJQ01QNk1TR09V
VF9JTkNfU1RBVFNfQkgobmV0LCBpZGV2LCBpY21wNl9oZHIoc2tiKS0+aWNtcDZfdHlwZSk7DQot
CQlJQ01QNl9JTkNfU1RBVFNfQkgobmV0LCBpZGV2LCBJQ01QNl9NSUJfT1VUTVNHUyk7DQorCQlJ
Q01QNk1TR09VVF9JTkNfU1RBVFMobmV0LCBpZGV2LCBpY21wNl9oZHIoc2tiKS0+aWNtcDZfdHlw
ZSk7DQorCQlJQ01QNl9JTkNfU1RBVFMobmV0LCBpZGV2LCBJQ01QNl9NSUJfT1VUTVNHUyk7DQog
CX0NCiANCiAJZXJyID0gaXA2X2xvY2FsX291dChza2IpOw0KZGlmZiAtLWdpdCBhL25ldC9pcHY2
L21jYXN0LmMgYi9uZXQvaXB2Ni9tY2FzdC5jDQppbmRleCBkMjBhOWJlLi40ZjEyYjY2IDEwMDY0
NA0KLS0tIGEvbmV0L2lwdjYvbWNhc3QuYw0KKysrIGIvbmV0L2lwdjYvbWNhc3QuYw0KQEAgLTE0
MzUsMTEgKzE0MzUsMTIgQEAgc3RhdGljIHZvaWQgbWxkX3NlbmRwYWNrKHN0cnVjdCBza19idWZm
ICpza2IpDQogCQkgICAgICBkc3Rfb3V0cHV0KTsNCiBvdXQ6DQogCWlmICghZXJyKSB7DQotCQlJ
Q01QNk1TR09VVF9JTkNfU1RBVFNfQkgobmV0LCBpZGV2LCBJQ01QVjZfTUxEMl9SRVBPUlQpOw0K
LQkJSUNNUDZfSU5DX1NUQVRTX0JIKG5ldCwgaWRldiwgSUNNUDZfTUlCX09VVE1TR1MpOw0KLQkJ
SVA2X1VQRF9QT19TVEFUU19CSChuZXQsIGlkZXYsIElQU1RBVFNfTUlCX09VVE1DQVNULCBwYXls
b2FkX2xlbik7DQotCX0gZWxzZQ0KLQkJSVA2X0lOQ19TVEFUU19CSChuZXQsIGlkZXYsIElQU1RB
VFNfTUlCX09VVERJU0NBUkRTKTsNCisJCUlDTVA2TVNHT1VUX0lOQ19TVEFUUyhuZXQsIGlkZXYs
IElDTVBWNl9NTEQyX1JFUE9SVCk7DQorCQlJQ01QNl9JTkNfU1RBVFMobmV0LCBpZGV2LCBJQ01Q
Nl9NSUJfT1VUTVNHUyk7DQorCQlJUDZfVVBEX1BPX1NUQVRTKG5ldCwgaWRldiwgSVBTVEFUU19N
SUJfT1VUTUNBU1QsIHBheWxvYWRfbGVuKTsNCisJfSBlbHNlIHsNCisJCUlQNl9JTkNfU1RBVFMo
bmV0LCBpZGV2LCBJUFNUQVRTX01JQl9PVVRESVNDQVJEUyk7DQorCX0NCiANCiAJcmN1X3JlYWRf
dW5sb2NrKCk7DQogCXJldHVybjsNCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9yb3V0ZS5jIGIvbmV0
L2lwdjYvcm91dGUuYw0KaW5kZXggOWE0ZjQzNy4uMzllMTFmOSAxMDA2NDQNCi0tLSBhL25ldC9p
cHY2L3JvdXRlLmMNCisrKyBiL25ldC9pcHY2L3JvdXRlLmMNCkBAIC0xMjUwLDcgKzEyNTAsNyBA
QCBpbnQgaXA2X3JvdXRlX2FkZChzdHJ1Y3QgZmliNl9jb25maWcgKmNmZykNCiAJCWdvdG8gb3V0
Ow0KIAl9DQogDQotCXJ0ID0gaXA2X2RzdF9hbGxvYygmbmV0LT5pcHY2LmlwNl9kc3Rfb3BzLCBO
VUxMLCBEU1RfTk9DT1VOVCk7DQorCXJ0ID0gaXA2X2RzdF9hbGxvYygmbmV0LT5pcHY2LmlwNl9k
c3Rfb3BzLCBOVUxMLCAoY2ZnLT5mY19mbGFncyAmIFJURl9BRERSQ09ORikgPyAwIDogRFNUX05P
Q09VTlQpOw0KIA0KIAlpZiAocnQgPT0gTlVMTCkgew0KIAkJZXJyID0gLUVOT01FTTsNCmRpZmYg
LS1naXQgYS9uZXQvcmRzL2l3LmMgYi9uZXQvcmRzL2l3LmMNCmluZGV4IDc4MjZkNDYuLjU4OTkz
NTYgMTAwNjQ0DQotLS0gYS9uZXQvcmRzL2l3LmMNCisrKyBiL25ldC9yZHMvaXcuYw0KQEAgLTIz
OSw3ICsyMzksOCBAQCBzdGF0aWMgaW50IHJkc19pd19sYWRkcl9jaGVjayhfX2JlMzIgYWRkcikN
CiAJcmV0ID0gcmRtYV9iaW5kX2FkZHIoY21faWQsIChzdHJ1Y3Qgc29ja2FkZHIgKikmc2luKTsN
CiAJLyogZHVlIHRvIHRoaXMsIHdlIHdpbGwgY2xhaW0gdG8gc3VwcG9ydCBJQiBkZXZpY2VzIHVu
bGVzcyB3ZQ0KIAkgICBjaGVjayBub2RlX3R5cGUuICovDQotCWlmIChyZXQgfHwgY21faWQtPmRl
dmljZS0+bm9kZV90eXBlICE9IFJETUFfTk9ERV9STklDKQ0KKwlpZiAocmV0IHx8ICFjbV9pZC0+
ZGV2aWNlIHx8DQorCSAgICBjbV9pZC0+ZGV2aWNlLT5ub2RlX3R5cGUgIT0gUkRNQV9OT0RFX1JO
SUMpDQogCQlyZXQgPSAtRUFERFJOT1RBVkFJTDsNCiANCiAJcmRzZGVidWcoImFkZHIgJXBJNCBy
ZXQgJWQgbm9kZSB0eXBlICVkXG4iLA0KZGlmZiAtLWdpdCBhL25ldC9zY3RwL3NtX21ha2VfY2h1
bmsuYyBiL25ldC9zY3RwL3NtX21ha2VfY2h1bmsuYw0KaW5kZXggMDEyMWUwYS4uYzk1YTNmMiAx
MDA2NDQNCi0tLSBhL25ldC9zY3RwL3NtX21ha2VfY2h1bmsuYw0KKysrIGIvbmV0L3NjdHAvc21f
bWFrZV9jaHVuay5jDQpAQCAtMTM2Niw4ICsxMzY2LDggQEAgc3RhdGljIHZvaWQgc2N0cF9jaHVu
a19kZXN0cm95KHN0cnVjdCBzY3RwX2NodW5rICpjaHVuaykNCiAJQlVHX09OKCFsaXN0X2VtcHR5
KCZjaHVuay0+bGlzdCkpOw0KIAlsaXN0X2RlbF9pbml0KCZjaHVuay0+dHJhbnNtaXR0ZWRfbGlz
dCk7DQogDQotCS8qIEZyZWUgdGhlIGNodW5rIHNrYiBkYXRhIGFuZCB0aGUgU0NUUF9jaHVuayBz
dHViIGl0c2VsZi4gKi8NCi0JZGV2X2tmcmVlX3NrYihjaHVuay0+c2tiKTsNCisJY29uc3VtZV9z
a2IoY2h1bmstPnNrYik7DQorCWNvbnN1bWVfc2tiKGNodW5rLT5hdXRoX2NodW5rKTsNCiANCiAJ
U0NUUF9EQkdfT0JKQ05UX0RFQyhjaHVuayk7DQogCWttZW1fY2FjaGVfZnJlZShzY3RwX2NodW5r
X2NhY2hlcCwgY2h1bmspOw0KZGlmZiAtLWdpdCBhL25ldC9zY3RwL3NtX3N0YXRlZnVucy5jIGIv
bmV0L3NjdHAvc21fc3RhdGVmdW5zLmMNCmluZGV4IGYxMzFjYWYuLjVhYzMzYjYgMTAwNjQ0DQot
LS0gYS9uZXQvc2N0cC9zbV9zdGF0ZWZ1bnMuYw0KKysrIGIvbmV0L3NjdHAvc21fc3RhdGVmdW5z
LmMNCkBAIC03NDksNyArNzQ5LDYgQEAgc2N0cF9kaXNwb3NpdGlvbl90IHNjdHBfc2ZfZG9fNV8x
RF9jZShjb25zdCBzdHJ1Y3Qgc2N0cF9lbmRwb2ludCAqZXAsDQogDQogCQkvKiBNYWtlIHN1cmUg
dGhhdCB3ZSBhbmQgdGhlIHBlZXIgYXJlIEFVVEggY2FwYWJsZSAqLw0KIAkJaWYgKCFzY3RwX2F1
dGhfZW5hYmxlIHx8ICFuZXdfYXNvYy0+cGVlci5hdXRoX2NhcGFibGUpIHsNCi0JCQlrZnJlZV9z
a2IoY2h1bmstPmF1dGhfY2h1bmspOw0KIAkJCXNjdHBfYXNzb2NpYXRpb25fZnJlZShuZXdfYXNv
Yyk7DQogCQkJcmV0dXJuIHNjdHBfc2ZfcGRpc2NhcmQoZXAsIGFzb2MsIHR5cGUsIGFyZywgY29t
bWFuZHMpOw0KIAkJfQ0KQEAgLTc2NCwxMCArNzYzLDYgQEAgc2N0cF9kaXNwb3NpdGlvbl90IHNj
dHBfc2ZfZG9fNV8xRF9jZShjb25zdCBzdHJ1Y3Qgc2N0cF9lbmRwb2ludCAqZXAsDQogCQlhdXRo
LnRyYW5zcG9ydCA9IGNodW5rLT50cmFuc3BvcnQ7DQogDQogCQlyZXQgPSBzY3RwX3NmX2F1dGhl
bnRpY2F0ZShlcCwgbmV3X2Fzb2MsIHR5cGUsICZhdXRoKTsNCi0NCi0JCS8qIFdlIGNhbiBub3cg
c2FmZWx5IGZyZWUgdGhlIGF1dGhfY2h1bmsgY2xvbmUgKi8NCi0JCWtmcmVlX3NrYihjaHVuay0+
YXV0aF9jaHVuayk7DQotDQogCQlpZiAocmV0ICE9IFNDVFBfSUVSUk9SX05PX0VSUk9SKSB7DQog
CQkJc2N0cF9hc3NvY2lhdGlvbl9mcmVlKG5ld19hc29jKTsNCiAJCQlyZXR1cm4gc2N0cF9zZl9w
ZGlzY2FyZChlcCwgYXNvYywgdHlwZSwgYXJnLCBjb21tYW5kcyk7DQpkaWZmIC0tZ2l0IGEvbmV0
L3NvY2tldC5jIGIvbmV0L3NvY2tldC5jDQppbmRleCBkNGZhYWRlLi4zZmFhMzU4IDEwMDY0NA0K
LS0tIGEvbmV0L3NvY2tldC5jDQorKysgYi9uZXQvc29ja2V0LmMNCkBAIC0xODg0LDYgKzE4ODQs
MTAgQEAgc3RhdGljIGludCBjb3B5X21zZ2hkcl9mcm9tX3VzZXIoc3RydWN0IG1zZ2hkciAqa21z
ZywNCiB7DQogCWlmIChjb3B5X2Zyb21fdXNlcihrbXNnLCB1bXNnLCBzaXplb2Yoc3RydWN0IG1z
Z2hkcikpKQ0KIAkJcmV0dXJuIC1FRkFVTFQ7DQorDQorCWlmIChrbXNnLT5tc2dfbmFtZWxlbiA8
IDApDQorCQlyZXR1cm4gLUVJTlZBTDsNCisNCiAJaWYgKGttc2ctPm1zZ19uYW1lbGVuID4gc2l6
ZW9mKHN0cnVjdCBzb2NrYWRkcl9zdG9yYWdlKSkNCiAJCWttc2ctPm1zZ19uYW1lbGVuID0gc2l6
ZW9mKHN0cnVjdCBzb2NrYWRkcl9zdG9yYWdlKTsNCiAJcmV0dXJuIDA7DQpkaWZmIC0tZ2l0IGEv
bmV0L3VuaXgvYWZfdW5peC5jIGIvbmV0L3VuaXgvYWZfdW5peC5jDQppbmRleCA1NGZjOTBiLi44
NzA1ZWUzIDEwMDY0NA0KLS0tIGEvbmV0L3VuaXgvYWZfdW5peC5jDQorKysgYi9uZXQvdW5peC9h
Zl91bml4LmMNCkBAIC0xNzcxLDggKzE3NzEsMTEgQEAgc3RhdGljIGludCB1bml4X2RncmFtX3Jl
Y3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAkJZ290byBv
dXQ7DQogDQogCWVyciA9IG11dGV4X2xvY2tfaW50ZXJydXB0aWJsZSgmdS0+cmVhZGxvY2spOw0K
LQlpZiAoZXJyKSB7DQotCQllcnIgPSBzb2NrX2ludHJfZXJybm8oc29ja19yY3Z0aW1lbyhzaywg
bm9ibG9jaykpOw0KKwlpZiAodW5saWtlbHkoZXJyKSkgew0KKwkJLyogcmVjdm1zZygpIGluIG5v
biBibG9ja2luZyBtb2RlIGlzIHN1cHBvc2VkIHRvIHJldHVybiAtRUFHQUlODQorCQkgKiBza19y
Y3Z0aW1lbyBpcyBub3QgaG9ub3JlZCBieSBtdXRleF9sb2NrX2ludGVycnVwdGlibGUoKQ0KKwkJ
ICovDQorCQllcnIgPSBub2Jsb2NrID8gLUVBR0FJTiA6IC1FUkVTVEFSVFNZUzsNCiAJCWdvdG8g
b3V0Ow0KIAl9DQogDQpAQCAtMTg4Nyw2ICsxODkwLDcgQEAgc3RhdGljIGludCB1bml4X3N0cmVh
bV9yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IHNvY2tldCAqc29jaywNCiAJc3Ry
dWN0IHVuaXhfc29jayAqdSA9IHVuaXhfc2soc2spOw0KIAlzdHJ1Y3Qgc29ja2FkZHJfdW4gKnN1
bmFkZHIgPSBtc2ctPm1zZ19uYW1lOw0KIAlpbnQgY29waWVkID0gMDsNCisJaW50IG5vYmxvY2sg
PSBmbGFncyAmIE1TR19ET05UV0FJVDsNCiAJaW50IGNoZWNrX2NyZWRzID0gMDsNCiAJaW50IHRh
cmdldDsNCiAJaW50IGVyciA9IDA7DQpAQCAtMTkwMSw3ICsxOTA1LDcgQEAgc3RhdGljIGludCB1
bml4X3N0cmVhbV9yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IHNvY2tldCAqc29j
aywNCiAJCWdvdG8gb3V0Ow0KIA0KIAl0YXJnZXQgPSBzb2NrX3Jjdmxvd2F0KHNrLCBmbGFncyZN
U0dfV0FJVEFMTCwgc2l6ZSk7DQotCXRpbWVvID0gc29ja19yY3Z0aW1lbyhzaywgZmxhZ3MmTVNH
X0RPTlRXQUlUKTsNCisJdGltZW8gPSBzb2NrX3JjdnRpbWVvKHNrLCBub2Jsb2NrKTsNCiANCiAJ
LyogTG9jayB0aGUgc29ja2V0IHRvIHByZXZlbnQgcXVldWUgZGlzb3JkZXJpbmcNCiAJICogd2hp
bGUgc2xlZXBzIGluIG1lbWNweV90b21zZw0KQEAgLTE5MTMsOCArMTkxNywxMSBAQCBzdGF0aWMg
aW50IHVuaXhfc3RyZWFtX3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0
ICpzb2NrLA0KIAl9DQogDQogCWVyciA9IG11dGV4X2xvY2tfaW50ZXJydXB0aWJsZSgmdS0+cmVh
ZGxvY2spOw0KLQlpZiAoZXJyKSB7DQotCQllcnIgPSBzb2NrX2ludHJfZXJybm8odGltZW8pOw0K
KwlpZiAodW5saWtlbHkoZXJyKSkgew0KKwkJLyogcmVjdm1zZygpIGluIG5vbiBibG9ja2luZyBt
b2RlIGlzIHN1cHBvc2VkIHRvIHJldHVybiAtRUFHQUlODQorCQkgKiBza19yY3Z0aW1lbyBpcyBu
b3QgaG9ub3JlZCBieSBtdXRleF9sb2NrX2ludGVycnVwdGlibGUoKQ0KKwkJICovDQorCQllcnIg
PSBub2Jsb2NrID8gLUVBR0FJTiA6IC1FUkVTVEFSVFNZUzsNCiAJCWdvdG8gb3V0Ow0KIAl9DQog
DQpkaWZmIC0tZ2l0IGEvc2VjdXJpdHkvc2VsaW51eC9ob29rcy5jIGIvc2VjdXJpdHkvc2VsaW51
eC9ob29rcy5jDQppbmRleCA0ZmE3OTM5Li42OTQ3N2ZmIDEwMDY0NA0KLS0tIGEvc2VjdXJpdHkv
c2VsaW51eC9ob29rcy5jDQorKysgYi9zZWN1cml0eS9zZWxpbnV4L2hvb2tzLmMNCkBAIC0xMzI4
LDE1ICsxMzI4LDMzIEBAIHN0YXRpYyBpbnQgaW5vZGVfZG9pbml0X3dpdGhfZGVudHJ5KHN0cnVj
dCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBkZW50cnkgKm9wdF9kZW50DQogCQlpc2VjLT5zaWQgPSBz
YnNlYy0+c2lkOw0KIA0KIAkJaWYgKChzYnNlYy0+ZmxhZ3MgJiBTRV9TQlBST0MpICYmICFTX0lT
TE5LKGlub2RlLT5pX21vZGUpKSB7DQotCQkJaWYgKG9wdF9kZW50cnkpIHsNCi0JCQkJaXNlYy0+
c2NsYXNzID0gaW5vZGVfbW9kZV90b19zZWN1cml0eV9jbGFzcyhpbm9kZS0+aV9tb2RlKTsNCi0J
CQkJcmMgPSBzZWxpbnV4X3Byb2NfZ2V0X3NpZChvcHRfZGVudHJ5LA0KLQkJCQkJCQkgIGlzZWMt
PnNjbGFzcywNCi0JCQkJCQkJICAmc2lkKTsNCi0JCQkJaWYgKHJjKQ0KLQkJCQkJZ290byBvdXRf
dW5sb2NrOw0KLQkJCQlpc2VjLT5zaWQgPSBzaWQ7DQotCQkJfQ0KKwkJCS8qIFdlIG11c3QgaGF2
ZSBhIGRlbnRyeSB0byBkZXRlcm1pbmUgdGhlIGxhYmVsIG9uDQorCQkJICogcHJvY2ZzIGlub2Rl
cyAqLw0KKwkJCWlmIChvcHRfZGVudHJ5KQ0KKwkJCQkvKiBDYWxsZWQgZnJvbSBkX2luc3RhbnRp
YXRlIG9yDQorCQkJCSAqIGRfc3BsaWNlX2FsaWFzLiAqLw0KKwkJCQlkZW50cnkgPSBkZ2V0KG9w
dF9kZW50cnkpOw0KKwkJCWVsc2UNCisJCQkJLyogQ2FsbGVkIGZyb20gc2VsaW51eF9jb21wbGV0
ZV9pbml0LCB0cnkgdG8NCisJCQkJICogZmluZCBhIGRlbnRyeS4gKi8NCisJCQkJZGVudHJ5ID0g
ZF9maW5kX2FsaWFzKGlub2RlKTsNCisJCQkvKg0KKwkJCSAqIFRoaXMgY2FuIGJlIGhpdCBvbiBi
b290IHdoZW4gYSBmaWxlIGlzIGFjY2Vzc2VkDQorCQkJICogYmVmb3JlIHRoZSBwb2xpY3kgaXMg
bG9hZGVkLiAgV2hlbiB3ZSBsb2FkIHBvbGljeSB3ZQ0KKwkJCSAqIG1heSBmaW5kIGlub2RlcyB0
aGF0IGhhdmUgbm8gZGVudHJ5IG9uIHRoZQ0KKwkJCSAqIHNic2VjLT5pc2VjX2hlYWQgbGlzdC4g
IE5vIHJlYXNvbiB0byBjb21wbGFpbiBhcw0KKwkJCSAqIHRoZXNlIHdpbGwgZ2V0IGZpeGVkIHVw
IHRoZSBuZXh0IHRpbWUgd2UgZ28gdGhyb3VnaA0KKwkJCSAqIGlub2RlX2RvaW5pdCgpIHdpdGgg
YSBkZW50cnksIGJlZm9yZSB0aGVzZSBpbm9kZXMNCisJCQkgKiBjb3VsZCBiZSB1c2VkIGFnYWlu
IGJ5IHVzZXJzcGFjZS4NCisJCQkgKi8NCisJCQlpZiAoIWRlbnRyeSkNCisJCQkJZ290byBvdXRf
dW5sb2NrOw0KKwkJCWlzZWMtPnNjbGFzcyA9IGlub2RlX21vZGVfdG9fc2VjdXJpdHlfY2xhc3Mo
aW5vZGUtPmlfbW9kZSk7DQorCQkJcmMgPSBzZWxpbnV4X3Byb2NfZ2V0X3NpZChkZW50cnksIGlz
ZWMtPnNjbGFzcywgJnNpZCk7DQorCQkJZHB1dChkZW50cnkpOw0KKwkJCWlmIChyYykNCisJCQkJ
Z290byBvdXRfdW5sb2NrOw0KKwkJCWlzZWMtPnNpZCA9IHNpZDsNCiAJCX0NCiAJCWJyZWFrOw0K
IAl9DQpkaWZmIC0tZ2l0IGEvc291bmQvcGNpL2hkYS9wYXRjaF9yZWFsdGVrLmMgYi9zb3VuZC9w
Y2kvaGRhL3BhdGNoX3JlYWx0ZWsuYw0KaW5kZXggMzZiY2U2OC4uZDMwN2FkYiAxMDA2NDQNCi0t
LSBhL3NvdW5kL3BjaS9oZGEvcGF0Y2hfcmVhbHRlay5jDQorKysgYi9zb3VuZC9wY2kvaGRhL3Bh
dGNoX3JlYWx0ZWsuYw0KQEAgLTM4NTUsNiArMzg1NSw3IEBAIHN0YXRpYyB2b2lkIGFsY19hdXRv
X2luaXRfc3RkKHN0cnVjdCBoZGFfY29kZWMgKmNvZGVjKQ0KIA0KIHN0YXRpYyBjb25zdCBzdHJ1
Y3Qgc25kX3BjaV9xdWlyayBiZWVwX3doaXRlX2xpc3RbXSA9IHsNCiAJU05EX1BDSV9RVUlSSygw
eDEwNDMsIDB4MTAzYywgIkFTVVMiLCAxKSwNCisJU05EX1BDSV9RVUlSSygweDEwNDMsIDB4MTE1
ZCwgIkFTVVMiLCAxKSwNCiAJU05EX1BDSV9RVUlSSygweDEwNDMsIDB4ODI5ZiwgIkFTVVMiLCAx
KSwNCiAJU05EX1BDSV9RVUlSSygweDEwNDMsIDB4ODNjZSwgIkVlZVBDIiwgMSksDQogCVNORF9Q
Q0lfUVVJUksoMHgxMDQzLCAweDgzMWEsICJFZWVQQyIsIDEpLA0KZGlmZiAtLWdpdCBhL3NvdW5k
L3BjaS9pY2UxNzEyL2ljZTE3MTIuYyBiL3NvdW5kL3BjaS9pY2UxNzEyL2ljZTE3MTIuYw0KaW5k
ZXggNDQ0NDZmMi4uN2E0YTE5NiAxMDA2NDQNCi0tLSBhL3NvdW5kL3BjaS9pY2UxNzEyL2ljZTE3
MTIuYw0KKysrIGIvc291bmQvcGNpL2ljZTE3MTIvaWNlMTcxMi5jDQpAQCAtNjg2LDkgKzY4Niwx
MCBAQCBzdGF0aWMgc25kX3BjbV91ZnJhbWVzX3Qgc25kX2ljZTE3MTJfcGxheWJhY2tfcG9pbnRl
cihzdHJ1Y3Qgc25kX3BjbV9zdWJzdHJlYW0gKg0KIAlpZiAoIShzbmRfaWNlMTcxMl9yZWFkKGlj
ZSwgSUNFMTcxMl9JUkVHX1BCS19DVFJMKSAmIDEpKQ0KIAkJcmV0dXJuIDA7DQogCXB0ciA9IHJ1
bnRpbWUtPmJ1ZmZlcl9zaXplIC0gaW53KGljZS0+ZGRtYV9wb3J0ICsgNCk7DQorCXB0ciA9IGJ5
dGVzX3RvX2ZyYW1lcyhzdWJzdHJlYW0tPnJ1bnRpbWUsIHB0cik7DQogCWlmIChwdHIgPT0gcnVu
dGltZS0+YnVmZmVyX3NpemUpDQogCQlwdHIgPSAwOw0KLQlyZXR1cm4gYnl0ZXNfdG9fZnJhbWVz
KHN1YnN0cmVhbS0+cnVudGltZSwgcHRyKTsNCisJcmV0dXJuIHB0cjsNCiB9DQogDQogc3RhdGlj
IHNuZF9wY21fdWZyYW1lc190IHNuZF9pY2UxNzEyX3BsYXliYWNrX2RzX3BvaW50ZXIoc3RydWN0
IHNuZF9wY21fc3Vic3RyZWFtICpzdWJzdHJlYW0pDQpAQCAtNzA1LDkgKzcwNiwxMCBAQCBzdGF0
aWMgc25kX3BjbV91ZnJhbWVzX3Qgc25kX2ljZTE3MTJfcGxheWJhY2tfZHNfcG9pbnRlcihzdHJ1
Y3Qgc25kX3BjbV9zdWJzdHJlYQ0KIAkJYWRkciA9IElDRTE3MTJfRFNDX0FERFIwOw0KIAlwdHIg
PSBzbmRfaWNlMTcxMl9kc19yZWFkKGljZSwgc3Vic3RyZWFtLT5udW1iZXIgKiAyLCBhZGRyKSAt
DQogCQlpY2UtPnBsYXliYWNrX2Nvbl92aXJ0X2FkZHJbc3Vic3RyZWFtLT5udW1iZXJdOw0KKwlw
dHIgPSBieXRlc190b19mcmFtZXMoc3Vic3RyZWFtLT5ydW50aW1lLCBwdHIpOw0KIAlpZiAocHRy
ID09IHN1YnN0cmVhbS0+cnVudGltZS0+YnVmZmVyX3NpemUpDQogCQlwdHIgPSAwOw0KLQlyZXR1
cm4gYnl0ZXNfdG9fZnJhbWVzKHN1YnN0cmVhbS0+cnVudGltZSwgcHRyKTsNCisJcmV0dXJuIHB0
cjsNCiB9DQogDQogc3RhdGljIHNuZF9wY21fdWZyYW1lc190IHNuZF9pY2UxNzEyX2NhcHR1cmVf
cG9pbnRlcihzdHJ1Y3Qgc25kX3BjbV9zdWJzdHJlYW0gKnN1YnN0cmVhbSkNCkBAIC03MTgsOSAr
NzIwLDEwIEBAIHN0YXRpYyBzbmRfcGNtX3VmcmFtZXNfdCBzbmRfaWNlMTcxMl9jYXB0dXJlX3Bv
aW50ZXIoc3RydWN0IHNuZF9wY21fc3Vic3RyZWFtICpzDQogCWlmICghKHNuZF9pY2UxNzEyX3Jl
YWQoaWNlLCBJQ0UxNzEyX0lSRUdfQ0FQX0NUUkwpICYgMSkpDQogCQlyZXR1cm4gMDsNCiAJcHRy
ID0gaW5sKElDRVJFRyhpY2UsIENPTkNBUF9BRERSKSkgLSBpY2UtPmNhcHR1cmVfY29uX3ZpcnRf
YWRkcjsNCisJcHRyID0gYnl0ZXNfdG9fZnJhbWVzKHN1YnN0cmVhbS0+cnVudGltZSwgcHRyKTsN
CiAJaWYgKHB0ciA9PSBzdWJzdHJlYW0tPnJ1bnRpbWUtPmJ1ZmZlcl9zaXplKQ0KIAkJcHRyID0g
MDsNCi0JcmV0dXJuIGJ5dGVzX3RvX2ZyYW1lcyhzdWJzdHJlYW0tPnJ1bnRpbWUsIHB0cik7DQor
CXJldHVybiBwdHI7DQogfQ0KIA0KIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc25kX3BjbV9oYXJkd2Fy
ZSBzbmRfaWNlMTcxMl9wbGF5YmFjayA9IHsNCkBAIC0xMTE0LDkgKzExMTcsMTAgQEAgc3RhdGlj
IHNuZF9wY21fdWZyYW1lc190IHNuZF9pY2UxNzEyX3BsYXliYWNrX3Byb19wb2ludGVyKHN0cnVj
dCBzbmRfcGNtX3N1YnN0cmUNCiAJaWYgKCEoaW5sKElDRU1UKGljZSwgUExBWUJBQ0tfQ09OVFJP
TCkpICYgSUNFMTcxMl9QTEFZQkFDS19TVEFSVCkpDQogCQlyZXR1cm4gMDsNCiAJcHRyID0gaWNl
LT5wbGF5YmFja19wcm9fc2l6ZSAtIChpbncoSUNFTVQoaWNlLCBQTEFZQkFDS19TSVpFKSkgPDwg
Mik7DQorCXB0ciA9IGJ5dGVzX3RvX2ZyYW1lcyhzdWJzdHJlYW0tPnJ1bnRpbWUsIHB0cik7DQog
CWlmIChwdHIgPT0gc3Vic3RyZWFtLT5ydW50aW1lLT5idWZmZXJfc2l6ZSkNCiAJCXB0ciA9IDA7
DQotCXJldHVybiBieXRlc190b19mcmFtZXMoc3Vic3RyZWFtLT5ydW50aW1lLCBwdHIpOw0KKwly
ZXR1cm4gcHRyOw0KIH0NCiANCiBzdGF0aWMgc25kX3BjbV91ZnJhbWVzX3Qgc25kX2ljZTE3MTJf
Y2FwdHVyZV9wcm9fcG9pbnRlcihzdHJ1Y3Qgc25kX3BjbV9zdWJzdHJlYW0gKnN1YnN0cmVhbSkN
CkBAIC0xMTI3LDkgKzExMzEsMTAgQEAgc3RhdGljIHNuZF9wY21fdWZyYW1lc190IHNuZF9pY2Ux
NzEyX2NhcHR1cmVfcHJvX3BvaW50ZXIoc3RydWN0IHNuZF9wY21fc3Vic3RyZWENCiAJaWYgKCEo
aW5sKElDRU1UKGljZSwgUExBWUJBQ0tfQ09OVFJPTCkpICYgSUNFMTcxMl9DQVBUVVJFX1NUQVJU
X1NIQURPVykpDQogCQlyZXR1cm4gMDsNCiAJcHRyID0gaWNlLT5jYXB0dXJlX3Byb19zaXplIC0g
KGludyhJQ0VNVChpY2UsIENBUFRVUkVfU0laRSkpIDw8IDIpOw0KKwlwdHIgPSBieXRlc190b19m
cmFtZXMoc3Vic3RyZWFtLT5ydW50aW1lLCBwdHIpOw0KIAlpZiAocHRyID09IHN1YnN0cmVhbS0+
cnVudGltZS0+YnVmZmVyX3NpemUpDQogCQlwdHIgPSAwOw0KLQlyZXR1cm4gYnl0ZXNfdG9fZnJh
bWVzKHN1YnN0cmVhbS0+cnVudGltZSwgcHRyKTsNCisJcmV0dXJuIHB0cjsNCiB9DQogDQogc3Rh
dGljIGNvbnN0IHN0cnVjdCBzbmRfcGNtX2hhcmR3YXJlIHNuZF9pY2UxNzEyX3BsYXliYWNrX3By
byA9IHsNCi==


--=-67qpOVkXRt0sObi/8NgV--

--=-buPf7p6NDjCE3suCtI0l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU2Elrue/yOyVhhEJAQqmwxAAhMeA+JeG7rPFKxn62koD39RnB7PXIHYQ
c7Nb3CDoeztVvjeVZ2guxH4I/X4eLzY+RX9335asFBbw0Q4tb0jM7Jf3agQFuUqY
fpfw4qSfcTUwKtSFJ37ozdnsBsr8liF1ZAeaeTRgLmvhLR8VcQyGGIlpK2oKQF87
XoOi+D4rO1paAyrbU25m8qySFy7HezMZ898vYoOlWFwxfa2uYlgcP6npOd0GOCA5
U0UAoETdznd50rXwMSWTp4m5221HTLFFwQ77i+0QyY+0TaiH/ciIuW4ALASYNnje
tzkmPSXJwFEltIvMWbBd6hAKe33+1f+F8BYqp3zBDGXh1IcxhZfNUOY1N0sypviu
uBkgN4Vqi+f8DRMqeEvVz3PCx5P9OlmYmANxRwQYc/rI+oQle2gjhe323hcAbNaN
2Dul7rIWIVzqyJfa6Nd8TL6FBVJpDOksBudwPplRKpJTpskQU5Xsh2prTf6PLWj1
T6a7XURcEvzJbzJCdWhEUf311eLxHcYxLA3pF0+1pqaILToUEsJ2pvS4GX62+WCG
cyPNeL9MoPdSsUpJKZSFS8mtUeUsgozqa+KdeS0+VVh7c8GzkIK1s57896VGIusi
EMCSIwlOm4b+gynIUBzxxa5RzwlrnnVGPYVXET/06GiUmuOQ+mGFz5xFcNRNnfw3
kLV2iIH/UkI=
=uBk+
-----END PGP SIGNATURE-----

--=-buPf7p6NDjCE3suCtI0l--
