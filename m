Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965191Ab3DJKmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:42:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38570 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755371Ab3DJKmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:42:09 -0400
Message-ID: <1365590517.3086.3.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.43
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 10 Apr 2013 11:41:57 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-XvhQ9NkkmMjRyOzVZq7T"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:290b:290b:eb64:1fff
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XvhQ9NkkmMjRyOzVZq7T
Content-Type: multipart/mixed; boundary="=-PPJ2WdjtiL/c7yRVODFw"


--=-PPJ2WdjtiL/c7yRVODFw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.43 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.42 is attached to this message.

Ben.

------------

 Makefile                                           |    2 +-
 arch/tile/kernel/setup.c                           |   18 +-
 drivers/block/aoe/aoecmd.c                         |    3 +-
 drivers/block/loop.c                               |    9 +-
 drivers/block/xen-blkback/blkback.c                |    7 +-
 drivers/bluetooth/ath3k.c                          |   18 ++
 drivers/bluetooth/btusb.c                          |    9 +
 drivers/char/virtio_console.c                      |   20 +-
 drivers/eisa/pci_eisa.c                            |   39 ++--
 drivers/hid/hid-ids.h                              |    6 +
 drivers/hid/hid-microsoft.c                        |    6 +-
 drivers/hid/usbhid/hid-quirks.c                    |    2 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |    8 +-
 drivers/iommu/amd_iommu.c                          |   20 +-
 drivers/net/bonding/bond_main.c                    |   91 +++------
 drivers/net/bonding/bond_sysfs.c                   |  121 ++++++-----
 drivers/net/can/sja1000/plx_pci.c                  |    4 +-
 drivers/net/can/sja1000/sja1000.c                  |    6 +-
 drivers/net/can/sja1000/sja1000.h                  |    2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e.h         |    1 -
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   22 +-
 drivers/net/ethernet/broadcom/tg3.c                |    7 +-
 drivers/net/ethernet/davicom/dm9000.c              |  214 ++++++++++------=
----
 drivers/net/ethernet/davicom/dm9000.h              |   11 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    7 +-
 drivers/net/ethernet/marvell/sky2.c                |    2 +-
 drivers/net/ethernet/marvell/sky2.h                |    2 +-
 drivers/net/ethernet/micrel/ks8851.c               |    2 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    4 +-
 drivers/net/ethernet/ti/davinci_emac.c             |    2 +-
 drivers/net/usb/smsc75xx.c                         |   12 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |    4 +
 drivers/net/wireless/b43/dma.c                     |   65 ++++--
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    2 +
 drivers/net/wireless/rtlwifi/usb.c                 |    1 +
 drivers/spi/spi-mpc512x-psc.c                      |    2 +-
 drivers/staging/comedi/drivers/s626.c              |    2 +-
 drivers/tty/serial/atmel_serial.c                  |   11 +-
 drivers/tty/vt/vc_screen.c                         |    6 +-
 drivers/usb/host/xhci-ring.c                       |   24 +--
 drivers/usb/host/xhci.h                            |    4 +
 drivers/usb/serial/ftdi_sio.c                      |    1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    7 +
 fs/block_dev.c                                     |    1 +
 fs/btrfs/extent-tree.c                             |    2 +-
 fs/dcache.c                                        |   16 +-
 fs/nfs/blocklayout/blocklayoutdm.c                 |    4 +-
 fs/nfs/nfs4proc.c                                  |   17 +-
 fs/nfs/pnfs.c                                      |   19 +-
 fs/nfsd/nfs4xdr.c                                  |    2 +-
 fs/reiserfs/xattr.c                                |    4 +-
 fs/sysfs/dir.c                                     |   17 +-
 fs/ubifs/super.c                                   |   12 +-
 fs/udf/udf_sb.h                                    |    2 +-
 include/linux/thermal.h                            |    2 +-
 kernel/time/tick-broadcast.c                       |    3 +-
 mm/mmap.c                                          |    2 +-
 mm/nommu.c                                         |    2 +-
 net/8021q/vlan.c                                   |   14 +-
 net/core/dev.c                                     |    6 +
 net/ipv4/tcp_input.c                               |    7 +-
 net/ipv4/tcp_output.c                              |    7 +-
 net/ipv6/addrconf.c                                |   26 +--
 net/ipv6/ip6_input.c                               |   21 ++
 net/irda/af_irda.c                                 |    6 +-
 net/netlink/genetlink.c                            |    1 +
 net/sunrpc/sched.c                                 |    9 +-
 net/unix/af_unix.c                                 |    7 +-
 security/keys/keyctl.c                             |    4 +-
 sound/soc/imx/imx-ssi.c                            |    5 +
 sound/soc/sh/dma-sh7760.c                          |    4 +-
 71 files changed, 585 insertions(+), 443 deletions(-)

AceLan Kao (3):
      Bluetooth: Add support for IMC Networks [13d3:3393]
      Bluetooth: Add support for Foxconn / Hon Hai [0489:e04e]
      Bluetooth: Add support for Foxconn / Hon Hai [0489:e056]

Al Viro (2):
      Nest rename_lock inside vfsmount_lock
      vt: synchronize_rcu() under spinlock is not nice...

Alan Cox (1):
      key: Fix resource leak

Amit Shah (2):
      virtio: console: rename cvq_lock to c_ivq_lock
      virtio: console: add locking around c_ovq operations

Anatol Pomozov (1):
      loop: prevent bdev freeing while device in use

Anatolij Gustschin (1):
      spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmenst=
s

Artem Bityutskiy (1):
      UBIFS: make space fixup work in the remount case

Ben Hutchings (1):
      Linux 3.2.43

Chris Metcalf (1):
      tile: expect new initramfs name from hypervisor file system

Chuck Lever (1):
      NFS: nfs_getaclargs.acl_len is a size_t

Cong Wang (1):
      8021q: fix a potential use-after-free

Daniel Schaal (1):
      Bluetooth: Add support for GC-WB300D PCIe [04ca:3006] to ath3k.

Eric Dumazet (3):
      tcp: preserve ACK clocking in TSO
      aoe: reserve enough headroom on skbs
      net: add a synchronize_net() in  netdev_rx_handler_unregister()

Felix Fietkau (2):
      ath9k_hw: revert chainmask to user configuration after calibration
      rt2x00: error in configurations with  mesh support disabled

Hannes Frederic Sowa (3):
      atl1e: drop pci-msi support because of packet  corruption
      ipv6: don't accept multicast traffic with scope 0
      ipv6: don't accept node local multicast traffic from  the wire

Hong Zhiguo (1):
      ipv6: fix bad free of addrconf_init_net

Ian Abbott (1):
      staging: comedi: s626: fix continuous acquisition

Iestyn C. Elfick (1):
      b43: A fix for DMA transmission sequence errors

J. Bruce Fields (1):
      nfsd4: reject "negative" acl lengths

Jakub Kicinski (1):
      ixgbe: fix registration order of driver and DCA nofitication

Jan Beulich (1):
      xen-blkback: fix dispatch_rw_block_io() error path

Jan Kara (2):
      reiserfs: Fix warning and inode leak when deleting inode with xattrs
      udf: Fix bitmap overflow on large filesystems with small block size

Jan Stancek (1):
      mm: prevent mmap_cache race in find_vma()

Jiri Kosina (1):
      HID: usbhid: fix build problem

Jiri Slaby (1):
      HID: microsoft: do not use compound literal - fix build

Joerg Roedel (1):
      iommu/amd: Make sure dma_ops are set for hotplug devices

Josef Bacik (1):
      Btrfs: limit the global reserve to 512mb

Joseph CHANG (1):
      DM9000B: driver initialization upgrade

Josh Boyer (3):
      Bluetooth: Add support for atheros 04ca:3004 device to ath3k
      HID: usbhid: quirk for Realtek Multi-card reader
      HID: usbhid: quirk for MSI GX680R led panel

Jussi Kivilinna (1):
      rtlwifi: usb: add missing freeing of skbuff

Kees Cook (2):
      net/irda: add missing error path release_sock call
      tg3: fix length overflow in VPD firmware parsing

Konstantin Holoborodko (1):
      usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD

Lars-Peter Clausen (1):
      ASoC: dma-sh7760: Fix compile error

Marc Kleine-Budde (1):
      can: sja1000: fix define conflict on SH

Mark Rutland (1):
      clockevents: Don't allow dummy broadcast timers

Masatake YAMATO (1):
      thermal: shorten too long mcast group name

Max.Nekludov@us.elster.com (1):
      ks8851: Fix interpretation of rxlen field.

Mike Marciniszyn (1):
      IPoIB: Fix send lockup due to missed TX completion

Ming Lei (4):
      Bluetooth: Add support for Dell[QCA 0cf3:0036]
      Bluetooth: Add support for Dell[QCA 0cf3:817a]
      sysfs: fix race between readdir and lseek
      sysfs: handle failure path correctly for readdir()

Mirko Lindner (2):
      sky2: Receive Overflows not counted
      sky2: Threshold for Pause Packet is set wrong

Mugunthan V N (1):
      drivers: net: ethernet: davinci_emac: use  netif_wake_queue() while r=
estarting tx queue

Paul Moore (1):
      unix: fix a race condition in unix_release()

Pawel Wieczorkiewicz (1):
      tty: atmel_serial_probe(): index of atmel_ports[] fix

Sascha Hauer (1):
      ASoC: imx-ssi: Fix occasional AC97 reset failure

Sergio Cambra (1):
      Bluetooth device 04ca:3008 should use ath3k

Steve Glendinning (1):
      smsc75xx: fix jumbo frame support

Sunguk Lee (1):
      Bluetooth: Device 0cf3:3008 should map AR 3012

Trond Myklebust (2):
      NFSv4.1: Fix a race in pNFS layoutcommit
      SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queu=
e_locked

Veaceslav Falico (3):
      bonding: remove already created master sysfs link on  failure
      pch_gbe: fix ip_summed checksum reporting on rx
      bonding: get netdev_rx_handler_unregister out of locks

Vivek Gautam (1):
      usb: xhci: Fix TRB transfer length macro used for Event TRB.

Yinghai Lu (1):
      EISA/PCI: Init EISA early, before PNP

Yuchung Cheng (1):
      tcp: undo spurious timeout after SACK reneging

fanchaoting (1):
      pnfs-block: removing DM device maybe cause oops when call dev_remove

nikolay@redhat.com (2):
      bonding: fix miimon and arp_interval delayed work race  conditions
      bonding: fix disabling of arp_interval and miimon



--=-PPJ2WdjtiL/c7yRVODFw
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.43.patch"
Content-Disposition: attachment; filename="linux-3.2.43.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUNCmluZGV4IGQ0NGYwMDkuLjU5MTMwZGIg
MTAwNjQ0DQotLS0gYS9NYWtlZmlsZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0xLDYgKzEsNiBAQA0K
IFZFUlNJT04gPSAzDQogUEFUQ0hMRVZFTCA9IDINCi1TVUJMRVZFTCA9IDQyDQorU1VCTEVWRUwg
PSA0Mw0KIEVYVFJBVkVSU0lPTiA9DQogTkFNRSA9IFNhYmVyLXRvb3RoZWQgU3F1aXJyZWwNCiAN
CmRpZmYgLS1naXQgYS9hcmNoL3RpbGUva2VybmVsL3NldHVwLmMgYi9hcmNoL3RpbGUva2VybmVs
L3NldHVwLmMNCmluZGV4IDVmODVkOGIuLmEwOWI2YzMgMTAwNjQ0DQotLS0gYS9hcmNoL3RpbGUv
a2VybmVsL3NldHVwLmMNCisrKyBiL2FyY2gvdGlsZS9rZXJuZWwvc2V0dXAuYw0KQEAgLTkxNCw3
ICs5MTQsNyBAQCB2b2lkIF9fY3B1aW5pdCBzZXR1cF9jcHUoaW50IGJvb3QpDQogI2lmZGVmIENP
TkZJR19CTEtfREVWX0lOSVRSRA0KIA0KIHN0YXRpYyBpbnQgX19pbml0ZGF0YSBzZXRfaW5pdHJh
bWZzX2ZpbGU7DQotc3RhdGljIGNoYXIgX19pbml0ZGF0YSBpbml0cmFtZnNfZmlsZVsxMjhdID0g
ImluaXRyYW1mcy5jcGlvLmd6IjsNCitzdGF0aWMgY2hhciBfX2luaXRkYXRhIGluaXRyYW1mc19m
aWxlWzEyOF0gPSAiaW5pdHJhbWZzIjsNCiANCiBzdGF0aWMgaW50IF9faW5pdCBzZXR1cF9pbml0
cmFtZnNfZmlsZShjaGFyICpzdHIpDQogew0KQEAgLTkyOCw5ICs5MjgsOSBAQCBzdGF0aWMgaW50
IF9faW5pdCBzZXR1cF9pbml0cmFtZnNfZmlsZShjaGFyICpzdHIpDQogZWFybHlfcGFyYW0oImlu
aXRyYW1mc19maWxlIiwgc2V0dXBfaW5pdHJhbWZzX2ZpbGUpOw0KIA0KIC8qDQotICogV2UgbG9v
ayBmb3IgYW4gYWRkaXRpb25hbCAiaW5pdHJhbWZzLmNwaW8uZ3oiIGZpbGUgaW4gdGhlIGh2ZnMu
DQotICogSWYgdGhlcmUgaXMgb25lLCB3ZSBhbGxvY2F0ZSBzb21lIG1lbW9yeSBmb3IgaXQgYW5k
IGl0IHdpbGwgYmUNCi0gKiB1bnBhY2tlZCB0byB0aGUgaW5pdHJhbWZzIGFmdGVyIGFueSBidWls
dC1pbiBpbml0cmFtZnNfZGF0YS4NCisgKiBXZSBsb29rIGZvciBhIGZpbGUgY2FsbGVkICJpbml0
cmFtZnMiIGluIHRoZSBodmZzLiAgSWYgdGhlcmUgaXMgb25lLCB3ZQ0KKyAqIGFsbG9jYXRlIHNv
bWUgbWVtb3J5IGZvciBpdCBhbmQgaXQgd2lsbCBiZSB1bnBhY2tlZCB0byB0aGUgaW5pdHJhbWZz
Lg0KKyAqIElmIGl0J3MgY29tcHJlc3NlZCwgdGhlIGluaXRkIGNvZGUgd2lsbCB1bmNvbXByZXNz
IGl0IGZpcnN0Lg0KICAqLw0KIHN0YXRpYyB2b2lkIF9faW5pdCBsb2FkX2h2X2luaXRyZCh2b2lk
KQ0KIHsNCkBAIC05NDAsMTAgKzk0MCwxNiBAQCBzdGF0aWMgdm9pZCBfX2luaXQgbG9hZF9odl9p
bml0cmQodm9pZCkNCiANCiAJZmQgPSBodl9mc19maW5kZmlsZSgoSFZfVmlydEFkZHIpIGluaXRy
YW1mc19maWxlKTsNCiAJaWYgKGZkID09IEhWX0VOT0VOVCkgew0KLQkJaWYgKHNldF9pbml0cmFt
ZnNfZmlsZSkNCisJCWlmIChzZXRfaW5pdHJhbWZzX2ZpbGUpIHsNCiAJCQlwcl93YXJuaW5nKCJO
byBzdWNoIGh2ZnMgaW5pdHJhbWZzIGZpbGUgJyVzJ1xuIiwNCiAJCQkJICAgaW5pdHJhbWZzX2Zp
bGUpOw0KLQkJcmV0dXJuOw0KKwkJCXJldHVybjsNCisJCX0gZWxzZSB7DQorCQkJLyogVHJ5IG9s
ZCBiYWNrd2FyZHMtY29tcGF0aWJsZSBuYW1lLiAqLw0KKwkJCWZkID0gaHZfZnNfZmluZGZpbGUo
KEhWX1ZpcnRBZGRyKSJpbml0cmFtZnMuY3Bpby5neiIpOw0KKwkJCWlmIChmZCA9PSBIVl9FTk9F
TlQpDQorCQkJCXJldHVybjsNCisJCX0NCiAJfQ0KIAlCVUdfT04oZmQgPCAwKTsNCiAJc3RhdCA9
IGh2X2ZzX2ZzdGF0KGZkKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Jsb2NrL2FvZS9hb2VjbWQu
YyBiL2RyaXZlcnMvYmxvY2svYW9lL2FvZWNtZC5jDQppbmRleCA4ODdmNjhmLi5kYjMwNTQyIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9ibG9jay9hb2UvYW9lY21kLmMNCisrKyBiL2RyaXZlcnMvYmxv
Y2svYW9lL2FvZWNtZC5jDQpAQCAtMzAsOCArMzAsOSBAQCBuZXdfc2tiKHVsb25nIGxlbikNCiB7
DQogCXN0cnVjdCBza19idWZmICpza2I7DQogDQotCXNrYiA9IGFsbG9jX3NrYihsZW4sIEdGUF9B
VE9NSUMpOw0KKwlza2IgPSBhbGxvY19za2IobGVuICsgTUFYX0hFQURFUiwgR0ZQX0FUT01JQyk7
DQogCWlmIChza2IpIHsNCisJCXNrYl9yZXNlcnZlKHNrYiwgTUFYX0hFQURFUik7DQogCQlza2Jf
cmVzZXRfbWFjX2hlYWRlcihza2IpOw0KIAkJc2tiX3Jlc2V0X25ldHdvcmtfaGVhZGVyKHNrYik7
DQogCQlza2ItPnByb3RvY29sID0gX19jb25zdGFudF9odG9ucyhFVEhfUF9BT0UpOw0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvYmxvY2svbG9vcC5jIGIvZHJpdmVycy9ibG9jay9sb29wLmMNCmluZGV4
IDhjNjc4N2EuLmEzNjU1NjIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Jsb2NrL2xvb3AuYw0KKysr
IGIvZHJpdmVycy9ibG9jay9sb29wLmMNCkBAIC05MDcsNiArOTA3LDExIEBAIHN0YXRpYyBpbnQg
bG9vcF9zZXRfZmQoc3RydWN0IGxvb3BfZGV2aWNlICpsbywgZm1vZGVfdCBtb2RlLA0KIAkJbG8t
PmxvX2ZsYWdzIHw9IExPX0ZMQUdTX1BBUlRTQ0FOOw0KIAlpZiAobG8tPmxvX2ZsYWdzICYgTE9f
RkxBR1NfUEFSVFNDQU4pDQogCQlpb2N0bF9ieV9iZGV2KGJkZXYsIEJMS1JSUEFSVCwgMCk7DQor
DQorCS8qIEdyYWIgdGhlIGJsb2NrX2RldmljZSB0byBwcmV2ZW50IGl0cyBkZXN0cnVjdGlvbiBh
ZnRlciB3ZQ0KKwkgKiBwdXQgL2Rldi9sb29wWFggaW5vZGUuIExhdGVyIGluIGxvb3BfY2xyX2Zk
KCkgd2UgYmRwdXQoYmRldikuDQorCSAqLw0KKwliZGdyYWIoYmRldik7DQogCXJldHVybiAwOw0K
IA0KIG91dF9jbHI6DQpAQCAtMTAwMyw4ICsxMDA4LDEwIEBAIHN0YXRpYyBpbnQgbG9vcF9jbHJf
ZmQoc3RydWN0IGxvb3BfZGV2aWNlICpsbykNCiAJbWVtc2V0KGxvLT5sb19lbmNyeXB0X2tleSwg
MCwgTE9fS0VZX1NJWkUpOw0KIAltZW1zZXQobG8tPmxvX2NyeXB0X25hbWUsIDAsIExPX05BTUVf
U0laRSk7DQogCW1lbXNldChsby0+bG9fZmlsZV9uYW1lLCAwLCBMT19OQU1FX1NJWkUpOw0KLQlp
ZiAoYmRldikNCisJaWYgKGJkZXYpIHsNCisJCWJkcHV0KGJkZXYpOw0KIAkJaW52YWxpZGF0ZV9i
ZGV2KGJkZXYpOw0KKwl9DQogCXNldF9jYXBhY2l0eShsby0+bG9fZGlzaywgMCk7DQogCWxvb3Bf
c3lzZnNfZXhpdChsbyk7DQogCWlmIChiZGV2KSB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9j
ay94ZW4tYmxrYmFjay9ibGtiYWNrLmMgYi9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL2Jsa2Jh
Y2suYw0KaW5kZXggMTVlYzRkYi4uODVmZGQ0YiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYmxvY2sv
eGVuLWJsa2JhY2svYmxrYmFjay5jDQorKysgYi9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL2Js
a2JhY2suYw0KQEAgLTc1OCwxMyArNzU4LDcgQEAgc3RhdGljIGludCBkaXNwYXRjaF9yd19ibG9j
a19pbyhzdHJ1Y3QgeGVuX2Jsa2lmICpibGtpZiwNCiAJCX0NCiAJfQ0KIA0KLQkvKg0KLQkgKiBX
ZSBzZXQgaXQgb25lIHNvIHRoYXQgdGhlIGxhc3Qgc3VibWl0X2JpbyBkb2VzIG5vdCBoYXZlIHRv
IGNhbGwNCi0JICogYXRvbWljX2luYy4NCi0JICovDQogCWF0b21pY19zZXQoJnBlbmRpbmdfcmVx
LT5wZW5kY250LCBuYmlvKTsNCi0NCi0JLyogR2V0IGEgcmVmZXJlbmNlIGNvdW50IGZvciB0aGUg
ZGlzayBxdWV1ZSBhbmQgc3RhcnQgc2VuZGluZyBJL08gKi8NCiAJYmxrX3N0YXJ0X3BsdWcoJnBs
dWcpOw0KIA0KIAlmb3IgKGkgPSAwOyBpIDwgbmJpbzsgaSsrKQ0KQEAgLTc5Miw2ICs3ODYsNyBA
QCBzdGF0aWMgaW50IGRpc3BhdGNoX3J3X2Jsb2NrX2lvKHN0cnVjdCB4ZW5fYmxraWYgKmJsa2lm
LA0KICBmYWlsX3B1dF9iaW86DQogCWZvciAoaSA9IDA7IGkgPCBuYmlvOyBpKyspDQogCQliaW9f
cHV0KGJpb2xpc3RbaV0pOw0KKwlhdG9taWNfc2V0KCZwZW5kaW5nX3JlcS0+cGVuZGNudCwgMSk7
DQogCV9fZW5kX2Jsb2NrX2lvX29wKHBlbmRpbmdfcmVxLCAtRUlOVkFMKTsNCiAJbXNsZWVwKDEp
OyAvKiBiYWNrIG9mZiBhIGJpdCAqLw0KIAlyZXR1cm4gLUVJTzsNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2JsdWV0b290aC9hdGgzay5jIGIvZHJpdmVycy9ibHVldG9vdGgvYXRoM2suYw0KaW5kZXgg
NTc0Y2U3My4uODUzZmRmOCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYmx1ZXRvb3RoL2F0aDNrLmMN
CisrKyBiL2RyaXZlcnMvYmx1ZXRvb3RoL2F0aDNrLmMNCkBAIC03MiwxNCArNzIsMjMgQEAgc3Rh
dGljIHN0cnVjdCB1c2JfZGV2aWNlX2lkIGF0aDNrX3RhYmxlW10gPSB7DQogCXsgVVNCX0RFVklD
RSgweDAzRjAsIDB4MzExRCkgfSwNCiANCiAJLyogQXRoZXJvcyBBUjMwMTIgd2l0aCBzZmxhc2gg
ZmlybXdhcmUqLw0KKwl7IFVTQl9ERVZJQ0UoMHgwQ0YzLCAweDAwMzYpIH0sDQogCXsgVVNCX0RF
VklDRSgweDBDRjMsIDB4MzAwNCkgfSwNCisJeyBVU0JfREVWSUNFKDB4MENGMywgMHgzMDA4KSB9
LA0KIAl7IFVTQl9ERVZJQ0UoMHgwQ0YzLCAweDMxMUQpIH0sDQorCXsgVVNCX0RFVklDRSgweDBD
RjMsIDB4ODE3YSkgfSwNCiAJeyBVU0JfREVWSUNFKDB4MTNkMywgMHgzMzc1KSB9LA0KKwl7IFVT
Ql9ERVZJQ0UoMHgwNENBLCAweDMwMDQpIH0sDQogCXsgVVNCX0RFVklDRSgweDA0Q0EsIDB4MzAw
NSkgfSwNCisJeyBVU0JfREVWSUNFKDB4MDRDQSwgMHgzMDA2KSB9LA0KKwl7IFVTQl9ERVZJQ0Uo
MHgwNENBLCAweDMwMDgpIH0sDQogCXsgVVNCX0RFVklDRSgweDEzZDMsIDB4MzM2MikgfSwNCiAJ
eyBVU0JfREVWSUNFKDB4MENGMywgMHhFMDA0KSB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgwOTMwLCAw
eDAyMTkpIH0sDQogCXsgVVNCX0RFVklDRSgweDA0ODksIDB4ZTA1NykgfSwNCisJeyBVU0JfREVW
SUNFKDB4MTNkMywgMHgzMzkzKSB9LA0KKwl7IFVTQl9ERVZJQ0UoMHgwNDg5LCAweGUwNGUpIH0s
DQorCXsgVVNCX0RFVklDRSgweDA0ODksIDB4ZTA1NikgfSwNCiANCiAJLyogQXRoZXJvcyBBUjVC
QlUxMiB3aXRoIHNmbGFzaCBmaXJtd2FyZSAqLw0KIAl7IFVTQl9ERVZJQ0UoMHgwNDg5LCAweEUw
MkMpIH0sDQpAQCAtOTksMTQgKzEwOCwyMyBAQCBNT0RVTEVfREVWSUNFX1RBQkxFKHVzYiwgYXRo
M2tfdGFibGUpOw0KIHN0YXRpYyBzdHJ1Y3QgdXNiX2RldmljZV9pZCBhdGgza19ibGlzdF90Ymxb
XSA9IHsNCiANCiAJLyogQXRoZXJvcyBBUjMwMTIgd2l0aCBzZmxhc2ggZmlybXdhcmUqLw0KKwl7
IFVTQl9ERVZJQ0UoMHgwQ0YzLCAweDAwMzYpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEy
IH0sDQogCXsgVVNCX0RFVklDRSgweDBjZjMsIDB4MzAwNCksIC5kcml2ZXJfaW5mbyA9IEJUVVNC
X0FUSDMwMTIgfSwNCisJeyBVU0JfREVWSUNFKDB4MGNmMywgMHgzMDA4KSwgLmRyaXZlcl9pbmZv
ID0gQlRVU0JfQVRIMzAxMiB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgwY2YzLCAweDMxMUQpLCAuZHJp
dmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQorCXsgVVNCX0RFVklDRSgweDBDRjMsIDB4ODE3
YSksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiAJeyBVU0JfREVWSUNFKDB4MTNk
MywgMHgzMzc1KSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KKwl7IFVTQl9ERVZJ
Q0UoMHgwNGNhLCAweDMwMDQpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQogCXsg
VVNCX0RFVklDRSgweDA0Y2EsIDB4MzAwNSksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIg
fSwNCisJeyBVU0JfREVWSUNFKDB4MDRjYSwgMHgzMDA2KSwgLmRyaXZlcl9pbmZvID0gQlRVU0Jf
QVRIMzAxMiB9LA0KKwl7IFVTQl9ERVZJQ0UoMHgwNGNhLCAweDMwMDgpLCAuZHJpdmVyX2luZm8g
PSBCVFVTQl9BVEgzMDEyIH0sDQogCXsgVVNCX0RFVklDRSgweDEzZDMsIDB4MzM2MiksIC5kcml2
ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiAJeyBVU0JfREVWSUNFKDB4MGNmMywgMHhlMDA0
KSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgwOTMw
LCAweDAyMTkpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQogCXsgVVNCX0RFVklD
RSgweDA0ODksIDB4ZTA1NyksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCisJeyBV
U0JfREVWSUNFKDB4MTNkMywgMHgzMzkzKSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9
LA0KKwl7IFVTQl9ERVZJQ0UoMHgwNDg5LCAweGUwNGUpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9B
VEgzMDEyIH0sDQorCXsgVVNCX0RFVklDRSgweDA0ODksIDB4ZTA1NiksIC5kcml2ZXJfaW5mbyA9
IEJUVVNCX0FUSDMwMTIgfSwNCiANCiAJLyogQXRoZXJvcyBBUjVCQlUyMiB3aXRoIHNmbGFzaCBm
aXJtd2FyZSAqLw0KIAl7IFVTQl9ERVZJQ0UoMHgwNDg5LCAweEUwM0MpLCAuZHJpdmVyX2luZm8g
PSBCVFVTQl9BVEgzMDEyIH0sDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibHVldG9vdGgvYnR1c2Iu
YyBiL2RyaXZlcnMvYmx1ZXRvb3RoL2J0dXNiLmMNCmluZGV4IGM1ZTQ0YTMuLjZiNzg0YjcgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL2JsdWV0b290aC9idHVzYi5jDQorKysgYi9kcml2ZXJzL2JsdWV0
b290aC9idHVzYi5jDQpAQCAtMTM5LDE0ICsxMzksMjMgQEAgc3RhdGljIHN0cnVjdCB1c2JfZGV2
aWNlX2lkIGJsYWNrbGlzdF90YWJsZVtdID0gew0KIAl7IFVTQl9ERVZJQ0UoMHgwM2YwLCAweDMx
MWQpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9JR05PUkUgfSwNCiANCiAJLyogQXRoZXJvcyAzMDEy
IHdpdGggc2ZsYXNoIGZpcm13YXJlICovDQorCXsgVVNCX0RFVklDRSgweDBjZjMsIDB4MDAzNiks
IC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiAJeyBVU0JfREVWSUNFKDB4MGNmMywg
MHgzMDA0KSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KKwl7IFVTQl9ERVZJQ0Uo
MHgwY2YzLCAweDMwMDgpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQogCXsgVVNC
X0RFVklDRSgweDBjZjMsIDB4MzExZCksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwN
CisJeyBVU0JfREVWSUNFKDB4MGNmMywgMHg4MTdhKSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRI
MzAxMiB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgxM2QzLCAweDMzNzUpLCAuZHJpdmVyX2luZm8gPSBC
VFVTQl9BVEgzMDEyIH0sDQorCXsgVVNCX0RFVklDRSgweDA0Y2EsIDB4MzAwNCksIC5kcml2ZXJf
aW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiAJeyBVU0JfREVWSUNFKDB4MDRjYSwgMHgzMDA1KSwg
LmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KKwl7IFVTQl9ERVZJQ0UoMHgwNGNhLCAw
eDMwMDYpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQorCXsgVVNCX0RFVklDRSgw
eDA0Y2EsIDB4MzAwOCksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCiAJeyBVU0Jf
REVWSUNFKDB4MTNkMywgMHgzMzYyKSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0K
IAl7IFVTQl9ERVZJQ0UoMHgwY2YzLCAweGUwMDQpLCAuZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgz
MDEyIH0sDQogCXsgVVNCX0RFVklDRSgweDA5MzAsIDB4MDIxOSksIC5kcml2ZXJfaW5mbyA9IEJU
VVNCX0FUSDMwMTIgfSwNCiAJeyBVU0JfREVWSUNFKDB4MDQ4OSwgMHhlMDU3KSwgLmRyaXZlcl9p
bmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KKwl7IFVTQl9ERVZJQ0UoMHgxM2QzLCAweDMzOTMpLCAu
ZHJpdmVyX2luZm8gPSBCVFVTQl9BVEgzMDEyIH0sDQorCXsgVVNCX0RFVklDRSgweDA0ODksIDB4
ZTA0ZSksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0FUSDMwMTIgfSwNCisJeyBVU0JfREVWSUNFKDB4
MDQ4OSwgMHhlMDU2KSwgLmRyaXZlcl9pbmZvID0gQlRVU0JfQVRIMzAxMiB9LA0KIA0KIAkvKiBB
dGhlcm9zIEFSNUJCVTEyIHdpdGggc2ZsYXNoIGZpcm13YXJlICovDQogCXsgVVNCX0RFVklDRSgw
eDA0ODksIDB4ZTAyYyksIC5kcml2ZXJfaW5mbyA9IEJUVVNCX0lHTk9SRSB9LA0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvY2hhci92aXJ0aW9fY29uc29sZS5jIGIvZHJpdmVycy9jaGFyL3ZpcnRpb19j
b25zb2xlLmMNCmluZGV4IDc3OTVkMWUuLmQ1YWU3MzYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2No
YXIvdmlydGlvX2NvbnNvbGUuYw0KKysrIGIvZHJpdmVycy9jaGFyL3ZpcnRpb19jb25zb2xlLmMN
CkBAIC0xMzEsNyArMTMxLDggQEAgc3RydWN0IHBvcnRzX2RldmljZSB7DQogCXNwaW5sb2NrX3Qg
cG9ydHNfbG9jazsNCiANCiAJLyogVG8gcHJvdGVjdCB0aGUgdnEgb3BlcmF0aW9ucyBmb3IgdGhl
IGNvbnRyb2wgY2hhbm5lbCAqLw0KLQlzcGlubG9ja190IGN2cV9sb2NrOw0KKwlzcGlubG9ja190
IGNfaXZxX2xvY2s7DQorCXNwaW5sb2NrX3QgY19vdnFfbG9jazsNCiANCiAJLyogVGhlIGN1cnJl
bnQgY29uZmlnIHNwYWNlIGlzIHN0b3JlZCBoZXJlICovDQogCXN0cnVjdCB2aXJ0aW9fY29uc29s
ZV9jb25maWcgY29uZmlnOw0KQEAgLTQ1NywxMSArNDU4LDE0IEBAIHN0YXRpYyBzc2l6ZV90IF9f
c2VuZF9jb250cm9sX21zZyhzdHJ1Y3QgcG9ydHNfZGV2aWNlICpwb3J0ZGV2LCB1MzIgcG9ydF9p
ZCwNCiAJdnEgPSBwb3J0ZGV2LT5jX292cTsNCiANCiAJc2dfaW5pdF9vbmUoc2csICZjcGt0LCBz
aXplb2YoY3BrdCkpOw0KKw0KKwlzcGluX2xvY2soJnBvcnRkZXYtPmNfb3ZxX2xvY2spOw0KIAlp
ZiAodmlydHF1ZXVlX2FkZF9idWYodnEsIHNnLCAxLCAwLCAmY3BrdCkgPj0gMCkgew0KIAkJdmly
dHF1ZXVlX2tpY2sodnEpOw0KIAkJd2hpbGUgKCF2aXJ0cXVldWVfZ2V0X2J1Zih2cSwgJmxlbikp
DQogCQkJY3B1X3JlbGF4KCk7DQogCX0NCisJc3Bpbl91bmxvY2soJnBvcnRkZXYtPmNfb3ZxX2xv
Y2spOw0KIAlyZXR1cm4gMDsNCiB9DQogDQpAQCAtMTQ2NiwyMyArMTQ3MCwyMyBAQCBzdGF0aWMg
dm9pZCBjb250cm9sX3dvcmtfaGFuZGxlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQogCXBv
cnRkZXYgPSBjb250YWluZXJfb2Yod29yaywgc3RydWN0IHBvcnRzX2RldmljZSwgY29udHJvbF93
b3JrKTsNCiAJdnEgPSBwb3J0ZGV2LT5jX2l2cTsNCiANCi0Jc3Bpbl9sb2NrKCZwb3J0ZGV2LT5j
dnFfbG9jayk7DQorCXNwaW5fbG9jaygmcG9ydGRldi0+Y19pdnFfbG9jayk7DQogCXdoaWxlICgo
YnVmID0gdmlydHF1ZXVlX2dldF9idWYodnEsICZsZW4pKSkgew0KLQkJc3Bpbl91bmxvY2soJnBv
cnRkZXYtPmN2cV9sb2NrKTsNCisJCXNwaW5fdW5sb2NrKCZwb3J0ZGV2LT5jX2l2cV9sb2NrKTsN
CiANCiAJCWJ1Zi0+bGVuID0gbGVuOw0KIAkJYnVmLT5vZmZzZXQgPSAwOw0KIA0KIAkJaGFuZGxl
X2NvbnRyb2xfbWVzc2FnZShwb3J0ZGV2LCBidWYpOw0KIA0KLQkJc3Bpbl9sb2NrKCZwb3J0ZGV2
LT5jdnFfbG9jayk7DQorCQlzcGluX2xvY2soJnBvcnRkZXYtPmNfaXZxX2xvY2spOw0KIAkJaWYg
KGFkZF9pbmJ1Zihwb3J0ZGV2LT5jX2l2cSwgYnVmKSA8IDApIHsNCiAJCQlkZXZfd2FybigmcG9y
dGRldi0+dmRldi0+ZGV2LA0KIAkJCQkgIkVycm9yIGFkZGluZyBidWZmZXIgdG8gcXVldWVcbiIp
Ow0KIAkJCWZyZWVfYnVmKGJ1Zik7DQogCQl9DQogCX0NCi0Jc3Bpbl91bmxvY2soJnBvcnRkZXYt
PmN2cV9sb2NrKTsNCisJc3Bpbl91bmxvY2soJnBvcnRkZXYtPmNfaXZxX2xvY2spOw0KIH0NCiAN
CiBzdGF0aWMgdm9pZCBvdXRfaW50cihzdHJ1Y3QgdmlydHF1ZXVlICp2cSkNCkBAIC0xNzIxLDEw
ICsxNzI1LDEyIEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IHZpcnRjb25zX3Byb2JlKHN0cnVjdCB2
aXJ0aW9fZGV2aWNlICp2ZGV2KQ0KIAlpZiAobXVsdGlwb3J0KSB7DQogCQl1bnNpZ25lZCBpbnQg
bnJfYWRkZWRfYnVmczsNCiANCi0JCXNwaW5fbG9ja19pbml0KCZwb3J0ZGV2LT5jdnFfbG9jayk7
DQorCQlzcGluX2xvY2tfaW5pdCgmcG9ydGRldi0+Y19pdnFfbG9jayk7DQorCQlzcGluX2xvY2tf
aW5pdCgmcG9ydGRldi0+Y19vdnFfbG9jayk7DQogCQlJTklUX1dPUksoJnBvcnRkZXYtPmNvbnRy
b2xfd29yaywgJmNvbnRyb2xfd29ya19oYW5kbGVyKTsNCiANCi0JCW5yX2FkZGVkX2J1ZnMgPSBm
aWxsX3F1ZXVlKHBvcnRkZXYtPmNfaXZxLCAmcG9ydGRldi0+Y3ZxX2xvY2spOw0KKwkJbnJfYWRk
ZWRfYnVmcyA9IGZpbGxfcXVldWUocG9ydGRldi0+Y19pdnEsDQorCQkJCQkgICAmcG9ydGRldi0+
Y19pdnFfbG9jayk7DQogCQlpZiAoIW5yX2FkZGVkX2J1ZnMpIHsNCiAJCQlkZXZfZXJyKCZ2ZGV2
LT5kZXYsDQogCQkJCSJFcnJvciBhbGxvY2F0aW5nIGJ1ZmZlcnMgZm9yIGNvbnRyb2wgcXVldWVc
biIpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZWlzYS9wY2lfZWlzYS5jIGIvZHJpdmVycy9laXNh
L3BjaV9laXNhLmMNCmluZGV4IGNkYWUyMDcuLmQ0Y2Q1NmEgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L2Vpc2EvcGNpX2Vpc2EuYw0KKysrIGIvZHJpdmVycy9laXNhL3BjaV9laXNhLmMNCkBAIC0xOSw4
ICsxOSw3IEBADQogLyogVGhlcmUgaXMgb25seSAqb25lKiBwY2lfZWlzYSBkZXZpY2UgcGVyIG1h
Y2hpbmUsIHJpZ2h0ID8gKi8NCiBzdGF0aWMgc3RydWN0IGVpc2Ffcm9vdF9kZXZpY2UgcGNpX2Vp
c2Ffcm9vdDsNCiANCi1zdGF0aWMgaW50IF9faW5pdCBwY2lfZWlzYV9pbml0KHN0cnVjdCBwY2lf
ZGV2ICpwZGV2LA0KLQkJCQljb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqZW50KQ0KK3N0YXRp
YyBpbnQgX19pbml0IHBjaV9laXNhX2luaXQoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQogew0KIAlp
bnQgcmM7DQogDQpAQCAtNDUsMjIgKzQ0LDI2IEBAIHN0YXRpYyBpbnQgX19pbml0IHBjaV9laXNh
X2luaXQoc3RydWN0IHBjaV9kZXYgKnBkZXYsDQogCXJldHVybiAwOw0KIH0NCiANCi1zdGF0aWMg
c3RydWN0IHBjaV9kZXZpY2VfaWQgcGNpX2Vpc2FfcGNpX3RibFtdID0gew0KLQl7IFBDSV9BTllf
SUQsIFBDSV9BTllfSUQsIFBDSV9BTllfSUQsIFBDSV9BTllfSUQsDQotCSAgUENJX0NMQVNTX0JS
SURHRV9FSVNBIDw8IDgsIDB4ZmZmZjAwLCAwIH0sDQotCXsgMCwgfQ0KLX07DQorLyoNCisgKiBX
ZSBoYXZlIHRvIGNhbGwgcGNpX2Vpc2FfaW5pdF9lYXJseSgpIGJlZm9yZSBwbnBhY3BpX2luaXQo
KS9pc2FwbnBfaW5pdCgpLg0KKyAqICAgT3RoZXJ3aXNlIHBucCByZXNvdXJjZSB3aWxsIGdldCBl
bmFibGVkIGVhcmx5IGFuZCBjb3VsZCBwcmV2ZW50IGVpc2ENCisgKiAgIHRvIGJlIGluaXRpYWxp
emVkLg0KKyAqIEFsc28gbmVlZCB0byBtYWtlIHN1cmUgcGNpX2Vpc2FfaW5pdF9lYXJseSgpIGlz
IGNhbGxlZCBhZnRlcg0KKyAqIHg4Ni9wY2lfc3Vic3lzX2luaXQoKS4NCisgKiBTbyBuZWVkIHRv
IHVzZSBzdWJzeXNfaW5pdGNhbGxfc3luYyB3aXRoIGl0Lg0KKyAqLw0KK3N0YXRpYyBpbnQgX19p
bml0IHBjaV9laXNhX2luaXRfZWFybHkodm9pZCkNCit7DQorCXN0cnVjdCBwY2lfZGV2ICpkZXYg
PSBOVUxMOw0KKwlpbnQgcmV0Ow0KIA0KLXN0YXRpYyBzdHJ1Y3QgcGNpX2RyaXZlciBfX3JlZmRh
dGEgcGNpX2Vpc2FfZHJpdmVyID0gew0KLQkubmFtZQkJPSAicGNpX2Vpc2EiLA0KLQkuaWRfdGFi
bGUJPSBwY2lfZWlzYV9wY2lfdGJsLA0KLQkucHJvYmUJCT0gcGNpX2Vpc2FfaW5pdCwNCi19Ow0K
Kwlmb3JfZWFjaF9wY2lfZGV2KGRldikNCisJCWlmICgoZGV2LT5jbGFzcyA+PiA4KSA9PSBQQ0lf
Q0xBU1NfQlJJREdFX0VJU0EpIHsNCisJCQlyZXQgPSBwY2lfZWlzYV9pbml0KGRldik7DQorCQkJ
aWYgKHJldCkNCisJCQkJcmV0dXJuIHJldDsNCisJCX0NCiANCi1zdGF0aWMgaW50IF9faW5pdCBw
Y2lfZWlzYV9pbml0X21vZHVsZSAodm9pZCkNCi17DQotCXJldHVybiBwY2lfcmVnaXN0ZXJfZHJp
dmVyICgmcGNpX2Vpc2FfZHJpdmVyKTsNCisJcmV0dXJuIDA7DQogfQ0KLQ0KLWRldmljZV9pbml0
Y2FsbChwY2lfZWlzYV9pbml0X21vZHVsZSk7DQotTU9EVUxFX0RFVklDRV9UQUJMRShwY2ksIHBj
aV9laXNhX3BjaV90YmwpOw0KK3N1YnN5c19pbml0Y2FsbF9zeW5jKHBjaV9laXNhX2luaXRfZWFy
bHkpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaGlkL2hpZC1pZHMuaCBiL2RyaXZlcnMvaGlkL2hp
ZC1pZHMuaA0KaW5kZXggZTY2NWJkZi4uMDgwNzVmMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaGlk
L2hpZC1pZHMuaA0KKysrIGIvZHJpdmVycy9oaWQvaGlkLWlkcy5oDQpAQCAtNTM5LDYgKzUzOSw5
IEBADQogI2RlZmluZSBVU0JfVkVORE9SX0lEX01PTlRFUkVZCQkweDA1NjYNCiAjZGVmaW5lIFVT
Ql9ERVZJQ0VfSURfR0VOSVVTX0tCMjlFCTB4MzAwNA0KIA0KKyNkZWZpbmUgVVNCX1ZFTkRPUl9J
RF9NU0kJCTB4MTc3MA0KKyNkZWZpbmUgVVNCX0RFVklDRV9JRF9NU0lfR1g2ODBSX0xFRF9QQU5F
TAkweGZmMDANCisNCiAjZGVmaW5lIFVTQl9WRU5ET1JfSURfTkFUSU9OQUxfU0VNSUNPTkRVQ1RP
UiAweDA0MDANCiAjZGVmaW5lIFVTQl9ERVZJQ0VfSURfTl9TX0hBUk1PTlkJMHhjMzU5DQogDQpA
QCAtNjIxLDYgKzYyNCw5IEBADQogI2RlZmluZSBVU0JfREVWSUNFX0lEX1FVQU5UQV9PUFRJQ0FM
X1RPVUNICTB4MzAwMA0KICNkZWZpbmUgVVNCX0RFVklDRV9JRF9QSVhBUlRfSU1BR0lOR19JTkNf
T1BUSUNBTF9UT1VDSF9TQ1JFRU4JMHgzMDAxDQogDQorI2RlZmluZSBVU0JfVkVORE9SX0lEX1JF
QUxURUsJCTB4MGJkYQ0KKyNkZWZpbmUgVVNCX0RFVklDRV9JRF9SRUFMVEVLX1JFQURFUgkweDAx
NTINCisNCiAjZGVmaW5lIFVTQl9WRU5ET1JfSURfUk9DQ0FUCQkweDFlN2QNCiAjZGVmaW5lIFVT
Ql9ERVZJQ0VfSURfUk9DQ0FUX0FSVk8JMHgzMGQ0DQogI2RlZmluZSBVU0JfREVWSUNFX0lEX1JP
Q0NBVF9LT05FCTB4MmNlZA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaGlkL2hpZC1taWNyb3NvZnQu
YyBiL2RyaXZlcnMvaGlkL2hpZC1taWNyb3NvZnQuYw0KaW5kZXggMzg5OTk4OS4uMjU5YjlmNCAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvaGlkL2hpZC1taWNyb3NvZnQuYw0KKysrIGIvZHJpdmVycy9o
aWQvaGlkLW1pY3Jvc29mdC5jDQpAQCAtNDcsOSArNDcsOSBAQCBzdGF0aWMgX191OCAqbXNfcmVw
b3J0X2ZpeHVwKHN0cnVjdCBoaWRfZGV2aWNlICpoZGV2LCBfX3U4ICpyZGVzYywNCiAJCXJkZXNj
WzU1OV0gPSAweDQ1Ow0KIAl9DQogCS8qIHRoZSBzYW1lIGFzIGFib3ZlIChzL3VzYWdlL3BoeXNp
Y2FsLykgKi8NCi0JaWYgKChxdWlya3MgJiBNU19SREVTQ18zSykgJiYgKnJzaXplID09IDEwNiAm
Jg0KLQkJCSFtZW1jbXAoKGNoYXIgW10peyAweDE5LCAweDAwLCAweDI5LCAweGZmIH0sDQotCQkJ
CSZyZGVzY1s5NF0sIDQpKSB7DQorCWlmICgocXVpcmtzICYgTVNfUkRFU0NfM0spICYmICpyc2l6
ZSA9PSAxMDYgJiYgcmRlc2NbOTRdID09IDB4MTkgJiYNCisJCQlyZGVzY1s5NV0gPT0gMHgwMCAm
JiByZGVzY1s5Nl0gPT0gMHgyOSAmJg0KKwkJCXJkZXNjWzk3XSA9PSAweGZmKSB7DQogCQlyZGVz
Y1s5NF0gPSAweDM1Ow0KIAkJcmRlc2NbOTZdID0gMHg0NTsNCiAJfQ0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvaGlkL3VzYmhpZC9oaWQtcXVpcmtzLmMgYi9kcml2ZXJzL2hpZC91c2JoaWQvaGlkLXF1
aXJrcy5jDQppbmRleCBlMjZlZGRmLi45NmExZTBmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9oaWQv
dXNiaGlkL2hpZC1xdWlya3MuYw0KKysrIGIvZHJpdmVycy9oaWQvdXNiaGlkL2hpZC1xdWlya3Mu
Yw0KQEAgLTcxLDExICs3MSwxMyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGhpZF9ibGFja2xpc3Qg
ew0KIAl7IFVTQl9WRU5ET1JfSURfRk9STU9TQSwgVVNCX0RFVklDRV9JRF9GT1JNT1NBX0lSX1JF
Q0VJVkVSLCBISURfUVVJUktfTk9fSU5JVF9SRVBPUlRTIH0sDQogCXsgVVNCX1ZFTkRPUl9JRF9G
UkVFU0NBTEUsIFVTQl9ERVZJQ0VfSURfRlJFRVNDQUxFX01YMjgsIEhJRF9RVUlSS19OT0dFVCB9
LA0KIAl7IFVTQl9WRU5ET1JfSURfTUdFLCBVU0JfREVWSUNFX0lEX01HRV9VUFMsIEhJRF9RVUlS
S19OT0dFVCB9LA0KKwl7IFVTQl9WRU5ET1JfSURfTVNJLCBVU0JfREVWSUNFX0lEX01TSV9HWDY4
MFJfTEVEX1BBTkVMLCBISURfUVVJUktfTk9fSU5JVF9SRVBPUlRTIH0sDQogCXsgVVNCX1ZFTkRP
Ul9JRF9QSVhBUlQsIFVTQl9ERVZJQ0VfSURfUElYQVJUX09QVElDQUxfVE9VQ0hfU0NSRUVOLCBI
SURfUVVJUktfTk9fSU5JVF9SRVBPUlRTIH0sDQogCXsgVVNCX1ZFTkRPUl9JRF9QSVhBUlQsIFVT
Ql9ERVZJQ0VfSURfUElYQVJUX09QVElDQUxfVE9VQ0hfU0NSRUVOMSwgSElEX1FVSVJLX05PX0lO
SVRfUkVQT1JUUyB9LA0KIAl7IFVTQl9WRU5ET1JfSURfUElYQVJULCBVU0JfREVWSUNFX0lEX1BJ
WEFSVF9PUFRJQ0FMX1RPVUNIX1NDUkVFTjIsIEhJRF9RVUlSS19OT19JTklUX1JFUE9SVFMgfSwN
CiAJeyBVU0JfVkVORE9SX0lEX1BST0RJR0UsIFVTQl9ERVZJQ0VfSURfUFJPRElHRV9DT1JETEVT
UywgSElEX1FVSVJLX05PR0VUIH0sDQogCXsgVVNCX1ZFTkRPUl9JRF9RVUFOVEEsIFVTQl9ERVZJ
Q0VfSURfUElYQVJUX0lNQUdJTkdfSU5DX09QVElDQUxfVE9VQ0hfU0NSRUVOLCBISURfUVVJUktf
Tk9HRVQgfSwNCisJeyBVU0JfVkVORE9SX0lEX1JFQUxURUssIFVTQl9ERVZJQ0VfSURfUkVBTFRF
S19SRUFERVIsIEhJRF9RVUlSS19OT19JTklUX1JFUE9SVFMgfSwNCiAJeyBVU0JfVkVORE9SX0lE
X1NVTiwgVVNCX0RFVklDRV9JRF9SQVJJVEFOX0tWTV9ET05HTEUsIEhJRF9RVUlSS19OT0dFVCB9
LA0KIAl7IFVTQl9WRU5ET1JfSURfU1lNQk9MLCBVU0JfREVWSUNFX0lEX1NZTUJPTF9TQ0FOTkVS
XzEsIEhJRF9RVUlSS19OT0dFVCB9LA0KIAl7IFVTQl9WRU5ET1JfSURfU1lNQk9MLCBVU0JfREVW
SUNFX0lEX1NZTUJPTF9TQ0FOTkVSXzIsIEhJRF9RVUlSS19OT0dFVCB9LA0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXBvaWIvaXBvaWJfY20uYyBiL2RyaXZlcnMvaW5maW5p
YmFuZC91bHAvaXBvaWIvaXBvaWJfY20uYw0KaW5kZXggMDE0NTA0ZC4uMzc2Nzg1MyAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXBvaWIvaXBvaWJfY20uYw0KKysrIGIvZHJp
dmVycy9pbmZpbmliYW5kL3VscC9pcG9pYi9pcG9pYl9jbS5jDQpAQCAtNzU1LDkgKzc1NSwxMyBA
QCB2b2lkIGlwb2liX2NtX3NlbmQoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IHNrX2J1
ZmYgKnNrYiwgc3RydWN0IGlwb2liX2NtXw0KIAkJaWYgKCsrcHJpdi0+dHhfb3V0c3RhbmRpbmcg
PT0gaXBvaWJfc2VuZHFfc2l6ZSkgew0KIAkJCWlwb2liX2RiZyhwcml2LCAiVFggcmluZyAweCV4
IGZ1bGwsIHN0b3BwaW5nIGtlcm5lbCBuZXQgcXVldWVcbiIsDQogCQkJCSAgdHgtPnFwLT5xcF9u
dW0pOw0KLQkJCWlmIChpYl9yZXFfbm90aWZ5X2NxKHByaXYtPnNlbmRfY3EsIElCX0NRX05FWFRf
Q09NUCkpDQotCQkJCWlwb2liX3dhcm4ocHJpdiwgInJlcXVlc3Qgbm90aWZ5IG9uIHNlbmQgQ1Eg
ZmFpbGVkXG4iKTsNCiAJCQluZXRpZl9zdG9wX3F1ZXVlKGRldik7DQorCQkJcmMgPSBpYl9yZXFf
bm90aWZ5X2NxKHByaXYtPnNlbmRfY3EsDQorCQkJCUlCX0NRX05FWFRfQ09NUCB8IElCX0NRX1JF
UE9SVF9NSVNTRURfRVZFTlRTKTsNCisJCQlpZiAocmMgPCAwKQ0KKwkJCQlpcG9pYl93YXJuKHBy
aXYsICJyZXF1ZXN0IG5vdGlmeSBvbiBzZW5kIENRIGZhaWxlZFxuIik7DQorCQkJZWxzZSBpZiAo
cmMpDQorCQkJCWlwb2liX3NlbmRfY29tcF9oYW5kbGVyKHByaXYtPnNlbmRfY3EsIGRldik7DQog
CQl9DQogCX0NCiB9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9pb21tdS9hbWRfaW9tbXUuYyBiL2Ry
aXZlcnMvaW9tbXUvYW1kX2lvbW11LmMNCmluZGV4IDBmMDc0ZTAuLjA3Y2IxYTYgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL2lvbW11L2FtZF9pb21tdS5jDQorKysgYi9kcml2ZXJzL2lvbW11L2FtZF9p
b21tdS5jDQpAQCAtMTg3NCwxNiArMTg3NCwxNiBAQCBzdGF0aWMgaW50IGRldmljZV9jaGFuZ2Vf
bm90aWZpZXIoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpuYiwNCiANCiAJCS8qIGFsbG9jYXRlIGEg
cHJvdGVjdGlvbiBkb21haW4gaWYgYSBkZXZpY2UgaXMgYWRkZWQgKi8NCiAJCWRtYV9kb21haW4g
PSBmaW5kX3Byb3RlY3Rpb25fZG9tYWluKGRldmlkKTsNCi0JCWlmIChkbWFfZG9tYWluKQ0KLQkJ
CWdvdG8gb3V0Ow0KLQkJZG1hX2RvbWFpbiA9IGRtYV9vcHNfZG9tYWluX2FsbG9jKCk7DQotCQlp
ZiAoIWRtYV9kb21haW4pDQotCQkJZ290byBvdXQ7DQotCQlkbWFfZG9tYWluLT50YXJnZXRfZGV2
ID0gZGV2aWQ7DQotDQotCQlzcGluX2xvY2tfaXJxc2F2ZSgmaW9tbXVfcGRfbGlzdF9sb2NrLCBm
bGFncyk7DQotCQlsaXN0X2FkZF90YWlsKCZkbWFfZG9tYWluLT5saXN0LCAmaW9tbXVfcGRfbGlz
dCk7DQotCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZpb21tdV9wZF9saXN0X2xvY2ssIGZsYWdz
KTsNCisJCWlmICghZG1hX2RvbWFpbikgew0KKwkJCWRtYV9kb21haW4gPSBkbWFfb3BzX2RvbWFp
bl9hbGxvYygpOw0KKwkJCWlmICghZG1hX2RvbWFpbikNCisJCQkJZ290byBvdXQ7DQorCQkJZG1h
X2RvbWFpbi0+dGFyZ2V0X2RldiA9IGRldmlkOw0KKw0KKwkJCXNwaW5fbG9ja19pcnFzYXZlKCZp
b21tdV9wZF9saXN0X2xvY2ssIGZsYWdzKTsNCisJCQlsaXN0X2FkZF90YWlsKCZkbWFfZG9tYWlu
LT5saXN0LCAmaW9tbXVfcGRfbGlzdCk7DQorCQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaW9t
bXVfcGRfbGlzdF9sb2NrLCBmbGFncyk7DQorCQl9DQogDQogCQlkZXYtPmFyY2hkYXRhLmRtYV9v
cHMgPSAmYW1kX2lvbW11X2RtYV9vcHM7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvYm9u
ZGluZy9ib25kX21haW4uYyBiL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMNCmluZGV4
IDYzZTNjNDcuLmZjMDdmOTAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRf
bWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfbWFpbi5jDQpAQCAtMTkzNCwx
MiArMTkzNCwxMSBAQCBpbnQgYm9uZF9yZWxlYXNlKHN0cnVjdCBuZXRfZGV2aWNlICpib25kX2Rl
diwgc3RydWN0IG5ldF9kZXZpY2UgKnNsYXZlX2RldikNCiAJCXJldHVybiAtRUlOVkFMOw0KIAl9
DQogDQorCXdyaXRlX3VubG9ja19iaCgmYm9uZC0+bG9jayk7DQogCS8qIHVucmVnaXN0ZXIgcnhf
aGFuZGxlciBlYXJseSBzbyBib25kX2hhbmRsZV9mcmFtZSB3b3VsZG4ndCBiZSBjYWxsZWQNCiAJ
ICogZm9yIHRoaXMgc2xhdmUgYW55bW9yZS4NCiAJICovDQogCW5ldGRldl9yeF9oYW5kbGVyX3Vu
cmVnaXN0ZXIoc2xhdmVfZGV2KTsNCi0Jd3JpdGVfdW5sb2NrX2JoKCZib25kLT5sb2NrKTsNCi0J
c3luY2hyb25pemVfbmV0KCk7DQogCXdyaXRlX2xvY2tfYmgoJmJvbmQtPmxvY2spOw0KIA0KIAlp
ZiAoIWJvbmQtPnBhcmFtcy5mYWlsX292ZXJfbWFjKSB7DQpAQCAtMzQyMiw2ICszNDIxLDI4IEBA
IHN0YXRpYyBpbnQgYm9uZF94bWl0X2hhc2hfcG9saWN5X2wyKHN0cnVjdCBza19idWZmICpza2Is
IGludCBjb3VudCkNCiANCiAvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIERldmljZSBlbnRy
eSBwb2ludHMgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovDQogDQorc3RhdGljIHZvaWQg
Ym9uZF93b3JrX2luaXRfYWxsKHN0cnVjdCBib25kaW5nICpib25kKQ0KK3sNCisJSU5JVF9ERUxB
WUVEX1dPUksoJmJvbmQtPm1jYXN0X3dvcmssDQorCQkJICBib25kX3Jlc2VuZF9pZ21wX2pvaW5f
cmVxdWVzdHNfZGVsYXllZCk7DQorCUlOSVRfREVMQVlFRF9XT1JLKCZib25kLT5hbGJfd29yaywg
Ym9uZF9hbGJfbW9uaXRvcik7DQorCUlOSVRfREVMQVlFRF9XT1JLKCZib25kLT5taWlfd29yaywg
Ym9uZF9taWlfbW9uaXRvcik7DQorCWlmIChib25kLT5wYXJhbXMubW9kZSA9PSBCT05EX01PREVf
QUNUSVZFQkFDS1VQKQ0KKwkJSU5JVF9ERUxBWUVEX1dPUksoJmJvbmQtPmFycF93b3JrLCBib25k
X2FjdGl2ZWJhY2t1cF9hcnBfbW9uKTsNCisJZWxzZQ0KKwkJSU5JVF9ERUxBWUVEX1dPUksoJmJv
bmQtPmFycF93b3JrLCBib25kX2xvYWRiYWxhbmNlX2FycF9tb24pOw0KKwlJTklUX0RFTEFZRURf
V09SSygmYm9uZC0+YWRfd29yaywgYm9uZF8zYWRfc3RhdGVfbWFjaGluZV9oYW5kbGVyKTsNCit9
DQorDQorc3RhdGljIHZvaWQgYm9uZF93b3JrX2NhbmNlbF9hbGwoc3RydWN0IGJvbmRpbmcgKmJv
bmQpDQorew0KKwljYW5jZWxfZGVsYXllZF93b3JrX3N5bmMoJmJvbmQtPm1paV93b3JrKTsNCisJ
Y2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZib25kLT5hcnBfd29yayk7DQorCWNhbmNlbF9kZWxh
eWVkX3dvcmtfc3luYygmYm9uZC0+YWxiX3dvcmspOw0KKwljYW5jZWxfZGVsYXllZF93b3JrX3N5
bmMoJmJvbmQtPmFkX3dvcmspOw0KKwljYW5jZWxfZGVsYXllZF93b3JrX3N5bmMoJmJvbmQtPm1j
YXN0X3dvcmspOw0KK30NCisNCiBzdGF0aWMgaW50IGJvbmRfb3BlbihzdHJ1Y3QgbmV0X2Rldmlj
ZSAqYm9uZF9kZXYpDQogew0KIAlzdHJ1Y3QgYm9uZGluZyAqYm9uZCA9IG5ldGRldl9wcml2KGJv
bmRfZGV2KTsNCkBAIC0zNDQ0LDQxICszNDY1LDI3IEBAIHN0YXRpYyBpbnQgYm9uZF9vcGVuKHN0
cnVjdCBuZXRfZGV2aWNlICpib25kX2RldikNCiAJfQ0KIAlyZWFkX3VubG9jaygmYm9uZC0+bG9j
ayk7DQogDQotCUlOSVRfREVMQVlFRF9XT1JLKCZib25kLT5tY2FzdF93b3JrLCBib25kX3Jlc2Vu
ZF9pZ21wX2pvaW5fcmVxdWVzdHNfZGVsYXllZCk7DQorCWJvbmRfd29ya19pbml0X2FsbChib25k
KTsNCiANCiAJaWYgKGJvbmRfaXNfbGIoYm9uZCkpIHsNCiAJCS8qIGJvbmRfYWxiX2luaXRpYWxp
emUgbXVzdCBiZSBjYWxsZWQgYmVmb3JlIHRoZSB0aW1lcg0KIAkJICogaXMgc3RhcnRlZC4NCiAJ
CSAqLw0KLQkJaWYgKGJvbmRfYWxiX2luaXRpYWxpemUoYm9uZCwgKGJvbmQtPnBhcmFtcy5tb2Rl
ID09IEJPTkRfTU9ERV9BTEIpKSkgew0KLQkJCS8qIHNvbWV0aGluZyB3ZW50IHdyb25nIC0gZmFp
bCB0aGUgb3BlbiBvcGVyYXRpb24gKi8NCisJCWlmIChib25kX2FsYl9pbml0aWFsaXplKGJvbmQs
IChib25kLT5wYXJhbXMubW9kZSA9PSBCT05EX01PREVfQUxCKSkpDQogCQkJcmV0dXJuIC1FTk9N
RU07DQotCQl9DQotDQotCQlJTklUX0RFTEFZRURfV09SSygmYm9uZC0+YWxiX3dvcmssIGJvbmRf
YWxiX21vbml0b3IpOw0KIAkJcXVldWVfZGVsYXllZF93b3JrKGJvbmQtPndxLCAmYm9uZC0+YWxi
X3dvcmssIDApOw0KIAl9DQogDQotCWlmIChib25kLT5wYXJhbXMubWlpbW9uKSB7ICAvKiBsaW5r
IGNoZWNrIGludGVydmFsLCBpbiBtaWxsaXNlY29uZHMuICovDQotCQlJTklUX0RFTEFZRURfV09S
SygmYm9uZC0+bWlpX3dvcmssIGJvbmRfbWlpX21vbml0b3IpOw0KKwlpZiAoYm9uZC0+cGFyYW1z
Lm1paW1vbikgIC8qIGxpbmsgY2hlY2sgaW50ZXJ2YWwsIGluIG1pbGxpc2Vjb25kcy4gKi8NCiAJ
CXF1ZXVlX2RlbGF5ZWRfd29yayhib25kLT53cSwgJmJvbmQtPm1paV93b3JrLCAwKTsNCi0JfQ0K
IA0KIAlpZiAoYm9uZC0+cGFyYW1zLmFycF9pbnRlcnZhbCkgeyAgLyogYXJwIGludGVydmFsLCBp
biBtaWxsaXNlY29uZHMuICovDQotCQlpZiAoYm9uZC0+cGFyYW1zLm1vZGUgPT0gQk9ORF9NT0RF
X0FDVElWRUJBQ0tVUCkNCi0JCQlJTklUX0RFTEFZRURfV09SSygmYm9uZC0+YXJwX3dvcmssDQot
CQkJCQkgIGJvbmRfYWN0aXZlYmFja3VwX2FycF9tb24pOw0KLQkJZWxzZQ0KLQkJCUlOSVRfREVM
QVlFRF9XT1JLKCZib25kLT5hcnBfd29yaywNCi0JCQkJCSAgYm9uZF9sb2FkYmFsYW5jZV9hcnBf
bW9uKTsNCi0NCiAJCXF1ZXVlX2RlbGF5ZWRfd29yayhib25kLT53cSwgJmJvbmQtPmFycF93b3Jr
LCAwKTsNCiAJCWlmIChib25kLT5wYXJhbXMuYXJwX3ZhbGlkYXRlKQ0KIAkJCWJvbmQtPnJlY3Zf
cHJvYmUgPSBib25kX2FycF9yY3Y7DQogCX0NCiANCiAJaWYgKGJvbmQtPnBhcmFtcy5tb2RlID09
IEJPTkRfTU9ERV84MDIzQUQpIHsNCi0JCUlOSVRfREVMQVlFRF9XT1JLKCZib25kLT5hZF93b3Jr
LCBib25kXzNhZF9zdGF0ZV9tYWNoaW5lX2hhbmRsZXIpOw0KIAkJcXVldWVfZGVsYXllZF93b3Jr
KGJvbmQtPndxLCAmYm9uZC0+YWRfd29yaywgMCk7DQogCQkvKiByZWdpc3RlciB0byByZWNlaXZl
IExBQ1BEVXMgKi8NCiAJCWJvbmQtPnJlY3ZfcHJvYmUgPSBib25kXzNhZF9sYWNwZHVfcmVjdjsN
CkBAIC0zNDkzLDM0ICszNTAwLDEwIEBAIHN0YXRpYyBpbnQgYm9uZF9jbG9zZShzdHJ1Y3QgbmV0
X2RldmljZSAqYm9uZF9kZXYpDQogCXN0cnVjdCBib25kaW5nICpib25kID0gbmV0ZGV2X3ByaXYo
Ym9uZF9kZXYpOw0KIA0KIAl3cml0ZV9sb2NrX2JoKCZib25kLT5sb2NrKTsNCi0NCiAJYm9uZC0+
c2VuZF9wZWVyX25vdGlmID0gMDsNCi0NCiAJd3JpdGVfdW5sb2NrX2JoKCZib25kLT5sb2NrKTsN
CiANCi0JaWYgKGJvbmQtPnBhcmFtcy5taWltb24pIHsgIC8qIGxpbmsgY2hlY2sgaW50ZXJ2YWws
IGluIG1pbGxpc2Vjb25kcy4gKi8NCi0JCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmYm9uZC0+
bWlpX3dvcmspOw0KLQl9DQotDQotCWlmIChib25kLT5wYXJhbXMuYXJwX2ludGVydmFsKSB7ICAv
KiBhcnAgaW50ZXJ2YWwsIGluIG1pbGxpc2Vjb25kcy4gKi8NCi0JCWNhbmNlbF9kZWxheWVkX3dv
cmtfc3luYygmYm9uZC0+YXJwX3dvcmspOw0KLQl9DQotDQotCXN3aXRjaCAoYm9uZC0+cGFyYW1z
Lm1vZGUpIHsNCi0JY2FzZSBCT05EX01PREVfODAyM0FEOg0KLQkJY2FuY2VsX2RlbGF5ZWRfd29y
a19zeW5jKCZib25kLT5hZF93b3JrKTsNCi0JCWJyZWFrOw0KLQljYXNlIEJPTkRfTU9ERV9UTEI6
DQotCWNhc2UgQk9ORF9NT0RFX0FMQjoNCi0JCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmYm9u
ZC0+YWxiX3dvcmspOw0KLQkJYnJlYWs7DQotCWRlZmF1bHQ6DQotCQlicmVhazsNCi0JfQ0KLQ0K
LQlpZiAoZGVsYXllZF93b3JrX3BlbmRpbmcoJmJvbmQtPm1jYXN0X3dvcmspKQ0KLQkJY2FuY2Vs
X2RlbGF5ZWRfd29ya19zeW5jKCZib25kLT5tY2FzdF93b3JrKTsNCi0NCisJYm9uZF93b3JrX2Nh
bmNlbF9hbGwoYm9uZCk7DQogCWlmIChib25kX2lzX2xiKGJvbmQpKSB7DQogCQkvKiBNdXN0IGJl
IGNhbGxlZCBvbmx5IGFmdGVyIGFsbA0KIAkJICogc2xhdmVzIGhhdmUgYmVlbiByZWxlYXNlZA0K
QEAgLTQzNjQsMjYgKzQzNDcsNiBAQCBzdGF0aWMgdm9pZCBib25kX3NldHVwKHN0cnVjdCBuZXRf
ZGV2aWNlICpib25kX2RldikNCiAJYm9uZF9kZXYtPmZlYXR1cmVzIHw9IGJvbmRfZGV2LT5od19m
ZWF0dXJlczsNCiB9DQogDQotc3RhdGljIHZvaWQgYm9uZF93b3JrX2NhbmNlbF9hbGwoc3RydWN0
IGJvbmRpbmcgKmJvbmQpDQotew0KLQlpZiAoYm9uZC0+cGFyYW1zLm1paW1vbiAmJiBkZWxheWVk
X3dvcmtfcGVuZGluZygmYm9uZC0+bWlpX3dvcmspKQ0KLQkJY2FuY2VsX2RlbGF5ZWRfd29ya19z
eW5jKCZib25kLT5taWlfd29yayk7DQotDQotCWlmIChib25kLT5wYXJhbXMuYXJwX2ludGVydmFs
ICYmIGRlbGF5ZWRfd29ya19wZW5kaW5nKCZib25kLT5hcnBfd29yaykpDQotCQljYW5jZWxfZGVs
YXllZF93b3JrX3N5bmMoJmJvbmQtPmFycF93b3JrKTsNCi0NCi0JaWYgKGJvbmQtPnBhcmFtcy5t
b2RlID09IEJPTkRfTU9ERV9BTEIgJiYNCi0JICAgIGRlbGF5ZWRfd29ya19wZW5kaW5nKCZib25k
LT5hbGJfd29yaykpDQotCQljYW5jZWxfZGVsYXllZF93b3JrX3N5bmMoJmJvbmQtPmFsYl93b3Jr
KTsNCi0NCi0JaWYgKGJvbmQtPnBhcmFtcy5tb2RlID09IEJPTkRfTU9ERV84MDIzQUQgJiYNCi0J
ICAgIGRlbGF5ZWRfd29ya19wZW5kaW5nKCZib25kLT5hZF93b3JrKSkNCi0JCWNhbmNlbF9kZWxh
eWVkX3dvcmtfc3luYygmYm9uZC0+YWRfd29yayk7DQotDQotCWlmIChkZWxheWVkX3dvcmtfcGVu
ZGluZygmYm9uZC0+bWNhc3Rfd29yaykpDQotCQljYW5jZWxfZGVsYXllZF93b3JrX3N5bmMoJmJv
bmQtPm1jYXN0X3dvcmspOw0KLX0NCi0NCiAvKg0KICogRGVzdHJveSBhIGJvbmRpbmcgZGV2aWNl
Lg0KICogTXVzdCBiZSB1bmRlciBydG5sX2xvY2sgd2hlbiB0aGlzIGZ1bmN0aW9uIGlzIGNhbGxl
ZC4NCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfc3lzZnMuYyBiL2RyaXZl
cnMvbmV0L2JvbmRpbmcvYm9uZF9zeXNmcy5jDQppbmRleCBhMDNmZGU5Li44ZWQ0OGMyIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX3N5c2ZzLmMNCisrKyBiL2RyaXZlcnMv
bmV0L2JvbmRpbmcvYm9uZF9zeXNmcy5jDQpAQCAtMTg0LDYgKzE4NCwxMSBAQCBpbnQgYm9uZF9j
cmVhdGVfc2xhdmVfc3ltbGlua3Moc3RydWN0IG5ldF9kZXZpY2UgKm1hc3RlciwNCiAJc3ByaW50
ZihsaW5rbmFtZSwgInNsYXZlXyVzIiwgc2xhdmUtPm5hbWUpOw0KIAlyZXQgPSBzeXNmc19jcmVh
dGVfbGluaygmKG1hc3Rlci0+ZGV2LmtvYmopLCAmKHNsYXZlLT5kZXYua29iaiksDQogCQkJCWxp
bmtuYW1lKTsNCisNCisJLyogZnJlZSB0aGUgbWFzdGVyIGxpbmsgY3JlYXRlZCBlYXJsaWVyIGlu
IGNhc2Ugb2YgZXJyb3IgKi8NCisJaWYgKHJldCkNCisJCXN5c2ZzX3JlbW92ZV9saW5rKCYoc2xh
dmUtPmRldi5rb2JqKSwgIm1hc3RlciIpOw0KKw0KIAlyZXR1cm4gcmV0Ow0KIA0KIH0NCkBAIC01
MTQsNiArNTE5LDggQEAgc3RhdGljIHNzaXplX3QgYm9uZGluZ19zdG9yZV9hcnBfaW50ZXJ2YWwo
c3RydWN0IGRldmljZSAqZCwNCiAJaW50IG5ld192YWx1ZSwgcmV0ID0gY291bnQ7DQogCXN0cnVj
dCBib25kaW5nICpib25kID0gdG9fYm9uZChkKTsNCiANCisJaWYgKCFydG5sX3RyeWxvY2soKSkN
CisJCXJldHVybiByZXN0YXJ0X3N5c2NhbGwoKTsNCiAJaWYgKHNzY2FuZihidWYsICIlZCIsICZu
ZXdfdmFsdWUpICE9IDEpIHsNCiAJCXByX2VycigiJXM6IG5vIGFycF9pbnRlcnZhbCB2YWx1ZSBz
cGVjaWZpZWQuXG4iLA0KIAkJICAgICAgIGJvbmQtPmRldi0+bmFtZSk7DQpAQCAtNTIxLDcgKzUy
OCw3IEBAIHN0YXRpYyBzc2l6ZV90IGJvbmRpbmdfc3RvcmVfYXJwX2ludGVydmFsKHN0cnVjdCBk
ZXZpY2UgKmQsDQogCQlnb3RvIG91dDsNCiAJfQ0KIAlpZiAobmV3X3ZhbHVlIDwgMCkgew0KLQkJ
cHJfZXJyKCIlczogSW52YWxpZCBhcnBfaW50ZXJ2YWwgdmFsdWUgJWQgbm90IGluIHJhbmdlIDEt
JWQ7IHJlamVjdGVkLlxuIiwNCisJCXByX2VycigiJXM6IEludmFsaWQgYXJwX2ludGVydmFsIHZh
bHVlICVkIG5vdCBpbiByYW5nZSAwLSVkOyByZWplY3RlZC5cbiIsDQogCQkgICAgICAgYm9uZC0+
ZGV2LT5uYW1lLCBuZXdfdmFsdWUsIElOVF9NQVgpOw0KIAkJcmV0ID0gLUVJTlZBTDsNCiAJCWdv
dG8gb3V0Ow0KQEAgLTUzNiwxOCArNTQzLDE1IEBAIHN0YXRpYyBzc2l6ZV90IGJvbmRpbmdfc3Rv
cmVfYXJwX2ludGVydmFsKHN0cnVjdCBkZXZpY2UgKmQsDQogCXByX2luZm8oIiVzOiBTZXR0aW5n
IEFSUCBtb25pdG9yaW5nIGludGVydmFsIHRvICVkLlxuIiwNCiAJCWJvbmQtPmRldi0+bmFtZSwg
bmV3X3ZhbHVlKTsNCiAJYm9uZC0+cGFyYW1zLmFycF9pbnRlcnZhbCA9IG5ld192YWx1ZTsNCi0J
aWYgKGJvbmQtPnBhcmFtcy5taWltb24pIHsNCi0JCXByX2luZm8oIiVzOiBBUlAgbW9uaXRvcmlu
ZyBjYW5ub3QgYmUgdXNlZCB3aXRoIE1JSSBtb25pdG9yaW5nLiAlcyBEaXNhYmxpbmcgTUlJIG1v
bml0b3JpbmcuXG4iLA0KLQkJCWJvbmQtPmRldi0+bmFtZSwgYm9uZC0+ZGV2LT5uYW1lKTsNCi0J
CWJvbmQtPnBhcmFtcy5taWltb24gPSAwOw0KLQkJaWYgKGRlbGF5ZWRfd29ya19wZW5kaW5nKCZi
b25kLT5taWlfd29yaykpIHsNCi0JCQljYW5jZWxfZGVsYXllZF93b3JrKCZib25kLT5taWlfd29y
ayk7DQotCQkJZmx1c2hfd29ya3F1ZXVlKGJvbmQtPndxKTsNCisJaWYgKG5ld192YWx1ZSkgew0K
KwkJaWYgKGJvbmQtPnBhcmFtcy5taWltb24pIHsNCisJCQlwcl9pbmZvKCIlczogQVJQIG1vbml0
b3JpbmcgY2Fubm90IGJlIHVzZWQgd2l0aCBNSUkgbW9uaXRvcmluZy4gJXMgRGlzYWJsaW5nIE1J
SSBtb25pdG9yaW5nLlxuIiwNCisJCQkJYm9uZC0+ZGV2LT5uYW1lLCBib25kLT5kZXYtPm5hbWUp
Ow0KKwkJCWJvbmQtPnBhcmFtcy5taWltb24gPSAwOw0KIAkJfQ0KLQl9DQotCWlmICghYm9uZC0+
cGFyYW1zLmFycF90YXJnZXRzWzBdKSB7DQotCQlwcl9pbmZvKCIlczogQVJQIG1vbml0b3Jpbmcg
aGFzIGJlZW4gc2V0IHVwLCBidXQgbm8gQVJQIHRhcmdldHMgaGF2ZSBiZWVuIHNwZWNpZmllZC5c
biIsDQotCQkJYm9uZC0+ZGV2LT5uYW1lKTsNCisJCWlmICghYm9uZC0+cGFyYW1zLmFycF90YXJn
ZXRzWzBdKQ0KKwkJCXByX2luZm8oIiVzOiBBUlAgbW9uaXRvcmluZyBoYXMgYmVlbiBzZXQgdXAs
IGJ1dCBubyBBUlAgdGFyZ2V0cyBoYXZlIGJlZW4gc3BlY2lmaWVkLlxuIiwNCisJCQkJYm9uZC0+
ZGV2LT5uYW1lKTsNCiAJfQ0KIAlpZiAoYm9uZC0+ZGV2LT5mbGFncyAmIElGRl9VUCkgew0KIAkJ
LyogSWYgdGhlIGludGVyZmFjZSBpcyB1cCwgd2UgbWF5IG5lZWQgdG8gZmlyZSBvZmYNCkBAIC01
NTUsMTkgKzU1OSwxNSBAQCBzdGF0aWMgc3NpemVfdCBib25kaW5nX3N0b3JlX2FycF9pbnRlcnZh
bChzdHJ1Y3QgZGV2aWNlICpkLA0KIAkJICogdGltZXIgd2lsbCBnZXQgZmlyZWQgb2ZmIHdoZW4g
dGhlIG9wZW4gZnVuY3Rpb24NCiAJCSAqIGlzIGNhbGxlZC4NCiAJCSAqLw0KLQkJaWYgKCFkZWxh
eWVkX3dvcmtfcGVuZGluZygmYm9uZC0+YXJwX3dvcmspKSB7DQotCQkJaWYgKGJvbmQtPnBhcmFt
cy5tb2RlID09IEJPTkRfTU9ERV9BQ1RJVkVCQUNLVVApDQotCQkJCUlOSVRfREVMQVlFRF9XT1JL
KCZib25kLT5hcnBfd29yaywNCi0JCQkJCQkgIGJvbmRfYWN0aXZlYmFja3VwX2FycF9tb24pOw0K
LQkJCWVsc2UNCi0JCQkJSU5JVF9ERUxBWUVEX1dPUksoJmJvbmQtPmFycF93b3JrLA0KLQkJCQkJ
CSAgYm9uZF9sb2FkYmFsYW5jZV9hcnBfbW9uKTsNCi0NCisJCWlmICghbmV3X3ZhbHVlKSB7DQor
CQkJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZib25kLT5hcnBfd29yayk7DQorCQl9IGVsc2Ug
ew0KKwkJCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmYm9uZC0+bWlpX3dvcmspOw0KIAkJCXF1
ZXVlX2RlbGF5ZWRfd29yayhib25kLT53cSwgJmJvbmQtPmFycF93b3JrLCAwKTsNCiAJCX0NCiAJ
fQ0KLQ0KIG91dDoNCisJcnRubF91bmxvY2soKTsNCiAJcmV0dXJuIHJldDsNCiB9DQogc3RhdGlj
IERFVklDRV9BVFRSKGFycF9pbnRlcnZhbCwgU19JUlVHTyB8IFNfSVdVU1IsDQpAQCAtNzA3LDcg
KzcwNyw3IEBAIHN0YXRpYyBzc2l6ZV90IGJvbmRpbmdfc3RvcmVfZG93bmRlbGF5KHN0cnVjdCBk
ZXZpY2UgKmQsDQogCX0NCiAJaWYgKG5ld192YWx1ZSA8IDApIHsNCiAJCXByX2VycigiJXM6IElu
dmFsaWQgZG93biBkZWxheSB2YWx1ZSAlZCBub3QgaW4gcmFuZ2UgJWQtJWQ7IHJlamVjdGVkLlxu
IiwNCi0JCSAgICAgICBib25kLT5kZXYtPm5hbWUsIG5ld192YWx1ZSwgMSwgSU5UX01BWCk7DQor
CQkgICAgICAgYm9uZC0+ZGV2LT5uYW1lLCBuZXdfdmFsdWUsIDAsIElOVF9NQVgpOw0KIAkJcmV0
ID0gLUVJTlZBTDsNCiAJCWdvdG8gb3V0Ow0KIAl9IGVsc2Ugew0KQEAgLTc2Miw4ICs3NjIsOCBA
QCBzdGF0aWMgc3NpemVfdCBib25kaW5nX3N0b3JlX3VwZGVsYXkoc3RydWN0IGRldmljZSAqZCwN
CiAJCWdvdG8gb3V0Ow0KIAl9DQogCWlmIChuZXdfdmFsdWUgPCAwKSB7DQotCQlwcl9lcnIoIiVz
OiBJbnZhbGlkIGRvd24gZGVsYXkgdmFsdWUgJWQgbm90IGluIHJhbmdlICVkLSVkOyByZWplY3Rl
ZC5cbiIsDQotCQkgICAgICAgYm9uZC0+ZGV2LT5uYW1lLCBuZXdfdmFsdWUsIDEsIElOVF9NQVgp
Ow0KKwkJcHJfZXJyKCIlczogSW52YWxpZCB1cCBkZWxheSB2YWx1ZSAlZCBub3QgaW4gcmFuZ2Ug
JWQtJWQ7IHJlamVjdGVkLlxuIiwNCisJCSAgICAgICBib25kLT5kZXYtPm5hbWUsIG5ld192YWx1
ZSwgMCwgSU5UX01BWCk7DQogCQlyZXQgPSAtRUlOVkFMOw0KIAkJZ290byBvdXQ7DQogCX0gZWxz
ZSB7DQpAQCAtOTYzLDYgKzk2Myw4IEBAIHN0YXRpYyBzc2l6ZV90IGJvbmRpbmdfc3RvcmVfbWlp
bW9uKHN0cnVjdCBkZXZpY2UgKmQsDQogCWludCBuZXdfdmFsdWUsIHJldCA9IGNvdW50Ow0KIAlz
dHJ1Y3QgYm9uZGluZyAqYm9uZCA9IHRvX2JvbmQoZCk7DQogDQorCWlmICghcnRubF90cnlsb2Nr
KCkpDQorCQlyZXR1cm4gcmVzdGFydF9zeXNjYWxsKCk7DQogCWlmIChzc2NhbmYoYnVmLCAiJWQi
LCAmbmV3X3ZhbHVlKSAhPSAxKSB7DQogCQlwcl9lcnIoIiVzOiBubyBtaWltb24gdmFsdWUgc3Bl
Y2lmaWVkLlxuIiwNCiAJCSAgICAgICBib25kLT5kZXYtPm5hbWUpOw0KQEAgLTk3MSw1MCArOTcz
LDQzIEBAIHN0YXRpYyBzc2l6ZV90IGJvbmRpbmdfc3RvcmVfbWlpbW9uKHN0cnVjdCBkZXZpY2Ug
KmQsDQogCX0NCiAJaWYgKG5ld192YWx1ZSA8IDApIHsNCiAJCXByX2VycigiJXM6IEludmFsaWQg
bWlpbW9uIHZhbHVlICVkIG5vdCBpbiByYW5nZSAlZC0lZDsgcmVqZWN0ZWQuXG4iLA0KLQkJICAg
ICAgIGJvbmQtPmRldi0+bmFtZSwgbmV3X3ZhbHVlLCAxLCBJTlRfTUFYKTsNCisJCSAgICAgICBi
b25kLT5kZXYtPm5hbWUsIG5ld192YWx1ZSwgMCwgSU5UX01BWCk7DQogCQlyZXQgPSAtRUlOVkFM
Ow0KIAkJZ290byBvdXQ7DQotCX0gZWxzZSB7DQotCQlwcl9pbmZvKCIlczogU2V0dGluZyBNSUkg
bW9uaXRvcmluZyBpbnRlcnZhbCB0byAlZC5cbiIsDQotCQkJYm9uZC0+ZGV2LT5uYW1lLCBuZXdf
dmFsdWUpOw0KLQkJYm9uZC0+cGFyYW1zLm1paW1vbiA9IG5ld192YWx1ZTsNCi0JCWlmIChib25k
LT5wYXJhbXMudXBkZWxheSkNCi0JCQlwcl9pbmZvKCIlczogTm90ZTogVXBkYXRpbmcgdXBkZWxh
eSAodG8gJWQpIHNpbmNlIGl0IGlzIGEgbXVsdGlwbGUgb2YgdGhlIG1paW1vbiB2YWx1ZS5cbiIs
DQotCQkJCWJvbmQtPmRldi0+bmFtZSwNCi0JCQkJYm9uZC0+cGFyYW1zLnVwZGVsYXkgKiBib25k
LT5wYXJhbXMubWlpbW9uKTsNCi0JCWlmIChib25kLT5wYXJhbXMuZG93bmRlbGF5KQ0KLQkJCXBy
X2luZm8oIiVzOiBOb3RlOiBVcGRhdGluZyBkb3duZGVsYXkgKHRvICVkKSBzaW5jZSBpdCBpcyBh
IG11bHRpcGxlIG9mIHRoZSBtaWltb24gdmFsdWUuXG4iLA0KLQkJCQlib25kLT5kZXYtPm5hbWUs
DQotCQkJCWJvbmQtPnBhcmFtcy5kb3duZGVsYXkgKiBib25kLT5wYXJhbXMubWlpbW9uKTsNCi0J
CWlmIChib25kLT5wYXJhbXMuYXJwX2ludGVydmFsKSB7DQotCQkJcHJfaW5mbygiJXM6IE1JSSBt
b25pdG9yaW5nIGNhbm5vdCBiZSB1c2VkIHdpdGggQVJQIG1vbml0b3JpbmcuIERpc2FibGluZyBB
UlAgbW9uaXRvcmluZy4uLlxuIiwNCi0JCQkJYm9uZC0+ZGV2LT5uYW1lKTsNCi0JCQlib25kLT5w
YXJhbXMuYXJwX2ludGVydmFsID0gMDsNCi0JCQlpZiAoYm9uZC0+cGFyYW1zLmFycF92YWxpZGF0
ZSkgew0KLQkJCQlib25kLT5wYXJhbXMuYXJwX3ZhbGlkYXRlID0NCi0JCQkJCUJPTkRfQVJQX1ZB
TElEQVRFX05PTkU7DQotCQkJfQ0KLQkJCWlmIChkZWxheWVkX3dvcmtfcGVuZGluZygmYm9uZC0+
YXJwX3dvcmspKSB7DQotCQkJCWNhbmNlbF9kZWxheWVkX3dvcmsoJmJvbmQtPmFycF93b3JrKTsN
Ci0JCQkJZmx1c2hfd29ya3F1ZXVlKGJvbmQtPndxKTsNCi0JCQl9DQotCQl9DQotDQotCQlpZiAo
Ym9uZC0+ZGV2LT5mbGFncyAmIElGRl9VUCkgew0KLQkJCS8qIElmIHRoZSBpbnRlcmZhY2UgaXMg
dXAsIHdlIG1heSBuZWVkIHRvIGZpcmUgb2ZmDQotCQkJICogdGhlIE1JSSB0aW1lci4gSWYgdGhl
IGludGVyZmFjZSBpcyBkb3duLCB0aGUNCi0JCQkgKiB0aW1lciB3aWxsIGdldCBmaXJlZCBvZmYg
d2hlbiB0aGUgb3BlbiBmdW5jdGlvbg0KLQkJCSAqIGlzIGNhbGxlZC4NCi0JCQkgKi8NCi0JCQlp
ZiAoIWRlbGF5ZWRfd29ya19wZW5kaW5nKCZib25kLT5taWlfd29yaykpIHsNCi0JCQkJSU5JVF9E
RUxBWUVEX1dPUksoJmJvbmQtPm1paV93b3JrLA0KLQkJCQkJCSAgYm9uZF9taWlfbW9uaXRvcik7
DQotCQkJCXF1ZXVlX2RlbGF5ZWRfd29yayhib25kLT53cSwNCi0JCQkJCQkgICAmYm9uZC0+bWlp
X3dvcmssIDApOw0KLQkJCX0NCisJfQ0KKwlwcl9pbmZvKCIlczogU2V0dGluZyBNSUkgbW9uaXRv
cmluZyBpbnRlcnZhbCB0byAlZC5cbiIsDQorCQlib25kLT5kZXYtPm5hbWUsIG5ld192YWx1ZSk7
DQorCWJvbmQtPnBhcmFtcy5taWltb24gPSBuZXdfdmFsdWU7DQorCWlmIChib25kLT5wYXJhbXMu
dXBkZWxheSkNCisJCXByX2luZm8oIiVzOiBOb3RlOiBVcGRhdGluZyB1cGRlbGF5ICh0byAlZCkg
c2luY2UgaXQgaXMgYSBtdWx0aXBsZSBvZiB0aGUgbWlpbW9uIHZhbHVlLlxuIiwNCisJCQlib25k
LT5kZXYtPm5hbWUsDQorCQkJYm9uZC0+cGFyYW1zLnVwZGVsYXkgKiBib25kLT5wYXJhbXMubWlp
bW9uKTsNCisJaWYgKGJvbmQtPnBhcmFtcy5kb3duZGVsYXkpDQorCQlwcl9pbmZvKCIlczogTm90
ZTogVXBkYXRpbmcgZG93bmRlbGF5ICh0byAlZCkgc2luY2UgaXQgaXMgYSBtdWx0aXBsZSBvZiB0
aGUgbWlpbW9uIHZhbHVlLlxuIiwNCisJCQlib25kLT5kZXYtPm5hbWUsDQorCQkJYm9uZC0+cGFy
YW1zLmRvd25kZWxheSAqIGJvbmQtPnBhcmFtcy5taWltb24pOw0KKwlpZiAobmV3X3ZhbHVlICYm
IGJvbmQtPnBhcmFtcy5hcnBfaW50ZXJ2YWwpIHsNCisJCXByX2luZm8oIiVzOiBNSUkgbW9uaXRv
cmluZyBjYW5ub3QgYmUgdXNlZCB3aXRoIEFSUCBtb25pdG9yaW5nLiBEaXNhYmxpbmcgQVJQIG1v
bml0b3JpbmcuLi5cbiIsDQorCQkJYm9uZC0+ZGV2LT5uYW1lKTsNCisJCWJvbmQtPnBhcmFtcy5h
cnBfaW50ZXJ2YWwgPSAwOw0KKwkJaWYgKGJvbmQtPnBhcmFtcy5hcnBfdmFsaWRhdGUpDQorCQkJ
Ym9uZC0+cGFyYW1zLmFycF92YWxpZGF0ZSA9IEJPTkRfQVJQX1ZBTElEQVRFX05PTkU7DQorCX0N
CisJaWYgKGJvbmQtPmRldi0+ZmxhZ3MgJiBJRkZfVVApIHsNCisJCS8qIElmIHRoZSBpbnRlcmZh
Y2UgaXMgdXAsIHdlIG1heSBuZWVkIHRvIGZpcmUgb2ZmDQorCQkgKiB0aGUgTUlJIHRpbWVyLiBJ
ZiB0aGUgaW50ZXJmYWNlIGlzIGRvd24sIHRoZQ0KKwkJICogdGltZXIgd2lsbCBnZXQgZmlyZWQg
b2ZmIHdoZW4gdGhlIG9wZW4gZnVuY3Rpb24NCisJCSAqIGlzIGNhbGxlZC4NCisJCSAqLw0KKwkJ
aWYgKCFuZXdfdmFsdWUpIHsNCisJCQljYW5jZWxfZGVsYXllZF93b3JrX3N5bmMoJmJvbmQtPm1p
aV93b3JrKTsNCisJCX0gZWxzZSB7DQorCQkJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZib25k
LT5hcnBfd29yayk7DQorCQkJcXVldWVfZGVsYXllZF93b3JrKGJvbmQtPndxLCAmYm9uZC0+bWlp
X3dvcmssIDApOw0KIAkJfQ0KIAl9DQogb3V0Og0KKwlydG5sX3VubG9jaygpOw0KIAlyZXR1cm4g
cmV0Ow0KIH0NCiBzdGF0aWMgREVWSUNFX0FUVFIobWlpbW9uLCBTX0lSVUdPIHwgU19JV1VTUiwN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9jYW4vc2phMTAwMC9wbHhfcGNpLmMgYi9kcml2ZXJz
L25ldC9jYW4vc2phMTAwMC9wbHhfcGNpLmMNCmluZGV4IGM3ZjNkNGUuLmMzMWMyZDYgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL25ldC9jYW4vc2phMTAwMC9wbHhfcGNpLmMNCisrKyBiL2RyaXZlcnMv
bmV0L2Nhbi9zamExMDAwL3BseF9wY2kuYw0KQEAgLTMwOSw3ICszMDksNyBAQCBzdGF0aWMgaW5s
aW5lIGludCBwbHhfcGNpX2NoZWNrX3NqYTEwMDAoY29uc3Qgc3RydWN0IHNqYTEwMDBfcHJpdiAq
cHJpdikNCiAJICovDQogCWlmICgocHJpdi0+cmVhZF9yZWcocHJpdiwgUkVHX0NSKSAmIFJFR19D
Ul9CQVNJQ0NBTl9JTklUSUFMX01BU0spID09DQogCSAgICBSRUdfQ1JfQkFTSUNDQU5fSU5JVElB
TCAmJg0KLQkgICAgKHByaXYtPnJlYWRfcmVnKHByaXYsIFJFR19TUikgPT0gUkVHX1NSX0JBU0lD
Q0FOX0lOSVRJQUwpICYmDQorCSAgICAocHJpdi0+cmVhZF9yZWcocHJpdiwgU0pBMTAwMF9SRUdf
U1IpID09IFJFR19TUl9CQVNJQ0NBTl9JTklUSUFMKSAmJg0KIAkgICAgKHByaXYtPnJlYWRfcmVn
KHByaXYsIFJFR19JUikgPT0gUkVHX0lSX0JBU0lDQ0FOX0lOSVRJQUwpKQ0KIAkJZmxhZyA9IDE7
DQogDQpAQCAtMzIxLDcgKzMyMSw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IHBseF9wY2lfY2hlY2tf
c2phMTAwMChjb25zdCBzdHJ1Y3Qgc2phMTAwMF9wcml2ICpwcml2KQ0KIAkgKiBTZWUgc3RhdGVz
IG9uIHAuIDIzIG9mIHRoZSBEYXRhc2hlZXQuDQogCSAqLw0KIAlpZiAocHJpdi0+cmVhZF9yZWco
cHJpdiwgUkVHX01PRCkgPT0gUkVHX01PRF9QRUxJQ0FOX0lOSVRJQUwgJiYNCi0JICAgIHByaXYt
PnJlYWRfcmVnKHByaXYsIFJFR19TUikgPT0gUkVHX1NSX1BFTElDQU5fSU5JVElBTCAmJg0KKwkg
ICAgcHJpdi0+cmVhZF9yZWcocHJpdiwgU0pBMTAwMF9SRUdfU1IpID09IFJFR19TUl9QRUxJQ0FO
X0lOSVRJQUwgJiYNCiAJICAgIHByaXYtPnJlYWRfcmVnKHByaXYsIFJFR19JUikgPT0gUkVHX0lS
X1BFTElDQU5fSU5JVElBTCkNCiAJCXJldHVybiBmbGFnOw0KIA0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2Nhbi9zamExMDAwL3NqYTEwMDAuYyBiL2RyaXZlcnMvbmV0L2Nhbi9zamExMDAwL3Nq
YTEwMDAuYw0KaW5kZXggMTkyYjBkMS4uNmExYWNmZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0
L2Nhbi9zamExMDAwL3NqYTEwMDAuYw0KKysrIGIvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvc2ph
MTAwMC5jDQpAQCAtOTEsNyArOTEsNyBAQCBzdGF0aWMgdm9pZCBzamExMDAwX3dyaXRlX2NtZHJl
ZyhzdHJ1Y3Qgc2phMTAwMF9wcml2ICpwcml2LCB1OCB2YWwpDQogCSAqLw0KIAlzcGluX2xvY2tf
aXJxc2F2ZSgmcHJpdi0+Y21kcmVnX2xvY2ssIGZsYWdzKTsNCiAJcHJpdi0+d3JpdGVfcmVnKHBy
aXYsIFJFR19DTVIsIHZhbCk7DQotCXByaXYtPnJlYWRfcmVnKHByaXYsIFJFR19TUik7DQorCXBy
aXYtPnJlYWRfcmVnKHByaXYsIFNKQTEwMDBfUkVHX1NSKTsNCiAJc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZSgmcHJpdi0+Y21kcmVnX2xvY2ssIGZsYWdzKTsNCiB9DQogDQpAQCAtNDk3LDcgKzQ5Nyw3
IEBAIGlycXJldHVybl90IHNqYTEwMDBfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRldl9pZCkN
CiANCiAJd2hpbGUgKChpc3JjID0gcHJpdi0+cmVhZF9yZWcocHJpdiwgUkVHX0lSKSkgJiYgKG4g
PCBTSkExMDAwX01BWF9JUlEpKSB7DQogCQluKys7DQotCQlzdGF0dXMgPSBwcml2LT5yZWFkX3Jl
Zyhwcml2LCBSRUdfU1IpOw0KKwkJc3RhdHVzID0gcHJpdi0+cmVhZF9yZWcocHJpdiwgU0pBMTAw
MF9SRUdfU1IpOw0KIAkJLyogY2hlY2sgZm9yIGFic2VudCBjb250cm9sbGVyIGR1ZSB0byBodyB1
bnBsdWcgKi8NCiAJCWlmIChzdGF0dXMgPT0gMHhGRiAmJiBzamExMDAwX2lzX2Fic2VudChwcml2
KSkNCiAJCQlyZXR1cm4gSVJRX05PTkU7DQpAQCAtNTE2LDcgKzUxNiw3IEBAIGlycXJldHVybl90
IHNqYTEwMDBfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRldl9pZCkNCiAJCQkvKiByZWNlaXZl
IGludGVycnVwdCAqLw0KIAkJCXdoaWxlIChzdGF0dXMgJiBTUl9SQlMpIHsNCiAJCQkJc2phMTAw
MF9yeChkZXYpOw0KLQkJCQlzdGF0dXMgPSBwcml2LT5yZWFkX3JlZyhwcml2LCBSRUdfU1IpOw0K
KwkJCQlzdGF0dXMgPSBwcml2LT5yZWFkX3JlZyhwcml2LCBTSkExMDAwX1JFR19TUik7DQogCQkJ
CS8qIGNoZWNrIGZvciBhYnNlbnQgY29udHJvbGxlciAqLw0KIAkJCQlpZiAoc3RhdHVzID09IDB4
RkYgJiYgc2phMTAwMF9pc19hYnNlbnQocHJpdikpDQogCQkJCQlyZXR1cm4gSVJRX05PTkU7DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvc2phMTAwMC5oIGIvZHJpdmVycy9u
ZXQvY2FuL3NqYTEwMDAvc2phMTAwMC5oDQppbmRleCAyM2ZmZjA2Li4yYTc5NTQzIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvc2phMTAwMC5oDQorKysgYi9kcml2ZXJzL25l
dC9jYW4vc2phMTAwMC9zamExMDAwLmgNCkBAIC01Niw3ICs1Niw3IEBADQogLyogU0pBMTAwMCBy
ZWdpc3RlcnMgLSBtYW51YWwgc2VjdGlvbiA2LjQgKFBlbGljYW4gTW9kZSkgKi8NCiAjZGVmaW5l
IFJFR19NT0QJCTB4MDANCiAjZGVmaW5lIFJFR19DTVIJCTB4MDENCi0jZGVmaW5lIFJFR19TUgkJ
MHgwMg0KKyNkZWZpbmUgU0pBMTAwMF9SRUdfU1IJCTB4MDINCiAjZGVmaW5lIFJFR19JUgkJMHgw
Mw0KICNkZWZpbmUgUkVHX0lFUgkJMHgwNA0KICNkZWZpbmUgUkVHX0FMQwkJMHgwQg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2F0aGVyb3MvYXRsMWUvYXRsMWUuaCBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2F0aGVyb3MvYXRsMWUvYXRsMWUuaA0KaW5kZXggODI5YjVhZC4uZWRm
ZGY2YiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2F0aGVyb3MvYXRsMWUvYXRs
MWUuaA0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXRoZXJvcy9hdGwxZS9hdGwxZS5oDQpA
QCAtNDM4LDcgKzQzOCw2IEBAIHN0cnVjdCBhdGwxZV9hZGFwdGVyIHsNCiAJc3RydWN0IGF0bDFl
X2h3ICAgICAgICBodzsNCiAJc3RydWN0IGF0bDFlX2h3X3N0YXRzICBod19zdGF0czsNCiANCi0J
Ym9vbCBoYXZlX21zaTsNCiAJdTMyIHdvbDsNCiAJdTE2IGxpbmtfc3BlZWQ7DQogCXUxNiBsaW5r
X2R1cGxleDsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hdGhlcm9zL2F0bDFl
L2F0bDFlX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2F0aGVyb3MvYXRsMWUvYXRsMWVf
bWFpbi5jDQppbmRleCA5NTQ4M2JjLi5jNjlkYzI5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvYXRoZXJvcy9hdGwxZS9hdGwxZV9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2F0aGVyb3MvYXRsMWUvYXRsMWVfbWFpbi5jDQpAQCAtMTg2NywzNyArMTg2NywxOSBA
QCBzdGF0aWMgdm9pZCBhdGwxZV9mcmVlX2lycShzdHJ1Y3QgYXRsMWVfYWRhcHRlciAqYWRhcHRl
cikNCiAJc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiA9IGFkYXB0ZXItPm5ldGRldjsNCiANCiAJ
ZnJlZV9pcnEoYWRhcHRlci0+cGRldi0+aXJxLCBuZXRkZXYpOw0KLQ0KLQlpZiAoYWRhcHRlci0+
aGF2ZV9tc2kpDQotCQlwY2lfZGlzYWJsZV9tc2koYWRhcHRlci0+cGRldik7DQogfQ0KIA0KIHN0
YXRpYyBpbnQgYXRsMWVfcmVxdWVzdF9pcnEoc3RydWN0IGF0bDFlX2FkYXB0ZXIgKmFkYXB0ZXIp
DQogew0KIAlzdHJ1Y3QgcGNpX2RldiAgICAqcGRldiAgID0gYWRhcHRlci0+cGRldjsNCiAJc3Ry
dWN0IG5ldF9kZXZpY2UgKm5ldGRldiA9IGFkYXB0ZXItPm5ldGRldjsNCi0JaW50IGZsYWdzID0g
MDsNCiAJaW50IGVyciA9IDA7DQogDQotCWFkYXB0ZXItPmhhdmVfbXNpID0gdHJ1ZTsNCi0JZXJy
ID0gcGNpX2VuYWJsZV9tc2koYWRhcHRlci0+cGRldik7DQotCWlmIChlcnIpIHsNCi0JCW5ldGRl
dl9kYmcoYWRhcHRlci0+bmV0ZGV2LA0KLQkJCSAgICJVbmFibGUgdG8gYWxsb2NhdGUgTVNJIGlu
dGVycnVwdCBFcnJvcjogJWRcbiIsIGVycik7DQotCQlhZGFwdGVyLT5oYXZlX21zaSA9IGZhbHNl
Ow0KLQl9IGVsc2UNCi0JCW5ldGRldi0+aXJxID0gcGRldi0+aXJxOw0KLQ0KLQ0KLQlpZiAoIWFk
YXB0ZXItPmhhdmVfbXNpKQ0KLQkJZmxhZ3MgfD0gSVJRRl9TSEFSRUQ7DQotCWVyciA9IHJlcXVl
c3RfaXJxKGFkYXB0ZXItPnBkZXYtPmlycSwgYXRsMWVfaW50ciwgZmxhZ3MsDQotCQkJbmV0ZGV2
LT5uYW1lLCBuZXRkZXYpOw0KKwllcnIgPSByZXF1ZXN0X2lycShwZGV2LT5pcnEsIGF0bDFlX2lu
dHIsIElSUUZfU0hBUkVELA0KKwkJCSAgbmV0ZGV2LT5uYW1lLCBuZXRkZXYpOw0KIAlpZiAoZXJy
KSB7DQogCQluZXRkZXZfZGJnKGFkYXB0ZXItPm5ldGRldiwNCiAJCQkgICAiVW5hYmxlIHRvIGFs
bG9jYXRlIGludGVycnVwdCBFcnJvcjogJWRcbiIsIGVycik7DQotCQlpZiAoYWRhcHRlci0+aGF2
ZV9tc2kpDQotCQkJcGNpX2Rpc2FibGVfbXNpKGFkYXB0ZXItPnBkZXYpOw0KIAkJcmV0dXJuIGVy
cjsNCiAJfQ0KIAluZXRkZXZfZGJnKGFkYXB0ZXItPm5ldGRldiwgImF0bDFlX3JlcXVlc3RfaXJx
IE9LXG4iKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS90ZzMu
YyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL3RnMy5jDQppbmRleCBjODZmYTUwLi5j
NmI5OTAzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vdGczLmMN
CisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL3RnMy5jDQpAQCAtMTM0MzMsOCAr
MTM0MzMsMTEgQEAgc3RhdGljIHZvaWQgX19kZXZpbml0IHRnM19yZWFkX3ZwZChzdHJ1Y3QgdGcz
ICp0cCkNCiAJCWlmIChqICsgbGVuID4gYmxvY2tfZW5kKQ0KIAkJCWdvdG8gcGFydG5vOw0KIA0K
LQkJbWVtY3B5KHRwLT5md192ZXIsICZ2cGRfZGF0YVtqXSwgbGVuKTsNCi0JCXN0cm5jYXQodHAt
PmZ3X3ZlciwgIiBiYyAiLCB2cGRsZW4gLSBsZW4gLSAxKTsNCisJCWlmIChsZW4gPj0gc2l6ZW9m
KHRwLT5md192ZXIpKQ0KKwkJCWxlbiA9IHNpemVvZih0cC0+ZndfdmVyKSAtIDE7DQorCQltZW1z
ZXQodHAtPmZ3X3ZlciwgMCwgc2l6ZW9mKHRwLT5md192ZXIpKTsNCisJCXNucHJpbnRmKHRwLT5m
d192ZXIsIHNpemVvZih0cC0+ZndfdmVyKSwgIiUuKnMgYmMgIiwgbGVuLA0KKwkJCSAmdnBkX2Rh
dGFbal0pOw0KIAl9DQogDQogcGFydG5vOg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2Rhdmljb20vZG05MDAwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9kYXZpY29tL2RtOTAw
MC5jDQppbmRleCAyYTIyZjUyLi4yZjJlOThiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZGF2aWNvbS9kbTkwMDAuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZGF2aWNv
bS9kbTkwMDAuYw0KQEAgLTI1Nyw2ICsyNTcsMTA3IEBAIHN0YXRpYyB2b2lkIGRtOTAwMF9kdW1w
YmxrXzMyYml0KHZvaWQgX19pb21lbSAqcmVnLCBpbnQgY291bnQpDQogCQl0bXAgPSByZWFkbChy
ZWcpOw0KIH0NCiANCisvKg0KKyAqIFNsZWVwLCBlaXRoZXIgYnkgdXNpbmcgbXNsZWVwKCkgb3Ig
aWYgd2UgYXJlIHN1c3BlbmRpbmcsIHRoZW4NCisgKiB1c2UgbWRlbGF5KCkgdG8gc2xlZXAuDQor
ICovDQorc3RhdGljIHZvaWQgZG05MDAwX21zbGVlcChib2FyZF9pbmZvX3QgKmRiLCB1bnNpZ25l
ZCBpbnQgbXMpDQorew0KKwlpZiAoZGItPmluX3N1c3BlbmQpDQorCQltZGVsYXkobXMpOw0KKwll
bHNlDQorCQltc2xlZXAobXMpOw0KK30NCisNCisvKiBSZWFkIGEgd29yZCBmcm9tIHBoeXhjZXIg
Ki8NCitzdGF0aWMgaW50DQorZG05MDAwX3BoeV9yZWFkKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYs
IGludCBwaHlfcmVnX3VudXNlZCwgaW50IHJlZykNCit7DQorCWJvYXJkX2luZm9fdCAqZGIgPSBu
ZXRkZXZfcHJpdihkZXYpOw0KKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KKwl1bnNpZ25lZCBpbnQg
cmVnX3NhdmU7DQorCWludCByZXQ7DQorDQorCW11dGV4X2xvY2soJmRiLT5hZGRyX2xvY2spOw0K
Kw0KKwlzcGluX2xvY2tfaXJxc2F2ZSgmZGItPmxvY2ssIGZsYWdzKTsNCisNCisJLyogU2F2ZSBw
cmV2aW91cyByZWdpc3RlciBhZGRyZXNzICovDQorCXJlZ19zYXZlID0gcmVhZGIoZGItPmlvX2Fk
ZHIpOw0KKw0KKwkvKiBGaWxsIHRoZSBwaHl4Y2VyIHJlZ2lzdGVyIGludG8gUkVHXzBDICovDQor
CWlvdyhkYiwgRE05MDAwX0VQQVIsIERNOTAwMF9QSFkgfCByZWcpOw0KKw0KKwkvKiBJc3N1ZSBw
aHl4Y2VyIHJlYWQgY29tbWFuZCAqLw0KKwlpb3coZGIsIERNOTAwMF9FUENSLCBFUENSX0VSUFJS
IHwgRVBDUl9FUE9TKTsNCisNCisJd3JpdGViKHJlZ19zYXZlLCBkYi0+aW9fYWRkcik7DQorCXNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJmRiLT5sb2NrLCBmbGFncyk7DQorDQorCWRtOTAwMF9tc2xl
ZXAoZGIsIDEpOwkJLyogV2FpdCByZWFkIGNvbXBsZXRlICovDQorDQorCXNwaW5fbG9ja19pcnFz
YXZlKCZkYi0+bG9jaywgZmxhZ3MpOw0KKwlyZWdfc2F2ZSA9IHJlYWRiKGRiLT5pb19hZGRyKTsN
CisNCisJaW93KGRiLCBETTkwMDBfRVBDUiwgMHgwKTsJLyogQ2xlYXIgcGh5eGNlciByZWFkIGNv
bW1hbmQgKi8NCisNCisJLyogVGhlIHJlYWQgZGF0YSBrZWVwcyBvbiBSRUdfMEQgJiBSRUdfMEUg
Ki8NCisJcmV0ID0gKGlvcihkYiwgRE05MDAwX0VQRFJIKSA8PCA4KSB8IGlvcihkYiwgRE05MDAw
X0VQRFJMKTsNCisNCisJLyogcmVzdG9yZSB0aGUgcHJldmlvdXMgYWRkcmVzcyAqLw0KKwl3cml0
ZWIocmVnX3NhdmUsIGRiLT5pb19hZGRyKTsNCisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZGIt
PmxvY2ssIGZsYWdzKTsNCisNCisJbXV0ZXhfdW5sb2NrKCZkYi0+YWRkcl9sb2NrKTsNCisNCisJ
ZG05MDAwX2RiZyhkYiwgNSwgInBoeV9yZWFkWyUwMnhdIC0+ICUwNHhcbiIsIHJlZywgcmV0KTsN
CisJcmV0dXJuIHJldDsNCit9DQorDQorLyogV3JpdGUgYSB3b3JkIHRvIHBoeXhjZXIgKi8NCitz
dGF0aWMgdm9pZA0KK2RtOTAwMF9waHlfd3JpdGUoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCisJ
CSBpbnQgcGh5YWRkcl91bnVzZWQsIGludCByZWcsIGludCB2YWx1ZSkNCit7DQorCWJvYXJkX2lu
Zm9fdCAqZGIgPSBuZXRkZXZfcHJpdihkZXYpOw0KKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KKwl1
bnNpZ25lZCBsb25nIHJlZ19zYXZlOw0KKw0KKwlkbTkwMDBfZGJnKGRiLCA1LCAicGh5X3dyaXRl
WyUwMnhdID0gJTA0eFxuIiwgcmVnLCB2YWx1ZSk7DQorCW11dGV4X2xvY2soJmRiLT5hZGRyX2xv
Y2spOw0KKw0KKwlzcGluX2xvY2tfaXJxc2F2ZSgmZGItPmxvY2ssIGZsYWdzKTsNCisNCisJLyog
U2F2ZSBwcmV2aW91cyByZWdpc3RlciBhZGRyZXNzICovDQorCXJlZ19zYXZlID0gcmVhZGIoZGIt
PmlvX2FkZHIpOw0KKw0KKwkvKiBGaWxsIHRoZSBwaHl4Y2VyIHJlZ2lzdGVyIGludG8gUkVHXzBD
ICovDQorCWlvdyhkYiwgRE05MDAwX0VQQVIsIERNOTAwMF9QSFkgfCByZWcpOw0KKw0KKwkvKiBG
aWxsIHRoZSB3cml0dGVuIGRhdGEgaW50byBSRUdfMEQgJiBSRUdfMEUgKi8NCisJaW93KGRiLCBE
TTkwMDBfRVBEUkwsIHZhbHVlKTsNCisJaW93KGRiLCBETTkwMDBfRVBEUkgsIHZhbHVlID4+IDgp
Ow0KKw0KKwkvKiBJc3N1ZSBwaHl4Y2VyIHdyaXRlIGNvbW1hbmQgKi8NCisJaW93KGRiLCBETTkw
MDBfRVBDUiwgRVBDUl9FUE9TIHwgRVBDUl9FUlBSVyk7DQorDQorCXdyaXRlYihyZWdfc2F2ZSwg
ZGItPmlvX2FkZHIpOw0KKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZkYi0+bG9jaywgZmxhZ3Mp
Ow0KKw0KKwlkbTkwMDBfbXNsZWVwKGRiLCAxKTsJCS8qIFdhaXQgd3JpdGUgY29tcGxldGUgKi8N
CisNCisJc3Bpbl9sb2NrX2lycXNhdmUoJmRiLT5sb2NrLCBmbGFncyk7DQorCXJlZ19zYXZlID0g
cmVhZGIoZGItPmlvX2FkZHIpOw0KKw0KKwlpb3coZGIsIERNOTAwMF9FUENSLCAweDApOwkvKiBD
bGVhciBwaHl4Y2VyIHdyaXRlIGNvbW1hbmQgKi8NCisNCisJLyogcmVzdG9yZSB0aGUgcHJldmlv
dXMgYWRkcmVzcyAqLw0KKwl3cml0ZWIocmVnX3NhdmUsIGRiLT5pb19hZGRyKTsNCisNCisJc3Bp
bl91bmxvY2tfaXJxcmVzdG9yZSgmZGItPmxvY2ssIGZsYWdzKTsNCisJbXV0ZXhfdW5sb2NrKCZk
Yi0+YWRkcl9sb2NrKTsNCit9DQorDQogLyogZG05MDAwX3NldF9pbw0KICAqDQogICogc2VsZWN0
IHRoZSBzcGVjaWZpZWQgc2V0IG9mIGlvIHJvdXRpbmVzIHRvIHVzZSB3aXRoIHRoZQ0KQEAgLTc5
Myw2ICs4OTQsOSBAQCBkbTkwMDBfaW5pdF9kbTkwMDAoc3RydWN0IG5ldF9kZXZpY2UgKmRldikN
CiANCiAJaW93KGRiLCBETTkwMDBfR1BDUiwgR1BDUl9HRVBfQ05UTCk7CS8qIExldCBHUElPMCBv
dXRwdXQgKi8NCiANCisJZG05MDAwX3BoeV93cml0ZShkZXYsIDAsIE1JSV9CTUNSLCBCTUNSX1JF
U0VUKTsgLyogUEhZIFJFU0VUICovDQorCWRtOTAwMF9waHlfd3JpdGUoZGV2LCAwLCBNSUlfRE1f
RFNQQ1IsIERTUENSX0lOSVRfUEFSQU0pOyAvKiBJbml0ICovDQorDQogCW5jciA9IChkYi0+Zmxh
Z3MgJiBETTkwMDBfUExBVEZfRVhUX1BIWSkgPyBOQ1JfRVhUX1BIWSA6IDA7DQogDQogCS8qIGlm
IHdvbCBpcyBuZWVkZWQsIHRoZW4gYWx3YXlzIHNldCBOQ1JfV0FLRUVOIG90aGVyd2lzZSB3ZSBl
bmQNCkBAIC0xMTk5LDEwOSArMTMwMyw2IEBAIGRtOTAwMF9vcGVuKHN0cnVjdCBuZXRfZGV2aWNl
ICpkZXYpDQogCXJldHVybiAwOw0KIH0NCiANCi0vKg0KLSAqIFNsZWVwLCBlaXRoZXIgYnkgdXNp
bmcgbXNsZWVwKCkgb3IgaWYgd2UgYXJlIHN1c3BlbmRpbmcsIHRoZW4NCi0gKiB1c2UgbWRlbGF5
KCkgdG8gc2xlZXAuDQotICovDQotc3RhdGljIHZvaWQgZG05MDAwX21zbGVlcChib2FyZF9pbmZv
X3QgKmRiLCB1bnNpZ25lZCBpbnQgbXMpDQotew0KLQlpZiAoZGItPmluX3N1c3BlbmQpDQotCQlt
ZGVsYXkobXMpOw0KLQllbHNlDQotCQltc2xlZXAobXMpOw0KLX0NCi0NCi0vKg0KLSAqICAgUmVh
ZCBhIHdvcmQgZnJvbSBwaHl4Y2VyDQotICovDQotc3RhdGljIGludA0KLWRtOTAwMF9waHlfcmVh
ZChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBpbnQgcGh5X3JlZ191bnVzZWQsIGludCByZWcpDQot
ew0KLQlib2FyZF9pbmZvX3QgKmRiID0gbmV0ZGV2X3ByaXYoZGV2KTsNCi0JdW5zaWduZWQgbG9u
ZyBmbGFnczsNCi0JdW5zaWduZWQgaW50IHJlZ19zYXZlOw0KLQlpbnQgcmV0Ow0KLQ0KLQltdXRl
eF9sb2NrKCZkYi0+YWRkcl9sb2NrKTsNCi0NCi0Jc3Bpbl9sb2NrX2lycXNhdmUoJmRiLT5sb2Nr
LGZsYWdzKTsNCi0NCi0JLyogU2F2ZSBwcmV2aW91cyByZWdpc3RlciBhZGRyZXNzICovDQotCXJl
Z19zYXZlID0gcmVhZGIoZGItPmlvX2FkZHIpOw0KLQ0KLQkvKiBGaWxsIHRoZSBwaHl4Y2VyIHJl
Z2lzdGVyIGludG8gUkVHXzBDICovDQotCWlvdyhkYiwgRE05MDAwX0VQQVIsIERNOTAwMF9QSFkg
fCByZWcpOw0KLQ0KLQlpb3coZGIsIERNOTAwMF9FUENSLCBFUENSX0VSUFJSIHwgRVBDUl9FUE9T
KTsJLyogSXNzdWUgcGh5eGNlciByZWFkIGNvbW1hbmQgKi8NCi0NCi0Jd3JpdGViKHJlZ19zYXZl
LCBkYi0+aW9fYWRkcik7DQotCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmRiLT5sb2NrLGZsYWdz
KTsNCi0NCi0JZG05MDAwX21zbGVlcChkYiwgMSk7CQkvKiBXYWl0IHJlYWQgY29tcGxldGUgKi8N
Ci0NCi0Jc3Bpbl9sb2NrX2lycXNhdmUoJmRiLT5sb2NrLGZsYWdzKTsNCi0JcmVnX3NhdmUgPSBy
ZWFkYihkYi0+aW9fYWRkcik7DQotDQotCWlvdyhkYiwgRE05MDAwX0VQQ1IsIDB4MCk7CS8qIENs
ZWFyIHBoeXhjZXIgcmVhZCBjb21tYW5kICovDQotDQotCS8qIFRoZSByZWFkIGRhdGEga2VlcHMg
b24gUkVHXzBEICYgUkVHXzBFICovDQotCXJldCA9IChpb3IoZGIsIERNOTAwMF9FUERSSCkgPDwg
OCkgfCBpb3IoZGIsIERNOTAwMF9FUERSTCk7DQotDQotCS8qIHJlc3RvcmUgdGhlIHByZXZpb3Vz
IGFkZHJlc3MgKi8NCi0Jd3JpdGViKHJlZ19zYXZlLCBkYi0+aW9fYWRkcik7DQotCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJmRiLT5sb2NrLGZsYWdzKTsNCi0NCi0JbXV0ZXhfdW5sb2NrKCZkYi0+
YWRkcl9sb2NrKTsNCi0NCi0JZG05MDAwX2RiZyhkYiwgNSwgInBoeV9yZWFkWyUwMnhdIC0+ICUw
NHhcbiIsIHJlZywgcmV0KTsNCi0JcmV0dXJuIHJldDsNCi19DQotDQotLyoNCi0gKiAgIFdyaXRl
IGEgd29yZCB0byBwaHl4Y2VyDQotICovDQotc3RhdGljIHZvaWQNCi1kbTkwMDBfcGh5X3dyaXRl
KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQotCQkgaW50IHBoeWFkZHJfdW51c2VkLCBpbnQgcmVn
LCBpbnQgdmFsdWUpDQotew0KLQlib2FyZF9pbmZvX3QgKmRiID0gbmV0ZGV2X3ByaXYoZGV2KTsN
Ci0JdW5zaWduZWQgbG9uZyBmbGFnczsNCi0JdW5zaWduZWQgbG9uZyByZWdfc2F2ZTsNCi0NCi0J
ZG05MDAwX2RiZyhkYiwgNSwgInBoeV93cml0ZVslMDJ4XSA9ICUwNHhcbiIsIHJlZywgdmFsdWUp
Ow0KLQltdXRleF9sb2NrKCZkYi0+YWRkcl9sb2NrKTsNCi0NCi0Jc3Bpbl9sb2NrX2lycXNhdmUo
JmRiLT5sb2NrLGZsYWdzKTsNCi0NCi0JLyogU2F2ZSBwcmV2aW91cyByZWdpc3RlciBhZGRyZXNz
ICovDQotCXJlZ19zYXZlID0gcmVhZGIoZGItPmlvX2FkZHIpOw0KLQ0KLQkvKiBGaWxsIHRoZSBw
aHl4Y2VyIHJlZ2lzdGVyIGludG8gUkVHXzBDICovDQotCWlvdyhkYiwgRE05MDAwX0VQQVIsIERN
OTAwMF9QSFkgfCByZWcpOw0KLQ0KLQkvKiBGaWxsIHRoZSB3cml0dGVuIGRhdGEgaW50byBSRUdf
MEQgJiBSRUdfMEUgKi8NCi0JaW93KGRiLCBETTkwMDBfRVBEUkwsIHZhbHVlKTsNCi0JaW93KGRi
LCBETTkwMDBfRVBEUkgsIHZhbHVlID4+IDgpOw0KLQ0KLQlpb3coZGIsIERNOTAwMF9FUENSLCBF
UENSX0VQT1MgfCBFUENSX0VSUFJXKTsJLyogSXNzdWUgcGh5eGNlciB3cml0ZSBjb21tYW5kICov
DQotDQotCXdyaXRlYihyZWdfc2F2ZSwgZGItPmlvX2FkZHIpOw0KLQlzcGluX3VubG9ja19pcnFy
ZXN0b3JlKCZkYi0+bG9jaywgZmxhZ3MpOw0KLQ0KLQlkbTkwMDBfbXNsZWVwKGRiLCAxKTsJCS8q
IFdhaXQgd3JpdGUgY29tcGxldGUgKi8NCi0NCi0Jc3Bpbl9sb2NrX2lycXNhdmUoJmRiLT5sb2Nr
LGZsYWdzKTsNCi0JcmVnX3NhdmUgPSByZWFkYihkYi0+aW9fYWRkcik7DQotDQotCWlvdyhkYiwg
RE05MDAwX0VQQ1IsIDB4MCk7CS8qIENsZWFyIHBoeXhjZXIgd3JpdGUgY29tbWFuZCAqLw0KLQ0K
LQkvKiByZXN0b3JlIHRoZSBwcmV2aW91cyBhZGRyZXNzICovDQotCXdyaXRlYihyZWdfc2F2ZSwg
ZGItPmlvX2FkZHIpOw0KLQ0KLQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZkYi0+bG9jaywgZmxh
Z3MpOw0KLQltdXRleF91bmxvY2soJmRiLT5hZGRyX2xvY2spOw0KLX0NCi0NCiBzdGF0aWMgdm9p
ZA0KIGRtOTAwMF9zaHV0ZG93bihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KIHsNCkBAIC0xNTAy
LDcgKzE1MDMsMTIgQEAgZG05MDAwX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYp
DQogCWRiLT5mbGFncyB8PSBETTkwMDBfUExBVEZfU0lNUExFX1BIWTsNCiAjZW5kaWYNCiANCi0J
ZG05MDAwX3Jlc2V0KGRiKTsNCisJLyogRml4aW5nIGJ1ZyBvbiBkbTkwMDBfcHJvYmUsIHRha2Vv
dmVyIGRtOTAwMF9yZXNldChkYiksDQorCSAqIE5lZWQgJ05DUl9NQUNfTEJLJyBiaXQgdG8gaW5k
ZWVkIHN0YWJsZSBvdXIgRE05MDAwIGZpZm8NCisJICogd2hpbGUgcHJvYmUgc3RhZ2UuDQorCSAq
Lw0KKw0KKwlpb3coZGIsIERNOTAwMF9OQ1IsIE5DUl9NQUNfTEJLIHwgTkNSX1JTVCk7DQogDQog
CS8qIHRyeSBtdWx0aXBsZSB0aW1lcywgRE05MDAwIHNvbWV0aW1lcyBnZXRzIHRoZSByZWFkIHdy
b25nICovDQogCWZvciAoaSA9IDA7IGkgPCA4OyBpKyspIHsNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9kYXZpY29tL2RtOTAwMC5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZGF2
aWNvbS9kbTkwMDAuaA0KaW5kZXggNTU2ODhiZC4uOWNlMDU4YSAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2Rhdmljb20vZG05MDAwLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2Rhdmljb20vZG05MDAwLmgNCkBAIC02OSw3ICs2OSw5IEBADQogI2RlZmluZSBOQ1JfV0FL
RUVOICAgICAgICAgICgxPDw2KQ0KICNkZWZpbmUgTkNSX0ZDT0wgICAgICAgICAgICAoMTw8NCkN
CiAjZGVmaW5lIE5DUl9GRFggICAgICAgICAgICAgKDE8PDMpDQotI2RlZmluZSBOQ1JfTEJLICAg
ICAgICAgICAgICgzPDwxKQ0KKw0KKyNkZWZpbmUgTkNSX1JFU0VSVkVEICAgICAgICAoMzw8MSkN
CisjZGVmaW5lIE5DUl9NQUNfTEJLICAgICAgICAgKDE8PDEpDQogI2RlZmluZSBOQ1JfUlNUCSAg
ICAgICAgICAgICgxPDwwKQ0KIA0KICNkZWZpbmUgTlNSX1NQRUVEICAgICAgICAgICAoMTw8NykN
CkBAIC0xNjcsNSArMTY5LDEyIEBADQogI2RlZmluZSBJU1JfTE5LQ0hORwkJKDE8PDUpDQogI2Rl
ZmluZSBJU1JfVU5ERVJSVU4JCSgxPDw0KQ0KIA0KKy8qIERhdmljb20gTUlJIHJlZ2lzdGVycy4N
CisgKi8NCisNCisjZGVmaW5lIE1JSV9ETV9EU1BDUgkJMHgxYiAgICAvKiBEU1AgQ29udHJvbCBS
ZWdpc3RlciAqLw0KKw0KKyNkZWZpbmUgRFNQQ1JfSU5JVF9QQVJBTQkweEUxMDAJLyogRFNQIGlu
aXQgcGFyYW1ldGVyICovDQorDQogI2VuZGlmIC8qIF9ETTkwMDBYX0hfICovDQogDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQppbmRleCBjYzk2YTVh
Li40MTM5NmZhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUv
aXhnYmVfbWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdi
ZV9tYWluLmMNCkBAIC04MDAzLDEyICs4MDAzLDE1IEBAIHN0YXRpYyBpbnQgX19pbml0IGl4Z2Jl
X2luaXRfbW9kdWxlKHZvaWQpDQogCXByX2luZm8oIiVzIC0gdmVyc2lvbiAlc1xuIiwgaXhnYmVf
ZHJpdmVyX3N0cmluZywgaXhnYmVfZHJpdmVyX3ZlcnNpb24pOw0KIAlwcl9pbmZvKCIlc1xuIiwg
aXhnYmVfY29weXJpZ2h0KTsNCiANCisJcmV0ID0gcGNpX3JlZ2lzdGVyX2RyaXZlcigmaXhnYmVf
ZHJpdmVyKTsNCisJaWYgKHJldCkNCisJCXJldHVybiByZXQ7DQorDQogI2lmZGVmIENPTkZJR19J
WEdCRV9EQ0ENCiAJZGNhX3JlZ2lzdGVyX25vdGlmeSgmZGNhX25vdGlmaWVyKTsNCiAjZW5kaWYN
CiANCi0JcmV0ID0gcGNpX3JlZ2lzdGVyX2RyaXZlcigmaXhnYmVfZHJpdmVyKTsNCi0JcmV0dXJu
IHJldDsNCisJcmV0dXJuIDA7DQogfQ0KIA0KIG1vZHVsZV9pbml0KGl4Z2JlX2luaXRfbW9kdWxl
KTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL3NreTIuYyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvc2t5Mi5jDQppbmRleCA2OWZjODg4Li45NGY5YThm
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9za3kyLmMNCisrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvc2t5Mi5jDQpAQCAtMTA2Niw3ICsxMDY2LDcg
QEAgc3RhdGljIHZvaWQgc2t5Ml9yYW1zZXQoc3RydWN0IHNreTJfaHcgKmh3LCB1MTYgcSwgdTMy
IHN0YXJ0LCB1MzIgc3BhY2UpDQogCQlza3kyX3dyaXRlMzIoaHcsIFJCX0FERFIocSwgUkJfUlhf
VVRIUCksIHRwKTsNCiAJCXNreTJfd3JpdGUzMihodywgUkJfQUREUihxLCBSQl9SWF9MVEhQKSwg
c3BhY2UvMik7DQogDQotCQl0cCA9IHNwYWNlIC0gMjA0OC84Ow0KKwkJdHAgPSBzcGFjZSAtIDgx
OTIvODsNCiAJCXNreTJfd3JpdGUzMihodywgUkJfQUREUihxLCBSQl9SWF9VVFBQKSwgdHApOw0K
IAkJc2t5Ml93cml0ZTMyKGh3LCBSQl9BRERSKHEsIFJCX1JYX0xUUFApLCBzcGFjZS80KTsNCiAJ
fSBlbHNlIHsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL3NreTIu
aCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvc2t5Mi5oDQppbmRleCAzYzg5NmNlLi5h
MGYyMjllIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9za3kyLmgN
CisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvc2t5Mi5oDQpAQCAtMjA2OSw3ICsy
MDY5LDcgQEAgZW51bSB7DQogCUdNX0lTX1JYX0ZGX09SCT0gMTw8MSwJLyogUmVjZWl2ZSBGSUZP
IE92ZXJydW4gKi8NCiAJR01fSVNfUlhfQ09NUEwJPSAxPDwwLAkvKiBGcmFtZSBSZWNlcHRpb24g
Q29tcGxldGUgKi8NCiANCi0jZGVmaW5lIEdNQUNfREVGX01TSyAgICAgR01fSVNfVFhfRkZfVVIN
CisjZGVmaW5lIEdNQUNfREVGX01TSyAgICAgKEdNX0lTX1RYX0ZGX1VSIHwgR01fSVNfUlhfRkZf
T1IpDQogfTsNCiANCiAvKglHTUFDX0xJTktfQ1RSTAkxNiBiaXQJR01BQyBMaW5rIENvbnRyb2wg
UmVnIChZVUtPTiBvbmx5KSAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21p
Y3JlbC9rczg4NTEuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21pY3JlbC9rczg4NTEuYw0KaW5k
ZXggZjU2NzQzYS4uMTE1ZTM3NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21p
Y3JlbC9rczg4NTEuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcmVsL2tzODg1MS5j
DQpAQCAtNDkwLDcgKzQ5MCw3IEBAIHN0YXRpYyB2b2lkIGtzODg1MV9yeF9wa3RzKHN0cnVjdCBr
czg4NTFfbmV0ICprcykNCiAJZm9yICg7IHJ4ZmMgIT0gMDsgcnhmYy0tKSB7DQogCQlyeGggPSBr
czg4NTFfcmRyZWczMihrcywgS1NfUlhGSFNSKTsNCiAJCXJ4c3RhdCA9IHJ4aCAmIDB4ZmZmZjsN
Ci0JCXJ4bGVuID0gcnhoID4+IDE2Ow0KKwkJcnhsZW4gPSAocnhoID4+IDE2KSAmIDB4ZmZmOw0K
IA0KIAkJbmV0aWZfZGJnKGtzLCByeF9zdGF0dXMsIGtzLT5uZXRkZXYsDQogCQkJICAicng6IHN0
YXQgMHglMDR4LCBsZW4gMHglMDR4XG4iLCByeHN0YXQsIHJ4bGVuKTsNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9va2ktc2VtaS9wY2hfZ2JlL3BjaF9nYmVfbWFpbi5jIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvb2tpLXNlbWkvcGNoX2diZS9wY2hfZ2JlX21haW4uYw0KaW5kZXgg
NDNjN2IyNS4uNDk1ZDY1YyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L29raS1z
ZW1pL3BjaF9nYmUvcGNoX2diZV9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L29r
aS1zZW1pL3BjaF9nYmUvcGNoX2diZV9tYWluLmMNCkBAIC0xNTQ1LDkgKzE1NDUsOSBAQCBwY2hf
Z2JlX2NsZWFuX3J4KHN0cnVjdCBwY2hfZ2JlX2FkYXB0ZXIgKmFkYXB0ZXIsDQogCQkJc2tiX3B1
dChza2IsIGxlbmd0aCk7DQogCQkJc2tiLT5wcm90b2NvbCA9IGV0aF90eXBlX3RyYW5zKHNrYiwg
bmV0ZGV2KTsNCiAJCQlpZiAodGNwX2lwX3N0YXR1cyAmIFBDSF9HQkVfUlhEX0FDQ19TVEFUX1RD
UElQT0spDQotCQkJCXNrYi0+aXBfc3VtbWVkID0gQ0hFQ0tTVU1fTk9ORTsNCi0JCQllbHNlDQog
CQkJCXNrYi0+aXBfc3VtbWVkID0gQ0hFQ0tTVU1fVU5ORUNFU1NBUlk7DQorCQkJZWxzZQ0KKwkJ
CQlza2ItPmlwX3N1bW1lZCA9IENIRUNLU1VNX05PTkU7DQogDQogCQkJbmFwaV9ncm9fcmVjZWl2
ZSgmYWRhcHRlci0+bmFwaSwgc2tiKTsNCiAJCQkoKndvcmtfZG9uZSkrKzsNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC90aS9kYXZpbmNpX2VtYWMuYyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3RpL2RhdmluY2lfZW1hYy5jDQppbmRleCAyMmYyNzg4Li5mZDgxMTVlIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvdGkvZGF2aW5jaV9lbWFjLmMNCisrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3RpL2RhdmluY2lfZW1hYy5jDQpAQCAtMTA0OCw3ICsxMDQ4LDcgQEAg
c3RhdGljIHZvaWQgZW1hY190eF9oYW5kbGVyKHZvaWQgKnRva2VuLCBpbnQgbGVuLCBpbnQgc3Rh
dHVzKQ0KIAlzdHJ1Y3QgbmV0X2RldmljZQkqbmRldiA9IHNrYi0+ZGV2Ow0KIA0KIAlpZiAodW5s
aWtlbHkobmV0aWZfcXVldWVfc3RvcHBlZChuZGV2KSkpDQotCQluZXRpZl9zdGFydF9xdWV1ZShu
ZGV2KTsNCisJCW5ldGlmX3dha2VfcXVldWUobmRldik7DQogCW5kZXYtPnN0YXRzLnR4X3BhY2tl
dHMrKzsNCiAJbmRldi0+c3RhdHMudHhfYnl0ZXMgKz0gbGVuOw0KIAlkZXZfa2ZyZWVfc2tiX2Fu
eShza2IpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9zbXNjNzV4eC5jIGIvZHJpdmVy
cy9uZXQvdXNiL3Ntc2M3NXh4LmMNCmluZGV4IDdiZDIxOWIuLmYzZDE3ZjggMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC91c2Ivc21zYzc1eHguYw0KKysrIGIvZHJpdmVycy9uZXQvdXNiL3Ntc2M3
NXh4LmMNCkBAIC03MjAsOCArNzIwLDEyIEBAIHN0YXRpYyBpbnQgc21zYzc1eHhfc2V0X3J4X21h
eF9mcmFtZV9sZW5ndGgoc3RydWN0IHVzYm5ldCAqZGV2LCBpbnQgc2l6ZSkNCiBzdGF0aWMgaW50
IHNtc2M3NXh4X2NoYW5nZV9tdHUoc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiwgaW50IG5ld19t
dHUpDQogew0KIAlzdHJ1Y3QgdXNibmV0ICpkZXYgPSBuZXRkZXZfcHJpdihuZXRkZXYpOw0KKwlp
bnQgcmV0Ow0KKw0KKwlpZiAobmV3X210dSA+IE1BWF9TSU5HTEVfUEFDS0VUX1NJWkUpDQorCQly
ZXR1cm4gLUVJTlZBTDsNCiANCi0JaW50IHJldCA9IHNtc2M3NXh4X3NldF9yeF9tYXhfZnJhbWVf
bGVuZ3RoKGRldiwgbmV3X210dSk7DQorCXJldCA9IHNtc2M3NXh4X3NldF9yeF9tYXhfZnJhbWVf
bGVuZ3RoKGRldiwgbmV3X210dSArIEVUSF9ITEVOKTsNCiAJY2hlY2tfd2Fybl9yZXR1cm4ocmV0
LCAiRmFpbGVkIHRvIHNldCBtYWMgcnggZnJhbWUgbGVuZ3RoIik7DQogDQogCXJldHVybiB1c2Ju
ZXRfY2hhbmdlX210dShuZXRkZXYsIG5ld19tdHUpOw0KQEAgLTk2NSw3ICs5NjksNyBAQCBzdGF0
aWMgaW50IHNtc2M3NXh4X3Jlc2V0KHN0cnVjdCB1c2JuZXQgKmRldikNCiANCiAJbmV0aWZfZGJn
KGRldiwgaWZ1cCwgZGV2LT5uZXQsICJGQ1RfVFhfQ1RMIHNldCB0byAweCUwOHgiLCBidWYpOw0K
IA0KLQlyZXQgPSBzbXNjNzV4eF9zZXRfcnhfbWF4X2ZyYW1lX2xlbmd0aChkZXYsIDE1MTQpOw0K
KwlyZXQgPSBzbXNjNzV4eF9zZXRfcnhfbWF4X2ZyYW1lX2xlbmd0aChkZXYsIGRldi0+bmV0LT5t
dHUgKyBFVEhfSExFTik7DQogCWNoZWNrX3dhcm5fcmV0dXJuKHJldCwgIkZhaWxlZCB0byBzZXQg
bWF4IHJ4IGZyYW1lIGxlbmd0aCIpOw0KIA0KIAlyZXQgPSBzbXNjNzV4eF9yZWFkX3JlZyhkZXYs
IE1BQ19SWCwgJmJ1Zik7DQpAQCAtMTEwOSw4ICsxMTEzLDggQEAgc3RhdGljIGludCBzbXNjNzV4
eF9yeF9maXh1cChzdHJ1Y3QgdXNibmV0ICpkZXYsIHN0cnVjdCBza19idWZmICpza2IpDQogCQkJ
ZWxzZSBpZiAocnhfY21kX2EgJiAoUlhfQ01EX0FfTE9ORyB8IFJYX0NNRF9BX1JVTlQpKQ0KIAkJ
CQlkZXYtPm5ldC0+c3RhdHMucnhfZnJhbWVfZXJyb3JzKys7DQogCQl9IGVsc2Ugew0KLQkJCS8q
IEVUSF9GUkFNRV9MRU4gKyA0KENSQykgKyAyKENPRSkgKyA0KFZsYW4pICovDQotCQkJaWYgKHVu
bGlrZWx5KHNpemUgPiAoRVRIX0ZSQU1FX0xFTiArIDEyKSkpIHsNCisJCQkvKiBNQVhfU0lOR0xF
X1BBQ0tFVF9TSVpFICsgNChDUkMpICsgMihDT0UpICsgNChWbGFuKSAqLw0KKwkJCWlmICh1bmxp
a2VseShzaXplID4gKE1BWF9TSU5HTEVfUEFDS0VUX1NJWkUgKyBFVEhfSExFTiArIDEyKSkpIHsN
CiAJCQkJbmV0aWZfZGJnKGRldiwgcnhfZXJyLCBkZXYtPm5ldCwNCiAJCQkJCSJzaXplIGVyciBy
eF9jbWRfYT0weCUwOHgiLCByeF9jbWRfYSk7DQogCQkJCXJldHVybiAwOw0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDNfY2FsaWIuYyBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDNfY2FsaWIuYw0KaW5kZXggYWU3NTBmOS4uMzk2
NTM1NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDNf
Y2FsaWIuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2FyOTAwM19jYWxp
Yi5jDQpAQCAtOTQ2LDYgKzk0Niw3IEBAIHN0YXRpYyBib29sIGFyOTAwM19od19pbml0X2NhbChz
dHJ1Y3QgYXRoX2h3ICphaCwNCiAJCQkJCSAgQVJfUEhZX0NMX1RBQl8xLA0KIAkJCQkJICBBUl9Q
SFlfQ0xfVEFCXzIgfTsNCiANCisJLyogVXNlIGNoaXAgY2hhaW5tYXNrIG9ubHkgZm9yIGNhbGli
cmF0aW9uICovDQogCWFyOTAwM19od19zZXRfY2hhaW5fbWFza3MoYWgsIGFoLT5jYXBzLnJ4X2No
YWlubWFzaywgYWgtPmNhcHMudHhfY2hhaW5tYXNrKTsNCiANCiAJaWYgKHJ0dCkgew0KQEAgLTEw
ODcsNiArMTA4OCw5IEBAIHNraXBfdHhfaXFjYWw6DQogCQlhcjkwMDNfaHdfcnR0X2Rpc2FibGUo
YWgpOw0KIAl9DQogDQorCS8qIFJldmVydCBjaGFpbm1hc2sgdG8gcnVudGltZSBwYXJhbWV0ZXJz
ICovDQorCWFyOTAwM19od19zZXRfY2hhaW5fbWFza3MoYWgsIGFoLT5yeGNoYWlubWFzaywgYWgt
PnR4Y2hhaW5tYXNrKTsNCisNCiAJLyogSW5pdGlhbGl6ZSBsaXN0IHBvaW50ZXJzICovDQogCWFo
LT5jYWxfbGlzdCA9IGFoLT5jYWxfbGlzdF9sYXN0ID0gYWgtPmNhbF9saXN0X2N1cnIgPSBOVUxM
Ow0KIAlhaC0+c3VwcF9jYWxzID0gSVFfTUlTTUFUQ0hfQ0FMOw0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2I0My9kbWEuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9kbWEu
Yw0KaW5kZXggNWU0NTYwNC4uMTI5NzVhZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2I0My9kbWEuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL2RtYS5jDQpAQCAt
MTQ4Miw4ICsxNDgyLDEyIEBAIHZvaWQgYjQzX2RtYV9oYW5kbGVfdHhzdGF0dXMoc3RydWN0IGI0
M193bGRldiAqZGV2LA0KIAljb25zdCBzdHJ1Y3QgYjQzX2RtYV9vcHMgKm9wczsNCiAJc3RydWN0
IGI0M19kbWFyaW5nICpyaW5nOw0KIAlzdHJ1Y3QgYjQzX2RtYWRlc2NfbWV0YSAqbWV0YTsNCisJ
c3RhdGljIGNvbnN0IHN0cnVjdCBiNDNfdHhzdGF0dXMgZmFrZTsgLyogZmlsbGVkIHdpdGggMCAq
Lw0KKwljb25zdCBzdHJ1Y3QgYjQzX3R4c3RhdHVzICp0eHN0YXQ7DQogCWludCBzbG90LCBmaXJz
dHVzZWQ7DQogCWJvb2wgZnJhbWVfc3VjY2VlZDsNCisJaW50IHNraXA7DQorCXN0YXRpYyB1OCBl
cnJfb3V0MSwgZXJyX291dDI7DQogDQogCXJpbmcgPSBwYXJzZV9jb29raWUoZGV2LCBzdGF0dXMt
PmNvb2tpZSwgJnNsb3QpOw0KIAlpZiAodW5saWtlbHkoIXJpbmcpKQ0KQEAgLTE0OTYsMTMgKzE1
MDAsMzYgQEAgdm9pZCBiNDNfZG1hX2hhbmRsZV90eHN0YXR1cyhzdHJ1Y3QgYjQzX3dsZGV2ICpk
ZXYsDQogCWZpcnN0dXNlZCA9IHJpbmctPmN1cnJlbnRfc2xvdCAtIHJpbmctPnVzZWRfc2xvdHMg
KyAxOw0KIAlpZiAoZmlyc3R1c2VkIDwgMCkNCiAJCWZpcnN0dXNlZCA9IHJpbmctPm5yX3Nsb3Rz
ICsgZmlyc3R1c2VkOw0KKw0KKwlza2lwID0gMDsNCiAJaWYgKHVubGlrZWx5KHNsb3QgIT0gZmly
c3R1c2VkKSkgew0KIAkJLyogVGhpcyBwb3NzaWJseSBpcyBhIGZpcm13YXJlIGJ1ZyBhbmQgd2ls
bCByZXN1bHQgaW4NCi0JCSAqIG1hbGZ1bmN0aW9uLCBtZW1vcnkgbGVha3MgYW5kL29yIHN0YWxs
IG9mIERNQSBmdW5jdGlvbmFsaXR5LiAqLw0KLQkJYjQzZGJnKGRldi0+d2wsICJPdXQgb2Ygb3Jk
ZXIgVFggc3RhdHVzIHJlcG9ydCBvbiBETUEgcmluZyAlZC4gIg0KLQkJICAgICAgICJFeHBlY3Rl
ZCAlZCwgYnV0IGdvdCAlZFxuIiwNCi0JCSAgICAgICByaW5nLT5pbmRleCwgZmlyc3R1c2VkLCBz
bG90KTsNCi0JCXJldHVybjsNCisJCSAqIG1hbGZ1bmN0aW9uLCBtZW1vcnkgbGVha3MgYW5kL29y
IHN0YWxsIG9mIERNQSBmdW5jdGlvbmFsaXR5Lg0KKwkJICovDQorCQlpZiAoc2xvdCA9PSBuZXh0
X3Nsb3QocmluZywgbmV4dF9zbG90KHJpbmcsIGZpcnN0dXNlZCkpKSB7DQorCQkJLyogSWYgYSBz
aW5nbGUgaGVhZGVyL2RhdGEgcGFpciB3YXMgbWlzc2VkLCBza2lwIG92ZXINCisJCQkgKiB0aGUg
Zmlyc3QgdHdvIHNsb3RzIGluIGFuIGF0dGVtcHQgdG8gcmVjb3Zlci4NCisJCQkgKi8NCisJCQlz
bG90ID0gZmlyc3R1c2VkOw0KKwkJCXNraXAgPSAyOw0KKwkJCWlmICghZXJyX291dDEpIHsNCisJ
CQkJLyogUmVwb3J0IHRoZSBlcnJvciBvbmNlLiAqLw0KKwkJCQliNDNkYmcoZGV2LT53bCwNCisJ
CQkJICAgICAgICJTa2lwIG9uIERNQSByaW5nICVkIHNsb3QgJWQuXG4iLA0KKwkJCQkgICAgICAg
cmluZy0+aW5kZXgsIHNsb3QpOw0KKwkJCQllcnJfb3V0MSA9IDE7DQorCQkJfQ0KKwkJfSBlbHNl
IHsNCisJCQkvKiBNb3JlIHRoYW4gYSBzaW5nbGUgaGVhZGVyL2RhdGEgcGFpciB3ZXJlIG1pc3Nl
ZC4NCisJCQkgKiBSZXBvcnQgdGhpcyBlcnJvciBvbmNlLg0KKwkJCSAqLw0KKwkJCWlmICghZXJy
X291dDIpDQorCQkJCWI0M2RiZyhkZXYtPndsLA0KKwkJCQkgICAgICAgIk91dCBvZiBvcmRlciBU
WCBzdGF0dXMgcmVwb3J0IG9uIERNQSByaW5nICVkLiBFeHBlY3RlZCAlZCwgYnV0IGdvdCAlZFxu
IiwNCisJCQkJICAgICAgIHJpbmctPmluZGV4LCBmaXJzdHVzZWQsIHNsb3QpOw0KKwkJCWVycl9v
dXQyID0gMTsNCisJCQlyZXR1cm47DQorCQl9DQogCX0NCiANCiAJb3BzID0gcmluZy0+b3BzOw0K
QEAgLTE1MTcsMTEgKzE1NDQsMTMgQEAgdm9pZCBiNDNfZG1hX2hhbmRsZV90eHN0YXR1cyhzdHJ1
Y3QgYjQzX3dsZGV2ICpkZXYsDQogCQkJICAgICAgIHNsb3QsIGZpcnN0dXNlZCwgcmluZy0+aW5k
ZXgpOw0KIAkJCWJyZWFrOw0KIAkJfQ0KKw0KIAkJaWYgKG1ldGEtPnNrYikgew0KIAkJCXN0cnVj
dCBiNDNfcHJpdmF0ZV90eF9pbmZvICpwcml2X2luZm8gPQ0KLQkJCQliNDNfZ2V0X3ByaXZfdHhf
aW5mbyhJRUVFODAyMTFfU0tCX0NCKG1ldGEtPnNrYikpOw0KKwkJCSAgICAgYjQzX2dldF9wcml2
X3R4X2luZm8oSUVFRTgwMjExX1NLQl9DQihtZXRhLT5za2IpKTsNCiANCi0JCQl1bm1hcF9kZXNj
YnVmZmVyKHJpbmcsIG1ldGEtPmRtYWFkZHIsIG1ldGEtPnNrYi0+bGVuLCAxKTsNCisJCQl1bm1h
cF9kZXNjYnVmZmVyKHJpbmcsIG1ldGEtPmRtYWFkZHIsDQorCQkJCQkgbWV0YS0+c2tiLT5sZW4s
IDEpOw0KIAkJCWtmcmVlKHByaXZfaW5mby0+Ym91bmNlYnVmZmVyKTsNCiAJCQlwcml2X2luZm8t
PmJvdW5jZWJ1ZmZlciA9IE5VTEw7DQogCQl9IGVsc2Ugew0KQEAgLTE1MzMsOCArMTU2Miw5IEBA
IHZvaWQgYjQzX2RtYV9oYW5kbGVfdHhzdGF0dXMoc3RydWN0IGI0M193bGRldiAqZGV2LA0KIAkJ
CXN0cnVjdCBpZWVlODAyMTFfdHhfaW5mbyAqaW5mbzsNCiANCiAJCQlpZiAodW5saWtlbHkoIW1l
dGEtPnNrYikpIHsNCi0JCQkJLyogVGhpcyBpcyBhIHNjYXR0ZXItZ2F0aGVyIGZyYWdtZW50IG9m
IGEgZnJhbWUsIHNvDQotCQkJCSAqIHRoZSBza2IgcG9pbnRlciBtdXN0IG5vdCBiZSBOVUxMLiAq
Lw0KKwkJCQkvKiBUaGlzIGlzIGEgc2NhdHRlci1nYXRoZXIgZnJhZ21lbnQgb2YgYSBmcmFtZSwN
CisJCQkJICogc28gdGhlIHNrYiBwb2ludGVyIG11c3Qgbm90IGJlIE5VTEwuDQorCQkJCSAqLw0K
IAkJCQliNDNkYmcoZGV2LT53bCwgIlRYIHN0YXR1cyB1bmV4cGVjdGVkIE5VTEwgc2tiICINCiAJ
CQkJICAgICAgICJhdCBzbG90ICVkIChmaXJzdD0lZCkgb24gcmluZyAlZFxuIiwNCiAJCQkJICAg
ICAgIHNsb3QsIGZpcnN0dXNlZCwgcmluZy0+aW5kZXgpOw0KQEAgLTE1NDUsOSArMTU3NSwxOCBA
QCB2b2lkIGI0M19kbWFfaGFuZGxlX3R4c3RhdHVzKHN0cnVjdCBiNDNfd2xkZXYgKmRldiwNCiAN
CiAJCQkvKg0KIAkJCSAqIENhbGwgYmFjayB0byBpbmZvcm0gdGhlIGllZWU4MDIxMSBzdWJzeXN0
ZW0gYWJvdXQNCi0JCQkgKiB0aGUgc3RhdHVzIG9mIHRoZSB0cmFuc21pc3Npb24uDQorCQkJICog
dGhlIHN0YXR1cyBvZiB0aGUgdHJhbnNtaXNzaW9uLiBXaGVuIHNraXBwaW5nIG92ZXINCisJCQkg
KiBhIG1pc3NlZCBUWCBzdGF0dXMgcmVwb3J0LCB1c2UgYSBzdGF0dXMgc3RydWN0dXJlDQorCQkJ
ICogZmlsbGVkIHdpdGggemVyb3MgdG8gaW5kaWNhdGUgdGhhdCB0aGUgZnJhbWUgd2FzIG5vdA0K
KwkJCSAqIHNlbnQgKGZyYW1lX2NvdW50IDApIGFuZCBub3QgYWNrbm93bGVkZ2VkDQogCQkJICov
DQotCQkJZnJhbWVfc3VjY2VlZCA9IGI0M19maWxsX3R4c3RhdHVzX3JlcG9ydChkZXYsIGluZm8s
IHN0YXR1cyk7DQorCQkJaWYgKHVubGlrZWx5KHNraXApKQ0KKwkJCQl0eHN0YXQgPSAmZmFrZTsN
CisJCQllbHNlDQorCQkJCXR4c3RhdCA9IHN0YXR1czsNCisNCisJCQlmcmFtZV9zdWNjZWVkID0g
YjQzX2ZpbGxfdHhzdGF0dXNfcmVwb3J0KGRldiwgaW5mbywNCisJCQkJCQkJCSB0eHN0YXQpOw0K
ICNpZmRlZiBDT05GSUdfQjQzX0RFQlVHDQogCQkJaWYgKGZyYW1lX3N1Y2NlZWQpDQogCQkJCXJp
bmctPm5yX3N1Y2NlZWRfdHhfcGFja2V0cysrOw0KQEAgLTE1NzUsMTIgKzE2MTQsMTQgQEAgdm9p
ZCBiNDNfZG1hX2hhbmRsZV90eHN0YXR1cyhzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYsDQogCQkvKiBF
dmVyeXRoaW5nIHVubWFwcGVkIGFuZCBmcmVlJ2QuIFNvIGl0J3Mgbm90IHVzZWQgYW55bW9yZS4g
Ki8NCiAJCXJpbmctPnVzZWRfc2xvdHMtLTsNCiANCi0JCWlmIChtZXRhLT5pc19sYXN0X2ZyYWdt
ZW50KSB7DQorCQlpZiAobWV0YS0+aXNfbGFzdF9mcmFnbWVudCAmJiAhc2tpcCkgew0KIAkJCS8q
IFRoaXMgaXMgdGhlIGxhc3Qgc2NhdHRlci1nYXRoZXINCiAJCQkgKiBmcmFnbWVudCBvZiB0aGUg
ZnJhbWUuIFdlIGFyZSBkb25lLiAqLw0KIAkJCWJyZWFrOw0KIAkJfQ0KIAkJc2xvdCA9IG5leHRf
c2xvdChyaW5nLCBzbG90KTsNCisJCWlmIChza2lwID4gMCkNCisJCQktLXNraXA7DQogCX0NCiAJ
aWYgKHJpbmctPnN0b3BwZWQpIHsNCiAJCUI0M19XQVJOX09OKGZyZWVfc2xvdHMocmluZykgPCBU
WF9TTE9UU19QRVJfRlJBTUUpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0
MngwMC9ydDJ4MDBkZXYuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDJ4MDBkZXYu
Yw0KaW5kZXggZjA5OWIzMC4uM2RlOTg3NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3J0MngwMC9ydDJ4MDBkZXYuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnQyeDAw
L3J0MngwMGRldi5jDQpAQCAtMTE0Niw3ICsxMTQ2LDkgQEAgaW50IHJ0MngwMGxpYl9wcm9iZV9k
ZXYoc3RydWN0IHJ0MngwMF9kZXYgKnJ0MngwMGRldikNCiAJCXJ0MngwMGRldi0+aHctPndpcGh5
LT5pbnRlcmZhY2VfbW9kZXMgfD0NCiAJCSAgICBCSVQoTkw4MDIxMV9JRlRZUEVfQURIT0MpIHwN
CiAJCSAgICBCSVQoTkw4MDIxMV9JRlRZUEVfQVApIHwNCisjaWZkZWYgQ09ORklHX01BQzgwMjEx
X01FU0gNCiAJCSAgICBCSVQoTkw4MDIxMV9JRlRZUEVfTUVTSF9QT0lOVCkgfA0KKyNlbmRpZg0K
IAkJICAgIEJJVChOTDgwMjExX0lGVFlQRV9XRFMpOw0KIA0KIAkvKg0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvdXNiLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9y
dGx3aWZpL3VzYi5jDQppbmRleCBjMDRlZTkyLi5lNWZlOTU2IDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvcnRsd2lmaS91c2IuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cnRsd2lmaS91c2IuYw0KQEAgLTgxMiw2ICs4MTIsNyBAQCBzdGF0aWMgdm9pZCBfcnRsX3VzYl90
cmFuc21pdChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJ
aWYgKHVubGlrZWx5KCFfdXJiKSkgew0KIAkJUlRfVFJBQ0UocnRscHJpdiwgQ09NUF9FUlIsIERC
R19FTUVSRywNCiAJCQkgKCJDYW4ndCBhbGxvY2F0ZSB1cmIuIERyb3Agc2tiIVxuIikpOw0KKwkJ
a2ZyZWVfc2tiKHNrYik7DQogCQlyZXR1cm47DQogCX0NCiAJdXJiX2xpc3QgPSAmcnRsdXNiLT50
eF9wZW5kaW5nW2VwX251bV07DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zcGkvc3BpLW1wYzUxMngt
cHNjLmMgYi9kcml2ZXJzL3NwaS9zcGktbXBjNTEyeC1wc2MuYw0KaW5kZXggNGM2M2Y3Ny4uMmUy
YjA0ZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3BpL3NwaS1tcGM1MTJ4LXBzYy5jDQorKysgYi9k
cml2ZXJzL3NwaS9zcGktbXBjNTEyeC1wc2MuYw0KQEAgLTE2NCw3ICsxNjQsNyBAQCBzdGF0aWMg
aW50IG1wYzUxMnhfcHNjX3NwaV90cmFuc2Zlcl9yeHR4KHN0cnVjdCBzcGlfZGV2aWNlICpzcGks
DQogDQogCQlmb3IgKGkgPSBjb3VudDsgaSA+IDA7IGktLSkgew0KIAkJCWRhdGEgPSB0eF9idWYg
PyAqdHhfYnVmKysgOiAwOw0KLQkJCWlmIChsZW4gPT0gRU9GQllURSkNCisJCQlpZiAobGVuID09
IEVPRkJZVEUgJiYgdC0+Y3NfY2hhbmdlKQ0KIAkJCQlzZXRiaXRzMzIoJmZpZm8tPnR4Y21kLCBN
UEM1MTJ4X1BTQ19GSUZPX0VPRik7DQogCQkJb3V0XzgoJmZpZm8tPnR4ZGF0YV84LCBkYXRhKTsN
CiAJCQlsZW4tLTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvY29tZWRpL2RyaXZlcnMv
czYyNi5jIGIvZHJpdmVycy9zdGFnaW5nL2NvbWVkaS9kcml2ZXJzL3M2MjYuYw0KaW5kZXggYzcy
MTI4Zi4uNDJjYWQ1YyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy9jb21lZGkvZHJpdmVy
cy9zNjI2LmMNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy9jb21lZGkvZHJpdmVycy9zNjI2LmMNCkBA
IC0xODgyLDcgKzE4ODIsNyBAQCBzdGF0aWMgaW50IHM2MjZfYWlfY21kKHN0cnVjdCBjb21lZGlf
ZGV2aWNlICpkZXYsIHN0cnVjdCBjb21lZGlfc3ViZGV2aWNlICpzKQ0KIAljYXNlIFRSSUdfTk9O
RToNCiAJCS8qICBjb250aW5vdXMgYWNxdWlzaXRpb24gKi8NCiAJCWRldnByaXYtPmFpX2NvbnRp
bm91cyA9IDE7DQotCQlkZXZwcml2LT5haV9zYW1wbGVfY291bnQgPSAwOw0KKwkJZGV2cHJpdi0+
YWlfc2FtcGxlX2NvdW50ID0gMTsNCiAJCWJyZWFrOw0KIAl9DQogDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy90dHkvc2VyaWFsL2F0bWVsX3NlcmlhbC5jIGIvZHJpdmVycy90dHkvc2VyaWFsL2F0bWVs
X3NlcmlhbC5jDQppbmRleCA5MGM4ZTNhLi45OWZjYjhjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy90
dHkvc2VyaWFsL2F0bWVsX3NlcmlhbC5jDQorKysgYi9kcml2ZXJzL3R0eS9zZXJpYWwvYXRtZWxf
c2VyaWFsLmMNCkBAIC0xNTksNyArMTU5LDcgQEAgc3RydWN0IGF0bWVsX3VhcnRfcG9ydCB7DQog
fTsNCiANCiBzdGF0aWMgc3RydWN0IGF0bWVsX3VhcnRfcG9ydCBhdG1lbF9wb3J0c1tBVE1FTF9N
QVhfVUFSVF07DQotc3RhdGljIHVuc2lnbmVkIGxvbmcgYXRtZWxfcG9ydHNfaW5fdXNlOw0KK3N0
YXRpYyBERUNMQVJFX0JJVE1BUChhdG1lbF9wb3J0c19pbl91c2UsIEFUTUVMX01BWF9VQVJUKTsN
CiANCiAjaWZkZWYgU1VQUE9SVF9TWVNSUQ0KIHN0YXRpYyBzdHJ1Y3QgY29uc29sZSBhdG1lbF9j
b25zb2xlOw0KQEAgLTE3ODQsMTUgKzE3ODQsMTQgQEAgc3RhdGljIGludCBfX2RldmluaXQgYXRt
ZWxfc2VyaWFsX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQogCWlmIChyZXQg
PCAwKQ0KIAkJLyogcG9ydCBpZCBub3QgZm91bmQgaW4gcGxhdGZvcm0gZGF0YSBub3IgZGV2aWNl
LXRyZWUgYWxpYXNlczoNCiAJCSAqIGF1dG8tZW51bWVyYXRlIGl0ICovDQotCQlyZXQgPSBmaW5k
X2ZpcnN0X3plcm9fYml0KCZhdG1lbF9wb3J0c19pbl91c2UsDQotCQkJCXNpemVvZihhdG1lbF9w
b3J0c19pbl91c2UpKTsNCisJCXJldCA9IGZpbmRfZmlyc3RfemVyb19iaXQoYXRtZWxfcG9ydHNf
aW5fdXNlLCBBVE1FTF9NQVhfVUFSVCk7DQogDQotCWlmIChyZXQgPiBBVE1FTF9NQVhfVUFSVCkg
ew0KKwlpZiAocmV0ID49IEFUTUVMX01BWF9VQVJUKSB7DQogCQlyZXQgPSAtRU5PREVWOw0KIAkJ
Z290byBlcnI7DQogCX0NCiANCi0JaWYgKHRlc3RfYW5kX3NldF9iaXQocmV0LCAmYXRtZWxfcG9y
dHNfaW5fdXNlKSkgew0KKwlpZiAodGVzdF9hbmRfc2V0X2JpdChyZXQsIGF0bWVsX3BvcnRzX2lu
X3VzZSkpIHsNCiAJCS8qIHBvcnQgYWxyZWFkeSBpbiB1c2UgKi8NCiAJCXJldCA9IC1FQlVTWTsN
CiAJCWdvdG8gZXJyOw0KQEAgLTE4NjYsNyArMTg2NSw3IEBAIHN0YXRpYyBpbnQgX19kZXZleGl0
IGF0bWVsX3NlcmlhbF9yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCiANCiAJ
LyogInBvcnQiIGlzIGFsbG9jYXRlZCBzdGF0aWNhbGx5LCBzbyB3ZSBzaG91bGRuJ3QgZnJlZSBp
dCAqLw0KIA0KLQljbGVhcl9iaXQocG9ydC0+bGluZSwgJmF0bWVsX3BvcnRzX2luX3VzZSk7DQor
CWNsZWFyX2JpdChwb3J0LT5saW5lLCBhdG1lbF9wb3J0c19pbl91c2UpOw0KIA0KIAljbGtfcHV0
KGF0bWVsX3BvcnQtPmNsayk7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy90dHkvdnQvdmNfc2Ny
ZWVuLmMgYi9kcml2ZXJzL3R0eS92dC92Y19zY3JlZW4uYw0KaW5kZXggN2EzNjdmZi4uZmQ4OWM0
MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdHR5L3Z0L3ZjX3NjcmVlbi5jDQorKysgYi9kcml2ZXJz
L3R0eS92dC92Y19zY3JlZW4uYw0KQEAgLTkzLDcgKzkzLDcgQEAgdmNzX3BvbGxfZGF0YV9mcmVl
KHN0cnVjdCB2Y3NfcG9sbF9kYXRhICpwb2xsKQ0KIHN0YXRpYyBzdHJ1Y3QgdmNzX3BvbGxfZGF0
YSAqDQogdmNzX3BvbGxfZGF0YV9nZXQoc3RydWN0IGZpbGUgKmZpbGUpDQogew0KLQlzdHJ1Y3Qg
dmNzX3BvbGxfZGF0YSAqcG9sbCA9IGZpbGUtPnByaXZhdGVfZGF0YTsNCisJc3RydWN0IHZjc19w
b2xsX2RhdGEgKnBvbGwgPSBmaWxlLT5wcml2YXRlX2RhdGEsICpraWxsID0gTlVMTDsNCiANCiAJ
aWYgKHBvbGwpDQogCQlyZXR1cm4gcG9sbDsNCkBAIC0xMjIsMTAgKzEyMiwxMiBAQCB2Y3NfcG9s
bF9kYXRhX2dldChzdHJ1Y3QgZmlsZSAqZmlsZSkNCiAJCWZpbGUtPnByaXZhdGVfZGF0YSA9IHBv
bGw7DQogCX0gZWxzZSB7DQogCQkvKiBzb21lb25lIGVsc2UgcmFjZWQgYWhlYWQgb2YgdXMgKi8N
Ci0JCXZjc19wb2xsX2RhdGFfZnJlZShwb2xsKTsNCisJCWtpbGwgPSBwb2xsOw0KIAkJcG9sbCA9
IGZpbGUtPnByaXZhdGVfZGF0YTsNCiAJfQ0KIAlzcGluX3VubG9jaygmZmlsZS0+Zl9sb2NrKTsN
CisJaWYgKGtpbGwpDQorCQl2Y3NfcG9sbF9kYXRhX2ZyZWUoa2lsbCk7DQogDQogCXJldHVybiBw
b2xsOw0KIH0NCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9ob3N0L3hoY2ktcmluZy5jIGIvZHJp
dmVycy91c2IvaG9zdC94aGNpLXJpbmcuYw0KaW5kZXggNWMxZjllNy4uMzdiMmE4OSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1yaW5nLmMNCisrKyBiL2RyaXZlcnMvdXNiL2hv
c3QveGhjaS1yaW5nLmMNCkBAIC0xOTY0LDggKzE5NjQsOCBAQCBzdGF0aWMgaW50IHByb2Nlc3Nf
Y3RybF90ZChzdHJ1Y3QgeGhjaV9oY2QgKnhoY2ksIHN0cnVjdCB4aGNpX3RkICp0ZCwNCiAJCWlm
IChldmVudF90cmIgIT0gZXBfcmluZy0+ZGVxdWV1ZSAmJg0KIAkJCQlldmVudF90cmIgIT0gdGQt
Pmxhc3RfdHJiKQ0KIAkJCXRkLT51cmItPmFjdHVhbF9sZW5ndGggPQ0KLQkJCQl0ZC0+dXJiLT50
cmFuc2Zlcl9idWZmZXJfbGVuZ3RoDQotCQkJCS0gVFJCX0xFTihsZTMyX3RvX2NwdShldmVudC0+
dHJhbnNmZXJfbGVuKSk7DQorCQkJCXRkLT51cmItPnRyYW5zZmVyX2J1ZmZlcl9sZW5ndGggLQ0K
KwkJCQlFVkVOVF9UUkJfTEVOKGxlMzJfdG9fY3B1KGV2ZW50LT50cmFuc2Zlcl9sZW4pKTsNCiAJ
CWVsc2UNCiAJCQl0ZC0+dXJiLT5hY3R1YWxfbGVuZ3RoID0gMDsNCiANCkBAIC0xOTk3LDcgKzE5
OTcsNyBAQCBzdGF0aWMgaW50IHByb2Nlc3NfY3RybF90ZChzdHJ1Y3QgeGhjaV9oY2QgKnhoY2ks
IHN0cnVjdCB4aGNpX3RkICp0ZCwNCiAJCS8qIE1heWJlIHRoZSBldmVudCB3YXMgZm9yIHRoZSBk
YXRhIHN0YWdlPyAqLw0KIAkJCXRkLT51cmItPmFjdHVhbF9sZW5ndGggPQ0KIAkJCQl0ZC0+dXJi
LT50cmFuc2Zlcl9idWZmZXJfbGVuZ3RoIC0NCi0JCQkJVFJCX0xFTihsZTMyX3RvX2NwdShldmVu
dC0+dHJhbnNmZXJfbGVuKSk7DQorCQkJCUVWRU5UX1RSQl9MRU4obGUzMl90b19jcHUoZXZlbnQt
PnRyYW5zZmVyX2xlbikpOw0KIAkJCXhoY2lfZGJnKHhoY2ksICJXYWl0aW5nIGZvciBzdGF0dXMg
Ig0KIAkJCQkJInN0YWdlIGV2ZW50XG4iKTsNCiAJCQlyZXR1cm4gMDsNCkBAIC0yMDMzLDcgKzIw
MzMsNyBAQCBzdGF0aWMgaW50IHByb2Nlc3NfaXNvY190ZChzdHJ1Y3QgeGhjaV9oY2QgKnhoY2ks
IHN0cnVjdCB4aGNpX3RkICp0ZCwNCiAJLyogaGFuZGxlIGNvbXBsZXRpb24gY29kZSAqLw0KIAlz
d2l0Y2ggKHRyYl9jb21wX2NvZGUpIHsNCiAJY2FzZSBDT01QX1NVQ0NFU1M6DQotCQlpZiAoVFJC
X0xFTihsZTMyX3RvX2NwdShldmVudC0+dHJhbnNmZXJfbGVuKSkgPT0gMCkgew0KKwkJaWYgKEVW
RU5UX1RSQl9MRU4obGUzMl90b19jcHUoZXZlbnQtPnRyYW5zZmVyX2xlbikpID09IDApIHsNCiAJ
CQlmcmFtZS0+c3RhdHVzID0gMDsNCiAJCQlicmVhazsNCiAJCX0NCkBAIC0yMDc4LDcgKzIwNzgs
NyBAQCBzdGF0aWMgaW50IHByb2Nlc3NfaXNvY190ZChzdHJ1Y3QgeGhjaV9oY2QgKnhoY2ksIHN0
cnVjdCB4aGNpX3RkICp0ZCwNCiAJCQkJbGVuICs9IFRSQl9MRU4obGUzMl90b19jcHUoY3VyX3Ry
Yi0+Z2VuZXJpYy5maWVsZFsyXSkpOw0KIAkJfQ0KIAkJbGVuICs9IFRSQl9MRU4obGUzMl90b19j
cHUoY3VyX3RyYi0+Z2VuZXJpYy5maWVsZFsyXSkpIC0NCi0JCQlUUkJfTEVOKGxlMzJfdG9fY3B1
KGV2ZW50LT50cmFuc2Zlcl9sZW4pKTsNCisJCQlFVkVOVF9UUkJfTEVOKGxlMzJfdG9fY3B1KGV2
ZW50LT50cmFuc2Zlcl9sZW4pKTsNCiANCiAJCWlmICh0cmJfY29tcF9jb2RlICE9IENPTVBfU1RP
UF9JTlZBTCkgew0KIAkJCWZyYW1lLT5hY3R1YWxfbGVuZ3RoID0gbGVuOw0KQEAgLTIxMzYsNyAr
MjEzNiw3IEBAIHN0YXRpYyBpbnQgcHJvY2Vzc19idWxrX2ludHJfdGQoc3RydWN0IHhoY2lfaGNk
ICp4aGNpLCBzdHJ1Y3QgeGhjaV90ZCAqdGQsDQogCWNhc2UgQ09NUF9TVUNDRVNTOg0KIAkJLyog
RG91YmxlIGNoZWNrIHRoYXQgdGhlIEhXIHRyYW5zZmVycmVkIGV2ZXJ5dGhpbmcuICovDQogCQlp
ZiAoZXZlbnRfdHJiICE9IHRkLT5sYXN0X3RyYiB8fA0KLQkJCQlUUkJfTEVOKGxlMzJfdG9fY3B1
KGV2ZW50LT50cmFuc2Zlcl9sZW4pKSAhPSAwKSB7DQorCQkgICAgRVZFTlRfVFJCX0xFTihsZTMy
X3RvX2NwdShldmVudC0+dHJhbnNmZXJfbGVuKSkgIT0gMCkgew0KIAkJCXhoY2lfd2Fybih4aGNp
LCAiV0FSTiBTdWNjZXNzZnVsIGNvbXBsZXRpb24gIg0KIAkJCQkJIm9uIHNob3J0IFRYXG4iKTsN
CiAJCQlpZiAodGQtPnVyYi0+dHJhbnNmZXJfZmxhZ3MgJiBVUkJfU0hPUlRfTk9UX09LKQ0KQEAg
LTIxNjQsMTggKzIxNjQsMTggQEAgc3RhdGljIGludCBwcm9jZXNzX2J1bGtfaW50cl90ZChzdHJ1
Y3QgeGhjaV9oY2QgKnhoY2ksIHN0cnVjdCB4aGNpX3RkICp0ZCwNCiAJCQkJIiVkIGJ5dGVzIHVu
dHJhbnNmZXJyZWRcbiIsDQogCQkJCXRkLT51cmItPmVwLT5kZXNjLmJFbmRwb2ludEFkZHJlc3Ms
DQogCQkJCXRkLT51cmItPnRyYW5zZmVyX2J1ZmZlcl9sZW5ndGgsDQotCQkJCVRSQl9MRU4obGUz
Ml90b19jcHUoZXZlbnQtPnRyYW5zZmVyX2xlbikpKTsNCisJCQkJRVZFTlRfVFJCX0xFTihsZTMy
X3RvX2NwdShldmVudC0+dHJhbnNmZXJfbGVuKSkpOw0KIAkvKiBGYXN0IHBhdGggLSB3YXMgdGhp
cyB0aGUgbGFzdCBUUkIgaW4gdGhlIFREIGZvciB0aGlzIFVSQj8gKi8NCiAJaWYgKGV2ZW50X3Ry
YiA9PSB0ZC0+bGFzdF90cmIpIHsNCi0JCWlmIChUUkJfTEVOKGxlMzJfdG9fY3B1KGV2ZW50LT50
cmFuc2Zlcl9sZW4pKSAhPSAwKSB7DQorCQlpZiAoRVZFTlRfVFJCX0xFTihsZTMyX3RvX2NwdShl
dmVudC0+dHJhbnNmZXJfbGVuKSkgIT0gMCkgew0KIAkJCXRkLT51cmItPmFjdHVhbF9sZW5ndGgg
PQ0KIAkJCQl0ZC0+dXJiLT50cmFuc2Zlcl9idWZmZXJfbGVuZ3RoIC0NCi0JCQkJVFJCX0xFTihs
ZTMyX3RvX2NwdShldmVudC0+dHJhbnNmZXJfbGVuKSk7DQorCQkJCUVWRU5UX1RSQl9MRU4obGUz
Ml90b19jcHUoZXZlbnQtPnRyYW5zZmVyX2xlbikpOw0KIAkJCWlmICh0ZC0+dXJiLT50cmFuc2Zl
cl9idWZmZXJfbGVuZ3RoIDwNCiAJCQkJCXRkLT51cmItPmFjdHVhbF9sZW5ndGgpIHsNCiAJCQkJ
eGhjaV93YXJuKHhoY2ksICJIQyBnYXZlIGJhZCBsZW5ndGggIg0KIAkJCQkJCSJvZiAlZCBieXRl
cyBsZWZ0XG4iLA0KLQkJCQkJICBUUkJfTEVOKGxlMzJfdG9fY3B1KGV2ZW50LT50cmFuc2Zlcl9s
ZW4pKSk7DQorCQkJCQkgIEVWRU5UX1RSQl9MRU4obGUzMl90b19jcHUoZXZlbnQtPnRyYW5zZmVy
X2xlbikpKTsNCiAJCQkJdGQtPnVyYi0+YWN0dWFsX2xlbmd0aCA9IDA7DQogCQkJCWlmICh0ZC0+
dXJiLT50cmFuc2Zlcl9mbGFncyAmIFVSQl9TSE9SVF9OT1RfT0spDQogCQkJCQkqc3RhdHVzID0g
LUVSRU1PVEVJTzsNCkBAIC0yMjE3LDcgKzIyMTcsNyBAQCBzdGF0aWMgaW50IHByb2Nlc3NfYnVs
a19pbnRyX3RkKHN0cnVjdCB4aGNpX2hjZCAqeGhjaSwgc3RydWN0IHhoY2lfdGQgKnRkLA0KIAkJ
aWYgKHRyYl9jb21wX2NvZGUgIT0gQ09NUF9TVE9QX0lOVkFMKQ0KIAkJCXRkLT51cmItPmFjdHVh
bF9sZW5ndGggKz0NCiAJCQkJVFJCX0xFTihsZTMyX3RvX2NwdShjdXJfdHJiLT5nZW5lcmljLmZp
ZWxkWzJdKSkgLQ0KLQkJCQlUUkJfTEVOKGxlMzJfdG9fY3B1KGV2ZW50LT50cmFuc2Zlcl9sZW4p
KTsNCisJCQkJRVZFTlRfVFJCX0xFTihsZTMyX3RvX2NwdShldmVudC0+dHJhbnNmZXJfbGVuKSk7
DQogCX0NCiANCiAJcmV0dXJuIGZpbmlzaF90ZCh4aGNpLCB0ZCwgZXZlbnRfdHJiLCBldmVudCwg
ZXAsIHN0YXR1cywgZmFsc2UpOw0KQEAgLTIyODMsNyArMjI4Myw3IEBAIHN0YXRpYyBpbnQgaGFu
ZGxlX3R4X2V2ZW50KHN0cnVjdCB4aGNpX2hjZCAqeGhjaSwNCiAJICogdHJhbnNmZXIgdHlwZQ0K
IAkgKi8NCiAJY2FzZSBDT01QX1NVQ0NFU1M6DQotCQlpZiAoVFJCX0xFTihsZTMyX3RvX2NwdShl
dmVudC0+dHJhbnNmZXJfbGVuKSkgPT0gMCkNCisJCWlmIChFVkVOVF9UUkJfTEVOKGxlMzJfdG9f
Y3B1KGV2ZW50LT50cmFuc2Zlcl9sZW4pKSA9PSAwKQ0KIAkJCWJyZWFrOw0KIAkJaWYgKHhoY2kt
PnF1aXJrcyAmIFhIQ0lfVFJVU1RfVFhfTEVOR1RIKQ0KIAkJCXRyYl9jb21wX2NvZGUgPSBDT01Q
X1NIT1JUX1RYOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS5oIGIvZHJpdmVy
cy91c2IvaG9zdC94aGNpLmgNCmluZGV4IGM1MTlhMzEuLjhiNGNjZTQ1IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy91c2IvaG9zdC94aGNpLmgNCisrKyBiL2RyaXZlcnMvdXNiL2hvc3QveGhjaS5oDQpA
QCAtOTY4LDYgKzk2OCwxMCBAQCBzdHJ1Y3QgeGhjaV90cmFuc2Zlcl9ldmVudCB7DQogCV9fbGUz
MglmbGFnczsNCiB9Ow0KIA0KKy8qIFRyYW5zZmVyIGV2ZW50IFRSQiBsZW5ndGggYml0IG1hc2sg
Ki8NCisvKiBiaXRzIDA6MjMgKi8NCisjZGVmaW5lCUVWRU5UX1RSQl9MRU4ocCkJCSgocCkgJiAw
eGZmZmZmZikNCisNCiAvKiogVHJhbnNmZXIgRXZlbnQgYml0IGZpZWxkcyAqKi8NCiAjZGVmaW5l
CVRSQl9UT19FUF9JRChwKQkoKChwKSA+PiAxNikgJiAweDFmKQ0KIA0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npby5jIGIvZHJpdmVycy91c2Ivc2VyaWFsL2Z0ZGlfc2lv
LmMNCmluZGV4IDcxYzQ2OTYuLjg3OGZmMDUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJp
YWwvZnRkaV9zaW8uYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL2Z0ZGlfc2lvLmMNCkBAIC02
NDgsNiArNjQ4LDcgQEAgc3RhdGljIHN0cnVjdCB1c2JfZGV2aWNlX2lkIGlkX3RhYmxlX2NvbWJp
bmVkIFtdID0gew0KIAl7IFVTQl9ERVZJQ0UoRlRESV9WSUQsIEZURElfUk1fQ0FOVklFV19QSUQp
IH0sDQogCXsgVVNCX0RFVklDRShBQ1RPTl9WSUQsIEFDVE9OX1NQRUNUUkFQUk9fUElEKSB9LA0K
IAl7IFVTQl9ERVZJQ0UoQ09OVEVDX1ZJRCwgQ09OVEVDX0NPTTFVU0JIX1BJRCkgfSwNCisJeyBV
U0JfREVWSUNFKE1JVFNVQklTSElfVklELCBNSVRTVUJJU0hJX0ZYVVNCX1BJRCkgfSwNCiAJeyBV
U0JfREVWSUNFKEJBTkRCX1ZJRCwgQkFOREJfVVNPVEw0X1BJRCkgfSwNCiAJeyBVU0JfREVWSUNF
KEJBTkRCX1ZJRCwgQkFOREJfVVNUTDRfUElEKSB9LA0KIAl7IFVTQl9ERVZJQ0UoQkFOREJfVklE
LCBCQU5EQl9VU085TUwyX1BJRCkgfSwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJpYWwv
ZnRkaV9zaW9faWRzLmggYi9kcml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW9faWRzLmgNCmluZGV4
IDk3ZTBhNmIuLjgwOWMwM2EgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9z
aW9faWRzLmgNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npb19pZHMuaA0KQEAgLTU4
NCw2ICs1ODQsMTMgQEANCiAjZGVmaW5lIENPTlRFQ19DT00xVVNCSF9QSUQJMHg4MzExCS8qIENP
TS0xKFVTQilIICovDQogDQogLyoNCisgKiBNaXRzdWJpc2hpIEVsZWN0cmljIENvcnAuIChodHRw
Oi8vd3d3Lm1lYXUuY29tKQ0KKyAqIFN1Ym1pdHRlZCBieSBLb25zdGFudGluIEhvbG9ib3JvZGtv
DQorICovDQorI2RlZmluZSBNSVRTVUJJU0hJX1ZJRAkJMHgwNkQzDQorI2RlZmluZSBNSVRTVUJJ
U0hJX0ZYVVNCX1BJRAkweDAyODQgLyogVVNCL1JTNDIyIGNvbnZlcnRlcnM6IEZYLVVTQi1BVy8t
QkQgKi8NCisNCisvKg0KICAqIERlZmluaXRpb25zIGZvciBCJkIgRWxlY3Ryb25pY3MgcHJvZHVj
dHMuDQogICovDQogI2RlZmluZSBCQU5EQl9WSUQJCTB4MDg1NgkvKiBCJkIgRWxlY3Ryb25pY3Mg
VmVuZG9yIElEICovDQpkaWZmIC0tZ2l0IGEvZnMvYmxvY2tfZGV2LmMgYi9mcy9ibG9ja19kZXYu
Yw0KaW5kZXggODMzZGRkYi4uNTNhYjI3MyAxMDA2NDQNCi0tLSBhL2ZzL2Jsb2NrX2Rldi5jDQor
KysgYi9mcy9ibG9ja19kZXYuYw0KQEAgLTU4Nyw2ICs1ODcsNyBAQCBzdHJ1Y3QgYmxvY2tfZGV2
aWNlICpiZGdyYWIoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldikNCiAJaWhvbGQoYmRldi0+YmRf
aW5vZGUpOw0KIAlyZXR1cm4gYmRldjsNCiB9DQorRVhQT1JUX1NZTUJPTChiZGdyYWIpOw0KIA0K
IGxvbmcgbnJfYmxvY2tkZXZfcGFnZXModm9pZCkNCiB7DQpkaWZmIC0tZ2l0IGEvZnMvYnRyZnMv
ZXh0ZW50LXRyZWUuYyBiL2ZzL2J0cmZzL2V4dGVudC10cmVlLmMNCmluZGV4IGY1ZmJlNTcuLjhk
NGQ1M2QgMTAwNjQ0DQotLS0gYS9mcy9idHJmcy9leHRlbnQtdHJlZS5jDQorKysgYi9mcy9idHJm
cy9leHRlbnQtdHJlZS5jDQpAQCAtMzk5Niw3ICszOTk2LDcgQEAgc3RhdGljIHZvaWQgdXBkYXRl
X2dsb2JhbF9ibG9ja19yc3Yoc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmZzX2luZm8pDQogCXNwaW5f
bG9jaygmYmxvY2tfcnN2LT5sb2NrKTsNCiAJc3Bpbl9sb2NrKCZzaW5mby0+bG9jayk7DQogDQot
CWJsb2NrX3Jzdi0+c2l6ZSA9IG51bV9ieXRlczsNCisJYmxvY2tfcnN2LT5zaXplID0gbWluX3Qo
dTY0LCBudW1fYnl0ZXMsIDUxMiAqIDEwMjQgKiAxMDI0KTsNCiANCiAJbnVtX2J5dGVzID0gc2lu
Zm8tPmJ5dGVzX3VzZWQgKyBzaW5mby0+Ynl0ZXNfcGlubmVkICsNCiAJCSAgICBzaW5mby0+Ynl0
ZXNfcmVzZXJ2ZWQgKyBzaW5mby0+Ynl0ZXNfcmVhZG9ubHkgKw0KZGlmZiAtLWdpdCBhL2ZzL2Rj
YWNoZS5jIGIvZnMvZGNhY2hlLmMNCmluZGV4IGJiN2Y0Y2MuLmU5MjNiZjQgMTAwNjQ0DQotLS0g
YS9mcy9kY2FjaGUuYw0KKysrIGIvZnMvZGNhY2hlLmMNCkBAIC0yNDQ1LDcgKzI0NDUsNiBAQCBz
dGF0aWMgaW50IHByZXBlbmRfcGF0aChjb25zdCBzdHJ1Y3QgcGF0aCAqcGF0aCwNCiAJYm9vbCBz
bGFzaCA9IGZhbHNlOw0KIAlpbnQgZXJyb3IgPSAwOw0KIA0KLQlicl9yZWFkX2xvY2sodmZzbW91
bnRfbG9jayk7DQogCXdoaWxlIChkZW50cnkgIT0gcm9vdC0+ZGVudHJ5IHx8IHZmc21udCAhPSBy
b290LT5tbnQpIHsNCiAJCXN0cnVjdCBkZW50cnkgKiBwYXJlbnQ7DQogDQpAQCAtMjQ3NSw4ICsy
NDc0LDYgQEAgc3RhdGljIGludCBwcmVwZW5kX3BhdGgoY29uc3Qgc3RydWN0IHBhdGggKnBhdGgs
DQogCWlmICghZXJyb3IgJiYgIXNsYXNoKQ0KIAkJZXJyb3IgPSBwcmVwZW5kKGJ1ZmZlciwgYnVm
bGVuLCAiLyIsIDEpOw0KIA0KLW91dDoNCi0JYnJfcmVhZF91bmxvY2sodmZzbW91bnRfbG9jayk7
DQogCXJldHVybiBlcnJvcjsNCiANCiBnbG9iYWxfcm9vdDoNCkBAIC0yNDkzLDcgKzI0OTAsNyBA
QCBnbG9iYWxfcm9vdDoNCiAJCWVycm9yID0gcHJlcGVuZChidWZmZXIsIGJ1ZmxlbiwgIi8iLCAx
KTsNCiAJaWYgKCFlcnJvcikNCiAJCWVycm9yID0gdmZzbW50LT5tbnRfbnMgPyAxIDogMjsNCi0J
Z290byBvdXQ7DQorCXJldHVybiBlcnJvcjsNCiB9DQogDQogLyoqDQpAQCAtMjUyMCw5ICsyNTE3
LDExIEBAIGNoYXIgKl9fZF9wYXRoKGNvbnN0IHN0cnVjdCBwYXRoICpwYXRoLA0KIAlpbnQgZXJy
b3I7DQogDQogCXByZXBlbmQoJnJlcywgJmJ1ZmxlbiwgIlwwIiwgMSk7DQorCWJyX3JlYWRfbG9j
ayh2ZnNtb3VudF9sb2NrKTsNCiAJd3JpdGVfc2VxbG9jaygmcmVuYW1lX2xvY2spOw0KIAllcnJv
ciA9IHByZXBlbmRfcGF0aChwYXRoLCByb290LCAmcmVzLCAmYnVmbGVuKTsNCiAJd3JpdGVfc2Vx
dW5sb2NrKCZyZW5hbWVfbG9jayk7DQorCWJyX3JlYWRfdW5sb2NrKHZmc21vdW50X2xvY2spOw0K
IA0KIAlpZiAoZXJyb3IgPCAwKQ0KIAkJcmV0dXJuIEVSUl9QVFIoZXJyb3IpOw0KQEAgLTI1Mzks
OSArMjUzOCwxMSBAQCBjaGFyICpkX2Fic29sdXRlX3BhdGgoY29uc3Qgc3RydWN0IHBhdGggKnBh
dGgsDQogCWludCBlcnJvcjsNCiANCiAJcHJlcGVuZCgmcmVzLCAmYnVmbGVuLCAiXDAiLCAxKTsN
CisJYnJfcmVhZF9sb2NrKHZmc21vdW50X2xvY2spOw0KIAl3cml0ZV9zZXFsb2NrKCZyZW5hbWVf
bG9jayk7DQogCWVycm9yID0gcHJlcGVuZF9wYXRoKHBhdGgsICZyb290LCAmcmVzLCAmYnVmbGVu
KTsNCiAJd3JpdGVfc2VxdW5sb2NrKCZyZW5hbWVfbG9jayk7DQorCWJyX3JlYWRfdW5sb2NrKHZm
c21vdW50X2xvY2spOw0KIA0KIAlpZiAoZXJyb3IgPiAxKQ0KIAkJZXJyb3IgPSAtRUlOVkFMOw0K
QEAgLTI2MDUsMTEgKzI2MDYsMTMgQEAgY2hhciAqZF9wYXRoKGNvbnN0IHN0cnVjdCBwYXRoICpw
YXRoLCBjaGFyICpidWYsIGludCBidWZsZW4pDQogCQlyZXR1cm4gcGF0aC0+ZGVudHJ5LT5kX29w
LT5kX2RuYW1lKHBhdGgtPmRlbnRyeSwgYnVmLCBidWZsZW4pOw0KIA0KIAlnZXRfZnNfcm9vdChj
dXJyZW50LT5mcywgJnJvb3QpOw0KKwlicl9yZWFkX2xvY2sodmZzbW91bnRfbG9jayk7DQogCXdy
aXRlX3NlcWxvY2soJnJlbmFtZV9sb2NrKTsNCiAJZXJyb3IgPSBwYXRoX3dpdGhfZGVsZXRlZChw
YXRoLCAmcm9vdCwgJnJlcywgJmJ1Zmxlbik7DQorCXdyaXRlX3NlcXVubG9jaygmcmVuYW1lX2xv
Y2spOw0KKwlicl9yZWFkX3VubG9jayh2ZnNtb3VudF9sb2NrKTsNCiAJaWYgKGVycm9yIDwgMCkN
CiAJCXJlcyA9IEVSUl9QVFIoZXJyb3IpOw0KLQl3cml0ZV9zZXF1bmxvY2soJnJlbmFtZV9sb2Nr
KTsNCiAJcGF0aF9wdXQoJnJvb3QpOw0KIAlyZXR1cm4gcmVzOw0KIH0NCkBAIC0yNzY0LDYgKzI3
NjcsNyBAQCBTWVNDQUxMX0RFRklORTIoZ2V0Y3dkLCBjaGFyIF9fdXNlciAqLCBidWYsIHVuc2ln
bmVkIGxvbmcsIHNpemUpDQogCWdldF9mc19yb290X2FuZF9wd2QoY3VycmVudC0+ZnMsICZyb290
LCAmcHdkKTsNCiANCiAJZXJyb3IgPSAtRU5PRU5UOw0KKwlicl9yZWFkX2xvY2sodmZzbW91bnRf
bG9jayk7DQogCXdyaXRlX3NlcWxvY2soJnJlbmFtZV9sb2NrKTsNCiAJaWYgKCFkX3VubGlua2Vk
KHB3ZC5kZW50cnkpKSB7DQogCQl1bnNpZ25lZCBsb25nIGxlbjsNCkBAIC0yNzczLDYgKzI3Nzcs
NyBAQCBTWVNDQUxMX0RFRklORTIoZ2V0Y3dkLCBjaGFyIF9fdXNlciAqLCBidWYsIHVuc2lnbmVk
IGxvbmcsIHNpemUpDQogCQlwcmVwZW5kKCZjd2QsICZidWZsZW4sICJcMCIsIDEpOw0KIAkJZXJy
b3IgPSBwcmVwZW5kX3BhdGgoJnB3ZCwgJnJvb3QsICZjd2QsICZidWZsZW4pOw0KIAkJd3JpdGVf
c2VxdW5sb2NrKCZyZW5hbWVfbG9jayk7DQorCQlicl9yZWFkX3VubG9jayh2ZnNtb3VudF9sb2Nr
KTsNCiANCiAJCWlmIChlcnJvciA8IDApDQogCQkJZ290byBvdXQ7DQpAQCAtMjc5Myw2ICsyNzk4
LDcgQEAgU1lTQ0FMTF9ERUZJTkUyKGdldGN3ZCwgY2hhciBfX3VzZXIgKiwgYnVmLCB1bnNpZ25l
ZCBsb25nLCBzaXplKQ0KIAkJfQ0KIAl9IGVsc2Ugew0KIAkJd3JpdGVfc2VxdW5sb2NrKCZyZW5h
bWVfbG9jayk7DQorCQlicl9yZWFkX3VubG9jayh2ZnNtb3VudF9sb2NrKTsNCiAJfQ0KIA0KIG91
dDoNCmRpZmYgLS1naXQgYS9mcy9uZnMvYmxvY2tsYXlvdXQvYmxvY2tsYXlvdXRkbS5jIGIvZnMv
bmZzL2Jsb2NrbGF5b3V0L2Jsb2NrbGF5b3V0ZG0uYw0KaW5kZXggZDA1NWM3NS4uNzMyNmU2ZSAx
MDA2NDQNCi0tLSBhL2ZzL25mcy9ibG9ja2xheW91dC9ibG9ja2xheW91dGRtLmMNCisrKyBiL2Zz
L25mcy9ibG9ja2xheW91dC9ibG9ja2xheW91dGRtLmMNCkBAIC01Miw3ICs1Miw4IEBAIHN0YXRp
YyB2b2lkIGRldl9yZW1vdmUoZGV2X3QgZGV2KQ0KIAlkcHJpbnRrKCJFbnRlcmluZyAlc1xuIiwg
X19mdW5jX18pOw0KIA0KIAltZW1zZXQoJm1zZywgMCwgc2l6ZW9mKG1zZykpOw0KLQltc2cuZGF0
YSA9IGt6YWxsb2MoMSArIHNpemVvZihibF91bW91bnRfcmVxdWVzdCksIEdGUF9OT0ZTKTsNCisJ
bXNnLmxlbiA9IHNpemVvZihibF9tc2cpICsgYmxfbXNnLnRvdGFsbGVuOw0KKwltc2cuZGF0YSA9
IGt6YWxsb2MobXNnLmxlbiwgR0ZQX05PRlMpOw0KIAlpZiAoIW1zZy5kYXRhKQ0KIAkJZ290byBv
dXQ7DQogDQpAQCAtNjMsNyArNjQsNiBAQCBzdGF0aWMgdm9pZCBkZXZfcmVtb3ZlKGRldl90IGRl
dikNCiAJbWVtY3B5KG1zZy5kYXRhLCAmYmxfbXNnLCBzaXplb2YoYmxfbXNnKSk7DQogCWRhdGFw
dHIgPSAodWludDhfdCAqKSBtc2cuZGF0YTsNCiAJbWVtY3B5KCZkYXRhcHRyW3NpemVvZihibF9t
c2cpXSwgJmJsX3Vtb3VudF9yZXF1ZXN0LCBzaXplb2YoYmxfdW1vdW50X3JlcXVlc3QpKTsNCi0J
bXNnLmxlbiA9IHNpemVvZihibF9tc2cpICsgYmxfbXNnLnRvdGFsbGVuOw0KIA0KIAlhZGRfd2Fp
dF9xdWV1ZSgmYmxfd3EsICZ3cSk7DQogCWlmIChycGNfcXVldWVfdXBjYWxsKGJsX2RldmljZV9w
aXBlLT5kX2lub2RlLCAmbXNnKSA8IDApIHsNCmRpZmYgLS1naXQgYS9mcy9uZnMvbmZzNHByb2Mu
YyBiL2ZzL25mcy9uZnM0cHJvYy5jDQppbmRleCA2ZDdjNTNkLi41NjM5ZWZkIDEwMDY0NA0KLS0t
IGEvZnMvbmZzL25mczRwcm9jLmMNCisrKyBiL2ZzL25mcy9uZnM0cHJvYy5jDQpAQCAtMzU3OCw3
ICszNTc4LDggQEAgc3RhdGljIHNzaXplX3QgX19uZnM0X2dldF9hY2xfdW5jYWNoZWQoc3RydWN0
IGlub2RlICppbm9kZSwgdm9pZCAqYnVmLCBzaXplX3QgYnUNCiAJCS5ycGNfYXJncCA9ICZhcmdz
LA0KIAkJLnJwY19yZXNwID0gJnJlcywNCiAJfTsNCi0JaW50IHJldCA9IC1FTk9NRU0sIG5wYWdl
cywgaSwgYWNsX2xlbiA9IDA7DQorCWludCByZXQgPSAtRU5PTUVNLCBucGFnZXMsIGk7DQorCXNp
emVfdCBhY2xfbGVuID0gMDsNCiANCiAJbnBhZ2VzID0gKGJ1ZmxlbiArIFBBR0VfU0laRSAtIDEp
ID4+IFBBR0VfU0hJRlQ7DQogCS8qIEFzIGxvbmcgYXMgd2UncmUgZG9pbmcgYSByb3VuZCB0cmlw
IHRvIHRoZSBzZXJ2ZXIgYW55d2F5LA0KQEAgLTYxMDgsMjIgKzYxMDksOCBAQCBuZnM0X2xheW91
dGNvbW1pdF9kb25lKHN0cnVjdCBycGNfdGFzayAqdGFzaywgdm9pZCAqY2FsbGRhdGEpDQogc3Rh
dGljIHZvaWQgbmZzNF9sYXlvdXRjb21taXRfcmVsZWFzZSh2b2lkICpjYWxsZGF0YSkNCiB7DQog
CXN0cnVjdCBuZnM0X2xheW91dGNvbW1pdF9kYXRhICpkYXRhID0gY2FsbGRhdGE7DQotCXN0cnVj
dCBwbmZzX2xheW91dF9zZWdtZW50ICpsc2VnLCAqdG1wOw0KLQl1bnNpZ25lZCBsb25nICpiaXRs
b2NrID0gJk5GU19JKGRhdGEtPmFyZ3MuaW5vZGUpLT5mbGFnczsNCiANCiAJcG5mc19jbGVhbnVw
X2xheW91dGNvbW1pdChkYXRhKTsNCi0JLyogTWF0Y2hlZCBieSByZWZlcmVuY2VzIGluIHBuZnNf
c2V0X2xheW91dGNvbW1pdCAqLw0KLQlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUobHNlZywgdG1w
LCAmZGF0YS0+bHNlZ19saXN0LCBwbHNfbGNfbGlzdCkgew0KLQkJbGlzdF9kZWxfaW5pdCgmbHNl
Zy0+cGxzX2xjX2xpc3QpOw0KLQkJaWYgKHRlc3RfYW5kX2NsZWFyX2JpdChORlNfTFNFR19MQVlP
VVRDT01NSVQsDQotCQkJCSAgICAgICAmbHNlZy0+cGxzX2ZsYWdzKSkNCi0JCQlwdXRfbHNlZyhs
c2VnKTsNCi0JfQ0KLQ0KLQljbGVhcl9iaXRfdW5sb2NrKE5GU19JTk9fTEFZT1VUQ09NTUlUVElO
RywgYml0bG9jayk7DQotCXNtcF9tYl9fYWZ0ZXJfY2xlYXJfYml0KCk7DQotCXdha2VfdXBfYml0
KGJpdGxvY2ssIE5GU19JTk9fTEFZT1VUQ09NTUlUVElORyk7DQotDQogCXB1dF9ycGNjcmVkKGRh
dGEtPmNyZWQpOw0KIAlrZnJlZShkYXRhKTsNCiB9DQpkaWZmIC0tZ2l0IGEvZnMvbmZzL3BuZnMu
YyBiL2ZzL25mcy9wbmZzLmMNCmluZGV4IDNhZDY1OTUuLmQxMjUxNGEgMTAwNjQ0DQotLS0gYS9m
cy9uZnMvcG5mcy5jDQorKysgYi9mcy9uZnMvcG5mcy5jDQpAQCAtMTM1NiwxMSArMTM1NiwyNyBA
QCBzdGF0aWMgdm9pZCBwbmZzX2xpc3Rfd3JpdGVfbHNlZyhzdHJ1Y3QgaW5vZGUgKmlub2RlLCBz
dHJ1Y3QgbGlzdF9oZWFkICpsaXN0cCkNCiANCiAJbGlzdF9mb3JfZWFjaF9lbnRyeShsc2VnLCAm
TkZTX0koaW5vZGUpLT5sYXlvdXQtPnBsaF9zZWdzLCBwbHNfbGlzdCkgew0KIAkJaWYgKGxzZWct
PnBsc19yYW5nZS5pb21vZGUgPT0gSU9NT0RFX1JXICYmDQotCQkgICAgdGVzdF9iaXQoTkZTX0xT
RUdfTEFZT1VUQ09NTUlULCAmbHNlZy0+cGxzX2ZsYWdzKSkNCisJCSAgICB0ZXN0X2FuZF9jbGVh
cl9iaXQoTkZTX0xTRUdfTEFZT1VUQ09NTUlULCAmbHNlZy0+cGxzX2ZsYWdzKSkNCiAJCQlsaXN0
X2FkZCgmbHNlZy0+cGxzX2xjX2xpc3QsIGxpc3RwKTsNCiAJfQ0KIH0NCiANCitzdGF0aWMgdm9p
ZCBwbmZzX2xpc3Rfd3JpdGVfbHNlZ19kb25lKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBs
aXN0X2hlYWQgKmxpc3RwKQ0KK3sNCisJc3RydWN0IHBuZnNfbGF5b3V0X3NlZ21lbnQgKmxzZWcs
ICp0bXA7DQorCXVuc2lnbmVkIGxvbmcgKmJpdGxvY2sgPSAmTkZTX0koaW5vZGUpLT5mbGFnczsN
CisNCisJLyogTWF0Y2hlZCBieSByZWZlcmVuY2VzIGluIHBuZnNfc2V0X2xheW91dGNvbW1pdCAq
Lw0KKwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUobHNlZywgdG1wLCBsaXN0cCwgcGxzX2xjX2xp
c3QpIHsNCisJCWxpc3RfZGVsX2luaXQoJmxzZWctPnBsc19sY19saXN0KTsNCisJCXB1dF9sc2Vn
KGxzZWcpOw0KKwl9DQorDQorCWNsZWFyX2JpdF91bmxvY2soTkZTX0lOT19MQVlPVVRDT01NSVRU
SU5HLCBiaXRsb2NrKTsNCisJc21wX21iX19hZnRlcl9jbGVhcl9iaXQoKTsNCisJd2FrZV91cF9i
aXQoYml0bG9jaywgTkZTX0lOT19MQVlPVVRDT01NSVRUSU5HKTsNCit9DQorDQogdm9pZCBwbmZz
X3NldF9sb19mYWlsKHN0cnVjdCBwbmZzX2xheW91dF9zZWdtZW50ICpsc2VnKQ0KIHsNCiAJaWYg
KGxzZWctPnBsc19yYW5nZS5pb21vZGUgPT0gSU9NT0RFX1JXKSB7DQpAQCAtMTQwOSw2ICsxNDI1
LDcgQEAgdm9pZCBwbmZzX2NsZWFudXBfbGF5b3V0Y29tbWl0KHN0cnVjdCBuZnM0X2xheW91dGNv
bW1pdF9kYXRhICpkYXRhKQ0KIA0KIAlpZiAobmZzcy0+cG5mc19jdXJyX2xkLT5jbGVhbnVwX2xh
eW91dGNvbW1pdCkNCiAJCW5mc3MtPnBuZnNfY3Vycl9sZC0+Y2xlYW51cF9sYXlvdXRjb21taXQo
ZGF0YSk7DQorCXBuZnNfbGlzdF93cml0ZV9sc2VnX2RvbmUoZGF0YS0+YXJncy5pbm9kZSwgJmRh
dGEtPmxzZWdfbGlzdCk7DQogfQ0KIA0KIC8qDQpkaWZmIC0tZ2l0IGEvZnMvbmZzZC9uZnM0eGRy
LmMgYi9mcy9uZnNkL25mczR4ZHIuYw0KaW5kZXggODAwYzIxNS4uMjRhZmE5NiAxMDA2NDQNCi0t
LSBhL2ZzL25mc2QvbmZzNHhkci5jDQorKysgYi9mcy9uZnNkL25mczR4ZHIuYw0KQEAgLTI4MCw3
ICsyODAsNyBAQCBuZnNkNF9kZWNvZGVfZmF0dHIoc3RydWN0IG5mc2Q0X2NvbXBvdW5kYXJncyAq
YXJncCwgdTMyICpibXZhbCwNCiAJCWlhdHRyLT5pYV92YWxpZCB8PSBBVFRSX1NJWkU7DQogCX0N
CiAJaWYgKGJtdmFsWzBdICYgRkFUVFI0X1dPUkQwX0FDTCkgew0KLQkJaW50IG5hY2U7DQorCQl1
MzIgbmFjZTsNCiAJCXN0cnVjdCBuZnM0X2FjZSAqYWNlOw0KIA0KIAkJUkVBRF9CVUYoNCk7IGxl
biArPSA0Ow0KZGlmZiAtLWdpdCBhL2ZzL3JlaXNlcmZzL3hhdHRyLmMgYi9mcy9yZWlzZXJmcy94
YXR0ci5jDQppbmRleCA2YmMzNDZjLi4wNGVlY2M0IDEwMDY0NA0KLS0tIGEvZnMvcmVpc2VyZnMv
eGF0dHIuYw0KKysrIGIvZnMvcmVpc2VyZnMveGF0dHIuYw0KQEAgLTE4Nyw4ICsxODcsOCBAQCBm
aWxsX3dpdGhfZGVudHJpZXModm9pZCAqYnVmLCBjb25zdCBjaGFyICpuYW1lLCBpbnQgbmFtZWxl
biwgbG9mZl90IG9mZnNldCwNCiAJaWYgKGRidWYtPmNvdW50ID09IEFSUkFZX1NJWkUoZGJ1Zi0+
ZGVudHJpZXMpKQ0KIAkJcmV0dXJuIC1FTk9TUEM7DQogDQotCWlmIChuYW1lWzBdID09ICcuJyAm
JiAobmFtZVsxXSA9PSAnXDAnIHx8DQotCQkJICAgICAgIChuYW1lWzFdID09ICcuJyAmJiBuYW1l
WzJdID09ICdcMCcpKSkNCisJaWYgKG5hbWVbMF0gPT0gJy4nICYmIChuYW1lbGVuIDwgMiB8fA0K
KwkJCSAgICAgICAobmFtZWxlbiA9PSAyICYmIG5hbWVbMV0gPT0gJy4nKSkpDQogCQlyZXR1cm4g
MDsNCiANCiAJZGVudHJ5ID0gbG9va3VwX29uZV9sZW4obmFtZSwgZGJ1Zi0+eGFkaXIsIG5hbWVs
ZW4pOw0KZGlmZiAtLWdpdCBhL2ZzL3N5c2ZzL2Rpci5jIGIvZnMvc3lzZnMvZGlyLmMNCmluZGV4
IGZhYmJiODEuLjM4OTllMjQgMTAwNjQ0DQotLS0gYS9mcy9zeXNmcy9kaXIuYw0KKysrIGIvZnMv
c3lzZnMvZGlyLmMNCkBAIC05ODUsNiArOTg1LDggQEAgc3RhdGljIGludCBzeXNmc19yZWFkZGly
KHN0cnVjdCBmaWxlICogZmlscCwgdm9pZCAqIGRpcmVudCwgZmlsbGRpcl90IGZpbGxkaXIpDQog
CQlpbm8gPSBwYXJlbnRfc2QtPnNfaW5vOw0KIAkJaWYgKGZpbGxkaXIoZGlyZW50LCAiLiIsIDEs
IGZpbHAtPmZfcG9zLCBpbm8sIERUX0RJUikgPT0gMCkNCiAJCQlmaWxwLT5mX3BvcysrOw0KKwkJ
ZWxzZQ0KKwkJCXJldHVybiAwOw0KIAl9DQogCWlmIChmaWxwLT5mX3BvcyA9PSAxKSB7DQogCQlp
ZiAocGFyZW50X3NkLT5zX3BhcmVudCkNCkBAIC05OTMsNiArOTk1LDggQEAgc3RhdGljIGludCBz
eXNmc19yZWFkZGlyKHN0cnVjdCBmaWxlICogZmlscCwgdm9pZCAqIGRpcmVudCwgZmlsbGRpcl90
IGZpbGxkaXIpDQogCQkJaW5vID0gcGFyZW50X3NkLT5zX2lubzsNCiAJCWlmIChmaWxsZGlyKGRp
cmVudCwgIi4uIiwgMiwgZmlscC0+Zl9wb3MsIGlubywgRFRfRElSKSA9PSAwKQ0KIAkJCWZpbHAt
PmZfcG9zKys7DQorCQllbHNlDQorCQkJcmV0dXJuIDA7DQogCX0NCiAJbXV0ZXhfbG9jaygmc3lz
ZnNfbXV0ZXgpOw0KIAlmb3IgKHBvcyA9IHN5c2ZzX2Rpcl9wb3MobnMsIHBhcmVudF9zZCwgZmls
cC0+Zl9wb3MsIHBvcyk7DQpAQCAtMTAyMywxMCArMTAyNywyMSBAQCBzdGF0aWMgaW50IHN5c2Zz
X3JlYWRkaXIoc3RydWN0IGZpbGUgKiBmaWxwLCB2b2lkICogZGlyZW50LCBmaWxsZGlyX3QgZmls
bGRpcikNCiAJcmV0dXJuIDA7DQogfQ0KIA0KK3N0YXRpYyBsb2ZmX3Qgc3lzZnNfZGlyX2xsc2Vl
ayhzdHJ1Y3QgZmlsZSAqZmlsZSwgbG9mZl90IG9mZnNldCwgaW50IHdoZW5jZSkNCit7DQorCXN0
cnVjdCBpbm9kZSAqaW5vZGUgPSBmaWxlLT5mX3BhdGguZGVudHJ5LT5kX2lub2RlOw0KKwlsb2Zm
X3QgcmV0Ow0KKw0KKwltdXRleF9sb2NrKCZpbm9kZS0+aV9tdXRleCk7DQorCXJldCA9IGdlbmVy
aWNfZmlsZV9sbHNlZWsoZmlsZSwgb2Zmc2V0LCB3aGVuY2UpOw0KKwltdXRleF91bmxvY2soJmlu
b2RlLT5pX211dGV4KTsNCisNCisJcmV0dXJuIHJldDsNCit9DQogDQogY29uc3Qgc3RydWN0IGZp
bGVfb3BlcmF0aW9ucyBzeXNmc19kaXJfb3BlcmF0aW9ucyA9IHsNCiAJLnJlYWQJCT0gZ2VuZXJp
Y19yZWFkX2RpciwNCiAJLnJlYWRkaXIJPSBzeXNmc19yZWFkZGlyLA0KIAkucmVsZWFzZQk9IHN5
c2ZzX2Rpcl9yZWxlYXNlLA0KLQkubGxzZWVrCQk9IGdlbmVyaWNfZmlsZV9sbHNlZWssDQorCS5s
bHNlZWsJCT0gc3lzZnNfZGlyX2xsc2VlaywNCiB9Ow0KZGlmZiAtLWdpdCBhL2ZzL3ViaWZzL3N1
cGVyLmMgYi9mcy91Ymlmcy9zdXBlci5jDQppbmRleCBhZTBlNzZiLi4yZjQ2N2U1IDEwMDY0NA0K
LS0tIGEvZnMvdWJpZnMvc3VwZXIuYw0KKysrIGIvZnMvdWJpZnMvc3VwZXIuYw0KQEAgLTE1ODMs
NiArMTU4MywxMiBAQCBzdGF0aWMgaW50IHViaWZzX3JlbW91bnRfcncoc3RydWN0IHViaWZzX2lu
Zm8gKmMpDQogCWMtPnJlbW91bnRpbmdfcncgPSAxOw0KIAljLT5yb19tb3VudCA9IDA7DQogDQor
CWlmIChjLT5zcGFjZV9maXh1cCkgew0KKwkJZXJyID0gdWJpZnNfZml4dXBfZnJlZV9zcGFjZShj
KTsNCisJCWlmIChlcnIpDQorCQkJcmV0dXJuIGVycjsNCisJfQ0KKw0KIAllcnIgPSBjaGVja19m
cmVlX3NwYWNlKGMpOw0KIAlpZiAoZXJyKQ0KIAkJZ290byBvdXQ7DQpAQCAtMTY5OSwxMiArMTcw
NSw2IEBAIHN0YXRpYyBpbnQgdWJpZnNfcmVtb3VudF9ydyhzdHJ1Y3QgdWJpZnNfaW5mbyAqYykN
CiAJCWVyciA9IGRiZ19jaGVja19zcGFjZV9pbmZvKGMpOw0KIAl9DQogDQotCWlmIChjLT5zcGFj
ZV9maXh1cCkgew0KLQkJZXJyID0gdWJpZnNfZml4dXBfZnJlZV9zcGFjZShjKTsNCi0JCWlmIChl
cnIpDQotCQkJZ290byBvdXQ7DQotCX0NCi0NCiAJbXV0ZXhfdW5sb2NrKCZjLT51bW91bnRfbXV0
ZXgpOw0KIAlyZXR1cm4gZXJyOw0KIA0KZGlmZiAtLWdpdCBhL2ZzL3VkZi91ZGZfc2IuaCBiL2Zz
L3VkZi91ZGZfc2IuaA0KaW5kZXggNTE0MmE4Mi4uNjA0ZjVmYyAxMDA2NDQNCi0tLSBhL2ZzL3Vk
Zi91ZGZfc2IuaA0KKysrIGIvZnMvdWRmL3VkZl9zYi5oDQpAQCAtODIsNyArODIsNyBAQCBzdHJ1
Y3QgdWRmX3ZpcnR1YWxfZGF0YSB7DQogc3RydWN0IHVkZl9iaXRtYXAgew0KIAlfX3UzMgkJCXNf
ZXh0TGVuZ3RoOw0KIAlfX3UzMgkJCXNfZXh0UG9zaXRpb247DQotCV9fdTE2CQkJc19ucl9ncm91
cHM7DQorCWludAkJCXNfbnJfZ3JvdXBzOw0KIAlzdHJ1Y3QgYnVmZmVyX2hlYWQgCSoqc19ibG9j
a19iaXRtYXA7DQogfTsNCiANCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3RoZXJtYWwuaCBi
L2luY2x1ZGUvbGludXgvdGhlcm1hbC5oDQppbmRleCA0N2I0YTI3Li41ZWY4NTlhIDEwMDY0NA0K
LS0tIGEvaW5jbHVkZS9saW51eC90aGVybWFsLmgNCisrKyBiL2luY2x1ZGUvbGludXgvdGhlcm1h
bC5oDQpAQCAtMTA4LDcgKzEwOCw3IEBAIHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlIHsNCiAv
KiBBZGRpbmcgZXZlbnQgbm90aWZpY2F0aW9uIHN1cHBvcnQgZWxlbWVudHMgKi8NCiAjZGVmaW5l
IFRIRVJNQUxfR0VOTF9GQU1JTFlfTkFNRSAgICAgICAgICAgICAgICAidGhlcm1hbF9ldmVudCIN
CiAjZGVmaW5lIFRIRVJNQUxfR0VOTF9WRVJTSU9OICAgICAgICAgICAgICAgICAgICAweDAxDQot
I2RlZmluZSBUSEVSTUFMX0dFTkxfTUNBU1RfR1JPVVBfTkFNRSAgICAgICAgICAgInRoZXJtYWxf
bWNfZ3JvdXAiDQorI2RlZmluZSBUSEVSTUFMX0dFTkxfTUNBU1RfR1JPVVBfTkFNRSAgICAgICAg
ICAgInRoZXJtYWxfbWNfZ3JwIg0KIA0KIGVudW0gZXZlbnRzIHsNCiAJVEhFUk1BTF9BVVgwLA0K
ZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lL3RpY2stYnJvYWRjYXN0LmMgYi9rZXJuZWwvdGltZS90
aWNrLWJyb2FkY2FzdC5jDQppbmRleCBmZDRhN2IxLi5jZDA2OGIyIDEwMDY0NA0KLS0tIGEva2Vy
bmVsL3RpbWUvdGljay1icm9hZGNhc3QuYw0KKysrIGIva2VybmVsL3RpbWUvdGljay1icm9hZGNh
c3QuYw0KQEAgLTY2LDcgKzY2LDggQEAgc3RhdGljIHZvaWQgdGlja19icm9hZGNhc3Rfc3RhcnRf
cGVyaW9kaWMoc3RydWN0IGNsb2NrX2V2ZW50X2RldmljZSAqYmMpDQogICovDQogaW50IHRpY2tf
Y2hlY2tfYnJvYWRjYXN0X2RldmljZShzdHJ1Y3QgY2xvY2tfZXZlbnRfZGV2aWNlICpkZXYpDQog
ew0KLQlpZiAoKHRpY2tfYnJvYWRjYXN0X2RldmljZS5ldnRkZXYgJiYNCisJaWYgKChkZXYtPmZl
YXR1cmVzICYgQ0xPQ0tfRVZUX0ZFQVRfRFVNTVkpIHx8DQorCSAgICAodGlja19icm9hZGNhc3Rf
ZGV2aWNlLmV2dGRldiAmJg0KIAkgICAgIHRpY2tfYnJvYWRjYXN0X2RldmljZS5ldnRkZXYtPnJh
dGluZyA+PSBkZXYtPnJhdGluZykgfHwNCiAJICAgICAoZGV2LT5mZWF0dXJlcyAmIENMT0NLX0VW
VF9GRUFUX0MzU1RPUCkpDQogCQlyZXR1cm4gMDsNCmRpZmYgLS1naXQgYS9tbS9tbWFwLmMgYi9t
bS9tbWFwLmMNCmluZGV4IGVhZTkwYWYuLmRmZjM3YTYgMTAwNjQ0DQotLS0gYS9tbS9tbWFwLmMN
CisrKyBiL21tL21tYXAuYw0KQEAgLTE1NzMsNyArMTU3Myw3IEBAIHN0cnVjdCB2bV9hcmVhX3N0
cnVjdCAqZmluZF92bWEoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHVuc2lnbmVkIGxvbmcgYWRkcikN
CiAJaWYgKG1tKSB7DQogCQkvKiBDaGVjayB0aGUgY2FjaGUgZmlyc3QuICovDQogCQkvKiAoQ2Fj
aGUgaGl0IHJhdGUgaXMgdHlwaWNhbGx5IGFyb3VuZCAzNSUuKSAqLw0KLQkJdm1hID0gbW0tPm1t
YXBfY2FjaGU7DQorCQl2bWEgPSBBQ0NFU1NfT05DRShtbS0+bW1hcF9jYWNoZSk7DQogCQlpZiAo
ISh2bWEgJiYgdm1hLT52bV9lbmQgPiBhZGRyICYmIHZtYS0+dm1fc3RhcnQgPD0gYWRkcikpIHsN
CiAJCQlzdHJ1Y3QgcmJfbm9kZSAqIHJiX25vZGU7DQogDQpkaWZmIC0tZ2l0IGEvbW0vbm9tbXUu
YyBiL21tL25vbW11LmMNCmluZGV4IGY1OWUxNzAuLmYwY2Q3YWIgMTAwNjQ0DQotLS0gYS9tbS9u
b21tdS5jDQorKysgYi9tbS9ub21tdS5jDQpAQCAtODA3LDcgKzgwNyw3IEBAIHN0cnVjdCB2bV9h
cmVhX3N0cnVjdCAqZmluZF92bWEoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHVuc2lnbmVkIGxvbmcg
YWRkcikNCiAJc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWE7DQogDQogCS8qIGNoZWNrIHRoZSBj
YWNoZSBmaXJzdCAqLw0KLQl2bWEgPSBtbS0+bW1hcF9jYWNoZTsNCisJdm1hID0gQUNDRVNTX09O
Q0UobW0tPm1tYXBfY2FjaGUpOw0KIAlpZiAodm1hICYmIHZtYS0+dm1fc3RhcnQgPD0gYWRkciAm
JiB2bWEtPnZtX2VuZCA+IGFkZHIpDQogCQlyZXR1cm4gdm1hOw0KIA0KZGlmZiAtLWdpdCBhL25l
dC84MDIxcS92bGFuLmMgYi9uZXQvODAyMXEvdmxhbi5jDQppbmRleCA1NDcxNjI4Li45NjNmMjg1
IDEwMDY0NA0KLS0tIGEvbmV0LzgwMjFxL3ZsYW4uYw0KKysrIGIvbmV0LzgwMjFxL3ZsYW4uYw0K
QEAgLTExMCwxMyArMTEwLDYgQEAgdm9pZCB1bnJlZ2lzdGVyX3ZsYW5fZGV2KHN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYsIHN0cnVjdCBsaXN0X2hlYWQgKmhlYWQpDQogCWdycCA9IHJ0bmxfZGVyZWZl
cmVuY2UocmVhbF9kZXYtPnZsZ3JwKTsNCiAJQlVHX09OKCFncnApOw0KIA0KLQkvKiBUYWtlIGl0
IG91dCBvZiBvdXIgb3duIHN0cnVjdHVyZXMsIGJ1dCBiZSBzdXJlIHRvIGludGVybG9jayB3aXRo
DQotCSAqIEhXIGFjY2VsZXJhdGluZyBkZXZpY2VzIG9yIFNXIHZsYW4gaW5wdXQgcGFja2V0IHBy
b2Nlc3NpbmcgaWYNCi0JICogVkxBTiBpcyBub3QgMCAobGVhdmUgaXQgdGhlcmUgZm9yIDgwMi4x
cCkuDQotCSAqLw0KLQlpZiAodmxhbl9pZCAmJiAocmVhbF9kZXYtPmZlYXR1cmVzICYgTkVUSUZf
Rl9IV19WTEFOX0ZJTFRFUikpDQotCQlvcHMtPm5kb192bGFuX3J4X2tpbGxfdmlkKHJlYWxfZGV2
LCB2bGFuX2lkKTsNCi0NCiAJZ3JwLT5ucl92bGFucy0tOw0KIA0KIAlpZiAodmxhbi0+ZmxhZ3Mg
JiBWTEFOX0ZMQUdfR1ZSUCkNCkBAIC0xMzksNiArMTMyLDEzIEBAIHZvaWQgdW5yZWdpc3Rlcl92
bGFuX2RldihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgbGlzdF9oZWFkICpoZWFkKQ0K
IAkJY2FsbF9yY3UoJmdycC0+cmN1LCB2bGFuX3JjdV9mcmVlKTsNCiAJfQ0KIA0KKwkvKiBUYWtl
IGl0IG91dCBvZiBvdXIgb3duIHN0cnVjdHVyZXMsIGJ1dCBiZSBzdXJlIHRvIGludGVybG9jayB3
aXRoDQorCSAqIEhXIGFjY2VsZXJhdGluZyBkZXZpY2VzIG9yIFNXIHZsYW4gaW5wdXQgcGFja2V0
IHByb2Nlc3NpbmcgaWYNCisJICogVkxBTiBpcyBub3QgMCAobGVhdmUgaXQgdGhlcmUgZm9yIDgw
Mi4xcCkuDQorCSAqLw0KKwlpZiAodmxhbl9pZCAmJiAocmVhbF9kZXYtPmZlYXR1cmVzICYgTkVU
SUZfRl9IV19WTEFOX0ZJTFRFUikpDQorCQlvcHMtPm5kb192bGFuX3J4X2tpbGxfdmlkKHJlYWxf
ZGV2LCB2bGFuX2lkKTsNCisNCiAJLyogR2V0IHJpZCBvZiB0aGUgdmxhbidzIHJlZmVyZW5jZSB0
byByZWFsX2RldiAqLw0KIAlkZXZfcHV0KHJlYWxfZGV2KTsNCiB9DQpkaWZmIC0tZ2l0IGEvbmV0
L2NvcmUvZGV2LmMgYi9uZXQvY29yZS9kZXYuYw0KaW5kZXggYjIzYmJiZi4uNzIwYWVhMCAxMDA2
NDQNCi0tLSBhL25ldC9jb3JlL2Rldi5jDQorKysgYi9uZXQvY29yZS9kZXYuYw0KQEAgLTMxOTMs
NiArMzE5Myw3IEBAIGludCBuZXRkZXZfcnhfaGFuZGxlcl9yZWdpc3RlcihzdHJ1Y3QgbmV0X2Rl
dmljZSAqZGV2LA0KIAlpZiAoZGV2LT5yeF9oYW5kbGVyKQ0KIAkJcmV0dXJuIC1FQlVTWTsNCiAN
CisJLyogTm90ZTogcnhfaGFuZGxlcl9kYXRhIG11c3QgYmUgc2V0IGJlZm9yZSByeF9oYW5kbGVy
ICovDQogCXJjdV9hc3NpZ25fcG9pbnRlcihkZXYtPnJ4X2hhbmRsZXJfZGF0YSwgcnhfaGFuZGxl
cl9kYXRhKTsNCiAJcmN1X2Fzc2lnbl9wb2ludGVyKGRldi0+cnhfaGFuZGxlciwgcnhfaGFuZGxl
cik7DQogDQpAQCAtMzIxMyw2ICszMjE0LDExIEBAIHZvaWQgbmV0ZGV2X3J4X2hhbmRsZXJfdW5y
ZWdpc3RlcihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KIA0KIAlBU1NFUlRfUlROTCgpOw0KIAlS
Q1VfSU5JVF9QT0lOVEVSKGRldi0+cnhfaGFuZGxlciwgTlVMTCk7DQorCS8qIGEgcmVhZGVyIHNl
ZWluZyBhIG5vbiBOVUxMIHJ4X2hhbmRsZXIgaW4gYSByY3VfcmVhZF9sb2NrKCkNCisJICogc2Vj
dGlvbiBoYXMgYSBndWFyYW50ZWUgdG8gc2VlIGEgbm9uIE5VTEwgcnhfaGFuZGxlcl9kYXRhDQor
CSAqIGFzIHdlbGwuDQorCSAqLw0KKwlzeW5jaHJvbml6ZV9uZXQoKTsNCiAJUkNVX0lOSVRfUE9J
TlRFUihkZXYtPnJ4X2hhbmRsZXJfZGF0YSwgTlVMTCk7DQogfQ0KIEVYUE9SVF9TWU1CT0xfR1BM
KG5ldGRldl9yeF9oYW5kbGVyX3VucmVnaXN0ZXIpOw0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L3Rj
cF9pbnB1dC5jIGIvbmV0L2lwdjQvdGNwX2lucHV0LmMNCmluZGV4IDFiMWY3YWYuLjMxMjRlMTcg
MTAwNjQ0DQotLS0gYS9uZXQvaXB2NC90Y3BfaW5wdXQuYw0KKysrIGIvbmV0L2lwdjQvdGNwX2lu
cHV0LmMNCkBAIC0yMjY1LDExICsyMjY1LDggQEAgdm9pZCB0Y3BfZW50ZXJfbG9zcyhzdHJ1Y3Qg
c29jayAqc2ssIGludCBob3cpDQogCWlmICh0Y3BfaXNfcmVubyh0cCkpDQogCQl0Y3BfcmVzZXRf
cmVub19zYWNrKHRwKTsNCiANCi0JaWYgKCFob3cpIHsNCi0JCS8qIFB1c2ggdW5kbyBtYXJrZXIs
IGlmIGl0IHdhcyBwbGFpbiBSVE8gYW5kIG5vdGhpbmcNCi0JCSAqIHdhcyByZXRyYW5zbWl0dGVk
LiAqLw0KLQkJdHAtPnVuZG9fbWFya2VyID0gdHAtPnNuZF91bmE7DQotCX0gZWxzZSB7DQorCXRw
LT51bmRvX21hcmtlciA9IHRwLT5zbmRfdW5hOw0KKwlpZiAoaG93KSB7DQogCQl0cC0+c2Fja2Vk
X291dCA9IDA7DQogCQl0cC0+ZmFja2V0c19vdXQgPSAwOw0KIAl9DQpkaWZmIC0tZ2l0IGEvbmV0
L2lwdjQvdGNwX291dHB1dC5jIGIvbmV0L2lwdjQvdGNwX291dHB1dC5jDQppbmRleCA5YmI3NDAw
Li41YzE4MDdjIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQvdGNwX291dHB1dC5jDQorKysgYi9uZXQv
aXB2NC90Y3Bfb3V0cHV0LmMNCkBAIC0xNTg3LDggKzE1ODcsMTEgQEAgc3RhdGljIGludCB0Y3Bf
dHNvX3Nob3VsZF9kZWZlcihzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19idWZmICpza2IpDQog
CQkJZ290byBzZW5kX25vdzsNCiAJfQ0KIA0KLQkvKiBPaywgaXQgbG9va3MgbGlrZSBpdCBpcyBh
ZHZpc2FibGUgdG8gZGVmZXIuICAqLw0KLQl0cC0+dHNvX2RlZmVycmVkID0gMSB8IChqaWZmaWVz
IDw8IDEpOw0KKwkvKiBPaywgaXQgbG9va3MgbGlrZSBpdCBpcyBhZHZpc2FibGUgdG8gZGVmZXIu
DQorCSAqIERvIG5vdCByZWFybSB0aGUgdGltZXIgaWYgYWxyZWFkeSBzZXQgdG8gbm90IGJyZWFr
IFRDUCBBQ0sgY2xvY2tpbmcuDQorCSAqLw0KKwlpZiAoIXRwLT50c29fZGVmZXJyZWQpDQorCQl0
cC0+dHNvX2RlZmVycmVkID0gMSB8IChqaWZmaWVzIDw8IDEpOw0KIA0KIAlyZXR1cm4gMTsNCiAN
CmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9hZGRyY29uZi5jIGIvbmV0L2lwdjYvYWRkcmNvbmYuYw0K
aW5kZXggYjI3YmFlZC4uODU4OWMyZCAxMDA2NDQNCi0tLSBhL25ldC9pcHY2L2FkZHJjb25mLmMN
CisrKyBiL25ldC9pcHY2L2FkZHJjb25mLmMNCkBAIC00NjU4LDI2ICs0NjU4LDIwIEBAIHN0YXRp
YyB2b2lkIGFkZHJjb25mX3N5c2N0bF91bnJlZ2lzdGVyKHN0cnVjdCBpbmV0Nl9kZXYgKmlkZXYp
DQogDQogc3RhdGljIGludCBfX25ldF9pbml0IGFkZHJjb25mX2luaXRfbmV0KHN0cnVjdCBuZXQg
Km5ldCkNCiB7DQotCWludCBlcnI7DQorCWludCBlcnIgPSAtRU5PTUVNOw0KIAlzdHJ1Y3QgaXB2
Nl9kZXZjb25mICphbGwsICpkZmx0Ow0KIA0KLQllcnIgPSAtRU5PTUVNOw0KLQlhbGwgPSAmaXB2
Nl9kZXZjb25mOw0KLQlkZmx0ID0gJmlwdjZfZGV2Y29uZl9kZmx0Ow0KKwlhbGwgPSBrbWVtZHVw
KCZpcHY2X2RldmNvbmYsIHNpemVvZihpcHY2X2RldmNvbmYpLCBHRlBfS0VSTkVMKTsNCisJaWYg
KGFsbCA9PSBOVUxMKQ0KKwkJZ290byBlcnJfYWxsb2NfYWxsOw0KIA0KLQlpZiAoIW5ldF9lcShu
ZXQsICZpbml0X25ldCkpIHsNCi0JCWFsbCA9IGttZW1kdXAoYWxsLCBzaXplb2YoaXB2Nl9kZXZj
b25mKSwgR0ZQX0tFUk5FTCk7DQotCQlpZiAoYWxsID09IE5VTEwpDQotCQkJZ290byBlcnJfYWxs
b2NfYWxsOw0KKwlkZmx0ID0ga21lbWR1cCgmaXB2Nl9kZXZjb25mX2RmbHQsIHNpemVvZihpcHY2
X2RldmNvbmZfZGZsdCksIEdGUF9LRVJORUwpOw0KKwlpZiAoZGZsdCA9PSBOVUxMKQ0KKwkJZ290
byBlcnJfYWxsb2NfZGZsdDsNCiANCi0JCWRmbHQgPSBrbWVtZHVwKGRmbHQsIHNpemVvZihpcHY2
X2RldmNvbmZfZGZsdCksIEdGUF9LRVJORUwpOw0KLQkJaWYgKGRmbHQgPT0gTlVMTCkNCi0JCQln
b3RvIGVycl9hbGxvY19kZmx0Ow0KLQl9IGVsc2Ugew0KLQkJLyogdGhlc2Ugd2lsbCBiZSBpbmhl
cml0ZWQgYnkgYWxsIG5hbWVzcGFjZXMgKi8NCi0JCWRmbHQtPmF1dG9jb25mID0gaXB2Nl9kZWZh
dWx0cy5hdXRvY29uZjsNCi0JCWRmbHQtPmRpc2FibGVfaXB2NiA9IGlwdjZfZGVmYXVsdHMuZGlz
YWJsZV9pcHY2Ow0KLQl9DQorCS8qIHRoZXNlIHdpbGwgYmUgaW5oZXJpdGVkIGJ5IGFsbCBuYW1l
c3BhY2VzICovDQorCWRmbHQtPmF1dG9jb25mID0gaXB2Nl9kZWZhdWx0cy5hdXRvY29uZjsNCisJ
ZGZsdC0+ZGlzYWJsZV9pcHY2ID0gaXB2Nl9kZWZhdWx0cy5kaXNhYmxlX2lwdjY7DQogDQogCW5l
dC0+aXB2Ni5kZXZjb25mX2FsbCA9IGFsbDsNCiAJbmV0LT5pcHY2LmRldmNvbmZfZGZsdCA9IGRm
bHQ7DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvaXA2X2lucHV0LmMgYi9uZXQvaXB2Ni9pcDZfaW5w
dXQuYw0KaW5kZXggZjhkMjRkZC4uNmE0ZjRmMyAxMDA2NDQNCi0tLSBhL25ldC9pcHY2L2lwNl9p
bnB1dC5jDQorKysgYi9uZXQvaXB2Ni9pcDZfaW5wdXQuYw0KQEAgLTExMSw2ICsxMTEsMjcgQEAg
aW50IGlwdjZfcmN2KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYs
IHN0cnVjdCBwYWNrZXRfdHlwZSAqcHQNCiAJICAgIGlwdjZfYWRkcl9sb29wYmFjaygmaGRyLT5k
YWRkcikpDQogCQlnb3RvIGVycjsNCiANCisJLyogUkZDNDI5MSBFcnJhdGEgSUQ6IDM0ODANCisJ
ICogSW50ZXJmYWNlLUxvY2FsIHNjb3BlIHNwYW5zIG9ubHkgYSBzaW5nbGUgaW50ZXJmYWNlIG9u
IGENCisJICogbm9kZSBhbmQgaXMgdXNlZnVsIG9ubHkgZm9yIGxvb3BiYWNrIHRyYW5zbWlzc2lv
biBvZg0KKwkgKiBtdWx0aWNhc3QuICBQYWNrZXRzIHdpdGggaW50ZXJmYWNlLWxvY2FsIHNjb3Bl
IHJlY2VpdmVkDQorCSAqIGZyb20gYW5vdGhlciBub2RlIG11c3QgYmUgZGlzY2FyZGVkLg0KKwkg
Ki8NCisJaWYgKCEoc2tiLT5wa3RfdHlwZSA9PSBQQUNLRVRfTE9PUEJBQ0sgfHwNCisJICAgICAg
ZGV2LT5mbGFncyAmIElGRl9MT09QQkFDSykgJiYNCisJICAgIGlwdjZfYWRkcl9pc19tdWx0aWNh
c3QoJmhkci0+ZGFkZHIpICYmDQorCSAgICBJUFY2X0FERFJfTUNfU0NPUEUoJmhkci0+ZGFkZHIp
ID09IDEpDQorCQlnb3RvIGVycjsNCisNCisJLyogUkZDNDI5MSAyLjcNCisJICogTm9kZXMgbXVz
dCBub3Qgb3JpZ2luYXRlIGEgcGFja2V0IHRvIGEgbXVsdGljYXN0IGFkZHJlc3Mgd2hvc2Ugc2Nv
cGUNCisJICogZmllbGQgY29udGFpbnMgdGhlIHJlc2VydmVkIHZhbHVlIDA7IGlmIHN1Y2ggYSBw
YWNrZXQgaXMgcmVjZWl2ZWQsIGl0DQorCSAqIG11c3QgYmUgc2lsZW50bHkgZHJvcHBlZC4NCisJ
ICovDQorCWlmIChpcHY2X2FkZHJfaXNfbXVsdGljYXN0KCZoZHItPmRhZGRyKSAmJg0KKwkgICAg
SVBWNl9BRERSX01DX1NDT1BFKCZoZHItPmRhZGRyKSA9PSAwKQ0KKwkJZ290byBlcnI7DQorDQog
CS8qDQogCSAqIFJGQzQyOTEgMi43DQogCSAqIE11bHRpY2FzdCBhZGRyZXNzZXMgbXVzdCBub3Qg
YmUgdXNlZCBhcyBzb3VyY2UgYWRkcmVzc2VzIGluIElQdjYNCmRpZmYgLS1naXQgYS9uZXQvaXJk
YS9hZl9pcmRhLmMgYi9uZXQvaXJkYS9hZl9pcmRhLmMNCmluZGV4IGMyNGYyNWEuLmY0YjQ5YzUg
MTAwNjQ0DQotLS0gYS9uZXQvaXJkYS9hZl9pcmRhLmMNCisrKyBiL25ldC9pcmRhL2FmX2lyZGEu
Yw0KQEAgLTI1ODQsOCArMjU4NCwxMCBAQCBiZWQ6DQogCQkJCSAgICBOVUxMLCBOVUxMLCBOVUxM
KTsNCiANCiAJCS8qIENoZWNrIGlmIHRoZSB3ZSBnb3Qgc29tZSByZXN1bHRzICovDQotCQlpZiAo
IXNlbGYtPmNhY2hlZGFkZHIpDQotCQkJcmV0dXJuIC1FQUdBSU47CQkvKiBEaWRuJ3QgZmluZCBh
bnkgZGV2aWNlcyAqLw0KKwkJaWYgKCFzZWxmLT5jYWNoZWRhZGRyKSB7DQorCQkJZXJyID0gLUVB
R0FJTjsJCS8qIERpZG4ndCBmaW5kIGFueSBkZXZpY2VzICovDQorCQkJZ290byBvdXQ7DQorCQl9
DQogCQlkYWRkciA9IHNlbGYtPmNhY2hlZGFkZHI7DQogCQkvKiBDbGVhbnVwICovDQogCQlzZWxm
LT5jYWNoZWRhZGRyID0gMDsNCmRpZmYgLS1naXQgYS9uZXQvbmV0bGluay9nZW5ldGxpbmsuYyBi
L25ldC9uZXRsaW5rL2dlbmV0bGluay5jDQppbmRleCA0ODJmYTU3Li44NzRmOGZmIDEwMDY0NA0K
LS0tIGEvbmV0L25ldGxpbmsvZ2VuZXRsaW5rLmMNCisrKyBiL25ldC9uZXRsaW5rL2dlbmV0bGlu
ay5jDQpAQCAtMTM0LDYgKzEzNCw3IEBAIGludCBnZW5sX3JlZ2lzdGVyX21jX2dyb3VwKHN0cnVj
dCBnZW5sX2ZhbWlseSAqZmFtaWx5LA0KIAlpbnQgZXJyID0gMDsNCiANCiAJQlVHX09OKGdycC0+
bmFtZVswXSA9PSAnXDAnKTsNCisJQlVHX09OKG1lbWNocihncnAtPm5hbWUsICdcMCcsIEdFTkxf
TkFNU0laKSA9PSBOVUxMKTsNCiANCiAJZ2VubF9sb2NrKCk7DQogDQpkaWZmIC0tZ2l0IGEvbmV0
L3N1bnJwYy9zY2hlZC5jIGIvbmV0L3N1bnJwYy9zY2hlZC5jDQppbmRleCAxOGM1YTUwLi5kYzZh
ZjI3IDEwMDY0NA0KLS0tIGEvbmV0L3N1bnJwYy9zY2hlZC5jDQorKysgYi9uZXQvc3VucnBjL3Nj
aGVkLmMNCkBAIC0xMzksNiArMTM5LDggQEAgc3RhdGljIHZvaWQgX19ycGNfYWRkX3dhaXRfcXVl
dWUoc3RydWN0IHJwY193YWl0X3F1ZXVlICpxdWV1ZSwNCiAJCWxpc3RfYWRkX3RhaWwoJnRhc2st
PnUudGtfd2FpdC5saXN0LCAmcXVldWUtPnRhc2tzWzBdKTsNCiAJdGFzay0+dGtfd2FpdHF1ZXVl
ID0gcXVldWU7DQogCXF1ZXVlLT5xbGVuKys7DQorCS8qIGJhcnJpZXIgbWF0Y2hlcyB0aGUgcmVh
ZCBpbiBycGNfd2FrZV91cF90YXNrX3F1ZXVlX2xvY2tlZCgpICovDQorCXNtcF93bWIoKTsNCiAJ
cnBjX3NldF9xdWV1ZWQodGFzayk7DQogDQogCWRwcmludGsoIlJQQzogJTV1IGFkZGVkIHRvIHF1
ZXVlICVwIFwiJXNcIlxuIiwNCkBAIC0zODksOCArMzkxLDExIEBAIHN0YXRpYyB2b2lkIF9fcnBj
X2RvX3dha2VfdXBfdGFzayhzdHJ1Y3QgcnBjX3dhaXRfcXVldWUgKnF1ZXVlLCBzdHJ1Y3QgcnBj
X3Rhc2sNCiAgKi8NCiBzdGF0aWMgdm9pZCBycGNfd2FrZV91cF90YXNrX3F1ZXVlX2xvY2tlZChz
dHJ1Y3QgcnBjX3dhaXRfcXVldWUgKnF1ZXVlLCBzdHJ1Y3QgcnBjX3Rhc2sgKnRhc2spDQogew0K
LQlpZiAoUlBDX0lTX1FVRVVFRCh0YXNrKSAmJiB0YXNrLT50a193YWl0cXVldWUgPT0gcXVldWUp
DQotCQlfX3JwY19kb193YWtlX3VwX3Rhc2socXVldWUsIHRhc2spOw0KKwlpZiAoUlBDX0lTX1FV
RVVFRCh0YXNrKSkgew0KKwkJc21wX3JtYigpOw0KKwkJaWYgKHRhc2stPnRrX3dhaXRxdWV1ZSA9
PSBxdWV1ZSkNCisJCQlfX3JwY19kb193YWtlX3VwX3Rhc2socXVldWUsIHRhc2spOw0KKwl9DQog
fQ0KIA0KIC8qDQpkaWZmIC0tZ2l0IGEvbmV0L3VuaXgvYWZfdW5peC5jIGIvbmV0L3VuaXgvYWZf
dW5peC5jDQppbmRleCAzMTdiZmUzLi4xODk3OGI2IDEwMDY0NA0KLS0tIGEvbmV0L3VuaXgvYWZf
dW5peC5jDQorKysgYi9uZXQvdW5peC9hZl91bml4LmMNCkBAIC0zNzEsNyArMzcxLDcgQEAgc3Rh
dGljIHZvaWQgdW5peF9zb2NrX2Rlc3RydWN0b3Ioc3RydWN0IHNvY2sgKnNrKQ0KICNlbmRpZg0K
IH0NCiANCi1zdGF0aWMgaW50IHVuaXhfcmVsZWFzZV9zb2NrKHN0cnVjdCBzb2NrICpzaywgaW50
IGVtYnJpb24pDQorc3RhdGljIHZvaWQgdW5peF9yZWxlYXNlX3NvY2soc3RydWN0IHNvY2sgKnNr
LCBpbnQgZW1icmlvbikNCiB7DQogCXN0cnVjdCB1bml4X3NvY2sgKnUgPSB1bml4X3NrKHNrKTsN
CiAJc3RydWN0IGRlbnRyeSAqZGVudHJ5Ow0KQEAgLTQ0NCw4ICs0NDQsNiBAQCBzdGF0aWMgaW50
IHVuaXhfcmVsZWFzZV9zb2NrKHN0cnVjdCBzb2NrICpzaywgaW50IGVtYnJpb24pDQogDQogCWlm
ICh1bml4X3RvdF9pbmZsaWdodCkNCiAJCXVuaXhfZ2MoKTsJCS8qIEdhcmJhZ2UgY29sbGVjdCBm
ZHMgKi8NCi0NCi0JcmV0dXJuIDA7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIGluaXRfcGVlcmNyZWQo
c3RydWN0IHNvY2sgKnNrKQ0KQEAgLTY4Miw5ICs2ODAsMTAgQEAgc3RhdGljIGludCB1bml4X3Jl
bGVhc2Uoc3RydWN0IHNvY2tldCAqc29jaykNCiAJaWYgKCFzaykNCiAJCXJldHVybiAwOw0KIA0K
Kwl1bml4X3JlbGVhc2Vfc29jayhzaywgMCk7DQogCXNvY2stPnNrID0gTlVMTDsNCiANCi0JcmV0
dXJuIHVuaXhfcmVsZWFzZV9zb2NrKHNrLCAwKTsNCisJcmV0dXJuIDA7DQogfQ0KIA0KIHN0YXRp
YyBpbnQgdW5peF9hdXRvYmluZChzdHJ1Y3Qgc29ja2V0ICpzb2NrKQ0KZGlmZiAtLWdpdCBhL3Nl
Y3VyaXR5L2tleXMva2V5Y3RsLmMgYi9zZWN1cml0eS9rZXlzL2tleWN0bC5jDQppbmRleCAwYjNm
NWQ3Li5iNzBlYWEyIDEwMDY0NA0KLS0tIGEvc2VjdXJpdHkva2V5cy9rZXljdGwuYw0KKysrIGIv
c2VjdXJpdHkva2V5cy9rZXljdGwuYw0KQEAgLTEwNjcsMTIgKzEwNjcsMTIgQEAgbG9uZyBrZXlj
dGxfaW5zdGFudGlhdGVfa2V5X2lvdihrZXlfc2VyaWFsX3QgaWQsDQogCXJldCA9IHJ3X2NvcHlf
Y2hlY2tfdXZlY3RvcihXUklURSwgX3BheWxvYWRfaW92LCBpb2MsDQogCQkJCSAgICBBUlJBWV9T
SVpFKGlvdnN0YWNrKSwgaW92c3RhY2ssICZpb3YsIDEpOw0KIAlpZiAocmV0IDwgMCkNCi0JCXJl
dHVybiByZXQ7DQorCQlnb3RvIGVycjsNCiAJaWYgKHJldCA9PSAwKQ0KIAkJZ290byBub19wYXls
b2FkX2ZyZWU7DQogDQogCXJldCA9IGtleWN0bF9pbnN0YW50aWF0ZV9rZXlfY29tbW9uKGlkLCBp
b3YsIGlvYywgcmV0LCByaW5naWQpOw0KLQ0KK2VycjoNCiAJaWYgKGlvdiAhPSBpb3ZzdGFjaykN
CiAJCWtmcmVlKGlvdik7DQogCXJldHVybiByZXQ7DQpkaWZmIC0tZ2l0IGEvc291bmQvc29jL2lt
eC9pbXgtc3NpLmMgYi9zb3VuZC9zb2MvaW14L2lteC1zc2kuYw0KaW5kZXggOTcxZWFmMC4uNDk2
OWM5OCAxMDA2NDQNCi0tLSBhL3NvdW5kL3NvYy9pbXgvaW14LXNzaS5jDQorKysgYi9zb3VuZC9z
b2MvaW14L2lteC1zc2kuYw0KQEAgLTU3Myw2ICs1NzMsOCBAQCBzdGF0aWMgdm9pZCBpbXhfc3Np
X2FjOTdfcmVzZXQoc3RydWN0IHNuZF9hYzk3ICphYzk3KQ0KIA0KIAlpZiAoaW14X3NzaS0+YWM5
N19yZXNldCkNCiAJCWlteF9zc2ktPmFjOTdfcmVzZXQoYWM5Nyk7DQorCS8qIEZpcnN0IHJlYWQg
c29tZXRpbWVzIGZhaWxzLCBkbyBhIGR1bW15IHJlYWQgKi8NCisJaW14X3NzaV9hYzk3X3JlYWQo
YWM5NywgMCk7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIGlteF9zc2lfYWM5N193YXJtX3Jlc2V0KHN0
cnVjdCBzbmRfYWM5NyAqYWM5NykNCkBAIC01ODEsNiArNTgzLDkgQEAgc3RhdGljIHZvaWQgaW14
X3NzaV9hYzk3X3dhcm1fcmVzZXQoc3RydWN0IHNuZF9hYzk3ICphYzk3KQ0KIA0KIAlpZiAoaW14
X3NzaS0+YWM5N193YXJtX3Jlc2V0KQ0KIAkJaW14X3NzaS0+YWM5N193YXJtX3Jlc2V0KGFjOTcp
Ow0KKw0KKwkvKiBGaXJzdCByZWFkIHNvbWV0aW1lcyBmYWlscywgZG8gYSBkdW1teSByZWFkICov
DQorCWlteF9zc2lfYWM5N19yZWFkKGFjOTcsIDApOw0KIH0NCiANCiBzdHJ1Y3Qgc25kX2FjOTdf
YnVzX29wcyBzb2NfYWM5N19vcHMgPSB7DQpkaWZmIC0tZ2l0IGEvc291bmQvc29jL3NoL2RtYS1z
aDc3NjAuYyBiL3NvdW5kL3NvYy9zaC9kbWEtc2g3NzYwLmMNCmluZGV4IGRiNzQwMDUuLjFhNzU3
YzMgMTAwNjQ0DQotLS0gYS9zb3VuZC9zb2Mvc2gvZG1hLXNoNzc2MC5jDQorKysgYi9zb3VuZC9z
b2Mvc2gvZG1hLXNoNzc2MC5jDQpAQCAtMzQyLDggKzM0Miw4IEBAIHN0YXRpYyBpbnQgY2FtZWxv
dF9wY21fbmV3KHN0cnVjdCBzbmRfc29jX3BjbV9ydW50aW1lICpydGQpDQogCXJldHVybiAwOw0K
IH0NCiANCi1zdGF0aWMgc3RydWN0IHNuZF9zb2NfcGxhdGZvcm0gc2g3NzYwX3NvY19wbGF0Zm9y
bSA9IHsNCi0JLnBjbV9vcHMgCT0gJmNhbWVsb3RfcGNtX29wcywNCitzdGF0aWMgc3RydWN0IHNu
ZF9zb2NfcGxhdGZvcm1fZHJpdmVyIHNoNzc2MF9zb2NfcGxhdGZvcm0gPSB7DQorCS5vcHMJCT0g
JmNhbWVsb3RfcGNtX29wcywNCiAJLnBjbV9uZXcJPSBjYW1lbG90X3BjbV9uZXcsDQogCS5wY21f
ZnJlZQk9IGNhbWVsb3RfcGNtX2ZyZWUsDQogfTsNCm==


--=-PPJ2WdjtiL/c7yRVODFw--

--=-XvhQ9NkkmMjRyOzVZq7T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUWVB9ee/yOyVhhEJAQoV0BAAqlsjHKpivEpDmD1otPVmYxsLb/JEmFA2
tBGmhu6HBGrWJiE4k3K9QLDbOL5PPeM3XizYfhKlqbz+Rf9RNkhtrRw10ywbufXU
OZukc695U2/nwWL45IaOLwiF37iTiaBi17Ycoh2BwsmBlzUymAo1Qw4xZdKzLQXl
Q4n4qZysJyvH6++P0oDsXeR9Ka/o9GvBQbwBdRikIDPMiUnZ1ncIEGKjd9qfshUJ
xz0dxmcpxXY5cBsEJU8bwjwvoVrZt5S+teKjpXS+rWLolQaeoDsNa2nJpbce8aCo
kYYITj3vGKXOdREglSHRderuqKuQQtrHp2gWONIjG65XvS08ZFOBYbZH7NMZozfx
qFp9VP3hhmUaDowh/YmUj4EWFRs0lIcEee4yq7KUm+x4Vz0BzCk9TkfgFV4tVphX
wCC5guAfL7b7TM8+DLjIVXmLwnUd6KEuDrRsRxyIvShhD4TSZ6TwJP0uUry4AphM
lMszg2dbJwd+Ek6kWdBzfy1OpPJM+Qcz766IWI6BJH/ozlg1UVLnOvyqNST7cjhQ
jaS/6lVrAD4pduJK4j3iWfijwKv4cimFsoTuoOqtxdnRGy0Fgji+fs7tnheSpr9z
LqM5FEIp8YLyQDpJ7lcMAA4XiM//kqlyiFFC0o5oWa0XhUZoJs1C11jSAPRsO8T5
4LS7exEf9dg=
=kUH+
-----END PGP SIGNATURE-----

--=-XvhQ9NkkmMjRyOzVZq7T--
