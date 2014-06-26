Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaFZTeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:34:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaFZTem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:34:42 -0400
Date: Thu, 26 Jun 2014 15:25:04 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.95
Message-ID: <20140626192504.GA24606@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.95 kernel.

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

 Makefile                                  |    2=20
 drivers/net/ethernet/mellanox/mlx4/main.c |  172 ++++++++-------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    7=20
 drivers/net/team/team.c                   |    7=20
 drivers/target/iscsi/iscsi_target_auth.c  |   10=20
 drivers/usb/class/cdc-acm.c               |   96 +++++---
 drivers/usb/class/cdc-acm.h               |    2=20
 include/linux/if_team.h                   |    1=20
 include/linux/lzo.h                       |   15 -
 include/net/inetpeer.h                    |    9=20
 include/sound/core.h                      |    2=20
 kernel/time/tick-sched.c                  |    4=20
 lib/decompress_unlzo.c                    |    2=20
 lib/lzo/Makefile                          |    2=20
 lib/lzo/lzo1x_compress.c                  |  335 +++++++++++++++++--------=
-----
 lib/lzo/lzo1x_decompress.c                |  255 ----------------------
 lib/lzo/lzo1x_decompress_safe.c           |  257 +++++++++++++++++++++++
 lib/lzo/lzodefs.h                         |   38 ++-
 lib/nlattr.c                              |    5=20
 net/ipv4/ipip.c                           |    1=20
 net/ipv6/ip6_output.c                     |   11=20
 net/ipv6/ip6_tunnel.c                     |    1=20
 net/ipv6/sit.c                            |    1=20
 net/sctp/associola.c                      |    2=20
 security/integrity/evm/evm_main.c         |   12 -
 sound/core/control.c                      |   78 ++++--
 sound/core/init.c                         |    1=20
 sound/pci/hda/patch_realtek.c             |    1=20
 28 files changed, 747 insertions(+), 582 deletions(-)

Eric Dumazet (1):
      net: fix inet_getid() and ipv6_select_ident() bugs

Greg Kroah-Hartman (2):
      lzo: properly check for overruns
      Linux 3.4.95

Jiri Pirko (1):
      team: fix mtu setting

Johan Hovold (7):
      USB: cdc-acm: fix write and suspend race
      USB: cdc-acm: fix write and resume race
      USB: cdc-acm: fix broken runtime suspend
      USB: cdc-acm: fix runtime PM for control messages
      USB: cdc-acm: fix shutdown and suspend race
      USB: cdc-acm: fix I/O after failed open
      USB: cdc-acm: fix runtime PM imbalance at shutdown

Kailang Yang (1):
      ALSA: hda/realtek - Add support of ALC891 codec

Lars-Peter Clausen (5):
      ALSA: control: Protect user controls against concurrent access
      ALSA: control: Fix replacing user controls
      ALSA: control: Don't access controls outside of protected regions
      ALSA: control: Handle numid overflow
      ALSA: control: Make sure that id->index does not overflow

Markus F.X.J. Oberhumer (2):
      lib/lzo: Rename lzo1x_decompress.c to lzo1x_decompress_safe.c
      lib/lzo: Update LZO compression to current upstream version

Michal Schmidt (1):
      netlink: rate-limit leftover bytes warning and print process name

Mimi Zohar (1):
      evm: prohibit userspace writing 'security.evm' HMAC value

Nicholas Bellinger (1):
      iscsi-target: Reject mutual authentication with reflected CHAP_C

Thomas Gleixner (1):
      nohz: Fix another inconsistency between CONFIG_NO_HZ=3Dn and nohz=3Do=
ff

Tom Gundersen (1):
      net: tunnels - enable module autoloading

Wei Yang (2):
      mlx4_core: Stash PCI ID driver_data in mlx4_priv structure
      net/mlx4_core: Preserve pci_dev_data after __mlx4_remove_one()

Xufeng Zhang (1):
      sctp: Fix sk_ack_backlog wrap-around problem


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrHOQAAoJEDjbvchgkmk+4CUP/3yflIAtKRT6FMIAe+Qjlbxj
BaCtUedAMbJPFc4KBSXIAkmAtC/wxO9OhJdnw1wgvzqVBEMGNXtr91tqZzfc6d9j
d3Ivy//leO69JOVKxMLRSadYnOnl8Myx5vvCJe17q9sXNrkXXIdGdXLzkgP2wPs6
fDThScuBPMUm2REE4NeGjbKL/zdAiDbFaclL2ywdUiODWNLjIFX80HQKyqCGfgkt
h2NUnl5IUsP79Iv65bIZ+O60RgIygsRg6U4wbiCnoRKsyIcfgC/Dzp6Xc6ILIYIK
O0hsc0I9AHmuyx4SRTzE8LFJlYnef9V/T0W3MghI5go1tv1RYTi2EQgU6GUKJBXK
6kS8e27MYdKAKfEGxV0WeiyfYnY/vFtaTKosxie5NJwoEK8eM+8KByyK7XwlRs3o
hUQhugrkN3jxtRs3+8zjHPOzowJXBr/sP9u5DhByqp35V/Pn1JuYtz3pYgUcZSO2
SNOOgzzPeNbabbIqNRg7I+nBo/A61eyjAPuRi+N3Vh0rBGqaaOk9hDuVAxGfGzml
F/wkF37FGPXfwlAuEXFGKqTdI+TId0GEGjXQAFofoLUCwuRnp+3QBZyHgujrqCfa
MD3kM3wvQxoo1a1dd72ZDLlg5xgF/T+r/A2cmL7QKpaLEcGWOoAwbveL4Ci09dFr
WoOXoco6mqsgvKlyMRc0
=ANuj
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
