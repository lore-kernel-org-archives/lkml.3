Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaCXE5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 00:57:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaCXE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 00:57:28 -0400
Date: Sun, 23 Mar 2014 21:59:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.84
Message-ID: <20140324045902.GA25974@kroah.com>
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

I'm announcing the release of the 3.4.84 kernel.

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

 Makefile                                             |    2 -
 arch/arm/mach-sa1100/include/mach/collie.h           |    2 +
 arch/powerpc/kernel/reloc_64.S                       |    1=20
 arch/x86/kernel/quirks.c                             |    2 -
 arch/x86/kvm/svm.c                                   |    6 ++--
 drivers/ata/libata-core.c                            |    1=20
 drivers/firewire/core-device.c                       |   22 ++++++++++-----
 drivers/firewire/net.c                               |    6 ++--
 drivers/firewire/sbp2.c                              |   17 +++++++++--
 drivers/gpu/drm/radeon/atombios_encoders.c           |    2 -
 drivers/gpu/drm/ttm/ttm_bo.c                         |    8 +++--
 drivers/net/can/flexcan.c                            |    4 ++
 drivers/net/ethernet/broadcom/tg3.c                  |    3 --
 drivers/net/ethernet/broadcom/tg3.h                  |    6 +++-
 drivers/net/virtio_net.c                             |    3 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                    |   19 +++++++++----
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h |    4 +-
 drivers/net/wireless/mwifiex/11n.c                   |    3 --
 drivers/scsi/isci/host.h                             |    5 +--
 drivers/scsi/isci/port_config.c                      |    7 ----
 drivers/scsi/isci/task.c                             |    2 -
 drivers/scsi/qla2xxx/qla_def.h                       |    3 --
 drivers/scsi/storvsc_drv.c                           |    3 ++
 fs/btrfs/compression.c                               |    2 +
 fs/nfs/delegation.c                                  |   11 ++++---
 fs/ocfs2/file.c                                      |    8 ++---
 fs/ocfs2/quota_global.c                              |   27 +++++++++++---=
-----
 fs/ocfs2/quota_local.c                               |    4 --
 fs/proc/base.c                                       |    1=20
 include/linux/firewire.h                             |    1=20
 include/linux/jiffies.h                              |    8 ++---
 include/linux/tracepoint.h                           |    6 ++++
 kernel/cpuset.c                                      |    2 -
 kernel/irq/manage.c                                  |    3 --
 kernel/sched/fair.c                                  |    8 ++---
 kernel/trace/trace_events.c                          |   10 +++++++
 kernel/tracepoint.c                                  |    7 ++++
 net/mac80211/sta_info.c                              |    4 ++
 net/mac80211/sta_info.h                              |    7 ++--
 net/mac80211/tx.c                                    |   15 ++++++++++
 net/sctp/sm_statefuns.c                              |    7 ++++
 sound/pci/oxygen/xonar_dg.c                          |   12 +++++++-
 sound/usb/mixer.c                                    |    1=20
 43 files changed, 186 insertions(+), 89 deletions(-)

Al Viro (1):
      ocfs2 syncs the wrong range...

Ales Novak (1):
      SCSI: storvsc: NULL pointer dereference fix

Alex Deucher (1):
      drm/radeon/atom: select the proper number of lanes in transmitter set=
up

Amitkumar Karwar (1):
      mwifiex: copy AP's HT capability info correctly

Anton Blanchard (1):
      powerpc: Align p_dyn, p_rela and p_st symbols

Arnd Bergmann (1):
      vmxnet3: fix building without CONFIG_PCI_MSI

Artem Fetishev (1):
      fs/proc/base.c: fix GPF in /proc/$PID/map_files

Chuansheng Liu (1):
      genirq: Remove racy waitqueue_active check

Dan Williams (1):
      SCSI: isci: fix reset timeout handling

Daniel Borkmann (1):
      net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH capable

Daniel J Blueman (1):
      x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

Emmanuel Grumbach (1):
      mac80211: fix AP powersave TX vs. wakeup race

Filipe David Borba Manana (1):
      Btrfs: fix data corruption when reading/updating compressed extents

George McCollister (1):
      sched: Fix double normalization of vruntime

Giridhar Malavali (1):
      SCSI: qla2xxx: Poll during initialization for ISP25xx and ISP83xx

Greg Kroah-Hartman (1):
      Linux 3.4.84

Jan Kara (1):
      ocfs2: fix quota file corruption

Jason Wang (1):
      virtio-net: alloc big buffers also when guest can receive UFO

Li Zefan (1):
      cpuset: fix a race condition in __cpuset_node_allowed_softwall()

Linus Walleij (1):
      ARM: 7991/1: sa1100: fix compile problem on Collie

Lukasz Dorau (1):
      SCSI: isci: correct erroneous for_each_isci_host macro

Marc Kleine-Budde (1):
      can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() =
fails

Michael Chan (1):
      tg3: Don't check undefined error bits in RXBD

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus Sp=
inPoint M8 (2BA30001)

Neil Horman (1):
      vmxnet3: fix netpoll race condition

Paul E. McKenney (1):
      jiffies: Avoid undefined behavior from signed overflow

Radim Kr=C4=8Dm=C3=A1=C5=99 (1):
      KVM: SVM: fix cr8 intercept window

Rob Clark (1):
      drm/ttm: don't oops if no invalidate_caches()

Roman Volkov (2):
      ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2
      ALSA: oxygen: modify adjust_dg_dac_routing function

Stefan Richter (1):
      firewire: net: fix use after free

Steven Rostedt (Red Hat) (1):
      tracing: Do not add event files for modules that fail tracepoints

Sujith Manoharan (1):
      ath9k: Fix ETSI compliance for AR9462 2.0

Takashi Iwai (1):
      ALSA: usb-audio: Add quirk for Logitech Webcam C500

Tejun Heo (1):
      firewire: don't use PREPARE_DELAYED_WORK

Trond Myklebust (1):
      NFS: Fix a delegation callback race


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTL7uWAAoJEDjbvchgkmk+Y2UP/iPNTrDzOB+mFFIBb5CFZKsg
si2y08GEwsx20BynJ9smPHqTqGeP1ZNxlgBbR4aUdglbapycpXcb1AthGKAqP2wl
qYNrL7Kq0k8UY4oR6kYlT7nR7QKNB9W6eYOCM/JfXj3N6+MUqNfieWkquur3yZl2
1ZeXAf+8jqYA9HSs61FUzmHkAVsym4NFXJyTVVCHrxqaHcbhPh8kI/MHpMuJSHGX
Np+4njbugoth8e4h2PaLKge3Swe2wkRp92PKjr+Z6cOMHlfkIN2rI6TW8xPnWjiY
WLYsucelXz51oYsphzAy+iqSS5D2uF0k1Zaf0fhm/fN/yawDPj1+ytwkoe+yO20E
t5gArXflOisMQ/vo/mWeryHjp3WGOrpQraeSpw6UWTLrXxnL6biCk2RF30BHM5Je
FTqGCtKmi8IfR64NnHJBLIoJxySyo2G+yAqe2MPzoDPSsXZmji7FtNteWomZZV4f
Lx6lRhLNTJ7TflR/rGeDsxvj8/1e3g+xvVuVk3dWmVSzCw0Wrsea0nN+1dOGb3DA
DjbKxPlbIXiZ8ax/84DLADlTSL/Ps5G2hhv+lkvomLm0JUfHt6MLTyZvqO5+yPD6
w+fJUY6OOhsS2a0Yu9Zgwk9uDPmkAsCXCeqpgzZwdd/jppTvfOIp00RbX0xHYY++
ej1rJiJQ+ztRLEcOuVhm
=gdKJ
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
