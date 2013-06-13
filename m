Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab3FMRL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:11:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab3FMRL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:11:26 -0400
Date: Thu, 13 Jun 2013 10:12:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.49
Message-ID: <20130613171203.GB18119@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.49 kernel.

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

 Makefile                                     |    2=20
 arch/powerpc/platforms/pseries/eeh_pseries.c |   12 ++---
 drivers/acpi/video.c                         |   16 +++++++
 drivers/gpu/drm/drm_irq.c                    |    6 ++
 drivers/gpu/drm/gma500/framebuffer.c         |    4 -
 drivers/gpu/drm/i915/intel_lvds.c            |    4 -
 drivers/gpu/drm/i915/intel_sdvo.c            |    2=20
 drivers/gpu/drm/radeon/atombios_encoders.c   |   11 +++--
 drivers/gpu/drm/radeon/evergreen.c           |   10 ++--
 drivers/gpu/drm/radeon/ni.c                  |   10 ++--
 drivers/gpu/drm/radeon/r100.c                |    9 ++--
 drivers/gpu/drm/radeon/r300.c                |    9 ++--
 drivers/gpu/drm/radeon/r420.c                |   10 ++--
 drivers/gpu/drm/radeon/r520.c                |    9 ++--
 drivers/gpu/drm/radeon/r600.c                |   10 ++--
 drivers/gpu/drm/radeon/rs400.c               |    9 ++--
 drivers/gpu/drm/radeon/rs600.c               |    9 ++--
 drivers/gpu/drm/radeon/rs690.c               |    9 ++--
 drivers/gpu/drm/radeon/rv515.c               |    9 ++--
 drivers/gpu/drm/radeon/rv770.c               |   10 ++--
 drivers/gpu/drm/radeon/si.c                  |   10 ++--
 drivers/hwmon/adm1021.c                      |   58 ++++++++++++++++++++++=
+----
 drivers/usb/host/ehci-sched.c                |    2=20
 drivers/usb/host/xhci-mem.c                  |   10 +++-
 drivers/usb/host/xhci.c                      |   12 +++++
 drivers/usb/serial/ark3116.c                 |    2=20
 drivers/usb/serial/cypress_m8.c              |   18 +++++++-
 drivers/usb/serial/cypress_m8.h              |    4 +
 drivers/usb/serial/ftdi_sio.c                |    2=20
 drivers/usb/serial/iuu_phoenix.c             |    4 -
 drivers/usb/serial/keyspan.c                 |    2=20
 drivers/usb/serial/mos7720.c                 |   25 ++++++++---
 drivers/usb/serial/option.c                  |    2=20
 drivers/usb/serial/visor.c                   |    9 ++++
 drivers/usb/serial/whiteheat.c               |    2=20
 drivers/xen/xen-pciback/pciback_ops.c        |   16 ++++---
 include/linux/ftrace.h                       |    3 -
 kernel/trace/ftrace.c                        |   36 ++++++++--------
 kernel/trace/trace_stack.c                   |    2=20
 sound/usb/mixer.c                            |    1=20
 sound/usb/quirks-table.h                     |   14 +++++-
 41 files changed, 286 insertions(+), 118 deletions(-)

Adis Hamzi=C4=87 (1):
      radeon: Fix system hang issue when using KMS with older cards

Alan Stern (1):
      USB: revert periodic scheduling bugfix

Alex Deucher (1):
      drm/radeon: don't allow audio on DCE6

Alex Hung (1):
      ACPI / video: ignore BIOS initial backlight value for HP m4

Ash Willis (1):
      ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6

Ben Mesman (1):
      drm/i915: no lvds quirk for hp t5740

Bj=C3=B8rn Mork (1):
      USB: option: blacklist network interface on Huawei E1820

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland/Cakewalk UM-3G support

Egbert Eich (1):
      drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DD=
C.

Gavin Shan (1):
      powerpc/eeh: Don't check RTAS token to get PE addr

Greg Kroah-Hartman (1):
      Linux 3.4.49

Guenter Roeck (1):
      hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1=
617

Huacai Chen (1):
      drm: fix a use-after-free when GPU acceleration disabled

Jan Beulich (1):
      xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()

Johan Hovold (9):
      USB: iuu_phoenix: fix bulk-message timeout
      USB: keyspan: fix bogus array index
      USB: ark3116: fix control-message timeout
      USB: visor: fix initialisation of Treo/Kyocera devices
      USB: whiteheat: fix broken port configuration
      USB: serial: fix Treo/Kyocera interrrupt-in urb context
      USB: mos7720: fix DMA to stack
      USB: mos7720: fix message timeouts
      USB: mos7720: fix hardware flow control

Namhyung Kim (1):
      tracing: Fix possible NULL pointer dereferences

Patrik Jakobsson (1):
      drm/gma500: Increase max resolution for mode setting

Robert Butora (1):
      USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device

Sergio Aguirre (1):
      xhci-mem: init list heads at the beginning of init

Steven Rostedt (1):
      ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section

Takashi Iwai (2):
      ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audi=
o iface
      ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam=
 c270

Tony Camuso (1):
      xhci - correct comp_mode_recovery_timer on return from hibernate

Vladimir Murzin (1):
      xhci: fix list access before init

Ying Xue (1):
      USB: ftdi_sio: Quiet sparse noise about using plain integer was NULL =
pointer


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRuf1jAAoJEDjbvchgkmk+jHgP/joHebFgaQQPhR4wsNyHxCeu
fzD859iXx1r7bNPgYG5Y6njI0ZGx6GkYyu902xxSi1lyTbiZsNQQddVQuEyOKP3k
N2CtWxEbTo6Ra/f6LlfwaqMtjoyXltpWZHMzy8+NAG889k/OS4xqQTPAW3uFP2Z6
4iGzfPwM30A+vpRAkBXt+r8RCGpXoQK8198GpitsaQSAlw1Df0xpegtunReaMydu
BmNuJ/QLrYKYY3lyk5AmSwgrf3Bhsu82Zb/7zlHEMFJfgnBOLP5Fz35hfaV5gU7b
rxaD0Qp2ljRdeviC/ZeFH7J9OIFXwxb5mu4OuWLFtc56tiGtGEKrqOn91hQvLFbp
JQzDdn1dzbPsROb1g/upzTLRQlrptfOIaa7Ib2lZ6QSi/rjvlwfVyzeL6nmpcanb
0kg8GYNygeOyy1hEjFsqdLV7xfvrQsh0a2mRxKKFo/IfmRxFdGa3KUZajCyRX8kM
8OYCKd8gDwdO2yW7gcJcsZk43ob6jDbYd03aX0pyQ5g+i6nmaTmNc8342qpm3A5F
GLUX/oj2Em6LzlW/sjhcuLwhyGPNyW9TL2CiYpAjkpuTWajZQjE94oFSFdLHw2R+
abq926iRjIQ3IC9oalJjBqdwk/rE5y9FWZ250hC/o38JTclPQbXEvHBJq3/N+6WV
qGEoht6WH9ARQiqUY+1Y
=Lj5A
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
