Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3EXTIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 15:08:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab3EXTIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 15:08:14 -0400
Date: Fri, 24 May 2013 12:08:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.9.4
Message-ID: <20130524190813.GA1222@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.9.4 kernel.

All users of the 3.9 kernel series must upgrade.

The updated 3.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.9.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/arm64/kernel/debug-monitors.c              |    2=20
 arch/arm64/mm/cache.S                           |    2=20
 arch/arm64/mm/proc.S                            |    3=20
 arch/x86/include/asm/syscalls.h                 |    4=20
 arch/x86/kernel/head64.c                        |    2=20
 arch/x86/kernel/vm86_32.c                       |   11 -
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c |    4=20
 drivers/gpu/drm/radeon/evergreen.c              |    4=20
 drivers/gpu/drm/radeon/radeon_ttm.c             |    2=20
 drivers/gpu/drm/radeon/si.c                     |    4=20
 drivers/hwmon/abituguru.c                       |   16 +-
 drivers/i2c/busses/i2c-designware-core.c        |   14 +
 drivers/i2c/busses/i2c-designware-core.h        |    2=20
 drivers/net/ntb_netdev.c                        |    2=20
 drivers/ntb/ntb_hw.c                            |   10 -
 drivers/ntb/ntb_transport.c                     |  175 +++++++++++++++----=
-----
 fs/btrfs/ioctl.c                                |   10 -
 include/uapi/linux/virtio_console.h             |    2=20
 19 files changed, 170 insertions(+), 101 deletions(-)

Alexander van Heukelum (1):
      x86, vm86: fix VM86 syscalls: use SYSCALL_DEFINEx(...)

Ben Skeggs (1):
      drm/nouveau/bios: fix thinko in ZM_MASK_ADD opcode

Dan Carpenter (2):
      ntb: off by one sanity checks
      NTB: fix pointer math issues

Gabriel de Perthuis (1):
      btrfs: don't stop searching after encountering the wrong item

Greg Kroah-Hartman (1):
      Linux 3.9.4

Jon Mason (8):
      NTB: variable dereferenced before check
      NTB: Handle 64bit BAR sizes
      NTB: Link toggle memory leak
      NTB: reset tx_index on link toggle
      NTB: Correctly handle receive buffers of the minimal size
      NTB: memcpy lockup workaround
      ntb_netdev: remove from list on exit
      NTB: Multiple NTB client fix

Josef Ahmad (1):
      i2c: designware: fix RX FIFO overrun

Linus Torvalds (1):
      x86: Fix bit corruption at CPU resume time

Michael S. Tsirkin (1):
      virtio_console: fix uapi header

Mika Westerberg (1):
      i2c: designware: always clear interrupts before enabling them

Niels Ole Salscheider (1):
      drm/radeon: Fix VRAM size calculation for VRAM >=3D 4GB

Sukanto Ghosh (1):
      arm64: mm: Fix operands of clz in __flush_dcache_all

Wei Yongjun (1):
      hwmon: fix error return code in abituguru_probe()

Will Deacon (1):
      arm64: debug: clear mdscr_el1 instead of taking the OS lock


--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRn7qdAAoJEDjbvchgkmk+2j0P/1e0EyAUauzkkD550Pyo8CCN
LlriPJLZdSgOy5mD7ECFWgpmbroD3jChWHENnvxIpbgxTG9j66Ej8FrbsomUFrq1
U0NKQoD5GvvvyeKCAYCcMf9Ub4OKxXDqLUuSL6vm68an2IHR8Co4/ETl7N7xA+VF
T1WLSnuSW3X61MQ1xptEdpGo4UbeBiav809hypuRHbix14IOzKmW2FsSxUcGsDHi
qSXvZjBt3cLk0suS0gn+Tm8dUZOMFR6lFqJDsOx2rrryDhJdIqfl4wtE0ygWKhO2
U9RdgR9If3paR5FufqNwaExIGTBdr/uoUVqzQHEhAqlD+fIo96cZ6+qAHjJwmZrH
lkM4ouT92+RgmeCmJmZ2uW04SQGhI+679o4ti7GwWqBCI2Xej1fiIXTgCk2XJ0Ep
TmknXeZ790GZ5Jq8na7ffUe3kymxmTez3K2pIZXXm+g+fu4K7bpFfxHS90qqiHig
LYMDs6QaC/WWLXen5+Fr8kebuxqadovCkgMgXu0Zal+I7DcBbdBMlwInCegy1igK
wqfWFieNXd7j3seyMWXXajHZxPrW1I8bMHV1cCBxNWYTqDFtFDsQxrebgsXECTiz
7AChkrI1hplzJO7vQgUXErca1K1JkUvwbqolh34AcMEgY5ifPAoD+yT8+6MwrbHR
gHFlVZDrOSf1f4diVR5L
=KFDH
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
