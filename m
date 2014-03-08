Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaCHBip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:38:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaCHBGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:06:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/99] 3.4.83-stable review
Date: Fri,  7 Mar 2014 17:06:56 -0800
Message-Id: <20140308010611.468206150@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.83 release.
There are 99 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Mar 10 01:05:53 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.83-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.83-rc1

Emil Goode <emilgoode@gmail.com>
    net: asix: add missing flag to struct driver_info

Lucas Stach <dev@lynxeye.de>
    net: asix: handle packets crossing URB boundaries

Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
    rtlwifi: Fix endian error in extracting packet type

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: add SKUs for 6000, 6005 and 6235 series

Stanislaw Gruszka <sgruszka@redhat.com>
    iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: dvm: don't send BT_CONFIG on devices w/o Bluetooth

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: always copy first 16 bytes of commands

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: handle DMA mapping failures

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: don't handle masked interrupt

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: protect SRAM debugfs

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fix flow handler debug code

Takashi Iwai <tiwai@suse.de>
    ALSA: asihpi: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    staging: line6: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ASoC: s6000: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ALSA: ua101: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Fix unlocked snd_pcm_stop() call

Takashi Iwai <tiwai@suse.de>
    ALSA: atiixp: Fix unlocked snd_pcm_stop() call

Fabio Estevam <fabio.estevam@freescale.com>
    ASoC: sglt5000: Fix the default value of CHIP_SSS_CTRL

Sascha Hauer <s.hauer@pengutronix.de>
    ASoC: imx-ssi: Fix occasional AC97 reset failure

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Prevent an rpc_task wakeup race

Jeff Layton <jlayton@redhat.com>
    sunrpc: clarify comments on rpc_make_runnable

David Vrabel <david.vrabel@citrix.com>
    xen/events: mask events when changing their VCPU binding

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/blkback: Check for insane amounts of request on the ring (v6).

Jan Beulich <jbeulich@suse.com>
    xen/io/ring.h: new macro to detect whether there are too many requests on the ring

Wei Liu <wei.liu2@citrix.com>
    xen-netback: don't disconnect frontend when seeing oversize packet

Wei Liu <wei.liu2@citrix.com>
    xen-netback: coalesce slots in TX path and fix regressions

stephen hemminger <stephen@networkplumber.org>
    xen-netback: fix sparse warning

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/smp/spinlock: Fix leakage of the spinlock interrupt line for every CPU online/offline

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/smp: Fix leakage of timer interrupt line for every CPU online/offline.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/boot: Disable BIOS SMP MP table search.

Takashi Iwai <tiwai@suse.de>
    saa7134: Fix unlocked snd_pcm_stop() call

Theodore Ts'o <tytso@mit.edu>
    ext4: return ENOMEM if sb_getblk() fails

Roland Dreier <roland@purestorage.com>
    block: Don't access request after it might be freed

Paul Clements <paul.clements@steeleye.com>
    nbd: correct disconnect behavior

Jeff Layton <jlayton@redhat.com>
    cifs: adjust sequence number downward after signing NT_CANCEL request

Jan Kara <jack@suse.cz>
    ext4: fix possible use-after-free with AIO

Adam Thomas <adamthomas1111@gmail.com>
    UBIFS: fix double free of ubifs_orphan objects

Theodore Ts'o <tytso@mit.edu>
    ext4/jbd2: don't wait (forever) for stale tid caused by wraparound

Dave Chiluk <chiluk@canonical.com>
    ncpfs: fix rmdir returns Device or resource busy

Jeff Layton <jlayton@redhat.com>
    cifs: don't instantiate new dentries in readdir for inodes that need to be revalidated immediately

majianpeng <majianpeng@gmail.com>
    libceph: unregister request in __map_request failed and nofail == false

Maxim Patlasov <MPatlasov@parallels.com>
    fuse: hotfix truncate_pagecache() issue

Miklos Szeredi <mszeredi@suse.cz>
    fuse: readdir: check for slash in names

Vyacheslav Dubeyko <slava@dubeyko.com>
    nilfs2: fix issue with race condition of competition between segments for dirty blocks

Jiri Olsa <jolsa@redhat.com>
    perf tools: Fix cache event name generation

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Remove extraneous newline when parsing hardware cache events

Jiang Liu <jiang.liu@huawei.com>
    mm/hotplug: correctly add new zone to all other nodes' zone lists

Tejun Heo <tj@kernel.org>
    cgroup: fix RCU accesses to task->cgroups

Kees Cook <keescook@chromium.org>
    proc connector: reject unprivileged listener bumps

Greg Edwards <gedwards@ddn.com>
    KVM: IOMMU: hva align mapping page size

Alexander Graf <agraf@suse.de>
    KVM: PPC: Emulate dcbf

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/kvm: dont announce RRBM support

Dominik Dingel <dingel@linux.vnet.ibm.com>
    KVM: s390: move kvm_guest_enter,exit closer to sie

Tejun Heo <tj@kernel.org>
    cgroup: cgroup_subsys->fork() should be called after the task is added to css_set

Johannes Weiner <hannes@cmpxchg.org>
    mm: vmscan: fix endless loop in kswapd balancing

Hannes Reinecke <hare@suse.de>
    dm mpath: fix stalls when handling invalid ioctls

Linus Walleij <linus.walleij@linaro.org>
    dma: ste_dma40: don't dereference free:d descriptor

Jan Kara <jack@suse.cz>
    quota: Fix race between dqput() and dquot_scan_active()

Eric Paris <eparis@redhat.com>
    SELinux: bigendian problems with filename trans rules

Peter Zijlstra <peterz@infradead.org>
    perf: Fix hotplug splat

Lai Jiangshan <laijs@cn.fujitsu.com>
    workqueue: ensure @task is valid across kthread_stop()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max1668) Fix writing the minimum temperature

Joerg Dorchain <joerg@dorchain.net>
    USB: ftdi_sio: add Cressi Leonardo PID

Aleksander Morgado <aleksander@aleksander.es>
    USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / processor: Rework processor throttling with work_on_cpu()

Hans de Goede <hdegoede@redhat.com>
    ACPI / video: Filter the _BCL table for duplicate brightness values

Jean Delvare <jdelvare@suse.de>
    i7core_edac: Fix PCI device reference count

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Enable INTx if BIOS left them disabled

Tejun Heo <tj@kernel.org>
    sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN

Denis V. Lunev <den@openvz.org>
    ata: enable quirk from jmicron JMB350 for JMB394

Peter Zijlstra <peterz@infradead.org>
    perf/x86: Fix event scheduling

Laurent Dufour <ldufour@linux.vnet.ibm.com>
    powerpc/crashdump : Fix page frame number check in copy_oldmem_page

Tony Breeds <tony@bakeyournoodle.com>
    powerpc/le: Ensure that the 'stop-self' RTAS token is handled correctly

Trond Myklebust <trond.myklebust@primarydata.com>
    SUNRPC: Fix races in xs_nospace()

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: wm8958-dsp: Fix firmware block loading

Takashi Iwai <tiwai@suse.de>
    ASoC: sta32x: Fix array access overflow

Takashi Iwai <tiwai@suse.de>
    ASoC: sta32x: Fix wrong enum for limiter2 release rate

Takashi Iwai <tiwai@suse.de>
    ASoC: wm8770: Fix wrong number of enum items

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: work around KEF X300A firmware bug

Florian Westphal <fw@strlen.de>
    net: ip, ipv6: handle gso skbs in forwarding path

Florian Westphal <fw@strlen.de>
    net: add and use skb_gso_transport_seglen()

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode

Emil Goode <emilgoode@gmail.com>
    usbnet: remove generic hard_header_len check

Jiri Bohac <jiri@boha.cz>
    bonding: 802.3ad: make aggregator_identifier bond-private

Nithin Sujir <nsujir@broadcom.com>
    tg3: Fix deadlock in tg3_change_mtu()

Maciej Żenczykowski <maze@google.com>
    net: fix 'ip rule' iif/oif device rename

Olivier Langlois <olivier@trillion01.com>
    rtlwifi: rtl8192ce: Fix too long disable of IRQs

Olivier Langlois <olivier@trillion01.com>
    rtlwifi: Fix incorrect return from rtl_ps_enable_nic()

Stanislaw Gruszka <stf_xl@wp.pl>
    rtl8187: fix regression on MIPS without coherent DMA

Jeff Layton <jlayton@redhat.com>
    cifs: ensure that uncached writes handle unmapped areas correctly

Chen Gang <gang.chen.5i5j@gmail.com>
    avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use

Paul Gortmaker <paul.gortmaker@windriver.com>
    avr32: fix missing module.h causing build failure in mimc200/fram.c

Vinayak Kale <vkale@apm.com>
    ARM: 7957/1: add DSB after icache flush in __flush_icache_all()

Will Deacon <will.deacon@arm.com>
    ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling MMU

Theodore Ts'o <tytso@mit.edu>
    ext4: don't leave i_crtime.tv_sec uninitialized

Theodore Ts'o <tytso@mit.edu>
    ext4: fix online resize with a non-standard blocks per group setting

Theodore Ts'o <tytso@mit.edu>
    ext4: don't try to modify s_flags if the the file system is read-only


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/arm/include/asm/cacheflush.h                 |   1 +
 arch/arm/mm/proc-v6.S                             |   3 +-
 arch/arm/mm/proc-v7.S                             |   2 +-
 arch/avr32/Makefile                               |   2 +-
 arch/avr32/boards/mimc200/fram.c                  |   1 +
 arch/powerpc/kernel/crash_dump.c                  |   8 +-
 arch/powerpc/kvm/emulate.c                        |   2 +
 arch/powerpc/platforms/pseries/hotplug-cpu.c      |  22 +-
 arch/s390/kvm/kvm-s390.c                          |  14 +-
 arch/x86/kernel/cpu/perf_event.c                  |   3 +
 arch/x86/xen/enlighten.c                          |   4 +
 arch/x86/xen/smp.c                                |   2 +
 block/blk-exec.c                                  |  12 +-
 drivers/acpi/processor_throttling.c               |  69 +++---
 drivers/acpi/video.c                              |   8 +-
 drivers/ata/libata-pmp.c                          |   7 +-
 drivers/ata/sata_sil.c                            |   1 +
 drivers/block/nbd.c                               |   8 +-
 drivers/block/xen-blkback/blkback.c               |  13 +-
 drivers/block/xen-blkback/common.h                |   2 +
 drivers/block/xen-blkback/xenbus.c                |   2 +
 drivers/connector/cn_proc.c                       |   8 +
 drivers/dma/ste_dma40.c                           |   4 +-
 drivers/edac/i7core_edac.c                        |   9 +-
 drivers/hwmon/max1668.c                           |   2 +-
 drivers/md/dm-mpath.c                             |   7 +-
 drivers/media/video/saa7134/saa7134-alsa.c        |   2 +
 drivers/net/bonding/bond_3ad.c                    |   6 +-
 drivers/net/bonding/bond_3ad.h                    |   1 +
 drivers/net/ethernet/broadcom/tg3.c               |   4 +-
 drivers/net/usb/asix.c                            | 128 +++++++---
 drivers/net/usb/gl620a.c                          |   4 +
 drivers/net/usb/mcs7830.c                         |   5 +-
 drivers/net/usb/net1080.c                         |   4 +
 drivers/net/usb/qmi_wwan.c                        |   8 +-
 drivers/net/usb/rndis_host.c                      |   4 +
 drivers/net/usb/smsc75xx.c                        |   4 +
 drivers/net/usb/smsc95xx.c                        |   4 +
 drivers/net/usb/usbnet.c                          |  25 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |   6 +
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   2 +-
 drivers/net/wireless/iwlwifi/iwl-cfg.h            |   1 +
 drivers/net/wireless/iwlwifi/iwl-core.c           |   5 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   3 +
 drivers/net/wireless/iwlwifi/iwl-pci.c            |  10 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |  11 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |  37 ++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |  65 ++++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |  27 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h    |  10 +-
 drivers/net/wireless/rtlwifi/base.c               |  89 +++----
 drivers/net/wireless/rtlwifi/ps.c                 |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c       |  18 +-
 drivers/net/wireless/rtlwifi/wifi.h               |   6 +-
 drivers/net/xen-netback/netback.c                 | 289 ++++++++++++++++++----
 drivers/pci/pci.c                                 |  10 +
 drivers/staging/line6/pcm.c                       |   5 +-
 drivers/usb/serial/ftdi_sio.c                     |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                 |   6 +
 drivers/usb/serial/option.c                       |   3 +-
 drivers/xen/events.c                              |  11 +
 fs/cifs/file.c                                    |  37 ++-
 fs/cifs/readdir.c                                 |   8 +
 fs/cifs/transport.c                               |   7 +
 fs/ext4/ext4.h                                    |   2 +
 fs/ext4/extents.c                                 |  25 +-
 fs/ext4/fsync.c                                   |   3 +-
 fs/ext4/indirect.c                                |   9 +-
 fs/ext4/inode.c                                   |  14 +-
 fs/ext4/mmp.c                                     |   2 +
 fs/ext4/page-io.c                                 |   9 +-
 fs/ext4/resize.c                                  |  10 +-
 fs/ext4/super.c                                   |  20 +-
 fs/ext4/xattr.c                                   |   3 +-
 fs/fuse/dir.c                                     |   9 +-
 fs/fuse/file.c                                    |   8 +-
 fs/fuse/fuse_i.h                                  |   9 +
 fs/fuse/inode.c                                   |   4 +-
 fs/jbd2/journal.c                                 |  31 +++
 fs/ncpfs/dir.c                                    |   9 -
 fs/nilfs2/page.c                                  |   2 +
 fs/nilfs2/segment.c                               |  11 +-
 fs/quota/dquot.c                                  |  14 +-
 fs/ubifs/orphan.c                                 |   5 +-
 fs/ubifs/ubifs.h                                  |   2 +
 include/linux/cgroup.h                            |  53 +++-
 include/linux/jbd2.h                              |   1 +
 include/linux/nbd.h                               |   1 +
 include/linux/skbuff.h                            |  19 ++
 include/xen/interface/io/netif.h                  |  18 ++
 include/xen/interface/io/ring.h                   |   5 +
 kernel/cgroup.c                                   |  50 ++--
 kernel/cgroup_freezer.c                           |  13 +-
 kernel/events/core.c                              |  12 +-
 kernel/fork.c                                     |   9 +-
 kernel/workqueue.c                                |   7 +
 mm/memory_hotplug.c                               |  15 +-
 mm/vmscan.c                                       |  27 +-
 net/ceph/osd_client.c                             |   2 +
 net/core/fib_rules.c                              |   7 +
 net/core/skbuff.c                                 |  25 ++
 net/ipv4/ip_forward.c                             |  68 ++++-
 net/ipv6/ip6_output.c                             |  13 +-
 net/sctp/socket.c                                 |  41 ++-
 net/sunrpc/sched.c                                |  13 +-
 net/sunrpc/xprtsock.c                             |   6 +-
 security/selinux/ss/policydb.c                    |   8 +-
 sound/arm/pxa2xx-pcm-lib.c                        |   2 +
 sound/pci/asihpi/asihpi.c                         |   3 +
 sound/pci/atiixp.c                                |   2 +
 sound/pci/atiixp_modem.c                          |   2 +
 sound/soc/codecs/sgtl5000.c                       |   2 +-
 sound/soc/codecs/sta32x.c                         |  74 +++---
 sound/soc/codecs/wm8770.c                         |   4 +-
 sound/soc/codecs/wm8958-dsp2.c                    |   2 +-
 sound/soc/imx/imx-ssi.c                           |   5 +
 sound/soc/s6000/s6000-pcm.c                       |   2 +
 sound/usb/6fire/pcm.c                             |  12 +-
 sound/usb/misc/ua101.c                            |  14 +-
 sound/usb/mixer_maps.c                            |   9 +
 sound/usb/usx2y/usbusx2yaudio.c                   |   4 +
 tools/perf/util/parse-events.c                    |   2 +-
 virt/kvm/iommu.c                                  |   4 +
 124 files changed, 1363 insertions(+), 483 deletions(-)


