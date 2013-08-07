Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab3HGFix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:38:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51820 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab3HGFiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:38:51 -0400
Date: Wed, 7 Aug 2013 15:38:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-Id: <20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au>
In-Reply-To: <CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com>
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
	<CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Aug_2013_15_38_40_+1000_uZNqUh7Ifr3Z1eIs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Aug_2013_15_38_40_+1000_uZNqUh7Ifr3Z1eIs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Wed, 7 Aug 2013 07:16:57 +0200 Sedat Dilek
<sedat.dilek@gmail.com> wrote:
>
> On Mon, Jul 29, 2013 at 3:08 AM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> >
> > After merging the ext4 tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > fs/ext4/ialloc.c: In function '__ext4_new_inode':
> > fs/ext4/ialloc.c:817:1: warning: label 'next_ino' defined but not used =
[-Wunused-label]
> >  next_ino:
> >  ^
> > fs/ext4/ialloc.c:792:4: error: label 'next_inode' used but not defined
> >     goto next_inode;
> >     ^
> >
> > Hmm ...
> >
> > Caused by commit 4a8603ef197a ("ext4: avoid reusing recently deleted
> > inodes in no journal mode").
> >
> > I have used the ext4 tree from next-20130726 for today.
>=20
> Since this message ext4-tree was not updated.
> The commit "ext4: avoid reusing recently deleted inodes in no journal
> mode" was refreshed and has a different commit-id.
> Did you test with this one? You still see the breakage?

Today's linux-next does not have this build failure.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__7_Aug_2013_15_38_40_+1000_uZNqUh7Ifr3Z1eIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSAd1oAAoJEECxmPOUX5FEgjwP/1Fl6E2QZTw7vB6OPCE1A/hO
ZgaS18FrP08XV4aB1V6s1nH6F7va6qJoIUZW1XCqJWCkhn3qadeDblq+WDV44aed
FTPiu6zKvbC9IR4+UFI1azUXwQ8FVSG6sy0yXX03fM57bMo1msa7r4b7H0JUacyA
uJzYZfBtmX2fLED5JDw+YyWv6jV4AzY+NzSaJRNooQ8o+Hq0s6MJ7uLSDpczm1Us
v1DhzOleWMcGJRvH3W9JghDy+Df0ekTK6S413YXx1k0LqIIUqTiWEp5/B4aWjxCj
5bHdAoop8PZjPnTUF0YoXsoMa45wZrFlO9PItgPfsHJz3nYSNjP1LNdWGWM90A6A
e/A7dgKS7C8IEsd/ez894aOcx9LjwlAj3S88GftO2/fDZsIwt5hNbIE/Yt+AYuNT
mDVvmenPnrISGrQHcuJbJkdg8T153oGiUG9X4RvF6NryXMQX5djSOP9PxXT006Y9
iDD+uByQbWrWkRfpPKCr28CW0xfvclv4DAhMU+bgG+JjSHdprVALJbVpt6hc1+Xm
XE5GizSF8SlJZ71vFwy3W2q3jNWd47pnN3LjUWqaZ7nfKbOj8j9OPwpjynViBo1y
m9LORm7b4BNu/kfKrjHlJVyrFsmNuz7uZL91dxI1YZeAf+8aQ17oaRQW53Wv9Bny
KTO78AqDMnp43n0WngtF
=qDJU
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Aug_2013_15_38_40_+1000_uZNqUh7Ifr3Z1eIs--
