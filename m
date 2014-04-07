Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbaDGLLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbaDGLLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:11:45 -0400
Date: Mon, 7 Apr 2014 07:11:30 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PULL] please pull file locking changes for 3.15
Message-ID: <20140407071130.672d7e8e@tlielax.poochiereds.net>
In-Reply-To: <20140407113706.d213ca01fed70e3367611197@canb.auug.org.au>
References: <20140331093120.10aeaba6@tlielax.poochiereds.net>
	<CA+55aFy_o-wDrbQSRnrThGqo8mcBS-pVXM6Kj0LqH8PzRr_0Kw@mail.gmail.com>
	<20140404205624.521f67d5@ipyr.poochiereds.net>
	<20140407113706.d213ca01fed70e3367611197@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/3Q_Sm3WQBFq3Nfk92Flx7./"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3Q_Sm3WQBFq3Nfk92Flx7./
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Apr 2014 11:37:06 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jeff,
>=20
> On Fri, 4 Apr 2014 20:56:24 -0400 Jeff Layton <jlayton@redhat.com> wrote:
> >
> > Thanks for the feedback and for pulling this in anyway. I'll make sure
> > to do all of that on subsequent pull requests.
>=20
> Also, please don't rebase what you have in linux-next before sending it to
> Linus (without good reason).  Especially if you then leave the linux-next
> included branch as it was - since that may cause conflicts in my tree
> (and so I notice the rebase).
>=20

I don't think I did that though, did I? Both the branches I had in this
case were based on 3.13-rc1.

Now that Linus has pulled in the changes, am I OK to rebase the
branches (or do a pull)?

--=20
Jeff Layton <jlayton@redhat.com>

--Sig_/3Q_Sm3WQBFq3Nfk92Flx7./
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTQofiAAoJEAAOaEEZVoIVjwoP/i3yPrrZBHWLE8b88jVMH6mK
P/TcNCmzp9YA0ejdDZmoZdRgUhek87jMcBXizAo1MRVvfMtn40cScXiXRbsoY2Q7
e29I6c26IXV3ITeNePP5Xm9K77EIqaG0WCE5zaDcVhccNmfS6XVmxVgcGg8F1TuM
C1GxhcOJJQ9SqU7tnjBrQ9k+2sQnfIEBaAf/m7IyL2cm9lGidbDYmJKohplHZRhj
v/oFpxDAKkBTjLuDNFO5sNKrAOgyq2Jbbqrg5EljvtgUfl5ZY+1Wq0lzzcArjdQA
7PQULYaH10nEsyImmN0O5tkt7Pm0Lph2fAiQEjSuWoXdzq26Pb9yKQu8AjxFW4De
16X7sM2At37JL19izYwO6JIuo0xHZkqr2nUjDIYTUcZGo3sLdIGqFPj6vQO6cpdu
3kSV+stz+8zQUuET2gshJOl7yy5ZCRC1iClE3RYabCMOMB8SdTgq+Eqc6xKUu3W+
9+LojVgBraH4HT04uIvSyvaJz0akcfl6IwqeAhhkQBidNDdrk7rOESlEqlqbHayF
6kHD5vCd2ev+UAlyC8Vv7g3hC7tz22Ji74NR6L1BOuzmDpwrBc/jUrBGXKNJYhzU
2F4aT+XPetStZefBj/n/ngnFyXZbYJrTmrj9ZfHung+tfswhAwuBz5BT1uT/cGt8
RvP+A+mWzGkQMMoBC3eK
=/WkN
-----END PGP SIGNATURE-----

--Sig_/3Q_Sm3WQBFq3Nfk92Flx7./--
