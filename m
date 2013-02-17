Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3BQTE1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:04:27 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:59937 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3BQTE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:04:26 -0500
Date: Sun, 17 Feb 2013 11:04:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.32
Message-ID: <20130217190444.GA10122@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.4.32 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 +-
 arch/s390/kernel/time.c                   |    3 +++
 arch/x86/include/asm/pgtable.h            |    5 +++++
 arch/x86/kernel/apic/x2apic_phys.c        |   21 +++++++++++----------
 arch/x86/mm/fault.c                       |    8 +++++---
 arch/x86/mm/init_64.c                     |    3 +++
 arch/x86/platform/efi/efi.c               |    2 +-
 arch/x86/xen/xen-asm_32.S                 |   14 +++++++-------
 drivers/net/ethernet/intel/igb/igb_main.c |    8 +++++---
 drivers/pci/remove.c                      |    2 ++
 10 files changed, 43 insertions(+), 25 deletions(-)

Alexander Duyck (1):
      igb: Remove artificial restriction on RQDPC stat reading

Greg Kroah-Hartman (1):
      Linux 3.4.32

Heiko Carstens (1):
      s390/timer: avoid overflow when programming clock comparator

Jan Beulich (1):
      x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.

Kees Cook (1):
      x86: Do not leak kernel page mapping locations

Mel Gorman (1):
      x86/mm: Check if PUD is large when validating a kernel address

Rafael J. Wysocki (1):
      PCI/PM: Clean up PME state when removing a device

Satoru Takeuchi (1):
      efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" boot parameter

Stoney Wang (1):
      x86/apic: Work around boot failure on HP ProLiant DL980 G7 Server systems


--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRISnMAAoJEDjbvchgkmk+X6IP/1/JYr+mpFgYlQ5bTxAfv8no
Ssl5XUL00vQ2TcMy+3iT+pNFSp9uUSZPjdiMvTpp0R2g6v84m5JbXB3nsOBERuMi
oOUc7k/AtziZA7Pnk2XNyr+smW6zrmISiuFUrM1sSs3NV3b2DWc9Uyc8mmocnh0/
ix4Ne+jB2+diQFn6GXT5nz5Ybl7BwDOEJgRZgQAGTIoD36jh62glD6H4f5N2yG7p
6febBzl1RQMhZnRqV/f4kiggHuTi0RM0BxJtJone5P1nBF/vGvSclpctm/RoEQrm
oGnSgJM6NJeMun20zxvHNdXaEE8u9GW1pGQ2r44thPRGj7PhIx+8L3rUbmsbl6hs
FHbE35uVGxICJZhD1Or1QKbj6bD/XV4BJmdn1Vy8cZ1OQ2MabOJC5bXipi+Zxghp
lnHmTbEoTC866OQNJVEaQPTlPwOFJIbV7e9BaIBlyCWBk0MfTNyfkH174Fy+1u8u
nLhAso8pU76wFEJd0e5UXAaUlOSIOfYBiaJgq95iTMXd9WKPBnZlkJKbrO+vK9eQ
01sWskuUQx4A26tkV1mUKJAQ4jnx2MDcA4OvZdqFDg48fgaCD66uYDF2OTz3HvDF
Lxfrn1w8RuQHl+syGF+sRbetDd0bRk5qTMVDgl18emEpTs+5L1vVIGnzXJdlmx0D
ECvJ+840Hhf4lEnRNMTA
=rBqd
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
