Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbaFZPG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:06:57 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64553 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbaFZPGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:06:53 -0400
Message-ID: <53AC3703.7050508@suse.cz>
Date: Thu, 26 Jun 2014 17:06:43 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
CC: lwn@lwn.net
Subject: Linux 3.12.23
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm announcing the release of the 3.12.23 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

- ----------------------------------------------------------------
Alan Stern (1):
      USB: Avoid runtime suspend loops for HCDs that can't handle
suspend/resume

Alessandro Miceli (2):
      rtl28xxu: add [1b80:d39d] Sveon STV20
      rtl28xxu: add [1b80:d3af] Sveon STV27

Alex Deucher (1):
      drm/radeon: handle non-VGA class pci devices with ATRM

Alexei Starovoitov (2):
      net: filter: fix typo in sparc BPF JIT
      net: filter: fix sparc32 typo

Alexej Starschenko (1):
      USB: serial: option: add support for Novatel E371 PCIe card

Andreas Schrägle (1):
      ahci: add PCI ID for Marvell 88SE91A0 SATA Controller

Andrey Ryabinin (2):
      ARM: 8051/1: put_user: fix possible data corruption in put_user
      mm: rmap: fix use-after-free in __put_anon_vma

Andy Lutomirski (2):
      fs,userns: Change inode_capable to capable_wrt_inode_uidgid
      auditsc: audit_krule mask accesses need bounds checking

Antti Palosaari (1):
      [media] rtl28xxu: add 15f4:0131 Astrometa DVB-T2

Ben Dooks (1):
      sh_eth: use RNC mode for packet reception

Ben Hutchings (2):
      Staging: speakup: Move pasting into a work item
      Staging: speakup: Update __speakup_paste_selection() tty
(ab)usage to match vt

Ben Skeggs (1):
      drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup

Bibek Basu (1):
      cpufreq: remove race while accessing cur_policy

Bjørn Mork (2):
      usb: cdc-wdm: export cdc-wdm uapi header
      net: qmi_wwan: add Olivetti Olicard modems

Boris BREZILLON (2):
      rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
      ARM: at91: fix at91_sysirq_mask_rtc for sam9x5 SoCs

Brian Healy (1):
      rtl28xxu: add 1b80:d395 Peak DVB-T USB

Chris Wilson (1):
      drm/i915: Only copy back the modified fields to userspace from
execbuffer

Christian König (2):
      drm/radeon: also try GART for CPU accessed buffers
      drm/radeon: avoid crash if VM command submission isn't available

Cong Wang (1):
      vxlan: use dev->needed_headroom instead of dev->hard_header_len

Dan Carpenter (1):
      qlcnic: info leak in qlcnic_dcb_peer_app_info()

Daniel Vetter (1):
      drm/i915: restrict vt-d stolen memory workaround to pre-gen8

David Woodhouse (1):
      iommu/vt-d: Fix missing IOTLB flush in intel_iommu_unmap()

Denis Turischev (1):
      xhci: Switch only Intel Lynx Point-LP ports to EHCI on shutdown.

Dmitry Kasatkin (1):
      ima: introduce ima_kernel_read()

Dmitry Popov (1):
      ipip, sit: fix ipv4_{update_pmtu,redirect} calls

Emil Goode (1):
      ARM: imx: fix error handling in ipu device registration

Eric Dumazet (3):
      net: fix inet_getid() and ipv6_select_ident() bugs
      net: force a list_del() in unregister_netdevice_many()
      ipv4: fix a race in ip4_datagram_release_cb()

Eric W. Biederman (6):
      netlink: Rename netlink_capable netlink_allowed
      net: Move the permission check in sock_diag_put_filterinfo to
packet_diag_dump
      net: Add variants of capable for use on on sockets
      net: Add variants of capable for use on netlink messages
      net: Use netlink_ns_capable to verify the permisions of netlink
messages
      netlink: Only check file credentials for implicit destinations

George McCollister (1):
      USB: ftdi_sio: add NovaTech OrionLXm product ID

Greg Kroah-Hartman (1):
      USB: cdc-wdm: properly include types.h

Heinz Mauelshagen (1):
      dm cache: always split discards on cache block boundaries

Helmut Schaa (1):
      ath9k: Fix sequence number assignment for non-data frames

Ian Abbott (1):
      staging: comedi: ni_daq_700: add mux settling delay

Igor Gnatenko (1):
      xhci: extend quirk for Renesas cards

Jan Vcelak (2):
      rtl28xxu: add USB ID for Genius TVGo DVB-T03
      rtl28xxu: add chipset version comments into device list

Jean Delvare (2):
      hwmon: (ntc_thermistor) Fix dependencies
      hwmon: (ntc_thermistor) Fix OF device ID mapping

Jiri Kosina (1):
      floppy: do not corrupt bio.bi_flags when reading block 0

Jiri Olsa (1):
      perf: Prevent false warning in perf_swevent_add

Jiri Pirko (1):
      team: fix mtu setting

Jiri Slaby (1):
      Linux 3.12.23

Joe Lawrence (1):
      SCSI: scsi_transport_sas: move bsg destructor into sas_rphy_remove

Johan Hovold (1):
      USB: io_ti: fix firmware download on big-endian machines (part 2)

Johannes Berg (1):
      Documentation: fix DOCBOOKS=... building

Justin Maggard (1):
      btrfs: fix defrag 32-bit integer overflow

Jérôme Carretero (1):
      ahci: Add Device ID for HighPoint RocketRaid 642L

Lai Jiangshan (1):
      sched: Fix hotplug vs. set_cpus_allowed_ptr()

Larry Finger (1):
      rtlwifi: rtl8192se: Fix regression due to commit 1bf4bbb

Laurent Pinchart (1):
      ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to
dpll4_m5 on all OMAP3 platforms

Markos Chandras (1):
      MIPS: asm: thread_info: Add _TIF_SECCOMP flag

Martin K. Petersen (1):
      libata: Blacklist queued trim for Crucial M500

Mathias Nyman (2):
      xhci: delete endpoints from bandwidth list before freeing whole
device
      usb: pci-quirks: Prevent Sony VAIO t-series from switching usb ports

Michael S. Tsirkin (5):
      skbuff: skb_segment: s/frag/nskb_frag/
      skbuff: skb_segment: s/skb_frag/frag/
      skbuff: skb_segment: s/skb/head_skb/
      skbuff: skb_segment: s/fskb/list_skb/
      skbuff: skb_segment: orphan frags before copying

Michael Welling (1):
      gpio: mcp23s08: Bug fix of SPI device tree registration.

Michal Schmidt (2):
      netlink: rate-limit leftover bytes warning and print process name
      rtnetlink: fix userspace API breakage for iproute2 < v3.9.0

Mimi Zohar (2):
      ima: audit log files opened with O_DIRECT flag
      evm: prohibit userspace writing 'security.evm' HMAC value

Naoya Horiguchi (1):
      mm/memory-failure.c: fix memory leak by race between poison and
unpoison

NeilBrown (2):
      md: always set MD_RECOVERY_INTR when aborting a reshape or other
"resync".
      md: always set MD_RECOVERY_INTR when interrupting a reshape thread.

Nicholas Bellinger (6):
      target: Fix NULL pointer dereference for XCOPY in
target_put_sess_cmd
      iser-target: Add missing target_put_sess_cmd for ImmedateData
failure
      target: Fix alua_access_state attribute OOPs for un-configured
devices
      iser-target: Fix multi network portal shutdown regression
      target: Allow READ_CAPACITY opcode in ALUA Standby access state
      iscsi-target: Reject mutual authentication with reflected CHAP_C

Peter Ujfalusi (1):
      ARM: omap5: hwmod_data: Correct IDLEMODE for McPDM

Peter Zijlstra (2):
      perf: Limit perf_event_attr::sample_period to 63 bits
      perf: Fix race in removing an event

Rabin Vincent (1):
      ARM: 8064/1: fix v7-M signal return

Robert Backhaus (1):
      [media] Add USB IDs for Winfast DTV Dongle Mini-D

Ronan Marquet (1):
      ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop

Sagi Grimberg (1):
      Target/iscsi,iser: Avoid accepting transport connections during
stop stage

Sebastian Ott (1):
      percpu-refcount: fix usage of this_cpu_ops

Sergei Shtylyov (1):
      sh_eth: fix SH7619/771x support

Steven Rostedt (Red Hat) (1):
      sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri
check

Takashi Iwai (2):
      ALSA: hda/analog - Fix silent output on ASUS A8JN
      ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup

Thomas Gleixner (1):
      sched: Sanitize irq accounting madness

Till Dörges (1):
      rtl28xxu: add ID [0ccd:00b4] TerraTec NOXON DAB Stick (rev 3)

Tom Gundersen (1):
      net: tunnels - enable module autoloading

Tomas Winkler (1):
      mei: me: drop harmful wait optimization

Toshiaki Makita (1):
      bridge: Prevent insertion of FDB entry with disallowed vlan

Ville Syrjälä (1):
      drm/i915: Allow user modes to exceed DVI 165MHz limit

Vlastimil Babka (3):
      mm: compaction: reset cached scanner pfn's before reading them
      mm: compaction: detect when scanners meet in isolate_freepages
      mm/compaction: make isolate_freepages start at pageblock boundary

Will Deacon (1):
      ARM: perf: hook up perf_sample_event_took around pmu irq handling

Xufeng Zhang (1):
      sctp: Fix sk_ack_backlog wrap-around problem

Yuchung Cheng (1):
      tcp: fix cwnd undo on DSACK in F-RTO

 Documentation/ABI/testing/ima_policy         |   2 +-
 Documentation/DocBook/media/Makefile         |   2 +-
 Makefile                                     |   2 +-
 arch/arm/include/asm/uaccess.h               |   3 +-
 arch/arm/kernel/entry-header.S               |   4 +
 arch/arm/kernel/perf_event.c                 |  11 +-
 arch/arm/mach-at91/sysirq_mask.c             |  22 ++--
 .../arm/mach-imx/devices/platform-ipu-core.c |   2 +-
 arch/arm/mach-omap2/cclock3xxx_data.c        |   3 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c   |   2 +-
 arch/mips/include/asm/thread_info.h          |   2 +-
 arch/sparc/net/bpf_jit_comp.c                |   8 +-
 crypto/crypto_user.c                         |   2 +-
 drivers/ata/ahci.c                           |   4 +
 drivers/ata/libata-core.c                    |   8 +-
 drivers/block/floppy.c                       |   2 +-
 drivers/connector/cn_proc.c                  |   2 +-
 drivers/cpufreq/cpufreq_governor.c           |   6 +
 drivers/gpio/gpio-mcp23s08.c                 |  11 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c   |  54 ++++----
 drivers/gpu/drm/i915/i915_gem_stolen.c       |   2 +-
 drivers/gpu/drm/i915/intel_hdmi.c            |   9 +-
 .../gpu/drm/nouveau/core/engine/disp/nvd0.c  |   2 +-
 drivers/gpu/drm/radeon/radeon_bios.c         |  14 +++
 drivers/gpu/drm/radeon/radeon_cs.c           |  15 ++-
 drivers/gpu/drm/radeon/radeon_object.c       |  38 +++---
 drivers/hwmon/Kconfig                        |   2 +-
 drivers/hwmon/ntc_thermistor.c               |  15 ++-
 drivers/infiniband/ulp/isert/ib_isert.c      |  10 ++
 drivers/iommu/intel-iommu.c                  |  18 ++-
 drivers/md/dm-cache-target.c                 |   2 +
 drivers/md/md.c                              |   5 +-
 drivers/media/dvb-core/dvb-usb-ids.h         |   4 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c      |  18 +++
 drivers/misc/mei/hw-me.c                     |   4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_dcb.c  |   1 +
 drivers/net/ethernet/renesas/sh_eth.c        |  31 +++--
 drivers/net/ethernet/renesas/sh_eth.h        |   2 -
 drivers/net/macvlan.c                        |   1 -
 drivers/net/team/team.c                      |   7 +-
 drivers/net/usb/qmi_wwan.c                   |   7 +-
 drivers/net/vxlan.c                          |   7 +-
 drivers/net/wireless/ath/ath9k/xmit.c        |   4 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |   6 +
 drivers/rtc/rtc-at91rm9200.c                 |  16 ++-
 drivers/scsi/scsi_netlink.c                  |   2 +-
 drivers/scsi/scsi_transport_sas.c            |   3 +-
 drivers/staging/comedi/drivers/ni_daq_700.c  |   2 +
 drivers/staging/speakup/main.c               |   1 +
 drivers/staging/speakup/selection.c          |  52 ++++++--
 drivers/staging/speakup/speakup.h            |   1 +
 drivers/target/iscsi/iscsi_target.c          |   1 +
 drivers/target/iscsi/iscsi_target_auth.c     |  10 ++
 drivers/target/iscsi/iscsi_target_core.h     |   1 +
 drivers/target/iscsi/iscsi_target_login.c    |   1 +
 drivers/target/iscsi/iscsi_target_tpg.c      |   2 +
 drivers/target/target_core_alua.c            |   9 ++
 drivers/target/target_core_configfs.c        |   5 +
 drivers/target/target_core_transport.c       |   4 +
 drivers/tty/tty_buffer.c                     |   2 +
 drivers/usb/core/driver.c                    |   9 +-
 drivers/usb/core/hub.c                       |  15 ++-
 drivers/usb/host/pci-quirks.c                |   7 ++
 drivers/usb/host/xhci-mem.c                  |  20 +--
 drivers/usb/host/xhci-pci.c                  |   8 +-
 drivers/usb/serial/ftdi_sio.c                |   2 +
 drivers/usb/serial/ftdi_sio_ids.h            |   5 +
 drivers/usb/serial/io_ti.c                   |   2 +-
 drivers/usb/serial/io_usbvend.h              |   2 +-
 drivers/usb/serial/option.c                  |   2 +
 fs/attr.c                                    |   8 +-
 fs/btrfs/ioctl.c                             |   6 +-
 fs/inode.c                                   |  10 +-
 fs/namei.c                                   |  11 +-
 fs/xfs/xfs_ioctl.c                           |   2 +-
 include/linux/capability.h                   |   2 +-
 include/linux/if_team.h                      |   1 +
 include/linux/netlink.h                      |  14 ++-
 include/linux/percpu-refcount.h              |   6 +-
 include/linux/sock_diag.h                    |   2 +-
 include/net/inetpeer.h                       |   9 +-
 include/net/sock.h                           |   5 +
 include/uapi/linux/usb/Kbuild                |   1 +
 include/uapi/linux/usb/cdc-wdm.h             |   2 +
 kernel/audit.c                               |   4 +-
 kernel/auditsc.c                             |  27 ++--
 kernel/capability.c                          |  20 ++-
 kernel/cpu.c                                 |   6 +-
 kernel/events/core.c                         |  63 ++++++----
 kernel/sched/core.c                          |   1 -
 kernel/sched/cpupri.c                        |   3 +-
 kernel/sched/cputime.c                       |  32 ++---
 lib/nlattr.c                                 |   4 +-
 mm/compaction.c                              |  57 +++++----
 mm/memory-failure.c                          |   2 +
 mm/rmap.c                                    |   3 +-
 net/bridge/br_input.c                        |   4 +-
 net/bridge/br_private.h                      |   7 ++
 net/bridge/br_vlan.c                         |  28 +++++
 net/can/gw.c                                 |   4 +-
 net/core/dev.c                               |   5 +-
 net/core/rtnetlink.c                         |  43 ++++---
 net/core/skbuff.c                            | 109 +++++++++--------
 net/core/sock.c                              |  49 ++++++++
 net/core/sock_diag.c                         |   4 +-
 net/dcb/dcbnl.c                              |   2 +-
 net/decnet/dn_dev.c                          |   4 +-
 net/decnet/dn_fib.c                          |   4 +-
 net/decnet/netfilter/dn_rtmsg.c              |   2 +-
 net/ipv4/datagram.c                          |  20 ++-
 net/ipv4/ipip.c                              |   5 +-
 net/ipv4/tcp_input.c                         |  11 +-
 net/ipv6/ip6_tunnel.c                        |   1 +
 net/ipv6/output_core.c                       |  11 +-
 net/ipv6/sit.c                               |   5 +-
 net/mac80211/iface.c                         |   1 -
 net/netfilter/nfnetlink.c                    |   2 +-
 net/netlink/af_netlink.c                     |  80 +++++++++++-
 net/netlink/genetlink.c                      |   2 +-
 net/packet/diag.c                            |   7 +-
 net/phonet/pn_netlink.c                      |   8 +-
 net/sched/act_api.c                          |   2 +-
 net/sched/cls_api.c                          |   2 +-
 net/sched/sch_api.c                          |   6 +-
 net/sctp/associola.c                         |   2 +-
 net/tipc/netlink.c                           |   2 +-
 net/xfrm/xfrm_user.c                         |   2 +-
 security/integrity/evm/evm_main.c            |  12 +-
 security/integrity/ima/ima_api.c             |   9 +-
 security/integrity/ima/ima_crypto.c          |  32 ++++-
 security/integrity/ima/ima_main.c            |   5 +-
 security/integrity/ima/ima_policy.c          |   6 +-
 security/integrity/integrity.h               |   1 +
 sound/pci/hda/patch_analog.c                 |   1 +
 sound/pci/hda/patch_realtek.c                |  10 +-
 135 files changed, 965 insertions(+), 406 deletions(-)


thanks,
- -- 
js
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTrDcDAAoJEL0lsQQGtHBJpAYQAJYWZPSn4S5u7vuibnKVVoi+
/VIpzH7TXSMXGSjdnABVESi7Nz/627O/njt1uxE2xpZk7zfOC6rDyQWLmLFjm6ZJ
E278mum3A2/n7Y1tTJqQ9UiR8xw9g1a74Vq7oBPGfbCX1Lmb8mTdYHExFULScqZH
y1SwRzXyo/JyBlqFDJ+dv4BzMQNCTqnWbvUsMqiYARqlCa6AFVr0IddHk/pw4vuV
uPO4ogdZKyahpJi0NK6TXKuOlAQAaieO7QaCqTA8bvBD96qyKotNJWB1UnAaw+CA
0sAP2DlyFDNjeMD402Lunnh+DVynu6AIqd+x4ECU8NY9oHaYESEodUgsKI0VgIQu
g8zTy3e037oNomVYu75mTQRDAQAWFcstQACoFY/J0Y8dNmgdzeu32VRs8UwxH641
suYJwVc0R2WmudqwNvOzVfJVb9VGAXo1LJyVN9ErrIZGJ2poVDVFYIXbtvMH83fW
sGJ0NIq4TKEUMJ4MzfT0hXUp4Uo6I39udafSTCF4sBCRGZkmMBGZ6vnUR/RGjU+w
eMNEA+kmpZB4pXD+r8TYygj+uGOjOo9myCYgw5PsvxtY6uJGdOvZekT84HUGWH4S
gRVYHScqZoaK5aWB+lG0bwpYvIuR7Ozh37oUmMKgdQGD13VaeHBpUrwq2oUG+4xu
z+p1FWmKoiFRpIVg7B5L
=pOLy
-----END PGP SIGNATURE-----
