Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162315Ab3DERku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:40:50 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50536 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162220Ab3DERkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:40:47 -0400
Date: Fri, 5 Apr 2013 10:40:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.39
Message-ID: <20130405174045.GA31513@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.39 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                             |    2=20
 arch/arm/include/asm/signal.h                        |    1=20
 arch/arm/mach-cns3xxx/core.c                         |   16 -
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h         |   16 -
 arch/avr32/include/asm/signal.h                      |    1=20
 arch/cris/include/asm/signal.h                       |    1=20
 arch/h8300/include/asm/signal.h                      |    1=20
 arch/m32r/include/asm/signal.h                       |    1=20
 arch/m68k/include/asm/signal.h                       |    1=20
 arch/mn10300/include/asm/signal.h                    |    1=20
 arch/powerpc/include/asm/signal.h                    |    1=20
 arch/s390/include/asm/signal.h                       |    1=20
 arch/sparc/include/asm/signal.h                      |    1=20
 arch/tile/kernel/setup.c                             |   25 +-
 arch/x86/include/asm/signal.h                        |    2=20
 arch/xtensa/include/asm/signal.h                     |    1=20
 drivers/block/aoe/aoecmd.c                           |    3=20
 drivers/block/loop.c                                 |    9=20
 drivers/block/xen-blkback/blkback.c                  |   39 ++-
 drivers/block/xen-blkback/common.h                   |   25 ++
 drivers/bluetooth/ath3k.c                            |    4=20
 drivers/bluetooth/btusb.c                            |    2=20
 drivers/firmware/efivars.c                           |   93 +++++++-
 drivers/gpu/drm/i915/intel_display.c                 |   11=20
 drivers/hid/hid-ids.h                                |    3=20
 drivers/hid/usbhid/hid-quirks.c                      |    1=20
 drivers/iommu/amd_iommu.c                            |   22 -
 drivers/net/bonding/bond_main.c                      |   91 ++------
 drivers/net/bonding/bond_sysfs.c                     |  121 +++++-----
 drivers/net/can/sja1000/plx_pci.c                    |    4=20
 drivers/net/can/sja1000/sja1000.c                    |    6=20
 drivers/net/can/sja1000/sja1000.h                    |    2=20
 drivers/net/ethernet/atheros/atl1e/atl1e.h           |    1=20
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c      |   22 -
 drivers/net/ethernet/broadcom/tg3.c                  |    7=20
 drivers/net/ethernet/davicom/dm9000.c                |  214 +++++++++-----=
-----
 drivers/net/ethernet/davicom/dm9000.h                |   11=20
 drivers/net/ethernet/marvell/sky2.c                  |    2=20
 drivers/net/ethernet/marvell/sky2.h                  |    2=20
 drivers/net/ethernet/micrel/ks8851.c                 |    2=20
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c |    4=20
 drivers/net/ethernet/ti/cpsw.c                       |    2=20
 drivers/net/ethernet/ti/davinci_emac.c               |    2=20
 drivers/net/usb/smsc75xx.c                           |   12 -
 drivers/net/wireless/ath/ath9k/ar9003_calib.c        |    4=20
 drivers/net/wireless/b43/dma.c                       |   65 ++++-
 drivers/net/wireless/b43/phy_n.c                     |    8=20
 drivers/net/wireless/mwifiex/init.c                  |    8=20
 drivers/net/wireless/rtlwifi/usb.c                   |    1=20
 drivers/staging/comedi/drivers/s626.c                |    2=20
 drivers/tty/serial/atmel_serial.c                    |   11=20
 drivers/tty/vt/vc_screen.c                           |    6=20
 drivers/usb/gadget/udc-core.c                        |    2=20
 drivers/usb/host/xhci-ring.c                         |   24 +-
 drivers/usb/host/xhci.h                              |    4=20
 drivers/usb/serial/ftdi_sio.c                        |    1=20
 drivers/usb/serial/ftdi_sio_ids.h                    |    7=20
 fs/block_dev.c                                       |    1=20
 fs/btrfs/extent-tree.c                               |   49 +++-
 fs/btrfs/extent_io.c                                 |   33 ++
 fs/btrfs/extent_io.h                                 |    2=20
 fs/btrfs/inode.c                                     |   14 +
 fs/btrfs/scrub.c                                     |    3=20
 fs/ext4/balloc.c                                     |    2=20
 fs/ext4/ext4.h                                       |    6=20
 fs/ext4/ialloc.c                                     |    4=20
 fs/ext4/mballoc.c                                    |   18 -
 fs/ext4/resize.c                                     |    8=20
 fs/ext4/super.c                                      |    4=20
 fs/nfs/blocklayout/blocklayoutdm.c                   |    4=20
 fs/nfsd/nfs4xdr.c                                    |    2=20
 fs/sysfs/dir.c                                       |   17 +
 include/asm-generic/signal.h                         |    4=20
 include/linux/thermal.h                              |    2=20
 include/linux/unix_diag.h                            |    4=20
 include/xen/interface/io/blkif.h                     |   10=20
 kernel/signal.c                                      |    2=20
 kernel/trace/trace.c                                 |   50 +++-
 kernel/trace/trace.h                                 |    7=20
 kernel/trace/trace_irqsoff.c                         |   19 +
 kernel/trace/trace_sched_wakeup.c                    |   18 +
 net/8021q/vlan.c                                     |   14 -
 net/bluetooth/sco.c                                  |    1=20
 net/core/dev.c                                       |    7=20
 net/ipv4/tcp_input.c                                 |    7=20
 net/ipv4/tcp_output.c                                |    7=20
 net/ipv6/addrconf.c                                  |   26 --
 net/ipv6/ip6_input.c                                 |   21 +
 net/irda/af_irda.c                                   |    6=20
 net/netlink/genetlink.c                              |    1=20
 net/sunrpc/sched.c                                   |    9=20
 net/unix/af_unix.c                                   |    7=20
 92 files changed, 846 insertions(+), 475 deletions(-)

Al Viro (1):
      vt: synchronize_rcu() under spinlock is not nice...

Alan Stern (1):
      usb: gadget: udc-core: fix a regression during gadget driver unbinding

Anatol Pomozov (1):
      loop: prevent bdev freeing while device in use

Andrew Morton (1):
      kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER

Andrey Vagin (1):
      net: fix *_DIAG_MAX constants

Ben Hutchings (1):
      signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_=
restorer

Bing Zhao (1):
      mwifiex: cancel cmd timer and free curr_cmd in shutdown process

Chris Mason (1):
      Btrfs: fix race between mmap writes and compression

Chris Metcalf (1):
      tile: expect new initramfs name from hypervisor file system

Cong Wang (1):
      8021q: fix a potential use-after-free

David Vrabel (1):
      xen/blkback: correctly respond to unknown, non-native requests

Eric Dumazet (4):
      net: remove a WARN_ON() in net_enable_timestamp()
      tcp: preserve ACK clocking in TSO
      aoe: reserve enough headroom on skbs
      net: add a synchronize_net() in netdev_rx_handler_unregister()

Felix Fietkau (1):
      ath9k_hw: revert chainmask to user configuration after calibration

Greg Kroah-Hartman (2):
      Revert "xen/blkback: Don't trust the handle from the frontend."
      Linux 3.4.39

Hannes Frederic Sowa (3):
      atl1e: drop pci-msi support because of packet corruption
      ipv6: don't accept multicast traffic with scope 0
      ipv6: don't accept node local multicast traffic from the wire

Hong Zhiguo (1):
      ipv6: fix bad free of addrconf_init_net

Ian Abbott (1):
      staging: comedi: s626: fix continuous acquisition

Iestyn C. Elfick (1):
      b43: A fix for DMA transmission sequence errors

J. Bruce Fields (1):
      nfsd4: reject "negative" acl lengths

Jan Beulich (1):
      xen-blkback: fix dispatch_rw_block_io() error path

Joerg Roedel (1):
      iommu/amd: Make sure dma_ops are set for hotplug devices

Josef Bacik (3):
      Btrfs: limit the global reserve to 512mb
      Btrfs: don't drop path when printing out tree errors in scrub
      Btrfs: fix space leak when we fail to reserve metadata space

Joseph CHANG (1):
      DM9000B: driver initialization upgrade

Josh Boyer (1):
      HID: usbhid: quirk for Realtek Multi-card reader

Jussi Kivilinna (1):
      rtlwifi: usb: add missing freeing of skbuff

Kees Cook (2):
      tg3: fix length overflow in VPD firmware parsing
      net/irda: add missing error path release_sock call

Konstantin Holoborodko (1):
      usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD

Lukas Czerner (1):
      ext4: convert number of blocks to clusters properly

Mac Lin (1):
      ARM: cns3xxx: fix mapping of private memory region

Marc Kleine-Budde (1):
      can: sja1000: fix define conflict on SH

Masatake YAMATO (1):
      thermal: shorten too long mcast group name

Matt Fleming (2):
      efivars: explicitly calculate length of VariableName
      efivars: Handle duplicate names from get_next_variable()

Max.Nekludov@us.elster.com (1):
      ks8851: Fix interpretation of rxlen field.

Ming Lei (4):
      Bluetooth: Add support for Dell[QCA 0cf3:0036]
      Bluetooth: Add support for Dell[QCA 0cf3:817a]
      sysfs: fix race between readdir and lseek
      sysfs: handle failure path correctly for readdir()

Mirko Lindner (2):
      sky2: Receive Overflows not counted
      sky2: Threshold for Pause Packet is set wrong

Mugunthan V N (2):
      drivers: net: ethernet: davinci_emac: use netif_wake_queue() while re=
starting tx queue
      drivers: net: ethernet: cpsw: use netif_wake_queue() while restarting=
 tx queue

Paul Moore (1):
      unix: fix a race condition in unix_release()

Pawel Wieczorkiewicz (1):
      tty: atmel_serial_probe(): index of atmel_ports[] fix

Rafa=C5=82 Mi=C5=82ecki (2):
      b43: N-PHY: increase initial value of "mind" in RSSI calibration
      b43: N-PHY: use more bits for offset in RSSI calibration

Steve Glendinning (1):
      smsc75xx: fix jumbo frame support

Steven Rostedt (Red Hat) (2):
      tracing: Protect tracer flags with trace_types_lock
      tracing: Prevent buffer overwrite disabled for latency tracers

Theodore Ts'o (1):
      ext4: use atomic64_t for the per-flexbg free_clusters count

Trond Myklebust (1):
      SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queu=
e_locked

Veaceslav Falico (3):
      bonding: remove already created master sysfs link on failure
      pch_gbe: fix ip_summed checksum reporting on rx
      bonding: get netdev_rx_handler_unregister out of locks

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/i915: Don't clobber crtc->fb when queue_flip fails

Vinicius Costa Gomes (1):
      Bluetooth: Fix not closing SCO sockets in the BT_CONNECT2 state

Vivek Gautam (1):
      usb: xhci: Fix TRB transfer length macro used for Event TRB.

Yuchung Cheng (1):
      tcp: undo spurious timeout after SACK reneging

fanchaoting (1):
      pnfs-block: removing DM device maybe cause oops when call dev_remove

nikolay@redhat.com (2):
      bonding: fix miimon and arp_interval delayed work race conditions
      bonding: fix disabling of arp_interval and miimon


--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRXwydAAoJEDjbvchgkmk+jIcQAILBylc+tLcKeJWee2Q1zf/d
D5DnJNn03FXTy2+ZwA+yGlRDYhO5WtojpUYOZFobztc6FgKnbPaacnN8RazBWjhk
tlWJ4wySXxtEc/HGP7M8oiK6Lb3+L8hlC701I68yu521HmkFbQ9HiZMxSS96zcN5
NPOvTpqlN76fg3CVsZtCXLMHIoQwZfsHLfNd7rRcGz8RTArDaknLm4Xh6LpKxk7y
HImOn9S5I2vlzJ80t+gU43f0Ik4UbK7Tqp7fab0hC4/eb7xEWCz1ehV/FEsmIsuL
Ea+JJ6Dp+3IZjgaPpBlz61wPu1SKBXemLGGp43hPI5LrsFH4t9Q+7m+/8RrHj2Vc
qY4iU0KQTyb3sh6tmTBOiNLWn0YBp+7c1BShHlic0sCFN3povIh/xtx4ZpfXLrNg
f9+a1O/cVUH4DtlQkRfS5q7dsD8/wZbnK4R+khAbQJY2fd1LilCdFC1gYGdOWwB4
fZ1LfxtAVIamqG8ZQgudZh12bjUAqluk7VCWarwX+DlHHhldvciPFkPDHlzADMY6
cu7I8ApUxA+tQShDGAgnQNdrw5vBEpaaAF0ipHwR3WY7Lyl7JX5f6d7sKsbBwwl6
K/1Jfq4m1UO+ee4kNkkRRPMBfsqwh2Guf9PgGDyY4By2fhj1Bzf+KYiNdcY8Hc99
GYLrl2CRsX56syU6T4Ef
=iRGM
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
