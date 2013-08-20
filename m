Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3HTP7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:59:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3HTP7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:59:02 -0400
Date: Tue, 20 Aug 2013 09:00:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.8
Message-ID: <20130820160052.GA21673@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.8 kernel.

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

 Makefile                                      |    2 -
 arch/Kconfig                                  |    6 +++
 arch/arm/include/asm/kvm_asm.h                |   22 +++++++------
 arch/arm/include/asm/tlb.h                    |    7 +++-
 arch/arm/kernel/perf_event.c                  |   10 +++++-
 arch/arm/kvm/coproc.c                         |    4 ++
 arch/arm/kvm/interrupts.S                     |   16 +++++++++-
 arch/arm/kvm/interrupts_head.S                |   10 +++++-
 arch/arm64/include/asm/tlb.h                  |    7 +++-
 arch/ia64/include/asm/tlb.h                   |    9 +++--
 arch/m68k/emu/natfeat.c                       |   23 ++++++++++++--
 arch/m68k/include/asm/div64.h                 |    9 +++--
 arch/microblaze/Kconfig                       |    2 -
 arch/s390/include/asm/tlb.h                   |    8 +++--
 arch/sh/include/asm/tlb.h                     |    6 ++-
 arch/um/include/asm/tlb.h                     |    6 ++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    4 +-
 arch/x86/kernel/sys_x86_64.c                  |    2 -
 arch/x86/mm/mmap.c                            |    2 -
 block/cfq-iosched.c                           |   17 ++++++++--
 block/deadline-iosched.c                      |   16 ++++++++--
 block/elevator.c                              |   25 +++------------
 block/noop-iosched.c                          |   17 ++++++++--
 drivers/net/can/usb/peak_usb/pcan_usb.c       |    2 -
 drivers/net/wireless/iwlegacy/4965-mac.c      |   16 +++++-----
 drivers/net/wireless/iwlegacy/common.c        |    1=20
 drivers/usb/core/quirks.c                     |    6 +++
 drivers/usb/host/ehci-sched.c                 |   13 +++-----
 drivers/usb/serial/keyspan.c                  |    2 -
 drivers/usb/serial/mos7720.c                  |   21 ++++++++-----
 drivers/usb/serial/mos7840.c                  |    2 -
 drivers/usb/serial/ti_usb_3410_5052.c         |    9 +++--
 drivers/usb/serial/usb_wwan.c                 |   20 ++++++------
 drivers/usb/wusbcore/wa-xfer.c                |    9 ++++-
 fs/exec.c                                     |    4 +-
 fs/ext4/ext4_jbd2.c                           |    8 ++---
 fs/proc/task_mmu.c                            |    8 ++---
 include/asm-generic/tlb.h                     |    2 -
 include/linux/elevator.h                      |    6 +++
 include/linux/sched.h                         |    1=20
 include/linux/syscalls.h                      |    5 +++
 kernel/cpuset.c                               |    6 ++-
 kernel/fork.c                                 |    6 +++
 kernel/power/qos.c                            |   13 +++++++-
 kernel/sched/fair.c                           |    1=20
 mm/hugetlb.c                                  |    2 -
 mm/memcontrol.c                               |    4 +-
 mm/memory.c                                   |   36 +++++++++++++---------
 mm/mmap.c                                     |    4 +-
 net/mac80211/mlme.c                           |   39 +++++++++++++++------=
---
 net/netlink/genetlink.c                       |    7 ++++
 net/wireless/core.c                           |    1=20
 net/wireless/nl80211.c                        |    6 ++-
 sound/pci/hda/hda_generic.c                   |    6 +--
 sound/pci/hda/patch_realtek.c                 |   11 ++++++
 sound/soc/codecs/cs42l52.c                    |    2 -
 sound/soc/soc-dapm.c                          |    7 ++--
 sound/soc/tegra/tegra30_i2s.c                 |    2 -
 sound/usb/6fire/midi.c                        |   16 +++++++++-
 sound/usb/6fire/midi.h                        |    6 ---
 sound/usb/6fire/pcm.c                         |   41 +++++++++++++++++++++=
++++-
 sound/usb/6fire/pcm.h                         |    2 -
 sound/usb/mixer.c                             |    1=20
 63 files changed, 405 insertions(+), 179 deletions(-)

Alan Stern (1):
      USB: EHCI: accept very late isochronous URBs

Andreas Schwab (1):
      m68k: Truncate base in do_div()

Andrey Vagin (1):
      memcg: don't initialize kmem-cache destroying work for root caches

Brian Austin (1):
      ASoC: cs42l52: Reorder Min/Max and update to SX_TLV for Beep Volume

Chris Wright (1):
      mac80211: fix infinite loop in ieee80211_determine_chantype

Geert Uytterhoeven (1):
      m68k/atari: ARAnyM - Fix NatFeat module support

Greg Kroah-Hartman (1):
      Linux 3.10.8

Guenter Roeck (1):
      s390: Fix broken build

Jan Kara (1):
      jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()

Jianpeng Ma (1):
      elevator: Fix a race in elevator switching

Johan Hovold (4):
      USB: ti_usb_3410_5052: fix big-endian firmware handling
      USB: mos7840: fix big-endian probe
      USB: mos7720: fix broken control requests
      USB: keyspan: fix null-deref at disconnect and release

Johannes Berg (5):
      mac80211: ignore HT primary channel while connected
      mac80211: continue using disabled channels while connected
      genetlink: fix family dump race
      cfg80211: fix P2P GO interface teardown
      nl80211: fix another nl80211_fam.attrbuf race

Lars-Peter Clausen (1):
      ASoC: dapm: Fix empty list check in dapm_new_mux()

Li Zefan (1):
      cpuset: fix the return value of cpuset_write_u64()

Linus Torvalds (1):
      Fix TLB gather virtual address range invalidation corner cases

Maksim A. Boyko (1):
      ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam=
 C525

Marc Zyngier (3):
      ARM: KVM: perform save/restore of PAR
      ARM: KVM: add missing dsb before invalidating Stage-2 TLBs
      ARM: KVM: clear exclusive monitor on all exception returns

Matt Burtch (1):
      USB-Serial: Fix error handling of usb_wwan

Michal Simek (1):
      microblaze: fix clone syscall

Oliver Neukum (1):
      usb: add two quirky touchscreen

Peter Zijlstra (1):
      sched: Ensure update_cfs_shares() is called for parents of continuous=
ly-running tasks

Radu Caragea (1):
      x86 get_unmapped_area(): use proper mmap base for bottom-up direction

Stanislaw Gruszka (2):
      iwl4965: set power mode early
      iwl4965: reset firmware after rfkill off

Stephane Grosjean (1):
      can: pcan_usb: fix wrong memcpy() bytes length

Stephen Boyd (2):
      perf/arm: Fix armpmu_map_hw_event()
      PM / QoS: Fix workqueue deadlock when using pm_qos_update_request_tim=
eout()

Stephen Warren (1):
      ASoC: tegra: fix Tegra30 I2S capture parameter setup

Takashi Iwai (3):
      ALSA: hda - Fix missing mute controls for CX5051
      ALSA: hda - Add pinfix for LG LW25 laptop
      ALSA: hda - Add a fixup for Gateway LT27

Thomas Pugliese (1):
      wusbcore: fix kernel panic when disconnecting a wireless USB->serial =
device

Torsten Schenk (2):
      ALSA: 6fire: make buffers DMA-able (pcm)
      ALSA: 6fire: make buffers DMA-able (midi)

Vince Weaver (1):
      perf/x86: Fix intel QPI uncore event definitions

Will Deacon (1):
      ARM: 7809/1: perf: fix event validation for software group leaders

yonghua zheng (1):
      fs/proc/task_mmu.c: fix buffer overflow in add_page_map()


--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSE5KzAAoJEDjbvchgkmk+LbMP/3isrhzlqOxrsWREtTasaZe+
ZDYeIxS8EHrhBV3bCIuHPQYbIeL0OWgEFpLHK4r/3NYJhTPaKe0IRt+maquKa+W+
QvTzcYpPzj8U98OhT+j8VZfxE9/Axi+p5uz/t29F/FZ6ZtruRxTiVkphLFiv52h7
lPShePUGMUU3ehkJfGJm26i8lm1NURX81jM1LTDv2QyHUZWxzjkcPKEnKXB+4bm8
pO7Vm7aHeP2ZbUQ1pB6Ax53nKbV42PnXzqHemxDlHhQHPhwK0cLlQWe26KwWpHy5
mW4csAv3vCzL0yO/GQvQgynVvtmOLPbdzTaKreYLMxn8vm4mm9PtHKw/boXtDzxL
POaUk4ulj/k/2rLu7h4JBj4hD5avI4g89NkjwSrlpEX1wnDZzga1tDTv8CdJv7rb
/8Epz8wYqKNi3BqlL5J+/Spc4Kjlr5rm2gqcsyiGo6UBE7PUklP3CNlv/hMlAbt3
WrN5IkgchLJz4q4VeV871yKfxl7hP4Cm/ntkE5dJiXYwNeVXoeNEU+zG0ptrBVX3
+xt9T0jZBnSjujqbH9LZaNUfmXV2cdQq7VCh4h71uPaXHK6Og9c+/Tl5m/FegjCr
e/5BQ+5nnFLoU3ar+UNi/oBZYno3TtT5sIY2iC4bznCoacD0cbx9VMk0kcUU3295
WdZYTGA/T9Qs6rrUDXZd
=6DJq
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
