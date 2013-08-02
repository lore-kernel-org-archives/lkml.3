Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3HBVvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:51:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57499 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363Ab3HBVvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:51:18 -0400
Message-ID: <1375480258.32254.24.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.50
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Fri, 02 Aug 2013 23:50:58 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-d+3U4e2WbZbdAw201rsB"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.218.101.46
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d+3U4e2WbZbdAw201rsB
Content-Type: multipart/mixed; boundary="=-FKkQ2AAH8Owp7TStfoHb"


--=-FKkQ2AAH8Owp7TStfoHb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.50 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.49 is attached to this message.

Ben.

------------

 Makefile                                        |   2 +-
 arch/powerpc/include/asm/module.h               |   5 +-
 arch/powerpc/kernel/vmlinux.lds.S               |   3 -
 arch/sparc/kernel/asm-offsets.c                 |   2 +
 arch/sparc/mm/hypersparc.S                      |   8 +-
 arch/sparc/mm/init_64.c                         |   9 +-
 arch/sparc/mm/swift.S                           |   8 +-
 arch/sparc/mm/tlb.c                             |   2 +-
 arch/sparc/mm/tsunami.S                         |   6 +-
 arch/sparc/mm/viking.S                          |  10 +-
 drivers/acpi/acpi_memhotplug.c                  |   1 +
 drivers/ata/ata_piix.c                          |   2 +-
 drivers/block/xen-blkback/blkback.c             |  13 +-
 drivers/block/xen-blkback/common.h              |   2 +
 drivers/block/xen-blkback/xenbus.c              |   2 +
 drivers/gpu/drm/radeon/radeon_combios.c         | 159 ++++++++------------=
----
 drivers/net/dummy.c                             |   4 +
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |  50 +++++++-
 drivers/net/ethernet/renesas/sh_eth.c           |  17 +--
 drivers/net/ethernet/renesas/sh_eth.h           |   2 +-
 drivers/net/ethernet/sun/sunvnet.c              |   2 +
 drivers/net/ifb.c                               |   8 +-
 drivers/net/macvtap.c                           |  14 ++-
 drivers/net/virtio_net.c                        |   5 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                 |   2 +-
 drivers/scsi/isci/task.c                        |   9 +-
 drivers/scsi/qla2xxx/qla_iocb.c                 |  11 +-
 drivers/scsi/sd.c                               |  22 ++--
 drivers/staging/comedi/comedi_fops.c            |  32 +++--
 drivers/staging/line6/pcm.c                     |   5 +-
 drivers/usb/core/hub.c                          |   9 ++
 drivers/usb/dwc3/core.h                         |   4 +-
 drivers/usb/dwc3/gadget.c                       |   1 +
 drivers/usb/host/xhci-pci.c                     |   1 -
 drivers/usb/host/xhci-ring.c                    |   2 +-
 drivers/usb/host/xhci.c                         |  13 +-
 drivers/usb/misc/sisusbvga/sisusb.c             |   1 +
 drivers/usb/serial/cp210x.c                     |   4 +
 drivers/usb/serial/mos7840.c                    |  26 ++--
 drivers/usb/serial/option.c                     |  23 ++--
 drivers/usb/serial/ti_usb_3410_5052.c           |   2 +-
 drivers/usb/storage/unusual_devs.h              |   7 ++
 drivers/virtio/virtio_ring.c                    |  59 +++++++--
 fs/btrfs/extent-tree.c                          |  13 ++
 fs/ext4/mballoc.c                               |  11 +-
 fs/lockd/svclock.c                              |   4 +
 fs/nfsd/vfs.c                                   |   5 +-
 fs/notify/fanotify/fanotify_user.c              |   1 +
 include/linux/if_pppox.h                        |   4 +-
 include/linux/virtio.h                          |   4 +
 include/net/addrconf.h                          |   3 +
 include/net/udp.h                               |   1 +
 include/xen/interface/io/ring.h                 |   5 +
 kernel/trace/trace.c                            |  10 +-
 net/8021q/vlan_dev.c                            |   7 ++
 net/9p/trans_common.c                           |  10 +-
 net/bridge/br_multicast.c                       |   5 +-
 net/core/neighbour.c                            |  12 +-
 net/ipv4/udp.c                                  |   3 +-
 net/ipv6/addrconf.c                             |  31 +++--
 net/ipv6/ip6_output.c                           |  24 ++--
 net/ipv6/mcast.c                                |  18 +--
 net/ipv6/udp.c                                  |   7 +-
 net/key/af_key.c                                |   2 +
 net/l2tp/l2tp_ppp.c                             |   3 +-
 net/x25/af_x25.c                                |  15 +--
 sound/arm/pxa2xx-pcm-lib.c                      |   2 +
 sound/pci/asihpi/asihpi.c                       |   3 +
 sound/pci/atiixp.c                              |   2 +
 sound/pci/atiixp_modem.c                        |   2 +
 sound/pci/hda/patch_hdmi.c                      |   4 +
 sound/soc/codecs/max98088.c                     |   2 +-
 sound/soc/codecs/sgtl5000.c                     |   2 +-
 sound/soc/codecs/sgtl5000.h                     |   2 +-
 sound/soc/s6000/s6000-pcm.c                     |   2 +
 sound/usb/6fire/pcm.c                           |  14 ++-
 sound/usb/misc/ua101.c                          |  14 ++-
 sound/usb/usx2y/usbusx2yaudio.c                 |   4 +
 78 files changed, 535 insertions(+), 285 deletions(-)

Aaron Plattner (2):
      ALSA: hda - Add new GPU codec ID to snd-hda
      ALSA: hda - Add new GPU codec ID to snd-hda

Alex Deucher (1):
      drm/radeon: improve dac adjust heuristics for legacy pdac

Alexandr \\\"Sky\\\" Ivanov (1):
      USB: option: add D-Link DWM-152/C1 and DWM-156/C1

Amerigo Wang (1):
      ipv6,mcast: always hold idev->lock before mca_lock

Andi Kleen (1):
      Fix incorrect memset in bnx2fc_parse_fcp_rsp

Anton Blanchard (1):
      powerpc/modules: Module CRC relocation fix causes perf issues

Barry Grussling (1):
      usb: cp210x support SEL C662 Vendor/Device

Ben Hutchings (1):
      Linux 3.2.50

Bj=C3=B8rn Mork (1):
      usb: option: add TP-LINK MA260

Changli Gao (1):
      net: Swap ver and type in pppoe_hdr

Chih-Chung Chang (1):
      ASoC: max98088 - fix element type of the register cache.

Dan Carpenter (1):
      fanotify: info leak in copy_event_to_user()

Dan Williams (1):
      usb: serial: option: add Olivetti Olicard 200

Daniil Bolsun (1):
      USB: option: append Petatel NP10T device to GSM modems list

Dave Jones (1):
      x25: Fix broken locking in ioctl error paths.

Dave Kleikamp (2):
      sunvnet: vnet_port_remove must call unregister_netdev
      sparc: tsb must be flushed before tlb

David Jeffery (1):
      lockd: protect nlm_blocked access in nlmsvc_retry_blocked

Eldad Zack (1):
      ALSA: usb-audio: 6fire: return correct XRUN indication

Enrico Mioso (3):
      usb: serial: option: Add ONYX 3G device support
      usb: serial: option: blacklist ONDA MT689DC QMI interface
      usb: serial: option.c: remove ONDA MT825UP product ID fromdriver

Eric Dumazet (3):
      ipv6: ip6_sk_dst_check() must not assume ipv6 dst
      neighbour: fix a race in neigh_destroy()
      vlan: fix a race in egress prio management

Ewan D. Milne (1):
      sd: fix crash when UA received on DIF enabled device

Fabio Estevam (2):
      ASoC: sglt5000: Fix the default value of CHIP_SSS_CTRL
      ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK

Felipe Balbi (1):
      usb: dwc3: gadget: don't prevent gadget from being probed if we fail

Gao feng (1):
      ipv6: don't call addrconf_dst_alloc again when enable lo

George Cherian (1):
      usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers wit=
h xhci 1.0

Hannes Frederic Sowa (2):
      ipv6: call udp_push_pending_frames when uncorking a socket with AF_IN=
ET pending data
      ipv6: ip6_append_data_mtu did not care about pmtudisc and frag_size

Harshula Jayasuriya (1):
      nfsd: nfsd_open: when dentry_open returns an error do not propagate a=
s struct file

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_type

Ian Abbott (2):
      staging: comedi: COMEDI_CANCEL ioctl should wake up read/write
      staging: comedi: fix a race between do_cmd_ioctl() and read/write

Jan Beulich (1):
      xen/io/ring.h: new macro to detect whether there are too many request=
s on the ring

Jason Wang (1):
      macvtap: correctly linearize skb when zerocopy is used

Jeff Skirvin (1):
      isci: Fix a race condition in the SSP task management path

Johan Hovold (2):
      USB: ti_usb_3410_5052: fix dynamic-id matching
      USB: mos7840: fix memory leak in open

Josef Bacik (2):
      Btrfs: fix lock leak when resuming snapshot deletion
      Btrfs: re-add root to dead root list if we stop dropping it

J=C3=B3hann B. Gu=C3=B0mundsson (1):
      USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga

Konrad Rzeszutek Wilk (1):
      xen/blkback: Check for insane amounts of request on the ring (v6).

Linus L=C3=BCssing (1):
      bridge: fix switched interval for MLD Query types

Luiz Angelo Daros de Luca (1):
      usb: serial: cp210x: Add USB ID for Netgear Switches embedded serial =
adapter

Mark Kettenis (1):
      drm/radeon: fix combios tables on older cards

Mathias Krause (1):
      af_key: fix info leaks in notify messages

Michael S. Tsirkin (3):
      macvtap: fix recovery from gup errors
      virtio: support unlocked queue poll
      virtio_net: fix race in RX VQ processing

Neil Horman (2):
      atl1e: fix dma mapping warnings
      atl1e: unmap partially mapped skb on dma error and free skb

Oleksij Rempel (1):
      xhci: fix null pointer dereference on ring_doorbell_for_active_rings

Olivier DANET (1):
      sparc32: vm_area_struct access for old Sun SPARCs.

Ondrej Zary (1):
      drm/radeon: Another card with wrong primary dac adj

Ren Bigcren (1):
      USB: storage: Add MicroVault Flash Drive to unusual_devs

Sami Rahman (1):
      USB: cp210x: add MMB and PI ZigBee USB Device Support

Sarah Sharp (1):
      xhci: Avoid NULL pointer deref when host dies.

Sasha Levin (1):
      9p: fix off by one causing access violations and memory corruption

Saurav Kashyap (1):
      qla2xxx: Properly set the tagging for commands.

Sergei Shtylyov (1):
      sh_eth: fix unhandled RFE interrupt

Steven Rostedt (Red Hat) (1):
      tracing: Use current_uid() for critical time tracing

Takashi Iwai (8):
      ALSA: asihpi: Fix unlocked snd_pcm_stop() call
      ALSA: atiixp: Fix unlocked snd_pcm_stop() call
      ALSA: 6fire: Fix unlocked snd_pcm_stop() call
      ALSA: ua101: Fix unlocked snd_pcm_stop() call
      ALSA: usx2y: Fix unlocked snd_pcm_stop() call
      ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call
      ASoC: s6000: Fix unlocked snd_pcm_stop() call
      staging: line6: Fix unlocked snd_pcm_stop() call

Theodore Ts'o (1):
      ext4: don't allow ext4_free_blocks() to fail due to ENOMEM

Toshi Kani (1):
      ACPI / memhotplug: Fix a stale pointer in error path

Wei Yongjun (1):
      l2tp: add missing .owner to struct pppox_proto

William Gulland (1):
      usb: Clear both buffers when clearing a control transfer TT buffer.

Youquan Song (1):
      ata: Fix DVD not dectected at some platform with Wellsburg PCH

bob picco (1):
      sparc64 address-congruence property

dingtianhong (3):
      ifb: fix rcu_sched self-detected stalls
      dummy: fix oops when loading the dummy failed
      ifb: fix oops when loading the ifb failed



--=-FKkQ2AAH8Owp7TStfoHb
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.50.patch"
Content-Disposition: attachment; filename="linux-3.2.50.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUNCmluZGV4IDJlM2Q3OTEuLjA3OTllOGUg
MTAwNjQ0DQotLS0gYS9NYWtlZmlsZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0xLDYgKzEsNiBAQA0K
IFZFUlNJT04gPSAzDQogUEFUQ0hMRVZFTCA9IDINCi1TVUJMRVZFTCA9IDQ5DQorU1VCTEVWRUwg
PSA1MA0KIEVYVFJBVkVSU0lPTiA9DQogTkFNRSA9IFNhYmVyLXRvb3RoZWQgU3F1aXJyZWwNCiAN
CmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vbW9kdWxlLmggYi9hcmNoL3Bv
d2VycGMvaW5jbHVkZS9hc20vbW9kdWxlLmgNCmluZGV4IDAxOTJhNGUuLjgwZGU2NGIgMTAwNjQ0
DQotLS0gYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vbW9kdWxlLmgNCisrKyBiL2FyY2gvcG93
ZXJwYy9pbmNsdWRlL2FzbS9tb2R1bGUuaA0KQEAgLTg3LDEwICs4Nyw5IEBAIHN0cnVjdCBleGNl
cHRpb25fdGFibGVfZW50cnk7DQogdm9pZCBzb3J0X2V4X3RhYmxlKHN0cnVjdCBleGNlcHRpb25f
dGFibGVfZW50cnkgKnN0YXJ0LA0KIAkJICAgc3RydWN0IGV4Y2VwdGlvbl90YWJsZV9lbnRyeSAq
ZmluaXNoKTsNCiANCi0jaWZkZWYgQ09ORklHX01PRFZFUlNJT05TDQorI2lmIGRlZmluZWQoQ09O
RklHX01PRFZFUlNJT05TKSAmJiBkZWZpbmVkKENPTkZJR19QUEM2NCkNCiAjZGVmaW5lIEFSQ0hf
UkVMT0NBVEVTX0tDUkNUQUINCi0NCi1leHRlcm4gY29uc3QgdW5zaWduZWQgbG9uZyByZWxvY19z
dGFydFtdOw0KKyNkZWZpbmUgcmVsb2Nfc3RhcnQgUEhZU0lDQUxfU1RBUlQNCiAjZW5kaWYNCiAj
ZW5kaWYgLyogX19LRVJORUxfXyAqLw0KICNlbmRpZgkvKiBfQVNNX1BPV0VSUENfTU9EVUxFX0gg
Ki8NCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMva2VybmVsL3ZtbGludXgubGRzLlMgYi9hcmNo
L3Bvd2VycGMva2VybmVsL3ZtbGludXgubGRzLlMNCmluZGV4IDkyMDI3NmMuLjNlOGZlNGIgMTAw
NjQ0DQotLS0gYS9hcmNoL3Bvd2VycGMva2VybmVsL3ZtbGludXgubGRzLlMNCisrKyBiL2FyY2gv
cG93ZXJwYy9rZXJuZWwvdm1saW51eC5sZHMuUw0KQEAgLTM4LDkgKzM4LDYgQEAgamlmZmllcyA9
IGppZmZpZXNfNjQgKyA0Ow0KICNlbmRpZg0KIFNFQ1RJT05TDQogew0KLQkuID0gMDsNCi0JcmVs
b2Nfc3RhcnQgPSAuOw0KLQ0KIAkuID0gS0VSTkVMQkFTRTsNCiANCiAvKg0KZGlmZiAtLWdpdCBh
L2FyY2gvc3BhcmMva2VybmVsL2FzbS1vZmZzZXRzLmMgYi9hcmNoL3NwYXJjL2tlcm5lbC9hc20t
b2Zmc2V0cy5jDQppbmRleCA2OGY3ZTExLi5jZTQ4MjAzIDEwMDY0NA0KLS0tIGEvYXJjaC9zcGFy
Yy9rZXJuZWwvYXNtLW9mZnNldHMuYw0KKysrIGIvYXJjaC9zcGFyYy9rZXJuZWwvYXNtLW9mZnNl
dHMuYw0KQEAgLTM0LDYgKzM0LDggQEAgaW50IGZvbyh2b2lkKQ0KIAlERUZJTkUoQU9GRl90YXNr
X3RocmVhZCwgb2Zmc2V0b2Yoc3RydWN0IHRhc2tfc3RydWN0LCB0aHJlYWQpKTsNCiAJQkxBTkso
KTsNCiAJREVGSU5FKEFPRkZfbW1fY29udGV4dCwgb2Zmc2V0b2Yoc3RydWN0IG1tX3N0cnVjdCwg
Y29udGV4dCkpOw0KKwlCTEFOSygpOw0KKwlERUZJTkUoVk1BX1ZNX01NLCAgICBvZmZzZXRvZihz
dHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QsIHZtX21tKSk7DQogDQogCS8qIERFRklORShOVU1fVVNFUl9T
RUdNRU5UUywgVEFTS19TSVpFPj4yOCk7ICovDQogCXJldHVybiAwOw0KZGlmZiAtLWdpdCBhL2Fy
Y2gvc3BhcmMvbW0vaHlwZXJzcGFyYy5TIGIvYXJjaC9zcGFyYy9tbS9oeXBlcnNwYXJjLlMNCmlu
ZGV4IDQ0YWFkMzIuLjk2OWY5NjQgMTAwNjQ0DQotLS0gYS9hcmNoL3NwYXJjL21tL2h5cGVyc3Bh
cmMuUw0KKysrIGIvYXJjaC9zcGFyYy9tbS9oeXBlcnNwYXJjLlMNCkBAIC03NCw3ICs3NCw3IEBA
IGh5cGVyc3BhcmNfZmx1c2hfY2FjaGVfbW1fb3V0Og0KIA0KIAkvKiBUaGUgdGhpbmdzIHdlIGRv
IGZvciBwZXJmb3JtYW5jZS4uLiAqLw0KIGh5cGVyc3BhcmNfZmx1c2hfY2FjaGVfcmFuZ2U6DQot
CWxkCVslbzAgKyAweDBdLCAlbzAJCS8qIFhYWCB2bWEtPnZtX21tLCBHUk9TUyBYWFggKi8NCisJ
bGQJWyVvMCArIFZNQV9WTV9NTV0sICVvMA0KICNpZm5kZWYgQ09ORklHX1NNUA0KIAlsZAlbJW8w
ICsgQU9GRl9tbV9jb250ZXh0XSwgJWcxDQogCWNtcAklZzEsIC0xDQpAQCAtMTYzLDcgKzE2Myw3
IEBAIGh5cGVyc3BhcmNfZmx1c2hfY2FjaGVfcmFuZ2Vfb3V0Og0KIAkgKi8NCiAJLyogVmVyaWZp
ZWQsIG15IGFzcy4uLiAqLw0KIGh5cGVyc3BhcmNfZmx1c2hfY2FjaGVfcGFnZToNCi0JbGQJWyVv
MCArIDB4MF0sICVvMAkJLyogWFhYIHZtYS0+dm1fbW0sIEdST1NTIFhYWCAqLw0KKwlsZAlbJW8w
ICsgVk1BX1ZNX01NXSwgJW8wDQogCWxkCVslbzAgKyBBT0ZGX21tX2NvbnRleHRdLCAlZzINCiAj
aWZuZGVmIENPTkZJR19TTVANCiAJY21wCSVnMiwgLTENCkBAIC0yODQsNyArMjg0LDcgQEAgaHlw
ZXJzcGFyY19mbHVzaF90bGJfbW1fb3V0Og0KIAkgc3RhCSVnNSwgWyVnMV0gQVNJX01fTU1VUkVH
Uw0KIA0KIGh5cGVyc3BhcmNfZmx1c2hfdGxiX3JhbmdlOg0KLQlsZAlbJW8wICsgMHgwMF0sICVv
MAkvKiBYWFggdm1hLT52bV9tbSBHUk9TUyBYWFggKi8NCisJbGQJWyVvMCArIFZNQV9WTV9NTV0s
ICVvMA0KIAltb3YJU1JNTVVfQ1RYX1JFRywgJWcxDQogCWxkCVslbzAgKyBBT0ZGX21tX2NvbnRl
eHRdLCAlbzMNCiAJbGRhCVslZzFdIEFTSV9NX01NVVJFR1MsICVnNQ0KQEAgLTMwNyw3ICszMDcs
NyBAQCBoeXBlcnNwYXJjX2ZsdXNoX3RsYl9yYW5nZV9vdXQ6DQogCSBzdGEJJWc1LCBbJWcxXSBB
U0lfTV9NTVVSRUdTDQogDQogaHlwZXJzcGFyY19mbHVzaF90bGJfcGFnZToNCi0JbGQJWyVvMCAr
IDB4MDBdLCAlbzAJLyogWFhYIHZtYS0+dm1fbW0gR1JPU1MgWFhYICovDQorCWxkCVslbzAgKyBW
TUFfVk1fTU1dLCAlbzANCiAJbW92CVNSTU1VX0NUWF9SRUcsICVnMQ0KIAlsZAlbJW8wICsgQU9G
Rl9tbV9jb250ZXh0XSwgJW8zDQogCWFuZG4JJW8xLCAoUEFHRV9TSVpFIC0gMSksICVvMQ0KZGlm
ZiAtLWdpdCBhL2FyY2gvc3BhcmMvbW0vaW5pdF82NC5jIGIvYXJjaC9zcGFyYy9tbS9pbml0XzY0
LmMNCmluZGV4IDZmZjRkNzguLmI0OTg5ZjkgMTAwNjQ0DQotLS0gYS9hcmNoL3NwYXJjL21tL2lu
aXRfNjQuYw0KKysrIGIvYXJjaC9zcGFyYy9tbS9pbml0XzY0LmMNCkBAIC0xMDcxLDcgKzEwNzEs
MTQgQEAgc3RhdGljIGludCBfX2luaXQgZ3JhYl9tYmxvY2tzKHN0cnVjdCBtZGVzY19oYW5kbGUg
Km1kKQ0KIAkJbS0+c2l6ZSA9ICp2YWw7DQogCQl2YWwgPSBtZGVzY19nZXRfcHJvcGVydHkobWQs
IG5vZGUsDQogCQkJCQkgImFkZHJlc3MtY29uZ3J1ZW5jZS1vZmZzZXQiLCBOVUxMKTsNCi0JCW0t
Pm9mZnNldCA9ICp2YWw7DQorDQorCQkvKiBUaGUgYWRkcmVzcy1jb25ncnVlbmNlLW9mZnNldCBw
cm9wZXJ0eSBpcyBvcHRpb25hbC4NCisJCSAqIEV4cGxpY2l0eSB6ZXJvIGl0IGJlIGlkZW50aWZ0
eSB0aGlzLg0KKwkJICovDQorCQlpZiAodmFsKQ0KKwkJCW0tPm9mZnNldCA9ICp2YWw7DQorCQll
bHNlDQorCQkJbS0+b2Zmc2V0ID0gMFVMOw0KIA0KIAkJbnVtYWRiZygiTUJMT0NLWyVkXTogYmFz
ZVslbGx4XSBzaXplWyVsbHhdIG9mZnNldFslbGx4XVxuIiwNCiAJCQljb3VudCAtIDEsIG0tPmJh
c2UsIG0tPnNpemUsIG0tPm9mZnNldCk7DQpkaWZmIC0tZ2l0IGEvYXJjaC9zcGFyYy9tbS9zd2lm
dC5TIGIvYXJjaC9zcGFyYy9tbS9zd2lmdC5TDQppbmRleCBjODAxYzM5Li41ZDJiODhkIDEwMDY0
NA0KLS0tIGEvYXJjaC9zcGFyYy9tbS9zd2lmdC5TDQorKysgYi9hcmNoL3NwYXJjL21tL3N3aWZ0
LlMNCkBAIC0xMDUsNyArMTA1LDcgQEAgc3dpZnRfZmx1c2hfY2FjaGVfbW1fb3V0Og0KIA0KIAku
Z2xvYmwJc3dpZnRfZmx1c2hfY2FjaGVfcmFuZ2UNCiBzd2lmdF9mbHVzaF9jYWNoZV9yYW5nZToN
Ci0JbGQJWyVvMCArIDB4MF0sICVvMAkJLyogWFhYIHZtYS0+dm1fbW0sIEdST1NTIFhYWCAqLw0K
KwlsZAlbJW8wICsgVk1BX1ZNX01NXSwgJW8wDQogCXN1YgklbzIsICVvMSwgJW8yDQogCXNldGhp
CSVoaSg0MDk2KSwgJW8zDQogCWNtcAklbzIsICVvMw0KQEAgLTExNiw3ICsxMTYsNyBAQCBzd2lm
dF9mbHVzaF9jYWNoZV9yYW5nZToNCiANCiAJLmdsb2JsCXN3aWZ0X2ZsdXNoX2NhY2hlX3BhZ2UN
CiBzd2lmdF9mbHVzaF9jYWNoZV9wYWdlOg0KLQlsZAlbJW8wICsgMHgwXSwgJW8wCQkvKiBYWFgg
dm1hLT52bV9tbSwgR1JPU1MgWFhYICovDQorCWxkCVslbzAgKyBWTUFfVk1fTU1dLCAlbzANCiA3
MDoNCiAJbGQJWyVvMCArIEFPRkZfbW1fY29udGV4dF0sICVnMg0KIAljbXAJJWcyLCAtMQ0KQEAg
LTIxOSw3ICsyMTksNyBAQCBzd2lmdF9mbHVzaF9zaWdfaW5zbnM6DQogCS5nbG9ibAlzd2lmdF9m
bHVzaF90bGJfcmFuZ2UNCiAJLmdsb2JsCXN3aWZ0X2ZsdXNoX3RsYl9hbGwNCiBzd2lmdF9mbHVz
aF90bGJfcmFuZ2U6DQotCWxkCVslbzAgKyAweDAwXSwgJW8wCS8qIFhYWCB2bWEtPnZtX21tIEdS
T1NTIFhYWCAqLw0KKwlsZAlbJW8wICsgVk1BX1ZNX01NXSwgJW8wDQogc3dpZnRfZmx1c2hfdGxi
X21tOg0KIAlsZAlbJW8wICsgQU9GRl9tbV9jb250ZXh0XSwgJWcyDQogCWNtcAklZzIsIC0xDQpA
QCAtMjMzLDcgKzIzMyw3IEBAIHN3aWZ0X2ZsdXNoX3RsYl9hbGxfb3V0Og0KIA0KIAkuZ2xvYmwJ
c3dpZnRfZmx1c2hfdGxiX3BhZ2UNCiBzd2lmdF9mbHVzaF90bGJfcGFnZToNCi0JbGQJWyVvMCAr
IDB4MDBdLCAlbzAJLyogWFhYIHZtYS0+dm1fbW0gR1JPU1MgWFhYICovDQorCWxkCVslbzAgKyBW
TUFfVk1fTU1dLCAlbzANCiAJbW92CVNSTU1VX0NUWF9SRUcsICVnMQ0KIAlsZAlbJW8wICsgQU9G
Rl9tbV9jb250ZXh0XSwgJW8zDQogCWFuZG4JJW8xLCAoUEFHRV9TSVpFIC0gMSksICVvMQ0KZGlm
ZiAtLWdpdCBhL2FyY2gvc3BhcmMvbW0vdGxiLmMgYi9hcmNoL3NwYXJjL21tL3RsYi5jDQppbmRl
eCBhZmQwMjFlLi4wNzJmNTUzIDEwMDY0NA0KLS0tIGEvYXJjaC9zcGFyYy9tbS90bGIuYw0KKysr
IGIvYXJjaC9zcGFyYy9tbS90bGIuYw0KQEAgLTExNSw4ICsxMTUsOCBAQCBub19jYWNoZV9mbHVz
aDoNCiAJfQ0KIA0KIAlpZiAoIXRiLT5hY3RpdmUpIHsNCi0JCWdsb2JhbF9mbHVzaF90bGJfcGFn
ZShtbSwgdmFkZHIpOw0KIAkJZmx1c2hfdHNiX3VzZXJfcGFnZShtbSwgdmFkZHIpOw0KKwkJZ2xv
YmFsX2ZsdXNoX3RsYl9wYWdlKG1tLCB2YWRkcik7DQogCQlnb3RvIG91dDsNCiAJfQ0KIA0KZGlm
ZiAtLWdpdCBhL2FyY2gvc3BhcmMvbW0vdHN1bmFtaS5TIGIvYXJjaC9zcGFyYy9tbS90c3VuYW1p
LlMNCmluZGV4IDRlNTVlOGYuLmJmMTBhMzQgMTAwNjQ0DQotLS0gYS9hcmNoL3NwYXJjL21tL3Rz
dW5hbWkuUw0KKysrIGIvYXJjaC9zcGFyYy9tbS90c3VuYW1pLlMNCkBAIC0yNCw3ICsyNCw3IEBA
DQogCS8qIFNsaWlpY2suLi4gKi8NCiB0c3VuYW1pX2ZsdXNoX2NhY2hlX3BhZ2U6DQogdHN1bmFt
aV9mbHVzaF9jYWNoZV9yYW5nZToNCi0JbGQJWyVvMCArIDB4MF0sICVvMAkvKiBYWFggdm1hLT52
bV9tbSwgR1JPU1MgWFhYICovDQorCWxkCVslbzAgKyBWTUFfVk1fTU1dLCAlbzANCiB0c3VuYW1p
X2ZsdXNoX2NhY2hlX21tOg0KIAlsZAlbJW8wICsgQU9GRl9tbV9jb250ZXh0XSwgJWcyDQogCWNt
cAklZzIsIC0xDQpAQCAtNDYsNyArNDYsNyBAQCB0c3VuYW1pX2ZsdXNoX3NpZ19pbnNuczoNCiAN
CiAJLyogTW9yZSBzbGljayBzdHVmZi4uLiAqLw0KIHRzdW5hbWlfZmx1c2hfdGxiX3JhbmdlOg0K
LQlsZAlbJW8wICsgMHgwMF0sICVvMAkvKiBYWFggdm1hLT52bV9tbSBHUk9TUyBYWFggKi8NCisJ
bGQJWyVvMCArIFZNQV9WTV9NTV0sICVvMA0KIHRzdW5hbWlfZmx1c2hfdGxiX21tOg0KIAlsZAlb
JW8wICsgQU9GRl9tbV9jb250ZXh0XSwgJWcyDQogCWNtcAklZzIsIC0xDQpAQCAtNjUsNyArNjUs
NyBAQCB0c3VuYW1pX2ZsdXNoX3RsYl9vdXQ6DQogDQogCS8qIFRoaXMgb25lIGNhbiBiZSBkb25l
IGluIGEgZmluZSBncmFpbmVkIG1hbm5lci4uLiAqLw0KIHRzdW5hbWlfZmx1c2hfdGxiX3BhZ2U6
DQotCWxkCVslbzAgKyAweDAwXSwgJW8wCS8qIFhYWCB2bWEtPnZtX21tIEdST1NTIFhYWCAqLw0K
KwlsZAlbJW8wICsgVk1BX1ZNX01NXSwgJW8wDQogCW1vdglTUk1NVV9DVFhfUkVHLCAlZzENCiAJ
bGQJWyVvMCArIEFPRkZfbW1fY29udGV4dF0sICVvMw0KIAlhbmRuCSVvMSwgKFBBR0VfU0laRSAt
IDEpLCAlbzENCmRpZmYgLS1naXQgYS9hcmNoL3NwYXJjL21tL3Zpa2luZy5TIGIvYXJjaC9zcGFy
Yy9tbS92aWtpbmcuUw0KaW5kZXggNmRmY2MxMy4uYTUxNjM3MiAxMDA2NDQNCi0tLSBhL2FyY2gv
c3BhcmMvbW0vdmlraW5nLlMNCisrKyBiL2FyY2gvc3BhcmMvbW0vdmlraW5nLlMNCkBAIC0xMDks
NyArMTA5LDcgQEAgdmlraW5nX214Y2NfZmx1c2hfcGFnZToNCiB2aWtpbmdfZmx1c2hfY2FjaGVf
cGFnZToNCiB2aWtpbmdfZmx1c2hfY2FjaGVfcmFuZ2U6DQogI2lmbmRlZiBDT05GSUdfU01QDQot
CWxkCVslbzAgKyAweDBdLCAlbzAJCS8qIFhYWCB2bWEtPnZtX21tLCBHUk9TUyBYWFggKi8NCisJ
bGQJWyVvMCArIFZNQV9WTV9NTV0sICVvMA0KICNlbmRpZg0KIHZpa2luZ19mbHVzaF9jYWNoZV9t
bToNCiAjaWZuZGVmIENPTkZJR19TTVANCkBAIC0xNDksNyArMTQ5LDcgQEAgdmlraW5nX2ZsdXNo
X3RsYl9tbToNCiAjZW5kaWYNCiANCiB2aWtpbmdfZmx1c2hfdGxiX3JhbmdlOg0KLQlsZAlbJW8w
ICsgMHgwMF0sICVvMAkvKiBYWFggdm1hLT52bV9tbSBHUk9TUyBYWFggKi8NCisJbGQJWyVvMCAr
IFZNQV9WTV9NTV0sICVvMA0KIAltb3YJU1JNTVVfQ1RYX1JFRywgJWcxDQogCWxkCVslbzAgKyBB
T0ZGX21tX2NvbnRleHRdLCAlbzMNCiAJbGRhCVslZzFdIEFTSV9NX01NVVJFR1MsICVnNQ0KQEAg
LTE3NCw3ICsxNzQsNyBAQCB2aWtpbmdfZmx1c2hfdGxiX3JhbmdlOg0KICNlbmRpZg0KIA0KIHZp
a2luZ19mbHVzaF90bGJfcGFnZToNCi0JbGQJWyVvMCArIDB4MDBdLCAlbzAJLyogWFhYIHZtYS0+
dm1fbW0gR1JPU1MgWFhYICovDQorCWxkCVslbzAgKyBWTUFfVk1fTU1dLCAlbzANCiAJbW92CVNS
TU1VX0NUWF9SRUcsICVnMQ0KIAlsZAlbJW8wICsgQU9GRl9tbV9jb250ZXh0XSwgJW8zDQogCWxk
YQlbJWcxXSBBU0lfTV9NTVVSRUdTLCAlZzUNCkBAIC0yNDAsNyArMjQwLDcgQEAgc3VuNGRzbXBf
Zmx1c2hfdGxiX3JhbmdlOg0KIAl0c3QJJWc1DQogCWJuZQkzZg0KIAkgbW92CVNSTU1VX0NUWF9S
RUcsICVnMQ0KLQlsZAlbJW8wICsgMHgwMF0sICVvMAkvKiBYWFggdm1hLT52bV9tbSBHUk9TUyBY
WFggKi8NCisJbGQJWyVvMCArIFZNQV9WTV9NTV0sICVvMA0KIAlsZAlbJW8wICsgQU9GRl9tbV9j
b250ZXh0XSwgJW8zDQogCWxkYQlbJWcxXSBBU0lfTV9NTVVSRUdTLCAlZzUNCiAJc2V0aGkJJWhp
KH4oKDEgPDwgU1JNTVVfUEdESVJfU0hJRlQpIC0gMSkpLCAlbzQNCkBAIC0yNjYsNyArMjY2LDcg
QEAgc3VuNGRzbXBfZmx1c2hfdGxiX3BhZ2U6DQogCXRzdAklZzUNCiAJYm5lCTJmDQogCSBtb3YJ
U1JNTVVfQ1RYX1JFRywgJWcxDQotCWxkCVslbzAgKyAweDAwXSwgJW8wCS8qIFhYWCB2bWEtPnZt
X21tIEdST1NTIFhYWCAqLw0KKwlsZAlbJW8wICsgVk1BX1ZNX01NXSwgJW8wDQogCWxkCVslbzAg
KyBBT0ZGX21tX2NvbnRleHRdLCAlbzMNCiAJbGRhCVslZzFdIEFTSV9NX01NVVJFR1MsICVnNQ0K
IAlhbmQJJW8xLCBQQUdFX01BU0ssICVvMQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9hY3Bp
X21lbWhvdHBsdWcuYyBiL2RyaXZlcnMvYWNwaS9hY3BpX21lbWhvdHBsdWcuYw0KaW5kZXggZDk4
NTcxMy4uZjgxNTk3ZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYWNwaS9hY3BpX21lbWhvdHBsdWcu
Yw0KKysrIGIvZHJpdmVycy9hY3BpL2FjcGlfbWVtaG90cGx1Zy5jDQpAQCAtNDIxLDYgKzQyMSw3
IEBAIHN0YXRpYyBpbnQgYWNwaV9tZW1vcnlfZGV2aWNlX2FkZChzdHJ1Y3QgYWNwaV9kZXZpY2Ug
KmRldmljZSkNCiAJLyogR2V0IHRoZSByYW5nZSBmcm9tIHRoZSBfQ1JTICovDQogCXJlc3VsdCA9
IGFjcGlfbWVtb3J5X2dldF9kZXZpY2VfcmVzb3VyY2VzKG1lbV9kZXZpY2UpOw0KIAlpZiAocmVz
dWx0KSB7DQorCQlkZXZpY2UtPmRyaXZlcl9kYXRhID0gTlVMTDsNCiAJCWtmcmVlKG1lbV9kZXZp
Y2UpOw0KIAkJcmV0dXJuIHJlc3VsdDsNCiAJfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYXRhL2F0
YV9waWl4LmMgYi9kcml2ZXJzL2F0YS9hdGFfcGlpeC5jDQppbmRleCA3YTk0OWFmLi41YjBiNWY3
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9hdGEvYXRhX3BpaXguYw0KKysrIGIvZHJpdmVycy9hdGEv
YXRhX3BpaXguYw0KQEAgLTM1Miw3ICszNTIsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHBjaV9k
ZXZpY2VfaWQgcGlpeF9wY2lfdGJsW10gPSB7DQogCS8qIFNBVEEgQ29udHJvbGxlciBJREUgKFdl
bGxzYnVyZykgKi8NCiAJeyAweDgwODYsIDB4OGQwMCwgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwg
MCwgMCwgaWNoOF9zYXRhX3NuYiB9LA0KIAkvKiBTQVRBIENvbnRyb2xsZXIgSURFIChXZWxsc2J1
cmcpICovDQotCXsgMHg4MDg2LCAweDhkMDgsIFBDSV9BTllfSUQsIFBDSV9BTllfSUQsIDAsIDAs
IGljaDhfMnBvcnRfc2F0YSB9LA0KKwl7IDB4ODA4NiwgMHg4ZDA4LCBQQ0lfQU5ZX0lELCBQQ0lf
QU5ZX0lELCAwLCAwLCBpY2g4XzJwb3J0X3NhdGFfc25iIH0sDQogCS8qIFNBVEEgQ29udHJvbGxl
ciBJREUgKFdlbGxzYnVyZykgKi8NCiAJeyAweDgwODYsIDB4OGQ2MCwgUENJX0FOWV9JRCwgUENJ
X0FOWV9JRCwgMCwgMCwgaWNoOF9zYXRhX3NuYiB9LA0KIAkvKiBTQVRBIENvbnRyb2xsZXIgSURF
IChXZWxsc2J1cmcpICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9jay94ZW4tYmxrYmFjay9i
bGtiYWNrLmMgYi9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL2Jsa2JhY2suYw0KaW5kZXggODVm
ZGQ0Yi4uMjIzMmI4NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2svYmxr
YmFjay5jDQorKysgYi9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL2Jsa2JhY2suYw0KQEAgLTI3
Nyw2ICsyNzcsNyBAQCBpbnQgeGVuX2Jsa2lmX3NjaGVkdWxlKHZvaWQgKmFyZykNCiB7DQogCXN0
cnVjdCB4ZW5fYmxraWYgKmJsa2lmID0gYXJnOw0KIAlzdHJ1Y3QgeGVuX3ZiZCAqdmJkID0gJmJs
a2lmLT52YmQ7DQorCWludCByZXQ7DQogDQogCXhlbl9ibGtpZl9nZXQoYmxraWYpOw0KIA0KQEAg
LTI5Nyw4ICsyOTgsMTIgQEAgaW50IHhlbl9ibGtpZl9zY2hlZHVsZSh2b2lkICphcmcpDQogCQli
bGtpZi0+d2FpdGluZ19yZXFzID0gMDsNCiAJCXNtcF9tYigpOyAvKiBjbGVhciBmbGFnICpiZWZv
cmUqIGNoZWNraW5nIGZvciB3b3JrICovDQogDQotCQlpZiAoZG9fYmxvY2tfaW9fb3AoYmxraWYp
KQ0KKwkJcmV0ID0gZG9fYmxvY2tfaW9fb3AoYmxraWYpOw0KKwkJaWYgKHJldCA+IDApDQogCQkJ
YmxraWYtPndhaXRpbmdfcmVxcyA9IDE7DQorCQlpZiAocmV0ID09IC1FQUNDRVMpDQorCQkJd2Fp
dF9ldmVudF9pbnRlcnJ1cHRpYmxlKGJsa2lmLT5zaHV0ZG93bl93cSwNCisJCQkJCQkga3RocmVh
ZF9zaG91bGRfc3RvcCgpKTsNCiANCiAJCWlmIChsb2dfc3RhdHMgJiYgdGltZV9hZnRlcihqaWZm
aWVzLCBibGtpZi0+c3RfcHJpbnQpKQ0KIAkJCXByaW50X3N0YXRzKGJsa2lmKTsNCkBAIC01Mzks
NiArNTQ0LDEyIEBAIF9fZG9fYmxvY2tfaW9fb3Aoc3RydWN0IHhlbl9ibGtpZiAqYmxraWYpDQog
CXJwID0gYmxrX3JpbmdzLT5jb21tb24uc3JpbmctPnJlcV9wcm9kOw0KIAlybWIoKTsgLyogRW5z
dXJlIHdlIHNlZSBxdWV1ZWQgcmVxdWVzdHMgdXAgdG8gJ3JwJy4gKi8NCiANCisJaWYgKFJJTkdf
UkVRVUVTVF9QUk9EX09WRVJGTE9XKCZibGtfcmluZ3MtPmNvbW1vbiwgcnApKSB7DQorCQlyYyA9
IGJsa19yaW5ncy0+Y29tbW9uLnJzcF9wcm9kX3B2dDsNCisJCXByX3dhcm4oRFJWX1BGWCAiRnJv
bnRlbmQgcHJvdmlkZWQgYm9ndXMgcmluZyByZXF1ZXN0cyAoJWQgLSAlZCA9ICVkKS4gSGFsdGlu
ZyByaW5nIHByb2Nlc3Npbmcgb24gZGV2PSUwNHhcbiIsDQorCQkJcnAsIHJjLCBycCAtIHJjLCBi
bGtpZi0+dmJkLnBkZXZpY2UpOw0KKwkJcmV0dXJuIC1FQUNDRVM7DQorCX0NCiAJd2hpbGUgKHJj
ICE9IHJwKSB7DQogDQogCQlpZiAoUklOR19SRVFVRVNUX0NPTlNfT1ZFUkZMT1coJmJsa19yaW5n
cy0+Y29tbW9uLCByYykpDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9jay94ZW4tYmxrYmFjay9j
b21tb24uaCBiL2RyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2svY29tbW9uLmgNCmluZGV4IGRmYjFi
M2EuLmY2Nzk4NWQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL2NvbW1v
bi5oDQorKysgYi9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL2NvbW1vbi5oDQpAQCAtMTk4LDYg
KzE5OCw4IEBAIHN0cnVjdCB4ZW5fYmxraWYgew0KIAlpbnQJCQlzdF93cl9zZWN0Ow0KIA0KIAl3
YWl0X3F1ZXVlX2hlYWRfdAl3YWl0aW5nX3RvX2ZyZWU7DQorCS8qIFRocmVhZCBzaHV0ZG93biB3
YWl0IHF1ZXVlLiAqLw0KKwl3YWl0X3F1ZXVlX2hlYWRfdAlzaHV0ZG93bl93cTsNCiB9Ow0KIA0K
IA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2sveGVuYnVzLmMgYi9kcml2
ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL3hlbmJ1cy5jDQppbmRleCA2NzRlM2MyLi43N2FlZDI2IDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9ibG9jay94ZW4tYmxrYmFjay94ZW5idXMuYw0KKysrIGIvZHJp
dmVycy9ibG9jay94ZW4tYmxrYmFjay94ZW5idXMuYw0KQEAgLTExOCw2ICsxMTgsNyBAQCBzdGF0
aWMgc3RydWN0IHhlbl9ibGtpZiAqeGVuX2Jsa2lmX2FsbG9jKGRvbWlkX3QgZG9taWQpDQogCWF0
b21pY19zZXQoJmJsa2lmLT5kcmFpbiwgMCk7DQogCWJsa2lmLT5zdF9wcmludCA9IGppZmZpZXM7
DQogCWluaXRfd2FpdHF1ZXVlX2hlYWQoJmJsa2lmLT53YWl0aW5nX3RvX2ZyZWUpOw0KKwlpbml0
X3dhaXRxdWV1ZV9oZWFkKCZibGtpZi0+c2h1dGRvd25fd3EpOw0KIA0KIAlyZXR1cm4gYmxraWY7
DQogfQ0KQEAgLTE3OCw2ICsxNzksNyBAQCBzdGF0aWMgdm9pZCB4ZW5fYmxraWZfZGlzY29ubmVj
dChzdHJ1Y3QgeGVuX2Jsa2lmICpibGtpZikNCiB7DQogCWlmIChibGtpZi0+eGVuYmxrZCkgew0K
IAkJa3RocmVhZF9zdG9wKGJsa2lmLT54ZW5ibGtkKTsNCisJCXdha2VfdXAoJmJsa2lmLT5zaHV0
ZG93bl93cSk7DQogCQlibGtpZi0+eGVuYmxrZCA9IE5VTEw7DQogCX0NCiANCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9jb21iaW9zLmMgYi9kcml2ZXJzL2dwdS9k
cm0vcmFkZW9uL3JhZGVvbl9jb21iaW9zLmMNCmluZGV4IGMzMmZkOTMuLjgxMTU1NTcgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9jb21iaW9zLmMNCisrKyBiL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2NvbWJpb3MuYw0KQEAgLTE0Nyw3ICsxNDcsNyBA
QCBzdGF0aWMgdWludDE2X3QgY29tYmlvc19nZXRfdGFibGVfb2Zmc2V0KHN0cnVjdCBkcm1fZGV2
aWNlICpkZXYsDQogCQkJCQkgZW51bSByYWRlb25fY29tYmlvc190YWJsZV9vZmZzZXQgdGFibGUp
DQogew0KIAlzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldiA9IGRldi0+ZGV2X3ByaXZhdGU7DQot
CWludCByZXY7DQorCWludCByZXYsIHNpemU7DQogCXVpbnQxNl90IG9mZnNldCA9IDAsIGNoZWNr
X29mZnNldDsNCiANCiAJaWYgKCFyZGV2LT5iaW9zKQ0KQEAgLTE1NiwxNzQgKzE1NiwxMDYgQEAg
c3RhdGljIHVpbnQxNl90IGNvbWJpb3NfZ2V0X3RhYmxlX29mZnNldChzdHJ1Y3QgZHJtX2Rldmlj
ZSAqZGV2LA0KIAlzd2l0Y2ggKHRhYmxlKSB7DQogCQkvKiBhYnNvbHV0ZSBvZmZzZXQgdGFibGVz
ICovDQogCWNhc2UgQ09NQklPU19BU0lDX0lOSVRfMV9UQUJMRToNCi0JCWNoZWNrX29mZnNldCA9
IFJCSU9TMTYocmRldi0+Ymlvc19oZWFkZXJfc3RhcnQgKyAweGMpOw0KLQkJaWYgKGNoZWNrX29m
ZnNldCkNCi0JCQlvZmZzZXQgPSBjaGVja19vZmZzZXQ7DQorCQljaGVja19vZmZzZXQgPSAweGM7
DQogCQlicmVhazsNCiAJY2FzZSBDT01CSU9TX0JJT1NfU1VQUE9SVF9UQUJMRToNCi0JCWNoZWNr
X29mZnNldCA9IFJCSU9TMTYocmRldi0+Ymlvc19oZWFkZXJfc3RhcnQgKyAweDE0KTsNCi0JCWlm
IChjaGVja19vZmZzZXQpDQotCQkJb2Zmc2V0ID0gY2hlY2tfb2Zmc2V0Ow0KKwkJY2hlY2tfb2Zm
c2V0ID0gMHgxNDsNCiAJCWJyZWFrOw0KIAljYXNlIENPTUJJT1NfREFDX1BST0dSQU1NSU5HX1RB
QkxFOg0KLQkJY2hlY2tfb2Zmc2V0ID0gUkJJT1MxNihyZGV2LT5iaW9zX2hlYWRlcl9zdGFydCAr
IDB4MmEpOw0KLQkJaWYgKGNoZWNrX29mZnNldCkNCi0JCQlvZmZzZXQgPSBjaGVja19vZmZzZXQ7
DQorCQljaGVja19vZmZzZXQgPSAweDJhOw0KIAkJYnJlYWs7DQogCWNhc2UgQ09NQklPU19NQVhf
Q09MT1JfREVQVEhfVEFCTEU6DQotCQljaGVja19vZmZzZXQgPSBSQklPUzE2KHJkZXYtPmJpb3Nf
aGVhZGVyX3N0YXJ0ICsgMHgyYyk7DQotCQlpZiAoY2hlY2tfb2Zmc2V0KQ0KLQkJCW9mZnNldCA9
IGNoZWNrX29mZnNldDsNCisJCWNoZWNrX29mZnNldCA9IDB4MmM7DQogCQlicmVhazsNCiAJY2Fz
ZSBDT01CSU9TX0NSVENfSU5GT19UQUJMRToNCi0JCWNoZWNrX29mZnNldCA9IFJCSU9TMTYocmRl
di0+Ymlvc19oZWFkZXJfc3RhcnQgKyAweDJlKTsNCi0JCWlmIChjaGVja19vZmZzZXQpDQotCQkJ
b2Zmc2V0ID0gY2hlY2tfb2Zmc2V0Ow0KKwkJY2hlY2tfb2Zmc2V0ID0gMHgyZTsNCiAJCWJyZWFr
Ow0KIAljYXNlIENPTUJJT1NfUExMX0lORk9fVEFCTEU6DQotCQljaGVja19vZmZzZXQgPSBSQklP
UzE2KHJkZXYtPmJpb3NfaGVhZGVyX3N0YXJ0ICsgMHgzMCk7DQotCQlpZiAoY2hlY2tfb2Zmc2V0
KQ0KLQkJCW9mZnNldCA9IGNoZWNrX29mZnNldDsNCisJCWNoZWNrX29mZnNldCA9IDB4MzA7DQog
CQlicmVhazsNCiAJY2FzZSBDT01CSU9TX1RWX0lORk9fVEFCTEU6DQotCQljaGVja19vZmZzZXQg
PSBSQklPUzE2KHJkZXYtPmJpb3NfaGVhZGVyX3N0YXJ0ICsgMHgzMik7DQotCQlpZiAoY2hlY2tf
b2Zmc2V0KQ0KLQkJCW9mZnNldCA9IGNoZWNrX29mZnNldDsNCisJCWNoZWNrX29mZnNldCA9IDB4
MzI7DQogCQlicmVhazsNCiAJY2FzZSBDT01CSU9TX0RGUF9JTkZPX1RBQkxFOg0KLQkJY2hlY2tf
b2Zmc2V0ID0gUkJJT1MxNihyZGV2LT5iaW9zX2hlYWRlcl9zdGFydCArIDB4MzQpOw0KLQkJaWYg
KGNoZWNrX29mZnNldCkNCi0JCQlvZmZzZXQgPSBjaGVja19vZmZzZXQ7DQorCQljaGVja19vZmZz
ZXQgPSAweDM0Ow0KIAkJYnJlYWs7DQogCWNhc2UgQ09NQklPU19IV19DT05GSUdfSU5GT19UQUJM
RToNCi0JCWNoZWNrX29mZnNldCA9IFJCSU9TMTYocmRldi0+Ymlvc19oZWFkZXJfc3RhcnQgKyAw
eDM2KTsNCi0JCWlmIChjaGVja19vZmZzZXQpDQotCQkJb2Zmc2V0ID0gY2hlY2tfb2Zmc2V0Ow0K
KwkJY2hlY2tfb2Zmc2V0ID0gMHgzNjsNCiAJCWJyZWFrOw0KIAljYXNlIENPTUJJT1NfTVVMVElN
RURJQV9JTkZPX1RBQkxFOg0KLQkJY2hlY2tfb2Zmc2V0ID0gUkJJT1MxNihyZGV2LT5iaW9zX2hl
YWRlcl9zdGFydCArIDB4MzgpOw0KLQkJaWYgKGNoZWNrX29mZnNldCkNCi0JCQlvZmZzZXQgPSBj
aGVja19vZmZzZXQ7DQorCQljaGVja19vZmZzZXQgPSAweDM4Ow0KIAkJYnJlYWs7DQogCWNhc2Ug
Q09NQklPU19UVl9TVERfUEFUQ0hfVEFCTEU6DQotCQljaGVja19vZmZzZXQgPSBSQklPUzE2KHJk
ZXYtPmJpb3NfaGVhZGVyX3N0YXJ0ICsgMHgzZSk7DQotCQlpZiAoY2hlY2tfb2Zmc2V0KQ0KLQkJ
CW9mZnNldCA9IGNoZWNrX29mZnNldDsNCisJCWNoZWNrX29mZnNldCA9IDB4M2U7DQogCQlicmVh
azsNCiAJY2FzZSBDT01CSU9TX0xDRF9JTkZPX1RBQkxFOg0KLQkJY2hlY2tfb2Zmc2V0ID0gUkJJ
T1MxNihyZGV2LT5iaW9zX2hlYWRlcl9zdGFydCArIDB4NDApOw0KLQkJaWYgKGNoZWNrX29mZnNl
dCkNCi0JCQlvZmZzZXQgPSBjaGVja19vZmZzZXQ7DQorCQljaGVja19vZmZzZXQgPSAweDQwOw0K
IAkJYnJlYWs7DQogCWNhc2UgQ09NQklPU19NT0JJTEVfSU5GT19UQUJMRToNCi0JCWNoZWNrX29m
ZnNldCA9IFJCSU9TMTYocmRldi0+Ymlvc19oZWFkZXJfc3RhcnQgKyAweDQyKTsNCi0JCWlmIChj
aGVja19vZmZzZXQpDQotCQkJb2Zmc2V0ID0gY2hlY2tfb2Zmc2V0Ow0KKwkJY2hlY2tfb2Zmc2V0
ID0gMHg0MjsNCiAJCWJyZWFrOw0KIAljYXNlIENPTUJJT1NfUExMX0lOSVRfVEFCTEU6DQotCQlj
aGVja19vZmZzZXQgPSBSQklPUzE2KHJkZXYtPmJpb3NfaGVhZGVyX3N0YXJ0ICsgMHg0Nik7DQot
CQlpZiAoY2hlY2tfb2Zmc2V0KQ0KLQkJCW9mZnNldCA9IGNoZWNrX29mZnNldDsNCisJCWNoZWNr
X29mZnNldCA9IDB4NDY7DQogCQlicmVhazsNCiAJY2FzZSBDT01CSU9TX01FTV9DT05GSUdfVEFC
TEU6DQotCQljaGVja19vZmZzZXQgPSBSQklPUzE2KHJkZXYtPmJpb3NfaGVhZGVyX3N0YXJ0ICsg
MHg0OCk7DQotCQlpZiAoY2hlY2tfb2Zmc2V0KQ0KLQkJCW9mZnNldCA9IGNoZWNrX29mZnNldDsN
CisJCWNoZWNrX29mZnNldCA9IDB4NDg7DQogCQlicmVhazsNCiAJY2FzZSBDT01CSU9TX1NBVkVf
TUFTS19UQUJMRToNCi0JCWNoZWNrX29mZnNldCA9IFJCSU9TMTYocmRldi0+Ymlvc19oZWFkZXJf
c3RhcnQgKyAweDRhKTsNCi0JCWlmIChjaGVja19vZmZzZXQpDQotCQkJb2Zmc2V0ID0gY2hlY2tf
b2Zmc2V0Ow0KKwkJY2hlY2tfb2Zmc2V0ID0gMHg0YTsNCiAJCWJyZWFrOw0KIAljYXNlIENPTUJJ
T1NfSEFSRENPREVEX0VESURfVEFCTEU6DQotCQljaGVja19vZmZzZXQgPSBSQklPUzE2KHJkZXYt
PmJpb3NfaGVhZGVyX3N0YXJ0ICsgMHg0Yyk7DQotCQlpZiAoY2hlY2tfb2Zmc2V0KQ0KLQkJCW9m
ZnNldCA9IGNoZWNrX29mZnNldDsNCisJCWNoZWNrX29mZnNldCA9IDB4NGM7DQogCQlicmVhazsN
CiAJY2FzZSBDT01CSU9TX0FTSUNfSU5JVF8yX1RBQkxFOg0KLQkJY2hlY2tfb2Zmc2V0ID0gUkJJ
T1MxNihyZGV2LT5iaW9zX2hlYWRlcl9zdGFydCArIDB4NGUpOw0KLQkJaWYgKGNoZWNrX29mZnNl
dCkNCi0JCQlvZmZzZXQgPSBjaGVja19vZmZzZXQ7DQorCQljaGVja19vZmZzZXQgPSAweDRlOw0K
IAkJYnJlYWs7DQogCWNhc2UgQ09NQklPU19DT05ORUNUT1JfSU5GT19UQUJMRToNCi0JCWNoZWNr
X29mZnNldCA9IFJCSU9TMTYocmRldi0+Ymlvc19oZWFkZXJfc3RhcnQgKyAweDUwKTsNCi0JCWlm
IChjaGVja19vZmZzZXQpDQotCQkJb2Zmc2V0ID0gY2hlY2tfb2Zmc2V0Ow0KKwkJY2hlY2tfb2Zm
c2V0ID0gMHg1MDsNCiAJCWJyZWFrOw0KIAljYXNlIENPTUJJT1NfRFlOX0NMS18xX1RBQkxFOg0K
LQkJY2hlY2tfb2Zmc2V0ID0gUkJJT1MxNihyZGV2LT5iaW9zX2hlYWRlcl9zdGFydCArIDB4NTIp
Ow0KLQkJaWYgKGNoZWNrX29mZnNldCkNCi0JCQlvZmZzZXQgPSBjaGVja19vZmZzZXQ7DQorCQlj
aGVja19vZmZzZXQgPSAweDUyOw0KIAkJYnJlYWs7DQogCWNhc2UgQ09NQklPU19SRVNFUlZFRF9N
RU1fVEFCTEU6DQotCQljaGVja19vZmZzZXQgPSBSQklPUzE2KHJkZXYtPmJpb3NfaGVhZGVyX3N0
YXJ0ICsgMHg1NCk7DQotCQlpZiAoY2hlY2tfb2Zmc2V0KQ0KLQkJCW9mZnNldCA9IGNoZWNrX29m
ZnNldDsNCisJCWNoZWNrX29mZnNldCA9IDB4NTQ7DQogCQlicmVhazsNCiAJY2FzZSBDT01CSU9T
X0VYVF9UTURTX0lORk9fVEFCTEU6DQotCQljaGVja19vZmZzZXQgPSBSQklPUzE2KHJkZXYtPmJp
b3NfaGVhZGVyX3N0YXJ0ICsgMHg1OCk7DQotCQlpZiAoY2hlY2tfb2Zmc2V0KQ0KLQkJCW9mZnNl
dCA9IGNoZWNrX29mZnNldDsNCisJCWNoZWNrX29mZnNldCA9IDB4NTg7DQogCQlicmVhazsNCiAJ
Y2FzZSBDT01CSU9TX01FTV9DTEtfSU5GT19UQUJMRToNCi0JCWNoZWNrX29mZnNldCA9IFJCSU9T
MTYocmRldi0+Ymlvc19oZWFkZXJfc3RhcnQgKyAweDVhKTsNCi0JCWlmIChjaGVja19vZmZzZXQp
DQotCQkJb2Zmc2V0ID0gY2hlY2tfb2Zmc2V0Ow0KKwkJY2hlY2tfb2Zmc2V0ID0gMHg1YTsNCiAJ
CWJyZWFrOw0KIAljYXNlIENPTUJJT1NfRVhUX0RBQ19JTkZPX1RBQkxFOg0KLQkJY2hlY2tfb2Zm
c2V0ID0gUkJJT1MxNihyZGV2LT5iaW9zX2hlYWRlcl9zdGFydCArIDB4NWMpOw0KLQkJaWYgKGNo
ZWNrX29mZnNldCkNCi0JCQlvZmZzZXQgPSBjaGVja19vZmZzZXQ7DQorCQljaGVja19vZmZzZXQg
PSAweDVjOw0KIAkJYnJlYWs7DQogCWNhc2UgQ09NQklPU19NSVNDX0lORk9fVEFCTEU6DQotCQlj
aGVja19vZmZzZXQgPSBSQklPUzE2KHJkZXYtPmJpb3NfaGVhZGVyX3N0YXJ0ICsgMHg1ZSk7DQot
CQlpZiAoY2hlY2tfb2Zmc2V0KQ0KLQkJCW9mZnNldCA9IGNoZWNrX29mZnNldDsNCisJCWNoZWNr
X29mZnNldCA9IDB4NWU7DQogCQlicmVhazsNCiAJY2FzZSBDT01CSU9TX0NSVF9JTkZPX1RBQkxF
Og0KLQkJY2hlY2tfb2Zmc2V0ID0gUkJJT1MxNihyZGV2LT5iaW9zX2hlYWRlcl9zdGFydCArIDB4
NjApOw0KLQkJaWYgKGNoZWNrX29mZnNldCkNCi0JCQlvZmZzZXQgPSBjaGVja19vZmZzZXQ7DQor
CQljaGVja19vZmZzZXQgPSAweDYwOw0KIAkJYnJlYWs7DQogCWNhc2UgQ09NQklPU19JTlRFR1JB
VEVEX1NZU1RFTV9JTkZPX1RBQkxFOg0KLQkJY2hlY2tfb2Zmc2V0ID0gUkJJT1MxNihyZGV2LT5i
aW9zX2hlYWRlcl9zdGFydCArIDB4NjIpOw0KLQkJaWYgKGNoZWNrX29mZnNldCkNCi0JCQlvZmZz
ZXQgPSBjaGVja19vZmZzZXQ7DQorCQljaGVja19vZmZzZXQgPSAweDYyOw0KIAkJYnJlYWs7DQog
CWNhc2UgQ09NQklPU19DT01QT05FTlRfVklERU9fSU5GT19UQUJMRToNCi0JCWNoZWNrX29mZnNl
dCA9IFJCSU9TMTYocmRldi0+Ymlvc19oZWFkZXJfc3RhcnQgKyAweDY0KTsNCi0JCWlmIChjaGVj
a19vZmZzZXQpDQotCQkJb2Zmc2V0ID0gY2hlY2tfb2Zmc2V0Ow0KKwkJY2hlY2tfb2Zmc2V0ID0g
MHg2NDsNCiAJCWJyZWFrOw0KIAljYXNlIENPTUJJT1NfRkFOX1NQRUVEX0lORk9fVEFCTEU6DQot
CQljaGVja19vZmZzZXQgPSBSQklPUzE2KHJkZXYtPmJpb3NfaGVhZGVyX3N0YXJ0ICsgMHg2Nik7
DQotCQlpZiAoY2hlY2tfb2Zmc2V0KQ0KLQkJCW9mZnNldCA9IGNoZWNrX29mZnNldDsNCisJCWNo
ZWNrX29mZnNldCA9IDB4NjY7DQogCQlicmVhazsNCiAJY2FzZSBDT01CSU9TX09WRVJEUklWRV9J
TkZPX1RBQkxFOg0KLQkJY2hlY2tfb2Zmc2V0ID0gUkJJT1MxNihyZGV2LT5iaW9zX2hlYWRlcl9z
dGFydCArIDB4NjgpOw0KLQkJaWYgKGNoZWNrX29mZnNldCkNCi0JCQlvZmZzZXQgPSBjaGVja19v
ZmZzZXQ7DQorCQljaGVja19vZmZzZXQgPSAweDY4Ow0KIAkJYnJlYWs7DQogCWNhc2UgQ09NQklP
U19PRU1fSU5GT19UQUJMRToNCi0JCWNoZWNrX29mZnNldCA9IFJCSU9TMTYocmRldi0+Ymlvc19o
ZWFkZXJfc3RhcnQgKyAweDZhKTsNCi0JCWlmIChjaGVja19vZmZzZXQpDQotCQkJb2Zmc2V0ID0g
Y2hlY2tfb2Zmc2V0Ow0KKwkJY2hlY2tfb2Zmc2V0ID0gMHg2YTsNCiAJCWJyZWFrOw0KIAljYXNl
IENPTUJJT1NfRFlOX0NMS18yX1RBQkxFOg0KLQkJY2hlY2tfb2Zmc2V0ID0gUkJJT1MxNihyZGV2
LT5iaW9zX2hlYWRlcl9zdGFydCArIDB4NmMpOw0KLQkJaWYgKGNoZWNrX29mZnNldCkNCi0JCQlv
ZmZzZXQgPSBjaGVja19vZmZzZXQ7DQorCQljaGVja19vZmZzZXQgPSAweDZjOw0KIAkJYnJlYWs7
DQogCWNhc2UgQ09NQklPU19QT1dFUl9DT05ORUNUT1JfSU5GT19UQUJMRToNCi0JCWNoZWNrX29m
ZnNldCA9IFJCSU9TMTYocmRldi0+Ymlvc19oZWFkZXJfc3RhcnQgKyAweDZlKTsNCi0JCWlmIChj
aGVja19vZmZzZXQpDQotCQkJb2Zmc2V0ID0gY2hlY2tfb2Zmc2V0Ow0KKwkJY2hlY2tfb2Zmc2V0
ID0gMHg2ZTsNCiAJCWJyZWFrOw0KIAljYXNlIENPTUJJT1NfSTJDX0lORk9fVEFCTEU6DQotCQlj
aGVja19vZmZzZXQgPSBSQklPUzE2KHJkZXYtPmJpb3NfaGVhZGVyX3N0YXJ0ICsgMHg3MCk7DQot
CQlpZiAoY2hlY2tfb2Zmc2V0KQ0KLQkJCW9mZnNldCA9IGNoZWNrX29mZnNldDsNCisJCWNoZWNr
X29mZnNldCA9IDB4NzA7DQogCQlicmVhazsNCiAJCS8qIHJlbGF0aXZlIG9mZnNldCB0YWJsZXMg
Ki8NCiAJY2FzZSBDT01CSU9TX0FTSUNfSU5JVF8zX1RBQkxFOgkvKiBvZmZzZXQgZnJvbSBtaXNj
IGluZm8gKi8NCkBAIC00MzksMTEgKzM3MSwxNiBAQCBzdGF0aWMgdWludDE2X3QgY29tYmlvc19n
ZXRfdGFibGVfb2Zmc2V0KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYsDQogCQl9DQogCQlicmVhazsN
CiAJZGVmYXVsdDoNCisJCWNoZWNrX29mZnNldCA9IDA7DQogCQlicmVhazsNCiAJfQ0KIA0KLQly
ZXR1cm4gb2Zmc2V0Ow0KKwlzaXplID0gUkJJT1M4KHJkZXYtPmJpb3NfaGVhZGVyX3N0YXJ0ICsg
MHg2KTsNCisJLyogY2hlY2sgYWJzb2x1dGUgb2Zmc2V0IHRhYmxlcyAqLw0KKwlpZiAodGFibGUg
PCBDT01CSU9TX0FTSUNfSU5JVF8zX1RBQkxFICYmIGNoZWNrX29mZnNldCAmJiBjaGVja19vZmZz
ZXQgPCBzaXplKQ0KKwkJb2Zmc2V0ID0gUkJJT1MxNihyZGV2LT5iaW9zX2hlYWRlcl9zdGFydCAr
IGNoZWNrX29mZnNldCk7DQogDQorCXJldHVybiBvZmZzZXQ7DQogfQ0KIA0KIGJvb2wgcmFkZW9u
X2NvbWJpb3NfY2hlY2tfaGFyZGNvZGVkX2VkaWQoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYp
DQpAQCAtOTUzLDE2ICs4OTAsMjIgQEAgc3RydWN0IHJhZGVvbl9lbmNvZGVyX3ByaW1hcnlfZGFj
ICpyYWRlb25fY29tYmlvc19nZXRfcHJpbWFyeV9kYWNfaW5mbyhzdHJ1Y3QNCiAJCQlkYWMgPSBS
QklPUzgoZGFjX2luZm8gKyAweDMpICYgMHhmOw0KIAkJCXBfZGFjLT5wczJfcGRhY19hZGogPSAo
YmcgPDwgOCkgfCAoZGFjKTsNCiAJCX0NCi0JCS8qIGlmIHRoZSB2YWx1ZXMgYXJlIGFsbCB6ZXJv
cywgdXNlIHRoZSB0YWJsZSAqLw0KLQkJaWYgKHBfZGFjLT5wczJfcGRhY19hZGopDQorCQkvKiBp
ZiB0aGUgdmFsdWVzIGFyZSB6ZXJvcywgdXNlIHRoZSB0YWJsZSAqLw0KKwkJaWYgKChkYWMgPT0g
MCkgfHwgKGJnID09IDApKQ0KKwkJCWZvdW5kID0gMDsNCisJCWVsc2UNCiAJCQlmb3VuZCA9IDE7
DQogCX0NCiANCiAJLyogcXVpcmtzICovDQorCS8qIFJhZGVvbiA3MDAwIChSVjEwMCkgKi8NCisJ
aWYgKCgoZGV2LT5wZGV2LT5kZXZpY2UgPT0gMHg1MTU5KSAmJg0KKwkgICAgKGRldi0+cGRldi0+
c3Vic3lzdGVtX3ZlbmRvciA9PSAweDE3NEIpICYmDQorCSAgICAoZGV2LT5wZGV2LT5zdWJzeXN0
ZW1fZGV2aWNlID09IDB4N2MyOCkpIHx8DQogCS8qIFJhZGVvbiA5MTAwIChSMjAwKSAqLw0KLQlp
ZiAoKGRldi0+cGRldi0+ZGV2aWNlID09IDB4NTE0RCkgJiYNCisJICAgKChkZXYtPnBkZXYtPmRl
dmljZSA9PSAweDUxNEQpICYmDQogCSAgICAoZGV2LT5wZGV2LT5zdWJzeXN0ZW1fdmVuZG9yID09
IDB4MTc0QikgJiYNCi0JICAgIChkZXYtPnBkZXYtPnN1YnN5c3RlbV9kZXZpY2UgPT0gMHg3MTQ5
KSkgew0KKwkgICAgKGRldi0+cGRldi0+c3Vic3lzdGVtX2RldmljZSA9PSAweDcxNDkpKSkgew0K
IAkJLyogdmJpb3MgdmFsdWUgaXMgYmFkLCB1c2UgdGhlIGRlZmF1bHQgKi8NCiAJCWZvdW5kID0g
MDsNCiAJfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2R1bW15LmMgYi9kcml2ZXJzL25ldC9k
dW1teS5jDQppbmRleCA2OGZlNzNjLi45OWIxMTQ1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQv
ZHVtbXkuYw0KKysrIGIvZHJpdmVycy9uZXQvZHVtbXkuYw0KQEAgLTE4Niw2ICsxODYsOCBAQCBz
dGF0aWMgaW50IF9faW5pdCBkdW1teV9pbml0X21vZHVsZSh2b2lkKQ0KIA0KIAlydG5sX2xvY2so
KTsNCiAJZXJyID0gX19ydG5sX2xpbmtfcmVnaXN0ZXIoJmR1bW15X2xpbmtfb3BzKTsNCisJaWYg
KGVyciA8IDApDQorCQlnb3RvIG91dDsNCiANCiAJZm9yIChpID0gMDsgaSA8IG51bWR1bW1pZXMg
JiYgIWVycjsgaSsrKSB7DQogCQllcnIgPSBkdW1teV9pbml0X29uZSgpOw0KQEAgLTE5Myw2ICsx
OTUsOCBAQCBzdGF0aWMgaW50IF9faW5pdCBkdW1teV9pbml0X21vZHVsZSh2b2lkKQ0KIAl9DQog
CWlmIChlcnIgPCAwKQ0KIAkJX19ydG5sX2xpbmtfdW5yZWdpc3RlcigmZHVtbXlfbGlua19vcHMp
Ow0KKw0KK291dDoNCiAJcnRubF91bmxvY2soKTsNCiANCiAJcmV0dXJuIGVycjsNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hdGhlcm9zL2F0bDFlL2F0bDFlX21haW4uYyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2F0aGVyb3MvYXRsMWUvYXRsMWVfbWFpbi5jDQppbmRleCBkZDg5
M2IzLi44Nzg1MWYwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXRoZXJvcy9h
dGwxZS9hdGwxZV9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2F0aGVyb3MvYXRs
MWUvYXRsMWVfbWFpbi5jDQpAQCAtMTY4NSw4ICsxNjg1LDggQEAgY2hlY2tfc3VtOg0KIAlyZXR1
cm4gMDsNCiB9DQogDQotc3RhdGljIHZvaWQgYXRsMWVfdHhfbWFwKHN0cnVjdCBhdGwxZV9hZGFw
dGVyICphZGFwdGVyLA0KLQkJICAgICAgc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGF0bDFl
X3RwZF9kZXNjICp0cGQpDQorc3RhdGljIGludCBhdGwxZV90eF9tYXAoc3RydWN0IGF0bDFlX2Fk
YXB0ZXIgKmFkYXB0ZXIsDQorCQkJc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGF0bDFlX3Rw
ZF9kZXNjICp0cGQpDQogew0KIAlzdHJ1Y3QgYXRsMWVfdHBkX2Rlc2MgKnVzZV90cGQgPSBOVUxM
Ow0KIAlzdHJ1Y3QgYXRsMWVfdHhfYnVmZmVyICp0eF9idWZmZXIgPSBOVUxMOw0KQEAgLTE2OTcs
NiArMTY5Nyw4IEBAIHN0YXRpYyB2b2lkIGF0bDFlX3R4X21hcChzdHJ1Y3QgYXRsMWVfYWRhcHRl
ciAqYWRhcHRlciwNCiAJdTE2IG5yX2ZyYWdzOw0KIAl1MTYgZjsNCiAJaW50IHNlZ21lbnQ7DQor
CWludCByaW5nX3N0YXJ0ID0gYWRhcHRlci0+dHhfcmluZy5uZXh0X3RvX3VzZTsNCisJaW50IHJp
bmdfZW5kOw0KIA0KIAlucl9mcmFncyA9IHNrYl9zaGluZm8oc2tiKS0+bnJfZnJhZ3M7DQogCXNl
Z21lbnQgPSAodHBkLT53b3JkMyA+PiBUUERfU0VHTUVOVF9FTl9TSElGVCkgJiBUUERfU0VHTUVO
VF9FTl9NQVNLOw0KQEAgLTE3MDksNiArMTcxMSw5IEBAIHN0YXRpYyB2b2lkIGF0bDFlX3R4X21h
cChzdHJ1Y3QgYXRsMWVfYWRhcHRlciAqYWRhcHRlciwNCiAJCXR4X2J1ZmZlci0+bGVuZ3RoID0g
bWFwX2xlbjsNCiAJCXR4X2J1ZmZlci0+ZG1hID0gcGNpX21hcF9zaW5nbGUoYWRhcHRlci0+cGRl
diwNCiAJCQkJCXNrYi0+ZGF0YSwgaGRyX2xlbiwgUENJX0RNQV9UT0RFVklDRSk7DQorCQlpZiAo
ZG1hX21hcHBpbmdfZXJyb3IoJmFkYXB0ZXItPnBkZXYtPmRldiwgdHhfYnVmZmVyLT5kbWEpKQ0K
KwkJCXJldHVybiAtRU5PU1BDOw0KKw0KIAkJQVRMMUVfU0VUX1BDSU1BUF9UWVBFKHR4X2J1ZmZl
ciwgQVRMMUVfVFhfUENJTUFQX1NJTkdMRSk7DQogCQltYXBwZWRfbGVuICs9IG1hcF9sZW47DQog
CQl1c2VfdHBkLT5idWZmZXJfYWRkciA9IGNwdV90b19sZTY0KHR4X2J1ZmZlci0+ZG1hKTsNCkBA
IC0xNzM1LDYgKzE3NDAsMjIgQEAgc3RhdGljIHZvaWQgYXRsMWVfdHhfbWFwKHN0cnVjdCBhdGwx
ZV9hZGFwdGVyICphZGFwdGVyLA0KIAkJdHhfYnVmZmVyLT5kbWEgPQ0KIAkJCXBjaV9tYXBfc2lu
Z2xlKGFkYXB0ZXItPnBkZXYsIHNrYi0+ZGF0YSArIG1hcHBlZF9sZW4sDQogCQkJCQltYXBfbGVu
LCBQQ0lfRE1BX1RPREVWSUNFKTsNCisNCisJCWlmIChkbWFfbWFwcGluZ19lcnJvcigmYWRhcHRl
ci0+cGRldi0+ZGV2LCB0eF9idWZmZXItPmRtYSkpIHsNCisJCQkvKiBXZSBuZWVkIHRvIHVud2lu
ZCB0aGUgbWFwcGluZ3Mgd2UndmUgZG9uZSAqLw0KKwkJCXJpbmdfZW5kID0gYWRhcHRlci0+dHhf
cmluZy5uZXh0X3RvX3VzZTsNCisJCQlhZGFwdGVyLT50eF9yaW5nLm5leHRfdG9fdXNlID0gcmlu
Z19zdGFydDsNCisJCQl3aGlsZSAoYWRhcHRlci0+dHhfcmluZy5uZXh0X3RvX3VzZSAhPSByaW5n
X2VuZCkgew0KKwkJCQl0cGQgPSBhdGwxZV9nZXRfdHBkKGFkYXB0ZXIpOw0KKwkJCQl0eF9idWZm
ZXIgPSBhdGwxZV9nZXRfdHhfYnVmZmVyKGFkYXB0ZXIsIHRwZCk7DQorCQkJCXBjaV91bm1hcF9z
aW5nbGUoYWRhcHRlci0+cGRldiwgdHhfYnVmZmVyLT5kbWEsDQorCQkJCQkJIHR4X2J1ZmZlci0+
bGVuZ3RoLCBQQ0lfRE1BX1RPREVWSUNFKTsNCisJCQl9DQorCQkJLyogUmVzZXQgdGhlIHR4IHJp
bmdzIG5leHQgcG9pbnRlciAqLw0KKwkJCWFkYXB0ZXItPnR4X3JpbmcubmV4dF90b191c2UgPSBy
aW5nX3N0YXJ0Ow0KKwkJCXJldHVybiAtRU5PU1BDOw0KKwkJfQ0KKw0KIAkJQVRMMUVfU0VUX1BD
SU1BUF9UWVBFKHR4X2J1ZmZlciwgQVRMMUVfVFhfUENJTUFQX1NJTkdMRSk7DQogCQltYXBwZWRf
bGVuICArPSBtYXBfbGVuOw0KIAkJdXNlX3RwZC0+YnVmZmVyX2FkZHIgPSBjcHVfdG9fbGU2NCh0
eF9idWZmZXItPmRtYSk7DQpAQCAtMTc3MCw2ICsxNzkxLDIzIEBAIHN0YXRpYyB2b2lkIGF0bDFl
X3R4X21hcChzdHJ1Y3QgYXRsMWVfYWRhcHRlciAqYWRhcHRlciwNCiAJCQkJCQkJICAoaSAqIE1B
WF9UWF9CVUZfTEVOKSwNCiAJCQkJCQkJICB0eF9idWZmZXItPmxlbmd0aCwNCiAJCQkJCQkJICBE
TUFfVE9fREVWSUNFKTsNCisNCisJCQlpZiAoZG1hX21hcHBpbmdfZXJyb3IoJmFkYXB0ZXItPnBk
ZXYtPmRldiwgdHhfYnVmZmVyLT5kbWEpKSB7DQorCQkJCS8qIFdlIG5lZWQgdG8gdW53aW5kIHRo
ZSBtYXBwaW5ncyB3ZSd2ZSBkb25lICovDQorCQkJCXJpbmdfZW5kID0gYWRhcHRlci0+dHhfcmlu
Zy5uZXh0X3RvX3VzZTsNCisJCQkJYWRhcHRlci0+dHhfcmluZy5uZXh0X3RvX3VzZSA9IHJpbmdf
c3RhcnQ7DQorCQkJCXdoaWxlIChhZGFwdGVyLT50eF9yaW5nLm5leHRfdG9fdXNlICE9IHJpbmdf
ZW5kKSB7DQorCQkJCQl0cGQgPSBhdGwxZV9nZXRfdHBkKGFkYXB0ZXIpOw0KKwkJCQkJdHhfYnVm
ZmVyID0gYXRsMWVfZ2V0X3R4X2J1ZmZlcihhZGFwdGVyLCB0cGQpOw0KKwkJCQkJZG1hX3VubWFw
X3BhZ2UoJmFkYXB0ZXItPnBkZXYtPmRldiwgdHhfYnVmZmVyLT5kbWEsDQorCQkJCQkJICAgICAg
IHR4X2J1ZmZlci0+bGVuZ3RoLCBETUFfVE9fREVWSUNFKTsNCisJCQkJfQ0KKw0KKwkJCQkvKiBS
ZXNldCB0aGUgcmluZyBuZXh0IHRvIHVzZSBwb2ludGVyICovDQorCQkJCWFkYXB0ZXItPnR4X3Jp
bmcubmV4dF90b191c2UgPSByaW5nX3N0YXJ0Ow0KKwkJCQlyZXR1cm4gLUVOT1NQQzsNCisJCQl9
DQorDQogCQkJQVRMMUVfU0VUX1BDSU1BUF9UWVBFKHR4X2J1ZmZlciwgQVRMMUVfVFhfUENJTUFQ
X1BBR0UpOw0KIAkJCXVzZV90cGQtPmJ1ZmZlcl9hZGRyID0gY3B1X3RvX2xlNjQodHhfYnVmZmVy
LT5kbWEpOw0KIAkJCXVzZV90cGQtPndvcmQyID0gKHVzZV90cGQtPndvcmQyICYgKH5UUERfQlVG
TEVOX01BU0spKSB8DQpAQCAtMTc4Nyw2ICsxODI1LDcgQEAgc3RhdGljIHZvaWQgYXRsMWVfdHhf
bWFwKHN0cnVjdCBhdGwxZV9hZGFwdGVyICphZGFwdGVyLA0KIAkvKiBUaGUgbGFzdCBidWZmZXIg
aW5mbyBjb250YWluIHRoZSBza2IgYWRkcmVzcywNCiAJICAgc28gaXQgd2lsbCBiZSBmcmVlIGFm
dGVyIHVubWFwICovDQogCXR4X2J1ZmZlci0+c2tiID0gc2tiOw0KKwlyZXR1cm4gMDsNCiB9DQog
DQogc3RhdGljIHZvaWQgYXRsMWVfdHhfcXVldWUoc3RydWN0IGF0bDFlX2FkYXB0ZXIgKmFkYXB0
ZXIsIHUxNiBjb3VudCwNCkBAIC0xODU0LDEwICsxODkzLDE1IEBAIHN0YXRpYyBuZXRkZXZfdHhf
dCBhdGwxZV94bWl0X2ZyYW1lKHN0cnVjdCBza19idWZmICpza2IsDQogCQlyZXR1cm4gTkVUREVW
X1RYX09LOw0KIAl9DQogDQotCWF0bDFlX3R4X21hcChhZGFwdGVyLCBza2IsIHRwZCk7DQorCWlm
IChhdGwxZV90eF9tYXAoYWRhcHRlciwgc2tiLCB0cGQpKSB7DQorCQlkZXZfa2ZyZWVfc2tiX2Fu
eShza2IpOw0KKwkJZ290byBvdXQ7DQorCX0NCisNCiAJYXRsMWVfdHhfcXVldWUoYWRhcHRlciwg
dHBkX3JlcSwgdHBkKTsNCiANCiAJbmV0ZGV2LT50cmFuc19zdGFydCA9IGppZmZpZXM7IC8qIE5F
VElGX0ZfTExUWCBkcml2ZXIgOiggKi8NCitvdXQ6DQogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
JmFkYXB0ZXItPnR4X2xvY2ssIGZsYWdzKTsNCiAJcmV0dXJuIE5FVERFVl9UWF9PSzsNCiB9DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9zaF9ldGguYyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvc2hfZXRoLmMNCmluZGV4IDliMjMwNzQuLmIyMDc3Y2Eg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3NoX2V0aC5jDQorKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3NoX2V0aC5jDQpAQCAtMTM2LDggKzEzNiw5
IEBAIHN0YXRpYyBzdHJ1Y3Qgc2hfZXRoX2NwdV9kYXRhIHNoX2V0aF9teV9jcHVfZGF0YSA9IHsN
CiAJLnJtY3JfdmFsdWUJPSAweDAwMDAwMDAxLA0KIA0KIAkudHhfY2hlY2sJPSBFRVNSX0ZUQyB8
IEVFU1JfQ05EIHwgRUVTUl9ETEMgfCBFRVNSX0NEIHwgRUVTUl9SVE8sDQotCS5lZXNyX2Vycl9j
aGVjawk9IEVFU1JfVFdCIHwgRUVTUl9UQUJUIHwgRUVTUl9SQUJUIHwgRUVTUl9SREUgfA0KLQkJ
CSAgRUVTUl9SRlJNRVIgfCBFRVNSX1RGRSB8IEVFU1JfVERFIHwgRUVTUl9FQ0ksDQorCS5lZXNy
X2Vycl9jaGVjawk9IEVFU1JfVFdCIHwgRUVTUl9UQUJUIHwgRUVTUl9SQUJUIHwgRUVTUl9SRkUg
fA0KKwkJCSAgRUVTUl9SREUgfCBFRVNSX1JGUk1FUiB8IEVFU1JfVEZFIHwgRUVTUl9UREUgfA0K
KwkJCSAgRUVTUl9FQ0ksDQogCS50eF9lcnJvcl9jaGVjawk9IEVFU1JfVFdCIHwgRUVTUl9UQUJU
IHwgRUVTUl9UREUgfCBFRVNSX1RGRSwNCiANCiAJLmFwcgkJPSAxLA0KQEAgLTI1MSw5ICsyNTIs
OSBAQCBzdGF0aWMgc3RydWN0IHNoX2V0aF9jcHVfZGF0YSBzaF9ldGhfbXlfY3B1X2RhdGFfZ2ln
YSA9IHsNCiAJLmVlc2lwcl92YWx1ZQk9IERNQUNfTV9SRlJNRVIgfCBETUFDX01fRUNJIHwgMHgw
MDNmZmZmZiwNCiANCiAJLnR4X2NoZWNrCT0gRUVTUl9UQzEgfCBFRVNSX0ZUQywNCi0JLmVlc3Jf
ZXJyX2NoZWNrCT0gRUVTUl9UV0IxIHwgRUVTUl9UV0IgfCBFRVNSX1RBQlQgfCBFRVNSX1JBQlQg
fCBcDQotCQkJICBFRVNSX1JERSB8IEVFU1JfUkZSTUVSIHwgRUVTUl9URkUgfCBFRVNSX1RERSB8
IFwNCi0JCQkgIEVFU1JfRUNJLA0KKwkuZWVzcl9lcnJfY2hlY2sJPSBFRVNSX1RXQjEgfCBFRVNS
X1RXQiB8IEVFU1JfVEFCVCB8IEVFU1JfUkFCVCB8DQorCQkJICBFRVNSX1JGRSB8IEVFU1JfUkRF
IHwgRUVTUl9SRlJNRVIgfCBFRVNSX1RGRSB8DQorCQkJICBFRVNSX1RERSB8IEVFU1JfRUNJLA0K
IAkudHhfZXJyb3JfY2hlY2sJPSBFRVNSX1RXQjEgfCBFRVNSX1RXQiB8IEVFU1JfVEFCVCB8IEVF
U1JfVERFIHwgXA0KIAkJCSAgRUVTUl9URkUsDQogCS5mZHJfdmFsdWUJPSAweDAwMDAwNzJmLA0K
QEAgLTM1NSw5ICszNTYsOSBAQCBzdGF0aWMgc3RydWN0IHNoX2V0aF9jcHVfZGF0YSBzaF9ldGhf
bXlfY3B1X2RhdGEgPSB7DQogCS5lZXNpcHJfdmFsdWUJPSBETUFDX01fUkZSTUVSIHwgRE1BQ19N
X0VDSSB8IDB4MDAzZmZmZmYsDQogDQogCS50eF9jaGVjawk9IEVFU1JfVEMxIHwgRUVTUl9GVEMs
DQotCS5lZXNyX2Vycl9jaGVjawk9IEVFU1JfVFdCMSB8IEVFU1JfVFdCIHwgRUVTUl9UQUJUIHwg
RUVTUl9SQUJUIHwgXA0KLQkJCSAgRUVTUl9SREUgfCBFRVNSX1JGUk1FUiB8IEVFU1JfVEZFIHwg
RUVTUl9UREUgfCBcDQotCQkJICBFRVNSX0VDSSwNCisJLmVlc3JfZXJyX2NoZWNrCT0gRUVTUl9U
V0IxIHwgRUVTUl9UV0IgfCBFRVNSX1RBQlQgfCBFRVNSX1JBQlQgfA0KKwkJCSAgRUVTUl9SRkUg
fCBFRVNSX1JERSB8IEVFU1JfUkZSTUVSIHwgRUVTUl9URkUgfA0KKwkJCSAgRUVTUl9UREUgfCBF
RVNSX0VDSSwNCiAJLnR4X2Vycm9yX2NoZWNrCT0gRUVTUl9UV0IxIHwgRUVTUl9UV0IgfCBFRVNS
X1RBQlQgfCBFRVNSX1RERSB8IFwNCiAJCQkgIEVFU1JfVEZFLA0KIA0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvc2hfZXRoLmggYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3NoX2V0aC5oDQppbmRleCA0Nzg3N2IxLi41OTA3MDVjIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9zaF9ldGguaA0KKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9zaF9ldGguaA0KQEAgLTQ2MSw3ICs0NjEsNyBAQCBlbnVtIEVFU1Jf
QklUIHsNCiANCiAjZGVmaW5lIERFRkFVTFRfVFhfQ0hFQ0sJKEVFU1JfRlRDIHwgRUVTUl9DTkQg
fCBFRVNSX0RMQyB8IEVFU1JfQ0QgfCBcDQogCQkJCSBFRVNSX1JUTykNCi0jZGVmaW5lIERFRkFV
TFRfRUVTUl9FUlJfQ0hFQ0sJKEVFU1JfVFdCIHwgRUVTUl9UQUJUIHwgRUVTUl9SQUJUIHwgXA0K
KyNkZWZpbmUgREVGQVVMVF9FRVNSX0VSUl9DSEVDSwkoRUVTUl9UV0IgfCBFRVNSX1RBQlQgfCBF
RVNSX1JBQlQgfCBFRVNSX1JGRSB8IFwNCiAJCQkJIEVFU1JfUkRFIHwgRUVTUl9SRlJNRVIgfCBF
RVNSX0FERSB8IFwNCiAJCQkJIEVFU1JfVEZFIHwgRUVTUl9UREUgfCBFRVNSX0VDSSkNCiAjZGVm
aW5lIERFRkFVTFRfVFhfRVJST1JfQ0hFQ0sJKEVFU1JfVFdCIHwgRUVTUl9UQUJUIHwgRUVTUl9B
REUgfCBFRVNSX1RERSB8IFwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdW4v
c3Vudm5ldC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3VuL3N1bnZuZXQuYw0KaW5kZXggOGM2
YzA1OS4uYmQwODkxOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N1bi9zdW52
bmV0LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N1bi9zdW52bmV0LmMNCkBAIC0xMjQ4
LDYgKzEyNDgsOCBAQCBzdGF0aWMgaW50IHZuZXRfcG9ydF9yZW1vdmUoc3RydWN0IHZpb19kZXYg
KnZkZXYpDQogCQlkZXZfc2V0X2RydmRhdGEoJnZkZXYtPmRldiwgTlVMTCk7DQogDQogCQlrZnJl
ZShwb3J0KTsNCisNCisJCXVucmVnaXN0ZXJfbmV0ZGV2KHZwLT5kZXYpOw0KIAl9DQogCXJldHVy
biAwOw0KIH0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9pZmIuYyBiL2RyaXZlcnMvbmV0L2lm
Yi5jDQppbmRleCA0NmI1ZjVmLi5iMTk4NDFhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvaWZi
LmMNCisrKyBiL2RyaXZlcnMvbmV0L2lmYi5jDQpAQCAtMjkwLDExICsyOTAsMTcgQEAgc3RhdGlj
IGludCBfX2luaXQgaWZiX2luaXRfbW9kdWxlKHZvaWQpDQogDQogCXJ0bmxfbG9jaygpOw0KIAll
cnIgPSBfX3J0bmxfbGlua19yZWdpc3RlcigmaWZiX2xpbmtfb3BzKTsNCisJaWYgKGVyciA8IDAp
DQorCQlnb3RvIG91dDsNCiANCi0JZm9yIChpID0gMDsgaSA8IG51bWlmYnMgJiYgIWVycjsgaSsr
KQ0KKwlmb3IgKGkgPSAwOyBpIDwgbnVtaWZicyAmJiAhZXJyOyBpKyspIHsNCiAJCWVyciA9IGlm
Yl9pbml0X29uZShpKTsNCisJCWNvbmRfcmVzY2hlZCgpOw0KKwl9DQogCWlmIChlcnIpDQogCQlf
X3J0bmxfbGlua191bnJlZ2lzdGVyKCZpZmJfbGlua19vcHMpOw0KKw0KK291dDoNCiAJcnRubF91
bmxvY2soKTsNCiANCiAJcmV0dXJuIGVycjsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9tYWN2
dGFwLmMgYi9kcml2ZXJzL25ldC9tYWN2dGFwLmMNCmluZGV4IDI2MTA2YzAuLjk2YjllM2MgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL25ldC9tYWN2dGFwLmMNCisrKyBiL2RyaXZlcnMvbmV0L21hY3Z0
YXAuYw0KQEAgLTUzMiw4ICs1MzIsMTAgQEAgc3RhdGljIGludCB6ZXJvY29weV9zZ19mcm9tX2lv
dmVjKHN0cnVjdCBza19idWZmICpza2IsIGNvbnN0IHN0cnVjdCBpb3ZlYyAqZnJvbSwNCiAJCQly
ZXR1cm4gLUVNU0dTSVpFOw0KIAkJbnVtX3BhZ2VzID0gZ2V0X3VzZXJfcGFnZXNfZmFzdChiYXNl
LCBzaXplLCAwLCAmcGFnZVtpXSk7DQogCQlpZiAobnVtX3BhZ2VzICE9IHNpemUpIHsNCi0JCQlm
b3IgKGkgPSAwOyBpIDwgbnVtX3BhZ2VzOyBpKyspDQotCQkJCXB1dF9wYWdlKHBhZ2VbaV0pOw0K
KwkJCWludCBqOw0KKw0KKwkJCWZvciAoaiA9IDA7IGogPCBudW1fcGFnZXM7IGorKykNCisJCQkJ
cHV0X3BhZ2UocGFnZVtpICsgal0pOw0KIAkJCXJldHVybiAtRUZBVUxUOw0KIAkJfQ0KIAkJdHJ1
ZXNpemUgPSBzaXplICogUEFHRV9TSVpFOw0KQEAgLTY1Myw2ICs2NTUsNyBAQCBzdGF0aWMgc3Np
emVfdCBtYWN2dGFwX2dldF91c2VyKHN0cnVjdCBtYWN2dGFwX3F1ZXVlICpxLCBzdHJ1Y3QgbXNn
aGRyICptLA0KIAlpbnQgdm5ldF9oZHJfbGVuID0gMDsNCiAJaW50IGNvcHlsZW4gPSAwOw0KIAli
b29sIHplcm9jb3B5ID0gZmFsc2U7DQorCXNpemVfdCBsaW5lYXI7DQogDQogCWlmIChxLT5mbGFn
cyAmIElGRl9WTkVUX0hEUikgew0KIAkJdm5ldF9oZHJfbGVuID0gcS0+dm5ldF9oZHJfc3o7DQpA
QCAtNzA3LDExICs3MTAsMTQgQEAgc3RhdGljIHNzaXplX3QgbWFjdnRhcF9nZXRfdXNlcihzdHJ1
Y3QgbWFjdnRhcF9xdWV1ZSAqcSwgc3RydWN0IG1zZ2hkciAqbSwNCiAJCQljb3B5bGVuID0gdm5l
dF9oZHIuaGRyX2xlbjsNCiAJCWlmICghY29weWxlbikNCiAJCQljb3B5bGVuID0gR09PRENPUFlf
TEVOOw0KLQl9IGVsc2UNCisJCWxpbmVhciA9IGNvcHlsZW47DQorCX0gZWxzZSB7DQogCQljb3B5
bGVuID0gbGVuOw0KKwkJbGluZWFyID0gdm5ldF9oZHIuaGRyX2xlbjsNCisJfQ0KIA0KIAlza2Ig
PSBtYWN2dGFwX2FsbG9jX3NrYigmcS0+c2ssIE5FVF9JUF9BTElHTiwgY29weWxlbiwNCi0JCQkJ
dm5ldF9oZHIuaGRyX2xlbiwgbm9ibG9jaywgJmVycik7DQorCQkJCWxpbmVhciwgbm9ibG9jaywg
JmVycik7DQogCWlmICghc2tiKQ0KIAkJZ290byBlcnI7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvdmlydGlvX25ldC5jIGIvZHJpdmVycy9uZXQvdmlydGlvX25ldC5jDQppbmRleCA2ZWU4
NDEwLi40M2E2YTExIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvdmlydGlvX25ldC5jDQorKysg
Yi9kcml2ZXJzL25ldC92aXJ0aW9fbmV0LmMNCkBAIC01MDgsNyArNTA4LDcgQEAgc3RhdGljIGlu
dCB2aXJ0bmV0X3BvbGwoc3RydWN0IG5hcGlfc3RydWN0ICpuYXBpLCBpbnQgYnVkZ2V0KQ0KIHsN
CiAJc3RydWN0IHZpcnRuZXRfaW5mbyAqdmkgPSBjb250YWluZXJfb2YobmFwaSwgc3RydWN0IHZp
cnRuZXRfaW5mbywgbmFwaSk7DQogCXZvaWQgKmJ1ZjsNCi0JdW5zaWduZWQgaW50IGxlbiwgcmVj
ZWl2ZWQgPSAwOw0KKwl1bnNpZ25lZCBpbnQgciwgbGVuLCByZWNlaXZlZCA9IDA7DQogDQogYWdh
aW46DQogCXdoaWxlIChyZWNlaXZlZCA8IGJ1ZGdldCAmJg0KQEAgLTUyNSw4ICs1MjUsOSBAQCBh
Z2FpbjoNCiANCiAJLyogT3V0IG9mIHBhY2tldHM/ICovDQogCWlmIChyZWNlaXZlZCA8IGJ1ZGdl
dCkgew0KKwkJciA9IHZpcnRxdWV1ZV9lbmFibGVfY2JfcHJlcGFyZSh2aS0+cnZxKTsNCiAJCW5h
cGlfY29tcGxldGUobmFwaSk7DQotCQlpZiAodW5saWtlbHkoIXZpcnRxdWV1ZV9lbmFibGVfY2Io
dmktPnJ2cSkpICYmDQorCQlpZiAodW5saWtlbHkodmlydHF1ZXVlX3BvbGwodmktPnJ2cSwgcikp
ICYmDQogCQkgICAgbmFwaV9zY2hlZHVsZV9wcmVwKG5hcGkpKSB7DQogCQkJdmlydHF1ZXVlX2Rp
c2FibGVfY2IodmktPnJ2cSk7DQogCQkJX19uYXBpX3NjaGVkdWxlKG5hcGkpOw0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2lvLmMgYi9kcml2ZXJzL3Njc2kvYm54MmZj
L2JueDJmY19pby5jDQppbmRleCA4NGE3OGFmLi4xODJmY2IyIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9zY3NpL2JueDJmYy9ibngyZmNfaW8uYw0KKysrIGIvZHJpdmVycy9zY3NpL2JueDJmYy9ibngy
ZmNfaW8uYw0KQEAgLTE3ODgsNyArMTc4OCw3IEBAIHN0YXRpYyB2b2lkIGJueDJmY19wYXJzZV9m
Y3BfcnNwKHN0cnVjdCBibngyZmNfY21kICppb19yZXEsDQogCQkJZmNwX3Nuc19sZW4gPSBTQ1NJ
X1NFTlNFX0JVRkZFUlNJWkU7DQogCQl9DQogDQotCQltZW1zZXQoc2NfY21kLT5zZW5zZV9idWZm
ZXIsIDAsIHNpemVvZihzY19jbWQtPnNlbnNlX2J1ZmZlcikpOw0KKwkJbWVtc2V0KHNjX2NtZC0+
c2Vuc2VfYnVmZmVyLCAwLCBTQ1NJX1NFTlNFX0JVRkZFUlNJWkUpOw0KIAkJaWYgKGZjcF9zbnNf
bGVuKQ0KIAkJCW1lbWNweShzY19jbWQtPnNlbnNlX2J1ZmZlciwgcnFfZGF0YSwgZmNwX3Nuc19s
ZW4pOw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9pc2NpL3Rhc2suYyBiL2RyaXZlcnMv
c2NzaS9pc2NpL3Rhc2suYw0KaW5kZXggNjZhZDNkYy4uZTI5NGQxMSAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvc2NzaS9pc2NpL3Rhc2suYw0KKysrIGIvZHJpdmVycy9zY3NpL2lzY2kvdGFzay5jDQpA
QCAtMTAzOCw2ICsxMDM4LDcgQEAgaW50IGlzY2lfdGFza19hYm9ydF90YXNrKHN0cnVjdCBzYXNf
dGFzayAqdGFzaykNCiAJaW50ICAgICAgICAgICAgICAgICAgICAgICByZXQgPSBUTUZfUkVTUF9G
VU5DX0ZBSUxFRDsNCiAJdW5zaWduZWQgbG9uZyAgICAgICAgICAgICBmbGFnczsNCiAJaW50ICAg
ICAgICAgICAgICAgICAgICAgICBwZXJmb3JtX3Rlcm1pbmF0aW9uID0gMDsNCisJaW50ICAgICAg
ICAgICAgICAgICAgICAgICB0YXJnZXRfZG9uZV9hbHJlYWR5ID0gMDsNCiANCiAJLyogR2V0IHRo
ZSBpc2NpX3JlcXVlc3QgcmVmZXJlbmNlIGZyb20gdGhlIHRhc2suICBOb3RlIHRoYXQNCiAJICog
dGhpcyBjaGVjayBkb2VzIG5vdCBkZXBlbmQgb24gdGhlIHBlbmRpbmcgcmVxdWVzdCBsaXN0DQpA
QCAtMTA1Miw5ICsxMDUzLDExIEBAIGludCBpc2NpX3Rhc2tfYWJvcnRfdGFzayhzdHJ1Y3Qgc2Fz
X3Rhc2sgKnRhc2spDQogCS8qIElmIHRhc2sgaXMgYWxyZWFkeSBkb25lLCB0aGUgcmVxdWVzdCBp
c24ndCB2YWxpZCAqLw0KIAlpZiAoISh0YXNrLT50YXNrX3N0YXRlX2ZsYWdzICYgU0FTX1RBU0tf
U1RBVEVfRE9ORSkgJiYNCiAJICAgICh0YXNrLT50YXNrX3N0YXRlX2ZsYWdzICYgU0FTX1RBU0tf
QVRfSU5JVElBVE9SKSAmJg0KLQkgICAgb2xkX3JlcXVlc3QpDQorCSAgICBvbGRfcmVxdWVzdCkg
ew0KIAkJaXNjaV9kZXZpY2UgPSBpc2NpX2xvb2t1cF9kZXZpY2UodGFzay0+ZGV2KTsNCi0NCisJ
CXRhcmdldF9kb25lX2FscmVhZHkgPSB0ZXN0X2JpdChJUkVRX0NPTVBMRVRFX0lOX1RBUkdFVCwN
CisJCQkJCSAgICAgICAmb2xkX3JlcXVlc3QtPmZsYWdzKTsNCisJfQ0KIAlzcGluX3VubG9jaygm
dGFzay0+dGFza19zdGF0ZV9sb2NrKTsNCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaXNjaV9o
b3N0LT5zY2ljX2xvY2ssIGZsYWdzKTsNCiANCkBAIC0xMTE2LDcgKzExMTksNyBAQCBpbnQgaXNj
aV90YXNrX2Fib3J0X3Rhc2soc3RydWN0IHNhc190YXNrICp0YXNrKQ0KIAl9DQogCWlmICh0YXNr
LT50YXNrX3Byb3RvID09IFNBU19QUk9UT0NPTF9TTVAgfHwNCiAJICAgIHNhc19wcm90b2NvbF9h
dGEodGFzay0+dGFza19wcm90bykgfHwNCi0JICAgIHRlc3RfYml0KElSRVFfQ09NUExFVEVfSU5f
VEFSR0VULCAmb2xkX3JlcXVlc3QtPmZsYWdzKSkgew0KKwkgICAgdGFyZ2V0X2RvbmVfYWxyZWFk
eSkgew0KIA0KIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaXNjaV9ob3N0LT5zY2ljX2xvY2ss
IGZsYWdzKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW9jYi5j
IGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lvY2IuYw0KaW5kZXggYTRiMjY3ZS4uOWZiZTI2
MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMNCisrKyBiL2Ry
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMNCkBAIC00MjMsNiArNDIzLDggQEAgcWxhMngw
MF9zdGFydF9zY3NpKHNyYl90ICpzcCkNCiAJCQkgICAgX19jb25zdGFudF9jcHVfdG9fbGUxNihD
Rl9TSU1QTEVfVEFHKTsNCiAJCQlicmVhazsNCiAJCX0NCisJfSBlbHNlIHsNCisJCWNtZF9wa3Qt
PmNvbnRyb2xfZmxhZ3MgPSBfX2NvbnN0YW50X2NwdV90b19sZTE2KENGX1NJTVBMRV9UQUcpOw0K
IAl9DQogDQogCS8qIExvYWQgU0NTSSBjb21tYW5kIHBhY2tldC4gKi8NCkBAIC0xMjQ0LDExICsx
MjQ2LDExIEBAIHFsYTI0eHhfYnVpbGRfc2NzaV9jcmNfMl9pb2NicyhzcmJfdCAqc3AsIHN0cnVj
dCBjbWRfdHlwZV9jcmNfMiAqY21kX3BrdCwNCiAJCSAgICBmY3BfY21uZC0+dGFza19hdHRyaWJ1
dGUgPSBUU0tfT1JERVJFRDsNCiAJCSAgICBicmVhazsNCiAJCWRlZmF1bHQ6DQotCQkgICAgZmNw
X2NtbmQtPnRhc2tfYXR0cmlidXRlID0gMDsNCisJCSAgICBmY3BfY21uZC0+dGFza19hdHRyaWJ1
dGUgPSBUU0tfU0lNUExFOw0KIAkJICAgIGJyZWFrOw0KIAkJfQ0KIAl9IGVsc2Ugew0KLQkJZmNw
X2NtbmQtPnRhc2tfYXR0cmlidXRlID0gMDsNCisJCWZjcF9jbW5kLT50YXNrX2F0dHJpYnV0ZSA9
IFRTS19TSU1QTEU7DQogCX0NCiANCiAJY21kX3BrdC0+ZmNwX3JzcF9kc2VnX2xlbiA9IDA7IC8q
IExldCByZXNwb25zZSBjb21lIGluIHN0YXR1cyBpb2NiICovDQpAQCAtMTQ1NCw3ICsxNDU2LDEy
IEBAIHFsYTI0eHhfc3RhcnRfc2NzaShzcmJfdCAqc3ApDQogCQljYXNlIE9SREVSRURfUVVFVUVf
VEFHOg0KIAkJCWNtZF9wa3QtPnRhc2sgPSBUU0tfT1JERVJFRDsNCiAJCQlicmVhazsNCisJCWRl
ZmF1bHQ6DQorCQkgICAgY21kX3BrdC0+dGFzayA9IFRTS19TSU1QTEU7DQorCQkgICAgYnJlYWs7
DQogCQl9DQorCX0gZWxzZSB7DQorCQljbWRfcGt0LT50YXNrID0gVFNLX1NJTVBMRTsNCiAJfQ0K
IA0KIAkvKiBMb2FkIFNDU0kgY29tbWFuZCBwYWNrZXQuICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL3NkLmMgYi9kcml2ZXJzL3Njc2kvc2QuYw0KaW5kZXggNmRhY2UxYS4uMTc2MDNkYSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9zZC5jDQorKysgYi9kcml2ZXJzL3Njc2kvc2QuYw0K
QEAgLTY0MSwxMCArNjQxLDE3IEBAIHN0YXRpYyBpbnQgc2NzaV9zZXR1cF9mbHVzaF9jbW5kKHN0
cnVjdCBzY3NpX2RldmljZSAqc2RwLCBzdHJ1Y3QgcmVxdWVzdCAqcnEpDQogDQogc3RhdGljIHZv
aWQgc2RfdW5wcmVwX2ZuKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgcmVxdWVzdCAq
cnEpDQogew0KKwlzdHJ1Y3Qgc2NzaV9jbW5kICpTQ3BudCA9IHJxLT5zcGVjaWFsOw0KKw0KIAlp
ZiAocnEtPmNtZF9mbGFncyAmIFJFUV9ESVNDQVJEKSB7DQogCQlmcmVlX3BhZ2UoKHVuc2lnbmVk
IGxvbmcpcnEtPmJ1ZmZlcik7DQogCQlycS0+YnVmZmVyID0gTlVMTDsNCiAJfQ0KKwlpZiAoU0Nw
bnQtPmNtbmQgIT0gcnEtPmNtZCkgew0KKwkJbWVtcG9vbF9mcmVlKFNDcG50LT5jbW5kLCBzZF9j
ZGJfcG9vbCk7DQorCQlTQ3BudC0+Y21uZCA9IE5VTEw7DQorCQlTQ3BudC0+Y21kX2xlbiA9IDA7
DQorCX0NCiB9DQogDQogLyoqDQpAQCAtMTQ1MiwyMSArMTQ1OSw2IEBAIHN0YXRpYyBpbnQgc2Rf
ZG9uZShzdHJ1Y3Qgc2NzaV9jbW5kICpTQ3BudCkNCiAJaWYgKHJxX2RhdGFfZGlyKFNDcG50LT5y
ZXF1ZXN0KSA9PSBSRUFEICYmIHNjc2lfcHJvdF9zZ19jb3VudChTQ3BudCkpDQogCQlzZF9kaWZf
Y29tcGxldGUoU0NwbnQsIGdvb2RfYnl0ZXMpOw0KIA0KLQlpZiAoc2NzaV9ob3N0X2RpZl9jYXBh
YmxlKHNka3AtPmRldmljZS0+aG9zdCwgc2RrcC0+cHJvdGVjdGlvbl90eXBlKQ0KLQkgICAgPT0g
U0RfRElGX1RZUEUyX1BST1RFQ1RJT04gJiYgU0NwbnQtPmNtbmQgIT0gU0NwbnQtPnJlcXVlc3Qt
PmNtZCkgew0KLQ0KLQkJLyogV2UgaGF2ZSB0byBwcmludCBhIGZhaWxlZCBjb21tYW5kIGhlcmUg
YXMgdGhlDQotCQkgKiBleHRlbmRlZCBDREIgZ2V0cyBmcmVlZCBiZWZvcmUgc2NzaV9pb19jb21w
bGV0aW9uKCkNCi0JCSAqIGlzIGNhbGxlZC4NCi0JCSAqLw0KLQkJaWYgKHJlc3VsdCkNCi0JCQlz
Y3NpX3ByaW50X2NvbW1hbmQoU0NwbnQpOw0KLQ0KLQkJbWVtcG9vbF9mcmVlKFNDcG50LT5jbW5k
LCBzZF9jZGJfcG9vbCk7DQotCQlTQ3BudC0+Y21uZCA9IE5VTEw7DQotCQlTQ3BudC0+Y21kX2xl
biA9IDA7DQotCX0NCi0NCiAJcmV0dXJuIGdvb2RfYnl0ZXM7DQogfQ0KIA0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy9jb21lZGkvY29tZWRpX2ZvcHMuYyBiL2RyaXZlcnMvc3RhZ2luZy9j
b21lZGkvY29tZWRpX2ZvcHMuYw0KaW5kZXggZmU0ZGJmMy4uN2U0MjE5MCAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvc3RhZ2luZy9jb21lZGkvY29tZWRpX2ZvcHMuYw0KKysrIGIvZHJpdmVycy9zdGFn
aW5nL2NvbWVkaS9jb21lZGlfZm9wcy5jDQpAQCAtMTA3OCwyMiArMTA3OCwxOSBAQCBzdGF0aWMg
aW50IGRvX2NtZF9pb2N0bChzdHJ1Y3QgY29tZWRpX2RldmljZSAqZGV2LA0KIAkJRFBSSU5USygi
c3ViZGV2aWNlIGJ1c3lcbiIpOw0KIAkJcmV0dXJuIC1FQlVTWTsNCiAJfQ0KLQlzLT5idXN5ID0g
ZmlsZTsNCiANCiAJLyogbWFrZSBzdXJlIGNoYW5uZWwvZ2FpbiBsaXN0IGlzbid0IHRvbyBsb25n
ICovDQogCWlmICh1c2VyX2NtZC5jaGFubGlzdF9sZW4gPiBzLT5sZW5fY2hhbmxpc3QpIHsNCiAJ
CURQUklOVEsoImNoYW5uZWwvZ2FpbiBsaXN0IHRvbyBsb25nICV1ID4gJWRcbiIsDQogCQkJdXNl
cl9jbWQuY2hhbmxpc3RfbGVuLCBzLT5sZW5fY2hhbmxpc3QpOw0KLQkJcmV0ID0gLUVJTlZBTDsN
Ci0JCWdvdG8gY2xlYW51cDsNCisJCXJldHVybiAtRUlOVkFMOw0KIAl9DQogDQogCS8qIG1ha2Ug
c3VyZSBjaGFubmVsL2dhaW4gbGlzdCBpc24ndCB0b28gc2hvcnQgKi8NCiAJaWYgKHVzZXJfY21k
LmNoYW5saXN0X2xlbiA8IDEpIHsNCiAJCURQUklOVEsoImNoYW5uZWwvZ2FpbiBsaXN0IHRvbyBz
aG9ydCAldSA8IDFcbiIsDQogCQkJdXNlcl9jbWQuY2hhbmxpc3RfbGVuKTsNCi0JCXJldCA9IC1F
SU5WQUw7DQotCQlnb3RvIGNsZWFudXA7DQorCQlyZXR1cm4gLUVJTlZBTDsNCiAJfQ0KIA0KIAlh
c3luYy0+Y21kID0gdXNlcl9jbWQ7DQpAQCAtMTEwMyw4ICsxMTAwLDcgQEAgc3RhdGljIGludCBk
b19jbWRfaW9jdGwoc3RydWN0IGNvbWVkaV9kZXZpY2UgKmRldiwNCiAJICAgIGttYWxsb2MoYXN5
bmMtPmNtZC5jaGFubGlzdF9sZW4gKiBzaXplb2YoaW50KSwgR0ZQX0tFUk5FTCk7DQogCWlmICgh
YXN5bmMtPmNtZC5jaGFubGlzdCkgew0KIAkJRFBSSU5USygiYWxsb2NhdGlvbiBmYWlsZWRcbiIp
Ow0KLQkJcmV0ID0gLUVOT01FTTsNCi0JCWdvdG8gY2xlYW51cDsNCisJCXJldHVybiAtRU5PTUVN
Ow0KIAl9DQogDQogCWlmIChjb3B5X2Zyb21fdXNlcihhc3luYy0+Y21kLmNoYW5saXN0LCB1c2Vy
X2NtZC5jaGFubGlzdCwNCkBAIC0xMTU2LDYgKzExNTIsOSBAQCBzdGF0aWMgaW50IGRvX2NtZF9p
b2N0bChzdHJ1Y3QgY29tZWRpX2RldmljZSAqZGV2LA0KIA0KIAljb21lZGlfc2V0X3N1YmRldmlj
ZV9ydW5mbGFncyhzLCB+MCwgU1JGX1VTRVIgfCBTUkZfUlVOTklORyk7DQogDQorCS8qIHNldCBz
LT5idXN5IF9hZnRlcl8gc2V0dGluZyBTUkZfUlVOTklORyBmbGFnIHRvIGF2b2lkIHJhY2Ugd2l0
aA0KKwkgKiBjb21lZGlfcmVhZCgpIG9yIGNvbWVkaV93cml0ZSgpICovDQorCXMtPmJ1c3kgPSBm
aWxlOw0KIAlyZXQgPSBzLT5kb19jbWQoZGV2LCBzKTsNCiAJaWYgKHJldCA9PSAwKQ0KIAkJcmV0
dXJuIDA7DQpAQCAtMTM3MCw2ICsxMzY5LDcgQEAgc3RhdGljIGludCBkb19jYW5jZWxfaW9jdGwo
c3RydWN0IGNvbWVkaV9kZXZpY2UgKmRldiwgdW5zaWduZWQgaW50IGFyZywNCiAJCQkgICB2b2lk
ICpmaWxlKQ0KIHsNCiAJc3RydWN0IGNvbWVkaV9zdWJkZXZpY2UgKnM7DQorCWludCByZXQ7DQog
DQogCWlmIChhcmcgPj0gZGV2LT5uX3N1YmRldmljZXMpDQogCQlyZXR1cm4gLUVJTlZBTDsNCkBA
IC0xMzg2LDcgKzEzODYsMTEgQEAgc3RhdGljIGludCBkb19jYW5jZWxfaW9jdGwoc3RydWN0IGNv
bWVkaV9kZXZpY2UgKmRldiwgdW5zaWduZWQgaW50IGFyZywNCiAJaWYgKHMtPmJ1c3kgIT0gZmls
ZSkNCiAJCXJldHVybiAtRUJVU1k7DQogDQotCXJldHVybiBkb19jYW5jZWwoZGV2LCBzKTsNCisJ
cmV0ID0gZG9fY2FuY2VsKGRldiwgcyk7DQorCWlmIChjb21lZGlfZ2V0X3N1YmRldmljZV9ydW5m
bGFncyhzKSAmIFNSRl9VU0VSKQ0KKwkJd2FrZV91cF9pbnRlcnJ1cHRpYmxlKCZzLT5hc3luYy0+
d2FpdF9oZWFkKTsNCisNCisJcmV0dXJuIHJldDsNCiB9DQogDQogLyoNCkBAIC0xNjUzLDYgKzE2
NTcsNyBAQCBzdGF0aWMgc3NpemVfdCBjb21lZGlfd3JpdGUoc3RydWN0IGZpbGUgKmZpbGUsIGNv
bnN0IGNoYXIgX191c2VyICpidWYsDQogDQogCQlpZiAoIShjb21lZGlfZ2V0X3N1YmRldmljZV9y
dW5mbGFncyhzKSAmIFNSRl9SVU5OSU5HKSkgew0KIAkJCWlmIChjb3VudCA9PSAwKSB7DQorCQkJ
CW11dGV4X2xvY2soJmRldi0+bXV0ZXgpOw0KIAkJCQlpZiAoY29tZWRpX2dldF9zdWJkZXZpY2Vf
cnVuZmxhZ3MocykgJg0KIAkJCQkJU1JGX0VSUk9SKSB7DQogCQkJCQlyZXR2YWwgPSAtRVBJUEU7
DQpAQCAtMTY2MCw2ICsxNjY1LDcgQEAgc3RhdGljIHNzaXplX3QgY29tZWRpX3dyaXRlKHN0cnVj
dCBmaWxlICpmaWxlLCBjb25zdCBjaGFyIF9fdXNlciAqYnVmLA0KIAkJCQkJcmV0dmFsID0gMDsN
CiAJCQkJfQ0KIAkJCQlkb19iZWNvbWVfbm9uYnVzeShkZXYsIHMpOw0KKwkJCQltdXRleF91bmxv
Y2soJmRldi0+bXV0ZXgpOw0KIAkJCX0NCiAJCQlicmVhazsNCiAJCX0NCkBAIC0xNzc0LDYgKzE3
ODAsNyBAQCBzdGF0aWMgc3NpemVfdCBjb21lZGlfcmVhZChzdHJ1Y3QgZmlsZSAqZmlsZSwgY2hh
ciBfX3VzZXIgKmJ1Ziwgc2l6ZV90IG5ieXRlcywNCiANCiAJCWlmIChuID09IDApIHsNCiAJCQlp
ZiAoIShjb21lZGlfZ2V0X3N1YmRldmljZV9ydW5mbGFncyhzKSAmIFNSRl9SVU5OSU5HKSkgew0K
KwkJCQltdXRleF9sb2NrKCZkZXYtPm11dGV4KTsNCiAJCQkJZG9fYmVjb21lX25vbmJ1c3koZGV2
LCBzKTsNCiAJCQkJaWYgKGNvbWVkaV9nZXRfc3ViZGV2aWNlX3J1bmZsYWdzKHMpICYNCiAJCQkJ
ICAgIFNSRl9FUlJPUikgew0KQEAgLTE3ODEsNiArMTc4OCw3IEBAIHN0YXRpYyBzc2l6ZV90IGNv
bWVkaV9yZWFkKHN0cnVjdCBmaWxlICpmaWxlLCBjaGFyIF9fdXNlciAqYnVmLCBzaXplX3QgbmJ5
dGVzLA0KIAkJCQl9IGVsc2Ugew0KIAkJCQkJcmV0dmFsID0gMDsNCiAJCQkJfQ0KKwkJCQltdXRl
eF91bmxvY2soJmRldi0+bXV0ZXgpOw0KIAkJCQlicmVhazsNCiAJCQl9DQogCQkJaWYgKGZpbGUt
PmZfZmxhZ3MgJiBPX05PTkJMT0NLKSB7DQpAQCAtMTgxOCw5ICsxODI2LDExIEBAIHN0YXRpYyBz
c2l6ZV90IGNvbWVkaV9yZWFkKHN0cnVjdCBmaWxlICpmaWxlLCBjaGFyIF9fdXNlciAqYnVmLCBz
aXplX3QgbmJ5dGVzLA0KIAkJYnVmICs9IG47DQogCQlicmVhazsJCS8qIG1ha2VzIGRldmljZSB3
b3JrIGxpa2UgYSBwaXBlICovDQogCX0NCi0JaWYgKCEoY29tZWRpX2dldF9zdWJkZXZpY2VfcnVu
ZmxhZ3MocykgJiAoU1JGX0VSUk9SIHwgU1JGX1JVTk5JTkcpKSAmJg0KLQkgICAgYXN5bmMtPmJ1
Zl9yZWFkX2NvdW50IC0gYXN5bmMtPmJ1Zl93cml0ZV9jb3VudCA9PSAwKSB7DQotCQlkb19iZWNv
bWVfbm9uYnVzeShkZXYsIHMpOw0KKwlpZiAoIShjb21lZGlfZ2V0X3N1YmRldmljZV9ydW5mbGFn
cyhzKSAmIChTUkZfRVJST1IgfCBTUkZfUlVOTklORykpKSB7DQorCQltdXRleF9sb2NrKCZkZXYt
Pm11dGV4KTsNCisJCWlmIChhc3luYy0+YnVmX3JlYWRfY291bnQgLSBhc3luYy0+YnVmX3dyaXRl
X2NvdW50ID09IDApDQorCQkJZG9fYmVjb21lX25vbmJ1c3koZGV2LCBzKTsNCisJCW11dGV4X3Vu
bG9jaygmZGV2LT5tdXRleCk7DQogCX0NCiAJc2V0X2N1cnJlbnRfc3RhdGUoVEFTS19SVU5OSU5H
KTsNCiAJcmVtb3ZlX3dhaXRfcXVldWUoJmFzeW5jLT53YWl0X2hlYWQsICZ3YWl0KTsNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvbGluZTYvcGNtLmMgYi9kcml2ZXJzL3N0YWdpbmcvbGlu
ZTYvcGNtLmMNCmluZGV4IDlkNGM4YTYuLjJkM2E0MjAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvbGluZTYvcGNtLmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy9saW5lNi9wY20uYw0KQEAg
LTM2MCw4ICszNjAsMTEgQEAgc3RhdGljIGludCBzbmRfbGluZTZfcGNtX2ZyZWUoc3RydWN0IHNu
ZF9kZXZpY2UgKmRldmljZSkNCiAqLw0KIHN0YXRpYyB2b2lkIHBjbV9kaXNjb25uZWN0X3N1YnN0
cmVhbShzdHJ1Y3Qgc25kX3BjbV9zdWJzdHJlYW0gKnN1YnN0cmVhbSkNCiB7DQotCWlmIChzdWJz
dHJlYW0tPnJ1bnRpbWUgJiYgc25kX3BjbV9ydW5uaW5nKHN1YnN0cmVhbSkpDQorCWlmIChzdWJz
dHJlYW0tPnJ1bnRpbWUgJiYgc25kX3BjbV9ydW5uaW5nKHN1YnN0cmVhbSkpIHsNCisJCXNuZF9w
Y21fc3RyZWFtX2xvY2tfaXJxKHN1YnN0cmVhbSk7DQogCQlzbmRfcGNtX3N0b3Aoc3Vic3RyZWFt
LCBTTkRSVl9QQ01fU1RBVEVfRElTQ09OTkVDVEVEKTsNCisJCXNuZF9wY21fc3RyZWFtX3VubG9j
a19pcnEoc3Vic3RyZWFtKTsNCisJfQ0KIH0NCiANCiAvKg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dXNiL2NvcmUvaHViLmMgYi9kcml2ZXJzL3VzYi9jb3JlL2h1Yi5jDQppbmRleCAyMmNiZTA2Li4y
NzY4YTdlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2IvY29yZS9odWIuYw0KKysrIGIvZHJpdmVy
cy91c2IvY29yZS9odWIuYw0KQEAgLTQ2Myw2ICs0NjMsMTUgQEAgcmVzdWJtaXQ6DQogc3RhdGlj
IGlubGluZSBpbnQNCiBodWJfY2xlYXJfdHRfYnVmZmVyIChzdHJ1Y3QgdXNiX2RldmljZSAqaGRl
diwgdTE2IGRldmluZm8sIHUxNiB0dCkNCiB7DQorCS8qIE5lZWQgdG8gY2xlYXIgYm90aCBkaXJl
Y3Rpb25zIGZvciBjb250cm9sIGVwICovDQorCWlmICgoKGRldmluZm8gPj4gMTEpICYgVVNCX0VO
RFBPSU5UX1hGRVJUWVBFX01BU0spID09DQorCQkJVVNCX0VORFBPSU5UX1hGRVJfQ09OVFJPTCkg
ew0KKwkJaW50IHN0YXR1cyA9IHVzYl9jb250cm9sX21zZyhoZGV2LCB1c2Jfc25kY3RybHBpcGUo
aGRldiwgMCksDQorCQkJCUhVQl9DTEVBUl9UVF9CVUZGRVIsIFVTQl9SVF9QT1JULA0KKwkJCQlk
ZXZpbmZvIF4gMHg4MDAwLCB0dCwgTlVMTCwgMCwgMTAwMCk7DQorCQlpZiAoc3RhdHVzKQ0KKwkJ
CXJldHVybiBzdGF0dXM7DQorCX0NCiAJcmV0dXJuIHVzYl9jb250cm9sX21zZyhoZGV2LCB1c2Jf
c25kY3RybHBpcGUoaGRldiwgMCksDQogCQkJICAgICAgIEhVQl9DTEVBUl9UVF9CVUZGRVIsIFVT
Ql9SVF9QT1JULCBkZXZpbmZvLA0KIAkJCSAgICAgICB0dCwgTlVMTCwgMCwgMTAwMCk7DQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy91c2IvZHdjMy9jb3JlLmggYi9kcml2ZXJzL3VzYi9kd2MzL2NvcmUu
aA0KaW5kZXggMjlhOGUxNi4uNDc5NWMwYyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2R3YzMv
Y29yZS5oDQorKysgYi9kcml2ZXJzL3VzYi9kd2MzL2NvcmUuaA0KQEAgLTY0Myw4ICs2NDMsOCBA
QCBzdHJ1Y3QgZHdjMyB7DQogDQogc3RydWN0IGR3YzNfZXZlbnRfdHlwZSB7DQogCXUzMglpc19k
ZXZzcGVjOjE7DQotCXUzMgl0eXBlOjY7DQotCXUzMglyZXNlcnZlZDhfMzE6MjU7DQorCXUzMgl0
eXBlOjc7DQorCXUzMglyZXNlcnZlZDhfMzE6MjQ7DQogfSBfX3BhY2tlZDsNCiANCiAjZGVmaW5l
IERXQzNfREVQRVZUX1hGRVJDT01QTEVURQkweDAxDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Iv
ZHdjMy9nYWRnZXQuYyBiL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCmluZGV4IGIzNjhiODMu
LjYxOWVlMTkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQorKysgYi9k
cml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQpAQCAtMTIxNyw2ICsxMjE3LDcgQEAgZXJyMToNCiAJ
X19kd2MzX2dhZGdldF9lcF9kaXNhYmxlKGR3Yy0+ZXBzWzBdKTsNCiANCiBlcnIwOg0KKwlkd2Mt
PmdhZGdldF9kcml2ZXIgPSBOVUxMOw0KIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZkd2MtPmxv
Y2ssIGZsYWdzKTsNCiANCiAJcmV0dXJuIHJldDsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9o
b3N0L3hoY2ktcGNpLmMgYi9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktcGNpLmMNCmluZGV4IGFjYTY0
N2EuLjc5ZDI3MjAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktcGNpLmMNCisr
KyBiL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1wY2kuYw0KQEAgLTg5LDcgKzg5LDYgQEAgc3RhdGlj
IHZvaWQgeGhjaV9wY2lfcXVpcmtzKHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IHhoY2lfaGNk
ICp4aGNpKQ0KIAkJeGhjaS0+cXVpcmtzIHw9IFhIQ0lfQU1EX1BMTF9GSVg7DQogCWlmIChwZGV2
LT52ZW5kb3IgPT0gUENJX1ZFTkRPUl9JRF9JTlRFTCAmJg0KIAkJCXBkZXYtPmRldmljZSA9PSBQ
Q0lfREVWSUNFX0lEX0lOVEVMX1BBTlRIRVJQT0lOVF9YSENJKSB7DQotCQl4aGNpLT5xdWlya3Mg
fD0gWEhDSV9TUFVSSU9VU19TVUNDRVNTOw0KIAkJeGhjaS0+cXVpcmtzIHw9IFhIQ0lfRVBfTElN
SVRfUVVJUks7DQogCQl4aGNpLT5saW1pdF9hY3RpdmVfZXBzID0gNjQ7DQogCQl4aGNpLT5xdWly
a3MgfD0gWEhDSV9TV19CV19DSEVDS0lORzsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9ob3N0
L3hoY2ktcmluZy5jIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLXJpbmcuYw0KaW5kZXggZDA4YTgw
NC4uNjMzNDc2ZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1yaW5nLmMNCisr
KyBiL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1yaW5nLmMNCkBAIC00NjMsNyArNDYzLDcgQEAgc3Rh
dGljIHZvaWQgcmluZ19kb29yYmVsbF9mb3JfYWN0aXZlX3JpbmdzKHN0cnVjdCB4aGNpX2hjZCAq
eGhjaSwNCiANCiAJLyogQSByaW5nIGhhcyBwZW5kaW5nIFVSQnMgaWYgaXRzIFREIGxpc3QgaXMg
bm90IGVtcHR5ICovDQogCWlmICghKGVwLT5lcF9zdGF0ZSAmIEVQX0hBU19TVFJFQU1TKSkgew0K
LQkJaWYgKCEobGlzdF9lbXB0eSgmZXAtPnJpbmctPnRkX2xpc3QpKSkNCisJCWlmIChlcC0+cmlu
ZyAmJiAhKGxpc3RfZW1wdHkoJmVwLT5yaW5nLT50ZF9saXN0KSkpDQogCQkJeGhjaV9yaW5nX2Vw
X2Rvb3JiZWxsKHhoY2ksIHNsb3RfaWQsIGVwX2luZGV4LCAwKTsNCiAJCXJldHVybjsNCiAJfQ0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS5jIGIvZHJpdmVycy91c2IvaG9zdC94
aGNpLmMNCmluZGV4IDEzNmMzNTcuLjZlMWM5MmEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9o
b3N0L3hoY2kuYw0KKysrIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLmMNCkBAIC0xMTUzLDkgKzEx
NTMsNiBAQCBzdGF0aWMgaW50IHhoY2lfY2hlY2tfYXJncyhzdHJ1Y3QgdXNiX2hjZCAqaGNkLCBz
dHJ1Y3QgdXNiX2RldmljZSAqdWRldiwNCiAJfQ0KIA0KIAl4aGNpID0gaGNkX3RvX3hoY2koaGNk
KTsNCi0JaWYgKHhoY2ktPnhoY19zdGF0ZSAmIFhIQ0lfU1RBVEVfSEFMVEVEKQ0KLQkJcmV0dXJu
IC1FTk9ERVY7DQotDQogCWlmIChjaGVja192aXJ0X2Rldikgew0KIAkJaWYgKCF1ZGV2LT5zbG90
X2lkIHx8ICF4aGNpLT5kZXZzW3VkZXYtPnNsb3RfaWRdKSB7DQogCQkJcHJpbnRrKEtFUk5fREVC
VUcgInhIQ0kgJXMgY2FsbGVkIHdpdGggdW5hZGRyZXNzZWQgIg0KQEAgLTExNzEsNiArMTE2OCw5
IEBAIHN0YXRpYyBpbnQgeGhjaV9jaGVja19hcmdzKHN0cnVjdCB1c2JfaGNkICpoY2QsIHN0cnVj
dCB1c2JfZGV2aWNlICp1ZGV2LA0KIAkJfQ0KIAl9DQogDQorCWlmICh4aGNpLT54aGNfc3RhdGUg
JiBYSENJX1NUQVRFX0hBTFRFRCkNCisJCXJldHVybiAtRU5PREVWOw0KKw0KIAlyZXR1cm4gMTsN
CiB9DQogDQpAQCAtNDE3OCw2ICs0MTc4LDEzIEBAIGludCB4aGNpX2dlbl9zZXR1cChzdHJ1Y3Qg
dXNiX2hjZCAqaGNkLCB4aGNpX2dldF9xdWlya3NfdCBnZXRfcXVpcmtzKQ0KIA0KIAlnZXRfcXVp
cmtzKGRldiwgeGhjaSk7DQogDQorCS8qIEluIHhoY2kgY29udHJvbGxlcnMgd2hpY2ggZm9sbG93
IHhoY2kgMS4wIHNwZWMgZ2l2ZXMgYSBzcHVyaW91cw0KKwkgKiBzdWNjZXNzIGV2ZW50IGFmdGVy
IGEgc2hvcnQgdHJhbnNmZXIuIFRoaXMgcXVpcmsgd2lsbCBpZ25vcmUgc3VjaA0KKwkgKiBzcHVy
aW91cyBldmVudC4NCisJICovDQorCWlmICh4aGNpLT5oY2lfdmVyc2lvbiA+IDB4OTYpDQorCQl4
aGNpLT5xdWlya3MgfD0gWEhDSV9TUFVSSU9VU19TVUNDRVNTOw0KKw0KIAkvKiBNYWtlIHN1cmUg
dGhlIEhDIGlzIGhhbHRlZC4gKi8NCiAJcmV0dmFsID0geGhjaV9oYWx0KHhoY2kpOw0KIAlpZiAo
cmV0dmFsKQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL21pc2Mvc2lzdXNidmdhL3Npc3VzYi5j
IGIvZHJpdmVycy91c2IvbWlzYy9zaXN1c2J2Z2Evc2lzdXNiLmMNCmluZGV4IGRkNTczYWIuLjdh
ZjE2M2QgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9taXNjL3Npc3VzYnZnYS9zaXN1c2IuYw0K
KysrIGIvZHJpdmVycy91c2IvbWlzYy9zaXN1c2J2Z2Evc2lzdXNiLmMNCkBAIC0zMjQ3LDYgKzMy
NDcsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgc2lzdXNiX3RhYmxlW10g
PSB7DQogCXsgVVNCX0RFVklDRSgweDA3MTEsIDB4MDkwMykgfSwNCiAJeyBVU0JfREVWSUNFKDB4
MDcxMSwgMHgwOTE4KSB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgwNzExLCAweDA5MjApIH0sDQorCXsg
VVNCX0RFVklDRSgweDA3MTEsIDB4MDk1MCkgfSwNCiAJeyBVU0JfREVWSUNFKDB4MTgyZCwgMHgw
MjFjKSB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgxODJkLCAweDAyNjkpIH0sDQogCXsgfQ0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9jcDIxMHguYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9j
cDIxMHguYw0KaW5kZXggOTEzYTE3OC4uYzQwOGZmNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNi
L3NlcmlhbC9jcDIxMHguYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL2NwMjEweC5jDQpAQCAt
NjAsNiArNjAsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgaWRfdGFibGVb
XSA9IHsNCiAJeyBVU0JfREVWSUNFKDB4MDQ4OSwgMHhFMDAwKSB9LCAvKiBQaXJlbGxpIEJyb2Fk
YmFuZCBTLnAuQSwgRFAtTDEwIFNJUC9HU00gTW9iaWxlICovDQogCXsgVVNCX0RFVklDRSgweDA0
ODksIDB4RTAwMykgfSwgLyogUGlyZWxsaSBCcm9hZGJhbmQgUy5wLkEsIERQLUwxMCBTSVAvR1NN
IE1vYmlsZSAqLw0KIAl7IFVTQl9ERVZJQ0UoMHgwNzQ1LCAweDEwMDApIH0sIC8qIENpcGhlckxh
YiBVU0IgQ0NEIEJhcmNvZGUgU2Nhbm5lciAxMDAwICovDQorCXsgVVNCX0RFVklDRSgweDA4NDYs
IDB4MTEwMCkgfSwgLyogTmV0R2VhciBNYW5hZ2VkIFN3aXRjaCBNNDEwMCBzZXJpZXMsIE01MzAw
IHNlcmllcywgTTcxMDAgc2VyaWVzICovDQogCXsgVVNCX0RFVklDRSgweDA4ZTYsIDB4NTUwMSkg
fSwgLyogR2VtYWx0byBQcm94LVBVL0NVIGNvbnRhY3RsZXNzIHNtYXJ0Y2FyZCByZWFkZXIgKi8N
CiAJeyBVU0JfREVWSUNFKDB4MDhGRCwgMHgwMDBBKSB9LCAvKiBEaWdpYW5zd2VyIEEvUyAsIFpp
Z0JlZS84MDIuMTUuNCBNQUMgRGV2aWNlICovDQogCXsgVVNCX0RFVklDRSgweDBCRUQsIDB4MTEw
MCkgfSwgLyogTUVJIChUTSkgQ2FzaGZsb3ctU0MgQmlsbC9Wb3VjaGVyIEFjY2VwdG9yICovDQpA
QCAtMTI0LDYgKzEyNSw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBpZF90
YWJsZVtdID0gew0KIAl7IFVTQl9ERVZJQ0UoMHgxMEM0LCAweDg1RjgpIH0sIC8qIFZpcnRlbmlv
IFByZW9uMzIgKi8NCiAJeyBVU0JfREVWSUNFKDB4MTBDNCwgMHg4NjY0KSB9LCAvKiBBQy1TZXJ2
aWNlcyBDQU4tSUYgKi8NCiAJeyBVU0JfREVWSUNFKDB4MTBDNCwgMHg4NjY1KSB9LCAvKiBBQy1T
ZXJ2aWNlcyBPQkQtSUYgKi8NCisJeyBVU0JfREVWSUNFKDB4MTBDNCwgMHg4OEE0KSB9LCAvKiBN
TUIgTmV0d29ya3MgWmlnQmVlIFVTQiBEZXZpY2UgKi8NCisJeyBVU0JfREVWSUNFKDB4MTBDNCwg
MHg4OEE1KSB9LCAvKiBQbGFuZXQgSW5ub3ZhdGlvbiBJbmdlbmkgWmlnQmVlIFVTQiBEZXZpY2Ug
Ki8NCiAJeyBVU0JfREVWSUNFKDB4MTBDNCwgMHhFQTYwKSB9LCAvKiBTaWxpY29uIExhYnMgZmFj
dG9yeSBkZWZhdWx0ICovDQogCXsgVVNCX0RFVklDRSgweDEwQzQsIDB4RUE2MSkgfSwgLyogU2ls
aWNvbiBMYWJzIGZhY3RvcnkgZGVmYXVsdCAqLw0KIAl7IFVTQl9ERVZJQ0UoMHgxMEM0LCAweEVB
NzApIH0sIC8qIFNpbGljb24gTGFicyBmYWN0b3J5IGRlZmF1bHQgKi8NCkBAIC0xNTQsNiArMTU3
LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkIGlkX3RhYmxlW10gPSB7DQog
CXsgVVNCX0RFVklDRSgweDE3RjQsIDB4QUFBQSkgfSwgLyogV2F2ZXNlbnNlIEphenogYmxvb2Qg
Z2x1Y29zZSBtZXRlciAqLw0KIAl7IFVTQl9ERVZJQ0UoMHgxODQzLCAweDAyMDApIH0sIC8qIFZh
aXNhbGEgVVNCIEluc3RydW1lbnQgQ2FibGUgKi8NCiAJeyBVU0JfREVWSUNFKDB4MThFRiwgMHhF
MDBGKSB9LCAvKiBFTFYgVVNCLUkyQy1JbnRlcmZhY2UgKi8NCisJeyBVU0JfREVWSUNFKDB4MUFE
QiwgMHgwMDAxKSB9LCAvKiBTY2h3ZWl0emVyIEVuZ2luZWVyaW5nIEM2NjIgQ2FibGUgKi8NCiAJ
eyBVU0JfREVWSUNFKDB4MUJFMywgMHgwN0E2KSB9LCAvKiBXQUdPIDc1MC05MjMgVVNCIFNlcnZp
Y2UgQ2FibGUgKi8NCiAJeyBVU0JfREVWSUNFKDB4MUUyOSwgMHgwMTAyKSB9LCAvKiBGZXN0byBD
UFgtVVNCICovDQogCXsgVVNCX0RFVklDRSgweDFFMjksIDB4MDUwMSkgfSwgLyogRmVzdG8gQ01T
UCAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9tb3M3ODQwLmMgYi9kcml2ZXJz
L3VzYi9zZXJpYWwvbW9zNzg0MC5jDQppbmRleCBlODllZTQ4Li41ZThjNzM2IDEwMDY0NA0KLS0t
IGEvZHJpdmVycy91c2Ivc2VyaWFsL21vczc4NDAuYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFs
L21vczc4NDAuYw0KQEAgLTkyNSwyMCArOTI1LDIwIEBAIHN0YXRpYyBpbnQgbW9zNzg0MF9vcGVu
KHN0cnVjdCB0dHlfc3RydWN0ICp0dHksIHN0cnVjdCB1c2Jfc2VyaWFsX3BvcnQgKnBvcnQpDQog
CXN0YXR1cyA9IG1vczc4NDBfZ2V0X3JlZ19zeW5jKHBvcnQsIG1vczc4NDBfcG9ydC0+U3BSZWdP
ZmZzZXQsICZEYXRhKTsNCiAJaWYgKHN0YXR1cyA8IDApIHsNCiAJCWRiZygiUmVhZGluZyBTcHJl
ZyBmYWlsZWQiKTsNCi0JCXJldHVybiAtMTsNCisJCWdvdG8gZXJyOw0KIAl9DQogCURhdGEgfD0g
MHg4MDsNCiAJc3RhdHVzID0gbW9zNzg0MF9zZXRfcmVnX3N5bmMocG9ydCwgbW9zNzg0MF9wb3J0
LT5TcFJlZ09mZnNldCwgRGF0YSk7DQogCWlmIChzdGF0dXMgPCAwKSB7DQogCQlkYmcoIndyaXRp
bmcgU3ByZWcgZmFpbGVkIik7DQotCQlyZXR1cm4gLTE7DQorCQlnb3RvIGVycjsNCiAJfQ0KIA0K
IAlEYXRhICY9IH4weDgwOw0KIAlzdGF0dXMgPSBtb3M3ODQwX3NldF9yZWdfc3luYyhwb3J0LCBt
b3M3ODQwX3BvcnQtPlNwUmVnT2Zmc2V0LCBEYXRhKTsNCiAJaWYgKHN0YXR1cyA8IDApIHsNCiAJ
CWRiZygid3JpdGluZyBTcHJlZyBmYWlsZWQiKTsNCi0JCXJldHVybiAtMTsNCisJCWdvdG8gZXJy
Ow0KIAl9DQogCS8qIEVuZCBvZiBibG9jayB0byBiZSBjaGVja2VkICovDQogDQpAQCAtOTQ3LDcg
Kzk0Nyw3IEBAIHN0YXRpYyBpbnQgbW9zNzg0MF9vcGVuKHN0cnVjdCB0dHlfc3RydWN0ICp0dHks
IHN0cnVjdCB1c2Jfc2VyaWFsX3BvcnQgKnBvcnQpDQogCQkJCQkJCQkJJkRhdGEpOw0KIAlpZiAo
c3RhdHVzIDwgMCkgew0KIAkJZGJnKCJSZWFkaW5nIENvbnRyb2xyZWcgZmFpbGVkIik7DQotCQly
ZXR1cm4gLTE7DQorCQlnb3RvIGVycjsNCiAJfQ0KIAlEYXRhIHw9IDB4MDg7CQkvKiBEcml2ZXIg
ZG9uZSBiaXQgKi8NCiAJRGF0YSB8PSAweDIwOwkJLyogcnhfZGlzYWJsZSAqLw0KQEAgLTk1NSw3
ICs5NTUsNyBAQCBzdGF0aWMgaW50IG1vczc4NDBfb3BlbihzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5
LCBzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0ICpwb3J0KQ0KIAkJCQltb3M3ODQwX3BvcnQtPkNvbnRy
b2xSZWdPZmZzZXQsIERhdGEpOw0KIAlpZiAoc3RhdHVzIDwgMCkgew0KIAkJZGJnKCJ3cml0aW5n
IENvbnRyb2xyZWcgZmFpbGVkIik7DQotCQlyZXR1cm4gLTE7DQorCQlnb3RvIGVycjsNCiAJfQ0K
IAkvKiBkbyByZWdpc3RlciBzZXR0aW5ncyBoZXJlICovDQogCS8qIFNldCBhbGwgcmVncyB0byB0
aGUgZGV2aWNlIGRlZmF1bHQgdmFsdWVzLiAqLw0KQEAgLTk2NiwyMSArOTY2LDIxIEBAIHN0YXRp
YyBpbnQgbW9zNzg0MF9vcGVuKHN0cnVjdCB0dHlfc3RydWN0ICp0dHksIHN0cnVjdCB1c2Jfc2Vy
aWFsX3BvcnQgKnBvcnQpDQogCXN0YXR1cyA9IG1vczc4NDBfc2V0X3VhcnRfcmVnKHBvcnQsIElO
VEVSUlVQVF9FTkFCTEVfUkVHSVNURVIsIERhdGEpOw0KIAlpZiAoc3RhdHVzIDwgMCkgew0KIAkJ
ZGJnKCJkaXNhYmxpbmcgaW50ZXJydXB0cyBmYWlsZWQiKTsNCi0JCXJldHVybiAtMTsNCisJCWdv
dG8gZXJyOw0KIAl9DQogCS8qIFNldCBGSUZPX0NPTlRST0xfUkVHSVNURVIgdG8gdGhlIGRlZmF1
bHQgdmFsdWUgKi8NCiAJRGF0YSA9IDB4MDA7DQogCXN0YXR1cyA9IG1vczc4NDBfc2V0X3VhcnRf
cmVnKHBvcnQsIEZJRk9fQ09OVFJPTF9SRUdJU1RFUiwgRGF0YSk7DQogCWlmIChzdGF0dXMgPCAw
KSB7DQogCQlkYmcoIldyaXRpbmcgRklGT19DT05UUk9MX1JFR0lTVEVSICBmYWlsZWQiKTsNCi0J
CXJldHVybiAtMTsNCisJCWdvdG8gZXJyOw0KIAl9DQogDQogCURhdGEgPSAweGNmOw0KIAlzdGF0
dXMgPSBtb3M3ODQwX3NldF91YXJ0X3JlZyhwb3J0LCBGSUZPX0NPTlRST0xfUkVHSVNURVIsIERh
dGEpOw0KIAlpZiAoc3RhdHVzIDwgMCkgew0KIAkJZGJnKCJXcml0aW5nIEZJRk9fQ09OVFJPTF9S
RUdJU1RFUiAgZmFpbGVkIik7DQotCQlyZXR1cm4gLTE7DQorCQlnb3RvIGVycjsNCiAJfQ0KIA0K
IAlEYXRhID0gMHgwMzsNCkBAIC0xMTM2LDcgKzExMzYsMTUgQEAgc3RhdGljIGludCBtb3M3ODQw
X29wZW4oc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwgc3RydWN0IHVzYl9zZXJpYWxfcG9ydCAqcG9y
dCkNCiAJZGJnICgiJXMgbGVhdmUiLCBfX2Z1bmNfXyk7DQogDQogCXJldHVybiAwOw0KLQ0KK2Vy
cjoNCisJZm9yIChqID0gMDsgaiA8IE5VTV9VUkJTOyArK2opIHsNCisJCXVyYiA9IG1vczc4NDBf
cG9ydC0+d3JpdGVfdXJiX3Bvb2xbal07DQorCQlpZiAoIXVyYikNCisJCQljb250aW51ZTsNCisJ
CWtmcmVlKHVyYi0+dHJhbnNmZXJfYnVmZmVyKTsNCisJCXVzYl9mcmVlX3VyYih1cmIpOw0KKwl9
DQorCXJldHVybiBzdGF0dXM7DQogfQ0KIA0KIC8qKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9vcHRpb24uYyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9v
cHRpb24uYw0KaW5kZXggYjgzNjVhNy4uYzIxMDNmNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNi
L3NlcmlhbC9vcHRpb24uYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL29wdGlvbi5jDQpAQCAt
MzQ3LDE3ICszNDcsMTIgQEAgc3RhdGljIHZvaWQgb3B0aW9uX2luc3RhdF9jYWxsYmFjayhzdHJ1
Y3QgdXJiICp1cmIpOw0KICNkZWZpbmUgT0xJVkVUVElfVkVORE9SX0lECQkJMHgwYjNjDQogI2Rl
ZmluZSBPTElWRVRUSV9QUk9EVUNUX09MSUNBUkQxMDAJCTB4YzAwMA0KICNkZWZpbmUgT0xJVkVU
VElfUFJPRFVDVF9PTElDQVJEMTQ1CQkweGMwMDMNCisjZGVmaW5lIE9MSVZFVFRJX1BST0RVQ1Rf
T0xJQ0FSRDIwMAkJMHhjMDA1DQogDQogLyogQ2Vsb3QgcHJvZHVjdHMgKi8NCiAjZGVmaW5lIENF
TE9UX1ZFTkRPUl9JRAkJCQkweDIxMWYNCiAjZGVmaW5lIENFTE9UX1BST0RVQ1RfQ1Q2ODBNCQkJ
MHg2ODAxDQogDQotLyogT05EQSBDb21tdW5pY2F0aW9uIHZlbmRvciBpZCAqLw0KLSNkZWZpbmUg
T05EQV9WRU5ET1JfSUQgICAgICAgMHgxZWU4DQotDQotLyogT05EQSBNVDgyNVVQIEhTRFBBIDE0
LjIgbW9kZW0gKi8NCi0jZGVmaW5lIE9OREFfTVQ4MjVVUCAgICAgICAgIDB4MDAwYg0KLQ0KIC8q
IFNhbXN1bmcgcHJvZHVjdHMgKi8NCiAjZGVmaW5lIFNBTVNVTkdfVkVORE9SX0lEICAgICAgICAg
ICAgICAgICAgICAgICAweDA0ZTgNCiAjZGVmaW5lIFNBTVNVTkdfUFJPRFVDVF9HVF9CMzczMCAg
ICAgICAgICAgICAgICAweDY4ODkNCkBAIC00NTAsNyArNDQ1LDggQEAgc3RhdGljIHZvaWQgb3B0
aW9uX2luc3RhdF9jYWxsYmFjayhzdHJ1Y3QgdXJiICp1cmIpOw0KIA0KIC8qIEh5dW5kYWkgUGV0
YXRlbCBJbmMuIHByb2R1Y3RzICovDQogI2RlZmluZSBQRVRBVEVMX1ZFTkRPUl9JRAkJCTB4MWZm
NA0KLSNkZWZpbmUgUEVUQVRFTF9QUk9EVUNUX05QMTBUCQkJMHg2MDBlDQorI2RlZmluZSBQRVRB
VEVMX1BST0RVQ1RfTlAxMFRfNjAwQQkJMHg2MDBhDQorI2RlZmluZSBQRVRBVEVMX1BST0RVQ1Rf
TlAxMFRfNjAwRQkJMHg2MDBlDQogDQogLyogVFAtTElOSyBJbmNvcnBvcmF0ZWQgcHJvZHVjdHMg
Ki8NCiAjZGVmaW5lIFRQTElOS19WRU5ET1JfSUQJCQkweDIzNTcNCkBAIC03OTcsNiArNzkzLDcg
QEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkIG9wdGlvbl9pZHNbXSA9IHsNCiAJ
eyBVU0JfREVWSUNFKEtZT0NFUkFfVkVORE9SX0lELCBLWU9DRVJBX1BST0RVQ1RfS1BDNjgwKSB9
LA0KIAl7IFVTQl9ERVZJQ0UoUVVBTENPTU1fVkVORE9SX0lELCAweDYwMDApfSwgLyogWlRFIEFD
ODcwMCAqLw0KIAl7IFVTQl9ERVZJQ0UoUVVBTENPTU1fVkVORE9SX0lELCAweDY2MTMpfSwgLyog
T25kYSBINjAwL1pURSBNRjMzMCAqLw0KKwl7IFVTQl9ERVZJQ0UoUVVBTENPTU1fVkVORE9SX0lE
LCAweDAwMjMpfSwgLyogT05ZWCAzRyBkZXZpY2UgKi8NCiAJeyBVU0JfREVWSUNFKFFVQUxDT01N
X1ZFTkRPUl9JRCwgMHg5MDAwKX0sIC8qIFNJTUNvbSBTSU01MjE4ICovDQogCXsgVVNCX0RFVklD
RShDTU9URUNIX1ZFTkRPUl9JRCwgQ01PVEVDSF9QUk9EVUNUXzYyODApIH0sIC8qIEJQMy1VU0Ig
JiBCUDMtRVhUIEhTRFBBICovDQogCXsgVVNCX0RFVklDRShDTU9URUNIX1ZFTkRPUl9JRCwgQ01P
VEVDSF9QUk9EVUNUXzYwMDgpIH0sDQpAQCAtODMyLDcgKzgyOSw4IEBAIHN0YXRpYyBjb25zdCBz
dHJ1Y3QgdXNiX2RldmljZV9pZCBvcHRpb25faWRzW10gPSB7DQogCXsgVVNCX0RFVklDRV9BTkRf
SU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwgMHgwMDE3LCAweGZmLCAweGZmLCAweGZmKSwN
CiAJCS5kcml2ZXJfaW5mbyA9IChrZXJuZWxfdWxvbmdfdCkmbmV0X2ludGYzX2JsYWNrbGlzdCB9
LA0KIAl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFpURV9WRU5ET1JfSUQsIDB4MDAx
OCwgMHhmZiwgMHhmZiwgMHhmZikgfSwNCi0JeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5G
TyhaVEVfVkVORE9SX0lELCAweDAwMTksIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sDQorCXsgVVNCX0RF
VklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwgMHgwMDE5LCAweGZmLCAweGZm
LCAweGZmKSwNCisJCS5kcml2ZXJfaW5mbyA9IChrZXJuZWxfdWxvbmdfdCkmbmV0X2ludGYzX2Js
YWNrbGlzdCB9LA0KIAl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFpURV9WRU5ET1Jf
SUQsIDB4MDAyMCwgMHhmZiwgMHhmZiwgMHhmZikgfSwNCiAJeyBVU0JfREVWSUNFX0FORF9JTlRF
UkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweDAwMjEsIDB4ZmYsIDB4ZmYsIDB4ZmYpLA0KIAkJ
LmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9uZ190KSZuZXRfaW50ZjRfYmxhY2tsaXN0IH0sDQpA
QCAtMTI3OCw4ICsxMjc2LDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkIG9w
dGlvbl9pZHNbXSA9IHsNCiANCiAJeyBVU0JfREVWSUNFKE9MSVZFVFRJX1ZFTkRPUl9JRCwgT0xJ
VkVUVElfUFJPRFVDVF9PTElDQVJEMTAwKSB9LA0KIAl7IFVTQl9ERVZJQ0UoT0xJVkVUVElfVkVO
RE9SX0lELCBPTElWRVRUSV9QUk9EVUNUX09MSUNBUkQxNDUpIH0sDQorCXsgVVNCX0RFVklDRShP
TElWRVRUSV9WRU5ET1JfSUQsIE9MSVZFVFRJX1BST0RVQ1RfT0xJQ0FSRDIwMCkgfSwNCiAJeyBV
U0JfREVWSUNFKENFTE9UX1ZFTkRPUl9JRCwgQ0VMT1RfUFJPRFVDVF9DVDY4ME0pIH0sIC8qIENU
LTY1MCBDRE1BIDQ1MCAxeEVWRE8gbW9kZW0gKi8NCi0JeyBVU0JfREVWSUNFKE9OREFfVkVORE9S
X0lELCBPTkRBX01UODI1VVApIH0sIC8qIE9OREEgTVQ4MjVVUCBtb2RlbSAqLw0KIAl7IFVTQl9E
RVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFNBTVNVTkdfVkVORE9SX0lELCBTQU1TVU5HX1BST0RV
Q1RfR1RfQjM3MzAsIFVTQl9DTEFTU19DRENfREFUQSwgMHgwMCwgMHgwMCkgfSwgLyogU2Ftc3Vu
ZyBHVC1CMzczMCBMVEUgVVNCIG1vZGVtLiovDQogCXsgVVNCX0RFVklDRShZVUdBX1ZFTkRPUl9J
RCwgWVVHQV9QUk9EVUNUX0NFTTYwMCkgfSwNCiAJeyBVU0JfREVWSUNFKFlVR0FfVkVORE9SX0lE
LCBZVUdBX1BST0RVQ1RfQ0VNNjEwKSB9LA0KQEAgLTEzNTEsOSArMTM0OSwxMiBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgb3B0aW9uX2lkc1tdID0gew0KIAl7IFVTQl9ERVZJ
Q0VfQU5EX0lOVEVSRkFDRV9JTkZPKE1FRElBVEVLX1ZFTkRPUl9JRCwgTUVESUFURUtfUFJPRFVD
VF9EQ180Q09NMiwgMHhmZiwgMHgwMiwgMHgwMSkgfSwNCiAJeyBVU0JfREVWSUNFX0FORF9JTlRF
UkZBQ0VfSU5GTyhNRURJQVRFS19WRU5ET1JfSUQsIE1FRElBVEVLX1BST0RVQ1RfRENfNENPTTIs
IDB4ZmYsIDB4MDAsIDB4MDApIH0sDQogCXsgVVNCX0RFVklDRShDRUxMSUVOVF9WRU5ET1JfSUQs
IENFTExJRU5UX1BST0RVQ1RfTUVOMjAwKSB9LA0KLQl7IFVTQl9ERVZJQ0UoUEVUQVRFTF9WRU5E
T1JfSUQsIFBFVEFURUxfUFJPRFVDVF9OUDEwVCkgfSwNCisJeyBVU0JfREVWSUNFKFBFVEFURUxf
VkVORE9SX0lELCBQRVRBVEVMX1BST0RVQ1RfTlAxMFRfNjAwQSkgfSwNCisJeyBVU0JfREVWSUNF
KFBFVEFURUxfVkVORE9SX0lELCBQRVRBVEVMX1BST0RVQ1RfTlAxMFRfNjAwRSkgfSwNCiAJeyBV
U0JfREVWSUNFKFRQTElOS19WRU5ET1JfSUQsIFRQTElOS19QUk9EVUNUX01BMTgwKSwNCiAJICAu
ZHJpdmVyX2luZm8gPSAoa2VybmVsX3Vsb25nX3QpJm5ldF9pbnRmNF9ibGFja2xpc3QgfSwNCisJ
eyBVU0JfREVWSUNFKFRQTElOS19WRU5ET1JfSUQsIDB4OTAwMCksCQkJCQkvKiBUUC1MaW5rIE1B
MjYwICovDQorCSAgLmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9uZ190KSZuZXRfaW50ZjRfYmxh
Y2tsaXN0IH0sDQogCXsgVVNCX0RFVklDRShDSEFOR0hPTkdfVkVORE9SX0lELCBDSEFOR0hPTkdf
UFJPRFVDVF9DSDY5MCkgfSwNCiAJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTygweDIw
MDEsIDB4N2QwMSwgMHhmZiwgMHgwMiwgMHgwMSkgfSwJLyogRC1MaW5rIERXTS0xNTYgKHZhcmlh
bnQpICovDQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oMHgyMDAxLCAweDdkMDEs
IDB4ZmYsIDB4MDAsIDB4MDApIH0sCS8qIEQtTGluayBEV00tMTU2ICh2YXJpYW50KSAqLw0KQEAg
LTEzNjEsNiArMTM2Miw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBvcHRp
b25faWRzW10gPSB7DQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oMHgyMDAxLCAw
eDdkMDIsIDB4ZmYsIDB4MDAsIDB4MDApIH0sDQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNF
X0lORk8oMHgyMDAxLCAweDdkMDMsIDB4ZmYsIDB4MDIsIDB4MDEpIH0sDQogCXsgVVNCX0RFVklD
RV9BTkRfSU5URVJGQUNFX0lORk8oMHgyMDAxLCAweDdkMDMsIDB4ZmYsIDB4MDAsIDB4MDApIH0s
DQorCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oMHgwN2QxLCAweDNlMDEsIDB4ZmYs
IDB4ZmYsIDB4ZmYpIH0sIC8qIEQtTGluayBEV00tMTUyL0MxICovDQorCXsgVVNCX0RFVklDRV9B
TkRfSU5URVJGQUNFX0lORk8oMHgwN2QxLCAweDNlMDIsIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sIC8q
IEQtTGluayBEV00tMTU2L0MxICovDQogCXsgfSAvKiBUZXJtaW5hdGluZyBlbnRyeSAqLw0KIH07
DQogTU9EVUxFX0RFVklDRV9UQUJMRSh1c2IsIG9wdGlvbl9pZHMpOw0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdXNiL3NlcmlhbC90aV91c2JfMzQxMF81MDUyLmMgYi9kcml2ZXJzL3VzYi9zZXJpYWwv
dGlfdXNiXzM0MTBfNTA1Mi5jDQppbmRleCA5ZDNiMzllLi40MjAzOGJhIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy91c2Ivc2VyaWFsL3RpX3VzYl8zNDEwXzUwNTIuYw0KKysrIGIvZHJpdmVycy91c2Iv
c2VyaWFsL3RpX3VzYl8zNDEwXzUwNTIuYw0KQEAgLTQwOCw3ICs0MDgsNyBAQCBzdGF0aWMgaW50
IHRpX3N0YXJ0dXAoc3RydWN0IHVzYl9zZXJpYWwgKnNlcmlhbCkNCiAJdXNiX3NldF9zZXJpYWxf
ZGF0YShzZXJpYWwsIHRkZXYpOw0KIA0KIAkvKiBkZXRlcm1pbmUgZGV2aWNlIHR5cGUgKi8NCi0J
aWYgKHVzYl9tYXRjaF9pZChzZXJpYWwtPmludGVyZmFjZSwgdGlfaWRfdGFibGVfMzQxMCkpDQor
CWlmIChzZXJpYWwtPnR5cGUgPT0gJnRpXzFwb3J0X2RldmljZSkNCiAJCXRkZXYtPnRkX2lzXzM0
MTAgPSAxOw0KIAlkYmcoIiVzIC0gZGV2aWNlIHR5cGUgaXMgJXMiLCBfX2Z1bmNfXywNCiAJCQkJ
dGRldi0+dGRfaXNfMzQxMCA/ICIzNDEwIiA6ICI1MDUyIik7DQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy91c2Ivc3RvcmFnZS91bnVzdWFsX2RldnMuaCBiL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdW51c3Vh
bF9kZXZzLmgNCmluZGV4IDdiOGQ1NjQuLjhhM2I1MzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Vz
Yi9zdG9yYWdlL3VudXN1YWxfZGV2cy5oDQorKysgYi9kcml2ZXJzL3VzYi9zdG9yYWdlL3VudXN1
YWxfZGV2cy5oDQpAQCAtNjU3LDYgKzY1NywxMyBAQCBVTlVTVUFMX0RFViggIDB4MDU0YywgMHgw
MTZhLCAweDAwMDAsIDB4OTk5OSwNCiAJCVVTQl9TQ19ERVZJQ0UsIFVTQl9QUl9ERVZJQ0UsIE5V
TEwsDQogCQlVU19GTF9GSVhfSU5RVUlSWSApLA0KIA0KKy8qIFN1Ym1pdHRlZCBieSBSZW4gQmln
Y3JlbiA8YmlnY3Jlbi5yZW5Ac29ueW1vYmlsZS5jb20+ICovDQorVU5VU1VBTF9ERVYoICAweDA1
NGMsIDB4MDJhNSwgMHgwMTAwLCAweDAxMDAsDQorCQkiU29ueSBDb3JwLiIsDQorCQkiTWljcm9W
YXVsdCBGbGFzaCBEcml2ZSIsDQorCQlVU0JfU0NfREVWSUNFLCBVU0JfUFJfREVWSUNFLCBOVUxM
LA0KKwkJVVNfRkxfTk9fUkVBRF9DQVBBQ0lUWV8xNiApLA0KKw0KIC8qIGZsb3BweSByZXBvcnRz
IG11bHRpcGxlIGx1bnMgKi8NCiBVTlVTVUFMX0RFViggIDB4MDU1ZCwgMHgyMDIwLCAweDAwMDAs
IDB4MDIxMCwNCiAJCSJTQU1TVU5HIiwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpcnRpby92aXJ0
aW9fcmluZy5jIGIvZHJpdmVycy92aXJ0aW8vdmlydGlvX3JpbmcuYw0KaW5kZXggZGMyZWVkMS4u
NGE4OGFjMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdmlydGlvL3ZpcnRpb19yaW5nLmMNCisrKyBi
L2RyaXZlcnMvdmlydGlvL3ZpcnRpb19yaW5nLmMNCkBAIC0zNjAsOSArMzYwLDIyIEBAIHZvaWQg
dmlydHF1ZXVlX2Rpc2FibGVfY2Ioc3RydWN0IHZpcnRxdWV1ZSAqX3ZxKQ0KIH0NCiBFWFBPUlRf
U1lNQk9MX0dQTCh2aXJ0cXVldWVfZGlzYWJsZV9jYik7DQogDQotYm9vbCB2aXJ0cXVldWVfZW5h
YmxlX2NiKHN0cnVjdCB2aXJ0cXVldWUgKl92cSkNCisvKioNCisgKiB2aXJ0cXVldWVfZW5hYmxl
X2NiX3ByZXBhcmUgLSByZXN0YXJ0IGNhbGxiYWNrcyBhZnRlciBkaXNhYmxlX2NiDQorICogQHZx
OiB0aGUgc3RydWN0IHZpcnRxdWV1ZSB3ZSdyZSB0YWxraW5nIGFib3V0Lg0KKyAqDQorICogVGhp
cyByZS1lbmFibGVzIGNhbGxiYWNrczsgaXQgcmV0dXJucyBjdXJyZW50IHF1ZXVlIHN0YXRlDQor
ICogaW4gYW4gb3BhcXVlIHVuc2lnbmVkIHZhbHVlLiBUaGlzIHZhbHVlIHNob3VsZCBiZSBsYXRl
ciB0ZXN0ZWQgYnkNCisgKiB2aXJ0cXVldWVfcG9sbCwgdG8gZGV0ZWN0IGEgcG9zc2libGUgcmFj
ZSBiZXR3ZWVuIHRoZSBkcml2ZXIgY2hlY2tpbmcgZm9yDQorICogbW9yZSB3b3JrLCBhbmQgZW5h
YmxpbmcgY2FsbGJhY2tzLg0KKyAqDQorICogQ2FsbGVyIG11c3QgZW5zdXJlIHdlIGRvbid0IGNh
bGwgdGhpcyB3aXRoIG90aGVyIHZpcnRxdWV1ZQ0KKyAqIG9wZXJhdGlvbnMgYXQgdGhlIHNhbWUg
dGltZSAoZXhjZXB0IHdoZXJlIG5vdGVkKS4NCisgKi8NCit1bnNpZ25lZCB2aXJ0cXVldWVfZW5h
YmxlX2NiX3ByZXBhcmUoc3RydWN0IHZpcnRxdWV1ZSAqX3ZxKQ0KIHsNCiAJc3RydWN0IHZyaW5n
X3ZpcnRxdWV1ZSAqdnEgPSB0b192dnEoX3ZxKTsNCisJdTE2IGxhc3RfdXNlZF9pZHg7DQogDQog
CVNUQVJUX1VTRSh2cSk7DQogDQpAQCAtMzcyLDE1ICszODUsNDUgQEAgYm9vbCB2aXJ0cXVldWVf
ZW5hYmxlX2NiKHN0cnVjdCB2aXJ0cXVldWUgKl92cSkNCiAJICogZWl0aGVyIGNsZWFyIHRoZSBm
bGFncyBiaXQgb3IgcG9pbnQgdGhlIGV2ZW50IGluZGV4IGF0IHRoZSBuZXh0DQogCSAqIGVudHJ5
LiBBbHdheXMgZG8gYm90aCB0byBrZWVwIGNvZGUgc2ltcGxlLiAqLw0KIAl2cS0+dnJpbmcuYXZh
aWwtPmZsYWdzICY9IH5WUklOR19BVkFJTF9GX05PX0lOVEVSUlVQVDsNCi0JdnJpbmdfdXNlZF9l
dmVudCgmdnEtPnZyaW5nKSA9IHZxLT5sYXN0X3VzZWRfaWR4Ow0KKwl2cmluZ191c2VkX2V2ZW50
KCZ2cS0+dnJpbmcpID0gbGFzdF91c2VkX2lkeCA9IHZxLT5sYXN0X3VzZWRfaWR4Ow0KKwlFTkRf
VVNFKHZxKTsNCisJcmV0dXJuIGxhc3RfdXNlZF9pZHg7DQorfQ0KK0VYUE9SVF9TWU1CT0xfR1BM
KHZpcnRxdWV1ZV9lbmFibGVfY2JfcHJlcGFyZSk7DQorDQorLyoqDQorICogdmlydHF1ZXVlX3Bv
bGwgLSBxdWVyeSBwZW5kaW5nIHVzZWQgYnVmZmVycw0KKyAqIEB2cTogdGhlIHN0cnVjdCB2aXJ0
cXVldWUgd2UncmUgdGFsa2luZyBhYm91dC4NCisgKiBAbGFzdF91c2VkX2lkeDogdmlydHF1ZXVl
IHN0YXRlIChmcm9tIGNhbGwgdG8gdmlydHF1ZXVlX2VuYWJsZV9jYl9wcmVwYXJlKS4NCisgKg0K
KyAqIFJldHVybnMgInRydWUiIGlmIHRoZXJlIGFyZSBwZW5kaW5nIHVzZWQgYnVmZmVycyBpbiB0
aGUgcXVldWUuDQorICoNCisgKiBUaGlzIGRvZXMgbm90IG5lZWQgdG8gYmUgc2VyaWFsaXplZC4N
CisgKi8NCitib29sIHZpcnRxdWV1ZV9wb2xsKHN0cnVjdCB2aXJ0cXVldWUgKl92cSwgdW5zaWdu
ZWQgbGFzdF91c2VkX2lkeCkNCit7DQorCXN0cnVjdCB2cmluZ192aXJ0cXVldWUgKnZxID0gdG9f
dnZxKF92cSk7DQorDQogCXZpcnRpb19tYigpOw0KLQlpZiAodW5saWtlbHkobW9yZV91c2VkKHZx
KSkpIHsNCi0JCUVORF9VU0UodnEpOw0KLQkJcmV0dXJuIGZhbHNlOw0KLQl9DQorCXJldHVybiAo
dTE2KWxhc3RfdXNlZF9pZHggIT0gdnEtPnZyaW5nLnVzZWQtPmlkeDsNCit9DQorRVhQT1JUX1NZ
TUJPTF9HUEwodmlydHF1ZXVlX3BvbGwpOw0KIA0KLQlFTkRfVVNFKHZxKTsNCi0JcmV0dXJuIHRy
dWU7DQorLyoqDQorICogdmlydHF1ZXVlX2VuYWJsZV9jYiAtIHJlc3RhcnQgY2FsbGJhY2tzIGFm
dGVyIGRpc2FibGVfY2IuDQorICogQHZxOiB0aGUgc3RydWN0IHZpcnRxdWV1ZSB3ZSdyZSB0YWxr
aW5nIGFib3V0Lg0KKyAqDQorICogVGhpcyByZS1lbmFibGVzIGNhbGxiYWNrczsgaXQgcmV0dXJu
cyAiZmFsc2UiIGlmIHRoZXJlIGFyZSBwZW5kaW5nDQorICogYnVmZmVycyBpbiB0aGUgcXVldWUs
IHRvIGRldGVjdCBhIHBvc3NpYmxlIHJhY2UgYmV0d2VlbiB0aGUgZHJpdmVyDQorICogY2hlY2tp
bmcgZm9yIG1vcmUgd29yaywgYW5kIGVuYWJsaW5nIGNhbGxiYWNrcy4NCisgKg0KKyAqIENhbGxl
ciBtdXN0IGVuc3VyZSB3ZSBkb24ndCBjYWxsIHRoaXMgd2l0aCBvdGhlciB2aXJ0cXVldWUNCisg
KiBvcGVyYXRpb25zIGF0IHRoZSBzYW1lIHRpbWUgKGV4Y2VwdCB3aGVyZSBub3RlZCkuDQorICov
DQorYm9vbCB2aXJ0cXVldWVfZW5hYmxlX2NiKHN0cnVjdCB2aXJ0cXVldWUgKl92cSkNCit7DQor
CXVuc2lnbmVkIGxhc3RfdXNlZF9pZHggPSB2aXJ0cXVldWVfZW5hYmxlX2NiX3ByZXBhcmUoX3Zx
KTsNCisJcmV0dXJuICF2aXJ0cXVldWVfcG9sbChfdnEsIGxhc3RfdXNlZF9pZHgpOw0KIH0NCiBF
WFBPUlRfU1lNQk9MX0dQTCh2aXJ0cXVldWVfZW5hYmxlX2NiKTsNCiANCmRpZmYgLS1naXQgYS9m
cy9idHJmcy9leHRlbnQtdHJlZS5jIGIvZnMvYnRyZnMvZXh0ZW50LXRyZWUuYw0KaW5kZXggOGQ0
ZDUzZC4uNDllZWZkYiAxMDA2NDQNCi0tLSBhL2ZzL2J0cmZzL2V4dGVudC10cmVlLmMNCisrKyBi
L2ZzL2J0cmZzL2V4dGVudC10cmVlLmMNCkBAIC02NTYwLDYgKzY1NjAsNyBAQCB2b2lkIGJ0cmZz
X2Ryb3Bfc25hcHNob3Qoc3RydWN0IGJ0cmZzX3Jvb3QgKnJvb3QsDQogCWludCBlcnIgPSAwOw0K
IAlpbnQgcmV0Ow0KIAlpbnQgbGV2ZWw7DQorCWJvb2wgcm9vdF9kcm9wcGVkID0gZmFsc2U7DQog
DQogCXBhdGggPSBidHJmc19hbGxvY19wYXRoKCk7DQogCWlmICghcGF0aCkgew0KQEAgLTY2MTQs
NiArNjYxNSw3IEBAIHZvaWQgYnRyZnNfZHJvcF9zbmFwc2hvdChzdHJ1Y3QgYnRyZnNfcm9vdCAq
cm9vdCwNCiAJCXdoaWxlICgxKSB7DQogCQkJYnRyZnNfdHJlZV9sb2NrKHBhdGgtPm5vZGVzW2xl
dmVsXSk7DQogCQkJYnRyZnNfc2V0X2xvY2tfYmxvY2tpbmcocGF0aC0+bm9kZXNbbGV2ZWxdKTsN
CisJCQlwYXRoLT5sb2Nrc1tsZXZlbF0gPSBCVFJGU19XUklURV9MT0NLX0JMT0NLSU5HOw0KIA0K
IAkJCXJldCA9IGJ0cmZzX2xvb2t1cF9leHRlbnRfaW5mbyh0cmFucywgcm9vdCwNCiAJCQkJCQlw
YXRoLT5ub2Rlc1tsZXZlbF0tPnN0YXJ0LA0KQEAgLTY2MjcsNiArNjYyOSw3IEBAIHZvaWQgYnRy
ZnNfZHJvcF9zbmFwc2hvdChzdHJ1Y3QgYnRyZnNfcm9vdCAqcm9vdCwNCiAJCQkJYnJlYWs7DQog
DQogCQkJYnRyZnNfdHJlZV91bmxvY2socGF0aC0+bm9kZXNbbGV2ZWxdKTsNCisJCQlwYXRoLT5s
b2Nrc1tsZXZlbF0gPSAwOw0KIAkJCVdBUk5fT04od2MtPnJlZnNbbGV2ZWxdICE9IDEpOw0KIAkJ
CWxldmVsLS07DQogCQl9DQpAQCAtNjcwNywxMSArNjcxMCwyMSBAQCB2b2lkIGJ0cmZzX2Ryb3Bf
c25hcHNob3Qoc3RydWN0IGJ0cmZzX3Jvb3QgKnJvb3QsDQogCQlmcmVlX2V4dGVudF9idWZmZXIo
cm9vdC0+Y29tbWl0X3Jvb3QpOw0KIAkJa2ZyZWUocm9vdCk7DQogCX0NCisJcm9vdF9kcm9wcGVk
ID0gdHJ1ZTsNCiBvdXRfZnJlZToNCiAJYnRyZnNfZW5kX3RyYW5zYWN0aW9uX3Rocm90dGxlKHRy
YW5zLCB0cmVlX3Jvb3QpOw0KIAlrZnJlZSh3Yyk7DQogCWJ0cmZzX2ZyZWVfcGF0aChwYXRoKTsN
CiBvdXQ6DQorCS8qDQorCSAqIFNvIGlmIHdlIG5lZWQgdG8gc3RvcCBkcm9wcGluZyB0aGUgc25h
cHNob3QgZm9yIHdoYXRldmVyIHJlYXNvbiB3ZQ0KKwkgKiBuZWVkIHRvIG1ha2Ugc3VyZSB0byBh
ZGQgaXQgYmFjayB0byB0aGUgZGVhZCByb290IGxpc3Qgc28gdGhhdCB3ZQ0KKwkgKiBrZWVwIHRy
eWluZyB0byBkbyB0aGUgd29yayBsYXRlci4gIFRoaXMgYWxzbyBjbGVhbnMgdXAgcm9vdHMgaWYg
d2UNCisJICogZG9uJ3QgaGF2ZSBpdCBpbiB0aGUgcmFkaXggKGxpa2Ugd2hlbiB3ZSByZWNvdmVy
IGFmdGVyIGEgcG93ZXIgZmFpbA0KKwkgKiBvciB1bm1vdW50KSBzbyB3ZSBkb24ndCBsZWFrIG1l
bW9yeS4NCisJICovDQorCWlmIChyb290X2Ryb3BwZWQgPT0gZmFsc2UpDQorCQlidHJmc19hZGRf
ZGVhZF9yb290KHJvb3QpOw0KIAlpZiAoZXJyKQ0KIAkJYnRyZnNfc3RkX2Vycm9yKHJvb3QtPmZz
X2luZm8sIGVycik7DQogCXJldHVybjsNCmRpZmYgLS1naXQgYS9mcy9leHQ0L21iYWxsb2MuYyBi
L2ZzL2V4dDQvbWJhbGxvYy5jDQppbmRleCA5MjQzMTAzLi45YjhjMTMxIDEwMDY0NA0KLS0tIGEv
ZnMvZXh0NC9tYmFsbG9jLmMNCisrKyBiL2ZzL2V4dDQvbWJhbGxvYy5jDQpAQCAtNDY5NiwxMSAr
NDY5NiwxNiBAQCBkb19tb3JlOg0KIAkJICogYmxvY2tzIGJlaW5nIGZyZWVkIGFyZSBtZXRhZGF0
YS4gdGhlc2UgYmxvY2tzIHNob3VsZG4ndA0KIAkJICogYmUgdXNlZCB1bnRpbCB0aGlzIHRyYW5z
YWN0aW9uIGlzIGNvbW1pdHRlZA0KIAkJICovDQorCXJldHJ5Og0KIAkJbmV3X2VudHJ5ID0ga21l
bV9jYWNoZV9hbGxvYyhleHQ0X2ZyZWVfZXh0X2NhY2hlcCwgR0ZQX05PRlMpOw0KIAkJaWYgKCFu
ZXdfZW50cnkpIHsNCi0JCQlleHQ0X21iX3VubG9hZF9idWRkeSgmZTRiKTsNCi0JCQllcnIgPSAt
RU5PTUVNOw0KLQkJCWdvdG8gZXJyb3JfcmV0dXJuOw0KKwkJCS8qDQorCQkJICogV2UgdXNlIGEg
cmV0cnkgbG9vcCBiZWNhdXNlDQorCQkJICogZXh0NF9mcmVlX2Jsb2NrcygpIGlzIG5vdCBhbGxv
d2VkIHRvIGZhaWwuDQorCQkJICovDQorCQkJY29uZF9yZXNjaGVkKCk7DQorCQkJY29uZ2VzdGlv
bl93YWl0KEJMS19SV19BU1lOQywgSFovNTApOw0KKwkJCWdvdG8gcmV0cnk7DQogCQl9DQogCQlu
ZXdfZW50cnktPnN0YXJ0X2NsdXN0ZXIgPSBiaXQ7DQogCQluZXdfZW50cnktPmdyb3VwICA9IGJs
b2NrX2dyb3VwOw0KZGlmZiAtLWdpdCBhL2ZzL2xvY2tkL3N2Y2xvY2suYyBiL2ZzL2xvY2tkL3N2
Y2xvY2suYw0KaW5kZXggZjAxNzljMy4uY2Q4NzAzZCAxMDA2NDQNCi0tLSBhL2ZzL2xvY2tkL3N2
Y2xvY2suYw0KKysrIGIvZnMvbG9ja2Qvc3ZjbG9jay5jDQpAQCAtOTEzLDYgKzkxMyw3IEBAIG5s
bXN2Y19yZXRyeV9ibG9ja2VkKHZvaWQpDQogCXVuc2lnbmVkIGxvbmcJdGltZW91dCA9IE1BWF9T
Q0hFRFVMRV9USU1FT1VUOw0KIAlzdHJ1Y3QgbmxtX2Jsb2NrICpibG9jazsNCiANCisJc3Bpbl9s
b2NrKCZubG1fYmxvY2tlZF9sb2NrKTsNCiAJd2hpbGUgKCFsaXN0X2VtcHR5KCZubG1fYmxvY2tl
ZCkgJiYgIWt0aHJlYWRfc2hvdWxkX3N0b3AoKSkgew0KIAkJYmxvY2sgPSBsaXN0X2VudHJ5KG5s
bV9ibG9ja2VkLm5leHQsIHN0cnVjdCBubG1fYmxvY2ssIGJfbGlzdCk7DQogDQpAQCAtOTIyLDYg
KzkyMyw3IEBAIG5sbXN2Y19yZXRyeV9ibG9ja2VkKHZvaWQpDQogCQkJdGltZW91dCA9IGJsb2Nr
LT5iX3doZW4gLSBqaWZmaWVzOw0KIAkJCWJyZWFrOw0KIAkJfQ0KKwkJc3Bpbl91bmxvY2soJm5s
bV9ibG9ja2VkX2xvY2spOw0KIA0KIAkJZHByaW50aygibmxtc3ZjX3JldHJ5X2Jsb2NrZWQoJXAs
IHdoZW49JWxkKVxuIiwNCiAJCQlibG9jaywgYmxvY2stPmJfd2hlbik7DQpAQCAtOTMxLDcgKzkz
Myw5IEBAIG5sbXN2Y19yZXRyeV9ibG9ja2VkKHZvaWQpDQogCQkJcmV0cnlfZGVmZXJyZWRfYmxv
Y2soYmxvY2spOw0KIAkJfSBlbHNlDQogCQkJbmxtc3ZjX2dyYW50X2Jsb2NrZWQoYmxvY2spOw0K
KwkJc3Bpbl9sb2NrKCZubG1fYmxvY2tlZF9sb2NrKTsNCiAJfQ0KKwlzcGluX3VubG9jaygmbmxt
X2Jsb2NrZWRfbG9jayk7DQogDQogCXJldHVybiB0aW1lb3V0Ow0KIH0NCmRpZmYgLS1naXQgYS9m
cy9uZnNkL3Zmcy5jIGIvZnMvbmZzZC92ZnMuYw0KaW5kZXggMWVjMWZkZS4uNTYxYTNkYyAxMDA2
NDQNCi0tLSBhL2ZzL25mc2QvdmZzLmMNCisrKyBiL2ZzL25mc2QvdmZzLmMNCkBAIC03ODIsOSAr
NzgyLDEwIEBAIG5mc2Rfb3BlbihzdHJ1Y3Qgc3ZjX3Jxc3QgKnJxc3RwLCBzdHJ1Y3Qgc3ZjX2Zo
ICpmaHAsIGludCB0eXBlLA0KIAl9DQogCSpmaWxwID0gZGVudHJ5X29wZW4oZGdldChkZW50cnkp
LCBtbnRnZXQoZmhwLT5maF9leHBvcnQtPmV4X3BhdGgubW50KSwNCiAJCQkgICAgZmxhZ3MsIGN1
cnJlbnRfY3JlZCgpKTsNCi0JaWYgKElTX0VSUigqZmlscCkpDQorCWlmIChJU19FUlIoKmZpbHAp
KSB7DQogCQlob3N0X2VyciA9IFBUUl9FUlIoKmZpbHApOw0KLQllbHNlDQorCQkqZmlscCA9IE5V
TEw7DQorCX0gZWxzZQ0KIAkJaG9zdF9lcnIgPSBpbWFfZmlsZV9jaGVjaygqZmlscCwgYWNjZXNz
KTsNCiBvdXRfbmZzZXJyOg0KIAllcnIgPSBuZnNlcnJubyhob3N0X2Vycik7DQpkaWZmIC0tZ2l0
IGEvZnMvbm90aWZ5L2Zhbm90aWZ5L2Zhbm90aWZ5X3VzZXIuYyBiL2ZzL25vdGlmeS9mYW5vdGlm
eS9mYW5vdGlmeV91c2VyLmMNCmluZGV4IDlmZGUxYzAuLjk4NjBmNmIgMTAwNjQ0DQotLS0gYS9m
cy9ub3RpZnkvZmFub3RpZnkvZmFub3RpZnlfdXNlci5jDQorKysgYi9mcy9ub3RpZnkvZmFub3Rp
ZnkvZmFub3RpZnlfdXNlci5jDQpAQCAtMTE4LDYgKzExOCw3IEBAIHN0YXRpYyBpbnQgZmlsbF9l
dmVudF9tZXRhZGF0YShzdHJ1Y3QgZnNub3RpZnlfZ3JvdXAgKmdyb3VwLA0KIAltZXRhZGF0YS0+
ZXZlbnRfbGVuID0gRkFOX0VWRU5UX01FVEFEQVRBX0xFTjsNCiAJbWV0YWRhdGEtPm1ldGFkYXRh
X2xlbiA9IEZBTl9FVkVOVF9NRVRBREFUQV9MRU47DQogCW1ldGFkYXRhLT52ZXJzID0gRkFOT1RJ
RllfTUVUQURBVEFfVkVSU0lPTjsNCisJbWV0YWRhdGEtPnJlc2VydmVkID0gMDsNCiAJbWV0YWRh
dGEtPm1hc2sgPSBldmVudC0+bWFzayAmIEZBTl9BTExfT1VUR09JTkdfRVZFTlRTOw0KIAltZXRh
ZGF0YS0+cGlkID0gcGlkX3ZucihldmVudC0+dGdpZCk7DQogCWlmICh1bmxpa2VseShldmVudC0+
bWFzayAmIEZBTl9RX09WRVJGTE9XKSkNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2lmX3Bw
cG94LmggYi9pbmNsdWRlL2xpbnV4L2lmX3BwcG94LmgNCmluZGV4IGI1ZjkyN2YuLjczMmM5NjIg
MTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L2lmX3BwcG94LmgNCisrKyBiL2luY2x1ZGUvbGlu
dXgvaWZfcHBwb3guaA0KQEAgLTEyOCwxMSArMTI4LDExIEBAIHN0cnVjdCBwcHBvZV90YWcgew0K
IA0KIHN0cnVjdCBwcHBvZV9oZHIgew0KICNpZiBkZWZpbmVkKF9fTElUVExFX0VORElBTl9CSVRG
SUVMRCkNCi0JX191OCB2ZXIgOiA0Ow0KIAlfX3U4IHR5cGUgOiA0Ow0KKwlfX3U4IHZlciA6IDQ7
DQogI2VsaWYgZGVmaW5lZChfX0JJR19FTkRJQU5fQklURklFTEQpDQotCV9fdTggdHlwZSA6IDQ7
DQogCV9fdTggdmVyIDogNDsNCisJX191OCB0eXBlIDogNDsNCiAjZWxzZQ0KICNlcnJvcgkiUGxl
YXNlIGZpeCA8YXNtL2J5dGVvcmRlci5oPiINCiAjZW5kaWYNCmRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L3ZpcnRpby5oIGIvaW5jbHVkZS9saW51eC92aXJ0aW8uaA0KaW5kZXggNGMwNjlkOGIu
Ljk2Yzc4NDMgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3ZpcnRpby5oDQorKysgYi9pbmNs
dWRlL2xpbnV4L3ZpcnRpby5oDQpAQCAtOTYsNiArOTYsMTAgQEAgdm9pZCB2aXJ0cXVldWVfZGlz
YWJsZV9jYihzdHJ1Y3QgdmlydHF1ZXVlICp2cSk7DQogDQogYm9vbCB2aXJ0cXVldWVfZW5hYmxl
X2NiKHN0cnVjdCB2aXJ0cXVldWUgKnZxKTsNCiANCit1bnNpZ25lZCB2aXJ0cXVldWVfZW5hYmxl
X2NiX3ByZXBhcmUoc3RydWN0IHZpcnRxdWV1ZSAqdnEpOw0KKw0KK2Jvb2wgdmlydHF1ZXVlX3Bv
bGwoc3RydWN0IHZpcnRxdWV1ZSAqdnEsIHVuc2lnbmVkKTsNCisNCiBib29sIHZpcnRxdWV1ZV9l
bmFibGVfY2JfZGVsYXllZChzdHJ1Y3QgdmlydHF1ZXVlICp2cSk7DQogDQogdm9pZCAqdmlydHF1
ZXVlX2RldGFjaF91bnVzZWRfYnVmKHN0cnVjdCB2aXJ0cXVldWUgKnZxKTsNCmRpZmYgLS1naXQg
YS9pbmNsdWRlL25ldC9hZGRyY29uZi5oIGIvaW5jbHVkZS9uZXQvYWRkcmNvbmYuaA0KaW5kZXgg
Y2JjNmJiMC4uNDRiMTExMCAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbmV0L2FkZHJjb25mLmgNCisr
KyBiL2luY2x1ZGUvbmV0L2FkZHJjb25mLmgNCkBAIC04MSw2ICs4MSw5IEBAIGV4dGVybiBpbnQJ
CQlpcHY2X2Rldl9nZXRfc2FkZHIoc3RydWN0IG5ldCAqbmV0LA0KIAkJCQkJICAgICAgIGNvbnN0
IHN0cnVjdCBpbjZfYWRkciAqZGFkZHIsDQogCQkJCQkgICAgICAgdW5zaWduZWQgaW50IHNyY3By
ZWZzLA0KIAkJCQkJICAgICAgIHN0cnVjdCBpbjZfYWRkciAqc2FkZHIpOw0KK2V4dGVybiBpbnQJ
CQlfX2lwdjZfZ2V0X2xsYWRkcihzdHJ1Y3QgaW5ldDZfZGV2ICppZGV2LA0KKwkJCQkJCSAgc3Ry
dWN0IGluNl9hZGRyICphZGRyLA0KKwkJCQkJCSAgdW5zaWduZWQgY2hhciBiYW5uZWRfZmxhZ3Mp
Ow0KIGV4dGVybiBpbnQJCQlpcHY2X2dldF9sbGFkZHIoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwN
CiAJCQkJCQlzdHJ1Y3QgaW42X2FkZHIgKmFkZHIsDQogCQkJCQkJdW5zaWduZWQgY2hhciBiYW5u
ZWRfZmxhZ3MpOw0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L3VkcC5oIGIvaW5jbHVkZS9uZXQv
dWRwLmgNCmluZGV4IDNiMjg1ZjQuLmUxNTgzMzAgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL25ldC91
ZHAuaA0KKysrIGIvaW5jbHVkZS9uZXQvdWRwLmgNCkBAIC0xODAsNiArMTgwLDcgQEAgZXh0ZXJu
IGludCB1ZHBfZ2V0X3BvcnQoc3RydWN0IHNvY2sgKnNrLCB1bnNpZ25lZCBzaG9ydCBzbnVtLA0K
IGV4dGVybiB2b2lkIHVkcF9lcnIoc3RydWN0IHNrX2J1ZmYgKiwgdTMyKTsNCiBleHRlcm4gaW50
IHVkcF9zZW5kbXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IHNvY2sgKnNrLA0KIAkJCSAg
ICBzdHJ1Y3QgbXNnaGRyICptc2csIHNpemVfdCBsZW4pOw0KK2V4dGVybiBpbnQgdWRwX3B1c2hf
cGVuZGluZ19mcmFtZXMoc3RydWN0IHNvY2sgKnNrKTsNCiBleHRlcm4gdm9pZCB1ZHBfZmx1c2hf
cGVuZGluZ19mcmFtZXMoc3RydWN0IHNvY2sgKnNrKTsNCiBleHRlcm4gaW50IHVkcF9yY3Yoc3Ry
dWN0IHNrX2J1ZmYgKnNrYik7DQogZXh0ZXJuIGludCB1ZHBfaW9jdGwoc3RydWN0IHNvY2sgKnNr
LCBpbnQgY21kLCB1bnNpZ25lZCBsb25nIGFyZyk7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4v
aW50ZXJmYWNlL2lvL3JpbmcuaCBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS9pby9yaW5nLmgNCmlu
ZGV4IDc1MjcxYjkuLjdkMjhhZmYgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2Uv
aW8vcmluZy5oDQorKysgYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvaW8vcmluZy5oDQpAQCAtMTg4
LDYgKzE4OCwxMSBAQCBzdHJ1Y3QgX19uYW1lIyNfYmFja19yaW5nIHsJCQkJCQlcDQogI2RlZmlu
ZSBSSU5HX1JFUVVFU1RfQ09OU19PVkVSRkxPVyhfciwgX2NvbnMpCQkJCVwNCiAgICAgKCgoX2Nv
bnMpIC0gKF9yKS0+cnNwX3Byb2RfcHZ0KSA+PSBSSU5HX1NJWkUoX3IpKQ0KIA0KKy8qIElsbC1i
ZWhhdmVkIGZyb250ZW5kIGRldGVybWluYXRpb246IENhbiB0aGVyZSBiZSB0aGlzIG1hbnkgcmVx
dWVzdHM/ICovDQorI2RlZmluZSBSSU5HX1JFUVVFU1RfUFJPRF9PVkVSRkxPVyhfciwgX3Byb2Qp
ICAgICAgICAgICAgICAgXA0KKyAgICAoKChfcHJvZCkgLSAoX3IpLT5yc3BfcHJvZF9wdnQpID4g
UklOR19TSVpFKF9yKSkNCisNCisNCiAjZGVmaW5lIFJJTkdfUFVTSF9SRVFVRVNUUyhfcikgZG8g
ewkJCQkJXA0KICAgICB3bWIoKTsgLyogYmFjayBzZWVzIHJlcXVlc3RzIC9iZWZvcmUvIHVwZGF0
ZWQgcHJvZHVjZXIgaW5kZXggKi8JXA0KICAgICAoX3IpLT5zcmluZy0+cmVxX3Byb2QgPSAoX3Ip
LT5yZXFfcHJvZF9wdnQ7CQkJCVwNCmRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2UvdHJhY2UuYyBi
L2tlcm5lbC90cmFjZS90cmFjZS5jDQppbmRleCAwZWM2YzM0Li5hNTg0YWQ5IDEwMDY0NA0KLS0t
IGEva2VybmVsL3RyYWNlL3RyYWNlLmMNCisrKyBiL2tlcm5lbC90cmFjZS90cmFjZS5jDQpAQCAt
NjMxLDcgKzYzMSwxNSBAQCBfX3VwZGF0ZV9tYXhfdHIoc3RydWN0IHRyYWNlX2FycmF5ICp0ciwg
c3RydWN0IHRhc2tfc3RydWN0ICp0c2ssIGludCBjcHUpDQogDQogCW1lbWNweShtYXhfZGF0YS0+
Y29tbSwgdHNrLT5jb21tLCBUQVNLX0NPTU1fTEVOKTsNCiAJbWF4X2RhdGEtPnBpZCA9IHRzay0+
cGlkOw0KLQltYXhfZGF0YS0+dWlkID0gdGFza191aWQodHNrKTsNCisJLyoNCisJICogSWYgdHNr
ID09IGN1cnJlbnQsIHRoZW4gdXNlIGN1cnJlbnRfdWlkKCksIGFzIHRoYXQgZG9lcyBub3QgdXNl
DQorCSAqIFJDVS4gVGhlIGlycSB0cmFjZXIgY2FuIGJlIGNhbGxlZCBvdXQgb2YgUkNVIHNjb3Bl
Lg0KKwkgKi8NCisJaWYgKHRzayA9PSBjdXJyZW50KQ0KKwkJbWF4X2RhdGEtPnVpZCA9IGN1cnJl
bnRfdWlkKCk7DQorCWVsc2UNCisJCW1heF9kYXRhLT51aWQgPSB0YXNrX3VpZCh0c2spOw0KKw0K
IAltYXhfZGF0YS0+bmljZSA9IHRzay0+c3RhdGljX3ByaW8gLSAyMCAtIE1BWF9SVF9QUklPOw0K
IAltYXhfZGF0YS0+cG9saWN5ID0gdHNrLT5wb2xpY3k7DQogCW1heF9kYXRhLT5ydF9wcmlvcml0
eSA9IHRzay0+cnRfcHJpb3JpdHk7DQpkaWZmIC0tZ2l0IGEvbmV0LzgwMjFxL3ZsYW5fZGV2LmMg
Yi9uZXQvODAyMXEvdmxhbl9kZXYuYw0KaW5kZXggMGNjY2NhOC4uYjQwZDNkYSAxMDA2NDQNCi0t
LSBhL25ldC84MDIxcS92bGFuX2Rldi5jDQorKysgYi9uZXQvODAyMXEvdmxhbl9kZXYuYw0KQEAg
LTcyLDYgKzcyLDggQEAgdmxhbl9kZXZfZ2V0X2VncmVzc19xb3NfbWFzayhzdHJ1Y3QgbmV0X2Rl
dmljZSAqZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KIHsNCiAJc3RydWN0IHZsYW5fcHJpb3Jp
dHlfdGNpX21hcHBpbmcgKm1wOw0KIA0KKwlzbXBfcm1iKCk7IC8qIGNvdXBsZWQgd2l0aCBzbXBf
d21iKCkgaW4gdmxhbl9kZXZfc2V0X2VncmVzc19wcmlvcml0eSgpICovDQorDQogCW1wID0gdmxh
bl9kZXZfaW5mbyhkZXYpLT5lZ3Jlc3NfcHJpb3JpdHlfbWFwWyhza2ItPnByaW9yaXR5ICYgMHhG
KV07DQogCXdoaWxlIChtcCkgew0KIAkJaWYgKG1wLT5wcmlvcml0eSA9PSBza2ItPnByaW9yaXR5
KSB7DQpAQCAtMjMyLDYgKzIzNCwxMSBAQCBpbnQgdmxhbl9kZXZfc2V0X2VncmVzc19wcmlvcml0
eShjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KIAlucC0+bmV4dCA9IG1wOw0KIAlucC0+
cHJpb3JpdHkgPSBza2JfcHJpbzsNCiAJbnAtPnZsYW5fcW9zID0gdmxhbl9xb3M7DQorCS8qIEJl
Zm9yZSBpbnNlcnRpbmcgdGhpcyBlbGVtZW50IGluIGhhc2ggdGFibGUsIG1ha2Ugc3VyZSBhbGwg
aXRzIGZpZWxkcw0KKwkgKiBhcmUgY29tbWl0dGVkIHRvIG1lbW9yeS4NCisJICogY291cGxlZCB3
aXRoIHNtcF9ybWIoKSBpbiB2bGFuX2Rldl9nZXRfZWdyZXNzX3Fvc19tYXNrKCkNCisJICovDQor
CXNtcF93bWIoKTsNCiAJdmxhbi0+ZWdyZXNzX3ByaW9yaXR5X21hcFtza2JfcHJpbyAmIDB4Rl0g
PSBucDsNCiAJaWYgKHZsYW5fcW9zKQ0KIAkJdmxhbi0+bnJfZWdyZXNzX21hcHBpbmdzKys7DQpk
aWZmIC0tZ2l0IGEvbmV0LzlwL3RyYW5zX2NvbW1vbi5jIGIvbmV0LzlwL3RyYW5zX2NvbW1vbi5j
DQppbmRleCBkZThkZjk1Li4yZWUzODc5IDEwMDY0NA0KLS0tIGEvbmV0LzlwL3RyYW5zX2NvbW1v
bi5jDQorKysgYi9uZXQvOXAvdHJhbnNfY29tbW9uLmMNCkBAIC0yNCwxMSArMjQsMTEgQEANCiAg
Ki8NCiB2b2lkIHA5X3JlbGVhc2VfcGFnZXMoc3RydWN0IHBhZ2UgKipwYWdlcywgaW50IG5yX3Bh
Z2VzKQ0KIHsNCi0JaW50IGkgPSAwOw0KLQl3aGlsZSAocGFnZXNbaV0gJiYgbnJfcGFnZXMtLSkg
ew0KLQkJcHV0X3BhZ2UocGFnZXNbaV0pOw0KLQkJaSsrOw0KLQl9DQorCWludCBpOw0KKw0KKwlm
b3IgKGkgPSAwOyBpIDwgbnJfcGFnZXM7IGkrKykNCisJCWlmIChwYWdlc1tpXSkNCisJCQlwdXRf
cGFnZShwYWdlc1tpXSk7DQogfQ0KIEVYUE9SVF9TWU1CT0wocDlfcmVsZWFzZV9wYWdlcyk7DQog
DQpkaWZmIC0tZ2l0IGEvbmV0L2JyaWRnZS9icl9tdWx0aWNhc3QuYyBiL25ldC9icmlkZ2UvYnJf
bXVsdGljYXN0LmMNCmluZGV4IDVhYzE4MTEuLmI4MTUwMGMgMTAwNjQ0DQotLS0gYS9uZXQvYnJp
ZGdlL2JyX211bHRpY2FzdC5jDQorKysgYi9uZXQvYnJpZGdlL2JyX211bHRpY2FzdC5jDQpAQCAt
NDY3LDggKzQ2Nyw5IEBAIHN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqYnJfaXA2X211bHRpY2FzdF9h
bGxvY19xdWVyeShzdHJ1Y3QgbmV0X2JyaWRnZSAqYnIsDQogCXNrYl9zZXRfdHJhbnNwb3J0X2hl
YWRlcihza2IsIHNrYi0+bGVuKTsNCiAJbWxkcSA9IChzdHJ1Y3QgbWxkX21zZyAqKSBpY21wNl9o
ZHIoc2tiKTsNCiANCi0JaW50ZXJ2YWwgPSBpcHY2X2FkZHJfYW55KGdyb3VwKSA/IGJyLT5tdWx0
aWNhc3RfbGFzdF9tZW1iZXJfaW50ZXJ2YWwgOg0KLQkJCQkJICBici0+bXVsdGljYXN0X3F1ZXJ5
X3Jlc3BvbnNlX2ludGVydmFsOw0KKwlpbnRlcnZhbCA9IGlwdjZfYWRkcl9hbnkoZ3JvdXApID8N
CisJCQlici0+bXVsdGljYXN0X3F1ZXJ5X3Jlc3BvbnNlX2ludGVydmFsIDoNCisJCQlici0+bXVs
dGljYXN0X2xhc3RfbWVtYmVyX2ludGVydmFsOw0KIA0KIAltbGRxLT5tbGRfdHlwZSA9IElDTVBW
Nl9NR01fUVVFUlk7DQogCW1sZHEtPm1sZF9jb2RlID0gMDsNCmRpZmYgLS1naXQgYS9uZXQvY29y
ZS9uZWlnaGJvdXIuYyBiL25ldC9jb3JlL25laWdoYm91ci5jDQppbmRleCA1Yjk3MDlmLi4wZWEz
ZmQzIDEwMDY0NA0KLS0tIGEvbmV0L2NvcmUvbmVpZ2hib3VyLmMNCisrKyBiL25ldC9jb3JlL25l
aWdoYm91ci5jDQpAQCAtMjM3LDcgKzIzNyw3IEBAIHN0YXRpYyB2b2lkIG5laWdoX2ZsdXNoX2Rl
dihzdHJ1Y3QgbmVpZ2hfdGFibGUgKnRibCwgc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCiAJCQkJ
ICAgd2UgbXVzdCBraWxsIHRpbWVycyBldGMuIGFuZCBtb3ZlDQogCQkJCSAgIGl0IHRvIHNhZmUg
c3RhdGUuDQogCQkJCSAqLw0KLQkJCQlza2JfcXVldWVfcHVyZ2UoJm4tPmFycF9xdWV1ZSk7DQor
CQkJCV9fc2tiX3F1ZXVlX3B1cmdlKCZuLT5hcnBfcXVldWUpOw0KIAkJCQluLT5vdXRwdXQgPSBu
ZWlnaF9ibGFja2hvbGU7DQogCQkJCWlmIChuLT5udWRfc3RhdGUgJiBOVURfVkFMSUQpDQogCQkJ
CQluLT5udWRfc3RhdGUgPSBOVURfTk9BUlA7DQpAQCAtMjkxLDcgKzI5MSw3IEBAIHN0YXRpYyBz
dHJ1Y3QgbmVpZ2hib3VyICpuZWlnaF9hbGxvYyhzdHJ1Y3QgbmVpZ2hfdGFibGUgKnRibCkNCiAJ
aWYgKCFuKQ0KIAkJZ290byBvdXRfZW50cmllczsNCiANCi0Jc2tiX3F1ZXVlX2hlYWRfaW5pdCgm
bi0+YXJwX3F1ZXVlKTsNCisJX19za2JfcXVldWVfaGVhZF9pbml0KCZuLT5hcnBfcXVldWUpOw0K
IAlyd2xvY2tfaW5pdCgmbi0+bG9jayk7DQogCXNlcWxvY2tfaW5pdCgmbi0+aGFfbG9jayk7DQog
CW4tPnVwZGF0ZWQJICA9IG4tPnVzZWQgPSBub3c7DQpAQCAtNzAxLDcgKzcwMSw5IEBAIHZvaWQg
bmVpZ2hfZGVzdHJveShzdHJ1Y3QgbmVpZ2hib3VyICpuZWlnaCkNCiAJaWYgKG5laWdoX2RlbF90
aW1lcihuZWlnaCkpDQogCQlwcmludGsoS0VSTl9XQVJOSU5HICJJbXBvc3NpYmxlIGV2ZW50Llxu
Iik7DQogDQotCXNrYl9xdWV1ZV9wdXJnZSgmbmVpZ2gtPmFycF9xdWV1ZSk7DQorCXdyaXRlX2xv
Y2tfYmgoJm5laWdoLT5sb2NrKTsNCisJX19za2JfcXVldWVfcHVyZ2UoJm5laWdoLT5hcnBfcXVl
dWUpOw0KKwl3cml0ZV91bmxvY2tfYmgoJm5laWdoLT5sb2NrKTsNCiANCiAJZGV2X3B1dChuZWln
aC0+ZGV2KTsNCiAJbmVpZ2hfcGFybXNfcHV0KG5laWdoLT5wYXJtcyk7DQpAQCAtODQzLDcgKzg0
NSw3IEBAIHN0YXRpYyB2b2lkIG5laWdoX2ludmFsaWRhdGUoc3RydWN0IG5laWdoYm91ciAqbmVp
Z2gpDQogCQluZWlnaC0+b3BzLT5lcnJvcl9yZXBvcnQobmVpZ2gsIHNrYik7DQogCQl3cml0ZV9s
b2NrKCZuZWlnaC0+bG9jayk7DQogCX0NCi0Jc2tiX3F1ZXVlX3B1cmdlKCZuZWlnaC0+YXJwX3F1
ZXVlKTsNCisJX19za2JfcXVldWVfcHVyZ2UoJm5laWdoLT5hcnBfcXVldWUpOw0KIH0NCiANCiBz
dGF0aWMgdm9pZCBuZWlnaF9wcm9iZShzdHJ1Y3QgbmVpZ2hib3VyICpuZWlnaCkNCkBAIC0xMTc2
LDcgKzExNzgsNyBAQCBpbnQgbmVpZ2hfdXBkYXRlKHN0cnVjdCBuZWlnaGJvdXIgKm5laWdoLCBj
b25zdCB1OCAqbGxhZGRyLCB1OCBuZXcsDQogDQogCQkJd3JpdGVfbG9ja19iaCgmbmVpZ2gtPmxv
Y2spOw0KIAkJfQ0KLQkJc2tiX3F1ZXVlX3B1cmdlKCZuZWlnaC0+YXJwX3F1ZXVlKTsNCisJCV9f
c2tiX3F1ZXVlX3B1cmdlKCZuZWlnaC0+YXJwX3F1ZXVlKTsNCiAJfQ0KIG91dDoNCiAJaWYgKHVw
ZGF0ZV9pc3JvdXRlcikgew0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L3VkcC5jIGIvbmV0L2lwdjQv
dWRwLmMNCmluZGV4IDVhNjVlZWEuLjVkZWNjOTMgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC91ZHAu
Yw0KKysrIGIvbmV0L2lwdjQvdWRwLmMNCkBAIC03NjYsNyArNzY2LDcgQEAgc2VuZDoNCiAvKg0K
ICAqIFB1c2ggb3V0IGFsbCBwZW5kaW5nIGRhdGEgYXMgb25lIFVEUCBkYXRhZ3JhbS4gU29ja2V0
IGlzIGxvY2tlZC4NCiAgKi8NCi1zdGF0aWMgaW50IHVkcF9wdXNoX3BlbmRpbmdfZnJhbWVzKHN0
cnVjdCBzb2NrICpzaykNCitpbnQgdWRwX3B1c2hfcGVuZGluZ19mcmFtZXMoc3RydWN0IHNvY2sg
KnNrKQ0KIHsNCiAJc3RydWN0IHVkcF9zb2NrICAqdXAgPSB1ZHBfc2soc2spOw0KIAlzdHJ1Y3Qg
aW5ldF9zb2NrICppbmV0ID0gaW5ldF9zayhzayk7DQpAQCAtNzg1LDYgKzc4NSw3IEBAIG91dDoN
CiAJdXAtPnBlbmRpbmcgPSAwOw0KIAlyZXR1cm4gZXJyOw0KIH0NCitFWFBPUlRfU1lNQk9MKHVk
cF9wdXNoX3BlbmRpbmdfZnJhbWVzKTsNCiANCiBpbnQgdWRwX3NlbmRtc2coc3RydWN0IGtpb2Ni
ICppb2NiLCBzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBtc2doZHIgKm1zZywNCiAJCXNpemVfdCBs
ZW4pDQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvYWRkcmNvbmYuYyBiL25ldC9pcHY2L2FkZHJjb25m
LmMNCmluZGV4IGQ2MDNjYWEuLjMxNGJkYTIgMTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni9hZGRyY29u
Zi5jDQorKysgYi9uZXQvaXB2Ni9hZGRyY29uZi5jDQpAQCAtMTIzNiw2ICsxMjM2LDIzIEBAIHRy
eV9uZXh0ZGV2Og0KIH0NCiBFWFBPUlRfU1lNQk9MKGlwdjZfZGV2X2dldF9zYWRkcik7DQogDQor
aW50IF9faXB2Nl9nZXRfbGxhZGRyKHN0cnVjdCBpbmV0Nl9kZXYgKmlkZXYsIHN0cnVjdCBpbjZf
YWRkciAqYWRkciwNCisJCSAgICAgIHVuc2lnbmVkIGNoYXIgYmFubmVkX2ZsYWdzKQ0KK3sNCisJ
c3RydWN0IGluZXQ2X2lmYWRkciAqaWZwOw0KKwlpbnQgZXJyID0gLUVBRERSTk9UQVZBSUw7DQor
DQorCWxpc3RfZm9yX2VhY2hfZW50cnkoaWZwLCAmaWRldi0+YWRkcl9saXN0LCBpZl9saXN0KSB7
DQorCQlpZiAoaWZwLT5zY29wZSA9PSBJRkFfTElOSyAmJg0KKwkJICAgICEoaWZwLT5mbGFncyAm
IGJhbm5lZF9mbGFncykpIHsNCisJCQlpcHY2X2FkZHJfY29weShhZGRyLCAmaWZwLT5hZGRyKTsN
CisJCQllcnIgPSAwOw0KKwkJCWJyZWFrOw0KKwkJfQ0KKwl9DQorCXJldHVybiBlcnI7DQorfQ0K
Kw0KIGludCBpcHY2X2dldF9sbGFkZHIoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IGlu
Nl9hZGRyICphZGRyLA0KIAkJICAgIHVuc2lnbmVkIGNoYXIgYmFubmVkX2ZsYWdzKQ0KIHsNCkBA
IC0xMjQ1LDE3ICsxMjYyLDggQEAgaW50IGlwdjZfZ2V0X2xsYWRkcihzdHJ1Y3QgbmV0X2Rldmlj
ZSAqZGV2LCBzdHJ1Y3QgaW42X2FkZHIgKmFkZHIsDQogCXJjdV9yZWFkX2xvY2soKTsNCiAJaWRl
diA9IF9faW42X2Rldl9nZXQoZGV2KTsNCiAJaWYgKGlkZXYpIHsNCi0JCXN0cnVjdCBpbmV0Nl9p
ZmFkZHIgKmlmcDsNCi0NCiAJCXJlYWRfbG9ja19iaCgmaWRldi0+bG9jayk7DQotCQlsaXN0X2Zv
cl9lYWNoX2VudHJ5KGlmcCwgJmlkZXYtPmFkZHJfbGlzdCwgaWZfbGlzdCkgew0KLQkJCWlmIChp
ZnAtPnNjb3BlID09IElGQV9MSU5LICYmDQotCQkJICAgICEoaWZwLT5mbGFncyAmIGJhbm5lZF9m
bGFncykpIHsNCi0JCQkJaXB2Nl9hZGRyX2NvcHkoYWRkciwgJmlmcC0+YWRkcik7DQotCQkJCWVy
ciA9IDA7DQotCQkJCWJyZWFrOw0KLQkJCX0NCi0JCX0NCisJCWVyciA9IF9faXB2Nl9nZXRfbGxh
ZGRyKGlkZXYsIGFkZHIsIGJhbm5lZF9mbGFncyk7DQogCQlyZWFkX3VubG9ja19iaCgmaWRldi0+
bG9jayk7DQogCX0NCiAJcmN1X3JlYWRfdW5sb2NrKCk7DQpAQCAtMjQzNCw2ICsyNDQyLDkgQEAg
c3RhdGljIHZvaWQgaW5pdF9sb29wYmFjayhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KIAkJCWlm
IChzcF9pZmEtPmZsYWdzICYgKElGQV9GX0RBREZBSUxFRCB8IElGQV9GX1RFTlRBVElWRSkpDQog
CQkJCWNvbnRpbnVlOw0KIA0KKwkJCWlmIChzcF9pZmEtPnJ0KQ0KKwkJCQljb250aW51ZTsNCisN
CiAJCQlzcF9ydCA9IGFkZHJjb25mX2RzdF9hbGxvYyhpZGV2LCAmc3BfaWZhLT5hZGRyLCAwKTsN
CiANCiAJCQkvKiBGYWlsdXJlIGNhc2VzIGFyZSBpZ25vcmVkICovDQpkaWZmIC0tZ2l0IGEvbmV0
L2lwdjYvaXA2X291dHB1dC5jIGIvbmV0L2lwdjYvaXA2X291dHB1dC5jDQppbmRleCA2YWFkYWE4
Li5kYjYwMDQzIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjYvaXA2X291dHB1dC5jDQorKysgYi9uZXQv
aXB2Ni9pcDZfb3V0cHV0LmMNCkBAIC05MDksMTEgKzkwOSwxNyBAQCBzdGF0aWMgc3RydWN0IGRz
dF9lbnRyeSAqaXA2X3NrX2RzdF9jaGVjayhzdHJ1Y3Qgc29jayAqc2ssDQogCQkJCQkgIGNvbnN0
IHN0cnVjdCBmbG93aTYgKmZsNikNCiB7DQogCXN0cnVjdCBpcHY2X3BpbmZvICpucCA9IGluZXQ2
X3NrKHNrKTsNCi0Jc3RydWN0IHJ0Nl9pbmZvICpydCA9IChzdHJ1Y3QgcnQ2X2luZm8gKilkc3Q7
DQorCXN0cnVjdCBydDZfaW5mbyAqcnQ7DQogDQogCWlmICghZHN0KQ0KIAkJZ290byBvdXQ7DQog
DQorCWlmIChkc3QtPm9wcy0+ZmFtaWx5ICE9IEFGX0lORVQ2KSB7DQorCQlkc3RfcmVsZWFzZShk
c3QpOw0KKwkJcmV0dXJuIE5VTEw7DQorCX0NCisNCisJcnQgPSAoc3RydWN0IHJ0Nl9pbmZvICop
ZHN0Ow0KIAkvKiBZZXMsIGNoZWNraW5nIHJvdXRlIHZhbGlkaXR5IGluIG5vdCBjb25uZWN0ZWQN
CiAJICogY2FzZSBpcyBub3QgdmVyeSBzaW1wbGUuIFRha2UgaW50byBhY2NvdW50LA0KIAkgKiB0
aGF0IHdlIGRvIG5vdCBzdXBwb3J0IHJvdXRpbmcgYnkgc291cmNlLCBUT1MsDQpAQCAtMTE3OCwx
MSArMTE4NCwxMiBAQCBzdGF0aWMgaW5saW5lIHN0cnVjdCBpcHY2X3J0X2hkciAqaXA2X3J0aGRy
X2R1cChzdHJ1Y3QgaXB2Nl9ydF9oZHIgKnNyYywNCiAJcmV0dXJuIHNyYyA/IGttZW1kdXAoc3Jj
LCAoc3JjLT5oZHJsZW4gKyAxKSAqIDgsIGdmcCkgOiBOVUxMOw0KIH0NCiANCi1zdGF0aWMgdm9p
ZCBpcDZfYXBwZW5kX2RhdGFfbXR1KGludCAqbXR1LA0KK3N0YXRpYyB2b2lkIGlwNl9hcHBlbmRf
ZGF0YV9tdHUodW5zaWduZWQgaW50ICptdHUsDQogCQkJCWludCAqbWF4ZnJhZ2xlbiwNCiAJCQkJ
dW5zaWduZWQgaW50IGZyYWdoZWFkZXJsZW4sDQogCQkJCXN0cnVjdCBza19idWZmICpza2IsDQot
CQkJCXN0cnVjdCBydDZfaW5mbyAqcnQpDQorCQkJCXN0cnVjdCBydDZfaW5mbyAqcnQsDQorCQkJ
CWJvb2wgcG10dXByb2JlKQ0KIHsNCiAJaWYgKCEocnQtPmRzdC5mbGFncyAmIERTVF9YRlJNX1RV
Tk5FTCkpIHsNCiAJCWlmIChza2IgPT0gTlVMTCkgew0KQEAgLTExOTQsNyArMTIwMSw5IEBAIHN0
YXRpYyB2b2lkIGlwNl9hcHBlbmRfZGF0YV9tdHUoaW50ICptdHUsDQogCQkJICogdGhpcyBmcmFn
bWVudCBpcyBub3QgZmlyc3QsIHRoZSBoZWFkZXJzDQogCQkJICogc3BhY2UgaXMgcmVnYXJkZWQg
YXMgZGF0YSBzcGFjZS4NCiAJCQkgKi8NCi0JCQkqbXR1ID0gZHN0X210dShydC0+ZHN0LnBhdGgp
Ow0KKwkJCSptdHUgPSBtaW4oKm10dSwgcG10dXByb2JlID8NCisJCQkJICAgcnQtPmRzdC5kZXYt
Pm10dSA6DQorCQkJCSAgIGRzdF9tdHUocnQtPmRzdC5wYXRoKSk7DQogCQl9DQogCQkqbWF4ZnJh
Z2xlbiA9ICgoKm10dSAtIGZyYWdoZWFkZXJsZW4pICYgfjcpDQogCQkJICAgICAgKyBmcmFnaGVh
ZGVybGVuIC0gc2l6ZW9mKHN0cnVjdCBmcmFnX2hkcik7DQpAQCAtMTIxMSwxMSArMTIyMCwxMCBA
QCBpbnQgaXA2X2FwcGVuZF9kYXRhKHN0cnVjdCBzb2NrICpzaywgaW50IGdldGZyYWcodm9pZCAq
ZnJvbSwgY2hhciAqdG8sDQogCXN0cnVjdCBpcHY2X3BpbmZvICpucCA9IGluZXQ2X3NrKHNrKTsN
CiAJc3RydWN0IGluZXRfY29yayAqY29yazsNCiAJc3RydWN0IHNrX2J1ZmYgKnNrYiwgKnNrYl9w
cmV2ID0gTlVMTDsNCi0JdW5zaWduZWQgaW50IG1heGZyYWdsZW4sIGZyYWdoZWFkZXJsZW47DQor
CXVuc2lnbmVkIGludCBtYXhmcmFnbGVuLCBmcmFnaGVhZGVybGVuLCBtdHU7DQogCWludCBleHRo
ZHJsZW47DQogCWludCBkc3RfZXh0aGRybGVuOw0KIAlpbnQgaGhfbGVuOw0KLQlpbnQgbXR1Ow0K
IAlpbnQgY29weTsNCiAJaW50IGVycjsNCiAJaW50IG9mZnNldCA9IDA7DQpAQCAtMTM3OCw3ICsx
Mzg2LDkgQEAgYWxsb2NfbmV3X3NrYjoNCiAJCQkvKiB1cGRhdGUgbXR1IGFuZCBtYXhmcmFnbGVu
IGlmIG5lY2Vzc2FyeSAqLw0KIAkJCWlmIChza2IgPT0gTlVMTCB8fCBza2JfcHJldiA9PSBOVUxM
KQ0KIAkJCQlpcDZfYXBwZW5kX2RhdGFfbXR1KCZtdHUsICZtYXhmcmFnbGVuLA0KLQkJCQkJCSAg
ICBmcmFnaGVhZGVybGVuLCBza2IsIHJ0KTsNCisJCQkJCQkgICAgZnJhZ2hlYWRlcmxlbiwgc2ti
LCBydCwNCisJCQkJCQkgICAgbnAtPnBtdHVkaXNjID09DQorCQkJCQkJICAgIElQVjZfUE1UVURJ
U0NfUFJPQkUpOw0KIA0KIAkJCXNrYl9wcmV2ID0gc2tiOw0KIA0KZGlmZiAtLWdpdCBhL25ldC9p
cHY2L21jYXN0LmMgYi9uZXQvaXB2Ni9tY2FzdC5jDQppbmRleCBmMmQ3NGVhLi5jN2VjNGJiIDEw
MDY0NA0KLS0tIGEvbmV0L2lwdjYvbWNhc3QuYw0KKysrIGIvbmV0L2lwdjYvbWNhc3QuYw0KQEAg
LTEzMzQsOCArMTMzNCw5IEBAIG1sZF9zY291bnQoc3RydWN0IGlmbWNhZGRyNiAqcG1jLCBpbnQg
dHlwZSwgaW50IGdkZWxldGVkLCBpbnQgc2RlbGV0ZWQpDQogCXJldHVybiBzY291bnQ7DQogfQ0K
IA0KLXN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqbWxkX25ld3BhY2soc3RydWN0IG5ldF9kZXZpY2Ug
KmRldiwgaW50IHNpemUpDQorc3RhdGljIHN0cnVjdCBza19idWZmICptbGRfbmV3cGFjayhzdHJ1
Y3QgaW5ldDZfZGV2ICppZGV2LCBpbnQgc2l6ZSkNCiB7DQorCXN0cnVjdCBuZXRfZGV2aWNlICpk
ZXYgPSBpZGV2LT5kZXY7DQogCXN0cnVjdCBuZXQgKm5ldCA9IGRldl9uZXQoZGV2KTsNCiAJc3Ry
dWN0IHNvY2sgKnNrID0gbmV0LT5pcHY2LmlnbXBfc2s7DQogCXN0cnVjdCBza19idWZmICpza2I7
DQpAQCAtMTM1OCw3ICsxMzU5LDcgQEAgc3RhdGljIHN0cnVjdCBza19idWZmICptbGRfbmV3cGFj
ayhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBpbnQgc2l6ZSkNCiANCiAJc2tiX3Jlc2VydmUoc2ti
LCBMTF9SRVNFUlZFRF9TUEFDRShkZXYpKTsNCiANCi0JaWYgKGlwdjZfZ2V0X2xsYWRkcihkZXYs
ICZhZGRyX2J1ZiwgSUZBX0ZfVEVOVEFUSVZFKSkgew0KKwlpZiAoX19pcHY2X2dldF9sbGFkZHIo
aWRldiwgJmFkZHJfYnVmLCBJRkFfRl9URU5UQVRJVkUpKSB7DQogCQkvKiA8ZHJhZnQtaWV0Zi1t
YWdtYS1tbGQtc291cmNlLTA1LnR4dD46DQogCQkgKiB1c2UgdW5zcGVjaWZpZWQgYWRkcmVzcyBh
cyB0aGUgc291cmNlIGFkZHJlc3MNCiAJCSAqIHdoZW4gYSB2YWxpZCBsaW5rLWxvY2FsIGFkZHJl
c3MgaXMgbm90IGF2YWlsYWJsZS4NCkBAIC0xNDYxLDcgKzE0NjIsNyBAQCBzdGF0aWMgc3RydWN0
IHNrX2J1ZmYgKmFkZF9ncmhlYWQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGlmbWNhZGRy
NiAqcG1jLA0KIAlzdHJ1Y3QgbWxkMl9ncmVjICpwZ3I7DQogDQogCWlmICghc2tiKQ0KLQkJc2ti
ID0gbWxkX25ld3BhY2soZGV2LCBkZXYtPm10dSk7DQorCQlza2IgPSBtbGRfbmV3cGFjayhwbWMt
PmlkZXYsIGRldi0+bXR1KTsNCiAJaWYgKCFza2IpDQogCQlyZXR1cm4gTlVMTDsNCiAJcGdyID0g
KHN0cnVjdCBtbGQyX2dyZWMgKilza2JfcHV0KHNrYiwgc2l6ZW9mKHN0cnVjdCBtbGQyX2dyZWMp
KTsNCkBAIC0xNDgxLDcgKzE0ODIsOCBAQCBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKmFkZF9ncmhl
YWQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGlmbWNhZGRyNiAqcG1jLA0KIHN0YXRpYyBz
dHJ1Y3Qgc2tfYnVmZiAqYWRkX2dyZWMoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGlmbWNh
ZGRyNiAqcG1jLA0KIAlpbnQgdHlwZSwgaW50IGdkZWxldGVkLCBpbnQgc2RlbGV0ZWQpDQogew0K
LQlzdHJ1Y3QgbmV0X2RldmljZSAqZGV2ID0gcG1jLT5pZGV2LT5kZXY7DQorCXN0cnVjdCBpbmV0
Nl9kZXYgKmlkZXYgPSBwbWMtPmlkZXY7DQorCXN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBpZGV2
LT5kZXY7DQogCXN0cnVjdCBtbGQyX3JlcG9ydCAqcG1yOw0KIAlzdHJ1Y3QgbWxkMl9ncmVjICpw
Z3IgPSBOVUxMOw0KIAlzdHJ1Y3QgaXA2X3NmX2xpc3QgKnBzZiwgKnBzZl9uZXh0LCAqcHNmX3By
ZXYsICoqcHNmX2xpc3Q7DQpAQCAtMTUxMCw3ICsxNTEyLDcgQEAgc3RhdGljIHN0cnVjdCBza19i
dWZmICphZGRfZ3JlYyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgaWZtY2FkZHI2ICpwbWMs
DQogCQkgICAgQVZBSUxBQkxFKHNrYikgPCBncmVjX3NpemUocG1jLCB0eXBlLCBnZGVsZXRlZCwg
c2RlbGV0ZWQpKSB7DQogCQkJaWYgKHNrYikNCiAJCQkJbWxkX3NlbmRwYWNrKHNrYik7DQotCQkJ
c2tiID0gbWxkX25ld3BhY2soZGV2LCBkZXYtPm10dSk7DQorCQkJc2tiID0gbWxkX25ld3BhY2so
aWRldiwgZGV2LT5tdHUpOw0KIAkJfQ0KIAl9DQogCWZpcnN0ID0gMTsNCkBAIC0xNTM3LDcgKzE1
MzksNyBAQCBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKmFkZF9ncmVjKHN0cnVjdCBza19idWZmICpz
a2IsIHN0cnVjdCBpZm1jYWRkcjYgKnBtYywNCiAJCQkJcGdyLT5ncmVjX25zcmNzID0gaHRvbnMo
c2NvdW50KTsNCiAJCQlpZiAoc2tiKQ0KIAkJCQltbGRfc2VuZHBhY2soc2tiKTsNCi0JCQlza2Ig
PSBtbGRfbmV3cGFjayhkZXYsIGRldi0+bXR1KTsNCisJCQlza2IgPSBtbGRfbmV3cGFjayhpZGV2
LCBkZXYtPm10dSk7DQogCQkJZmlyc3QgPSAxOw0KIAkJCXNjb3VudCA9IDA7DQogCQl9DQpAQCAt
MTU5Miw4ICsxNTk0LDggQEAgc3RhdGljIHZvaWQgbWxkX3NlbmRfcmVwb3J0KHN0cnVjdCBpbmV0
Nl9kZXYgKmlkZXYsIHN0cnVjdCBpZm1jYWRkcjYgKnBtYykNCiAJc3RydWN0IHNrX2J1ZmYgKnNr
YiA9IE5VTEw7DQogCWludCB0eXBlOw0KIA0KKwlyZWFkX2xvY2tfYmgoJmlkZXYtPmxvY2spOw0K
IAlpZiAoIXBtYykgew0KLQkJcmVhZF9sb2NrX2JoKCZpZGV2LT5sb2NrKTsNCiAJCWZvciAocG1j
PWlkZXYtPm1jX2xpc3Q7IHBtYzsgcG1jPXBtYy0+bmV4dCkgew0KIAkJCWlmIChwbWMtPm1jYV9m
bGFncyAmIE1BRl9OT1JFUE9SVCkNCiAJCQkJY29udGludWU7DQpAQCAtMTYwNSw3ICsxNjA3LDYg
QEAgc3RhdGljIHZvaWQgbWxkX3NlbmRfcmVwb3J0KHN0cnVjdCBpbmV0Nl9kZXYgKmlkZXYsIHN0
cnVjdCBpZm1jYWRkcjYgKnBtYykNCiAJCQlza2IgPSBhZGRfZ3JlYyhza2IsIHBtYywgdHlwZSwg
MCwgMCk7DQogCQkJc3Bpbl91bmxvY2tfYmgoJnBtYy0+bWNhX2xvY2spOw0KIAkJfQ0KLQkJcmVh
ZF91bmxvY2tfYmgoJmlkZXYtPmxvY2spOw0KIAl9IGVsc2Ugew0KIAkJc3Bpbl9sb2NrX2JoKCZw
bWMtPm1jYV9sb2NrKTsNCiAJCWlmIChwbWMtPm1jYV9zZmNvdW50W01DQVNUX0VYQ0xVREVdKQ0K
QEAgLTE2MTUsNiArMTYxNiw3IEBAIHN0YXRpYyB2b2lkIG1sZF9zZW5kX3JlcG9ydChzdHJ1Y3Qg
aW5ldDZfZGV2ICppZGV2LCBzdHJ1Y3QgaWZtY2FkZHI2ICpwbWMpDQogCQlza2IgPSBhZGRfZ3Jl
Yyhza2IsIHBtYywgdHlwZSwgMCwgMCk7DQogCQlzcGluX3VubG9ja19iaCgmcG1jLT5tY2FfbG9j
ayk7DQogCX0NCisJcmVhZF91bmxvY2tfYmgoJmlkZXYtPmxvY2spOw0KIAlpZiAoc2tiKQ0KIAkJ
bWxkX3NlbmRwYWNrKHNrYik7DQogfQ0KZGlmZiAtLWdpdCBhL25ldC9pcHY2L3VkcC5jIGIvbmV0
L2lwdjYvdWRwLmMNCmluZGV4IDIwZjA4MTIuLmY5ZTQ5NmIgMTAwNjQ0DQotLS0gYS9uZXQvaXB2
Ni91ZHAuYw0KKysrIGIvbmV0L2lwdjYvdWRwLmMNCkBAIC04OTMsMTEgKzg5MywxNiBAQCBzdGF0
aWMgaW50IHVkcF92Nl9wdXNoX3BlbmRpbmdfZnJhbWVzKHN0cnVjdCBzb2NrICpzaykNCiAJc3Ry
dWN0IHVkcGhkciAqdWg7DQogCXN0cnVjdCB1ZHBfc29jayAgKnVwID0gdWRwX3NrKHNrKTsNCiAJ
c3RydWN0IGluZXRfc29jayAqaW5ldCA9IGluZXRfc2soc2spOw0KLQlzdHJ1Y3QgZmxvd2k2ICpm
bDYgPSAmaW5ldC0+Y29yay5mbC51LmlwNjsNCisJc3RydWN0IGZsb3dpNiAqZmw2Ow0KIAlpbnQg
ZXJyID0gMDsNCiAJaW50IGlzX3VkcGxpdGUgPSBJU19VRFBMSVRFKHNrKTsNCiAJX193c3VtIGNz
dW0gPSAwOw0KIA0KKwlpZiAodXAtPnBlbmRpbmcgPT0gQUZfSU5FVCkNCisJCXJldHVybiB1ZHBf
cHVzaF9wZW5kaW5nX2ZyYW1lcyhzayk7DQorDQorCWZsNiA9ICZpbmV0LT5jb3JrLmZsLnUuaXA2
Ow0KKw0KIAkvKiBHcmFiIHRoZSBza2J1ZmYgd2hlcmUgVURQIGhlYWRlciBzcGFjZSBleGlzdHMu
ICovDQogCWlmICgoc2tiID0gc2tiX3BlZWsoJnNrLT5za193cml0ZV9xdWV1ZSkpID09IE5VTEwp
DQogCQlnb3RvIG91dDsNCmRpZmYgLS1naXQgYS9uZXQva2V5L2FmX2tleS5jIGIvbmV0L2tleS9h
Zl9rZXkuYw0KaW5kZXggMWU3MzNlOS4uNmZlZmRmYyAxMDA2NDQNCi0tLSBhL25ldC9rZXkvYWZf
a2V5LmMNCisrKyBiL25ldC9rZXkvYWZfa2V5LmMNCkBAIC0xNzA1LDYgKzE3MDUsNyBAQCBzdGF0
aWMgaW50IGtleV9ub3RpZnlfc2FfZmx1c2goY29uc3Qgc3RydWN0IGttX2V2ZW50ICpjKQ0KIAlo
ZHItPnNhZGJfbXNnX3ZlcnNpb24gPSBQRl9LRVlfVjI7DQogCWhkci0+c2FkYl9tc2dfZXJybm8g
PSAodWludDhfdCkgMDsNCiAJaGRyLT5zYWRiX21zZ19sZW4gPSAoc2l6ZW9mKHN0cnVjdCBzYWRi
X21zZykgLyBzaXplb2YodWludDY0X3QpKTsNCisJaGRyLT5zYWRiX21zZ19yZXNlcnZlZCA9IDA7
DQogDQogCXBma2V5X2Jyb2FkY2FzdChza2IsIEdGUF9BVE9NSUMsIEJST0FEQ0FTVF9BTEwsIE5V
TEwsIGMtPm5ldCk7DQogDQpAQCAtMjY4Niw2ICsyNjg3LDcgQEAgc3RhdGljIGludCBrZXlfbm90
aWZ5X3BvbGljeV9mbHVzaChjb25zdCBzdHJ1Y3Qga21fZXZlbnQgKmMpDQogCWhkci0+c2FkYl9t
c2dfdmVyc2lvbiA9IFBGX0tFWV9WMjsNCiAJaGRyLT5zYWRiX21zZ19lcnJubyA9ICh1aW50OF90
KSAwOw0KIAloZHItPnNhZGJfbXNnX2xlbiA9IChzaXplb2Yoc3RydWN0IHNhZGJfbXNnKSAvIHNp
emVvZih1aW50NjRfdCkpOw0KKwloZHItPnNhZGJfbXNnX3Jlc2VydmVkID0gMDsNCiAJcGZrZXlf
YnJvYWRjYXN0KHNrYl9vdXQsIEdGUF9BVE9NSUMsIEJST0FEQ0FTVF9BTEwsIE5VTEwsIGMtPm5l
dCk7DQogCXJldHVybiAwOw0KIA0KZGlmZiAtLWdpdCBhL25ldC9sMnRwL2wydHBfcHBwLmMgYi9u
ZXQvbDJ0cC9sMnRwX3BwcC5jDQppbmRleCA3NDQxMGU2Li5lNTc5MDA2IDEwMDY0NA0KLS0tIGEv
bmV0L2wydHAvbDJ0cF9wcHAuYw0KKysrIGIvbmV0L2wydHAvbDJ0cF9wcHAuYw0KQEAgLTE3Nzgs
NyArMTc3OCw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcHJvdG9fb3BzIHBwcG9sMnRwX29wcyA9
IHsNCiANCiBzdGF0aWMgY29uc3Qgc3RydWN0IHBwcG94X3Byb3RvIHBwcG9sMnRwX3Byb3RvID0g
ew0KIAkuY3JlYXRlCQk9IHBwcG9sMnRwX2NyZWF0ZSwNCi0JLmlvY3RsCQk9IHBwcG9sMnRwX2lv
Y3RsDQorCS5pb2N0bAkJPSBwcHBvbDJ0cF9pb2N0bCwNCisJLm93bmVyCQk9IFRISVNfTU9EVUxF
LA0KIH07DQogDQogI2lmZGVmIENPTkZJR19MMlRQX1YzDQpkaWZmIC0tZ2l0IGEvbmV0L3gyNS9h
Zl94MjUuYyBiL25ldC94MjUvYWZfeDI1LmMNCmluZGV4IDNlMTZjNmEuLmRjMjRiYTkgMTAwNjQ0
DQotLS0gYS9uZXQveDI1L2FmX3gyNS5jDQorKysgYi9uZXQveDI1L2FmX3gyNS5jDQpAQCAtMTU4
NiwxMSArMTU4NiwxMSBAQCBvdXRfY3VkX3JlbGVhc2U6DQogCWNhc2UgU0lPQ1gyNUNBTExBQ0NQ
VEFQUFJWOiB7DQogCQlyYyA9IC1FSU5WQUw7DQogCQlsb2NrX3NvY2soc2spOw0KLQkJaWYgKHNr
LT5za19zdGF0ZSAhPSBUQ1BfQ0xPU0UpDQotCQkJYnJlYWs7DQotCQljbGVhcl9iaXQoWDI1X0FD
Q1BUX0FQUFJWX0ZMQUcsICZ4MjUtPmZsYWdzKTsNCisJCWlmIChzay0+c2tfc3RhdGUgPT0gVENQ
X0NMT1NFKSB7DQorCQkJY2xlYXJfYml0KFgyNV9BQ0NQVF9BUFBSVl9GTEFHLCAmeDI1LT5mbGFn
cyk7DQorCQkJcmMgPSAwOw0KKwkJfQ0KIAkJcmVsZWFzZV9zb2NrKHNrKTsNCi0JCXJjID0gMDsN
CiAJCWJyZWFrOw0KIAl9DQogDQpAQCAtMTU5OCwxNCArMTU5OCwxNSBAQCBvdXRfY3VkX3JlbGVh
c2U6DQogCQlyYyA9IC1FSU5WQUw7DQogCQlsb2NrX3NvY2soc2spOw0KIAkJaWYgKHNrLT5za19z
dGF0ZSAhPSBUQ1BfRVNUQUJMSVNIRUQpDQotCQkJYnJlYWs7DQorCQkJZ290byBvdXRfc2VuZGNh
bGxhY2NwdF9yZWxlYXNlOw0KIAkJLyogbXVzdCBjYWxsIGFjY3B0YXBwcnYgYWJvdmUgKi8NCiAJ
CWlmICh0ZXN0X2JpdChYMjVfQUNDUFRfQVBQUlZfRkxBRywgJngyNS0+ZmxhZ3MpKQ0KLQkJCWJy
ZWFrOw0KKwkJCWdvdG8gb3V0X3NlbmRjYWxsYWNjcHRfcmVsZWFzZTsNCiAJCXgyNV93cml0ZV9p
bnRlcm5hbChzaywgWDI1X0NBTExfQUNDRVBURUQpOw0KIAkJeDI1LT5zdGF0ZSA9IFgyNV9TVEFU
RV8zOw0KLQkJcmVsZWFzZV9zb2NrKHNrKTsNCiAJCXJjID0gMDsNCitvdXRfc2VuZGNhbGxhY2Nw
dF9yZWxlYXNlOg0KKwkJcmVsZWFzZV9zb2NrKHNrKTsNCiAJCWJyZWFrOw0KIAl9DQogDQpkaWZm
IC0tZ2l0IGEvc291bmQvYXJtL3B4YTJ4eC1wY20tbGliLmMgYi9zb3VuZC9hcm0vcHhhMnh4LXBj
bS1saWIuYw0KaW5kZXggNzZlMGQ1Ni4uODIzMzU5ZSAxMDA2NDQNCi0tLSBhL3NvdW5kL2FybS9w
eGEyeHgtcGNtLWxpYi5jDQorKysgYi9zb3VuZC9hcm0vcHhhMnh4LXBjbS1saWIuYw0KQEAgLTE2
Niw3ICsxNjYsOSBAQCB2b2lkIHB4YTJ4eF9wY21fZG1hX2lycShpbnQgZG1hX2NoLCB2b2lkICpk
ZXZfaWQpDQogCX0gZWxzZSB7DQogCQlwcmludGsoS0VSTl9FUlIgIiVzOiBETUEgZXJyb3Igb24g
Y2hhbm5lbCAlZCAoRENTUj0lI3gpXG4iLA0KIAkJCXJ0ZC0+cGFyYW1zLT5uYW1lLCBkbWFfY2gs
IGRjc3IpOw0KKwkJc25kX3BjbV9zdHJlYW1fbG9jayhzdWJzdHJlYW0pOw0KIAkJc25kX3BjbV9z
dG9wKHN1YnN0cmVhbSwgU05EUlZfUENNX1NUQVRFX1hSVU4pOw0KKwkJc25kX3BjbV9zdHJlYW1f
dW5sb2NrKHN1YnN0cmVhbSk7DQogCX0NCiB9DQogRVhQT1JUX1NZTUJPTChweGEyeHhfcGNtX2Rt
YV9pcnEpOw0KZGlmZiAtLWdpdCBhL3NvdW5kL3BjaS9hc2locGkvYXNpaHBpLmMgYi9zb3VuZC9w
Y2kvYXNpaHBpL2FzaWhwaS5jDQppbmRleCBmNGI5ZTJiLi5mYmYwYmNkIDEwMDY0NA0KLS0tIGEv
c291bmQvcGNpL2FzaWhwaS9hc2locGkuYw0KKysrIGIvc291bmQvcGNpL2FzaWhwaS9hc2locGku
Yw0KQEAgLTc2OCw3ICs3NjgsMTAgQEAgc3RhdGljIHZvaWQgc25kX2NhcmRfYXNpaHBpX3RpbWVy
X2Z1bmN0aW9uKHVuc2lnbmVkIGxvbmcgZGF0YSkNCiAJCQkJCQlzLT5udW1iZXIpOw0KIAkJCQlk
cy0+ZHJhaW5lZF9jb3VudCsrOw0KIAkJCQlpZiAoZHMtPmRyYWluZWRfY291bnQgPiAyKSB7DQor
CQkJCQl1bnNpZ25lZCBsb25nIGZsYWdzOw0KKwkJCQkJc25kX3BjbV9zdHJlYW1fbG9ja19pcnFz
YXZlKHMsIGZsYWdzKTsNCiAJCQkJCXNuZF9wY21fc3RvcChzLCBTTkRSVl9QQ01fU1RBVEVfWFJV
Tik7DQorCQkJCQlzbmRfcGNtX3N0cmVhbV91bmxvY2tfaXJxcmVzdG9yZShzLCBmbGFncyk7DQog
CQkJCQljb250aW51ZTsNCiAJCQkJfQ0KIAkJCX0gZWxzZSB7DQpkaWZmIC0tZ2l0IGEvc291bmQv
cGNpL2F0aWl4cC5jIGIvc291bmQvcGNpL2F0aWl4cC5jDQppbmRleCAxNWU0ZTVlLi42ZmFhMTcz
IDEwMDY0NA0KLS0tIGEvc291bmQvcGNpL2F0aWl4cC5jDQorKysgYi9zb3VuZC9wY2kvYXRpaXhw
LmMNCkBAIC02ODgsNyArNjg4LDkgQEAgc3RhdGljIHZvaWQgc25kX2F0aWl4cF94cnVuX2RtYShz
dHJ1Y3QgYXRpaXhwICpjaGlwLCBzdHJ1Y3QgYXRpaXhwX2RtYSAqZG1hKQ0KIAlpZiAoISBkbWEt
PnN1YnN0cmVhbSB8fCAhIGRtYS0+cnVubmluZykNCiAJCXJldHVybjsNCiAJc25kX3ByaW50ZGQo
ImF0aWl4cDogWFJVTiBkZXRlY3RlZCAoRE1BICVkKVxuIiwgZG1hLT5vcHMtPnR5cGUpOw0KKwlz
bmRfcGNtX3N0cmVhbV9sb2NrKGRtYS0+c3Vic3RyZWFtKTsNCiAJc25kX3BjbV9zdG9wKGRtYS0+
c3Vic3RyZWFtLCBTTkRSVl9QQ01fU1RBVEVfWFJVTik7DQorCXNuZF9wY21fc3RyZWFtX3VubG9j
ayhkbWEtPnN1YnN0cmVhbSk7DQogfQ0KIA0KIC8qDQpkaWZmIC0tZ2l0IGEvc291bmQvcGNpL2F0
aWl4cF9tb2RlbS5jIGIvc291bmQvcGNpL2F0aWl4cF9tb2RlbS5jDQppbmRleCA1N2JmOGY0Li5k
NzUyMTIwIDEwMDY0NA0KLS0tIGEvc291bmQvcGNpL2F0aWl4cF9tb2RlbS5jDQorKysgYi9zb3Vu
ZC9wY2kvYXRpaXhwX21vZGVtLmMNCkBAIC02MzgsNyArNjM4LDkgQEAgc3RhdGljIHZvaWQgc25k
X2F0aWl4cF94cnVuX2RtYShzdHJ1Y3QgYXRpaXhwX21vZGVtICpjaGlwLA0KIAlpZiAoISBkbWEt
PnN1YnN0cmVhbSB8fCAhIGRtYS0+cnVubmluZykNCiAJCXJldHVybjsNCiAJc25kX3ByaW50ZGQo
ImF0aWl4cC1tb2RlbTogWFJVTiBkZXRlY3RlZCAoRE1BICVkKVxuIiwgZG1hLT5vcHMtPnR5cGUp
Ow0KKwlzbmRfcGNtX3N0cmVhbV9sb2NrKGRtYS0+c3Vic3RyZWFtKTsNCiAJc25kX3BjbV9zdG9w
KGRtYS0+c3Vic3RyZWFtLCBTTkRSVl9QQ01fU1RBVEVfWFJVTik7DQorCXNuZF9wY21fc3RyZWFt
X3VubG9jayhkbWEtPnN1YnN0cmVhbSk7DQogfQ0KIA0KIC8qDQpkaWZmIC0tZ2l0IGEvc291bmQv
cGNpL2hkYS9wYXRjaF9oZG1pLmMgYi9zb3VuZC9wY2kvaGRhL3BhdGNoX2hkbWkuYw0KaW5kZXgg
ZDE0OGEyYi4uNTVkOWIzMCAxMDA2NDQNCi0tLSBhL3NvdW5kL3BjaS9oZGEvcGF0Y2hfaGRtaS5j
DQorKysgYi9zb3VuZC9wY2kvaGRhL3BhdGNoX2hkbWkuYw0KQEAgLTE4OTcsNiArMTg5Nyw4IEBA
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgaGRhX2NvZGVjX3ByZXNldCBzbmRfaGRhX3ByZXNldF9oZG1p
W10gPSB7DQogeyAuaWQgPSAweDEwZGUwMDQyLCAubmFtZSA9ICJHUFUgNDIgSERNSS9EUCIsCS5w
YXRjaCA9IHBhdGNoX2dlbmVyaWNfaGRtaSB9LA0KIHsgLmlkID0gMHgxMGRlMDA0MywgLm5hbWUg
PSAiR1BVIDQzIEhETUkvRFAiLAkucGF0Y2ggPSBwYXRjaF9nZW5lcmljX2hkbWkgfSwNCiB7IC5p
ZCA9IDB4MTBkZTAwNDQsIC5uYW1lID0gIkdQVSA0NCBIRE1JL0RQIiwJLnBhdGNoID0gcGF0Y2hf
Z2VuZXJpY19oZG1pIH0sDQoreyAuaWQgPSAweDEwZGUwMDUxLCAubmFtZSA9ICJHUFUgNTEgSERN
SS9EUCIsCS5wYXRjaCA9IHBhdGNoX2dlbmVyaWNfaGRtaSB9LA0KK3sgLmlkID0gMHgxMGRlMDA2
MCwgLm5hbWUgPSAiR1BVIDYwIEhETUkvRFAiLAkucGF0Y2ggPSBwYXRjaF9nZW5lcmljX2hkbWkg
fSwNCiB7IC5pZCA9IDB4MTBkZTAwNjcsIC5uYW1lID0gIk1DUDY3IEhETUkiLAkucGF0Y2ggPSBw
YXRjaF9udmhkbWlfMmNoIH0sDQogeyAuaWQgPSAweDEwZGU4MDAxLCAubmFtZSA9ICJNQ1A3MyBI
RE1JIiwJLnBhdGNoID0gcGF0Y2hfbnZoZG1pXzJjaCB9LA0KIHsgLmlkID0gMHg4MDg2MDA1NCwg
Lm5hbWUgPSAiSWJleFBlYWsgSERNSSIsCS5wYXRjaCA9IHBhdGNoX2dlbmVyaWNfaGRtaSB9LA0K
QEAgLTE5NDMsNiArMTk0NSw4IEBAIE1PRFVMRV9BTElBUygic25kLWhkYS1jb2RlYy1pZDoxMGRl
MDA0MSIpOw0KIE1PRFVMRV9BTElBUygic25kLWhkYS1jb2RlYy1pZDoxMGRlMDA0MiIpOw0KIE1P
RFVMRV9BTElBUygic25kLWhkYS1jb2RlYy1pZDoxMGRlMDA0MyIpOw0KIE1PRFVMRV9BTElBUygi
c25kLWhkYS1jb2RlYy1pZDoxMGRlMDA0NCIpOw0KK01PRFVMRV9BTElBUygic25kLWhkYS1jb2Rl
Yy1pZDoxMGRlMDA1MSIpOw0KK01PRFVMRV9BTElBUygic25kLWhkYS1jb2RlYy1pZDoxMGRlMDA2
MCIpOw0KIE1PRFVMRV9BTElBUygic25kLWhkYS1jb2RlYy1pZDoxMGRlMDA2NyIpOw0KIE1PRFVM
RV9BTElBUygic25kLWhkYS1jb2RlYy1pZDoxMGRlODAwMSIpOw0KIE1PRFVMRV9BTElBUygic25k
LWhkYS1jb2RlYy1pZDoxN2U4MDA0NyIpOw0KZGlmZiAtLWdpdCBhL3NvdW5kL3NvYy9jb2RlY3Mv
bWF4OTgwODguYyBiL3NvdW5kL3NvYy9jb2RlY3MvbWF4OTgwODguYw0KaW5kZXggYjdjZjI0Ni4u
ZDU4YzU3NSAxMDA2NDQNCi0tLSBhL3NvdW5kL3NvYy9jb2RlY3MvbWF4OTgwODguYw0KKysrIGIv
c291bmQvc29jL2NvZGVjcy9tYXg5ODA4OC5jDQpAQCAtMTU5NSw3ICsxNTk1LDcgQEAgc3RhdGlj
IGludCBtYXg5ODA4OF9kYWkyX2RpZ2l0YWxfbXV0ZShzdHJ1Y3Qgc25kX3NvY19kYWkgKmNvZGVj
X2RhaSwgaW50IG11dGUpDQogDQogc3RhdGljIHZvaWQgbWF4OTgwODhfc3luY19jYWNoZShzdHJ1
Y3Qgc25kX3NvY19jb2RlYyAqY29kZWMpDQogew0KLSAgICAgICB1MTYgKnJlZ19jYWNoZSA9IGNv
ZGVjLT5yZWdfY2FjaGU7DQorICAgICAgIHU4ICpyZWdfY2FjaGUgPSBjb2RlYy0+cmVnX2NhY2hl
Ow0KICAgICAgICBpbnQgaTsNCiANCiAgICAgICAgaWYgKCFjb2RlYy0+Y2FjaGVfc3luYykNCmRp
ZmYgLS1naXQgYS9zb3VuZC9zb2MvY29kZWNzL3NndGw1MDAwLmMgYi9zb3VuZC9zb2MvY29kZWNz
L3NndGw1MDAwLmMNCmluZGV4IGJiY2Y5MjEuLmI1ZDRhOTcgMTAwNjQ0DQotLS0gYS9zb3VuZC9z
b2MvY29kZWNzL3NndGw1MDAwLmMNCisrKyBiL3NvdW5kL3NvYy9jb2RlY3Mvc2d0bDUwMDAuYw0K
QEAgLTM4LDcgKzM4LDcgQEANCiBzdGF0aWMgY29uc3QgdTE2IHNndGw1MDAwX3JlZ3NbU0dUTDUw
MDBfTUFYX1JFR19PRkZTRVRdID0gIHsNCiAJW1NHVEw1MDAwX0NISVBfQ0xLX0NUUkxdID0gMHgw
MDA4LA0KIAlbU0dUTDUwMDBfQ0hJUF9JMlNfQ1RSTF0gPSAweDAwMTAsDQotCVtTR1RMNTAwMF9D
SElQX1NTU19DVFJMXSA9IDB4MDAwOCwNCisJW1NHVEw1MDAwX0NISVBfU1NTX0NUUkxdID0gMHgw
MDEwLA0KIAlbU0dUTDUwMDBfQ0hJUF9EQUNfVk9MXSA9IDB4M2MzYywNCiAJW1NHVEw1MDAwX0NI
SVBfUEFEX1NUUkVOR1RIXSA9IDB4MDE1ZiwNCiAJW1NHVEw1MDAwX0NISVBfQU5BX0hQX0NUUkxd
ID0gMHgxODE4LA0KZGlmZiAtLWdpdCBhL3NvdW5kL3NvYy9jb2RlY3Mvc2d0bDUwMDAuaCBiL3Nv
dW5kL3NvYy9jb2RlY3Mvc2d0bDUwMDAuaA0KaW5kZXggOGE5ZjQzNS4uZDNhNjhiYiAxMDA2NDQN
Ci0tLSBhL3NvdW5kL3NvYy9jb2RlY3Mvc2d0bDUwMDAuaA0KKysrIGIvc291bmQvc29jL2NvZGVj
cy9zZ3RsNTAwMC5oDQpAQCAtMzQ3LDcgKzM0Nyw3IEBADQogI2RlZmluZSBTR1RMNTAwMF9QTExf
SU5UX0RJVl9NQVNLCQkweGY4MDANCiAjZGVmaW5lIFNHVEw1MDAwX1BMTF9JTlRfRElWX1NISUZU
CQkxMQ0KICNkZWZpbmUgU0dUTDUwMDBfUExMX0lOVF9ESVZfV0lEVEgJCTUNCi0jZGVmaW5lIFNH
VEw1MDAwX1BMTF9GUkFDX0RJVl9NQVNLCQkweDA3MDANCisjZGVmaW5lIFNHVEw1MDAwX1BMTF9G
UkFDX0RJVl9NQVNLCQkweDA3ZmYNCiAjZGVmaW5lIFNHVEw1MDAwX1BMTF9GUkFDX0RJVl9TSElG
VAkJMA0KICNkZWZpbmUgU0dUTDUwMDBfUExMX0ZSQUNfRElWX1dJRFRICQkxMQ0KIA0KZGlmZiAt
LWdpdCBhL3NvdW5kL3NvYy9zNjAwMC9zNjAwMC1wY20uYyBiL3NvdW5kL3NvYy9zNjAwMC9zNjAw
MC1wY20uYw0KaW5kZXggNTVlZmMyYi4uNzViYWJhZSAxMDA2NDQNCi0tLSBhL3NvdW5kL3NvYy9z
NjAwMC9zNjAwMC1wY20uYw0KKysrIGIvc291bmQvc29jL3M2MDAwL3M2MDAwLXBjbS5jDQpAQCAt
MTI4LDcgKzEyOCw5IEBAIHN0YXRpYyBpcnFyZXR1cm5fdCBzNjAwMF9wY21faXJxKGludCBpcnEs
IHZvaWQgKmRhdGEpDQogCQkgICAgc3Vic3RyZWFtLT5ydW50aW1lICYmDQogCQkgICAgc25kX3Bj
bV9ydW5uaW5nKHN1YnN0cmVhbSkpIHsNCiAJCQlkZXZfZGJnKHBjbS0+ZGV2LCAieHJ1blxuIik7
DQorCQkJc25kX3BjbV9zdHJlYW1fbG9jayhzdWJzdHJlYW0pOw0KIAkJCXNuZF9wY21fc3RvcChz
dWJzdHJlYW0sIFNORFJWX1BDTV9TVEFURV9YUlVOKTsNCisJCQlzbmRfcGNtX3N0cmVhbV91bmxv
Y2soc3Vic3RyZWFtKTsNCiAJCQlyZXQgPSBJUlFfSEFORExFRDsNCiAJCX0NCiANCmRpZmYgLS1n
aXQgYS9zb3VuZC91c2IvNmZpcmUvcGNtLmMgYi9zb3VuZC91c2IvNmZpcmUvcGNtLmMNCmluZGV4
IGQxNDRjZGIuLjg4OGE3YzcgMTAwNjQ0DQotLS0gYS9zb3VuZC91c2IvNmZpcmUvcGNtLmMNCisr
KyBiL3NvdW5kL3VzYi82ZmlyZS9wY20uYw0KQEAgLTU0MSw3ICs1NDEsNyBAQCBzdGF0aWMgc25k
X3BjbV91ZnJhbWVzX3QgdXNiNmZpcmVfcGNtX3BvaW50ZXIoDQogCXNuZF9wY21fdWZyYW1lc190
IHJldDsNCiANCiAJaWYgKHJ0LT5wYW5pYyB8fCAhc3ViKQ0KLQkJcmV0dXJuIFNORFJWX1BDTV9T
VEFURV9YUlVOOw0KKwkJcmV0dXJuIFNORFJWX1BDTV9QT1NfWFJVTjsNCiANCiAJc3Bpbl9sb2Nr
X2lycXNhdmUoJnN1Yi0+bG9jaywgZmxhZ3MpOw0KIAlyZXQgPSBzdWItPmRtYV9vZmY7DQpAQCAt
NjQwLDE3ICs2NDAsMjUgQEAgaW50IF9fZGV2aW5pdCB1c2I2ZmlyZV9wY21faW5pdChzdHJ1Y3Qg
c2ZpcmVfY2hpcCAqY2hpcCkNCiB2b2lkIHVzYjZmaXJlX3BjbV9hYm9ydChzdHJ1Y3Qgc2ZpcmVf
Y2hpcCAqY2hpcCkNCiB7DQogCXN0cnVjdCBwY21fcnVudGltZSAqcnQgPSBjaGlwLT5wY207DQor
CXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQogCWludCBpOw0KIA0KIAlpZiAocnQpIHsNCiAJCXJ0LT5w
YW5pYyA9IHRydWU7DQogDQotCQlpZiAocnQtPnBsYXliYWNrLmluc3RhbmNlKQ0KKwkJaWYgKHJ0
LT5wbGF5YmFjay5pbnN0YW5jZSkgew0KKwkJCXNuZF9wY21fc3RyZWFtX2xvY2tfaXJxc2F2ZShy
dC0+cGxheWJhY2suaW5zdGFuY2UsIGZsYWdzKTsNCiAJCQlzbmRfcGNtX3N0b3AocnQtPnBsYXli
YWNrLmluc3RhbmNlLA0KIAkJCQkJU05EUlZfUENNX1NUQVRFX1hSVU4pOw0KLQkJaWYgKHJ0LT5j
YXB0dXJlLmluc3RhbmNlKQ0KKwkJCXNuZF9wY21fc3RyZWFtX3VubG9ja19pcnFyZXN0b3JlKHJ0
LT5wbGF5YmFjay5pbnN0YW5jZSwgZmxhZ3MpOw0KKwkJfQ0KKw0KKwkJaWYgKHJ0LT5jYXB0dXJl
Lmluc3RhbmNlKSB7DQorCQkJc25kX3BjbV9zdHJlYW1fbG9ja19pcnFzYXZlKHJ0LT5jYXB0dXJl
Lmluc3RhbmNlLCBmbGFncyk7DQogCQkJc25kX3BjbV9zdG9wKHJ0LT5jYXB0dXJlLmluc3RhbmNl
LA0KIAkJCQkJU05EUlZfUENNX1NUQVRFX1hSVU4pOw0KKwkJCXNuZF9wY21fc3RyZWFtX3VubG9j
a19pcnFyZXN0b3JlKHJ0LT5jYXB0dXJlLmluc3RhbmNlLCBmbGFncyk7DQorCQl9DQogDQogCQlm
b3IgKGkgPSAwOyBpIDwgUENNX05fVVJCUzsgaSsrKSB7DQogCQkJdXNiX3BvaXNvbl91cmIoJnJ0
LT5pbl91cmJzW2ldLmluc3RhbmNlKTsNCmRpZmYgLS1naXQgYS9zb3VuZC91c2IvbWlzYy91YTEw
MS5jIGIvc291bmQvdXNiL21pc2MvdWExMDEuYw0KaW5kZXggYzA2MDljMi4uODQwNTJjZiAxMDA2
NDQNCi0tLSBhL3NvdW5kL3VzYi9taXNjL3VhMTAxLmMNCisrKyBiL3NvdW5kL3VzYi9taXNjL3Vh
MTAxLmMNCkBAIC02MTMsMTQgKzYxMywyNCBAQCBzdGF0aWMgaW50IHN0YXJ0X3VzYl9wbGF5YmFj
ayhzdHJ1Y3QgdWExMDEgKnVhKQ0KIA0KIHN0YXRpYyB2b2lkIGFib3J0X2Fsc2FfY2FwdHVyZShz
dHJ1Y3QgdWExMDEgKnVhKQ0KIHsNCi0JaWYgKHRlc3RfYml0KEFMU0FfQ0FQVFVSRV9SVU5OSU5H
LCAmdWEtPnN0YXRlcykpDQorCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQorDQorCWlmICh0ZXN0X2Jp
dChBTFNBX0NBUFRVUkVfUlVOTklORywgJnVhLT5zdGF0ZXMpKSB7DQorCQlzbmRfcGNtX3N0cmVh
bV9sb2NrX2lycXNhdmUodWEtPmNhcHR1cmUuc3Vic3RyZWFtLCBmbGFncyk7DQogCQlzbmRfcGNt
X3N0b3AodWEtPmNhcHR1cmUuc3Vic3RyZWFtLCBTTkRSVl9QQ01fU1RBVEVfWFJVTik7DQorCQlz
bmRfcGNtX3N0cmVhbV91bmxvY2tfaXJxcmVzdG9yZSh1YS0+Y2FwdHVyZS5zdWJzdHJlYW0sIGZs
YWdzKTsNCisJfQ0KIH0NCiANCiBzdGF0aWMgdm9pZCBhYm9ydF9hbHNhX3BsYXliYWNrKHN0cnVj
dCB1YTEwMSAqdWEpDQogew0KLQlpZiAodGVzdF9iaXQoQUxTQV9QTEFZQkFDS19SVU5OSU5HLCAm
dWEtPnN0YXRlcykpDQorCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQorDQorCWlmICh0ZXN0X2JpdChB
TFNBX1BMQVlCQUNLX1JVTk5JTkcsICZ1YS0+c3RhdGVzKSkgew0KKwkJc25kX3BjbV9zdHJlYW1f
bG9ja19pcnFzYXZlKHVhLT5wbGF5YmFjay5zdWJzdHJlYW0sIGZsYWdzKTsNCiAJCXNuZF9wY21f
c3RvcCh1YS0+cGxheWJhY2suc3Vic3RyZWFtLCBTTkRSVl9QQ01fU1RBVEVfWFJVTik7DQorCQlz
bmRfcGNtX3N0cmVhbV91bmxvY2tfaXJxcmVzdG9yZSh1YS0+cGxheWJhY2suc3Vic3RyZWFtLCBm
bGFncyk7DQorCX0NCiB9DQogDQogc3RhdGljIGludCBzZXRfc3RyZWFtX2h3KHN0cnVjdCB1YTEw
MSAqdWEsIHN0cnVjdCBzbmRfcGNtX3N1YnN0cmVhbSAqc3Vic3RyZWFtLA0KZGlmZiAtLWdpdCBh
L3NvdW5kL3VzYi91c3gyeS91c2J1c3gyeWF1ZGlvLmMgYi9zb3VuZC91c2IvdXN4MnkvdXNidXN4
MnlhdWRpby5jDQppbmRleCA2ZmZiMzcxLi5kNTcyNGQ4IDEwMDY0NA0KLS0tIGEvc291bmQvdXNi
L3VzeDJ5L3VzYnVzeDJ5YXVkaW8uYw0KKysrIGIvc291bmQvdXNiL3VzeDJ5L3VzYnVzeDJ5YXVk
aW8uYw0KQEAgLTI3Myw3ICsyNzMsMTEgQEAgc3RhdGljIHZvaWQgdXNYMllfY2xpZW50c19zdG9w
KHN0cnVjdCB1c1gyWWRldiAqdXNYMlkpDQogCQlzdHJ1Y3Qgc25kX3VzWDJZX3N1YnN0cmVhbSAq
c3VicyA9IHVzWDJZLT5zdWJzW3NdOw0KIAkJaWYgKHN1YnMpIHsNCiAJCQlpZiAoYXRvbWljX3Jl
YWQoJnN1YnMtPnN0YXRlKSA+PSBzdGF0ZV9QUkVSVU5OSU5HKSB7DQorCQkJCXVuc2lnbmVkIGxv
bmcgZmxhZ3M7DQorDQorCQkJCXNuZF9wY21fc3RyZWFtX2xvY2tfaXJxc2F2ZShzdWJzLT5wY21f
c3Vic3RyZWFtLCBmbGFncyk7DQogCQkJCXNuZF9wY21fc3RvcChzdWJzLT5wY21fc3Vic3RyZWFt
LCBTTkRSVl9QQ01fU1RBVEVfWFJVTik7DQorCQkJCXNuZF9wY21fc3RyZWFtX3VubG9ja19pcnFy
ZXN0b3JlKHN1YnMtPnBjbV9zdWJzdHJlYW0sIGZsYWdzKTsNCiAJCQl9DQogCQkJZm9yICh1ID0g
MDsgdSA8IE5SVVJCUzsgdSsrKSB7DQogCQkJCXN0cnVjdCB1cmIgKnVyYiA9IHN1YnMtPnVyYlt1
XTsNCn==


--=-FKkQ2AAH8Owp7TStfoHb--

--=-d+3U4e2WbZbdAw201rsB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfwpwue/yOyVhhEJAQoL7hAAzuHi9fBKim3XDLIhjICo0A7E/214abCz
7sQRTh5W0251ZzxxtQZcH9xly4z0xKPVeRFS0Q5ColQHLkhcUlzmzco5Oh+JSjl3
M6y8DzDDXmg5VUebuTqKqB957rYf2a4spNv4H6C2lmnKtJNkm0mTgBcqNmW/wnOY
f9hYgKDwWi/QSCpvuzKfwAUwD97QNq2jUz9fhPjvMgF3vC939YJkbTDaXOpXum66
Clx6E6thssCasavj1pFySfG9zF8+U/XG2VEnmvf9MzezkRNrAIPrkvhP070LqCWk
lp/XjNakBQa1VJSS16JnHkOYdruPFwc8FKTsQVJgRq/vS9tczf59rnQrc5bPh0Mq
FOvnrCYS0V/2+TNFUN6eS35Igy3ikkiPFuKc/Cl7CqRHXlCDhp+4rzVanUJzHI2L
9+dhIJfzdZHs1nyhT+f9cwXxel8rVMyKxO//g8b06NSrBeabBnquMuSNxtf4+PNs
FJCOIn6BVZ6nk4MbmduM6PDIpsQDO2u3CHQrjiDCEK5hePa8eDuJGAOAf1EjqBRr
QL4ByVJpegVyorXoiMy0KhBSImtoBr6Bk17aoWC4XZaABxlSDfzSBDwsbndbhqjK
2kYoWunVwMjVS0HdgssOwDqgJku7zz2ZICC0DIWQYGAOQe7qmfA/X3Uu/qQB9dd+
FmkzOZaO7OA=
=uCSl
-----END PGP SIGNATURE-----

--=-d+3U4e2WbZbdAw201rsB--
