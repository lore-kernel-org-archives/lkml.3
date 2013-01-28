Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3A1E5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:57:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:44300 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab3A1E5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:57:47 -0500
Date: Sun, 27 Jan 2013 20:59:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.61
Message-ID: <20130128045931.GA3607@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.61 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                   |    2=20
 arch/x86/include/asm/traps.h               |   26 +++++++++
 drivers/acpi/processor_idle.c              |    3 +
 drivers/ata/ahci.c                         |    6 ++
 drivers/dma/ioat/dma_v3.c                  |    2=20
 drivers/firmware/dmi_scan.c                |   78 ++++++++++++++++++++++--=
-----
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   21 +++++++
 drivers/gpu/drm/i915/i915_reg.h            |    3 +
 drivers/gpu/drm/i915/intel_display.c       |    4 +
 drivers/misc/sgi-xp/xpc_main.c             |   34 +++++++++++-
 drivers/pci/pcie/aspm.c                    |    3 +
 drivers/scsi/sd.c                          |   13 ++--
 drivers/staging/usbip/usbip_common.c       |   11 +---
 drivers/staging/usbip/usbip_common.h       |    2=20
 drivers/staging/usbip/vhci_rx.c            |    3 -
 drivers/tty/serial/8250.c                  |    2=20
 drivers/usb/host/uhci-hcd.c                |   15 +++--
 include/linux/pci_ids.h                    |    2=20
 kernel/trace/ftrace.c                      |    2=20
 19 files changed, 188 insertions(+), 44 deletions(-)

Alan Cox (1):
      ahci: Add identifiers for ASM106x devices

Alan Stern (1):
      USB: UHCI: fix IRQ race during initialization

Bart Westgeest (1):
      staging: usbip: changed function return type to void

Chris Wilson (1):
      drm/i915: Invalidate the relocation presumed_offsets along the slow p=
ath

Colin Ian King (1):
      PCI: Allow pcie_aspm=3Dforce even when FADT indicates it is unsupport=
ed

Daniel Vetter (1):
      drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled

Greg Kroah-Hartman (1):
      Linux 3.0.61

Jiri Slaby (1):
      serial: 8250, increase PASS_LIMIT

Joel D. Diaz (1):
      SCSI: sd: Reshuffle init_sd to avoid crash

Kees Cook (1):
      x86: Use enum instead of literals for trap values [PARTIAL]

Konrad Rzeszutek Wilk (1):
      ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled

Robin Holt (1):
      SGI-XP: handle non-fatal traps

Shuah Khan (1):
      ioat: Fix DMA memory sync direction correct flag

Steven Rostedt (1):
      ftrace: Be first to run code modification on modules

Zhenzhong Duan (2):
      drivers/firmware/dmi_scan.c: check dmi version when get system uuid
      drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exis=
ts


--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRBgWzAAoJEDjbvchgkmk+2T0QAKqT0COVaDXPemdcdvJYPGrH
7+r3SZD/F4YokcbXSGlvrKIANpbikyBG7Q5SrBEkqVK1SO4kS7v7Ohoj1SrRhOBR
ecldqWGez5jZqMB1IYzkoBExF6B5ttJ80SterWKMcQzuDr1TOWCdyRpkpdHFqEFM
FqROAI69nbYzdP3Kc0eZwmsLNOAQjfmiBME1wWPDIQ37VxIjlpv2Cv70QIBKUMrd
vPPkDXPWP5X6P76Aevd+ZXRVLTaHMgX7UQp9QbMy75Wf4IdcoIilV9udKC3IgXne
9MKb+BvpkXfd7GKWF5yUapxjV99Aiz99PvlxYk5AgPhxfZFM9SEeLrT8ROuuKUIZ
9K+B1Pz6W8WPgcTjy/z6Bt3QSWjN9nLk5V6Prw+X/HiLpM21CD8D8qYwmIknjMXo
01jGYgJfgRD+v5KiBm/MhUzjAXx164c+ZAsz6GDf7phN4BHtb5HIRyV0Mda8bIq2
dAcRelVpDzps9oSjOYp4ryA0+ZumAgkXix6omJQj0vErN/HPk5Pw6Pi5Rrg3vltG
bTDz+nHA1mvAlSdb6NegK0XbZTAqVn0JKqQtYmlFFdi1eC3H6m4PolGjDDutW8tn
IUqGr3AvGwNp9qEtOcRwBmupe4Q1flgVlOxYW5fLzxvbOpvC0wTQs7FBbf9N8c/6
Jo6n4TMg2moJ/v31xckF
=bdWJ
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
