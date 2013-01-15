Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab3AOXtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:49:07 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46666 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729Ab3AOXtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:49:03 -0500
MIME-Version: 1.0
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
Date: Tue, 15 Jan 2013 21:49:02 -0200
Message-ID: <CA+MoWDqvdiTTbGa4CXqAkgnToiX2es3r_M=VjBggoWfxOXdxEQ@mail.gmail.com>
Subject: Re: [ 00/71] 3.0.59-stable review
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0.59-rc1+ compile and run nicely with Fedora 17.

On Tue, Jan 15, 2013 at 8:53 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 3.0.59 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jan 17 22:53:26 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.59-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 3.0.59-rc1
>
> Ian Abbott <abbotti@mev.co.uk>
>     staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should select COMEDI_FC
>
> Ian Abbott <abbotti@mev.co.uk>
>     staging: comedi: don't hijack hardware device private data
>
> Daniel Vetter <daniel.vetter@ffwll.ch>
>     Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"
>
> Alexander Graf <agraf@suse.de>
>     KVM: PPC: 44x: fix DCR read/write
>
> Woodhouse, David <david.woodhouse@intel.com>
>     intel-iommu: Free old page tables before creating superpage
>
> Benjamin Marzinski <bmarzins@redhat.com>
>     GFS2: Test bufdata with buffer locked and gfs2_log_lock held
>
> Sarah Sharp <sarah.a.sharp@linux.intel.com>
>     xhci: Handle HS bulk/ctrl endpoints that don't NAK.
>
> Oliver Neukum <oliver@neukum.org>
>     USB: hub: handle claim of enabled remote wakeup after reset
>
> Sarah Sharp <sarah.a.sharp@linux.intel.com>
>     USB: Increase reset timeout.
>
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>     usb: gadget: dummy: fix enumeration with g_multi
>
> Denis N Ladin <denladin@gmail.com>
>     USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"
>
> Tomasz Mloduchowski <q@qdot.me>
>     usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added
>
> Bjørn Mork <bjorn@mork.no>
>     USB: option: add Telekom Speedstick LTE II
>
> Quentin.Li <snowmanli88@163.com>
>     USB: option: Add new MEDIATEK PID support
>
> Bjørn Mork <bjorn@mork.no>
>     USB: option: blacklist network interface on ZTE MF880
>
> Dzianis Kahanovich <mahatma@bspu.unibel.by>
>     USB: option: add Nexpring NP10T terminal id
>
> Johannes Berg <johannes.berg@intel.com>
>     mac80211: use del_timer_sync for final sta cleanup timer deletion
>
> Jerome Glisse <jglisse@redhat.com>
>     radeon/kms: force rn50 chip to always report connected on analog output
>
> Samuel Thibault <samuel.thibault@ens-lyon.org>
>     staging: speakup: avoid out-of-range access in synth_add()
>
> Nickolai Zeldovich <nickolai@csail.mit.edu>
>     staging: speakup: avoid out-of-range access in synth_init()
>
> Larry Finger <Larry.Finger@lwfinger.net>
>     staging: r8712u: Add new device ID
>
> Ian Abbott <abbotti@mev.co.uk>
>     staging: comedi: comedi_test: fix race when cancelling command
>
> Ian Abbott <abbotti@mev.co.uk>
>     staging: comedi: prevent auto-unconfig of manually configured devices
>
> Mike Dunn <mikedunn@newsguy.com>
>     ALSA: pxa27x: fix ac97 cold reset
>
> Mark Brown <broonie@opensource.wolfsonmicro.com>
>     ASoC: wm2000: Fix sense of speech clarity enable
>
> Eric Wong <normalperson@yhbt.net>
>     epoll: prevent missed events on EPOLL_CTL_MOD
>
> Eric Dumazet <eric.dumazet@gmail.com>
>     rtnetlink: fix rtnl_calcit() and rtnl_dump_ifinfo()
>
> Greg Rose <gregory.v.rose@intel.com>
>     rtnetlink: Fix problem with buffer allocation
>
> Greg Rose <gregory.v.rose@intel.com>
>     rtnetlink: Compute and store minimum ifinfo dump size
>
> Zhang Rui <rui.zhang@intel.com>
>     ACPI : do not use Lid and Sleep button for S5 wakeup
>
> Andre Przywara <andre.przywara@amd.com>
>     x86, amd: Disable way access filter on Piledriver CPUs
>
> David Rientjes <rientjes@google.com>
>     thp, memcg: split hugepage for memcg oom on cow
>
> Namjae Jeon <namjae.jeon@samsung.com>
>     udf: don't increment lenExtents while writing to a hole
>
> Namjae Jeon <namjae.jeon@samsung.com>
>     udf: fix memory leak while allocating blocks during write
>
> Ed L. Cashin <ecashin@coraid.com>
>     aoe: do not call bdi_init after blk_alloc_queue
>
> Theodore Ts'o <tytso@mit.edu>
>     ext4: lock i_mutex when truncating orphan inodes
>
> Michael Tokarev <mjt@tls.msk.ru>
>     ext4: do not try to write superblock on ro remount w/o journal
>
> Jan Kara <jack@suse.cz>
>     jbd2: fix assertion failure in jbd2_journal_flush()
>
> Forrest Liu <forrestl@synology.com>
>     ext4: fix extent tree corruption caused by hole punch
>
> Lothar Waßmann <LW@KARO-electronics.de>
>     video: mxsfb: fix crash when unblanking the display
>
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: 64bit fixes: vCommandTimerWait change calculation of timer.
>
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32
>
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: 64 bit fixes: fix long warning messages.
>
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: 64 bit fixes : correct all type sizes
>
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: 64 bit fixes: use u32 for QWORD definition.
>
> Malcolm Priestley <tvboxspy@gmail.com>
>     staging: vt6656: [BUG] out of bound array reference in RFbSetPower.
>
> Alasdair G Kergon <agk@redhat.com>
>     dm ioctl: prevent unsafe change to dm_ioctl data_size
>
> Steven Rostedt <srostedt@redhat.com>
>     ring-buffer: Fix race between integrity check and readers
>
> Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
>     RDMA/nes: Fix for terminate timer crash
>
> Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
>     RDMA/nes: Fix for crash when registering zero length MR for CQ
>
> Paulo Zanoni <paulo.r.zanoni@intel.com>
>     drm/i915: make the panel fitter work on pipes B and C on IVB
>
> Dan Williams <dcbw@redhat.com>
>     i2400m: add Intel 6150 device IDs
>
> Alexey Khoroshilov <khoroshilov@ispras.ru>
>     jffs2: hold erase_completion_lock on exit
>
> Trond Myklebust <Trond.Myklebust@netapp.com>
>     SUNRPC: Ensure we release the socket write lock if the rpc_task exits early
>
> Trond Myklebust <Trond.Myklebust@netapp.com>
>     SUNRPC: Ensure that we free the rpc_task after cleanups are done
>
> Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
>     ext4: fix memory leak in ext4_xattr_set_acl()'s error path
>
> Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
>     mfd: Only unregister platform devices allocated by the mfd core
>
> Yi Zou <yi.zou@intel.com>
>     target/tcm_fc: fix the lockdep warning due to inconsistent lock state
>
> Xiaotian Feng <xtfeng@gmail.com>
>     libata: fix Null pointer dereference on disk error
>
> Aaron Lu <aaron.lu@intel.com>
>     libata: set dma_mode to 0xff in reset
>
> Mikael Pettersson <mikpe@it.uu.se>
>     sata_promise: fix hardreset lockdep error
>
> David Jeffery <djeffery@redhat.com>
>     SCSI: qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.
>
> Xi Wang <xi.wang@gmail.com>
>     SCSI: mvsas: fix undefined bit shift
>
> Stephan Gatzka <stephan.gatzka@gmail.com>
>     firewire: net: Fix handling of fragmented multicast/broadcast packets.
>
> Gabor Juhos <juhosg@openwrt.org>
>     ath9k: ar9003: fix OTP register offsets for AR9340
>
> Felix Fietkau <nbd@openwrt.org>
>     Revert "ath9k_hw: Update AR9003 high_power tx gain table"
>
> Laura Abbott <lauraa@codeaurora.org>
>     mm: use aligned zone start for pfn_to_bitidx calculation
>
> Jason Liu <r64343@freescale.com>
>     mm: compaction: fix echo 1 > compact_memory return error issue
>
> Sebastian Ott <sebott@linux.vnet.ibm.com>
>     s390/cio: fix pgid reserved check
>
> Shan Hai <shan.hai@windriver.com>
>     powerpc/vdso: Remove redundant locking in update_vsyscall_tz()
>
> Anton Blanchard <anton@samba.org>
>     powerpc: Fix CONFIG_RELOCATABLE=y CONFIG_CRASH_DUMP=n build
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                           |   4 +-
>  arch/powerpc/kernel/head_64.S                      |   2 +-
>  arch/powerpc/kernel/time.c                         |   5 -
>  arch/powerpc/kvm/44x_emulate.c                     |   2 +
>  arch/x86/kernel/cpu/amd.c                          |  14 ++
>  drivers/acpi/scan.c                                |   7 +-
>  drivers/ata/libata-core.c                          |   1 +
>  drivers/ata/libata-eh.c                            |   1 +
>  drivers/ata/libata-scsi.c                          |   6 +-
>  drivers/ata/sata_promise.c                         |  15 +-
>  drivers/block/aoe/aoe.h                            |   2 +-
>  drivers/block/aoe/aoeblk.c                         |   5 -
>  drivers/firewire/net.c                             |  13 +-
>  drivers/gpu/drm/i915/i915_reg.h                    |   2 +
>  drivers/gpu/drm/i915/intel_display.c               |   6 +-
>  drivers/gpu/drm/i915/intel_lvds.c                  |   8 -
>  drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |   8 +
>  drivers/infiniband/core/netlink.c                  |   2 +-
>  drivers/infiniband/hw/nes/nes.h                    |   1 +
>  drivers/infiniband/hw/nes/nes_hw.c                 |   9 +-
>  drivers/infiniband/hw/nes/nes_verbs.c              |   9 +-
>  drivers/md/dm-ioctl.c                              |   8 +
>  drivers/mfd/mfd-core.c                             |  15 +-
>  drivers/net/wimax/i2400m/i2400m-usb.h              |   3 +
>  drivers/net/wimax/i2400m/usb.c                     |   6 +
>  .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   | 172 ++++++++++-----------
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |   6 +-
>  drivers/pci/intel-iommu.c                          |  11 +-
>  drivers/s390/cio/device_pgid.c                     |  10 +-
>  drivers/scsi/mvsas/mv_94xx.h                       |  14 +-
>  drivers/scsi/mvsas/mv_sas.h                        |   2 +-
>  drivers/scsi/qla2xxx/qla_os.c                      |   4 +-
>  drivers/staging/comedi/Kconfig                     |   1 +
>  drivers/staging/comedi/comedi_fops.c               |  21 +++
>  drivers/staging/comedi/comedidev.h                 |   1 +
>  drivers/staging/comedi/drivers.c                   |  34 ++--
>  drivers/staging/comedi/drivers/comedi_test.c       |   2 +-
>  drivers/staging/comedi/internal.h                  |   1 +
>  drivers/staging/rtl8712/usb_intf.c                 |   2 +
>  drivers/staging/speakup/synth.c                    |   4 +-
>  drivers/staging/vt6656/dpc.c                       |   4 +-
>  drivers/staging/vt6656/key.c                       |  53 +++++--
>  drivers/staging/vt6656/key.h                       |   8 +-
>  drivers/staging/vt6656/mac.c                       |   6 +-
>  drivers/staging/vt6656/rf.c                        |   3 +
>  drivers/staging/vt6656/rxtx.c                      |  18 ++-
>  drivers/staging/vt6656/ttype.h                     |  16 +-
>  drivers/staging/vt6656/wcmd.c                      |  20 +--
>  drivers/staging/vt6656/wpa2.h                      |   4 +-
>  drivers/target/tcm_fc/tfc_sess.c                   |   2 +-
>  drivers/usb/class/cdc-acm.c                        |   3 +
>  drivers/usb/core/hub.c                             |  12 +-
>  drivers/usb/gadget/dummy_hcd.c                     |   9 +-
>  drivers/usb/host/xhci-mem.c                        |   2 +
>  drivers/usb/serial/ftdi_sio.c                      |   2 +
>  drivers/usb/serial/ftdi_sio_ids.h                  |   6 +
>  drivers/usb/serial/option.c                        |  18 ++-
>  drivers/video/mxsfb.c                              |   3 +-
>  fs/eventpoll.c                                     |  22 ++-
>  fs/ext4/acl.c                                      |   6 +-
>  fs/ext4/extents.c                                  |  22 ++-
>  fs/ext4/super.c                                    |   4 +-
>  fs/gfs2/lops.c                                     |  18 +--
>  fs/gfs2/trans.c                                    |   8 +
>  fs/jbd2/transaction.c                              |   3 +-
>  fs/jffs2/nodemgmt.c                                |   6 +-
>  fs/udf/inode.c                                     |  11 +-
>  include/linux/if_link.h                            |   1 +
>  include/linux/netlink.h                            |   6 +-
>  include/linux/rtnetlink.h                          |   3 +
>  include/net/rtnetlink.h                            |   7 +-
>  kernel/trace/ring_buffer.c                         |   2 +
>  mm/compaction.c                                    |   6 +-
>  mm/huge_memory.c                                   |   3 +
>  mm/memory.c                                        |  18 ++-
>  mm/page_alloc.c                                    |   2 +-
>  net/bridge/br_netlink.c                            |  15 +-
>  net/core/fib_rules.c                               |   6 +-
>  net/core/neighbour.c                               |  11 +-
>  net/core/rtnetlink.c                               | 127 ++++++++++++---
>  net/dcb/dcbnl.c                                    |   4 +-
>  net/decnet/dn_dev.c                                |   6 +-
>  net/decnet/dn_fib.c                                |   4 +-
>  net/decnet/dn_route.c                              |   5 +-
>  net/ipv4/devinet.c                                 |   6 +-
>  net/ipv4/fib_frontend.c                            |   6 +-
>  net/ipv4/inet_diag.c                               |   2 +-
>  net/ipv4/ipmr.c                                    |   3 +-
>  net/ipv4/route.c                                   |   2 +-
>  net/ipv6/addrconf.c                                |  16 +-
>  net/ipv6/addrlabel.c                               |   9 +-
>  net/ipv6/ip6_fib.c                                 |   3 +-
>  net/ipv6/ip6mr.c                                   |   3 +-
>  net/ipv6/route.c                                   |   6 +-
>  net/mac80211/sta_info.c                            |   2 +-
>  net/netfilter/ipset/ip_set_core.c                  |   2 +-
>  net/netfilter/nf_conntrack_netlink.c               |   4 +-
>  net/netlink/af_netlink.c                           |  17 +-
>  net/netlink/genetlink.c                            |   2 +-
>  net/phonet/pn_netlink.c                            |  13 +-
>  net/sched/act_api.c                                |   7 +-
>  net/sched/cls_api.c                                |   6 +-
>  net/sched/sch_api.c                                |  12 +-
>  net/sunrpc/sched.c                                 |  30 +++-
>  net/sunrpc/xprt.c                                  |  12 +-
>  net/xfrm/xfrm_user.c                               |   3 +-
>  sound/arm/pxa2xx-ac97-lib.c                        |   8 +-
>  sound/soc/codecs/wm2000.c                          |   4 +-
>  108 files changed, 742 insertions(+), 390 deletions(-)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Peter
