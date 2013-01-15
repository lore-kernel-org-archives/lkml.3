Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab3AOSvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:51:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:33926 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab3AOSvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:51:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/221] 3.7.3-stable review
Date: Tue, 15 Jan 2013 10:48:47 -0800
Message-Id: <20130115184958.025580322@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.7.3 release.
There are 221 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jan 17 18:49:23 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.7.3-rc1

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Treat crtc->mode.clock == 0 as disabled

Krzysztof Mazur <krzysiek@podlesie.net>
    i915: ensure that VGA plane is disabled

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: force restore on lid open

David Zafman <david.zafman@inktank.com>
    libceph: Unlock unprocessed pages in start_read() error path

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: call handle_cap_grant() for cap import message

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: Fix __ceph_do_pending_vmtruncate

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: Don't add dirty inode to dirty list if caps is in migration

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: Fix infinite loop in __wake_requests

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: Don't update i_max_size when handling non-auth cap

Alex Elder <elder@inktank.com>
    rbd: remove linger unconditionally

Alex Elder <elder@inktank.com>
    rbd: get rid of RBD_MAX_SEG_NAME_LEN

Alex Elder <elder@inktank.com>
    rbd: do not allow remove of mounted-on image

Alex Elder <elder@inktank.com>
    rbd: remove snapshots on error in rbd_add()

Alex Elder <elder@inktank.com>
    rbd: increase maximum snapshot name length

Alex Elder <elder@inktank.com>
    rbd: fix read-only option name

Alex Elder <elder@inktank.com>
    rbd: zero return code in rbd_dev_image_id()

Alex Elder <elder@inktank.com>
    rbd: fix bug in rbd_dev_id_put()

Alex Elder <elder@inktank.com>
    ceph: don't reference req after put

Sage Weil <sage@inktank.com>
    libceph: remove 'osdtimeout' option

Alex Elder <elder@inktank.com>
    libceph: avoid using freed osd in __kick_osd_requests()

Sage Weil <sage@inktank.com>
    libceph: fix osdmap decode error paths

Sage Weil <sage@inktank.com>
    libceph: fix protocol feature mismatch failure path

Daniel Vetter <daniel.vetter@ffwll.ch>
    Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"

Alex Elder <elder@inktank.com>
    libceph: WARN, don't BUG on unexpected connection states

Alex Elder <elder@inktank.com>
    libceph: always reset osds when kicking

Alex Elder <elder@inktank.com>
    libceph: move linger requests sooner in kick_requests()

Alex Elder <elder@inktank.com>
    libceph: register request before unregister linger

Alex Elder <elder@inktank.com>
    libceph: don't use rb_init_node() in ceph_osdc_alloc_request()

Alex Elder <elder@inktank.com>
    libceph: init event->node in ceph_osdc_create_event()

Alex Elder <elder@inktank.com>
    libceph: init osd->o_node in create_osd()

Alex Elder <elder@inktank.com>
    libceph: report connection fault with warning

Alex Elder <elder@inktank.com>
    libceph: socket can close in any connection state

Alexander Graf <agraf@suse.de>
    KVM: PPC: 44x: fix DCR read/write

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: disable cpt phase pointer fdi rx workaround

Konstantin Khlebnikov <khlebnikov@openvz.org>
    EDAC: Fix kernel panic on module unloading

Stanislaw Gruszka <sgruszka@redhat.com>
    Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails"

Joe Thornber <ejt@redhat.com>
    dm thin: fix race between simultaneous io and discards to same block

Ralf Baechle <ralf@linux-mips.org>
    Revert "MIPS: Optimise TLB handlers for MIPS32/64 R2 cores."

Axel Lin <axel.lin@ingics.com>
    regulator: max8998: Ensure enough delay time for max8998_set_voltage_buck_time_sel

Axel Lin <axel.lin@ingics.com>
    regulator: max8998: Use uV in voltage_map_desc

Axel Lin <axel.lin@ingics.com>
    regulator: max8997: Use uV in voltage_map_desc

Jan Beulich <JBeulich@suse.com>
    USB: ehci: make debug port in-use detection functional again

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Handle HS bulk/ctrl endpoints that don't NAK.

Oliver Neukum <oliver@neukum.org>
    USB: hub: handle claim of enabled remote wakeup after reset

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Avoid "dead ports", add roothub port polling.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Handle warm reset failure on empty port.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Ignore port state until reset completes.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Increase reset timeout.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Allow USB 3.0 ports to be disabled.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Ignore xHCI Reset Device status.

Andreas Fleig <andreasfleig@gmail.com>
    USB: Add device quirk for Microsoft VX700 webcam

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Handle auto-transition from hot to warm reset.

Aleksi Torhamo <aleksi@torhamo.net>
    drm/nvc0/fb: fix crash when different mutex is used to protect same list

Aleksi Torhamo <aleksi@torhamo.net>
    drm/nouveau/clock: fix support for more than 2 monitors on nve0

Marcin Slusarz <marcin.slusarz@gmail.com>
    drm/nouveau: add locking around instobj list operations

Marcin Slusarz <marcin.slusarz@gmail.com>
    drm/nouveau: fix blank LVDS screen regression on pre-nv50 cards

Marcin Slusarz <marcin.slusarz@gmail.com>
    drm/nv17-50: restore fence buffer on resume

Sergei Shtylyov <sshtylyov@ru.mvista.com>
    usb: musb: core: print new line in the driver banner again

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: dummy: fix enumeration with g_multi

Denis N Ladin <denladin@gmail.com>
    USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"

Tomasz Mloduchowski <q@qdot.me>
    usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added

Bjørn Mork <bjorn@mork.no>
    USB: option: add Telekom Speedstick LTE II

Quentin.Li <snowmanli88@163.com>
    USB: option: Add new MEDIATEK PID support

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist network interface on ZTE MF880

Dzianis Kahanovich <mahatma@bspu.unibel.by>
    USB: option: add Nexpring NP10T terminal id

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Fix firmware loading when driver is built into the kernel

Bing Zhao <bzhao@marvell.com>
    mwifiex: check wait_event_interruptible return value

Johannes Berg <johannes.berg@intel.com>
    mac80211: use del_timer_sync for final sta cleanup timer deletion

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix station destruction in AP/mesh modes

Stanislaw Gruszka <sgruszka@redhat.com>
    mac80211: fix ibss scanning

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: fix the reclaimed packet tracking upon flush queue

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fix PCIe interrupt handle return value

Jerome Glisse <jglisse@redhat.com>
    radeon/kms: force rn50 chip to always report connected on analog output

Nitin Gupta <ngupta@vflare.org>
    staging: zram: fix invalid memory references during disk write

Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
    staging: zram: factor-out zram_decompress_page() function

Samuel Thibault <samuel.thibault@ens-lyon.org>
    staging: speakup: avoid out-of-range access in synth_add()

Nickolai Zeldovich <nickolai@csail.mit.edu>
    staging: speakup: avoid out-of-range access in synth_init()

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8712u: Add new device ID

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: comedi_test: fix race when cancelling command

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should select COMEDI_FC

Éric Piel <piel@delmic.com>
    staging: comedi: fix minimum AO period for NI 625x and NI 628x

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: prevent auto-unconfig of manually configured devices

Mike Dunn <mikedunn@newsguy.com>
    ALSA: pxa27x: fix ac97 warm reset

Mike Dunn <mikedunn@newsguy.com>
    ALSA: pxa27x: fix ac97 cold reset

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Disable runtime D3 for Intel CPT & co

David Henningsson <david.henningsson@canonical.com>
    Revert "ALSA: hda - Shut up pins at power-saving mode with Conexnat codecs"

Linus Torvalds <torvalds@linux-foundation.org>
    vfs: add missing virtual cache flush after editing partial pages

Hans de Goede <hdegoede@redhat.com>
    udldrmfb: udl_get_edid: drop unneeded i--

Hans de Goede <hdegoede@redhat.com>
    udldrmfb: udl_get_edid: usb_control_msg buffer must not be on the stack

Hans de Goede <hdegoede@redhat.com>
    udldrmfb: Fix EDID not working with monitors with EDID extension blocks

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm5100: Remove DSP B and left justified formats

Patrick Lai <plai@codeaurora.org>
    ASoC: pcm: allow backend hardware to be freed in pause state

Axel Lin <axel.lin@ingics.com>
    ASoC: sta529: Fix update register bits in sta529_set_dai_fmt

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm2200: Remove DSP B and left justified AIF modes

Axel Lin <axel.lin@ingics.com>
    ASoC: wm2200: Fix setting dai format in wm2200_set_fmt

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm2000: Fix sense of speech clarity enable

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: arizona: Remove DSP B and left justified AIF modes

Axel Lin <axel.lin@ingics.com>
    ASoC: arizona: Do proper shift for setting AIF rate

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: arizona: Correct FLL source definitions

Marek Vasut <marex@denx.de>
    HID: add quirk for Freescale i.MX23 ROM recovery

Eric Wong <normalperson@yhbt.net>
    epoll: prevent missed events on EPOLL_CTL_MOD

Mark Brown <broonie@opensource.wolfsonmicro.com>
    regmap: debugfs: Avoid overflows for very small reads

Zhang Rui <rui.zhang@intel.com>
    ACPI : do not use Lid and Sleep button for S5 wakeup

Namjae Jeon <namjae.jeon@samsung.com>
    udf: don't increment lenExtents while writing to a hole

Namjae Jeon <namjae.jeon@samsung.com>
    udf: fix memory leak while allocating blocks during write

Ed L. Cashin <ecashin@coraid.com>
    aoe: remove vestigial request queue allocation

Guo Chao <yan@linux.vnet.ibm.com>
    ext4: release buffer in failed path in dx_probe()

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid hang when mounting non-journal filesystems with orphan list

Theodore Ts'o <tytso@mit.edu>
    ext4: lock i_mutex when truncating orphan inodes

Michael Tokarev <mjt@tls.msk.ru>
    ext4: do not try to write superblock on ro remount w/o journal

Jan Kara <jack@suse.cz>
    jbd2: fix assertion failure in jbd2_journal_flush()

Jan Kara <jack@suse.cz>
    ext4: check dioread_nolock on remount

Forrest Liu <forrestl@synology.com>
    ext4: fix extent tree corruption caused by hole punch

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: Move disabling/enabling runtime PM to late suspend/early resume

Seth Forshee <seth.forshee@canonical.com>
    samsung-laptop: Add quirk for broken acpi_video backlight on N250P

Lothar Waßmann <LW@KARO-electronics.de>
    video: mxsfb: fix crash when unblanking the display

Hante Meuleman <meuleman@broadcom.com>
    brcmfmac: fix parsing rsn ie for ap mode.

Sivaram Nair <sivaramn@nvidia.com>
    cpuidle / coupled: fix ready counter decrement

Ian Campbell <Ian.Campbell@citrix.com>
    xen/netfront: improve truesize tracking

Kees Cook <keescook@chromium.org>
    audit: create explicit AUDIT_SECCOMP event type

Chris Verges <kg4ysn@gmail.com>
    hwmon: (lm73} Detect and report i2c bus errors

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: 64bit fixes: vCommandTimerWait change calculation of timer.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: 64 bit fixes: fix long warning messages.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: 64 bit fixes : correct all type sizes

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: 64 bit fixes: use u32 for QWORD definition.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [BUG] out of bound array reference in RFbSetPower.

Joe Thornber <ejt@redhat.com>
    dm thin: replace dm_cell_release_singleton with cell_defer_except

Alasdair G Kergon <agk@redhat.com>
    dm ioctl: prevent unsafe change to dm_ioctl data_size

Mikulas Patocka <mpatocka@redhat.com>
    dm persistent data: rename node to btree_node

Mike Snitzer <snitzer@redhat.com>
    dm: disable WRITE SAME

Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
    RDMA/nes: Fix for terminate timer crash

Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
    RDMA/nes: Fix for crash when registering zero length MR for CQ

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Revert shrinker changes from "Track unbound pages"

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915; Only increment the user-pin-count after successfully pinning the bo

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Only evict the blocks required to create the requested hole

Seung-Woo Kim <sw0312.kim@samsung.com>
    drm/prime: drop reference on imported dma-buf come from gem

Dave Airlie <airlied@redhat.com>
    drm/i915: fix flags in dma buf exporting

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: don't disable disconnected outputs

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Flush outstanding unpin tasks before pageflipping

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Close race between processing unpin task and queueing the flip

Mel Gorman <mgorman@suse.de>
    mm: compaction: partially revert capture of suitable high-order page

Paulo Zanoni <paulo.r.zanoni@intel.com>
    drm/i915: make the panel fitter work on pipes B and C on IVB

Aaro Koskinen <aaro.koskinen@iki.fi>
    drm/nouveau: fix init with agpgart-uninorth

Niels Ole Salscheider <niels_ole@salscheider-online.de>
    drm/radeon: Properly handle DDC probe for DP bridges

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add connector table for Mac G4 Silver

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add WAIT_UNTIL to evergreen VM safe reg list

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: avoid deadlock in pm path when waiting for fence

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: don't leave fence blocked process on failed GPU reset

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: restore modeset late in GPU reset path

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: fix amd afusion gpu setup aka sumo v2

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix eDP clk and lane setup for scaled modes

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dce32+: use fractional fb dividers for high clocks

Christian König <deathsimple@vodafone.de>
    drm/radeon: stop page faults from hanging the system (v2)

Woodhouse, David <david.woodhouse@intel.com>
    intel-iommu: Free old page tables before creating superpage

Dan Williams <dcbw@redhat.com>
    i2400m: add Intel 6150 device IDs

Alexey Khoroshilov <khoroshilov@ispras.ru>
    jffs2: hold erase_completion_lock on exit

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Ensure we release the socket write lock if the rpc_task exits early

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Ensure that we free the rpc_task after cleanups are done

J. Bruce Fields <bfields@redhat.com>
    svcrpc: Revert "sunrpc/cache.h: replace simple_strtoul"

Stanislav Kinsbursky <skinsbursky@parallels.com>
    SUNRPC: continue run over clients list on PipeFS event instead of break

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Fix validity issues with rpc_pipefs sb->s_fs_info

Tomi Valkeinen <tomi.valkeinen@ti.com>
    OMAP: board-files: fix i2c_bus for tfp410

Pawel Moll <pawel.moll@arm.com>
    kbuild: Do not remove vmlinux when cleaning external module

Wolfram Sang <w.sang@pengutronix.de>
    mtd: nand: gpmi: reset BCH earlier, too, to avoid NAND startup problems

Nathan Williams <nathan@traverse.com.au>
    mtd cs553x_nand: Initialise ecc.strength before nand_scan()

Theodore Ts'o <tytso@mit.edu>
    ext4: fix possible use after free with metadata csum

Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
    ext4: fix memory leak in ext4_xattr_set_acl()'s error path

Geert Uytterhoeven <geert@linux-m68k.org>
    mfd: Remove Unicode Byte Order Marks from da9055

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    mfd: Only unregister platform devices allocated by the mfd core

Mark Brown <broonie@opensource.wolfsonmicro.com>
    mfd: wm8994: Add support for WM1811 rev E

Chris Boot <bootc@bootc.net>
    sbp-target: fix error path in sbp_make_tpg()

Yi Zou <yi.zou@intel.com>
    target/tcm_fc: fix the lockdep warning due to inconsistent lock state

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    target/file: Fix 32-bit highmem breakage for SGL -> iovec mapping

Xiaotian Feng <xtfeng@gmail.com>
    libata: fix Null pointer dereference on disk error

Aaron Lu <aaron.lu@intel.com>
    libata: set dma_mode to 0xff in reset

Maxime Bizon <mbizon@freebox.fr>
    pstore/ram: Fix undefined usage of rounddown_pow_of_two(0)

Jack Morgenstein <jackm@dev.mellanox.co.il>
    mlx4_core: Fix potential deadlock in mlx4_eq_int()

Jack Morgenstein <jackm@dev.mellanox.co.il>
    IB/mlx4: Fix spinlock order to avoid lockdep warnings

Mattia Dongili <malattia@linux.it>
    sony-laptop: fix SNC buffer calls when SN06 returns Integers

Mikael Pettersson <mikpe@it.uu.se>
    sata_promise: fix hardreset lockdep error

Steve Hodgson <steve@purestorage.com>
    qla2xxx: Look up LUN for abort requests

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    iscsit: use GFP_ATOMIC under spin lock

Roland Dreier <roland@purestorage.com>
    iscsi-target: Always send a response before terminating iSCSI connection

Steve Hodgson <steve@purestorage.com>
    iscsi-target: Fix bug in handling of ExpStatSN ACK during u32 wrap-around

Steve Hodgson <steve@purestorage.com>
    SCSI: qla2xxx: Free rsp_data even on error in qla2x00_process_loopback()

Giridhar Malavali <giridhar.malavali@qlogic.com>
    SCSI: qla2xxx: Change in setting UNLOADING flag and FC vports logout sequence while unloading qla2xxx driver.

David Jeffery <djeffery@redhat.com>
    SCSI: qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.

Armen Baloyan <armen.baloyan@qlogic.com>
    SCSI: qla2xxx: Properly set result field of bsg_job reply structure for success and failure.

Sasha Levin <sasha.levin@oracle.com>
    SCSI: prevent stack buffer overflow in host_reset

Xi Wang <xi.wang@gmail.com>
    SCSI: mvsas: fix undefined bit shift

Sangbeom Kim <sbkim73@samsung.com>
    regulator: s2mps11: Fix ramp delay value shift operation

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: sigmadsp: Fix endianness conversion issue

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm8994: Use the same DCS codes for all WM1811 variants

Bjørn Mork <bjorn@mork.no>
    watchdog: Fix disable/enable regression

Stephan Gatzka <stephan.gatzka@gmail.com>
    firewire: net: Fix handling of fragmented multicast/broadcast packets.

Christian Lamparter <chunkeey@googlemail.com>
    carl9170: fix -EINVAL bailout during init with !CONFIG_MAC80211_MESH

Stanislaw Gruszka <sgruszka@redhat.com>
    mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k_hw: Fix RX gain initvals for AR9485

Felix Fietkau <nbd@openwrt.org>
    ath9k_hw: Fix signal strength / channel noise reporting

Gabor Juhos <juhosg@openwrt.org>
    ath9k: ar9003: fix OTP register offsets for AR9340

Felix Fietkau <nbd@openwrt.org>
    Revert "ath9k_hw: Update AR9003 high_power tx gain table"

Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
    ath9k_hw: Enable hw PLL power save for AR9462

Max Filippov <jcmvbkbc@gmail.com>
    mm: bootmem: fix free_all_bootmem_core() with odd bitmap alignment

Laura Abbott <lauraa@codeaurora.org>
    mm: use aligned zone start for pfn_to_bitidx calculation

Jason Liu <r64343@freescale.com>
    mm: compaction: fix echo 1 > compact_memory return error issue

Huacai Chen <chenhc@lemote.com>
    MIPS: Fix poweroff failure when HOTPLUG_CPU configured.

Sebastian Ott <sebott@linux.vnet.ibm.com>
    s390/cio: fix pgid reserved check

Alex Williamson <alex.williamson@redhat.com>
    KVM: Fix user memslot overlap check

Scott Wood <scottwood@freescale.com>
    KVM: PPC: e500: fix allocation size error on g2h_tlb1_map

Gabor Juhos <juhosg@openwrt.org>
    powerpc: Add missing NULL terminator to avoid boot panic on PPC40x

Shan Hai <shan.hai@windriver.com>
    powerpc/vdso: Remove redundant locking in update_vsyscall_tz()

Anton Blanchard <anton@samba.org>
    powerpc: Fix CONFIG_RELOCATABLE=y CONFIG_CRASH_DUMP=n build

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/kvm: Fix address space mixup

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/kvm: dont announce RRBM support

Helmut Schaa <helmut.schaa@googlemail.com>
    rt2x00: Only specify interface combinations if more then one interface is possible

Rafał Miłecki <zajec5@gmail.com>
    bcma: mips: fix clearing device IRQ

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: silently ignore fw flaws in Tx path

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: don't handle masked interrupt

Felix Fietkau <nbd@openwrt.org>
    ath5k: fix tx path skb leaks

Mark Brown <broonie@opensource.wolfsonmicro.com>
    regulator: wm831x: Set the new rather than old value for DVS VSEL


-------------

Diffstat:

 Documentation/power/runtime_pm.txt                 |   9 +-
 Makefile                                           |  12 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   1 +
 arch/arm/mach-omap2/board-am3517evm.c              |   1 +
 arch/arm/mach-omap2/board-cm-t35.c                 |   1 +
 arch/arm/mach-omap2/board-devkit8000.c             |   1 +
 arch/arm/mach-omap2/board-omap3evm.c               |   1 +
 arch/arm/mach-omap2/board-omap3stalker.c           |   1 +
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h        |   3 +
 arch/arm/mach-pxa/pxa27x.c                         |   4 +-
 arch/mips/kernel/process.c                         |   4 +-
 arch/mips/mm/tlbex.c                               |  16 --
 arch/powerpc/kernel/head_64.S                      |   2 +-
 arch/powerpc/kernel/time.c                         |   5 -
 arch/powerpc/kvm/44x_emulate.c                     |   2 +
 arch/powerpc/kvm/e500_tlb.c                        |   2 +-
 arch/powerpc/platforms/40x/ppc40x_simple.c         |   3 +-
 arch/s390/kernel/entry64.S                         |  25 ++-
 arch/s390/kvm/kvm-s390.c                           |   2 +-
 drivers/acpi/scan.c                                |   7 +-
 drivers/ata/libata-core.c                          |   1 +
 drivers/ata/libata-eh.c                            |   1 +
 drivers/ata/libata-scsi.c                          |   6 +-
 drivers/ata/sata_promise.c                         |  15 +-
 drivers/base/power/main.c                          |   9 +-
 drivers/base/regmap/regmap-debugfs.c               |   2 +-
 drivers/bcma/driver_mips.c                         |   2 +-
 drivers/block/aoe/aoeblk.c                         |  17 +-
 drivers/block/rbd.c                                |  63 +++++---
 drivers/block/rbd_types.h                          |   2 -
 drivers/cpuidle/coupled.c                          |   2 +-
 drivers/edac/edac_mc_sysfs.c                       |   2 +-
 drivers/firewire/net.c                             |  13 +-
 drivers/gpu/drm/drm_mm.c                           |  45 ++----
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c         |   5 +
 drivers/gpu/drm/i915/i915_debugfs.c                |   4 +-
 drivers/gpu/drm/i915/i915_drv.c                    |   2 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   3 +-
 drivers/gpu/drm/i915/i915_gem.c                    |  25 ++-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c             |   7 +-
 drivers/gpu/drm/i915/i915_irq.c                    |   4 +-
 drivers/gpu/drm/i915/i915_reg.h                    |   2 +
 drivers/gpu/drm/i915/intel_display.c               | 136 +++++++++-------
 drivers/gpu/drm/i915/intel_drv.h                   |   9 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |  10 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  23 ++-
 .../gpu/drm/nouveau/core/include/subdev/bios/pll.h |   2 +
 drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c   |   2 +
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |   6 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/base.c |  35 ++++-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   2 +-
 drivers/gpu/drm/nouveau/nouveau_fence.h            |   1 +
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   1 +
 drivers/gpu/drm/nouveau/nv04_dfp.c                 |   2 +-
 drivers/gpu/drm/nouveau/nv10_fence.c               |   8 +
 drivers/gpu/drm/nouveau/nv50_fence.c               |   1 +
 drivers/gpu/drm/radeon/atombios_crtc.c             |   2 +
 drivers/gpu/drm/radeon/atombios_encoders.c         |   2 +-
 drivers/gpu/drm/radeon/evergreen.c                 |  18 ++-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   1 +
 drivers/gpu/drm/radeon/evergreend.h                |   5 +
 drivers/gpu/drm/radeon/ni.c                        |  16 +-
 drivers/gpu/drm/radeon/nid.h                       |  11 ++
 drivers/gpu/drm/radeon/radeon.h                    |   3 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |  51 ++++++
 drivers/gpu/drm/radeon/radeon_connectors.c         |  10 +-
 drivers/gpu/drm/radeon/radeon_device.c             |  17 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  13 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |  49 ++++--
 drivers/gpu/drm/radeon/radeon_i2c.c                |  10 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |   8 +
 drivers/gpu/drm/radeon/radeon_mode.h               |   5 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |  15 +-
 drivers/gpu/drm/radeon/radeon_prime.c              |   1 +
 drivers/gpu/drm/radeon/si.c                        |  25 ++-
 drivers/gpu/drm/radeon/sid.h                       |  14 ++
 drivers/gpu/drm/udl/udl_connector.c                |  17 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/usbhid/hid-quirks.c                    |   1 +
 drivers/hwmon/lm73.c                               |  16 +-
 drivers/infiniband/hw/mlx4/cm.c                    |   4 +-
 drivers/infiniband/hw/nes/nes.h                    |   1 +
 drivers/infiniband/hw/nes/nes_hw.c                 |   9 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |   9 +-
 drivers/iommu/intel-iommu.c                        |  11 +-
 drivers/md/dm-bio-prison.c                         |  25 ---
 drivers/md/dm-bio-prison.h                         |   1 -
 drivers/md/dm-ioctl.c                              |   8 +
 drivers/md/dm-table.c                              |   2 +
 drivers/md/dm-thin.c                               | 101 ++++++++----
 drivers/md/persistent-data/dm-btree-internal.h     |  16 +-
 drivers/md/persistent-data/dm-btree-remove.c       |  50 +++---
 drivers/md/persistent-data/dm-btree-spine.c        |   6 +-
 drivers/md/persistent-data/dm-btree.c              |  22 +--
 drivers/mfd/mfd-core.c                             |  15 +-
 drivers/mfd/wm8994-core.c                          |   1 +
 drivers/mtd/nand/cs553x_nand.c                     |   3 +-
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |   9 ++
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |   9 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |  10 +-
 drivers/net/wimax/i2400m/i2400m-usb.h              |   3 +
 drivers/net/wimax/i2400m/usb.c                     |   6 +
 drivers/net/wireless/ath/ath5k/base.c              |   4 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   2 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   | 172 ++++++++++-----------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |   6 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   6 +-
 drivers/net/wireless/ath/ath9k/calib.c             |   1 +
 drivers/net/wireless/ath/ath9k/calib.h             |   3 +
 drivers/net/wireless/ath/carl9170/fw.c             |   6 +-
 drivers/net/wireless/b43/b43.h                     |   5 +
 drivers/net/wireless/b43/main.c                    |  54 +++++--
 drivers/net/wireless/b43/main.h                    |   5 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   5 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c              |  71 ++++-----
 drivers/net/wireless/iwlwifi/pcie/rx.c             |  13 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |  21 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c            |   3 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |  10 +-
 drivers/net/xen-netfront.c                         |  27 +---
 drivers/platform/x86/samsung-laptop.c              |  10 ++
 drivers/platform/x86/sony-laptop.c                 |  15 +-
 drivers/regulator/max8997.c                        |  36 ++---
 drivers/regulator/max8998.c                        |  44 +++---
 drivers/regulator/s2mps11.c                        |  10 +-
 drivers/regulator/wm831x-dcdc.c                    |   2 +-
 drivers/s390/cio/device_pgid.c                     |  10 +-
 drivers/scsi/mvsas/mv_94xx.h                       |  14 +-
 drivers/scsi/mvsas/mv_sas.h                        |   2 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   3 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  72 ++++-----
 drivers/scsi/qla2xxx/qla_os.c                      |   7 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  21 ++-
 drivers/scsi/scsi_sysfs.c                          |  11 +-
 drivers/staging/comedi/Kconfig                     |   1 +
 drivers/staging/comedi/comedi_fops.c               |   3 +
 drivers/staging/comedi/drivers/comedi_test.c       |   2 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |  16 +-
 drivers/staging/omapdrm/omap_gem_dmabuf.c          |   5 +
 drivers/staging/rtl8712/usb_intf.c                 |   2 +
 drivers/staging/speakup/synth.c                    |   4 +-
 drivers/staging/vt6656/dpc.c                       |   4 +-
 drivers/staging/vt6656/key.c                       |  53 +++++--
 drivers/staging/vt6656/key.h                       |   8 +-
 drivers/staging/vt6656/mac.c                       |   6 +-
 drivers/staging/vt6656/rf.c                        |   3 +
 drivers/staging/vt6656/rxtx.c                      |  18 ++-
 drivers/staging/vt6656/ttype.h                     |  16 +-
 drivers/staging/vt6656/wcmd.c                      |  20 +--
 drivers/staging/vt6656/wpa2.h                      |   4 +-
 drivers/staging/zram/zram_drv.c                    | 152 +++++++++---------
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/target/iscsi/iscsi_target_erl2.c           |   2 +-
 drivers/target/iscsi/iscsi_target_login.c          |   8 +-
 drivers/target/iscsi/iscsi_target_nego.c           |  10 +-
 drivers/target/iscsi/iscsi_target_tmr.c            |   4 +-
 drivers/target/sbp/sbp_target.c                    |  17 +-
 drivers/target/target_core_file.c                  |   9 +-
 drivers/target/tcm_fc/tfc_sess.c                   |   2 +-
 drivers/usb/class/cdc-acm.c                        |   3 +
 drivers/usb/core/hub.c                             | 120 +++++++++++---
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/gadget/dummy_hcd.c                     |   9 +-
 drivers/usb/host/ehci-pci.c                        |  39 ++---
 drivers/usb/host/xhci-hub.c                        |  38 ++++-
 drivers/usb/host/xhci-mem.c                        |   2 +
 drivers/usb/host/xhci-ring.c                       |   9 ++
 drivers/usb/host/xhci.c                            |  10 ++
 drivers/usb/musb/musb_core.c                       |   5 +-
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   6 +
 drivers/usb/serial/option.c                        |  18 ++-
 drivers/video/mxsfb.c                              |   3 +-
 fs/buffer.c                                        |   1 +
 fs/ceph/addr.c                                     |   9 ++
 fs/ceph/caps.c                                     |  16 +-
 fs/ceph/inode.c                                    |  15 +-
 fs/ceph/mds_client.c                               |   9 +-
 fs/ceph/super.c                                    |   2 -
 fs/eventpoll.c                                     |  22 ++-
 fs/ext4/acl.c                                      |   6 +-
 fs/ext4/extents.c                                  |  22 ++-
 fs/ext4/ialloc.c                                   |   2 +-
 fs/ext4/namei.c                                    |   5 +-
 fs/ext4/super.c                                    |  26 ++--
 fs/jbd2/transaction.c                              |   3 +-
 fs/jffs2/nodemgmt.c                                |   6 +-
 fs/pstore/ram.c                                    |  12 +-
 fs/udf/inode.c                                     |  11 +-
 include/drm/drm_mm.h                               |   2 +-
 include/linux/audit.h                              |   3 +-
 include/linux/ceph/libceph.h                       |   2 -
 include/linux/compaction.h                         |   4 +-
 include/linux/mfd/da9055/core.h                    |   2 +-
 include/linux/mfd/da9055/pdata.h                   |   2 +-
 include/linux/mfd/da9055/reg.h                     |   2 +-
 include/linux/mm.h                                 |   1 -
 include/linux/sunrpc/cache.h                       |   6 +-
 include/net/mac80211.h                             |   5 +
 include/uapi/linux/audit.h                         |   1 +
 include/video/omap-panel-tfp410.h                  |   2 +-
 kernel/auditsc.c                                   |  14 +-
 kernel/watchdog.c                                  |  11 +-
 mm/bootmem.c                                       |  24 ++-
 mm/compaction.c                                    |  98 ++----------
 mm/internal.h                                      |   1 -
 mm/page_alloc.c                                    |  37 ++---
 net/ceph/ceph_common.c                             |   3 +-
 net/ceph/messenger.c                               |  72 +++++----
 net/ceph/osd_client.c                              |  93 ++++-------
 net/ceph/osdmap.c                                  |  31 ++--
 net/mac80211/ibss.c                                |   9 +-
 net/mac80211/ieee80211_i.h                         |  10 +-
 net/mac80211/iface.c                               |  28 ++--
 net/mac80211/scan.c                                |  34 ++--
 net/mac80211/sta_info.c                            |  46 +++++-
 net/mac80211/sta_info.h                            |   3 +-
 net/mac80211/status.c                              |   6 +-
 net/sunrpc/clnt.c                                  |   2 +-
 net/sunrpc/rpc_pipe.c                              |   7 +-
 net/sunrpc/sched.c                                 |  30 +++-
 net/sunrpc/xprt.c                                  |  12 +-
 sound/arm/pxa2xx-ac97-lib.c                        |  26 +++-
 sound/pci/hda/hda_intel.c                          |  13 +-
 sound/pci/hda/patch_conexant.c                     |  16 --
 sound/soc/codecs/arizona.c                         |   9 +-
 sound/soc/codecs/arizona.h                         |  18 +--
 sound/soc/codecs/sigmadsp.c                        |   2 +-
 sound/soc/codecs/sta529.c                          |   9 +-
 sound/soc/codecs/wm2000.c                          |   4 +-
 sound/soc/codecs/wm2200.c                          |   8 +-
 sound/soc/codecs/wm5100.c                          |   6 -
 sound/soc/codecs/wm8994.c                          |  16 +-
 sound/soc/soc-pcm.c                                |   1 +
 virt/kvm/kvm_main.c                                |  13 +-
 235 files changed, 2063 insertions(+), 1365 deletions(-)


