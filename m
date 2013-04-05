Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162251Ab3DERkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:40:19 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:39089 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162223Ab3DERkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:40:15 -0400
Date: Fri, 5 Apr 2013 10:40:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.6
Message-ID: <20130405174012.GA28836@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.8.6 kernel.

All users of the 3.8 kernel series must upgrade.

The updated 3.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.8.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                             |    2=20
 arch/arm/boot/dts/kirkwood-goflexnet.dts             |    1=20
 arch/arm/include/asm/signal.h                        |    1=20
 arch/arm/mach-cns3xxx/core.c                         |   16 -
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h         |   16 -
 arch/arm/mach-imx/common.h                           |    2=20
 arch/arm/mach-imx/hotplug.c                          |   12 +
 arch/arm/mach-imx/src.c                              |   12 +
 arch/arm/mach-omap2/common.h                         |    3=20
 arch/arm/mach-omap2/io.c                             |   18 +
 arch/arm/mach-omap2/timer.c                          |    4=20
 arch/avr32/include/asm/signal.h                      |    1=20
 arch/cris/include/asm/signal.h                       |    1=20
 arch/h8300/include/asm/signal.h                      |    1=20
 arch/m32r/include/asm/signal.h                       |    1=20
 arch/m68k/include/asm/signal.h                       |    1=20
 arch/mn10300/include/asm/signal.h                    |    1=20
 arch/powerpc/include/asm/signal.h                    |    1=20
 arch/s390/include/asm/signal.h                       |    1=20
 arch/sparc/include/asm/signal.h                      |    2=20
 arch/tile/kernel/setup.c                             |   25 +-
 arch/x86/include/asm/signal.h                        |    3=20
 arch/x86/include/asm/xen/hypercall.h                 |    4=20
 arch/xtensa/include/asm/signal.h                     |    1=20
 drivers/block/aoe/aoecmd.c                           |    3=20
 drivers/block/loop.c                                 |    9=20
 drivers/block/xen-blkback/blkback.c                  |   38 ++-
 drivers/block/xen-blkback/common.h                   |   25 ++
 drivers/block/xen-blkfront.c                         |   41 +--
 drivers/bluetooth/ath3k.c                            |    4=20
 drivers/bluetooth/btusb.c                            |    2=20
 drivers/char/virtio_console.c                        |   22 +
 drivers/crypto/caam/caamalg.c                        |   27 --
 drivers/crypto/caam/compat.h                         |    1=20
 drivers/crypto/talitos.c                             |   30 --
 drivers/firmware/efivars.c                           |   87 +++++++
 drivers/gpu/drm/i915/intel_display.c                 |   11=20
 drivers/gpu/drm/i915/intel_dp.c                      |   12 -
 drivers/hid/hid-ids.h                                |    6=20
 drivers/hid/usbhid/hid-quirks.c                      |    2=20
 drivers/iommu/amd_iommu.c                            |   22 -
 drivers/media/pci/bt8xx/bttv-driver.c                |   20 +
 drivers/net/bonding/bond_main.c                      |    3=20
 drivers/net/bonding/bond_sysfs.c                     |   97 ++++----
 drivers/net/can/sja1000/plx_pci.c                    |    4=20
 drivers/net/can/sja1000/sja1000.c                    |    6=20
 drivers/net/can/sja1000/sja1000.h                    |    2=20
 drivers/net/ethernet/atheros/atl1e/atl1e.h           |    1=20
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c      |   19 -
 drivers/net/ethernet/broadcom/tg3.c                  |    7=20
 drivers/net/ethernet/davicom/dm9000.c                |  214 +++++++++-----=
-----
 drivers/net/ethernet/davicom/dm9000.h                |   11=20
 drivers/net/ethernet/freescale/fec_ptp.c             |    3=20
 drivers/net/ethernet/marvell/sky2.c                  |    2=20
 drivers/net/ethernet/marvell/sky2.h                  |    2=20
 drivers/net/ethernet/micrel/ks8851.c                 |    2=20
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c |    4=20
 drivers/net/ethernet/ti/cpsw.c                       |    4=20
 drivers/net/ethernet/ti/davinci_emac.c               |    2=20
 drivers/net/usb/smsc75xx.c                           |   12 -
 drivers/net/wireless/ath/ath9k/ar9003_calib.c        |    4=20
 drivers/net/wireless/ath/ath9k/link.c                |   29 +-
 drivers/net/wireless/b43/dma.c                       |   65 ++++-
 drivers/net/wireless/b43/phy_n.c                     |    8=20
 drivers/net/wireless/iwlwifi/dvm/lib.c               |    9=20
 drivers/net/wireless/iwlwifi/dvm/ucode.c             |    4=20
 drivers/net/wireless/iwlwifi/pcie/tx.c               |    2=20
 drivers/net/wireless/mwifiex/cmdevt.c                |   22 +
 drivers/net/wireless/mwifiex/init.c                  |    8=20
 drivers/net/wireless/mwifiex/main.h                  |    4=20
 drivers/net/wireless/mwifiex/scan.c                  |    8=20
 drivers/net/wireless/mwifiex/sta_ioctl.c             |   10=20
 drivers/net/wireless/rtlwifi/usb.c                   |    1=20
 drivers/regulator/core.c                             |    4=20
 drivers/staging/comedi/drivers/s626.c                |    2=20
 drivers/target/target_core_transport.c               |    4=20
 drivers/tty/serial/atmel_serial.c                    |   11=20
 drivers/tty/vt/vc_screen.c                           |    6=20
 drivers/usb/gadget/udc-core.c                        |    2=20
 drivers/usb/host/ehci-sched.c                        |    2=20
 drivers/usb/host/xhci-ring.c                         |   24 +-
 drivers/usb/host/xhci.h                              |    4=20
 drivers/usb/serial/ark3116.c                         |   10=20
 drivers/usb/serial/ch341.c                           |   11=20
 drivers/usb/serial/cypress_m8.c                      |   14 -
 drivers/usb/serial/f81232.c                          |    9=20
 drivers/usb/serial/ftdi_sio.c                        |   20 -
 drivers/usb/serial/ftdi_sio_ids.h                    |    7=20
 drivers/usb/serial/io_edgeport.c                     |   12 -
 drivers/usb/serial/io_ti.c                           |   12 -
 drivers/usb/serial/mct_u232.c                        |   13 -
 drivers/usb/serial/mos7840.c                         |   16 -
 drivers/usb/serial/oti6858.c                         |   10=20
 drivers/usb/serial/pl2303.c                          |   11=20
 drivers/usb/serial/quatech2.c                        |   12 -
 drivers/usb/serial/spcp8x5.c                         |    9=20
 drivers/usb/serial/ssu100.c                          |   12 -
 drivers/usb/serial/ti_usb_3410_5052.c                |   10=20
 drivers/usb/serial/usb-serial.c                      |    1=20
 drivers/xen/events.c                                 |   20 +
 drivers/xen/fallback.c                               |    3=20
 drivers/xen/xen-pciback/pci_stub.c                   |   59 +++--
 fs/block_dev.c                                       |    1=20
 fs/btrfs/ctree.c                                     |   30 +-
 fs/btrfs/extent-tree.c                               |   49 +++-
 fs/btrfs/extent_io.c                                 |   33 ++
 fs/btrfs/extent_io.h                                 |    2=20
 fs/btrfs/inode.c                                     |   14 +
 fs/btrfs/scrub.c                                     |    3=20
 fs/btrfs/tree-log.c                                  |    5=20
 fs/dcache.c                                          |   16 -
 fs/namespace.c                                       |   54 ++++
 fs/nfs/blocklayout/blocklayoutdm.c                   |    4=20
 fs/nfs/idmap.c                                       |   13 -
 fs/nfs/nfs4filelayout.c                              |    1=20
 fs/nfs/nfs4proc.c                                    |   14 -
 fs/nfs/pnfs.c                                        |   54 +++-
 fs/nfsd/nfs4xdr.c                                    |    2=20
 fs/pnode.c                                           |    6=20
 fs/pnode.h                                           |    1=20
 fs/proc/root.c                                       |    4=20
 fs/sysfs/dir.c                                       |   17 +
 fs/sysfs/mount.c                                     |    4=20
 include/linux/fs_struct.h                            |    2=20
 include/linux/mount.h                                |    2=20
 include/linux/thermal.h                              |    2=20
 include/linux/usb/serial.h                           |    2=20
 include/linux/user_namespace.h                       |    4=20
 include/uapi/asm-generic/signal.h                    |    4=20
 include/uapi/linux/packet_diag.h                     |    4=20
 include/uapi/linux/unix_diag.h                       |    4=20
 include/xen/interface/io/blkif.h                     |   10=20
 include/xen/interface/physdev.h                      |    6=20
 ipc/mqueue.c                                         |   12 -
 kernel/pid_namespace.c                               |    3=20
 kernel/signal.c                                      |    2=20
 kernel/trace/trace.c                                 |   38 ++-
 kernel/trace/trace.h                                 |    6=20
 kernel/trace/trace_irqsoff.c                         |   19 +
 kernel/trace/trace_sched_wakeup.c                    |   18 +
 kernel/user.c                                        |    2=20
 kernel/user_namespace.c                              |   11=20
 net/8021q/vlan.c                                     |   14 -
 net/bluetooth/sco.c                                  |    1=20
 net/core/dev.c                                       |    7=20
 net/core/flow.c                                      |    2=20
 net/core/scm.c                                       |    4=20
 net/ipv4/tcp_input.c                                 |    7=20
 net/ipv4/tcp_output.c                                |    7=20
 net/ipv6/addrconf.c                                  |   26 --
 net/ipv6/ip6_input.c                                 |   21 +
 net/irda/af_irda.c                                   |    6=20
 net/mac80211/mlme.c                                  |    4=20
 net/mac80211/sta_info.c                              |   12 -
 net/netlink/genetlink.c                              |    1=20
 net/sched/sch_fq_codel.c                             |    2=20
 net/sunrpc/sched.c                                   |    9=20
 net/unix/af_unix.c                                   |    7=20
 158 files changed, 1341 insertions(+), 658 deletions(-)

Al Viro (2):
      vt: synchronize_rcu() under spinlock is not nice...
      Nest rename_lock inside vfsmount_lock

Alan Stern (1):
      usb: gadget: udc-core: fix a regression during gadget driver unbinding

Amit Shah (2):
      virtio: console: rename cvq_lock to c_ivq_lock
      virtio: console: add locking around c_ovq operations

Amitkumar Karwar (1):
      mwifiex: fix race when queuing commands

Anatol Pomozov (1):
      loop: prevent bdev freeing while device in use

Andrew Morton (1):
      kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER

Andrey Vagin (1):
      net: fix *_DIAG_MAX constants

Ben Hutchings (1):
      signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_=
restorer

Bing Zhao (2):
      mwifiex: skip pending commands after function shutdown
      mwifiex: cancel cmd timer and free curr_cmd in shutdown process

Chris Mason (1):
      Btrfs: fix race between mmap writes and compression

Chris Metcalf (1):
      tile: expect new initramfs name from hypervisor file system

Cong Wang (1):
      8021q: fix a potential use-after-free

David Vrabel (2):
      xen/blkback: correctly respond to unknown, non-native requests
      xen/events: avoid race with raising an event in unmask_evtchn()

Emmanuel Grumbach (2):
      iwlwifi: fix length check in multi-TB HCMD
      iwlwifi: dvm: don't send HCMD in restart flow

Eric Dumazet (4):
      net: remove a WARN_ON() in net_enable_timestamp()
      tcp: preserve ACK clocking in TSO
      aoe: reserve enough headroom on skbs
      net: add a synchronize_net() in netdev_rx_handler_unregister()

Eric Hutter (1):
      ARM: kirkwood: Fix chip-delay for GoFlex Net

Eric W. Biederman (7):
      scm: Require CAP_SYS_ADMIN over the current pidns to spoof pids.
      pid: Handle the exit of a multi-threaded init.
      userns: Don't allow creation if the user is chrooted
      vfs: Add a mount flag to lock read only bind mounts
      vfs: Carefully propogate mounts across user namespaces
      ipc: Restrict mounting the mqueue filesystem
      userns: Restrict when proc and sysfs can be mounted

Fabio Estevam (1):
      fec: Fix the build as module

Felix Fietkau (2):
      ath9k_hw: revert chainmask to user configuration after calibration
      ath9k: limit tx path hang check to normal data queues

Greg Kroah-Hartman (1):
      Linux 3.8.6

Hannes Frederic Sowa (3):
      atl1e: drop pci-msi support because of packet corruption
      ipv6: don't accept multicast traffic with scope 0
      ipv6: don't accept node local multicast traffic from the wire

Hans de Goede (1):
      media: [REGRESSION] bt8xx: Fix too large height in cropcap

Hong Zhiguo (1):
      ipv6: fix bad free of addrconf_init_net

Horia Geanta (2):
      Revert "crypto: talitos - add IPsec ESN support"
      Revert "crypto: caam - add IPsec ESN support"

Ian Abbott (1):
      staging: comedi: s626: fix continuous acquisition

Iestyn C. Elfick (1):
      b43: A fix for DMA transmission sequence errors

J. Bruce Fields (1):
      nfsd4: reject "negative" acl lengths

Jan Beulich (2):
      xen-pciback: notify hypervisor about devices intended to be assigned =
to guests
      xen-blkback: fix dispatch_rw_block_io() error path

Jan Schmidt (1):
      Btrfs: fix locking on ROOT_REPLACE operations in tree mod log

Jiri Kosina (1):
      HID: usbhid: fix build problem

Joerg Roedel (1):
      iommu/amd: Make sure dma_ops are set for hotplug devices

Johan Hovold (17):
      USB: serial: add modem-status-change wait queue
      USB: quatech2: fix use-after-free in TIOCMIWAIT
      USB: mos7840: fix broken TIOCMIWAIT
      USB: io_ti: fix use-after-free in TIOCMIWAIT
      USB: oti6858: fix use-after-free in TIOCMIWAIT
      USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
      USB: pl2303: fix use-after-free in TIOCMIWAIT
      USB: mos7840: fix use-after-free in TIOCMIWAIT
      USB: spcp8x5: fix use-after-free in TIOCMIWAIT
      USB: ssu100: fix use-after-free in TIOCMIWAIT
      USB: ch341: fix use-after-free in TIOCMIWAIT
      USB: io_edgeport: fix use-after-free in TIOCMIWAIT
      USB: f81232: fix use-after-free in TIOCMIWAIT
      USB: ark3116: fix use-after-free in TIOCMIWAIT
      USB: mct_u232: fix use-after-free in TIOCMIWAIT
      USB: cypress_m8: fix use-after-free in TIOCMIWAIT
      USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT

Johannes Berg (2):
      mac80211: always synchronize_net() during station removal
      mac80211: prevent spurious HT/VHT downgrade message

Josef Bacik (4):
      Btrfs: use set_nlink if our i_nlink is 0
      Btrfs: limit the global reserve to 512mb
      Btrfs: don't drop path when printing out tree errors in scrub
      Btrfs: fix space leak when we fail to reserve metadata space

Joseph CHANG (1):
      DM9000B: driver initialization upgrade

Josh Boyer (2):
      HID: usbhid: quirk for Realtek Multi-card reader
      HID: usbhid: quirk for MSI GX680R led panel

Jussi Kivilinna (1):
      rtlwifi: usb: add missing freeing of skbuff

Kees Cook (2):
      tg3: fix length overflow in VPD firmware parsing
      net/irda: add missing error path release_sock call

Konstantin Holoborodko (1):
      usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD

Li RongQing (1):
      net: fix the use of this_cpu_ptr

Lothar Wa=C3=9Fmann (1):
      net: ethernet: cpsw: fix erroneous condition in error check

Luis R. Rodriguez (1):
      ath9k: avoid queueing hw check work when suspended

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

Ming Lei (5):
      Bluetooth: Add support for Dell[QCA 0cf3:0036]
      Bluetooth: Add support for Dell[QCA 0cf3:817a]
      sysfs: fix race between readdir and lseek
      sysfs: handle failure path correctly for readdir()
      USB: serial: fix hang when opening port

Mirko Lindner (2):
      sky2: Receive Overflows not counted
      sky2: Threshold for Pause Packet is set wrong

Mugunthan V N (2):
      drivers: net: ethernet: davinci_emac: use netif_wake_queue() while re=
starting tx queue
      drivers: net: ethernet: cpsw: use netif_wake_queue() while restarting=
 tx queue

Nicholas Bellinger (1):
      target: Fix RESERVATION_CONFLICT status regression for iscsi-target s=
pecial case

Paul Moore (1):
      unix: fix a race condition in unix_release()

Pawel Wieczorkiewicz (1):
      tty: atmel_serial_probe(): index of atmel_ports[] fix

Rafa=C5=82 Mi=C5=82ecki (2):
      b43: N-PHY: increase initial value of "mind" in RSSI calibration
      b43: N-PHY: use more bits for offset in RSSI calibration

Rajendra Nayak (1):
      ARM: OMAP: clocks: Delay clk inits atleast until slab is initialized

Roger Pau Monne (1):
      xen-blkfront: switch from llist to list

Russ Dill (1):
      regulator: Fix memory garbage dev_err printout.

Shawn Guo (1):
      ARM: imx: fix sync issue between imx_cpu_die and imx_cpu_kill

Soeren Moch (1):
      USB: EHCI: fix bug in iTD/siTD DMA pool allocation

Steve Glendinning (1):
      smsc75xx: fix jumbo frame support

Steven Rostedt (Red Hat) (1):
      tracing: Prevent buffer overwrite disabled for latency tracers

Takashi Iwai (1):
      drm/i915: Use the fixed pixel clock for eDP in intel_dp_set_m_n()

Trond Myklebust (4):
      SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queu=
e_locked
      NFSv4: Fix the string length returned by the idmapper
      NFSv4.1: Fix a race in pNFS layoutcommit
      NFSv4.1: Always clear the NFS_INO_LAYOUTCOMMIT in layoutreturn

Veaceslav Falico (3):
      bonding: remove already created master sysfs link on failure
      pch_gbe: fix ip_summed checksum reporting on rx
      bonding: get netdev_rx_handler_unregister out of locks

Vijay Subramanian (1):
      net: fq_codel: Fix off-by-one error

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

nikolay@redhat.com (1):
      bonding: fix disabling of arp_interval and miimon


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRXwx8AAoJEDjbvchgkmk+NRkP/j58755fnFooxvZMgepTJYX2
P3ft71IKeAJ1tXfyIJMcyHlQcFidm82vy8PVYbsTqaY1JnZFvi6EEC6WofGploa0
09qJDCXQXUm8HMY44R+WP0kg8uNfuz1GzFCNLJOxKQDCRRmyTp0DSoJ3TIJ4SM1G
Cmxq9/ArwPZaDHGA4SD48RwKwZ0yFg8A/4vdE7hImOTzpuuAEH/GkxM0tCdW/L99
pxWoIdEvsb2HGO+puVuBrcIj01g21Fv33pDuicAarCKRLPVszXeSXbuZqfL8GTOu
x/TV4q1gt3nDYu/N6+wpnC0SFvjSZbP5jep0VlB1C/fPltN02HiN4kU+ht+HiXAB
CPxbWA3srvIPXPduEM0bG5MPABIcj6soXYFjaJnnUmWOjZRiSGQeG0Qn9bPPzFaV
eRxYg7Mc8k+N7UVeDVn2peGtKCvRIycKdEMBDHNWZ9BznB+j+g6YMF0F4LlHhNZs
HJQd1uFyr7hKckyU8PvG4e1prmMEM2469StPATk4UdyFw9ePafXT90riZLCCybPw
Ik8XmPeBtPLTyTbyQFbF/ch/dY+13NcYgOWmFM1hkv6w0I9LFPccowbFbpdxn+rk
UBIN22fyLiI8B0EDsQB/9O2l9IzIS6CJLnaHHeHosnxG2w5Xfy8D73GKRM7KXoL7
pFalYHEPe+RYtADJaFbz
=yNK6
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
