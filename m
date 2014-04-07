Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaDGNfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:35:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbaDGNf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:35:29 -0400
Date: Mon, 7 Apr 2014 09:35:18 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PULL] please pull file locking changes for 3.15
Message-ID: <20140407093518.301f9844@tlielax.poochiereds.net>
In-Reply-To: <20140407222702.9773d7369c05918a6f16151f@canb.auug.org.au>
References: <20140331093120.10aeaba6@tlielax.poochiereds.net>
	<CA+55aFy_o-wDrbQSRnrThGqo8mcBS-pVXM6Kj0LqH8PzRr_0Kw@mail.gmail.com>
	<20140404205624.521f67d5@ipyr.poochiereds.net>
	<20140407113706.d213ca01fed70e3367611197@canb.auug.org.au>
	<20140407071130.672d7e8e@tlielax.poochiereds.net>
	<20140407222702.9773d7369c05918a6f16151f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/7jF.D9=SYjaLt4A/dP/9qL."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7jF.D9=SYjaLt4A/dP/9qL.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Apr 2014 22:27:02 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jeff,
>=20
> On Mon, 7 Apr 2014 07:11:30 -0400 Jeff Layton <jlayton@redhat.com> wrote:
> >
> > On Mon, 7 Apr 2014 11:37:06 +1000
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >=20
> > > On Fri, 4 Apr 2014 20:56:24 -0400 Jeff Layton <jlayton@redhat.com> wr=
ote:
> > > >
> > > > Thanks for the feedback and for pulling this in anyway. I'll make s=
ure
> > > > to do all of that on subsequent pull requests.
> > >=20
> > > Also, please don't rebase what you have in linux-next before sending =
it to
> > > Linus (without good reason).  Especially if you then leave the linux-=
next
> > > included branch as it was - since that may cause conflicts in my tree
> > > (and so I notice the rebase).
> >=20
> > I don't think I did that though, did I? Both the branches I had in this
> > case were based on 3.13-rc1.
>=20
> OK, so the base stayed the same, but you recommitted all the same patches
> (I didn't check to see if the commit messages changed) which due to some
> other change caused conflicts in linux-next today :-( Not really a
> biggie, but generally, you really shouldn't rewrite your commits just
> before sending them to Linus.
>=20
> > Now that Linus has pulled in the changes, am I OK to rebase the
> > branches (or do a pull)?
>=20
> At this point, you should just reset your next included branch to be in
> Linus' tree beyond where Linus merged your tree, then it will be
> effectively empty (unless you then add some more patches on top - but at
> this point those should only be fixes).
>=20

Ahh ok, I guess I *did* alter a commit message in my locks-3.15 branch
and didn't propagate that to my linux-next branch. That probably threw
off the commit IDs. The patches themselves should have been identical
though. Sorry about that!

In any case, I've gone ahead and reset my branch as you recommend and
linux-next branch and will be more careful about that in the future.

--=20
Jeff Layton <jlayton@redhat.com>

--Sig_/7jF.D9=SYjaLt4A/dP/9qL.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTQqmXAAoJEAAOaEEZVoIV+cwP+gI4rb9FnjyWKoEx4JYX9hSa
Ajo84fUDj+FCvxehWpx7E4UiAQgq0ZV/I64BfkvE0SgEZxayNMVBYxDwS/bExmBq
I+d6xollHWzVdPRJvFWJRSse1ljGAB7AqruZmct4Bi7ovY3Y4xXEi9dW0XKjgJgr
/ScrNIEtFAJBQ9mHZ1QepluLFgQU1f8oXgtlKswr8qus/Juy30VXdQ+5IcoUhjBN
0rl7LB+6VcS/SNA8buV7nsHyExj0qLoEqTkZXzJinFoC38ypK3JSSZveRRKpVyWw
9+aSGFBidY/ikSspyQJV5H6Z9QcGfZC0ukT6gXa1coBjGxTWyMzYBU6Q0eeHAhpi
poc9OEnXLDRb7nmJq3kDQcdGkoLa5I1z3hxUSNzFEiUgS3gZz2pCFRe2mXm3JIfi
BCJs055i7zfCNmliOO1ynLiNJO3R3HgPvTCrC2AkxJMj6ykqwkbc0sQYIqDEUwE5
iN2oSTGDgubP5QBuBqNZrxmLPX8hRsGC9EE9buUN/6y5dS1IQMj9tXy0e8h9EzWe
Pcnv+qxjaz6kLdEDaXIHfErEOW4retAKxf7IHLWvTIXzJtWhLCzu860GGn5JXx4F
LZca5XIF0bmLhiy3dPyY7DRnSVRIGl4+fZtaH3zsUAe2+O3sA4q1ZptQypOeQS9e
iu6bW4HfmFjTWjjz+YSj
=Xxpg
-----END PGP SIGNATURE-----

--Sig_/7jF.D9=SYjaLt4A/dP/9qL.--
