Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaANA07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:26:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaANA0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:26:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/62] 3.10.27-stable review
Date: Mon, 13 Jan 2014 16:26:25 -0800
Message-Id: <20140114002710.464561569@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.27 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jan 16 00:26:56 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.27-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.27-rc1

Paul Turner <pjt@google.com>
    sched: Guarantee new group-entities always have weight

Ben Segall <bsegall@google.com>
    sched: Fix hrtimer_cancel()/rq->lock deadlock

Ben Segall <bsegall@google.com>
    sched: Fix cfs_bandwidth misuse of hrtimer_expires_remaining

Ben Segall <bsegall@google.com>
    sched: Fix race on toggling cfs_bandwidth_used

Linus Torvalds <torvalds@linux-foundation.org>
    x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround

Daniel Borkmann <dborkman@redhat.com>
    netfilter: nf_nat: fix access to uninitialized buffer in IRC NAT helper

Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
    SCSI: sd: Reduce buffer size for vpd request

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: Add X86_FEATURE_APERFMPERF to cpu match parameters.

Felix Fietkau <nbd@openwrt.org>
    mac80211: move "bufferable MMPDU" check to fix AP mode scan

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / Battery: Add a _BIX quirk for NEC LZ750/LS

Jiang Liu <jiang.liu@linux.intel.com>
    ACPI / TPM: fix memory leak when walking ACPI namespace

Thomas Gleixner <tglx@linutronix.de>
    mfd: rtsx_pcr: Disable interrupts before cancelling delayed works

Andrew Bresticker <abrestic@chromium.org>
    clk: exynos5250: fix sysmmu_mfc{l,r} gate clocks

Abhilash Kesavan <a.kesavan@samsung.com>
    clk: samsung: exynos5250: Add CLK_IGNORE_UNUSED flag for the sysreg clock

Seung-Woo Kim <sw0312.kim@samsung.com>
    clk: samsung: exynos4: Correct SRC_MFC register

James Hogan <james.hogan@imgtec.com>
    clk: clk-divider: fix divisor > 255 bug

Simon Guinot <sguinot@lacie.com>
    ahci: add PCI ID for Marvell 88SE9170 SATA controller

John David Anglin <dave.anglin@bell.net>
    parisc: Ensure full cache coherency for kmap/kunmap

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/bios: make jump conditional

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    ARM: shmobile: mackerel: Fix coherent DMA mask

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    ARM: shmobile: armadillo: Fix coherent DMA mask

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    ARM: shmobile: kzm9g: Fix coherent DMA mask

Abhilash Kesavan <a.kesavan@samsung.com>
    ARM: dts: exynos5250: Fix MDMA0 clock number

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: fix "bad mode in ... handler" message for undefined instructions

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: fix footbridge clockevent device

Simon Horman <horms@verge.net.au>
    net: Loosen constraints for recalculating checksum in skb_segment()

Curt Brune <curt@cumulusnetworks.com>
    bridge: use spin_lock_bh() in br_multicast_set_hash_max

David S. Miller <davem@davemloft.net>
    netpoll: Fix missing TXQ unlock and and OOPS.

Daniel Borkmann <dborkman@redhat.com>
    net: llc: fix use after free in llc_ui_recvmsg

Jason Wang <jasowang@redhat.com>
    virtio-net: fix refill races during restore

Michael S. Tsirkin <mst@redhat.com>
    virtio_net: don't leak memory or block when too many frags

Michael S. Tsirkin <mst@redhat.com>
    virtio-net: make all RX paths handle errors consistently

Michael S. Tsirkin <mst@redhat.com>
    virtio_net: fix error handling for mergeable buffers

David S. Miller <davem@davemloft.net>
    vlan: Fix header ops passthru when doing TX VLAN offload.

Florian Westphal <fw@strlen.de>
    net: rose: restore old recvmsg behavior

Sasha Levin <sasha.levin@oracle.com>
    rds: prevent dereference of a NULL device

Li RongQing <roy.qing.li@gmail.com>
    ipv6: always set the new created dst's from in ip6_rt_copy

Eric Dumazet <edumazet@google.com>
    net: fec: fix potential use after free

Salva Peiró <speiro@ai2.upv.es>
    hamradio/yam: fix info leak in ioctl

Wenliang Fan <fanwlexca@gmail.com>
    drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()

Daniel Borkmann <dborkman@redhat.com>
    net: inet_diag: zero out uninitialized idiag_{src,dst} fields

Timo Teräs <timo.teras@iki.fi>
    ip_gre: fix msg_name parsing for recvfrom/recvmsg

Sasha Levin <sasha.levin@oracle.com>
    net: unix: allow bind to fail on mutex lock

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: fix illegal mac_header comparison on 32bit

Jason Wang <jasowang@redhat.com>
    netvsc: don't flush peers notifying work during setting mtu

Nat Gurumoorthy <natg@google.com>
    tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0

Sasha Levin <sasha.levin@oracle.com>
    net: unix: allow set_peek_off to fail

Changli Gao <xiaosuo@gmail.com>
    net: drop_monitor: fix the value of maxattr

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: don't count addrconf generated routes against gc limit

Daniel Borkmann <dborkman@redhat.com>
    packet: fix send path when running with proto == 0

Andrey Vagin <avagin@openvz.org>
    virtio: delete napi structures from netdev before releasing memory

Jason Wang <jasowang@redhat.com>
    macvtap: signal truncated packets

Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    tun: update file current position

Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    macvtap: update file current position

Vlad Yasevich <vyasevic@redhat.com>
    macvtap: Do not double-count received packets

Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
    rds: prevent BUG_ON triggered on congestion update to loopback

Eric Dumazet <edumazet@google.com>
    net: do not pretend FRAGLIST support

Kamala R <kamala@aristanetworks.com>
    IPv6: Fixed support for blackhole and prohibit routes

Nestor Lopez Casado <nlopezcasad@logitech.com>
    HID: Revert "Revert "HID: Fix logitech-dj: missing Unifying device issue""

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    gpio-rcar: R-Car GPIO IRQ share interrupt

Magnus Damm <damm@opensource.se>
    clocksource: em_sti: Set cpu_possible_mask to fix SMP broadcast

Axel Lin <axel.lin@ingics.com>
    irqchip: renesas-irqc: Fix irqc_probe error handling


-------------

Diffstat:

 Documentation/networking/packet_mmap.txt          |  10 ++
 Makefile                                          |   4 +-
 arch/arm/boot/dts/exynos5250.dtsi                 |   2 +-
 arch/arm/kernel/traps.c                           |   8 +-
 arch/arm/mach-footbridge/dc21285-timer.c          |   5 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c    |   4 +-
 arch/arm/mach-shmobile/board-kzm9g.c              |   2 +-
 arch/arm/mach-shmobile/board-mackerel.c           |   4 +-
 arch/parisc/include/asm/cacheflush.h              |  12 +--
 arch/parisc/include/asm/page.h                    |   5 +-
 arch/parisc/kernel/cache.c                        |  35 -------
 arch/x86/include/asm/fpu-internal.h               |  13 +--
 drivers/acpi/battery.c                            |  21 +++-
 drivers/ata/ahci.c                                |   3 +
 drivers/char/tpm/tpm_ppi.c                        |  15 +--
 drivers/clk/clk-divider.c                         |   2 +-
 drivers/clk/samsung/clk-exynos4.c                 |   2 +-
 drivers/clk/samsung/clk-exynos5250.c              |   7 +-
 drivers/clocksource/em_sti.c                      |   2 +-
 drivers/cpufreq/intel_pstate.c                    |   3 +-
 drivers/gpio/gpio-rcar.c                          |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c   |   6 +-
 drivers/hid/hid-logitech-dj.c                     |  45 ++++++++
 drivers/hid/hid-logitech-dj.h                     |   1 +
 drivers/irqchip/irq-renesas-irqc.c                |   4 +-
 drivers/mfd/rtsx_pcr.c                            |  10 +-
 drivers/net/ethernet/broadcom/tg3.c               |   3 +
 drivers/net/ethernet/freescale/fec_main.c         |   4 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c         |   2 +-
 drivers/net/ethernet/tehuti/tehuti.c              |   1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c       |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |   2 +-
 drivers/net/hamradio/hdlcdrv.c                    |   2 +
 drivers/net/hamradio/yam.c                        |   1 +
 drivers/net/hyperv/netvsc_drv.c                   |   1 -
 drivers/net/macvtap.c                             |  20 ++--
 drivers/net/tun.c                                 |   2 +
 drivers/net/virtio_net.c                          | 119 +++++++++++++++-------
 drivers/scsi/sd.c                                 |   5 +-
 include/linux/net.h                               |   2 +-
 include/linux/netdevice.h                         |   9 ++
 include/linux/skbuff.h                            |   5 +
 kernel/sched/core.c                               |   9 +-
 kernel/sched/fair.c                               |  48 ++++++---
 kernel/sched/sched.h                              |   3 +-
 net/8021q/vlan_dev.c                              |  19 +++-
 net/bridge/br_multicast.c                         |   4 +-
 net/core/drop_monitor.c                           |   1 -
 net/core/neighbour.c                              |   2 +-
 net/core/netpoll.c                                |  11 +-
 net/core/skbuff.c                                 |   3 +-
 net/core/sock.c                                   |   2 +-
 net/ipv4/inet_diag.c                              |  16 +++
 net/ipv4/ip_gre.c                                 |   1 +
 net/ipv6/route.c                                  |  34 +++----
 net/ipv6/udp_offload.c                            |   2 +-
 net/llc/af_llc.c                                  |   5 +-
 net/mac80211/tx.c                                 |  23 +++--
 net/netfilter/nf_nat_irc.c                        |  32 +++++-
 net/packet/af_packet.c                            |  65 +++++++-----
 net/rds/ib.c                                      |   3 +-
 net/rds/ib_send.c                                 |   5 +-
 net/rose/af_rose.c                                |  16 +--
 net/unix/af_unix.c                                |  16 ++-
 64 files changed, 479 insertions(+), 248 deletions(-)


