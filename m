Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3AQRNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:13:24 -0500
Received: from mail.kernel.org ([198.145.19.201]:36388 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab3AQRNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:13:19 -0500
Date: Thu, 17 Jan 2013 09:13:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.59
Message-ID: <20130117171315.GA29744@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.59 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                             |    2=20
 arch/powerpc/kernel/head_64.S                        |    2=20
 arch/powerpc/kernel/time.c                           |    5=20
 arch/powerpc/kvm/44x_emulate.c                       |    2=20
 arch/x86/kernel/cpu/amd.c                            |   14 +
 drivers/acpi/scan.c                                  |    7=20
 drivers/ata/libata-core.c                            |    1=20
 drivers/ata/libata-eh.c                              |    1=20
 drivers/ata/libata-scsi.c                            |    6=20
 drivers/ata/sata_promise.c                           |   15 +
 drivers/block/aoe/aoe.h                              |    2=20
 drivers/block/aoe/aoeblk.c                           |    5=20
 drivers/firewire/net.c                               |   13 -
 drivers/gpu/drm/i915/i915_reg.h                      |    2=20
 drivers/gpu/drm/i915/intel_display.c                 |    6=20
 drivers/gpu/drm/i915/intel_lvds.c                    |    8=20
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c      |    8=20
 drivers/infiniband/core/netlink.c                    |    2=20
 drivers/infiniband/hw/nes/nes.h                      |    1=20
 drivers/infiniband/hw/nes/nes_hw.c                   |    9=20
 drivers/infiniband/hw/nes/nes_verbs.c                |    9=20
 drivers/md/dm-ioctl.c                                |    8=20
 drivers/mfd/mfd-core.c                               |   15 +
 drivers/net/wimax/i2400m/i2400m-usb.h                |    3=20
 drivers/net/wimax/i2400m/usb.c                       |    6=20
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h |  172 +++++++++-----=
-----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h       |    6=20
 drivers/pci/intel-iommu.c                            |   11 -
 drivers/s390/cio/device_pgid.c                       |   10 -
 drivers/scsi/mvsas/mv_94xx.h                         |   14 -
 drivers/scsi/mvsas/mv_sas.h                          |    2=20
 drivers/scsi/qla2xxx/qla_os.c                        |    4=20
 drivers/staging/comedi/Kconfig                       |    1=20
 drivers/staging/comedi/comedi_fops.c                 |   21 ++
 drivers/staging/comedi/comedidev.h                   |    1=20
 drivers/staging/comedi/drivers.c                     |   34 +--
 drivers/staging/comedi/drivers/comedi_test.c         |    2=20
 drivers/staging/comedi/internal.h                    |    1=20
 drivers/staging/rtl8712/usb_intf.c                   |    2=20
 drivers/staging/speakup/synth.c                      |    4=20
 drivers/staging/vt6656/dpc.c                         |    4=20
 drivers/staging/vt6656/key.c                         |   53 +++--
 drivers/staging/vt6656/key.h                         |    8=20
 drivers/staging/vt6656/mac.c                         |    6=20
 drivers/staging/vt6656/rf.c                          |    3=20
 drivers/staging/vt6656/rxtx.c                        |   18 +
 drivers/staging/vt6656/ttype.h                       |   16 -
 drivers/staging/vt6656/wcmd.c                        |   20 +-
 drivers/staging/vt6656/wpa2.h                        |    4=20
 drivers/target/tcm_fc/tfc_sess.c                     |    2=20
 drivers/usb/class/cdc-acm.c                          |    3=20
 drivers/usb/core/hub.c                               |   12 -
 drivers/usb/gadget/dummy_hcd.c                       |    9=20
 drivers/usb/host/xhci-mem.c                          |    2=20
 drivers/usb/serial/ftdi_sio.c                        |    2=20
 drivers/usb/serial/ftdi_sio_ids.h                    |    6=20
 drivers/usb/serial/option.c                          |   18 +
 drivers/video/mxsfb.c                                |    3=20
 fs/eventpoll.c                                       |   22 ++
 fs/ext4/acl.c                                        |    6=20
 fs/ext4/extents.c                                    |   22 +-
 fs/ext4/super.c                                      |    4=20
 fs/gfs2/lops.c                                       |   18 -
 fs/gfs2/trans.c                                      |    8=20
 fs/jbd2/transaction.c                                |    3=20
 fs/jffs2/nodemgmt.c                                  |    6=20
 fs/udf/inode.c                                       |   11 -
 include/linux/if_link.h                              |    1=20
 include/linux/netlink.h                              |    6=20
 include/linux/rtnetlink.h                            |    3=20
 include/net/rtnetlink.h                              |    7=20
 kernel/trace/ring_buffer.c                           |    2=20
 mm/compaction.c                                      |    6=20
 mm/huge_memory.c                                     |    3=20
 mm/memory.c                                          |   18 +
 mm/page_alloc.c                                      |    2=20
 net/bridge/br_netlink.c                              |   15 +
 net/core/fib_rules.c                                 |    6=20
 net/core/neighbour.c                                 |   11 -
 net/core/rtnetlink.c                                 |  127 +++++++++++---
 net/dcb/dcbnl.c                                      |    4=20
 net/decnet/dn_dev.c                                  |    6=20
 net/decnet/dn_fib.c                                  |    4=20
 net/decnet/dn_route.c                                |    5=20
 net/ipv4/devinet.c                                   |    6=20
 net/ipv4/fib_frontend.c                              |    6=20
 net/ipv4/inet_diag.c                                 |    2=20
 net/ipv4/ipmr.c                                      |    3=20
 net/ipv4/route.c                                     |    2=20
 net/ipv6/addrconf.c                                  |   16 +
 net/ipv6/addrlabel.c                                 |    9=20
 net/ipv6/ip6_fib.c                                   |    3=20
 net/ipv6/ip6mr.c                                     |    3=20
 net/ipv6/route.c                                     |    6=20
 net/mac80211/sta_info.c                              |    2=20
 net/netfilter/ipset/ip_set_core.c                    |    2=20
 net/netfilter/nf_conntrack_netlink.c                 |    4=20
 net/netlink/af_netlink.c                             |   17 +
 net/netlink/genetlink.c                              |    2=20
 net/phonet/pn_netlink.c                              |   13 -
 net/sched/act_api.c                                  |    7=20
 net/sched/cls_api.c                                  |    6=20
 net/sched/sch_api.c                                  |   12 -
 net/sunrpc/sched.c                                   |   27 ++
 net/xfrm/xfrm_user.c                                 |    3=20
 sound/arm/pxa2xx-ac97-lib.c                          |    8=20
 sound/soc/codecs/wm2000.c                            |    4=20
 107 files changed, 730 insertions(+), 385 deletions(-)

Aaron Lu (1):
      libata: set dma_mode to 0xff in reset

Alasdair G Kergon (1):
      dm ioctl: prevent unsafe change to dm_ioctl data_size

Alexander Graf (1):
      KVM: PPC: 44x: fix DCR read/write

Alexey Khoroshilov (1):
      jffs2: hold erase_completion_lock on exit

Andre Przywara (1):
      x86, amd: Disable way access filter on Piledriver CPUs

Anton Blanchard (1):
      powerpc: Fix CONFIG_RELOCATABLE=3Dy CONFIG_CRASH_DUMP=3Dn build

Benjamin Marzinski (1):
      GFS2: Test bufdata with buffer locked and gfs2_log_lock held

Bj=F8rn Mork (2):
      USB: option: blacklist network interface on ZTE MF880
      USB: option: add Telekom Speedstick LTE II

Charles Keepax (1):
      mfd: Only unregister platform devices allocated by the mfd core

Dan Williams (1):
      i2400m: add Intel 6150 device IDs

Daniel Vetter (1):
      Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"

David Jeffery (1):
      SCSI: qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.

David Rientjes (1):
      thp, memcg: split hugepage for memcg oom on cow

Denis N Ladin (1):
      USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"

Dzianis Kahanovich (1):
      USB: option: add Nexpring NP10T terminal id

Ed L. Cashin (1):
      aoe: do not call bdi_init after blk_alloc_queue

Eric Dumazet (1):
      rtnetlink: fix rtnl_calcit() and rtnl_dump_ifinfo()

Eric Wong (1):
      epoll: prevent missed events on EPOLL_CTL_MOD

Eugene Shatokhin (1):
      ext4: fix memory leak in ext4_xattr_set_acl()'s error path

Felix Fietkau (1):
      Revert "ath9k_hw: Update AR9003 high_power tx gain table"

Forrest Liu (1):
      ext4: fix extent tree corruption caused by hole punch

Gabor Juhos (1):
      ath9k: ar9003: fix OTP register offsets for AR9340

Greg Kroah-Hartman (1):
      Linux 3.0.59

Greg Rose (2):
      rtnetlink: Compute and store minimum ifinfo dump size
      rtnetlink: Fix problem with buffer allocation

Ian Abbott (4):
      staging: comedi: prevent auto-unconfig of manually configured devices
      staging: comedi: comedi_test: fix race when cancelling command
      staging: comedi: don't hijack hardware device private data
      staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should select COMEDI_FC

Jan Kara (1):
      jbd2: fix assertion failure in jbd2_journal_flush()

Jason Liu (1):
      mm: compaction: fix echo 1 > compact_memory return error issue

Jerome Glisse (1):
      radeon/kms: force rn50 chip to always report connected on analog outp=
ut

Johannes Berg (1):
      mac80211: use del_timer_sync for final sta cleanup timer deletion

Larry Finger (1):
      staging: r8712u: Add new device ID

Laura Abbott (1):
      mm: use aligned zone start for pfn_to_bitidx calculation

Lothar Wa=DFmann (1):
      video: mxsfb: fix crash when unblanking the display

Malcolm Priestley (6):
      staging: vt6656: [BUG] out of bound array reference in RFbSetPower.
      staging: vt6656: 64 bit fixes: use u32 for QWORD definition.
      staging: vt6656: 64 bit fixes : correct all type sizes
      staging: vt6656: 64 bit fixes: fix long warning messages.
      staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32
      staging: vt6656: 64bit fixes: vCommandTimerWait change calculation of=
 timer.

Mark Brown (1):
      ASoC: wm2000: Fix sense of speech clarity enable

Michael Tokarev (1):
      ext4: do not try to write superblock on ro remount w/o journal

Mikael Pettersson (1):
      sata_promise: fix hardreset lockdep error

Mike Dunn (1):
      ALSA: pxa27x: fix ac97 cold reset

Namjae Jeon (2):
      udf: fix memory leak while allocating blocks during write
      udf: don't increment lenExtents while writing to a hole

Nickolai Zeldovich (1):
      staging: speakup: avoid out-of-range access in synth_init()

Oliver Neukum (1):
      USB: hub: handle claim of enabled remote wakeup after reset

Paulo Zanoni (1):
      drm/i915: make the panel fitter work on pipes B and C on IVB

Quentin.Li (1):
      USB: option: Add new MEDIATEK PID support

Samuel Thibault (1):
      staging: speakup: avoid out-of-range access in synth_add()

Sarah Sharp (2):
      USB: Increase reset timeout.
      xhci: Handle HS bulk/ctrl endpoints that don't NAK.

Sebastian Andrzej Siewior (1):
      usb: gadget: dummy: fix enumeration with g_multi

Sebastian Ott (1):
      s390/cio: fix pgid reserved check

Shan Hai (1):
      powerpc/vdso: Remove redundant locking in update_vsyscall_tz()

Stephan Gatzka (1):
      firewire: net: Fix handling of fragmented multicast/broadcast packets.

Steven Rostedt (1):
      ring-buffer: Fix race between integrity check and readers

Tatyana Nikolova (2):
      RDMA/nes: Fix for crash when registering zero length MR for CQ
      RDMA/nes: Fix for terminate timer crash

Theodore Ts'o (1):
      ext4: lock i_mutex when truncating orphan inodes

Tomasz Mloduchowski (1):
      usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added

Trond Myklebust (1):
      SUNRPC: Ensure that we free the rpc_task after cleanups are done

Woodhouse, David (1):
      intel-iommu: Free old page tables before creating superpage

Xi Wang (1):
      SCSI: mvsas: fix undefined bit shift

Xiaotian Feng (1):
      libata: fix Null pointer dereference on disk error

Yi Zou (1):
      target/tcm_fc: fix the lockdep warning due to inconsistent lock state

Zhang Rui (1):
      ACPI : do not use Lid and Sleep button for S5 wakeup


--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ+DErAAoJEDjbvchgkmk+438P/3C2Aa0AyZBqLWySUv74R07c
JjlitB3xISPV9CXlsDJBOQDAfnvTKuy4VfHaNhIzoyBRXjJjenVW9ftuBb1uEd0Y
0Rw0seoHLK2l+Tuw3QQv+0loWHwAwvPvfTBPJHC2hg3OBqSEM7pSJS7cCz40szmM
yz+FAoq59/tis5zzQ2enM1CXQPWFX3VfAz3eKfO+dJKoJze1SowmpYNHeIK/JnGI
QUMKgnAKU7pz0fdtFoQp4CbCImOga/yqGpRNV7F4AHKIrpCQtc9xK3tyxcP7bkVV
jjJoydHov+4u2oVCsmI+o0BBkJ18W3B7yXXgbFIJPetpo33MDQQqj60KEIR27yr6
cB6botKIe1FwiyoeuaQB41b/Qi567TT/bflWqgk1MLMqxUGo30bAwhfkQx0cbNp6
AK+GoExYnYkyNir/QLEcU5QkaPTm+W8YC3cVcV7oOkIeb0WZXSa8GAFSKtV5sZuZ
Fv2Z4RdSEIdmJXxqpGlHkxRj/X/KZ28qJJetBDPboiBbipYIsnb+e2VtWDxpJNQt
VGNMEN7y4wg5bx1RiisWh+TfoabhliYxru8RzKBgK6LqcrlA9k4QQs604fbhRlco
6L6LKumWzKKzI4AzoI5jhwySB70YZRoUFM/xybkI5yOdEzq2MD4kL7TVxriBNZFd
9gOje57adI2nlANUB0Jh
=sNQ1
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
