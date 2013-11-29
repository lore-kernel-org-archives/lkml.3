Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3K2T0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 14:26:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3K2T0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 14:26:11 -0500
Date: Fri, 29 Nov 2013 11:27:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.21
Message-ID: <20131129192705.GA15863@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.21 kernel.

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

 Makefile                                           |    2=20
 arch/arm/kvm/mmu.c                                 |   34 +++-
 arch/cris/include/asm/io.h                         |    1=20
 arch/ia64/include/asm/processor.h                  |    2=20
 arch/powerpc/kernel/signal_32.c                    |   10 +
 arch/powerpc/kernel/vio.c                          |    4=20
 arch/powerpc/mm/slice.c                            |    2=20
 arch/powerpc/platforms/52xx/Kconfig                |    2=20
 arch/powerpc/platforms/powernv/pci-ioda.c          |   12 +
 arch/s390/crypto/aes_s390.c                        |   19 +-
 arch/s390/kernel/smp.c                             |    4=20
 arch/s390/kernel/vtime.c                           |    2=20
 arch/x86/kernel/ftrace.c                           |   14 +
 arch/x86/kernel/microcode_amd.c                    |    2=20
 arch/x86/kernel/process.c                          |    6=20
 arch/x86/kvm/emulate.c                             |    5=20
 block/blk-core.c                                   |    1=20
 block/blk-settings.c                               |    1=20
 block/blk-timeout.c                                |    3=20
 crypto/ansi_cprng.c                                |    4=20
 drivers/acpi/acpica/exoparg1.c                     |   48 +++++
 drivers/acpi/acpica/exstore.c                      |  166 ++++++++++++----=
----
 drivers/acpi/ec.c                                  |    3=20
 drivers/acpi/pci_root.c                            |    5=20
 drivers/acpi/processor_idle.c                      |   46 +----
 drivers/acpi/scan.c                                |    2=20
 drivers/acpi/video.c                               |    2=20
 drivers/block/brd.c                                |    2=20
 drivers/block/loop.c                               |    2=20
 drivers/firmware/dmi_scan.c                        |   12 +
 drivers/gpu/drm/i915/intel_lvds.c                  |   24 ++
 drivers/gpu/drm/nouveau/core/engine/disp/hdanva3.c |    2=20
 drivers/gpu/drm/nouveau/core/engine/disp/hdanvd0.c |    2=20
 drivers/gpu/drm/nouveau/core/engine/disp/sornv50.c |    8=20
 drivers/hwmon/lm90.c                               |   11 -
 drivers/idle/intel_idle.c                          |    2=20
 drivers/misc/mei/nfc.c                             |   10 -
 drivers/net/can/c_can/c_can.c                      |    6=20
 drivers/net/can/usb/kvaser_usb.c                   |   20 +-
 drivers/net/wireless/libertas/debugfs.c            |    6=20
 drivers/net/wireless/rt2x00/rt2800lib.c            |   11 -
 drivers/net/wireless/rt2x00/rt2800usb.c            |   12 -
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    3=20
 drivers/net/wireless/rt2x00/rt2x00lib.h            |    2=20
 drivers/net/wireless/rt2x00/rt2x00mac.c            |    7=20
 drivers/net/wireless/rt2x00/rt2x00queue.c          |    4=20
 drivers/pci/access.c                               |   19 +-
 drivers/scsi/aacraid/commctrl.c                    |    3=20
 drivers/usb/core/hub.c                             |    5=20
 drivers/usb/serial/mos7840.c                       |    4=20
 fs/configfs/dir.c                                  |   16 +
 fs/exec.c                                          |    6=20
 fs/nfs/nfs4proc.c                                  |   22 +-
 fs/nfsd/export.c                                   |   15 +
 fs/nfsd/vfs.c                                      |  173 ++++++++++++----=
-----
 include/linux/binfmts.h                            |    3=20
 include/linux/mod_devicetable.h                    |    6=20
 include/linux/sched.h                              |   82 +++++++++
 include/linux/thread_info.h                        |    2=20
 include/sound/compress_driver.h                    |    9 +
 ipc/shm.c                                          |   37 +++-
 kernel/cpu/idle.c                                  |    9 -
 kernel/ptrace.c                                    |    3=20
 kernel/trace/trace_event_perf.c                    |    2=20
 mm/slub.c                                          |    4=20
 net/sunrpc/clnt.c                                  |    2=20
 net/sunrpc/xprtsock.c                              |   28 ++-
 security/integrity/ima/ima_policy.c                |    1=20
 sound/core/compress_offload.c                      |   54 +++++-
 sound/isa/msnd/msnd_pinnacle.c                     |    4=20
 sound/pci/hda/hda_codec.c                          |    7=20
 sound/pci/hda/hda_generic.c                        |    4=20
 sound/pci/hda/patch_analog.c                       |    6=20
 sound/pci/hda/patch_conexant.c                     |    3=20
 sound/pci/hda/patch_realtek.c                      |   83 +++++++++-
 sound/usb/6fire/chip.c                             |    2=20
 virt/kvm/iommu.c                                   |    4=20
 77 files changed, 817 insertions(+), 349 deletions(-)

Aaron Lu (1):
      ACPI / video: Quirk initial backlight level 0

Anatolij Gustschin (1):
      powerpc/52xx: fix build breakage for MPC5200 LPBFIFO module

Andy Adamson (1):
      SUNRPC: don't map EKEYEXPIRED to EACCES in call_refreshresult

Anton Blanchard (1):
      powerpc: ppc64 address space capped at 32TB, mmap randomisation disab=
led

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

Chris Wilson (1):
      drm/i915: quirk away phantom LVDS on Intel's D510MO mainboard

Christoffer Dall (1):
      arm/arm64: KVM: Fix hyp mappings of vmalloc regions

Christoph Hellwig (2):
      nfsd: split up nfsd_setattr
      nfsd: make sure to balance get/put_write_access

Christoph Lameter (1):
      slub: Handle NULL parameter in kmem_cache_flags

Dan Carpenter (1):
      libertas: potential oops in debugfs

David Henningsson (3):
      ALSA: hda - Make sure mute LEDs stay on during runtime suspend (Realt=
ek)
      ALSA: hda - Fix Line Out automute on Realtek multifunction jacks
      ALSA: hda - Add headset quirk for Dell Inspiron 3135

Emil Velikov (1):
      drm/nv50-/disp: remove dcb_outp_match call, and related variables

Felix Fietkau (1):
      rt2x00: fix a crash bug in the HT descriptor handling fix

Gabor Juhos (1):
      rt2x00: rt2800lib: fix VGC adjustment for RT5592

Gavin Shan (1):
      powerpc/powernv: Add PE to its own PELTV

Greg Edwards (1):
      KVM: IOMMU: hva align mapping page size

Greg Kroah-Hartman (1):
      Linux 3.10.21

Greg Thelen (1):
      ipc,shm: fix shm_file deletion races

Guenter Roeck (1):
      hwmon: (lm90) Fix max6696 alarm handling

Herbert Xu (1):
      crypto: s390 - Fix aes-cbc IV corruption

Ilia Mirkin (1):
      drm/nva3-/disp: fix hda eld writing, needs to be padded

J. Bruce Fields (1):
      nfsd: return better errors to exportfs

Jani Nikula (1):
      dmi: add support for exact DMI matches in addition to substring match=
ing

Jeff Moyer (1):
      block: fix race between request completion and timeout handling

Jesper Nilsson (1):
      ipc,shm: correct error return value in shmctl (SHM_UNLOCK)

Johan Hovold (1):
      USB: mos7840: fix tiocmget error handling

Julius Werner (1):
      usb: hub: Clear Port Reset Change during init/resume

Junxiao Bi (1):
      configfs: fix race between dentry put and lookup

Kailang Yang (1):
      ALSA: hda - Add support of ALC255 codecs

Kees Cook (1):
      exec/ptrace: fix get_dumpable() incorrect tests

Kevin Hao (1):
      ftrace/x86: skip over the breakpoint for ftrace caller

Mahesh Rajashekhara (1):
      aacraid: prevent invalid pointer dereference

Markus Pargmann (1):
      can: c_can: Fix RX message handling, handle lost message before EOB

Martin Schwidefsky (1):
      s390/vtime: correct idle time calculation

Mauro Carvalho Chehab (1):
      cris: media platform drivers: fix build

Michael Neuling (1):
      powerpc/signals: Mark VSX not saved with small contexts

Mike Snitzer (1):
      block: properly stack underlying max_segment_size to DM device

Mikulas Patocka (1):
      block: fix a probe argument to blk_register_region

Mimi Zohar (1):
      Revert "ima: policy for RAMFS"

Neil Horman (1):
      crypto: ansi_cprng - Fix off by one error in non-block size request

Olivier Sobrie (1):
      can: kvaser_usb: fix usb endpoints detection

Paolo Bonzini (1):
      KVM: x86: fix emulation of "movzbl %bpl, %eax"

Peter Zijlstra (1):
      sched, idle: Fix the idle polling state logic

Prarit Bhargava (1):
      powerpc/vio: use strcpy in modalias_show

Puneet Kumar (1):
      ACPI / EC: Ensure lock is acquired before accessing ec struct members

Rafael J. Wysocki (2):
      ACPI / hotplug: Fix handle_root_bridge_removal()
      ACPI / hotplug: Do not execute "insert in progress" _OST

Rob Pearce (1):
      drm/i915: No LVDS hardware on Intel D410PT and D425KT

Stanislaw Gruszka (3):
      rt2x00: check if device is still available on rt2x00mac_flush()
      rt2x00: fix HT TX descriptor settings regression
      rt2800usb: slow down TX status polling

Steven Rostedt (1):
      perf/ftrace: Fix paranoid level for enabling function tracer

Takashi Iwai (11):
      ALSA: 6fire: Fix probe of multiple cards
      ALSA: msnd: Avoid duplicated driver name
      ALSA: hda - Enable SPDIF for Acer TravelMate 6293
      ALSA: hda - Add support for CX20952
      ALSA: hda - Add pincfg fixup for ASUS W5A
      ALSA: hda - Check keep_eapd_on before inv_eapd
      ALSA: hda - Don't turn off EAPD for headphone on Lenovo N100
      ALSA: hda - Don't clear the power state at snd_hda_codec_reset()
      ALSA: hda - Fix unbalanced runtime PM notification at resume
      ALSA: hda - Fix the headphone jack detection on Sony VAIO TX
      ALSA: hda - Provide missing pin configs for VAIO with ALC260

Thomas Renninger (1):
      x86/microcode/amd: Tone down printk(), don't treat a missing firmware=
 file as an error

Tomas Winkler (1):
      mei: nfc: fix memory leak in error path

Trond Myklebust (3):
      NFSv4: Fix a use-after-free situation in _nfs4_proc_getlk()
      NFSv4: Fix state reference counting in _nfs4_opendata_reclaim_to_nfs4=
_state
      SUNRPC: Fix a data corruption issue when retransmitting RPC calls

Vinod Koul (2):
      ALSA: compress: fix drain calls blocking other compress functions
      ALSA: compress: fix drain calls blocking other compress functions (v6)

Weston Andros Adamson (3):
      NFSv4: fix NULL dereference in open recover
      NFSv4: don't fail on missing fattr in open recover
      NFSv4: don't reprocess cached open CLAIM_PREVIOUS


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmOqJAAoJEDjbvchgkmk+HrUP/j/V6rPIHWVPH1Yuqbcmox3b
22rXTkM8vrWcelrHESQOjYs0aQc+rGuiXOcn05I4HEVBS9NdxZUXpHw7woF5088R
2r3BJx4x0cD4l/ElRFsZce6C+mWotw2XuRHkjnJbP+DOutq+0ZUotIHEw0sjqpGS
J9lPiNegcBaQ2iJYxtcCj9x+2ZWozMGlbtTNaAB14o/dMiP9L7XBRvkr+a+tNOVf
GjoSif9pGHYFhaJ4icI/1PCx/6xJlwXdaBUg9ENI7yLQFtegmeV8ta3e2fuqD89L
RnYTRAPtLPSVfu8m9Cn87PKMlfIJYP3MgOgevHl87OFVa40bsPGdH9zzeL01s8D+
N178qB2NeO5VLEO0tlEi+1GGm7CohFUSX3KYjEF7c8PuRR9Gm/Cob573JpQrh+AL
Dg9Bz4gvsEb7INQLkW3aWXLcAddb+EhG1xu6IQ7Tg9vjIiI8hdzbxiuLZhmS4d/U
k4F6C6wRTCcjYEUpJWcGFu6O7vxbF3B0AxuuWamLv+ZqXEtQbAg4d76o5abO7hkb
X2gzZL8jB/3a/CHwn68ukcqA8WkAd1zaCgej35YzpVOeLNPAzHUH/7eBxiF1m5C1
V5MFYhaytj7jD3giygILQBoOhMB/wSX3x6hcusWkZdHSqj8nz4A9I3igWuNgZjau
4MPnmLN13qnK3nntyDj6
=PNan
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
