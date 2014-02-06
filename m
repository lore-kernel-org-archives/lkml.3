Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbaBFTzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:55:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaBFTzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:55:46 -0500
Date: Thu, 6 Feb 2014 11:56:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.79
Message-ID: <20140206195655.GA1934@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.79 kernel.

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

 Makefile                                        |    2=20
 arch/arm/mach-at91/sam9_smc.c                   |    2=20
 arch/powerpc/kernel/cacheinfo.c                 |    3=20
 arch/x86/kvm/lapic.c                            |    3=20
 drivers/edac/e752x_edac.c                       |    4=20
 drivers/md/raid5.c                              |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |   13 ++
 drivers/net/ethernet/via/via-rhine.c            |    1=20
 drivers/net/wireless/b43/b43.h                  |    4=20
 drivers/net/wireless/b43/main.c                 |   27 +++---
 drivers/net/wireless/b43/xmit.c                 |    4=20
 drivers/net/wireless/b43legacy/main.c           |    1=20
 drivers/net/wireless/rtlwifi/core.c             |    1=20
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c     |   29 +++---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c     |    1=20
 drivers/parport/parport_pc.c                    |   10 --
 drivers/platform/x86/hp_accel.c                 |    1=20
 drivers/scsi/bfa/bfad.c                         |    6 -
 drivers/staging/rtl8712/usb_intf.c              |    5 +
 drivers/staging/vt6656/baseband.c               |    3=20
 drivers/target/iscsi/iscsi_target.c             |   34 ++++---
 drivers/tty/serial/8250/8250_pci.c              |    4=20
 drivers/tty/serial/atmel_serial.c               |   20 ++--
 drivers/usb/core/config.c                       |    7 -
 drivers/usb/core/hub.c                          |   40 +-------
 drivers/usb/host/xhci.c                         |    3=20
 drivers/usb/serial/cypress_m8.h                 |    2=20
 drivers/usb/serial/option.c                     |   15 +++
 drivers/usb/storage/unusual_devs.h              |    7 +
 fs/btrfs/extent-tree.c                          |    2=20
 include/linux/hugetlb.h                         |    6 +
 mm/hugetlb.c                                    |   17 +++
 mm/swap.c                                       |  107 +++++++++++++++++--=
-----
 net/compat.c                                    |    9 --
 net/ipv4/inet_diag.c                            |    4=20
 net/ipv4/ipmr.c                                 |    7 +
 net/ipv6/ip6mr.c                                |    7 +
 sound/pci/Kconfig                               |   12 ++
 sound/pci/rme9652/rme9652.c                     |    2=20
 sound/soc/codecs/adau1701.c                     |    2=20
 40 files changed, 274 insertions(+), 154 deletions(-)

Andrea Arcangeli (1):
      mm: hugetlbfs: fix hugetlbfs optimization

Andy Grover (1):
      target/iscsi: Fix network portal creation race

Andy Honig (1):
      KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)

Aristeu Rozanski (1):
      e752x_edac: Fix pci_dev usage count

Greg Kroah-Hartman (1):
      Linux 3.4.79

Hannes Frederic Sowa (1):
      net: avoid reference counter overflows on fib_rules in multicast forw=
arding

Jack Pham (1):
      usb: xhci: Check for XHCI_PLAT in xhci_cleanup_msix()

Jean-Jacques Hiblot (1):
      ARM: at91: smc: bug fix in sam9_smc_cs_read()

Johan Hovold (1):
      USB: cypress_m8: fix ring-indicator detection and reporting

Larry Finger (7):
      rtlwifi: rtl8192cu: Add new device ID
      rtlwifi: Set the link state
      rtlwifi: rtl8192cu: Fix some code in RF handling
      b43: Fix lockdep splat
      b43: Fix unload oops if firmware is not available
      b43legacy: Fix unload oops if firmware is not available
      staging: r8712u: Set device type to wlan

Lars-Peter Clausen (1):
      ASoC: adau1701: Fix ADAU1701_SEROCTL_WORD_LEN_16 constant

Malcolm Priestley (1):
      staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity=
 on bScanning

Marek Roszko (1):
      tty/serial: at91: Handle shutdown more safely

Michal Schmidt (1):
      bnx2x: fix DMA unmapping of TSO split BDs

Mikhail Zolotaryov (1):
      USB: Nokia 502 is an unusual device

Neal Cardwell (1):
      inet_diag: fix inet_diag_dump_icsk() timewait socket state logic

NeilBrown (1):
      md/raid5: fix long-standing problem with bitmap handling on write fai=
lure.

PaX Team (1):
      x86, x32: Correct invalid use of user timespec in the kernel

Paul Mackerras (1):
      powerpc: Make sure "cache" directory is removed when offlining cpu

Rahul Bedarkar (1):
      USB: serial: add support for iBall 3.5G connect usb modem

Richard Weinberger (1):
      net,via-rhine: Fix tx_timeout handling

Sebastian Andrzej Siewior (1):
      parport: parport_pc: remove double PCI ID for NetMos

Takashi Iwai (3):
      ALSA: rme9652: fix a missing comma in channel_map_9636_ds[]
      ALSA: Enable CONFIG_ZONE_DMA for smaller PCI DMA masks
      hp_accel: Add a new PnP ID HPQ6007 for new HP laptops

Thomas Pugliese (1):
      usb: core: get config and string descriptors for unauthorized devices

Vijaya Mohan Guvva (1):
      SCSI: bfa: Chinook quad port 16G FC HBA claim issue

Wang Shilong (1):
      Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()

Yegor Yefremov (1):
      serial: add support for 200 v3 series Titan card

ZHAO Gang (1):
      b43: fix the wrong assignment of status.freq in b43_rx()

=E5=BC=A0=E5=90=9B (1):
      usb: option: add new zte 3g modem pids to option driver


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8+kHAAoJEDjbvchgkmk+VTEP/1koVvFmqdODchX61l6ikmIe
EWNvVGGNznPfO+yy/8IontaY+VKyEzJeLmOntbrmH9hetO1f8WDl1lNhfVyLv0U5
orkv5gn0vvjeHwYhd8+4ODLkHxjPZ7aEPImcNHYSbQ0vAZBdSvZwz8MDZYgfJ9gD
z/HHbZrsWgszup+NHhCLFqHUJvLLy6FmxPYq54UpaBmvcArJzTNAAB8otlXidDRI
CbmamiC7J4ZsUeT3CP6/npFmNAnc8cZmc7vnyjhevP6y1/4un1C1dDII6pD7piYG
4+Gw3uW12kNOoIyfor17LU6caJCYf4JmJKQVMg5Myo79lWjYA9DPi9h7BNuG1IQR
+Eoli3jHh26t5c1ilvwmzDo8Nm4EVI7B436VEAJhDU6AIFjNAOx1hZRPn2PLMIM2
Dw4AteF5n/km3efCfcE7ArKlym3ZxY27ks2im63fSaYwn06+gONBp+8Ty1xxOBom
QErBfbq8wsmCjyamAtGhZyMTT7dhnfU27qmd/JR29a9RZx+Gw9gioSSPlC2diYN3
0RGKRLVxHvuEqRNMGvGycLDiv+hGhBFGUuAKwmvw4US+RAaItn8wB8Me7mhWUH67
ga/cdAcjIiZleEi2OZTF+GdQV7Qtu0p2YA+vwtnylL6EjDKujste++0eKcgGNPfC
s/UnNTQAF7XDFgVmpI9U
=mJ9D
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
