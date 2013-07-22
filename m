Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3GVBoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:44:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3GVBoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:44:44 -0400
Date: Sun, 21 Jul 2013 18:44:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.2
Message-ID: <20130722014457.GA7652@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.2 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/parisc/registers              |    8 ++
 Makefile                                    |    2=20
 arch/arm/boot/dts/imx23.dtsi                |    8 +-
 arch/arm/boot/dts/imx28.dtsi                |    8 +-
 arch/arm/boot/dts/imx6dl.dtsi               |    2=20
 arch/arm/boot/dts/imx6q.dtsi                |    4 +
 arch/arm/include/asm/mmu_context.h          |   10 ++-
 arch/arm/kernel/perf_event.c                |    1=20
 arch/arm/kernel/smp_tlb.c                   |   18 -----
 arch/arm/kernel/smp_twd.c                   |    2=20
 arch/arm/mach-shmobile/setup-emev2.c        |    8 +-
 arch/arm/mach-shmobile/setup-r8a73a4.c      |    2=20
 arch/arm/mm/context.c                       |   55 +++++++++++++---
 arch/arm/mm/init.c                          |    2=20
 arch/c6x/mm/init.c                          |    1=20
 arch/parisc/include/asm/special_insns.h     |    9 +-
 arch/parisc/include/asm/tlbflush.h          |    5 -
 arch/parisc/kernel/cache.c                  |    2=20
 arch/parisc/lib/memcpy.c                    |   79 +++++++++++++++---------
 arch/x86/boot/compressed/eboot.c            |   20 +++++-
 arch/x86/xen/time.c                         |   17 -----
 drivers/acpi/Makefile                       |    1=20
 drivers/acpi/acpi_cmos_rtc.c                |   92 +++++++++++++++++++++++=
+++++
 drivers/acpi/acpica/hwxfsleep.c             |    8 +-
 drivers/acpi/device_pm.c                    |   23 +++++--
 drivers/acpi/ec.c                           |    4 +
 drivers/acpi/internal.h                     |    5 +
 drivers/acpi/scan.c                         |    1=20
 drivers/ata/ahci.c                          |    2=20
 drivers/ata/libahci.c                       |    3=20
 drivers/block/nbd.c                         |    7 +-
 drivers/dma/pl330.c                         |    4 -
 drivers/hid/hid-apple.c                     |    6 +
 drivers/hid/hid-core.c                      |    6 +
 drivers/hid/hid-ids.h                       |    3=20
 drivers/hv/ring_buffer.c                    |   10 +--
 drivers/hv/vmbus_drv.c                      |    2=20
 drivers/input/mouse/bcm5974.c               |   36 ++++++++++
 drivers/net/wireless/iwlwifi/pcie/tx.c      |   13 +++
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c |    2=20
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    1=20
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c |    6 -
 drivers/parisc/lba_pci.c                    |   56 +++++++++++++++++
 drivers/pci/iov.c                           |    5 -
 drivers/pci/probe.c                         |   14 ++--
 drivers/pci/quirks.c                        |    2=20
 drivers/pci/xen-pcifront.c                  |    7 --
 drivers/pcmcia/at91_cf.c                    |    4 -
 drivers/rtc/rtc-rv3029c2.c                  |    2=20
 drivers/tty/serial/pch_uart.c               |    5 +
 drivers/usb/gadget/f_mass_storage.c         |    2=20
 drivers/usb/host/ehci-omap.c                |   11 ++-
 drivers/usb/host/xhci-mem.c                 |    4 +
 drivers/usb/host/xhci-plat.c                |    1=20
 drivers/usb/serial/option.c                 |    4 -
 drivers/usb/serial/qcserial.c               |    8 ++
 fs/btrfs/ctree.c                            |   13 ++-
 fs/btrfs/send.c                             |   35 ++++++++++
 fs/cifs/cifs_unicode.h                      |    8 +-
 fs/cifs/cifsencrypt.c                       |    6 -
 fs/cifs/file.c                              |    9 +-
 fs/cifs/inode.c                             |    5 +
 fs/ext3/namei.c                             |    7 --
 fs/ext4/balloc.c                            |    4 -
 fs/ext4/extents.c                           |    4 -
 fs/ext4/file.c                              |   14 ++--
 fs/ext4/inline.c                            |    2=20
 fs/ext4/inode.c                             |   15 ++--
 fs/ext4/mballoc.c                           |   11 ++-
 fs/ext4/namei.c                             |    7 --
 fs/ext4/resize.c                            |    4 -
 fs/ext4/super.c                             |   14 +---
 fs/jbd2/journal.c                           |    3=20
 fs/jbd2/transaction.c                       |    2=20
 fs/ocfs2/xattr.c                            |   10 +++
 fs/ubifs/super.c                            |    2=20
 include/linux/cgroup.h                      |   58 ++++++++++++++---
 include/linux/nbd.h                         |    1=20
 kernel/cgroup.c                             |   25 +++++--
 kernel/irq/manage.c                         |    6 -
 kernel/timer.c                              |    8 +-
 mm/memcontrol.c                             |    8 --
 mm/page_alloc.c                             |    4 +
 mm/slab.c                                   |    2=20
 84 files changed, 675 insertions(+), 235 deletions(-)

Al Viro (1):
      ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()

Axel Lin (1):
      drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq

Bart Van Assche (1):
      timer: Fix jiffies wrap behavior of round_jiffies_common()

Bartlomiej Zolnierkiewicz (1):
      drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()

Ben Hutchings (1):
      genirq: Fix can_request_irq() for IRQs without an action

Chen Gang (1):
      arch: c6x: mm: include "asm/uaccess.h" to pass compiling

Christoph Lameter (1):
      slab: fix init_lock_keys

Dan Williams (1):
      USB: option,qcserial: move Novatel Gobi1K IDs to qcserial

Darren Hart (1):
      pch_uart: Add uart_clk selection for the MinnowBoard

Dmitry Torokhov (2):
      HID: apple: Add support for the 2013 Macbook Air
      Input: bcm5974 - add support for the 2013 MacBook Air

Emmanuel Grumbach (2):
      iwlwifi: pcie: fix race in queue unmapping
      iwlwifi: pcie: wake the queue if stopped when being unmapped

George Cherian (1):
      usb: host: xhci-plat: release mem region while removing module

Greg Kroah-Hartman (1):
      Linux 3.10.2

Helge Deller (4):
      parisc: document the shadow registers
      parisc: Fix gcc miscompilation in pa_memcpy()
      parisc: fix LMMIO mismatch between PAT length and MASK register
      parisc: optimize mtsp(0,sr) inline assembly

Jan Kara (4):
      ext4: fix data offset overflow on 32-bit archs in ext4_inline_data_fi=
emap()
      ext4: fix overflows in SEEK_HOLE, SEEK_DATA implementations
      ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
      ext4: fix overflow when counting used blocks on 32-bit architectures

Jason Liu (1):
      ARM: 7778/1: smp_twd: twd_update_frequency need be run on all online =
CPUs

Jason Wang (1):
      drivers: hv: switch to use mb() instead of smp_mb()

Jed Davis (1):
      ARM: 7765/1: perf: Record the user-mode PC in the call chain.

Jiang Liu (1):
      PCI: Fix refcount issue in pci_create_root_bus() error recovery path

Joachim Eastwood (1):
      pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status

John David Anglin (1):
      parisc: Ensure volatile space register %sr1 is not clobbered

Josef Bacik (3):
      Btrfs: fix estale with btrfs send
      Btrfs: hold the tree mod lock in __tree_mod_log_rewind
      Btrfs: only do the tree_mod_log_free_eb if this is our last ref

Junxiao Bi (1):
      ocfs2: xattr: fix inlined xattr reflink

Konrad Rzeszutek Wilk (1):
      xen/pcifront: Deal with toolstack missing 'XenbusStateClosing' state.

Lan Tianyu (2):
      ACPI: Add CMOS RTC Operation Region handler support
      ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to skip DSDT scan

Larry Finger (3):
      rtlwifi: rtl8192cu: Add new USB ID for TP-Link TL-WN8200ND
      rtlwifi: rtl8723ae: Fix typo in firmware names
      rtlwifi: rtl8192cu: Fix duplicate if test

Laszlo Ersek (1):
      xen/time: remove blocked time accounting from xen "clockchip"

Li Zefan (1):
      cgroup: fix umount vs cgroup_event_remove() race

Lorenzo Pieralisi (1):
      ARM: dts: imx: cpus/cpu nodes dts updates

Lv Zheng (1):
      ACPICA: Do not use extended sleep registers unless HW-reduced bit is =
set

Maarten ter Huurne (1):
      ext4: fix corruption when online resizing a fs with 1K block size

Magnus Damm (1):
      ARM: shmobile: emev2 GIO3 resource fix

Marc Zyngier (3):
      ARM: 7767/1: let the ASID allocator handle suspended animation
      ARM: 7768/1: prevent risks of out-of-bound access in ASID allocator
      ARM: 7769/1: Cortex-A15: fix erratum 798181 implementation

Mathias Nyman (1):
      xhci: check for failed dma pool allocation

Michal Hocko (1):
      memcg, kmem: fix reference count handling on the error path

Paul Clements (1):
      nbd: correct disconnect behavior

Pavel Shilovsky (1):
      CIFS: Fix a deadlock when a file is reopened

Rafael J. Wysocki (1):
      ACPI / PM: Fix corner case in acpi_bus_update_power()

Richard Genoud (1):
      UBIFS: correct mount message

Roger Quadros (1):
      USB: ehci-omap: Tweak PHY initialization sequence

Russell King (1):
      ARM: mm: fix boot on SA1110 Assabet

Seth Heasley (1):
      ahci: AHCI-mode SATA patch for Intel Coleto Creek DeviceIDs

Shane Huang (2):
      ahci: Add AMD CZ SATA device ID
      ahci: remove pmp link online check in FBS EH

Steve French (2):
      CIFS use sensible file nlink values if unprovided
      Handle big endianness in NTLM (ntlmv2) authentication

Takanari Hayama (1):
      ARM: shmobile: r8a73a4: Fix resources for SCIFB0

Tejun Heo (1):
      cgroup: fix RCU accesses to task->cgroups

Theodore Ts'o (6):
      jbd2: move superblock checksum calculation to jbd2_write_superblock()
      jbd2: fix theoretical race in jbd2__journal_restart
      ext4: check error return from ext4_write_inline_data_end()
      ext4: fix ext4_get_group_number()
      ext4: don't show usrquota/grpquota twice in /proc/mounts
      ext4: don't allow ext4_free_blocks() to fail due to ENOMEM

UCHINO Satoshi (1):
      usb: gadget: f_mass_storage: add missing memory barrier for thread_wa=
keup_needed

Wanpeng Li (1):
      mm/memory-hotplug: fix lowmem count overflow when offline pages

Xudong Hao (1):
      PCI: Finish SR-IOV VF setup before adding the device

Zach Bobroff (1):
      x86, efi: retry ExitBootServices() on failure


--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7I6YAAoJEDjbvchgkmk+33kP/AmrPlBBc/E/I9hhGOOaehcx
x/J7eINIJLt8HTGTa2oh25lNYSKnNesFou/SjitMbtuS36qw++1zwit3pz5Xk6an
vMwfb7QXw7vCK6iuUvUKQqhfQTHEXddy6IhfcBQaQ80ACztt9BRdAq+qEj0vqkM+
1y/D7dyrE7EMuTTgFPk1l41jFeU+518FWEG6M9GlTeWK27R+VUm1GLDevTtbDrD1
ygGAEY2S2FUQsTeUNEYWBIMEfKfyirg0Cvro338H4/dI3o/sQIO7avHrqWrNvftl
tTTX2PeiDBOIff8rzpvNZawJFN9Bx5X8cEex4aSvZ5yXpGmx1q6s2mLskYXjuSMV
rve6+qgykbEsIEg0KmZp0oS3dTyYXVag0ylX2eoabVjqvERBe8OoiU9R8n9rKPgQ
SC3fptHVmXBd0Mdq1YdeQMPxihfsnE36BuJiAd0znM8211/0PzF1rB525OtZmos3
tQJx22SD6JRUivnPrzOcJnXSVTasvtZoz3nLZ5K9PeFSP156cXrYk8CX1dL1ptWZ
TZLAc9P4mVYB23SP9czy3xsQZVpj2TVjITa/qt/DurH6k0pTcs6AXSLB8s/Ut7v3
tmsIRMP7VEJ0DBudpRyp9Jnyq2xk5pBr/jGOvnd5D3Q8pf6Xj4/kDcEQ/8188Iqq
87rXhJqnWJDou7b9aPoI
=Zw8i
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
