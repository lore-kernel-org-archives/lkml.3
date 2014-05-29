Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbaE2Ns3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:48:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58942 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932416AbaE2Ns1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:48:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 000/103] 3.12.21-stable review
Date: Thu, 29 May 2014 15:48:21 +0200
Message-Id: <cover.1401371258.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.21 release.
There are 103 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Jun  2 13:47:39 2014
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.21-rc1.xz
and the diffstat can be found below.

thanks,
js

===============


AceLan Kao (3):
  HID: usbhid: merge the sis quirk
  HID: usbhid: quirk for Synaptics HD touchscreen
  HID: usbhid: quirk for Synaptics Quad HD touchscreen

Al Viro (1):
  don't bother with {get,put}_write_access() on non-regular files

Aleksander Morgado (1):
  net: qmi_wwan: add support for Cinterion PXS8 and PHS8

Alex Deucher (2):
  drm/radeon: call drm_edid_to_eld when we update the edid
  drm/radeon: fix typo in spectre_golden_registers

Andreas Schwab (1):
  powerpc: Add vr save/restore functions

Andrew Lutomirski (1):
  net: Fix ns_capable check in sock_diag_put_filterinfo

Andrey Vagin (1):
  netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len

Andy King (1):
  vsock: Make transport the proto owner

Antonio Quartulli (1):
  batman-adv: increase orig refcount when storing ref in gw_node

Benjamin Tissoires (1):
  HID: core: do not scan constant input report

Bjørn Mork (14):
  usb: qcserial: add Sierra Wireless EM7355
  usb: qcserial: add Sierra Wireless MC73xx
  usb: qcserial: add Sierra Wireless MC7305/MC7355
  usb: option: add Olivetti Olicard 500
  usb: option: add Alcatel L800MA
  usb: option: add and update a number of CMOTech devices
  net: qmi_wwan: add Sierra Wireless EM7355
  net: qmi_wwan: add Sierra Wireless MC73xx
  net: qmi_wwan: add Sierra Wireless MC7305/MC7355
  net: qmi_wwan: add Olivetti Olicard 500
  net: qmi_wwan: add Alcatel L800MA
  net: qmi_wwan: add a number of CMOTech devices
  net: qmi_wwan: add a number of Dell devices
  net: cdc_mbim: handle unaccelerated VLAN tagged frames

Chris Mason (1):
  mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll

Christopher Friedt (1):
  drm/vmwgfx: correct fb_fix_screeninfo.line_length

Cong Wang (1):
  rtnetlink: wait for unregistering devices in rtnl_link_unregister()

Dan Carpenter (1):
  SCSI: megaraid: missing bounds check in mimd_to_kioc()

Daniel Borkmann (2):
  net: sctp: wake up all assocs if sndbuf policy is per socket
  net: sctp: test if association is dead in sctp_wake_up_waiters

Daniele Palmas (1):
  usb: option driver, add support for Telit UE910v2

David Gibson (2):
  rtnetlink: Warn when interface's information won't fit in our packet
  rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF
    is set

Dmitry Petukhov (1):
  l2tp: take PMTU from tunnel UDP socket

Emanuel Krenz (1):
  HID: add support for SiS multitouch panel in the touch monitor LG
    23ET83V

Eric Dumazet (2):
  ipv6: Limit mtu to 65575 bytes
  net-gro: reset skb->truesize in napi_reuse_skb()

Fabio Porcedda (1):
  net: qmi_wwan: add Telit LE920 newer firmware support

Florian Westphal (3):
  net: core: don't account for udp header size when computing seglen
  net: ipv4: ip_forward: fix inverted local_df test
  net: ipv6: send pkttoobig immediately if orig frag size > mtu

Hans de Goede (2):
  xhci: For streams the css flag most be read from the stream-ctx on ep
    stop
  HID: add NO_INIT_REPORTS quirk for Synaptics Touch Pad V 103S

Ilya Dryomov (1):
  rbd: fix error paths in rbd_img_request_fill()

Ivan Vecera (1):
  tg3: update rx_jumbo_pending ring param only when jumbo frames are
    enabled

James Bottomley (2):
  scsi: fix our current target reap infrastructure
  SCSI: dual scan thread bug fix

Jani Nikula (1):
  drm/i915/tv: fix gen4 composite s-video tv-out

Johan Hovold (4):
  USB: usb_wwan: fix handling of missing bulk endpoints
  Revert "USB: serial: add usbid for dell wwan card to sierra.c"
  USB: serial: fix sysfs-attribute removal deadlock
  USB: io_ti: fix firmware download on big-endian machines

Julian Anastasov (1):
  ipv4: return valid RTA_IIF on ip route get

Konrad Rzeszutek Wilk (1):
  xen/spinlock: Don't enable them unconditionally.

Kumar Sundararajan (1):
  ipv6: fib: fix fib dump restart

Li RongQing (1):
  ipv4: initialise the itag variable in __mkroute_input

Liu Yu (1):
  tcp_cubic: fix the range of delayed_ack

Maarten Lankhorst (1):
  drm/qxl: unset a pointer in sync_obj_unref

Marcelo Tosatti (1):
  KVM: x86: remove WARN_ON from get_kernel_ns()

Mathias Krause (1):
  filter: prevent nla extensions to peek beyond the end of the message

Mel Gorman (1):
  mm: use paravirt friendly ops for NUMA hinting ptes

Michael Ulbricht (1):
  USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM
    driver

Michele Baldessari (1):
  USB: serial: ftdi_sio: add id for Brainboxes serial cards

Mikulas Patocka (1):
  tgafb: fix mode setting with fbset

Mizuma, Masayoshi (1):
  mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()

NeilBrown (1):
  md/raid1: r1buf_pool_alloc: free allocate pages when subsequent
    allocation fails.

Nicolas Dichtel (3):
  gre: don't allow to add the same tunnel twice
  vti: don't allow to add the same tunnel twice
  ip6_gre: don't allow to remove the fb_tunnel_dev

Nikolay Aleksandrov (1):
  sfc: fix calling of free_irq with already free vector

Oleg Nesterov (1):
  list: introduce list_next_entry() and list_prev_entry()

Oliver Hartkopp (1):
  slip: fix spinlock variant

Peter Christensen (1):
  macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.

Raymond Wanyoike (1):
  net: qmi_wwan: add ZTE MF667

Richard Guy Briggs (4):
  audit: restore order of tty and ses fields in log output
  pid: get pid_t ppid of task in init_pid_ns
  sched: declare pid_alive as inline
  audit: convert PPIDs to the inital PID namespace.

Roman Pen (1):
  blktrace: fix accounting of partially completed requests

Sachin Prabhu (1):
  cifs: Wait for writebacks to complete before attempting write.

Sergey Popovich (1):
  ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation

Steffen Klassert (1):
  ip_tunnel: Initialize the fallback device properly

Steven Rostedt (Red Hat) (1):
  tracepoint: Do not waste memory on mods with no tracepoints

Susant Sahani (1):
  ip6_tunnel: fix potential NULL pointer dereference

Thomas Bächler (1):
  fs: Don't return 0 from get_anon_bdev

Thomas Graf (1):
  netfilter: Can't fail and free after table replacement

Thomas Hellstrom (1):
  drm/vmwgfx: Make sure user-space can't DMA across buffer object
    boundaries v2

Thomas Richter (1):
  bonding: Remove debug_fs files when module init fails

Toshiaki Makita (2):
  bridge: Fix double free and memory leak around br_allowed_ingress
  bridge: Handle IFLA_ADDRESS correctly when creating bridge device

Tristan Bruns (1):
  USB: cp210x: Add 8281 (Nanotec Plug & Drive)

Viresh Kumar (1):
  tick-common: Fix wrong check in tick_check_replacement()

Vlad Yasevich (3):
  net: sctp: cache auth_enable per endpoint
  mactap: Fix checksum errors for non-gso packets in bridge mode
  Revert "macvlan : fix checksums error when we are in bridge mode"

Wanlong Gao (1):
  HID: usbhid: fix sis quirk

Xufeng Zhang (1):
  sctp: reset flowi4_oif parameter on route lookup

Ying Cai (1):
  ip_tunnel: Set network header properly for IP_ECN_decapsulate()

Yufeng Shen (1):
  HID: usbhid: quirk for CY-TM75 75 inch Touch Overlay

dingtianhong (1):
  vlan: Fix lockdep warning when vlan dev handle notification

 arch/powerpc/lib/crtsavres.S                   | 186 +++++++++++++++++++++++++
 arch/x86/kvm/x86.c                             |   1 -
 arch/x86/xen/spinlock.c                        |   5 +-
 block/blk-core.c                               |   2 +-
 drivers/block/rbd.c                            |   2 +-
 drivers/gpu/drm/i915/intel_tv.c                |   9 +-
 drivers/gpu/drm/qxl/qxl_ttm.c                  |   1 +
 drivers/gpu/drm/radeon/cik.c                   |   2 +-
 drivers/gpu/drm/radeon/radeon_display.c        |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c        |  22 +++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c             |   5 +-
 drivers/hid/hid-core.c                         |   8 +-
 drivers/hid/hid-ids.h                          |  10 +-
 drivers/hid/hid-multitouch.c                   |   7 +-
 drivers/hid/usbhid/hid-quirks.c                |  11 +-
 drivers/md/raid1.c                             |  17 ++-
 drivers/net/bonding/bond_main.c                |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |   3 -
 drivers/net/ethernet/broadcom/tg3.c            |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |   1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |   6 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |   1 -
 drivers/net/ethernet/sfc/nic.c                 |  14 +-
 drivers/net/macvlan.c                          |   9 +-
 drivers/net/macvtap.c                          |   9 ++
 drivers/net/slip/slip.c                        |   6 +-
 drivers/net/usb/cdc_mbim.c                     |  39 ++++--
 drivers/net/usb/qmi_wwan.c                     |  31 +++++
 drivers/scsi/megaraid/megaraid_mm.c            |   2 +
 drivers/scsi/scsi_scan.c                       | 112 +++++++++------
 drivers/scsi/scsi_sysfs.c                      |  20 ++-
 drivers/usb/class/cdc-acm.c                    |  28 +++-
 drivers/usb/host/xhci-ring.c                   |  14 +-
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
 fs/cifs/cifsfs.c                               |  14 +-
 fs/cifs/cifsglob.h                             |   8 ++
 fs/cifs/cifsproto.h                            |   3 +
 fs/cifs/file.c                                 |  31 ++++-
 fs/cifs/misc.c                                 |  74 +++++++++-
 fs/cifs/smb1ops.c                              |  11 ++
 fs/cifs/smb2misc.c                             |  18 ++-
 fs/cifs/smb2ops.c                              |  14 ++
 fs/file_table.c                                |   4 +-
 fs/open.c                                      |  26 +---
 fs/super.c                                     |   5 +-
 include/asm-generic/pgtable.h                  |  31 +++--
 include/linux/list.h                           |  16 +++
 include/linux/rtnetlink.h                      |   5 +
 include/linux/sched.h                          |  20 ++-
 include/linux/sock_diag.h                      |   2 +-
 include/net/af_vsock.h                         |   6 +-
 include/net/ip6_route.h                        |   5 +
 include/net/netfilter/nf_conntrack_extend.h    |   4 +-
 include/net/sctp/structs.h                     |   4 +-
 include/scsi/scsi_device.h                     |   3 +-
 include/trace/events/block.h                   |  33 ++++-
 kernel/audit.c                                 |   8 +-
 kernel/auditsc.c                               |   2 +-
 kernel/events/core.c                           |   3 -
 kernel/time/tick-common.c                      |   2 +-
 kernel/trace/blktrace.c                        |  20 +--
 kernel/tracepoint.c                            |   6 +
 mm/hugetlb.c                                   |   1 +
 net/8021q/vlan_dev.c                           |  46 +++++-
 net/batman-adv/gateway_client.c                |  11 +-
 net/bridge/br_input.c                          |   2 +-
 net/bridge/br_netlink.c                        |  15 ++
 net/bridge/br_vlan.c                           |   7 +-
 net/bridge/netfilter/ebtables.c                |   5 +-
 net/core/dev.c                                 |   4 +-
 net/core/filter.c                              |   6 +-
 net/core/net_namespace.c                       |   2 +-
 net/core/rtnetlink.c                           |  66 +++++++--
 net/core/skbuff.c                              |  12 +-
 net/core/sock_diag.c                           |   4 +-
 net/ipv4/fib_semantics.c                       |   2 +-
 net/ipv4/ip_forward.c                          |   4 +-
 net/ipv4/ip_gre.c                              |   2 +-
 net/ipv4/ip_tunnel.c                           |   3 +
 net/ipv4/ip_vti.c                              |   2 +-
 net/ipv4/netfilter/arp_tables.c                |   6 +-
 net/ipv4/netfilter/ip_tables.c                 |   6 +-
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
 net/vmw_vsock/af_vsock.c                       |  47 +++----
 scripts/mod/modpost.c                          |   8 +-
 110 files changed, 1351 insertions(+), 362 deletions(-)

-- 
1.9.3

