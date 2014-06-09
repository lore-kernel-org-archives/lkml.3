Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934440AbaFIXDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:03:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933879AbaFIWpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/40] 3.10.43-stable review
Date: Mon,  9 Jun 2014 15:48:31 -0700
Message-Id: <20140609224839.127615063@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.43 release.
There are 40 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jun 11 22:48:25 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.43-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.43-rc1

Sergey Popovich <popovich_sergei@mail.ru>
    netfilter: Fix potential use after free in ip6_route_me_harder()

Will Deacon <will.deacon@arm.com>
    ARM: perf: hook up perf_sample_event_took around pmu irq handling

Knut Petersen <Knut_Petersen@t-online.de>
    perf: Enforce 1 as lower limit for perf_event_max_sample_rate

Stephane Eranian <eranian@google.com>
    perf: Fix interrupt handler timing harness

Dave Hansen <dave.hansen@linux.intel.com>
    perf: Drop sample rate when sampling is too slow

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Add missing target_put_sess_cmd for ImmedateData failure

Andrey Ryabinin <a.ryabinin@samsung.com>
    mm: rmap: fix use-after-free in __put_anon_vma

Alan Stern <stern@rowland.harvard.edu>
    USB: Avoid runtime suspend loops for HCDs that can't handle suspend/resume

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix firmware download on big-endian machines (part 2)

Alexej Starschenko <starschenko@gmail.com>
    USB: serial: option: add support for Novatel E371 PCIe card

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: cdc-wdm: properly include types.h

Bjørn Mork <bjorn@mork.no>
    usb: cdc-wdm: export cdc-wdm uapi header

George McCollister <george.mccollister@gmail.com>
    USB: ftdi_sio: add NovaTech OrionLXm product ID

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup

Ronan Marquet <ronan.marquet@orange.fr>
    ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_daq_700: add mux settling delay

Ben Hutchings <ben@decadent.org.uk>
    Staging: speakup: Move pasting into a work item

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: delete endpoints from bandwidth list before freeing whole device

NeilBrown <neilb@suse.de>
    md: always set MD_RECOVERY_INTR when interrupting a reshape thread.

NeilBrown <neilb@suse.de>
    md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Only copy back the modified fields to userspace from execbuffer

Lai Jiangshan <laijs@cn.fujitsu.com>
    sched: Fix hotplug vs. set_cpus_allowed_ptr()

Heinz Mauelshagen <heinzm@redhat.com>
    dm cache: always split discards on cache block boundaries

Andrey Ryabinin <a.ryabinin@samsung.com>
    ARM: 8051/1: put_user: fix possible data corruption in put_user

Santosh Shilimkar <santosh.shilimkar@ti.com>
    ARM: OMAP4: Fix the boot regression with CPU_IDLE enabled

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms

Emil Goode <emilgoode@gmail.com>
    ARM: imx: fix error handling in ipu device registration

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: handle non-VGA class pci devices with ATRM

Christian König <christian.koenig@amd.com>
    drm/radeon: also try GART for CPU accessed buffers

Ben Skeggs <bskeggs@redhat.com>
    drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup

Jean Delvare <jdelvare@suse.de>
    hwmon: (ntc_thermistor) Fix OF device ID mapping

Jean Delvare <jdelvare@suse.de>
    hwmon: (ntc_thermistor) Fix dependencies

Johannes Berg <johannes.berg@intel.com>
    Documentation: fix DOCBOOKS=... building

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm/memory-failure.c: fix memory leak by race between poison and unpoison

David Ahern <dsahern@gmail.com>
    perf evsel: Fix printing of perf_event_paranoid message

Peter Zijlstra <peterz@infradead.org>
    perf: Fix race in removing an event

Peter Zijlstra <peterz@infradead.org>
    perf: Limit perf_event_attr::sample_period to 63 bits

Jiri Olsa <jolsa@redhat.com>
    perf: Prevent false warning in perf_swevent_add

Thomas Gleixner <tglx@linutronix.de>
    sched: Sanitize irq accounting madness

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check


-------------

Diffstat:

 Documentation/DocBook/media/Makefile            |   2 +-
 Documentation/sysctl/kernel.txt                 |  26 ++++
 Makefile                                        |   4 +-
 arch/arm/include/asm/uaccess.h                  |   3 +-
 arch/arm/kernel/perf_event.c                    |  11 +-
 arch/arm/mach-imx/devices/platform-ipu-core.c   |   2 +-
 arch/arm/mach-omap2/cclock3xxx_data.c           |   3 +-
 arch/arm/mach-omap2/cpuidle44xx.c               |  25 +++-
 arch/x86/kernel/cpu/perf_event.c                |  12 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c      |  54 ++++----
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c |   2 +-
 drivers/gpu/drm/radeon/radeon_bios.c            |  14 +++
 drivers/gpu/drm/radeon/radeon_object.c          |  38 +++---
 drivers/hwmon/Kconfig                           |   2 +-
 drivers/hwmon/ntc_thermistor.c                  |  15 ++-
 drivers/infiniband/ulp/isert/ib_isert.c         |   2 +
 drivers/md/dm-cache-target.c                    |   2 +
 drivers/md/md.c                                 |   5 +-
 drivers/staging/comedi/drivers/ni_daq_700.c     |   2 +
 drivers/staging/speakup/main.c                  |   1 +
 drivers/staging/speakup/selection.c             |  38 +++++-
 drivers/staging/speakup/speakup.h               |   1 +
 drivers/usb/core/driver.c                       |   9 +-
 drivers/usb/core/hub.c                          |  15 ++-
 drivers/usb/host/xhci-mem.c                     |  20 +--
 drivers/usb/serial/ftdi_sio.c                   |   2 +
 drivers/usb/serial/ftdi_sio_ids.h               |   5 +
 drivers/usb/serial/io_ti.c                      |   2 +-
 drivers/usb/serial/io_usbvend.h                 |   2 +-
 drivers/usb/serial/option.c                     |   2 +
 include/linux/perf_event.h                      |   7 ++
 include/uapi/linux/usb/Kbuild                   |   1 +
 include/uapi/linux/usb/cdc-wdm.h                |   2 +
 kernel/cpu.c                                    |   6 +-
 kernel/events/core.c                            | 157 ++++++++++++++++++++----
 kernel/sched/core.c                             |   1 -
 kernel/sched/cpupri.c                           |   3 +-
 kernel/sched/cputime.c                          |  32 ++---
 kernel/sysctl.c                                 |  10 ++
 mm/memory-failure.c                             |   2 +
 mm/rmap.c                                       |   3 +-
 net/ipv6/netfilter.c                            |   6 +-
 sound/pci/hda/patch_realtek.c                   |  10 +-
 tools/perf/util/evsel.c                         |   2 +-
 44 files changed, 422 insertions(+), 141 deletions(-)


