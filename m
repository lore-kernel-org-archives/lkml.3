Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab3JKUQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:16:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab3JKTk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 000/135] 3.11.5-stable review
Date: Fri, 11 Oct 2013 12:38:01 -0700
Message-Id: <20131011193945.181603934@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.11.5 release.
There are 135 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Oct 13 19:38:31 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.11.5-rc1

Kent Overstreet <kmo@daterainc.com>
    bcache: Fix a null ptr deref regression

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add new Qualcomm devices

David Herrmann <dh.herrmann@gmail.com>
    HID: uhid: allocate static minor

Marcel Holtmann <marcel@holtmann.org>
    HID: uhid: add devname module alias

Anders F. U. Kiær <ablacksheep@gmail.com>
    HID: add Holtek USB ID 04d9:a081 SHARKOON DarkGlider

Stefan Achatz <erazor_de@users.sourceforge.net>
    HID: roccat: add support for KonePureOptical v2

Josef Bacik <jbacik@fusionio.com>
    Btrfs: remove ourselves from the cluster list under lock

Josef Bacik <jbacik@fusionio.com>
    Btrfs: skip subvol entries when checking if we've created a dir already

Josef Bacik <jbacik@fusionio.com>
    Btrfs: change how we queue blocks for backref checking

Josef Bacik <jbacik@fusionio.com>
    Btrfs: reset ret in record_one_backref

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390: fix system call restart after inferior call

Chris Metcalf <cmetcalf@tilera.com>
    tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT

Franck Jullien <franck.jullien@gmail.com>
    mmc: fix null pointer use in mmc_blk_remove_req

David Herrmann <dh.herrmann@gmail.com>
    HID: wiimote: fix FF deadlock

Olof Johansson <olof@lixom.net>
    ARM: multi_v7_defconfig: enable ARM_ATAG_DTB_COMPAT

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix GPIO for Acer Aspire 3830TG

Stephen Warren <swarren@nvidia.com>
    ARM: tegra: unify Tegra's Kconfig a bit more

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/bios/init: stub opcode 0xaa

Mark Tinguely <tinguely@sgi.com>
    xfs: fix node forward in xfs_node_toosmall

Lv Zheng <lv.zheng@intel.com>
    ACPI / IPMI: Fix atomic context requirement of ipmi_msg_handler()

Michael Grzeschik <m.grzeschik@pengutronix.de>
    dmaengine: imx-dma: fix slow path issue in prep_dma_cyclic

Michael Grzeschik <m.grzeschik@pengutronix.de>
    dmaengine: imx-dma: fix callback path in tasklet

Michael Grzeschik <m.grzeschik@pengutronix.de>
    dmaengine: imx-dma: fix lockdep issue between irqhandler and tasklet

Rafał Miłecki <zajec5@gmail.com>
    drm/radeon: fix hdmi callbacks for rv6xx (incorrectly added to r520)

Frederic Weisbecker <fweisbec@gmail.com>
    irq: Force hardirq exit's softirq processing on its own stack

Eric W. Biederman <ebiederm@xmission.com>
    net: Update the sysctl permissions handler to test effective uid/gid

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Only perform wait_for_tasks when performing shutdown

Rafael Aquini <aquini@redhat.com>
    mm: avoid reinserting isolated balloon pages into LRU lists

Christian Lamparter <chunkeey@googlemail.com>
    p54usb: add USB ID for Corega WLUSB2GTST USB adapter

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Align private space in rtl_priv struct

Jack Wang <jinpu.wang@profitbricks.com>
    ib_srpt: always set response for task management

Nicholas Bellinger <nab@linux-iscsi.org>
    ib_srpt: Destroy cm_id before destroying QP.

David Vrabel <david.vrabel@citrix.com>
    xen/hvc: allow xenboot console to be used again

Michal Malý <madcatxster@prifuk.cz>
    USB: serial: option: Ignore card reader interface on Huawei E1750

David Cohen <david.a.cohen@linux.intel.com>
    usb: chipidea: add Intel Clovertrail pci id

Bing Zhao <bzhao@marvell.com>
    mwifiex: fix PCIe hs_cfg cancel cmd timeout

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: fix hang issue for USB chipsets

Bing Zhao <bzhao@marvell.com>
    mwifiex: fix NULL pointer dereference in usb suspend handler

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4.1: nfs4_fl_prepare_ds - fix bugs when the connect attempt fails

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    kernel/kmod.c: check for NULL in call_usermodehelper_exec()

Darrick J. Wong <darrick.wong@oracle.com>
    mm/bounce.c: fix a regression where MS_SNAP_STABLE (stable pages snapshotting) was ignored

David Miller <davem@davemloft.net>
    mm: Fix generic hugetlb pte check return type.

Kirill Tkhai <tkhai@yandex.ru>
    sparc32: Fix exit flag passed from traced sys_sigreturn

Kirill Tkhai <tkhai@yandex.ru>
    sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall

David S. Miller <davem@davemloft.net>
    sparc64: Fix off by one in trampoline TLB mapping installation loop.

David S. Miller <davem@davemloft.net>
    esp_scsi: Fix tag state corruption when autosensing.

Kirill Tkhai <tkhai@yandex.ru>
    sparc64: Fix ITLB handler of null page

Kirill Tkhai <tkhai@yandex.ru>
    sparc64: Remove RWSEM export leftovers

Kees Cook <keescook@chromium.org>
    sparc: fix ldom_reboot buffer overflow harder

David S. Miller <davem@davemloft.net>
    sparc64: Fix buggy strlcpy() conversion in ldom_reboot().

Davidlohr Bueso <davidlohr@hp.com>
    ipc: fix race with LSMs

Davidlohr Bueso <davidlohr@hp.com>
    ipc,msg: prevent race with rmid in msgsnd,msgrcv

Manfred Spraul <manfred@colorfullife.com>
    ipc/sem.c: fix race in sem_lock()

Vyacheslav Dubeyko <slava@dubeyko.com>
    nilfs2: fix issue with race condition of competition between segments for dirty blocks

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix rfkill functionality during the HCI setup stage

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Introduce a new HCI_RFKILLED flag

Raphael Kubo da Costa <rakuco@FreeBSD.org>
    Bluetooth: Add support for BCM20702A0 [0b05, 17cb]

Peng Chen <pengchen@qti.qualcomm.com>
    Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.

Andre Guedes <andre.guedes@openbossa.org>
    Bluetooth: Fix encryption key size for peripheral role

Andre Guedes <andre.guedes@openbossa.org>
    Bluetooth: Fix security level for peripheral role

Arend van Spriel <arend@broadcom.com>
    brcmfmac: obtain platform data upon module initialization

Maxim Patlasov <MPatlasov@parallels.com>
    fuse: fix fallocate vs. ftruncate race

Maxim Patlasov <MPatlasov@parallels.com>
    fuse: wait for writeback in fuse_file_fallocate()

Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    powerpc: Restore registers on error exit from csum_partial_copy_generic()

Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
    powerpc/sysfs: Disable writing to PURR in guest mode

Nathan Fontenot <nfont@linux.vnet.ibm.com>
    powerpc: Fix memory hotplug with sparse vmemmap

Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    powerpc: Fix parameter clobber in csum_partial_copy_generic()

Prarit Bhargava <prarit@redhat.com>
    powerpc/vio: Fix modalias_show return values

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Turn interrupts hard off in tm_reclaim()

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Switch out userspace PPR and DSCR sooner

Michael Ellerman <michael@ellerman.id.au>
    powerpc/perf: Fix handling of FAB events

Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
    powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_table()

Will Deacon <will.deacon@arm.com>
    iommu/arm-smmu: don't enable SMMU device until probing has completed

Dan Carpenter <dan.carpenter@oracle.com>
    iommu/arm-smmu: fix iommu_present() test in init

Dan Carpenter <dan.carpenter@oracle.com>
    iommu/arm-smmu: fix a signedness bug

Joerg Roedel <joro@8bytes.org>
    ARM: mach-integrator: Add stub for pci_v3_early_init() for !CONFIG_PCI

Olof Johansson <olof@lixom.net>
    ARM: kvm: rename cpu_reset to avoid name clash

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: ab8500-codec: info leak in anc_status_control_put()

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: max98095: a couple array underflows

Javier Martinez Canillas <javier.martinez@collabora.co.uk>
    gpio/omap: auto-setup a GPIO when used as an IRQ

Javier Martinez Canillas <javier.martinez@collabora.co.uk>
    gpio/omap: maintain GPIO and IRQ usage separately

Dan Aloni <alonid@stratoscale.com>
    fs/binfmt_elf.c: prevent a coredump with a large vm_map_count from Oopsing

Nishanth Menon <nm@ti.com>
    regulator: ti-abb: Fix bias voltage glitch in transition to bypass mode

Gabor Juhos <juhosg@openwrt.org>
    avr32: fix clockevents kernel warning

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip6tnl: allow to use rtnl ops on fb tunnel

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    sit: allow to use rtnl ops on fb tunnel

Steffen Klassert <steffen.klassert@secunet.com>
    ip_tunnel_core: Change __skb_push back to skb_push

Steffen Klassert <steffen.klassert@secunet.com>
    ip_tunnel: Fix a memory corruption in ip_tunnel_xmit

Ricardo Ribalda <ricardo.ribalda@gmail.com>
    ll_temac: Reset dma descriptors indexes on ndo_open

Salam Noureddine <noureddine@aristanetworks.com>
    ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put

Salam Noureddine <noureddine@aristanetworks.com>
    ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: gre: correct calculation of max_headroom

Neil Horman <nhorman@tuxdriver.com>
    bonding: Fix broken promiscuity reference counting issue

Peter Korsgaard <peter@korsgaard.com>
    dm9601: fix IFF_ALLMULTI handling

Pravin B Shelar <pshelar@nicira.com>
    ip_tunnel: Do not use stale inner_iph pointer.

Eric Dumazet <edumazet@google.com>
    net: net_secret should not depend on TCP

Catalin(ux) M. BOIE <catab@embedromix.ro>
    IPv6 NAT: Do not drop DNATed 6to4/6rd packets

Roger Luethi <rl@hellgate.ch>
    via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: udp packets following an UFO enqueued packet need also be handled by UFO

Mikulas Patocka <mpatocka@redhat.com>
    skge: fix invalid value passed to pci_unmap_sigle

Ansis Atteka <aatteka@nicira.com>
    ip: generate unique IP identificator if local fragmentation is allowed

Ansis Atteka <aatteka@nicira.com>
    ip: use ip_hdr() in __ip_make_skb() to retrieve IP header

Duan Jiong <duanj.fnst@cn.fujitsu.com>
    net:dccp: do not report ICMP redirects to user space

Antonio Quartulli <antonio@open-mesh.com>
    batman-adv: set the TAG flag for the vid passed to BLA

Sridhar Samudrala <sri@us.ibm.com>
    vxlan: Avoid creating fdb entry with NULL destination

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    ethernet/arc/arc_emac: Fix huge delays in large file copies

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: rfc4443: do not report ICMP redirects to user space

Ding Zhi <zhi.ding@6wind.com>
    ip6_tunnels: raddr and laddr are inverted in nl msg

Hong Zhiguo <zhiguohong@tencent.com>
    bridge: fix NULL pointer deref of br_port_get_rcu

Hong Zhiguo <zhiguohong@tencent.com>
    bridge: use br_port_get_rtnl within rtnl lock

Herbert Xu <herbert@gondor.apana.org.au>
    bridge: Clamp forward_delay when enabling STP

Chris Healy <cphealy@gmail.com>
    resubmit bridge: fix message_age_timer calculation

David Vrabel <david.vrabel@citrix.com>
    xen-netback: count number required slots for an skb more carefully

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit

Jason Wang <jasowang@redhat.com>
    tuntap: correctly handle error in tun_set_iff()

Nikolay Aleksandrov <nikolay@redhat.com>
    netpoll: fix NULL pointer dereference in netpoll_cleanup

Sonic Zhang <sonic.zhang@analog.com>
    netpoll: Should handle ETH_P_ARP other than ETH_P_IP in netpoll_neigh_reply

Francois Romieu <romieu@fr.zoreil.com>
    r8169: enforce RX_MULTI_EN for the 8168f.

Vimalkumar <j.vimal@gmail.com>
    net_sched: htb: fix a typo in htb_change_class()

Eric Dumazet <edumazet@google.com>
    net: flow_dissector: fix thoff for IPPROTO_AH

Eric Dumazet <edumazet@google.com>
    net: fix multiqueue selection

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix smatch warning in sctp_send_asconf_del_ip

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix bug in sctp_poll for SOCK_SELECT_ERR_QUEUE

Daniel Borkmann <dborkman@redhat.com>
    net: fib: fib6_add: fix potential NULL pointer dereference

Jiri Pirko <jiri@resnulli.us>
    ipv6/exthdrs: accept tlv which includes only padding

Dave Jones <davej@redhat.com>
    tcp: Add missing braces to do_tcp_setsockopt

Dave Jones <davej@redhat.com>
    caif: Add missing braces to multiline if in cfctrl_linkup_request

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    sh_eth: fix napi_{en|dis}able() calls racing against interrupts

Jiri Kosina <jkosina@suse.cz>
    HID: fix unused rsize usage

Jiri Kosina <jkosina@suse.cz>
    HID: fix data access in implement()

Dan Carpenter <dan.carpenter@oracle.com>
    cciss: fix info leak in cciss_ioctl32_passthru()

Dan Carpenter <dan.carpenter@oracle.com>
    cpqarray: fix info leak in ida_locked_ioctl()

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix leak of inode reference on delegation failure


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/configs/multi_v7_defconfig                |   1 +
 arch/arm/kvm/reset.c                               |   6 +-
 arch/arm/mach-integrator/pci_v3.h                  |   7 +
 arch/arm/mach-tegra/Kconfig                        |  21 +--
 arch/avr32/kernel/time.c                           |   9 +-
 arch/powerpc/kernel/iommu.c                        |   2 +-
 arch/powerpc/kernel/sysfs.c                        |  18 ++-
 arch/powerpc/kernel/tm.S                           |  95 +++++++++----
 arch/powerpc/kernel/vio.c                          |  12 +-
 arch/powerpc/lib/checksum_64.S                     |  58 +++++---
 arch/powerpc/mm/init_64.c                          |   4 +
 arch/powerpc/mm/mem.c                              |   9 ++
 arch/powerpc/perf/power8-pmu.c                     |   5 +-
 arch/s390/kernel/entry.S                           |   1 +
 arch/s390/kernel/entry64.S                         |   1 +
 arch/sparc/kernel/ds.c                             |   5 +-
 arch/sparc/kernel/entry.S                          |   2 +-
 arch/sparc/kernel/ktlb.S                           |   3 +-
 arch/sparc/kernel/syscalls.S                       |   8 +-
 arch/sparc/kernel/trampoline_64.S                  |   2 -
 arch/sparc/lib/ksyms.c                             |   9 --
 arch/tile/include/asm/percpu.h                     |  34 ++++-
 drivers/acpi/acpi_ipmi.c                           |  24 ++--
 drivers/block/cciss.c                              |   1 +
 drivers/block/cpqarray.c                           |   1 +
 drivers/bluetooth/ath3k.c                          |   2 +
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/dma/imx-dma.c                              |  31 ++--
 drivers/gpio/gpio-omap.c                           | 158 +++++++++++++--------
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |  19 ++-
 drivers/gpu/drm/radeon/radeon_asic.c               |   4 +-
 drivers/hid/Kconfig                                |   1 +
 drivers/hid/hid-core.c                             |  21 ++-
 drivers/hid/hid-holtek-mouse.c                     |   4 +
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-logitech-dj.c                      |  12 +-
 drivers/hid/hid-picolcd_debugfs.c                  |  23 +--
 drivers/hid/hid-roccat-konepure.c                  |   3 +-
 drivers/hid/hid-wiimote-modules.c                  |  40 ++++--
 drivers/hid/hid-wiimote.h                          |   4 +-
 drivers/hid/uhid.c                                 |   4 +-
 drivers/hid/usbhid/hid-core.c                      |   5 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  14 +-
 drivers/iommu/arm-smmu.c                           |  13 +-
 drivers/md/bcache/request.c                        |   3 +-
 drivers/mmc/card/block.c                           |   2 +-
 drivers/net/bonding/bond_main.c                    |  13 +-
 drivers/net/ethernet/arc/emac_main.c               |   4 +-
 drivers/net/ethernet/marvell/skge.c                |   9 +-
 drivers/net/ethernet/realtek/r8169.c               |   1 +
 drivers/net/ethernet/renesas/sh_eth.c              |  12 +-
 drivers/net/ethernet/via/via-rhine.c               |   9 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   6 +
 drivers/net/ppp/pptp.c                             |   2 +-
 drivers/net/tun.c                                  |  11 +-
 drivers/net/usb/dm9601.c                           |   2 +-
 drivers/net/usb/qmi_wwan.c                         | 130 ++++++++++++++++-
 drivers/net/vxlan.c                                |  20 +--
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  28 ++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   3 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  14 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   2 +-
 drivers/net/wireless/mwifiex/11n_aggr.c            |   3 +-
 drivers/net/wireless/mwifiex/11n_aggr.h            |   2 +-
 drivers/net/wireless/mwifiex/cmdevt.c              |   5 +-
 drivers/net/wireless/mwifiex/usb.c                 |   7 -
 drivers/net/wireless/mwifiex/wmm.c                 |   3 +-
 drivers/net/wireless/p54/p54usb.c                  |   1 +
 drivers/net/wireless/rtlwifi/wifi.h                |   2 +-
 drivers/net/xen-netback/netback.c                  |  94 ++++++++----
 drivers/regulator/ti-abb-regulator.c               |  16 ++-
 drivers/scsi/esp_scsi.c                            |  14 +-
 drivers/scsi/esp_scsi.h                            |   1 +
 drivers/staging/comedi/drivers/ni_65xx.c           |  25 ++--
 drivers/target/iscsi/iscsi_target_util.c           |   4 +-
 drivers/tty/hvc/hvc_xen.c                          |   1 +
 drivers/usb/chipidea/ci_hdrc_pci.c                 |   7 +-
 drivers/usb/serial/option.c                        |   3 +
 fs/binfmt_elf.c                                    |  30 ++--
 fs/btrfs/extent-tree.c                             |   3 +-
 fs/btrfs/inode.c                                   |   3 +-
 fs/btrfs/relocation.c                              |  14 +-
 fs/btrfs/send.c                                    |   3 +-
 fs/fuse/file.c                                     |  23 ++-
 fs/nfs/nfs4filelayoutdev.c                         |  18 +--
 fs/nfsd/nfs4state.c                                |  31 ++--
 fs/nilfs2/page.c                                   |   2 +
 fs/nilfs2/segment.c                                |  11 +-
 fs/xfs/xfs_da_btree.c                              |   5 +-
 include/asm-generic/hugetlb.h                      |   4 +-
 include/linux/balloon_compaction.h                 |  25 ++++
 include/linux/hid.h                                |   1 +
 include/linux/miscdevice.h                         |   1 +
 include/net/addrconf.h                             |   4 +
 include/net/bluetooth/hci.h                        |   1 +
 include/net/ip.h                                   |  12 +-
 include/net/secure_seq.h                           |   1 -
 ipc/msg.c                                          |  32 ++++-
 ipc/sem.c                                          | 156 ++++++++++++--------
 ipc/shm.c                                          |  17 ++-
 ipc/util.c                                         |  32 ++---
 ipc/util.h                                         |  10 +-
 kernel/kmod.c                                      |   4 +
 kernel/softirq.c                                   |  15 +-
 mm/Kconfig                                         |   2 +-
 mm/bounce.c                                        |   2 +
 mm/migrate.c                                       |   2 +-
 mm/vmscan.c                                        |   4 +-
 net/batman-adv/soft-interface.c                    |   2 +
 net/bluetooth/hci_core.c                           |  26 +++-
 net/bluetooth/hci_event.c                          |   6 +-
 net/bluetooth/hidp/core.c                          |  15 +-
 net/bridge/br_netlink.c                            |   4 +-
 net/bridge/br_private.h                            |   8 +-
 net/bridge/br_stp.c                                |  23 ++-
 net/bridge/br_stp_if.c                             |  12 +-
 net/caif/cfctrl.c                                  |   3 +-
 net/core/flow_dissector.c                          |   6 +-
 net/core/netpoll.c                                 |  11 +-
 net/core/secure_seq.c                              |  27 +++-
 net/dccp/ipv6.c                                    |   1 +
 net/ipv4/af_inet.c                                 |   4 +-
 net/ipv4/igmp.c                                    |   8 +-
 net/ipv4/inetpeer.c                                |   4 +-
 net/ipv4/ip_output.c                               |   8 +-
 net/ipv4/ip_tunnel.c                               |  15 +-
 net/ipv4/ip_tunnel_core.c                          |   2 +-
 net/ipv4/ipmr.c                                    |   2 +-
 net/ipv4/raw.c                                     |   2 +-
 net/ipv4/tcp.c                                     |   3 +-
 net/ipv4/xfrm4_mode_tunnel.c                       |   2 +-
 net/ipv6/addrconf.c                                |  27 ++++
 net/ipv6/exthdrs.c                                 |   6 -
 net/ipv6/ip6_fib.c                                 |   2 +-
 net/ipv6/ip6_gre.c                                 |   4 +-
 net/ipv6/ip6_output.c                              |  53 +++----
 net/ipv6/ip6_tunnel.c                              |   5 +-
 net/ipv6/mcast.c                                   |   6 +-
 net/ipv6/sit.c                                     |  85 +++++++++--
 net/netfilter/ipvs/ip_vs_xmit.c                    |   2 +-
 net/sched/sch_htb.c                                |   2 +-
 net/sctp/input.c                                   |   3 +-
 net/sctp/ipv6.c                                    |  44 ++----
 net/sctp/socket.c                                  |   5 +-
 net/sysctl_net.c                                   |   4 +-
 sound/pci/hda/patch_conexant.c                     |  11 ++
 sound/soc/codecs/88pm860x-codec.c                  |   3 +
 sound/soc/codecs/ab8500-codec.c                    |   7 +-
 sound/soc/codecs/max98095.c                        |   4 +-
 150 files changed, 1414 insertions(+), 684 deletions(-)


