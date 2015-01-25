Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbbAYTBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:01:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbbAYSJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.18 000/183] 3.18.4-stable review
Date: Sun, 25 Jan 2015 10:05:22 -0800
Message-Id: <20150125180810.160428929@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.18.4 release.
There are 183 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Jan 27 18:07:34 UTC 2015.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.18.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.18.4-rc1

Bandan Das <bsd@redhat.com>
    KVM: nVMX: Disable unrestricted mode if ept=0

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Kill check_power_well() calls

Nicholas Bellinger <nab@linux-iscsi.org>
    vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Drop arbitrary maximum I/O size limit

Trond Myklebust <trond.myklebust@primarydata.com>
    LOCKD: Fix a race when initialising nlmsvc_timeout

Michal Marek <mmarek@suse.cz>
    kbuild: Fix removal of the debian/ directory

Daniel Borkmann <dborkman@redhat.com>
    x86, um: actually mark system call tables readonly

Richard Weinberger <richard@nod.at>
    um: Skip futex_atomic_cmpxchg_inatomic() test

Dan Carpenter <dan.carpenter@oracle.com>
    decompress_bunzip2: off by one in get_next_block()

Lars-Peter Clausen <lars@metafoo.de>
    iio: ad799x: Fix ad7991/ad7995/ad7999 config setup

Mugunthan V N <mugunthanvnm@ti.com>
    ARM: dts: dra7-evm: fix qspi device tree partition size

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: shmobile: sh73a0 legacy: Set .control_parent for all irqpin instances

Jisheng Zhang <jszhang@marvell.com>
    ARM: dts: berlin: add broken-cd and set bus width for eMMC in Marvell DMP DT

Keerthy <j-keerthy@ti.com>
    bus: omap_l3_noc: Correct returning IRQ_HANDLED unconditionally in the irq handler

Keerthy <j-keerthy@ti.com>
    bus: omap_l3_noc: Add resume hook to restore context

Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
    ARM: omap5/dra7xx: Enable booting secondary CPU in HYP mode

Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
    ARM: omap5/dra7xx: Fix frequency typos

Gary Bisson <bisson.gary@gmail.com>
    ARM: clk-imx6q: fix video divider for rev T0 1.0

Dmitry Voytik <voytikd@gmail.com>
    ARM: imx6q: drop unnecessary semicolon

Fabio Estevam <fabio.estevam@freescale.com>
    ARM: dts: imx51-babbage: Fix ULPI PHY reset modelling

Fabio Estevam <fabio.estevam@freescale.com>
    ARM: dts: imx25: Fix the SPI1 clocks

Fabio Estevam <fabio.estevam@freescale.com>
    ARM: imx6sx: Set PLL2 as parent of QSPI clocks

Nishanth Menon <nm@ti.com>
    ARM: omap2plus_defconfig: use CONFIG_CPUFREQ_DT

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: I8042 - add Acer Aspire 7738 to the nomux list

Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>
    Input: i8042 - reset keyboard to fix Elantech touchpad detection

Sam hung <sam.hung@emc.com.tw>
    Input: elantech - support new ICs types for version 4

Ahmed S. Darwish <ahmed.darwish@valeo.com>
    can: kvaser_usb: Don't send a RESET_CHIP for non-existing channels

Ahmed S. Darwish <ahmed.darwish@valeo.com>
    can: kvaser_usb: Reset all URB tx contexts upon channel close

Ahmed S. Darwish <ahmed.darwish@valeo.com>
    can: kvaser_usb: Don't free packets when tight on URBs

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: musb: stuff leak of struct usb_hcd

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: fix initialization bug in iso_stream_schedule()

Johan Hovold <johan@kernel.org>
    USB: console: fix potential use after free

Johan Hovold <johan@kernel.org>
    USB: console: fix uninitialised ldisc semaphore

Songjun Wu <songjun.wu@atmel.com>
    usb: gadget: udc: atmel: fix possible oops when unloading module

Bo Shen <voice.shen@atmel.com>
    usb: gadget: udc: atmel: fix possible IN hang issue

Bo Shen <voice.shen@atmel.com>
    usb: gadget: udc: atmel: change setting for DMA

Mario Schuknecht <mario.schuknecht@dresearch-fe.de>
    usb: gadget: gadgetfs: Free memory allocated by memdup_user()

Johan Hovold <johan@kernel.org>
    USB: keyspan: fix null-deref at probe

Reinhard Speyerer <rspmn@arcor.de>
    USB: qcserial/option: make AT URCs work for Sierra Wireless MC73xx

David Peterson <david.peterson@cel.com>
    USB: cp210x: add IDs for CEL USB sticks and MeshWorks devices

Preston Fick <pffick@gmail.com>
    USB: cp210x: fix ID for production CEL MeshConnect USB Stick

Amit Virdi <amit.virdi@st.com>
    usb: dwc3: gadget: Stop TRB preparation after limit is reached

Amit Virdi <amit.virdi@st.com>
    usb: dwc3: gadget: Fix TRB preparation during SG

Arseny Solokha <asolokha@kb.kras.ru>
    OHCI: add a quirk for ULi M5237 blocking on reset

Johan Hovold <johan@kernel.org>
    gpio: sysfs: fix gpio device-attribute leak

Johan Hovold <johan@kernel.org>
    gpio: sysfs: fix gpio-chip device-attribute leak

Johan Hovold <johan@kernel.org>
    gpio: fix sleep-while-atomic in gpiochip_remove

Johan Hovold <johan@kernel.org>
    gpio: fix memory leak and sleep-while-atomic

Johan Hovold <johan@kernel.org>
    gpio: fix memory and reference leaks in gpiochip_add error path

Aaron Lu <aaron.lu@intel.com>
    gpio: crystalcove: use handle_nested_irq

Hans Holmberg <hans.holmberg@intel.com>
    gpiolib: of: Correct error handling in of_get_named_gpiod_flags

Johan Hovold <johan@kernel.org>
    pinctrl: lantiq: remove bogus of_gpio_chip_add

Jisheng Zhang <jszhang@marvell.com>
    ARM: dts: berlin: correct BG2Q's SM GPIO location.

Tyler Baker <tyler.baker@linaro.org>
    reset: sunxi: fix spinlock initialization

Hans de Goede <hdegoede@redhat.com>
    uas: Add US_FL_NO_ATA_1X for 2 more Seagate disk enclosures

Hans de Goede <hdegoede@redhat.com>
    uas: Add US_FL_NO_REPORT_OPCODES for JMicron JMS566 with usb-id 0bc2:a013

Hans de Goede <hdegoede@redhat.com>
    uas: Add US_FL_NO_ATA_1X for Seagate devices with usb-id 0bc2:a013

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: clean reset bit before reset

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4.1: Fix client id trunking on Linux

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Check both notrace and filter for old hash

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Fix updating of filters for shared global_ops filters

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace/jprobes/x86: Fix conflict between jprobes and function graph tracing

Simon Guinot <simon.guinot@sequanux.org>
    leds: netxbig: fix oops at probe time

Mugunthan V N <mugunthanvnm@ti.com>
    drivers: net: cpsw: fix multicast flush in dual emac mode

Vasu Dev <vasu.dev@intel.com>
    i40e: adds FCoE configure option

Eyal Shapira <eyal@wizery.com>
    iwlwifi: mvm: fix Rx with both chains

Catalin Marinas <catalin.marinas@arm.com>
    arm64: partially revert "ARM: 8167/1: extend the reserved memory for initrd to be page aligned"

Tim Kryger <tim.kryger@gmail.com>
    mmc: sdhci: Set SDHCI_POWER_ON with external vmmc

Anton Blanchard <anton@samba.org>
    powernv: Fix OPAL tracepoint code

NeilBrown <neilb@suse.de>
    locks: fix NULL-deref in generic_delete_lease

Wei Yang <weiyang@linux.vnet.ibm.com>
    vfio-pci: Fix the check on pci device type in vfio_pci_probe()

Hans Verkuil <hverkuil@xs4all.nl>
    vivid: fix CROP_BOUNDS typo for video output

James Hogan <james.hogan@imgtec.com>
    img-ir/hw: Fix potential deadlock stopping timer

Dylan Rajaratnam <dylan.rajaratnam@imgtec.com>
    img-ir/hw: Always read data to clear buffer

Takashi Iwai <tiwai@suse.de>
    uvcvideo: Fix destruction order in uvc_delete()

Mauro Carvalho Chehab <mchehab@osg.samsung.com>
    sound: Update au0828 quirks table

Mauro Carvalho Chehab <mchehab@osg.samsung.com>
    sound: simplify au0828 quirk table

Sakari Ailus <sakari.ailus@linux.intel.com>
    smiapp: Take mutex during PLL update in sensor initialisation

Frank Schaefer <fschaefer.oss@googlemail.com>
    af9005: fix kernel panic on init if compiled without IR

Sakari Ailus <sakari.ailus@linux.intel.com>
    smiapp-pll: Correct clock debug prints

Tomi Valkeinen <tomi.valkeinen@ti.com>
    video/fbdev: fix defio's fsync

Tomi Valkeinen <tomi.valkeinen@ti.com>
    video/logo: prevent use of logos after they have been freed

Bjørn Mork <bjorn@mork.no>
    x86/build: Clean auto-generated processor feature files

Felipe Balbi <balbi@ti.com>
    net: ethernet: cpsw: fix hangs with interrupts

Long Li <longli@microsoft.com>
    storvsc: ring buffer failures may result in I/O freeze

James Bottomley <JBottomley@Parallels.com>
    serial: fix parisc boot hang

John David Anglin <dave.anglin@bell.net>
    parisc: fix out-of-register compiler error in ldcw inline assembler function

zhendong chen <alex.chen@huawei.com>
    dm: fix missed error code if .end_io isn't implemented by target_type

Mauro Carvalho Chehab <mchehab@osg.samsung.com>
    bugon.cocci: fix Options at the macro

Jisheng Zhang <jszhang@marvell.com>
    ARM: dts: berlin: fix io clk and add missing core clk for BG2Q sdhci2 host

Boris Brezillon <boris.brezillon@free-electrons.com>
    clk: at91: keep slow clk enabled to prevent system hang

Jisheng Zhang <jszhang@marvell.com>
    clk: berlin: bg2q: remove non-exist "smemc" gate clock

Heiko Stuebner <heiko@sntech.de>
    clk: rockchip: fix rk3066 pll lock bit location

Heiko Stuebner <heiko@sntech.de>
    clk: rockchip: fix rk3288 cpuclk core dividers

Kevin Hao <haokexin@gmail.com>
    Revert "clk: ppc-corenet: Fix Section mismatch warning"

Tomeu Vizoso <tomeu.vizoso@collabora.com>
    clk: Don't try to use a struct clk* after it could have been freed

Stephen Boyd <sboyd@codeaurora.org>
    clk: Really fix deadlock with mmap_sem

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    clk: samsung: Fix double add of syscore ops after driver rebind

Alan Stern <stern@rowland.harvard.edu>
    SCSI: fix regression in scsi_send_eh_cmnd()

Tony Battersby <tonyb@cybernetics.com>
    scsi: fix random memory corruption with scsi-mq + T10 PI

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: blacklist RSOC for Microsoft iSCSI target devices

Sreekanth Reddy <sreekanth.reddy@avagotech.com>
    Revert "[SCSI] mpt3sas: Remove phys on topology change"

Sreekanth Reddy <sreekanth.reddy@avagotech.com>
    Revert "[SCSI] mpt2sas: Remove phys on topology change."

Ville Syrjälä <ville.syrjala@linux.intel.com>
    Revert "drm/i915: Preserve VGACNTR bits from the BIOS"

Sagi Grimberg <sagig@mellanox.com>
    iscsi,iser-target: Expose supported protection ops according to t10_pi

Sagi Grimberg <sagig@mellanox.com>
    iser-target: Fix NULL dereference in SW mode DIF

Sagi Grimberg <sagig@mellanox.com>
    iser-target: Allocate PI contexts dynamically

Sagi Grimberg <sagig@mellanox.com>
    iser-target: Fix implicit termination of connections

Sagi Grimberg <sagig@mellanox.com>
    iser-target: Handle ADDR_CHANGE event for listener cm_id

Sagi Grimberg <sagig@mellanox.com>
    iser-target: Fix connected_handler + teardown flow race

Sagi Grimberg <sagig@mellanox.com>
    iser-target: Parallelize CM connection establishment

Sagi Grimberg <sagig@mellanox.com>
    iser-target: Fix flush + disconnect completion handling

Sagi Grimberg <sagig@mellanox.com>
    iscsi,iser-target: Initiate termination only once

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fail connection on short sendmsg writes

Thomas Gleixner <tglx@linutronix.de>
    genirq: Prevent proc race against freeing of irq descriptors

Max Gurtovoy <maxg@mellanox.com>
    IB/iser: Fix possible SQ overflow

Hannes Reinecke <hare@suse.de>
    tcm_loop: Fix wrong I_T nexus association

Kyle McMartin <kyle@redhat.com>
    uapi/linux/target_core_user.h: fix headers_install.sh badness

Thomas Gleixner <tglx@linutronix.de>
    tick/powerclamp: Remove tick_nohz_idle abuse

Dominique Leuenberger <dimstar@opensuse.org>
    hp_accel: Add support for HP ZBook 15

Hans de Goede <hdegoede@redhat.com>
    asus-nb-wmi: Add another wapf=4 quirk

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Fix error when accessing unmapped memory in skb

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192ce: Set fw_ready flag

Jouni Malinen <jouni@qca.qualcomm.com>
    cfg80211: Fix 160 MHz channels with 80+80 and 160 MHz drivers

Arik Nemtsov <arik@wizery.com>
    cfg80211: avoid mem leak on driver hint set

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    cfg80211: don't WARN about two consecutive Country IE hint

Luciano Coelho <luciano.coelho@intel.com>
    nl80211: check matches array length before acessing it

Hans de Goede <hdegoede@redhat.com>
    xhci: Add broken-streams quirk for Fresco Logic FL1000G xhci controllers

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Check if slot is already in default state before moving it there

Ian Munsie <imunsie@au1.ibm.com>
    cxl: Unmap MMIO regions when detaching a context

Ian Munsie <imunsie@au1.ibm.com>
    cxl: Add timeout to process element commands

Ian Munsie <imunsie@au1.ibm.com>
    cxl: Change contexts_lock to a mutex to fix sleep while atomic bug

Vineet Gupta <vgupta@synopsys.com>
    ARC: [nsimosci] move peripherals to match model to FPGA

Rob Clark <robdclark@gmail.com>
    drm/irq: BUG_ON() -> WARN_ON()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Don't call intel_prepare_page_flip() multiple times on gen2-4

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Disable PSMI sleep messages on all rings around context switches

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Force the CS stall for invalidate flushes

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Invalidate media caches on gen7

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nv4c/mc: disable msi

Jesse Barnes <jbarnes@virtuousgeek.org>
    drm/i915: save/restore GMBUS freq across suspend/resume on gen4

Dave Airlie <airlied@redhat.com>
    drm/i915: resume MST after reading back hw state

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Only warn the first time we attempt to mmio whilst suspended

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Disallow pin ioctl completely for kms drivers

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Don't complain about stolen conflicts on gen3

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: adjust default bapm settings for KV

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix sad_count check for dce3

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: KV has three PPLLs (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: check the right ring in radeon_evict_flags()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: work around a hw bug in MGCG on CIK

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in CI dpm disable

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/dp-mst: Remove branches before dropping the reference

Dave Airlie <airlied@redhat.com>
    drm/dp: retry AUX transactions 32 times (v1.1)

Dave Airlie <airlied@redhat.com>
    drm/fb_helper: move deferred fb checking into restore mode (v2)

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    drm/ttm: Avoid memory allocation from shrinker functions.

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix fence event code

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix error printout on signals pending

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Don't use memory accounting for kernel-side fence objects

Govindarajulu Varadarajan <_govind@gmx.com>
    enic: fix rx skb checksum

Jiri Pirko <jiri@resnulli.us>
    team: avoid possible underflow of count_pending value for notify_peers and mcast_rejoin

Eric Dumazet <edumazet@google.com>
    alx: fix alx_poll()

Palik, Imre <imrep@amazon.de>
    xen-netback: fixing the propagation of the transmit shaper timeout

Herbert Xu <herbert@gondor.apana.org.au>
    tcp: Do not apply TSO segment limit to non-TSO packets

Maor Gottlieb <maorg@mellanox.com>
    net/mlx4_core: Correcly update the mtt's offset in the MR re-reg flow

Jesse Gross <jesse@nicira.com>
    net: Generalize ndo_gso_check to ndo_features_check

Jay Vosburgh <jay.vosburgh@canonical.com>
    net/core: Handle csum for CHECKSUM_COMPLETE VXLAN forwarding

Thomas Graf <tgraf@suug.ch>
    net: Reset secmark when scrubbing packet

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
    net: Fix stacked vlan offload features computation

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    tcp6: don't move IP6CB before xfrm6_policy_check()

Amir Vadai <amirv@mellanox.com>
    net/mlx4_en: Doorbell is byteswapped in Little Endian archs

Antonio Quartulli <antonio@meshcoding.com>
    batman-adv: avoid NULL dereferences and fix if check

Sven Eckelmann <sven@narfation.org>
    batman-adv: Unify fragment size calculation

Sven Eckelmann <sven@narfation.org>
    batman-adv: Calculate extra tail size based on queued fragments

Prashant Sreedharan <prashant@broadcom.com>
    tg3: tg3_disable_ints using uninitialized mailbox value to disable interrupts

stephen hemminger <stephen@networkplumber.org>
    in6: fix conflict with glibc

Jason Wang <jasowang@redhat.com>
    net: drop the packet when fails to do software segmentation or header check

David Vrabel <david.vrabel@citrix.com>
    xen-netback: support frontends without feature-rx-notify again

Jesse Gross <jesse@nicira.com>
    geneve: Fix races between socket add and release.

Jesse Gross <jesse@nicira.com>
    geneve: Remove socket and offload handlers at destruction.

Thomas Graf <tgraf@suug.ch>
    netlink: Don't reorder loads/stores before marking mmap netlink frame as available

David Miller <davem@davemloft.net>
    netlink: Always copy on mmap TX.

Ido Shamay <idos@mellanox.com>
    net/mlx4: Cache line CQE/EQE stride fixes

Timo Teräs <timo.teras@iki.fi>
    gre: fix the inner mac header in nbma tunnel xmit path


-------------

Diffstat:

 Documentation/kernel-parameters.txt              |   1 +
 Makefile                                         |   4 +-
 arch/arc/boot/dts/nsimosci.dts                   |  18 +-
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts       |   2 +
 arch/arm/boot/dts/berlin2q.dtsi                  |  63 +--
 arch/arm/boot/dts/dra7-evm.dts                   |  10 +-
 arch/arm/boot/dts/imx25.dtsi                     |   2 +-
 arch/arm/boot/dts/imx51-babbage.dts              |  22 +-
 arch/arm/configs/omap2plus_defconfig             |   2 +-
 arch/arm/mach-imx/clk-imx6q.c                    |   4 +-
 arch/arm/mach-imx/clk-imx6sx.c                   |   3 +
 arch/arm/mach-omap2/common.h                     |   1 +
 arch/arm/mach-omap2/omap-headsmp.S               |  21 +
 arch/arm/mach-omap2/omap-smp.c                   |  13 +-
 arch/arm/mach-omap2/timer.c                      |   8 +-
 arch/arm/mach-shmobile/setup-sh73a0.c            |   3 +
 arch/arm64/mm/init.c                             |   8 +-
 arch/parisc/include/asm/ldcw.h                   |  13 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S   |   1 -
 arch/um/Kconfig.common                           |   1 +
 arch/x86/boot/Makefile                           |   1 +
 arch/x86/kernel/cpu/Makefile                     |   1 +
 arch/x86/kernel/kprobes/core.c                   |  20 +-
 arch/x86/kvm/vmx.c                               |   4 +-
 arch/x86/um/sys_call_table_32.c                  |   2 +-
 arch/x86/um/sys_call_table_64.c                  |   2 +-
 drivers/bus/omap_l3_noc.c                        |  63 ++-
 drivers/clk/at91/clk-slow.c                      |  27 +
 drivers/clk/berlin/bg2q.c                        |   1 -
 drivers/clk/clk-ppc-corenet.c                    |   2 +-
 drivers/clk/clk.c                                |  10 +-
 drivers/clk/rockchip/clk-rk3188.c                |  15 +-
 drivers/clk/rockchip/clk-rk3288.c                |  28 +-
 drivers/clk/samsung/clk-exynos-audss.c           |   4 +
 drivers/gpio/gpio-crystalcove.c                  |   2 +-
 drivers/gpio/gpiolib-of.c                        |  10 +-
 drivers/gpio/gpiolib-sysfs.c                     |  47 +-
 drivers/gpio/gpiolib.c                           |  18 +-
 drivers/gpu/drm/drm_dp_helper.c                  |   7 +-
 drivers/gpu/drm/drm_dp_mst_topology.c            |   5 +-
 drivers/gpu/drm/drm_fb_helper.c                  |  13 +-
 drivers/gpu/drm/drm_irq.c                        |   3 +-
 drivers/gpu/drm/i915/i915_drv.c                  |   3 +-
 drivers/gpu/drm/i915/i915_drv.h                  |   3 +-
 drivers/gpu/drm/i915/i915_gem.c                  |   5 +-
 drivers/gpu/drm/i915/i915_gem_context.c          |  48 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c           |   6 +-
 drivers/gpu/drm/i915/i915_irq.c                  |   6 +-
 drivers/gpu/drm/i915/i915_reg.h                  |   4 +
 drivers/gpu/drm/i915/i915_suspend.c              |   8 +
 drivers/gpu/drm/i915/intel_display.c             |   8 +-
 drivers/gpu/drm/i915/intel_pm.c                  |  27 -
 drivers/gpu/drm/i915/intel_ringbuffer.c          |   3 +
 drivers/gpu/drm/i915/intel_uncore.c              |   4 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c    |   8 -
 drivers/gpu/drm/radeon/atombios_crtc.c           |   8 +-
 drivers/gpu/drm/radeon/atombios_dp.c             |   4 +
 drivers/gpu/drm/radeon/ci_dpm.c                  |   2 +-
 drivers/gpu/drm/radeon/cik.c                     |   3 +-
 drivers/gpu/drm/radeon/dce3_1_afmt.c             |   2 +-
 drivers/gpu/drm/radeon/kv_dpm.c                  |  10 +-
 drivers/gpu/drm/radeon/radeon_ttm.c              |   2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c             |  26 +-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c         |  25 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c              |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c            |  39 +-
 drivers/iio/adc/ad799x.c                         |  15 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h         |   2 +
 drivers/infiniband/ulp/iser/iser_initiator.c     |   6 +-
 drivers/infiniband/ulp/isert/ib_isert.c          | 640 +++++++++++++++--------
 drivers/infiniband/ulp/isert/ib_isert.h          |  15 +-
 drivers/input/mouse/elantech.c                   |   2 +
 drivers/input/serio/i8042-x86ia64io.h            |  39 ++
 drivers/input/serio/i8042.c                      |  14 +
 drivers/leds/leds-netxbig.c                      |  12 +-
 drivers/md/dm.c                                  |   2 +-
 drivers/media/i2c/smiapp-pll.c                   |   4 +-
 drivers/media/i2c/smiapp/smiapp-core.c           |   2 +
 drivers/media/platform/vivid/vivid-vid-out.c     |   2 +-
 drivers/media/rc/img-ir/img-ir-hw.c              |  28 +-
 drivers/media/rc/img-ir/img-ir-hw.h              |   3 +
 drivers/media/usb/au0828/au0828-cards.c          |   5 +
 drivers/media/usb/dvb-usb/af9005.c               |   3 +
 drivers/media/usb/uvc/uvc_driver.c               |   6 +-
 drivers/misc/cxl/context.c                       |  26 +-
 drivers/misc/cxl/cxl.h                           |   9 +-
 drivers/misc/cxl/file.c                          |   6 +-
 drivers/misc/cxl/native.c                        |  12 +-
 drivers/misc/cxl/pci.c                           |   2 +-
 drivers/misc/cxl/sysfs.c                         |  10 +-
 drivers/misc/mei/hw-me.c                         |  12 +
 drivers/mmc/host/sdhci.c                         |   6 +
 drivers/net/can/usb/kvaser_usb.c                 |  20 +-
 drivers/net/ethernet/atheros/alx/main.c          |  24 +-
 drivers/net/ethernet/broadcom/tg3.c              |  34 +-
 drivers/net/ethernet/cisco/enic/enic_main.c      |  12 +-
 drivers/net/ethernet/emulex/benet/be_main.c      |   8 +-
 drivers/net/ethernet/intel/Kconfig               |  11 +
 drivers/net/ethernet/intel/i40e/Makefile         |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_osdep.h     |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c   |  21 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c       |  12 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c          |   4 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c          |   9 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |   8 +-
 drivers/net/ethernet/ti/cpsw.c                   |  30 +-
 drivers/net/ethernet/ti/cpsw_ale.c               |  10 +-
 drivers/net/ethernet/ti/cpsw_ale.h               |   2 +-
 drivers/net/team/team.c                          |  16 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c         |   2 +-
 drivers/net/wireless/rtlwifi/pci.c               |  32 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c      |   2 +
 drivers/net/xen-netback/common.h                 |   4 +-
 drivers/net/xen-netback/interface.c              |   4 +-
 drivers/net/xen-netback/netback.c                |  27 +-
 drivers/net/xen-netback/xenbus.c                 |  13 +-
 drivers/pinctrl/pinctrl-xway.c                   |   2 -
 drivers/platform/x86/asus-nb-wmi.c               |   9 +
 drivers/platform/x86/hp_accel.c                  |   1 +
 drivers/reset/reset-sunxi.c                      |   4 +
 drivers/scsi/mpt2sas/mpt2sas_transport.c         |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c         |   5 +-
 drivers/scsi/scsi_devinfo.c                      |   1 +
 drivers/scsi/scsi_error.c                        |   4 +-
 drivers/scsi/scsi_lib.c                          |   4 +-
 drivers/scsi/storvsc_drv.c                       |   7 +-
 drivers/target/iscsi/iscsi_target_login.c        |  10 +-
 drivers/target/iscsi/iscsi_target_util.c         |  26 +-
 drivers/target/loopback/tcm_loop.c               |  66 +--
 drivers/target/loopback/tcm_loop.h               |   7 +-
 drivers/target/target_core_device.c              |   8 +-
 drivers/target/target_core_file.c                |  11 +-
 drivers/target/target_core_iblock.c              |   2 +-
 drivers/target/target_core_sbc.c                 |  15 -
 drivers/target/target_core_spc.c                 |   5 +-
 drivers/thermal/intel_powerclamp.c               |   2 -
 drivers/tty/serial/serial_core.c                 |   4 +-
 drivers/usb/dwc3/gadget.c                        |   6 +-
 drivers/usb/gadget/legacy/inode.c                |   1 +
 drivers/usb/gadget/udc/atmel_usba_udc.c          |  19 +-
 drivers/usb/host/ehci-sched.c                    |   8 +-
 drivers/usb/host/pci-quirks.c                    |  18 +-
 drivers/usb/host/xhci-pci.c                      |   2 +
 drivers/usb/host/xhci.c                          |   9 +
 drivers/usb/musb/musb_host.c                     |   1 -
 drivers/usb/serial/console.c                     |  16 +-
 drivers/usb/serial/cp210x.c                      |   4 +-
 drivers/usb/serial/keyspan.c                     |  20 +-
 drivers/usb/serial/option.c                      |  11 +-
 drivers/usb/serial/qcserial.c                    |   1 -
 drivers/usb/storage/unusual_uas.h                |  28 +
 drivers/vfio/pci/vfio_pci.c                      |   4 +-
 drivers/vhost/scsi.c                             |  24 +-
 drivers/video/fbdev/core/fb_defio.c              |   5 +-
 drivers/video/logo/logo.c                        |  17 +-
 fs/lockd/svc.c                                   |   8 +-
 fs/locks.c                                       |   2 +-
 fs/nfs/nfs4client.c                              |  17 +-
 fs/proc/stat.c                                   |   2 +-
 include/linux/kernel_stat.h                      |   1 +
 include/linux/netdevice.h                        |  20 +-
 include/net/vxlan.h                              |  28 +-
 include/uapi/linux/in6.h                         |   3 +-
 include/uapi/linux/libc-compat.h                 |   3 +
 include/uapi/linux/target_core_user.h            |   4 -
 kernel/irq/internals.h                           |   4 +
 kernel/irq/irqdesc.c                             |  52 ++
 kernel/irq/proc.c                                |  22 +-
 kernel/time/tick-sched.c                         |   2 -
 kernel/trace/ftrace.c                            |  53 +-
 lib/decompress_bunzip2.c                         |   2 +-
 net/batman-adv/fragmentation.c                   |   4 +-
 net/batman-adv/gateway_client.c                  |   2 +-
 net/core/dev.c                                   |  37 +-
 net/core/skbuff.c                                |   1 +
 net/ipv4/geneve.c                                |  30 +-
 net/ipv4/ip_gre.c                                |   9 +-
 net/ipv4/tcp_output.c                            |   4 +-
 net/ipv6/tcp_ipv6.c                              |  45 +-
 net/netlink/af_netlink.c                         |  54 +-
 net/wireless/chan.c                              |   9 +-
 net/wireless/nl80211.c                           |   2 +-
 net/wireless/reg.c                               |  12 +-
 scripts/Makefile.clean                           |  16 +-
 scripts/coccinelle/misc/bugon.cocci              |   2 +-
 sound/usb/quirks-table.h                         | 166 ++----
 186 files changed, 1854 insertions(+), 1095 deletions(-)


