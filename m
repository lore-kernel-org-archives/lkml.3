Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaDCWoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:44:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbaDCWoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:44:09 -0400
Date: Thu, 3 Apr 2014 15:46:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.86
Message-ID: <20140403224632.GA13833@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.86 kernel.

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

 Makefile                                 |    2=20
 arch/x86/include/asm/topology.h          |    3=20
 drivers/input/mouse/synaptics.c          |   55 ++++
 drivers/staging/speakup/i18n.c           |   12 -
 drivers/staging/speakup/i18n.h           |   12 -
 drivers/staging/speakup/keyhelp.c        |   36 +--
 drivers/staging/speakup/kobjects.c       |   80 +++---
 drivers/staging/speakup/main.c           |  366 +++++++++++++++-----------=
-----
 drivers/staging/speakup/selection.c      |   14 -
 drivers/staging/speakup/serialio.c       |    6=20
 drivers/staging/speakup/speakup.h        |   72 +++---
 drivers/staging/speakup/speakup_acntpc.c |    6=20
 drivers/staging/speakup/speakup_acntsa.c |    2=20
 drivers/staging/speakup/speakup_apollo.c |    8=20
 drivers/staging/speakup/speakup_audptr.c |    2=20
 drivers/staging/speakup/speakup_bns.c    |    2=20
 drivers/staging/speakup/speakup_decext.c |    6=20
 drivers/staging/speakup/speakup_decpc.c  |    4=20
 drivers/staging/speakup/speakup_dectlk.c |    6=20
 drivers/staging/speakup/speakup_dtlk.c   |    4=20
 drivers/staging/speakup/speakup_dummy.c  |    2=20
 drivers/staging/speakup/speakup_keypc.c  |    6=20
 drivers/staging/speakup/speakup_ltlk.c   |    2=20
 drivers/staging/speakup/speakup_spkout.c |    2=20
 drivers/staging/speakup/speakup_txprt.c  |    2=20
 drivers/staging/speakup/spk_priv.h       |    8=20
 drivers/staging/speakup/synth.c          |   38 +--
 drivers/staging/speakup/thread.c         |    4=20
 drivers/staging/speakup/varhandlers.c    |   66 ++---
 fs/ext4/inode.c                          |   15 -
 include/linux/bitops.h                   |   15 +
 net/netfilter/nf_conntrack_proto_dccp.c  |    6=20
 32 files changed, 469 insertions(+), 395 deletions(-)

Artem Fetishev (1):
      x86: fix boot on uniprocessor systems

Benjamin Tissoires (1):
      Input: synaptics - add manual min/max quirk

Daniel Borkmann (1):
      netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages

Greg Kroah-Hartman (1):
      Linux 3.4.86

Hans de Goede (1):
      Input: synaptics - add manual min/max quirk for ThinkPad X240

Samuel Thibault (1):
      staging: speakup: Prefix externally-visible symbols

Theodore Ts'o (1):
      ext4: atomically set inode->i_flags in ext4_set_inode_flags()


--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPeTIAAoJEDjbvchgkmk+RMkP/3GO2h13xbHdIwKG0WLlR2/S
UlUqrSkKiNW8tccHQYT+vN/zgahgIH7Ef5aAAGgBbYmWURkyME9TCG/IC/Ch5iwT
urrlt5jtgyRgc3HhvCUiXOwoXEmznIODh8jv/zAsRcOZke1CB7IJiflgP4Ff51OS
qri9Q3H3OzXsUXl4KA8XOQpFfAdyJJKW9luDvQz1EvKwYN6Zoy2TmhwDlUJOG580
mMKrOgXeCkfCI+silpiXut0kgQlj3dD0DpVv6kvjc0tQYos2fBmMLv6UbgAcaWRG
rQBVAROwaWZb3KPI9CaWcEnQBC93I5any+cEcQzxaB7wvFk56RtM97IwoSAPy9Bc
69zzP9aCK0vlwBOfBBuHVNC3I6ivggDOz7ItDjZ7Y80+QYhlAgUfbjYCJnAH/fYA
I3BQ2J7eW+8LXFrYvd1Q92I2c5jDloNU5dZFz56IvRDXX3rUV26PieXm5Jz9aB83
cU6AvjpYfq0VsVSk3tnbyAfMzB5e4HNe4RBTrf1wFUh1UKUFuhkBcRdaMjEXX++5
SeWcHjz7dljNGpA6gt2tMmY8aeaBrQ/f5p8FnpdB3mpWMstOVSTYiQOedgjC6hyP
l5jDkAeoTT9dDcEZhwqNIJtls1TJOYiX1qus5XvsqNyf2qzPhOae/dwF2k3olyea
QDEPIvQyz44Psmy4Bffe
=p5tu
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
