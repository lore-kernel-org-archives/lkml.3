Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3AKSOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:14:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:56811 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab3AKSOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:14:02 -0500
Date: Fri, 11 Jan 2013 10:13:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.25
Message-ID: <20130111181357.GA17182@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.25 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/networking/ip-sysctl.txt         |    5=20
 Makefile                                       |    2=20
 arch/arm/kernel/swp_emulate.c                  |    2=20
 arch/arm/mach-realview/include/mach/board-eb.h |    2=20
 arch/arm/mm/mmu.c                              |    2=20
 arch/cris/include/asm/io.h                     |   39 ++
 arch/sparc/include/asm/hugetlb.h               |   10=20
 arch/x86/kernel/cpu/amd.c                      |   14 +
 drivers/acpi/scan.c                            |    2=20
 drivers/acpi/sleep.c                           |  348 ++++++++++++--------=
-----
 drivers/atm/solos-pci.c                        |    5=20
 drivers/bluetooth/ath3k.c                      |    1=20
 drivers/bluetooth/btusb.c                      |    1=20
 drivers/hid/hid-core.c                         |    1=20
 drivers/input/joystick/walkera0701.c           |    7=20
 drivers/input/mouse/sentelic.c                 |    2=20
 drivers/input/serio/i8042-x86ia64io.h          |    9=20
 drivers/misc/sgi-xp/xpc_main.c                 |   34 ++
 drivers/net/bonding/bond_main.c                |    7=20
 drivers/net/bonding/bond_sysfs.c               |    2=20
 drivers/net/can/dev.c                          |    3=20
 drivers/net/ethernet/8390/ne.c                 |    1=20
 drivers/net/irda/sir_dev.c                     |    2=20
 drivers/net/usb/ipheth.c                       |    5=20
 drivers/net/wireless/b43/dma.c                 |    7=20
 drivers/net/wireless/b43/main.c                |   12=20
 drivers/net/wireless/b43/pio.c                 |    4=20
 drivers/net/wireless/b43legacy/b43legacy.h     |    5=20
 drivers/net/wireless/b43legacy/main.c          |   37 ++
 drivers/net/wireless/p54/p54usb.c              |    4=20
 drivers/net/wireless/rtlwifi/usb.c             |    7=20
 drivers/pci/quirks.c                           |    7=20
 drivers/pnp/pnpacpi/core.c                     |    2=20
 drivers/rtc/rtc-vt8500.c                       |   11=20
 drivers/usb/gadget/f_ecm.c                     |    4=20
 drivers/usb/gadget/f_eem.c                     |    5=20
 drivers/usb/gadget/f_midi.c                    |    1=20
 drivers/usb/gadget/f_ncm.c                     |    4=20
 drivers/usb/gadget/f_phonet.c                  |    8=20
 drivers/usb/gadget/f_rndis.c                   |    4=20
 drivers/usb/gadget/f_subset.c                  |    4=20
 drivers/usb/gadget/f_uvc.c                     |   39 +-
 drivers/usb/host/ehci-pci.c                    |    3=20
 drivers/usb/host/pci-quirks.c                  |    4=20
 drivers/usb/host/xhci-mem.c                    |    9=20
 drivers/usb/host/xhci-ring.c                   |   32 +-
 drivers/usb/host/xhci.c                        |    4=20
 drivers/usb/musb/cppi_dma.c                    |    1=20
 drivers/virtio/virtio_ring.c                   |    7=20
 fs/binfmt_misc.c                               |    5=20
 fs/binfmt_script.c                             |    4=20
 fs/exec.c                                      |   15 +
 fs/nfs/client.c                                |    3=20
 fs/nfs/dir.c                                   |   11=20
 fs/nfs/nfs4proc.c                              |   21 +
 fs/nfs/super.c                                 |    2=20
 fs/nfsd/nfs4proc.c                             |    8=20
 fs/nfsd/nfs4state.c                            |    2=20
 fs/nfsd/nfs4xdr.c                              |   11=20
 fs/nfsd/nfssvc.c                               |    2=20
 fs/nfsd/vfs.c                                  |   10=20
 fs/splice.c                                    |    4=20
 include/asm-generic/tlb.h                      |    9=20
 include/linux/binfmts.h                        |    1=20
 include/linux/freezer.h                        |   50 +++
 include/linux/page-flags.h                     |    8=20
 include/linux/pci_ids.h                        |    1=20
 include/linux/snmp.h                           |    3=20
 include/net/inet_connection_sock.h             |    1=20
 include/net/tcp.h                              |    1=20
 kernel/cgroup.c                                |    2=20
 kernel/irq/manage.c                            |   23 +
 lib/atomic64.c                                 |   17 -
 mm/memory.c                                    |    5=20
 mm/mempolicy.c                                 |   64 +---
 mm/page-writeback.c                            |   25 +
 net/batman-adv/bat_iv_ogm.c                    |    2=20
 net/bluetooth/hci_core.c                       |    2=20
 net/bluetooth/rfcomm/sock.c                    |    4=20
 net/dccp/ipv4.c                                |    4=20
 net/dccp/ipv6.c                                |    3=20
 net/ipv4/inet_connection_sock.c                |   16 +
 net/ipv4/inet_diag.c                           |  154 ++++++++---
 net/ipv4/ip_fragment.c                         |   19 -
 net/ipv4/proc.c                                |    3=20
 net/ipv4/sysctl_net_ipv4.c                     |    7=20
 net/ipv4/tcp_input.c                           |   93 ++++--
 net/ipv4/tcp_ipv4.c                            |    6=20
 net/ipv6/tcp_ipv6.c                            |    3=20
 net/sched/sch_htb.c                            |    2=20
 net/sctp/chunk.c                               |   20 +
 net/sctp/socket.c                              |    4=20
 sound/pci/hda/patch_realtek.c                  |    4=20
 sound/pci/hda/patch_sigmatel.c                 |    2=20
 sound/usb/midi.c                               |   91 ++++--
 95 files changed, 992 insertions(+), 486 deletions(-)

Akinobu Mita (1):
      batman-adv: fix random jitter calculation

Al Viro (1):
      ARM: missing ->mmap_sem around find_vma() in swp_emulate.c

Alan Cox (2):
      ne2000: add the right platform device
      pnpacpi: fix incorrect TEST_ALPHA() test

Alexander Shiyan (1):
      irda: sir_dev: Fix copy/paste typo

Alexander Stein (1):
      can: Do not call dev_put if restart timer is running upon close

Alexis R. Cortes (1):
      usb: host: xhci: Stricter conditional for Z1 system models for Compli=
ance Mode Patch

Andre Przywara (1):
      x86, amd: Disable way access filter on Piledriver CPUs

Andy Lutomirski (1):
      PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz

Ben Hutchings (1):
      HID: Add Apple wireless keyboard 2011 ANSI to special driver list

Bryan Schumaker (1):
      NFS: Add sequence_priviliged_ops for nfs4_proc_sequence()

Christian Lamparter (1):
      p54usb: add USBIDs for two more p54usb devices

Christoffer Dall (1):
      mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED

Christoph Paasch (1):
      inet: Fix kmemleak in tcp_v4/6_syn_recv_sock and dccp_v4/6_request_re=
cv_sock

Christophe TORDEUX (1):
      Input: sentelic - only report position of first finger as ST coordina=
tes

Corey Minyard (1):
      CRIS: fix I/O macros

Dave Kleikamp (1):
      sparc: huge_ptep_set_* functions need to call set_huge_pte_at()

David Woodhouse (1):
      solos-pci: fix double-free of TX skb in DMA mode

Eric Dumazet (6):
      tcp: fix MSG_SENDPAGE_NOTLAST logic
      tcp: implement RFC 5961 3.2
      tcp: implement RFC 5961 4.2
      tcp: refine SYN handling in tcp_validate_incoming
      tcp: tcp_replace_ts_recent() should not be called from tcp_validate_i=
ncoming()
      tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation

Felix Fietkau (1):
      b43: fix tx path skb leaks

Greg Kroah-Hartman (1):
      Linux 3.4.25

Gustavo Padovan (2):
      Bluetooth: Add missing lock nesting notation
      Bluetooth: cancel power_on work when unregistering the device

Hugh Dickins (1):
      tmpfs mempolicy: fix /proc/mounts corrupting memory

J. Bruce Fields (2):
      nfsd: fix v4 reply caching
      nfsd4: fix oops on unusual readlike compound

Jay Purohit (1):
      usb/ipheth: Add iPhone 5 support

Johannes Berg (1):
      ipv4: ip_check_defrag must not modify skb before unsharing

Julius Werner (1):
      xhci: fix null-pointer dereference when destroying half-built segment=
 rings

Jussi Kivilinna (1):
      rtlwifi: fix incorrect use of usb_alloc_coherent with usb_control_msg

Kees Cook (1):
      exec: do not leave bprm->interp on stack

Larry Finger (1):
      b43legacy: Fix firmware loading when driver is built into the kernel

Marcos Chaparro (1):
      Bluetooth: ath3k: Add support for VAIO VPCEH [0489:e027]

Michal Hocko (1):
      mm: limit mmu_gather batching to fix soft lockups on !CONFIG_PREEMPT

Neal Cardwell (4):
      inet_diag: fix oops for IPv4 AF_INET6 TCP SYN-RECV state
      inet_diag: validate byte code to prevent oops in inet_diag_bc_run()
      inet_diag: avoid unsafe and nonsensical prefix matches in inet_diag_b=
c_run()
      inet_diag: validate port comparison byte code to prevent unsafe reads

Neil Brown (1):
      nfsd: avoid permission checks on EXCLUSIVE_CREATE replay

NeilBrown (1):
      NFS: avoid NULL dereference in nfs_destroy_server

Ondrej Zary (1):
      x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops

Peter Popovec (1):
      Input: walkera0701 - fix crash on startup

Rafael J. Wysocki (1):
      ACPI / scan: Do not use dummy HID for system bus ACPI nodes

Robin Holt (1):
      SGI-XP: handle non-fatal traps

Russell Webb (1):
      xhci: Add Lynx Point LP to list of Intel switchable hosts

Sarah Sharp (2):
      xhci: Fix conditional check in bandwidth calculation.
      xHCI: Fix TD Size calculation on 1.0 hosts.

Sarveshwar Bandi (1):
      bonding: Bonding driver does not consider the gso_max_size/gso_max_se=
gs setting of slave devices.

Sebastian Andrzej Siewior (4):
      usb: gadget: midi: free hs descriptors
      usb: gadget: phonet: free requests in pn_bind()'s error path
      usb: gadget: uvc: fix error path in uvc_function_bind()
      usb: gadget: network: fix bind() error path

Sergei Shtylyov (1):
      usb: musb: cppi_dma: export cppi_interrupt()

Sonny Rao (1):
      mm: fix calculation of dirtyable memory

Stefan Hasko (1):
      net: sched: integer overflow fix

Stephen Boyd (1):
      lib: atomic64: Initialize locks statically to fix early users

Takashi Iwai (4):
      ALSA: usb-audio: Avoid autopm calls after disconnection
      ALSA: usb-audio: Fix missing autopm for MIDI input
      ALSA: hda - Fix the wrong pincaps set in ALC861VD dallas/hp fixup
      ALSA: hda - Fix pin configuration of HP Pavilion dv7

Tejun Heo (2):
      cgroup: remove incorrect dget/dput() pair in cgroup_create_dir()
      freezer: add missing mb's to freezer_count() and freezer_should_skip()

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

Will Deacon (3):
      virtio: force vring descriptors to be allocated from lowmem
      ARM: mm: use pteval_t to represent page protection values
      ARM: 7607/1: realview: fix private peripheral memory base for EB rev.=
 B boards

Xi Wang (1):
      nfs: fix null checking in nfs_get_option_str()

Yanchuan Nian (1):
      nfs: fix wrong object type in lockowner_slab

Zhang Rui (1):
      ACPI: do acpisleep dmi check when CONFIG_ACPI_SLEEP is set

nikolay@redhat.com (1):
      bonding: fix race condition in bonding_store_slaves_active


--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ8FZlAAoJEDjbvchgkmk+rlQP/AjbI9c6O8EhKdwAQUYz/86+
qfF4W15M4Hw1EICHY6Gn3dzV7UYwP2Kv2wajejdIYb/kNP4a3yb7bKGtLOKJ/2IL
pOmP3mWF5ovzVbj1BFuAqI92IWKKS3KQ6lfHd0BWS5B6fSCCsJ4u8VJdoiPIyfk1
5duJBs1L/YoLfwmrSHBWgRZQKR6BMA8nu7XUQ7TmY8GBlzSiSjp6a0tP04yhJnQR
i0mAVdVIjOg8zCJXwwgqSLFGv2wD1YTBwJjnHjJ4zE7hjEPii9sa50VG6nsbAOGn
JpTKnWJR6Na5YzCaWB7drmFvmtMVXKpz5Jta32a5amUv1Al4NmCS4wy6O8kgKHYx
wAgAaCy3p1fnFEnlNC+p5hfKwZdAU9j83uXY/CMU9A+6vrwBphLusUtaf2WP6Tiu
L5HfAYpVboQMf5eTFThHU+E9Re/VERLmmQssb+oBHP9Lfe7pLOd1uQB6T7NCt7HZ
GhMeQsRVa36cvcAS0g9zn368B5PZxlWleGHwtAukaEturkYPTHkTsKf4wfxHcrxA
Fty9fbLe912mqHQr5iUR/YYPiETUKYvDiwZOHIA6hQv0t4yOvFbjEMdyBN3+E8yo
BZQEK8DLB+re8Qj9UeWlDCZqpimAsUooa7mvcbrdDVb1k4jOz11dL3al5BJYRaWU
5H4Kny/nfdo0R0dO3dK1
=kel7
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
