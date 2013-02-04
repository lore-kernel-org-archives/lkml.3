Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3BDEcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:32:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:50520 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab3BDEcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:32:07 -0500
Date: Sun, 3 Feb 2013 20:34:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.62
Message-ID: <20130204043417.GA14790@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.62 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 +-
 arch/arm/mm/dma-mapping.c                |   18 ++++++++++--------
 arch/x86/kernel/msr.c                    |    3 +++
 arch/x86/kernel/setup.c                  |    2 ++
 arch/x86/platform/efi/efi_64.c           |   22 +++++++++++++++++-----
 drivers/edac/edac_pci_sysfs.c            |    2 +-
 drivers/net/can/c_can/c_can.c            |    4 ++--
 drivers/net/can/pch_can.c                |    2 +-
 drivers/net/can/ti_hecc.c                |    4 ++--
 drivers/net/wireless/ath/ath9k/beacon.c  |    1 +
 drivers/net/wireless/ath/ath9k/htc_hst.c |    2 ++
 fs/cifs/cifs_dfs_ref.c                   |    2 ++
 kernel/smp.c                             |   13 ++++++++++++-
 net/bluetooth/hci_event.c                |    2 +-
 net/bluetooth/hidp/core.c                |    2 +-
 sound/usb/mixer.c                        |   17 ++++++++++++-----
 16 files changed, 70 insertions(+), 28 deletions(-)

Alan Cox (1):
      x86/msr: Add capabilities check

Anderson Lizardo (1):
      Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()

Clemens Ladisch (1):
      ALSA: usb-audio: fix invalid length check for RME and other UAC 2 devices

Cong Ding (1):
      fs/cifs/cifs_dfs_ref.c: fix potential memory leakage

Dan Carpenter (1):
      EDAC: Test correct variable in ->store function

Felix Fietkau (1):
      ath9k: fix double-free bug on beacon generate failure

Greg Kroah-Hartman (1):
      Linux 3.0.62

H. Peter Anvin (1):
      x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI

Nathan Zimmer (1):
      efi, x86: Pass a proper identity mapping in efi_call_phys_prelog

Olivier Sobrie (3):
      can: c_can: fix invalid error codes
      can: ti_hecc: fix invalid error codes
      can: pch_can: fix invalid error codes

Russell King (1):
      ARM: DMA: Fix struct page iterator in dma_cache_maint() to work with sparsemem

Sujith Manoharan (1):
      ath9k_htc: Fix memory leak

Szymon Janc (1):
      Bluetooth: Fix sending HCI commands after reset

Wang YanQing (1):
      smp: Fix SMP function call empty cpu mask race


--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRDzpJAAoJEDjbvchgkmk++XkP/RwLwjYpwR87co23ZGkSwAzk
ZVb9BakMPD9QWFbTEBDIEejifgImJkKOmulc51BwFHaD9Zjlb0+c8lTohDFRVyDq
PK0t4y8cV0N0SrDrzDQW28kJMfrbmqsosXJYYqFAkRicJn7lEM4cSPZT+wUu3OCX
gEOyBTkAjMAQfs9O4Ay/sfcY148+RrLxls4LPtVPZxKB31w6WDHG/a3Bi3rvseBy
4rY8lP7FUJx1/mKyMIwtEj6AXj4Hb61iIzb/A38bLwaEGqEQtkN73dMsWaelosBo
SSircT0TiJH7neSRMZyY0r3ske5e1w4iHrwvXsIIGhDvVlW7GxS4rcdSjdDqaB2L
B0mvYzTOd5h5KYbs+NbamVoZddMA31Ige89rTvp2EkIU9YBaFnk7tTkqptI76RAp
DHHGfg00hlMpwYqG17ZFCfrB5IrZdYAuxowUav/6QxbF0mlOzR/qWaBQC4BRVv63
MtyfMN4ik2NWwSMLhfCJua6KyYt54UyHzv1vuTaZbLEwiJhLFqYFVebkeTHohknX
iWqsWxYvUGRS4ha49TQcp92foxJvY1x29HLoAe7qZz2FDH2tnqJXolZAvL/rstAQ
RYCLmDcHoaa2XmsbsD1jgvvm1R0EXFVDunhLlQMl+2TrYvKMm0iY962fQ49nqUJ4
SmPQQdfWxBUqPea5Um+9
=HkXy
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
