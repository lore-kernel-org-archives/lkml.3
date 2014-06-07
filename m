Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaFGXLD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 19:11:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaFGXK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 19:10:58 -0400
Date: Sat, 7 Jun 2014 16:10:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.92
Message-ID: <20140607231052.GA27791@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.92 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/i2c/busses/i2c-piix4             |    2=20
 Documentation/ja_JP/HOWTO                      |    2=20
 Documentation/ja_JP/stable_kernel_rules.txt    |    6=20
 Documentation/kernel-parameters.txt            |   20 +
 Documentation/zh_CN/HOWTO                      |    2=20
 Documentation/zh_CN/stable_kernel_rules.txt    |    2=20
 Makefile                                       |    2=20
 arch/arm/kernel/crash_dump.c                   |    2=20
 arch/parisc/kernel/syscall_table.S             |    2=20
 arch/s390/crypto/aes_s390.c                    |   50 ++--
 arch/x86/Kconfig                               |    1=20
 arch/x86/boot/Makefile                         |    6=20
 arch/x86/boot/compressed/Makefile              |    1=20
 arch/x86/include/asm/hugetlb.h                 |    1=20
 arch/x86/kernel/crash.c                        |    2=20
 arch/x86/kernel/ldt.c                          |    4=20
 arch/x86/kernel/reboot.c                       |   11 -
 arch/x86/kernel/setup.c                        |    4=20
 arch/x86/kernel/step.c                         |   53 +++--
 arch/x86/kernel/sys_x86_64.c                   |    2=20
 arch/x86/mm/mmap.c                             |    6=20
 arch/x86/platform/efi/efi.c                    |  105 ++++++++++
 arch/x86/vdso/vdso32-setup.c                   |    8=20
 crypto/crypto_wq.c                             |    2=20
 drivers/acpi/blacklist.c                       |   13 +
 drivers/ata/ata_piix.c                         |    8=20
 drivers/ata/pata_at91.c                        |   11 -
 drivers/atm/ambassador.c                       |    2=20
 drivers/atm/idt77252.c                         |    2=20
 drivers/base/dd.c                              |   17 +
 drivers/block/floppy.c                         |   11 -
 drivers/block/nbd.c                            |    9=20
 drivers/char/ipmi/ipmi_kcs_sm.c                |    5=20
 drivers/char/ipmi/ipmi_si_intf.c               |   46 ++--
 drivers/char/random.c                          |   24 +-
 drivers/crypto/caam/error.c                    |   10=20
 drivers/edac/i82975x_edac.c                    |   11 -
 drivers/firmware/Kconfig                       |   18 +
 drivers/firmware/efivars.c                     |  256 +++++++++++++++++---=
-----
 drivers/gpu/drm/drm_crtc_helper.c              |    4=20
 drivers/gpu/drm/i915/i915_debugfs.c            |    6=20
 drivers/gpu/drm/i915/i915_drv.h                |    4=20
 drivers/gpu/drm/i915/i915_gem.c                |   23 +-
 drivers/gpu/drm/i915/i915_irq.c                |    4=20
 drivers/gpu/drm/i915/intel_display.c           |  114 ++++++++++-
 drivers/gpu/drm/i915/intel_dp.c                |    5=20
 drivers/gpu/drm/i915/intel_drv.h               |    5=20
 drivers/gpu/drm/i915/intel_lvds.c              |    3=20
 drivers/gpu/drm/i915/intel_opregion.c          |    2=20
 drivers/gpu/drm/i915/intel_panel.c             |   31 ++-
 drivers/gpu/drm/i915/intel_sdvo.c              |   22 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c         |    3=20
 drivers/gpu/drm/nouveau/nouveau_bo.c           |    2=20
 drivers/gpu/drm/radeon/atombios_crtc.c         |    5=20
 drivers/gpu/drm/radeon/evergreen.c             |    9=20
 drivers/gpu/drm/radeon/ni.c                    |    3=20
 drivers/gpu/drm/radeon/r600.c                  |    3=20
 drivers/gpu/drm/radeon/r600_hdmi.c             |    4=20
 drivers/gpu/drm/radeon/radeon_atpx_handler.c   |    7=20
 drivers/gpu/drm/radeon/radeon_combios.c        |  125 ++++++++++++
 drivers/gpu/drm/radeon/radeon_connectors.c     |   34 +++
 drivers/gpu/drm/radeon/radeon_display.c        |    1=20
 drivers/gpu/drm/radeon/radeon_kms.c            |    4=20
 drivers/gpu/drm/radeon/radeon_mode.h           |    2=20
 drivers/gpu/drm/radeon/rv770.c                 |    3=20
 drivers/gpu/drm/radeon/si.c                    |    3=20
 drivers/gpu/drm/ttm/ttm_bo.c                   |   32 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c             |    5=20
 drivers/hid/hid-logitech-dj.c                  |   38 ++-
 drivers/hv/ring_buffer.c                       |    4=20
 drivers/hv/vmbus_drv.c                         |    2=20
 drivers/hwmon/emc1403.c                        |    4=20
 drivers/i2c/busses/Kconfig                     |    1=20
 drivers/i2c/busses/i2c-designware-core.c       |    3=20
 drivers/i2c/busses/i2c-piix4.c                 |    3=20
 drivers/i2c/busses/i2c-tegra.c                 |   13 +
 drivers/idle/intel_idle.c                      |    7=20
 drivers/input/mouse/synaptics.c                |   31 ++-
 drivers/md/dm-bufio.c                          |   26 ++
 drivers/md/dm-mpath.c                          |   18 +
 drivers/md/dm-snap.c                           |   73 ++++++-
 drivers/md/dm-thin.c                           |    4=20
 drivers/md/md.c                                |    3=20
 drivers/md/persistent-data/dm-btree-remove.c   |   46 ++--
 drivers/md/raid10.c                            |    8=20
 drivers/media/media-device.c                   |    1=20
 drivers/misc/hpilo.c                           |   11 -
 drivers/mtd/devices/m25p80.c                   |   19 -
 drivers/mtd/ubi/scan.c                         |    2=20
 drivers/net/bonding/bond_main.c                |    1=20
 drivers/net/can/c_can/c_can.c                  |    6=20
 drivers/net/can/sja1000/sja1000.c              |   17 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |    3=20
 drivers/net/ethernet/broadcom/tg3.c            |    4=20
 drivers/net/ethernet/intel/e1000e/e1000.h      |    1=20
 drivers/net/ethernet/intel/e1000e/netdev.c     |   48 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  |    7=20
 drivers/net/macvlan.c                          |    3=20
 drivers/net/wimax/i2400m/usb-rx.c              |    2=20
 drivers/net/wireless/ath/ath9k/xmit.c          |    8=20
 drivers/net/wireless/b43/Kconfig               |    4=20
 drivers/net/wireless/rt2x00/rt2500usb.c        |    2=20
 drivers/net/wireless/rt2x00/rt2800usb.c        |    2=20
 drivers/net/wireless/rt2x00/rt2x00mac.c        |   22 +-
 drivers/net/wireless/rt2x00/rt73usb.c          |    1=20
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c    |    2=20
 drivers/net/xen-netfront.c                     |   17 +
 drivers/pci/hotplug/shpchp.h                   |    2=20
 drivers/pci/hotplug/shpchp_core.c              |   26 +-
 drivers/pci/hotplug/shpchp_ctrl.c              |   10=20
 drivers/pci/pcie/aspm.c                        |    3=20
 drivers/platform/x86/msi-wmi.c                 |    4=20
 drivers/platform/x86/thinkpad_acpi.c           |    2=20
 drivers/rapidio/devices/tsi721.c               |   11 +
 drivers/regulator/max8997.c                    |   36 +--
 drivers/regulator/max8998.c                    |    2=20
 drivers/rtc/rtc-pl031.c                        |   10=20
 drivers/staging/octeon/ethernet-tx.c           |    2=20
 drivers/staging/speakup/speakup_soft.c         |    2=20
 drivers/staging/zram/zram_drv.c                |   38 ++-
 drivers/staging/zram/zram_sysfs.c              |    6=20
 drivers/tty/n_gsm.c                            |   78 +++----
 drivers/tty/serial/imx.c                       |   18 -
 drivers/usb/class/cdc-acm.c                    |   28 ++
 drivers/usb/gadget/at91_udc.c                  |   10=20
 drivers/usb/serial/cp210x.c                    |    1=20
 drivers/usb/serial/ftdi_sio.c                  |   33 +++
 drivers/usb/serial/ftdi_sio_ids.h              |   37 +++
 drivers/usb/serial/io_ti.c                     |   50 +++-
 drivers/usb/serial/option.c                    |   83 +++++++-
 drivers/usb/serial/sierra.c                    |    1=20
 drivers/usb/storage/shuttle_usbat.c            |    2=20
 drivers/usb/storage/unusual_devs.h             |   14 +
 drivers/video/backlight/atmel-pwm-bl.c         |    3=20
 drivers/video/console/vgacon.c                 |   17 +
 fs/cachefiles/rdwr.c                           |    2=20
 fs/cifs/cifsfs.c                               |   24 ++
 fs/cifs/cifsfs.h                               |    4=20
 fs/cifs/cifssmb.c                              |    8=20
 fs/cifs/file.c                                 |    8=20
 fs/ecryptfs/keystore.c                         |    3=20
 fs/nfs/callback_xdr.c                          |    6=20
 fs/nfs/nfs4proc.c                              |   23 --
 fs/nfs/nfs4state.c                             |   14 +
 fs/nfs/pnfs.c                                  |   19 +
 fs/nfsd/nfs4acl.c                              |   17 -
 fs/nfsd/nfs4proc.c                             |    8=20
 fs/nfsd/nfs4state.c                            |   15 +
 fs/nfsd/nfs4xdr.c                              |    2=20
 fs/nfsd/vfs.c                                  |    5=20
 fs/posix_acl.c                                 |    6=20
 fs/stat.c                                      |    5=20
 include/drm/drm_mode.h                         |    2=20
 include/linux/compiler-intel.h                 |    2=20
 include/linux/efi.h                            |   16 +
 include/linux/ftrace.h                         |    2=20
 include/linux/list.h                           |   16 +
 include/linux/mm_types.h                       |    1=20
 include/linux/net.h                            |   23 ++
 include/linux/perf_event.h                     |   12 -
 include/linux/skbuff.h                         |   12 +
 include/net/ip6_route.h                        |    5=20
 include/net/mac80211.h                         |    5=20
 include/trace/events/module.h                  |    2=20
 include/xen/interface/io/netif.h               |    1=20
 kernel/events/core.c                           |    4=20
 kernel/events/ring_buffer.c                    |   31 ++-
 kernel/futex.c                                 |  239 ++++++++++++++++++--=
---
 kernel/hrtimer.c                               |   30 ++
 kernel/module.c                                |    3=20
 kernel/sched/core.c                            |   35 ++-
 kernel/timer.c                                 |    2=20
 kernel/trace/ftrace.c                          |   98 ++++++---
 kernel/trace/trace.c                           |    6=20
 mm/hugetlb.c                                   |    1=20
 mm/memory-failure.c                            |   15 -
 mm/memory.c                                    |    5=20
 mm/percpu.c                                    |    2=20
 net/core/dev.c                                 |    1=20
 net/core/filter.c                              |    6=20
 net/core/rtnetlink.c                           |   33 ++-
 net/core/skbuff.c                              |   21 +-
 net/ipv4/fib_semantics.c                       |    2=20
 net/ipv4/ip_forward.c                          |    4=20
 net/ipv4/ping.c                                |   15 +
 net/ipv4/route.c                               |    2=20
 net/ipv4/tcp_cubic.c                           |    2=20
 net/ipv6/route.c                               |    5=20
 net/l2tp/l2tp_ppp.c                            |    4=20
 net/mac80211/rx.c                              |    3=20
 net/mac80211/status.c                          |    6=20
 net/sched/act_mirred.c                         |   11 -
 net/sctp/socket.c                              |   42 ++++
 net/wireless/sme.c                             |    3=20
 sound/pci/hda/patch_conexant.c                 |   34 ++-
 sound/soc/codecs/wm8962.c                      |   15 +
 sound/soc/codecs/wm8962.h                      |    4=20
 197 files changed, 2368 insertions(+), 787 deletions(-)

Aaro Koskinen (1):
      drm/nouveau: fix init with agpgart-uninorth

Alan Cox (1):
      dj: memory scribble in logi_dj

Alex Deucher (12):
      drm/radeon: call drm_edid_to_eld when we update the edid
      drm/radeon: fix ATPX detection on non-VGA GPUs
      drm: fix documentation for drm_crtc_set_mode()
      drm/radeon/dce32+: use fractional fb dividers for high clocks
      drm/radeon: add connector table for SAM440ep embedded board
      drm/radeon: add connector table for Mac G4 Silver
      drm/radeon: fix typo in evergreen_mc_resume()
      drm/radeon: use frac fb div on RS780/RS880
      drm/radeon: cleanup properly if mmio mapping fails
      drm/radeon: fix panel scaling with eDP and LVDS bridges
      drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
      drm/radeon: always program the MC on startup

Alex Hung (1):
      thinkpad-acpi: fix issuing duplicated key events for brightness up/do=
wn

Alexander Duyck (1):
      skb: Add inline helper for getting the skb end offset from head

Alexander Stein (1):
      can: c_can: Set reserved bit in IFx_MASK2 to 1 on write

Alexandre Bounine (1):
      rapidio/tsi721: fix bug in MSI interrupt handling

Andy Adamson (1):
      NFSv4 wait on recovery for async session errors

Anthony Iliopoulos (1):
      x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

Axel Lin (2):
      regulator: max8997: Use uV in voltage_map_desc
      regulator: max8998: Ensure enough delay time for max8998_set_voltage_=
buck_time_sel

Bartlomiej Zolnierkiewicz (1):
      pata_at91: fix ata_host_activate() failure handling

Ben Hutchings (5):
      rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init=
()
      efivars: pstore: Do not check size when erasing variable
      efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
      x86/efi: Fix dummy variable buffer allocation
      rapidio/tsi721: Fix interrupt mask when handling MSI

Bjorn Helgaas (1):
      PCI: shpchp: Use per-slot workqueues to avoid deadlock

Bj=F8rn Mork (3):
      usb: option: add Olivetti Olicard 500
      usb: option: add Alcatel L800MA
      usb: option: add and update a number of CMOTech devices

Bodo Stroesser (1):
      ipmi: Fix a race restarting the timer

Brian Norris (1):
      mtd: m25p80: fix allocation size

Bruce Allan (1):
      e1000e: DoS while TSO enabled caused by link partner with small MSS

Carsten Emde (3):
      drm/i915: panel: invert brightness via parameter
      drm/i915: panel: invert brightness via quirk
      drm/i915: panel: invert brightness acer aspire 5734z

Charles Keepax (1):
      ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile

Chen Yucong (1):
      hwpoison, hugetlb: lock_page/unlock_page does not match for handling =
a free hugepage

Chris Wilson (4):
      drm/i915: Close race between processing unpin task and queueing the f=
lip
      drm/i915; Only increment the user-pin-count after successfully pinnin=
g the bo
      drm/i915: Workaround incoherence between fences and LLC across multip=
le CPUs
      drm: Pad drm_mode_get_connector to 64-bit boundary

Christoph Hellwig (1):
      posix_acl: handle NULL ACL in posix_acl_equiv_mode

Christopher Friedt (1):
      drm/vmwgfx: correct fb_fix_screeninfo.line_length

Chuck Lever (1):
      NFS: nfs_getaclargs.acl_len is a size_t

Corey Minyard (1):
      ipmi: Reset the KCS timeout when starting error recovery

Dan Carpenter (1):
      NFSv4.1: integer overflow in decode_cb_sequence_args()

Daniel Borkmann (2):
      net: sctp: wake up all assocs if sndbuf policy is per socket
      net: sctp: test if association is dead in sctp_wake_up_waiters

Daniel Vetter (1):
      drm/i915: dump UTS_RELEASE into the error_state

Daniele Forsi (2):
      usb: storage: shuttle_usbat: fix discs being detected twice
      USB: Nokia 5300 should be treated as unusual dev

Daniele Palmas (1):
      usb: option driver, add support for Telit UE910v2

David Gibson (2):
      rtnetlink: Warn when interface's information won't fit in our packet
      rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF=
 is set

David Henningsson (2):
      ALSA: HDA: Add inverted internal mic quirk for Lenovo S205
      ALSA: hda - Fix oops caused by recent commit "Fix internal mic for Le=
novo Ideapad U300s"

Dirk Behme (1):
      tty: serial: imx: don't reinit clock in imx_setup_ufcr()

Dmitry Petukhov (1):
      l2tp: take PMTU from tunnel UDP socket

Du, Wenkai (1):
      i2c: designware: Mask all interrupts during i2c controller enable

Egbert Eich (1):
      DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.

Eric Dumazet (2):
      ipv6: Limit mtu to 65575 bytes
      net-gro: reset skb->truesize in napi_reuse_skb()

Felix Fietkau (1):
      mac80211: drop spoofed packets in ad-hoc mode

Felix Kaechele (1):
      ALSA: hda - Add inverted internal mic quirk for Lenovo IdeaPad U310

Fenghua Yu (1):
      x86/apic: Disable I/O APIC before shutdown of the local APIC

Florian Westphal (2):
      net: core: don't account for udp header size when computing seglen
      net: ipv4: ip_forward: fix inverted local_df test

Frederic Berat (1):
      n_gsm : Flow control handling in Mux driver

Geert Uytterhoeven (1):
      Documentation: Update stable address in Chinese and Japanese translat=
ions

Gerald Schaefer (1):
      crypto: s390 - Fix aes-xts parameter corruption

Geyslan G. Bem (1):
      ecryptfs: Fix memory leakage in keystore.c

Grant Likely (1):
      drivercore: deferral race condition fix

Greg Kroah-Hartman (1):
      Linux 3.4.92

H. Peter Anvin (3):
      x86, build, icc: Remove uninitialized_var() from compiler-intel.h
      x86, build: Pass in additional -mno-mmx, -mno-sse options
      x86/Sandy Bridge: mark arrays in __init functions as __initconst

Hans de Goede (1):
      ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015=
PX

Haojian Zhuang (1):
      drivers/rtc/rtc-pl031.c: fix the missing operation on enable

Harshula Jayasuriya (1):
      nfsd: nfsd_open: when dentry_open returns an error do not propagate a=
s struct file

Hauke Mehrtens (1):
      b43: ensue that BCMA is "y" when B43 is "y"

Helge Deller (1):
      parisc: fix epoll_pwait syscall on compat kernel

Herbert Xu (1):
      crypto: s390 - Fix aes-cbc IV corruption

Herton Ronaldo Krzesinski (1):
      floppy: properly handle failure on add_disk loop

Horia Geanta (1):
      crypto: caam - add allocation failure handling in SPRINTFCAT macro

Ilia Mirkin (1):
      drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi

Ivan Vecera (1):
      tg3: update rx_jumbo_pending ring param only when jumbo frames are en=
abled

J. Bruce Fields (3):
      nfsd4: warn on finding lockowner without stateid's
      nfsd4: remove lockowner when removing lock stateid
      nfsd4: fix xdr decoding of large non-write compounds

Jakub Kicinski (1):
      ixgbe: fix registration order of driver and DCA nofitication

James Ralston (1):
      ata_piix: Add Device IDs for Intel Lynx Point-LP PCH

Jani Nikula (7):
      drm/i915/sdvo: clean up connectors on intel_sdvo_init() failures
      drm/i915: add missing \n to UTS_RELEASE in the error_state
      drm/i915: add quirk to invert brightness on eMachines G725
      drm/i915: add quirk to invert brightness on eMachines e725
      drm/i915: add quirk to invert brightness on Packard Bell NCL20
      drm/i915: ensure single initialization and cleanup of backlight device
      drm/i915: try not to lose backlight CBLV precision

Jason Wang (2):
      act_mirred: do not drop packets when fails to mirror it
      drivers: hv: switch to use mb() instead of smp_mb()

Jaume Delcl=F2s (1):
      Wireless: rt2x00: Add device id for Sweex LW323 to rt2800usb.c

Jean-Jacques Hiblot (1):
      usb: gadget: at91-udc: fix irq and iomem resource retrieval

Jerome Glisse (1):
      drm/radeon: fix amd afusion gpu setup aka sumo v2

Jiang Liu (3):
      zram: avoid invalid memory access in zram_exit()
      zram: destroy all devices on error recovery path in zram_init()
      zram: avoid access beyond the zram device

Jianyu Zhan (1):
      percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()

Jiri Bohac (1):
      timer: Prevent overflow in apply_slack

Jiri Kosina (1):
      random: fix accounting race condition with lockless irq entropy_count=
 update

Jiri Slaby (1):
      MISC: hpilo, remove pci_disable_device

Joe Lawrence (1):
      PCI/ASPM: Don't touch ASPM if forcibly disabled

Joe Perches (1):
      net: Add net_ratelimited_function and net_<level>_ratelimited macros

Joe Thornber (1):
      dm thin: fix discard corruption

Johan Hovold (3):
      Revert "USB: serial: add usbid for dell wwan card to sierra.c"
      USB: io_ti: fix firmware download on big-endian machines
      backlight: atmel-pwm-bl: fix gpio polarity in remove

Johannes Berg (1):
      cfg80211: check wdev->netdev in connection work

Josef Gajdusek (2):
      hwmon: (emc1403) fix inverted store_hyst()
      hwmon: (emc1403) Support full range of known chip revision numbers

Josh Boyer (2):
      efivars: Disable external interrupt while holding efivars->lock
      efi: be more paranoid about available space when creating variables

Justin Lecher (1):
      fs: cachefiles: add support for large files in filesystem caching

Kinglong Mee (1):
      NFSD: Call ->set_acl with a NULL ACL structure if no entries

Konrad Rzeszutek Wilk (1):
      intel_idle: Don't register CPU notifier if we are not running.

Krzysztof Mazur (1):
      i915: ensure that VGA plane is disabled

Laxman Dewangan (1):
      i2c: tegra: check the clk_prepare_enable() return value

Leon Ma (1):
      hrtimer: Prevent remote enqueue of leftmost timers

Li RongQing (1):
      ipv4: initialise the itag variable in __mkroute_input

Linus Torvalds (3):
      mm: make fixup_user_fault() check the vma access rights too
      x86-64, modify_ldt: Make support for 16-bit segments a runtime option
      VFS: make vfs_fstat() use f[get|put]_light()

Linus Walleij (1):
      drivers/rtc/rtc-pl031.c: restore ST variant functionality

Liu Hua (1):
      ARM: 8012/1: kdump: Avoid overflow when converting pfn to physaddr

Liu Yu (1):
      tcp_cubic: fix the range of delayed_ack

Maia Kozheva (1):
      rt2800usb: Add support for 2001:3c1e (D-Link DWA-125 rev B1) USB Wi-F=
i adapter

Marc Dionne (1):
      HID: logitech: don't use stack based dj_report structures

Marcel Apfelbaum (1):
      PCI: shpchp: Check bridge's secondary (not primary) bus speed

Marcelo Tosatti (1):
      vgacon.c: add cond reschedule points in vgacon_do_font_op

Mateusz Guzik (1):
      cifs: delay super block destruction until all cifsFileInfo objects ar=
e gone

Mathias Krause (1):
      filter: prevent nla extensions to peek beyond the end of the message

Matt Fleming (1):
      x86, efivars: firmware bug workarounds should be in platform code

Matthew Garrett (1):
      Modify UEFI anti-bricking code

Matthieu CASTET (1):
      UBI: erase free PEB with bitflip in EC header

Mauro Carvalho Chehab (1):
      i82975x_edac: Fix dimm label initialization

Maxim Mikityanskiy (1):
      msi-wmi: Fix memory leak

Michael Ulbricht (1):
      USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM dr=
iver

Michele Baldessari (1):
      USB: serial: ftdi_sio: add id for Brainboxes serial cards

Mikulas Patocka (3):
      dm bufio: avoid a possible __vmalloc deadlock
      dm snapshot: add missing module aliases
      dm snapshot: avoid snapshot space leak on crash

Minchan Kim (1):
      zram: Fix deadlock bug in partial read/write

Mizuma, Masayoshi (1):
      mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()

Namhyung Kim (1):
      sched/debug: Limit sd->*_idx range on sysctl

NeilBrown (2):
      md: avoid possible spinning md thread at shutdown.
      md/raid10: fix "enough" function for detecting if array is failed.

Oleg Nesterov (3):
      list: introduce list_next_entry() and list_prev_entry()
      ptrace/x86: Introduce set_task_blockstep() helper
      ptrace/x86: Partly fix set_task_blockstep()->update_debugctlmsr() log=
ic

Oliver Hartkopp (1):
      can: sja1000: fix {pre,post}_irq() handling and IRQ handler return va=
lue

Ondrej Zary (1):
      drm/radeon: Another card with wrong primary dac adj

Paolo Bonzini (1):
      nbd: fsync and kill block device on shutdown

Pavel Shilovsky (1):
      CIFS: Fix error handling in cifs_push_mandatory_locks

Peter Zijlstra (1):
      perf: Fix perf ring buffer memory ordering

Radu Caragea (1):
      x86 get_unmapped_area: Access mmap_legacy_base through mm_struct memb=
er

Randy Dunlap (1):
      x86: fix build error and kconfig for ia32_emulation and binfmt

Rashika Kheria (1):
      Staging: zram: Fix access of NULL pointer

Richard Weinberger (2):
      x86,efi: Check max_size only if it is non-zero.
      x86,efi: Implement efi_no_storage_paranoia parameter

Romain Izard (1):
      trace: module: Maintain a valid user count

Russ Gorby (2):
      n_gsm: avoid accessing freed memory during CMD_FCOFF condition
      n_gsm: replace kfree_skb w/ appropriate dev_* versions

Salva Peir=F3 (1):
      media: media-device: fix infoleak in ioctl media_enum_entities()

Samuel Thibault (1):
      speakup: lower default software speech rate

Seiji Aguchi (2):
      efi_pstore: Check remaining space with QueryVariableInfo() before wri=
ting data
      efi_pstore: Introducing workqueue updating sysfs

Sergey Popovich (1):
      ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation

Sergey Senozhatsky (1):
      zram: allow request end to coincide with disksize

Sergey Vlasov (1):
      efi: Export efi_query_variable_store() for efivars.ko

Seth Forshee (3):
      Input: synaptics - adjust threshold for treating position values as n=
egative
      efivars: Allow disabling use as a pstore backend
      efivars: Add module parameter to disable use as a pstore backend

Shane Huang (1):
      i2c-piix4: Add AMD CZ SMBus device ID

Shiva Krishna Merla (1):
      dm mpath: fix race condition between multipath_dtr and pg_init_done

Stanislaw Gruszka (3):
      rt2x00: fix beaconing on USB
      mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
      ath9k: protect tid->sched check

Steve French (1):
      setfacl removes part of ACL when setting POSIX ACLs to Samba

Steven Rostedt (Red Hat) (3):
      ftrace/module: Hardcode ftrace_module_init() call into load_module()
      ftrace: Check module functions being traced on reload
      tracing: Keep overwrite in sync between regular and snapshot buffers

Stuart Hayes (1):
      hrtimer: Prevent all reprogramming if hang detected

Takashi Iwai (4):
      ALSA: hda - Add stereo-dmic fixup for Acer Aspire One 522
      ALSA: hda/conexant - Correct vendor IDs for new codecs
      ALSA: hda - Add Conexant CX20755/20756/20757 codec IDs
      ALSA: hda - Add support for CX20952

Thomas Gleixner (6):
      futex: Add another early deadlock detection check
      futex: Prevent attaching to kernel threads
      futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr =3D=
=3D uaddr2 in futex_requeue(..., requeue_pi=3D1)
      futex: Validate atomic acquisition in futex_lock_pi_atomic()
      futex: Always cleanup owner tid in unlock_pi
      futex: Make lookup_pi_state more robust

Thomas Hellstrom (1):
      drm/ttm: Fix memory type compatibility check

Thomas Richter (1):
      bonding: Remove debug_fs files when module init fails

Tim Chen (1):
      crypto: crypto_wq - Fix late crypto work queue initialization

Tristan Bruns (1):
      USB: cp210x: Add 8281 (Nanotec Plug & Drive)

Trond Myklebust (2):
      NFSv4.1: Fix a race in pNFS layoutcommit
      NFSv4.1: Handle NFS4ERR_DELAY when resetting the NFSv4.1 session

Victor A. Santos (1):
      USB: Nokia 305 should be treated as unusual dev

Viresh Kumar (1):
      hrtimer: Set expiry time before switch_hrtimer_base()

Vlad Yasevich (1):
      Revert "macvlan : fix checksums error when we are in bridge mode"

Wang, Xiaoming (1):
      net: ipv4: current group_info should be put after using.

Wei Liu (1):
      xen-netfront: reduce gso_max_size to account for max TCP header

Wei Yongjun (1):
      perf: Fix error return code

Weston Andros Adamson (1):
      NFSv4.1: Don't decode skipped layoutgets

Xose Vazquez Perez (1):
      wireless: rt2x00: rt{2500,73}usb.c put back duplicate id

fanchaoting (1):
      nfsd: don't run get_file if nfs4_preprocess_stateid_op return error

libin (1):
      sched/debug: Fix sd->*_idx limit range avoiding overflow

samix.lebsir (1):
      char: n_gsm: remove message filtering for contipated DLCI


--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTk5v8AAoJEDjbvchgkmk+3zUQAKam+cFgCYE1ddMJVSJpXdvz
8tV6ygycMaxjYzJ7qMnlIShCke89CZ2oV5FaxQ8YFt6RP9KGMod1q2nGpjGp5Rfm
Z1fh8tmumh87isaP8Dfn7EzGmEohFNoWgeDVR6D0H/cJekKHve4pz4UGuFcdhx3G
Bx3aOPh3UrmXQgkhMJbDI7NstQXQqF1g2qIQP2kzEDRihFxCuQYTAkQpS6ee/ix6
gl8nWd5WapsZuM6Z3idrCNW5udxx1nbUfiTnFkIPJC9tDGflrcfX+SgLIEcfWoOn
RJAW855YL8ngHcwaRAdwJCgAaezaBb2VRwb1z6Mh2zvGV5FOfUgOCnb/Xm4b7lCJ
vzVgV2JDorWxzpDENku2QFbEGZUvSv807VAH2b9EzVWs+W0YBo56OJtADeSwb0H2
LLqSCO5rL5+4Lki3j5Cg+AxQarnBPvOOxysPmdEIlImh8VKZOviZ4LJsPJzHDT54
JrDbVAbLnEe96FY5sG3zLQ/YKk+TivxdZu7v27F4rQDa1jlYVGYFHqbFUiWk8NCf
DneCY8JAE0QoJeyVJEdpTbklQf+FkLtWPtFYx7A1sBIutPJH/3QCPfPL1BAVR4AZ
sFqYFhzcsP6n1K/fTZU6uA9EOXIxqDk2+Wgvx/7zXpm7vnbLFlG28ePi0hxP58EN
lAbIuzoMx/YKlKQPEsor
=XnFU
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
