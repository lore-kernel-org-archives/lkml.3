Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3LTP5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:57:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3LTP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:57:09 -0500
Date: Fri, 20 Dec 2013 07:57:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.25
Message-ID: <20131220155719.GA23866@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.25 kernel.

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

 Makefile                                           |    2=20
 arch/arm/kernel/process.c                          |    7 +
 arch/arm/kernel/stacktrace.c                       |    2=20
 arch/arm/mach-omap2/omap_hwmod.c                   |   43 ++++++++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   13 --
 arch/arm/mach-pxa/reset.c                          |    8 +
 arch/arm/mach-pxa/tosa.c                           |  102 ++++++++++------=
-----
 arch/mips/mm/dma-default.c                         |   16 ++-
 arch/powerpc/include/asm/pgalloc-32.h              |    6 -
 arch/powerpc/include/asm/pgalloc-64.h              |    6 -
 arch/x86/Makefile                                  |    8 -
 arch/x86/boot/Makefile                             |    6 -
 arch/x86/boot/compressed/Makefile                  |    1=20
 arch/x86/kvm/lapic.c                               |   35 ++++---
 arch/x86/kvm/lapic.h                               |    4=20
 arch/x86/kvm/x86.c                                 |   40 --------
 arch/x86/platform/efi/efi.c                        |    7 -
 arch/x86/realmode/rm/Makefile                      |    3=20
 crypto/algif_hash.c                                |    3=20
 crypto/algif_skcipher.c                            |    3=20
 drivers/gpu/drm/i915/intel_display.c               |    2=20
 drivers/gpu/drm/radeon/r600_hdmi.c                 |    8 -
 drivers/gpu/drm/radeon/si.c                        |   11 +-
 drivers/hwmon/hih6130.c                            |   16 ++-
 drivers/hwmon/lm78.c                               |    2=20
 drivers/hwmon/sis5595.c                            |    2=20
 drivers/hwmon/vt8231.c                             |    2=20
 drivers/hwmon/w83l786ng.c                          |   13 +-
 drivers/input/joystick/xpad.c                      |    1=20
 drivers/input/touchscreen/usbtouchscreen.c         |   22 +++-
 drivers/md/dm-bufio.c                              |    5 +
 drivers/md/dm-delay.c                              |   23 ++--
 drivers/md/dm-snap.c                               |   71 +++++++++++++-
 drivers/md/dm-table.c                              |    5 +
 drivers/md/dm-thin.c                               |    4=20
 drivers/md/persistent-data/dm-array.c              |   10 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |    8 +
 drivers/media/dvb-frontends/af9033.c               |   12 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |    4=20
 drivers/media/i2c/wm8775.c                         |    4=20
 drivers/media/pci/bt8xx/bttv-driver.c              |    3=20
 drivers/media/pci/saa7164/saa7164-core.c           |    4=20
 drivers/media/usb/dvb-usb-v2/af9035.c              |   17 ++-
 drivers/net/ethernet/intel/igb/e1000_phy.c         |    5 -
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   22 ++--
 drivers/net/wireless/iwlwifi/mvm/debugfs.c         |    4=20
 drivers/net/wireless/mwifiex/sta_ioctl.c           |    4=20
 drivers/pci/pci-driver.c                           |   12 +-
 drivers/rtc/rtc-at91rm9200.c                       |    2=20
 drivers/staging/comedi/drivers/amplc_pc263.c       |    3=20
 drivers/staging/comedi/drivers/amplc_pci263.c      |    3=20
 drivers/staging/comedi/drivers/pcmuio.c            |   11 +-
 drivers/staging/comedi/drivers/ssv_dnp.c           |    6 -
 drivers/usb/core/hub.c                             |    5 -
 drivers/usb/dwc3/ep0.c                             |    2=20
 drivers/usb/dwc3/gadget.c                          |    5 -
 drivers/usb/gadget/composite.c                     |    1=20
 drivers/usb/serial/option.c                        |   27 +++++
 drivers/watchdog/sc1200wdt.c                       |    3=20
 fs/btrfs/acl.c                                     |    2=20
 fs/btrfs/inode.c                                   |   47 +++++----
 fs/btrfs/ioctl.c                                   |    3=20
 fs/btrfs/send.c                                    |    4=20
 fs/btrfs/tree-log.c                                |    2=20
 fs/btrfs/volumes.c                                 |    2=20
 fs/nfs/blocklayout/extents.c                       |    2=20
 fs/nfs/nfs4proc.c                                  |    3=20
 fs/nfsd/nfscache.c                                 |    9 +
 fs/xfs/xfs_fsops.c                                 |    6 +
 fs/xfs/xfs_ioctl.c                                 |    3=20
 fs/xfs/xfs_ioctl32.c                               |    3=20
 include/linux/compiler-intel.h                     |    2=20
 include/linux/kexec.h                              |    3=20
 include/sound/memalloc.h                           |    2=20
 include/uapi/sound/compress_offload.h              |    6 -
 kernel/futex.c                                     |    2=20
 kernel/kexec.c                                     |    4=20
 kernel/sched/debug.c                               |    8 +
 kernel/sched/fair.c                                |    2=20
 net/ipv4/udp.c                                     |    3=20
 net/ipv6/ip6_tunnel.c                              |    2=20
 net/mac80211/cfg.c                                 |    3=20
 net/mac80211/rx.c                                  |    3=20
 security/selinux/hooks.c                           |   93 +++++++++++++++-=
---
 sound/pci/hda/hda_generic.c                        |   47 +++++++++
 sound/pci/hda/hda_generic.h                        |    3=20
 sound/pci/hda/patch_analog.c                       |   10 ++
 sound/pci/hda/patch_hdmi.c                         |    5 -
 virt/kvm/kvm_main.c                                |    3=20
 89 files changed, 649 insertions(+), 317 deletions(-)

Alan (1):
      sc1200_wdt: Fix oops

Alan Stern (1):
      usb: dwc3: fix implementation of endpoint wedge

Alex Deucher (2):
      drm/radeon: program DCE2 audio dto just like DCE3
      drm/radeon: fixup bad vram size on SI

Andy Adamson (1):
      NFSv4 wait on recovery for async session errors

Andy Honig (3):
      KVM: Improve create VCPU parameter (CVE-2013-4587)
      KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)
      KVM: x86: Convert vapic synchronization to _cached functions (CVE-201=
3-6368)

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix IEC958 ctl indexes for some simple HDMI devices

Antti Palosaari (3):
      media: af9035: fix broken I2C and USB I/O
      media: af9033: fix broken I2C
      media: af9035: add [0413:6a05] Leadtek WinFast DTV Dongle Dual

Ben Segall (1):
      sched: Avoid throttle_cfs_rq() racing with period_timer stopping

Bob Copeland (1):
      Revert "mac80211: allow disable power save in mesh"

Brian Carnes (1):
      hwmon: (w83l786ng) Fix fan speed control mode setting and reporting

Carolyn Wyborny (1):
      igb: Fix for issue where values could be too high for udelay function.

Christian Engelmayer (1):
      Input: usbtouchscreen - separate report and transmit buffer size hand=
ling

Dan Carpenter (4):
      hwmon: Prevent some divide by zeros in FAN_TO_REG()
      xfs: underflow bug in xfs_attrlist_by_handle()
      media: af9035: unlock on error in af9035_i2c_master_xfer()
      Btrfs: fix access_ok() check in btrfs_ioctl_send()

Dave Chinner (1):
      xfs: growfs overruns AGFL buffer on V4 filesystems

David Sterba (1):
      btrfs: call mnt_drop_write after interrupted subvol deletion

Dmitry Eremin-Solenikov (1):
      ARM: pxa: tosa: fix keys mapping

Fangxiaozhi (Franko) (1):
      USB: option: support new huawei devices

Filipe David Borba Manana (1):
      Btrfs: fix incorrect inode acl reset

Gleb Natapov (1):
      KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376)

Greg Kroah-Hartman (2):
      Revert "net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_N=
OTLAST"
      Linux 3.10.25

Gustavo Zacarias (1):
      USB: serial: option: blacklist interface 1 for Huawei E173s-6

H Hartley Sweeten (2):
      staging: comedi: drivers: use comedi_dio_update_state() for simple ca=
ses
      staging: comedi: ssv_dnp: use comedi_dio_update_state()

H. Peter Anvin (2):
      x86, build: Pass in additional -mno-mmx, -mno-sse options
      x86, build, icc: Remove uninitialized_var() from compiler-intel.h

Hans Verkuil (3):
      media: bttv: don't setup the controls if there are no video devices
      media: wm8775: fix broken audio routing
      cxd2820r_core: fix sparse warnings

Helge Deller (1):
      nfs: fix do_div() warning by instead using sector_div()

Hong H. Pham (1):
      powerpc: Fix PTE page address mismatch in pgtable ctor/dtor

Ian Abbott (1):
      staging: comedi: pcmuio: fix possible NULL deref on detach

Jean Delvare (1):
      hwmon: (w83l768ng) Fix fan speed control range

Jeff Layton (1):
      nfsd: when reusing an existing repcache entry, unhash it first

Jim Quinlan (1):
      MIPS: DMA: For BMIPS5000 cores flush region just like non-coherent R1=
0000

Joe Thornber (2):
      dm array: fix a reference counting bug in shadow_ablock
      dm thin: switch to read only mode if a mapping insert fails

Johannes Berg (2):
      mac80211: don't attempt to reorder multicast frames
      iwlwifi: mvm: check sta_id/drain values in debugfs

Josef Bacik (1):
      Btrfs: fix hole check in log_one_extent

Jos=E9 Miguel Gon=E7alves (1):
      hwmon: HIH-6130: Support I2C bus drivers without I2C_FUNC_SMBUS_QUICK

Julius Werner (1):
      usb: hub: Use correct reset for wedged USB3 devices that are NOTATTAC=
HED

Khalid Aziz (1):
      PCI: Disable Bus Master only on kexec reboot

Konstantin Khlebnikov (2):
      ARM: 7912/1: check stack pointer in get_wchan
      ARM: 7913/1: fix framepointer check in unwind_frame

Linus Pizunski (1):
      drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap

Linus Torvalds (1):
      futex: fix handling of read-only-mapped hugepages

Liu Bo (2):
      Btrfs: fix memory leak of chunks' extent map
      Btrfs: do not run snapshot-aware defragment on error

Mag (1):
      Input: xpad - add signature for Razer Onza Classic Edition

Matthew Garrett (1):
      x86, efi: Don't use (U)EFI time services on 32 bit

Michael Grzeschik (1):
      usb: gadget: composite: reset delayed_status on reset_config

Mike Snitzer (1):
      dm space map metadata: return on failure in sm_metadata_new_block

Mikulas Patocka (4):
      dm bufio: initialize read-only module parameters
      dm snapshot: avoid snapshot space leak on crash
      dm delay: fix a possible deadlock due to shared workqueue
      dm table: fail dm_table_create on dm_round_up overflow

Nicolas Dichtel (1):
      ip6tnl: fix use after free of fb_tnl_dev

Paul Moore (2):
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute=
()

Roger Quadros (2):
      ARM: OMAP3: hwmod data: Don't prevent RESET of USB Host module
      ARM: OMAP2+: hwmod: Fix SOFTRESET logic

Sergei Ianovich (1):
      ARM: pxa: prevent PXA270 occasional reboot freezes

Stefano Panella (1):
      ALSA: memalloc.h - fix wrong truncation of dma_addr_t

Sujith Manoharan (2):
      ath9k: Fix QuickDrop usage
      ath9k: Fix XLNA bias strength

Takashi Iwai (3):
      ALSA: compress: Fix 64bit ABI incompatibility
      ALSA: hda - Add static DAC/pin mapping for AD1986A codec
      ALSA: hda - Mute all aamix inputs as default

Ujjal Roy (1):
      mwifiex: fix memory leak issue for ibss join

Ville Syrj=E4l=E4 (1):
      drm/i915: Fix pipe CSC post offset calculation

Wei Yongjun (1):
      media: saa7164: fix return value check in saa7164_initdev()


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJStGjeAAoJEDjbvchgkmk+vOoP/0GKRwyZGIIsuWNr5433Qajh
4Z5W8X0e7TwQZSSW34RpnTCi7HkAWhNHDVcqK/sH25oEFttvipFi+h3SwTeKb74K
6XkgUgI6ruePtuUThfg9AxQcpm8T+ffucajKcXQqZyYZl04LY/ZtgtnPlX76tSg1
qRIthpNp6Yf9V1O2vSaKGnqwnP2cXJUetrZroAbC+yIWmF/udFPsnuVsvpGWhEJi
WG10vFoAscC8pXNOS8s9TIBKiPzJl35Bam+oHZQ6ETIl73EBTIg0ncwZKsyafuco
07IJDrLVUoXYV9BI4+kbpSnHcWFaaL6akco3a2ixE2ULisE4m1gLJnC+HK6BFnBF
0LJNpcDmMDgvlfVdPQmowfhV7nfRv2n1S5c2AVs0hguj7I32LWpw+fhPEEjg+n31
XLYJ2/W7CSB2h49jwFM5bC+6rUFuTEhUiMtbG9BFEkZvKNtBBmracMgkApLJtOD7
C5eUQQVkPN1+anhSVw/0U30CSU0dQhMW12jKzmn0gbL4mo9m0gizrSJOwasBJI/I
tDPqhKGwSdHfLG57p7Qj705A0kgIcoDtCQ8CLnF7cOpQXn9KAiworVTDZsIIi2Uy
VHC/X+LtarBRRf0kC5rlaiWSZI/bpUt7vNupwsRylXLmEUe8Y7cGneRfJNIpv/5t
4PkvQJOB26CsPbmtzmPN
=oxrM
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
