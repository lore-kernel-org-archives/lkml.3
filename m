Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3F2Uz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 16:55:59 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:33599 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3F2Uz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 16:55:57 -0400
MIME-Version: 1.0
In-Reply-To: <CA+QCeVRutsCRBW14UqP7Ms5gEhfM91nqJugyWPq5nmwimoDBKA@mail.gmail.com>
References: <20130214191226.GA23218@kroah.com> <CA+QCeVRutsCRBW14UqP7Ms5gEhfM91nqJugyWPq5nmwimoDBKA@mail.gmail.com>
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Sat, 29 Jun 2013 23:55:35 +0300
Message-ID: <CA+QCeVT44JKmEezFkB4zvobWR+T9_NO5m=0q5zNGGjqdAnf3og@mail.gmail.com>
Subject: Re: Linux 3.7.8
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        lwn <lwn@lwn.net>, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 June 2013 23:50, Sergey Meirovich <rathamahata@gmail.com> wrote:
> Hi,
>
> On 14 February 2013 21:12, Greg KH <gregkh@linuxfoundation.org> wrote:
>> I'm announcing the release of the 3.7.8 kernel.
 Please ignore - this is about  3.9.8 kernel
>
> I've got issues with my radeon GPU on 3.7.8
> ...
> [   20.944106] BUG: unable to handle kernel NULL pointer dereference
> at 00000000000001f8
> [   20.945753] IP: [<ffffffff812a11a3>] radeon_vm_bo_add+0xb3/0x110
> [   20.946498] PGD 243c0a067 PUD 243cbb067 PMD 0
> [   20.947236] Oops: 0000 [#1] PREEMPT SMP
> [   20.947964] Modules linked in:
> [   20.948675] CPU 3
> [   20.948682] Pid: 2759, comm: X Not tainted 3.9.8 #1 SAMSUNG
> ELECTRONICS CO., LTD.
> 355V4C/355V4X/355V5C/355V5X/356V4C/356V4X/356V5C/356V5X/3445VC/3445VX/3545VC/3545VX/NP355V5C-S0NRU
> [   20.950160] RIP: 0010:[<ffffffff812a11a3>]  [<ffffffff812a11a3>]
> radeon_vm_bo_add+0xb3/0x110
> [   20.950961] RSP: 0018:ffff880244dd3c08  EFLAGS: 00010246
> [   20.951745] RAX: ffff88024578a210 RBX: ffff880243f7c2a0 RCX: 0000000000000000
> [   20.952534] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88024578a240
> [   20.953331] RBP: ffff88024578a200 R08: 0000000000014400 R09: ffff880243f7c2a0
> [   20.954131] R10: 0000000000000005 R11: ffffffffffffffff R12: 00000000000001f0
> [   20.954941] R13: ffff880243f7c2d0 R14: ffff88024578a240 R15: ffff880245fa9000
> [   20.955757] FS:  00007f5c2424e880(0000) GS:ffff88024ed80000(0000)
> knlGS:0000000000000000
> [   20.956590] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   20.957424] CR2: 00000000000001f8 CR3: 00000002451c3000 CR4: 00000000000407e0
> [   20.958273] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   20.959124] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   20.959969] Process X (pid: 2759, threadinfo ffff880244dd2000, task
> ffff880245e277f0)
> [   20.960828] Stack:
> [   20.961679]  ffff880245fba000 ffff88024578a200 ffff880244ea8800
> ffff880244ea8800
> [   20.962572]  ffff880244ea8820 ffffffff81289dab ffff880245fa9020
> ffff880245fa9020
> [   20.963463]  ffff8802450f25c8 ffff880243cbd400 ffffffff812650c1
> 0000000000000000
> [   20.964362] Call Trace:
> [   20.965250]  [<ffffffff81289dab>] ? radeon_driver_open_kms+0x6b/0xd0
> [   20.966165]  [<ffffffff812650c1>] ? drm_open+0x281/0x6d0
> [   20.967075]  [<ffffffff810d92e8>] ? exact_lock+0x8/0x20
> [   20.967980]  [<ffffffff81265e63>] ? drm_stub_open+0x103/0x1a0
> [   20.968886]  [<ffffffff810d9716>] ? chrdev_open+0x96/0x1c0
> [   20.969787]  [<ffffffff810d9680>] ? cdev_put+0x20/0x20
> [   20.970682]  [<ffffffff810d3a42>] ? do_dentry_open.isra.18+0x192/0x280
> [   20.971588]  [<ffffffff810d3b45>] ? finish_open+0x15/0x20
> [   20.972489]  [<ffffffff810e220b>] ? do_last.isra.59+0x29b/0xc90
> [   20.973393]  [<ffffffff810b0000>] ? __do_fault+0x1e0/0x500
> [   20.974294]  [<ffffffff810e2cb5>] ? path_openat.isra.60+0xb5/0x4b0
> [   20.975199]  [<ffffffff810b2d3b>] ? handle_pte_fault+0x9b/0x7a0
> [   20.976105]  [<ffffffff810e3e60>] ? do_filp_open+0x40/0x90
> [   20.977010]  [<ffffffff810eff97>] ? __alloc_fd+0x97/0x120
> [   20.977904]  [<ffffffff810d4bb3>] ? do_sys_open+0xf3/0x1d0
> [   20.978797]  [<ffffffff81653f52>] ? system_call_fastpath+0x16/0x1b
> [   20.979690] Code: 89 5b 08 4c 89 6b 30 4c 89 6b 38 e8 68 f8 3a 00
> 48 8b 45 10 4c 89 f7 4c 89 68 08 48 89 43 30 48 8d 45 10 48 89 43 38
> 4c 89 6d 10 <49> 8b 44 24 08 49 89 5c 24 08 4c 89 23 48 89 43 08 48 89
> 18 e8
> [   20.981714] RIP  [<ffffffff812a11a3>] radeon_vm_bo_add+0xb3/0x110
> [   20.982673]  RSP <ffff880244dd3c08>
> [   20.983616] CR2: 00000000000001f8
> [   20.984613] ---[ end trace 4c43aa9ba50a68eb ]---
>
>
>
>>
>> All users of the 3.7 kernel series must upgrade.
>>
>> The updated 3.7.y git tree can be found at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.7.y
>> and can be browsed at the normal kernel.org git web browser:
>>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------
>>
>>  MAINTAINERS                                          |    6
>>  Makefile                                             |    2
>>  drivers/atm/iphase.h                                 |  146 +++++++++----------
>>  drivers/char/virtio_console.c                        |    3
>>  drivers/gpu/drm/nouveau/core/core/subdev.c           |    2
>>  drivers/gpu/drm/nouveau/core/include/core/object.h   |    7
>>  drivers/gpu/drm/nouveau/nouveau_drm.c                |    3
>>  drivers/infiniband/hw/qib/qib_qp.c                   |   11 -
>>  drivers/isdn/gigaset/capi.c                          |    2
>>  drivers/md/dm-thin.c                                 |   13 -
>>  drivers/media/usb/pwc/pwc-if.c                       |    6
>>  drivers/mfd/db8500-prcmu.c                           |    6
>>  drivers/net/can/c_can/c_can.c                        |    6
>>  drivers/net/ethernet/calxeda/xgmac.c                 |    4
>>  drivers/net/ethernet/intel/e1000e/defines.h          |    9 +
>>  drivers/net/ethernet/intel/e1000e/e1000.h            |    2
>>  drivers/net/ethernet/intel/e1000e/ethtool.c          |    2
>>  drivers/net/ethernet/intel/e1000e/hw.h               |    1
>>  drivers/net/ethernet/intel/e1000e/ich8lan.c          |   11 +
>>  drivers/net/ethernet/intel/e1000e/netdev.c           |   46 +++++
>>  drivers/net/ethernet/mellanox/mlx4/en_tx.c           |   13 +
>>  drivers/net/ethernet/mellanox/mlx4/main.c            |   11 -
>>  drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c |    2
>>  drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    2
>>  drivers/net/ethernet/realtek/r8169.c                 |    7
>>  drivers/net/ethernet/via/via-rhine.c                 |    8 -
>>  drivers/net/loopback.c                               |    5
>>  drivers/net/macvlan.c                                |    5
>>  drivers/net/wireless/ath/ath9k/ar9003_calib.c        |    2
>>  drivers/net/wireless/ath/ath9k/ar9003_phy.c          |    2
>>  drivers/net/wireless/ath/ath9k/hw.h                  |    1
>>  drivers/net/wireless/iwlwifi/dvm/tx.c                |   24 ---
>>  drivers/net/wireless/mwifiex/scan.c                  |    9 -
>>  drivers/net/wireless/rtlwifi/base.c                  |    7
>>  drivers/net/wireless/rtlwifi/usb.c                   |    4
>>  drivers/net/xen-netback/common.h                     |    3
>>  drivers/net/xen-netback/interface.c                  |   23 +-
>>  drivers/net/xen-netback/netback.c                    |  115 +++++++++-----
>>  drivers/regulator/max8998.c                          |    2
>>  drivers/regulator/of_regulator.c                     |    6
>>  drivers/regulator/s2mps11.c                          |    4
>>  include/linux/netdevice.h                            |    3
>>  include/net/ip.h                                     |    2
>>  net/bluetooth/smp.c                                  |   13 +
>>  net/core/dev.c                                       |    8 +
>>  net/core/pktgen.c                                    |    9 -
>>  net/core/request_sock.c                              |    2
>>  net/core/skbuff.c                                    |   44 +----
>>  net/ipv4/datagram.c                                  |   25 +++
>>  net/ipv4/ip_gre.c                                    |    6
>>  net/ipv4/ip_sockglue.c                               |    2
>>  net/ipv4/ping.c                                      |    1
>>  net/ipv4/raw.c                                       |    1
>>  net/ipv4/route.c                                     |   54 ++++++-
>>  net/ipv4/tcp.c                                       |   27 ++-
>>  net/ipv4/tcp_cong.c                                  |   14 +
>>  net/ipv4/tcp_input.c                                 |    8 -
>>  net/ipv4/tcp_ipv4.c                                  |    9 -
>>  net/ipv4/udp.c                                       |    1
>>  net/ipv6/addrconf.c                                  |    2
>>  net/ipv6/icmp.c                                      |   12 +
>>  net/ipv6/ip6_gre.c                                   |    2
>>  net/ipv6/ip6_output.c                                |    4
>>  net/ipv6/route.c                                     |    2
>>  net/packet/af_packet.c                               |   10 -
>>  net/sctp/endpointola.c                               |    5
>>  net/sctp/outqueue.c                                  |   12 +
>>  net/sctp/socket.c                                    |    2
>>  net/wireless/core.c                                  |    3
>>  69 files changed, 536 insertions(+), 290 deletions(-)
>>
>> Alexander Stein (1):
>>       can: c_can: Set reserved bit in IFx_MASK2 to 1 on write
>>
>> Alim Akhtar (1):
>>       regulator: s2mps11: fix incorrect register for buck10
>>
>> Bing Zhao (1):
>>       mwifiex: fix incomplete scan in case of IE parsing error
>>
>> Bruce Allan (1):
>>       e1000e: enable ECC on I217/I218 to catch packet buffer memory errors
>>
>> Cong Wang (2):
>>       net: prevent setting ttl=0 via IP_TTL
>>       pktgen: correctly handle failures when adding a device
>>
>> Daniel Borkmann (2):
>>       net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
>>       net: sctp: sctp_endpoint_free: zero out secret key data
>>
>> David S. Miller (1):
>>       via-rhine: Fix bugs in NAPI support.
>>
>> Emmanuel Grumbach (1):
>>       Revert "iwlwifi: fix the reclaimed packet tracking upon flush queue"
>>
>> Eric Dumazet (11):
>>       tcp: fix a panic on UP machines in reqsk_fastopen_remove
>>       macvlan: fix macvlan_get_size()
>>       tcp: fix incorrect LOCKDROPPEDICMPS counter
>>       netxen: fix off by one bug in netxen_release_tx_buffer()
>>       net: loopback: fix a dst refcounting issue
>>       tcp: fix an infinite loop in tcp_slow_start()
>>       tcp: frto should not set snd_cwnd to 0
>>       tcp: splice: fix an infinite loop in tcp_read_sock()
>>       tcp: fix splice() and tcp collapsing interaction
>>       net: splice: avoid high order page splitting
>>       net: splice: fix __splice_segment()
>>
>> Felix Fietkau (1):
>>       ath9k_hw: fix calibration issues on chainmask that don't include chain 0
>>
>> Greg Kroah-Hartman (1):
>>       Linux 3.7.8
>>
>> Heiko Carstens (1):
>>       atm/iphase: rename fregt_t -> ffreg_t
>>
>> Ian Campbell (3):
>>       xen/netback: shutdown the ring if it contains garbage.
>>       xen/netback: free already allocated memory on failure in xen_netbk_get_requests
>>       netback: correct netbk_tx_err to handle wrap around.
>>
>> Ilpo Järvinen (1):
>>       tcp: fix for zero packets_in_flight was too broad
>>
>> Johan Hedberg (1):
>>       Bluetooth: Fix handling of unexpected SMP PDUs
>>
>> Larry Finger (2):
>>       rtlwifi: Fix the usage of the wrong variable in usb.c
>>       rtlwifi: Fix scheduling while atomic bug
>>
>> Linus Walleij (1):
>>       mfd: db8500-prcmu: Fix irqdomain usage
>>
>> Marcelo Ricardo Leitner (1):
>>       ipv6: do not create neighbor entries for local delivery
>>
>> Marcin Slusarz (1):
>>       drm/nouveau: add lockdep annotations
>>
>> Marek Szyprowski (1):
>>       regulator: max8998: fix incorrect min_uV value for ldo10
>>
>> Matthew Daley (1):
>>       xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.
>>
>> Mauro Carvalho Chehab (1):
>>       media: pwc-if: must check vb2_queue_init() success
>>
>> Mike Marciniszyn (1):
>>       IB/qib: Fix for broken sparse warning fix
>>
>> Mike Snitzer (1):
>>       dm thin: fix queue limits stacking
>>
>> Neil Horman (1):
>>       sctp: refactor sctp_outq_teardown to insure proper re-initalization
>>
>> Or Gerlitz (1):
>>       net/mlx4_core: Set number of msix vectors under SRIOV mode to firmware defaults
>>
>> Phil Sutter (1):
>>       packet: fix leakage of tx_ring memory
>>
>> Pravin B Shelar (1):
>>       IP_GRE: Fix kernel panic in IP_GRE with GRE csum.
>>
>> Rob Herring (1):
>>       net: calxedaxgmac: throw away overrun frames
>>
>> Romain KUNTZ (1):
>>       ipv6: fix header length calculation in ip6_append_data()
>>
>> Romain Kuntz (1):
>>       ipv6: fix the noflags test in addrconf_get_prefix_route
>>
>> Sjur Brændeland (1):
>>       virtio_console: Don't access uninitialized data.
>>
>> Stanislaw Gruszka (1):
>>       net, wireless: overwrite default_ethtool_ops
>>
>> Steffen Klassert (6):
>>       ipv4: Remove output route check in ipv4_mtu
>>       ipv4: Don't update the pmtu on mtu locked routes
>>       ipv6: Add an error handler for icmp6
>>       ipv4: Invalidate the socket cached route on pmtu events if possible
>>       ipv4: Add a socket release callback for datagram sockets
>>       ipv4: Fix route refcount on pmtu discovery
>>
>> Stephen Hemminger (1):
>>       MAINTAINERS: Stephen Hemminger email change
>>
>> Stephen Warren (1):
>>       regulator: clear state each invocation of of_regulator_match
>>
>> Tilman Schmidt (1):
>>       isdn/gigaset: fix zero size border case in debug dump
>>
>> Timo Teräs (1):
>>       r8169: remove the obsolete and incorrect AMD workaround
>>
>> Tommi Rantala (1):
>>       ipv6/ip6_gre: fix error case handling in ip6gre_tunnel_xmit()
>>
>> Willy Tarreau (1):
>>       tcp: don't abort splice() after small transfers
>>
>> Yan Burman (1):
>>       net/mlx4_en: Fix bridged vSwitch configuration for non SRIOV mode
>>
>> Yuchung Cheng (1):
>>       tcp: detect SYN/data drop when F-RTO is disabled
>>
