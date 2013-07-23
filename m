Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935252Ab3GWW7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:59:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934122Ab3GWW04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:26:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 000/103] 3.10.3-stable review
Date: Tue, 23 Jul 2013 15:25:11 -0700
Message-Id: <20130723220418.532514378@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.3 release.
There are 103 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jul 25 22:01:33 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.3-rc1

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Add trace_array_get/put() to event handling

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Fix race between deleting buffer and setting events

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Get trace_array ref counts when accessing trace files

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Add trace_array_get/put() to handle instance refs better

Alexander Z Lam <azl@google.com>
    tracing: Protect ftrace_trace_arrays list in trace_events.c

Alexander Z Lam <azl@google.com>
    tracing: Make trace_marker use the correct per-instance buffer

zhangwei(Jovi) <jovi.zhangwei@huawei.com>
    tracing: Fix irqs-off tag display in syscall tracing

Steven Rostedt <rostedt@goodmis.org>
    tracing: Failed to create system directory

Peter Zijlstra <peterz@infradead.org>
    perf: Fix perf_lock_task_context() vs RCU

Jiri Olsa <jolsa@redhat.com>
    perf: Remove WARN_ON_ONCE() check in __perf_event_enable() for valid scenario

Jiri Olsa <jolsa@redhat.com>
    perf: Clone child context from parent context pmu

Takashi Iwai <tiwai@suse.de>
    staging: line6: Fix unlocked snd_pcm_stop() call

David Daney <david.daney@cavium.com>
    MIPS: Octeon: Don't clobber bootloader data structures.

Arnd Bergmann <arnd@arndb.de>
    thermal: cpu_cooling: fix stub function

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: adjust boot parameters address when INITIALIZE_XTENSA_MMU_INSIDE_VMLINUX is selected

Alex Williamson <alex.williamson@redhat.com>
    iommu/amd: Only unmap large pages from the first pte

Emil Velikov <emil.l.velikov@gmail.com>
    drm/nv50-/disp: Use output specific mask in interrupt

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nva3/disp: Fix HDMI audio regression

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add backlight quirk for hybrid mac

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix AVI infoframe generation

Marcin Slusarz <marcin.slusarz@gmail.com>
    drm/nouveau: use vmalloc for pgt allocation

Julia Lemire <jlemire@matrox.com>
    drm/mgag200: Added resolution and bandwidth limits for various G200e products.

YoungJun Cho <yj44.cho@samsung.com>
    drm/gem: fix not to assign error value to gem name

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Only clear write-domains after a successful wait-seqno

Ben Widawsky <ben@bwidawsk.net>
    drm/i915: Fix context sizes on HSW

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Fix up sdvo hpd pins for i965g/gm

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    of: Fix address decoding on Bimini and js2x machines

J. Bruce Fields <bfields@redhat.com>
    svcrpc: don't error out on small tcp fragment

J. Bruce Fields <bfields@redhat.com>
    svcrpc: fix handling of too-short rpc's

J. Bruce Fields <bfields@redhat.com>
    svcrpc: fix failures to handle -1 uid's

zhangwei(Jovi) <jovi.zhangwei@huawei.com>
    uprobes: Fix return value in error handling path

Bu, Yitian <ybu@qti.qualcomm.com>
    printk: Fix rq->lock vs logbuf_lock unlock lock inversion

Johannes Berg <johannes.berg@intel.com>
    mac80211: close AP_VLAN interfaces before unregistering all

Hauke Mehrtens <hauke@hauke-m.de>
    b43: ensue that BCMA is "y" when B43 is "y"

Luiz Capitulino <lcapitulino@redhat.com>
    virtio_balloon: leak_balloon(): only tell host if we got pages deflated

Stanislav Kinsbursky <skinsbursky@parallels.com>
    SUNRPC: fix races on PipeFS UMOUNT notifications

Stanislav Kinsbursky <skinsbursky@parallels.com>
    SUNRPC: fix races on PipeFS MOUNT notifications

Reddy, Sreekanth <Sreekanth.Reddy@lsi.com>
    SCSI: mpt2sas: Fix for issue Missing delay not getting set during system bootup

Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
    SCSI: mpt2sas: fix firmware failure with wrong task attribute

Steffen Maier <maier@linux.vnet.ibm.com>
    SCSI: zfcp: status read buffers on first adapter open with link down

Steffen Maier <maier@linux.vnet.ibm.com>
    SCSI: zfcp: block queue limits with data router

Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>
    SCSI: zfcp: fix adapter (re)open recovery while link to SAN is down

Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
    SCSI: aacraid: Fix for arrays are going offline in the system. System hangs

Martin K. Petersen <martin.petersen@oracle.com>
    SCSI: sd: Update WRITE SAME heuristics

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Do not assign noise for NULL caldata

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Fix noisefloor calibration

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k_hw: Assign default xlna config for AR9485

Gabor Juhos <juhosg@openwrt.org>
    rt2x00: rt2800lib: fix default TX power check for RT55xx

Gabor Juhos <juhosg@openwrt.org>
    rt2x00: read 5GHz TX power values from the correct offset

Baruch Siach <baruch@tkos.co.il>
    clocksource: dw_apb: Fix error check

Thomas Gleixner <tglx@linutronix.de>
    tick: Prevent uncontrolled switch to oneshot mode

Thomas Gleixner <tglx@linutronix.de>
    tick: Sanitize broadcast control logic

NeilBrown <neilb@suse.de>
    md/raid10: fix two problems with RAID10 resync.

NeilBrown <neilb@suse.de>
    md/raid10: fix two bugs affecting RAID10 reshape.

NeilBrown <neilb@suse.de>
    md/raid10: fix bug which causes all RAID10 reshapes to move no data.

Fabio Estevam <fabio.estevam@freescale.com>
    ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK

Takashi Iwai <tiwai@suse.de>
    ASoC: atmel: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ASoC: s6000: Fix unlocked snd_pcm_stop() call

Shane Huang <shane.huang@amd.com>
    i2c-piix4: Add AMD CZ SMBus device ID

Mark Langsdorf <mark.langsdorf@calxeda.com>
    sata_highbank: increase retry count but shorten duration for Calxeda controller

Seth Heasley <seth.heasley@intel.com>
    ata_piix: IDE-mode SATA patch for Intel Coleto Creek DeviceIDs

Tejun Heo <tj@kernel.org>
    libata: skip SRST for all SIMG [34]7x port-multipliers

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    libata-zpodd: must use ata_tf_init()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775) Drop unsupported fan alarm attributes for NCT6775

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775) Fix temperature alarm attributes

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ALSA: asihpi: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ALSA: atiixp: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ALSA: ua101: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ALSA: seq-oss: Initialize MIDI clients asynchronously

Aaron Plattner <aplattner@nvidia.com>
    ALSA: hda - Add new GPU codec ID to snd-hda

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix the max length of control name in generic parser

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix missing Mic Boost controls for VIA codecs

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Cache the MUX selection for generic HDMI

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix return value of snd_hda_check_power_state()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix EAPD vmaster hook for AD1884 & co

Alexandre Belloni <alexandre.belloni@free-electrons.com>
    iio: inkern: fix iio_convert_raw_to_processed_unlocked

Alexandre Belloni <alexandre.belloni@free-electrons.com>
    iio: Fix iio_channel_has_info

Will Deacon <will.deacon@arm.com>
    arm64: mm: don't treat user cache maintenance faults as writes

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    cpufreq: Revert commit 2f7021a8 to fix CPU hotplug regression

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    cpufreq: Revert commit a66b2e to fix suspend/resume regression

Michael Ellerman <michael@ellerman.id.au>
    powerpc/perf: Don't enable if we have zero events

Michael Ellerman <michael@ellerman.id.au>
    powerpc/perf: Use existing out label in power_pmu_enable()

Michael Ellerman <michael@ellerman.id.au>
    powerpc/perf: Freeze PMC5/6 if we're not using them

Michael Ellerman <michael@ellerman.id.au>
    powerpc/perf: Rework disable logic in pmu_disable()

Michael Ellerman <michael@ellerman.id.au>
    powerpc/perf: Check that events only include valid bits on Power8

Nathan Fontenot <nfont@linux.vnet.ibm.com>
    powerpc/numa: Do not update sysfs cpu registration from invalid context

Chen Gang <gang.chen@asianux.com>
    powerpc/smp: Section mismatch from smp_release_cpus to __initdata spinning_secondaries

Michael Ellerman <michael@ellerman.id.au>
    powerpc: Wire up the HV facility unavailable exception

Michael Ellerman <michaele@au1.ibm.com>
    powerpc: Rename and flesh out the facility unavailable exception handler

Michael Ellerman <michael@ellerman.id.au>
    powerpc: Remove KVMTEST from RELON exception handlers

Michael Ellerman <michael@ellerman.id.au>
    powerpc: Remove unreachable relocation on exception handlers

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix return of active 64bit signals

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix return of 32bit rt signals to active transactions

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix restoration of MSR on 32bit signal return

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix 32 bit non-rt signals

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix writing top half of MSR on 32 bit signals

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/powernv: Fix iommu initialization again

Michael Neuling <mikey@neuling.org>
    powerpc/hw_brk: Fix off by one error when validating DAWR region end

Michael Neuling <mikey@neuling.org>
    powerpc/hw_brk: Fix clearing of extraneous IRQ

Michael Neuling <mikey@neuling.org>
    powerpc/hw_brk: Fix setting of length for exact mode breakpoints


-------------

Diffstat:

 Documentation/i2c/busses/i2c-piix4                 |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/mm/fault.c                              |  46 ++---
 arch/mips/cavium-octeon/setup.c                    |   2 +-
 arch/powerpc/include/asm/exception-64s.h           |   8 +-
 arch/powerpc/include/asm/reg.h                     |   1 +
 arch/powerpc/kernel/exceptions-64s.S               |  56 +++---
 arch/powerpc/kernel/hw_breakpoint.c                |   3 +-
 arch/powerpc/kernel/ptrace.c                       |   4 +-
 arch/powerpc/kernel/setup_64.c                     |   2 +-
 arch/powerpc/kernel/signal_32.c                    |  70 +++++--
 arch/powerpc/kernel/signal_64.c                    |   8 +-
 arch/powerpc/kernel/traps.c                        |  41 +++-
 arch/powerpc/mm/numa.c                             |   5 +-
 arch/powerpc/perf/core-book3s.c                    |  46 +++--
 arch/powerpc/perf/power8-pmu.c                     |  17 ++
 arch/powerpc/platforms/powernv/pci-ioda.c          |  21 +++
 arch/xtensa/kernel/head.S                          |   9 +
 arch/xtensa/kernel/setup.c                         |   6 +-
 drivers/ata/ata_piix.c                             |   2 +
 drivers/ata/libata-pmp.c                           |  33 ++--
 drivers/ata/libata-zpodd.c                         |   7 +-
 drivers/ata/sata_highbank.c                        |  20 +-
 drivers/clocksource/dw_apb_timer_of.c              |   2 +-
 drivers/cpufreq/cpufreq.c                          |   4 +-
 drivers/cpufreq/cpufreq_governor.c                 |   3 -
 drivers/cpufreq/cpufreq_stats.c                    |   6 +-
 drivers/gpu/drm/drm_gem.c                          |  18 +-
 drivers/gpu/drm/i915/i915_gem.c                    |   3 +-
 drivers/gpu/drm/i915/i915_gem_context.c            |   2 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  13 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  28 ++-
 drivers/gpu/drm/mgag200/mgag200_drv.h              |   3 +-
 drivers/gpu/drm/mgag200/mgag200_main.c             |   2 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |  70 ++++++-
 .../gpu/drm/nouveau/core/engine/disp/hdminva3.c    |   4 +
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |   6 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c      |   6 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   7 +
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |  11 +-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |  11 +-
 drivers/hwmon/nct6775.c                            |  92 ++++++---
 drivers/i2c/busses/Kconfig                         |   1 +
 drivers/i2c/busses/i2c-piix4.c                     |   3 +-
 drivers/iio/inkern.c                               |   2 +-
 drivers/iommu/amd_iommu.c                          |   6 +-
 drivers/md/raid10.c                                |  24 ++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   2 +
 drivers/net/wireless/ath/ath9k/calib.c             |   1 -
 drivers/net/wireless/ath/ath9k/hw.c                |   3 +-
 drivers/net/wireless/ath/ath9k/main.c              |   7 -
 drivers/net/wireless/b43/Kconfig                   |   4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |   6 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |   3 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |   3 +-
 drivers/of/address.c                               |   8 +-
 drivers/s390/scsi/zfcp_aux.c                       |   5 +-
 drivers/s390/scsi/zfcp_fsf.c                       |  27 ++-
 drivers/s390/scsi/zfcp_scsi.c                      |  10 +-
 drivers/scsi/aacraid/src.c                         |   3 +
 drivers/scsi/mpt2sas/mpt2sas_base.c                |  13 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h                |   3 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |  14 +-
 drivers/scsi/scsi.c                                |   8 +-
 drivers/scsi/sd.c                                  |  46 +++--
 drivers/scsi/sd.h                                  |   1 +
 drivers/staging/line6/pcm.c                        |   5 +-
 drivers/virtio/virtio_balloon.c                    |   3 +-
 include/linux/cpu_cooling.h                        |   4 +-
 include/linux/iio/iio.h                            |   4 +-
 kernel/events/core.c                               |  28 ++-
 kernel/printk.c                                    |   2 +-
 kernel/time/tick-broadcast.c                       |  80 ++++++--
 kernel/time/tick-common.c                          |   3 +-
 kernel/trace/trace.c                               | 209 ++++++++++++++++++---
 kernel/trace/trace.h                               |   5 +
 kernel/trace/trace_events.c                        | 130 +++++++++++--
 kernel/trace/trace_syscalls.c                      |  21 ++-
 kernel/trace/trace_uprobe.c                        |   4 +-
 net/mac80211/iface.c                               |   9 +
 net/sunrpc/clnt.c                                  |  31 +--
 net/sunrpc/rpc_pipe.c                              |   5 +-
 net/sunrpc/svcauth_unix.c                          |   2 -
 net/sunrpc/svcsock.c                               |   9 +-
 sound/arm/pxa2xx-pcm-lib.c                         |   2 +
 sound/core/seq/oss/seq_oss_init.c                  |  16 +-
 sound/core/seq/oss/seq_oss_midi.c                  |   2 +-
 sound/pci/asihpi/asihpi.c                          |   3 +
 sound/pci/atiixp.c                                 |   2 +
 sound/pci/atiixp_modem.c                           |   2 +
 sound/pci/hda/hda_generic.c                        |   2 +-
 sound/pci/hda/hda_local.h                          |  10 +-
 sound/pci/hda/patch_analog.c                       |  12 +-
 sound/pci/hda/patch_hdmi.c                         |   4 +-
 sound/pci/hda/patch_via.c                          |   2 +
 sound/soc/atmel/atmel-pcm-dma.c                    |   2 +
 sound/soc/codecs/sgtl5000.h                        |   2 +-
 sound/soc/s6000/s6000-pcm.c                        |   2 +
 sound/usb/6fire/pcm.c                              |  12 +-
 sound/usb/misc/ua101.c                             |  14 +-
 sound/usb/usx2y/usbusx2yaudio.c                    |   4 +
 102 files changed, 1134 insertions(+), 428 deletions(-)


