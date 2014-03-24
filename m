Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaCXE6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 00:58:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaCXE6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 00:58:44 -0400
Date: Sun, 23 Mar 2014 22:00:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.34
Message-ID: <20140324050018.GA26149@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.34 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                             |    2=20
 arch/arm/include/asm/spinlock.h                      |    2=20
 arch/arm/kernel/setup.c                              |   30 +++-
 arch/arm/mach-sa1100/include/mach/collie.h           |    2=20
 arch/mips/include/asm/mipsregs.h                     |    1=20
 arch/powerpc/kernel/reloc_64.S                       |    1=20
 arch/x86/kernel/head_32.S                            |    7 -
 arch/x86/kernel/head_64.S                            |    6=20
 arch/x86/kernel/i387.c                               |   15 +-
 arch/x86/kernel/quirks.c                             |    2=20
 arch/x86/kvm/svm.c                                   |    6=20
 drivers/acpi/resource.c                              |   10 +
 drivers/acpi/sleep.c                                 |   32 ++--
 drivers/ata/libata-core.c                            |    1=20
 drivers/firewire/core-device.c                       |   22 ++-
 drivers/firewire/net.c                               |    6=20
 drivers/firewire/sbp2.c                              |   17 +-
 drivers/gpu/drm/radeon/atombios_encoders.c           |    2=20
 drivers/gpu/drm/ttm/ttm_bo.c                         |    8 -
 drivers/infiniband/ulp/isert/ib_isert.c              |  124 ++++++++------=
-----
 drivers/infiniband/ulp/isert/ib_isert.h              |    4=20
 drivers/md/dm-cache-target.c                         |   11 -
 drivers/net/can/flexcan.c                            |    4=20
 drivers/net/ethernet/broadcom/tg3.c                  |    3=20
 drivers/net/ethernet/broadcom/tg3.h                  |    6=20
 drivers/net/ethernet/sfc/ptp.c                       |    7 +
 drivers/net/virtio_net.c                             |    3=20
 drivers/net/vmxnet3/vmxnet3_drv.c                    |   19 ++
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h |    4=20
 drivers/net/wireless/iwlwifi/dvm/mac80211.c          |   22 +++
 drivers/net/wireless/iwlwifi/dvm/sta.c               |    1=20
 drivers/net/wireless/iwlwifi/dvm/tx.c                |   14 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c               |    2=20
 drivers/net/wireless/iwlwifi/iwl-modparams.h         |   11 +
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c           |    7 -
 drivers/net/wireless/iwlwifi/mvm/mac80211.c          |   22 +++
 drivers/net/wireless/iwlwifi/mvm/tx.c                |   18 +-
 drivers/net/wireless/mwifiex/11ac.c                  |    3=20
 drivers/net/wireless/mwifiex/11n.c                   |    3=20
 drivers/net/wireless/mwifiex/pcie.c                  |   34 ++---
 drivers/net/wireless/mwifiex/scan.c                  |    8 -
 drivers/net/wireless/mwifiex/usb.c                   |    8 -
 drivers/net/wireless/mwifiex/wmm.c                   |    3=20
 drivers/pci/pci.c                                    |    3=20
 drivers/pnp/pnpacpi/rsparser.c                       |   15 +-
 drivers/rapidio/devices/tsi721.h                     |    1=20
 drivers/rapidio/devices/tsi721_dma.c                 |   27 ++--
 drivers/regulator/core.c                             |   14 +-
 drivers/s390/block/dasd.c                            |    8 -
 drivers/scsi/isci/host.h                             |    5=20
 drivers/scsi/isci/port_config.c                      |    7 -
 drivers/scsi/isci/task.c                             |    2=20
 drivers/scsi/qla2xxx/qla_def.h                       |    3=20
 drivers/scsi/storvsc_drv.c                           |    3=20
 drivers/spi/spi-ath79.c                              |    4=20
 drivers/target/iscsi/iscsi_target.c                  |    8 -
 drivers/target/iscsi/iscsi_target_erl2.c             |   16 +-
 drivers/target/iscsi/iscsi_target_tpg.c              |    2=20
 drivers/usb/core/config.c                            |    4=20
 drivers/usb/core/quirks.c                            |    4=20
 fs/bio-integrity.c                                   |    2=20
 fs/btrfs/compression.c                               |    2=20
 fs/namei.c                                           |    1=20
 fs/nfs/delegation.c                                  |   11 +
 fs/nfs/nfs4proc.c                                    |    5=20
 fs/ocfs2/file.c                                      |    8 -
 fs/ocfs2/quota_global.c                              |   27 ++--
 fs/ocfs2/quota_local.c                               |    4=20
 fs/proc/base.c                                       |    1=20
 include/linux/firewire.h                             |    1=20
 include/linux/jiffies.h                              |    8 -
 include/linux/tracepoint.h                           |    6=20
 include/net/tcp.h                                    |    3=20
 include/target/iscsi/iscsi_transport.h               |    1=20
 ipc/msg.c                                            |    2=20
 kernel/cpuset.c                                      |    2=20
 kernel/irq/manage.c                                  |    3=20
 kernel/sched/fair.c                                  |    8 -
 kernel/time/tick-broadcast.c                         |   13 +
 kernel/trace/trace_events.c                          |   10 +
 kernel/tracepoint.c                                  |    7 -
 mm/compaction.c                                      |   20 +--
 mm/memcontrol.c                                      |   14 ++
 net/core/neighbour.c                                 |    6=20
 net/ipv4/tcp.c                                       |    8 -
 net/ipv4/tcp_output.c                                |    7 -
 net/ipv6/exthdrs_core.c                              |    2=20
 net/ipv6/udp_offload.c                               |    2=20
 net/mac80211/mesh_ps.c                               |    1=20
 net/mac80211/mlme.c                                  |   23 +++
 net/mac80211/sta_info.c                              |    5=20
 net/mac80211/sta_info.h                              |    7 -
 net/mac80211/tx.c                                    |   15 ++
 net/mac80211/wme.c                                   |    5=20
 net/sctp/sm_statefuns.c                              |    7 +
 net/unix/af_unix.c                                   |    3=20
 sound/pci/hda/patch_analog.c                         |    1=20
 sound/pci/hda/patch_realtek.c                        |    1=20
 sound/pci/oxygen/xonar_dg.c                          |   12 +
 sound/usb/mixer.c                                    |    1=20
 100 files changed, 596 insertions(+), 308 deletions(-)

Al Viro (1):
      ocfs2 syncs the wrong range...

Ales Novak (1):
      SCSI: storvsc: NULL pointer dereference fix

Alex Deucher (1):
      drm/radeon/atom: select the proper number of lanes in transmitter set=
up

Alexandre Bounine (1):
      rapidio/tsi721: fix tasklet termination in dma channel release

Amitkumar Karwar (4):
      mwifiex: add NULL check for PCIe Rx skb
      mwifiex: fix cmd and Tx data timeout issue for PCIe cards
      mwifiex: copy AP's HT capability info correctly
      mwifiex: save and copy AP's VHT capability info correctly

Anton Blanchard (2):
      powerpc: Align p_dyn, p_rela and p_st symbols
      net: unix socket code abuses csum_partial

Arnd Bergmann (1):
      vmxnet3: fix building without CONFIG_PCI_MSI

Artem Fetishev (1):
      fs/proc/base.c: fix GPF in /proc/$PID/map_files

Avinash Patil (1):
      mwifiex: clean pcie ring only when device is present

Bing Zhao (1):
      mwifiex: do not advertise usb autosuspend support

Bjorn Helgaas (1):
      PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not ena=
bled

Chuansheng Liu (1):
      genirq: Remove racy waitqueue_active check

Dan Williams (1):
      SCSI: isci: fix reset timeout handling

Daniel Borkmann (1):
      net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH capable

Daniel J Blueman (1):
      x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

Duan Jiong (1):
      neigh: recompute reachabletime before returning from neigh_periodic_w=
ork()

Edward Cree (1):
      sfc: check for NULL efx->ptp_data in efx_ptp_event

Emmanuel Grumbach (4):
      mac80211: fix AP powersave TX vs. wakeup race
      iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails
      iwlwifi: disable TX AMPDU by default for iwldvm
      iwlwifi: mvm: don't WARN when statistics are handled late

Eric Dumazet (1):
      net-tcp: fastopen: fix high order allocations

Felix Fietkau (1):
      mac80211: send control port protocol frames to the VO queue

Filipe Brandenburger (1):
      memcg: reparent charges of children before processing parent

Filipe David Borba Manana (1):
      Btrfs: fix data corruption when reading/updating compressed extents

Gabor Juhos (1):
      spi: spi-ath79: fix initial GPIO CS line setup

George McCollister (1):
      sched: Fix double normalization of vruntime

Giridhar Malavali (1):
      SCSI: qla2xxx: Poll during initialization for ISP25xx and ISP83xx

Greg Kroah-Hartman (1):
      Linux 3.10.34

H. Peter Anvin (1):
      x86: Ignore NMIs that come in during early boot

Hannes Frederic Sowa (1):
      ipv6: reuse ip6_frag_id from ip6_ufo_append_data

Hans Schillstrom (1):
      ipv6: ipv6_find_hdr restore prev functionality

Heiko Carstens (1):
      s390/dasd: hold request queue sysfs lock when calling elevator_init()

Heinz Mauelshagen (2):
      dm cache: fix truncation bug when copying a block to/from >2TB fast d=
evice
      dm cache: fix access beyond end of origin device

Jan Kara (1):
      ocfs2: fix quota file corruption

Jason Wang (1):
      virtio-net: alloc big buffers also when guest can receive UFO

Johannes Berg (4):
      mac80211: don't validate unchanged AP bandwidth while tracking
      mac80211: fix association to 20/40 MHz VHT networks
      mac80211: clear sequence/fragment number in QoS-null frames
      iwlwifi: fix TX status for aggregated packets

Julius Werner (2):
      usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e
      usb: Make DELAY_INIT quirk wait 100ms between Get Configuration reque=
sts

Laura Abbott (1):
      mm/compaction: break out of loop on !PageBuddy in isolate_freepages_b=
lock

Li Zefan (1):
      cpuset: fix a race condition in __cpuset_node_allowed_softwall()

Linus Torvalds (1):
      x86: fix compile error due to X86_TRAP_NMI use in asm files

Linus Walleij (1):
      ARM: 7991/1: sa1100: fix compile problem on Collie

Lukasz Dorau (1):
      SCSI: isci: correct erroneous for_each_isci_host macro

Magnus Damm (1):
      ARM: 7864/1: Handle 64-bit memory in case of 32-bit phys_addr_t

Marc Kleine-Budde (1):
      can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() =
fails

Marius Knaust (1):
      ALSA: hda - Added inverted digital-mic handling for Acer TravelMate 8=
371

Markus Pargmann (1):
      regulator: core: Replace direct ops->enable usage

Michael Chan (1):
      tg3: Don't check undefined error bits in RXBD

Michael Kerrisk (1):
      ipc: Fix 2 bugs in msgrcv() MSG_COPY implementation

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus Sp=
inPoint M8 (2BA30001)

Neil Horman (1):
      vmxnet3: fix netpoll race condition

Nicholas Bellinger (5):
      iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug
      bio-integrity: Fix bio_integrity_verify segment start bug
      iscsi/iser-target: Use list_del_init for ->i_conn_node
      iscsi/iser-target: Fix isert_conn->state hung shutdown issues
      iser-target: Fix post_send_buf_count for RDMA READ/WRITE

Oleg Drokin (1):
      Fix mountpoint reference leakage in linkat

Paul E. McKenney (1):
      jiffies: Avoid undefined behavior from signed overflow

Qais Yousef (1):
      MIPS: include linux/types.h

Radim Kr=C4=8Dm=C3=A1=C5=99 (1):
      KVM: SVM: fix cr8 intercept window

Rafael J. Wysocki (1):
      ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states

Rob Clark (1):
      drm/ttm: don't oops if no invalidate_caches()

Roman Volkov (2):
      ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2
      ALSA: oxygen: modify adjust_dg_dac_routing function

Russell King (1):
      ARM: ignore memory below PHYS_OFFSET

Stefan Richter (1):
      firewire: net: fix use after free

Steven Rostedt (Red Hat) (1):
      tracing: Do not add event files for modules that fail tracepoints

Sujith Manoharan (1):
      ath9k: Fix ETSI compliance for AR9462 2.0

Suresh Siddha (1):
      x86, fpu: Check tsk_used_math() in kernel_fpu_end() for eager FPU

Takashi Iwai (2):
      ALSA: usb-audio: Add quirk for Logitech Webcam C500
      ALSA: hda - Add missing loopback merge path for AD1884/1984 codecs

Tejun Heo (1):
      firewire: don't use PREPARE_DELAYED_WORK

Thomas Gleixner (1):
      tick: Make oneshot broadcast robust vs. CPU offlining

Trond Myklebust (2):
      NFS: Fix a delegation callback race
      NFSv4: nfs4_stateid_is_current should return 'true' for an invalid st=
ateid

Will Deacon (1):
      ARM: 7811/1: locks: use early clobber in arch_spin_trylock

Zhang Rui (2):
      ACPI / resources: ignore invalid ACPI device resources
      PNP / ACPI: proper handling of ACPI IO/Memory resource parsing failur=
es


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTL7viAAoJEDjbvchgkmk+wL4QAKqpy4/frPZ7s3+8ACcfSVkZ
g0yh0dC594+OChlFyIJpXtJn3ksCyHqts5lgcZ0KRNYPz35UV3J6kbErKByf6x0W
2Tj2XLwWpy3VEQ/mH/ui7Atdm3lywgkOByeVGhAhZNCWAkXqZKnLI7f5wP3Yn0Hs
N5BqdGdiF5fzK1lAVbUW8om7DKqQlg0//7d+J5hEAS+fBowVNEGuUuESKbM3Eigw
DWtout52olFYrNRYTc7YZA25+MnNV8NXdONWdjdfKlJGbswU8zzIjJxvyTO79qFS
iN5xmMRoX9w2IubxUz2fJuly4scXk+8BIdvpRK0uQ0m63HPpDzXo5jNFbA64xVAY
D8Q8nOC8mEI0IzTWyHL7TTUNY/FAAMAl4QUil0rulvt8PilBqCEGaD1ATpo/CcnF
2CWTbsR5wi5JMsslWRGOsQZpvmV77MnQ4mftRNikUwGTjllF90hsN/0AnZgp2MNZ
lElGQ2UuECsV/9B5u6EpzgzTezEaOIA+QmpGL3X+eZkvQ83RitRXOu7GjMy/KwdD
J2Tn1v7/gqWNqGA/tQfdraOfRla5NwWWzCd4iTsef4CrIVxIjEkRA2hOP0QF8MPl
mIHv3hr5L+JzJRUBiRAxwDNLmExwu3Oe1tg1eb7G2Qoz1foduL8qPA5n3SfHY/MB
BQJsztVHax2+6Eys4dQ4
=WNE0
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
