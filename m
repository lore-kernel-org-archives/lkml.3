Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3GHEjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 00:39:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41688 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3GHEjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 00:39:52 -0400
Date: Mon, 8 Jul 2013 14:39:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>
Cc: Steve Capper <steve.capper@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Jul 3
Message-Id: <20130708143947.d17036df40fdce8d9e90efb4@canb.auug.org.au>
In-Reply-To: <20130703144802.GA32130@logfs.org>
References: <20130703180620.6919bf7d7f13f7ed21046c68@canb.auug.org.au>
	<20130703112539.GA32584@linaro.org>
	<20130703144802.GA32130@logfs.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Jul_2013_14_39_47_+1000_XXZzuIKORn1P1PXa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Jul_2013_14_39_47_+1000_XXZzuIKORn1P1PXa
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi J=C3=B6rn,

On Wed, 3 Jul 2013 10:48:03 -0400 J=C3=B6rn Engel <joern@logfs.org> wrote:
>
> On Wed, 3 July 2013 12:25:41 +0100, Steve Capper wrote:
> >=20
> > Today's linux-next appears to introduce some BUGs when running the libh=
ugetlbfs
> > testsuite (under both ARM64 and x86_64):
> >=20
> > [   94.320661] BUG: Bad rss-counter state mm:ffff880119461040 idx:1 val=
:-512
> > [   94.330346] BUG: Bad rss-counter state mm:ffff880119460680 idx:1 val=
:-2560
> > [   94.341746] BUG: Bad rss-counter state mm:ffff880119460d00 idx:1 val=
:-512
> > [   94.347518] BUG: Bad rss-counter state mm:ffff880119460d00 idx:1 val=
:-512
> > [   94.415203] BUG: Bad rss-counter state mm:ffff8801194f9040 idx:1 val=
:-1024
> >=20
> > I've bisected this to commit:
> > commit 446313e3e4e7274c4d1e449d107fab6c041ec59c
> > hugetlb: properly account rss
> >=20
> > The bad counter values I get are all negative.
> >=20
> > To reproduce this, just run through the latest libhugetlbfs test suite,=
 these
> > warnings appear pretty much immediately. (I set aside 200 huge pages fi=
rst):
> > http://libhugetlbfs.sourceforge.net/
> >=20
> > Reverting this commit allows the test suite to run without problems.
>=20
> Thank you, I will have a look.  For the interim, dropping this patch
> from -mm seems the best approach.

OK, I have dropped that from the akpm tree in linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__8_Jul_2013_14_39_47_+1000_XXZzuIKORn1P1PXa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR2kKTAAoJEECxmPOUX5FEpjEQAI+xUurd9vfy6TqiwQIMeF3M
aenRScugcnXaXgmktAROh+3OUImDmDhhCe6ckS8CJQR5S2SBQRG1PFEYBUDoLB/l
466Zq6GyVzF4b/utxr8J2WaxvvZFFjQGJTNlVgFNJVfSqtV19FbpUxRh4kYum3Ke
zd+KhdiJuB5BiNgiRMLFm+O04+7IkTZVp8c430XkN7ZUyvGzZtzQpoQMq00F1xq4
s6qUXHAw8HIW4zKEAboG5bbNx3Mm1QyAMj6s4XDEZKSsfyFJVIinwuY81ypP0lr6
b6aiEaa4E6SKn0qiPG7aqrZeyo9rrvolAqjnrEQ4vQzEkkEiMeAIaxRh7ebmcMGm
Uxv7HSSPNaDLMV2In/wqc7QMmgk1N02QYkO4uXw6p+TfBu3XLH1xFWNp0gC40c/I
7I4lQ2MJ1+0I7pU8Wo7K9Nut43FNa9Br1xVPk/CQBc3kx8Lb3U8MlK7KQiqH0LHz
v1xqgStToRoB1bi/UO+onDtzKL79+C8URhUGJny4W54eIUcQzwEg/aGVP+8IX3cn
nICOesdifPn+joTDQWKHxPBojfAHYjPe+Vy4P2aYETRilLK/LTJitdODoEl9YySU
4MjKZWZlmCl6cWXwWcSsmBhSUJx/rn29BOIy2vPzjB3+WHktnxoGt7w5sqSFZWBf
r7cE4AVQadvVNhTNKUwi
=Pikc
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Jul_2013_14_39_47_+1000_XXZzuIKORn1P1PXa--
