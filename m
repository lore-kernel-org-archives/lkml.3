Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097AbaALNdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 08:33:11 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:54665 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaALNdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 08:33:06 -0500
MIME-Version: 1.0
Date: Sun, 12 Jan 2014 20:33:03 +0700
X-Google-Sender-Auth: WBACLwqi1hCGMFgrXYiVSXu-0c4
Message-ID: <CA+55aFwLXnW-GWKNcUCrpS5e7fd_0ZoKk83H4qMJNUS_WCF_3A@mail.gmail.com>
Subject: Linux 3.13-rc8
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another RC. And things look fine.

rc8 has the usual "two thirds drivers, one third random" mix, with
"random" having some arch updates (arm and parisc this time), but is
mostly network updates. A fair chunk of the driver changes are network
drivers too, for that matter.

But nothing particularly scary. The scariest part of this release is
how slow my network is, and the patch is still being uploaded, but it
should be done any minute now. Or maybe in half an hour. Whatever. But
the git trees have been updated for hours, it's just the tar-balls and
patches (and this release announcement) that were delayed by bad
networking.

Let's hope things keep calm, and that I can make the final 3.13 next
week when I get back home. But for that all to work well, you guys
need to test. Ok?

                    Linus

---
Abhilash Kesavan (4):
      clk: samsung: exynos5250: Fix ACP gate register offset
      clk: samsung: exynos5250: Add MDMA0 clocks
      ARM: dts: exynos5250: Fix MDMA0 clock number
      clk: samsung: exynos5250: Add CLK_IGNORE_UNUSED flag for the sysreg clock

Alan (1):
      sata_sis: missing PM support

Alexander Mezin (1):
      ACPI / AC: change notification handler type to ACPI_ALL_NOTIFY

Alexander van Heukelum (1):
      Revert "drm/i915: assume all GM45 Acer laptops use inverted backlight PWM"

Andrew Bresticker (1):
      clk: exynos5250: fix sysmmu_mfc{l,r} gate clocks

Arron Wang (1):
      NFC: Fix target mode p2p link establishment

Ben Skeggs (1):
      drm/nouveau: populate master subdev pointer only when fully constructed

Ben Widawsky (1):
      drm/i915/bdw: Flush system agent on gen8 also

Bob Gleitsmann (1):
      drm/nouveau: return offset of allocated notifier

Christian Engelmayer (1):
      drm/nouveau/nouveau: fix memory leak in nouveau_crtc_page_flip()

Chuansheng Liu (1):
      xfs: Calling destroy_work_on_stack() to pair with INIT_WORK_ONSTACK()

Curt Brune (1):
      bridge: use spin_lock_bh() in br_multicast_set_hash_max

Dan Williams (1):
      hso: fix handling of modem port SERIAL_STATE notifications

Daniel Borkmann (4):
      net: llc: fix order of evaluation in llc_conn_ac_inc_vr_by_1
      net: llc: fix use after free in llc_ui_recvmsg
      net: 6lowpan: fix lowpan_header_create non-compression memcpy call
      netfilter: nf_nat: fix access to uninitialized buffer in IRC NAT helper

Daniel Vetter (1):
      MAINTAINERS: Updates for drm/i915

Dave Kleikamp (1):
      Revert "sparc64: Fix __copy_{to,from}_user_inatomic defines."

David S. Miller (2):
      vlan: Fix header ops passthru when doing TX VLAN offload.
      netpoll: Fix missing TXQ unlock and and OOPS.

Dirk Brandewie (1):
      intel_pstate: Add X86_FEATURE_APERFMPERF to cpu match parameters.

Dmitry Kravkov (1):
      bnx2x: limit number of interrupt vectors for 57711

Eric Whitney (1):
      ext4: fix bigalloc regression

Erik Hugne (1):
      tipc: correctly unlink packets from deferred packet queue

Fabio Estevam (1):
      fec: Revert "fec: Do not assume that PHY reset is active low"

Felix Fietkau (1):
      mac80211: move "bufferable MMPDU" check to fix AP mode scan

Guenter Roeck (1):
      isdn: Drop big endian cpp checks from telespci and hfc_pci drivers

Hangbin Liu (1):
      infiniband: make sure the src net is infiniband when create new link

Hannes Frederic Sowa (2):
      ipv6: don't install anycast address for /128 addresses on routers
      ipv6: add link-local, sit and loopback address with INFINITY_LIFE_TIME

Hugh Dickins (1):
      thp: fix copy_page_rep GPF by testing is_huge_zero_pmd once only

Ilia Mirkin (2):
      drm/nouveau/bios: make jump conditional
      drm/nouveau/bios: fix offset calculation for BMPv1 bioses

James Hogan (1):
      clk: clk-divider: fix divisor > 255 bug

Jason Wang (3):
      virtio-net: fix refill races during restore
      macvlan: forbid L2 fowarding offload for macvtap
      net: core: explicitly select a txq before doing l2 forwarding

Javier Lopez (1):
      mac80211_hwsim: Fix NULL pointer dereference

Jesper Dangaard Brouer (1):
      netfilter: only warn once on wrong seqadj usage

Jiang Liu (3):
      ACPI / TPM: fix memory leak when walking ACPI namespace
      Revert "intel_idle: mark states tables with __initdata tag"
      intel_idle: close avn_cstates array with correct marker

Jie Liu (1):
      xfs: fix off-by-one error in xfs_attr3_rmt_verify

John David Anglin (1):
      parisc: Ensure full cache coherency for kmap/kunmap

Josh Boyer (1):
      xen-netback: Include header for vmalloc

Kelly Doran (1):
      drm/nvc0/gr: fix mthd data submission

Kirill Tkhai (2):
      sparc64: Fix build regression
      sparc64: smp_callin: Enable irqs after preemption is disabled

Krzysztof Kozlowski (1):
      clk: exynos: File scope reg_save array should depend on PM_SLEEP

Lan Tianyu (1):
      ACPI / Battery: Add a _BIX quirk for NEC LZ750/LS

Laura Abbott (1):
      ARM: 7931/1: Correct virt_addr_valid

Laurent Pinchart (3):
      ARM: shmobile: armadillo: Fix coherent DMA mask
      ARM: shmobile: kzm9g: Fix coherent DMA mask
      ARM: shmobile: mackerel: Fix coherent DMA mask

Li RongQing (4):
      ipv6: fix the use of pcpu_tstats in sit
      ipv6: fix the use of pcpu_tstats in ip6_tunnel
      ipv6: fix the use of pcpu_tstats in ip6_vti.c
      ipv6: pcpu_tstats.syncp should be initialised in ip6_vti.c

Linus Torvalds (1):
      Linux 3.13-rc8

Manish Chopra (3):
      qlcnic: Fix loopback diagnostic test
      qlcnic: Fix resource allocation for TX queues
      qlcnic: Fix bug in TX statistics

Michal Kalderon (2):
      bnx2x: Correct number of MSI-X vectors for VFs
      bnx2x: Clean before update RSS arrives

Michal Schmidt (1):
      bnx2x: fix DMA unmapping of TSO split BDs

Milo Kim (1):
      leds: lp5521/5523: Remove duplicate mutex

Ming Lei (1):
      block: null_blk: fix queue leak inside removing device

Octavian Purdila (1):
      usbnet: mcs7830: rework link state detection

Oren Givon (1):
      iwlwifi: add new devices for 7265 series

Rob Herring (1):
      ARM: 7933/1: rename ioremap_cached to ioremap_cache

Russell King (3):
      ARM: fix footbridge clockevent device
      CRYPTO: Fix more AES build errors
      ARM: fix "bad mode in ... handler" message for undefined instructions

Seung-Woo Kim (1):
      clk: samsung: exynos4: Correct SRC_MFC register

Shahed Shaikh (2):
      qlcnic: Fix bug in Tx completion path
      qlcnic: Fix ethtool statistics length calculation

Sid Boyce (1):
      drm/nvce/mc: fix msi rearm on GF114

Simon Guinot (1):
      ahci: add PCI ID for Marvell 88SE9170 SATA controller

Steven Capper (1):
      ARM: 7923/1: mm: fix dcache flush logic for compound high pages

Steven Rostedt (1):
      SELinux: Fix possible NULL pointer dereference in
selinux_inode_permission()

Suresh Reddy (2):
      be2net: increase the timeout value for loopback-test FW cmd
      be2net: fix max_evt_qs calculation for BE3 in SR-IOV config

Thadeu Lima de Souza Cascardo (1):
      cxgb4: allow large buffer size to have page size

Thomas Gleixner (1):
      mfd: rtsx_pcr: Disable interrupts before cancelling delayed works

Vasundhara Volam (1):
      be2net: disable RSS when number of RXQs is reduced to 1 via set-channels

Vlad Yasevich (1):
      sctp: Remove outqueue empty state

Wei-Chun Chao (1):
      ipv4: fix tunneled VM traffic over hw VXLAN/GRE GSO NIC

Yaniv Rosner (5):
      bnx2x: Fix 578xx-KR 1G link
      bnx2x: Fix passive DAC cable detection
      bnx2x: Fix Duplex setting for 54618se
      bnx2x: Fix incorrect link-up report
      bnx2x: Fix KR2 work-around detection of BCM8073

Yasushi Asano (1):
      ipv6 addrconf: fix preferred lifetime state-changing behavior
while valid_lft is infinity

Yijing Wang (1):
      sparc/PCI: Use dev_is_pci() to identify PCI devices

Yuval Mintz (3):
      bnx2x: fix AFEX memory overflow
      bnx2x: fix VLAN configuration for VFs.
      bnx2x: prevent WARN during driver unload

fan.du (1):
      {vxlan, inet6} Mark vxlan_dev flags with VXLAN_F_IPV6 properly
