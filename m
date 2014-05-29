Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbaE2EiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:38:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795AbaE2EiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/86] 3.10.41-stable review
Date: Wed, 28 May 2014 21:36:35 -0700
Message-Id: <20140529043513.451722422@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.41 release.
There are 86 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat May 31 04:34:49 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.41-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.41-rc1

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add a number of Dell devices

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add a number of CMOTech devices

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Alcatel L800MA

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Olivetti Olicard 500

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Sierra Wireless MC7305/MC7355

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Sierra Wireless MC73xx

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Sierra Wireless EM7355

Aleksander Morgado <aleksander@aleksander.es>
    net: qmi_wwan: add support for Cinterion PXS8 and PHS8

Raymond Wanyoike <raymond.wanyoike@gmail.com>
    net: qmi_wwan: add ZTE MF667

Enrico Mioso <mrkiko.rs@gmail.com>
    net: qmi_wwan: Olivetti Olicard 200 support

Aleksander Morgado <aleksander@lanedo.com>
    net: qmi_wwan: fix Cinterion PLXX product ID

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: qmi_wwan: add Telit LE920 newer firmware support

Enrico Mioso <mrkiko.rs@gmail.com>
    qmi_wwan: add ONDA MT689DC device ID (fwd)

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add TP-LINK MA260

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Option GTM681W

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: fixup Sierra Wireless MC8305 entry

Eric Dumazet <edumazet@google.com>
    net-gro: reset skb->truesize in napi_reuse_skb()

Li RongQing <roy.qing.li@gmail.com>
    ipv4: initialise the itag variable in __mkroute_input

Susant Sahani <susant@redhat.com>
    ip6_tunnel: fix potential NULL pointer dereference

Peter Christensen <pch@ordbogen.com>
    macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.

Bjørn Mork <bjorn@mork.no>
    net: cdc_mbim: handle unaccelerated VLAN tagged frames

Sergey Popovich <popovich_sergei@mail.ru>
    ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation

Florian Westphal <fw@strlen.de>
    net: ipv6: send pkttoobig immediately if orig frag size > mtu

Florian Westphal <fw@strlen.de>
    net: ipv4: ip_forward: fix inverted local_df test

Liu Yu <allanyuliu@tencent.com>
    tcp_cubic: fix the range of delayed_ack

Vlad Yasevich <vyasevic@redhat.com>
    Revert "macvlan : fix checksums error when we are in bridge mode"

Xufeng Zhang <xufeng.zhang@windriver.com>
    sctp: reset flowi4_oif parameter on route lookup

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
    bridge: Handle IFLA_ADDRESS correctly when creating bridge device

Kumar Sundararajan <kumar@fb.com>
    ipv6: fib: fix fib dump restart

David Gibson <david@gibson.dropbear.id.au>
    rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF is set

David Gibson <david@gibson.dropbear.id.au>
    rtnetlink: Warn when interface's information won't fit in our packet

Andrew Lutomirski <luto@amacapital.net>
    net: Fix ns_capable check in sock_diag_put_filterinfo

Vlad Yasevich <vyasevic@redhat.com>
    net: sctp: cache auth_enable per endpoint

Ivan Vecera <ivecera@redhat.com>
    tg3: update rx_jumbo_pending ring param only when jumbo frames are enabled

dingtianhong <dingtianhong@huawei.com>
    vlan: Fix lockdep warning when vlan dev handle notification

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip6_gre: don't allow to remove the fb_tunnel_dev

Mathias Krause <minipli@googlemail.com>
    filter: prevent nla extensions to peek beyond the end of the message

Julian Anastasov <ja@ssi.bg>
    ipv4: return valid RTA_IIF on ip route get

Wang, Xiaoming <xiaoming.wang@intel.com>
    net: ipv4: current group_info should be put after using.

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vti: don't allow to add the same tunnel twice

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    gre: don't allow to add the same tunnel twice

Eric Dumazet <edumazet@google.com>
    ipv6: Limit mtu to 65575 bytes

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
    bridge: Fix double free and memory leak around br_allowed_ingress

Thomas Richter <tmricht@linux.vnet.ibm.com>
    bonding: Remove debug_fs files when module init fails

Florian Westphal <fw@strlen.de>
    net: core: don't account for udp header size when computing seglen

Dmitry Petukhov <dmgenp@gmail.com>
    l2tp: take PMTU from tunnel UDP socket

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: test if association is dead in sctp_wake_up_waiters

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: wake up all assocs if sndbuf policy is per socket

Oleg Nesterov <oleg@redhat.com>
    list: introduce list_next_entry() and list_prev_entry()

Alex Deucher <alexdeucher@gmail.com>
    drm/radeon: call drm_edid_to_eld when we update the edid

Maarten Lankhorst <maarten.lankhorst@canonical.com>
    drm/qxl: unset a pointer in sync_obj_unref

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Make sure user-space can't DMA across buffer object boundaries v2

Christopher Friedt <chrisfriedt@gmail.com>
    drm/vmwgfx: correct fb_fix_screeninfo.line_length

Bjørn Mork <bjorn@mork.no>
    usb: option: add and update a number of CMOTech devices

Bjørn Mork <bjorn@mork.no>
    usb: option: add Alcatel L800MA

Bjørn Mork <bjorn@mork.no>
    usb: option: add Olivetti Olicard 500

Bjørn Mork <bjorn@mork.no>
    usb: qcserial: add Sierra Wireless MC7305/MC7355

Bjørn Mork <bjorn@mork.no>
    usb: qcserial: add Sierra Wireless MC73xx

Bjørn Mork <bjorn@mork.no>
    usb: qcserial: add Sierra Wireless EM7355

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix firmware download on big-endian machines

Johan Hovold <jhovold@gmail.com>
    USB: serial: fix sysfs-attribute removal deadlock

Johan Hovold <jhovold@gmail.com>
    Revert "USB: serial: add usbid for dell wwan card to sierra.c"

Daniele Palmas <dnlplm@gmail.com>
    usb: option driver, add support for Telit UE910v2

Michele Baldessari <michele@acksyn.org>
    USB: serial: ftdi_sio: add id for Brainboxes serial cards

Johan Hovold <jhovold@gmail.com>
    USB: usb_wwan: fix handling of missing bulk endpoints

Tristan Bruns <tristan@tristanbruns.de>
    USB: cp210x: Add 8281 (Nanotec Plug & Drive)

Michael Ulbricht <michael.ulbricht@systec-electronic.com>
    USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM driver

Mel Gorman <mgorman@suse.de>
    mm: use paravirt friendly ops for NUMA hinting ptes

Mizuma, Masayoshi <m.mizuma@jp.fujitsu.com>
    mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()

NeilBrown <neilb@suse.de>
    md/raid1: r1buf_pool_alloc: free allocate pages when subsequent allocation fails.

Al Viro <viro@zeniv.linux.org.uk>
    don't bother with {get,put}_write_access() on non-regular files

Helge Deller <deller@gmx.de>
    parisc: fix epoll_pwait syscall on compat kernel

Mikulas Patocka <mpatocka@redhat.com>
    tgafb: fix mode setting with fbset

Andreas Schwab <schwab@linux-m68k.org>
    powerpc: Add vr save/restore functions

Ilya Dryomov <ilya.dryomov@inktank.com>
    rbd: fix error paths in rbd_img_request_fill()

Olof Johansson <olof@lixom.net>
    ARM: multi_v7_defconfig: enable ARM_ATAG_DTB_COMPAT

Soren Brinkmann <soren.brinkmann@xilinx.com>
    arm: multi_v7_defconfig: Enable initrd/initramfs support

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: ohci: fix probe failure with Agere/LSI controllers

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: ohci: beautify some macro definitions

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracepoint: Do not waste memory on mods with no tracepoints

Thomas Graf <tgraf@suug.ch>
    netfilter: Can't fail and free after table replacement

Andrey Vagin <avagin@openvz.org>
    netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len

Roman Pen <r.peniaev@gmail.com>
    blktrace: fix accounting of partially completed requests

Dan Carpenter <dan.carpenter@oracle.com>
    SCSI: megaraid: missing bounds check in mimd_to_kioc()

James Bottomley <JBottomley@Parallels.com>
    SCSI: dual scan thread bug fix

James Bottomley <JBottomley@Parallels.com>
    scsi: fix our current target reap infrastructure


-------------

Diffstat:

 Makefile                                       |   4 +-
 arch/arm/configs/multi_v7_defconfig            |   2 +
 arch/parisc/kernel/syscall_table.S             |   2 +-
 arch/powerpc/lib/crtsavres.S                   | 186 +++++++++++++++++++++++++
 block/blk-core.c                               |   2 +-
 drivers/block/rbd.c                            |   2 +-
 drivers/firewire/ohci.c                        |  31 ++---
 drivers/gpu/drm/qxl/qxl_ttm.c                  |   1 +
 drivers/gpu/drm/radeon/radeon_display.c        |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c        |  22 +++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c             |   5 +-
 drivers/md/raid1.c                             |  17 ++-
 drivers/net/bonding/bond_main.c                |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |   3 -
 drivers/net/ethernet/broadcom/tg3.c            |   4 +-
 drivers/net/macvlan.c                          |   9 +-
 drivers/net/usb/cdc_mbim.c                     |  39 ++++--
 drivers/net/usb/qmi_wwan.c                     |  38 ++++-
 drivers/scsi/megaraid/megaraid_mm.c            |   2 +
 drivers/scsi/scsi_scan.c                       | 112 +++++++++------
 drivers/scsi/scsi_sysfs.c                      |  20 ++-
 drivers/usb/class/cdc-acm.c                    |  28 +++-
 drivers/usb/serial/cp210x.c                    |   1 +
 drivers/usb/serial/ftdi_sio.c                  |  33 +++++
 drivers/usb/serial/ftdi_sio_ids.h              |  37 +++++
 drivers/usb/serial/io_ti.c                     |  50 ++++---
 drivers/usb/serial/option.c                    |  83 ++++++++++-
 drivers/usb/serial/qcserial.c                  |   9 ++
 drivers/usb/serial/sierra.c                    |   1 -
 drivers/usb/serial/usb-serial.c                |   4 +-
 drivers/usb/serial/usb_wwan.c                  |   9 +-
 drivers/video/tgafb.c                          |  15 +-
 fs/file_table.c                                |   4 +-
 fs/open.c                                      |  26 +---
 include/asm-generic/pgtable.h                  |  31 +++--
 include/linux/list.h                           |  16 +++
 include/linux/sock_diag.h                      |   2 +-
 include/net/ip6_route.h                        |   5 +
 include/net/netfilter/nf_conntrack_extend.h    |   4 +-
 include/net/sctp/structs.h                     |   4 +-
 include/scsi/scsi_device.h                     |   3 +-
 include/trace/events/block.h                   |  33 ++++-
 kernel/events/core.c                           |   3 -
 kernel/trace/blktrace.c                        |  20 +--
 kernel/tracepoint.c                            |   6 +
 mm/hugetlb.c                                   |   1 +
 net/8021q/vlan_dev.c                           |  46 +++++-
 net/bridge/br_input.c                          |   2 +-
 net/bridge/br_netlink.c                        |  15 ++
 net/bridge/br_vlan.c                           |   7 +-
 net/bridge/netfilter/ebtables.c                |   5 +-
 net/core/dev.c                                 |   2 +
 net/core/filter.c                              |   6 +-
 net/core/rtnetlink.c                           |  33 +++--
 net/core/skbuff.c                              |  12 +-
 net/core/sock_diag.c                           |   4 +-
 net/ipv4/fib_semantics.c                       |   2 +-
 net/ipv4/ip_forward.c                          |   4 +-
 net/ipv4/ip_gre.c                              |   2 +-
 net/ipv4/ip_vti.c                              |   2 +-
 net/ipv4/netfilter/arp_tables.c                |   6 +-
 net/ipv4/netfilter/ip_tables.c                 |   6 +-
 net/ipv4/ping.c                                |  15 +-
 net/ipv4/route.c                               |   4 +-
 net/ipv4/tcp_cubic.c                           |   2 +-
 net/ipv6/ip6_fib.c                             |   3 +-
 net/ipv6/ip6_gre.c                             |  10 ++
 net/ipv6/ip6_output.c                          |   6 +-
 net/ipv6/ip6_tunnel.c                          |   2 +-
 net/ipv6/netfilter/ip6_tables.c                |   6 +-
 net/ipv6/route.c                               |   5 +-
 net/l2tp/l2tp_ppp.c                            |   4 +-
 net/packet/diag.c                              |   2 +-
 net/sctp/auth.c                                |  17 +--
 net/sctp/endpointola.c                         |   3 +-
 net/sctp/protocol.c                            |   7 +-
 net/sctp/sm_make_chunk.c                       |  32 +++--
 net/sctp/sm_statefuns.c                        |   6 +-
 net/sctp/socket.c                              |  96 +++++++++----
 net/sctp/sysctl.c                              |  38 ++++-
 scripts/mod/modpost.c                          |   8 +-
 81 files changed, 1041 insertions(+), 310 deletions(-)


