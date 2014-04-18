Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaDRJV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:21:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45870 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949AbaDRJVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:21:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 00/72] 3.12.18-stable review
Date: Fri, 18 Apr 2014 11:21:47 +0200
Message-Id: <cover.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.18 release.
There are 72 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Apr 23 09:14:42 2014
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.18-rc1.xz
and the diffstat can be found below.

thanks,
js

===============


Adam Jackson (1):
  fbdev: Make the switch from generic to native driver less alarming

Alex Deucher (2):
  drm/radeon: change audio enable logic
  drm/radeon: enable speaker allocation setup on dce3.2

Anton Nayshtut (1):
  ipv6: Fix exthdrs offload registration.

Ard Biesheuvel (1):
  crypto: ghash-clmulni-intel - use C implementation for setkey()

Chris Wilson (2):
  drm/i915: Undo the PIPEA quirk for i845
  video/fb: Propagate error code from failing to unregister conflicting
    fb

Dan Carpenter (1):
  isdnloop: several buffer overflows

Daniel Borkmann (1):
  net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk

David Stevens (2):
  vxlan: fix potential NULL dereference in arp_reduce()
  vxlan: fix nonfunctional neigh_reduce()

Eric Dumazet (4):
  net: unix: non blocking recvmsg() should not return -EINTR
  pkt_sched: fq: do not hold qdisc lock while allocating memory
  tcp: tcp_release_cb() should release socket ownership
  tcp: syncookies: do not use getnstimeofday()

Erik Hugne (4):
  tipc: drop subscriber connection id invalidation
  tipc: fix memory leak during module removal
  tipc: don't log disabled tasklet handler errors
  tipc: fix spinlock recursion bug for failed subscriptions

Finn Thain (1):
  m68k: Skip futex_atomic_cmpxchg_inatomic() test

Florian Westphal (1):
  inet: frag: make sure forced eviction removes all frags

Gerd Hoffmann (2):
  drm: add drm_set_preferred_mode
  drm/cirrus: use drm_set_preferred_mode

Gu Zheng (1):
  fb: reorder the lock sequence to fix potential dead lock

Hannes Frederic Sowa (1):
  ipv6: some ipv6 statistic counters failed to disable bh

Heiko Carstens (1):
  futex: Allow architectures to skip futex_atomic_cmpxchg_inatomic()
    test

Heiner Kallweit (1):
  ipv6: Avoid unnecessary temporary addresses being generated

Jan Kara (1):
  ext4: Speedup WB_SYNC_ALL pass called from sync(2)

Jiri Kosina (1):
  floppy: bail out in open() if drive is not responding to block0 read

Jiri Slaby (1):
  Char: ipmi_bt_sm, fix infinite loop

Li RongQing (1):
  netpoll: fix the skb check in pkt_is_ns

Linus Lüssing (3):
  bridge: multicast: add sanity check for query source addresses
  bridge: multicast: add sanity check for general query destination
  bridge: multicast: enable snooping on general queries only

Malahal Naineni (1):
  nfs: initialize the ACL support bits to zero.

Martin Koegler (1):
  drm/cirrus: Fix cirrus drm driver for fbdev + qemu

Matthew Leach (1):
  net: socket: error on a negative msg_namelen

Michael Chan (1):
  bnx2: Fix shutdown sequence

Michael S. Tsirkin (2):
  vhost: fix total length when packets are too short
  vhost: validate vhost_get_vq_desc return value

Mike Rapoport (1):
  net: vxlan: fix crash when interface is created with no group

Mikulas Patocka (3):
  powernow-k6: disable cache when changing frequency
  powernow-k6: correctly initialize default parameters
  powernow-k6: reorder frequencies

Mischa Jonker (1):
  ARC: [nsimosci] Change .dts to use generic 8250 UART

Nicolas Dichtel (3):
  rtnetlink: fix fdb notification flags
  ipmr: fix mfc notification flags
  ip6mr: fix mfc notification flags

Nikolay Aleksandrov (1):
  net: fix for a race condition in the inet frag code

Nishanth Menon (1):
  net: micrel : ks8851-ml: add vdd-supply support

Oliver Neukum (1):
  usbnet: include wait queue head in device structure

Pablo Neira (1):
  netlink: don't compare the nul-termination in nla_strcmp

Paul Durrant (1):
  xen-netback: remove pointless clause from if statement

Paul Moore (1):
  selinux: correctly label /proc inodes in use before the policy is
    loaded

Peter Boström (1):
  vlan: Set correct source MAC address with TX VLAN offload enabled

Pravin B Shelar (1):
  ip_tunnel: Fix dst ref-count.

Sabrina Dubroca (1):
  ipv6: don't set DST_NOCOUNT for remotely added routes

Sasha Levin (1):
  rds: prevent dereference of a NULL device in rds_iw_laddr_check

Sebastian Hesselbarth (1):
  PCI: mvebu: move clock enable before register access

Stefan Wahren (1):
  eth: fec: Fix lost promiscuous mode after reconnecting cable

Takashi Iwai (1):
  drm: Prefer noninterlace cmdline mode unless explicitly specified

Trond Myklebust (2):
  NFSv3: Fix return value of nfs3_proc_setacls
  SUNRPC: Fix potential memory scribble in xprt_free_bc_request()

Vineet Gupta (1):
  ARC: [nsimosci] Unbork console

Vlad Yasevich (2):
  tg3: Do not include vlan acceleration features in vlan_features
  vlan: Set hard_header_len according to available acceleration

Wei Liu (1):
  xen-netback: disable rogue vif in kthread context

YOSHIFUJI Hideaki (1):
  isdnloop: Validate NUL-terminated strings from user.

Ying Xue (2):
  tipc: allow connection shutdown callback to be invoked in advance
  tipc: fix connection refcount leak

dingtianhong (1):
  bonding: set correct vlan id for alb xmit path

lucien (1):
  ipv6: ip6_append_data_mtu do not handle the mtu of the second fragment
    properly

 .../devicetree/bindings/net/micrel-ks8851.txt      |   1 +
 arch/arc/boot/dts/nsimosci.dts                     |  12 +-
 arch/arc/configs/nsimosci_defconfig                |   1 +
 arch/m68k/Kconfig                                  |   1 +
 arch/s390/Kconfig                                  |   1 +
 arch/x86/crypto/ghash-clmulni-intel_asm.S          |  29 ----
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |  14 +-
 drivers/block/floppy.c                             |  36 +++--
 drivers/char/ipmi/ipmi_bt_sm.c                     |   2 +-
 drivers/cpufreq/powernow-k6.c                      | 147 +++++++++++++++++----
 drivers/gpu/drm/cirrus/cirrus_fbdev.c              |   3 +
 drivers/gpu/drm/cirrus/cirrus_mode.c               |  11 +-
 drivers/gpu/drm/drm_edid.c                         |  13 ++
 drivers/gpu/drm/drm_fb_helper.c                    |  11 ++
 drivers/gpu/drm/i915/intel_display.c               |   3 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                 |  13 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |  26 ++--
 drivers/gpu/drm/radeon/r600_audio.c                |  14 +-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |  15 +--
 drivers/gpu/drm/radeon/radeon.h                    |   6 +
 drivers/isdn/isdnloop/isdnloop.c                   |  23 ++--
 drivers/net/bonding/bond_alb.c                     |   2 +-
 drivers/net/ethernet/broadcom/bnx2.c               |  37 +++++-
 drivers/net/ethernet/broadcom/bnx2.h               |   5 +
 drivers/net/ethernet/broadcom/tg3.c                |   5 +-
 drivers/net/ethernet/freescale/fec_main.c          |  14 +-
 drivers/net/ethernet/micrel/ks8851.c               |  30 ++++-
 drivers/net/usb/usbnet.c                           |  33 +++--
 drivers/net/vxlan.c                                | 136 ++++++++++++++++---
 drivers/net/xen-netback/common.h                   |   5 +
 drivers/net/xen-netback/interface.c                |  11 ++
 drivers/net/xen-netback/netback.c                  |  20 ++-
 drivers/pci/host/pci-mvebu.c                       |  25 ++--
 drivers/vhost/net.c                                |  20 ++-
 drivers/video/fbmem.c                              |  84 +++++++-----
 drivers/video/fbsysfs.c                            |  19 ++-
 drivers/video/sh_mobile_lcdcfb.c                   |  10 +-
 fs/ext4/inode.c                                    |  13 +-
 fs/nfs/nfs3acl.c                                   |  15 ++-
 fs/nfs/nfs4xdr.c                                   |   2 +-
 include/drm/drm_crtc.h                             |   2 +
 include/linux/fb.h                                 |   4 +-
 include/linux/futex.h                              |   4 +
 include/linux/usb/usbnet.h                         |   2 +-
 include/net/sock.h                                 |   5 +
 include/net/tcp.h                                  |  11 +-
 include/uapi/linux/fd.h                            |   3 +-
 init/Kconfig                                       |   7 +
 kernel/futex.c                                     |  14 +-
 lib/nlattr.c                                       |  10 +-
 net/8021q/vlan.c                                   |   4 +-
 net/8021q/vlan_dev.c                               |   6 +-
 net/bridge/br_multicast.c                          |  33 ++++-
 net/core/netpoll.c                                 |   2 +-
 net/core/rtnetlink.c                               |  10 +-
 net/core/sock.c                                    |   5 +-
 net/ipv4/gre_demux.c                               |   8 ++
 net/ipv4/inet_fragment.c                           |   5 +-
 net/ipv4/ip_tunnel.c                               |   3 -
 net/ipv4/ip_tunnel_core.c                          |   1 +
 net/ipv4/ipmr.c                                    |  13 +-
 net/ipv4/tcp_output.c                              |  11 ++
 net/ipv6/addrconf.c                                |   5 +-
 net/ipv6/exthdrs_offload.c                         |   4 +-
 net/ipv6/icmp.c                                    |   2 +-
 net/ipv6/ip6_output.c                              |  18 ++-
 net/ipv6/ip6mr.c                                   |  13 +-
 net/ipv6/mcast.c                                   |  11 +-
 net/ipv6/ping.c                                    |   4 +-
 net/ipv6/route.c                                   |   2 +-
 net/rds/iw.c                                       |   3 +-
 net/sched/sch_fq.c                                 |  28 ++--
 net/sctp/sm_make_chunk.c                           |   4 +-
 net/sctp/sm_statefuns.c                            |   5 -
 net/socket.c                                       |   4 +
 net/sunrpc/backchannel_rqst.c                      |   6 +-
 net/tipc/config.c                                  |   9 +-
 net/tipc/handler.c                                 |   1 -
 net/tipc/name_table.c                              |  37 +++++-
 net/tipc/server.c                                  |  14 +-
 net/tipc/subscr.c                                  |  48 +++----
 net/unix/af_unix.c                                 |  17 ++-
 security/selinux/hooks.c                           |  36 +++--
 83 files changed, 930 insertions(+), 372 deletions(-)

-- 
1.9.2

