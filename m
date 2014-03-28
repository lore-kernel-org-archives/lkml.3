Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaC1Ra7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:30:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaC1Raw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.13 00/46] 3.13.8-stable review
Date: Fri, 28 Mar 2014 10:31:44 -0700
Message-Id: <20140328173134.630198216@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.13.8 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Mar 30 17:31:14 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.13.8-rc1

Ilya Dryomov <ilya.dryomov@inktank.com>
    libceph: fix preallocation check in get_reply()

Ilya Dryomov <ilya.dryomov@inktank.com>
    libceph: rename front to front_len in get_reply()

Ilya Dryomov <ilya.dryomov@inktank.com>
    libceph: rename ceph_msg::front_max to front_alloc_len

Michele Baldessari <michele@acksyn.org>
    e100: Fix "disabling already-disabled device" warning

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Fix resume issues on Renesas chips in Samsung laptops

Ping Cheng <pinglinux@gmail.com>
    Input: wacom - add reporting of SW_MUTE_DEVICE events

Ping Cheng <pinglinux@gmail.com>
    Input: wacom - add support for three new Intuos devices

Ping Cheng <pinglinux@gmail.com>
    Input: wacom - make sure touch_max is set for touch devices

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: VMX: fix use after free of vmx->loaded_vmcs

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: x86: handle invalid root_hpa everywhere

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: MMU: handle invalid root_hpa at __direct_map

Hans de Goede <hdegoede@redhat.com>
    Input: elantech - improve clickpad detection

Dave Jones <davej@redhat.com>
    fs/proc/proc_devtree.c: remove empty /proc/device-tree when no openfirmware exists.

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/powernv: Refactor PHB diag-data dump

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/powernv: Dump PHB diag-data immediately

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/eeh: Handle multiple EEH errors

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/powernv: Move PHB-diag dump functions around

Markus Pargmann <mpa@pengutronix.de>
    regulator: core: Replace direct ops->disable usage

Dan Carpenter <dan.carpenter@oracle.com>
    p54: clamp properly instead of just truncating

Guenter Roeck <linux@roeck-us.net>
    MIPS: Fix build error seen in some configurations

Ben Hutchings <ben@decadent.org.uk>
    deb-pkg: Fix cross-building linux-headers package

Ben Hutchings <ben@decadent.org.uk>
    deb-pkg: Fix building for MIPS big-endian or ARM OABI

Peter Zijlstra <peterz@infradead.org>
    perf tools: Fix AAAAARGH64 memory barriers

Russell King <rmk+kernel@arm.linux.org.uk>
    Fix uses of dma_max_pfn() when converting to a limiting address

Linus Torvalds <torvalds@linux-foundation.org>
    printk: fix syslog() overflowing user buffer

Alexei Starovoitov <ast@plumgrid.com>
    x86: bpf_jit: support negative offsets

Trond Myklebust <trond.myklebust@primarydata.com>
    SUNRPC: Fix a pipe_version reference leak

Ben Peddell <klightspeed@killerwolves.net>
    ARM: 7941/2: Fix incorrect FDT initrd parameter override

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Use the correct maximum TX DMA ring size for SFC9100

Peter Zijlstra <peterz@infradead.org>
    stop_machine: Fix^2 race between stop_two_cpus() and stop_cpus()

Stephen Warren <swarren@nvidia.com>
    ASoC: max98090: make REVISION_ID readable

Josh Durgin <josh.durgin@inktank.com>
    libceph: resend all writes after the osdmap loses the full flag

Josh Durgin <josh.durgin@inktank.com>
    libceph: block I/O when PAUSE or FULL osd map flags are set

Dan Carpenter <dan.carpenter@oracle.com>
    media: cx18: check for allocation failure in cx18_read_eeprom()

Dan Carpenter <dan.carpenter@oracle.com>
    media: dw2102: some missing unlocks on error

Dan Carpenter <dan.carpenter@oracle.com>
    media: cxusb: unlock on error in cxusb_i2c_xfer()

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Use the correct net namespace in nfs4_update_server

Christian Riesch <christian.riesch@omicron.at>
    net: davinci_emac: Replace devm_request_irq with request_irq

Helge Deller <deller@gmx.de>
    partly revert commit 8a10bc9: parisc/sti_console: prefer Linux fonts over built-in ROM fonts

Vaibhav Nagarnaik <vnagarnaik@google.com>
    tracing: Fix array size mismatch in format string

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Disable stolen memory when DMAR is active

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Don't enable display error interrupts from the start

Ben Widawsky <benjamin.widawsky@intel.com>
    drm/i915: Fix PSR programming

Stefan Agner <stefan@agner.ch>
    clocksource: vf_pit_timer: use complement for sched_clock reading

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ALSA: compress: Pass through return value of open ops callback

Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
    HID: hidraw: fix warning destroying hidraw device files after parent


-------------

Diffstat:

 Makefile                                  |   4 +-
 arch/arm/mm/init.c                        |   3 +-
 arch/mips/include/asm/syscall.h           |   2 +-
 arch/powerpc/include/asm/eeh.h            |  10 ++
 arch/powerpc/kernel/eeh_driver.c          | 150 ++++++++--------
 arch/powerpc/platforms/powernv/eeh-ioda.c | 283 +++++++-----------------------
 arch/powerpc/platforms/powernv/pci.c      | 226 ++++++++++++++++++------
 arch/powerpc/platforms/powernv/pci.h      |   3 +
 arch/x86/kvm/mmu.c                        |  12 ++
 arch/x86/kvm/paging_tmpl.h                |   8 +
 arch/x86/kvm/vmx.c                        |   2 +-
 arch/x86/net/bpf_jit.S                    |   2 +-
 drivers/clocksource/vf_pit_timer.c        |   2 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c    |   7 +
 drivers/gpu/drm/i915/i915_irq.c           |  18 +-
 drivers/gpu/drm/i915/intel_dp.c           |   2 +-
 drivers/hid/hidraw.c                      |   4 +-
 drivers/input/mouse/elantech.c            |  45 ++++-
 drivers/input/tablet/wacom_sys.c          |  23 ++-
 drivers/input/tablet/wacom_wac.c          |  89 ++++++++--
 drivers/input/tablet/wacom_wac.h          |   7 +
 drivers/media/pci/cx18/cx18-driver.c      |   5 +-
 drivers/media/usb/dvb-usb/cxusb.c         |  21 ++-
 drivers/media/usb/dvb-usb/dw2102.c        |  52 ++++--
 drivers/mmc/card/queue.c                  |   2 +-
 drivers/net/ethernet/intel/e100.c         |   2 +-
 drivers/net/ethernet/sfc/efx.h            |   3 +
 drivers/net/ethernet/sfc/ethtool.c        |   4 +-
 drivers/net/ethernet/ti/davinci_emac.c    |  25 ++-
 drivers/net/wireless/p54/txrx.c           |   2 +-
 drivers/regulator/core.c                  |  34 ++--
 drivers/scsi/scsi_lib.c                   |   2 +-
 drivers/usb/host/xhci-pci.c               |   5 +
 fs/nfs/internal.h                         |   3 +-
 fs/nfs/nfs4client.c                       |   7 +-
 fs/nfs/nfs4namespace.c                    |  12 +-
 fs/proc/proc_devtree.c                    |   1 +
 include/linux/ceph/messenger.h            |   2 +-
 include/linux/ceph/osd_client.h           |   1 +
 include/linux/ftrace_event.h              |   4 -
 include/trace/ftrace.h                    |   7 +-
 kernel/printk/printk.c                    |   2 -
 kernel/stop_machine.c                     |   2 +-
 kernel/trace/trace_events.c               |   6 -
 kernel/trace/trace_export.c               |   7 +-
 lib/fonts/Kconfig                         |   6 +-
 net/ceph/messenger.c                      |   7 +-
 net/ceph/mon_client.c                     |   8 +-
 net/ceph/osd_client.c                     |  66 +++++--
 net/sunrpc/auth_gss/auth_gss.c            |   4 +-
 scripts/package/builddeb                  |  13 +-
 sound/core/compress_offload.c             |   2 +-
 sound/soc/codecs/max98090.c               |   1 +
 tools/perf/perf.h                         |   4 +-
 54 files changed, 713 insertions(+), 511 deletions(-)


