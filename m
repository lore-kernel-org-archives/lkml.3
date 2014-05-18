Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaERMr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 08:47:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaERMrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 08:47:25 -0400
Date: Sun, 18 May 2014 05:47:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.91
Message-ID: <20140518124723.GA11692@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.91 kernel.

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

 Makefile                                    |    2=20
 arch/powerpc/lib/crtsavres.S                |  186 +++++++++++++++++++++++=
+++++
 block/blk-core.c                            |    2=20
 drivers/scsi/megaraid/megaraid_mm.c         |    2=20
 drivers/tty/n_tty.c                         |    2=20
 drivers/video/tgafb.c                       |   15 +-
 include/linux/net.h                         |   23 +++
 include/net/netfilter/nf_conntrack_extend.h |    4=20
 include/trace/events/block.h                |   33 ++++
 kernel/trace/blktrace.c                     |   20 +--
 kernel/tracepoint.c                         |    6=20
 net/bridge/netfilter/ebtables.c             |    5=20
 net/ipv4/netfilter/arp_tables.c             |    6=20
 net/ipv4/netfilter/ip_tables.c              |    6=20
 net/ipv6/netfilter/ip6_tables.c             |    6=20
 scripts/mod/modpost.c                       |    8 -
 16 files changed, 296 insertions(+), 30 deletions(-)

Andreas Schwab (1):
      powerpc: Add vr save/restore functions

Andrey Vagin (1):
      netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len

Dan Carpenter (1):
      SCSI: megaraid: missing bounds check in mimd_to_kioc()

Greg Kroah-Hartman (1):
      Linux 3.4.91

Joe Perches (1):
      net: Add net_ratelimited_function and net_<level>_ratelimited macros

Mikulas Patocka (1):
      tgafb: fix mode setting with fbset

Peter Hurley (1):
      n_tty: Fix n_tty_write crash when echoing in raw mode

Roman Pen (1):
      blktrace: fix accounting of partially completed requests

Steven Rostedt (Red Hat) (1):
      tracepoint: Do not waste memory on mods with no tracepoints

Thomas Graf (1):
      netfilter: Can't fail and free after table replacement


--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTeKvbAAoJEDjbvchgkmk+QPMQAJPtEwb9ec+Oao7XP2nZEH7S
i79gbtOQPR1EysIqxMAMomz+55VVH9YWWQvLHKrg61ywtXVpp1JMXD9sgtIOGSre
PymoNhu0w4rQO7df0nM7BLgxE4eMOnnrcRxnTT+6MAqYHBxOk/Ig+8uWR9/t6ADJ
1a6GtBDPhYbvH1o84/LiuWiouL1C4tgmpT8ByBppn2G/GbidicytJuEqZTO0ja0A
n1ruT4zTkubc72bsRUmQbRY9xCGUR8MyTa+/P8nHRiao0ZshE8Ots/ZjBvyiSRIv
61KUJbENp0zp9UJJN7CEzwUNf2dIdebU59+ZS0b2FdINW5LZZKtfh3RfStxnm935
JrcfyIySxtSRJMU5ZFSOmGJ8naQjO3IxpbfVvvVguhKr8Dsvnry+accWQEp6HMfT
6q/3iF2vBKtAxrXA47n1qjh1HXNtom2lNPYE9wyYIYjrrWbfKuTvi95Hgka8p/Fi
LctOQm04Oyskf01a9p4L/6F+KtMkdUr6BN2y64qzL7jqjm+q7xThXdslhXboIY93
FTXSJaEBj9dE3rcUQeA+BjtEkwSz7l6KltVV7HphxVQKrEC+sAtOAA+ohIqr6u8+
ym/LYiDv6oELwIuq1t1H1ShiygO1lqW8xj2Ry5kI5TGBKH1diTb83yp1pEuYLCmr
hTFbbs368e/13BsjK4QU
=ZB9J
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
