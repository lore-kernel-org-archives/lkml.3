Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab3AKSN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:13:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:56713 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab3AKSNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:13:25 -0500
Date: Fri, 11 Jan 2013 10:13:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.7.2
Message-ID: <20130111181316.GA13353@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.7.2 kernel.

All users of the 3.7 kernel series must upgrade.

The updated 3.7.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.7.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                       |    2=20
 arch/arm/kernel/swp_emulate.c                  |    2=20
 arch/arm/mach-realview/include/mach/board-eb.h |    2=20
 arch/arm/mm/cache-v7.S                         |    6=20
 arch/arm/mm/mmu.c                              |    2=20
 arch/arm64/include/asm/pgtable.h               |    2=20
 arch/arm64/include/asm/unistd32.h              |    2=20
 arch/arm64/kernel/signal.c                     |   37 +-
 arch/cris/include/asm/io.h                     |   39 ++
 arch/sparc/crypto/aes_asm.S                    |   20 +
 arch/sparc/crypto/aes_glue.c                   |   31 ++
 arch/sparc/crypto/camellia_glue.c              |    3=20
 arch/sparc/crypto/des_asm.S                    |    1=20
 arch/sparc/crypto/des_glue.c                   |    6=20
 arch/sparc/include/asm/hugetlb.h               |   10=20
 arch/x86/pci/common.c                          |    3=20
 drivers/acpi/scan.c                            |    2=20
 drivers/acpi/sleep.c                           |  348 ++++++++++++--------=
-----
 drivers/ata/libata-acpi.c                      |    4=20
 drivers/atm/solos-pci.c                        |    5=20
 drivers/base/firmware_class.c                  |   30 +-
 drivers/bluetooth/btusb.c                      |    1=20
 drivers/hid/hid-core.c                         |    1=20
 drivers/input/joystick/walkera0701.c           |    7=20
 drivers/input/keyboard/gpio_keys.c             |   13=20
 drivers/input/keyboard/gpio_keys_polled.c      |   13=20
 drivers/input/mouse/sentelic.c                 |    2=20
 drivers/input/serio/i8042-x86ia64io.h          |    9=20
 drivers/input/tablet/wacom_wac.c               |    3=20
 drivers/misc/sgi-xp/xpc_main.c                 |   34 ++
 drivers/net/can/dev.c                          |    3=20
 drivers/net/usb/cdc_ether.c                    |   15 +
 drivers/net/usb/qmi_wwan.c                     |   14 +
 drivers/net/wireless/b43/dma.c                 |    7=20
 drivers/net/wireless/b43/main.c                |   12=20
 drivers/net/wireless/b43/pio.c                 |    4=20
 drivers/net/wireless/b43legacy/b43legacy.h     |    5=20
 drivers/net/wireless/b43legacy/main.c          |   37 ++
 drivers/net/wireless/p54/p54usb.c              |    4=20
 drivers/net/wireless/rtlwifi/usb.c             |    7=20
 drivers/pci/pci-driver.c                       |   67 ++--
 drivers/pci/pci.c                              |    2=20
 drivers/pci/pcie/portdrv_pci.c                 |   20 +
 drivers/pci/quirks.c                           |    7=20
 drivers/pnp/pnpacpi/core.c                     |    2=20
 drivers/rtc/class.c                            |    1=20
 drivers/rtc/rtc-vt8500.c                       |   11=20
 drivers/staging/omapdrm/omap_crtc.c            |    2=20
 drivers/usb/chipidea/core.c                    |    3=20
 drivers/usb/core/message.c                     |   54 ++-
 drivers/usb/gadget/f_ecm.c                     |    4=20
 drivers/usb/gadget/f_eem.c                     |    5=20
 drivers/usb/gadget/f_midi.c                    |    1=20
 drivers/usb/gadget/f_ncm.c                     |    4=20
 drivers/usb/gadget/f_phonet.c                  |    8=20
 drivers/usb/gadget/f_rndis.c                   |    4=20
 drivers/usb/gadget/f_subset.c                  |    4=20
 drivers/usb/gadget/f_uvc.c                     |   39 +-
 drivers/usb/gadget/tcm_usb_gadget.c            |    1=20
 drivers/usb/host/ehci-pci.c                    |    3=20
 drivers/usb/host/pci-quirks.c                  |    4=20
 drivers/usb/host/xhci-mem.c                    |    9=20
 drivers/usb/host/xhci-ring.c                   |   32 +-
 drivers/usb/host/xhci.c                        |    4=20
 drivers/usb/musb/cppi_dma.c                    |    1=20
 drivers/usb/musb/musb_dsps.c                   |    3=20
 drivers/virtio/virtio_ring.c                   |    7=20
 fs/binfmt_misc.c                               |    5=20
 fs/binfmt_script.c                             |    4=20
 fs/cifs/readdir.c                              |   59 ++--
 fs/cifs/smb1ops.c                              |    7=20
 fs/cifs/smb2pdu.c                              |    2=20
 fs/cifs/transport.c                            |    6=20
 fs/dcache.c                                    |    2=20
 fs/exec.c                                      |   15 +
 fs/file_table.c                                |    2=20
 fs/nfs/callback_proc.c                         |    2=20
 fs/nfs/client.c                                |    3=20
 fs/nfs/dir.c                                   |   27 +
 fs/nfs/direct.c                                |    8=20
 fs/nfs/nfs4proc.c                              |   46 ++-
 fs/nfs/pnfs.c                                  |    2=20
 fs/nfs/read.c                                  |   10=20
 fs/nfs/super.c                                 |    2=20
 fs/nfs/write.c                                 |   13=20
 fs/nfsd/nfs4proc.c                             |    8=20
 fs/nfsd/nfs4state.c                            |    2=20
 fs/nfsd/nfs4xdr.c                              |   11=20
 fs/nfsd/nfssvc.c                               |    2=20
 fs/nfsd/vfs.c                                  |   10=20
 fs/proc/array.c                                |    2=20
 fs/splice.c                                    |    4=20
 fs/xfs/xfs_aops.c                              |   81 ++---
 fs/xfs/xfs_log.c                               |    3=20
 fs/xfs/xfs_qm.c                                |   15 -
 include/asm-generic/tlb.h                      |    9=20
 include/linux/binfmts.h                        |    1=20
 include/linux/cgroup.h                         |    1=20
 include/linux/freezer.h                        |   50 +++
 include/linux/hugetlb_cgroup.h                 |    5=20
 include/linux/kernel.h                         |    6=20
 include/linux/libata.h                         |    1=20
 include/linux/page-flags.h                     |    8=20
 include/linux/pci_ids.h                        |    1=20
 include/net/gro_cells.h                        |   14 -
 include/net/inet_connection_sock.h             |    1=20
 include/net/ndisc.h                            |    7=20
 kernel/cgroup.c                                |   76 ++---
 kernel/cgroup_freezer.c                        |   13=20
 kernel/fork.c                                  |    9=20
 kernel/irq/manage.c                            |   23 +
 kernel/printk.c                                |    5=20
 kernel/signal.c                                |    1=20
 lib/atomic64.c                                 |   17 -
 mm/highmem.c                                   |    1=20
 mm/hugetlb.c                                   |   11=20
 mm/hugetlb_cgroup.c                            |   19 +
 mm/memory.c                                    |    5=20
 mm/mempolicy.c                                 |   64 +---
 mm/page-writeback.c                            |   25 +
 net/9p/trans_virtio.c                          |    3=20
 net/batman-adv/bat_iv_ogm.c                    |    2=20
 net/bluetooth/hci_core.c                       |    2=20
 net/bluetooth/rfcomm/sock.c                    |    4=20
 net/bluetooth/sco.c                            |   19 -
 net/dccp/ipv4.c                                |    4=20
 net/dccp/ipv6.c                                |    3=20
 net/ipv4/inet_connection_sock.c                |   16 +
 net/ipv4/tcp_ipv4.c                            |    6=20
 net/ipv6/ndisc.c                               |   17 +
 net/ipv6/tcp_ipv6.c                            |    3=20
 net/mac802154/wpan.c                           |    2=20
 net/sched/sch_htb.c                            |    2=20
 net/sctp/probe.c                               |    3=20
 sound/pci/hda/hda_intel.c                      |   19 +
 sound/pci/hda/patch_conexant.c                 |    1=20
 sound/pci/hda/patch_hdmi.c                     |   18 -
 sound/pci/hda/patch_realtek.c                  |   34 ++
 sound/pci/hda/patch_sigmatel.c                 |    2=20
 sound/usb/midi.c                               |   91 ++++--
 140 files changed, 1279 insertions(+), 748 deletions(-)

Aaron Lu (1):
      libata: restore acpi disable functionality

Afzal Mohammed (1):
      Revert "usb: musb: dsps: remove explicit NOP device creation"

Akinobu Mita (1):
      batman-adv: fix random jitter calculation

Al Viro (2):
      arm64: compat for clock_adjtime(2) is miswired
      ARM: missing ->mmap_sem around find_vma() in swp_emulate.c

Alan Cox (1):
      pnpacpi: fix incorrect TEST_ALPHA() test

Alan Stern (1):
      USB: fix endpoint-disabling for failed config changes

Alexander Aring (1):
      mac802154: fix NOHZ local_softirq_pending 08 warning

Alexander Stein (1):
      can: Do not call dev_put if restart timer is running upon close

Alexis R. Cortes (1):
      usb: host: xhci: Stricter conditional for Z1 system models for Compli=
ance Mode Patch

Andrew Morton (1):
      revert "rtc: recycle id when unloading a rtc driver"

Andy Gross (1):
      staging: drm/omap: Fix include error during make

Andy Lutomirski (1):
      PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz

Artem Bityutskiy (1):
      proc: pid/status: show all supplementary groups

Ben Hutchings (1):
      HID: Add Apple wireless keyboard 2011 ANSI to special driver list

Bryan Schumaker (1):
      NFS: Add sequence_priviliged_ops for nfs4_proc_sequence()

Catalin Marinas (1):
      arm64: Make !dirty ptes read-only

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

Chuansheng Liu (2):
      firmware loader: Fix the race FW_STATUS_DONE is followed by class_tim=
eout
      firmware loader: Fix the concurrent request_firmware() race for kref_=
get/put

Corey Minyard (1):
      CRIS: fix I/O macros

Dan Williams (1):
      qmi_wwan/cdc_ether: add Dell Wireless 5800 (Novatel E362) USB IDs

Daniel Borkmann (1):
      sctp: jsctp_sf_eat_sack: fix jprobes function signature mismatch

Dave Chinner (2):
      xfs: fix direct IO nested transaction deadlock.
      xfs: fix stray dquot unlock when reclaiming dquots

Dave Kleikamp (1):
      sparc: huge_ptep_set_* functions need to call set_huge_pte_at()

David Henningsson (1):
      ALSA: hda - add mute LED for HP Pavilion 17 (Realtek codec)

David S. Miller (6):
      sparc64: Fix unrolled AES 256-bit key loops.
      sparc64: Fix AES ctr mode block size.
      sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in AES code.
      sparc64: Fix ECB looping constructs in AES code.
      sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in DES code.
      sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in CAMELLIA code.

David Woodhouse (1):
      solos-pci: fix double-free of TX skb in DMA mode

Diego Calleja (1):
      Input: wacom - fix touch support for Bamboo Fun CTH-461

Dmitry Torokhov (1):
      Input: gpio_keys - defer probing if GPIO probing is deferred

Duan Jiong (1):
      ipv6: Change skb->data before using icmpv6_notify() to propagate redi=
rect

Eric Dumazet (2):
      net: fix a race in gro_cell_poll()
      tcp: fix MSG_SENDPAGE_NOTLAST logic

Felix Fietkau (1):
      b43: fix tx path skb leaks

Gabor Juhos (1):
      Input: gpio_keys_polled - defer probing if GPIO probing is deferred

Gao feng (1):
      cgroup_rm_file: don't delete the uncreated files

Greg Kroah-Hartman (1):
      Linux 3.7.2

Guenter Roeck (1):
      linux/kernel.h: fix DIV_ROUND_CLOSEST with unsigned divisors

Gustavo Padovan (3):
      Bluetooth: Add missing lock nesting notation
      Bluetooth: cancel power_on work when unregistering the device
      Revert "Bluetooth: Fix possible deadlock in SCO code"

Huang Ying (2):
      PCI/PM: Keep runtime PM enabled for unbound PCI devices
      PCI/PM: Do not suspend port if any subordinate device needs PME polli=
ng

Hugh Dickins (1):
      tmpfs mempolicy: fix /proc/mounts corrupting memory

J. Bruce Fields (2):
      nfsd: fix v4 reply caching
      nfsd4: fix oops on unusual readlike compound

Jan Kara (1):
      fs: Fix imbalance in freeze protection in mark_files_ro()

Jeff Cook (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17b5]

Jeff Layton (6):
      nfs: don't extend writes to cover entire page if pagecache is invalid
      nfs: don't zero out the rest of the page if we hit the EOF on a DIO R=
EAD
      cifs: move check for NULL socket into smb_send_rqst
      cifs: adjust sequence number downward after signing NT_CANCEL request
      cifs: rename cifs_readdir_lookup to cifs_prime_dcache and make it voi=
d return
      cifs: don't compare uniqueids in cifs_prime_dcache unless server inod=
e numbers are in use

Jianguo Wu (1):
      mm/hugetlb: create hugetlb cgroup file in hugetlb_init

Julius Werner (1):
      xhci: fix null-pointer dereference when destroying half-built segment=
 rings

Jussi Kivilinna (1):
      rtlwifi: fix incorrect use of usb_alloc_coherent with usb_control_msg

Kees Cook (1):
      exec: do not leave bprm->interp on stack

Larry Finger (1):
      b43legacy: Fix firmware loading when driver is built into the kernel

Lothar Wa=DFmann (1):
      USB: chipidea: fix use after free bug

Michal Hocko (1):
      mm: limit mmu_gather batching to fix soft lockups on !CONFIG_PREEMPT

Myron Stowe (1):
      PCI: Work around Stratus ftServer broken PCIe hierarchy (fix DMI chec=
k)

Neil Brown (1):
      nfsd: avoid permission checks on EXCLUSIVE_CREATE replay

NeilBrown (2):
      NFS: avoid NULL dereference in nfs_destroy_server
      vfs: d_obtain_alias() needs to use "/" as default name.

Nickolai Zeldovich (1):
      nfs: avoid dereferencing null pointer in initiate_bulk_draining

Oleg Nesterov (1):
      signals: sys_ssetmask() uses uninitialized newmask

Ondrej Zary (1):
      x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops

Peter Popovec (1):
      Input: walkera0701 - fix crash on startup

Rafael J. Wysocki (1):
      ACPI / scan: Do not use dummy HID for system bus ACPI nodes

Robin Holt (1):
      SGI-XP: handle non-fatal traps

Roland Dreier (1):
      printk: fix incorrect length from print_time() when seconds > 99999

Russell Webb (1):
      xhci: Add Lynx Point LP to list of Intel switchable hosts

Sarah Sharp (2):
      xhci: Fix conditional check in bandwidth calculation.
      xHCI: Fix TD Size calculation on 1.0 hosts.

Sebastian Andrzej Siewior (5):
      usb: gadget: midi: free hs descriptors
      usb: gadget: phonet: free requests in pn_bind()'s error path
      usb: gadget: tcm_usb_gadget: NULL terminate the FS descriptor list
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

Steve French (1):
      SMB3 mounts fail with access denied to some servers

Sven Wegener (1):
      NFSv4: Check for buffer length in __nfs4_get_acl_uncached

Takashi Iwai (7):
      ALSA: usb-audio: Avoid autopm calls after disconnection
      ALSA: usb-audio: Fix missing autopm for MIDI input
      ALSA: hda - Move runtime PM check to runtime_idle callback
      ALSA: hda - Add stereo-dmic fixup for Acer Aspire One 522
      ALSA: hda - Always turn on pins for HDMI/DP
      ALSA: hda - Fix the wrong pincaps set in ALC861VD dallas/hp fixup
      ALSA: hda - Fix pin configuration of HP Pavilion dv7

Tejun Heo (3):
      cgroup: cgroup_subsys->fork() should be called after the task is adde=
d to css_set
      cgroup: remove incorrect dget/dput() pair in cgroup_create_dir()
      freezer: add missing mb's to freezer_count() and freezer_should_skip()

Thomas Gleixner (1):
      genirq: Always force thread affinity

Tomasz Guszkowski (1):
      p54usb: add USB ID for T-Com Sinus 154 data II

Tony Prisk (2):
      drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield
      drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct rtc_t=
ime

Trond Myklebust (3):
      NFS: Fix calls to drop_nlink()
      NFS: Don't use SetPageError in the NFS writeback code
      NFS: Ensure that we free the rpc_task after read and write cleanups a=
re done

Weston Andros Adamson (1):
      NFS: Fix access to suid/sgid executables

Will Deacon (7):
      arm64: signal: push the unwinding prologue on the signal stack
      mm: highmem: export kmap_to_page for modules
      virtio: 9p: correctly pass physical address to userspace for high pag=
es
      virtio: force vring descriptors to be allocated from lowmem
      ARM: mm: use pteval_t to represent page protection values
      ARM: 7607/1: realview: fix private peripheral memory base for EB rev.=
 B boards
      ARM: 7606/1: cache: flush to LoUU instead of LoUIS on uniprocessor CP=
Us

Xi Wang (1):
      nfs: fix null checking in nfs_get_option_str()

Yanchuan Nian (2):
      nfs: fix wrong object type in lockowner_slab
      pnfs: Increase the refcount when LAYOUTGET fails the first time

Zhang Rui (1):
      ACPI: do acpisleep dmi check when CONFIG_ACPI_SLEEP is set


--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ8FY8AAoJEDjbvchgkmk+cC8QALgAQsOxPZtYliyDfRwvscuB
zObiCBFs7jXz4l8WICxcJj3OeuNtWo9NJ1maYrU0i/JKCRWpBh+iyQs/7RYqfT34
SCfKjLB4WrbFvorpng6VddgXMT6T0B6mE28mPJHHt98VuQiocDu5UTIBjnzQj4YE
iTOY4IjfZQHso/ylcuy4FiHu7qVPiBzVqxZ6HARY72XsSHcgNGalJbp2DicyqZ0X
maeZ0NLuhZXFBiaCOElyxhpgp+sPkXGv/6PN+m6pIwt+5qG6XCNwVIMs8EIB/Zmd
Dw37coPKOnoA8I8Q0Vx0dB8uywML3zy5RBMhdGCt/ullla91iCj9Bw9Wav3QloiF
zE6bw+Dp6RDMa0DSB2D1kkjqh42TKKCGaUQdSXH9JLbc8aMkhWMqyPHh4CWG8nw1
W6cHA73JnRFqHDPV6hwXMTTS2BpgRjEykSOS92fTSIkg4k8j26J7w/nWlgl1I/PX
vai2YtCQKmjUdTCBZX8IpLFdgdoK0zGjS+0e9jSgbwmJ9Kd3XpUSVH42s0STCg3c
hzgho7Os/DCN10C6DkZxUwiNds9ZKIMTabaAwqC2yuzdfSxG4//GoNUfYie0x09x
hQIz3bR99SPVrrFvrgQI3Ev/F+sIPcI/wXjpwXFKgLe44xRlIX+0NYgXODCfdJxM
AS13WAxBcFlURXlOMNwX
=lvU9
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
