Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaACNVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:21:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43316 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbaACNVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:21:41 -0500
Message-ID: <1388755289.22017.42.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.54
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Fri, 03 Jan 2014 13:21:29 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Kk0aZEtAkWt5tFyj4BRR"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.229
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Kk0aZEtAkWt5tFyj4BRR
Content-Type: multipart/mixed; boundary="=-7n0h7Rc+HoG1NzjT31Lg"


--=-7n0h7Rc+HoG1NzjT31Lg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.54 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.53 is attached to this message.

Ben.

------------

 Documentation/sysctl/kernel.txt               |  25 ++--
 Makefile                                      |   2 +-
 arch/arm/include/asm/assembler.h              |   8 ++
 arch/arm/include/asm/uaccess.h                |  40 ++++--
 arch/arm/kernel/process.c                     |   7 +-
 arch/arm/kernel/stacktrace.c                  |   2 +-
 arch/arm/lib/getuser.S                        |  23 ++--
 arch/arm/lib/putuser.S                        |   6 +
 arch/arm/mach-footbridge/common.c             |   3 +
 arch/arm/mach-footbridge/dc21285.c            |   2 -
 arch/arm/mach-integrator/integrator_cp.c      |   3 +-
 arch/arm/mach-pxa/reset.c                     |   8 +-
 arch/arm/mach-pxa/tosa.c                      | 102 +++++++--------
 arch/arm/mach-sa1100/assabet.c                |   3 +
 arch/avr32/boot/u-boot/head.S                 |  35 +++++-
 arch/avr32/kernel/entry-avr32b.S              |   3 +-
 arch/avr32/kernel/head.S                      |  20 ---
 arch/cris/include/asm/io.h                    |   1 +
 arch/ia64/include/asm/processor.h             |   2 +-
 arch/powerpc/kernel/signal_32.c               |   6 +
 arch/powerpc/kernel/signal_64.c               |   6 +
 arch/powerpc/kernel/time.c                    |   4 +-
 arch/powerpc/kernel/vio.c                     |  12 +-
 arch/s390/crypto/aes_s390.c                   |  50 ++++----
 arch/um/os-Linux/start_up.c                   |   2 +
 arch/x86/boot/Makefile                        |   6 +-
 arch/x86/boot/compressed/Makefile             |   1 +
 arch/x86/kernel/crash.c                       |   2 +-
 arch/x86/kernel/microcode_amd.c               |   2 +-
 arch/x86/kernel/reboot.c                      |  11 +-
 arch/x86/kvm/lapic.c                          |   3 +-
 arch/x86/platform/efi/efi.c                   |   5 -
 block/blk-core.c                              |   2 +
 block/blk-timeout.c                           |   3 +-
 crypto/algif_hash.c                           |   5 +-
 crypto/algif_skcipher.c                       |   4 +-
 crypto/ansi_cprng.c                           |   4 +-
 crypto/authenc.c                              |   7 +-
 crypto/ccm.c                                  |   3 +-
 drivers/ata/ahci.c                            |   6 +
 drivers/ata/ahci_platform.c                   |   1 +
 drivers/ata/libahci.c                         |  16 +++
 drivers/ata/libata-core.c                     |   1 +
 drivers/ata/libata-transport.c                |  16 +--
 drivers/atm/idt77252.c                        |   2 +-
 drivers/block/brd.c                           |   2 +-
 drivers/block/loop.c                          |   6 +-
 drivers/char/i8k.c                            |   7 ++
 drivers/connector/cn_proc.c                   |  66 ++++++----
 drivers/gpio/gpio-mpc8xxx.c                   |   8 +-
 drivers/gpu/drm/i915/intel_display.c          |   4 +
 drivers/gpu/drm/nouveau/nouveau_gem.c         |   3 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |  28 +++++
 drivers/gpu/drm/ttm/ttm_bo.c                  |  32 +++--
 drivers/hid/hid-multitouch.c                  |   2 +-
 drivers/hwmon/lm78.c                          |   2 +
 drivers/hwmon/lm90.c                          |  11 +-
 drivers/hwmon/sis5595.c                       |   2 +
 drivers/hwmon/vt8231.c                        |   2 +-
 drivers/hwmon/w83l786ng.c                     |  14 ++-
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |   7 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c     |   6 +-
 drivers/isdn/isdnloop/isdnloop.c              |   8 +-
 drivers/isdn/mISDN/socket.c                   |  13 +-
 drivers/md/dm-bufio.c                         |   5 +
 drivers/md/dm-delay.c                         |  23 ++--
 drivers/md/dm-mpath.c                         |  18 ++-
 drivers/md/dm-snap.c                          |  71 +++++++++--
 drivers/md/dm-table.c                         |  23 +++-
 drivers/media/video/saa7164/saa7164-core.c    |   4 +-
 drivers/misc/enclosure.c                      |   7 ++
 drivers/mmc/card/block.c                      |  47 ++++++-
 drivers/mtd/devices/m25p80.c                  |  19 ++-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c        |   4 +-
 drivers/mtd/nand/nand_base.c                  |  16 ++-
 drivers/net/bonding/bond_sysfs.c              |  11 +-
 drivers/net/can/c_can/c_can.c                 |   6 +-
 drivers/net/can/sja1000/sja1000.c             |  17 +--
 drivers/net/ethernet/smsc/smc91x.h            |  22 +---
 drivers/net/ppp/pppoe.c                       |   2 -
 drivers/net/wireless/libertas/debugfs.c       |   6 +-
 drivers/net/wireless/mwifiex/sdio.c           |   3 +
 drivers/net/wireless/prism54/islpci_dev.c     |   7 +-
 drivers/net/wireless/rt2x00/rt2400pci.c       |   2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c       |   3 +
 drivers/net/wireless/rtlwifi/base.c           |  90 ++++++--------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c  |   6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c  |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c  |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c   |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c  |   2 +-
 drivers/net/wireless/rtlwifi/wifi.h           |   6 +-
 drivers/pci/pcie/portdrv_pci.c                |   1 -
 drivers/rtc/rtc-at91rm9200.c                  |   2 +
 drivers/s390/net/qeth_core_main.c             |   6 +-
 drivers/scsi/aacraid/commctrl.c               |   3 +-
 drivers/scsi/hpsa.c                           |   4 +-
 drivers/scsi/libsas/sas_ata.c                 |   2 +-
 drivers/staging/tidspbridge/Kconfig           |   2 +-
 drivers/staging/zram/zram_sysfs.c             |  25 ++--
 drivers/target/iscsi/iscsi_target_auth.c      |   5 +-
 drivers/target/iscsi/iscsi_target_nego.c      |   2 +-
 drivers/usb/class/cdc-acm.c                   |   2 +
 drivers/usb/core/hub.c                        |  16 ++-
 drivers/usb/dwc3/ep0.c                        |   2 +
 drivers/usb/dwc3/gadget.c                     |   5 +-
 drivers/usb/gadget/composite.c                |   1 +
 drivers/usb/serial/ftdi_sio.c                 |  31 +++--
 drivers/usb/serial/generic.c                  |   9 +-
 drivers/usb/serial/mos7840.c                  |  36 +++---
 drivers/usb/serial/option.c                   |  44 +++++++
 drivers/usb/serial/pl2303.c                   |  31 +++--
 drivers/usb/serial/spcp8x5.c                  |  30 +++--
 drivers/usb/wusbcore/wa-rpipe.c               |   5 +-
 drivers/usb/wusbcore/wa-xfer.c                |   5 +-
 drivers/video/backlight/atmel-pwm-bl.c        |   7 +-
 fs/cifs/cifssmb.c                             |   8 +-
 fs/configfs/dir.c                             |  16 ++-
 fs/devpts/inode.c                             |   1 +
 fs/exec.c                                     |   6 +
 fs/ext4/xattr.c                               |   1 +
 fs/nfs/nfs4proc.c                             |  14 ++-
 fs/nfsd/nfs4xdr.c                             |   2 +-
 fs/nfsd/vfs.c                                 | 173 +++++++++++++++-------=
----
 fs/xfs/xfs_ioctl.c                            |   3 +-
 fs/xfs/xfs_ioctl32.c                          |   3 +-
 include/crypto/scatterwalk.h                  |   3 +-
 include/linux/binfmts.h                       |   3 -
 include/linux/compiler-intel.h                |   2 -
 include/linux/msg.h                           |   6 +-
 include/linux/mtd/map.h                       |   4 +-
 include/linux/net.h                           |   8 ++
 include/linux/pci_ids.h                       |   1 +
 include/linux/random.h                        |   6 +-
 include/linux/sched.h                         |   4 +
 include/net/ip.h                              |   2 +-
 include/net/ipv6.h                            |   6 +-
 include/sound/memalloc.h                      |   2 +-
 include/trace/ftrace.h                        |   5 +-
 ipc/msgutil.c                                 |  12 +-
 ipc/util.h                                    |   4 +-
 kernel/audit.c                                |   7 +-
 kernel/cpuset.c                               |   8 +-
 kernel/futex.c                                |   2 +-
 kernel/irq/pm.c                               |   2 +-
 kernel/power/snapshot.c                       |   6 +-
 kernel/ptrace.c                               |   3 +-
 kernel/sched_debug.c                          |   8 ++
 kernel/sched_fair.c                           |   2 +
 kernel/time/alarmtimer.c                      |   4 +-
 kernel/trace/ftrace.c                         | 164 ++++++++++++++++------=
--
 lib/random32.c                                |  14 +--
 lib/vsprintf.c                                |  32 ++++-
 net/appletalk/ddp.c                           |  16 ++-
 net/atm/common.c                              |   2 -
 net/ax25/af_ax25.c                            |   4 +-
 net/bluetooth/af_bluetooth.c                  |   4 -
 net/bluetooth/hci_sock.c                      |   2 -
 net/bluetooth/rfcomm/sock.c                   |   1 -
 net/bridge/br_if.c                            |   2 +
 net/caif/caif_socket.c                        |   4 -
 net/compat.c                                  |   5 +-
 net/core/dev.c                                |   4 +-
 net/core/fib_rules.c                          |   3 +-
 net/core/iovec.c                              |   3 +-
 net/core/pktgen.c                             |   7 ++
 net/ieee802154/6lowpan.c                      |   4 +-
 net/ipv4/datagram.c                           |   2 +-
 net/ipv4/ip_sockglue.c                        |   3 +-
 net/ipv4/ping.c                               |  13 +-
 net/ipv4/raw.c                                |   6 +-
 net/ipv4/tcp_ipv4.c                           |   2 +-
 net/ipv4/udp.c                                |  14 +--
 net/ipv6/datagram.c                           |   8 +-
 net/ipv6/ip6_output.c                         |   4 +-
 net/ipv6/raw.c                                |   8 +-
 net/ipv6/route.c                              |   7 +-
 net/ipv6/udp.c                                |   9 +-
 net/ipx/af_ipx.c                              |   3 +-
 net/irda/af_irda.c                            |   4 -
 net/iucv/af_iucv.c                            |   2 -
 net/key/af_key.c                              |   1 -
 net/l2tp/l2tp_ip.c                            |   4 +-
 net/l2tp/l2tp_ppp.c                           |   2 -
 net/llc/af_llc.c                              |   2 -
 net/mac80211/rx.c                             |   3 +-
 net/netlink/af_netlink.c                      |   2 -
 net/netrom/af_netrom.c                        |   3 +-
 net/nfc/rawsock.c                             |   2 -
 net/packet/af_packet.c                        |  96 +++++++-------
 net/phonet/datagram.c                         |   9 +-
 net/rds/recv.c                                |   2 -
 net/rose/af_rose.c                            |   8 +-
 net/rxrpc/ar-recvmsg.c                        |   9 +-
 net/socket.c                                  |  24 ++--
 net/sunrpc/xprtsock.c                         |  28 +++--
 net/tipc/socket.c                             |   6 -
 net/unix/af_unix.c                            |   5 -
 net/x25/af_x25.c                              |   3 +-
 security/selinux/hooks.c                      |  93 +++++++++++---
 security/selinux/netlabel.c                   |   6 +-
 sound/drivers/pcsp/pcsp.c                     |   2 +-
 sound/isa/msnd/msnd_pinnacle.c                |   4 +-
 sound/pci/hda/patch_conexant.c                |   3 +
 sound/pci/hda/patch_realtek.c                 |   2 +
 sound/soc/codecs/ak4642.c                     |   2 +-
 sound/soc/codecs/wm8731.c                     |   4 +-
 sound/soc/codecs/wm8990.c                     |   2 +
 sound/usb/6fire/chip.c                        |   2 +-
 virt/kvm/iommu.c                              |   4 +
 virt/kvm/kvm_main.c                           |  28 +++--
 211 files changed, 1562 insertions(+), 898 deletions(-)

Aaron Lu (1):
      PM / hibernate: Avoid overflow in hibernate_preallocate_memory()

Alan Cox (1):
      drivers/char/i8k.c: add Dell XPLS L421X

Alan Stern (1):
      usb: dwc3: fix implementation of endpoint wedge

Alex Williamson (1):
      KVM: Fix iommu map/unmap to handle memory slot moves

Alistair Popple (1):
      ahci: add support for IBM Akebono platform device

Andreas Bie=C3=9Fmann (2):
      avr32: setup crt for early panic()
      avr32: fix out-of-range jump in large kernels

Andreas Henriksson (1):
      net: Fix "ip rule delete table 256"

Andy Adamson (1):
      NFSv4 wait on recovery for async session errors

Andy Honig (2):
      KVM: Improve create VCPU parameter (CVE-2013-4587)
      KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)

Anton Blanchard (1):
      powerpc/pseries: Duplicate dtl entries sometimes sent to userspace

Avinash Patil (1):
      mwifiex: correct packet length for packets from SDIO interface

Ben Hutchings (1):
      Linux 3.2.54

Ben Segall (1):
      sched: Avoid throttle_cfs_rq() racing with period_timer stopping

Ben Skeggs (1):
      drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previ=
ous fence

Benjamin Tissoires (1):
      HID: multitouch: validate indexes details

Bo Shen (1):
      ASoC: wm8731: fix dsp mode configuration

Brian Carnes (1):
      hwmon: (w83l786ng) Fix fan speed control mode setting and reporting

Brian Norris (2):
      mtd: nand: hack ONFI for non-power-of-2 dimensions
      mtd: m25p80: fix allocation size

Chris Metcalf (1):
      connector: improved unaligned access error fix

Christoph Hellwig (2):
      nfsd: split up nfsd_setattr
      nfsd: make sure to balance get/put_write_access

Colin Leitner (4):
      USB: spcp8x5: correct handling of CS5 setting
      USB: mos7840: correct handling of CS5 setting
      USB: ftdi_sio: fixed handling of unsupported CSIZE setting
      USB: pl2303: fixed handling of CS5 setting

Dan Carpenter (5):
      hwmon: Prevent some divide by zeros in FAN_TO_REG()
      isdnloop: use strlcpy() instead of strcpy()
      net: clamp ->msg_namelen instead of returning an error
      libertas: potential oops in debugfs
      xfs: underflow bug in xfs_attrlist_by_handle()

Dan Williams (2):
      prism54: set netdev type to "wlan"
      libsas: fix usage of ata_tf_to_fis

Daniel Borkmann (2):
      random32: fix off-by-one in seeding requirement
      packet: fix use after free race in send path when dev is released

Daniel Vetter (1):
      drm/i915: flush cursors harder

David Cluytens (1):
      USB: cdc-acm: Added support for the Lenovo RD02-D400 USB Modem

Ding Tianhong (1):
      bridge: flush br's address entry in fdb when remove the bridge dev

Dmitry Eremin-Solenikov (1):
      ARM: pxa: tosa: fix keys mapping

Duan Jiong (1):
      ipv6: use rt6_get_dflt_router to get default router in rt6_route_rcv

Eric Dumazet (2):
      ipv4: fix possible seqlock deadlock
      inet: fix possible seqlock deadlocks

Eric Seppanen (2):
      iscsi-target: fix extract_param to handle buffer length corner case
      iscsi-target: chap auth shouldn't match username with trailing garbag=
e

Fangxiaozhi (Franko) (1):
      USB: option: support new huawei devices

Felipe Pena (1):
      rtlwifi: rtl8192se: Fix wrong assignment

Fenghua Yu (1):
      x86/apic: Disable I/O APIC before shutdown of the local APIC

Gerald Schaefer (1):
      crypto: s390 - Fix aes-xts parameter corruption

Greg Edwards (1):
      KVM: IOMMU: hva align mapping page size

Greg Kroah-Hartman (1):
      Staging: tidspbridge: disable driver

Guenter Roeck (1):
      hwmon: (lm90) Fix max6696 alarm handling

Gustavo Zacarias (1):
      USB: serial: option: blacklist interface 1 for Huawei E173s-6

Gwendal Grignou (1):
      libata: Fix display of sata speed

H. Peter Anvin (2):
      x86, build: Pass in additional -mno-mmx, -mno-sse options
      x86, build, icc: Remove uninitialized_var() from compiler-intel.h

Hannes Frederic Sowa (6):
      inet: prevent leakage of uninitialized memory to user in recv syscall=
s
      net: rework recvmsg handler msg_name and msg_namelen logic
      net: add BUG_ON if kernel advertises msg_namelen > sizeof(struct sock=
addr_storage)
      inet: fix addr_len/msg->msg_namelen assignment in recv_error and rxpm=
tu functions
      ipv6: fix leaking uninitialized port number of offender sockaddr
      ipv6: fix possible seqlock deadlock in ip6_finish_output2

Herbert Xu (1):
      crypto: s390 - Fix aes-cbc IV corruption

Horia Geanta (1):
      crypto: ccm - Fix handling of zero plaintext when computing mac

Huang Shijie (1):
      mtd: gpmi: fix kernel BUG due to racing DMA operations

Ilija Hadzic (1):
      devpts: plug the memory leak in kill_sb

J. Bruce Fields (1):
      nfsd4: fix xdr decoding of large non-write compounds

James Bottomley (1):
      enclosure: fix WARN_ON in dual path device removing

James Ralston (1):
      ahci: Add Device IDs for Intel Wildcat Point-LP

Jan Kara (2):
      IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_f=
ast()
      IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast(=
)

Jason Wang (1):
      net: flow_dissector: fail on evil iph->ihl

Jean Delvare (1):
      hwmon: (w83l768ng) Fix fan speed control range

Jeff Moyer (1):
      block: fix race between request completion and timeout handling

Jerome Glisse (1):
      radeon: workaround pinning failure on low ram gpu

Johan Hovold (4):
      USB: mos7840: fix tiocmget error handling
      backlight: atmel-pwm-bl: fix reported brightness
      backlight: atmel-pwm-bl: fix gpio polarity in remove
      USB: serial: fix race in generic write

Johannes Berg (1):
      mac80211: don't attempt to reorder multicast frames

Jonathan Austin (1):
      ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD

Jukka Rissanen (1):
      6lowpan: Uncompression of traffic class field was incorrect

Julius Werner (2):
      usb: hub: Clear Port Reset Change during init/resume
      usb: hub: Use correct reset for wedged USB3 devices that are NOTATTAC=
HED

Junxiao Bi (1):
      configfs: fix race between dentry put and lookup

KOBAYASHI Yoshitake (1):
      mmc: block: fix a bug of error handling in MMC driver

KOSAKI Motohiro (1):
      alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist

Kailang Yang (2):
      ALSA: hda/realtek - Add support of ALC231 codec
      ALSA: hda/realtek - Set pcbeep amp for ALC668

Kees Cook (1):
      exec/ptrace: fix get_dumpable() incorrect tests

Konstantin Khlebnikov (2):
      ARM: 7912/1: check stack pointer in get_wchan
      ARM: 7913/1: fix framepointer check in unwind_frame

Larry Finger (4):
      rtlwifi: rtl8192se: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192cu: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192de: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192cu: Fix more pointer arithmetic errors

Laxman Dewangan (1):
      irq: Enable all irqs unconditionally in irq_resume

Linus Pizunski (1):
      drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap

Linus Torvalds (1):
      futex: fix handling of read-only-mapped hugepages

Linus Walleij (1):
      net: smc91: fix crash regression on the versatile

Liu Gang (1):
      powerpc/gpio: Fix the wrong GPIO input data on MPC8572/MPC8536

Mahesh Rajashekhara (1):
      aacraid: prevent invalid pointer dereference

Marcelo Tosatti (1):
      KVM: perform an invalid memslot step for gpa base change

Mark Brown (1):
      ASoC: wm8990: Mark the register map as dirty when powering down

Mark Cave-Ayland (1):
      rtlwifi: Fix endian error in extracting packet type

Markus Pargmann (1):
      can: c_can: Fix RX message handling, handle lost message before EOB

Mathias Krause (3):
      audit: fix info leak in AUDIT_GET requests
      audit: use nlmsg_len() to get message payload length
      ipc, msg: fix message length check for negative values

Matthew Garrett (1):
      x86, efi: Don't use (U)EFI time services on 32 bit

Mauro Carvalho Chehab (1):
      cris: media platform drivers: fix build

Michael Grzeschik (1):
      usb: gadget: composite: reset delayed_status on reset_config

Michael Neuling (2):
      powerpc/signals: Mark VSX not saved with small contexts
      powerpc/signals: Improved mark VSX not saved with small contexts fix

Mikulas Patocka (8):
      dm: allocate buffer for messages with small number of arguments using=
 GFP_NOIO
      blk-core: Fix memory corruption if blkcg_init_queue fails
      loop: fix crash if blk_alloc_queue fails
      block: fix a probe argument to blk_register_region
      dm delay: fix a possible deadlock due to shared workqueue
      dm snapshot: avoid snapshot space leak on crash
      dm table: fail dm_table_create on dm_round_up overflow
      dm bufio: initialize read-only module parameters

Neil Horman (1):
      crypto: ansi_cprng - Fix off by one error in non-block size request

Nikolay Aleksandrov (1):
      bonding: fix two race conditions in bond_store_updelay/downdelay

Oliver Hartkopp (1):
      can: sja1000: fix {pre,post}_irq() handling and IRQ handler return va=
lue

Paul Moore (3):
      selinux: correct locking in selinux_netlbl_socket_connect)
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute=
()

Peter Zijlstra (1):
      cpuset: Fix memory allocator deadlock

Phil Edworthy (1):
      ASoC: ak4642: prevent un-necessary changes to SG_SL1

Prarit Bhargava (2):
      powerpc/vio: Fix modalias_show return values
      powerpc/vio: use strcpy in modalias_show

Rashika Kheria (2):
      Staging: zram: Fix access of NULL pointer
      Staging: zram: Fix memory leak by refcount mismatch

Rui li (1):
      USB=EF=BC=9Aadd new zte 3g-dongle's pid to option.c

Russell King (3):
      ARM: sa11x0/assabet: ensure CS2 is configured appropriately
      ARM: footbridge: fix VGA initialisation
      ARM: 7527/1: uaccess: explicitly check __user pointer when !CPU_USE_D=
OMAINS

Ryan Mallon (1):
      vsprintf: check real user/group id for %pK

Samir Benmendil (1):
      ahci: add Marvell 9230 to the AHCI PCI device list

Sarah Sharp (1):
      usb: Disable USB 2.0 Link PM before device reset.

Sergei Ianovich (1):
      ARM: pxa: prevent PXA270 occasional reboot freezes

Sergei Trofimovich (1):
      um: add missing declaration of 'getrlimit()' and friends

Shan Hai (1):
      drivers/libata: Set max sector to 65535 for Slimtype DVD A DS8A9SH dr=
ive

Shawn Landden (1):
      net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Shiva Krishna Merla (1):
      dm mpath: fix race condition between multipath_dtr and pg_init_done

Stanislaw Gruszka (2):
      rt2400pci: fix RSSI read
      rt2x00: check if device is still available on rt2x00mac_flush()

Stefano Panella (1):
      ALSA: memalloc.h - fix wrong truncation of dma_addr_t

Stephen M. Cameron (2):
      hpsa: do not discard scsi status on aborted commands
      hpsa: return 0 from driver probe function on success, not 1

Steve French (1):
      setfacl removes part of ACL when setting POSIX ACLs to Samba

Steven Rostedt (2):
      ftrace: Fix ftrace hash record update with notrace
      ftrace: Create ftrace_hash_empty() helper routine

Steven Rostedt (Red Hat) (3):
      tracing: Allow events to have NULL strings
      ftrace: Check module functions being traced on reload
      ftrace: Fix function graph with loading of modules

Takashi Iwai (4):
      ALSA: 6fire: Fix probe of multiple cards
      ALSA: hda - Add support for CX20952
      ALSA: msnd: Avoid duplicated driver name
      ALSA: pcsp: Fix the order of input device unregistration

Theodore Ts'o (1):
      ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()

Thomas Hellstrom (1):
      drm/ttm: Fix memory type compatibility check

Thomas Pugliese (2):
      usb: wusbcore: set the RPIPE wMaxPacketSize value correctly
      usb: wusbcore: change WA_SEGS_MAX to a legal value

Thomas Renninger (1):
      x86/microcode/amd: Tone down printk(), don't treat a missing firmware=
 file as an error

Tom Lendacky (3):
      crypto: authenc - Find proper IV address in ablkcipher callback
      crypto: scatterwalk - Set the chain pointer indication bit
      crypto: scatterwalk - Use sg_chain_ptr on chain entries

Trond Myklebust (3):
      NFSv4: Fix a use-after-free situation in _nfs4_proc_getlk()
      SUNRPC: Fix a data corruption issue when retransmitting RPC calls
      NFSv4: Update list of irrecoverable errors on DELEGRETURN

Tyler Hicks (1):
      audit: printk USER_AVC messages when audit isn't enabled

Ursula Braun (1):
      qeth: avoid buffer overflow in snmp ioctl

Veaceslav Falico (2):
      bonding: don't permit to use ARP monitoring in 802.3ad mode
      af_packet: block BH in prb_shutdown_retire_blk_timer()

Vlad Yasevich (1):
      net: core: Always propagate flag changes to interfaces

Wang Haitao (1):
      mtd: map: fixed bug in 64-bit systems

Wei Yongjun (1):
      saa7164: fix return value check in saa7164_initdev()

Xiangliang Yu (1):
      PCI: Define macro for Marvell vendor ID

Ying Xue (1):
      atm: idt77252: fix dev refcnt leak

Yinghai Lu (1):
      PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()

fan.du (1):
      {pktgen, xfrm} Update IPv4 header total len and checksum after tranfo=
rmation

xiangliang yu (1):
      ahci: disabled FBS prior to issuing software reset


--=20
Ben Hutchings
The program is absolutely right; therefore, the computer must be wrong.

--=-7n0h7Rc+HoG1NzjT31Lg
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.54.patch"
Content-Disposition: attachment; filename="linux-3.2.54.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vc3lzY3RsL2tlcm5lbC50eHQgYi9Eb2N1bWVudGF0
aW9uL3N5c2N0bC9rZXJuZWwudHh0DQppbmRleCAxZjI0NjM2Li4yYTY4MDg5IDEwMDY0NA0KLS0t
IGEvRG9jdW1lbnRhdGlvbi9zeXNjdGwva2VybmVsLnR4dA0KKysrIGIvRG9jdW1lbnRhdGlvbi9z
eXNjdGwva2VybmVsLnR4dA0KQEAgLTI4MywxMyArMjgzLDI0IEBAIERlZmF1bHQgdmFsdWUgaXMg
Ii9zYmluL2hvdHBsdWciLg0KIGtwdHJfcmVzdHJpY3Q6DQogDQogVGhpcyB0b2dnbGUgaW5kaWNh
dGVzIHdoZXRoZXIgcmVzdHJpY3Rpb25zIGFyZSBwbGFjZWQgb24NCi1leHBvc2luZyBrZXJuZWwg
YWRkcmVzc2VzIHZpYSAvcHJvYyBhbmQgb3RoZXIgaW50ZXJmYWNlcy4gIFdoZW4NCi1rcHRyX3Jl
c3RyaWN0IGlzIHNldCB0byAoMCksIHRoZXJlIGFyZSBubyByZXN0cmljdGlvbnMuICBXaGVuDQot
a3B0cl9yZXN0cmljdCBpcyBzZXQgdG8gKDEpLCB0aGUgZGVmYXVsdCwga2VybmVsIHBvaW50ZXJz
DQotcHJpbnRlZCB1c2luZyB0aGUgJXBLIGZvcm1hdCBzcGVjaWZpZXIgd2lsbCBiZSByZXBsYWNl
ZCB3aXRoIDAncw0KLXVubGVzcyB0aGUgdXNlciBoYXMgQ0FQX1NZU0xPRy4gIFdoZW4ga3B0cl9y
ZXN0cmljdCBpcyBzZXQgdG8NCi0oMiksIGtlcm5lbCBwb2ludGVycyBwcmludGVkIHVzaW5nICVw
SyB3aWxsIGJlIHJlcGxhY2VkIHdpdGggMCdzDQotcmVnYXJkbGVzcyBvZiBwcml2aWxlZ2VzLg0K
K2V4cG9zaW5nIGtlcm5lbCBhZGRyZXNzZXMgdmlhIC9wcm9jIGFuZCBvdGhlciBpbnRlcmZhY2Vz
Lg0KKw0KK1doZW4ga3B0cl9yZXN0cmljdCBpcyBzZXQgdG8gKDApLCB0aGUgZGVmYXVsdCwgdGhl
cmUgYXJlIG5vIHJlc3RyaWN0aW9ucy4NCisNCitXaGVuIGtwdHJfcmVzdHJpY3QgaXMgc2V0IHRv
ICgxKSwga2VybmVsIHBvaW50ZXJzIHByaW50ZWQgdXNpbmcgdGhlICVwSw0KK2Zvcm1hdCBzcGVj
aWZpZXIgd2lsbCBiZSByZXBsYWNlZCB3aXRoIDAncyB1bmxlc3MgdGhlIHVzZXIgaGFzIENBUF9T
WVNMT0cNCithbmQgZWZmZWN0aXZlIHVzZXIgYW5kIGdyb3VwIGlkcyBhcmUgZXF1YWwgdG8gdGhl
IHJlYWwgaWRzLiBUaGlzIGlzDQorYmVjYXVzZSAlcEsgY2hlY2tzIGFyZSBkb25lIGF0IHJlYWQo
KSB0aW1lIHJhdGhlciB0aGFuIG9wZW4oKSB0aW1lLCBzbw0KK2lmIHBlcm1pc3Npb25zIGFyZSBl
bGV2YXRlZCBiZXR3ZWVuIHRoZSBvcGVuKCkgYW5kIHRoZSByZWFkKCkgKGUuZyB2aWENCithIHNl
dHVpZCBiaW5hcnkpIHRoZW4gJXBLIHdpbGwgbm90IGxlYWsga2VybmVsIHBvaW50ZXJzIHRvIHVu
cHJpdmlsZWdlZA0KK3VzZXJzLiBOb3RlLCB0aGlzIGlzIGEgdGVtcG9yYXJ5IHNvbHV0aW9uIG9u
bHkuIFRoZSBjb3JyZWN0IGxvbmctdGVybQ0KK3NvbHV0aW9uIGlzIHRvIGRvIHRoZSBwZXJtaXNz
aW9uIGNoZWNrcyBhdCBvcGVuKCkgdGltZS4gQ29uc2lkZXIgcmVtb3ZpbmcNCit3b3JsZCByZWFk
IHBlcm1pc3Npb25zIGZyb20gZmlsZXMgdGhhdCB1c2UgJXBLLCBhbmQgdXNpbmcgZG1lc2dfcmVz
dHJpY3QNCit0byBwcm90ZWN0IGFnYWluc3QgdXNlcyBvZiAlcEsgaW4gZG1lc2coOCkgaWYgbGVh
a2luZyBrZXJuZWwgcG9pbnRlcg0KK3ZhbHVlcyB0byB1bnByaXZpbGVnZWQgdXNlcnMgaXMgYSBj
b25jZXJuLg0KKw0KK1doZW4ga3B0cl9yZXN0cmljdCBpcyBzZXQgdG8gKDIpLCBrZXJuZWwgcG9p
bnRlcnMgcHJpbnRlZCB1c2luZw0KKyVwSyB3aWxsIGJlIHJlcGxhY2VkIHdpdGggMCdzIHJlZ2Fy
ZGxlc3Mgb2YgcHJpdmlsZWdlcy4NCiANCiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KIA0KZGlmZiAtLWdpdCBhL01ha2VmaWxl
IGIvTWFrZWZpbGUNCmluZGV4IDkwZjU3ZGMuLjg0OGJlMjYgMTAwNjQ0DQotLS0gYS9NYWtlZmls
ZQ0KKysrIGIvTWFrZWZpbGUNCkBAIC0xLDYgKzEsNiBAQA0KIFZFUlNJT04gPSAzDQogUEFUQ0hM
RVZFTCA9IDINCi1TVUJMRVZFTCA9IDUzDQorU1VCTEVWRUwgPSA1NA0KIEVYVFJBVkVSU0lPTiA9
DQogTkFNRSA9IFNhYmVyLXRvb3RoZWQgU3F1aXJyZWwNCiANCmRpZmYgLS1naXQgYS9hcmNoL2Fy
bS9pbmNsdWRlL2FzbS9hc3NlbWJsZXIuaCBiL2FyY2gvYXJtL2luY2x1ZGUvYXNtL2Fzc2VtYmxl
ci5oDQppbmRleCA3YmI4YmY5Li5iN2M1ZDVkIDEwMDY0NA0KLS0tIGEvYXJjaC9hcm0vaW5jbHVk
ZS9hc20vYXNzZW1ibGVyLmgNCisrKyBiL2FyY2gvYXJtL2luY2x1ZGUvYXNtL2Fzc2VtYmxlci5o
DQpAQCAtMzA3LDQgKzMwNywxMiBAQA0KIAkuc2l6ZSBcbmFtZSAsIC4gLSBcbmFtZQ0KIAkuZW5k
bQ0KIA0KKwkubWFjcm8gY2hlY2tfdWFjY2VzcywgYWRkcjpyZXEsIHNpemU6cmVxLCBsaW1pdDpy
ZXEsIHRtcDpyZXEsIGJhZDpyZXENCisjaWZuZGVmIENPTkZJR19DUFVfVVNFX0RPTUFJTlMNCisJ
YWRkcwlcdG1wLCBcYWRkciwgI1xzaXplIC0gMQ0KKwlzYmNjY3MJXHRtcCwgXHRtcCwgXGxpbWl0
DQorCWJjcwlcYmFkDQorI2VuZGlmDQorCS5lbmRtDQorDQogI2VuZGlmIC8qIF9fQVNNX0FTU0VN
QkxFUl9IX18gKi8NCmRpZmYgLS1naXQgYS9hcmNoL2FybS9pbmNsdWRlL2FzbS91YWNjZXNzLmgg
Yi9hcmNoL2FybS9pbmNsdWRlL2FzbS91YWNjZXNzLmgNCmluZGV4IGIyOTM2MTYuLjI5MmMzZjgg
MTAwNjQ0DQotLS0gYS9hcmNoL2FybS9pbmNsdWRlL2FzbS91YWNjZXNzLmgNCisrKyBiL2FyY2gv
YXJtL2luY2x1ZGUvYXNtL3VhY2Nlc3MuaA0KQEAgLTEwMSwyOCArMTAxLDM5IEBAIGV4dGVybiBp
bnQgX19nZXRfdXNlcl8xKHZvaWQgKik7DQogZXh0ZXJuIGludCBfX2dldF91c2VyXzIodm9pZCAq
KTsNCiBleHRlcm4gaW50IF9fZ2V0X3VzZXJfNCh2b2lkICopOw0KIA0KLSNkZWZpbmUgX19nZXRf
dXNlcl94KF9fcjIsX19wLF9fZSxfX3MsX19pLi4uKQkJCQlcDQorI2RlZmluZSBfX0dVUF9DTE9C
QkVSXzEJImxyIiwgImNjIg0KKyNpZmRlZiBDT05GSUdfQ1BVX1VTRV9ET01BSU5TDQorI2RlZmlu
ZSBfX0dVUF9DTE9CQkVSXzIJImlwIiwgImxyIiwgImNjIg0KKyNlbHNlDQorI2RlZmluZSBfX0dV
UF9DTE9CQkVSXzIgImxyIiwgImNjIg0KKyNlbmRpZg0KKyNkZWZpbmUgX19HVVBfQ0xPQkJFUl80
CSJsciIsICJjYyINCisNCisjZGVmaW5lIF9fZ2V0X3VzZXJfeChfX3IyLF9fcCxfX2UsX19sLF9f
cykJCQkJXA0KIAkgICBfX2FzbV9fIF9fdm9sYXRpbGVfXyAoCQkJCQlcDQogCQlfX2FzbWVxKCIl
MCIsICJyMCIpIF9fYXNtZXEoIiUxIiwgInIyIikJCQlcDQorCQlfX2FzbWVxKCIlMyIsICJyMSIp
CQkJCQlcDQogCQkiYmwJX19nZXRfdXNlcl8iICNfX3MJCQkJXA0KIAkJOiAiPSZyIiAoX19lKSwg
Ij1yIiAoX19yMikJCQkJXA0KLQkJOiAiMCIgKF9fcCkJCQkJCQlcDQotCQk6IF9faSwgImNjIikN
CisJCTogIjAiIChfX3ApLCAiciIgKF9fbCkJCQkJCVwNCisJCTogX19HVVBfQ0xPQkJFUl8jI19f
cykNCiANCiAjZGVmaW5lIGdldF91c2VyKHgscCkJCQkJCQkJXA0KIAkoewkJCQkJCQkJXA0KKwkJ
dW5zaWduZWQgbG9uZyBfX2xpbWl0ID0gY3VycmVudF90aHJlYWRfaW5mbygpLT5hZGRyX2xpbWl0
IC0gMTsgXA0KIAkJcmVnaXN0ZXIgY29uc3QgdHlwZW9mKCoocCkpIF9fdXNlciAqX19wIGFzbSgi
cjAiKSA9IChwKTtcDQogCQlyZWdpc3RlciB1bnNpZ25lZCBsb25nIF9fcjIgYXNtKCJyMiIpOwkJ
CVwNCisJCXJlZ2lzdGVyIHVuc2lnbmVkIGxvbmcgX19sIGFzbSgicjEiKSA9IF9fbGltaXQ7CQlc
DQogCQlyZWdpc3RlciBpbnQgX19lIGFzbSgicjAiKTsJCQkJXA0KIAkJc3dpdGNoIChzaXplb2Yo
KihfX3ApKSkgewkJCQlcDQogCQljYXNlIDE6CQkJCQkJCVwNCi0JCQlfX2dldF91c2VyX3goX19y
MiwgX19wLCBfX2UsIDEsICJsciIpOwkJXA0KLQkgICAgICAgCQlicmVhazsJCQkJCQlcDQorCQkJ
X19nZXRfdXNlcl94KF9fcjIsIF9fcCwgX19lLCBfX2wsIDEpOwkJXA0KKwkJCWJyZWFrOwkJCQkJ
CVwNCiAJCWNhc2UgMjoJCQkJCQkJXA0KLQkJCV9fZ2V0X3VzZXJfeChfX3IyLCBfX3AsIF9fZSwg
MiwgInIzIiwgImxyIik7CVwNCisJCQlfX2dldF91c2VyX3goX19yMiwgX19wLCBfX2UsIF9fbCwg
Mik7CQlcDQogCQkJYnJlYWs7CQkJCQkJXA0KIAkJY2FzZSA0OgkJCQkJCQlcDQotCSAgICAgICAJ
CV9fZ2V0X3VzZXJfeChfX3IyLCBfX3AsIF9fZSwgNCwgImxyIik7CQlcDQorCQkJX19nZXRfdXNl
cl94KF9fcjIsIF9fcCwgX19lLCBfX2wsIDQpOwkJXA0KIAkJCWJyZWFrOwkJCQkJCVwNCiAJCWRl
ZmF1bHQ6IF9fZSA9IF9fZ2V0X3VzZXJfYmFkKCk7IGJyZWFrOwkJCVwNCiAJCX0JCQkJCQkJXA0K
QEAgLTEzNSwzMSArMTQ2LDM0IEBAIGV4dGVybiBpbnQgX19wdXRfdXNlcl8yKHZvaWQgKiwgdW5z
aWduZWQgaW50KTsNCiBleHRlcm4gaW50IF9fcHV0X3VzZXJfNCh2b2lkICosIHVuc2lnbmVkIGlu
dCk7DQogZXh0ZXJuIGludCBfX3B1dF91c2VyXzgodm9pZCAqLCB1bnNpZ25lZCBsb25nIGxvbmcp
Ow0KIA0KLSNkZWZpbmUgX19wdXRfdXNlcl94KF9fcjIsX19wLF9fZSxfX3MpCQkJCQlcDQorI2Rl
ZmluZSBfX3B1dF91c2VyX3goX19yMixfX3AsX19lLF9fbCxfX3MpCQkJCVwNCiAJICAgX19hc21f
XyBfX3ZvbGF0aWxlX18gKAkJCQkJXA0KIAkJX19hc21lcSgiJTAiLCAicjAiKSBfX2FzbWVxKCIl
MiIsICJyMiIpCQkJXA0KKwkJX19hc21lcSgiJTMiLCAicjEiKQkJCQkJXA0KIAkJImJsCV9fcHV0
X3VzZXJfIiAjX19zCQkJCVwNCiAJCTogIj0mciIgKF9fZSkJCQkJCQlcDQotCQk6ICIwIiAoX19w
KSwgInIiIChfX3IyKQkJCQkJXA0KKwkJOiAiMCIgKF9fcCksICJyIiAoX19yMiksICJyIiAoX19s
KQkJCVwNCiAJCTogImlwIiwgImxyIiwgImNjIikNCiANCiAjZGVmaW5lIHB1dF91c2VyKHgscCkJ
CQkJCQkJXA0KIAkoewkJCQkJCQkJXA0KKwkJdW5zaWduZWQgbG9uZyBfX2xpbWl0ID0gY3VycmVu
dF90aHJlYWRfaW5mbygpLT5hZGRyX2xpbWl0IC0gMTsgXA0KIAkJcmVnaXN0ZXIgY29uc3QgdHlw
ZW9mKCoocCkpIF9fcjIgYXNtKCJyMiIpID0gKHgpOwlcDQogCQlyZWdpc3RlciBjb25zdCB0eXBl
b2YoKihwKSkgX191c2VyICpfX3AgYXNtKCJyMCIpID0gKHApO1wNCisJCXJlZ2lzdGVyIHVuc2ln
bmVkIGxvbmcgX19sIGFzbSgicjEiKSA9IF9fbGltaXQ7CQlcDQogCQlyZWdpc3RlciBpbnQgX19l
IGFzbSgicjAiKTsJCQkJXA0KIAkJc3dpdGNoIChzaXplb2YoKihfX3ApKSkgewkJCQlcDQogCQlj
YXNlIDE6CQkJCQkJCVwNCi0JCQlfX3B1dF91c2VyX3goX19yMiwgX19wLCBfX2UsIDEpOwkJXA0K
KwkJCV9fcHV0X3VzZXJfeChfX3IyLCBfX3AsIF9fZSwgX19sLCAxKTsJCVwNCiAJCQlicmVhazsJ
CQkJCQlcDQogCQljYXNlIDI6CQkJCQkJCVwNCi0JCQlfX3B1dF91c2VyX3goX19yMiwgX19wLCBf
X2UsIDIpOwkJXA0KKwkJCV9fcHV0X3VzZXJfeChfX3IyLCBfX3AsIF9fZSwgX19sLCAyKTsJCVwN
CiAJCQlicmVhazsJCQkJCQlcDQogCQljYXNlIDQ6CQkJCQkJCVwNCi0JCQlfX3B1dF91c2VyX3go
X19yMiwgX19wLCBfX2UsIDQpOwkJXA0KKwkJCV9fcHV0X3VzZXJfeChfX3IyLCBfX3AsIF9fZSwg
X19sLCA0KTsJCVwNCiAJCQlicmVhazsJCQkJCQlcDQogCQljYXNlIDg6CQkJCQkJCVwNCi0JCQlf
X3B1dF91c2VyX3goX19yMiwgX19wLCBfX2UsIDgpOwkJXA0KKwkJCV9fcHV0X3VzZXJfeChfX3Iy
LCBfX3AsIF9fZSwgX19sLCA4KTsJCVwNCiAJCQlicmVhazsJCQkJCQlcDQogCQlkZWZhdWx0OiBf
X2UgPSBfX3B1dF91c2VyX2JhZCgpOyBicmVhazsJCQlcDQogCQl9CQkJCQkJCVwNCmRpZmYgLS1n
aXQgYS9hcmNoL2FybS9rZXJuZWwvcHJvY2Vzcy5jIGIvYXJjaC9hcm0va2VybmVsL3Byb2Nlc3Mu
Yw0KaW5kZXggZTY4ZDI1MS4uZDllM2M2MSAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtL2tlcm5lbC9w
cm9jZXNzLmMNCisrKyBiL2FyY2gvYXJtL2tlcm5lbC9wcm9jZXNzLmMNCkBAIC00NjgsNiArNDY4
LDcgQEAgRVhQT1JUX1NZTUJPTChrZXJuZWxfdGhyZWFkKTsNCiB1bnNpZ25lZCBsb25nIGdldF93
Y2hhbihzdHJ1Y3QgdGFza19zdHJ1Y3QgKnApDQogew0KIAlzdHJ1Y3Qgc3RhY2tmcmFtZSBmcmFt
ZTsNCisJdW5zaWduZWQgbG9uZyBzdGFja19wYWdlOw0KIAlpbnQgY291bnQgPSAwOw0KIAlpZiAo
IXAgfHwgcCA9PSBjdXJyZW50IHx8IHAtPnN0YXRlID09IFRBU0tfUlVOTklORykNCiAJCXJldHVy
biAwOw0KQEAgLTQ3Niw5ICs0NzcsMTEgQEAgdW5zaWduZWQgbG9uZyBnZXRfd2NoYW4oc3RydWN0
IHRhc2tfc3RydWN0ICpwKQ0KIAlmcmFtZS5zcCA9IHRocmVhZF9zYXZlZF9zcChwKTsNCiAJZnJh
bWUubHIgPSAwOwkJCS8qIHJlY292ZXJlZCBmcm9tIHRoZSBzdGFjayAqLw0KIAlmcmFtZS5wYyA9
IHRocmVhZF9zYXZlZF9wYyhwKTsNCisJc3RhY2tfcGFnZSA9ICh1bnNpZ25lZCBsb25nKXRhc2tf
c3RhY2tfcGFnZShwKTsNCiAJZG8gew0KLQkJaW50IHJldCA9IHVud2luZF9mcmFtZSgmZnJhbWUp
Ow0KLQkJaWYgKHJldCA8IDApDQorCQlpZiAoZnJhbWUuc3AgPCBzdGFja19wYWdlIHx8DQorCQkg
ICAgZnJhbWUuc3AgPj0gc3RhY2tfcGFnZSArIFRIUkVBRF9TSVpFIHx8DQorCQkgICAgdW53aW5k
X2ZyYW1lKCZmcmFtZSkgPCAwKQ0KIAkJCXJldHVybiAwOw0KIAkJaWYgKCFpbl9zY2hlZF9mdW5j
dGlvbnMoZnJhbWUucGMpKQ0KIAkJCXJldHVybiBmcmFtZS5wYzsNCmRpZmYgLS1naXQgYS9hcmNo
L2FybS9rZXJuZWwvc3RhY2t0cmFjZS5jIGIvYXJjaC9hcm0va2VybmVsL3N0YWNrdHJhY2UuYw0K
aW5kZXggMDBmNzllNS4uYWY0ZThjOCAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtL2tlcm5lbC9zdGFj
a3RyYWNlLmMNCisrKyBiL2FyY2gvYXJtL2tlcm5lbC9zdGFja3RyYWNlLmMNCkBAIC0zMSw3ICsz
MSw3IEBAIGludCBub3RyYWNlIHVud2luZF9mcmFtZShzdHJ1Y3Qgc3RhY2tmcmFtZSAqZnJhbWUp
DQogCWhpZ2ggPSBBTElHTihsb3csIFRIUkVBRF9TSVpFKTsNCiANCiAJLyogY2hlY2sgY3VycmVu
dCBmcmFtZSBwb2ludGVyIGlzIHdpdGhpbiBib3VuZHMgKi8NCi0JaWYgKGZwIDwgKGxvdyArIDEy
KSB8fCBmcCArIDQgPj0gaGlnaCkNCisJaWYgKGZwIDwgbG93ICsgMTIgfHwgZnAgPiBoaWdoIC0g
NCkNCiAJCXJldHVybiAtRUlOVkFMOw0KIA0KIAkvKiByZXN0b3JlIHRoZSByZWdpc3RlcnMgZnJv
bSB0aGUgc3RhY2sgZnJhbWUgKi8NCmRpZmYgLS1naXQgYS9hcmNoL2FybS9saWIvZ2V0dXNlci5T
IGIvYXJjaC9hcm0vbGliL2dldHVzZXIuUw0KaW5kZXggMWIwNDljZC4uNDMwNmZiZiAxMDA2NDQN
Ci0tLSBhL2FyY2gvYXJtL2xpYi9nZXR1c2VyLlMNCisrKyBiL2FyY2gvYXJtL2xpYi9nZXR1c2Vy
LlMNCkBAIC0xNiw4ICsxNiw5IEBADQogICogX19nZXRfdXNlcl9YDQogICoNCiAgKiBJbnB1dHM6
CXIwIGNvbnRhaW5zIHRoZSBhZGRyZXNzDQorICoJCXIxIGNvbnRhaW5zIHRoZSBhZGRyZXNzIGxp
bWl0LCB3aGljaCBtdXN0IGJlIHByZXNlcnZlZA0KICAqIE91dHB1dHM6CXIwIGlzIHRoZSBlcnJv
ciBjb2RlDQotICoJCXIyLCByMyBjb250YWlucyB0aGUgemVyby1leHRlbmRlZCB2YWx1ZQ0KKyAq
CQlyMiBjb250YWlucyB0aGUgemVyby1leHRlbmRlZCB2YWx1ZQ0KICAqCQlsciBjb3JydXB0ZWQN
CiAgKg0KICAqIE5vIG90aGVyIHJlZ2lzdGVycyBtdXN0IGJlIGFsdGVyZWQuICAoc2VlIDxhc20v
dWFjY2Vzcy5oPg0KQEAgLTI3LDMzICsyOCwzOSBAQA0KICAqIE5vdGUgYWxzbyB0aGF0IGl0IGlz
IGludGVuZGVkIHRoYXQgX19nZXRfdXNlcl9iYWQgaXMgbm90IGdsb2JhbC4NCiAgKi8NCiAjaW5j
bHVkZSA8bGludXgvbGlua2FnZS5oPg0KKyNpbmNsdWRlIDxhc20vYXNzZW1ibGVyLmg+DQogI2lu
Y2x1ZGUgPGFzbS9lcnJuby5oPg0KICNpbmNsdWRlIDxhc20vZG9tYWluLmg+DQogDQogRU5UUlko
X19nZXRfdXNlcl8xKQ0KKwljaGVja191YWNjZXNzIHIwLCAxLCByMSwgcjIsIF9fZ2V0X3VzZXJf
YmFkDQogMToJVChsZHJiKQlyMiwgW3IwXQ0KIAltb3YJcjAsICMwDQogCW1vdglwYywgbHINCiBF
TkRQUk9DKF9fZ2V0X3VzZXJfMSkNCiANCiBFTlRSWShfX2dldF91c2VyXzIpDQotI2lmZGVmIENP
TkZJR19USFVNQjJfS0VSTkVMDQotMjoJVChsZHJiKQlyMiwgW3IwXQ0KLTM6CVQobGRyYikJcjMs
IFtyMCwgIzFdDQorCWNoZWNrX3VhY2Nlc3MgcjAsIDIsIHIxLCByMiwgX19nZXRfdXNlcl9iYWQN
CisjaWZkZWYgQ09ORklHX0NQVV9VU0VfRE9NQUlOUw0KK3JiCS5yZXEJaXANCisyOglsZHJidAly
MiwgW3IwXSwgIzENCiszOglsZHJidAlyYiwgW3IwXSwgIzANCiAjZWxzZQ0KLTI6CVQobGRyYikJ
cjIsIFtyMF0sICMxDQotMzoJVChsZHJiKQlyMywgW3IwXQ0KK3JiCS5yZXEJcjANCisyOglsZHJi
CXIyLCBbcjBdDQorMzoJbGRyYglyYiwgW3IwLCAjMV0NCiAjZW5kaWYNCiAjaWZuZGVmIF9fQVJN
RUJfXw0KLQlvcnIJcjIsIHIyLCByMywgbHNsICM4DQorCW9ycglyMiwgcjIsIHJiLCBsc2wgIzgN
CiAjZWxzZQ0KLQlvcnIJcjIsIHIzLCByMiwgbHNsICM4DQorCW9ycglyMiwgcmIsIHIyLCBsc2wg
IzgNCiAjZW5kaWYNCiAJbW92CXIwLCAjMA0KIAltb3YJcGMsIGxyDQogRU5EUFJPQyhfX2dldF91
c2VyXzIpDQogDQogRU5UUlkoX19nZXRfdXNlcl80KQ0KKwljaGVja191YWNjZXNzIHIwLCA0LCBy
MSwgcjIsIF9fZ2V0X3VzZXJfYmFkDQogNDoJVChsZHIpCXIyLCBbcjBdDQogCW1vdglyMCwgIzAN
CiAJbW92CXBjLCBscg0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2xpYi9wdXR1c2VyLlMgYi9hcmNo
L2FybS9saWIvcHV0dXNlci5TDQppbmRleCBjMDIzZmMxLi45YTg5N2ZhIDEwMDY0NA0KLS0tIGEv
YXJjaC9hcm0vbGliL3B1dHVzZXIuUw0KKysrIGIvYXJjaC9hcm0vbGliL3B1dHVzZXIuUw0KQEAg
LTE2LDYgKzE2LDcgQEANCiAgKiBfX3B1dF91c2VyX1gNCiAgKg0KICAqIElucHV0czoJcjAgY29u
dGFpbnMgdGhlIGFkZHJlc3MNCisgKgkJcjEgY29udGFpbnMgdGhlIGFkZHJlc3MgbGltaXQsIHdo
aWNoIG11c3QgYmUgcHJlc2VydmVkDQogICoJCXIyLCByMyBjb250YWlucyB0aGUgdmFsdWUNCiAg
KiBPdXRwdXRzOglyMCBpcyB0aGUgZXJyb3IgY29kZQ0KICAqCQlsciBjb3JydXB0ZWQNCkBAIC0y
NywxNiArMjgsMTkgQEANCiAgKiBOb3RlIGFsc28gdGhhdCBpdCBpcyBpbnRlbmRlZCB0aGF0IF9f
cHV0X3VzZXJfYmFkIGlzIG5vdCBnbG9iYWwuDQogICovDQogI2luY2x1ZGUgPGxpbnV4L2xpbmth
Z2UuaD4NCisjaW5jbHVkZSA8YXNtL2Fzc2VtYmxlci5oPg0KICNpbmNsdWRlIDxhc20vZXJybm8u
aD4NCiAjaW5jbHVkZSA8YXNtL2RvbWFpbi5oPg0KIA0KIEVOVFJZKF9fcHV0X3VzZXJfMSkNCisJ
Y2hlY2tfdWFjY2VzcyByMCwgMSwgcjEsIGlwLCBfX3B1dF91c2VyX2JhZA0KIDE6CVQoc3RyYikJ
cjIsIFtyMF0NCiAJbW92CXIwLCAjMA0KIAltb3YJcGMsIGxyDQogRU5EUFJPQyhfX3B1dF91c2Vy
XzEpDQogDQogRU5UUlkoX19wdXRfdXNlcl8yKQ0KKwljaGVja191YWNjZXNzIHIwLCAyLCByMSwg
aXAsIF9fcHV0X3VzZXJfYmFkDQogCW1vdglpcCwgcjIsIGxzciAjOA0KICNpZmRlZiBDT05GSUdf
VEhVTUIyX0tFUk5FTA0KICNpZm5kZWYgX19BUk1FQl9fDQpAQCAtNjAsMTIgKzY0LDE0IEBAIEVO
VFJZKF9fcHV0X3VzZXJfMikNCiBFTkRQUk9DKF9fcHV0X3VzZXJfMikNCiANCiBFTlRSWShfX3B1
dF91c2VyXzQpDQorCWNoZWNrX3VhY2Nlc3MgcjAsIDQsIHIxLCBpcCwgX19wdXRfdXNlcl9iYWQN
CiA0OglUKHN0cikJcjIsIFtyMF0NCiAJbW92CXIwLCAjMA0KIAltb3YJcGMsIGxyDQogRU5EUFJP
QyhfX3B1dF91c2VyXzQpDQogDQogRU5UUlkoX19wdXRfdXNlcl84KQ0KKwljaGVja191YWNjZXNz
IHIwLCA4LCByMSwgaXAsIF9fcHV0X3VzZXJfYmFkDQogI2lmZGVmIENPTkZJR19USFVNQjJfS0VS
TkVMDQogNToJVChzdHIpCXIyLCBbcjBdDQogNjoJVChzdHIpCXIzLCBbcjAsICM0XQ0KZGlmZiAt
LWdpdCBhL2FyY2gvYXJtL21hY2gtZm9vdGJyaWRnZS9jb21tb24uYyBiL2FyY2gvYXJtL21hY2gt
Zm9vdGJyaWRnZS9jb21tb24uYw0KaW5kZXggMzhhNDRmOS4uNWI5MWU0NSAxMDA2NDQNCi0tLSBh
L2FyY2gvYXJtL21hY2gtZm9vdGJyaWRnZS9jb21tb24uYw0KKysrIGIvYXJjaC9hcm0vbWFjaC1m
b290YnJpZGdlL2NvbW1vbi5jDQpAQCAtMTUsNiArMTUsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9p
bml0Lmg+DQogI2luY2x1ZGUgPGxpbnV4L2lvLmg+DQogI2luY2x1ZGUgPGxpbnV4L3NwaW5sb2Nr
Lmg+DQorI2luY2x1ZGUgPHZpZGVvL3ZnYS5oPg0KICANCiAjaW5jbHVkZSA8YXNtL3BndGFibGUu
aD4NCiAjaW5jbHVkZSA8YXNtL3BhZ2UuaD4NCkBAIC0xOTcsNiArMTk4LDggQEAgdm9pZCBfX2lu
aXQgZm9vdGJyaWRnZV9tYXBfaW8odm9pZCkNCiAJICovDQogCWlmIChmb290YnJpZGdlX2Nmbl9t
b2RlKCkpDQogCQlpb3RhYmxlX2luaXQoZWJzYTI4NV9ob3N0X2lvX2Rlc2MsIEFSUkFZX1NJWkUo
ZWJzYTI4NV9ob3N0X2lvX2Rlc2MpKTsNCisNCisJdmdhX2Jhc2UgPSBQQ0lNRU1fQkFTRTsNCiB9
DQogDQogI2lmZGVmIENPTkZJR19GT09UQlJJREdFX0FERElODQpkaWZmIC0tZ2l0IGEvYXJjaC9h
cm0vbWFjaC1mb290YnJpZGdlL2RjMjEyODUuYyBiL2FyY2gvYXJtL21hY2gtZm9vdGJyaWRnZS9k
YzIxMjg1LmMNCmluZGV4IDE4YzMyYTUuLmE4ZGZhMDAgMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9t
YWNoLWZvb3RicmlkZ2UvZGMyMTI4NS5jDQorKysgYi9hcmNoL2FybS9tYWNoLWZvb3RicmlkZ2Uv
ZGMyMTI4NS5jDQpAQCAtMTgsNyArMTgsNiBAQA0KICNpbmNsdWRlIDxsaW51eC9pcnEuaD4NCiAj
aW5jbHVkZSA8bGludXgvaW8uaD4NCiAjaW5jbHVkZSA8bGludXgvc3BpbmxvY2suaD4NCi0jaW5j
bHVkZSA8dmlkZW8vdmdhLmg+DQogDQogI2luY2x1ZGUgPGFzbS9pcnEuaD4NCiAjaW5jbHVkZSA8
YXNtL3N5c3RlbS5oPg0KQEAgLTI5Nyw3ICsyOTYsNiBAQCB2b2lkIF9faW5pdCBkYzIxMjg1X3By
ZWluaXQodm9pZCkNCiAJaW50IGNmbl9tb2RlOw0KIA0KIAlwY2liaW9zX21pbl9tZW0gPSAweDgx
MDAwMDAwOw0KLQl2Z2FfYmFzZSA9IFBDSU1FTV9CQVNFOw0KIA0KIAltZW1fc2l6ZSA9ICh1bnNp
Z25lZCBpbnQpaGlnaF9tZW1vcnkgLSBQQUdFX09GRlNFVDsNCiAJZm9yIChtZW1fbWFzayA9IDB4
MDAxMDAwMDA7IG1lbV9tYXNrIDwgMHgxMDAwMDAwMDsgbWVtX21hc2sgPDw9IDEpDQpkaWZmIC0t
Z2l0IGEvYXJjaC9hcm0vbWFjaC1pbnRlZ3JhdG9yL2ludGVncmF0b3JfY3AuYyBiL2FyY2gvYXJt
L21hY2gtaW50ZWdyYXRvci9pbnRlZ3JhdG9yX2NwLmMNCmluZGV4IDVkZTQ5YzMuLjg5MmQwZDYg
MTAwNjQ0DQotLS0gYS9hcmNoL2FybS9tYWNoLWludGVncmF0b3IvaW50ZWdyYXRvcl9jcC5jDQor
KysgYi9hcmNoL2FybS9tYWNoLWludGVncmF0b3IvaW50ZWdyYXRvcl9jcC5jDQpAQCAtMzg0LDcg
KzM4NCw4IEBAIHN0YXRpYyBzdHJ1Y3QgYW1iYV9kZXZpY2UgYWFjaV9kZXZpY2UgPSB7DQogc3Rh
dGljIHZvaWQgY3BfY2xjZF9lbmFibGUoc3RydWN0IGNsY2RfZmIgKmZiKQ0KIHsNCiAJc3RydWN0
IGZiX3Zhcl9zY3JlZW5pbmZvICp2YXIgPSAmZmItPmZiLnZhcjsNCi0JdTMyIHZhbCA9IENNX0NU
UkxfU1RBVElDMSB8IENNX0NUUkxfU1RBVElDMjsNCisJdTMyIHZhbCA9IENNX0NUUkxfU1RBVElD
MSB8IENNX0NUUkxfU1RBVElDMg0KKwkJCXwgQ01fQ1RSTF9MQ0RFTjAgfCBDTV9DVFJMX0xDREVO
MTsNCiANCiAJaWYgKHZhci0+Yml0c19wZXJfcGl4ZWwgPD0gOCB8fA0KIAkgICAgKHZhci0+Yml0
c19wZXJfcGl4ZWwgPT0gMTYgJiYgdmFyLT5ncmVlbi5sZW5ndGggPT0gNSkpDQpkaWZmIC0tZ2l0
IGEvYXJjaC9hcm0vbWFjaC1weGEvcmVzZXQuYyBiL2FyY2gvYXJtL21hY2gtcHhhL3Jlc2V0LmMN
CmluZGV4IDAxZTlkNjQuLjBlMjUzNDggMTAwNjQ0DQotLS0gYS9hcmNoL2FybS9tYWNoLXB4YS9y
ZXNldC5jDQorKysgYi9hcmNoL2FybS9tYWNoLXB4YS9yZXNldC5jDQpAQCAtMTIsNiArMTIsNyBA
QA0KIA0KICNpbmNsdWRlIDxtYWNoL3JlZ3Mtb3N0Lmg+DQogI2luY2x1ZGUgPG1hY2gvcmVzZXQu
aD4NCisjaW5jbHVkZSA8bWFjaC9zbWVtYy5oPg0KIA0KIHVuc2lnbmVkIGludCByZXNldF9zdGF0
dXM7DQogRVhQT1JUX1NZTUJPTChyZXNldF9zdGF0dXMpOw0KQEAgLTc5LDYgKzgwLDEyIEBAIHN0
YXRpYyB2b2lkIGRvX2h3X3Jlc2V0KHZvaWQpDQogCU9XRVIgPSBPV0VSX1dNRTsNCiAJT1NTUiA9
IE9TU1JfTTM7DQogCU9TTVIzID0gT1NDUiArIDM2ODY0MDsJLyogLi4uIGluIDEwMCBtcyAqLw0K
KwkvKg0KKwkgKiBTRFJBTSBoYW5ncyBvbiB3YXRjaGRvZyByZXNldCBvbiBNYXJ2ZWxsIFBYQTI3
MCAoZXJyYXR1bSA3MSkNCisJICogd2UgcHV0IFNEUkFNIGludG8gc2VsZi1yZWZyZXNoIHRvIHBy
ZXZlbnQgdGhhdA0KKwkgKi8NCisJd2hpbGUgKDEpDQorCQl3cml0ZWxfcmVsYXhlZChNRFJFRlJf
U0xGUlNILCBNRFJFRlIpOw0KIH0NCiANCiB2b2lkIGFyY2hfcmVzZXQoY2hhciBtb2RlLCBjb25z
dCBjaGFyICpjbWQpDQpAQCAtOTksNCArMTA2LDMgQEAgdm9pZCBhcmNoX3Jlc2V0KGNoYXIgbW9k
ZSwgY29uc3QgY2hhciAqY21kKQ0KIAkJYnJlYWs7DQogCX0NCiB9DQotDQpkaWZmIC0tZ2l0IGEv
YXJjaC9hcm0vbWFjaC1weGEvdG9zYS5jIGIvYXJjaC9hcm0vbWFjaC1weGEvdG9zYS5jDQppbmRl
eCA0MDJiMGM5Ni4uMzNkZDU3YyAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtL21hY2gtcHhhL3Rvc2Eu
Yw0KKysrIGIvYXJjaC9hcm0vbWFjaC1weGEvdG9zYS5jDQpAQCAtNDI0LDU3ICs0MjQsNTcgQEAg
c3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgdG9zYV9wb3dlcl9kZXZpY2UgPSB7DQogICog
VG9zYSBLZXlib2FyZA0KICAqLw0KIHN0YXRpYyBjb25zdCB1aW50MzJfdCB0b3Nha2JkX2tleW1h
cFtdID0gew0KLQlLRVkoMCwgMiwgS0VZX1cpLA0KLQlLRVkoMCwgNiwgS0VZX0spLA0KLQlLRVko
MCwgNywgS0VZX0JBQ0tTUEFDRSksDQotCUtFWSgwLCA4LCBLRVlfUCksDQotCUtFWSgxLCAxLCBL
RVlfUSksDQotCUtFWSgxLCAyLCBLRVlfRSksDQotCUtFWSgxLCAzLCBLRVlfVCksDQotCUtFWSgx
LCA0LCBLRVlfWSksDQotCUtFWSgxLCA2LCBLRVlfTyksDQotCUtFWSgxLCA3LCBLRVlfSSksDQot
CUtFWSgxLCA4LCBLRVlfQ09NTUEpLA0KLQlLRVkoMiwgMSwgS0VZX0EpLA0KLQlLRVkoMiwgMiwg
S0VZX0QpLA0KLQlLRVkoMiwgMywgS0VZX0cpLA0KLQlLRVkoMiwgNCwgS0VZX1UpLA0KLQlLRVko
MiwgNiwgS0VZX0wpLA0KLQlLRVkoMiwgNywgS0VZX0VOVEVSKSwNCi0JS0VZKDIsIDgsIEtFWV9E
T1QpLA0KLQlLRVkoMywgMSwgS0VZX1opLA0KLQlLRVkoMywgMiwgS0VZX0MpLA0KLQlLRVkoMywg
MywgS0VZX1YpLA0KLQlLRVkoMywgNCwgS0VZX0opLA0KLQlLRVkoMywgNSwgVE9TQV9LRVlfQURE
UkVTU0JPT0spLA0KLQlLRVkoMywgNiwgVE9TQV9LRVlfQ0FOQ0VMKSwNCi0JS0VZKDMsIDcsIFRP
U0FfS0VZX0NFTlRFUiksDQotCUtFWSgzLCA4LCBUT1NBX0tFWV9PSyksDQotCUtFWSgzLCA5LCBL
RVlfTEVGVFNISUZUKSwNCi0JS0VZKDQsIDEsIEtFWV9TKSwNCi0JS0VZKDQsIDIsIEtFWV9SKSwN
Ci0JS0VZKDQsIDMsIEtFWV9CKSwNCi0JS0VZKDQsIDQsIEtFWV9OKSwNCi0JS0VZKDQsIDUsIFRP
U0FfS0VZX0NBTEVOREFSKSwNCi0JS0VZKDQsIDYsIFRPU0FfS0VZX0hPTUVQQUdFKSwNCi0JS0VZ
KDQsIDcsIEtFWV9MRUZUQ1RSTCksDQotCUtFWSg0LCA4LCBUT1NBX0tFWV9MSUdIVCksDQotCUtF
WSg0LCAxMCwgS0VZX1JJR0hUU0hJRlQpLA0KLQlLRVkoNSwgMSwgS0VZX1RBQiksDQotCUtFWSg1
LCAyLCBLRVlfU0xBU0gpLA0KLQlLRVkoNSwgMywgS0VZX0gpLA0KLQlLRVkoNSwgNCwgS0VZX00p
LA0KLQlLRVkoNSwgNSwgVE9TQV9LRVlfTUVOVSksDQotCUtFWSg1LCA3LCBLRVlfVVApLA0KLQlL
RVkoNSwgMTEsIFRPU0FfS0VZX0ZOKSwNCi0JS0VZKDYsIDEsIEtFWV9YKSwNCi0JS0VZKDYsIDIs
IEtFWV9GKSwNCi0JS0VZKDYsIDMsIEtFWV9TUEFDRSksDQotCUtFWSg2LCA0LCBLRVlfQVBPU1RS
T1BIRSksDQotCUtFWSg2LCA1LCBUT1NBX0tFWV9NQUlMKSwNCi0JS0VZKDYsIDYsIEtFWV9MRUZU
KSwNCi0JS0VZKDYsIDcsIEtFWV9ET1dOKSwNCi0JS0VZKDYsIDgsIEtFWV9SSUdIVCksDQorCUtF
WSgwLCAxLCBLRVlfVyksDQorCUtFWSgwLCA1LCBLRVlfSyksDQorCUtFWSgwLCA2LCBLRVlfQkFD
S1NQQUNFKSwNCisJS0VZKDAsIDcsIEtFWV9QKSwNCisJS0VZKDEsIDAsIEtFWV9RKSwNCisJS0VZ
KDEsIDEsIEtFWV9FKSwNCisJS0VZKDEsIDIsIEtFWV9UKSwNCisJS0VZKDEsIDMsIEtFWV9ZKSwN
CisJS0VZKDEsIDUsIEtFWV9PKSwNCisJS0VZKDEsIDYsIEtFWV9JKSwNCisJS0VZKDEsIDcsIEtF
WV9DT01NQSksDQorCUtFWSgyLCAwLCBLRVlfQSksDQorCUtFWSgyLCAxLCBLRVlfRCksDQorCUtF
WSgyLCAyLCBLRVlfRyksDQorCUtFWSgyLCAzLCBLRVlfVSksDQorCUtFWSgyLCA1LCBLRVlfTCks
DQorCUtFWSgyLCA2LCBLRVlfRU5URVIpLA0KKwlLRVkoMiwgNywgS0VZX0RPVCksDQorCUtFWSgz
LCAwLCBLRVlfWiksDQorCUtFWSgzLCAxLCBLRVlfQyksDQorCUtFWSgzLCAyLCBLRVlfViksDQor
CUtFWSgzLCAzLCBLRVlfSiksDQorCUtFWSgzLCA0LCBUT1NBX0tFWV9BRERSRVNTQk9PSyksDQor
CUtFWSgzLCA1LCBUT1NBX0tFWV9DQU5DRUwpLA0KKwlLRVkoMywgNiwgVE9TQV9LRVlfQ0VOVEVS
KSwNCisJS0VZKDMsIDcsIFRPU0FfS0VZX09LKSwNCisJS0VZKDMsIDgsIEtFWV9MRUZUU0hJRlQp
LA0KKwlLRVkoNCwgMCwgS0VZX1MpLA0KKwlLRVkoNCwgMSwgS0VZX1IpLA0KKwlLRVkoNCwgMiwg
S0VZX0IpLA0KKwlLRVkoNCwgMywgS0VZX04pLA0KKwlLRVkoNCwgNCwgVE9TQV9LRVlfQ0FMRU5E
QVIpLA0KKwlLRVkoNCwgNSwgVE9TQV9LRVlfSE9NRVBBR0UpLA0KKwlLRVkoNCwgNiwgS0VZX0xF
RlRDVFJMKSwNCisJS0VZKDQsIDcsIFRPU0FfS0VZX0xJR0hUKSwNCisJS0VZKDQsIDksIEtFWV9S
SUdIVFNISUZUKSwNCisJS0VZKDUsIDAsIEtFWV9UQUIpLA0KKwlLRVkoNSwgMSwgS0VZX1NMQVNI
KSwNCisJS0VZKDUsIDIsIEtFWV9IKSwNCisJS0VZKDUsIDMsIEtFWV9NKSwNCisJS0VZKDUsIDQs
IFRPU0FfS0VZX01FTlUpLA0KKwlLRVkoNSwgNiwgS0VZX1VQKSwNCisJS0VZKDUsIDEwLCBUT1NB
X0tFWV9GTiksDQorCUtFWSg2LCAwLCBLRVlfWCksDQorCUtFWSg2LCAxLCBLRVlfRiksDQorCUtF
WSg2LCAyLCBLRVlfU1BBQ0UpLA0KKwlLRVkoNiwgMywgS0VZX0FQT1NUUk9QSEUpLA0KKwlLRVko
NiwgNCwgVE9TQV9LRVlfTUFJTCksDQorCUtFWSg2LCA1LCBLRVlfTEVGVCksDQorCUtFWSg2LCA2
LCBLRVlfRE9XTiksDQorCUtFWSg2LCA3LCBLRVlfUklHSFQpLA0KIH07DQogDQogc3RhdGljIHN0
cnVjdCBtYXRyaXhfa2V5bWFwX2RhdGEgdG9zYWtiZF9rZXltYXBfZGF0YSA9IHsNCmRpZmYgLS1n
aXQgYS9hcmNoL2FybS9tYWNoLXNhMTEwMC9hc3NhYmV0LmMgYi9hcmNoL2FybS9tYWNoLXNhMTEw
MC9hc3NhYmV0LmMNCmluZGV4IDNkZDEzM2YuLmVmOGQ5ZDggMTAwNjQ0DQotLS0gYS9hcmNoL2Fy
bS9tYWNoLXNhMTEwMC9hc3NhYmV0LmMNCisrKyBiL2FyY2gvYXJtL21hY2gtc2ExMTAwL2Fzc2Fi
ZXQuYw0KQEAgLTQxMSw2ICs0MTEsOSBAQCBzdGF0aWMgdm9pZCBfX2luaXQgYXNzYWJldF9tYXBf
aW8odm9pZCkNCiAJICogSXRzIGNhbGxlZCBHUENMS1IwIGluIG15IFNBMTExMCBtYW51YWwuDQog
CSAqLw0KIAlTZXIxU0RDUjAgfD0gU0RDUjBfU1VTOw0KKwlNU0MxID0gKE1TQzEgJiB+MHhmZmZm
KSB8DQorCQlNU0NfTm9uQnJzdCB8IE1TQ18zMkJpdFN0TWVtIHwNCisJCU1TQ19SZEFjYygyKSB8
IE1TQ19XckFjYygyKSB8IE1TQ19SZWMoMCk7DQogDQogCWlmIChtYWNoaW5lX2hhc19uZXBvbnNl
dCgpKSB7DQogI2lmZGVmIENPTkZJR19BU1NBQkVUX05FUE9OU0VUDQpkaWZmIC0tZ2l0IGEvYXJj
aC9hdnIzMi9ib290L3UtYm9vdC9oZWFkLlMgYi9hcmNoL2F2cjMyL2Jvb3QvdS1ib290L2hlYWQu
Uw0KaW5kZXggNDQ4OGZhMi4uMmZmYzI5OCAxMDA2NDQNCi0tLSBhL2FyY2gvYXZyMzIvYm9vdC91
LWJvb3QvaGVhZC5TDQorKysgYi9hcmNoL2F2cjMyL2Jvb3QvdS1ib290L2hlYWQuUw0KQEAgLTgs
NiArOCw4IEBADQogICogcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb24u
DQogICovDQogI2luY2x1ZGUgPGFzbS9zZXR1cC5oPg0KKyNpbmNsdWRlIDxhc20vdGhyZWFkX2lu
Zm8uaD4NCisjaW5jbHVkZSA8YXNtL3N5c3JlZy5oPg0KIA0KIAkvKg0KIAkgKiBUaGUga2VybmVs
IGlzIGxvYWRlZCB3aGVyZSB3ZSB3YW50IGl0IHRvIGJlIGFuZCBhbGwgY2FjaGVzDQpAQCAtMjAs
MTEgKzIyLDYgQEANCiAJLnNlY3Rpb24gLmluaXQudGV4dCwiYXgiDQogCS5nbG9iYWwgX3N0YXJ0
DQogX3N0YXJ0Og0KLQkvKiBDaGVjayBpZiB0aGUgYm9vdCBsb2FkZXIgYWN0dWFsbHkgcHJvdmlk
ZWQgYSB0YWcgdGFibGUgKi8NCi0JbGRkcGMJcjAsIG1hZ2ljX251bWJlcg0KLQljcC53CXIxMiwg
cjANCi0JYnJuZQlub190YWdfdGFibGUNCi0NCiAJLyogSW5pdGlhbGl6ZSAuYnNzICovDQogCWxk
ZHBjCXIyLCBic3Nfc3RhcnRfYWRkcg0KIAlsZGRwYyAgIHIzLCBlbmRfYWRkcg0KQEAgLTM0LDYg
KzMxLDI1IEBAIF9zdGFydDoNCiAJY3AgICAgICByMiwgcjMNCiAJYnJsbyAgICAxYg0KIA0KKwkv
KiBJbml0aWFsaXplIHN0YXR1cyByZWdpc3RlciAqLw0KKwlsZGRwYwlyMCwgaW5pdF9zcg0KKwlt
dHNyCVNZU1JFR19TUiwgcjANCisNCisJLyogU2V0IGluaXRpYWwgc3RhY2sgcG9pbnRlciAqLw0K
KwlsZGRwYwlzcCwgc3RhY2tfYWRkcg0KKwlzdWIJc3AsIC1USFJFQURfU0laRQ0KKw0KKyNpZmRl
ZiBDT05GSUdfRlJBTUVfUE9JTlRFUg0KKwkvKiBNYXJrIGxhc3Qgc3RhY2sgZnJhbWUgKi8NCisJ
bW92CWxyLCAwDQorCW1vdglyNywgMA0KKyNlbmRpZg0KKw0KKwkvKiBDaGVjayBpZiB0aGUgYm9v
dCBsb2FkZXIgYWN0dWFsbHkgcHJvdmlkZWQgYSB0YWcgdGFibGUgKi8NCisJbGRkcGMJcjAsIG1h
Z2ljX251bWJlcg0KKwljcC53CXIxMiwgcjANCisJYnJuZQlub190YWdfdGFibGUNCisNCiAJLyoN
CiAJICogU2F2ZSB0aGUgdGFnIHRhYmxlIGFkZHJlc3MgZm9yIGxhdGVyIHVzZS4gVGhpcyBtdXN0
IGJlIGRvbmUNCiAJICogX2FmdGVyXyAuYnNzIGhhcyBiZWVuIGluaXRpYWxpemVkLi4uDQpAQCAt
NTMsOCArNjksMTUgQEAgYnNzX3N0YXJ0X2FkZHI6DQogCS5sb25nICAgX19ic3Nfc3RhcnQNCiBl
bmRfYWRkcjoNCiAJLmxvbmcgICBfZW5kDQoraW5pdF9zcjoNCisJLmxvbmcJMHgwMDdmMDAwMAkv
KiBTdXBlcnZpc29yIG1vZGUsIGV2ZXJ5dGhpbmcgbWFza2VkICovDQorc3RhY2tfYWRkcjoNCisJ
LmxvbmcJaW5pdF90aHJlYWRfdW5pb24NCitwYW5pY19hZGRyOg0KKwkubG9uZwlwYW5pYw0KIA0K
IG5vX3RhZ190YWJsZToNCiAJc3ViCXIxMiwgcGMsICguIC0gMmYpDQotCWJyYWwJcGFuaWMNCisJ
LyogYnJhbmNoIHRvIHBhbmljKCkgd2hpY2ggY2FuIGJlIGZhciBhd2F5IHdpdGggdGhhdCBjb25z
dHJ1Y3QgKi8NCisJbGRkcGMJcGMsIHBhbmljX2FkZHINCiAyOgkuYXNjaXoJIkJvb3QgbG9hZGVy
IGRpZG4ndCBwcm92aWRlIGNvcnJlY3QgbWFnaWMgbnVtYmVyXG4iDQpkaWZmIC0tZ2l0IGEvYXJj
aC9hdnIzMi9rZXJuZWwvZW50cnktYXZyMzJiLlMgYi9hcmNoL2F2cjMyL2tlcm5lbC9lbnRyeS1h
dnIzMmIuUw0KaW5kZXggMTY5MjY4Yy4uYTkxZTg5OCAxMDA2NDQNCi0tLSBhL2FyY2gvYXZyMzIv
a2VybmVsL2VudHJ5LWF2cjMyYi5TDQorKysgYi9hcmNoL2F2cjMyL2tlcm5lbC9lbnRyeS1hdnIz
MmIuUw0KQEAgLTM5OSw5ICszOTksMTAgQEAgaGFuZGxlX2NyaXRpY2FsOg0KIAkvKiBXZSBzaG91
bGQgbmV2ZXIgZ2V0IGhlcmUuLi4gKi8NCiBiYWRfcmV0dXJuOg0KIAlzdWIJcjEyLCBwYywgKC4g
LSAxZikNCi0JYnJhbAlwYW5pYw0KKwlsZGRwYwlwYywgMmYNCiAJLmFsaWduCTINCiAxOgkuYXNj
aXoJIlJldHVybiBmcm9tIGNyaXRpY2FsIGV4Y2VwdGlvbiEiDQorMjoJLmxvbmcJcGFuaWMNCiAN
CiAJLmFsaWduCTENCiBkb19idXNfZXJyb3Jfd3JpdGU6DQpkaWZmIC0tZ2l0IGEvYXJjaC9hdnIz
Mi9rZXJuZWwvaGVhZC5TIGIvYXJjaC9hdnIzMi9rZXJuZWwvaGVhZC5TDQppbmRleCA2MTYzYmQw
Li41OWVhZTZkIDEwMDY0NA0KLS0tIGEvYXJjaC9hdnIzMi9rZXJuZWwvaGVhZC5TDQorKysgYi9h
cmNoL2F2cjMyL2tlcm5lbC9oZWFkLlMNCkBAIC0xMCwzMyArMTAsMTMgQEANCiAjaW5jbHVkZSA8
bGludXgvbGlua2FnZS5oPg0KIA0KICNpbmNsdWRlIDxhc20vcGFnZS5oPg0KLSNpbmNsdWRlIDxh
c20vdGhyZWFkX2luZm8uaD4NCi0jaW5jbHVkZSA8YXNtL3N5c3JlZy5oPg0KIA0KIAkuc2VjdGlv
biAuaW5pdC50ZXh0LCJheCINCiAJLmdsb2JhbCBrZXJuZWxfZW50cnkNCiBrZXJuZWxfZW50cnk6
DQotCS8qIEluaXRpYWxpemUgc3RhdHVzIHJlZ2lzdGVyICovDQotCWxkZHBjICAgcjAsIGluaXRf
c3INCi0JbXRzcglTWVNSRUdfU1IsIHIwDQotDQotCS8qIFNldCBpbml0aWFsIHN0YWNrIHBvaW50
ZXIgKi8NCi0JbGRkcGMgICBzcCwgc3RhY2tfYWRkcg0KLQlzdWIJc3AsIC1USFJFQURfU0laRQ0K
LQ0KLSNpZmRlZiBDT05GSUdfRlJBTUVfUE9JTlRFUg0KLQkvKiBNYXJrIGxhc3Qgc3RhY2sgZnJh
bWUgKi8NCi0JbW92CWxyLCAwDQotCW1vdglyNywgMA0KLSNlbmRpZg0KLQ0KIAkvKiBTdGFydCB0
aGUgc2hvdyAqLw0KIAlsZGRwYyAgIHBjLCBrZXJuZWxfc3RhcnRfYWRkcg0KIA0KIAkuYWxpZ24g
IDINCi1pbml0X3NyOg0KLQkubG9uZyAgIDB4MDA3ZjAwMDAJLyogU3VwZXJ2aXNvciBtb2RlLCBl
dmVyeXRoaW5nIG1hc2tlZCAqLw0KLXN0YWNrX2FkZHI6DQotCS5sb25nICAgaW5pdF90aHJlYWRf
dW5pb24NCiBrZXJuZWxfc3RhcnRfYWRkcjoNCiAJLmxvbmcgICBzdGFydF9rZXJuZWwNCmRpZmYg
LS1naXQgYS9hcmNoL2NyaXMvaW5jbHVkZS9hc20vaW8uaCBiL2FyY2gvY3Jpcy9pbmNsdWRlL2Fz
bS9pby5oDQppbmRleCBhYzEyYWUyLi5kYjlhMTZjIDEwMDY0NA0KLS0tIGEvYXJjaC9jcmlzL2lu
Y2x1ZGUvYXNtL2lvLmgNCisrKyBiL2FyY2gvY3Jpcy9pbmNsdWRlL2FzbS9pby5oDQpAQCAtMyw2
ICszLDcgQEANCiANCiAjaW5jbHVkZSA8YXNtL3BhZ2UuaD4gICAvKiBmb3IgX192YSwgX19wYSAq
Lw0KICNpbmNsdWRlIDxhcmNoL2lvLmg+DQorI2luY2x1ZGUgPGFzbS1nZW5lcmljL2lvbWFwLmg+
DQogI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPg0KIA0KIHN0cnVjdCBjcmlzX2lvX29wZXJhdGlv
bnMNCmRpZmYgLS1naXQgYS9hcmNoL2lhNjQvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmggYi9hcmNo
L2lhNjQvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmgNCmluZGV4IGQ5ZjM5N2YuLmZiYTc2OTYgMTAw
NjQ0DQotLS0gYS9hcmNoL2lhNjQvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmgNCisrKyBiL2FyY2gv
aWE2NC9pbmNsdWRlL2FzbS9wcm9jZXNzb3IuaA0KQEAgLTMyMCw3ICszMjAsNyBAQCBzdHJ1Y3Qg
dGhyZWFkX3N0cnVjdCB7DQogCXJlZ3MtPmxvYWRycyA9IDA7CQkJCQkJCQkJXA0KIAlyZWdzLT5y
OCA9IGdldF9kdW1wYWJsZShjdXJyZW50LT5tbSk7CS8qIHNldCAiZG9uJ3QgemFwIHJlZ2lzdGVy
cyIgZmxhZyAqLwkJXA0KIAlyZWdzLT5yMTIgPSBuZXdfc3AgLSAxNjsJLyogYWxsb2NhdGUgMTYg
Ynl0ZSBzY3JhdGNoIGFyZWEgKi8JCQlcDQotCWlmICh1bmxpa2VseSghZ2V0X2R1bXBhYmxlKGN1
cnJlbnQtPm1tKSkpIHsJCQkJCQkJXA0KKwlpZiAodW5saWtlbHkoZ2V0X2R1bXBhYmxlKGN1cnJl
bnQtPm1tKSAhPSBTVUlEX0RVTVBfVVNFUikpIHsJXA0KIAkJLyoJCQkJCQkJCQkJXA0KIAkJICog
WmFwIHNjcmF0Y2ggcmVncyB0byBhdm9pZCBsZWFraW5nIGJpdHMgYmV0d2VlbiBwcm9jZXNzZXMg
d2l0aCBkaWZmZXJlbnQJXA0KIAkJICogdWlkL3ByaXZpbGVnZXMuCQkJCQkJCQlcDQpkaWZmIC0t
Z2l0IGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9zaWduYWxfMzIuYyBiL2FyY2gvcG93ZXJwYy9rZXJu
ZWwvc2lnbmFsXzMyLmMNCmluZGV4IDgzNmE1YTEuLmZhMWU1NmIgMTAwNjQ0DQotLS0gYS9hcmNo
L3Bvd2VycGMva2VybmVsL3NpZ25hbF8zMi5jDQorKysgYi9hcmNoL3Bvd2VycGMva2VybmVsL3Np
Z25hbF8zMi5jDQpAQCAtNDQ1LDYgKzQ0NSwxMiBAQCBzdGF0aWMgaW50IHNhdmVfdXNlcl9yZWdz
KHN0cnVjdCBwdF9yZWdzICpyZWdzLCBzdHJ1Y3QgbWNvbnRleHQgX191c2VyICpmcmFtZSwNCiAj
ZW5kaWYgLyogQ09ORklHX0FMVElWRUMgKi8NCiAJaWYgKGNvcHlfZnByX3RvX3VzZXIoJmZyYW1l
LT5tY19mcmVncywgY3VycmVudCkpDQogCQlyZXR1cm4gMTsNCisNCisJLyoNCisJICogQ2xlYXIg
dGhlIE1TUiBWU1ggYml0IHRvIGluZGljYXRlIHRoZXJlIGlzIG5vIHZhbGlkIHN0YXRlIGF0dGFj
aGVkDQorCSAqIHRvIHRoaXMgY29udGV4dCwgZXhjZXB0IGluIHRoZSBzcGVjaWZpYyBjYXNlIGJl
bG93IHdoZXJlIHdlIHNldCBpdC4NCisJICovDQorCW1zciAmPSB+TVNSX1ZTWDsNCiAjaWZkZWYg
Q09ORklHX1ZTWA0KIAkvKg0KIAkgKiBDb3B5IFZTUiAwLTMxIHVwcGVyIGhhbGYgZnJvbSB0aHJl
YWRfc3RydWN0IHRvIGxvY2FsDQpkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL2tlcm5lbC9zaWdu
YWxfNjQuYyBiL2FyY2gvcG93ZXJwYy9rZXJuZWwvc2lnbmFsXzY0LmMNCmluZGV4IGE1MGI1ZWMu
LjYwZDFmNzUgMTAwNjQ0DQotLS0gYS9hcmNoL3Bvd2VycGMva2VybmVsL3NpZ25hbF82NC5jDQor
KysgYi9hcmNoL3Bvd2VycGMva2VybmVsL3NpZ25hbF82NC5jDQpAQCAtMTE2LDYgKzExNiwxMiBA
QCBzdGF0aWMgbG9uZyBzZXR1cF9zaWdjb250ZXh0KHN0cnVjdCBzaWdjb250ZXh0IF9fdXNlciAq
c2MsIHN0cnVjdCBwdF9yZWdzICpyZWdzLA0KIAlmbHVzaF9mcF90b190aHJlYWQoY3VycmVudCk7
DQogCS8qIGNvcHkgZnByIHJlZ3MgYW5kIGZwc2NyICovDQogCWVyciB8PSBjb3B5X2Zwcl90b191
c2VyKCZzYy0+ZnBfcmVncywgY3VycmVudCk7DQorDQorCS8qDQorCSAqIENsZWFyIHRoZSBNU1Ig
VlNYIGJpdCB0byBpbmRpY2F0ZSB0aGVyZSBpcyBubyB2YWxpZCBzdGF0ZSBhdHRhY2hlZA0KKwkg
KiB0byB0aGlzIGNvbnRleHQsIGV4Y2VwdCBpbiB0aGUgc3BlY2lmaWMgY2FzZSBiZWxvdyB3aGVy
ZSB3ZSBzZXQgaXQuDQorCSAqLw0KKwltc3IgJj0gfk1TUl9WU1g7DQogI2lmZGVmIENPTkZJR19W
U1gNCiAJLyoNCiAJICogQ29weSBWU1ggbG93IGRvdWJsZXdvcmQgdG8gbG9jYWwgYnVmZmVyIGZv
ciBmb3JtYXR0aW5nLA0KZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9rZXJuZWwvdGltZS5jIGIv
YXJjaC9wb3dlcnBjL2tlcm5lbC90aW1lLmMNCmluZGV4IGU3NGY4NmUuLjMwNDY4MGEgMTAwNjQ0
DQotLS0gYS9hcmNoL3Bvd2VycGMva2VybmVsL3RpbWUuYw0KKysrIGIvYXJjaC9wb3dlcnBjL2tl
cm5lbC90aW1lLmMNCkBAIC0yMzUsOCArMjM1LDYgQEAgc3RhdGljIHU2NCBzY2FuX2Rpc3BhdGNo
X2xvZyh1NjQgc3RvcF90YikNCiAJaWYgKGkgPT0gdnBhLT5kdGxfaWR4KQ0KIAkJcmV0dXJuIDA7
DQogCXdoaWxlIChpIDwgdnBhLT5kdGxfaWR4KSB7DQotCQlpZiAoZHRsX2NvbnN1bWVyKQ0KLQkJ
CWR0bF9jb25zdW1lcihkdGwsIGkpOw0KIAkJZHRiID0gZHRsLT50aW1lYmFzZTsNCiAJCXRiX2Rl
bHRhID0gZHRsLT5lbnF1ZXVlX3RvX2Rpc3BhdGNoX3RpbWUgKw0KIAkJCWR0bC0+cmVhZHlfdG9f
ZW5xdWV1ZV90aW1lOw0KQEAgLTI0OSw2ICsyNDcsOCBAQCBzdGF0aWMgdTY0IHNjYW5fZGlzcGF0
Y2hfbG9nKHU2NCBzdG9wX3RiKQ0KIAkJfQ0KIAkJaWYgKGR0YiA+IHN0b3BfdGIpDQogCQkJYnJl
YWs7DQorCQlpZiAoZHRsX2NvbnN1bWVyKQ0KKwkJCWR0bF9jb25zdW1lcihkdGwsIGkpOw0KIAkJ
c3RvbGVuICs9IHRiX2RlbHRhOw0KIAkJKytpOw0KIAkJKytkdGw7DQpkaWZmIC0tZ2l0IGEvYXJj
aC9wb3dlcnBjL2tlcm5lbC92aW8uYyBiL2FyY2gvcG93ZXJwYy9rZXJuZWwvdmlvLmMNCmluZGV4
IGY2NWFmNjEuLmRmYjFjMTkgMTAwNjQ0DQotLS0gYS9hcmNoL3Bvd2VycGMva2VybmVsL3Zpby5j
DQorKysgYi9hcmNoL3Bvd2VycGMva2VybmVsL3Zpby5jDQpAQCAtMTM1MSwxMSArMTM1MSwxNSBA
QCBzdGF0aWMgc3NpemVfdCBtb2RhbGlhc19zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0
IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsDQogCWNvbnN0IGNoYXIgKmNwOw0KIA0KIAlkbiA9IGRl
di0+b2Zfbm9kZTsNCi0JaWYgKCFkbikNCi0JCXJldHVybiAtRU5PREVWOw0KKwlpZiAoIWRuKSB7
DQorCQlzdHJjcHkoYnVmLCAiXG4iKTsNCisJCXJldHVybiBzdHJsZW4oYnVmKTsNCisJfQ0KIAlj
cCA9IG9mX2dldF9wcm9wZXJ0eShkbiwgImNvbXBhdGlibGUiLCBOVUxMKTsNCi0JaWYgKCFjcCkN
Ci0JCXJldHVybiAtRU5PREVWOw0KKwlpZiAoIWNwKSB7DQorCQlzdHJjcHkoYnVmLCAiXG4iKTsN
CisJCXJldHVybiBzdHJsZW4oYnVmKTsNCisJfQ0KIA0KIAlyZXR1cm4gc3ByaW50ZihidWYsICJ2
aW86VCVzUyVzXG4iLCB2aW9fZGV2LT50eXBlLCBjcCk7DQogfQ0KZGlmZiAtLWdpdCBhL2FyY2gv
czM5MC9jcnlwdG8vYWVzX3MzOTAuYyBiL2FyY2gvczM5MC9jcnlwdG8vYWVzX3MzOTAuYw0KaW5k
ZXggYTljZTEzNS4uM2VjOGIzOSAxMDA2NDQNCi0tLSBhL2FyY2gvczM5MC9jcnlwdG8vYWVzX3Mz
OTAuYw0KKysrIGIvYXJjaC9zMzkwL2NyeXB0by9hZXNfczM5MC5jDQpAQCAtMzUsNyArMzUsNiBA
QCBzdGF0aWMgdTggKmN0cmJsazsNCiBzdGF0aWMgY2hhciBrZXlsZW5fZmxhZzsNCiANCiBzdHJ1
Y3QgczM5MF9hZXNfY3R4IHsNCi0JdTggaXZbQUVTX0JMT0NLX1NJWkVdOw0KIAl1OCBrZXlbQUVT
X01BWF9LRVlfU0laRV07DQogCWxvbmcgZW5jOw0KIAlsb25nIGRlYzsNCkBAIC01Niw4ICs1NSw3
IEBAIHN0cnVjdCBwY2NfcGFyYW0gew0KIA0KIHN0cnVjdCBzMzkwX3h0c19jdHggew0KIAl1OCBr
ZXlbMzJdOw0KLQl1OCB4dHNfcGFyYW1bMTZdOw0KLQlzdHJ1Y3QgcGNjX3BhcmFtIHBjYzsNCisJ
dTggcGNjX2tleVszMl07DQogCWxvbmcgZW5jOw0KIAlsb25nIGRlYzsNCiAJaW50IGtleV9sZW47
DQpAQCAtNDQyLDI5ICs0NDAsMzUgQEAgc3RhdGljIGludCBjYmNfYWVzX3NldF9rZXkoc3RydWN0
IGNyeXB0b190Zm0gKnRmbSwgY29uc3QgdTggKmluX2tleSwNCiAJcmV0dXJuIGFlc19zZXRfa2V5
KHRmbSwgaW5fa2V5LCBrZXlfbGVuKTsNCiB9DQogDQotc3RhdGljIGludCBjYmNfYWVzX2NyeXB0
KHN0cnVjdCBibGtjaXBoZXJfZGVzYyAqZGVzYywgbG9uZyBmdW5jLCB2b2lkICpwYXJhbSwNCitz
dGF0aWMgaW50IGNiY19hZXNfY3J5cHQoc3RydWN0IGJsa2NpcGhlcl9kZXNjICpkZXNjLCBsb25n
IGZ1bmMsDQogCQkJIHN0cnVjdCBibGtjaXBoZXJfd2FsayAqd2FsaykNCiB7DQorCXN0cnVjdCBz
MzkwX2Flc19jdHggKnNjdHggPSBjcnlwdG9fYmxrY2lwaGVyX2N0eChkZXNjLT50Zm0pOw0KIAlp
bnQgcmV0ID0gYmxrY2lwaGVyX3dhbGtfdmlydChkZXNjLCB3YWxrKTsNCiAJdW5zaWduZWQgaW50
IG5ieXRlcyA9IHdhbGstPm5ieXRlczsNCisJc3RydWN0IHsNCisJCXU4IGl2W0FFU19CTE9DS19T
SVpFXTsNCisJCXU4IGtleVtBRVNfTUFYX0tFWV9TSVpFXTsNCisJfSBwYXJhbTsNCiANCiAJaWYg
KCFuYnl0ZXMpDQogCQlnb3RvIG91dDsNCiANCi0JbWVtY3B5KHBhcmFtLCB3YWxrLT5pdiwgQUVT
X0JMT0NLX1NJWkUpOw0KKwltZW1jcHkocGFyYW0uaXYsIHdhbGstPml2LCBBRVNfQkxPQ0tfU0la
RSk7DQorCW1lbWNweShwYXJhbS5rZXksIHNjdHgtPmtleSwgc2N0eC0+a2V5X2xlbik7DQogCWRv
IHsNCiAJCS8qIG9ubHkgdXNlIGNvbXBsZXRlIGJsb2NrcyAqLw0KIAkJdW5zaWduZWQgaW50IG4g
PSBuYnl0ZXMgJiB+KEFFU19CTE9DS19TSVpFIC0gMSk7DQogCQl1OCAqb3V0ID0gd2Fsay0+ZHN0
LnZpcnQuYWRkcjsNCiAJCXU4ICppbiA9IHdhbGstPnNyYy52aXJ0LmFkZHI7DQogDQotCQlyZXQg
PSBjcnlwdF9zMzkwX2ttYyhmdW5jLCBwYXJhbSwgb3V0LCBpbiwgbik7DQorCQlyZXQgPSBjcnlw
dF9zMzkwX2ttYyhmdW5jLCAmcGFyYW0sIG91dCwgaW4sIG4pOw0KIAkJQlVHX09OKChyZXQgPCAw
KSB8fCAocmV0ICE9IG4pKTsNCiANCiAJCW5ieXRlcyAmPSBBRVNfQkxPQ0tfU0laRSAtIDE7DQog
CQlyZXQgPSBibGtjaXBoZXJfd2Fsa19kb25lKGRlc2MsIHdhbGssIG5ieXRlcyk7DQogCX0gd2hp
bGUgKChuYnl0ZXMgPSB3YWxrLT5uYnl0ZXMpKTsNCi0JbWVtY3B5KHdhbGstPml2LCBwYXJhbSwg
QUVTX0JMT0NLX1NJWkUpOw0KKwltZW1jcHkod2Fsay0+aXYsIHBhcmFtLml2LCBBRVNfQkxPQ0tf
U0laRSk7DQogDQogb3V0Og0KIAlyZXR1cm4gcmV0Ow0KQEAgLTQ4MSw3ICs0ODUsNyBAQCBzdGF0
aWMgaW50IGNiY19hZXNfZW5jcnlwdChzdHJ1Y3QgYmxrY2lwaGVyX2Rlc2MgKmRlc2MsDQogCQly
ZXR1cm4gZmFsbGJhY2tfYmxrX2VuYyhkZXNjLCBkc3QsIHNyYywgbmJ5dGVzKTsNCiANCiAJYmxr
Y2lwaGVyX3dhbGtfaW5pdCgmd2FsaywgZHN0LCBzcmMsIG5ieXRlcyk7DQotCXJldHVybiBjYmNf
YWVzX2NyeXB0KGRlc2MsIHNjdHgtPmVuYywgc2N0eC0+aXYsICZ3YWxrKTsNCisJcmV0dXJuIGNi
Y19hZXNfY3J5cHQoZGVzYywgc2N0eC0+ZW5jLCAmd2Fsayk7DQogfQ0KIA0KIHN0YXRpYyBpbnQg
Y2JjX2Flc19kZWNyeXB0KHN0cnVjdCBibGtjaXBoZXJfZGVzYyAqZGVzYywNCkBAIC00OTUsNyAr
NDk5LDcgQEAgc3RhdGljIGludCBjYmNfYWVzX2RlY3J5cHQoc3RydWN0IGJsa2NpcGhlcl9kZXNj
ICpkZXNjLA0KIAkJcmV0dXJuIGZhbGxiYWNrX2Jsa19kZWMoZGVzYywgZHN0LCBzcmMsIG5ieXRl
cyk7DQogDQogCWJsa2NpcGhlcl93YWxrX2luaXQoJndhbGssIGRzdCwgc3JjLCBuYnl0ZXMpOw0K
LQlyZXR1cm4gY2JjX2Flc19jcnlwdChkZXNjLCBzY3R4LT5kZWMsIHNjdHgtPml2LCAmd2Fsayk7
DQorCXJldHVybiBjYmNfYWVzX2NyeXB0KGRlc2MsIHNjdHgtPmRlYywgJndhbGspOw0KIH0NCiAN
CiBzdGF0aWMgc3RydWN0IGNyeXB0b19hbGcgY2JjX2Flc19hbGcgPSB7DQpAQCAtNTg3LDcgKzU5
MSw3IEBAIHN0YXRpYyBpbnQgeHRzX2Flc19zZXRfa2V5KHN0cnVjdCBjcnlwdG9fdGZtICp0Zm0s
IGNvbnN0IHU4ICppbl9rZXksDQogCQl4dHNfY3R4LT5lbmMgPSBLTV9YVFNfMTI4X0VOQ1JZUFQ7
DQogCQl4dHNfY3R4LT5kZWMgPSBLTV9YVFNfMTI4X0RFQ1JZUFQ7DQogCQltZW1jcHkoeHRzX2N0
eC0+a2V5ICsgMTYsIGluX2tleSwgMTYpOw0KLQkJbWVtY3B5KHh0c19jdHgtPnBjYy5rZXkgKyAx
NiwgaW5fa2V5ICsgMTYsIDE2KTsNCisJCW1lbWNweSh4dHNfY3R4LT5wY2Nfa2V5ICsgMTYsIGlu
X2tleSArIDE2LCAxNik7DQogCQlicmVhazsNCiAJY2FzZSA0ODoNCiAJCXh0c19jdHgtPmVuYyA9
IDA7DQpAQCAtNTk4LDcgKzYwMiw3IEBAIHN0YXRpYyBpbnQgeHRzX2Flc19zZXRfa2V5KHN0cnVj
dCBjcnlwdG9fdGZtICp0Zm0sIGNvbnN0IHU4ICppbl9rZXksDQogCQl4dHNfY3R4LT5lbmMgPSBL
TV9YVFNfMjU2X0VOQ1JZUFQ7DQogCQl4dHNfY3R4LT5kZWMgPSBLTV9YVFNfMjU2X0RFQ1JZUFQ7
DQogCQltZW1jcHkoeHRzX2N0eC0+a2V5LCBpbl9rZXksIDMyKTsNCi0JCW1lbWNweSh4dHNfY3R4
LT5wY2Mua2V5LCBpbl9rZXkgKyAzMiwgMzIpOw0KKwkJbWVtY3B5KHh0c19jdHgtPnBjY19rZXks
IGluX2tleSArIDMyLCAzMik7DQogCQlicmVhazsNCiAJZGVmYXVsdDoNCiAJCSpmbGFncyB8PSBD
UllQVE9fVEZNX1JFU19CQURfS0VZX0xFTjsNCkBAIC02MTcsMjggKzYyMSwzMiBAQCBzdGF0aWMg
aW50IHh0c19hZXNfY3J5cHQoc3RydWN0IGJsa2NpcGhlcl9kZXNjICpkZXNjLCBsb25nIGZ1bmMs
DQogCXVuc2lnbmVkIGludCBuYnl0ZXMgPSB3YWxrLT5uYnl0ZXM7DQogCXVuc2lnbmVkIGludCBu
Ow0KIAl1OCAqaW4sICpvdXQ7DQotCXZvaWQgKnBhcmFtOw0KKwlzdHJ1Y3QgcGNjX3BhcmFtIHBj
Y19wYXJhbTsNCisJc3RydWN0IHsNCisJCXU4IGtleVszMl07DQorCQl1OCBpbml0WzE2XTsNCisJ
fSB4dHNfcGFyYW07DQogDQogCWlmICghbmJ5dGVzKQ0KIAkJZ290byBvdXQ7DQogDQotCW1lbXNl
dCh4dHNfY3R4LT5wY2MuYmxvY2ssIDAsIHNpemVvZih4dHNfY3R4LT5wY2MuYmxvY2spKTsNCi0J
bWVtc2V0KHh0c19jdHgtPnBjYy5iaXQsIDAsIHNpemVvZih4dHNfY3R4LT5wY2MuYml0KSk7DQot
CW1lbXNldCh4dHNfY3R4LT5wY2MueHRzLCAwLCBzaXplb2YoeHRzX2N0eC0+cGNjLnh0cykpOw0K
LQltZW1jcHkoeHRzX2N0eC0+cGNjLnR3ZWFrLCB3YWxrLT5pdiwgc2l6ZW9mKHh0c19jdHgtPnBj
Yy50d2VhaykpOw0KLQlwYXJhbSA9IHh0c19jdHgtPnBjYy5rZXkgKyBvZmZzZXQ7DQotCXJldCA9
IGNyeXB0X3MzOTBfcGNjKGZ1bmMsIHBhcmFtKTsNCisJbWVtc2V0KHBjY19wYXJhbS5ibG9jaywg
MCwgc2l6ZW9mKHBjY19wYXJhbS5ibG9jaykpOw0KKwltZW1zZXQocGNjX3BhcmFtLmJpdCwgMCwg
c2l6ZW9mKHBjY19wYXJhbS5iaXQpKTsNCisJbWVtc2V0KHBjY19wYXJhbS54dHMsIDAsIHNpemVv
ZihwY2NfcGFyYW0ueHRzKSk7DQorCW1lbWNweShwY2NfcGFyYW0udHdlYWssIHdhbGstPml2LCBz
aXplb2YocGNjX3BhcmFtLnR3ZWFrKSk7DQorCW1lbWNweShwY2NfcGFyYW0ua2V5LCB4dHNfY3R4
LT5wY2Nfa2V5LCAzMik7DQorCXJldCA9IGNyeXB0X3MzOTBfcGNjKGZ1bmMsICZwY2NfcGFyYW0u
a2V5W29mZnNldF0pOw0KIAlCVUdfT04ocmV0IDwgMCk7DQogDQotCW1lbWNweSh4dHNfY3R4LT54
dHNfcGFyYW0sIHh0c19jdHgtPnBjYy54dHMsIDE2KTsNCi0JcGFyYW0gPSB4dHNfY3R4LT5rZXkg
KyBvZmZzZXQ7DQorCW1lbWNweSh4dHNfcGFyYW0ua2V5LCB4dHNfY3R4LT5rZXksIDMyKTsNCisJ
bWVtY3B5KHh0c19wYXJhbS5pbml0LCBwY2NfcGFyYW0ueHRzLCAxNik7DQogCWRvIHsNCiAJCS8q
IG9ubHkgdXNlIGNvbXBsZXRlIGJsb2NrcyAqLw0KIAkJbiA9IG5ieXRlcyAmIH4oQUVTX0JMT0NL
X1NJWkUgLSAxKTsNCiAJCW91dCA9IHdhbGstPmRzdC52aXJ0LmFkZHI7DQogCQlpbiA9IHdhbGst
PnNyYy52aXJ0LmFkZHI7DQogDQotCQlyZXQgPSBjcnlwdF9zMzkwX2ttKGZ1bmMsIHBhcmFtLCBv
dXQsIGluLCBuKTsNCisJCXJldCA9IGNyeXB0X3MzOTBfa20oZnVuYywgJnh0c19wYXJhbS5rZXlb
b2Zmc2V0XSwgb3V0LCBpbiwgbik7DQogCQlCVUdfT04ocmV0IDwgMCB8fCByZXQgIT0gbik7DQog
DQogCQluYnl0ZXMgJj0gQUVTX0JMT0NLX1NJWkUgLSAxOw0KZGlmZiAtLWdpdCBhL2FyY2gvdW0v
b3MtTGludXgvc3RhcnRfdXAuYyBiL2FyY2gvdW0vb3MtTGludXgvc3RhcnRfdXAuYw0KaW5kZXgg
NDI1MTYyZS4uMmY1M2I4OSAxMDA2NDQNCi0tLSBhL2FyY2gvdW0vb3MtTGludXgvc3RhcnRfdXAu
Yw0KKysrIGIvYXJjaC91bS9vcy1MaW51eC9zdGFydF91cC5jDQpAQCAtMTUsNiArMTUsOCBAQA0K
ICNpbmNsdWRlIDxzeXMvbW1hbi5oPg0KICNpbmNsdWRlIDxzeXMvc3RhdC5oPg0KICNpbmNsdWRl
IDxzeXMvd2FpdC5oPg0KKyNpbmNsdWRlIDxzeXMvdGltZS5oPg0KKyNpbmNsdWRlIDxzeXMvcmVz
b3VyY2UuaD4NCiAjaW5jbHVkZSA8YXNtL3VuaXN0ZC5oPg0KICNpbmNsdWRlICJpbml0LmgiDQog
I2luY2x1ZGUgIm9zLmgiDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvYm9vdC9NYWtlZmlsZSBiL2Fy
Y2gveDg2L2Jvb3QvTWFrZWZpbGUNCmluZGV4IDk1MzY1YTguLmU4MDU0MmIgMTAwNjQ0DQotLS0g
YS9hcmNoL3g4Ni9ib290L01ha2VmaWxlDQorKysgYi9hcmNoL3g4Ni9ib290L01ha2VmaWxlDQpA
QCAtNTEsMTggKzUxLDE4IEBAICQob2JqKS9jcHVzdHIuaDogJChvYmopL21rY3B1c3RyIEZPUkNF
DQogDQogIyBIb3cgdG8gY29tcGlsZSB0aGUgMTYtYml0IGNvZGUuICBOb3RlIHdlIGFsd2F5cyBj
b21waWxlIGZvciAtbWFyY2g9aTM4NiwNCiAjIHRoYXQgd2F5IHdlIGNhbiBjb21wbGFpbiB0byB0
aGUgdXNlciBpZiB0aGUgQ1BVIGlzIGluc3VmZmljaWVudC4NCi1LQlVJTERfQ0ZMQUdTCTo9ICQo
TElOVVhJTkNMVURFKSAtZyAtT3MgLURfU0VUVVAgLURfX0tFUk5FTF9fIFwNCitLQlVJTERfQ0ZM
QUdTCTo9ICQoTElOVVhJTkNMVURFKSAtbTMyIC1nIC1PcyAtRF9TRVRVUCAtRF9fS0VSTkVMX18g
XA0KIAkJICAgLURESVNBQkxFX0JSQU5DSF9QUk9GSUxJTkcgXA0KIAkJICAgLVdhbGwgLVdzdHJp
Y3QtcHJvdG90eXBlcyBcDQogCQkgICAtbWFyY2g9aTM4NiAtbXJlZ3Bhcm09MyBcDQogCQkgICAt
aW5jbHVkZSAkKHNyY3RyZWUpLyQoc3JjKS9jb2RlMTZnY2MuaCBcDQogCQkgICAtZm5vLXN0cmlj
dC1hbGlhc2luZyAtZm9taXQtZnJhbWUtcG9pbnRlciBcDQorCQkgICAtbW5vLW1teCAtbW5vLXNz
ZSBcDQogCQkgICAkKGNhbGwgY2Mtb3B0aW9uLCAtZmZyZWVzdGFuZGluZykgXA0KIAkJICAgJChj
YWxsIGNjLW9wdGlvbiwgLWZuby10b3BsZXZlbC1yZW9yZGVyLFwNCi0JCQkkKGNhbGwgY2Mtb3B0
aW9uLCAtZm5vLXVuaXQtYXQtYS10aW1lKSkgXA0KKwkJICAgJChjYWxsIGNjLW9wdGlvbiwgLWZu
by11bml0LWF0LWEtdGltZSkpIFwNCiAJCSAgICQoY2FsbCBjYy1vcHRpb24sIC1mbm8tc3RhY2st
cHJvdGVjdG9yKSBcDQogCQkgICAkKGNhbGwgY2Mtb3B0aW9uLCAtbXByZWZlcnJlZC1zdGFjay1i
b3VuZGFyeT0yKQ0KLUtCVUlMRF9DRkxBR1MJKz0gJChjYWxsIGNjLW9wdGlvbiwgLW0zMikNCiBL
QlVJTERfQUZMQUdTCTo9ICQoS0JVSUxEX0NGTEFHUykgLURfX0FTU0VNQkxZX18NCiBHQ09WX1BS
T0ZJTEUgOj0gbg0KIA0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9NYWtl
ZmlsZSBiL2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9NYWtlZmlsZQ0KaW5kZXggNzc0NTNjNi4u
Y2RhNWNlZiAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9NYWtlZmlsZQ0K
KysrIGIvYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL01ha2VmaWxlDQpAQCAtMTIsNiArMTIsNyBA
QCBLQlVJTERfQ0ZMQUdTICs9IC1ERElTQUJMRV9CUkFOQ0hfUFJPRklMSU5HDQogY2ZsYWdzLSQo
Q09ORklHX1g4Nl8zMikgOj0gLW1hcmNoPWkzODYNCiBjZmxhZ3MtJChDT05GSUdfWDg2XzY0KSA6
PSAtbWNtb2RlbD1zbWFsbA0KIEtCVUlMRF9DRkxBR1MgKz0gJChjZmxhZ3MteSkNCitLQlVJTERf
Q0ZMQUdTICs9IC1tbm8tbW14IC1tbm8tc3NlDQogS0JVSUxEX0NGTEFHUyArPSAkKGNhbGwgY2Mt
b3B0aW9uLC1mZnJlZXN0YW5kaW5nKQ0KIEtCVUlMRF9DRkxBR1MgKz0gJChjYWxsIGNjLW9wdGlv
biwtZm5vLXN0YWNrLXByb3RlY3RvcikNCiANCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwv
Y3Jhc2guYyBiL2FyY2gveDg2L2tlcm5lbC9jcmFzaC5jDQppbmRleCAxM2FkODk5Li42OWUyMzFi
IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva2VybmVsL2NyYXNoLmMNCisrKyBiL2FyY2gveDg2L2tl
cm5lbC9jcmFzaC5jDQpAQCAtOTUsMTAgKzk1LDEwIEBAIHZvaWQgbmF0aXZlX21hY2hpbmVfY3Jh
c2hfc2h1dGRvd24oc3RydWN0IHB0X3JlZ3MgKnJlZ3MpDQogCWNwdV9lbWVyZ2VuY3lfdm14b2Zm
KCk7DQogCWNwdV9lbWVyZ2VuY3lfc3ZtX2Rpc2FibGUoKTsNCiANCi0JbGFwaWNfc2h1dGRvd24o
KTsNCiAjaWYgZGVmaW5lZChDT05GSUdfWDg2X0lPX0FQSUMpDQogCWRpc2FibGVfSU9fQVBJQygp
Ow0KICNlbmRpZg0KKwlsYXBpY19zaHV0ZG93bigpOw0KICNpZmRlZiBDT05GSUdfSFBFVF9USU1F
Ug0KIAlocGV0X2Rpc2FibGUoKTsNCiAjZW5kaWYNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJu
ZWwvbWljcm9jb2RlX2FtZC5jIGIvYXJjaC94ODYva2VybmVsL21pY3JvY29kZV9hbWQuYw0KaW5k
ZXggMWVmOTYyYi4uZjliOWVhYSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2tlcm5lbC9taWNyb2Nv
ZGVfYW1kLmMNCisrKyBiL2FyY2gveDg2L2tlcm5lbC9taWNyb2NvZGVfYW1kLmMNCkBAIC0zMzEs
NyArMzMxLDcgQEAgc3RhdGljIGVudW0gdWNvZGVfc3RhdGUgcmVxdWVzdF9taWNyb2NvZGVfYW1k
KGludCBjcHUsIHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCiAJCXNucHJpbnRmKGZ3X25hbWUsIHNp
emVvZihmd19uYW1lKSwgImFtZC11Y29kZS9taWNyb2NvZGVfYW1kX2ZhbSUuMnhoLmJpbiIsIGMt
Png4Nik7DQogDQogCWlmIChyZXF1ZXN0X2Zpcm13YXJlKCZmdywgKGNvbnN0IGNoYXIgKilmd19u
YW1lLCBkZXZpY2UpKSB7DQotCQlwcl9lcnIoImZhaWxlZCB0byBsb2FkIGZpbGUgJXNcbiIsIGZ3
X25hbWUpOw0KKwkJcHJfZGVidWcoImZhaWxlZCB0byBsb2FkIGZpbGUgJXNcbiIsIGZ3X25hbWUp
Ow0KIAkJZ290byBvdXQ7DQogCX0NCiANCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvcmVi
b290LmMgYi9hcmNoL3g4Ni9rZXJuZWwvcmVib290LmMNCmluZGV4IGE0ZTFiNGIuLmY0MTFhY2Eg
MTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvcmVib290LmMNCisrKyBiL2FyY2gveDg2L2tl
cm5lbC9yZWJvb3QuYw0KQEAgLTY1Miw2ICs2NTIsMTMgQEAgdm9pZCBuYXRpdmVfbWFjaGluZV9z
aHV0ZG93bih2b2lkKQ0KIA0KIAkvKiBUaGUgYm9vdCBjcHUgaXMgYWx3YXlzIGxvZ2ljYWwgY3B1
IDAgKi8NCiAJaW50IHJlYm9vdF9jcHVfaWQgPSAwOw0KKyNlbmRpZg0KKw0KKyNpZmRlZiBDT05G
SUdfWDg2X0lPX0FQSUMNCisJZGlzYWJsZV9JT19BUElDKCk7DQorI2VuZGlmDQorDQorI2lmZGVm
IENPTkZJR19TTVANCiANCiAjaWZkZWYgQ09ORklHX1g4Nl8zMg0KIAkvKiBTZWUgaWYgdGhlcmUg
aGFzIGJlZW4gZ2l2ZW4gYSBjb21tYW5kIGxpbmUgb3ZlcnJpZGUgKi8NCkBAIC02NzUsMTAgKzY4
Miw2IEBAIHZvaWQgbmF0aXZlX21hY2hpbmVfc2h1dGRvd24odm9pZCkNCiANCiAJbGFwaWNfc2h1
dGRvd24oKTsNCiANCi0jaWZkZWYgQ09ORklHX1g4Nl9JT19BUElDDQotCWRpc2FibGVfSU9fQVBJ
QygpOw0KLSNlbmRpZg0KLQ0KICNpZmRlZiBDT05GSUdfSFBFVF9USU1FUg0KIAlocGV0X2Rpc2Fi
bGUoKTsNCiAjZW5kaWYNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbGFwaWMuYyBiL2FyY2gv
eDg2L2t2bS9sYXBpYy5jDQppbmRleCA1NGFiYjQwLi40M2U3NzUzIDEwMDY0NA0KLS0tIGEvYXJj
aC94ODYva3ZtL2xhcGljLmMNCisrKyBiL2FyY2gveDg2L2t2bS9sYXBpYy5jDQpAQCAtNTM3LDcg
KzUzNyw4IEBAIHN0YXRpYyB1MzIgYXBpY19nZXRfdG1jY3Qoc3RydWN0IGt2bV9sYXBpYyAqYXBp
YykNCiAJQVNTRVJUKGFwaWMgIT0gTlVMTCk7DQogDQogCS8qIGlmIGluaXRpYWwgY291bnQgaXMg
MCwgY3VycmVudCBjb3VudCBzaG91bGQgYWxzbyBiZSAwICovDQotCWlmIChhcGljX2dldF9yZWco
YXBpYywgQVBJQ19UTUlDVCkgPT0gMCkNCisJaWYgKGFwaWNfZ2V0X3JlZyhhcGljLCBBUElDX1RN
SUNUKSA9PSAwIHx8DQorCQlhcGljLT5sYXBpY190aW1lci5wZXJpb2QgPT0gMCkNCiAJCXJldHVy
biAwOw0KIA0KIAlyZW1haW5pbmcgPSBocnRpbWVyX2dldF9yZW1haW5pbmcoJmFwaWMtPmxhcGlj
X3RpbWVyLnRpbWVyKTsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9wbGF0Zm9ybS9lZmkvZWZpLmMg
Yi9hcmNoL3g4Ni9wbGF0Zm9ybS9lZmkvZWZpLmMNCmluZGV4IGExOGQyMGQuLmJlZTc1YTYgMTAw
NjQ0DQotLS0gYS9hcmNoL3g4Ni9wbGF0Zm9ybS9lZmkvZWZpLmMNCisrKyBiL2FyY2gveDg2L3Bs
YXRmb3JtL2VmaS9lZmkuYw0KQEAgLTYxNCwxMSArNjE0LDYgQEAgdm9pZCBfX2luaXQgZWZpX2lu
aXQodm9pZCkNCiANCiAJc2V0X2JpdChFRklfTUVNTUFQLCAmeDg2X2VmaV9mYWNpbGl0eSk7DQog
DQotI2lmZGVmIENPTkZJR19YODZfMzINCi0JeDg2X3BsYXRmb3JtLmdldF93YWxsY2xvY2sgPSBl
ZmlfZ2V0X3RpbWU7DQotCXg4Nl9wbGF0Zm9ybS5zZXRfd2FsbGNsb2NrID0gZWZpX3NldF9ydGNf
bW1zczsNCi0jZW5kaWYNCi0NCiAjaWYgRUZJX0RFQlVHDQogCXByaW50X2VmaV9tZW1tYXAoKTsN
CiAjZW5kaWYNCmRpZmYgLS1naXQgYS9ibG9jay9ibGstY29yZS5jIGIvYmxvY2svYmxrLWNvcmUu
Yw0KaW5kZXggNDlkOWU5MS4uYTIxOWM4OSAxMDA2NDQNCi0tLSBhL2Jsb2NrL2Jsay1jb3JlLmMN
CisrKyBiL2Jsb2NrL2Jsay1jb3JlLmMNCkBAIC00ODMsNiArNDgzLDcgQEAgc3RydWN0IHJlcXVl
c3RfcXVldWUgKmJsa19hbGxvY19xdWV1ZV9ub2RlKGdmcF90IGdmcF9tYXNrLCBpbnQgbm9kZV9p
ZCkNCiAJfQ0KIA0KIAlpZiAoYmxrX3Rocm90bF9pbml0KHEpKSB7DQorCQliZGlfZGVzdHJveSgm
cS0+YmFja2luZ19kZXZfaW5mbyk7DQogCQlrbWVtX2NhY2hlX2ZyZWUoYmxrX3JlcXVlc3RxX2Nh
Y2hlcCwgcSk7DQogCQlyZXR1cm4gTlVMTDsNCiAJfQ0KQEAgLTIwMTUsNiArMjAxNiw3IEBAIHZv
aWQgYmxrX3N0YXJ0X3JlcXVlc3Qoc3RydWN0IHJlcXVlc3QgKnJlcSkNCiAJaWYgKHVubGlrZWx5
KGJsa19iaWRpX3JxKHJlcSkpKQ0KIAkJcmVxLT5uZXh0X3JxLT5yZXNpZF9sZW4gPSBibGtfcnFf
Ynl0ZXMocmVxLT5uZXh0X3JxKTsNCiANCisJQlVHX09OKHRlc3RfYml0KFJFUV9BVE9NX0NPTVBM
RVRFLCAmcmVxLT5hdG9taWNfZmxhZ3MpKTsNCiAJYmxrX2FkZF90aW1lcihyZXEpOw0KIH0NCiBF
WFBPUlRfU1lNQk9MKGJsa19zdGFydF9yZXF1ZXN0KTsNCmRpZmYgLS1naXQgYS9ibG9jay9ibGst
dGltZW91dC5jIGIvYmxvY2svYmxrLXRpbWVvdXQuYw0KaW5kZXggNzgwMzU0OC4uYjExODJlYSAx
MDA2NDQNCi0tLSBhL2Jsb2NrL2Jsay10aW1lb3V0LmMNCisrKyBiL2Jsb2NrL2Jsay10aW1lb3V0
LmMNCkBAIC05MCw4ICs5MCw4IEBAIHN0YXRpYyB2b2lkIGJsa19ycV90aW1lZF9vdXQoc3RydWN0
IHJlcXVlc3QgKnJlcSkNCiAJCV9fYmxrX2NvbXBsZXRlX3JlcXVlc3QocmVxKTsNCiAJCWJyZWFr
Ow0KIAljYXNlIEJMS19FSF9SRVNFVF9USU1FUjoNCi0JCWJsa19jbGVhcl9ycV9jb21wbGV0ZShy
ZXEpOw0KIAkJYmxrX2FkZF90aW1lcihyZXEpOw0KKwkJYmxrX2NsZWFyX3JxX2NvbXBsZXRlKHJl
cSk7DQogCQlicmVhazsNCiAJY2FzZSBCTEtfRUhfTk9UX0hBTkRMRUQ6DQogCQkvKg0KQEAgLTE3
Myw3ICsxNzMsNiBAQCB2b2lkIGJsa19hZGRfdGltZXIoc3RydWN0IHJlcXVlc3QgKnJlcSkNCiAJ
CXJldHVybjsNCiANCiAJQlVHX09OKCFsaXN0X2VtcHR5KCZyZXEtPnRpbWVvdXRfbGlzdCkpOw0K
LQlCVUdfT04odGVzdF9iaXQoUkVRX0FUT01fQ09NUExFVEUsICZyZXEtPmF0b21pY19mbGFncykp
Ow0KIA0KIAkvKg0KIAkgKiBTb21lIExMRHMsIGxpa2Ugc2NzaSwgcGVlayBhdCB0aGUgdGltZW91
dCB0byBwcmV2ZW50IGENCmRpZmYgLS1naXQgYS9jcnlwdG8vYWxnaWZfaGFzaC5jIGIvY3J5cHRv
L2FsZ2lmX2hhc2guYw0KaW5kZXggMDI2MjIxMC4uODUwMjQ2MiAxMDA2NDQNCi0tLSBhL2NyeXB0
by9hbGdpZl9oYXNoLmMNCisrKyBiL2NyeXB0by9hbGdpZl9oYXNoLmMNCkBAIC0xMTQsNiArMTE0
LDkgQEAgc3RhdGljIHNzaXplX3QgaGFzaF9zZW5kcGFnZShzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBz
dHJ1Y3QgcGFnZSAqcGFnZSwNCiAJc3RydWN0IGhhc2hfY3R4ICpjdHggPSBhc2stPnByaXZhdGU7
DQogCWludCBlcnI7DQogDQorCWlmIChmbGFncyAmIE1TR19TRU5EUEFHRV9OT1RMQVNUKQ0KKwkJ
ZmxhZ3MgfD0gTVNHX01PUkU7DQorDQogCWxvY2tfc29jayhzayk7DQogCXNnX2luaXRfdGFibGUo
Y3R4LT5zZ2wuc2csIDEpOw0KIAlzZ19zZXRfcGFnZShjdHgtPnNnbC5zZywgcGFnZSwgc2l6ZSwg
b2Zmc2V0KTsNCkBAIC0xNjEsOCArMTY0LDYgQEAgc3RhdGljIGludCBoYXNoX3JlY3Ztc2coc3Ry
dWN0IGtpb2NiICp1bnVzZWQsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCWVsc2UgaWYgKGxlbiA8
IGRzKQ0KIAkJbXNnLT5tc2dfZmxhZ3MgfD0gTVNHX1RSVU5DOw0KIA0KLQltc2ctPm1zZ19uYW1l
bGVuID0gMDsNCi0NCiAJbG9ja19zb2NrKHNrKTsNCiAJaWYgKGN0eC0+bW9yZSkgew0KIAkJY3R4
LT5tb3JlID0gMDsNCmRpZmYgLS1naXQgYS9jcnlwdG8vYWxnaWZfc2tjaXBoZXIuYyBiL2NyeXB0
by9hbGdpZl9za2NpcGhlci5jDQppbmRleCBhMWM0ZjBhLi5hMTljMDI3IDEwMDY0NA0KLS0tIGEv
Y3J5cHRvL2FsZ2lmX3NrY2lwaGVyLmMNCisrKyBiL2NyeXB0by9hbGdpZl9za2NpcGhlci5jDQpA
QCAtMzc4LDYgKzM3OCw5IEBAIHN0YXRpYyBzc2l6ZV90IHNrY2lwaGVyX3NlbmRwYWdlKHN0cnVj
dCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBwYWdlICpwYWdlLA0KIAlzdHJ1Y3Qgc2tjaXBoZXJfc2df
bGlzdCAqc2dsOw0KIAlpbnQgZXJyID0gLUVJTlZBTDsNCiANCisJaWYgKGZsYWdzICYgTVNHX1NF
TkRQQUdFX05PVExBU1QpDQorCQlmbGFncyB8PSBNU0dfTU9SRTsNCisNCiAJbG9ja19zb2NrKHNr
KTsNCiAJaWYgKCFjdHgtPm1vcmUgJiYgY3R4LT51c2VkKQ0KIAkJZ290byB1bmxvY2s7DQpAQCAt
NDMyLDcgKzQzNSw2IEBAIHN0YXRpYyBpbnQgc2tjaXBoZXJfcmVjdm1zZyhzdHJ1Y3Qga2lvY2Ig
KnVudXNlZCwgc3RydWN0IHNvY2tldCAqc29jaywNCiAJbG9uZyBjb3BpZWQgPSAwOw0KIA0KIAls
b2NrX3NvY2soc2spOw0KLQltc2ctPm1zZ19uYW1lbGVuID0gMDsNCiAJZm9yIChpb3YgPSBtc2ct
Pm1zZ19pb3YsIGlvdmxlbiA9IG1zZy0+bXNnX2lvdmxlbjsgaW92bGVuID4gMDsNCiAJICAgICBp
b3ZsZW4tLSwgaW92KyspIHsNCiAJCXVuc2lnbmVkIGxvbmcgc2VnbGVuID0gaW92LT5pb3ZfbGVu
Ow0KZGlmZiAtLWdpdCBhL2NyeXB0by9hbnNpX2Nwcm5nLmMgYi9jcnlwdG8vYW5zaV9jcHJuZy5j
DQppbmRleCBmZmEwMjQ1Li42MDU2MTc4IDEwMDY0NA0KLS0tIGEvY3J5cHRvL2Fuc2lfY3Bybmcu
Yw0KKysrIGIvY3J5cHRvL2Fuc2lfY3BybmcuYw0KQEAgLTIzMCwxMSArMjMwLDExIEBAIHJlbWFp
bmRlcjoNCiAJICovDQogCWlmIChieXRlX2NvdW50IDwgREVGQVVMVF9CTEtfU1opIHsNCiBlbXB0
eV9yYnVmOg0KLQkJZm9yICg7IGN0eC0+cmFuZF9kYXRhX3ZhbGlkIDwgREVGQVVMVF9CTEtfU1o7
DQotCQkJY3R4LT5yYW5kX2RhdGFfdmFsaWQrKykgew0KKwkJd2hpbGUgKGN0eC0+cmFuZF9kYXRh
X3ZhbGlkIDwgREVGQVVMVF9CTEtfU1opIHsNCiAJCQkqcHRyID0gY3R4LT5yYW5kX2RhdGFbY3R4
LT5yYW5kX2RhdGFfdmFsaWRdOw0KIAkJCXB0cisrOw0KIAkJCWJ5dGVfY291bnQtLTsNCisJCQlj
dHgtPnJhbmRfZGF0YV92YWxpZCsrOw0KIAkJCWlmIChieXRlX2NvdW50ID09IDApDQogCQkJCWdv
dG8gZG9uZTsNCiAJCX0NCmRpZmYgLS1naXQgYS9jcnlwdG8vYXV0aGVuYy5jIGIvY3J5cHRvL2F1
dGhlbmMuYw0KaW5kZXggNWVmN2JhNi4uZDIxZGEyZiAxMDA2NDQNCi0tLSBhL2NyeXB0by9hdXRo
ZW5jLmMNCisrKyBiL2NyeXB0by9hdXRoZW5jLmMNCkBAIC0zNjgsOSArMzY4LDEwIEBAIHN0YXRp
YyB2b2lkIGNyeXB0b19hdXRoZW5jX2VuY3J5cHRfZG9uZShzdHJ1Y3QgY3J5cHRvX2FzeW5jX3Jl
cXVlc3QgKnJlcSwNCiAJaWYgKCFlcnIpIHsNCiAJCXN0cnVjdCBjcnlwdG9fYWVhZCAqYXV0aGVu
YyA9IGNyeXB0b19hZWFkX3JlcXRmbShhcmVxKTsNCiAJCXN0cnVjdCBjcnlwdG9fYXV0aGVuY19j
dHggKmN0eCA9IGNyeXB0b19hZWFkX2N0eChhdXRoZW5jKTsNCi0JCXN0cnVjdCBhYmxrY2lwaGVy
X3JlcXVlc3QgKmFicmVxID0gYWVhZF9yZXF1ZXN0X2N0eChhcmVxKTsNCi0JCXU4ICppdiA9ICh1
OCAqKShhYnJlcSArIDEpICsNCi0JCQkgY3J5cHRvX2FibGtjaXBoZXJfcmVxc2l6ZShjdHgtPmVu
Yyk7DQorCQlzdHJ1Y3QgYXV0aGVuY19yZXF1ZXN0X2N0eCAqYXJlcV9jdHggPSBhZWFkX3JlcXVl
c3RfY3R4KGFyZXEpOw0KKwkJc3RydWN0IGFibGtjaXBoZXJfcmVxdWVzdCAqYWJyZXEgPSAodm9p
ZCAqKShhcmVxX2N0eC0+dGFpbA0KKwkJCQkJCQkgICAgKyBjdHgtPnJlcW9mZik7DQorCQl1OCAq
aXYgPSAodTggKilhYnJlcSAtIGNyeXB0b19hYmxrY2lwaGVyX2l2c2l6ZShjdHgtPmVuYyk7DQog
DQogCQllcnIgPSBjcnlwdG9fYXV0aGVuY19nZW5pY3YoYXJlcSwgaXYsIDApOw0KIAl9DQpkaWZm
IC0tZ2l0IGEvY3J5cHRvL2NjbS5jIGIvY3J5cHRvL2NjbS5jDQppbmRleCBjMzZkNjU0Li4yMDAy
Y2E3IDEwMDY0NA0KLS0tIGEvY3J5cHRvL2NjbS5jDQorKysgYi9jcnlwdG8vY2NtLmMNCkBAIC0y
NzEsNyArMjcxLDggQEAgc3RhdGljIGludCBjcnlwdG9fY2NtX2F1dGgoc3RydWN0IGFlYWRfcmVx
dWVzdCAqcmVxLCBzdHJ1Y3Qgc2NhdHRlcmxpc3QgKnBsYWluLA0KIAl9DQogDQogCS8qIGNvbXB1
dGUgcGxhaW50ZXh0IGludG8gbWFjICovDQotCWdldF9kYXRhX3RvX2NvbXB1dGUoY2lwaGVyLCBw
Y3R4LCBwbGFpbiwgY3J5cHRsZW4pOw0KKwlpZiAoY3J5cHRsZW4pDQorCQlnZXRfZGF0YV90b19j
b21wdXRlKGNpcGhlciwgcGN0eCwgcGxhaW4sIGNyeXB0bGVuKTsNCiANCiBvdXQ6DQogCXJldHVy
biBlcnI7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hdGEvYWhjaS5jIGIvZHJpdmVycy9hdGEvYWhj
aS5jDQppbmRleCAwNDQ1ZjUyLi5kMjlmNmQ1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9hdGEvYWhj
aS5jDQorKysgYi9kcml2ZXJzL2F0YS9haGNpLmMNCkBAIC0zMDMsNiArMzAzLDEwIEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCBhaGNpX3BjaV90YmxbXSA9IHsNCiAJeyBQQ0lf
VkRFVklDRShJTlRFTCwgMHg4ZDY2KSwgYm9hcmRfYWhjaSB9LCAvKiBXZWxsc2J1cmcgUkFJRCAq
Lw0KIAl7IFBDSV9WREVWSUNFKElOVEVMLCAweDhkNmUpLCBib2FyZF9haGNpIH0sIC8qIFdlbGxz
YnVyZyBSQUlEICovDQogCXsgUENJX1ZERVZJQ0UoSU5URUwsIDB4MjNhMyksIGJvYXJkX2FoY2kg
fSwgLyogQ29sZXRvIENyZWVrIEFIQ0kgKi8NCisJeyBQQ0lfVkRFVklDRShJTlRFTCwgMHg5Yzgz
KSwgYm9hcmRfYWhjaSB9LCAvKiBXaWxkY2F0IFBvaW50LUxQIEFIQ0kgKi8NCisJeyBQQ0lfVkRF
VklDRShJTlRFTCwgMHg5Yzg1KSwgYm9hcmRfYWhjaSB9LCAvKiBXaWxkY2F0IFBvaW50LUxQIFJB
SUQgKi8NCisJeyBQQ0lfVkRFVklDRShJTlRFTCwgMHg5Yzg3KSwgYm9hcmRfYWhjaSB9LCAvKiBX
aWxkY2F0IFBvaW50LUxQIFJBSUQgKi8NCisJeyBQQ0lfVkRFVklDRShJTlRFTCwgMHg5YzhmKSwg
Ym9hcmRfYWhjaSB9LCAvKiBXaWxkY2F0IFBvaW50LUxQIFJBSUQgKi8NCiANCiAJLyogSk1pY3Jv
biAzNjAvMS8zLzUvNiwgbWF0Y2ggY2xhc3MgdG8gYXZvaWQgSURFIGZ1bmN0aW9uICovDQogCXsg
UENJX1ZFTkRPUl9JRF9KTUlDUk9OLCBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lE
LA0KQEAgLTQzNyw2ICs0NDEsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQg
YWhjaV9wY2lfdGJsW10gPSB7DQogCSAgLmRyaXZlcl9kYXRhID0gYm9hcmRfYWhjaV95ZXNfZmJz
IH0sCQkJLyogODhzZTkxNzIgb24gc29tZSBHaWdhYnl0ZSAqLw0KIAl7IFBDSV9ERVZJQ0UoMHgx
YjRiLCAweDkxYTMpLA0KIAkgIC5kcml2ZXJfZGF0YSA9IGJvYXJkX2FoY2lfeWVzX2ZicyB9LA0K
Kwl7IFBDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9NQVJWRUxMX0VYVCwgMHg5MjMwKSwNCisJICAu
ZHJpdmVyX2RhdGEgPSBib2FyZF9haGNpX3llc19mYnMgfSwNCiANCiAJLyogUHJvbWlzZSAqLw0K
IAl7IFBDSV9WREVWSUNFKFBST01JU0UsIDB4M2YyMCksIGJvYXJkX2FoY2kgfSwJLyogUERDNDI4
MTkgKi8NCmRpZmYgLS1naXQgYS9kcml2ZXJzL2F0YS9haGNpX3BsYXRmb3JtLmMgYi9kcml2ZXJz
L2F0YS9haGNpX3BsYXRmb3JtLmMNCmluZGV4IDQzYjg3NTguLjY2OTIxMDggMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL2F0YS9haGNpX3BsYXRmb3JtLmMNCisrKyBiL2RyaXZlcnMvYXRhL2FoY2lfcGxh
dGZvcm0uYw0KQEAgLTIwNCw2ICsyMDQsNyBAQCBzdGF0aWMgaW50IF9fZGV2ZXhpdCBhaGNpX3Jl
bW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KIA0KIHN0YXRpYyBjb25zdCBzdHJ1
Y3Qgb2ZfZGV2aWNlX2lkIGFoY2lfb2ZfbWF0Y2hbXSA9IHsNCiAJeyAuY29tcGF0aWJsZSA9ICJj
YWx4ZWRhLGhiLWFoY2kiLCB9LA0KKwl7IC5jb21wYXRpYmxlID0gImlibSw0NzZndHItYWhjaSIs
IH0sDQogCXt9LA0KIH07DQogTU9EVUxFX0RFVklDRV9UQUJMRShvZiwgYWhjaV9vZl9tYXRjaCk7
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hdGEvbGliYWhjaS5jIGIvZHJpdmVycy9hdGEvbGliYWhj
aS5jDQppbmRleCA2MGRlZjAzLi5kZTI4MDJjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9hdGEvbGli
YWhjaS5jDQorKysgYi9kcml2ZXJzL2F0YS9saWJhaGNpLmMNCkBAIC0xMjQ3LDkgKzEyNDcsMTEg
QEAgaW50IGFoY2lfZG9fc29mdHJlc2V0KHN0cnVjdCBhdGFfbGluayAqbGluaywgdW5zaWduZWQg
aW50ICpjbGFzcywNCiB7DQogCXN0cnVjdCBhdGFfcG9ydCAqYXAgPSBsaW5rLT5hcDsNCiAJc3Ry
dWN0IGFoY2lfaG9zdF9wcml2ICpocHJpdiA9IGFwLT5ob3N0LT5wcml2YXRlX2RhdGE7DQorCXN0
cnVjdCBhaGNpX3BvcnRfcHJpdiAqcHAgPSBhcC0+cHJpdmF0ZV9kYXRhOw0KIAljb25zdCBjaGFy
ICpyZWFzb24gPSBOVUxMOw0KIAl1bnNpZ25lZCBsb25nIG5vdywgbXNlY3M7DQogCXN0cnVjdCBh
dGFfdGFza2ZpbGUgdGY7DQorCWJvb2wgZmJzX2Rpc2FibGVkID0gZmFsc2U7DQogCWludCByYzsN
CiANCiAJRFBSSU5USygiRU5URVJcbiIpOw0KQEAgLTEyNTksNiArMTI2MSwxNiBAQCBpbnQgYWhj
aV9kb19zb2Z0cmVzZXQoc3RydWN0IGF0YV9saW5rICpsaW5rLCB1bnNpZ25lZCBpbnQgKmNsYXNz
LA0KIAlpZiAocmMgJiYgcmMgIT0gLUVPUE5PVFNVUFApDQogCQlhdGFfbGlua193YXJuKGxpbmss
ICJmYWlsZWQgdG8gcmVzZXQgZW5naW5lIChlcnJubz0lZClcbiIsIHJjKTsNCiANCisJLyoNCisJ
ICogQWNjb3JkaW5nIHRvIEFIQ0ktMS4yIDkuMy45OiBpZiBGQlMgaXMgZW5hYmxlLCBzb2Z0d2Fy
ZSBzaGFsbA0KKwkgKiBjbGVhciBQeEZCUy5FTiB0byAnMCcgcHJpb3IgdG8gaXNzdWluZyBzb2Z0
d2FyZSByZXNldCB0byBkZXZpY2VzDQorCSAqIHRoYXQgaXMgYXR0YWNoZWQgdG8gcG9ydCBtdWx0
aXBsaWVyLg0KKwkgKi8NCisJaWYgKCFhdGFfaXNfaG9zdF9saW5rKGxpbmspICYmIHBwLT5mYnNf
ZW5hYmxlZCkgew0KKwkJYWhjaV9kaXNhYmxlX2ZicyhhcCk7DQorCQlmYnNfZGlzYWJsZWQgPSB0
cnVlOw0KKwl9DQorDQogCWF0YV90Zl9pbml0KGxpbmstPmRldmljZSwgJnRmKTsNCiANCiAJLyog
aXNzdWUgdGhlIGZpcnN0IEQySCBSZWdpc3RlciBGSVMgKi8NCkBAIC0xMjk5LDYgKzEzMTEsMTAg
QEAgaW50IGFoY2lfZG9fc29mdHJlc2V0KHN0cnVjdCBhdGFfbGluayAqbGluaywgdW5zaWduZWQg
aW50ICpjbGFzcywNCiAJfSBlbHNlDQogCQkqY2xhc3MgPSBhaGNpX2Rldl9jbGFzc2lmeShhcCk7
DQogDQorCS8qIHJlLWVuYWJsZSBGQlMgaWYgZGlzYWJsZWQgYmVmb3JlICovDQorCWlmIChmYnNf
ZGlzYWJsZWQpDQorCQlhaGNpX2VuYWJsZV9mYnMoYXApOw0KKw0KIAlEUFJJTlRLKCJFWElULCBj
bGFzcz0ldVxuIiwgKmNsYXNzKTsNCiAJcmV0dXJuIDA7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9hdGEvbGliYXRhLWNvcmUuYyBiL2RyaXZlcnMvYXRhL2xpYmF0YS1jb3JlLmMNCmluZGV4IGQ1
NGI3ZDYuLmEwYTM5ODcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2F0YS9saWJhdGEtY29yZS5jDQor
KysgYi9kcml2ZXJzL2F0YS9saWJhdGEtY29yZS5jDQpAQCAtNDA2Nyw2ICs0MDY3LDcgQEAgc3Rh
dGljIGNvbnN0IHN0cnVjdCBhdGFfYmxhY2tsaXN0X2VudHJ5IGF0YV9kZXZpY2VfYmxhY2tsaXN0
IFtdID0gew0KIAl7ICJUT1JpU0FOIERWRC1ST00gRFJELU4yMTYiLCBOVUxMLAlBVEFfSE9SS0FH
RV9NQVhfU0VDXzEyOCB9LA0KIAl7ICJRVUFOVFVNIERBVCAgICBEQVQ3Mi0wMDAiLCBOVUxMLAlB
VEFfSE9SS0FHRV9BVEFQSV9NT0QxNl9ETUEgfSwNCiAJeyAiU2xpbXR5cGUgRFZEIEEgIERTOEE4
U0giLCBOVUxMLAlBVEFfSE9SS0FHRV9NQVhfU0VDX0xCQTQ4IH0sDQorCXsgIlNsaW10eXBlIERW
RCBBICBEUzhBOVNIIiwgTlVMTCwJQVRBX0hPUktBR0VfTUFYX1NFQ19MQkE0OCB9LA0KIA0KIAkv
KiBEZXZpY2VzIHdlIGV4cGVjdCB0byBmYWlsIGRpYWdub3N0aWNzICovDQogDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9hdGEvbGliYXRhLXRyYW5zcG9ydC5jIGIvZHJpdmVycy9hdGEvbGliYXRhLXRy
YW5zcG9ydC5jDQppbmRleCBjZTlkYzYyLi5jMDFmMDQwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9h
dGEvbGliYXRhLXRyYW5zcG9ydC5jDQorKysgYi9kcml2ZXJzL2F0YS9saWJhdGEtdHJhbnNwb3J0
LmMNCkBAIC0zMTIsMjUgKzMxMiwyNSBAQCBpbnQgYXRhX3Rwb3J0X2FkZChzdHJ1Y3QgZGV2aWNl
ICpwYXJlbnQsDQogLyoNCiAgKiBBVEEgbGluayBhdHRyaWJ1dGVzDQogICovDQorc3RhdGljIGlu
dCBub29wKGludCB4KSB7IHJldHVybiB4OyB9DQogDQotDQotI2RlZmluZSBhdGFfbGlua19zaG93
X2xpbmtzcGVlZChmaWVsZCkJCQkJCVwNCisjZGVmaW5lIGF0YV9saW5rX3Nob3dfbGlua3NwZWVk
KGZpZWxkLCBmb3JtYXQpCQkJICAgICAgICBcDQogc3RhdGljIHNzaXplX3QJCQkJCQkJCVwNCiBz
aG93X2F0YV9saW5rXyMjZmllbGQoc3RydWN0IGRldmljZSAqZGV2LAkJCQlcDQogCQkgICAgICBz
dHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQkJXA0KIHsJCQkJCQkJCQlc
DQogCXN0cnVjdCBhdGFfbGluayAqbGluayA9IHRyYW5zcG9ydF9jbGFzc190b19saW5rKGRldik7
CQlcDQogCQkJCQkJCQkJXA0KLQlyZXR1cm4gc3ByaW50ZihidWYsIiVzXG4iLCBzYXRhX3NwZF9z
dHJpbmcoZmxzKGxpbmstPmZpZWxkKSkpOwlcDQorCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVzXG4i
LCBzYXRhX3NwZF9zdHJpbmcoZm9ybWF0KGxpbmstPmZpZWxkKSkpOyBcDQogfQ0KIA0KLSNkZWZp
bmUgYXRhX2xpbmtfbGlua3NwZWVkX2F0dHIoZmllbGQpCQkJCQlcDQotCWF0YV9saW5rX3Nob3df
bGlua3NwZWVkKGZpZWxkKQkJCQkJXA0KKyNkZWZpbmUgYXRhX2xpbmtfbGlua3NwZWVkX2F0dHIo
ZmllbGQsIGZvcm1hdCkJCQkJXA0KKwlhdGFfbGlua19zaG93X2xpbmtzcGVlZChmaWVsZCwgZm9y
bWF0KQkJCQlcDQogc3RhdGljIERFVklDRV9BVFRSKGZpZWxkLCBTX0lSVUdPLCBzaG93X2F0YV9s
aW5rXyMjZmllbGQsIE5VTEwpDQogDQotYXRhX2xpbmtfbGlua3NwZWVkX2F0dHIoaHdfc2F0YV9z
cGRfbGltaXQpOw0KLWF0YV9saW5rX2xpbmtzcGVlZF9hdHRyKHNhdGFfc3BkX2xpbWl0KTsNCi1h
dGFfbGlua19saW5rc3BlZWRfYXR0cihzYXRhX3NwZCk7DQorYXRhX2xpbmtfbGlua3NwZWVkX2F0
dHIoaHdfc2F0YV9zcGRfbGltaXQsIGZscyk7DQorYXRhX2xpbmtfbGlua3NwZWVkX2F0dHIoc2F0
YV9zcGRfbGltaXQsIGZscyk7DQorYXRhX2xpbmtfbGlua3NwZWVkX2F0dHIoc2F0YV9zcGQsIG5v
b3ApOw0KIA0KIA0KIHN0YXRpYyBERUNMQVJFX1RSQU5TUE9SVF9DTEFTUyhhdGFfbGlua19jbGFz
cywNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2F0bS9pZHQ3NzI1Mi5jIGIvZHJpdmVycy9hdG0vaWR0
NzcyNTIuYw0KaW5kZXggMWMwNTIxMi4uYjBlNzVjZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvYXRt
L2lkdDc3MjUyLmMNCisrKyBiL2RyaXZlcnMvYXRtL2lkdDc3MjUyLmMNCkBAIC0zNTEzLDcgKzM1
MTMsNyBAQCBpbml0X2NhcmQoc3RydWN0IGF0bV9kZXYgKmRldikNCiAJdG1wID0gZGV2X2dldF9i
eV9uYW1lKCZpbml0X25ldCwgdG5hbWUpOwkvKiBqaHM6IHdhcyAidG1wID0gZGV2X2dldCh0bmFt
ZSk7IiAqLw0KIAlpZiAodG1wKSB7DQogCQltZW1jcHkoY2FyZC0+YXRtZGV2LT5lc2ksIHRtcC0+
ZGV2X2FkZHIsIDYpOw0KLQ0KKwkJZGV2X3B1dCh0bXApOw0KIAkJcHJpbnRrKCIlczogRVNJICVw
TVxuIiwgY2FyZC0+bmFtZSwgY2FyZC0+YXRtZGV2LT5lc2kpOw0KIAl9DQogCS8qDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9ibG9jay9icmQuYyBiL2RyaXZlcnMvYmxvY2svYnJkLmMNCmluZGV4IDk2
OGEwZDQuLmYzNTk3NWYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Jsb2NrL2JyZC5jDQorKysgYi9k
cml2ZXJzL2Jsb2NrL2JyZC5jDQpAQCAtNTQ3LDcgKzU0Nyw3IEBAIHN0YXRpYyBzdHJ1Y3Qga29i
amVjdCAqYnJkX3Byb2JlKGRldl90IGRldiwgaW50ICpwYXJ0LCB2b2lkICpkYXRhKQ0KIA0KIAlt
dXRleF9sb2NrKCZicmRfZGV2aWNlc19tdXRleCk7DQogCWJyZCA9IGJyZF9pbml0X29uZShNSU5P
UihkZXYpID4+IHBhcnRfc2hpZnQpOw0KLQlrb2JqID0gYnJkID8gZ2V0X2Rpc2soYnJkLT5icmRf
ZGlzaykgOiBFUlJfUFRSKC1FTk9NRU0pOw0KKwlrb2JqID0gYnJkID8gZ2V0X2Rpc2soYnJkLT5i
cmRfZGlzaykgOiBOVUxMOw0KIAltdXRleF91bmxvY2soJmJyZF9kZXZpY2VzX211dGV4KTsNCiAN
CiAJKnBhcnQgPSAwOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svbG9vcC5jIGIvZHJpdmVy
cy9ibG9jay9sb29wLmMNCmluZGV4IGEzNjU1NjIuLmQ2NTkxMzUgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL2Jsb2NrL2xvb3AuYw0KKysrIGIvZHJpdmVycy9ibG9jay9sb29wLmMNCkBAIC0xNjM1LDcg
KzE2MzUsNyBAQCBzdGF0aWMgaW50IGxvb3BfYWRkKHN0cnVjdCBsb29wX2RldmljZSAqKmwsIGlu
dCBpKQ0KIA0KIAlsby0+bG9fcXVldWUgPSBibGtfYWxsb2NfcXVldWUoR0ZQX0tFUk5FTCk7DQog
CWlmICghbG8tPmxvX3F1ZXVlKQ0KLQkJZ290byBvdXRfZnJlZV9kZXY7DQorCQlnb3RvIG91dF9m
cmVlX2lkcjsNCiANCiAJZGlzayA9IGxvLT5sb19kaXNrID0gYWxsb2NfZGlzaygxIDw8IHBhcnRf
c2hpZnQpOw0KIAlpZiAoIWRpc2spDQpAQCAtMTY3OSw2ICsxNjc5LDggQEAgc3RhdGljIGludCBs
b29wX2FkZChzdHJ1Y3QgbG9vcF9kZXZpY2UgKipsLCBpbnQgaSkNCiANCiBvdXRfZnJlZV9xdWV1
ZToNCiAJYmxrX2NsZWFudXBfcXVldWUobG8tPmxvX3F1ZXVlKTsNCitvdXRfZnJlZV9pZHI6DQor
CWlkcl9yZW1vdmUoJmxvb3BfaW5kZXhfaWRyLCBpKTsNCiBvdXRfZnJlZV9kZXY6DQogCWtmcmVl
KGxvKTsNCiBvdXQ6DQpAQCAtMTc0Miw3ICsxNzQ0LDcgQEAgc3RhdGljIHN0cnVjdCBrb2JqZWN0
ICpsb29wX3Byb2JlKGRldl90IGRldiwgaW50ICpwYXJ0LCB2b2lkICpkYXRhKQ0KIAlpZiAoZXJy
IDwgMCkNCiAJCWVyciA9IGxvb3BfYWRkKCZsbywgTUlOT1IoZGV2KSA+PiBwYXJ0X3NoaWZ0KTsN
CiAJaWYgKGVyciA8IDApDQotCQlrb2JqID0gRVJSX1BUUihlcnIpOw0KKwkJa29iaiA9IE5VTEw7
DQogCWVsc2UNCiAJCWtvYmogPSBnZXRfZGlzayhsby0+bG9fZGlzayk7DQogCW11dGV4X3VubG9j
aygmbG9vcF9pbmRleF9tdXRleCk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL2k4ay5jIGIv
ZHJpdmVycy9jaGFyL2k4ay5jDQppbmRleCA2ZTQwMDcyLi41MWVmY2JjIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9jaGFyL2k4ay5jDQorKysgYi9kcml2ZXJzL2NoYXIvaThrLmMNCkBAIC02NjQsNiAr
NjY0LDEzIEBAIHN0YXRpYyBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCBfX2luaXRkYXRhIGk4a19kbWlf
dGFibGVbXSA9IHsNCiAJCQlETUlfTUFUQ0goRE1JX1BST0RVQ1RfTkFNRSwgIlZvc3RybyIpLA0K
IAkJfSwNCiAJfSwNCisJew0KKwkJLmlkZW50ID0gIkRlbGwgWFBTNDIxIiwNCisJCS5tYXRjaGVz
ID0gew0KKwkJCURNSV9NQVRDSChETUlfU1lTX1ZFTkRPUiwgIkRlbGwgSW5jLiIpLA0KKwkJCURN
SV9NQVRDSChETUlfUFJPRFVDVF9OQU1FLCAiWFBTIEw0MjFYIiksDQorCQl9LA0KKwl9LA0KICAg
ICAgICAgeyB9DQogfTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Nvbm5lY3Rvci9jbl9wcm9j
LmMgYi9kcml2ZXJzL2Nvbm5lY3Rvci9jbl9wcm9jLmMNCmluZGV4IDY2ZDUzODQuLjA5NGE3MTAg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL2Nvbm5lY3Rvci9jbl9wcm9jLmMNCisrKyBiL2RyaXZlcnMv
Y29ubmVjdG9yL2NuX3Byb2MuYw0KQEAgLTMxLDExICszMSwyMyBAQA0KICNpbmNsdWRlIDxsaW51
eC9wdHJhY2UuaD4NCiAjaW5jbHVkZSA8bGludXgvYXRvbWljLmg+DQogDQotI2luY2x1ZGUgPGFz
bS91bmFsaWduZWQuaD4NCi0NCiAjaW5jbHVkZSA8bGludXgvY25fcHJvYy5oPg0KIA0KLSNkZWZp
bmUgQ05fUFJPQ19NU0dfU0laRSAoc2l6ZW9mKHN0cnVjdCBjbl9tc2cpICsgc2l6ZW9mKHN0cnVj
dCBwcm9jX2V2ZW50KSkNCisvKg0KKyAqIFNpemUgb2YgYSBjbl9tc2cgZm9sbG93ZWQgYnkgYSBw
cm9jX2V2ZW50IHN0cnVjdHVyZS4gIFNpbmNlIHRoZQ0KKyAqIHNpemVvZiBzdHJ1Y3QgY25fbXNn
IGlzIGEgbXVsdGlwbGUgb2YgNCBieXRlcywgYnV0IG5vdCA4IGJ5dGVzLCB3ZQ0KKyAqIGFkZCBv
bmUgNC1ieXRlIHdvcmQgdG8gdGhlIHNpemUgaGVyZSwgYW5kIHRoZW4gc3RhcnQgdGhlIGFjdHVh
bA0KKyAqIGNuX21zZyBzdHJ1Y3R1cmUgNCBieXRlcyBpbnRvIHRoZSBzdGFjayBidWZmZXIuICBU
aGUgcmVzdWx0IGlzIHRoYXQNCisgKiB0aGUgaW1tZWRpYXRlbHkgZm9sbG93aW5nIHByb2NfZXZl
bnQgc3RydWN0dXJlIGlzIGFsaWduZWQgdG8gOCBieXRlcy4NCisgKi8NCisjZGVmaW5lIENOX1BS
T0NfTVNHX1NJWkUgKHNpemVvZihzdHJ1Y3QgY25fbXNnKSArIHNpemVvZihzdHJ1Y3QgcHJvY19l
dmVudCkgKyA0KQ0KKw0KKy8qIFNlZSBjb21tZW50IGFib3ZlOyB3ZSB0ZXN0IG91ciBhc3N1bXB0
aW9uIGFib3V0IHNpemVvZiBzdHJ1Y3QgY25fbXNnIGhlcmUuICovDQorc3RhdGljIGlubGluZSBz
dHJ1Y3QgY25fbXNnICpidWZmZXJfdG9fY25fbXNnKF9fdTggKmJ1ZmZlcikNCit7DQorCUJVSUxE
X0JVR19PTihzaXplb2Yoc3RydWN0IGNuX21zZykgIT0gMjApOw0KKwlyZXR1cm4gKHN0cnVjdCBj
bl9tc2cgKikoYnVmZmVyICsgNCk7DQorfQ0KIA0KIHN0YXRpYyBhdG9taWNfdCBwcm9jX2V2ZW50
X251bV9saXN0ZW5lcnMgPSBBVE9NSUNfSU5JVCgwKTsNCiBzdGF0aWMgc3RydWN0IGNiX2lkIGNu
X3Byb2NfZXZlbnRfaWQgPSB7IENOX0lEWF9QUk9DLCBDTl9WQUxfUFJPQyB9Ow0KQEAgLTU1LDE5
ICs2NywxOSBAQCB2b2lkIHByb2NfZm9ya19jb25uZWN0b3Ioc3RydWN0IHRhc2tfc3RydWN0ICp0
YXNrKQ0KIHsNCiAJc3RydWN0IGNuX21zZyAqbXNnOw0KIAlzdHJ1Y3QgcHJvY19ldmVudCAqZXY7
DQotCV9fdTggYnVmZmVyW0NOX1BST0NfTVNHX1NJWkVdOw0KKwlfX3U4IGJ1ZmZlcltDTl9QUk9D
X01TR19TSVpFXSBfX2FsaWduZWQoOCk7DQogCXN0cnVjdCB0aW1lc3BlYyB0czsNCiAJc3RydWN0
IHRhc2tfc3RydWN0ICpwYXJlbnQ7DQogDQogCWlmIChhdG9taWNfcmVhZCgmcHJvY19ldmVudF9u
dW1fbGlzdGVuZXJzKSA8IDEpDQogCQlyZXR1cm47DQogDQotCW1zZyA9IChzdHJ1Y3QgY25fbXNn
KilidWZmZXI7DQorCW1zZyA9IGJ1ZmZlcl90b19jbl9tc2coYnVmZmVyKTsNCiAJZXYgPSAoc3Ry
dWN0IHByb2NfZXZlbnQqKW1zZy0+ZGF0YTsNCiAJbWVtc2V0KCZldi0+ZXZlbnRfZGF0YSwgMCwg
c2l6ZW9mKGV2LT5ldmVudF9kYXRhKSk7DQogCWdldF9zZXEoJm1zZy0+c2VxLCAmZXYtPmNwdSk7
DQogCWt0aW1lX2dldF90cygmdHMpOyAvKiBnZXQgaGlnaCByZXMgbW9ub3RvbmljIHRpbWVzdGFt
cCAqLw0KLQlwdXRfdW5hbGlnbmVkKHRpbWVzcGVjX3RvX25zKCZ0cyksIChfX3U2NCAqKSZldi0+
dGltZXN0YW1wX25zKTsNCisJZXYtPnRpbWVzdGFtcF9ucyA9IHRpbWVzcGVjX3RvX25zKCZ0cyk7
DQogCWV2LT53aGF0ID0gUFJPQ19FVkVOVF9GT1JLOw0KIAlyY3VfcmVhZF9sb2NrKCk7DQogCXBh
cmVudCA9IHJjdV9kZXJlZmVyZW5jZSh0YXNrLT5yZWFsX3BhcmVudCk7DQpAQCAtOTAsMTcgKzEw
MiwxNyBAQCB2b2lkIHByb2NfZXhlY19jb25uZWN0b3Ioc3RydWN0IHRhc2tfc3RydWN0ICp0YXNr
KQ0KIAlzdHJ1Y3QgY25fbXNnICptc2c7DQogCXN0cnVjdCBwcm9jX2V2ZW50ICpldjsNCiAJc3Ry
dWN0IHRpbWVzcGVjIHRzOw0KLQlfX3U4IGJ1ZmZlcltDTl9QUk9DX01TR19TSVpFXTsNCisJX191
OCBidWZmZXJbQ05fUFJPQ19NU0dfU0laRV0gX19hbGlnbmVkKDgpOw0KIA0KIAlpZiAoYXRvbWlj
X3JlYWQoJnByb2NfZXZlbnRfbnVtX2xpc3RlbmVycykgPCAxKQ0KIAkJcmV0dXJuOw0KIA0KLQlt
c2cgPSAoc3RydWN0IGNuX21zZyopYnVmZmVyOw0KKwltc2cgPSBidWZmZXJfdG9fY25fbXNnKGJ1
ZmZlcik7DQogCWV2ID0gKHN0cnVjdCBwcm9jX2V2ZW50Kiltc2ctPmRhdGE7DQogCW1lbXNldCgm
ZXYtPmV2ZW50X2RhdGEsIDAsIHNpemVvZihldi0+ZXZlbnRfZGF0YSkpOw0KIAlnZXRfc2VxKCZt
c2ctPnNlcSwgJmV2LT5jcHUpOw0KIAlrdGltZV9nZXRfdHMoJnRzKTsgLyogZ2V0IGhpZ2ggcmVz
IG1vbm90b25pYyB0aW1lc3RhbXAgKi8NCi0JcHV0X3VuYWxpZ25lZCh0aW1lc3BlY190b19ucygm
dHMpLCAoX191NjQgKikmZXYtPnRpbWVzdGFtcF9ucyk7DQorCWV2LT50aW1lc3RhbXBfbnMgPSB0
aW1lc3BlY190b19ucygmdHMpOw0KIAlldi0+d2hhdCA9IFBST0NfRVZFTlRfRVhFQzsNCiAJZXYt
PmV2ZW50X2RhdGEuZXhlYy5wcm9jZXNzX3BpZCA9IHRhc2stPnBpZDsNCiAJZXYtPmV2ZW50X2Rh
dGEuZXhlYy5wcm9jZXNzX3RnaWQgPSB0YXNrLT50Z2lkOw0KQEAgLTExNiwxNCArMTI4LDE0IEBA
IHZvaWQgcHJvY19pZF9jb25uZWN0b3Ioc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrLCBpbnQgd2hp
Y2hfaWQpDQogew0KIAlzdHJ1Y3QgY25fbXNnICptc2c7DQogCXN0cnVjdCBwcm9jX2V2ZW50ICpl
djsNCi0JX191OCBidWZmZXJbQ05fUFJPQ19NU0dfU0laRV07DQorCV9fdTggYnVmZmVyW0NOX1BS
T0NfTVNHX1NJWkVdIF9fYWxpZ25lZCg4KTsNCiAJc3RydWN0IHRpbWVzcGVjIHRzOw0KIAljb25z
dCBzdHJ1Y3QgY3JlZCAqY3JlZDsNCiANCiAJaWYgKGF0b21pY19yZWFkKCZwcm9jX2V2ZW50X251
bV9saXN0ZW5lcnMpIDwgMSkNCiAJCXJldHVybjsNCiANCi0JbXNnID0gKHN0cnVjdCBjbl9tc2cq
KWJ1ZmZlcjsNCisJbXNnID0gYnVmZmVyX3RvX2NuX21zZyhidWZmZXIpOw0KIAlldiA9IChzdHJ1
Y3QgcHJvY19ldmVudCopbXNnLT5kYXRhOw0KIAltZW1zZXQoJmV2LT5ldmVudF9kYXRhLCAwLCBz
aXplb2YoZXYtPmV2ZW50X2RhdGEpKTsNCiAJZXYtPndoYXQgPSB3aGljaF9pZDsNCkBAIC0xNDQs
NyArMTU2LDcgQEAgdm9pZCBwcm9jX2lkX2Nvbm5lY3RvcihzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRh
c2ssIGludCB3aGljaF9pZCkNCiAJcmN1X3JlYWRfdW5sb2NrKCk7DQogCWdldF9zZXEoJm1zZy0+
c2VxLCAmZXYtPmNwdSk7DQogCWt0aW1lX2dldF90cygmdHMpOyAvKiBnZXQgaGlnaCByZXMgbW9u
b3RvbmljIHRpbWVzdGFtcCAqLw0KLQlwdXRfdW5hbGlnbmVkKHRpbWVzcGVjX3RvX25zKCZ0cyks
IChfX3U2NCAqKSZldi0+dGltZXN0YW1wX25zKTsNCisJZXYtPnRpbWVzdGFtcF9ucyA9IHRpbWVz
cGVjX3RvX25zKCZ0cyk7DQogDQogCW1lbWNweSgmbXNnLT5pZCwgJmNuX3Byb2NfZXZlbnRfaWQs
IHNpemVvZihtc2ctPmlkKSk7DQogCW1zZy0+YWNrID0gMDsgLyogbm90IHVzZWQgKi8NCkBAIC0x
NTgsMTcgKzE3MCwxNyBAQCB2b2lkIHByb2Nfc2lkX2Nvbm5lY3RvcihzdHJ1Y3QgdGFza19zdHJ1
Y3QgKnRhc2spDQogCXN0cnVjdCBjbl9tc2cgKm1zZzsNCiAJc3RydWN0IHByb2NfZXZlbnQgKmV2
Ow0KIAlzdHJ1Y3QgdGltZXNwZWMgdHM7DQotCV9fdTggYnVmZmVyW0NOX1BST0NfTVNHX1NJWkVd
Ow0KKwlfX3U4IGJ1ZmZlcltDTl9QUk9DX01TR19TSVpFXSBfX2FsaWduZWQoOCk7DQogDQogCWlm
IChhdG9taWNfcmVhZCgmcHJvY19ldmVudF9udW1fbGlzdGVuZXJzKSA8IDEpDQogCQlyZXR1cm47
DQogDQotCW1zZyA9IChzdHJ1Y3QgY25fbXNnICopYnVmZmVyOw0KKwltc2cgPSBidWZmZXJfdG9f
Y25fbXNnKGJ1ZmZlcik7DQogCWV2ID0gKHN0cnVjdCBwcm9jX2V2ZW50ICopbXNnLT5kYXRhOw0K
IAltZW1zZXQoJmV2LT5ldmVudF9kYXRhLCAwLCBzaXplb2YoZXYtPmV2ZW50X2RhdGEpKTsNCiAJ
Z2V0X3NlcSgmbXNnLT5zZXEsICZldi0+Y3B1KTsNCiAJa3RpbWVfZ2V0X3RzKCZ0cyk7IC8qIGdl
dCBoaWdoIHJlcyBtb25vdG9uaWMgdGltZXN0YW1wICovDQotCXB1dF91bmFsaWduZWQodGltZXNw
ZWNfdG9fbnMoJnRzKSwgKF9fdTY0ICopJmV2LT50aW1lc3RhbXBfbnMpOw0KKwlldi0+dGltZXN0
YW1wX25zID0gdGltZXNwZWNfdG9fbnMoJnRzKTsNCiAJZXYtPndoYXQgPSBQUk9DX0VWRU5UX1NJ
RDsNCiAJZXYtPmV2ZW50X2RhdGEuc2lkLnByb2Nlc3NfcGlkID0gdGFzay0+cGlkOw0KIAlldi0+
ZXZlbnRfZGF0YS5zaWQucHJvY2Vzc190Z2lkID0gdGFzay0+dGdpZDsNCkBAIC0xODUsMTcgKzE5
NywxNyBAQCB2b2lkIHByb2NfcHRyYWNlX2Nvbm5lY3RvcihzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRh
c2ssIGludCBwdHJhY2VfaWQpDQogCXN0cnVjdCBjbl9tc2cgKm1zZzsNCiAJc3RydWN0IHByb2Nf
ZXZlbnQgKmV2Ow0KIAlzdHJ1Y3QgdGltZXNwZWMgdHM7DQotCV9fdTggYnVmZmVyW0NOX1BST0Nf
TVNHX1NJWkVdOw0KKwlfX3U4IGJ1ZmZlcltDTl9QUk9DX01TR19TSVpFXSBfX2FsaWduZWQoOCk7
DQogDQogCWlmIChhdG9taWNfcmVhZCgmcHJvY19ldmVudF9udW1fbGlzdGVuZXJzKSA8IDEpDQog
CQlyZXR1cm47DQogDQotCW1zZyA9IChzdHJ1Y3QgY25fbXNnICopYnVmZmVyOw0KKwltc2cgPSBi
dWZmZXJfdG9fY25fbXNnKGJ1ZmZlcik7DQogCWV2ID0gKHN0cnVjdCBwcm9jX2V2ZW50ICopbXNn
LT5kYXRhOw0KIAltZW1zZXQoJmV2LT5ldmVudF9kYXRhLCAwLCBzaXplb2YoZXYtPmV2ZW50X2Rh
dGEpKTsNCiAJZ2V0X3NlcSgmbXNnLT5zZXEsICZldi0+Y3B1KTsNCiAJa3RpbWVfZ2V0X3RzKCZ0
cyk7IC8qIGdldCBoaWdoIHJlcyBtb25vdG9uaWMgdGltZXN0YW1wICovDQotCXB1dF91bmFsaWdu
ZWQodGltZXNwZWNfdG9fbnMoJnRzKSwgKF9fdTY0ICopJmV2LT50aW1lc3RhbXBfbnMpOw0KKwll
di0+dGltZXN0YW1wX25zID0gdGltZXNwZWNfdG9fbnMoJnRzKTsNCiAJZXYtPndoYXQgPSBQUk9D
X0VWRU5UX1BUUkFDRTsNCiAJZXYtPmV2ZW50X2RhdGEucHRyYWNlLnByb2Nlc3NfcGlkICA9IHRh
c2stPnBpZDsNCiAJZXYtPmV2ZW50X2RhdGEucHRyYWNlLnByb2Nlc3NfdGdpZCA9IHRhc2stPnRn
aWQ7DQpAQCAtMjIwLDE3ICsyMzIsMTcgQEAgdm9pZCBwcm9jX2NvbW1fY29ubmVjdG9yKHN0cnVj
dCB0YXNrX3N0cnVjdCAqdGFzaykNCiAJc3RydWN0IGNuX21zZyAqbXNnOw0KIAlzdHJ1Y3QgcHJv
Y19ldmVudCAqZXY7DQogCXN0cnVjdCB0aW1lc3BlYyB0czsNCi0JX191OCBidWZmZXJbQ05fUFJP
Q19NU0dfU0laRV07DQorCV9fdTggYnVmZmVyW0NOX1BST0NfTVNHX1NJWkVdIF9fYWxpZ25lZCg4
KTsNCiANCiAJaWYgKGF0b21pY19yZWFkKCZwcm9jX2V2ZW50X251bV9saXN0ZW5lcnMpIDwgMSkN
CiAJCXJldHVybjsNCiANCi0JbXNnID0gKHN0cnVjdCBjbl9tc2cgKilidWZmZXI7DQorCW1zZyA9
IGJ1ZmZlcl90b19jbl9tc2coYnVmZmVyKTsNCiAJZXYgPSAoc3RydWN0IHByb2NfZXZlbnQgKilt
c2ctPmRhdGE7DQogCW1lbXNldCgmZXYtPmV2ZW50X2RhdGEsIDAsIHNpemVvZihldi0+ZXZlbnRf
ZGF0YSkpOw0KIAlnZXRfc2VxKCZtc2ctPnNlcSwgJmV2LT5jcHUpOw0KIAlrdGltZV9nZXRfdHMo
JnRzKTsgLyogZ2V0IGhpZ2ggcmVzIG1vbm90b25pYyB0aW1lc3RhbXAgKi8NCi0JcHV0X3VuYWxp
Z25lZCh0aW1lc3BlY190b19ucygmdHMpLCAoX191NjQgKikmZXYtPnRpbWVzdGFtcF9ucyk7DQor
CWV2LT50aW1lc3RhbXBfbnMgPSB0aW1lc3BlY190b19ucygmdHMpOw0KIAlldi0+d2hhdCA9IFBS
T0NfRVZFTlRfQ09NTTsNCiAJZXYtPmV2ZW50X2RhdGEuY29tbS5wcm9jZXNzX3BpZCAgPSB0YXNr
LT5waWQ7DQogCWV2LT5ldmVudF9kYXRhLmNvbW0ucHJvY2Vzc190Z2lkID0gdGFzay0+dGdpZDsN
CkBAIC0yNDcsMTggKzI1OSwxOCBAQCB2b2lkIHByb2NfZXhpdF9jb25uZWN0b3Ioc3RydWN0IHRh
c2tfc3RydWN0ICp0YXNrKQ0KIHsNCiAJc3RydWN0IGNuX21zZyAqbXNnOw0KIAlzdHJ1Y3QgcHJv
Y19ldmVudCAqZXY7DQotCV9fdTggYnVmZmVyW0NOX1BST0NfTVNHX1NJWkVdOw0KKwlfX3U4IGJ1
ZmZlcltDTl9QUk9DX01TR19TSVpFXSBfX2FsaWduZWQoOCk7DQogCXN0cnVjdCB0aW1lc3BlYyB0
czsNCiANCiAJaWYgKGF0b21pY19yZWFkKCZwcm9jX2V2ZW50X251bV9saXN0ZW5lcnMpIDwgMSkN
CiAJCXJldHVybjsNCiANCi0JbXNnID0gKHN0cnVjdCBjbl9tc2cqKWJ1ZmZlcjsNCisJbXNnID0g
YnVmZmVyX3RvX2NuX21zZyhidWZmZXIpOw0KIAlldiA9IChzdHJ1Y3QgcHJvY19ldmVudCopbXNn
LT5kYXRhOw0KIAltZW1zZXQoJmV2LT5ldmVudF9kYXRhLCAwLCBzaXplb2YoZXYtPmV2ZW50X2Rh
dGEpKTsNCiAJZ2V0X3NlcSgmbXNnLT5zZXEsICZldi0+Y3B1KTsNCiAJa3RpbWVfZ2V0X3RzKCZ0
cyk7IC8qIGdldCBoaWdoIHJlcyBtb25vdG9uaWMgdGltZXN0YW1wICovDQotCXB1dF91bmFsaWdu
ZWQodGltZXNwZWNfdG9fbnMoJnRzKSwgKF9fdTY0ICopJmV2LT50aW1lc3RhbXBfbnMpOw0KKwll
di0+dGltZXN0YW1wX25zID0gdGltZXNwZWNfdG9fbnMoJnRzKTsNCiAJZXYtPndoYXQgPSBQUk9D
X0VWRU5UX0VYSVQ7DQogCWV2LT5ldmVudF9kYXRhLmV4aXQucHJvY2Vzc19waWQgPSB0YXNrLT5w
aWQ7DQogCWV2LT5ldmVudF9kYXRhLmV4aXQucHJvY2Vzc190Z2lkID0gdGFzay0+dGdpZDsNCkBA
IC0yODQsMTggKzI5NiwxOCBAQCBzdGF0aWMgdm9pZCBjbl9wcm9jX2FjayhpbnQgZXJyLCBpbnQg
cmN2ZF9zZXEsIGludCByY3ZkX2FjaykNCiB7DQogCXN0cnVjdCBjbl9tc2cgKm1zZzsNCiAJc3Ry
dWN0IHByb2NfZXZlbnQgKmV2Ow0KLQlfX3U4IGJ1ZmZlcltDTl9QUk9DX01TR19TSVpFXTsNCisJ
X191OCBidWZmZXJbQ05fUFJPQ19NU0dfU0laRV0gX19hbGlnbmVkKDgpOw0KIAlzdHJ1Y3QgdGlt
ZXNwZWMgdHM7DQogDQogCWlmIChhdG9taWNfcmVhZCgmcHJvY19ldmVudF9udW1fbGlzdGVuZXJz
KSA8IDEpDQogCQlyZXR1cm47DQogDQotCW1zZyA9IChzdHJ1Y3QgY25fbXNnKilidWZmZXI7DQor
CW1zZyA9IGJ1ZmZlcl90b19jbl9tc2coYnVmZmVyKTsNCiAJZXYgPSAoc3RydWN0IHByb2NfZXZl
bnQqKW1zZy0+ZGF0YTsNCiAJbWVtc2V0KCZldi0+ZXZlbnRfZGF0YSwgMCwgc2l6ZW9mKGV2LT5l
dmVudF9kYXRhKSk7DQogCW1zZy0+c2VxID0gcmN2ZF9zZXE7DQogCWt0aW1lX2dldF90cygmdHMp
OyAvKiBnZXQgaGlnaCByZXMgbW9ub3RvbmljIHRpbWVzdGFtcCAqLw0KLQlwdXRfdW5hbGlnbmVk
KHRpbWVzcGVjX3RvX25zKCZ0cyksIChfX3U2NCAqKSZldi0+dGltZXN0YW1wX25zKTsNCisJZXYt
PnRpbWVzdGFtcF9ucyA9IHRpbWVzcGVjX3RvX25zKCZ0cyk7DQogCWV2LT5jcHUgPSAtMTsNCiAJ
ZXYtPndoYXQgPSBQUk9DX0VWRU5UX05PTkU7DQogCWV2LT5ldmVudF9kYXRhLmFjay5lcnIgPSBl
cnI7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncGlvL2dwaW8tbXBjOHh4eC5jIGIvZHJpdmVycy9n
cGlvL2dwaW8tbXBjOHh4eC5jDQppbmRleCBlZGNmZmQ2Li4zNGJlMTNiIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9ncGlvL2dwaW8tbXBjOHh4eC5jDQorKysgYi9kcml2ZXJzL2dwaW8vZ3Bpby1tcGM4
eHh4LmMNCkBAIC02OSwxMCArNjksMTQgQEAgc3RhdGljIGludCBtcGM4NTcyX2dwaW9fZ2V0KHN0
cnVjdCBncGlvX2NoaXAgKmdjLCB1bnNpZ25lZCBpbnQgZ3BpbykNCiAJdTMyIHZhbDsNCiAJc3Ry
dWN0IG9mX21tX2dwaW9fY2hpcCAqbW0gPSB0b19vZl9tbV9ncGlvX2NoaXAoZ2MpOw0KIAlzdHJ1
Y3QgbXBjOHh4eF9ncGlvX2NoaXAgKm1wYzh4eHhfZ2MgPSB0b19tcGM4eHh4X2dwaW9fY2hpcCht
bSk7DQorCXUzMiBvdXRfbWFzaywgb3V0X3NoYWRvdzsNCiANCi0JdmFsID0gaW5fYmUzMihtbS0+
cmVncyArIEdQSU9fREFUKSAmIH5pbl9iZTMyKG1tLT5yZWdzICsgR1BJT19ESVIpOw0KKwlvdXRf
bWFzayA9IGluX2JlMzIobW0tPnJlZ3MgKyBHUElPX0RJUik7DQogDQotCXJldHVybiAodmFsIHwg
bXBjOHh4eF9nYy0+ZGF0YSkgJiBtcGM4eHh4X2dwaW8ybWFzayhncGlvKTsNCisJdmFsID0gaW5f
YmUzMihtbS0+cmVncyArIEdQSU9fREFUKSAmIH5vdXRfbWFzazsNCisJb3V0X3NoYWRvdyA9IG1w
Yzh4eHhfZ2MtPmRhdGEgJiBvdXRfbWFzazsNCisNCisJcmV0dXJuICh2YWwgfCBvdXRfc2hhZG93
KSAmIG1wYzh4eHhfZ3BpbzJtYXNrKGdwaW8pOw0KIH0NCiANCiBzdGF0aWMgaW50IG1wYzh4eHhf
Z3Bpb19nZXQoc3RydWN0IGdwaW9fY2hpcCAqZ2MsIHVuc2lnbmVkIGludCBncGlvKQ0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2Rpc3BsYXkuYyBiL2RyaXZlcnMvZ3B1
L2RybS9pOTE1L2ludGVsX2Rpc3BsYXkuYw0KaW5kZXggZWUyOWMxZi4uNmQzNjY5NSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2Rpc3BsYXkuYw0KKysrIGIvZHJpdmVy
cy9ncHUvZHJtL2k5MTUvaW50ZWxfZGlzcGxheS5jDQpAQCAtNjA2Myw3ICs2MDYzLDkgQEAgc3Rh
dGljIHZvaWQgaTl4eF91cGRhdGVfY3Vyc29yKHN0cnVjdCBkcm1fY3J0YyAqY3J0YywgdTMyIGJh
c2UpDQogCQlpbnRlbF9jcnRjLT5jdXJzb3JfdmlzaWJsZSA9IHZpc2libGU7DQogCX0NCiAJLyog
YW5kIGNvbW1pdCBjaGFuZ2VzIG9uIG5leHQgdmJsYW5rICovDQorCVBPU1RJTkdfUkVBRChDVVJD
TlRSKHBpcGUpKTsNCiAJSTkxNV9XUklURShDVVJCQVNFKHBpcGUpLCBiYXNlKTsNCisJUE9TVElO
R19SRUFEKENVUkJBU0UocGlwZSkpOw0KIH0NCiANCiBzdGF0aWMgdm9pZCBpdmJfdXBkYXRlX2N1
cnNvcihzdHJ1Y3QgZHJtX2NydGMgKmNydGMsIHUzMiBiYXNlKQ0KQEAgLTYwODgsNyArNjA5MCw5
IEBAIHN0YXRpYyB2b2lkIGl2Yl91cGRhdGVfY3Vyc29yKHN0cnVjdCBkcm1fY3J0YyAqY3J0Yywg
dTMyIGJhc2UpDQogCQlpbnRlbF9jcnRjLT5jdXJzb3JfdmlzaWJsZSA9IHZpc2libGU7DQogCX0N
CiAJLyogYW5kIGNvbW1pdCBjaGFuZ2VzIG9uIG5leHQgdmJsYW5rICovDQorCVBPU1RJTkdfUkVB
RChDVVJDTlRSX0lWQihwaXBlKSk7DQogCUk5MTVfV1JJVEUoQ1VSQkFTRV9JVkIocGlwZSksIGJh
c2UpOw0KKwlQT1NUSU5HX1JFQUQoQ1VSQkFTRV9JVkIocGlwZSkpOw0KIH0NCiANCiAvKiBJZiBu
by1wYXJ0IG9mIHRoZSBjdXJzb3IgaXMgdmlzaWJsZSBvbiB0aGUgZnJhbWVidWZmZXIsIHRoZW4g
dGhlIEdQVSBtYXkgaGFuZy4uLiAqLw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9ub3V2
ZWF1L25vdXZlYXVfZ2VtLmMgYi9kcml2ZXJzL2dwdS9kcm0vbm91dmVhdS9ub3V2ZWF1X2dlbS5j
DQppbmRleCA3Y2UzZmRlLi5iZDBiMWZjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9ncHUvZHJtL25v
dXZlYXUvbm91dmVhdV9nZW0uYw0KKysrIGIvZHJpdmVycy9ncHUvZHJtL25vdXZlYXUvbm91dmVh
dV9nZW0uYw0KQEAgLTI4MSw3ICsyODEsOCBAQCB2YWxpZGF0ZV9maW5pX2xpc3Qoc3RydWN0IGxp
c3RfaGVhZCAqbGlzdCwgc3RydWN0IG5vdXZlYXVfZmVuY2UgKmZlbmNlKQ0KIAlsaXN0X2Zvcl9l
YWNoX3NhZmUoZW50cnksIHRtcCwgbGlzdCkgew0KIAkJbnZibyA9IGxpc3RfZW50cnkoZW50cnks
IHN0cnVjdCBub3V2ZWF1X2JvLCBlbnRyeSk7DQogDQotCQlub3V2ZWF1X2JvX2ZlbmNlKG52Ym8s
IGZlbmNlKTsNCisJCWlmIChsaWtlbHkoZmVuY2UpKQ0KKwkJCW5vdXZlYXVfYm9fZmVuY2UobnZi
bywgZmVuY2UpOw0KIA0KIAkJaWYgKHVubGlrZWx5KG52Ym8tPnZhbGlkYXRlX21hcHBlZCkpIHsN
CiAJCQl0dG1fYm9fa3VubWFwKCZudmJvLT5rbWFwKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL3JhZGVvbl9sZWdhY3lfY3J0Yy5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVv
bi9yYWRlb25fbGVnYWN5X2NydGMuYw0KaW5kZXggZGFhZGYyMS4uYTkyMzhiMCAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2xlZ2FjeV9jcnRjLmMNCisrKyBiL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2xlZ2FjeV9jcnRjLmMNCkBAIC00MTYsMTIgKzQx
Niw0MCBAQCBpbnQgcmFkZW9uX2NydGNfZG9fc2V0X2Jhc2Uoc3RydWN0IGRybV9jcnRjICpjcnRj
LA0KIAkvKiBQaW4gZnJhbWVidWZmZXIgJiBnZXQgdGlsbGluZyBpbmZvcm1hdGlvbnMgKi8NCiAJ
b2JqID0gcmFkZW9uX2ZiLT5vYmo7DQogCXJibyA9IGdlbV90b19yYWRlb25fYm8ob2JqKTsNCity
ZXRyeToNCiAJciA9IHJhZGVvbl9ib19yZXNlcnZlKHJibywgZmFsc2UpOw0KIAlpZiAodW5saWtl
bHkociAhPSAwKSkNCiAJCXJldHVybiByOw0KIAlyID0gcmFkZW9uX2JvX3BpbihyYm8sIFJBREVP
Tl9HRU1fRE9NQUlOX1ZSQU0sICZiYXNlKTsNCiAJaWYgKHVubGlrZWx5KHIgIT0gMCkpIHsNCiAJ
CXJhZGVvbl9ib191bnJlc2VydmUocmJvKTsNCisNCisJCS8qIE9uIG9sZCBHUFUgbGlrZSBSTjUw
IHdpdGggbGl0dGxlIHZyYW0gcGluaW5nIGNhbiBmYWlscyBiZWNhdXNlDQorCQkgKiBjdXJyZW50
IGZiIGlzIHRha2luZyBhbGwgc3BhY2UgbmVlZGVkLiBTbyBpbnN0ZWFkIG9mIHVucGluaW5nDQor
CQkgKiB0aGUgb2xkIGJ1ZmZlciBhZnRlciBwaW5pbmcgdGhlIG5ldyBvbmUsIGZpcnN0IHVucGlu
IG9sZCBvbmUNCisJCSAqIGFuZCB0aGVuIHJldHJ5IHBpbmluZyBuZXcgb25lLg0KKwkJICoNCisJ
CSAqIEFzIG9ubHkgbWFzdGVyIGNhbiBzZXQgbW9kZSBvbmx5IG1hc3RlciBjYW4gcGluIGFuZCBp
dCBpcw0KKwkJICogdW5saWtlbHkgdGhlIG1hc3RlciBjbGllbnQgd2lsbCByYWNlIHdpdGggaXRz
ZWxmIGVzcGVjaWFseQ0KKwkJICogb24gdGhvc2Ugb2xkIGdwdSB3aXRoIHNpbmdsZSBjcnRjLg0K
KwkJICoNCisJCSAqIFdlIGRvbid0IHNodXRkb3duIHRoZSBkaXNwbGF5IGNvbnRyb2xsZXIgYmVj
YXVzZSBuZXcgYnVmZmVyDQorCQkgKiB3aWxsIGVuZCB1cCBpbiBzYW1lIHNwb3QuDQorCQkgKi8N
CisJCWlmICghYXRvbWljICYmIGZiICYmIGZiICE9IGNydGMtPmZiKSB7DQorCQkJc3RydWN0IHJh
ZGVvbl9ibyAqb2xkX3JibzsNCisJCQl1bnNpZ25lZCBsb25nIG5zaXplLCBvc2l6ZTsNCisNCisJ
CQlvbGRfcmJvID0gZ2VtX3RvX3JhZGVvbl9ibyh0b19yYWRlb25fZnJhbWVidWZmZXIoZmIpLT5v
YmopOw0KKwkJCW9zaXplID0gcmFkZW9uX2JvX3NpemUob2xkX3Jibyk7DQorCQkJbnNpemUgPSBy
YWRlb25fYm9fc2l6ZShyYm8pOw0KKwkJCWlmIChuc2l6ZSA8PSBvc2l6ZSAmJiAhcmFkZW9uX2Jv
X3Jlc2VydmUob2xkX3JibywgZmFsc2UpKSB7DQorCQkJCXJhZGVvbl9ib191bnBpbihvbGRfcmJv
KTsNCisJCQkJcmFkZW9uX2JvX3VucmVzZXJ2ZShvbGRfcmJvKTsNCisJCQkJZmIgPSBOVUxMOw0K
KwkJCQlnb3RvIHJldHJ5Ow0KKwkJCX0NCisJCX0NCiAJCXJldHVybiAtRUlOVkFMOw0KIAl9DQog
CXJhZGVvbl9ib19nZXRfdGlsaW5nX2ZsYWdzKHJibywgJnRpbGluZ19mbGFncywgTlVMTCk7DQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3R0bS90dG1fYm8uYyBiL2RyaXZlcnMvZ3B1L2Ry
bS90dG0vdHRtX2JvLmMNCmluZGV4IDBkMjdiZmYuLjIyYTg5Y2QgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL2dwdS9kcm0vdHRtL3R0bV9iby5jDQorKysgYi9kcml2ZXJzL2dwdS9kcm0vdHRtL3R0bV9i
by5jDQpAQCAtMTEwMSwyNCArMTEwMSwzMiBAQCBvdXRfdW5sb2NrOg0KIAlyZXR1cm4gcmV0Ow0K
IH0NCiANCi1zdGF0aWMgaW50IHR0bV9ib19tZW1fY29tcGF0KHN0cnVjdCB0dG1fcGxhY2VtZW50
ICpwbGFjZW1lbnQsDQotCQkJICAgICBzdHJ1Y3QgdHRtX21lbV9yZWcgKm1lbSkNCitzdGF0aWMg
Ym9vbCB0dG1fYm9fbWVtX2NvbXBhdChzdHJ1Y3QgdHRtX3BsYWNlbWVudCAqcGxhY2VtZW50LA0K
KwkJCSAgICAgIHN0cnVjdCB0dG1fbWVtX3JlZyAqbWVtLA0KKwkJCSAgICAgIHVpbnQzMl90ICpu
ZXdfZmxhZ3MpDQogew0KIAlpbnQgaTsNCiANCiAJaWYgKG1lbS0+bW1fbm9kZSAmJiBwbGFjZW1l
bnQtPmxwZm4gIT0gMCAmJg0KIAkgICAgKG1lbS0+c3RhcnQgPCBwbGFjZW1lbnQtPmZwZm4gfHwN
CiAJICAgICBtZW0tPnN0YXJ0ICsgbWVtLT5udW1fcGFnZXMgPiBwbGFjZW1lbnQtPmxwZm4pKQ0K
LQkJcmV0dXJuIC0xOw0KKwkJcmV0dXJuIGZhbHNlOw0KIA0KIAlmb3IgKGkgPSAwOyBpIDwgcGxh
Y2VtZW50LT5udW1fcGxhY2VtZW50OyBpKyspIHsNCi0JCWlmICgocGxhY2VtZW50LT5wbGFjZW1l
bnRbaV0gJiBtZW0tPnBsYWNlbWVudCAmDQotCQkJVFRNX1BMX01BU0tfQ0FDSElORykgJiYNCi0J
CQkocGxhY2VtZW50LT5wbGFjZW1lbnRbaV0gJiBtZW0tPnBsYWNlbWVudCAmDQotCQkJVFRNX1BM
X01BU0tfTUVNKSkNCi0JCQlyZXR1cm4gaTsNCisJCSpuZXdfZmxhZ3MgPSBwbGFjZW1lbnQtPnBs
YWNlbWVudFtpXTsNCisJCWlmICgoKm5ld19mbGFncyAmIG1lbS0+cGxhY2VtZW50ICYgVFRNX1BM
X01BU0tfQ0FDSElORykgJiYNCisJCSAgICAoKm5ld19mbGFncyAmIG1lbS0+cGxhY2VtZW50ICYg
VFRNX1BMX01BU0tfTUVNKSkNCisJCQlyZXR1cm4gdHJ1ZTsNCisJfQ0KKw0KKwlmb3IgKGkgPSAw
OyBpIDwgcGxhY2VtZW50LT5udW1fYnVzeV9wbGFjZW1lbnQ7IGkrKykgew0KKwkJKm5ld19mbGFn
cyA9IHBsYWNlbWVudC0+YnVzeV9wbGFjZW1lbnRbaV07DQorCQlpZiAoKCpuZXdfZmxhZ3MgJiBt
ZW0tPnBsYWNlbWVudCAmIFRUTV9QTF9NQVNLX0NBQ0hJTkcpICYmDQorCQkgICAgKCpuZXdfZmxh
Z3MgJiBtZW0tPnBsYWNlbWVudCAmIFRUTV9QTF9NQVNLX01FTSkpDQorCQkJcmV0dXJuIHRydWU7
DQogCX0NCi0JcmV0dXJuIC0xOw0KKw0KKwlyZXR1cm4gZmFsc2U7DQogfQ0KIA0KIGludCB0dG1f
Ym9fdmFsaWRhdGUoc3RydWN0IHR0bV9idWZmZXJfb2JqZWN0ICpibywNCkBAIC0xMTI3LDYgKzEx
MzUsNyBAQCBpbnQgdHRtX2JvX3ZhbGlkYXRlKHN0cnVjdCB0dG1fYnVmZmVyX29iamVjdCAqYm8s
DQogCQkJYm9vbCBub193YWl0X2dwdSkNCiB7DQogCWludCByZXQ7DQorCXVpbnQzMl90IG5ld19m
bGFnczsNCiANCiAJQlVHX09OKCFhdG9taWNfcmVhZCgmYm8tPnJlc2VydmVkKSk7DQogCS8qIENo
ZWNrIHRoYXQgcmFuZ2UgaXMgdmFsaWQgKi8NCkBAIC0xMTM3LDggKzExNDYsNyBAQCBpbnQgdHRt
X2JvX3ZhbGlkYXRlKHN0cnVjdCB0dG1fYnVmZmVyX29iamVjdCAqYm8sDQogCS8qDQogCSAqIENo
ZWNrIHdoZXRoZXIgd2UgbmVlZCB0byBtb3ZlIGJ1ZmZlci4NCiAJICovDQotCXJldCA9IHR0bV9i
b19tZW1fY29tcGF0KHBsYWNlbWVudCwgJmJvLT5tZW0pOw0KLQlpZiAocmV0IDwgMCkgew0KKwlp
ZiAoIXR0bV9ib19tZW1fY29tcGF0KHBsYWNlbWVudCwgJmJvLT5tZW0sICZuZXdfZmxhZ3MpKSB7
DQogCQlyZXQgPSB0dG1fYm9fbW92ZV9idWZmZXIoYm8sIHBsYWNlbWVudCwgaW50ZXJydXB0aWJs
ZSwgbm9fd2FpdF9yZXNlcnZlLCBub193YWl0X2dwdSk7DQogCQlpZiAocmV0KQ0KIAkJCXJldHVy
biByZXQ7DQpAQCAtMTE0Nyw3ICsxMTU1LDcgQEAgaW50IHR0bV9ib192YWxpZGF0ZShzdHJ1Y3Qg
dHRtX2J1ZmZlcl9vYmplY3QgKmJvLA0KIAkJICogVXNlIHRoZSBhY2Nlc3MgYW5kIG90aGVyIG5v
bi1tYXBwaW5nLXJlbGF0ZWQgZmxhZyBiaXRzIGZyb20NCiAJCSAqIHRoZSBjb21wYXRpYmxlIG1l
bW9yeSBwbGFjZW1lbnQgZmxhZ3MgdG8gdGhlIGFjdGl2ZSBmbGFncw0KIAkJICovDQotCQl0dG1f
ZmxhZ19tYXNrZWQoJmJvLT5tZW0ucGxhY2VtZW50LCBwbGFjZW1lbnQtPnBsYWNlbWVudFtyZXRd
LA0KKwkJdHRtX2ZsYWdfbWFza2VkKCZiby0+bWVtLnBsYWNlbWVudCwgbmV3X2ZsYWdzLA0KIAkJ
CQl+VFRNX1BMX01BU0tfTUVNVFlQRSk7DQogCX0NCiAJLyoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2hpZC9oaWQtbXVsdGl0b3VjaC5jIGIvZHJpdmVycy9oaWQvaGlkLW11bHRpdG91Y2guYw0KaW5k
ZXggMTNhZjBmMS4uYTYwNWJhMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaGlkL2hpZC1tdWx0aXRv
dWNoLmMNCisrKyBiL2RyaXZlcnMvaGlkL2hpZC1tdWx0aXRvdWNoLmMNCkBAIC02Niw3ICs2Niw3
IEBAIHN0cnVjdCBtdF9kZXZpY2Ugew0KIAl1bnNpZ25lZCBsYXN0X2ZpZWxkX2luZGV4OwkvKiBs
YXN0IGZpZWxkIGluZGV4IG9mIHRoZSByZXBvcnQgKi8NCiAJdW5zaWduZWQgbGFzdF9zbG90X2Zp
ZWxkOwkvKiB0aGUgbGFzdCBmaWVsZCBvZiBhIHNsb3QgKi8NCiAJaW50IGxhc3RfbXRfY29sbGVj
dGlvbjsJLyogbGFzdCBrbm93biBtdC1yZWxhdGVkIGNvbGxlY3Rpb24gKi8NCi0JX19zOCBpbnB1
dG1vZGU7CQkvKiBJbnB1dE1vZGUgSElEIGZlYXR1cmUsIC0xIGlmIG5vbi1leGlzdGVudCAqLw0K
KwlfX3MxNiBpbnB1dG1vZGU7CS8qIElucHV0TW9kZSBISUQgZmVhdHVyZSwgLTEgaWYgbm9uLWV4
aXN0ZW50ICovDQogCV9fdTggbnVtX3JlY2VpdmVkOwkvKiBob3cgbWFueSBjb250YWN0cyB3ZSBy
ZWNlaXZlZCAqLw0KIAlfX3U4IG51bV9leHBlY3RlZDsJLyogZXhwZWN0ZWQgbGFzdCBjb250YWN0
IGluZGV4ICovDQogCV9fdTggbWF4Y29udGFjdHM7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9od21v
bi9sbTc4LmMgYi9kcml2ZXJzL2h3bW9uL2xtNzguYw0KaW5kZXggNmRmMGI0Ni4uYTQyYTdiMCAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvaHdtb24vbG03OC5jDQorKysgYi9kcml2ZXJzL2h3bW9uL2xt
NzguYw0KQEAgLTkwLDYgKzkwLDggQEAgc3RhdGljIGlubGluZSB1OCBGQU5fVE9fUkVHKGxvbmcg
cnBtLCBpbnQgZGl2KQ0KIHsNCiAJaWYgKHJwbSA8PSAwKQ0KIAkJcmV0dXJuIDI1NTsNCisJaWYg
KHJwbSA+IDEzNTAwMDApDQorCQlyZXR1cm4gMTsNCiAJcmV0dXJuIFNFTlNPUlNfTElNSVQoKDEz
NTAwMDAgKyBycG0gKiBkaXYgLyAyKSAvIChycG0gKiBkaXYpLCAxLCAyNTQpOw0KIH0NCiANCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2h3bW9uL2xtOTAuYyBiL2RyaXZlcnMvaHdtb24vbG05MC5jDQpp
bmRleCA2MTViYzRmLi42ZDVlY2UxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9od21vbi9sbTkwLmMN
CisrKyBiL2RyaXZlcnMvaHdtb24vbG05MC5jDQpAQCAtMjY4LDcgKzI2OCw3IEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgbG05MF9wYXJhbXMgbG05MF9wYXJhbXNbXSA9IHsNCiAJW21heDY2OTZdID0g
ew0KIAkJLmZsYWdzID0gTE05MF9IQVZFX0VNRVJHRU5DWQ0KIAkJICB8IExNOTBfSEFWRV9FTUVS
R0VOQ1lfQUxBUk0gfCBMTTkwX0hBVkVfVEVNUDMsDQotCQkuYWxlcnRfYWxhcm1zID0gMHgxODdj
LA0KKwkJLmFsZXJ0X2FsYXJtcyA9IDB4MWM3YywNCiAJCS5tYXhfY29udnJhdGUgPSA2LA0KIAkJ
LnJlZ19sb2NhbF9leHQgPSBNQVg2NjU3X1JFR19SX0xPQ0FMX1RFTVBMLA0KIAl9LA0KQEAgLTE0
NzQsMTkgKzE0NzQsMjIgQEAgc3RhdGljIHZvaWQgbG05MF9hbGVydChzdHJ1Y3QgaTJjX2NsaWVu
dCAqY2xpZW50LCB1bnNpZ25lZCBpbnQgZmxhZykNCiAJaWYgKChhbGFybXMgJiAweDdmKSA9PSAw
ICYmIChhbGFybXMyICYgMHhmZSkgPT0gMCkgew0KIAkJZGV2X2luZm8oJmNsaWVudC0+ZGV2LCAi
RXZlcnl0aGluZyBPS1xuIik7DQogCX0gZWxzZSB7DQotCQlpZiAoYWxhcm1zICYgMHg2MSkNCisJ
CWlmICgoYWxhcm1zICYgMHg2MSkgfHwgKGFsYXJtczIgJiAweDgwKSkNCiAJCQlkZXZfd2Fybigm
Y2xpZW50LT5kZXYsDQogCQkJCSAidGVtcCVkIG91dCBvZiByYW5nZSwgcGxlYXNlIGNoZWNrIVxu
IiwgMSk7DQotCQlpZiAoYWxhcm1zICYgMHgxYSkNCisJCWlmICgoYWxhcm1zICYgMHgxYSkgfHwg
KGFsYXJtczIgJiAweDIwKSkNCiAJCQlkZXZfd2FybigmY2xpZW50LT5kZXYsDQogCQkJCSAidGVt
cCVkIG91dCBvZiByYW5nZSwgcGxlYXNlIGNoZWNrIVxuIiwgMik7DQogCQlpZiAoYWxhcm1zICYg
MHgwNCkNCiAJCQlkZXZfd2FybigmY2xpZW50LT5kZXYsDQogCQkJCSAidGVtcCVkIGRpb2RlIG9w
ZW4sIHBsZWFzZSBjaGVjayFcbiIsIDIpOw0KIA0KLQkJaWYgKGFsYXJtczIgJiAweDE4KQ0KKwkJ
aWYgKGFsYXJtczIgJiAweDVhKQ0KIAkJCWRldl93YXJuKCZjbGllbnQtPmRldiwNCiAJCQkJICJ0
ZW1wJWQgb3V0IG9mIHJhbmdlLCBwbGVhc2UgY2hlY2shXG4iLCAzKTsNCisJCWlmIChhbGFybXMy
ICYgMHgwNCkNCisJCQlkZXZfd2FybigmY2xpZW50LT5kZXYsDQorCQkJCSAidGVtcCVkIGRpb2Rl
IG9wZW4sIHBsZWFzZSBjaGVjayFcbiIsIDMpOw0KIA0KIAkJLyogRGlzYWJsZSBBTEVSVCMgb3V0
cHV0LCBiZWNhdXNlIHRoZXNlIGNoaXBzIGRvbid0IGltcGxlbWVudA0KIAkJICBTTUJ1cyBhbGVy
dCBjb3JyZWN0bHk7IHRoZXkgc2hvdWxkIG9ubHkgaG9sZCB0aGUgYWxlcnQgbGluZQ0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvaHdtb24vc2lzNTU5NS5jIGIvZHJpdmVycy9od21vbi9zaXM1NTk1LmMN
CmluZGV4IDQ3ZDdjZTkuLjVhYjY5NTMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2h3bW9uL3NpczU1
OTUuYw0KKysrIGIvZHJpdmVycy9od21vbi9zaXM1NTk1LmMNCkBAIC0xMzMsNiArMTMzLDggQEAg
c3RhdGljIGlubGluZSB1OCBGQU5fVE9fUkVHKGxvbmcgcnBtLCBpbnQgZGl2KQ0KIHsNCiAJaWYg
KHJwbSA8PSAwKQ0KIAkJcmV0dXJuIDI1NTsNCisJaWYgKHJwbSA+IDEzNTAwMDApDQorCQlyZXR1
cm4gMTsNCiAJcmV0dXJuIFNFTlNPUlNfTElNSVQoKDEzNTAwMDAgKyBycG0gKiBkaXYgLyAyKSAv
IChycG0gKiBkaXYpLCAxLCAyNTQpOw0KIH0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL2h3bW9u
L3Z0ODIzMS5jIGIvZHJpdmVycy9od21vbi92dDgyMzEuYw0KaW5kZXggZGIzYjJlOC4uNmRmNjdh
OSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaHdtb24vdnQ4MjMxLmMNCisrKyBiL2RyaXZlcnMvaHdt
b24vdnQ4MjMxLmMNCkBAIC0xMzksNyArMTM5LDcgQEAgc3RhdGljIGNvbnN0IHU4IHJlZ3RlbXBt
aW5bXSA9IHsgMHgzYSwgMHgzZSwgMHgyYywgMHgyZSwgMHgzMCwgMHgzMiB9Ow0KICovDQogc3Rh
dGljIGlubGluZSB1OCBGQU5fVE9fUkVHKGxvbmcgcnBtLCBpbnQgZGl2KQ0KIHsNCi0JaWYgKHJw
bSA9PSAwKQ0KKwlpZiAocnBtIDw9IDAgfHwgcnBtID4gMTMxMDcyMCkNCiAJCXJldHVybiAwOw0K
IAlyZXR1cm4gU0VOU09SU19MSU1JVCgxMzEwNzIwIC8gKHJwbSAqIGRpdiksIDEsIDI1NSk7DQog
fQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHdtb24vdzgzbDc4Nm5nLmMgYi9kcml2ZXJzL2h3bW9u
L3c4M2w3ODZuZy5jDQppbmRleCAwMjU0ZTE4Li5iOWMwYTdmIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9od21vbi93ODNsNzg2bmcuYw0KKysrIGIvZHJpdmVycy9od21vbi93ODNsNzg2bmcuYw0KQEAg
LTQ0Nyw4ICs0NDcsMTEgQEAgc3RvcmVfcHdtKHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGRl
dmljZV9hdHRyaWJ1dGUgKmF0dHIsDQogCXN0cnVjdCB3ODNsNzg2bmdfZGF0YSAqZGF0YSA9IGky
Y19nZXRfY2xpZW50ZGF0YShjbGllbnQpOw0KIAl1MzIgdmFsID0gU0VOU09SU19MSU1JVChzaW1w
bGVfc3RydG91bChidWYsIE5VTEwsIDEwKSwgMCwgMjU1KTsNCiANCisJdmFsID0gRElWX1JPVU5E
X0NMT1NFU1QodmFsLCAweDExKTsNCisNCiAJbXV0ZXhfbG9jaygmZGF0YS0+dXBkYXRlX2xvY2sp
Ow0KLQlkYXRhLT5wd21bbnJdID0gdmFsOw0KKwlkYXRhLT5wd21bbnJdID0gdmFsICogMHgxMTsN
CisJdmFsIHw9IHc4M2w3ODZuZ19yZWFkX3ZhbHVlKGNsaWVudCwgVzgzTDc4Nk5HX1JFR19QV01b
bnJdKSAmIDB4ZjA7DQogCXc4M2w3ODZuZ193cml0ZV92YWx1ZShjbGllbnQsIFc4M0w3ODZOR19S
RUdfUFdNW25yXSwgdmFsKTsNCiAJbXV0ZXhfdW5sb2NrKCZkYXRhLT51cGRhdGVfbG9jayk7DQog
CXJldHVybiBjb3VudDsNCkBAIC00NzEsNyArNDc0LDcgQEAgc3RvcmVfcHdtX2VuYWJsZShzdHJ1
Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLA0KIAltdXRleF9s
b2NrKCZkYXRhLT51cGRhdGVfbG9jayk7DQogCXJlZyA9IHc4M2w3ODZuZ19yZWFkX3ZhbHVlKGNs
aWVudCwgVzgzTDc4Nk5HX1JFR19GQU5fQ0ZHKTsNCiAJZGF0YS0+cHdtX2VuYWJsZVtucl0gPSB2
YWw7DQotCXJlZyAmPSB+KDB4MDIgPDwgVzgzTDc4Nk5HX1BXTV9FTkFCTEVfU0hJRlRbbnJdKTsN
CisJcmVnICY9IH4oMHgwMyA8PCBXODNMNzg2TkdfUFdNX0VOQUJMRV9TSElGVFtucl0pOw0KIAly
ZWcgfD0gKHZhbCAtIDEpIDw8IFc4M0w3ODZOR19QV01fRU5BQkxFX1NISUZUW25yXTsNCiAJdzgz
bDc4Nm5nX3dyaXRlX3ZhbHVlKGNsaWVudCwgVzgzTDc4Nk5HX1JFR19GQU5fQ0ZHLCByZWcpOw0K
IAltdXRleF91bmxvY2soJmRhdGEtPnVwZGF0ZV9sb2NrKTsNCkBAIC03NDAsOSArNzQzLDEwIEBA
IHN0YXRpYyBzdHJ1Y3QgdzgzbDc4Nm5nX2RhdGEgKnc4M2w3ODZuZ191cGRhdGVfZGV2aWNlKHN0
cnVjdCBkZXZpY2UgKmRldikNCiAJCQkgICAgKChwd21jZmcgPj4gVzgzTDc4Nk5HX1BXTV9NT0RF
X1NISUZUW2ldKSAmIDEpDQogCQkJICAgID8gMCA6IDE7DQogCQkJZGF0YS0+cHdtX2VuYWJsZVtp
XSA9DQotCQkJICAgICgocHdtY2ZnID4+IFc4M0w3ODZOR19QV01fRU5BQkxFX1NISUZUW2ldKSAm
IDIpICsgMTsNCi0JCQlkYXRhLT5wd21baV0gPSB3ODNsNzg2bmdfcmVhZF92YWx1ZShjbGllbnQs
DQotCQkJICAgIFc4M0w3ODZOR19SRUdfUFdNW2ldKTsNCisJCQkgICAgKChwd21jZmcgPj4gVzgz
TDc4Nk5HX1BXTV9FTkFCTEVfU0hJRlRbaV0pICYgMykgKyAxOw0KKwkJCWRhdGEtPnB3bVtpXSA9
DQorCQkJICAgICh3ODNsNzg2bmdfcmVhZF92YWx1ZShjbGllbnQsIFc4M0w3ODZOR19SRUdfUFdN
W2ldKQ0KKwkJCSAgICAgJiAweDBmKSAqIDB4MTE7DQogCQl9DQogDQogDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9pbmZpbmliYW5kL2h3L2lwYXRoL2lwYXRoX3VzZXJfc2RtYS5jIGIvZHJpdmVycy9p
bmZpbmliYW5kL2h3L2lwYXRoL2lwYXRoX3VzZXJfc2RtYS5jDQppbmRleCBmNWNiMTNiLi5jYzA0
YjdiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2lwYXRoL2lwYXRoX3VzZXJf
c2RtYS5jDQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXBhdGgvaXBhdGhfdXNlcl9zZG1h
LmMNCkBAIC0yODAsOSArMjgwLDcgQEAgc3RhdGljIGludCBpcGF0aF91c2VyX3NkbWFfcGluX3Bh
Z2VzKGNvbnN0IHN0cnVjdCBpcGF0aF9kZXZkYXRhICpkZCwNCiAJaW50IGo7DQogCWludCByZXQ7
DQogDQotCXJldCA9IGdldF91c2VyX3BhZ2VzKGN1cnJlbnQsIGN1cnJlbnQtPm1tLCBhZGRyLA0K
LQkJCSAgICAgbnBhZ2VzLCAwLCAxLCBwYWdlcywgTlVMTCk7DQotDQorCXJldCA9IGdldF91c2Vy
X3BhZ2VzX2Zhc3QoYWRkciwgbnBhZ2VzLCAwLCBwYWdlcyk7DQogCWlmIChyZXQgIT0gbnBhZ2Vz
KSB7DQogCQlpbnQgaTsNCiANCkBAIC04MTEsMTAgKzgwOSw3IEBAIGludCBpcGF0aF91c2VyX3Nk
bWFfd3JpdGV2KHN0cnVjdCBpcGF0aF9kZXZkYXRhICpkZCwNCiAJd2hpbGUgKGRpbSkgew0KIAkJ
Y29uc3QgaW50IG14cCA9IDg7DQogDQotCQlkb3duX3dyaXRlKCZjdXJyZW50LT5tbS0+bW1hcF9z
ZW0pOw0KIAkJcmV0ID0gaXBhdGhfdXNlcl9zZG1hX3F1ZXVlX3BrdHMoZGQsIHBxLCAmbGlzdCwg
aW92LCBkaW0sIG14cCk7DQotCQl1cF93cml0ZSgmY3VycmVudC0+bW0tPm1tYXBfc2VtKTsNCi0N
CiAJCWlmIChyZXQgPD0gMCkNCiAJCQlnb3RvIGRvbmVfdW5sb2NrOw0KIAkJZWxzZSB7DQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L3FpYi9xaWJfdXNlcl9zZG1hLmMgYi9kcml2
ZXJzL2luZmluaWJhbmQvaHcvcWliL3FpYl91c2VyX3NkbWEuYw0KaW5kZXggODI0NDIwOC4uNTcz
YjQ2MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9xaWIvcWliX3VzZXJfc2Rt
YS5jDQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvcWliL3FpYl91c2VyX3NkbWEuYw0KQEAg
LTI4NCw4ICsyODQsNyBAQCBzdGF0aWMgaW50IHFpYl91c2VyX3NkbWFfcGluX3BhZ2VzKGNvbnN0
IHN0cnVjdCBxaWJfZGV2ZGF0YSAqZGQsDQogCWludCBqOw0KIAlpbnQgcmV0Ow0KIA0KLQlyZXQg
PSBnZXRfdXNlcl9wYWdlcyhjdXJyZW50LCBjdXJyZW50LT5tbSwgYWRkciwNCi0JCQkgICAgIG5w
YWdlcywgMCwgMSwgcGFnZXMsIE5VTEwpOw0KKwlyZXQgPSBnZXRfdXNlcl9wYWdlc19mYXN0KGFk
ZHIsIG5wYWdlcywgMCwgcGFnZXMpOw0KIA0KIAlpZiAocmV0ICE9IG5wYWdlcykgew0KIAkJaW50
IGk7DQpAQCAtODMwLDEwICs4MjksNyBAQCBpbnQgcWliX3VzZXJfc2RtYV93cml0ZXYoc3RydWN0
IHFpYl9jdHh0ZGF0YSAqcmNkLA0KIAl3aGlsZSAoZGltKSB7DQogCQljb25zdCBpbnQgbXhwID0g
ODsNCiANCi0JCWRvd25fd3JpdGUoJmN1cnJlbnQtPm1tLT5tbWFwX3NlbSk7DQogCQlyZXQgPSBx
aWJfdXNlcl9zZG1hX3F1ZXVlX3BrdHMoZGQsIHBxLCAmbGlzdCwgaW92LCBkaW0sIG14cCk7DQot
CQl1cF93cml0ZSgmY3VycmVudC0+bW0tPm1tYXBfc2VtKTsNCi0NCiAJCWlmIChyZXQgPD0gMCkN
CiAJCQlnb3RvIGRvbmVfdW5sb2NrOw0KIAkJZWxzZSB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9p
c2RuL2lzZG5sb29wL2lzZG5sb29wLmMgYi9kcml2ZXJzL2lzZG4vaXNkbmxvb3AvaXNkbmxvb3Au
Yw0KaW5kZXggNTA5MTM1Zi4uNGRmODBmYiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaXNkbi9pc2Ru
bG9vcC9pc2RubG9vcC5jDQorKysgYi9kcml2ZXJzL2lzZG4vaXNkbmxvb3AvaXNkbmxvb3AuYw0K
QEAgLTEwODMsOCArMTA4MywxMCBAQCBpc2RubG9vcF9zdGFydChpc2RubG9vcF9jYXJkICogY2Fy
ZCwgaXNkbmxvb3Bfc2RlZiAqIHNkZWZwKQ0KIAkJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZj
YXJkLT5pc2RubG9vcF9sb2NrLCBmbGFncyk7DQogCQkJCXJldHVybiAtRU5PTUVNOw0KIAkJCX0N
Ci0JCQlmb3IgKGkgPSAwOyBpIDwgMzsgaSsrKQ0KLQkJCQlzdHJjcHkoY2FyZC0+czBudW1baV0s
IHNkZWYubnVtW2ldKTsNCisJCQlmb3IgKGkgPSAwOyBpIDwgMzsgaSsrKSB7DQorCQkJCXN0cmxj
cHkoY2FyZC0+czBudW1baV0sIHNkZWYubnVtW2ldLA0KKwkJCQkJc2l6ZW9mKGNhcmQtPnMwbnVt
WzBdKSk7DQorCQkJfQ0KIAkJCWJyZWFrOw0KIAkJY2FzZSBJU0ROX1BUWVBFXzFUUjY6DQogCQkJ
aWYgKGlzZG5sb29wX2Zha2UoY2FyZCwgIkRSVjEuMDRUQy0xVFI2LUNBUEktQ05TLUJBU0lTLTI5
LjExLjk1IiwNCkBAIC0xMDk3LDcgKzEwOTksNyBAQCBpc2RubG9vcF9zdGFydChpc2RubG9vcF9j
YXJkICogY2FyZCwgaXNkbmxvb3Bfc2RlZiAqIHNkZWZwKQ0KIAkJCQlzcGluX3VubG9ja19pcnFy
ZXN0b3JlKCZjYXJkLT5pc2RubG9vcF9sb2NrLCBmbGFncyk7DQogCQkJCXJldHVybiAtRU5PTUVN
Ow0KIAkJCX0NCi0JCQlzdHJjcHkoY2FyZC0+czBudW1bMF0sIHNkZWYubnVtWzBdKTsNCisJCQlz
dHJsY3B5KGNhcmQtPnMwbnVtWzBdLCBzZGVmLm51bVswXSwgc2l6ZW9mKGNhcmQtPnMwbnVtWzBd
KSk7DQogCQkJY2FyZC0+czBudW1bMV1bMF0gPSAnXDAnOw0KIAkJCWNhcmQtPnMwbnVtWzJdWzBd
ID0gJ1wwJzsNCiAJCQlicmVhazsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL2lzZG4vbUlTRE4vc29j
a2V0LmMgYi9kcml2ZXJzL2lzZG4vbUlTRE4vc29ja2V0LmMNCmluZGV4IDczOGVhOGQuLjk4ZTgy
NzQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2lzZG4vbUlTRE4vc29ja2V0LmMNCisrKyBiL2RyaXZl
cnMvaXNkbi9tSVNETi9zb2NrZXQuYw0KQEAgLTExNyw3ICsxMTcsNiBAQCBtSVNETl9zb2NrX3Jl
Y3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIHsNCiAJc3Ry
dWN0IHNrX2J1ZmYJCSpza2I7DQogCXN0cnVjdCBzb2NrCQkqc2sgPSBzb2NrLT5zazsNCi0Jc3Ry
dWN0IHNvY2thZGRyX21JU0ROCSptYWRkcjsNCiANCiAJaW50CQljb3BpZWQsIGVycjsNCiANCkBA
IC0xMzUsOSArMTM0LDkgQEAgbUlTRE5fc29ja19yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwg
c3RydWN0IHNvY2tldCAqc29jaywNCiAJaWYgKCFza2IpDQogCQlyZXR1cm4gZXJyOw0KIA0KLQlp
ZiAobXNnLT5tc2dfbmFtZWxlbiA+PSBzaXplb2Yoc3RydWN0IHNvY2thZGRyX21JU0ROKSkgew0K
LQkJbXNnLT5tc2dfbmFtZWxlbiA9IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfbUlTRE4pOw0KLQkJ
bWFkZHIgPSAoc3RydWN0IHNvY2thZGRyX21JU0ROICopbXNnLT5tc2dfbmFtZTsNCisJaWYgKG1z
Zy0+bXNnX25hbWUpIHsNCisJCXN0cnVjdCBzb2NrYWRkcl9tSVNETiAqbWFkZHIgPSBtc2ctPm1z
Z19uYW1lOw0KKw0KIAkJbWFkZHItPmZhbWlseSA9IEFGX0lTRE47DQogCQltYWRkci0+ZGV2ID0g
X3BtcyhzayktPmRldi0+aWQ7DQogCQlpZiAoKHNrLT5za19wcm90b2NvbCA9PSBJU0ROX1BfTEFQ
RF9URSkgfHwNCkBAIC0xNTAsMTEgKzE0OSw3IEBAIG1JU0ROX3NvY2tfcmVjdm1zZyhzdHJ1Y3Qg
a2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCQkJbWFkZHItPnNhcGkgPSBfcG1z
KHNrKS0+Y2guYWRkciAmIDB4RkY7DQogCQkJbWFkZHItPnRlaSA9ICAoX3BtcyhzayktPmNoLmFk
ZHIgPj4gOCkgJiAweEZGOw0KIAkJfQ0KLQl9IGVsc2Ugew0KLQkJaWYgKG1zZy0+bXNnX25hbWVs
ZW4pDQotCQkJcHJpbnRrKEtFUk5fV0FSTklORyAiJXM6IHRvbyBzbWFsbCBuYW1lbGVuICVkXG4i
LA0KLQkJCSAgICBfX2Z1bmNfXywgbXNnLT5tc2dfbmFtZWxlbik7DQotCQltc2ctPm1zZ19uYW1l
bGVuID0gMDsNCisJCW1zZy0+bXNnX25hbWVsZW4gPSBzaXplb2YoKm1hZGRyKTsNCiAJfQ0KIA0K
IAljb3BpZWQgPSBza2ItPmxlbiArIE1JU0ROX0hFQURFUl9MRU47DQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9tZC9kbS1idWZpby5jIGIvZHJpdmVycy9tZC9kbS1idWZpby5jDQppbmRleCBhNWRmY2Mw
Li45MTBkMmY4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZC9kbS1idWZpby5jDQorKysgYi9kcml2
ZXJzL21kL2RtLWJ1ZmlvLmMNCkBAIC0xNjExLDYgKzE2MTEsMTEgQEAgc3RhdGljIGludCBfX2lu
aXQgZG1fYnVmaW9faW5pdCh2b2lkKQ0KIHsNCiAJX191NjQgbWVtOw0KIA0KKwlkbV9idWZpb19h
bGxvY2F0ZWRfa21lbV9jYWNoZSA9IDA7DQorCWRtX2J1ZmlvX2FsbG9jYXRlZF9nZXRfZnJlZV9w
YWdlcyA9IDA7DQorCWRtX2J1ZmlvX2FsbG9jYXRlZF92bWFsbG9jID0gMDsNCisJZG1fYnVmaW9f
Y3VycmVudF9hbGxvY2F0ZWQgPSAwOw0KKw0KIAltZW1zZXQoJmRtX2J1ZmlvX2NhY2hlcywgMCwg
c2l6ZW9mIGRtX2J1ZmlvX2NhY2hlcyk7DQogCW1lbXNldCgmZG1fYnVmaW9fY2FjaGVfbmFtZXMs
IDAsIHNpemVvZiBkbV9idWZpb19jYWNoZV9uYW1lcyk7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9tZC9kbS1kZWxheS5jIGIvZHJpdmVycy9tZC9kbS1kZWxheS5jDQppbmRleCAxMTQzMWFjLi4z
ZjEyM2YxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tZC9kbS1kZWxheS5jDQorKysgYi9kcml2ZXJz
L21kL2RtLWRlbGF5LmMNCkBAIC0yMCw2ICsyMCw3IEBADQogc3RydWN0IGRlbGF5X2Mgew0KIAlz
dHJ1Y3QgdGltZXJfbGlzdCBkZWxheV90aW1lcjsNCiAJc3RydWN0IG11dGV4IHRpbWVyX2xvY2s7
DQorCXN0cnVjdCB3b3JrcXVldWVfc3RydWN0ICprZGVsYXlkX3dxOw0KIAlzdHJ1Y3Qgd29ya19z
dHJ1Y3QgZmx1c2hfZXhwaXJlZF9iaW9zOw0KIAlzdHJ1Y3QgbGlzdF9oZWFkIGRlbGF5ZWRfYmlv
czsNCiAJYXRvbWljX3QgbWF5X2RlbGF5Ow0KQEAgLTQ1LDE0ICs0NiwxMyBAQCBzdHJ1Y3QgZG1f
ZGVsYXlfaW5mbyB7DQogDQogc3RhdGljIERFRklORV9NVVRFWChkZWxheWVkX2Jpb3NfbG9jayk7
DQogDQotc3RhdGljIHN0cnVjdCB3b3JrcXVldWVfc3RydWN0ICprZGVsYXlkX3dxOw0KIHN0YXRp
YyBzdHJ1Y3Qga21lbV9jYWNoZSAqZGVsYXllZF9jYWNoZTsNCiANCiBzdGF0aWMgdm9pZCBoYW5k
bGVfZGVsYXllZF90aW1lcih1bnNpZ25lZCBsb25nIGRhdGEpDQogew0KIAlzdHJ1Y3QgZGVsYXlf
YyAqZGMgPSAoc3RydWN0IGRlbGF5X2MgKilkYXRhOw0KIA0KLQlxdWV1ZV93b3JrKGtkZWxheWRf
d3EsICZkYy0+Zmx1c2hfZXhwaXJlZF9iaW9zKTsNCisJcXVldWVfd29yayhkYy0+a2RlbGF5ZF93
cSwgJmRjLT5mbHVzaF9leHBpcmVkX2Jpb3MpOw0KIH0NCiANCiBzdGF0aWMgdm9pZCBxdWV1ZV90
aW1lb3V0KHN0cnVjdCBkZWxheV9jICpkYywgdW5zaWduZWQgbG9uZyBleHBpcmVzKQ0KQEAgLTE5
MCw2ICsxOTAsMTIgQEAgb3V0Og0KIAkJZ290byBiYWRfZGV2X3dyaXRlOw0KIAl9DQogDQorCWRj
LT5rZGVsYXlkX3dxID0gYWxsb2Nfd29ya3F1ZXVlKCJrZGVsYXlkIiwgV1FfTUVNX1JFQ0xBSU0s
IDApOw0KKwlpZiAoIWRjLT5rZGVsYXlkX3dxKSB7DQorCQlETUVSUigiQ291bGRuJ3Qgc3RhcnQg
a2RlbGF5ZCIpOw0KKwkJZ290byBiYWRfcXVldWU7DQorCX0NCisNCiAJc2V0dXBfdGltZXIoJmRj
LT5kZWxheV90aW1lciwgaGFuZGxlX2RlbGF5ZWRfdGltZXIsICh1bnNpZ25lZCBsb25nKWRjKTsN
CiANCiAJSU5JVF9XT1JLKCZkYy0+Zmx1c2hfZXhwaXJlZF9iaW9zLCBmbHVzaF9leHBpcmVkX2Jp
b3MpOw0KQEAgLTIwMiw2ICsyMDgsOCBAQCBvdXQ6DQogCXRpLT5wcml2YXRlID0gZGM7DQogCXJl
dHVybiAwOw0KIA0KK2JhZF9xdWV1ZToNCisJbWVtcG9vbF9kZXN0cm95KGRjLT5kZWxheWVkX3Bv
b2wpOw0KIGJhZF9kZXZfd3JpdGU6DQogCWlmIChkYy0+ZGV2X3dyaXRlKQ0KIAkJZG1fcHV0X2Rl
dmljZSh0aSwgZGMtPmRldl93cml0ZSk7DQpAQCAtMjE2LDcgKzIyNCw3IEBAIHN0YXRpYyB2b2lk
IGRlbGF5X2R0cihzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSkNCiB7DQogCXN0cnVjdCBkZWxheV9jICpk
YyA9IHRpLT5wcml2YXRlOw0KIA0KLQlmbHVzaF93b3JrcXVldWUoa2RlbGF5ZF93cSk7DQorCWRl
c3Ryb3lfd29ya3F1ZXVlKGRjLT5rZGVsYXlkX3dxKTsNCiANCiAJZG1fcHV0X2RldmljZSh0aSwg
ZGMtPmRldl9yZWFkKTsNCiANCkBAIC0zNTAsMTIgKzM1OCw2IEBAIHN0YXRpYyBpbnQgX19pbml0
IGRtX2RlbGF5X2luaXQodm9pZCkNCiB7DQogCWludCByID0gLUVOT01FTTsNCiANCi0Ja2RlbGF5
ZF93cSA9IGFsbG9jX3dvcmtxdWV1ZSgia2RlbGF5ZCIsIFdRX01FTV9SRUNMQUlNLCAwKTsNCi0J
aWYgKCFrZGVsYXlkX3dxKSB7DQotCQlETUVSUigiQ291bGRuJ3Qgc3RhcnQga2RlbGF5ZCIpOw0K
LQkJZ290byBiYWRfcXVldWU7DQotCX0NCi0NCiAJZGVsYXllZF9jYWNoZSA9IEtNRU1fQ0FDSEUo
ZG1fZGVsYXlfaW5mbywgMCk7DQogCWlmICghZGVsYXllZF9jYWNoZSkgew0KIAkJRE1FUlIoIkNv
dWxkbid0IGNyZWF0ZSBkZWxheWVkIGJpbyBjYWNoZS4iKTsNCkBAIC0zNzMsOCArMzc1LDYgQEAg
c3RhdGljIGludCBfX2luaXQgZG1fZGVsYXlfaW5pdCh2b2lkKQ0KIGJhZF9yZWdpc3RlcjoNCiAJ
a21lbV9jYWNoZV9kZXN0cm95KGRlbGF5ZWRfY2FjaGUpOw0KIGJhZF9tZW1jYWNoZToNCi0JZGVz
dHJveV93b3JrcXVldWUoa2RlbGF5ZF93cSk7DQotYmFkX3F1ZXVlOg0KIAlyZXR1cm4gcjsNCiB9
DQogDQpAQCAtMzgyLDcgKzM4Miw2IEBAIHN0YXRpYyB2b2lkIF9fZXhpdCBkbV9kZWxheV9leGl0
KHZvaWQpDQogew0KIAlkbV91bnJlZ2lzdGVyX3RhcmdldCgmZGVsYXlfdGFyZ2V0KTsNCiAJa21l
bV9jYWNoZV9kZXN0cm95KGRlbGF5ZWRfY2FjaGUpOw0KLQlkZXN0cm95X3dvcmtxdWV1ZShrZGVs
YXlkX3dxKTsNCiB9DQogDQogLyogTW9kdWxlIGhvb2tzICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9tZC9kbS1tcGF0aC5jIGIvZHJpdmVycy9tZC9kbS1tcGF0aC5jDQppbmRleCA3ZTc2NmY5Mi4u
ODRhZDUzMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbWQvZG0tbXBhdGguYw0KKysrIGIvZHJpdmVy
cy9tZC9kbS1tcGF0aC5jDQpAQCAtODQsNiArODQsNyBAQCBzdHJ1Y3QgbXVsdGlwYXRoIHsNCiAJ
dW5zaWduZWQgcXVldWVfaW87CQkvKiBNdXN0IHdlIHF1ZXVlIGFsbCBJL08/ICovDQogCXVuc2ln
bmVkIHF1ZXVlX2lmX25vX3BhdGg7CS8qIFF1ZXVlIEkvTyBpZiBsYXN0IHBhdGggZmFpbHM/ICov
DQogCXVuc2lnbmVkIHNhdmVkX3F1ZXVlX2lmX25vX3BhdGg7LyogU2F2ZWQgc3RhdGUgZHVyaW5n
IHN1c3BlbnNpb24gKi8NCisJdW5zaWduZWQgcGdfaW5pdF9kaXNhYmxlZDoxOwkvKiBwZ19pbml0
IGlzIG5vdCBjdXJyZW50bHkgYWxsb3dlZCAqLw0KIAl1bnNpZ25lZCBwZ19pbml0X3JldHJpZXM7
CS8qIE51bWJlciBvZiB0aW1lcyB0byByZXRyeSBwZ19pbml0ICovDQogCXVuc2lnbmVkIHBnX2lu
aXRfY291bnQ7CQkvKiBOdW1iZXIgb2YgdGltZXMgcGdfaW5pdCBjYWxsZWQgKi8NCiAJdW5zaWdu
ZWQgcGdfaW5pdF9kZWxheV9tc2VjczsJLyogTnVtYmVyIG9mIG1zZWNzIGJlZm9yZSBwZ19pbml0
IHJldHJ5ICovDQpAQCAtNDczLDcgKzQ3NCw4IEBAIHN0YXRpYyB2b2lkIHByb2Nlc3NfcXVldWVk
X2lvcyhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQogCSAgICAoIXBncGF0aCAmJiAhbS0+cXVl
dWVfaWZfbm9fcGF0aCkpDQogCQltdXN0X3F1ZXVlID0gMDsNCiANCi0JaWYgKG0tPnBnX2luaXRf
cmVxdWlyZWQgJiYgIW0tPnBnX2luaXRfaW5fcHJvZ3Jlc3MgJiYgcGdwYXRoKQ0KKwlpZiAobS0+
cGdfaW5pdF9yZXF1aXJlZCAmJiAhbS0+cGdfaW5pdF9pbl9wcm9ncmVzcyAmJiBwZ3BhdGggJiYN
CisJICAgICFtLT5wZ19pbml0X2Rpc2FibGVkKQ0KIAkJX19wZ19pbml0X2FsbF9wYXRocyhtKTsN
CiANCiBvdXQ6DQpAQCAtODg3LDEwICs4ODksMjAgQEAgc3RhdGljIHZvaWQgbXVsdGlwYXRoX3dh
aXRfZm9yX3BnX2luaXRfY29tcGxldGlvbihzdHJ1Y3QgbXVsdGlwYXRoICptKQ0KIA0KIHN0YXRp
YyB2b2lkIGZsdXNoX211bHRpcGF0aF93b3JrKHN0cnVjdCBtdWx0aXBhdGggKm0pDQogew0KKwl1
bnNpZ25lZCBsb25nIGZsYWdzOw0KKw0KKwlzcGluX2xvY2tfaXJxc2F2ZSgmbS0+bG9jaywgZmxh
Z3MpOw0KKwltLT5wZ19pbml0X2Rpc2FibGVkID0gMTsNCisJc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZSgmbS0+bG9jaywgZmxhZ3MpOw0KKw0KIAlmbHVzaF93b3JrcXVldWUoa21wYXRoX2hhbmRsZXJk
KTsNCiAJbXVsdGlwYXRoX3dhaXRfZm9yX3BnX2luaXRfY29tcGxldGlvbihtKTsNCiAJZmx1c2hf
d29ya3F1ZXVlKGttdWx0aXBhdGhkKTsNCiAJZmx1c2hfd29ya19zeW5jKCZtLT50cmlnZ2VyX2V2
ZW50KTsNCisNCisJc3Bpbl9sb2NrX2lycXNhdmUoJm0tPmxvY2ssIGZsYWdzKTsNCisJbS0+cGdf
aW5pdF9kaXNhYmxlZCA9IDA7DQorCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm0tPmxvY2ssIGZs
YWdzKTsNCiB9DQogDQogc3RhdGljIHZvaWQgbXVsdGlwYXRoX2R0cihzdHJ1Y3QgZG1fdGFyZ2V0
ICp0aSkNCkBAIC0xMTExLDcgKzExMjMsNyBAQCBzdGF0aWMgaW50IHBnX2luaXRfbGltaXRfcmVh
Y2hlZChzdHJ1Y3QgbXVsdGlwYXRoICptLCBzdHJ1Y3QgcGdwYXRoICpwZ3BhdGgpDQogDQogCXNw
aW5fbG9ja19pcnFzYXZlKCZtLT5sb2NrLCBmbGFncyk7DQogDQotCWlmIChtLT5wZ19pbml0X2Nv
dW50IDw9IG0tPnBnX2luaXRfcmV0cmllcykNCisJaWYgKG0tPnBnX2luaXRfY291bnQgPD0gbS0+
cGdfaW5pdF9yZXRyaWVzICYmICFtLT5wZ19pbml0X2Rpc2FibGVkKQ0KIAkJbS0+cGdfaW5pdF9y
ZXF1aXJlZCA9IDE7DQogCWVsc2UNCiAJCWxpbWl0X3JlYWNoZWQgPSAxOw0KQEAgLTE2MjEsNyAr
MTYzMyw3IEBAIG91dDoNCiAgKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovDQogc3RhdGljIHN0cnVjdCB0YXJnZXRfdHlwZSBt
dWx0aXBhdGhfdGFyZ2V0ID0gew0KIAkubmFtZSA9ICJtdWx0aXBhdGgiLA0KLQkudmVyc2lvbiA9
IHsxLCAzLCAxfSwNCisJLnZlcnNpb24gPSB7MSwgMywgMn0sDQogCS5tb2R1bGUgPSBUSElTX01P
RFVMRSwNCiAJLmN0ciA9IG11bHRpcGF0aF9jdHIsDQogCS5kdHIgPSBtdWx0aXBhdGhfZHRyLA0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0tc25hcC5jIGIvZHJpdmVycy9tZC9kbS1zbmFwLmMN
CmluZGV4IDVjMzAzMTYuLmZlYzc5ZTcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21kL2RtLXNuYXAu
Yw0KKysrIGIvZHJpdmVycy9tZC9kbS1zbmFwLmMNCkBAIC02Niw2ICs2NiwxOCBAQCBzdHJ1Y3Qg
ZG1fc25hcHNob3Qgew0KIA0KIAlhdG9taWNfdCBwZW5kaW5nX2V4Y2VwdGlvbnNfY291bnQ7DQog
DQorCS8qIFByb3RlY3RlZCBieSAibG9jayIgKi8NCisJc2VjdG9yX3QgZXhjZXB0aW9uX3N0YXJ0
X3NlcXVlbmNlOw0KKw0KKwkvKiBQcm90ZWN0ZWQgYnkga2NvcHlkIHNpbmdsZS10aHJlYWRlZCBj
YWxsYmFjayAqLw0KKwlzZWN0b3JfdCBleGNlcHRpb25fY29tcGxldGVfc2VxdWVuY2U7DQorDQor
CS8qDQorCSAqIEEgbGlzdCBvZiBwZW5kaW5nIGV4Y2VwdGlvbnMgdGhhdCBjb21wbGV0ZWQgb3V0
IG9mIG9yZGVyLg0KKwkgKiBQcm90ZWN0ZWQgYnkga2NvcHlkIHNpbmdsZS10aHJlYWRlZCBjYWxs
YmFjay4NCisJICovDQorCXN0cnVjdCBsaXN0X2hlYWQgb3V0X29mX29yZGVyX2xpc3Q7DQorDQog
CW1lbXBvb2xfdCAqcGVuZGluZ19wb29sOw0KIA0KIAlzdHJ1Y3QgZG1fZXhjZXB0aW9uX3RhYmxl
IHBlbmRpbmc7DQpAQCAtMTcxLDYgKzE4MywxNCBAQCBzdHJ1Y3QgZG1fc25hcF9wZW5kaW5nX2V4
Y2VwdGlvbiB7DQogCSAqLw0KIAlpbnQgc3RhcnRlZDsNCiANCisJLyogVGhlcmUgd2FzIGNvcHlp
bmcgZXJyb3IuICovDQorCWludCBjb3B5X2Vycm9yOw0KKw0KKwkvKiBBIHNlcXVlbmNlIG51bWJl
ciwgaXQgaXMgdXNlZCBmb3IgaW4tb3JkZXIgY29tcGxldGlvbi4gKi8NCisJc2VjdG9yX3QgZXhj
ZXB0aW9uX3NlcXVlbmNlOw0KKw0KKwlzdHJ1Y3QgbGlzdF9oZWFkIG91dF9vZl9vcmRlcl9lbnRy
eTsNCisNCiAJLyoNCiAJICogRm9yIHdyaXRpbmcgYSBjb21wbGV0ZSBjaHVuaywgYnlwYXNzaW5n
IHRoZSBjb3B5Lg0KIAkgKi8NCkBAIC0xMDkwLDYgKzExMTAsOSBAQCBzdGF0aWMgaW50IHNuYXBz
aG90X2N0cihzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgdW5zaWduZWQgaW50IGFyZ2MsIGNoYXIgKiph
cmd2KQ0KIAlzLT52YWxpZCA9IDE7DQogCXMtPmFjdGl2ZSA9IDA7DQogCWF0b21pY19zZXQoJnMt
PnBlbmRpbmdfZXhjZXB0aW9uc19jb3VudCwgMCk7DQorCXMtPmV4Y2VwdGlvbl9zdGFydF9zZXF1
ZW5jZSA9IDA7DQorCXMtPmV4Y2VwdGlvbl9jb21wbGV0ZV9zZXF1ZW5jZSA9IDA7DQorCUlOSVRf
TElTVF9IRUFEKCZzLT5vdXRfb2Zfb3JkZXJfbGlzdCk7DQogCWluaXRfcndzZW0oJnMtPmxvY2sp
Ow0KIAlJTklUX0xJU1RfSEVBRCgmcy0+bGlzdCk7DQogCXNwaW5fbG9ja19pbml0KCZzLT5wZV9s
b2NrKTsNCkBAIC0xNDQ4LDYgKzE0NzEsMTkgQEAgc3RhdGljIHZvaWQgY29tbWl0X2NhbGxiYWNr
KHZvaWQgKmNvbnRleHQsIGludCBzdWNjZXNzKQ0KIAlwZW5kaW5nX2NvbXBsZXRlKHBlLCBzdWNj
ZXNzKTsNCiB9DQogDQorc3RhdGljIHZvaWQgY29tcGxldGVfZXhjZXB0aW9uKHN0cnVjdCBkbV9z
bmFwX3BlbmRpbmdfZXhjZXB0aW9uICpwZSkNCit7DQorCXN0cnVjdCBkbV9zbmFwc2hvdCAqcyA9
IHBlLT5zbmFwOw0KKw0KKwlpZiAodW5saWtlbHkocGUtPmNvcHlfZXJyb3IpKQ0KKwkJcGVuZGlu
Z19jb21wbGV0ZShwZSwgMCk7DQorDQorCWVsc2UNCisJCS8qIFVwZGF0ZSB0aGUgbWV0YWRhdGEg
aWYgd2UgYXJlIHBlcnNpc3RlbnQgKi8NCisJCXMtPnN0b3JlLT50eXBlLT5jb21taXRfZXhjZXB0
aW9uKHMtPnN0b3JlLCAmcGUtPmUsDQorCQkJCQkJIGNvbW1pdF9jYWxsYmFjaywgcGUpOw0KK30N
CisNCiAvKg0KICAqIENhbGxlZCB3aGVuIHRoZSBjb3B5IEkvTyBoYXMgZmluaXNoZWQuICBrY29w
eWQgYWN0dWFsbHkgcnVucw0KICAqIHRoaXMgY29kZSBzbyBkb24ndCBibG9jay4NCkBAIC0xNDU3
LDEzICsxNDkzLDMyIEBAIHN0YXRpYyB2b2lkIGNvcHlfY2FsbGJhY2soaW50IHJlYWRfZXJyLCB1
bnNpZ25lZCBsb25nIHdyaXRlX2Vyciwgdm9pZCAqY29udGV4dCkNCiAJc3RydWN0IGRtX3NuYXBf
cGVuZGluZ19leGNlcHRpb24gKnBlID0gY29udGV4dDsNCiAJc3RydWN0IGRtX3NuYXBzaG90ICpz
ID0gcGUtPnNuYXA7DQogDQotCWlmIChyZWFkX2VyciB8fCB3cml0ZV9lcnIpDQotCQlwZW5kaW5n
X2NvbXBsZXRlKHBlLCAwKTsNCisJcGUtPmNvcHlfZXJyb3IgPSByZWFkX2VyciB8fCB3cml0ZV9l
cnI7DQogDQotCWVsc2UNCi0JCS8qIFVwZGF0ZSB0aGUgbWV0YWRhdGEgaWYgd2UgYXJlIHBlcnNp
c3RlbnQgKi8NCi0JCXMtPnN0b3JlLT50eXBlLT5jb21taXRfZXhjZXB0aW9uKHMtPnN0b3JlLCAm
cGUtPmUsDQotCQkJCQkJIGNvbW1pdF9jYWxsYmFjaywgcGUpOw0KKwlpZiAocGUtPmV4Y2VwdGlv
bl9zZXF1ZW5jZSA9PSBzLT5leGNlcHRpb25fY29tcGxldGVfc2VxdWVuY2UpIHsNCisJCXMtPmV4
Y2VwdGlvbl9jb21wbGV0ZV9zZXF1ZW5jZSsrOw0KKwkJY29tcGxldGVfZXhjZXB0aW9uKHBlKTsN
CisNCisJCXdoaWxlICghbGlzdF9lbXB0eSgmcy0+b3V0X29mX29yZGVyX2xpc3QpKSB7DQorCQkJ
cGUgPSBsaXN0X2VudHJ5KHMtPm91dF9vZl9vcmRlcl9saXN0Lm5leHQsDQorCQkJCQlzdHJ1Y3Qg
ZG1fc25hcF9wZW5kaW5nX2V4Y2VwdGlvbiwgb3V0X29mX29yZGVyX2VudHJ5KTsNCisJCQlpZiAo
cGUtPmV4Y2VwdGlvbl9zZXF1ZW5jZSAhPSBzLT5leGNlcHRpb25fY29tcGxldGVfc2VxdWVuY2Up
DQorCQkJCWJyZWFrOw0KKwkJCXMtPmV4Y2VwdGlvbl9jb21wbGV0ZV9zZXF1ZW5jZSsrOw0KKwkJ
CWxpc3RfZGVsKCZwZS0+b3V0X29mX29yZGVyX2VudHJ5KTsNCisJCQljb21wbGV0ZV9leGNlcHRp
b24ocGUpOw0KKwkJfQ0KKwl9IGVsc2Ugew0KKwkJc3RydWN0IGxpc3RfaGVhZCAqbGg7DQorCQlz
dHJ1Y3QgZG1fc25hcF9wZW5kaW5nX2V4Y2VwdGlvbiAqcGUyOw0KKw0KKwkJbGlzdF9mb3JfZWFj
aF9wcmV2KGxoLCAmcy0+b3V0X29mX29yZGVyX2xpc3QpIHsNCisJCQlwZTIgPSBsaXN0X2VudHJ5
KGxoLCBzdHJ1Y3QgZG1fc25hcF9wZW5kaW5nX2V4Y2VwdGlvbiwgb3V0X29mX29yZGVyX2VudHJ5
KTsNCisJCQlpZiAocGUyLT5leGNlcHRpb25fc2VxdWVuY2UgPCBwZS0+ZXhjZXB0aW9uX3NlcXVl
bmNlKQ0KKwkJCQlicmVhazsNCisJCX0NCisJCWxpc3RfYWRkKCZwZS0+b3V0X29mX29yZGVyX2Vu
dHJ5LCBsaCk7DQorCX0NCiB9DQogDQogLyoNCkBAIC0xNTU4LDYgKzE2MTMsOCBAQCBfX2ZpbmRf
cGVuZGluZ19leGNlcHRpb24oc3RydWN0IGRtX3NuYXBzaG90ICpzLA0KIAkJcmV0dXJuIE5VTEw7
DQogCX0NCiANCisJcGUtPmV4Y2VwdGlvbl9zZXF1ZW5jZSA9IHMtPmV4Y2VwdGlvbl9zdGFydF9z
ZXF1ZW5jZSsrOw0KKw0KIAlkbV9pbnNlcnRfZXhjZXB0aW9uKCZzLT5wZW5kaW5nLCAmcGUtPmUp
Ow0KIA0KIAlyZXR1cm4gcGU7DQpAQCAtMjIwMCw3ICsyMjU3LDcgQEAgc3RhdGljIHN0cnVjdCB0
YXJnZXRfdHlwZSBvcmlnaW5fdGFyZ2V0ID0gew0KIA0KIHN0YXRpYyBzdHJ1Y3QgdGFyZ2V0X3R5
cGUgc25hcHNob3RfdGFyZ2V0ID0gew0KIAkubmFtZSAgICA9ICJzbmFwc2hvdCIsDQotCS52ZXJz
aW9uID0gezEsIDEwLCAxfSwNCisJLnZlcnNpb24gPSB7MSwgMTAsIDJ9LA0KIAkubW9kdWxlICA9
IFRISVNfTU9EVUxFLA0KIAkuY3RyICAgICA9IHNuYXBzaG90X2N0ciwNCiAJLmR0ciAgICAgPSBz
bmFwc2hvdF9kdHIsDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS10YWJsZS5jIGIvZHJpdmVy
cy9tZC9kbS10YWJsZS5jDQppbmRleCA1Mjg0OGFiLi41YzUyNTgyIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9tZC9kbS10YWJsZS5jDQorKysgYi9kcml2ZXJzL21kL2RtLXRhYmxlLmMNCkBAIC0yMTUs
NiArMjE1LDExIEBAIGludCBkbV90YWJsZV9jcmVhdGUoc3RydWN0IGRtX3RhYmxlICoqcmVzdWx0
LCBmbW9kZV90IG1vZGUsDQogDQogCW51bV90YXJnZXRzID0gZG1fcm91bmRfdXAobnVtX3Rhcmdl
dHMsIEtFWVNfUEVSX05PREUpOw0KIA0KKwlpZiAoIW51bV90YXJnZXRzKSB7DQorCQlrZnJlZSh0
KTsNCisJCXJldHVybiAtRU5PTUVNOw0KKwl9DQorDQogCWlmIChhbGxvY190YXJnZXRzKHQsIG51
bV90YXJnZXRzKSkgew0KIAkJa2ZyZWUodCk7DQogCQl0ID0gTlVMTDsNCkBAIC01ODEsMTQgKzU4
NiwyOCBAQCBzdGF0aWMgaW50IGFkam9pbihzdHJ1Y3QgZG1fdGFibGUgKnRhYmxlLCBzdHJ1Y3Qg
ZG1fdGFyZ2V0ICp0aSkNCiANCiAvKg0KICAqIFVzZWQgdG8gZHluYW1pY2FsbHkgYWxsb2NhdGUg
dGhlIGFyZyBhcnJheS4NCisgKg0KKyAqIFdlIGRvIGZpcnN0IGFsbG9jYXRpb24gd2l0aCBHRlBf
Tk9JTyBiZWNhdXNlIGRtLW1wYXRoIGFuZCBkbS10aGluIG11c3QNCisgKiBwcm9jZXNzIG1lc3Nh
Z2VzIGV2ZW4gaWYgc29tZSBkZXZpY2UgaXMgc3VzcGVuZGVkLiBUaGVzZSBtZXNzYWdlcyBoYXZl
IGENCisgKiBzbWFsbCBmaXhlZCBudW1iZXIgb2YgYXJndW1lbnRzLg0KKyAqDQorICogT24gdGhl
IG90aGVyIGhhbmQsIGRtLXN3aXRjaCBuZWVkcyB0byBwcm9jZXNzIGJ1bGsgZGF0YSB1c2luZyBt
ZXNzYWdlcyBhbmQNCisgKiBleGNlc3NpdmUgdXNlIG9mIEdGUF9OT0lPIGNvdWxkIGNhdXNlIHRy
b3VibGUuDQogICovDQogc3RhdGljIGNoYXIgKipyZWFsbG9jX2FyZ3YodW5zaWduZWQgKmFycmF5
X3NpemUsIGNoYXIgKipvbGRfYXJndikNCiB7DQogCWNoYXIgKiphcmd2Ow0KIAl1bnNpZ25lZCBu
ZXdfc2l6ZTsNCisJZ2ZwX3QgZ2ZwOw0KIA0KLQluZXdfc2l6ZSA9ICphcnJheV9zaXplID8gKmFy
cmF5X3NpemUgKiAyIDogNjQ7DQotCWFyZ3YgPSBrbWFsbG9jKG5ld19zaXplICogc2l6ZW9mKCph
cmd2KSwgR0ZQX0tFUk5FTCk7DQorCWlmICgqYXJyYXlfc2l6ZSkgew0KKwkJbmV3X3NpemUgPSAq
YXJyYXlfc2l6ZSAqIDI7DQorCQlnZnAgPSBHRlBfS0VSTkVMOw0KKwl9IGVsc2Ugew0KKwkJbmV3
X3NpemUgPSA4Ow0KKwkJZ2ZwID0gR0ZQX05PSU87DQorCX0NCisJYXJndiA9IGttYWxsb2MobmV3
X3NpemUgKiBzaXplb2YoKmFyZ3YpLCBnZnApOw0KIAlpZiAoYXJndikgew0KIAkJbWVtY3B5KGFy
Z3YsIG9sZF9hcmd2LCAqYXJyYXlfc2l6ZSAqIHNpemVvZigqYXJndikpOw0KIAkJKmFycmF5X3Np
emUgPSBuZXdfc2l6ZTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxNjQv
c2FhNzE2NC1jb3JlLmMgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcxNjQvc2FhNzE2NC1jb3Jl
LmMNCmluZGV4IDNiN2Q3YjQuLjhmM2M0N2UgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21lZGlhL3Zp
ZGVvL3NhYTcxNjQvc2FhNzE2NC1jb3JlLmMNCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vc2Fh
NzE2NC9zYWE3MTY0LWNvcmUuYw0KQEAgLTEzODYsOSArMTM4NiwxMSBAQCBzdGF0aWMgaW50IF9f
ZGV2aW5pdCBzYWE3MTY0X2luaXRkZXYoc3RydWN0IHBjaV9kZXYgKnBjaV9kZXYsDQogCQlpZiAo
ZndfZGVidWcpIHsNCiAJCQlkZXYtPmt0aHJlYWQgPSBrdGhyZWFkX3J1bihzYWE3MTY0X3RocmVh
ZF9mdW5jdGlvbiwgZGV2LA0KIAkJCQkic2FhNzE2NCBkZWJ1ZyIpOw0KLQkJCWlmICghZGV2LT5r
dGhyZWFkKQ0KKwkJCWlmIChJU19FUlIoZGV2LT5rdGhyZWFkKSkgew0KKwkJCQlkZXYtPmt0aHJl
YWQgPSBOVUxMOw0KIAkJCQlwcmludGsoS0VSTl9FUlIgIiVzKCkgRmFpbGVkIHRvIGNyZWF0ZSAi
DQogCQkJCQkiZGVidWcga2VybmVsIHRocmVhZFxuIiwgX19mdW5jX18pOw0KKwkJCX0NCiAJCX0N
CiANCiAJfSAvKiAhPSBCT0FSRF9VTktOT1dOICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9taXNj
L2VuY2xvc3VyZS5jIGIvZHJpdmVycy9taXNjL2VuY2xvc3VyZS5jDQppbmRleCAwMGU1ZmNhYzgu
LmNiZWU4NDIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21pc2MvZW5jbG9zdXJlLmMNCisrKyBiL2Ry
aXZlcnMvbWlzYy9lbmNsb3N1cmUuYw0KQEAgLTE5OCw2ICsxOTgsMTMgQEAgc3RhdGljIHZvaWQg
ZW5jbG9zdXJlX3JlbW92ZV9saW5rcyhzdHJ1Y3QgZW5jbG9zdXJlX2NvbXBvbmVudCAqY2RldikN
CiB7DQogCWNoYXIgbmFtZVtFTkNMT1NVUkVfTkFNRV9TSVpFXTsNCiANCisJLyoNCisJICogSW4g
b2RkIGNpcmN1bXN0YW5jZXMsIGxpa2UgbXVsdGlwYXRoIGRldmljZXMsIHNvbWV0aGluZyBlbHNl
IG1heQ0KKwkgKiBhbHJlYWR5IGhhdmUgcmVtb3ZlZCB0aGUgbGlua3MsIHNvIGNoZWNrIGZvciB0
aGlzIGNvbmRpdGlvbiBmaXJzdC4NCisJICovDQorCWlmICghY2Rldi0+ZGV2LT5rb2JqLnNkKQ0K
KwkJcmV0dXJuOw0KKw0KIAllbmNsb3N1cmVfbGlua19uYW1lKGNkZXYsIG5hbWUpOw0KIAlzeXNm
c19yZW1vdmVfbGluaygmY2Rldi0+ZGV2LT5rb2JqLCBuYW1lKTsNCiAJc3lzZnNfcmVtb3ZlX2xp
bmsoJmNkZXYtPmNkZXYua29iaiwgImRldmljZSIpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbW1j
L2NhcmQvYmxvY2suYyBiL2RyaXZlcnMvbW1jL2NhcmQvYmxvY2suYw0KaW5kZXggNzQ3OTNhZi4u
NDgwMmY3ZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbW1jL2NhcmQvYmxvY2suYw0KKysrIGIvZHJp
dmVycy9tbWMvY2FyZC9ibG9jay5jDQpAQCAtNjM0LDcgKzYzNCw3IEBAIHN0YXRpYyBpbnQgbW1j
X2Jsa19jbWRfZXJyb3Ioc3RydWN0IHJlcXVlc3QgKnJlcSwgY29uc3QgY2hhciAqbmFtZSwgaW50
IGVycm9yLA0KICAqIE90aGVyd2lzZSB3ZSBkb24ndCB1bmRlcnN0YW5kIHdoYXQgaGFwcGVuZWQs
IHNvIGFib3J0Lg0KICAqLw0KIHN0YXRpYyBpbnQgbW1jX2Jsa19jbWRfcmVjb3Zlcnkoc3RydWN0
IG1tY19jYXJkICpjYXJkLCBzdHJ1Y3QgcmVxdWVzdCAqcmVxLA0KLQlzdHJ1Y3QgbW1jX2Jsa19y
ZXF1ZXN0ICpicnEsIGludCAqZWNjX2VycikNCisJc3RydWN0IG1tY19ibGtfcmVxdWVzdCAqYnJx
LCBpbnQgKmVjY19lcnIsIGludCAqZ2VuX2VycikNCiB7DQogCWJvb2wgcHJldl9jbWRfc3RhdHVz
X3ZhbGlkID0gdHJ1ZTsNCiAJdTMyIHN0YXR1cywgc3RvcF9zdGF0dXMgPSAwOw0KQEAgLTY2NSw2
ICs2NjUsMTYgQEAgc3RhdGljIGludCBtbWNfYmxrX2NtZF9yZWNvdmVyeShzdHJ1Y3QgbW1jX2Nh
cmQgKmNhcmQsIHN0cnVjdCByZXF1ZXN0ICpyZXEsDQogCSAgICAoYnJxLT5jbWQucmVzcFswXSAm
IFIxX0NBUkRfRUNDX0ZBSUxFRCkpDQogCQkqZWNjX2VyciA9IDE7DQogDQorCS8qIEZsYWcgR2Vu
ZXJhbCBlcnJvcnMgKi8NCisJaWYgKCFtbWNfaG9zdF9pc19zcGkoY2FyZC0+aG9zdCkgJiYgcnFf
ZGF0YV9kaXIocmVxKSAhPSBSRUFEKQ0KKwkJaWYgKChzdGF0dXMgJiBSMV9FUlJPUikgfHwNCisJ
CQkoYnJxLT5zdG9wLnJlc3BbMF0gJiBSMV9FUlJPUikpIHsNCisJCQlwcl9lcnIoIiVzOiAlczog
Z2VuZXJhbCBlcnJvciBzZW5kaW5nIHN0b3Agb3Igc3RhdHVzIGNvbW1hbmQsIHN0b3AgY21kIHJl
c3BvbnNlICUjeCwgY2FyZCBzdGF0dXMgJSN4XG4iLA0KKwkJCSAgICAgICByZXEtPnJxX2Rpc2st
PmRpc2tfbmFtZSwgX19mdW5jX18sDQorCQkJICAgICAgIGJycS0+c3RvcC5yZXNwWzBdLCBzdGF0
dXMpOw0KKwkJCSpnZW5fZXJyID0gMTsNCisJCX0NCisNCiAJLyoNCiAJICogQ2hlY2sgdGhlIGN1
cnJlbnQgY2FyZCBzdGF0ZS4gIElmIGl0IGlzIGluIHNvbWUgZGF0YSB0cmFuc2Zlcg0KIAkgKiBt
b2RlLCB0ZWxsIGl0IHRvIHN0b3AgKGFuZCBob3BlZnVsbHkgdHJhbnNpdGlvbiBiYWNrIHRvIFRS
QU4uKQ0KQEAgLTY4NCw2ICs2OTQsMTMgQEAgc3RhdGljIGludCBtbWNfYmxrX2NtZF9yZWNvdmVy
eShzdHJ1Y3QgbW1jX2NhcmQgKmNhcmQsIHN0cnVjdCByZXF1ZXN0ICpyZXEsDQogCQkJcmV0dXJu
IEVSUl9BQk9SVDsNCiAJCWlmIChzdG9wX3N0YXR1cyAmIFIxX0NBUkRfRUNDX0ZBSUxFRCkNCiAJ
CQkqZWNjX2VyciA9IDE7DQorCQlpZiAoIW1tY19ob3N0X2lzX3NwaShjYXJkLT5ob3N0KSAmJiBy
cV9kYXRhX2RpcihyZXEpICE9IFJFQUQpDQorCQkJaWYgKHN0b3Bfc3RhdHVzICYgUjFfRVJST1Ip
IHsNCisJCQkJcHJfZXJyKCIlczogJXM6IGdlbmVyYWwgZXJyb3Igc2VuZGluZyBzdG9wIGNvbW1h
bmQsIHN0b3AgY21kIHJlc3BvbnNlICUjeFxuIiwNCisJCQkJICAgICAgIHJlcS0+cnFfZGlzay0+
ZGlza19uYW1lLCBfX2Z1bmNfXywNCisJCQkJICAgICAgIHN0b3Bfc3RhdHVzKTsNCisJCQkJKmdl
bl9lcnIgPSAxOw0KKwkJCX0NCiAJfQ0KIA0KIAkvKiBDaGVjayBmb3Igc2V0IGJsb2NrIGNvdW50
IGVycm9ycyAqLw0KQEAgLTkzMyw3ICs5NTAsNyBAQCBzdGF0aWMgaW50IG1tY19ibGtfZXJyX2No
ZWNrKHN0cnVjdCBtbWNfY2FyZCAqY2FyZCwNCiAJCQkJCQkgICAgbW1jX2FjdGl2ZSk7DQogCXN0
cnVjdCBtbWNfYmxrX3JlcXVlc3QgKmJycSA9ICZtcV9tcnEtPmJycTsNCiAJc3RydWN0IHJlcXVl
c3QgKnJlcSA9IG1xX21ycS0+cmVxOw0KLQlpbnQgZWNjX2VyciA9IDA7DQorCWludCBlY2NfZXJy
ID0gMCwgZ2VuX2VyciA9IDA7DQogDQogCS8qDQogCSAqIHNiYy5lcnJvciBpbmRpY2F0ZXMgYSBw
cm9ibGVtIHdpdGggdGhlIHNldCBibG9jayBjb3VudA0KQEAgLTk0Nyw3ICs5NjQsNyBAQCBzdGF0
aWMgaW50IG1tY19ibGtfZXJyX2NoZWNrKHN0cnVjdCBtbWNfY2FyZCAqY2FyZCwNCiAJICovDQog
CWlmIChicnEtPnNiYy5lcnJvciB8fCBicnEtPmNtZC5lcnJvciB8fCBicnEtPnN0b3AuZXJyb3Ig
fHwNCiAJICAgIGJycS0+ZGF0YS5lcnJvcikgew0KLQkJc3dpdGNoIChtbWNfYmxrX2NtZF9yZWNv
dmVyeShjYXJkLCByZXEsIGJycSwgJmVjY19lcnIpKSB7DQorCQlzd2l0Y2ggKG1tY19ibGtfY21k
X3JlY292ZXJ5KGNhcmQsIHJlcSwgYnJxLCAmZWNjX2VyciwgJmdlbl9lcnIpKSB7DQogCQljYXNl
IEVSUl9SRVRSWToNCiAJCQlyZXR1cm4gTU1DX0JMS19SRVRSWTsNCiAJCWNhc2UgRVJSX0FCT1JU
Og0KQEAgLTk3NSw2ICs5OTIsMTUgQEAgc3RhdGljIGludCBtbWNfYmxrX2Vycl9jaGVjayhzdHJ1
Y3QgbW1jX2NhcmQgKmNhcmQsDQogCSAqLw0KIAlpZiAoIW1tY19ob3N0X2lzX3NwaShjYXJkLT5o
b3N0KSAmJiBycV9kYXRhX2RpcihyZXEpICE9IFJFQUQpIHsNCiAJCXUzMiBzdGF0dXM7DQorDQor
CQkvKiBDaGVjayBzdG9wIGNvbW1hbmQgcmVzcG9uc2UgKi8NCisJCWlmIChicnEtPnN0b3AucmVz
cFswXSAmIFIxX0VSUk9SKSB7DQorCQkJcHJfZXJyKCIlczogJXM6IGdlbmVyYWwgZXJyb3Igc2Vu
ZGluZyBzdG9wIGNvbW1hbmQsIHN0b3AgY21kIHJlc3BvbnNlICUjeFxuIiwNCisJCQkgICAgICAg
cmVxLT5ycV9kaXNrLT5kaXNrX25hbWUsIF9fZnVuY19fLA0KKwkJCSAgICAgICBicnEtPnN0b3Au
cmVzcFswXSk7DQorCQkJZ2VuX2VyciA9IDE7DQorCQl9DQorDQogCQlkbyB7DQogCQkJaW50IGVy
ciA9IGdldF9jYXJkX3N0YXR1cyhjYXJkLCAmc3RhdHVzLCA1KTsNCiAJCQlpZiAoZXJyKSB7DQpA
QCAtOTgyLDYgKzEwMDgsMTQgQEAgc3RhdGljIGludCBtbWNfYmxrX2Vycl9jaGVjayhzdHJ1Y3Qg
bW1jX2NhcmQgKmNhcmQsDQogCQkJCSAgICAgICByZXEtPnJxX2Rpc2stPmRpc2tfbmFtZSwgZXJy
KTsNCiAJCQkJcmV0dXJuIE1NQ19CTEtfQ01EX0VSUjsNCiAJCQl9DQorDQorCQkJaWYgKHN0YXR1
cyAmIFIxX0VSUk9SKSB7DQorCQkJCXByX2VycigiJXM6ICVzOiBnZW5lcmFsIGVycm9yIHNlbmRp
bmcgc3RhdHVzIGNvbW1hbmQsIGNhcmQgc3RhdHVzICUjeFxuIiwNCisJCQkJICAgICAgIHJlcS0+
cnFfZGlzay0+ZGlza19uYW1lLCBfX2Z1bmNfXywNCisJCQkJICAgICAgIHN0YXR1cyk7DQorCQkJ
CWdlbl9lcnIgPSAxOw0KKwkJCX0NCisNCiAJCQkvKg0KIAkJCSAqIFNvbWUgY2FyZHMgbWlzaGFu
ZGxlIHRoZSBzdGF0dXMgYml0cywNCiAJCQkgKiBzbyBtYWtlIHN1cmUgdG8gY2hlY2sgYm90aCB0
aGUgYnVzeQ0KQEAgLTk5MSw2ICsxMDI1LDEzIEBAIHN0YXRpYyBpbnQgbW1jX2Jsa19lcnJfY2hl
Y2soc3RydWN0IG1tY19jYXJkICpjYXJkLA0KIAkJCSAoUjFfQ1VSUkVOVF9TVEFURShzdGF0dXMp
ID09IFIxX1NUQVRFX1BSRykpOw0KIAl9DQogDQorCS8qIGlmIGdlbmVyYWwgZXJyb3Igb2NjdXJz
LCByZXRyeSB0aGUgd3JpdGUgb3BlcmF0aW9uLiAqLw0KKwlpZiAoZ2VuX2Vycikgew0KKwkJcHJf
d2FybmluZygiJXM6IHJldHJ5aW5nIHdyaXRlIGZvciBnZW5lcmFsIGVycm9yXG4iLA0KKwkJCQly
ZXEtPnJxX2Rpc2stPmRpc2tfbmFtZSk7DQorCQlyZXR1cm4gTU1DX0JMS19SRVRSWTsNCisJfQ0K
Kw0KIAlpZiAoYnJxLT5kYXRhLmVycm9yKSB7DQogCQlwcl9lcnIoIiVzOiBlcnJvciAlZCB0cmFu
c2ZlcnJpbmcgZGF0YSwgc2VjdG9yICV1LCBuciAldSwgY21kIHJlc3BvbnNlICUjeCwgY2FyZCBz
dGF0dXMgJSN4XG4iLA0KIAkJICAgICAgIHJlcS0+cnFfZGlzay0+ZGlza19uYW1lLCBicnEtPmRh
dGEuZXJyb3IsDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tdGQvZGV2aWNlcy9tMjVwODAuYyBiL2Ry
aXZlcnMvbXRkL2RldmljZXMvbTI1cDgwLmMNCmluZGV4IDlmOTk4MmYuLjNkNmJlYjcgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL210ZC9kZXZpY2VzL20yNXA4MC5jDQorKysgYi9kcml2ZXJzL210ZC9k
ZXZpY2VzL20yNXA4MC5jDQpAQCAtNzEsNyArNzEsNyBAQA0KIA0KIC8qIERlZmluZSBtYXggdGlt
ZXMgdG8gY2hlY2sgc3RhdHVzIHJlZ2lzdGVyIGJlZm9yZSB3ZSBnaXZlIHVwLiAqLw0KICNkZWZp
bmUJTUFYX1JFQURZX1dBSVRfSklGRklFUwkoNDAgKiBIWikJLyogTTI1UDE2IHNwZWNzIDQwcyBt
YXggY2hpcCBlcmFzZSAqLw0KLSNkZWZpbmUJTUFYX0NNRF9TSVpFCQk1DQorI2RlZmluZQlNQVhf
Q01EX1NJWkUJCTYNCiANCiAjaWZkZWYgQ09ORklHX00yNVBYWF9VU0VfRkFTVF9SRUFEDQogI2Rl
ZmluZSBPUENPREVfUkVBRCAJT1BDT0RFX0ZBU1RfUkVBRA0KQEAgLTg3NCwxNCArODc0LDEzIEBA
IHN0YXRpYyBpbnQgX19kZXZpbml0IG0yNXBfcHJvYmUoc3RydWN0IHNwaV9kZXZpY2UgKnNwaSkN
CiAJCX0NCiAJfQ0KIA0KLQlmbGFzaCA9IGt6YWxsb2Moc2l6ZW9mICpmbGFzaCwgR0ZQX0tFUk5F
TCk7DQorCWZsYXNoID0gZGV2bV9remFsbG9jKCZzcGktPmRldiwgc2l6ZW9mKCpmbGFzaCksIEdG
UF9LRVJORUwpOw0KIAlpZiAoIWZsYXNoKQ0KIAkJcmV0dXJuIC1FTk9NRU07DQotCWZsYXNoLT5j
b21tYW5kID0ga21hbGxvYyhNQVhfQ01EX1NJWkUgKyBGQVNUX1JFQURfRFVNTVlfQllURSwgR0ZQ
X0tFUk5FTCk7DQotCWlmICghZmxhc2gtPmNvbW1hbmQpIHsNCi0JCWtmcmVlKGZsYXNoKTsNCisN
CisJZmxhc2gtPmNvbW1hbmQgPSBkZXZtX2t6YWxsb2MoJnNwaS0+ZGV2LCBNQVhfQ01EX1NJWkUs
IEdGUF9LRVJORUwpOw0KKwlpZiAoIWZsYXNoLT5jb21tYW5kKQ0KIAkJcmV0dXJuIC1FTk9NRU07
DQotCX0NCiANCiAJZmxhc2gtPnNwaSA9IHNwaTsNCiAJbXV0ZXhfaW5pdCgmZmxhc2gtPmxvY2sp
Ow0KQEAgLTk3OCwxNCArOTc3LDEwIEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IG0yNXBfcHJvYmUo
c3RydWN0IHNwaV9kZXZpY2UgKnNwaSkNCiBzdGF0aWMgaW50IF9fZGV2ZXhpdCBtMjVwX3JlbW92
ZShzdHJ1Y3Qgc3BpX2RldmljZSAqc3BpKQ0KIHsNCiAJc3RydWN0IG0yNXAJKmZsYXNoID0gZGV2
X2dldF9kcnZkYXRhKCZzcGktPmRldik7DQotCWludAkJc3RhdHVzOw0KIA0KIAkvKiBDbGVhbiB1
cCBNVEQgc3R1ZmYuICovDQotCXN0YXR1cyA9IG10ZF9kZXZpY2VfdW5yZWdpc3RlcigmZmxhc2gt
Pm10ZCk7DQotCWlmIChzdGF0dXMgPT0gMCkgew0KLQkJa2ZyZWUoZmxhc2gtPmNvbW1hbmQpOw0K
LQkJa2ZyZWUoZmxhc2gpOw0KLQl9DQorCW10ZF9kZXZpY2VfdW5yZWdpc3RlcigmZmxhc2gtPm10
ZCk7DQorDQogCXJldHVybiAwOw0KIH0NCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL210ZC9uYW5k
L2dwbWktbmFuZC9ncG1pLW5hbmQuYyBiL2RyaXZlcnMvbXRkL25hbmQvZ3BtaS1uYW5kL2dwbWkt
bmFuZC5jDQppbmRleCBmMzlmODNlLi5kNmE3NzY0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9tdGQv
bmFuZC9ncG1pLW5hbmQvZ3BtaS1uYW5kLmMNCisrKyBiL2RyaXZlcnMvbXRkL25hbmQvZ3BtaS1u
YW5kL2dwbWktbmFuZC5jDQpAQCAtMjI3LDggKzIyNyw2IEBAIHN0YXRpYyB2b2lkIGRtYV9pcnFf
Y2FsbGJhY2sodm9pZCAqcGFyYW0pDQogCXN0cnVjdCBncG1pX25hbmRfZGF0YSAqdGhpcyA9IHBh
cmFtOw0KIAlzdHJ1Y3QgY29tcGxldGlvbiAqZG1hX2MgPSAmdGhpcy0+ZG1hX2RvbmU7DQogDQot
CWNvbXBsZXRlKGRtYV9jKTsNCi0NCiAJc3dpdGNoICh0aGlzLT5kbWFfdHlwZSkgew0KIAljYXNl
IERNQV9GT1JfQ09NTUFORDoNCiAJCWRtYV91bm1hcF9zZyh0aGlzLT5kZXYsICZ0aGlzLT5jbWRf
c2dsLCAxLCBETUFfVE9fREVWSUNFKTsNCkBAIC0yNTMsNiArMjUxLDggQEAgc3RhdGljIHZvaWQg
ZG1hX2lycV9jYWxsYmFjayh2b2lkICpwYXJhbSkNCiAJZGVmYXVsdDoNCiAJCXByX2VycigiaW4g
d3JvbmcgRE1BIG9wZXJhdGlvbi5cbiIpOw0KIAl9DQorDQorCWNvbXBsZXRlKGRtYV9jKTsNCiB9
DQogDQogaW50IHN0YXJ0X2RtYV93aXRob3V0X2JjaF9pcnEoc3RydWN0IGdwbWlfbmFuZF9kYXRh
ICp0aGlzLA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbXRkL25hbmQvbmFuZF9iYXNlLmMgYi9kcml2
ZXJzL210ZC9uYW5kL25hbmRfYmFzZS5jDQppbmRleCBkYWVkNjk4Li40NmVkMjk2IDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9tdGQvbmFuZC9uYW5kX2Jhc2UuYw0KKysrIGIvZHJpdmVycy9tdGQvbmFu
ZC9uYW5kX2Jhc2UuYw0KQEAgLTI4OTUsMTAgKzI4OTUsMjIgQEAgc3RhdGljIGludCBuYW5kX2Zs
YXNoX2RldGVjdF9vbmZpKHN0cnVjdCBtdGRfaW5mbyAqbXRkLCBzdHJ1Y3QgbmFuZF9jaGlwICpj
aGlwLA0KIAlzYW5pdGl6ZV9zdHJpbmcocC0+bW9kZWwsIHNpemVvZihwLT5tb2RlbCkpOw0KIAlp
ZiAoIW10ZC0+bmFtZSkNCiAJCW10ZC0+bmFtZSA9IHAtPm1vZGVsOw0KKw0KIAltdGQtPndyaXRl
c2l6ZSA9IGxlMzJfdG9fY3B1KHAtPmJ5dGVfcGVyX3BhZ2UpOw0KLQltdGQtPmVyYXNlc2l6ZSA9
IGxlMzJfdG9fY3B1KHAtPnBhZ2VzX3Blcl9ibG9jaykgKiBtdGQtPndyaXRlc2l6ZTsNCisNCisJ
LyoNCisJICogcGFnZXNfcGVyX2Jsb2NrIGFuZCBibG9ja3NfcGVyX2x1biBtYXkgbm90IGJlIGEg
cG93ZXItb2YtMiBzaXplDQorCSAqIChkb24ndCBhc2sgbWUgd2hvIHRob3VnaHQgb2YgdGhpcy4u
LikuIE1URCBhc3N1bWVzIHRoYXQgdGhlc2UNCisJICogZGltZW5zaW9ucyB3aWxsIGJlIHBvd2Vy
LW9mLTIsIHNvIGp1c3QgdHJ1bmNhdGUgdGhlIHJlbWFpbmluZyBhcmVhLg0KKwkgKi8NCisJbXRk
LT5lcmFzZXNpemUgPSAxIDw8IChmbHMobGUzMl90b19jcHUocC0+cGFnZXNfcGVyX2Jsb2NrKSkg
LSAxKTsNCisJbXRkLT5lcmFzZXNpemUgKj0gbXRkLT53cml0ZXNpemU7DQorDQogCW10ZC0+b29i
c2l6ZSA9IGxlMTZfdG9fY3B1KHAtPnNwYXJlX2J5dGVzX3Blcl9wYWdlKTsNCi0JY2hpcC0+Y2hp
cHNpemUgPSAodWludDY0X3QpbGUzMl90b19jcHUocC0+YmxvY2tzX3Blcl9sdW4pICogbXRkLT5l
cmFzZXNpemU7DQorDQorCS8qIFNlZSBlcmFzZXNpemUgY29tbWVudCAqLw0KKwljaGlwLT5jaGlw
c2l6ZSA9IDEgPDwgKGZscyhsZTMyX3RvX2NwdShwLT5ibG9ja3NfcGVyX2x1bikpIC0gMSk7DQor
CWNoaXAtPmNoaXBzaXplICo9ICh1aW50NjRfdCltdGQtPmVyYXNlc2l6ZTsNCiAJKmJ1c3cgPSAw
Ow0KIAlpZiAobGUxNl90b19jcHUocC0+ZmVhdHVyZXMpICYgMSkNCiAJCSpidXN3ID0gTkFORF9C
VVNXSURUSF8xNjsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfc3lzZnMu
YyBiL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9zeXNmcy5jDQppbmRleCA4ZWQ0OGMyLi5jZjk1
YmQ4ZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9zeXNmcy5jDQorKysg
Yi9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfc3lzZnMuYw0KQEAgLTUzNCw4ICs1MzQsOSBAQCBz
dGF0aWMgc3NpemVfdCBib25kaW5nX3N0b3JlX2FycF9pbnRlcnZhbChzdHJ1Y3QgZGV2aWNlICpk
LA0KIAkJZ290byBvdXQ7DQogCX0NCiAJaWYgKGJvbmQtPnBhcmFtcy5tb2RlID09IEJPTkRfTU9E
RV9BTEIgfHwNCi0JICAgIGJvbmQtPnBhcmFtcy5tb2RlID09IEJPTkRfTU9ERV9UTEIpIHsNCi0J
CXByX2luZm8oIiVzOiBBUlAgbW9uaXRvcmluZyBjYW5ub3QgYmUgdXNlZCB3aXRoIEFMQi9UTEIu
IE9ubHkgTUlJIG1vbml0b3JpbmcgaXMgc3VwcG9ydGVkIG9uICVzLlxuIiwNCisJICAgIGJvbmQt
PnBhcmFtcy5tb2RlID09IEJPTkRfTU9ERV9UTEIgfHwNCisJICAgIGJvbmQtPnBhcmFtcy5tb2Rl
ID09IEJPTkRfTU9ERV84MDIzQUQpIHsNCisJCXByX2luZm8oIiVzOiBBUlAgbW9uaXRvcmluZyBj
YW5ub3QgYmUgdXNlZCB3aXRoIEFMQi9UTEIvODAyLjNhZC4gT25seSBNSUkgbW9uaXRvcmluZyBp
cyBzdXBwb3J0ZWQgb24gJXMuXG4iLA0KIAkJCWJvbmQtPmRldi0+bmFtZSwgYm9uZC0+ZGV2LT5u
YW1lKTsNCiAJCXJldCA9IC1FSU5WQUw7DQogCQlnb3RvIG91dDsNCkBAIC02OTMsNiArNjk0LDgg
QEAgc3RhdGljIHNzaXplX3QgYm9uZGluZ19zdG9yZV9kb3duZGVsYXkoc3RydWN0IGRldmljZSAq
ZCwNCiAJaW50IG5ld192YWx1ZSwgcmV0ID0gY291bnQ7DQogCXN0cnVjdCBib25kaW5nICpib25k
ID0gdG9fYm9uZChkKTsNCiANCisJaWYgKCFydG5sX3RyeWxvY2soKSkNCisJCXJldHVybiByZXN0
YXJ0X3N5c2NhbGwoKTsNCiAJaWYgKCEoYm9uZC0+cGFyYW1zLm1paW1vbikpIHsNCiAJCXByX2Vy
cigiJXM6IFVuYWJsZSB0byBzZXQgZG93biBkZWxheSBhcyBNSUkgbW9uaXRvcmluZyBpcyBkaXNh
YmxlZFxuIiwNCiAJCSAgICAgICBib25kLT5kZXYtPm5hbWUpOw0KQEAgLTcyNiw2ICs3MjksNyBA
QCBzdGF0aWMgc3NpemVfdCBib25kaW5nX3N0b3JlX2Rvd25kZWxheShzdHJ1Y3QgZGV2aWNlICpk
LA0KIAl9DQogDQogb3V0Og0KKwlydG5sX3VubG9jaygpOw0KIAlyZXR1cm4gcmV0Ow0KIH0NCiBz
dGF0aWMgREVWSUNFX0FUVFIoZG93bmRlbGF5LCBTX0lSVUdPIHwgU19JV1VTUiwNCkBAIC03NDgs
NiArNzUyLDggQEAgc3RhdGljIHNzaXplX3QgYm9uZGluZ19zdG9yZV91cGRlbGF5KHN0cnVjdCBk
ZXZpY2UgKmQsDQogCWludCBuZXdfdmFsdWUsIHJldCA9IGNvdW50Ow0KIAlzdHJ1Y3QgYm9uZGlu
ZyAqYm9uZCA9IHRvX2JvbmQoZCk7DQogDQorCWlmICghcnRubF90cnlsb2NrKCkpDQorCQlyZXR1
cm4gcmVzdGFydF9zeXNjYWxsKCk7DQogCWlmICghKGJvbmQtPnBhcmFtcy5taWltb24pKSB7DQog
CQlwcl9lcnIoIiVzOiBVbmFibGUgdG8gc2V0IHVwIGRlbGF5IGFzIE1JSSBtb25pdG9yaW5nIGlz
IGRpc2FibGVkXG4iLA0KIAkJICAgICAgIGJvbmQtPmRldi0+bmFtZSk7DQpAQCAtNzgxLDYgKzc4
Nyw3IEBAIHN0YXRpYyBzc2l6ZV90IGJvbmRpbmdfc3RvcmVfdXBkZWxheShzdHJ1Y3QgZGV2aWNl
ICpkLA0KIAl9DQogDQogb3V0Og0KKwlydG5sX3VubG9jaygpOw0KIAlyZXR1cm4gcmV0Ow0KIH0N
CiBzdGF0aWMgREVWSUNFX0FUVFIodXBkZWxheSwgU19JUlVHTyB8IFNfSVdVU1IsDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvY2FuL2NfY2FuL2NfY2FuLmMgYi9kcml2ZXJzL25ldC9jYW4vY19j
YW4vY19jYW4uYw0KaW5kZXggNjQ2NDdkNC4uOTFkMWI1YSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L2Nhbi9jX2Nhbi9jX2Nhbi5jDQorKysgYi9kcml2ZXJzL25ldC9jYW4vY19jYW4vY19jYW4u
Yw0KQEAgLTc2NCw5ICs3NjQsNiBAQCBzdGF0aWMgaW50IGNfY2FuX2RvX3J4X3BvbGwoc3RydWN0
IG5ldF9kZXZpY2UgKmRldiwgaW50IHF1b3RhKQ0KIAkJCW1zZ19jdHJsX3NhdmUgPSBwcml2LT5y
ZWFkX3JlZyhwcml2LA0KIAkJCQkJJnByaXYtPnJlZ3MtPmlmcmVnc1swXS5tc2dfY250cmwpOw0K
IA0KLQkJCWlmIChtc2dfY3RybF9zYXZlICYgSUZfTUNPTlRfRU9CKQ0KLQkJCQlyZXR1cm4gbnVt
X3J4X3BrdHM7DQotDQogCQkJaWYgKG1zZ19jdHJsX3NhdmUgJiBJRl9NQ09OVF9NU0dMU1QpIHsN
CiAJCQkJY19jYW5faGFuZGxlX2xvc3RfbXNnX29iaihkZXYsIDAsIG1zZ19vYmopOw0KIAkJCQlu
dW1fcnhfcGt0cysrOw0KQEAgLTc3NCw2ICs3NzEsOSBAQCBzdGF0aWMgaW50IGNfY2FuX2RvX3J4
X3BvbGwoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgaW50IHF1b3RhKQ0KIAkJCQljb250aW51ZTsN
CiAJCQl9DQogDQorCQkJaWYgKG1zZ19jdHJsX3NhdmUgJiBJRl9NQ09OVF9FT0IpDQorCQkJCXJl
dHVybiBudW1fcnhfcGt0czsNCisNCiAJCQlpZiAoIShtc2dfY3RybF9zYXZlICYgSUZfTUNPTlRf
TkVXREFUKSkNCiAJCQkJY29udGludWU7DQogDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2Fu
L3NqYTEwMDAvc2phMTAwMC5jIGIvZHJpdmVycy9uZXQvY2FuL3NqYTEwMDAvc2phMTAwMC5jDQpp
bmRleCA2YTFhY2ZlLi41NjhiODIxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvY2FuL3NqYTEw
MDAvc2phMTAwMC5jDQorKysgYi9kcml2ZXJzL25ldC9jYW4vc2phMTAwMC9zamExMDAwLmMNCkBA
IC00ODgsMTkgKzQ4OCwxOSBAQCBpcnFyZXR1cm5fdCBzamExMDAwX2ludGVycnVwdChpbnQgaXJx
LCB2b2lkICpkZXZfaWQpDQogCXVpbnQ4X3QgaXNyYywgc3RhdHVzOw0KIAlpbnQgbiA9IDA7DQog
DQotCS8qIFNoYXJlZCBpbnRlcnJ1cHRzIGFuZCBJUlEgb2ZmPyAqLw0KLQlpZiAocHJpdi0+cmVh
ZF9yZWcocHJpdiwgUkVHX0lFUikgPT0gSVJRX09GRikNCi0JCXJldHVybiBJUlFfTk9ORTsNCi0N
CiAJaWYgKHByaXYtPnByZV9pcnEpDQogCQlwcml2LT5wcmVfaXJxKHByaXYpOw0KIA0KKwkvKiBT
aGFyZWQgaW50ZXJydXB0cyBhbmQgSVJRIG9mZj8gKi8NCisJaWYgKHByaXYtPnJlYWRfcmVnKHBy
aXYsIFJFR19JRVIpID09IElSUV9PRkYpDQorCQlnb3RvIG91dDsNCisNCiAJd2hpbGUgKChpc3Jj
ID0gcHJpdi0+cmVhZF9yZWcocHJpdiwgUkVHX0lSKSkgJiYgKG4gPCBTSkExMDAwX01BWF9JUlEp
KSB7DQotCQluKys7DQorDQogCQlzdGF0dXMgPSBwcml2LT5yZWFkX3JlZyhwcml2LCBTSkExMDAw
X1JFR19TUik7DQogCQkvKiBjaGVjayBmb3IgYWJzZW50IGNvbnRyb2xsZXIgZHVlIHRvIGh3IHVu
cGx1ZyAqLw0KIAkJaWYgKHN0YXR1cyA9PSAweEZGICYmIHNqYTEwMDBfaXNfYWJzZW50KHByaXYp
KQ0KLQkJCXJldHVybiBJUlFfTk9ORTsNCisJCQlnb3RvIG91dDsNCiANCiAJCWlmIChpc3JjICYg
SVJRX1dVSSkNCiAJCQlkZXZfd2FybihkZXYtPmRldi5wYXJlbnQsICJ3YWtldXAgaW50ZXJydXB0
XG4iKTsNCkBAIC01MTksNyArNTE5LDcgQEAgaXJxcmV0dXJuX3Qgc2phMTAwMF9pbnRlcnJ1cHQo
aW50IGlycSwgdm9pZCAqZGV2X2lkKQ0KIAkJCQlzdGF0dXMgPSBwcml2LT5yZWFkX3JlZyhwcml2
LCBTSkExMDAwX1JFR19TUik7DQogCQkJCS8qIGNoZWNrIGZvciBhYnNlbnQgY29udHJvbGxlciAq
Lw0KIAkJCQlpZiAoc3RhdHVzID09IDB4RkYgJiYgc2phMTAwMF9pc19hYnNlbnQocHJpdikpDQot
CQkJCQlyZXR1cm4gSVJRX05PTkU7DQorCQkJCQlnb3RvIG91dDsNCiAJCQl9DQogCQl9DQogCQlp
ZiAoaXNyYyAmIChJUlFfRE9JIHwgSVJRX0VJIHwgSVJRX0JFSSB8IElSUV9FUEkgfCBJUlFfQUxJ
KSkgew0KQEAgLTUyNyw4ICs1MjcsOSBAQCBpcnFyZXR1cm5fdCBzamExMDAwX2ludGVycnVwdChp
bnQgaXJxLCB2b2lkICpkZXZfaWQpDQogCQkJaWYgKHNqYTEwMDBfZXJyKGRldiwgaXNyYywgc3Rh
dHVzKSkNCiAJCQkJYnJlYWs7DQogCQl9DQorCQluKys7DQogCX0NCi0NCitvdXQ6DQogCWlmIChw
cml2LT5wb3N0X2lycSkNCiAJCXByaXYtPnBvc3RfaXJxKHByaXYpOw0KIA0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3Ntc2Mvc21jOTF4LmggYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9zbXNjL3NtYzkxeC5oDQppbmRleCA1ZjUzZmJiLi5mZjFhZjQxIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvc21zYy9zbWM5MXguaA0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvc21zYy9zbWM5MXguaA0KQEAgLTQ2LDcgKzQ2LDggQEANCiAgICAgZGVmaW5lZChDT05GSUdf
TUFDSF9MSVRUTEVUT04pIHx8XA0KICAgICBkZWZpbmVkKENPTkZJR19NQUNIX1pZTE9OSVRFMikg
fHxcDQogICAgIGRlZmluZWQoQ09ORklHX0FSQ0hfVklQRVIpIHx8XA0KLSAgICBkZWZpbmVkKENP
TkZJR19NQUNIX1NUQVJHQVRFMikNCisgICAgZGVmaW5lZChDT05GSUdfTUFDSF9TVEFSR0FURTIp
IHx8XA0KKyAgICBkZWZpbmVkKENPTkZJR19BUkNIX1ZFUlNBVElMRSkNCiANCiAjaW5jbHVkZSA8
YXNtL21hY2gtdHlwZXMuaD4NCiANCkBAIC0xNTQsNiArMTU1LDggQEAgc3RhdGljIGlubGluZSB2
b2lkIFNNQ19vdXR3KHUxNiB2YWwsIHZvaWQgX19pb21lbSAqaW9hZGRyLCBpbnQgcmVnKQ0KICNk
ZWZpbmUgU01DX291dGwodiwgYSwgcikJd3JpdGVsKHYsIChhKSArIChyKSkNCiAjZGVmaW5lIFNN
Q19pbnNsKGEsIHIsIHAsIGwpCXJlYWRzbCgoYSkgKyAociksIHAsIGwpDQogI2RlZmluZSBTTUNf
b3V0c2woYSwgciwgcCwgbCkJd3JpdGVzbCgoYSkgKyAociksIHAsIGwpDQorI2RlZmluZSBTTUNf
aW5zdyhhLCByLCBwLCBsKQlyZWFkc3coKGEpICsgKHIpLCBwLCBsKQ0KKyNkZWZpbmUgU01DX291
dHN3KGEsIHIsIHAsIGwpCXdyaXRlc3coKGEpICsgKHIpLCBwLCBsKQ0KICNkZWZpbmUgU01DX0lS
UV9GTEFHUwkJKC0xKQkvKiBmcm9tIHJlc291cmNlICovDQogDQogLyogV2UgYWN0dWFsbHkgY2Fu
J3Qgd3JpdGUgaGFsZndvcmRzIHByb3Blcmx5IGlmIG5vdCB3b3JkIGFsaWduZWQgKi8NCkBAIC0y
MDYsMjMgKzIwOSw2IEBAIFNNQ19vdXR3KHUxNiB2YWwsIHZvaWQgX19pb21lbSAqaW9hZGRyLCBp
bnQgcmVnKQ0KICNkZWZpbmUgUlBDX0xTQV9ERUZBVUxUCQlSUENfTEVEX1RYX1JYDQogI2RlZmlu
ZSBSUENfTFNCX0RFRkFVTFQJCVJQQ19MRURfMTAwXzEwDQogDQotI2VsaWYJZGVmaW5lZChDT05G
SUdfQVJDSF9WRVJTQVRJTEUpDQotDQotI2RlZmluZSBTTUNfQ0FOX1VTRV84QklUCTENCi0jZGVm
aW5lIFNNQ19DQU5fVVNFXzE2QklUCTENCi0jZGVmaW5lIFNNQ19DQU5fVVNFXzMyQklUCTENCi0j
ZGVmaW5lIFNNQ19OT1dBSVQJCTENCi0NCi0jZGVmaW5lIFNNQ19pbmIoYSwgcikJCXJlYWRiKChh
KSArIChyKSkNCi0jZGVmaW5lIFNNQ19pbncoYSwgcikJCXJlYWR3KChhKSArIChyKSkNCi0jZGVm
aW5lIFNNQ19pbmwoYSwgcikJCXJlYWRsKChhKSArIChyKSkNCi0jZGVmaW5lIFNNQ19vdXRiKHYs
IGEsIHIpCXdyaXRlYih2LCAoYSkgKyAocikpDQotI2RlZmluZSBTTUNfb3V0dyh2LCBhLCByKQl3
cml0ZXcodiwgKGEpICsgKHIpKQ0KLSNkZWZpbmUgU01DX291dGwodiwgYSwgcikJd3JpdGVsKHYs
IChhKSArIChyKSkNCi0jZGVmaW5lIFNNQ19pbnNsKGEsIHIsIHAsIGwpCXJlYWRzbCgoYSkgKyAo
ciksIHAsIGwpDQotI2RlZmluZSBTTUNfb3V0c2woYSwgciwgcCwgbCkJd3JpdGVzbCgoYSkgKyAo
ciksIHAsIGwpDQotI2RlZmluZSBTTUNfSVJRX0ZMQUdTCQkoLTEpCS8qIGZyb20gcmVzb3VyY2Ug
Ki8NCi0NCiAjZWxpZiBkZWZpbmVkKENPTkZJR19NTjEwMzAwKQ0KIA0KIC8qDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvcHBwL3BwcG9lLmMgYi9kcml2ZXJzL25ldC9wcHAvcHBwb2UuYw0KaW5k
ZXggMTE2MTU4NC4uMmYzMTlkMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3BwcC9wcHBvZS5j
DQorKysgYi9kcml2ZXJzL25ldC9wcHAvcHBwb2UuYw0KQEAgLTk4NSw4ICs5ODUsNiBAQCBzdGF0
aWMgaW50IHBwcG9lX3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpz
b2NrLA0KIAlpZiAoZXJyb3IgPCAwKQ0KIAkJZ290byBlbmQ7DQogDQotCW0tPm1zZ19uYW1lbGVu
ID0gMDsNCi0NCiAJaWYgKHNrYikgew0KIAkJdG90YWxfbGVuID0gbWluX3Qoc2l6ZV90LCB0b3Rh
bF9sZW4sIHNrYi0+bGVuKTsNCiAJCWVycm9yID0gc2tiX2NvcHlfZGF0YWdyYW1faW92ZWMoc2ti
LCAwLCBtLT5tc2dfaW92LCB0b3RhbF9sZW4pOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2xpYmVydGFzL2RlYnVnZnMuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2xpYmVydGFz
L2RlYnVnZnMuYw0KaW5kZXggZDhkOGYwZC4uMzVkODZmYSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2xpYmVydGFzL2RlYnVnZnMuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvbGliZXJ0YXMvZGVidWdmcy5jDQpAQCAtOTE5LDcgKzkxOSwxMCBAQCBzdGF0aWMgc3NpemVf
dCBsYnNfZGVidWdmc193cml0ZShzdHJ1Y3QgZmlsZSAqZiwgY29uc3QgY2hhciBfX3VzZXIgKmJ1
ZiwNCiAJY2hhciAqcDI7DQogCXN0cnVjdCBkZWJ1Z19kYXRhICpkID0gZi0+cHJpdmF0ZV9kYXRh
Ow0KIA0KLQlwZGF0YSA9IGttYWxsb2MoY250LCBHRlBfS0VSTkVMKTsNCisJaWYgKGNudCA9PSAw
KQ0KKwkJcmV0dXJuIDA7DQorDQorCXBkYXRhID0ga21hbGxvYyhjbnQgKyAxLCBHRlBfS0VSTkVM
KTsNCiAJaWYgKHBkYXRhID09IE5VTEwpDQogCQlyZXR1cm4gMDsNCiANCkBAIC05MjgsNiArOTMx
LDcgQEAgc3RhdGljIHNzaXplX3QgbGJzX2RlYnVnZnNfd3JpdGUoc3RydWN0IGZpbGUgKmYsIGNv
bnN0IGNoYXIgX191c2VyICpidWYsDQogCQlrZnJlZShwZGF0YSk7DQogCQlyZXR1cm4gMDsNCiAJ
fQ0KKwlwZGF0YVtjbnRdID0gJ1wwJzsNCiANCiAJcDAgPSBwZGF0YTsNCiAJZm9yIChpID0gMDsg
aSA8IG51bV9vZl9pdGVtczsgaSsrKSB7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvbXdpZmlleC9zZGlvLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L3NkaW8uYw0K
aW5kZXggMTdmODcyMC4uNzJiMjUzZDIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9td2lmaWV4L3NkaW8uYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zZGlv
LmMNCkBAIC05MzYsNyArOTM2LDEwIEBAIHN0YXRpYyBpbnQgbXdpZmlleF9kZWNvZGVfcnhfcGFj
a2V0KHN0cnVjdCBtd2lmaWV4X2FkYXB0ZXIgKmFkYXB0ZXIsDQogCQkJCSAgICBzdHJ1Y3Qgc2tf
YnVmZiAqc2tiLCB1MzIgdXBsZF90eXApDQogew0KIAl1OCAqY21kX2J1ZjsNCisJX19sZTE2ICpj
dXJyX3B0ciA9IChfX2xlMTYgKilza2ItPmRhdGE7DQorCXUxNiBwa3RfbGVuID0gbGUxNl90b19j
cHUoKmN1cnJfcHRyKTsNCiANCisJc2tiX3RyaW0oc2tiLCBwa3RfbGVuKTsNCiAJc2tiX3B1bGwo
c2tiLCBJTlRGX0hFQURFUl9MRU4pOw0KIA0KIAlzd2l0Y2ggKHVwbGRfdHlwKSB7DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcHJpc201NC9pc2xwY2lfZGV2LmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9wcmlzbTU0L2lzbHBjaV9kZXYuYw0KaW5kZXggNWQwZjYxNS4uZTJmYTUz
OCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3ByaXNtNTQvaXNscGNpX2Rldi5j
DQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9wcmlzbTU0L2lzbHBjaV9kZXYuYw0KQEAgLTgx
Miw2ICs4MTIsMTAgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlX29wcyBpc2xwY2lf
bmV0ZGV2X29wcyA9IHsNCiAJLm5kb192YWxpZGF0ZV9hZGRyCT0gZXRoX3ZhbGlkYXRlX2FkZHIs
DQogfTsNCiANCitzdGF0aWMgc3RydWN0IGRldmljZV90eXBlIHdsYW5fdHlwZSA9IHsNCisJLm5h
bWUJPSAid2xhbiIsDQorfTsNCisNCiBzdHJ1Y3QgbmV0X2RldmljZSAqDQogaXNscGNpX3NldHVw
KHN0cnVjdCBwY2lfZGV2ICpwZGV2KQ0KIHsNCkBAIC04MjIsOSArODI2LDggQEAgaXNscGNpX3Nl
dHVwKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQ0KIAkJcmV0dXJuIG5kZXY7DQogDQogCXBjaV9zZXRf
ZHJ2ZGF0YShwZGV2LCBuZGV2KTsNCi0jaWYgZGVmaW5lZChTRVRfTkVUREVWX0RFVikNCiAJU0VU
X05FVERFVl9ERVYobmRldiwgJnBkZXYtPmRldik7DQotI2VuZGlmDQorCVNFVF9ORVRERVZfREVW
VFlQRShuZGV2LCAmd2xhbl90eXBlKTsNCiANCiAJLyogc2V0dXAgdGhlIHN0cnVjdHVyZSBtZW1i
ZXJzICovDQogCW5kZXYtPmJhc2VfYWRkciA9IHBjaV9yZXNvdXJjZV9zdGFydChwZGV2LCAwKTsN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydDJ4MDAvcnQyNDAwcGNpLmMgYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9ydDJ4MDAvcnQyNDAwcGNpLmMNCmluZGV4IDBlYTg1ZjQuLjEz
MWIyMmIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydDJ4MDAvcnQyNDAwcGNp
LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0MngwMC9ydDI0MDBwY2kuYw0KQEAgLTEy
NTMsNyArMTI1Myw3IEBAIHN0YXRpYyB2b2lkIHJ0MjQwMHBjaV9maWxsX3J4ZG9uZShzdHJ1Y3Qg
cXVldWVfZW50cnkgKmVudHJ5LA0KIAkgKi8NCiAJcnhkZXNjLT50aW1lc3RhbXAgPSAoKHU2NCly
eF9oaWdoIDw8IDMyKSB8IHJ4X2xvdzsNCiAJcnhkZXNjLT5zaWduYWwgPSBydDJ4MDBfZ2V0X2Zp
ZWxkMzIod29yZDIsIFJYRF9XMl9TSUdOQUwpICYgfjB4MDg7DQotCXJ4ZGVzYy0+cnNzaSA9IHJ0
MngwMF9nZXRfZmllbGQzMih3b3JkMiwgUlhEX1czX1JTU0kpIC0NCisJcnhkZXNjLT5yc3NpID0g
cnQyeDAwX2dldF9maWVsZDMyKHdvcmQzLCBSWERfVzNfUlNTSSkgLQ0KIAkgICAgZW50cnktPnF1
ZXVlLT5ydDJ4MDBkZXYtPnJzc2lfb2Zmc2V0Ow0KIAlyeGRlc2MtPnNpemUgPSBydDJ4MDBfZ2V0
X2ZpZWxkMzIod29yZDAsIFJYRF9XMF9EQVRBQllURV9DT1VOVCk7DQogDQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcnQyeDAwL3J0MngwMG1hYy5jIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvcnQyeDAwL3J0MngwMG1hYy5jDQppbmRleCA5MjFkYTlhLi41YzM4MjgxIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnQyeDAwL3J0MngwMG1hYy5jDQorKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9ydDJ4MDAvcnQyeDAwbWFjLmMNCkBAIC03NzEsNiArNzcxLDkgQEAg
dm9pZCBydDJ4MDBtYWNfZmx1c2goc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIGJvb2wgZHJvcCkN
CiAJc3RydWN0IHJ0MngwMF9kZXYgKnJ0MngwMGRldiA9IGh3LT5wcml2Ow0KIAlzdHJ1Y3QgZGF0
YV9xdWV1ZSAqcXVldWU7DQogDQorCWlmICghdGVzdF9iaXQoREVWSUNFX1NUQVRFX1BSRVNFTlQs
ICZydDJ4MDBkZXYtPmZsYWdzKSkNCisJCXJldHVybjsNCisNCiAJdHhfcXVldWVfZm9yX2VhY2go
cnQyeDAwZGV2LCBxdWV1ZSkNCiAJCXJ0MngwMHF1ZXVlX2ZsdXNoX3F1ZXVlKHF1ZXVlLCBkcm9w
KTsNCiB9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9iYXNlLmMg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL2Jhc2UuYw0KaW5kZXggYjRjZTkzNC4uYTkx
N2EyMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvYmFzZS5jDQor
KysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL2Jhc2UuYw0KQEAgLTMxLDYgKzMxLDcg
QEANCiANCiAjaW5jbHVkZSA8bGludXgvaXAuaD4NCiAjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+
DQorI2luY2x1ZGUgPGxpbnV4L3VkcC5oPg0KICNpbmNsdWRlICJ3aWZpLmgiDQogI2luY2x1ZGUg
InJjLmgiDQogI2luY2x1ZGUgImJhc2UuaCINCkBAIC05NTYsNjAgKzk1Nyw1MSBAQCB1OCBydGxf
aXNfc3BlY2lhbF9kYXRhKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3Qgc2tfYnVmZiAq
c2tiLCB1OCBpc190eCkNCiAJaWYgKCFpZWVlODAyMTFfaXNfZGF0YShmYykpDQogCQlyZXR1cm4g
ZmFsc2U7DQogDQorCWlwID0gKGNvbnN0IHN0cnVjdCBpcGhkciAqKShza2ItPmRhdGEgKyBtYWNf
aGRyX2xlbiArDQorCQkJCSAgICBTTkFQX1NJWkUgKyBQUk9UT0NfVFlQRV9TSVpFKTsNCisJZXRo
ZXJfdHlwZSA9IGJlMTZfdG9fY3B1cCgoX19iZTE2ICopDQorCQkJCSAgKHNrYi0+ZGF0YSArIG1h
Y19oZHJfbGVuICsgU05BUF9TSVpFKSk7DQogDQotCWlwID0gKHN0cnVjdCBpcGhkciAqKSgodTgg
Kikgc2tiLT5kYXRhICsgbWFjX2hkcl9sZW4gKw0KLQkJCSAgICAgIFNOQVBfU0laRSArIFBST1RP
Q19UWVBFX1NJWkUpOw0KLQlldGhlcl90eXBlID0gKih1MTYgKikgKCh1OCAqKSBza2ItPmRhdGEg
KyBtYWNfaGRyX2xlbiArIFNOQVBfU0laRSk7DQotCS8qCWV0aGVyX3R5cGUgPSBudG9ocyhldGhl
cl90eXBlKTsgKi8NCi0NCi0JaWYgKEVUSF9QX0lQID09IGV0aGVyX3R5cGUpIHsNCi0JCWlmIChJ
UFBST1RPX1VEUCA9PSBpcC0+cHJvdG9jb2wpIHsNCi0JCQlzdHJ1Y3QgdWRwaGRyICp1ZHAgPSAo
c3RydWN0IHVkcGhkciAqKSgodTggKikgaXAgKw0KLQkJCQkJCQkgICAgICAgKGlwLT5paGwgPDwg
MikpOw0KLQkJCWlmICgoKCgodTggKikgdWRwKVsxXSA9PSA2OCkgJiYNCi0JCQkgICAgICgoKHU4
ICopIHVkcClbM10gPT0gNjcpKSB8fA0KLQkJCSAgICAoKCgodTggKikgdWRwKVsxXSA9PSA2Nykg
JiYNCi0JCQkgICAgICgoKHU4ICopIHVkcClbM10gPT0gNjgpKSkgew0KLQkJCQkvKg0KLQkJCQkg
KiA2OCA6IFVEUCBCT09UUCBjbGllbnQNCi0JCQkJICogNjcgOiBVRFAgQk9PVFAgc2VydmVyDQot
CQkJCSAqLw0KLQkJCQlSVF9UUkFDRShydGxwcml2LCAoQ09NUF9TRU5EIHwgQ09NUF9SRUNWKSwN
Ci0JCQkJCSBEQkdfRE1FU0csICgiZGhjcCAlcyAhIVxuIiwNCi0JCQkJCQkgICAgIChpc190eCkg
PyAiVHgiIDogIlJ4IikpOw0KLQ0KLQkJCQlpZiAoaXNfdHgpIHsNCi0JCQkJCXJ0bF9scHNfbGVh
dmUoaHcpOw0KLQkJCQkJcHBzYy0+bGFzdF9kZWxheWxwc19zdGFtcF9qaWZmaWVzID0NCi0JCQkJ
CSAgICBqaWZmaWVzOw0KLQkJCQl9DQotDQotCQkJCXJldHVybiB0cnVlOw0KLQkJCX0NCi0JCX0N
Ci0JfSBlbHNlIGlmIChFVEhfUF9BUlAgPT0gZXRoZXJfdHlwZSkgew0KLQkJaWYgKGlzX3R4KSB7
DQotCQkJcnRsX2xwc19sZWF2ZShodyk7DQotCQkJcHBzYy0+bGFzdF9kZWxheWxwc19zdGFtcF9q
aWZmaWVzID0gamlmZmllczsNCi0JCX0NCisJc3dpdGNoIChldGhlcl90eXBlKSB7DQorCWNhc2Ug
RVRIX1BfSVA6IHsNCisJCXN0cnVjdCB1ZHBoZHIgKnVkcDsNCisJCXUxNiBzcmM7DQorCQl1MTYg
ZHN0Ow0KIA0KLQkJcmV0dXJuIHRydWU7DQotCX0gZWxzZSBpZiAoRVRIX1BfUEFFID09IGV0aGVy
X3R5cGUpIHsNCi0JCVJUX1RSQUNFKHJ0bHByaXYsIChDT01QX1NFTkQgfCBDT01QX1JFQ1YpLCBE
QkdfRE1FU0csDQotCQkJICgiODAyLjFYICVzIEVBUE9MIHBrdCEhXG4iLCAoaXNfdHgpID8gIlR4
IiA6ICJSeCIpKTsNCisJCWlmIChpcC0+cHJvdG9jb2wgIT0gSVBQUk9UT19VRFApDQorCQkJcmV0
dXJuIGZhbHNlOw0KKwkJdWRwID0gKHN0cnVjdCB1ZHBoZHIgKikoKHU4ICopaXAgKyAoaXAtPmlo
bCA8PCAyKSk7DQorCQlzcmMgPSBiZTE2X3RvX2NwdSh1ZHAtPnNvdXJjZSk7DQorCQlkc3QgPSBi
ZTE2X3RvX2NwdSh1ZHAtPmRlc3QpOw0KIA0KLQkJaWYgKGlzX3R4KSB7DQotCQkJcnRsX2xwc19s
ZWF2ZShodyk7DQotCQkJcHBzYy0+bGFzdF9kZWxheWxwc19zdGFtcF9qaWZmaWVzID0gamlmZmll
czsNCi0JCX0NCisJCS8qIElmIHRoaXMgY2FzZSBpbnZvbHZlcyBwb3J0IDY4IChVRFAgQk9PVFAg
Y2xpZW50KSBjb25uZWN0aW5nDQorCQkgKiB3aXRoIHBvcnQgNjcgKFVEUCBCT09UUCBzZXJ2ZXIp
LCB0aGVuIHJldHVybiB0cnVlIHNvIHRoYXQNCisJCSAqIHRoZSBsb3dlc3Qgc3BlZWQgaXMgdXNl
ZC4NCisJCSAqLw0KKwkJaWYgKCEoKHNyYyA9PSA2OCAmJiBkc3QgPT0gNjcpIHx8IChzcmMgPT0g
NjcgJiYgZHN0ID09IDY4KSkpDQorCQkJcmV0dXJuIGZhbHNlOw0KIA0KLQkJcmV0dXJuIHRydWU7
DQotCX0gZWxzZSBpZiAoRVRIX1BfSVBWNiA9PSBldGhlcl90eXBlKSB7DQotCQkvKiBJUHY2ICov
DQotCQlyZXR1cm4gdHJ1ZTsNCisJCVJUX1RSQUNFKHJ0bHByaXYsIChDT01QX1NFTkQgfCBDT01Q
X1JFQ1YpLCBEQkdfRE1FU0csDQorCQkJICgiZGhjcCAlcyAhIVxuIiwgaXNfdHggPyAiVHgiIDog
IlJ4IikpOw0KKwkJYnJlYWs7DQogCX0NCi0NCi0JcmV0dXJuIGZhbHNlOw0KKwljYXNlIEVUSF9Q
X0FSUDoNCisJCWJyZWFrOw0KKwljYXNlIEVUSF9QX1BBRToNCisJCVJUX1RSQUNFKHJ0bHByaXYs
IChDT01QX1NFTkQgfCBDT01QX1JFQ1YpLCBEQkdfRE1FU0csDQorCQkJICgiODAyLjFYICVzIEVB
UE9MIHBrdCEhXG4iLCBpc190eCA/ICJUeCIgOiAiUngiKSk7DQorCQlicmVhazsNCisJY2FzZSBF
VEhfUF9JUFY2Og0KKwkJLyogVE9ETzogSXMgdGhpcyByaWdodD8gKi8NCisJCXJldHVybiBmYWxz
ZTsNCisJZGVmYXVsdDoNCisJCXJldHVybiBmYWxzZTsNCisJfQ0KKwlpZiAoaXNfdHgpIHsNCisJ
CXJ0bF9scHNfbGVhdmUoaHcpOw0KKwkJcHBzYy0+bGFzdF9kZWxheWxwc19zdGFtcF9qaWZmaWVz
ID0gamlmZmllczsNCisJfQ0KKwlyZXR1cm4gdHJ1ZTsNCiB9DQogDQogLyoqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MmN1L21hYy5jIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTkyY3UvbWFjLmMNCmluZGV4IDA2MGEwNmYuLjU1MTUy
MTUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3J0bDgxOTJjdS9t
YWMuYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTkyY3UvbWFjLmMN
CkBAIC03ODIsNyArNzgyLDcgQEAgc3RhdGljIGxvbmcgX3J0bDkyY19zaWduYWxfc2NhbGVfbWFw
cGluZyhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywNCiANCiBzdGF0aWMgdm9pZCBfcnRsOTJjX3F1
ZXJ5X3J4cGh5c3RhdHVzKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KIAkJCQkgICAgICBzdHJ1
Y3QgcnRsX3N0YXRzICpwc3RhdHMsDQotCQkJCSAgICAgIHN0cnVjdCByeF9kZXNjXzkyYyAqcGRl
c2MsDQorCQkJCSAgICAgIHN0cnVjdCByeF9kZXNjXzkyYyAqcF9kZXNjLA0KIAkJCQkgICAgICBz
dHJ1Y3QgcnhfZndpbmZvXzkyYyAqcF9kcnZpbmZvLA0KIAkJCQkgICAgICBib29sIHBhY2tldF9t
YXRjaF9ic3NpZCwNCiAJCQkJICAgICAgYm9vbCBwYWNrZXRfdG9zZWxmLA0KQEAgLTc5NywxMSAr
Nzk3LDExIEBAIHN0YXRpYyB2b2lkIF9ydGw5MmNfcXVlcnlfcnhwaHlzdGF0dXMoc3RydWN0IGll
ZWU4MDIxMV9odyAqaHcsDQogCXUzMiByc3NpLCB0b3RhbF9yc3NpID0gMDsNCiAJYm9vbCBpbl9w
b3dlcnNhdmVtb2RlID0gZmFsc2U7DQogCWJvb2wgaXNfY2NrX3JhdGU7DQorCXU4ICpwZGVzYyA9
ICh1OCAqKXBfZGVzYzsNCiANCi0JaXNfY2NrX3JhdGUgPSBSWF9IQUxfSVNfQ0NLX1JBVEUocGRl
c2MpOw0KKwlpc19jY2tfcmF0ZSA9IFJYX0hBTF9JU19DQ0tfUkFURShwX2Rlc2MpOw0KIAlwc3Rh
dHMtPnBhY2tldF9tYXRjaGJzc2lkID0gcGFja2V0X21hdGNoX2Jzc2lkOw0KIAlwc3RhdHMtPnBh
Y2tldF90b3NlbGYgPSBwYWNrZXRfdG9zZWxmOw0KLQlwc3RhdHMtPmlzX2NjayA9IGlzX2Nja19y
YXRlOw0KIAlwc3RhdHMtPnBhY2tldF9iZWFjb24gPSBwYWNrZXRfYmVhY29uOw0KIAlwc3RhdHMt
PmlzX2NjayA9IGlzX2Nja19yYXRlOw0KIAlwc3RhdHMtPlJYX1NJR1FbMF0gPSAtMTsNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3J0bDgxOTJjdS90cnguYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MmN1L3RyeC5jDQppbmRleCBhN2UxYTJj
Li5hNmVhMmQ5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4
MTkyY3UvdHJ4LmMNCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MmN1
L3RyeC5jDQpAQCAtMzAzLDEwICszMDMsMTAgQEAgb3V0Og0KIGJvb2wgcnRsOTJjdV9yeF9xdWVy
eV9kZXNjKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KIAkJCSAgIHN0cnVjdCBydGxfc3RhdHMg
KnN0YXRzLA0KIAkJCSAgIHN0cnVjdCBpZWVlODAyMTFfcnhfc3RhdHVzICpyeF9zdGF0dXMsDQot
CQkJICAgdTggKnBfZGVzYywgc3RydWN0IHNrX2J1ZmYgKnNrYikNCisJCQkgICB1OCAqcGRlc2Ms
IHN0cnVjdCBza19idWZmICpza2IpDQogew0KIAlzdHJ1Y3QgcnhfZndpbmZvXzkyYyAqcF9kcnZp
bmZvOw0KLQlzdHJ1Y3QgcnhfZGVzY185MmMgKnBkZXNjID0gKHN0cnVjdCByeF9kZXNjXzkyYyAq
KXBfZGVzYzsNCisJc3RydWN0IHJ4X2Rlc2NfOTJjICpwX2Rlc2MgPSAoc3RydWN0IHJ4X2Rlc2Nf
OTJjICopcGRlc2M7DQogCXUzMiBwaHlzdGF0dXMgPSBHRVRfUlhfREVTQ19QSFlfU1RBVFVTKHBk
ZXNjKTsNCiANCiAJc3RhdHMtPmxlbmd0aCA9ICh1MTYpIEdFVF9SWF9ERVNDX1BLVF9MRU4ocGRl
c2MpOw0KQEAgLTM0NSwxMSArMzQ1LDExIEBAIGJvb2wgcnRsOTJjdV9yeF9xdWVyeV9kZXNjKHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KIAlpZiAocGh5c3RhdHVzKSB7DQogCQlwX2RydmluZm8g
PSAoc3RydWN0IHJ4X2Z3aW5mb185MmMgKikoc2tiLT5kYXRhICsNCiAJCQkJCQkgICAgIHN0YXRz
LT5yeF9idWZzaGlmdCk7DQotCQlydGw5MmNfdHJhbnNsYXRlX3J4X3NpZ25hbF9zdHVmZihodywg
c2tiLCBzdGF0cywgcGRlc2MsDQorCQlydGw5MmNfdHJhbnNsYXRlX3J4X3NpZ25hbF9zdHVmZiho
dywgc2tiLCBzdGF0cywgcF9kZXNjLA0KIAkJCQkJCSBwX2RydmluZm8pOw0KIAl9DQogCS8qcnhf
c3RhdHVzLT5xdWFsID0gc3RhdHMtPnNpZ25hbDsgKi8NCi0Jcnhfc3RhdHVzLT5zaWduYWwgPSBz
dGF0cy0+cnNzaSArIDEwOw0KKwlyeF9zdGF0dXMtPnNpZ25hbCA9IHN0YXRzLT5yZWN2c2lnbmFs
cG93ZXIgKyAxMDsNCiAJLypyeF9zdGF0dXMtPm5vaXNlID0gLXN0YXRzLT5ub2lzZTsgKi8NCiAJ
cmV0dXJuIHRydWU7DQogfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdp
ZmkvcnRsODE5MmRlL3RyeC5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTky
ZGUvdHJ4LmMNCmluZGV4IDM2MzdjMGMuLjYzOWI1N2IgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9ydGx3aWZpL3J0bDgxOTJkZS90cnguYw0KKysrIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvcnRsd2lmaS9ydGw4MTkyZGUvdHJ4LmMNCkBAIC01MjksNyArNTI5LDcgQEAgYm9vbCBy
dGw5MmRlX3J4X3F1ZXJ5X2Rlc2Moc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCXN0cnVjdCBydGxf
c3RhdHMgKnN0YXRzLA0KIAkJCQkJCSAgIHBfZHJ2aW5mbyk7DQogCX0NCiAJLypyeF9zdGF0dXMt
PnF1YWwgPSBzdGF0cy0+c2lnbmFsOyAqLw0KLQlyeF9zdGF0dXMtPnNpZ25hbCA9IHN0YXRzLT5y
c3NpICsgMTA7DQorCXJ4X3N0YXR1cy0+c2lnbmFsID0gc3RhdHMtPnJlY3ZzaWduYWxwb3dlciAr
IDEwOw0KIAkvKnJ4X3N0YXR1cy0+bm9pc2UgPSAtc3RhdHMtPm5vaXNlOyAqLw0KIAlyZXR1cm4g
dHJ1ZTsNCiB9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4
MTkyc2UvcmYuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MnNlL3JmLmMN
CmluZGV4IDBhZDUwZmUuLjEzMDgxZDkgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9ydGx3aWZpL3J0bDgxOTJzZS9yZi5jDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3
aWZpL3J0bDgxOTJzZS9yZi5jDQpAQCAtMjc0LDcgKzI3NCw3IEBAIHN0YXRpYyB2b2lkIF9ydGw5
MnNfZ2V0X3R4cG93ZXJfd3JpdGV2YWxfYnlyZWd1bGF0b3J5KHN0cnVjdCBpZWVlODAyMTFfaHcg
Kmh3LA0KIAkJCQkgICAgcnRsZWZ1c2UtPnB3cmdyb3VwX2h0NDANCiAJCQkJICAgIFtSRjkwX1BB
VEhfQV1bY2hubCAtIDFdKSB7DQogCQkJCQlwd3JkaWZmX2xpbWl0W2ldID0NCi0JCQkJCSAgcnRs
ZWZ1c2UtPnB3cmdyb3VwX2h0MjANCisJCQkJCSAgcnRsZWZ1c2UtPnB3cmdyb3VwX2h0NDANCiAJ
CQkJCSAgW1JGOTBfUEFUSF9BXVtjaG5sIC0gMV07DQogCQkJCX0NCiAJCQl9IGVsc2Ugew0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MnNlL3RyeC5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTkyc2UvdHJ4LmMNCmluZGV4IGZiZWJl
M2UuLjU0MmE4NzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3J0
bDgxOTJzZS90cnguYw0KKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9ydGw4MTky
c2UvdHJ4LmMNCkBAIC01ODIsNyArNTgyLDcgQEAgYm9vbCBydGw5MnNlX3J4X3F1ZXJ5X2Rlc2Mo
c3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBydGxfc3RhdHMgKnN0YXRzLA0KIAl9DQog
DQogCS8qcnhfc3RhdHVzLT5xdWFsID0gc3RhdHMtPnNpZ25hbDsgKi8NCi0Jcnhfc3RhdHVzLT5z
aWduYWwgPSBzdGF0cy0+cnNzaSArIDEwOw0KKwlyeF9zdGF0dXMtPnNpZ25hbCA9IHN0YXRzLT5y
ZWN2c2lnbmFscG93ZXIgKyAxMDsNCiAJLypyeF9zdGF0dXMtPm5vaXNlID0gLXN0YXRzLT5ub2lz
ZTsgKi8NCiANCiAJcmV0dXJuIHRydWU7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcnRsd2lmaS93aWZpLmggYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3dpZmkuaA0K
aW5kZXggODJiYWFhMi4uNTc2NGVmNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3J0bHdpZmkvd2lmaS5oDQorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3dpZmku
aA0KQEAgLTczLDExICs3Myw3IEBADQogI2RlZmluZSBSVExfU0xPVF9USU1FXzkJCQkJOQ0KICNk
ZWZpbmUgUlRMX1NMT1RfVElNRV8yMAkJCTIwDQogDQotLypyZWxhdGVkIHdpdGggdGNwL2lwLiAq
Lw0KLS8qaWZfZWh0aGVyLmgqLw0KLSNkZWZpbmUgRVRIX1BfUEFFCQkweDg4OEUJLypQb3J0IEFj
Y2VzcyBFbnRpdHkgKElFRUUgODAyLjFYKSAqLw0KLSNkZWZpbmUgRVRIX1BfSVAJCTB4MDgwMAkv
KkludGVybmV0IFByb3RvY29sIHBhY2tldCAqLw0KLSNkZWZpbmUgRVRIX1BfQVJQCQkweDA4MDYJ
LypBZGRyZXNzIFJlc29sdXRpb24gcGFja2V0ICovDQorLypyZWxhdGVkIHRvIHRjcC9pcC4gKi8N
CiAjZGVmaW5lIFNOQVBfU0laRQkJNg0KICNkZWZpbmUgUFJPVE9DX1RZUEVfU0laRQkyDQogDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kvcGNpZS9wb3J0ZHJ2X3BjaS5jIGIvZHJpdmVycy9wY2kv
cGNpZS9wb3J0ZHJ2X3BjaS5jDQppbmRleCBlMDYxMGJkLi43ZTQxYjcwIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9wY2kvcGNpZS9wb3J0ZHJ2X3BjaS5jDQorKysgYi9kcml2ZXJzL3BjaS9wY2llL3Bv
cnRkcnZfcGNpLmMNCkBAIC0xNTEsNyArMTUxLDYgQEAgc3RhdGljIGludCBfX2RldmluaXQgcGNp
ZV9wb3J0ZHJ2X3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpkZXYsDQogc3RhdGljIHZvaWQgcGNpZV9w
b3J0ZHJ2X3JlbW92ZShzdHJ1Y3QgcGNpX2RldiAqZGV2KQ0KIHsNCiAJcGNpZV9wb3J0X2Rldmlj
ZV9yZW1vdmUoZGV2KTsNCi0JcGNpX2Rpc2FibGVfZGV2aWNlKGRldik7DQogfQ0KIA0KIHN0YXRp
YyBpbnQgZXJyb3JfZGV0ZWN0ZWRfaXRlcihzdHJ1Y3QgZGV2aWNlICpkZXZpY2UsIHZvaWQgKmRh
dGEpDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ydGMvcnRjLWF0OTFybTkyMDAuYyBiL2RyaXZlcnMv
cnRjL3J0Yy1hdDkxcm05MjAwLmMNCmluZGV4IGUzOWI3N2EuLjE1NDA2ZDUgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3J0Yy9ydGMtYXQ5MXJtOTIwMC5jDQorKysgYi9kcml2ZXJzL3J0Yy9ydGMtYXQ5
MXJtOTIwMC5jDQpAQCAtMTU2LDYgKzE1Niw4IEBAIHN0YXRpYyBpbnQgYXQ5MV9ydGNfc2V0YWxh
cm0oc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgcnRjX3drYWxybSAqYWxybSkNCiANCiAJYXQ5
MV9hbGFybV95ZWFyID0gdG0udG1feWVhcjsNCiANCisJdG0udG1fbW9uID0gYWxybS0+dGltZS50
bV9tb247DQorCXRtLnRtX21kYXkgPSBhbHJtLT50aW1lLnRtX21kYXk7DQogCXRtLnRtX2hvdXIg
PSBhbHJtLT50aW1lLnRtX2hvdXI7DQogCXRtLnRtX21pbiA9IGFscm0tPnRpbWUudG1fbWluOw0K
IAl0bS50bV9zZWMgPSBhbHJtLT50aW1lLnRtX3NlYzsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Mz
OTAvbmV0L3FldGhfY29yZV9tYWluLmMgYi9kcml2ZXJzL3MzOTAvbmV0L3FldGhfY29yZV9tYWlu
LmMNCmluZGV4IGZmZjU3ZGUuLjU1ZjY0ODggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3MzOTAvbmV0
L3FldGhfY29yZV9tYWluLmMNCisrKyBiL2RyaXZlcnMvczM5MC9uZXQvcWV0aF9jb3JlX21haW4u
Yw0KQEAgLTQzMjIsNyArNDMyMiw3IEBAIGludCBxZXRoX3NubXBfY29tbWFuZChzdHJ1Y3QgcWV0
aF9jYXJkICpjYXJkLCBjaGFyIF9fdXNlciAqdWRhdGEpDQogCXN0cnVjdCBxZXRoX2NtZF9idWZm
ZXIgKmlvYjsNCiAJc3RydWN0IHFldGhfaXBhX2NtZCAqY21kOw0KIAlzdHJ1Y3QgcWV0aF9zbm1w
X3VyZXEgKnVyZXE7DQotCWludCByZXFfbGVuOw0KKwl1bnNpZ25lZCBpbnQgcmVxX2xlbjsNCiAJ
c3RydWN0IHFldGhfYXJwX3F1ZXJ5X2luZm8gcWluZm8gPSB7MCwgfTsNCiAJaW50IHJjID0gMDsN
CiANCkBAIC00MzM4LDYgKzQzMzgsMTAgQEAgaW50IHFldGhfc25tcF9jb21tYW5kKHN0cnVjdCBx
ZXRoX2NhcmQgKmNhcmQsIGNoYXIgX191c2VyICp1ZGF0YSkNCiAJLyogc2tpcCA0IGJ5dGVzIChk
YXRhX2xlbiBzdHJ1Y3QgbWVtYmVyKSB0byBnZXQgcmVxX2xlbiAqLw0KIAlpZiAoY29weV9mcm9t
X3VzZXIoJnJlcV9sZW4sIHVkYXRhICsgc2l6ZW9mKGludCksIHNpemVvZihpbnQpKSkNCiAJCXJl
dHVybiAtRUZBVUxUOw0KKwlpZiAocmVxX2xlbiA+IChRRVRIX0JVRlNJWkUgLSBJUEFfUERVX0hF
QURFUl9TSVpFIC0NCisJCSAgICAgICBzaXplb2Yoc3RydWN0IHFldGhfaXBhY21kX2hkcikgLQ0K
KwkJICAgICAgIHNpemVvZihzdHJ1Y3QgcWV0aF9pcGFjbWRfc2V0YWRwcGFybXNfaGRyKSkpDQor
CQlyZXR1cm4gLUVJTlZBTDsNCiAJdXJlcSA9IG1lbWR1cF91c2VyKHVkYXRhLCByZXFfbGVuICsg
c2l6ZW9mKHN0cnVjdCBxZXRoX3NubXBfdXJlcV9oZHIpKTsNCiAJaWYgKElTX0VSUih1cmVxKSkg
ew0KIAkJUUVUSF9DQVJEX1RFWFQoY2FyZCwgMiwgInNubXBub21lIik7DQpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zY3NpL2FhY3JhaWQvY29tbWN0cmwuYyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2Nv
bW1jdHJsLmMNCmluZGV4IDhhMGIzMzAuLjEyNTQ0MzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Nj
c2kvYWFjcmFpZC9jb21tY3RybC5jDQorKysgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tY3Ry
bC5jDQpAQCAtNTA4LDcgKzUwOCw4IEBAIHN0YXRpYyBpbnQgYWFjX3NlbmRfcmF3X3NyYihzdHJ1
Y3QgYWFjX2RldiogZGV2LCB2b2lkIF9fdXNlciAqIGFyZykNCiAJCWdvdG8gY2xlYW51cDsNCiAJ
fQ0KIA0KLQlpZiAoZmlic2l6ZSA+IChkZXYtPm1heF9maWJfc2l6ZSAtIHNpemVvZihzdHJ1Y3Qg
YWFjX2ZpYmhkcikpKSB7DQorCWlmICgoZmlic2l6ZSA8IChzaXplb2Yoc3RydWN0IHVzZXJfYWFj
X3NyYikgLSBzaXplb2Yoc3RydWN0IHVzZXJfc2dlbnRyeSkpKSB8fA0KKwkgICAgKGZpYnNpemUg
PiAoZGV2LT5tYXhfZmliX3NpemUgLSBzaXplb2Yoc3RydWN0IGFhY19maWJoZHIpKSkpIHsNCiAJ
CXJjb2RlID0gLUVJTlZBTDsNCiAJCWdvdG8gY2xlYW51cDsNCiAJfQ0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS9ocHNhLmMgYi9kcml2ZXJzL3Njc2kvaHBzYS5jDQppbmRleCAwZjQ4NTUwLi41
YjdlMWJmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL2hwc2EuYw0KKysrIGIvZHJpdmVycy9z
Y3NpL2hwc2EuYw0KQEAgLTExODYsNyArMTE4Niw3IEBAIHN0YXRpYyB2b2lkIGNvbXBsZXRlX3Nj
c2lfY29tbWFuZChzdHJ1Y3QgQ29tbWFuZExpc3QgKmNwKQ0KIAkJCQkJImhhcyBjaGVjayBjb25k
aXRpb246IGFib3J0ZWQgY29tbWFuZDogIg0KIAkJCQkJIkFTQzogMHgleCwgQVNDUTogMHgleFxu
IiwNCiAJCQkJCWNwLCBhc2MsIGFzY3EpOw0KLQkJCQljbWQtPnJlc3VsdCA9IERJRF9TT0ZUX0VS
Uk9SIDw8IDE2Ow0KKwkJCQljbWQtPnJlc3VsdCB8PSBESURfU09GVF9FUlJPUiA8PCAxNjsNCiAJ
CQkJYnJlYWs7DQogCQkJfQ0KIAkJCS8qIE11c3QgYmUgc29tZSBvdGhlciB0eXBlIG9mIGNoZWNr
IGNvbmRpdGlvbiAqLw0KQEAgLTQ0NjUsNyArNDQ2NSw3IEBAIHJlaW5pdF9hZnRlcl9zb2Z0X3Jl
c2V0Og0KIAlocHNhX2hiYV9pbnF1aXJ5KGgpOw0KIAlocHNhX3JlZ2lzdGVyX3Njc2koaCk7CS8q
IGhvb2sgb3Vyc2VsdmVzIGludG8gU0NTSSBzdWJzeXN0ZW0gKi8NCiAJc3RhcnRfY29udHJvbGxl
cl9sb2NrdXBfZGV0ZWN0b3IoaCk7DQotCXJldHVybiAxOw0KKwlyZXR1cm4gMDsNCiANCiBjbGVh
bjQ6DQogCWhwc2FfZnJlZV9zZ19jaGFpbl9ibG9ja3MoaCk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL2xpYnNhcy9zYXNfYXRhLmMgYi9kcml2ZXJzL3Njc2kvbGlic2FzL3Nhc19hdGEuYw0K
aW5kZXggNDg2OGZjOS4uNWUxNzBlMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9saWJzYXMv
c2FzX2F0YS5jDQorKysgYi9kcml2ZXJzL3Njc2kvbGlic2FzL3Nhc19hdGEuYw0KQEAgLTE5Nyw3
ICsxOTcsNyBAQCBzdGF0aWMgdW5zaWduZWQgaW50IHNhc19hdGFfcWNfaXNzdWUoc3RydWN0IGF0
YV9xdWV1ZWRfY21kICpxYykNCiAJCXFjLT50Zi5uc2VjdCA9IDA7DQogCX0NCiANCi0JYXRhX3Rm
X3RvX2ZpcygmcWMtPnRmLCAxLCAwLCAodTgqKSZ0YXNrLT5hdGFfdGFzay5maXMpOw0KKwlhdGFf
dGZfdG9fZmlzKCZxYy0+dGYsIHFjLT5kZXYtPmxpbmstPnBtcCwgMSwgKHU4ICopJnRhc2stPmF0
YV90YXNrLmZpcyk7DQogCXRhc2stPnVsZGRfdGFzayA9IHFjOw0KIAlpZiAoYXRhX2lzX2F0YXBp
KHFjLT50Zi5wcm90b2NvbCkpIHsNCiAJCW1lbWNweSh0YXNrLT5hdGFfdGFzay5hdGFwaV9wYWNr
ZXQsIHFjLT5jZGIsIHFjLT5kZXYtPmNkYl9sZW4pOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy90aWRzcGJyaWRnZS9LY29uZmlnIGIvZHJpdmVycy9zdGFnaW5nL3RpZHNwYnJpZGdlL0tj
b25maWcNCmluZGV4IDkzZGU0ZjIuLmIyN2Q5YWEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvdGlkc3BicmlkZ2UvS2NvbmZpZw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3RpZHNwYnJpZGdl
L0tjb25maWcNCkBAIC00LDcgKzQsNyBAQA0KIA0KIG1lbnVjb25maWcgVElEU1BCUklER0UNCiAJ
dHJpc3RhdGUgIkRTUCBCcmlkZ2UgZHJpdmVyIg0KLQlkZXBlbmRzIG9uIEFSQ0hfT01BUDMNCisJ
ZGVwZW5kcyBvbiBBUkNIX09NQVAzICYmIEJST0tFTg0KIAlzZWxlY3QgT01BUF9NQk9YX0ZXSw0K
IAloZWxwDQogCSAgRFNQL0JJT1MgQnJpZGdlIGlzIGRlc2lnbmVkIGZvciBwbGF0Zm9ybXMgdGhh
dCBjb250YWluIGEgR1BQIGFuZA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy96cmFtL3py
YW1fc3lzZnMuYyBiL2RyaXZlcnMvc3RhZ2luZy96cmFtL3pyYW1fc3lzZnMuYw0KaW5kZXggMWZh
ZTFlOS4uZmM1NTJkOCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy96cmFtL3pyYW1fc3lz
ZnMuYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3pyYW0venJhbV9zeXNmcy5jDQpAQCAtOTUsMjAg
Kzk1LDI3IEBAIHN0YXRpYyBzc2l6ZV90IHJlc2V0X3N0b3JlKHN0cnVjdCBkZXZpY2UgKmRldiwN
CiAJenJhbSA9IGRldl90b196cmFtKGRldik7DQogCWJkZXYgPSBiZGdldF9kaXNrKHpyYW0tPmRp
c2ssIDApOw0KIA0KKwlpZiAoIWJkZXYpDQorCQlyZXR1cm4gLUVOT01FTTsNCisNCiAJLyogRG8g
bm90IHJlc2V0IGFuIGFjdGl2ZSBkZXZpY2UhICovDQotCWlmIChiZGV2LT5iZF9ob2xkZXJzKQ0K
LQkJcmV0dXJuIC1FQlVTWTsNCisJaWYgKGJkZXYtPmJkX2hvbGRlcnMpIHsNCisJCXJldCA9IC1F
QlVTWTsNCisJCWdvdG8gb3V0Ow0KKwl9DQogDQogCXJldCA9IHN0cmljdF9zdHJ0b3VsKGJ1Ziwg
MTAsICZkb19yZXNldCk7DQogCWlmIChyZXQpDQotCQlyZXR1cm4gcmV0Ow0KKwkJZ290byBvdXQ7
DQogDQotCWlmICghZG9fcmVzZXQpDQotCQlyZXR1cm4gLUVJTlZBTDsNCisJaWYgKCFkb19yZXNl
dCkgew0KKwkJcmV0ID0gLUVJTlZBTDsNCisJCWdvdG8gb3V0Ow0KKwl9DQogDQogCS8qIE1ha2Ug
c3VyZSBhbGwgcGVuZGluZyBJL08gaXMgZmluaXNoZWQgKi8NCi0JaWYgKGJkZXYpDQotCQlmc3lu
Y19iZGV2KGJkZXYpOw0KKwlmc3luY19iZGV2KGJkZXYpOw0KKwliZHB1dChiZGV2KTsNCiANCiAJ
ZG93bl93cml0ZSgmenJhbS0+aW5pdF9sb2NrKTsNCiAJaWYgKHpyYW0tPmluaXRfZG9uZSkNCkBA
IC0xMTYsNiArMTIzLDEwIEBAIHN0YXRpYyBzc2l6ZV90IHJlc2V0X3N0b3JlKHN0cnVjdCBkZXZp
Y2UgKmRldiwNCiAJdXBfd3JpdGUoJnpyYW0tPmluaXRfbG9jayk7DQogDQogCXJldHVybiBsZW47
DQorDQorb3V0Og0KKwliZHB1dChiZGV2KTsNCisJcmV0dXJuIHJldDsNCiB9DQogDQogc3RhdGlj
IHNzaXplX3QgbnVtX3JlYWRzX3Nob3coc3RydWN0IGRldmljZSAqZGV2LA0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldF9hdXRoLmMgYi9kcml2ZXJzL3Rhcmdl
dC9pc2NzaS9pc2NzaV90YXJnZXRfYXV0aC5jDQppbmRleCAxY2Q2Y2UzLi41OWU3Mzc4IDEwMDY0
NA0KLS0tIGEvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X2F1dGguYw0KKysrIGIv
ZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X2F1dGguYw0KQEAgLTE3Miw2ICsxNzIs
NyBAQCBzdGF0aWMgaW50IGNoYXBfc2VydmVyX2NvbXB1dGVfbWQ1KA0KIAl1bnNpZ25lZCBjaGFy
IGNsaWVudF9kaWdlc3RbTUQ1X1NJR05BVFVSRV9TSVpFXTsNCiAJdW5zaWduZWQgY2hhciBzZXJ2
ZXJfZGlnZXN0W01ENV9TSUdOQVRVUkVfU0laRV07DQogCXVuc2lnbmVkIGNoYXIgY2hhcF9uW01B
WF9DSEFQX05fU0laRV0sIGNoYXBfcltNQVhfUkVTUE9OU0VfTEVOR1RIXTsNCisJc2l6ZV90IGNv
bXBhcmVfbGVuOw0KIAlzdHJ1Y3QgaXNjc2lfY2hhcCAqY2hhcCA9IChzdHJ1Y3QgaXNjc2lfY2hh
cCAqKSBjb25uLT5hdXRoX3Byb3RvY29sOw0KIAlzdHJ1Y3QgY3J5cHRvX2hhc2ggKnRmbTsNCiAJ
c3RydWN0IGhhc2hfZGVzYyBkZXNjOw0KQEAgLTIxMCw3ICsyMTEsOSBAQCBzdGF0aWMgaW50IGNo
YXBfc2VydmVyX2NvbXB1dGVfbWQ1KA0KIAkJZ290byBvdXQ7DQogCX0NCiANCi0JaWYgKG1lbWNt
cChjaGFwX24sIGF1dGgtPnVzZXJpZCwgc3RybGVuKGF1dGgtPnVzZXJpZCkpICE9IDApIHsNCisJ
LyogSW5jbHVkZSB0aGUgdGVybWluYXRpbmcgTlVMTCBpbiB0aGUgY29tcGFyZSAqLw0KKwljb21w
YXJlX2xlbiA9IHN0cmxlbihhdXRoLT51c2VyaWQpICsgMTsNCisJaWYgKHN0cm5jbXAoY2hhcF9u
LCBhdXRoLT51c2VyaWQsIGNvbXBhcmVfbGVuKSAhPSAwKSB7DQogCQlwcl9lcnIoIkNIQVBfTiB2
YWx1ZXMgZG8gbm90IG1hdGNoIVxuIik7DQogCQlnb3RvIG91dDsNCiAJfQ0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldF9uZWdvLmMgYi9kcml2ZXJzL3Rhcmdl
dC9pc2NzaS9pc2NzaV90YXJnZXRfbmVnby5jDQppbmRleCA3ZDg1Zjg4Li4zNDg2ZDEyIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X25lZ28uYw0KKysrIGIv
ZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X25lZ28uYw0KQEAgLTg5LDcgKzg5LDcg
QEAgaW50IGV4dHJhY3RfcGFyYW0oDQogCWlmIChsZW4gPCAwKQ0KIAkJcmV0dXJuIC0xOw0KIA0K
LQlpZiAobGVuID4gbWF4X2xlbmd0aCkgew0KKwlpZiAobGVuID49IG1heF9sZW5ndGgpIHsNCiAJ
CXByX2VycigiTGVuZ3RoIG9mIGlucHV0OiAlZCBleGVlZHMgbWF4X2xlbmd0aDoiDQogCQkJIiAl
ZFxuIiwgbGVuLCBtYXhfbGVuZ3RoKTsNCiAJCXJldHVybiAtMTsNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3VzYi9jbGFzcy9jZGMtYWNtLmMgYi9kcml2ZXJzL3VzYi9jbGFzcy9jZGMtYWNtLmMNCmlu
ZGV4IDBjZGZmMzguLjYzNmVlOWUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9jbGFzcy9jZGMt
YWNtLmMNCisrKyBiL2RyaXZlcnMvdXNiL2NsYXNzL2NkYy1hY20uYw0KQEAgLTE0NDgsNiArMTQ0
OCw4IEBAIHN0YXRpYyBpbnQgYWNtX3Jlc2V0X3Jlc3VtZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAq
aW50ZikNCiANCiBzdGF0aWMgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQgYWNtX2lkc1tdID0g
ew0KIAkvKiBxdWlya3kgYW5kIGJyb2tlbiBkZXZpY2VzICovDQorCXsgVVNCX0RFVklDRSgweDE3
ZWYsIDB4NzAwMCksIC8qIExlbm92byBVU0IgbW9kZW0gKi8NCisJLmRyaXZlcl9pbmZvID0gTk9f
VU5JT05fTk9STUFMLCB9LC8qIGhhcyBubyB1bmlvbiBkZXNjcmlwdG9yICovDQogCXsgVVNCX0RF
VklDRSgweDA4NzAsIDB4MDAwMSksIC8qIE1ldHJpY29tIEdTIE1vZGVtICovDQogCS5kcml2ZXJf
aW5mbyA9IE5PX1VOSU9OX05PUk1BTCwgLyogaGFzIG5vIHVuaW9uIGRlc2NyaXB0b3IgKi8NCiAJ
fSwNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9jb3JlL2h1Yi5jIGIvZHJpdmVycy91c2IvY29y
ZS9odWIuYw0KaW5kZXggYTVlYTg1Zi4uNzAxMzE2NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNi
L2NvcmUvaHViLmMNCisrKyBiL2RyaXZlcnMvdXNiL2NvcmUvaHViLmMNCkBAIC05MDAsNiArOTAw
LDExIEBAIHN0YXRpYyB2b2lkIGh1Yl9hY3RpdmF0ZShzdHJ1Y3QgdXNiX2h1YiAqaHViLCBlbnVt
IGh1Yl9hY3RpdmF0aW9uX3R5cGUgdHlwZSkNCiAJCQljbGVhcl9wb3J0X2ZlYXR1cmUoaHViLT5o
ZGV2LCBwb3J0MSwNCiAJCQkJCVVTQl9QT1JUX0ZFQVRfQ19QT1JUX0xJTktfU1RBVEUpOw0KIAkJ
fQ0KKwkJaWYgKHBvcnRjaGFuZ2UgJiBVU0JfUE9SVF9TVEFUX0NfUkVTRVQpIHsNCisJCQluZWVk
X2RlYm91bmNlX2RlbGF5ID0gdHJ1ZTsNCisJCQljbGVhcl9wb3J0X2ZlYXR1cmUoaHViLT5oZGV2
LCBwb3J0MSwNCisJCQkJCVVTQl9QT1JUX0ZFQVRfQ19SRVNFVCk7DQorCQl9DQogDQogCQlpZiAo
KHBvcnRjaGFuZ2UgJiBVU0JfUE9SVF9TVEFUX0NfQkhfUkVTRVQpICYmDQogCQkJCWh1Yl9pc19z
dXBlcnNwZWVkKGh1Yi0+aGRldikpIHsNCkBAIC0zNzQ5LDggKzM3NTQsOSBAQCBzdGF0aWMgdm9p
ZCBodWJfZXZlbnRzKHZvaWQpDQogCQkJCQlodWItPmhkZXYtPmNoaWxkcmVuW2kgLSAxXTsNCiAN
CiAJCQkJZGV2X2RiZyhodWJfZGV2LCAid2FybSByZXNldCBwb3J0ICVkXG4iLCBpKTsNCi0JCQkJ
aWYgKCF1ZGV2IHx8ICEocG9ydHN0YXR1cyAmDQotCQkJCQkJVVNCX1BPUlRfU1RBVF9DT05ORUNU
SU9OKSkgew0KKwkJCQlpZiAoIXVkZXYgfHwNCisJCQkJICAgICEocG9ydHN0YXR1cyAmIFVTQl9Q
T1JUX1NUQVRfQ09OTkVDVElPTikgfHwNCisJCQkJICAgIHVkZXYtPnN0YXRlID09IFVTQl9TVEFU
RV9OT1RBVFRBQ0hFRCkgew0KIAkJCQkJc3RhdHVzID0gaHViX3BvcnRfcmVzZXQoaHViLCBpLA0K
IAkJCQkJCQlOVUxMLCBIVUJfQkhfUkVTRVRfVElNRSwNCiAJCQkJCQkJdHJ1ZSk7DQpAQCAtNDAx
OCw2ICs0MDI0LDEyIEBAIHN0YXRpYyBpbnQgdXNiX3Jlc2V0X2FuZF92ZXJpZnlfZGV2aWNlKHN0
cnVjdCB1c2JfZGV2aWNlICp1ZGV2KQ0KIAl9DQogCXBhcmVudF9odWIgPSBoZGV2X3RvX2h1Yihw
YXJlbnRfaGRldik7DQogDQorCS8qIERpc2FibGUgVVNCMiBoYXJkd2FyZSBMUE0uDQorCSAqIEl0
IHdpbGwgYmUgcmUtZW5hYmxlZCBieSB0aGUgZW51bWVyYXRpb24gcHJvY2Vzcy4NCisJICovDQor
CWlmICh1ZGV2LT51c2IyX2h3X2xwbV9lbmFibGVkID09IDEpDQorCQl1c2Jfc2V0X3VzYjJfaGFy
ZHdhcmVfbHBtKHVkZXYsIDApOw0KKw0KIAlzZXRfYml0KHBvcnQxLCBwYXJlbnRfaHViLT5idXN5
X2JpdHMpOw0KIAlmb3IgKGkgPSAwOyBpIDwgU0VUX0NPTkZJR19UUklFUzsgKytpKSB7DQogDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZHdjMy9lcDAuYyBiL2RyaXZlcnMvdXNiL2R3YzMvZXAw
LmMNCmluZGV4IGMwZGNmNjkuLmM0MTM0ZTggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9kd2Mz
L2VwMC5jDQorKysgYi9kcml2ZXJzL3VzYi9kd2MzL2VwMC5jDQpAQCAtMzk0LDYgKzM5NCw4IEBA
IHN0YXRpYyBpbnQgZHdjM19lcDBfaGFuZGxlX2ZlYXR1cmUoc3RydWN0IGR3YzMgKmR3YywNCiAJ
CQlkZXAgPSAgZHdjM193SW5kZXhfdG9fZGVwKGR3YywgY3RybC0+d0luZGV4KTsNCiAJCQlpZiAo
IWRlcCkNCiAJCQkJcmV0dXJuIC1FSU5WQUw7DQorCQkJaWYgKHNldCA9PSAwICYmIChkZXAtPmZs
YWdzICYgRFdDM19FUF9XRURHRSkpDQorCQkJCWJyZWFrOw0KIAkJCXJldCA9IF9fZHdjM19nYWRn
ZXRfZXBfc2V0X2hhbHQoZGVwLCBzZXQpOw0KIAkJCWlmIChyZXQpDQogCQkJCXJldHVybiAtRUlO
VkFMOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMgYi9kcml2ZXJzL3Vz
Yi9kd2MzL2dhZGdldC5jDQppbmRleCA2MTllZTE5Li41ZjJlM2QwIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy91c2IvZHdjMy9nYWRnZXQuYw0KKysrIGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0K
QEAgLTkwMyw5ICs5MDMsNiBAQCBpbnQgX19kd2MzX2dhZGdldF9lcF9zZXRfaGFsdChzdHJ1Y3Qg
ZHdjM19lcCAqZGVwLCBpbnQgdmFsdWUpDQogCQllbHNlDQogCQkJZGVwLT5mbGFncyB8PSBEV0Mz
X0VQX1NUQUxMOw0KIAl9IGVsc2Ugew0KLQkJaWYgKGRlcC0+ZmxhZ3MgJiBEV0MzX0VQX1dFREdF
KQ0KLQkJCXJldHVybiAwOw0KLQ0KIAkJcmV0ID0gZHdjM19zZW5kX2dhZGdldF9lcF9jbWQoZHdj
LCBkZXAtPm51bWJlciwNCiAJCQlEV0MzX0RFUENNRF9DTEVBUlNUQUxMLCAmcGFyYW1zKTsNCiAJ
CWlmIChyZXQpDQpAQCAtOTEzLDcgKzkxMCw3IEBAIGludCBfX2R3YzNfZ2FkZ2V0X2VwX3NldF9o
YWx0KHN0cnVjdCBkd2MzX2VwICpkZXAsIGludCB2YWx1ZSkNCiAJCQkJCXZhbHVlID8gInNldCIg
OiAiY2xlYXIiLA0KIAkJCQkJZGVwLT5uYW1lKTsNCiAJCWVsc2UNCi0JCQlkZXAtPmZsYWdzICY9
IH5EV0MzX0VQX1NUQUxMOw0KKwkJCWRlcC0+ZmxhZ3MgJj0gfihEV0MzX0VQX1NUQUxMIHwgRFdD
M19FUF9XRURHRSk7DQogCX0NCiANCiAJcmV0dXJuIHJldDsNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3VzYi9nYWRnZXQvY29tcG9zaXRlLmMgYi9kcml2ZXJzL3VzYi9nYWRnZXQvY29tcG9zaXRlLmMN
CmluZGV4IGY3MWIwNzguLjQ0ODRlZjEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9nYWRnZXQv
Y29tcG9zaXRlLmMNCisrKyBiL2RyaXZlcnMvdXNiL2dhZGdldC9jb21wb3NpdGUuYw0KQEAgLTU4
NSw2ICs1ODUsNyBAQCBzdGF0aWMgdm9pZCByZXNldF9jb25maWcoc3RydWN0IHVzYl9jb21wb3Np
dGVfZGV2ICpjZGV2KQ0KIAkJYml0bWFwX3plcm8oZi0+ZW5kcG9pbnRzLCAzMik7DQogCX0NCiAJ
Y2Rldi0+Y29uZmlnID0gTlVMTDsNCisJY2Rldi0+ZGVsYXllZF9zdGF0dXMgPSAwOw0KIH0NCiAN
CiBzdGF0aWMgaW50IHNldF9jb25maWcoc3RydWN0IHVzYl9jb21wb3NpdGVfZGV2ICpjZGV2LA0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npby5jIGIvZHJpdmVycy91c2Iv
c2VyaWFsL2Z0ZGlfc2lvLmMNCmluZGV4IGEzZjZmZTAuLjg1NTA0YmIgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW8uYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL2Z0
ZGlfc2lvLmMNCkBAIC0yMTkyLDYgKzIxOTIsMjAgQEAgc3RhdGljIHZvaWQgZnRkaV9zZXRfdGVy
bWlvcyhzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5LA0KIAkJdGVybWlvcy0+Y19jZmxhZyB8PSBDUlRT
Q1RTOw0KIAl9DQogDQorCS8qDQorCSAqIEFsbCBGVERJIFVBUlQgY2hpcHMgYXJlIGxpbWl0ZWQg
dG8gQ1M3LzguIFdlIHdvbid0IHByZXRlbmQgdG8NCisJICogc3VwcG9ydCBDUzUvNiBhbmQgcmV2
ZXJ0IHRoZSBDU0laRSBzZXR0aW5nIGluc3RlYWQuDQorCSAqLw0KKwlpZiAoKENfQ1NJWkUodHR5
KSAhPSBDUzgpICYmIChDX0NTSVpFKHR0eSkgIT0gQ1M3KSkgew0KKwkJZGV2X3dhcm4oJnBvcnQt
PmRldiwgInJlcXVlc3RlZCBDU0laRSBzZXR0aW5nIG5vdCBzdXBwb3J0ZWRcbiIpOw0KKw0KKwkJ
dGVybWlvcy0+Y19jZmxhZyAmPSB+Q1NJWkU7DQorCQlpZiAob2xkX3Rlcm1pb3MpDQorCQkJdGVy
bWlvcy0+Y19jZmxhZyB8PSBvbGRfdGVybWlvcy0+Y19jZmxhZyAmIENTSVpFOw0KKwkJZWxzZQ0K
KwkJCXRlcm1pb3MtPmNfY2ZsYWcgfD0gQ1M4Ow0KKwl9DQorDQogCWNmbGFnID0gdGVybWlvcy0+
Y19jZmxhZzsNCiANCiAJaWYgKCFvbGRfdGVybWlvcykNCkBAIC0yMjI4LDEzICsyMjQyLDE2IEBA
IG5vX3NraXA6DQogCX0gZWxzZSB7DQogCQl1cmJfdmFsdWUgfD0gRlRESV9TSU9fU0VUX0RBVEFf
UEFSSVRZX05PTkU7DQogCX0NCi0JaWYgKGNmbGFnICYgQ1NJWkUpIHsNCi0JCXN3aXRjaCAoY2Zs
YWcgJiBDU0laRSkgew0KLQkJY2FzZSBDUzc6IHVyYl92YWx1ZSB8PSA3OyBkYmcoIlNldHRpbmcg
Q1M3Iik7IGJyZWFrOw0KLQkJY2FzZSBDUzg6IHVyYl92YWx1ZSB8PSA4OyBkYmcoIlNldHRpbmcg
Q1M4Iik7IGJyZWFrOw0KLQkJZGVmYXVsdDoNCi0JCQlkZXZfZXJyKCZwb3J0LT5kZXYsICJDU0la
RSB3YXMgc2V0IGJ1dCBub3QgQ1M3LUNTOFxuIik7DQotCQl9DQorCXN3aXRjaCAoY2ZsYWcgJiBD
U0laRSkgew0KKwljYXNlIENTNzoNCisJCXVyYl92YWx1ZSB8PSA3Ow0KKwkJZGV2X2RiZygmcG9y
dC0+ZGV2LCAiU2V0dGluZyBDUzdcbiIpOw0KKwkJYnJlYWs7DQorCWRlZmF1bHQ6DQorCWNhc2Ug
Q1M4Og0KKwkJdXJiX3ZhbHVlIHw9IDg7DQorCQlkZXZfZGJnKCZwb3J0LT5kZXYsICJTZXR0aW5n
IENTOFxuIik7DQorCQlicmVhazsNCiAJfQ0KIA0KIAkvKiBUaGlzIGlzIG5lZWRlZCBieSB0aGUg
YnJlYWsgY29tbWFuZCBzaW5jZSBpdCB1c2VzIHRoZSBzYW1lIGNvbW1hbmQNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3VzYi9zZXJpYWwvZ2VuZXJpYy5jIGIvZHJpdmVycy91c2Ivc2VyaWFsL2dlbmVy
aWMuYw0KaW5kZXggOWYwYjJiZi4uYzBlNjQ4NiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3Nl
cmlhbC9nZW5lcmljLmMNCisrKyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9nZW5lcmljLmMNCkBAIC0y
MjgsMTQgKzIyOCw3IEBAIHJldHJ5Og0KIAkJcmV0dXJuIHJlc3VsdDsNCiAJfQ0KIA0KLQkvKiBU
cnkgc2VuZGluZyBvZmYgYW5vdGhlciB1cmIsIHVubGVzcyBpbiBpcnEgY29udGV4dCAoaW4gd2hp
Y2ggY2FzZQ0KLQkgKiB0aGVyZSB3aWxsIGJlIG5vIGZyZWUgdXJiKS4gKi8NCi0JaWYgKCFpbl9p
cnEoKSkNCi0JCWdvdG8gcmV0cnk7DQotDQotCWNsZWFyX2JpdF91bmxvY2soVVNCX1NFUklBTF9X
UklURV9CVVNZLCAmcG9ydC0+ZmxhZ3MpOw0KLQ0KLQlyZXR1cm4gMDsNCisJZ290byByZXRyeTsJ
LyogdHJ5IHNlbmRpbmcgb2ZmIGFub3RoZXIgdXJiICovDQogfQ0KIA0KIC8qKg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdXNiL3NlcmlhbC9tb3M3ODQwLmMgYi9kcml2ZXJzL3VzYi9zZXJpYWwvbW9z
Nzg0MC5jDQppbmRleCA1ZDI1MDFlLi44MGZjNDBhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Iv
c2VyaWFsL21vczc4NDAuYw0KKysrIGIvZHJpdmVycy91c2Ivc2VyaWFsL21vczc4NDAuYw0KQEAg
LTE2ODksNyArMTY4OSwxMSBAQCBzdGF0aWMgaW50IG1vczc4NDBfdGlvY21nZXQoc3RydWN0IHR0
eV9zdHJ1Y3QgKnR0eSkNCiAJCXJldHVybiAtRU5PREVWOw0KIA0KIAlzdGF0dXMgPSBtb3M3ODQw
X2dldF91YXJ0X3JlZyhwb3J0LCBNT0RFTV9TVEFUVVNfUkVHSVNURVIsICZtc3IpOw0KKwlpZiAo
c3RhdHVzICE9IDEpDQorCQlyZXR1cm4gLUVJTzsNCiAJc3RhdHVzID0gbW9zNzg0MF9nZXRfdWFy
dF9yZWcocG9ydCwgTU9ERU1fQ09OVFJPTF9SRUdJU1RFUiwgJm1jcik7DQorCWlmIChzdGF0dXMg
IT0gMSkNCisJCXJldHVybiAtRUlPOw0KIAlyZXN1bHQgPSAoKG1jciAmIE1DUl9EVFIpID8gVElP
Q01fRFRSIDogMCkNCiAJICAgIHwgKChtY3IgJiBNQ1JfUlRTKSA/IFRJT0NNX1JUUyA6IDApDQog
CSAgICB8ICgobWNyICYgTUNSX0xPT1BCQUNLKSA/IFRJT0NNX0xPT1AgOiAwKQ0KQEAgLTE5ODMs
MjUgKzE5ODcsMjUgQEAgc3RhdGljIHZvaWQgbW9zNzg0MF9jaGFuZ2VfcG9ydF9zZXR0aW5ncyhz
dHJ1Y3QgdHR5X3N0cnVjdCAqdHR5LA0KIAlpZmxhZyA9IHR0eS0+dGVybWlvcy0+Y19pZmxhZzsN
CiANCiAJLyogQ2hhbmdlIHRoZSBudW1iZXIgb2YgYml0cyAqLw0KLQlpZiAoY2ZsYWcgJiBDU0la
RSkgew0KLQkJc3dpdGNoIChjZmxhZyAmIENTSVpFKSB7DQotCQljYXNlIENTNToNCi0JCQlsRGF0
YSA9IExDUl9CSVRTXzU7DQotCQkJYnJlYWs7DQorCXN3aXRjaCAoY2ZsYWcgJiBDU0laRSkgew0K
KwljYXNlIENTNToNCisJCWxEYXRhID0gTENSX0JJVFNfNTsNCisJCWJyZWFrOw0KIA0KLQkJY2Fz
ZSBDUzY6DQotCQkJbERhdGEgPSBMQ1JfQklUU182Ow0KLQkJCWJyZWFrOw0KKwljYXNlIENTNjoN
CisJCWxEYXRhID0gTENSX0JJVFNfNjsNCisJCWJyZWFrOw0KIA0KLQkJY2FzZSBDUzc6DQotCQkJ
bERhdGEgPSBMQ1JfQklUU183Ow0KLQkJCWJyZWFrOw0KLQkJZGVmYXVsdDoNCi0JCWNhc2UgQ1M4
Og0KLQkJCWxEYXRhID0gTENSX0JJVFNfODsNCi0JCQlicmVhazsNCi0JCX0NCisJY2FzZSBDUzc6
DQorCQlsRGF0YSA9IExDUl9CSVRTXzc7DQorCQlicmVhazsNCisNCisJZGVmYXVsdDoNCisJY2Fz
ZSBDUzg6DQorCQlsRGF0YSA9IExDUl9CSVRTXzg7DQorCQlicmVhazsNCiAJfQ0KKw0KIAkvKiBD
aGFuZ2UgdGhlIFBhcml0eSBiaXQgKi8NCiAJaWYgKGNmbGFnICYgUEFSRU5CKSB7DQogCQlpZiAo
Y2ZsYWcgJiBQQVJPREQpIHsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJpYWwvb3B0aW9u
LmMgYi9kcml2ZXJzL3VzYi9zZXJpYWwvb3B0aW9uLmMNCmluZGV4IGQ4YWNlODIuLmQ2ZDBmYjQg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL3VzYi9zZXJpYWwvb3B0aW9uLmMNCisrKyBiL2RyaXZlcnMv
dXNiL3NlcmlhbC9vcHRpb24uYw0KQEAgLTg1LDYgKzg1LDcgQEAgc3RhdGljIHZvaWQgb3B0aW9u
X2luc3RhdF9jYWxsYmFjayhzdHJ1Y3QgdXJiICp1cmIpOw0KICNkZWZpbmUgSFVBV0VJX1BST0RV
Q1RfSzQ1MDUJCQkweDE0NjQNCiAjZGVmaW5lIEhVQVdFSV9QUk9EVUNUX0szNzY1CQkJMHgxNDY1
DQogI2RlZmluZSBIVUFXRUlfUFJPRFVDVF9LNDYwNQkJCTB4MTRDNg0KKyNkZWZpbmUgSFVBV0VJ
X1BST0RVQ1RfRTE3M1M2CQkJMHgxQzA3DQogDQogI2RlZmluZSBRVUFOVEFfVkVORE9SX0lECQkJ
MHgwNDA4DQogI2RlZmluZSBRVUFOVEFfUFJPRFVDVF9RMTAxCQkJMHhFQTAyDQpAQCAtNTg2LDYg
KzU4Nyw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdXNiX2RldmljZV9pZCBvcHRpb25faWRzW10g
PSB7DQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwg
MHgxYzIzLCBVU0JfQ0xBU1NfQ09NTSwgMHgwMiwgMHhmZikgfSwNCiAJeyBVU0JfREVWSUNFX0FO
RF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCBIVUFXRUlfUFJPRFVDVF9FMTczLCAw
eGZmLCAweGZmLCAweGZmKSwNCiAJCS5kcml2ZXJfaW5mbyA9IChrZXJuZWxfdWxvbmdfdCkgJm5l
dF9pbnRmMV9ibGFja2xpc3QgfSwNCisJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhI
VUFXRUlfVkVORE9SX0lELCBIVUFXRUlfUFJPRFVDVF9FMTczUzYsIDB4ZmYsIDB4ZmYsIDB4ZmYp
LA0KKwkJLmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9uZ190KSAmbmV0X2ludGYxX2JsYWNrbGlz
dCB9LA0KIAl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQs
IEhVQVdFSV9QUk9EVUNUX0UxNzUwLCAweGZmLCAweGZmLCAweGZmKSwNCiAJCS5kcml2ZXJfaW5m
byA9IChrZXJuZWxfdWxvbmdfdCkgJm5ldF9pbnRmMl9ibGFja2xpc3QgfSwNCiAJeyBVU0JfREVW
SUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweDE0NDEsIFVTQl9DTEFT
U19DT01NLCAweDAyLCAweGZmKSB9LA0KQEAgLTY0OCw2ICs2NTEsMTAgQEAgc3RhdGljIGNvbnN0
IHN0cnVjdCB1c2JfZGV2aWNlX2lkIG9wdGlvbl9pZHNbXSA9IHsNCiAJeyBVU0JfVkVORE9SX0FO
RF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAxLCAweDZEKSB9LA0K
IAl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYs
IDB4MDEsIDB4NkUpIH0sDQogCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJ
X1ZFTkRPUl9JRCwgMHhmZiwgMHgwMSwgMHg2RikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRF
UkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAxLCAweDcyKSB9LA0KKwl7IFVT
Ql9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDEs
IDB4NzMpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRP
Ul9JRCwgMHhmZiwgMHgwMSwgMHg3NCkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0Vf
SU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAxLCAweDc1KSB9LA0KIAl7IFVTQl9WRU5E
T1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDEsIDB4Nzgp
IH0sDQogCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwg
MHhmZiwgMHgwMSwgMHg3OSkgfSwNCiAJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhI
VUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAxLCAweDdBKSB9LA0KQEAgLTcwMiw2ICs3MDksMTAg
QEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkIG9wdGlvbl9pZHNbXSA9IHsNCiAJ
eyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAw
eDAyLCAweDZEKSB9LA0KIAl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9W
RU5ET1JfSUQsIDB4ZmYsIDB4MDIsIDB4NkUpIH0sDQogCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJG
QUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMiwgMHg2RikgfSwNCisJeyBVU0Jf
VkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAyLCAw
eDcyKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1Jf
SUQsIDB4ZmYsIDB4MDIsIDB4NzMpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lO
Rk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMiwgMHg3NCkgfSwNCisJeyBVU0JfVkVORE9S
X0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAyLCAweDc1KSB9
LA0KIAl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4
ZmYsIDB4MDIsIDB4NzgpIH0sDQogCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVB
V0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMiwgMHg3OSkgfSwNCiAJeyBVU0JfVkVORE9SX0FORF9J
TlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAyLCAweDdBKSB9LA0KQEAg
LTc1Niw2ICs3NjcsMTAgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkIG9wdGlv
bl9pZHNbXSA9IHsNCiAJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVO
RE9SX0lELCAweGZmLCAweDAzLCAweDZEKSB9LA0KIAl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFD
RV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4NkUpIH0sDQogCXsgVVNCX1ZF
TkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHg2
RikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lE
LCAweGZmLCAweDAzLCAweDcyKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZP
KEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4NzMpIH0sDQorCXsgVVNCX1ZFTkRPUl9B
TkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHg3NCkgfSwN
CisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZm
LCAweDAzLCAweDc1KSB9LA0KIAl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdF
SV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDMsIDB4NzgpIH0sDQogCXsgVVNCX1ZFTkRPUl9BTkRfSU5U
RVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwMywgMHg3OSkgfSwNCiAJeyBV
U0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDAz
LCAweDdBKSB9LA0KQEAgLTgxMCw2ICs4MjUsMTAgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1c2Jf
ZGV2aWNlX2lkIG9wdGlvbl9pZHNbXSA9IHsNCiAJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0Vf
SU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA0LCAweDZEKSB9LA0KIAl7IFVTQl9WRU5E
T1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4NkUp
IH0sDQogCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwg
MHhmZiwgMHgwNCwgMHg2RikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhI
VUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA0LCAweDcyKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5E
X0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4NzMpIH0sDQor
CXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwg
MHgwNCwgMHg3NCkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlf
VkVORE9SX0lELCAweGZmLCAweDA0LCAweDc1KSB9LA0KIAl7IFVTQl9WRU5ET1JfQU5EX0lOVEVS
RkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDQsIDB4NzgpIH0sDQogCXsgVVNC
X1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNCwg
MHg3OSkgfSwNCiAJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9S
X0lELCAweGZmLCAweDA0LCAweDdBKSB9LA0KQEAgLTg2NCw2ICs4ODMsMTAgQEAgc3RhdGljIGNv
bnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkIG9wdGlvbl9pZHNbXSA9IHsNCiAJeyBVU0JfVkVORE9S
X0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDZEKSB9
LA0KIAl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4
ZmYsIDB4MDUsIDB4NkUpIH0sDQogCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVB
V0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNSwgMHg2RikgfSwNCisJeyBVU0JfVkVORE9SX0FORF9J
TlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDcyKSB9LA0KKwl7
IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4
MDUsIDB4NzMpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZF
TkRPUl9JRCwgMHhmZiwgMHgwNSwgMHg3NCkgfSwNCisJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZB
Q0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDc1KSB9LA0KIAl7IFVTQl9W
RU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDUsIDB4
NzgpIH0sDQogCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9J
RCwgMHhmZiwgMHgwNSwgMHg3OSkgfSwNCiAJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5G
TyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA1LCAweDdBKSB9LA0KQEAgLTkxOCw2ICs5NDEs
MTAgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkIG9wdGlvbl9pZHNbXSA9IHsN
CiAJeyBVU0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZm
LCAweDA2LCAweDZEKSB9LA0KIAl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdF
SV9WRU5ET1JfSUQsIDB4ZmYsIDB4MDYsIDB4NkUpIH0sDQogCXsgVVNCX1ZFTkRPUl9BTkRfSU5U
RVJGQUNFX0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHg2RikgfSwNCisJeyBV
U0JfVkVORE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2
LCAweDcyKSB9LA0KKwl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5E
T1JfSUQsIDB4ZmYsIDB4MDYsIDB4NzMpIH0sDQorCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNF
X0lORk8oSFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHg3NCkgfSwNCisJeyBVU0JfVkVO
RE9SX0FORF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2LCAweDc1
KSB9LA0KIAl7IFVTQl9WRU5ET1JfQU5EX0lOVEVSRkFDRV9JTkZPKEhVQVdFSV9WRU5ET1JfSUQs
IDB4ZmYsIDB4MDYsIDB4NzgpIH0sDQogCXsgVVNCX1ZFTkRPUl9BTkRfSU5URVJGQUNFX0lORk8o
SFVBV0VJX1ZFTkRPUl9JRCwgMHhmZiwgMHgwNiwgMHg3OSkgfSwNCiAJeyBVU0JfVkVORE9SX0FO
RF9JTlRFUkZBQ0VfSU5GTyhIVUFXRUlfVkVORE9SX0lELCAweGZmLCAweDA2LCAweDdBKSB9LA0K
QEAgLTEzOTEsNiArMTQxOCwyMyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHVzYl9kZXZpY2VfaWQg
b3B0aW9uX2lkc1tdID0gew0KIAkJLmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9uZ190KSZuZXRf
aW50ZjJfYmxhY2tsaXN0IH0sDQogCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRF
X1ZFTkRPUl9JRCwgMHgxNDI2LCAweGZmLCAweGZmLCAweGZmKSwgIC8qIFpURSBNRjkxICovDQog
CQkuZHJpdmVyX2luZm8gPSAoa2VybmVsX3Vsb25nX3QpJm5ldF9pbnRmMl9ibGFja2xpc3QgfSwN
CisJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweDE1MzMs
IDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sDQorCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8o
WlRFX1ZFTkRPUl9JRCwgMHgxNTM0LCAweGZmLCAweGZmLCAweGZmKSB9LA0KKwl7IFVTQl9ERVZJ
Q0VfQU5EX0lOVEVSRkFDRV9JTkZPKFpURV9WRU5ET1JfSUQsIDB4MTUzNSwgMHhmZiwgMHhmZiwg
MHhmZikgfSwNCisJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lE
LCAweDE1NDUsIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sDQorCXsgVVNCX0RFVklDRV9BTkRfSU5URVJG
QUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwgMHgxNTQ2LCAweGZmLCAweGZmLCAweGZmKSB9LA0KKwl7
IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFpURV9WRU5ET1JfSUQsIDB4MTU0NywgMHhm
ZiwgMHhmZiwgMHhmZikgfSwNCisJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhaVEVf
VkVORE9SX0lELCAweDE1NjUsIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sDQorCXsgVVNCX0RFVklDRV9B
TkRfSU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwgMHgxNTY2LCAweGZmLCAweGZmLCAweGZm
KSB9LA0KKwl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFpURV9WRU5ET1JfSUQsIDB4
MTU2NywgMHhmZiwgMHhmZiwgMHhmZikgfSwNCisJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0Vf
SU5GTyhaVEVfVkVORE9SX0lELCAweDE1ODksIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sDQorCXsgVVNC
X0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwgMHgxNTkwLCAweGZmLCAw
eGZmLCAweGZmKSB9LA0KKwl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKFpURV9WRU5E
T1JfSUQsIDB4MTU5MSwgMHhmZiwgMHhmZiwgMHhmZikgfSwNCisJeyBVU0JfREVWSUNFX0FORF9J
TlRFUkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweDE1OTIsIDB4ZmYsIDB4ZmYsIDB4ZmYpIH0s
DQorCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9JRCwgMHgxNTk0
LCAweGZmLCAweGZmLCAweGZmKSB9LA0KKwl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZP
KFpURV9WRU5ET1JfSUQsIDB4MTU5NiwgMHhmZiwgMHhmZiwgMHhmZikgfSwNCisJeyBVU0JfREVW
SUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweDE1OTgsIDB4ZmYsIDB4ZmYs
IDB4ZmYpIH0sDQorCXsgVVNCX0RFVklDRV9BTkRfSU5URVJGQUNFX0lORk8oWlRFX1ZFTkRPUl9J
RCwgMHgxNjAwLCAweGZmLCAweGZmLCAweGZmKSB9LA0KIAl7IFVTQl9ERVZJQ0VfQU5EX0lOVEVS
RkFDRV9JTkZPKFpURV9WRU5ET1JfSUQsIDB4MjAwMiwgMHhmZiwNCiAJICAweGZmLCAweGZmKSwg
LmRyaXZlcl9pbmZvID0gKGtlcm5lbF91bG9uZ190KSZ6dGVfazM3NjVfel9ibGFja2xpc3QgfSwN
CiAJeyBVU0JfREVWSUNFX0FORF9JTlRFUkZBQ0VfSU5GTyhaVEVfVkVORE9SX0lELCAweDIwMDMs
IDB4ZmYsIDB4ZmYsIDB4ZmYpIH0sDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivc2VyaWFsL3Bs
MjMwMy5jIGIvZHJpdmVycy91c2Ivc2VyaWFsL3BsMjMwMy5jDQppbmRleCAzMTdlNTAzLi5lMzkz
NmMxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL3BsMjMwMy5jDQorKysgYi9kcml2
ZXJzL3VzYi9zZXJpYWwvcGwyMzAzLmMNCkBAIC0yOTAsMjQgKzI5MCwyMSBAQCBzdGF0aWMgdm9p
ZCBwbDIzMDNfc2V0X3Rlcm1pb3Moc3RydWN0IHR0eV9zdHJ1Y3QgKnR0eSwNCiAJZGJnKCIweGEx
OjB4MjE6MDowICAlZCAtICV4ICV4ICV4ICV4ICV4ICV4ICV4IiwgaSwNCiAJICAgIGJ1ZlswXSwg
YnVmWzFdLCBidWZbMl0sIGJ1ZlszXSwgYnVmWzRdLCBidWZbNV0sIGJ1Zls2XSk7DQogDQotCWlm
IChjZmxhZyAmIENTSVpFKSB7DQotCQlzd2l0Y2ggKGNmbGFnICYgQ1NJWkUpIHsNCi0JCWNhc2Ug
Q1M1Og0KLQkJCWJ1Zls2XSA9IDU7DQotCQkJYnJlYWs7DQotCQljYXNlIENTNjoNCi0JCQlidWZb
Nl0gPSA2Ow0KLQkJCWJyZWFrOw0KLQkJY2FzZSBDUzc6DQotCQkJYnVmWzZdID0gNzsNCi0JCQli
cmVhazsNCi0JCWRlZmF1bHQ6DQotCQljYXNlIENTODoNCi0JCQlidWZbNl0gPSA4Ow0KLQkJCWJy
ZWFrOw0KLQkJfQ0KLQkJZGJnKCIlcyAtIGRhdGEgYml0cyA9ICVkIiwgX19mdW5jX18sIGJ1Zls2
XSk7DQorCXN3aXRjaCAoQ19DU0laRSh0dHkpKSB7DQorCWNhc2UgQ1M1Og0KKwkJYnVmWzZdID0g
NTsNCisJCWJyZWFrOw0KKwljYXNlIENTNjoNCisJCWJ1Zls2XSA9IDY7DQorCQlicmVhazsNCisJ
Y2FzZSBDUzc6DQorCQlidWZbNl0gPSA3Ow0KKwkJYnJlYWs7DQorCWRlZmF1bHQ6DQorCWNhc2Ug
Q1M4Og0KKwkJYnVmWzZdID0gODsNCiAJfQ0KKwlkZXZfZGJnKCZwb3J0LT5kZXYsICJkYXRhIGJp
dHMgPSAlZFxuIiwgYnVmWzZdKTsNCiANCiAJLyogRm9yIHJlZmVyZW5jZSBidWZbMF06YnVmWzNd
IGJhdWQgcmF0ZSB2YWx1ZSAqLw0KIAkvKiBOT1RFOiBPbmx5IHRoZSB2YWx1ZXMgZGVmaW5lZCBp
biBiYXVkX3N1cCBhcmUgc3VwcG9ydGVkICENCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9zZXJp
YWwvc3BjcDh4NS5jIGIvZHJpdmVycy91c2Ivc2VyaWFsL3NwY3A4eDUuYw0KaW5kZXggZjMxNzli
MC4uMmY2N2I5OSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL3NlcmlhbC9zcGNwOHg1LmMNCisr
KyBiL2RyaXZlcnMvdXNiL3NlcmlhbC9zcGNwOHg1LmMNCkBAIC0zOTQsMjIgKzM5NCwyMCBAQCBz
dGF0aWMgdm9pZCBzcGNwOHg1X3NldF90ZXJtaW9zKHN0cnVjdCB0dHlfc3RydWN0ICp0dHksDQog
CX0NCiANCiAJLyogU2V0IERhdGEgTGVuZ3RoIDogMDA6NWJpdCwgMDE6NmJpdCwgMTA6N2JpdCwg
MTE6OGJpdCAqLw0KLQlpZiAoY2ZsYWcgJiBDU0laRSkgew0KLQkJc3dpdGNoIChjZmxhZyAmIENT
SVpFKSB7DQotCQljYXNlIENTNToNCi0JCQlidWZbMV0gfD0gU0VUX1VBUlRfRk9STUFUX1NJWkVf
NTsNCi0JCQlicmVhazsNCi0JCWNhc2UgQ1M2Og0KLQkJCWJ1ZlsxXSB8PSBTRVRfVUFSVF9GT1JN
QVRfU0laRV82Ow0KLQkJCWJyZWFrOw0KLQkJY2FzZSBDUzc6DQotCQkJYnVmWzFdIHw9IFNFVF9V
QVJUX0ZPUk1BVF9TSVpFXzc7DQotCQkJYnJlYWs7DQotCQlkZWZhdWx0Og0KLQkJY2FzZSBDUzg6
DQotCQkJYnVmWzFdIHw9IFNFVF9VQVJUX0ZPUk1BVF9TSVpFXzg7DQotCQkJYnJlYWs7DQotCQl9
DQorCXN3aXRjaCAoY2ZsYWcgJiBDU0laRSkgew0KKwljYXNlIENTNToNCisJCWJ1ZlsxXSB8PSBT
RVRfVUFSVF9GT1JNQVRfU0laRV81Ow0KKwkJYnJlYWs7DQorCWNhc2UgQ1M2Og0KKwkJYnVmWzFd
IHw9IFNFVF9VQVJUX0ZPUk1BVF9TSVpFXzY7DQorCQlicmVhazsNCisJY2FzZSBDUzc6DQorCQli
dWZbMV0gfD0gU0VUX1VBUlRfRk9STUFUX1NJWkVfNzsNCisJCWJyZWFrOw0KKwlkZWZhdWx0Og0K
KwljYXNlIENTODoNCisJCWJ1ZlsxXSB8PSBTRVRfVUFSVF9GT1JNQVRfU0laRV84Ow0KKwkJYnJl
YWs7DQogCX0NCiANCiAJLyogU2V0IFN0b3AgYml0MiA6IDA6MWJpdCAxOjJiaXQgKi8NCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3VzYi93dXNiY29yZS93YS1ycGlwZS5jIGIvZHJpdmVycy91c2Ivd3Vz
YmNvcmUvd2EtcnBpcGUuYw0KaW5kZXggZjBkNTQ2Yy4uY2ExMDMxYiAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvdXNiL3d1c2Jjb3JlL3dhLXJwaXBlLmMNCisrKyBiL2RyaXZlcnMvdXNiL3d1c2Jjb3Jl
L3dhLXJwaXBlLmMNCkBAIC0zMzIsNyArMzMyLDEwIEBAIHN0YXRpYyBpbnQgcnBpcGVfYWltKHN0
cnVjdCB3YV9ycGlwZSAqcnBpcGUsIHN0cnVjdCB3YWhjICp3YSwNCiAJLyogRklYTUU6IGNvbXB1
dGUgc28gc2VnX3NpemUgPiBlcC0+bWF4cGt0c2l6ZSAqLw0KIAlycGlwZS0+ZGVzY3Iud0Jsb2Nr
cyA9IGNwdV90b19sZTE2KDE2KTsJCS8qIGdpdmVuICovDQogCS8qIGVwMCBtYXhwa3RzaXplIGlz
IDB4MjAwIChXVVNCMS4wWzQuOC4xXSkgKi8NCi0JcnBpcGUtPmRlc2NyLndNYXhQYWNrZXRTaXpl
ID0gY3B1X3RvX2xlMTYoZXAtPmRlc2Mud01heFBhY2tldFNpemUpOw0KKwlpZiAodXNiX2VuZHBv
aW50X3hmZXJfaXNvYygmZXAtPmRlc2MpKQ0KKwkJcnBpcGUtPmRlc2NyLndNYXhQYWNrZXRTaXpl
ID0gZXBjZC0+d092ZXJUaGVBaXJQYWNrZXRTaXplOw0KKwllbHNlDQorCQlycGlwZS0+ZGVzY3Iu
d01heFBhY2tldFNpemUgPSBlcC0+ZGVzYy53TWF4UGFja2V0U2l6ZTsNCiAJcnBpcGUtPmRlc2Ny
LmJIU0h1YkFkZHJlc3MgPSAwOwkJCS8qIHJlc2VydmVkOiB6ZXJvICovDQogCXJwaXBlLT5kZXNj
ci5iSFNIdWJQb3J0ID0gd3VzYl9wb3J0X25vX3RvX2lkeCh1cmItPmRldi0+cG9ydG51bSk7DQog
CS8qIEZJWE1FOiB1c2UgbWF4aW11bSBzcGVlZCBhcyBzdXBwb3J0ZWQgb3IgcmVjb21tZW5kZWQg
YnkgZGV2aWNlICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Ivd3VzYmNvcmUvd2EteGZlci5j
IGIvZHJpdmVycy91c2Ivd3VzYmNvcmUvd2EteGZlci5jDQppbmRleCA1N2MwMWFiLi41ZjZkZjZl
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy91c2Ivd3VzYmNvcmUvd2EteGZlci5jDQorKysgYi9kcml2
ZXJzL3VzYi93dXNiY29yZS93YS14ZmVyLmMNCkBAIC05MCw3ICs5MCw4IEBADQogI2luY2x1ZGUg
Ind1c2JoYy5oIg0KIA0KIGVudW0gew0KLQlXQV9TRUdTX01BWCA9IDI1NSwNCisJLyogW1dVU0Jd
IHNlY3Rpb24gOC4zLjMgYWxsb2NhdGVzIDcgYml0cyBmb3IgdGhlIHNlZ21lbnQgaW5kZXguICov
DQorCVdBX1NFR1NfTUFYID0gMTI4LA0KIH07DQogDQogZW51bSB3YV9zZWdfc3RhdHVzIHsNCkBA
IC00NDQsNyArNDQ1LDcgQEAgc3RhdGljIHNzaXplX3QgX193YV94ZmVyX3NldHVwX3NpemVzKHN0
cnVjdCB3YV94ZmVyICp4ZmVyLA0KIAl4ZmVyLT5zZWdfc2l6ZSA9ICh4ZmVyLT5zZWdfc2l6ZSAv
IG1heHBrdHNpemUpICogbWF4cGt0c2l6ZTsNCiAJeGZlci0+c2VncyA9ICh1cmItPnRyYW5zZmVy
X2J1ZmZlcl9sZW5ndGggKyB4ZmVyLT5zZWdfc2l6ZSAtIDEpDQogCQkvIHhmZXItPnNlZ19zaXpl
Ow0KLQlpZiAoeGZlci0+c2VncyA+PSBXQV9TRUdTX01BWCkgew0KKwlpZiAoeGZlci0+c2VncyA+
IFdBX1NFR1NfTUFYKSB7DQogCQlkZXZfZXJyKGRldiwgIkJVRz8gb3BzLCBudW1iZXIgb2Ygc2Vn
bWVudHMgJWQgYmlnZ2VyIHRoYW4gJWRcbiIsDQogCQkJKGludCkodXJiLT50cmFuc2Zlcl9idWZm
ZXJfbGVuZ3RoIC8geGZlci0+c2VnX3NpemUpLA0KIAkJCVdBX1NFR1NfTUFYKTsNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3ZpZGVvL2JhY2tsaWdodC9hdG1lbC1wd20tYmwuYyBiL2RyaXZlcnMvdmlk
ZW8vYmFja2xpZ2h0L2F0bWVsLXB3bS1ibC5jDQppbmRleCAwNDQzYTRmLi5kYWIzYTBjIDEwMDY0
NA0KLS0tIGEvZHJpdmVycy92aWRlby9iYWNrbGlnaHQvYXRtZWwtcHdtLWJsLmMNCisrKyBiL2Ry
aXZlcnMvdmlkZW8vYmFja2xpZ2h0L2F0bWVsLXB3bS1ibC5jDQpAQCAtNzAsNyArNzAsNyBAQCBz
dGF0aWMgaW50IGF0bWVsX3B3bV9ibF9zZXRfaW50ZW5zaXR5KHN0cnVjdCBiYWNrbGlnaHRfZGV2
aWNlICpiZCkNCiBzdGF0aWMgaW50IGF0bWVsX3B3bV9ibF9nZXRfaW50ZW5zaXR5KHN0cnVjdCBi
YWNrbGlnaHRfZGV2aWNlICpiZCkNCiB7DQogCXN0cnVjdCBhdG1lbF9wd21fYmwgKnB3bWJsID0g
YmxfZ2V0X2RhdGEoYmQpOw0KLQl1OCBpbnRlbnNpdHk7DQorCXUzMiBpbnRlbnNpdHk7DQogDQog
CWlmIChwd21ibC0+cGRhdGEtPnB3bV9hY3RpdmVfbG93KSB7DQogCQlpbnRlbnNpdHkgPSBwd21f
Y2hhbm5lbF9yZWFkbCgmcHdtYmwtPnB3bWMsIFBXTV9DRFRZKSAtDQpAQCAtODAsNyArODAsNyBA
QCBzdGF0aWMgaW50IGF0bWVsX3B3bV9ibF9nZXRfaW50ZW5zaXR5KHN0cnVjdCBiYWNrbGlnaHRf
ZGV2aWNlICpiZCkNCiAJCQlwd21fY2hhbm5lbF9yZWFkbCgmcHdtYmwtPnB3bWMsIFBXTV9DRFRZ
KTsNCiAJfQ0KIA0KLQlyZXR1cm4gaW50ZW5zaXR5Ow0KKwlyZXR1cm4gaW50ZW5zaXR5ICYgMHhm
ZmZmOw0KIH0NCiANCiBzdGF0aWMgaW50IGF0bWVsX3B3bV9ibF9pbml0X3B3bShzdHJ1Y3QgYXRt
ZWxfcHdtX2JsICpwd21ibCkNCkBAIC0yMTEsNyArMjExLDggQEAgc3RhdGljIGludCBfX2V4aXQg
YXRtZWxfcHdtX2JsX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KIAlzdHJ1
Y3QgYXRtZWxfcHdtX2JsICpwd21ibCA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYpOw0KIA0K
IAlpZiAocHdtYmwtPmdwaW9fb24gIT0gLTEpIHsNCi0JCWdwaW9fc2V0X3ZhbHVlKHB3bWJsLT5n
cGlvX29uLCAwKTsNCisJCWdwaW9fc2V0X3ZhbHVlKHB3bWJsLT5ncGlvX29uLA0KKwkJCQkJMCBe
IHB3bWJsLT5wZGF0YS0+b25fYWN0aXZlX2xvdyk7DQogCQlncGlvX2ZyZWUocHdtYmwtPmdwaW9f
b24pOw0KIAl9DQogCXB3bV9jaGFubmVsX2Rpc2FibGUoJnB3bWJsLT5wd21jKTsNCmRpZmYgLS1n
aXQgYS9mcy9jaWZzL2NpZnNzbWIuYyBiL2ZzL2NpZnMvY2lmc3NtYi5jDQppbmRleCBjODU4YTI5
Li45NjlmNzRmIDEwMDY0NA0KLS0tIGEvZnMvY2lmcy9jaWZzc21iLmMNCisrKyBiL2ZzL2NpZnMv
Y2lmc3NtYi5jDQpAQCAtMzQzNywxMSArMzQzNywxMyBAQCBzdGF0aWMgX191MTYgQUNMX3RvX2Np
ZnNfcG9zaXgoY2hhciAqcGFybV9kYXRhLCBjb25zdCBjaGFyICpwQUNMLA0KIAkJcmV0dXJuIDA7
DQogCX0NCiAJY2lmc19hY2wtPnZlcnNpb24gPSBjcHVfdG9fbGUxNigxKTsNCi0JaWYgKGFjbF90
eXBlID09IEFDTF9UWVBFX0FDQ0VTUykNCisJaWYgKGFjbF90eXBlID09IEFDTF9UWVBFX0FDQ0VT
Uykgew0KIAkJY2lmc19hY2wtPmFjY2Vzc19lbnRyeV9jb3VudCA9IGNwdV90b19sZTE2KGNvdW50
KTsNCi0JZWxzZSBpZiAoYWNsX3R5cGUgPT0gQUNMX1RZUEVfREVGQVVMVCkNCisJCWNpZnNfYWNs
LT5kZWZhdWx0X2VudHJ5X2NvdW50ID0gX19jb25zdGFudF9jcHVfdG9fbGUxNigweEZGRkYpOw0K
Kwl9IGVsc2UgaWYgKGFjbF90eXBlID09IEFDTF9UWVBFX0RFRkFVTFQpIHsNCiAJCWNpZnNfYWNs
LT5kZWZhdWx0X2VudHJ5X2NvdW50ID0gY3B1X3RvX2xlMTYoY291bnQpOw0KLQllbHNlIHsNCisJ
CWNpZnNfYWNsLT5hY2Nlc3NfZW50cnlfY291bnQgPSBfX2NvbnN0YW50X2NwdV90b19sZTE2KDB4
RkZGRik7DQorCX0gZWxzZSB7DQogCQljRllJKDEsICJ1bmtub3duIEFDTCB0eXBlICVkIiwgYWNs
X3R5cGUpOw0KIAkJcmV0dXJuIDA7DQogCX0NCmRpZmYgLS1naXQgYS9mcy9jb25maWdmcy9kaXIu
YyBiL2ZzL2NvbmZpZ2ZzL2Rpci5jDQppbmRleCA5YTM3YTliLi41ZWY3MmM4IDEwMDY0NA0KLS0t
IGEvZnMvY29uZmlnZnMvZGlyLmMNCisrKyBiL2ZzL2NvbmZpZ2ZzL2Rpci5jDQpAQCAtNTYsMTAg
KzU2LDE5IEBAIHN0YXRpYyB2b2lkIGNvbmZpZ2ZzX2RfaXB1dChzdHJ1Y3QgZGVudHJ5ICogZGVu
dHJ5LA0KIAlzdHJ1Y3QgY29uZmlnZnNfZGlyZW50ICpzZCA9IGRlbnRyeS0+ZF9mc2RhdGE7DQog
DQogCWlmIChzZCkgew0KLQkJQlVHX09OKHNkLT5zX2RlbnRyeSAhPSBkZW50cnkpOw0KIAkJLyog
Q29vcmRpbmF0ZSB3aXRoIGNvbmZpZ2ZzX3JlYWRkaXIgKi8NCiAJCXNwaW5fbG9jaygmY29uZmln
ZnNfZGlyZW50X2xvY2spOw0KLQkJc2QtPnNfZGVudHJ5ID0gTlVMTDsNCisJCS8qIENvb3JkaW5h
dGUgd2l0aCBjb25maWdmc19hdHRhY2hfYXR0ciB3aGVyZSB3aWxsIGluY3JlYXNlDQorCQkgKiBz
ZC0+c19jb3VudCBhbmQgdXBkYXRlIHNkLT5zX2RlbnRyeSB0byBuZXcgYWxsb2NhdGVkIG9uZS4N
CisJCSAqIE9ubHkgc2V0IHNkLT5kZW50cnkgdG8gbnVsbCB3aGVuIHRoaXMgZGVudHJ5IGlzIHRo
ZSBvbmx5DQorCQkgKiBzZCBvd25lci4NCisJCSAqIElmIG5vdCBkbyBzbywgY29uZmlnZnNfZF9p
cHV0IG1heSBydW4ganVzdCBhZnRlcg0KKwkJICogY29uZmlnZnNfYXR0YWNoX2F0dHIgYW5kIHNl
dCBzZC0+c19kZW50cnkgdG8gbnVsbA0KKwkJICogZXZlbiBpdCdzIHN0aWxsIGluIHVzZS4NCisJ
CSAqLw0KKwkJaWYgKGF0b21pY19yZWFkKCZzZC0+c19jb3VudCkgPD0gMikNCisJCQlzZC0+c19k
ZW50cnkgPSBOVUxMOw0KKw0KIAkJc3Bpbl91bmxvY2soJmNvbmZpZ2ZzX2RpcmVudF9sb2NrKTsN
CiAJCWNvbmZpZ2ZzX3B1dChzZCk7DQogCX0NCkBAIC00MzYsOCArNDQ1LDExIEBAIHN0YXRpYyBp
bnQgY29uZmlnZnNfYXR0YWNoX2F0dHIoc3RydWN0IGNvbmZpZ2ZzX2RpcmVudCAqIHNkLCBzdHJ1
Y3QgZGVudHJ5ICogZGVuDQogCXN0cnVjdCBjb25maWdmc19hdHRyaWJ1dGUgKiBhdHRyID0gc2Qt
PnNfZWxlbWVudDsNCiAJaW50IGVycm9yOw0KIA0KKwlzcGluX2xvY2soJmNvbmZpZ2ZzX2RpcmVu
dF9sb2NrKTsNCiAJZGVudHJ5LT5kX2ZzZGF0YSA9IGNvbmZpZ2ZzX2dldChzZCk7DQogCXNkLT5z
X2RlbnRyeSA9IGRlbnRyeTsNCisJc3Bpbl91bmxvY2soJmNvbmZpZ2ZzX2RpcmVudF9sb2NrKTsN
CisNCiAJZXJyb3IgPSBjb25maWdmc19jcmVhdGUoZGVudHJ5LCAoYXR0ci0+Y2FfbW9kZSAmIFNf
SUFMTFVHTykgfCBTX0lGUkVHLA0KIAkJCQljb25maWdmc19pbml0X2ZpbGUpOw0KIAlpZiAoZXJy
b3IpIHsNCmRpZmYgLS1naXQgYS9mcy9kZXZwdHMvaW5vZGUuYyBiL2ZzL2RldnB0cy9pbm9kZS5j
DQppbmRleCBkNWQ1Mjk3Li4yYTk1MDQ3IDEwMDY0NA0KLS0tIGEvZnMvZGV2cHRzL2lub2RlLmMN
CisrKyBiL2ZzL2RldnB0cy9pbm9kZS5jDQpAQCAtNDEzLDYgKzQxMyw3IEBAIHN0YXRpYyB2b2lk
IGRldnB0c19raWxsX3NiKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpDQogew0KIAlzdHJ1Y3QgcHRz
X2ZzX2luZm8gKmZzaSA9IERFVlBUU19TQihzYik7DQogDQorCWlkYV9kZXN0cm95KCZmc2ktPmFs
bG9jYXRlZF9wdHlzKTsNCiAJa2ZyZWUoZnNpKTsNCiAJa2lsbF9saXR0ZXJfc3VwZXIoc2IpOw0K
IH0NCmRpZmYgLS1naXQgYS9mcy9leGVjLmMgYi9mcy9leGVjLmMNCmluZGV4IGEyZDBlNTEuLjc4
MTk5ZWIgMTAwNjQ0DQotLS0gYS9mcy9leGVjLmMNCisrKyBiL2ZzL2V4ZWMuYw0KQEAgLTIwMzIs
NiArMjAzMiwxMiBAQCBzdGF0aWMgaW50IF9fZ2V0X2R1bXBhYmxlKHVuc2lnbmVkIGxvbmcgbW1f
ZmxhZ3MpDQogCXJldHVybiAocmV0ID49IDIpID8gMiA6IHJldDsNCiB9DQogDQorLyoNCisgKiBU
aGlzIHJldHVybnMgdGhlIGFjdHVhbCB2YWx1ZSBvZiB0aGUgc3VpZF9kdW1wYWJsZSBmbGFnLiBG
b3IgdGhpbmdzDQorICogdGhhdCBhcmUgdXNpbmcgdGhpcyBmb3IgY2hlY2tpbmcgZm9yIHByaXZp
bGVnZSB0cmFuc2l0aW9ucywgaXQgbXVzdA0KKyAqIHRlc3QgYWdhaW5zdCBTVUlEX0RVTVBfVVNF
UiByYXRoZXIgdGhhbiB0cmVhdGluZyBpdCBhcyBhIGJvb2xlYW4NCisgKiB2YWx1ZS4NCisgKi8N
CiBpbnQgZ2V0X2R1bXBhYmxlKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tKQ0KIHsNCiAJcmV0dXJuIF9f
Z2V0X2R1bXBhYmxlKG1tLT5mbGFncyk7DQpkaWZmIC0tZ2l0IGEvZnMvZXh0NC94YXR0ci5jIGIv
ZnMvZXh0NC94YXR0ci5jDQppbmRleCBiNGU5ZjNmLi4wNTYxN2JkIDEwMDY0NA0KLS0tIGEvZnMv
ZXh0NC94YXR0ci5jDQorKysgYi9mcy9leHQ0L3hhdHRyLmMNCkBAIC0xMjcxLDYgKzEyNzEsNyBA
QCByZXRyeToNCiAJCQkJCW5ld19leHRyYV9pc2l6ZSA9IHNfbWluX2V4dHJhX2lzaXplOw0KIAkJ
CQkJa2ZyZWUoaXMpOyBpcyA9IE5VTEw7DQogCQkJCQlrZnJlZShicyk7IGJzID0gTlVMTDsNCisJ
CQkJCWJyZWxzZShiaCk7DQogCQkJCQlnb3RvIHJldHJ5Ow0KIAkJCQl9DQogCQkJCWVycm9yID0g
LTE7DQpkaWZmIC0tZ2l0IGEvZnMvbmZzL25mczRwcm9jLmMgYi9mcy9uZnMvbmZzNHByb2MuYw0K
aW5kZXggNTYzOWVmZC4uM2QwMjkzMSAxMDA2NDQNCi0tLSBhL2ZzL25mcy9uZnM0cHJvYy5jDQor
KysgYi9mcy9uZnMvbmZzNHByb2MuYw0KQEAgLTM3NjQsOCArMzc2NCw3IEBAIG5mczRfYXN5bmNf
aGFuZGxlX2Vycm9yKHN0cnVjdCBycGNfdGFzayAqdGFzaywgY29uc3Qgc3RydWN0IG5mc19zZXJ2
ZXIgKnNlcnZlciwNCiAJCQlkcHJpbnRrKCIlcyBFUlJPUiAlZCwgUmVzZXQgc2Vzc2lvblxuIiwg
X19mdW5jX18sDQogCQkJCXRhc2stPnRrX3N0YXR1cyk7DQogCQkJbmZzNF9zY2hlZHVsZV9zZXNz
aW9uX3JlY292ZXJ5KGNscC0+Y2xfc2Vzc2lvbik7DQotCQkJdGFzay0+dGtfc3RhdHVzID0gMDsN
Ci0JCQlyZXR1cm4gLUVBR0FJTjsNCisJCQlnb3RvIHdhaXRfb25fcmVjb3Zlcnk7DQogI2VuZGlm
IC8qIENPTkZJR19ORlNfVjRfMSAqLw0KIAkJY2FzZSAtTkZTNEVSUl9ERUxBWToNCiAJCQluZnNf
aW5jX3NlcnZlcl9zdGF0cyhzZXJ2ZXIsIE5GU0lPU19ERUxBWSk7DQpAQCAtMzg4NywxMSArMzg4
NiwxNyBAQCBzdGF0aWMgdm9pZCBuZnM0X2RlbGVncmV0dXJuX2RvbmUoc3RydWN0IHJwY190YXNr
ICp0YXNrLCB2b2lkICpjYWxsZGF0YSkNCiAJCXJldHVybjsNCiANCiAJc3dpdGNoICh0YXNrLT50
a19zdGF0dXMpIHsNCi0JY2FzZSAtTkZTNEVSUl9TVEFMRV9TVEFURUlEOg0KLQljYXNlIC1ORlM0
RVJSX0VYUElSRUQ6DQogCWNhc2UgMDoNCiAJCXJlbmV3X2xlYXNlKGRhdGEtPnJlcy5zZXJ2ZXIs
IGRhdGEtPnRpbWVzdGFtcCk7DQogCQlicmVhazsNCisJY2FzZSAtTkZTNEVSUl9BRE1JTl9SRVZP
S0VEOg0KKwljYXNlIC1ORlM0RVJSX0RFTEVHX1JFVk9LRUQ6DQorCWNhc2UgLU5GUzRFUlJfQkFE
X1NUQVRFSUQ6DQorCWNhc2UgLU5GUzRFUlJfT0xEX1NUQVRFSUQ6DQorCWNhc2UgLU5GUzRFUlJf
U1RBTEVfU1RBVEVJRDoNCisJY2FzZSAtTkZTNEVSUl9FWFBJUkVEOg0KKwkJdGFzay0+dGtfc3Rh
dHVzID0gMDsNCisJCWJyZWFrOw0KIAlkZWZhdWx0Og0KIAkJaWYgKG5mczRfYXN5bmNfaGFuZGxl
X2Vycm9yKHRhc2ssIGRhdGEtPnJlcy5zZXJ2ZXIsIE5VTEwpID09DQogCQkJCS1FQUdBSU4pIHsN
CkBAIC00MDUyLDYgKzQwNTcsNyBAQCBzdGF0aWMgaW50IF9uZnM0X3Byb2NfZ2V0bGsoc3RydWN0
IG5mczRfc3RhdGUgKnN0YXRlLCBpbnQgY21kLCBzdHJ1Y3QgZmlsZV9sb2NrDQogCQkJc3RhdHVz
ID0gMDsNCiAJfQ0KIAlyZXF1ZXN0LT5mbF9vcHMtPmZsX3JlbGVhc2VfcHJpdmF0ZShyZXF1ZXN0
KTsNCisJcmVxdWVzdC0+Zmxfb3BzID0gTlVMTDsNCiBvdXQ6DQogCXJldHVybiBzdGF0dXM7DQog
fQ0KZGlmZiAtLWdpdCBhL2ZzL25mc2QvbmZzNHhkci5jIGIvZnMvbmZzZC9uZnM0eGRyLmMNCmlu
ZGV4IDk5NjI1YjguLmFkZTUzMTYgMTAwNjQ0DQotLS0gYS9mcy9uZnNkL25mczR4ZHIuYw0KKysr
IGIvZnMvbmZzZC9uZnM0eGRyLmMNCkBAIC0xNzcsOCArMTc3LDggQEAgc3RhdGljIF9fYmUzMiAq
cmVhZF9idWYoc3RydWN0IG5mc2Q0X2NvbXBvdW5kYXJncyAqYXJncCwgdTMyIG5ieXRlcykNCiAJ
ICovDQogCW1lbWNweShwLCBhcmdwLT5wLCBhdmFpbCk7DQogCS8qIHN0ZXAgdG8gbmV4dCBwYWdl
ICovDQotCWFyZ3AtPnBhZ2VsaXN0Kys7DQogCWFyZ3AtPnAgPSBwYWdlX2FkZHJlc3MoYXJncC0+
cGFnZWxpc3RbMF0pOw0KKwlhcmdwLT5wYWdlbGlzdCsrOw0KIAlpZiAoYXJncC0+cGFnZWxlbiA8
IFBBR0VfU0laRSkgew0KIAkJYXJncC0+ZW5kID0gYXJncC0+cCArIChhcmdwLT5wYWdlbGVuPj4y
KTsNCiAJCWFyZ3AtPnBhZ2VsZW4gPSAwOw0KZGlmZiAtLWdpdCBhL2ZzL25mc2QvdmZzLmMgYi9m
cy9uZnNkL3Zmcy5jDQppbmRleCA2MWI2OTdlLi42YTY2ZmMwIDEwMDY0NA0KLS0tIGEvZnMvbmZz
ZC92ZnMuYw0KKysrIGIvZnMvbmZzZC92ZnMuYw0KQEAgLTI5Nyw0MSArMjk3LDEyIEBAIGNvbW1p
dF9tZXRhZGF0YShzdHJ1Y3Qgc3ZjX2ZoICpmaHApDQogfQ0KIA0KIC8qDQotICogU2V0IHZhcmlv
dXMgZmlsZSBhdHRyaWJ1dGVzLg0KLSAqIE4uQi4gQWZ0ZXIgdGhpcyBjYWxsIGZocCBuZWVkcyBh
biBmaF9wdXQNCisgKiBHbyBvdmVyIHRoZSBhdHRyaWJ1dGVzIGFuZCB0YWtlIGNhcmUgb2YgdGhl
IHNtYWxsIGRpZmZlcmVuY2VzIGJldHdlZW4NCisgKiBORlMgc2VtYW50aWNzIGFuZCB3aGF0IExp
bnV4IGV4cGVjdHMuDQogICovDQotX19iZTMyDQotbmZzZF9zZXRhdHRyKHN0cnVjdCBzdmNfcnFz
dCAqcnFzdHAsIHN0cnVjdCBzdmNfZmggKmZocCwgc3RydWN0IGlhdHRyICppYXAsDQotCSAgICAg
aW50IGNoZWNrX2d1YXJkLCB0aW1lX3QgZ3VhcmR0aW1lKQ0KK3N0YXRpYyB2b2lkDQorbmZzZF9z
YW5pdGl6ZV9hdHRycyhzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgaWF0dHIgKmlhcCkNCiB7
DQotCXN0cnVjdCBkZW50cnkJKmRlbnRyeTsNCi0Jc3RydWN0IGlub2RlCSppbm9kZTsNCi0JaW50
CQlhY2Ntb2RlID0gTkZTRF9NQVlfU0FUVFI7DQotCWludAkJZnR5cGUgPSAwOw0KLQlfX2JlMzIJ
CWVycjsNCi0JaW50CQlob3N0X2VycjsNCi0JaW50CQlzaXplX2NoYW5nZSA9IDA7DQotDQotCWlm
IChpYXAtPmlhX3ZhbGlkICYgKEFUVFJfQVRJTUUgfCBBVFRSX01USU1FIHwgQVRUUl9TSVpFKSkN
Ci0JCWFjY21vZGUgfD0gTkZTRF9NQVlfV1JJVEV8TkZTRF9NQVlfT1dORVJfT1ZFUlJJREU7DQot
CWlmIChpYXAtPmlhX3ZhbGlkICYgQVRUUl9TSVpFKQ0KLQkJZnR5cGUgPSBTX0lGUkVHOw0KLQ0K
LQkvKiBHZXQgaW5vZGUgKi8NCi0JZXJyID0gZmhfdmVyaWZ5KHJxc3RwLCBmaHAsIGZ0eXBlLCBh
Y2Ntb2RlKTsNCi0JaWYgKGVycikNCi0JCWdvdG8gb3V0Ow0KLQ0KLQlkZW50cnkgPSBmaHAtPmZo
X2RlbnRyeTsNCi0JaW5vZGUgPSBkZW50cnktPmRfaW5vZGU7DQotDQotCS8qIElnbm9yZSBhbnkg
bW9kZSB1cGRhdGVzIG9uIHN5bWxpbmtzICovDQotCWlmIChTX0lTTE5LKGlub2RlLT5pX21vZGUp
KQ0KLQkJaWFwLT5pYV92YWxpZCAmPSB+QVRUUl9NT0RFOw0KLQ0KLQlpZiAoIWlhcC0+aWFfdmFs
aWQpDQotCQlnb3RvIG91dDsNCi0NCiAJLyoNCiAJICogTkZTdjIgZG9lcyBub3QgZGlmZmVyZW50
aWF0ZSBiZXR3ZWVuICJzZXQtW2FjXXRpbWUtdG8tbm93Ig0KIAkgKiB3aGljaCBvbmx5IHJlcXVp
cmVzIGFjY2VzcywgYW5kICJzZXQtW2FjXXRpbWUtdG8tWCIgd2hpY2gNCkBAIC0zNDEsOCArMzEy
LDcgQEAgbmZzZF9zZXRhdHRyKHN0cnVjdCBzdmNfcnFzdCAqcnFzdHAsIHN0cnVjdCBzdmNfZmgg
KmZocCwgc3RydWN0IGlhdHRyICppYXAsDQogCSAqIGNvbnZlcnQgdG8gInNldCB0byBub3ciIGlu
c3RlYWQgb2YgInNldCB0byBleHBsaWNpdCB0aW1lIg0KIAkgKg0KIAkgKiBXZSBvbmx5IGNhbGwg
aW5vZGVfY2hhbmdlX29rIGFzIHRoZSBsYXN0IHRlc3QgYXMgdGVjaG5pY2FsbHkNCi0JICogaXQg
aXMgbm90IGFuIGludGVyZmFjZSB0aGF0IHdlIHNob3VsZCBiZSB1c2luZy4gIEl0IGlzIG9ubHkN
Ci0JICogdmFsaWQgaWYgdGhlIGZpbGVzeXN0ZW0gZG9lcyBub3QgZGVmaW5lIGl0J3Mgb3duIGlf
b3AtPnNldGF0dHIuDQorCSAqIGl0IGlzIG5vdCBhbiBpbnRlcmZhY2UgdGhhdCB3ZSBzaG91bGQg
YmUgdXNpbmcuDQogCSAqLw0KICNkZWZpbmUgQk9USF9USU1FX1NFVCAoQVRUUl9BVElNRV9TRVQg
fCBBVFRSX01USU1FX1NFVCkNCiAjZGVmaW5lCU1BWF9UT1VDSF9USU1FX0VSUk9SICgzMCo2MCkN
CkBAIC0zNjgsMzAgKzMzOCw2IEBAIG5mc2Rfc2V0YXR0cihzdHJ1Y3Qgc3ZjX3Jxc3QgKnJxc3Rw
LCBzdHJ1Y3Qgc3ZjX2ZoICpmaHAsIHN0cnVjdCBpYXR0ciAqaWFwLA0KIAkJCWlhcC0+aWFfdmFs
aWQgJj0gfkJPVEhfVElNRV9TRVQ7DQogCQl9DQogCX0NCi0JICAgIA0KLQkvKg0KLQkgKiBUaGUg
c2l6ZSBjYXNlIGlzIHNwZWNpYWwuDQotCSAqIEl0IGNoYW5nZXMgdGhlIGZpbGUgYXMgd2VsbCBh
cyB0aGUgYXR0cmlidXRlcy4NCi0JICovDQotCWlmIChpYXAtPmlhX3ZhbGlkICYgQVRUUl9TSVpF
KSB7DQotCQlpZiAoaWFwLT5pYV9zaXplIDwgaW5vZGUtPmlfc2l6ZSkgew0KLQkJCWVyciA9IG5m
c2RfcGVybWlzc2lvbihycXN0cCwgZmhwLT5maF9leHBvcnQsIGRlbnRyeSwNCi0JCQkJCU5GU0Rf
TUFZX1RSVU5DfE5GU0RfTUFZX09XTkVSX09WRVJSSURFKTsNCi0JCQlpZiAoZXJyKQ0KLQkJCQln
b3RvIG91dDsNCi0JCX0NCi0NCi0JCWhvc3RfZXJyID0gZ2V0X3dyaXRlX2FjY2Vzcyhpbm9kZSk7
DQotCQlpZiAoaG9zdF9lcnIpDQotCQkJZ290byBvdXRfbmZzZXJyOw0KLQ0KLQkJc2l6ZV9jaGFu
Z2UgPSAxOw0KLQkJaG9zdF9lcnIgPSBsb2Nrc192ZXJpZnlfdHJ1bmNhdGUoaW5vZGUsIE5VTEws
IGlhcC0+aWFfc2l6ZSk7DQotCQlpZiAoaG9zdF9lcnIpIHsNCi0JCQlwdXRfd3JpdGVfYWNjZXNz
KGlub2RlKTsNCi0JCQlnb3RvIG91dF9uZnNlcnI7DQotCQl9DQotCX0NCiANCiAJLyogc2FuaXRp
emUgdGhlIG1vZGUgY2hhbmdlICovDQogCWlmIChpYXAtPmlhX3ZhbGlkICYgQVRUUl9NT0RFKSB7
DQpAQCAtNDE0LDMyICszNjAsMTExIEBAIG5mc2Rfc2V0YXR0cihzdHJ1Y3Qgc3ZjX3Jxc3QgKnJx
c3RwLCBzdHJ1Y3Qgc3ZjX2ZoICpmaHAsIHN0cnVjdCBpYXR0ciAqaWFwLA0KIAkJCWlhcC0+aWFf
dmFsaWQgfD0gKEFUVFJfS0lMTF9TVUlEIHwgQVRUUl9LSUxMX1NHSUQpOw0KIAkJfQ0KIAl9DQor
fQ0KIA0KLQkvKiBDaGFuZ2UgdGhlIGF0dHJpYnV0ZXMuICovDQorc3RhdGljIF9fYmUzMg0KK25m
c2RfZ2V0X3dyaXRlX2FjY2VzcyhzdHJ1Y3Qgc3ZjX3Jxc3QgKnJxc3RwLCBzdHJ1Y3Qgc3ZjX2Zo
ICpmaHAsDQorCQlzdHJ1Y3QgaWF0dHIgKmlhcCkNCit7DQorCXN0cnVjdCBpbm9kZSAqaW5vZGUg
PSBmaHAtPmZoX2RlbnRyeS0+ZF9pbm9kZTsNCisJaW50IGhvc3RfZXJyOw0KIA0KLQlpYXAtPmlh
X3ZhbGlkIHw9IEFUVFJfQ1RJTUU7DQorCWlmIChpYXAtPmlhX3NpemUgPCBpbm9kZS0+aV9zaXpl
KSB7DQorCQlfX2JlMzIgZXJyOw0KIA0KLQllcnIgPSBuZnNlcnJfbm90c3luYzsNCi0JaWYgKCFj
aGVja19ndWFyZCB8fCBndWFyZHRpbWUgPT0gaW5vZGUtPmlfY3RpbWUudHZfc2VjKSB7DQotCQlo
b3N0X2VyciA9IG5mc2RfYnJlYWtfbGVhc2UoaW5vZGUpOw0KLQkJaWYgKGhvc3RfZXJyKQ0KLQkJ
CWdvdG8gb3V0X25mc2VycjsNCi0JCWZoX2xvY2soZmhwKTsNCisJCWVyciA9IG5mc2RfcGVybWlz
c2lvbihycXN0cCwgZmhwLT5maF9leHBvcnQsIGZocC0+ZmhfZGVudHJ5LA0KKwkJCQlORlNEX01B
WV9UUlVOQyB8IE5GU0RfTUFZX09XTkVSX09WRVJSSURFKTsNCisJCWlmIChlcnIpDQorCQkJcmV0
dXJuIGVycjsNCisJfQ0KIA0KLQkJaG9zdF9lcnIgPSBub3RpZnlfY2hhbmdlKGRlbnRyeSwgaWFw
KTsNCi0JCWVyciA9IG5mc2Vycm5vKGhvc3RfZXJyKTsNCi0JCWZoX3VubG9jayhmaHApOw0KKwlo
b3N0X2VyciA9IGdldF93cml0ZV9hY2Nlc3MoaW5vZGUpOw0KKwlpZiAoaG9zdF9lcnIpDQorCQln
b3RvIG91dF9uZnNlcnJubzsNCisNCisJaG9zdF9lcnIgPSBsb2Nrc192ZXJpZnlfdHJ1bmNhdGUo
aW5vZGUsIE5VTEwsIGlhcC0+aWFfc2l6ZSk7DQorCWlmIChob3N0X2VycikNCisJCWdvdG8gb3V0
X3B1dF93cml0ZV9hY2Nlc3M7DQorCXJldHVybiAwOw0KKw0KK291dF9wdXRfd3JpdGVfYWNjZXNz
Og0KKwlwdXRfd3JpdGVfYWNjZXNzKGlub2RlKTsNCitvdXRfbmZzZXJybm86DQorCXJldHVybiBu
ZnNlcnJubyhob3N0X2Vycik7DQorfQ0KKw0KKy8qDQorICogU2V0IHZhcmlvdXMgZmlsZSBhdHRy
aWJ1dGVzLiAgQWZ0ZXIgdGhpcyBjYWxsIGZocCBuZWVkcyBhbiBmaF9wdXQuDQorICovDQorX19i
ZTMyDQorbmZzZF9zZXRhdHRyKHN0cnVjdCBzdmNfcnFzdCAqcnFzdHAsIHN0cnVjdCBzdmNfZmgg
KmZocCwgc3RydWN0IGlhdHRyICppYXAsDQorCSAgICAgaW50IGNoZWNrX2d1YXJkLCB0aW1lX3Qg
Z3VhcmR0aW1lKQ0KK3sNCisJc3RydWN0IGRlbnRyeQkqZGVudHJ5Ow0KKwlzdHJ1Y3QgaW5vZGUJ
Kmlub2RlOw0KKwlpbnQJCWFjY21vZGUgPSBORlNEX01BWV9TQVRUUjsNCisJaW50CQlmdHlwZSA9
IDA7DQorCV9fYmUzMgkJZXJyOw0KKwlpbnQJCWhvc3RfZXJyOw0KKwlpbnQJCXNpemVfY2hhbmdl
ID0gMDsNCisNCisJaWYgKGlhcC0+aWFfdmFsaWQgJiAoQVRUUl9BVElNRSB8IEFUVFJfTVRJTUUg
fCBBVFRSX1NJWkUpKQ0KKwkJYWNjbW9kZSB8PSBORlNEX01BWV9XUklURXxORlNEX01BWV9PV05F
Ul9PVkVSUklERTsNCisJaWYgKGlhcC0+aWFfdmFsaWQgJiBBVFRSX1NJWkUpDQorCQlmdHlwZSA9
IFNfSUZSRUc7DQorDQorCS8qIEdldCBpbm9kZSAqLw0KKwllcnIgPSBmaF92ZXJpZnkocnFzdHAs
IGZocCwgZnR5cGUsIGFjY21vZGUpOw0KKwlpZiAoZXJyKQ0KKwkJZ290byBvdXQ7DQorDQorCWRl
bnRyeSA9IGZocC0+ZmhfZGVudHJ5Ow0KKwlpbm9kZSA9IGRlbnRyeS0+ZF9pbm9kZTsNCisNCisJ
LyogSWdub3JlIGFueSBtb2RlIHVwZGF0ZXMgb24gc3ltbGlua3MgKi8NCisJaWYgKFNfSVNMTkso
aW5vZGUtPmlfbW9kZSkpDQorCQlpYXAtPmlhX3ZhbGlkICY9IH5BVFRSX01PREU7DQorDQorCWlm
ICghaWFwLT5pYV92YWxpZCkNCisJCWdvdG8gb3V0Ow0KKw0KKwluZnNkX3Nhbml0aXplX2F0dHJz
KGlub2RlLCBpYXApOw0KKw0KKwkvKg0KKwkgKiBUaGUgc2l6ZSBjYXNlIGlzIHNwZWNpYWwsIGl0
IGNoYW5nZXMgdGhlIGZpbGUgaW4gYWRkaXRpb24gdG8gdGhlDQorCSAqIGF0dHJpYnV0ZXMuDQor
CSAqLw0KKwlpZiAoaWFwLT5pYV92YWxpZCAmIEFUVFJfU0laRSkgew0KKwkJZXJyID0gbmZzZF9n
ZXRfd3JpdGVfYWNjZXNzKHJxc3RwLCBmaHAsIGlhcCk7DQorCQlpZiAoZXJyKQ0KKwkJCWdvdG8g
b3V0Ow0KKwkJc2l6ZV9jaGFuZ2UgPSAxOw0KIAl9DQorDQorCWlhcC0+aWFfdmFsaWQgfD0gQVRU
Ul9DVElNRTsNCisNCisJaWYgKGNoZWNrX2d1YXJkICYmIGd1YXJkdGltZSAhPSBpbm9kZS0+aV9j
dGltZS50dl9zZWMpIHsNCisJCWVyciA9IG5mc2Vycl9ub3RzeW5jOw0KKwkJZ290byBvdXRfcHV0
X3dyaXRlX2FjY2VzczsNCisJfQ0KKw0KKwlob3N0X2VyciA9IG5mc2RfYnJlYWtfbGVhc2UoaW5v
ZGUpOw0KKwlpZiAoaG9zdF9lcnIpDQorCQlnb3RvIG91dF9wdXRfd3JpdGVfYWNjZXNzX25mc2Vy
cm9yOw0KKw0KKwlmaF9sb2NrKGZocCk7DQorCWhvc3RfZXJyID0gbm90aWZ5X2NoYW5nZShkZW50
cnksIGlhcCk7DQorCWZoX3VubG9jayhmaHApOw0KKw0KK291dF9wdXRfd3JpdGVfYWNjZXNzX25m
c2Vycm9yOg0KKwllcnIgPSBuZnNlcnJubyhob3N0X2Vycik7DQorb3V0X3B1dF93cml0ZV9hY2Nl
c3M6DQogCWlmIChzaXplX2NoYW5nZSkNCiAJCXB1dF93cml0ZV9hY2Nlc3MoaW5vZGUpOw0KIAlp
ZiAoIWVycikNCiAJCWNvbW1pdF9tZXRhZGF0YShmaHApOw0KIG91dDoNCiAJcmV0dXJuIGVycjsN
Ci0NCi1vdXRfbmZzZXJyOg0KLQllcnIgPSBuZnNlcnJubyhob3N0X2Vycik7DQotCWdvdG8gb3V0
Ow0KIH0NCiANCiAjaWYgZGVmaW5lZChDT05GSUdfTkZTRF9WMl9BQ0wpIHx8IFwNCmRpZmYgLS1n
aXQgYS9mcy94ZnMveGZzX2lvY3RsLmMgYi9mcy94ZnMveGZzX2lvY3RsLmMNCmluZGV4IGQ5OWE5
MDUuLmViNTE5ZGUgMTAwNjQ0DQotLS0gYS9mcy94ZnMveGZzX2lvY3RsLmMNCisrKyBiL2ZzL3hm
cy94ZnNfaW9jdGwuYw0KQEAgLTQwNCw3ICs0MDQsOCBAQCB4ZnNfYXR0cmxpc3RfYnlfaGFuZGxl
KA0KIAkJcmV0dXJuIC1YRlNfRVJST1IoRVBFUk0pOw0KIAlpZiAoY29weV9mcm9tX3VzZXIoJmFs
X2hyZXEsIGFyZywgc2l6ZW9mKHhmc19mc29wX2F0dHJsaXN0X2hhbmRsZXJlcV90KSkpDQogCQly
ZXR1cm4gLVhGU19FUlJPUihFRkFVTFQpOw0KLQlpZiAoYWxfaHJlcS5idWZsZW4gPiBYQVRUUl9M
SVNUX01BWCkNCisJaWYgKGFsX2hyZXEuYnVmbGVuIDwgc2l6ZW9mKHN0cnVjdCBhdHRybGlzdCkg
fHwNCisJICAgIGFsX2hyZXEuYnVmbGVuID4gWEFUVFJfTElTVF9NQVgpDQogCQlyZXR1cm4gLVhG
U19FUlJPUihFSU5WQUwpOw0KIA0KIAkvKg0KZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfaW9jdGwz
Mi5jIGIvZnMveGZzL3hmc19pb2N0bDMyLmMNCmluZGV4IDU0ZTYyM2IuLjBkNjg1YjMgMTAwNjQ0
DQotLS0gYS9mcy94ZnMveGZzX2lvY3RsMzIuYw0KKysrIGIvZnMveGZzL3hmc19pb2N0bDMyLmMN
CkBAIC0zNjEsNyArMzYxLDggQEAgeGZzX2NvbXBhdF9hdHRybGlzdF9ieV9oYW5kbGUoDQogCWlm
IChjb3B5X2Zyb21fdXNlcigmYWxfaHJlcSwgYXJnLA0KIAkJCSAgIHNpemVvZihjb21wYXRfeGZz
X2Zzb3BfYXR0cmxpc3RfaGFuZGxlcmVxX3QpKSkNCiAJCXJldHVybiAtWEZTX0VSUk9SKEVGQVVM
VCk7DQotCWlmIChhbF9ocmVxLmJ1ZmxlbiA+IFhBVFRSX0xJU1RfTUFYKQ0KKwlpZiAoYWxfaHJl
cS5idWZsZW4gPCBzaXplb2Yoc3RydWN0IGF0dHJsaXN0KSB8fA0KKwkgICAgYWxfaHJlcS5idWZs
ZW4gPiBYQVRUUl9MSVNUX01BWCkNCiAJCXJldHVybiAtWEZTX0VSUk9SKEVJTlZBTCk7DQogDQog
CS8qDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9jcnlwdG8vc2NhdHRlcndhbGsuaCBiL2luY2x1ZGUv
Y3J5cHRvL3NjYXR0ZXJ3YWxrLmgNCmluZGV4IDRmZDk1YTMuLjA1MzIyNzkgMTAwNjQ0DQotLS0g
YS9pbmNsdWRlL2NyeXB0by9zY2F0dGVyd2Fsay5oDQorKysgYi9pbmNsdWRlL2NyeXB0by9zY2F0
dGVyd2Fsay5oDQpAQCAtNTgsNiArNTgsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgc2NhdHRlcndh
bGtfc2dfY2hhaW4oc3RydWN0IHNjYXR0ZXJsaXN0ICpzZzEsIGludCBudW0sDQogew0KIAlzZ19z
ZXRfcGFnZSgmc2cxW251bSAtIDFdLCAodm9pZCAqKXNnMiwgMCwgMCk7DQogCXNnMVtudW0gLSAx
XS5wYWdlX2xpbmsgJj0gfjB4MDI7DQorCXNnMVtudW0gLSAxXS5wYWdlX2xpbmsgfD0gMHgwMTsN
CiB9DQogDQogc3RhdGljIGlubGluZSBzdHJ1Y3Qgc2NhdHRlcmxpc3QgKnNjYXR0ZXJ3YWxrX3Nn
X25leHQoc3RydWN0IHNjYXR0ZXJsaXN0ICpzZykNCkBAIC02NSw3ICs2Niw3IEBAIHN0YXRpYyBp
bmxpbmUgc3RydWN0IHNjYXR0ZXJsaXN0ICpzY2F0dGVyd2Fsa19zZ19uZXh0KHN0cnVjdCBzY2F0
dGVybGlzdCAqc2cpDQogCWlmIChzZ19pc19sYXN0KHNnKSkNCiAJCXJldHVybiBOVUxMOw0KIA0K
LQlyZXR1cm4gKCsrc2cpLT5sZW5ndGggPyBzZyA6ICh2b2lkICopc2dfcGFnZShzZyk7DQorCXJl
dHVybiAoKytzZyktPmxlbmd0aCA/IHNnIDogc2dfY2hhaW5fcHRyKHNnKTsNCiB9DQogDQogc3Rh
dGljIGlubGluZSB2b2lkIHNjYXR0ZXJ3YWxrX2NyeXB0b19jaGFpbihzdHJ1Y3Qgc2NhdHRlcmxp
c3QgKmhlYWQsDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9iaW5mbXRzLmggYi9pbmNsdWRl
L2xpbnV4L2JpbmZtdHMuaA0KaW5kZXggYWNkOGQ0Yi4uZDMzNzQxOSAxMDA2NDQNCi0tLSBhL2lu
Y2x1ZGUvbGludXgvYmluZm10cy5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2JpbmZtdHMuaA0KQEAg
LTExMiw5ICsxMTIsNiBAQCBleHRlcm4gdm9pZCBzZXR1cF9uZXdfZXhlYyhzdHJ1Y3QgbGludXhf
YmlucHJtICogYnBybSk7DQogZXh0ZXJuIHZvaWQgd291bGRfZHVtcChzdHJ1Y3QgbGludXhfYmlu
cHJtICosIHN0cnVjdCBmaWxlICopOw0KIA0KIGV4dGVybiBpbnQgc3VpZF9kdW1wYWJsZTsNCi0j
ZGVmaW5lIFNVSURfRFVNUF9ESVNBQkxFCTAJLyogTm8gc2V0dWlkIGR1bXBpbmcgKi8NCi0jZGVm
aW5lIFNVSURfRFVNUF9VU0VSCQkxCS8qIER1bXAgYXMgdXNlciBvZiBwcm9jZXNzICovDQotI2Rl
ZmluZSBTVUlEX0RVTVBfUk9PVAkJMgkvKiBEdW1wIGFzIHJvb3QgKi8NCiANCiAvKiBTdGFjayBh
cmVhIHByb3RlY3Rpb25zICovDQogI2RlZmluZSBFWFNUQUNLX0RFRkFVTFQgICAwCS8qIFdoYXRl
dmVyIHRoZSBhcmNoIGRlZmF1bHRzIHRvICovDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9j
b21waWxlci1pbnRlbC5oIGIvaW5jbHVkZS9saW51eC9jb21waWxlci1pbnRlbC5oDQppbmRleCBk
OGU2MzZlLi5jYmE5NTkzIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9jb21waWxlci1pbnRl
bC5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2NvbXBpbGVyLWludGVsLmgNCkBAIC0yNyw1ICsyNywz
IEBADQogI2RlZmluZSBfX211c3RfYmVfYXJyYXkoYSkgMA0KIA0KICNlbmRpZg0KLQ0KLSNkZWZp
bmUgdW5pbml0aWFsaXplZF92YXIoeCkgeA0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbXNn
LmggYi9pbmNsdWRlL2xpbnV4L21zZy5oDQppbmRleCA1NmFiZjE1NS4uNzBmYzM2OSAxMDA2NDQN
Ci0tLSBhL2luY2x1ZGUvbGludXgvbXNnLmgNCisrKyBiL2luY2x1ZGUvbGludXgvbXNnLmgNCkBA
IC03Niw5ICs3Niw5IEBAIHN0cnVjdCBtc2dpbmZvIHsNCiANCiAvKiBvbmUgbXNnX21zZyBzdHJ1
Y3R1cmUgZm9yIGVhY2ggbWVzc2FnZSAqLw0KIHN0cnVjdCBtc2dfbXNnIHsNCi0Jc3RydWN0IGxp
c3RfaGVhZCBtX2xpc3Q7IA0KLQlsb25nICBtX3R5cGU7ICAgICAgICAgIA0KLQlpbnQgbV90czsg
ICAgICAgICAgIC8qIG1lc3NhZ2UgdGV4dCBzaXplICovDQorCXN0cnVjdCBsaXN0X2hlYWQgbV9s
aXN0Ow0KKwlsb25nIG1fdHlwZTsNCisJc2l6ZV90IG1fdHM7CQkvKiBtZXNzYWdlIHRleHQgc2l6
ZSAqLw0KIAlzdHJ1Y3QgbXNnX21zZ3NlZyogbmV4dDsNCiAJdm9pZCAqc2VjdXJpdHk7DQogCS8q
IHRoZSBhY3R1YWwgbWVzc2FnZSBmb2xsb3dzIGltbWVkaWF0ZWx5ICovDQpkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9tdGQvbWFwLmggYi9pbmNsdWRlL2xpbnV4L210ZC9tYXAuaA0KaW5kZXgg
ZGFhZDRlNi4uMzg4NzkwMSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvbXRkL21hcC5oDQor
KysgYi9pbmNsdWRlL2xpbnV4L210ZC9tYXAuaA0KQEAgLTM2MSw3ICszNjEsNyBAQCBzdGF0aWMg
aW5saW5lIG1hcF93b3JkIG1hcF93b3JkX2xvYWRfcGFydGlhbChzdHJ1Y3QgbWFwX2luZm8gKm1h
cCwgbWFwX3dvcmQgb3JpZw0KIAkJCWJpdHBvcyA9IChtYXBfYmFua3dpZHRoKG1hcCktMS1pKSo4
Ow0KICNlbmRpZg0KIAkJCW9yaWcueFswXSAmPSB+KDB4ZmYgPDwgYml0cG9zKTsNCi0JCQlvcmln
LnhbMF0gfD0gYnVmW2ktc3RhcnRdIDw8IGJpdHBvczsNCisJCQlvcmlnLnhbMF0gfD0gKHVuc2ln
bmVkIGxvbmcpYnVmW2ktc3RhcnRdIDw8IGJpdHBvczsNCiAJCX0NCiAJfQ0KIAlyZXR1cm4gb3Jp
ZzsNCkBAIC0zODAsNyArMzgwLDcgQEAgc3RhdGljIGlubGluZSBtYXBfd29yZCBtYXBfd29yZF9m
ZihzdHJ1Y3QgbWFwX2luZm8gKm1hcCkNCiANCiAJaWYgKG1hcF9iYW5rd2lkdGgobWFwKSA8IE1B
UF9GRl9MSU1JVCkgew0KIAkJaW50IGJ3ID0gOCAqIG1hcF9iYW5rd2lkdGgobWFwKTsNCi0JCXIu
eFswXSA9ICgxIDw8IGJ3KSAtIDE7DQorCQlyLnhbMF0gPSAoMVVMIDw8IGJ3KSAtIDE7DQogCX0g
ZWxzZSB7DQogCQlmb3IgKGk9MDsgaTxtYXBfd29yZHMobWFwKTsgaSsrKQ0KIAkJCXIueFtpXSA9
IH4wVUw7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9uZXQuaCBiL2luY2x1ZGUvbGludXgv
bmV0LmgNCmluZGV4IGI3Y2EwOGUuLmJkNGY2YzcgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4
L25ldC5oDQorKysgYi9pbmNsdWRlL2xpbnV4L25ldC5oDQpAQCAtMTk3LDYgKzE5NywxNCBAQCBz
dHJ1Y3QgcHJvdG9fb3BzIHsNCiAjZW5kaWYNCiAJaW50CQkoKnNlbmRtc2cpICAgKHN0cnVjdCBr
aW9jYiAqaW9jYiwgc3RydWN0IHNvY2tldCAqc29jaywNCiAJCQkJICAgICAgc3RydWN0IG1zZ2hk
ciAqbSwgc2l6ZV90IHRvdGFsX2xlbik7DQorCS8qIE5vdGVzIGZvciBpbXBsZW1lbnRpbmcgcmVj
dm1zZzoNCisJICogPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KKwkgKiBtc2ctPm1z
Z19uYW1lbGVuIHNob3VsZCBnZXQgdXBkYXRlZCBieSB0aGUgcmVjdm1zZyBoYW5kbGVycw0KKwkg
KiBpZmYgbXNnX25hbWUgIT0gTlVMTC4gSXQgaXMgYnkgZGVmYXVsdCAwIHRvIHByZXZlbnQNCisJ
ICogcmV0dXJuaW5nIHVuaW5pdGlhbGl6ZWQgbWVtb3J5IHRvIHVzZXIgc3BhY2UuICBUaGUgcmVj
dmZyb20NCisJICogaGFuZGxlcnMgY2FuIGFzc3VtZSB0aGF0IG1zZy5tc2dfbmFtZSBpcyBlaXRo
ZXIgTlVMTCBvciBoYXMNCisJICogYSBtaW5pbXVtIHNpemUgb2Ygc2l6ZW9mKHN0cnVjdCBzb2Nr
YWRkcl9zdG9yYWdlKS4NCisJICovDQogCWludAkJKCpyZWN2bXNnKSAgIChzdHJ1Y3Qga2lvY2Ig
KmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCQkJCSAgICAgIHN0cnVjdCBtc2doZHIgKm0s
IHNpemVfdCB0b3RhbF9sZW4sDQogCQkJCSAgICAgIGludCBmbGFncyk7DQpkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9wY2lfaWRzLmggYi9pbmNsdWRlL2xpbnV4L3BjaV9pZHMuaA0KaW5kZXgg
M2RiM2RhMS4uZDkzZjQxNyAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvcGNpX2lkcy5oDQor
KysgYi9pbmNsdWRlL2xpbnV4L3BjaV9pZHMuaA0KQEAgLTE1NzksNiArMTU3OSw3IEBADQogI2Rl
ZmluZSBQQ0lfU1VCREVWSUNFX0lEX0tFWVNQQU5fU1gyCTB4NTMzNA0KIA0KICNkZWZpbmUgUENJ
X1ZFTkRPUl9JRF9NQVJWRUxMCQkweDExYWINCisjZGVmaW5lIFBDSV9WRU5ET1JfSURfTUFSVkVM
TF9FWFQJMHgxYjRiDQogI2RlZmluZSBQQ0lfREVWSUNFX0lEX01BUlZFTExfR1Q2NDExMQkweDQx
NDYNCiAjZGVmaW5lIFBDSV9ERVZJQ0VfSURfTUFSVkVMTF9HVDY0MjYwCTB4NjQzMA0KICNkZWZp
bmUgUENJX0RFVklDRV9JRF9NQVJWRUxMX01WNjQzNjAJMHg2NDYwDQpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9saW51eC9yYW5kb20uaCBiL2luY2x1ZGUvbGludXgvcmFuZG9tLmgNCmluZGV4IDdlNzdj
ZWUuLmY1ZTEzMTEgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3JhbmRvbS5oDQorKysgYi9p
bmNsdWRlL2xpbnV4L3JhbmRvbS5oDQpAQCAtODksOSArODksOSBAQCBzdGF0aWMgaW5saW5lIHZv
aWQgcHJhbmRvbTMyX3NlZWQoc3RydWN0IHJuZF9zdGF0ZSAqc3RhdGUsIHU2NCBzZWVkKQ0KIHsN
CiAJdTMyIGkgPSAoc2VlZCA+PiAzMikgXiAoc2VlZCA8PCAxMCkgXiBzZWVkOw0KIA0KLQlzdGF0
ZS0+czEgPSBfX3NlZWQoaSwgMSk7DQotCXN0YXRlLT5zMiA9IF9fc2VlZChpLCA3KTsNCi0Jc3Rh
dGUtPnMzID0gX19zZWVkKGksIDE1KTsNCisJc3RhdGUtPnMxID0gX19zZWVkKGksIDIpOw0KKwlz
dGF0ZS0+czIgPSBfX3NlZWQoaSwgOCk7DQorCXN0YXRlLT5zMyA9IF9fc2VlZChpLCAxNik7DQog
fQ0KIA0KICNpZmRlZiBDT05GSUdfQVJDSF9SQU5ET00NCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L3NjaGVkLmggYi9pbmNsdWRlL2xpbnV4L3NjaGVkLmgNCmluZGV4IDgyMDQ4OTguLjMxMmQw
NDcgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L3NjaGVkLmgNCisrKyBiL2luY2x1ZGUvbGlu
dXgvc2NoZWQuaA0KQEAgLTQwMyw2ICs0MDMsMTAgQEAgc3RhdGljIGlubGluZSB2b2lkIGFyY2hf
cGlja19tbWFwX2xheW91dChzdHJ1Y3QgbW1fc3RydWN0ICptbSkge30NCiBleHRlcm4gdm9pZCBz
ZXRfZHVtcGFibGUoc3RydWN0IG1tX3N0cnVjdCAqbW0sIGludCB2YWx1ZSk7DQogZXh0ZXJuIGlu
dCBnZXRfZHVtcGFibGUoc3RydWN0IG1tX3N0cnVjdCAqbW0pOw0KIA0KKyNkZWZpbmUgU1VJRF9E
VU1QX0RJU0FCTEUJMAkvKiBObyBzZXR1aWQgZHVtcGluZyAqLw0KKyNkZWZpbmUgU1VJRF9EVU1Q
X1VTRVIJCTEJLyogRHVtcCBhcyB1c2VyIG9mIHByb2Nlc3MgKi8NCisjZGVmaW5lIFNVSURfRFVN
UF9ST09UCQkyCS8qIER1bXAgYXMgcm9vdCAqLw0KKw0KIC8qIG1tIGZsYWdzICovDQogLyogZHVt
cGFibGUgYml0cyAqLw0KICNkZWZpbmUgTU1GX0RVTVBBQkxFICAgICAgMCAgLyogY29yZSBkdW1w
IGlzIHBlcm1pdHRlZCAqLw0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2lwLmggYi9pbmNsdWRl
L25ldC9pcC5oDQppbmRleCAwNmFlZDcyLi5iOTM1ZTZjIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9u
ZXQvaXAuaA0KKysrIGIvaW5jbHVkZS9uZXQvaXAuaA0KQEAgLTQ2Niw3ICs0NjYsNyBAQCBleHRl
cm4gaW50CWNvbXBhdF9pcF9nZXRzb2Nrb3B0KHN0cnVjdCBzb2NrICpzaywgaW50IGxldmVsLA0K
IAkJCWludCBvcHRuYW1lLCBjaGFyIF9fdXNlciAqb3B0dmFsLCBpbnQgX191c2VyICpvcHRsZW4p
Ow0KIGV4dGVybiBpbnQJaXBfcmFfY29udHJvbChzdHJ1Y3Qgc29jayAqc2ssIHVuc2lnbmVkIGNo
YXIgb24sIHZvaWQgKCpkZXN0cnVjdG9yKShzdHJ1Y3Qgc29jayAqKSk7DQogDQotZXh0ZXJuIGlu
dCAJaXBfcmVjdl9lcnJvcihzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBtc2doZHIgKm1zZywgaW50
IGxlbik7DQorZXh0ZXJuIGludCAJaXBfcmVjdl9lcnJvcihzdHJ1Y3Qgc29jayAqc2ssIHN0cnVj
dCBtc2doZHIgKm1zZywgaW50IGxlbiwgaW50ICphZGRyX2xlbik7DQogZXh0ZXJuIHZvaWQJaXBf
aWNtcF9lcnJvcihzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19idWZmICpza2IsIGludCBlcnIs
IA0KIAkJCSAgICAgIF9fYmUxNiBwb3J0LCB1MzIgaW5mbywgdTggKnBheWxvYWQpOw0KIGV4dGVy
biB2b2lkCWlwX2xvY2FsX2Vycm9yKHN0cnVjdCBzb2NrICpzaywgaW50IGVyciwgX19iZTMyIGRh
ZGRyLCBfX2JlMTYgZHBvcnQsDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvaXB2Ni5oIGIvaW5j
bHVkZS9uZXQvaXB2Ni5oDQppbmRleCA0ZDU0OWNmLi4wNTgwNjczIDEwMDY0NA0KLS0tIGEvaW5j
bHVkZS9uZXQvaXB2Ni5oDQorKysgYi9pbmNsdWRlL25ldC9pcHY2LmgNCkBAIC02MDIsOCArNjAy
LDEwIEBAIGV4dGVybiBpbnQJCQljb21wYXRfaXB2Nl9nZXRzb2Nrb3B0KHN0cnVjdCBzb2NrICpz
aywNCiBleHRlcm4gaW50CQkJaXA2X2RhdGFncmFtX2Nvbm5lY3Qoc3RydWN0IHNvY2sgKnNrLCAN
CiAJCQkJCQkgICAgIHN0cnVjdCBzb2NrYWRkciAqYWRkciwgaW50IGFkZHJfbGVuKTsNCiANCi1l
eHRlcm4gaW50IAkJCWlwdjZfcmVjdl9lcnJvcihzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBtc2do
ZHIgKm1zZywgaW50IGxlbik7DQotZXh0ZXJuIGludCAJCQlpcHY2X3JlY3ZfcnhwbXR1KHN0cnVj
dCBzb2NrICpzaywgc3RydWN0IG1zZ2hkciAqbXNnLCBpbnQgbGVuKTsNCitleHRlcm4gaW50IAkJ
CWlwdjZfcmVjdl9lcnJvcihzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBtc2doZHIgKm1zZywgaW50
IGxlbiwNCisJCQkJCQlpbnQgKmFkZHJfbGVuKTsNCitleHRlcm4gaW50IAkJCWlwdjZfcmVjdl9y
eHBtdHUoc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3QgbXNnaGRyICptc2csIGludCBsZW4sDQorCQkJ
CQkJIGludCAqYWRkcl9sZW4pOw0KIGV4dGVybiB2b2lkCQkJaXB2Nl9pY21wX2Vycm9yKHN0cnVj
dCBzb2NrICpzaywgc3RydWN0IHNrX2J1ZmYgKnNrYiwgaW50IGVyciwgX19iZTE2IHBvcnQsDQog
CQkJCQkJdTMyIGluZm8sIHU4ICpwYXlsb2FkKTsNCiBleHRlcm4gdm9pZAkJCWlwdjZfbG9jYWxf
ZXJyb3Ioc3RydWN0IHNvY2sgKnNrLCBpbnQgZXJyLCBzdHJ1Y3QgZmxvd2k2ICpmbDYsIHUzMiBp
bmZvKTsNCmRpZmYgLS1naXQgYS9pbmNsdWRlL3NvdW5kL21lbWFsbG9jLmggYi9pbmNsdWRlL3Nv
dW5kL21lbWFsbG9jLmgNCmluZGV4IGM0MjUwNjIuLmFiMjQwYmIgMTAwNjQ0DQotLS0gYS9pbmNs
dWRlL3NvdW5kL21lbWFsbG9jLmgNCisrKyBiL2luY2x1ZGUvc291bmQvbWVtYWxsb2MuaA0KQEAg
LTEwMSw3ICsxMDEsNyBAQCBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludCBzbmRfc2didWZfYWxp
Z25lZF9wYWdlcyhzaXplX3Qgc2l6ZSkNCiBzdGF0aWMgaW5saW5lIGRtYV9hZGRyX3Qgc25kX3Nn
YnVmX2dldF9hZGRyKHN0cnVjdCBzbmRfc2dfYnVmICpzZ2J1Ziwgc2l6ZV90IG9mZnNldCkNCiB7
DQogCWRtYV9hZGRyX3QgYWRkciA9IHNnYnVmLT50YWJsZVtvZmZzZXQgPj4gUEFHRV9TSElGVF0u
YWRkcjsNCi0JYWRkciAmPSBQQUdFX01BU0s7DQorCWFkZHIgJj0gfigoZG1hX2FkZHJfdClQQUdF
X1NJWkUgLSAxKTsNCiAJcmV0dXJuIGFkZHIgKyBvZmZzZXQgJSBQQUdFX1NJWkU7DQogfQ0KIA0K
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvdHJhY2UvZnRyYWNlLmggYi9pbmNsdWRlL3RyYWNlL2Z0cmFj
ZS5oDQppbmRleCA3Njk3MjQ5Li43NjNiZjA1IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS90cmFjZS9m
dHJhY2UuaA0KKysrIGIvaW5jbHVkZS90cmFjZS9mdHJhY2UuaA0KQEAgLTM3OSw3ICszNzksOCBA
QCBmdHJhY2VfZGVmaW5lX2ZpZWxkc18jI2NhbGwoc3RydWN0IGZ0cmFjZV9ldmVudF9jYWxsICpl
dmVudF9jYWxsKQlcDQogCV9fZGF0YV9zaXplICs9IChsZW4pICogc2l6ZW9mKHR5cGUpOw0KIA0K
ICN1bmRlZiBfX3N0cmluZw0KLSNkZWZpbmUgX19zdHJpbmcoaXRlbSwgc3JjKSBfX2R5bmFtaWNf
YXJyYXkoY2hhciwgaXRlbSwgc3RybGVuKHNyYykgKyAxKQ0KKyNkZWZpbmUgX19zdHJpbmcoaXRl
bSwgc3JjKSBfX2R5bmFtaWNfYXJyYXkoY2hhciwgaXRlbSwJCQlcDQorCQkgICAgc3RybGVuKChz
cmMpID8gKGNvbnN0IGNoYXIgKikoc3JjKSA6ICIobnVsbCkiKSArIDEpDQogDQogI3VuZGVmIERF
Q0xBUkVfRVZFTlRfQ0xBU1MNCiAjZGVmaW5lIERFQ0xBUkVfRVZFTlRfQ0xBU1MoY2FsbCwgcHJv
dG8sIGFyZ3MsIHRzdHJ1Y3QsIGFzc2lnbiwgcHJpbnQpCVwNCkBAIC01MDQsNyArNTA1LDcgQEAg
c3RhdGljIGlubGluZSBub3RyYWNlIGludCBmdHJhY2VfZ2V0X29mZnNldHNfIyNjYWxsKAkJCVwN
CiANCiAjdW5kZWYgX19hc3NpZ25fc3RyDQogI2RlZmluZSBfX2Fzc2lnbl9zdHIoZHN0LCBzcmMp
CQkJCQkJXA0KLQlzdHJjcHkoX19nZXRfc3RyKGRzdCksIHNyYyk7DQorCXN0cmNweShfX2dldF9z
dHIoZHN0KSwgKHNyYykgPyAoY29uc3QgY2hhciAqKShzcmMpIDogIihudWxsKSIpOw0KIA0KICN1
bmRlZiBUUF9mYXN0X2Fzc2lnbg0KICNkZWZpbmUgVFBfZmFzdF9hc3NpZ24oYXJncy4uLikgYXJn
cw0KZGlmZiAtLWdpdCBhL2lwYy9tc2d1dGlsLmMgYi9pcGMvbXNndXRpbC5jDQppbmRleCA1NjUy
MTAxLi5mYzZmZGVkIDEwMDY0NA0KLS0tIGEvaXBjL21zZ3V0aWwuYw0KKysrIGIvaXBjL21zZ3V0
aWwuYw0KQEAgLTM3LDE1ICszNywxNSBAQCBzdHJ1Y3QgbXNnX21zZ3NlZyB7DQogCS8qIHRoZSBu
ZXh0IHBhcnQgb2YgdGhlIG1lc3NhZ2UgZm9sbG93cyBpbW1lZGlhdGVseSAqLw0KIH07DQogDQot
I2RlZmluZSBEQVRBTEVOX01TRwkoUEFHRV9TSVpFLXNpemVvZihzdHJ1Y3QgbXNnX21zZykpDQot
I2RlZmluZSBEQVRBTEVOX1NFRwkoUEFHRV9TSVpFLXNpemVvZihzdHJ1Y3QgbXNnX21zZ3NlZykp
DQorI2RlZmluZSBEQVRBTEVOX01TRwkoKHNpemVfdClQQUdFX1NJWkUtc2l6ZW9mKHN0cnVjdCBt
c2dfbXNnKSkNCisjZGVmaW5lIERBVEFMRU5fU0VHCSgoc2l6ZV90KVBBR0VfU0laRS1zaXplb2Yo
c3RydWN0IG1zZ19tc2dzZWcpKQ0KIA0KLXN0cnVjdCBtc2dfbXNnICpsb2FkX21zZyhjb25zdCB2
b2lkIF9fdXNlciAqc3JjLCBpbnQgbGVuKQ0KK3N0cnVjdCBtc2dfbXNnICpsb2FkX21zZyhjb25z
dCB2b2lkIF9fdXNlciAqc3JjLCBzaXplX3QgbGVuKQ0KIHsNCiAJc3RydWN0IG1zZ19tc2cgKm1z
ZzsNCiAJc3RydWN0IG1zZ19tc2dzZWcgKipwc2VnOw0KIAlpbnQgZXJyOw0KLQlpbnQgYWxlbjsN
CisJc2l6ZV90IGFsZW47DQogDQogCWFsZW4gPSBsZW47DQogCWlmIChhbGVuID4gREFUQUxFTl9N
U0cpDQpAQCAtOTksOSArOTksOSBAQCBvdXRfZXJyOg0KIAlyZXR1cm4gRVJSX1BUUihlcnIpOw0K
IH0NCiANCi1pbnQgc3RvcmVfbXNnKHZvaWQgX191c2VyICpkZXN0LCBzdHJ1Y3QgbXNnX21zZyAq
bXNnLCBpbnQgbGVuKQ0KK2ludCBzdG9yZV9tc2codm9pZCBfX3VzZXIgKmRlc3QsIHN0cnVjdCBt
c2dfbXNnICptc2csIHNpemVfdCBsZW4pDQogew0KLQlpbnQgYWxlbjsNCisJc2l6ZV90IGFsZW47
DQogCXN0cnVjdCBtc2dfbXNnc2VnICpzZWc7DQogDQogCWFsZW4gPSBsZW47DQpkaWZmIC0tZ2l0
IGEvaXBjL3V0aWwuaCBiL2lwYy91dGlsLmgNCmluZGV4IDZmNWMyMGIuLjBiZmM5MzQgMTAwNjQ0
DQotLS0gYS9pcGMvdXRpbC5oDQorKysgYi9pcGMvdXRpbC5oDQpAQCAtMTM4LDggKzEzOCw4IEBA
IGludCBpcGNfcGFyc2VfdmVyc2lvbiAoaW50ICpjbWQpOw0KICNlbmRpZg0KIA0KIGV4dGVybiB2
b2lkIGZyZWVfbXNnKHN0cnVjdCBtc2dfbXNnICptc2cpOw0KLWV4dGVybiBzdHJ1Y3QgbXNnX21z
ZyAqbG9hZF9tc2coY29uc3Qgdm9pZCBfX3VzZXIgKnNyYywgaW50IGxlbik7DQotZXh0ZXJuIGlu
dCBzdG9yZV9tc2codm9pZCBfX3VzZXIgKmRlc3QsIHN0cnVjdCBtc2dfbXNnICptc2csIGludCBs
ZW4pOw0KK2V4dGVybiBzdHJ1Y3QgbXNnX21zZyAqbG9hZF9tc2coY29uc3Qgdm9pZCBfX3VzZXIg
KnNyYywgc2l6ZV90IGxlbik7DQorZXh0ZXJuIGludCBzdG9yZV9tc2codm9pZCBfX3VzZXIgKmRl
c3QsIHN0cnVjdCBtc2dfbXNnICptc2csIHNpemVfdCBsZW4pOw0KIA0KIGV4dGVybiB2b2lkIHJl
Y29tcHV0ZV9tc2dtbmkoc3RydWN0IGlwY19uYW1lc3BhY2UgKik7DQogDQpkaWZmIC0tZ2l0IGEv
a2VybmVsL2F1ZGl0LmMgYi9rZXJuZWwvYXVkaXQuYw0KaW5kZXggZDRiYzU5NC4uZTE0YmM3NCAx
MDA2NDQNCi0tLSBhL2tlcm5lbC9hdWRpdC5jDQorKysgYi9rZXJuZWwvYXVkaXQuYw0KQEAgLTYy
NSw3ICs2MjUsNyBAQCBzdGF0aWMgaW50IGF1ZGl0X2xvZ19jb21tb25fcmVjdl9tc2coc3RydWN0
IGF1ZGl0X2J1ZmZlciAqKmFiLCB1MTYgbXNnX3R5cGUsDQogCWNoYXIgKmN0eCA9IE5VTEw7DQog
CXUzMiBsZW47DQogDQotCWlmICghYXVkaXRfZW5hYmxlZCkgew0KKwlpZiAoIWF1ZGl0X2VuYWJs
ZWQgJiYgbXNnX3R5cGUgIT0gQVVESVRfVVNFUl9BVkMpIHsNCiAJCSphYiA9IE5VTEw7DQogCQly
ZXR1cm4gcmM7DQogCX0NCkBAIC02ODQsNiArNjg0LDcgQEAgc3RhdGljIGludCBhdWRpdF9yZWNl
aXZlX21zZyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3Qgbmxtc2doZHIgKm5saCkNCiANCiAJ
c3dpdGNoIChtc2dfdHlwZSkgew0KIAljYXNlIEFVRElUX0dFVDoNCisJCXN0YXR1c19zZXQubWFz
awkJID0gMDsNCiAJCXN0YXR1c19zZXQuZW5hYmxlZAkgPSBhdWRpdF9lbmFibGVkOw0KIAkJc3Rh
dHVzX3NldC5mYWlsdXJlCSA9IGF1ZGl0X2ZhaWx1cmU7DQogCQlzdGF0dXNfc2V0LnBpZAkJID0g
YXVkaXRfcGlkOw0KQEAgLTY5NSw3ICs2OTYsNyBAQCBzdGF0aWMgaW50IGF1ZGl0X3JlY2VpdmVf
bXNnKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBubG1zZ2hkciAqbmxoKQ0KIAkJCQkgJnN0
YXR1c19zZXQsIHNpemVvZihzdGF0dXNfc2V0KSk7DQogCQlicmVhazsNCiAJY2FzZSBBVURJVF9T
RVQ6DQotCQlpZiAobmxoLT5ubG1zZ19sZW4gPCBzaXplb2Yoc3RydWN0IGF1ZGl0X3N0YXR1cykp
DQorCQlpZiAobmxtc2dfbGVuKG5saCkgPCBzaXplb2Yoc3RydWN0IGF1ZGl0X3N0YXR1cykpDQog
CQkJcmV0dXJuIC1FSU5WQUw7DQogCQlzdGF0dXNfZ2V0ICAgPSAoc3RydWN0IGF1ZGl0X3N0YXR1
cyAqKWRhdGE7DQogCQlpZiAoc3RhdHVzX2dldC0+bWFzayAmIEFVRElUX1NUQVRVU19FTkFCTEVE
KSB7DQpAQCAtODk5LDcgKzkwMCw3IEBAIHN0YXRpYyBpbnQgYXVkaXRfcmVjZWl2ZV9tc2coc3Ry
dWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5sbXNnaGRyICpubGgpDQogCQlzdHJ1Y3QgdGFza19z
dHJ1Y3QgKnRzazsNCiAJCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQogDQotCQlpZiAobmxoLT5ubG1z
Z19sZW4gPCBzaXplb2Yoc3RydWN0IGF1ZGl0X3R0eV9zdGF0dXMpKQ0KKwkJaWYgKG5sbXNnX2xl
bihubGgpIDwgc2l6ZW9mKHN0cnVjdCBhdWRpdF90dHlfc3RhdHVzKSkNCiAJCQlyZXR1cm4gLUVJ
TlZBTDsNCiAJCXMgPSBkYXRhOw0KIAkJaWYgKHMtPmVuYWJsZWQgIT0gMCAmJiBzLT5lbmFibGVk
ICE9IDEpDQpkaWZmIC0tZ2l0IGEva2VybmVsL2NwdXNldC5jIGIva2VybmVsL2NwdXNldC5jDQpp
bmRleCA4MzVlZWU2Li41N2ViOThkIDEwMDY0NA0KLS0tIGEva2VybmVsL2NwdXNldC5jDQorKysg
Yi9rZXJuZWwvY3B1c2V0LmMNCkBAIC05ODMsOCArOTgzLDEwIEBAIHN0YXRpYyB2b2lkIGNwdXNl
dF9jaGFuZ2VfdGFza19ub2RlbWFzayhzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzaywNCiAJbmVlZF9s
b29wID0gdGFza19oYXNfbWVtcG9saWN5KHRzaykgfHwNCiAJCQkhbm9kZXNfaW50ZXJzZWN0cygq
bmV3bWVtcywgdHNrLT5tZW1zX2FsbG93ZWQpOw0KIA0KLQlpZiAobmVlZF9sb29wKQ0KKwlpZiAo
bmVlZF9sb29wKSB7DQorCQlsb2NhbF9pcnFfZGlzYWJsZSgpOw0KIAkJd3JpdGVfc2VxY291bnRf
YmVnaW4oJnRzay0+bWVtc19hbGxvd2VkX3NlcSk7DQorCX0NCiANCiAJbm9kZXNfb3IodHNrLT5t
ZW1zX2FsbG93ZWQsIHRzay0+bWVtc19hbGxvd2VkLCAqbmV3bWVtcyk7DQogCW1wb2xfcmViaW5k
X3Rhc2sodHNrLCBuZXdtZW1zLCBNUE9MX1JFQklORF9TVEVQMSk7DQpAQCAtOTkyLDggKzk5NCwx
MCBAQCBzdGF0aWMgdm9pZCBjcHVzZXRfY2hhbmdlX3Rhc2tfbm9kZW1hc2soc3RydWN0IHRhc2tf
c3RydWN0ICp0c2ssDQogCW1wb2xfcmViaW5kX3Rhc2sodHNrLCBuZXdtZW1zLCBNUE9MX1JFQklO
RF9TVEVQMik7DQogCXRzay0+bWVtc19hbGxvd2VkID0gKm5ld21lbXM7DQogDQotCWlmIChuZWVk
X2xvb3ApDQorCWlmIChuZWVkX2xvb3ApIHsNCiAJCXdyaXRlX3NlcWNvdW50X2VuZCgmdHNrLT5t
ZW1zX2FsbG93ZWRfc2VxKTsNCisJCWxvY2FsX2lycV9lbmFibGUoKTsNCisJfQ0KIA0KIAl0YXNr
X3VubG9jayh0c2spOw0KIH0NCmRpZmYgLS1naXQgYS9rZXJuZWwvZnV0ZXguYyBiL2tlcm5lbC9m
dXRleC5jDQppbmRleCAxZDA1MzhlLi44ODg4ODE1IDEwMDY0NA0KLS0tIGEva2VybmVsL2Z1dGV4
LmMNCisrKyBiL2tlcm5lbC9mdXRleC5jDQpAQCAtMjg1LDcgKzI4NSw3IEBAIGFnYWluOg0KIAkJ
cHV0X3BhZ2UocGFnZSk7DQogCQkvKiBzZXJpYWxpemUgYWdhaW5zdCBfX3NwbGl0X2h1Z2VfcGFn
ZV9zcGxpdHRpbmcoKSAqLw0KIAkJbG9jYWxfaXJxX2Rpc2FibGUoKTsNCi0JCWlmIChsaWtlbHko
X19nZXRfdXNlcl9wYWdlc19mYXN0KGFkZHJlc3MsIDEsIDEsICZwYWdlKSA9PSAxKSkgew0KKwkJ
aWYgKGxpa2VseShfX2dldF91c2VyX3BhZ2VzX2Zhc3QoYWRkcmVzcywgMSwgIXJvLCAmcGFnZSkg
PT0gMSkpIHsNCiAJCQlwYWdlX2hlYWQgPSBjb21wb3VuZF9oZWFkKHBhZ2UpOw0KIAkJCS8qDQog
CQkJICogcGFnZV9oZWFkIGlzIHZhbGlkIHBvaW50ZXIgYnV0IHdlIG11c3QgcGluDQpkaWZmIC0t
Z2l0IGEva2VybmVsL2lycS9wbS5jIGIva2VybmVsL2lycS9wbS5jDQppbmRleCAxNWU1M2IxLi5k
Y2QzZjk3IDEwMDY0NA0KLS0tIGEva2VybmVsL2lycS9wbS5jDQorKysgYi9rZXJuZWwvaXJxL3Bt
LmMNCkBAIC01MCw3ICs1MCw3IEBAIHN0YXRpYyB2b2lkIHJlc3VtZV9pcnFzKGJvb2wgd2FudF9l
YXJseSkNCiAJCWJvb2wgaXNfZWFybHkgPSBkZXNjLT5hY3Rpb24gJiYNCiAJCQlkZXNjLT5hY3Rp
b24tPmZsYWdzICYgSVJRRl9FQVJMWV9SRVNVTUU7DQogDQotCQlpZiAoaXNfZWFybHkgIT0gd2Fu
dF9lYXJseSkNCisJCWlmICghaXNfZWFybHkgJiYgd2FudF9lYXJseSkNCiAJCQljb250aW51ZTsN
CiANCiAJCXJhd19zcGluX2xvY2tfaXJxc2F2ZSgmZGVzYy0+bG9jaywgZmxhZ3MpOw0KZGlmZiAt
LWdpdCBhL2tlcm5lbC9wb3dlci9zbmFwc2hvdC5jIGIva2VybmVsL3Bvd2VyL3NuYXBzaG90LmMN
CmluZGV4IGNiZTJjMTQuLjM4MDI5MWUgMTAwNjQ0DQotLS0gYS9rZXJuZWwvcG93ZXIvc25hcHNo
b3QuYw0KKysrIGIva2VybmVsL3Bvd2VyL3NuYXBzaG90LmMNCkBAIC0xMzkwLDcgKzEzOTAsMTEg
QEAgaW50IGhpYmVybmF0ZV9wcmVhbGxvY2F0ZV9tZW1vcnkodm9pZCkNCiAJICogaGlnaG1lbSBh
bmQgbm9uLWhpZ2htZW0gem9uZXMgc2VwYXJhdGVseS4NCiAJICovDQogCXBhZ2VzX2hpZ2htZW0g
PSBwcmVhbGxvY2F0ZV9pbWFnZV9oaWdobWVtKGhpZ2htZW0gLyAyKTsNCi0JYWxsb2MgPSAoY291
bnQgLSBtYXhfc2l6ZSkgLSBwYWdlc19oaWdobWVtOw0KKwlhbGxvYyA9IGNvdW50IC0gbWF4X3Np
emU7DQorCWlmIChhbGxvYyA+IHBhZ2VzX2hpZ2htZW0pDQorCQlhbGxvYyAtPSBwYWdlc19oaWdo
bWVtOw0KKwllbHNlDQorCQlhbGxvYyA9IDA7DQogCXBhZ2VzID0gcHJlYWxsb2NhdGVfaW1hZ2Vf
bWVtb3J5KGFsbG9jLCBhdmFpbF9ub3JtYWwpOw0KIAlpZiAocGFnZXMgPCBhbGxvYykgew0KIAkJ
LyogV2UgaGF2ZSBleGhhdXN0ZWQgbm9uLWhpZ2htZW0gcGFnZXMsIHRyeSBoaWdobWVtLiAqLw0K
ZGlmZiAtLWdpdCBhL2tlcm5lbC9wdHJhY2UuYyBiL2tlcm5lbC9wdHJhY2UuYw0KaW5kZXggNjdm
ZWRhZC4uZjc5ODAzYSAxMDA2NDQNCi0tLSBhL2tlcm5lbC9wdHJhY2UuYw0KKysrIGIva2VybmVs
L3B0cmFjZS5jDQpAQCAtMjQ2LDcgKzI0Niw4IEBAIG9rOg0KIAlzbXBfcm1iKCk7DQogCWlmICh0
YXNrLT5tbSkNCiAJCWR1bXBhYmxlID0gZ2V0X2R1bXBhYmxlKHRhc2stPm1tKTsNCi0JaWYgKCFk
dW1wYWJsZSAmJiAhdGFza19uc19jYXBhYmxlKHRhc2ssIENBUF9TWVNfUFRSQUNFKSkNCisJaWYg
KGR1bXBhYmxlICE9IFNVSURfRFVNUF9VU0VSICYmDQorCSAgICAhdGFza19uc19jYXBhYmxlKHRh
c2ssIENBUF9TWVNfUFRSQUNFKSkNCiAJCXJldHVybiAtRVBFUk07DQogDQogCXJldHVybiBzZWN1
cml0eV9wdHJhY2VfYWNjZXNzX2NoZWNrKHRhc2ssIG1vZGUpOw0KZGlmZiAtLWdpdCBhL2tlcm5l
bC9zY2hlZF9kZWJ1Zy5jIGIva2VybmVsL3NjaGVkX2RlYnVnLmMNCmluZGV4IGE2NzEwYTEuLmY0
MDEwZTIgMTAwNjQ0DQotLS0gYS9rZXJuZWwvc2NoZWRfZGVidWcuYw0KKysrIGIva2VybmVsL3Nj
aGVkX2RlYnVnLmMNCkBAIC0yMTMsNiArMjEzLDE0IEBAIHZvaWQgcHJpbnRfY2ZzX3JxKHN0cnVj
dCBzZXFfZmlsZSAqbSwgaW50IGNwdSwgc3RydWN0IGNmc19ycSAqY2ZzX3JxKQ0KIAlTRVFfcHJp
bnRmKG0sICIgIC4lLTMwczogJWRcbiIsICJsb2FkX3RnIiwNCiAJCQlhdG9taWNfcmVhZCgmY2Zz
X3JxLT50Zy0+bG9hZF93ZWlnaHQpKTsNCiAjZW5kaWYNCisjaWZkZWYgQ09ORklHX0NGU19CQU5E
V0lEVEgNCisJU0VRX3ByaW50ZihtLCAiICAuJS0zMHM6ICVkXG4iLCAidGctPmNmc19iYW5kd2lk
dGgudGltZXJfYWN0aXZlIiwNCisJCQljZnNfcnEtPnRnLT5jZnNfYmFuZHdpZHRoLnRpbWVyX2Fj
dGl2ZSk7DQorCVNFUV9wcmludGYobSwgIiAgLiUtMzBzOiAlZFxuIiwgInRocm90dGxlZCIsDQor
CQkJY2ZzX3JxLT50aHJvdHRsZWQpOw0KKwlTRVFfcHJpbnRmKG0sICIgIC4lLTMwczogJWRcbiIs
ICJ0aHJvdHRsZV9jb3VudCIsDQorCQkJY2ZzX3JxLT50aHJvdHRsZV9jb3VudCk7DQorI2VuZGlm
DQogDQogCXByaW50X2Nmc19ncm91cF9zdGF0cyhtLCBjcHUsIGNmc19ycS0+dGcpOw0KICNlbmRp
Zg0KZGlmZiAtLWdpdCBhL2tlcm5lbC9zY2hlZF9mYWlyLmMgYi9rZXJuZWwvc2NoZWRfZmFpci5j
DQppbmRleCBjMjYxZGE3Li41YjllNDU2IDEwMDY0NA0KLS0tIGEva2VybmVsL3NjaGVkX2ZhaXIu
Yw0KKysrIGIva2VybmVsL3NjaGVkX2ZhaXIuYw0KQEAgLTE1MjcsNiArMTUyNyw4IEBAIHN0YXRp
YyB2b2lkIHRocm90dGxlX2Nmc19ycShzdHJ1Y3QgY2ZzX3JxICpjZnNfcnEpDQogCWNmc19ycS0+
dGhyb3R0bGVkX3RpbWVzdGFtcCA9IHJxLT5jbG9jazsNCiAJcmF3X3NwaW5fbG9jaygmY2ZzX2It
PmxvY2spOw0KIAlsaXN0X2FkZF90YWlsX3JjdSgmY2ZzX3JxLT50aHJvdHRsZWRfbGlzdCwgJmNm
c19iLT50aHJvdHRsZWRfY2ZzX3JxKTsNCisJaWYgKCFjZnNfYi0+dGltZXJfYWN0aXZlKQ0KKwkJ
X19zdGFydF9jZnNfYmFuZHdpZHRoKGNmc19iKTsNCiAJcmF3X3NwaW5fdW5sb2NrKCZjZnNfYi0+
bG9jayk7DQogfQ0KIA0KZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lL2FsYXJtdGltZXIuYyBiL2tl
cm5lbC90aW1lL2FsYXJtdGltZXIuYw0KaW5kZXggOGE0NmY1ZC4uMDkwN2U0MyAxMDA2NDQNCi0t
LSBhL2tlcm5lbC90aW1lL2FsYXJtdGltZXIuYw0KKysrIGIva2VybmVsL3RpbWUvYWxhcm10aW1l
ci5jDQpAQCAtNDY4LDcgKzQ2OCw3IEBAIHN0YXRpYyBpbnQgYWxhcm1fY2xvY2tfZ2V0cmVzKGNv
bnN0IGNsb2NraWRfdCB3aGljaF9jbG9jaywgc3RydWN0IHRpbWVzcGVjICp0cCkNCiAJY2xvY2tp
ZF90IGJhc2VpZCA9IGFsYXJtX2Jhc2VzW2Nsb2NrMmFsYXJtKHdoaWNoX2Nsb2NrKV0uYmFzZV9j
bG9ja2lkOw0KIA0KIAlpZiAoIWFsYXJtdGltZXJfZ2V0X3J0Y2RldigpKQ0KLQkJcmV0dXJuIC1F
Tk9UU1VQUDsNCisJCXJldHVybiAtRUlOVkFMOw0KIA0KIAlyZXR1cm4gaHJ0aW1lcl9nZXRfcmVz
KGJhc2VpZCwgdHApOw0KIH0NCkBAIC00ODUsNyArNDg1LDcgQEAgc3RhdGljIGludCBhbGFybV9j
bG9ja19nZXQoY2xvY2tpZF90IHdoaWNoX2Nsb2NrLCBzdHJ1Y3QgdGltZXNwZWMgKnRwKQ0KIAlz
dHJ1Y3QgYWxhcm1fYmFzZSAqYmFzZSA9ICZhbGFybV9iYXNlc1tjbG9jazJhbGFybSh3aGljaF9j
bG9jayldOw0KIA0KIAlpZiAoIWFsYXJtdGltZXJfZ2V0X3J0Y2RldigpKQ0KLQkJcmV0dXJuIC1F
Tk9UU1VQUDsNCisJCXJldHVybiAtRUlOVkFMOw0KIA0KIAkqdHAgPSBrdGltZV90b190aW1lc3Bl
YyhiYXNlLT5nZXR0aW1lKCkpOw0KIAlyZXR1cm4gMDsNCmRpZmYgLS1naXQgYS9rZXJuZWwvdHJh
Y2UvZnRyYWNlLmMgYi9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCmluZGV4IDIyNjc3NmIuLmQ0MGQ3
ZjYgMTAwNjQ0DQotLS0gYS9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCisrKyBiL2tlcm5lbC90cmFj
ZS9mdHJhY2UuYw0KQEAgLTI1OSw5ICsyNTksNiBAQCBzdGF0aWMgaW50IHJlbW92ZV9mdHJhY2Vf
b3BzKHN0cnVjdCBmdHJhY2Vfb3BzICoqbGlzdCwgc3RydWN0IGZ0cmFjZV9vcHMgKm9wcykNCiAN
CiBzdGF0aWMgaW50IF9fcmVnaXN0ZXJfZnRyYWNlX2Z1bmN0aW9uKHN0cnVjdCBmdHJhY2Vfb3Bz
ICpvcHMpDQogew0KLQlpZiAoZnRyYWNlX2Rpc2FibGVkKQ0KLQkJcmV0dXJuIC1FTk9ERVY7DQot
DQogCWlmIChGVFJBQ0VfV0FSTl9PTihvcHMgPT0gJmdsb2JhbF9vcHMpKQ0KIAkJcmV0dXJuIC1F
SU5WQUw7DQogDQpAQCAtMjkwLDkgKzI4Nyw2IEBAIHN0YXRpYyBpbnQgX191bnJlZ2lzdGVyX2Z0
cmFjZV9mdW5jdGlvbihzdHJ1Y3QgZnRyYWNlX29wcyAqb3BzKQ0KIHsNCiAJaW50IHJldDsNCiAN
Ci0JaWYgKGZ0cmFjZV9kaXNhYmxlZCkNCi0JCXJldHVybiAtRU5PREVWOw0KLQ0KIAlpZiAoV0FS
Tl9PTighKG9wcy0+ZmxhZ3MgJiBGVFJBQ0VfT1BTX0ZMX0VOQUJMRUQpKSkNCiAJCXJldHVybiAt
RUJVU1k7DQogDQpAQCAtMTAxNyw2ICsxMDExLDExIEBAIHN0YXRpYyBzdHJ1Y3QgZnRyYWNlX3Bh
Z2UJKmZ0cmFjZV9wYWdlczsNCiANCiBzdGF0aWMgc3RydWN0IGR5bl9mdHJhY2UgKmZ0cmFjZV9m
cmVlX3JlY29yZHM7DQogDQorc3RhdGljIGJvb2wgZnRyYWNlX2hhc2hfZW1wdHkoc3RydWN0IGZ0
cmFjZV9oYXNoICpoYXNoKQ0KK3sNCisJcmV0dXJuICFoYXNoIHx8ICFoYXNoLT5jb3VudDsNCit9
DQorDQogc3RhdGljIHN0cnVjdCBmdHJhY2VfZnVuY19lbnRyeSAqDQogZnRyYWNlX2xvb2t1cF9p
cChzdHJ1Y3QgZnRyYWNlX2hhc2ggKmhhc2gsIHVuc2lnbmVkIGxvbmcgaXApDQogew0KQEAgLTEw
MjUsNyArMTAyNCw3IEBAIGZ0cmFjZV9sb29rdXBfaXAoc3RydWN0IGZ0cmFjZV9oYXNoICpoYXNo
LCB1bnNpZ25lZCBsb25nIGlwKQ0KIAlzdHJ1Y3QgaGxpc3RfaGVhZCAqaGhkOw0KIAlzdHJ1Y3Qg
aGxpc3Rfbm9kZSAqbjsNCiANCi0JaWYgKCFoYXNoLT5jb3VudCkNCisJaWYgKGZ0cmFjZV9oYXNo
X2VtcHR5KGhhc2gpKQ0KIAkJcmV0dXJuIE5VTEw7DQogDQogCWlmIChoYXNoLT5zaXplX2JpdHMg
PiAwKQ0KQEAgLTExNjksNyArMTE2OCw3IEBAIGFsbG9jX2FuZF9jb3B5X2Z0cmFjZV9oYXNoKGlu
dCBzaXplX2JpdHMsIHN0cnVjdCBmdHJhY2VfaGFzaCAqaGFzaCkNCiAJCXJldHVybiBOVUxMOw0K
IA0KIAkvKiBFbXB0eSBoYXNoPyAqLw0KLQlpZiAoIWhhc2ggfHwgIWhhc2gtPmNvdW50KQ0KKwlp
ZiAoZnRyYWNlX2hhc2hfZW1wdHkoaGFzaCkpDQogCQlyZXR1cm4gbmV3X2hhc2g7DQogDQogCXNp
emUgPSAxIDw8IGhhc2gtPnNpemVfYml0czsNCkBAIC0xMjk0LDkgKzEyOTMsOSBAQCBmdHJhY2Vf
b3BzX3Rlc3Qoc3RydWN0IGZ0cmFjZV9vcHMgKm9wcywgdW5zaWduZWQgbG9uZyBpcCkNCiAJZmls
dGVyX2hhc2ggPSByY3VfZGVyZWZlcmVuY2VfcmF3KG9wcy0+ZmlsdGVyX2hhc2gpOw0KIAlub3Ry
YWNlX2hhc2ggPSByY3VfZGVyZWZlcmVuY2VfcmF3KG9wcy0+bm90cmFjZV9oYXNoKTsNCiANCi0J
aWYgKCghZmlsdGVyX2hhc2ggfHwgIWZpbHRlcl9oYXNoLT5jb3VudCB8fA0KKwlpZiAoKGZ0cmFj
ZV9oYXNoX2VtcHR5KGZpbHRlcl9oYXNoKSB8fA0KIAkgICAgIGZ0cmFjZV9sb29rdXBfaXAoZmls
dGVyX2hhc2gsIGlwKSkgJiYNCi0JICAgICghbm90cmFjZV9oYXNoIHx8ICFub3RyYWNlX2hhc2gt
PmNvdW50IHx8DQorCSAgICAoZnRyYWNlX2hhc2hfZW1wdHkobm90cmFjZV9oYXNoKSB8fA0KIAkg
ICAgICFmdHJhY2VfbG9va3VwX2lwKG5vdHJhY2VfaGFzaCwgaXApKSkNCiAJCXJldCA9IDE7DQog
CWVsc2UNCkBAIC0xMzQ4LDcgKzEzNDcsNyBAQCBzdGF0aWMgdm9pZCBfX2Z0cmFjZV9oYXNoX3Jl
Y191cGRhdGUoc3RydWN0IGZ0cmFjZV9vcHMgKm9wcywNCiAJaWYgKGZpbHRlcl9oYXNoKSB7DQog
CQloYXNoID0gb3BzLT5maWx0ZXJfaGFzaDsNCiAJCW90aGVyX2hhc2ggPSBvcHMtPm5vdHJhY2Vf
aGFzaDsNCi0JCWlmICghaGFzaCB8fCAhaGFzaC0+Y291bnQpDQorCQlpZiAoZnRyYWNlX2hhc2hf
ZW1wdHkoaGFzaCkpDQogCQkJYWxsID0gMTsNCiAJfSBlbHNlIHsNCiAJCWluYyA9ICFpbmM7DQpA
QCAtMTM1OCw3ICsxMzU3LDcgQEAgc3RhdGljIHZvaWQgX19mdHJhY2VfaGFzaF9yZWNfdXBkYXRl
KHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMsDQogCQkgKiBJZiB0aGUgbm90cmFjZSBoYXNoIGhhcyBu
byBpdGVtcywNCiAJCSAqIHRoZW4gdGhlcmUncyBub3RoaW5nIHRvIGRvLg0KIAkJICovDQotCQlp
ZiAoaGFzaCAmJiAhaGFzaC0+Y291bnQpDQorCQlpZiAoZnRyYWNlX2hhc2hfZW1wdHkoaGFzaCkp
DQogCQkJcmV0dXJuOw0KIAl9DQogDQpAQCAtMTM3NSw4ICsxMzc0LDggQEAgc3RhdGljIHZvaWQg
X19mdHJhY2VfaGFzaF9yZWNfdXBkYXRlKHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMsDQogCQkJaWYg
KCFvdGhlcl9oYXNoIHx8ICFmdHJhY2VfbG9va3VwX2lwKG90aGVyX2hhc2gsIHJlYy0+aXApKQ0K
IAkJCQltYXRjaCA9IDE7DQogCQl9IGVsc2Ugew0KLQkJCWluX2hhc2ggPSBoYXNoICYmICEhZnRy
YWNlX2xvb2t1cF9pcChoYXNoLCByZWMtPmlwKTsNCi0JCQlpbl9vdGhlcl9oYXNoID0gb3RoZXJf
aGFzaCAmJiAhIWZ0cmFjZV9sb29rdXBfaXAob3RoZXJfaGFzaCwgcmVjLT5pcCk7DQorCQkJaW5f
aGFzaCA9ICEhZnRyYWNlX2xvb2t1cF9pcChoYXNoLCByZWMtPmlwKTsNCisJCQlpbl9vdGhlcl9o
YXNoID0gISFmdHJhY2VfbG9va3VwX2lwKG90aGVyX2hhc2gsIHJlYy0+aXApOw0KIA0KIAkJCS8q
DQogCQkJICoNCkBAIC0xMzg0LDcgKzEzODMsNyBAQCBzdGF0aWMgdm9pZCBfX2Z0cmFjZV9oYXNo
X3JlY191cGRhdGUoc3RydWN0IGZ0cmFjZV9vcHMgKm9wcywNCiAJCQlpZiAoZmlsdGVyX2hhc2gg
JiYgaW5faGFzaCAmJiAhaW5fb3RoZXJfaGFzaCkNCiAJCQkJbWF0Y2ggPSAxOw0KIAkJCWVsc2Ug
aWYgKCFmaWx0ZXJfaGFzaCAmJiBpbl9oYXNoICYmDQotCQkJCSAoaW5fb3RoZXJfaGFzaCB8fCAh
b3RoZXJfaGFzaC0+Y291bnQpKQ0KKwkJCQkgKGluX290aGVyX2hhc2ggfHwgZnRyYWNlX2hhc2hf
ZW1wdHkob3RoZXJfaGFzaCkpKQ0KIAkJCQltYXRjaCA9IDE7DQogCQl9DQogCQlpZiAoIW1hdGNo
KQ0KQEAgLTE2OTgsMTAgKzE2OTcsMTUgQEAgc3RhdGljIHZvaWQgZnRyYWNlX3N0YXJ0dXBfZW5h
YmxlKGludCBjb21tYW5kKQ0KIHN0YXRpYyBpbnQgZnRyYWNlX3N0YXJ0dXAoc3RydWN0IGZ0cmFj
ZV9vcHMgKm9wcywgaW50IGNvbW1hbmQpDQogew0KIAlib29sIGhhc2hfZW5hYmxlID0gdHJ1ZTsN
CisJaW50IHJldDsNCiANCiAJaWYgKHVubGlrZWx5KGZ0cmFjZV9kaXNhYmxlZCkpDQogCQlyZXR1
cm4gLUVOT0RFVjsNCiANCisJcmV0ID0gX19yZWdpc3Rlcl9mdHJhY2VfZnVuY3Rpb24ob3BzKTsN
CisJaWYgKHJldCkNCisJCXJldHVybiByZXQ7DQorDQogCWZ0cmFjZV9zdGFydF91cCsrOw0KIAlj
b21tYW5kIHw9IEZUUkFDRV9VUERBVEVfQ0FMTFM7DQogDQpAQCAtMTcyMywxMiArMTcyNywxNyBA
QCBzdGF0aWMgaW50IGZ0cmFjZV9zdGFydHVwKHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMsIGludCBj
b21tYW5kKQ0KIAlyZXR1cm4gMDsNCiB9DQogDQotc3RhdGljIHZvaWQgZnRyYWNlX3NodXRkb3du
KHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMsIGludCBjb21tYW5kKQ0KK3N0YXRpYyBpbnQgZnRyYWNl
X3NodXRkb3duKHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMsIGludCBjb21tYW5kKQ0KIHsNCiAJYm9v
bCBoYXNoX2Rpc2FibGUgPSB0cnVlOw0KKwlpbnQgcmV0Ow0KIA0KIAlpZiAodW5saWtlbHkoZnRy
YWNlX2Rpc2FibGVkKSkNCi0JCXJldHVybjsNCisJCXJldHVybiAtRU5PREVWOw0KKw0KKwlyZXQg
PSBfX3VucmVnaXN0ZXJfZnRyYWNlX2Z1bmN0aW9uKG9wcyk7DQorCWlmIChyZXQpDQorCQlyZXR1
cm4gcmV0Ow0KIA0KIAlmdHJhY2Vfc3RhcnRfdXAtLTsNCiAJLyoNCkBAIC0xNzYzLDkgKzE3NzIs
MTAgQEAgc3RhdGljIHZvaWQgZnRyYWNlX3NodXRkb3duKHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMs
IGludCBjb21tYW5kKQ0KIAl9DQogDQogCWlmICghY29tbWFuZCB8fCAhZnRyYWNlX2VuYWJsZWQp
DQotCQlyZXR1cm47DQorCQlyZXR1cm4gMDsNCiANCiAJZnRyYWNlX3J1bl91cGRhdGVfY29kZShj
b21tYW5kKTsNCisJcmV0dXJuIDA7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIGZ0cmFjZV9zdGFydHVw
X3N5c2N0bCh2b2lkKQ0KQEAgLTE3OTQsMTIgKzE4MDQsNTcgQEAgc3RhdGljIGN5Y2xlX3QJCWZ0
cmFjZV91cGRhdGVfdGltZTsNCiBzdGF0aWMgdW5zaWduZWQgbG9uZwlmdHJhY2VfdXBkYXRlX2Nu
dDsNCiB1bnNpZ25lZCBsb25nCQlmdHJhY2VfdXBkYXRlX3RvdF9jbnQ7DQogDQotc3RhdGljIGlu
dCBvcHNfdHJhY2VzX21vZChzdHJ1Y3QgZnRyYWNlX29wcyAqb3BzKQ0KK3N0YXRpYyBpbmxpbmUg
aW50IG9wc190cmFjZXNfbW9kKHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMpDQogew0KLQlzdHJ1Y3Qg
ZnRyYWNlX2hhc2ggKmhhc2g7DQorCS8qDQorCSAqIEZpbHRlcl9oYXNoIGJlaW5nIGVtcHR5IHdp
bGwgZGVmYXVsdCB0byB0cmFjZSBtb2R1bGUuDQorCSAqIEJ1dCBub3RyYWNlIGhhc2ggcmVxdWly
ZXMgYSB0ZXN0IG9mIGluZGl2aWR1YWwgbW9kdWxlIGZ1bmN0aW9ucy4NCisJICovDQorCXJldHVy
biBmdHJhY2VfaGFzaF9lbXB0eShvcHMtPmZpbHRlcl9oYXNoKSAmJg0KKwkJZnRyYWNlX2hhc2hf
ZW1wdHkob3BzLT5ub3RyYWNlX2hhc2gpOw0KK30NCiANCi0JaGFzaCA9IG9wcy0+ZmlsdGVyX2hh
c2g7DQotCXJldHVybiAhISghaGFzaCB8fCAhaGFzaC0+Y291bnQpOw0KKy8qDQorICogQ2hlY2sg
aWYgdGhlIGN1cnJlbnQgb3BzIHJlZmVyZW5jZXMgdGhlIHJlY29yZC4NCisgKg0KKyAqIElmIHRo
ZSBvcHMgdHJhY2VzIGFsbCBmdW5jdGlvbnMsIHRoZW4gaXQgd2FzIGFscmVhZHkgYWNjb3VudGVk
IGZvci4NCisgKiBJZiB0aGUgb3BzIGRvZXMgbm90IHRyYWNlIHRoZSBjdXJyZW50IHJlY29yZCBm
dW5jdGlvbiwgc2tpcCBpdC4NCisgKiBJZiB0aGUgb3BzIGlnbm9yZXMgdGhlIGZ1bmN0aW9uIHZp
YSBub3RyYWNlIGZpbHRlciwgc2tpcCBpdC4NCisgKi8NCitzdGF0aWMgaW5saW5lIGJvb2wNCitv
cHNfcmVmZXJlbmNlc19yZWMoc3RydWN0IGZ0cmFjZV9vcHMgKm9wcywgc3RydWN0IGR5bl9mdHJh
Y2UgKnJlYykNCit7DQorCS8qIElmIG9wcyBpc24ndCBlbmFibGVkLCBpZ25vcmUgaXQgKi8NCisJ
aWYgKCEob3BzLT5mbGFncyAmIEZUUkFDRV9PUFNfRkxfRU5BQkxFRCkpDQorCQlyZXR1cm4gMDsN
CisNCisJLyogSWYgb3BzIHRyYWNlcyBhbGwgbW9kcywgd2UgYWxyZWFkeSBhY2NvdW50ZWQgZm9y
IGl0ICovDQorCWlmIChvcHNfdHJhY2VzX21vZChvcHMpKQ0KKwkJcmV0dXJuIDA7DQorDQorCS8q
IFRoZSBmdW5jdGlvbiBtdXN0IGJlIGluIHRoZSBmaWx0ZXIgKi8NCisJaWYgKCFmdHJhY2VfaGFz
aF9lbXB0eShvcHMtPmZpbHRlcl9oYXNoKSAmJg0KKwkgICAgIWZ0cmFjZV9sb29rdXBfaXAob3Bz
LT5maWx0ZXJfaGFzaCwgcmVjLT5pcCkpDQorCQlyZXR1cm4gMDsNCisNCisJLyogSWYgaW4gbm90
cmFjZSBoYXNoLCB3ZSBpZ25vcmUgaXQgdG9vICovDQorCWlmIChmdHJhY2VfbG9va3VwX2lwKG9w
cy0+bm90cmFjZV9oYXNoLCByZWMtPmlwKSkNCisJCXJldHVybiAwOw0KKw0KKwlyZXR1cm4gMTsN
Cit9DQorDQorc3RhdGljIGludCByZWZlcmVuY2VkX2ZpbHRlcnMoc3RydWN0IGR5bl9mdHJhY2Ug
KnJlYykNCit7DQorCXN0cnVjdCBmdHJhY2Vfb3BzICpvcHM7DQorCWludCBjbnQgPSAwOw0KKw0K
Kwlmb3IgKG9wcyA9IGZ0cmFjZV9vcHNfbGlzdDsgb3BzICE9ICZmdHJhY2VfbGlzdF9lbmQ7IG9w
cyA9IG9wcy0+bmV4dCkgew0KKwkJaWYgKG9wc19yZWZlcmVuY2VzX3JlYyhvcHMsIHJlYykpDQor
CQkgICAgY250Kys7DQorCX0NCisNCisJcmV0dXJuIGNudDsNCiB9DQogDQogc3RhdGljIGludCBm
dHJhY2VfdXBkYXRlX2NvZGUoc3RydWN0IG1vZHVsZSAqbW9kKQ0KQEAgLTE4MDcsNiArMTg2Miw3
IEBAIHN0YXRpYyBpbnQgZnRyYWNlX3VwZGF0ZV9jb2RlKHN0cnVjdCBtb2R1bGUgKm1vZCkNCiAJ
c3RydWN0IGR5bl9mdHJhY2UgKnA7DQogCWN5Y2xlX3Qgc3RhcnQsIHN0b3A7DQogCXVuc2lnbmVk
IGxvbmcgcmVmID0gMDsNCisJYm9vbCB0ZXN0ID0gZmFsc2U7DQogDQogCS8qDQogCSAqIFdoZW4g
YWRkaW5nIGEgbW9kdWxlLCB3ZSBuZWVkIHRvIGNoZWNrIGlmIHRyYWNlcnMgYXJlDQpAQCAtMTgx
OSw5ICsxODc1LDEyIEBAIHN0YXRpYyBpbnQgZnRyYWNlX3VwZGF0ZV9jb2RlKHN0cnVjdCBtb2R1
bGUgKm1vZCkNCiANCiAJCWZvciAob3BzID0gZnRyYWNlX29wc19saXN0Ow0KIAkJICAgICBvcHMg
IT0gJmZ0cmFjZV9saXN0X2VuZDsgb3BzID0gb3BzLT5uZXh0KSB7DQotCQkJaWYgKG9wcy0+Zmxh
Z3MgJiBGVFJBQ0VfT1BTX0ZMX0VOQUJMRUQgJiYNCi0JCQkgICAgb3BzX3RyYWNlc19tb2Qob3Bz
KSkNCi0JCQkJcmVmKys7DQorCQkJaWYgKG9wcy0+ZmxhZ3MgJiBGVFJBQ0VfT1BTX0ZMX0VOQUJM
RUQpIHsNCisJCQkJaWYgKG9wc190cmFjZXNfbW9kKG9wcykpDQorCQkJCQlyZWYrKzsNCisJCQkJ
ZWxzZQ0KKwkJCQkJdGVzdCA9IHRydWU7DQorCQkJfQ0KIAkJfQ0KIAl9DQogDQpAQCAtMTgyOSw2
ICsxODg4LDcgQEAgc3RhdGljIGludCBmdHJhY2VfdXBkYXRlX2NvZGUoc3RydWN0IG1vZHVsZSAq
bW9kKQ0KIAlmdHJhY2VfdXBkYXRlX2NudCA9IDA7DQogDQogCXdoaWxlIChmdHJhY2VfbmV3X2Fk
ZHJzKSB7DQorCQlpbnQgY250ID0gcmVmOw0KIA0KIAkJLyogSWYgc29tZXRoaW5nIHdlbnQgd3Jv
bmcsIGJhaWwgd2l0aG91dCBlbmFibGluZyBhbnl0aGluZyAqLw0KIAkJaWYgKHVubGlrZWx5KGZ0
cmFjZV9kaXNhYmxlZCkpDQpAQCAtMTgzNiw3ICsxODk2LDkgQEAgc3RhdGljIGludCBmdHJhY2Vf
dXBkYXRlX2NvZGUoc3RydWN0IG1vZHVsZSAqbW9kKQ0KIA0KIAkJcCA9IGZ0cmFjZV9uZXdfYWRk
cnM7DQogCQlmdHJhY2VfbmV3X2FkZHJzID0gcC0+bmV3bGlzdDsNCi0JCXAtPmZsYWdzID0gcmVm
Ow0KKwkJaWYgKHRlc3QpDQorCQkJY250ICs9IHJlZmVyZW5jZWRfZmlsdGVycyhwKTsNCisJCXAt
PmZsYWdzID0gY250Ow0KIA0KIAkJLyoNCiAJCSAqIERvIHRoZSBpbml0aWFsIHJlY29yZCBjb252
ZXJzaW9uIGZyb20gbWNvdW50IGp1bXANCkBAIC0xODU5LDcgKzE5MjEsNyBAQCBzdGF0aWMgaW50
IGZ0cmFjZV91cGRhdGVfY29kZShzdHJ1Y3QgbW9kdWxlICptb2QpDQogCQkgKiBjb252ZXJzaW9u
IHB1dHMgdGhlIG1vZHVsZSB0byB0aGUgY29ycmVjdCBzdGF0ZSwgdGh1cw0KIAkJICogcGFzc2lu
ZyB0aGUgZnRyYWNlX21ha2VfY2FsbCBjaGVjay4NCiAJCSAqLw0KLQkJaWYgKGZ0cmFjZV9zdGFy
dF91cCAmJiByZWYpIHsNCisJCWlmIChmdHJhY2Vfc3RhcnRfdXAgJiYgY250KSB7DQogCQkJaW50
IGZhaWxlZCA9IF9fZnRyYWNlX3JlcGxhY2VfY29kZShwLCAxKTsNCiAJCQlpZiAoZmFpbGVkKSB7
DQogCQkJCWZ0cmFjZV9idWcoZmFpbGVkLCBwLT5pcCk7DQpAQCAtMjExMiw3ICsyMTc0LDggQEAg
c3RhdGljIHZvaWQgKnRfc3RhcnQoc3RydWN0IHNlcV9maWxlICptLCBsb2ZmX3QgKnBvcykNCiAJ
ICogb2ZmLCB3ZSBjYW4gc2hvcnQgY3V0IGFuZCBqdXN0IHByaW50IG91dCB0aGF0IGFsbA0KIAkg
KiBmdW5jdGlvbnMgYXJlIGVuYWJsZWQuDQogCSAqLw0KLQlpZiAoaXRlci0+ZmxhZ3MgJiBGVFJB
Q0VfSVRFUl9GSUxURVIgJiYgIW9wcy0+ZmlsdGVyX2hhc2gtPmNvdW50KSB7DQorCWlmIChpdGVy
LT5mbGFncyAmIEZUUkFDRV9JVEVSX0ZJTFRFUiAmJg0KKwkgICAgZnRyYWNlX2hhc2hfZW1wdHko
b3BzLT5maWx0ZXJfaGFzaCkpIHsNCiAJCWlmICgqcG9zID4gMCkNCiAJCQlyZXR1cm4gdF9oYXNo
X3N0YXJ0KG0sIHBvcyk7DQogCQlpdGVyLT5mbGFncyB8PSBGVFJBQ0VfSVRFUl9QUklOVEFMTDsN
CkBAIC0yNTY0LDE2ICsyNjI3LDEzIEBAIHN0YXRpYyB2b2lkIF9fZW5hYmxlX2Z0cmFjZV9mdW5j
dGlvbl9wcm9iZSh2b2lkKQ0KIAlpZiAoaSA9PSBGVFJBQ0VfRlVOQ19IQVNIU0laRSkNCiAJCXJl
dHVybjsNCiANCi0JcmV0ID0gX19yZWdpc3Rlcl9mdHJhY2VfZnVuY3Rpb24oJnRyYWNlX3Byb2Jl
X29wcyk7DQotCWlmICghcmV0KQ0KLQkJcmV0ID0gZnRyYWNlX3N0YXJ0dXAoJnRyYWNlX3Byb2Jl
X29wcywgMCk7DQorCXJldCA9IGZ0cmFjZV9zdGFydHVwKCZ0cmFjZV9wcm9iZV9vcHMsIDApOw0K
IA0KIAlmdHJhY2VfcHJvYmVfcmVnaXN0ZXJlZCA9IDE7DQogfQ0KIA0KIHN0YXRpYyB2b2lkIF9f
ZGlzYWJsZV9mdHJhY2VfZnVuY3Rpb25fcHJvYmUodm9pZCkNCiB7DQotCWludCByZXQ7DQogCWlu
dCBpOw0KIA0KIAlpZiAoIWZ0cmFjZV9wcm9iZV9yZWdpc3RlcmVkKQ0KQEAgLTI1ODYsOSArMjY0
Niw3IEBAIHN0YXRpYyB2b2lkIF9fZGlzYWJsZV9mdHJhY2VfZnVuY3Rpb25fcHJvYmUodm9pZCkN
CiAJfQ0KIA0KIAkvKiBubyBtb3JlIGZ1bmNzIGxlZnQgKi8NCi0JcmV0ID0gX191bnJlZ2lzdGVy
X2Z0cmFjZV9mdW5jdGlvbigmdHJhY2VfcHJvYmVfb3BzKTsNCi0JaWYgKCFyZXQpDQotCQlmdHJh
Y2Vfc2h1dGRvd24oJnRyYWNlX3Byb2JlX29wcywgMCk7DQorCWZ0cmFjZV9zaHV0ZG93bigmdHJh
Y2VfcHJvYmVfb3BzLCAwKTsNCiANCiAJZnRyYWNlX3Byb2JlX3JlZ2lzdGVyZWQgPSAwOw0KIH0N
CkBAIC0zNTYxLDEyICszNjE5LDE1IEBAIGRldmljZV9pbml0Y2FsbChmdHJhY2Vfbm9keW5faW5p
dCk7DQogc3RhdGljIGlubGluZSBpbnQgZnRyYWNlX2luaXRfZHluX2RlYnVnZnMoc3RydWN0IGRl
bnRyeSAqZF90cmFjZXIpIHsgcmV0dXJuIDA7IH0NCiBzdGF0aWMgaW5saW5lIHZvaWQgZnRyYWNl
X3N0YXJ0dXBfZW5hYmxlKGludCBjb21tYW5kKSB7IH0NCiAvKiBLZWVwIGFzIG1hY3JvcyBzbyB3
ZSBkbyBub3QgbmVlZCB0byBkZWZpbmUgdGhlIGNvbW1hbmRzICovDQotIyBkZWZpbmUgZnRyYWNl
X3N0YXJ0dXAob3BzLCBjb21tYW5kKQkJCVwNCi0JKHsJCQkJCQlcDQotCQkob3BzKS0+ZmxhZ3Mg
fD0gRlRSQUNFX09QU19GTF9FTkFCTEVEOwlcDQotCQkwOwkJCQkJXA0KKyMgZGVmaW5lIGZ0cmFj
ZV9zdGFydHVwKG9wcywgY29tbWFuZCkJCQkJCVwNCisJKHsJCQkJCQkJCVwNCisJCWludCBfX19y
ZXQgPSBfX3JlZ2lzdGVyX2Z0cmFjZV9mdW5jdGlvbihvcHMpOwkJXA0KKwkJaWYgKCFfX19yZXQp
CQkJCQkJXA0KKwkJCShvcHMpLT5mbGFncyB8PSBGVFJBQ0VfT1BTX0ZMX0VOQUJMRUQ7CQlcDQor
CQlfX19yZXQ7CQkJCQkJCVwNCiAJfSkNCi0jIGRlZmluZSBmdHJhY2Vfc2h1dGRvd24ob3BzLCBj
b21tYW5kKQlkbyB7IH0gd2hpbGUgKDApDQorIyBkZWZpbmUgZnRyYWNlX3NodXRkb3duKG9wcywg
Y29tbWFuZCkgX191bnJlZ2lzdGVyX2Z0cmFjZV9mdW5jdGlvbihvcHMpDQorDQogIyBkZWZpbmUg
ZnRyYWNlX3N0YXJ0dXBfc3lzY3RsKCkJZG8geyB9IHdoaWxlICgwKQ0KICMgZGVmaW5lIGZ0cmFj
ZV9zaHV0ZG93bl9zeXNjdGwoKQlkbyB7IH0gd2hpbGUgKDApDQogDQpAQCAtMzkwNiwxNSArMzk2
Nyw4IEBAIGludCByZWdpc3Rlcl9mdHJhY2VfZnVuY3Rpb24oc3RydWN0IGZ0cmFjZV9vcHMgKm9w
cykNCiANCiAJbXV0ZXhfbG9jaygmZnRyYWNlX2xvY2spOw0KIA0KLQlpZiAodW5saWtlbHkoZnRy
YWNlX2Rpc2FibGVkKSkNCi0JCWdvdG8gb3V0X3VubG9jazsNCi0NCi0JcmV0ID0gX19yZWdpc3Rl
cl9mdHJhY2VfZnVuY3Rpb24ob3BzKTsNCi0JaWYgKCFyZXQpDQotCQlyZXQgPSBmdHJhY2Vfc3Rh
cnR1cChvcHMsIDApOw0KLQ0KKwlyZXQgPSBmdHJhY2Vfc3RhcnR1cChvcHMsIDApOw0KIA0KLSBv
dXRfdW5sb2NrOg0KIAltdXRleF91bmxvY2soJmZ0cmFjZV9sb2NrKTsNCiAJcmV0dXJuIHJldDsN
CiB9DQpAQCAtMzkzMSw5ICszOTg1LDcgQEAgaW50IHVucmVnaXN0ZXJfZnRyYWNlX2Z1bmN0aW9u
KHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMpDQogCWludCByZXQ7DQogDQogCW11dGV4X2xvY2soJmZ0
cmFjZV9sb2NrKTsNCi0JcmV0ID0gX191bnJlZ2lzdGVyX2Z0cmFjZV9mdW5jdGlvbihvcHMpOw0K
LQlpZiAoIXJldCkNCi0JCWZ0cmFjZV9zaHV0ZG93bihvcHMsIDApOw0KKwlyZXQgPSBmdHJhY2Vf
c2h1dGRvd24ob3BzLCAwKTsNCiAJbXV0ZXhfdW5sb2NrKCZmdHJhY2VfbG9jayk7DQogDQogCXJl
dHVybiByZXQ7DQpAQCAtNDEyNyw2ICs0MTc5LDEyIEBAIGZ0cmFjZV9zdXNwZW5kX25vdGlmaWVy
X2NhbGwoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpibCwgdW5zaWduZWQgbG9uZyBzdGF0ZSwNCiAJ
cmV0dXJuIE5PVElGWV9ET05FOw0KIH0NCiANCisvKiBKdXN0IGEgcGxhY2UgaG9sZGVyIGZvciBm
dW5jdGlvbiBncmFwaCAqLw0KK3N0YXRpYyBzdHJ1Y3QgZnRyYWNlX29wcyBmZ3JhcGhfb3BzIF9f
cmVhZF9tb3N0bHkgPSB7DQorCS5mdW5jCQk9IGZ0cmFjZV9zdHViLA0KKwkuZmxhZ3MJCT0gRlRS
QUNFX09QU19GTF9HTE9CQUwsDQorfTsNCisNCiBpbnQgcmVnaXN0ZXJfZnRyYWNlX2dyYXBoKHRy
YWNlX2Z1bmNfZ3JhcGhfcmV0X3QgcmV0ZnVuYywNCiAJCQl0cmFjZV9mdW5jX2dyYXBoX2VudF90
IGVudHJ5ZnVuYykNCiB7DQpAQCAtNDE1Myw3ICs0MjExLDcgQEAgaW50IHJlZ2lzdGVyX2Z0cmFj
ZV9ncmFwaCh0cmFjZV9mdW5jX2dyYXBoX3JldF90IHJldGZ1bmMsDQogCWZ0cmFjZV9ncmFwaF9y
ZXR1cm4gPSByZXRmdW5jOw0KIAlmdHJhY2VfZ3JhcGhfZW50cnkgPSBlbnRyeWZ1bmM7DQogDQot
CXJldCA9IGZ0cmFjZV9zdGFydHVwKCZnbG9iYWxfb3BzLCBGVFJBQ0VfU1RBUlRfRlVOQ19SRVQp
Ow0KKwlyZXQgPSBmdHJhY2Vfc3RhcnR1cCgmZmdyYXBoX29wcywgRlRSQUNFX1NUQVJUX0ZVTkNf
UkVUKTsNCiANCiBvdXQ6DQogCW11dGV4X3VubG9jaygmZnRyYWNlX2xvY2spOw0KQEAgLTQxNzAs
NyArNDIyOCw3IEBAIHZvaWQgdW5yZWdpc3Rlcl9mdHJhY2VfZ3JhcGgodm9pZCkNCiAJZnRyYWNl
X2dyYXBoX2FjdGl2ZS0tOw0KIAlmdHJhY2VfZ3JhcGhfcmV0dXJuID0gKHRyYWNlX2Z1bmNfZ3Jh
cGhfcmV0X3QpZnRyYWNlX3N0dWI7DQogCWZ0cmFjZV9ncmFwaF9lbnRyeSA9IGZ0cmFjZV9ncmFw
aF9lbnRyeV9zdHViOw0KLQlmdHJhY2Vfc2h1dGRvd24oJmdsb2JhbF9vcHMsIEZUUkFDRV9TVE9Q
X0ZVTkNfUkVUKTsNCisJZnRyYWNlX3NodXRkb3duKCZmZ3JhcGhfb3BzLCBGVFJBQ0VfU1RPUF9G
VU5DX1JFVCk7DQogCXVucmVnaXN0ZXJfcG1fbm90aWZpZXIoJmZ0cmFjZV9zdXNwZW5kX25vdGlm
aWVyKTsNCiAJdW5yZWdpc3Rlcl90cmFjZV9zY2hlZF9zd2l0Y2goZnRyYWNlX2dyYXBoX3Byb2Jl
X3NjaGVkX3N3aXRjaCwgTlVMTCk7DQogDQpkaWZmIC0tZ2l0IGEvbGliL3JhbmRvbTMyLmMgYi9s
aWIvcmFuZG9tMzIuYw0KaW5kZXggZmMzNTQ1YS4uMWY0NGJkYyAxMDA2NDQNCi0tLSBhL2xpYi9y
YW5kb20zMi5jDQorKysgYi9saWIvcmFuZG9tMzIuYw0KQEAgLTkyLDcgKzkyLDcgQEAgdm9pZCBz
cmFuZG9tMzIodTMyIGVudHJvcHkpDQogCSAqLw0KIAlmb3JfZWFjaF9wb3NzaWJsZV9jcHUgKGkp
IHsNCiAJCXN0cnVjdCBybmRfc3RhdGUgKnN0YXRlID0gJnBlcl9jcHUobmV0X3JhbmRfc3RhdGUs
IGkpOw0KLQkJc3RhdGUtPnMxID0gX19zZWVkKHN0YXRlLT5zMSBeIGVudHJvcHksIDEpOw0KKwkJ
c3RhdGUtPnMxID0gX19zZWVkKHN0YXRlLT5zMSBeIGVudHJvcHksIDIpOw0KIAl9DQogfQ0KIEVY
UE9SVF9TWU1CT0woc3JhbmRvbTMyKTsNCkBAIC0xMDksOSArMTA5LDkgQEAgc3RhdGljIGludCBf
X2luaXQgcmFuZG9tMzJfaW5pdCh2b2lkKQ0KIAkJc3RydWN0IHJuZF9zdGF0ZSAqc3RhdGUgPSAm
cGVyX2NwdShuZXRfcmFuZF9zdGF0ZSxpKTsNCiANCiAjZGVmaW5lIExDRyh4KQkoKHgpICogNjkw
NjkpCS8qIHN1cGVyLWR1cGVyIExDRyAqLw0KLQkJc3RhdGUtPnMxID0gX19zZWVkKExDRyhpICsg
amlmZmllcyksIDEpOw0KLQkJc3RhdGUtPnMyID0gX19zZWVkKExDRyhzdGF0ZS0+czEpLCA3KTsN
Ci0JCXN0YXRlLT5zMyA9IF9fc2VlZChMQ0coc3RhdGUtPnMyKSwgMTUpOw0KKwkJc3RhdGUtPnMx
ID0gX19zZWVkKExDRyhpICsgamlmZmllcyksIDIpOw0KKwkJc3RhdGUtPnMyID0gX19zZWVkKExD
RyhzdGF0ZS0+czEpLCA4KTsNCisJCXN0YXRlLT5zMyA9IF9fc2VlZChMQ0coc3RhdGUtPnMyKSwg
MTYpOw0KIA0KIAkJLyogIndhcm0gaXQgdXAiICovDQogCQlwcmFuZG9tMzIoc3RhdGUpOw0KQEAg
LTEzOCw5ICsxMzgsOSBAQCBzdGF0aWMgaW50IF9faW5pdCByYW5kb20zMl9yZXNlZWQodm9pZCkN
CiAJCXUzMiBzZWVkc1szXTsNCiANCiAJCWdldF9yYW5kb21fYnl0ZXMoJnNlZWRzLCBzaXplb2Yo
c2VlZHMpKTsNCi0JCXN0YXRlLT5zMSA9IF9fc2VlZChzZWVkc1swXSwgMSk7DQotCQlzdGF0ZS0+
czIgPSBfX3NlZWQoc2VlZHNbMV0sIDcpOw0KLQkJc3RhdGUtPnMzID0gX19zZWVkKHNlZWRzWzJd
LCAxNSk7DQorCQlzdGF0ZS0+czEgPSBfX3NlZWQoc2VlZHNbMF0sIDIpOw0KKwkJc3RhdGUtPnMy
ID0gX19zZWVkKHNlZWRzWzFdLCA4KTsNCisJCXN0YXRlLT5zMyA9IF9fc2VlZChzZWVkc1syXSwg
MTYpOw0KIA0KIAkJLyogbWl4IGl0IGluICovDQogCQlwcmFuZG9tMzIoc3RhdGUpOw0KZGlmZiAt
LWdpdCBhL2xpYi92c3ByaW50Zi5jIGIvbGliL3ZzcHJpbnRmLmMNCmluZGV4IGQ3NGMzMTcuLmFl
MDJlNDIgMTAwNjQ0DQotLS0gYS9saWIvdnNwcmludGYuYw0KKysrIGIvbGliL3ZzcHJpbnRmLmMN
CkBAIC0yNSw2ICsyNSw3IEBADQogI2luY2x1ZGUgPGxpbnV4L2thbGxzeW1zLmg+DQogI2luY2x1
ZGUgPGxpbnV4L3VhY2Nlc3MuaD4NCiAjaW5jbHVkZSA8bGludXgvaW9wb3J0Lmg+DQorI2luY2x1
ZGUgPGxpbnV4L2NyZWQuaD4NCiAjaW5jbHVkZSA8bmV0L2FkZHJjb25mLmg+DQogDQogI2luY2x1
ZGUgPGFzbS9wYWdlLmg+CQkvKiBmb3IgUEFHRV9TSVpFICovDQpAQCAtODkyLDEwICs4OTMsMzUg
QEAgY2hhciAqcG9pbnRlcihjb25zdCBjaGFyICpmbXQsIGNoYXIgKmJ1ZiwgY2hhciAqZW5kLCB2
b2lkICpwdHIsDQogCQkJCXNwZWMuZmllbGRfd2lkdGggPSAyICogc2l6ZW9mKHZvaWQgKik7DQog
CQkJcmV0dXJuIHN0cmluZyhidWYsIGVuZCwgInBLLWVycm9yIiwgc3BlYyk7DQogCQl9DQotCQlp
ZiAoISgoa3B0cl9yZXN0cmljdCA9PSAwKSB8fA0KLQkJICAgICAgKGtwdHJfcmVzdHJpY3QgPT0g
MSAmJg0KLQkJICAgICAgIGhhc19jYXBhYmlsaXR5X25vYXVkaXQoY3VycmVudCwgQ0FQX1NZU0xP
RykpKSkNCisNCisJCXN3aXRjaCAoa3B0cl9yZXN0cmljdCkgew0KKwkJY2FzZSAwOg0KKwkJCS8q
IEFsd2F5cyBwcmludCAlcEsgdmFsdWVzICovDQorCQkJYnJlYWs7DQorCQljYXNlIDE6IHsNCisJ
CQkvKg0KKwkJCSAqIE9ubHkgcHJpbnQgdGhlIHJlYWwgcG9pbnRlciB2YWx1ZSBpZiB0aGUgY3Vy
cmVudA0KKwkJCSAqIHByb2Nlc3MgaGFzIENBUF9TWVNMT0cgYW5kIGlzIHJ1bm5pbmcgd2l0aCB0
aGUNCisJCQkgKiBzYW1lIGNyZWRlbnRpYWxzIGl0IHN0YXJ0ZWQgd2l0aC4gVGhpcyBpcyBiZWNh
dXNlDQorCQkJICogYWNjZXNzIHRvIGZpbGVzIGlzIGNoZWNrZWQgYXQgb3BlbigpIHRpbWUsIGJ1
dCAlcEsNCisJCQkgKiBjaGVja3MgcGVybWlzc2lvbiBhdCByZWFkKCkgdGltZS4gV2UgZG9uJ3Qg
d2FudCB0bw0KKwkJCSAqIGxlYWsgcG9pbnRlciB2YWx1ZXMgaWYgYSBiaW5hcnkgb3BlbnMgYSBm
aWxlIHVzaW5nDQorCQkJICogJXBLIGFuZCB0aGVuIGVsZXZhdGVzIHByaXZpbGVnZXMgYmVmb3Jl
IHJlYWRpbmcgaXQuDQorCQkJICovDQorCQkJY29uc3Qgc3RydWN0IGNyZWQgKmNyZWQgPSBjdXJy
ZW50X2NyZWQoKTsNCisNCisJCQlpZiAoIWhhc19jYXBhYmlsaXR5X25vYXVkaXQoY3VycmVudCwg
Q0FQX1NZU0xPRykgfHwNCisJCQkgICAgY3JlZC0+ZXVpZCAhPSBjcmVkLT51aWQgfHwNCisJCQkg
ICAgY3JlZC0+ZWdpZCAhPSBjcmVkLT5naWQpDQorCQkJCXB0ciA9IE5VTEw7DQorCQkJYnJlYWs7
DQorCQl9DQorCQljYXNlIDI6DQorCQlkZWZhdWx0Og0KKwkJCS8qIEFsd2F5cyBwcmludCAwJ3Mg
Zm9yICVwSyAqLw0KIAkJCXB0ciA9IE5VTEw7DQorCQkJYnJlYWs7DQorCQl9DQogCQlicmVhazsN
CiAJfQ0KIAlzcGVjLmZsYWdzIHw9IFNNQUxMOw0KZGlmZiAtLWdpdCBhL25ldC9hcHBsZXRhbGsv
ZGRwLmMgYi9uZXQvYXBwbGV0YWxrL2RkcC5jDQppbmRleCBiZmE5YWI5My4uMzM0ZDRjZCAxMDA2
NDQNCi0tLSBhL25ldC9hcHBsZXRhbGsvZGRwLmMNCisrKyBiL25ldC9hcHBsZXRhbGsvZGRwLmMN
CkBAIC0xNzQwLDcgKzE3NDAsNiBAQCBzdGF0aWMgaW50IGF0YWxrX3JlY3Ztc2coc3RydWN0IGtp
b2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3QgbXNnaGRyDQogCQkJIHNpemVf
dCBzaXplLCBpbnQgZmxhZ3MpDQogew0KIAlzdHJ1Y3Qgc29jayAqc2sgPSBzb2NrLT5zazsNCi0J
c3RydWN0IHNvY2thZGRyX2F0ICpzYXQgPSAoc3RydWN0IHNvY2thZGRyX2F0ICopbXNnLT5tc2df
bmFtZTsNCiAJc3RydWN0IGRkcGVoZHIgKmRkcDsNCiAJaW50IGNvcGllZCA9IDA7DQogCWludCBv
ZmZzZXQgPSAwOw0KQEAgLTE3NjksMTQgKzE3NjgsMTMgQEAgc3RhdGljIGludCBhdGFsa19yZWN2
bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IHNvY2tldCAqc29jaywgc3RydWN0IG1zZ2hk
cg0KIAl9DQogCWVyciA9IHNrYl9jb3B5X2RhdGFncmFtX2lvdmVjKHNrYiwgb2Zmc2V0LCBtc2ct
Pm1zZ19pb3YsIGNvcGllZCk7DQogDQotCWlmICghZXJyKSB7DQotCQlpZiAoc2F0KSB7DQotCQkJ
c2F0LT5zYXRfZmFtaWx5ICAgICAgPSBBRl9BUFBMRVRBTEs7DQotCQkJc2F0LT5zYXRfcG9ydCAg
ICAgICAgPSBkZHAtPmRlaF9zcG9ydDsNCi0JCQlzYXQtPnNhdF9hZGRyLnNfbm9kZSA9IGRkcC0+
ZGVoX3Nub2RlOw0KLQkJCXNhdC0+c2F0X2FkZHIuc19uZXQgID0gZGRwLT5kZWhfc25ldDsNCi0J
CX0NCi0JCW1zZy0+bXNnX25hbWVsZW4gPSBzaXplb2YoKnNhdCk7DQorCWlmICghZXJyICYmIG1z
Zy0+bXNnX25hbWUpIHsNCisJCXN0cnVjdCBzb2NrYWRkcl9hdCAqc2F0ID0gbXNnLT5tc2dfbmFt
ZTsNCisJCXNhdC0+c2F0X2ZhbWlseSAgICAgID0gQUZfQVBQTEVUQUxLOw0KKwkJc2F0LT5zYXRf
cG9ydCAgICAgICAgPSBkZHAtPmRlaF9zcG9ydDsNCisJCXNhdC0+c2F0X2FkZHIuc19ub2RlID0g
ZGRwLT5kZWhfc25vZGU7DQorCQlzYXQtPnNhdF9hZGRyLnNfbmV0ICA9IGRkcC0+ZGVoX3NuZXQ7
DQorCQltc2ctPm1zZ19uYW1lbGVuICAgICA9IHNpemVvZigqc2F0KTsNCiAJfQ0KIA0KIAlza2Jf
ZnJlZV9kYXRhZ3JhbShzaywgc2tiKTsJLyogRnJlZSB0aGUgZGF0YWdyYW0uICovDQpkaWZmIC0t
Z2l0IGEvbmV0L2F0bS9jb21tb24uYyBiL25ldC9hdG0vY29tbW9uLmMNCmluZGV4IDQzYjZiZmUu
LjBjYTA2ZTggMTAwNjQ0DQotLS0gYS9uZXQvYXRtL2NvbW1vbi5jDQorKysgYi9uZXQvYXRtL2Nv
bW1vbi5jDQpAQCAtNTAwLDggKzUwMCw2IEBAIGludCB2Y2NfcmVjdm1zZyhzdHJ1Y3Qga2lvY2Ig
KmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIgKm1zZywNCiAJc3RydWN0
IHNrX2J1ZmYgKnNrYjsNCiAJaW50IGNvcGllZCwgZXJyb3IgPSAtRUlOVkFMOw0KIA0KLQltc2ct
Pm1zZ19uYW1lbGVuID0gMDsNCi0NCiAJaWYgKHNvY2stPnN0YXRlICE9IFNTX0NPTk5FQ1RFRCkN
CiAJCXJldHVybiAtRU5PVENPTk47DQogCWlmIChmbGFncyAmIH5NU0dfRE9OVFdBSVQpCQkvKiBv
bmx5IGhhbmRsZSBNU0dfRE9OVFdBSVQgKi8NCmRpZmYgLS1naXQgYS9uZXQvYXgyNS9hZl9heDI1
LmMgYi9uZXQvYXgyNS9hZl9heDI1LmMNCmluZGV4IDg2YWMzN2YuLjdiOGRiMGUgMTAwNjQ0DQot
LS0gYS9uZXQvYXgyNS9hZl9heDI1LmMNCisrKyBiL25ldC9heDI1L2FmX2F4MjUuYw0KQEAgLTE2
MzUsMTEgKzE2MzUsMTEgQEAgc3RhdGljIGludCBheDI1X3JlY3Ztc2coc3RydWN0IGtpb2NiICpp
b2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIA0KIAlza2JfY29weV9kYXRhZ3JhbV9pb3ZlYyhz
a2IsIDAsIG1zZy0+bXNnX2lvdiwgY29waWVkKTsNCiANCi0JaWYgKG1zZy0+bXNnX25hbWVsZW4g
IT0gMCkgew0KLQkJc3RydWN0IHNvY2thZGRyX2F4MjUgKnNheCA9IChzdHJ1Y3Qgc29ja2FkZHJf
YXgyNSAqKW1zZy0+bXNnX25hbWU7DQorCWlmIChtc2ctPm1zZ19uYW1lKSB7DQogCQlheDI1X2Rp
Z2kgZGlnaTsNCiAJCWF4MjVfYWRkcmVzcyBzcmM7DQogCQljb25zdCB1bnNpZ25lZCBjaGFyICpt
YWMgPSBza2JfbWFjX2hlYWRlcihza2IpOw0KKwkJc3RydWN0IHNvY2thZGRyX2F4MjUgKnNheCA9
IG1zZy0+bXNnX25hbWU7DQogDQogCQltZW1zZXQoc2F4LCAwLCBzaXplb2Yoc3RydWN0IGZ1bGxf
c29ja2FkZHJfYXgyNSkpOw0KIAkJYXgyNV9hZGRyX3BhcnNlKG1hYyArIDEsIHNrYi0+ZGF0YSAt
IG1hYyAtIDEsICZzcmMsIE5VTEwsDQpkaWZmIC0tZ2l0IGEvbmV0L2JsdWV0b290aC9hZl9ibHVl
dG9vdGguYyBiL25ldC9ibHVldG9vdGgvYWZfYmx1ZXRvb3RoLmMNCmluZGV4IDgzOGYxMTMuLjA5
MzhmNmIgMTAwNjQ0DQotLS0gYS9uZXQvYmx1ZXRvb3RoL2FmX2JsdWV0b290aC5jDQorKysgYi9u
ZXQvYmx1ZXRvb3RoL2FmX2JsdWV0b290aC5jDQpAQCAtMjQ1LDggKzI0NSw2IEBAIGludCBidF9z
b2NrX3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAlp
ZiAoZmxhZ3MgJiAoTVNHX09PQikpDQogCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQogDQotCW1zZy0+
bXNnX25hbWVsZW4gPSAwOw0KLQ0KIAlza2IgPSBza2JfcmVjdl9kYXRhZ3JhbShzaywgZmxhZ3Ms
IG5vYmxvY2ssICZlcnIpOw0KIAlpZiAoIXNrYikgew0KIAkJaWYgKHNrLT5za19zaHV0ZG93biAm
IFJDVl9TSFVURE9XTikNCkBAIC0zMTEsOCArMzA5LDYgQEAgaW50IGJ0X3NvY2tfc3RyZWFtX3Jl
Y3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAlpZiAoZmxh
Z3MgJiBNU0dfT09CKQ0KIAkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KIA0KLQltc2ctPm1zZ19uYW1l
bGVuID0gMDsNCi0NCiAJQlRfREJHKCJzayAlcCBzaXplICV6dSIsIHNrLCBzaXplKTsNCiANCiAJ
bG9ja19zb2NrKHNrKTsNCmRpZmYgLS1naXQgYS9uZXQvYmx1ZXRvb3RoL2hjaV9zb2NrLmMgYi9u
ZXQvYmx1ZXRvb3RoL2hjaV9zb2NrLmMNCmluZGV4IDgzNjFlZTQuLmJiNzhjNzUgMTAwNjQ0DQot
LS0gYS9uZXQvYmx1ZXRvb3RoL2hjaV9zb2NrLmMNCisrKyBiL25ldC9ibHVldG9vdGgvaGNpX3Nv
Y2suYw0KQEAgLTQ0OCw4ICs0NDgsNiBAQCBzdGF0aWMgaW50IGhjaV9zb2NrX3JlY3Ztc2coc3Ry
dWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAlpZiAoIXNrYikNCiAJCXJl
dHVybiBlcnI7DQogDQotCW1zZy0+bXNnX25hbWVsZW4gPSAwOw0KLQ0KIAljb3BpZWQgPSBza2It
PmxlbjsNCiAJaWYgKGxlbiA8IGNvcGllZCkgew0KIAkJbXNnLT5tc2dfZmxhZ3MgfD0gTVNHX1RS
VU5DOw0KZGlmZiAtLWdpdCBhL25ldC9ibHVldG9vdGgvcmZjb21tL3NvY2suYyBiL25ldC9ibHVl
dG9vdGgvcmZjb21tL3NvY2suYw0KaW5kZXggODJjZTE2NC4uMTRjNDg2NCAxMDA2NDQNCi0tLSBh
L25ldC9ibHVldG9vdGgvcmZjb21tL3NvY2suYw0KKysrIGIvbmV0L2JsdWV0b290aC9yZmNvbW0v
c29jay5jDQpAQCAtNjI3LDcgKzYyNyw2IEBAIHN0YXRpYyBpbnQgcmZjb21tX3NvY2tfcmVjdm1z
ZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogDQogCWlmICh0ZXN0
X2FuZF9jbGVhcl9iaXQoUkZDT01NX0RFRkVSX1NFVFVQLCAmZC0+ZmxhZ3MpKSB7DQogCQlyZmNv
bW1fZGxjX2FjY2VwdChkKTsNCi0JCW1zZy0+bXNnX25hbWVsZW4gPSAwOw0KIAkJcmV0dXJuIDA7
DQogCX0NCiANCmRpZmYgLS1naXQgYS9uZXQvYnJpZGdlL2JyX2lmLmMgYi9uZXQvYnJpZGdlL2Jy
X2lmLmMNCmluZGV4IGYzZjc1YWQuLjU2NjkzYzMgMTAwNjQ0DQotLS0gYS9uZXQvYnJpZGdlL2Jy
X2lmLmMNCisrKyBiL25ldC9icmlkZ2UvYnJfaWYuYw0KQEAgLTE3MCw2ICsxNzAsOCBAQCB2b2lk
IGJyX2Rldl9kZWxldGUoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IGxpc3RfaGVhZCAq
aGVhZCkNCiAJCWRlbF9uYnAocCk7DQogCX0NCiANCisJYnJfZmRiX2RlbGV0ZV9ieV9wb3J0KGJy
LCBOVUxMLCAxKTsNCisNCiAJZGVsX3RpbWVyX3N5bmMoJmJyLT5nY190aW1lcik7DQogDQogCWJy
X3N5c2ZzX2RlbGJyKGJyLT5kZXYpOw0KZGlmZiAtLWdpdCBhL25ldC9jYWlmL2NhaWZfc29ja2V0
LmMgYi9uZXQvY2FpZi9jYWlmX3NvY2tldC5jDQppbmRleCA1M2E4ZTM3Li43ZmFjNzVmIDEwMDY0
NA0KLS0tIGEvbmV0L2NhaWYvY2FpZl9zb2NrZXQuYw0KKysrIGIvbmV0L2NhaWYvY2FpZl9zb2Nr
ZXQuYw0KQEAgLTMyMCw4ICszMjAsNiBAQCBzdGF0aWMgaW50IGNhaWZfc2VxcGt0X3JlY3Ztc2co
c3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAlpZiAobS0+bXNnX2Zs
YWdzJk1TR19PT0IpDQogCQlnb3RvIHJlYWRfZXJyb3I7DQogDQotCW0tPm1zZ19uYW1lbGVuID0g
MDsNCi0NCiAJc2tiID0gc2tiX3JlY3ZfZGF0YWdyYW0oc2ssIGZsYWdzLCAwICwgJnJldCk7DQog
CWlmICghc2tiKQ0KIAkJZ290byByZWFkX2Vycm9yOw0KQEAgLTM5NSw4ICszOTMsNiBAQCBzdGF0
aWMgaW50IGNhaWZfc3RyZWFtX3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29j
a2V0ICpzb2NrLA0KIAlpZiAoZmxhZ3MmTVNHX09PQikNCiAJCWdvdG8gb3V0Ow0KIA0KLQltc2ct
Pm1zZ19uYW1lbGVuID0gMDsNCi0NCiAJLyoNCiAJICogTG9jayB0aGUgc29ja2V0IHRvIHByZXZl
bnQgcXVldWUgZGlzb3JkZXJpbmcNCiAJICogd2hpbGUgc2xlZXBzIGluIG1lbWNweV90b21zZw0K
ZGlmZiAtLWdpdCBhL25ldC9jb21wYXQuYyBiL25ldC9jb21wYXQuYw0KaW5kZXggMzEzOWVmMi4u
NDE3MjRjOSAxMDA2NDQNCi0tLSBhL25ldC9jb21wYXQuYw0KKysrIGIvbmV0L2NvbXBhdC5jDQpA
QCAtNzIsNyArNzIsNyBAQCBpbnQgZ2V0X2NvbXBhdF9tc2doZHIoc3RydWN0IG1zZ2hkciAqa21z
Zywgc3RydWN0IGNvbXBhdF9tc2doZHIgX191c2VyICp1bXNnKQ0KIAkgICAgX19nZXRfdXNlcihr
bXNnLT5tc2dfZmxhZ3MsICZ1bXNnLT5tc2dfZmxhZ3MpKQ0KIAkJcmV0dXJuIC1FRkFVTFQ7DQog
CWlmIChrbXNnLT5tc2dfbmFtZWxlbiA+IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFnZSkp
DQotCQlyZXR1cm4gLUVJTlZBTDsNCisJCWttc2ctPm1zZ19uYW1lbGVuID0gc2l6ZW9mKHN0cnVj
dCBzb2NrYWRkcl9zdG9yYWdlKTsNCiAJa21zZy0+bXNnX25hbWUgPSBjb21wYXRfcHRyKHRtcDEp
Ow0KIAlrbXNnLT5tc2dfaW92ID0gY29tcGF0X3B0cih0bXAyKTsNCiAJa21zZy0+bXNnX2NvbnRy
b2wgPSBjb21wYXRfcHRyKHRtcDMpOw0KQEAgLTkzLDcgKzkzLDggQEAgaW50IHZlcmlmeV9jb21w
YXRfaW92ZWMoc3RydWN0IG1zZ2hkciAqa2Vybl9tc2csIHN0cnVjdCBpb3ZlYyAqa2Vybl9pb3Ys
DQogCQkJaWYgKGVyciA8IDApDQogCQkJCXJldHVybiBlcnI7DQogCQl9DQotCQlrZXJuX21zZy0+
bXNnX25hbWUgPSBrZXJuX2FkZHJlc3M7DQorCQlpZiAoa2Vybl9tc2ctPm1zZ19uYW1lKQ0KKwkJ
CWtlcm5fbXNnLT5tc2dfbmFtZSA9IGtlcm5fYWRkcmVzczsNCiAJfSBlbHNlDQogCQlrZXJuX21z
Zy0+bXNnX25hbWUgPSBOVUxMOw0KIA0KZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Rldi5jIGIvbmV0
L2NvcmUvZGV2LmMNCmluZGV4IDhlNDU1YjguLjdiY2YzN2QgMTAwNjQ0DQotLS0gYS9uZXQvY29y
ZS9kZXYuYw0KKysrIGIvbmV0L2NvcmUvZGV2LmMNCkBAIC0yNjA5LDYgKzI2MDksOCBAQCBpcDoN
CiAJCQlnb3RvIGRvbmU7DQogDQogCQlpcCA9IChjb25zdCBzdHJ1Y3QgaXBoZHIgKikgKHNrYi0+
ZGF0YSArIG5ob2ZmKTsNCisJCWlmIChpcC0+aWhsIDwgNSkNCisJCQlnb3RvIGRvbmU7DQogCQlp
ZiAoaXBfaXNfZnJhZ21lbnQoaXApKQ0KIAkJCWlwX3Byb3RvID0gMDsNCiAJCWVsc2UNCkBAIC00
NTE1LDcgKzQ1MTcsNyBAQCBzdGF0aWMgdm9pZCBkZXZfY2hhbmdlX3J4X2ZsYWdzKHN0cnVjdCBu
ZXRfZGV2aWNlICpkZXYsIGludCBmbGFncykNCiB7DQogCWNvbnN0IHN0cnVjdCBuZXRfZGV2aWNl
X29wcyAqb3BzID0gZGV2LT5uZXRkZXZfb3BzOw0KIA0KLQlpZiAoKGRldi0+ZmxhZ3MgJiBJRkZf
VVApICYmIG9wcy0+bmRvX2NoYW5nZV9yeF9mbGFncykNCisJaWYgKG9wcy0+bmRvX2NoYW5nZV9y
eF9mbGFncykNCiAJCW9wcy0+bmRvX2NoYW5nZV9yeF9mbGFncyhkZXYsIGZsYWdzKTsNCiB9DQog
DQpkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvZmliX3J1bGVzLmMgYi9uZXQvY29yZS9maWJfcnVsZXMu
Yw0KaW5kZXggYzAyZTYzYy4uYzBjMjFiMSAxMDA2NDQNCi0tLSBhL25ldC9jb3JlL2ZpYl9ydWxl
cy5jDQorKysgYi9uZXQvY29yZS9maWJfcnVsZXMuYw0KQEAgLTQ0Myw3ICs0NDMsOCBAQCBzdGF0
aWMgaW50IGZpYl9ubF9kZWxydWxlKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBubG1zZ2hk
ciogbmxoLCB2b2lkICphcmcpDQogCQlpZiAoZnJoLT5hY3Rpb24gJiYgKGZyaC0+YWN0aW9uICE9
IHJ1bGUtPmFjdGlvbikpDQogCQkJY29udGludWU7DQogDQotCQlpZiAoZnJoLT50YWJsZSAmJiAo
ZnJoX2dldF90YWJsZShmcmgsIHRiKSAhPSBydWxlLT50YWJsZSkpDQorCQlpZiAoZnJoX2dldF90
YWJsZShmcmgsIHRiKSAmJg0KKwkJICAgIChmcmhfZ2V0X3RhYmxlKGZyaCwgdGIpICE9IHJ1bGUt
PnRhYmxlKSkNCiAJCQljb250aW51ZTsNCiANCiAJCWlmICh0YltGUkFfUFJJT1JJVFldICYmDQpk
aWZmIC0tZ2l0IGEvbmV0L2NvcmUvaW92ZWMuYyBiL25ldC9jb3JlL2lvdmVjLmMNCmluZGV4IGM0
MGYyN2UuLjEzOWVmOTMgMTAwNjQ0DQotLS0gYS9uZXQvY29yZS9pb3ZlYy5jDQorKysgYi9uZXQv
Y29yZS9pb3ZlYy5jDQpAQCAtNDgsNyArNDgsOCBAQCBpbnQgdmVyaWZ5X2lvdmVjKHN0cnVjdCBt
c2doZHIgKm0sIHN0cnVjdCBpb3ZlYyAqaW92LCBzdHJ1Y3Qgc29ja2FkZHIgKmFkZHJlc3MsDQog
CQkJaWYgKGVyciA8IDApDQogCQkJCXJldHVybiBlcnI7DQogCQl9DQotCQltLT5tc2dfbmFtZSA9
IGFkZHJlc3M7DQorCQlpZiAobS0+bXNnX25hbWUpDQorCQkJbS0+bXNnX25hbWUgPSBhZGRyZXNz
Ow0KIAl9IGVsc2Ugew0KIAkJbS0+bXNnX25hbWUgPSBOVUxMOw0KIAl9DQpkaWZmIC0tZ2l0IGEv
bmV0L2NvcmUvcGt0Z2VuLmMgYi9uZXQvY29yZS9wa3RnZW4uYw0KaW5kZXggMmVmN2RhMC4uODBh
ZWFjOSAxMDA2NDQNCi0tLSBhL25ldC9jb3JlL3BrdGdlbi5jDQorKysgYi9uZXQvY29yZS9wa3Rn
ZW4uYw0KQEAgLTI1MjQsNiArMjUyNCw4IEBAIHN0YXRpYyBpbnQgcHJvY2Vzc19pcHNlYyhzdHJ1
Y3QgcGt0Z2VuX2RldiAqcGt0X2RldiwNCiAJCWlmICh4KSB7DQogCQkJaW50IHJldDsNCiAJCQlf
X3U4ICpldGg7DQorCQkJc3RydWN0IGlwaGRyICppcGg7DQorDQogCQkJbmhlYWQgPSB4LT5wcm9w
cy5oZWFkZXJfbGVuIC0gc2tiX2hlYWRyb29tKHNrYik7DQogCQkJaWYgKG5oZWFkID4gMCkgew0K
IAkJCQlyZXQgPSBwc2tiX2V4cGFuZF9oZWFkKHNrYiwgbmhlYWQsIDAsIEdGUF9BVE9NSUMpOw0K
QEAgLTI1NDUsNiArMjU0NywxMSBAQCBzdGF0aWMgaW50IHByb2Nlc3NfaXBzZWMoc3RydWN0IHBr
dGdlbl9kZXYgKnBrdF9kZXYsDQogCQkJZXRoID0gKF9fdTggKikgc2tiX3B1c2goc2tiLCBFVEhf
SExFTik7DQogCQkJbWVtY3B5KGV0aCwgcGt0X2Rldi0+aGgsIDEyKTsNCiAJCQkqKHUxNiAqKSAm
ZXRoWzEyXSA9IHByb3RvY29sOw0KKw0KKwkJCS8qIFVwZGF0ZSBJUHY0IGhlYWRlciBsZW4gYXMg
d2VsbCBhcyBjaGVja3N1bSB2YWx1ZSAqLw0KKwkJCWlwaCA9IGlwX2hkcihza2IpOw0KKwkJCWlw
aC0+dG90X2xlbiA9IGh0b25zKHNrYi0+bGVuIC0gRVRIX0hMRU4pOw0KKwkJCWlwX3NlbmRfY2hl
Y2soaXBoKTsNCiAJCX0NCiAJfQ0KIAlyZXR1cm4gMTsNCmRpZmYgLS1naXQgYS9uZXQvaWVlZTgw
MjE1NC82bG93cGFuLmMgYi9uZXQvaWVlZTgwMjE1NC82bG93cGFuLmMNCmluZGV4IDE5ZDZhZWYu
LjVkNDJkZjIgMTAwNjQ0DQotLS0gYS9uZXQvaWVlZTgwMjE1NC82bG93cGFuLmMNCisrKyBiL25l
dC9pZWVlODAyMTU0LzZsb3dwYW4uYw0KQEAgLTU2Myw3ICs1NjMsNyBAQCBsb3dwYW5fcHJvY2Vz
c19kYXRhKHN0cnVjdCBza19idWZmICpza2IpDQogCSAqIFRyYWZmaWMgY2xhc3MgY2FycmllZCBp
bi1saW5lDQogCSAqIEVDTiArIERTQ1AgKDEgYnl0ZSksIEZsb3cgTGFiZWwgaXMgZWxpZGVkDQog
CSAqLw0KLQljYXNlIDE6IC8qIDEwYiAqLw0KKwljYXNlIDI6IC8qIDEwYiAqLw0KIAkJaWYgKCFz
a2ItPmxlbikNCiAJCQlnb3RvIGRyb3A7DQogCQl0bXAgPSBsb3dwYW5fZmV0Y2hfc2tiX3U4KHNr
Yik7DQpAQCAtNTc2LDcgKzU3Niw3IEBAIGxvd3Bhbl9wcm9jZXNzX2RhdGEoc3RydWN0IHNrX2J1
ZmYgKnNrYikNCiAJICogRmxvdyBMYWJlbCBjYXJyaWVkIGluLWxpbmUNCiAJICogRUNOICsgMi1i
aXQgUGFkICsgRmxvdyBMYWJlbCAoMyBieXRlcyksIERTQ1AgaXMgZWxpZGVkDQogCSAqLw0KLQlj
YXNlIDI6IC8qIDAxYiAqLw0KKwljYXNlIDE6IC8qIDAxYiAqLw0KIAkJaWYgKCFza2ItPmxlbikN
CiAJCQlnb3RvIGRyb3A7DQogCQl0bXAgPSBsb3dwYW5fZmV0Y2hfc2tiX3U4KHNrYik7DQpkaWZm
IC0tZ2l0IGEvbmV0L2lwdjQvZGF0YWdyYW0uYyBiL25ldC9pcHY0L2RhdGFncmFtLmMNCmluZGV4
IDQyNGZhZmIuLmVjMDc1MTAgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC9kYXRhZ3JhbS5jDQorKysg
Yi9uZXQvaXB2NC9kYXRhZ3JhbS5jDQpAQCAtNTcsNyArNTcsNyBAQCBpbnQgaXA0X2RhdGFncmFt
X2Nvbm5lY3Qoc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qgc29ja2FkZHIgKnVhZGRyLCBpbnQgYWRk
cl9sZW4pDQogCWlmIChJU19FUlIocnQpKSB7DQogCQllcnIgPSBQVFJfRVJSKHJ0KTsNCiAJCWlm
IChlcnIgPT0gLUVORVRVTlJFQUNIKQ0KLQkJCUlQX0lOQ19TVEFUU19CSChzb2NrX25ldChzayks
IElQU1RBVFNfTUlCX09VVE5PUk9VVEVTKTsNCisJCQlJUF9JTkNfU1RBVFMoc29ja19uZXQoc2sp
LCBJUFNUQVRTX01JQl9PVVROT1JPVVRFUyk7DQogCQlnb3RvIG91dDsNCiAJfQ0KIA0KZGlmZiAt
LWdpdCBhL25ldC9pcHY0L2lwX3NvY2tnbHVlLmMgYi9uZXQvaXB2NC9pcF9zb2NrZ2x1ZS5jDQpp
bmRleCAzYjM2MDAyLi41NDJhOWMxIDEwMDY0NA0KLS0tIGEvbmV0L2lwdjQvaXBfc29ja2dsdWUu
Yw0KKysrIGIvbmV0L2lwdjQvaXBfc29ja2dsdWUuYw0KQEAgLTM3NCw3ICszNzQsNyBAQCB2b2lk
IGlwX2xvY2FsX2Vycm9yKHN0cnVjdCBzb2NrICpzaywgaW50IGVyciwgX19iZTMyIGRhZGRyLCBf
X2JlMTYgcG9ydCwgdTMyIGluZg0KIC8qDQogICoJSGFuZGxlIE1TR19FUlJRVUVVRQ0KICAqLw0K
LWludCBpcF9yZWN2X2Vycm9yKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IG1zZ2hkciAqbXNnLCBp
bnQgbGVuKQ0KK2ludCBpcF9yZWN2X2Vycm9yKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IG1zZ2hk
ciAqbXNnLCBpbnQgbGVuLCBpbnQgKmFkZHJfbGVuKQ0KIHsNCiAJc3RydWN0IHNvY2tfZXh0ZXJy
X3NrYiAqc2VycjsNCiAJc3RydWN0IHNrX2J1ZmYgKnNrYiwgKnNrYjI7DQpAQCAtNDExLDYgKzQx
MSw3IEBAIGludCBpcF9yZWN2X2Vycm9yKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IG1zZ2hkciAq
bXNnLCBpbnQgbGVuKQ0KIAkJCQkJCSAgIHNlcnItPmFkZHJfb2Zmc2V0KTsNCiAJCXNpbi0+c2lu
X3BvcnQgPSBzZXJyLT5wb3J0Ow0KIAkJbWVtc2V0KCZzaW4tPnNpbl96ZXJvLCAwLCBzaXplb2Yo
c2luLT5zaW5femVybykpOw0KKwkJKmFkZHJfbGVuID0gc2l6ZW9mKCpzaW4pOw0KIAl9DQogDQog
CW1lbWNweSgmZXJyaGRyLmVlLCAmc2Vyci0+ZWUsIHNpemVvZihzdHJ1Y3Qgc29ja19leHRlbmRl
ZF9lcnIpKTsNCmRpZmYgLS1naXQgYS9uZXQvaXB2NC9waW5nLmMgYi9uZXQvaXB2NC9waW5nLmMN
CmluZGV4IDI5NGEzODAuLjAwOTc1YjYgMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC9waW5nLmMNCisr
KyBiL25ldC9pcHY0L3BpbmcuYw0KQEAgLTU2Nyw3ICs1NjcsNyBAQCBzdGF0aWMgaW50IHBpbmdf
c2VuZG1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrICpzaywgc3RydWN0IG1zZ2hk
ciAqbXNnLA0KIAkJZXJyID0gUFRSX0VSUihydCk7DQogCQlydCA9IE5VTEw7DQogCQlpZiAoZXJy
ID09IC1FTkVUVU5SRUFDSCkNCi0JCQlJUF9JTkNfU1RBVFNfQkgobmV0LCBJUFNUQVRTX01JQl9P
VVROT1JPVVRFUyk7DQorCQkJSVBfSU5DX1NUQVRTKG5ldCwgSVBTVEFUU19NSUJfT1VUTk9ST1VU
RVMpOw0KIAkJZ290byBvdXQ7DQogCX0NCiANCkBAIC02MjMsNyArNjIzLDYgQEAgc3RhdGljIGlu
dCBwaW5nX3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29jayAqc2ssIHN0cnVj
dCBtc2doZHIgKm1zZywNCiAJCQlzaXplX3QgbGVuLCBpbnQgbm9ibG9jaywgaW50IGZsYWdzLCBp
bnQgKmFkZHJfbGVuKQ0KIHsNCiAJc3RydWN0IGluZXRfc29jayAqaXNrID0gaW5ldF9zayhzayk7
DQotCXN0cnVjdCBzb2NrYWRkcl9pbiAqc2luID0gKHN0cnVjdCBzb2NrYWRkcl9pbiAqKW1zZy0+
bXNnX25hbWU7DQogCXN0cnVjdCBza19idWZmICpza2I7DQogCWludCBjb3BpZWQsIGVycjsNCiAN
CkBAIC02MzIsMTEgKzYzMSw4IEBAIHN0YXRpYyBpbnQgcGluZ19yZWN2bXNnKHN0cnVjdCBraW9j
YiAqaW9jYiwgc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3QgbXNnaGRyICptc2csDQogCWlmIChmbGFn
cyAmIE1TR19PT0IpDQogCQlnb3RvIG91dDsNCiANCi0JaWYgKGFkZHJfbGVuKQ0KLQkJKmFkZHJf
bGVuID0gc2l6ZW9mKCpzaW4pOw0KLQ0KIAlpZiAoZmxhZ3MgJiBNU0dfRVJSUVVFVUUpDQotCQly
ZXR1cm4gaXBfcmVjdl9lcnJvcihzaywgbXNnLCBsZW4pOw0KKwkJcmV0dXJuIGlwX3JlY3ZfZXJy
b3Ioc2ssIG1zZywgbGVuLCBhZGRyX2xlbik7DQogDQogCXNrYiA9IHNrYl9yZWN2X2RhdGFncmFt
KHNrLCBmbGFncywgbm9ibG9jaywgJmVycik7DQogCWlmICghc2tiKQ0KQEAgLTY1NiwxMSArNjUy
LDE0IEBAIHN0YXRpYyBpbnQgcGluZ19yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0
IHNvY2sgKnNrLCBzdHJ1Y3QgbXNnaGRyICptc2csDQogCXNvY2tfcmVjdl90aW1lc3RhbXAobXNn
LCBzaywgc2tiKTsNCiANCiAJLyogQ29weSB0aGUgYWRkcmVzcy4gKi8NCi0JaWYgKHNpbikgew0K
KwlpZiAobXNnLT5tc2dfbmFtZSkgew0KKwkJc3RydWN0IHNvY2thZGRyX2luICpzaW4gPSAoc3Ry
dWN0IHNvY2thZGRyX2luICopbXNnLT5tc2dfbmFtZTsNCisNCiAJCXNpbi0+c2luX2ZhbWlseSA9
IEFGX0lORVQ7DQogCQlzaW4tPnNpbl9wb3J0ID0gMCAvKiBza2ItPmgudWgtPnNvdXJjZSAqLzsN
CiAJCXNpbi0+c2luX2FkZHIuc19hZGRyID0gaXBfaGRyKHNrYiktPnNhZGRyOw0KIAkJbWVtc2V0
KHNpbi0+c2luX3plcm8sIDAsIHNpemVvZihzaW4tPnNpbl96ZXJvKSk7DQorCQkqYWRkcl9sZW4g
PSBzaXplb2YoKnNpbik7DQogCX0NCiAJaWYgKGlzay0+Y21zZ19mbGFncykNCiAJCWlwX2Ntc2df
cmVjdihtc2csIHNrYik7DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvcmF3LmMgYi9uZXQvaXB2NC9y
YXcuYw0KaW5kZXggMjgxNTAxNC4uY2ZkZWQ5MyAxMDA2NDQNCi0tLSBhL25ldC9pcHY0L3Jhdy5j
DQorKysgYi9uZXQvaXB2NC9yYXcuYw0KQEAgLTY4NiwxMSArNjg2LDggQEAgc3RhdGljIGludCBy
YXdfcmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrICpzaywgc3RydWN0IG1z
Z2hkciAqbXNnLA0KIAlpZiAoZmxhZ3MgJiBNU0dfT09CKQ0KIAkJZ290byBvdXQ7DQogDQotCWlm
IChhZGRyX2xlbikNCi0JCSphZGRyX2xlbiA9IHNpemVvZigqc2luKTsNCi0NCiAJaWYgKGZsYWdz
ICYgTVNHX0VSUlFVRVVFKSB7DQotCQllcnIgPSBpcF9yZWN2X2Vycm9yKHNrLCBtc2csIGxlbik7
DQorCQllcnIgPSBpcF9yZWN2X2Vycm9yKHNrLCBtc2csIGxlbiwgYWRkcl9sZW4pOw0KIAkJZ290
byBvdXQ7DQogCX0NCiANCkBAIC03MTYsNiArNzEzLDcgQEAgc3RhdGljIGludCByYXdfcmVjdm1z
ZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrICpzaywgc3RydWN0IG1zZ2hkciAqbXNn
LA0KIAkJc2luLT5zaW5fYWRkci5zX2FkZHIgPSBpcF9oZHIoc2tiKS0+c2FkZHI7DQogCQlzaW4t
PnNpbl9wb3J0ID0gMDsNCiAJCW1lbXNldCgmc2luLT5zaW5femVybywgMCwgc2l6ZW9mKHNpbi0+
c2luX3plcm8pKTsNCisJCSphZGRyX2xlbiA9IHNpemVvZigqc2luKTsNCiAJfQ0KIAlpZiAoaW5l
dC0+Y21zZ19mbGFncykNCiAJCWlwX2Ntc2dfcmVjdihtc2csIHNrYik7DQpkaWZmIC0tZ2l0IGEv
bmV0L2lwdjQvdGNwX2lwdjQuYyBiL25ldC9pcHY0L3RjcF9pcHY0LmMNCmluZGV4IGE5N2M5YWQu
LjkyZDcxMzggMTAwNjQ0DQotLS0gYS9uZXQvaXB2NC90Y3BfaXB2NC5jDQorKysgYi9uZXQvaXB2
NC90Y3BfaXB2NC5jDQpAQCAtMTgyLDcgKzE4Miw3IEBAIGludCB0Y3BfdjRfY29ubmVjdChzdHJ1
Y3Qgc29jayAqc2ssIHN0cnVjdCBzb2NrYWRkciAqdWFkZHIsIGludCBhZGRyX2xlbikNCiAJaWYg
KElTX0VSUihydCkpIHsNCiAJCWVyciA9IFBUUl9FUlIocnQpOw0KIAkJaWYgKGVyciA9PSAtRU5F
VFVOUkVBQ0gpDQotCQkJSVBfSU5DX1NUQVRTX0JIKHNvY2tfbmV0KHNrKSwgSVBTVEFUU19NSUJf
T1VUTk9ST1VURVMpOw0KKwkJCUlQX0lOQ19TVEFUUyhzb2NrX25ldChzayksIElQU1RBVFNfTUlC
X09VVE5PUk9VVEVTKTsNCiAJCXJldHVybiBlcnI7DQogCX0NCiANCmRpZmYgLS1naXQgYS9uZXQv
aXB2NC91ZHAuYyBiL25ldC9pcHY0L3VkcC5jDQppbmRleCA1ZGVjYzkzLi44YzJlMjU5IDEwMDY0
NA0KLS0tIGEvbmV0L2lwdjQvdWRwLmMNCisrKyBiL25ldC9pcHY0L3VkcC5jDQpAQCAtOTM3LDcg
KzkzNyw3IEBAIGludCB1ZHBfc2VuZG1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2Nr
ICpzaywgc3RydWN0IG1zZ2hkciAqbXNnLA0KIAkJCWVyciA9IFBUUl9FUlIocnQpOw0KIAkJCXJ0
ID0gTlVMTDsNCiAJCQlpZiAoZXJyID09IC1FTkVUVU5SRUFDSCkNCi0JCQkJSVBfSU5DX1NUQVRT
X0JIKG5ldCwgSVBTVEFUU19NSUJfT1VUTk9ST1VURVMpOw0KKwkJCQlJUF9JTkNfU1RBVFMobmV0
LCBJUFNUQVRTX01JQl9PVVROT1JPVVRFUyk7DQogCQkJZ290byBvdXQ7DQogCQl9DQogDQpAQCAt
MTAzNiw2ICsxMDM2LDkgQEAgaW50IHVkcF9zZW5kcGFnZShzdHJ1Y3Qgc29jayAqc2ssIHN0cnVj
dCBwYWdlICpwYWdlLCBpbnQgb2Zmc2V0LA0KIAlzdHJ1Y3QgdWRwX3NvY2sgKnVwID0gdWRwX3Nr
KHNrKTsNCiAJaW50IHJldDsNCiANCisJaWYgKGZsYWdzICYgTVNHX1NFTkRQQUdFX05PVExBU1Qp
DQorCQlmbGFncyB8PSBNU0dfTU9SRTsNCisNCiAJaWYgKCF1cC0+cGVuZGluZykgew0KIAkJc3Ry
dWN0IG1zZ2hkciBtc2cgPSB7CS5tc2dfZmxhZ3MgPSBmbGFnc3xNU0dfTU9SRSB9Ow0KIA0KQEAg
LTExNzEsMTQgKzExNzQsOCBAQCBpbnQgdWRwX3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBz
dHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBtc2doZHIgKm1zZywNCiAJaW50IGlzX3VkcGxpdGUgPSBJ
U19VRFBMSVRFKHNrKTsNCiAJYm9vbCBzbG93Ow0KIA0KLQkvKg0KLQkgKglDaGVjayBhbnkgcGFz
c2VkIGFkZHJlc3Nlcw0KLQkgKi8NCi0JaWYgKGFkZHJfbGVuKQ0KLQkJKmFkZHJfbGVuID0gc2l6
ZW9mKCpzaW4pOw0KLQ0KIAlpZiAoZmxhZ3MgJiBNU0dfRVJSUVVFVUUpDQotCQlyZXR1cm4gaXBf
cmVjdl9lcnJvcihzaywgbXNnLCBsZW4pOw0KKwkJcmV0dXJuIGlwX3JlY3ZfZXJyb3Ioc2ssIG1z
ZywgbGVuLCBhZGRyX2xlbik7DQogDQogdHJ5X2FnYWluOg0KIAlza2IgPSBfX3NrYl9yZWN2X2Rh
dGFncmFtKHNrLCBmbGFncyB8IChub2Jsb2NrID8gTVNHX0RPTlRXQUlUIDogMCksDQpAQCAtMTIz
MSw2ICsxMjI4LDcgQEAgdHJ5X2FnYWluOg0KIAkJc2luLT5zaW5fcG9ydCA9IHVkcF9oZHIoc2ti
KS0+c291cmNlOw0KIAkJc2luLT5zaW5fYWRkci5zX2FkZHIgPSBpcF9oZHIoc2tiKS0+c2FkZHI7
DQogCQltZW1zZXQoc2luLT5zaW5femVybywgMCwgc2l6ZW9mKHNpbi0+c2luX3plcm8pKTsNCisJ
CSphZGRyX2xlbiA9IHNpemVvZigqc2luKTsNCiAJfQ0KIAlpZiAoaW5ldC0+Y21zZ19mbGFncykN
CiAJCWlwX2Ntc2dfcmVjdihtc2csIHNrYik7DQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvZGF0YWdy
YW0uYyBiL25ldC9pcHY2L2RhdGFncmFtLmMNCmluZGV4IGUyNDgwNjkuLjNjN2M5NDggMTAwNjQ0
DQotLS0gYS9uZXQvaXB2Ni9kYXRhZ3JhbS5jDQorKysgYi9uZXQvaXB2Ni9kYXRhZ3JhbS5jDQpA
QCAtMzE1LDcgKzMxNSw3IEBAIHZvaWQgaXB2Nl9sb2NhbF9yeHBtdHUoc3RydWN0IHNvY2sgKnNr
LCBzdHJ1Y3QgZmxvd2k2ICpmbDYsIHUzMiBtdHUpDQogLyoNCiAgKglIYW5kbGUgTVNHX0VSUlFV
RVVFDQogICovDQotaW50IGlwdjZfcmVjdl9lcnJvcihzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBt
c2doZHIgKm1zZywgaW50IGxlbikNCitpbnQgaXB2Nl9yZWN2X2Vycm9yKHN0cnVjdCBzb2NrICpz
aywgc3RydWN0IG1zZ2hkciAqbXNnLCBpbnQgbGVuLCBpbnQgKmFkZHJfbGVuKQ0KIHsNCiAJc3Ry
dWN0IGlwdjZfcGluZm8gKm5wID0gaW5ldDZfc2soc2spOw0KIAlzdHJ1Y3Qgc29ja19leHRlcnJf
c2tiICpzZXJyOw0KQEAgLTM2Niw2ICszNjYsNyBAQCBpbnQgaXB2Nl9yZWN2X2Vycm9yKHN0cnVj
dCBzb2NrICpzaywgc3RydWN0IG1zZ2hkciAqbXNnLCBpbnQgbGVuKQ0KIAkJCWlwdjZfYWRkcl9z
ZXRfdjRtYXBwZWQoKihfX2JlMzIgKikobmggKyBzZXJyLT5hZGRyX29mZnNldCksDQogCQkJCQkg
ICAgICAgJnNpbi0+c2luNl9hZGRyKTsNCiAJCX0NCisJCSphZGRyX2xlbiA9IHNpemVvZigqc2lu
KTsNCiAJfQ0KIA0KIAltZW1jcHkoJmVycmhkci5lZSwgJnNlcnItPmVlLCBzaXplb2Yoc3RydWN0
IHNvY2tfZXh0ZW5kZWRfZXJyKSk7DQpAQCAtMzc0LDYgKzM3NSw3IEBAIGludCBpcHY2X3JlY3Zf
ZXJyb3Ioc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3QgbXNnaGRyICptc2csIGludCBsZW4pDQogCWlm
IChzZXJyLT5lZS5lZV9vcmlnaW4gIT0gU09fRUVfT1JJR0lOX0xPQ0FMKSB7DQogCQlzaW4tPnNp
bjZfZmFtaWx5ID0gQUZfSU5FVDY7DQogCQlzaW4tPnNpbjZfZmxvd2luZm8gPSAwOw0KKwkJc2lu
LT5zaW42X3BvcnQgPSAwOw0KIAkJc2luLT5zaW42X3Njb3BlX2lkID0gMDsNCiAJCWlmIChza2It
PnByb3RvY29sID09IGh0b25zKEVUSF9QX0lQVjYpKSB7DQogCQkJaXB2Nl9hZGRyX2NvcHkoJnNp
bi0+c2luNl9hZGRyLCAmaXB2Nl9oZHIoc2tiKS0+c2FkZHIpOw0KQEAgLTQxOCw3ICs0MjAsOCBA
QCBvdXQ6DQogLyoNCiAgKglIYW5kbGUgSVBWNl9SRUNWUEFUSE1UVQ0KICAqLw0KLWludCBpcHY2
X3JlY3ZfcnhwbXR1KHN0cnVjdCBzb2NrICpzaywgc3RydWN0IG1zZ2hkciAqbXNnLCBpbnQgbGVu
KQ0KK2ludCBpcHY2X3JlY3ZfcnhwbXR1KHN0cnVjdCBzb2NrICpzaywgc3RydWN0IG1zZ2hkciAq
bXNnLCBpbnQgbGVuLA0KKwkJICAgICBpbnQgKmFkZHJfbGVuKQ0KIHsNCiAJc3RydWN0IGlwdjZf
cGluZm8gKm5wID0gaW5ldDZfc2soc2spOw0KIAlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KQEAgLTQ1
Miw2ICs0NTUsNyBAQCBpbnQgaXB2Nl9yZWN2X3J4cG10dShzdHJ1Y3Qgc29jayAqc2ssIHN0cnVj
dCBtc2doZHIgKm1zZywgaW50IGxlbikNCiAJCXNpbi0+c2luNl9wb3J0ID0gMDsNCiAJCXNpbi0+
c2luNl9zY29wZV9pZCA9IG10dV9pbmZvLmlwNm1fYWRkci5zaW42X3Njb3BlX2lkOw0KIAkJaXB2
Nl9hZGRyX2NvcHkoJnNpbi0+c2luNl9hZGRyLCAmbXR1X2luZm8uaXA2bV9hZGRyLnNpbjZfYWRk
cik7DQorCQkqYWRkcl9sZW4gPSBzaXplb2YoKnNpbik7DQogCX0NCiANCiAJcHV0X2Ntc2cobXNn
LCBTT0xfSVBWNiwgSVBWNl9QQVRITVRVLCBzaXplb2YobXR1X2luZm8pLCAmbXR1X2luZm8pOw0K
ZGlmZiAtLWdpdCBhL25ldC9pcHY2L2lwNl9vdXRwdXQuYyBiL25ldC9pcHY2L2lwNl9vdXRwdXQu
Yw0KaW5kZXggOTc2NzViZi4uZDNmZGU3ZSAxMDA2NDQNCi0tLSBhL25ldC9pcHY2L2lwNl9vdXRw
dXQuYw0KKysrIGIvbmV0L2lwdjYvaXA2X291dHB1dC5jDQpAQCAtMTQ0LDggKzE0NCw4IEBAIHN0
YXRpYyBpbnQgaXA2X2ZpbmlzaF9vdXRwdXQyKHN0cnVjdCBza19idWZmICpza2IpDQogCQlyZXR1
cm4gcmVzOw0KIAl9DQogCXJjdV9yZWFkX3VubG9jaygpOw0KLQlJUDZfSU5DX1NUQVRTX0JIKGRl
dl9uZXQoZHN0LT5kZXYpLA0KLQkJCSBpcDZfZHN0X2lkZXYoZHN0KSwgSVBTVEFUU19NSUJfT1VU
Tk9ST1VURVMpOw0KKwlJUDZfSU5DX1NUQVRTKGRldl9uZXQoZHN0LT5kZXYpLA0KKwkJICAgICAg
aXA2X2RzdF9pZGV2KGRzdCksIElQU1RBVFNfTUlCX09VVE5PUk9VVEVTKTsNCiAJa2ZyZWVfc2ti
KHNrYik7DQogCXJldHVybiAtRUlOVkFMOw0KIH0NCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9yYXcu
YyBiL25ldC9pcHY2L3Jhdy5jDQppbmRleCA2ZTZjMmM0Li45ZWNiYzg0IDEwMDY0NA0KLS0tIGEv
bmV0L2lwdjYvcmF3LmMNCisrKyBiL25ldC9pcHY2L3Jhdy5jDQpAQCAtNDU2LDE0ICs0NTYsMTEg
QEAgc3RhdGljIGludCByYXd2Nl9yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IHNv
Y2sgKnNrLA0KIAlpZiAoZmxhZ3MgJiBNU0dfT09CKQ0KIAkJcmV0dXJuIC1FT1BOT1RTVVBQOw0K
IA0KLQlpZiAoYWRkcl9sZW4pDQotCQkqYWRkcl9sZW49c2l6ZW9mKCpzaW42KTsNCi0NCiAJaWYg
KGZsYWdzICYgTVNHX0VSUlFVRVVFKQ0KLQkJcmV0dXJuIGlwdjZfcmVjdl9lcnJvcihzaywgbXNn
LCBsZW4pOw0KKwkJcmV0dXJuIGlwdjZfcmVjdl9lcnJvcihzaywgbXNnLCBsZW4sIGFkZHJfbGVu
KTsNCiANCiAJaWYgKG5wLT5yeHBtdHUgJiYgbnAtPnJ4b3B0LmJpdHMucnhwbXR1KQ0KLQkJcmV0
dXJuIGlwdjZfcmVjdl9yeHBtdHUoc2ssIG1zZywgbGVuKTsNCisJCXJldHVybiBpcHY2X3JlY3Zf
cnhwbXR1KHNrLCBtc2csIGxlbiwgYWRkcl9sZW4pOw0KIA0KIAlza2IgPSBza2JfcmVjdl9kYXRh
Z3JhbShzaywgZmxhZ3MsIG5vYmxvY2ssICZlcnIpOw0KIAlpZiAoIXNrYikNCkBAIC00OTgsNiAr
NDk1LDcgQEAgc3RhdGljIGludCByYXd2Nl9yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3Ry
dWN0IHNvY2sgKnNrLA0KIAkJc2luNi0+c2luNl9zY29wZV9pZCA9IDA7DQogCQlpZiAoaXB2Nl9h
ZGRyX3R5cGUoJnNpbjYtPnNpbjZfYWRkcikgJiBJUFY2X0FERFJfTElOS0xPQ0FMKQ0KIAkJCXNp
bjYtPnNpbjZfc2NvcGVfaWQgPSBJUDZDQihza2IpLT5paWY7DQorCQkqYWRkcl9sZW4gPSBzaXpl
b2YoKnNpbjYpOw0KIAl9DQogDQogCXNvY2tfcmVjdl90c19hbmRfZHJvcHMobXNnLCBzaywgc2ti
KTsNCmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9yb3V0ZS5jIGIvbmV0L2lwdjYvcm91dGUuYw0KaW5k
ZXggYmM5MTAzZC4uMTc2ODIzOCAxMDA2NDQNCi0tLSBhL25ldC9pcHY2L3JvdXRlLmMNCisrKyBi
L25ldC9pcHY2L3JvdXRlLmMNCkBAIC01OTIsOCArNTkyLDExIEBAIGludCBydDZfcm91dGVfcmN2
KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHU4ICpvcHQsIGludCBsZW4sDQogCQlwcmVmaXggPSAm
cHJlZml4X2J1ZjsNCiAJfQ0KIA0KLQlydCA9IHJ0Nl9nZXRfcm91dGVfaW5mbyhuZXQsIHByZWZp
eCwgcmluZm8tPnByZWZpeF9sZW4sIGd3YWRkciwNCi0JCQkJZGV2LT5pZmluZGV4KTsNCisJaWYg
KHJpbmZvLT5wcmVmaXhfbGVuID09IDApDQorCQlydCA9IHJ0Nl9nZXRfZGZsdF9yb3V0ZXIoZ3dh
ZGRyLCBkZXYpOw0KKwllbHNlDQorCQlydCA9IHJ0Nl9nZXRfcm91dGVfaW5mbyhuZXQsIHByZWZp
eCwgcmluZm8tPnByZWZpeF9sZW4sDQorCQkJCQlnd2FkZHIsIGRldi0+aWZpbmRleCk7DQogDQog
CWlmIChydCAmJiAhbGlmZXRpbWUpIHsNCiAJCWlwNl9kZWxfcnQocnQpOw0KZGlmZiAtLWdpdCBh
L25ldC9pcHY2L3VkcC5jIGIvbmV0L2lwdjYvdWRwLmMNCmluZGV4IGY5ZTQ5NmIuLmY4YmVjMWUg
MTAwNjQ0DQotLS0gYS9uZXQvaXB2Ni91ZHAuYw0KKysrIGIvbmV0L2lwdjYvdWRwLmMNCkBAIC0z
NDcsMTQgKzM0NywxMSBAQCBpbnQgdWRwdjZfcmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0
cnVjdCBzb2NrICpzaywNCiAJaW50IGlzX3VkcDQ7DQogCWJvb2wgc2xvdzsNCiANCi0JaWYgKGFk
ZHJfbGVuKQ0KLQkJKmFkZHJfbGVuPXNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfaW42KTsNCi0NCiAJ
aWYgKGZsYWdzICYgTVNHX0VSUlFVRVVFKQ0KLQkJcmV0dXJuIGlwdjZfcmVjdl9lcnJvcihzaywg
bXNnLCBsZW4pOw0KKwkJcmV0dXJuIGlwdjZfcmVjdl9lcnJvcihzaywgbXNnLCBsZW4sIGFkZHJf
bGVuKTsNCiANCiAJaWYgKG5wLT5yeHBtdHUgJiYgbnAtPnJ4b3B0LmJpdHMucnhwbXR1KQ0KLQkJ
cmV0dXJuIGlwdjZfcmVjdl9yeHBtdHUoc2ssIG1zZywgbGVuKTsNCisJCXJldHVybiBpcHY2X3Jl
Y3ZfcnhwbXR1KHNrLCBtc2csIGxlbiwgYWRkcl9sZW4pOw0KIA0KIHRyeV9hZ2FpbjoNCiAJc2ti
ID0gX19za2JfcmVjdl9kYXRhZ3JhbShzaywgZmxhZ3MgfCAobm9ibG9jayA/IE1TR19ET05UV0FJ
VCA6IDApLA0KQEAgLTQyMyw3ICs0MjAsNyBAQCB0cnlfYWdhaW46DQogCQkJaWYgKGlwdjZfYWRk
cl90eXBlKCZzaW42LT5zaW42X2FkZHIpICYgSVBWNl9BRERSX0xJTktMT0NBTCkNCiAJCQkJc2lu
Ni0+c2luNl9zY29wZV9pZCA9IElQNkNCKHNrYiktPmlpZjsNCiAJCX0NCi0NCisJCSphZGRyX2xl
biA9IHNpemVvZigqc2luNik7DQogCX0NCiAJaWYgKGlzX3VkcDQpIHsNCiAJCWlmIChpbmV0LT5j
bXNnX2ZsYWdzKQ0KZGlmZiAtLWdpdCBhL25ldC9pcHgvYWZfaXB4LmMgYi9uZXQvaXB4L2FmX2lw
eC5jDQppbmRleCA5NjgwMjI2Li44YzA2YTUwIDEwMDY0NA0KLS0tIGEvbmV0L2lweC9hZl9pcHgu
Yw0KKysrIGIvbmV0L2lweC9hZl9pcHguYw0KQEAgLTE4MzUsOCArMTgzNSw2IEBAIHN0YXRpYyBp
bnQgaXB4X3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0K
IAlpZiAoc2tiLT50c3RhbXAudHY2NCkNCiAJCXNrLT5za19zdGFtcCA9IHNrYi0+dHN0YW1wOw0K
IA0KLQltc2ctPm1zZ19uYW1lbGVuID0gc2l6ZW9mKCpzaXB4KTsNCi0NCiAJaWYgKHNpcHgpIHsN
CiAJCXNpcHgtPnNpcHhfZmFtaWx5CT0gQUZfSVBYOw0KIAkJc2lweC0+c2lweF9wb3J0CQk9IGlw
eC0+aXB4X3NvdXJjZS5zb2NrOw0KQEAgLTE4NDQsNiArMTg0Miw3IEBAIHN0YXRpYyBpbnQgaXB4
X3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAkJc2lw
eC0+c2lweF9uZXR3b3JrCT0gSVBYX1NLQl9DQihza2IpLT5pcHhfc291cmNlX25ldDsNCiAJCXNp
cHgtPnNpcHhfdHlwZSAJPSBpcHgtPmlweF90eXBlOw0KIAkJc2lweC0+c2lweF96ZXJvCQk9IDA7
DQorCQltc2ctPm1zZ19uYW1lbGVuCT0gc2l6ZW9mKCpzaXB4KTsNCiAJfQ0KIAlyYyA9IGNvcGll
ZDsNCiANCmRpZmYgLS1naXQgYS9uZXQvaXJkYS9hZl9pcmRhLmMgYi9uZXQvaXJkYS9hZl9pcmRh
LmMNCmluZGV4IDkxODIxZTkuLmY1ZDAxMWEgMTAwNjQ0DQotLS0gYS9uZXQvaXJkYS9hZl9pcmRh
LmMNCisrKyBiL25ldC9pcmRhL2FmX2lyZGEuYw0KQEAgLTEzODYsOCArMTM4Niw2IEBAIHN0YXRp
YyBpbnQgaXJkYV9yZWN2bXNnX2RncmFtKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IHNvY2tl
dCAqc29jaywNCiANCiAJSVJEQV9ERUJVRyg0LCAiJXMoKVxuIiwgX19mdW5jX18pOw0KIA0KLQlt
c2ctPm1zZ19uYW1lbGVuID0gMDsNCi0NCiAJc2tiID0gc2tiX3JlY3ZfZGF0YWdyYW0oc2ssIGZs
YWdzICYgfk1TR19ET05UV0FJVCwNCiAJCQkJZmxhZ3MgJiBNU0dfRE9OVFdBSVQsICZlcnIpOw0K
IAlpZiAoIXNrYikNCkBAIC0xNDUyLDggKzE0NTAsNiBAQCBzdGF0aWMgaW50IGlyZGFfcmVjdm1z
Z19zdHJlYW0oc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAl0YXJn
ZXQgPSBzb2NrX3Jjdmxvd2F0KHNrLCBmbGFncyAmIE1TR19XQUlUQUxMLCBzaXplKTsNCiAJdGlt
ZW8gPSBzb2NrX3JjdnRpbWVvKHNrLCBub2Jsb2NrKTsNCiANCi0JbXNnLT5tc2dfbmFtZWxlbiA9
IDA7DQotDQogCWRvIHsNCiAJCWludCBjaHVuazsNCiAJCXN0cnVjdCBza19idWZmICpza2IgPSBz
a2JfZGVxdWV1ZSgmc2stPnNrX3JlY2VpdmVfcXVldWUpOw0KZGlmZiAtLWdpdCBhL25ldC9pdWN2
L2FmX2l1Y3YuYyBiL25ldC9pdWN2L2FmX2l1Y3YuYw0KaW5kZXggZTgzNjE0MC4uY2Y5OGQ2MiAx
MDA2NDQNCi0tLSBhL25ldC9pdWN2L2FmX2l1Y3YuYw0KKysrIGIvbmV0L2l1Y3YvYWZfaXVjdi5j
DQpAQCAtMTM1Niw4ICsxMzU2LDYgQEAgc3RhdGljIGludCBpdWN2X3NvY2tfcmVjdm1zZyhzdHJ1
Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCWludCBibGVuOw0KIAlpbnQg
ZXJyID0gMDsNCiANCi0JbXNnLT5tc2dfbmFtZWxlbiA9IDA7DQotDQogCWlmICgoc2stPnNrX3N0
YXRlID09IElVQ1ZfRElTQ09OTiB8fCBzay0+c2tfc3RhdGUgPT0gSVVDVl9TRVZFUkVEKSAmJg0K
IAkgICAgc2tiX3F1ZXVlX2VtcHR5KCZpdWN2LT5iYWNrbG9nX3NrYl9xKSAmJg0KIAkgICAgc2ti
X3F1ZXVlX2VtcHR5KCZzay0+c2tfcmVjZWl2ZV9xdWV1ZSkgJiYNCmRpZmYgLS1naXQgYS9uZXQv
a2V5L2FmX2tleS5jIGIvbmV0L2tleS9hZl9rZXkuYw0KaW5kZXggOGRiZGI4ZS4uZGM4ZDdlZiAx
MDA2NDQNCi0tLSBhL25ldC9rZXkvYWZfa2V5LmMNCisrKyBiL25ldC9rZXkvYWZfa2V5LmMNCkBA
IC0zNTk1LDcgKzM1OTUsNiBAQCBzdGF0aWMgaW50IHBma2V5X3JlY3Ztc2coc3RydWN0IGtpb2Ni
ICpraW9jYiwNCiAJaWYgKGZsYWdzICYgfihNU0dfUEVFS3xNU0dfRE9OVFdBSVR8TVNHX1RSVU5D
fE1TR19DTVNHX0NPTVBBVCkpDQogCQlnb3RvIG91dDsNCiANCi0JbXNnLT5tc2dfbmFtZWxlbiA9
IDA7DQogCXNrYiA9IHNrYl9yZWN2X2RhdGFncmFtKHNrLCBmbGFncywgZmxhZ3MgJiBNU0dfRE9O
VFdBSVQsICZlcnIpOw0KIAlpZiAoc2tiID09IE5VTEwpDQogCQlnb3RvIG91dDsNCmRpZmYgLS1n
aXQgYS9uZXQvbDJ0cC9sMnRwX2lwLmMgYi9uZXQvbDJ0cC9sMnRwX2lwLmMNCmluZGV4IDZjN2U2
MDkuLjMzNGE5M2QgMTAwNjQ0DQotLS0gYS9uZXQvbDJ0cC9sMnRwX2lwLmMNCisrKyBiL25ldC9s
MnRwL2wydHBfaXAuYw0KQEAgLTU2OCw5ICs1NjgsNiBAQCBzdGF0aWMgaW50IGwydHBfaXBfcmVj
dm1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrICpzaywgc3RydWN0IG1zZ2hkciAq
bQ0KIAlpZiAoZmxhZ3MgJiBNU0dfT09CKQ0KIAkJZ290byBvdXQ7DQogDQotCWlmIChhZGRyX2xl
bikNCi0JCSphZGRyX2xlbiA9IHNpemVvZigqc2luKTsNCi0NCiAJc2tiID0gc2tiX3JlY3ZfZGF0
YWdyYW0oc2ssIGZsYWdzLCBub2Jsb2NrLCAmZXJyKTsNCiAJaWYgKCFza2IpDQogCQlnb3RvIG91
dDsNCkBAIC01OTMsNiArNTkwLDcgQEAgc3RhdGljIGludCBsMnRwX2lwX3JlY3Ztc2coc3RydWN0
IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBtc2doZHIgKm0NCiAJCXNpbi0+
c2luX2FkZHIuc19hZGRyID0gaXBfaGRyKHNrYiktPnNhZGRyOw0KIAkJc2luLT5zaW5fcG9ydCA9
IDA7DQogCQltZW1zZXQoJnNpbi0+c2luX3plcm8sIDAsIHNpemVvZihzaW4tPnNpbl96ZXJvKSk7
DQorCQkqYWRkcl9sZW4gPSBzaXplb2YoKnNpbik7DQogCX0NCiAJaWYgKGluZXQtPmNtc2dfZmxh
Z3MpDQogCQlpcF9jbXNnX3JlY3YobXNnLCBza2IpOw0KZGlmZiAtLWdpdCBhL25ldC9sMnRwL2wy
dHBfcHBwLmMgYi9uZXQvbDJ0cC9sMnRwX3BwcC5jDQppbmRleCA4NTcwMDc5Li45NjljZDNlIDEw
MDY0NA0KLS0tIGEvbmV0L2wydHAvbDJ0cF9wcHAuYw0KKysrIGIvbmV0L2wydHAvbDJ0cF9wcHAu
Yw0KQEAgLTIwMCw4ICsyMDAsNiBAQCBzdGF0aWMgaW50IHBwcG9sMnRwX3JlY3Ztc2coc3RydWN0
IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAlpZiAoc2stPnNrX3N0YXRlICYg
UFBQT1hfQk9VTkQpDQogCQlnb3RvIGVuZDsNCiANCi0JbXNnLT5tc2dfbmFtZWxlbiA9IDA7DQot
DQogCWVyciA9IDA7DQogCXNrYiA9IHNrYl9yZWN2X2RhdGFncmFtKHNrLCBmbGFncyAmIH5NU0df
RE9OVFdBSVQsDQogCQkJCWZsYWdzICYgTVNHX0RPTlRXQUlULCAmZXJyKTsNCmRpZmYgLS1naXQg
YS9uZXQvbGxjL2FmX2xsYy5jIGIvbmV0L2xsYy9hZl9sbGMuYw0KaW5kZXggZTU1NjVjNy4uOTlh
NjBkNSAxMDA2NDQNCi0tLSBhL25ldC9sbGMvYWZfbGxjLmMNCisrKyBiL25ldC9sbGMvYWZfbGxj
LmMNCkBAIC03MjAsOCArNzIwLDYgQEAgc3RhdGljIGludCBsbGNfdWlfcmVjdm1zZyhzdHJ1Y3Qg
a2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCWludCB0YXJnZXQ7CS8qIFJlYWQg
YXQgbGVhc3QgdGhpcyBtYW55IGJ5dGVzICovDQogCWxvbmcgdGltZW87DQogDQotCW1zZy0+bXNn
X25hbWVsZW4gPSAwOw0KLQ0KIAlsb2NrX3NvY2soc2spOw0KIAljb3BpZWQgPSAtRU5PVENPTk47
DQogCWlmICh1bmxpa2VseShzay0+c2tfdHlwZSA9PSBTT0NLX1NUUkVBTSAmJiBzay0+c2tfc3Rh
dGUgPT0gVENQX0xJU1RFTikpDQpkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL3J4LmMgYi9uZXQv
bWFjODAyMTEvcnguYw0KaW5kZXggZGIwMWQwMi4uNzFkODU2NCAxMDA2NDQNCi0tLSBhL25ldC9t
YWM4MDIxMS9yeC5jDQorKysgYi9uZXQvbWFjODAyMTEvcnguYw0KQEAgLTc2NCw3ICs3NjQsOCBA
QCBzdGF0aWMgdm9pZCBpZWVlODAyMTFfcnhfcmVvcmRlcl9hbXBkdShzdHJ1Y3QgaWVlZTgwMjEx
X3J4X2RhdGEgKnJ4KQ0KIAl1MTYgc2M7DQogCWludCB0aWQ7DQogDQotCWlmICghaWVlZTgwMjEx
X2lzX2RhdGFfcW9zKGhkci0+ZnJhbWVfY29udHJvbCkpDQorCWlmICghaWVlZTgwMjExX2lzX2Rh
dGFfcW9zKGhkci0+ZnJhbWVfY29udHJvbCkgfHwNCisJICAgIGlzX211bHRpY2FzdF9ldGhlcl9h
ZGRyKGhkci0+YWRkcjEpKQ0KIAkJZ290byBkb250X3Jlb3JkZXI7DQogDQogCS8qDQpkaWZmIC0t
Z2l0IGEvbmV0L25ldGxpbmsvYWZfbmV0bGluay5jIGIvbmV0L25ldGxpbmsvYWZfbmV0bGluay5j
DQppbmRleCAzZDFkNTVkLi4yMzY5ZTk2IDEwMDY0NA0KLS0tIGEvbmV0L25ldGxpbmsvYWZfbmV0
bGluay5jDQorKysgYi9uZXQvbmV0bGluay9hZl9uZXRsaW5rLmMNCkBAIC0xNDQ1LDggKzE0NDUs
NiBAQCBzdGF0aWMgaW50IG5ldGxpbmtfcmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKmtpb2NiLCBzdHJ1
Y3Qgc29ja2V0ICpzb2NrLA0KIAl9DQogI2VuZGlmDQogDQotCW1zZy0+bXNnX25hbWVsZW4gPSAw
Ow0KLQ0KIAljb3BpZWQgPSBkYXRhX3NrYi0+bGVuOw0KIAlpZiAobGVuIDwgY29waWVkKSB7DQog
CQltc2ctPm1zZ19mbGFncyB8PSBNU0dfVFJVTkM7DQpkaWZmIC0tZ2l0IGEvbmV0L25ldHJvbS9h
Zl9uZXRyb20uYyBiL25ldC9uZXRyb20vYWZfbmV0cm9tLmMNCmluZGV4IDNkZjdjNWEuLmI0ZDg4
OWIgMTAwNjQ0DQotLS0gYS9uZXQvbmV0cm9tL2FmX25ldHJvbS5jDQorKysgYi9uZXQvbmV0cm9t
L2FmX25ldHJvbS5jDQpAQCAtMTE4MiwxMCArMTE4Miw5IEBAIHN0YXRpYyBpbnQgbnJfcmVjdm1z
ZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCQlzYXgtPnNheDI1
X2ZhbWlseSA9IEFGX05FVFJPTTsNCiAJCXNrYl9jb3B5X2Zyb21fbGluZWFyX2RhdGFfb2Zmc2V0
KHNrYiwgNywgc2F4LT5zYXgyNV9jYWxsLmF4MjVfY2FsbCwNCiAJCQkgICAgICBBWDI1X0FERFJf
TEVOKTsNCisJCW1zZy0+bXNnX25hbWVsZW4gPSBzaXplb2YoKnNheCk7DQogCX0NCiANCi0JbXNn
LT5tc2dfbmFtZWxlbiA9IHNpemVvZigqc2F4KTsNCi0NCiAJc2tiX2ZyZWVfZGF0YWdyYW0oc2ss
IHNrYik7DQogDQogCXJlbGVhc2Vfc29jayhzayk7DQpkaWZmIC0tZ2l0IGEvbmV0L25mYy9yYXdz
b2NrLmMgYi9uZXQvbmZjL3Jhd3NvY2suYw0KaW5kZXggN2ExNjdmYy4uMGQ1NzBkMyAxMDA2NDQN
Ci0tLSBhL25ldC9uZmMvcmF3c29jay5jDQorKysgYi9uZXQvbmZjL3Jhd3NvY2suYw0KQEAgLTI0
OCw4ICsyNDgsNiBAQCBzdGF0aWMgaW50IHJhd3NvY2tfcmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKmlv
Y2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCWlmICghc2tiKQ0KIAkJcmV0dXJuIHJjOw0KIA0K
LQltc2ctPm1zZ19uYW1lbGVuID0gMDsNCi0NCiAJY29waWVkID0gc2tiLT5sZW47DQogCWlmIChs
ZW4gPCBjb3BpZWQpIHsNCiAJCW1zZy0+bXNnX2ZsYWdzIHw9IE1TR19UUlVOQzsNCmRpZmYgLS1n
aXQgYS9uZXQvcGFja2V0L2FmX3BhY2tldC5jIGIvbmV0L3BhY2tldC9hZl9wYWNrZXQuYw0KaW5k
ZXggYTJhYzJjMy4uNGYxOWJmMiAxMDA2NDQNCi0tLSBhL25ldC9wYWNrZXQvYWZfcGFja2V0LmMN
CisrKyBiL25ldC9wYWNrZXQvYWZfcGFja2V0LmMNCkBAIC0yOTUsNiArMjk1LDcgQEAgc3RydWN0
IHBhY2tldF9zb2NrIHsNCiAJdW5zaWduZWQgaW50CQl0cF9yZXNlcnZlOw0KIAl1bnNpZ25lZCBp
bnQJCXRwX2xvc3M6MTsNCiAJdW5zaWduZWQgaW50CQl0cF90c3RhbXA7DQorCXN0cnVjdCBuZXRf
ZGV2aWNlIF9fcmN1CSpjYWNoZWRfZGV2Ow0KIAlzdHJ1Y3QgcGFja2V0X3R5cGUJcHJvdF9ob29r
IF9fX19jYWNoZWxpbmVfYWxpZ25lZF9pbl9zbXA7DQogfTsNCiANCkBAIC0zNTAsMTEgKzM1MSwx
NSBAQCBzdGF0aWMgdm9pZCBfX2Zhbm91dF9saW5rKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IHBh
Y2tldF9zb2NrICpwbyk7DQogc3RhdGljIHZvaWQgcmVnaXN0ZXJfcHJvdF9ob29rKHN0cnVjdCBz
b2NrICpzaykNCiB7DQogCXN0cnVjdCBwYWNrZXRfc29jayAqcG8gPSBwa3Rfc2soc2spOw0KKw0K
IAlpZiAoIXBvLT5ydW5uaW5nKSB7DQotCQlpZiAocG8tPmZhbm91dCkNCisJCWlmIChwby0+ZmFu
b3V0KSB7DQogCQkJX19mYW5vdXRfbGluayhzaywgcG8pOw0KLQkJZWxzZQ0KKwkJfSBlbHNlIHsN
CiAJCQlkZXZfYWRkX3BhY2soJnBvLT5wcm90X2hvb2spOw0KKwkJCXJjdV9hc3NpZ25fcG9pbnRl
cihwby0+Y2FjaGVkX2RldiwgcG8tPnByb3RfaG9vay5kZXYpOw0KKwkJfQ0KKw0KIAkJc29ja19o
b2xkKHNrKTsNCiAJCXBvLT5ydW5uaW5nID0gMTsNCiAJfQ0KQEAgLTM3MiwxMCArMzc3LDEzIEBA
IHN0YXRpYyB2b2lkIF9fdW5yZWdpc3Rlcl9wcm90X2hvb2soc3RydWN0IHNvY2sgKnNrLCBib29s
IHN5bmMpDQogCXN0cnVjdCBwYWNrZXRfc29jayAqcG8gPSBwa3Rfc2soc2spOw0KIA0KIAlwby0+
cnVubmluZyA9IDA7DQotCWlmIChwby0+ZmFub3V0KQ0KKwlpZiAocG8tPmZhbm91dCkgew0KIAkJ
X19mYW5vdXRfdW5saW5rKHNrLCBwbyk7DQotCWVsc2UNCisJfSBlbHNlIHsNCiAJCV9fZGV2X3Jl
bW92ZV9wYWNrKCZwby0+cHJvdF9ob29rKTsNCisJCVJDVV9JTklUX1BPSU5URVIocG8tPmNhY2hl
ZF9kZXYsIE5VTEwpOw0KKwl9DQorDQogCV9fc29ja19wdXQoc2spOw0KIA0KIAlpZiAoc3luYykg
ew0KQEAgLTQ5Nyw5ICs1MDUsOSBAQCBzdGF0aWMgdm9pZCBwcmJfc2h1dGRvd25fcmV0aXJlX2Js
a190aW1lcihzdHJ1Y3QgcGFja2V0X3NvY2sgKnBvLA0KIA0KIAlwa2MgPSB0eF9yaW5nID8gJnBv
LT50eF9yaW5nLnByYl9iZHFjIDogJnBvLT5yeF9yaW5nLnByYl9iZHFjOw0KIA0KLQlzcGluX2xv
Y2soJnJiX3F1ZXVlLT5sb2NrKTsNCisJc3Bpbl9sb2NrX2JoKCZyYl9xdWV1ZS0+bG9jayk7DQog
CXBrYy0+ZGVsZXRlX2Jsa190aW1lciA9IDE7DQotCXNwaW5fdW5sb2NrKCZyYl9xdWV1ZS0+bG9j
ayk7DQorCXNwaW5fdW5sb2NrX2JoKCZyYl9xdWV1ZS0+bG9jayk7DQogDQogCXByYl9kZWxfcmV0
aXJlX2Jsa190aW1lcihwa2MpOw0KIH0NCkBAIC0yMDMyLDEyICsyMDQwLDI0IEBAIHN0YXRpYyBp
bnQgdHBhY2tldF9maWxsX3NrYihzdHJ1Y3QgcGFja2V0X3NvY2sgKnBvLCBzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiLA0KIAlyZXR1cm4gdHBfbGVuOw0KIH0NCiANCitzdGF0aWMgc3RydWN0IG5ldF9kZXZp
Y2UgKnBhY2tldF9jYWNoZWRfZGV2X2dldChzdHJ1Y3QgcGFja2V0X3NvY2sgKnBvKQ0KK3sNCisJ
c3RydWN0IG5ldF9kZXZpY2UgKmRldjsNCisNCisJcmN1X3JlYWRfbG9jaygpOw0KKwlkZXYgPSBy
Y3VfZGVyZWZlcmVuY2UocG8tPmNhY2hlZF9kZXYpOw0KKwlpZiAoZGV2KQ0KKwkJZGV2X2hvbGQo
ZGV2KTsNCisJcmN1X3JlYWRfdW5sb2NrKCk7DQorDQorCXJldHVybiBkZXY7DQorfQ0KKw0KIHN0
YXRpYyBpbnQgdHBhY2tldF9zbmQoc3RydWN0IHBhY2tldF9zb2NrICpwbywgc3RydWN0IG1zZ2hk
ciAqbXNnKQ0KIHsNCiAJc3RydWN0IHNrX2J1ZmYgKnNrYjsNCiAJc3RydWN0IG5ldF9kZXZpY2Ug
KmRldjsNCiAJX19iZTE2IHByb3RvOw0KLQlib29sIG5lZWRfcmxzX2RldiA9IGZhbHNlOw0KIAlp
bnQgZXJyLCByZXNlcnZlID0gMDsNCiAJdm9pZCAqcGg7DQogCXN0cnVjdCBzb2NrYWRkcl9sbCAq
c2FkZHIgPSAoc3RydWN0IHNvY2thZGRyX2xsICopbXNnLT5tc2dfbmFtZTsNCkBAIC0yMDUwLDcg
KzIwNzAsNyBAQCBzdGF0aWMgaW50IHRwYWNrZXRfc25kKHN0cnVjdCBwYWNrZXRfc29jayAqcG8s
IHN0cnVjdCBtc2doZHIgKm1zZykNCiANCiAJZXJyID0gLUVCVVNZOw0KIAlpZiAoc2FkZHIgPT0g
TlVMTCkgew0KLQkJZGV2ID0gcG8tPnByb3RfaG9vay5kZXY7DQorCQlkZXYJPSBwYWNrZXRfY2Fj
aGVkX2Rldl9nZXQocG8pOw0KIAkJcHJvdG8JPSBwby0+bnVtOw0KIAkJYWRkcgk9IE5VTEw7DQog
CX0gZWxzZSB7DQpAQCAtMjA2NCwxOSArMjA4NCwxNyBAQCBzdGF0aWMgaW50IHRwYWNrZXRfc25k
KHN0cnVjdCBwYWNrZXRfc29jayAqcG8sIHN0cnVjdCBtc2doZHIgKm1zZykNCiAJCXByb3RvCT0g
c2FkZHItPnNsbF9wcm90b2NvbDsNCiAJCWFkZHIJPSBzYWRkci0+c2xsX2FkZHI7DQogCQlkZXYg
PSBkZXZfZ2V0X2J5X2luZGV4KHNvY2tfbmV0KCZwby0+c2spLCBzYWRkci0+c2xsX2lmaW5kZXgp
Ow0KLQkJbmVlZF9ybHNfZGV2ID0gdHJ1ZTsNCiAJfQ0KIA0KIAllcnIgPSAtRU5YSU87DQogCWlm
ICh1bmxpa2VseShkZXYgPT0gTlVMTCkpDQogCQlnb3RvIG91dDsNCi0NCi0JcmVzZXJ2ZSA9IGRl
di0+aGFyZF9oZWFkZXJfbGVuOw0KLQ0KIAllcnIgPSAtRU5FVERPV047DQogCWlmICh1bmxpa2Vs
eSghKGRldi0+ZmxhZ3MgJiBJRkZfVVApKSkNCiAJCWdvdG8gb3V0X3B1dDsNCiANCisJcmVzZXJ2
ZSA9IGRldi0+aGFyZF9oZWFkZXJfbGVuOw0KKw0KIAlzaXplX21heCA9IHBvLT50eF9yaW5nLmZy
YW1lX3NpemUNCiAJCS0gKHBvLT50cF9oZHJsZW4gLSBzaXplb2Yoc3RydWN0IHNvY2thZGRyX2xs
KSk7DQogDQpAQCAtMjE1Miw4ICsyMTcwLDcgQEAgb3V0X3N0YXR1czoNCiAJX19wYWNrZXRfc2V0
X3N0YXR1cyhwbywgcGgsIHN0YXR1cyk7DQogCWtmcmVlX3NrYihza2IpOw0KIG91dF9wdXQ6DQot
CWlmIChuZWVkX3Jsc19kZXYpDQotCQlkZXZfcHV0KGRldik7DQorCWRldl9wdXQoZGV2KTsNCiBv
dXQ6DQogCW11dGV4X3VubG9jaygmcG8tPnBnX3ZlY19sb2NrKTsNCiAJcmV0dXJuIGVycjsNCkBA
IC0yMTkxLDcgKzIyMDgsNiBAQCBzdGF0aWMgaW50IHBhY2tldF9zbmQoc3RydWN0IHNvY2tldCAq
c29jaywNCiAJc3RydWN0IHNrX2J1ZmYgKnNrYjsNCiAJc3RydWN0IG5ldF9kZXZpY2UgKmRldjsN
CiAJX19iZTE2IHByb3RvOw0KLQlib29sIG5lZWRfcmxzX2RldiA9IGZhbHNlOw0KIAl1bnNpZ25l
ZCBjaGFyICphZGRyOw0KIAlpbnQgZXJyLCByZXNlcnZlID0gMDsNCiAJc3RydWN0IHZpcnRpb19u
ZXRfaGRyIHZuZXRfaGRyID0geyAwIH07DQpAQCAtMjIwNSw3ICsyMjIxLDcgQEAgc3RhdGljIGlu
dCBwYWNrZXRfc25kKHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCSAqLw0KIA0KIAlpZiAoc2FkZHIg
PT0gTlVMTCkgew0KLQkJZGV2ID0gcG8tPnByb3RfaG9vay5kZXY7DQorCQlkZXYJPSBwYWNrZXRf
Y2FjaGVkX2Rldl9nZXQocG8pOw0KIAkJcHJvdG8JPSBwby0+bnVtOw0KIAkJYWRkcgk9IE5VTEw7
DQogCX0gZWxzZSB7DQpAQCAtMjIxNywxOSArMjIzMywxNyBAQCBzdGF0aWMgaW50IHBhY2tldF9z
bmQoc3RydWN0IHNvY2tldCAqc29jaywNCiAJCXByb3RvCT0gc2FkZHItPnNsbF9wcm90b2NvbDsN
CiAJCWFkZHIJPSBzYWRkci0+c2xsX2FkZHI7DQogCQlkZXYgPSBkZXZfZ2V0X2J5X2luZGV4KHNv
Y2tfbmV0KHNrKSwgc2FkZHItPnNsbF9pZmluZGV4KTsNCi0JCW5lZWRfcmxzX2RldiA9IHRydWU7
DQogCX0NCiANCiAJZXJyID0gLUVOWElPOw0KLQlpZiAoZGV2ID09IE5VTEwpDQorCWlmICh1bmxp
a2VseShkZXYgPT0gTlVMTCkpDQogCQlnb3RvIG91dF91bmxvY2s7DQotCWlmIChzb2NrLT50eXBl
ID09IFNPQ0tfUkFXKQ0KLQkJcmVzZXJ2ZSA9IGRldi0+aGFyZF9oZWFkZXJfbGVuOw0KLQ0KIAll
cnIgPSAtRU5FVERPV047DQotCWlmICghKGRldi0+ZmxhZ3MgJiBJRkZfVVApKQ0KKwlpZiAodW5s
aWtlbHkoIShkZXYtPmZsYWdzICYgSUZGX1VQKSkpDQogCQlnb3RvIG91dF91bmxvY2s7DQogDQor
CWlmIChzb2NrLT50eXBlID09IFNPQ0tfUkFXKQ0KKwkJcmVzZXJ2ZSA9IGRldi0+aGFyZF9oZWFk
ZXJfbGVuOw0KIAlpZiAocG8tPmhhc192bmV0X2hkcikgew0KIAkJdm5ldF9oZHJfbGVuID0gc2l6
ZW9mKHZuZXRfaGRyKTsNCiANCkBAIC0yMzUwLDE1ICsyMzY0LDE0IEBAIHN0YXRpYyBpbnQgcGFj
a2V0X3NuZChzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAlpZiAoZXJyID4gMCAmJiAoZXJyID0gbmV0
X3htaXRfZXJybm8oZXJyKSkgIT0gMCkNCiAJCWdvdG8gb3V0X3VubG9jazsNCiANCi0JaWYgKG5l
ZWRfcmxzX2RldikNCi0JCWRldl9wdXQoZGV2KTsNCisJZGV2X3B1dChkZXYpOw0KIA0KIAlyZXR1
cm4gbGVuOw0KIA0KIG91dF9mcmVlOg0KIAlrZnJlZV9za2Ioc2tiKTsNCiBvdXRfdW5sb2NrOg0K
LQlpZiAoZGV2ICYmIG5lZWRfcmxzX2RldikNCisJaWYgKGRldikNCiAJCWRldl9wdXQoZGV2KTsN
CiBvdXQ6DQogCXJldHVybiBlcnI7DQpAQCAtMjU3NSw2ICsyNTg4LDcgQEAgc3RhdGljIGludCBw
YWNrZXRfY3JlYXRlKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHNvY2tldCAqc29jaywgaW50IHBy
b3RvY29sLA0KIAlwbyA9IHBrdF9zayhzayk7DQogCXNrLT5za19mYW1pbHkgPSBQRl9QQUNLRVQ7
DQogCXBvLT5udW0gPSBwcm90bzsNCisJUkNVX0lOSVRfUE9JTlRFUihwby0+Y2FjaGVkX2Rldiwg
TlVMTCk7DQogDQogCXNrLT5za19kZXN0cnVjdCA9IHBhY2tldF9zb2NrX2Rlc3RydWN0Ow0KIAlz
a19yZWZjbnRfZGVidWdfaW5jKHNrKTsNCkBAIC0yNjYzLDcgKzI2NzcsNiBAQCBzdGF0aWMgaW50
IHBhY2tldF9yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IHNvY2tldCAqc29jaywN
CiAJc3RydWN0IHNvY2sgKnNrID0gc29jay0+c2s7DQogCXN0cnVjdCBza19idWZmICpza2I7DQog
CWludCBjb3BpZWQsIGVycjsNCi0Jc3RydWN0IHNvY2thZGRyX2xsICpzbGw7DQogCWludCB2bmV0
X2hkcl9sZW4gPSAwOw0KIA0KIAllcnIgPSAtRUlOVkFMOw0KQEAgLTI3NDYsMjIgKzI3NTksMTAg
QEAgc3RhdGljIGludCBwYWNrZXRfcmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBz
b2NrZXQgKnNvY2ssDQogCQkJZ290byBvdXRfZnJlZTsNCiAJfQ0KIA0KLQkvKg0KLQkgKglJZiB0
aGUgYWRkcmVzcyBsZW5ndGggZmllbGQgaXMgdGhlcmUgdG8gYmUgZmlsbGVkIGluLCB3ZSBmaWxs
DQotCSAqCWl0IGluIG5vdy4NCisJLyogWW91IGxvc2UgYW55IGRhdGEgYmV5b25kIHRoZSBidWZm
ZXIgeW91IGdhdmUuIElmIGl0IHdvcnJpZXMNCisJICogYSB1c2VyIHByb2dyYW0gdGhleSBjYW4g
YXNrIHRoZSBkZXZpY2UgZm9yIGl0cyBNVFUNCisJICogYW55d2F5Lg0KIAkgKi8NCi0NCi0Jc2xs
ID0gJlBBQ0tFVF9TS0JfQ0Ioc2tiKS0+c2EubGw7DQotCWlmIChzb2NrLT50eXBlID09IFNPQ0tf
UEFDS0VUKQ0KLQkJbXNnLT5tc2dfbmFtZWxlbiA9IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfcGt0
KTsNCi0JZWxzZQ0KLQkJbXNnLT5tc2dfbmFtZWxlbiA9IHNsbC0+c2xsX2hhbGVuICsgb2Zmc2V0
b2Yoc3RydWN0IHNvY2thZGRyX2xsLCBzbGxfYWRkcik7DQotDQotCS8qDQotCSAqCVlvdSBsb3Nl
IGFueSBkYXRhIGJleW9uZCB0aGUgYnVmZmVyIHlvdSBnYXZlLiBJZiBpdCB3b3JyaWVzIGENCi0J
ICoJdXNlciBwcm9ncmFtIHRoZXkgY2FuIGFzayB0aGUgZGV2aWNlIGZvciBpdHMgTVRVIGFueXdh
eS4NCi0JICovDQotDQogCWNvcGllZCA9IHNrYi0+bGVuOw0KIAlpZiAoY29waWVkID4gbGVuKSB7
DQogCQljb3BpZWQgPSBsZW47DQpAQCAtMjc3NCw5ICsyNzc1LDIwIEBAIHN0YXRpYyBpbnQgcGFj
a2V0X3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIA0K
IAlzb2NrX3JlY3ZfdHNfYW5kX2Ryb3BzKG1zZywgc2ssIHNrYik7DQogDQotCWlmIChtc2ctPm1z
Z19uYW1lKQ0KKwlpZiAobXNnLT5tc2dfbmFtZSkgew0KKwkJLyogSWYgdGhlIGFkZHJlc3MgbGVu
Z3RoIGZpZWxkIGlzIHRoZXJlIHRvIGJlIGZpbGxlZA0KKwkJICogaW4sIHdlIGZpbGwgaXQgaW4g
bm93Lg0KKwkJICovDQorCQlpZiAoc29jay0+dHlwZSA9PSBTT0NLX1BBQ0tFVCkgew0KKwkJCW1z
Zy0+bXNnX25hbWVsZW4gPSBzaXplb2Yoc3RydWN0IHNvY2thZGRyX3BrdCk7DQorCQl9IGVsc2Ug
ew0KKwkJCXN0cnVjdCBzb2NrYWRkcl9sbCAqc2xsID0gJlBBQ0tFVF9TS0JfQ0Ioc2tiKS0+c2Eu
bGw7DQorCQkJbXNnLT5tc2dfbmFtZWxlbiA9IHNsbC0+c2xsX2hhbGVuICsNCisJCQkJb2Zmc2V0
b2Yoc3RydWN0IHNvY2thZGRyX2xsLCBzbGxfYWRkcik7DQorCQl9DQogCQltZW1jcHkobXNnLT5t
c2dfbmFtZSwgJlBBQ0tFVF9TS0JfQ0Ioc2tiKS0+c2EsDQogCQkgICAgICAgbXNnLT5tc2dfbmFt
ZWxlbik7DQorCX0NCiANCiAJaWYgKHBrdF9zayhzayktPmF1eGRhdGEpIHsNCiAJCXN0cnVjdCB0
cGFja2V0X2F1eGRhdGEgYXV4Ow0KZGlmZiAtLWdpdCBhL25ldC9waG9uZXQvZGF0YWdyYW0uYyBi
L25ldC9waG9uZXQvZGF0YWdyYW0uYw0KaW5kZXggYmYzNWI0ZS4uYjI1ZjJkMyAxMDA2NDQNCi0t
LSBhL25ldC9waG9uZXQvZGF0YWdyYW0uYw0KKysrIGIvbmV0L3Bob25ldC9kYXRhZ3JhbS5jDQpA
QCAtMTM5LDkgKzEzOSw2IEBAIHN0YXRpYyBpbnQgcG5fcmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKmlv
Y2IsIHN0cnVjdCBzb2NrICpzaywNCiAJCQlNU0dfQ01TR19DT01QQVQpKQ0KIAkJZ290byBvdXRf
bm9mcmVlOw0KIA0KLQlpZiAoYWRkcl9sZW4pDQotCQkqYWRkcl9sZW4gPSBzaXplb2Yoc2EpOw0K
LQ0KIAlza2IgPSBza2JfcmVjdl9kYXRhZ3JhbShzaywgZmxhZ3MsIG5vYmxvY2ssICZydmFsKTsN
CiAJaWYgKHNrYiA9PSBOVUxMKQ0KIAkJZ290byBvdXRfbm9mcmVlOw0KQEAgLTE2Miw4ICsxNTks
MTAgQEAgc3RhdGljIGludCBwbl9yZWN2bXNnKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IHNv
Y2sgKnNrLA0KIA0KIAlydmFsID0gKGZsYWdzICYgTVNHX1RSVU5DKSA/IHNrYi0+bGVuIDogY29w
eWxlbjsNCiANCi0JaWYgKG1zZy0+bXNnX25hbWUgIT0gTlVMTCkNCi0JCW1lbWNweShtc2ctPm1z
Z19uYW1lLCAmc2EsIHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfcG4pKTsNCisJaWYgKG1zZy0+bXNn
X25hbWUgIT0gTlVMTCkgew0KKwkJbWVtY3B5KG1zZy0+bXNnX25hbWUsICZzYSwgc2l6ZW9mKHNh
KSk7DQorCQkqYWRkcl9sZW4gPSBzaXplb2Yoc2EpOw0KKwl9DQogDQogb3V0Og0KIAlza2JfZnJl
ZV9kYXRhZ3JhbShzaywgc2tiKTsNCmRpZmYgLS1naXQgYS9uZXQvcmRzL3JlY3YuYyBiL25ldC9y
ZHMvcmVjdi5jDQppbmRleCBmYzU3ZDMxLi45NmExMjM5IDEwMDY0NA0KLS0tIGEvbmV0L3Jkcy9y
ZWN2LmMNCisrKyBiL25ldC9yZHMvcmVjdi5jDQpAQCAtNDEwLDggKzQxMCw2IEBAIGludCByZHNf
cmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBt
c2doZHIgKm1zZywNCiANCiAJcmRzZGVidWcoInNpemUgJXp1IGZsYWdzIDB4JXggdGltZW8gJWxk
XG4iLCBzaXplLCBtc2dfZmxhZ3MsIHRpbWVvKTsNCiANCi0JbXNnLT5tc2dfbmFtZWxlbiA9IDA7
DQotDQogCWlmIChtc2dfZmxhZ3MgJiBNU0dfT09CKQ0KIAkJZ290byBvdXQ7DQogDQpkaWZmIC0t
Z2l0IGEvbmV0L3Jvc2UvYWZfcm9zZS5jIGIvbmV0L3Jvc2UvYWZfcm9zZS5jDQppbmRleCAxZjk2
ZmI5Li5iZjc2ZGVjNyAxMDA2NDQNCi0tLSBhL25ldC9yb3NlL2FmX3Jvc2UuYw0KKysrIGIvbmV0
L3Jvc2UvYWZfcm9zZS5jDQpAQCAtMTIyMSw3ICsxMjIxLDYgQEAgc3RhdGljIGludCByb3NlX3Jl
Y3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIHsNCiAJc3Ry
dWN0IHNvY2sgKnNrID0gc29jay0+c2s7DQogCXN0cnVjdCByb3NlX3NvY2sgKnJvc2UgPSByb3Nl
X3NrKHNrKTsNCi0Jc3RydWN0IHNvY2thZGRyX3Jvc2UgKnNyb3NlID0gKHN0cnVjdCBzb2NrYWRk
cl9yb3NlICopbXNnLT5tc2dfbmFtZTsNCiAJc2l6ZV90IGNvcGllZDsNCiAJdW5zaWduZWQgY2hh
ciAqYXNtcHRyOw0KIAlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KQEAgLTEyNTcsOCArMTI1NiwxMSBA
QCBzdGF0aWMgaW50IHJvc2VfcmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBzb2Nr
ZXQgKnNvY2ssDQogDQogCXNrYl9jb3B5X2RhdGFncmFtX2lvdmVjKHNrYiwgMCwgbXNnLT5tc2df
aW92LCBjb3BpZWQpOw0KIA0KLQlpZiAoc3Jvc2UgIT0gTlVMTCkgew0KLQkJbWVtc2V0KHNyb3Nl
LCAwLCBtc2ctPm1zZ19uYW1lbGVuKTsNCisJaWYgKG1zZy0+bXNnX25hbWUpIHsNCisJCXN0cnVj
dCBzb2NrYWRkcl9yb3NlICpzcm9zZTsNCisNCisJCW1lbXNldChtc2ctPm1zZ19uYW1lLCAwLCBz
aXplb2Yoc3RydWN0IGZ1bGxfc29ja2FkZHJfcm9zZSkpOw0KKwkJc3Jvc2UgPSBtc2ctPm1zZ19u
YW1lOw0KIAkJc3Jvc2UtPnNyb3NlX2ZhbWlseSA9IEFGX1JPU0U7DQogCQlzcm9zZS0+c3Jvc2Vf
YWRkciAgID0gcm9zZS0+ZGVzdF9hZGRyOw0KIAkJc3Jvc2UtPnNyb3NlX2NhbGwgICA9IHJvc2Ut
PmRlc3RfY2FsbDsNCmRpZmYgLS1naXQgYS9uZXQvcnhycGMvYXItcmVjdm1zZy5jIGIvbmV0L3J4
cnBjL2FyLXJlY3Ztc2cuYw0KaW5kZXggNGI0ODY4Ny4uODk4NDkyYSAxMDA2NDQNCi0tLSBhL25l
dC9yeHJwYy9hci1yZWN2bXNnLmMNCisrKyBiL25ldC9yeHJwYy9hci1yZWN2bXNnLmMNCkBAIC0x
NDMsMTAgKzE0MywxMyBAQCBpbnQgcnhycGNfcmVjdm1zZyhzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0
cnVjdCBzb2NrZXQgKnNvY2ssDQogDQogCQkvKiBjb3B5IHRoZSBwZWVyIGFkZHJlc3MgYW5kIHRp
bWVzdGFtcCAqLw0KIAkJaWYgKCFjb250aW51ZV9jYWxsKSB7DQotCQkJaWYgKG1zZy0+bXNnX25h
bWUgJiYgbXNnLT5tc2dfbmFtZWxlbiA+IDApDQorCQkJaWYgKG1zZy0+bXNnX25hbWUpIHsNCisJ
CQkJc2l6ZV90IGxlbiA9DQorCQkJCQlzaXplb2YoY2FsbC0+Y29ubi0+dHJhbnMtPnBlZXItPnNy
eCk7DQogCQkJCW1lbWNweShtc2ctPm1zZ19uYW1lLA0KLQkJCQkgICAgICAgJmNhbGwtPmNvbm4t
PnRyYW5zLT5wZWVyLT5zcngsDQotCQkJCSAgICAgICBzaXplb2YoY2FsbC0+Y29ubi0+dHJhbnMt
PnBlZXItPnNyeCkpOw0KKwkJCQkgICAgICAgJmNhbGwtPmNvbm4tPnRyYW5zLT5wZWVyLT5zcngs
IGxlbik7DQorCQkJCW1zZy0+bXNnX25hbWVsZW4gPSBsZW47DQorCQkJfQ0KIAkJCXNvY2tfcmVj
dl90c19hbmRfZHJvcHMobXNnLCAmcngtPnNrLCBza2IpOw0KIAkJfQ0KIA0KZGlmZiAtLWdpdCBh
L25ldC9zb2NrZXQuYyBiL25ldC9zb2NrZXQuYw0KaW5kZXggYmY3YWRhYS4uZDRmYWFkZSAxMDA2
NDQNCi0tLSBhL25ldC9zb2NrZXQuYw0KKysrIGIvbmV0L3NvY2tldC5jDQpAQCAtMjE1LDEyICsy
MTUsMTMgQEAgc3RhdGljIGludCBtb3ZlX2FkZHJfdG9fdXNlcihzdHJ1Y3Qgc29ja2FkZHIgKmth
ZGRyLCBpbnQga2xlbiwNCiAJaW50IGVycjsNCiAJaW50IGxlbjsNCiANCisJQlVHX09OKGtsZW4g
PiBzaXplb2Yoc3RydWN0IHNvY2thZGRyX3N0b3JhZ2UpKTsNCiAJZXJyID0gZ2V0X3VzZXIobGVu
LCB1bGVuKTsNCiAJaWYgKGVycikNCiAJCXJldHVybiBlcnI7DQogCWlmIChsZW4gPiBrbGVuKQ0K
IAkJbGVuID0ga2xlbjsNCi0JaWYgKGxlbiA8IDAgfHwgbGVuID4gc2l6ZW9mKHN0cnVjdCBzb2Nr
YWRkcl9zdG9yYWdlKSkNCisJaWYgKGxlbiA8IDApDQogCQlyZXR1cm4gLUVJTlZBTDsNCiAJaWYg
KGxlbikgew0KIAkJaWYgKGF1ZGl0X3NvY2thZGRyKGtsZW4sIGthZGRyKSkNCkBAIC0xNzUyLDgg
KzE3NTMsMTAgQEAgU1lTQ0FMTF9ERUZJTkU2KHJlY3Zmcm9tLCBpbnQsIGZkLCB2b2lkIF9fdXNl
ciAqLCB1YnVmLCBzaXplX3QsIHNpemUsDQogCW1zZy5tc2dfaW92ID0gJmlvdjsNCiAJaW92Lmlv
dl9sZW4gPSBzaXplOw0KIAlpb3YuaW92X2Jhc2UgPSB1YnVmOw0KLQltc2cubXNnX25hbWUgPSAo
c3RydWN0IHNvY2thZGRyICopJmFkZHJlc3M7DQotCW1zZy5tc2dfbmFtZWxlbiA9IHNpemVvZihh
ZGRyZXNzKTsNCisJLyogU2F2ZSBzb21lIGN5Y2xlcyBhbmQgZG9uJ3QgY29weSB0aGUgYWRkcmVz
cyBpZiBub3QgbmVlZGVkICovDQorCW1zZy5tc2dfbmFtZSA9IGFkZHIgPyAoc3RydWN0IHNvY2th
ZGRyICopJmFkZHJlc3MgOiBOVUxMOw0KKwkvKiBXZSBhc3N1bWUgYWxsIGtlcm5lbCBjb2RlIGtu
b3dzIHRoZSBzaXplIG9mIHNvY2thZGRyX3N0b3JhZ2UgKi8NCisJbXNnLm1zZ19uYW1lbGVuID0g
MDsNCiAJaWYgKHNvY2stPmZpbGUtPmZfZmxhZ3MgJiBPX05PTkJMT0NLKQ0KIAkJZmxhZ3MgfD0g
TVNHX0RPTlRXQUlUOw0KIAllcnIgPSBzb2NrX3JlY3Ztc2coc29jaywgJm1zZywgc2l6ZSwgZmxh
Z3MpOw0KQEAgLTE4ODIsNyArMTg4NSw3IEBAIHN0YXRpYyBpbnQgY29weV9tc2doZHJfZnJvbV91
c2VyKHN0cnVjdCBtc2doZHIgKmttc2csDQogCWlmIChjb3B5X2Zyb21fdXNlcihrbXNnLCB1bXNn
LCBzaXplb2Yoc3RydWN0IG1zZ2hkcikpKQ0KIAkJcmV0dXJuIC1FRkFVTFQ7DQogCWlmIChrbXNn
LT5tc2dfbmFtZWxlbiA+IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFnZSkpDQotCQlyZXR1
cm4gLUVJTlZBTDsNCisJCWttc2ctPm1zZ19uYW1lbGVuID0gc2l6ZW9mKHN0cnVjdCBzb2NrYWRk
cl9zdG9yYWdlKTsNCiAJcmV0dXJuIDA7DQogfQ0KIA0KQEAgLTIxNDIsMTggKzIxNDUsMTYgQEAg
c3RhdGljIGludCBfX19zeXNfcmVjdm1zZyhzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3QgbXNn
aGRyIF9fdXNlciAqbXNnLA0KIAkJCWdvdG8gb3V0Ow0KIAl9DQogDQotCS8qDQotCSAqICAgICAg
U2F2ZSB0aGUgdXNlci1tb2RlIGFkZHJlc3MgKHZlcmlmeV9pb3ZlYyB3aWxsIGNoYW5nZSB0aGUN
Ci0JICogICAgICBrZXJuZWwgbXNnaGRyIHRvIHVzZSB0aGUga2VybmVsIGFkZHJlc3Mgc3BhY2Up
DQorCS8qIFNhdmUgdGhlIHVzZXItbW9kZSBhZGRyZXNzICh2ZXJpZnlfaW92ZWMgd2lsbCBjaGFu
Z2UgdGhlDQorCSAqIGtlcm5lbCBtc2doZHIgdG8gdXNlIHRoZSBrZXJuZWwgYWRkcmVzcyBzcGFj
ZSkNCiAJICovDQotDQogCXVhZGRyID0gKF9fZm9yY2Ugdm9pZCBfX3VzZXIgKiltc2dfc3lzLT5t
c2dfbmFtZTsNCiAJdWFkZHJfbGVuID0gQ09NUEFUX05BTUVMRU4obXNnKTsNCi0JaWYgKE1TR19D
TVNHX0NPTVBBVCAmIGZsYWdzKSB7DQorCWlmIChNU0dfQ01TR19DT01QQVQgJiBmbGFncykNCiAJ
CWVyciA9IHZlcmlmeV9jb21wYXRfaW92ZWMobXNnX3N5cywgaW92LA0KIAkJCQkJICAoc3RydWN0
IHNvY2thZGRyICopJmFkZHIsDQogCQkJCQkgIFZFUklGWV9XUklURSk7DQotCX0gZWxzZQ0KKwll
bHNlDQogCQllcnIgPSB2ZXJpZnlfaW92ZWMobXNnX3N5cywgaW92LA0KIAkJCQkgICAoc3RydWN0
IHNvY2thZGRyICopJmFkZHIsDQogCQkJCSAgIFZFUklGWV9XUklURSk7DQpAQCAtMjE2NCw2ICsy
MTY1LDkgQEAgc3RhdGljIGludCBfX19zeXNfcmVjdm1zZyhzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBz
dHJ1Y3QgbXNnaGRyIF9fdXNlciAqbXNnLA0KIAljbXNnX3B0ciA9ICh1bnNpZ25lZCBsb25nKW1z
Z19zeXMtPm1zZ19jb250cm9sOw0KIAltc2dfc3lzLT5tc2dfZmxhZ3MgPSBmbGFncyAmIChNU0df
Q01TR19DTE9FWEVDfE1TR19DTVNHX0NPTVBBVCk7DQogDQorCS8qIFdlIGFzc3VtZSBhbGwga2Vy
bmVsIGNvZGUga25vd3MgdGhlIHNpemUgb2Ygc29ja2FkZHJfc3RvcmFnZSAqLw0KKwltc2dfc3lz
LT5tc2dfbmFtZWxlbiA9IDA7DQorDQogCWlmIChzb2NrLT5maWxlLT5mX2ZsYWdzICYgT19OT05C
TE9DSykNCiAJCWZsYWdzIHw9IE1TR19ET05UV0FJVDsNCiAJZXJyID0gKG5vc2VjID8gc29ja19y
ZWN2bXNnX25vc2VjIDogc29ja19yZWN2bXNnKShzb2NrLCBtc2dfc3lzLA0KZGlmZiAtLWdpdCBh
L25ldC9zdW5ycGMveHBydHNvY2suYyBiL25ldC9zdW5ycGMveHBydHNvY2suYw0KaW5kZXggNjVm
ZTIzYi4uYmZiNzhmYSAxMDA2NDQNCi0tLSBhL25ldC9zdW5ycGMveHBydHNvY2suYw0KKysrIGIv
bmV0L3N1bnJwYy94cHJ0c29jay5jDQpAQCAtMzkwLDggKzM5MCwxMCBAQCBzdGF0aWMgaW50IHhz
X3NlbmRfa3ZlYyhzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3Qgc29ja2FkZHIgKmFkZHIsIGlu
dCBhZGRybGVuLA0KIAlyZXR1cm4ga2VybmVsX3NlbmRtc2coc29jaywgJm1zZywgTlVMTCwgMCwg
MCk7DQogfQ0KIA0KLXN0YXRpYyBpbnQgeHNfc2VuZF9wYWdlZGF0YShzdHJ1Y3Qgc29ja2V0ICpz
b2NrLCBzdHJ1Y3QgeGRyX2J1ZiAqeGRyLCB1bnNpZ25lZCBpbnQgYmFzZSwgaW50IG1vcmUpDQor
c3RhdGljIGludCB4c19zZW5kX3BhZ2VkYXRhKHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCB4
ZHJfYnVmICp4ZHIsIHVuc2lnbmVkIGludCBiYXNlLCBpbnQgbW9yZSwgYm9vbCB6ZXJvY29weSkN
CiB7DQorCXNzaXplX3QgKCpkb19zZW5kcGFnZSkoc3RydWN0IHNvY2tldCAqc29jaywgc3RydWN0
IHBhZ2UgKnBhZ2UsDQorCQkJaW50IG9mZnNldCwgc2l6ZV90IHNpemUsIGludCBmbGFncyk7DQog
CXN0cnVjdCBwYWdlICoqcHBhZ2U7DQogCXVuc2lnbmVkIGludCByZW1haW5kZXI7DQogCWludCBl
cnIsIHNlbnQgPSAwOw0KQEAgLTQwMCw2ICs0MDIsOSBAQCBzdGF0aWMgaW50IHhzX3NlbmRfcGFn
ZWRhdGEoc3RydWN0IHNvY2tldCAqc29jaywgc3RydWN0IHhkcl9idWYgKnhkciwgdW5zaWduZWQg
aQ0KIAliYXNlICs9IHhkci0+cGFnZV9iYXNlOw0KIAlwcGFnZSA9IHhkci0+cGFnZXMgKyAoYmFz
ZSA+PiBQQUdFX1NISUZUKTsNCiAJYmFzZSAmPSB+UEFHRV9NQVNLOw0KKwlkb19zZW5kcGFnZSA9
IHNvY2stPm9wcy0+c2VuZHBhZ2U7DQorCWlmICghemVyb2NvcHkpDQorCQlkb19zZW5kcGFnZSA9
IHNvY2tfbm9fc2VuZHBhZ2U7DQogCWZvcig7Oykgew0KIAkJdW5zaWduZWQgaW50IGxlbiA9IG1p
bl90KHVuc2lnbmVkIGludCwgUEFHRV9TSVpFIC0gYmFzZSwgcmVtYWluZGVyKTsNCiAJCWludCBm
bGFncyA9IFhTX1NFTkRNU0dfRkxBR1M7DQpAQCAtNDA3LDcgKzQxMiw3IEBAIHN0YXRpYyBpbnQg
eHNfc2VuZF9wYWdlZGF0YShzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3QgeGRyX2J1ZiAqeGRy
LCB1bnNpZ25lZCBpDQogCQlyZW1haW5kZXIgLT0gbGVuOw0KIAkJaWYgKHJlbWFpbmRlciAhPSAw
IHx8IG1vcmUpDQogCQkJZmxhZ3MgfD0gTVNHX01PUkU7DQotCQllcnIgPSBzb2NrLT5vcHMtPnNl
bmRwYWdlKHNvY2ssICpwcGFnZSwgYmFzZSwgbGVuLCBmbGFncyk7DQorCQllcnIgPSBkb19zZW5k
cGFnZShzb2NrLCAqcHBhZ2UsIGJhc2UsIGxlbiwgZmxhZ3MpOw0KIAkJaWYgKHJlbWFpbmRlciA9
PSAwIHx8IGVyciAhPSBsZW4pDQogCQkJYnJlYWs7DQogCQlzZW50ICs9IGVycjsNCkBAIC00Mjgs
OSArNDMzLDEwIEBAIHN0YXRpYyBpbnQgeHNfc2VuZF9wYWdlZGF0YShzdHJ1Y3Qgc29ja2V0ICpz
b2NrLCBzdHJ1Y3QgeGRyX2J1ZiAqeGRyLCB1bnNpZ25lZCBpDQogICogQGFkZHJsZW46IFVEUCBv
bmx5IC0tIGxlbmd0aCBvZiBkZXN0aW5hdGlvbiBhZGRyZXNzDQogICogQHhkcjogYnVmZmVyIGNv
bnRhaW5pbmcgdGhpcyByZXF1ZXN0DQogICogQGJhc2U6IHN0YXJ0aW5nIHBvc2l0aW9uIGluIHRo
ZSBidWZmZXINCisgKiBAemVyb2NvcHk6IHRydWUgaWYgaXQgaXMgc2FmZSB0byB1c2Ugc2VuZHBh
Z2UoKQ0KICAqDQogICovDQotc3RhdGljIGludCB4c19zZW5kcGFnZXMoc3RydWN0IHNvY2tldCAq
c29jaywgc3RydWN0IHNvY2thZGRyICphZGRyLCBpbnQgYWRkcmxlbiwgc3RydWN0IHhkcl9idWYg
KnhkciwgdW5zaWduZWQgaW50IGJhc2UpDQorc3RhdGljIGludCB4c19zZW5kcGFnZXMoc3RydWN0
IHNvY2tldCAqc29jaywgc3RydWN0IHNvY2thZGRyICphZGRyLCBpbnQgYWRkcmxlbiwgc3RydWN0
IHhkcl9idWYgKnhkciwgdW5zaWduZWQgaW50IGJhc2UsIGJvb2wgemVyb2NvcHkpDQogew0KIAl1
bnNpZ25lZCBpbnQgcmVtYWluZGVyID0geGRyLT5sZW4gLSBiYXNlOw0KIAlpbnQgZXJyLCBzZW50
ID0gMDsNCkBAIC00NTgsNyArNDY0LDcgQEAgc3RhdGljIGludCB4c19zZW5kcGFnZXMoc3RydWN0
IHNvY2tldCAqc29jaywgc3RydWN0IHNvY2thZGRyICphZGRyLCBpbnQgYWRkcmxlbiwNCiAJaWYg
KGJhc2UgPCB4ZHItPnBhZ2VfbGVuKSB7DQogCQl1bnNpZ25lZCBpbnQgbGVuID0geGRyLT5wYWdl
X2xlbiAtIGJhc2U7DQogCQlyZW1haW5kZXIgLT0gbGVuOw0KLQkJZXJyID0geHNfc2VuZF9wYWdl
ZGF0YShzb2NrLCB4ZHIsIGJhc2UsIHJlbWFpbmRlciAhPSAwKTsNCisJCWVyciA9IHhzX3NlbmRf
cGFnZWRhdGEoc29jaywgeGRyLCBiYXNlLCByZW1haW5kZXIgIT0gMCwgemVyb2NvcHkpOw0KIAkJ
aWYgKHJlbWFpbmRlciA9PSAwIHx8IGVyciAhPSBsZW4pDQogCQkJZ290byBvdXQ7DQogCQlzZW50
ICs9IGVycjsNCkBAIC01NjEsNyArNTY3LDcgQEAgc3RhdGljIGludCB4c19sb2NhbF9zZW5kX3Jl
cXVlc3Qoc3RydWN0IHJwY190YXNrICp0YXNrKQ0KIAkJCXJlcS0+cnFfc3ZlYy0+aW92X2Jhc2Us
IHJlcS0+cnFfc3ZlYy0+aW92X2xlbik7DQogDQogCXN0YXR1cyA9IHhzX3NlbmRwYWdlcyh0cmFu
c3BvcnQtPnNvY2ssIE5VTEwsIDAsDQotCQkJCQkJeGRyLCByZXEtPnJxX2J5dGVzX3NlbnQpOw0K
KwkJCQkJCXhkciwgcmVxLT5ycV9ieXRlc19zZW50LCB0cnVlKTsNCiAJZHByaW50aygiUlBDOiAg
ICAgICAlcygldSkgPSAlZFxuIiwNCiAJCQlfX2Z1bmNfXywgeGRyLT5sZW4gLSByZXEtPnJxX2J5
dGVzX3NlbnQsIHN0YXR1cyk7DQogCWlmIChsaWtlbHkoc3RhdHVzID49IDApKSB7DQpAQCAtNjE3
LDcgKzYyMyw3IEBAIHN0YXRpYyBpbnQgeHNfdWRwX3NlbmRfcmVxdWVzdChzdHJ1Y3QgcnBjX3Rh
c2sgKnRhc2spDQogCXN0YXR1cyA9IHhzX3NlbmRwYWdlcyh0cmFuc3BvcnQtPnNvY2ssDQogCQkJ
ICAgICAgeHNfYWRkcih4cHJ0KSwNCiAJCQkgICAgICB4cHJ0LT5hZGRybGVuLCB4ZHIsDQotCQkJ
ICAgICAgcmVxLT5ycV9ieXRlc19zZW50KTsNCisJCQkgICAgICByZXEtPnJxX2J5dGVzX3NlbnQs
IHRydWUpOw0KIA0KIAlkcHJpbnRrKCJSUEM6ICAgICAgIHhzX3VkcF9zZW5kX3JlcXVlc3QoJXUp
ID0gJWRcbiIsDQogCQkJeGRyLT5sZW4gLSByZXEtPnJxX2J5dGVzX3NlbnQsIHN0YXR1cyk7DQpA
QCAtNjg4LDYgKzY5NCw3IEBAIHN0YXRpYyBpbnQgeHNfdGNwX3NlbmRfcmVxdWVzdChzdHJ1Y3Qg
cnBjX3Rhc2sgKnRhc2spDQogCXN0cnVjdCBycGNfeHBydCAqeHBydCA9IHJlcS0+cnFfeHBydDsN
CiAJc3RydWN0IHNvY2tfeHBydCAqdHJhbnNwb3J0ID0gY29udGFpbmVyX29mKHhwcnQsIHN0cnVj
dCBzb2NrX3hwcnQsIHhwcnQpOw0KIAlzdHJ1Y3QgeGRyX2J1ZiAqeGRyID0gJnJlcS0+cnFfc25k
X2J1ZjsNCisJYm9vbCB6ZXJvY29weSA9IHRydWU7DQogCWludCBzdGF0dXM7DQogDQogCXhzX2Vu
Y29kZV9zdHJlYW1fcmVjb3JkX21hcmtlcigmcmVxLT5ycV9zbmRfYnVmKTsNCkBAIC02OTUsMTMg
KzcwMiwyMCBAQCBzdGF0aWMgaW50IHhzX3RjcF9zZW5kX3JlcXVlc3Qoc3RydWN0IHJwY190YXNr
ICp0YXNrKQ0KIAl4c19wa3RkdW1wKCJwYWNrZXQgZGF0YToiLA0KIAkJCQlyZXEtPnJxX3N2ZWMt
Pmlvdl9iYXNlLA0KIAkJCQlyZXEtPnJxX3N2ZWMtPmlvdl9sZW4pOw0KKwkvKiBEb24ndCB1c2Ug
emVybyBjb3B5IGlmIHRoaXMgaXMgYSByZXNlbmQuIElmIHRoZSBSUEMgY2FsbA0KKwkgKiBjb21w
bGV0ZXMgd2hpbGUgdGhlIHNvY2tldCBob2xkcyBhIHJlZmVyZW5jZSB0byB0aGUgcGFnZXMsDQor
CSAqIHRoZW4gd2UgbWF5IGVuZCB1cCByZXNlbmRpbmcgY29ycnVwdGVkIGRhdGEuDQorCSAqLw0K
KwlpZiAodGFzay0+dGtfZmxhZ3MgJiBSUENfVEFTS19TRU5UKQ0KKwkJemVyb2NvcHkgPSBmYWxz
ZTsNCiANCiAJLyogQ29udGludWUgdHJhbnNtaXR0aW5nIHRoZSBwYWNrZXQvcmVjb3JkLiBXZSBt
dXN0IGJlIGNhcmVmdWwNCiAJICogdG8gY29wZSB3aXRoIHdyaXRlc3BhY2UgY2FsbGJhY2tzIGFy
cml2aW5nIF9hZnRlcl8gd2UgaGF2ZQ0KIAkgKiBjYWxsZWQgc2VuZG1zZygpLiAqLw0KIAl3aGls
ZSAoMSkgew0KIAkJc3RhdHVzID0geHNfc2VuZHBhZ2VzKHRyYW5zcG9ydC0+c29jaywNCi0JCQkJ
CU5VTEwsIDAsIHhkciwgcmVxLT5ycV9ieXRlc19zZW50KTsNCisJCQkJCU5VTEwsIDAsIHhkciwg
cmVxLT5ycV9ieXRlc19zZW50LA0KKwkJCQkJemVyb2NvcHkpOw0KIA0KIAkJZHByaW50aygiUlBD
OiAgICAgICB4c190Y3Bfc2VuZF9yZXF1ZXN0KCV1KSA9ICVkXG4iLA0KIAkJCQl4ZHItPmxlbiAt
IHJlcS0+cnFfYnl0ZXNfc2VudCwgc3RhdHVzKTsNCmRpZmYgLS1naXQgYS9uZXQvdGlwYy9zb2Nr
ZXQuYyBiL25ldC90aXBjL3NvY2tldC5jDQppbmRleCBmZGYzNGFmLi4wNTg5NDFlIDEwMDY0NA0K
LS0tIGEvbmV0L3RpcGMvc29ja2V0LmMNCisrKyBiL25ldC90aXBjL3NvY2tldC5jDQpAQCAtOTQ5
LDkgKzk0OSw2IEBAIHN0YXRpYyBpbnQgcmVjdl9tc2coc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1
Y3Qgc29ja2V0ICpzb2NrLA0KIAkJZ290byBleGl0Ow0KIAl9DQogDQotCS8qIHdpbGwgYmUgdXBk
YXRlZCBpbiBzZXRfb3JpZ19hZGRyKCkgaWYgbmVlZGVkICovDQotCW0tPm1zZ19uYW1lbGVuID0g
MDsNCi0NCiAJdGltZW91dCA9IHNvY2tfcmN2dGltZW8oc2ssIGZsYWdzICYgTVNHX0RPTlRXQUlU
KTsNCiByZXN0YXJ0Og0KIA0KQEAgLTEwNzgsOSArMTA3NSw2IEBAIHN0YXRpYyBpbnQgcmVjdl9z
dHJlYW0oc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAkJZ290byBl
eGl0Ow0KIAl9DQogDQotCS8qIHdpbGwgYmUgdXBkYXRlZCBpbiBzZXRfb3JpZ19hZGRyKCkgaWYg
bmVlZGVkICovDQotCW0tPm1zZ19uYW1lbGVuID0gMDsNCi0NCiAJdGFyZ2V0ID0gc29ja19yY3Zs
b3dhdChzaywgZmxhZ3MgJiBNU0dfV0FJVEFMTCwgYnVmX2xlbik7DQogCXRpbWVvdXQgPSBzb2Nr
X3JjdnRpbWVvKHNrLCBmbGFncyAmIE1TR19ET05UV0FJVCk7DQogcmVzdGFydDoNCmRpZmYgLS1n
aXQgYS9uZXQvdW5peC9hZl91bml4LmMgYi9uZXQvdW5peC9hZl91bml4LmMNCmluZGV4IDUxMjJi
MjIuLjkzMzhjY2MgMTAwNjQ0DQotLS0gYS9uZXQvdW5peC9hZl91bml4LmMNCisrKyBiL25ldC91
bml4L2FmX3VuaXguYw0KQEAgLTE3NDQsNyArMTc0NCw2IEBAIHN0YXRpYyB2b2lkIHVuaXhfY29w
eV9hZGRyKHN0cnVjdCBtc2doZHIgKm1zZywgc3RydWN0IHNvY2sgKnNrKQ0KIHsNCiAJc3RydWN0
IHVuaXhfc29jayAqdSA9IHVuaXhfc2soc2spOw0KIA0KLQltc2ctPm1zZ19uYW1lbGVuID0gMDsN
CiAJaWYgKHUtPmFkZHIpIHsNCiAJCW1zZy0+bXNnX25hbWVsZW4gPSB1LT5hZGRyLT5sZW47DQog
CQltZW1jcHkobXNnLT5tc2dfbmFtZSwgdS0+YWRkci0+bmFtZSwgdS0+YWRkci0+bGVuKTsNCkBA
IC0xNzY3LDggKzE3NjYsNiBAQCBzdGF0aWMgaW50IHVuaXhfZGdyYW1fcmVjdm1zZyhzdHJ1Y3Qg
a2lvY2IgKmlvY2IsIHN0cnVjdCBzb2NrZXQgKnNvY2ssDQogCWlmIChmbGFncyZNU0dfT09CKQ0K
IAkJZ290byBvdXQ7DQogDQotCW1zZy0+bXNnX25hbWVsZW4gPSAwOw0KLQ0KIAllcnIgPSBtdXRl
eF9sb2NrX2ludGVycnVwdGlibGUoJnUtPnJlYWRsb2NrKTsNCiAJaWYgKGVycikgew0KIAkJZXJy
ID0gc29ja19pbnRyX2Vycm5vKHNvY2tfcmN2dGltZW8oc2ssIG5vYmxvY2spKTsNCkBAIC0xOTAy
LDggKzE4OTksNiBAQCBzdGF0aWMgaW50IHVuaXhfc3RyZWFtX3JlY3Ztc2coc3RydWN0IGtpb2Ni
ICppb2NiLCBzdHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAl0YXJnZXQgPSBzb2NrX3Jjdmxvd2F0KHNr
LCBmbGFncyZNU0dfV0FJVEFMTCwgc2l6ZSk7DQogCXRpbWVvID0gc29ja19yY3Z0aW1lbyhzaywg
ZmxhZ3MmTVNHX0RPTlRXQUlUKTsNCiANCi0JbXNnLT5tc2dfbmFtZWxlbiA9IDA7DQotDQogCS8q
IExvY2sgdGhlIHNvY2tldCB0byBwcmV2ZW50IHF1ZXVlIGRpc29yZGVyaW5nDQogCSAqIHdoaWxl
IHNsZWVwcyBpbiBtZW1jcHlfdG9tc2cNCiAJICovDQpkaWZmIC0tZ2l0IGEvbmV0L3gyNS9hZl94
MjUuYyBiL25ldC94MjUvYWZfeDI1LmMNCmluZGV4IGRjMjRiYTkuLjA3Yjk5NzMgMTAwNjQ0DQot
LS0gYS9uZXQveDI1L2FmX3gyNS5jDQorKysgYi9uZXQveDI1L2FmX3gyNS5jDQpAQCAtMTM0Mywx
MCArMTM0Myw5IEBAIHN0YXRpYyBpbnQgeDI1X3JlY3Ztc2coc3RydWN0IGtpb2NiICppb2NiLCBz
dHJ1Y3Qgc29ja2V0ICpzb2NrLA0KIAlpZiAoc3gyNSkgew0KIAkJc3gyNS0+c3gyNV9mYW1pbHkg
PSBBRl9YMjU7DQogCQlzeDI1LT5zeDI1X2FkZHIgICA9IHgyNS0+ZGVzdF9hZGRyOw0KKwkJbXNn
LT5tc2dfbmFtZWxlbiA9IHNpemVvZigqc3gyNSk7DQogCX0NCiANCi0JbXNnLT5tc2dfbmFtZWxl
biA9IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfeDI1KTsNCi0NCiAJeDI1X2NoZWNrX3JidWYoc2sp
Ow0KIAlyYyA9IGNvcGllZDsNCiBvdXRfZnJlZV9kZ3JhbToNCmRpZmYgLS1naXQgYS9zZWN1cml0
eS9zZWxpbnV4L2hvb2tzLmMgYi9zZWN1cml0eS9zZWxpbnV4L2hvb2tzLmMNCmluZGV4IDExMjZj
MTAuLjU4OThmMzQgMTAwNjQ0DQotLS0gYS9zZWN1cml0eS9zZWxpbnV4L2hvb2tzLmMNCisrKyBi
L3NlY3VyaXR5L3NlbGludXgvaG9va3MuYw0KQEAgLTUzLDYgKzUzLDcgQEANCiAjaW5jbHVkZSA8
bmV0L2ljbXAuaD4NCiAjaW5jbHVkZSA8bmV0L2lwLmg+CQkvKiBmb3IgbG9jYWxfcG9ydF9yYW5n
ZVtdICovDQogI2luY2x1ZGUgPG5ldC90Y3AuaD4JCS8qIHN0cnVjdCBvcl9jYWxsYWJsZSB1c2Vk
IGluIHNvY2tfcmN2X3NrYiAqLw0KKyNpbmNsdWRlIDxuZXQvaW5ldF9jb25uZWN0aW9uX3NvY2su
aD4NCiAjaW5jbHVkZSA8bmV0L25ldF9uYW1lc3BhY2UuaD4NCiAjaW5jbHVkZSA8bmV0L25ldGxh
YmVsLmg+DQogI2luY2x1ZGUgPGxpbnV4L3VhY2Nlc3MuaD4NCkBAIC0zNzA0LDYgKzM3MDUsMzAg
QEAgc3RhdGljIGludCBzZWxpbnV4X3NrYl9wZWVybGJsX3NpZChzdHJ1Y3Qgc2tfYnVmZiAqc2ti
LCB1MTYgZmFtaWx5LCB1MzIgKnNpZCkNCiAJcmV0dXJuIDA7DQogfQ0KIA0KKy8qKg0KKyAqIHNl
bGludXhfY29ubl9zaWQgLSBEZXRlcm1pbmUgdGhlIGNoaWxkIHNvY2tldCBsYWJlbCBmb3IgYSBj
b25uZWN0aW9uDQorICogQHNrX3NpZDogdGhlIHBhcmVudCBzb2NrZXQncyBTSUQNCisgKiBAc2ti
X3NpZDogdGhlIHBhY2tldCdzIFNJRA0KKyAqIEBjb25uX3NpZDogdGhlIHJlc3VsdGluZyBjb25u
ZWN0aW9uIFNJRA0KKyAqDQorICogSWYgQHNrYl9zaWQgaXMgdmFsaWQgdGhlbiB0aGUgdXNlcjpy
b2xlOnR5cGUgaW5mb3JtYXRpb24gZnJvbSBAc2tfc2lkIGlzDQorICogY29tYmluZWQgd2l0aCB0
aGUgTUxTIGluZm9ybWF0aW9uIGZyb20gQHNrYl9zaWQgaW4gb3JkZXIgdG8gY3JlYXRlDQorICog
QGNvbm5fc2lkLiAgSWYgQHNrYl9zaWQgaXMgbm90IHZhbGlkIHRoZW4gdGhlbiBAY29ubl9zaWQg
aXMgc2ltcGx5IGEgY29weQ0KKyAqIG9mIEBza19zaWQuICBSZXR1cm5zIHplcm8gb24gc3VjY2Vz
cywgbmVnYXRpdmUgdmFsdWVzIG9uIGZhaWx1cmUuDQorICoNCisgKi8NCitzdGF0aWMgaW50IHNl
bGludXhfY29ubl9zaWQodTMyIHNrX3NpZCwgdTMyIHNrYl9zaWQsIHUzMiAqY29ubl9zaWQpDQor
ew0KKwlpbnQgZXJyID0gMDsNCisNCisJaWYgKHNrYl9zaWQgIT0gU0VDU0lEX05VTEwpDQorCQll
cnIgPSBzZWN1cml0eV9zaWRfbWxzX2NvcHkoc2tfc2lkLCBza2Jfc2lkLCBjb25uX3NpZCk7DQor
CWVsc2UNCisJCSpjb25uX3NpZCA9IHNrX3NpZDsNCisNCisJcmV0dXJuIGVycjsNCit9DQorDQog
Lyogc29ja2V0IHNlY3VyaXR5IG9wZXJhdGlvbnMgKi8NCiANCiBzdGF0aWMgaW50IHNvY2tldF9z
b2NrY3JlYXRlX3NpZChjb25zdCBzdHJ1Y3QgdGFza19zZWN1cml0eV9zdHJ1Y3QgKnRzZWMsDQpA
QCAtNDI5NSw3ICs0MzIwLDcgQEAgc3RhdGljIGludCBzZWxpbnV4X2luZXRfY29ubl9yZXF1ZXN0
KHN0cnVjdCBzb2NrICpzaywgc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJc3RydWN0IHNrX3NlY3Vy
aXR5X3N0cnVjdCAqc2tzZWMgPSBzay0+c2tfc2VjdXJpdHk7DQogCWludCBlcnI7DQogCXUxNiBm
YW1pbHkgPSBzay0+c2tfZmFtaWx5Ow0KLQl1MzIgbmV3c2lkOw0KKwl1MzIgY29ubnNpZDsNCiAJ
dTMyIHBlZXJzaWQ7DQogDQogCS8qIGhhbmRsZSBtYXBwZWQgSVB2NCBwYWNrZXRzIGFycml2aW5n
IHZpYSBJUHY2IHNvY2tldHMgKi8NCkBAIC00MzA1LDE2ICs0MzMwLDExIEBAIHN0YXRpYyBpbnQg
c2VsaW51eF9pbmV0X2Nvbm5fcmVxdWVzdChzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19idWZm
ICpza2IsDQogCWVyciA9IHNlbGludXhfc2tiX3BlZXJsYmxfc2lkKHNrYiwgZmFtaWx5LCAmcGVl
cnNpZCk7DQogCWlmIChlcnIpDQogCQlyZXR1cm4gZXJyOw0KLQlpZiAocGVlcnNpZCA9PSBTRUNT
SURfTlVMTCkgew0KLQkJcmVxLT5zZWNpZCA9IHNrc2VjLT5zaWQ7DQotCQlyZXEtPnBlZXJfc2Vj
aWQgPSBTRUNTSURfTlVMTDsNCi0JfSBlbHNlIHsNCi0JCWVyciA9IHNlY3VyaXR5X3NpZF9tbHNf
Y29weShza3NlYy0+c2lkLCBwZWVyc2lkLCAmbmV3c2lkKTsNCi0JCWlmIChlcnIpDQotCQkJcmV0
dXJuIGVycjsNCi0JCXJlcS0+c2VjaWQgPSBuZXdzaWQ7DQotCQlyZXEtPnBlZXJfc2VjaWQgPSBw
ZWVyc2lkOw0KLQl9DQorCWVyciA9IHNlbGludXhfY29ubl9zaWQoc2tzZWMtPnNpZCwgcGVlcnNp
ZCwgJmNvbm5zaWQpOw0KKwlpZiAoZXJyKQ0KKwkJcmV0dXJuIGVycjsNCisJcmVxLT5zZWNpZCA9
IGNvbm5zaWQ7DQorCXJlcS0+cGVlcl9zZWNpZCA9IHBlZXJzaWQ7DQogDQogCXJldHVybiBzZWxp
bnV4X25ldGxibF9pbmV0X2Nvbm5fcmVxdWVzdChyZXEsIGZhbWlseSk7DQogfQ0KQEAgLTQ1NDIs
NiArNDU2Miw3IEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgc2VsaW51eF9pcHY2X2ZvcndhcmQodW5z
aWduZWQgaW50IGhvb2tudW0sDQogc3RhdGljIHVuc2lnbmVkIGludCBzZWxpbnV4X2lwX291dHB1
dChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIAkJCQkgICAgICB1MTYgZmFtaWx5KQ0KIHsNCisJc3Ry
dWN0IHNvY2sgKnNrOw0KIAl1MzIgc2lkOw0KIA0KIAlpZiAoIW5ldGxibF9lbmFibGVkKCkpDQpA
QCAtNDU1MCw4ICs0NTcxLDI3IEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgc2VsaW51eF9pcF9vdXRw
dXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJLyogd2UgZG8gdGhpcyBpbiB0aGUgTE9DQUxfT1VU
IHBhdGggYW5kIG5vdCB0aGUgUE9TVF9ST1VUSU5HIHBhdGgNCiAJICogYmVjYXVzZSB3ZSB3YW50
IHRvIG1ha2Ugc3VyZSB3ZSBhcHBseSB0aGUgbmVjZXNzYXJ5IGxhYmVsaW5nDQogCSAqIGJlZm9y
ZSBJUHNlYyBpcyBhcHBsaWVkIHNvIHdlIGNhbiBsZXZlcmFnZSBBSCBwcm90ZWN0aW9uICovDQot
CWlmIChza2ItPnNrKSB7DQotCQlzdHJ1Y3Qgc2tfc2VjdXJpdHlfc3RydWN0ICpza3NlYyA9IHNr
Yi0+c2stPnNrX3NlY3VyaXR5Ow0KKwlzayA9IHNrYi0+c2s7DQorCWlmIChzaykgew0KKwkJc3Ry
dWN0IHNrX3NlY3VyaXR5X3N0cnVjdCAqc2tzZWM7DQorDQorCQlpZiAoc2stPnNrX3N0YXRlID09
IFRDUF9MSVNURU4pDQorCQkJLyogaWYgdGhlIHNvY2tldCBpcyB0aGUgbGlzdGVuaW5nIHN0YXRl
IHRoZW4gdGhpcw0KKwkJCSAqIHBhY2tldCBpcyBhIFNZTi1BQ0sgcGFja2V0IHdoaWNoIG1lYW5z
IGl0IG5lZWRzIHRvDQorCQkJICogYmUgbGFiZWxlZCBiYXNlZCBvbiB0aGUgY29ubmVjdGlvbi9y
ZXF1ZXN0X3NvY2sgYW5kDQorCQkJICogbm90IHRoZSBwYXJlbnQgc29ja2V0LiAgdW5mb3J0dW5h
dGVseSwgd2UgY2FuJ3QNCisJCQkgKiBsb29rdXAgdGhlIHJlcXVlc3Rfc29jayB5ZXQgYXMgaXQg
aXNuJ3QgcXVldWVkIG9uDQorCQkJICogdGhlIHBhcmVudCBzb2NrZXQgdW50aWwgYWZ0ZXIgdGhl
IFNZTi1BQ0sgaXMgc2VudC4NCisJCQkgKiB0aGUgInNvbHV0aW9uIiBpcyB0byBzaW1wbHkgcGFz
cyB0aGUgcGFja2V0IGFzLWlzDQorCQkJICogYXMgYW55IElQIG9wdGlvbiBiYXNlZCBsYWJlbGlu
ZyBzaG91bGQgYmUgY29waWVkDQorCQkJICogZnJvbSB0aGUgaW5pdGlhbCBjb25uZWN0aW9uIHJl
cXVlc3QgKGluIHRoZSBJUA0KKwkJCSAqIGxheWVyKS4gIGl0IGlzIGZhciBmcm9tIGlkZWFsLCBi
dXQgdW50aWwgd2UgZ2V0IGENCisJCQkgKiBzZWN1cml0eSBsYWJlbCBpbiB0aGUgcGFja2V0IGl0
c2VsZiB0aGlzIGlzIHRoZQ0KKwkJCSAqIGJlc3Qgd2UgY2FuIGRvLiAqLw0KKwkJCXJldHVybiBO
Rl9BQ0NFUFQ7DQorDQorCQkvKiBzdGFuZGFyZCBwcmFjdGljZSwgbGFiZWwgdXNpbmcgdGhlIHBh
cmVudCBzb2NrZXQgKi8NCisJCXNrc2VjID0gc2stPnNrX3NlY3VyaXR5Ow0KIAkJc2lkID0gc2tz
ZWMtPnNpZDsNCiAJfSBlbHNlDQogCQlzaWQgPSBTRUNJTklUU0lEX0tFUk5FTDsNCkBAIC00NjMz
LDEyICs0NjczLDEyIEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgc2VsaW51eF9pcF9wb3N0cm91dGUo
c3RydWN0IHNrX2J1ZmYgKnNrYiwgaW50IGlmaW5kZXgsDQogCWlmICghc2VjbWFya19hY3RpdmUg
JiYgIXBlZXJsYmxfYWN0aXZlKQ0KIAkJcmV0dXJuIE5GX0FDQ0VQVDsNCiANCi0JLyogaWYgdGhl
IHBhY2tldCBpcyBiZWluZyBmb3J3YXJkZWQgdGhlbiBnZXQgdGhlIHBlZXIgbGFiZWwgZnJvbSB0
aGUNCi0JICogcGFja2V0IGl0c2VsZjsgb3RoZXJ3aXNlIGNoZWNrIHRvIHNlZSBpZiBpdCBpcyBm
cm9tIGEgbG9jYWwNCi0JICogYXBwbGljYXRpb24gb3IgdGhlIGtlcm5lbCwgaWYgZnJvbSBhbiBh
cHBsaWNhdGlvbiBnZXQgdGhlIHBlZXIgbGFiZWwNCi0JICogZnJvbSB0aGUgc2VuZGluZyBzb2Nr
ZXQsIG90aGVyd2lzZSB1c2UgdGhlIGtlcm5lbCdzIHNpZCAqLw0KIAlzayA9IHNrYi0+c2s7DQog
CWlmIChzayA9PSBOVUxMKSB7DQorCQkvKiBXaXRob3V0IGFuIGFzc29jaWF0ZWQgc29ja2V0IHRo
ZSBwYWNrZXQgaXMgZWl0aGVyIGNvbWluZw0KKwkJICogZnJvbSB0aGUga2VybmVsIG9yIGl0IGlz
IGJlaW5nIGZvcndhcmRlZDsgY2hlY2sgdGhlIHBhY2tldA0KKwkJICogdG8gZGV0ZXJtaW5lIHdo
aWNoIGFuZCBpZiB0aGUgcGFja2V0IGlzIGJlaW5nIGZvcndhcmRlZA0KKwkJICogcXVlcnkgdGhl
IHBhY2tldCBkaXJlY3RseSB0byBkZXRlcm1pbmUgdGhlIHNlY3VyaXR5IGxhYmVsLiAqLw0KIAkJ
aWYgKHNrYi0+c2tiX2lpZikgew0KIAkJCXNlY21hcmtfcGVybSA9IFBBQ0tFVF9fRk9SV0FSRF9P
VVQ7DQogCQkJaWYgKHNlbGludXhfc2tiX3BlZXJsYmxfc2lkKHNrYiwgZmFtaWx5LCAmcGVlcl9z
aWQpKQ0KQEAgLTQ2NDcsNyArNDY4NywyNiBAQCBzdGF0aWMgdW5zaWduZWQgaW50IHNlbGludXhf
aXBfcG9zdHJvdXRlKHN0cnVjdCBza19idWZmICpza2IsIGludCBpZmluZGV4LA0KIAkJCXNlY21h
cmtfcGVybSA9IFBBQ0tFVF9fU0VORDsNCiAJCQlwZWVyX3NpZCA9IFNFQ0lOSVRTSURfS0VSTkVM
Ow0KIAkJfQ0KKwl9IGVsc2UgaWYgKHNrLT5za19zdGF0ZSA9PSBUQ1BfTElTVEVOKSB7DQorCQkv
KiBMb2NhbGx5IGdlbmVyYXRlZCBwYWNrZXQgYnV0IHRoZSBhc3NvY2lhdGVkIHNvY2tldCBpcyBp
biB0aGUNCisJCSAqIGxpc3RlbmluZyBzdGF0ZSB3aGljaCBtZWFucyB0aGlzIGlzIGEgU1lOLUFD
SyBwYWNrZXQuICBJbg0KKwkJICogdGhpcyBwYXJ0aWN1bGFyIGNhc2UgdGhlIGNvcnJlY3Qgc2Vj
dXJpdHkgbGFiZWwgaXMgYXNzaWduZWQNCisJCSAqIHRvIHRoZSBjb25uZWN0aW9uL3JlcXVlc3Rf
c29jayBidXQgdW5mb3J0dW5hdGVseSB3ZSBjYW4ndA0KKwkJICogcXVlcnkgdGhlIHJlcXVlc3Rf
c29jayBhcyBpdCBpc24ndCBxdWV1ZWQgb24gdGhlIHBhcmVudA0KKwkJICogc29ja2V0IHVudGls
IGFmdGVyIHRoZSBTWU4tQUNLIHBhY2tldCBpcyBzZW50OyB0aGUgb25seQ0KKwkJICogdmlhYmxl
IGNob2ljZSBpcyB0byByZWdlbmVyYXRlIHRoZSBsYWJlbCBsaWtlIHdlIGRvIGluDQorCQkgKiBz
ZWxpbnV4X2luZXRfY29ubl9yZXF1ZXN0KCkuICBTZWUgYWxzbyBzZWxpbnV4X2lwX291dHB1dCgp
DQorCQkgKiBmb3Igc2ltaWxhciBwcm9ibGVtcy4gKi8NCisJCXUzMiBza2Jfc2lkOw0KKwkJc3Ry
dWN0IHNrX3NlY3VyaXR5X3N0cnVjdCAqc2tzZWMgPSBzay0+c2tfc2VjdXJpdHk7DQorCQlpZiAo
c2VsaW51eF9za2JfcGVlcmxibF9zaWQoc2tiLCBmYW1pbHksICZza2Jfc2lkKSkNCisJCQlyZXR1
cm4gTkZfRFJPUDsNCisJCWlmIChzZWxpbnV4X2Nvbm5fc2lkKHNrc2VjLT5zaWQsIHNrYl9zaWQs
ICZwZWVyX3NpZCkpDQorCQkJcmV0dXJuIE5GX0RST1A7DQorCQlzZWNtYXJrX3Blcm0gPSBQQUNL
RVRfX1NFTkQ7DQogCX0gZWxzZSB7DQorCQkvKiBMb2NhbGx5IGdlbmVyYXRlZCBwYWNrZXQsIGZl
dGNoIHRoZSBzZWN1cml0eSBsYWJlbCBmcm9tIHRoZQ0KKwkJICogYXNzb2NpYXRlZCBzb2NrZXQu
ICovDQogCQlzdHJ1Y3Qgc2tfc2VjdXJpdHlfc3RydWN0ICpza3NlYyA9IHNrLT5za19zZWN1cml0
eTsNCiAJCXBlZXJfc2lkID0gc2tzZWMtPnNpZDsNCiAJCXNlY21hcmtfcGVybSA9IFBBQ0tFVF9f
U0VORDsNCmRpZmYgLS1naXQgYS9zZWN1cml0eS9zZWxpbnV4L25ldGxhYmVsLmMgYi9zZWN1cml0
eS9zZWxpbnV4L25ldGxhYmVsLmMNCmluZGV4IGRhNGI4YjIuLjYyMzVkMDUgMTAwNjQ0DQotLS0g
YS9zZWN1cml0eS9zZWxpbnV4L25ldGxhYmVsLmMNCisrKyBiL3NlY3VyaXR5L3NlbGludXgvbmV0
bGFiZWwuYw0KQEAgLTQ0Miw4ICs0NDIsNyBAQCBpbnQgc2VsaW51eF9uZXRsYmxfc29ja2V0X2Nv
bm5lY3Qoc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qgc29ja2FkZHIgKmFkZHIpDQogCSAgICBza3Nl
Yy0+bmxibF9zdGF0ZSAhPSBOTEJMX0NPTk5MQUJFTEVEKQ0KIAkJcmV0dXJuIDA7DQogDQotCWxv
Y2FsX2JoX2Rpc2FibGUoKTsNCi0JYmhfbG9ja19zb2NrX25lc3RlZChzayk7DQorCWxvY2tfc29j
ayhzayk7DQogDQogCS8qIGNvbm5lY3RlZCBzb2NrZXRzIGFyZSBhbGxvd2VkIHRvIGRpc2Nvbm5l
Y3Qgd2hlbiB0aGUgYWRkcmVzcyBmYW1pbHkNCiAJICogaXMgc2V0IHRvIEFGX1VOU1BFQywgaWYg
dGhhdCBpcyB3aGF0IGlzIGhhcHBlbmluZyB3ZSB3YW50IHRvIHJlc2V0DQpAQCAtNDY0LDcgKzQ2
Myw2IEBAIGludCBzZWxpbnV4X25ldGxibF9zb2NrZXRfY29ubmVjdChzdHJ1Y3Qgc29jayAqc2ss
IHN0cnVjdCBzb2NrYWRkciAqYWRkcikNCiAJCXNrc2VjLT5ubGJsX3N0YXRlID0gTkxCTF9DT05O
TEFCRUxFRDsNCiANCiBzb2NrZXRfY29ubmVjdF9yZXR1cm46DQotCWJoX3VubG9ja19zb2NrKHNr
KTsNCi0JbG9jYWxfYmhfZW5hYmxlKCk7DQorCXJlbGVhc2Vfc29jayhzayk7DQogCXJldHVybiBy
YzsNCiB9DQpkaWZmIC0tZ2l0IGEvc291bmQvZHJpdmVycy9wY3NwL3Bjc3AuYyBiL3NvdW5kL2Ry
aXZlcnMvcGNzcC9wY3NwLmMNCmluZGV4IDk0NmEwY2IuLmU2YWQ4ZDQgMTAwNjQ0DQotLS0gYS9z
b3VuZC9kcml2ZXJzL3Bjc3AvcGNzcC5jDQorKysgYi9zb3VuZC9kcml2ZXJzL3Bjc3AvcGNzcC5j
DQpAQCAtMTg3LDggKzE4Nyw4IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IHBjc3BfcHJvYmUoc3Ry
dWN0IHBsYXRmb3JtX2RldmljZSAqZGV2KQ0KIHN0YXRpYyBpbnQgX19kZXZleGl0IHBjc3BfcmVt
b3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKmRldikNCiB7DQogCXN0cnVjdCBzbmRfcGNzcCAq
Y2hpcCA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKGRldik7DQotCWFsc2FfY2FyZF9wY3NwX2V4aXQo
Y2hpcCk7DQogCXBjc3Brcl9pbnB1dF9yZW1vdmUoY2hpcC0+aW5wdXRfZGV2KTsNCisJYWxzYV9j
YXJkX3Bjc3BfZXhpdChjaGlwKTsNCiAJcGxhdGZvcm1fc2V0X2RydmRhdGEoZGV2LCBOVUxMKTsN
CiAJcmV0dXJuIDA7DQogfQ0KZGlmZiAtLWdpdCBhL3NvdW5kL2lzYS9tc25kL21zbmRfcGlubmFj
bGUuYyBiL3NvdW5kL2lzYS9tc25kL21zbmRfcGlubmFjbGUuYw0KaW5kZXggMDk2MWUyYy4uYTlj
YzY4NyAxMDA2NDQNCi0tLSBhL3NvdW5kL2lzYS9tc25kL21zbmRfcGlubmFjbGUuYw0KKysrIGIv
c291bmQvaXNhL21zbmQvbXNuZF9waW5uYWNsZS5jDQpAQCAtNzMsOSArNzMsMTEgQEANCiAjaWZk
ZWYgTVNORF9DTEFTU0lDDQogIyAgaW5jbHVkZSAibXNuZF9jbGFzc2ljLmgiDQogIyAgZGVmaW5l
IExPR05BTUUJCQkibXNuZF9jbGFzc2ljIg0KKyMgIGRlZmluZSBERVZfTkFNRQkJCSJtc25kLWNs
YXNzaWMiDQogI2Vsc2UNCiAjICBpbmNsdWRlICJtc25kX3Bpbm5hY2xlLmgiDQogIyAgZGVmaW5l
IExPR05BTUUJCQkic25kX21zbmRfcGlubmFjbGUiDQorIyAgZGVmaW5lIERFVl9OQU1FCQkJIm1z
bmQtcGlubmFjbGUiDQogI2VuZGlmDQogDQogc3RhdGljIHZvaWQgX19kZXZpbml0IHNldF9kZWZh
dWx0X2F1ZGlvX3BhcmFtZXRlcnMoc3RydWN0IHNuZF9tc25kICpjaGlwKQ0KQEAgLTEwNjgsOCAr
MTA3MCw2IEBAIHN0YXRpYyBpbnQgX19kZXZleGl0IHNuZF9tc25kX2lzYV9yZW1vdmUoc3RydWN0
IGRldmljZSAqcGRldiwgdW5zaWduZWQgaW50IGRldikNCiAJcmV0dXJuIDA7DQogfQ0KIA0KLSNk
ZWZpbmUgREVWX05BTUUgIm1zbmQtcGlubmFjbGUiDQotDQogc3RhdGljIHN0cnVjdCBpc2FfZHJp
dmVyIHNuZF9tc25kX2RyaXZlciA9IHsNCiAJLm1hdGNoCQk9IHNuZF9tc25kX2lzYV9tYXRjaCwN
CiAJLnByb2JlCQk9IHNuZF9tc25kX2lzYV9wcm9iZSwNCmRpZmYgLS1naXQgYS9zb3VuZC9wY2kv
aGRhL3BhdGNoX2NvbmV4YW50LmMgYi9zb3VuZC9wY2kvaGRhL3BhdGNoX2NvbmV4YW50LmMNCmlu
ZGV4IDk4NGI1YjEuLjg0M2Q5ZjMgMTAwNjQ0DQotLS0gYS9zb3VuZC9wY2kvaGRhL3BhdGNoX2Nv
bmV4YW50LmMNCisrKyBiL3NvdW5kL3BjaS9oZGEvcGF0Y2hfY29uZXhhbnQuYw0KQEAgLTQ2MTAs
NiArNDYxMCw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaGRhX2NvZGVjX3ByZXNldCBzbmRfaGRh
X3ByZXNldF9jb25leGFudFtdID0gew0KIAkgIC5wYXRjaCA9IHBhdGNoX2NvbmV4YW50X2F1dG8g
fSwNCiAJeyAuaWQgPSAweDE0ZjE1MTE1LCAubmFtZSA9ICJDWDIwNzU3IiwNCiAJICAucGF0Y2gg
PSBwYXRjaF9jb25leGFudF9hdXRvIH0sDQorCXsgLmlkID0gMHgxNGYxNTFkNywgLm5hbWUgPSAi
Q1gyMDk1MiIsDQorCSAgLnBhdGNoID0gcGF0Y2hfY29uZXhhbnRfYXV0byB9LA0KIAl7fSAvKiB0
ZXJtaW5hdG9yICovDQogfTsNCiANCkBAIC00NjM2LDYgKzQ2MzgsNyBAQCBNT0RVTEVfQUxJQVMo
InNuZC1oZGEtY29kZWMtaWQ6MTRmMTUxMTEiKTsNCiBNT0RVTEVfQUxJQVMoInNuZC1oZGEtY29k
ZWMtaWQ6MTRmMTUxMTMiKTsNCiBNT0RVTEVfQUxJQVMoInNuZC1oZGEtY29kZWMtaWQ6MTRmMTUx
MTQiKTsNCiBNT0RVTEVfQUxJQVMoInNuZC1oZGEtY29kZWMtaWQ6MTRmMTUxMTUiKTsNCitNT0RV
TEVfQUxJQVMoInNuZC1oZGEtY29kZWMtaWQ6MTRmMTUxZDciKTsNCiANCiBNT0RVTEVfTElDRU5T
RSgiR1BMIik7DQogTU9EVUxFX0RFU0NSSVBUSU9OKCJDb25leGFudCBIRC1hdWRpbyBjb2RlYyIp
Ow0KZGlmZiAtLWdpdCBhL3NvdW5kL3BjaS9oZGEvcGF0Y2hfcmVhbHRlay5jIGIvc291bmQvcGNp
L2hkYS9wYXRjaF9yZWFsdGVrLmMNCmluZGV4IDkyYzkxM2QuLjFmNzhjYTYgMTAwNjQ0DQotLS0g
YS9zb3VuZC9wY2kvaGRhL3BhdGNoX3JlYWx0ZWsuYw0KKysrIGIvc291bmQvcGNpL2hkYS9wYXRj
aF9yZWFsdGVrLmMNCkBAIC01OTQzLDYgKzU5NDMsNyBAQCBzdGF0aWMgaW50IHBhdGNoX2FsYzY2
MihzdHJ1Y3QgaGRhX2NvZGVjICpjb2RlYykNCiAJCWNhc2UgMHgxMGVjMDI3MjoNCiAJCWNhc2Ug
MHgxMGVjMDY2MzoNCiAJCWNhc2UgMHgxMGVjMDY2NToNCisJCWNhc2UgMHgxMGVjMDY2ODoNCiAJ
CQlzZXRfYmVlcF9hbXAoc3BlYywgMHgwYiwgMHgwNCwgSERBX0lOUFVUKTsNCiAJCQlicmVhazsN
CiAJCWNhc2UgMHgxMGVjMDI3MzoNCkBAIC02MDE5LDYgKzYwMjAsNyBAQCBzdGF0aWMgaW50IHBh
dGNoX2FsYzY4MChzdHJ1Y3QgaGRhX2NvZGVjICpjb2RlYykNCiAgKi8NCiBzdGF0aWMgY29uc3Qg
c3RydWN0IGhkYV9jb2RlY19wcmVzZXQgc25kX2hkYV9wcmVzZXRfcmVhbHRla1tdID0gew0KIAl7
IC5pZCA9IDB4MTBlYzAyMjEsIC5uYW1lID0gIkFMQzIyMSIsIC5wYXRjaCA9IHBhdGNoX2FsYzI2
OSB9LA0KKwl7IC5pZCA9IDB4MTBlYzAyMzEsIC5uYW1lID0gIkFMQzIzMSIsIC5wYXRjaCA9IHBh
dGNoX2FsYzI2OSB9LA0KIAl7IC5pZCA9IDB4MTBlYzAyNjAsIC5uYW1lID0gIkFMQzI2MCIsIC5w
YXRjaCA9IHBhdGNoX2FsYzI2MCB9LA0KIAl7IC5pZCA9IDB4MTBlYzAyNjIsIC5uYW1lID0gIkFM
QzI2MiIsIC5wYXRjaCA9IHBhdGNoX2FsYzI2MiB9LA0KIAl7IC5pZCA9IDB4MTBlYzAyNjcsIC5u
YW1lID0gIkFMQzI2NyIsIC5wYXRjaCA9IHBhdGNoX2FsYzI2OCB9LA0KZGlmZiAtLWdpdCBhL3Nv
dW5kL3NvYy9jb2RlY3MvYWs0NjQyLmMgYi9zb3VuZC9zb2MvY29kZWNzL2FrNDY0Mi5jDQppbmRl
eCAxYzQ5OTlkLi5mMmRhYzVjIDEwMDY0NA0KLS0tIGEvc291bmQvc29jL2NvZGVjcy9hazQ2NDIu
Yw0KKysrIGIvc291bmQvc29jL2NvZGVjcy9hazQ2NDIuYw0KQEAgLTIxNCw3ICsyMTQsNyBAQCBz
dGF0aWMgaW50IGFrNDY0Ml9kYWlfc3RhcnR1cChzdHJ1Y3Qgc25kX3BjbV9zdWJzdHJlYW0gKnN1
YnN0cmVhbSwNCiAJCSAqIFRoaXMgb3BlcmF0aW9uIGNhbWUgZnJvbSBleGFtcGxlIGNvZGUgb2YN
CiAJCSAqICJBU0FISSBLQVNFSSBBSzQ2NDIiIChqYXBhbmVzZSkgbWFudWFsIHA5NC4NCiAJCSAq
Lw0KLQkJc25kX3NvY193cml0ZShjb2RlYywgU0dfU0wxLCBQTU1QIHwgTUdBSU4wKTsNCisJCXNu
ZF9zb2NfdXBkYXRlX2JpdHMoY29kZWMsIFNHX1NMMSwgUE1NUCB8IE1HQUlOMCwgUE1NUCB8IE1H
QUlOMCk7DQogCQlzbmRfc29jX3dyaXRlKGNvZGVjLCBUSU1FUiwgWlRNKDB4MykgfCBXVE0oMHgz
KSk7DQogCQlzbmRfc29jX3dyaXRlKGNvZGVjLCBBTENfQ1RMMSwgQUxDIHwgTE1USDApOw0KIAkJ
c25kX3NvY191cGRhdGVfYml0cyhjb2RlYywgUFdfTUdNVDEsIFBNVkNNIHwgUE1BREwsDQpkaWZm
IC0tZ2l0IGEvc291bmQvc29jL2NvZGVjcy93bTg3MzEuYyBiL3NvdW5kL3NvYy9jb2RlY3Mvd204
NzMxLmMNCmluZGV4IGE3YzlhZTEuLjZjZmQ0ZjcgMTAwNjQ0DQotLS0gYS9zb3VuZC9zb2MvY29k
ZWNzL3dtODczMS5jDQorKysgYi9zb3VuZC9zb2MvY29kZWNzL3dtODczMS5jDQpAQCAtMzkyLDEw
ICszOTIsMTAgQEAgc3RhdGljIGludCB3bTg3MzFfc2V0X2RhaV9mbXQoc3RydWN0IHNuZF9zb2Nf
ZGFpICpjb2RlY19kYWksDQogCQlpZmFjZSB8PSAweDAwMDE7DQogCQlicmVhazsNCiAJY2FzZSBT
TkRfU09DX0RBSUZNVF9EU1BfQToNCi0JCWlmYWNlIHw9IDB4MDAwMzsNCisJCWlmYWNlIHw9IDB4
MDAxMzsNCiAJCWJyZWFrOw0KIAljYXNlIFNORF9TT0NfREFJRk1UX0RTUF9COg0KLQkJaWZhY2Ug
fD0gMHgwMDEzOw0KKwkJaWZhY2UgfD0gMHgwMDAzOw0KIAkJYnJlYWs7DQogCWRlZmF1bHQ6DQog
CQlyZXR1cm4gLUVJTlZBTDsNCmRpZmYgLS1naXQgYS9zb3VuZC9zb2MvY29kZWNzL3dtODk5MC5j
IGIvc291bmQvc29jL2NvZGVjcy93bTg5OTAuYw0KaW5kZXggZDI5YTk2Mi4uY2ZhNWJlYSAxMDA2
NDQNCi0tLSBhL3NvdW5kL3NvYy9jb2RlY3Mvd204OTkwLmMNCisrKyBiL3NvdW5kL3NvYy9jb2Rl
Y3Mvd204OTkwLmMNCkBAIC0xMjY2LDYgKzEyNjYsOCBAQCBzdGF0aWMgaW50IHdtODk5MF9zZXRf
Ymlhc19sZXZlbChzdHJ1Y3Qgc25kX3NvY19jb2RlYyAqY29kZWMsDQogDQogCQkvKiBkaXNhYmxl
IFBPQkNUUkwsIFNPRlRfU1QgYW5kIEJVRkRDT1BFTiAqLw0KIAkJc25kX3NvY193cml0ZShjb2Rl
YywgV004OTkwX0FOVElQT1AyLCAweDApOw0KKw0KKwkJY29kZWMtPmNhY2hlX3N5bmMgPSAxOw0K
IAkJYnJlYWs7DQogCX0NCiANCmRpZmYgLS1naXQgYS9zb3VuZC91c2IvNmZpcmUvY2hpcC5jIGIv
c291bmQvdXNiLzZmaXJlL2NoaXAuYw0KaW5kZXggYzdkY2E3Yi4uNDZhMjgxNiAxMDA2NDQNCi0t
LSBhL3NvdW5kL3VzYi82ZmlyZS9jaGlwLmMNCisrKyBiL3NvdW5kL3VzYi82ZmlyZS9jaGlwLmMN
CkBAIC0xMDIsNyArMTAyLDcgQEAgc3RhdGljIGludCBfX2RldmluaXQgdXNiNmZpcmVfY2hpcF9w
cm9iZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZiwNCiAJCQl1c2Jfc2V0X2ludGZkYXRhKGlu
dGYsIGNoaXBzW2ldKTsNCiAJCQltdXRleF91bmxvY2soJnJlZ2lzdGVyX211dGV4KTsNCiAJCQly
ZXR1cm4gMDsNCi0JCX0gZWxzZSBpZiAocmVnaWR4IDwgMCkNCisJCX0gZWxzZSBpZiAoIWRldmlj
ZXNbaV0gJiYgcmVnaWR4IDwgMCkNCiAJCQlyZWdpZHggPSBpOw0KIAl9DQogCWlmIChyZWdpZHgg
PCAwKSB7DQpkaWZmIC0tZ2l0IGEvdmlydC9rdm0vaW9tbXUuYyBiL3ZpcnQva3ZtL2lvbW11LmMN
CmluZGV4IDUzM2RiMzMuLjVkYmIzNWQgMTAwNjQ0DQotLS0gYS92aXJ0L2t2bS9pb21tdS5jDQor
KysgYi92aXJ0L2t2bS9pb21tdS5jDQpAQCAtMTAxLDYgKzEwMSwxMCBAQCBpbnQga3ZtX2lvbW11
X21hcF9wYWdlcyhzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fbWVtb3J5X3Nsb3QgKnNsb3Qp
DQogCQl3aGlsZSAoKGdmbiA8PCBQQUdFX1NISUZUKSAmIChwYWdlX3NpemUgLSAxKSkNCiAJCQlw
YWdlX3NpemUgPj49IDE7DQogDQorCQkvKiBNYWtlIHN1cmUgaHZhIGlzIGFsaWduZWQgdG8gdGhl
IHBhZ2Ugc2l6ZSB3ZSB3YW50IHRvIG1hcCAqLw0KKwkJd2hpbGUgKGdmbl90b19odmFfbWVtc2xv
dChzbG90LCBnZm4pICYgKHBhZ2Vfc2l6ZSAtIDEpKQ0KKwkJCXBhZ2Vfc2l6ZSA+Pj0gMTsNCisN
CiAJCS8qDQogCQkgKiBQaW4gYWxsIHBhZ2VzIHdlIGFyZSBhYm91dCB0byBtYXAgaW4gbWVtb3J5
LiBUaGlzIGlzDQogCQkgKiBpbXBvcnRhbnQgYmVjYXVzZSB3ZSB1bm1hcCBhbmQgdW5waW4gaW4g
NGtiIHN0ZXBzIGxhdGVyLg0KZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2t2bV9tYWluLmMgYi92aXJ0
L2t2bS9rdm1fbWFpbi5jDQppbmRleCA4YmYwNWYwLi5kODNhYTVlIDEwMDY0NA0KLS0tIGEvdmly
dC9rdm0va3ZtX21haW4uYw0KKysrIGIvdmlydC9rdm0va3ZtX21haW4uYw0KQEAgLTc3NCw3ICs3
NzQsNyBAQCBza2lwX2xwYWdlOg0KIAkJbmV3LnVzZXJzcGFjZV9hZGRyID0gbWVtLT51c2Vyc3Bh
Y2VfYWRkcjsNCiAjZW5kaWYgLyogbm90IGRlZmluZWQgQ09ORklHX1MzOTAgKi8NCiANCi0JaWYg
KCFucGFnZXMpIHsNCisJaWYgKCFucGFnZXMgfHwgYmFzZV9nZm4gIT0gb2xkLmJhc2VfZ2ZuKSB7
DQogCQlyID0gLUVOT01FTTsNCiAJCXNsb3RzID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IGt2bV9t
ZW1zbG90cyksIEdGUF9LRVJORUwpOw0KIAkJaWYgKCFzbG90cykNCkBAIC03ODgsOCArNzg4LDEw
IEBAIHNraXBfbHBhZ2U6DQogCQlvbGRfbWVtc2xvdHMgPSBrdm0tPm1lbXNsb3RzOw0KIAkJcmN1
X2Fzc2lnbl9wb2ludGVyKGt2bS0+bWVtc2xvdHMsIHNsb3RzKTsNCiAJCXN5bmNocm9uaXplX3Ny
Y3VfZXhwZWRpdGVkKCZrdm0tPnNyY3UpOw0KLQkJLyogRnJvbSB0aGlzIHBvaW50IG5vIG5ldyBz
aGFkb3cgcGFnZXMgcG9pbnRpbmcgdG8gYSBkZWxldGVkDQotCQkgKiBtZW1zbG90IHdpbGwgYmUg
Y3JlYXRlZC4NCisJCS8qIHNsb3Qgd2FzIGRlbGV0ZWQgb3IgbW92ZWQsIGNsZWFyIGlvbW11IG1h
cHBpbmcgKi8NCisJCWt2bV9pb21tdV91bm1hcF9wYWdlcyhrdm0sICZvbGQpOw0KKwkJLyogRnJv
bSB0aGlzIHBvaW50IG5vIG5ldyBzaGFkb3cgcGFnZXMgcG9pbnRpbmcgdG8gYSBkZWxldGVkLA0K
KwkJICogb3IgbW92ZWQsIG1lbXNsb3Qgd2lsbCBiZSBjcmVhdGVkLg0KIAkJICoNCiAJCSAqIHZh
bGlkYXRpb24gb2Ygc3AtPmdmbiBoYXBwZW5zIGluOg0KIAkJICogCS0gZ2ZuX3RvX2h2YSAoa3Zt
X3JlYWRfZ3Vlc3QsIGdmbl90b19wZm4pDQpAQCAtODAzLDE0ICs4MDUsNiBAQCBza2lwX2xwYWdl
Og0KIAlpZiAocikNCiAJCWdvdG8gb3V0X2ZyZWU7DQogDQotCS8qIG1hcC91bm1hcCB0aGUgcGFn
ZXMgaW4gaW9tbXUgcGFnZSB0YWJsZSAqLw0KLQlpZiAobnBhZ2VzKSB7DQotCQlyID0ga3ZtX2lv
bW11X21hcF9wYWdlcyhrdm0sICZuZXcpOw0KLQkJaWYgKHIpDQotCQkJZ290byBvdXRfZnJlZTsN
Ci0JfSBlbHNlDQotCQlrdm1faW9tbXVfdW5tYXBfcGFnZXMoa3ZtLCAmb2xkKTsNCi0NCiAJciA9
IC1FTk9NRU07DQogCXNsb3RzID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IGt2bV9tZW1zbG90cyks
IEdGUF9LRVJORUwpOw0KIAlpZiAoIXNsb3RzKQ0KQEAgLTgyMCw2ICs4MTQsMTMgQEAgc2tpcF9s
cGFnZToNCiAJCXNsb3RzLT5ubWVtc2xvdHMgPSBtZW0tPnNsb3QgKyAxOw0KIAlzbG90cy0+Z2Vu
ZXJhdGlvbisrOw0KIA0KKwkvKiBtYXAgbmV3IG1lbW9yeSBzbG90IGludG8gdGhlIGlvbW11ICov
DQorCWlmIChucGFnZXMpIHsNCisJCXIgPSBrdm1faW9tbXVfbWFwX3BhZ2VzKGt2bSwgJm5ldyk7
DQorCQlpZiAocikNCisJCQlnb3RvIG91dF9zbG90czsNCisJfQ0KKw0KIAkvKiBhY3R1YWwgbWVt
b3J5IGlzIGZyZWVkIHZpYSBvbGQgaW4ga3ZtX2ZyZWVfcGh5c21lbV9zbG90IGJlbG93ICovDQog
CWlmICghbnBhZ2VzKSB7DQogCQluZXcucm1hcCA9IE5VTEw7DQpAQCAtODQ3LDYgKzg0OCw4IEBA
IHNraXBfbHBhZ2U6DQogDQogCXJldHVybiAwOw0KIA0KK291dF9zbG90czoNCisJa2ZyZWUoc2xv
dHMpOw0KIG91dF9mcmVlOg0KIAlrdm1fZnJlZV9waHlzbWVtX3Nsb3QoJm5ldywgJm9sZCk7DQog
b3V0Og0KQEAgLTE2ODMsNiArMTY4Niw5IEBAIHN0YXRpYyBpbnQga3ZtX3ZtX2lvY3RsX2NyZWF0
ZV92Y3B1KHN0cnVjdCBrdm0gKmt2bSwgdTMyIGlkKQ0KIAlpbnQgcjsNCiAJc3RydWN0IGt2bV92
Y3B1ICp2Y3B1LCAqdjsNCiANCisJaWYgKGlkID49IEtWTV9NQVhfVkNQVVMpDQorCQlyZXR1cm4g
LUVJTlZBTDsNCisNCiAJdmNwdSA9IGt2bV9hcmNoX3ZjcHVfY3JlYXRlKGt2bSwgaWQpOw0KIAlp
ZiAoSVNfRVJSKHZjcHUpKQ0KIAkJcmV0dXJuIFBUUl9FUlIodmNwdSk7DQo=


--=-7n0h7Rc+HoG1NzjT31Lg--

--=-Kk0aZEtAkWt5tFyj4BRR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUsa5Wee/yOyVhhEJAQqNxw/+P/sMuZjFsLPbewhPyW+LZCryJ8XyzlF9
EU7C9ZAe/dP/gNEVhLOmxTSFFTiDXRdvwD4wVs6hrLaxxQ10PW+2gll3a8nwLjcL
uxhYLac+IHehduRUtNBFgnrL+aj3deWuD5+eT1YzAAoqExgjSMfPV4Ouxb96LAf/
ZWtXFY32DAn7Tua9U0K1wdJaldUkNQK3KQvH7ZxGbTOBZu7MkCva0CmJMY+n6Ffj
9tnngODGtFC28tADlGDx/Dg1+v5H1d+a8wXtn8RPjoH8uYOQUO3+OT0pCznxqKhm
X/q5aaz2biZcurgSuBVN0HLmjD7tgKw6KY2gpovJAVwGs54x18G1VQiKcqq0rJQj
8icMP2thUKhrivWADlP5dfO2/tQl7QLEcTsgpUF4/RlTOTV/ohA+N7bbE/RcigRx
3OobqpVtQVKxd9FYaP9tg/SDaboxbkJ7Lbfa+sGKB2PSXtC7959GNLxD66FlPn1L
FXan7Whh/c6rhO4wCymfalCmCvbX5fAwu0dkA7HdaZeEmL+3M+rfMaFNMCICwbwq
BIMM7BitLi6GvC6mOFJ7eK6RO0wLAuoAgrqfFmscCW/bnnX+3JbSZfhRE3iPv4RA
TA6BClavL096hAHQ6GdRdnBjzcEPrnNw+YF19iGAaBjgpSiWjXGJZ3e8oLWJYP3B
fP3tc8+Qqvw=
=asc1
-----END PGP SIGNATURE-----

--=-Kk0aZEtAkWt5tFyj4BRR--
