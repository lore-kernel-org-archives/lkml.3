Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaGZTK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:10:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbaGZTKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:10:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/87] 3.14.14-stable review
Date: Sat, 26 Jul 2014 12:01:34 -0700
Message-Id: <20140726190214.530473925@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.14 release.
There are 87 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Jul 28 19:01:59 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.14-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.14-rc1

Anton Kolesov <Anton.Kolesov@synopsys.com>
    ARC: Implement ptrace(PTRACE_GET_THREAD_AREA)

Linus Torvalds <torvalds@linux-foundation.org>
    Don't trigger congestion wait on dirty-but-not-writeout pages

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: disable CTS to Self

Marek Vasut <marex@denx.de>
    ARM: dts: imx: Add alias for ethernet controller

Benjamin LaHaise <bcrl@kvack.org>
    aio: protect reqs_available updates from changes in interrupt handlers

Mateusz Guzik <mguzik@redhat.com>
    sched: Fix possible divide by zero in avg_atom() calculation

Peter Zijlstra <peterz@infradead.org>
    locking/mutex: Disable optimistic spinning on some architectures

Takashi Iwai <tiwai@suse.de>
    PM / sleep: Fix request_firmware() error at resume

Mike Snitzer <snitzer@redhat.com>
    dm cache metadata: do not allow the data block size to change

Mike Snitzer <snitzer@redhat.com>
    dm thin metadata: do not allow the data block size to change

Ted Juan <ted.juan@gmail.com>
    mtd: devices: elm: fix elm_context_save() and elm_context_restore() functions

Peter Zijlstra <peterz@infradead.org>
    x86, tsc: Fix cpufreq lockup

John Stultz <john.stultz@linaro.org>
    alarmtimer: Fix bug where relative alarm timers were treated as absolute

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: avoid leaking edid data

Jason Wang <jasowang@redhat.com>
    drm/qxl: return IRQ_NONE if it was not our irq

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: set default bl level to something reasonable

Tomasz Figa <t.figa@samsung.com>
    irqchip: gic: Fix core ID calculation when topology is read from DT

Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
    irqchip: gic: Add binding probe for ARM GIC400

Matthias Brugger <matthias.bgg@gmail.com>
    irqchip: gic: Add support for cortex a7 compatible string

Martin Lau <kafai@fb.com>
    ring-buffer: Fix polling on trace_pipe

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: fix Tx timeout issue

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
    perf/x86/intel: ignore CondChgd bit to avoid false NMI handling

Jiri Olsa <jolsa@redhat.com>
    perf: Do not allow optimized switch for non-cloned events

Eric Dumazet <edumazet@google.com>
    ipv4: fix buffer overflow in ip_options_compile()

Ben Hutchings <ben@decadent.org.uk>
    dns_resolver: Null-terminate the right string

Manuel Schölling <manuel.schoelling@gmx.de>
    dns_resolver: assure that dns_query() result is null-terminated

Bjørn Mork <bjorn@mork.no>
    net: huawei_cdc_ncm: add "subclass 3" devices

Sowmini Varadhan <sowmini.varadhan@oracle.com>
    sunvnet: clean up objects created in vnet_new() on vnet_exit()

Jerry Chu <hkchu@google.com>
    net-gre-gro: Fix a bug that breaks the forwarding path

Nikolay Aleksandrov <nikolay@redhat.com>
    bonding: fix ad_select module param check

Christoph Schulz <develop@kristov.de>
    net: pppoe: use correct channel MTU when using Multilink PPP

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix information leaks in ulpevent layer

Jon Paul Maloy <jon.maloy@ericsson.com>
    tipc: clear 'next'-pointer of message fragments before reassembly

Suresh Reddy <Suresh.Reddy@emulex.com>
    be2net: set EQ DB clear-intr bit in be_open()

Ben Pfaff <blp@nicira.com>
    netlink: Fix handling of error from netlink_dump().

Thomas Fitzsimmons <fitzsim@fitzsim.org>
    net: mvneta: Fix big endian issue in mvneta_txq_desc_csum()

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    net: mvneta: fix operation in 10 Mbit/s mode

Andrey Utkin <andrey.krieger.utkin@gmail.com>
    appletalk: Fix socket referencing in skb

Yuchung Cheng <ycheng@google.com>
    tcp: fix false undo corner cases

dingtianhong <dingtianhong@huawei.com>
    igmp: fix the problem when mc leave group

Loic Prylli <loicp@google.com>
    net: Fix NETDEV_CHANGE notifier usage causing spurious arp flush

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add two Sierra Wireless/Netgear devices

Bernd Wachter <bernd.wachter@jolla.com>
    net: qmi_wwan: Add ID for Telewell TW-LTE 4G v2

Edward Allcutt <edward.allcutt@openmarket.com>
    ipv4: icmp: Fix pMTU handling for rare case

Christoph Paasch <christoph.paasch@uclouvain.be>
    tcp: Fix divide by zero when pushing during tcp-repair

Eric Dumazet <edumazet@google.com>
    bnx2x: fix possible panic under memory stress

Eric Dumazet <edumazet@google.com>
    vlan: free percpu stats in device destructor

Eric Dumazet <edumazet@google.com>
    net: fix sparse warning in sk_dst_set()

Eric Dumazet <edumazet@google.com>
    ipv4: irq safe sk_dst_[re]set() and ipv4_sk_update_pmtu() fix

Eric Dumazet <edumazet@google.com>
    ipv4: fix dst race in sk_dst_get()

Wei-Chun Chao <weichunc@plumgrid.com>
    net: fix UDP tunnel GSO of frag_list GRO packets

Bjørn Mork <bjorn@mork.no>
    net: huawei_cdc_ncm: increase command buffer size

Li RongQing <roy.qing.li@gmail.com>
    8021q: fix a potential memory leak

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: check proc_dointvec result in proc_sctp_do_auth

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: propagate sysctl errors from proc_do* properly

Tyler Hall <tylerwhall@gmail.com>
    slcan: Port write_wakeup deadlock fix from slip

Tyler Hall <tylerwhall@gmail.com>
    slip: Fix deadlock in write_wakeup

Dmitry Popov <ixaphire@qrator.net>
    ip_tunnel: fix ip_tunnel_lookup

David Ertman <davidx.m.ertman@intel.com>
    e1000e: Fix SHRA register access for 82579

Hugh Dickins <hughd@google.com>
    shmem: fix splicing from a hole while it's punched

Hugh Dickins <hughd@google.com>
    shmem: fix faulting into a hole, not taking i_mutex

Hugh Dickins <hughd@google.com>
    shmem: fix faulting into a hole while it's punched

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dvm: don't enable CTS to self

Oren Givon <oren.givon@intel.com>
    iwlwifi: update the 7265 series HW IDs

Niu Yawei <yawei.niu@gmail.com>
    quota: missing lock in dqcache_shrink_scan()

Stefan Assmann <sassmann@kpanic.de>
    igb: do a reset on SR-IOV re-init if device is down

Todd Fujinaka <todd.fujinaka@intel.com>
    igb: Workaround for i210 Errata 25: Slow System Clock

Guenter Roeck <linux@roeck-us.net>
    hwmon: (adt7470) Fix writes to temperature limit registers

Axel Lin <axel.lin@ingics.com>
    hwmon: (da9052) Don't use dash in the name attribute

Axel Lin <axel.lin@ingics.com>
    hwmon: (da9055) Don't use dash in the name attribute

David Vrabel <david.vrabel@citrix.com>
    xen/balloon: set ballooned out pages as invalid in p2m

zhangwei(Jovi) <jovi.zhangwei@huawei.com>
    tracing: Add TRACE_ITER_PRINTK flag check in __trace_puts/__trace_bputs

zhangwei(Jovi) <jovi.zhangwei@huawei.com>
    tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Fix graph tracer with stack tracer on other archs

Oleg Nesterov <oleg@redhat.com>
    tracing: instance_rmdir() leaks ftrace_event_file->filter

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    iio:core: Handle error when mask type is not separate

Anand Avati <avati@redhat.com>
    fuse: ignore entry-timeout on LOOKUP_REVAL

Miklos Szeredi <mszeredi@suse.cz>
    fuse: handle large user and group ID

Miklos Szeredi <mszeredi@suse.cz>
    fuse: timeout comparison fix

Loic Poulain <loic.poulain@intel.com>
    Bluetooth: Ignore H5 non-link packets in non-active state

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: util: Fix a bug in the KVP code

Mengdong Lin <mengdong.lin@intel.com>
    ALSA: hda - initialize audio InfoFrame to be all zero

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix broken PM due to incomplete i915 initialization

Hans de Goede <hdegoede@redhat.com>
    media: gspca_pac7302: Add new usb-id for Genius i-Look 317

Abbas Raza <Abbas_Raza@mentor.com>
    usb: chipidea: udc: Disable auto ZLP generation on ep0

Gavin Guo <gavin.guo@canonical.com>
    usb: Check if port status is equal to RxDetect


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/arc/include/uapi/asm/ptrace.h              |   1 +
 arch/arc/kernel/ptrace.c                        |   4 +
 arch/arm/Kconfig                                |   1 +
 arch/arm/boot/dts/imx25.dtsi                    |   1 +
 arch/arm/boot/dts/imx27.dtsi                    |   1 +
 arch/arm/boot/dts/imx51.dtsi                    |   1 +
 arch/arm/boot/dts/imx53.dtsi                    |   1 +
 arch/arm64/Kconfig                              |   1 +
 arch/powerpc/Kconfig                            |   1 +
 arch/sparc/Kconfig                              |   1 +
 arch/x86/Kconfig                                |   1 +
 arch/x86/kernel/cpu/perf_event_intel.c          |   9 ++
 arch/x86/kernel/tsc.c                           |   4 +-
 drivers/bluetooth/hci_h5.c                      |   1 +
 drivers/gpu/drm/qxl/qxl_irq.c                   |   3 +
 drivers/gpu/drm/radeon/atombios_encoders.c      |  10 +-
 drivers/gpu/drm/radeon/radeon_display.c         |   5 +
 drivers/hv/hv_kvp.c                             |  14 ++-
 drivers/hv/hv_util.c                            |   2 +-
 drivers/hwmon/adt7470.c                         |   6 +-
 drivers/hwmon/da9052-hwmon.c                    |   2 +-
 drivers/hwmon/da9055-hwmon.c                    |   2 +-
 drivers/iio/industrialio-event.c                |   3 +
 drivers/irqchip/irq-gic.c                       |   7 +-
 drivers/md/dm-cache-metadata.c                  |   9 ++
 drivers/md/dm-thin-metadata.c                   |   9 ++
 drivers/media/usb/gspca/pac7302.c               |   1 +
 drivers/mtd/devices/elm.c                       |   2 +
 drivers/net/bonding/bond_main.c                 |   2 +-
 drivers/net/can/slcan.c                         |  41 +++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |   3 +-
 drivers/net/ethernet/emulex/benet/be_main.c     |   2 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c     |   2 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.h     |   2 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c    |   7 ++
 drivers/net/ethernet/intel/igb/e1000_defines.h  |  18 ++--
 drivers/net/ethernet/intel/igb/e1000_hw.h       |   3 +
 drivers/net/ethernet/intel/igb/e1000_i210.c     |  66 +++++++++++++
 drivers/net/ethernet/intel/igb/e1000_i210.h     |  12 +++
 drivers/net/ethernet/intel/igb/e1000_regs.h     |   1 +
 drivers/net/ethernet/intel/igb/igb_main.c       |  16 ++++
 drivers/net/ethernet/marvell/mvneta.c           |   4 +-
 drivers/net/ethernet/sun/sunvnet.c              |  20 +++-
 drivers/net/ppp/pppoe.c                         |   2 +-
 drivers/net/slip/slip.c                         |  36 +++++--
 drivers/net/slip/slip.h                         |   1 +
 drivers/net/usb/huawei_cdc_ncm.c                |  10 +-
 drivers/net/usb/qmi_wwan.c                      |   3 +
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |  12 ---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c     |   8 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c         |   3 +-
 drivers/net/wireless/mwifiex/main.c             |   1 +
 drivers/usb/chipidea/udc.c                      |   4 +-
 drivers/usb/core/hub.c                          |  19 ++++
 drivers/xen/balloon.c                           |  12 +--
 fs/aio.c                                        |   7 ++
 fs/fuse/dir.c                                   |   7 +-
 fs/fuse/inode.c                                 |  20 +++-
 fs/quota/dquot.c                                |   2 +
 include/net/sock.h                              |  16 ++--
 kernel/Kconfig.locks                            |   5 +-
 kernel/events/core.c                            |   2 +-
 kernel/power/process.c                          |   1 +
 kernel/sched/debug.c                            |   2 +-
 kernel/time/alarmtimer.c                        |  20 +++-
 kernel/trace/ftrace.c                           |   4 +-
 kernel/trace/ring_buffer.c                      |   4 -
 kernel/trace/trace.c                            |  18 +++-
 kernel/trace/trace_events.c                     |   1 +
 mm/shmem.c                                      | 104 +++++++++++++++++---
 mm/vmscan.c                                     |  11 +--
 net/8021q/vlan_core.c                           |   5 +-
 net/8021q/vlan_dev.c                            |  13 ++-
 net/appletalk/ddp.c                             |   3 -
 net/core/dev.c                                  |  11 ++-
 net/core/dst.c                                  |  16 +++-
 net/core/skbuff.c                               |   3 +-
 net/dns_resolver/dns_query.c                    |   4 +-
 net/ipv4/af_inet.c                              |   3 +
 net/ipv4/gre_offload.c                          |   3 +
 net/ipv4/icmp.c                                 |   2 -
 net/ipv4/igmp.c                                 |  10 +-
 net/ipv4/ip_options.c                           |   4 +
 net/ipv4/ip_tunnel.c                            |  26 ++---
 net/ipv4/route.c                                |  15 +--
 net/ipv4/tcp.c                                  |   3 +-
 net/ipv4/tcp_input.c                            |  10 +-
 net/ipv4/tcp_offload.c                          |   2 +-
 net/ipv4/tcp_output.c                           |   6 +-
 net/ipv6/tcpv6_offload.c                        |   2 +-
 net/netlink/af_netlink.c                        |   4 +-
 net/sctp/sysctl.c                               |  46 ++++-----
 net/sctp/ulpevent.c                             | 122 +++---------------------
 net/tipc/bcast.c                                |   1 +
 sound/pci/hda/hda_intel.c                       |  10 +-
 sound/pci/hda/patch_hdmi.c                      |   1 +
 97 files changed, 647 insertions(+), 319 deletions(-)


