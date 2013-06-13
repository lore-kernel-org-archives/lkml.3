Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab3FMRy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:54:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3FMRyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:54:25 -0400
Date: Thu, 13 Jun 2013 10:55:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.9.6
Message-ID: <20130613175502.GA9768@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.9.6 kernel.

All users of the 3.9 kernel series must upgrade.

The updated 3.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.9.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                     |    4 -
 arch/arm/boot/compressed/Makefile            |    2=20
 arch/arm/boot/compressed/head-sa1100.S       |    1=20
 arch/arm/boot/compressed/head-shark.S        |    1=20
 arch/arm/boot/compressed/head.S              |    1=20
 arch/arm/include/asm/percpu.h                |   11 ++++-
 arch/arm/kernel/topology.c                   |    2=20
 arch/arm/mach-kirkwood/board-ts219.c         |   10 ----
 arch/powerpc/include/asm/cputable.h          |   17 ++++---
 arch/powerpc/include/asm/machdep.h           |    3 +
 arch/powerpc/include/asm/pci-bridge.h        |    2=20
 arch/powerpc/kernel/pci-common.c             |   21 +++++++++
 arch/powerpc/kernel/process.c                |    3 -
 arch/powerpc/kernel/traps.c                  |    2=20
 arch/powerpc/perf/core-book3s.c              |    2=20
 arch/powerpc/platforms/pseries/eeh_pseries.c |   12 ++---
 arch/powerpc/platforms/pseries/msi.c         |   55 ++++++++++++++++++++++=
++-
 arch/powerpc/platforms/pseries/pci.c         |   53 ++++++++++++++++++++++=
++
 arch/powerpc/platforms/pseries/pseries.h     |    4 +
 arch/powerpc/platforms/pseries/setup.c       |    2=20
 arch/s390/include/asm/pgtable.h              |    3 -
 arch/x86/pci/common.c                        |    5 +-
 arch/x86/xen/smp.c                           |    8 +++
 drivers/acpi/device_pm.c                     |   10 ++--
 drivers/acpi/video.c                         |   16 +++++++
 drivers/cpufreq/acpi-cpufreq.c               |    4 -
 drivers/dma/ste_dma40.c                      |    8 ++-
 drivers/gpu/drm/drm_irq.c                    |    6 ++
 drivers/gpu/drm/gma500/framebuffer.c         |    4 -
 drivers/gpu/drm/i915/i915_gem.c              |    7 ---
 drivers/gpu/drm/i915/intel_display.c         |   24 ++++++++++-
 drivers/gpu/drm/i915/intel_lvds.c            |    4 -
 drivers/gpu/drm/i915/intel_sdvo.c            |    2=20
 drivers/gpu/drm/mgag200/mgag200_mode.c       |    9 ++--
 drivers/gpu/drm/radeon/atombios_encoders.c   |   11 +++--
 drivers/gpu/drm/radeon/evergreen.c           |   20 ++++-----
 drivers/gpu/drm/radeon/ni.c                  |   10 ++--
 drivers/gpu/drm/radeon/r100.c                |    9 ++--
 drivers/gpu/drm/radeon/r300.c                |    9 ++--
 drivers/gpu/drm/radeon/r420.c                |   10 ++--
 drivers/gpu/drm/radeon/r520.c                |    9 ++--
 drivers/gpu/drm/radeon/r600.c                |   19 +++-----
 drivers/gpu/drm/radeon/rs400.c               |    9 ++--
 drivers/gpu/drm/radeon/rs600.c               |    9 ++--
 drivers/gpu/drm/radeon/rs690.c               |    9 ++--
 drivers/gpu/drm/radeon/rv515.c               |    9 ++--
 drivers/gpu/drm/radeon/rv770.c               |   19 +++-----
 drivers/gpu/drm/radeon/si.c                  |   10 ++--
 drivers/hwmon/adm1021.c                      |   58 ++++++++++++++++++++++=
+----
 drivers/iio/frequency/adf4350.c              |    2=20
 drivers/iio/inkern.c                         |    2=20
 drivers/pci/probe.c                          |    2=20
 drivers/platform/x86/hp-wmi.c                |    2=20
 drivers/usb/dwc3/dwc3-pci.c                  |    2=20
 drivers/usb/dwc3/gadget.c                    |   14 +++++-
 drivers/usb/host/ehci-sched.c                |    2=20
 drivers/usb/host/xhci-mem.c                  |   10 +++-
 drivers/usb/host/xhci-pci.c                  |    8 +++
 drivers/usb/host/xhci.c                      |   16 ++++++-
 drivers/usb/host/xhci.h                      |    3 +
 drivers/usb/musb/musb_host.c                 |   18 +++-----
 drivers/usb/musb/musb_host.h                 |    1=20
 drivers/usb/serial/ark3116.c                 |    2=20
 drivers/usb/serial/cypress_m8.c              |   18 +++++++-
 drivers/usb/serial/cypress_m8.h              |    4 +
 drivers/usb/serial/ftdi_sio.c                |   28 ++++---------
 drivers/usb/serial/generic.c                 |   31 ++++++++++++++
 drivers/usb/serial/io_ti.c                   |   22 ++++++----
 drivers/usb/serial/iuu_phoenix.c             |    4 -
 drivers/usb/serial/keyspan.c                 |    2=20
 drivers/usb/serial/mos7720.c                 |   25 ++++++++---
 drivers/usb/serial/mos7840.c                 |   35 ++++++++++++----
 drivers/usb/serial/option.c                  |   26 +-----------
 drivers/usb/serial/qcserial.c                |    1=20
 drivers/usb/serial/usb-serial.c              |   19 ++++++++
 drivers/usb/serial/visor.c                   |    9 ++++
 drivers/usb/serial/whiteheat.c               |    2=20
 drivers/usb/serial/zte_ev.c                  |   58 ++++++++++++++++------=
-----
 fs/cifs/connect.c                            |    4 -
 fs/ecryptfs/file.c                           |    6 ++
 fs/hpfs/file.c                               |    4 +
 include/linux/usb/serial.h                   |    4 +
 kernel/softirq.c                             |   13 ++++--
 kernel/time/timekeeping.c                    |    8 +++
 sound/pci/hda/hda_generic.c                  |   44 ++++++++++++++++----
 sound/pci/hda/hda_generic.h                  |    1=20
 sound/pci/hda/patch_via.c                    |   10 ++++
 sound/usb/mixer.c                            |    1=20
 sound/usb/quirks-table.h                     |   14 +++++-
 89 files changed, 741 insertions(+), 274 deletions(-)

Aaron Lu (1):
      ACPI / scan: do not match drivers against objects having scan handlers

Adis Hamzi=C4=87 (1):
      radeon: Fix system hang issue when using KMS with older cards

Alan Stern (1):
      USB: revert periodic scheduling bugfix

Alex Deucher (1):
      drm/radeon: don't allow audio on DCE6

Alex Hung (1):
      ACPI / video: ignore BIOS initial backlight value for HP m4

Andrew Lunn (1):
      ARM: Kirkwood: TS219: Fix crash by double PCIe instantiation

Arnd Bergmann (2):
      ARM: 7742/1: topology: export cpu_topology
      ARM: 7743/1: compressed/head.S: work around new binutils warning

Ash Willis (1):
      ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6

Ben Greear (1):
      Fix lockup related to stop_machine being stuck in __do_softirq.

Ben Hutchings (1):
      s390: Add pgste to ptep_modify_prot_start()

Ben Mesman (1):
      drm/i915: no lvds quirk for hp t5740

Bj=C3=B8rn Mork (1):
      USB: option: blacklist network interface on Huawei E1820

Brian King (4):
      pci: Set dev->dev.type in alloc_pci_dev
      powerpc: Set default VGA device
      powerpc/pseries: Force 32 bit MSIs for devices that require it
      powerpc/pseries: Make 32-bit MSI quirk work on systems lacking firmwa=
re support

Christopher Harvey (1):
      drm/mgag200: Add missing write to index before accessing data register

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland/Cakewalk UM-3G support

Dan Williams (1):
      USB: option,zte_ev: move most ZTE CDMA devices to zte_ev

Daniel Vetter (1):
      drm/i915: Fix spurious -EIO/SIGBUS on wedged gpus

Egbert Eich (1):
      drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DD=
C.

Gavin Shan (1):
      powerpc/eeh: Don't check RTAS token to get PE addr

George Cherian (1):
      usb: dwc3: gadget: free trb pool only from epnum 2

Greg Kroah-Hartman (1):
      Linux 3.9.6

Guenter Roeck (2):
      hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1=
617
      powerpc: Fix build error in stable/3.9

Huacai Chen (1):
      drm: fix a use-after-free when GPU acceleration disabled

Imre Deak (1):
      drm/i915: force full modeset if the connector is in DPMS OFF mode

Jeff Layton (1):
      cifs: fix off-by-one bug in build_unc_path_to_root

Johan Hovold (17):
      USB: iuu_phoenix: fix bulk-message timeout
      USB: keyspan: fix bogus array index
      USB: ark3116: fix control-message timeout
      USB: visor: fix initialisation of Treo/Kyocera devices
      USB: zte_ev: fix control-message timeouts
      USB: zte_ev: fix broken open
      USB: whiteheat: fix broken port configuration
      USB: serial: fix Treo/Kyocera interrrupt-in urb context
      USB: mos7840: fix DMA to stack
      USB: mos7720: fix DMA to stack
      USB: mos7720: fix message timeouts
      USB: mos7720: fix hardware flow control
      USB: serial: add wait_until_sent operation
      USB: serial: add generic wait_until_sent implementation
      USB: ftdi_sio: clean up get_modem_status
      USB: ftdi_sio: fix chars_in_buffer overhead
      USB: io_ti: fix chars_in_buffer overhead

Kleber Sacilotto de Souza (2):
      powerpc/pseries: Perform proper max_bus_speed detection
      radeon: use max_bus_speed to activate gen2 speeds

Konrad Rzeszutek Wilk (1):
      xen/smp: Fixup NOHZ per cpu data when onlining an offline CPU.

Matt Fleming (1):
      x86/PCI: Map PCI setup data with ioremap() so it can be in highmem

Michael Ellerman (1):
      powerpc/perf: Fix deadlock caused by calling printk() in PMU exception

Michael Hennerich (2):
      iio:inkern: Fix typo/bug in convert raw to processed.
      iio: frequency: ad4350: Fix bug / typo in mask

Michael Neuling (1):
      powerpc/hw_breakpoints: Add DABRX cpu feature to fix 32-bit regression

Mikulas Patocka (1):
      hpfs: fix warnings when the filesystem fills up

Patrik Jakobsson (1):
      drm/gma500: Increase max resolution for mode setting

Paul Taysom (1):
      ecryptfs: fixed msync to flush data

Peter Chen (1):
      usb: dwc3: pci: PHY should be deleted later than dwc3 core

Rabin Vincent (1):
      dmaengine: ste_dma40: fix pm runtime ref counting

Rafael J. Wysocki (2):
      ACPI / PM: Do not execute _PS0 for devices without _PSC during initia=
lization
      Revert "ACPI / scan: do not match drivers against objects having scan=
 handlers"

Richard Weinberger (1):
      USB: serial: Add Option GTM681W to qcserial device table.

Robert Butora (1):
      USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device

Ross Lagerwall (1):
      acpi-cpufreq: set current frequency based on target P-State

Sarah Sharp (1):
      xhci: Disable D3cold for buggy TI redrivers.

Sergio Aguirre (1):
      xhci-mem: init list heads at the beginning of init

Takashi Iwai (6):
      ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audi=
o iface
      ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam=
 c270
      ALSA: hda/via - Disable broken dynamic power control
      ALSA: hda/via - Fix wrongly cleared pins after suspend on VT1802
      ALSA: hda - Allow setting automute/automic hooks after parsing
      ALSA: hda - Add keep_eapd_on flag to generic parser

Tony Camuso (1):
      xhci - correct comp_mode_recovery_timer on return from hibernate

Tyler Hicks (1):
      eCryptfs: Check return of filemap_write_and_wait during fsync

Virupax Sadashivpetimath (1):
      usb: musb: make use_sg flag URB specific

Vladimir Murzin (1):
      xhci: fix list access before init

Will Deacon (1):
      ARM: 7747/1: pcpu: ensure __my_cpu_offset cannot be re-ordered across=
 barrier()

Zoran Markovic (1):
      timekeeping: Correct run-time detection of persistent_clock.

lan,Tianyu (1):
      x86 / platform / hp_wmi: Fix bluetooth_rfkill misuse in hp_wmi_rfkill=
_setup()


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRugd2AAoJEDjbvchgkmk+t7oQAMqnfhgykVSIYnZaR5H6ug2B
bDwYhsL7v7fHwAwDvvQJAz5+bp8xDnC7SdX5pTK7od9LpA0526OA1qQEDGVqZV9j
LIbgTOucFFTeDL58Y8hHlcTtQLMTUp7RUsP5z8RmQmBzwaBrlvhNDCieJSWZ0b4X
7u5vbjNum7mt+QGoPAytdNVZ1XFWHADBO2kNGnqAKKQ8LJ3H5U28SO4qELPMuxN3
ykfFyET32fk4MyeOcW9Z0fDOS9bscT98l/MMRNZNg3LCu0ZxjvOTNItaXvuNjyn1
Pwr+HLYle48OXM0A0AkTYJQqHCi/FfhR9119uMhrlM52MoQXJv+kxLqp7S5QJlnN
TxgZ+tXlPktzGPv5eZDRwsHjYLcaxn/7piKxevQPMvGDzVwELmVjaUf7kL1pzojP
nRNqP6SopMDegZx674d7g2Bmz/ozQyCXcmXeLhYuJc13gQiIOa8nVUrGYtZOk6Ig
9yTnu64yoPf7T0I8/J1hVwHQ0H6PXLEUWRPRulxcuJA4j6gZ2e99QhV3oZFymtch
DX0RdYwqBbktbCS8QlUZHBSwsKpyvagkXuEuCHA8d9QZUNdrC+pNhVh/zSJVHQSb
JPJuNqfcZLDbkp5zzGv234WwjI3Tw23xksYFgGajMvkSUBFHsstxCcBoeY1QlawR
UofSMUatMIGBmwZt0Yrw
=uk1d
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
