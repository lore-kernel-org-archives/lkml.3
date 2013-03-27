Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3C0N4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:56:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55350 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365Ab3C0N4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:56:12 -0400
Message-ID: <1364392547.3520.72.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.42
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 27 Mar 2013 13:55:47 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-qKW140t/aOaSlhCSMfQW"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:e40a:77e1:ece1:499b
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qKW140t/aOaSlhCSMfQW
Content-Type: multipart/mixed; boundary="=-VfzpRBgEmSkvMAsWCyeR"


--=-VfzpRBgEmSkvMAsWCyeR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.42 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.41 is attached to this message.

Ben.

------------

 Makefile                                     |    2 +-
 arch/arm/include/asm/signal.h                |    1 +
 arch/avr32/include/asm/signal.h              |    1 +
 arch/cris/include/asm/signal.h               |    1 +
 arch/h8300/include/asm/signal.h              |    1 +
 arch/m32r/include/asm/signal.h               |    1 +
 arch/m68k/include/asm/signal.h               |    1 +
 arch/mn10300/include/asm/signal.h            |    1 +
 arch/powerpc/include/asm/signal.h            |    1 +
 arch/powerpc/kernel/cputable.c               |    2 +-
 arch/s390/include/asm/signal.h               |    1 +
 arch/s390/include/asm/tlbflush.h             |    2 -
 arch/sparc/include/asm/signal.h              |    1 +
 arch/x86/include/asm/signal.h                |    2 +
 arch/x86/kernel/cpu/perf_event_intel_ds.c    |   10 +
 arch/x86/lib/usercopy_64.c                   |    4 +-
 arch/x86/power/cpu.c                         |    2 +
 arch/xtensa/include/asm/signal.h             |    1 +
 drivers/firmware/Kconfig                     |   18 ++
 drivers/firmware/efivars.c                   |  256 ++++++++++++++++++++--=
----
 drivers/gpu/drm/drm_edid.c                   |    3 +-
 drivers/gpu/drm/i915/i915_debugfs.c          |    2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c   |   11 +-
 drivers/gpu/drm/i915/intel_display.c         |    2 +-
 drivers/gpu/drm/i915/intel_opregion.c        |   23 ++-
 drivers/gpu/drm/radeon/radeon_benchmark.c    |   16 +-
 drivers/i2c/busses/i2c-tegra.c               |   13 +-
 drivers/md/dm-thin.c                         |    4 +-
 drivers/md/persistent-data/dm-btree-remove.c |   46 ++---
 drivers/net/bonding/bond_main.c              |    6 +-
 drivers/net/ethernet/sfc/efx.c               |   53 ++++--
 drivers/net/ethernet/sfc/efx.h               |   13 ++
 drivers/net/ethernet/sfc/falcon.c            |    2 +
 drivers/net/ethernet/sfc/mcdi.c              |   29 +--
 drivers/net/ethernet/sfc/mcdi.h              |    1 +
 drivers/net/ethernet/sfc/mcdi_mac.c          |    4 +-
 drivers/net/ethernet/sfc/net_driver.h        |   10 +-
 drivers/net/ethernet/sfc/nic.c               |   24 ++-
 drivers/net/ethernet/sfc/nic.h               |    2 +
 drivers/net/ethernet/sfc/rx.c                |   25 ++-
 drivers/net/ethernet/sfc/selftest.c          |    2 +-
 drivers/net/ethernet/sfc/siena.c             |   15 +-
 drivers/net/macvlan.c                        |    1 +
 drivers/net/netconsole.c                     |   20 +-
 drivers/net/tun.c                            |    2 +
 drivers/net/wireless/mwifiex/join.c          |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  |   89 ++++-----
 drivers/tty/pty.c                            |    1 -
 drivers/tty/serial/sunsu.c                   |   21 +--
 drivers/usb/core/hcd-pci.c                   |   23 ++-
 drivers/usb/gadget/udc-core.c                |    2 +-
 drivers/usb/host/xhci.c                      |    3 +-
 drivers/usb/host/xhci.h                      |    4 +-
 drivers/usb/serial/garmin_gps.c              |    7 +-
 drivers/usb/serial/io_ti.c                   |    1 +
 drivers/usb/serial/usb-serial.c              |    3 +-
 drivers/usb/storage/unusual_devs.h           |    7 +
 drivers/vhost/net.c                          |    3 +-
 fs/cifs/asn1.c                               |   53 +-----
 fs/cifs/cifsfs.c                             |   24 +++
 fs/cifs/cifsfs.h                             |    4 +
 fs/cifs/file.c                               |    6 +-
 fs/ext4/balloc.c                             |    2 +-
 fs/ext4/ext4.h                               |    6 +-
 fs/ext4/extents.c                            |    6 +-
 fs/ext4/ialloc.c                             |    4 +-
 fs/ext4/inode.c                              |    3 +-
 fs/ext4/mballoc.c                            |   18 +-
 fs/ext4/resize.c                             |    6 +-
 fs/ext4/super.c                              |    4 +-
 fs/isofs/export.c                            |    1 +
 fs/jbd2/transaction.c                        |   15 +-
 fs/proc/inode.c                              |   12 +-
 fs/udf/namei.c                               |    1 +
 include/asm-generic/signal.h                 |    4 +
 include/linux/efi.h                          |    3 +-
 include/linux/perf_event.h                   |    6 +
 include/linux/skbuff.h                       |    7 +-
 include/net/inet_frag.h                      |    9 +
 include/net/ip_fib.h                         |   12 +-
 kernel/signal.c                              |    2 +-
 kernel/trace/ftrace.c                        |    4 +-
 kernel/trace/trace.c                         |   59 ++++--
 kernel/trace/trace.h                         |    7 +
 kernel/trace/trace_irqsoff.c                 |   19 +-
 kernel/trace/trace_sched_wakeup.c            |   18 +-
 mm/hugetlb.c                                 |    8 +-
 net/core/dev.c                               |    1 +
 net/core/rtnetlink.c                         |    3 +-
 net/dcb/dcbnl.c                              |    7 +
 net/ieee802154/6lowpan.h                     |    2 +-
 net/ipv4/inet_fragment.c                     |   20 +-
 net/ipv4/ip_fragment.c                       |   12 +-
 net/ipv4/ip_options.c                        |    5 +-
 net/ipv4/tcp.c                               |    2 +-
 net/ipv4/tcp_input.c                         |    6 +-
 net/ipv4/tcp_output.c                        |    1 -
 net/ipv6/ip6_input.c                         |    3 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c      |   11 +-
 net/ipv6/reassembly.c                        |    8 +-
 net/ipv6/route.c                             |    3 +-
 net/l2tp/l2tp_ppp.c                          |    1 +
 net/netlabel/netlabel_unlabeled.c            |   27 ++-
 net/rds/message.c                            |    3 +
 net/sctp/associola.c                         |    2 +-
 net/sctp/sm_statefuns.c                      |    2 +-
 security/selinux/xfrm.c                      |    2 +-
 sound/pci/hda/hda_codec.c                    |    2 +-
 sound/pci/hda/patch_conexant.c               |    8 +-
 sound/usb/mixer.c                            |   16 +-
 tools/hv/hv_kvp_daemon.c                     |    8 +-
 tools/perf/util/trace-event-parse.c          |    2 -
 112 files changed, 844 insertions(+), 445 deletions(-)

Alan Stern (1):
      usb: gadget: udc-core: fix a regression during gadget driver unbindin=
g

Alex Deucher (1):
      drm/radeon/benchmark: make sure bo blit copy exists before using it

Andrew Morton (1):
      kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER

Ben Hutchings (13):
      perf: Revert duplicated commit
      sfc: Convert firmware subtypes to native byte order in  efx_mcdi_get_=
board_cfg()
      sfc: Fix two causes of flush failure
      sfc: Fix timekeeping in efx_mcdi_poll()
      sfc: Properly sync RX DMA buffer when it is not the  last in the page
      sfc: Fix efx_rx_buf_offset() in the presence of  swiotlb
      sfc: Detach net device when stopping queues for  reconfiguration
      sfc: Disable soft interrupt handling during  efx_device_detach_sync()
      sfc: Only use TX push if a single descriptor is to be  written
      efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
      efivars: pstore: Do not check size when erasing variable
      signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_=
restorer
      Linux 3.2.42

Benjamin Herrenschmidt (1):
      powerpc: Fix cputable entry for 970MP rev 1.0

Bing Zhao (1):
      mwifiex: fix potential out-of-boundary access to ibss rate table

CQ Tang (1):
      x86-64: Fix the failure case in copy_user_handle_tail()

Cong Wang (1):
      rds: limit the size allocated by rds_message_alloc()

Cristian Bercaru (1):
      bridging: fix rx_handlers return code

Dan Carpenter (1):
      selinux: use GFP_ATOMIC under spin_lock

Daniel Mack (2):
      ALSA: snd-usb: mixer: propagate errors up the call chain
      ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()

Daniel Pieczko (1):
      sfc: lock TX queues when calling netif_device_detach()

David Rientjes (1):
      perf,x86: fix link failure for non-Intel configs

David Ward (1):
      net/ipv4: Ensure that location of timestamp option is  stored

Denis V. Lunev (1):
      ipv4: fix definition of FIB_TABLE_HASHSZ

Dmitry Artamonow (1):
      usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player

Dmitry Torokhov (1):
      USB: xhci - fix bit definitions for IMAN register

Eric Dumazet (2):
      tun: add a missing nf_reset() in tun_net_xmit()
      tcp: fix skb_availroom()

Guillaume Nault (1):
      l2tp: Restore socket refcount when sendmsg succeeds

Hannes Frederic Sowa (2):
      ipv6: stop multicast forwarding to process interface  scoped addresse=
s
      inet: limit length of fragment queue hash table bucket  lists

Hannes Reinecke (1):
      USB: xhci: correctly enable interrupts

Heiko Carstens (1):
      s390/mm: fix flush_tlb_kernel_range()

Jan Kara (1):
      jbd2: fix use after free in jbd2_journal_dirty_metadata()

Jeff Layton (1):
      cifs: ignore everything in SPNEGO blob after mechTypes

Jiri Slaby (1):
      TTY: do not reset master's packet mode

Joe Thornber (1):
      dm thin: fix discard corruption

Johan Hovold (3):
      USB: garmin_gps: fix memory leak on disconnect
      USB: io_ti: fix get_icount for two port adapters
      USB: serial: fix interface refcounting

Kees Cook (2):
      drm/i915: restrict kernel address leak in debugfs
      drm/i915: bounds check execbuffer relocation count

Larry Finger (2):
      rtlwifi: rtl8192cu: Fix schedule while atomic bug splat
      rtlwifi: rtl8192cu: Fix problem that prevents reassociation

Laxman Dewangan (1):
      i2c: tegra: check the clk_prepare_enable() return value

Lekensteyn (1):
      i915: initialize CADL in opregion

Linus Torvalds (2):
      perf,x86: fix wrmsr_on_cpu() warning on suspend/resume
      vfs,proc: guarantee unique inodes in /proc

Lorenzo Colitti (1):
      net: ipv6: Don't purge default router if accept_ra=3D2

Lukas Czerner (1):
      ext4: convert number of blocks to clusters properly

Mateusz Guzik (1):
      cifs: delay super block destruction until all cifsFileInfo objects ar=
e gone

Mathias Krause (4):
      rtnl: fix info leak on RTM_GETLINK request for VF  devices
      dcbnl: fix various netlink info leaks
      udf: avoid info leak on export
      isofs: avoid info leak on export

Matt Fleming (2):
      efivars: explicitly calculate length of VariableName
      efivars: Handle duplicate names from get_next_variable()

Michael S. Tsirkin (1):
      vhost/net: fix heads usage of ubuf_info

Neal Cardwell (1):
      tcp: fix double-counted receiver RTT when leaving  receiver fast path

Paul Moore (1):
      netlabel: correctly list all the static label mappings

Seiji Aguchi (1):
      efi_pstore: Introducing workqueue updating sysfs

Seth Forshee (2):
      efivars: Allow disabling use as a pstore backend
      efivars: Add module parameter to disable use as a pstore backend

Stephane Eranian (1):
      perf,x86: fix kernel crash with PEBS/BTS after suspend/resume

Steven Rostedt (Red Hat) (5):
      tracing: Fix race in snapshot swapping
      tracing: Fix free of probe entry by calling call_rcu_sched()
      tracing: Protect tracer flags with trace_types_lock
      tracing: Keep overwrite in sync between regular and snapshot buffers
      tracing: Prevent buffer overwrite disabled for latency tracers

Stuart Hodgson (1):
      sfc: Do not attempt to flush queues if DMA is disabled

St=C3=A9phane Marchesin (1):
      drm/i915: Increase the RC6p threshold.

Takashi Iwai (2):
      ALSA: hda/cirrus - Fix the digital beep registration
      ALSA: hda - Fix typo in checking IEC958 emphasis bit

Theodore Ts'o (2):
      ext4: use atomic64_t for the per-flexbg free_clusters count
      ext4: fix data=3Djournal fast mount/umount hang

Tkhai Kirill (1):
      sunsu: Fix panic in case of nonexistent port at  "console=3DttySY" cm=
dline option

Tomas Hozza (1):
      tools: hv: Netlink source address validation allows DoS

Torsten Duwe (2):
      KMS: fix EDID detailed timing vsync parsing
      KMS: fix EDID detailed timing frame rate

Veaceslav Falico (2):
      netconsole: don't call __netpoll_cleanup() while  atomic
      bonding: don't call update_speed_duplex() under  spinlocks

Vlad Yasevich (3):
      macvlan: Set IFF_UNICAST_FLT flag to prevent  unnecessary promisc mod=
e.
      sctp: Use correct sideffect command in duplicate  cookie handling
      rtnetlink: Mask the rta_type when range checking

Wanpeng Li (1):
      mm/hugetlb: fix total hugetlbfs pages count when using memory overcom=
mit accouting

Xufeng Zhang (1):
      sctp: don't break the loop while meeting the  active_path so as to fi=
nd the matched transport

YOSHIFUJI Hideaki / =E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E (1):
      6lowpan: Fix endianness issue in is_addr_link_local().

Zheng Liu (1):
      ext4: fix the wrong number of the allocated blocks in ext4_split_exte=
nt()



--=-VfzpRBgEmSkvMAsWCyeR
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.42.patch"
Content-Disposition: attachment; filename="linux-3.2.42.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUNCmluZGV4IDk1ZTYyMjAuLmQ0NGYwMDkg
MTAwNjQ0DQotLS0gYS9NYWtlZmlsZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0xLDYgKzEsNiBAQA0K
IFZFUlNJT04gPSAzDQogUEFUQ0hMRVZFTCA9IDINCi1TVUJMRVZFTCA9IDQxDQorU1VCTEVWRUwg
PSA0Mg0KIEVYVFJBVkVSU0lPTiA9DQogTkFNRSA9IFNhYmVyLXRvb3RoZWQgU3F1aXJyZWwNCiAN
CmRpZmYgLS1naXQgYS9hcmNoL2FybS9pbmNsdWRlL2FzbS9zaWduYWwuaCBiL2FyY2gvYXJtL2lu
Y2x1ZGUvYXNtL3NpZ25hbC5oDQppbmRleCA0M2JhMGZiLi41NTllZTI0IDEwMDY0NA0KLS0tIGEv
YXJjaC9hcm0vaW5jbHVkZS9hc20vc2lnbmFsLmgNCisrKyBiL2FyY2gvYXJtL2luY2x1ZGUvYXNt
L3NpZ25hbC5oDQpAQCAtMTI3LDYgKzEyNyw3IEBAIHN0cnVjdCBzaWdhY3Rpb24gew0KIAlfX3Np
Z3Jlc3RvcmVfdCBzYV9yZXN0b3JlcjsNCiAJc2lnc2V0X3Qgc2FfbWFzazsJCS8qIG1hc2sgbGFz
dCBmb3IgZXh0ZW5zaWJpbGl0eSAqLw0KIH07DQorI2RlZmluZSBfX0FSQ0hfSEFTX1NBX1JFU1RP
UkVSDQogDQogc3RydWN0IGtfc2lnYWN0aW9uIHsNCiAJc3RydWN0IHNpZ2FjdGlvbiBzYTsNCmRp
ZmYgLS1naXQgYS9hcmNoL2F2cjMyL2luY2x1ZGUvYXNtL3NpZ25hbC5oIGIvYXJjaC9hdnIzMi9p
bmNsdWRlL2FzbS9zaWduYWwuaA0KaW5kZXggODc5MGRmYy4uZTY5NTJhMCAxMDA2NDQNCi0tLSBh
L2FyY2gvYXZyMzIvaW5jbHVkZS9hc20vc2lnbmFsLmgNCisrKyBiL2FyY2gvYXZyMzIvaW5jbHVk
ZS9hc20vc2lnbmFsLmgNCkBAIC0xMjgsNiArMTI4LDcgQEAgc3RydWN0IHNpZ2FjdGlvbiB7DQog
CV9fc2lncmVzdG9yZV90IHNhX3Jlc3RvcmVyOw0KIAlzaWdzZXRfdCBzYV9tYXNrOwkJLyogbWFz
ayBsYXN0IGZvciBleHRlbnNpYmlsaXR5ICovDQogfTsNCisjZGVmaW5lIF9fQVJDSF9IQVNfU0Ff
UkVTVE9SRVINCiANCiBzdHJ1Y3Qga19zaWdhY3Rpb24gew0KIAlzdHJ1Y3Qgc2lnYWN0aW9uIHNh
Ow0KZGlmZiAtLWdpdCBhL2FyY2gvY3Jpcy9pbmNsdWRlL2FzbS9zaWduYWwuaCBiL2FyY2gvY3Jp
cy9pbmNsdWRlL2FzbS9zaWduYWwuaA0KaW5kZXggZWE2YWY5YS4uMDU3ZmVhMiAxMDA2NDQNCi0t
LSBhL2FyY2gvY3Jpcy9pbmNsdWRlL2FzbS9zaWduYWwuaA0KKysrIGIvYXJjaC9jcmlzL2luY2x1
ZGUvYXNtL3NpZ25hbC5oDQpAQCAtMTIyLDYgKzEyMiw3IEBAIHN0cnVjdCBzaWdhY3Rpb24gew0K
IAl2b2lkICgqc2FfcmVzdG9yZXIpKHZvaWQpOw0KIAlzaWdzZXRfdCBzYV9tYXNrOwkJLyogbWFz
ayBsYXN0IGZvciBleHRlbnNpYmlsaXR5ICovDQogfTsNCisjZGVmaW5lIF9fQVJDSF9IQVNfU0Ff
UkVTVE9SRVINCiANCiBzdHJ1Y3Qga19zaWdhY3Rpb24gew0KIAlzdHJ1Y3Qgc2lnYWN0aW9uIHNh
Ow0KZGlmZiAtLWdpdCBhL2FyY2gvaDgzMDAvaW5jbHVkZS9hc20vc2lnbmFsLmggYi9hcmNoL2g4
MzAwL2luY2x1ZGUvYXNtL3NpZ25hbC5oDQppbmRleCBmZDhiNjZlLi44Njk1NzA3IDEwMDY0NA0K
LS0tIGEvYXJjaC9oODMwMC9pbmNsdWRlL2FzbS9zaWduYWwuaA0KKysrIGIvYXJjaC9oODMwMC9p
bmNsdWRlL2FzbS9zaWduYWwuaA0KQEAgLTEyMSw2ICsxMjEsNyBAQCBzdHJ1Y3Qgc2lnYWN0aW9u
IHsNCiAJdm9pZCAoKnNhX3Jlc3RvcmVyKSh2b2lkKTsNCiAJc2lnc2V0X3Qgc2FfbWFzazsJCS8q
IG1hc2sgbGFzdCBmb3IgZXh0ZW5zaWJpbGl0eSAqLw0KIH07DQorI2RlZmluZSBfX0FSQ0hfSEFT
X1NBX1JFU1RPUkVSDQogDQogc3RydWN0IGtfc2lnYWN0aW9uIHsNCiAJc3RydWN0IHNpZ2FjdGlv
biBzYTsNCmRpZmYgLS1naXQgYS9hcmNoL20zMnIvaW5jbHVkZS9hc20vc2lnbmFsLmggYi9hcmNo
L20zMnIvaW5jbHVkZS9hc20vc2lnbmFsLmgNCmluZGV4IGIyZWViMGQuLjgwMmQ1NjEgMTAwNjQ0
DQotLS0gYS9hcmNoL20zMnIvaW5jbHVkZS9hc20vc2lnbmFsLmgNCisrKyBiL2FyY2gvbTMyci9p
bmNsdWRlL2FzbS9zaWduYWwuaA0KQEAgLTEyMyw2ICsxMjMsNyBAQCBzdHJ1Y3Qgc2lnYWN0aW9u
IHsNCiAJX19zaWdyZXN0b3JlX3Qgc2FfcmVzdG9yZXI7DQogCXNpZ3NldF90IHNhX21hc2s7CQkv
KiBtYXNrIGxhc3QgZm9yIGV4dGVuc2liaWxpdHkgKi8NCiB9Ow0KKyNkZWZpbmUgX19BUkNIX0hB
U19TQV9SRVNUT1JFUg0KIA0KIHN0cnVjdCBrX3NpZ2FjdGlvbiB7DQogCXN0cnVjdCBzaWdhY3Rp
b24gc2E7DQpkaWZmIC0tZ2l0IGEvYXJjaC9tNjhrL2luY2x1ZGUvYXNtL3NpZ25hbC5oIGIvYXJj
aC9tNjhrL2luY2x1ZGUvYXNtL3NpZ25hbC5oDQppbmRleCA5M2ZlODNlLi5hMjBhZTYzIDEwMDY0
NA0KLS0tIGEvYXJjaC9tNjhrL2luY2x1ZGUvYXNtL3NpZ25hbC5oDQorKysgYi9hcmNoL202OGsv
aW5jbHVkZS9hc20vc2lnbmFsLmgNCkBAIC0xMTksNiArMTE5LDcgQEAgc3RydWN0IHNpZ2FjdGlv
biB7DQogCV9fc2lncmVzdG9yZV90IHNhX3Jlc3RvcmVyOw0KIAlzaWdzZXRfdCBzYV9tYXNrOwkJ
LyogbWFzayBsYXN0IGZvciBleHRlbnNpYmlsaXR5ICovDQogfTsNCisjZGVmaW5lIF9fQVJDSF9I
QVNfU0FfUkVTVE9SRVINCiANCiBzdHJ1Y3Qga19zaWdhY3Rpb24gew0KIAlzdHJ1Y3Qgc2lnYWN0
aW9uIHNhOw0KZGlmZiAtLWdpdCBhL2FyY2gvbW4xMDMwMC9pbmNsdWRlL2FzbS9zaWduYWwuaCBi
L2FyY2gvbW4xMDMwMC9pbmNsdWRlL2FzbS9zaWduYWwuaA0KaW5kZXggMTg2NWQ3Mi4uZWVjYWE3
NiAxMDA2NDQNCi0tLSBhL2FyY2gvbW4xMDMwMC9pbmNsdWRlL2FzbS9zaWduYWwuaA0KKysrIGIv
YXJjaC9tbjEwMzAwL2luY2x1ZGUvYXNtL3NpZ25hbC5oDQpAQCAtMTMxLDYgKzEzMSw3IEBAIHN0
cnVjdCBzaWdhY3Rpb24gew0KIAlfX3NpZ3Jlc3RvcmVfdCBzYV9yZXN0b3JlcjsNCiAJc2lnc2V0
X3Qgc2FfbWFzazsJCS8qIG1hc2sgbGFzdCBmb3IgZXh0ZW5zaWJpbGl0eSAqLw0KIH07DQorI2Rl
ZmluZSBfX0FSQ0hfSEFTX1NBX1JFU1RPUkVSDQogDQogc3RydWN0IGtfc2lnYWN0aW9uIHsNCiAJ
c3RydWN0IHNpZ2FjdGlvbiBzYTsNCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9h
c20vc2lnbmFsLmggYi9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vc2lnbmFsLmgNCmluZGV4IDNl
YjEzYmUuLmVjNjNhMGEgMTAwNjQ0DQotLS0gYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vc2ln
bmFsLmgNCisrKyBiL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9zaWduYWwuaA0KQEAgLTEwOSw2
ICsxMDksNyBAQCBzdHJ1Y3Qgc2lnYWN0aW9uIHsNCiAJX19zaWdyZXN0b3JlX3Qgc2FfcmVzdG9y
ZXI7DQogCXNpZ3NldF90IHNhX21hc2s7CQkvKiBtYXNrIGxhc3QgZm9yIGV4dGVuc2liaWxpdHkg
Ki8NCiB9Ow0KKyNkZWZpbmUgX19BUkNIX0hBU19TQV9SRVNUT1JFUg0KIA0KIHN0cnVjdCBrX3Np
Z2FjdGlvbiB7DQogCXN0cnVjdCBzaWdhY3Rpb24gc2E7DQpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dl
cnBjL2tlcm5lbC9jcHV0YWJsZS5jIGIvYXJjaC9wb3dlcnBjL2tlcm5lbC9jcHV0YWJsZS5jDQpp
bmRleCBlZGFlNWJiLi5iOTJiNzU2IDEwMDY0NA0KLS0tIGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9j
cHV0YWJsZS5jDQorKysgYi9hcmNoL3Bvd2VycGMva2VybmVsL2NwdXRhYmxlLmMNCkBAIC0yNjgs
NyArMjY4LDcgQEAgc3RhdGljIHN0cnVjdCBjcHVfc3BlYyBfX2luaXRkYXRhIGNwdV9zcGVjc1td
ID0gew0KIAkJLmNwdV9mZWF0dXJlcwkJPSBDUFVfRlRSU19QUEM5NzAsDQogCQkuY3B1X3VzZXJf
ZmVhdHVyZXMJPSBDT01NT05fVVNFUl9QT1dFUjQgfA0KIAkJCVBQQ19GRUFUVVJFX0hBU19BTFRJ
VkVDX0NPTVAsDQotCQkubW11X2ZlYXR1cmVzCQk9IE1NVV9GVFJfSFBURV9UQUJMRSwNCisJCS5t
bXVfZmVhdHVyZXMJCT0gTU1VX0ZUUlNfUFBDOTcwLA0KIAkJLmljYWNoZV9ic2l6ZQkJPSAxMjgs
DQogCQkuZGNhY2hlX2JzaXplCQk9IDEyOCwNCiAJCS5udW1fcG1jcwkJPSA4LA0KZGlmZiAtLWdp
dCBhL2FyY2gvczM5MC9pbmNsdWRlL2FzbS9zaWduYWwuaCBiL2FyY2gvczM5MC9pbmNsdWRlL2Fz
bS9zaWduYWwuaA0KaW5kZXggY2RmNWNiMi4uYzg3MjYyNiAxMDA2NDQNCi0tLSBhL2FyY2gvczM5
MC9pbmNsdWRlL2FzbS9zaWduYWwuaA0KKysrIGIvYXJjaC9zMzkwL2luY2x1ZGUvYXNtL3NpZ25h
bC5oDQpAQCAtMTMxLDYgKzEzMSw3IEBAIHN0cnVjdCBzaWdhY3Rpb24gew0KICAgICAgICAgdm9p
ZCAoKnNhX3Jlc3RvcmVyKSh2b2lkKTsNCiAgICAgICAgIHNpZ3NldF90IHNhX21hc2s7ICAgICAg
ICAgICAgICAgLyogbWFzayBsYXN0IGZvciBleHRlbnNpYmlsaXR5ICovDQogfTsNCisjZGVmaW5l
IF9fQVJDSF9IQVNfU0FfUkVTVE9SRVINCiANCiBzdHJ1Y3Qga19zaWdhY3Rpb24gew0KICAgICAg
ICAgc3RydWN0IHNpZ2FjdGlvbiBzYTsNCmRpZmYgLS1naXQgYS9hcmNoL3MzOTAvaW5jbHVkZS9h
c20vdGxiZmx1c2guaCBiL2FyY2gvczM5MC9pbmNsdWRlL2FzbS90bGJmbHVzaC5oDQppbmRleCAx
ZDg2NDhjLi44NzQzMDI5IDEwMDY0NA0KLS0tIGEvYXJjaC9zMzkwL2luY2x1ZGUvYXNtL3RsYmZs
dXNoLmgNCisrKyBiL2FyY2gvczM5MC9pbmNsdWRlL2FzbS90bGJmbHVzaC5oDQpAQCAtNzQsOCAr
NzQsNiBAQCBzdGF0aWMgaW5saW5lIHZvaWQgX190bGJfZmx1c2hfaWR0ZSh1bnNpZ25lZCBsb25n
IGFzY2UpDQogDQogc3RhdGljIGlubGluZSB2b2lkIF9fdGxiX2ZsdXNoX21tKHN0cnVjdCBtbV9z
dHJ1Y3QgKiBtbSkNCiB7DQotCWlmICh1bmxpa2VseShjcHVtYXNrX2VtcHR5KG1tX2NwdW1hc2so
bW0pKSkpDQotCQlyZXR1cm47DQogCS8qDQogCSAqIElmIHRoZSBtYWNoaW5lIGhhcyBJRFRFIHdl
IHByZWZlciB0byBkbyBhIHBlciBtbSBmbHVzaA0KIAkgKiBvbiBhbGwgY3B1cyBpbnN0ZWFkIG9m
IGRvaW5nIGEgbG9jYWwgZmx1c2ggaWYgdGhlIG1tDQpkaWZmIC0tZ2l0IGEvYXJjaC9zcGFyYy9p
bmNsdWRlL2FzbS9zaWduYWwuaCBiL2FyY2gvc3BhcmMvaW5jbHVkZS9hc20vc2lnbmFsLmgNCmlu
ZGV4IGU0OWI4MjguLjQ5Mjk0MzEgMTAwNjQ0DQotLS0gYS9hcmNoL3NwYXJjL2luY2x1ZGUvYXNt
L3NpZ25hbC5oDQorKysgYi9hcmNoL3NwYXJjL2luY2x1ZGUvYXNtL3NpZ25hbC5oDQpAQCAtMTkx
LDYgKzE5MSw3IEBAIHN0cnVjdCBfX29sZF9zaWdhY3Rpb24gew0KIAl1bnNpZ25lZCBsb25nCQlz
YV9mbGFnczsNCiAJdm9pZAkJCSgqc2FfcmVzdG9yZXIpKHZvaWQpOyAgLyogbm90IHVzZWQgYnkg
TGludXgvU1BBUkMgeWV0ICovDQogfTsNCisjZGVmaW5lIF9fQVJDSF9IQVNfU0FfUkVTVE9SRVIN
CiANCiB0eXBlZGVmIHN0cnVjdCBzaWdhbHRzdGFjayB7DQogCXZvaWQJCQlfX3VzZXIgKnNzX3Nw
Ow0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NpZ25hbC5oIGIvYXJjaC94ODYv
aW5jbHVkZS9hc20vc2lnbmFsLmgNCmluZGV4IDU5ODQ1N2MuLjZjYmM3OTUgMTAwNjQ0DQotLS0g
YS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zaWduYWwuaA0KKysrIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20vc2lnbmFsLmgNCkBAIC0xMjUsNiArMTI1LDggQEAgdHlwZWRlZiB1bnNpZ25lZCBsb25nIHNp
Z3NldF90Ow0KIGV4dGVybiB2b2lkIGRvX25vdGlmeV9yZXN1bWUoc3RydWN0IHB0X3JlZ3MgKiwg
dm9pZCAqLCBfX3UzMik7DQogIyBlbmRpZiAvKiBfX0tFUk5FTF9fICovDQogDQorI2RlZmluZSBf
X0FSQ0hfSEFTX1NBX1JFU1RPUkVSDQorDQogI2lmZGVmIF9faTM4Nl9fDQogIyBpZmRlZiBfX0tF
Uk5FTF9fDQogc3RydWN0IG9sZF9zaWdhY3Rpb24gew0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tl
cm5lbC9jcHUvcGVyZl9ldmVudF9pbnRlbF9kcy5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9wZXJm
X2V2ZW50X2ludGVsX2RzLmMNCmluZGV4IDczZGE2YjYuLjJkNGU3NmIgMTAwNjQ0DQotLS0gYS9h
cmNoL3g4Ni9rZXJuZWwvY3B1L3BlcmZfZXZlbnRfaW50ZWxfZHMuYw0KKysrIGIvYXJjaC94ODYv
a2VybmVsL2NwdS9wZXJmX2V2ZW50X2ludGVsX2RzLmMNCkBAIC03MzYsMyArNzM2LDEzIEBAIHZv
aWQgaW50ZWxfZHNfaW5pdCh2b2lkKQ0KIAkJfQ0KIAl9DQogfQ0KKw0KK3ZvaWQgcGVyZl9yZXN0
b3JlX2RlYnVnX3N0b3JlKHZvaWQpDQorew0KKwlzdHJ1Y3QgZGVidWdfc3RvcmUgKmRzID0gX190
aGlzX2NwdV9yZWFkKGNwdV9od19ldmVudHMuZHMpOw0KKw0KKwlpZiAoIXg4Nl9wbXUuYnRzICYm
ICF4ODZfcG11LnBlYnMpDQorCQlyZXR1cm47DQorDQorCXdybXNybChNU1JfSUEzMl9EU19BUkVB
LCAodW5zaWduZWQgbG9uZylkcyk7DQorfQ0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2xpYi91c2Vy
Y29weV82NC5jIGIvYXJjaC94ODYvbGliL3VzZXJjb3B5XzY0LmMNCmluZGV4IGI3YzI4NDkuLjU1
NGI3YjUgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9saWIvdXNlcmNvcHlfNjQuYw0KKysrIGIvYXJj
aC94ODYvbGliL3VzZXJjb3B5XzY0LmMNCkBAIC0xNjksMTAgKzE2OSwxMCBAQCBjb3B5X3VzZXJf
aGFuZGxlX3RhaWwoY2hhciAqdG8sIGNoYXIgKmZyb20sIHVuc2lnbmVkIGxlbiwgdW5zaWduZWQg
emVyb3Jlc3QpDQogCWNoYXIgYzsNCiAJdW5zaWduZWQgemVyb19sZW47DQogDQotCWZvciAoOyBs
ZW47IC0tbGVuKSB7DQorCWZvciAoOyBsZW47IC0tbGVuLCB0bysrKSB7DQogCQlpZiAoX19nZXRf
dXNlcl9ub2NoZWNrKGMsIGZyb20rKywgc2l6ZW9mKGNoYXIpKSkNCiAJCQlicmVhazsNCi0JCWlm
IChfX3B1dF91c2VyX25vY2hlY2soYywgdG8rKywgc2l6ZW9mKGNoYXIpKSkNCisJCWlmIChfX3B1
dF91c2VyX25vY2hlY2soYywgdG8sIHNpemVvZihjaGFyKSkpDQogCQkJYnJlYWs7DQogCX0NCiAN
CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9wb3dlci9jcHUuYyBiL2FyY2gveDg2L3Bvd2VyL2NwdS5j
DQppbmRleCBmMTBjMGFmLi40M2M5ZjZhIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvcG93ZXIvY3B1
LmMNCisrKyBiL2FyY2gveDg2L3Bvd2VyL2NwdS5jDQpAQCAtMTEsNiArMTEsNyBAQA0KICNpbmNs
dWRlIDxsaW51eC9zdXNwZW5kLmg+DQogI2luY2x1ZGUgPGxpbnV4L2V4cG9ydC5oPg0KICNpbmNs
dWRlIDxsaW51eC9zbXAuaD4NCisjaW5jbHVkZSA8bGludXgvcGVyZl9ldmVudC5oPg0KIA0KICNp
bmNsdWRlIDxhc20vcGd0YWJsZS5oPg0KICNpbmNsdWRlIDxhc20vcHJvdG8uaD4NCkBAIC0yMjUs
NiArMjI2LDcgQEAgc3RhdGljIHZvaWQgX19yZXN0b3JlX3Byb2Nlc3Nvcl9zdGF0ZShzdHJ1Y3Qg
c2F2ZWRfY29udGV4dCAqY3R4dCkNCiANCiAJZG9fZnB1X2VuZCgpOw0KIAltdHJyX2JwX3Jlc3Rv
cmUoKTsNCisJcGVyZl9yZXN0b3JlX2RlYnVnX3N0b3JlKCk7DQogfQ0KIA0KIC8qIE5lZWRlZCBi
eSBhcG0uYyAqLw0KZGlmZiAtLWdpdCBhL2FyY2gveHRlbnNhL2luY2x1ZGUvYXNtL3NpZ25hbC5o
IGIvYXJjaC94dGVuc2EvaW5jbHVkZS9hc20vc2lnbmFsLmgNCmluZGV4IDYzM2JhNzMuLjc1ZWRm
OGEgMTAwNjQ0DQotLS0gYS9hcmNoL3h0ZW5zYS9pbmNsdWRlL2FzbS9zaWduYWwuaA0KKysrIGIv
YXJjaC94dGVuc2EvaW5jbHVkZS9hc20vc2lnbmFsLmgNCkBAIC0xMzMsNiArMTMzLDcgQEAgc3Ry
dWN0IHNpZ2FjdGlvbiB7DQogCXZvaWQgKCpzYV9yZXN0b3Jlcikodm9pZCk7DQogCXNpZ3NldF90
IHNhX21hc2s7CQkvKiBtYXNrIGxhc3QgZm9yIGV4dGVuc2liaWxpdHkgKi8NCiB9Ow0KKyNkZWZp
bmUgX19BUkNIX0hBU19TQV9SRVNUT1JFUg0KIA0KIHN0cnVjdCBrX3NpZ2FjdGlvbiB7DQogCXN0
cnVjdCBzaWdhY3Rpb24gc2E7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9maXJtd2FyZS9LY29uZmln
IGIvZHJpdmVycy9maXJtd2FyZS9LY29uZmlnDQppbmRleCBlZmJhMTYzLi5iZjRkNmUyIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9maXJtd2FyZS9LY29uZmlnDQorKysgYi9kcml2ZXJzL2Zpcm13YXJl
L0tjb25maWcNCkBAIC01Myw2ICs1MywyNCBAQCBjb25maWcgRUZJX1ZBUlMNCiAJICBTdWJzZXF1
ZW50IGVmaWJvb3RtZ3IgcmVsZWFzZXMgbWF5IGJlIGZvdW5kIGF0Og0KIAkgIDxodHRwOi8vbGlu
dXguZGVsbC5jb20vZWZpYm9vdG1ncj4NCiANCitjb25maWcgRUZJX1ZBUlNfUFNUT1JFDQorCWJv
b2wgIlJlZ2lzdGVyIGVmaXZhcnMgYmFja2VuZCBmb3IgcHN0b3JlIg0KKwlkZXBlbmRzIG9uIEVG
SV9WQVJTICYmIFBTVE9SRQ0KKwlkZWZhdWx0IHkNCisJaGVscA0KKwkgIFNheSBZIGhlcmUgdG8g
ZW5hYmxlIHVzZSBlZml2YXJzIGFzIGEgYmFja2VuZCB0byBwc3RvcmUuIFRoaXMNCisJICB3aWxs
IGFsbG93IHdyaXRpbmcgY29uc29sZSBtZXNzYWdlcywgY3Jhc2ggZHVtcHMsIG9yIGFueXRoaW5n
DQorCSAgZWxzZSBzdXBwb3J0ZWQgYnkgcHN0b3JlIHRvIEVGSSB2YXJpYWJsZXMuDQorDQorY29u
ZmlnIEVGSV9WQVJTX1BTVE9SRV9ERUZBVUxUX0RJU0FCTEUNCisJYm9vbCAiRGlzYWJsZSB1c2lu
ZyBlZml2YXJzIGFzIGEgcHN0b3JlIGJhY2tlbmQgYnkgZGVmYXVsdCINCisJZGVwZW5kcyBvbiBF
RklfVkFSU19QU1RPUkUNCisJZGVmYXVsdCBuDQorCWhlbHANCisJICBTYXlpbmcgWSBoZXJlIHdp
bGwgZGlzYWJsZSB0aGUgdXNlIG9mIGVmaXZhcnMgYXMgYSBzdG9yYWdlDQorCSAgYmFja2VuZCBm
b3IgcHN0b3JlIGJ5IGRlZmF1bHQuIFRoaXMgc2V0dGluZyBjYW4gYmUgb3ZlcnJpZGRlbg0KKwkg
IHVzaW5nIHRoZSBlZml2YXJzIG1vZHVsZSdzIHBzdG9yZV9kaXNhYmxlIHBhcmFtZXRlci4NCisN
CiBjb25maWcgRUZJX1BDRFANCiAJYm9vbCAiQ29uc29sZSBkZXZpY2Ugc2VsZWN0aW9uIHZpYSBF
RkkgUENEUCBvciBIQ0RQIHRhYmxlIg0KIAlkZXBlbmRzIG9uIEFDUEkgJiYgRUZJICYmIElBNjQN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2Zpcm13YXJlL2VmaXZhcnMuYyBiL2RyaXZlcnMvZmlybXdh
cmUvZWZpdmFycy5jDQppbmRleCA4MTM0NmFlLi5iMTVjMGFhIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9maXJtd2FyZS9lZml2YXJzLmMNCisrKyBiL2RyaXZlcnMvZmlybXdhcmUvZWZpdmFycy5jDQpA
QCAtOTIsNiArOTIsMTEgQEAgTU9EVUxFX1ZFUlNJT04oRUZJVkFSU19WRVJTSU9OKTsNCiANCiAj
ZGVmaW5lIERVTVBfTkFNRV9MRU4gNTINCiANCitzdGF0aWMgYm9vbCBlZml2YXJzX3BzdG9yZV9k
aXNhYmxlID0NCisJSVNfRU5BQkxFRChDT05GSUdfRUZJX1ZBUlNfUFNUT1JFX0RFRkFVTFRfRElT
QUJMRSk7DQorDQorbW9kdWxlX3BhcmFtX25hbWVkKHBzdG9yZV9kaXNhYmxlLCBlZml2YXJzX3Bz
dG9yZV9kaXNhYmxlLCBib29sLCAwNjQ0KTsNCisNCiAvKg0KICAqIFRoZSBtYXhpbXVtIHNpemUg
b2YgVmFyaWFibGVOYW1lICsgRGF0YSA9IDEwMjQNCiAgKiBUaGVyZWZvcmUsIGl0J3MgcmVhc29u
YWJsZSB0byBzYXZlIHRoYXQgbXVjaA0KQEAgLTEyMiw2ICsxMjcsOCBAQCBzdHJ1Y3QgZWZpdmFy
X2F0dHJpYnV0ZSB7DQogCXNzaXplX3QgKCpzdG9yZSkoc3RydWN0IGVmaXZhcl9lbnRyeSAqZW50
cnksIGNvbnN0IGNoYXIgKmJ1Ziwgc2l6ZV90IGNvdW50KTsNCiB9Ow0KIA0KK3N0YXRpYyBzdHJ1
Y3QgZWZpdmFycyBfX2VmaXZhcnM7DQorDQogI2RlZmluZSBQU1RPUkVfRUZJX0FUVFJJQlVURVMg
XA0KIAkoRUZJX1ZBUklBQkxFX05PTl9WT0xBVElMRSB8IFwNCiAJIEVGSV9WQVJJQUJMRV9CT09U
U0VSVklDRV9BQ0NFU1MgfCBcDQpAQCAtMTQ2LDYgKzE1MywxNCBAQCBlZml2YXJfY3JlYXRlX3N5
c2ZzX2VudHJ5KHN0cnVjdCBlZml2YXJzICplZml2YXJzLA0KIAkJCSAgZWZpX2NoYXIxNl90ICp2
YXJpYWJsZV9uYW1lLA0KIAkJCSAgZWZpX2d1aWRfdCAqdmVuZG9yX2d1aWQpOw0KIA0KKy8qDQor
ICogUHJvdG90eXBlIGZvciB3b3JrcXVldWUgZnVuY3Rpb25zIHVwZGF0aW5nIHN5c2ZzIGVudHJ5
DQorICovDQorDQorc3RhdGljIHZvaWQgZWZpdmFyX3VwZGF0ZV9zeXNmc19lbnRyaWVzKHN0cnVj
dCB3b3JrX3N0cnVjdCAqKTsNCitzdGF0aWMgREVDTEFSRV9XT1JLKGVmaXZhcl93b3JrLCBlZml2
YXJfdXBkYXRlX3N5c2ZzX2VudHJpZXMpOw0KK3N0YXRpYyBib29sIGVmaXZhcl93cV9lbmFibGVk
ID0gdHJ1ZTsNCisNCiAvKiBSZXR1cm4gdGhlIG51bWJlciBvZiB1bmljb2RlIGNoYXJhY3RlcnMg
aW4gZGF0YSAqLw0KIHN0YXRpYyB1bnNpZ25lZCBsb25nDQogdXRmMTZfc3RybmxlbihlZmlfY2hh
cjE2X3QgKnMsIHNpemVfdCBtYXhsZW5ndGgpDQpAQCAtNjU5LDggKzY3NCw2IEBAIHN0YXRpYyBz
dHJ1Y3Qga29ial90eXBlIGVmaXZhcl9rdHlwZSA9IHsNCiAJLmRlZmF1bHRfYXR0cnMgPSBkZWZf
YXR0cnMsDQogfTsNCiANCi1zdGF0aWMgc3RydWN0IHBzdG9yZV9pbmZvIGVmaV9wc3RvcmVfaW5m
bzsNCi0NCiBzdGF0aWMgaW5saW5lIHZvaWQNCiBlZml2YXJfdW5yZWdpc3RlcihzdHJ1Y3QgZWZp
dmFyX2VudHJ5ICp2YXIpDQogew0KQEAgLTY5Nyw3ICs3MTAsNyBAQCBzdGF0aWMgaW50IGVmaV9z
dGF0dXNfdG9fZXJyKGVmaV9zdGF0dXNfdCBzdGF0dXMpDQogCXJldHVybiBlcnI7DQogfQ0KIA0K
LSNpZmRlZiBDT05GSUdfUFNUT1JFDQorI2lmZGVmIENPTkZJR19FRklfVkFSU19QU1RPUkUNCiAN
CiBzdGF0aWMgaW50IGVmaV9wc3RvcmVfb3BlbihzdHJ1Y3QgcHN0b3JlX2luZm8gKnBzaSkNCiB7
DQpAQCAtNzc0LDE5ICs3ODcsMjEgQEAgc3RhdGljIGludCBlZmlfcHN0b3JlX3dyaXRlKGVudW0g
cHN0b3JlX3R5cGVfaWQgdHlwZSwgdTY0ICppZCwNCiANCiAJc3Bpbl9sb2NrX2lycXNhdmUoJmVm
aXZhcnMtPmxvY2ssIGZsYWdzKTsNCiANCi0JLyoNCi0JICogQ2hlY2sgaWYgdGhlcmUgaXMgYSBz
cGFjZSBlbm91Z2ggdG8gbG9nLg0KLQkgKiBzaXplOiBhIHNpemUgb2YgbG9nZ2luZyBkYXRhDQot
CSAqIERVTVBfTkFNRV9MRU4gKiAyOiBhIG1heGltdW0gc2l6ZSBvZiB2YXJpYWJsZSBuYW1lDQot
CSAqLw0KKwlpZiAoc2l6ZSkgew0KKwkJLyoNCisJCSAqIENoZWNrIGlmIHRoZXJlIGlzIGEgc3Bh
Y2UgZW5vdWdoIHRvIGxvZy4NCisJCSAqIHNpemU6IGEgc2l6ZSBvZiBsb2dnaW5nIGRhdGENCisJ
CSAqIERVTVBfTkFNRV9MRU4gKiAyOiBhIG1heGltdW0gc2l6ZSBvZiB2YXJpYWJsZSBuYW1lDQor
CQkgKi8NCiANCi0Jc3RhdHVzID0gY2hlY2tfdmFyX3NpemVfbG9ja2VkKGVmaXZhcnMsIFBTVE9S
RV9FRklfQVRUUklCVVRFUywNCi0JCQkJCSBzaXplICsgRFVNUF9OQU1FX0xFTiAqIDIpOw0KKwkJ
c3RhdHVzID0gY2hlY2tfdmFyX3NpemVfbG9ja2VkKGVmaXZhcnMsIFBTVE9SRV9FRklfQVRUUklC
VVRFUywNCisJCQkJCSAgICAgICBzaXplICsgRFVNUF9OQU1FX0xFTiAqIDIpOw0KIA0KLQlpZiAo
c3RhdHVzKSB7DQotCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZlZml2YXJzLT5sb2NrLCBmbGFn
cyk7DQotCQkqaWQgPSBwYXJ0Ow0KLQkJcmV0dXJuIC1FTk9TUEM7DQorCQlpZiAoc3RhdHVzKSB7
DQorCQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZWZpdmFycy0+bG9jaywgZmxhZ3MpOw0KKwkJ
CSppZCA9IHBhcnQ7DQorCQkJcmV0dXJuIC1FTk9TUEM7DQorCQl9DQogCX0NCiANCiAJZm9yIChp
ID0gMDsgaSA8IERVTVBfTkFNRV9MRU47IGkrKykNCkBAIC04MzAsMTEgKzg0NSw4IEBAIHN0YXRp
YyBpbnQgZWZpX3BzdG9yZV93cml0ZShlbnVtIHBzdG9yZV90eXBlX2lkIHR5cGUsIHU2NCAqaWQs
DQogCWlmIChmb3VuZCkNCiAJCWVmaXZhcl91bnJlZ2lzdGVyKGZvdW5kKTsNCiANCi0JaWYgKHNp
emUpDQotCQlyZXQgPSBlZml2YXJfY3JlYXRlX3N5c2ZzX2VudHJ5KGVmaXZhcnMsDQotCQkJCQkg
IHV0ZjE2X3N0cnNpemUoZWZpX25hbWUsDQotCQkJCQkJCURVTVBfTkFNRV9MRU4gKiAyKSwNCi0J
CQkJCSAgZWZpX25hbWUsICZ2ZW5kb3IpOw0KKwlpZiAoZWZpdmFyX3dxX2VuYWJsZWQpDQorCQlz
Y2hlZHVsZV93b3JrKCZlZml2YXJfd29yayk7DQogDQogCSppZCA9IHBhcnQ7DQogCXJldHVybiBy
ZXQ7DQpAQCAtODQ3LDM2ICs4NTksNiBAQCBzdGF0aWMgaW50IGVmaV9wc3RvcmVfZXJhc2UoZW51
bSBwc3RvcmVfdHlwZV9pZCB0eXBlLCB1NjQgaWQsDQogDQogCXJldHVybiAwOw0KIH0NCi0jZWxz
ZQ0KLXN0YXRpYyBpbnQgZWZpX3BzdG9yZV9vcGVuKHN0cnVjdCBwc3RvcmVfaW5mbyAqcHNpKQ0K
LXsNCi0JcmV0dXJuIDA7DQotfQ0KLQ0KLXN0YXRpYyBpbnQgZWZpX3BzdG9yZV9jbG9zZShzdHJ1
Y3QgcHN0b3JlX2luZm8gKnBzaSkNCi17DQotCXJldHVybiAwOw0KLX0NCi0NCi1zdGF0aWMgc3Np
emVfdCBlZmlfcHN0b3JlX3JlYWQodTY0ICppZCwgZW51bSBwc3RvcmVfdHlwZV9pZCAqdHlwZSwN
Ci0JCQkgICAgICAgc3RydWN0IHRpbWVzcGVjICp0aW1lc3BlYywNCi0JCQkgICAgICAgY2hhciAq
KmJ1Ziwgc3RydWN0IHBzdG9yZV9pbmZvICpwc2kpDQotew0KLQlyZXR1cm4gLTE7DQotfQ0KLQ0K
LXN0YXRpYyBpbnQgZWZpX3BzdG9yZV93cml0ZShlbnVtIHBzdG9yZV90eXBlX2lkIHR5cGUsIHU2
NCAqaWQsDQotCQl1bnNpZ25lZCBpbnQgcGFydCwgc2l6ZV90IHNpemUsIHN0cnVjdCBwc3RvcmVf
aW5mbyAqcHNpKQ0KLXsNCi0JcmV0dXJuIDA7DQotfQ0KLQ0KLXN0YXRpYyBpbnQgZWZpX3BzdG9y
ZV9lcmFzZShlbnVtIHBzdG9yZV90eXBlX2lkIHR5cGUsIHU2NCBpZCwNCi0JCQkgICAgc3RydWN0
IHBzdG9yZV9pbmZvICpwc2kpDQotew0KLQlyZXR1cm4gMDsNCi19DQotI2VuZGlmDQogDQogc3Rh
dGljIHN0cnVjdCBwc3RvcmVfaW5mbyBlZmlfcHN0b3JlX2luZm8gPSB7DQogCS5vd25lcgkJPSBU
SElTX01PRFVMRSwNCkBAIC04ODgsNiArODcwLDI0IEBAIHN0YXRpYyBzdHJ1Y3QgcHN0b3JlX2lu
Zm8gZWZpX3BzdG9yZV9pbmZvID0gew0KIAkuZXJhc2UJCT0gZWZpX3BzdG9yZV9lcmFzZSwNCiB9
Ow0KIA0KK3N0YXRpYyB2b2lkIGVmaXZhcl9wc3RvcmVfcmVnaXN0ZXIoc3RydWN0IGVmaXZhcnMg
KmVmaXZhcnMpDQorew0KKwllZml2YXJzLT5lZmlfcHN0b3JlX2luZm8gPSBlZmlfcHN0b3JlX2lu
Zm87DQorCWVmaXZhcnMtPmVmaV9wc3RvcmVfaW5mby5idWYgPSBrbWFsbG9jKDQwOTYsIEdGUF9L
RVJORUwpOw0KKwlpZiAoZWZpdmFycy0+ZWZpX3BzdG9yZV9pbmZvLmJ1Zikgew0KKwkJZWZpdmFy
cy0+ZWZpX3BzdG9yZV9pbmZvLmJ1ZnNpemUgPSAxMDI0Ow0KKwkJZWZpdmFycy0+ZWZpX3BzdG9y
ZV9pbmZvLmRhdGEgPSBlZml2YXJzOw0KKwkJc3Bpbl9sb2NrX2luaXQoJmVmaXZhcnMtPmVmaV9w
c3RvcmVfaW5mby5idWZfbG9jayk7DQorCQlwc3RvcmVfcmVnaXN0ZXIoJmVmaXZhcnMtPmVmaV9w
c3RvcmVfaW5mbyk7DQorCX0NCit9DQorI2Vsc2UNCitzdGF0aWMgdm9pZCBlZml2YXJfcHN0b3Jl
X3JlZ2lzdGVyKHN0cnVjdCBlZml2YXJzICplZml2YXJzKQ0KK3sNCisJcmV0dXJuOw0KK30NCisj
ZW5kaWYNCisNCiBzdGF0aWMgc3NpemVfdCBlZml2YXJfY3JlYXRlKHN0cnVjdCBmaWxlICpmaWxw
LCBzdHJ1Y3Qga29iamVjdCAqa29iaiwNCiAJCQkgICAgIHN0cnVjdCBiaW5fYXR0cmlidXRlICpi
aW5fYXR0ciwNCiAJCQkgICAgIGNoYXIgKmJ1ZiwgbG9mZl90IHBvcywgc2l6ZV90IGNvdW50KQ0K
QEAgLTEwMjUsNiArMTAyNSwxMDMgQEAgc3RhdGljIHNzaXplX3QgZWZpdmFyX2RlbGV0ZShzdHJ1
Y3QgZmlsZSAqZmlscCwgc3RydWN0IGtvYmplY3QgKmtvYmosDQogCXJldHVybiBjb3VudDsNCiB9
DQogDQorc3RhdGljIGJvb2wgdmFyaWFibGVfaXNfcHJlc2VudChlZmlfY2hhcjE2X3QgKnZhcmlh
YmxlX25hbWUsIGVmaV9ndWlkX3QgKnZlbmRvcikNCit7DQorCXN0cnVjdCBlZml2YXJfZW50cnkg
KmVudHJ5LCAqbjsNCisJc3RydWN0IGVmaXZhcnMgKmVmaXZhcnMgPSAmX19lZml2YXJzOw0KKwl1
bnNpZ25lZCBsb25nIHN0cnNpemUxLCBzdHJzaXplMjsNCisJYm9vbCBmb3VuZCA9IGZhbHNlOw0K
Kw0KKwlzdHJzaXplMSA9IHV0ZjE2X3N0cnNpemUodmFyaWFibGVfbmFtZSwgMTAyNCk7DQorCWxp
c3RfZm9yX2VhY2hfZW50cnlfc2FmZShlbnRyeSwgbiwgJmVmaXZhcnMtPmxpc3QsIGxpc3QpIHsN
CisJCXN0cnNpemUyID0gdXRmMTZfc3Ryc2l6ZShlbnRyeS0+dmFyLlZhcmlhYmxlTmFtZSwgMTAy
NCk7DQorCQlpZiAoc3Ryc2l6ZTEgPT0gc3Ryc2l6ZTIgJiYNCisJCQkhbWVtY21wKHZhcmlhYmxl
X25hbWUsICYoZW50cnktPnZhci5WYXJpYWJsZU5hbWUpLA0KKwkJCQlzdHJzaXplMikgJiYNCisJ
CQkhZWZpX2d1aWRjbXAoZW50cnktPnZhci5WZW5kb3JHdWlkLA0KKwkJCQkqdmVuZG9yKSkgew0K
KwkJCWZvdW5kID0gdHJ1ZTsNCisJCQlicmVhazsNCisJCX0NCisJfQ0KKwlyZXR1cm4gZm91bmQ7
DQorfQ0KKw0KKy8qDQorICogUmV0dXJucyB0aGUgc2l6ZSBvZiB2YXJpYWJsZV9uYW1lLCBpbiBi
eXRlcywgaW5jbHVkaW5nIHRoZQ0KKyAqIHRlcm1pbmF0aW5nIE5VTEwgY2hhcmFjdGVyLCBvciB2
YXJpYWJsZV9uYW1lX3NpemUgaWYgbm8gTlVMTA0KKyAqIGNoYXJhY3RlciBpcyBmb3VuZCBhbW9u
ZyB0aGUgZmlyc3QgdmFyaWFibGVfbmFtZV9zaXplIGJ5dGVzLg0KKyAqLw0KK3N0YXRpYyB1bnNp
Z25lZCBsb25nIHZhcl9uYW1lX3N0cm5zaXplKGVmaV9jaGFyMTZfdCAqdmFyaWFibGVfbmFtZSwN
CisJCQkJICAgICAgIHVuc2lnbmVkIGxvbmcgdmFyaWFibGVfbmFtZV9zaXplKQ0KK3sNCisJdW5z
aWduZWQgbG9uZyBsZW47DQorCWVmaV9jaGFyMTZfdCBjOw0KKw0KKwkvKg0KKwkgKiBUaGUgdmFy
aWFibGUgbmFtZSBpcywgYnkgZGVmaW5pdGlvbiwgYSBOVUxMLXRlcm1pbmF0ZWQNCisJICogc3Ry
aW5nLCBzbyBtYWtlIGFic29sdXRlbHkgc3VyZSB0aGF0IHZhcmlhYmxlX25hbWVfc2l6ZSBpcw0K
KwkgKiB0aGUgdmFsdWUgd2UgZXhwZWN0IGl0IHRvIGJlLiBJZiBub3QsIHJldHVybiB0aGUgcmVh
bCBzaXplLg0KKwkgKi8NCisJZm9yIChsZW4gPSAyOyBsZW4gPD0gdmFyaWFibGVfbmFtZV9zaXpl
OyBsZW4gKz0gc2l6ZW9mKGMpKSB7DQorCQljID0gdmFyaWFibGVfbmFtZVsobGVuIC8gc2l6ZW9m
KGMpKSAtIDFdOw0KKwkJaWYgKCFjKQ0KKwkJCWJyZWFrOw0KKwl9DQorDQorCXJldHVybiBtaW4o
bGVuLCB2YXJpYWJsZV9uYW1lX3NpemUpOw0KK30NCisNCitzdGF0aWMgdm9pZCBlZml2YXJfdXBk
YXRlX3N5c2ZzX2VudHJpZXMoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KK3sNCisJc3RydWN0
IGVmaXZhcnMgKmVmaXZhcnMgPSAmX19lZml2YXJzOw0KKwllZmlfZ3VpZF90IHZlbmRvcjsNCisJ
ZWZpX2NoYXIxNl90ICp2YXJpYWJsZV9uYW1lOw0KKwl1bnNpZ25lZCBsb25nIHZhcmlhYmxlX25h
bWVfc2l6ZSA9IDEwMjQ7DQorCWVmaV9zdGF0dXNfdCBzdGF0dXMgPSBFRklfTk9UX0ZPVU5EOw0K
Kwlib29sIGZvdW5kOw0KKw0KKwkvKiBBZGQgbmV3IHN5c2ZzIGVudHJpZXMgKi8NCisJd2hpbGUg
KDEpIHsNCisJCXZhcmlhYmxlX25hbWUgPSBremFsbG9jKHZhcmlhYmxlX25hbWVfc2l6ZSwgR0ZQ
X0tFUk5FTCk7DQorCQlpZiAoIXZhcmlhYmxlX25hbWUpIHsNCisJCQlwcl9lcnIoImVmaXZhcnM6
IE1lbW9yeSBhbGxvY2F0aW9uIGZhaWxlZC5cbiIpOw0KKwkJCXJldHVybjsNCisJCX0NCisNCisJ
CXNwaW5fbG9ja19pcnEoJmVmaXZhcnMtPmxvY2spOw0KKwkJZm91bmQgPSBmYWxzZTsNCisJCXdo
aWxlICgxKSB7DQorCQkJdmFyaWFibGVfbmFtZV9zaXplID0gMTAyNDsNCisJCQlzdGF0dXMgPSBl
Zml2YXJzLT5vcHMtPmdldF9uZXh0X3ZhcmlhYmxlKA0KKwkJCQkJCQkmdmFyaWFibGVfbmFtZV9z
aXplLA0KKwkJCQkJCQl2YXJpYWJsZV9uYW1lLA0KKwkJCQkJCQkmdmVuZG9yKTsNCisJCQlpZiAo
c3RhdHVzICE9IEVGSV9TVUNDRVNTKSB7DQorCQkJCWJyZWFrOw0KKwkJCX0gZWxzZSB7DQorCQkJ
CWlmICghdmFyaWFibGVfaXNfcHJlc2VudCh2YXJpYWJsZV9uYW1lLA0KKwkJCQkgICAgJnZlbmRv
cikpIHsNCisJCQkJCWZvdW5kID0gdHJ1ZTsNCisJCQkJCWJyZWFrOw0KKwkJCQl9DQorCQkJfQ0K
KwkJfQ0KKwkJc3Bpbl91bmxvY2tfaXJxKCZlZml2YXJzLT5sb2NrKTsNCisNCisJCWlmICghZm91
bmQpIHsNCisJCQlrZnJlZSh2YXJpYWJsZV9uYW1lKTsNCisJCQlicmVhazsNCisJCX0gZWxzZSB7
DQorCQkJdmFyaWFibGVfbmFtZV9zaXplID0gdmFyX25hbWVfc3RybnNpemUodmFyaWFibGVfbmFt
ZSwNCisJCQkJCQkJICAgICAgIHZhcmlhYmxlX25hbWVfc2l6ZSk7DQorCQkJZWZpdmFyX2NyZWF0
ZV9zeXNmc19lbnRyeShlZml2YXJzLA0KKwkJCQkJCSAgdmFyaWFibGVfbmFtZV9zaXplLA0KKwkJ
CQkJCSAgdmFyaWFibGVfbmFtZSwgJnZlbmRvcik7DQorCQl9DQorCX0NCit9DQorDQogLyoNCiAg
KiBMZXQncyBub3QgbGVhdmUgb3V0IHN5c3RhYiBpbmZvcm1hdGlvbiB0aGF0IHNudWNrIGludG8N
CiAgKiB0aGUgZWZpdmFycyBkcml2ZXINCkBAIC0xMjEyLDYgKzEzMDksMzUgQEAgdm9pZCB1bnJl
Z2lzdGVyX2VmaXZhcnMoc3RydWN0IGVmaXZhcnMgKmVmaXZhcnMpDQogfQ0KIEVYUE9SVF9TWU1C
T0xfR1BMKHVucmVnaXN0ZXJfZWZpdmFycyk7DQogDQorLyoNCisgKiBQcmludCBhIHdhcm5pbmcg
d2hlbiBkdXBsaWNhdGUgRUZJIHZhcmlhYmxlcyBhcmUgZW5jb3VudGVyZWQgYW5kDQorICogZGlz
YWJsZSB0aGUgc3lzZnMgd29ya3F1ZXVlIHNpbmNlIHRoZSBmaXJtd2FyZSBpcyBidWdneS4NCisg
Ki8NCitzdGF0aWMgdm9pZCBkdXBfdmFyaWFibGVfYnVnKGVmaV9jaGFyMTZfdCAqczE2LCBlZmlf
Z3VpZF90ICp2ZW5kb3JfZ3VpZCwNCisJCQkgICAgIHVuc2lnbmVkIGxvbmcgbGVuMTYpDQorew0K
KwlzaXplX3QgaSwgbGVuOCA9IGxlbjE2IC8gc2l6ZW9mKGVmaV9jaGFyMTZfdCk7DQorCWNoYXIg
KnM4Ow0KKw0KKwkvKg0KKwkgKiBEaXNhYmxlIHRoZSB3b3JrcXVldWUgc2luY2UgdGhlIGFsZ29y
aXRobSBpdCB1c2VzIGZvcg0KKwkgKiBkZXRlY3RpbmcgbmV3IHZhcmlhYmxlcyB3b24ndCB3b3Jr
IHdpdGggdGhpcyBidWdneQ0KKwkgKiBpbXBsZW1lbnRhdGlvbiBvZiBHZXROZXh0VmFyaWFibGVO
YW1lKCkuDQorCSAqLw0KKwllZml2YXJfd3FfZW5hYmxlZCA9IGZhbHNlOw0KKw0KKwlzOCA9IGt6
YWxsb2MobGVuOCwgR0ZQX0tFUk5FTCk7DQorCWlmICghczgpDQorCQlyZXR1cm47DQorDQorCWZv
ciAoaSA9IDA7IGkgPCBsZW44OyBpKyspDQorCQlzOFtpXSA9IHMxNltpXTsNCisNCisJcHJpbnRr
KEtFUk5fV0FSTklORyAiZWZpdmFyczogZHVwbGljYXRlIHZhcmlhYmxlOiAlcy0lcFVsXG4iLA0K
KwkgICAgICAgczgsIHZlbmRvcl9ndWlkKTsNCisJa2ZyZWUoczgpOw0KK30NCisNCiBpbnQgcmVn
aXN0ZXJfZWZpdmFycyhzdHJ1Y3QgZWZpdmFycyAqZWZpdmFycywNCiAJCSAgICAgY29uc3Qgc3Ry
dWN0IGVmaXZhcl9vcGVyYXRpb25zICpvcHMsDQogCQkgICAgIHN0cnVjdCBrb2JqZWN0ICpwYXJl
bnRfa29iaikNCkBAIC0xMjUyLDYgKzEzNzgsMjQgQEAgaW50IHJlZ2lzdGVyX2VmaXZhcnMoc3Ry
dWN0IGVmaXZhcnMgKmVmaXZhcnMsDQogCQkJCQkJJnZlbmRvcl9ndWlkKTsNCiAJCXN3aXRjaCAo
c3RhdHVzKSB7DQogCQljYXNlIEVGSV9TVUNDRVNTOg0KKwkJCXZhcmlhYmxlX25hbWVfc2l6ZSA9
IHZhcl9uYW1lX3N0cm5zaXplKHZhcmlhYmxlX25hbWUsDQorCQkJCQkJCSAgICAgICB2YXJpYWJs
ZV9uYW1lX3NpemUpOw0KKw0KKwkJCS8qDQorCQkJICogU29tZSBmaXJtd2FyZSBpbXBsZW1lbnRh
dGlvbnMgcmV0dXJuIHRoZQ0KKwkJCSAqIHNhbWUgdmFyaWFibGUgbmFtZSBvbiBtdWx0aXBsZSBj
YWxscyB0bw0KKwkJCSAqIGdldF9uZXh0X3ZhcmlhYmxlKCkuIFRlcm1pbmF0ZSB0aGUgbG9vcA0K
KwkJCSAqIGltbWVkaWF0ZWx5IGFzIHRoZXJlIGlzIG5vIGd1YXJhbnRlZSB0aGF0DQorCQkJICog
d2UnbGwgZXZlciBzZWUgYSBkaWZmZXJlbnQgdmFyaWFibGUgbmFtZSwNCisJCQkgKiBhbmQgbWF5
IGVuZCB1cCBsb29waW5nIGhlcmUgZm9yZXZlci4NCisJCQkgKi8NCisJCQlpZiAodmFyaWFibGVf
aXNfcHJlc2VudCh2YXJpYWJsZV9uYW1lLCAmdmVuZG9yX2d1aWQpKSB7DQorCQkJCWR1cF92YXJp
YWJsZV9idWcodmFyaWFibGVfbmFtZSwgJnZlbmRvcl9ndWlkLA0KKwkJCQkJCSB2YXJpYWJsZV9u
YW1lX3NpemUpOw0KKwkJCQlzdGF0dXMgPSBFRklfTk9UX0ZPVU5EOw0KKwkJCQlicmVhazsNCisJ
CQl9DQorDQogCQkJZWZpdmFyX2NyZWF0ZV9zeXNmc19lbnRyeShlZml2YXJzLA0KIAkJCQkJCSAg
dmFyaWFibGVfbmFtZV9zaXplLA0KIAkJCQkJCSAgdmFyaWFibGVfbmFtZSwNCkBAIC0xMjcxLDE1
ICsxNDE1LDggQEAgaW50IHJlZ2lzdGVyX2VmaXZhcnMoc3RydWN0IGVmaXZhcnMgKmVmaXZhcnMs
DQogCWlmIChlcnJvcikNCiAJCXVucmVnaXN0ZXJfZWZpdmFycyhlZml2YXJzKTsNCiANCi0JZWZp
dmFycy0+ZWZpX3BzdG9yZV9pbmZvID0gZWZpX3BzdG9yZV9pbmZvOw0KLQ0KLQllZml2YXJzLT5l
ZmlfcHN0b3JlX2luZm8uYnVmID0ga21hbGxvYyg0MDk2LCBHRlBfS0VSTkVMKTsNCi0JaWYgKGVm
aXZhcnMtPmVmaV9wc3RvcmVfaW5mby5idWYpIHsNCi0JCWVmaXZhcnMtPmVmaV9wc3RvcmVfaW5m
by5idWZzaXplID0gMTAyNDsNCi0JCWVmaXZhcnMtPmVmaV9wc3RvcmVfaW5mby5kYXRhID0gZWZp
dmFyczsNCi0JCXNwaW5fbG9ja19pbml0KCZlZml2YXJzLT5lZmlfcHN0b3JlX2luZm8uYnVmX2xv
Y2spOw0KLQkJcHN0b3JlX3JlZ2lzdGVyKCZlZml2YXJzLT5lZmlfcHN0b3JlX2luZm8pOw0KLQl9
DQorCWlmICghZWZpdmFyc19wc3RvcmVfZGlzYWJsZSkNCisJCWVmaXZhcl9wc3RvcmVfcmVnaXN0
ZXIoZWZpdmFycyk7DQogDQogb3V0Og0KIAlrZnJlZSh2YXJpYWJsZV9uYW1lKTsNCkBAIC0xMjg4
LDcgKzE0MjUsNiBAQCBvdXQ6DQogfQ0KIEVYUE9SVF9TWU1CT0xfR1BMKHJlZ2lzdGVyX2VmaXZh
cnMpOw0KIA0KLXN0YXRpYyBzdHJ1Y3QgZWZpdmFycyBfX2VmaXZhcnM7DQogc3RhdGljIHN0cnVj
dCBlZml2YXJfb3BlcmF0aW9ucyBvcHM7DQogDQogLyoNCkBAIC0xMzQ2LDYgKzE0ODIsOCBAQCBl
cnJfcHV0Og0KIHN0YXRpYyB2b2lkIF9fZXhpdA0KIGVmaXZhcnNfZXhpdCh2b2lkKQ0KIHsNCisJ
Y2FuY2VsX3dvcmtfc3luYygmZWZpdmFyX3dvcmspOw0KKw0KIAlpZiAoZWZpX2VuYWJsZWQoRUZJ
X1JVTlRJTUVfU0VSVklDRVMpKSB7DQogCQl1bnJlZ2lzdGVyX2VmaXZhcnMoJl9fZWZpdmFycyk7
DQogCQlrb2JqZWN0X3B1dChlZmlfa29iaik7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJt
L2RybV9lZGlkLmMgYi9kcml2ZXJzL2dwdS9kcm0vZHJtX2VkaWQuYw0KaW5kZXggOTA4MGViNy4u
NzIxMWY2NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9kcm1fZWRpZC5jDQorKysgYi9k
cml2ZXJzL2dwdS9kcm0vZHJtX2VkaWQuYw0KQEAgLTg1Miw3ICs4NTIsNyBAQCBzdGF0aWMgc3Ry
dWN0IGRybV9kaXNwbGF5X21vZGUgKmRybV9tb2RlX2RldGFpbGVkKHN0cnVjdCBkcm1fZGV2aWNl
ICpkZXYsDQogCXVuc2lnbmVkIHZibGFuayA9IChwdC0+dmFjdGl2ZV92YmxhbmtfaGkgJiAweGYp
IDw8IDggfCBwdC0+dmJsYW5rX2xvOw0KIAl1bnNpZ25lZCBoc3luY19vZmZzZXQgPSAocHQtPmhz
eW5jX3ZzeW5jX29mZnNldF9wdWxzZV93aWR0aF9oaSAmIDB4YzApIDw8IDIgfCBwdC0+aHN5bmNf
b2Zmc2V0X2xvOw0KIAl1bnNpZ25lZCBoc3luY19wdWxzZV93aWR0aCA9IChwdC0+aHN5bmNfdnN5
bmNfb2Zmc2V0X3B1bHNlX3dpZHRoX2hpICYgMHgzMCkgPDwgNCB8IHB0LT5oc3luY19wdWxzZV93
aWR0aF9sbzsNCi0JdW5zaWduZWQgdnN5bmNfb2Zmc2V0ID0gKHB0LT5oc3luY192c3luY19vZmZz
ZXRfcHVsc2Vfd2lkdGhfaGkgJiAweGMpID4+IDIgfCBwdC0+dnN5bmNfb2Zmc2V0X3B1bHNlX3dp
ZHRoX2xvID4+IDQ7DQorCXVuc2lnbmVkIHZzeW5jX29mZnNldCA9IChwdC0+aHN5bmNfdnN5bmNf
b2Zmc2V0X3B1bHNlX3dpZHRoX2hpICYgMHhjKSA8PCAyIHwgcHQtPnZzeW5jX29mZnNldF9wdWxz
ZV93aWR0aF9sbyA+PiA0Ow0KIAl1bnNpZ25lZCB2c3luY19wdWxzZV93aWR0aCA9IChwdC0+aHN5
bmNfdnN5bmNfb2Zmc2V0X3B1bHNlX3dpZHRoX2hpICYgMHgzKSA8PCA0IHwgKHB0LT52c3luY19v
ZmZzZXRfcHVsc2Vfd2lkdGhfbG8gJiAweGYpOw0KIA0KIAkvKiBpZ25vcmUgdGlueSBtb2RlcyAq
Lw0KQEAgLTkzMyw2ICs5MzMsNyBAQCBzZXRfc2l6ZToNCiAJfQ0KIA0KIAltb2RlLT50eXBlID0g
RFJNX01PREVfVFlQRV9EUklWRVI7DQorCW1vZGUtPnZyZWZyZXNoID0gZHJtX21vZGVfdnJlZnJl
c2gobW9kZSk7DQogCWRybV9tb2RlX3NldF9uYW1lKG1vZGUpOw0KIA0KIAlyZXR1cm4gbW9kZTsN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2RlYnVnZnMuYyBiL2RyaXZl
cnMvZ3B1L2RybS9pOTE1L2k5MTVfZGVidWdmcy5jDQppbmRleCA1NjIwMTkyLi45YjRlNWM2IDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9kZWJ1Z2ZzLmMNCisrKyBiL2Ry
aXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZGVidWdmcy5jDQpAQCAtMTIyLDcgKzEyMiw3IEBAIHN0
YXRpYyBjb25zdCBjaGFyICpjYWNoZV9sZXZlbF9zdHIoaW50IHR5cGUpDQogc3RhdGljIHZvaWQN
CiBkZXNjcmliZV9vYmooc3RydWN0IHNlcV9maWxlICptLCBzdHJ1Y3QgZHJtX2k5MTVfZ2VtX29i
amVjdCAqb2JqKQ0KIHsNCi0Jc2VxX3ByaW50ZihtLCAiJXA6ICVzJXMgJTh6ZCAlMDR4ICUwNHgg
JWQgJWQlcyVzJXMiLA0KKwlzZXFfcHJpbnRmKG0sICIlcEs6ICVzJXMgJTh6ZCAlMDR4ICUwNHgg
JWQgJWQlcyVzJXMiLA0KIAkJICAgJm9iai0+YmFzZSwNCiAJCSAgIGdldF9waW5fZmxhZyhvYmop
LA0KIAkJICAgZ2V0X3RpbGluZ19mbGFnKG9iaiksDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUv
ZHJtL2k5MTUvaTkxNV9nZW1fZXhlY2J1ZmZlci5jIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkx
NV9nZW1fZXhlY2J1ZmZlci5jDQppbmRleCA4NzhiOTg5Li5iMWJiNzM0IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9nZW1fZXhlY2J1ZmZlci5jDQorKysgYi9kcml2ZXJz
L2dwdS9kcm0vaTkxNS9pOTE1X2dlbV9leGVjYnVmZmVyLmMNCkBAIC05MDcsMTUgKzkwNywyMCBA
QCB2YWxpZGF0ZV9leGVjX2xpc3Qoc3RydWN0IGRybV9pOTE1X2dlbV9leGVjX29iamVjdDIgKmV4
ZWMsDQogCQkgICBpbnQgY291bnQpDQogew0KIAlpbnQgaTsNCisJaW50IHJlbG9jc190b3RhbCA9
IDA7DQorCWludCByZWxvY3NfbWF4ID0gSU5UX01BWCAvIHNpemVvZihzdHJ1Y3QgZHJtX2k5MTVf
Z2VtX3JlbG9jYXRpb25fZW50cnkpOw0KIA0KIAlmb3IgKGkgPSAwOyBpIDwgY291bnQ7IGkrKykg
ew0KIAkJY2hhciBfX3VzZXIgKnB0ciA9IChjaGFyIF9fdXNlciAqKSh1aW50cHRyX3QpZXhlY1tp
XS5yZWxvY3NfcHRyOw0KIAkJaW50IGxlbmd0aDsgLyogbGltaXRlZCBieSBmYXVsdF9pbl9wYWdl
c19yZWFkYWJsZSgpICovDQogDQotCQkvKiBGaXJzdCBjaGVjayBmb3IgbWFsaWNpb3VzIGlucHV0
IGNhdXNpbmcgb3ZlcmZsb3cgKi8NCi0JCWlmIChleGVjW2ldLnJlbG9jYXRpb25fY291bnQgPg0K
LQkJICAgIElOVF9NQVggLyBzaXplb2Yoc3RydWN0IGRybV9pOTE1X2dlbV9yZWxvY2F0aW9uX2Vu
dHJ5KSkNCisJCS8qIEZpcnN0IGNoZWNrIGZvciBtYWxpY2lvdXMgaW5wdXQgY2F1c2luZyBvdmVy
ZmxvdyBpbg0KKwkJICogdGhlIHdvcnN0IGNhc2Ugd2hlcmUgd2UgbmVlZCB0byBhbGxvY2F0ZSB0
aGUgZW50aXJlDQorCQkgKiByZWxvY2F0aW9uIHRyZWUgYXMgYSBzaW5nbGUgYXJyYXkuDQorCQkg
Ki8NCisJCWlmIChleGVjW2ldLnJlbG9jYXRpb25fY291bnQgPiByZWxvY3NfbWF4IC0gcmVsb2Nz
X3RvdGFsKQ0KIAkJCXJldHVybiAtRUlOVkFMOw0KKwkJcmVsb2NzX3RvdGFsICs9IGV4ZWNbaV0u
cmVsb2NhdGlvbl9jb3VudDsNCiANCiAJCWxlbmd0aCA9IGV4ZWNbaV0ucmVsb2NhdGlvbl9jb3Vu
dCAqDQogCQkJc2l6ZW9mKHN0cnVjdCBkcm1faTkxNV9nZW1fcmVsb2NhdGlvbl9lbnRyeSk7DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZGlzcGxheS5jIGIvZHJpdmVy
cy9ncHUvZHJtL2k5MTUvaW50ZWxfZGlzcGxheS5jDQppbmRleCA0NTkxNTgyLi4xNzk2MWRmIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZGlzcGxheS5jDQorKysgYi9k
cml2ZXJzL2dwdS9kcm0vaTkxNS9pbnRlbF9kaXNwbGF5LmMNCkBAIC04MDU5LDcgKzgwNTksNyBA
QCB2b2lkIGdlbjZfZW5hYmxlX3JwcyhzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSAqZGV2X3ByaXYp
DQogCUk5MTVfV1JJVEUoR0VONl9SQ19TTEVFUCwgMCk7DQogCUk5MTVfV1JJVEUoR0VONl9SQzFl
X1RIUkVTSE9MRCwgMTAwMCk7DQogCUk5MTVfV1JJVEUoR0VONl9SQzZfVEhSRVNIT0xELCA1MDAw
MCk7DQotCUk5MTVfV1JJVEUoR0VONl9SQzZwX1RIUkVTSE9MRCwgMTAwMDAwKTsNCisJSTkxNV9X
UklURShHRU42X1JDNnBfVEhSRVNIT0xELCAxNTAwMDApOw0KIAlJOTE1X1dSSVRFKEdFTjZfUkM2
cHBfVEhSRVNIT0xELCA2NDAwMCk7IC8qIHVudXNlZCAqLw0KIA0KIAlpZiAoaW50ZWxfZW5hYmxl
X3JjNihkZXZfcHJpdi0+ZGV2KSkNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9p
bnRlbF9vcHJlZ2lvbi5jIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfb3ByZWdpb24uYw0K
aW5kZXggMjg5MTQwYi4uY2ZmYjAwNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1
L2ludGVsX29wcmVnaW9uLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX29wcmVn
aW9uLmMNCkBAIC00MTksNiArNDE5LDI1IEBAIGJsaW5kX3NldDoNCiAJZ290byBlbmQ7DQogfQ0K
IA0KK3N0YXRpYyB2b2lkIGludGVsX3NldHVwX2NhZGxzKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYp
DQorew0KKwlzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSAqZGV2X3ByaXYgPSBkZXYtPmRldl9wcml2
YXRlOw0KKwlzdHJ1Y3QgaW50ZWxfb3ByZWdpb24gKm9wcmVnaW9uID0gJmRldl9wcml2LT5vcHJl
Z2lvbjsNCisJaW50IGkgPSAwOw0KKwl1MzIgZGlzcF9pZDsNCisNCisJLyogSW5pdGlhbGl6ZSB0
aGUgQ0FETCBmaWVsZCBieSBkdXBsaWNhdGluZyB0aGUgRElETCB2YWx1ZXMuDQorCSAqIFRlY2hu
aWNhbGx5LCB0aGlzIGlzIG5vdCBhbHdheXMgY29ycmVjdCBhcyBkaXNwbGF5IG91dHB1dHMgbWF5
IGV4aXN0LA0KKwkgKiBidXQgbm90IGFjdGl2ZS4gVGhpcyBpbml0aWFsaXphdGlvbiBpcyBuZWNl
c3NhcnkgZm9yIHNvbWUgQ2xldm8NCisJICogbGFwdG9wcyB0aGF0IGNoZWNrIHRoaXMgZmllbGQg
YmVmb3JlIHByb2Nlc3NpbmcgdGhlIGJyaWdodG5lc3MgYW5kDQorCSAqIGRpc3BsYXkgc3dpdGNo
aW5nIGhvdGtleXMuIEp1c3QgbGlrZSBESURMLCBDQURMIGlzIE5VTEwtdGVybWluYXRlZCBpZg0K
KwkgKiB0aGVyZSBhcmUgbGVzcyB0aGFuIGVpZ2h0IGRldmljZXMuICovDQorCWRvIHsNCisJCWRp
c3BfaWQgPSBpb3JlYWQzMigmb3ByZWdpb24tPmFjcGktPmRpZGxbaV0pOw0KKwkJaW93cml0ZTMy
KGRpc3BfaWQsICZvcHJlZ2lvbi0+YWNwaS0+Y2FkbFtpXSk7DQorCX0gd2hpbGUgKCsraSA8IDgg
JiYgZGlzcF9pZCAhPSAwKTsNCit9DQorDQogdm9pZCBpbnRlbF9vcHJlZ2lvbl9pbml0KHN0cnVj
dCBkcm1fZGV2aWNlICpkZXYpDQogew0KIAlzdHJ1Y3QgZHJtX2k5MTVfcHJpdmF0ZSAqZGV2X3By
aXYgPSBkZXYtPmRldl9wcml2YXRlOw0KQEAgLTQyOCw4ICs0NDcsMTAgQEAgdm9pZCBpbnRlbF9v
cHJlZ2lvbl9pbml0KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpDQogCQlyZXR1cm47DQogDQogCWlm
IChvcHJlZ2lvbi0+YWNwaSkgew0KLQkJaWYgKGRybV9jb3JlX2NoZWNrX2ZlYXR1cmUoZGV2LCBE
UklWRVJfTU9ERVNFVCkpDQorCQlpZiAoZHJtX2NvcmVfY2hlY2tfZmVhdHVyZShkZXYsIERSSVZF
Ul9NT0RFU0VUKSkgew0KIAkJCWludGVsX2RpZGxfb3V0cHV0cyhkZXYpOw0KKwkJCWludGVsX3Nl
dHVwX2NhZGxzKGRldik7DQorCQl9DQogDQogCQkvKiBOb3RpZnkgQklPUyB3ZSBhcmUgcmVhZHkg
dG8gaGFuZGxlIEFDUEkgdmlkZW8gZXh0IG5vdGlmcy4NCiAJCSAqIFJpZ2h0IG5vdywgYWxsIHRo
ZSBldmVudHMgYXJlIGhhbmRsZWQgYnkgdGhlIEFDUEkgdmlkZW8gbW9kdWxlLg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2JlbmNobWFyay5jIGIvZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9yYWRlb25fYmVuY2htYXJrLmMNCmluZGV4IDE3ZTFhOWIuLjQ0MWRlMzgg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9iZW5jaG1hcmsuYw0K
KysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fYmVuY2htYXJrLmMNCkBAIC0xMzks
MTMgKzEzOSwxNSBAQCBzdGF0aWMgdm9pZCByYWRlb25fYmVuY2htYXJrX21vdmUoc3RydWN0IHJh
ZGVvbl9kZXZpY2UgKnJkZXYsIHVuc2lnbmVkIHNpemUsDQogCQkJCQkJICAgICBzZG9tYWluLCBk
ZG9tYWluLCAiZG1hIik7DQogCX0NCiANCi0JdGltZSA9IHJhZGVvbl9iZW5jaG1hcmtfZG9fbW92
ZShyZGV2LCBzaXplLCBzYWRkciwgZGFkZHIsDQotCQkJCQlSQURFT05fQkVOQ0hNQVJLX0NPUFlf
QkxJVCwgbik7DQotCWlmICh0aW1lIDwgMCkNCi0JCWdvdG8gb3V0X2NsZWFudXA7DQotCWlmICh0
aW1lID4gMCkNCi0JCXJhZGVvbl9iZW5jaG1hcmtfbG9nX3Jlc3VsdHMobiwgc2l6ZSwgdGltZSwN
Ci0JCQkJCSAgICAgc2RvbWFpbiwgZGRvbWFpbiwgImJsaXQiKTsNCisJaWYgKHJkZXYtPmFzaWMt
PmNvcHlfYmxpdCkgew0KKwkJdGltZSA9IHJhZGVvbl9iZW5jaG1hcmtfZG9fbW92ZShyZGV2LCBz
aXplLCBzYWRkciwgZGFkZHIsDQorCQkJCQkJUkFERU9OX0JFTkNITUFSS19DT1BZX0JMSVQsIG4p
Ow0KKwkJaWYgKHRpbWUgPCAwKQ0KKwkJCWdvdG8gb3V0X2NsZWFudXA7DQorCQlpZiAodGltZSA+
IDApDQorCQkJcmFkZW9uX2JlbmNobWFya19sb2dfcmVzdWx0cyhuLCBzaXplLCB0aW1lLA0KKwkJ
CQkJCSAgICAgc2RvbWFpbiwgZGRvbWFpbiwgImJsaXQiKTsNCisJfQ0KIA0KIG91dF9jbGVhbnVw
Og0KIAlpZiAoc29iaikgew0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaTJjL2J1c3Nlcy9pMmMtdGVn
cmEuYyBiL2RyaXZlcnMvaTJjL2J1c3Nlcy9pMmMtdGVncmEuYw0KaW5kZXggM2Q3ODg1YS4uMzA1
NmVhNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaTJjL2J1c3Nlcy9pMmMtdGVncmEuYw0KKysrIGIv
ZHJpdmVycy9pMmMvYnVzc2VzL2kyYy10ZWdyYS5jDQpAQCAtMzQxLDcgKzM0MSwxMSBAQCBzdGF0
aWMgaW50IHRlZ3JhX2kyY19pbml0KHN0cnVjdCB0ZWdyYV9pMmNfZGV2ICppMmNfZGV2KQ0KIAl1
MzIgdmFsOw0KIAlpbnQgZXJyID0gMDsNCiANCi0JY2xrX2VuYWJsZShpMmNfZGV2LT5jbGspOw0K
KwllcnIgPSBjbGtfZW5hYmxlKGkyY19kZXYtPmNsayk7DQorCWlmIChlcnIgPCAwKSB7DQorCQlk
ZXZfZXJyKGkyY19kZXYtPmRldiwgIkNsb2NrIGVuYWJsZSBmYWlsZWQgJWRcbiIsIGVycik7DQor
CQlyZXR1cm4gZXJyOw0KKwl9DQogDQogCXRlZ3JhX3BlcmlwaF9yZXNldF9hc3NlcnQoaTJjX2Rl
di0+Y2xrKTsNCiAJdWRlbGF5KDIpOw0KQEAgLTUzNiw3ICs1NDAsMTIgQEAgc3RhdGljIGludCB0
ZWdyYV9pMmNfeGZlcihzdHJ1Y3QgaTJjX2FkYXB0ZXIgKmFkYXAsIHN0cnVjdCBpMmNfbXNnIG1z
Z3NbXSwNCiAJaWYgKGkyY19kZXYtPmlzX3N1c3BlbmRlZCkNCiAJCXJldHVybiAtRUJVU1k7DQog
DQotCWNsa19lbmFibGUoaTJjX2Rldi0+Y2xrKTsNCisJcmV0ID0gY2xrX2VuYWJsZShpMmNfZGV2
LT5jbGspOw0KKwlpZiAocmV0IDwgMCkgew0KKwkJZGV2X2VycihpMmNfZGV2LT5kZXYsICJDbG9j
ayBlbmFibGUgZmFpbGVkICVkXG4iLCByZXQpOw0KKwkJcmV0dXJuIHJldDsNCisJfQ0KKw0KIAlm
b3IgKGkgPSAwOyBpIDwgbnVtOyBpKyspIHsNCiAJCWludCBzdG9wID0gKGkgPT0gKG51bSAtIDEp
KSA/IDEgIDogMDsNCiAJCXJldCA9IHRlZ3JhX2kyY194ZmVyX21zZyhpMmNfZGV2LCAmbXNnc1tp
XSwgc3RvcCk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS10aGluLmMgYi9kcml2ZXJzL21k
L2RtLXRoaW4uYw0KaW5kZXggZGE0ZDI5OS4uMmM5ZGQyYyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bWQvZG0tdGhpbi5jDQorKysgYi9kcml2ZXJzL21kL2RtLXRoaW4uYw0KQEAgLTIyMTIsNyArMjIx
Miw3IEBAIHN0YXRpYyBzdHJ1Y3QgdGFyZ2V0X3R5cGUgcG9vbF90YXJnZXQgPSB7DQogCS5uYW1l
ID0gInRoaW4tcG9vbCIsDQogCS5mZWF0dXJlcyA9IERNX1RBUkdFVF9TSU5HTEVUT04gfCBETV9U
QVJHRVRfQUxXQVlTX1dSSVRFQUJMRSB8DQogCQkgICAgRE1fVEFSR0VUX0lNTVVUQUJMRSwNCi0J
LnZlcnNpb24gPSB7MSwgMCwgMX0sDQorCS52ZXJzaW9uID0gezEsIDAsIDJ9LA0KIAkubW9kdWxl
ID0gVEhJU19NT0RVTEUsDQogCS5jdHIgPSBwb29sX2N0ciwNCiAJLmR0ciA9IHBvb2xfZHRyLA0K
QEAgLTI0MjgsNyArMjQyOCw3IEBAIHN0YXRpYyB2b2lkIHRoaW5faW9faGludHMoc3RydWN0IGRt
X3RhcmdldCAqdGksIHN0cnVjdCBxdWV1ZV9saW1pdHMgKmxpbWl0cykNCiANCiBzdGF0aWMgc3Ry
dWN0IHRhcmdldF90eXBlIHRoaW5fdGFyZ2V0ID0gew0KIAkubmFtZSA9ICJ0aGluIiwNCi0JLnZl
cnNpb24gPSB7MSwgMCwgMX0sDQorCS52ZXJzaW9uID0gezEsIDAsIDJ9LA0KIAkubW9kdWxlCT0g
VEhJU19NT0RVTEUsDQogCS5jdHIgPSB0aGluX2N0ciwNCiAJLmR0ciA9IHRoaW5fZHRyLA0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbWQvcGVyc2lzdGVudC1kYXRhL2RtLWJ0cmVlLXJlbW92ZS5jIGIv
ZHJpdmVycy9tZC9wZXJzaXN0ZW50LWRhdGEvZG0tYnRyZWUtcmVtb3ZlLmMNCmluZGV4IGU2Y2Rm
ZGUuLjFkZTBmNWYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21kL3BlcnNpc3RlbnQtZGF0YS9kbS1i
dHJlZS1yZW1vdmUuYw0KKysrIGIvZHJpdmVycy9tZC9wZXJzaXN0ZW50LWRhdGEvZG0tYnRyZWUt
cmVtb3ZlLmMNCkBAIC0xMzksMTUgKzEzOSw4IEBAIHN0cnVjdCBjaGlsZCB7DQogCXN0cnVjdCBi
dHJlZV9ub2RlICpuOw0KIH07DQogDQotc3RhdGljIHN0cnVjdCBkbV9idHJlZV92YWx1ZV90eXBl
IGxlNjRfdHlwZSA9IHsNCi0JLmNvbnRleHQgPSBOVUxMLA0KLQkuc2l6ZSA9IHNpemVvZihfX2xl
NjQpLA0KLQkuaW5jID0gTlVMTCwNCi0JLmRlYyA9IE5VTEwsDQotCS5lcXVhbCA9IE5VTEwNCi19
Ow0KLQ0KLXN0YXRpYyBpbnQgaW5pdF9jaGlsZChzdHJ1Y3QgZG1fYnRyZWVfaW5mbyAqaW5mbywg
c3RydWN0IGJ0cmVlX25vZGUgKnBhcmVudCwNCitzdGF0aWMgaW50IGluaXRfY2hpbGQoc3RydWN0
IGRtX2J0cmVlX2luZm8gKmluZm8sIHN0cnVjdCBkbV9idHJlZV92YWx1ZV90eXBlICp2dCwNCisJ
CSAgICAgIHN0cnVjdCBidHJlZV9ub2RlICpwYXJlbnQsDQogCQkgICAgICB1bnNpZ25lZCBpbmRl
eCwgc3RydWN0IGNoaWxkICpyZXN1bHQpDQogew0KIAlpbnQgciwgaW5jOw0KQEAgLTE2NCw3ICsx
NTcsNyBAQCBzdGF0aWMgaW50IGluaXRfY2hpbGQoc3RydWN0IGRtX2J0cmVlX2luZm8gKmluZm8s
IHN0cnVjdCBidHJlZV9ub2RlICpwYXJlbnQsDQogCXJlc3VsdC0+biA9IGRtX2Jsb2NrX2RhdGEo
cmVzdWx0LT5ibG9jayk7DQogDQogCWlmIChpbmMpDQotCQlpbmNfY2hpbGRyZW4oaW5mby0+dG0s
IHJlc3VsdC0+biwgJmxlNjRfdHlwZSk7DQorCQlpbmNfY2hpbGRyZW4oaW5mby0+dG0sIHJlc3Vs
dC0+biwgdnQpOw0KIA0KIAkqKChfX2xlNjQgKikgdmFsdWVfcHRyKHBhcmVudCwgaW5kZXgsIHNp
emVvZihfX2xlNjQpKSkgPQ0KIAkJY3B1X3RvX2xlNjQoZG1fYmxvY2tfbG9jYXRpb24ocmVzdWx0
LT5ibG9jaykpOw0KQEAgLTIzNiw3ICsyMjksNyBAQCBzdGF0aWMgdm9pZCBfX3JlYmFsYW5jZTIo
c3RydWN0IGRtX2J0cmVlX2luZm8gKmluZm8sIHN0cnVjdCBidHJlZV9ub2RlICpwYXJlbnQsDQog
fQ0KIA0KIHN0YXRpYyBpbnQgcmViYWxhbmNlMihzdHJ1Y3Qgc2hhZG93X3NwaW5lICpzLCBzdHJ1
Y3QgZG1fYnRyZWVfaW5mbyAqaW5mbywNCi0JCSAgICAgIHVuc2lnbmVkIGxlZnRfaW5kZXgpDQor
CQkgICAgICBzdHJ1Y3QgZG1fYnRyZWVfdmFsdWVfdHlwZSAqdnQsIHVuc2lnbmVkIGxlZnRfaW5k
ZXgpDQogew0KIAlpbnQgcjsNCiAJc3RydWN0IGJ0cmVlX25vZGUgKnBhcmVudDsNCkBAIC0yNDQs
MTEgKzIzNywxMSBAQCBzdGF0aWMgaW50IHJlYmFsYW5jZTIoc3RydWN0IHNoYWRvd19zcGluZSAq
cywgc3RydWN0IGRtX2J0cmVlX2luZm8gKmluZm8sDQogDQogCXBhcmVudCA9IGRtX2Jsb2NrX2Rh
dGEoc2hhZG93X2N1cnJlbnQocykpOw0KIA0KLQlyID0gaW5pdF9jaGlsZChpbmZvLCBwYXJlbnQs
IGxlZnRfaW5kZXgsICZsZWZ0KTsNCisJciA9IGluaXRfY2hpbGQoaW5mbywgdnQsIHBhcmVudCwg
bGVmdF9pbmRleCwgJmxlZnQpOw0KIAlpZiAocikNCiAJCXJldHVybiByOw0KIA0KLQlyID0gaW5p
dF9jaGlsZChpbmZvLCBwYXJlbnQsIGxlZnRfaW5kZXggKyAxLCAmcmlnaHQpOw0KKwlyID0gaW5p
dF9jaGlsZChpbmZvLCB2dCwgcGFyZW50LCBsZWZ0X2luZGV4ICsgMSwgJnJpZ2h0KTsNCiAJaWYg
KHIpIHsNCiAJCWV4aXRfY2hpbGQoaW5mbywgJmxlZnQpOw0KIAkJcmV0dXJuIHI7DQpAQCAtMzY4
LDcgKzM2MSw3IEBAIHN0YXRpYyB2b2lkIF9fcmViYWxhbmNlMyhzdHJ1Y3QgZG1fYnRyZWVfaW5m
byAqaW5mbywgc3RydWN0IGJ0cmVlX25vZGUgKnBhcmVudCwNCiB9DQogDQogc3RhdGljIGludCBy
ZWJhbGFuY2UzKHN0cnVjdCBzaGFkb3dfc3BpbmUgKnMsIHN0cnVjdCBkbV9idHJlZV9pbmZvICpp
bmZvLA0KLQkJICAgICAgdW5zaWduZWQgbGVmdF9pbmRleCkNCisJCSAgICAgIHN0cnVjdCBkbV9i
dHJlZV92YWx1ZV90eXBlICp2dCwgdW5zaWduZWQgbGVmdF9pbmRleCkNCiB7DQogCWludCByOw0K
IAlzdHJ1Y3QgYnRyZWVfbm9kZSAqcGFyZW50ID0gZG1fYmxvY2tfZGF0YShzaGFkb3dfY3VycmVu
dChzKSk7DQpAQCAtMzc3LDE3ICszNzAsMTcgQEAgc3RhdGljIGludCByZWJhbGFuY2UzKHN0cnVj
dCBzaGFkb3dfc3BpbmUgKnMsIHN0cnVjdCBkbV9idHJlZV9pbmZvICppbmZvLA0KIAkvKg0KIAkg
KiBGSVhNRTogZmlsbCBvdXQgYW4gYXJyYXk/DQogCSAqLw0KLQlyID0gaW5pdF9jaGlsZChpbmZv
LCBwYXJlbnQsIGxlZnRfaW5kZXgsICZsZWZ0KTsNCisJciA9IGluaXRfY2hpbGQoaW5mbywgdnQs
IHBhcmVudCwgbGVmdF9pbmRleCwgJmxlZnQpOw0KIAlpZiAocikNCiAJCXJldHVybiByOw0KIA0K
LQlyID0gaW5pdF9jaGlsZChpbmZvLCBwYXJlbnQsIGxlZnRfaW5kZXggKyAxLCAmY2VudGVyKTsN
CisJciA9IGluaXRfY2hpbGQoaW5mbywgdnQsIHBhcmVudCwgbGVmdF9pbmRleCArIDEsICZjZW50
ZXIpOw0KIAlpZiAocikgew0KIAkJZXhpdF9jaGlsZChpbmZvLCAmbGVmdCk7DQogCQlyZXR1cm4g
cjsNCiAJfQ0KIA0KLQlyID0gaW5pdF9jaGlsZChpbmZvLCBwYXJlbnQsIGxlZnRfaW5kZXggKyAy
LCAmcmlnaHQpOw0KKwlyID0gaW5pdF9jaGlsZChpbmZvLCB2dCwgcGFyZW50LCBsZWZ0X2luZGV4
ICsgMiwgJnJpZ2h0KTsNCiAJaWYgKHIpIHsNCiAJCWV4aXRfY2hpbGQoaW5mbywgJmxlZnQpOw0K
IAkJZXhpdF9jaGlsZChpbmZvLCAmY2VudGVyKTsNCkBAIC00MzQsNyArNDI3LDggQEAgc3RhdGlj
IGludCBnZXRfbnJfZW50cmllcyhzdHJ1Y3QgZG1fdHJhbnNhY3Rpb25fbWFuYWdlciAqdG0sDQog
fQ0KIA0KIHN0YXRpYyBpbnQgcmViYWxhbmNlX2NoaWxkcmVuKHN0cnVjdCBzaGFkb3dfc3BpbmUg
KnMsDQotCQkJICAgICAgc3RydWN0IGRtX2J0cmVlX2luZm8gKmluZm8sIHVpbnQ2NF90IGtleSkN
CisJCQkgICAgICBzdHJ1Y3QgZG1fYnRyZWVfaW5mbyAqaW5mbywNCisJCQkgICAgICBzdHJ1Y3Qg
ZG1fYnRyZWVfdmFsdWVfdHlwZSAqdnQsIHVpbnQ2NF90IGtleSkNCiB7DQogCWludCBpLCByLCBo
YXNfbGVmdF9zaWJsaW5nLCBoYXNfcmlnaHRfc2libGluZzsNCiAJdWludDMyX3QgY2hpbGRfZW50
cmllczsNCkBAIC00NzIsMTMgKzQ2NiwxMyBAQCBzdGF0aWMgaW50IHJlYmFsYW5jZV9jaGlsZHJl
bihzdHJ1Y3Qgc2hhZG93X3NwaW5lICpzLA0KIAloYXNfcmlnaHRfc2libGluZyA9IGkgPCAobGUz
Ml90b19jcHUobi0+aGVhZGVyLm5yX2VudHJpZXMpIC0gMSk7DQogDQogCWlmICghaGFzX2xlZnRf
c2libGluZykNCi0JCXIgPSByZWJhbGFuY2UyKHMsIGluZm8sIGkpOw0KKwkJciA9IHJlYmFsYW5j
ZTIocywgaW5mbywgdnQsIGkpOw0KIA0KIAllbHNlIGlmICghaGFzX3JpZ2h0X3NpYmxpbmcpDQot
CQlyID0gcmViYWxhbmNlMihzLCBpbmZvLCBpIC0gMSk7DQorCQlyID0gcmViYWxhbmNlMihzLCBp
bmZvLCB2dCwgaSAtIDEpOw0KIA0KIAllbHNlDQotCQlyID0gcmViYWxhbmNlMyhzLCBpbmZvLCBp
IC0gMSk7DQorCQlyID0gcmViYWxhbmNlMyhzLCBpbmZvLCB2dCwgaSAtIDEpOw0KIA0KIAlyZXR1
cm4gcjsNCiB9DQpAQCAtNTI5LDcgKzUyMyw3IEBAIHN0YXRpYyBpbnQgcmVtb3ZlX3JhdyhzdHJ1
Y3Qgc2hhZG93X3NwaW5lICpzLCBzdHJ1Y3QgZG1fYnRyZWVfaW5mbyAqaW5mbywNCiAJCWlmIChs
ZTMyX3RvX2NwdShuLT5oZWFkZXIuZmxhZ3MpICYgTEVBRl9OT0RFKQ0KIAkJCXJldHVybiBkb19s
ZWFmKG4sIGtleSwgaW5kZXgpOw0KIA0KLQkJciA9IHJlYmFsYW5jZV9jaGlsZHJlbihzLCBpbmZv
LCBrZXkpOw0KKwkJciA9IHJlYmFsYW5jZV9jaGlsZHJlbihzLCBpbmZvLCB2dCwga2V5KTsNCiAJ
CWlmIChyKQ0KIAkJCWJyZWFrOw0KIA0KQEAgLTU1MCw2ICs1NDQsMTQgQEAgc3RhdGljIGludCBy
ZW1vdmVfcmF3KHN0cnVjdCBzaGFkb3dfc3BpbmUgKnMsIHN0cnVjdCBkbV9idHJlZV9pbmZvICpp
bmZvLA0KIAlyZXR1cm4gcjsNCiB9DQogDQorc3RhdGljIHN0cnVjdCBkbV9idHJlZV92YWx1ZV90
eXBlIGxlNjRfdHlwZSA9IHsNCisJLmNvbnRleHQgPSBOVUxMLA0KKwkuc2l6ZSA9IHNpemVvZihf
X2xlNjQpLA0KKwkuaW5jID0gTlVMTCwNCisJLmRlYyA9IE5VTEwsDQorCS5lcXVhbCA9IE5VTEwN
Cit9Ow0KKw0KIGludCBkbV9idHJlZV9yZW1vdmUoc3RydWN0IGRtX2J0cmVlX2luZm8gKmluZm8s
IGRtX2Jsb2NrX3Qgcm9vdCwNCiAJCSAgICB1aW50NjRfdCAqa2V5cywgZG1fYmxvY2tfdCAqbmV3
X3Jvb3QpDQogew0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMg
Yi9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfbWFpbi5jDQppbmRleCAyMDJhZTM0Li42M2UzYzQ3
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX21haW4uYw0KKysrIGIvZHJp
dmVycy9uZXQvYm9uZGluZy9ib25kX21haW4uYw0KQEAgLTE3MTUsNiArMTcxNSw4IEBAIGludCBi
b25kX2Vuc2xhdmUoc3RydWN0IG5ldF9kZXZpY2UgKmJvbmRfZGV2LCBzdHJ1Y3QgbmV0X2Rldmlj
ZSAqc2xhdmVfZGV2KQ0KIA0KIAlib25kX2NvbXB1dGVfZmVhdHVyZXMoYm9uZCk7DQogDQorCWJv
bmRfdXBkYXRlX3NwZWVkX2R1cGxleChuZXdfc2xhdmUpOw0KKw0KIAlyZWFkX2xvY2soJmJvbmQt
PmxvY2spOw0KIA0KIAluZXdfc2xhdmUtPmxhc3RfYXJwX3J4ID0gamlmZmllczsNCkBAIC0xNzU4
LDggKzE3NjAsNiBAQCBpbnQgYm9uZF9lbnNsYXZlKHN0cnVjdCBuZXRfZGV2aWNlICpib25kX2Rl
diwgc3RydWN0IG5ldF9kZXZpY2UgKnNsYXZlX2RldikNCiAJCW5ld19zbGF2ZS0+bGluayAgPSBC
T05EX0xJTktfRE9XTjsNCiAJfQ0KIA0KLQlib25kX3VwZGF0ZV9zcGVlZF9kdXBsZXgobmV3X3Ns
YXZlKTsNCi0NCiAJaWYgKFVTRVNfUFJJTUFSWShib25kLT5wYXJhbXMubW9kZSkgJiYgYm9uZC0+
cGFyYW1zLnByaW1hcnlbMF0pIHsNCiAJCS8qIGlmIHRoZXJlIGlzIGEgcHJpbWFyeSBzbGF2ZSwg
cmVtZW1iZXIgaXQgKi8NCiAJCWlmIChzdHJjbXAoYm9uZC0+cGFyYW1zLnByaW1hcnksIG5ld19z
bGF2ZS0+ZGV2LT5uYW1lKSA9PSAwKSB7DQpAQCAtMjQzNyw4ICsyNDM3LDYgQEAgc3RhdGljIHZv
aWQgYm9uZF9taWltb25fY29tbWl0KHN0cnVjdCBib25kaW5nICpib25kKQ0KIAkJCQlib25kX3Nl
dF9iYWNrdXBfc2xhdmUoc2xhdmUpOw0KIAkJCX0NCiANCi0JCQlib25kX3VwZGF0ZV9zcGVlZF9k
dXBsZXgoc2xhdmUpOw0KLQ0KIAkJCXByX2luZm8oIiVzOiBsaW5rIHN0YXR1cyBkZWZpbml0ZWx5
IHVwIGZvciBpbnRlcmZhY2UgJXMsICV1IE1icHMgJXMgZHVwbGV4LlxuIiwNCiAJCQkJYm9uZC0+
ZGV2LT5uYW1lLCBzbGF2ZS0+ZGV2LT5uYW1lLA0KIAkJCQlzbGF2ZS0+c3BlZWQsIHNsYXZlLT5k
dXBsZXggPyAiZnVsbCIgOiAiaGFsZiIpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3NmYy9lZnguYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnguYw0KaW5kZXggYTY2
MTFmMS4uNWQ1YTA1ZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZngu
Yw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmeC5jDQpAQCAtNjUwLDI1ICs2NTAs
MzAgQEAgc3RhdGljIHZvaWQgZWZ4X2ZpbmlfY2hhbm5lbHMoc3RydWN0IGVmeF9uaWMgKmVmeCkN
CiAJc3RydWN0IGVmeF9jaGFubmVsICpjaGFubmVsOw0KIAlzdHJ1Y3QgZWZ4X3R4X3F1ZXVlICp0
eF9xdWV1ZTsNCiAJc3RydWN0IGVmeF9yeF9xdWV1ZSAqcnhfcXVldWU7DQorCXN0cnVjdCBwY2lf
ZGV2ICpkZXYgPSBlZngtPnBjaV9kZXY7DQogCWludCByYzsNCiANCiAJRUZYX0FTU0VSVF9SRVNF
VF9TRVJJQUxJU0VEKGVmeCk7DQogCUJVR19PTihlZngtPnBvcnRfZW5hYmxlZCk7DQogDQotCXJj
ID0gZWZ4X25pY19mbHVzaF9xdWV1ZXMoZWZ4KTsNCi0JaWYgKHJjICYmIEVGWF9XT1JLQVJPVU5E
Xzc4MDMoZWZ4KSkgew0KLQkJLyogU2NoZWR1bGUgYSByZXNldCB0byByZWNvdmVyIGZyb20gdGhl
IGZsdXNoIGZhaWx1cmUuIFRoZQ0KLQkJICogZGVzY3JpcHRvciBjYWNoZXMgcmVmZXJlbmNlIG1l
bW9yeSB3ZSdyZSBhYm91dCB0byBmcmVlLA0KLQkJICogYnV0IGZhbGNvbl9yZWNvbmZpZ3VyZV9t
YWNfd3JhcHBlcigpIHdvbid0IHJlY29ubmVjdA0KLQkJICogdGhlIE1BQ3MgYmVjYXVzZSBvZiB0
aGUgcGVuZGluZyByZXNldC4gKi8NCi0JCW5ldGlmX2VycihlZngsIGRydiwgZWZ4LT5uZXRfZGV2
LA0KLQkJCSAgIlJlc2V0dGluZyB0byByZWNvdmVyIGZyb20gZmx1c2ggZmFpbHVyZVxuIik7DQot
CQllZnhfc2NoZWR1bGVfcmVzZXQoZWZ4LCBSRVNFVF9UWVBFX0FMTCk7DQotCX0gZWxzZSBpZiAo
cmMpIHsNCi0JCW5ldGlmX2VycihlZngsIGRydiwgZWZ4LT5uZXRfZGV2LCAiZmFpbGVkIHRvIGZs
dXNoIHF1ZXVlc1xuIik7DQotCX0gZWxzZSB7DQotCQluZXRpZl9kYmcoZWZ4LCBkcnYsIGVmeC0+
bmV0X2RldiwNCi0JCQkgICJzdWNjZXNzZnVsbHkgZmx1c2hlZCBhbGwgcXVldWVzXG4iKTsNCisJ
LyogT25seSBwZXJmb3JtIGZsdXNoIGlmIGRtYSBpcyBlbmFibGVkICovDQorCWlmIChkZXYtPmlz
X2J1c21hc3Rlcikgew0KKwkJcmMgPSBlZnhfbmljX2ZsdXNoX3F1ZXVlcyhlZngpOw0KKw0KKwkJ
aWYgKHJjICYmIEVGWF9XT1JLQVJPVU5EXzc4MDMoZWZ4KSkgew0KKwkJCS8qIFNjaGVkdWxlIGEg
cmVzZXQgdG8gcmVjb3ZlciBmcm9tIHRoZSBmbHVzaCBmYWlsdXJlLiBUaGUNCisJCQkgKiBkZXNj
cmlwdG9yIGNhY2hlcyByZWZlcmVuY2UgbWVtb3J5IHdlJ3JlIGFib3V0IHRvIGZyZWUsDQorCQkJ
ICogYnV0IGZhbGNvbl9yZWNvbmZpZ3VyZV9tYWNfd3JhcHBlcigpIHdvbid0IHJlY29ubmVjdA0K
KwkJCSAqIHRoZSBNQUNzIGJlY2F1c2Ugb2YgdGhlIHBlbmRpbmcgcmVzZXQuICovDQorCQkJbmV0
aWZfZXJyKGVmeCwgZHJ2LCBlZngtPm5ldF9kZXYsDQorCQkJCSAgIlJlc2V0dGluZyB0byByZWNv
dmVyIGZyb20gZmx1c2ggZmFpbHVyZVxuIik7DQorCQkJZWZ4X3NjaGVkdWxlX3Jlc2V0KGVmeCwg
UkVTRVRfVFlQRV9BTEwpOw0KKwkJfSBlbHNlIGlmIChyYykgew0KKwkJCW5ldGlmX2VycihlZngs
IGRydiwgZWZ4LT5uZXRfZGV2LCAiZmFpbGVkIHRvIGZsdXNoIHF1ZXVlc1xuIik7DQorCQl9IGVs
c2Ugew0KKwkJCW5ldGlmX2RiZyhlZngsIGRydiwgZWZ4LT5uZXRfZGV2LA0KKwkJCQkgICJzdWNj
ZXNzZnVsbHkgZmx1c2hlZCBhbGwgcXVldWVzXG4iKTsNCisJCX0NCiAJfQ0KIA0KIAllZnhfZm9y
X2VhY2hfY2hhbm5lbChjaGFubmVsLCBlZngpIHsNCkBAIC03MTQsNiArNzE5LDcgQEAgZWZ4X3Jl
YWxsb2NfY2hhbm5lbHMoc3RydWN0IGVmeF9uaWMgKmVmeCwgdTMyIHJ4cV9lbnRyaWVzLCB1MzIg
dHhxX2VudHJpZXMpDQogCXVuc2lnbmVkIGk7DQogCWludCByYzsNCiANCisJZWZ4X2RldmljZV9k
ZXRhY2hfc3luYyhlZngpOw0KIAllZnhfc3RvcF9hbGwoZWZ4KTsNCiAJZWZ4X2ZpbmlfY2hhbm5l
bHMoZWZ4KTsNCiANCkBAIC03NTcsNiArNzYzLDcgQEAgb3V0Og0KIA0KIAllZnhfaW5pdF9jaGFu
bmVscyhlZngpOw0KIAllZnhfc3RhcnRfYWxsKGVmeCk7DQorCW5ldGlmX2RldmljZV9hdHRhY2go
ZWZ4LT5uZXRfZGV2KTsNCiAJcmV0dXJuIHJjOw0KIA0KIHJvbGxiYWNrOg0KQEAgLTE1MjUsOCAr
MTUzMiwxMiBAQCBzdGF0aWMgdm9pZCBlZnhfc3RvcF9hbGwoc3RydWN0IGVmeF9uaWMgKmVmeCkN
CiAJLyogRmx1c2ggZWZ4X21hY193b3JrKCksIHJlZmlsbF93b3JrcXVldWUsIG1vbml0b3Jfd29y
ayAqLw0KIAllZnhfZmx1c2hfYWxsKGVmeCk7DQogDQotCS8qIFN0b3AgdGhlIGtlcm5lbCB0cmFu
c21pdCBpbnRlcmZhY2UgbGF0ZSwgc28gdGhlIHdhdGNoZG9nDQotCSAqIHRpbWVyIGlzbid0IHRp
Y2tpbmcgb3ZlciB0aGUgZmx1c2ggKi8NCisJLyogU3RvcCB0aGUga2VybmVsIHRyYW5zbWl0IGlu
dGVyZmFjZS4gIFRoaXMgaXMgb25seSB2YWxpZCBpZg0KKwkgKiB0aGUgZGV2aWNlIGlzIHN0b3Bw
ZWQgb3IgZGV0YWNoZWQ7IG90aGVyd2lzZSB0aGUgd2F0Y2hkb2cNCisJICogbWF5IGZpcmUgaW1t
ZWRpYXRlbHkuDQorCSAqLw0KKwlXQVJOX09OKG5ldGlmX3J1bm5pbmcoZWZ4LT5uZXRfZGV2KSAm
Jg0KKwkJbmV0aWZfZGV2aWNlX3ByZXNlbnQoZWZ4LT5uZXRfZGV2KSk7DQogCWlmIChlZnhfZGV2
X3JlZ2lzdGVyZWQoZWZ4KSkgew0KIAkJbmV0aWZfdHhfc3RvcF9hbGxfcXVldWVzKGVmeC0+bmV0
X2Rldik7DQogCQluZXRpZl90eF9sb2NrX2JoKGVmeC0+bmV0X2Rldik7DQpAQCAtMTgyNywxMCAr
MTgzOCwxMSBAQCBzdGF0aWMgaW50IGVmeF9jaGFuZ2VfbXR1KHN0cnVjdCBuZXRfZGV2aWNlICpu
ZXRfZGV2LCBpbnQgbmV3X210dSkNCiAJaWYgKG5ld19tdHUgPiBFRlhfTUFYX01UVSkNCiAJCXJl
dHVybiAtRUlOVkFMOw0KIA0KLQllZnhfc3RvcF9hbGwoZWZ4KTsNCi0NCiAJbmV0aWZfZGJnKGVm
eCwgZHJ2LCBlZngtPm5ldF9kZXYsICJjaGFuZ2luZyBNVFUgdG8gJWRcbiIsIG5ld19tdHUpOw0K
IA0KKwllZnhfZGV2aWNlX2RldGFjaF9zeW5jKGVmeCk7DQorCWVmeF9zdG9wX2FsbChlZngpOw0K
Kw0KIAllZnhfZmluaV9jaGFubmVscyhlZngpOw0KIA0KIAltdXRleF9sb2NrKCZlZngtPm1hY19s
b2NrKTsNCkBAIC0xODQzLDYgKzE4NTUsNyBAQCBzdGF0aWMgaW50IGVmeF9jaGFuZ2VfbXR1KHN0
cnVjdCBuZXRfZGV2aWNlICpuZXRfZGV2LCBpbnQgbmV3X210dSkNCiAJZWZ4X2luaXRfY2hhbm5l
bHMoZWZ4KTsNCiANCiAJZWZ4X3N0YXJ0X2FsbChlZngpOw0KKwluZXRpZl9kZXZpY2VfYXR0YWNo
KGVmeC0+bmV0X2Rldik7DQogCXJldHVybiByYzsNCiB9DQogDQpAQCAtMjEzMiw3ICsyMTQ1LDcg
QEAgaW50IGVmeF9yZXNldChzdHJ1Y3QgZWZ4X25pYyAqZWZ4LCBlbnVtIHJlc2V0X3R5cGUgbWV0
aG9kKQ0KIAluZXRpZl9pbmZvKGVmeCwgZHJ2LCBlZngtPm5ldF9kZXYsICJyZXNldHRpbmcgKCVz
KVxuIiwNCiAJCSAgIFJFU0VUX1RZUEUobWV0aG9kKSk7DQogDQotCW5ldGlmX2RldmljZV9kZXRh
Y2goZWZ4LT5uZXRfZGV2KTsNCisJZWZ4X2RldmljZV9kZXRhY2hfc3luYyhlZngpOw0KIAllZnhf
cmVzZXRfZG93bihlZngsIG1ldGhvZCk7DQogDQogCXJjID0gZWZ4LT50eXBlLT5yZXNldChlZngs
IG1ldGhvZCk7DQpAQCAtMjU4MCw3ICsyNTkzLDcgQEAgc3RhdGljIGludCBlZnhfcG1fZnJlZXpl
KHN0cnVjdCBkZXZpY2UgKmRldikNCiANCiAJZWZ4LT5zdGF0ZSA9IFNUQVRFX0ZJTkk7DQogDQot
CW5ldGlmX2RldmljZV9kZXRhY2goZWZ4LT5uZXRfZGV2KTsNCisJZWZ4X2RldmljZV9kZXRhY2hf
c3luYyhlZngpOw0KIA0KIAllZnhfc3RvcF9hbGwoZWZ4KTsNCiAJZWZ4X2ZpbmlfY2hhbm5lbHMo
ZWZ4KTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4LmggYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4LmgNCmluZGV4IDEzNTUyNDUuLjk2NjhkMjkgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4LmgNCisrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3NmYy9lZnguaA0KQEAgLTE0OSw0ICsxNDksMTcgQEAgZXh0ZXJuIHZvaWQgZWZ4
X2xpbmtfc3RhdHVzX2NoYW5nZWQoc3RydWN0IGVmeF9uaWMgKmVmeCk7DQogZXh0ZXJuIHZvaWQg
ZWZ4X2xpbmtfc2V0X2FkdmVydGlzaW5nKHN0cnVjdCBlZnhfbmljICplZngsIHUzMik7DQogZXh0
ZXJuIHZvaWQgZWZ4X2xpbmtfc2V0X3dhbnRlZF9mYyhzdHJ1Y3QgZWZ4X25pYyAqZWZ4LCB1OCk7
DQogDQorc3RhdGljIGlubGluZSB2b2lkIGVmeF9kZXZpY2VfZGV0YWNoX3N5bmMoc3RydWN0IGVm
eF9uaWMgKmVmeCkNCit7DQorCXN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBlZngtPm5ldF9kZXY7
DQorDQorCS8qIExvY2svZnJlZXplIGFsbCBUWCBxdWV1ZXMgc28gdGhhdCB3ZSBjYW4gYmUgc3Vy
ZSB0aGUNCisJICogVFggc2NoZWR1bGVyIGlzIHN0b3BwZWQgd2hlbiB3ZSdyZSBkb25lIGFuZCBi
ZWZvcmUNCisJICogbmV0aWZfZGV2aWNlX3ByZXNlbnQoKSBiZWNvbWVzIGZhbHNlLg0KKwkgKi8N
CisJbmV0aWZfdHhfbG9ja19iaChkZXYpOw0KKwluZXRpZl9kZXZpY2VfZGV0YWNoKGRldik7DQor
CW5ldGlmX3R4X3VubG9ja19iaChkZXYpOw0KK30NCisNCiAjZW5kaWYgLyogRUZYX0VGWF9IICov
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2ZhbGNvbi5jIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvc2ZjL2ZhbGNvbi5jDQppbmRleCA5N2I2MDZiLi4yNmNkNmMwIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2ZhbGNvbi5jDQorKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9zZmMvZmFsY29uLmMNCkBAIC0xNzYyLDYgKzE3NjIsNyBAQCBjb25zdCBz
dHJ1Y3QgZWZ4X25pY190eXBlIGZhbGNvbl9hMV9uaWNfdHlwZSA9IHsNCiAJLnJlbW92ZV9wb3J0
ID0gZmFsY29uX3JlbW92ZV9wb3J0LA0KIAkuaGFuZGxlX2dsb2JhbF9ldmVudCA9IGZhbGNvbl9o
YW5kbGVfZ2xvYmFsX2V2ZW50LA0KIAkucHJlcGFyZV9mbHVzaCA9IGZhbGNvbl9wcmVwYXJlX2Zs
dXNoLA0KKwkuZmluaXNoX2ZsdXNoID0gZWZ4X3BvcnRfZHVtbXlfb3Bfdm9pZCwNCiAJLnVwZGF0
ZV9zdGF0cyA9IGZhbGNvbl91cGRhdGVfbmljX3N0YXRzLA0KIAkuc3RhcnRfc3RhdHMgPSBmYWxj
b25fc3RhcnRfbmljX3N0YXRzLA0KIAkuc3RvcF9zdGF0cyA9IGZhbGNvbl9zdG9wX25pY19zdGF0
cywNCkBAIC0xODA0LDYgKzE4MDUsNyBAQCBjb25zdCBzdHJ1Y3QgZWZ4X25pY190eXBlIGZhbGNv
bl9iMF9uaWNfdHlwZSA9IHsNCiAJLnJlbW92ZV9wb3J0ID0gZmFsY29uX3JlbW92ZV9wb3J0LA0K
IAkuaGFuZGxlX2dsb2JhbF9ldmVudCA9IGZhbGNvbl9oYW5kbGVfZ2xvYmFsX2V2ZW50LA0KIAku
cHJlcGFyZV9mbHVzaCA9IGZhbGNvbl9wcmVwYXJlX2ZsdXNoLA0KKwkuZmluaXNoX2ZsdXNoID0g
ZWZ4X3BvcnRfZHVtbXlfb3Bfdm9pZCwNCiAJLnVwZGF0ZV9zdGF0cyA9IGZhbGNvbl91cGRhdGVf
bmljX3N0YXRzLA0KIAkuc3RhcnRfc3RhdHMgPSBmYWxjb25fc3RhcnRfbmljX3N0YXRzLA0KIAku
c3RvcF9zdGF0cyA9IGZhbGNvbl9zdG9wX25pY19zdGF0cywNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9zZmMvbWNkaS5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL21jZGku
Yw0KaW5kZXggODFhNDI1My4uYzEwMDBjZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3NmYy9tY2RpLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9tY2RpLmMNCkBA
IC0zMCw3ICszMCw3IEBADQogI2RlZmluZSBSRUJPT1RfRkxBR19QT1JUMCAweDNmOA0KICNkZWZp
bmUgUkVCT09UX0ZMQUdfUE9SVDEgMHgzZmMNCiANCi0jZGVmaW5lIE1DRElfUlBDX1RJTUVPVVQg
ICAgICAgMTAgLypzZWNvbmRzICovDQorI2RlZmluZSBNQ0RJX1JQQ19USU1FT1VUICAgICAgICgx
MCAqIEhaKQ0KIA0KICNkZWZpbmUgTUNESV9QRFUoZWZ4KQkJCQkJCQlcDQogCShlZnhfcG9ydF9u
dW0oZWZ4KSA/IENNRF9QRFVfUE9SVDEgOiBDTURfUERVX1BPUlQwKQ0KQEAgLTEyMCw3ICsxMjAs
NyBAQCBzdGF0aWMgdm9pZCBlZnhfbWNkaV9jb3B5b3V0KHN0cnVjdCBlZnhfbmljICplZngsIHU4
ICpvdXRidWYsIHNpemVfdCBvdXRsZW4pDQogc3RhdGljIGludCBlZnhfbWNkaV9wb2xsKHN0cnVj
dCBlZnhfbmljICplZngpDQogew0KIAlzdHJ1Y3QgZWZ4X21jZGlfaWZhY2UgKm1jZGkgPSBlZnhf
bWNkaShlZngpOw0KLQl1bnNpZ25lZCBpbnQgdGltZSwgZmluaXNoOw0KKwl1bnNpZ25lZCBsb25n
IHRpbWUsIGZpbmlzaDsNCiAJdW5zaWduZWQgaW50IHJlc3BzZXEsIHJlc3BjbWQsIGVycm9yOw0K
IAl1bnNpZ25lZCBpbnQgcGR1ID0gRlJfQ1pfTUNfVFJFR19TTUVNICsgTUNESV9QRFUoZWZ4KTsN
CiAJdW5zaWduZWQgaW50IHJjLCBzcGluczsNCkBAIC0xMzYsNyArMTM2LDcgQEAgc3RhdGljIGlu
dCBlZnhfbWNkaV9wb2xsKHN0cnVjdCBlZnhfbmljICplZngpDQogCSAqIGFuZCBwb2xsIG9uY2Ug
YSBqaWZmeSAoYXBwcm94aW1hdGVseSkNCiAJICovDQogCXNwaW5zID0gVElDS19VU0VDOw0KLQlm
aW5pc2ggPSBnZXRfc2Vjb25kcygpICsgTUNESV9SUENfVElNRU9VVDsNCisJZmluaXNoID0gamlm
ZmllcyArIE1DRElfUlBDX1RJTUVPVVQ7DQogDQogCXdoaWxlICgxKSB7DQogCQlpZiAoc3BpbnMg
IT0gMCkgew0KQEAgLTE0Niw3ICsxNDYsNyBAQCBzdGF0aWMgaW50IGVmeF9tY2RpX3BvbGwoc3Ry
dWN0IGVmeF9uaWMgKmVmeCkNCiAJCQlzY2hlZHVsZV90aW1lb3V0X3VuaW50ZXJydXB0aWJsZSgx
KTsNCiAJCX0NCiANCi0JCXRpbWUgPSBnZXRfc2Vjb25kcygpOw0KKwkJdGltZSA9IGppZmZpZXM7
DQogDQogCQlybWIoKTsNCiAJCWVmeF9yZWFkZChlZngsICZyZWcsIHBkdSk7DQpAQCAtMTU4LDcg
KzE1OCw3IEBAIHN0YXRpYyBpbnQgZWZ4X21jZGlfcG9sbChzdHJ1Y3QgZWZ4X25pYyAqZWZ4KQ0K
IAkJICAgIEVGWF9EV09SRF9GSUVMRChyZWcsIE1DRElfSEVBREVSX1JFU1BPTlNFKSkNCiAJCQli
cmVhazsNCiANCi0JCWlmICh0aW1lID49IGZpbmlzaCkNCisJCWlmICh0aW1lX2FmdGVyKHRpbWUs
IGZpbmlzaCkpDQogCQkJcmV0dXJuIC1FVElNRURPVVQ7DQogCX0NCiANCkBAIC0yNTAsNyArMjUw
LDcgQEAgc3RhdGljIGludCBlZnhfbWNkaV9hd2FpdF9jb21wbGV0aW9uKHN0cnVjdCBlZnhfbmlj
ICplZngpDQogCWlmICh3YWl0X2V2ZW50X3RpbWVvdXQoDQogCQkgICAgbWNkaS0+d3EsDQogCQkg
ICAgYXRvbWljX3JlYWQoJm1jZGktPnN0YXRlKSA9PSBNQ0RJX1NUQVRFX0NPTVBMRVRFRCwNCi0J
CSAgICBtc2Vjc190b19qaWZmaWVzKE1DRElfUlBDX1RJTUVPVVQgKiAxMDAwKSkgPT0gMCkNCisJ
CSAgICBNQ0RJX1JQQ19USU1FT1VUKSA9PSAwKQ0KIAkJcmV0dXJuIC1FVElNRURPVVQ7DQogDQog
CS8qIENoZWNrIGlmIGVmeF9tY2RpX3NldF9tb2RlKCkgc3dpdGNoZWQgdXMgYmFjayB0byBwb2xs
ZWQgY29tcGxldGlvbnMuDQpAQCAtNjY2LDkgKzY2Niw4IEBAIGludCBlZnhfbWNkaV9nZXRfYm9h
cmRfY2ZnKHN0cnVjdCBlZnhfbmljICplZngsIHU4ICptYWNfYWRkcmVzcywNCiAJCQkgICB1MTYg
KmZ3X3N1YnR5cGVfbGlzdCkNCiB7DQogCXVpbnQ4X3Qgb3V0YnVmW01DX0NNRF9HRVRfQk9BUkRf
Q0ZHX09VVF9MRU5dOw0KLQlzaXplX3Qgb3V0bGVuOw0KKwlzaXplX3Qgb3V0bGVuLCBvZmZzZXQs
IGk7DQogCWludCBwb3J0X251bSA9IGVmeF9wb3J0X251bShlZngpOw0KLQlpbnQgb2Zmc2V0Ow0K
IAlpbnQgcmM7DQogDQogCUJVSUxEX0JVR19PTihNQ19DTURfR0VUX0JPQVJEX0NGR19JTl9MRU4g
IT0gMCk7DQpAQCAtNjg4LDEwICs2ODcsMTYgQEAgaW50IGVmeF9tY2RpX2dldF9ib2FyZF9jZmco
c3RydWN0IGVmeF9uaWMgKmVmeCwgdTggKm1hY19hZGRyZXNzLA0KIAkJOiBNQ19DTURfR0VUX0JP
QVJEX0NGR19PVVRfTUFDX0FERFJfQkFTRV9QT1JUMF9PRlNUOw0KIAlpZiAobWFjX2FkZHJlc3Mp
DQogCQltZW1jcHkobWFjX2FkZHJlc3MsIG91dGJ1ZiArIG9mZnNldCwgRVRIX0FMRU4pOw0KLQlp
ZiAoZndfc3VidHlwZV9saXN0KQ0KLQkJbWVtY3B5KGZ3X3N1YnR5cGVfbGlzdCwNCi0JCSAgICAg
ICBvdXRidWYgKyBNQ19DTURfR0VUX0JPQVJEX0NGR19PVVRfRldfU1VCVFlQRV9MSVNUX09GU1Qs
DQotCQkgICAgICAgTUNfQ01EX0dFVF9CT0FSRF9DRkdfT1VUX0ZXX1NVQlRZUEVfTElTVF9MRU4p
Ow0KKwlpZiAoZndfc3VidHlwZV9saXN0KSB7DQorCQlvZmZzZXQgPSBNQ19DTURfR0VUX0JPQVJE
X0NGR19PVVRfRldfU1VCVFlQRV9MSVNUX09GU1Q7DQorCQlmb3IgKGkgPSAwOw0KKwkJICAgICBp
IDwgTUNfQ01EX0dFVF9CT0FSRF9DRkdfT1VUX0ZXX1NVQlRZUEVfTElTVF9MRU4gLyAyOw0KKwkJ
ICAgICBpKyspIHsNCisJCQlmd19zdWJ0eXBlX2xpc3RbaV0gPQ0KKwkJCQlsZTE2X3RvX2NwdXAo
KF9fbGUxNiAqKShvdXRidWYgKyBvZmZzZXQpKTsNCisJCQlvZmZzZXQgKz0gMjsNCisJCX0NCisJ
fQ0KIA0KIAlyZXR1cm4gMDsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9z
ZmMvbWNkaS5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL21jZGkuaA0KaW5kZXggYWNlZDJh
Ny4uYjYxZWVhMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9tY2RpLmgN
CisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9tY2RpLmgNCkBAIC0xMjYsNSArMTI2LDYg
QEAgZXh0ZXJuIGludCBlZnhfbWNkaV93b2xfZmlsdGVyX3NldF9tYWdpYyhzdHJ1Y3QgZWZ4X25p
YyAqZWZ4LA0KIGV4dGVybiBpbnQgZWZ4X21jZGlfd29sX2ZpbHRlcl9nZXRfbWFnaWMoc3RydWN0
IGVmeF9uaWMgKmVmeCwgaW50ICppZF9vdXQpOw0KIGV4dGVybiBpbnQgZWZ4X21jZGlfd29sX2Zp
bHRlcl9yZW1vdmUoc3RydWN0IGVmeF9uaWMgKmVmeCwgaW50IGlkKTsNCiBleHRlcm4gaW50IGVm
eF9tY2RpX3dvbF9maWx0ZXJfcmVzZXQoc3RydWN0IGVmeF9uaWMgKmVmeCk7DQorZXh0ZXJuIGlu
dCBlZnhfbWNkaV9zZXRfbWFjKHN0cnVjdCBlZnhfbmljICplZngpOw0KIA0KICNlbmRpZiAvKiBF
RlhfTUNESV9IICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL21jZGlf
bWFjLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvbWNkaV9tYWMuYw0KaW5kZXggNTBjMjA3
Ny4uZGEyNjlkNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9tY2RpX21h
Yy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvbWNkaV9tYWMuYw0KQEAgLTEzLDcg
KzEzLDcgQEANCiAjaW5jbHVkZSAibWNkaS5oIg0KICNpbmNsdWRlICJtY2RpX3Bjb2wuaCINCiAN
Ci1zdGF0aWMgaW50IGVmeF9tY2RpX3NldF9tYWMoc3RydWN0IGVmeF9uaWMgKmVmeCkNCitpbnQg
ZWZ4X21jZGlfc2V0X21hYyhzdHJ1Y3QgZWZ4X25pYyAqZWZ4KQ0KIHsNCiAJdTMyIHJlamVjdCwg
ZmNudGw7DQogCXU4IGNtZGJ5dGVzW01DX0NNRF9TRVRfTUFDX0lOX0xFTl07DQpAQCAtNDUsNiAr
NDUsOCBAQCBzdGF0aWMgaW50IGVmeF9tY2RpX3NldF9tYWMoc3RydWN0IGVmeF9uaWMgKmVmeCkN
CiAJfQ0KIAlpZiAoZWZ4LT53YW50ZWRfZmMgJiBFRlhfRkNfQVVUTykNCiAJCWZjbnRsID0gTUNf
Q01EX0ZDTlRMX0FVVE87DQorCWlmIChlZngtPmZjX2Rpc2FibGUpDQorCQlmY250bCA9IE1DX0NN
RF9GQ05UTF9PRkY7DQogDQogCU1DRElfU0VUX0RXT1JEKGNtZGJ5dGVzLCBTRVRfTUFDX0lOX0ZD
TlRMLCBmY250bCk7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL25l
dF9kcml2ZXIuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9uZXRfZHJpdmVyLmgNCmluZGV4
IGI4ZTI1MWEuLjhiY2I4ZmQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMv
bmV0X2RyaXZlci5oDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvbmV0X2RyaXZlci5o
DQpAQCAtMjEzLDYgKzIxMyw3IEBAIHN0cnVjdCBlZnhfdHhfcXVldWUgew0KICAqCUlmIGJvdGgg
dGhpcyBhbmQgcGFnZSBhcmUgJU5VTEwsIHRoZSBidWZmZXIgc2xvdCBpcyBjdXJyZW50bHkgZnJl
ZS4NCiAgKiBAcGFnZTogVGhlIGFzc29jaWF0ZWQgcGFnZSBidWZmZXIsIGlmIGFueS4NCiAgKglJ
ZiBib3RoIHRoaXMgYW5kIHNrYiBhcmUgJU5VTEwsIHRoZSBidWZmZXIgc2xvdCBpcyBjdXJyZW50
bHkgZnJlZS4NCisgKiBAcGFnZV9vZmZzZXQ6IE9mZnNldCB3aXRoaW4gcGFnZS4gVmFsaWQgaWZm
IEBmbGFncyAmICVFRlhfUlhfQlVGX1BBR0UuDQogICogQGxlbjogQnVmZmVyIGxlbmd0aCwgaW4g
Ynl0ZXMuDQogICogQGlzX3BhZ2U6IEluZGljYXRlcyBpZiBAcGFnZSBpcyB2YWxpZC4gSWYgZmFs
c2UsIEBza2IgaXMgdmFsaWQuDQogICovDQpAQCAtMjIyLDcgKzIyMyw4IEBAIHN0cnVjdCBlZnhf
cnhfYnVmZmVyIHsNCiAJCXN0cnVjdCBza19idWZmICpza2I7DQogCQlzdHJ1Y3QgcGFnZSAqcGFn
ZTsNCiAJfSB1Ow0KLQl1bnNpZ25lZCBpbnQgbGVuOw0KKwl1MTYgcGFnZV9vZmZzZXQ7DQorCXUx
NiBsZW47DQogCWJvb2wgaXNfcGFnZTsNCiB9Ow0KIA0KQEAgLTY4OSw2ICs2OTEsOSBAQCBzdHJ1
Y3QgZWZ4X2ZpbHRlcl9zdGF0ZTsNCiAgKiBAcHJvbWlzY3VvdXM6IFByb21pc2N1b3VzIGZsYWcu
IFByb3RlY3RlZCBieSBuZXRpZl90eF9sb2NrLg0KICAqIEBtdWx0aWNhc3RfaGFzaDogTXVsdGlj
YXN0IGhhc2ggdGFibGUNCiAgKiBAd2FudGVkX2ZjOiBXYW50ZWQgZmxvdyBjb250cm9sIGZsYWdz
DQorICogQGZjX2Rpc2FibGU6IFdoZW4gbm9uLXplcm8gZmxvdyBjb250cm9sIGlzIGRpc2FibGVk
LiBUeXBpY2FsbHkgdXNlZCB0bw0KKyAqCWVuc3VyZSB0aGF0IG5ldHdvcmsgYmFjayBwcmVzc3Vy
ZSBkb2Vzbid0IGRlbGF5IGRtYSBxdWV1ZSBmbHVzaGVzLg0KKyAqCVNlcmlhbGlzZWQgYnkgdGhl
IHJ0bmwgbG9jay4NCiAgKiBAbWFjX3dvcms6IFdvcmsgaXRlbSBmb3IgY2hhbmdpbmcgTUFDIHBy
b21pc2N1aXR5IGFuZCBtdWx0aWNhc3QgaGFzaA0KICAqIEBsb29wYmFja19tb2RlOiBMb29wYmFj
ayBzdGF0dXMNCiAgKiBAbG9vcGJhY2tfbW9kZXM6IFN1cHBvcnRlZCBsb29wYmFjayBtb2RlIGJp
dG1hc2sNCkBAIC03ODIsNiArNzg3LDcgQEAgc3RydWN0IGVmeF9uaWMgew0KIAlib29sIHByb21p
c2N1b3VzOw0KIAl1bmlvbiBlZnhfbXVsdGljYXN0X2hhc2ggbXVsdGljYXN0X2hhc2g7DQogCXU4
IHdhbnRlZF9mYzsNCisJdW5zaWduZWQgZmNfZGlzYWJsZTsNCiANCiAJYXRvbWljX3QgcnhfcmVz
ZXQ7DQogCWVudW0gZWZ4X2xvb3BiYWNrX21vZGUgbG9vcGJhY2tfbW9kZTsNCkBAIC04MzUsNiAr
ODQxLDcgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQgZWZ4X3BvcnRfbnVtKHN0cnVjdCBl
ZnhfbmljICplZngpDQogICogQHJlbW92ZV9wb3J0OiBGcmVlIHJlc291cmNlcyBhbGxvY2F0ZWQg
YnkgcHJvYmVfcG9ydCgpDQogICogQGhhbmRsZV9nbG9iYWxfZXZlbnQ6IEhhbmRsZSBhICJnbG9i
YWwiIGV2ZW50IChtYXkgYmUgJU5VTEwpDQogICogQHByZXBhcmVfZmx1c2g6IFByZXBhcmUgdGhl
IGhhcmR3YXJlIGZvciBmbHVzaGluZyB0aGUgRE1BIHF1ZXVlcw0KKyAqIEBmaW5pc2hfZmx1c2g6
IENsZWFuIHVwIGFmdGVyIGZsdXNoaW5nIHRoZSBETUEgcXVldWVzDQogICogQHVwZGF0ZV9zdGF0
czogVXBkYXRlIHN0YXRpc3RpY3Mgbm90IHByb3ZpZGVkIGJ5IGV2ZW50IGhhbmRsaW5nDQogICog
QHN0YXJ0X3N0YXRzOiBTdGFydCB0aGUgcmVndWxhciBmZXRjaGluZyBvZiBzdGF0aXN0aWNzDQog
ICogQHN0b3Bfc3RhdHM6IFN0b3AgdGhlIHJlZ3VsYXIgZmV0Y2hpbmcgb2Ygc3RhdGlzdGljcw0K
QEAgLTg4MCw2ICs4ODcsNyBAQCBzdHJ1Y3QgZWZ4X25pY190eXBlIHsNCiAJdm9pZCAoKnJlbW92
ZV9wb3J0KShzdHJ1Y3QgZWZ4X25pYyAqZWZ4KTsNCiAJYm9vbCAoKmhhbmRsZV9nbG9iYWxfZXZl
bnQpKHN0cnVjdCBlZnhfY2hhbm5lbCAqY2hhbm5lbCwgZWZ4X3F3b3JkX3QgKik7DQogCXZvaWQg
KCpwcmVwYXJlX2ZsdXNoKShzdHJ1Y3QgZWZ4X25pYyAqZWZ4KTsNCisJdm9pZCAoKmZpbmlzaF9m
bHVzaCkoc3RydWN0IGVmeF9uaWMgKmVmeCk7DQogCXZvaWQgKCp1cGRhdGVfc3RhdHMpKHN0cnVj
dCBlZnhfbmljICplZngpOw0KIAl2b2lkICgqc3RhcnRfc3RhdHMpKHN0cnVjdCBlZnhfbmljICpl
ZngpOw0KIAl2b2lkICgqc3RvcF9zdGF0cykoc3RydWN0IGVmeF9uaWMgKmVmeCk7DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL25pYy5jIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvc2ZjL25pYy5jDQppbmRleCAzZWRmYmFmLi4yZTljYTEwIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvc2ZjL25pYy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMv
bmljLmMNCkBAIC0zNzEsNyArMzcxLDggQEAgZWZ4X21heV9wdXNoX3R4X2Rlc2Moc3RydWN0IGVm
eF90eF9xdWV1ZSAqdHhfcXVldWUsIHVuc2lnbmVkIGludCB3cml0ZV9jb3VudCkNCiAJCXJldHVy
biBmYWxzZTsNCiANCiAJdHhfcXVldWUtPmVtcHR5X3JlYWRfY291bnQgPSAwOw0KLQlyZXR1cm4g
KChlbXB0eV9yZWFkX2NvdW50IF4gd3JpdGVfY291bnQpICYgfkVGWF9FTVBUWV9DT1VOVF9WQUxJ
RCkgPT0gMDsNCisJcmV0dXJuICgoZW1wdHlfcmVhZF9jb3VudCBeIHdyaXRlX2NvdW50KSAmIH5F
RlhfRU1QVFlfQ09VTlRfVkFMSUQpID09IDANCisJCSYmIHR4X3F1ZXVlLT53cml0ZV9jb3VudCAt
IHdyaXRlX2NvdW50ID09IDE7DQogfQ0KIA0KIC8qIEZvciBlYWNoIGVudHJ5IGluc2VydGVkIGlu
dG8gdGhlIHNvZnR3YXJlIGRlc2NyaXB0b3IgcmluZywgY3JlYXRlIGENCkBAIC0xMjYxLDEzICsx
MjYyLDI3IEBAIGludCBlZnhfbmljX2ZsdXNoX3F1ZXVlcyhzdHJ1Y3QgZWZ4X25pYyAqZWZ4KQ0K
IAkJCX0NCiAJCQllZnhfZm9yX2VhY2hfcG9zc2libGVfY2hhbm5lbF90eF9xdWV1ZSh0eF9xdWV1
ZSwgY2hhbm5lbCkgew0KIAkJCQlpZiAodHhfcXVldWUtPmluaXRpYWxpc2VkICYmDQotCQkJCSAg
ICB0eF9xdWV1ZS0+Zmx1c2hlZCAhPSBGTFVTSF9ET05FKQ0KLQkJCQkJKyt0eF9wZW5kaW5nOw0K
KwkJCQkgICAgdHhfcXVldWUtPmZsdXNoZWQgIT0gRkxVU0hfRE9ORSkgew0KKwkJCQkJZWZ4X293
b3JkX3QgdHhkX3B0cl90Ymw7DQorDQorCQkJCQllZnhfcmVhZG9fdGFibGUoZWZ4LCAmdHhkX3B0
cl90YmwsDQorCQkJCQkJCUZSX0JaX1RYX0RFU0NfUFRSX1RCTCwNCisJCQkJCQkJdHhfcXVldWUt
PnF1ZXVlKTsNCisJCQkJCWlmIChFRlhfT1dPUkRfRklFTEQodHhkX3B0cl90YmwsDQorCQkJCQkJ
CSAgICBGUkZfQVpfVFhfREVTQ1FfRkxVU0gpIHx8DQorCQkJCQkgICAgRUZYX09XT1JEX0ZJRUxE
KHR4ZF9wdHJfdGJsLA0KKwkJCQkJCQkgICAgRlJGX0FaX1RYX0RFU0NRX0VOKSkNCisJCQkJCQkr
K3R4X3BlbmRpbmc7DQorCQkJCQllbHNlDQorCQkJCQkJdHhfcXVldWUtPmZsdXNoZWQgPSBGTFVT
SF9ET05FOw0KKwkJCQl9DQogCQkJfQ0KIAkJfQ0KIA0KLQkJaWYgKHJ4X3BlbmRpbmcgPT0gMCAm
JiB0eF9wZW5kaW5nID09IDApDQorCQlpZiAocnhfcGVuZGluZyA9PSAwICYmIHR4X3BlbmRpbmcg
PT0gMCkgew0KKwkJCWVmeC0+dHlwZS0+ZmluaXNoX2ZsdXNoKGVmeCk7DQogCQkJcmV0dXJuIDA7
DQorCQl9DQogDQogCQltc2xlZXAoRUZYX0ZMVVNIX0lOVEVSVkFMKTsNCiAJCWVmeF9wb2xsX2Zs
dXNoX2V2ZW50cyhlZngpOw0KQEAgLTEyOTMsNiArMTMwOCw3IEBAIGludCBlZnhfbmljX2ZsdXNo
X3F1ZXVlcyhzdHJ1Y3QgZWZ4X25pYyAqZWZ4KQ0KIAkJfQ0KIAl9DQogDQorCWVmeC0+dHlwZS0+
ZmluaXNoX2ZsdXNoKGVmeCk7DQogCXJldHVybiAtRVRJTUVET1VUOw0KIH0NCiANCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvbmljLmggYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9zZmMvbmljLmgNCmluZGV4IDY2ZWNlNDguLjU4MzAyYTIgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9zZmMvbmljLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9u
aWMuaA0KQEAgLTIxMCw2ICsyMTAsOCBAQCBleHRlcm4gdm9pZCBmYWxjb25faXJxX2Fja19hMShz
dHJ1Y3QgZWZ4X25pYyAqZWZ4KTsNCiANCiAvKiBHbG9iYWwgUmVzb3VyY2VzICovDQogZXh0ZXJu
IGludCBlZnhfbmljX2ZsdXNoX3F1ZXVlcyhzdHJ1Y3QgZWZ4X25pYyAqZWZ4KTsNCitleHRlcm4g
dm9pZCBzaWVuYV9wcmVwYXJlX2ZsdXNoKHN0cnVjdCBlZnhfbmljICplZngpOw0KK2V4dGVybiB2
b2lkIHNpZW5hX2ZpbmlzaF9mbHVzaChzdHJ1Y3QgZWZ4X25pYyAqZWZ4KTsNCiBleHRlcm4gdm9p
ZCBmYWxjb25fc3RhcnRfbmljX3N0YXRzKHN0cnVjdCBlZnhfbmljICplZngpOw0KIGV4dGVybiB2
b2lkIGZhbGNvbl9zdG9wX25pY19zdGF0cyhzdHJ1Y3QgZWZ4X25pYyAqZWZ4KTsNCiBleHRlcm4g
dm9pZCBmYWxjb25fc2V0dXBfeGF1aShzdHJ1Y3QgZWZ4X25pYyAqZWZ4KTsNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvcnguYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Nm
Yy9yeC5jDQppbmRleCA1ZWY0Y2MwLi45Y2U4NjY1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvc2ZjL3J4LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9yeC5jDQpA
QCAtOTUsMTEgKzk1LDcgQEAgc3RhdGljIHVuc2lnbmVkIGludCByeF9yZWZpbGxfbGltaXQgPSA5
NTsNCiBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludCBlZnhfcnhfYnVmX29mZnNldChzdHJ1Y3Qg
ZWZ4X25pYyAqZWZ4LA0KIAkJCQkJICAgICBzdHJ1Y3QgZWZ4X3J4X2J1ZmZlciAqYnVmKQ0KIHsN
Ci0JLyogT2Zmc2V0IGlzIGFsd2F5cyB3aXRoaW4gb25lIHBhZ2UsIHNvIHdlIGRvbid0IG5lZWQg
dG8gY29uc2lkZXINCi0JICogdGhlIHBhZ2Ugb3JkZXIuDQotCSAqLw0KLQlyZXR1cm4gKCgoX19m
b3JjZSB1bnNpZ25lZCBsb25nKSBidWYtPmRtYV9hZGRyICYgKFBBR0VfU0laRSAtIDEpKSArDQot
CQllZngtPnR5cGUtPnJ4X2J1ZmZlcl9oYXNoX3NpemUpOw0KKwlyZXR1cm4gYnVmLT5wYWdlX29m
ZnNldCArIGVmeC0+dHlwZS0+cnhfYnVmZmVyX2hhc2hfc2l6ZTsNCiB9DQogc3RhdGljIGlubGlu
ZSB1bnNpZ25lZCBpbnQgZWZ4X3J4X2J1Zl9zaXplKHN0cnVjdCBlZnhfbmljICplZngpDQogew0K
QEAgLTE5NCw2ICsxOTAsNyBAQCBzdGF0aWMgaW50IGVmeF9pbml0X3J4X2J1ZmZlcnNfcGFnZShz
dHJ1Y3QgZWZ4X3J4X3F1ZXVlICpyeF9xdWV1ZSkNCiAJc3RydWN0IGVmeF9yeF9idWZmZXIgKnJ4
X2J1ZjsNCiAJc3RydWN0IHBhZ2UgKnBhZ2U7DQogCXZvaWQgKnBhZ2VfYWRkcjsNCisJdW5zaWdu
ZWQgaW50IHBhZ2Vfb2Zmc2V0Ow0KIAlzdHJ1Y3QgZWZ4X3J4X3BhZ2Vfc3RhdGUgKnN0YXRlOw0K
IAlkbWFfYWRkcl90IGRtYV9hZGRyOw0KIAl1bnNpZ25lZCBpbmRleCwgY291bnQ7DQpAQCAtMjIw
LDEyICsyMTcsMTQgQEAgc3RhdGljIGludCBlZnhfaW5pdF9yeF9idWZmZXJzX3BhZ2Uoc3RydWN0
IGVmeF9yeF9xdWV1ZSAqcnhfcXVldWUpDQogDQogCQlwYWdlX2FkZHIgKz0gc2l6ZW9mKHN0cnVj
dCBlZnhfcnhfcGFnZV9zdGF0ZSk7DQogCQlkbWFfYWRkciArPSBzaXplb2Yoc3RydWN0IGVmeF9y
eF9wYWdlX3N0YXRlKTsNCisJCXBhZ2Vfb2Zmc2V0ID0gc2l6ZW9mKHN0cnVjdCBlZnhfcnhfcGFn
ZV9zdGF0ZSk7DQogDQogCXNwbGl0Og0KIAkJaW5kZXggPSByeF9xdWV1ZS0+YWRkZWRfY291bnQg
JiByeF9xdWV1ZS0+cHRyX21hc2s7DQogCQlyeF9idWYgPSBlZnhfcnhfYnVmZmVyKHJ4X3F1ZXVl
LCBpbmRleCk7DQogCQlyeF9idWYtPmRtYV9hZGRyID0gZG1hX2FkZHIgKyBFRlhfUEFHRV9JUF9B
TElHTjsNCiAJCXJ4X2J1Zi0+dS5wYWdlID0gcGFnZTsNCisJCXJ4X2J1Zi0+cGFnZV9vZmZzZXQg
PSBwYWdlX29mZnNldCArIEVGWF9QQUdFX0lQX0FMSUdOOw0KIAkJcnhfYnVmLT5sZW4gPSBlZngt
PnJ4X2J1ZmZlcl9sZW4gLSBFRlhfUEFHRV9JUF9BTElHTjsNCiAJCXJ4X2J1Zi0+aXNfcGFnZSA9
IHRydWU7DQogCQkrK3J4X3F1ZXVlLT5hZGRlZF9jb3VudDsNCkBAIC0yMzcsNiArMjM2LDcgQEAg
c3RhdGljIGludCBlZnhfaW5pdF9yeF9idWZmZXJzX3BhZ2Uoc3RydWN0IGVmeF9yeF9xdWV1ZSAq
cnhfcXVldWUpDQogCQkJZ2V0X3BhZ2UocGFnZSk7DQogCQkJZG1hX2FkZHIgKz0gKFBBR0VfU0la
RSA+PiAxKTsNCiAJCQlwYWdlX2FkZHIgKz0gKFBBR0VfU0laRSA+PiAxKTsNCisJCQlwYWdlX29m
ZnNldCArPSAoUEFHRV9TSVpFID4+IDEpOw0KIAkJCSsrY291bnQ7DQogCQkJZ290byBzcGxpdDsN
CiAJCX0NCkBAIC0yNDYsNyArMjQ2LDggQEAgc3RhdGljIGludCBlZnhfaW5pdF9yeF9idWZmZXJz
X3BhZ2Uoc3RydWN0IGVmeF9yeF9xdWV1ZSAqcnhfcXVldWUpDQogfQ0KIA0KIHN0YXRpYyB2b2lk
IGVmeF91bm1hcF9yeF9idWZmZXIoc3RydWN0IGVmeF9uaWMgKmVmeCwNCi0JCQkJc3RydWN0IGVm
eF9yeF9idWZmZXIgKnJ4X2J1ZikNCisJCQkJc3RydWN0IGVmeF9yeF9idWZmZXIgKnJ4X2J1ZiwN
CisJCQkJdW5zaWduZWQgaW50IHVzZWRfbGVuKQ0KIHsNCiAJaWYgKHJ4X2J1Zi0+aXNfcGFnZSAm
JiByeF9idWYtPnUucGFnZSkgew0KIAkJc3RydWN0IGVmeF9yeF9wYWdlX3N0YXRlICpzdGF0ZTsN
CkBAIC0yNTcsNiArMjU4LDEwIEBAIHN0YXRpYyB2b2lkIGVmeF91bm1hcF9yeF9idWZmZXIoc3Ry
dWN0IGVmeF9uaWMgKmVmeCwNCiAJCQkJICAgICAgIHN0YXRlLT5kbWFfYWRkciwNCiAJCQkJICAg
ICAgIGVmeF9yeF9idWZfc2l6ZShlZngpLA0KIAkJCQkgICAgICAgUENJX0RNQV9GUk9NREVWSUNF
KTsNCisJCX0gZWxzZSBpZiAodXNlZF9sZW4pIHsNCisJCQlkbWFfc3luY19zaW5nbGVfZm9yX2Nw
dSgmZWZ4LT5wY2lfZGV2LT5kZXYsDQorCQkJCQkJcnhfYnVmLT5kbWFfYWRkciwgdXNlZF9sZW4s
DQorCQkJCQkJRE1BX0ZST01fREVWSUNFKTsNCiAJCX0NCiAJfSBlbHNlIGlmICghcnhfYnVmLT5p
c19wYWdlICYmIHJ4X2J1Zi0+dS5za2IpIHsNCiAJCXBjaV91bm1hcF9zaW5nbGUoZWZ4LT5wY2lf
ZGV2LCByeF9idWYtPmRtYV9hZGRyLA0KQEAgLTI3OSw3ICsyODQsNyBAQCBzdGF0aWMgdm9pZCBl
ZnhfZnJlZV9yeF9idWZmZXIoc3RydWN0IGVmeF9uaWMgKmVmeCwNCiBzdGF0aWMgdm9pZCBlZnhf
ZmluaV9yeF9idWZmZXIoc3RydWN0IGVmeF9yeF9xdWV1ZSAqcnhfcXVldWUsDQogCQkJICAgICAg
IHN0cnVjdCBlZnhfcnhfYnVmZmVyICpyeF9idWYpDQogew0KLQllZnhfdW5tYXBfcnhfYnVmZmVy
KHJ4X3F1ZXVlLT5lZngsIHJ4X2J1Zik7DQorCWVmeF91bm1hcF9yeF9idWZmZXIocnhfcXVldWUt
PmVmeCwgcnhfYnVmLCAwKTsNCiAJZWZ4X2ZyZWVfcnhfYnVmZmVyKHJ4X3F1ZXVlLT5lZngsIHJ4
X2J1Zik7DQogfQ0KIA0KQEAgLTU1MCwxMCArNTU1LDEwIEBAIHZvaWQgZWZ4X3J4X3BhY2tldChz
dHJ1Y3QgZWZ4X3J4X3F1ZXVlICpyeF9xdWV1ZSwgdW5zaWduZWQgaW50IGluZGV4LA0KIAkJZ290
byBvdXQ7DQogCX0NCiANCi0JLyogUmVsZWFzZSBjYXJkIHJlc291cmNlcyAtIGFzc3VtZXMgYWxs
IFJYIGJ1ZmZlcnMgY29uc3VtZWQgaW4tb3JkZXINCi0JICogcGVyIFJYIHF1ZXVlDQorCS8qIFJl
bGVhc2UgYW5kL29yIHN5bmMgRE1BIG1hcHBpbmcgLSBhc3N1bWVzIGFsbCBSWCBidWZmZXJzDQor
CSAqIGNvbnN1bWVkIGluLW9yZGVyIHBlciBSWCBxdWV1ZQ0KIAkgKi8NCi0JZWZ4X3VubWFwX3J4
X2J1ZmZlcihlZngsIHJ4X2J1Zik7DQorCWVmeF91bm1hcF9yeF9idWZmZXIoZWZ4LCByeF9idWYs
IGxlbik7DQogDQogCS8qIFByZWZldGNoIG5pY2UgYW5kIGVhcmx5IHNvIGRhdGEgd2lsbCAoaG9w
ZWZ1bGx5KSBiZSBpbiBjYWNoZSBieQ0KIAkgKiB0aGUgdGltZSB3ZSBsb29rIGF0IGl0Lg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9zZWxmdGVzdC5jIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc2ZjL3NlbGZ0ZXN0LmMNCmluZGV4IDgyMmY2YzIuLjQ5MDc4ODUgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvc2VsZnRlc3QuYw0KKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvc2ZjL3NlbGZ0ZXN0LmMNCkBAIC02OTgsNyArNjk4LDcgQEAgaW50IGVm
eF9zZWxmdGVzdChzdHJ1Y3QgZWZ4X25pYyAqZWZ4LCBzdHJ1Y3QgZWZ4X3NlbGZfdGVzdHMgKnRl
c3RzLA0KIAkvKiBEZXRhY2ggdGhlIGRldmljZSBzbyB0aGUga2VybmVsIGRvZXNuJ3QgdHJhbnNt
aXQgZHVyaW5nIHRoZQ0KIAkgKiBsb29wYmFjayB0ZXN0IGFuZCB0aGUgd2F0Y2hkb2cgdGltZW91
dCBkb2Vzbid0IGZpcmUuDQogCSAqLw0KLQluZXRpZl9kZXZpY2VfZGV0YWNoKGVmeC0+bmV0X2Rl
dik7DQorCWVmeF9kZXZpY2VfZGV0YWNoX3N5bmMoZWZ4KTsNCiANCiAJbXV0ZXhfbG9jaygmZWZ4
LT5tYWNfbG9jayk7DQogCWlmIChlZngtPmxvb3BiYWNrX21vZGVzKSB7DQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL3NpZW5hLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9z
ZmMvc2llbmEuYw0KaW5kZXggY2MyNTQ5Yy4uYzU4Yjk3MyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3NmYy9zaWVuYS5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMv
c2llbmEuYw0KQEAgLTEzNyw2ICsxMzcsMTggQEAgc3RhdGljIHZvaWQgc2llbmFfcmVtb3ZlX3Bv
cnQoc3RydWN0IGVmeF9uaWMgKmVmeCkNCiAJZWZ4X25pY19mcmVlX2J1ZmZlcihlZngsICZlZngt
PnN0YXRzX2J1ZmZlcik7DQogfQ0KIA0KK3ZvaWQgc2llbmFfcHJlcGFyZV9mbHVzaChzdHJ1Y3Qg
ZWZ4X25pYyAqZWZ4KQ0KK3sNCisJaWYgKGVmeC0+ZmNfZGlzYWJsZSsrID09IDApDQorCQllZnhf
bWNkaV9zZXRfbWFjKGVmeCk7DQorfQ0KKw0KK3ZvaWQgc2llbmFfZmluaXNoX2ZsdXNoKHN0cnVj
dCBlZnhfbmljICplZngpDQorew0KKwlpZiAoLS1lZngtPmZjX2Rpc2FibGUgPT0gMCkNCisJCWVm
eF9tY2RpX3NldF9tYWMoZWZ4KTsNCit9DQorDQogc3RhdGljIGNvbnN0IHN0cnVjdCBlZnhfbmlj
X3JlZ2lzdGVyX3Rlc3Qgc2llbmFfcmVnaXN0ZXJfdGVzdHNbXSA9IHsNCiAJeyBGUl9BWl9BRFJf
UkVHSU9OLA0KIAkgIEVGWF9PV09SRDMyKDB4MDAwM0ZGRkYsIDB4MDAwM0ZGRkYsIDB4MDAwM0ZG
RkYsIDB4MDAwM0ZGRkYpIH0sDQpAQCAtNjI0LDcgKzYzNiw4IEBAIGNvbnN0IHN0cnVjdCBlZnhf
bmljX3R5cGUgc2llbmFfYTBfbmljX3R5cGUgPSB7DQogCS5yZXNldCA9IHNpZW5hX3Jlc2V0X2h3
LA0KIAkucHJvYmVfcG9ydCA9IHNpZW5hX3Byb2JlX3BvcnQsDQogCS5yZW1vdmVfcG9ydCA9IHNp
ZW5hX3JlbW92ZV9wb3J0LA0KLQkucHJlcGFyZV9mbHVzaCA9IGVmeF9wb3J0X2R1bW15X29wX3Zv
aWQsDQorCS5wcmVwYXJlX2ZsdXNoID0gc2llbmFfcHJlcGFyZV9mbHVzaCwNCisJLmZpbmlzaF9m
bHVzaCA9IHNpZW5hX2ZpbmlzaF9mbHVzaCwNCiAJLnVwZGF0ZV9zdGF0cyA9IHNpZW5hX3VwZGF0
ZV9uaWNfc3RhdHMsDQogCS5zdGFydF9zdGF0cyA9IHNpZW5hX3N0YXJ0X25pY19zdGF0cywNCiAJ
LnN0b3Bfc3RhdHMgPSBzaWVuYV9zdG9wX25pY19zdGF0cywNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9tYWN2bGFuLmMgYi9kcml2ZXJzL25ldC9tYWN2bGFuLmMNCmluZGV4IDk3ZjM0MmUuLjU0
NGFjMDYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9tYWN2bGFuLmMNCisrKyBiL2RyaXZlcnMv
bmV0L21hY3ZsYW4uYw0KQEAgLTU4NSw2ICs1ODUsNyBAQCB2b2lkIG1hY3ZsYW5fY29tbW9uX3Nl
dHVwKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQogCWV0aGVyX3NldHVwKGRldik7DQogDQogCWRl
di0+cHJpdl9mbGFncwkgICAgICAgJj0gfihJRkZfWE1JVF9EU1RfUkVMRUFTRSB8IElGRl9UWF9T
S0JfU0hBUklORyk7DQorCWRldi0+cHJpdl9mbGFncwkgICAgICAgfD0gSUZGX1VOSUNBU1RfRkxU
Ow0KIAlkZXYtPm5ldGRldl9vcHMJCT0gJm1hY3ZsYW5fbmV0ZGV2X29wczsNCiAJZGV2LT5kZXN0
cnVjdG9yCQk9IGZyZWVfbmV0ZGV2Ow0KIAlkZXYtPmhlYWRlcl9vcHMJCT0gJm1hY3ZsYW5faGFy
ZF9oZWFkZXJfb3BzLA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L25ldGNvbnNvbGUuYyBiL2Ry
aXZlcnMvbmV0L25ldGNvbnNvbGUuYw0KaW5kZXggMDFiMTA0ZS4uYmZmNjkwOCAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvbmV0L25ldGNvbnNvbGUuYw0KKysrIGIvZHJpdmVycy9uZXQvbmV0Y29uc29s
ZS5jDQpAQCAtNjMwLDYgKzYzMCw3IEBAIHN0YXRpYyBpbnQgbmV0Y29uc29sZV9uZXRkZXZfZXZl
bnQoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICp0aGlzLA0KIAkJZ290byBkb25lOw0KIA0KIAlzcGlu
X2xvY2tfaXJxc2F2ZSgmdGFyZ2V0X2xpc3RfbG9jaywgZmxhZ3MpOw0KK3Jlc3RhcnQ6DQogCWxp
c3RfZm9yX2VhY2hfZW50cnkobnQsICZ0YXJnZXRfbGlzdCwgbGlzdCkgew0KIAkJbmV0Y29uc29s
ZV90YXJnZXRfZ2V0KG50KTsNCiAJCWlmIChudC0+bnAuZGV2ID09IGRldikgew0KQEAgLTY0Miwy
MCArNjQzLDE3IEBAIHN0YXRpYyBpbnQgbmV0Y29uc29sZV9uZXRkZXZfZXZlbnQoc3RydWN0IG5v
dGlmaWVyX2Jsb2NrICp0aGlzLA0KIAkJCWNhc2UgTkVUREVWX1VOUkVHSVNURVI6DQogCQkJCS8q
DQogCQkJCSAqIHJ0bmxfbG9jayBhbHJlYWR5IGhlbGQNCisJCQkJICogd2UgbWlnaHQgc2xlZXAg
aW4gX19uZXRwb2xsX2NsZWFudXAoKQ0KIAkJCQkgKi8NCi0JCQkJaWYgKG50LT5ucC5kZXYpIHsN
Ci0JCQkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoDQotCQkJCQkJCSAgICAgICZ0YXJnZXRfbGlz
dF9sb2NrLA0KLQkJCQkJCQkgICAgICBmbGFncyk7DQotCQkJCQlfX25ldHBvbGxfY2xlYW51cCgm
bnQtPm5wKTsNCi0JCQkJCXNwaW5fbG9ja19pcnFzYXZlKCZ0YXJnZXRfbGlzdF9sb2NrLA0KLQkJ
CQkJCQkgIGZsYWdzKTsNCi0JCQkJCWRldl9wdXQobnQtPm5wLmRldik7DQotCQkJCQludC0+bnAu
ZGV2ID0gTlVMTDsNCi0JCQkJfQ0KKwkJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZ0YXJnZXRf
bGlzdF9sb2NrLCBmbGFncyk7DQorCQkJCV9fbmV0cG9sbF9jbGVhbnVwKCZudC0+bnApOw0KKwkJ
CQlzcGluX2xvY2tfaXJxc2F2ZSgmdGFyZ2V0X2xpc3RfbG9jaywgZmxhZ3MpOw0KKwkJCQlkZXZf
cHV0KG50LT5ucC5kZXYpOw0KKwkJCQludC0+bnAuZGV2ID0gTlVMTDsNCiAJCQkJbnQtPmVuYWJs
ZWQgPSAwOw0KIAkJCQlzdG9wcGVkID0gdHJ1ZTsNCi0JCQkJYnJlYWs7DQorCQkJCW5ldGNvbnNv
bGVfdGFyZ2V0X3B1dChudCk7DQorCQkJCWdvdG8gcmVzdGFydDsNCiAJCQl9DQogCQl9DQogCQlu
ZXRjb25zb2xlX3RhcmdldF9wdXQobnQpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3R1bi5j
IGIvZHJpdmVycy9uZXQvdHVuLmMNCmluZGV4IGExMmM5YmYuLmY0YzVkZTYgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC90dW4uYw0KKysrIGIvZHJpdmVycy9uZXQvdHVuLmMNCkBAIC00MTcsNiAr
NDE3LDggQEAgc3RhdGljIG5ldGRldl90eF90IHR1bl9uZXRfeG1pdChzdHJ1Y3Qgc2tfYnVmZiAq
c2tiLCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KIAkgKiBmb3IgaW5kZWZpbml0ZSB0aW1lLiAq
Lw0KIAlza2Jfb3JwaGFuKHNrYik7DQogDQorCW5mX3Jlc2V0KHNrYik7DQorDQogCS8qIEVucXVl
dWUgcGFja2V0ICovDQogCXNrYl9xdWV1ZV90YWlsKCZ0dW4tPnNvY2tldC5zay0+c2tfcmVjZWl2
ZV9xdWV1ZSwgc2tiKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lm
aWV4L2pvaW4uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvam9pbi5jDQppbmRleCA2
MmI0YzI5Li5kNDhkZmI3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmll
eC9qb2luLmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvam9pbi5jDQpAQCAt
MTA2MiwxMCArMTA2Miw5IEBAIG13aWZpZXhfY21kXzgwMl8xMV9hZF9ob2Nfam9pbihzdHJ1Y3Qg
bXdpZmlleF9wcml2YXRlICpwcml2LA0KIAkJCQlhZGhvY19qb2luLT5ic3NfZGVzY3JpcHRvci5i
c3NpZCwNCiAJCQkJYWRob2Nfam9pbi0+YnNzX2Rlc2NyaXB0b3Iuc3NpZCk7DQogDQotCWZvciAo
aSA9IDA7IGJzc19kZXNjLT5zdXBwb3J0ZWRfcmF0ZXNbaV0gJiYNCi0JCQlpIDwgTVdJRklFWF9T
VVBQT1JURURfUkFURVM7DQotCQkJaSsrKQ0KLQkJCTsNCisJZm9yIChpID0gMDsgaSA8IE1XSUZJ
RVhfU1VQUE9SVEVEX1JBVEVTICYmDQorCQkgICAgYnNzX2Rlc2MtPnN1cHBvcnRlZF9yYXRlc1tp
XTsgaSsrKQ0KKwkJOw0KIAlyYXRlc19zaXplID0gaTsNCiANCiAJLyogQ29weSBEYXRhIFJhdGVz
IGZyb20gdGhlIFJhdGVzIHJlY29yZGVkIGluIHNjYW4gcmVzcG9uc2UgKi8NCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3J0bDgxOTJjdS9ody5jIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTkyY3UvaHcuYw0KaW5kZXggODE0YzA1ZC4uZDM5MjBk
YSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MmN1L2h3
LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MmN1L2h3LmMNCkBA
IC0xNTU3LDc0ICsxNTU3LDU3IEBAIHZvaWQgcnRsOTJjdV9jYXJkX2Rpc2FibGUoc3RydWN0IGll
ZWU4MDIxMV9odyAqaHcpDQogDQogdm9pZCBydGw5MmN1X3NldF9jaGVja19ic3NpZChzdHJ1Y3Qg
aWVlZTgwMjExX2h3ICpodywgYm9vbCBjaGVja19ic3NpZCkNCiB7DQotCS8qIGR1bW15IHJvdXRp
bmUgbmVlZGVkIGZvciBjYWxsYmFjayBmcm9tIHJ0bF9vcF9jb25maWd1cmVfZmlsdGVyKCkgKi8N
Ci19DQotDQotLyo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PSAqLw0KLQ0KLXN0YXRpYyB2b2lkIF9ydGw5MmN1
X3NldF9jaGVja19ic3NpZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywNCi0JCQkgICAgICBlbnVt
IG5sODAyMTFfaWZ0eXBlIHR5cGUpDQotew0KIAlzdHJ1Y3QgcnRsX3ByaXYgKnJ0bHByaXYgPSBy
dGxfcHJpdihodyk7DQotCXUzMiByZWdfcmNyID0gcnRsX3JlYWRfZHdvcmQocnRscHJpdiwgUkVH
X1JDUik7DQogCXN0cnVjdCBydGxfaGFsICpydGxoYWwgPSBydGxfaGFsKHJ0bHByaXYpOw0KLQlz
dHJ1Y3QgcnRsX3BoeSAqcnRscGh5ID0gJihydGxwcml2LT5waHkpOw0KLQl1OCBmaWx0ZXJvdXRf
bm9uX2Fzc29jaWF0ZWRfYnNzaWQgPSBmYWxzZTsNCisJdTMyIHJlZ19yY3IgPSBydGxfcmVhZF9k
d29yZChydGxwcml2LCBSRUdfUkNSKTsNCiANCi0Jc3dpdGNoICh0eXBlKSB7DQotCWNhc2UgTkw4
MDIxMV9JRlRZUEVfQURIT0M6DQotCWNhc2UgTkw4MDIxMV9JRlRZUEVfU1RBVElPTjoNCi0JCWZp
bHRlcm91dF9ub25fYXNzb2NpYXRlZF9ic3NpZCA9IHRydWU7DQotCQlicmVhazsNCi0JY2FzZSBO
TDgwMjExX0lGVFlQRV9VTlNQRUNJRklFRDoNCi0JY2FzZSBOTDgwMjExX0lGVFlQRV9BUDoNCi0J
ZGVmYXVsdDoNCi0JCWJyZWFrOw0KLQl9DQotCWlmIChmaWx0ZXJvdXRfbm9uX2Fzc29jaWF0ZWRf
YnNzaWQpIHsNCisJaWYgKHJ0bHByaXYtPnBzYy5yZnB3cl9zdGF0ZSAhPSBFUkZPTikNCisJCXJl
dHVybjsNCisNCisJaWYgKGNoZWNrX2Jzc2lkKSB7DQorCQl1OCB0bXA7DQogCQlpZiAoSVNfTk9S
TUFMX0NISVAocnRsaGFsLT52ZXJzaW9uKSkgew0KLQkJCXN3aXRjaCAocnRscGh5LT5jdXJyZW50
X2lvX3R5cGUpIHsNCi0JCQljYXNlIElPX0NNRF9SRVNVTUVfRE1fQllfU0NBTjoNCi0JCQkJcmVn
X3JjciB8PSAoUkNSX0NCU1NJRF9EQVRBIHwgUkNSX0NCU1NJRF9CQ04pOw0KLQkJCQlydGxwcml2
LT5jZmctPm9wcy0+c2V0X2h3X3JlZyhodywNCi0JCQkJCQkgSFdfVkFSX1JDUiwgKHU4ICopKCZy
ZWdfcmNyKSk7DQotCQkJCS8qIGVuYWJsZSB1cGRhdGUgVFNGICovDQotCQkJCV9ydGw5MmN1X3Nl
dF9iY25fY3RybF9yZWcoaHcsIDAsIEJJVCg0KSk7DQotCQkJCWJyZWFrOw0KLQkJCWNhc2UgSU9f
Q01EX1BBVVNFX0RNX0JZX1NDQU46DQotCQkJCXJlZ19yY3IgJj0gfihSQ1JfQ0JTU0lEX0RBVEEg
fCBSQ1JfQ0JTU0lEX0JDTik7DQotCQkJCXJ0bHByaXYtPmNmZy0+b3BzLT5zZXRfaHdfcmVnKGh3
LA0KLQkJCQkJCSBIV19WQVJfUkNSLCAodTggKikoJnJlZ19yY3IpKTsNCi0JCQkJLyogZGlzYWJs
ZSB1cGRhdGUgVFNGICovDQotCQkJCV9ydGw5MmN1X3NldF9iY25fY3RybF9yZWcoaHcsIEJJVCg0
KSwgMCk7DQotCQkJCWJyZWFrOw0KLQkJCX0NCisJCQlyZWdfcmNyIHw9IChSQ1JfQ0JTU0lEX0RB
VEEgfCBSQ1JfQ0JTU0lEX0JDTik7DQorCQkJdG1wID0gQklUKDQpOw0KIAkJfSBlbHNlIHsNCi0J
CQlyZWdfcmNyIHw9IChSQ1JfQ0JTU0lEKTsNCi0JCQlydGxwcml2LT5jZmctPm9wcy0+c2V0X2h3
X3JlZyhodywgSFdfVkFSX1JDUiwNCi0JCQkJCQkgICAgICAodTggKikoJnJlZ19yY3IpKTsNCi0J
CQlfcnRsOTJjdV9zZXRfYmNuX2N0cmxfcmVnKGh3LCAwLCAoQklUKDQpfEJJVCg1KSkpOw0KKwkJ
CXJlZ19yY3IgfD0gUkNSX0NCU1NJRDsNCisJCQl0bXAgPSBCSVQoNCkgfCBCSVQoNSk7DQogCQl9
DQotCX0gZWxzZSBpZiAoZmlsdGVyb3V0X25vbl9hc3NvY2lhdGVkX2Jzc2lkID09IGZhbHNlKSB7
DQorCQlydGxwcml2LT5jZmctPm9wcy0+c2V0X2h3X3JlZyhodywgSFdfVkFSX1JDUiwNCisJCQkJ
CSAgICAgICh1OCAqKSAoJnJlZ19yY3IpKTsNCisJCV9ydGw5MmN1X3NldF9iY25fY3RybF9yZWco
aHcsIDAsIHRtcCk7DQorCX0gZWxzZSB7DQorCQl1OCB0bXA7DQogCQlpZiAoSVNfTk9STUFMX0NI
SVAocnRsaGFsLT52ZXJzaW9uKSkgew0KLQkJCXJlZ19yY3IgJj0gKH4oUkNSX0NCU1NJRF9EQVRB
IHwgUkNSX0NCU1NJRF9CQ04pKTsNCi0JCQlydGxwcml2LT5jZmctPm9wcy0+c2V0X2h3X3JlZyho
dywgSFdfVkFSX1JDUiwNCi0JCQkJCQkgICAgICAodTggKikoJnJlZ19yY3IpKTsNCi0JCQlfcnRs
OTJjdV9zZXRfYmNuX2N0cmxfcmVnKGh3LCBCSVQoNCksIDApOw0KKwkJCXJlZ19yY3IgJj0gfihS
Q1JfQ0JTU0lEX0RBVEEgfCBSQ1JfQ0JTU0lEX0JDTik7DQorCQkJdG1wID0gQklUKDQpOw0KIAkJ
fSBlbHNlIHsNCi0JCQlyZWdfcmNyICY9ICh+UkNSX0NCU1NJRCk7DQotCQkJcnRscHJpdi0+Y2Zn
LT5vcHMtPnNldF9od19yZWcoaHcsIEhXX1ZBUl9SQ1IsDQotCQkJCQkJICAgICAgKHU4ICopKCZy
ZWdfcmNyKSk7DQotCQkJX3J0bDkyY3Vfc2V0X2Jjbl9jdHJsX3JlZyhodywgKEJJVCg0KXxCSVQo
NSkpLCAwKTsNCisJCQlyZWdfcmNyICY9IH5SQ1JfQ0JTU0lEOw0KKwkJCXRtcCA9IEJJVCg0KSB8
IEJJVCg1KTsNCiAJCX0NCisJCXJlZ19yY3IgJj0gKH4oUkNSX0NCU1NJRF9EQVRBIHwgUkNSX0NC
U1NJRF9CQ04pKTsNCisJCXJ0bHByaXYtPmNmZy0+b3BzLT5zZXRfaHdfcmVnKGh3LA0KKwkJCQkJ
ICAgICAgSFdfVkFSX1JDUiwgKHU4ICopICgmcmVnX3JjcikpOw0KKwkJX3J0bDkyY3Vfc2V0X2Jj
bl9jdHJsX3JlZyhodywgdG1wLCAwKTsNCiAJfQ0KIH0NCiANCisvKj09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
ICovDQorDQogaW50IHJ0bDkyY3Vfc2V0X25ldHdvcmtfdHlwZShzdHJ1Y3QgaWVlZTgwMjExX2h3
ICpodywgZW51bSBubDgwMjExX2lmdHlwZSB0eXBlKQ0KIHsNCisJc3RydWN0IHJ0bF9wcml2ICpy
dGxwcml2ID0gcnRsX3ByaXYoaHcpOw0KKw0KIAlpZiAoX3J0bDkyY3Vfc2V0X21lZGlhX3N0YXR1
cyhodywgdHlwZSkpDQogCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQotCV9ydGw5MmN1X3NldF9jaGVj
a19ic3NpZChodywgdHlwZSk7DQorDQorCWlmIChydGxwcml2LT5tYWM4MDIxMS5saW5rX3N0YXRl
ID09IE1BQzgwMjExX0xJTktFRCkgew0KKwkJaWYgKHR5cGUgIT0gTkw4MDIxMV9JRlRZUEVfQVAp
DQorCQkJcnRsOTJjdV9zZXRfY2hlY2tfYnNzaWQoaHcsIHRydWUpOw0KKwl9IGVsc2Ugew0KKwkJ
cnRsOTJjdV9zZXRfY2hlY2tfYnNzaWQoaHcsIGZhbHNlKTsNCisJfQ0KKw0KIAlyZXR1cm4gMDsN
CiB9DQogDQpAQCAtMjIzOCw4ICsyMjIxLDYgQEAgdm9pZCBydGw5MmN1X3VwZGF0ZV9oYWxfcmF0
ZV90YWJsZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywNCiAJCQkgICAgICAgKHNob3J0Z2lfcmF0
ZSA8PCA0KSB8IChzaG9ydGdpX3JhdGUpOw0KIAl9DQogCXJ0bF93cml0ZV9kd29yZChydGxwcml2
LCBSRUdfQVJGUjAgKyByYXRyX2luZGV4ICogNCwgcmF0cl92YWx1ZSk7DQotCVJUX1RSQUNFKHJ0
bHByaXYsIENPTVBfUkFUUiwgREJHX0RNRVNHLCAoIiV4XG4iLCBydGxfcmVhZF9kd29yZChydGxw
cml2LA0KLQkJIFJFR19BUkZSMCkpKTsNCiB9DQogDQogdm9pZCBydGw5MmN1X3VwZGF0ZV9oYWxf
cmF0ZV9tYXNrKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCB1OCByc3NpX2xldmVsKQ0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdHR5L3B0eS5jIGIvZHJpdmVycy90dHkvcHR5LmMNCmluZGV4IGUxODYw
NGIuLmQxOWI4NzkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3R0eS9wdHkuYw0KKysrIGIvZHJpdmVy
cy90dHkvcHR5LmMNCkBAIC00OSw3ICs0OSw2IEBAIHN0YXRpYyB2b2lkIHB0eV9jbG9zZShzdHJ1
Y3QgdHR5X3N0cnVjdCAqdHR5LCBzdHJ1Y3QgZmlsZSAqZmlscCkNCiAJdHR5LT5wYWNrZXQgPSAw
Ow0KIAlpZiAoIXR0eS0+bGluaykNCiAJCXJldHVybjsNCi0JdHR5LT5saW5rLT5wYWNrZXQgPSAw
Ow0KIAlzZXRfYml0KFRUWV9PVEhFUl9DTE9TRUQsICZ0dHktPmxpbmstPmZsYWdzKTsNCiAJd2Fr
ZV91cF9pbnRlcnJ1cHRpYmxlKCZ0dHktPmxpbmstPnJlYWRfd2FpdCk7DQogCXdha2VfdXBfaW50
ZXJydXB0aWJsZSgmdHR5LT5saW5rLT53cml0ZV93YWl0KTsNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3R0eS9zZXJpYWwvc3Vuc3UuYyBiL2RyaXZlcnMvdHR5L3NlcmlhbC9zdW5zdS5jDQppbmRleCBh
ZDBmOGY1Li4yZGM0ZDliIDEwMDY0NA0KLS0tIGEvZHJpdmVycy90dHkvc2VyaWFsL3N1bnN1LmMN
CisrKyBiL2RyaXZlcnMvdHR5L3NlcmlhbC9zdW5zdS5jDQpAQCAtOTY4LDYgKzk2OCw3IEBAIHN0
YXRpYyBzdHJ1Y3QgdWFydF9vcHMgc3Vuc3VfcG9wcyA9IHsNCiAjZGVmaW5lIFVBUlRfTlIJNA0K
IA0KIHN0YXRpYyBzdHJ1Y3QgdWFydF9zdW5zdV9wb3J0IHN1bnN1X3BvcnRzW1VBUlRfTlJdOw0K
K3N0YXRpYyBpbnQgbnJfaW5zdDsgLyogTnVtYmVyIG9mIGFscmVhZHkgcmVnaXN0ZXJlZCBwb3J0
cyAqLw0KIA0KICNpZmRlZiBDT05GSUdfU0VSSU8NCiANCkBAIC0xMzM3LDEzICsxMzM4LDggQEAg
c3RhdGljIGludCBfX2luaXQgc3Vuc3VfY29uc29sZV9zZXR1cChzdHJ1Y3QgY29uc29sZSAqY28s
IGNoYXIgKm9wdGlvbnMpDQogCXByaW50aygiQ29uc29sZTogdHR5UyVkIChTVSlcbiIsDQogCSAg
ICAgICAoc3Vuc3VfcmVnLm1pbm9yIC0gNjQpICsgY28tPmluZGV4KTsNCiANCi0JLyoNCi0JICog
Q2hlY2sgd2hldGhlciBhbiBpbnZhbGlkIHVhcnQgbnVtYmVyIGhhcyBiZWVuIHNwZWNpZmllZCwg
YW5kDQotCSAqIGlmIHNvLCBzZWFyY2ggZm9yIHRoZSBmaXJzdCBhdmFpbGFibGUgcG9ydCB0aGF0
IGRvZXMgaGF2ZQ0KLQkgKiBjb25zb2xlIHN1cHBvcnQuDQotCSAqLw0KLQlpZiAoY28tPmluZGV4
ID49IFVBUlRfTlIpDQotCQljby0+aW5kZXggPSAwOw0KKwlpZiAoY28tPmluZGV4ID4gbnJfaW5z
dCkNCisJCXJldHVybiAtRU5PREVWOw0KIAlwb3J0ID0gJnN1bnN1X3BvcnRzW2NvLT5pbmRleF0u
cG9ydDsNCiANCiAJLyoNCkBAIC0xNDA4LDcgKzE0MDQsNiBAQCBzdGF0aWMgZW51bSBzdV90eXBl
IF9fZGV2aW5pdCBzdV9nZXRfdHlwZShzdHJ1Y3QgZGV2aWNlX25vZGUgKmRwKQ0KIA0KIHN0YXRp
YyBpbnQgX19kZXZpbml0IHN1X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKm9wKQ0KIHsN
Ci0Jc3RhdGljIGludCBpbnN0Ow0KIAlzdHJ1Y3QgZGV2aWNlX25vZGUgKmRwID0gb3AtPmRldi5v
Zl9ub2RlOw0KIAlzdHJ1Y3QgdWFydF9zdW5zdV9wb3J0ICp1cDsNCiAJc3RydWN0IHJlc291cmNl
ICpycDsNCkBAIC0xNDE4LDE2ICsxNDEzLDE2IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IHN1X3By
b2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKm9wKQ0KIA0KIAl0eXBlID0gc3VfZ2V0X3R5cGUo
ZHApOw0KIAlpZiAodHlwZSA9PSBTVV9QT1JUX1BPUlQpIHsNCi0JCWlmIChpbnN0ID49IFVBUlRf
TlIpDQorCQlpZiAobnJfaW5zdCA+PSBVQVJUX05SKQ0KIAkJCXJldHVybiAtRUlOVkFMOw0KLQkJ
dXAgPSAmc3Vuc3VfcG9ydHNbaW5zdF07DQorCQl1cCA9ICZzdW5zdV9wb3J0c1tucl9pbnN0XTsN
CiAJfSBlbHNlIHsNCiAJCXVwID0ga3phbGxvYyhzaXplb2YoKnVwKSwgR0ZQX0tFUk5FTCk7DQog
CQlpZiAoIXVwKQ0KIAkJCXJldHVybiAtRU5PTUVNOw0KIAl9DQogDQotCXVwLT5wb3J0LmxpbmUg
PSBpbnN0Ow0KKwl1cC0+cG9ydC5saW5lID0gbnJfaW5zdDsNCiANCiAJc3Bpbl9sb2NrX2luaXQo
JnVwLT5wb3J0LmxvY2spOw0KIA0KQEAgLTE0NjEsNiArMTQ1Niw4IEBAIHN0YXRpYyBpbnQgX19k
ZXZpbml0IHN1X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKm9wKQ0KIAkJfQ0KIAkJZGV2
X3NldF9kcnZkYXRhKCZvcC0+ZGV2LCB1cCk7DQogDQorCQlucl9pbnN0Kys7DQorDQogCQlyZXR1
cm4gMDsNCiAJfQ0KIA0KQEAgLTE0ODgsNyArMTQ4NSw3IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0
IHN1X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKm9wKQ0KIA0KIAlkZXZfc2V0X2RydmRh
dGEoJm9wLT5kZXYsIHVwKTsNCiANCi0JaW5zdCsrOw0KKwlucl9pbnN0Kys7DQogDQogCXJldHVy
biAwOw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NvcmUvaGNkLXBjaS5jIGIvZHJpdmVy
cy91c2IvY29yZS9oY2QtcGNpLmMNCmluZGV4IDYxZDA4ZGQuLjc2YmUzYmEgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3VzYi9jb3JlL2hjZC1wY2kuYw0KKysrIGIvZHJpdmVycy91c2IvY29yZS9oY2Qt
cGNpLmMNCkBAIC0xNzMsNiArMTczLDcgQEAgaW50IHVzYl9oY2RfcGNpX3Byb2JlKHN0cnVjdCBw
Y2lfZGV2ICpkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICppZCkNCiAJc3RydWN0IGhj
X2RyaXZlcgkqZHJpdmVyOw0KIAlzdHJ1Y3QgdXNiX2hjZAkJKmhjZDsNCiAJaW50CQkJcmV0dmFs
Ow0KKwlpbnQJCQloY2RfaXJxID0gMDsNCiANCiAJaWYgKHVzYl9kaXNhYmxlZCgpKQ0KIAkJcmV0
dXJuIC1FTk9ERVY7DQpAQCAtMTg3LDE1ICsxODgsMTkgQEAgaW50IHVzYl9oY2RfcGNpX3Byb2Jl
KHN0cnVjdCBwY2lfZGV2ICpkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICppZCkNCiAJ
CXJldHVybiAtRU5PREVWOw0KIAlkZXYtPmN1cnJlbnRfc3RhdGUgPSBQQ0lfRDA7DQogDQotCS8q
IFRoZSB4SENJIGRyaXZlciBzdXBwb3J0cyBNU0kgYW5kIE1TSS1YLA0KLQkgKiBzbyBkb24ndCBm
YWlsIGlmIHRoZSBCSU9TIGRvZXNuJ3QgcHJvdmlkZSBhIGxlZ2FjeSBJUlEuDQorCS8qDQorCSAq
IFRoZSB4SENJIGRyaXZlciBoYXMgaXRzIG93biBpcnEgbWFuYWdlbWVudA0KKwkgKiBtYWtlIHN1
cmUgaXJxIHNldHVwIGlzIG5vdCB0b3VjaGVkIGZvciB4aGNpIGluIGdlbmVyaWMgaGNkIGNvZGUN
CiAJICovDQotCWlmICghZGV2LT5pcnEgJiYgKGRyaXZlci0+ZmxhZ3MgJiBIQ0RfTUFTSykgIT0g
SENEX1VTQjMpIHsNCi0JCWRldl9lcnIoJmRldi0+ZGV2LA0KLQkJCSJGb3VuZCBIQyB3aXRoIG5v
IElSUS4gIENoZWNrIEJJT1MvUENJICVzIHNldHVwIVxuIiwNCi0JCQlwY2lfbmFtZShkZXYpKTsN
Ci0JCXJldHZhbCA9IC1FTk9ERVY7DQotCQlnb3RvIGRpc2FibGVfcGNpOw0KKwlpZiAoKGRyaXZl
ci0+ZmxhZ3MgJiBIQ0RfTUFTSykgIT0gSENEX1VTQjMpIHsNCisJCWlmICghZGV2LT5pcnEpIHsN
CisJCQlkZXZfZXJyKCZkZXYtPmRldiwNCisJCQkiRm91bmQgSEMgd2l0aCBubyBJUlEuIENoZWNr
IEJJT1MvUENJICVzIHNldHVwIVxuIiwNCisJCQkJcGNpX25hbWUoZGV2KSk7DQorCQkJcmV0dmFs
ID0gLUVOT0RFVjsNCisJCQlnb3RvIGRpc2FibGVfcGNpOw0KKwkJfQ0KKwkJaGNkX2lycSA9IGRl
di0+aXJxOw0KIAl9DQogDQogCWhjZCA9IHVzYl9jcmVhdGVfaGNkKGRyaXZlciwgJmRldi0+ZGV2
LCBwY2lfbmFtZShkZXYpKTsNCkBAIC0yNDUsNyArMjUwLDcgQEAgaW50IHVzYl9oY2RfcGNpX3By
b2JlKHN0cnVjdCBwY2lfZGV2ICpkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICppZCkN
CiANCiAJcGNpX3NldF9tYXN0ZXIoZGV2KTsNCiANCi0JcmV0dmFsID0gdXNiX2FkZF9oY2QoaGNk
LCBkZXYtPmlycSwgSVJRRl9TSEFSRUQpOw0KKwlyZXR2YWwgPSB1c2JfYWRkX2hjZChoY2QsIGhj
ZF9pcnEsIElSUUZfU0hBUkVEKTsNCiAJaWYgKHJldHZhbCAhPSAwKQ0KIAkJZ290byB1bm1hcF9y
ZWdpc3RlcnM7DQogCXNldF9oc19jb21wYW5pb24oZGV2LCBoY2QpOw0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdXNiL2dhZGdldC91ZGMtY29yZS5jIGIvZHJpdmVycy91c2IvZ2FkZ2V0L3VkYy1jb3Jl
LmMNCmluZGV4IDkwMTkyNGEuLmQ0MzNmZGYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9nYWRn
ZXQvdWRjLWNvcmUuYw0KKysrIGIvZHJpdmVycy91c2IvZ2FkZ2V0L3VkYy1jb3JlLmMNCkBAIC0y
MTMsNyArMjEzLDcgQEAgc3RhdGljIHZvaWQgdXNiX2dhZGdldF9yZW1vdmVfZHJpdmVyKHN0cnVj
dCB1c2JfdWRjICp1ZGMpDQogCQl1ZGMtPmRyaXZlci0+ZGlzY29ubmVjdCh1ZGMtPmdhZGdldCk7
DQogCQl1c2JfZ2FkZ2V0X2Rpc2Nvbm5lY3QodWRjLT5nYWRnZXQpOw0KIAkJdWRjLT5kcml2ZXIt
PnVuYmluZCh1ZGMtPmdhZGdldCk7DQotCQl1c2JfZ2FkZ2V0X3VkY19zdG9wKHVkYy0+Z2FkZ2V0
LCB1ZGMtPmRyaXZlcik7DQorCQl1c2JfZ2FkZ2V0X3VkY19zdG9wKHVkYy0+Z2FkZ2V0LCBOVUxM
KTsNCiAJfSBlbHNlIHsNCiAJCXVzYl9nYWRnZXRfc3RvcCh1ZGMtPmdhZGdldCwgdWRjLT5kcml2
ZXIpOw0KIAl9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvaG9zdC94aGNpLmMgYi9kcml2ZXJz
L3VzYi9ob3N0L3hoY2kuYw0KaW5kZXggNTNjOGJlMS4uMmMwMzUwZiAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvdXNiL2hvc3QveGhjaS5jDQorKysgYi9kcml2ZXJzL3VzYi9ob3N0L3hoY2kuYw0KQEAg
LTM0Miw3ICszNDIsNyBAQCBzdGF0aWMgaW50IHhoY2lfdHJ5X2VuYWJsZV9tc2koc3RydWN0IHVz
Yl9oY2QgKmhjZCkNCiAJICogZ2VuZXJhdGUgaW50ZXJydXB0cy4gIERvbid0IGV2ZW4gdHJ5IHRv
IGVuYWJsZSBNU0kuDQogCSAqLw0KIAlpZiAoeGhjaS0+cXVpcmtzICYgWEhDSV9CUk9LRU5fTVNJ
KQ0KLQkJcmV0dXJuIDA7DQorCQlnb3RvIGxlZ2FjeV9pcnE7DQogDQogCS8qIHVucmVnaXN0ZXIg
dGhlIGxlZ2FjeSBpbnRlcnJ1cHQgKi8NCiAJaWYgKGhjZC0+aXJxKQ0KQEAgLTM2Myw2ICszNjMs
NyBAQCBzdGF0aWMgaW50IHhoY2lfdHJ5X2VuYWJsZV9tc2koc3RydWN0IHVzYl9oY2QgKmhjZCkN
CiAJCXJldHVybiAtRUlOVkFMOw0KIAl9DQogDQorIGxlZ2FjeV9pcnE6DQogCS8qIGZhbGwgYmFj
ayB0byBsZWdhY3kgaW50ZXJydXB0Ki8NCiAJcmV0ID0gcmVxdWVzdF9pcnEocGRldi0+aXJxLCAm
dXNiX2hjZF9pcnEsIElSUUZfU0hBUkVELA0KIAkJCWhjZC0+aXJxX2Rlc2NyLCBoY2QpOw0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS5oIGIvZHJpdmVycy91c2IvaG9zdC94aGNp
LmgNCmluZGV4IGNjMzY4YzIuLmM1MTlhMzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9ob3N0
L3hoY2kuaA0KKysrIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLmgNCkBAIC0yMDYsOCArMjA2LDgg
QEAgc3RydWN0IHhoY2lfb3BfcmVncyB7DQogLyogYml0cyAxMjozMSBhcmUgcmVzZXJ2ZWQgKGFu
ZCBzaG91bGQgYmUgcHJlc2VydmVkIG9uIHdyaXRlcykuICovDQogDQogLyogSU1BTiAtIEludGVy
cnVwdCBNYW5hZ2VtZW50IFJlZ2lzdGVyICovDQotI2RlZmluZSBJTUFOX0lQCQkoMSA8PCAxKQ0K
LSNkZWZpbmUgSU1BTl9JRQkJKDEgPDwgMCkNCisjZGVmaW5lIElNQU5fSUUJCSgxIDw8IDEpDQor
I2RlZmluZSBJTUFOX0lQCQkoMSA8PCAwKQ0KIA0KIC8qIFVTQlNUUyAtIFVTQiBzdGF0dXMgLSBz
dGF0dXMgYml0bWFza3MgKi8NCiAvKiBIQyBub3QgcnVubmluZyAtIHNldCB0byAxIHdoZW4gcnVu
L3N0b3AgYml0IGlzIGNsZWFyZWQuICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2VyaWFs
L2dhcm1pbl9ncHMuYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9nYXJtaW5fZ3BzLmMNCmluZGV4IDFh
NDljYTkuLmU2NjRiYWMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvZ2FybWluX2dw
cy5jDQorKysgYi9kcml2ZXJzL3VzYi9zZXJpYWwvZ2FybWluX2dwcy5jDQpAQCAtOTczLDEwICs5
NzMsNyBAQCBzdGF0aWMgdm9pZCBnYXJtaW5fY2xvc2Uoc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAq
cG9ydCkNCiAJaWYgKCFzZXJpYWwpDQogCQlyZXR1cm47DQogDQotCW11dGV4X2xvY2soJnBvcnQt
PnNlcmlhbC0+ZGlzY19tdXRleCk7DQotDQotCWlmICghcG9ydC0+c2VyaWFsLT5kaXNjb25uZWN0
ZWQpDQotCQlnYXJtaW5fY2xlYXIoZ2FybWluX2RhdGFfcCk7DQorCWdhcm1pbl9jbGVhcihnYXJt
aW5fZGF0YV9wKTsNCiANCiAJLyogc2h1dGRvd24gb3VyIHVyYnMgKi8NCiAJdXNiX2tpbGxfdXJi
KHBvcnQtPnJlYWRfdXJiKTsNCkBAIC05ODUsOCArOTgyLDYgQEAgc3RhdGljIHZvaWQgZ2FybWlu
X2Nsb3NlKHN0cnVjdCB1c2Jfc2VyaWFsX3BvcnQgKnBvcnQpDQogCS8qIGtlZXAgcmVzZXQgc3Rh
dGUgc28gd2Uga25vdyB0aGF0IHdlIG11c3Qgc3RhcnQgYSBuZXcgc2Vzc2lvbiAqLw0KIAlpZiAo
Z2FybWluX2RhdGFfcC0+c3RhdGUgIT0gU1RBVEVfUkVTRVQpDQogCQlnYXJtaW5fZGF0YV9wLT5z
dGF0ZSA9IFNUQVRFX0RJU0NPTk5FQ1RFRDsNCi0NCi0JbXV0ZXhfdW5sb2NrKCZwb3J0LT5zZXJp
YWwtPmRpc2NfbXV0ZXgpOw0KIH0NCiANCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJp
YWwvaW9fdGkuYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9pb190aS5jDQppbmRleCAzZGU3NTFkLi4x
ZjE0NWJmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL2lvX3RpLmMNCisrKyBiL2Ry
aXZlcnMvdXNiL3NlcmlhbC9pb190aS5jDQpAQCAtMjc5Niw2ICsyNzk2LDcgQEAgc3RhdGljIHN0
cnVjdCB1c2Jfc2VyaWFsX2RyaXZlciBlZGdlcG9ydF8ycG9ydF9kZXZpY2UgPSB7DQogCS5zZXRf
dGVybWlvcwkJPSBlZGdlX3NldF90ZXJtaW9zLA0KIAkudGlvY21nZXQJCT0gZWRnZV90aW9jbWdl
dCwNCiAJLnRpb2Ntc2V0CQk9IGVkZ2VfdGlvY21zZXQsDQorCS5nZXRfaWNvdW50CQk9IGVkZ2Vf
Z2V0X2ljb3VudCwNCiAJLndyaXRlCQkJPSBlZGdlX3dyaXRlLA0KIAkud3JpdGVfcm9vbQkJPSBl
ZGdlX3dyaXRlX3Jvb20sDQogCS5jaGFyc19pbl9idWZmZXIJPSBlZGdlX2NoYXJzX2luX2J1ZmZl
ciwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJpYWwvdXNiLXNlcmlhbC5jIGIvZHJpdmVy
cy91c2Ivc2VyaWFsL3VzYi1zZXJpYWwuYw0KaW5kZXggZGMxY2U2Mi4uMjQ4MmQ1ZSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC91c2Itc2VyaWFsLmMNCisrKyBiL2RyaXZlcnMvdXNi
L3NlcmlhbC91c2Itc2VyaWFsLmMNCkBAIC0xNjgsNiArMTY4LDcgQEAgc3RhdGljIHZvaWQgZGVz
dHJveV9zZXJpYWwoc3RydWN0IGtyZWYgKmtyZWYpDQogCQl9DQogCX0NCiANCisJdXNiX3B1dF9p
bnRmKHNlcmlhbC0+aW50ZXJmYWNlKTsNCiAJdXNiX3B1dF9kZXYoc2VyaWFsLT5kZXYpOw0KIAlr
ZnJlZShzZXJpYWwpOw0KIH0NCkBAIC02MjQsNyArNjI1LDcgQEAgc3RhdGljIHN0cnVjdCB1c2Jf
c2VyaWFsICpjcmVhdGVfc2VyaWFsKHN0cnVjdCB1c2JfZGV2aWNlICpkZXYsDQogCX0NCiAJc2Vy
aWFsLT5kZXYgPSB1c2JfZ2V0X2RldihkZXYpOw0KIAlzZXJpYWwtPnR5cGUgPSBkcml2ZXI7DQot
CXNlcmlhbC0+aW50ZXJmYWNlID0gaW50ZXJmYWNlOw0KKwlzZXJpYWwtPmludGVyZmFjZSA9IHVz
Yl9nZXRfaW50ZihpbnRlcmZhY2UpOw0KIAlrcmVmX2luaXQoJnNlcmlhbC0+a3JlZik7DQogCW11
dGV4X2luaXQoJnNlcmlhbC0+ZGlzY19tdXRleCk7DQogCXNlcmlhbC0+bWlub3IgPSBTRVJJQUxf
VFRZX05PX01JTk9SOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdW51c3VhbF9k
ZXZzLmggYi9kcml2ZXJzL3VzYi9zdG9yYWdlL3VudXN1YWxfZGV2cy5oDQppbmRleCBmYThhMWIy
Li43YjhkNTY0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc3RvcmFnZS91bnVzdWFsX2RldnMu
aA0KKysrIGIvZHJpdmVycy91c2Ivc3RvcmFnZS91bnVzdWFsX2RldnMuaA0KQEAgLTQ4OCw2ICs0
ODgsMTMgQEAgVU5VU1VBTF9ERVYoICAweDA0ZTgsIDB4NTEyMiwgMHgwMDAwLCAweDk5OTksDQog
CQlVU0JfU0NfREVWSUNFLCBVU0JfUFJfREVWSUNFLCBOVUxMLA0KIAkJVVNfRkxfTUFYX1NFQ1RP
UlNfNjQgfCBVU19GTF9CVUxLX0lHTk9SRV9UQUcpLA0KIA0KKy8qIEFkZGVkIGJ5IERtaXRyeSBB
cnRhbW9ub3cgPG1hZF9zb2Z0QGluYm94LnJ1PiAqLw0KK1VOVVNVQUxfREVWKCAgMHgwNGU4LCAw
eDUxMzYsIDB4MDAwMCwgMHg5OTk5LA0KKwkJIlNhbXN1bmciLA0KKwkJIllQLVozIiwNCisJCVVT
Ql9TQ19ERVZJQ0UsIFVTQl9QUl9ERVZJQ0UsIE5VTEwsDQorCQlVU19GTF9NQVhfU0VDVE9SU182
NCksDQorDQogLyogRW50cnkgYW5kIHN1cHBvcnRpbmcgcGF0Y2ggYnkgVGhlb2RvcmUgS2lsZ29y
ZSA8a2lsZ290YUBhdWJ1cm4uZWR1Pi4NCiAgKiBEZXZpY2UgdXNlcyBzdGFuZGFyZHMtdmlvbGF0
aW5nIDMyLWJ5dGUgQnVsayBDb21tYW5kIEJsb2NrIFdyYXBwZXJzIGFuZA0KICAqIHJlcG9ydHMg
aXRzZWxmIGFzICJQcm9wcmlldGFyeSBTQ1NJIEJ1bGsuIiBDZi4gZGV2aWNlIGVudHJ5IDB4MDg0
ZDoweDAwMTEuDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy92aG9zdC9uZXQuYyBiL2RyaXZlcnMvdmhv
c3QvbmV0LmMNCmluZGV4IGI3NjA3MWUuLjVjNTgxMjggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Zo
b3N0L25ldC5jDQorKysgYi9kcml2ZXJzL3Zob3N0L25ldC5jDQpAQCAtMjM0LDcgKzIzNCw4IEBA
IHN0YXRpYyB2b2lkIGhhbmRsZV90eChzdHJ1Y3Qgdmhvc3RfbmV0ICpuZXQpDQogCQkJCW1zZy5t
c2dfY29udHJvbGxlbiA9IDA7DQogCQkJCXVidWZzID0gTlVMTDsNCiAJCQl9IGVsc2Ugew0KLQkJ
CQlzdHJ1Y3QgdWJ1Zl9pbmZvICp1YnVmID0gJnZxLT51YnVmX2luZm9baGVhZF07DQorCQkJCXN0
cnVjdCB1YnVmX2luZm8gKnVidWY7DQorCQkJCXVidWYgPSB2cS0+dWJ1Zl9pbmZvICsgdnEtPnVw
ZW5kX2lkeDsNCiANCiAJCQkJdnEtPmhlYWRzW3ZxLT51cGVuZF9pZHhdLmxlbiA9IGxlbjsNCiAJ
CQkJdWJ1Zi0+Y2FsbGJhY2sgPSB2aG9zdF96ZXJvY29weV9jYWxsYmFjazsNCmRpZmYgLS1naXQg
YS9mcy9jaWZzL2FzbjEuYyBiL2ZzL2NpZnMvYXNuMS5jDQppbmRleCBjZmQxY2UzLi4xZDM2ZGIx
IDEwMDY0NA0KLS0tIGEvZnMvY2lmcy9hc24xLmMNCisrKyBiL2ZzL2NpZnMvYXNuMS5jDQpAQCAt
NjE0LDUzICs2MTQsMTAgQEAgZGVjb2RlX25lZ1Rva2VuSW5pdCh1bnNpZ25lZCBjaGFyICpzZWN1
cml0eV9ibG9iLCBpbnQgbGVuZ3RoLA0KIAkJfQ0KIAl9DQogDQotCS8qIG1lY2hsaXN0TUlDICov
DQotCWlmIChhc24xX2hlYWRlcl9kZWNvZGUoJmN0eCwgJmVuZCwgJmNscywgJmNvbiwgJnRhZykg
PT0gMCkgew0KLQkJLyogQ2hlY2sgaWYgd2UgaGF2ZSByZWFjaGVkIHRoZSBlbmQgb2YgdGhlIGJs
b2IsIGJ1dCB3aXRoDQotCQkgICBubyBtZWNoTGlzdE1pYyAoZS5nLiBOVExNU1NQIGluc3RlYWQg
b2YgS1JCNSkgKi8NCi0JCWlmIChjdHguZXJyb3IgPT0gQVNOMV9FUlJfREVDX0VNUFRZKQ0KLQkJ
CWdvdG8gZGVjb2RlX25lZ3Rva2VuX2V4aXQ7DQotCQljRllJKDEsICJFcnJvciBkZWNvZGluZyBs
YXN0IHBhcnQgbmVnVG9rZW5Jbml0IGV4aXQzIik7DQotCQlyZXR1cm4gMDsNCi0JfSBlbHNlIGlm
ICgoY2xzICE9IEFTTjFfQ1RYKSB8fCAoY29uICE9IEFTTjFfQ09OKSkgew0KLQkJLyogdGFnID0g
MyBpbmRpY2F0aW5nIG1lY2hMaXN0TUlDICovDQotCQljRllJKDEsICJFeGl0IDQgY2xzID0gJWQg
Y29uID0gJWQgdGFnID0gJWQgZW5kID0gJXAgKCVkKSIsDQotCQkJY2xzLCBjb24sIHRhZywgZW5k
LCAqZW5kKTsNCi0JCXJldHVybiAwOw0KLQl9DQotDQotCS8qIHNlcXVlbmNlICovDQotCWlmIChh
c24xX2hlYWRlcl9kZWNvZGUoJmN0eCwgJmVuZCwgJmNscywgJmNvbiwgJnRhZykgPT0gMCkgew0K
LQkJY0ZZSSgxLCAiRXJyb3IgZGVjb2RpbmcgbGFzdCBwYXJ0IG5lZ1Rva2VuSW5pdCBleGl0NSIp
Ow0KLQkJcmV0dXJuIDA7DQotCX0gZWxzZSBpZiAoKGNscyAhPSBBU04xX1VOSSkgfHwgKGNvbiAh
PSBBU04xX0NPTikNCi0JCSAgIHx8ICh0YWcgIT0gQVNOMV9TRVEpKSB7DQotCQljRllJKDEsICJj
bHMgPSAlZCBjb24gPSAlZCB0YWcgPSAlZCBlbmQgPSAlcCAoJWQpIiwNCi0JCQljbHMsIGNvbiwg
dGFnLCBlbmQsICplbmQpOw0KLQl9DQotDQotCS8qIHNlcXVlbmNlIG9mICovDQotCWlmIChhc24x
X2hlYWRlcl9kZWNvZGUoJmN0eCwgJmVuZCwgJmNscywgJmNvbiwgJnRhZykgPT0gMCkgew0KLQkJ
Y0ZZSSgxLCAiRXJyb3IgZGVjb2RpbmcgbGFzdCBwYXJ0IG5lZ1Rva2VuSW5pdCBleGl0IDciKTsN
Ci0JCXJldHVybiAwOw0KLQl9IGVsc2UgaWYgKChjbHMgIT0gQVNOMV9DVFgpIHx8IChjb24gIT0g
QVNOMV9DT04pKSB7DQotCQljRllJKDEsICJFeGl0IDggY2xzID0gJWQgY29uID0gJWQgdGFnID0g
JWQgZW5kID0gJXAgKCVkKSIsDQotCQkJY2xzLCBjb24sIHRhZywgZW5kLCAqZW5kKTsNCi0JCXJl
dHVybiAwOw0KLQl9DQotDQotCS8qIGdlbmVyYWwgc3RyaW5nICovDQotCWlmIChhc24xX2hlYWRl
cl9kZWNvZGUoJmN0eCwgJmVuZCwgJmNscywgJmNvbiwgJnRhZykgPT0gMCkgew0KLQkJY0ZZSSgx
LCAiRXJyb3IgZGVjb2RpbmcgbGFzdCBwYXJ0IG5lZ1Rva2VuSW5pdCBleGl0OSIpOw0KLQkJcmV0
dXJuIDA7DQotCX0gZWxzZSBpZiAoKGNscyAhPSBBU04xX1VOSSkgfHwgKGNvbiAhPSBBU04xX1BS
SSkNCi0JCSAgIHx8ICh0YWcgIT0gQVNOMV9HRU5TVFIpKSB7DQotCQljRllJKDEsICJFeGl0MTAg
Y2xzID0gJWQgY29uID0gJWQgdGFnID0gJWQgZW5kID0gJXAgKCVkKSIsDQotCQkJY2xzLCBjb24s
IHRhZywgZW5kLCAqZW5kKTsNCi0JCXJldHVybiAwOw0KLQl9DQotCWNGWUkoMSwgIk5lZWQgdG8g
Y2FsbCBhc24xX29jdGV0c19kZWNvZGUoKSBmdW5jdGlvbiBmb3IgJXMiLA0KLQkJY3R4LnBvaW50
ZXIpOwkvKiBpcyB0aGlzIFVURi04IG9yIEFTQ0lJPyAqLw0KLWRlY29kZV9uZWd0b2tlbl9leGl0
Og0KKwkvKg0KKwkgKiBXZSBjdXJyZW50bHkgaWdub3JlIGFueXRoaW5nIGF0IHRoZSBlbmQgb2Yg
dGhlIFNQTkVHTyBibG9iIGFmdGVyDQorCSAqIHRoZSBtZWNoVHlwZXMgaGF2ZSBiZWVuIHBhcnNl
ZCwgc2luY2Ugbm9uZSBvZiB0aGF0IGluZm8gaXMNCisJICogdXNlZCBhdCB0aGUgbW9tZW50Lg0K
KwkgKi8NCiAJcmV0dXJuIDE7DQogfQ0KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2ZzLmMgYi9m
cy9jaWZzL2NpZnNmcy5jDQppbmRleCBiM2EyYTQwLi4yNWJiOTdmIDEwMDY0NA0KLS0tIGEvZnMv
Y2lmcy9jaWZzZnMuYw0KKysrIGIvZnMvY2lmcy9jaWZzZnMuYw0KQEAgLTkwLDYgKzkwLDMwIEBA
IGV4dGVybiBtZW1wb29sX3QgKmNpZnNfc21fcmVxX3Bvb2xwOw0KIGV4dGVybiBtZW1wb29sX3Qg
KmNpZnNfcmVxX3Bvb2xwOw0KIGV4dGVybiBtZW1wb29sX3QgKmNpZnNfbWlkX3Bvb2xwOw0KIA0K
Ky8qDQorICogQnVtcHMgcmVmY291bnQgZm9yIGNpZnMgc3VwZXIgYmxvY2suDQorICogTm90ZSB0
aGF0IGl0IHNob3VsZCBiZSBvbmx5IGNhbGxlZCBpZiBhIHJlZmVyZWNlIHRvIFZGUyBzdXBlciBi
bG9jayBpcw0KKyAqIGFscmVhZHkgaGVsZCwgZS5nLiBpbiBvcGVuLXR5cGUgc3lzY2FsbHMgY29u
dGV4dC4gT3RoZXJ3aXNlIGl0IGNhbiByYWNlIHdpdGgNCisgKiBhdG9taWNfZGVjX2FuZF90ZXN0
IGluIGRlYWN0aXZhdGVfbG9ja2VkX3N1cGVyLg0KKyAqLw0KK3ZvaWQNCitjaWZzX3NiX2FjdGl2
ZShzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQ0KK3sNCisJc3RydWN0IGNpZnNfc2JfaW5mbyAqc2Vy
dmVyID0gQ0lGU19TQihzYik7DQorDQorCWlmIChhdG9taWNfaW5jX3JldHVybigmc2VydmVyLT5h
Y3RpdmUpID09IDEpDQorCQlhdG9taWNfaW5jKCZzYi0+c19hY3RpdmUpOw0KK30NCisNCit2b2lk
DQorY2lmc19zYl9kZWFjdGl2ZShzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQ0KK3sNCisJc3RydWN0
IGNpZnNfc2JfaW5mbyAqc2VydmVyID0gQ0lGU19TQihzYik7DQorDQorCWlmIChhdG9taWNfZGVj
X2FuZF90ZXN0KCZzZXJ2ZXItPmFjdGl2ZSkpDQorCQlkZWFjdGl2YXRlX3N1cGVyKHNiKTsNCit9
DQorDQogc3RhdGljIGludA0KIGNpZnNfcmVhZF9zdXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNi
KQ0KIHsNCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5oIGIvZnMvY2lmcy9jaWZzZnMuaA0K
aW5kZXggMzBmZjU2MC4uYzkxZWE4MSAxMDA2NDQNCi0tLSBhL2ZzL2NpZnMvY2lmc2ZzLmgNCisr
KyBiL2ZzL2NpZnMvY2lmc2ZzLmgNCkBAIC00MSw2ICs0MSwxMCBAQCBleHRlcm4gc3RydWN0IGZp
bGVfc3lzdGVtX3R5cGUgY2lmc19mc190eXBlOw0KIGV4dGVybiBjb25zdCBzdHJ1Y3QgYWRkcmVz
c19zcGFjZV9vcGVyYXRpb25zIGNpZnNfYWRkcl9vcHM7DQogZXh0ZXJuIGNvbnN0IHN0cnVjdCBh
ZGRyZXNzX3NwYWNlX29wZXJhdGlvbnMgY2lmc19hZGRyX29wc19zbWFsbGJ1ZjsNCiANCisvKiBG
dW5jdGlvbnMgcmVsYXRlZCB0byBzdXBlciBibG9jayBvcGVyYXRpb25zICovDQorZXh0ZXJuIHZv
aWQgY2lmc19zYl9hY3RpdmUoc3RydWN0IHN1cGVyX2Jsb2NrICpzYik7DQorZXh0ZXJuIHZvaWQg
Y2lmc19zYl9kZWFjdGl2ZShzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKTsNCisNCiAvKiBGdW5jdGlv
bnMgcmVsYXRlZCB0byBpbm9kZXMgKi8NCiBleHRlcm4gY29uc3Qgc3RydWN0IGlub2RlX29wZXJh
dGlvbnMgY2lmc19kaXJfaW5vZGVfb3BzOw0KIGV4dGVybiBzdHJ1Y3QgaW5vZGUgKmNpZnNfcm9v
dF9pZ2V0KHN0cnVjdCBzdXBlcl9ibG9jayAqKTsNCmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZpbGUu
YyBiL2ZzL2NpZnMvZmlsZS5jDQppbmRleCA1MTU3NGQ0Li5jNTU4MDhlIDEwMDY0NA0KLS0tIGEv
ZnMvY2lmcy9maWxlLmMNCisrKyBiL2ZzL2NpZnMvZmlsZS5jDQpAQCAtMjY1LDYgKzI2NSw4IEBA
IGNpZnNfbmV3X2ZpbGVpbmZvKF9fdTE2IGZpbGVIYW5kbGUsIHN0cnVjdCBmaWxlICpmaWxlLA0K
IAltdXRleF9pbml0KCZwQ2lmc0ZpbGUtPmZoX211dGV4KTsNCiAJSU5JVF9XT1JLKCZwQ2lmc0Zp
bGUtPm9wbG9ja19icmVhaywgY2lmc19vcGxvY2tfYnJlYWspOw0KIA0KKwljaWZzX3NiX2FjdGl2
ZShpbm9kZS0+aV9zYik7DQorDQogCXNwaW5fbG9jaygmY2lmc19maWxlX2xpc3RfbG9jayk7DQog
CWxpc3RfYWRkKCZwQ2lmc0ZpbGUtPnRsaXN0LCAmKHRsaW5rX3Rjb24odGxpbmspLT5vcGVuRmls
ZUxpc3QpKTsNCiAJLyogaWYgcmVhZGFibGUgZmlsZSBpbnN0YW5jZSBwdXQgZmlyc3QgaW4gbGlz
dCovDQpAQCAtMjkzLDcgKzI5NSw4IEBAIHZvaWQgY2lmc0ZpbGVJbmZvX3B1dChzdHJ1Y3QgY2lm
c0ZpbGVJbmZvICpjaWZzX2ZpbGUpDQogCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBjaWZzX2ZpbGUt
PmRlbnRyeS0+ZF9pbm9kZTsNCiAJc3RydWN0IGNpZnNfdGNvbiAqdGNvbiA9IHRsaW5rX3Rjb24o
Y2lmc19maWxlLT50bGluayk7DQogCXN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaWZzaSA9IENJRlNf
SShpbm9kZSk7DQotCXN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IgPSBDSUZTX1NCKGlub2Rl
LT5pX3NiKTsNCisJc3RydWN0IHN1cGVyX2Jsb2NrICpzYiA9IGlub2RlLT5pX3NiOw0KKwlzdHJ1
Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiID0gQ0lGU19TQihzYik7DQogCXN0cnVjdCBjaWZzTG9j
a0luZm8gKmxpLCAqdG1wOw0KIA0KIAlzcGluX2xvY2soJmNpZnNfZmlsZV9saXN0X2xvY2spOw0K
QEAgLTM0NSw2ICszNDgsNyBAQCB2b2lkIGNpZnNGaWxlSW5mb19wdXQoc3RydWN0IGNpZnNGaWxl
SW5mbyAqY2lmc19maWxlKQ0KIA0KIAljaWZzX3B1dF90bGluayhjaWZzX2ZpbGUtPnRsaW5rKTsN
CiAJZHB1dChjaWZzX2ZpbGUtPmRlbnRyeSk7DQorCWNpZnNfc2JfZGVhY3RpdmUoc2IpOw0KIAlr
ZnJlZShjaWZzX2ZpbGUpOw0KIH0NCiANCmRpZmYgLS1naXQgYS9mcy9leHQ0L2JhbGxvYy5jIGIv
ZnMvZXh0NC9iYWxsb2MuYw0KaW5kZXggNDg0ZmZlZS4uMjg0NWExZiAxMDA2NDQNCi0tLSBhL2Zz
L2V4dDQvYmFsbG9jLmMNCisrKyBiL2ZzL2V4dDQvYmFsbG9jLmMNCkBAIC01NzEsNyArNTcxLDcg
QEAgZXh0NF9mc2Jsa190IGV4dDRfY291bnRfZnJlZV9jbHVzdGVycyhzdHJ1Y3Qgc3VwZXJfYmxv
Y2sgKnNiKQ0KIAlicmVsc2UoYml0bWFwX2JoKTsNCiAJcHJpbnRrKEtFUk5fREVCVUcgImV4dDRf
Y291bnRfZnJlZV9jbHVzdGVyczogc3RvcmVkID0gJWxsdSINCiAJICAgICAgICIsIGNvbXB1dGVk
ID0gJWxsdSwgJWxsdVxuIiwNCi0JICAgICAgIEVYVDRfQjJDKEVYVDRfU0Ioc2IpLCBleHQ0X2Zy
ZWVfYmxvY2tzX2NvdW50KGVzKSksDQorCSAgICAgICBFWFQ0X05VTV9CMkMoRVhUNF9TQihzYiks
IGV4dDRfZnJlZV9ibG9ja3NfY291bnQoZXMpKSwNCiAJICAgICAgIGRlc2NfY291bnQsIGJpdG1h
cF9jb3VudCk7DQogCXJldHVybiBiaXRtYXBfY291bnQ7DQogI2Vsc2UNCmRpZmYgLS1naXQgYS9m
cy9leHQ0L2V4dDQuaCBiL2ZzL2V4dDQvZXh0NC5oDQppbmRleCA4Y2IxODRjLi42MGI2Y2E1IDEw
MDY0NA0KLS0tIGEvZnMvZXh0NC9leHQ0LmgNCisrKyBiL2ZzL2V4dDQvZXh0NC5oDQpAQCAtMzA5
LDkgKzMwOSw5IEBAIHN0cnVjdCBleHQ0X2dyb3VwX2Rlc2MNCiAgKi8NCiANCiBzdHJ1Y3QgZmxl
eF9ncm91cHMgew0KLQlhdG9taWNfdCBmcmVlX2lub2RlczsNCi0JYXRvbWljX3QgZnJlZV9jbHVz
dGVyczsNCi0JYXRvbWljX3QgdXNlZF9kaXJzOw0KKwlhdG9taWM2NF90CWZyZWVfY2x1c3RlcnM7
DQorCWF0b21pY190CWZyZWVfaW5vZGVzOw0KKwlhdG9taWNfdAl1c2VkX2RpcnM7DQogfTsNCiAN
CiAjZGVmaW5lIEVYVDRfQkdfSU5PREVfVU5JTklUCTB4MDAwMSAvKiBJbm9kZSB0YWJsZS9iaXRt
YXAgbm90IGluIHVzZSAqLw0KZGlmZiAtLWdpdCBhL2ZzL2V4dDQvZXh0ZW50cy5jIGIvZnMvZXh0
NC9leHRlbnRzLmMNCmluZGV4IGI0OGUwZGMuLmNlMGJjMjUgMTAwNjQ0DQotLS0gYS9mcy9leHQ0
L2V4dGVudHMuYw0KKysrIGIvZnMvZXh0NC9leHRlbnRzLmMNCkBAIC0yOTYwLDYgKzI5NjAsNyBA
QCBzdGF0aWMgaW50IGV4dDRfc3BsaXRfZXh0ZW50KGhhbmRsZV90ICpoYW5kbGUsDQogCWludCBl
cnIgPSAwOw0KIAlpbnQgdW5pbml0aWFsaXplZDsNCiAJaW50IHNwbGl0X2ZsYWcxLCBmbGFnczE7
DQorCWludCBhbGxvY2F0ZWQgPSBtYXAtPm1fbGVuOw0KIA0KIAlkZXB0aCA9IGV4dF9kZXB0aChp
bm9kZSk7DQogCWV4ID0gcGF0aFtkZXB0aF0ucF9leHQ7DQpAQCAtMjk3OSw2ICsyOTgwLDggQEAg
c3RhdGljIGludCBleHQ0X3NwbGl0X2V4dGVudChoYW5kbGVfdCAqaGFuZGxlLA0KIAkJCQltYXAt
Pm1fbGJsayArIG1hcC0+bV9sZW4sIHNwbGl0X2ZsYWcxLCBmbGFnczEpOw0KIAkJaWYgKGVycikN
CiAJCQlnb3RvIG91dDsNCisJfSBlbHNlIHsNCisJCWFsbG9jYXRlZCA9IGVlX2xlbiAtIChtYXAt
Pm1fbGJsayAtIGVlX2Jsb2NrKTsNCiAJfQ0KIA0KIAlleHQ0X2V4dF9kcm9wX3JlZnMocGF0aCk7
DQpAQCAtMzAwMSw3ICszMDA0LDcgQEAgc3RhdGljIGludCBleHQ0X3NwbGl0X2V4dGVudChoYW5k
bGVfdCAqaGFuZGxlLA0KIA0KIAlleHQ0X2V4dF9zaG93X2xlYWYoaW5vZGUsIHBhdGgpOw0KIG91
dDoNCi0JcmV0dXJuIGVyciA/IGVyciA6IG1hcC0+bV9sZW47DQorCXJldHVybiBlcnIgPyBlcnIg
OiBhbGxvY2F0ZWQ7DQogfQ0KIA0KICNkZWZpbmUgRVhUNF9FWFRfWkVST19MRU4gNw0KQEAgLTM2
NjMsNiArMzY2Niw3IEBAIG91dDoNCiAJCQkJCWFsbG9jYXRlZCAtIG1hcC0+bV9sZW4pOw0KIAkJ
YWxsb2NhdGVkID0gbWFwLT5tX2xlbjsNCiAJfQ0KKwltYXAtPm1fbGVuID0gYWxsb2NhdGVkOw0K
IA0KIAkvKg0KIAkgKiBJZiB3ZSBoYXZlIGRvbmUgZmFsbG9jYXRlIHdpdGggdGhlIG9mZnNldCB0
aGF0IGlzIGFscmVhZHkNCmRpZmYgLS1naXQgYS9mcy9leHQ0L2lhbGxvYy5jIGIvZnMvZXh0NC9p
YWxsb2MuYw0KaW5kZXggNjI2Njc5OS4uNmQxZjU3NyAxMDA2NDQNCi0tLSBhL2ZzL2V4dDQvaWFs
bG9jLmMNCisrKyBiL2ZzL2V4dDQvaWFsbG9jLmMNCkBAIC0yOTQsOCArMjk0LDggQEAgZXJyb3Jf
cmV0dXJuOg0KIH0NCiANCiBzdHJ1Y3Qgb3Jsb3Zfc3RhdHMgew0KKwlfX3U2NCBmcmVlX2NsdXN0
ZXJzOw0KIAlfX3UzMiBmcmVlX2lub2RlczsNCi0JX191MzIgZnJlZV9jbHVzdGVyczsNCiAJX191
MzIgdXNlZF9kaXJzOw0KIH07DQogDQpAQCAtMzEyLDcgKzMxMiw3IEBAIHN0YXRpYyB2b2lkIGdl
dF9vcmxvdl9zdGF0cyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBleHQ0X2dyb3VwX3QgZywNCiAN
CiAJaWYgKGZsZXhfc2l6ZSA+IDEpIHsNCiAJCXN0YXRzLT5mcmVlX2lub2RlcyA9IGF0b21pY19y
ZWFkKCZmbGV4X2dyb3VwW2ddLmZyZWVfaW5vZGVzKTsNCi0JCXN0YXRzLT5mcmVlX2NsdXN0ZXJz
ID0gYXRvbWljX3JlYWQoJmZsZXhfZ3JvdXBbZ10uZnJlZV9jbHVzdGVycyk7DQorCQlzdGF0cy0+
ZnJlZV9jbHVzdGVycyA9IGF0b21pYzY0X3JlYWQoJmZsZXhfZ3JvdXBbZ10uZnJlZV9jbHVzdGVy
cyk7DQogCQlzdGF0cy0+dXNlZF9kaXJzID0gYXRvbWljX3JlYWQoJmZsZXhfZ3JvdXBbZ10udXNl
ZF9kaXJzKTsNCiAJCXJldHVybjsNCiAJfQ0KZGlmZiAtLWdpdCBhL2ZzL2V4dDQvaW5vZGUuYyBi
L2ZzL2V4dDQvaW5vZGUuYw0KaW5kZXggNGIyYmI3NS4uMzI3MGZmZCAxMDA2NDQNCi0tLSBhL2Zz
L2V4dDQvaW5vZGUuYw0KKysrIGIvZnMvZXh0NC9pbm9kZS5jDQpAQCAtMTQyLDcgKzE0Miw4IEBA
IHZvaWQgZXh0NF9ldmljdF9pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQ0KIAkJICogZG9uJ3Qg
dXNlIHBhZ2UgY2FjaGUuDQogCQkgKi8NCiAJCWlmIChleHQ0X3Nob3VsZF9qb3VybmFsX2RhdGEo
aW5vZGUpICYmDQotCQkgICAgKFNfSVNMTksoaW5vZGUtPmlfbW9kZSkgfHwgU19JU1JFRyhpbm9k
ZS0+aV9tb2RlKSkpIHsNCisJCSAgICAoU19JU0xOSyhpbm9kZS0+aV9tb2RlKSB8fCBTX0lTUkVH
KGlub2RlLT5pX21vZGUpKSAmJg0KKwkJICAgIGlub2RlLT5pX2lubyAhPSBFWFQ0X0pPVVJOQUxf
SU5PKSB7DQogCQkJam91cm5hbF90ICpqb3VybmFsID0gRVhUNF9TQihpbm9kZS0+aV9zYiktPnNf
am91cm5hbDsNCiAJCQl0aWRfdCBjb21taXRfdGlkID0gRVhUNF9JKGlub2RlKS0+aV9kYXRhc3lu
Y190aWQ7DQogDQpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9tYmFsbG9jLmMgYi9mcy9leHQ0L21iYWxs
b2MuYw0KaW5kZXggNTUzZmY3MS4uN2IxODU2MyAxMDA2NDQNCi0tLSBhL2ZzL2V4dDQvbWJhbGxv
Yy5jDQorKysgYi9mcy9leHQ0L21iYWxsb2MuYw0KQEAgLTI4NjYsOCArMjg2Niw4IEBAIGV4dDRf
bWJfbWFya19kaXNrc3BhY2VfdXNlZChzdHJ1Y3QgZXh0NF9hbGxvY2F0aW9uX2NvbnRleHQgKmFj
LA0KIAlpZiAoc2JpLT5zX2xvZ19ncm91cHNfcGVyX2ZsZXgpIHsNCiAJCWV4dDRfZ3JvdXBfdCBm
bGV4X2dyb3VwID0gZXh0NF9mbGV4X2dyb3VwKHNiaSwNCiAJCQkJCQkJICBhYy0+YWNfYl9leC5m
ZV9ncm91cCk7DQotCQlhdG9taWNfc3ViKGFjLT5hY19iX2V4LmZlX2xlbiwNCi0JCQkgICAmc2Jp
LT5zX2ZsZXhfZ3JvdXBzW2ZsZXhfZ3JvdXBdLmZyZWVfY2x1c3RlcnMpOw0KKwkJYXRvbWljNjRf
c3ViKGFjLT5hY19iX2V4LmZlX2xlbiwNCisJCQkgICAgICZzYmktPnNfZmxleF9ncm91cHNbZmxl
eF9ncm91cF0uZnJlZV9jbHVzdGVycyk7DQogCX0NCiANCiAJZXJyID0gZXh0NF9oYW5kbGVfZGly
dHlfbWV0YWRhdGEoaGFuZGxlLCBOVUxMLCBiaXRtYXBfYmgpOw0KQEAgLTM0ODUsNyArMzQ4NSw3
IEBAIGV4dDRfbWJfbmV3X2lub2RlX3BhKHN0cnVjdCBleHQ0X2FsbG9jYXRpb25fY29udGV4dCAq
YWMpDQogCQkJd2luID0gb2ZmczsNCiANCiAJCWFjLT5hY19iX2V4LmZlX2xvZ2ljYWwgPSBhYy0+
YWNfb19leC5mZV9sb2dpY2FsIC0NCi0JCQlFWFQ0X0IyQyhzYmksIHdpbik7DQorCQkJRVhUNF9O
VU1fQjJDKHNiaSwgd2luKTsNCiAJCUJVR19PTihhYy0+YWNfb19leC5mZV9sb2dpY2FsIDwgYWMt
PmFjX2JfZXguZmVfbG9naWNhbCk7DQogCQlCVUdfT04oYWMtPmFjX29fZXguZmVfbGVuID4gYWMt
PmFjX2JfZXguZmVfbGVuKTsNCiAJfQ0KQEAgLTQ2MzQsNyArNDYzNCw3IEBAIGRvX21vcmU6DQog
CQkJRVhUNF9CTE9DS1NfUEVSX0dST1VQKHNiKTsNCiAJCWNvdW50IC09IG92ZXJmbG93Ow0KIAl9
DQotCWNvdW50X2NsdXN0ZXJzID0gRVhUNF9CMkMoc2JpLCBjb3VudCk7DQorCWNvdW50X2NsdXN0
ZXJzID0gRVhUNF9OVU1fQjJDKHNiaSwgY291bnQpOw0KIAliaXRtYXBfYmggPSBleHQ0X3JlYWRf
YmxvY2tfYml0bWFwKHNiLCBibG9ja19ncm91cCk7DQogCWlmICghYml0bWFwX2JoKSB7DQogCQll
cnIgPSAtRUlPOw0KQEAgLTQ3MjQsOCArNDcyNCw4IEBAIGRvX21vcmU6DQogDQogCWlmIChzYmkt
PnNfbG9nX2dyb3Vwc19wZXJfZmxleCkgew0KIAkJZXh0NF9ncm91cF90IGZsZXhfZ3JvdXAgPSBl
eHQ0X2ZsZXhfZ3JvdXAoc2JpLCBibG9ja19ncm91cCk7DQotCQlhdG9taWNfYWRkKGNvdW50X2Ns
dXN0ZXJzLA0KLQkJCSAgICZzYmktPnNfZmxleF9ncm91cHNbZmxleF9ncm91cF0uZnJlZV9jbHVz
dGVycyk7DQorCQlhdG9taWM2NF9hZGQoY291bnRfY2x1c3RlcnMsDQorCQkJICAgICAmc2JpLT5z
X2ZsZXhfZ3JvdXBzW2ZsZXhfZ3JvdXBdLmZyZWVfY2x1c3RlcnMpOw0KIAl9DQogDQogCWV4dDRf
bWJfdW5sb2FkX2J1ZGR5KCZlNGIpOw0KQEAgLTQ4NjUsMTIgKzQ4NjUsMTIgQEAgaW50IGV4dDRf
Z3JvdXBfYWRkX2Jsb2NrcyhoYW5kbGVfdCAqaGFuZGxlLCBzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNi
LA0KIAlkZXNjLT5iZ19jaGVja3N1bSA9IGV4dDRfZ3JvdXBfZGVzY19jc3VtKHNiaSwgYmxvY2tf
Z3JvdXAsIGRlc2MpOw0KIAlleHQ0X3VubG9ja19ncm91cChzYiwgYmxvY2tfZ3JvdXApOw0KIAlw
ZXJjcHVfY291bnRlcl9hZGQoJnNiaS0+c19mcmVlY2x1c3RlcnNfY291bnRlciwNCi0JCQkgICBF
WFQ0X0IyQyhzYmksIGJsb2Nrc19mcmVlZCkpOw0KKwkJCSAgIEVYVDRfTlVNX0IyQyhzYmksIGJs
b2Nrc19mcmVlZCkpOw0KIA0KIAlpZiAoc2JpLT5zX2xvZ19ncm91cHNfcGVyX2ZsZXgpIHsNCiAJ
CWV4dDRfZ3JvdXBfdCBmbGV4X2dyb3VwID0gZXh0NF9mbGV4X2dyb3VwKHNiaSwgYmxvY2tfZ3Jv
dXApOw0KLQkJYXRvbWljX2FkZChFWFQ0X0IyQyhzYmksIGJsb2Nrc19mcmVlZCksDQotCQkJICAg
JnNiaS0+c19mbGV4X2dyb3Vwc1tmbGV4X2dyb3VwXS5mcmVlX2NsdXN0ZXJzKTsNCisJCWF0b21p
YzY0X2FkZChFWFQ0X05VTV9CMkMoc2JpLCBibG9ja3NfZnJlZWQpLA0KKwkJCSAgICAgJnNiaS0+
c19mbGV4X2dyb3Vwc1tmbGV4X2dyb3VwXS5mcmVlX2NsdXN0ZXJzKTsNCiAJfQ0KIA0KIAlleHQ0
X21iX3VubG9hZF9idWRkeSgmZTRiKTsNCmRpZmYgLS1naXQgYS9mcy9leHQ0L3Jlc2l6ZS5jIGIv
ZnMvZXh0NC9yZXNpemUuYw0KaW5kZXggMzMxMjljMC4uNmU2N2I5NyAxMDA2NDQNCi0tLSBhL2Zz
L2V4dDQvcmVzaXplLmMNCisrKyBiL2ZzL2V4dDQvcmVzaXplLmMNCkBAIC05MzgsNyArOTM4LDcg
QEAgaW50IGV4dDRfZ3JvdXBfYWRkKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBleHQ0
X25ld19ncm91cF9kYXRhICppbnB1dCkNCiANCiAJLyogVXBkYXRlIHRoZSBmcmVlIHNwYWNlIGNv
dW50cyAqLw0KIAlwZXJjcHVfY291bnRlcl9hZGQoJnNiaS0+c19mcmVlY2x1c3RlcnNfY291bnRl
ciwNCi0JCQkgICBFWFQ0X0IyQyhzYmksIGlucHV0LT5mcmVlX2Jsb2Nrc19jb3VudCkpOw0KKwkJ
CSAgIEVYVDRfTlVNX0IyQyhzYmksIGlucHV0LT5mcmVlX2Jsb2Nrc19jb3VudCkpOw0KIAlwZXJj
cHVfY291bnRlcl9hZGQoJnNiaS0+c19mcmVlaW5vZGVzX2NvdW50ZXIsDQogCQkJICAgRVhUNF9J
Tk9ERVNfUEVSX0dST1VQKHNiKSk7DQogDQpAQCAtOTQ2LDggKzk0Niw4IEBAIGludCBleHQ0X2dy
b3VwX2FkZChzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBzdHJ1Y3QgZXh0NF9uZXdfZ3JvdXBfZGF0
YSAqaW5wdXQpDQogCSAgICBzYmktPnNfbG9nX2dyb3Vwc19wZXJfZmxleCkgew0KIAkJZXh0NF9n
cm91cF90IGZsZXhfZ3JvdXA7DQogCQlmbGV4X2dyb3VwID0gZXh0NF9mbGV4X2dyb3VwKHNiaSwg
aW5wdXQtPmdyb3VwKTsNCi0JCWF0b21pY19hZGQoRVhUNF9CMkMoc2JpLCBpbnB1dC0+ZnJlZV9i
bG9ja3NfY291bnQpLA0KLQkJCSAgICZzYmktPnNfZmxleF9ncm91cHNbZmxleF9ncm91cF0uZnJl
ZV9jbHVzdGVycyk7DQorCQlhdG9taWM2NF9hZGQoRVhUNF9OVU1fQjJDKHNiaSwgaW5wdXQtPmZy
ZWVfYmxvY2tzX2NvdW50KSwNCisJCQkgICAgICZzYmktPnNfZmxleF9ncm91cHNbZmxleF9ncm91
cF0uZnJlZV9jbHVzdGVycyk7DQogCQlhdG9taWNfYWRkKEVYVDRfSU5PREVTX1BFUl9HUk9VUChz
YiksDQogCQkJICAgJnNiaS0+c19mbGV4X2dyb3Vwc1tmbGV4X2dyb3VwXS5mcmVlX2lub2Rlcyk7
DQogCX0NCmRpZmYgLS1naXQgYS9mcy9leHQ0L3N1cGVyLmMgYi9mcy9leHQ0L3N1cGVyLmMNCmlu
ZGV4IDI0YWM3YTIuLmNjMzg2YjIgMTAwNjQ0DQotLS0gYS9mcy9leHQ0L3N1cGVyLmMNCisrKyBi
L2ZzL2V4dDQvc3VwZXIuYw0KQEAgLTIwNDcsOCArMjA0Nyw4IEBAIHN0YXRpYyBpbnQgZXh0NF9m
aWxsX2ZsZXhfaW5mbyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQ0KIAkJZmxleF9ncm91cCA9IGV4
dDRfZmxleF9ncm91cChzYmksIGkpOw0KIAkJYXRvbWljX2FkZChleHQ0X2ZyZWVfaW5vZGVzX2Nv
dW50KHNiLCBnZHApLA0KIAkJCSAgICZzYmktPnNfZmxleF9ncm91cHNbZmxleF9ncm91cF0uZnJl
ZV9pbm9kZXMpOw0KLQkJYXRvbWljX2FkZChleHQ0X2ZyZWVfZ3JvdXBfY2x1c3RlcnMoc2IsIGdk
cCksDQotCQkJICAgJnNiaS0+c19mbGV4X2dyb3Vwc1tmbGV4X2dyb3VwXS5mcmVlX2NsdXN0ZXJz
KTsNCisJCWF0b21pYzY0X2FkZChleHQ0X2ZyZWVfZ3JvdXBfY2x1c3RlcnMoc2IsIGdkcCksDQor
CQkJICAgICAmc2JpLT5zX2ZsZXhfZ3JvdXBzW2ZsZXhfZ3JvdXBdLmZyZWVfY2x1c3RlcnMpOw0K
IAkJYXRvbWljX2FkZChleHQ0X3VzZWRfZGlyc19jb3VudChzYiwgZ2RwKSwNCiAJCQkgICAmc2Jp
LT5zX2ZsZXhfZ3JvdXBzW2ZsZXhfZ3JvdXBdLnVzZWRfZGlycyk7DQogCX0NCmRpZmYgLS1naXQg
YS9mcy9pc29mcy9leHBvcnQuYyBiL2ZzL2lzb2ZzL2V4cG9ydC5jDQppbmRleCA1MTZlYjIxLi5m
ZDg4YWRkIDEwMDY0NA0KLS0tIGEvZnMvaXNvZnMvZXhwb3J0LmMNCisrKyBiL2ZzL2lzb2ZzL2V4
cG9ydC5jDQpAQCAtMTM1LDYgKzEzNSw3IEBAIGlzb2ZzX2V4cG9ydF9lbmNvZGVfZmgoc3RydWN0
IGRlbnRyeSAqZGVudHJ5LA0KIAlsZW4gPSAzOw0KIAlmaDMyWzBdID0gZWktPmlfaWdldDVfYmxv
Y2s7DQogIAlmaDE2WzJdID0gKF9fdTE2KWVpLT5pX2lnZXQ1X29mZnNldDsgIC8qIGZoMTYgW3Np
Y10gKi8NCisJZmgxNlszXSA9IDA7ICAvKiBhdm9pZCBsZWFraW5nIHVuaW5pdGlhbGl6ZWQgZGF0
YSAqLw0KIAlmaDMyWzJdID0gaW5vZGUtPmlfZ2VuZXJhdGlvbjsNCiAJaWYgKGNvbm5lY3RhYmxl
ICYmICFTX0lTRElSKGlub2RlLT5pX21vZGUpKSB7DQogCQlzdHJ1Y3QgaW5vZGUgKnBhcmVudDsN
CmRpZmYgLS1naXQgYS9mcy9qYmQyL3RyYW5zYWN0aW9uLmMgYi9mcy9qYmQyL3RyYW5zYWN0aW9u
LmMNCmluZGV4IGQ3ZGQ3NzQuLjZhYzViYjEgMTAwNjQ0DQotLS0gYS9mcy9qYmQyL3RyYW5zYWN0
aW9uLmMNCisrKyBiL2ZzL2piZDIvdHJhbnNhY3Rpb24uYw0KQEAgLTEwMTYsOSArMTAxNiwxMiBA
QCBvdXQ6DQogdm9pZCBqYmQyX2pvdXJuYWxfc2V0X3RyaWdnZXJzKHN0cnVjdCBidWZmZXJfaGVh
ZCAqYmgsDQogCQkJICAgICAgIHN0cnVjdCBqYmQyX2J1ZmZlcl90cmlnZ2VyX3R5cGUgKnR5cGUp
DQogew0KLQlzdHJ1Y3Qgam91cm5hbF9oZWFkICpqaCA9IGJoMmpoKGJoKTsNCisJc3RydWN0IGpv
dXJuYWxfaGVhZCAqamggPSBqYmQyX2pvdXJuYWxfZ3JhYl9qb3VybmFsX2hlYWQoYmgpOw0KIA0K
KwlpZiAoV0FSTl9PTighamgpKQ0KKwkJcmV0dXJuOw0KIAlqaC0+Yl90cmlnZ2VycyA9IHR5cGU7
DQorCWpiZDJfam91cm5hbF9wdXRfam91cm5hbF9oZWFkKGpoKTsNCiB9DQogDQogdm9pZCBqYmQy
X2J1ZmZlcl9mcm96ZW5fdHJpZ2dlcihzdHJ1Y3Qgam91cm5hbF9oZWFkICpqaCwgdm9pZCAqbWFw
cGVkX2RhdGEsDQpAQCAtMTA3MCwxNyArMTA3MywxOCBAQCBpbnQgamJkMl9qb3VybmFsX2RpcnR5
X21ldGFkYXRhKGhhbmRsZV90ICpoYW5kbGUsIHN0cnVjdCBidWZmZXJfaGVhZCAqYmgpDQogew0K
IAl0cmFuc2FjdGlvbl90ICp0cmFuc2FjdGlvbiA9IGhhbmRsZS0+aF90cmFuc2FjdGlvbjsNCiAJ
am91cm5hbF90ICpqb3VybmFsID0gdHJhbnNhY3Rpb24tPnRfam91cm5hbDsNCi0Jc3RydWN0IGpv
dXJuYWxfaGVhZCAqamggPSBiaDJqaChiaCk7DQorCXN0cnVjdCBqb3VybmFsX2hlYWQgKmpoOw0K
IAlpbnQgcmV0ID0gMDsNCiANCi0JamJkX2RlYnVnKDUsICJqb3VybmFsX2hlYWQgJXBcbiIsIGpo
KTsNCi0JSkJVRkZFUl9UUkFDRShqaCwgImVudHJ5Iik7DQogCWlmIChpc19oYW5kbGVfYWJvcnRl
ZChoYW5kbGUpKQ0KIAkJZ290byBvdXQ7DQotCWlmICghYnVmZmVyX2piZChiaCkpIHsNCisJamgg
PSBqYmQyX2pvdXJuYWxfZ3JhYl9qb3VybmFsX2hlYWQoYmgpOw0KKwlpZiAoIWpoKSB7DQogCQly
ZXQgPSAtRVVDTEVBTjsNCiAJCWdvdG8gb3V0Ow0KIAl9DQorCWpiZF9kZWJ1Zyg1LCAiam91cm5h
bF9oZWFkICVwXG4iLCBqaCk7DQorCUpCVUZGRVJfVFJBQ0UoamgsICJlbnRyeSIpOw0KIA0KIAlq
YmRfbG9ja19iaF9zdGF0ZShiaCk7DQogDQpAQCAtMTE3MSw2ICsxMTc1LDcgQEAgaW50IGpiZDJf
am91cm5hbF9kaXJ0eV9tZXRhZGF0YShoYW5kbGVfdCAqaGFuZGxlLCBzdHJ1Y3QgYnVmZmVyX2hl
YWQgKmJoKQ0KIAlzcGluX3VubG9jaygmam91cm5hbC0+al9saXN0X2xvY2spOw0KIG91dF91bmxv
Y2tfYmg6DQogCWpiZF91bmxvY2tfYmhfc3RhdGUoYmgpOw0KKwlqYmQyX2pvdXJuYWxfcHV0X2pv
dXJuYWxfaGVhZChqaCk7DQogb3V0Og0KIAlKQlVGRkVSX1RSQUNFKGpoLCAiZXhpdCIpOw0KIAlX
QVJOX09OKHJldCk7CS8qIEFsbCBlcnJvcnMgYXJlIGJ1Z3MsIHNvIGR1bXAgdGhlIHN0YWNrICov
DQpkaWZmIC0tZ2l0IGEvZnMvcHJvYy9pbm9kZS5jIGIvZnMvcHJvYy9pbm9kZS5jDQppbmRleCA3
NzM3YzU0Li4wMGYwOGIzIDEwMDY0NA0KLS0tIGEvZnMvcHJvYy9pbm9kZS5jDQorKysgYi9mcy9w
cm9jL2lub2RlLmMNCkBAIC00MjcsMTIgKzQyNywxMCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGZp
bGVfb3BlcmF0aW9ucyBwcm9jX3JlZ19maWxlX29wc19ub19jb21wYXQgPSB7DQogDQogc3RydWN0
IGlub2RlICpwcm9jX2dldF9pbm9kZShzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBzdHJ1Y3QgcHJv
Y19kaXJfZW50cnkgKmRlKQ0KIHsNCi0Jc3RydWN0IGlub2RlICogaW5vZGU7DQorCXN0cnVjdCBp
bm9kZSAqaW5vZGUgPSBuZXdfaW5vZGVfcHNldWRvKHNiKTsNCiANCi0JaW5vZGUgPSBpZ2V0X2xv
Y2tlZChzYiwgZGUtPmxvd19pbm8pOw0KLQlpZiAoIWlub2RlKQ0KLQkJcmV0dXJuIE5VTEw7DQot
CWlmIChpbm9kZS0+aV9zdGF0ZSAmIElfTkVXKSB7DQorCWlmIChpbm9kZSkgew0KKwkJaW5vZGUt
PmlfaW5vID0gZGUtPmxvd19pbm87DQogCQlpbm9kZS0+aV9tdGltZSA9IGlub2RlLT5pX2F0aW1l
ID0gaW5vZGUtPmlfY3RpbWUgPSBDVVJSRU5UX1RJTUU7DQogCQlQUk9DX0koaW5vZGUpLT5mZCA9
IDA7DQogCQlQUk9DX0koaW5vZGUpLT5wZGUgPSBkZTsNCkBAIC00NjEsOSArNDU5LDcgQEAgc3Ry
dWN0IGlub2RlICpwcm9jX2dldF9pbm9kZShzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBzdHJ1Y3Qg
cHJvY19kaXJfZW50cnkgKmRlKQ0KIAkJCQlpbm9kZS0+aV9mb3AgPSBkZS0+cHJvY19mb3BzOw0K
IAkJCX0NCiAJCX0NCi0JCXVubG9ja19uZXdfaW5vZGUoaW5vZGUpOw0KLQl9IGVsc2UNCi0JICAg
ICAgIHBkZV9wdXQoZGUpOw0KKwl9DQogCXJldHVybiBpbm9kZTsNCiB9CQkJDQogDQpkaWZmIC0t
Z2l0IGEvZnMvdWRmL25hbWVpLmMgYi9mcy91ZGYvbmFtZWkuYw0KaW5kZXggNDYzOWUxMy4uNzFj
OTdmYiAxMDA2NDQNCi0tLSBhL2ZzL3VkZi9uYW1laS5jDQorKysgYi9mcy91ZGYvbmFtZWkuYw0K
QEAgLTEyOTMsNiArMTI5Myw3IEBAIHN0YXRpYyBpbnQgdWRmX2VuY29kZV9maChzdHJ1Y3QgZGVu
dHJ5ICpkZSwgX191MzIgKmZoLCBpbnQgKmxlbnAsDQogCSpsZW5wID0gMzsNCiAJZmlkLT51ZGYu
YmxvY2sgPSBsb2NhdGlvbi5sb2dpY2FsQmxvY2tOdW07DQogCWZpZC0+dWRmLnBhcnRyZWYgPSBs
b2NhdGlvbi5wYXJ0aXRpb25SZWZlcmVuY2VOdW07DQorCWZpZC0+dWRmLnBhcmVudF9wYXJ0cmVm
ID0gMDsNCiAJZmlkLT51ZGYuZ2VuZXJhdGlvbiA9IGlub2RlLT5pX2dlbmVyYXRpb247DQogDQog
CWlmIChjb25uZWN0YWJsZSAmJiAhU19JU0RJUihpbm9kZS0+aV9tb2RlKSkgew0KZGlmZiAtLWdp
dCBhL2luY2x1ZGUvYXNtLWdlbmVyaWMvc2lnbmFsLmggYi9pbmNsdWRlL2FzbS1nZW5lcmljL3Np
Z25hbC5oDQppbmRleCA1NTVjMGFlLi43NDNmN2E1IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9hc20t
Z2VuZXJpYy9zaWduYWwuaA0KKysrIGIvaW5jbHVkZS9hc20tZ2VuZXJpYy9zaWduYWwuaA0KQEAg
LTk5LDYgKzk5LDEwIEBAIHR5cGVkZWYgdW5zaWduZWQgbG9uZyBvbGRfc2lnc2V0X3Q7DQogDQog
I2luY2x1ZGUgPGFzbS1nZW5lcmljL3NpZ25hbC1kZWZzLmg+DQogDQorI2lmZGVmIFNBX1JFU1RP
UkVSDQorI2RlZmluZSBfX0FSQ0hfSEFTX1NBX1JFU1RPUkVSDQorI2VuZGlmDQorDQogc3RydWN0
IHNpZ2FjdGlvbiB7DQogCV9fc2lnaGFuZGxlcl90IHNhX2hhbmRsZXI7DQogCXVuc2lnbmVkIGxv
bmcgc2FfZmxhZ3M7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9lZmkuaCBiL2luY2x1ZGUv
bGludXgvZWZpLmgNCmluZGV4IGNlOTVhNGIuLjg0NjlmM2YgMTAwNjQ0DQotLS0gYS9pbmNsdWRl
L2xpbnV4L2VmaS5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2VmaS5oDQpAQCAtNDg0LDcgKzQ4NCw4
IEBAIHN0cnVjdCBlZml2YXJzIHsNCiAJICogMSkgLT5saXN0IC0gYWRkcywgcmVtb3ZhbHMsIHJl
YWRzLCB3cml0ZXMNCiAJICogMikgb3BzLltnc11ldF92YXJpYWJsZSgpIGNhbGxzLg0KIAkgKiBJ
dCBtdXN0IG5vdCBiZSBoZWxkIHdoZW4gY3JlYXRpbmcgc3lzZnMgZW50cmllcyBvciBjYWxsaW5n
IGttYWxsb2MuDQotCSAqIG9wcy5nZXRfbmV4dF92YXJpYWJsZSgpIGlzIG9ubHkgY2FsbGVkIGZy
b20gcmVnaXN0ZXJfZWZpdmFycygpLA0KKwkgKiBvcHMuZ2V0X25leHRfdmFyaWFibGUoKSBpcyBv
bmx5IGNhbGxlZCBmcm9tIHJlZ2lzdGVyX2VmaXZhcnMoKQ0KKwkgKiBvciBlZml2YXJfdXBkYXRl
X3N5c2ZzX2VudHJpZXMoKSwNCiAJICogd2hpY2ggaXMgcHJvdGVjdGVkIGJ5IHRoZSBCS0wsIHNv
IHRoYXQgcGF0aCBpcyBzYWZlLg0KIAkgKi8NCiAJc3BpbmxvY2tfdCBsb2NrOw0KZGlmZiAtLWdp
dCBhL2luY2x1ZGUvbGludXgvcGVyZl9ldmVudC5oIGIvaW5jbHVkZS9saW51eC9wZXJmX2V2ZW50
LmgNCmluZGV4IGI2NjliZTYuLjliOWIyYWEgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3Bl
cmZfZXZlbnQuaA0KKysrIGIvaW5jbHVkZS9saW51eC9wZXJmX2V2ZW50LmgNCkBAIC0xMTg2LDYg
KzExODYsMTIgQEAgc3RhdGljIGlubGluZSB2b2lkIHBlcmZfZXZlbnRfZGlzYWJsZShzdHJ1Y3Qg
cGVyZl9ldmVudCAqZXZlbnQpCQl7IH0NCiBzdGF0aWMgaW5saW5lIHZvaWQgcGVyZl9ldmVudF90
YXNrX3RpY2sodm9pZCkJCQkJeyB9DQogI2VuZGlmDQogDQorI2lmIGRlZmluZWQoQ09ORklHX1BF
UkZfRVZFTlRTKSAmJiBkZWZpbmVkKENPTkZJR19DUFVfU1VQX0lOVEVMKQ0KK2V4dGVybiB2b2lk
IHBlcmZfcmVzdG9yZV9kZWJ1Z19zdG9yZSh2b2lkKTsNCisjZWxzZQ0KK3N0YXRpYyBpbmxpbmUg
dm9pZCBwZXJmX3Jlc3RvcmVfZGVidWdfc3RvcmUodm9pZCkJCQl7IH0NCisjZW5kaWYNCisNCiAj
ZGVmaW5lIHBlcmZfb3V0cHV0X3B1dChoYW5kbGUsIHgpIHBlcmZfb3V0cHV0X2NvcHkoKGhhbmRs
ZSksICYoeCksIHNpemVvZih4KSkNCiANCiAvKg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgv
c2tidWZmLmggYi9pbmNsdWRlL2xpbnV4L3NrYnVmZi5oDQppbmRleCA1M2RjN2U3Li5kYTY1ODkw
IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9za2J1ZmYuaA0KKysrIGIvaW5jbHVkZS9saW51
eC9za2J1ZmYuaA0KQEAgLTQ1NSw3ICs0NTUsNyBAQCBzdHJ1Y3Qgc2tfYnVmZiB7DQogCXVuaW9u
IHsNCiAJCV9fdTMyCQltYXJrOw0KIAkJX191MzIJCWRyb3Bjb3VudDsNCi0JCV9fdTMyCQlhdmFp
bF9zaXplOw0KKwkJX191MzIJCXJlc2VydmVkX3RhaWxyb29tOw0KIAl9Ow0KIA0KIAlfX3UxNgkJ
CXZsYW5fdGNpOw0KQEAgLTEzMzIsNyArMTMzMiwxMCBAQCBzdGF0aWMgaW5saW5lIGludCBza2Jf
dGFpbHJvb20oY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYikNCiAgKi8NCiBzdGF0aWMgaW5saW5l
IGludCBza2JfYXZhaWxyb29tKGNvbnN0IHN0cnVjdCBza19idWZmICpza2IpDQogew0KLQlyZXR1
cm4gc2tiX2lzX25vbmxpbmVhcihza2IpID8gMCA6IHNrYi0+YXZhaWxfc2l6ZSAtIHNrYi0+bGVu
Ow0KKwlpZiAoc2tiX2lzX25vbmxpbmVhcihza2IpKQ0KKwkJcmV0dXJuIDA7DQorDQorCXJldHVy
biBza2ItPmVuZCAtIHNrYi0+dGFpbCAtIHNrYi0+cmVzZXJ2ZWRfdGFpbHJvb207DQogfQ0KIA0K
IC8qKg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2luZXRfZnJhZy5oIGIvaW5jbHVkZS9uZXQv
aW5ldF9mcmFnLmgNCmluZGV4IDE2ZmYyOWEuLmIyODliZDIgMTAwNjQ0DQotLS0gYS9pbmNsdWRl
L25ldC9pbmV0X2ZyYWcuaA0KKysrIGIvaW5jbHVkZS9uZXQvaW5ldF9mcmFnLmgNCkBAIC0zMyw2
ICszMywxMyBAQCBzdHJ1Y3QgaW5ldF9mcmFnX3F1ZXVlIHsNCiANCiAjZGVmaW5lIElORVRGUkFH
U19IQVNIU1oJCTY0DQogDQorLyogYXZlcmFnZWQ6DQorICogbWF4X2RlcHRoID0gZGVmYXVsdCBp
cGZyYWdfaGlnaF90aHJlc2ggLyBJTkVURlJBR1NfSEFTSFNaIC8NCisgKgkgICAgICAgcm91bmRl
ZCB1cCAoU0tCX1RSVUVMRU4oMCkgKyBzaXplb2Yoc3RydWN0IGlwcSBvcg0KKyAqCSAgICAgICBz
dHJ1Y3QgZnJhZ19xdWV1ZSkpDQorICovDQorI2RlZmluZSBJTkVURlJBR1NfTUFYREVQVEgJCTEy
OA0KKw0KIHN0cnVjdCBpbmV0X2ZyYWdzIHsNCiAJc3RydWN0IGhsaXN0X2hlYWQJaGFzaFtJTkVU
RlJBR1NfSEFTSFNaXTsNCiAJcndsb2NrX3QJCWxvY2s7DQpAQCAtNjQsNiArNzEsOCBAQCBpbnQg
aW5ldF9mcmFnX2V2aWN0b3Ioc3RydWN0IG5ldG5zX2ZyYWdzICpuZiwgc3RydWN0IGluZXRfZnJh
Z3MgKmYpOw0KIHN0cnVjdCBpbmV0X2ZyYWdfcXVldWUgKmluZXRfZnJhZ19maW5kKHN0cnVjdCBu
ZXRuc19mcmFncyAqbmYsDQogCQlzdHJ1Y3QgaW5ldF9mcmFncyAqZiwgdm9pZCAqa2V5LCB1bnNp
Z25lZCBpbnQgaGFzaCkNCiAJX19yZWxlYXNlcygmZi0+bG9jayk7DQordm9pZCBpbmV0X2ZyYWdf
bWF5YmVfd2Fybl9vdmVyZmxvdyhzdHJ1Y3QgaW5ldF9mcmFnX3F1ZXVlICpxLA0KKwkJCQkgICBj
b25zdCBjaGFyICpwcmVmaXgpOw0KIA0KIHN0YXRpYyBpbmxpbmUgdm9pZCBpbmV0X2ZyYWdfcHV0
KHN0cnVjdCBpbmV0X2ZyYWdfcXVldWUgKnEsIHN0cnVjdCBpbmV0X2ZyYWdzICpmKQ0KIHsNCmRp
ZmYgLS1naXQgYS9pbmNsdWRlL25ldC9pcF9maWIuaCBiL2luY2x1ZGUvbmV0L2lwX2ZpYi5oDQpp
bmRleCAxMDQyMmVmLi4yMTI0MDA0IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9uZXQvaXBfZmliLmgN
CisrKyBiL2luY2x1ZGUvbmV0L2lwX2ZpYi5oDQpAQCAtMTI5LDE4ICsxMjksMTYgQEAgc3RydWN0
IGZpYl9yZXN1bHRfbmwgew0KIH07DQogDQogI2lmZGVmIENPTkZJR19JUF9ST1VURV9NVUxUSVBB
VEgNCi0NCiAjZGVmaW5lIEZJQl9SRVNfTkgocmVzKQkJKChyZXMpLmZpLT5maWJfbmhbKHJlcyku
bmhfc2VsXSkNCi0NCi0jZGVmaW5lIEZJQl9UQUJMRV9IQVNIU1ogMg0KLQ0KICNlbHNlIC8qIENP
TkZJR19JUF9ST1VURV9NVUxUSVBBVEggKi8NCi0NCiAjZGVmaW5lIEZJQl9SRVNfTkgocmVzKQkJ
KChyZXMpLmZpLT5maWJfbmhbMF0pDQorI2VuZGlmIC8qIENPTkZJR19JUF9ST1VURV9NVUxUSVBB
VEggKi8NCiANCisjaWZkZWYgQ09ORklHX0lQX01VTFRJUExFX1RBQkxFUw0KICNkZWZpbmUgRklC
X1RBQkxFX0hBU0hTWiAyNTYNCi0NCi0jZW5kaWYgLyogQ09ORklHX0lQX1JPVVRFX01VTFRJUEFU
SCAqLw0KKyNlbHNlDQorI2RlZmluZSBGSUJfVEFCTEVfSEFTSFNaIDINCisjZW5kaWYNCiANCiBl
eHRlcm4gX19iZTMyIGZpYl9pbmZvX3VwZGF0ZV9uaF9zYWRkcihzdHJ1Y3QgbmV0ICpuZXQsIHN0
cnVjdCBmaWJfbmggKm5oKTsNCiANCmRpZmYgLS1naXQgYS9rZXJuZWwvc2lnbmFsLmMgYi9rZXJu
ZWwvc2lnbmFsLmMNCmluZGV4IDcxZTE4MTYuLmVhNzZkMzAgMTAwNjQ0DQotLS0gYS9rZXJuZWwv
c2lnbmFsLmMNCisrKyBiL2tlcm5lbC9zaWduYWwuYw0KQEAgLTQ4MSw3ICs0ODEsNyBAQCBmbHVz
aF9zaWduYWxfaGFuZGxlcnMoc3RydWN0IHRhc2tfc3RydWN0ICp0LCBpbnQgZm9yY2VfZGVmYXVs
dCkNCiAJCWlmIChmb3JjZV9kZWZhdWx0IHx8IGthLT5zYS5zYV9oYW5kbGVyICE9IFNJR19JR04p
DQogCQkJa2EtPnNhLnNhX2hhbmRsZXIgPSBTSUdfREZMOw0KIAkJa2EtPnNhLnNhX2ZsYWdzID0g
MDsNCi0jaWZkZWYgU0FfUkVTVE9SRVINCisjaWZkZWYgX19BUkNIX0hBU19TQV9SRVNUT1JFUg0K
IAkJa2EtPnNhLnNhX3Jlc3RvcmVyID0gTlVMTDsNCiAjZW5kaWYNCiAJCXNpZ2VtcHR5c2V0KCZr
YS0+c2Euc2FfbWFzayk7DQpkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL2Z0cmFjZS5jIGIva2Vy
bmVsL3RyYWNlL2Z0cmFjZS5jDQppbmRleCA2Yzg4MGU4Li4wOTQzZDJhIDEwMDY0NA0KLS0tIGEv
a2VybmVsL3RyYWNlL2Z0cmFjZS5jDQorKysgYi9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCkBAIC0y
NzI1LDggKzI3MjUsOCBAQCBfX3VucmVnaXN0ZXJfZnRyYWNlX2Z1bmN0aW9uX3Byb2JlKGNoYXIg
Kmdsb2IsIHN0cnVjdCBmdHJhY2VfcHJvYmVfb3BzICpvcHMsDQogCQkJCQljb250aW51ZTsNCiAJ
CQl9DQogDQotCQkJaGxpc3RfZGVsKCZlbnRyeS0+bm9kZSk7DQotCQkJY2FsbF9yY3UoJmVudHJ5
LT5yY3UsIGZ0cmFjZV9mcmVlX2VudHJ5X3JjdSk7DQorCQkJaGxpc3RfZGVsX3JjdSgmZW50cnkt
Pm5vZGUpOw0KKwkJCWNhbGxfcmN1X3NjaGVkKCZlbnRyeS0+cmN1LCBmdHJhY2VfZnJlZV9lbnRy
eV9yY3UpOw0KIAkJfQ0KIAl9DQogCV9fZGlzYWJsZV9mdHJhY2VfZnVuY3Rpb25fcHJvYmUoKTsN
CmRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvdHJhY2UuYyBiL2tlcm5lbC90cmFjZS90cmFjZS5j
DQppbmRleCA1NjM4MTA0Li4xN2VkYjE0IDEwMDY0NA0KLS0tIGEva2VybmVsL3RyYWNlL3RyYWNl
LmMNCisrKyBiL2tlcm5lbC90cmFjZS90cmFjZS5jDQpAQCAtNjUyLDcgKzY1Miw3IEBAIF9fdXBk
YXRlX21heF90cihzdHJ1Y3QgdHJhY2VfYXJyYXkgKnRyLCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRz
aywgaW50IGNwdSkNCiB2b2lkDQogdXBkYXRlX21heF90cihzdHJ1Y3QgdHJhY2VfYXJyYXkgKnRy
LCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzaywgaW50IGNwdSkNCiB7DQotCXN0cnVjdCByaW5nX2J1
ZmZlciAqYnVmID0gdHItPmJ1ZmZlcjsNCisJc3RydWN0IHJpbmdfYnVmZmVyICpidWY7DQogDQog
CWlmICh0cmFjZV9zdG9wX2NvdW50KQ0KIAkJcmV0dXJuOw0KQEAgLTY2NCw2ICs2NjQsNyBAQCB1
cGRhdGVfbWF4X3RyKHN0cnVjdCB0cmFjZV9hcnJheSAqdHIsIHN0cnVjdCB0YXNrX3N0cnVjdCAq
dHNrLCBpbnQgY3B1KQ0KIAl9DQogCWFyY2hfc3Bpbl9sb2NrKCZmdHJhY2VfbWF4X2xvY2spOw0K
IA0KKwlidWYgPSB0ci0+YnVmZmVyOw0KIAl0ci0+YnVmZmVyID0gbWF4X3RyLmJ1ZmZlcjsNCiAJ
bWF4X3RyLmJ1ZmZlciA9IGJ1ZjsNCiANCkBAIC0yNjM1LDExICsyNjM2LDI1IEBAIHN0YXRpYyBp
bnQgc2V0X3RyYWNlcl9vcHRpb24oc3RydWN0IHRyYWNlciAqdHJhY2UsIGNoYXIgKmNtcCwgaW50
IG5lZykNCiAJcmV0dXJuIC1FSU5WQUw7DQogfQ0KIA0KLXN0YXRpYyB2b2lkIHNldF90cmFjZXJf
ZmxhZ3ModW5zaWduZWQgaW50IG1hc2ssIGludCBlbmFibGVkKQ0KKy8qIFNvbWUgdHJhY2VycyBy
ZXF1aXJlIG92ZXJ3cml0ZSB0byBzdGF5IGVuYWJsZWQgKi8NCitpbnQgdHJhY2Vfa2VlcF9vdmVy
d3JpdGUoc3RydWN0IHRyYWNlciAqdHJhY2VyLCB1MzIgbWFzaywgaW50IHNldCkNCit7DQorCWlm
ICh0cmFjZXItPmVuYWJsZWQgJiYgKG1hc2sgJiBUUkFDRV9JVEVSX09WRVJXUklURSkgJiYgIXNl
dCkNCisJCXJldHVybiAtMTsNCisNCisJcmV0dXJuIDA7DQorfQ0KKw0KK2ludCBzZXRfdHJhY2Vy
X2ZsYWcodW5zaWduZWQgaW50IG1hc2ssIGludCBlbmFibGVkKQ0KIHsNCiAJLyogZG8gbm90aGlu
ZyBpZiBmbGFnIGlzIGFscmVhZHkgc2V0ICovDQogCWlmICghISh0cmFjZV9mbGFncyAmIG1hc2sp
ID09ICEhZW5hYmxlZCkNCi0JCXJldHVybjsNCisJCXJldHVybiAwOw0KKw0KKwkvKiBHaXZlIHRo
ZSB0cmFjZXIgYSBjaGFuY2UgdG8gYXBwcm92ZSB0aGUgY2hhbmdlICovDQorCWlmIChjdXJyZW50
X3RyYWNlLT5mbGFnX2NoYW5nZWQpDQorCQlpZiAoY3VycmVudF90cmFjZS0+ZmxhZ19jaGFuZ2Vk
KGN1cnJlbnRfdHJhY2UsIG1hc2ssICEhZW5hYmxlZCkpDQorCQkJcmV0dXJuIC1FSU5WQUw7DQog
DQogCWlmIChlbmFibGVkKQ0KIAkJdHJhY2VfZmxhZ3MgfD0gbWFzazsNCkBAIC0yNjQ5LDggKzI2
NjQsMTQgQEAgc3RhdGljIHZvaWQgc2V0X3RyYWNlcl9mbGFncyh1bnNpZ25lZCBpbnQgbWFzaywg
aW50IGVuYWJsZWQpDQogCWlmIChtYXNrID09IFRSQUNFX0lURVJfUkVDT1JEX0NNRCkNCiAJCXRy
YWNlX2V2ZW50X2VuYWJsZV9jbWRfcmVjb3JkKGVuYWJsZWQpOw0KIA0KLQlpZiAobWFzayA9PSBU
UkFDRV9JVEVSX09WRVJXUklURSkNCisJaWYgKG1hc2sgPT0gVFJBQ0VfSVRFUl9PVkVSV1JJVEUp
IHsNCiAJCXJpbmdfYnVmZmVyX2NoYW5nZV9vdmVyd3JpdGUoZ2xvYmFsX3RyYWNlLmJ1ZmZlciwg
ZW5hYmxlZCk7DQorI2lmZGVmIENPTkZJR19UUkFDRVJfTUFYX1RSQUNFDQorCQlyaW5nX2J1ZmZl
cl9jaGFuZ2Vfb3ZlcndyaXRlKG1heF90ci5idWZmZXIsIGVuYWJsZWQpOw0KKyNlbmRpZg0KKwl9
DQorDQorCXJldHVybiAwOw0KIH0NCiANCiBzdGF0aWMgc3NpemVfdA0KQEAgLTI2NjAsNyArMjY4
MSw3IEBAIHRyYWNpbmdfdHJhY2Vfb3B0aW9uc193cml0ZShzdHJ1Y3QgZmlsZSAqZmlscCwgY29u
c3QgY2hhciBfX3VzZXIgKnVidWYsDQogCWNoYXIgYnVmWzY0XTsNCiAJY2hhciAqY21wOw0KIAlp
bnQgbmVnID0gMDsNCi0JaW50IHJldDsNCisJaW50IHJldCA9IDA7DQogCWludCBpOw0KIA0KIAlp
ZiAoY250ID49IHNpemVvZihidWYpKQ0KQEAgLTI2NzcsMjEgKzI2OTgsMjMgQEAgdHJhY2luZ190
cmFjZV9vcHRpb25zX3dyaXRlKHN0cnVjdCBmaWxlICpmaWxwLCBjb25zdCBjaGFyIF9fdXNlciAq
dWJ1ZiwNCiAJCWNtcCArPSAyOw0KIAl9DQogDQorCW11dGV4X2xvY2soJnRyYWNlX3R5cGVzX2xv
Y2spOw0KKw0KIAlmb3IgKGkgPSAwOyB0cmFjZV9vcHRpb25zW2ldOyBpKyspIHsNCiAJCWlmIChz
dHJjbXAoY21wLCB0cmFjZV9vcHRpb25zW2ldKSA9PSAwKSB7DQotCQkJc2V0X3RyYWNlcl9mbGFn
cygxIDw8IGksICFuZWcpOw0KKwkJCXJldCA9IHNldF90cmFjZXJfZmxhZygxIDw8IGksICFuZWcp
Ow0KIAkJCWJyZWFrOw0KIAkJfQ0KIAl9DQogDQogCS8qIElmIG5vIG9wdGlvbiBjb3VsZCBiZSBz
ZXQsIHRlc3QgdGhlIHNwZWNpZmljIHRyYWNlciBvcHRpb25zICovDQotCWlmICghdHJhY2Vfb3B0
aW9uc1tpXSkgew0KLQkJbXV0ZXhfbG9jaygmdHJhY2VfdHlwZXNfbG9jayk7DQorCWlmICghdHJh
Y2Vfb3B0aW9uc1tpXSkNCiAJCXJldCA9IHNldF90cmFjZXJfb3B0aW9uKGN1cnJlbnRfdHJhY2Us
IGNtcCwgbmVnKTsNCi0JCW11dGV4X3VubG9jaygmdHJhY2VfdHlwZXNfbG9jayk7DQotCQlpZiAo
cmV0KQ0KLQkJCXJldHVybiByZXQ7DQotCX0NCisNCisJbXV0ZXhfdW5sb2NrKCZ0cmFjZV90eXBl
c19sb2NrKTsNCisNCisJaWYgKHJldCkNCisJCXJldHVybiByZXQ7DQogDQogCSpwcG9zICs9IGNu
dDsNCiANCkBAIC0zMDE1LDYgKzMwMzgsOSBAQCBzdGF0aWMgaW50IHRyYWNpbmdfc2V0X3RyYWNl
cihjb25zdCBjaGFyICpidWYpDQogCQlnb3RvIG91dDsNCiANCiAJdHJhY2VfYnJhbmNoX2Rpc2Fi
bGUoKTsNCisNCisJY3VycmVudF90cmFjZS0+ZW5hYmxlZCA9IGZhbHNlOw0KKw0KIAlpZiAoY3Vy
cmVudF90cmFjZSAmJiBjdXJyZW50X3RyYWNlLT5yZXNldCkNCiAJCWN1cnJlbnRfdHJhY2UtPnJl
c2V0KHRyKTsNCiAJaWYgKGN1cnJlbnRfdHJhY2UgJiYgY3VycmVudF90cmFjZS0+dXNlX21heF90
cikgew0KQEAgLTMwNDQsNiArMzA3MCw3IEBAIHN0YXRpYyBpbnQgdHJhY2luZ19zZXRfdHJhY2Vy
KGNvbnN0IGNoYXIgKmJ1ZikNCiAJCQlnb3RvIG91dDsNCiAJfQ0KIA0KKwljdXJyZW50X3RyYWNl
LT5lbmFibGVkID0gdHJ1ZTsNCiAJdHJhY2VfYnJhbmNoX2VuYWJsZSh0cik7DQogIG91dDoNCiAJ
bXV0ZXhfdW5sb2NrKCZ0cmFjZV90eXBlc19sb2NrKTsNCkBAIC00Mzc4LDcgKzQ0MDUsMTMgQEAg
dHJhY2Vfb3B0aW9uc19jb3JlX3dyaXRlKHN0cnVjdCBmaWxlICpmaWxwLCBjb25zdCBjaGFyIF9f
dXNlciAqdWJ1Ziwgc2l6ZV90IGNudCwNCiANCiAJaWYgKHZhbCAhPSAwICYmIHZhbCAhPSAxKQ0K
IAkJcmV0dXJuIC1FSU5WQUw7DQotCXNldF90cmFjZXJfZmxhZ3MoMSA8PCBpbmRleCwgdmFsKTsN
CisNCisJbXV0ZXhfbG9jaygmdHJhY2VfdHlwZXNfbG9jayk7DQorCXJldCA9IHNldF90cmFjZXJf
ZmxhZygxIDw8IGluZGV4LCB2YWwpOw0KKwltdXRleF91bmxvY2soJnRyYWNlX3R5cGVzX2xvY2sp
Ow0KKw0KKwlpZiAocmV0IDwgMCkNCisJCXJldHVybiByZXQ7DQogDQogCSpwcG9zICs9IGNudDsN
CiANCmRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvdHJhY2UuaCBiL2tlcm5lbC90cmFjZS90cmFj
ZS5oDQppbmRleCAwOTJlMWY4Li5jM2MzZjZiIDEwMDY0NA0KLS0tIGEva2VybmVsL3RyYWNlL3Ry
YWNlLmgNCisrKyBiL2tlcm5lbC90cmFjZS90cmFjZS5oDQpAQCAtMjcxLDEwICsyNzEsMTQgQEAg
c3RydWN0IHRyYWNlciB7DQogCWVudW0gcHJpbnRfbGluZV90CSgqcHJpbnRfbGluZSkoc3RydWN0
IHRyYWNlX2l0ZXJhdG9yICppdGVyKTsNCiAJLyogSWYgeW91IGhhbmRsZWQgdGhlIGZsYWcgc2V0
dGluZywgcmV0dXJuIDAgKi8NCiAJaW50CQkJKCpzZXRfZmxhZykodTMyIG9sZF9mbGFncywgdTMy
IGJpdCwgaW50IHNldCk7DQorCS8qIFJldHVybiAwIGlmIE9LIHdpdGggY2hhbmdlLCBlbHNlIHJl
dHVybiBub24temVybyAqLw0KKwlpbnQJCQkoKmZsYWdfY2hhbmdlZCkoc3RydWN0IHRyYWNlciAq
dHJhY2VyLA0KKwkJCQkJCXUzMiBtYXNrLCBpbnQgc2V0KTsNCiAJc3RydWN0IHRyYWNlcgkJKm5l
eHQ7DQogCXN0cnVjdCB0cmFjZXJfZmxhZ3MJKmZsYWdzOw0KIAlpbnQJCQlwcmludF9tYXg7DQog
CWludAkJCXVzZV9tYXhfdHI7DQorCWJvb2wJCQllbmFibGVkOw0KIH07DQogDQogDQpAQCAtODE1
LDYgKzgxOSw5IEBAIGV4dGVybiBzdHJ1Y3QgbGlzdF9oZWFkIGZ0cmFjZV9ldmVudHM7DQogZXh0
ZXJuIGNvbnN0IGNoYXIgKl9fc3RhcnRfX190cmFjZV9icHJpbnRrX2ZtdFtdOw0KIGV4dGVybiBj
b25zdCBjaGFyICpfX3N0b3BfX190cmFjZV9icHJpbnRrX2ZtdFtdOw0KIA0KK2ludCB0cmFjZV9r
ZWVwX292ZXJ3cml0ZShzdHJ1Y3QgdHJhY2VyICp0cmFjZXIsIHUzMiBtYXNrLCBpbnQgc2V0KTsN
CitpbnQgc2V0X3RyYWNlcl9mbGFnKHVuc2lnbmVkIGludCBtYXNrLCBpbnQgZW5hYmxlZCk7DQor
DQogI3VuZGVmIEZUUkFDRV9FTlRSWQ0KICNkZWZpbmUgRlRSQUNFX0VOVFJZKGNhbGwsIHN0cnVj
dF9uYW1lLCBpZCwgdHN0cnVjdCwgcHJpbnQpCQlcDQogCWV4dGVybiBzdHJ1Y3QgZnRyYWNlX2V2
ZW50X2NhbGwJCQkJCVwNCmRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvdHJhY2VfaXJxc29mZi5j
IGIva2VybmVsL3RyYWNlL3RyYWNlX2lycXNvZmYuYw0KaW5kZXggMjBkYWQwZC4uMTYyNmUxYSAx
MDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS90cmFjZV9pcnFzb2ZmLmMNCisrKyBiL2tlcm5lbC90
cmFjZS90cmFjZV9pcnFzb2ZmLmMNCkBAIC0zMiw3ICszMiw3IEBAIGVudW0gew0KIA0KIHN0YXRp
YyBpbnQgdHJhY2VfdHlwZSBfX3JlYWRfbW9zdGx5Ow0KIA0KLXN0YXRpYyBpbnQgc2F2ZV9sYXRf
ZmxhZzsNCitzdGF0aWMgaW50IHNhdmVfZmxhZ3M7DQogDQogc3RhdGljIHZvaWQgc3RvcF9pcnFz
b2ZmX3RyYWNlcihzdHJ1Y3QgdHJhY2VfYXJyYXkgKnRyLCBpbnQgZ3JhcGgpOw0KIHN0YXRpYyBp
bnQgc3RhcnRfaXJxc29mZl90cmFjZXIoc3RydWN0IHRyYWNlX2FycmF5ICp0ciwgaW50IGdyYXBo
KTsNCkBAIC01NDYsOCArNTQ2LDExIEBAIHN0YXRpYyB2b2lkIHN0b3BfaXJxc29mZl90cmFjZXIo
c3RydWN0IHRyYWNlX2FycmF5ICp0ciwgaW50IGdyYXBoKQ0KIA0KIHN0YXRpYyB2b2lkIF9faXJx
c29mZl90cmFjZXJfaW5pdChzdHJ1Y3QgdHJhY2VfYXJyYXkgKnRyKQ0KIHsNCi0Jc2F2ZV9sYXRf
ZmxhZyA9IHRyYWNlX2ZsYWdzICYgVFJBQ0VfSVRFUl9MQVRFTkNZX0ZNVDsNCi0JdHJhY2VfZmxh
Z3MgfD0gVFJBQ0VfSVRFUl9MQVRFTkNZX0ZNVDsNCisJc2F2ZV9mbGFncyA9IHRyYWNlX2ZsYWdz
Ow0KKw0KKwkvKiBub24gb3ZlcndyaXRlIHNjcmV3cyB1cCB0aGUgbGF0ZW5jeSB0cmFjZXJzICov
DQorCXNldF90cmFjZXJfZmxhZyhUUkFDRV9JVEVSX09WRVJXUklURSwgMSk7DQorCXNldF90cmFj
ZXJfZmxhZyhUUkFDRV9JVEVSX0xBVEVOQ1lfRk1ULCAxKTsNCiANCiAJdHJhY2luZ19tYXhfbGF0
ZW5jeSA9IDA7DQogCWlycXNvZmZfdHJhY2UgPSB0cjsNCkBAIC01NjEsMTAgKzU2NCwxMyBAQCBz
dGF0aWMgdm9pZCBfX2lycXNvZmZfdHJhY2VyX2luaXQoc3RydWN0IHRyYWNlX2FycmF5ICp0cikN
CiANCiBzdGF0aWMgdm9pZCBpcnFzb2ZmX3RyYWNlcl9yZXNldChzdHJ1Y3QgdHJhY2VfYXJyYXkg
KnRyKQ0KIHsNCisJaW50IGxhdF9mbGFnID0gc2F2ZV9mbGFncyAmIFRSQUNFX0lURVJfTEFURU5D
WV9GTVQ7DQorCWludCBvdmVyd3JpdGVfZmxhZyA9IHNhdmVfZmxhZ3MgJiBUUkFDRV9JVEVSX09W
RVJXUklURTsNCisNCiAJc3RvcF9pcnFzb2ZmX3RyYWNlcih0ciwgaXNfZ3JhcGgoKSk7DQogDQot
CWlmICghc2F2ZV9sYXRfZmxhZykNCi0JCXRyYWNlX2ZsYWdzICY9IH5UUkFDRV9JVEVSX0xBVEVO
Q1lfRk1UOw0KKwlzZXRfdHJhY2VyX2ZsYWcoVFJBQ0VfSVRFUl9MQVRFTkNZX0ZNVCwgbGF0X2Zs
YWcpOw0KKwlzZXRfdHJhY2VyX2ZsYWcoVFJBQ0VfSVRFUl9PVkVSV1JJVEUsIG92ZXJ3cml0ZV9m
bGFnKTsNCiB9DQogDQogc3RhdGljIHZvaWQgaXJxc29mZl90cmFjZXJfc3RhcnQoc3RydWN0IHRy
YWNlX2FycmF5ICp0cikNCkBAIC01OTcsNiArNjAzLDcgQEAgc3RhdGljIHN0cnVjdCB0cmFjZXIg
aXJxc29mZl90cmFjZXIgX19yZWFkX21vc3RseSA9DQogCS5wcmludF9saW5lICAgICA9IGlycXNv
ZmZfcHJpbnRfbGluZSwNCiAJLmZsYWdzCQk9ICZ0cmFjZXJfZmxhZ3MsDQogCS5zZXRfZmxhZwk9
IGlycXNvZmZfc2V0X2ZsYWcsDQorCS5mbGFnX2NoYW5nZWQJPSB0cmFjZV9rZWVwX292ZXJ3cml0
ZSwNCiAjaWZkZWYgQ09ORklHX0ZUUkFDRV9TRUxGVEVTVA0KIAkuc2VsZnRlc3QgICAgPSB0cmFj
ZV9zZWxmdGVzdF9zdGFydHVwX2lycXNvZmYsDQogI2VuZGlmDQpAQCAtNjMwLDYgKzYzNyw3IEBA
IHN0YXRpYyBzdHJ1Y3QgdHJhY2VyIHByZWVtcHRvZmZfdHJhY2VyIF9fcmVhZF9tb3N0bHkgPQ0K
IAkucHJpbnRfbGluZSAgICAgPSBpcnFzb2ZmX3ByaW50X2xpbmUsDQogCS5mbGFncwkJPSAmdHJh
Y2VyX2ZsYWdzLA0KIAkuc2V0X2ZsYWcJPSBpcnFzb2ZmX3NldF9mbGFnLA0KKwkuZmxhZ19jaGFu
Z2VkCT0gdHJhY2Vfa2VlcF9vdmVyd3JpdGUsDQogI2lmZGVmIENPTkZJR19GVFJBQ0VfU0VMRlRF
U1QNCiAJLnNlbGZ0ZXN0ICAgID0gdHJhY2Vfc2VsZnRlc3Rfc3RhcnR1cF9wcmVlbXB0b2ZmLA0K
ICNlbmRpZg0KQEAgLTY2NSw2ICs2NzMsNyBAQCBzdGF0aWMgc3RydWN0IHRyYWNlciBwcmVlbXB0
aXJxc29mZl90cmFjZXIgX19yZWFkX21vc3RseSA9DQogCS5wcmludF9saW5lICAgICA9IGlycXNv
ZmZfcHJpbnRfbGluZSwNCiAJLmZsYWdzCQk9ICZ0cmFjZXJfZmxhZ3MsDQogCS5zZXRfZmxhZwk9
IGlycXNvZmZfc2V0X2ZsYWcsDQorCS5mbGFnX2NoYW5nZWQJPSB0cmFjZV9rZWVwX292ZXJ3cml0
ZSwNCiAjaWZkZWYgQ09ORklHX0ZUUkFDRV9TRUxGVEVTVA0KIAkuc2VsZnRlc3QgICAgPSB0cmFj
ZV9zZWxmdGVzdF9zdGFydHVwX3ByZWVtcHRpcnFzb2ZmLA0KICNlbmRpZg0KZGlmZiAtLWdpdCBh
L2tlcm5lbC90cmFjZS90cmFjZV9zY2hlZF93YWtldXAuYyBiL2tlcm5lbC90cmFjZS90cmFjZV9z
Y2hlZF93YWtldXAuYw0KaW5kZXggZTRhNzBjMC4uNjg1N2UwYyAxMDA2NDQNCi0tLSBhL2tlcm5l
bC90cmFjZS90cmFjZV9zY2hlZF93YWtldXAuYw0KKysrIGIva2VybmVsL3RyYWNlL3RyYWNlX3Nj
aGVkX3dha2V1cC5jDQpAQCAtMzYsNyArMzYsNyBAQCBzdGF0aWMgdm9pZCBfX3dha2V1cF9yZXNl
dChzdHJ1Y3QgdHJhY2VfYXJyYXkgKnRyKTsNCiBzdGF0aWMgaW50IHdha2V1cF9ncmFwaF9lbnRy
eShzdHJ1Y3QgZnRyYWNlX2dyYXBoX2VudCAqdHJhY2UpOw0KIHN0YXRpYyB2b2lkIHdha2V1cF9n
cmFwaF9yZXR1cm4oc3RydWN0IGZ0cmFjZV9ncmFwaF9yZXQgKnRyYWNlKTsNCiANCi1zdGF0aWMg
aW50IHNhdmVfbGF0X2ZsYWc7DQorc3RhdGljIGludCBzYXZlX2ZsYWdzOw0KIA0KICNkZWZpbmUg
VFJBQ0VfRElTUExBWV9HUkFQSCAgICAgMQ0KIA0KQEAgLTUyOCw4ICs1MjgsMTEgQEAgc3RhdGlj
IHZvaWQgc3RvcF93YWtldXBfdHJhY2VyKHN0cnVjdCB0cmFjZV9hcnJheSAqdHIpDQogDQogc3Rh
dGljIGludCBfX3dha2V1cF90cmFjZXJfaW5pdChzdHJ1Y3QgdHJhY2VfYXJyYXkgKnRyKQ0KIHsN
Ci0Jc2F2ZV9sYXRfZmxhZyA9IHRyYWNlX2ZsYWdzICYgVFJBQ0VfSVRFUl9MQVRFTkNZX0ZNVDsN
Ci0JdHJhY2VfZmxhZ3MgfD0gVFJBQ0VfSVRFUl9MQVRFTkNZX0ZNVDsNCisJc2F2ZV9mbGFncyA9
IHRyYWNlX2ZsYWdzOw0KKw0KKwkvKiBub24gb3ZlcndyaXRlIHNjcmV3cyB1cCB0aGUgbGF0ZW5j
eSB0cmFjZXJzICovDQorCXNldF90cmFjZXJfZmxhZyhUUkFDRV9JVEVSX09WRVJXUklURSwgMSk7
DQorCXNldF90cmFjZXJfZmxhZyhUUkFDRV9JVEVSX0xBVEVOQ1lfRk1ULCAxKTsNCiANCiAJdHJh
Y2luZ19tYXhfbGF0ZW5jeSA9IDA7DQogCXdha2V1cF90cmFjZSA9IHRyOw0KQEAgLTU1MSwxMiAr
NTU0LDE1IEBAIHN0YXRpYyBpbnQgd2FrZXVwX3J0X3RyYWNlcl9pbml0KHN0cnVjdCB0cmFjZV9h
cnJheSAqdHIpDQogDQogc3RhdGljIHZvaWQgd2FrZXVwX3RyYWNlcl9yZXNldChzdHJ1Y3QgdHJh
Y2VfYXJyYXkgKnRyKQ0KIHsNCisJaW50IGxhdF9mbGFnID0gc2F2ZV9mbGFncyAmIFRSQUNFX0lU
RVJfTEFURU5DWV9GTVQ7DQorCWludCBvdmVyd3JpdGVfZmxhZyA9IHNhdmVfZmxhZ3MgJiBUUkFD
RV9JVEVSX09WRVJXUklURTsNCisNCiAJc3RvcF93YWtldXBfdHJhY2VyKHRyKTsNCiAJLyogbWFr
ZSBzdXJlIHdlIHB1dCBiYWNrIGFueSB0YXNrcyB3ZSBhcmUgdHJhY2luZyAqLw0KIAl3YWtldXBf
cmVzZXQodHIpOw0KIA0KLQlpZiAoIXNhdmVfbGF0X2ZsYWcpDQotCQl0cmFjZV9mbGFncyAmPSB+
VFJBQ0VfSVRFUl9MQVRFTkNZX0ZNVDsNCisJc2V0X3RyYWNlcl9mbGFnKFRSQUNFX0lURVJfTEFU
RU5DWV9GTVQsIGxhdF9mbGFnKTsNCisJc2V0X3RyYWNlcl9mbGFnKFRSQUNFX0lURVJfT1ZFUldS
SVRFLCBvdmVyd3JpdGVfZmxhZyk7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIHdha2V1cF90cmFjZXJf
c3RhcnQoc3RydWN0IHRyYWNlX2FycmF5ICp0cikNCkBAIC01ODIsNiArNTg4LDcgQEAgc3RhdGlj
IHN0cnVjdCB0cmFjZXIgd2FrZXVwX3RyYWNlciBfX3JlYWRfbW9zdGx5ID0NCiAJLnByaW50X2xp
bmUJPSB3YWtldXBfcHJpbnRfbGluZSwNCiAJLmZsYWdzCQk9ICZ0cmFjZXJfZmxhZ3MsDQogCS5z
ZXRfZmxhZwk9IHdha2V1cF9zZXRfZmxhZywNCisJLmZsYWdfY2hhbmdlZAk9IHRyYWNlX2tlZXBf
b3ZlcndyaXRlLA0KICNpZmRlZiBDT05GSUdfRlRSQUNFX1NFTEZURVNUDQogCS5zZWxmdGVzdCAg
ICA9IHRyYWNlX3NlbGZ0ZXN0X3N0YXJ0dXBfd2FrZXVwLA0KICNlbmRpZg0KQEAgLTYwMyw2ICs2
MTAsNyBAQCBzdGF0aWMgc3RydWN0IHRyYWNlciB3YWtldXBfcnRfdHJhY2VyIF9fcmVhZF9tb3N0
bHkgPQ0KIAkucHJpbnRfbGluZQk9IHdha2V1cF9wcmludF9saW5lLA0KIAkuZmxhZ3MJCT0gJnRy
YWNlcl9mbGFncywNCiAJLnNldF9mbGFnCT0gd2FrZXVwX3NldF9mbGFnLA0KKwkuZmxhZ19jaGFu
Z2VkCT0gdHJhY2Vfa2VlcF9vdmVyd3JpdGUsDQogI2lmZGVmIENPTkZJR19GVFJBQ0VfU0VMRlRF
U1QNCiAJLnNlbGZ0ZXN0ICAgID0gdHJhY2Vfc2VsZnRlc3Rfc3RhcnR1cF93YWtldXAsDQogI2Vu
ZGlmDQpkaWZmIC0tZ2l0IGEvbW0vaHVnZXRsYi5jIGIvbW0vaHVnZXRsYi5jDQppbmRleCBkNmMw
ZmRmLi40YzdkNDJhIDEwMDY0NA0KLS0tIGEvbW0vaHVnZXRsYi5jDQorKysgYi9tbS9odWdldGxi
LmMNCkBAIC0yMDkyLDggKzIwOTIsMTIgQEAgaW50IGh1Z2V0bGJfcmVwb3J0X25vZGVfbWVtaW5m
byhpbnQgbmlkLCBjaGFyICpidWYpDQogLyogUmV0dXJuIHRoZSBudW1iZXIgcGFnZXMgb2YgbWVt
b3J5IHdlIHBoeXNpY2FsbHkgaGF2ZSwgaW4gUEFHRV9TSVpFIHVuaXRzLiAqLw0KIHVuc2lnbmVk
IGxvbmcgaHVnZXRsYl90b3RhbF9wYWdlcyh2b2lkKQ0KIHsNCi0Jc3RydWN0IGhzdGF0ZSAqaCA9
ICZkZWZhdWx0X2hzdGF0ZTsNCi0JcmV0dXJuIGgtPm5yX2h1Z2VfcGFnZXMgKiBwYWdlc19wZXJf
aHVnZV9wYWdlKGgpOw0KKwlzdHJ1Y3QgaHN0YXRlICpoOw0KKwl1bnNpZ25lZCBsb25nIG5yX3Rv
dGFsX3BhZ2VzID0gMDsNCisNCisJZm9yX2VhY2hfaHN0YXRlKGgpDQorCQlucl90b3RhbF9wYWdl
cyArPSBoLT5ucl9odWdlX3BhZ2VzICogcGFnZXNfcGVyX2h1Z2VfcGFnZShoKTsNCisJcmV0dXJu
IG5yX3RvdGFsX3BhZ2VzOw0KIH0NCiANCiBzdGF0aWMgaW50IGh1Z2V0bGJfYWNjdF9tZW1vcnko
c3RydWN0IGhzdGF0ZSAqaCwgbG9uZyBkZWx0YSkNCmRpZmYgLS1naXQgYS9uZXQvY29yZS9kZXYu
YyBiL25ldC9jb3JlL2Rldi5jDQppbmRleCAyYWFjNGVjLi5iMjNiYmJmIDEwMDY0NA0KLS0tIGEv
bmV0L2NvcmUvZGV2LmMNCisrKyBiL25ldC9jb3JlL2Rldi5jDQpAQCAtMzI5OSw2ICszMjk5LDcg
QEAgbmNsczoNCiAJCX0NCiAJCXN3aXRjaCAocnhfaGFuZGxlcigmc2tiKSkgew0KIAkJY2FzZSBS
WF9IQU5ETEVSX0NPTlNVTUVEOg0KKwkJCXJldCA9IE5FVF9SWF9TVUNDRVNTOw0KIAkJCWdvdG8g
b3V0Ow0KIAkJY2FzZSBSWF9IQU5ETEVSX0FOT1RIRVI6DQogCQkJZ290byBhbm90aGVyX3JvdW5k
Ow0KZGlmZiAtLWdpdCBhL25ldC9jb3JlL3J0bmV0bGluay5jIGIvbmV0L2NvcmUvcnRuZXRsaW5r
LmMNCmluZGV4IDUyMjljN2YuLjNiNWU2ODAgMTAwNjQ0DQotLS0gYS9uZXQvY29yZS9ydG5ldGxp
bmsuYw0KKysrIGIvbmV0L2NvcmUvcnRuZXRsaW5rLmMNCkBAIC05NzMsNiArOTczLDcgQEAgc3Rh
dGljIGludCBydG5sX2ZpbGxfaWZpbmZvKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYsDQogCQkJICogcmVwb3J0IGFueXRoaW5nLg0KIAkJCSAqLw0KIAkJCWl2aS5z
cG9vZmNoayA9IC0xOw0KKwkJCW1lbXNldChpdmkubWFjLCAwLCBzaXplb2YoaXZpLm1hYykpOw0K
IAkJCWlmIChkZXYtPm5ldGRldl9vcHMtPm5kb19nZXRfdmZfY29uZmlnKGRldiwgaSwgJml2aSkp
DQogCQkJCWJyZWFrOw0KIAkJCXZmX21hYy52ZiA9DQpAQCAtMjA0MSw3ICsyMDQyLDcgQEAgc3Rh
dGljIGludCBydG5ldGxpbmtfcmN2X21zZyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3Qgbmxt
c2doZHIgKm5saCkNCiAJCXN0cnVjdCBydGF0dHIgKmF0dHIgPSAodm9pZCAqKW5saCArIE5MTVNH
X0FMSUdOKG1pbl9sZW4pOw0KIA0KIAkJd2hpbGUgKFJUQV9PSyhhdHRyLCBhdHRybGVuKSkgew0K
LQkJCXVuc2lnbmVkIGZsYXZvciA9IGF0dHItPnJ0YV90eXBlOw0KKwkJCXVuc2lnbmVkIGludCBm
bGF2b3IgPSBhdHRyLT5ydGFfdHlwZSAmIE5MQV9UWVBFX01BU0s7DQogCQkJaWYgKGZsYXZvcikg
ew0KIAkJCQlpZiAoZmxhdm9yID4gcnRhX21heFtzel9pZHhdKQ0KIAkJCQkJcmV0dXJuIC1FSU5W
QUw7DQpkaWZmIC0tZ2l0IGEvbmV0L2RjYi9kY2JubC5jIGIvbmV0L2RjYi9kY2JubC5jDQppbmRl
eCBkODYwNTMwLi4yZjk1MTdkIDEwMDY0NA0KLS0tIGEvbmV0L2RjYi9kY2JubC5jDQorKysgYi9u
ZXQvZGNiL2RjYm5sLmMNCkBAIC0zMzYsNiArMzM2LDcgQEAgc3RhdGljIGludCBkY2JubF9nZXRw
ZXJtX2h3YWRkcihzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCBzdHJ1Y3QgbmxhdHRyICoqdGIs
DQogCWRjYi0+ZGNiX2ZhbWlseSA9IEFGX1VOU1BFQzsNCiAJZGNiLT5jbWQgPSBEQ0JfQ01EX0dQ
RVJNX0hXQUREUjsNCiANCisJbWVtc2V0KHBlcm1fYWRkciwgMCwgc2l6ZW9mKHBlcm1fYWRkcikp
Ow0KIAluZXRkZXYtPmRjYm5sX29wcy0+Z2V0cGVybWh3YWRkcihuZXRkZXYsIHBlcm1fYWRkcik7
DQogDQogCXJldCA9IG5sYV9wdXQoZGNibmxfc2tiLCBEQ0JfQVRUUl9QRVJNX0hXQUREUiwgc2l6
ZW9mKHBlcm1fYWRkciksDQpAQCAtMTIzOCw2ICsxMjM5LDcgQEAgc3RhdGljIGludCBkY2JubF9p
ZWVlX2ZpbGwoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikN
CiANCiAJaWYgKG9wcy0+aWVlZV9nZXRldHMpIHsNCiAJCXN0cnVjdCBpZWVlX2V0cyBldHM7DQor
CQltZW1zZXQoJmV0cywgMCwgc2l6ZW9mKGV0cykpOw0KIAkJZXJyID0gb3BzLT5pZWVlX2dldGV0
cyhuZXRkZXYsICZldHMpOw0KIAkJaWYgKCFlcnIpDQogCQkJTkxBX1BVVChza2IsIERDQl9BVFRS
X0lFRUVfRVRTLCBzaXplb2YoZXRzKSwgJmV0cyk7DQpAQCAtMTI0NSw2ICsxMjQ3LDcgQEAgc3Rh
dGljIGludCBkY2JubF9pZWVlX2ZpbGwoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9k
ZXZpY2UgKm5ldGRldikNCiANCiAJaWYgKG9wcy0+aWVlZV9nZXRwZmMpIHsNCiAJCXN0cnVjdCBp
ZWVlX3BmYyBwZmM7DQorCQltZW1zZXQoJnBmYywgMCwgc2l6ZW9mKHBmYykpOw0KIAkJZXJyID0g
b3BzLT5pZWVlX2dldHBmYyhuZXRkZXYsICZwZmMpOw0KIAkJaWYgKCFlcnIpDQogCQkJTkxBX1BV
VChza2IsIERDQl9BVFRSX0lFRUVfUEZDLCBzaXplb2YocGZjKSwgJnBmYyk7DQpAQCAtMTI3Nyw2
ICsxMjgwLDcgQEAgc3RhdGljIGludCBkY2JubF9pZWVlX2ZpbGwoc3RydWN0IHNrX2J1ZmYgKnNr
Yiwgc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikNCiAJLyogZ2V0IHBlZXIgaW5mbyBpZiBhdmFp
bGFibGUgKi8NCiAJaWYgKG9wcy0+aWVlZV9wZWVyX2dldGV0cykgew0KIAkJc3RydWN0IGllZWVf
ZXRzIGV0czsNCisJCW1lbXNldCgmZXRzLCAwLCBzaXplb2YoZXRzKSk7DQogCQllcnIgPSBvcHMt
PmllZWVfcGVlcl9nZXRldHMobmV0ZGV2LCAmZXRzKTsNCiAJCWlmICghZXJyKQ0KIAkJCU5MQV9Q
VVQoc2tiLCBEQ0JfQVRUUl9JRUVFX1BFRVJfRVRTLCBzaXplb2YoZXRzKSwgJmV0cyk7DQpAQCAt
MTI4NCw2ICsxMjg4LDcgQEAgc3RhdGljIGludCBkY2JubF9pZWVlX2ZpbGwoc3RydWN0IHNrX2J1
ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikNCiANCiAJaWYgKG9wcy0+aWVlZV9w
ZWVyX2dldHBmYykgew0KIAkJc3RydWN0IGllZWVfcGZjIHBmYzsNCisJCW1lbXNldCgmcGZjLCAw
LCBzaXplb2YocGZjKSk7DQogCQllcnIgPSBvcHMtPmllZWVfcGVlcl9nZXRwZmMobmV0ZGV2LCAm
cGZjKTsNCiAJCWlmICghZXJyKQ0KIAkJCU5MQV9QVVQoc2tiLCBEQ0JfQVRUUl9JRUVFX1BFRVJf
UEZDLCBzaXplb2YocGZjKSwgJnBmYyk7DQpAQCAtMTQ2Myw2ICsxNDY4LDcgQEAgc3RhdGljIGlu
dCBkY2JubF9jZWVfZmlsbChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgbmV0X2RldmljZSAq
bmV0ZGV2KQ0KIAkvKiBwZWVyIGluZm8gaWYgYXZhaWxhYmxlICovDQogCWlmIChvcHMtPmNlZV9w
ZWVyX2dldHBnKSB7DQogCQlzdHJ1Y3QgY2VlX3BnIHBnOw0KKwkJbWVtc2V0KCZwZywgMCwgc2l6
ZW9mKHBnKSk7DQogCQllcnIgPSBvcHMtPmNlZV9wZWVyX2dldHBnKG5ldGRldiwgJnBnKTsNCiAJ
CWlmICghZXJyKQ0KIAkJCU5MQV9QVVQoc2tiLCBEQ0JfQVRUUl9DRUVfUEVFUl9QRywgc2l6ZW9m
KHBnKSwgJnBnKTsNCkBAIC0xNDcwLDYgKzE0NzYsNyBAQCBzdGF0aWMgaW50IGRjYm5sX2NlZV9m
aWxsKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYpDQogDQog
CWlmIChvcHMtPmNlZV9wZWVyX2dldHBmYykgew0KIAkJc3RydWN0IGNlZV9wZmMgcGZjOw0KKwkJ
bWVtc2V0KCZwZmMsIDAsIHNpemVvZihwZmMpKTsNCiAJCWVyciA9IG9wcy0+Y2VlX3BlZXJfZ2V0
cGZjKG5ldGRldiwgJnBmYyk7DQogCQlpZiAoIWVycikNCiAJCQlOTEFfUFVUKHNrYiwgRENCX0FU
VFJfQ0VFX1BFRVJfUEZDLCBzaXplb2YocGZjKSwgJnBmYyk7DQpkaWZmIC0tZ2l0IGEvbmV0L2ll
ZWU4MDIxNTQvNmxvd3Bhbi5oIGIvbmV0L2llZWU4MDIxNTQvNmxvd3Bhbi5oDQppbmRleCA1ZDhj
ZjgwLi44YjA4NjZmIDEwMDY0NA0KLS0tIGEvbmV0L2llZWU4MDIxNTQvNmxvd3Bhbi5oDQorKysg
Yi9uZXQvaWVlZTgwMjE1NC82bG93cGFuLmgNCkBAIC04Nyw3ICs4Nyw3IEBADQogCShtZW1jbXAo
YWRkcjEsIGFkZHIyLCBsZW5ndGggPj4gMykgPT0gMCkNCiANCiAvKiBsb2NhbCBsaW5rLCBpLmUu
IEZFODA6Oi8xMCAqLw0KLSNkZWZpbmUgaXNfYWRkcl9saW5rX2xvY2FsKGEpICgoKGEpLT5zNl9h
ZGRyMTZbMF0pID09IDB4ODBGRSkNCisjZGVmaW5lIGlzX2FkZHJfbGlua19sb2NhbChhKSAoKChh
KS0+czZfYWRkcjE2WzBdKSA9PSBodG9ucygweEZFODApKQ0KIA0KIC8qDQogICogY2hlY2sgd2hl
dGhlciB3ZSBjYW4gY29tcHJlc3MgdGhlIElJRCB0byAxNiBiaXRzLA0KZGlmZiAtLWdpdCBhL25l
dC9pcHY0L2luZXRfZnJhZ21lbnQuYyBiL25ldC9pcHY0L2luZXRfZnJhZ21lbnQuYw0KaW5kZXgg
NWZmMmE1MS4uMjEwYjcxMCAxMDA2NDQNCi0tLSBhL25ldC9pcHY0L2luZXRfZnJhZ21lbnQuYw0K
KysrIGIvbmV0L2lwdjQvaW5ldF9mcmFnbWVudC5jDQpAQCAtMjEsNiArMjEsNyBAQA0KICNpbmNs
dWRlIDxsaW51eC9ydG5ldGxpbmsuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KIA0KKyNp
bmNsdWRlIDxuZXQvc29jay5oPg0KICNpbmNsdWRlIDxuZXQvaW5ldF9mcmFnLmg+DQogDQogc3Rh
dGljIHZvaWQgaW5ldF9mcmFnX3NlY3JldF9yZWJ1aWxkKHVuc2lnbmVkIGxvbmcgZHVtbXkpDQpA
QCAtMjcxLDYgKzI3Miw3IEBAIHN0cnVjdCBpbmV0X2ZyYWdfcXVldWUgKmluZXRfZnJhZ19maW5k
KHN0cnVjdCBuZXRuc19mcmFncyAqbmYsDQogew0KIAlzdHJ1Y3QgaW5ldF9mcmFnX3F1ZXVlICpx
Ow0KIAlzdHJ1Y3QgaGxpc3Rfbm9kZSAqbjsNCisJaW50IGRlcHRoID0gMDsNCiANCiAJaGxpc3Rf
Zm9yX2VhY2hfZW50cnkocSwgbiwgJmYtPmhhc2hbaGFzaF0sIGxpc3QpIHsNCiAJCWlmIChxLT5u
ZXQgPT0gbmYgJiYgZi0+bWF0Y2gocSwga2V5KSkgew0KQEAgLTI3OCw5ICsyODAsMjUgQEAgc3Ry
dWN0IGluZXRfZnJhZ19xdWV1ZSAqaW5ldF9mcmFnX2ZpbmQoc3RydWN0IG5ldG5zX2ZyYWdzICpu
ZiwNCiAJCQlyZWFkX3VubG9jaygmZi0+bG9jayk7DQogCQkJcmV0dXJuIHE7DQogCQl9DQorCQlk
ZXB0aCsrOw0KIAl9DQogCXJlYWRfdW5sb2NrKCZmLT5sb2NrKTsNCiANCi0JcmV0dXJuIGluZXRf
ZnJhZ19jcmVhdGUobmYsIGYsIGtleSk7DQorCWlmIChkZXB0aCA8PSBJTkVURlJBR1NfTUFYREVQ
VEgpDQorCQlyZXR1cm4gaW5ldF9mcmFnX2NyZWF0ZShuZiwgZiwga2V5KTsNCisJZWxzZQ0KKwkJ
cmV0dXJuIEVSUl9QVFIoLUVOT0JVRlMpOw0KIH0NCiBFWFBPUlRfU1lNQk9MKGluZXRfZnJhZ19m
aW5kKTsNCisNCit2b2lkIGluZXRfZnJhZ19tYXliZV93YXJuX292ZXJmbG93KHN0cnVjdCBpbmV0
X2ZyYWdfcXVldWUgKnEsDQorCQkJCSAgIGNvbnN0IGNoYXIgKnByZWZpeCkNCit7DQorCXN0YXRp
YyBjb25zdCBjaGFyIG1zZ1tdID0gImluZXRfZnJhZ19maW5kOiBGcmFnbWVudCBoYXNoIGJ1Y2tl
dCINCisJCSIgbGlzdCBsZW5ndGggZ3JldyBvdmVyIGxpbWl0ICIgX19zdHJpbmdpZnkoSU5FVEZS
QUdTX01BWERFUFRIKQ0KKwkJIi4gRHJvcHBpbmcgZnJhZ21lbnQuXG4iOw0KKw0KKwlpZiAoUFRS
X0VSUihxKSA9PSAtRU5PQlVGUykNCisJCUxJTUlUX05FVERFQlVHKEtFUk5fV0FSTklORyAiJXMl
cyIsIHByZWZpeCwgbXNnKTsNCit9DQorRVhQT1JUX1NZTUJPTChpbmV0X2ZyYWdfbWF5YmVfd2Fy
bl9vdmVyZmxvdyk7DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvaXBfZnJhZ21lbnQuYyBiL25ldC9p
cHY0L2lwX2ZyYWdtZW50LmMNCmluZGV4IGE0ZTcxMzEuLmIyY2ZlODMgMTAwNjQ0DQotLS0gYS9u
ZXQvaXB2NC9pcF9mcmFnbWVudC5jDQorKysgYi9uZXQvaXB2NC9pcF9mcmFnbWVudC5jDQpAQCAt
MjAsNiArMjAsOCBAQA0KICAqCQlQYXRyaWNrIE1jSGFyZHkgOglMUlUgcXVldWUgb2YgZnJhZyBo
ZWFkcyBmb3IgZXZpY3Rvci4NCiAgKi8NCiANCisjZGVmaW5lIHByX2ZtdChmbXQpICJJUHY0OiAi
IGZtdA0KKw0KICNpbmNsdWRlIDxsaW51eC9jb21waWxlci5oPg0KICNpbmNsdWRlIDxsaW51eC9t
b2R1bGUuaD4NCiAjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4NCkBAIC0yOTMsMTQgKzI5NSwxMiBA
QCBzdGF0aWMgaW5saW5lIHN0cnVjdCBpcHEgKmlwX2ZpbmQoc3RydWN0IG5ldCAqbmV0LCBzdHJ1
Y3QgaXBoZHIgKmlwaCwgdTMyIHVzZXIpDQogCWhhc2ggPSBpcHFoYXNoZm4oaXBoLT5pZCwgaXBo
LT5zYWRkciwgaXBoLT5kYWRkciwgaXBoLT5wcm90b2NvbCk7DQogDQogCXEgPSBpbmV0X2ZyYWdf
ZmluZCgmbmV0LT5pcHY0LmZyYWdzLCAmaXA0X2ZyYWdzLCAmYXJnLCBoYXNoKTsNCi0JaWYgKHEg
PT0gTlVMTCkNCi0JCWdvdG8gb3V0X25vbWVtOw0KKwlpZiAoSVNfRVJSX09SX05VTEwocSkpIHsN
CisJCWluZXRfZnJhZ19tYXliZV93YXJuX292ZXJmbG93KHEsIHByX2ZtdCgpKTsNCisJCXJldHVy
biBOVUxMOw0KKwl9DQogDQogCXJldHVybiBjb250YWluZXJfb2YocSwgc3RydWN0IGlwcSwgcSk7
DQotDQotb3V0X25vbWVtOg0KLQlMSU1JVF9ORVRERUJVRyhLRVJOX0VSUiAiaXBfZnJhZ19jcmVh
dGU6IG5vIG1lbW9yeSBsZWZ0ICFcbiIpOw0KLQlyZXR1cm4gTlVMTDsNCiB9DQogDQogLyogSXMg
dGhlIGZyYWdtZW50IHRvbyBmYXIgYWhlYWQgdG8gYmUgcGFydCBvZiBpcHE/ICovDQpkaWZmIC0t
Z2l0IGEvbmV0L2lwdjQvaXBfb3B0aW9ucy5jIGIvbmV0L2lwdjQvaXBfb3B0aW9ucy5jDQppbmRl
eCA0MmRkMWE5Li40MGViNGZjIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQvaXBfb3B0aW9ucy5jDQor
KysgYi9uZXQvaXB2NC9pcF9vcHRpb25zLmMNCkBAIC0zNTgsNyArMzU4LDYgQEAgaW50IGlwX29w
dGlvbnNfY29tcGlsZShzdHJ1Y3QgbmV0ICpuZXQsDQogCQkJCX0NCiAJCQkJc3dpdGNoIChvcHRw
dHJbM10mMHhGKSB7DQogCQkJCSAgICAgIGNhc2UgSVBPUFRfVFNfVFNPTkxZOg0KLQkJCQkJb3B0
LT50cyA9IG9wdHB0ciAtIGlwaDsNCiAJCQkJCWlmIChza2IpDQogCQkJCQkJdGltZXB0ciA9ICZv
cHRwdHJbb3B0cHRyWzJdLTFdOw0KIAkJCQkJb3B0LT50c19uZWVkdGltZSA9IDE7DQpAQCAtMzY5
LDcgKzM2OCw2IEBAIGludCBpcF9vcHRpb25zX2NvbXBpbGUoc3RydWN0IG5ldCAqbmV0LA0KIAkJ
CQkJCXBwX3B0ciA9IG9wdHB0ciArIDI7DQogCQkJCQkJZ290byBlcnJvcjsNCiAJCQkJCX0NCi0J
CQkJCW9wdC0+dHMgPSBvcHRwdHIgLSBpcGg7DQogCQkJCQlpZiAocnQpICB7DQogCQkJCQkJbWVt
Y3B5KCZvcHRwdHJbb3B0cHRyWzJdLTFdLCAmcnQtPnJ0X3NwZWNfZHN0LCA0KTsNCiAJCQkJCQl0
aW1lcHRyID0gJm9wdHB0cltvcHRwdHJbMl0rM107DQpAQCAtMzgzLDcgKzM4MSw2IEBAIGludCBp
cF9vcHRpb25zX2NvbXBpbGUoc3RydWN0IG5ldCAqbmV0LA0KIAkJCQkJCXBwX3B0ciA9IG9wdHB0
ciArIDI7DQogCQkJCQkJZ290byBlcnJvcjsNCiAJCQkJCX0NCi0JCQkJCW9wdC0+dHMgPSBvcHRw
dHIgLSBpcGg7DQogCQkJCQl7DQogCQkJCQkJX19iZTMyIGFkZHI7DQogCQkJCQkJbWVtY3B5KCZh
ZGRyLCAmb3B0cHRyW29wdHB0clsyXS0xXSwgNCk7DQpAQCAtNDE2LDEyICs0MTMsMTIgQEAgaW50
IGlwX29wdGlvbnNfY29tcGlsZShzdHJ1Y3QgbmV0ICpuZXQsDQogCQkJCQlwcF9wdHIgPSBvcHRw
dHIgKyAzOw0KIAkJCQkJZ290byBlcnJvcjsNCiAJCQkJfQ0KLQkJCQlvcHQtPnRzID0gb3B0cHRy
IC0gaXBoOw0KIAkJCQlpZiAoc2tiKSB7DQogCQkJCQlvcHRwdHJbM10gPSAob3B0cHRyWzNdJjB4
Ril8KChvdmVyZmxvdysxKTw8NCk7DQogCQkJCQlvcHQtPmlzX2NoYW5nZWQgPSAxOw0KIAkJCQl9
DQogCQkJfQ0KKwkJCW9wdC0+dHMgPSBvcHRwdHIgLSBpcGg7DQogCQkJYnJlYWs7DQogCQkgICAg
ICBjYXNlIElQT1BUX1JBOg0KIAkJCWlmIChvcHRsZW4gPCA0KSB7DQpkaWZmIC0tZ2l0IGEvbmV0
L2lwdjQvdGNwLmMgYi9uZXQvaXB2NC90Y3AuYw0KaW5kZXggNTJlZGJiOC4uZmUzODFjMiAxMDA2
NDQNCi0tLSBhL25ldC9pcHY0L3RjcC5jDQorKysgYi9uZXQvaXB2NC90Y3AuYw0KQEAgLTcwNCw3
ICs3MDQsNyBAQCBzdHJ1Y3Qgc2tfYnVmZiAqc2tfc3RyZWFtX2FsbG9jX3NrYihzdHJ1Y3Qgc29j
ayAqc2ssIGludCBzaXplLCBnZnBfdCBnZnApDQogCQkJICogTWFrZSBzdXJlIHRoYXQgd2UgaGF2
ZSBleGFjdGx5IHNpemUgYnl0ZXMNCiAJCQkgKiBhdmFpbGFibGUgdG8gdGhlIGNhbGxlciwgbm8g
bW9yZSwgbm8gbGVzcy4NCiAJCQkgKi8NCi0JCQlza2ItPmF2YWlsX3NpemUgPSBzaXplOw0KKwkJ
CXNrYi0+cmVzZXJ2ZWRfdGFpbHJvb20gPSBza2ItPmVuZCAtIHNrYi0+dGFpbCAtIHNpemU7DQog
CQkJcmV0dXJuIHNrYjsNCiAJCX0NCiAJCV9fa2ZyZWVfc2tiKHNrYik7DQpkaWZmIC0tZ2l0IGEv
bmV0L2lwdjQvdGNwX2lucHV0LmMgYi9uZXQvaXB2NC90Y3BfaW5wdXQuYw0KaW5kZXggZTg2NWVk
MS4uMWIxZjdhZiAxMDA2NDQNCi0tLSBhL25ldC9pcHY0L3RjcF9pbnB1dC5jDQorKysgYi9uZXQv
aXB2NC90Y3BfaW5wdXQuYw0KQEAgLTU0OTQsNiArNTQ5NCw5IEBAIGludCB0Y3BfcmN2X2VzdGFi
bGlzaGVkKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJCQkJaWYgKHRj
cF9jaGVja3N1bV9jb21wbGV0ZV91c2VyKHNrLCBza2IpKQ0KIAkJCQkJZ290byBjc3VtX2Vycm9y
Ow0KIA0KKwkJCQlpZiAoKGludClza2ItPnRydWVzaXplID4gc2stPnNrX2ZvcndhcmRfYWxsb2Mp
DQorCQkJCQlnb3RvIHN0ZXA1Ow0KKw0KIAkJCQkvKiBQcmVkaWN0ZWQgcGFja2V0IGlzIGluIHdp
bmRvdyBieSBkZWZpbml0aW9uLg0KIAkJCQkgKiBzZXEgPT0gcmN2X254dCBhbmQgcmN2X3d1cCA8
PSByY3Zfbnh0Lg0KIAkJCQkgKiBIZW5jZSwgY2hlY2sgc2VxPD1yY3Zfd3VwIHJlZHVjZXMgdG86
DQpAQCAtNTUwNSw5ICs1NTA4LDYgQEAgaW50IHRjcF9yY3ZfZXN0YWJsaXNoZWQoc3RydWN0IHNv
Y2sgKnNrLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIA0KIAkJCQl0Y3BfcmN2X3J0dF9tZWFzdXJl
X3RzKHNrLCBza2IpOw0KIA0KLQkJCQlpZiAoKGludClza2ItPnRydWVzaXplID4gc2stPnNrX2Zv
cndhcmRfYWxsb2MpDQotCQkJCQlnb3RvIHN0ZXA1Ow0KLQ0KIAkJCQlORVRfSU5DX1NUQVRTX0JI
KHNvY2tfbmV0KHNrKSwgTElOVVhfTUlCX1RDUEhQSElUUyk7DQogDQogCQkJCS8qIEJ1bGsgZGF0
YSB0cmFuc2ZlcjogcmVjZWl2ZXIgKi8NCmRpZmYgLS1naXQgYS9uZXQvaXB2NC90Y3Bfb3V0cHV0
LmMgYi9uZXQvaXB2NC90Y3Bfb3V0cHV0LmMNCmluZGV4IDkyMWNiYWMuLjliYjc0MDAgMTAwNjQ0
DQotLS0gYS9uZXQvaXB2NC90Y3Bfb3V0cHV0LmMNCisrKyBiL25ldC9pcHY0L3RjcF9vdXRwdXQu
Yw0KQEAgLTEwOTYsNyArMTA5Niw2IEBAIHN0YXRpYyB2b2lkIF9fcHNrYl90cmltX2hlYWQoc3Ry
dWN0IHNrX2J1ZmYgKnNrYiwgaW50IGxlbikNCiAJZWF0ID0gbWluX3QoaW50LCBsZW4sIHNrYl9o
ZWFkbGVuKHNrYikpOw0KIAlpZiAoZWF0KSB7DQogCQlfX3NrYl9wdWxsKHNrYiwgZWF0KTsNCi0J
CXNrYi0+YXZhaWxfc2l6ZSAtPSBlYXQ7DQogCQlsZW4gLT0gZWF0Ow0KIAkJaWYgKCFsZW4pDQog
CQkJcmV0dXJuOw0KZGlmZiAtLWdpdCBhL25ldC9pcHY2L2lwNl9pbnB1dC5jIGIvbmV0L2lwdjYv
aXA2X2lucHV0LmMNCmluZGV4IGE0NmM2NGUuLmY4ZDI0ZGQgMTAwNjQ0DQotLS0gYS9uZXQvaXB2
Ni9pcDZfaW5wdXQuYw0KKysrIGIvbmV0L2lwdjYvaXA2X2lucHV0LmMNCkBAIC0yNjUsNyArMjY1
LDggQEAgaW50IGlwNl9tY19pbnB1dChzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KIAkgKiAgICAgIElQ
djYgbXVsdGljYXN0IHJvdXRlciBtb2RlIGlzIG5vdyBzdXBwb3J0ZWQgOykNCiAJICovDQogCWlm
IChkZXZfbmV0KHNrYi0+ZGV2KS0+aXB2Ni5kZXZjb25mX2FsbC0+bWNfZm9yd2FyZGluZyAmJg0K
LQkgICAgIShpcHY2X2FkZHJfdHlwZSgmaGRyLT5kYWRkcikgJiBJUFY2X0FERFJfTElOS0xPQ0FM
KSAmJg0KKwkgICAgIShpcHY2X2FkZHJfdHlwZSgmaGRyLT5kYWRkcikgJg0KKwkgICAgICAoSVBW
Nl9BRERSX0xPT1BCQUNLfElQVjZfQUREUl9MSU5LTE9DQUwpKSAmJg0KIAkgICAgbGlrZWx5KCEo
SVA2Q0Ioc2tiKS0+ZmxhZ3MgJiBJUDZTS0JfRk9SV0FSREVEKSkpIHsNCiAJCS8qDQogCQkgKiBP
a2F5LCB3ZSB0cnkgdG8gZm9yd2FyZCAtIHNwbGl0IGFuZCBkdXBsaWNhdGUNCmRpZmYgLS1naXQg
YS9uZXQvaXB2Ni9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3JlYXNtLmMgYi9uZXQvaXB2Ni9uZXRm
aWx0ZXIvbmZfY29ubnRyYWNrX3JlYXNtLmMNCmluZGV4IDM4ZjAwYjAuLjUyZTJmNjUgMTAwNjQ0
DQotLS0gYS9uZXQvaXB2Ni9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3JlYXNtLmMNCisrKyBiL25l
dC9pcHY2L25ldGZpbHRlci9uZl9jb25udHJhY2tfcmVhc20uYw0KQEAgLTE0LDYgKzE0LDggQEAN
CiAgKiAyIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJz
aW9uLg0KICAqLw0KIA0KKyNkZWZpbmUgcHJfZm10KGZtdCkgIklQdjYtbmY6ICIgZm10DQorDQog
I2luY2x1ZGUgPGxpbnV4L2Vycm5vLmg+DQogI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+DQogI2lu
Y2x1ZGUgPGxpbnV4L3N0cmluZy5oPg0KQEAgLTE3NiwxMyArMTc4LDEyIEBAIGZxX2ZpbmQoX19i
ZTMyIGlkLCB1MzIgdXNlciwgc3RydWN0IGluNl9hZGRyICpzcmMsIHN0cnVjdCBpbjZfYWRkciAq
ZHN0KQ0KIA0KIAlxID0gaW5ldF9mcmFnX2ZpbmQoJm5mX2luaXRfZnJhZ3MsICZuZl9mcmFncywg
JmFyZywgaGFzaCk7DQogCWxvY2FsX2JoX2VuYWJsZSgpOw0KLQlpZiAocSA9PSBOVUxMKQ0KLQkJ
Z290byBvb207DQorCWlmIChJU19FUlJfT1JfTlVMTChxKSkgew0KKwkJaW5ldF9mcmFnX21heWJl
X3dhcm5fb3ZlcmZsb3cocSwgcHJfZm10KCkpOw0KKwkJcmV0dXJuIE5VTEw7DQorCX0NCiANCiAJ
cmV0dXJuIGNvbnRhaW5lcl9vZihxLCBzdHJ1Y3QgbmZfY3RfZnJhZzZfcXVldWUsIHEpOw0KLQ0K
LW9vbToNCi0JcmV0dXJuIE5VTEw7DQogfQ0KIA0KIA0KZGlmZiAtLWdpdCBhL25ldC9pcHY2L3Jl
YXNzZW1ibHkuYyBiL25ldC9pcHY2L3JlYXNzZW1ibHkuYw0KaW5kZXggZGZiMTY0ZS4uMmIwYTRj
YSAxMDA2NDQNCi0tLSBhL25ldC9pcHY2L3JlYXNzZW1ibHkuYw0KKysrIGIvbmV0L2lwdjYvcmVh
c3NlbWJseS5jDQpAQCAtMjYsNiArMjYsOSBAQA0KICAqCVlPU0hJRlVKSSxILiBAVVNBR0kJQWx3
YXlzIHJlbW92ZSBmcmFnbWVudCBoZWFkZXIgdG8NCiAgKgkJCQljYWxjdWxhdGUgSUNWIGNvcnJl
Y3RseS4NCiAgKi8NCisNCisjZGVmaW5lIHByX2ZtdChmbXQpICJJUHY2OiAiIGZtdA0KKw0KICNp
bmNsdWRlIDxsaW51eC9lcnJuby5oPg0KICNpbmNsdWRlIDxsaW51eC90eXBlcy5oPg0KICNpbmNs
dWRlIDxsaW51eC9zdHJpbmcuaD4NCkBAIC0yNDAsOSArMjQzLDEwIEBAIGZxX2ZpbmQoc3RydWN0
IG5ldCAqbmV0LCBfX2JlMzIgaWQsIGNvbnN0IHN0cnVjdCBpbjZfYWRkciAqc3JjLCBjb25zdCBz
dHJ1Y3QgaW42DQogCWhhc2ggPSBpbmV0Nl9oYXNoX2ZyYWcoaWQsIHNyYywgZHN0LCBpcDZfZnJh
Z3Mucm5kKTsNCiANCiAJcSA9IGluZXRfZnJhZ19maW5kKCZuZXQtPmlwdjYuZnJhZ3MsICZpcDZf
ZnJhZ3MsICZhcmcsIGhhc2gpOw0KLQlpZiAocSA9PSBOVUxMKQ0KKwlpZiAoSVNfRVJSX09SX05V
TEwocSkpIHsNCisJCWluZXRfZnJhZ19tYXliZV93YXJuX292ZXJmbG93KHEsIHByX2ZtdCgpKTsN
CiAJCXJldHVybiBOVUxMOw0KLQ0KKwl9DQogCXJldHVybiBjb250YWluZXJfb2YocSwgc3RydWN0
IGZyYWdfcXVldWUsIHEpOw0KIH0NCiANCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9yb3V0ZS5jIGIv
bmV0L2lwdjYvcm91dGUuYw0KaW5kZXggNzkxYzFmYS4uMThlYTczYyAxMDA2NDQNCi0tLSBhL25l
dC9pcHY2L3JvdXRlLmMNCisrKyBiL25ldC9pcHY2L3JvdXRlLmMNCkBAIC0xOTIwLDcgKzE5MjAs
OCBAQCB2b2lkIHJ0Nl9wdXJnZV9kZmx0X3JvdXRlcnMoc3RydWN0IG5ldCAqbmV0KQ0KIHJlc3Rh
cnQ6DQogCXJlYWRfbG9ja19iaCgmdGFibGUtPnRiNl9sb2NrKTsNCiAJZm9yIChydCA9IHRhYmxl
LT50YjZfcm9vdC5sZWFmOyBydDsgcnQgPSBydC0+ZHN0LnJ0Nl9uZXh0KSB7DQotCQlpZiAocnQt
PnJ0NmlfZmxhZ3MgJiAoUlRGX0RFRkFVTFQgfCBSVEZfQUREUkNPTkYpKSB7DQorCQlpZiAocnQt
PnJ0NmlfZmxhZ3MgJiAoUlRGX0RFRkFVTFQgfCBSVEZfQUREUkNPTkYpICYmDQorCQkgICAgKCFy
dC0+cnQ2aV9pZGV2IHx8IHJ0LT5ydDZpX2lkZXYtPmNuZi5hY2NlcHRfcmEgIT0gMikpIHsNCiAJ
CQlkc3RfaG9sZCgmcnQtPmRzdCk7DQogCQkJcmVhZF91bmxvY2tfYmgoJnRhYmxlLT50YjZfbG9j
ayk7DQogCQkJaXA2X2RlbF9ydChydCk7DQpkaWZmIC0tZ2l0IGEvbmV0L2wydHAvbDJ0cF9wcHAu
YyBiL25ldC9sMnRwL2wydHBfcHBwLmMNCmluZGV4IGIxYmQxNmYuLjZmNjAxNzUgMTAwNjQ0DQot
LS0gYS9uZXQvbDJ0cC9sMnRwX3BwcC5jDQorKysgYi9uZXQvbDJ0cC9sMnRwX3BwcC5jDQpAQCAt
MzYwLDYgKzM2MCw3IEBAIHN0YXRpYyBpbnQgcHBwb2wydHBfc2VuZG1zZyhzdHJ1Y3Qga2lvY2Ig
KmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doDQogCWwydHBfeG1pdF9za2Io
c2Vzc2lvbiwgc2tiLCBzZXNzaW9uLT5oZHJfbGVuKTsNCiANCiAJc29ja19wdXQocHMtPnR1bm5l
bF9zb2NrKTsNCisJc29ja19wdXQoc2spOw0KIA0KIAlyZXR1cm4gZXJyb3I7DQogDQpkaWZmIC0t
Z2l0IGEvbmV0L25ldGxhYmVsL25ldGxhYmVsX3VubGFiZWxlZC5jIGIvbmV0L25ldGxhYmVsL25l
dGxhYmVsX3VubGFiZWxlZC5jDQppbmRleCBkNDYzZjVhLi4yMzI2N2IzIDEwMDY0NA0KLS0tIGEv
bmV0L25ldGxhYmVsL25ldGxhYmVsX3VubGFiZWxlZC5jDQorKysgYi9uZXQvbmV0bGFiZWwvbmV0
bGFiZWxfdW5sYWJlbGVkLmMNCkBAIC0xMTg5LDggKzExODksNiBAQCBzdGF0aWMgaW50IG5ldGxi
bF91bmxhYmVsX3N0YXRpY2xpc3Qoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJc3RydWN0IG5ldGxi
bF91bmxoc2hfd2Fsa19hcmcgY2JfYXJnOw0KIAl1MzIgc2tpcF9ia3QgPSBjYi0+YXJnc1swXTsN
CiAJdTMyIHNraXBfY2hhaW4gPSBjYi0+YXJnc1sxXTsNCi0JdTMyIHNraXBfYWRkcjQgPSBjYi0+
YXJnc1syXTsNCi0JdTMyIHNraXBfYWRkcjYgPSBjYi0+YXJnc1szXTsNCiAJdTMyIGl0ZXJfYmt0
Ow0KIAl1MzIgaXRlcl9jaGFpbiA9IDAsIGl0ZXJfYWRkcjQgPSAwLCBpdGVyX2FkZHI2ID0gMDsN
CiAJc3RydWN0IG5ldGxibF91bmxoc2hfaWZhY2UgKmlmYWNlOw0KQEAgLTEyMTUsNyArMTIxMyw3
IEBAIHN0YXRpYyBpbnQgbmV0bGJsX3VubGFiZWxfc3RhdGljbGlzdChzdHJ1Y3Qgc2tfYnVmZiAq
c2tiLA0KIAkJCQljb250aW51ZTsNCiAJCQluZXRsYmxfYWY0bGlzdF9mb3JlYWNoX3JjdShhZGRy
NCwNCiAJCQkJCQkgICAmaWZhY2UtPmFkZHI0X2xpc3QpIHsNCi0JCQkJaWYgKGl0ZXJfYWRkcjQr
KyA8IHNraXBfYWRkcjQpDQorCQkJCWlmIChpdGVyX2FkZHI0KysgPCBjYi0+YXJnc1syXSkNCiAJ
CQkJCWNvbnRpbnVlOw0KIAkJCQlpZiAobmV0bGJsX3VubGFiZWxfc3RhdGljbGlzdF9nZW4oDQog
CQkJCQkgICAgICBOTEJMX1VOTEFCRUxfQ19TVEFUSUNMSVNULA0KQEAgLTEyMzEsNyArMTIyOSw3
IEBAIHN0YXRpYyBpbnQgbmV0bGJsX3VubGFiZWxfc3RhdGljbGlzdChzdHJ1Y3Qgc2tfYnVmZiAq
c2tiLA0KICNpZiBkZWZpbmVkKENPTkZJR19JUFY2KSB8fCBkZWZpbmVkKENPTkZJR19JUFY2X01P
RFVMRSkNCiAJCQluZXRsYmxfYWY2bGlzdF9mb3JlYWNoX3JjdShhZGRyNiwNCiAJCQkJCQkgICAm
aWZhY2UtPmFkZHI2X2xpc3QpIHsNCi0JCQkJaWYgKGl0ZXJfYWRkcjYrKyA8IHNraXBfYWRkcjYp
DQorCQkJCWlmIChpdGVyX2FkZHI2KysgPCBjYi0+YXJnc1szXSkNCiAJCQkJCWNvbnRpbnVlOw0K
IAkJCQlpZiAobmV0bGJsX3VubGFiZWxfc3RhdGljbGlzdF9nZW4oDQogCQkJCQkgICAgICBOTEJM
X1VOTEFCRUxfQ19TVEFUSUNMSVNULA0KQEAgLTEyNTAsMTAgKzEyNDgsMTAgQEAgc3RhdGljIGlu
dCBuZXRsYmxfdW5sYWJlbF9zdGF0aWNsaXN0KHN0cnVjdCBza19idWZmICpza2IsDQogDQogdW5s
YWJlbF9zdGF0aWNsaXN0X3JldHVybjoNCiAJcmN1X3JlYWRfdW5sb2NrKCk7DQotCWNiLT5hcmdz
WzBdID0gc2tpcF9ia3Q7DQotCWNiLT5hcmdzWzFdID0gc2tpcF9jaGFpbjsNCi0JY2ItPmFyZ3Nb
Ml0gPSBza2lwX2FkZHI0Ow0KLQljYi0+YXJnc1szXSA9IHNraXBfYWRkcjY7DQorCWNiLT5hcmdz
WzBdID0gaXRlcl9ia3Q7DQorCWNiLT5hcmdzWzFdID0gaXRlcl9jaGFpbjsNCisJY2ItPmFyZ3Nb
Ml0gPSBpdGVyX2FkZHI0Ow0KKwljYi0+YXJnc1szXSA9IGl0ZXJfYWRkcjY7DQogCXJldHVybiBz
a2ItPmxlbjsNCiB9DQogDQpAQCAtMTI3MywxMiArMTI3MSw5IEBAIHN0YXRpYyBpbnQgbmV0bGJs
X3VubGFiZWxfc3RhdGljbGlzdGRlZihzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIHsNCiAJc3RydWN0
IG5ldGxibF91bmxoc2hfd2Fsa19hcmcgY2JfYXJnOw0KIAlzdHJ1Y3QgbmV0bGJsX3VubGhzaF9p
ZmFjZSAqaWZhY2U7DQotCXUzMiBza2lwX2FkZHI0ID0gY2ItPmFyZ3NbMF07DQotCXUzMiBza2lw
X2FkZHI2ID0gY2ItPmFyZ3NbMV07DQotCXUzMiBpdGVyX2FkZHI0ID0gMDsNCisJdTMyIGl0ZXJf
YWRkcjQgPSAwLCBpdGVyX2FkZHI2ID0gMDsNCiAJc3RydWN0IG5ldGxibF9hZjRsaXN0ICphZGRy
NDsNCiAjaWYgZGVmaW5lZChDT05GSUdfSVBWNikgfHwgZGVmaW5lZChDT05GSUdfSVBWNl9NT0RV
TEUpDQotCXUzMiBpdGVyX2FkZHI2ID0gMDsNCiAJc3RydWN0IG5ldGxibF9hZjZsaXN0ICphZGRy
NjsNCiAjZW5kaWYNCiANCkBAIC0xMjkyLDcgKzEyODcsNyBAQCBzdGF0aWMgaW50IG5ldGxibF91
bmxhYmVsX3N0YXRpY2xpc3RkZWYoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJCWdvdG8gdW5sYWJl
bF9zdGF0aWNsaXN0ZGVmX3JldHVybjsNCiANCiAJbmV0bGJsX2FmNGxpc3RfZm9yZWFjaF9yY3Uo
YWRkcjQsICZpZmFjZS0+YWRkcjRfbGlzdCkgew0KLQkJaWYgKGl0ZXJfYWRkcjQrKyA8IHNraXBf
YWRkcjQpDQorCQlpZiAoaXRlcl9hZGRyNCsrIDwgY2ItPmFyZ3NbMF0pDQogCQkJY29udGludWU7
DQogCQlpZiAobmV0bGJsX3VubGFiZWxfc3RhdGljbGlzdF9nZW4oTkxCTF9VTkxBQkVMX0NfU1RB
VElDTElTVERFRiwNCiAJCQkJCSAgICAgIGlmYWNlLA0KQEAgLTEzMDUsNyArMTMwMCw3IEBAIHN0
YXRpYyBpbnQgbmV0bGJsX3VubGFiZWxfc3RhdGljbGlzdGRlZihzdHJ1Y3Qgc2tfYnVmZiAqc2ti
LA0KIAl9DQogI2lmIGRlZmluZWQoQ09ORklHX0lQVjYpIHx8IGRlZmluZWQoQ09ORklHX0lQVjZf
TU9EVUxFKQ0KIAluZXRsYmxfYWY2bGlzdF9mb3JlYWNoX3JjdShhZGRyNiwgJmlmYWNlLT5hZGRy
Nl9saXN0KSB7DQotCQlpZiAoaXRlcl9hZGRyNisrIDwgc2tpcF9hZGRyNikNCisJCWlmIChpdGVy
X2FkZHI2KysgPCBjYi0+YXJnc1sxXSkNCiAJCQljb250aW51ZTsNCiAJCWlmIChuZXRsYmxfdW5s
YWJlbF9zdGF0aWNsaXN0X2dlbihOTEJMX1VOTEFCRUxfQ19TVEFUSUNMSVNUREVGLA0KIAkJCQkJ
ICAgICAgaWZhY2UsDQpAQCAtMTMyMCw4ICsxMzE1LDggQEAgc3RhdGljIGludCBuZXRsYmxfdW5s
YWJlbF9zdGF0aWNsaXN0ZGVmKHN0cnVjdCBza19idWZmICpza2IsDQogDQogdW5sYWJlbF9zdGF0
aWNsaXN0ZGVmX3JldHVybjoNCiAJcmN1X3JlYWRfdW5sb2NrKCk7DQotCWNiLT5hcmdzWzBdID0g
c2tpcF9hZGRyNDsNCi0JY2ItPmFyZ3NbMV0gPSBza2lwX2FkZHI2Ow0KKwljYi0+YXJnc1swXSA9
IGl0ZXJfYWRkcjQ7DQorCWNiLT5hcmdzWzFdID0gaXRlcl9hZGRyNjsNCiAJcmV0dXJuIHNrYi0+
bGVuOw0KIH0NCiANCmRpZmYgLS1naXQgYS9uZXQvcmRzL21lc3NhZ2UuYyBiL25ldC9yZHMvbWVz
c2FnZS5jDQppbmRleCBmMGE0NjU4Li5hZmY1ODljIDEwMDY0NA0KLS0tIGEvbmV0L3Jkcy9tZXNz
YWdlLmMNCisrKyBiL25ldC9yZHMvbWVzc2FnZS5jDQpAQCAtMTk3LDYgKzE5Nyw5IEBAIHN0cnVj
dCByZHNfbWVzc2FnZSAqcmRzX21lc3NhZ2VfYWxsb2ModW5zaWduZWQgaW50IGV4dHJhX2xlbiwg
Z2ZwX3QgZ2ZwKQ0KIHsNCiAJc3RydWN0IHJkc19tZXNzYWdlICpybTsNCiANCisJaWYgKGV4dHJh
X2xlbiA+IEtNQUxMT0NfTUFYX1NJWkUgLSBzaXplb2Yoc3RydWN0IHJkc19tZXNzYWdlKSkNCisJ
CXJldHVybiBOVUxMOw0KKw0KIAlybSA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCByZHNfbWVzc2Fn
ZSkgKyBleHRyYV9sZW4sIGdmcCk7DQogCWlmICghcm0pDQogCQlnb3RvIG91dDsNCmRpZmYgLS1n
aXQgYS9uZXQvc2N0cC9hc3NvY2lvbGEuYyBiL25ldC9zY3RwL2Fzc29jaW9sYS5jDQppbmRleCBh
Y2QyZWRiLi4zYzA0NjkyIDEwMDY0NA0KLS0tIGEvbmV0L3NjdHAvYXNzb2Npb2xhLmMNCisrKyBi
L25ldC9zY3RwL2Fzc29jaW9sYS5jDQpAQCAtMTA1MCw3ICsxMDUwLDcgQEAgc3RydWN0IHNjdHBf
dHJhbnNwb3J0ICpzY3RwX2Fzc29jX2xvb2t1cF90c24oc3RydWN0IHNjdHBfYXNzb2NpYXRpb24g
KmFzb2MsDQogCQkJdHJhbnNwb3J0cykgew0KIA0KIAkJaWYgKHRyYW5zcG9ydCA9PSBhY3RpdmUp
DQotCQkJYnJlYWs7DQorCQkJY29udGludWU7DQogCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGNodW5r
LCAmdHJhbnNwb3J0LT50cmFuc21pdHRlZCwNCiAJCQkJdHJhbnNtaXR0ZWRfbGlzdCkgew0KIAkJ
CWlmIChrZXkgPT0gY2h1bmstPnN1YmguZGF0YV9oZHItPnRzbikgew0KZGlmZiAtLWdpdCBhL25l
dC9zY3RwL3NtX3N0YXRlZnVucy5jIGIvbmV0L3NjdHAvc21fc3RhdGVmdW5zLmMNCmluZGV4IDg5
MWY1ZGIuLmNiMWM0MzAgMTAwNjQ0DQotLS0gYS9uZXQvc2N0cC9zbV9zdGF0ZWZ1bnMuYw0KKysr
IGIvbmV0L3NjdHAvc21fc3RhdGVmdW5zLmMNCkBAIC0yMDQ0LDcgKzIwNDQsNyBAQCBzY3RwX2Rp
c3Bvc2l0aW9uX3Qgc2N0cF9zZl9kb181XzJfNF9kdXBjb29rKGNvbnN0IHN0cnVjdCBzY3RwX2Vu
ZHBvaW50ICplcCwNCiAJfQ0KIA0KIAkvKiBEZWxldGUgdGhlIHRlbXBvcnkgbmV3IGFzc29jaWF0
aW9uLiAqLw0KLQlzY3RwX2FkZF9jbWRfc2YoY29tbWFuZHMsIFNDVFBfQ01EX05FV19BU09DLCBT
Q1RQX0FTT0MobmV3X2Fzb2MpKTsNCisJc2N0cF9hZGRfY21kX3NmKGNvbW1hbmRzLCBTQ1RQX0NN
RF9TRVRfQVNPQywgU0NUUF9BU09DKG5ld19hc29jKSk7DQogCXNjdHBfYWRkX2NtZF9zZihjb21t
YW5kcywgU0NUUF9DTURfREVMRVRFX1RDQiwgU0NUUF9OVUxMKCkpOw0KIA0KIAkvKiBSZXN0b3Jl
IGFzc29jaWF0aW9uIHBvaW50ZXIgdG8gcHJvdmlkZSBTQ1RQIGNvbW1hbmQgaW50ZXJwZXRlcg0K
ZGlmZiAtLWdpdCBhL3NlY3VyaXR5L3NlbGludXgveGZybS5jIGIvc2VjdXJpdHkvc2VsaW51eC94
ZnJtLmMNCmluZGV4IDQ4NjY1ZWMuLjhhYjI5NTEgMTAwNjQ0DQotLS0gYS9zZWN1cml0eS9zZWxp
bnV4L3hmcm0uYw0KKysrIGIvc2VjdXJpdHkvc2VsaW51eC94ZnJtLmMNCkBAIC0zMTAsNyArMzEw
LDcgQEAgaW50IHNlbGludXhfeGZybV9wb2xpY3lfY2xvbmUoc3RydWN0IHhmcm1fc2VjX2N0eCAq
b2xkX2N0eCwNCiANCiAJaWYgKG9sZF9jdHgpIHsNCiAJCW5ld19jdHggPSBrbWFsbG9jKHNpemVv
Zigqb2xkX2N0eCkgKyBvbGRfY3R4LT5jdHhfbGVuLA0KLQkJCQkgIEdGUF9LRVJORUwpOw0KKwkJ
CQkgIEdGUF9BVE9NSUMpOw0KIAkJaWYgKCFuZXdfY3R4KQ0KIAkJCXJldHVybiAtRU5PTUVNOw0K
IA0KZGlmZiAtLWdpdCBhL3NvdW5kL3BjaS9oZGEvaGRhX2NvZGVjLmMgYi9zb3VuZC9wY2kvaGRh
L2hkYV9jb2RlYy5jDQppbmRleCBiMDE4N2U3Li43NzQ3ZDI2IDEwMDY0NA0KLS0tIGEvc291bmQv
cGNpL2hkYS9oZGFfY29kZWMuYw0KKysrIGIvc291bmQvcGNpL2hkYS9oZGFfY29kZWMuYw0KQEAg
LTI3NzEsNyArMjc3MSw3IEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgY29udmVydF90b19zcGRpZl9z
dGF0dXModW5zaWduZWQgc2hvcnQgdmFsKQ0KIAlpZiAodmFsICYgQUNfRElHMV9QUk9GRVNTSU9O
QUwpDQogCQlzYml0cyB8PSBJRUM5NThfQUVTMF9QUk9GRVNTSU9OQUw7DQogCWlmIChzYml0cyAm
IElFQzk1OF9BRVMwX1BST0ZFU1NJT05BTCkgew0KLQkJaWYgKHNiaXRzICYgQUNfRElHMV9FTVBI
QVNJUykNCisJCWlmICh2YWwgJiBBQ19ESUcxX0VNUEhBU0lTKQ0KIAkJCXNiaXRzIHw9IElFQzk1
OF9BRVMwX1BST19FTVBIQVNJU181MDE1Ow0KIAl9IGVsc2Ugew0KIAkJaWYgKHZhbCAmIEFDX0RJ
RzFfRU1QSEFTSVMpDQpkaWZmIC0tZ2l0IGEvc291bmQvcGNpL2hkYS9wYXRjaF9jb25leGFudC5j
IGIvc291bmQvcGNpL2hkYS9wYXRjaF9jb25leGFudC5jDQppbmRleCBjOTI2OWNlLi45ODRiNWIx
IDEwMDY0NA0KLS0tIGEvc291bmQvcGNpL2hkYS9wYXRjaF9jb25leGFudC5jDQorKysgYi9zb3Vu
ZC9wY2kvaGRhL3BhdGNoX2NvbmV4YW50LmMNCkBAIC0xMjM2LDcgKzEyMzYsNyBAQCBzdGF0aWMg
aW50IHBhdGNoX2N4dDUwNDUoc3RydWN0IGhkYV9jb2RlYyAqY29kZWMpDQogCX0NCiANCiAJaWYg
KHNwZWMtPmJlZXBfYW1wKQ0KLQkJc25kX2hkYV9hdHRhY2hfYmVlcF9kZXZpY2UoY29kZWMsIHNw
ZWMtPmJlZXBfYW1wKTsNCisJCXNuZF9oZGFfYXR0YWNoX2JlZXBfZGV2aWNlKGNvZGVjLCBnZXRf
YW1wX25pZF8oc3BlYy0+YmVlcF9hbXApKTsNCiANCiAJcmV0dXJuIDA7DQogfQ0KQEAgLTIwMjcs
NyArMjAyNyw3IEBAIHN0YXRpYyBpbnQgcGF0Y2hfY3h0NTA1MShzdHJ1Y3QgaGRhX2NvZGVjICpj
b2RlYykNCiAJfQ0KIA0KIAlpZiAoc3BlYy0+YmVlcF9hbXApDQotCQlzbmRfaGRhX2F0dGFjaF9i
ZWVwX2RldmljZShjb2RlYywgc3BlYy0+YmVlcF9hbXApOw0KKwkJc25kX2hkYV9hdHRhY2hfYmVl
cF9kZXZpY2UoY29kZWMsIGdldF9hbXBfbmlkXyhzcGVjLT5iZWVwX2FtcCkpOw0KIA0KIAljb25l
eGFudF9pbml0X2phY2tzKGNvZGVjKTsNCiAJaWYgKHNwZWMtPmF1dG9fbWljICYgQVVUT19NSUNf
UE9SVEIpDQpAQCAtMzIyNSw3ICszMjI1LDcgQEAgc3RhdGljIGludCBwYXRjaF9jeHQ1MDY2KHN0
cnVjdCBoZGFfY29kZWMgKmNvZGVjKQ0KIAl9DQogDQogCWlmIChzcGVjLT5iZWVwX2FtcCkNCi0J
CXNuZF9oZGFfYXR0YWNoX2JlZXBfZGV2aWNlKGNvZGVjLCBzcGVjLT5iZWVwX2FtcCk7DQorCQlz
bmRfaGRhX2F0dGFjaF9iZWVwX2RldmljZShjb2RlYywgZ2V0X2FtcF9uaWRfKHNwZWMtPmJlZXBf
YW1wKSk7DQogDQogCXJldHVybiAwOw0KIH0NCkBAIC00NTU2LDcgKzQ1NTYsNyBAQCBzdGF0aWMg
aW50IHBhdGNoX2NvbmV4YW50X2F1dG8oc3RydWN0IGhkYV9jb2RlYyAqY29kZWMpDQogCXNwZWMt
PmNhcHR1cmVfc3RyZWFtID0gJmN4X2F1dG9fcGNtX2FuYWxvZ19jYXB0dXJlOw0KIAljb2RlYy0+
cGF0Y2hfb3BzID0gY3hfYXV0b19wYXRjaF9vcHM7DQogCWlmIChzcGVjLT5iZWVwX2FtcCkNCi0J
CXNuZF9oZGFfYXR0YWNoX2JlZXBfZGV2aWNlKGNvZGVjLCBzcGVjLT5iZWVwX2FtcCk7DQorCQlz
bmRfaGRhX2F0dGFjaF9iZWVwX2RldmljZShjb2RlYywgZ2V0X2FtcF9uaWRfKHNwZWMtPmJlZXBf
YW1wKSk7DQogCXJldHVybiAwOw0KIH0NCiANCmRpZmYgLS1naXQgYS9zb3VuZC91c2IvbWl4ZXIu
YyBiL3NvdW5kL3VzYi9taXhlci5jDQppbmRleCA5MTIxZGVlLi5mNDU0MGJmIDEwMDY0NA0KLS0t
IGEvc291bmQvdXNiL21peGVyLmMNCisrKyBiL3NvdW5kL3VzYi9taXhlci5jDQpAQCAtNzExLDgg
KzcxMSw5IEBAIHN0YXRpYyBpbnQgY2hlY2tfaW5wdXRfdGVybShzdHJ1Y3QgbWl4ZXJfYnVpbGQg
KnN0YXRlLCBpbnQgaWQsIHN0cnVjdCB1c2JfYXVkaW9fDQogCQljYXNlIFVBQzJfQ0xPQ0tfU0VM
RUNUT1I6IHsNCiAJCQlzdHJ1Y3QgdWFjX3NlbGVjdG9yX3VuaXRfZGVzY3JpcHRvciAqZCA9IHAx
Ow0KIAkJCS8qIGNhbGwgcmVjdXJzaXZlbHkgdG8gcmV0cmlldmUgdGhlIGNoYW5uZWwgaW5mbyAq
Lw0KLQkJCWlmIChjaGVja19pbnB1dF90ZXJtKHN0YXRlLCBkLT5iYVNvdXJjZUlEWzBdLCB0ZXJt
KSA8IDApDQotCQkJCXJldHVybiAtRU5PREVWOw0KKwkJCWVyciA9IGNoZWNrX2lucHV0X3Rlcm0o
c3RhdGUsIGQtPmJhU291cmNlSURbMF0sIHRlcm0pOw0KKwkJCWlmIChlcnIgPCAwKQ0KKwkJCQly
ZXR1cm4gZXJyOw0KIAkJCXRlcm0tPnR5cGUgPSBkLT5iRGVzY3JpcHRvclN1YnR5cGUgPDwgMTY7
IC8qIHZpcnR1YWwgdHlwZSAqLw0KIAkJCXRlcm0tPmlkID0gaWQ7DQogCQkJdGVybS0+bmFtZSA9
IHVhY19zZWxlY3Rvcl91bml0X2lTZWxlY3RvcihkKTsNCkBAIC0xMjYzLDggKzEyNjQsOSBAQCBz
dGF0aWMgaW50IHBhcnNlX2F1ZGlvX2ZlYXR1cmVfdW5pdChzdHJ1Y3QgbWl4ZXJfYnVpbGQgKnN0
YXRlLCBpbnQgdW5pdGlkLCB2b2lkDQogCQlyZXR1cm4gZXJyOw0KIA0KIAkvKiBkZXRlcm1pbmUg
dGhlIGlucHV0IHNvdXJjZSB0eXBlIGFuZCBuYW1lICovDQotCWlmIChjaGVja19pbnB1dF90ZXJt
KHN0YXRlLCBoZHItPmJTb3VyY2VJRCwgJml0ZXJtKSA8IDApDQotCQlyZXR1cm4gLUVJTlZBTDsN
CisJZXJyID0gY2hlY2tfaW5wdXRfdGVybShzdGF0ZSwgaGRyLT5iU291cmNlSUQsICZpdGVybSk7
DQorCWlmIChlcnIgPCAwKQ0KKwkJcmV0dXJuIGVycjsNCiANCiAJbWFzdGVyX2JpdHMgPSBzbmRf
dXNiX2NvbWJpbmVfYnl0ZXMoYm1hQ29udHJvbHMsIGNzaXplKTsNCiAJLyogbWFzdGVyIGNvbmZp
Z3VyYXRpb24gcXVpcmtzICovDQpAQCAtMjAxOCw3ICsyMDIwLDcgQEAgc3RhdGljIGludCBzbmRf
dXNiX21peGVyX2NvbnRyb2xzKHN0cnVjdCB1c2JfbWl4ZXJfaW50ZXJmYWNlICptaXhlcikNCiAJ
CQlzdGF0ZS5vdGVybS50eXBlID0gbGUxNl90b19jcHUoZGVzYy0+d1Rlcm1pbmFsVHlwZSk7DQog
CQkJc3RhdGUub3Rlcm0ubmFtZSA9IGRlc2MtPmlUZXJtaW5hbDsNCiAJCQllcnIgPSBwYXJzZV9h
dWRpb191bml0KCZzdGF0ZSwgZGVzYy0+YlNvdXJjZUlEKTsNCi0JCQlpZiAoZXJyIDwgMCkNCisJ
CQlpZiAoZXJyIDwgMCAmJiBlcnIgIT0gLUVJTlZBTCkNCiAJCQkJcmV0dXJuIGVycjsNCiAJCX0g
ZWxzZSB7IC8qIFVBQ19WRVJTSU9OXzIgKi8NCiAJCQlzdHJ1Y3QgdWFjMl9vdXRwdXRfdGVybWlu
YWxfZGVzY3JpcHRvciAqZGVzYyA9IHA7DQpAQCAtMjAzMCwxMiArMjAzMiwxMiBAQCBzdGF0aWMg
aW50IHNuZF91c2JfbWl4ZXJfY29udHJvbHMoc3RydWN0IHVzYl9taXhlcl9pbnRlcmZhY2UgKm1p
eGVyKQ0KIAkJCXN0YXRlLm90ZXJtLnR5cGUgPSBsZTE2X3RvX2NwdShkZXNjLT53VGVybWluYWxU
eXBlKTsNCiAJCQlzdGF0ZS5vdGVybS5uYW1lID0gZGVzYy0+aVRlcm1pbmFsOw0KIAkJCWVyciA9
IHBhcnNlX2F1ZGlvX3VuaXQoJnN0YXRlLCBkZXNjLT5iU291cmNlSUQpOw0KLQkJCWlmIChlcnIg
PCAwKQ0KKwkJCWlmIChlcnIgPCAwICYmIGVyciAhPSAtRUlOVkFMKQ0KIAkJCQlyZXR1cm4gZXJy
Ow0KIA0KIAkJCS8qIGZvciBVQUMyLCB1c2UgdGhlIHNhbWUgYXBwcm9hY2ggdG8gYWxzbyBhZGQg
dGhlIGNsb2NrIHNlbGVjdG9ycyAqLw0KIAkJCWVyciA9IHBhcnNlX2F1ZGlvX3VuaXQoJnN0YXRl
LCBkZXNjLT5iQ1NvdXJjZUlEKTsNCi0JCQlpZiAoZXJyIDwgMCkNCisJCQlpZiAoZXJyIDwgMCAm
JiBlcnIgIT0gLUVJTlZBTCkNCiAJCQkJcmV0dXJuIGVycjsNCiAJCX0NCiAJfQ0KZGlmZiAtLWdp
dCBhL3Rvb2xzL2h2L2h2X2t2cF9kYWVtb24uYyBiL3Rvb2xzL2h2L2h2X2t2cF9kYWVtb24uYw0K
aW5kZXggMDk2MWQ4OC4uNWUxOTQxMCAxMDA2NDQNCi0tLSBhL3Rvb2xzL2h2L2h2X2t2cF9kYWVt
b24uYw0KKysrIGIvdG9vbHMvaHYvaHZfa3ZwX2RhZW1vbi5jDQpAQCAtMzkzLDEzICszOTMsMTkg
QEAgaW50IG1haW4odm9pZCkNCiAJCWxlbiA9IHJlY3Zmcm9tKGZkLCBrdnBfcmVjdl9idWZmZXIs
IHNpemVvZihrdnBfcmVjdl9idWZmZXIpLCAwLA0KIAkJCQlhZGRyX3AsICZhZGRyX2wpOw0KIA0K
LQkJaWYgKGxlbiA8IDAgfHwgYWRkci5ubF9waWQpIHsNCisJCWlmIChsZW4gPCAwKSB7DQogCQkJ
c3lzbG9nKExPR19FUlIsICJyZWN2ZnJvbSBmYWlsZWQ7IHBpZDoldSBlcnJvcjolZCAlcyIsDQog
CQkJCQlhZGRyLm5sX3BpZCwgZXJybm8sIHN0cmVycm9yKGVycm5vKSk7DQogCQkJY2xvc2UoZmQp
Ow0KIAkJCXJldHVybiAtMTsNCiAJCX0NCiANCisJCWlmIChhZGRyLm5sX3BpZCkgew0KKwkJCXN5
c2xvZyhMT0dfV0FSTklORywgIlJlY2VpdmVkIHBhY2tldCBmcm9tIHVudHJ1c3RlZCBwaWQ6JXUi
LA0KKwkJCQkJYWRkci5ubF9waWQpOw0KKwkJCWNvbnRpbnVlOw0KKwkJfQ0KKw0KIAkJaW5jb21p
bmdfbXNnID0gKHN0cnVjdCBubG1zZ2hkciAqKWt2cF9yZWN2X2J1ZmZlcjsNCiAJCWluY29taW5n
X2NuX21zZyA9IChzdHJ1Y3QgY25fbXNnICopTkxNU0dfREFUQShpbmNvbWluZ19tc2cpOw0KIA0K
ZGlmZiAtLWdpdCBhL3Rvb2xzL3BlcmYvdXRpbC90cmFjZS1ldmVudC1wYXJzZS5jIGIvdG9vbHMv
cGVyZi91dGlsL3RyYWNlLWV2ZW50LXBhcnNlLmMNCmluZGV4IGJmNTRjNDguLjZjMTY0ZGMgMTAw
NjQ0DQotLS0gYS90b29scy9wZXJmL3V0aWwvdHJhY2UtZXZlbnQtcGFyc2UuYw0KKysrIGIvdG9v
bHMvcGVyZi91dGlsL3RyYWNlLWV2ZW50LXBhcnNlLmMNCkBAIC0xNTgyLDggKzE1ODIsNiBAQCBw
cm9jZXNzX3N5bWJvbHMoc3RydWN0IGV2ZW50ICpldmVudCwgc3RydWN0IHByaW50X2FyZyAqYXJn
LCBjaGFyICoqdG9rKQ0KIAlmaWVsZCA9IG1hbGxvY19vcl9kaWUoc2l6ZW9mKCpmaWVsZCkpOw0K
IA0KIAl0eXBlID0gcHJvY2Vzc19hcmcoZXZlbnQsIGZpZWxkLCAmdG9rZW4pOw0KLQl3aGlsZSAo
dHlwZSA9PSBFVkVOVF9PUCkNCi0JCXR5cGUgPSBwcm9jZXNzX29wKGV2ZW50LCBmaWVsZCwgJnRv
a2VuKTsNCiAJaWYgKHRlc3RfdHlwZV90b2tlbih0eXBlLCB0b2tlbiwgRVZFTlRfREVMSU0sICIs
IikpDQogCQlnb3RvIG91dF9mcmVlOw0KIA0K


--=-VfzpRBgEmSkvMAsWCyeR--

--=-qKW140t/aOaSlhCSMfQW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUVL6Y+e/yOyVhhEJAQoLVBAAqeFmIQgSWQskR0Lw97kt86mkwztnV/0b
eS1QdvEPH8hanePJnzSSmA7n564KCcJNOnkX4EAN6NRAEAvmr9i9i8mXQL/lvDik
x37aoJIRiSo3+WQ6T50qJtoQb0Vg13lfvy6hOiHZP4/n9Dw8gSlGznsgIxe3vEal
hFthySHG7xGpZ85km8B4raWaY4J3gP1qdP7IeQxYJ9FTTz/tFN0JoSt2eBJGxnCa
GcYCsAda7vRhnwNAaJoPL8rKQyFG9ezQHrxytOu+S4KsXoN0UN/MUh/uvzwPz6aE
cvZU+/m/G8cqVTlPsFhM7oBJjPUn5+DzZoOEtl+NTgCj1t3azMs4BgS/vGS+Nsl/
g8Q23CgDHVdEBPcBjrRCDEtH9Qd1xH+THzdENelCL633YgUPQw1TkUVBFv4qpErL
dds1qHZ8P770Tjcdwjv7ggW2VFRhU55T1/aowa+8pWVXVTvTTXRySgrX3fBbj2hz
H7mWkBhpUfVKr0bQ5ToMCvhXSX6wJPh8c6XEMxBkHuJ5TEKlZvoABtwOZ3Xe9Xiv
yUNyUH+WbMI8ADsIQswxcLZx0/sn4MGVahQrRiIaCrkYHnKMQ9kJUNoA2erT5/YS
OuLpTRxzFVOgwIUF7pWaVepeGAzP1FR7pD7r/y7JAU3X5300J3An73Wi8aAhr8jM
Iguqi+hpUxA=
=vgN3
-----END PGP SIGNATURE-----

--=-qKW140t/aOaSlhCSMfQW--
