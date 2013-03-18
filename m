Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3CRVGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:06:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3CRVGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/75] 3.8.4-stable review
Date: Mon, 18 Mar 2013 14:06:23 -0700
Message-Id: <20130318210510.203500214@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.8.4 release.
There are 75 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Mar 20 21:04:55 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.8.4-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drm/i915: reorder setup sequence to have irqs for output setup"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drm/i915: enable irqs earlier when resuming"

YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    6lowpan: Fix endianness issue in is_addr_link_local().

Mathias Krause <minipli@googlemail.com>
    dcbnl: fix various netlink info leaks

Mathias Krause <minipli@googlemail.com>
    rtnl: fix info leak on RTM_GETLINK request for VF devices

Mathias Krause <minipli@googlemail.com>
    bridge: fix mdb info leaks

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: stop multicast forwarding to process interface scoped addresses

Cristian Bercaru <B43982@freescale.com>
    bridging: fix rx_handlers return code

Paul Moore <pmoore@redhat.com>
    netlabel: correctly list all the static label mappings

Vlad Yasevich <vyasevic@redhat.com>
    macvlan: Set IFF_UNICAST_FLT flag to prevent unnecessary promisc mode.

Vlad Yasevich <vyasevic@redhat.com>
    team: unsyc the devices addresses when port is removed

Veaceslav Falico <vfalico@redhat.com>
    bonding: fire NETDEV_RELEASE event only on 0 slaves

Zang MingJie <zealot0630@gmail.com>
    vxlan: fix oops when delete netns containing vxlan

Eric Dumazet <edumazet@google.com>
    tun: add a missing nf_reset() in tun_net_xmit()

Neal Cardwell <ncardwell@google.com>
    tcp: fix double-counted receiver RTT when leaving receiver fast path

Lorenzo Colitti <lorenzo@google.com>
    net: ipv6: Don't purge default router if accept_ra=2

Cong Wang <amwang@redhat.com>
    rds: limit the size allocated by rds_message_alloc()

Huang, Xiong <xiong@qca.qualcomm.com>
    atl1c: restore buffer state

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: Restore socket refcount when sendmsg succeeds

Guenter Roeck <linux@roeck-us.net>
    net/sctp: Validate parameter size for SCTP_GET_ASSOC_STATS

Guo Chao <yan@linux.vnet.ibm.com>
    loopdev: remove an user triggerable oops

Guo Chao <yan@linux.vnet.ibm.com>
    loopdev: fix a deadlock

Guo Chao <yan@linux.vnet.ibm.com>
    block: use i_size_write() in bd_set_size()

Amir Vadai <amirv@mellanox.com>
    net/mlx4_en: Disable RFS when running in SRIOV mode

Amir Vadai <amirv@mellanox.com>
    net/mlx4_en: Initialize RFS filters lock and list in init_netdev

Johan Hovold <jhovold@gmail.com>
    atmel_lcdfb: fix 16-bpp modes on older SOCs

Sam Ravnborg <sam@ravnborg.org>
    kbuild: fix make headers_check with make 3.80

Brian Norris <computersforpeace@gmail.com>
    mtd: nand: reintroduce NAND_NO_READRDY as NAND_NEED_READRDY

Eric Sandeen <sandeen@redhat.com>
    btrfs: use rcu_barrier() to wait for bdev puts at unmount

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/mm: fix flush_tlb_kernel_range()

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390: critical section cleanup vs. machine checks

David Rientjes <rientjes@google.com>
    perf,x86: fix link failure for non-Intel configs

Linus Torvalds <torvalds@linux-foundation.org>
    perf,x86: fix wrmsr_on_cpu() warning on suspend/resume

Dan Carpenter <dan.carpenter@oracle.com>
    selinux: use GFP_ATOMIC under spin_lock

Matt Porter <mporter@ti.com>
    ARM: davinci: edma: fix dmaengine induced null pointer dereference on da830

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc: Rename USER_ESID_BITS* to ESID_BITS*

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc: Update kernel VSID range

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc: Make VSID_BITS* dependency explicit

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc: Fix cputable entry for 970MP rev 1.0

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc: Fix STAB initialization

Marcin Jurkowski <marcin1j@gmail.com>
    w1: fix oops when w1_search is called from netlink connector

Johan Hovold <jhovold@gmail.com>
    w1-gpio: remove erroneous __exit and __exit_p()

Axel Lin <axel.lin@ingics.com>
    hwmon: (lineage-pem) Add missing terminating entry for pem_[input|fan]_attributes

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/ltc2978) Fix temperature reporting

Johan Hovold <jhovold@gmail.com>
    ARM: w1-gpio: fix erroneous gpio requests

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix missing error handling in snd_seq_timer_open()

Stephane Eranian <eranian@google.com>
    perf,x86: fix kernel crash with PEBS/BTS after suspend/resume

Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    ARM: kirkwood: fix to retain gbe MAC addresses for DT kernels

Scott Ashcroft <scott.ashcroft@talk21.com>
    Fix 4 port and add support for 8 port 'Unknown' PCI serial port cards

Jiri Slaby <jslaby@suse.cz>
    TTY: do not reset master's packet mode

Jiri Slaby <jslaby@suse.cz>
    TTY: disable debugging warning

Ley Foon Tan <lftan@altera.com>
    tty/serial: Add support for Altera serial port

Paul Bolle <pebolle@tiscali.nl>
    tty: serial: fix typo "SERIAL_S3C2412"

Paul Bolle <pebolle@tiscali.nl>
    tty: serial: fix typo "ARCH_S5P6450"

Wang YanQing <udknight@gmail.com>
    serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller

Josh Boyer <jwboyer@redhat.com>
    serial: 8250: Keep 8250.<xxxx> module options functional after driver rename

Sean Young <sean@mess.org>
    tty/8250_pnp: serial port detection regression since v3.7

Lars-Peter Clausen <lars@metafoo.de>
    ext3: Fix format string issues

Kees Cook <keescook@chromium.org>
    signal: always clear sa_restorer on execve

Dan Williams <dcbw@redhat.com>
    qcserial: bind to DM/DIAG port on Gobi 1K devices

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: dt9812: use CR_CHAN() for channel number

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix oops on resume from suspend.

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: don't check DMA values in QH overlays

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: work around silicon bug in Intel's EHCI controllers

Bjørn Mork <bjorn@mork.no>
    USB: storage: fix Huawei mode switching regression

Steve Conklin <sconklin@canonical.com>
    usb: serial: Add Rigblaster Advantage to device table

Christian Schmiedl <christian.schmiedl@gemalto.com>
    USB: added support for Cinterion's products AH6 and PLS8

Matwey V. Kornilov <matwey@sai.msu.ru>
    usb: cp210x new Vendor/Device IDs

Felipe Balbi <balbi@ti.com>
    usb: dwc3: core: don't forget to free coherent memory

Maxin B. John <maxin.john@enea.com>
    tools: usb: ffs-test: Fix build failure

Oliver Neukum <oneukum@suse.de>
    USB: cdc-wdm: fix buffer overflow

Bjørn Mork <bjorn@mork.no>
    USB: option: add Huawei E5331

Amit Shah <amit.shah@redhat.com>
    virtio: rng: disallow multiple device registrations, fixes crashes

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pciback: Don't disable a PCI device that is already disabled.

Dan Williams <dcbw@redhat.com>
    qcaux: add Franklin U600


-------------

Diffstat:

 .../devicetree/bindings/tty/serial/of-serial.txt   |   3 +
 Makefile                                           |   4 +-
 arch/arm/mach-at91/board-foxg20.c                  |   1 +
 arch/arm/mach-at91/board-stamp9g20.c               |   1 +
 arch/arm/mach-davinci/dma.c                        |   3 +
 arch/arm/mach-ixp4xx/vulcan-setup.c                |   1 +
 arch/arm/mach-kirkwood/board-dt.c                  |  24 +-
 arch/arm/mach-pxa/raumfeld.c                       |   1 +
 arch/powerpc/include/asm/mmu-hash64.h              | 128 ++++----
 arch/powerpc/kernel/cputable.c                     |   2 +-
 arch/powerpc/kernel/exceptions-64s.S               |  34 ++-
 arch/powerpc/kvm/book3s_64_mmu_host.c              |   4 +-
 arch/powerpc/mm/hash_utils_64.c                    |  22 +-
 arch/powerpc/mm/mmu_context_hash64.c               |  11 +-
 arch/powerpc/mm/pgtable_64.c                       |   2 +-
 arch/powerpc/mm/slb_low.S                          |  50 ++--
 arch/powerpc/mm/tlb_hash64.c                       |   2 +-
 arch/s390/include/asm/tlbflush.h                   |   2 -
 arch/s390/kernel/entry.S                           |   3 +-
 arch/s390/kernel/entry64.S                         |   5 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |  10 +
 arch/x86/power/cpu.c                               |   2 +
 drivers/block/loop.c                               |  24 +-
 drivers/char/hw_random/virtio-rng.c                |  13 +-
 drivers/gpu/drm/i915/i915_dma.c                    |  23 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  13 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   1 -
 drivers/gpu/drm/i915/i915_irq.c                    |   4 -
 drivers/hwmon/lineage-pem.c                        |   2 +
 drivers/hwmon/pmbus/ltc2978.c                      |  14 +-
 drivers/mtd/nand/nand_base.c                       |  16 +
 drivers/mtd/nand/nand_ids.c                        |  80 ++---
 drivers/net/bonding/bond_main.c                    |   5 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |  16 +-
 drivers/net/macvlan.c                              |   1 +
 drivers/net/team/team.c                            |   2 +
 drivers/net/tun.c                                  |   2 +
 drivers/net/vxlan.c                                |   9 +
 drivers/staging/comedi/drivers/dt9812.c            |  16 +-
 drivers/staging/vt6656/main_usb.c                  |   4 -
 drivers/tty/pty.c                                  |   1 -
 drivers/tty/serial/8250/8250.c                     |  52 +++-
 drivers/tty/serial/8250/8250_pci.c                 |  21 +-
 drivers/tty/serial/8250/8250_pnp.c                 |  12 +-
 drivers/tty/serial/Kconfig                         |   4 +-
 drivers/tty/serial/of_serial.c                     |   6 +
 drivers/tty/tty_buffer.c                           |   2 +-
 drivers/usb/class/cdc-wdm.c                        |  23 +-
 drivers/usb/dwc3/core.c                            |   1 +
 drivers/usb/host/ehci-hcd.c                        |   6 +-
 drivers/usb/host/ehci-q.c                          |  36 ++-
 drivers/usb/serial/cp210x.c                        |  20 ++
 drivers/usb/serial/option.c                        |   5 +
 drivers/usb/serial/qcaux.c                         |   1 +
 drivers/usb/serial/qcserial.c                      |   7 +-
 drivers/usb/storage/initializers.c                 |  76 +----
 drivers/usb/storage/initializers.h                 |   4 +-
 drivers/usb/storage/unusual_devs.h                 | 329 ++++++++++++++++++++-
 drivers/video/atmel_lcdfb.c                        |  22 +-
 drivers/w1/masters/w1-gpio.c                       |   4 +-
 drivers/w1/w1.c                                    |   3 +-
 drivers/xen/xen-pciback/pciback_ops.c              |   3 +-
 fs/block_dev.c                                     |   4 +-
 fs/btrfs/volumes.c                                 |   6 +
 fs/ext3/super.c                                    |   4 +-
 include/linux/mtd/nand.h                           |   7 +
 include/linux/perf_event.h                         |   6 +
 include/uapi/linux/serial_core.h                   |   5 +-
 include/video/atmel_lcdc.h                         |   1 +
 kernel/signal.c                                    |   3 +
 net/bridge/br_mdb.c                                |   4 +
 net/core/dev.c                                     |   1 +
 net/core/rtnetlink.c                               |   1 +
 net/dcb/dcbnl.c                                    |   8 +
 net/ieee802154/6lowpan.h                           |   2 +-
 net/ipv4/tcp_input.c                               |   6 +-
 net/ipv6/ip6_input.c                               |   3 +-
 net/ipv6/route.c                                   |   3 +-
 net/l2tp/l2tp_ppp.c                                |   1 +
 net/netlabel/netlabel_unlabeled.c                  |  27 +-
 net/rds/message.c                                  |   3 +
 net/sctp/socket.c                                  |   6 +-
 scripts/Makefile.headersinst                       |  11 +-
 security/selinux/xfrm.c                            |   2 +-
 sound/core/seq/seq_timer.c                         |   8 +-
 tools/usb/ffs-test.c                               |   2 +-
 87 files changed, 920 insertions(+), 404 deletions(-)


