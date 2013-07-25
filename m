Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab3GYWW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 18:22:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab3GYWWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 18:22:22 -0400
Date: Thu, 25 Jul 2013 15:22:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.3
Message-ID: <20130725222221.GA32230@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.3 kernel.

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

 Documentation/i2c/busses/i2c-piix4                  |    2=20
 Makefile                                            |    2=20
 arch/arm64/mm/fault.c                               |   46 +---
 arch/mips/cavium-octeon/setup.c                     |    2=20
 arch/powerpc/include/asm/exception-64s.h            |    8=20
 arch/powerpc/include/asm/reg.h                      |    1=20
 arch/powerpc/kernel/exceptions-64s.S                |   56 ++---
 arch/powerpc/kernel/hw_breakpoint.c                 |    3=20
 arch/powerpc/kernel/ptrace.c                        |    4=20
 arch/powerpc/kernel/setup_64.c                      |    2=20
 arch/powerpc/kernel/signal_32.c                     |   70 +++++-
 arch/powerpc/kernel/signal_64.c                     |    8=20
 arch/powerpc/kernel/traps.c                         |   41 +++
 arch/powerpc/mm/numa.c                              |    5=20
 arch/powerpc/perf/core-book3s.c                     |   46 ++--
 arch/powerpc/perf/power8-pmu.c                      |   17 +
 arch/powerpc/platforms/powernv/pci-ioda.c           |   21 ++
 arch/xtensa/kernel/head.S                           |    9=20
 arch/xtensa/kernel/setup.c                          |    6=20
 drivers/ata/ata_piix.c                              |    2=20
 drivers/ata/libata-pmp.c                            |   33 +--
 drivers/ata/libata-zpodd.c                          |    7=20
 drivers/ata/sata_highbank.c                         |   20 +
 drivers/clocksource/dw_apb_timer_of.c               |    2=20
 drivers/cpufreq/cpufreq.c                           |    4=20
 drivers/cpufreq/cpufreq_governor.c                  |    3=20
 drivers/cpufreq/cpufreq_stats.c                     |    6=20
 drivers/gpu/drm/drm_gem.c                           |   18 -
 drivers/gpu/drm/i915/i915_gem.c                     |    3=20
 drivers/gpu/drm/i915/i915_gem_context.c             |    2=20
 drivers/gpu/drm/i915/i915_irq.c                     |   13 -
 drivers/gpu/drm/i915/i915_reg.h                     |   28 +-
 drivers/gpu/drm/mgag200/mgag200_drv.h               |    3=20
 drivers/gpu/drm/mgag200/mgag200_main.c              |    2=20
 drivers/gpu/drm/mgag200/mgag200_mode.c              |   70 ++++++
 drivers/gpu/drm/nouveau/core/engine/disp/hdminva3.c |    4=20
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c     |    6=20
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c       |    6=20
 drivers/gpu/drm/radeon/atombios_encoders.c          |    7=20
 drivers/gpu/drm/radeon/evergreen_hdmi.c             |   11 -
 drivers/gpu/drm/radeon/r600_hdmi.c                  |   11 -
 drivers/hwmon/nct6775.c                             |   92 ++++++--
 drivers/i2c/busses/Kconfig                          |    1=20
 drivers/i2c/busses/i2c-piix4.c                      |    3=20
 drivers/iio/inkern.c                                |    2=20
 drivers/iommu/amd_iommu.c                           |    6=20
 drivers/md/raid10.c                                 |   24 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c      |    8=20
 drivers/net/wireless/ath/ath9k/ar9003_phy.h         |    2=20
 drivers/net/wireless/ath/ath9k/calib.c              |    1=20
 drivers/net/wireless/ath/ath9k/hw.c                 |    3=20
 drivers/net/wireless/ath/ath9k/main.c               |    7=20
 drivers/net/wireless/b43/Kconfig                    |    4=20
 drivers/net/wireless/rt2x00/rt2800lib.c             |    6=20
 drivers/net/wireless/rt2x00/rt61pci.c               |    3=20
 drivers/net/wireless/rt2x00/rt73usb.c               |    3=20
 drivers/of/address.c                                |    8=20
 drivers/s390/scsi/zfcp_aux.c                        |    5=20
 drivers/s390/scsi/zfcp_fsf.c                        |   27 +-
 drivers/s390/scsi/zfcp_scsi.c                       |   10=20
 drivers/scsi/aacraid/src.c                          |    3=20
 drivers/scsi/mpt2sas/mpt2sas_base.c                 |   13 -
 drivers/scsi/mpt2sas/mpt2sas_base.h                 |    3=20
 drivers/scsi/mpt2sas/mpt2sas_scsih.c                |   14 -
 drivers/scsi/scsi.c                                 |    8=20
 drivers/scsi/sd.c                                   |   46 +++-
 drivers/scsi/sd.h                                   |    1=20
 drivers/staging/line6/pcm.c                         |    5=20
 drivers/virtio/virtio_balloon.c                     |    3=20
 include/linux/cpu_cooling.h                         |    4=20
 include/linux/iio/iio.h                             |    4=20
 kernel/events/core.c                                |   28 ++
 kernel/printk.c                                     |    2=20
 kernel/time/tick-broadcast.c                        |   80 ++++++-
 kernel/time/tick-common.c                           |    3=20
 kernel/trace/trace.c                                |  209 +++++++++++++++=
++---
 kernel/trace/trace.h                                |    5=20
 kernel/trace/trace_events.c                         |  130 ++++++++++--
 kernel/trace/trace_syscalls.c                       |   21 +-
 kernel/trace/trace_uprobe.c                         |    4=20
 net/mac80211/iface.c                                |    9=20
 net/sunrpc/svcauth_unix.c                           |    2=20
 net/sunrpc/svcsock.c                                |    9=20
 sound/arm/pxa2xx-pcm-lib.c                          |    2=20
 sound/core/seq/oss/seq_oss_init.c                   |   16 +
 sound/core/seq/oss/seq_oss_midi.c                   |    2=20
 sound/pci/asihpi/asihpi.c                           |    3=20
 sound/pci/atiixp.c                                  |    2=20
 sound/pci/atiixp_modem.c                            |    2=20
 sound/pci/hda/hda_generic.c                         |    2=20
 sound/pci/hda/hda_local.h                           |   10=20
 sound/pci/hda/patch_analog.c                        |   12 -
 sound/pci/hda/patch_hdmi.c                          |    4=20
 sound/pci/hda/patch_via.c                           |    2=20
 sound/soc/atmel/atmel-pcm-dma.c                     |    2=20
 sound/soc/codecs/sgtl5000.h                         |    2=20
 sound/soc/s6000/s6000-pcm.c                         |    2=20
 sound/usb/6fire/pcm.c                               |   12 -
 sound/usb/misc/ua101.c                              |   14 +
 sound/usb/usx2y/usbusx2yaudio.c                     |    4=20
 100 files changed, 1113 insertions(+), 411 deletions(-)

Aaron Plattner (1):
      ALSA: hda - Add new GPU codec ID to snd-hda

Alex Deucher (2):
      drm/radeon: fix AVI infoframe generation
      drm/radeon: add backlight quirk for hybrid mac

Alex Williamson (1):
      iommu/amd: Only unmap large pages from the first pte

Alexander Z Lam (2):
      tracing: Make trace_marker use the correct per-instance buffer
      tracing: Protect ftrace_trace_arrays list in trace_events.c

Alexandre Belloni (2):
      iio: Fix iio_channel_has_info
      iio: inkern: fix iio_convert_raw_to_processed_unlocked

Arnd Bergmann (1):
      thermal: cpu_cooling: fix stub function

Baruch Siach (1):
      clocksource: dw_apb: Fix error check

Ben Widawsky (1):
      drm/i915: Fix context sizes on HSW

Benjamin Herrenschmidt (2):
      powerpc/powernv: Fix iommu initialization again
      of: Fix address decoding on Bimini and js2x machines

Bu, Yitian (1):
      printk: Fix rq->lock vs logbuf_lock unlock lock inversion

Chen Gang (1):
      powerpc/smp: Section mismatch from smp_release_cpus to __initdata spi=
nning_secondaries

Chris Wilson (1):
      drm/i915: Only clear write-domains after a successful wait-seqno

Daniel Hansel (1):
      SCSI: zfcp: fix adapter (re)open recovery while link to SAN is down

Daniel Vetter (1):
      drm/i915: Fix up sdvo hpd pins for i965g/gm

David Daney (1):
      MIPS: Octeon: Don't clobber bootloader data structures.

Emil Velikov (1):
      drm/nv50-/disp: Use output specific mask in interrupt

Fabio Estevam (1):
      ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK

Gabor Juhos (2):
      rt2x00: read 5GHz TX power values from the correct offset
      rt2x00: rt2800lib: fix default TX power check for RT55xx

Greg Kroah-Hartman (1):
      Linux 3.10.3

Guenter Roeck (2):
      hwmon: (nct6775) Fix temperature alarm attributes
      hwmon: (nct6775) Drop unsupported fan alarm attributes for NCT6775

Hauke Mehrtens (1):
      b43: ensue that BCMA is "y" when B43 is "y"

Ilia Mirkin (1):
      drm/nva3/disp: Fix HDMI audio regression

J. Bruce Fields (3):
      svcrpc: fix failures to handle -1 uid's
      svcrpc: fix handling of too-short rpc's
      svcrpc: don't error out on small tcp fragment

Jiri Olsa (2):
      perf: Clone child context from parent context pmu
      perf: Remove WARN_ON_ONCE() check in __perf_event_enable() for valid =
scenario

Johannes Berg (1):
      mac80211: close AP_VLAN interfaces before unregistering all

Julia Lemire (1):
      drm/mgag200: Added resolution and bandwidth limits for various G200e =
products.

Luiz Capitulino (1):
      virtio_balloon: leak_balloon(): only tell host if we got pages deflat=
ed

Mahesh Rajashekhara (1):
      SCSI: aacraid: Fix for arrays are going offline in the system. System=
 hangs

Marcin Slusarz (1):
      drm/nouveau: use vmalloc for pgt allocation

Mark Langsdorf (1):
      sata_highbank: increase retry count but shorten duration for Calxeda =
controller

Martin K. Petersen (1):
      SCSI: sd: Update WRITE SAME heuristics

Max Filippov (1):
      xtensa: adjust boot parameters address when INITIALIZE_XTENSA_MMU_INS=
IDE_VMLINUX is selected

Michael Ellerman (9):
      powerpc: Remove unreachable relocation on exception handlers
      powerpc: Remove KVMTEST from RELON exception handlers
      powerpc: Rename and flesh out the facility unavailable exception hand=
ler
      powerpc: Wire up the HV facility unavailable exception
      powerpc/perf: Check that events only include valid bits on Power8
      powerpc/perf: Rework disable logic in pmu_disable()
      powerpc/perf: Freeze PMC5/6 if we're not using them
      powerpc/perf: Use existing out label in power_pmu_enable()
      powerpc/perf: Don't enable if we have zero events

Michael Neuling (8):
      powerpc/hw_brk: Fix setting of length for exact mode breakpoints
      powerpc/hw_brk: Fix clearing of extraneous IRQ
      powerpc/hw_brk: Fix off by one error when validating DAWR region end
      powerpc/tm: Fix writing top half of MSR on 32 bit signals
      powerpc/tm: Fix 32 bit non-rt signals
      powerpc/tm: Fix restoration of MSR on 32bit signal return
      powerpc/tm: Fix return of 32bit rt signals to active transactions
      powerpc/tm: Fix return of active 64bit signals

Nathan Fontenot (1):
      powerpc/numa: Do not update sysfs cpu registration from invalid conte=
xt

NeilBrown (3):
      md/raid10: fix bug which causes all RAID10 reshapes to move no data.
      md/raid10: fix two bugs affecting RAID10 reshape.
      md/raid10: fix two problems with RAID10 resync.

Peter Zijlstra (1):
      perf: Fix perf_lock_task_context() vs RCU

Reddy, Sreekanth (1):
      SCSI: mpt2sas: Fix for issue Missing delay not getting set during sys=
tem bootup

Sergei Shtylyov (1):
      libata-zpodd: must use ata_tf_init()

Seth Heasley (1):
      ata_piix: IDE-mode SATA patch for Intel Coleto Creek DeviceIDs

Shane Huang (1):
      i2c-piix4: Add AMD CZ SMBus device ID

Sreekanth Reddy (1):
      SCSI: mpt2sas: fix firmware failure with wrong task attribute

Srivatsa S. Bhat (2):
      cpufreq: Revert commit a66b2e to fix suspend/resume regression
      cpufreq: Revert commit 2f7021a8 to fix CPU hotplug regression

Steffen Maier (2):
      SCSI: zfcp: block queue limits with data router
      SCSI: zfcp: status read buffers on first adapter open with link down

Steven Rostedt (1):
      tracing: Failed to create system directory

Steven Rostedt (Red Hat) (4):
      tracing: Add trace_array_get/put() to handle instance refs better
      tracing: Get trace_array ref counts when accessing trace files
      tracing: Fix race between deleting buffer and setting events
      tracing: Add trace_array_get/put() to event handling

Sujith Manoharan (3):
      ath9k_hw: Assign default xlna config for AR9485
      ath9k: Fix noisefloor calibration
      ath9k: Do not assign noise for NULL caldata

Takashi Iwai (15):
      ALSA: hda - Fix EAPD vmaster hook for AD1884 & co
      ALSA: hda - Fix return value of snd_hda_check_power_state()
      ALSA: hda - Cache the MUX selection for generic HDMI
      ALSA: hda - Fix missing Mic Boost controls for VIA codecs
      ALSA: hda - Fix the max length of control name in generic parser
      ALSA: seq-oss: Initialize MIDI clients asynchronously
      ALSA: 6fire: Fix unlocked snd_pcm_stop() call
      ALSA: ua101: Fix unlocked snd_pcm_stop() call
      ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call
      ALSA: atiixp: Fix unlocked snd_pcm_stop() call
      ALSA: asihpi: Fix unlocked snd_pcm_stop() call
      ALSA: usx2y: Fix unlocked snd_pcm_stop() call
      ASoC: s6000: Fix unlocked snd_pcm_stop() call
      ASoC: atmel: Fix unlocked snd_pcm_stop() call
      staging: line6: Fix unlocked snd_pcm_stop() call

Tejun Heo (1):
      libata: skip SRST for all SIMG [34]7x port-multipliers

Thomas Gleixner (2):
      tick: Sanitize broadcast control logic
      tick: Prevent uncontrolled switch to oneshot mode

Will Deacon (1):
      arm64: mm: don't treat user cache maintenance faults as writes

YoungJun Cho (1):
      drm/gem: fix not to assign error value to gem name

zhangwei(Jovi) (2):
      uprobes: Fix return value in error handling path
      tracing: Fix irqs-off tag display in syscall tracing


--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJR8aUdAAoJEDjbvchgkmk+KqEP/23pUJZrJBkG/0BeNYBIVCNq
uFFwqwVwthqBuVjka6BLJ9+ZpR8yJqU95mx97nWAIlV6PTkbPhfk8d+h7uuRSXnz
C952TM4zJ8b+/osaCKIwkFc9LYMyi320k0C4I6R1e3L0vZeHbsurxznBWyd+eCXx
AZU1F5iG6LYk6yhll10lGoY1SOikdppAhFjaX/A1qw2gZDHFSlp5CMKA7A1VqzIb
b1Ena/LZF11W0ZbHHebgQNZQ/8ohc8+xw5PU29341PTGgvF+/kV18r8y9cmBSDB0
oPjHUzewdxlIabNy7ChtugyYhkseTG6Bzwptz9IhEBfC9oijW1xRk4TNtCDlph4A
lJ8UF/cu9DgzgiRH2obiHBb9YXjxwoW9n93fznmqTwMUpCPOWn0qk/Gh0XYa906c
hE9RpIfXMH3XR7tCjZN/Xjxmw7q/vqPRislgchjDDPXIqNHNRwaKNsnj/gJkY0DL
gcVWVb/7ULdE+U7SFThduHhWkvsixpYXtQ/IZV0b6xFtbr18TwsnnPY+fNTLOCz+
RoTsiTsasIvLEeYUy/jN/SV+FWEZjBQbWX5Y+pkK4K5/FFjm32hEWDXftmyKvqwE
Yuoom2hnBHL606fktFAIHJH6HmXg//SuLhfczujahgYF6IkI9dNQa4+a/1kT0cxF
AF5ZSM+F2SNIcxDVzvSy
=nMAD
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
