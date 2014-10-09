Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbaJIVrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:47:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaJIVrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:47:04 -0400
Date: Thu, 9 Oct 2014 14:47:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.57
Message-ID: <20141009214703.GA8571@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.57 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                 |    2 -
 drivers/block/drbd/drbd_nl.c             |    6 +++
 drivers/cpufreq/cpufreq_governor.c       |   10 -----
 drivers/cpufreq/cpufreq_governor.h       |    1=20
 drivers/cpufreq/cpufreq_ondemand.c       |   39 ++++------------------
 drivers/cpufreq/cpufreq_stats.c          |    2 -
 drivers/md/raid5.c                       |   18 +++++++++-
 drivers/media/v4l2-core/videobuf2-core.c |   15 +++++++-
 fs/udf/inode.c                           |   35 ++++++++++++--------
 include/linux/jiffies.h                  |   12 ------
 include/media/videobuf2-core.h           |    4 ++
 init/Kconfig                             |    1=20
 kernel/events/core.c                     |    4 +-
 kernel/fork.c                            |    5 +-
 kernel/time.c                            |   54 +++++++++++++++++---------=
-----
 kernel/trace/ring_buffer.c               |    2 -
 mm/huge_memory.c                         |   11 ++++--
 net/wireless/nl80211.c                   |    6 +++
 18 files changed, 122 insertions(+), 105 deletions(-)

Andreas Schwab (1):
      cpufreq: Fix wrong time unit conversion

Andrew Hunter (1):
      jiffies: Fix timeval conversion to jiffies

Greg Kroah-Hartman (1):
      Linux 3.10.57

Hans Verkuil (1):
      media: vb2: fix VBI/poll regression

Jan Kara (1):
      udf: Avoid infinite loop when processing indirect ICBs

Johannes Berg (1):
      nl80211: clear skb cb before passing to netlink

Josh Triplett (1):
      init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu

Lars Ellenberg (1):
      drbd: fix regression 'out of mem, failed to invoke fence-peer helper'

Mel Gorman (1):
      mm: numa: Do not mark PTEs pte_numa when splitting huge pages

NeilBrown (1):
      md/raid5: disable 'DISCARD' by default due to safety concerns.

Peter Zijlstra (1):
      perf: fix perf bug in fork()

Steven Rostedt (Red Hat) (1):
      ring-buffer: Fix infinite spin in reading buffer

Stratos Karafotis (1):
      cpufreq: ondemand: Change the calculation of target frequency

Waiman Long (1):
      mm, thp: move invariant bug check out of loop in __split_huge_page_map


--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUNwJXAAoJEDjbvchgkmk+y9oQAIEFwzZrju2m21SFvojTaUej
F1nxO1B/ITjqWLZq/zVEWCLPjBn7AwKn6UdOMTXX8wJEbcIIAMK1JEnhyjaSI0LU
CSyXfMp1cM7mm/Xia6/7/cz6hZIywB5aQ+VhSQ9p/oUp9sO8V8JC6hoZBBBApJjY
+hKugCQORHJtVhEq++/E7/DgPGZ+FQPUHR2J6VQGfFXNCrhU8RyWZTfCcOQB0mwr
ELe1TrgWmJgEsokrNzDhP/uQ9LdQZFu8L+iLY9EQexQoEkvEfFO7zeJEuAH2uTy/
2HXpGJBE68VyZfHLcnyqQPUCJalvCxivQ5bLJbpexsKzLezGQOlcjjV9MCu+uL1Z
b8ZdKqyPGp3rKMG2H8VXheYkkRZkFfLBsforUFZ07XJ/5N7BUqkdN7pAWMHrP+XL
bAxrFQTjWviCFs2NEpOgNKk7G9aF8ln0jsaRnc5r9qpzHLs+rtPCvSJlFfyAOXy9
nosjP9bOYwaiW1UQBDgH2KrOVqgBSBtadeuJ0nYkeXrISKboz7YstzkWk0b85uYS
n3leNeqT5XfsoFOORK4o5bIUjzZVWv1/HNYwOhzhs9aRO36g0FDt8GQPqmzl8N1d
pO8yFKvCcMVkPANhJTzmVwsbT7K1RFejIhikJwzovk+OjjQo4ZrtV7+vuMs6agrG
AT6v19VWKVeW/OfBlqnQ
=VEiP
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
