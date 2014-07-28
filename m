Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaG1Rkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:40:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaG1Rkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:40:32 -0400
Date: Mon, 28 Jul 2014 10:40:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.100
Message-ID: <20140728174005.GA16334@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.100 kernel.

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
 arch/x86/kernel/cpu/perf_event_intel.c      |    9 +
 crypto/testmgr.h                            |   38 ++++---
 drivers/gpu/drm/radeon/radeon_display.c     |    5 +
 drivers/iommu/dmar.c                        |   11 ++
 drivers/iommu/intel-iommu.c                 |   15 +++
 drivers/net/ethernet/emulex/benet/be_main.c |    2=20
 drivers/net/ethernet/sun/sunvnet.c          |   20 +++-
 drivers/net/ppp/pppoe.c                     |    2=20
 drivers/net/wireless/mwifiex/main.c         |    1=20
 kernel/power/process.c                      |    1=20
 kernel/time/alarmtimer.c                    |   20 +++-
 mm/shmem.c                                  |  139 +++++++++++++++++++++++=
+++--
 mm/truncate.c                               |   25 -----
 net/8021q/vlan_core.c                       |    5 -
 net/appletalk/ddp.c                         |    3=20
 net/dns_resolver/dns_query.c                |    4=20
 net/ipv4/igmp.c                             |   10 +-
 net/ipv4/ip_options.c                       |    4=20
 net/ipv4/tcp_input.c                        |   10 +-
 net/ipv4/tcp_output.c                       |    6 -
 net/sctp/ulpevent.c                         |  122 +++---------------------
 net/tipc/bcast.c                            |    1=20
 23 files changed, 273 insertions(+), 182 deletions(-)

Alex Deucher (1):
      drm/radeon: avoid leaking edid data

Amitkumar Karwar (1):
      mwifiex: fix Tx timeout issue

Andrey Utkin (1):
      appletalk: Fix socket referencing in skb

Ben Hutchings (1):
      dns_resolver: Null-terminate the right string

Christoph Schulz (1):
      net: pppoe: use correct channel MTU when using Multilink PPP

Daniel Borkmann (1):
      net: sctp: fix information leaks in ulpevent layer

Eric Dumazet (1):
      ipv4: fix buffer overflow in ip_options_compile()

Greg Kroah-Hartman (1):
      Linux 3.4.100

HATAYAMA Daisuke (1):
      perf/x86/intel: ignore CondChgd bit to avoid false NMI handling

Hugh Dickins (3):
      shmem: fix faulting into a hole while it's punched
      shmem: fix faulting into a hole, not taking i_mutex
      shmem: fix splicing from a hole while it's punched

John Stultz (1):
      alarmtimer: Fix bug where relative alarm timers were treated as absol=
ute

Jon Paul Maloy (1):
      tipc: clear 'next'-pointer of message fragments before reassembly

Li RongQing (1):
      8021q: fix a potential memory leak

Manuel Sch=F6lling (1):
      dns_resolver: assure that dns_query() result is null-terminated

Markus F.X.J. Oberhumer (1):
      crypto: testmgr - update LZO compression test vectors

Neal Cardwell (1):
      tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb

Sowmini Varadhan (1):
      sunvnet: clean up objects created in vnet_new() on vnet_exit()

Suresh Reddy (1):
      be2net: set EQ DB clear-intr bit in be_open()

Takao Indoh (1):
      iommu/vt-d: Disable translation if already enabled

Takashi Iwai (1):
      PM / sleep: Fix request_firmware() error at resume

Yuchung Cheng (1):
      tcp: fix false undo corner cases

dingtianhong (1):
      igmp: fix the problem when mc leave group


--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1or1AAoJEDjbvchgkmk+4aMP/i18rzKAs0hBAHDsAX5DRUlZ
YkdV70QIr066nTM/qpgS6XUrB4cxyqBI04khvBwI36F68nWglbbjOuubmJFO6T8m
oScJr4K7OqU+026scjSoLcTBVokOCxB7TtI76XY3OeMKasfEkm72fFnXETdOfX4+
xZFDN/Fy+bBv67EBG/6L8O7YIjhCqa8tWTyq1eHZmpTQ+fVwKXpkQQlqGKzQISgc
2fL11CGWmnwtXuCv3bsPFnJolk6/dYveKVOGjbSigHnJljq+yRb01yje21A4Qehi
yHtOTWOEfH81609KPJ9qBoZFvclpuYbvdQRaU5WP0WwE2GSbltm1N6viihoE6iLz
/iaKS+SOAwPnstfD3aFIT8KNHlzIRtWOMOW5iqLglHZikVTyai++2TeAHfbgpwHd
SCEtQd4xM6g3tmm8woNuiLYAA2mZfBhXUaeFNTfbvFRrQgHTO0P3OAWb9vGsPrse
YLkB6hMCH7OkKt8BxKhSkrW5UzNZFJBcW/Une8iKjxD9CwLh3EjHvfNh9SfZIb3e
NE8OOjI4xlp39CSxMbhhAXZXcQP4f+MyYc+9ypC5nOmbiJoShHfeU0TaSClN9dEM
j535WH8+Jnk6Ogp6dGAlykF/w0T6F6IAbSkUKgt+iAb/Pza0OgrVyssOA5dr8jY3
HkhQjb6k8AYzASOEggtl
=paQk
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
