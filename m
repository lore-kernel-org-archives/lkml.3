Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab3GOCDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 22:03:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34154 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3GOCDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 22:03:42 -0400
Date: Mon, 15 Jul 2013 12:03:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Linus-next stats (Was: Linux 3.11-rc1)
Message-Id: <20130715120330.21e2a09099bf009db580ab9e@canb.auug.org.au>
In-Reply-To: <CA+55aFyfTJKRnsFHGxQ+-2+GVstMUj6t4f0q5-8wJMbN-Y93+g@mail.gmail.com>
References: <CA+55aFyfTJKRnsFHGxQ+-2+GVstMUj6t4f0q5-8wJMbN-Y93+g@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__15_Jul_2013_12_03_30_+1000_r9k_r7Emz6zeZ5jR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Jul_2013_12_03_30_+1000_r9k_r7Emz6zeZ5jR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 14 Jul 2013 16:57:23 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> This merge window was smaller in terms of number of commits than the
> 3.10 merge window, but we actually have more new lines. Most of that
> seems to be in staging - a full third of all changes by line-count is
> staging, and merging in Lustre is the bulk of that. Let's see how that
> all turns out, I have to say that we don't have a great track record
> on merging filesystems through staging.
>=20
> Ignoring the lustre merge, I think this really was a somewhat calmer
> merge window. We had a few trees with problems, and we have an
> on-going debate about stable patches that was triggered largely thanks
> to this merge window, so now we'll have something to discuss for the
> kernel summit. But on the whole, I suspect we might be starting to see
> the traditional summer slump (Australia notwithstanding).

As usual, the executive friendly graph is at
http://neuling.org/linux-next-size.html :-)

(No merge commits counted, next-20130701 was the linux-next based on v3.10)

Commits in v3.11-rc1 (relative to v3.10): 9494
Commits in next-20130701:		  8929
Commits with the same SHA1:		  7670
Commits with the same patch_id:		   759	(1)
Commits with the same subject line:	    55	(1)

(1) not counting those in the lines above.

So commits in -rc1 that were "in" next-20130701:	8484	89.4%
			(essentially unchanged from 89.3% last time)
Commits in -rc1 that were not in next-20120722:		1010	10.6%

Pretty good, but it would be still nice to figure out where the last lot
came from.  I have the "git log --oneline --no-walk" list if someone
wants them.

Some breakdown of that list:

Top ten first word of commit summary:

     80 btrfs
     41 arm
     35 [scsi]
     32 net
     28 drm/exynos
     25 perf
     25 drm/radeon/dpm
     19 vxlan
     17 input
     16 tracing

Top ten authors:

     56 Ben Skeggs <bskeggs@redhat.com>
     36 Alex Deucher <alexander.deucher@amd.com>
     27 Josef Bacik <jbacik@fusionio.com>
     24 Miao Xie <miaox@cn.fujitsu.com>
     16 J. Bruce Fields <bfields@redhat.com>
     16 Bart Van Assche <bvanassche@acm.org>
     13 Stephen Hemminger <stephen@networkplumber.org>
     12 Michael Ellerman <michael@ellerman.id.au>
     12 Al Viro <viro@zeniv.linux.org.uk>
     10 Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Top ten commiters:

    130 David S. Miller <davem@davemloft.net>
     81 Josef Bacik <jbacik@fusionio.com>
     68 Ben Skeggs <bskeggs@redhat.com>
     64 Linus Torvalds <torvalds@linux-foundation.org>
     39 Benjamin Herrenschmidt <benh@kernel.crashing.org>
     37 Alex Deucher <alexander.deucher@amd.com>
     35 James Bottomley <JBottomley@Parallels.com>
     24 Dave Airlie <airlied@redhat.com>
     23 Thomas Gleixner <tglx@linutronix.de>
     23 Arnaldo Carvalho de Melo <acme@redhat.com>

Quite a few of these could be bug fixes (especially DaveM's).

There are also 444 commits in next-20130701 that didn't make it into v3.11-=
rc1.

Top twelve first word of commit summary:

     66 arm
     37 mtd
     31 drm/i915
     11 rsxx
     10 ocfs2
      9 xen-blkback
      8 selinux
      7 kdb
      6 drbd
      6 cris
      6 clocksource
      6 acpi

Top ten authors:

     43 Andrew Morton <akpm@linux-foundation.org>
     28 Paul Gortmaker <paul.gortmaker@windriver.com>
     19 Sascha Hauer <s.hauer@pengutronix.de>
     18 Dave Chinner <dchinner@redhat.com>
     15 Alexander Shiyan <shc_work@mail.ru>
     12 Roger Pau Monne <roger.pau@citrix.com>
     12 Michal Simek <michal.simek@xilinx.com>
     11 Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
     10 Joern Engel <joern@logfs.org>
     10 Daniel Vetter <daniel.vetter@ffwll.ch>

Some of Andrew's patches are fixes for other patches in his tree (and
have been merged into those).  Paul's patches are the __cpuinit removal
series that should be applied right after -rc1.

Top ten commiters:

    184 Stephen Rothwell <sfr@canb.auug.org.au>
     39 Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
     36 Shawn Guo <shawn.guo@linaro.org>
     31 Daniel Vetter <daniel.vetter@ffwll.ch>
     18 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
     17 Michal Simek <michal.simek@xilinx.com>
     17 Jens Axboe <axboe@kernel.dk>
     14 Simon Horman <horms+renesas@verge.net.au>
     14 Joern Engel <joern@logfs.org>
     11 Rafael J. Wysocki <rafael.j.wysocki@intel.com>
=20
Well, that's embarrasing :-)  Those commits by me are from the quilt
series (including Andrew's mmotm tree).

Some of the above will have been merged into other patches or replaced, I
guess.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__15_Jul_2013_12_03_30_+1000_r9k_r7Emz6zeZ5jR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR41h2AAoJEECxmPOUX5FEV6oP/ihxRb0uQ4r/8wqxSrie+q2P
gYV3bKSa5Ri2YcYuoI8EoJfHifzfbGyG56/AgD8o2a8S0yRgXzBcrcbrsWoEfUrt
3Z27IUhWZGB45Iofiz/IAJsFlOsHcs8J4i7MMhNdsKBx2UMA9v50AaFO9R38pK9n
Kdtg4smfvzyjdPAJWiC175lVGuvgSZC6E/ab1Y64GWV8jUM/xRyuqzYPUcqozP22
G0CvhVnuNQjy/eaLKCbTXPybrjnYyYacSIrGJ3zYWAKHhhCMZT6Na+blfEc5vIdX
snJxsw3mghhG5HAVXeZg5iq5Cl1Y4xqwCJX9oh3xc24Z5DwAnMxHhAPHJ7nYe5ER
ks7krJgk/G82P3QPl/GQS28w/Nvq9qsIjJkT36gvumzXtzXTJq26hMq1lJkUNXA+
0H2maZ/XeOmhRPrAT88sTNmv70KWWnKI1pgqSFRKcojJwLur03yBKCZ6127lDxtn
BWExDjfNT4A6myXoaW6DIQuLvVszy9Xn91ALBowlhYiyaIpWoWNoe0IMFqH0ZUQU
6xcS5r5IRBUJX2fRLmDyct0F3bGvmI/Eh2fMM4dqgb3g9Yhkv/zGP3G13NfNpCRQ
Mqe3YxVEhbTqoWkoDdZ7TctPKwPY0ox0pMAulydbugLWTf8KNUUP97DxCH/dr4Ji
a1WeORPKTGCfMcF3FkeH
=Gt/R
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Jul_2013_12_03_30_+1000_r9k_r7Emz6zeZ5jR--
