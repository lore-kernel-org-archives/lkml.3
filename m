Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484AbaFIOK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:10:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43515 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933265AbaFIOKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:10:14 -0400
Message-ID: <1402323005.23860.79.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.60
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Mon, 09 Jun 2014 15:10:05 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Y8WySKz0pORJz7LEbXfi"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Y8WySKz0pORJz7LEbXfi
Content-Type: multipart/mixed; boundary="=-fvL+mcIi4w+BEHW3vovx"


--=-fvL+mcIi4w+BEHW3vovx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.60 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.59 is attached to this message.

Ben.

------------

 Documentation/input/elantech.txt            |   5 +-
 Makefile                                    |   2 +-
 arch/powerpc/lib/crtsavres.S                | 186 ++++++++++++++++++++++
 arch/x86/include/asm/hugetlb.h              |   1 +
 arch/x86/kernel/ldt.c                       |   4 +-
 arch/x86/vdso/vdso32-setup.c                |   8 +
 drivers/acpi/ec.c                           |  77 ++++++++-
 drivers/atm/ambassador.c                    |   2 +-
 drivers/atm/idt77252.c                      |   2 +-
 drivers/bluetooth/ath3k.c                   |   2 +
 drivers/bluetooth/btusb.c                   |   1 +
 drivers/crypto/caam/error.c                 |  10 +-
 drivers/dma/mv_xor.c                        |   8 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c      |   3 -
 drivers/gpu/drm/radeon/radeon_bios.c        |  14 ++
 drivers/gpu/drm/radeon/radeon_object.c      |  38 +++--
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c     |  22 +++
 drivers/hid/hid-ids.h                       |   7 +
 drivers/hid/usbhid/hid-quirks.c             |   5 +
 drivers/hwmon/emc1403.c                     |   4 +-
 drivers/i2c/busses/i2c-designware-core.c    |   3 +
 drivers/i2c/busses/i2c-s3c2410.c            |   2 +-
 drivers/input/mouse/elantech.c              |  26 ++-
 drivers/input/mouse/elantech.h              |   1 +
 drivers/input/mouse/synaptics.c             |   8 +
 drivers/md/md.c                             |   3 +-
 drivers/media/media-device.c                |   1 +
 drivers/media/video/ov7670.c                |   2 +-
 drivers/media/video/v4l2-compat-ioctl32.c   |  12 +-
 drivers/net/bonding/bond_main.c             |   1 +
 drivers/net/can/sja1000/peak_pci.c          |  31 ++--
 drivers/net/ethernet/broadcom/tg3.c         |   4 +-
 drivers/net/macvlan.c                       |   9 +-
 drivers/net/wimax/i2400m/usb-rx.c           |   2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |  22 +--
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |  17 +-
 drivers/pci/hotplug/shpchp_ctrl.c           |   4 +-
 drivers/platform/x86/thinkpad_acpi.c        |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |   1 -
 drivers/staging/octeon/ethernet-tx.c        |   2 +-
 drivers/tty/hvc/hvc_console.c               |   2 +-
 drivers/usb/storage/shuttle_usbat.c         |   2 +-
 drivers/usb/storage/unusual_devs.h          |  14 ++
 drivers/video/tgafb.c                       |  15 +-
 fs/nfsd/nfs4acl.c                           |  17 +-
 fs/nfsd/nfs4state.c                         |  40 +++--
 fs/posix_acl.c                              |   6 +
 include/linux/ftrace.h                      |   2 +
 include/linux/kvm_host.h                    |   1 -
 include/linux/skbuff.h                      |  12 +-
 include/net/ip6_route.h                     |   5 +
 include/trace/events/module.h               |   2 +-
 kernel/events/core.c                        |  16 +-
 kernel/futex.c                              | 239 ++++++++++++++++++++++--=
----
 kernel/hrtimer.c                            |  30 +++-
 kernel/module.c                             |   3 +
 kernel/sched_cpupri.c                       |   3 +-
 kernel/timer.c                              |   2 +-
 kernel/trace/ftrace.c                       |  27 +---
 kernel/tracepoint.c                         |   6 +
 mm/memory-failure.c                         |  17 +-
 mm/page-writeback.c                         |   4 +-
 net/bluetooth/hci_conn.c                    |   9 +-
 net/bridge/br_netlink.c                     |  15 ++
 net/bridge/netfilter/ebtables.c             |   5 +-
 net/ceph/messenger.c                        |  39 ++++-
 net/core/dev.c                              |   1 +
 net/core/filter.c                           |   6 +-
 net/core/rtnetlink.c                        |  33 ++--
 net/core/skbuff.c                           |  21 +--
 net/ipv4/fib_semantics.c                    |   2 +-
 net/ipv4/ip_forward.c                       |   4 +-
 net/ipv4/netfilter/arp_tables.c             |   6 +-
 net/ipv4/netfilter/ip_tables.c              |   6 +-
 net/ipv4/ping.c                             |  15 +-
 net/ipv4/route.c                            |   2 +-
 net/ipv4/tcp_cubic.c                        |   2 +-
 net/ipv6/netfilter/ip6_tables.c             |   6 +-
 net/ipv6/route.c                            |   5 +-
 net/l2tp/l2tp_ppp.c                         |   4 +-
 net/sched/act_mirred.c                      |  11 +-
 net/sctp/protocol.c                         |   7 +-
 scripts/mod/modpost.c                       |   8 +-
 virt/kvm/async_pf.c                         |  14 +-
 84 files changed, 961 insertions(+), 279 deletions(-)

AceLan Kao (3):
      HID: usbhid: quirk for Synaptics Large Touchccreen
      HID: usbhid: quirk for Synaptics HD touchscreen
      HID: usbhid: quirk for Synaptics Quad HD touchscreen

Alex Deucher (1):
      drm/radeon: handle non-VGA class pci devices with ATRM

Alex Elder (1):
      libceph: only call kernel_sendpage() via helper

Alex Hung (1):
      thinkpad-acpi: fix issuing duplicated key events for brightness up/do=
wn

Alexander Duyck (1):
      skb: Add inline helper for getting the skb end offset from head

Andreas Schwab (1):
      powerpc: Add vr save/restore functions

Anthony Iliopoulos (1):
      x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

Ben Hutchings (2):
      rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init=
()
      Linux 3.2.60

Chen Yucong (1):
      hwpoison, hugetlb: lock_page/unlock_page does not match for handling =
a free hugepage

Christian K=C3=B6nig (1):
      drm/radeon: also try GART for CPU accessed buffers

Christoph Hellwig (1):
      posix_acl: handle NULL ACL in posix_acl_equiv_mode

Chunwei Chen (1):
      libceph: fix corruption when using page_count 0 page in rbd

Daniele Forsi (2):
      usb: storage: shuttle_usbat: fix discs being detected twice
      USB: Nokia 5300 should be treated as unusual dev

David Gibson (2):
      rtnetlink: Warn when interface's information won't fit in our packet
      rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF=
 is set

Dmitry Petukhov (1):
      l2tp: take PMTU from tunnel UDP socket

Du, Wenkai (1):
      i2c: designware: Mask all interrupts during i2c controller enable

Eric Dumazet (2):
      ipv6: Limit mtu to 65575 bytes
      net-gro: reset skb->truesize in napi_reuse_skb()

Ezequiel Garcia (1):
      dma: mv_xor: Flush descriptors before activating a channel

Florian Westphal (2):
      net: core: don't account for udp header size when computing seglen
      net: ipv4: ip_forward: fix inverted local_df test

Guennadi Liakhovetski (2):
      V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from =
user-space
      V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode

Hans de Goede (3):
      Input: synaptics - add min/max quirk for ThinkPad Edge E431
      HID: add NO_INIT_REPORTS quirk for Synaptics Touch Pad V 103S
      Input: elantech - fix touchpad initialization on Gigabyte U2442

Horia Geanta (1):
      crypto: caam - add allocation failure handling in SPRINTFCAT macro

Ilia Mirkin (1):
      drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi

Ivan Vecera (1):
      tg3: update rx_jumbo_pending ring param only when jumbo frames are en=
abled

J. Bruce Fields (2):
      nfsd4: remove lockowner when removing lock stateid
      nfsd4: warn on finding lockowner without stateid's

Jason Wang (1):
      act_mirred: do not drop packets when fails to mirror it

Jiri Bohac (1):
      timer: Prevent overflow in apply_slack

Jiri Olsa (1):
      perf: Prevent false warning in perf_swevent_add

Johan Hedberg (1):
      Bluetooth: Fix redundant encryption request for reauthentication

Josef Gajdusek (2):
      hwmon: (emc1403) fix inverted store_hyst()
      hwmon: (emc1403) Support full range of known chip revision numbers

Kieran Clancy (2):
      ACPI / EC: Clear stale EC events on Samsung systems
      ACPI / EC: Process rather than discard events in acpi_ec_clear

Kinglong Mee (1):
      NFSD: Call ->set_acl with a NULL ACL structure if no entries

Larry Finger (1):
      rtlwifi: rtl8192cu: Fix too long disable of IRQs

Leon Ma (1):
      hrtimer: Prevent remote enqueue of leftmost timers

Li RongQing (1):
      ipv4: initialise the itag variable in __mkroute_input

Linus Torvalds (1):
      x86-64, modify_ldt: Make support for 16-bit segments a runtime option

Liu Yu (1):
      tcp_cubic: fix the range of delayed_ack

Marcel Apfelbaum (1):
      PCI: shpchp: Check bridge's secondary (not primary) bus speed

Mathias Krause (1):
      filter: prevent nla extensions to peek beyond the end of the message

Mikulas Patocka (1):
      tgafb: fix mode setting with fbset

Mohammed Habibulla (1):
      Bluetooth: Add support for Lite-on [04ca:3007]

Naoya Horiguchi (1):
      mm/memory-failure.c: fix memory leak by race between poison and unpoi=
son

NeilBrown (1):
      md: avoid possible spinning md thread at shutdown.

Oleg Nesterov (1):
      KVM: async_pf: mm->mm_users can not pin apf->mm

Olof Johansson (1):
      i2c: s3c2410: resume race fix

Peter Christensen (1):
      macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.

Peter Zijlstra (1):
      perf: Limit perf_event_attr::sample_period to 63 bits

Radim Kr=C4=8Dm=C3=A1=C5=99 (2):
      kvm: free resources after canceling async_pf
      kvm: remove .done from struct kvm_async_pf

Rik van Riel (1):
      mm/page-writeback.c: fix divide by zero in pos_ratio_polynom

Romain Izard (1):
      trace: module: Maintain a valid user count

Salva Peir=C3=B3 (1):
      media-device: fix infoleak in ioctl media_enum_entities()

Sergey Popovich (1):
      ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation

Stanislaw Gruszka (1):
      rt2x00: fix beaconing on USB

Stephane Grosjean (2):
      can: peak_pci: Fix the way channels are linked together
      can: peak_pci: prevent use after free at netdev removal

Steven Rostedt (Red Hat) (3):
      tracepoint: Do not waste memory on mods with no tracepoints
      ftrace/module: Hardcode ftrace_module_init() call into load_module()
      sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri chec=
k

Stuart Hayes (1):
      hrtimer: Prevent all reprogramming if hang detected

Thomas Gleixner (6):
      futex: Add another early deadlock detection check
      futex: Prevent attaching to kernel threads
      futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr =3D=
=3D uaddr2 in futex_requeue(..., requeue_pi=3D1)
      futex: Validate atomic acquisition in futex_lock_pi_atomic()
      futex: Always cleanup owner tid in unlock_pi
      futex: Make lookup_pi_state more robust

Thomas Graf (1):
      netfilter: Can't fail and free after table replacement

Thomas Hellstrom (1):
      drm/vmwgfx: Make sure user-space can't DMA across buffer object bound=
aries v2

Thomas Richter (1):
      bonding: Remove debug_fs files when module init fails

Tomoki Sekiyama (1):
      drivers/tty/hvc: don't free hvc_console_setup after init

Toshiaki Makita (1):
      bridge: Handle IFLA_ADDRESS correctly when creating bridge device

Trond Myklebust (2):
      NFSd: Move default initialisers from create_client() to alloc_client(=
)
      NFSd: call rpc_destroy_wait_queue() from free_client()

Tyler Stachecki (1):
      mpt2sas: Don't disable device twice at suspend.

Victor A. Santos (1):
      USB: Nokia 305 should be treated as unusual dev

Viresh Kumar (1):
      hrtimer: Set expiry time before switch_hrtimer_base()

Vlad Yasevich (1):
      Revert "macvlan : fix checksums error when we are in bridge mode"

Wang, Xiaoming (1):
      net: ipv4: current group_info should be put after using.

Xufeng Zhang (1):
      sctp: reset flowi4_oif parameter on route lookup

paul.szabo@sydney.edu.au (1):
      Negative (setpoint-dirty) in bdi_position_ratio()


--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-fvL+mcIi4w+BEHW3vovx
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.60.patch"
Content-Disposition: attachment; filename="linux-3.2.60.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vaW5wdXQvZWxhbnRlY2gudHh0IGIvRG9jdW1lbnRh
dGlvbi9pbnB1dC9lbGFudGVjaC50eHQNCmluZGV4IDU2MDJlYjcuLmUxYWUxMjcgMTAwNjQ0DQot
LS0gYS9Eb2N1bWVudGF0aW9uL2lucHV0L2VsYW50ZWNoLnR4dA0KKysrIGIvRG9jdW1lbnRhdGlv
bi9pbnB1dC9lbGFudGVjaC50eHQNCkBAIC01MDQsOSArNTA0LDEyIEBAIGJ5dGUgNToNCiAqIHJl
Z18xMA0KIA0KICAgIGJpdCAgIDcgICA2ICAgNSAgIDQgICAzICAgMiAgIDEgICAwDQotICAgICAg
ICAgMCAgIDAgICAwICAgMCAgIDAgICAwICAgMCAgIEENCisgICAgICAgICAwICAgMCAgIDAgICAw
ICAgUiAgIEYgICBUICAgQQ0KIA0KICAgICAgICAgIEE6IDEgPSBlbmFibGUgYWJzb2x1dGUgdHJh
Y2tpbmcNCisgICAgICAgICBUOiAxID0gZW5hYmxlIHR3byBmaW5nZXIgbW9kZSBhdXRvIGNvcnJl
Y3QNCisgICAgICAgICBGOiAxID0gZGlzYWJsZSBBQlMgUG9zaXRpb24gRmlsdGVyDQorICAgICAg
ICAgUjogMSA9IGVuYWJsZSByZWFsIGhhcmR3YXJlIHJlc29sdXRpb24NCiANCiA2LjIgTmF0aXZl
IGFic29sdXRlIG1vZGUgNiBieXRlIHBhY2tldCBmb3JtYXQNCiAgICAgfn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCmRpZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2Vm
aWxlDQppbmRleCAxYmUzNDE0Li4zMTdkNWVhIDEwMDY0NA0KLS0tIGEvTWFrZWZpbGUNCisrKyBi
L01ha2VmaWxlDQpAQCAtMSw2ICsxLDYgQEANCiBWRVJTSU9OID0gMw0KIFBBVENITEVWRUwgPSAy
DQotU1VCTEVWRUwgPSA1OQ0KK1NVQkxFVkVMID0gNjANCiBFWFRSQVZFUlNJT04gPQ0KIE5BTUUg
PSBTYWJlci10b290aGVkIFNxdWlycmVsDQogDQpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2xp
Yi9jcnRzYXZyZXMuUyBiL2FyY2gvcG93ZXJwYy9saWIvY3J0c2F2cmVzLlMNCmluZGV4IDFjODkz
ZjAuLjIxZWNkZjUgMTAwNjQ0DQotLS0gYS9hcmNoL3Bvd2VycGMvbGliL2NydHNhdnJlcy5TDQor
KysgYi9hcmNoL3Bvd2VycGMvbGliL2NydHNhdnJlcy5TDQpAQCAtMjMwLDYgKzIzMCw4NyBAQCBf
R0xPQkFMKF9yZXN0MzJncHJfMzFfeCkNCiAJbXIJMSwxMQ0KIAlibHINCiANCisjaWZkZWYgQ09O
RklHX0FMVElWRUMNCisvKiBDYWxsZWQgd2l0aCByMCBwb2ludGluZyBqdXN0IGJleW9uZCB0aGUg
ZW5kIG9mIHRoZSB2ZWN0b3Igc2F2ZSBhcmVhLiAgKi8NCisNCitfR0xPQkFMKF9zYXZldnJfMjAp
DQorCWxpCXIxMSwtMTkyDQorCXN0dngJdnIyMCxyMTEscjANCitfR0xPQkFMKF9zYXZldnJfMjEp
DQorCWxpCXIxMSwtMTc2DQorCXN0dngJdnIyMSxyMTEscjANCitfR0xPQkFMKF9zYXZldnJfMjIp
DQorCWxpCXIxMSwtMTYwDQorCXN0dngJdnIyMixyMTEscjANCitfR0xPQkFMKF9zYXZldnJfMjMp
DQorCWxpCXIxMSwtMTQ0DQorCXN0dngJdnIyMyxyMTEscjANCitfR0xPQkFMKF9zYXZldnJfMjQp
DQorCWxpCXIxMSwtMTI4DQorCXN0dngJdnIyNCxyMTEscjANCitfR0xPQkFMKF9zYXZldnJfMjUp
DQorCWxpCXIxMSwtMTEyDQorCXN0dngJdnIyNSxyMTEscjANCitfR0xPQkFMKF9zYXZldnJfMjYp
DQorCWxpCXIxMSwtOTYNCisJc3R2eAl2cjI2LHIxMSxyMA0KK19HTE9CQUwoX3NhdmV2cl8yNykN
CisJbGkJcjExLC04MA0KKwlzdHZ4CXZyMjcscjExLHIwDQorX0dMT0JBTChfc2F2ZXZyXzI4KQ0K
KwlsaQlyMTEsLTY0DQorCXN0dngJdnIyOCxyMTEscjANCitfR0xPQkFMKF9zYXZldnJfMjkpDQor
CWxpCXIxMSwtNDgNCisJc3R2eAl2cjI5LHIxMSxyMA0KK19HTE9CQUwoX3NhdmV2cl8zMCkNCisJ
bGkJcjExLC0zMg0KKwlzdHZ4CXZyMzAscjExLHIwDQorX0dMT0JBTChfc2F2ZXZyXzMxKQ0KKwls
aQlyMTEsLTE2DQorCXN0dngJdnIzMSxyMTEscjANCisJYmxyDQorDQorX0dMT0JBTChfcmVzdHZy
XzIwKQ0KKwlsaQlyMTEsLTE5Mg0KKwlsdngJdnIyMCxyMTEscjANCitfR0xPQkFMKF9yZXN0dnJf
MjEpDQorCWxpCXIxMSwtMTc2DQorCWx2eAl2cjIxLHIxMSxyMA0KK19HTE9CQUwoX3Jlc3R2cl8y
MikNCisJbGkJcjExLC0xNjANCisJbHZ4CXZyMjIscjExLHIwDQorX0dMT0JBTChfcmVzdHZyXzIz
KQ0KKwlsaQlyMTEsLTE0NA0KKwlsdngJdnIyMyxyMTEscjANCitfR0xPQkFMKF9yZXN0dnJfMjQp
DQorCWxpCXIxMSwtMTI4DQorCWx2eAl2cjI0LHIxMSxyMA0KK19HTE9CQUwoX3Jlc3R2cl8yNSkN
CisJbGkJcjExLC0xMTINCisJbHZ4CXZyMjUscjExLHIwDQorX0dMT0JBTChfcmVzdHZyXzI2KQ0K
KwlsaQlyMTEsLTk2DQorCWx2eAl2cjI2LHIxMSxyMA0KK19HTE9CQUwoX3Jlc3R2cl8yNykNCisJ
bGkJcjExLC04MA0KKwlsdngJdnIyNyxyMTEscjANCitfR0xPQkFMKF9yZXN0dnJfMjgpDQorCWxp
CXIxMSwtNjQNCisJbHZ4CXZyMjgscjExLHIwDQorX0dMT0JBTChfcmVzdHZyXzI5KQ0KKwlsaQly
MTEsLTQ4DQorCWx2eAl2cjI5LHIxMSxyMA0KK19HTE9CQUwoX3Jlc3R2cl8zMCkNCisJbGkJcjEx
LC0zMg0KKwlsdngJdnIzMCxyMTEscjANCitfR0xPQkFMKF9yZXN0dnJfMzEpDQorCWxpCXIxMSwt
MTYNCisJbHZ4CXZyMzEscjExLHIwDQorCWJscg0KKw0KKyNlbmRpZiAvKiBDT05GSUdfQUxUSVZF
QyAqLw0KKw0KICNlbHNlIC8qIENPTkZJR19QUEM2NCAqLw0KIA0KIC5nbG9ibAlfc2F2ZWdwcjBf
MTQNCkBAIC0zNTMsNiArNDM0LDExMSBAQCBfcmVzdGdwcjBfMzE6DQogCW10bHIJcjANCiAJYmxy
DQogDQorI2lmZGVmIENPTkZJR19BTFRJVkVDDQorLyogQ2FsbGVkIHdpdGggcjAgcG9pbnRpbmcg
anVzdCBiZXlvbmQgdGhlIGVuZCBvZiB0aGUgdmVjdG9yIHNhdmUgYXJlYS4gICovDQorDQorLmds
b2JsCV9zYXZldnJfMjANCitfc2F2ZXZyXzIwOg0KKwlsaQlyMTIsLTE5Mg0KKwlzdHZ4CXZyMjAs
cjEyLHIwDQorLmdsb2JsCV9zYXZldnJfMjENCitfc2F2ZXZyXzIxOg0KKwlsaQlyMTIsLTE3Ng0K
KwlzdHZ4CXZyMjEscjEyLHIwDQorLmdsb2JsCV9zYXZldnJfMjINCitfc2F2ZXZyXzIyOg0KKwls
aQlyMTIsLTE2MA0KKwlzdHZ4CXZyMjIscjEyLHIwDQorLmdsb2JsCV9zYXZldnJfMjMNCitfc2F2
ZXZyXzIzOg0KKwlsaQlyMTIsLTE0NA0KKwlzdHZ4CXZyMjMscjEyLHIwDQorLmdsb2JsCV9zYXZl
dnJfMjQNCitfc2F2ZXZyXzI0Og0KKwlsaQlyMTIsLTEyOA0KKwlzdHZ4CXZyMjQscjEyLHIwDQor
Lmdsb2JsCV9zYXZldnJfMjUNCitfc2F2ZXZyXzI1Og0KKwlsaQlyMTIsLTExMg0KKwlzdHZ4CXZy
MjUscjEyLHIwDQorLmdsb2JsCV9zYXZldnJfMjYNCitfc2F2ZXZyXzI2Og0KKwlsaQlyMTIsLTk2
DQorCXN0dngJdnIyNixyMTIscjANCisuZ2xvYmwJX3NhdmV2cl8yNw0KK19zYXZldnJfMjc6DQor
CWxpCXIxMiwtODANCisJc3R2eAl2cjI3LHIxMixyMA0KKy5nbG9ibAlfc2F2ZXZyXzI4DQorX3Nh
dmV2cl8yODoNCisJbGkJcjEyLC02NA0KKwlzdHZ4CXZyMjgscjEyLHIwDQorLmdsb2JsCV9zYXZl
dnJfMjkNCitfc2F2ZXZyXzI5Og0KKwlsaQlyMTIsLTQ4DQorCXN0dngJdnIyOSxyMTIscjANCisu
Z2xvYmwJX3NhdmV2cl8zMA0KK19zYXZldnJfMzA6DQorCWxpCXIxMiwtMzINCisJc3R2eAl2cjMw
LHIxMixyMA0KKy5nbG9ibAlfc2F2ZXZyXzMxDQorX3NhdmV2cl8zMToNCisJbGkJcjEyLC0xNg0K
KwlzdHZ4CXZyMzEscjEyLHIwDQorCWJscg0KKw0KKy5nbG9ibAlfcmVzdHZyXzIwDQorX3Jlc3R2
cl8yMDoNCisJbGkJcjEyLC0xOTINCisJbHZ4CXZyMjAscjEyLHIwDQorLmdsb2JsCV9yZXN0dnJf
MjENCitfcmVzdHZyXzIxOg0KKwlsaQlyMTIsLTE3Ng0KKwlsdngJdnIyMSxyMTIscjANCisuZ2xv
YmwJX3Jlc3R2cl8yMg0KK19yZXN0dnJfMjI6DQorCWxpCXIxMiwtMTYwDQorCWx2eAl2cjIyLHIx
MixyMA0KKy5nbG9ibAlfcmVzdHZyXzIzDQorX3Jlc3R2cl8yMzoNCisJbGkJcjEyLC0xNDQNCisJ
bHZ4CXZyMjMscjEyLHIwDQorLmdsb2JsCV9yZXN0dnJfMjQNCitfcmVzdHZyXzI0Og0KKwlsaQly
MTIsLTEyOA0KKwlsdngJdnIyNCxyMTIscjANCisuZ2xvYmwJX3Jlc3R2cl8yNQ0KK19yZXN0dnJf
MjU6DQorCWxpCXIxMiwtMTEyDQorCWx2eAl2cjI1LHIxMixyMA0KKy5nbG9ibAlfcmVzdHZyXzI2
DQorX3Jlc3R2cl8yNjoNCisJbGkJcjEyLC05Ng0KKwlsdngJdnIyNixyMTIscjANCisuZ2xvYmwJ
X3Jlc3R2cl8yNw0KK19yZXN0dnJfMjc6DQorCWxpCXIxMiwtODANCisJbHZ4CXZyMjcscjEyLHIw
DQorLmdsb2JsCV9yZXN0dnJfMjgNCitfcmVzdHZyXzI4Og0KKwlsaQlyMTIsLTY0DQorCWx2eAl2
cjI4LHIxMixyMA0KKy5nbG9ibAlfcmVzdHZyXzI5DQorX3Jlc3R2cl8yOToNCisJbGkJcjEyLC00
OA0KKwlsdngJdnIyOSxyMTIscjANCisuZ2xvYmwJX3Jlc3R2cl8zMA0KK19yZXN0dnJfMzA6DQor
CWxpCXIxMiwtMzINCisJbHZ4CXZyMzAscjEyLHIwDQorLmdsb2JsCV9yZXN0dnJfMzENCitfcmVz
dHZyXzMxOg0KKwlsaQlyMTIsLTE2DQorCWx2eAl2cjMxLHIxMixyMA0KKwlibHINCisNCisjZW5k
aWYgLyogQ09ORklHX0FMVElWRUMgKi8NCisNCiAjZW5kaWYgLyogQ09ORklHX1BQQzY0ICovDQog
DQogI2VuZGlmDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vaHVnZXRsYi5oIGIv
YXJjaC94ODYvaW5jbHVkZS9hc20vaHVnZXRsYi5oDQppbmRleCA0MzlhOWFjLi40OGZhMzkxIDEw
MDY0NA0KLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vaHVnZXRsYi5oDQorKysgYi9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9odWdldGxiLmgNCkBAIC01MSw2ICs1MSw3IEBAIHN0YXRpYyBpbmxpbmUg
cHRlX3QgaHVnZV9wdGVwX2dldF9hbmRfY2xlYXIoc3RydWN0IG1tX3N0cnVjdCAqbW0sDQogc3Rh
dGljIGlubGluZSB2b2lkIGh1Z2VfcHRlcF9jbGVhcl9mbHVzaChzdHJ1Y3Qgdm1fYXJlYV9zdHJ1
Y3QgKnZtYSwNCiAJCQkJCSB1bnNpZ25lZCBsb25nIGFkZHIsIHB0ZV90ICpwdGVwKQ0KIHsNCisJ
cHRlcF9jbGVhcl9mbHVzaCh2bWEsIGFkZHIsIHB0ZXApOw0KIH0NCiANCiBzdGF0aWMgaW5saW5l
IGludCBodWdlX3B0ZV9ub25lKHB0ZV90IHB0ZSkNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJu
ZWwvbGR0LmMgYi9hcmNoL3g4Ni9rZXJuZWwvbGR0LmMNCmluZGV4IDRhYzQ1MzEuLjNlMGNjYmYg
MTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvbGR0LmMNCisrKyBiL2FyY2gveDg2L2tlcm5l
bC9sZHQuYw0KQEAgLTIxLDYgKzIxLDggQEANCiAjaW5jbHVkZSA8YXNtL21tdV9jb250ZXh0Lmg+
DQogI2luY2x1ZGUgPGFzbS9zeXNjYWxscy5oPg0KIA0KK2ludCBzeXNjdGxfbGR0MTYgPSAwOw0K
Kw0KICNpZmRlZiBDT05GSUdfU01QDQogc3RhdGljIHZvaWQgZmx1c2hfbGR0KHZvaWQgKmN1cnJl
bnRfbW0pDQogew0KQEAgLTIzNSw3ICsyMzcsNyBAQCBzdGF0aWMgaW50IHdyaXRlX2xkdCh2b2lk
IF9fdXNlciAqcHRyLCB1bnNpZ25lZCBsb25nIGJ5dGVjb3VudCwgaW50IG9sZG1vZGUpDQogCSAq
IElSRVQgbGVha2luZyB0aGUgaGlnaCBiaXRzIG9mIHRoZSBrZXJuZWwgc3RhY2sgYWRkcmVzcy4N
CiAJICovDQogI2lmZGVmIENPTkZJR19YODZfNjQNCi0JaWYgKCFsZHRfaW5mby5zZWdfMzJiaXQp
IHsNCisJaWYgKCFsZHRfaW5mby5zZWdfMzJiaXQgJiYgIXN5c2N0bF9sZHQxNikgew0KIAkJZXJy
b3IgPSAtRUlOVkFMOw0KIAkJZ290byBvdXRfdW5sb2NrOw0KIAl9DQpkaWZmIC0tZ2l0IGEvYXJj
aC94ODYvdmRzby92ZHNvMzItc2V0dXAuYyBiL2FyY2gveDg2L3Zkc28vdmRzbzMyLXNldHVwLmMN
CmluZGV4IDQ2OGQ1OTEuLjUxYmRjMDUgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni92ZHNvL3Zkc28z
Mi1zZXR1cC5jDQorKysgYi9hcmNoL3g4Ni92ZHNvL3Zkc28zMi1zZXR1cC5jDQpAQCAtNDEsNiAr
NDEsNyBAQCBlbnVtIHsNCiAjaWZkZWYgQ09ORklHX1g4Nl82NA0KICNkZWZpbmUgdmRzb19lbmFi
bGVkCQkJc3lzY3RsX3ZzeXNjYWxsMzINCiAjZGVmaW5lIGFyY2hfc2V0dXBfYWRkaXRpb25hbF9w
YWdlcwlzeXNjYWxsMzJfc2V0dXBfcGFnZXMNCitleHRlcm4gaW50IHN5c2N0bF9sZHQxNjsNCiAj
ZW5kaWYNCiANCiAvKg0KQEAgLTM4OCw2ICszODksMTMgQEAgc3RhdGljIGN0bF90YWJsZSBhYmlf
dGFibGUyW10gPSB7DQogCQkubW9kZQkJPSAwNjQ0LA0KIAkJLnByb2NfaGFuZGxlcgk9IHByb2Nf
ZG9pbnR2ZWMNCiAJfSwNCisJew0KKwkJLnByb2NuYW1lCT0gImxkdDE2IiwNCisJCS5kYXRhCQk9
ICZzeXNjdGxfbGR0MTYsDQorCQkubWF4bGVuCQk9IHNpemVvZihpbnQpLA0KKwkJLm1vZGUJCT0g
MDY0NCwNCisJCS5wcm9jX2hhbmRsZXIJPSBwcm9jX2RvaW50dmVjDQorCX0sDQogCXt9DQogfTsN
CiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2FjcGkvZWMuYyBiL2RyaXZlcnMvYWNwaS9lYy5jDQpp
bmRleCA4MTc2YjgyLi4zOTIzMDY0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9hY3BpL2VjLmMNCisr
KyBiL2RyaXZlcnMvYWNwaS9lYy5jDQpAQCAtNzAsNiArNzAsOCBAQCBlbnVtIGVjX2NvbW1hbmQg
ew0KICNkZWZpbmUgQUNQSV9FQ19ERUxBWQkJNTAwCS8qIFdhaXQgNTAwbXMgbWF4LiBkdXJpbmcg
RUMgb3BzICovDQogI2RlZmluZSBBQ1BJX0VDX1VERUxBWV9HTEsJMTAwMAkvKiBXYWl0IDFtcyBt
YXguIHRvIGdldCBnbG9iYWwgbG9jayAqLw0KICNkZWZpbmUgQUNQSV9FQ19NU0lfVURFTEFZCTU1
MAkvKiBXYWl0IDU1MHVzIGZvciBNU0kgRUMgKi8NCisjZGVmaW5lIEFDUElfRUNfQ0xFQVJfTUFY
CTEwMAkvKiBNYXhpbXVtIG51bWJlciBvZiBldmVudHMgdG8gcXVlcnkNCisJCQkJCSAqIHdoZW4g
dHJ5aW5nIHRvIGNsZWFyIHRoZSBFQyAqLw0KIA0KIGVudW0gew0KIAlFQ19GTEFHU19RVUVSWV9Q
RU5ESU5HLAkJLyogUXVlcnkgaXMgcGVuZGluZyAqLw0KQEAgLTEyMyw2ICsxMjUsNyBAQCBFWFBP
UlRfU1lNQk9MKGZpcnN0X2VjKTsNCiBzdGF0aWMgaW50IEVDX0ZMQUdTX01TSTsgLyogT3V0LW9m
LXNwZWMgTVNJIGNvbnRyb2xsZXIgKi8NCiBzdGF0aWMgaW50IEVDX0ZMQUdTX1ZBTElEQVRFX0VD
RFQ7IC8qIEFTVVN0ZWMgRUNEVHMgbmVlZCB0byBiZSB2YWxpZGF0ZWQgKi8NCiBzdGF0aWMgaW50
IEVDX0ZMQUdTX1NLSVBfRFNEVF9TQ0FOOyAvKiBOb3QgYWxsIEJJT1Mgc3Vydml2ZSBlYXJseSBE
U0RUIHNjYW4gKi8NCitzdGF0aWMgaW50IEVDX0ZMQUdTX0NMRUFSX09OX1JFU1VNRTsgLyogTmVl
ZHMgYWNwaV9lY19jbGVhcigpIG9uIGJvb3QvcmVzdW1lICovDQogDQogLyogLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFRyYW5zYWN0aW9uIE1hbmFnZW1l
bnQNCkBAIC0yMDMsMTMgKzIwNiwxMyBAQCB1bmxvY2s6DQogCXNwaW5fdW5sb2NrX2lycXJlc3Rv
cmUoJmVjLT5jdXJyX2xvY2ssIGZsYWdzKTsNCiB9DQogDQotc3RhdGljIGludCBhY3BpX2VjX3N5
bmNfcXVlcnkoc3RydWN0IGFjcGlfZWMgKmVjKTsNCitzdGF0aWMgaW50IGFjcGlfZWNfc3luY19x
dWVyeShzdHJ1Y3QgYWNwaV9lYyAqZWMsIHU4ICpkYXRhKTsNCiANCiBzdGF0aWMgaW50IGVjX2No
ZWNrX3NjaV9zeW5jKHN0cnVjdCBhY3BpX2VjICplYywgdTggc3RhdGUpDQogew0KIAlpZiAoc3Rh
dGUgJiBBQ1BJX0VDX0ZMQUdfU0NJKSB7DQogCQlpZiAoIXRlc3RfYW5kX3NldF9iaXQoRUNfRkxB
R1NfUVVFUllfUEVORElORywgJmVjLT5mbGFncykpDQotCQkJcmV0dXJuIGFjcGlfZWNfc3luY19x
dWVyeShlYyk7DQorCQkJcmV0dXJuIGFjcGlfZWNfc3luY19xdWVyeShlYywgTlVMTCk7DQogCX0N
CiAJcmV0dXJuIDA7DQogfQ0KQEAgLTQ0OSw2ICs0NTIsMjcgQEAgaW50IGVjX3RyYW5zYWN0aW9u
KHU4IGNvbW1hbmQsDQogDQogRVhQT1JUX1NZTUJPTChlY190cmFuc2FjdGlvbik7DQogDQorLyoN
CisgKiBQcm9jZXNzIF9RIGV2ZW50cyB0aGF0IG1pZ2h0IGhhdmUgYWNjdW11bGF0ZWQgaW4gdGhl
IEVDLg0KKyAqIFJ1biB3aXRoIGxvY2tlZCBlYyBtdXRleC4NCisgKi8NCitzdGF0aWMgdm9pZCBh
Y3BpX2VjX2NsZWFyKHN0cnVjdCBhY3BpX2VjICplYykNCit7DQorCWludCBpLCBzdGF0dXM7DQor
CXU4IHZhbHVlID0gMDsNCisNCisJZm9yIChpID0gMDsgaSA8IEFDUElfRUNfQ0xFQVJfTUFYOyBp
KyspIHsNCisJCXN0YXR1cyA9IGFjcGlfZWNfc3luY19xdWVyeShlYywgJnZhbHVlKTsNCisJCWlm
IChzdGF0dXMgfHwgIXZhbHVlKQ0KKwkJCWJyZWFrOw0KKwl9DQorDQorCWlmICh1bmxpa2VseShp
ID09IEFDUElfRUNfQ0xFQVJfTUFYKSkNCisJCXByX3dhcm4oIldhcm5pbmc6IE1heGltdW0gb2Yg
JWQgc3RhbGUgRUMgZXZlbnRzIGNsZWFyZWRcbiIsIGkpOw0KKwllbHNlDQorCQlwcl9pbmZvKCIl
ZCBzdGFsZSBFQyBldmVudHMgY2xlYXJlZFxuIiwgaSk7DQorfQ0KKw0KIHZvaWQgYWNwaV9lY19i
bG9ja190cmFuc2FjdGlvbnModm9pZCkNCiB7DQogCXN0cnVjdCBhY3BpX2VjICplYyA9IGZpcnN0
X2VjOw0KQEAgLTQ3Miw2ICs0OTYsMTAgQEAgdm9pZCBhY3BpX2VjX3VuYmxvY2tfdHJhbnNhY3Rp
b25zKHZvaWQpDQogCW11dGV4X2xvY2soJmVjLT5sb2NrKTsNCiAJLyogQWxsb3cgdHJhbnNhY3Rp
b25zIHRvIGJlIGNhcnJpZWQgb3V0IGFnYWluICovDQogCWNsZWFyX2JpdChFQ19GTEFHU19CTE9D
S0VELCAmZWMtPmZsYWdzKTsNCisNCisJaWYgKEVDX0ZMQUdTX0NMRUFSX09OX1JFU1VNRSkNCisJ
CWFjcGlfZWNfY2xlYXIoZWMpOw0KKw0KIAltdXRleF91bmxvY2soJmVjLT5sb2NrKTsNCiB9DQog
DQpAQCAtNTYxLDEzICs1ODksMTggQEAgc3RhdGljIHZvaWQgYWNwaV9lY19ydW4odm9pZCAqY3h0
KQ0KIAlrZnJlZShoYW5kbGVyKTsNCiB9DQogDQotc3RhdGljIGludCBhY3BpX2VjX3N5bmNfcXVl
cnkoc3RydWN0IGFjcGlfZWMgKmVjKQ0KK3N0YXRpYyBpbnQgYWNwaV9lY19zeW5jX3F1ZXJ5KHN0
cnVjdCBhY3BpX2VjICplYywgdTggKmRhdGEpDQogew0KIAl1OCB2YWx1ZSA9IDA7DQogCWludCBz
dGF0dXM7DQogCXN0cnVjdCBhY3BpX2VjX3F1ZXJ5X2hhbmRsZXIgKmhhbmRsZXIsICpjb3B5Ow0K
LQlpZiAoKHN0YXR1cyA9IGFjcGlfZWNfcXVlcnlfdW5sb2NrZWQoZWMsICZ2YWx1ZSkpKQ0KKw0K
KwlzdGF0dXMgPSBhY3BpX2VjX3F1ZXJ5X3VubG9ja2VkKGVjLCAmdmFsdWUpOw0KKwlpZiAoZGF0
YSkNCisJCSpkYXRhID0gdmFsdWU7DQorCWlmIChzdGF0dXMpDQogCQlyZXR1cm4gc3RhdHVzOw0K
Kw0KIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGhhbmRsZXIsICZlYy0+bGlzdCwgbm9kZSkgew0KIAkJ
aWYgKHZhbHVlID09IGhhbmRsZXItPnF1ZXJ5X2JpdCkgew0KIAkJCS8qIGhhdmUgY3VzdG9tIGhh
bmRsZXIgZm9yIHRoaXMgYml0ICovDQpAQCAtNTkwLDcgKzYyMyw3IEBAIHN0YXRpYyB2b2lkIGFj
cGlfZWNfZ3BlX3F1ZXJ5KHZvaWQgKmVjX2N4dCkNCiAJaWYgKCFlYykNCiAJCXJldHVybjsNCiAJ
bXV0ZXhfbG9jaygmZWMtPmxvY2spOw0KLQlhY3BpX2VjX3N5bmNfcXVlcnkoZWMpOw0KKwlhY3Bp
X2VjX3N5bmNfcXVlcnkoZWMsIE5VTEwpOw0KIAltdXRleF91bmxvY2soJmVjLT5sb2NrKTsNCiB9
DQogDQpAQCAtODI4LDYgKzg2MSwxMyBAQCBzdGF0aWMgaW50IGFjcGlfZWNfYWRkKHN0cnVjdCBh
Y3BpX2RldmljZSAqZGV2aWNlKQ0KIA0KIAkvKiBFQyBpcyBmdWxseSBvcGVyYXRpb25hbCwgYWxs
b3cgcXVlcmllcyAqLw0KIAljbGVhcl9iaXQoRUNfRkxBR1NfUVVFUllfUEVORElORywgJmVjLT5m
bGFncyk7DQorDQorCS8qIENsZWFyIHN0YWxlIF9RIGV2ZW50cyBpZiBoYXJkd2FyZSBtaWdodCBy
ZXF1aXJlIHRoYXQgKi8NCisJaWYgKEVDX0ZMQUdTX0NMRUFSX09OX1JFU1VNRSkgew0KKwkJbXV0
ZXhfbG9jaygmZWMtPmxvY2spOw0KKwkJYWNwaV9lY19jbGVhcihlYyk7DQorCQltdXRleF91bmxv
Y2soJmVjLT5sb2NrKTsNCisJfQ0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCkBAIC05MjksNiArOTY5
LDMwIEBAIHN0YXRpYyBpbnQgZWNfZW5sYXJnZV9zdG9ybV90aHJlc2hvbGQoY29uc3Qgc3RydWN0
IGRtaV9zeXN0ZW1faWQgKmlkKQ0KIAlyZXR1cm4gMDsNCiB9DQogDQorLyoNCisgKiBPbiBzb21l
IGhhcmR3YXJlIGl0IGlzIG5lY2Vzc2FyeSB0byBjbGVhciBldmVudHMgYWNjdW11bGF0ZWQgYnkg
dGhlIEVDIGR1cmluZw0KKyAqIHNsZWVwLiBUaGVzZSBFQ3Mgc3RvcCByZXBvcnRpbmcgR1BFcyB1
bnRpbCB0aGV5IGFyZSBtYW51YWxseSBwb2xsZWQsIGlmIHRvbw0KKyAqIG1hbnkgZXZlbnRzIGFy
ZSBhY2N1bXVsYXRlZC4gKGUuZy4gU2Ftc3VuZyBTZXJpZXMgNS85IG5vdGVib29rcykNCisgKg0K
KyAqIGh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9NDQxNjENCisg
Kg0KKyAqIElkZWFsbHksIHRoZSBFQyBzaG91bGQgYWxzbyBiZSBpbnN0cnVjdGVkIE5PVCB0byBh
Y2N1bXVsYXRlIGV2ZW50cyBkdXJpbmcNCisgKiBzbGVlcCAod2hpY2ggV2luZG93cyBzZWVtcyB0
byBkbyBzb21laG93KSwgYnV0IHRoZSBpbnRlcmZhY2UgdG8gY29udHJvbCB0aGlzDQorICogYmVo
YXZpb3VyIGlzIG5vdCBrbm93biBhdCB0aGlzIHRpbWUuDQorICoNCisgKiBNb2RlbHMga25vd24g
dG8gYmUgYWZmZWN0ZWQgYXJlIFNhbXN1bmcgNTMwVXh4LzUzNVV4eC81NDBVeHgvNTUwUHh4Lzkw
MFh4eCwNCisgKiBob3dldmVyIGl0IGlzIHZlcnkgbGlrZWx5IHRoYXQgb3RoZXIgU2Ftc3VuZyBt
b2RlbHMgYXJlIGFmZmVjdGVkLg0KKyAqDQorICogT24gc3lzdGVtcyB3aGljaCBkb24ndCBhY2N1
bXVsYXRlIF9RIGV2ZW50cyBkdXJpbmcgc2xlZXAsIHRoaXMgZXh0cmEgY2hlY2sNCisgKiBzaG91
bGQgYmUgaGFybWxlc3MuDQorICovDQorc3RhdGljIGludCBlY19jbGVhcl9vbl9yZXN1bWUoY29u
c3Qgc3RydWN0IGRtaV9zeXN0ZW1faWQgKmlkKQ0KK3sNCisJcHJfZGVidWcoIkRldGVjdGVkIHN5
c3RlbSBuZWVkaW5nIEVDIHBvbGwgb24gcmVzdW1lLlxuIik7DQorCUVDX0ZMQUdTX0NMRUFSX09O
X1JFU1VNRSA9IDE7DQorCXJldHVybiAwOw0KK30NCisNCiBzdGF0aWMgc3RydWN0IGRtaV9zeXN0
ZW1faWQgX19pbml0ZGF0YSBlY19kbWlfdGFibGVbXSA9IHsNCiAJew0KIAllY19za2lwX2RzZHRf
c2NhbiwgIkNvbXBhbCBKRkw5MiIsIHsNCkBAIC05NjgsNiArMTAzMiw5IEBAIHN0YXRpYyBzdHJ1
Y3QgZG1pX3N5c3RlbV9pZCBfX2luaXRkYXRhIGVjX2RtaV90YWJsZVtdID0gew0KIAllY192YWxp
ZGF0ZV9lY2R0LCAiQVNVUyBoYXJkd2FyZSIsIHsNCiAJRE1JX01BVENIKERNSV9TWVNfVkVORE9S
LCAiQVNVU1RlayBDb21wdXRlciBJbmMuIiksDQogCURNSV9NQVRDSChETUlfUFJPRFVDVF9OQU1F
LCAiTDRSIiksfSwgTlVMTH0sDQorCXsNCisJZWNfY2xlYXJfb25fcmVzdW1lLCAiU2Ftc3VuZyBo
YXJkd2FyZSIsIHsNCisJRE1JX01BVENIKERNSV9TWVNfVkVORE9SLCAiU0FNU1VORyBFTEVDVFJP
TklDUyBDTy4sIExURC4iKX0sIE5VTEx9LA0KIAl7fSwNCiB9Ow0KIA0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvYXRtL2FtYmFzc2Fkb3IuYyBiL2RyaXZlcnMvYXRtL2FtYmFzc2Fkb3IuYw0KaW5kZXgg
ZjhmNDFlMC4uODliMzBmMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYXRtL2FtYmFzc2Fkb3IuYw0K
KysrIGIvZHJpdmVycy9hdG0vYW1iYXNzYWRvci5jDQpAQCAtODAyLDcgKzgwMiw3IEBAIHN0YXRp
YyB2b2lkIGZpbGxfcnhfcG9vbCAoYW1iX2RldiAqIGRldiwgdW5zaWduZWQgY2hhciBwb29sLA0K
ICAgICB9DQogICAgIC8vIGNhc3QgbmVlZGVkIGFzIHRoZXJlIGlzIG5vICU/IGZvciBwb2ludGVy
IGRpZmZlcmVuY2VzDQogICAgIFBSSU5URCAoREJHX1NLQiwgImFsbG9jYXRlZCBza2IgYXQgJXAs
IGhlYWQgJXAsIGFyZWEgJWxpIiwNCi0JICAgIHNrYiwgc2tiLT5oZWFkLCAobG9uZykgKHNrYl9l
bmRfcG9pbnRlcihza2IpIC0gc2tiLT5oZWFkKSk7DQorCSAgICBza2IsIHNrYi0+aGVhZCwgKGxv
bmcpIHNrYl9lbmRfb2Zmc2V0KHNrYikpOw0KICAgICByeC5oYW5kbGUgPSB2aXJ0X3RvX2J1cyAo
c2tiKTsNCiAgICAgcnguaG9zdF9hZGRyZXNzID0gY3B1X3RvX2JlMzIgKHZpcnRfdG9fYnVzIChz
a2ItPmRhdGEpKTsNCiAgICAgaWYgKHJ4X2dpdmUgKGRldiwgJnJ4LCBwb29sKSkNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL2F0bS9pZHQ3NzI1Mi5jIGIvZHJpdmVycy9hdG0vaWR0NzcyNTIuYw0KaW5k
ZXggYjBlNzVjZS4uODE4NDVmYSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYXRtL2lkdDc3MjUyLmMN
CisrKyBiL2RyaXZlcnMvYXRtL2lkdDc3MjUyLmMNCkBAIC0xMjU4LDcgKzEyNTgsNyBAQCBpZHQ3
NzI1Ml9yeF9yYXcoc3RydWN0IGlkdDc3MjUyX2RldiAqY2FyZCkNCiAJdGFpbCA9IHJlYWRsKFNB
Ul9SRUdfUkFXQ1QpOw0KIA0KIAlwY2lfZG1hX3N5bmNfc2luZ2xlX2Zvcl9jcHUoY2FyZC0+cGNp
ZGV2LCBJRFQ3NzI1Ml9QUlZfUEFERFIocXVldWUpLA0KLQkJCQkgICAgc2tiX2VuZF9wb2ludGVy
KHF1ZXVlKSAtIHF1ZXVlLT5oZWFkIC0gMTYsDQorCQkJCSAgICBza2JfZW5kX29mZnNldChxdWV1
ZSkgLSAxNiwNCiAJCQkJICAgIFBDSV9ETUFfRlJPTURFVklDRSk7DQogDQogCXdoaWxlIChoZWFk
ICE9IHRhaWwpIHsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2JsdWV0b290aC9hdGgzay5jIGIvZHJp
dmVycy9ibHVldG9vdGgvYXRoM2suYw0KaW5kZXggMzUzOWY5Yi4uNmZlMDAzYSAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvYmx1ZXRvb3RoL2F0aDNrLmMNCisrKyBiL2RyaXZlcnMvYmx1ZXRvb3RoL2F0
aDNrLmMNCkBAIC04MSw2ICs4MSw3IEBAIHN0YXRpYyBzdHJ1Y3QgdXNiX2RldmljZV9pZCBhdGgz
a190YWJsZVtdID0gew0KIAl7IFVTQl9ERVZJQ0UoMHgwNENBLCAweDMwMDQpIH0sDQogCXsgVVNC
X0RFVklDRSgweDA0Q0EsIDB4MzAwNSkgfSwNCiAJeyBVU0JfREVWSUNFKDB4MDRDQSwgMHgzMDA2
KSB9LA0KKwl7IFVTQl9ERVZJQ0UoMHgwNENBLCAweDMwMDcpIH0sDQogCXsgVVNCX0RFVklDRSgw
eDA0Q0EsIDB4MzAwOCkgfSwNCiAJeyBVU0JfREVWSUNFKDB4MTNkMywgMHgzMzYyKSB9LA0KIAl7
IFVTQl9ERVZJQ0UoMHgwQ0YzLCAweEUwMDQpIH0sDQpAQCAtMTIzLDYgKzEyNCw3IEBAIHN0YXRp
YyBzdHJ1Y3QgdXNiX2RldmljZV9pZCBhdGgza19ibGlzdF90YmxbXSA9IHsNCiAJeyBVU0JfREVW
SUNFKDB4MDRjYSwgMHgzMDA0KSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KIAl7
IFVTQl9ERVZJQ0UoMHgwNGNhLCAweDMwMDUpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEy
IH0sDQogCXsgVVNCX0RFVklDRSgweDA0Y2EsIDB4MzAwNiksIC5kcml2ZXJfaW5mbyA9IEJUVVNC
X0FUSDMwMTIgfSwNCisJeyBVU0JfREVWSUNFKDB4MDRjYSwgMHgzMDA3KSwgLmRyaXZlcl9pbmZv
ID0gQlRVU0JfQVRIMzAxMiB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgwNGNhLCAweDMwMDgpLCAuZHJp
dmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQogCXsgVVNCX0RFVklDRSgweDEzZDMsIDB4MzM2
MiksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiAJeyBVU0JfREVWSUNFKDB4MGNm
MywgMHhlMDA0KSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvYmx1ZXRvb3RoL2J0dXNiLmMgYi9kcml2ZXJzL2JsdWV0b290aC9idHVzYi5jDQpp
bmRleCBmMThiNWEyLi5kZGRjYjFkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ibHVldG9vdGgvYnR1
c2IuYw0KKysrIGIvZHJpdmVycy9ibHVldG9vdGgvYnR1c2IuYw0KQEAgLTE1Miw2ICsxNTIsNyBA
QCBzdGF0aWMgc3RydWN0IHVzYl9kZXZpY2VfaWQgYmxhY2tsaXN0X3RhYmxlW10gPSB7DQogCXsg
VVNCX0RFVklDRSgweDA0Y2EsIDB4MzAwNCksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIg
fSwNCiAJeyBVU0JfREVWSUNFKDB4MDRjYSwgMHgzMDA1KSwgLmRyaXZlcl9pbmZvID0gQlRVU0Jf
QVRIMzAxMiB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgwNGNhLCAweDMwMDYpLCAuZHJpdmVyX2luZm8g
PSBCVFVTQl9BVEgzMDEyIH0sDQorCXsgVVNCX0RFVklDRSgweDA0Y2EsIDB4MzAwNyksIC5kcml2
ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiAJeyBVU0JfREVWSUNFKDB4MDRjYSwgMHgzMDA4
KSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgxM2Qz
LCAweDMzNjIpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQogCXsgVVNCX0RFVklD
RSgweDBjZjMsIDB4ZTAwNCksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2NyeXB0by9jYWFtL2Vycm9yLmMgYi9kcml2ZXJzL2NyeXB0by9jYWFt
L2Vycm9yLmMNCmluZGV4IDdlMmQ1NGIuLjliOGQyMzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Ny
eXB0by9jYWFtL2Vycm9yLmMNCisrKyBiL2RyaXZlcnMvY3J5cHRvL2NhYW0vZXJyb3IuYw0KQEAg
LTE2LDkgKzE2LDEzIEBADQogCWNoYXIgKnRtcDsJCQkJCQlcDQogCQkJCQkJCQlcDQogCXRtcCA9
IGttYWxsb2Moc2l6ZW9mKGZvcm1hdCkgKyBtYXhfYWxsb2MsIEdGUF9BVE9NSUMpOwlcDQotCXNw
cmludGYodG1wLCBmb3JtYXQsIHBhcmFtKTsJCQkJXA0KLQlzdHJjYXQoc3RyLCB0bXApOwkJCQkJ
XA0KLQlrZnJlZSh0bXApOwkJCQkJCVwNCisJaWYgKGxpa2VseSh0bXApKSB7CQkJCQlcDQorCQlz
cHJpbnRmKHRtcCwgZm9ybWF0LCBwYXJhbSk7CQkJXA0KKwkJc3RyY2F0KHN0ciwgdG1wKTsJCQkJ
XA0KKwkJa2ZyZWUodG1wKTsJCQkJCVwNCisJfSBlbHNlIHsJCQkJCQlcDQorCQlzdHJjYXQoc3Ry
LCAia21hbGxvYyBmYWlsdXJlIGluIFNQUklOVEZDQVQiKTsJXA0KKwl9CQkJCQkJCVwNCiB9DQog
DQogc3RhdGljIHZvaWQgcmVwb3J0X2p1bXBfaWR4KHUzMiBzdGF0dXMsIGNoYXIgKm91dHN0cikN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2RtYS9tdl94b3IuYyBiL2RyaXZlcnMvZG1hL212X3hvci5j
DQppbmRleCA5YTM1M2MyLi45YjAxMTQ1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9kbWEvbXZfeG9y
LmMNCisrKyBiL2RyaXZlcnMvZG1hL212X3hvci5jDQpAQCAtMjE4LDEyICsyMTgsMTAgQEAgc3Rh
dGljIHZvaWQgbXZfc2V0X21vZGUoc3RydWN0IG12X3hvcl9jaGFuICpjaGFuLA0KIA0KIHN0YXRp
YyB2b2lkIG12X2NoYW5fYWN0aXZhdGUoc3RydWN0IG12X3hvcl9jaGFuICpjaGFuKQ0KIHsNCi0J
dTMyIGFjdGl2YXRpb247DQotDQogCWRldl9kYmcoY2hhbi0+ZGV2aWNlLT5jb21tb24uZGV2LCAi
IGFjdGl2YXRlIGNoYW4uXG4iKTsNCi0JYWN0aXZhdGlvbiA9IF9fcmF3X3JlYWRsKFhPUl9BQ1RJ
VkFUSU9OKGNoYW4pKTsNCi0JYWN0aXZhdGlvbiB8PSAweDE7DQotCV9fcmF3X3dyaXRlbChhY3Rp
dmF0aW9uLCBYT1JfQUNUSVZBVElPTihjaGFuKSk7DQorDQorCS8qIHdyaXRlbCBlbnN1cmVzIGFs
bCBkZXNjcmlwdG9ycyBhcmUgZmx1c2hlZCBiZWZvcmUgYWN0aXZhdGlvbiAqLw0KKwl3cml0ZWwo
QklUKDApLCBYT1JfQUNUSVZBVElPTihjaGFuKSk7DQogfQ0KIA0KIHN0YXRpYyBjaGFyIG12X2No
YW5faXNfYnVzeShzdHJ1Y3QgbXZfeG9yX2NoYW4gKmNoYW4pDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9ncHUvZHJtL25vdXZlYXUvbm91dmVhdV9hY3BpLmMgYi9kcml2ZXJzL2dwdS9kcm0vbm91dmVh
dS9ub3V2ZWF1X2FjcGkuYw0KaW5kZXggM2RmNTZjNy4uNWVlOGNjYSAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvZ3B1L2RybS9ub3V2ZWF1L25vdXZlYXVfYWNwaS5jDQorKysgYi9kcml2ZXJzL2dwdS9k
cm0vbm91dmVhdS9ub3V2ZWF1X2FjcGkuYw0KQEAgLTMzMiw5ICszMzIsNiBAQCBib29sIG5vdXZl
YXVfYWNwaV9yb21fc3VwcG9ydGVkKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQ0KIAlhY3BpX3N0YXR1
cyBzdGF0dXM7DQogCWFjcGlfaGFuZGxlIGRoYW5kbGUsIHJvbV9oYW5kbGU7DQogDQotCWlmICgh
bm91dmVhdV9kc21fcHJpdi5kc21fZGV0ZWN0ZWQgJiYgIW5vdXZlYXVfZHNtX3ByaXYub3B0aW11
c19kZXRlY3RlZCkNCi0JCXJldHVybiBmYWxzZTsNCi0NCiAJZGhhbmRsZSA9IERFVklDRV9BQ1BJ
X0hBTkRMRSgmcGRldi0+ZGV2KTsNCiAJaWYgKCFkaGFuZGxlKQ0KIAkJcmV0dXJuIGZhbHNlOw0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2Jpb3MuYyBiL2RyaXZl
cnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2Jpb3MuYw0KaW5kZXggZDMwNmNjOC4uY2NmMzI0YiAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2Jpb3MuYw0KKysrIGIv
ZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fYmlvcy5jDQpAQCAtMTczLDYgKzE3MywyMCBA
QCBzdGF0aWMgYm9vbCByYWRlb25fYXRybV9nZXRfYmlvcyhzdHJ1Y3QgcmFkZW9uX2RldmljZSAq
cmRldikNCiAJCX0NCiAJfQ0KIA0KKwlpZiAoIWZvdW5kKSB7DQorCQl3aGlsZSAoKHBkZXYgPSBw
Y2lfZ2V0X2NsYXNzKFBDSV9DTEFTU19ESVNQTEFZX09USEVSIDw8IDgsIHBkZXYpKSAhPSBOVUxM
KSB7DQorCQkJZGhhbmRsZSA9IERFVklDRV9BQ1BJX0hBTkRMRSgmcGRldi0+ZGV2KTsNCisJCQlp
ZiAoIWRoYW5kbGUpDQorCQkJCWNvbnRpbnVlOw0KKw0KKwkJCXN0YXR1cyA9IGFjcGlfZ2V0X2hh
bmRsZShkaGFuZGxlLCAiQVRSTSIsICZhdHJtX2hhbmRsZSk7DQorCQkJaWYgKCFBQ1BJX0ZBSUxV
UkUoc3RhdHVzKSkgew0KKwkJCQlmb3VuZCA9IHRydWU7DQorCQkJCWJyZWFrOw0KKwkJCX0NCisJ
CX0NCisJfQ0KKw0KIAlpZiAoIWZvdW5kKQ0KIAkJcmV0dXJuIGZhbHNlOw0KIA0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX29iamVjdC5jIGIvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9yYWRlb25fb2JqZWN0LmMNCmluZGV4IGYzYWU2MDcuLjNlMzViYmUgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9vYmplY3QuYw0KKysrIGIvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fb2JqZWN0LmMNCkBAIC01MTMsMjIgKzUxMywzMCBA
QCBpbnQgcmFkZW9uX2JvX2ZhdWx0X3Jlc2VydmVfbm90aWZ5KHN0cnVjdCB0dG1fYnVmZmVyX29i
amVjdCAqYm8pDQogCXJibyA9IGNvbnRhaW5lcl9vZihibywgc3RydWN0IHJhZGVvbl9ibywgdGJv
KTsNCiAJcmFkZW9uX2JvX2NoZWNrX3RpbGluZyhyYm8sIDAsIDApOw0KIAlyZGV2ID0gcmJvLT5y
ZGV2Ow0KLQlpZiAoYm8tPm1lbS5tZW1fdHlwZSA9PSBUVE1fUExfVlJBTSkgew0KLQkJc2l6ZSA9
IGJvLT5tZW0ubnVtX3BhZ2VzIDw8IFBBR0VfU0hJRlQ7DQotCQlvZmZzZXQgPSBiby0+bWVtLnN0
YXJ0IDw8IFBBR0VfU0hJRlQ7DQotCQlpZiAoKG9mZnNldCArIHNpemUpID4gcmRldi0+bWMudmlz
aWJsZV92cmFtX3NpemUpIHsNCi0JCQkvKiBodXJyYWggdGhlIG1lbW9yeSBpcyBub3QgdmlzaWJs
ZSAhICovDQotCQkJcmFkZW9uX3R0bV9wbGFjZW1lbnRfZnJvbV9kb21haW4ocmJvLCBSQURFT05f
R0VNX0RPTUFJTl9WUkFNKTsNCi0JCQlyYm8tPnBsYWNlbWVudC5scGZuID0gcmRldi0+bWMudmlz
aWJsZV92cmFtX3NpemUgPj4gUEFHRV9TSElGVDsNCi0JCQlyID0gdHRtX2JvX3ZhbGlkYXRlKGJv
LCAmcmJvLT5wbGFjZW1lbnQsIGZhbHNlLCB0cnVlLCBmYWxzZSk7DQotCQkJaWYgKHVubGlrZWx5
KHIgIT0gMCkpDQotCQkJCXJldHVybiByOw0KLQkJCW9mZnNldCA9IGJvLT5tZW0uc3RhcnQgPDwg
UEFHRV9TSElGVDsNCi0JCQkvKiB0aGlzIHNob3VsZCBub3QgaGFwcGVuICovDQotCQkJaWYgKChv
ZmZzZXQgKyBzaXplKSA+IHJkZXYtPm1jLnZpc2libGVfdnJhbV9zaXplKQ0KLQkJCQlyZXR1cm4g
LUVJTlZBTDsNCi0JCX0NCisJaWYgKGJvLT5tZW0ubWVtX3R5cGUgIT0gVFRNX1BMX1ZSQU0pDQor
CQlyZXR1cm4gMDsNCisNCisJc2l6ZSA9IGJvLT5tZW0ubnVtX3BhZ2VzIDw8IFBBR0VfU0hJRlQ7
DQorCW9mZnNldCA9IGJvLT5tZW0uc3RhcnQgPDwgUEFHRV9TSElGVDsNCisJaWYgKChvZmZzZXQg
KyBzaXplKSA8PSByZGV2LT5tYy52aXNpYmxlX3ZyYW1fc2l6ZSkNCisJCXJldHVybiAwOw0KKw0K
KwkvKiBodXJyYWggdGhlIG1lbW9yeSBpcyBub3QgdmlzaWJsZSAhICovDQorCXJhZGVvbl90dG1f
cGxhY2VtZW50X2Zyb21fZG9tYWluKHJibywgUkFERU9OX0dFTV9ET01BSU5fVlJBTSk7DQorCXJi
by0+cGxhY2VtZW50LmxwZm4gPSByZGV2LT5tYy52aXNpYmxlX3ZyYW1fc2l6ZSA+PiBQQUdFX1NI
SUZUOw0KKwlyID0gdHRtX2JvX3ZhbGlkYXRlKGJvLCAmcmJvLT5wbGFjZW1lbnQsIGZhbHNlLCB0
cnVlLCBmYWxzZSk7DQorCWlmICh1bmxpa2VseShyID09IC1FTk9NRU0pKSB7DQorCQlyYWRlb25f
dHRtX3BsYWNlbWVudF9mcm9tX2RvbWFpbihyYm8sIFJBREVPTl9HRU1fRE9NQUlOX0dUVCk7DQor
CQlyZXR1cm4gdHRtX2JvX3ZhbGlkYXRlKGJvLCAmcmJvLT5wbGFjZW1lbnQsIGZhbHNlLCB0cnVl
LCBmYWxzZSk7DQorCX0gZWxzZSBpZiAodW5saWtlbHkociAhPSAwKSkgew0KKwkJcmV0dXJuIHI7
DQogCX0NCisNCisJb2Zmc2V0ID0gYm8tPm1lbS5zdGFydCA8PCBQQUdFX1NISUZUOw0KKwkvKiB0
aGlzIHNob3VsZCBuZXZlciBoYXBwZW4gKi8NCisJaWYgKChvZmZzZXQgKyBzaXplKSA+IHJkZXYt
Pm1jLnZpc2libGVfdnJhbV9zaXplKQ0KKwkJcmV0dXJuIC1FSU5WQUw7DQorDQogCXJldHVybiAw
Ow0KIH0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vdm13Z2Z4L3Ztd2dmeF9leGVj
YnVmLmMgYi9kcml2ZXJzL2dwdS9kcm0vdm13Z2Z4L3Ztd2dmeF9leGVjYnVmLmMNCmluZGV4IDQw
OTMyZmIuLjg0YmEwMzMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vdm13Z2Z4L3Ztd2dm
eF9leGVjYnVmLmMNCisrKyBiL2RyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4X2V4ZWNidWYu
Yw0KQEAgLTU1OCwxNCArNTU4LDM2IEBAIHN0YXRpYyBpbnQgdm13X2NtZF9kbWEoc3RydWN0IHZt
d19wcml2YXRlICpkZXZfcHJpdiwNCiAJfSAqY21kOw0KIAlpbnQgcmV0Ow0KIAlzdHJ1Y3Qgdm13
X3Jlc291cmNlICpyZXM7DQorCVNWR0EzZENtZFN1cmZhY2VETUFTdWZmaXggKnN1ZmZpeDsNCisJ
dWludDMyX3QgYm9fc2l6ZTsNCiANCiAJY21kID0gY29udGFpbmVyX29mKGhlYWRlciwgc3RydWN0
IHZtd19kbWFfY21kLCBoZWFkZXIpOw0KKwlzdWZmaXggPSAoU1ZHQTNkQ21kU3VyZmFjZURNQVN1
ZmZpeCAqKSgodW5zaWduZWQgbG9uZykgJmNtZC0+ZG1hICsNCisJCQkJCSAgICAgICBoZWFkZXIt
PnNpemUgLSBzaXplb2YoKnN1ZmZpeCkpOw0KKw0KKwkvKiBNYWtlIHN1cmUgZGV2aWNlIGFuZCB2
ZXJpZmllciBzdGF5cyBpbiBzeW5jLiAqLw0KKwlpZiAodW5saWtlbHkoc3VmZml4LT5zdWZmaXhT
aXplICE9IHNpemVvZigqc3VmZml4KSkpIHsNCisJCURSTV9FUlJPUigiSW52YWxpZCBETUEgc3Vm
Zml4IHNpemUuXG4iKTsNCisJCXJldHVybiAtRUlOVkFMOw0KKwl9DQorDQogCXJldCA9IHZtd190
cmFuc2xhdGVfZ3Vlc3RfcHRyKGRldl9wcml2LCBzd19jb250ZXh0LA0KIAkJCQkgICAgICAmY21k
LT5kbWEuZ3Vlc3QucHRyLA0KIAkJCQkgICAgICAmdm13X2JvKTsNCiAJaWYgKHVubGlrZWx5KHJl
dCAhPSAwKSkNCiAJCXJldHVybiByZXQ7DQogDQorCS8qIE1ha2Ugc3VyZSBETUEgZG9lc24ndCBj
cm9zcyBCTyBib3VuZGFyaWVzLiAqLw0KKwlib19zaXplID0gdm13X2JvLT5iYXNlLm51bV9wYWdl
cyAqIFBBR0VfU0laRTsNCisJaWYgKHVubGlrZWx5KGNtZC0+ZG1hLmd1ZXN0LnB0ci5vZmZzZXQg
PiBib19zaXplKSkgew0KKwkJRFJNX0VSUk9SKCJJbnZhbGlkIERNQSBvZmZzZXQuXG4iKTsNCisJ
CXJldHVybiAtRUlOVkFMOw0KKwl9DQorDQorCWJvX3NpemUgLT0gY21kLT5kbWEuZ3Vlc3QucHRy
Lm9mZnNldDsNCisJaWYgKHVubGlrZWx5KHN1ZmZpeC0+bWF4aW11bU9mZnNldCA+IGJvX3NpemUp
KQ0KKwkJc3VmZml4LT5tYXhpbXVtT2Zmc2V0ID0gYm9fc2l6ZTsNCisNCiAJYm8gPSAmdm13X2Jv
LT5iYXNlOw0KIAlyZXQgPSB2bXdfdXNlcl9zdXJmYWNlX2xvb2t1cF9oYW5kbGUoZGV2X3ByaXYs
IHN3X2NvbnRleHQtPnRmaWxlLA0KIAkJCQkJICAgICBjbWQtPmRtYS5ob3N0LnNpZCwgJnNyZik7
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9oaWQvaGlkLWlkcy5oIGIvZHJpdmVycy9oaWQvaGlkLWlk
cy5oDQppbmRleCBjYTJiM2U2Li5jY2M4OWIwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9oaWQvaGlk
LWlkcy5oDQorKysgYi9kcml2ZXJzL2hpZC9oaWQtaWRzLmgNCkBAIC02NzgsNiArNjc4LDEzIEBA
DQogI2RlZmluZSBVU0JfREVWSUNFX0lEX1NZTUJPTF9TQ0FOTkVSXzEJMHgwODAwDQogI2RlZmlu
ZSBVU0JfREVWSUNFX0lEX1NZTUJPTF9TQ0FOTkVSXzIJMHgxMzAwDQogDQorI2RlZmluZSBVU0Jf
VkVORE9SX0lEX1NZTkFQVElDUwkJMHgwNmNiDQorI2RlZmluZSBVU0JfREVWSUNFX0lEX1NZTkFQ
VElDU19MVFMxCTB4MGFmOA0KKyNkZWZpbmUgVVNCX0RFVklDRV9JRF9TWU5BUFRJQ1NfTFRTMgkw
eDFkMTANCisjZGVmaW5lIFVTQl9ERVZJQ0VfSURfU1lOQVBUSUNTX0hECTB4MGFjMw0KKyNkZWZp
bmUgVVNCX0RFVklDRV9JRF9TWU5BUFRJQ1NfUVVBRF9IRAkweDFhYzMNCisjZGVmaW5lIFVTQl9E
RVZJQ0VfSURfU1lOQVBUSUNTX1RQX1YxMDMJMHg1NzEwDQorDQogI2RlZmluZSBVU0JfVkVORE9S
X0lEX1RIUlVTVE1BU1RFUgkweDA0NGYNCiANCiAjZGVmaW5lIFVTQl9WRU5ET1JfSURfVE9QU0VF
RAkJMHgwNzY2DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9oaWQvdXNiaGlkL2hpZC1xdWlya3MuYyBi
L2RyaXZlcnMvaGlkL3VzYmhpZC9oaWQtcXVpcmtzLmMNCmluZGV4IGY5OGZiYWQuLjcxYzI1ODIg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL2hpZC91c2JoaWQvaGlkLXF1aXJrcy5jDQorKysgYi9kcml2
ZXJzL2hpZC91c2JoaWQvaGlkLXF1aXJrcy5jDQpAQCAtMTAwLDYgKzEwMCwxMSBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IGhpZF9ibGFja2xpc3Qgew0KIAl7IFVTQl9WRU5ET1JfSURfQ0hJQ09OWSwg
VVNCX0RFVklDRV9JRF9DSElDT05ZX1dJUkVMRVNTLCBISURfUVVJUktfTVVMVElfSU5QVVQgfSwN
CiAJeyBVU0JfVkVORE9SX0lEX1NJR01BX01JQ1JPLCBVU0JfREVWSUNFX0lEX1NJR01BX01JQ1JP
X0tFWUJPQVJELCBISURfUVVJUktfTk9fSU5JVF9SRVBPUlRTIH0sDQogCXsgVVNCX1ZFTkRPUl9J
RF9OVFJJRywgVVNCX0RFVklDRV9JRF9OVFJJR19EVU9TRU5TRSwgSElEX1FVSVJLX05PX0lOSVRf
UkVQT1JUUyB9LA0KKwl7IFVTQl9WRU5ET1JfSURfU1lOQVBUSUNTLCBVU0JfREVWSUNFX0lEX1NZ
TkFQVElDU19MVFMxLCBISURfUVVJUktfTk9fSU5JVF9SRVBPUlRTIH0sDQorCXsgVVNCX1ZFTkRP
Ul9JRF9TWU5BUFRJQ1MsIFVTQl9ERVZJQ0VfSURfU1lOQVBUSUNTX0xUUzIsIEhJRF9RVUlSS19O
T19JTklUX1JFUE9SVFMgfSwNCisJeyBVU0JfVkVORE9SX0lEX1NZTkFQVElDUywgVVNCX0RFVklD
RV9JRF9TWU5BUFRJQ1NfSEQsIEhJRF9RVUlSS19OT19JTklUX1JFUE9SVFMgfSwNCisJeyBVU0Jf
VkVORE9SX0lEX1NZTkFQVElDUywgVVNCX0RFVklDRV9JRF9TWU5BUFRJQ1NfUVVBRF9IRCwgSElE
X1FVSVJLX05PX0lOSVRfUkVQT1JUUyB9LA0KKwl7IFVTQl9WRU5ET1JfSURfU1lOQVBUSUNTLCBV
U0JfREVWSUNFX0lEX1NZTkFQVElDU19UUF9WMTAzLCBISURfUVVJUktfTk9fSU5JVF9SRVBPUlRT
IH0sDQogDQogCXsgMCwgMCB9DQogfTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2h3bW9uL2VtYzE0
MDMuYyBiL2RyaXZlcnMvaHdtb24vZW1jMTQwMy5jDQppbmRleCBjZDJhNmU0Li43ZGEwOGFjIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9od21vbi9lbWMxNDAzLmMNCisrKyBiL2RyaXZlcnMvaHdtb24v
ZW1jMTQwMy5jDQpAQCAtMTU5LDcgKzE1OSw3IEBAIHN0YXRpYyBzc2l6ZV90IHN0b3JlX2h5c3Qo
c3RydWN0IGRldmljZSAqZGV2LA0KIAlpZiAocmV0dmFsIDwgMCkNCiAJCWdvdG8gZmFpbDsNCiAN
Ci0JaHlzdCA9IHZhbCAtIHJldHZhbCAqIDEwMDA7DQorCWh5c3QgPSByZXR2YWwgKiAxMDAwIC0g
dmFsOw0KIAloeXN0ID0gRElWX1JPVU5EX0NMT1NFU1QoaHlzdCwgMTAwMCk7DQogCWlmIChoeXN0
IDwgMCB8fCBoeXN0ID4gMjU1KSB7DQogCQlyZXR2YWwgPSAtRVJBTkdFOw0KQEAgLTI5MCw3ICsy
OTAsNyBAQCBzdGF0aWMgaW50IGVtYzE0MDNfZGV0ZWN0KHN0cnVjdCBpMmNfY2xpZW50ICpjbGll
bnQsDQogCX0NCiANCiAJaWQgPSBpMmNfc21idXNfcmVhZF9ieXRlX2RhdGEoY2xpZW50LCBUSEVS
TUFMX1JFVklTSU9OX1JFRyk7DQotCWlmIChpZCAhPSAweDAxKQ0KKwlpZiAoaWQgPCAweDAxIHx8
IGlkID4gMHgwNCkNCiAJCXJldHVybiAtRU5PREVWOw0KIA0KIAlyZXR1cm4gMDsNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL2kyYy9idXNzZXMvaTJjLWRlc2lnbndhcmUtY29yZS5jIGIvZHJpdmVycy9p
MmMvYnVzc2VzL2kyYy1kZXNpZ253YXJlLWNvcmUuYw0KaW5kZXggM2MyODEyZi4uYWFkYjM5OCAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvaTJjL2J1c3Nlcy9pMmMtZGVzaWdud2FyZS1jb3JlLmMNCisr
KyBiL2RyaXZlcnMvaTJjL2J1c3Nlcy9pMmMtZGVzaWdud2FyZS1jb3JlLmMNCkBAIC0zNDYsNiAr
MzQ2LDkgQEAgc3RhdGljIHZvaWQgaTJjX2R3X3hmZXJfaW5pdChzdHJ1Y3QgZHdfaTJjX2RldiAq
ZGV2KQ0KIAkJaWNfY29uICY9IH5EV19JQ19DT05fMTBCSVRBRERSX01BU1RFUjsNCiAJZHdfd3Jp
dGVsKGRldiwgaWNfY29uLCBEV19JQ19DT04pOw0KIA0KKwkvKiBlbmZvcmNlIGRpc2FibGVkIGlu
dGVycnVwdHMgKGR1ZSB0byBIVyBpc3N1ZXMpICovDQorCWkyY19kd19kaXNhYmxlX2ludChkZXYp
Ow0KKw0KIAkvKiBFbmFibGUgdGhlIGFkYXB0ZXIgKi8NCiAJZHdfd3JpdGVsKGRldiwgMSwgRFdf
SUNfRU5BQkxFKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2kyYy9idXNzZXMvaTJjLXMzYzI0
MTAuYyBiL2RyaXZlcnMvaTJjL2J1c3Nlcy9pMmMtczNjMjQxMC5jDQppbmRleCA0YzE3MTgwLi43
ZDZkMmI3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pMmMvYnVzc2VzL2kyYy1zM2MyNDEwLmMNCisr
KyBiL2RyaXZlcnMvaTJjL2J1c3Nlcy9pMmMtczNjMjQxMC5jDQpAQCAtMTA4MiwxMCArMTA4Miwx
MCBAQCBzdGF0aWMgaW50IHMzYzI0eHhfaTJjX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXYpDQog
CXN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYgPSB0b19wbGF0Zm9ybV9kZXZpY2UoZGV2KTsN
CiAJc3RydWN0IHMzYzI0eHhfaTJjICppMmMgPSBwbGF0Zm9ybV9nZXRfZHJ2ZGF0YShwZGV2KTsN
CiANCi0JaTJjLT5zdXNwZW5kZWQgPSAwOw0KIAljbGtfZW5hYmxlKGkyYy0+Y2xrKTsNCiAJczNj
MjR4eF9pMmNfaW5pdChpMmMpOw0KIAljbGtfZGlzYWJsZShpMmMtPmNsayk7DQorCWkyYy0+c3Vz
cGVuZGVkID0gMDsNCiANCiAJcmV0dXJuIDA7DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5w
dXQvbW91c2UvZWxhbnRlY2guYyBiL2RyaXZlcnMvaW5wdXQvbW91c2UvZWxhbnRlY2guYw0KaW5k
ZXggZTJhOTg2Ny4uMzQyYTA1OSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaW5wdXQvbW91c2UvZWxh
bnRlY2guYw0KKysrIGIvZHJpdmVycy9pbnB1dC9tb3VzZS9lbGFudGVjaC5jDQpAQCAtMTEsNiAr
MTEsNyBAQA0KICAqLw0KIA0KICNpbmNsdWRlIDxsaW51eC9kZWxheS5oPg0KKyNpbmNsdWRlIDxs
aW51eC9kbWkuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KICNpbmNsdWRlIDxsaW51eC9t
b2R1bGUuaD4NCiAjaW5jbHVkZSA8bGludXgvaW5wdXQuaD4NCkBAIC03ODMsNyArNzg0LDExIEBA
IHN0YXRpYyBpbnQgZWxhbnRlY2hfc2V0X2Fic29sdXRlX21vZGUoc3RydWN0IHBzbW91c2UgKnBz
bW91c2UpDQogCQlicmVhazsNCiANCiAJY2FzZSAzOg0KLQkJZXRkLT5yZWdfMTAgPSAweDBiOw0K
KwkJaWYgKGV0ZC0+c2V0X2h3X3Jlc29sdXRpb24pDQorCQkJZXRkLT5yZWdfMTAgPSAweDBiOw0K
KwkJZWxzZQ0KKwkJCWV0ZC0+cmVnXzEwID0gMHgwMzsNCisNCiAJCWlmIChlbGFudGVjaF93cml0
ZV9yZWcocHNtb3VzZSwgMHgxMCwgZXRkLT5yZWdfMTApKQ0KIAkJCXJjID0gLTE7DQogDQpAQCAt
MTIwNiw2ICsxMjExLDIyIEBAIHN0YXRpYyBpbnQgZWxhbnRlY2hfcmVjb25uZWN0KHN0cnVjdCBw
c21vdXNlICpwc21vdXNlKQ0KIH0NCiANCiAvKg0KKyAqIFNvbWUgaHdfdmVyc2lvbiAzIG1vZGVs
cyBnbyBpbnRvIGVycm9yIHN0YXRlIHdoZW4gd2UgdHJ5IHRvIHNldCBiaXQgMyBvZiByMTANCisg
Ki8NCitzdGF0aWMgY29uc3Qgc3RydWN0IGRtaV9zeXN0ZW1faWQgbm9faHdfcmVzX2RtaV90YWJs
ZVtdID0gew0KKyNpZiBkZWZpbmVkKENPTkZJR19ETUkpICYmIGRlZmluZWQoQ09ORklHX1g4NikN
CisJew0KKwkJLyogR2lnYWJ5dGUgVTI0NDIgKi8NCisJCS5tYXRjaGVzID0gew0KKwkJCURNSV9N
QVRDSChETUlfU1lTX1ZFTkRPUiwgIkdJR0FCWVRFIiksDQorCQkJRE1JX01BVENIKERNSV9QUk9E
VUNUX05BTUUsICJVMjQ0MiIpLA0KKwkJfSwNCisJfSwNCisjZW5kaWYNCisJeyB9DQorfTsNCisN
CisvKg0KICAqIGRldGVybWluZSBoYXJkd2FyZSB2ZXJzaW9uIGFuZCBzZXQgc29tZSBwcm9wZXJ0
aWVzIGFjY29yZGluZyB0byBpdC4NCiAgKi8NCiBzdGF0aWMgaW50IGVsYW50ZWNoX3NldF9wcm9w
ZXJ0aWVzKHN0cnVjdCBlbGFudGVjaF9kYXRhICpldGQpDQpAQCAtMTI1NCw2ICsxMjc1LDkgQEAg
c3RhdGljIGludCBlbGFudGVjaF9zZXRfcHJvcGVydGllcyhzdHJ1Y3QgZWxhbnRlY2hfZGF0YSAq
ZXRkKQ0KIAkJCWV0ZC0+cmVwb3J0c19wcmVzc3VyZSA9IHRydWU7DQogCX0NCiANCisJLyogRW5h
YmxlIHJlYWwgaGFyZHdhcmUgcmVzb2x1dGlvbiBvbiBod192ZXJzaW9uIDMgPyAqLw0KKwlldGQt
PnNldF9od19yZXNvbHV0aW9uID0gIWRtaV9jaGVja19zeXN0ZW0obm9faHdfcmVzX2RtaV90YWJs
ZSk7DQorDQogCXJldHVybiAwOw0KIH0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2lucHV0L21v
dXNlL2VsYW50ZWNoLmggYi9kcml2ZXJzL2lucHV0L21vdXNlL2VsYW50ZWNoLmgNCmluZGV4IDll
NWYxYWEuLjM1NjliZWQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2lucHV0L21vdXNlL2VsYW50ZWNo
LmgNCisrKyBiL2RyaXZlcnMvaW5wdXQvbW91c2UvZWxhbnRlY2guaA0KQEAgLTEyOCw2ICsxMjgs
NyBAQCBzdHJ1Y3QgZWxhbnRlY2hfZGF0YSB7DQogCWJvb2wgcGFyaXR5Y2hlY2s7DQogCWJvb2wg
anVtcHlfY3Vyc29yOw0KIAlib29sIHJlcG9ydHNfcHJlc3N1cmU7DQorCWJvb2wgc2V0X2h3X3Jl
c29sdXRpb247DQogCXVuc2lnbmVkIGNoYXIgaHdfdmVyc2lvbjsNCiAJdW5zaWduZWQgaW50IGZ3
X3ZlcnNpb247DQogCXVuc2lnbmVkIGludCBzaW5nbGVfZmluZ2VyX3JlcG9ydHM7DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9pbnB1dC9tb3VzZS9zeW5hcHRpY3MuYyBiL2RyaXZlcnMvaW5wdXQvbW91
c2Uvc3luYXB0aWNzLmMNCmluZGV4IDg4NmMxOTEuLjhhMzk4MDcgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL2lucHV0L21vdXNlL3N5bmFwdGljcy5jDQorKysgYi9kcml2ZXJzL2lucHV0L21vdXNlL3N5
bmFwdGljcy5jDQpAQCAtMTM5NCw2ICsxMzk0LDE0IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZG1p
X3N5c3RlbV9pZCBtaW5fbWF4X2RtaV90YWJsZVtdIF9faW5pdGNvbnN0ID0gew0KIAkJLmRyaXZl
cl9kYXRhID0gKGludCBbXSl7MTIzMiwgNTcxMCwgMTE1NiwgNDY5Nn0sDQogCX0sDQogCXsNCisJ
CS8qIExlbm92byBUaGlua1BhZCBFZGdlIEU0MzEgKi8NCisJCS5tYXRjaGVzID0gew0KKwkJCURN
SV9NQVRDSChETUlfU1lTX1ZFTkRPUiwgIkxFTk9WTyIpLA0KKwkJCURNSV9NQVRDSChETUlfUFJP
RFVDVF9WRVJTSU9OLCAiVGhpbmtQYWQgRWRnZSBFNDMxIiksDQorCQl9LA0KKwkJLmRyaXZlcl9k
YXRhID0gKGludCBbXSl7MTAyNCwgNTAyMiwgMjUwOCwgNDgzMn0sDQorCX0sDQorCXsNCiAJCS8q
IExlbm92byBUaGlua1BhZCBUNDMxcyAqLw0KIAkJLm1hdGNoZXMgPSB7DQogCQkJRE1JX01BVENI
KERNSV9TWVNfVkVORE9SLCAiTEVOT1ZPIiksDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5j
IGIvZHJpdmVycy9tZC9tZC5jDQppbmRleCAyZDA1NDRjLi5kYjRiNGE4IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9tZC9tZC5jDQorKysgYi9kcml2ZXJzL21kL21kLmMNCkBAIC04MTIyLDcgKzgxMjIs
OCBAQCBzdGF0aWMgaW50IG1kX25vdGlmeV9yZWJvb3Qoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICp0
aGlzLA0KIAkJaWYgKG1kZGV2X3RyeWxvY2sobWRkZXYpKSB7DQogCQkJaWYgKG1kZGV2LT5wZXJz
KQ0KIAkJCQlfX21kX3N0b3Bfd3JpdGVzKG1kZGV2KTsNCi0JCQltZGRldi0+c2FmZW1vZGUgPSAy
Ow0KKwkJCWlmIChtZGRldi0+cGVyc2lzdGVudCkNCisJCQkJbWRkZXYtPnNhZmVtb2RlID0gMjsN
CiAJCQltZGRldl91bmxvY2sobWRkZXYpOw0KIAkJfQ0KIAkJbmVlZF9kZWxheSA9IDE7DQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9tZWRpYS1kZXZpY2UuYyBiL2RyaXZlcnMvbWVkaWEvbWVk
aWEtZGV2aWNlLmMNCmluZGV4IDZlZGM5YmEuLjI5ODcwM2YgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L21lZGlhL21lZGlhLWRldmljZS5jDQorKysgYi9kcml2ZXJzL21lZGlhL21lZGlhLWRldmljZS5j
DQpAQCAtOTAsNiArOTAsNyBAQCBzdGF0aWMgbG9uZyBtZWRpYV9kZXZpY2VfZW51bV9lbnRpdGll
cyhzdHJ1Y3QgbWVkaWFfZGV2aWNlICptZGV2LA0KIAlzdHJ1Y3QgbWVkaWFfZW50aXR5ICplbnQ7
DQogCXN0cnVjdCBtZWRpYV9lbnRpdHlfZGVzYyB1X2VudDsNCiANCisJbWVtc2V0KCZ1X2VudCwg
MCwgc2l6ZW9mKHVfZW50KSk7DQogCWlmIChjb3B5X2Zyb21fdXNlcigmdV9lbnQuaWQsICZ1ZW50
LT5pZCwgc2l6ZW9mKHVfZW50LmlkKSkpDQogCQlyZXR1cm4gLUVGQVVMVDsNCiANCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL292NzY3MC5jIGIvZHJpdmVycy9tZWRpYS92aWRlby9v
djc2NzAuYw0KaW5kZXggOGFhMDU4NS4uMTcxMjVkOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWVk
aWEvdmlkZW8vb3Y3NjcwLmMNCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vb3Y3NjcwLmMNCkBA
IC05MzcsNyArOTM3LDcgQEAgc3RhdGljIGludCBvdjc2NzBfZW51bV9mcmFtZXNpemVzKHN0cnVj
dCB2NGwyX3N1YmRldiAqc2QsDQogCSAqIHdpbmRvd3MgdGhhdCBmYWxsIG91dHNpZGUgdGhhdC4N
CiAJICovDQogCWZvciAoaSA9IDA7IGkgPCBOX1dJTl9TSVpFUzsgaSsrKSB7DQotCQlzdHJ1Y3Qg
b3Y3NjcwX3dpbl9zaXplICp3aW4gPSAmb3Y3NjcwX3dpbl9zaXplc1tpbmRleF07DQorCQlzdHJ1
Y3Qgb3Y3NjcwX3dpbl9zaXplICp3aW4gPSAmb3Y3NjcwX3dpbl9zaXplc1tpXTsNCiAJCWlmIChp
bmZvLT5taW5fd2lkdGggJiYgd2luLT53aWR0aCA8IGluZm8tPm1pbl93aWR0aCkNCiAJCQljb250
aW51ZTsNCiAJCWlmIChpbmZvLT5taW5faGVpZ2h0ICYmIHdpbi0+aGVpZ2h0IDwgaW5mby0+bWlu
X2hlaWdodCkNCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3Y0bDItY29tcGF0LWlv
Y3RsMzIuYyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vdjRsMi1jb21wYXQtaW9jdGwzMi5jDQppbmRl
eCBjNjg1MzFiLi4yNjcxOTU5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby92NGwy
LWNvbXBhdC1pb2N0bDMyLmMNCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vdjRsMi1jb21wYXQt
aW9jdGwzMi5jDQpAQCAtMTc4LDYgKzE3OCw5IEBAIHN0cnVjdCB2NGwyX2NyZWF0ZV9idWZmZXJz
MzIgew0KIA0KIHN0YXRpYyBpbnQgX19nZXRfdjRsMl9mb3JtYXQzMihzdHJ1Y3QgdjRsMl9mb3Jt
YXQgKmtwLCBzdHJ1Y3QgdjRsMl9mb3JtYXQzMiBfX3VzZXIgKnVwKQ0KIHsNCisJaWYgKGdldF91
c2VyKGtwLT50eXBlLCAmdXAtPnR5cGUpKQ0KKwkJcmV0dXJuIC1FRkFVTFQ7DQorDQogCXN3aXRj
aCAoa3AtPnR5cGUpIHsNCiAJY2FzZSBWNEwyX0JVRl9UWVBFX1ZJREVPX0NBUFRVUkU6DQogCWNh
c2UgVjRMMl9CVUZfVFlQRV9WSURFT19PVVRQVVQ6DQpAQCAtMjA4LDE3ICsyMTEsMTYgQEAgc3Rh
dGljIGludCBfX2dldF92NGwyX2Zvcm1hdDMyKHN0cnVjdCB2NGwyX2Zvcm1hdCAqa3AsIHN0cnVj
dCB2NGwyX2Zvcm1hdDMyIF9fdXMNCiANCiBzdGF0aWMgaW50IGdldF92NGwyX2Zvcm1hdDMyKHN0
cnVjdCB2NGwyX2Zvcm1hdCAqa3AsIHN0cnVjdCB2NGwyX2Zvcm1hdDMyIF9fdXNlciAqdXApDQog
ew0KLQlpZiAoIWFjY2Vzc19vayhWRVJJRllfUkVBRCwgdXAsIHNpemVvZihzdHJ1Y3QgdjRsMl9m
b3JtYXQzMikpIHx8DQotCQkJZ2V0X3VzZXIoa3AtPnR5cGUsICZ1cC0+dHlwZSkpDQotCQkJcmV0
dXJuIC1FRkFVTFQ7DQorCWlmICghYWNjZXNzX29rKFZFUklGWV9SRUFELCB1cCwgc2l6ZW9mKHN0
cnVjdCB2NGwyX2Zvcm1hdDMyKSkpDQorCQlyZXR1cm4gLUVGQVVMVDsNCiAJcmV0dXJuIF9fZ2V0
X3Y0bDJfZm9ybWF0MzIoa3AsIHVwKTsNCiB9DQogDQogc3RhdGljIGludCBnZXRfdjRsMl9jcmVh
dGUzMihzdHJ1Y3QgdjRsMl9jcmVhdGVfYnVmZmVycyAqa3AsIHN0cnVjdCB2NGwyX2NyZWF0ZV9i
dWZmZXJzMzIgX191c2VyICp1cCkNCiB7DQogCWlmICghYWNjZXNzX29rKFZFUklGWV9SRUFELCB1
cCwgc2l6ZW9mKHN0cnVjdCB2NGwyX2NyZWF0ZV9idWZmZXJzMzIpKSB8fA0KLQkgICAgY29weV9m
cm9tX3VzZXIoa3AsIHVwLCBvZmZzZXRvZihzdHJ1Y3QgdjRsMl9jcmVhdGVfYnVmZmVyczMyLCBm
b3JtYXQuZm10KSkpDQotCQkJcmV0dXJuIC1FRkFVTFQ7DQorCSAgICBjb3B5X2Zyb21fdXNlcihr
cCwgdXAsIG9mZnNldG9mKHN0cnVjdCB2NGwyX2NyZWF0ZV9idWZmZXJzMzIsIGZvcm1hdCkpKQ0K
KwkJcmV0dXJuIC1FRkFVTFQ7DQogCXJldHVybiBfX2dldF92NGwyX2Zvcm1hdDMyKCZrcC0+Zm9y
bWF0LCAmdXAtPmZvcm1hdCk7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2JvbmRp
bmcvYm9uZF9tYWluLmMgYi9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfbWFpbi5jDQppbmRleCAx
YmYzNmFjLi41YWYyYThmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX21h
aW4uYw0KKysrIGIvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX21haW4uYw0KQEAgLTQ5MTQsNiAr
NDkxNCw3IEBAIHN0YXRpYyBpbnQgX19pbml0IGJvbmRpbmdfaW5pdCh2b2lkKQ0KIG91dDoNCiAJ
cmV0dXJuIHJlczsNCiBlcnI6DQorCWJvbmRfZGVzdHJveV9kZWJ1Z2ZzKCk7DQogCXJ0bmxfbGlu
a191bnJlZ2lzdGVyKCZib25kX2xpbmtfb3BzKTsNCiBlcnJfbGluazoNCiAJdW5yZWdpc3Rlcl9w
ZXJuZXRfc3Vic3lzKCZib25kX25ldF9vcHMpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nh
bi9zamExMDAwL3BlYWtfcGNpLmMgYi9kcml2ZXJzL25ldC9jYW4vc2phMTAwMC9wZWFrX3BjaS5j
DQppbmRleCAyYzdmNTAzLi41MTkyZjg2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvY2FuL3Nq
YTEwMDAvcGVha19wY2kuYw0KKysrIGIvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvcGVha19wY2ku
Yw0KQEAgLTM5LDkgKzM5LDkgQEAgTU9EVUxFX0xJQ0VOU0UoIkdQTCB2MiIpOw0KICNkZWZpbmUg
RFJWX05BTUUgICJwZWFrX3BjaSINCiANCiBzdHJ1Y3QgcGVha19wY2lfY2hhbiB7DQotCXZvaWQg
X19pb21lbSAqY2ZnX2Jhc2U7CSAgICAgLyogQ29tbW9uIGZvciBhbGwgY2hhbm5lbHMgKi8NCi0J
c3RydWN0IG5ldF9kZXZpY2UgKm5leHRfZGV2OyAvKiBDaGFpbiBvZiBuZXR3b3JrIGRldmljZXMg
Ki8NCi0JdTE2IGljcl9tYXNrOwkJICAgICAvKiBJbnRlcnJ1cHQgbWFzayBmb3IgZmFzdCBhY2sg
Ki8NCisJdm9pZCBfX2lvbWVtICpjZmdfYmFzZTsJCS8qIENvbW1vbiBmb3IgYWxsIGNoYW5uZWxz
ICovDQorCXN0cnVjdCBuZXRfZGV2aWNlICpwcmV2X2RldjsJLyogQ2hhaW4gb2YgbmV0d29yayBk
ZXZpY2VzICovDQorCXUxNiBpY3JfbWFzazsJCQkvKiBJbnRlcnJ1cHQgbWFzayBmb3IgZmFzdCBh
Y2sgKi8NCiB9Ow0KIA0KICNkZWZpbmUgUEVBS19QQ0lfQ0FOX0NMT0NLCSgxNjAwMDAwMCAvIDIp
DQpAQCAtOTgsNyArOTgsNyBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBwZWFrX3BjaV9wcm9iZShz
dHJ1Y3QgcGNpX2RldiAqcGRldiwNCiB7DQogCXN0cnVjdCBzamExMDAwX3ByaXYgKnByaXY7DQog
CXN0cnVjdCBwZWFrX3BjaV9jaGFuICpjaGFuOw0KLQlzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCAq
ZGV2MCA9IE5VTEw7DQorCXN0cnVjdCBuZXRfZGV2aWNlICpkZXYsICpwcmV2X2RldjsNCiAJdm9p
ZCBfX2lvbWVtICpjZmdfYmFzZSwgKnJlZ19iYXNlOw0KIAl1MTYgc3ViX3N5c19pZCwgaWNyOw0K
IAlpbnQgaSwgZXJyLCBjaGFubmVsczsNCkBAIC0xOTYsMTggKzE5NiwxNCBAQCBzdGF0aWMgaW50
IF9fZGV2aW5pdCBwZWFrX3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwNCiAJCX0NCiAN
CiAJCS8qIENyZWF0ZSBjaGFpbiBvZiBTSkExMDAwIGRldmljZXMgKi8NCi0JCWlmIChpID09IDAp
DQotCQkJZGV2MCA9IGRldjsNCi0JCWVsc2UNCi0JCQljaGFuLT5uZXh0X2RldiA9IGRldjsNCisJ
CWNoYW4tPnByZXZfZGV2ID0gcGNpX2dldF9kcnZkYXRhKHBkZXYpOw0KKwkJcGNpX3NldF9kcnZk
YXRhKHBkZXYsIGRldik7DQogDQogCQlkZXZfaW5mbygmcGRldi0+ZGV2LA0KIAkJCSAiJXMgYXQg
cmVnX2Jhc2U9MHglcCBjZmdfYmFzZT0weCVwIGlycT0lZFxuIiwNCiAJCQkgZGV2LT5uYW1lLCBw
cml2LT5yZWdfYmFzZSwgY2hhbi0+Y2ZnX2Jhc2UsIGRldi0+aXJxKTsNCiAJfQ0KIA0KLQlwY2lf
c2V0X2RydmRhdGEocGRldiwgZGV2MCk7DQotDQogCS8qIEVuYWJsZSBpbnRlcnJ1cHRzICovDQog
CXdyaXRldyhpY3IsIGNmZ19iYXNlICsgUElUQV9JQ1IgKyAyKTsNCiANCkBAIC0yMTcsMTIgKzIx
MywxMyBAQCBmYWlsdXJlX3JlbW92ZV9jaGFubmVsczoNCiAJLyogRGlzYWJsZSBpbnRlcnJ1cHRz
ICovDQogCXdyaXRldygweDAsIGNmZ19iYXNlICsgUElUQV9JQ1IgKyAyKTsNCiANCi0JZm9yIChk
ZXYgPSBkZXYwOyBkZXY7IGRldiA9IGNoYW4tPm5leHRfZGV2KSB7DQotCQl1bnJlZ2lzdGVyX3Nq
YTEwMDBkZXYoZGV2KTsNCi0JCWZyZWVfc2phMTAwMGRldihkZXYpOw0KKwlmb3IgKGRldiA9IHBj
aV9nZXRfZHJ2ZGF0YShwZGV2KTsgZGV2OyBkZXYgPSBwcmV2X2Rldikgew0KIAkJcHJpdiA9IG5l
dGRldl9wcml2KGRldik7DQogCQljaGFuID0gcHJpdi0+cHJpdjsNCi0JCWRldiA9IGNoYW4tPm5l
eHRfZGV2Ow0KKwkJcHJldl9kZXYgPSBjaGFuLT5wcmV2X2RldjsNCisNCisJCXVucmVnaXN0ZXJf
c2phMTAwMGRldihkZXYpOw0KKwkJZnJlZV9zamExMDAwZGV2KGRldik7DQogCX0NCiANCiAJcGNp
X2lvdW5tYXAocGRldiwgcmVnX2Jhc2UpOw0KQEAgLTI0MSw3ICsyMzgsNyBAQCBmYWlsdXJlX2Rp
c2FibGVfcGNpOg0KIA0KIHN0YXRpYyB2b2lkIF9fZGV2ZXhpdCBwZWFrX3BjaV9yZW1vdmUoc3Ry
dWN0IHBjaV9kZXYgKnBkZXYpDQogew0KLQlzdHJ1Y3QgbmV0X2RldmljZSAqZGV2ID0gcGNpX2dl
dF9kcnZkYXRhKHBkZXYpOyAvKiBGaXJzdCBkZXZpY2UgKi8NCisJc3RydWN0IG5ldF9kZXZpY2Ug
KmRldiA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsgLyogTGFzdCBkZXZpY2UgKi8NCiAJc3RydWN0
IHNqYTEwMDBfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQogCXN0cnVjdCBwZWFrX3Bj
aV9jaGFuICpjaGFuID0gcHJpdi0+cHJpdjsNCiAJdm9pZCBfX2lvbWVtICpjZmdfYmFzZSA9IGNo
YW4tPmNmZ19iYXNlOw0KQEAgLTI1MiwxMCArMjQ5LDEyIEBAIHN0YXRpYyB2b2lkIF9fZGV2ZXhp
dCBwZWFrX3BjaV9yZW1vdmUoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQogDQogCS8qIExvb3Agb3Zl
ciBhbGwgcmVnaXN0ZXJlZCBkZXZpY2VzICovDQogCXdoaWxlICgxKSB7DQorCQlzdHJ1Y3QgbmV0
X2RldmljZSAqcHJldl9kZXYgPSBjaGFuLT5wcmV2X2RldjsNCisNCiAJCWRldl9pbmZvKCZwZGV2
LT5kZXYsICJyZW1vdmluZyBkZXZpY2UgJXNcbiIsIGRldi0+bmFtZSk7DQogCQl1bnJlZ2lzdGVy
X3NqYTEwMDBkZXYoZGV2KTsNCiAJCWZyZWVfc2phMTAwMGRldihkZXYpOw0KLQkJZGV2ID0gY2hh
bi0+bmV4dF9kZXY7DQorCQlkZXYgPSBwcmV2X2RldjsNCiAJCWlmICghZGV2KQ0KIAkJCWJyZWFr
Ow0KIAkJcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvYnJvYWRjb20vdGczLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS90
ZzMuYw0KaW5kZXggYzc3YzQ2Mi4uMjYxNTQzMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2Jyb2FkY29tL3RnMy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNv
bS90ZzMuYw0KQEAgLTEwNjU2LDcgKzEwNjU2LDkgQEAgc3RhdGljIGludCB0ZzNfc2V0X3Jpbmdw
YXJhbShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgZXRodG9vbF9yaW5ncGFyYW0gKmUN
CiAJaWYgKHRnM19mbGFnKHRwLCBNQVhfUlhQRU5EXzY0KSAmJg0KIAkgICAgdHAtPnJ4X3BlbmRp
bmcgPiA2MykNCiAJCXRwLT5yeF9wZW5kaW5nID0gNjM7DQotCXRwLT5yeF9qdW1ib19wZW5kaW5n
ID0gZXJpbmctPnJ4X2p1bWJvX3BlbmRpbmc7DQorDQorCWlmICh0ZzNfZmxhZyh0cCwgSlVNQk9f
UklOR19FTkFCTEUpKQ0KKwkJdHAtPnJ4X2p1bWJvX3BlbmRpbmcgPSBlcmluZy0+cnhfanVtYm9f
cGVuZGluZzsNCiANCiAJZm9yIChpID0gMDsgaSA8IHRwLT5pcnFfbWF4OyBpKyspDQogCQl0cC0+
bmFwaVtpXS50eF9wZW5kaW5nID0gZXJpbmctPnR4X3BlbmRpbmc7DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvbWFjdmxhbi5jIGIvZHJpdmVycy9uZXQvbWFjdmxhbi5jDQppbmRleCAzMDFiMzll
Li5iNzRjZGY2IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvbWFjdmxhbi5jDQorKysgYi9kcml2
ZXJzL25ldC9tYWN2bGFuLmMNCkBAIC0yMzYsMTEgKzIzNiw5IEBAIHN0YXRpYyBpbnQgbWFjdmxh
bl9xdWV1ZV94bWl0KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYp
DQogCWNvbnN0IHN0cnVjdCBtYWN2bGFuX2RldiAqdmxhbiA9IG5ldGRldl9wcml2KGRldik7DQog
CWNvbnN0IHN0cnVjdCBtYWN2bGFuX3BvcnQgKnBvcnQgPSB2bGFuLT5wb3J0Ow0KIAljb25zdCBz
dHJ1Y3QgbWFjdmxhbl9kZXYgKmRlc3Q7DQotCV9fdTggaXBfc3VtbWVkID0gc2tiLT5pcF9zdW1t
ZWQ7DQogDQogCWlmICh2bGFuLT5tb2RlID09IE1BQ1ZMQU5fTU9ERV9CUklER0UpIHsNCiAJCWNv
bnN0IHN0cnVjdCBldGhoZHIgKmV0aCA9ICh2b2lkICopc2tiLT5kYXRhOw0KLQkJc2tiLT5pcF9z
dW1tZWQgPSBDSEVDS1NVTV9VTk5FQ0VTU0FSWTsNCiANCiAJCS8qIHNlbmQgdG8gb3RoZXIgYnJp
ZGdlIHBvcnRzIGRpcmVjdGx5ICovDQogCQlpZiAoaXNfbXVsdGljYXN0X2V0aGVyX2FkZHIoZXRo
LT5oX2Rlc3QpKSB7DQpAQCAtMjU4LDcgKzI1Niw2IEBAIHN0YXRpYyBpbnQgbWFjdmxhbl9xdWV1
ZV94bWl0KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQogCX0N
CiANCiB4bWl0X3dvcmxkOg0KLQlza2ItPmlwX3N1bW1lZCA9IGlwX3N1bW1lZDsNCiAJc2tiLT5k
ZXYgPSB2bGFuLT5sb3dlcmRldjsNCiAJcmV0dXJuIGRldl9xdWV1ZV94bWl0KHNrYik7DQogfQ0K
QEAgLTM5NCw4ICszOTEsMTAgQEAgc3RhdGljIHZvaWQgbWFjdmxhbl9jaGFuZ2VfcnhfZmxhZ3Mo
c3RydWN0IG5ldF9kZXZpY2UgKmRldiwgaW50IGNoYW5nZSkNCiAJc3RydWN0IG1hY3ZsYW5fZGV2
ICp2bGFuID0gbmV0ZGV2X3ByaXYoZGV2KTsNCiAJc3RydWN0IG5ldF9kZXZpY2UgKmxvd2VyZGV2
ID0gdmxhbi0+bG93ZXJkZXY7DQogDQotCWlmIChjaGFuZ2UgJiBJRkZfQUxMTVVMVEkpDQotCQlk
ZXZfc2V0X2FsbG11bHRpKGxvd2VyZGV2LCBkZXYtPmZsYWdzICYgSUZGX0FMTE1VTFRJID8gMSA6
IC0xKTsNCisJaWYgKGRldi0+ZmxhZ3MgJiBJRkZfVVApIHsNCisJCWlmIChjaGFuZ2UgJiBJRkZf
QUxMTVVMVEkpDQorCQkJZGV2X3NldF9hbGxtdWx0aShsb3dlcmRldiwgZGV2LT5mbGFncyAmIElG
Rl9BTExNVUxUSSA/IDEgOiAtMSk7DQorCX0NCiB9DQogDQogc3RhdGljIHZvaWQgbWFjdmxhbl9z
ZXRfbXVsdGljYXN0X2xpc3Qoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aW1heC9pMjQwMG0vdXNiLXJ4LmMgYi9kcml2ZXJzL25ldC93aW1heC9pMjQw
MG0vdXNiLXJ4LmMNCmluZGV4IGUzMjU3NjguLmI3OGVlNjcgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L25ldC93aW1heC9pMjQwMG0vdXNiLXJ4LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpbWF4L2kyNDAw
bS91c2ItcnguYw0KQEAgLTI3Nyw3ICsyNzcsNyBAQCByZXRyeToNCiAJCWRfcHJpbnRmKDEsIGRl
diwgIlJYOiBzaXplIGNoYW5nZWQgdG8gJWQsIHJlY2VpdmVkICVkLCAiDQogCQkJICJjb3BpZWQg
JWQsIGNhcGFjaXR5ICVsZFxuIiwNCiAJCQkgcnhfc2l6ZSwgcmVhZF9zaXplLCByeF9za2ItPmxl
biwNCi0JCQkgKGxvbmcpIChza2JfZW5kX3BvaW50ZXIobmV3X3NrYikgLSBuZXdfc2tiLT5oZWFk
KSk7DQorCQkJIChsb25nKSBza2JfZW5kX29mZnNldChuZXdfc2tiKSk7DQogCQlnb3RvIHJldHJ5
Ow0KIAl9DQogCQkvKiBJbiBtb3N0IGNhc2VzLCBpdCBoYXBwZW5zIGR1ZSB0byB0aGUgaGFyZHdh
cmUgc2NoZWR1bGluZyBhDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnQyeDAw
L3J0MngwMG1hYy5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnQyeDAwL3J0MngwMG1hYy5jDQpp
bmRleCA1YzM4MjgxLi4xZDRjNTc5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cnQyeDAwL3J0MngwMG1hYy5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydDJ4MDAvcnQy
eDAwbWFjLmMNCkBAIC02NTEsMjAgKzY1MSwxOCBAQCB2b2lkIHJ0MngwMG1hY19ic3NfaW5mb19j
aGFuZ2VkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KIAkJCQkgICAgICBic3NfY29uZi0+YnNz
aWQpOw0KIA0KIAkvKg0KLQkgKiBVcGRhdGUgdGhlIGJlYWNvbi4gVGhpcyBpcyBvbmx5IHJlcXVp
cmVkIG9uIFVTQiBkZXZpY2VzLiBQQ0kNCi0JICogZGV2aWNlcyBmZXRjaCBiZWFjb25zIHBlcmlv
ZGljYWxseS4NCi0JICovDQotCWlmIChjaGFuZ2VzICYgQlNTX0NIQU5HRURfQkVBQ09OICYmIHJ0
MngwMF9pc191c2IocnQyeDAwZGV2KSkNCi0JCXJ0MngwMHF1ZXVlX3VwZGF0ZV9iZWFjb24ocnQy
eDAwZGV2LCB2aWYpOw0KLQ0KLQkvKg0KIAkgKiBTdGFydC9zdG9wIGJlYWNvbmluZy4NCiAJICov
DQogCWlmIChjaGFuZ2VzICYgQlNTX0NIQU5HRURfQkVBQ09OX0VOQUJMRUQpIHsNCiAJCWlmICgh
YnNzX2NvbmYtPmVuYWJsZV9iZWFjb24gJiYgaW50Zi0+ZW5hYmxlX2JlYWNvbikgew0KLQkJCXJ0
MngwMHF1ZXVlX2NsZWFyX2JlYWNvbihydDJ4MDBkZXYsIHZpZik7DQogCQkJcnQyeDAwZGV2LT5p
bnRmX2JlYWNvbmluZy0tOw0KIAkJCWludGYtPmVuYWJsZV9iZWFjb24gPSBmYWxzZTsNCisJCQkv
Kg0KKwkJCSAqIENsZWFyIGJlYWNvbiBpbiB0aGUgSC9XIGZvciB0aGlzIHZpZi4gVGhpcyBpcyBu
ZWVkZWQNCisJCQkgKiB0byBkaXNhYmxlIGJlYWNvbmluZyBvbiB0aGlzIHBhcnRpY3VsYXIgaW50
ZXJmYWNlDQorCQkJICogYW5kIGtlZXAgaXQgcnVubmluZyBvbiBvdGhlciBpbnRlcmZhY2VzLg0K
KwkJCSAqLw0KKwkJCXJ0MngwMHF1ZXVlX2NsZWFyX2JlYWNvbihydDJ4MDBkZXYsIHZpZik7DQog
DQogCQkJaWYgKHJ0MngwMGRldi0+aW50Zl9iZWFjb25pbmcgPT0gMCkgew0KIAkJCQkvKg0KQEAg
LTY3NSwxMSArNjczLDE1IEBAIHZvaWQgcnQyeDAwbWFjX2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0
IGllZWU4MDIxMV9odyAqaHcsDQogCQkJCXJ0MngwMHF1ZXVlX3N0b3BfcXVldWUocnQyeDAwZGV2
LT5iY24pOw0KIAkJCQltdXRleF91bmxvY2soJmludGYtPmJlYWNvbl9za2JfbXV0ZXgpOw0KIAkJ
CX0NCi0NCi0NCiAJCX0gZWxzZSBpZiAoYnNzX2NvbmYtPmVuYWJsZV9iZWFjb24gJiYgIWludGYt
PmVuYWJsZV9iZWFjb24pIHsNCiAJCQlydDJ4MDBkZXYtPmludGZfYmVhY29uaW5nKys7DQogCQkJ
aW50Zi0+ZW5hYmxlX2JlYWNvbiA9IHRydWU7DQorCQkJLyoNCisJCQkgKiBVcGxvYWQgYmVhY29u
IHRvIHRoZSBIL1cuIFRoaXMgaXMgb25seSByZXF1aXJlZCBvbg0KKwkJCSAqIFVTQiBkZXZpY2Vz
LiBQQ0kgZGV2aWNlcyBmZXRjaCBiZWFjb25zIHBlcmlvZGljYWxseS4NCisJCQkgKi8NCisJCQlp
ZiAocnQyeDAwX2lzX3VzYihydDJ4MDBkZXYpKQ0KKwkJCQlydDJ4MDBxdWV1ZV91cGRhdGVfYmVh
Y29uKHJ0MngwMGRldiwgdmlmKTsNCiANCiAJCQlpZiAocnQyeDAwZGV2LT5pbnRmX2JlYWNvbmlu
ZyA9PSAxKSB7DQogCQkJCS8qDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRs
d2lmaS9ydGw4MTkyY3UvaHcuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5
MmN1L2h3LmMNCmluZGV4IGQzOTIwZGEuLjc5ZmM0YjcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9ydGx3aWZpL3J0bDgxOTJjdS9ody5jDQorKysgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9ydGx3aWZpL3J0bDgxOTJjdS9ody5jDQpAQCAtMTE1OCwxMiArMTE1OCwyMyBAQCBpbnQg
cnRsOTJjdV9od19pbml0KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQ0KIAlzdHJ1Y3QgcnRsX3Bz
X2N0bCAqcHBzYyA9IHJ0bF9wc2MocnRsX3ByaXYoaHcpKTsNCiAJaW50IGVyciA9IDA7DQogCXN0
YXRpYyBib29sIGlxa19pbml0aWFsaXplZDsNCisJdW5zaWduZWQgbG9uZyBmbGFnczsNCisNCisJ
LyogQXMgdGhpcyBmdW5jdGlvbiBjYW4gdGFrZSBhIHZlcnkgbG9uZyB0aW1lICh1cCB0byAzNTAg
bXMpDQorCSAqIGFuZCBjYW4gYmUgY2FsbGVkIHdpdGggaXJxcyBkaXNhYmxlZCwgcmVlbmFibGUg
dGhlIGlycXMNCisJICogdG8gbGV0IHRoZSBvdGhlciBkZXZpY2VzIGNvbnRpbnVlIGJlaW5nIHNl
cnZpY2VkLg0KKwkgKg0KKwkgKiBJdCBpcyBzYWZlIGRvaW5nIHNvIHNpbmNlIG91ciBvd24gaW50
ZXJydXB0cyB3aWxsIG9ubHkgYmUgZW5hYmxlZA0KKwkgKiBpbiBhIHN1YnNlcXVlbnQgc3RlcC4N
CisJICovDQorCWxvY2FsX3NhdmVfZmxhZ3MoZmxhZ3MpOw0KKwlsb2NhbF9pcnFfZW5hYmxlKCk7
DQogDQogCXJ0bGhhbC0+aHdfdHlwZSA9IEhBUkRXQVJFX1RZUEVfUlRMODE5MkNVOw0KIAllcnIg
PSBfcnRsOTJjdV9pbml0X21hYyhodyk7DQogCWlmIChlcnIpIHsNCiAJCVJUX1RSQUNFKHJ0bHBy
aXYsIENPTVBfRVJSLCBEQkdfRU1FUkcsICgiaW5pdCBtYWMgZmFpbGVkIVxuIikpOw0KLQkJcmV0
dXJuIGVycjsNCisJCWdvdG8gZXhpdDsNCiAJfQ0KIAllcnIgPSBydGw5MmNfZG93bmxvYWRfZnco
aHcpOw0KIAlpZiAoZXJyKSB7DQpAQCAtMTE3MSw3ICsxMTgyLDcgQEAgaW50IHJ0bDkyY3VfaHdf
aW5pdChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykNCiAJCQkgKCJGYWlsZWQgdG8gZG93bmxvYWQg
RlcuIEluaXQgSFcgd2l0aG91dCBGVyBub3cuLlxuIikpOw0KIAkJZXJyID0gMTsNCiAJCXJ0bGhh
bC0+ZndfcmVhZHkgPSBmYWxzZTsNCi0JCXJldHVybiBlcnI7DQorCQlnb3RvIGV4aXQ7DQogCX0g
ZWxzZSB7DQogCQlydGxoYWwtPmZ3X3JlYWR5ID0gdHJ1ZTsNCiAJfQ0KQEAgLTEyMTIsNiArMTIy
Myw4IEBAIGludCBydGw5MmN1X2h3X2luaXQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpDQogCV91
cGRhdGVfbWFjX3NldHRpbmcoaHcpOw0KIAlydGw5MmNfZG1faW5pdChodyk7DQogCV9kdW1wX3Jl
Z2lzdGVycyhodyk7DQorZXhpdDoNCisJbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOw0KIAlyZXR1
cm4gZXJyOw0KIH0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3BjaS9ob3RwbHVnL3NocGNocF9j
dHJsLmMgYi9kcml2ZXJzL3BjaS9ob3RwbHVnL3NocGNocF9jdHJsLmMNCmluZGV4IDNmZmMxYjIu
LmI4ODg2NzUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3BjaS9ob3RwbHVnL3NocGNocF9jdHJsLmMN
CisrKyBiL2RyaXZlcnMvcGNpL2hvdHBsdWcvc2hwY2hwX2N0cmwuYw0KQEAgLTI4NSw4ICsyODUs
OCBAQCBzdGF0aWMgaW50IGJvYXJkX2FkZGVkKHN0cnVjdCBzbG90ICpwX3Nsb3QpDQogCQlyZXR1
cm4gV1JPTkdfQlVTX0ZSRVFVRU5DWTsNCiAJfQ0KIA0KLQlic3AgPSBjdHJsLT5wY2lfZGV2LT5i
dXMtPmN1cl9idXNfc3BlZWQ7DQotCW1zcCA9IGN0cmwtPnBjaV9kZXYtPmJ1cy0+bWF4X2J1c19z
cGVlZDsNCisJYnNwID0gY3RybC0+cGNpX2Rldi0+c3Vib3JkaW5hdGUtPmN1cl9idXNfc3BlZWQ7
DQorCW1zcCA9IGN0cmwtPnBjaV9kZXYtPnN1Ym9yZGluYXRlLT5tYXhfYnVzX3NwZWVkOw0KIA0K
IAkvKiBDaGVjayBpZiB0aGVyZSBhcmUgb3RoZXIgc2xvdHMgb3IgZGV2aWNlcyBvbiB0aGUgc2Ft
ZSBidXMgKi8NCiAJaWYgKCFsaXN0X2VtcHR5KCZjdHJsLT5wY2lfZGV2LT5zdWJvcmRpbmF0ZS0+
ZGV2aWNlcykpDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wbGF0Zm9ybS94ODYvdGhpbmtwYWRfYWNw
aS5jIGIvZHJpdmVycy9wbGF0Zm9ybS94ODYvdGhpbmtwYWRfYWNwaS5jDQppbmRleCA4ZTZjNGZh
Li4yYThkNmFhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9wbGF0Zm9ybS94ODYvdGhpbmtwYWRfYWNw
aS5jDQorKysgYi9kcml2ZXJzL3BsYXRmb3JtL3g4Ni90aGlua3BhZF9hY3BpLmMNCkBAIC0zNDA1
LDcgKzM0MDUsNyBAQCBzdGF0aWMgaW50IF9faW5pdCBob3RrZXlfaW5pdChzdHJ1Y3QgaWJtX2lu
aXRfc3RydWN0ICppaWJtKQ0KIAkvKiBEbyBub3QgaXNzdWUgZHVwbGljYXRlIGJyaWdodG5lc3Mg
Y2hhbmdlIGV2ZW50cyB0bw0KIAkgKiB1c2Vyc3BhY2UuIHRwYWNwaV9kZXRlY3RfYnJpZ2h0bmVz
c19jYXBhYmlsaXRpZXMoKSBtdXN0IGhhdmUNCiAJICogYmVlbiBjYWxsZWQgYmVmb3JlIHRoaXMg
cG9pbnQgICovDQotCWlmICh0cF9mZWF0dXJlcy5icmlnaHRfYWNwaW1vZGUgJiYgYWNwaV92aWRl
b19iYWNrbGlnaHRfc3VwcG9ydCgpKSB7DQorCWlmIChhY3BpX3ZpZGVvX2JhY2tsaWdodF9zdXBw
b3J0KCkpIHsNCiAJCXByX2luZm8oIlRoaXMgVGhpbmtQYWQgaGFzIHN0YW5kYXJkIEFDUEkgYmFj
a2xpZ2h0ICINCiAJCQkiYnJpZ2h0bmVzcyBjb250cm9sLCBzdXBwb3J0ZWQgYnkgdGhlIEFDUEkg
Ig0KIAkJCSJ2aWRlbyBkcml2ZXJcbiIpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9tcHQy
c2FzL21wdDJzYXNfc2NzaWguYyBiL2RyaXZlcnMvc2NzaS9tcHQyc2FzL21wdDJzYXNfc2NzaWgu
Yw0KaW5kZXggOTg3YzZkNi4uMDE3ODBhOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9tcHQy
c2FzL21wdDJzYXNfc2NzaWguYw0KKysrIGIvZHJpdmVycy9zY3NpL21wdDJzYXMvbXB0MnNhc19z
Y3NpaC5jDQpAQCAtODE2Niw3ICs4MTY2LDYgQEAgX3Njc2loX3N1c3BlbmQoc3RydWN0IHBjaV9k
ZXYgKnBkZXYsIHBtX21lc3NhZ2VfdCBzdGF0ZSkNCiANCiAJbXB0MnNhc19iYXNlX2ZyZWVfcmVz
b3VyY2VzKGlvYyk7DQogCXBjaV9zYXZlX3N0YXRlKHBkZXYpOw0KLQlwY2lfZGlzYWJsZV9kZXZp
Y2UocGRldik7DQogCXBjaV9zZXRfcG93ZXJfc3RhdGUocGRldiwgZGV2aWNlX3N0YXRlKTsNCiAJ
cmV0dXJuIDA7DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9vY3Rlb24vZXRoZXJu
ZXQtdHguYyBiL2RyaXZlcnMvc3RhZ2luZy9vY3Rlb24vZXRoZXJuZXQtdHguYw0KaW5kZXggMjU0
MmMzNy4uYzVkYTBkMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy9vY3Rlb24vZXRoZXJu
ZXQtdHguYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL29jdGVvbi9ldGhlcm5ldC10eC5jDQpAQCAt
MzQ0LDcgKzM0NCw3IEBAIGludCBjdm1fb2N0X3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3Ry
dWN0IG5ldF9kZXZpY2UgKmRldikNCiAJfQ0KIAlpZiAodW5saWtlbHkNCiAJICAgIChza2ItPnRy
dWVzaXplICE9DQotCSAgICAgc2l6ZW9mKCpza2IpICsgc2tiX2VuZF9wb2ludGVyKHNrYikgLSBz
a2ItPmhlYWQpKSB7DQorCSAgICAgc2l6ZW9mKCpza2IpICsgc2tiX2VuZF9vZmZzZXQoc2tiKSkp
IHsNCiAJCS8qDQogCQkgICBwcmludGsoIlRYIGJ1ZmZlciB0cnVlc2l6ZSBoYXMgYmVlbiBjaGFu
Z2VkXG4iKTsNCiAJCSAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdHR5L2h2Yy9odmNfY29uc29s
ZS5jIGIvZHJpdmVycy90dHkvaHZjL2h2Y19jb25zb2xlLmMNCmluZGV4IDdiOTdlN2UuLjQ0MzU0
N2IgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3R0eS9odmMvaHZjX2NvbnNvbGUuYw0KKysrIGIvZHJp
dmVycy90dHkvaHZjL2h2Y19jb25zb2xlLmMNCkBAIC0xOTAsNyArMTkwLDcgQEAgc3RhdGljIHN0
cnVjdCB0dHlfZHJpdmVyICpodmNfY29uc29sZV9kZXZpY2Uoc3RydWN0IGNvbnNvbGUgKmMsIGlu
dCAqaW5kZXgpDQogCXJldHVybiBodmNfZHJpdmVyOw0KIH0NCiANCi1zdGF0aWMgaW50IF9faW5p
dCBodmNfY29uc29sZV9zZXR1cChzdHJ1Y3QgY29uc29sZSAqY28sIGNoYXIgKm9wdGlvbnMpDQor
c3RhdGljIGludCBodmNfY29uc29sZV9zZXR1cChzdHJ1Y3QgY29uc29sZSAqY28sIGNoYXIgKm9w
dGlvbnMpDQogewkNCiAJaWYgKGNvLT5pbmRleCA8IDAgfHwgY28tPmluZGV4ID49IE1BWF9OUl9I
VkNfQ09OU09MRVMpDQogCQlyZXR1cm4gLUVOT0RFVjsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Vz
Yi9zdG9yYWdlL3NodXR0bGVfdXNiYXQuYyBiL2RyaXZlcnMvdXNiL3N0b3JhZ2Uvc2h1dHRsZV91
c2JhdC5jDQppbmRleCAwYjAwMDkxLi5mZjhhZWVlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Iv
c3RvcmFnZS9zaHV0dGxlX3VzYmF0LmMNCisrKyBiL2RyaXZlcnMvdXNiL3N0b3JhZ2Uvc2h1dHRs
ZV91c2JhdC5jDQpAQCAtMTg0Niw3ICsxODQ2LDcgQEAgc3RhdGljIGludCB1c2JhdF9wcm9iZShz
dHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZiwNCiAJdXMtPnRyYW5zcG9ydF9uYW1lID0gIlNodXR0
bGUgVVNCQVQiOw0KIAl1cy0+dHJhbnNwb3J0ID0gdXNiYXRfZmxhc2hfdHJhbnNwb3J0Ow0KIAl1
cy0+dHJhbnNwb3J0X3Jlc2V0ID0gdXNiX3N0b3JfQ0JfcmVzZXQ7DQotCXVzLT5tYXhfbHVuID0g
MTsNCisJdXMtPm1heF9sdW4gPSAwOw0KIA0KIAlyZXN1bHQgPSB1c2Jfc3Rvcl9wcm9iZTIodXMp
Ow0KIAlyZXR1cm4gcmVzdWx0Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdW51
c3VhbF9kZXZzLmggYi9kcml2ZXJzL3VzYi9zdG9yYWdlL3VudXN1YWxfZGV2cy5oDQppbmRleCAw
ODcxMWJjLi40OWQyMjJkIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc3RvcmFnZS91bnVzdWFs
X2RldnMuaA0KKysrIGIvZHJpdmVycy91c2Ivc3RvcmFnZS91bnVzdWFsX2RldnMuaA0KQEAgLTIy
Niw2ICsyMjYsMjAgQEAgVU5VU1VBTF9ERVYoICAweDA0MjEsIDB4MDQ5NSwgMHgwMzcwLCAweDAz
NzAsDQogCQlVU0JfU0NfREVWSUNFLCBVU0JfUFJfREVWSUNFLCBOVUxMLA0KIAkJVVNfRkxfTUFY
X1NFQ1RPUlNfNjQgKSwNCiANCisvKiBSZXBvcnRlZCBieSBEYW5pZWxlIEZvcnNpIDxkZm9yc2lA
Z21haWwuY29tPiAqLw0KK1VOVVNVQUxfREVWKCAgMHgwNDIxLCAweDA0YjksIDB4MDM1MCwgMHgw
MzUwLA0KKwkJIk5va2lhIiwNCisJCSI1MzAwIiwNCisJCVVTQl9TQ19ERVZJQ0UsIFVTQl9QUl9E
RVZJQ0UsIE5VTEwsDQorCQlVU19GTF9NQVhfU0VDVE9SU182NCApLA0KKw0KKy8qIFBhdGNoIHN1
Ym1pdHRlZCBieSBWaWN0b3IgQS4gU2FudG9zIDx2aWN0b3JhdXIuc2FudG9zQGdtYWlsLmNvbT4g
Ki8NCitVTlVTVUFMX0RFViggIDB4MDQyMSwgMHgwNWFmLCAweDA3NDIsIDB4MDc0MiwNCisJCSJO
b2tpYSIsDQorCQkiMzA1IiwNCisJCVVTQl9TQ19ERVZJQ0UsIFVTQl9QUl9ERVZJQ0UsIE5VTEws
DQorCQlVU19GTF9NQVhfU0VDVE9SU182NCksDQorDQogLyogUGF0Y2ggc3VibWl0dGVkIGJ5IE1p
a2hhaWwgWm9sb3RhcnlvdiA8bGVib25AbGVib24ub3JnLnVhPiAqLw0KIFVOVVNVQUxfREVWKCAg
MHgwNDIxLCAweDA2YWEsIDB4MTExMCwgMHgxMTEwLA0KIAkJIk5va2lhIiwNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3ZpZGVvL3RnYWZiLmMgYi9kcml2ZXJzL3ZpZGVvL3RnYWZiLmMNCmluZGV4IGFj
MmNmNmQuLjNiMTViY2EgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3ZpZGVvL3RnYWZiLmMNCisrKyBi
L2RyaXZlcnMvdmlkZW8vdGdhZmIuYw0KQEAgLTE5Miw2ICsxOTIsOCBAQCB0Z2FmYl9jaGVja192
YXIoc3RydWN0IGZiX3Zhcl9zY3JlZW5pbmZvICp2YXIsIHN0cnVjdCBmYl9pbmZvICppbmZvKQ0K
IA0KIAlpZiAodmFyLT54cmVzX3ZpcnR1YWwgIT0gdmFyLT54cmVzIHx8IHZhci0+eXJlc192aXJ0
dWFsICE9IHZhci0+eXJlcykNCiAJCXJldHVybiAtRUlOVkFMOw0KKwlpZiAodmFyLT54cmVzICog
dmFyLT55cmVzICogKHZhci0+Yml0c19wZXJfcGl4ZWwgPj4gMykgPiBpbmZvLT5maXguc21lbV9s
ZW4pDQorCQlyZXR1cm4gLUVJTlZBTDsNCiAJaWYgKHZhci0+bm9uc3RkKQ0KIAkJcmV0dXJuIC1F
SU5WQUw7DQogCWlmICgxMDAwMDAwMDAwIC8gdmFyLT5waXhjbG9jayA+IFRHQV9QTExfTUFYX0ZS
RVEpDQpAQCAtMjcyLDYgKzI3NCw3IEBAIHRnYWZiX3NldF9wYXIoc3RydWN0IGZiX2luZm8gKmlu
Zm8pDQogCXBhci0+eXJlcyA9IGluZm8tPnZhci55cmVzOw0KIAlwYXItPnBsbF9mcmVxID0gcGxs
X2ZyZXEgPSAxMDAwMDAwMDAwIC8gaW5mby0+dmFyLnBpeGNsb2NrOw0KIAlwYXItPmJpdHNfcGVy
X3BpeGVsID0gaW5mby0+dmFyLmJpdHNfcGVyX3BpeGVsOw0KKwlpbmZvLT5maXgubGluZV9sZW5n
dGggPSBwYXItPnhyZXMgKiAocGFyLT5iaXRzX3Blcl9waXhlbCA+PiAzKTsNCiANCiAJdGdhX3R5
cGUgPSBwYXItPnRnYV90eXBlOw0KIA0KQEAgLTEzMTgsNiArMTMyMSw3IEBAIHRnYWZiX2luaXRf
Zml4KHN0cnVjdCBmYl9pbmZvICppbmZvKQ0KIAlpbnQgdGdhX2J1c190YyA9IFRHQV9CVVNfVEMo
cGFyLT5kZXYpOw0KIAl1OCB0Z2FfdHlwZSA9IHBhci0+dGdhX3R5cGU7DQogCWNvbnN0IGNoYXIg
KnRnYV90eXBlX25hbWUgPSBOVUxMOw0KKwl1bnNpZ25lZCBtZW1vcnlfc2l6ZTsNCiANCiAJc3dp
dGNoICh0Z2FfdHlwZSkgew0KIAljYXNlIFRHQV9UWVBFXzhQTEFORToNCkBAIC0xMzI1LDIxICsx
MzI5LDI1IEBAIHRnYWZiX2luaXRfZml4KHN0cnVjdCBmYl9pbmZvICppbmZvKQ0KIAkJCXRnYV90
eXBlX25hbWUgPSAiRGlnaXRhbCBaTFhwLUUxIjsNCiAJCWlmICh0Z2FfYnVzX3RjKQ0KIAkJCXRn
YV90eXBlX25hbWUgPSAiRGlnaXRhbCBaTFgtRTEiOw0KKwkJbWVtb3J5X3NpemUgPSAyMDk3MTUy
Ow0KIAkJYnJlYWs7DQogCWNhc2UgVEdBX1RZUEVfMjRQTEFORToNCiAJCWlmICh0Z2FfYnVzX3Bj
aSkNCiAJCQl0Z2FfdHlwZV9uYW1lID0gIkRpZ2l0YWwgWkxYcC1FMiI7DQogCQlpZiAodGdhX2J1
c190YykNCiAJCQl0Z2FfdHlwZV9uYW1lID0gIkRpZ2l0YWwgWkxYLUUyIjsNCisJCW1lbW9yeV9z
aXplID0gODM4ODYwODsNCiAJCWJyZWFrOw0KIAljYXNlIFRHQV9UWVBFXzI0UExVU1o6DQogCQlp
ZiAodGdhX2J1c19wY2kpDQogCQkJdGdhX3R5cGVfbmFtZSA9ICJEaWdpdGFsIFpMWHAtRTMiOw0K
IAkJaWYgKHRnYV9idXNfdGMpDQogCQkJdGdhX3R5cGVfbmFtZSA9ICJEaWdpdGFsIFpMWC1FMyI7
DQorCQltZW1vcnlfc2l6ZSA9IDE2Nzc3MjE2Ow0KIAkJYnJlYWs7DQogCWRlZmF1bHQ6DQogCQl0
Z2FfdHlwZV9uYW1lID0gIlVua25vd24iOw0KKwkJbWVtb3J5X3NpemUgPSAxNjc3NzIxNjsNCiAJ
CWJyZWFrOw0KIAl9DQogDQpAQCAtMTM1MSw5ICsxMzU5LDggQEAgdGdhZmJfaW5pdF9maXgoc3Ry
dWN0IGZiX2luZm8gKmluZm8pDQogCQkJICAgID8gRkJfVklTVUFMX1BTRVVET0NPTE9SDQogCQkJ
ICAgIDogRkJfVklTVUFMX0RJUkVDVENPTE9SKTsNCiANCi0JaW5mby0+Zml4LmxpbmVfbGVuZ3Ro
ID0gcGFyLT54cmVzICogKHBhci0+Yml0c19wZXJfcGl4ZWwgPj4gMyk7DQogCWluZm8tPmZpeC5z
bWVtX3N0YXJ0ID0gKHNpemVfdCkgcGFyLT50Z2FfZmJfYmFzZTsNCi0JaW5mby0+Zml4LnNtZW1f
bGVuID0gaW5mby0+Zml4LmxpbmVfbGVuZ3RoICogcGFyLT55cmVzOw0KKwlpbmZvLT5maXguc21l
bV9sZW4gPSBtZW1vcnlfc2l6ZTsNCiAJaW5mby0+Zml4Lm1taW9fc3RhcnQgPSAoc2l6ZV90KSBw
YXItPnRnYV9yZWdzX2Jhc2U7DQogCWluZm8tPmZpeC5tbWlvX2xlbiA9IDUxMjsNCiANCkBAIC0x
NDc4LDYgKzE0ODUsOSBAQCB0Z2FmYl9yZWdpc3RlcihzdHJ1Y3QgZGV2aWNlICpkZXYpDQogCQlt
b2RlZGJfdGdhID0gJm1vZGVkYl90YzsNCiAJCW1vZGVkYnNpemVfdGdhID0gMTsNCiAJfQ0KKw0K
Kwl0Z2FmYl9pbml0X2ZpeChpbmZvKTsNCisNCiAJcmV0ID0gZmJfZmluZF9tb2RlKCZpbmZvLT52
YXIsIGluZm8sDQogCQkJICAgbW9kZV9vcHRpb24gPyBtb2RlX29wdGlvbiA6IG1vZGVfb3B0aW9u
X3RnYSwNCiAJCQkgICBtb2RlZGJfdGdhLCBtb2RlZGJzaXplX3RnYSwgTlVMTCwNCkBAIC0xNDk1
LDcgKzE1MDUsNiBAQCB0Z2FmYl9yZWdpc3RlcihzdHJ1Y3QgZGV2aWNlICpkZXYpDQogCX0NCiAN
CiAJdGdhZmJfc2V0X3BhcihpbmZvKTsNCi0JdGdhZmJfaW5pdF9maXgoaW5mbyk7DQogDQogCWlm
IChyZWdpc3Rlcl9mcmFtZWJ1ZmZlcihpbmZvKSA8IDApIHsNCiAJCXByaW50ayhLRVJOX0VSUiAi
dGdhZmI6IENvdWxkIG5vdCByZWdpc3RlciBmcmFtZWJ1ZmZlclxuIik7DQpkaWZmIC0tZ2l0IGEv
ZnMvbmZzZC9uZnM0YWNsLmMgYi9mcy9uZnNkL25mczRhY2wuYw0KaW5kZXggOWM1MWFmZi4uNDM1
YTliZTEgMTAwNjQ0DQotLS0gYS9mcy9uZnNkL25mczRhY2wuYw0KKysrIGIvZnMvbmZzZC9uZnM0
YWNsLmMNCkBAIC0zNzMsOCArMzczLDEwIEBAIHNvcnRfcGFjbChzdHJ1Y3QgcG9zaXhfYWNsICpw
YWNsKQ0KIAkgKiBieSB1aWQvZ2lkLiAqLw0KIAlpbnQgaSwgajsNCiANCi0JaWYgKHBhY2wtPmFf
Y291bnQgPD0gNCkNCi0JCXJldHVybjsgLyogbm8gdXNlcnMgb3IgZ3JvdXBzICovDQorCS8qIG5v
IHVzZXJzIG9yIGdyb3VwcyAqLw0KKwlpZiAoIXBhY2wgfHwgcGFjbC0+YV9jb3VudCA8PSA0KQ0K
KwkJcmV0dXJuOw0KKw0KIAlpID0gMTsNCiAJd2hpbGUgKHBhY2wtPmFfZW50cmllc1tpXS5lX3Rh
ZyA9PSBBQ0xfVVNFUikNCiAJCWkrKzsNCkBAIC00OTgsMTMgKzUwMCwxMiBAQCBwb3NpeF9zdGF0
ZV90b19hY2woc3RydWN0IHBvc2l4X2FjbF9zdGF0ZSAqc3RhdGUsIHVuc2lnbmVkIGludCBmbGFn
cykNCiANCiAJLyoNCiAJICogQUNMcyB3aXRoIG5vIEFDRXMgYXJlIHRyZWF0ZWQgZGlmZmVyZW50
bHkgaW4gdGhlIGluaGVyaXRhYmxlDQotCSAqIGFuZCBlZmZlY3RpdmUgY2FzZXM6IHdoZW4gdGhl
cmUgYXJlIG5vIGluaGVyaXRhYmxlIEFDRXMsIHdlDQotCSAqIHNldCBhIHplcm8tbGVuZ3RoIGRl
ZmF1bHQgcG9zaXggYWNsOg0KKwkgKiBhbmQgZWZmZWN0aXZlIGNhc2VzOiB3aGVuIHRoZXJlIGFy
ZSBubyBpbmhlcml0YWJsZSBBQ0VzLA0KKwkgKiBjYWxscyAtPnNldF9hY2wgd2l0aCBhIE5VTEwg
QUNMIHN0cnVjdHVyZS4NCiAJICovDQotCWlmIChzdGF0ZS0+ZW1wdHkgJiYgKGZsYWdzICYgTkZT
NF9BQ0xfVFlQRV9ERUZBVUxUKSkgew0KLQkJcGFjbCA9IHBvc2l4X2FjbF9hbGxvYygwLCBHRlBf
S0VSTkVMKTsNCi0JCXJldHVybiBwYWNsID8gcGFjbCA6IEVSUl9QVFIoLUVOT01FTSk7DQotCX0N
CisJaWYgKHN0YXRlLT5lbXB0eSAmJiAoZmxhZ3MgJiBORlM0X0FDTF9UWVBFX0RFRkFVTFQpKQ0K
KwkJcmV0dXJuIE5VTEw7DQorDQogCS8qDQogCSAqIFdoZW4gdGhlcmUgYXJlIG5vIGVmZmVjdGl2
ZSBBQ0VzLCB0aGUgZm9sbG93aW5nIHdpbGwgZW5kDQogCSAqIHVwIHNldHRpbmcgYSAzLWVsZW1l
bnQgZWZmZWN0aXZlIHBvc2l4IEFDTCB3aXRoIGFsbA0KZGlmZiAtLWdpdCBhL2ZzL25mc2QvbmZz
NHN0YXRlLmMgYi9mcy9uZnNkL25mczRzdGF0ZS5jDQppbmRleCA0Y2VmOTlmLi5iMmUwYTU1IDEw
MDY0NA0KLS0tIGEvZnMvbmZzZC9uZnM0c3RhdGUuYw0KKysrIGIvZnMvbmZzZC9uZnM0c3RhdGUu
Yw0KQEAgLTk4Niw2ICs5ODYsMTggQEAgc3RhdGljIHN0cnVjdCBuZnM0X2NsaWVudCAqYWxsb2Nf
Y2xpZW50KHN0cnVjdCB4ZHJfbmV0b2JqIG5hbWUpDQogCX0NCiAJbWVtY3B5KGNscC0+Y2xfbmFt
ZS5kYXRhLCBuYW1lLmRhdGEsIG5hbWUubGVuKTsNCiAJY2xwLT5jbF9uYW1lLmxlbiA9IG5hbWUu
bGVuOw0KKwlJTklUX0xJU1RfSEVBRCgmY2xwLT5jbF9zZXNzaW9ucyk7DQorCWlkcl9pbml0KCZj
bHAtPmNsX3N0YXRlaWRzKTsNCisJYXRvbWljX3NldCgmY2xwLT5jbF9yZWZjb3VudCwgMCk7DQor
CWNscC0+Y2xfY2Jfc3RhdGUgPSBORlNENF9DQl9VTktOT1dOOw0KKwlJTklUX0xJU1RfSEVBRCgm
Y2xwLT5jbF9pZGhhc2gpOw0KKwlJTklUX0xJU1RfSEVBRCgmY2xwLT5jbF9zdHJoYXNoKTsNCisJ
SU5JVF9MSVNUX0hFQUQoJmNscC0+Y2xfb3Blbm93bmVycyk7DQorCUlOSVRfTElTVF9IRUFEKCZj
bHAtPmNsX2RlbGVnYXRpb25zKTsNCisJSU5JVF9MSVNUX0hFQUQoJmNscC0+Y2xfbHJ1KTsNCisJ
SU5JVF9MSVNUX0hFQUQoJmNscC0+Y2xfY2FsbGJhY2tzKTsNCisJc3Bpbl9sb2NrX2luaXQoJmNs
cC0+Y2xfbG9jayk7DQorCXJwY19pbml0X3dhaXRfcXVldWUoJmNscC0+Y2xfY2Jfd2FpdHEsICJC
YWNrY2hhbm5lbCBzbG90IHRhYmxlIik7DQogCXJldHVybiBjbHA7DQogfQ0KIA0KQEAgLTk5OSw2
ICsxMDExLDcgQEAgZnJlZV9jbGllbnQoc3RydWN0IG5mczRfY2xpZW50ICpjbHApDQogCQlsaXN0
X2RlbCgmc2VzLT5zZV9wZXJjbG50KTsNCiAJCW5mc2Q0X3B1dF9zZXNzaW9uKHNlcyk7DQogCX0N
CisJcnBjX2Rlc3Ryb3lfd2FpdF9xdWV1ZSgmY2xwLT5jbF9jYl93YWl0cSk7DQogCWlmIChjbHAt
PmNsX2NyZWQuY3JfZ3JvdXBfaW5mbykNCiAJCXB1dF9ncm91cF9pbmZvKGNscC0+Y2xfY3JlZC5j
cl9ncm91cF9pbmZvKTsNCiAJa2ZyZWUoY2xwLT5jbF9wcmluY2lwYWwpOw0KQEAgLTExNjMsNyAr
MTE3Niw2IEBAIHN0YXRpYyBzdHJ1Y3QgbmZzNF9jbGllbnQgKmNyZWF0ZV9jbGllbnQoc3RydWN0
IHhkcl9uZXRvYmogbmFtZSwgY2hhciAqcmVjZGlyLA0KIAlpZiAoY2xwID09IE5VTEwpDQogCQly
ZXR1cm4gTlVMTDsNCiANCi0JSU5JVF9MSVNUX0hFQUQoJmNscC0+Y2xfc2Vzc2lvbnMpOw0KIA0K
IAlwcmluYyA9IHN2Y19nc3NfcHJpbmNpcGFsKHJxc3RwKTsNCiAJaWYgKHByaW5jKSB7DQpAQCAt
MTE3NCwyMSArMTE4NiwxMCBAQCBzdGF0aWMgc3RydWN0IG5mczRfY2xpZW50ICpjcmVhdGVfY2xp
ZW50KHN0cnVjdCB4ZHJfbmV0b2JqIG5hbWUsIGNoYXIgKnJlY2RpciwNCiAJCX0NCiAJfQ0KIA0K
LQlpZHJfaW5pdCgmY2xwLT5jbF9zdGF0ZWlkcyk7DQogCW1lbWNweShjbHAtPmNsX3JlY2Rpciwg
cmVjZGlyLCBIRVhESVJfTEVOKTsNCi0JYXRvbWljX3NldCgmY2xwLT5jbF9yZWZjb3VudCwgMCk7
DQotCWNscC0+Y2xfY2Jfc3RhdGUgPSBORlNENF9DQl9VTktOT1dOOw0KLQlJTklUX0xJU1RfSEVB
RCgmY2xwLT5jbF9pZGhhc2gpOw0KLQlJTklUX0xJU1RfSEVBRCgmY2xwLT5jbF9zdHJoYXNoKTsN
Ci0JSU5JVF9MSVNUX0hFQUQoJmNscC0+Y2xfb3Blbm93bmVycyk7DQotCUlOSVRfTElTVF9IRUFE
KCZjbHAtPmNsX2RlbGVnYXRpb25zKTsNCi0JSU5JVF9MSVNUX0hFQUQoJmNscC0+Y2xfbHJ1KTsN
Ci0JSU5JVF9MSVNUX0hFQUQoJmNscC0+Y2xfY2FsbGJhY2tzKTsNCi0Jc3Bpbl9sb2NrX2luaXQo
JmNscC0+Y2xfbG9jayk7DQogCUlOSVRfV09SSygmY2xwLT5jbF9jYl9udWxsLmNiX3dvcmssIG5m
c2Q0X2RvX2NhbGxiYWNrX3JwYyk7DQogCWNscC0+Y2xfdGltZSA9IGdldF9zZWNvbmRzKCk7DQog
CWNsZWFyX2JpdCgwLCAmY2xwLT5jbF9jYl9zbG90X2J1c3kpOw0KLQlycGNfaW5pdF93YWl0X3F1
ZXVlKCZjbHAtPmNsX2NiX3dhaXRxLCAiQmFja2NoYW5uZWwgc2xvdCB0YWJsZSIpOw0KIAljb3B5
X3ZlcmYoY2xwLCB2ZXJmKTsNCiAJcnBjX2NvcHlfYWRkcigoc3RydWN0IHNvY2thZGRyICopICZj
bHAtPmNsX2FkZHIsIHNhKTsNCiAJY2xwLT5jbF9mbGF2b3IgPSBycXN0cC0+cnFfZmxhdm9yOw0K
QEAgLTMzNzUsOSArMzM3NiwxNiBAQCBvdXQ6DQogc3RhdGljIF9fYmUzMg0KIG5mc2Q0X2ZyZWVf
bG9ja19zdGF0ZWlkKHN0cnVjdCBuZnM0X29sX3N0YXRlaWQgKnN0cCkNCiB7DQotCWlmIChjaGVj
a19mb3JfbG9ja3Moc3RwLT5zdF9maWxlLCBsb2Nrb3duZXIoc3RwLT5zdF9zdGF0ZW93bmVyKSkp
DQorCXN0cnVjdCBuZnM0X2xvY2tvd25lciAqbG8gPSBsb2Nrb3duZXIoc3RwLT5zdF9zdGF0ZW93
bmVyKTsNCisNCisJaWYgKGNoZWNrX2Zvcl9sb2NrcyhzdHAtPnN0X2ZpbGUsIGxvKSkNCiAJCXJl
dHVybiBuZnNlcnJfbG9ja3NfaGVsZDsNCi0JcmVsZWFzZV9sb2NrX3N0YXRlaWQoc3RwKTsNCisJ
LyoNCisJICogQ3VycmVudGx5IHRoZXJlJ3MgYSAxLTEgbG9jayBzdGF0ZWlkPC0+bG9ja293bmVy
DQorCSAqIGNvcnJlc3BvbmRhbmNlLCBhbmQgd2UgaGF2ZSB0byBkZWxldGUgdGhlIGxvY2tvd25l
ciB3aGVuIHdlDQorCSAqIGRlbGV0ZSB0aGUgbG9jayBzdGF0ZWlkOg0KKwkgKi8NCisJdW5oYXNo
X2xvY2tvd25lcihsbyk7DQogCXJldHVybiBuZnNfb2s7DQogfQ0KIA0KQEAgLTM4MTIsNiArMzgy
MCwxMCBAQCBzdGF0aWMgYm9vbCBzYW1lX2xvY2tvd25lcl9pbm8oc3RydWN0IG5mczRfbG9ja293
bmVyICpsbywgc3RydWN0IGlub2RlICppbm9kZSwgYw0KIA0KIAlpZiAoIXNhbWVfb3duZXJfc3Ry
KCZsby0+bG9fb3duZXIsIG93bmVyLCBjbGlkKSkNCiAJCXJldHVybiBmYWxzZTsNCisJaWYgKGxp
c3RfZW1wdHkoJmxvLT5sb19vd25lci5zb19zdGF0ZWlkcykpIHsNCisJCVdBUk5fT05fT05DRSgx
KTsNCisJCXJldHVybiBmYWxzZTsNCisJfQ0KIAlsc3QgPSBsaXN0X2ZpcnN0X2VudHJ5KCZsby0+
bG9fb3duZXIuc29fc3RhdGVpZHMsDQogCQkJICAgICAgIHN0cnVjdCBuZnM0X29sX3N0YXRlaWQs
IHN0X3BlcnN0YXRlb3duZXIpOw0KIAlyZXR1cm4gbHN0LT5zdF9maWxlLT5maV9pbm9kZSA9PSBp
bm9kZTsNCmRpZmYgLS1naXQgYS9mcy9wb3NpeF9hY2wuYyBiL2ZzL3Bvc2l4X2FjbC5jDQppbmRl
eCBjZWE0NjIzLi42YzcwYWIyIDEwMDY0NA0KLS0tIGEvZnMvcG9zaXhfYWNsLmMNCisrKyBiL2Zz
L3Bvc2l4X2FjbC5jDQpAQCAtMTU1LDYgKzE1NSwxMiBAQCBwb3NpeF9hY2xfZXF1aXZfbW9kZShj
b25zdCBzdHJ1Y3QgcG9zaXhfYWNsICphY2wsIHVtb2RlX3QgKm1vZGVfcCkNCiAJdW1vZGVfdCBt
b2RlID0gMDsNCiAJaW50IG5vdF9lcXVpdiA9IDA7DQogDQorCS8qDQorCSAqIEEgbnVsbCBBQ0wg
Y2FuIGFsd2F5cyBiZSBwcmVzZW50ZWQgYXMgbW9kZSBiaXRzLg0KKwkgKi8NCisJaWYgKCFhY2wp
DQorCQlyZXR1cm4gMDsNCisNCiAJRk9SRUFDSF9BQ0xfRU5UUlkocGEsIGFjbCwgcGUpIHsNCiAJ
CXN3aXRjaCAocGEtPmVfdGFnKSB7DQogCQkJY2FzZSBBQ0xfVVNFUl9PQko6DQpkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC9mdHJhY2UuaCBiL2luY2x1ZGUvbGludXgvZnRyYWNlLmgNCmluZGV4
IDI2ZWFmY2UuLmEzZWJiMDkgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L2Z0cmFjZS5oDQor
KysgYi9pbmNsdWRlL2xpbnV4L2Z0cmFjZS5oDQpAQCAtMjYwLDYgKzI2MCw3IEBAIGV4dGVybiBp
bnQgZnRyYWNlX21ha2VfY2FsbChzdHJ1Y3QgZHluX2Z0cmFjZSAqcmVjLCB1bnNpZ25lZCBsb25n
IGFkZHIpOw0KIGV4dGVybiBpbnQgZnRyYWNlX2FyY2hfcmVhZF9keW5faW5mbyhjaGFyICpidWYs
IGludCBzaXplKTsNCiANCiBleHRlcm4gaW50IHNraXBfdHJhY2UodW5zaWduZWQgbG9uZyBpcCk7
DQorZXh0ZXJuIHZvaWQgZnRyYWNlX21vZHVsZV9pbml0KHN0cnVjdCBtb2R1bGUgKm1vZCk7DQog
DQogZXh0ZXJuIHZvaWQgZnRyYWNlX2Rpc2FibGVfZGFlbW9uKHZvaWQpOw0KIGV4dGVybiB2b2lk
IGZ0cmFjZV9lbmFibGVfZGFlbW9uKHZvaWQpOw0KQEAgLTI3Miw2ICsyNzMsNyBAQCBzdGF0aWMg
aW5saW5lIHZvaWQgZnRyYWNlX3NldF9maWx0ZXIodW5zaWduZWQgY2hhciAqYnVmLCBpbnQgbGVu
LCBpbnQgcmVzZXQpDQogc3RhdGljIGlubGluZSB2b2lkIGZ0cmFjZV9kaXNhYmxlX2RhZW1vbih2
b2lkKSB7IH0NCiBzdGF0aWMgaW5saW5lIHZvaWQgZnRyYWNlX2VuYWJsZV9kYWVtb24odm9pZCkg
eyB9DQogc3RhdGljIGlubGluZSB2b2lkIGZ0cmFjZV9yZWxlYXNlX21vZChzdHJ1Y3QgbW9kdWxl
ICptb2QpIHt9DQorc3RhdGljIGlubGluZSB2b2lkIGZ0cmFjZV9tb2R1bGVfaW5pdChzdHJ1Y3Qg
bW9kdWxlICptb2QpIHt9DQogc3RhdGljIGlubGluZSBpbnQgcmVnaXN0ZXJfZnRyYWNlX2NvbW1h
bmQoc3RydWN0IGZ0cmFjZV9mdW5jX2NvbW1hbmQgKmNtZCkNCiB7DQogCXJldHVybiAtRUlOVkFM
Ow0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaCBiL2luY2x1ZGUvbGludXgv
a3ZtX2hvc3QuaA0KaW5kZXggZTY3OTZjMS4uZjkzZDhjMSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUv
bGludXgva3ZtX2hvc3QuaA0KKysrIGIvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oDQpAQCAtOTUs
NyArOTUsNiBAQCBzdHJ1Y3Qga3ZtX2FzeW5jX3BmIHsNCiAJdW5zaWduZWQgbG9uZyBhZGRyOw0K
IAlzdHJ1Y3Qga3ZtX2FyY2hfYXN5bmNfcGYgYXJjaDsNCiAJc3RydWN0IHBhZ2UgKnBhZ2U7DQot
CWJvb2wgZG9uZTsNCiB9Ow0KIA0KIHZvaWQga3ZtX2NsZWFyX2FzeW5jX3BmX2NvbXBsZXRpb25f
cXVldWUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L3NrYnVmZi5oIGIvaW5jbHVkZS9saW51eC9za2J1ZmYuaA0KaW5kZXggMTNiZDZkMC4uYzQ0NWU1
MiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvc2tidWZmLmgNCisrKyBiL2luY2x1ZGUvbGlu
dXgvc2tidWZmLmgNCkBAIC02MTcsMTEgKzYxNywyMSBAQCBzdGF0aWMgaW5saW5lIHVuc2lnbmVk
IGNoYXIgKnNrYl9lbmRfcG9pbnRlcihjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KIHsNCiAJ
cmV0dXJuIHNrYi0+aGVhZCArIHNrYi0+ZW5kOw0KIH0NCisNCitzdGF0aWMgaW5saW5lIHVuc2ln
bmVkIGludCBza2JfZW5kX29mZnNldChjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KK3sNCisJ
cmV0dXJuIHNrYi0+ZW5kOw0KK30NCiAjZWxzZQ0KIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgY2hh
ciAqc2tiX2VuZF9wb2ludGVyKGNvbnN0IHN0cnVjdCBza19idWZmICpza2IpDQogew0KIAlyZXR1
cm4gc2tiLT5lbmQ7DQogfQ0KKw0KK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IHNrYl9lbmRf
b2Zmc2V0KGNvbnN0IHN0cnVjdCBza19idWZmICpza2IpDQorew0KKwlyZXR1cm4gc2tiLT5lbmQg
LSBza2ItPmhlYWQ7DQorfQ0KICNlbmRpZg0KIA0KIC8qIEludGVybmFsICovDQpAQCAtMjU0OSw3
ICsyNTU5LDcgQEAgc3RhdGljIGlubGluZSBib29sIHNrYl9pc19yZWN5Y2xlYWJsZShjb25zdCBz
dHJ1Y3Qgc2tfYnVmZiAqc2tiLCBpbnQgc2tiX3NpemUpDQogCQlyZXR1cm4gZmFsc2U7DQogDQog
CXNrYl9zaXplID0gU0tCX0RBVEFfQUxJR04oc2tiX3NpemUgKyBORVRfU0tCX1BBRCk7DQotCWlm
IChza2JfZW5kX3BvaW50ZXIoc2tiKSAtIHNrYi0+aGVhZCA8IHNrYl9zaXplKQ0KKwlpZiAoc2ti
X2VuZF9vZmZzZXQoc2tiKSA8IHNrYl9zaXplKQ0KIAkJcmV0dXJuIGZhbHNlOw0KIA0KIAlpZiAo
c2tiX3NoYXJlZChza2IpIHx8IHNrYl9jbG9uZWQoc2tiKSkNCmRpZmYgLS1naXQgYS9pbmNsdWRl
L25ldC9pcDZfcm91dGUuaCBiL2luY2x1ZGUvbmV0L2lwNl9yb3V0ZS5oDQppbmRleCA1ZTkxYjcy
Li40OTEzZGFjIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9uZXQvaXA2X3JvdXRlLmgNCisrKyBiL2lu
Y2x1ZGUvbmV0L2lwNl9yb3V0ZS5oDQpAQCAtMzQsNiArMzQsMTEgQEAgc3RydWN0IHJvdXRlX2lu
Zm8gew0KICNkZWZpbmUgUlQ2X0xPT0tVUF9GX1NSQ1BSRUZfUFVCTElDCTB4MDAwMDAwMTANCiAj
ZGVmaW5lIFJUNl9MT09LVVBfRl9TUkNQUkVGX0NPQQkweDAwMDAwMDIwDQogDQorLyogV2UgZG8g
bm90ICh5ZXQgPykgc3VwcG9ydCBJUHY2IGp1bWJvZ3JhbXMgKFJGQyAyNjc1KQ0KKyAqIFVubGlr
ZSBJUHY0LCBoZHItPnNlZ19sZW4gZG9lc24ndCBpbmNsdWRlIHRoZSBJUHY2IGhlYWRlcg0KKyAq
Lw0KKyNkZWZpbmUgSVA2X01BWF9NVFUgKDB4RkZGRiArIHNpemVvZihzdHJ1Y3QgaXB2Nmhkcikp
DQorDQogLyoNCiAgKiBydDZfc3JjcHJlZnMyZmxhZ3MoKSBhbmQgcnQ2X2ZsYWdzMnNyY3ByZWZz
KCkgdHJhbnNsYXRlDQogICogYmV0d2VlbiBJUFY2X0FERFJfUFJFRkVSRU5DRVMgc29ja2V0IG9w
dGlvbiB2YWx1ZXMNCmRpZmYgLS1naXQgYS9pbmNsdWRlL3RyYWNlL2V2ZW50cy9tb2R1bGUuaCBi
L2luY2x1ZGUvdHJhY2UvZXZlbnRzL21vZHVsZS5oDQppbmRleCAxNjE5MzI3Li5jYTI5OGM3IDEw
MDY0NA0KLS0tIGEvaW5jbHVkZS90cmFjZS9ldmVudHMvbW9kdWxlLmgNCisrKyBiL2luY2x1ZGUv
dHJhY2UvZXZlbnRzL21vZHVsZS5oDQpAQCAtNzgsNyArNzgsNyBAQCBERUNMQVJFX0VWRU5UX0NM
QVNTKG1vZHVsZV9yZWZjbnQsDQogDQogCVRQX2Zhc3RfYXNzaWduKA0KIAkJX19lbnRyeS0+aXAJ
PSBpcDsNCi0JCV9fZW50cnktPnJlZmNudAk9IF9fdGhpc19jcHVfcmVhZChtb2QtPnJlZnB0ci0+
aW5jcykgKyBfX3RoaXNfY3B1X3JlYWQobW9kLT5yZWZwdHItPmRlY3MpOw0KKwkJX19lbnRyeS0+
cmVmY250CT0gX190aGlzX2NwdV9yZWFkKG1vZC0+cmVmcHRyLT5pbmNzKSAtIF9fdGhpc19jcHVf
cmVhZChtb2QtPnJlZnB0ci0+ZGVjcyk7DQogCQlfX2Fzc2lnbl9zdHIobmFtZSwgbW9kLT5uYW1l
KTsNCiAJKSwNCiANCmRpZmYgLS1naXQgYS9rZXJuZWwvZXZlbnRzL2NvcmUuYyBiL2tlcm5lbC9l
dmVudHMvY29yZS5jDQppbmRleCBiMTViNGY3Li4xZDFlZGNiIDEwMDY0NA0KLS0tIGEva2VybmVs
L2V2ZW50cy9jb3JlLmMNCisrKyBiL2tlcm5lbC9ldmVudHMvY29yZS5jDQpAQCAtNDg5OSw2ICs0
ODk5LDkgQEAgc3RydWN0IHN3ZXZlbnRfaHRhYmxlIHsNCiANCiAJLyogUmVjdXJzaW9uIGF2b2lk
YW5jZSBpbiBlYWNoIGNvbnRleHRzICovDQogCWludAkJCQlyZWN1cnNpb25bUEVSRl9OUl9DT05U
RVhUU107DQorDQorCS8qIEtlZXBzIHRyYWNrIG9mIGNwdSBiZWluZyBpbml0aWFsaXplZC9leGl0
ZWQgKi8NCisJYm9vbAkJCQlvbmxpbmU7DQogfTsNCiANCiBzdGF0aWMgREVGSU5FX1BFUl9DUFUo
c3RydWN0IHN3ZXZlbnRfaHRhYmxlLCBzd2V2ZW50X2h0YWJsZSk7DQpAQCAtNTE0MSw4ICs1MTQ0
LDE0IEBAIHN0YXRpYyBpbnQgcGVyZl9zd2V2ZW50X2FkZChzdHJ1Y3QgcGVyZl9ldmVudCAqZXZl
bnQsIGludCBmbGFncykNCiAJaHdjLT5zdGF0ZSA9ICEoZmxhZ3MgJiBQRVJGX0VGX1NUQVJUKTsN
CiANCiAJaGVhZCA9IGZpbmRfc3dldmVudF9oZWFkKHN3aGFzaCwgZXZlbnQpOw0KLQlpZiAoV0FS
Tl9PTl9PTkNFKCFoZWFkKSkNCisJaWYgKCFoZWFkKSB7DQorCQkvKg0KKwkJICogV2UgY2FuIHJh
Y2Ugd2l0aCBjcHUgaG90cGx1ZyBjb2RlLiBEbyBub3QNCisJCSAqIFdBUk4gaWYgdGhlIGNwdSBq
dXN0IGdvdCB1bnBsdWdnZWQuDQorCQkgKi8NCisJCVdBUk5fT05fT05DRShzd2hhc2gtPm9ubGlu
ZSk7DQogCQlyZXR1cm4gLUVJTlZBTDsNCisJfQ0KIA0KIAlobGlzdF9hZGRfaGVhZF9yY3UoJmV2
ZW50LT5obGlzdF9lbnRyeSwgaGVhZCk7DQogDQpAQCAtNjMwMSw2ICs2MzEwLDkgQEAgU1lTQ0FM
TF9ERUZJTkU1KHBlcmZfZXZlbnRfb3BlbiwNCiAJaWYgKGF0dHIuZnJlcSkgew0KIAkJaWYgKGF0
dHIuc2FtcGxlX2ZyZXEgPiBzeXNjdGxfcGVyZl9ldmVudF9zYW1wbGVfcmF0ZSkNCiAJCQlyZXR1
cm4gLUVJTlZBTDsNCisJfSBlbHNlIHsNCisJCWlmIChhdHRyLnNhbXBsZV9wZXJpb2QgJiAoMVVM
TCA8PCA2MykpDQorCQkJcmV0dXJuIC1FSU5WQUw7DQogCX0NCiANCiAJLyoNCkBAIC03MDc4LDYg
KzcwOTAsNyBAQCBzdGF0aWMgdm9pZCBfX2NwdWluaXQgcGVyZl9ldmVudF9pbml0X2NwdShpbnQg
Y3B1KQ0KIAlzdHJ1Y3Qgc3dldmVudF9odGFibGUgKnN3aGFzaCA9ICZwZXJfY3B1KHN3ZXZlbnRf
aHRhYmxlLCBjcHUpOw0KIA0KIAltdXRleF9sb2NrKCZzd2hhc2gtPmhsaXN0X211dGV4KTsNCisJ
c3doYXNoLT5vbmxpbmUgPSB0cnVlOw0KIAlpZiAoc3doYXNoLT5obGlzdF9yZWZjb3VudCA+IDAp
IHsNCiAJCXN0cnVjdCBzd2V2ZW50X2hsaXN0ICpobGlzdDsNCiANCkBAIC03MTM1LDYgKzcxNDgs
NyBAQCBzdGF0aWMgdm9pZCBwZXJmX2V2ZW50X2V4aXRfY3B1KGludCBjcHUpDQogCXBlcmZfZXZl
bnRfZXhpdF9jcHVfY29udGV4dChjcHUpOw0KIA0KIAltdXRleF9sb2NrKCZzd2hhc2gtPmhsaXN0
X211dGV4KTsNCisJc3doYXNoLT5vbmxpbmUgPSBmYWxzZTsNCiAJc3dldmVudF9obGlzdF9yZWxl
YXNlKHN3aGFzaCk7DQogCW11dGV4X3VubG9jaygmc3doYXNoLT5obGlzdF9tdXRleCk7DQogfQ0K
ZGlmZiAtLWdpdCBhL2tlcm5lbC9mdXRleC5jIGIva2VybmVsL2Z1dGV4LmMNCmluZGV4IDg4ODg4
MTUuLjFiYjM3ZDAgMTAwNjQ0DQotLS0gYS9rZXJuZWwvZnV0ZXguYw0KKysrIGIva2VybmVsL2Z1
dGV4LmMNCkBAIC01ODgsNiArNTg4LDU1IEBAIHZvaWQgZXhpdF9waV9zdGF0ZV9saXN0KHN0cnVj
dCB0YXNrX3N0cnVjdCAqY3VycikNCiAJcmF3X3NwaW5fdW5sb2NrX2lycSgmY3Vyci0+cGlfbG9j
ayk7DQogfQ0KIA0KKy8qDQorICogV2UgbmVlZCB0byBjaGVjayB0aGUgZm9sbG93aW5nIHN0YXRl
czoNCisgKg0KKyAqICAgICAgV2FpdGVyIHwgcGlfc3RhdGUgfCBwaS0+b3duZXIgfCB1VElEICAg
ICAgfCB1T0RJRUQgfCA/DQorICoNCisgKiBbMV0gIE5VTEwgICB8IC0tLSAgICAgIHwgLS0tICAg
ICAgIHwgMCAgICAgICAgIHwgMC8xICAgIHwgVmFsaWQNCisgKiBbMl0gIE5VTEwgICB8IC0tLSAg
ICAgIHwgLS0tICAgICAgIHwgPjAgICAgICAgIHwgMC8xICAgIHwgVmFsaWQNCisgKg0KKyAqIFsz
XSAgRm91bmQgIHwgTlVMTCAgICAgfCAtLSAgICAgICAgfCBBbnkgICAgICAgfCAwLzEgICAgfCBJ
bnZhbGlkDQorICoNCisgKiBbNF0gIEZvdW5kICB8IEZvdW5kICAgIHwgTlVMTCAgICAgIHwgMCAg
ICAgICAgIHwgMSAgICAgIHwgVmFsaWQNCisgKiBbNV0gIEZvdW5kICB8IEZvdW5kICAgIHwgTlVM
TCAgICAgIHwgPjAgICAgICAgIHwgMSAgICAgIHwgSW52YWxpZA0KKyAqDQorICogWzZdICBGb3Vu
ZCAgfCBGb3VuZCAgICB8IHRhc2sgICAgICB8IDAgICAgICAgICB8IDEgICAgICB8IFZhbGlkDQor
ICoNCisgKiBbN10gIEZvdW5kICB8IEZvdW5kICAgIHwgTlVMTCAgICAgIHwgQW55ICAgICAgIHwg
MCAgICAgIHwgSW52YWxpZA0KKyAqDQorICogWzhdICBGb3VuZCAgfCBGb3VuZCAgICB8IHRhc2sg
ICAgICB8ID09dGFza1RJRCB8IDAvMSAgICB8IFZhbGlkDQorICogWzldICBGb3VuZCAgfCBGb3Vu
ZCAgICB8IHRhc2sgICAgICB8IDAgICAgICAgICB8IDAgICAgICB8IEludmFsaWQNCisgKiBbMTBd
IEZvdW5kICB8IEZvdW5kICAgIHwgdGFzayAgICAgIHwgIT10YXNrVElEIHwgMC8xICAgIHwgSW52
YWxpZA0KKyAqDQorICogWzFdCUluZGljYXRlcyB0aGF0IHRoZSBrZXJuZWwgY2FuIGFjcXVpcmUg
dGhlIGZ1dGV4IGF0b21pY2FsbHkuIFdlDQorICoJY2FtZSBjYW1lIGhlcmUgZHVlIHRvIGEgc3Rh
bGUgRlVURVhfV0FJVEVSUy9GVVRFWF9PV05FUl9ESUVEIGJpdC4NCisgKg0KKyAqIFsyXQlWYWxp
ZCwgaWYgVElEIGRvZXMgbm90IGJlbG9uZyB0byBhIGtlcm5lbCB0aHJlYWQuIElmIG5vIG1hdGNo
aW5nDQorICogICAgICB0aHJlYWQgaXMgZm91bmQgdGhlbiBpdCBpbmRpY2F0ZXMgdGhhdCB0aGUg
b3duZXIgVElEIGhhcyBkaWVkLg0KKyAqDQorICogWzNdCUludmFsaWQuIFRoZSB3YWl0ZXIgaXMg
cXVldWVkIG9uIGEgbm9uIFBJIGZ1dGV4DQorICoNCisgKiBbNF0JVmFsaWQgc3RhdGUgYWZ0ZXIg
ZXhpdF9yb2J1c3RfbGlzdCgpLCB3aGljaCBzZXRzIHRoZSB1c2VyIHNwYWNlDQorICoJdmFsdWUg
dG8gRlVURVhfV0FJVEVSUyB8IEZVVEVYX09XTkVSX0RJRUQuDQorICoNCisgKiBbNV0JVGhlIHVz
ZXIgc3BhY2UgdmFsdWUgZ290IG1hbmlwdWxhdGVkIGJldHdlZW4gZXhpdF9yb2J1c3RfbGlzdCgp
DQorICoJYW5kIGV4aXRfcGlfc3RhdGVfbGlzdCgpDQorICoNCisgKiBbNl0JVmFsaWQgc3RhdGUg
YWZ0ZXIgZXhpdF9waV9zdGF0ZV9saXN0KCkgd2hpY2ggc2V0cyB0aGUgbmV3IG93bmVyIGluDQor
ICoJdGhlIHBpX3N0YXRlIGJ1dCBjYW5ub3QgYWNjZXNzIHRoZSB1c2VyIHNwYWNlIHZhbHVlLg0K
KyAqDQorICogWzddCXBpX3N0YXRlLT5vd25lciBjYW4gb25seSBiZSBOVUxMIHdoZW4gdGhlIE9X
TkVSX0RJRUQgYml0IGlzIHNldC4NCisgKg0KKyAqIFs4XQlPd25lciBhbmQgdXNlciBzcGFjZSB2
YWx1ZSBtYXRjaA0KKyAqDQorICogWzldCVRoZXJlIGlzIG5vIHRyYW5zaWVudCBzdGF0ZSB3aGlj
aCBzZXRzIHRoZSB1c2VyIHNwYWNlIFRJRCB0byAwDQorICoJZXhjZXB0IGV4aXRfcm9idXN0X2xp
c3QoKSwgYnV0IHRoaXMgaXMgaW5kaWNhdGVkIGJ5IHRoZQ0KKyAqCUZVVEVYX09XTkVSX0RJRUQg
Yml0LiBTZWUgWzRdDQorICoNCisgKiBbMTBdIFRoZXJlIGlzIG5vIHRyYW5zaWVudCBzdGF0ZSB3
aGljaCBsZWF2ZXMgb3duZXIgYW5kIHVzZXIgc3BhY2UNCisgKglUSUQgb3V0IG9mIHN5bmMuDQor
ICovDQogc3RhdGljIGludA0KIGxvb2t1cF9waV9zdGF0ZSh1MzIgdXZhbCwgc3RydWN0IGZ1dGV4
X2hhc2hfYnVja2V0ICpoYiwNCiAJCXVuaW9uIGZ1dGV4X2tleSAqa2V5LCBzdHJ1Y3QgZnV0ZXhf
cGlfc3RhdGUgKipwcykNCkBAIC02MDMsMTIgKzY1MiwxMyBAQCBsb29rdXBfcGlfc3RhdGUodTMy
IHV2YWwsIHN0cnVjdCBmdXRleF9oYXNoX2J1Y2tldCAqaGIsDQogCXBsaXN0X2Zvcl9lYWNoX2Vu
dHJ5X3NhZmUodGhpcywgbmV4dCwgaGVhZCwgbGlzdCkgew0KIAkJaWYgKG1hdGNoX2Z1dGV4KCZ0
aGlzLT5rZXksIGtleSkpIHsNCiAJCQkvKg0KLQkJCSAqIEFub3RoZXIgd2FpdGVyIGFscmVhZHkg
ZXhpc3RzIC0gYnVtcCB1cA0KLQkJCSAqIHRoZSByZWZjb3VudCBhbmQgcmV0dXJuIGl0cyBwaV9z
dGF0ZToNCisJCQkgKiBTYW5pdHkgY2hlY2sgdGhlIHdhaXRlciBiZWZvcmUgaW5jcmVhc2luZw0K
KwkJCSAqIHRoZSByZWZjb3VudCBhbmQgYXR0YWNoaW5nIHRvIGl0Lg0KIAkJCSAqLw0KIAkJCXBp
X3N0YXRlID0gdGhpcy0+cGlfc3RhdGU7DQogCQkJLyoNCi0JCQkgKiBVc2Vyc3BhY2UgbWlnaHQg
aGF2ZSBtZXNzZWQgdXAgbm9uLVBJIGFuZCBQSSBmdXRleGVzDQorCQkJICogVXNlcnNwYWNlIG1p
Z2h0IGhhdmUgbWVzc2VkIHVwIG5vbi1QSSBhbmQNCisJCQkgKiBQSSBmdXRleGVzIFszXQ0KIAkJ
CSAqLw0KIAkJCWlmICh1bmxpa2VseSghcGlfc3RhdGUpKQ0KIAkJCQlyZXR1cm4gLUVJTlZBTDsN
CkBAIC02MTYsMzQgKzY2Niw3MCBAQCBsb29rdXBfcGlfc3RhdGUodTMyIHV2YWwsIHN0cnVjdCBm
dXRleF9oYXNoX2J1Y2tldCAqaGIsDQogCQkJV0FSTl9PTighYXRvbWljX3JlYWQoJnBpX3N0YXRl
LT5yZWZjb3VudCkpOw0KIA0KIAkJCS8qDQotCQkJICogV2hlbiBwaV9zdGF0ZS0+b3duZXIgaXMg
TlVMTCB0aGVuIHRoZSBvd25lciBkaWVkDQotCQkJICogYW5kIGFub3RoZXIgd2FpdGVyIGlzIG9u
IHRoZSBmbHkuIHBpX3N0YXRlLT5vd25lcg0KLQkJCSAqIGlzIGZpeGVkIHVwIGJ5IHRoZSB0YXNr
IHdoaWNoIGFjcXVpcmVzDQotCQkJICogcGlfc3RhdGUtPnJ0X211dGV4Lg0KLQkJCSAqDQotCQkJ
ICogV2UgZG8gbm90IGNoZWNrIGZvciBwaWQgPT0gMCB3aGljaCBjYW4gaGFwcGVuIHdoZW4NCi0J
CQkgKiB0aGUgb3duZXIgZGllZCBhbmQgcm9idXN0X2xpc3RfZXhpdCgpIGNsZWFyZWQgdGhlDQot
CQkJICogVElELg0KKwkJCSAqIEhhbmRsZSB0aGUgb3duZXIgZGllZCBjYXNlOg0KIAkJCSAqLw0K
LQkJCWlmIChwaWQgJiYgcGlfc3RhdGUtPm93bmVyKSB7DQorCQkJaWYgKHV2YWwgJiBGVVRFWF9P
V05FUl9ESUVEKSB7DQorCQkJCS8qDQorCQkJCSAqIGV4aXRfcGlfc3RhdGVfbGlzdCBzZXRzIG93
bmVyIHRvIE5VTEwgYW5kDQorCQkJCSAqIHdha2VzIHRoZSB0b3Btb3N0IHdhaXRlci4gVGhlIHRh
c2sgd2hpY2gNCisJCQkJICogYWNxdWlyZXMgdGhlIHBpX3N0YXRlLT5ydF9tdXRleCB3aWxsIGZp
eHVwDQorCQkJCSAqIG93bmVyLg0KKwkJCQkgKi8NCisJCQkJaWYgKCFwaV9zdGF0ZS0+b3duZXIp
IHsNCisJCQkJCS8qDQorCQkJCQkgKiBObyBwaSBzdGF0ZSBvd25lciwgYnV0IHRoZSB1c2VyDQor
CQkJCQkgKiBzcGFjZSBUSUQgaXMgbm90IDAuIEluY29uc2lzdGVudA0KKwkJCQkJICogc3RhdGUu
IFs1XQ0KKwkJCQkJICovDQorCQkJCQlpZiAocGlkKQ0KKwkJCQkJCXJldHVybiAtRUlOVkFMOw0K
KwkJCQkJLyoNCisJCQkJCSAqIFRha2UgYSByZWYgb24gdGhlIHN0YXRlIGFuZA0KKwkJCQkJICog
cmV0dXJuLiBbNF0NCisJCQkJCSAqLw0KKwkJCQkJZ290byBvdXRfc3RhdGU7DQorCQkJCX0NCisN
CiAJCQkJLyoNCi0JCQkJICogQmFpbCBvdXQgaWYgdXNlciBzcGFjZSBtYW5pcHVsYXRlZCB0aGUN
Ci0JCQkJICogZnV0ZXggdmFsdWUuDQorCQkJCSAqIElmIFRJRCBpcyAwLCB0aGVuIGVpdGhlciB0
aGUgZHlpbmcgb3duZXINCisJCQkJICogaGFzIG5vdCB5ZXQgZXhlY3V0ZWQgZXhpdF9waV9zdGF0
ZV9saXN0KCkNCisJCQkJICogb3Igc29tZSB3YWl0ZXIgYWNxdWlyZWQgdGhlIHJ0bXV0ZXggaW4g
dGhlDQorCQkJCSAqIHBpIHN0YXRlLCBidXQgZGlkIG5vdCB5ZXQgZml4dXAgdGhlIFRJRCBpbg0K
KwkJCQkgKiB1c2VyIHNwYWNlLg0KKwkJCQkgKg0KKwkJCQkgKiBUYWtlIGEgcmVmIG9uIHRoZSBz
dGF0ZSBhbmQgcmV0dXJuLiBbNl0NCiAJCQkJICovDQotCQkJCWlmIChwaWQgIT0gdGFza19waWRf
dm5yKHBpX3N0YXRlLT5vd25lcikpDQorCQkJCWlmICghcGlkKQ0KKwkJCQkJZ290byBvdXRfc3Rh
dGU7DQorCQkJfSBlbHNlIHsNCisJCQkJLyoNCisJCQkJICogSWYgdGhlIG93bmVyIGRpZWQgYml0
IGlzIG5vdCBzZXQsDQorCQkJCSAqIHRoZW4gdGhlIHBpX3N0YXRlIG11c3QgaGF2ZSBhbg0KKwkJ
CQkgKiBvd25lci4gWzddDQorCQkJCSAqLw0KKwkJCQlpZiAoIXBpX3N0YXRlLT5vd25lcikNCiAJ
CQkJCXJldHVybiAtRUlOVkFMOw0KIAkJCX0NCiANCisJCQkvKg0KKwkJCSAqIEJhaWwgb3V0IGlm
IHVzZXIgc3BhY2UgbWFuaXB1bGF0ZWQgdGhlDQorCQkJICogZnV0ZXggdmFsdWUuIElmIHBpIHN0
YXRlIGV4aXN0cyB0aGVuIHRoZQ0KKwkJCSAqIG93bmVyIFRJRCBtdXN0IGJlIHRoZSBzYW1lIGFz
IHRoZSB1c2VyDQorCQkJICogc3BhY2UgVElELiBbOS8xMF0NCisJCQkgKi8NCisJCQlpZiAocGlk
ICE9IHRhc2tfcGlkX3ZucihwaV9zdGF0ZS0+b3duZXIpKQ0KKwkJCQlyZXR1cm4gLUVJTlZBTDsN
CisNCisJCW91dF9zdGF0ZToNCiAJCQlhdG9taWNfaW5jKCZwaV9zdGF0ZS0+cmVmY291bnQpOw0K
IAkJCSpwcyA9IHBpX3N0YXRlOw0KLQ0KIAkJCXJldHVybiAwOw0KIAkJfQ0KIAl9DQogDQogCS8q
DQogCSAqIFdlIGFyZSB0aGUgZmlyc3Qgd2FpdGVyIC0gdHJ5IHRvIGxvb2sgdXAgdGhlIHJlYWwg
b3duZXIgYW5kIGF0dGFjaA0KLQkgKiB0aGUgbmV3IHBpX3N0YXRlIHRvIGl0LCBidXQgYmFpbCBv
dXQgd2hlbiBUSUQgPSAwDQorCSAqIHRoZSBuZXcgcGlfc3RhdGUgdG8gaXQsIGJ1dCBiYWlsIG91
dCB3aGVuIFRJRCA9IDAgWzFdDQogCSAqLw0KIAlpZiAoIXBpZCkNCiAJCXJldHVybiAtRVNSQ0g7
DQpAQCAtNjUxLDYgKzczNywxMSBAQCBsb29rdXBfcGlfc3RhdGUodTMyIHV2YWwsIHN0cnVjdCBm
dXRleF9oYXNoX2J1Y2tldCAqaGIsDQogCWlmICghcCkNCiAJCXJldHVybiAtRVNSQ0g7DQogDQor
CWlmICghcC0+bW0pIHsNCisJCXB1dF90YXNrX3N0cnVjdChwKTsNCisJCXJldHVybiAtRVBFUk07
DQorCX0NCisNCiAJLyoNCiAJICogV2UgbmVlZCB0byBsb29rIGF0IHRoZSB0YXNrIHN0YXRlIGZs
YWdzIHRvIGZpZ3VyZSBvdXQsDQogCSAqIHdoZXRoZXIgdGhlIHRhc2sgaXMgZXhpdGluZy4gVG8g
cHJvdGVjdCBhZ2FpbnN0IHRoZSBkb19leGl0DQpAQCAtNjcxLDYgKzc2Miw5IEBAIGxvb2t1cF9w
aV9zdGF0ZSh1MzIgdXZhbCwgc3RydWN0IGZ1dGV4X2hhc2hfYnVja2V0ICpoYiwNCiAJCXJldHVy
biByZXQ7DQogCX0NCiANCisJLyoNCisJICogTm8gZXhpc3RpbmcgcGkgc3RhdGUuIEZpcnN0IHdh
aXRlci4gWzJdDQorCSAqLw0KIAlwaV9zdGF0ZSA9IGFsbG9jX3BpX3N0YXRlKCk7DQogDQogCS8q
DQpAQCAtNzQyLDEwICs4MzYsMTggQEAgcmV0cnk6DQogCQlyZXR1cm4gLUVERUFETEs7DQogDQog
CS8qDQotCSAqIFN1cnByaXNlIC0gd2UgZ290IHRoZSBsb2NrLiBKdXN0IHJldHVybiB0byB1c2Vy
c3BhY2U6DQorCSAqIFN1cnByaXNlIC0gd2UgZ290IHRoZSBsb2NrLCBidXQgd2UgZG8gbm90IHRy
dXN0IHVzZXIgc3BhY2UgYXQgYWxsLg0KIAkgKi8NCi0JaWYgKHVubGlrZWx5KCFjdXJ2YWwpKQ0K
LQkJcmV0dXJuIDE7DQorCWlmICh1bmxpa2VseSghY3VydmFsKSkgew0KKwkJLyoNCisJCSAqIFdl
IHZlcmlmeSB3aGV0aGVyIHRoZXJlIGlzIGtlcm5lbCBzdGF0ZSBmb3IgdGhpcw0KKwkJICogZnV0
ZXguIElmIG5vdCwgd2UgY2FuIHNhZmVseSBhc3N1bWUsIHRoYXQgdGhlIDAgLT4NCisJCSAqIFRJ
RCB0cmFuc2l0aW9uIGlzIGNvcnJlY3QuIElmIHN0YXRlIGV4aXN0cywgd2UgZG8NCisJCSAqIG5v
dCBib3RoZXIgdG8gZml4dXAgdGhlIHVzZXIgc3BhY2Ugc3RhdGUgYXMgaXQgd2FzDQorCQkgKiBj
b3JydXB0ZWQgYWxyZWFkeS4NCisJCSAqLw0KKwkJcmV0dXJuIGZ1dGV4X3RvcF93YWl0ZXIoaGIs
IGtleSkgPyAtRUlOVkFMIDogMTsNCisJfQ0KIA0KIAl1dmFsID0gY3VydmFsOw0KIA0KQEAgLTg3
NSw2ICs5NzcsNyBAQCBzdGF0aWMgaW50IHdha2VfZnV0ZXhfcGkodTMyIF9fdXNlciAqdWFkZHIs
IHUzMiB1dmFsLCBzdHJ1Y3QgZnV0ZXhfcSAqdGhpcykNCiAJc3RydWN0IHRhc2tfc3RydWN0ICpu
ZXdfb3duZXI7DQogCXN0cnVjdCBmdXRleF9waV9zdGF0ZSAqcGlfc3RhdGUgPSB0aGlzLT5waV9z
dGF0ZTsNCiAJdTMyIHVuaW5pdGlhbGl6ZWRfdmFyKGN1cnZhbCksIG5ld3ZhbDsNCisJaW50IHJl
dCA9IDA7DQogDQogCWlmICghcGlfc3RhdGUpDQogCQlyZXR1cm4gLUVJTlZBTDsNCkBAIC04OTgs
MjMgKzEwMDEsMTkgQEAgc3RhdGljIGludCB3YWtlX2Z1dGV4X3BpKHUzMiBfX3VzZXIgKnVhZGRy
LCB1MzIgdXZhbCwgc3RydWN0IGZ1dGV4X3EgKnRoaXMpDQogCQluZXdfb3duZXIgPSB0aGlzLT50
YXNrOw0KIA0KIAkvKg0KLQkgKiBXZSBwYXNzIGl0IHRvIHRoZSBuZXh0IG93bmVyLiAoVGhlIFdB
SVRFUlMgYml0IGlzIGFsd2F5cw0KLQkgKiBrZXB0IGVuYWJsZWQgd2hpbGUgdGhlcmUgaXMgUEkg
c3RhdGUgYXJvdW5kLiBXZSBtdXN0IGFsc28NCi0JICogcHJlc2VydmUgdGhlIG93bmVyIGRpZWQg
Yml0LikNCisJICogV2UgcGFzcyBpdCB0byB0aGUgbmV4dCBvd25lci4gVGhlIFdBSVRFUlMgYml0
IGlzIGFsd2F5cw0KKwkgKiBrZXB0IGVuYWJsZWQgd2hpbGUgdGhlcmUgaXMgUEkgc3RhdGUgYXJv
dW5kLiBXZSBjbGVhbnVwIHRoZQ0KKwkgKiBvd25lciBkaWVkIGJpdCwgYmVjYXVzZSB3ZSBhcmUg
dGhlIG93bmVyLg0KIAkgKi8NCi0JaWYgKCEodXZhbCAmIEZVVEVYX09XTkVSX0RJRUQpKSB7DQot
CQlpbnQgcmV0ID0gMDsNCisJbmV3dmFsID0gRlVURVhfV0FJVEVSUyB8IHRhc2tfcGlkX3Zucihu
ZXdfb3duZXIpOw0KIA0KLQkJbmV3dmFsID0gRlVURVhfV0FJVEVSUyB8IHRhc2tfcGlkX3Zucihu
ZXdfb3duZXIpOw0KLQ0KLQkJaWYgKGNtcHhjaGdfZnV0ZXhfdmFsdWVfbG9ja2VkKCZjdXJ2YWws
IHVhZGRyLCB1dmFsLCBuZXd2YWwpKQ0KLQkJCXJldCA9IC1FRkFVTFQ7DQotCQllbHNlIGlmIChj
dXJ2YWwgIT0gdXZhbCkNCi0JCQlyZXQgPSAtRUlOVkFMOw0KLQkJaWYgKHJldCkgew0KLQkJCXJh
d19zcGluX3VubG9jaygmcGlfc3RhdGUtPnBpX211dGV4LndhaXRfbG9jayk7DQotCQkJcmV0dXJu
IHJldDsNCi0JCX0NCisJaWYgKGNtcHhjaGdfZnV0ZXhfdmFsdWVfbG9ja2VkKCZjdXJ2YWwsIHVh
ZGRyLCB1dmFsLCBuZXd2YWwpKQ0KKwkJcmV0ID0gLUVGQVVMVDsNCisJZWxzZSBpZiAoY3VydmFs
ICE9IHV2YWwpDQorCQlyZXQgPSAtRUlOVkFMOw0KKwlpZiAocmV0KSB7DQorCQlyYXdfc3Bpbl91
bmxvY2soJnBpX3N0YXRlLT5waV9tdXRleC53YWl0X2xvY2spOw0KKwkJcmV0dXJuIHJldDsNCiAJ
fQ0KIA0KIAlyYXdfc3Bpbl9sb2NrX2lycSgmcGlfc3RhdGUtPm93bmVyLT5waV9sb2NrKTsNCkBA
IC0xMTkzLDcgKzEyOTIsNyBAQCB2b2lkIHJlcXVldWVfcGlfd2FrZV9mdXRleChzdHJ1Y3QgZnV0
ZXhfcSAqcSwgdW5pb24gZnV0ZXhfa2V5ICprZXksDQogICoNCiAgKiBSZXR1cm5zOg0KICAqICAw
IC0gZmFpbGVkIHRvIGFjcXVpcmUgdGhlIGxvY2sgYXRvbWljbHkNCi0gKiAgMSAtIGFjcXVpcmVk
IHRoZSBsb2NrDQorICogPjAgLSBhY3F1aXJlZCB0aGUgbG9jaywgcmV0dXJuIHZhbHVlIGlzIHZw
aWQgb2YgdGhlIHRvcF93YWl0ZXINCiAgKiA8MCAtIGVycm9yDQogICovDQogc3RhdGljIGludCBm
dXRleF9wcm94eV90cnlsb2NrX2F0b21pYyh1MzIgX191c2VyICpwaWZ1dGV4LA0KQEAgLTEyMDQs
NyArMTMwMyw3IEBAIHN0YXRpYyBpbnQgZnV0ZXhfcHJveHlfdHJ5bG9ja19hdG9taWModTMyIF9f
dXNlciAqcGlmdXRleCwNCiB7DQogCXN0cnVjdCBmdXRleF9xICp0b3Bfd2FpdGVyID0gTlVMTDsN
CiAJdTMyIGN1cnZhbDsNCi0JaW50IHJldDsNCisJaW50IHJldCwgdnBpZDsNCiANCiAJaWYgKGdl
dF9mdXRleF92YWx1ZV9sb2NrZWQoJmN1cnZhbCwgcGlmdXRleCkpDQogCQlyZXR1cm4gLUVGQVVM
VDsNCkBAIC0xMjMyLDExICsxMzMxLDEzIEBAIHN0YXRpYyBpbnQgZnV0ZXhfcHJveHlfdHJ5bG9j
a19hdG9taWModTMyIF9fdXNlciAqcGlmdXRleCwNCiAJICogdGhlIGNvbnRlbmRlZCBjYXNlIG9y
IGlmIHNldF93YWl0ZXJzIGlzIDEuICBUaGUgcGlfc3RhdGUgaXMgcmV0dXJuZWQNCiAJICogaW4g
cHMgaW4gY29udGVuZGVkIGNhc2VzLg0KIAkgKi8NCisJdnBpZCA9IHRhc2tfcGlkX3Zucih0b3Bf
d2FpdGVyLT50YXNrKTsNCiAJcmV0ID0gZnV0ZXhfbG9ja19waV9hdG9taWMocGlmdXRleCwgaGIy
LCBrZXkyLCBwcywgdG9wX3dhaXRlci0+dGFzaywNCiAJCQkJICAgc2V0X3dhaXRlcnMpOw0KLQlp
ZiAocmV0ID09IDEpDQorCWlmIChyZXQgPT0gMSkgew0KIAkJcmVxdWV1ZV9waV93YWtlX2Z1dGV4
KHRvcF93YWl0ZXIsIGtleTIsIGhiMik7DQotDQorCQlyZXR1cm4gdnBpZDsNCisJfQ0KIAlyZXR1
cm4gcmV0Ow0KIH0NCiANCkBAIC0xMjY4LDEwICsxMzY5LDE2IEBAIHN0YXRpYyBpbnQgZnV0ZXhf
cmVxdWV1ZSh1MzIgX191c2VyICp1YWRkcjEsIHVuc2lnbmVkIGludCBmbGFncywNCiAJc3RydWN0
IGZ1dGV4X2hhc2hfYnVja2V0ICpoYjEsICpoYjI7DQogCXN0cnVjdCBwbGlzdF9oZWFkICpoZWFk
MTsNCiAJc3RydWN0IGZ1dGV4X3EgKnRoaXMsICpuZXh0Ow0KLQl1MzIgY3VydmFsMjsNCiANCiAJ
aWYgKHJlcXVldWVfcGkpIHsNCiAJCS8qDQorCQkgKiBSZXF1ZXVlIFBJIG9ubHkgd29ya3Mgb24g
dHdvIGRpc3RpbmN0IHVhZGRycy4gVGhpcw0KKwkJICogY2hlY2sgaXMgb25seSB2YWxpZCBmb3Ig
cHJpdmF0ZSBmdXRleGVzLiBTZWUgYmVsb3cuDQorCQkgKi8NCisJCWlmICh1YWRkcjEgPT0gdWFk
ZHIyKQ0KKwkJCXJldHVybiAtRUlOVkFMOw0KKw0KKwkJLyoNCiAJCSAqIHJlcXVldWVfcGkgcmVx
dWlyZXMgYSBwaV9zdGF0ZSwgdHJ5IHRvIGFsbG9jYXRlIGl0IG5vdw0KIAkJICogd2l0aG91dCBh
bnkgbG9ja3MgaW4gY2FzZSBpdCBmYWlscy4NCiAJCSAqLw0KQEAgLTEzMDksNiArMTQxNiwxNSBA
QCByZXRyeToNCiAJaWYgKHVubGlrZWx5KHJldCAhPSAwKSkNCiAJCWdvdG8gb3V0X3B1dF9rZXkx
Ow0KIA0KKwkvKg0KKwkgKiBUaGUgY2hlY2sgYWJvdmUgd2hpY2ggY29tcGFyZXMgdWFkZHJzIGlz
IG5vdCBzdWZmaWNpZW50IGZvcg0KKwkgKiBzaGFyZWQgZnV0ZXhlcy4gV2UgbmVlZCB0byBjb21w
YXJlIHRoZSBrZXlzOg0KKwkgKi8NCisJaWYgKHJlcXVldWVfcGkgJiYgbWF0Y2hfZnV0ZXgoJmtl
eTEsICZrZXkyKSkgew0KKwkJcmV0ID0gLUVJTlZBTDsNCisJCWdvdG8gb3V0X3B1dF9rZXlzOw0K
Kwl9DQorDQogCWhiMSA9IGhhc2hfZnV0ZXgoJmtleTEpOw0KIAloYjIgPSBoYXNoX2Z1dGV4KCZr
ZXkyKTsNCiANCkBAIC0xMzU0LDE2ICsxNDcwLDI1IEBAIHJldHJ5X3ByaXZhdGU6DQogCQkgKiBB
dCB0aGlzIHBvaW50IHRoZSB0b3Bfd2FpdGVyIGhhcyBlaXRoZXIgdGFrZW4gdWFkZHIyIG9yIGlz
DQogCQkgKiB3YWl0aW5nIG9uIGl0LiAgSWYgdGhlIGZvcm1lciwgdGhlbiB0aGUgcGlfc3RhdGUg
d2lsbCBub3QNCiAJCSAqIGV4aXN0IHlldCwgbG9vayBpdCB1cCBvbmUgbW9yZSB0aW1lIHRvIGVu
c3VyZSB3ZSBoYXZlIGENCi0JCSAqIHJlZmVyZW5jZSB0byBpdC4NCisJCSAqIHJlZmVyZW5jZSB0
byBpdC4gSWYgdGhlIGxvY2sgd2FzIHRha2VuLCByZXQgY29udGFpbnMgdGhlDQorCQkgKiB2cGlk
IG9mIHRoZSB0b3Agd2FpdGVyIHRhc2suDQogCQkgKi8NCi0JCWlmIChyZXQgPT0gMSkgew0KKwkJ
aWYgKHJldCA+IDApIHsNCiAJCQlXQVJOX09OKHBpX3N0YXRlKTsNCiAJCQlkcm9wX2NvdW50Kys7
DQogCQkJdGFza19jb3VudCsrOw0KLQkJCXJldCA9IGdldF9mdXRleF92YWx1ZV9sb2NrZWQoJmN1
cnZhbDIsIHVhZGRyMik7DQotCQkJaWYgKCFyZXQpDQotCQkJCXJldCA9IGxvb2t1cF9waV9zdGF0
ZShjdXJ2YWwyLCBoYjIsICZrZXkyLA0KLQkJCQkJCSAgICAgICZwaV9zdGF0ZSk7DQorCQkJLyoN
CisJCQkgKiBJZiB3ZSBhY3F1aXJlZCB0aGUgbG9jaywgdGhlbiB0aGUgdXNlcg0KKwkJCSAqIHNw
YWNlIHZhbHVlIG9mIHVhZGRyMiBzaG91bGQgYmUgdnBpZC4gSXQNCisJCQkgKiBjYW5ub3QgYmUg
Y2hhbmdlZCBieSB0aGUgdG9wIHdhaXRlciBhcyBpdA0KKwkJCSAqIGlzIGJsb2NrZWQgb24gaGIy
IGxvY2sgaWYgaXQgdHJpZXMgdG8gZG8NCisJCQkgKiBzby4gSWYgc29tZXRoaW5nIGZpZGRsZWQg
d2l0aCBpdCBiZWhpbmQgb3VyDQorCQkJICogYmFjayB0aGUgcGkgc3RhdGUgbG9va3VwIG1pZ2h0
IHVuZWFydGgNCisJCQkgKiBpdC4gU28gd2UgcmF0aGVyIHVzZSB0aGUga25vd24gdmFsdWUgdGhh
bg0KKwkJCSAqIHJlcmVhZGluZyBhbmQgaGFuZGluZyBwb3RlbnRpYWwgY3JhcCB0bw0KKwkJCSAq
IGxvb2t1cF9waV9zdGF0ZS4NCisJCQkgKi8NCisJCQlyZXQgPSBsb29rdXBfcGlfc3RhdGUocmV0
LCBoYjIsICZrZXkyLCAmcGlfc3RhdGUpOw0KIAkJfQ0KIA0KIAkJc3dpdGNoIChyZXQpIHsNCkBA
IC0yMTMzLDkgKzIyNTgsMTAgQEAgcmV0cnk6DQogCS8qDQogCSAqIFRvIGF2b2lkIHJhY2VzLCB0
cnkgdG8gZG8gdGhlIFRJRCAtPiAwIGF0b21pYyB0cmFuc2l0aW9uDQogCSAqIGFnYWluLiBJZiBp
dCBzdWNjZWVkcyB0aGVuIHdlIGNhbiByZXR1cm4gd2l0aG91dCB3YWtpbmcNCi0JICogYW55b25l
IGVsc2UgdXA6DQorCSAqIGFueW9uZSBlbHNlIHVwLiBXZSBvbmx5IHRyeSB0aGlzIGlmIG5laXRo
ZXIgdGhlIHdhaXRlcnMgbm9yDQorCSAqIHRoZSBvd25lciBkaWVkIGJpdCBhcmUgc2V0Lg0KIAkg
Ki8NCi0JaWYgKCEodXZhbCAmIEZVVEVYX09XTkVSX0RJRUQpICYmDQorCWlmICghKHV2YWwgJiB+
RlVURVhfVElEX01BU0spICYmDQogCSAgICBjbXB4Y2hnX2Z1dGV4X3ZhbHVlX2xvY2tlZCgmdXZh
bCwgdWFkZHIsIHZwaWQsIDApKQ0KIAkJZ290byBwaV9mYXVsdGVkOw0KIAkvKg0KQEAgLTIxNjcs
MTEgKzIyOTMsOSBAQCByZXRyeToNCiAJLyoNCiAJICogTm8gd2FpdGVycyAtIGtlcm5lbCB1bmxv
Y2tzIHRoZSBmdXRleDoNCiAJICovDQotCWlmICghKHV2YWwgJiBGVVRFWF9PV05FUl9ESUVEKSkg
ew0KLQkJcmV0ID0gdW5sb2NrX2Z1dGV4X3BpKHVhZGRyLCB1dmFsKTsNCi0JCWlmIChyZXQgPT0g
LUVGQVVMVCkNCi0JCQlnb3RvIHBpX2ZhdWx0ZWQ7DQotCX0NCisJcmV0ID0gdW5sb2NrX2Z1dGV4
X3BpKHVhZGRyLCB1dmFsKTsNCisJaWYgKHJldCA9PSAtRUZBVUxUKQ0KKwkJZ290byBwaV9mYXVs
dGVkOw0KIA0KIG91dF91bmxvY2s6DQogCXNwaW5fdW5sb2NrKCZoYi0+bG9jayk7DQpAQCAtMjMz
MSw2ICsyNDU1LDE1IEBAIHN0YXRpYyBpbnQgZnV0ZXhfd2FpdF9yZXF1ZXVlX3BpKHUzMiBfX3Vz
ZXIgKnVhZGRyLCB1bnNpZ25lZCBpbnQgZmxhZ3MsDQogCWlmIChyZXQpDQogCQlnb3RvIG91dF9r
ZXkyOw0KIA0KKwkvKg0KKwkgKiBUaGUgY2hlY2sgYWJvdmUgd2hpY2ggY29tcGFyZXMgdWFkZHJz
IGlzIG5vdCBzdWZmaWNpZW50IGZvcg0KKwkgKiBzaGFyZWQgZnV0ZXhlcy4gV2UgbmVlZCB0byBj
b21wYXJlIHRoZSBrZXlzOg0KKwkgKi8NCisJaWYgKG1hdGNoX2Z1dGV4KCZxLmtleSwgJmtleTIp
KSB7DQorCQlyZXQgPSAtRUlOVkFMOw0KKwkJZ290byBvdXRfcHV0X2tleXM7DQorCX0NCisNCiAJ
LyogUXVldWUgdGhlIGZ1dGV4X3EsIGRyb3AgdGhlIGhiIGxvY2ssIHdhaXQgZm9yIHdha2V1cC4g
Ki8NCiAJZnV0ZXhfd2FpdF9xdWV1ZV9tZShoYiwgJnEsIHRvKTsNCiANCmRpZmYgLS1naXQgYS9r
ZXJuZWwvaHJ0aW1lci5jIGIva2VybmVsL2hydGltZXIuYw0KaW5kZXggNjBmN2UzMi4uMjBlODhh
ZiAxMDA2NDQNCi0tLSBhL2tlcm5lbC9ocnRpbWVyLmMNCisrKyBiL2tlcm5lbC9ocnRpbWVyLmMN
CkBAIC0yMzIsNiArMjMyLDExIEBAIGFnYWluOg0KIAkJCWdvdG8gYWdhaW47DQogCQl9DQogCQl0
aW1lci0+YmFzZSA9IG5ld19iYXNlOw0KKwl9IGVsc2Ugew0KKwkJaWYgKGNwdSAhPSB0aGlzX2Nw
dSAmJiBocnRpbWVyX2NoZWNrX3RhcmdldCh0aW1lciwgbmV3X2Jhc2UpKSB7DQorCQkJY3B1ID0g
dGhpc19jcHU7DQorCQkJZ290byBhZ2FpbjsNCisJCX0NCiAJfQ0KIAlyZXR1cm4gbmV3X2Jhc2U7
DQogfQ0KQEAgLTU2Nyw2ICs1NzIsMjMgQEAgaHJ0aW1lcl9mb3JjZV9yZXByb2dyYW0oc3RydWN0
IGhydGltZXJfY3B1X2Jhc2UgKmNwdV9iYXNlLCBpbnQgc2tpcF9lcXVhbCkNCiANCiAJY3B1X2Jh
c2UtPmV4cGlyZXNfbmV4dC50djY0ID0gZXhwaXJlc19uZXh0LnR2NjQ7DQogDQorCS8qDQorCSAq
IElmIGEgaGFuZyB3YXMgZGV0ZWN0ZWQgaW4gdGhlIGxhc3QgdGltZXIgaW50ZXJydXB0IHRoZW4g
d2UNCisJICogbGVhdmUgdGhlIGhhbmcgZGVsYXkgYWN0aXZlIGluIHRoZSBoYXJkd2FyZS4gV2Ug
d2FudCB0aGUNCisJICogc3lzdGVtIHRvIG1ha2UgcHJvZ3Jlc3MuIFRoYXQgYWxzbyBwcmV2ZW50
cyB0aGUgZm9sbG93aW5nDQorCSAqIHNjZW5hcmlvOg0KKwkgKiBUMSBleHBpcmVzIDUwbXMgZnJv
bSBub3cNCisJICogVDIgZXhwaXJlcyA1cyBmcm9tIG5vdw0KKwkgKg0KKwkgKiBUMSBpcyByZW1v
dmVkLCBzbyB0aGlzIGNvZGUgaXMgY2FsbGVkIGFuZCB3b3VsZCByZXByb2dyYW0NCisJICogdGhl
IGhhcmR3YXJlIHRvIDVzIGZyb20gbm93LiBBbnkgaHJ0aW1lcl9zdGFydCBhZnRlciB0aGF0DQor
CSAqIHdpbGwgbm90IHJlcHJvZ3JhbSB0aGUgaGFyZHdhcmUgZHVlIHRvIGhhbmdfZGV0ZWN0ZWQg
YmVpbmcNCisJICogc2V0LiBTbyB3ZSdkIGVmZmVjdGl2bHkgYmxvY2sgYWxsIHRpbWVycyB1bnRp
bCB0aGUgVDIgZXZlbnQNCisJICogZmlyZXMuDQorCSAqLw0KKwlpZiAoY3B1X2Jhc2UtPmhhbmdf
ZGV0ZWN0ZWQpDQorCQlyZXR1cm47DQorDQogCWlmIChjcHVfYmFzZS0+ZXhwaXJlc19uZXh0LnR2
NjQgIT0gS1RJTUVfTUFYKQ0KIAkJdGlja19wcm9ncmFtX2V2ZW50KGNwdV9iYXNlLT5leHBpcmVz
X25leHQsIDEpOw0KIH0NCkBAIC05NTgsMTEgKzk4MCw4IEBAIGludCBfX2hydGltZXJfc3RhcnRf
cmFuZ2VfbnMoc3RydWN0IGhydGltZXIgKnRpbWVyLCBrdGltZV90IHRpbSwNCiAJLyogUmVtb3Zl
IGFuIGFjdGl2ZSB0aW1lciBmcm9tIHRoZSBxdWV1ZTogKi8NCiAJcmV0ID0gcmVtb3ZlX2hydGlt
ZXIodGltZXIsIGJhc2UpOw0KIA0KLQkvKiBTd2l0Y2ggdGhlIHRpbWVyIGJhc2UsIGlmIG5lY2Vz
c2FyeTogKi8NCi0JbmV3X2Jhc2UgPSBzd2l0Y2hfaHJ0aW1lcl9iYXNlKHRpbWVyLCBiYXNlLCBt
b2RlICYgSFJUSU1FUl9NT0RFX1BJTk5FRCk7DQotDQogCWlmIChtb2RlICYgSFJUSU1FUl9NT0RF
X1JFTCkgew0KLQkJdGltID0ga3RpbWVfYWRkX3NhZmUodGltLCBuZXdfYmFzZS0+Z2V0X3RpbWUo
KSk7DQorCQl0aW0gPSBrdGltZV9hZGRfc2FmZSh0aW0sIGJhc2UtPmdldF90aW1lKCkpOw0KIAkJ
LyoNCiAJCSAqIENPTkZJR19USU1FX0xPV19SRVMgaXMgYSB0ZW1wb3Jhcnkgd2F5IGZvciBhcmNo
aXRlY3R1cmVzDQogCQkgKiB0byBzaWduYWwgdGhhdCB0aGV5IHNpbXBseSByZXR1cm4geHRpbWUg
aW4NCkBAIC05NzcsNiArOTk2LDkgQEAgaW50IF9faHJ0aW1lcl9zdGFydF9yYW5nZV9ucyhzdHJ1
Y3QgaHJ0aW1lciAqdGltZXIsIGt0aW1lX3QgdGltLA0KIA0KIAlocnRpbWVyX3NldF9leHBpcmVz
X3JhbmdlX25zKHRpbWVyLCB0aW0sIGRlbHRhX25zKTsNCiANCisJLyogU3dpdGNoIHRoZSB0aW1l
ciBiYXNlLCBpZiBuZWNlc3Nhcnk6ICovDQorCW5ld19iYXNlID0gc3dpdGNoX2hydGltZXJfYmFz
ZSh0aW1lciwgYmFzZSwgbW9kZSAmIEhSVElNRVJfTU9ERV9QSU5ORUQpOw0KKw0KIAl0aW1lcl9z
dGF0c19ocnRpbWVyX3NldF9zdGFydF9pbmZvKHRpbWVyKTsNCiANCiAJbGVmdG1vc3QgPSBlbnF1
ZXVlX2hydGltZXIodGltZXIsIG5ld19iYXNlKTsNCmRpZmYgLS1naXQgYS9rZXJuZWwvbW9kdWxl
LmMgYi9rZXJuZWwvbW9kdWxlLmMNCmluZGV4IDY1MzYyZDkuLjk1ZWNkOWYgMTAwNjQ0DQotLS0g
YS9rZXJuZWwvbW9kdWxlLmMNCisrKyBiL2tlcm5lbC9tb2R1bGUuYw0KQEAgLTI4ODgsNiArMjg4
OCw5IEBAIHN0YXRpYyBzdHJ1Y3QgbW9kdWxlICpsb2FkX21vZHVsZSh2b2lkIF9fdXNlciAqdW1v
ZCwNCiAJLyogVGhpcyBoYXMgdG8gYmUgZG9uZSBvbmNlIHdlJ3JlIHN1cmUgbW9kdWxlIG5hbWUg
aXMgdW5pcXVlLiAqLw0KIAlkeW5hbWljX2RlYnVnX3NldHVwKGluZm8uZGVidWcsIGluZm8ubnVt
X2RlYnVnKTsNCiANCisJLyogRnRyYWNlIGluaXQgbXVzdCBiZSBjYWxsZWQgaW4gdGhlIE1PRFVM
RV9TVEFURV9VTkZPUk1FRCBzdGF0ZSAqLw0KKwlmdHJhY2VfbW9kdWxlX2luaXQobW9kKTsNCisN
CiAJLyogRmluZCBkdXBsaWNhdGUgc3ltYm9scyAqLw0KIAllcnIgPSB2ZXJpZnlfZXhwb3J0X3N5
bWJvbHMobW9kKTsNCiAJaWYgKGVyciA8IDApDQpkaWZmIC0tZ2l0IGEva2VybmVsL3NjaGVkX2Nw
dXByaS5jIGIva2VybmVsL3NjaGVkX2NwdXByaS5jDQppbmRleCBhODZjZjlkLi4xZjRhZmRkIDEw
MDY0NA0KLS0tIGEva2VybmVsL3NjaGVkX2NwdXByaS5jDQorKysgYi9rZXJuZWwvc2NoZWRfY3B1
cHJpLmMNCkBAIC02OCw4ICs2OCw3IEBAIGludCBjcHVwcmlfZmluZChzdHJ1Y3QgY3B1cHJpICpj
cCwgc3RydWN0IHRhc2tfc3RydWN0ICpwLA0KIAlpbnQgICAgICAgICAgICAgICAgICBpZHggICAg
ICA9IDA7DQogCWludCAgICAgICAgICAgICAgICAgIHRhc2tfcHJpID0gY29udmVydF9wcmlvKHAt
PnByaW8pOw0KIA0KLQlpZiAodGFza19wcmkgPj0gTUFYX1JUX1BSSU8pDQotCQlyZXR1cm4gMDsN
CisJQlVHX09OKHRhc2tfcHJpID49IENQVVBSSV9OUl9QUklPUklUSUVTKTsNCiANCiAJZm9yIChp
ZHggPSAwOyBpZHggPCB0YXNrX3ByaTsgaWR4KyspIHsNCiAJCXN0cnVjdCBjcHVwcmlfdmVjICp2
ZWMgID0gJmNwLT5wcmlfdG9fY3B1W2lkeF07DQpkaWZmIC0tZ2l0IGEva2VybmVsL3RpbWVyLmMg
Yi9rZXJuZWwvdGltZXIuYw0KaW5kZXggZjhiMDVhNC4uMzQ5OTUzZSAxMDA2NDQNCi0tLSBhL2tl
cm5lbC90aW1lci5jDQorKysgYi9rZXJuZWwvdGltZXIuYw0KQEAgLTc2OSw3ICs3NjksNyBAQCB1
bnNpZ25lZCBsb25nIGFwcGx5X3NsYWNrKHN0cnVjdCB0aW1lcl9saXN0ICp0aW1lciwgdW5zaWdu
ZWQgbG9uZyBleHBpcmVzKQ0KIA0KIAliaXQgPSBmaW5kX2xhc3RfYml0KCZtYXNrLCBCSVRTX1BF
Ul9MT05HKTsNCiANCi0JbWFzayA9ICgxIDw8IGJpdCkgLSAxOw0KKwltYXNrID0gKDFVTCA8PCBi
aXQpIC0gMTsNCiANCiAJZXhwaXJlc19saW1pdCA9IGV4cGlyZXNfbGltaXQgJiB+KG1hc2spOw0K
IA0KZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFjZS9mdHJhY2UuYyBiL2tlcm5lbC90cmFjZS9mdHJh
Y2UuYw0KaW5kZXggYTY1ZmEzNi4uZGNiYWZlZCAxMDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS9m
dHJhY2UuYw0KKysrIGIva2VybmVsL3RyYWNlL2Z0cmFjZS5jDQpAQCAtMzU0MiwxNiArMzU0Miwx
MSBAQCBzdGF0aWMgdm9pZCBmdHJhY2VfaW5pdF9tb2R1bGUoc3RydWN0IG1vZHVsZSAqbW9kLA0K
IAlmdHJhY2VfcHJvY2Vzc19sb2NzKG1vZCwgc3RhcnQsIGVuZCk7DQogfQ0KIA0KLXN0YXRpYyBp
bnQgZnRyYWNlX21vZHVsZV9ub3RpZnlfZW50ZXIoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpzZWxm
LA0KLQkJCQkgICAgICB1bnNpZ25lZCBsb25nIHZhbCwgdm9pZCAqZGF0YSkNCit2b2lkIGZ0cmFj
ZV9tb2R1bGVfaW5pdChzdHJ1Y3QgbW9kdWxlICptb2QpDQogew0KLQlzdHJ1Y3QgbW9kdWxlICpt
b2QgPSBkYXRhOw0KLQ0KLQlpZiAodmFsID09IE1PRFVMRV9TVEFURV9DT01JTkcpDQotCQlmdHJh
Y2VfaW5pdF9tb2R1bGUobW9kLCBtb2QtPmZ0cmFjZV9jYWxsc2l0ZXMsDQotCQkJCSAgIG1vZC0+
ZnRyYWNlX2NhbGxzaXRlcyArDQotCQkJCSAgIG1vZC0+bnVtX2Z0cmFjZV9jYWxsc2l0ZXMpOw0K
LQlyZXR1cm4gMDsNCisJZnRyYWNlX2luaXRfbW9kdWxlKG1vZCwgbW9kLT5mdHJhY2VfY2FsbHNp
dGVzLA0KKwkJCSAgIG1vZC0+ZnRyYWNlX2NhbGxzaXRlcyArDQorCQkJICAgbW9kLT5udW1fZnRy
YWNlX2NhbGxzaXRlcyk7DQogfQ0KIA0KIHN0YXRpYyBpbnQgZnRyYWNlX21vZHVsZV9ub3RpZnlf
ZXhpdChzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKnNlbGYsDQpAQCAtMzU2NSwxMSArMzU2MCw2IEBA
IHN0YXRpYyBpbnQgZnRyYWNlX21vZHVsZV9ub3RpZnlfZXhpdChzdHJ1Y3Qgbm90aWZpZXJfYmxv
Y2sgKnNlbGYsDQogCXJldHVybiAwOw0KIH0NCiAjZWxzZQ0KLXN0YXRpYyBpbnQgZnRyYWNlX21v
ZHVsZV9ub3RpZnlfZW50ZXIoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpzZWxmLA0KLQkJCQkgICAg
ICB1bnNpZ25lZCBsb25nIHZhbCwgdm9pZCAqZGF0YSkNCi17DQotCXJldHVybiAwOw0KLX0NCiBz
dGF0aWMgaW50IGZ0cmFjZV9tb2R1bGVfbm90aWZ5X2V4aXQoc3RydWN0IG5vdGlmaWVyX2Jsb2Nr
ICpzZWxmLA0KIAkJCQkgICAgIHVuc2lnbmVkIGxvbmcgdmFsLCB2b2lkICpkYXRhKQ0KIHsNCkBA
IC0zNTc3LDExICszNTY3LDYgQEAgc3RhdGljIGludCBmdHJhY2VfbW9kdWxlX25vdGlmeV9leGl0
KHN0cnVjdCBub3RpZmllcl9ibG9jayAqc2VsZiwNCiB9DQogI2VuZGlmIC8qIENPTkZJR19NT0RV
TEVTICovDQogDQotc3RydWN0IG5vdGlmaWVyX2Jsb2NrIGZ0cmFjZV9tb2R1bGVfZW50ZXJfbmIg
PSB7DQotCS5ub3RpZmllcl9jYWxsID0gZnRyYWNlX21vZHVsZV9ub3RpZnlfZW50ZXIsDQotCS5w
cmlvcml0eSA9IElOVF9NQVgsCS8qIFJ1biBiZWZvcmUgYW55dGhpbmcgdGhhdCBjYW4gdXNlIGtw
cm9iZXMgKi8NCi19Ow0KLQ0KIHN0cnVjdCBub3RpZmllcl9ibG9jayBmdHJhY2VfbW9kdWxlX2V4
aXRfbmIgPSB7DQogCS5ub3RpZmllcl9jYWxsID0gZnRyYWNlX21vZHVsZV9ub3RpZnlfZXhpdCwN
CiAJLnByaW9yaXR5ID0gSU5UX01JTiwJLyogUnVuIGFmdGVyIGFueXRoaW5nIHRoYXQgY2FuIHJl
bW92ZSBrcHJvYmVzICovDQpAQCAtMzYxOCwxMCArMzYwMyw2IEBAIHZvaWQgX19pbml0IGZ0cmFj
ZV9pbml0KHZvaWQpDQogCQkJCSAgX19zdGFydF9tY291bnRfbG9jLA0KIAkJCQkgIF9fc3RvcF9t
Y291bnRfbG9jKTsNCiANCi0JcmV0ID0gcmVnaXN0ZXJfbW9kdWxlX25vdGlmaWVyKCZmdHJhY2Vf
bW9kdWxlX2VudGVyX25iKTsNCi0JaWYgKHJldCkNCi0JCXByX3dhcm5pbmcoIkZhaWxlZCB0byBy
ZWdpc3RlciB0cmFjZSBmdHJhY2UgbW9kdWxlIGVudGVyIG5vdGlmaWVyXG4iKTsNCi0NCiAJcmV0
ID0gcmVnaXN0ZXJfbW9kdWxlX25vdGlmaWVyKCZmdHJhY2VfbW9kdWxlX2V4aXRfbmIpOw0KIAlp
ZiAocmV0KQ0KIAkJcHJfd2FybmluZygiRmFpbGVkIHRvIHJlZ2lzdGVyIHRyYWNlIGZ0cmFjZSBt
b2R1bGUgZXhpdCBub3RpZmllclxuIik7DQpkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlcG9pbnQu
YyBiL2tlcm5lbC90cmFjZXBvaW50LmMNCmluZGV4IDQxYjI1YTAuLjA4OGZiYzUgMTAwNjQ0DQot
LS0gYS9rZXJuZWwvdHJhY2Vwb2ludC5jDQorKysgYi9rZXJuZWwvdHJhY2Vwb2ludC5jDQpAQCAt
NjM4LDYgKzYzOCw5IEBAIHN0YXRpYyBpbnQgdHJhY2Vwb2ludF9tb2R1bGVfY29taW5nKHN0cnVj
dCBtb2R1bGUgKm1vZCkNCiAJc3RydWN0IHRwX21vZHVsZSAqdHBfbW9kLCAqaXRlcjsNCiAJaW50
IHJldCA9IDA7DQogDQorCWlmICghbW9kLT5udW1fdHJhY2Vwb2ludHMpDQorCQlyZXR1cm4gMDsN
CisNCiAJLyoNCiAJICogV2Ugc2tpcCBtb2R1bGVzIHRoYXQgdGFpbnQgdGhlIGtlcm5lbCwgZXNw
ZWNpYWxseSB0aG9zZSB3aXRoIGRpZmZlcmVudA0KIAkgKiBtb2R1bGUgaGVhZGVycyAoZm9yIGZv
cmNlZCBsb2FkKSwgdG8gbWFrZSBzdXJlIHdlIGRvbid0IGNhdXNlIGEgY3Jhc2guDQpAQCAtNjgx
LDYgKzY4NCw5IEBAIHN0YXRpYyBpbnQgdHJhY2Vwb2ludF9tb2R1bGVfZ29pbmcoc3RydWN0IG1v
ZHVsZSAqbW9kKQ0KIHsNCiAJc3RydWN0IHRwX21vZHVsZSAqcG9zOw0KIA0KKwlpZiAoIW1vZC0+
bnVtX3RyYWNlcG9pbnRzKQ0KKwkJcmV0dXJuIDA7DQorDQogCW11dGV4X2xvY2soJnRyYWNlcG9p
bnRzX211dGV4KTsNCiAJdHJhY2Vwb2ludF91cGRhdGVfcHJvYmVfcmFuZ2UobW9kLT50cmFjZXBv
aW50c19wdHJzLA0KIAkJbW9kLT50cmFjZXBvaW50c19wdHJzICsgbW9kLT5udW1fdHJhY2Vwb2lu
dHMpOw0KZGlmZiAtLWdpdCBhL21tL21lbW9yeS1mYWlsdXJlLmMgYi9tbS9tZW1vcnktZmFpbHVy
ZS5jDQppbmRleCA5NmM0YmNmLi41MTkwMWIxIDEwMDY0NA0KLS0tIGEvbW0vbWVtb3J5LWZhaWx1
cmUuYw0KKysrIGIvbW0vbWVtb3J5LWZhaWx1cmUuYw0KQEAgLTEwMzMsMTUgKzEwMzMsMTYgQEAg
aW50IF9fbWVtb3J5X2ZhaWx1cmUodW5zaWduZWQgbG9uZyBwZm4sIGludCB0cmFwbm8sIGludCBm
bGFncykNCiAJCQlyZXR1cm4gMDsNCiAJCX0gZWxzZSBpZiAoUGFnZUh1Z2UoaHBhZ2UpKSB7DQog
CQkJLyoNCi0JCQkgKiBDaGVjayAianVzdCB1bnBvaXNvbmVkIiwgImZpbHRlciBoaXQiLCBhbmQN
Ci0JCQkgKiAicmFjZSB3aXRoIG90aGVyIHN1YnBhZ2UuIg0KKwkJCSAqIENoZWNrICJmaWx0ZXIg
aGl0IiBhbmQgInJhY2Ugd2l0aCBvdGhlciBzdWJwYWdlLiINCiAJCQkgKi8NCiAJCQlsb2NrX3Bh
Z2UoaHBhZ2UpOw0KLQkJCWlmICghUGFnZUhXUG9pc29uKGhwYWdlKQ0KLQkJCSAgICB8fCAoaHdw
b2lzb25fZmlsdGVyKHApICYmIFRlc3RDbGVhclBhZ2VIV1BvaXNvbihwKSkNCi0JCQkgICAgfHwg
KHAgIT0gaHBhZ2UgJiYgVGVzdFNldFBhZ2VIV1BvaXNvbihocGFnZSkpKSB7DQotCQkJCWF0b21p
Y19sb25nX3N1Yihucl9wYWdlcywgJm1jZV9iYWRfcGFnZXMpOw0KLQkJCQlyZXR1cm4gMDsNCisJ
CQlpZiAoUGFnZUhXUG9pc29uKGhwYWdlKSkgew0KKwkJCQlpZiAoKGh3cG9pc29uX2ZpbHRlcihw
KSAmJiBUZXN0Q2xlYXJQYWdlSFdQb2lzb24ocCkpDQorCQkJCSAgICB8fCAocCAhPSBocGFnZSAm
JiBUZXN0U2V0UGFnZUhXUG9pc29uKGhwYWdlKSkpIHsNCisJCQkJCWF0b21pY19sb25nX3N1Yihu
cl9wYWdlcywgJm1jZV9iYWRfcGFnZXMpOw0KKwkJCQkJdW5sb2NrX3BhZ2UoaHBhZ2UpOw0KKwkJ
CQkJcmV0dXJuIDA7DQorCQkJCX0NCiAJCQl9DQogCQkJc2V0X3BhZ2VfaHdwb2lzb25faHVnZV9w
YWdlKGhwYWdlKTsNCiAJCQlyZXMgPSBkZXF1ZXVlX2h3cG9pc29uZWRfaHVnZV9wYWdlKGhwYWdl
KTsNCkBAIC0xMDkzLDYgKzEwOTQsOCBAQCBpbnQgX19tZW1vcnlfZmFpbHVyZSh1bnNpZ25lZCBs
b25nIHBmbiwgaW50IHRyYXBubywgaW50IGZsYWdzKQ0KIAkgKi8NCiAJaWYgKCFQYWdlSFdQb2lz
b24ocCkpIHsNCiAJCXByaW50ayhLRVJOX0VSUiAiTUNFICUjbHg6IGp1c3QgdW5wb2lzb25lZFxu
IiwgcGZuKTsNCisJCWF0b21pY19sb25nX3N1Yihucl9wYWdlcywgJm1jZV9iYWRfcGFnZXMpOw0K
KwkJcHV0X3BhZ2UoaHBhZ2UpOw0KIAkJcmVzID0gMDsNCiAJCWdvdG8gb3V0Ow0KIAl9DQpkaWZm
IC0tZ2l0IGEvbW0vcGFnZS13cml0ZWJhY2suYyBiL21tL3BhZ2Utd3JpdGViYWNrLmMNCmluZGV4
IGI1Y2Q3OTYuLmQyYWMwNTcgMTAwNjQ0DQotLS0gYS9tbS9wYWdlLXdyaXRlYmFjay5jDQorKysg
Yi9tbS9wYWdlLXdyaXRlYmFjay5jDQpAQCAtNTU5LDcgKzU1OSw3IEBAIHN0YXRpYyB1bnNpZ25l
ZCBsb25nIGJkaV9wb3NpdGlvbl9yYXRpbyhzdHJ1Y3QgYmFja2luZ19kZXZfaW5mbyAqYmRpLA0K
IAkgKiAgICAgPT4gZmFzdCByZXNwb25zZSBvbiBsYXJnZSBlcnJvcnM7IHNtYWxsIG9zY2lsbGF0
aW9uIG5lYXIgc2V0cG9pbnQNCiAJICovDQogCXNldHBvaW50ID0gKGZyZWVydW4gKyBsaW1pdCkg
LyAyOw0KLQl4ID0gZGl2X3M2NCgoc2V0cG9pbnQgLSBkaXJ0eSkgPDwgUkFURUxJTUlUX0NBTENf
U0hJRlQsDQorCXggPSBkaXY2NF9zNjQoKChzNjQpc2V0cG9pbnQgLSAoczY0KWRpcnR5KSA8PCBS
QVRFTElNSVRfQ0FMQ19TSElGVCwNCiAJCSAgICBsaW1pdCAtIHNldHBvaW50ICsgMSk7DQogCXBv
c19yYXRpbyA9IHg7DQogCXBvc19yYXRpbyA9IHBvc19yYXRpbyAqIHggPj4gUkFURUxJTUlUX0NB
TENfU0hJRlQ7DQpAQCAtNjI1LDcgKzYyNSw3IEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nIGJkaV9w
b3NpdGlvbl9yYXRpbyhzdHJ1Y3QgYmFja2luZ19kZXZfaW5mbyAqYmRpLA0KIAl4X2ludGVyY2Vw
dCA9IGJkaV9zZXRwb2ludCArIHNwYW47DQogDQogCWlmIChiZGlfZGlydHkgPCB4X2ludGVyY2Vw
dCAtIHNwYW4gLyA0KSB7DQotCQlwb3NfcmF0aW8gPSBkaXZfdTY0KHBvc19yYXRpbyAqICh4X2lu
dGVyY2VwdCAtIGJkaV9kaXJ0eSksDQorCQlwb3NfcmF0aW8gPSBkaXY2NF91NjQocG9zX3JhdGlv
ICogKHhfaW50ZXJjZXB0IC0gYmRpX2RpcnR5KSwNCiAJCQkJICAgIHhfaW50ZXJjZXB0IC0gYmRp
X3NldHBvaW50ICsgMSk7DQogCX0gZWxzZQ0KIAkJcG9zX3JhdGlvIC89IDQ7DQpkaWZmIC0tZ2l0
IGEvbmV0L2JsdWV0b290aC9oY2lfY29ubi5jIGIvbmV0L2JsdWV0b290aC9oY2lfY29ubi5jDQpp
bmRleCBhYTEyNjQ5Li40ZDk5ZDQyIDEwMDY0NA0KLS0tIGEvbmV0L2JsdWV0b290aC9oY2lfY29u
bi5jDQorKysgYi9uZXQvYmx1ZXRvb3RoL2hjaV9jb25uLmMNCkBAIC02MTAsMTQgKzYxMCwxNyBA
QCBzdGF0aWMgaW50IGhjaV9jb25uX2F1dGgoc3RydWN0IGhjaV9jb25uICpjb25uLCBfX3U4IHNl
Y19sZXZlbCwgX191OCBhdXRoX3R5cGUpDQogCWlmICghdGVzdF9hbmRfc2V0X2JpdChIQ0lfQ09O
Tl9BVVRIX1BFTkQsICZjb25uLT5wZW5kKSkgew0KIAkJc3RydWN0IGhjaV9jcF9hdXRoX3JlcXVl
c3RlZCBjcDsNCiANCi0JCS8qIGVuY3J5cHQgbXVzdCBiZSBwZW5kaW5nIGlmIGF1dGggaXMgYWxz
byBwZW5kaW5nICovDQotCQlzZXRfYml0KEhDSV9DT05OX0VOQ1JZUFRfUEVORCwgJmNvbm4tPnBl
bmQpOw0KLQ0KIAkJY3AuaGFuZGxlID0gY3B1X3RvX2xlMTYoY29ubi0+aGFuZGxlKTsNCiAJCWhj
aV9zZW5kX2NtZChjb25uLT5oZGV2LCBIQ0lfT1BfQVVUSF9SRVFVRVNURUQsDQogCQkJCQkJCXNp
emVvZihjcCksICZjcCk7DQorDQorCQkvKiBJZiB3ZSdyZSBhbHJlYWR5IGVuY3J5cHRlZCBzZXQg
dGhlIFJFQVVUSF9QRU5EIGZsYWcsDQorCQkgKiBvdGhlcndpc2Ugc2V0IHRoZSBFTkNSWVBUX1BF
TkQuDQorCQkgKi8NCiAJCWlmIChjb25uLT5rZXlfdHlwZSAhPSAweGZmKQ0KIAkJCXNldF9iaXQo
SENJX0NPTk5fUkVBVVRIX1BFTkQsICZjb25uLT5wZW5kKTsNCisJCWVsc2UNCisJCQlzZXRfYml0
KEhDSV9DT05OX0VOQ1JZUFRfUEVORCwgJmNvbm4tPnBlbmQpOw0KIAl9DQogDQogCXJldHVybiAw
Ow0KZGlmZiAtLWdpdCBhL25ldC9icmlkZ2UvYnJfbmV0bGluay5jIGIvbmV0L2JyaWRnZS9icl9u
ZXRsaW5rLmMNCmluZGV4IGNiZjljY2QuLjk5YTQ4YTMgMTAwNjQ0DQotLS0gYS9uZXQvYnJpZGdl
L2JyX25ldGxpbmsuYw0KKysrIGIvbmV0L2JyaWRnZS9icl9uZXRsaW5rLmMNCkBAIC0yMTEsMTEg
KzIxMSwyNiBAQCBzdGF0aWMgaW50IGJyX3ZhbGlkYXRlKHN0cnVjdCBubGF0dHIgKnRiW10sIHN0
cnVjdCBubGF0dHIgKmRhdGFbXSkNCiAJcmV0dXJuIDA7DQogfQ0KIA0KK3N0YXRpYyBpbnQgYnJf
ZGV2X25ld2xpbmsoc3RydWN0IG5ldCAqc3JjX25ldCwgc3RydWN0IG5ldF9kZXZpY2UgKmRldiwN
CisJCQkgIHN0cnVjdCBubGF0dHIgKnRiW10sIHN0cnVjdCBubGF0dHIgKmRhdGFbXSkNCit7DQor
CXN0cnVjdCBuZXRfYnJpZGdlICpiciA9IG5ldGRldl9wcml2KGRldik7DQorDQorCWlmICh0YltJ
RkxBX0FERFJFU1NdKSB7DQorCQlzcGluX2xvY2tfYmgoJmJyLT5sb2NrKTsNCisJCWJyX3N0cF9j
aGFuZ2VfYnJpZGdlX2lkKGJyLCBubGFfZGF0YSh0YltJRkxBX0FERFJFU1NdKSk7DQorCQlzcGlu
X3VubG9ja19iaCgmYnItPmxvY2spOw0KKwl9DQorDQorCXJldHVybiByZWdpc3Rlcl9uZXRkZXZp
Y2UoZGV2KTsNCit9DQorDQogc3RydWN0IHJ0bmxfbGlua19vcHMgYnJfbGlua19vcHMgX19yZWFk
X21vc3RseSA9IHsNCiAJLmtpbmQJCT0gImJyaWRnZSIsDQogCS5wcml2X3NpemUJPSBzaXplb2Yo
c3RydWN0IG5ldF9icmlkZ2UpLA0KIAkuc2V0dXAJCT0gYnJfZGV2X3NldHVwLA0KIAkudmFsaWRh
dGUJPSBicl92YWxpZGF0ZSwNCisJLm5ld2xpbmsJPSBicl9kZXZfbmV3bGluaywNCiAJLmRlbGxp
bmsJPSBicl9kZXZfZGVsZXRlLA0KIH07DQogDQpkaWZmIC0tZ2l0IGEvbmV0L2JyaWRnZS9uZXRm
aWx0ZXIvZWJ0YWJsZXMuYyBiL25ldC9icmlkZ2UvbmV0ZmlsdGVyL2VidGFibGVzLmMNCmluZGV4
IDU4NjRjYzQuLjQ1ZjkzZjggMTAwNjQ0DQotLS0gYS9uZXQvYnJpZGdlL25ldGZpbHRlci9lYnRh
Ymxlcy5jDQorKysgYi9uZXQvYnJpZGdlL25ldGZpbHRlci9lYnRhYmxlcy5jDQpAQCAtMTA0NCwx
MCArMTA0NCw5IEBAIHN0YXRpYyBpbnQgZG9fcmVwbGFjZV9maW5pc2goc3RydWN0IG5ldCAqbmV0
LCBzdHJ1Y3QgZWJ0X3JlcGxhY2UgKnJlcGwsDQogCWlmIChyZXBsLT5udW1fY291bnRlcnMgJiYN
CiAJICAgY29weV90b191c2VyKHJlcGwtPmNvdW50ZXJzLCBjb3VudGVyc3RtcCwNCiAJICAgcmVw
bC0+bnVtX2NvdW50ZXJzICogc2l6ZW9mKHN0cnVjdCBlYnRfY291bnRlcikpKSB7DQotCQlyZXQg
PSAtRUZBVUxUOw0KKwkJLyogU2lsZW50IGVycm9yLCBjYW4ndCBmYWlsLCBuZXcgdGFibGUgaXMg
YWxyZWFkeSBpbiBwbGFjZSAqLw0KKwkJbmV0X3dhcm5fcmF0ZWxpbWl0ZWQoImVidGFibGVzOiBj
b3VudGVycyBjb3B5IHRvIHVzZXIgZmFpbGVkIHdoaWxlIHJlcGxhY2luZyB0YWJsZVxuIik7DQog
CX0NCi0JZWxzZQ0KLQkJcmV0ID0gMDsNCiANCiAJLyogZGVjcmVhc2UgbW9kdWxlIGNvdW50IGFu
ZCBmcmVlIHJlc291cmNlcyAqLw0KIAlFQlRfRU5UUllfSVRFUkFURSh0YWJsZS0+ZW50cmllcywg
dGFibGUtPmVudHJpZXNfc2l6ZSwNCmRpZmYgLS1naXQgYS9uZXQvY2VwaC9tZXNzZW5nZXIuYyBi
L25ldC9jZXBoL21lc3Nlbmdlci5jDQppbmRleCBhZDViNzA4Li4yMGJhMmQ1IDEwMDY0NA0KLS0t
IGEvbmV0L2NlcGgvbWVzc2VuZ2VyLmMNCisrKyBiL25ldC9jZXBoL21lc3Nlbmdlci5jDQpAQCAt
Mjg0LDYgKzI4NCwzNyBAQCBzdGF0aWMgaW50IGNlcGhfdGNwX3NlbmRtc2coc3RydWN0IHNvY2tl
dCAqc29jaywgc3RydWN0IGt2ZWMgKmlvdiwNCiAJcmV0dXJuIHI7DQogfQ0KIA0KK3N0YXRpYyBp
bnQgX19jZXBoX3RjcF9zZW5kcGFnZShzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3QgcGFnZSAq
cGFnZSwNCisJCSAgICAgaW50IG9mZnNldCwgc2l6ZV90IHNpemUsIGJvb2wgbW9yZSkNCit7DQor
CWludCBmbGFncyA9IE1TR19ET05UV0FJVCB8IE1TR19OT1NJR05BTCB8IChtb3JlID8gTVNHX01P
UkUgOiBNU0dfRU9SKTsNCisJaW50IHJldDsNCisNCisJcmV0ID0ga2VybmVsX3NlbmRwYWdlKHNv
Y2ssIHBhZ2UsIG9mZnNldCwgc2l6ZSwgZmxhZ3MpOw0KKwlpZiAocmV0ID09IC1FQUdBSU4pDQor
CQlyZXQgPSAwOw0KKw0KKwlyZXR1cm4gcmV0Ow0KK30NCisNCitzdGF0aWMgaW50IGNlcGhfdGNw
X3NlbmRwYWdlKHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBwYWdlICpwYWdlLA0KKwkJICAg
ICBpbnQgb2Zmc2V0LCBzaXplX3Qgc2l6ZSwgYm9vbCBtb3JlKQ0KK3sNCisJaW50IHJldDsNCisJ
c3RydWN0IGt2ZWMgaW92Ow0KKw0KKwkvKiBzZW5kcGFnZSBjYW5ub3QgcHJvcGVybHkgaGFuZGxl
IHBhZ2VzIHdpdGggcGFnZV9jb3VudCA9PSAwLA0KKwkgKiB3ZSBuZWVkIHRvIGZhbGxiYWNrIHRv
IHNlbmRtc2cgaWYgdGhhdCdzIHRoZSBjYXNlICovDQorCWlmIChwYWdlX2NvdW50KHBhZ2UpID49
IDEpDQorCQlyZXR1cm4gX19jZXBoX3RjcF9zZW5kcGFnZShzb2NrLCBwYWdlLCBvZmZzZXQsIHNp
emUsIG1vcmUpOw0KKw0KKwlpb3YuaW92X2Jhc2UgPSBrbWFwKHBhZ2UpICsgb2Zmc2V0Ow0KKwlp
b3YuaW92X2xlbiA9IHNpemU7DQorCXJldCA9IGNlcGhfdGNwX3NlbmRtc2coc29jaywgJmlvdiwg
MSwgc2l6ZSwgbW9yZSk7DQorCWt1bm1hcChwYWdlKTsNCisNCisJcmV0dXJuIHJldDsNCit9DQog
DQogLyoNCiAgKiBTaHV0ZG93bi9jbG9zZSB0aGUgc29ja2V0IGZvciB0aGUgZ2l2ZW4gY29ubmVj
dGlvbi4NCkBAIC04NTEsMTggKzg4MiwxNCBAQCBzdGF0aWMgaW50IHdyaXRlX3BhcnRpYWxfbXNn
X3BhZ2VzKHN0cnVjdCBjZXBoX2Nvbm5lY3Rpb24gKmNvbikNCiAJCQkJY3B1X3RvX2xlMzIoY3Jj
MzJjKHRtcGNyYywgYmFzZSwgbGVuKSk7DQogCQkJY29uLT5vdXRfbXNnX3Bvcy5kaWRfcGFnZV9j
cmMgPSAxOw0KIAkJfQ0KLQkJcmV0ID0ga2VybmVsX3NlbmRwYWdlKGNvbi0+c29jaywgcGFnZSwN
CisJCXJldCA9IGNlcGhfdGNwX3NlbmRwYWdlKGNvbi0+c29jaywgcGFnZSwNCiAJCQkJICAgICAg
Y29uLT5vdXRfbXNnX3Bvcy5wYWdlX3BvcyArIHBhZ2Vfc2hpZnQsDQotCQkJCSAgICAgIGxlbiwN
Ci0JCQkJICAgICAgTVNHX0RPTlRXQUlUIHwgTVNHX05PU0lHTkFMIHwNCi0JCQkJICAgICAgTVNH
X01PUkUpOw0KKwkJCQkgICAgICBsZW4sIDEpOw0KIA0KIAkJaWYgKGNyYyAmJg0KIAkJICAgICht
c2ctPnBhZ2VzIHx8IG1zZy0+cGFnZWxpc3QgfHwgbXNnLT5iaW8gfHwgaW5fdHJhaWwpKQ0KIAkJ
CWt1bm1hcChwYWdlKTsNCiANCi0JCWlmIChyZXQgPT0gLUVBR0FJTikNCi0JCQlyZXQgPSAwOw0K
IAkJaWYgKHJldCA8PSAwKQ0KIAkJCWdvdG8gb3V0Ow0KIA0KZGlmZiAtLWdpdCBhL25ldC9jb3Jl
L2Rldi5jIGIvbmV0L2NvcmUvZGV2LmMNCmluZGV4IDdiY2YzN2QuLjg1NGRhMTUgMTAwNjQ0DQot
LS0gYS9uZXQvY29yZS9kZXYuYw0KKysrIGIvbmV0L2NvcmUvZGV2LmMNCkBAIC0zNjQ4LDYgKzM2
NDgsNyBAQCBzdGF0aWMgdm9pZCBuYXBpX3JldXNlX3NrYihzdHJ1Y3QgbmFwaV9zdHJ1Y3QgKm5h
cGksIHN0cnVjdCBza19idWZmICpza2IpDQogCXNrYi0+dmxhbl90Y2kgPSAwOw0KIAlza2ItPmRl
diA9IG5hcGktPmRldjsNCiAJc2tiLT5za2JfaWlmID0gMDsNCisJc2tiLT50cnVlc2l6ZSA9IFNL
Ql9UUlVFU0laRShza2JfZW5kX29mZnNldChza2IpKTsNCiANCiAJbmFwaS0+c2tiID0gc2tiOw0K
IH0NCmRpZmYgLS1naXQgYS9uZXQvY29yZS9maWx0ZXIuYyBiL25ldC9jb3JlL2ZpbHRlci5jDQpp
bmRleCA1ZGVhNDUyLi45Yzg4MDgwIDEwMDY0NA0KLS0tIGEvbmV0L2NvcmUvZmlsdGVyLmMNCisr
KyBiL25ldC9jb3JlL2ZpbHRlci5jDQpAQCAtMzIwLDYgKzMyMCw4IEBAIGxvYWRfYjoNCiANCiAJ
CQlpZiAoc2tiX2lzX25vbmxpbmVhcihza2IpKQ0KIAkJCQlyZXR1cm4gMDsNCisJCQlpZiAoc2ti
LT5sZW4gPCBzaXplb2Yoc3RydWN0IG5sYXR0cikpDQorCQkJCXJldHVybiAwOw0KIAkJCWlmIChB
ID4gc2tiLT5sZW4gLSBzaXplb2Yoc3RydWN0IG5sYXR0cikpDQogCQkJCXJldHVybiAwOw0KIA0K
QEAgLTMzNiwxMSArMzM4LDEzIEBAIGxvYWRfYjoNCiANCiAJCQlpZiAoc2tiX2lzX25vbmxpbmVh
cihza2IpKQ0KIAkJCQlyZXR1cm4gMDsNCisJCQlpZiAoc2tiLT5sZW4gPCBzaXplb2Yoc3RydWN0
IG5sYXR0cikpDQorCQkJCXJldHVybiAwOw0KIAkJCWlmIChBID4gc2tiLT5sZW4gLSBzaXplb2Yo
c3RydWN0IG5sYXR0cikpDQogCQkJCXJldHVybiAwOw0KIA0KIAkJCW5sYSA9IChzdHJ1Y3Qgbmxh
dHRyICopJnNrYi0+ZGF0YVtBXTsNCi0JCQlpZiAobmxhLT5ubGFfbGVuID4gQSAtIHNrYi0+bGVu
KQ0KKwkJCWlmIChubGEtPm5sYV9sZW4gPiBza2ItPmxlbiAtIEEpDQogCQkJCXJldHVybiAwOw0K
IA0KIAkJCW5sYSA9IG5sYV9maW5kX25lc3RlZChubGEsIFgpOw0KZGlmZiAtLWdpdCBhL25ldC9j
b3JlL3J0bmV0bGluay5jIGIvbmV0L2NvcmUvcnRuZXRsaW5rLmMNCmluZGV4IDViN2Q1ZjIuLjdi
ZWFmMTAgMTAwNjQ0DQotLS0gYS9uZXQvY29yZS9ydG5ldGxpbmsuYw0KKysrIGIvbmV0L2NvcmUv
cnRuZXRsaW5rLmMNCkBAIC03NDQsNyArNzQ0LDggQEAgc3RhdGljIGlubGluZSBpbnQgcnRubF92
ZmluZm9fc2l6ZShjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KIAkJcmV0dXJuIDA7DQog
fQ0KIA0KLXN0YXRpYyBzaXplX3QgcnRubF9wb3J0X3NpemUoY29uc3Qgc3RydWN0IG5ldF9kZXZp
Y2UgKmRldikNCitzdGF0aWMgc2l6ZV90IHJ0bmxfcG9ydF9zaXplKGNvbnN0IHN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYsDQorCQkJICAgICB1MzIgZXh0X2ZpbHRlcl9tYXNrKQ0KIHsNCiAJc2l6ZV90
IHBvcnRfc2l6ZSA9IG5sYV90b3RhbF9zaXplKDQpCQkvKiBQT1JUX1ZGICovDQogCQkrIG5sYV90
b3RhbF9zaXplKFBPUlRfUFJPRklMRV9NQVgpCS8qIFBPUlRfUFJPRklMRSAqLw0KQEAgLTc2MCw3
ICs3NjEsOCBAQCBzdGF0aWMgc2l6ZV90IHJ0bmxfcG9ydF9zaXplKGNvbnN0IHN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYpDQogCXNpemVfdCBwb3J0X3NlbGZfc2l6ZSA9IG5sYV90b3RhbF9zaXplKHNp
emVvZihzdHJ1Y3QgbmxhdHRyKSkNCiAJCSsgcG9ydF9zaXplOw0KIA0KLQlpZiAoIWRldi0+bmV0
ZGV2X29wcy0+bmRvX2dldF92Zl9wb3J0IHx8ICFkZXYtPmRldi5wYXJlbnQpDQorCWlmICghZGV2
LT5uZXRkZXZfb3BzLT5uZG9fZ2V0X3ZmX3BvcnQgfHwgIWRldi0+ZGV2LnBhcmVudCB8fA0KKwkg
ICAgIShleHRfZmlsdGVyX21hc2sgJiBSVEVYVF9GSUxURVJfVkYpKQ0KIAkJcmV0dXJuIDA7DQog
CWlmIChkZXZfbnVtX3ZmKGRldi0+ZGV2LnBhcmVudCkpDQogCQlyZXR1cm4gcG9ydF9zZWxmX3Np
emUgKyB2Zl9wb3J0c19zaXplICsNCkBAIC03OTEsNyArNzkzLDcgQEAgc3RhdGljIG5vaW5saW5l
IHNpemVfdCBpZl9ubG1zZ19zaXplKGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQogCSAg
ICAgICArIG5sYV90b3RhbF9zaXplKGV4dF9maWx0ZXJfbWFzaw0KIAkJCSAgICAgICAgJiBSVEVY
VF9GSUxURVJfVkYgPyA0IDogMCkgLyogSUZMQV9OVU1fVkYgKi8NCiAJICAgICAgICsgcnRubF92
ZmluZm9fc2l6ZShkZXYsIGV4dF9maWx0ZXJfbWFzaykgLyogSUZMQV9WRklORk9fTElTVCAqLw0K
LQkgICAgICAgKyBydG5sX3BvcnRfc2l6ZShkZXYpIC8qIElGTEFfVkZfUE9SVFMgKyBJRkxBX1BP
UlRfU0VMRiAqLw0KKwkgICAgICAgKyBydG5sX3BvcnRfc2l6ZShkZXYsIGV4dF9maWx0ZXJfbWFz
aykgLyogSUZMQV9WRl9QT1JUUyArIElGTEFfUE9SVF9TRUxGICovDQogCSAgICAgICArIHJ0bmxf
bGlua19nZXRfc2l6ZShkZXYpIC8qIElGTEFfTElOS0lORk8gKi8NCiAJICAgICAgICsgcnRubF9s
aW5rX2dldF9hZl9zaXplKGRldik7IC8qIElGTEFfQUZfU1BFQyAqLw0KIH0NCkBAIC04NTEsMTEg
Kzg1MywxMyBAQCBzdGF0aWMgaW50IHJ0bmxfcG9ydF9zZWxmX2ZpbGwoc3RydWN0IHNrX2J1ZmYg
KnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCiAJcmV0dXJuIDA7DQogfQ0KIA0KLXN0YXRp
YyBpbnQgcnRubF9wb3J0X2ZpbGwoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZp
Y2UgKmRldikNCitzdGF0aWMgaW50IHJ0bmxfcG9ydF9maWxsKHN0cnVjdCBza19idWZmICpza2Is
IHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQorCQkJICB1MzIgZXh0X2ZpbHRlcl9tYXNrKQ0KIHsN
CiAJaW50IGVycjsNCiANCi0JaWYgKCFkZXYtPm5ldGRldl9vcHMtPm5kb19nZXRfdmZfcG9ydCB8
fCAhZGV2LT5kZXYucGFyZW50KQ0KKwlpZiAoIWRldi0+bmV0ZGV2X29wcy0+bmRvX2dldF92Zl9w
b3J0IHx8ICFkZXYtPmRldi5wYXJlbnQgfHwNCisJICAgICEoZXh0X2ZpbHRlcl9tYXNrICYgUlRF
WFRfRklMVEVSX1ZGKSkNCiAJCXJldHVybiAwOw0KIA0KIAllcnIgPSBydG5sX3BvcnRfc2VsZl9m
aWxsKHNrYiwgZGV2KTsNCkBAIC0xMDAyLDcgKzEwMDYsNyBAQCBzdGF0aWMgaW50IHJ0bmxfZmls
bF9pZmluZm8oc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCiAJ
CW5sYV9uZXN0X2VuZChza2IsIHZmaW5mbyk7DQogCX0NCiANCi0JaWYgKHJ0bmxfcG9ydF9maWxs
KHNrYiwgZGV2KSkNCisJaWYgKHJ0bmxfcG9ydF9maWxsKHNrYiwgZGV2LCBleHRfZmlsdGVyX21h
c2spKQ0KIAkJZ290byBubGFfcHV0X2ZhaWx1cmU7DQogDQogCWlmIChkZXYtPnJ0bmxfbGlua19v
cHMpIHsNCkBAIC0xMDU3LDYgKzEwNjEsNyBAQCBzdGF0aWMgaW50IHJ0bmxfZHVtcF9pZmluZm8o
c3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldGxpbmtfY2FsbGJhY2sgKmNiKQ0KIAlzdHJ1
Y3QgaGxpc3Rfbm9kZSAqbm9kZTsNCiAJc3RydWN0IG5sYXR0ciAqdGJbSUZMQV9NQVgrMV07DQog
CXUzMiBleHRfZmlsdGVyX21hc2sgPSAwOw0KKwlpbnQgZXJyOw0KIA0KIAlzX2ggPSBjYi0+YXJn
c1swXTsNCiAJc19pZHggPSBjYi0+YXJnc1sxXTsNCkBAIC0xMDc3LDExICsxMDgyLDE3IEBAIHN0
YXRpYyBpbnQgcnRubF9kdW1wX2lmaW5mbyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgbmV0
bGlua19jYWxsYmFjayAqY2IpDQogCQlobGlzdF9mb3JfZWFjaF9lbnRyeV9yY3UoZGV2LCBub2Rl
LCBoZWFkLCBpbmRleF9obGlzdCkgew0KIAkJCWlmIChpZHggPCBzX2lkeCkNCiAJCQkJZ290byBj
b250Ow0KLQkJCWlmIChydG5sX2ZpbGxfaWZpbmZvKHNrYiwgZGV2LCBSVE1fTkVXTElOSywNCi0J
CQkJCSAgICAgTkVUTElOS19DQihjYi0+c2tiKS5waWQsDQotCQkJCQkgICAgIGNiLT5ubGgtPm5s
bXNnX3NlcSwgMCwNCi0JCQkJCSAgICAgTkxNX0ZfTVVMVEksDQotCQkJCQkgICAgIGV4dF9maWx0
ZXJfbWFzaykgPD0gMCkNCisJCQllcnIgPSBydG5sX2ZpbGxfaWZpbmZvKHNrYiwgZGV2LCBSVE1f
TkVXTElOSywNCisJCQkJCSAgICAgICBORVRMSU5LX0NCKGNiLT5za2IpLnBpZCwNCisJCQkJCSAg
ICAgICBjYi0+bmxoLT5ubG1zZ19zZXEsIDAsDQorCQkJCQkgICAgICAgTkxNX0ZfTVVMVEksDQor
CQkJCQkgICAgICAgZXh0X2ZpbHRlcl9tYXNrKTsNCisJCQkvKiBJZiB3ZSByYW4gb3V0IG9mIHJv
b20gb24gdGhlIGZpcnN0IG1lc3NhZ2UsDQorCQkJICogd2UncmUgaW4gdHJvdWJsZQ0KKwkJCSAq
Lw0KKwkJCVdBUk5fT04oKGVyciA9PSAtRU1TR1NJWkUpICYmIChza2ItPmxlbiA9PSAwKSk7DQor
DQorCQkJaWYgKGVyciA8PSAwKQ0KIAkJCQlnb3RvIG91dDsNCiANCiAJCQlubF9kdW1wX2NoZWNr
X2NvbnNpc3RlbnQoY2IsIG5sbXNnX2hkcihza2IpKTsNCmRpZmYgLS1naXQgYS9uZXQvY29yZS9z
a2J1ZmYuYyBiL25ldC9jb3JlL3NrYnVmZi5jDQppbmRleCA4YWM0YTBmLi45MjA0ZDliIDEwMDY0
NA0KLS0tIGEvbmV0L2NvcmUvc2tidWZmLmMNCisrKyBiL25ldC9jb3JlL3NrYnVmZi5jDQpAQCAt
NzQzLDcgKzc0Myw3IEBAIHN0YXRpYyB2b2lkIGNvcHlfc2tiX2hlYWRlcihzdHJ1Y3Qgc2tfYnVm
ZiAqbmV3LCBjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqb2xkKQ0KIHN0cnVjdCBza19idWZmICpza2Jf
Y29weShjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBnZnBfdCBnZnBfbWFzaykNCiB7DQogCWlu
dCBoZWFkZXJsZW4gPSBza2JfaGVhZHJvb20oc2tiKTsNCi0JdW5zaWduZWQgaW50IHNpemUgPSAo
c2tiX2VuZF9wb2ludGVyKHNrYikgLSBza2ItPmhlYWQpICsgc2tiLT5kYXRhX2xlbjsNCisJdW5z
aWduZWQgaW50IHNpemUgPSBza2JfZW5kX29mZnNldChza2IpICsgc2tiLT5kYXRhX2xlbjsNCiAJ
c3RydWN0IHNrX2J1ZmYgKm4gPSBhbGxvY19za2Ioc2l6ZSwgZ2ZwX21hc2spOw0KIA0KIAlpZiAo
IW4pDQpAQCAtODQzLDcgKzg0Myw3IEBAIGludCBwc2tiX2V4cGFuZF9oZWFkKHN0cnVjdCBza19i
dWZmICpza2IsIGludCBuaGVhZCwgaW50IG50YWlsLA0KIHsNCiAJaW50IGk7DQogCXU4ICpkYXRh
Ow0KLQlpbnQgc2l6ZSA9IG5oZWFkICsgKHNrYl9lbmRfcG9pbnRlcihza2IpIC0gc2tiLT5oZWFk
KSArIG50YWlsOw0KKwlpbnQgc2l6ZSA9IG5oZWFkICsgc2tiX2VuZF9vZmZzZXQoc2tiKSArIG50
YWlsOw0KIAlsb25nIG9mZjsNCiAJYm9vbCBmYXN0cGF0aDsNCiANCkBAIC0yNjQyLDE0ICsyNjQy
LDEzIEBAIHN0cnVjdCBza19idWZmICpza2Jfc2VnbWVudChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCB1
MzIgZmVhdHVyZXMpDQogCQkJaWYgKHVubGlrZWx5KCFuc2tiKSkNCiAJCQkJZ290byBlcnI7DQog
DQotCQkJaHNpemUgPSBza2JfZW5kX3BvaW50ZXIobnNrYikgLSBuc2tiLT5oZWFkOw0KKwkJCWhz
aXplID0gc2tiX2VuZF9vZmZzZXQobnNrYik7DQogCQkJaWYgKHNrYl9jb3dfaGVhZChuc2tiLCBk
b2Zmc2V0ICsgaGVhZHJvb20pKSB7DQogCQkJCWtmcmVlX3NrYihuc2tiKTsNCiAJCQkJZ290byBl
cnI7DQogCQkJfQ0KIA0KLQkJCW5za2ItPnRydWVzaXplICs9IHNrYl9lbmRfcG9pbnRlcihuc2ti
KSAtIG5za2ItPmhlYWQgLQ0KLQkJCQkJICBoc2l6ZTsNCisJCQluc2tiLT50cnVlc2l6ZSArPSBz
a2JfZW5kX29mZnNldChuc2tiKSAtIGhzaXplOw0KIAkJCXNrYl9yZWxlYXNlX2hlYWRfc3RhdGUo
bnNrYik7DQogCQkJX19za2JfcHVzaChuc2tiLCBkb2Zmc2V0KTsNCiAJCX0gZWxzZSB7DQpAQCAt
MzE5NywxMiArMzE5NiwxNCBAQCBFWFBPUlRfU1lNQk9MKF9fc2tiX3dhcm5fbHJvX2ZvcndhcmRp
bmcpOw0KIHVuc2lnbmVkIGludCBza2JfZ3NvX3RyYW5zcG9ydF9zZWdsZW4oY29uc3Qgc3RydWN0
IHNrX2J1ZmYgKnNrYikNCiB7DQogCWNvbnN0IHN0cnVjdCBza2Jfc2hhcmVkX2luZm8gKnNoaW5m
byA9IHNrYl9zaGluZm8oc2tiKTsNCi0JdW5zaWduZWQgaW50IGhkcl9sZW47DQogDQogCWlmIChs
aWtlbHkoc2hpbmZvLT5nc29fdHlwZSAmIChTS0JfR1NPX1RDUFY0IHwgU0tCX0dTT19UQ1BWNikp
KQ0KLQkJaGRyX2xlbiA9IHRjcF9oZHJsZW4oc2tiKTsNCi0JZWxzZQ0KLQkJaGRyX2xlbiA9IHNp
emVvZihzdHJ1Y3QgdWRwaGRyKTsNCi0JcmV0dXJuIGhkcl9sZW4gKyBzaGluZm8tPmdzb19zaXpl
Ow0KKwkJcmV0dXJuIHRjcF9oZHJsZW4oc2tiKSArIHNoaW5mby0+Z3NvX3NpemU7DQorDQorCS8q
IFVGTyBzZXRzIGdzb19zaXplIHRvIHRoZSBzaXplIG9mIHRoZSBmcmFnbWVudGF0aW9uDQorCSAq
IHBheWxvYWQsIGkuZS4gdGhlIHNpemUgb2YgdGhlIEw0IChVRFApIGhlYWRlciBpcyBhbHJlYWR5
DQorCSAqIGFjY291bnRlZCBmb3IuDQorCSAqLw0KKwlyZXR1cm4gc2hpbmZvLT5nc29fc2l6ZTsN
CiB9DQogRVhQT1JUX1NZTUJPTF9HUEwoc2tiX2dzb190cmFuc3BvcnRfc2VnbGVuKTsNCmRpZmYg
LS1naXQgYS9uZXQvaXB2NC9maWJfc2VtYW50aWNzLmMgYi9uZXQvaXB2NC9maWJfc2VtYW50aWNz
LmMNCmluZGV4IGQwMWY5YzYuLjc2ZGE5NzkgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC9maWJfc2Vt
YW50aWNzLmMNCisrKyBiL25ldC9pcHY0L2ZpYl9zZW1hbnRpY3MuYw0KQEAgLTc1MiwxMyArNzUy
LDEzIEBAIHN0cnVjdCBmaWJfaW5mbyAqZmliX2NyZWF0ZV9pbmZvKHN0cnVjdCBmaWJfY29uZmln
ICpjZmcpDQogCWZpID0ga3phbGxvYyhzaXplb2YoKmZpKStuaHMqc2l6ZW9mKHN0cnVjdCBmaWJf
bmgpLCBHRlBfS0VSTkVMKTsNCiAJaWYgKGZpID09IE5VTEwpDQogCQlnb3RvIGZhaWx1cmU7DQor
CWZpYl9pbmZvX2NudCsrOw0KIAlpZiAoY2ZnLT5mY19teCkgew0KIAkJZmktPmZpYl9tZXRyaWNz
ID0ga3phbGxvYyhzaXplb2YodTMyKSAqIFJUQVhfTUFYLCBHRlBfS0VSTkVMKTsNCiAJCWlmICgh
ZmktPmZpYl9tZXRyaWNzKQ0KIAkJCWdvdG8gZmFpbHVyZTsNCiAJfSBlbHNlDQogCQlmaS0+Zmli
X21ldHJpY3MgPSAodTMyICopIGRzdF9kZWZhdWx0X21ldHJpY3M7DQotCWZpYl9pbmZvX2NudCsr
Ow0KIA0KIAlmaS0+ZmliX25ldCA9IGhvbGRfbmV0KG5ldCk7DQogCWZpLT5maWJfcHJvdG9jb2wg
PSBjZmctPmZjX3Byb3RvY29sOw0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L2lwX2ZvcndhcmQuYyBi
L25ldC9pcHY0L2lwX2ZvcndhcmQuYw0KaW5kZXggZTBkOWYwMi4uNzU5M2YzYSAxMDA2NDQNCi0t
LSBhL25ldC9pcHY0L2lwX2ZvcndhcmQuYw0KKysrIGIvbmV0L2lwdjQvaXBfZm9yd2FyZC5jDQpA
QCAtNDIsMTIgKzQyLDEyIEBADQogc3RhdGljIGJvb2wgaXBfbWF5X2ZyYWdtZW50KGNvbnN0IHN0
cnVjdCBza19idWZmICpza2IpDQogew0KIAlyZXR1cm4gdW5saWtlbHkoKGlwX2hkcihza2IpLT5m
cmFnX29mZiAmIGh0b25zKElQX0RGKSkgPT0gMCkgfHwNCi0JICAgICAgICFza2ItPmxvY2FsX2Rm
Ow0KKwkJc2tiLT5sb2NhbF9kZjsNCiB9DQogDQogc3RhdGljIGJvb2wgaXBfZXhjZWVkc19tdHUo
Y29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwgdW5zaWduZWQgaW50IG10dSkNCiB7DQotCWlmIChz
a2ItPmxlbiA8PSBtdHUgfHwgc2tiLT5sb2NhbF9kZikNCisJaWYgKHNrYi0+bGVuIDw9IG10dSkN
CiAJCXJldHVybiBmYWxzZTsNCiANCiAJaWYgKHNrYl9pc19nc28oc2tiKSAmJiBza2JfZ3NvX25l
dHdvcmtfc2VnbGVuKHNrYikgPD0gbXR1KQ0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L25ldGZpbHRl
ci9hcnBfdGFibGVzLmMgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvYXJwX3RhYmxlcy5jDQppbmRleCBm
ZDdhM2Y2Li5iY2I2ZTYxIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQvbmV0ZmlsdGVyL2FycF90YWJs
ZXMuYw0KKysrIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL2FycF90YWJsZXMuYw0KQEAgLTEwMzksOCAr
MTAzOSwxMCBAQCBzdGF0aWMgaW50IF9fZG9fcmVwbGFjZShzdHJ1Y3QgbmV0ICpuZXQsIGNvbnN0
IGNoYXIgKm5hbWUsDQogDQogCXh0X2ZyZWVfdGFibGVfaW5mbyhvbGRpbmZvKTsNCiAJaWYgKGNv
cHlfdG9fdXNlcihjb3VudGVyc19wdHIsIGNvdW50ZXJzLA0KLQkJCSBzaXplb2Yoc3RydWN0IHh0
X2NvdW50ZXJzKSAqIG51bV9jb3VudGVycykgIT0gMCkNCi0JCXJldCA9IC1FRkFVTFQ7DQorCQkJ
IHNpemVvZihzdHJ1Y3QgeHRfY291bnRlcnMpICogbnVtX2NvdW50ZXJzKSAhPSAwKSB7DQorCQkv
KiBTaWxlbnQgZXJyb3IsIGNhbid0IGZhaWwsIG5ldyB0YWJsZSBpcyBhbHJlYWR5IGluIHBsYWNl
ICovDQorCQluZXRfd2Fybl9yYXRlbGltaXRlZCgiYXJwdGFibGVzOiBjb3VudGVycyBjb3B5IHRv
IHVzZXIgZmFpbGVkIHdoaWxlIHJlcGxhY2luZyB0YWJsZVxuIik7DQorCX0NCiAJdmZyZWUoY291
bnRlcnMpOw0KIAl4dF90YWJsZV91bmxvY2sodCk7DQogCXJldHVybiByZXQ7DQpkaWZmIC0tZ2l0
IGEvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX3RhYmxlcy5jIGIvbmV0L2lwdjQvbmV0ZmlsdGVyL2lw
X3RhYmxlcy5jDQppbmRleCAyNGU1NTZlLi5mOThhMWNmIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQv
bmV0ZmlsdGVyL2lwX3RhYmxlcy5jDQorKysgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvaXBfdGFibGVz
LmMNCkBAIC0xMjI3LDggKzEyMjcsMTAgQEAgX19kb19yZXBsYWNlKHN0cnVjdCBuZXQgKm5ldCwg
Y29uc3QgY2hhciAqbmFtZSwgdW5zaWduZWQgaW50IHZhbGlkX2hvb2tzLA0KIA0KIAl4dF9mcmVl
X3RhYmxlX2luZm8ob2xkaW5mbyk7DQogCWlmIChjb3B5X3RvX3VzZXIoY291bnRlcnNfcHRyLCBj
b3VudGVycywNCi0JCQkgc2l6ZW9mKHN0cnVjdCB4dF9jb3VudGVycykgKiBudW1fY291bnRlcnMp
ICE9IDApDQotCQlyZXQgPSAtRUZBVUxUOw0KKwkJCSBzaXplb2Yoc3RydWN0IHh0X2NvdW50ZXJz
KSAqIG51bV9jb3VudGVycykgIT0gMCkgew0KKwkJLyogU2lsZW50IGVycm9yLCBjYW4ndCBmYWls
LCBuZXcgdGFibGUgaXMgYWxyZWFkeSBpbiBwbGFjZSAqLw0KKwkJbmV0X3dhcm5fcmF0ZWxpbWl0
ZWQoImlwdGFibGVzOiBjb3VudGVycyBjb3B5IHRvIHVzZXIgZmFpbGVkIHdoaWxlIHJlcGxhY2lu
ZyB0YWJsZVxuIik7DQorCX0NCiAJdmZyZWUoY291bnRlcnMpOw0KIAl4dF90YWJsZV91bmxvY2so
dCk7DQogCXJldHVybiByZXQ7DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvcGluZy5jIGIvbmV0L2lw
djQvcGluZy5jDQppbmRleCAwMDk3NWI2Li5kNDk1ZDRiIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQv
cGluZy5jDQorKysgYi9uZXQvaXB2NC9waW5nLmMNCkBAIC0yMDMsMjYgKzIwMywzMyBAQCBzdGF0
aWMgaW50IHBpbmdfaW5pdF9zb2NrKHN0cnVjdCBzb2NrICpzaykNCiAJc3RydWN0IG5ldCAqbmV0
ID0gc29ja19uZXQoc2spOw0KIAlnaWRfdCBncm91cCA9IGN1cnJlbnRfZWdpZCgpOw0KIAlnaWRf
dCByYW5nZVsyXTsNCi0Jc3RydWN0IGdyb3VwX2luZm8gKmdyb3VwX2luZm8gPSBnZXRfY3VycmVu
dF9ncm91cHMoKTsNCi0JaW50IGksIGosIGNvdW50ID0gZ3JvdXBfaW5mby0+bmdyb3VwczsNCisJ
c3RydWN0IGdyb3VwX2luZm8gKmdyb3VwX2luZm87DQorCWludCBpLCBqLCBjb3VudDsNCisJaW50
IHJldCA9IDA7DQogDQogCWluZXRfZ2V0X3BpbmdfZ3JvdXBfcmFuZ2VfbmV0KG5ldCwgcmFuZ2Us
IHJhbmdlKzEpOw0KIAlpZiAocmFuZ2VbMF0gPD0gZ3JvdXAgJiYgZ3JvdXAgPD0gcmFuZ2VbMV0p
DQogCQlyZXR1cm4gMDsNCiANCisJZ3JvdXBfaW5mbyA9IGdldF9jdXJyZW50X2dyb3VwcygpOw0K
Kwljb3VudCA9IGdyb3VwX2luZm8tPm5ncm91cHM7DQogCWZvciAoaSA9IDA7IGkgPCBncm91cF9p
bmZvLT5uYmxvY2tzOyBpKyspIHsNCiAJCWludCBjcF9jb3VudCA9IG1pbl90KGludCwgTkdST1VQ
U19QRVJfQkxPQ0ssIGNvdW50KTsNCiANCiAJCWZvciAoaiA9IDA7IGogPCBjcF9jb3VudDsgaisr
KSB7DQogCQkJZ3JvdXAgPSBncm91cF9pbmZvLT5ibG9ja3NbaV1bal07DQogCQkJaWYgKHJhbmdl
WzBdIDw9IGdyb3VwICYmIGdyb3VwIDw9IHJhbmdlWzFdKQ0KLQkJCQlyZXR1cm4gMDsNCisJCQkJ
Z290byBvdXRfcmVsZWFzZV9ncm91cDsNCiAJCX0NCiANCiAJCWNvdW50IC09IGNwX2NvdW50Ow0K
IAl9DQogDQotCXJldHVybiAtRUFDQ0VTOw0KKwlyZXQgPSAtRUFDQ0VTOw0KKw0KK291dF9yZWxl
YXNlX2dyb3VwOg0KKwlwdXRfZ3JvdXBfaW5mbyhncm91cF9pbmZvKTsNCisJcmV0dXJuIHJldDsN
CiB9DQogDQogc3RhdGljIHZvaWQgcGluZ19jbG9zZShzdHJ1Y3Qgc29jayAqc2ssIGxvbmcgdGlt
ZW91dCkNCmRpZmYgLS1naXQgYS9uZXQvaXB2NC9yb3V0ZS5jIGIvbmV0L2lwdjQvcm91dGUuYw0K
aW5kZXggNjc2OGNlMi4uNjUyNjExMCAxMDA2NDQNCi0tLSBhL25ldC9pcHY0L3JvdXRlLmMNCisr
KyBiL25ldC9pcHY0L3JvdXRlLmMNCkBAIC0yMTQyLDcgKzIxNDIsNyBAQCBzdGF0aWMgaW50IF9f
bWtyb3V0ZV9pbnB1dChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIAlzdHJ1Y3QgaW5fZGV2aWNlICpv
dXRfZGV2Ow0KIAl1bnNpZ25lZCBpbnQgZmxhZ3MgPSAwOw0KIAlfX2JlMzIgc3BlY19kc3Q7DQot
CXUzMiBpdGFnOw0KKwl1MzIgaXRhZyA9IDA7DQogDQogCS8qIGdldCBhIHdvcmtpbmcgcmVmZXJl
bmNlIHRvIHRoZSBvdXRwdXQgZGV2aWNlICovDQogCW91dF9kZXYgPSBfX2luX2Rldl9nZXRfcmN1
KEZJQl9SRVNfREVWKCpyZXMpKTsNCmRpZmYgLS1naXQgYS9uZXQvaXB2NC90Y3BfY3ViaWMuYyBi
L25ldC9pcHY0L3RjcF9jdWJpYy5jDQppbmRleCBiNzhlYWMyLi5lZDNkNmQ0IDEwMDY0NA0KLS0t
IGEvbmV0L2lwdjQvdGNwX2N1YmljLmMNCisrKyBiL25ldC9pcHY0L3RjcF9jdWJpYy5jDQpAQCAt
NDA2LDcgKzQwNiw3IEBAIHN0YXRpYyB2b2lkIGJpY3RjcF9hY2tlZChzdHJ1Y3Qgc29jayAqc2ss
IHUzMiBjbnQsIHMzMiBydHRfdXMpDQogCQlyYXRpbyAtPSBjYS0+ZGVsYXllZF9hY2sgPj4gQUNL
X1JBVElPX1NISUZUOw0KIAkJcmF0aW8gKz0gY250Ow0KIA0KLQkJY2EtPmRlbGF5ZWRfYWNrID0g
bWluKHJhdGlvLCBBQ0tfUkFUSU9fTElNSVQpOw0KKwkJY2EtPmRlbGF5ZWRfYWNrID0gY2xhbXAo
cmF0aW8sIDFVLCBBQ0tfUkFUSU9fTElNSVQpOw0KIAl9DQogDQogCS8qIFNvbWUgY2FsbHMgYXJl
IGZvciBkdXBsaWNhdGVzIHdpdGhvdXQgdGltZXRhbXBzICovDQpkaWZmIC0tZ2l0IGEvbmV0L2lw
djYvbmV0ZmlsdGVyL2lwNl90YWJsZXMuYyBiL25ldC9pcHY2L25ldGZpbHRlci9pcDZfdGFibGVz
LmMNCmluZGV4IDk0ODc0YjAuLjJlNzUyYjIgMTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni9uZXRmaWx0
ZXIvaXA2X3RhYmxlcy5jDQorKysgYi9uZXQvaXB2Ni9uZXRmaWx0ZXIvaXA2X3RhYmxlcy5jDQpA
QCAtMTI0OSw4ICsxMjQ5LDEwIEBAIF9fZG9fcmVwbGFjZShzdHJ1Y3QgbmV0ICpuZXQsIGNvbnN0
IGNoYXIgKm5hbWUsIHVuc2lnbmVkIGludCB2YWxpZF9ob29rcywNCiANCiAJeHRfZnJlZV90YWJs
ZV9pbmZvKG9sZGluZm8pOw0KIAlpZiAoY29weV90b191c2VyKGNvdW50ZXJzX3B0ciwgY291bnRl
cnMsDQotCQkJIHNpemVvZihzdHJ1Y3QgeHRfY291bnRlcnMpICogbnVtX2NvdW50ZXJzKSAhPSAw
KQ0KLQkJcmV0ID0gLUVGQVVMVDsNCisJCQkgc2l6ZW9mKHN0cnVjdCB4dF9jb3VudGVycykgKiBu
dW1fY291bnRlcnMpICE9IDApIHsNCisJCS8qIFNpbGVudCBlcnJvciwgY2FuJ3QgZmFpbCwgbmV3
IHRhYmxlIGlzIGFscmVhZHkgaW4gcGxhY2UgKi8NCisJCW5ldF93YXJuX3JhdGVsaW1pdGVkKCJp
cDZ0YWJsZXM6IGNvdW50ZXJzIGNvcHkgdG8gdXNlciBmYWlsZWQgd2hpbGUgcmVwbGFjaW5nIHRh
YmxlXG4iKTsNCisJfQ0KIAl2ZnJlZShjb3VudGVycyk7DQogCXh0X3RhYmxlX3VubG9jayh0KTsN
CiAJcmV0dXJuIHJldDsNCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9yb3V0ZS5jIGIvbmV0L2lwdjYv
cm91dGUuYw0KaW5kZXggMzllMTFmOS4uNzgyZjY3YSAxMDA2NDQNCi0tLSBhL25ldC9pcHY2L3Jv
dXRlLmMNCisrKyBiL25ldC9pcHY2L3JvdXRlLmMNCkBAIC0xMDU2LDcgKzEwNTYsNyBAQCBzdGF0
aWMgdW5zaWduZWQgaW50IGlwNl9tdHUoY29uc3Qgc3RydWN0IGRzdF9lbnRyeSAqZHN0KQ0KIAl1
bnNpZ25lZCBpbnQgbXR1ID0gZHN0X21ldHJpY19yYXcoZHN0LCBSVEFYX01UVSk7DQogDQogCWlm
IChtdHUpDQotCQlyZXR1cm4gbXR1Ow0KKwkJZ290byBvdXQ7DQogDQogCW10dSA9IElQVjZfTUlO
X01UVTsNCiANCkBAIC0xMDY2LDcgKzEwNjYsOCBAQCBzdGF0aWMgdW5zaWduZWQgaW50IGlwNl9t
dHUoY29uc3Qgc3RydWN0IGRzdF9lbnRyeSAqZHN0KQ0KIAkJbXR1ID0gaWRldi0+Y25mLm10dTY7
DQogCXJjdV9yZWFkX3VubG9jaygpOw0KIA0KLQlyZXR1cm4gbXR1Ow0KK291dDoNCisJcmV0dXJu
IG1pbl90KHVuc2lnbmVkIGludCwgbXR1LCBJUDZfTUFYX01UVSk7DQogfQ0KIA0KIHN0YXRpYyBz
dHJ1Y3QgZHN0X2VudHJ5ICppY21wNl9kc3RfZ2NfbGlzdDsNCmRpZmYgLS1naXQgYS9uZXQvbDJ0
cC9sMnRwX3BwcC5jIGIvbmV0L2wydHAvbDJ0cF9wcHAuYw0KaW5kZXggOTY5Y2QzZS4uZTBmMDkz
NCAxMDA2NDQNCi0tLSBhL25ldC9sMnRwL2wydHBfcHBwLmMNCisrKyBiL25ldC9sMnRwL2wydHBf
cHBwLmMNCkBAIC03NzIsOSArNzcyLDkgQEAgc3RhdGljIGludCBwcHBvbDJ0cF9jb25uZWN0KHN0
cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBzb2NrYWRkciAqdXNlcnZhZGRyLA0KIAlzZXNzaW9u
LT5kZXJlZiA9IHBwcG9sMnRwX3Nlc3Npb25fc29ja19wdXQ7DQogDQogCS8qIElmIFBNVFUgZGlz
Y292ZXJ5IHdhcyBlbmFibGVkLCB1c2UgdGhlIE1UVSB0aGF0IHdhcyBkaXNjb3ZlcmVkICovDQot
CWRzdCA9IHNrX2RzdF9nZXQoc2spOw0KKwlkc3QgPSBza19kc3RfZ2V0KHR1bm5lbC0+c29jayk7
DQogCWlmIChkc3QgIT0gTlVMTCkgew0KLQkJdTMyIHBtdHUgPSBkc3RfbXR1KF9fc2tfZHN0X2dl
dChzaykpOw0KKwkJdTMyIHBtdHUgPSBkc3RfbXR1KF9fc2tfZHN0X2dldCh0dW5uZWwtPnNvY2sp
KTsNCiAJCWlmIChwbXR1ICE9IDApDQogCQkJc2Vzc2lvbi0+bXR1ID0gc2Vzc2lvbi0+bXJ1ID0g
cG10dSAtDQogCQkJCVBQUE9MMlRQX0hFQURFUl9PVkVSSEVBRDsNCmRpZmYgLS1naXQgYS9uZXQv
c2NoZWQvYWN0X21pcnJlZC5jIGIvbmV0L3NjaGVkL2FjdF9taXJyZWQuYw0KaW5kZXggZTA1MTM5
OC4uZDA2N2VkMSAxMDA2NDQNCi0tLSBhL25ldC9zY2hlZC9hY3RfbWlycmVkLmMNCisrKyBiL25l
dC9zY2hlZC9hY3RfbWlycmVkLmMNCkBAIC0yMDEsMTMgKzIwMSwxMiBAQCBzdGF0aWMgaW50IHRj
Zl9taXJyZWQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgY29uc3Qgc3RydWN0IHRjX2FjdGlvbiAqYSwN
CiBvdXQ6DQogCWlmIChlcnIpIHsNCiAJCW0tPnRjZl9xc3RhdHMub3ZlcmxpbWl0cysrOw0KLQkJ
Lyogc2hvdWxkIHdlIGJlIGFza2luZyBmb3IgcGFja2V0IHRvIGJlIGRyb3BwZWQ/DQotCQkgKiBt
YXkgbWFrZSBzZW5zZSBmb3IgcmVkaXJlY3QgY2FzZSBvbmx5DQotCQkgKi8NCi0JCXJldHZhbCA9
IFRDX0FDVF9TSE9UOw0KLQl9IGVsc2Ugew0KKwkJaWYgKG0tPnRjZm1fZWFjdGlvbiAhPSBUQ0Ff
RUdSRVNTX01JUlJPUikNCisJCQlyZXR2YWwgPSBUQ19BQ1RfU0hPVDsNCisJCWVsc2UNCisJCQly
ZXR2YWwgPSBtLT50Y2ZfYWN0aW9uOw0KKwl9IGVsc2UNCiAJCXJldHZhbCA9IG0tPnRjZl9hY3Rp
b247DQotCX0NCiAJc3Bpbl91bmxvY2soJm0tPnRjZl9sb2NrKTsNCiANCiAJcmV0dXJuIHJldHZh
bDsNCmRpZmYgLS1naXQgYS9uZXQvc2N0cC9wcm90b2NvbC5jIGIvbmV0L3NjdHAvcHJvdG9jb2wu
Yw0KaW5kZXggNmY2YWQ4Ni4uZGUzNWUwMSAxMDA2NDQNCi0tLSBhL25ldC9zY3RwL3Byb3RvY29s
LmMNCisrKyBiL25ldC9zY3RwL3Byb3RvY29sLmMNCkBAIC01MjgsOCArNTI4LDEzIEBAIHN0YXRp
YyB2b2lkIHNjdHBfdjRfZ2V0X2RzdChzdHJ1Y3Qgc2N0cF90cmFuc3BvcnQgKnQsIHVuaW9uIHNj
dHBfYWRkciAqc2FkZHIsDQogCQkJY29udGludWU7DQogCQlpZiAoKGxhZGRyLT5zdGF0ZSA9PSBT
Q1RQX0FERFJfU1JDKSAmJg0KIAkJICAgIChBRl9JTkVUID09IGxhZGRyLT5hLnNhLnNhX2ZhbWls
eSkpIHsNCi0JCQlmbDQtPnNhZGRyID0gbGFkZHItPmEudjQuc2luX2FkZHIuc19hZGRyOw0KIAkJ
CWZsNC0+Zmw0X3Nwb3J0ID0gbGFkZHItPmEudjQuc2luX3BvcnQ7DQorCQkJZmxvd2k0X3VwZGF0
ZV9vdXRwdXQoZmw0LA0KKwkJCQkJICAgICBhc29jLT5iYXNlLnNrLT5za19ib3VuZF9kZXZfaWYs
DQorCQkJCQkgICAgIFJUX0NPTk5fRkxBR1MoYXNvYy0+YmFzZS5zayksDQorCQkJCQkgICAgIGRh
ZGRyLT52NC5zaW5fYWRkci5zX2FkZHIsDQorCQkJCQkgICAgIGxhZGRyLT5hLnY0LnNpbl9hZGRy
LnNfYWRkcik7DQorDQogCQkJcnQgPSBpcF9yb3V0ZV9vdXRwdXRfa2V5KCZpbml0X25ldCwgZmw0
KTsNCiAJCQlpZiAoIUlTX0VSUihydCkpIHsNCiAJCQkJZHN0ID0gJnJ0LT5kc3Q7DQpkaWZmIC0t
Z2l0IGEvc2NyaXB0cy9tb2QvbW9kcG9zdC5jIGIvc2NyaXB0cy9tb2QvbW9kcG9zdC5jDQppbmRl
eCA2MTkyMjhkLi5kYzU3NDhmIDEwMDY0NA0KLS0tIGEvc2NyaXB0cy9tb2QvbW9kcG9zdC5jDQor
KysgYi9zY3JpcHRzL21vZC9tb2Rwb3N0LmMNCkBAIC01NjksMTIgKzU2OSwxNiBAQCBzdGF0aWMg
aW50IGlnbm9yZV91bmRlZl9zeW1ib2woc3RydWN0IGVsZl9pbmZvICppbmZvLCBjb25zdCBjaGFy
ICpzeW1uYW1lKQ0KIAkJaWYgKHN0cm5jbXAoc3ltbmFtZSwgIl9yZXN0Z3ByXyIsIHNpemVvZigi
X3Jlc3RncHJfIikgLSAxKSA9PSAwIHx8DQogCQkgICAgc3RybmNtcChzeW1uYW1lLCAiX3NhdmVn
cHJfIiwgc2l6ZW9mKCJfc2F2ZWdwcl8iKSAtIDEpID09IDAgfHwNCiAJCSAgICBzdHJuY21wKHN5
bW5hbWUsICJfcmVzdDMyZ3ByXyIsIHNpemVvZigiX3Jlc3QzMmdwcl8iKSAtIDEpID09IDAgfHwN
Ci0JCSAgICBzdHJuY21wKHN5bW5hbWUsICJfc2F2ZTMyZ3ByXyIsIHNpemVvZigiX3NhdmUzMmdw
cl8iKSAtIDEpID09IDApDQorCQkgICAgc3RybmNtcChzeW1uYW1lLCAiX3NhdmUzMmdwcl8iLCBz
aXplb2YoIl9zYXZlMzJncHJfIikgLSAxKSA9PSAwIHx8DQorCQkgICAgc3RybmNtcChzeW1uYW1l
LCAiX3Jlc3R2cl8iLCBzaXplb2YoIl9yZXN0dnJfIikgLSAxKSA9PSAwIHx8DQorCQkgICAgc3Ry
bmNtcChzeW1uYW1lLCAiX3NhdmV2cl8iLCBzaXplb2YoIl9zYXZldnJfIikgLSAxKSA9PSAwKQ0K
IAkJCXJldHVybiAxOw0KIAlpZiAoaW5mby0+aGRyLT5lX21hY2hpbmUgPT0gRU1fUFBDNjQpDQog
CQkvKiBTcGVjaWFsIHJlZ2lzdGVyIGZ1bmN0aW9uIGxpbmtlZCBvbiBhbGwgbW9kdWxlcyBkdXJp
bmcgZmluYWwgbGluayBvZiAua28gKi8NCiAJCWlmIChzdHJuY21wKHN5bW5hbWUsICJfcmVzdGdw
cjBfIiwgc2l6ZW9mKCJfcmVzdGdwcjBfIikgLSAxKSA9PSAwIHx8DQotCQkgICAgc3RybmNtcChz
eW1uYW1lLCAiX3NhdmVncHIwXyIsIHNpemVvZigiX3NhdmVncHIwXyIpIC0gMSkgPT0gMCkNCisJ
CSAgICBzdHJuY21wKHN5bW5hbWUsICJfc2F2ZWdwcjBfIiwgc2l6ZW9mKCJfc2F2ZWdwcjBfIikg
LSAxKSA9PSAwIHx8DQorCQkgICAgc3RybmNtcChzeW1uYW1lLCAiX3Jlc3R2cl8iLCBzaXplb2Yo
Il9yZXN0dnJfIikgLSAxKSA9PSAwIHx8DQorCQkgICAgc3RybmNtcChzeW1uYW1lLCAiX3NhdmV2
cl8iLCBzaXplb2YoIl9zYXZldnJfIikgLSAxKSA9PSAwKQ0KIAkJCXJldHVybiAxOw0KIAkvKiBE
byBub3QgaWdub3JlIHRoaXMgc3ltYm9sICovDQogCXJldHVybiAwOw0KZGlmZiAtLWdpdCBhL3Zp
cnQva3ZtL2FzeW5jX3BmLmMgYi92aXJ0L2t2bS9hc3luY19wZi5jDQppbmRleCA3NDI2OGI0Li5i
ZGQyYzBkIDEwMDY0NA0KLS0tIGEvdmlydC9rdm0vYXN5bmNfcGYuYw0KKysrIGIvdmlydC9rdm0v
YXN5bmNfcGYuYw0KQEAgLTc1LDcgKzc1LDYgQEAgc3RhdGljIHZvaWQgYXN5bmNfcGZfZXhlY3V0
ZShzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQogCXNwaW5fbG9jaygmdmNwdS0+YXN5bmNfcGYu
bG9jayk7DQogCWxpc3RfYWRkX3RhaWwoJmFwZi0+bGluaywgJnZjcHUtPmFzeW5jX3BmLmRvbmUp
Ow0KIAlhcGYtPnBhZ2UgPSBwYWdlOw0KLQlhcGYtPmRvbmUgPSB0cnVlOw0KIAlzcGluX3VubG9j
aygmdmNwdS0+YXN5bmNfcGYubG9jayk7DQogDQogCS8qDQpAQCAtODgsNyArODcsNyBAQCBzdGF0
aWMgdm9pZCBhc3luY19wZl9leGVjdXRlKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiAJaWYg
KHdhaXRxdWV1ZV9hY3RpdmUoJnZjcHUtPndxKSkNCiAJCXdha2VfdXBfaW50ZXJydXB0aWJsZSgm
dmNwdS0+d3EpOw0KIA0KLQltbWRyb3AobW0pOw0KKwltbXB1dChtbSk7DQogCWt2bV9wdXRfa3Zt
KHZjcHUtPmt2bSk7DQogfQ0KIA0KQEAgLTk5LDEwICs5OCwxMiBAQCB2b2lkIGt2bV9jbGVhcl9h
c3luY19wZl9jb21wbGV0aW9uX3F1ZXVlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCiAJCXN0cnVj
dCBrdm1fYXN5bmNfcGYgKndvcmsgPQ0KIAkJCWxpc3RfZW50cnkodmNwdS0+YXN5bmNfcGYucXVl
dWUubmV4dCwNCiAJCQkJICAgdHlwZW9mKCp3b3JrKSwgcXVldWUpOw0KLQkJY2FuY2VsX3dvcmtf
c3luYygmd29yay0+d29yayk7DQogCQlsaXN0X2RlbCgmd29yay0+cXVldWUpOw0KLQkJaWYgKCF3
b3JrLT5kb25lKSAvKiB3b3JrIHdhcyBjYW5jZWxlZCAqLw0KKwkJaWYgKGNhbmNlbF93b3JrX3N5
bmMoJndvcmstPndvcmspKSB7DQorCQkJbW1wdXQod29yay0+bW0pOw0KKwkJCWt2bV9wdXRfa3Zt
KHZjcHUtPmt2bSk7IC8qID09IHdvcmstPnZjcHUtPmt2bSAqLw0KIAkJCWttZW1fY2FjaGVfZnJl
ZShhc3luY19wZl9jYWNoZSwgd29yayk7DQorCQl9DQogCX0NCiANCiAJc3Bpbl9sb2NrKCZ2Y3B1
LT5hc3luY19wZi5sb2NrKTsNCkBAIC0xNjMsMTMgKzE2NCwxMiBAQCBpbnQga3ZtX3NldHVwX2Fz
eW5jX3BmKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgZ3ZhX3QgZ3ZhLCBnZm5fdCBnZm4sDQogCQly
ZXR1cm4gMDsNCiANCiAJd29yay0+cGFnZSA9IE5VTEw7DQotCXdvcmstPmRvbmUgPSBmYWxzZTsN
CiAJd29yay0+dmNwdSA9IHZjcHU7DQogCXdvcmstPmd2YSA9IGd2YTsNCiAJd29yay0+YWRkciA9
IGdmbl90b19odmEodmNwdS0+a3ZtLCBnZm4pOw0KIAl3b3JrLT5hcmNoID0gKmFyY2g7DQogCXdv
cmstPm1tID0gY3VycmVudC0+bW07DQotCWF0b21pY19pbmMoJndvcmstPm1tLT5tbV9jb3VudCk7
DQorCWF0b21pY19pbmMoJndvcmstPm1tLT5tbV91c2Vycyk7DQogCWt2bV9nZXRfa3ZtKHdvcmst
PnZjcHUtPmt2bSk7DQogDQogCS8qIHRoaXMgY2FuJ3QgcmVhbGx5IGhhcHBlbiBvdGhlcndpc2Ug
Z2ZuX3RvX3Bmbl9hc3luYw0KQEAgLTE4Nyw3ICsxODcsNyBAQCBpbnQga3ZtX3NldHVwX2FzeW5j
X3BmKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgZ3ZhX3QgZ3ZhLCBnZm5fdCBnZm4sDQogCXJldHVy
biAxOw0KIHJldHJ5X3N5bmM6DQogCWt2bV9wdXRfa3ZtKHdvcmstPnZjcHUtPmt2bSk7DQotCW1t
ZHJvcCh3b3JrLT5tbSk7DQorCW1tcHV0KHdvcmstPm1tKTsNCiAJa21lbV9jYWNoZV9mcmVlKGFz
eW5jX3BmX2NhY2hlLCB3b3JrKTsNCiAJcmV0dXJuIDA7DQogfQ0K


--=-fvL+mcIi4w+BEHW3vovx--

--=-Y8WySKz0pORJz7LEbXfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5XAPee/yOyVhhEJAQqc6Q/+OJnKlZ7C/1Nab1ZtFDzOCdft0F8fGutU
TBldvSP8DLZ/c88g7Elo5dBe1xrNEzHPQz6RJcPMXKDtEZCHIjWu9akf4/mhyWrn
txTFQ+QZls54vVMEAOSXVMnyEYPuRJYXEvNwvtmd/zc1kEy1uryfRdlbQSky0gOL
r+oaSgHwMtPflCR7WnAhPkErF2cJTsZlT8tMW4WpWj0bx8TDy6p6LfwYMm3GRQRf
rX6GGbZgvta2UJIB93qZAcxIx8fS+OX5UXofRXrX61wrUSLNSs+JSGS/jHwDn+wS
Caxz1VbPr/syo4HXl7Qogo8dykhbEyObIto/DdsMYflCmnCjgGy24pTl3t/bdTb9
dTtsfBcMIa6i+u8IhEAC3ZCPTwCvzyguxsK+L9za9ajLPAEst7nbBFaJoKXXV5gV
NtGThhgCouOziBd3ZrvzvuG0GoVofC2v8oWM6g3jV6XeM3ozNGfcvrQw48rDlBsm
EnG260g10vBxDlITPxRRqrKtCi2oTWejelcB7oBhXgd9pPfZGwJAFYwrloB7V3P+
yHa8assWhAal8NN3BP2Zla/DuC5qZZTyKPbwz+OAd+6yjtY/Y2KZ+EEfxsIlERCT
evwVtL05mOfflz1zkuQ/vG5WOyU48QjpeJYi80IJ4TplHgIWODfZkBioRt/kDBpJ
UfkA3ESFoWU=
=Js0+
-----END PGP SIGNATURE-----

--=-Y8WySKz0pORJz7LEbXfi--
