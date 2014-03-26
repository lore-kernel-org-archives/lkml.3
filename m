Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaCZMcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:32:47 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:47199 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbaCZMcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:32:43 -0400
Message-ID: <5332C8E7.6010001@suse.cz>
Date: Wed, 26 Mar 2014 13:32:39 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
CC: lwn@lwn.net
Subject: Linux 3.12.15
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm announcing the release of the 3.12.15 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

Al Viro (1):
      ocfs2 syncs the wrong range...

Ales Novak (1):
      SCSI: storvsc: NULL pointer dereference fix

Alex Deucher (8):
      drm/radeon/atom: select the proper number of lanes in
transmitter setup
      drm/radeon/dpm: fix typo in
EVERGREEN_SMC_FIRMWARE_HEADER_softRegisters
      drm/radeon: re-order firmware loading in preparation for dpm rework
      drm/radeon/cik: properly set sdma ring status on disable
      drm/radeon/cik: stop the sdma engines in the enable() function
      drm/radeon/cik: properly set compute ring status on disable
      drm/radeon: fix minor typos in si_dpm.c
      drm/radeon/si: fix typo in dpm sq ramping setup

Alexandre Bounine (1):
      rapidio/tsi721: fix tasklet termination in dma channel release

Amitkumar Karwar (4):
      mwifiex: add NULL check for PCIe Rx skb
      mwifiex: fix cmd and Tx data timeout issue for PCIe cards
      mwifiex: copy AP's HT capability info correctly
      mwifiex: save and copy AP's VHT capability info correctly

Anssi Hannula (6):
      ALSA: hda - hdmi: Fix incorrect default channel mapping for
unusual CAs
      ALSA: hda - hdmi: Fix programmed active channel count
      ALSA: hda - hdmi: Fix unused slots being enabled in manual and
non-PCM mappings
      ALSA: hda - hdmi: Fix channel maps with less common speakers
      ALSA: hda - hdmi: Fix available channel maps missing from TLV
      ALSA: hda - hdmi: Tweak debug messages to be more useful

Anton Blanchard (2):
      powerpc: Align p_dyn, p_rela and p_st symbols
      net: unix socket code abuses csum_partial

Arnd Bergmann (1):
      vmxnet3: fix building without CONFIG_PCI_MSI

Artem Fetishev (1):
      fs/proc/base.c: fix GPF in /proc/$PID/map_files

Avinash Patil (1):
      mwifiex: clean pcie ring only when device is present

Axel Lin (2):
      spi: coldfire-qspi: Fix getting correct address for *mcfqspi
      spi: fsl-dspi: Fix getting correct address for master

Benjamin Herrenschmidt (1):
      powerpc: Fix fatal SLB miss when restoring PPR

Bing Zhao (1):
      mwifiex: do not advertise usb autosuspend support

Bjorn Helgaas (2):
      PCI: Drop warning about drivers that don't use pci_set_master()
      PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X
not enabled

Chad Dupuis (1):
      SCSI: qla2xxx: Fix multiqueue MSI-X registration.

Chen-Yu Tsai (1):
      pinctrl: sunxi: use chained_irq_{enter, exit} for GIC compatibility

Chuansheng Liu (1):
      genirq: Remove racy waitqueue_active check

Clemens Ladisch (1):
      ALSA: hda: add device IDs for AMD Evergreen/Northern Islands HDMI

Dan Williams (1):
      SCSI: isci: fix reset timeout handling

Daniel Borkmann (1):
      net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH
capable

Daniel J Blueman (1):
      x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

David Henningsson (1):
      ALSA: hda - Explicitly keep codec powered up in hdmi_present_sense

Duan Jiong (1):
      neigh: recompute reachabletime before returning from
neigh_periodic_work()

Edward Cree (1):
      sfc: check for NULL efx->ptp_data in efx_ptp_event

Emmanuel Grumbach (3):
      mac80211: fix AP powersave TX vs. wakeup race
      iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails
      iwlwifi: disable TX AMPDU by default for iwldvm

Eric Dumazet (1):
      net-tcp: fastopen: fix high order allocations

Felipe Contreras (1):
      ACPI: update win8 OSI blacklist

Felix Fietkau (3):
      mac80211: send control port protocol frames to the VO queue
      ath9k: fix ps-poll responses under a-mpdu sessions
      ath9k: fix invalid descriptor discarding

Fernando Luis Vazquez Cao (1):
      tun: remove bogus hardware vlan acceleration flags from
vlan_features

Filipe Brandenburger (1):
      memcg: reparent charges of children before processing parent

Florian Westphal (2):
      tcp: syncookies: reduce cookie lifetime to 128 seconds
      tcp: syncookies: reduce mss table to four values

Gabor Juhos (1):
      spi: spi-ath79: fix initial GPIO CS line setup

George McCollister (1):
      sched: Fix double normalization of vruntime

Gerald Schaefer (1):
      s390/appldata: restore missing init_virt_timer()

Giridhar Malavali (1):
      SCSI: qla2xxx: Poll during initialization for ISP25xx and ISP83xx

H. Peter Anvin (1):
      x86: Ignore NMIs that come in during early boot

Hannes Frederic Sowa (1):
      ipv6: reuse ip6_frag_id from ip6_ufo_append_data

Hans Schillstrom (1):
      ipv6: ipv6_find_hdr restore prev functionality

Heinz Mauelshagen (2):
      dm cache: fix truncation bug when copying a block to/from >2TB
fast device
      dm cache: fix access beyond end of origin device

Hendrik Brueckner (1):
      s390/3270: fix missing device_destroy() call

Huang Rui (3):
      usb: pci-quirks: refactor AMD quirk to abstract AMD chipset types
      usb: ehci: use amd_chipset_type to filter for usb subsystem hang bug
      usb: ohci: use amd_chipset_type to filter for SB800 prefetch

Hugh Dickins (1):
      memcg: fix endless loop in __mem_cgroup_iter_next()

Imre Deak (1):
      drm/i915: fix pch pci device enumeration

James Bates (1):
      efifb: prevent null-deref when iterating dmi_list

James Ralston (1):
      ALSA: hda - Add Device IDs for Intel Wildcat Point-LP PCH

Jan Kara (2):
      blktrace: Send BLK_TN_PROCESS events to all running traces
      ocfs2: fix quota file corruption

Jason Baron (3):
      epoll: optimize EPOLL_CTL_DEL using rcu
      epoll: do not take global 'epmutex' for simple topologies
      epoll: do not take the nested ep->mtx on EPOLL_CTL_DEL

Jason Wang (1):
      virtio-net: alloc big buffers also when guest can receive UFO

Jean Delvare (1):
      x86_pkg_temp_thermal: Do not expose as a hwmon device

Jiri Slaby (2):
      x86/dumpstack: Fix printk_address for direct addresses
      Linux 3.12.15

Joe Thornber (1):
      dm space map metadata: fix refcount decrement below 0 which
caused corruption

Johannes Berg (4):
      mac80211: don't validate unchanged AP bandwidth while tracking
      mac80211: fix association to 20/40 MHz VHT networks
      mac80211: clear sequence/fragment number in QoS-null frames
      iwlwifi: fix TX status for aggregated packets

Johannes Weiner (1):
      mm: page_alloc: exempt GFP_THISNODE allocations from zone fairness

Julius Werner (2):
      usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e
      usb: Make DELAY_INIT quirk wait 100ms between Get Configuration
requests

Kieran Clancy (1):
      ACPI / EC: Clear stale EC events on Samsung systems

Laura Abbott (1):
      mm/compaction: break out of loop on !PageBuddy in
isolate_freepages_block

Lauri Kasanen (1):
      drm/radeon: TTM must be init with cpu-visible VRAM, v2

Li Zefan (2):
      cpuset: fix a locking issue in cpuset_migrate_mm()
      cpuset: fix a race condition in __cpuset_node_allowed_softwall()

Linus Torvalds (2):
      futex: move user address verification up to common code
      x86: fix compile error due to X86_TRAP_NMI use in asm files

Linus Walleij (1):
      ARM: 7991/1: sa1100: fix compile problem on Collie

Lukasz Dorau (1):
      SCSI: isci: correct erroneous for_each_isci_host macro

Marc Kleine-Budde (5):
      can: flexcan: fix shutdown: first disable chip, then all interrupts
      can: flexcan: flexcan_open(): fix error path if
flexcan_chip_start() fails
      can: flexcan: fix transition from and to low power mode in
chip_{en,dis}able
      can: flexcan: factor out transceiver {en,dis}able into seperate
functions
      can: flexcan: flexcan_remove(): add missing netif_napi_del()

Marios Andreopoulos (1):
      libata: disable queued TRIM for Crucial M500 mSATA SSDs

Marius Knaust (1):
      ALSA: hda - Added inverted digital-mic handling for Acer
TravelMate 8371

Markus Pargmann (1):
      regulator: core: Replace direct ops->enable usage

Martin Schwidefsky (2):
      s390/time,vdso: convert to the new update_vsyscall interface
      s390,time: revert direct ktime path for s390 clockevent device

Mathias Nyman (2):
      Revert "USBNET: ax88179_178a: enable tso if usb host supports sg
dma"
      Revert "xhci 1.0: Limit arbitrarily-aligned scatter gather."

Max Stepanov (1):
      iwlwifi: mvm: change of listen interval from 70 to 10

Mel Gorman (2):
      sched: Assign correct scheduling domain to 'sd_llc'
      mm: do not walk all of system memory during show_mem

Mengdong Lin (3):
      ALSA: hda - add codec ID for Valleyview2 display codec
      ALSA: hda - not choose assigned converters for unused pins of
Valleyview
      ALSA: hda - rename function not_share_unassigned_cvt()

Michael Chan (1):
      tg3: Don't check undefined error bits in RXBD

Michael Kerrisk (1):
      ipc: Fix 2 bugs in msgrcv() MSG_COPY implementation

Michael Neuling (1):
      powerpc/tm: Fix crash when forking inside a transaction

Michal Kubecek (1):
      xfrm: prevent ipcomp scratch buffer race condition

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate
Momentus SpinPoint M8 (2BA30001)

Minchan Kim (1):
      zram: avoid null access when fail to alloc meta

Neil Horman (1):
      vmxnet3: fix netpoll race condition

NeilBrown (1):
      SUNRPC: close a rare race in xs_tcp_setup_socket.

Nicholas Bellinger (6):
      iscsi/iser-target: Use list_del_init for ->i_conn_node
      iscsi/iser-target: Fix isert_conn->state hung shutdown issues
      iser-target: Ignore completions for FRWRs in isert_cq_tx_work
      iser-target: Fix post_send_buf_count for RDMA READ/WRITE
      iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug
      bio-integrity: Fix bio_integrity_verify segment start bug

Oleg Drokin (1):
      Fix mountpoint reference leakage in linkat

Paul E. McKenney (2):
      rcu: Throttle invoke_rcu_core() invocations due to non-lazy
callbacks
      rcu: Throttle rcu_try_advance_all_cbs() execution

Peter Zijlstra (3):
      sched: Avoid NULL dereference on sd_busy
      sched: Initialize power_orig for overlapping groups
      sched/rt: Add missing rmb()

Philippe De Muyter (1):
      spi: spi-imx: spi_imx_remove: do not disable disabled clocks

Preeti U Murthy (1):
      sched: Remove unnecessary iteration over sched domains to update
nr_busy_cpus

Qais Yousef (1):
      MIPS: include linux/types.h

Radim Krčmář (1):
      KVM: SVM: fix cr8 intercept window

Rafael J. Wysocki (1):
      ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states

Richard Weinberger (1):
      i2c: Remove usage of orphaned symbol OF_I2C

Rob Clark (1):
      drm/ttm: don't oops if no invalidate_caches()

Roman Volkov (2):
      ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2
      ALSA: oxygen: modify adjust_dg_dac_routing function

Shawn Bohrer (1):
      sched/rt: Remove redundant nr_cpus_allowed test

Stanislaw Gruszka (1):
      ath9k: protect tid->sched check

Stefan Richter (2):
      firewire: net: fix use after free
      firewire: ohci: fix probe failure with Agere/LSI controllers

Steve Capper (1):
      arm64: mm: Add double logical invert to pte accessors

Steven Rostedt (Red Hat) (1):
      tracing: Do not add event files for modules that fail tracepoints

Sujith Manoharan (1):
      ath9k: Fix ETSI compliance for AR9462 2.0

Suresh Siddha (1):
      x86, fpu: Check tsk_used_math() in kernel_fpu_end() for eager FPU

Takashi Iwai (8):
      ALSA: hda - Fix possible races in HDMI driver
      ALSA: hda - Move mutex from hda_eld to per_pin in HDMI codec driver
      ALSA: hda - Fix typos in patch_hdmi.c
      ALSA: hda - Name Haswell HDMI controllers better
      ALSA: hda - Delay HDMI presence reports while waiting for ELD
information
      ALSA: usb-audio: Add quirk for Logitech Webcam C500
      ALSA: hda - Add missing loopback merge path for AD1884/1984 codecs
      ALSA: hda - Fix loud click noise with IdeaPad 410Y

Tejun Heo (2):
      firewire: don't use PREPARE_DELAYED_WORK
      libata: use wider match for blacklisting Crucial M500

Thomas Gleixner (2):
      nohz: Fix another inconsistency between CONFIG_NO_HZ=n and nohz=off
      NOHZ: Check for nohz active instead of nohz enabled

Toshiaki Makita (1):
      veth: Fix vlan_features so as to be able to use stacked vlan
interfaces

Trond Myklebust (2):
      NFS: Fix a delegation callback race
      NFSv4: nfs4_stateid_is_current should return 'true' for an
invalid stateid

Vaidyanathan Srinivasan (1):
      sched: Fix asymmetric scheduling for POWER7

Ville Syrjälä (1):
      drm/i915: Reject >165MHz modes w/ DVI monitors

Vlastimil Babka (1):
      mm: include VM_MIXEDMAP flag in the VM_SPECIAL list to avoid
m(un)locking

Waiman Long (2):
      SELinux: Reduce overhead of mls_level_isvalid() function call
      SELinux: Increase ebitmap_node size for 64-bit configuration

Xin Long (1):
      ip_tunnel:multicast process cause panic due to skb->_skb_refdst
NULL pointer

Zhang Rui (2):
      ACPI / resources: ignore invalid ACPI device resources
      PNP / ACPI: proper handling of ACPI IO/Memory resource parsing
failures

thanks,
- -- 
js
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTMsjnAAoJEL0lsQQGtHBJtBUP/0iWMdCd9RpHV7RyZTLmctAl
iGYC0u4GdHJ/rFnmcCtHRydtrVSZIOcRfVHspxpxL0E6Oo941vCsXza3IB0gfd7n
FcG7JsRJGPHQ/A4ZAfz7CTgasuUtNnXI7gFkB2p3l0MIfHtGdxWRKR9BhSu3JOCo
tTrwrQdzeAOJllMBIMCcRMPqYlZaVDhnJjz0aL+h5+R91j0VYdcwT0gSRq9e99m4
Dwd6eNTkIsFZ9qp6IIlOAN3R2l5zWJxiR8DL9X2PHwjYyg2KgtvTALoT3vLbKWlM
dcXjr1dLdeJMsa1fJf/B48VrCm1wyeZNadhJ7Y0TfeCApoVtfw3QaBw4YUkNmrXO
u2eeVkq21awCXK0dF/jRPWowy8r7o7A2f2I59hSydreuafPJpZ6DMjPhyqfb9cu8
QPk9KkX5C0YNGimTujNdI84xb1rAv8zXxNdM5W4Oq2mPORkj012yC1VV21eeojvm
evtjjl9FMl9ctfbhZ50DmXRIAXUw0qGKfQ7CtUGF/61RnNJa+EpRQWjbQcnsj2o1
YzmOOm2YewDQE7OwcDl03SrRMlLjfWbPvQeaV8zElpGwfjxtuMw7HKWX8/0r1T1Q
dHCVacZHY0s5/komifzNKlnEW5O/v0HUCws1XeBQRkQEbFyU6U5BC5WYwtR54qft
AwEQyv5x9+lo8wFS3hdx
=7RyA
-----END PGP SIGNATURE-----
