Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3KYAKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 19:10:19 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48218 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3KYAKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 19:10:15 -0500
Date: Mon, 25 Nov 2013 11:10:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: linux-next stats (Was: Linux 3.13-rc1 is out)
Message-Id: <20131125111005.e85b207a474ef992c385c8df@canb.auug.org.au>
In-Reply-To: <CA+55aFxK5hkhteiL5cyPtHX5reup6aOiHQTCDKKdBsHiWsroGA@mail.gmail.com>
References: <CA+55aFxK5hkhteiL5cyPtHX5reup6aOiHQTCDKKdBsHiWsroGA@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Nov_2013_11_10_05_+1100_fYoGDdes67=4Rhs4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Nov_2013_11_10_05_+1100_fYoGDdes67=4Rhs4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Nov 2013 12:36:37 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> Talking about mistakes... I suspect it was a mistake to have that
> extra week before the merge window opened, and I probably should just
> have done a 3.12-rc8 instead. Because the linux-next statistics look
> suspicious, and we had extra stuff show up there not just in that
> first week. Clearly people took that "let's have an extra week of
> merge window" and extrapolated it a bit too much. Oh, well. Live and
> learn.

As usual, the executive friendly graph is at
http://neuling.org/linux-next-size.html :-)

(No merge commits counted, next-20131105 was the linux-next based on v3.12)

Commits in v3.13-rc1 (relative to v3.12): 10518		(v3.12-rc11:	9474)
Commits in next-20131105:		   9029		(next-20130903:	8891)
Commits with the same SHA1:		   7979		(		7991)
Commits with the same patch_id:		    621	(1)	(		 472)
Commits with the same subject line:	     70	(1)	(		  70)

(1) not counting those in the lines above.

So commits in -rc1 that were in next-20131105:	8670	82.4%	(8533	90.1%)
Commits in -rc1 that were not in next-20131105:	1848	17.6%	( 941	 9.9%)

So worse than last time, probably because of the 1 week delay.

[Aside: if I use next-20131111 as a base (when Linus' starting doing
merges in earnest), the stats look like this:

Commits in next-20131111:		   9906
Commits with the same SHA1:		   9156
Commits with the same patch_id:		    354	(1)
Commits with the same subject line:	     41	(1)

So commits in -rc1 that were in next-20131111:	9551	90.8%
Commits in -rc1 that were not in next-20131105:	 967	 9.2%

So, much more in line with previous releases.
]

Some breakdown of the list of extra commits (relative to next-20131105)
in -rc1:

Top ten first word of commit summary:

    337 drm
    115 btrfs
     83 perf
     68 alsa
     50 asoc
     49 arm
     46 net
     31 powerpc
     27 netfilter
     27 acpi

Top ten authors:

     66 Ben Skeggs <bskeggs@redhat.com>
     63 Takashi Iwai <tiwai@suse.de>
     63 Al Viro <viro@zeniv.linux.org.uk>
     46 Alex Deucher <alexander.deucher@amd.com>
     39 Ben Widawsky <benjamin.widawsky@intel.com>
     33 Josef Bacik <jbacik@fusionio.com>
     31 Johannes Berg <johannes.berg@intel.com>
     29 J. Bruce Fields <bfields@redhat.com>
     29 Dan Carpenter <dan.carpenter@oracle.com>
     27 Peter Zijlstra <peterz@infradead.org>

Top ten commiters:

    195 David S. Miller <davem@davemloft.net>
    117 Chris Mason <chris.mason@fusionio.com>
     95 Daniel Vetter <daniel.vetter@ffwll.ch>
     94 Al Viro <viro@zeniv.linux.org.uk>
     86 Ben Skeggs <bskeggs@redhat.com>
     82 Arnaldo Carvalho de Melo <acme@redhat.com>
     74 Alex Deucher <alexander.deucher@amd.com>
     69 Takashi Iwai <tiwai@suse.de>
     53 Dave Airlie <airlied@redhat.com>
     52 Mark Brown <broonie@linaro.org>

There are also 358 commits in next-20131105 that didn't make it into
v3.13-rc1.

Top ten first word of commit summary:

     51 arm
     40 crypto
     21 block
     11 x86
     11 ocfs2
     11 dm
     10 ceph
     10 bluetooth
      9 iov_iter
      9 9p

Top ten authors:

     27 Kent Overstreet <kmo@daterainc.com>
     22 Dave Kleikamp <dave.kleikamp@oracle.com>
     19 Andrew Morton <akpm@linux-foundation.org>
      9 Zach Brown <zab@zabbo.net>
      9 Denis Carikli <denis@eukrea.com>
      8 Geyslan G. Bem <geyslan@gmail.com>
      7 Sachin Kamat <sachin.kamat@linaro.org>
      7 Kees Cook <keescook@chromium.org>
      7 Alex Porosanu <alexandru.porosanu@freescale.com>
      6 Yan, Zheng <zheng.z.yan@intel.com>

Some of Andrew's patches are fixes for other patches in his tree (and
have been merged into those).

Top ten commiters:

     93 Stephen Rothwell <sfr@canb.auug.org.au>
     48 Herbert Xu <herbert@gondor.apana.org.au>
     33 Dave Kleikamp <dave.kleikamp@oracle.com>
     30 Jens Axboe <axboe@kernel.dk>
     27 Shawn Guo <shawn.guo@linaro.org>
     17 Kukjin Kim <kgene.kim@samsung.com>
     11 Mauro Carvalho Chehab <m.chehab@samsung.com>
     10 Jason Wessel <jason.wessel@windriver.com>
      9 Sage Weil <sage@inktank.com>
      9 Eric Van Hensbergen <ericvh@gmail.com>

Those commits by me are from the quilt series (mainly Andrew's mmotm
tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__25_Nov_2013_11_10_05_+1100_fYoGDdes67=4Rhs4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSkpVhAAoJEMDTa8Ir7ZwVg/gP/3rtMMCoQdFm6q15I4kR4kAR
uO62Hsgw7OTzTBEuPD/Jj3kv+fHjRkQa06QqVsxwPICib5iPZRDNZ2N6I+WfnUb7
Nh+1ud4ANw6M/aF5MKkZi71ZTd9b3X+OJZgBLwh5tDR7wzu+rDvXML4MihbtLrR2
k04rHgiZrSlySkEQq4y234KVV3uC5hAqezBtC7Lb/YIgca31LElFtItqF1LFKlSQ
BwE4cQuWR8ze/PLtLF5dSU5pJiNKgfwNpqk0Im+wmfrTlkYiSlUCcDS/NF1UIDAj
KkI5ntjVtOKt8RFjdKtfvBDc2B6jSjtHmh9ZETM58fI7y6+9yEVNlqan3ZRFgofe
1sblesdIQm7NSe5ARLHkX46oBIZn8ndEEfoUzVy6VImBcrwBhf7LzNJXfMNzcrTT
eP6WyonMgX6OqJt3Y1N2RXuiDjGDDPMJbZNzMbBflqD0fcL55hQYqrUDEeIliQ5b
SxKPdYFXBqRwTY/2UB112TNfIood/iY/LoWSqIhjpbRTH7DggRWzGya6UFjCeTym
Hm6jjqRbaZVq2gpKN2RXajO9CuXOVimjPjw4EyrPzMQurpwKgOsucu2fGwRnUhSH
bf+TEHnA2jq39nMY2DLGrvN499TfUrX1jA6P7VAYXoGk49FnJJpm5jMThRenpQSu
vBd1o7PNsRcYaoqfDCnR
=CzyK
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Nov_2013_11_10_05_+1100_fYoGDdes67=4Rhs4--
