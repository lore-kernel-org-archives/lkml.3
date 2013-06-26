Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3FZCqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:46:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54108 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946Ab3FZCp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.425780530@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [00/26] 3.2.48-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.48 release.
There are 26 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jun 28 12:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.47 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Anders Hammarquist (1):
      USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable
         [35a2fbc941accd0e9f1bfadd669311786118d874]

Andy Lutomirski (1):
      net: Block MSG_CMSG_COMPAT in send(m)msg and  recv(m)msg
         [1be374a0518a288147c6a7398792583200a67261,
          a7526eb5d06b0084ef12d7b168d008fcf516caab]

Ben Hutchings (2):
      Revert "drm/i915: GFX_MODE Flush TLB Invalidate Mode must be  '1' for scanline waits"
         [not upstream; reverts a change that regressed 3.2 only]
      x86/efi: Fix dummy variable buffer allocation
         [b8cb62f82103083a6e8fa5470bfe634a2c06514d]

Chris Metcalf (1):
      tilepro: work around module link error with gcc 4.7
         [3cb3f839d306443f3d1e79b0bde1a2ad2c12b555]

Clemens Ladisch (1):
      ALSA: usb-audio: work around Android accessory firmware bug
         [342cda29343a6272c630f94ed56810a76740251b]

Daniel Borkmann (2):
      net: sctp: fix NULL pointer dereference in socket  destruction
         [1abd165ed757db1afdefaac0a4bc8a70f97d258c]
      packet: packet_getname_spkt: make sure string is  always 0-terminated
         [2dc85bf323515e59e15dfa858d1472bb25cad0fe]

Dave Chiluk (1):
      ncpfs: fix rmdir returns Device or resource busy
         [698b8223631472bf982ed570b0812faa61955683]

Eric Dumazet (5):
      ip_tunnel: fix kernel panic with icmp_dest_unreach
         [a622260254ee481747cceaaa8609985b29a31565]
      ipv6: fix possible crashes in ip6_cork_release()
         [284041ef21fdf2e0d216ab6b787bc9072b4eb58a]
      net: force a reload of first item in  hlist_nulls_for_each_entry_rcu
         [c87a124a5d5e8cf8e21c4363c3372bcaf53ea190]
      tcp: fix tcp_md5_hash_skb_data()
         [54d27fcb338bd9c42d1dfc5a39e18f6f9d373c2e]
      tcp: xps: fix reordering issues
         [547669d483e5783d722772af1483fa474da7caf9]

Gao feng (1):
      ipv6: assign rt6_info to inet6_ifaddr in init_loopback
         [534c877928a16ae5f9776436a497109639bf67dc]

Guillaume Nault (2):
      l2tp: Fix PPP header erasure and memory leak
         [55b92b7a11690bc377b5d373872a6b650ae88e64]
      l2tp: Fix sendmsg() return value
         [a6f79d0f26704214b5b702bbac525cb72997f984]

Matthew Garrett (1):
      Modify UEFI anti-bricking code
         [f8b8404337de4e2466e2e1139ea68b1f8295974f]

Paul Moore (1):
      netlabel: improve domain mapping validation
         [6b21e1b77d1a3d58ebfd513264c885695e8a0ba5]

Randy Dunlap (1):
      x86: fix build error and kconfig for ia32_emulation and binfmt
         [d1603990ea626668c78527376d9ec084d634202d]

Simon Baatz (1):
      ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_page
         [1bc39742aab09248169ef9d3727c9def3528b3f3]

Stefan Bader, françois romieu (1):
      r8169: fix 8168evl frame padding.
         [e5195c1f31f399289347e043d6abf3ffa80f0005,
          b423e9ae49d78ea3f53b131c8d5a6087aed16fd6]

Takashi Iwai (1):
      ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam c310
         [36691e1be6ec551eef4a5225f126a281f8c051c2]

Vivek Goyal (1):
      virtio-blk: Call revalidate_disk() upon online disk resize
         [e9986f303dc0f285401de28cf96f42f4dd23a4a1]

Wei Yongjun (1):
      gianfar: add missing iounmap() on error in  gianfar_ptp_probe()
         [e5f5e380e0f3bb11f04ca5bc66a551e58e0ad26e]

Zhanghaoyu (1):
      KVM: x86: remove vcpu's CPL check in host-invoked XCR set
         [764bcbc5a6d7a2f3e75c9f0e4caa984e2926e346]

 Makefile                                     |    4 +-
 arch/arm/include/asm/cacheflush.h            |    4 +-
 arch/arm/mm/flush.c                          |   33 +++++++++++
 arch/tile/lib/exports.c                      |    2 +
 arch/x86/Kconfig                             |    1 +
 arch/x86/kvm/x86.c                           |    5 +-
 arch/x86/platform/efi/efi.c                  |   80 +++++++++++++++++++++++---
 drivers/block/virtio_blk.c                   |    1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c      |    5 --
 drivers/net/ethernet/freescale/gianfar_ptp.c |    1 +
 drivers/net/ethernet/realtek/r8169.c         |   33 +++++++++--
 drivers/usb/serial/ti_usb_3410_5052.c        |    3 +-
 drivers/usb/serial/ti_usb_3410_5052.h        |    4 +-
 fs/ncpfs/dir.c                               |    9 ---
 include/linux/rculist_nulls.h                |    7 ++-
 include/linux/socket.h                       |    3 +
 net/compat.c                                 |   13 ++++-
 net/ipv4/ip_gre.c                            |    2 +-
 net/ipv4/ipip.c                              |    2 +-
 net/ipv4/tcp.c                               |    7 ++-
 net/ipv4/tcp_output.c                        |   10 ++--
 net/ipv6/addrconf.c                          |    4 +-
 net/ipv6/ip6_output.c                        |    2 +-
 net/l2tp/l2tp_ppp.c                          |    6 +-
 net/netlabel/netlabel_domainhash.c           |   69 ++++++++++++++++++++++
 net/packet/af_packet.c                       |    5 +-
 net/sctp/socket.c                            |    6 ++
 net/socket.c                                 |   67 ++++++++++++++-------
 sound/usb/card.c                             |   22 ++++++-
 sound/usb/mixer.c                            |    1 +
 30 files changed, 329 insertions(+), 82 deletions(-)

-- 
Ben Hutchings
Knowledge is power.  France is bacon.

