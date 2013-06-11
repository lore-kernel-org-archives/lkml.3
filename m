Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab3FKUV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:21:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab3FKUDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/79] 3.9.6-stable review
Date: Tue, 11 Jun 2013 13:02:26 -0700
Message-Id: <20130611195312.352656079@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.9.6 release.
There are 79 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 13 19:50:17 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.9.6-rc1

Ben Hutchings <ben@decadent.org.uk>
    s390: Add pgste to ptep_modify_prot_start()

Zoran Markovic <zoran.markovic@linaro.org>
    timekeeping: Correct run-time detection of persistent_clock.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/smp: Fixup NOHZ per cpu data when onlining an offline CPU.

Ben Greear <greearb@candelatech.com>
    Fix lockup related to stop_machine being stuck in __do_softirq.

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix chars_in_buffer overhead

Johan Hovold <jhovold@gmail.com>
    USB: ftdi_sio: fix chars_in_buffer overhead

Johan Hovold <jhovold@gmail.com>
    USB: ftdi_sio: clean up get_modem_status

Johan Hovold <jhovold@gmail.com>
    USB: serial: add generic wait_until_sent implementation

Johan Hovold <jhovold@gmail.com>
    USB: serial: add wait_until_sent operation

Imre Deak <imre.deak@intel.com>
    drm/i915: force full modeset if the connector is in DPMS OFF mode

Michael Hennerich <michael.hennerich@analog.com>
    iio: frequency: ad4350: Fix bug / typo in mask

Michael Hennerich <michael.hennerich@analog.com>
    iio:inkern: Fix typo/bug in convert raw to processed.

Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
    radeon: use max_bus_speed to activate gen2 speeds

Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
    powerpc/pseries: Perform proper max_bus_speed detection

Brian King <brking@linux.vnet.ibm.com>
    powerpc/pseries: Make 32-bit MSI quirk work on systems lacking firmware support

Brian King <brking@linux.vnet.ibm.com>
    powerpc/pseries: Force 32 bit MSIs for devices that require it

Brian King <brking@linux.vnet.ibm.com>
    powerpc: Set default VGA device

Brian King <brking@linux.vnet.ibm.com>
    pci: Set dev->dev.type in alloc_pci_dev

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/gma500: Increase max resolution for mode setting

George Cherian <george.cherian@ti.com>
    usb: dwc3: gadget: free trb pool only from epnum 2

Guenter Roeck <linux@roeck-us.net>
    powerpc: Fix build error in stable/3.9

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPI / scan: do not match drivers against objects having scan handlers"

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Fix spurious -EIO/SIGBUS on wedged gpus

Ben Mesman <ben@bnc.nl>
    drm/i915: no lvds quirk for hp t5740

Egbert Eich <eich@suse.de>
    drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC.

Huacai Chen <chenhc@lemote.com>
    drm: fix a use-after-free when GPU acceleration disabled

Christopher Harvey <charvey@matrox.com>
    drm/mgag200: Add missing write to index before accessing data register

Guenter Roeck <linux@roeck-us.net>
    hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1617

Tyler Hicks <tyhicks@canonical.com>
    eCryptfs: Check return of filemap_write_and_wait during fsync

Paul Taysom <taysom@chromium.org>
    ecryptfs: fixed msync to flush data

Jeff Layton <jlayton@redhat.com>
    cifs: fix off-by-one bug in build_unc_path_to_root

Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
    hpfs: fix warnings when the filesystem fills up

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: don't allow audio on DCE6

Adis Hamzić <adis@hamzadis.com>
    radeon: Fix system hang issue when using KMS with older cards

Rabin Vincent <rabin.vincent@stericsson.com>
    dmaengine: ste_dma40: fix pm runtime ref counting

Michael Ellerman <michael@ellerman.id.au>
    powerpc/perf: Fix deadlock caused by calling printk() in PMU exception

Michael Neuling <mikey@neuling.org>
    powerpc/hw_breakpoints: Add DABRX cpu feature to fix 32-bit regression

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/eeh: Don't check RTAS token to get PE addr

Will Deacon <will.deacon@arm.com>
    ARM: 7747/1: pcpu: ensure __my_cpu_offset cannot be re-ordered across barrier()

Arnd Bergmann <arnd@arndb.de>
    ARM: 7743/1: compressed/head.S: work around new binutils warning

Arnd Bergmann <arnd@arndb.de>
    ARM: 7742/1: topology: export cpu_topology

Andrew Lunn <andrew@lunn.ch>
    ARM: Kirkwood: TS219: Fix crash by double PCIe instantiation

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add keep_eapd_on flag to generic parser

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Allow setting automute/automic hooks after parsing

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/via - Fix wrongly cleared pins after suspend on VT1802

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/via - Disable broken dynamic power control

lan,Tianyu <tianyu.lan@intel.com>
    x86 / platform / hp_wmi: Fix bluetooth_rfkill misuse in hp_wmi_rfkill_setup()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / PM: Do not execute _PS0 for devices without _PSC during initialization

Aaron Lu <aaron.lu@intel.com>
    ACPI / scan: do not match drivers against objects having scan handlers

Ash Willis <ashwillis.kernel@gmail.com>
    ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6

Alex Hung <alex.hung@canonical.com>
    ACPI / video: ignore BIOS initial backlight value for HP m4

Ross Lagerwall <rosslagerwall@gmail.com>
    acpi-cpufreq: set current frequency based on target P-State

Johan Hovold <jhovold@gmail.com>
    USB: mos7720: fix hardware flow control

Johan Hovold <jhovold@gmail.com>
    USB: mos7720: fix message timeouts

Johan Hovold <jhovold@gmail.com>
    USB: mos7720: fix DMA to stack

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix DMA to stack

Alan Stern <stern@rowland.harvard.edu>
    USB: revert periodic scheduling bugfix

Johan Hovold <jhovold@gmail.com>
    USB: serial: fix Treo/Kyocera interrrupt-in urb context

Johan Hovold <jhovold@gmail.com>
    USB: whiteheat: fix broken port configuration

Robert Butora <robert.butora.fi@gmail.com>
    USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device

Johan Hovold <jhovold@gmail.com>
    USB: zte_ev: fix broken open

Johan Hovold <jhovold@gmail.com>
    USB: zte_ev: fix control-message timeouts

Johan Hovold <jhovold@gmail.com>
    USB: visor: fix initialisation of Treo/Kyocera devices

Johan Hovold <jhovold@gmail.com>
    USB: ark3116: fix control-message timeout

Johan Hovold <jhovold@gmail.com>
    USB: keyspan: fix bogus array index

Johan Hovold <jhovold@gmail.com>
    USB: iuu_phoenix: fix bulk-message timeout

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audio iface

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: fix Roland/Cakewalk UM-3G support

Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
    usb: musb: make use_sg flag URB specific

Matt Fleming <matt.fleming@intel.com>
    x86/PCI: Map PCI setup data with ioremap() so it can be in highmem

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Disable D3cold for buggy TI redrivers.

Vladimir Murzin <murzin.v@gmail.com>
    xhci: fix list access before init

Sergio Aguirre <sergio.a.aguirre.rodriguez@intel.com>
    xhci-mem: init list heads at the beginning of init

Tony Camuso <tcamuso@redhat.com>
    xhci - correct comp_mode_recovery_timer on return from hibernate

Peter Chen <peter.chen@freescale.com>
    usb: dwc3: pci: PHY should be deleted later than dwc3 core

Dan Williams <dcbw@redhat.com>
    USB: option,zte_ev: move most ZTE CDMA devices to zte_ev

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist network interface on Huawei E1820

Richard Weinberger <richard@nod.at>
    USB: serial: Add Option GTM681W to qcserial device table.


-------------

Diffstat:

 Makefile                                     |  4 +-
 arch/arm/boot/compressed/Makefile            |  2 +-
 arch/arm/boot/compressed/head-sa1100.S       |  1 +
 arch/arm/boot/compressed/head-shark.S        |  1 +
 arch/arm/boot/compressed/head.S              |  1 +
 arch/arm/include/asm/percpu.h                | 11 +++++-
 arch/arm/kernel/topology.c                   |  2 +
 arch/arm/mach-kirkwood/board-ts219.c         | 10 -----
 arch/powerpc/include/asm/cputable.h          | 17 ++++----
 arch/powerpc/include/asm/machdep.h           |  3 ++
 arch/powerpc/include/asm/pci-bridge.h        |  2 +
 arch/powerpc/kernel/pci-common.c             | 21 ++++++++++
 arch/powerpc/kernel/process.c                |  3 +-
 arch/powerpc/kernel/traps.c                  |  2 +-
 arch/powerpc/perf/core-book3s.c              |  2 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c | 12 +++---
 arch/powerpc/platforms/pseries/msi.c         | 53 ++++++++++++++++++++++++-
 arch/powerpc/platforms/pseries/pci.c         | 53 +++++++++++++++++++++++++
 arch/powerpc/platforms/pseries/pseries.h     |  4 ++
 arch/powerpc/platforms/pseries/setup.c       |  2 +
 arch/s390/include/asm/pgtable.h              |  3 +-
 arch/x86/pci/common.c                        |  5 ++-
 arch/x86/xen/smp.c                           |  8 ++++
 drivers/acpi/device_pm.c                     | 10 +++--
 drivers/acpi/video.c                         | 16 ++++++++
 drivers/cpufreq/acpi-cpufreq.c               |  4 +-
 drivers/dma/ste_dma40.c                      |  8 ++--
 drivers/gpu/drm/drm_irq.c                    |  6 ++-
 drivers/gpu/drm/gma500/framebuffer.c         |  4 +-
 drivers/gpu/drm/i915/i915_gem.c              |  7 +---
 drivers/gpu/drm/i915/intel_display.c         | 24 +++++++++++-
 drivers/gpu/drm/i915/intel_lvds.c            |  4 +-
 drivers/gpu/drm/i915/intel_sdvo.c            |  2 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c       |  9 +++--
 drivers/gpu/drm/radeon/atombios_encoders.c   | 11 ++++--
 drivers/gpu/drm/radeon/evergreen.c           | 20 +++++-----
 drivers/gpu/drm/radeon/ni.c                  | 10 +++--
 drivers/gpu/drm/radeon/r100.c                |  9 +++--
 drivers/gpu/drm/radeon/r300.c                |  9 +++--
 drivers/gpu/drm/radeon/r420.c                | 10 +++--
 drivers/gpu/drm/radeon/r520.c                |  9 +++--
 drivers/gpu/drm/radeon/r600.c                | 19 ++++-----
 drivers/gpu/drm/radeon/rs400.c               |  9 +++--
 drivers/gpu/drm/radeon/rs600.c               |  9 +++--
 drivers/gpu/drm/radeon/rs690.c               |  9 +++--
 drivers/gpu/drm/radeon/rv515.c               |  9 +++--
 drivers/gpu/drm/radeon/rv770.c               | 19 ++++-----
 drivers/gpu/drm/radeon/si.c                  | 10 +++--
 drivers/hwmon/adm1021.c                      | 58 ++++++++++++++++++++++++----
 drivers/iio/frequency/adf4350.c              |  2 +-
 drivers/iio/inkern.c                         |  2 +-
 drivers/pci/probe.c                          |  2 +-
 drivers/platform/x86/hp-wmi.c                |  2 +-
 drivers/usb/dwc3/dwc3-pci.c                  |  2 +-
 drivers/usb/dwc3/gadget.c                    | 14 ++++++-
 drivers/usb/host/ehci-sched.c                |  2 +-
 drivers/usb/host/xhci-mem.c                  | 10 +++--
 drivers/usb/host/xhci-pci.c                  |  8 ++++
 drivers/usb/host/xhci.c                      | 16 ++++++--
 drivers/usb/host/xhci.h                      |  3 ++
 drivers/usb/musb/musb_host.c                 | 18 ++++-----
 drivers/usb/musb/musb_host.h                 |  1 +
 drivers/usb/serial/ark3116.c                 |  2 +-
 drivers/usb/serial/cypress_m8.c              | 18 ++++++++-
 drivers/usb/serial/cypress_m8.h              |  4 ++
 drivers/usb/serial/ftdi_sio.c                | 28 +++++---------
 drivers/usb/serial/generic.c                 | 31 +++++++++++++++
 drivers/usb/serial/io_ti.c                   | 22 +++++++----
 drivers/usb/serial/iuu_phoenix.c             |  4 +-
 drivers/usb/serial/keyspan.c                 |  2 +-
 drivers/usb/serial/mos7720.c                 | 25 ++++++++----
 drivers/usb/serial/mos7840.c                 | 35 +++++++++++++----
 drivers/usb/serial/option.c                  | 26 ++-----------
 drivers/usb/serial/qcserial.c                |  1 +
 drivers/usb/serial/usb-serial.c              | 19 +++++++++
 drivers/usb/serial/visor.c                   |  9 +++++
 drivers/usb/serial/whiteheat.c               |  2 +-
 drivers/usb/serial/zte_ev.c                  | 58 +++++++++++++++++-----------
 fs/cifs/connect.c                            |  4 +-
 fs/ecryptfs/file.c                           |  6 +++
 fs/hpfs/file.c                               |  4 ++
 include/linux/usb/serial.h                   |  4 ++
 kernel/softirq.c                             | 13 +++++--
 kernel/time/timekeeping.c                    |  8 ++++
 sound/pci/hda/hda_generic.c                  | 44 ++++++++++++++++-----
 sound/pci/hda/hda_generic.h                  |  1 +
 sound/pci/hda/patch_via.c                    | 10 ++++-
 sound/usb/mixer.c                            |  1 +
 sound/usb/quirks-table.h                     | 14 ++++++-
 89 files changed, 739 insertions(+), 274 deletions(-)


