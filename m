Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919Ab3GPXkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:40:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49570 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933573Ab3GPXkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:40:19 -0400
Message-ID: <1374018009.3225.123.camel@fourier>
Subject: Re: [ 3.8.y.z extended stable ] Patch "memcg, kmem: fix reference
 count handling on the error path" has been added to staging queue
From: Kamal Mostafa <kamal@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel-team@lists.ubuntu.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Jul 2013 16:40:09 -0700
In-Reply-To: <20130716160658.fc30d70b5230aab5b3b3950b@linux-foundation.org>
References: <1374015242-28112-1-git-send-email-kamal@canonical.com>
	 <20130716160658.fc30d70b5230aab5b3b3950b@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-LLB2LZJ2RScBi2zfmyD5"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LLB2LZJ2RScBi2zfmyD5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-07-16 at 16:06 -0700, Andrew Morton wrote:
> On Tue, 16 Jul 2013 15:54:02 -0700 Kamal Mostafa <kamal@canonical.com> wr=
ote:
>=20
> > This is a note to let you know that I have just added a patch titled
> >=20
> >     memcg, kmem: fix reference count handling on the error path
> >=20
> > to the linux-3.8.y-queue branch of the 3.8.y.z extended stable tree=20
> > which can be found at:
>=20
> hm, why.

Because it said "Cc: <stable@vger.kernel.org> [3.8]", making me think
the author specifically wanted it to be applied to 3.8-stable.

>[...]
> Note to stable tree maintainers: I carefully evaluate every patch I
> handle to decide whether or not it should be backported.  Every single
> one.

Might you consider stripping off the "Cc: stable [3.8]" line when you
add your SOB, in such a case?

> Hence if you decide to backport a patch which I merged, you are
> overriding an earlier decision of mine.

I'm happy to defer to your judgment here.  I've dropped it from the
linux-3.8.y-queue.

> Now, I will freely admit that I may have made a mistake.  But please be
> aware that you are taking a path which I have already considered and
> rejected.  So a little extra care is warranted for akpm patches, please.

I'll try to watch out for them.

Thanks Andrew,

 -Kamal


--=-LLB2LZJ2RScBi2zfmyD5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJR5dnZAAoJEHqwmdxYrXhZFkYP/07GsNrD9sN76/YrlM+J3Uk4
8bAKgXmXERybCzFtxlQnIjgV3lUr9/nW1RKPPOn2nwE08nql2YGlcQMfyuqgv3nZ
kq4ULoJFM6XlhDQLSb/5V98N0oeotA4ZufLtaTw2O7mprfMbOKuQzsm9desKx4R8
bK9+nDGTG6hKXMpjTYEbga67Ooc2xDoSgy0IYQ8wfoSn5qIcJLcn/n9xnKNxKHqQ
ZCuXBgbdBqPy/dZVzWCHxQvr1A1GQg9B5+Hf2/7cHTVjxCINPmT+7JJa51UyWDIH
vxznDAvWtHywHsR2bH/74RB0cJb/ofBbGka+fzln1Y8HoIYJ4/z5r9YyUzUbF2yX
aLCWLaMgI3AZUbajqrQhdwcdjFazHkVLaZHOUzHH6gfTrFgPFNX7iEpPxsDqB7gS
KtIDdTBIbmSWLurAm+IfSwIMQ+OkjK/5eJGEXDQ+A04jbev1ehKajWNOD4Ep4Q6t
i9XICHEtj/VfaXcybooTHUfUSvfSC0jwbITVgnp5GP6OIUugchH+lVUzjpngnf6e
H70xuebBtMZtbYj0GVEjW2Frcv6ExILtiY1gPA0FuZqhe2q9isvDWB6ppWU984kl
tQhhB9oRjgW1Xol/6jY1PoKPVorUHEfby/F7ObuEgMTzQll9KNjVYb2zNaWjYCA8
My6Im1W6u/m782a1svJr
=UOdw
-----END PGP SIGNATURE-----

--=-LLB2LZJ2RScBi2zfmyD5--

