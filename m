Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162347Ab3DERlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:41:21 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34572 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162228Ab3DERlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:41:16 -0400
Date: Fri, 5 Apr 2013 10:41:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.72
Message-ID: <20130405174114.GA971@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.72 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                              |    2=20
 arch/arm/include/asm/signal.h         |    1=20
 arch/avr32/include/asm/signal.h       |    1=20
 arch/cris/include/asm/signal.h        |    1=20
 arch/h8300/include/asm/signal.h       |    1=20
 arch/ia64/kvm/kvm-ia64.c              |    5 +
 arch/m32r/include/asm/signal.h        |    1=20
 arch/m68k/include/asm/signal.h        |    1=20
 arch/mn10300/include/asm/signal.h     |    1=20
 arch/powerpc/include/asm/signal.h     |    1=20
 arch/s390/include/asm/signal.h        |    1=20
 arch/sparc/include/asm/signal.h       |    1=20
 arch/x86/include/asm/signal.h         |    2=20
 arch/x86/kernel/amd_iommu.c           |   24 ++++----
 arch/x86/kvm/i8254.c                  |   10 ++-
 arch/x86/kvm/x86.c                    |   19 ++++--
 arch/xtensa/include/asm/signal.h      |    1=20
 drivers/block/aoe/aoecmd.c            |    3 -
 drivers/block/loop.c                  |    9 ++-
 drivers/block/xen-blkback/blkback.c   |    7 --
 drivers/bluetooth/ath3k.c             |    4 +
 drivers/bluetooth/btusb.c             |    2=20
 drivers/firmware/efivars.c            |   92 +++++++++++++++++++++++++++++=
+-
 drivers/gpu/drm/i915/intel_display.c  |   23 +++----
 drivers/net/atl1e/atl1e.h             |    1=20
 drivers/net/atl1e/atl1e_main.c        |   22 -------
 drivers/net/bonding/bond_main.c       |    3 -
 drivers/net/davinci_emac.c            |    2=20
 drivers/net/ks8851.c                  |    2=20
 drivers/net/macvtap.c                 |    4 +
 drivers/net/pch_gbe/pch_gbe_main.c    |    4 -
 drivers/net/sky2.c                    |    2=20
 drivers/net/sky2.h                    |    2=20
 drivers/net/usb/smsc75xx.c            |   12 ++--
 drivers/net/wireless/b43/dma.c        |   65 ++++++++++++++++++----
 drivers/net/wireless/mwifiex/init.c   |    8 ++
 drivers/staging/comedi/drivers/s626.c |    2=20
 drivers/tty/vt/vc_screen.c            |    6 +-
 drivers/usb/host/xhci-ring.c          |   24 ++++----
 drivers/usb/host/xhci.h               |    4 +
 drivers/usb/serial/ftdi_sio.c         |    1=20
 drivers/usb/serial/ftdi_sio_ids.h     |    7 ++
 fs/block_dev.c                        |    1=20
 fs/btrfs/extent-tree.c                |    2=20
 fs/ext4/ext4.h                        |    6 +-
 fs/ext4/ialloc.c                      |   18 +++---
 fs/ext4/mballoc.c                     |   10 +--
 fs/ext4/resize.c                      |    4 -
 fs/ext4/super.c                       |    4 -
 fs/nfs/nfs4proc.c                     |   99 ++++++++++++++++++++---------=
-----
 fs/nfs/nfs4xdr.c                      |   34 ++++++++---
 fs/nfsd/nfs4xdr.c                     |    2=20
 fs/sysfs/dir.c                        |   17 +++++
 include/asm-generic/signal.h          |    4 +
 include/linux/kvm_host.h              |    7 ++
 include/linux/nfs_xdr.h               |    5 +
 include/linux/sunrpc/xdr.h            |    2=20
 include/linux/thermal.h               |    2=20
 kernel/signal.c                       |    2=20
 kernel/trace/trace.c                  |   50 +++++++++++++----
 kernel/trace/trace.h                  |    7 ++
 kernel/trace/trace_irqsoff.c          |   19 ++++--
 kernel/trace/trace_sched_wakeup.c     |   18 ++++--
 mm/memory_hotplug.c                   |   15 ++---
 net/8021q/vlan.c                      |   14 ++--
 net/batman-adv/icmp_socket.c          |    5 -
 net/bluetooth/sco.c                   |    1=20
 net/core/dev.c                        |    6 ++
 net/ipv4/tcp_input.c                  |    7 --
 net/ipv4/tcp_output.c                 |    7 +-
 net/ipv6/addrconf.c                   |   26 +++-----
 net/irda/af_irda.c                    |    6 +-
 net/netlink/genetlink.c               |    1=20
 net/sunrpc/sched.c                    |    9 ++-
 net/sunrpc/xdr.c                      |    3 -
 net/unix/af_unix.c                    |    7 +-
 net/x25/af_x25.c                      |   37 ++++++++++--
 net/x25/x25_dev.c                     |    6 ++
 net/x25/x25_facilities.c              |   10 ++-
 net/x25/x25_in.c                      |   43 +++++++++++++-
 net/x25/x25_link.c                    |    3 +
 net/x25/x25_subr.c                    |   14 ++++
 virt/kvm/irq_comm.c                   |    1=20
 virt/kvm/kvm_main.c                   |   15 +++--
 84 files changed, 665 insertions(+), 268 deletions(-)

Al Viro (1):
      vt: synchronize_rcu() under spinlock is not nice...

Anatol Pomozov (1):
      loop: prevent bdev freeing while device in use

Andrew Morton (1):
      kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER

Andy Adamson (1):
      NFSv4: include bitmap in nfsv4 get acl data

Avi Kivity (2):
      KVM: Ensure all vcpus are consistent with in-kernel irqchip settings
      KVM: Fix buffer overflow in kvm_set_irq()

Ben Hutchings (1):
      signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_=
restorer

Bing Zhao (1):
      mwifiex: cancel cmd timer and free curr_cmd in shutdown process

Chuck Lever (1):
      NFS: nfs_getaclargs.acl_len is a size_t

Cong Wang (1):
      8021q: fix a potential use-after-free

Eric Dumazet (3):
      tcp: preserve ACK clocking in TSO
      aoe: reserve enough headroom on skbs
      net: add a synchronize_net() in netdev_rx_handler_unregister()

Greg Kroah-Hartman (1):
      Linux 3.0.72

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

Jan Kiszka (2):
      KVM: Clean up error handling during VCPU creation
      KVM: x86: Prevent starting PIT timers in the absence of irqchip suppo=
rt

Jason Wang (1):
      macvtap: zerocopy: validate vectors before building skb

Jesse Barnes (1):
      drm/i915: don't set unpin_work if vblank_get fails

Jiang Liu (1):
      mm/hotplug: correctly add new zone to all other nodes' zone lists

Joerg Roedel (1):
      iommu/amd: Make sure dma_ops are set for hotplug devices

Josef Bacik (1):
      Btrfs: limit the global reserve to 512mb

Kees Cook (1):
      net/irda: add missing error path release_sock call

Konstantin Holoborodko (1):
      usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD

Masatake YAMATO (1):
      thermal: shorten too long mcast group name

Matt Fleming (2):
      efivars: explicitly calculate length of VariableName
      efivars: Handle duplicate names from get_next_variable()

Matthew Daley (2):
      x25: Validate incoming call user data lengths
      x25: Handle undersized/fragmented skbs

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
      atl1e: drop pci-msi support because of packet corruption

Paul Kot (1):
      batman-adv: bat_socket_read missing checks

Paul Moore (1):
      unix: fix a race condition in unix_release()

Petr Matousek (1):
      KVM: x86: invalid opcode oops on SET_SREGS with OSXSAVE bit set (CVE-=
2012-4461)

Steve Glendinning (1):
      smsc75xx: fix jumbo frame support

Steven Rostedt (Red Hat) (2):
      tracing: Protect tracer flags with trace_types_lock
      tracing: Prevent buffer overwrite disabled for latency tracers

Sven Eckelmann (1):
      batman-adv: Only write requested number of byte to user buffer

Theodore Ts'o (1):
      ext4: use atomic64_t for the per-flexbg free_clusters count

Trond Myklebust (2):
      SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queu=
e_locked
      NFSv4: Fix an Oops in the NFSv4 getacl code

Veaceslav Falico (2):
      pch_gbe: fix ip_summed checksum reporting on rx
      bonding: get netdev_rx_handler_unregister out of locks

Ville Syrj=E4l=E4 (1):
      drm/i915: Don't clobber crtc->fb when queue_flip fails

Vinicius Costa Gomes (1):
      Bluetooth: Fix not closing SCO sockets in the BT_CONNECT2 state

Vivek Gautam (1):
      usb: xhci: Fix TRB transfer length macro used for Event TRB.

Yuchung Cheng (1):
      tcp: undo spurious timeout after SACK reneging


--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRXwy6AAoJEDjbvchgkmk+358QALuJEYXckiZn+ix290KLc2Ui
XN/gc1mBlqhLWZixZcYvG7jfl2MLVJSR3snHmJX62QDRqfbZ6K+JkrAG8tEI7LRl
5QQTLo9ojN8VXu3UFZqlCJiltl5YKEV5bEOmQMB/HrKB+J287lU/AmFpsbqK0Hno
y8FtkWpgDJqBte+bpmRSAgENKtE5C6zbV6fZVMVWNi3UK2RjNwigQ1jmgew1SH0x
cHkPTSI4Sa8YuMoq2dYQGCS0p/u+CoL+bTmBlHj3YnNk1AvDmHZofhlocqUkytRs
NsoF4EL89tL+g2i1PDJU+dY4IfliiUhY8YqUcyKo9HEXZegxDx9j+8dfaJUIf803
iDBrU9CShMWZ60niPla8cre6rwLN9whQQmmHG/AikbTsDpL3iyP8MBKK0thyAgvt
+kUxgg9hmNX/i4L0VUnoYHFZVE9Xg1Nl/v6nBZVsfRVuygDvfLxVZkVLVjALZFHu
gb0W8ZW/ixmq5zwKXept34av+qNQfC6zjY1I4cmKqf8DPelN97GDWLUq5mKUJsCj
DNGfm4n9a1TIzzLOywuXreCdebrRPxkXFc5TxmC3189+Xm6sn/9Yvlj78WNEX9yJ
3kQdrWsdJV3O08+dKHaHsM4bleZMuK/u2GahgOwrPSR7MBV0GC1/lJv5/MRAS77Z
Evb1xbELHMFajX838rX7
=eBPC
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
