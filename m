Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3B1OLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:11:07 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60350 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3B1OLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:11:03 -0500
Date: Thu, 28 Feb 2013 06:11:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.1
Message-ID: <20130228141106.GA14542@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.8.1 kernel.

All users of the 3.8 kernel series must upgrade.

The updated 3.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.8.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                               |    2=20
 arch/arm/boot/dts/at91sam9n12.dtsi                     |    8=20
 arch/arm/boot/dts/at91sam9x5.dtsi                      |    6=20
 arch/arm/kernel/sched_clock.c                          |    4=20
 arch/arm/mach-imx/clk-imx25.c                          |    3=20
 arch/arm/mach-integrator/integrator_ap.c               |    2=20
 arch/arm/mach-pxa/include/mach/smemc.h                 |    1=20
 arch/arm/mach-pxa/smemc.c                              |   15 +
 arch/arm/mach-s3c24xx/include/mach/debug-macro.S       |   12 -
 arch/arm/mach-s3c24xx/include/mach/entry-macro.S       |    4=20
 arch/arm/mach-s3c24xx/pm-h1940.S                       |    2=20
 arch/arm/mach-s3c24xx/sleep-s3c2410.S                  |   12 -
 arch/arm/mach-s3c24xx/sleep-s3c2412.S                  |   12 -
 arch/arm/mach-versatile/core.c                         |   15 +
 arch/arm/mach-versatile/pci.c                          |   11 -
 arch/arm/plat-samsung/include/plat/debug-macro.S       |   18 -
 arch/arm64/kernel/signal32.c                           |    4=20
 arch/parisc/include/asm/pgtable.h                      |   13 +
 arch/parisc/kernel/cache.c                             |   18 +
 arch/powerpc/Kconfig                                   |    4=20
 arch/powerpc/include/asm/eeh.h                         |    3=20
 arch/powerpc/kernel/machine_kexec_64.c                 |    5=20
 arch/powerpc/kernel/of_platform.c                      |    3=20
 arch/powerpc/kernel/pci-common.c                       |    7=20
 arch/powerpc/lib/Makefile                              |    4=20
 arch/powerpc/platforms/pseries/eeh.c                   |   24 ++
 arch/s390/kvm/kvm-s390.c                               |    8=20
 arch/sparc/include/asm/hugetlb.h                       |    1=20
 arch/sparc/include/asm/page_64.h                       |    4=20
 arch/sparc/include/asm/tsb.h                           |   28 ++
 arch/sparc/kernel/tsb.S                                |   39 +++-
 arch/sparc/mm/fault_64.c                               |    9=20
 arch/sparc/mm/init_64.c                                |   62 ++++--
 arch/sparc/mm/tlb.c                                    |   11 -
 arch/sparc/mm/tsb.c                                    |    2=20
 arch/x86/Kconfig                                       |    4=20
 arch/x86/include/asm/mmzone_32.h                       |    6=20
 arch/x86/kernel/cpu/mshyperv.c                         |    3=20
 arch/x86/mm/numa.c                                     |   32 +--
 arch/x86/mm/numa_32.c                                  |  161 ------------=
-----
 arch/x86/mm/numa_internal.h                            |    6=20
 arch/x86/power/hibernate_32.c                          |    2=20
 arch/x86/xen/spinlock.c                                |    1=20
 drivers/base/bus.c                                     |    4=20
 drivers/base/dd.c                                      |    2=20
 drivers/dca/dca-core.c                                 |    5=20
 drivers/dma/sh/shdma.c                                 |    2=20
 drivers/gpio/gpio-em.c                                 |    3=20
 drivers/gpu/drm/drm_crtc.c                             |    3=20
 drivers/gpu/drm/drm_edid.c                             |   12 -
 drivers/gpu/drm/drm_usb.c                              |    2=20
 drivers/gpu/drm/i915/i915_debugfs.c                    |   12 -
 drivers/gpu/drm/i915/i915_drv.h                        |    2=20
 drivers/gpu/drm/i915/i915_gem.c                        |    5=20
 drivers/gpu/drm/i915/i915_reg.h                        |    9=20
 drivers/gpu/drm/i915/intel_crt.c                       |   14 -
 drivers/gpu/drm/i915/intel_ddi.c                       |   25 +-
 drivers/gpu/drm/i915/intel_display.c                   |   68 ++++---
 drivers/gpu/drm/i915/intel_drv.h                       |   11 -
 drivers/gpu/drm/i915/intel_panel.c                     |   13 -
 drivers/gpu/drm/i915/intel_sprite.c                    |    8=20
 drivers/gpu/drm/nouveau/core/include/subdev/bios/dcb.h |    3=20
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c         |   32 ++-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv50.c     |   14 -
 drivers/gpu/drm/radeon/atombios_crtc.c                 |    6=20
 drivers/gpu/drm/radeon/evergreen.c                     |   13 +
 drivers/gpu/drm/radeon/r600_hdmi.c                     |    1=20
 drivers/gpu/drm/radeon/radeon_atpx_handler.c           |   73 +++++++
 drivers/gpu/drm/radeon/radeon_pm.c                     |    2=20
 drivers/gpu/drm/udl/udl_drv.h                          |    2=20
 drivers/gpu/drm/udl/udl_fb.c                           |   48 ++++-
 drivers/gpu/vga/vga_switcheroo.c                       |    3=20
 drivers/hid/hid-wiimote-ext.c                          |    8=20
 drivers/iommu/intel-iommu.c                            |    8=20
 drivers/mmc/core/mmc.c                                 |    2=20
 drivers/mmc/host/sdhci-esdhc-imx.c                     |   19 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c         |    4=20
 drivers/net/ppp/ppp_generic.c                          |    8=20
 drivers/net/usb/cdc_ncm.c                              |   11 -
 drivers/net/wireless/b43/dma.h                         |    2=20
 drivers/net/wireless/p54/p54usb.c                      |    2=20
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c            |    9=20
 drivers/net/wireless/rtlwifi/usb.c                     |   49 +++--
 drivers/net/wireless/rtlwifi/usb.h                     |    3=20
 drivers/net/xen-netback/interface.c                    |    3=20
 drivers/net/xen-netback/netback.c                      |    8=20
 drivers/pci/access.c                                   |    2=20
 drivers/pcmcia/vrc4171_card.c                          |    1=20
 drivers/pps/clients/pps-ldisc.c                        |   10 -
 drivers/pps/pps.c                                      |   47 ++++
 drivers/s390/kvm/kvm_virtio.c                          |   38 +++-
 drivers/staging/comedi/comedi_fops.c                   |    5=20
 drivers/staging/comedi/drivers/ni_labpc.c              |   34 +--
 drivers/staging/vt6656/dpc.c                           |    4=20
 drivers/staging/vt6656/rxtx.c                          |    2=20
 drivers/staging/vt6656/usbpipe.c                       |   28 ++
 drivers/staging/zram/zram_drv.c                        |    9=20
 drivers/staging/zsmalloc/zsmalloc-main.c               |   10 -
 drivers/tty/n_gsm.c                                    |   42 ++++
 drivers/tty/serial/imx.c                               |   11 -
 drivers/tty/tty_ioctl.c                                |    4=20
 drivers/tty/vt/vt.c                                    |  138 ++++++++++--=
--
 drivers/usb/host/ehci-omap.c                           |   10 -
 drivers/usb/musb/am35x.c                               |    2=20
 drivers/usb/musb/blackfin.c                            |    2=20
 drivers/usb/musb/da8xx.c                               |    7=20
 drivers/usb/musb/davinci.c                             |    7=20
 drivers/usb/musb/musb_core.c                           |    1=20
 drivers/usb/musb/musb_dsps.c                           |    2=20
 drivers/usb/musb/omap2430.c                            |    2=20
 drivers/usb/musb/tusb6010.c                            |    2=20
 drivers/usb/musb/ux500.c                               |   12 -
 drivers/usb/serial/ftdi_sio.c                          |   20 --
 drivers/usb/serial/mct_u232.c                          |   22 --
 drivers/usb/serial/option.c                            |   16 +
 drivers/usb/serial/quatech2.c                          |   18 -
 drivers/usb/serial/sierra.c                            |    8=20
 drivers/usb/serial/ssu100.c                            |   19 --
 drivers/usb/serial/usb-serial.c                        |   14 +
 drivers/usb/serial/usb_wwan.c                          |    8=20
 drivers/usb/storage/initializers.c                     |    4=20
 drivers/usb/storage/unusual_cypress.h                  |    2=20
 drivers/video/backlight/adp8860_bl.c                   |    2=20
 drivers/video/backlight/adp8870_bl.c                   |    2=20
 drivers/video/console/fbcon.c                          |   58 +++++-
 drivers/video/console/vgacon.c                         |   22 +-
 drivers/video/fbmem.c                                  |   11 -
 drivers/video/fbsysfs.c                                |    3=20
 drivers/video/fsl-diu-fb.c                             |   64 +++---
 drivers/xen/evtchn.c                                   |   10 +
 fs/block_dev.c                                         |    1=20
 fs/gfs2/bmap.c                                         |    4=20
 fs/lockd/clntproc.c                                    |    3=20
 fs/namespace.c                                         |   29 +--
 fs/nfs/blocklayout/blocklayout.c                       |    1=20
 fs/nfs/callback_proc.c                                 |   61 ------
 fs/nfs/nfs4proc.c                                      |   35 ++-
 fs/nfs/objlayout/objio_osd.c                           |    1=20
 fs/nfs/pnfs.c                                          |  150 ++++++++++++=
+--
 fs/nfs/pnfs.h                                          |    7=20
 fs/notify/inotify/inotify_user.c                       |    4=20
 fs/ocfs2/dlmglue.c                                     |    5=20
 include/linux/console.h                                |    2=20
 include/linux/if_vlan.h                                |    6=20
 include/linux/pps_kernel.h                             |   17 +
 include/linux/vt_kern.h                                |    3=20
 include/net/dst.h                                      |    8=20
 include/net/icmp.h                                     |    1=20
 include/net/inet6_hashtables.h                         |    8=20
 include/net/inet_sock.h                                |    1=20
 include/net/ip6_fib.h                                  |   39 +---
 include/net/ipv6.h                                     |   12 +
 include/net/sock.h                                     |    2=20
 include/uapi/linux/serial_core.h                       |    2=20
 include/uapi/linux/usb/audio.h                         |    6=20
 kernel/futex.c                                         |    2=20
 kernel/futex_compat.c                                  |    2=20
 kernel/hrtimer.c                                       |   36 +--
 kernel/irq/spurious.c                                  |    7=20
 kernel/posix-cpu-timers.c                              |   23 ++
 kernel/timeconst.pl                                    |    6=20
 kernel/workqueue.c                                     |    2=20
 mm/fadvise.c                                           |   18 +
 mm/mmu_notifier.c                                      |   82 ++++----
 mm/shmem.c                                             |   10 -
 net/core/dst.c                                         |    1=20
 net/core/sock_diag.c                                   |    3=20
 net/ipv4/af_inet.c                                     |   11 -
 net/ipv4/icmp.c                                        |   23 ++
 net/ipv4/ping.c                                        |    4=20
 net/ipv4/tcp_output.c                                  |   18 +
 net/ipv6/route.c                                       |    8=20
 net/ipv6/xfrm6_policy.c                                |    2=20
 net/mac80211/mlme.c                                    |    4=20
 security/keys/process_keys.c                           |    2=20
 sound/drivers/aloop.c                                  |    5=20
 sound/pci/ali5451/ali5451.c                            |    2=20
 sound/pci/hda/hda_codec.c                              |   43 ++--
 sound/pci/hda/hda_codec.h                              |    3=20
 sound/pci/hda/hda_intel.c                              |    2=20
 sound/pci/hda/patch_hdmi.c                             |   18 +
 sound/pci/hda/patch_realtek.c                          |    1=20
 sound/pci/rme32.c                                      |    2=20
 sound/soc/codecs/arizona.c                             |   11 +
 sound/soc/codecs/wm2200.c                              |    4=20
 sound/usb/quirks-table.h                               |    2=20
 sound/usb/quirks.c                                     |    2=20
 tools/perf/Makefile                                    |    4=20
 tools/perf/ui/hist.c                                   |    6=20
 tools/perf/util/parse-events.y                         |    1=20
 tools/perf/util/pmu.y                                  |    1=20
 191 files changed, 1647 insertions(+), 991 deletions(-)

Al Viro (1):
      get rid of unprotected dereferencing of mnt->mnt_ns

Alan Cox (1):
      fb: rework locking to fix lock ordering on takeover

Alex Deucher (4):
      drm/radeon/dce6: fix display powergating
      drm/radeon: fix multi-head power profile stability on BTC+ asics
      drm/radeon: remove overzealous warning in hdmi handling
      drm/radeon: properly validate the atpx interface

Alex Williamson (1):
      PCI: Fix PCI Express Capability accessors for PCI_EXP_FLAGS

Anatolij Gustschin (2):
      drivers/video: fsl-diu-fb: fix pixel formats for 24 and 16 bpp
      drivers/video: fsl-diu-fb: fix bugs in interrupt handling

Anssi Hannula (1):
      ALSA: hda - Fix default multichannel HDMI mapping regression

Arnd Bergmann (1):
      ARM: samsung: fix assembly syntax for new gas

Balaji T K (1):
      mmc: core: expose RPMB partition only for CMD23 capable hosts

Ben Skeggs (3):
      drm/nouveau/bios: parse external transmitter type if off-chip
      drm/nouveau/bios: store a type/mask hash in parsed dcb data
      drm/nv50/devinit: reverse the logic for running encoder init scripts

Ben Widawsky (2):
      drm/i915: Fix CAGF for HSW
      drm/i915: Fix RC6VIDS encode/decode

Bjorn Helgaas (1):
      Driver core: treat unregistered bus_types as having no devices

Bj=F8rn Mork (4):
      net: cdc_ncm: fix probing of devices with multiple control interface =
altsettings
      USB: option: add and update Alcatel modems
      USB: option: add Yota / Megafon M100-1 4g modem
      USB: option: add Huawei "ACM" devices using protocol =3D vendor

Bob Peterson (1):
      GFS2: Get a block reservation before resizing a file

Chris Rattray (1):
      ASoC: wm2200: correct IN2L and IN3L digital mute

Chris Wilson (2):
      drm/i915: Only run idle processing from i915_gem_retire_requests_work=
er
      drm/i915: Handle untiled planes when computing their offsets

Christian Borntraeger (1):
      s390/kvm: Fix store status for ACRS/FPRS

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland A-PRO support

Cong Wang (1):
      vlan: adjust vlan_set_encap_proto() for its callers

Cornelia Huck (1):
      KVM: s390: Handle hosts not supporting s390-virtio.

Damien Lespiau (2):
      drm/i915: Preserve the DDI link reversal configuration
      drm/i915: Preserve the FDI line reversal override bit on CPT

Daniel Vetter (5):
      Revert "drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S"
      intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets
      drm/i915: write backlight harder
      drm/i915: Use HAS_L3_GPU_CACHE in i915_gem_l3_remap
      drm/i915: inverted brightness quirk for Acer Aspire 4736Z

Dave Airlie (6):
      drm/udl: make usage as a console safer
      drm/udl: disable fb_defio by default
      vgacon/vt: clear buffer attributes when we load a 512 character font =
(v2)
      drm/usb: bind driver to correct device
      fbcon: don't lose the console font across generic->chip driver switch
      fbcon: fix locking harder

Dave Hansen (1):
      x86-32, mm: Rip out x86_32 NUMA remapping code

David Henningsson (1):
      ALSA: hda - hdmi: ELD shouldn't be valid after unplug

David Herrmann (1):
      HID: wiimote: fix nunchuck button parser

David Howells (1):
      KEYS: Revert one application of "Fix unreachable code" patch

David S. Miller (4):
      sparc64: Fix gfp_flags setting in tsb_grow().
      sparc64: Handle hugepage TSB being NULL.
      sparc64: Fix tsb_grow() in atomic context.
      sparc64: Fix huge PMD to PTE translation for sun4u in TLB miss handle=
r.

David Vrabel (2):
      xen-netback: correctly return errors from netbk_count_requests()
      xen-netback: cancel the credit timer when taking the vif down

Denis Efremov (2):
      ALSA: ali5451: remove irq enabling in pointer callback
      ALSA: rme32.c irq enabling after spin_lock_irq

Dirkjan Bussink (1):
      tty: Prevent deadlock in n_gsm driver

Eric Dumazet (2):
      ppp: set qdisc_tx_busylock to avoid LOCKDEP splat
      ipv6: use a stronger hash for tcp

Fabio Baltieri (1):
      usb: musb: ux500: use clk_prepare_enable and clk_disable_unprepare

Fernando Luis Vazquez Cao (1):
      ALSA: hda - Workaround for silent output on Sony Vaio VGC-LN51JGB wit=
h ALC889

George Spelvin (3):
      pps: Add pps_lookup_dev() function
      pps: Use pps_lookup_dev to reduce ldisc coupling
      pps: Fix a use-after free bug when unregistering a source.

Grant Likely (1):
      drivercore: Fix ordering between deferred_probe and exiting initcalls

Greg Kroah-Hartman (1):
      Linux 3.8.1

Greg Thelen (1):
      tmpfs: fix use-after-free of mempolicy object

Guennadi Liakhovetski (1):
      dma: sh: Don't use ENODEV for failing slave lookup

H. Peter Anvin (3):
      x86-32, mm: Remove reference to resume_map_numa_kva()
      x86-32, mm: Remove reference to alloc_remap()
      timeconst.pl: Eliminate Perl warning

Ian Abbott (3):
      staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors
      staging: comedi: ni_labpc: set up command4 register *after* command3
      staging: comedi: ni_labpc: correct differential channel sequence for =
AI commands

Igor Grinberg (1):
      ARM: PXA3xx: program the CSMSADRCFG register

Jani Nikula (1):
      drm/i915: add missing \n to UTS_RELEASE in the error_state

Jean Delvare (1):
      pcmcia/vrc4171: Add missing spinlock init

Jim Somerville (1):
      inotify: remove broken mask checks causing unmount to be EINVAL

Jiri Olsa (1):
      perf hists: Fix period symbol_conf.field_sep display

Jiri Slaby (1):
      ALSA: usb/quirks, fix out-of-bounds access

Johan Hovold (1):
      USB: serial: fix null-pointer dereferences on disconnect

Johannes Berg (1):
      mac80211: always unblock CSA queue stop when disconnecting

John David Anglin (1):
      Purge existing TLB entries in set_pte_at and ptep_set_wrprotect

Joonsoo Kim (1):
      ARM: 7643/1: sched: correct update_sched_clock()

Josh Boyer (1):
      USB: usb-storage: unusual_devs update for Super TOP SATA bridge

Junxiao Bi (1):
      ocfs2: unlock super lock if lockres refresh failed

Jussi Kivilinna (1):
      rtlwifi: usb: allocate URB control message setup_packet and data buff=
er separately

Kleber Sacilotto de Souza (2):
      mlx4_en: fix allocation of device tx_cq
      mlx4_en: fix allocation of CPU affinity reverse-map

Konstantin Khlebnikov (1):
      workqueue: un-GPL function delayed_work_timer_fn()

Larry Finger (3):
      b43: Increase number of RX DMA slots
      rtlwifi: rtl8192cu: Fix NULL dereference BUG when using new_id
      rtlwifi: rtl8192cu: Add new USB ID

Lars-Peter Clausen (1):
      drivers/video/backlight/adp88?0_bl.c: fix resume

Leonid Shatz (1):
      hrtimer: Prevent hrtimer_enqueue_reprogram race

Li Wei (2):
      ipv4: fix a bug in ping_err().
      ipv4: fix error handling in icmp_protocol.

Linus Walleij (1):
      ARM: 7635/1: versatile: fix the PCI IRQ regression

MITSUNARI Shigeo (1):
      fs/block_dev.c: page cache wrongly left invalidated after revalidate_=
disk()

Maarten Lankhorst (1):
      drm: shut up invalid edid messages

Maciej Sosnowski (1):
      dca: check against empty dca_domains list before unregister provider

Magnus Damm (1):
      gpio: em: Use irq_domain_add_simple() to fix runtime error

Malcolm Priestley (3):
      staging: vt6656: revert : 64 bit- Correctly address void structure.
      staging: vt6656: Revert: 64bit fixes: dpc.c incorrect addressing of v=
oid structure.
      staging: vt6656: Fix URB submitted while active warning.

Mathias Krause (1):
      sock_diag: Fix out-of-bounds access to sock_diag_handlers[]

Mel Gorman (1):
      mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to disc=
ard all pages

Michael Chan (1):
      serial_core: Fix type definition for PORT_BRCM_TRUMANAGE.

Mika Kuoppala (1):
      drm/i915: disable shared panel fitter for pipe

Minchan Kim (2):
      zram: Fix deadlock bug in partial read/write
      staging: zsmalloc: Fix TLB coherency and build problem

Ming Lei (2):
      usb: musb: core: fix failure path
      usb: musb: fix dependency on transceiver driver

Nicolas Ferre (1):
      ARM: at91/DT: remove atmel,use-dma-* from 9x5 and 9n12 USART nodes

Nicolas Pitre (1):
      tty vt: fix character insertion overflow

Olaf Hering (1):
      x86: Hyper-V: register clocksource only if its advertised

Oleg Nesterov (1):
      tty: set_termios/set_termiox should not return -EINTR

Patrik Jakobsson (1):
      drm/i915: Set i9xx sdvo clock limits according to specifications

Paulo Zanoni (1):
      drm: don't add inferred modes for monitors that don't support them

Pawel Moll (1):
      ALSA: usb: Fix Processing Unit Descriptor parsers

Phileas Fogg (1):
      powerpc/kexec: Disable hard IRQ before kexec

Robin Holt (1):
      mmu_notifier_unregister NULL Pointer deref and multiple ->release() c=
allouts

Roger Quadros (2):
      USB: ehci-omap: Don't free gpios that we didn't request
      USB: ehci-omap: Fix autoloading of module

Romain KUNTZ (1):
      xfrm: release neighbor upon dst destruction

Ryo Tsutsui (1):
      ASoC: arizona: Fixed a bug in FLL fractional calculation

Shawn Guo (1):
      mmc: sdhci-esdhc-imx: fix host version read

Stanislaw Gruszka (1):
      posix-cpu-timers: Fix nanosleep task_struct leak

Stefan Bader (1):
      xen: Send spinlock IPI to all waiters

Steffen Trumtrar (1):
      ARM: i.MX25: clk: parent per5_clk to AHB clock

Suzuki K. Poulose (1):
      uprobes/powerpc: Add dependency on single step emulation

Takashi Iwai (5):
      ALSA: aloop: Fix Oops while PM resume
      ALSA: hda - Disable runtime PM for Intel 5 Series/3400
      ALSA: hda - Release assigned pin/cvt at error path of hdmi_pcm_open()
      ALSA: hda - Fix broken workaround for HDMI/SPDIF conflicts
      fb: Yet another band-aid for fixing lockdep mess

Thadeu Lima de Souza Cascardo (1):
      powerpc/eeh: Fix crash when adding a device in a slot with DDW

Thomas Gleixner (3):
      genirq: Avoid deadlock in spurious handling
      serial: imx: Fix recursive locking bug
      futex: Revert "futex: Mark get_robust_list as deprecated"

Tomasz Guszkowski (1):
      p54usb: corrected USB ID for T-Com Sinus 154 data II

Trond Myklebust (3):
      NLM: Ensure that we resend all pending blocking locks after a reclaim
      NFSv4.1: Fix an ABBA locking issue with session and state serialisati=
on
      NFSv4.1: Fix bulk recall and destroy of layouts

Ville Syrj=E4l=E4 (2):
      drm: Fill depth/bits_per_pixel for C8 format
      drm: Use C8 instead of RGB332 when determining the format from depth/=
bpp

Vinson Lee (1):
      perf tools: Fix build with bison 2.3 and older.

Wei Liu (1):
      xen: close evtchn port if binding to irq fails

Weston Andros Adamson (1):
      NFSv4.1: Don't decode skipped layoutgets

Will Deacon (2):
      ARM: integrator: ensure ap_syscon_base is initialised when !CONFIG_MMU
      arm64: compat: use compat_uptr_t type for compat_ucontext.uc_link

YOSHIFUJI Hideaki (1):
      ipv6: fix race condition regarding dst->expires and dst->from.

Ying Xue (1):
      net: fix a compile error when SOCK_REFCNT_DEBUG is enabled

Yuchung Cheng (1):
      tcp: fix SYN-data space mis-accounting

fanchaoting (1):
      umount oops when remove blocklayoutdriver first

fangxiaozhi (1):
      USB: storage: properly handle the endian issues of idProduct


--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRL2V6AAoJEDjbvchgkmk+j9UQAK6SI2X7Naw7eD4gpnJYZNxZ
PRCjAhnjtaUOP8OGswDBUbMm/xUdnWx99aibZSEiajp5PxKHbB9m8RjoI7z/mEs4
nxjL+fJ9ToKQFXIvRCPYg5IGPjpwca05RevCWo5KOuldvNpYjUnC0daSXaHG4Plq
MMjyfAqaId6+8C9OvuxxLJR7TNW8nvRwBAAC/ROcRr11djMmPzZxgOrDqjvCBUrU
OpXvdNV/mCr/jnMhTwuqHUo0WYtplMYTmhueaOAVzMSQ8c55GT8hMZuGS9a/IlIg
RmbFQVJPNAUmdNr2VyJFuKnz+VvwTKzVeWNQprmhK3w3PhvQRHzrmdOxNBeob3CS
XCWrBXD7OkrFlFFtd9ZxT7KaZ12HnN+SUwmBlRmYf1+EQ01RT4bj3tvqTefpT5FA
g3ogHKkGDYGANU/+qsQfYYhHyRZC/SmeRxEd/RjoBxlfZ83TBrorPF7p1LOvPe94
/YV7QITya11tTMk44J4hEQ4t+LtDCiN5iiGpCET+1QY37UoXYtgjwxNSckM4PVKb
+q9/QmcD257EFwpZdFYkHAR9gwiwxHuNLV5aptTEBVzg6RBIJQJ3Lu8eXqFs4Yqh
j0SIm3VBQ0uKDAPbqagDsWIeXh+6Vi5ZuzTa5kxbVwm8XO98FoXSgqOvOL9AR7YU
3cFkZ+OaPiaGJYIfC7OH
=X8UC
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
