Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3GCSRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:17:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab3GCSQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:16:59 -0400
Date: Wed, 3 Jul 2013 11:16:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.52
Message-ID: <20130703181658.GA3049@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.52 kernel.

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

 Makefile                          |    2=20
 arch/arm/include/asm/cacheflush.h |    4=20
 arch/arm/mm/flush.c               |   33 +++++
 arch/arm/mm/nommu.c               |    6=20
 drivers/net/wan/dlci.c            |   26 +++-
 drivers/tty/serial/pch_uart.c     |   29 +++-
 fs/exec.c                         |   16 +-
 fs/ubifs/dir.c                    |   54 ++++++--
 include/linux/perf_event.h        |    3=20
 kernel/events/core.c              |  233 ++++++++++++++++++++++++++-------=
-----
 kernel/events/hw_breakpoint.c     |    4=20
 kernel/events/internal.h          |    4=20
 net/bluetooth/l2cap_core.c        |    3=20
 13 files changed, 303 insertions(+), 114 deletions(-)

Anderson Lizardo (1):
      Bluetooth: Fix crash in l2cap_build_cmd() with small MTU

Artem Bityutskiy (2):
      UBIFS: prepare to fix a horrid bug
      UBIFS: fix a horrid bug

Greg Kroah-Hartman (1):
      Linux 3.4.52

Liang Li (1):
      pch_uart: fix a deadlock when pch_uart as console

Oleg Nesterov (1):
      hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()

Peter Zijlstra (2):
      perf: Fix perf mmap bugs
      perf: Fix mmap() accounting hole

Simon Baatz (2):
      ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_pa=
ge
      ARM: 7772/1: Fix missing flush_kernel_dcache_page() for noMMU

Stephane Eranian (1):
      perf: Disable monitoring on setuid processes for regular users

Zefan Li (2):
      dlci: acquire rtnl_lock before calling __dev_get_by_name()
      dlci: validate the net device in dlci_del()


--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJR1GqaAAoJEDjbvchgkmk+mesQALE2o/9NjzRGA7bo4JsO3Rs2
njPEiZa8a+bWGSoULF9pj1ixs/GABoQNQOhqD51V3avkDCqkspB9Wd7YD5WvT0Qj
QTg5chU5ac7GvUrIWY3bJzdkExIB3BZ1EiSJ4qLdS0vXdCY70i2hICqHIkT3mxu1
+T92canTf4nKuUswz6AkqXbvF0HyTRQqmgugHav6eEi6L+n3O30jQCpqO1qIyJET
0CIPKJmvMcz+gQ9QQAslWvNf/tfasClkWO6S9VMF//t8ucU4uuiJkL46FspJoomX
+zPsyfmavmyrSJozpWU0q/lKyIDCk4duUI6UBJeVqu1/UXM82oU5YfnhT2AuZ9Ee
pIa44aV20okOq5hgA25uekZOjNuO1VfR1Ix/m6ZekVyYkIX4HZ4RJhUbIB+rmMwk
c9PzvvNPxTSvcE7f9H1pgxOWzpHRbNffRQy6UX3MSaRqD9qSi5RBx17nlgYM0TWE
PXHc3lnAUR//5mdrvUAcireRkI1a3GcvuwcVw9KMQGQYwoo+i2XaNHZlhiX2n4hz
SSxc469DhcrdawgqbQGV1OOo8ow+/L5RpDVVNFKZgEpW2vxc9nF1KJ09rIl2R362
ulCr2+aqGxurl6CJseA10rhuyBEDhAEg8lifbputP0TMr28tEm1SrptDiCdOk8Xo
fHr/YzKlu8EtnYM9Zv2p
=JZ73
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
