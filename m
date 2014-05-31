Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaEaVDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 17:03:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaEaVDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 17:03:11 -0400
Date: Sat, 31 May 2014 14:03:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.5
Message-ID: <20140531210309.GA313@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.5 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                       |    4=20
 arch/parisc/include/asm/shmparam.h             |    5 -
 arch/parisc/include/uapi/asm/resource.h        |    1=20
 arch/parisc/kernel/cache.c                     |    3=20
 arch/parisc/kernel/sys_parisc.c                |   14 +--
 arch/parisc/kernel/syscall_table.S             |    2=20
 arch/s390/net/bpf_jit_comp.c                   |    2=20
 arch/x86/include/asm/preempt.h                 |   12 ++
 arch/x86/kvm/x86.c                             |    1=20
 arch/x86/net/bpf_jit_comp.c                    |    2=20
 arch/x86/xen/spinlock.c                        |    5 -
 block/blk-core.c                               |    2=20
 drivers/block/rbd.c                            |    2=20
 drivers/gpu/drm/i915/i915_drv.h                |    1=20
 drivers/gpu/drm/i915/i915_trace.h              |    4=20
 drivers/gpu/drm/i915/intel_display.c           |   16 +++
 drivers/gpu/drm/i915/intel_panel.c             |    4=20
 drivers/gpu/drm/i915/intel_tv.c                |    9 +-
 drivers/gpu/drm/qxl/qxl_ttm.c                  |    1=20
 drivers/gpu/drm/radeon/cik.c                   |    6 -
 drivers/gpu/drm/radeon/radeon_display.c        |    1=20
 drivers/gpu/drm/radeon/radeon_ring.c           |    1=20
 drivers/gpu/drm/vmwgfx/vmwgfx_context.c        |    2=20
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c        |   22 ++++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c             |    5 -
 drivers/hid/hid-core.c                         |    5 -
 drivers/hid/hid-ids.h                          |    3=20
 drivers/hid/hid-microsoft.c                    |    4=20
 drivers/hid/usbhid/hid-quirks.c                |    1=20
 drivers/md/raid1.c                             |   17 ++-
 drivers/net/bonding/bond_main.c                |    1=20
 drivers/net/bonding/bond_options.c             |    1=20
 drivers/net/ethernet/broadcom/tg3.c            |    4=20
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |    1=20
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    6 -
 drivers/net/ethernet/mellanox/mlx4/main.c      |    3=20
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |    1=20
 drivers/net/ethernet/sfc/nic.c                 |   14 +--
 drivers/net/macvlan.c                          |   21 +++-
 drivers/net/macvtap.c                          |    9 ++
 drivers/net/phy/phy_device.c                   |    4=20
 drivers/net/slip/slip.c                        |    6 -
 drivers/net/usb/cdc_mbim.c                     |   57 +++++++++---
 drivers/net/usb/cdc_ncm.c                      |    2=20
 drivers/net/usb/qmi_wwan.c                     |   28 ++++++
 drivers/net/wireless/ti/wl18xx/event.h         |   20 ++++
 drivers/scsi/megaraid/megaraid_mm.c            |    2=20
 drivers/scsi/scsi_scan.c                       |  112 +++++++++++++++-----=
-----
 drivers/scsi/scsi_sysfs.c                      |   20 +++-
 drivers/tty/serial/omap-serial.c               |   29 +++---
 drivers/usb/class/cdc-acm.c                    |   28 ++++--
 drivers/usb/serial/cp210x.c                    |    1=20
 drivers/usb/serial/ftdi_sio.c                  |   33 +++++++
 drivers/usb/serial/ftdi_sio_ids.h              |   37 ++++++++
 drivers/usb/serial/io_ti.c                     |   50 +++++++----
 drivers/usb/serial/option.c                    |   83 +++++++++++++++++-
 drivers/usb/serial/qcserial.c                  |    9 ++
 drivers/usb/serial/sierra.c                    |    1=20
 drivers/usb/serial/usb-serial.c                |    4=20
 drivers/usb/serial/usb_wwan.c                  |    9 --
 drivers/xen/events/events_fifo.c               |   41 ++++++---
 fs/cifs/cifsfs.c                               |   14 ++-
 fs/cifs/cifsglob.h                             |    8 +
 fs/cifs/cifsproto.h                            |    3=20
 fs/cifs/file.c                                 |   31 ++++++
 fs/cifs/misc.c                                 |   74 ++++++++++++++++
 fs/cifs/smb1ops.c                              |   11 ++
 fs/cifs/smb2misc.c                             |   18 +++-
 fs/cifs/smb2ops.c                              |   14 +++
 fs/file_table.c                                |    4=20
 fs/open.c                                      |   26 +----
 fs/super.c                                     |    5 -
 include/asm-generic/pgtable.h                  |   31 +++++-
 include/linux/if_macvlan.h                     |    1=20
 include/linux/if_vlan.h                        |    3=20
 include/linux/net.h                            |   15 ---
 include/linux/netdevice.h                      |   18 +++-
 include/linux/preempt.h                        |    2=20
 include/linux/rtnetlink.h                      |    5 +
 include/linux/sched.h                          |   20 ++++
 include/linux/sock_diag.h                      |    2=20
 include/linux/thread_info.h                    |    2=20
 include/net/af_vsock.h                         |    6 +
 include/net/ip6_route.h                        |    5 +
 include/net/netfilter/nf_conntrack_extend.h    |    4=20
 include/net/netfilter/nf_tables_core.h         |   10 ++
 include/net/sctp/structs.h                     |   18 +++-
 include/scsi/scsi_device.h                     |    3=20
 include/trace/events/block.h                   |   33 ++++++-
 init/Kconfig                                   |   24 ++---
 kernel/audit.c                                 |    4=20
 kernel/auditsc.c                               |    2=20
 kernel/time/tick-common.c                      |    2=20
 kernel/time/tick-sched.c                       |    5 -
 kernel/trace/blktrace.c                        |   20 ++--
 kernel/trace/trace_events_trigger.c            |    2=20
 kernel/trace/trace_uprobe.c                    |    6 +
 kernel/tracepoint.c                            |    6 +
 mm/huge_memory.c                               |   13 ++
 mm/hugetlb.c                                   |    1=20
 net/8021q/vlan.c                               |    1=20
 net/8021q/vlan_dev.c                           |   13 +-
 net/batman-adv/bat_iv_ogm.c                    |    2=20
 net/batman-adv/distributed-arp-table.c         |    3=20
 net/batman-adv/fragmentation.c                 |   11 +-
 net/batman-adv/gateway_client.c                |   11 ++
 net/batman-adv/originator.c                    |   62 ++++++++++++-
 net/bridge/br_input.c                          |    2=20
 net/bridge/br_netlink.c                        |   15 +++
 net/bridge/br_vlan.c                           |    7 -
 net/bridge/netfilter/ebtables.c                |    5 -
 net/core/dev.c                                 |   56 ++++++++++++
 net/core/filter.c                              |    6 +
 net/core/neighbour.c                           |    4=20
 net/core/net_namespace.c                       |    2=20
 net/core/rtnetlink.c                           |   66 ++++++++++++--
 net/core/skbuff.c                              |   16 ++-
 net/core/sock_diag.c                           |    4=20
 net/core/utils.c                               |    8 -
 net/ipv4/fib_semantics.c                       |    2=20
 net/ipv4/ip_forward.c                          |    4=20
 net/ipv4/ip_gre.c                              |    2=20
 net/ipv4/ip_tunnel.c                           |    6 +
 net/ipv4/ip_vti.c                              |    2=20
 net/ipv4/netfilter/arp_tables.c                |    6 -
 net/ipv4/netfilter/ip_tables.c                 |    6 -
 net/ipv4/ping.c                                |   15 ++-
 net/ipv4/route.c                               |    4=20
 net/ipv4/tcp_cubic.c                           |    2=20
 net/ipv6/ip6_fib.c                             |    3=20
 net/ipv6/ip6_gre.c                             |   10 ++
 net/ipv6/ip6_offload.c                         |    6 -
 net/ipv6/ip6_output.c                          |    8 +
 net/ipv6/ip6_tunnel.c                          |    2=20
 net/ipv6/netfilter/ip6_tables.c                |    6 -
 net/ipv6/route.c                               |    5 -
 net/ipv6/tcpv6_offload.c                       |    2=20
 net/l2tp/l2tp_ppp.c                            |    4=20
 net/netfilter/nf_tables_api.c                  |    3=20
 net/netfilter/nf_tables_core.c                 |    3=20
 net/netfilter/nft_cmp.c                        |    2=20
 net/packet/diag.c                              |    2=20
 net/sched/cls_tcindex.c                        |   30 ++++--
 net/sched/sch_hhf.c                            |   11 +-
 net/sctp/associola.c                           |   82 ++++++++++++++----
 net/sctp/auth.c                                |   17 +--
 net/sctp/endpointola.c                         |    3=20
 net/sctp/protocol.c                            |    7 +
 net/sctp/sm_make_chunk.c                       |   32 +++----
 net/sctp/sm_sideeffect.c                       |    7 -
 net/sctp/sm_statefuns.c                        |    8 -
 net/sctp/socket.c                              |  102 ++++++++++++++++----=
--
 net/sctp/sysctl.c                              |   36 +++++++-
 net/sctp/ulpevent.c                            |    8 -
 net/vmw_vsock/af_vsock.c                       |   47 ++++------
 tools/lib/traceevent/event-parse.c             |    1=20
 156 files changed, 1546 insertions(+), 509 deletions(-)

Al Viro (1):
      don't bother with {get,put}_write_access() on non-regular files

Alex Deucher (3):
      drm/radeon: call drm_edid_to_eld when we update the edid
      drm/radeon: fix endian swap on hawaii clear state buffer setup
      drm/radeon: fix typo in spectre_golden_registers

Alexei Starovoitov (1):
      net: filter: x86: fix JIT address randomization

Andrew Lutomirski (1):
      net: Fix ns_capable check in sock_diag_put_filterinfo

Andrey Vagin (1):
      netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len

Andy King (1):
      vsock: Make transport the proto owner

Antonio Quartulli (3):
      batman-adv: fix reference counting imbalance while sending fragment
      batman-adv: increase orig refcount when storing ref in gw_node
      batman-adv: fix local TT check for outgoing arp requests in DAT

Benjamin Tissoires (1):
      HID: core: do not scan constant input report

Bj=F8rn Mork (16):
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
      net: cdc_ncm: fix buffer overflow
      net: cdc_mbim: __vlan_find_dev_deep need rcu_read_lock
      net: cdc_mbim: handle unaccelerated VLAN tagged frames

Chris Mason (1):
      mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll

Christian K=F6nig (1):
      drm/radeon: clear needs_reset flag if IB test fails

Christopher Friedt (1):
      drm/vmwgfx: correct fb_fix_screeninfo.line_length

Cong Wang (2):
      rtnetlink: wait for unregistering devices in rtnl_link_unregister()
      net_sched: fix an oops in tcindex filter

Dan Carpenter (1):
      SCSI: megaraid: missing bounds check in mimd_to_kioc()

Daniel Borkmann (3):
      net: sctp: wake up all assocs if sndbuf policy is per socket
      net: sctp: test if association is dead in sctp_wake_up_waiters
      Revert "net: sctp: Fix a_rwnd/rwnd management to reflect real state o=
f the receiver's buffer"

Daniele Palmas (1):
      usb: option driver, add support for Telit UE910v2

David Gibson (2):
      rtnetlink: Warn when interface's information won't fit in our packet
      rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF=
 is set

Derya (1):
      Revert "HID: microsoft: Add ID's for Surface Type/Touch Cover 2"

Dmitry Petukhov (1):
      l2tp: take PMTU from tunnel UDP socket

Duan Jiong (1):
      neigh: set nud_state to NUD_INCOMPLETE when probing router reachabili=
ty

Eliad Peller (1):
      wl18xx: align event mailbox with current fw

Eric Dumazet (4):
      ipv6: Limit mtu to 65575 bytes
      net: gro: make sure skb->cb[] initial content has not to be zero
      ipv6: gro: fix CHECKSUM_COMPLETE support
      net-gro: reset skb->truesize in napi_reuse_skb()

Eyal Perry (1):
      net/mlx4_core: Don't issue PCIe speed/width checks for VFs

Florian Westphal (3):
      net: core: don't account for udp header size when computing seglen
      net: ipv4: ip_forward: fix inverted local_df test
      net: ipv6: send pkttoobig immediately if orig frag size > mtu

Greg Kroah-Hartman (1):
      Linux 3.14.5

Guenter Roeck (1):
      net: phy: Don't call phy_resume if phy_init_hw failed

Hannes Frederic Sowa (2):
      net: avoid dependency of net_get_random_once on nop patching
      ipv6: fix calculation of option len in ip6_append_data

Hans de Goede (1):
      HID: add NO_INIT_REPORTS quirk for Synaptics Touch Pad V 103S

Heiko Carstens (1):
      net: filter: s390: fix JIT address randomization

Helge Deller (2):
      parisc: change value of SHMLBA from 0x00400000 to PAGE_SIZE
      parisc: fix epoll_pwait syscall on compat kernel

Ilya Dryomov (1):
      rbd: fix error paths in rbd_img_request_fill()

Ivan Vecera (1):
      tg3: update rx_jumbo_pending ring param only when jumbo frames are en=
abled

James Bottomley (2):
      scsi: fix our current target reap infrastructure
      SCSI: dual scan thread bug fix

Jani Nikula (2):
      drm/i915: restore QUIRK_NO_PCH_PWM_ENABLE
      drm/i915/tv: fix gen4 composite s-video tv-out

Johan Hovold (4):
      USB: usb_wwan: fix handling of missing bulk endpoints
      Revert "USB: serial: add usbid for dell wwan card to sierra.c"
      USB: serial: fix sysfs-attribute removal deadlock
      USB: io_ti: fix firmware download on big-endian machines

John David Anglin (1):
      parisc: remove _STK_LIM_MAX override

John Fastabend (1):
      net: sched: lock imbalance in hhf qdisc

Julian Anastasov (1):
      ipv4: return valid RTA_IIF on ip route get

Karl Heiss (1):
      net: sctp: Don't transition to PF state when transport has exhausted =
'Path.Max.Retrans'.

Kirill A. Shutemov (1):
      thp: close race between split and zap huge pages

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

Marek Lindner (1):
      batman-adv: fix indirect hard_iface NULL dereference

Mathias Krause (1):
      filter: prevent nla extensions to peek beyond the end of the message

Mel Gorman (1):
      mm: use paravirt friendly ops for NUMA hinting ptes

Michael Ulbricht (1):
      USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM dr=
iver

Michele Baldessari (1):
      USB: serial: ftdi_sio: add id for Brainboxes serial cards

Mizuma, Masayoshi (1):
      mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()

NeilBrown (1):
      md/raid1: r1buf_pool_alloc: free allocate pages when subsequent alloc=
ation fails.

Nicolas Dichtel (3):
      gre: don't allow to add the same tunnel twice
      vti: don't allow to add the same tunnel twice
      ip6_gre: don't allow to remove the fb_tunnel_dev

Nikolay Aleksandrov (2):
      sfc: fix calling of free_irq with already free vector
      bonding: fix out of range parameters for bond_intmax_tbl

Oliver Hartkopp (1):
      slip: fix spinlock variant

Pablo Neira Ayuso (1):
      netfilter: nf_tables: set names cannot be larger than 15 bytes

Patrick McHardy (1):
      netfilter: nf_tables: fix nft_cmp_fast failure on big endian for size=
 < 4

Peter Christensen (1):
      macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.

Peter Foley (1):
      init/Kconfig: move the trusted keyring config option to general setup

Peter Zijlstra (1):
      x86,preempt: Fix preemption for i386

Richard Guy Briggs (2):
      pid: get pid_t ppid of task in init_pid_ns
      audit: convert PPIDs to the inital PID namespace.

Roman Pen (1):
      blktrace: fix accounting of partially completed requests

Sachin Prabhu (1):
      cifs: Wait for writebacks to complete before attempting write.

Sergey Popovich (1):
      ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation

Simon Wunderlich (4):
      batman-adv: fix neigh_ifinfo imbalance
      batman-adv: fix neigh reference imbalance
      batman-adv: always run purge_orig_neighbors
      batman-adv: fix removing neigh_ifinfo

Steffen Klassert (1):
      ip_tunnel: Initialize the fallback device properly

Steven Rostedt (2):
      tools lib traceevent: Fix memory leak in pretty_print()
      drm/i915: Do not dereference pointers from ring buffer in evict event

Steven Rostedt (Red Hat) (2):
      tracepoint: Do not waste memory on mods with no tracepoints
      tracing: Use rcu_dereference_sched() for trace event triggers

Susant Sahani (1):
      ip6_tunnel: fix potential NULL pointer dereference

Thomas B=E4chler (1):
      fs: Don't return 0 from get_anon_bdev

Thomas Graf (1):
      netfilter: Can't fail and free after table replacement

Thomas Hellstrom (2):
      drm/vmwgfx: Fix query buffer locking order violation
      drm/vmwgfx: Make sure user-space can't DMA across buffer object bound=
aries v2

Thomas Richter (1):
      bonding: Remove debug_fs files when module init fails

Timo Ter=E4s (1):
      ipv4: ip_tunnels: disable cache for nbma gre tunnels

Tony Lindgren (1):
      serial: omap: Fix missing pm_runtime_resume handling by simplifying c=
ode

Toshiaki Makita (2):
      bridge: Fix double free and memory leak around br_allowed_ingress
      bridge: Handle IFLA_ADDRESS correctly when creating bridge device

Tristan Bruns (1):
      USB: cp210x: Add 8281 (Nanotec Plug & Drive)

Viresh Kumar (3):
      tick-common: Fix wrong check in tick_check_replacement()
      tick-sched: Don't call update_wall_time() when delta is lesser than t=
ick_period
      tick-sched: Check tick_nohz_enabled in tick_nohz_switch_to_nohz()

Vlad Yasevich (8):
      net: Start with correct mac_len in skb_network_protocol
      net: Find the nesting level of a given device by type.
      net: Allow for more then a single subclass for netif_addr_lock
      vlan: Fix lockdep warning with stacked vlan devices.
      macvlan: Fix lockdep warnings with stacked macvlan devices
      net: sctp: cache auth_enable per endpoint
      mactap: Fix checksum errors for non-gso packets in bridge mode
      Revert "macvlan : fix checksums error when we are in bridge mode"

Vladimir Murzin (1):
      xen/events/fifo: correctly align bitops

Wang, Xiaoming (1):
      net: ipv4: current group_info should be put after using.

Xufeng Zhang (1):
      sctp: reset flowi4_oif parameter on route lookup

Ying Cai (1):
      ip_tunnel: Set network header properly for IP_ECN_decapsulate()

dingtianhong (1):
      vlan: Fix lockdep warning when vlan dev handle notification

zhangwei(Jovi) (1):
      tracing/uprobes: Fix uprobe_cpu_buffer memory leak


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTikONAAoJEDjbvchgkmk+Uk0P/A346n00n3Zpu6dtseb5ee9/
ju2115AmG3BicDb5YdxTq/zP8skd1hTsAfQW5sHcstWEOxA0BoJ5nK6+p6nkMzRM
OuMOD13QIq9LWYUPbVB9V6TqIlB7AE7bTNGqMMS+y6LKzsh64WP3/jpYP9M6CV18
zDHTqYa2IPYtHtfzKFntYkWKWxxUeRCypDjybogR2X4+UzB2v4lPq+IGjwQx4jzT
xLXo7IVdDhr+uxkrZJMWbcYDKmxig/X5gcg3wAnCaHCHREY2pC3xXOuoYvdZD/aB
diGguz+xQTrFJU1eRhLfo6iJWnkIg/E5ImC3HLFHdTNeNhuUsc6h2+e1kS4PFN9O
BIuQcF4i6fyKQYijL/aksGAbhM6+vdXtZybJQFeiZKZ6ZSODwMMlRHLYwXtlWSE1
Tm5wQmwliByknV9SsCeeKDgCzZvOS4C0GFENzGKu7dmsb+/4tcD6msE/gA4kTeGv
BbhbME4ZuIxxhdRBPBH9KAMLRqrmBBfE5a7OMJmIcOPCfdktRdPxTVEQymql6J56
l1hLEN2wdlHs5nbCGeZ53MSN1aqHNNTclJ4sfs/zdnS1CoWZ+GF6T9OVuUEwM+Xt
5aNq5/veQBI6qR+MNsd6XDrE2NAGc+NuLaiSggk0XBmk8os9DvUp71xvsQ94KckH
nT3cDckvRa2Js4ALBJpD
=lj1P
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
