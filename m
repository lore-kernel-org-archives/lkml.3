Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbaCUADO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:03:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076AbaCUADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.13 000/149] 3.13.7-stable review
Date: Thu, 20 Mar 2014 17:02:43 -0700
Message-Id: <20140321000436.377902063@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.13.7 release.
There are 149 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Mar 23 00:03:54 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.7-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.13.7-rc1

Filipe Brandenburger <filbranden@google.com>
    memcg: reparent charges of children before processing parent

Steve Capper <steve.capper@linaro.org>
    arm64: mm: Add double logical invert to pte accessors

Nicholas Bellinger <nab@linux-iscsi.org>
    bio-integrity: Fix bio_integrity_verify segment start bug

Qais Yousef <qais.yousef@imgtec.com>
    MIPS: include linux/types.h

Oleg Drokin <green@linuxhacker.ru>
    Fix mountpoint reference leakage in linkat

Shuah Khan <shuah.kh@samsung.com>
    regulator: core: Change dummy supplies error message to a warning

Roman Volkov <v1ron@mail.ru>
    ALSA: oxygen: modify adjust_dg_dac_routing function

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: Add support for Baytrail turbo P states

Dirk Brandewie <dirk.j.brandewie@intel.com>
    intel_pstate: Add setting voltage value for baytrail P states.

Gao feng <gaofeng@cn.fujitsu.com>
    audit: don't generate loginuid log when audit disabled

Filipe David Borba Manana <fdmanana@gmail.com>
    Btrfs: fix data corruption when reading/updating compressed extents

Filipe David Borba Manana <fdmanana@gmail.com>
    Btrfs: fix tree mod logging

Filipe David Borba Manana <fdmanana@gmail.com>
    Btrfs: return immediately if tree log mod is not necessary

Suresh Siddha <sbsiddha@gmail.com>
    x86, fpu: Check tsk_used_math() in kernel_fpu_end() for eager FPU

Ales Novak <alnovak@suse.cz>
    SCSI: storvsc: NULL pointer dereference fix

Chad Dupuis <chad.dupuis@qlogic.com>
    SCSI: qla2xxx: Fix multiqueue MSI-X registration.

Giridhar Malavali <giridhar.malavali@qlogic.com>
    SCSI: qla2xxx: Poll during initialization for ISP25xx and ISP83xx

Lukasz Dorau <lukasz.dorau@intel.com>
    SCSI: isci: correct erroneous for_each_isci_host macro

Dan Williams <dan.j.williams@intel.com>
    SCSI: isci: fix reset timeout handling

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: flexcan_remove(): add missing netif_napi_del()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: factor out transceiver {en,dis}able into seperate functions

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: fix transition from and to low power mode in chip_{en,dis}able

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() fails

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: fix shutdown: first disable chip, then all interrupts

Anton Blanchard <anton@samba.org>
    net: unix socket code abuses csum_partial

Heinz Mauelshagen <heinzm@redhat.com>
    dm cache: fix access beyond end of origin device

Heinz Mauelshagen <heinzm@redhat.com>
    dm cache: fix truncation bug when copying a block to/from >2TB fast device

Joe Thornber <ejt@redhat.com>
    dm space map metadata: fix refcount decrement below 0 which caused corruption

Heinz Mauelshagen <heinzm@redhat.com>
    dm cache mq: fix memory allocation failure for large cache devices

Laura Abbott <lauraa@codeaurora.org>
    mm/compaction: break out of loop on !PageBuddy in isolate_freepages_block

Arnd Bergmann <arnd@arndb.de>
    vmxnet3: fix building without CONFIG_PCI_MSI

Neil Horman <nhorman@tuxdriver.com>
    vmxnet3: fix netpoll race condition

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled

Anton Blanchard <anton@samba.org>
    ibmveth: Fix endian issues with MAC addresses

Radim Krčmář <rkrcmar@redhat.com>
    KVM: SVM: fix cr8 intercept window

Michael Kerrisk <mtk.manpages@gmail.com>
    ipc: Fix 2 bugs in msgrcv() MSG_COPY implementation

Richard Weinberger <richard@nod.at>
    i2c: Remove usage of orphaned symbol OF_I2C

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: si476x: Fix IO setup

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: 88pm860: Fix IO setup

Patrick Lai <plai@codeaurora.org>
    ASoC: pcm: free path list before exiting from error conditions

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/si: fix typo in dpm sq ramping setup

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix minor typos in si_dpm.c

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/cik: properly set compute ring status on disable

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/cik: stop the sdma engines in the enable() function

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/cik: properly set sdma ring status on disable

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix runpm disabling on non-PX harder

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: re-order firmware loading in preparation for dpm rework

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Reject >165MHz modes w/ DVI monitors

Imre Deak <imre.deak@intel.com>
    drm/i915: fix pch pci device enumeration

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm: fix typo in EVERGREEN_SMC_FIRMWARE_HEADER_softRegisters

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: select the proper number of lanes in transmitter setup

Artem Fetishev <artem_fetishev@epam.com>
    fs/proc/base.c: fix GPF in /proc/$PID/map_files

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug

Mark Rutland <mark.rutland@arm.com>
    mm/readahead.c: fix do_readahead() for no readpage(s)

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Fix command leak for tx_desc->comp_llnode_batch

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Fix post_send_buf_count for RDMA READ/WRITE

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Ignore completions for FRWRs in isert_cq_tx_work

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi/iser-target: Fix isert_conn->state hung shutdown issues

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi/iser-target: Use list_del_init for ->i_conn_node

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Skip current frequency initialization for ->setpolicy drivers

Aaron Plattner <aplattner@nvidia.com>
    cpufreq: use cpufreq_cpu_get() to avoid cpufreq_get() race conditions

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: nfs4_stateid_is_current should return 'true' for an invalid stateid

Trond Myklebust <trond.myklebust@primarydata.com>
    NFS: Fix a delegation callback race

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix another nfs4_sequence corruptor

Gabor Juhos <juhosg@openwrt.org>
    spi: spi-ath79: fix initial GPIO CS line setup

Philippe De Muyter <phdm@macqel.be>
    spi: spi-imx: spi_imx_remove: do not disable disabled clocks

Axel Lin <axel.lin@ingics.com>
    spi: fsl-dspi: Fix getting correct address for master

Axel Lin <axel.lin@ingics.com>
    spi: coldfire-qspi: Fix getting correct address for *mcfqspi

Tejun Heo <tj@kernel.org>
    libata: use wider match for blacklisting Crucial M500

Michele Baldessari <michele@acksyn.org>
    libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001)

Marios Andreopoulos <opensource@andmarios.com>
    libata: disable queued TRIM for Crucial M500 mSATA SSDs

Tejun Heo <tj@kernel.org>
    firewire: don't use PREPARE_DELAYED_WORK

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: ohci: fix probe failure with Agere/LSI controllers

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: net: fix use after free

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Do not add event files for modules that fail tracepoints

Kieran Clancy <clancy.kieran@gmail.com>
    ACPI / EC: Clear stale EC events on Samsung systems

Zhang Rui <rui.zhang@intel.com>
    ACPI / resources: ignore invalid ACPI device resources

Li Zefan <lizefan@huawei.com>
    cpuset: fix a race condition in __cpuset_node_allowed_softwall()

Li Zefan <lizefan@huawei.com>
    cpuset: fix a locking issue in cpuset_migrate_mm()

Chuansheng Liu <chuansheng.liu@intel.com>
    genirq: Remove racy waitqueue_active check

Mathias Nyman <mathias.nyman@linux.intel.com>
    Revert "xhci 1.0: Limit arbitrarily-aligned scatter gather."

Julius Werner <jwerner@chromium.org>
    usb: Make DELAY_INIT quirk wait 100ms between Get Configuration requests

Julius Werner <jwerner@chromium.org>
    usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e

Mathias Nyman <mathias.nyman@linux.intel.com>
    Revert "USBNET: ax88179_178a: enable tso if usb host supports sg dma"

Jean Delvare <jdelvare@suse.de>
    x86_pkg_temp_thermal: Do not expose as a hwmon device

Daniel J Blueman <daniel@numascale.com>
    x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

Linus Torvalds <torvalds@linux-foundation.org>
    x86: fix compile error due to X86_TRAP_NMI use in asm files

H. Peter Anvin <hpa@linux.intel.com>
    x86: Ignore NMIs that come in during early boot

Markus Pargmann <mpa@pengutronix.de>
    regulator: core: Replace direct ops->enable usage

Linus Walleij <linus.walleij@linaro.org>
    ARM: 7991/1: sa1100: fix compile problem on Collie

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: fix noMMU kallsyms symbol filtering

Russell King <rmk+kernel@arm.linux.org.uk>
    DRM: armada: fix use of kfifo_put()

Anton Blanchard <anton@samba.org>
    powerpc: Align p_dyn, p_rela and p_st symbols

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix crash when forking inside a transaction

Chen-Yu Tsai <wens@csie.org>
    pinctrl: sunxi: use chained_irq_{enter, exit} for GIC compatibility

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix loud click noise with IdeaPad 410Y

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Use analog beep for Thinkpads with AD1984 codecs

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add missing loopback merge path for AD1884/1984 codecs

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - add automute fix for another dell AIO model

Marius Knaust <marius.knaust@gmail.com>
    ALSA: hda - Added inverted digital-mic handling for Acer TravelMate 8371

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add quirk for Logitech Webcam C500

Roman Volkov <v1ron@mail.ru>
    ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2

Rob Clark <rclark@redhat.com>
    drm/ttm: don't oops if no invalidate_caches()

Lauri Kasanen <cand@gmx.com>
    drm/radeon: TTM must be init with cpu-visible VRAM, v2

Ben Hutchings <ben@decadent.org.uk>
    perf trace: Decode architecture-specific signal numbers

Vineet Gupta <vgupta@synopsys.com>
    ARC: Use correct PTAG register for icache flush

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: save and copy AP's VHT capability info correctly

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: copy AP's HT capability info correctly

Bing Zhao <bzhao@marvell.com>
    mwifiex: do not advertise usb autosuspend support

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: fix cmd and Tx data timeout issue for PCIe cards

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: add NULL check for PCIe Rx skb

Avinash Patil <patila@marvell.com>
    mwifiex: clean pcie ring only when device is present

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: disable TX AMPDU by default for iwldvm

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: don't WARN when statistics are handled late

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fix TX status for aggregated packets

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails

Max Stepanov <Max.Stepanov@intel.com>
    iwlwifi: mvm: change of listen interval from 70 to 10

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix invalid descriptor discarding

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix ps-poll responses under a-mpdu sessions

Stanislaw Gruszka <sgruszka@redhat.com>
    ath9k: protect tid->sched check

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Fix ETSI compliance for AR9462 2.0

Johannes Berg <johannes.berg@intel.com>
    mac80211: clear sequence/fragment number in QoS-null frames

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix association to 20/40 MHz VHT networks

Johannes Berg <johannes.berg@intel.com>
    mac80211: don't validate unchanged AP bandwidth while tracking

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    mac80211: fix AP powersave TX vs. wakeup race

Felix Fietkau <nbd@openwrt.org>
    mac80211: send control port protocol frames to the VO queue

Vlad Yasevich <vyasevic@redhat.com>
    macvlan: Add support for 'always_on' offload features

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH capable

Xin Long <lucien.xin@gmail.com>
    ip_tunnel:multicast process cause panic due to skb->_skb_refdst NULL pointer

Michael Chan <mchan@broadcom.com>
    tg3: Don't check undefined error bits in RXBD

Hans Schillstrom <hans@schillstrom.com>
    ipv6: ipv6_find_hdr restore prev functionality

Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
    sch_tbf: Fix potential memory leak in tbf_change().

Edward Cree <ecree@solarflare.com>
    sfc: check for NULL efx->ptp_data in efx_ptp_event

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv4: ipv6: better estimate tunnel header cut for correct ufo handling

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: reuse ip6_frag_id from ip6_ufo_append_data

Jason Wang <jasowang@redhat.com>
    virtio-net: alloc big buffers also when guest can receive UFO

Duan Jiong <duanj.fnst@cn.fujitsu.com>
    neigh: recompute reachabletime before returning from neigh_periodic_work()

Eric Dumazet <edumazet@google.com>
    net-tcp: fastopen: fix high order allocations

Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
    tun: remove bogus hardware vlan acceleration flags from vlan_features

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
    veth: Fix vlan_features so as to be able to use stacked vlan interfaces

Alexandre Bounine <alexandre.bounine@idt.com>
    rapidio/tsi721: fix tasklet termination in dma channel release

George McCollister <george.mccollister@gmail.com>
    sched: Fix double normalization of vruntime

Hugh Dickins <hughd@google.com>
    memcg: fix endless loop in __mem_cgroup_iter_next()

Al Viro <viro@zeniv.linux.org.uk>
    ocfs2 syncs the wrong range...

Jan Kara <jack@suse.cz>
    ocfs2: fix quota file corruption

Vlastimil Babka <vbabka@suse.cz>
    mm: include VM_MIXEDMAP flag in the VM_SPECIAL list to avoid m(un)locking

Johannes Weiner <hannes@cmpxchg.org>
    mm: page_alloc: exempt GFP_THISNODE allocations from zone fairness

Minchan Kim <minchan@kernel.org>
    zram: avoid null access when fail to alloc meta


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/mm/cache_arc700.c                         |   4 +-
 arch/arm/Kconfig                                   |   2 +
 arch/arm/include/asm/memory.h                      |   9 +-
 arch/arm/mach-sa1100/include/mach/collie.h         |   2 +
 arch/arm64/include/asm/pgtable.h                   |   8 +-
 arch/mips/include/asm/mipsregs.h                   |   1 +
 arch/powerpc/kernel/process.c                      |   9 +
 arch/powerpc/kernel/reloc_64.S                     |   1 +
 arch/x86/kernel/head_32.S                          |   7 +-
 arch/x86/kernel/head_64.S                          |   6 +-
 arch/x86/kernel/i387.c                             |  15 +-
 arch/x86/kernel/quirks.c                           |   2 +-
 arch/x86/kvm/svm.c                                 |   6 +-
 drivers/acpi/ec.c                                  |  64 ++++
 drivers/acpi/resource.c                            |  10 +
 drivers/acpi/sleep.c                               |  32 +-
 drivers/ata/libata-core.c                          |   3 +-
 drivers/cpufreq/cpufreq.c                          |  25 +-
 drivers/cpufreq/intel_pstate.c                     |  71 +++-
 drivers/firewire/core-device.c                     |  22 +-
 drivers/firewire/net.c                             |   6 +-
 drivers/firewire/ohci.c                            |  15 +-
 drivers/firewire/sbp2.c                            |  17 +-
 drivers/gpu/drm/armada/armada_drv.c                |  10 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  23 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |   6 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   2 +-
 drivers/gpu/drm/radeon/cik.c                       |  47 +--
 drivers/gpu/drm/radeon/cik_sdma.c                  |  14 +-
 drivers/gpu/drm/radeon/evergreen.c                 |  33 +-
 drivers/gpu/drm/radeon/evergreen_smc.h             |   2 +-
 drivers/gpu/drm/radeon/ni.c                        |  36 +-
 drivers/gpu/drm/radeon/r600.c                      |  16 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |  10 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   3 +
 drivers/gpu/drm/radeon/rv770.c                     |  16 +-
 drivers/gpu/drm/radeon/si.c                        |  18 +-
 drivers/gpu/drm/radeon/si_dpm.c                    |   4 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   8 +-
 drivers/i2c/busses/Kconfig                         |   2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            | 180 ++++++----
 drivers/infiniband/ulp/isert/ib_isert.h            |   7 +-
 drivers/md/dm-cache-policy-mq.c                    |   4 +-
 drivers/md/dm-cache-target.c                       |  11 +-
 drivers/md/persistent-data/dm-space-map-metadata.c | 113 ++++--
 drivers/net/can/flexcan.c                          |  92 +++--
 drivers/net/ethernet/broadcom/tg3.c                |   3 +-
 drivers/net/ethernet/broadcom/tg3.h                |   6 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  25 +-
 drivers/net/ethernet/ibm/ibmveth.h                 |   1 -
 drivers/net/ethernet/sfc/ptp.c                     |   7 +
 drivers/net/macvlan.c                              |   7 +-
 drivers/net/tun.c                                  |   4 +-
 drivers/net/usb/ax88179_178a.c                     |   8 -
 drivers/net/veth.c                                 |   3 +-
 drivers/net/virtio_net.c                           |   3 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  19 +-
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |   4 +-
 drivers/net/wireless/ath/ath9k/recv.c              |  70 ++--
 drivers/net/wireless/ath/ath9k/xmit.c              |  13 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  22 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c             |   1 +
 drivers/net/wireless/iwlwifi/dvm/tx.c              |  14 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c             |   2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h       |  11 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c         |   7 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  22 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h             |   2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c              |  18 +-
 drivers/net/wireless/mwifiex/11ac.c                |   3 +-
 drivers/net/wireless/mwifiex/11n.c                 |   3 +-
 drivers/net/wireless/mwifiex/pcie.c                |  34 +-
 drivers/net/wireless/mwifiex/scan.c                |   8 +-
 drivers/net/wireless/mwifiex/usb.c                 |   8 -
 drivers/net/wireless/mwifiex/wmm.c                 |   3 +-
 drivers/pci/pci.c                                  |   3 +
 drivers/pinctrl/pinctrl-sunxi.c                    |   4 +
 drivers/rapidio/devices/tsi721.h                   |   1 +
 drivers/rapidio/devices/tsi721_dma.c               |  27 +-
 drivers/regulator/core.c                           |  16 +-
 drivers/scsi/isci/host.h                           |   5 +-
 drivers/scsi/isci/port_config.c                    |   7 -
 drivers/scsi/isci/task.c                           |   2 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   3 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  46 ++-
 drivers/scsi/storvsc_drv.c                         |   3 +
 drivers/spi/spi-ath79.c                            |   4 +-
 drivers/spi/spi-coldfire-qspi.c                    |   6 +-
 drivers/spi/spi-fsl-dspi.c                         |   6 +-
 drivers/spi/spi-imx.c                              |   4 +-
 drivers/staging/zram/zram_drv.c                    |   2 +
 drivers/target/iscsi/iscsi_target.c                |  10 +-
 drivers/target/iscsi/iscsi_target_erl2.c           |  16 +-
 drivers/target/iscsi/iscsi_target_tpg.c            |   2 +-
 drivers/thermal/x86_pkg_temp_thermal.c             |   6 +-
 drivers/usb/core/config.c                          |   4 +
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/host/xhci.c                            |  14 +-
 fs/bio-integrity.c                                 |   2 +-
 fs/btrfs/compression.c                             |   2 +
 fs/btrfs/ctree.c                                   | 387 ++++++++++++++++-----
 fs/namei.c                                         |   5 +-
 fs/nfs/delegation.c                                |  11 +-
 fs/nfs/nfs4proc.c                                  |  15 +-
 fs/ocfs2/file.c                                    |   8 +-
 fs/ocfs2/quota_global.c                            |  27 +-
 fs/ocfs2/quota_local.c                             |   4 -
 fs/proc/base.c                                     |   1 +
 include/linux/firewire.h                           |   1 +
 include/linux/mm.h                                 |   2 +-
 include/linux/nfs_xdr.h                            |   5 +
 include/linux/tracepoint.h                         |   6 +
 include/net/tcp.h                                  |   3 +-
 include/target/iscsi/iscsi_transport.h             |   1 +
 ipc/msg.c                                          |   2 +
 kernel/auditsc.c                                   |   3 +
 kernel/cpuset.c                                    |  10 +-
 kernel/irq/manage.c                                |   3 +-
 kernel/sched/fair.c                                |   8 +-
 kernel/trace/trace_events.c                        |  10 +
 kernel/tracepoint.c                                |   7 +-
 mm/compaction.c                                    |  20 +-
 mm/huge_memory.c                                   |   2 +-
 mm/memcontrol.c                                    |  19 +-
 mm/page_alloc.c                                    |  26 +-
 mm/readahead.c                                     |  15 +-
 net/core/neighbour.c                               |   6 +-
 net/ipv4/af_inet.c                                 |   7 +-
 net/ipv4/ip_tunnel_core.c                          |   1 -
 net/ipv4/tcp.c                                     |   8 +-
 net/ipv4/tcp_output.c                              |   7 +-
 net/ipv6/exthdrs_core.c                            |   2 +-
 net/ipv6/ip6_offload.c                             |  20 +-
 net/ipv6/udp_offload.c                             |   2 +-
 net/mac80211/mesh_ps.c                             |   1 +
 net/mac80211/mlme.c                                |  23 ++
 net/mac80211/sta_info.c                            |   5 +
 net/mac80211/sta_info.h                            |   7 +-
 net/mac80211/tx.c                                  |  15 +
 net/mac80211/wme.c                                 |   5 +
 net/sched/sch_tbf.c                                |  24 +-
 net/sctp/sm_statefuns.c                            |   7 +
 net/unix/af_unix.c                                 |   3 +-
 sound/pci/hda/patch_analog.c                       |   4 +
 sound/pci/hda/patch_realtek.c                      |  22 +-
 sound/pci/oxygen/xonar_dg.c                        |  12 +-
 sound/soc/codecs/88pm860x-codec.c                  |   3 +
 sound/soc/codecs/si476x.c                          |   2 +-
 sound/soc/soc-pcm.c                                |   3 +
 sound/usb/mixer.c                                  |   1 +
 tools/perf/builtin-trace.c                         |  10 +-
 152 files changed, 1575 insertions(+), 754 deletions(-)


