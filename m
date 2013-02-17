Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3BQTFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:05:20 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55512 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3BQTFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:05:18 -0500
Date: Sun, 17 Feb 2013 11:05:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.7.9
Message-ID: <20130217190535.GA15916@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.7.9 kernel.

All users of the 3.7 kernel series must upgrade.

The updated 3.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.7.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 +-
 arch/s390/kernel/time.c            |    3 +++
 arch/x86/include/asm/pgtable.h     |    5 +++++
 arch/x86/kernel/apic/x2apic_phys.c |   21 +++++++++++----------
 arch/x86/mm/fault.c                |    8 +++++---
 arch/x86/mm/init_64.c              |    3 +++
 arch/x86/platform/efi/efi.c        |    2 +-
 arch/x86/xen/xen-asm_32.S          |   14 +++++++-------
 drivers/pci/remove.c               |    2 ++
 drivers/rtc/rtc-pl031.c            |    4 +++-
 fs/xfs/xfs_buf.c                   |   18 ------------------
 mm/mlock.c                         |    6 +++---
 12 files changed, 44 insertions(+), 44 deletions(-)

Gerald Schaefer (1):
      mm: don't overwrite mm->def_flags in do_mlockall()

Greg Kroah-Hartman (2):
      Revert: xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end
      Linux 3.7.9

Heiko Carstens (1):
      s390/timer: avoid overflow when programming clock comparator

Jan Beulich (1):
      x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.

Kees Cook (1):
      x86: Do not leak kernel page mapping locations

Linus Walleij (1):
      drivers/rtc/rtc-pl031.c: restore ST variant functionality

Mel Gorman (1):
      x86/mm: Check if PUD is large when validating a kernel address

Rafael J. Wysocki (1):
      PCI/PM: Clean up PME state when removing a device

Satoru Takeuchi (1):
      efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" boot parameter

Stoney Wang (1):
      x86/apic: Work around boot failure on HP ProLiant DL980 G7 Server systems


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRISn/AAoJEDjbvchgkmk+JsIP/R5cFHPAjuno2eukaJHz/N1K
LG3SK778CllX2WbtTqwSqyVj6L8FfWEqpk92Olb2ASIR7k9ejeF905E3juWUnkv1
HEbFLJdu4UaXeeB1LLM25v6tg8yifdeqEjt73/fh6hIeJHNEO6TVSguvNJ/qtaia
JFOKxiWNkXIoTs5P7WnKeFSO7ZdyTZxlszJMidMGSW3QgID5bsFwZK9uxMjxPKso
+pbhGgFgTXzFMXMnCUnlAsnREnpcWnPPE0/z6mOW9zH7jnQOs1ou2pCAoN0gJWF0
zsYQRKfd7x5abEV/nN2oz1U4dLk+bOIEf9TKxjOc7zIZXuO34rRiZirqeyANUjSR
cVp0dXotaU+hZ+SaoC9OQ5aRjdMqZtNIw0rfYw9Z4vFbLcv05RnUglFvXbzonpty
u7FIwdyKH/O3fS+nenogfem+IkMU4uL/VXlwBzjEFJLtuBssCAsXwDDpC/IkTqP0
4SuKtHQQ4cqyz7+Ulq2Bd9+9fMNp57FYId5sY1NlBLiPB7Q+OSt8DAvOc6XaFP4S
xCREIeWevjsnjpG3u2j4za0hnQtg7dtRXxCCyn9NaP+wPSpTs3e8B2ppMRAi/0Ik
bfmGZCbNlo0To+BYqiJsjpJLAYnQQXUk6cy07/GDxJfuW5i24aSx32OOSZaDhPeK
UxbUConh3kbuxngRSQ4c
=oNdz
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
