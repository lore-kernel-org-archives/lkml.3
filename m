Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaCDUgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:36:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083AbaCDUEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/97] 3.10.33-stable review
Date: Tue,  4 Mar 2014 12:03:13 -0800
Message-Id: <20140304200345.895517495@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.33 release.
There are 97 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Mar  6 20:03:11 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.33-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.33-rc1

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: disable pll sharing for DP on DCE4.1

Christian König <christian.koenig@amd.com>
    drm/radeon: fix missing bo reservation

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: print the supported atpx function mask

Mike Snitzer <snitzer@redhat.com>
    dm thin: fix the error path for the thin device constructor

Mike Snitzer <snitzer@redhat.com>
    dm thin: avoid metadata commit if a pool's thin devices haven't changed

Hannes Reinecke <hare@suse.de>
    dm mpath: fix stalls when handling invalid ioctls

Linus Walleij <linus.walleij@linaro.org>
    dma: ste_dma40: don't dereference free:d descriptor

Jean Delvare <jdelvare@suse.de>
    i7300_edac: Fix device reference count

Dr. Greg Wettstein <greg@enjellic.com>
    qla2xxx: Fix kernel panic on selective retransmission request

Will Deacon <will.deacon@arm.com>
    ARM: 7812/1: rwlocks: retry trylock operation if strex fails on free lock

Will Deacon <will.deacon@arm.com>
    ARM: 7749/1: spinlock: retry trylock operation if strex fails on free lock

Stephen Warren <swarren@nvidia.com>
    ARM: tegra: only run PL310 init on systems with one

Olof Johansson <olof@lixom.net>
    ARM64: unwind: Fix PC calculation

James Hogan <james.hogan@imgtec.com>
    irq-metag*: stop set_affinity vectoring to offline cpus

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    Input - arizona-haptics: Fix double lock of dapm_mutex

Davidlohr Bueso <davidlohr@hp.com>
    ipc,mqueue: remove limits for the amount of system-wide queues

Jan Kara <jack@suse.cz>
    quota: Fix race between dqput() and dquot_scan_active()

Eric Paris <eparis@redhat.com>
    SELinux: bigendian problems with filename trans rules

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: introduce spill_registers_kernel macro

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add a fixup for HP Folio 13 mute LED

Peter Zijlstra <peterz@infradead.org>
    perf: Fix hotplug splat

Denis CIOCCA <denis.ciocca@st.com>
    iio:gyro: bug on L3GD20H gyroscope support

Arve Hjønnevåg <arve@android.com>
    staging: binder: Fix death notifications

Lai Jiangshan <laijs@cn.fujitsu.com>
    workqueue: ensure @task is valid across kthread_stop()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max1668) Fix writing the minimum temperature

Chao Bi <chao.bi@intel.com>
    mei: set client's read_cb to NULL when flow control fails

Joerg Dorchain <joerg@dorchain.net>
    USB: ftdi_sio: add Cressi Leonardo PID

Stanislaw Gruszka <sgruszka@redhat.com>
    usb: ehci: fix deadlock when threadirqs option is used

Aleksander Morgado <aleksander@aleksander.es>
    USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8

Florian Fainelli <florian@openwrt.org>
    usb: gadget: bcm63xx_udc: fix build failure on DMA channel code

Matthieu CASTET <matthieu.castet@parrot.com>
    usb: chipidea: need to mask when writting endptflush and endptprime

Olivier Sobrie <olivier@sobrie.be>
    can: kvaser_usb: check number of channels returned by HW

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / processor: Rework processor throttling with work_on_cpu()

Hans de Goede <hdegoede@redhat.com>
    ACPI / video: Filter the _BCL table for duplicate brightness values

Jean Delvare <jdelvare@suse.de>
    i7core_edac: Fix PCI device reference count

Tomasz Nowicki <tomasz.nowicki@linaro.org>
    ACPI / PCI: Fix memory leak in acpi_pci_irq_enable()

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Enable INTx if BIOS left them disabled

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    cpufreq: powernow-k8: Initialize per-cpu data-structures properly

Tejun Heo <tj@kernel.org>
    sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN

Denis V. Lunev <den@openvz.org>
    ata: enable quirk from jmicron JMB350 for JMB394

Peter Zijlstra <peterz@infradead.org>
    perf/x86: Fix event scheduling

Marek Szyprowski <m.szyprowski@samsung.com>
    x86: dma-mapping: fix GFP_ATOMIC macro usage

Levente Kurusa <levex@linux.com>
    ahci: disable NCQ on Samsung pci-e SSDs on macbooks

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

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: sta32x: Fix cache sync

Mark Brown <broonie@linaro.org>
    ASoC: da732x: Mark DC offset control registers volatile

Takashi Iwai <tiwai@suse.de>
    ASoC: wm8770: Fix wrong number of enum items

Dylan Reid <dgreid@chromium.org>
    ASoC: max98090: sync regcache on entering STANDBY

Andrew Honig <ahonig@google.com>
    kvm: x86: fix emulator buffer overflow (CVE-2014-0049)

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Enable front audio jacks on one HP desktop model

Hsin-Yu Chao <hychao@chromium.org>
    ALSA: hda/ca0132 - Fix recording from mode id 0x8

Hsin-Yu Chao <hychao@chromium.org>
    ALSA: hda/ca0132 - setup/cleanup streams

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: work around KEF X300A firmware bug

Christoph Hellwig <hch@infradead.org>
    fs: fix iversion handling

Michal Hocko <mhocko@suse.cz>
    memcg: fix endless loop caused by mem_cgroup_iter

Eric Dumazet <edumazet@google.com>
    net: use __GFP_NORETRY for high order allocations

Florian Westphal <fw@strlen.de>
    net: ip, ipv6: handle gso skbs in forwarding path

Florian Westphal <fw@strlen.de>
    net: core: introduce netif_skb_dev_features

Florian Westphal <fw@strlen.de>
    net: add and use skb_gso_transport_seglen()

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode

Duan Jiong <duanj.fnst@cn.fujitsu.com>
    ipv4: fix counter in_slow_tot

Jiri Bohac <jiri@boha.cz>
    bonding: 802.3ad: make aggregator_identifier bond-private

Emil Goode <emilgoode@gmail.com>
    usbnet: remove generic hard_header_len check

Emil Goode <emilgoode@gmail.com>
    net: asix: add missing flag to struct driver_info

Nithin Sujir <nsujir@broadcom.com>
    tg3: Fix deadlock in tg3_change_mtu()

John Ogness <john.ogness@linutronix.de>
    tcp: tsq: fix nonagle handling

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Netgear Aircard 340U

Sabrina Dubroca <sd@queasysnail.net>
    netpoll: fix netconsole IPv6 setup

Maciej Żenczykowski <maze@google.com>
    net: fix 'ip rule' iif/oif device rename

Geert Uytterhoeven <geert@linux-m68k.org>
    ipv4: Fix runtime WARNING in rtmsg_ifa()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: add destructor for self generated skbs

Richard Yao <ryao@gentoo.org>
    9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers

Eric Dumazet <edumazet@google.com>
    6lowpan: fix lockdep splats

Olivier Langlois <olivier@trillion01.com>
    rtlwifi: rtl8192ce: Fix too long disable of IRQs

Olivier Langlois <olivier@trillion01.com>
    rtlwifi: Fix incorrect return from rtl_ps_enable_nic()

Stanislaw Gruszka <stf_xl@wp.pl>
    rtl8187: fix regression on MIPS without coherent DMA

Pavel Shilovsky <piastry@etersoft.ru>
    CIFS: Fix too big maxBuf size for SMB3 mounts

Jeff Layton <jlayton@redhat.com>
    cifs: ensure that uncached writes handle unmapped areas correctly

Chen Gang <gang.chen.5i5j@gmail.com>
    avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use

Paul Gortmaker <paul.gortmaker@windriver.com>
    avr32: fix missing module.h causing build failure in mimc200/fram.c

Pekon Gupta <pekon@ti.com>
    ARM: OMAP2+: gpmc: fix: DT ONENAND child nodes not probed when MTD_ONENAND is built as module

Pekon Gupta <pekon@ti.com>
    ARM: OMAP2+: gpmc: fix: DT NAND child nodes not probed when MTD_NAND is built as module

Vinayak Kale <vkale@apm.com>
    ARM: 7957/1: add DSB after icache flush in __flush_icache_all()

Will Deacon <will.deacon@arm.com>
    ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling MMU

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dma-mapping: fix GFP_ATOMIC macro usage

Theodore Ts'o <tytso@mit.edu>
    ext4: don't leave i_crtime.tv_sec uninitialized

Theodore Ts'o <tytso@mit.edu>
    ext4: fix online resize with a non-standard blocks per group setting

Theodore Ts'o <tytso@mit.edu>
    ext4: fix online resize with very large inode tables

Theodore Ts'o <tytso@mit.edu>
    ext4: don't try to modify s_flags if the the file system is read-only

Zheng Liu <wenqing.lz@taobao.com>
    ext4: fix error paths in swap_inode_boot_loader()

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nv50/disp: use correct register to determine DP display bpp

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau: set irq_enabled manually


-------------

Diffstat:

 Makefile                                        |  4 +-
 arch/arm/include/asm/cacheflush.h               |  1 +
 arch/arm/include/asm/spinlock.h                 | 82 +++++++++++++++----------
 arch/arm/mach-omap2/gpmc.c                      |  4 +-
 arch/arm/mach-tegra/common.c                    | 11 ++++
 arch/arm/mm/dma-mapping.c                       |  2 +-
 arch/arm/mm/proc-v6.S                           |  3 +-
 arch/arm/mm/proc-v7.S                           |  2 +-
 arch/arm64/kernel/stacktrace.c                  |  6 +-
 arch/avr32/Makefile                             |  2 +-
 arch/avr32/boards/mimc200/fram.c                |  1 +
 arch/powerpc/kernel/crash_dump.c                |  8 ++-
 arch/powerpc/platforms/pseries/hotplug-cpu.c    | 22 +++----
 arch/x86/kernel/cpu/perf_event.c                |  3 +
 arch/x86/kernel/pci-dma.c                       |  4 +-
 arch/x86/kvm/x86.c                              |  2 +-
 arch/xtensa/include/asm/traps.h                 | 44 ++++++++-----
 arch/xtensa/kernel/entry.S                      | 60 ++++++++++++++----
 drivers/acpi/pci_irq.c                          |  1 +
 drivers/acpi/processor_throttling.c             | 69 ++++++++++-----------
 drivers/acpi/video.c                            |  8 ++-
 drivers/ata/ahci.c                              | 14 +++++
 drivers/ata/libata-pmp.c                        |  7 ++-
 drivers/ata/sata_sil.c                          |  1 +
 drivers/cpufreq/powernow-k8.c                   | 10 ++-
 drivers/dma/ste_dma40.c                         |  4 +-
 drivers/edac/i7300_edac.c                       | 38 ++++++------
 drivers/edac/i7core_edac.c                      |  9 ++-
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c |  2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c           |  3 +
 drivers/gpu/drm/radeon/atombios_crtc.c          | 16 ++++-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c    |  3 +-
 drivers/gpu/drm/radeon/radeon_kms.c             |  6 ++
 drivers/hwmon/max1668.c                         |  2 +-
 drivers/iio/gyro/Kconfig                        |  2 +-
 drivers/iio/gyro/st_gyro.h                      |  1 -
 drivers/iio/gyro/st_gyro_core.c                 |  9 ++-
 drivers/iio/gyro/st_gyro_i2c.c                  |  1 -
 drivers/iio/gyro/st_gyro_spi.c                  |  1 -
 drivers/input/misc/arizona-haptics.c            | 11 ++--
 drivers/irqchip/irq-metag-ext.c                 |  2 +-
 drivers/irqchip/irq-metag.c                     |  2 +-
 drivers/md/dm-mpath.c                           |  7 ++-
 drivers/md/dm-thin-metadata.c                   | 17 +++++
 drivers/md/dm-thin-metadata.h                   |  2 +
 drivers/md/dm-thin.c                            |  8 ++-
 drivers/misc/mei/client.c                       |  4 +-
 drivers/net/bonding/bond_3ad.c                  |  6 +-
 drivers/net/bonding/bond_3ad.h                  |  1 +
 drivers/net/can/dev.c                           | 15 +----
 drivers/net/can/janz-ican3.c                    | 18 ++----
 drivers/net/can/usb/kvaser_usb.c                |  2 +
 drivers/net/can/vcan.c                          |  9 ++-
 drivers/net/ethernet/broadcom/tg3.c             |  4 +-
 drivers/net/usb/asix_devices.c                  |  3 +-
 drivers/net/usb/ax88179_178a.c                  |  4 ++
 drivers/net/usb/gl620a.c                        |  4 ++
 drivers/net/usb/mcs7830.c                       |  5 +-
 drivers/net/usb/net1080.c                       |  4 ++
 drivers/net/usb/qmi_wwan.c                      |  9 +--
 drivers/net/usb/rndis_host.c                    |  4 ++
 drivers/net/usb/smsc75xx.c                      |  4 ++
 drivers/net/usb/smsc95xx.c                      |  4 ++
 drivers/net/usb/usbnet.c                        | 25 +++-----
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h  | 10 ++-
 drivers/net/wireless/rtlwifi/ps.c               |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c     | 18 +++++-
 drivers/pci/pci.c                               | 10 +++
 drivers/scsi/qla2xxx/qla_target.c               |  3 +-
 drivers/staging/android/binder.c                |  3 +-
 drivers/usb/chipidea/udc.c                      |  4 +-
 drivers/usb/gadget/bcm63xx_udc.c                | 58 +++++++++--------
 drivers/usb/host/ehci-hcd.c                     | 13 +++-
 drivers/usb/serial/ftdi_sio.c                   |  2 +
 drivers/usb/serial/ftdi_sio_ids.h               |  6 ++
 drivers/usb/serial/option.c                     |  3 +-
 fs/attr.c                                       |  5 --
 fs/btrfs/inode.c                                |  8 ++-
 fs/cifs/file.c                                  | 37 ++++++++++-
 fs/cifs/smb2glob.h                              |  3 +
 fs/cifs/smb2ops.c                               | 14 ++---
 fs/cifs/smb2pdu.c                               |  3 +
 fs/ext4/ext4.h                                  |  2 +
 fs/ext4/inode.c                                 |  4 ++
 fs/ext4/ioctl.c                                 |  3 +-
 fs/ext4/resize.c                                | 34 ++++++----
 fs/ext4/super.c                                 | 20 +++---
 fs/quota/dquot.c                                | 14 ++++-
 include/linux/can/skb.h                         | 38 ++++++++++++
 include/linux/ipc_namespace.h                   |  2 -
 include/linux/netdevice.h                       |  7 ++-
 include/linux/skbuff.h                          | 19 ++++++
 ipc/mq_sysctl.c                                 | 18 ++++--
 ipc/mqueue.c                                    |  6 +-
 kernel/events/core.c                            | 12 ++--
 kernel/workqueue.c                              |  7 +++
 mm/memcontrol.c                                 |  4 +-
 net/9p/trans_virtio.c                           |  5 +-
 net/can/af_can.c                                |  3 +-
 net/can/bcm.c                                   |  4 +-
 net/core/dev.c                                  | 27 ++++----
 net/core/fib_rules.c                            |  7 +++
 net/core/netpoll.c                              |  4 +-
 net/core/skbuff.c                               | 25 ++++++++
 net/core/sock.c                                 |  2 +-
 net/ieee802154/6lowpan.c                        | 20 ++++++
 net/ipv4/devinet.c                              |  3 +-
 net/ipv4/ip_forward.c                           | 71 ++++++++++++++++++++-
 net/ipv4/route.c                                |  4 +-
 net/ipv4/tcp_output.c                           | 13 +++-
 net/ipv6/ip6_output.c                           | 17 ++++-
 net/sctp/socket.c                               | 41 ++++++++++---
 net/sunrpc/xprtsock.c                           |  6 +-
 security/selinux/ss/policydb.c                  |  8 +--
 sound/pci/hda/patch_ca0132.c                    | 68 +++-----------------
 sound/pci/hda/patch_sigmatel.c                  | 33 ++++++++++
 sound/soc/codecs/da732x.c                       | 12 ++++
 sound/soc/codecs/max98090.c                     | 20 +++---
 sound/soc/codecs/sta32x.c                       | 76 +++++++++++------------
 sound/soc/codecs/wm8770.c                       |  4 +-
 sound/soc/codecs/wm8958-dsp2.c                  |  2 +-
 sound/usb/mixer_maps.c                          |  9 +++
 122 files changed, 1025 insertions(+), 493 deletions(-)


