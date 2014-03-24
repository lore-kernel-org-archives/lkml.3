Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaCXE7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 00:59:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaCXE7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 00:59:39 -0400
Date: Sun, 23 Mar 2014 22:01:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.13.7
Message-ID: <20140324050113.GA26355@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.13.7 kernel.

All users of the 3.13 kernel series must upgrade.

The updated 3.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.13.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                             |    2=20
 arch/arc/mm/cache_arc700.c                           |    4=20
 arch/arm/Kconfig                                     |    2=20
 arch/arm/include/asm/memory.h                        |    9=20
 arch/arm/mach-sa1100/include/mach/collie.h           |    2=20
 arch/arm64/include/asm/pgtable.h                     |    8=20
 arch/mips/include/asm/mipsregs.h                     |    1=20
 arch/powerpc/kernel/process.c                        |    9=20
 arch/powerpc/kernel/reloc_64.S                       |    1=20
 arch/x86/kernel/head_32.S                            |    7=20
 arch/x86/kernel/head_64.S                            |    6=20
 arch/x86/kernel/i387.c                               |   15=20
 arch/x86/kernel/quirks.c                             |    2=20
 arch/x86/kvm/svm.c                                   |    6=20
 drivers/acpi/ec.c                                    |   64 +++
 drivers/acpi/resource.c                              |   10=20
 drivers/acpi/sleep.c                                 |   32 -
 drivers/ata/libata-core.c                            |    3=20
 drivers/cpufreq/cpufreq.c                            |   25 -
 drivers/cpufreq/intel_pstate.c                       |   71 +++
 drivers/firewire/core-device.c                       |   22 -
 drivers/firewire/net.c                               |    6=20
 drivers/firewire/ohci.c                              |   15=20
 drivers/firewire/sbp2.c                              |   17=20
 drivers/gpu/drm/armada/armada_drv.c                  |   10=20
 drivers/gpu/drm/i915/i915_drv.c                      |   23 -
 drivers/gpu/drm/i915/intel_hdmi.c                    |    6=20
 drivers/gpu/drm/radeon/atombios_encoders.c           |    2=20
 drivers/gpu/drm/radeon/cik.c                         |   47 +-
 drivers/gpu/drm/radeon/cik_sdma.c                    |   14=20
 drivers/gpu/drm/radeon/evergreen.c                   |   33 -
 drivers/gpu/drm/radeon/evergreen_smc.h               |    2=20
 drivers/gpu/drm/radeon/ni.c                          |   36 -
 drivers/gpu/drm/radeon/r600.c                        |   16=20
 drivers/gpu/drm/radeon/radeon_kms.c                  |   10=20
 drivers/gpu/drm/radeon/radeon_ttm.c                  |    3=20
 drivers/gpu/drm/radeon/rv770.c                       |   16=20
 drivers/gpu/drm/radeon/si.c                          |   18=20
 drivers/gpu/drm/radeon/si_dpm.c                      |    4=20
 drivers/gpu/drm/ttm/ttm_bo.c                         |    8=20
 drivers/i2c/busses/Kconfig                           |    2=20
 drivers/infiniband/ulp/isert/ib_isert.c              |  180 +++++---
 drivers/infiniband/ulp/isert/ib_isert.h              |    7=20
 drivers/md/dm-cache-policy-mq.c                      |    4=20
 drivers/md/dm-cache-target.c                         |   11=20
 drivers/md/persistent-data/dm-space-map-metadata.c   |  113 ++++-
 drivers/net/can/flexcan.c                            |   92 +++-
 drivers/net/ethernet/broadcom/tg3.c                  |    3=20
 drivers/net/ethernet/broadcom/tg3.h                  |    6=20
 drivers/net/ethernet/ibm/ibmveth.c                   |   25 -
 drivers/net/ethernet/ibm/ibmveth.h                   |    1=20
 drivers/net/ethernet/sfc/ptp.c                       |    7=20
 drivers/net/macvlan.c                                |    7=20
 drivers/net/tun.c                                    |    4=20
 drivers/net/usb/ax88179_178a.c                       |    8=20
 drivers/net/veth.c                                   |    3=20
 drivers/net/virtio_net.c                             |    3=20
 drivers/net/vmxnet3/vmxnet3_drv.c                    |   19=20
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h |    4=20
 drivers/net/wireless/ath/ath9k/recv.c                |   70 +--
 drivers/net/wireless/ath/ath9k/xmit.c                |   13=20
 drivers/net/wireless/iwlwifi/dvm/mac80211.c          |   22 -
 drivers/net/wireless/iwlwifi/dvm/sta.c               |    1=20
 drivers/net/wireless/iwlwifi/dvm/tx.c                |   14=20
 drivers/net/wireless/iwlwifi/iwl-drv.c               |    2=20
 drivers/net/wireless/iwlwifi/iwl-modparams.h         |   11=20
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c           |    7=20
 drivers/net/wireless/iwlwifi/mvm/mac80211.c          |   22 -
 drivers/net/wireless/iwlwifi/mvm/mvm.h               |    2=20
 drivers/net/wireless/iwlwifi/mvm/tx.c                |   18=20
 drivers/net/wireless/mwifiex/11ac.c                  |    3=20
 drivers/net/wireless/mwifiex/11n.c                   |    3=20
 drivers/net/wireless/mwifiex/pcie.c                  |   34 -
 drivers/net/wireless/mwifiex/scan.c                  |    8=20
 drivers/net/wireless/mwifiex/usb.c                   |    8=20
 drivers/net/wireless/mwifiex/wmm.c                   |    3=20
 drivers/pci/pci.c                                    |    3=20
 drivers/pinctrl/pinctrl-sunxi.c                      |    4=20
 drivers/pnp/pnpacpi/rsparser.c                       |   15=20
 drivers/rapidio/devices/tsi721.h                     |    1=20
 drivers/rapidio/devices/tsi721_dma.c                 |   27 -
 drivers/regulator/core.c                             |   16=20
 drivers/scsi/isci/host.h                             |    5=20
 drivers/scsi/isci/port_config.c                      |    7=20
 drivers/scsi/isci/task.c                             |    2=20
 drivers/scsi/qla2xxx/qla_def.h                       |    3=20
 drivers/scsi/qla2xxx/qla_isr.c                       |   46 +-
 drivers/scsi/storvsc_drv.c                           |    3=20
 drivers/spi/spi-ath79.c                              |    4=20
 drivers/spi/spi-coldfire-qspi.c                      |    6=20
 drivers/spi/spi-fsl-dspi.c                           |    6=20
 drivers/spi/spi-imx.c                                |    4=20
 drivers/staging/zram/zram_drv.c                      |    2=20
 drivers/target/iscsi/iscsi_target.c                  |   10=20
 drivers/target/iscsi/iscsi_target_erl2.c             |   16=20
 drivers/target/iscsi/iscsi_target_tpg.c              |    2=20
 drivers/thermal/x86_pkg_temp_thermal.c               |    6=20
 drivers/usb/core/config.c                            |    4=20
 drivers/usb/core/quirks.c                            |    4=20
 drivers/usb/host/xhci.c                              |   14=20
 fs/bio-integrity.c                                   |    2=20
 fs/btrfs/compression.c                               |    2=20
 fs/btrfs/ctree.c                                     |  387 ++++++++++++++=
-----
 fs/namei.c                                           |    5=20
 fs/nfs/delegation.c                                  |   11=20
 fs/nfs/nfs4proc.c                                    |   15=20
 fs/ocfs2/file.c                                      |    8=20
 fs/ocfs2/quota_global.c                              |   27 -
 fs/ocfs2/quota_local.c                               |    4=20
 fs/proc/base.c                                       |    1=20
 include/linux/firewire.h                             |    1=20
 include/linux/mm.h                                   |    2=20
 include/linux/nfs_xdr.h                              |    5=20
 include/linux/tracepoint.h                           |    6=20
 include/net/tcp.h                                    |    3=20
 include/target/iscsi/iscsi_transport.h               |    1=20
 ipc/msg.c                                            |    2=20
 kernel/auditsc.c                                     |    3=20
 kernel/cpuset.c                                      |   10=20
 kernel/irq/manage.c                                  |    3=20
 kernel/sched/fair.c                                  |    8=20
 kernel/trace/trace_events.c                          |   10=20
 kernel/tracepoint.c                                  |    7=20
 mm/compaction.c                                      |   20=20
 mm/huge_memory.c                                     |    2=20
 mm/memcontrol.c                                      |   19=20
 mm/page_alloc.c                                      |   26 +
 mm/readahead.c                                       |   15=20
 net/core/neighbour.c                                 |    6=20
 net/ipv4/af_inet.c                                   |    7=20
 net/ipv4/ip_tunnel_core.c                            |    1=20
 net/ipv4/tcp.c                                       |    8=20
 net/ipv4/tcp_output.c                                |    7=20
 net/ipv6/exthdrs_core.c                              |    2=20
 net/ipv6/ip6_offload.c                               |   20=20
 net/ipv6/udp_offload.c                               |    2=20
 net/mac80211/mesh_ps.c                               |    1=20
 net/mac80211/mlme.c                                  |   23 +
 net/mac80211/sta_info.c                              |    5=20
 net/mac80211/sta_info.h                              |    7=20
 net/mac80211/tx.c                                    |   15=20
 net/mac80211/wme.c                                   |    5=20
 net/sched/sch_tbf.c                                  |   24 -
 net/sctp/sm_statefuns.c                              |    7=20
 net/unix/af_unix.c                                   |    3=20
 sound/pci/hda/patch_analog.c                         |    4=20
 sound/pci/hda/patch_realtek.c                        |   22 +
 sound/pci/oxygen/xonar_dg.c                          |   12=20
 sound/soc/codecs/88pm860x-codec.c                    |    3=20
 sound/soc/codecs/si476x.c                            |    2=20
 sound/usb/mixer.c                                    |    1=20
 tools/perf/builtin-trace.c                           |   10=20
 152 files changed, 1583 insertions(+), 756 deletions(-)

Aaron Plattner (1):
      cpufreq: use cpufreq_cpu_get() to avoid cpufreq_get() race conditions

Al Viro (1):
      ocfs2 syncs the wrong range...

Ales Novak (1):
      SCSI: storvsc: NULL pointer dereference fix

Alex Deucher (9):
      drm/radeon/atom: select the proper number of lanes in transmitter set=
up
      drm/radeon/dpm: fix typo in EVERGREEN_SMC_FIRMWARE_HEADER_softRegiste=
rs
      drm/radeon: re-order firmware loading in preparation for dpm rework
      drm/radeon: fix runpm disabling on non-PX harder
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

Anton Blanchard (3):
      powerpc: Align p_dyn, p_rela and p_st symbols
      ibmveth: Fix endian issues with MAC addresses
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

Ben Hutchings (1):
      perf trace: Decode architecture-specific signal numbers

Bing Zhao (1):
      mwifiex: do not advertise usb autosuspend support

Bjorn Helgaas (1):
      PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not ena=
bled

Chad Dupuis (1):
      SCSI: qla2xxx: Fix multiqueue MSI-X registration.

Chen-Yu Tsai (1):
      pinctrl: sunxi: use chained_irq_{enter, exit} for GIC compatibility

Chuansheng Liu (1):
      genirq: Remove racy waitqueue_active check

Dan Williams (1):
      SCSI: isci: fix reset timeout handling

Daniel Borkmann (1):
      net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH capable

Daniel J Blueman (1):
      x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

Dirk Brandewie (2):
      intel_pstate: Add setting voltage value for baytrail P states.
      intel_pstate: Add support for Baytrail turbo P states

Duan Jiong (1):
      neigh: recompute reachabletime before returning from neigh_periodic_w=
ork()

Edward Cree (1):
      sfc: check for NULL efx->ptp_data in efx_ptp_event

Emmanuel Grumbach (4):
      mac80211: fix AP powersave TX vs. wakeup race
      iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails
      iwlwifi: mvm: don't WARN when statistics are handled late
      iwlwifi: disable TX AMPDU by default for iwldvm

Eric Dumazet (1):
      net-tcp: fastopen: fix high order allocations

Felix Fietkau (3):
      mac80211: send control port protocol frames to the VO queue
      ath9k: fix ps-poll responses under a-mpdu sessions
      ath9k: fix invalid descriptor discarding

Fernando Luis Vazquez Cao (1):
      tun: remove bogus hardware vlan acceleration flags from vlan_features

Filipe Brandenburger (1):
      memcg: reparent charges of children before processing parent

Filipe David Borba Manana (3):
      Btrfs: return immediately if tree log mod is not necessary
      Btrfs: fix tree mod logging
      Btrfs: fix data corruption when reading/updating compressed extents

Gabor Juhos (1):
      spi: spi-ath79: fix initial GPIO CS line setup

Gao feng (1):
      audit: don't generate loginuid log when audit disabled

George McCollister (1):
      sched: Fix double normalization of vruntime

Giridhar Malavali (1):
      SCSI: qla2xxx: Poll during initialization for ISP25xx and ISP83xx

Greg Kroah-Hartman (1):
      Linux 3.13.7

H. Peter Anvin (1):
      x86: Ignore NMIs that come in during early boot

Hannes Frederic Sowa (2):
      ipv6: reuse ip6_frag_id from ip6_ufo_append_data
      ipv4: ipv6: better estimate tunnel header cut for correct ufo handling

Hans Schillstrom (1):
      ipv6: ipv6_find_hdr restore prev functionality

Heinz Mauelshagen (3):
      dm cache mq: fix memory allocation failure for large cache devices
      dm cache: fix truncation bug when copying a block to/from >2TB fast d=
evice
      dm cache: fix access beyond end of origin device

Hiroaki SHIMODA (1):
      sch_tbf: Fix potential memory leak in tbf_change().

Hugh Dickins (1):
      memcg: fix endless loop in __mem_cgroup_iter_next()

Hui Wang (1):
      ALSA: hda - add automute fix for another dell AIO model

Imre Deak (1):
      drm/i915: fix pch pci device enumeration

Jan Kara (1):
      ocfs2: fix quota file corruption

Jason Wang (1):
      virtio-net: alloc big buffers also when guest can receive UFO

Jean Delvare (1):
      x86_pkg_temp_thermal: Do not expose as a hwmon device

Joe Thornber (1):
      dm space map metadata: fix refcount decrement below 0 which caused co=
rruption

Johannes Berg (4):
      mac80211: don't validate unchanged AP bandwidth while tracking
      mac80211: fix association to 20/40 MHz VHT networks
      mac80211: clear sequence/fragment number in QoS-null frames
      iwlwifi: fix TX status for aggregated packets

Johannes Weiner (1):
      mm: page_alloc: exempt GFP_THISNODE allocations from zone fairness

Julius Werner (2):
      usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e
      usb: Make DELAY_INIT quirk wait 100ms between Get Configuration reque=
sts

Kieran Clancy (1):
      ACPI / EC: Clear stale EC events on Samsung systems

Lars-Peter Clausen (2):
      ASoC: 88pm860: Fix IO setup
      ASoC: si476x: Fix IO setup

Laura Abbott (1):
      mm/compaction: break out of loop on !PageBuddy in isolate_freepages_b=
lock

Lauri Kasanen (1):
      drm/radeon: TTM must be init with cpu-visible VRAM, v2

Li Zefan (2):
      cpuset: fix a locking issue in cpuset_migrate_mm()
      cpuset: fix a race condition in __cpuset_node_allowed_softwall()

Linus Torvalds (1):
      x86: fix compile error due to X86_TRAP_NMI use in asm files

Linus Walleij (1):
      ARM: 7991/1: sa1100: fix compile problem on Collie

Lukasz Dorau (1):
      SCSI: isci: correct erroneous for_each_isci_host macro

Marc Kleine-Budde (5):
      can: flexcan: fix shutdown: first disable chip, then all interrupts
      can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() =
fails
      can: flexcan: fix transition from and to low power mode in chip_{en,d=
is}able
      can: flexcan: factor out transceiver {en,dis}able into seperate funct=
ions
      can: flexcan: flexcan_remove(): add missing netif_napi_del()

Marios Andreopoulos (1):
      libata: disable queued TRIM for Crucial M500 mSATA SSDs

Marius Knaust (1):
      ALSA: hda - Added inverted digital-mic handling for Acer TravelMate 8=
371

Mark Rutland (1):
      mm/readahead.c: fix do_readahead() for no readpage(s)

Markus Pargmann (1):
      regulator: core: Replace direct ops->enable usage

Mathias Nyman (2):
      Revert "USBNET: ax88179_178a: enable tso if usb host supports sg dma"
      Revert "xhci 1.0: Limit arbitrarily-aligned scatter gather."

Max Stepanov (1):
      iwlwifi: mvm: change of listen interval from 70 to 10

Michael Chan (1):
      tg3: Don't check undefined error bits in RXBD

Michael Kerrisk (1):
      ipc: Fix 2 bugs in msgrcv() MSG_COPY implementation

Michael Neuling (1):
      powerpc/tm: Fix crash when forking inside a transaction

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus Sp=
inPoint M8 (2BA30001)

Minchan Kim (1):
      zram: avoid null access when fail to alloc meta

Neil Horman (1):
      vmxnet3: fix netpoll race condition

Nicholas Bellinger (7):
      iscsi/iser-target: Use list_del_init for ->i_conn_node
      iscsi/iser-target: Fix isert_conn->state hung shutdown issues
      iser-target: Ignore completions for FRWRs in isert_cq_tx_work
      iser-target: Fix post_send_buf_count for RDMA READ/WRITE
      iser-target: Fix command leak for tx_desc->comp_llnode_batch
      iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug
      bio-integrity: Fix bio_integrity_verify segment start bug

Oleg Drokin (1):
      Fix mountpoint reference leakage in linkat

Philippe De Muyter (1):
      spi: spi-imx: spi_imx_remove: do not disable disabled clocks

Qais Yousef (1):
      MIPS: include linux/types.h

Radim Kr=C4=8Dm=C3=A1=C5=99 (1):
      KVM: SVM: fix cr8 intercept window

Rafael J. Wysocki (2):
      cpufreq: Skip current frequency initialization for ->setpolicy drivers
      ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states

Richard Weinberger (1):
      i2c: Remove usage of orphaned symbol OF_I2C

Rob Clark (1):
      drm/ttm: don't oops if no invalidate_caches()

Roman Volkov (2):
      ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2
      ALSA: oxygen: modify adjust_dg_dac_routing function

Russell King (2):
      DRM: armada: fix use of kfifo_put()
      ARM: fix noMMU kallsyms symbol filtering

Shuah Khan (1):
      regulator: core: Change dummy supplies error message to a warning

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

Takashi Iwai (4):
      ALSA: usb-audio: Add quirk for Logitech Webcam C500
      ALSA: hda - Add missing loopback merge path for AD1884/1984 codecs
      ALSA: hda - Use analog beep for Thinkpads with AD1984 codecs
      ALSA: hda - Fix loud click noise with IdeaPad 410Y

Tejun Heo (2):
      firewire: don't use PREPARE_DELAYED_WORK
      libata: use wider match for blacklisting Crucial M500

Toshiaki Makita (1):
      veth: Fix vlan_features so as to be able to use stacked vlan interfac=
es

Trond Myklebust (3):
      NFSv4: Fix another nfs4_sequence corruptor
      NFS: Fix a delegation callback race
      NFSv4: nfs4_stateid_is_current should return 'true' for an invalid st=
ateid

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/i915: Reject >165MHz modes w/ DVI monitors

Vineet Gupta (1):
      ARC: Use correct PTAG register for icache flush

Vlad Yasevich (1):
      macvlan: Add support for 'always_on' offload features

Vlastimil Babka (1):
      mm: include VM_MIXEDMAP flag in the VM_SPECIAL list to avoid m(un)loc=
king

Xin Long (1):
      ip_tunnel:multicast process cause panic due to skb->_skb_refdst NULL =
pointer

Zhang Rui (2):
      ACPI / resources: ignore invalid ACPI device resources
      PNP / ACPI: proper handling of ACPI IO/Memory resource parsing failur=
es


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTL7wZAAoJEDjbvchgkmk+UmIQANFAtGpg/IlUC2RWvNADVyjW
wR7vcsV9vtuCOsbO8EmSaQrsUZ3tR5pVMDjLRDb7oiojYM6s/IZV5XeKx35mgQc/
GbmrkohToM1oyula6RH4G45sRtgIodj+ae/49yCmnSB9Jic+GK2K67WH2LhtNTSv
sYzxLdp3IdP61iTM5jAQVEejlvu5SBeKdp+xoxkjwKK0K9T3kn8YXWK5d1VSOYbj
Zxq1dpninMHvoWdrNUpwRm00/OpahSH10itjYhDPdc/2CO+7fAjzAQPU/LR10Rn6
oEP/C/snXz3kndzC+gsmYqlBjs5LnSgLeqsPFWXjupwitla7hBpIUl6x6kHmxznL
T8GXPdFTg93qsaiCfNEiETdVHN6zKrEswkHZc1z6rPd/5SxKsFASn3/92QHIPExn
xvwsv9JRlbHFWKtsoj/Jv7OHZ0Hi1BQiz9PJqEmUDXR+xxowyZnpgcxUkih7Mgqs
WFk8sgsD65WskQqjNl6iiR//VenjpkeQnfIGRObHaTGimElss9QeK0A8iot8MhTr
UAZNSq1w7rW3q8EvB/9yYiSJ7MAS1mqekpjOvcKT0gYqrRz1ECLClg7Ik1kOW/wM
eTS4Mu+01JRxRSxEkSRbmKsWsacDdUgbmAo1v69lRHXf2pIrIWrbjWOx5VrZf5oq
s5hg51+EzjFbhwJyZNF3
=3eZn
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
