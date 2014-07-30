Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaG3MPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:15:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36600 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbaG3MPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 00/94] 3.12.26-stable review
Date: Wed, 30 Jul 2014 14:15:03 +0200
Message-Id: <cover.1406722269.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.26 release.
There are 94 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Aug  1 14:11:10 CEST 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.26-rc1.xz
and the diffstat can be found below.

thanks,
js

===============


Abbas Raza (1):
  usb: chipidea: udc: Disable auto ZLP generation on ep0

Alex Deucher (2):
  drm/radeon: set default bl level to something reasonable
  drm/radeon: avoid leaking edid data

Amitkumar Karwar (1):
  mwifiex: fix Tx timeout issue

Anand Avati (1):
  fuse: ignore entry-timeout on LOOKUP_REVAL

Andrey Utkin (1):
  appletalk: Fix socket referencing in skb

Andy Whitcroft (1):
  ACPI / resources: only reject zero length resources based at address
    zero

Anton Kolesov (1):
  ARC: Implement ptrace(PTRACE_GET_THREAD_AREA)

Antti Palosaari (1):
  media: tda10071: force modulation to QPSK on DVB-S

Axel Lin (2):
  hwmon: (da9055) Don't use dash in the name attribute
  hwmon: (da9052) Don't use dash in the name attribute

Ben Pfaff (1):
  netlink: Fix handling of error from netlink_dump().

Benjamin LaHaise (1):
  aio: protect reqs_available updates from changes in interrupt handlers

Bernd Wachter (1):
  net: qmi_wwan: Add ID for Telewell TW-LTE 4G v2

Bjørn Mork (1):
  net: qmi_wwan: add two Sierra Wireless/Netgear devices

Catalin Marinas (1):
  mm: kmemleak: avoid false negatives on vmalloc'ed objects

Christian König (1):
  drm/radeon: fix irq ring buffer overflow handling

Christoph Hellwig (1):
  block: don't assume last put of shared tags is for the host

Christoph Paasch (1):
  tcp: Fix divide by zero when pushing during tcp-repair

Christoph Schulz (1):
  net: pppoe: use correct channel MTU when using Multilink PPP

Daniel Borkmann (3):
  net: sctp: propagate sysctl errors from proc_do* properly
  net: sctp: check proc_dointvec result in proc_sctp_do_auth
  net: sctp: fix information leaks in ulpevent layer

Daniel Thompson (1):
  serial: sirf: Fix compilation failure

David Ertman (1):
  e1000e: Fix SHRA register access for 82579

Dmitry Popov (1):
  ip_tunnel: fix ip_tunnel_lookup

Dmitry Torokhov (1):
  Input: fix defuzzing logic

Edward Allcutt (1):
  ipv4: icmp: Fix pMTU handling for rare case

Emmanuel Grumbach (1):
  iwlwifi: dvm: don't enable CTS to self

Eric Dumazet (4):
  ipv4: fix dst race in sk_dst_get()
  ipv4: irq safe sk_dst_[re]set() and ipv4_sk_update_pmtu() fix
  bnx2x: fix possible panic under memory stress
  ipv4: fix buffer overflow in ip_options_compile()

Gavin Guo (1):
  usb: Check if port status is equal to RxDetect

Guenter Roeck (2):
  hwmon: (adt7470) Fix writes to temperature limit registers
  hwmon: (smsc47m192) Fix temperature limit and vrm write operations

HATAYAMA Daisuke (1):
  perf/x86/intel: ignore CondChgd bit to avoid false NMI handling

Hans Verkuil (1):
  media: hdpvr: fix two audio bugs

Hans de Goede (1):
  media: gspca_pac7302: Add new usb-id for Genius i-Look 317

Hugh Dickins (3):
  shmem: fix faulting into a hole while it's punched
  shmem: fix faulting into a hole, not taking i_mutex
  shmem: fix splicing from a hole while it's punched

Jason Wang (1):
  drm/qxl: return IRQ_NONE if it was not our irq

John David Anglin (1):
  parisc: Remove SA_RESTORER define

John Stultz (1):
  alarmtimer: Fix bug where relative alarm timers were treated as
    absolute

Jon Paul Maloy (1):
  tipc: clear 'next'-pointer of message fragments before reassembly

K. Y. Srinivasan (1):
  Drivers: hv: util: Fix a bug in the KVP code

Kevin Hao (1):
  libata: support the ata host which implements a queue depth less than
    32

Li RongQing (1):
  8021q: fix a potential memory leak

Linus Torvalds (2):
  Don't trigger congestion wait on dirty-but-not-writeout pages
  Fix gcc-4.9.0 miscompilation of load_balance() in scheduler

Loic Poulain (1):
  Bluetooth: Ignore H5 non-link packets in non-active state

Loic Prylli (1):
  net: Fix NETDEV_CHANGE notifier usage causing spurious arp flush

Manuel Schölling (1):
  dns_resolver: assure that dns_query() result is null-terminated

Marek Vasut (1):
  ARM: dts: imx: Add alias for ethernet controller

Martin Lau (1):
  ring-buffer: Fix polling on trace_pipe

Mateusz Guzik (1):
  sched: Fix possible divide by zero in avg_atom() calculation

Matthias Brugger (1):
  irqchip: gic: Add support for cortex a7 compatible string

Michael Brown (1):
  x86/efi: Include a .bss section within the PE/COFF headers

Mike Snitzer (2):
  dm thin metadata: do not allow the data block size to change
  dm cache metadata: do not allow the data block size to change

Miklos Szeredi (2):
  fuse: timeout comparison fix
  fuse: handle large user and group ID

Mikulas Patocka (2):
  block: provide compat ioctl for BLKZEROOUT
  slab_common: fix the check for duplicate slab names

Neal Cardwell (1):
  tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb

Niu Yawei (1):
  quota: missing lock in dqcache_shrink_scan()

Peter Zijlstra (1):
  locking/mutex: Disable optimistic spinning on some architectures

Qipan Li (1):
  serial: sirf: fix spinlock deadlock issue

Rickard Strandqvist (1):
  media: media: v4l2-core: v4l2-dv-timings.c: Cleaning up code wrong
    value used in aspect ratio

Romain Degez (1):
  ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)

Silesh C V (1):
  coredump: fix the setting of PF_DUMPCORE

Sowmini Varadhan (1):
  sunvnet: clean up objects created in vnet_new() on vnet_exit()

Stefan Assmann (1):
  igb: do a reset on SR-IOV re-init if device is down

Steven Rostedt (Red Hat) (1):
  tracing: Fix graph tracer with stack tracer on other archs

Suresh Reddy (1):
  be2net: set EQ DB clear-intr bit in be_open()

Sven Wegener (1):
  x86_32, entry: Store badsys error code in %eax

Takashi Iwai (2):
  ALSA: hda - Fix broken PM due to incomplete i915 initialization
  PM / sleep: Fix request_firmware() error at resume

Ted Juan (1):
  mtd: devices: elm: fix elm_context_save() and elm_context_restore()
    functions

Tejun Heo (1):
  blkcg: don't call into policy draining if root_blkg is already gone

Thomas Gleixner (1):
  can: c_can: Remove EOB exit

Thomas Petazzoni (1):
  net: mvneta: fix operation in 10 Mbit/s mode

Todd Fujinaka (1):
  igb: Workaround for i210 Errata 25: Slow System Clock

Tomasz Figa (1):
  irqchip: gic: Fix core ID calculation when topology is read from DT

Tony Luck (1):
  tracing: Fix wraparound problems in "uptime" trace clock

Tyler Hall (2):
  slip: Fix deadlock in write_wakeup
  slcan: Port write_wakeup deadlock fix from slip

Vasily Averin (1):
  fs: umount on symlink leaks mnt count

Wei-Chun Chao (1):
  net: fix UDP tunnel GSO of frag_list GRO packets

Yuchung Cheng (1):
  tcp: fix false undo corner cases

dingtianhong (1):
  igmp: fix the problem when mc leave group

zhangwei(Jovi) (2):
  tracing: Add ftrace_trace_stack into __trace_puts/__trace_bputs
  tracing: Add TRACE_ITER_PRINTK flag check in
    __trace_puts/__trace_bputs

 Makefile                                        |   2 +
 arch/arc/include/uapi/asm/ptrace.h              |   1 +
 arch/arc/kernel/ptrace.c                        |   4 +
 arch/arm/Kconfig                                |   1 +
 arch/arm/boot/dts/imx25.dtsi                    |   1 +
 arch/arm/boot/dts/imx27.dtsi                    |   1 +
 arch/arm/boot/dts/imx51.dtsi                    |   1 +
 arch/arm/boot/dts/imx53.dtsi                    |   1 +
 arch/arm64/Kconfig                              |   1 +
 arch/parisc/include/uapi/asm/signal.h           |   2 -
 arch/powerpc/Kconfig                            |   1 +
 arch/sparc/Kconfig                              |   1 +
 arch/x86/Kconfig                                |   1 +
 arch/x86/boot/header.S                          |  26 ++++-
 arch/x86/boot/tools/build.c                     |  37 +++++--
 arch/x86/kernel/cpu/perf_event_intel.c          |   9 ++
 arch/x86/kernel/entry_32.S                      |   9 +-
 block/blk-cgroup.c                              |   7 ++
 block/blk-tag.c                                 |  33 ++-----
 block/compat_ioctl.c                            |   1 +
 drivers/acpi/resource.c                         |  10 +-
 drivers/ata/ahci.c                              |   1 +
 drivers/ata/libata-core.c                       |  22 ++++-
 drivers/bluetooth/hci_h5.c                      |   1 +
 drivers/gpu/drm/qxl/qxl_irq.c                   |   3 +
 drivers/gpu/drm/radeon/atombios_encoders.c      |  10 +-
 drivers/gpu/drm/radeon/cik.c                    |   1 +
 drivers/gpu/drm/radeon/evergreen.c              |   1 +
 drivers/gpu/drm/radeon/r600.c                   |   1 +
 drivers/gpu/drm/radeon/radeon_display.c         |   5 +
 drivers/gpu/drm/radeon/si.c                     |   1 +
 drivers/hv/hv_kvp.c                             |  14 ++-
 drivers/hv/hv_util.c                            |   2 +-
 drivers/hwmon/adt7470.c                         |   6 +-
 drivers/hwmon/da9052-hwmon.c                    |   2 +-
 drivers/hwmon/da9055-hwmon.c                    |   2 +-
 drivers/hwmon/smsc47m192.c                      |   4 +-
 drivers/input/input.c                           |   6 +-
 drivers/irqchip/irq-gic.c                       |   6 +-
 drivers/md/dm-cache-metadata.c                  |   9 ++
 drivers/md/dm-thin-metadata.c                   |   9 ++
 drivers/media/dvb-frontends/tda10071.c          |   6 +-
 drivers/media/usb/gspca/pac7302.c               |   1 +
 drivers/media/usb/hdpvr/hdpvr-video.c           |   6 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c       |   4 +-
 drivers/mtd/devices/elm.c                       |   2 +
 drivers/net/can/c_can/c_can.c                   |   3 -
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
 drivers/net/ethernet/marvell/mvneta.c           |   2 +-
 drivers/net/ethernet/sun/sunvnet.c              |  20 +++-
 drivers/net/ppp/pppoe.c                         |   2 +-
 drivers/net/slip/slip.c                         |  36 +++++--
 drivers/net/slip/slip.h                         |   1 +
 drivers/net/usb/qmi_wwan.c                      |   3 +
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |  12 ---
 drivers/net/wireless/mwifiex/main.c             |   1 +
 drivers/tty/serial/sirfsoc_uart.c               |  49 ++++------
 drivers/tty/serial/sirfsoc_uart.h               |   2 -
 drivers/usb/chipidea/udc.c                      |   4 +-
 drivers/usb/core/hub.c                          |  19 ++++
 fs/aio.c                                        |   7 ++
 fs/coredump.c                                   |   2 +-
 fs/fuse/dir.c                                   |   7 +-
 fs/fuse/inode.c                                 |  20 +++-
 fs/namei.c                                      |   3 +-
 fs/quota/dquot.c                                |   2 +
 include/net/sock.h                              |  16 ++--
 kernel/Kconfig.locks                            |   5 +-
 kernel/power/process.c                          |   1 +
 kernel/sched/debug.c                            |   2 +-
 kernel/time/alarmtimer.c                        |  20 +++-
 kernel/trace/ftrace.c                           |   4 +-
 kernel/trace/ring_buffer.c                      |   4 -
 kernel/trace/trace.c                            |  20 +++-
 kernel/trace/trace_clock.c                      |   9 +-
 mm/kmemleak.c                                   |   4 +-
 mm/shmem.c                                      | 104 +++++++++++++++++---
 mm/slab_common.c                                |   2 +-
 mm/vmalloc.c                                    |  14 ++-
 mm/vmscan.c                                     |  11 +--
 net/8021q/vlan_core.c                           |   5 +-
 net/appletalk/ddp.c                             |   3 -
 net/core/dev.c                                  |   6 +-
 net/core/dst.c                                  |  16 +++-
 net/core/skbuff.c                               |   3 +-
 net/dns_resolver/dns_query.c                    |   4 +-
 net/ipv4/icmp.c                                 |   2 -
 net/ipv4/igmp.c                                 |  10 +-
 net/ipv4/ip_options.c                           |   4 +
 net/ipv4/ip_tunnel.c                            |  12 ++-
 net/ipv4/route.c                                |  15 +--
 net/ipv4/tcp.c                                  |   3 +-
 net/ipv4/tcp_input.c                            |  10 +-
 net/ipv4/tcp_output.c                           |   6 +-
 net/netlink/af_netlink.c                        |   4 +-
 net/sctp/sysctl.c                               |  22 ++---
 net/sctp/ulpevent.c                             | 122 +++---------------------
 net/tipc/bcast.c                                |   1 +
 sound/pci/hda/hda_intel.c                       |  10 +-
 110 files changed, 737 insertions(+), 380 deletions(-)

-- 
2.0.1

