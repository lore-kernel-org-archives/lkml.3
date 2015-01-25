Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbbAYTZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:25:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbbAYSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/98] 3.14.30-stable review
Date: Sun, 25 Jan 2015 10:06:18 -0800
Message-Id: <20150125180712.859646324@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.30 release.
There are 98 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Jan 27 18:06:36 UTC 2015.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.30-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.30-rc1

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/3215: fix tty output containing tabs

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/3215: fix hanging console issue

Jerry Hoemann <jerry.hoemann@hp.com>
    fsnotify: next_i is freed during fsnotify_unmount_inodes.

Alexander Y. Fomichev <git.user@gmail.com>
    net: fix creation adjacent device symlinks

Alexander Y. Fomichev <git.user@gmail.com>
    net: prevent of emerging cross-namespace symlinks

Dan Carpenter <dan.carpenter@oracle.com>
    netfilter: ipset: small potential read beyond the end of buffer

Bandan Das <bsd@redhat.com>
    KVM: nVMX: Disable unrestricted mode if ept=0

Kent Overstreet <kmo@daterainc.com>
    bcache: Make sure to pass GFP_WAIT to mempool_alloc()

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
    vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion

Hannes Reinecke <hare@suse.de>
    tcm_loop: Fix wrong I_T nexus association

Hannes Reinecke <hare@suse.de>
    tcm_loop: Fixup tag handling

Trond Myklebust <trond.myklebust@primarydata.com>
    LOCKD: Fix a race when initialising nlmsvc_timeout

Daniel Borkmann <dborkman@redhat.com>
    x86, um: actually mark system call tables readonly

Richard Weinberger <richard@nod.at>
    um: Skip futex_atomic_cmpxchg_inatomic() test

Dan Carpenter <dan.carpenter@oracle.com>
    decompress_bunzip2: off by one in get_next_block()

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: shmobile: sh73a0 legacy: Set .control_parent for all irqpin instances

Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
    ARM: omap5/dra7xx: Fix frequency typos

Gary Bisson <bisson.gary@gmail.com>
    ARM: clk-imx6q: fix video divider for rev T0 1.0

Dmitry Voytik <voytikd@gmail.com>
    ARM: imx6q: drop unnecessary semicolon

Fabio Estevam <fabio.estevam@freescale.com>
    ARM: dts: imx25: Fix the SPI1 clocks

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: I8042 - add Acer Aspire 7738 to the nomux list

Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>
    Input: i8042 - reset keyboard to fix Elantech touchpad detection

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

Johan Hovold <johan@kernel.org>
    USB: keyspan: fix null-deref at probe

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
    gpio: fix memory and reference leaks in gpiochip_add error path

Hans Holmberg <hans.holmberg@intel.com>
    gpiolib: of: Correct error handling in of_get_named_gpiod_flags

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4.1: Fix client id trunking on Linux

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace/jprobes/x86: Fix conflict between jprobes and function graph tracing

Mugunthan V N <mugunthanvnm@ti.com>
    drivers: net: cpsw: fix multicast flush in dual emac mode

Wei Yang <weiyang@linux.vnet.ibm.com>
    vfio-pci: Fix the check on pci device type in vfio_pci_probe()

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
    video/logo: prevent use of logos after they have been freed

Felipe Balbi <balbi@ti.com>
    net: ethernet: cpsw: fix hangs with interrupts

Long Li <longli@microsoft.com>
    storvsc: ring buffer failures may result in I/O freeze

John David Anglin <dave.anglin@bell.net>
    parisc: fix out-of-register compiler error in ldcw inline assembler function

Tomeu Vizoso <tomeu.vizoso@collabora.com>
    clk: Don't try to use a struct clk* after it could have been freed

Stephen Boyd <sboyd@codeaurora.org>
    clk: Really fix deadlock with mmap_sem

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    clk: samsung: Fix double add of syscore ops after driver rebind

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: blacklist RSOC for Microsoft iSCSI target devices

Sreekanth Reddy <sreekanth.reddy@avagotech.com>
    Revert "[SCSI] mpt3sas: Remove phys on topology change"

Sreekanth Reddy <sreekanth.reddy@avagotech.com>
    Revert "[SCSI] mpt2sas: Remove phys on topology change."

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fail connection on short sendmsg writes

Thomas Gleixner <tglx@linutronix.de>
    genirq: Prevent proc race against freeing of irq descriptors

Thomas Gleixner <tglx@linutronix.de>
    tick/powerclamp: Remove tick_nohz_idle abuse

Dominique Leuenberger <dimstar@opensuse.org>
    hp_accel: Add support for HP ZBook 15

Jouni Malinen <jouni@qca.qualcomm.com>
    cfg80211: Fix 160 MHz channels with 80+80 and 160 MHz drivers

Arik Nemtsov <arik@wizery.com>
    cfg80211: avoid mem leak on driver hint set

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    cfg80211: don't WARN about two consecutive Country IE hint

Vineet Gupta <vgupta@synopsys.com>
    ARC: switch to generic ENTRY/END assembler annotations

Vineet Gupta <vgupta@synopsys.com>
    ARC: [nsimosci] move peripherals to match model to FPGA

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Force the CS stall for invalidate flushes

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Invalidate media caches on gen7

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nv4c/mc: disable msi

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Only warn the first time we attempt to mmio whilst suspended

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Don't complain about stolen conflicts on gen3

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: check the right ring in radeon_evict_flags()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: work around a hw bug in MGCG on CIK

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in CI dpm disable

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    drm/ttm: Avoid memory allocation from shrinker functions.

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix fence event code

Jay Vosburgh <jay.vosburgh@canonical.com>
    net/core: Handle csum for CHECKSUM_COMPLETE VXLAN forwarding

Govindarajulu Varadarajan <_govind@gmx.com>
    enic: fix rx skb checksum

Jiri Pirko <jiri@resnulli.us>
    team: avoid possible underflow of count_pending value for notify_peers and mcast_rejoin

Eric Dumazet <edumazet@google.com>
    alx: fix alx_poll()

Herbert Xu <herbert@gondor.apana.org.au>
    tcp: Do not apply TSO segment limit to non-TSO packets

Thomas Graf <tgraf@suug.ch>
    net: Reset secmark when scrubbing packet

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
    net: Fix stacked vlan offload features computation

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

Thomas Graf <tgraf@suug.ch>
    netlink: Don't reorder loads/stores before marking mmap netlink frame as available

David Miller <davem@davemloft.net>
    netlink: Always copy on mmap TX.

Timo Teräs <timo.teras@iki.fi>
    gre: fix the inner mac header in nbma tunnel xmit path


-------------

Diffstat:

 Documentation/kernel-parameters.txt           |   1 +
 Makefile                                      |   4 +-
 arch/arc/boot/dts/nsimosci.dts                |  18 +-
 arch/arc/include/asm/linkage.h                |  14 --
 arch/arc/kernel/ctx_sw_asm.S                  |   2 +-
 arch/arc/kernel/entry.S                       |  52 ++--
 arch/arc/lib/memcmp.S                         |   6 +-
 arch/arc/lib/memcpy-700.S                     |   6 +-
 arch/arc/lib/memset.S                         |  10 +-
 arch/arc/lib/strchr-700.S                     |   6 +-
 arch/arc/lib/strcmp.S                         |   6 +-
 arch/arc/lib/strcpy-700.S                     |   6 +-
 arch/arc/lib/strlen.S                         |   6 +-
 arch/arc/mm/tlbex.S                           |  10 +-
 arch/arm/boot/dts/imx25.dtsi                  |   2 +-
 arch/arm/mach-imx/clk-imx6q.c                 |   4 +-
 arch/arm/mach-omap2/timer.c                   |   8 +-
 arch/arm/mach-shmobile/setup-sh73a0.c         |   3 +
 arch/parisc/include/asm/ldcw.h                |  13 +-
 arch/um/Kconfig.common                        |   1 +
 arch/x86/kernel/kprobes/core.c                |  20 +-
 arch/x86/kvm/vmx.c                            |   4 +-
 arch/x86/um/sys_call_table_32.c               |   2 +-
 arch/x86/um/sys_call_table_64.c               |   2 +-
 drivers/clk/clk.c                             |  10 +-
 drivers/clk/samsung/clk-exynos-audss.c        |   4 +
 drivers/gpio/gpiolib-of.c                     |  10 +-
 drivers/gpio/gpiolib.c                        |  11 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c        |   6 +-
 drivers/gpu/drm/i915/i915_reg.h               |   1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c       |   3 +
 drivers/gpu/drm/i915/intel_uncore.c           |   4 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv4c.c |   8 -
 drivers/gpu/drm/radeon/atombios_dp.c          |   4 +
 drivers/gpu/drm/radeon/ci_dpm.c               |   2 +-
 drivers/gpu/drm/radeon/cik.c                  |   3 +-
 drivers/gpu/drm/radeon/radeon_ttm.c           |   2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c          |  26 +-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c      |  25 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c         |  17 +-
 drivers/infiniband/ulp/isert/ib_isert.c       | 344 ++++++++++++++++++--------
 drivers/infiniband/ulp/isert/ib_isert.h       |   7 +-
 drivers/input/serio/i8042-x86ia64io.h         |  39 +++
 drivers/input/serio/i8042.c                   |  14 ++
 drivers/md/bcache/btree.c                     |   2 +-
 drivers/media/i2c/smiapp-pll.c                |   4 +-
 drivers/media/i2c/smiapp/smiapp-core.c        |   2 +
 drivers/media/usb/au0828/au0828-cards.c       |   5 +
 drivers/media/usb/dvb-usb/af9005.c            |   3 +
 drivers/media/usb/uvc/uvc_driver.c            |   6 +-
 drivers/net/can/usb/kvaser_usb.c              |  20 +-
 drivers/net/ethernet/atheros/alx/main.c       |  24 +-
 drivers/net/ethernet/broadcom/tg3.c           |  34 +--
 drivers/net/ethernet/cisco/enic/enic_main.c   |  12 +-
 drivers/net/ethernet/ti/cpsw.c                |  30 ++-
 drivers/net/ethernet/ti/cpsw_ale.c            |  10 +-
 drivers/net/ethernet/ti/cpsw_ale.h            |   2 +-
 drivers/net/team/team.c                       |  16 +-
 drivers/platform/x86/hp_accel.c               |   1 +
 drivers/s390/char/con3215.c                   |  52 ++--
 drivers/scsi/mpt2sas/mpt2sas_transport.c      |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c      |   5 +-
 drivers/scsi/scsi_devinfo.c                   |   1 +
 drivers/scsi/storvsc_drv.c                    |   7 +-
 drivers/target/iscsi/iscsi_target_login.c     |   3 +
 drivers/target/iscsi/iscsi_target_util.c      |  26 +-
 drivers/target/loopback/tcm_loop.c            |  89 +++----
 drivers/target/loopback/tcm_loop.h            |   7 +-
 drivers/thermal/intel_powerclamp.c            |   2 -
 drivers/usb/dwc3/gadget.c                     |   6 +-
 drivers/usb/host/ehci-sched.c                 |   8 +-
 drivers/usb/host/pci-quirks.c                 |  18 +-
 drivers/usb/musb/musb_host.c                  |   1 -
 drivers/usb/serial/console.c                  |  16 +-
 drivers/usb/serial/cp210x.c                   |   4 +-
 drivers/usb/serial/keyspan.c                  |  20 +-
 drivers/vfio/pci/vfio_pci.c                   |   4 +-
 drivers/vhost/scsi.c                          |  24 +-
 drivers/video/logo/logo.c                     |  17 +-
 fs/lockd/svc.c                                |   8 +-
 fs/nfs/nfs4client.c                           |  17 +-
 fs/notify/inode_mark.c                        |  17 +-
 fs/proc/stat.c                                |   2 +-
 include/linux/kernel_stat.h                   |   1 +
 include/uapi/linux/in6.h                      |   3 +-
 include/uapi/linux/libc-compat.h              |   3 +
 kernel/irq/internals.h                        |   8 +
 kernel/irq/irqdesc.c                          |  52 ++++
 kernel/irq/proc.c                             |  22 +-
 kernel/time/tick-sched.c                      |   2 -
 lib/decompress_bunzip2.c                      |   2 +-
 net/batman-adv/fragmentation.c                |   4 +-
 net/batman-adv/gateway_client.c               |   2 +-
 net/core/dev.c                                |  89 ++++++-
 net/core/skbuff.c                             |   1 +
 net/ipv4/ip_gre.c                             |   9 +-
 net/ipv4/tcp_output.c                         |   4 +-
 net/netfilter/ipset/ip_set_core.c             |   6 +
 net/netlink/af_netlink.c                      |  54 ++--
 net/wireless/chan.c                           |   9 +-
 net/wireless/reg.c                            |  12 +-
 sound/usb/quirks-table.h                      | 166 +++----------
 102 files changed, 1045 insertions(+), 680 deletions(-)


