Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbbAYSJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:09:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbbAYSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:08:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/50] 3.10.66-stable review
Date: Sun, 25 Jan 2015 10:06:50 -0800
Message-Id: <20150125180702.521559311@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.66 release.
There are 50 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Jan 27 18:06:25 UTC 2015.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.66-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.66-rc1

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/3215: fix tty output containing tabs

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/3215: fix hanging console issue

Jerry Hoemann <jerry.hoemann@hp.com>
    fsnotify: next_i is freed during fsnotify_unmount_inodes.

Dan Carpenter <dan.carpenter@oracle.com>
    netfilter: ipset: small potential read beyond the end of buffer

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mmc: sdhci: Fix sleep in atomic after inserting SD card

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

Hans Holmberg <hans.holmberg@intel.com>
    gpiolib: of: Correct error handling in of_get_named_gpiod_flags

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4.1: Fix client id trunking on Linux

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace/jprobes/x86: Fix conflict between jprobes and function graph tracing

Wei Yang <weiyang@linux.vnet.ibm.com>
    vfio-pci: Fix the check on pci device type in vfio_pci_probe()

Takashi Iwai <tiwai@suse.de>
    uvcvideo: Fix destruction order in uvc_delete()

Sakari Ailus <sakari.ailus@linux.intel.com>
    smiapp: Take mutex during PLL update in sensor initialisation

Frank Schaefer <fschaefer.oss@googlemail.com>
    af9005: fix kernel panic on init if compiled without IR

Sakari Ailus <sakari.ailus@linux.intel.com>
    smiapp-pll: Correct clock debug prints

Tomi Valkeinen <tomi.valkeinen@ti.com>
    video/logo: prevent use of logos after they have been freed

Long Li <longli@microsoft.com>
    storvsc: ring buffer failures may result in I/O freeze

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fail connection on short sendmsg writes

Dominique Leuenberger <dimstar@opensuse.org>
    hp_accel: Add support for HP ZBook 15

Jouni Malinen <jouni@qca.qualcomm.com>
    cfg80211: Fix 160 MHz channels with 80+80 and 160 MHz drivers

Vineet Gupta <vgupta@synopsys.com>
    ARC: [nsimosci] move peripherals to match model to FPGA

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Force the CS stall for invalidate flushes

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Invalidate media caches on gen7

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: check the right ring in radeon_evict_flags()

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix fence event code

Govindarajulu Varadarajan <_govind@gmx.com>
    enic: fix rx skb checksum

Eric Dumazet <edumazet@google.com>
    alx: fix alx_poll()

Herbert Xu <herbert@gondor.apana.org.au>
    tcp: Do not apply TSO segment limit to non-TSO packets

Prashant Sreedharan <prashant@broadcom.com>
    tg3: tg3_disable_ints using uninitialized mailbox value to disable interrupts

Thomas Graf <tgraf@suug.ch>
    netlink: Don't reorder loads/stores before marking mmap netlink frame as available

David Miller <davem@davemloft.net>
    netlink: Always copy on mmap TX.


-------------

Diffstat:

 Documentation/kernel-parameters.txt         |  1 +
 Makefile                                    |  4 +--
 arch/arc/boot/dts/nsimosci.dts              | 18 +++++-----
 arch/arm/boot/dts/imx25.dtsi                |  2 +-
 arch/arm/mach-imx/clk-imx6q.c               |  4 +--
 arch/arm/mach-omap2/timer.c                 |  8 ++---
 arch/arm/mach-shmobile/setup-sh73a0.c       |  3 ++
 arch/um/Kconfig.common                      |  1 +
 arch/x86/kernel/kprobes/core.c              | 20 ++++++++---
 arch/x86/um/sys_call_table_32.c             |  2 +-
 arch/x86/um/sys_call_table_64.c             |  2 +-
 drivers/gpio/gpiolib-of.c                   | 10 ++++--
 drivers/gpu/drm/i915/i915_reg.h             |  1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c     |  3 ++
 drivers/gpu/drm/radeon/atombios_dp.c        |  4 +++
 drivers/gpu/drm/radeon/radeon_ttm.c         |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c       | 17 ++++-----
 drivers/input/serio/i8042-x86ia64io.h       | 39 +++++++++++++++++++++
 drivers/input/serio/i8042.c                 | 14 ++++++++
 drivers/media/i2c/smiapp-pll.c              |  4 +--
 drivers/media/i2c/smiapp/smiapp-core.c      |  2 ++
 drivers/media/usb/dvb-usb/af9005.c          |  3 ++
 drivers/media/usb/uvc/uvc_driver.c          |  6 ++--
 drivers/mmc/host/sdhci.c                    |  3 +-
 drivers/net/can/usb/kvaser_usb.c            | 20 ++++++-----
 drivers/net/ethernet/atheros/alx/main.c     | 24 +++++++------
 drivers/net/ethernet/broadcom/tg3.c         | 34 +++++++++---------
 drivers/net/ethernet/cisco/enic/enic_main.c | 12 ++++---
 drivers/platform/x86/hp_accel.c             |  1 +
 drivers/s390/char/con3215.c                 | 52 +++++++++++++++++----------
 drivers/scsi/storvsc_drv.c                  |  7 ++--
 drivers/target/iscsi/iscsi_target_util.c    | 26 ++++++--------
 drivers/usb/dwc3/gadget.c                   |  6 ++--
 drivers/usb/host/pci-quirks.c               | 18 ++++++++--
 drivers/usb/serial/cp210x.c                 |  4 ++-
 drivers/usb/serial/keyspan.c                | 20 ++++++++---
 drivers/vfio/pci/vfio_pci.c                 |  4 +--
 drivers/video/logo/logo.c                   | 17 ++++++++-
 fs/lockd/svc.c                              |  8 ++---
 fs/nfs/nfs4client.c                         | 17 +++++----
 fs/notify/inode_mark.c                      | 17 +++++----
 lib/decompress_bunzip2.c                    |  2 +-
 net/ipv4/tcp_output.c                       |  4 +--
 net/netfilter/ipset/ip_set_core.c           |  6 ++++
 net/netlink/af_netlink.c                    | 54 +++++++++--------------------
 net/wireless/chan.c                         |  9 +++--
 46 files changed, 335 insertions(+), 200 deletions(-)


