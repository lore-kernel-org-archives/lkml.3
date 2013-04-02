Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391Ab3DBXX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:23:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685Ab3DBWLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:11:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 000/124] 3.8.6-stable review
Date: Tue,  2 Apr 2013 15:09:42 -0700
Message-Id: <20130402221104.163133110@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.8.6 release.
There are 124 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Apr  4 22:09:55 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.8.6-rc1

Steve Glendinning <steve.glendinning@shawell.net>
    smsc75xx: fix jumbo frame support

Veaceslav Falico <vfalico@redhat.com>
    pch_gbe: fix ip_summed checksum reporting on rx

Vijay Subramanian <subramanian.vijay@gmail.com>
    net: fq_codel: Fix off-by-one error

Li RongQing <roy.qing.li@gmail.com>
    net: fix the use of this_cpu_ptr

Lothar Waßmann <LW@KARO-electronics.de>
    net: ethernet: cpsw: fix erroneous condition in error check

Eric Dumazet <edumazet@google.com>
    net: add a synchronize_net() in netdev_rx_handler_unregister()

Max.Nekludov@us.elster.com <Max.Nekludov@us.elster.com>
    ks8851: Fix interpretation of rxlen field.

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: don't accept node local multicast traffic from the wire

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: don't accept multicast traffic with scope 0

Hong Zhiguo <honkiko@gmail.com>
    ipv6: fix bad free of addrconf_init_net

Fabio Estevam <fabio.estevam@freescale.com>
    fec: Fix the build as module

Joseph CHANG <josright123@gmail.com>
    DM9000B: driver initialization upgrade

Hannes Frederic Sowa <hannes@stressinduktion.org>
    atl1e: drop pci-msi support because of packet corruption

Eric Dumazet <edumazet@google.com>
    aoe: reserve enough headroom on skbs

Andrey Vagin <avagin@openvz.org>
    net: fix *_DIAG_MAX constants

Mugunthan V N <mugunthanvnm@ti.com>
    drivers: net: ethernet: cpsw: use netif_wake_queue() while restarting tx queue

Mugunthan V N <mugunthanvnm@ti.com>
    drivers: net: ethernet: davinci_emac: use netif_wake_queue() while restarting tx queue

nikolay@redhat.com <nikolay@redhat.com>
    bonding: fix disabling of arp_interval and miimon

Veaceslav Falico <vfalico@redhat.com>
    bonding: remove already created master sysfs link on failure

dingtianhong <dingtianhong@huawei.com>
    af_unix: dont send SCM_CREDENTIAL when dest socket is NULL

Paul Moore <pmoore@redhat.com>
    unix: fix a race condition in unix_release()

Masatake YAMATO <yamato@redhat.com>
    thermal: shorten too long mcast group name

Cong Wang <amwang@redhat.com>
    8021q: fix a potential use-after-free

Yuchung Cheng <ycheng@google.com>
    tcp: undo spurious timeout after SACK reneging

Eric Dumazet <edumazet@google.com>
    tcp: preserve ACK clocking in TSO

Mirko Lindner <mlindner@marvell.com>
    sky2: Threshold for Pause Packet is set wrong

Mirko Lindner <mlindner@marvell.com>
    sky2: Receive Overflows not counted

Eric Dumazet <edumazet@google.com>
    net: remove a WARN_ON() in net_enable_timestamp()

Russ Dill <Russ.Dill@ti.com>
    regulator: Fix memory garbage dev_err printout.

Matt Fleming <matt.fleming@intel.com>
    efivars: Handle duplicate names from get_next_variable()

Matt Fleming <matt.fleming@intel.com>
    efivars: explicitly calculate length of VariableName

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Prevent buffer overwrite disabled for latency tracers

David Vrabel <david.vrabel@citrix.com>
    xen/events: avoid race with raising an event in unmask_evtchn()

Josef Bacik <jbacik@fusionio.com>
    Btrfs: fix space leak when we fail to reserve metadata space

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dvm: don't send HCMD in restart flow

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Don't clobber crtc->fb when queue_flip fails

Takashi Iwai <tiwai@suse.de>
    drm/i915: Use the fixed pixel clock for eDP in intel_dp_set_m_n()

J. Bruce Fields <bfields@redhat.com>
    nfsd4: reject "negative" acl lengths

Amit Shah <amit.shah@redhat.com>
    virtio: console: add locking around c_ovq operations

Amit Shah <amit.shah@redhat.com>
    virtio: console: rename cvq_lock to c_ivq_lock

Rajendra Nayak <rnayak@ti.com>
    ARM: OMAP: clocks: Delay clk inits atleast until slab is initialized

Eric Hutter <hutter.eric@gmail.com>
    ARM: kirkwood: Fix chip-delay for GoFlex Net

Shawn Guo <shawn.guo@linaro.org>
    ARM: imx: fix sync issue between imx_cpu_die and imx_cpu_kill

Mac Lin <mkl0301@gmail.com>
    ARM: cns3xxx: fix mapping of private memory region

Anatol Pomozov <anatol.pomozov@gmail.com>
    loop: prevent bdev freeing while device in use

Andrew Morton <akpm@linux-foundation.org>
    kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER

Ben Hutchings <ben@decadent.org.uk>
    signal: Define __ARCH_HAS_SA_RESTORER so we know whether to clear sa_restorer

Alan Stern <stern@rowland.harvard.edu>
    usb: gadget: udc-core: fix a regression during gadget driver unbinding

Johan Hovold <jhovold@gmail.com>
    USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: cypress_m8: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: mct_u232: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: ark3116: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: f81232: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: io_edgeport: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: ch341: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: ssu100: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: spcp8x5: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: pl2303: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: ftdi_sio: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: oti6858: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix broken TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: quatech2: fix use-after-free in TIOCMIWAIT

Ming Lei <tom.leiming@gmail.com>
    USB: serial: fix hang when opening port

Johan Hovold <jhovold@gmail.com>
    USB: serial: add modem-status-change wait queue

Josef Bacik <jbacik@fusionio.com>
    Btrfs: don't drop path when printing out tree errors in scrub

Josef Bacik <jbacik@fusionio.com>
    Btrfs: limit the global reserve to 512mb

Chris Mason <chris.mason@fusionio.com>
    Btrfs: fix race between mmap writes and compression

Jan Schmidt <list.btrfs@jan-o-sch.net>
    Btrfs: fix locking on ROOT_REPLACE operations in tree mod log

Josef Bacik <jbacik@fusionio.com>
    Btrfs: use set_nlink if our i_nlink is 0

Eric W. Biederman <ebiederm@xmission.com>
    userns: Restrict when proc and sysfs can be mounted

Eric W. Biederman <ebiederm@xmission.com>
    ipc: Restrict mounting the mqueue filesystem

Eric W. Biederman <ebiederm@xmission.com>
    vfs: Carefully propogate mounts across user namespaces

Eric W. Biederman <ebiederm@xmission.com>
    vfs: Add a mount flag to lock read only bind mounts

Eric W. Biederman <ebiederm@xmission.com>
    userns: Don't allow creation if the user is chrooted

Eric W. Biederman <ebiederm@xmission.com>
    pid: Handle the exit of a multi-threaded init.

Eric W. Biederman <ebiederm@xmission.com>
    scm: Require CAP_SYS_ADMIN over the current pidns to spoof pids.

Johannes Berg <johannes.berg@intel.com>
    mac80211: prevent spurious HT/VHT downgrade message

Hans de Goede <hdegoede@redhat.com>
    media: [REGRESSION] bt8xx: Fix too large height in cropcap

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix RESERVATION_CONFLICT status regression for iscsi-target special case

Vivek Gautam <gautam.vivek@samsung.com>
    usb: xhci: Fix TRB transfer length macro used for Event TRB.

Soeren Moch <smoch@web.de>
    USB: EHCI: fix bug in iTD/siTD DMA pool allocation

Al Viro <viro@zeniv.linux.org.uk>
    Nest rename_lock inside vfsmount_lock

Kees Cook <keescook@chromium.org>
    net/irda: add missing error path release_sock call

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4.1: Always clear the NFS_INO_LAYOUTCOMMIT in layoutreturn

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4.1: Fix a race in pNFS layoutcommit

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Fix the string length returned by the idmapper

fanchaoting <fanchaoting@cn.fujitsu.com>
    pnfs-block: removing DM device maybe cause oops when call dev_remove

Bing Zhao <bzhao@marvell.com>
    mwifiex: cancel cmd timer and free curr_cmd in shutdown process

Bing Zhao <bzhao@marvell.com>
    mwifiex: skip pending commands after function shutdown

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: fix race when queuing commands

Al Viro <viro@zeniv.linux.org.uk>
    vt: synchronize_rcu() under spinlock is not nice...

Konstantin Holoborodko <klh.kernel@gmail.com>
    usb: ftdi_sio: Add support for Mitsubishi FX-USB-AW/-BD

Pawel Wieczorkiewicz <wpawel@gmail.com>
    tty: atmel_serial_probe(): index of atmel_ports[] fix

Roger Pau Monne <roger.pau@citrix.com>
    xen-blkfront: switch from llist to list

Jan Beulich <JBeulich@suse.com>
    xen-blkback: fix dispatch_rw_block_io() error path

David Vrabel <david.vrabel@citrix.com>
    xen/blkback: correctly respond to unknown, non-native requests

Jan Beulich <JBeulich@suse.com>
    xen-pciback: notify hypervisor about devices intended to be assigned to guests

Joerg Roedel <joro@8bytes.org>
    iommu/amd: Make sure dma_ops are set for hotplug devices

Johannes Berg <johannes.berg@intel.com>
    mac80211: always synchronize_net() during station removal

Kees Cook <keescook@chromium.org>
    tg3: fix length overflow in VPD firmware parsing

Rafał Miłecki <zajec5@gmail.com>
    b43: N-PHY: use more bits for offset in RSSI calibration

Iestyn C. Elfick <isedev@gmail.com>
    b43: A fix for DMA transmission sequence errors

Rafał Miłecki <zajec5@gmail.com>
    b43: N-PHY: increase initial value of "mind" in RSSI calibration

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: fix length check in multi-TB HCMD

Jussi Kivilinna <jussi.kivilinna@iki.fi>
    rtlwifi: usb: add missing freeing of skbuff

Jiri Kosina <jkosina@suse.cz>
    HID: usbhid: fix build problem

Josh Boyer <jwboyer@redhat.com>
    HID: usbhid: quirk for MSI GX680R led panel

Josh Boyer <jwboyer@redhat.com>
    HID: usbhid: quirk for Realtek Multi-card reader

Luis R. Rodriguez <mcgrof@do-not-panic.com>
    ath9k: avoid queueing hw check work when suspended

Felix Fietkau <nbd@openwrt.org>
    ath9k: limit tx path hang check to normal data queues

Felix Fietkau <nbd@openwrt.org>
    ath9k_hw: revert chainmask to user configuration after calibration

Marc Kleine-Budde <mkl@pengutronix.de>
    can: sja1000: fix define conflict on SH

Ming Lei <ming.lei@canonical.com>
    sysfs: handle failure path correctly for readdir()

Ming Lei <ming.lei@canonical.com>
    sysfs: fix race between readdir and lseek

Horia Geanta <horia.geanta@freescale.com>
    Revert "crypto: caam - add IPsec ESN support"

Horia Geanta <horia.geanta@freescale.com>
    Revert "crypto: talitos - add IPsec ESN support"

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: s626: fix continuous acquisition

Ming Lei <ming.lei@canonical.com>
    Bluetooth: Add support for Dell[QCA 0cf3:817a]

Ming Lei <ming.lei@canonical.com>
    Bluetooth: Add support for Dell[QCA 0cf3:0036]

Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
    Bluetooth: Fix not closing SCO sockets in the BT_CONNECT2 state

Chris Metcalf <cmetcalf@tilera.com>
    tile: expect new initramfs name from hypervisor file system

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queue_locked


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/kirkwood-goflexnet.dts           |   1 +
 arch/arm/include/asm/signal.h                      |   1 +
 arch/arm/mach-cns3xxx/core.c                       |  16 +-
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h       |  16 +-
 arch/arm/mach-imx/common.h                         |   2 +
 arch/arm/mach-imx/hotplug.c                        |  12 ++
 arch/arm/mach-imx/src.c                            |  12 ++
 arch/arm/mach-omap2/common.h                       |   3 +
 arch/arm/mach-omap2/io.c                           |  18 +-
 arch/arm/mach-omap2/timer.c                        |   4 +
 arch/avr32/include/asm/signal.h                    |   1 +
 arch/cris/include/asm/signal.h                     |   1 +
 arch/h8300/include/asm/signal.h                    |   1 +
 arch/m32r/include/asm/signal.h                     |   1 +
 arch/m68k/include/asm/signal.h                     |   1 +
 arch/mn10300/include/asm/signal.h                  |   1 +
 arch/powerpc/include/asm/signal.h                  |   1 +
 arch/s390/include/asm/signal.h                     |   1 +
 arch/sparc/include/asm/signal.h                    |   2 +
 arch/tile/kernel/setup.c                           |  25 ++-
 arch/x86/include/asm/signal.h                      |   3 +
 arch/x86/include/asm/xen/hypercall.h               |   4 +-
 arch/xtensa/include/asm/signal.h                   |   1 +
 drivers/block/aoe/aoecmd.c                         |   3 +-
 drivers/block/loop.c                               |   9 +-
 drivers/block/xen-blkback/blkback.c                |  38 +++-
 drivers/block/xen-blkback/common.h                 |  25 +++
 drivers/block/xen-blkfront.c                       |  41 ++--
 drivers/bluetooth/ath3k.c                          |   4 +
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/char/virtio_console.c                      |  22 ++-
 drivers/crypto/caam/caamalg.c                      |  27 +--
 drivers/crypto/caam/compat.h                       |   1 -
 drivers/crypto/talitos.c                           |  30 +--
 drivers/firmware/efivars.c                         |  87 +++++++++
 drivers/gpu/drm/i915/intel_display.c               |  11 +-
 drivers/gpu/drm/i915/intel_dp.c                    |  12 +-
 drivers/hid/hid-ids.h                              |   6 +
 drivers/hid/usbhid/hid-quirks.c                    |   2 +
 drivers/iommu/amd_iommu.c                          |  22 +--
 drivers/media/pci/bt8xx/bttv-driver.c              |  20 +-
 drivers/net/bonding/bond_sysfs.c                   |  97 +++++-----
 drivers/net/can/sja1000/plx_pci.c                  |   4 +-
 drivers/net/can/sja1000/sja1000.c                  |   6 +-
 drivers/net/can/sja1000/sja1000.h                  |   2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e.h         |   1 -
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |  19 +-
 drivers/net/ethernet/broadcom/tg3.c                |   7 +-
 drivers/net/ethernet/davicom/dm9000.c              | 214 +++++++++++----------
 drivers/net/ethernet/davicom/dm9000.h              |  11 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |   3 +
 drivers/net/ethernet/marvell/sky2.c                |   2 +-
 drivers/net/ethernet/marvell/sky2.h                |   2 +-
 drivers/net/ethernet/micrel/ks8851.c               |   2 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |   4 +-
 drivers/net/ethernet/ti/cpsw.c                     |   4 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   2 +-
 drivers/net/usb/smsc75xx.c                         |  12 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |   4 +
 drivers/net/wireless/ath/ath9k/link.c              |  29 +--
 drivers/net/wireless/b43/dma.c                     |  65 +++++--
 drivers/net/wireless/b43/phy_n.c                   |   8 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c             |   9 +
 drivers/net/wireless/iwlwifi/dvm/ucode.c           |   4 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c             |   2 +-
 drivers/net/wireless/mwifiex/cmdevt.c              |  22 ++-
 drivers/net/wireless/mwifiex/init.c                |   8 +
 drivers/net/wireless/mwifiex/main.h                |   4 +-
 drivers/net/wireless/mwifiex/scan.c                |   8 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |  10 +-
 drivers/net/wireless/rtlwifi/usb.c                 |   1 +
 drivers/regulator/core.c                           |   4 +-
 drivers/staging/comedi/drivers/s626.c              |   2 +-
 drivers/target/target_core_transport.c             |   4 +-
 drivers/tty/serial/atmel_serial.c                  |  11 +-
 drivers/tty/vt/vc_screen.c                         |   6 +-
 drivers/usb/gadget/udc-core.c                      |   2 +-
 drivers/usb/host/ehci-sched.c                      |   2 +
 drivers/usb/host/xhci-ring.c                       |  24 +--
 drivers/usb/host/xhci.h                            |   4 +
 drivers/usb/serial/ark3116.c                       |  10 +-
 drivers/usb/serial/ch341.c                         |  11 +-
 drivers/usb/serial/cypress_m8.c                    |  14 +-
 drivers/usb/serial/f81232.c                        |   9 +-
 drivers/usb/serial/ftdi_sio.c                      |  20 +-
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 drivers/usb/serial/io_edgeport.c                   |  12 +-
 drivers/usb/serial/io_ti.c                         |  12 +-
 drivers/usb/serial/mct_u232.c                      |  13 +-
 drivers/usb/serial/mos7840.c                       |  16 +-
 drivers/usb/serial/oti6858.c                       |  10 +-
 drivers/usb/serial/pl2303.c                        |  11 +-
 drivers/usb/serial/quatech2.c                      |  12 +-
 drivers/usb/serial/spcp8x5.c                       |   9 +-
 drivers/usb/serial/ssu100.c                        |  12 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |  10 +-
 drivers/usb/serial/usb-serial.c                    |   1 +
 drivers/xen/events.c                               |  20 +-
 drivers/xen/fallback.c                             |   3 +-
 drivers/xen/xen-pciback/pci_stub.c                 |  59 ++++--
 fs/block_dev.c                                     |   1 +
 fs/btrfs/ctree.c                                   |  30 ++-
 fs/btrfs/extent-tree.c                             |  49 ++++-
 fs/btrfs/extent_io.c                               |  33 ++++
 fs/btrfs/extent_io.h                               |   2 +
 fs/btrfs/inode.c                                   |  14 ++
 fs/btrfs/scrub.c                                   |   3 +-
 fs/btrfs/tree-log.c                                |   5 +-
 fs/dcache.c                                        |  16 +-
 fs/namespace.c                                     |  54 +++++-
 fs/nfs/blocklayout/blocklayoutdm.c                 |   4 +-
 fs/nfs/idmap.c                                     |  13 +-
 fs/nfs/nfs4filelayout.c                            |   1 -
 fs/nfs/nfs4proc.c                                  |  14 --
 fs/nfs/pnfs.c                                      |  54 +++++-
 fs/nfsd/nfs4xdr.c                                  |   2 +-
 fs/pnode.c                                         |   6 +
 fs/pnode.h                                         |   1 +
 fs/proc/root.c                                     |   4 +
 fs/sysfs/dir.c                                     |  17 +-
 fs/sysfs/mount.c                                   |   4 +
 include/linux/fs_struct.h                          |   2 +
 include/linux/mount.h                              |   2 +
 include/linux/thermal.h                            |   2 +-
 include/linux/usb/serial.h                         |   2 +
 include/linux/user_namespace.h                     |   4 +
 include/uapi/asm-generic/signal.h                  |   4 +
 include/uapi/linux/packet_diag.h                   |   4 +-
 include/uapi/linux/unix_diag.h                     |   4 +-
 include/xen/interface/io/blkif.h                   |  10 +
 include/xen/interface/physdev.h                    |   6 +
 ipc/mqueue.c                                       |  12 +-
 kernel/pid_namespace.c                             |   3 +-
 kernel/signal.c                                    |   2 +-
 kernel/trace/trace.c                               |  38 +++-
 kernel/trace/trace.h                               |   6 +
 kernel/trace/trace_irqsoff.c                       |  19 +-
 kernel/trace/trace_sched_wakeup.c                  |  18 +-
 kernel/user.c                                      |   2 +
 kernel/user_namespace.c                            |  11 ++
 net/8021q/vlan.c                                   |  14 +-
 net/bluetooth/sco.c                                |   1 +
 net/core/dev.c                                     |   7 +-
 net/core/flow.c                                    |   2 +-
 net/core/scm.c                                     |   4 +-
 net/ipv4/tcp_input.c                               |   7 +-
 net/ipv4/tcp_output.c                              |   7 +-
 net/ipv6/addrconf.c                                |  26 +--
 net/ipv6/ip6_input.c                               |  21 ++
 net/irda/af_irda.c                                 |   6 +-
 net/mac80211/mlme.c                                |   4 +
 net/mac80211/sta_info.c                            |  12 +-
 net/netlink/genetlink.c                            |   1 +
 net/sched/sch_fq_codel.c                           |   2 +-
 net/sunrpc/sched.c                                 |   9 +-
 net/unix/af_unix.c                                 |  11 +-
 157 files changed, 1343 insertions(+), 659 deletions(-)


