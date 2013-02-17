Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab3BQTDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:03:48 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55729 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3BQTDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:03:46 -0500
Date: Sun, 17 Feb 2013 11:04:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.65
Message-ID: <20130217190404.GA5719@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.65 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                       |    2 +-
 arch/x86/include/asm/pgtable.h |    5 +++++
 arch/x86/mm/init_64.c          |    3 +++
 arch/x86/xen/xen-asm_32.S      |   14 +++++++-------
 drivers/net/igb/igb_main.c     |    8 +++++---
 drivers/pci/remove.c           |    2 ++
 6 files changed, 23 insertions(+), 11 deletions(-)

Alexander Duyck (1):
      igb: Remove artificial restriction on RQDPC stat reading

Greg Kroah-Hartman (1):
      Linux 3.0.65

Jan Beulich (1):
      x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.

Mel Gorman (1):
      x86/mm: Check if PUD is large when validating a kernel address

Rafael J. Wysocki (1):
      PCI/PM: Clean up PME state when removing a device


--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRISmkAAoJEDjbvchgkmk+kKAQAIHcIPnEXZPl/5Vp1Xj+RnfP
6wnIVy4Ak/yINwIYbZmP3GghwsRRujQLxbzlqYn1qq7eY+bc5ZSdHze3vLGYFnc9
PzOYBncZIPpEvvZnd0RHUUEg+MkkB6/MpbTuXmd6RKNiq90t7Mg7EAu0N+EUKzUx
Evy43ytw0goLYkJmJyP7RKaGdeNvE07UeU1AeizGnQiZAXCE831kNLj5d8xDo83N
YtexWuvPygWJ6x1kP6xqo9EI+dwdk57QdRB+y9KBapVMOII1hxysIxNq3Nw6xZwg
XGJrLR3E8W8acf1H0bXaoY848F3Ijk4a31B4TrAiEQu2BWjNJyPPW+FdJbPsZbx0
BZ8xqNaCC565z4+cXYgN3o5+kRcJexF9L08aiPpi5M+MRyt+h8gi0qpJ6SQrvVMX
9hiSG4XhgOVR8U/yY6OYFX4tAOyPTtL34GsHESmkcpkvMYAcFBXlH3AmJw4WPDeF
AKqxAQ5p5bYsku+YcmNRqjdGnQMYGz63oZiKZx2frWOKhOb60/a41C1tOX1YOhtT
D4KmKfsmOimbtPoUNZIymrG+68qO9TAsuChNz7/VJPN6Fu6u3hG8IuRjB77NLCFJ
mXsD+g4ku902/vD33qJPYnLzM991GTONYOspJ+IrL3V9qpeYSwFOf2HB6FEXfQXQ
s7BteeDoa9ewVu5nKALw
=cuKY
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
