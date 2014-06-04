Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaFDXUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:20:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaFDXUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:20:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 000/228] 3.14.6-stable review
Date: Wed,  4 Jun 2014 16:20:29 -0700
Message-Id: <20140604232347.966798903@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.6 release.
There are 228 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jun  6 23:23:11 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.6-rc1

Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    media: V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode

Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    media: V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space

Eyal Shapira <eyal@wizery.com>
    iwlwifi: mvm: rs: clear per rate stats when aggregation changes

Eliad Peller <eliad@wizery.com>
    iwlwifi: add rs_rate_scale_clear_tbl_windows helper function

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: disable beacon filtering

Antti Palosaari <crope@iki.fi>
    media: fc2580: fix tuning failure on 32-bit arch

Alex Williamson <alex.williamson@redhat.com>
    iommu/amd: Fix interrupt remapping for aliased devices

Chunwei Chen <tuxoko@gmail.com>
    libceph: fix corruption when using page_count 0 page in rbd

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: core: Ignore unsupported Dual/Quad Transfer Mode bits

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    powerpc, kexec: Fix "Processor X is stuck" issue during kexec from ST mode

Guenter Roeck <linux@roeck-us.net>
    powerpc: Fix 64 bit builds with binutils 2.24

Anton Blanchard <anton@samba.org>
    powerpc: irq work racing with timer interrupt can result in timer interrupt hang

Gavin Shan <gwshan@linux.vnet.ibm.com>
    powerpc/powernv: Reset root port in firmware

Stephen Boyd <sboyd@codeaurora.org>
    clk: Fix slab corruption in clk_unregister()

Stephen Boyd <sboyd@codeaurora.org>
    clk: Fix double free due to devm_clk_register()

Harald Freudenberger <freude@linux.vnet.ibm.com>
    crypto: s390 - fix aes,des ctr mode concurrency finding.

Horia Geanta <horia.geanta@freescale.com>
    crypto: caam - add allocation failure handling in SPRINTFCAT macro

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: remove setting P state to MAX on init

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: Set turbo VID for BayTrail

Olof Johansson <olof@lixom.net>
    i2c: s3c2410: resume race fix

Du, Wenkai <wenkai.du@intel.com>
    i2c: designware: Mask all interrupts during i2c controller enable

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: bail out on zero length transfers

Hans de Goede <hdegoede@redhat.com>
    ACPI / video: Revert native brightness quirk for ThinkPad T530

Aaron Lu <aaron.lu@intel.com>
    ACPI / video: correct DMI tag for Dell Inspiron 7520

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / TPM: Fix resume regression on Chromebooks

Edward Lin <yidi.lin@canonical.com>
    ACPI: blacklist win8 OSI for Dell Inspiron 7737

Guenter Roeck <linux@roeck-us.net>
    ACPI: Revert "ACPI / AC: convert ACPI ac driver to platform bus"

Igor Mammedov <imammedo@redhat.com>
    ACPI / processor: do not mark present at boot but not onlined CPU as onlined

Hans de Goede <hdegoede@redhat.com>
    ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015PX

Hans de Goede <hdegoede@redhat.com>
    ACPI / video: Add use_native_backlight quirks for more systems

Lan Tianyu <tianyu.lan@intel.com>
    ACPI: Revert "ACPI / Battery: Remove battery's proc directory"

Lan Tianyu <tianyu.lan@intel.com>
    ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"

Lv Zheng <lv.zheng@intel.com>
    ACPICA: Tables: Restore old behavor to favor 32-bit FADT addresses.

Lv Zheng <lv.zheng@intel.com>
    ACPICA: Tables: Fix invalid pointer accesses in acpi_tb_parse_root_table().

Levente Kurusa <levex@linux.com>
    libata: clean up ZPODD when a port is detached

Nicholas Bellinger <nab@linux-iscsi.org>
    tcm_fc: Fix free-after-use regression in ft_free_cmd

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: went back to plain {request,free}_irq() calls

Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    dma: mv_xor: Flush descriptors before activating a channel

Xuelin Shi <xuelin.shi@freescale.com>
    dmaengine: fix dmaengine_unmap failure

Joe Thornber <ejt@redhat.com>
    dm thin: add timeout to stop out-of-data-space mode holding IO forever

Joe Thornber <ejt@redhat.com>
    dm thin: allow metadata commit if pool is in PM_OUT_OF_DATA_SPACE mode

Mikulas Patocka <mpatocka@redhat.com>
    dm crypt: fix cpu hotplug crash by removing per-cpu structure

Gavin Shan <gwshan@linux.vnet.ibm.com>
    PCI: Wrong register used to check pending traffic

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: BT Coex - fix Look Up Table

Jani Nikula <jani.nikula@intel.com>
    drm/i915: quirk invert brightness for Acer Aspire 5336

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix unsafe loop iteration over vma whilst unbinding them

Imre Deak <imre.deak@intel.com>
    drm/i915: move power domain init earlier during system resume

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Disable self-refresh for untiled fbs on i915gm

Mikulas Patocka <mpatocka@redhat.com>
    target: fix memory leak on XCOPY

Andy Grover <agrover@redhat.com>
    target: Don't allow setting WC emulation if device doesn't support

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Fix iscsit_accept_np and rdma_cm racy flow

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Fix wrong connection requests list addition

Andy Grover <agrover@redhat.com>
    target: Allow non-supporting backends to set pi_prot_type to 0

Marcel Apfelbaum <marcel.a@redhat.com>
    PCI: shpchp: Check bridge's secondary (not primary) bus speed

Tejun Heo <tj@kernel.org>
    sysfs: make sure read buffer is zeroed

Arnd Bergmann <arnd@arndb.de>
    genirq: Provide irq_force_affinity fallback for non-SMP

Linus Torvalds <torvalds@linux-foundation.org>
    x86-64, modify_ldt: Make support for 16-bit segments a runtime option

James Hogan <james.hogan@imgtec.com>
    metag: Reduce maximum stack size to 256MB

Mikulas Patocka <mpatocka@redhat.com>
    metag: fix memory barriers

John David Anglin <dave.anglin@bell.net>
    parisc: Improve LWS-CAS performance

Helge Deller <deller@gmx.de>
    parisc: ratelimit userspace segfault printing

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: dapm: Skip CODEC<->CODEC links in connect_dai_link_widgets()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: fix setting channel in monitor mode

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: disable interrupts upon PCIe alloc

Jianyu Zhan <nasa4836@gmail.com>
    percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: mvebu-soc-id: keep clock enabled if PCIe unit is enabled

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: mvebu-soc-id: add missing clk_put() call

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    PCI: mvebu: split PCIe BARs into multiple MBus windows when needed

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    bus: mvebu-mbus: allow several windows with the same target/attribute

Willy Tarreau <w@1wt.eu>
    PCI: mvebu: fix off-by-one in the computed size of the mbus windows

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    memory: mvebu-devbus: fix the conversion of the bus width

Lai Jiangshan <laijs@cn.fujitsu.com>
    workqueue: make rescuer_thread() empty wq->maydays list before exiting

Lai Jiangshan <laijs@cn.fujitsu.com>
    workqueue: fix a possible race condition between rescuer and pwq-release

Daeseok Youn <daeseok.youn@gmail.com>
    workqueue: fix bugs in wq_update_unbound_numa() failure path

J. Bruce Fields <bfields@redhat.com>
    nfsd4: remove lockowner when removing lock stateid

J. Bruce Fields <bfields@redhat.com>
    nfsd4: warn on finding lockowner without stateid's

Kinglong Mee <kinglongmee@gmail.com>
    NFSD: Call ->set_acl with a NULL ACL structure if no entries

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSd: call rpc_destroy_wait_queue() from free_client()

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSd: Move default initialisers from create_client() to alloc_client()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets

Anssi Hannula <anssi.hannula@iki.fi>
    ALSA: hda - hdmi: Set converter channel count even without sink

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - change min/max quirk table to pnp-id matching

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - add a matches_pnp_id helper function

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - T540p - unify with other LEN0034 models

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - add min/max quirk for the ThinkPad W540

Hans de Goede <hdegoede@redhat.com>
    Input: elantech - fix touchpad initialization on Gigabyte U2442

Sheng-Liang Song <ssl@chromium.org>
    Input: atkbd - fix keyboard not working on some LG laptops

Romain Izard <romain.izard.pro@gmail.com>
    trace: module: Maintain a valid user count

Al Viro <viro@zeniv.linux.org.uk>
    fix races between __d_instantiate() and checks of dentry flags

Ian Kent <raven@themaw.net>
    autofs: fix lockref lookup

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: clear directory's completeness when creating file

David Ertman <davidx.m.ertman@intel.com>
    e1000e: Fix no connectivity when driver loaded with cable out

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - report INPUT_PROP_TOPBUTTONPAD property

Hans de Goede <hdegoede@redhat.com>
    Input: Add INPUT_PROP_TOPBUTTONPAD device property

Hans de Goede <hdegoede@redhat.com>
    Input: i8042 - add firmware_id support

Hans de Goede <hdegoede@redhat.com>
    Input: serio - add firmware_id sysfs attribute

Chew, Kean ho <kean.ho.chew@intel.com>
    i2c: i801: enable Intel BayTrail SMBUS

Salva Peiró <speiro@ai2.upv.es>
    media: media-device: fix infoleak in ioctl media_enum_entities()

Dan Carpenter <dan.carpenter@oracle.com>
    clk: vexpress: NULL dereference on error path

Tim Chen <tim.c.chen@linux.intel.com>
    crypto: crypto_wq - Fix late crypto work queue initialization

Aristeu Rozanski <aris@redhat.com>
    device_cgroup: check if exception removal is allowed

Aristeu Rozanski <aris@redhat.com>
    device_cgroup: rework device access check and exception checking

Geert Uytterhoeven <geert+renesas@glider.be>
    Documentation: Update stable address in Chinese and Japanese translations

Emil Goode <emilgoode@gmail.com>
    brcmsmac: fix deadlock on missing firmware

Russell King <rmk+kernel@arm.linux.org.uk>
    leds: leds-pwm: properly clean up after probe failure

Martin Peres <martin.peres@labri.fr>
    drm/nouveau/pm/fan: drop the fan lock in fan_update() before rescheduling

Christoph Paasch <christoph.paasch@uclouvain.be>
    igb: Unset IGB_FLAG_HAS_MSIX-flag when falling back to msi-only

Christoph Paasch <christoph.paasch@uclouvain.be>
    igb: Fix Null-pointer dereference in igb_reset_q_vector

Dan Carpenter <dan.carpenter@oracle.com>
    i40e: potential array underflow in i40e_vc_process_vf_msg()

Aaron Lu <aaron.lu@intel.com>
    drm/i915: restore backlight precision when converting from ACPI

Jani Nikula <jani.nikula@intel.com>
    drm/i915/vlv: reset VLV media force wake request register

Maarten Lankhorst <maarten.lankhorst@canonical.com>
    drm/nouveau: fix another lock unbalance in nouveau_crtc_page_flip

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi

Ben Hutchings <ben@decadent.org.uk>
    rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init()

Liu Hua <sdu.liu@huawei.com>
    ARM: 8012/1: kdump: Avoid overflow when converting pfn to physaddr

Leif Lindholm <leif.lindholm@linaro.org>
    arm: dts: Fix missing device_type="memory" for ste-ccu8540

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: fix NOR bus-width in Armada XP OpenBlocks AX3 Device Tree

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: fix NOR bus-width in Armada XP DB Device Tree

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: fix NOR bus-width in Armada XP GP Device Tree

Thomas Gleixner <tglx@linutronix.de>
    ARM: common: edma: Fix xbar mapping

Sascha Hauer <s.hauer@pengutronix.de>
    ARM: dts: i.MX53: Fix ipu register space size

Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    ARM: dts: kirkwood: fix mislocated pcie-controller nodes

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: orion5x: fix target ID for crypto SRAM window

Johannes Weiner <hannes@cmpxchg.org>
    revert "mm: vmscan: do not swap anon pages just because free+file is low"

Vlastimil Babka <vbabka@suse.cz>
    mm/compaction: make isolate_freepages start at pageblock boundary

Rik van Riel <riel@redhat.com>
    mm/page-writeback.c: fix divide by zero in pos_ratio_polynom

Fabian Frederick <fabf@skynet.be>
    fs/affs/super.c: bugfix / double free

Christoph Hellwig <hch@lst.de>
    posix_acl: handle NULL ACL in posix_acl_equiv_mode

Marcel Holtmann <marcel@holtmann.org>
    Revert "Bluetooth: Enable autosuspend for Intel Bluetooth device"

Mohammed Habibulla <moch@chromium.org>
    Bluetooth: Add support for Lite-on [04ca:3007]

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix redundant encryption request for reauthentication

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix triggering BR/EDR L2CAP Connect too early

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: work around corrupted TEAC UD-H01 feedback data

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2x00: fix beaconing on USB

Daniele Forsi <dforsi@gmail.com>
    USB: Nokia 5300 should be treated as unusual dev

Victor A. Santos <victoraur.santos@gmail.com>
    USB: Nokia 305 should be treated as unusual dev

Daniele Forsi <dforsi@gmail.com>
    usb: storage: shuttle_usbat: fix discs being detected twice

Bjørn Mork <bjorn@mork.no>
    usb: qcserial: add a number of Dell devices

Alan Stern <stern@rowland.harvard.edu>
    USB: OHCI: fix problem with global suspend on ATI controllers

Jean-Jacques Hiblot <jjhiblot@traphandler.com>
    usb: gadget: at91-udc: fix irq and iomem resource retrieval

Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
    fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6

Atilla Filiz <atilla.filiz@essensium.com>
    iio:imu:mpu6050: Fixed segfault in Invensens MPU driver due to null dereference

Tuomas Tynkkynen <ttynkkynen@nvidia.com>
    clk: tegra: Fix wrong value written to PLLE_AUX

Thierry Reding <treding@nvidia.com>
    drm/tegra: Remove gratuitous pad field

Leo Liu <leo.liu@amd.com>
    drm/radeon: check buffer relocation offset

Christian König <christian.koenig@amd.com>
    drm/radeon: use pflip irq on R600+ v2

Christian König <christian.koenig@amd.com>
    drm/radeon/uvd: use lower clocks on old UVD to boot v2

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: fix count in cik_sdma_ring_test()

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: disable dpm on rv770 by default

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: don't allow runpm=1 on systems with out ATPX

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon/pm: don't walk the crtc list before it has been initialized (v2)

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: fix ATPX detection on non-VGA GPUs

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: properly unregister hwmon interface (v2)

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon/ci: make sure mc ucode is loaded before checking the size

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon/si: make sure mc ucode is loaded before checking the size

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: re-enable mclk dpm on R7 260X asics

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: add support for newer mc ucode on CI (v2)

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: add support for newer mc ucode on SI (v2)

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: disable mclk dpm on R7 260X

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: fix runpm handling on APUs (v4)

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: fix audio pin counts for DCE6+ (v2)

Egbert Eich <eich@suse.de>
    drm/i915: Break encoder->crtc link separately in intel_sanitize_crtc()

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Don't WARN nor handle unexpected hpd interrupts on gmch platforms

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Don't check gmch state on inherited configs

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Allow user modes to exceed DVI 165MHz limit

Neil Greatorex <neil@fatboyfat.co.uk>
    irqchip: armada-370-xp: Fix releasing of MSIs

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    irqchip: armada-370-xp: implement the ->check_device() msi_chip operation

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    irqchip: armada-370-xp: fix invalid cast of signed value into unsigned variable

Kieran Clancy <clancy.kieran@gmail.com>
    ACPI / EC: Process rather than discard events in acpi_ec_clear

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PNP / ACPI: Do not return errors if _DIS or _SRS are not present

NeilBrown <neilb@suse.de>
    md: avoid possible spinning md thread at shutdown.

NeilBrown <neilb@suse.de>
    md/raid10: call wait_barrier() for each request submitted.

Mike Snitzer <snitzer@redhat.com>
    dm cache: fix writethrough mode quiescing in cache_map

Milan Broz <gmazyland@gmail.com>
    dm verity: fix biovecs hash calculation regression

Viresh Kumar <viresh.kumar@linaro.org>
    hrtimer: Set expiry time before switch_hrtimer_base()

Leon Ma <xindong.ma@intel.com>
    hrtimer: Prevent remote enqueue of leftmost timers

Stuart Hayes <stuart.w.hayes@gmail.com>
    hrtimer: Prevent all reprogramming if hang detected

Grant Likely <grant.likely@linaro.org>
    drivercore: deferral race condition fix

Josef Gajdusek <atx@atx.name>
    hwmon: (emc1403) Support full range of known chip revision numbers

Jean Delvare <jdelvare@suse.de>
    hwmon: (emc1403) Fix resource leak on module unload

Josef Gajdusek <atx@atx.name>
    hwmon: (emc1403) fix inverted store_hyst()

Guenter Roeck <linux@roeck-us.net>
    Revert "hwmon: (coretemp) Refine TjMax detection"

Rusty Russell <rusty@rustcorp.com.au>
    module: remove warning about waiting module removal.

Leon Yu <chianglungyu@gmail.com>
    aio: fix potential leak in aio_run_iocb().

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: delay enabling smart FIFO until after beacon RX

Chen Yucong <slaoub@gmail.com>
    hwpoison, hugetlb: lock_page/unlock_page does not match for handling a free hugepage

Mark Salter <msalter@redhat.com>
    arm64: fix pud_huge() for 2-level pagetables

Anthony Iliopoulos <anthony.iliopoulos@huawei.com>
    x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

Heiko Stuebner <heiko@sntech.de>
    drivers/rtc/rtc-hym8563.c: set uie_unsupported

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm, thp: close race between mremap() and split_huge_page()

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix on-channel remain-on-channel

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    mac80211: fix suspend vs. association race

Eliad Peller <eliad@wizery.com>
    mac80211: fix nested rtnl locking on ieee80211_reconfig

Eliad Peller <eliad@wizery.com>
    cfg80211: add cfg80211_sched_scan_stopped_rtnl

Eliad Peller <eliad@wizery.com>
    cfg80211: free sme on connection failures

Ilan Peer <ilan.peer@intel.com>
    cfg80211: fix few minor issues in reg_process_hint()

Corey Minyard <cminyard@mvista.com>
    ipmi: Reset the KCS timeout when starting error recovery

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    ipmi: Fix a race restarting the timer

Jiri Bohac <jbohac@suse.cz>
    timer: Prevent overflow in apply_slack

Stephen Warren <swarren@nvidia.com>
    gpu: host1x: handle the correct # of syncpt regs

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: 7000: bump API to 9

Eyal Shapira <eyal@wizery.com>
    iwlwifi: mvm: rs: reinit rs if no tx for a long time

Eyal Shapira <eyal@wizery.com>
    iwlwifi: mvm: rs: fix and cleanup rs_get_rate_action

Eyal Shapira <eyal@wizery.com>
    iwlwifi: mvm: avoid searching unnecessary columns

Eyal Shapira <eyal@wizery.com>
    iwlwifi: mvm: rs: fallback to legacy Tx columns

Oren Givon <oren.givon@intel.com>
    iwlwifi: add new 7265 HW IDs

Eyal Shapira <eyal@wizery.com>
    iwlwifi: mvm: rs: fix mimo delimiter in LQ cmd

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: add MODULE_FIRMWARE for 7265

Loic Poulain <loic.poulain@intel.com>
    8250_core: Fix unwanted TX chars write

Loic Poulain <loic.poulain@intel.com>
    serial: 8250: Fix thread unsafe __dma_tx_complete function

Linus Torvalds <torvalds@linux-foundation.org>
    mm: make fixup_user_fault() check the vma access rights too

Vincent Stehlé <vincent.stehle@laposte.net>
    topology: Fix compilation warning when not in SMP

Eric Dumazet <edumazet@google.com>
    coredump: fix va_list corruption

Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    pata_at91: fix ata_host_activate() failure handling

Tejun Heo <tj@kernel.org>
    kernfs: add back missing error check in kernfs_fop_mmap()

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    clocksource: Exynos_mct: Register clock event after request_irq()

Thomas Gleixner <tglx@linutronix.de>
    clocksource: Exynos_mct: Use irq_force_affinity() in cpu bringup

Thomas Gleixner <tglx@linutronix.de>
    genirq: Allow forcing cpu affinity of interrupts

Thomas Gleixner <tglx@linutronix.de>
    irqchip: Gic: Support forced affinity setting

Rob Herring <robh@kernel.org>
    of/irq: do irq resolution in platform_get_irq

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace/module: Hardcode ftrace_module_init() call into load_module()

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Fix deadlock detector for real

Leif Lindholm <leif.lindholm@linaro.org>
    mips: dts: Fix missing device_type="memory" property in memory nodes

Aaro Koskinen <aaro.koskinen@iki.fi>
    MIPS/loongson2_cpufreq: Fix CPU clock rate setting

Thomas Gleixner <tglx@linutronix.de>
    futex: Prevent attaching to kernel threads

Thomas Gleixner <tglx@linutronix.de>
    futex: Add another early deadlock detection check


-------------

Diffstat:

 Documentation/devicetree/bindings/dma/ti-edma.txt  |   4 +-
 Documentation/i2c/busses/i2c-i801                  |   1 +
 Documentation/input/elantech.txt                   |   5 +-
 Documentation/ja_JP/HOWTO                          |   2 +-
 Documentation/ja_JP/stable_kernel_rules.txt        |   6 +-
 Documentation/zh_CN/HOWTO                          |   2 +-
 Documentation/zh_CN/stable_kernel_rules.txt        |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/am33xx.dtsi                      |   2 +-
 arch/arm/boot/dts/armada-xp-db.dts                 |   2 +-
 arch/arm/boot/dts/armada-xp-gp.dts                 |   2 +-
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts   |   2 +-
 arch/arm/boot/dts/imx53.dtsi                       |   2 +-
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts     |  18 +-
 arch/arm/boot/dts/kirkwood-nsa310-common.dtsi      |  18 +-
 arch/arm/boot/dts/ste-ccu8540.dts                  |   1 +
 arch/arm/common/edma.c                             |  48 +--
 arch/arm/kernel/crash_dump.c                       |   2 +-
 arch/arm/mach-mvebu/mvebu-soc-id.c                 |  13 +-
 arch/arm/mach-orion5x/common.h                     |   2 +-
 arch/arm64/mm/hugetlbpage.c                        |   4 +
 arch/metag/include/asm/barrier.h                   |   3 +
 arch/metag/include/asm/processor.h                 |   2 +
 arch/mips/cavium-octeon/octeon-irq.c               |   2 +-
 arch/mips/lantiq/dts/easy50712.dts                 |   1 +
 arch/mips/loongson/lemote-2f/clock.c               |   5 +-
 arch/mips/ralink/dts/mt7620a_eval.dts              |   1 +
 arch/mips/ralink/dts/rt2880_eval.dts               |   1 +
 arch/mips/ralink/dts/rt3052_eval.dts               |   1 +
 arch/mips/ralink/dts/rt3883_eval.dts               |   1 +
 arch/parisc/Kconfig                                |   1 +
 arch/parisc/include/asm/processor.h                |   2 +
 arch/parisc/kernel/syscall.S                       |  12 +-
 arch/parisc/kernel/traps.c                         |  54 ++--
 arch/parisc/mm/fault.c                             |  44 ++-
 arch/powerpc/Makefile                              |   4 +-
 arch/powerpc/include/asm/ppc_asm.h                 |   7 +-
 arch/powerpc/kernel/machine_kexec_64.c             |   2 +-
 arch/powerpc/kernel/time.c                         |   3 -
 arch/powerpc/platforms/powernv/eeh-ioda.c          |   3 +-
 arch/s390/crypto/aes_s390.c                        |   3 +
 arch/s390/crypto/des_s390.c                        |   3 +
 arch/x86/include/asm/hugetlb.h                     |   1 +
 arch/x86/kernel/ldt.c                              |   4 +-
 arch/x86/vdso/vdso32-setup.c                       |   8 +
 crypto/crypto_wq.c                                 |   2 +-
 drivers/acpi/Kconfig                               |  17 ++
 drivers/acpi/Makefile                              |   1 +
 drivers/acpi/ac.c                                  | 117 ++++----
 drivers/acpi/acpi_platform.c                       |   1 -
 drivers/acpi/acpi_processor.c                      |   1 -
 drivers/acpi/acpica/acglobal.h                     |   4 +-
 drivers/acpi/acpica/tbutils.c                      |   7 +-
 drivers/acpi/battery.c                             | 329 ++++++++++++++++++++-
 drivers/acpi/blacklist.c                           |  21 ++
 drivers/acpi/cm_sbs.c                              | 105 +++++++
 drivers/acpi/ec.c                                  |  21 +-
 drivers/acpi/video.c                               |  16 +-
 drivers/ata/libata-core.c                          |   9 +
 drivers/ata/pata_at91.c                            |  11 +-
 drivers/base/dd.c                                  |  17 ++
 drivers/base/platform.c                            |   7 +-
 drivers/base/topology.c                            |   3 +-
 drivers/bluetooth/ath3k.c                          |   2 +
 drivers/bluetooth/btusb.c                          |   5 +-
 drivers/bus/mvebu-mbus.c                           |   6 -
 drivers/char/ipmi/ipmi_kcs_sm.c                    |   5 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |  46 +--
 drivers/char/tpm/tpm_ppi.c                         |   8 +-
 drivers/clk/clk.c                                  |  74 ++---
 drivers/clk/tegra/clk-pll.c                        |   2 +-
 drivers/clk/versatile/clk-vexpress-osc.c           |   2 +-
 drivers/clocksource/exynos_mct.c                   |  12 +-
 drivers/cpufreq/intel_pstate.c                     |  34 +--
 drivers/cpufreq/loongson2_cpufreq.c                |   4 +-
 drivers/crypto/caam/error.c                        |  10 +-
 drivers/dma/dmaengine.c                            |   2 +
 drivers/dma/dw/core.c                              |  11 +-
 drivers/dma/mv_xor.c                               |   8 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  90 +++++-
 drivers/gpu/drm/i915/i915_gem.c                    |   4 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  18 +-
 drivers/gpu/drm/i915/intel_display.c               |  52 ++--
 drivers/gpu/drm/i915/intel_drv.h                   |   3 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |   9 +-
 drivers/gpu/drm/i915/intel_panel.c                 |   8 +-
 drivers/gpu/drm/i915/intel_pm.c                    |  10 +
 drivers/gpu/drm/i915/intel_uncore.c                |   2 +
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c    |  19 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |   3 -
 drivers/gpu/drm/nouveau/nouveau_display.c          |   2 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |   8 +
 drivers/gpu/drm/radeon/cik.c                       | 104 ++++++-
 drivers/gpu/drm/radeon/cik_sdma.c                  |   2 +-
 drivers/gpu/drm/radeon/cikd.h                      |   9 +
 drivers/gpu/drm/radeon/dce6_afmt.c                 |  14 +-
 drivers/gpu/drm/radeon/evergreen.c                 |  28 +-
 drivers/gpu/drm/radeon/r600.c                      |  13 +-
 drivers/gpu/drm/radeon/r600_dpm.c                  |  35 ++-
 drivers/gpu/drm/radeon/radeon.h                    |  12 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c       |   9 +-
 drivers/gpu/drm/radeon/radeon_device.c             |  19 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   4 +
 drivers/gpu/drm/radeon/radeon_drv.c                |  24 +-
 drivers/gpu/drm/radeon/radeon_family.h             |   1 +
 drivers/gpu/drm/radeon/radeon_kms.c                |  12 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |  51 ++--
 drivers/gpu/drm/radeon/radeon_ucode.h              |   7 +-
 drivers/gpu/drm/radeon/radeon_uvd.c                |   4 +
 drivers/gpu/drm/radeon/si.c                        |  65 ++--
 drivers/gpu/drm/radeon/uvd_v1_0.c                  |  10 +-
 drivers/gpu/host1x/hw/intr_hw.c                    |   4 +-
 drivers/hwmon/coretemp.c                           |   4 +-
 drivers/hwmon/emc1403.c                            |  10 +-
 drivers/i2c/busses/Kconfig                         |   1 +
 drivers/i2c/busses/i2c-designware-core.c           |   3 +
 drivers/i2c/busses/i2c-i801.c                      |   3 +
 drivers/i2c/busses/i2c-rcar.c                      |   9 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |   7 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  27 +-
 drivers/infiniband/ulp/isert/ib_isert.h            |   2 +-
 drivers/input/keyboard/atkbd.c                     |  29 +-
 drivers/input/mouse/elantech.c                     |  26 +-
 drivers/input/mouse/elantech.h                     |   1 +
 drivers/input/mouse/synaptics.c                    | 195 ++++++------
 drivers/input/serio/i8042-x86ia64io.h              |  15 +
 drivers/input/serio/i8042.c                        |   6 +
 drivers/input/serio/serio.c                        |  14 +
 drivers/iommu/amd_iommu.c                          |   2 +-
 drivers/irqchip/irq-armada-370-xp.c                |  17 +-
 drivers/irqchip/irq-gic.c                          |   8 +-
 drivers/leds/leds-pwm.c                            |  23 +-
 drivers/md/dm-cache-target.c                       |   1 +
 drivers/md/dm-crypt.c                              |  61 +---
 drivers/md/dm-thin.c                               |  23 +-
 drivers/md/dm-verity.c                             |  15 +-
 drivers/md/md.c                                    |   3 +-
 drivers/md/raid10.c                                |  13 +-
 drivers/media/i2c/ov7670.c                         |   2 +-
 drivers/media/media-device.c                       |   1 +
 drivers/media/tuners/fc2580.c                      |   6 +-
 drivers/media/tuners/fc2580_priv.h                 |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  12 +-
 drivers/memory/mvebu-devbus.c                      |  15 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |  20 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   7 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  14 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c            |   5 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c         |  12 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |   7 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c              | 219 ++++++++------
 drivers/net/wireless/iwlwifi/mvm/rs.h              |   2 +
 drivers/net/wireless/iwlwifi/mvm/sf.c              |   3 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c            |   2 +
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  10 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |  22 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |   2 +-
 drivers/of/irq.c                                   |  26 ++
 drivers/of/platform.c                              |   4 +-
 drivers/pci/host/pci-mvebu.c                       |  92 +++++-
 drivers/pci/hotplug/shpchp_ctrl.c                  |   4 +-
 drivers/pci/pci.c                                  |   5 +-
 drivers/pnp/pnpacpi/core.c                         |  44 +--
 drivers/rtc/rtc-hym8563.c                          |   3 +
 drivers/spi/spi.c                                  |  11 +-
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/target/target_core_device.c                |  12 +-
 drivers/target/target_core_transport.c             |   2 +-
 drivers/target/tcm_fc/tfc_cmd.c                    |   8 +-
 drivers/tty/serial/8250/8250_core.c                |   2 +-
 drivers/tty/serial/8250/8250_dma.c                 |   9 +-
 drivers/usb/gadget/at91_udc.c                      |  10 -
 drivers/usb/host/ehci-fsl.c                        |   3 +-
 drivers/usb/host/ohci-hub.c                        |  18 ++
 drivers/usb/host/ohci-pci.c                        |   1 +
 drivers/usb/host/ohci.h                            |   2 +
 drivers/usb/serial/qcserial.c                      |  15 +
 drivers/usb/storage/shuttle_usbat.c                |   2 +-
 drivers/usb/storage/unusual_devs.h                 |  14 +
 fs/affs/super.c                                    |   2 -
 fs/aio.c                                           |   6 +-
 fs/autofs4/root.c                                  |   4 +-
 fs/ceph/dir.c                                      |   9 +-
 fs/ceph/inode.c                                    |  71 +----
 fs/ceph/super.h                                    |   1 -
 fs/coredump.c                                      |   7 +-
 fs/dcache.c                                        |   3 +-
 fs/exec.c                                          |   6 +-
 fs/kernfs/file.c                                   |   2 +
 fs/namei.c                                         |   6 +-
 fs/nfsd/nfs4acl.c                                  |  17 +-
 fs/nfsd/nfs4state.c                                |  40 ++-
 fs/posix_acl.c                                     |   6 +
 fs/sysfs/file.c                                    |   3 +-
 include/linux/dmaengine.h                          |   1 +
 include/linux/ftrace.h                             |   2 +
 include/linux/interrupt.h                          |  40 ++-
 include/linux/irq.h                                |   3 +-
 include/linux/of_irq.h                             |   5 +
 include/linux/serio.h                              |   1 +
 include/net/cfg80211.h                             |  12 +
 include/trace/events/module.h                      |   2 +-
 include/uapi/drm/tegra_drm.h                       |   1 -
 include/uapi/linux/input.h                         |   1 +
 kernel/futex.c                                     |  52 +++-
 kernel/hrtimer.c                                   |  30 +-
 kernel/irq/manage.c                                |  17 +-
 kernel/kexec.c                                     |   8 +
 kernel/locking/rtmutex.c                           |  32 +-
 kernel/module.c                                    |   6 +-
 kernel/timer.c                                     |   2 +-
 kernel/trace/ftrace.c                              |  27 +-
 kernel/workqueue.c                                 |  36 ++-
 mm/compaction.c                                    |  22 +-
 mm/memory-failure.c                                |  15 +-
 mm/memory.c                                        |   5 +
 mm/mremap.c                                        |   9 +-
 mm/page-writeback.c                                |   6 +-
 mm/percpu.c                                        |   2 +-
 mm/vmscan.c                                        |  18 ++
 net/bluetooth/hci_conn.c                           |   9 +-
 net/bluetooth/hci_event.c                          |   6 +
 net/ceph/messenger.c                               |  20 +-
 net/mac80211/ieee80211_i.h                         |   1 +
 net/mac80211/mlme.c                                |  20 +-
 net/mac80211/offchannel.c                          |  27 +-
 net/mac80211/util.c                                |   2 +-
 net/wireless/reg.c                                 |  19 +-
 net/wireless/scan.c                                |  12 +-
 net/wireless/sme.c                                 |   2 +-
 security/device_cgroup.c                           | 203 ++++++++++---
 sound/pci/hda/hda_intel.c                          |   3 +
 sound/pci/hda/patch_hdmi.c                         |   4 +-
 sound/soc/codecs/wm8962.c                          |  15 +-
 sound/soc/codecs/wm8962.h                          |   4 +
 sound/soc/soc-dapm.c                               |   7 +-
 sound/usb/card.h                                   |   1 +
 sound/usb/endpoint.c                               |  15 +-
 240 files changed, 2763 insertions(+), 1205 deletions(-)


