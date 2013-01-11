Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3AKSOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:14:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:56851 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678Ab3AKSOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:14:37 -0500
Date: Fri, 11 Jan 2013 10:14:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.58
Message-ID: <20130111181433.GA19687@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.58 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/networking/ip-sysctl.txt |    5 +
 Makefile                               |    2=20
 arch/arm/kernel/swp_emulate.c          |    2=20
 arch/arm/mm/mmu.c                      |    2=20
 arch/cris/include/asm/io.h             |   39 +++++++++++--
 arch/sparc/include/asm/hugetlb.h       |   10 ++-
 arch/x86/kernel/cpu/amd.c              |   14 ++++
 drivers/acpi/scan.c                    |    2=20
 drivers/atm/solos-pci.c                |    5 +
 drivers/bluetooth/ath3k.c              |    1=20
 drivers/bluetooth/btusb.c              |    1=20
 drivers/input/joystick/walkera0701.c   |    7 +-
 drivers/input/serio/i8042-x86ia64io.h  |    9 +++
 drivers/net/bonding/bond_main.c        |    7 ++
 drivers/net/bonding/bond_sysfs.c       |    2=20
 drivers/net/can/dev.c                  |    3 -
 drivers/net/irda/sir_dev.c             |    2=20
 drivers/net/ne.c                       |    1=20
 drivers/net/usb/ipheth.c               |    5 +
 drivers/net/wireless/p54/p54usb.c      |    4 +
 drivers/pci/quirks.c                   |    7 +-
 drivers/pnp/pnpacpi/core.c             |    2=20
 drivers/rtc/rtc-vt8500.c               |   11 ++-
 drivers/usb/gadget/f_phonet.c          |    8 ++
 drivers/usb/host/ehci-pci.c            |    3 -
 drivers/usb/host/pci-quirks.c          |    4 +
 drivers/virtio/virtio_ring.c           |    7 ++
 fs/binfmt_misc.c                       |    5 +
 fs/binfmt_script.c                     |    4 +
 fs/exec.c                              |   15 +++++
 fs/nfs/client.c                        |    3 -
 fs/nfs/dir.c                           |   11 ++-
 fs/nfs/super.c                         |    2=20
 fs/nfsd/nfs4xdr.c                      |   11 +++
 include/asm-generic/tlb.h              |    9 +++
 include/linux/binfmts.h                |    1=20
 include/linux/compiler-gcc.h           |    5 +
 include/linux/page-flags.h             |    8 ++
 include/linux/pci_ids.h                |    1=20
 include/linux/snmp.h                   |    3 -
 include/net/tcp.h                      |    1=20
 kernel/cgroup.c                        |    2=20
 kernel/irq/manage.c                    |   23 +++++++-
 mm/memory.c                            |    5 +
 mm/mempolicy.c                         |   64 +++++++++-------------
 net/bluetooth/hci_core.c               |    2=20
 net/ipv4/proc.c                        |    3 -
 net/ipv4/sysctl_net_ipv4.c             |    7 ++
 net/ipv4/tcp_input.c                   |   93 ++++++++++++++++++++++++----=
-----
 net/sched/sch_htb.c                    |    2=20
 net/sctp/chunk.c                       |   20 ++++---
 net/sctp/socket.c                      |    4 -
 sound/usb/midi.c                       |   91 ++++++++++++++++++++--------=
----
 53 files changed, 406 insertions(+), 154 deletions(-)

Al Viro (1):
      ARM: missing ->mmap_sem around find_vma() in swp_emulate.c

Alan Cox (2):
      ne2000: add the right platform device
      pnpacpi: fix incorrect TEST_ALPHA() test

Alexander Shiyan (1):
      irda: sir_dev: Fix copy/paste typo

Alexander Stein (1):
      can: Do not call dev_put if restart timer is running upon close

Andre Przywara (1):
      x86, amd: Disable way access filter on Piledriver CPUs

Andy Lutomirski (1):
      PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz

Christian Lamparter (1):
      p54usb: add USBIDs for two more p54usb devices

Christoffer Dall (1):
      mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED

Corey Minyard (1):
      CRIS: fix I/O macros

Dave Kleikamp (1):
      sparc: huge_ptep_set_* functions need to call set_huge_pte_at()

David Woodhouse (1):
      solos-pci: fix double-free of TX skb in DMA mode

Eric Dumazet (5):
      tcp: implement RFC 5961 3.2
      tcp: implement RFC 5961 4.2
      tcp: refine SYN handling in tcp_validate_incoming
      tcp: tcp_replace_ts_recent() should not be called from tcp_validate_i=
ncoming()
      tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation

Greg Kroah-Hartman (1):
      Linux 3.0.58

Gustavo Padovan (1):
      Bluetooth: cancel power_on work when unregistering the device

Hugh Dickins (1):
      tmpfs mempolicy: fix /proc/mounts corrupting memory

J. Bruce Fields (1):
      nfsd4: fix oops on unusual readlike compound

Jay Purohit (1):
      usb/ipheth: Add iPhone 5 support

Kees Cook (1):
      exec: do not leave bprm->interp on stack

Marcos Chaparro (1):
      Bluetooth: ath3k: Add support for VAIO VPCEH [0489:e027]

Michal Hocko (1):
      mm: limit mmu_gather batching to fix soft lockups on !CONFIG_PREEMPT

NeilBrown (1):
      NFS: avoid NULL dereference in nfs_destroy_server

Ondrej Zary (1):
      x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops

Peter Popovec (1):
      Input: walkera0701 - fix crash on startup

Rafael J. Wysocki (1):
      ACPI / scan: Do not use dummy HID for system bus ACPI nodes

Russell Webb (1):
      xhci: Add Lynx Point LP to list of Intel switchable hosts

Sarveshwar Bandi (1):
      bonding: Bonding driver does not consider the gso_max_size/gso_max_se=
gs setting of slave devices.

Sebastian Andrzej Siewior (1):
      usb: gadget: phonet: free requests in pn_bind()'s error path

Stefan Hasko (1):
      net: sched: integer overflow fix

Steven Rostedt (1):
      ftrace: Do not function trace inlined functions

Takashi Iwai (2):
      ALSA: usb-audio: Avoid autopm calls after disconnection
      ALSA: usb-audio: Fix missing autopm for MIDI input

Tejun Heo (1):
      cgroup: remove incorrect dget/dput() pair in cgroup_create_dir()

Thomas Gleixner (1):
      genirq: Always force thread affinity

Tomasz Guszkowski (1):
      p54usb: add USB ID for T-Com Sinus 154 data II

Tommi Rantala (2):
      sctp: fix memory leak in sctp_datamsg_from_user() when copy from user=
 space fails
      sctp: fix -ENOMEM result with invalid user space pointer in sendto() =
syscall

Tony Prisk (2):
      drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield
      drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct rtc_t=
ime

Trond Myklebust (1):
      NFS: Fix calls to drop_nlink()

Will Deacon (2):
      virtio: force vring descriptors to be allocated from lowmem
      ARM: mm: use pteval_t to represent page protection values

Xi Wang (1):
      nfs: fix null checking in nfs_get_option_str()

nikolay@redhat.com (1):
      bonding: fix race condition in bonding_store_slaves_active


--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ8FaJAAoJEDjbvchgkmk+f/cQAKYIiicRvzCyO9IQnoLr21xq
0lEjXniS4O90yAhFzMTKm4sfsfrghmCywBgxWRr0tAdZOFSI2g0jMJPzPq9GB9bN
XIVWlBg+qCuJ4kCv1hthZr42Rj1VOVorcvbc0ArQiRLVxxe0sHuUJ2fzBgZqgiRk
jw8+U+t6+6NZ5CzFtu0U0AXzzybuy4ZH2qNLRmgjUaSSlVUwgMDdYiwpNdNZ267M
rmwpcVEq8ncH4r3e2fhdYxDhDJgKaPmSgpaXCuQWF+qE0CHYsL2+TKolGpyqHKAO
5mXBcrSGkwf19AzDH5/KS3gdHGQC/bhg+GELv4CKzFzoG9ZGQ/azBE29ptenccPG
Wwv3OvDwU7p09WZshIsrVjzoKmSR357nutWkAc5raPSbk38mkSouaWGF558GqML5
yVrvP8E4xiHVSZoOyl0Lm1+Gf92Ga7BJ5MxfLk6UAWaJ2IRAyQ7RFaNTRCiJ5MFP
OxnTW56WKFHXtQjVOK8o07BLGOIjZbdnSBoIM7APnJq/7zwGva0nUFLPlO+tfnNk
om6pqlI4M6LKQI9I7ts3D6UdunjM7nBjw5++3fEBQB2to1liILO0J9SC9oYCN1ve
/ey9VxrqlH7bitBdkBw+sqp3rfKZzMd/YCLnpxXAR+bFIQdBYEywpCJ/Ka9FJ1W6
k+fl6K2GfCeMY4CarSn7
=evl7
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
