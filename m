Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3K2TI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 14:08:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3K2TIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 14:08:55 -0500
Date: Fri, 29 Nov 2013 11:09:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.11.10
Message-ID: <20131129190948.GA30832@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.11.10 kernel.

All users of the 3.11 kernel series must upgrade.

Note, this is the LAST 3.11.x kernel to be releases, please move to
3.12.x at this point in time.  3.11.x is end-of-life, not to be updated
again.

The updated 3.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.11.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                            |    2=20
 arch/ia64/include/asm/processor.h                   |    2=20
 arch/s390/crypto/aes_s390.c                         |   19 +-
 arch/x86/kernel/process.c                           |    6=20
 crypto/ansi_cprng.c                                 |    4=20
 drivers/acpi/acpica/exoparg1.c                      |   48 +++++
 drivers/acpi/acpica/exstore.c                       |  166 ++++++++++++---=
-----
 drivers/acpi/ec.c                                   |    3=20
 drivers/acpi/pci_root.c                             |    5=20
 drivers/acpi/processor_idle.c                       |   46 +----
 drivers/acpi/scan.c                                 |    2=20
 drivers/acpi/video.c                                |    2=20
 drivers/bluetooth/btusb.c                           |    1=20
 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc1.c |    4=20
 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd7.c |    1=20
 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd9.c |    1=20
 drivers/hv/channel_mgmt.c                           |    5=20
 drivers/idle/intel_idle.c                           |    2=20
 drivers/net/can/c_can/c_can.c                       |    6=20
 drivers/net/can/usb/kvaser_usb.c                    |   20 +-
 drivers/net/ethernet/atheros/alx/main.c             |    3=20
 drivers/net/wireless/libertas/debugfs.c             |    6=20
 drivers/net/wireless/rt2x00/rt2800lib.c             |   11 -
 drivers/net/wireless/rt2x00/rt2x00dev.c             |    3=20
 drivers/net/wireless/rt2x00/rt2x00lib.h             |    2=20
 drivers/net/wireless/rt2x00/rt2x00mac.c             |    7=20
 drivers/net/wireless/rt2x00/rt2x00queue.c           |    4=20
 drivers/pci/access.c                                |   19 +-
 drivers/platform/x86/thinkpad_acpi.c                |    7=20
 drivers/scsi/aacraid/commctrl.c                     |    3=20
 drivers/staging/comedi/comedi_fops.c                |    5=20
 drivers/staging/zram/zram_drv.c                     |    6=20
 drivers/usb/serial/mos7840.c                        |    4=20
 fs/btrfs/relocation.c                               |   18 +-
 fs/exec.c                                           |    6=20
 include/linux/binfmts.h                             |    3=20
 include/linux/sched.h                               |   82 +++++++++
 include/linux/thread_info.h                         |    2=20
 ipc/shm.c                                           |   37 +++-
 kernel/cpu/idle.c                                   |    9 -
 kernel/ptrace.c                                     |    3=20
 kernel/trace/trace_event_perf.c                     |    2=20
 net/sunrpc/clnt.c                                   |    2=20
 security/integrity/ima/ima_policy.c                 |    1=20
 44 files changed, 395 insertions(+), 195 deletions(-)

Aaron Lu (1):
      ACPI / video: Quirk initial backlight level 0

Andy Adamson (1):
      SUNRPC: don't map EKEYEXPIRED to EACCES in call_refreshresult

Ben Skeggs (1):
      drm/nvc0-/gr: fix a number of missing explicit array terminators...

Bjorn Helgaas (3):
      PCI: Allow PCIe Capability link-related register access for switches
      PCI: Remove PCIe Capability version checks
      PCI: Support PCIe Capability Slot registers only for ports with slots

Bob Moore (3):
      ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and Buffe=
rField refs.
      ACPICA: Return error if DerefOf resolves to a null package element.
      ACPICA: Fix for a Store->ArgX when ArgX contains a reference to a fie=
ld.

Dan Carpenter (1):
      libertas: potential oops in debugfs

Felix Fietkau (1):
      rt2x00: fix a crash bug in the HT descriptor handling fix

Gabor Juhos (1):
      rt2x00: rt2800lib: fix VGC adjustment for RT5592

Greg Kroah-Hartman (1):
      Linux 3.11.10

Greg Thelen (1):
      ipc,shm: fix shm_file deletion races

Hans de Goede (1):
      Bluetooth: revert: "Bluetooth: Add missing reset_resume dev_pm_ops"

Herbert Xu (1):
      crypto: s390 - Fix aes-cbc IV corruption

Ian Abbott (1):
      staging: comedi: avoid memleak for subdevice private

Jesper Nilsson (1):
      ipc,shm: correct error return value in shmctl (SHM_UNLOCK)

Johan Hovold (1):
      USB: mos7840: fix tiocmget error handling

Josef Bacik (1):
      Btrfs: relocate csums properly with prealloc extents

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Fix a bug in channel rescind code

Kees Cook (1):
      exec/ptrace: fix get_dumpable() incorrect tests

Mahesh Rajashekhara (1):
      aacraid: prevent invalid pointer dereference

Markus Pargmann (1):
      can: c_can: Fix RX message handling, handle lost message before EOB

Mimi Zohar (1):
      Revert "ima: policy for RAMFS"

Neil Horman (1):
      crypto: ansi_cprng - Fix off by one error in non-block size request

Olivier Sobrie (1):
      can: kvaser_usb: fix usb endpoints detection

Peter Zijlstra (1):
      sched, idle: Fix the idle polling state logic

Puneet Kumar (1):
      ACPI / EC: Ensure lock is acquired before accessing ec struct members

Rafael J. Wysocki (2):
      ACPI / hotplug: Fix handle_root_bridge_removal()
      ACPI / hotplug: Do not execute "insert in progress" _OST

Rashika Kheria (1):
      Staging: zram: Fix access of NULL pointer

Stanislaw Gruszka (2):
      rt2x00: check if device is still available on rt2x00mac_flush()
      rt2x00: fix HT TX descriptor settings regression

Steven Rostedt (1):
      perf/ftrace: Fix paranoid level for enabling function tracer

Takashi Iwai (1):
      thinkpad_acpi: Fix build error when CONFIG_SND_MAX_CARDS > 32

hahnjo (1):
      alx: Reset phy speed after resume


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmOZ8AAoJEDjbvchgkmk+DKAP/itpdQtjIO3NHgwYshLlGD8Y
IfbM2+5ly6ChX0KVUeMxzOPb8s8p0wHJqMn4aAIBwQMDWJM5DjDv3+EyQCIy4IiL
gAO+my/jN69bJVKI6PJViR2I3OUBHcF4UKAouERIeqGgUOM6UFfVMyTlOgZZpX1P
NMgfBHruwuBZYj10N/IL3IkB3ryFt61OwDgWCZf9h0kplmR2aC2z7B5qim+2KhGs
9RH7c3hfiPyD4I1Oo6Ja0QEpJR5eBsa2I4Ac2LkAZu3UacJQsnBYg5AEdjnuhVp5
uQa7cVWa05VJF1GRT9uWNZA1fFH5rpeivIdirczDEJSmrWn6n/h5E5foOPnTBcsB
dpZsDlITR2cSe2EOHBSD6x6TR/sVkP1HlnaLLQSMLfsjbFZ8O209y9Acy/ghlI7Y
EnFw3D95DX3LUOjiSWbnpgoXWD2aM9aHvDqMgI7JCXfum3GvAO1oH2QH01P4kFCJ
ENBMOPpWRJNJVJYUSu8Jnz/JciIRAyPlxLorSA9K/JMLPP9bpgzdVV+lxFjuj8B9
VDm8YKZO+cLaR8Z0SEsHVblj91qH1ZM3w7I5aTCS5bRL6kRy7jJJ8K72yMKU+6/7
cub0G5jPXcxbzkNDEBzzsKm0brrh6z+se53WXfWqlJHHRAf/9vTp5wVRtFpe46z+
IkU24T6BRNgr/MP68XSV
=Kc5P
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
