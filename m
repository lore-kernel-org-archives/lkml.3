Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495Ab3DGXZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:25:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46541 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757645Ab3DGXZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:25:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.214522651@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [00/74] 3.2.43-rc1 review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.43 release.
There are 74 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Apr 09 23:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.42 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

AceLan Kao (3):
      Bluetooth: Add support for Foxconn / Hon Hai [0489:e04e]
         [3a61eda81ebcfc006ebb1496764299d53e5bf67f]
      Bluetooth: Add support for Foxconn / Hon Hai [0489:e056]
         [2582d529c44d12502a700f1c3db062b9f44679bc]
      Bluetooth: Add support for IMC Networks [13d3:3393]
         [eed307e290b96636def331375e065aca43f9069a]

Al Viro (2):
      Nest rename_lock inside vfsmount_lock
         [7ea600b5314529f9d1b9d6d3c41cb26fce6a7a4a]
      vt: synchronize_rcu() under spinlock is not nice...
         [e8cd81693bbbb15db57d3c9aa7dd90eda4842874]

Alan Cox (1):
      key: Fix resource leak
         [a84a921978b7d56e0e4b87ffaca6367429b4d8ff]

Amit Shah (2):
      virtio: console: add locking around c_ovq operations
         [9ba5c80b1aea8648a3efe5f22dc1f7cacdfbeeb8]
      virtio: console: rename cvq_lock to c_ivq_lock
         [165b1b8bbc17c9469b053bab78b11b7cbce6d161]

Anatol Pomozov (1):
      loop: prevent bdev freeing while device in use
         [c1681bf8a7b1b98edee8b862a42c19c4e53205fd]

Anatolij Gustschin (1):
      spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts
         [1ad849aee5f53353ed88d9cd3d68a51b03a7d44f]

Artem Bityutskiy (1):
      UBIFS: make space fixup work in the remount case
         [67e753ca41782913d805ff4a8a2b0f60b26b7915]

Chris Metcalf (1):
      tile: expect new initramfs name from hypervisor file system
         [ff7f3efb9abf986f4ecd8793a9593f7ca4d6431a]

Chuck Lever (1):
      NFS: nfs_getaclargs.acl_len is a size_t
         [56d08fef2369d5ca9ad2e1fc697f5379fd8af751]

Cong Wang (1):
      8021q: fix a potential use-after-free
         [4a7df340ed1bac190c124c1601bfc10cde9fb4fb]

Daniel Schaal (1):
      Bluetooth: Add support for GC-WB300D PCIe [04ca:3006] to ath3k.
         [2c262b2a5235b7f5b18d4d58394511f76371d7cb]

Eric Dumazet (3):
      aoe: reserve enough headroom on skbs
         [91c5746425aed8f7188a351f1224a26aa232e4b3]
      net: add a synchronize_net() in  netdev_rx_handler_unregister()
         [00cfec37484761a44a3b6f4675a54caa618210ae]
      tcp: preserve ACK clocking in TSO
         [f4541d60a449afd40448b06496dcd510f505928e]

Fanchaoting (1):
      pnfs-block: removing DM device maybe cause oops when call dev_remove
         [4376c94618c26225e69e17b7c91169c45a90b292]

Felix Fietkau (2):
      ath9k_hw: revert chainmask to user configuration after calibration
         [74632d11a133b5baf6b9d622dd19d2f944d93d94]
      rt2x00: error in configurations with  mesh support disabled
         [6ef9e2f6d12ce9e2120916804d2ddd46b954a70b]

Hannes Frederic Sowa (3):
      atl1e: drop pci-msi support because of packet  corruption
         [188ab1b105c96656f6bcfb49d0d8bb1b1936b632]
      ipv6: don't accept multicast traffic with scope 0
         [20314092c1b41894d8c181bf9aa6f022be2416aa]
      ipv6: don't accept node local multicast traffic from  the wire
         [1c4a154e5253687c51123956dfcee9e9dfa8542d]

Hong Zhiguo (1):
      ipv6: fix bad free of addrconf_init_net
         [a79ca223e029aa4f09abb337accf1812c900a800]

Ian Abbott (1):
      staging: comedi: s626: fix continuous acquisition
         [e4317ce877a31dbb9d96375391c1c4ad2210d637]

Iestyn C. Elfick (1):
      b43: A fix for DMA transmission sequence errors
         [b251412db99ccd4495ce372fec7daee27bf06923]

J. Bruce Fields (1):
      nfsd4: reject "negative" acl lengths
         [64a817cfbded8674f345d1117b117f942a351a69]

Jakub Kicinski (1):
      ixgbe: fix registration order of driver and DCA nofitication
         [f01fc1a82c2ee68726b400fadb156bd623b5f2f1]

Jan Beulich (1):
      xen-blkback: fix dispatch_rw_block_io() error path
         [0e5e098ac22dae38f957e951b70d3cf73beff0f7]

Jan Kara (2):
      reiserfs: Fix warning and inode leak when deleting inode with xattrs
         [35e5cbc0af240778e61113286c019837e06aeec6]
      udf: Fix bitmap overflow on large filesystems with small block size
         [89b1f39eb4189de745fae554b0d614d87c8d5c63]

Jan Stancek (1):
      mm: prevent mmap_cache race in find_vma()
         [b6a9b7f6b1f21735a7456d534dc0e68e61359d2c]

Jiri Kosina (1):
      HID: usbhid: fix build problem
         [570637dc8eeb2faba06228d497ff40bb019bcc93]

Jiri Slaby (1):
      HID: microsoft: do not use compound literal - fix build
         [6b90466cfec2a2fe027187d675d8d14217c12d82]

Joerg Roedel (1):
      iommu/amd: Make sure dma_ops are set for hotplug devices
         [c2a2876e863356b092967ea62bebdb4dd663af80]

Josef Bacik (1):
      Btrfs: limit the global reserve to 512mb
         [fdf30d1c1b386e1b73116cc7e0fb14e962b763b0]

Joseph CHANG (1):
      DM9000B: driver initialization upgrade
         [6741f40d198c6a5feb23653a1efd4ca47f93d83d]

Josh Boyer (3):
      Bluetooth: Add support for atheros 04ca:3004 device to ath3k
         [3f63c340a72f2872a9362245cb2e03f3d2bb73a6]
      HID: usbhid: quirk for MSI GX680R led panel
         [620ae90ed8ca8b6e40cb9e10279b4f5ef9f0ab81]
      HID: usbhid: quirk for Realtek Multi-card reader
         [3d464d9b71ef2f2b40a4bc9dcf06794fd1be9d12]

Jussi Kivilinna (1):
      rtlwifi: usb: add missing freeing of skbuff
         [36ef0b473fbf43d5db23eea4616cc1d18cec245f]

Kees Cook (2):
      net/irda: add missing error path release_sock call
         [896ee0eee6261e30c3623be931c3f621428947df]
      tg3: fix length overflow in VPD firmware parsing
         [715230a44310a8cf66fbfb5a46f9a62a9b2de424]

Konstantin Holoborodko (1):
      usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD
         [482b0b5d82bd916cc0c55a2abf65bdc69023b843]

Lars-Peter Clausen (1):
      ASoC: dma-sh7760: Fix compile error
         [417a1178f1bf3cdc606376b3ded3a22489fbb3eb]

Marc Kleine-Budde (1):
      can: sja1000: fix define conflict on SH
         [f901b6bc404b67d96eca739857c097e022727b71]

Mark Rutland (1):
      clockevents: Don't allow dummy broadcast timers
         [a7dc19b8652c862d5b7c4d2339bd3c428bd29c4a]

Masatake YAMATO (1):
      thermal: shorten too long mcast group name
         [73214f5d9f33b79918b1f7babddd5c8af28dd23d,
          f1e79e208076ffe7bad97158275f1c572c04f5c7]

Max.Nekludov@us.elster.com (1):
      ks8851: Fix interpretation of rxlen field.
         [14bc435ea54cb888409efb54fc6b76c13ef530e9]

Mike Marciniszyn (1):
      IPoIB: Fix send lockup due to missed TX completion
         [1ee9e2aa7b31427303466776f455d43e5e3c9275]

Ming Lei (4):
      Bluetooth: Add support for Dell[QCA 0cf3:0036]
         [d66629c1325399cf080ba8b2fb086c10e5439cdd]
      Bluetooth: Add support for Dell[QCA 0cf3:817a]
         [ebaf5795ef57a70a042ea259448a465024e2821d]
      sysfs: fix race between readdir and lseek
         [991f76f837bf22c5bb07261cfd86525a0a96650c]
      sysfs: handle failure path correctly for readdir()
         [e5110f411d2ee35bf8d202ccca2e89c633060dca]

Mirko Lindner (2):
      sky2: Receive Overflows not counted
         [9cfe8b156c21cf340b3a10ecb3022fbbc1c39185]
      sky2: Threshold for Pause Packet is set wrong
         [74f9f42c1c1650e74fb464f76644c9041f996851]

Mugunthan V N (1):
      drivers: net: ethernet: davinci_emac: use  netif_wake_queue() while restarting tx queue
         [7e51cde276ca820d526c6c21cf8147df595a36bf]

Nikolay@Redhat.Com (2):
      bonding: fix disabling of arp_interval and miimon
         [1bc7db16782c2a581fb4d53ca853631050f31611]
      bonding: fix miimon and arp_interval delayed work race  conditions
         [fbb0c41b814d497c656fc7be9e35456f139cb2fb]

Paul Moore (1):
      unix: fix a race condition in unix_release()
         [ded34e0fe8fe8c2d595bfa30626654e4b87621e0]

Pawel Wieczorkiewicz (1):
      tty: atmel_serial_probe(): index of atmel_ports[] fix
         [503bded92da283b2f31d87e054c4c6d30c3c2340]

Sascha Hauer (1):
      ASoC: imx-ssi: Fix occasional AC97 reset failure
         [b6e51600f4e983e757b1b6942becaa1ae7d82e67]

Sergio Cambra (1):
      Bluetooth device 04ca:3008 should use ath3k
         [f4d6f7dce71a5da93da50272ff1670bf2f1146b1]

Steve Glendinning (1):
      smsc75xx: fix jumbo frame support
         [4c51e53689569398d656e631c17308d9b8e84650]

Sunguk Lee (1):
      Bluetooth: Device 0cf3:3008 should map AR 3012
         [94a32d10f47b637ae24b78b1ddc7ef0e8396fda4]

Trond Myklebust (2):
      NFSv4.1: Fix a race in pNFS layoutcommit
         [a073dbff359f4741013ae4b8395f5364c5e00b48]
      SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queue_locked
         [1166fde6a923c30f4351515b6a9a1efc513e7d00]

Veaceslav Falico (3):
      bonding: get netdev_rx_handler_unregister out of locks
         [fcd99434fb5c137274d2e15dd2a6a7455f0f29ff]
      bonding: remove already created master sysfs link on  failure
         [9fe16b78ee17579cb4f333534cf7043e94c67024]
      pch_gbe: fix ip_summed checksum reporting on rx
         [76a0e68129d7d24eb995a6871ab47081bbfa0acc]

Vivek Gautam (1):
      usb: xhci: Fix TRB transfer length macro used for Event TRB.
         [1c11a172cb30492f5f6a82c6e118fdcd9946c34f]

Yinghai Lu (1):
      EISA/PCI: Init EISA early, before PNP
         [c5fb301ae83bec6892e54984e6ec765c47df8e10]

Yuchung Cheng (1):
      tcp: undo spurious timeout after SACK reneging
         [7ebe183c6d444ef5587d803b64a1f4734b18c564]

 Makefile                                           |    4 +-
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
 drivers/net/ethernet/davicom/dm9000.c              |  214 ++++++++++----------
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
 71 files changed, 586 insertions(+), 444 deletions(-)

-- 
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

