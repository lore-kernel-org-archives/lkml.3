Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3CZXvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:51:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3CZWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/98] 3.8.5-stable review
Date: Tue, 26 Mar 2013 15:41:49 -0700
Message-Id: <20130326224242.449070940@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.8.5 release.
There are 98 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Mar 28 22:41:38 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.8.5-rc1

Felix Fietkau <nbd@openwrt.org>
    rt2x00: error in configurations with mesh support disabled

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: DMA-mapping: add missing GFP_DMA flag for atomic buffer allocation

Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
    usb: musb: da8xx: Fix build breakage due to typo

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix get_icount for two port adapters

Johan Hovold <jhovold@gmail.com>
    USB: garmin_gps: fix memory leak on disconnect

Jan Kara <jack@suse.cz>
    udf: Fix bitmap overflow on large filesystems with small block size

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: Rework acpi_get_child() to be more efficient

Ben Hutchings <ben@decadent.org.uk>
    efivars: Fix check for CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE

Seth Forshee <seth.forshee@canonical.com>
    efivars: Add module parameter to disable use as a pstore backend

Seth Forshee <seth.forshee@canonical.com>
    efivars: Allow disabling use as a pstore backend

Johan Hovold <jhovold@gmail.com>
    USB: serial: fix interface refcounting

Andrzej Pietrasiewicz <andrzej.p@samsung.com>
    usb: gadget: ffs: fix enable multiple instances

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: fix regression in QH unlinking

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: fix regression during bus resume

Johan Hovold <jhovold@gmail.com>
    USB: cdc-acm: fix device unregistration

Hannes Reinecke <hare@suse.de>
    USB: xhci: correctly enable interrupts

Dmitry Torokhov <dtor@vmware.com>
    USB: xhci - fix bit definitions for IMAN register

CQ Tang <cq.tang@intel.com>
    x86-64: Fix the failure case in copy_user_handle_tail()

Mark Rutland <mark.rutland@arm.com>
    clockevents: Don't allow dummy broadcast timers

Kent Overstreet <koverstreet@google.com>
    nfsd: fix bad offset use

NeilBrown <neilb@suse.de>
    md/raid5: ensure sync and DISCARD don't happen at the same time.

Jonathan Brassow <jbrassow@redhat.com>
    MD RAID5: Avoid accessing gendisk or queue structs when not available

NeilBrown <neilb@suse.de>
    md/raid5: schedule_construction should abort if nothing to do.

Takahisa Tanaka <mc74hc00@gmail.com>
    watchdog: sp5100_tco: Remove code that may cause a boot failure

Takahisa Tanaka <mc74hc00@gmail.com>
    watchdog: sp5100_tco: Set the AcpiMmioSel bitmask value to 1 instead of 2

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IPoIB: Fix send lockup due to missed TX completion

Theodore Ts'o <tytso@mit.edu>
    ext4: fix data=journal fast mount/umount hang

Lukas Czerner <lczerner@redhat.com>
    ext4: use s_extent_max_zeroout_kb value as number of kb

Theodore Ts'o <tytso@mit.edu>
    ext4: use atomic64_t for the per-flexbg free_clusters count

Dmitry Artamonow <mad_soft@inbox.ru>
    usb-storage: add unusual_devs entry for Samsung YP-Z3 mp3 player

Zheng Liu <wenqing.lz@taobao.com>
    ext4: fix the wrong number of the allocated blocks in ext4_split_extent()

Jan Kara <jack@suse.cz>
    jbd2: fix use after free in jbd2_journal_dirty_metadata()

Jeff Layton <jlayton@redhat.com>
    cifs: ignore everything in SPNEGO blob after mechTypes

Mateusz Guzik <mguzik@redhat.com>
    cifs: delay super block destruction until all cifsFileInfo objects are gone

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/benchmark: make sure bo blit copy exists before using it

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix backend map setup on 1 RB trinity boards

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix S/R on VM systems (cayman/TN/SI)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add support for Richland APUs

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add Richland pci ids

Julia Lemire <jlemire@matrox.com>
    drm/mgag200: Bug fix: Modified pll algorithm for EH project

Mikulas Patocka <mpatocka@redhat.com>
    dm verity: avoid deadlock

Joe Thornber <ejt@redhat.com>
    dm thin: fix discard corruption

Laxman Dewangan <ldewangan@nvidia.com>
    ARM: tegra: fix register address of slink controller

Nicholas Bellinger <nab@linux-iscsi.org>
    target/file: Bump FD_MAX_SECTORS to 2048 to handle 1M sized I/Os

Andy Grover <agrover@redhat.com>
    target/iscsi: Fix mutual CHAP auth on big-endian arches

Vladimir Davydov <vdavydov@parallels.com>
    mqueue: sys_mq_open: do not call mnt_drop_write() if read-only

H Hartley Sweeten <hartleys@visionengravers.com>
    drivers/video/ep93xx-fb.c: include <linux/io.h> for devm_ioremap()

Wanpeng Li <liwanp@linux.vnet.ibm.com>
    mm/hugetlb: fix total hugetlbfs pages count when using memory overcommit accouting

Nicolas Ferre <nicolas.ferre@atmel.com>
    drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR

Torsten Duwe <torsten@lst.de>
    KMS: fix EDID detailed timing frame rate

Torsten Duwe <torsten@lst.de>
    KMS: fix EDID detailed timing vsync parsing

Laxman Dewangan <ldewangan@nvidia.com>
    i2c: tegra: check the clk_prepare_enable() return value

Daniel Vetter <daniel.vetter@ffwll.ch>
    Revert "drm/i915: write backlight harder"

Kees Cook <keescook@chromium.org>
    drm/i915: bounds check execbuffer relocation count

Bing Zhao <bzhao@marvell.com>
    mwifiex: fix potential out-of-boundary access to ibss rate table

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix problem that prevents reassociation

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix schedule while atomic bug splat

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Keep overwrite in sync between regular and snapshot buffers

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Protect tracer flags with trace_types_lock

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Fix free of probe entry by calling call_rcu_sched()

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Fix race in snapshot swapping

Kees Cook <keescook@chromium.org>
    drm/i915: restrict kernel address leak in debugfs

Takashi Iwai <tiwai@suse.de>
    Revert "drm/i915: try to train DP even harder"

Linus Torvalds <torvalds@linux-foundation.org>
    vfs,proc: guarantee unique inodes in /proc

Al Viro <viro@zeniv.linux.org.uk>
    saner proc_get_inode() calling conventions

Daniel Mack <zonque@gmail.com>
    ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()

Daniel Mack <zonque@gmail.com>
    ALSA: snd-usb: mixer: propagate errors up the call chain

Torstein Hegge <hegge@resisty.net>
    ALSA: usb: Parse UAC2 extension unit like for UAC1

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix typo in checking IEC958 emphasis bit

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/cirrus - Fix the digital beep registration

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Only use TX push if a single descriptor is to be written

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Disable soft interrupt handling during efx_device_detach_sync()

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Detach net device when stopping queues for reconfiguration

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Fix efx_rx_buf_offset() in the presence of swiotlb

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Properly sync RX DMA buffer when it is not the last in the page

Julia Lawall <Julia.Lawall@lip6.fr>
    drivers/net/ethernet/sfc/ptp.c: adjust duplicate test

Hannes Frederic Sowa <hannes@stressinduktion.org>
    inet: limit length of fragment queue hash table bucket lists

Eric Dumazet <edumazet@google.com>
    tcp: dont handle MTU reduction on LISTEN socket

Maciej Żenczykowski <maze@google.com>
    bnx2x: fix occasional statistics off-by-4GB error

Michael S. Tsirkin <mst@redhat.com>
    vhost/net: fix heads usage of ubuf_info

Michal Schmidt <mschmidt@redhat.com>
    bnx2x: add missing napi deletion in error path

Bjørn Mork <bjorn@mork.no>
    net: cdc_ncm, cdc_mbim: allow user to prefer NCM for backwards compatibility

Vlad Yasevich <vyasevic@redhat.com>
    rtnetlink: Mask the rta_type when range checking

Timo Teräs <timo.teras@iki.fi>
    Revert "ip_gre: make ipgre_tunnel_xmit() not parse network header as IP unconditionally"

Pavel Emelyanov <xemul@parallels.com>
    skb: Propagate pfmemalloc on skb from head page only

Eric Dumazet <edumazet@google.com>
    tcp: fix skb_availroom()

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: set correct altsetting for Gobi 1K devices

Denis V. Lunev <den@openvz.org>
    ipv4: fix definition of FIB_TABLE_HASHSZ

Xufeng Zhang <xufeng.zhang@windriver.com>
    sctp: don't break the loop while meeting the active_path so as to find the matched transport

Vlad Yasevich <vyasevich@gmail.com>
    sctp: Use correct sideffect command in duplicate cookie handling

Nithin Sujir <nsujir@broadcom.com>
    tg3: 5715 does not link up when autoneg off

Veaceslav Falico <vfalico@redhat.com>
    bonding: don't call update_speed_duplex() under spinlocks

Marek Lindner <lindner_marek@yahoo.de>
    batman-adv: verify tt len does not exceed packet len

Veaceslav Falico <vfalico@redhat.com>
    netconsole: don't call __netpoll_cleanup() while atomic

stephen hemminger <stephen@networkplumber.org>
    bridge: reserve space for IFLA_BRPORT_FAST_LEAVE

David Ward <david.ward@ll.mit.edu>
    net/ipv4: Ensure that location of timestamp option is stored

Tkhai Kirill <tkhai@yandex.ru>
    sunsu: Fix panic in case of nonexistent port at "console=ttySY" cmdline option

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: work around silicon bug in Intel's EHCI controllers


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/arm/boot/dts/tegra20.dtsi                    |   2 +-
 arch/arm/boot/dts/tegra30.dtsi                    |   2 +-
 arch/arm/mm/dma-mapping.c                         |   5 +-
 arch/x86/lib/usercopy_64.c                        |   4 +-
 drivers/acpi/glue.c                               |  35 +++---
 drivers/firmware/Kconfig                          |  18 ++++
 drivers/firmware/efivars.c                        |  70 +++++-------
 drivers/gpu/drm/drm_edid.c                        |   3 +-
 drivers/gpu/drm/i915/i915_debugfs.c               |   2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c        |  11 +-
 drivers/gpu/drm/i915/intel_dp.c                   |   2 +-
 drivers/gpu/drm/i915/intel_panel.c                |  13 +--
 drivers/gpu/drm/mgag200/mgag200_mode.c            |  10 +-
 drivers/gpu/drm/radeon/ni.c                       |  33 ++++--
 drivers/gpu/drm/radeon/radeon_benchmark.c         |  16 +--
 drivers/gpu/drm/radeon/si.c                       |   1 +
 drivers/i2c/busses/i2c-tegra.c                    |  13 ++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c           |   8 +-
 drivers/md/dm-bufio.c                             |   2 +
 drivers/md/dm-thin.c                              |   4 +-
 drivers/md/dm-verity.c                            |  39 ++++++-
 drivers/md/persistent-data/dm-btree-remove.c      |  46 ++++----
 drivers/md/raid5.c                                | 116 ++++++++++++++------
 drivers/md/raid5.h                                |   1 +
 drivers/net/bonding/bond_main.c                   |   6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h |   3 +-
 drivers/net/ethernet/broadcom/tg3.c               |   8 ++
 drivers/net/ethernet/sfc/efx.c                    |  16 ++-
 drivers/net/ethernet/sfc/efx.h                    |   4 +-
 drivers/net/ethernet/sfc/net_driver.h             |   4 +-
 drivers/net/ethernet/sfc/nic.c                    |   3 +-
 drivers/net/ethernet/sfc/ptp.c                    |   2 +-
 drivers/net/ethernet/sfc/rx.c                     |  25 +++--
 drivers/net/netconsole.c                          |  15 +--
 drivers/net/usb/cdc_mbim.c                        |  11 +-
 drivers/net/usb/cdc_ncm.c                         |  49 ++++++---
 drivers/net/usb/qmi_wwan.c                        |  49 +++------
 drivers/net/wireless/mwifiex/join.c               |   7 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c           |   2 +
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c       |  89 ++++++---------
 drivers/rtc/rtc-at91rm9200.c                      |  50 +++++----
 drivers/rtc/rtc-at91rm9200.h                      |   1 -
 drivers/target/iscsi/iscsi_target_auth.c          |   5 +-
 drivers/target/target_core_file.h                 |   2 +-
 drivers/tty/serial/sunsu.c                        |  21 ++--
 drivers/usb/class/cdc-acm.c                       |   3 +-
 drivers/usb/core/hcd-pci.c                        |  23 ++--
 drivers/usb/gadget/g_ffs.c                        |   4 +-
 drivers/usb/host/ehci-hcd.c                       |   7 +-
 drivers/usb/host/ehci-hub.c                       |   2 +-
 drivers/usb/host/ehci-q.c                         |  31 +++++-
 drivers/usb/host/ehci-timer.c                     |   2 +-
 drivers/usb/host/xhci.c                           |   3 +-
 drivers/usb/host/xhci.h                           |   4 +-
 drivers/usb/musb/da8xx.c                          |   2 +-
 drivers/usb/serial/garmin_gps.c                   |   7 +-
 drivers/usb/serial/io_ti.c                        |   1 +
 drivers/usb/serial/usb-serial.c                   |   3 +-
 drivers/usb/storage/unusual_devs.h                |   7 ++
 drivers/vhost/net.c                               |   3 +-
 drivers/video/ep93xx-fb.c                         |   1 +
 drivers/watchdog/sp5100_tco.c                     | 126 ++--------------------
 drivers/watchdog/sp5100_tco.h                     |   2 +-
 fs/cifs/asn1.c                                    |  53 +--------
 fs/cifs/cifsfs.c                                  |  24 +++++
 fs/cifs/cifsfs.h                                  |   4 +
 fs/cifs/file.c                                    |   6 +-
 fs/ext4/ext4.h                                    |   6 +-
 fs/ext4/extents.c                                 |   8 +-
 fs/ext4/ialloc.c                                  |   4 +-
 fs/ext4/inode.c                                   |   3 +-
 fs/ext4/mballoc.c                                 |  12 +--
 fs/ext4/resize.c                                  |   4 +-
 fs/ext4/super.c                                   |   4 +-
 fs/jbd2/transaction.c                             |  15 ++-
 fs/nfsd/vfs.c                                     |   3 +-
 fs/proc/generic.c                                 |  21 ++--
 fs/proc/inode.c                                   |  12 +--
 fs/udf/udf_sb.h                                   |   2 +-
 include/drm/drm_pciids.h                          |  13 ++-
 include/linux/skbuff.h                            |  13 ++-
 include/linux/usb/cdc_ncm.h                       |   1 +
 include/net/inet_frag.h                           |   9 ++
 include/net/ip_fib.h                              |  12 +--
 ipc/mqueue.c                                      |   3 +-
 kernel/time/tick-broadcast.c                      |   3 +-
 kernel/trace/ftrace.c                             |   4 +-
 kernel/trace/trace.c                              |  21 ++--
 mm/hugetlb.c                                      |   8 +-
 net/batman-adv/bat_iv_ogm.c                       |   6 +-
 net/bridge/br_netlink.c                           |   1 +
 net/core/rtnetlink.c                              |   2 +-
 net/ipv4/inet_fragment.c                          |  20 +++-
 net/ipv4/ip_fragment.c                            |  11 +-
 net/ipv4/ip_gre.c                                 |   5 +-
 net/ipv4/ip_options.c                             |   5 +-
 net/ipv4/tcp.c                                    |   2 +-
 net/ipv4/tcp_ipv4.c                               |  14 +--
 net/ipv4/tcp_output.c                             |   1 -
 net/ipv6/netfilter/nf_conntrack_reasm.c           |  12 +--
 net/ipv6/reassembly.c                             |   8 +-
 net/ipv6/tcp_ipv6.c                               |   7 ++
 net/sctp/associola.c                              |   2 +-
 net/sctp/sm_statefuns.c                           |   2 +-
 sound/pci/hda/hda_codec.c                         |   2 +-
 sound/pci/hda/patch_conexant.c                    |   8 +-
 sound/usb/mixer.c                                 |  21 ++--
 109 files changed, 778 insertions(+), 683 deletions(-)


