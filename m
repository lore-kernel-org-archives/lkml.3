Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3CFNgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:36:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54672 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755065Ab3CFNgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:36:36 -0500
Message-ID: <1362576982.3768.420.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.40
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 06 Mar 2013 13:36:22 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-B81KU+1Yr4v6FJc+Rhu9"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B81KU+1Yr4v6FJc+Rhu9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.40 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Documentation/kernel-parameters.txt              |    5 +
 Makefile                                         |    2 +-
 arch/arm/mach-pxa/include/mach/smemc.h           |    1 +
 arch/arm/mach-pxa/smemc.c                        |   15 +-
 arch/arm/mach-s3c2410/include/mach/debug-macro.S |   12 +-
 arch/arm/mach-s3c2410/include/mach/entry-macro.S |    4 +-
 arch/arm/mach-s3c2410/pm-h1940.S                 |    2 +-
 arch/arm/mach-s3c2410/sleep.S                    |   12 +-
 arch/arm/mach-s3c2412/sleep.S                    |   12 +-
 arch/arm/mach-w90x900/include/mach/entry-macro.S |    4 +-
 arch/arm/plat-samsung/include/plat/debug-macro.S |   18 +-
 arch/parisc/include/asm/pgtable.h                |   13 +-
 arch/parisc/kernel/cache.c                       |   18 ++
 arch/powerpc/include/asm/eeh.h                   |    3 +
 arch/powerpc/kernel/machine_kexec_64.c           |    5 +
 arch/powerpc/kernel/of_platform.c                |    3 +
 arch/powerpc/kernel/pci-common.c                 |    7 +-
 arch/powerpc/platforms/pseries/eeh.c             |   24 ++-
 arch/s390/kernel/time.c                          |    3 +
 arch/s390/kvm/kvm-s390.c                         |    8 +
 arch/x86/Kconfig                                 |    2 +-
 arch/x86/include/asm/pgtable.h                   |    5 +
 arch/x86/kernel/apic/x2apic_phys.c               |   17 +-
 arch/x86/kernel/cpu/mshyperv.c                   |    3 +-
 arch/x86/kernel/head.c                           |   53 +++--
 arch/x86/mm/fault.c                              |    8 +-
 arch/x86/mm/init_64.c                            |    3 +
 arch/x86/platform/efi/efi.c                      |   59 +++---
 arch/x86/xen/spinlock.c                          |    1 -
 block/genhd.c                                    |   15 +-
 drivers/acpi/sleep.c                             |    8 +
 drivers/ata/ata_piix.c                           |   35 ++++
 drivers/base/bus.c                               |    4 +-
 drivers/block/nbd.c                              |   10 +
 drivers/block/sunvdc.c                           |    2 +-
 drivers/block/xen-blkback/xenbus.c               |   49 +++--
 drivers/dca/dca-core.c                           |    5 +
 drivers/firewire/core-device.c                   |    4 +
 drivers/gpu/drm/drm_edid.c                       |    6 +-
 drivers/gpu/drm/drm_usb.c                        |    2 +-
 drivers/gpu/drm/i915/i915_debugfs.c              |    2 +-
 drivers/gpu/drm/i915/intel_display.c             |   12 +-
 drivers/gpu/drm/radeon/evergreen.c               |    2 +
 drivers/hid/hid-core.c                           |    1 +
 drivers/hid/hid-ids.h                            |    3 +
 drivers/iommu/intel-iommu.c                      |    8 +-
 drivers/media/rc/rc-main.c                       |    5 +-
 drivers/media/video/omap/omap_vout.c             |   12 +-
 drivers/media/video/v4l2-device.c                |   30 ++-
 drivers/mmc/host/sdhci-esdhc-imx.c               |   19 +-
 drivers/net/ethernet/intel/igb/igb_main.c        |    8 +-
 drivers/net/wireless/b43/dma.h                   |    2 +-
 drivers/net/wireless/p54/p54usb.c                |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c      |    9 +-
 drivers/net/wireless/rtlwifi/usb.c               |   49 +++--
 drivers/net/wireless/rtlwifi/usb.h               |    3 +-
 drivers/net/xen-netback/interface.c              |    3 +-
 drivers/net/xen-netback/netback.c                |    8 +-
 drivers/pci/remove.c                             |    2 +
 drivers/pcmcia/vrc4171_card.c                    |    1 +
 drivers/platform/x86/asus-laptop.c               |   17 +-
 drivers/pps/clients/pps-ldisc.c                  |   10 +-
 drivers/pps/pps.c                                |   47 ++++-
 drivers/rtc/rtc-pl031.c                          |    4 +-
 drivers/s390/kvm/kvm_virtio.c                    |   38 +++-
 drivers/staging/comedi/comedi_fops.c             |   13 +-
 drivers/staging/comedi/drivers/ni_labpc.c        |   35 ++--
 drivers/staging/speakup/speakup_soft.c           |    2 +-
 drivers/staging/zram/zram_drv.c                  |    4 +-
 drivers/target/target_core_device.c              |   13 +-
 drivers/target/target_core_fabric_configfs.c     |   12 +-
 drivers/target/target_core_tpg.c                 |   10 +-
 drivers/tty/serial/8250.c                        |    4 +-
 drivers/tty/tty_ioctl.c                          |    4 +-
 drivers/tty/vt/vt.c                              |  136 ++++++++----
 drivers/usb/core/driver.c                        |   38 ++--
 drivers/usb/core/hub.c                           |   10 +-
 drivers/usb/core/quirks.c                        |  151 ++++++++------
 drivers/usb/core/usb.h                           |    4 +
 drivers/usb/host/ehci-omap.c                     |    2 +-
 drivers/usb/serial/ftdi_sio.c                    |   20 +-
 drivers/usb/serial/mct_u232.c                    |   22 +-
 drivers/usb/serial/option.c                      |   16 +-
 drivers/usb/serial/sierra.c                      |    8 +-
 drivers/usb/serial/ssu100.c                      |   19 +-
 drivers/usb/serial/usb-serial.c                  |   15 +-
 drivers/usb/serial/usb_wwan.c                    |    8 +-
 drivers/usb/storage/initializers.c               |    4 +-
 drivers/usb/storage/unusual_cypress.h            |    2 +-
 drivers/vhost/vhost.c                            |    2 +-
 drivers/video/backlight/adp8860_bl.c             |    2 +-
 drivers/video/backlight/adp8870_bl.c             |    2 +-
 drivers/video/console/fbcon.c                    |   47 ++++-
 drivers/video/console/vgacon.c                   |   22 +-
 drivers/video/fbmem.c                            |    9 +-
 drivers/video/fbsysfs.c                          |    3 +
 drivers/xen/evtchn.c                             |   10 +
 drivers/xen/xen-pciback/pciback_ops.c            |   15 +-
 fs/binfmt_em86.c                                 |    1 -
 fs/binfmt_misc.c                                 |    6 -
 fs/binfmt_script.c                               |    4 +-
 fs/block_dev.c                                   |    4 +-
 fs/cachefiles/rdwr.c                             |    2 +-
 fs/direct-io.c                                   |    2 +-
 fs/exec.c                                        |   10 +-
 fs/ext4/balloc.c                                 |    9 +-
 fs/ext4/extents.c                                |  242 ++++++++++++------=
----
 fs/ext4/indirect.c                               |    9 +-
 fs/ext4/inode.c                                  |   11 +-
 fs/ext4/mballoc.c                                |    6 +-
 fs/ext4/mmp.c                                    |    2 +
 fs/ext4/page-io.c                                |    9 +-
 fs/ext4/resize.c                                 |    6 +-
 fs/ext4/xattr.c                                  |   10 +-
 fs/lockd/clntproc.c                              |    3 +
 fs/nfs/blocklayout/blocklayout.c                 |    1 +
 fs/nfs/nfs4proc.c                                |    3 +-
 fs/nfs/objlayout/objio_osd.c                     |    1 +
 fs/nfsd/nfs4state.c                              |    2 +
 fs/notify/inotify/inotify_user.c                 |    4 -
 fs/ocfs2/aops.c                                  |    2 +-
 fs/ocfs2/dlmglue.c                               |    5 +-
 fs/ocfs2/suballoc.c                              |    7 +-
 fs/ocfs2/suballoc.h                              |    2 +-
 fs/ocfs2/xattr.c                                 |    2 +-
 fs/partitions/check.c                            |    2 +-
 fs/pstore/platform.c                             |   35 +++-
 fs/ubifs/orphan.c                                |    5 +-
 fs/ubifs/ubifs.h                                 |    2 +
 include/linux/auto_fs.h                          |   25 +--
 include/linux/binfmts.h                          |    2 -
 include/linux/console.h                          |    2 +
 include/linux/fs.h                               |    2 +
 include/linux/idr.h                              |   11 +
 include/linux/kmod.h                             |    2 +
 include/linux/mmu_notifier.h                     |    1 +
 include/linux/pps_kernel.h                       |   17 +-
 include/linux/pstore.h                           |    8 +
 include/linux/quota.h                            |    1 +
 include/linux/serial_core.h                      |    4 +-
 include/linux/usb/audio.h                        |    6 +-
 include/linux/vt_kern.h                          |    3 +
 include/net/inet6_hashtables.h                   |    8 +-
 include/net/inet_sock.h                          |    1 +
 include/net/ipv6.h                               |   12 ++
 include/target/target_core_device.h              |    2 +-
 kernel/cgroup.c                                  |    8 +
 kernel/cpuset.c                                  |   12 +-
 kernel/hrtimer.c                                 |   36 ++--
 kernel/irq/spurious.c                            |    7 +-
 kernel/kmod.c                                    |   82 ++++++--
 kernel/posix-cpu-timers.c                        |   23 +-
 kernel/posix-timers.c                            |    7 +
 kernel/sysctl_binary.c                           |    3 +-
 kernel/timeconst.pl                              |    6 +-
 kernel/trace/ftrace.c                            |   46 ++--
 kernel/workqueue.c                               |   42 +++-
 lib/idr.c                                        |   51 +++--
 mm/fadvise.c                                     |   18 +-
 mm/mmu_notifier.c                                |  147 +++++++------
 mm/page_alloc.c                                  |   15 +-
 mm/shmem.c                                       |   10 +-
 net/bridge/br_stp_bpdu.c                         |    2 +
 net/ipv4/af_inet.c                               |    9 +-
 net/ipv4/ping.c                                  |    4 +-
 net/sunrpc/svc_xprt.c                            |   15 +-
 sound/drivers/aloop.c                            |    5 +-
 sound/pci/ali5451/ali5451.c                      |    2 +-
 sound/pci/hda/patch_hdmi.c                       |    7 +-
 sound/pci/rme32.c                                |    2 +-
 sound/usb/quirks-table.h                         |    2 +-
 171 files changed, 1634 insertions(+), 866 deletions(-)

Adam Thomas (1):
      UBIFS: fix double free of ubifs_orphan objects

Al Viro (1):
      omap_vout: find_vma() needs ->mmap_sem held

Alan Cox (1):
      fb: rework locking to fix lock ordering on takeover

Alex Deucher (1):
      drm/radeon/evergreen+: wait for the MC to settle after MC blackout

Alexander Duyck (1):
      igb: Remove artificial restriction on RQDPC stat reading

Alexey Klimov (1):
      usb hid quirks for Masterkit MA901 usb radio

Andrea Arcangeli (1):
      mm: mmu_notifier: make the mmu_notifier srcu static

Arnd Bergmann (2):
      ARM: samsung: fix assembly syntax for new gas
      ARM: w90x900: fix legacy assembly syntax

Ashish Sangwan (1):
      ext4: fix hole punch failure when depth is greater than 0

Ben Hutchings (3):
      8250: use correct value for PORT_BRCM_TRUMANAGE
      asus-laptop: Do not call HWRS on init
      Linux 3.2.40

Bjorn Helgaas (1):
      Driver core: treat unregistered bus_types as having no devices

Bj=C3=B8rn Mork (3):
      USB: option: add and update Alcatel modems
      USB: option: add Yota / Megafon M100-1 4g modem
      USB: option: add Huawei "ACM" devices using protocol =3D vendor

Christian Borntraeger (1):
      s390/kvm: Fix store status for ACRS/FPRS

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland A-PRO support

Cornelia Huck (1):
      KVM: s390: Handle hosts not supporting s390-virtio.

Dan Carpenter (1):
      rc: unlock on error in show_protocols()

Daniel Vetter (2):
      Revert "drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S"
      intel/iommu: force writebuffer-flush quirk on Gen 4 Chipsets

Dave Airlie (3):
      vgacon/vt: clear buffer attributes when we load a 512 character font =
(v2)
      fbcon: don't lose the console font across generic->chip driver switch
      drm/usb: bind driver to correct device

Dave Hansen (1):
      x86-32, mm: Rip out x86_32 NUMA remapping code

David Henningsson (1):
      ALSA: hda - hdmi: ELD shouldn't be valid after unplug

David S. Miller (1):
      sunvdc: Fix off-by-one in generic_request().

David Vrabel (2):
      xen-netback: correctly return errors from netbk_count_requests()
      xen-netback: cancel the credit timer when taking the vif down

Denis Efremov (2):
      ALSA: rme32.c irq enabling after spin_lock_irq
      ALSA: ali5451: remove irq enabling in pointer callback

Douglas Bagnall (1):
      Avoid sysfs oops when an rc_dev's raw device is absent

Eric Dumazet (1):
      ipv6: use a stronger hash for tcp

George Spelvin (3):
      pps: Add pps_lookup_dev() function
      pps: Use pps_lookup_dev to reduce ldisc coupling
      pps: Fix a use-after free bug when unregistering a source.

Greg Pearson (1):
      x86/apic: Use x2apic physical mode based on FADT setting

Greg Thelen (1):
      tmpfs: fix use-after-free of mempolicy object

H. Peter Anvin (2):
      timeconst.pl: Eliminate Perl warning
      x86: Make sure we can boot in the case the BDA contains pure garbage

Heiko Carstens (1):
      s390/timer: avoid overflow when programming clock comparator

Helge Deller (1):
      unbreak automounter support on 64-bit kernel with 32-bit userspace (v=
2)

Hugh Dickins (1):
      idr: make idr_get_next() good for rcu_read_lock()

Ian Abbott (4):
      staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors
      staging: comedi: check s->async for poll(), read() and write()
      staging: comedi: ni_labpc: correct differential channel sequence for =
AI commands
      staging: comedi: ni_labpc: set up command4 register *after* command3

Igor Grinberg (1):
      ARM: PXA3xx: program the CSMSADRCFG register

J. Bruce Fields (1):
      svcrpc: make svc_age_temp_xprts enqueue under sv_lock

James Ralston (2):
      ata_piix: Add Device IDs for Intel Lynx Point-LP PCH
      ata_piix: Add Device IDs for Intel Wellsburg PCH

Jan Beulich (2):
      xen-blkback: do not leak mode property
      xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}(=
)

Jan Kara (3):
      ext4: fix possible use-after-free with AIO
      fs: Fix possible use-after-free with AIO
      ocfs2: fix possible use-after-free with AIO

Jani Nikula (1):
      drm/i915: add missing \n to UTS_RELEASE in the error_state

Jean Delvare (1):
      pcmcia/vrc4171: Add missing spinlock init

Jeff Liu (1):
      ocfs2: fix ocfs2_init_security_and_acl() to initialize acl correctly

Jim Somerville (1):
      inotify: remove broken mask checks causing unmount to be EINVAL

Johan Hovold (1):
      USB: serial: fix null-pointer dereferences on disconnect

John David Anglin (1):
      Purge existing TLB entries in set_pte_at and ptep_set_wrprotect

Joseph Salisbury (1):
      ACPI: Add DMI entry for Sony VGN-FW41E_H

Josh Boyer (1):
      USB: usb-storage: unusual_devs update for Super TOP SATA bridge

Junxiao Bi (1):
      ocfs2: unlock super lock if lockres refresh failed

Jussi Kivilinna (1):
      rtlwifi: usb: allocate URB control message setup_packet and data buff=
er separately

Justin Lecher (1):
      fs: cachefiles: add support for large files in filesystem caching

Kees Cook (2):
      x86: Do not leak kernel page mapping locations
      exec: use -ELOOP for max recursion depth

Konrad Rzeszutek Wilk (2):
      doc, xen: Mention 'earlyprintk=3Dxen' in the documentation.
      doc, kernel-parameters: Document 'console=3Dhvc<n>'

Larry Finger (3):
      rtlwifi: rtl8192cu: Fix NULL dereference BUG when using new_id
      rtlwifi: rtl8192cu: Add new USB ID
      b43: Increase number of RX DMA slots

Lars-Peter Clausen (1):
      drivers/video/backlight/adp88?0_bl.c: fix resume

Laurent Pinchart (3):
      v4l: Reset subdev v4l2_dev field to NULL if registration fails
      usb: Add quirk detection based on interface information
      usb: Add USB_QUIRK_RESET_RESUME for all Logitech UVC webcams

Leonid Shatz (1):
      hrtimer: Prevent hrtimer_enqueue_reprogram race

Li Wei (1):
      ipv4: fix a bug in ping_err().

Li Zefan (2):
      cgroup: fix exit() vs rmdir() race
      cpuset: fix cpuset_print_task_mems_allowed() vs rename() race

Linus Torvalds (1):
      mm: fix pageblock bitmap allocation

Linus Walleij (1):
      drivers/rtc/rtc-pl031.c: restore ST variant functionality

Lukas Czerner (3):
      ext4: fix xattr block allocation/release with bigalloc
      ext4: fix free clusters calculation in bigalloc filesystem
      ext4: rewrite punch hole to use ext4_ext_remove_space()

MITSUNARI Shigeo (1):
      fs/block_dev.c: page cache wrongly left invalidated after revalidate_=
disk()

Maciej Sosnowski (1):
      dca: check against empty dca_domains list before unregister provider

Matt Fleming (1):
      x86, efi: Make "noefi" really disable EFI runtime serivces

Mel Gorman (2):
      x86/mm: Check if PUD is large when validating a kernel address
      mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to disc=
ard all pages

Michael S. Tsirkin (1):
      vhost: fix length for cross region descriptor

Mika Kuoppala (1):
      drm/i915: disable shared panel fitter for pipe

Minchan Kim (1):
      zram: Fix deadlock bug in partial read/write

Nicholas Bellinger (2):
      target: Fix lookup of dynamic NodeACLs during cached demo-mode operat=
ion
      target: Add missing mapped_lun bounds checking during make_mappedlun =
setup

Niu Yawei (1):
      ext4: fix race in ext4_mb_add_n_trim()

Olaf Hering (1):
      x86: Hyper-V: register clocksource only if its advertised

Oleg Nesterov (6):
      tty: set_termios/set_termiox should not return -EINTR
      usermodehelper: introduce umh_complete(sub_info)
      usermodehelper: implement UMH_KILLABLE
      usermodehelper: ____call_usermodehelper() doesn't need do_exit()
      kmod: introduce call_modprobe() helper
      kmod: make __request_module() killable

Paolo Bonzini (1):
      nbd: fsync and kill block device on shutdown

Patrik Jakobsson (1):
      drm/i915: Set i9xx sdvo clock limits according to specifications

Paulo Zanoni (1):
      drm: don't add inferred modes for monitors that don't support them

Pawel Moll (1):
      ALSA: usb: Fix Processing Unit Descriptor parsers

Phileas Fogg (1):
      powerpc/kexec: Disable hard IRQ before kexec

Philipp Reisner (1):
      idr: idr_for_each_entry() macro

Rafael J. Wysocki (1):
      PCI/PM: Clean up PME state when removing a device

Robin Holt (1):
      mmu_notifier_unregister NULL Pointer deref and multiple ->release() c=
allouts

Roger Quadros (1):
      USB: ehci-omap: Fix autoloading of module

Sagi Grimberg (1):
      mm: mmu_notifier: have mmu_notifiers use a global SRCU so they may sa=
fely schedule

Samuel Thibault (1):
      speakup: lower default software speech rate

Satoru Takeuchi (1):
      efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" boot =
parameter

Seiji Aguchi (1):
      pstore: Avoid deadlock in panic and emergency-restart path

Seth Heasley (3):
      ata_piix: IDE-mode SATA patch for Intel Lynx Point DeviceIDs
      ata_piix: IDE-mode SATA patch for Intel DH89xxCC DeviceIDs
      ata_piix: IDE-mode SATA patch for Intel Avoton DeviceIDs

Shawn Guo (1):
      mmc: sdhci-esdhc-imx: fix host version read

Stanislaw Gruszka (1):
      posix-cpu-timers: Fix nanosleep task_struct leak

Stefan Bader (1):
      xen: Send spinlock IPI to all waiters

Stephen Hemminger (1):
      bridge: set priority of STP packets

Steven Rostedt (Red Hat) (1):
      ftrace: Call ftrace cleanup module notifier after all other notifiers

Stoney Wang (1):
      x86/apic: Work around boot failure on HP ProLiant DL980 G7 Server sys=
tems

Takashi Iwai (3):
      ALSA: hda - Release assigned pin/cvt at error path of hdmi_pcm_open()
      ALSA: aloop: Fix Oops while PM resume
      fb: Yet another band-aid for fixing lockdep mess

Tejun Heo (6):
      workqueue: consider work function when searching for busy work items
      posix-timer: Don't call idr_find() with out-of-range ID
      idr: fix a subtle bug in idr_get_next()
      block: fix synchronization and limit check in blk_alloc_devt()
      firewire: add minor number range check to fw_device_init()
      idr: fix top layer handling

Thadeu Lima de Souza Cascardo (1):
      powerpc/eeh: Fix crash when adding a device in a slot with DDW

Theodore Ts'o (3):
      ext4: return ENOMEM if sb_getblk() fails
      quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format
      ext4: fix kernel BUG on large-scale rm -rf commands

Thomas Gleixner (1):
      genirq: Avoid deadlock in spurious handling

Tomas Henzl (1):
      block: fix ext_devt_idr handling

Tomasz Guszkowski (1):
      p54usb: corrected USB ID for T-Com Sinus 154 data II

Trond Myklebust (1):
      NLM: Ensure that we resend all pending blocking locks after a reclaim

Wei Liu (1):
      xen: close evtchn port if binding to irq fails

Weston Andros Adamson (1):
      NFSv4.1: Don't decode skipped layoutgets

Xi Wang (1):
      sysctl: fix null checking in bin_dn_node_address()

Xiaowei.Hu (1):
      ocfs2: ac->ac_allow_chain_relink=3D0 won't disable group relink

fanchaoting (1):
      umount oops when remove blocklayoutdriver first

fangxiaozhi (1):
      USB: storage: properly handle the endian issues of idProduct

majianpeng (1):
      nfsd: Fix memleak



--=-B81KU+1Yr4v6FJc+Rhu9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTdGVue/yOyVhhEJAQpx/w//cIu71shR1KYThEwDnUcr90/Qp3NEqjGK
IuleQ7ymyYc6KicaPziW+Q6zGV6qfznno5SGvrASG5/UWN7xd+fZHgjnEONncWPN
eWKrqnlpD3ekBpIRAMBvbcre8gITrUk0iVU3HqQCcBB5Yxc1YLwrSCv3JztA8KL1
kGRIL4ZGU2XjEncbTw/YUaAsG0swbwPJIlfLPIYGjjpnI/OrqeUaFGMW/3DW2CYj
Q8/42E9KrZjOB/W0JgMY9kHzoQgxPnXEKuRxVNHxFRf1HnK/hEkv3XFgC72OCKer
VtjFHeKIDWGMddZjEMta7sq1uTkDdLjQ4xdRc7l+elCf56D5l+M4v+IXeebph8Iz
s33uxIWetdrC9rKotThVAoE5gOcZKlg2O3ZymSY1UL3KZy5xh+RjMVkuwhkj4bhs
I7zUqWYP5SWMhyqWPmOYw2dfJw3uSzkL8LyJMTfUT8YXuOlNjXrwMLX4TKV1aa4k
z2Q52lMkwoI8Zst1gM8fcZTFLBPXz06WPUE99hdmoKOKOq7M+imMPngXrqmu5ghH
CYTVbQAo9lk6y7Bx8KqdsQN7Fd5EyLVclyoOPVuxgm5V+4ezTyNKtfYpoB7s9J/n
mrbRPVvEhaEFdJUgxRk6Be9YupeyIv6fLRWWSr1NCtShloZc/m2F+XjtoUm209Kk
xOzIcSd0UGs=
=0OiG
-----END PGP SIGNATURE-----

--=-B81KU+1Yr4v6FJc+Rhu9--
