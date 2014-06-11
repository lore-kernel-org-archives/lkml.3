Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaFKTrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:47:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaFKTrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:47:49 -0400
Date: Wed, 11 Jun 2014 12:51:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.93
Message-ID: <20140611195139.GA2977@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.93 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/tty/serial/of-serial.txt |    3=20
 Makefile                                                   |    2=20
 arch/arm/include/asm/uaccess.h                             |    3=20
 drivers/block/virtio_blk.c                                 |   20 --
 drivers/bluetooth/ath3k.c                                  |   39 ++++
 drivers/bluetooth/btusb.c                                  |   28 ++
 drivers/char/virtio_console.c                              |   22 +-
 drivers/md/md.c                                            |    4=20
 drivers/scsi/hpsa.c                                        |   32 ++-
 drivers/scsi/isci/task.c                                   |    9=20
 drivers/scsi/mpt2sas/mpt2sas_base.c                        |   13 -
 drivers/scsi/mpt2sas/mpt2sas_base.h                        |    3=20
 drivers/scsi/mpt2sas/mpt2sas_scsih.c                       |  126 ++++++++=
++++-
 drivers/staging/speakup/main.c                             |    1=20
 drivers/staging/speakup/selection.c                        |   38 +++
 drivers/staging/speakup/speakup.h                          |    1=20
 drivers/target/iscsi/iscsi_target_login.c                  |    8=20
 drivers/target/iscsi/iscsi_target_nego.c                   |   10 -
 drivers/target/target_core_alua.c                          |    6=20
 drivers/target/target_core_file.c                          |    9=20
 drivers/target/target_core_pscsi.c                         |    8=20
 drivers/target/target_core_transport.c                     |    5=20
 drivers/tty/serial/8250/8250.c                             |   36 +++
 drivers/tty/serial/8250/8250.h                             |    1=20
 drivers/tty/serial/8250/8250_pci.c                         |   55 ++++-
 drivers/tty/serial/of_serial.c                             |    6=20
 drivers/tty/serial/pch_uart.c                              |    5=20
 drivers/tty/tty_buffer.c                                   |   11 -
 drivers/usb/core/driver.c                                  |    9=20
 drivers/usb/core/hub.c                                     |   15 +
 drivers/usb/host/xhci-mem.c                                |   20 +-
 drivers/usb/serial/ftdi_sio.c                              |    2=20
 drivers/usb/serial/ftdi_sio_ids.h                          |    5=20
 drivers/usb/serial/io_ti.c                                 |    2=20
 drivers/usb/serial/io_usbvend.h                            |    2=20
 drivers/usb/serial/option.c                                |    2=20
 fs/nfsd/nfsctl.c                                           |   62 ++++--
 fs/nfsd/nfsd.h                                             |    6=20
 fs/nfsd/nfssvc.c                                           |   41 ++--
 include/linux/highmem.h                                    |    7=20
 include/linux/pci_ids.h                                    |    1=20
 include/linux/serial_core.h                                |    6=20
 include/linux/sunrpc/svcsock.h                             |    1=20
 include/linux/virtio_console.h                             |    2=20
 kernel/cpu.c                                               |    6=20
 kernel/events/core.c                                       |   61 ++++--
 kernel/sched/core.c                                        |    1=20
 kernel/sched/cpupri.c                                      |    3=20
 mm/highmem.c                                               |   13 +
 mm/memory-failure.c                                        |    2=20
 mm/rmap.c                                                  |    3=20
 net/9p/trans_virtio.c                                      |    3=20
 net/bluetooth/l2cap_core.c                                 |   94 +++++++--
 net/sunrpc/svcsock.c                                       |   16 +
 sound/pci/hda/patch_realtek.c                              |   10 -
 55 files changed, 690 insertions(+), 209 deletions(-)

AceLan Kao (5):
      Bluetooth: Add support for IMC Networks [13d3:3393]
      Bluetooth: Add support for Foxconn / Hon Hai [0489:e04e]
      Bluetooth: Add support for Foxconn / Hon Hai [0489:e056]
      Bluetooth: Add support for Atheros [0cf3:3121]
      Bluetooth: Add support for Atheros [0cf3:e003]

Alan Stern (1):
      USB: Avoid runtime suspend loops for HCDs that can't handle suspend/r=
esume

Alexander Graf (1):
      virtio-blk: Don't free ida when disk is in use

Alexej Starschenko (1):
      USB: serial: option: add support for Novatel E371 PCIe card

Amit Shah (2):
      virtio: console: rename cvq_lock to c_ivq_lock
      virtio: console: add locking around c_ovq operations

Andrey Ryabinin (2):
      ARM: 8051/1: put_user: fix possible data corruption in put_user
      mm: rmap: fix use-after-free in __put_anon_vma

Asias He (4):
      virtio_blk: Drop unused request tracking list
      virtio-blk: Fix hot-unplug race in remove method
      virtio-blk: Call del_gendisk() before disable guest kick
      virtio-blk: Reset device after blk_cleanup_queue()

Ben Hutchings (2):
      Staging: speakup: Move pasting into a work item
      mm: add kmap_to_page()

Cho, Yu-Chen (1):
      Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]

Daniel Schaal (1):
      Bluetooth: Add support for GC-WB300D PCIe [04ca:3006] to ath3k.

George McCollister (1):
      USB: ftdi_sio: add NovaTech OrionLXm product ID

Giancarlo Formicuccia (1):
      Bluetooth: add support for atheros 0930:0219

Greg Kroah-Hartman (1):
      Linux 3.4.93

Gustavo Padovan (1):
      Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for Broadcom/Foxconn

Hannes Reinecke (1):
      target: use correct sense code for LUN communication failure

Ilya Zykov (1):
      tty: Correct tty buffer flush.

Jaganath Kanakkassery (1):
      Bluetooth: Fix invalid length check in l2cap_information_rsp()

Jaroslav Resler (1):
      Bluetooth: Add support for BCM20702A0 [04ca, 2003]

Jeff Cook (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17b5]

Jeff Skirvin (1):
      isci: Fix a race condition in the SSP task management path

Jiri Olsa (1):
      perf: Prevent false warning in perf_swevent_add

Johan Hedberg (1):
      Bluetooth: Fix missing length checks for L2CAP signalling PDUs

Johan Hovold (3):
      USB: io_ti: fix firmware download on big-endian machines (part 2)
      serial: pch_uart: fix tty-kref leak in dma-rx path
      serial: pch_uart: fix tty-kref leak in rx-error path

Josh Boyer (1):
      Bluetooth: Add support for atheros 04ca:3004 device to ath3k

Lai Jiangshan (1):
      sched: Fix hotplug vs. set_cpus_allowed_ptr()

Ley Foon Tan (1):
      tty/serial: Add support for Altera serial port

Marek Vasut (1):
      Bluetooth: Support AR3011 in Acer Iconia Tab W500

Mathias Nyman (1):
      xhci: delete endpoints from bandwidth list before freeing whole device

Michael Gruetzner (1):
      Bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C

Michael S. Tsirkin (1):
      virtio_console: fix uapi header

Mike Miller (1):
      hpsa: gen8plus Smart Array IDs

Naoya Horiguchi (1):
      mm/memory-failure.c: fix memory leak by race between poison and unpoi=
son

NeilBrown (1):
      md: always set MD_RECOVERY_INTR when aborting a reshape or other "res=
ync".

Nicholas Bellinger (1):
      target: Fix MAINTENANCE_IN service action CDB checks to use lower 5 b=
its

Noguchi Kazutosi (1):
      Bluetooth: Add support for Foxconn/Hon Hai [0489:e04d]

Peng Chen (2):
      Bluetooth: add support for atheros 0489:e057
      Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.

Peter Zijlstra (2):
      perf: Limit perf_event_attr::sample_period to 63 bits
      perf: Fix race in removing an event

Raphael Kubo da Costa (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17cb]

Reddy, Sreekanth (1):
      mpt2sas: Fix for issue Missing delay not getting set during system bo=
otup

Roland Dreier (1):
      iscsi-target: Always send a response before terminating iSCSI connect=
ion

Ronan Marquet (1):
      ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop

Scott Ashcroft (1):
      Fix 4 port and add support for 8 port 'Unknown' PCI serial port cards

Sebastian Andrzej Siewior (1):
      target/file: Fix 32-bit highmem breakage for SGL -> iovec mapping

Sergio Cambra (1):
      Bluetooth device 04ca:3008 should use ath3k

Sreekanth Reddy (1):
      mpt2sas: Fix for device scan following host reset could get stuck in =
a infinite loop

Stanislav Kinsbursky (9):
      nfsd: pass net to nfsd_init_socks()
      nfsd: pass net to nfsd_startup() and nfsd_shutdown()
      nfsd: pass net to nfsd_create_serv()
      nfsd: pass net to nfsd_svc()
      nfsd: pass net to nfsd_set_nrthreads()
      nfsd: pass net to __write_ports() and down
      nfsd: pass proper net to nfsd_destroy() from NFSd kthreads
      nfsd: containerize NFSd filesystem
      nfsd: check passed socket's net matches NFSd superblock's one

Stephen Hurd (1):
      8250/16?50: Add support for Broadcom TruManage redirected serial port

Steven Rostedt (Red Hat) (1):
      sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check

Sujith Manoharan (1):
      Bluetooth: ath3k: Add support for ID 0x13d3/0x3402

Sunguk Lee (1):
      Bluetooth: Device 0cf3:3008 should map AR 3012

Takashi Iwai (1):
      ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup

Thomas Loo (1):
      Bluetooth: ath3k: Add support for Fujitsu Lifebook UH5x2 [04c5:1330]

Wei Yongjun (1):
      target/pscsi: fix return value check

Will Deacon (3):
      mm: highmem: export kmap_to_page for modules
      virtio: 9p: correctly pass physical address to userspace for high pag=
es
      mm: highmem: don't treat PKMAP_ADDR(LAST_PKMAP) as a highmem address

Yevgeniy Melnichuk (1):
      Bluetooth: Add support for Sony Vaio T-Series


--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTmLNLAAoJEDjbvchgkmk+NvkP/RwbwJ2ddyqRKkX0hwz9RWDX
BwLW7KmcWm1UpZJ8hVOqk/EgCdByN7NE2TERTYtp5Vs54U8Ft6fgnlYbwJbRM38j
GBoWTjV4nyxU47/s+AwiXdRW0/0oGuxDpygNx/dB+LwXljcqKjAFzU4bwzb8p4vE
tWWqsXk0pOrccO9+/gQnVeWypdn3uSYoA+zPjt13BlL/7INf0trx14R72QyI8vHw
uAywdRLGhN/9AJws1PTyYKFnvvxgYLfxAUWiqi/9Z7rXMRK91XbR8MRoW1Fec7Vy
mLSXh3lkQEyxWA8dSDrwKqy+HD59krOokOfbAzMJDDb6JZDU2fWE3dTz2WZfJyfy
aUrP0HSYXhNmHViHHX+61mFGWLhB6D9A/K3on4kPxRO8byyqtnJZQ49617Tj03GK
OkZ5GhBAV6OCebc83WqWIAO/VTzKuOxzPAabenbasMyWXuU0NwPXD/xaD9tFmgi2
cn+yzpsPHtqUlzmlmEl6dfFleoMnfSew9+hgAQEHr/yjxeAlYGHPsOa2wRrqabDp
qrtnlARFHQ6yD1MOuwWAnBKEPszdzb/aVacqwOH4bnevVKxL/3gAgAR2+ZSocEMS
t9gJjHCeVYaFmrJJ+tF9DydnGdIHqDgLuwdc2sH7VbfA1oHjiIsV0awsd27djoh9
E/Sk1mMKV8Sxg20uckYx
=cwxE
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
