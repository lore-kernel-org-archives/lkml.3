Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbbAGUwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:52:23 -0500
Received: from ozlabs.org ([103.22.144.67]:59948 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbbAGUwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:52:09 -0500
Date: Thu, 8 Jan 2015 07:52:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Missing next-$date git-tag when pulled-in linux-next.git on top
 of linus.git
Message-ID: <20150108075201.042f9126@canb.auug.org.au>
In-Reply-To: <CA+icZUVYu2uaAG-sSf5pf_rzGU+BSBAwu9mhBDrCXZ0a2nw1sA@mail.gmail.com>
References: <CA+icZUVVPe68VGwRcc5ztxGwHi83wHJVeiJMUuBynm2LypoaZA@mail.gmail.com>
	<20150107212439.7254d389@canb.auug.org.au>
	<CA+icZUVYu2uaAG-sSf5pf_rzGU+BSBAwu9mhBDrCXZ0a2nw1sA@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5vDmxIEJvhYz0a2s7ZYJ=Fi"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5vDmxIEJvhYz0a2s7ZYJ=Fi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Wed, 7 Jan 2015 14:47:53 +0100 Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Wed, Jan 7, 2015 at 11:24 AM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> > Hi Sedat,
> >
> > On Wed, 7 Jan 2015 09:24:57 +0100 Sedat Dilek <sedat.dilek@gmail.com> w=
rote:
> >>
> >> My workflow looks like this
> >>
> >> # Get mainline Git tree
> >> $ git clone $LINUS_GIT_URL
> >>
> >> # Checkout latest mainline (rc) tag (aka -next's "origin" commit-id)
> >> $ git checkout -b Linux-v3.19-rc3 v3.19-rc3
> >>
> >> # Base to pull in current -next
> >> $ git checkout -b Linux-next-20150107
> >>
> >> # Pull in stuff from next-20150107
> >> $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-ne=
xt.git
> >> tags/next-20150107
> >
> > Just do
> >
> > $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-nex=
t.git master
> >
> > That should also fetch the next- tag.
>=20
> For current -next this is OK.
> Sometimes I needed to test against a specific next-version.
> Any idea?

$ git clone <Linus' tree> next
$ cd next
$ git fetch <Next URL> next-xxxxxxxx
$ git checkout -b Linux-next-xxxxxxxx next-xxxxxxxx

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/5vDmxIEJvhYz0a2s7ZYJ=Fi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUrZx3AAoJEMDTa8Ir7ZwVeFsP/3zYLFnH+qQZWTR/xKhI8WIC
vyhYJVdKBg1JxUv68+jUtgXgJTmpKs047m/36Yu/8apJLbcbUnv1+h++KnWmq5Sb
sEwa5LCXtzYPABvGPraK+H8issl5XG8poqFgsSFvkGwHuGprK8leFud80nmSgzZh
LNTCExF1fqU/miBQKFoh4OZz+RSmGhZ2Z8UJJvSTXOr/svYRzWEUTtY9wkBG8usf
aHkwXoavaOPsuk3dDfzwFIvSbFJnIttmnQ1DCFfbw448lv5VwpGM+6ais/FEpr9t
z1UZW5zWdOIEPmliEjnRx4pq+21oQRv7jJIxTP6UAvmTfEs0ba7KbNGbSZJG49zN
ZCwUECYHPODUTmknymHt7fMakioMzrm84O9be3XuTYwdOQZkFjelp8UPDmzkpW/1
YohzUfmtvcXSD5DaiRAf1ZOcs0KSdpSkgNwrePXXA5mh4EkMRcWvr0o24qTNIJLv
jOZfcrS9+pGJF/uDHx0Vw3bSF5k69bs3hnhSXj0hK5yy3vC/21glJ9+74bSkrYaE
7uT5Tk/U4Ve5Pwl+9yEX3b9OrV+NZhMYyipF767VrvkIWT4xrgWDbVicd9dM4UiN
mSsvR3mm/lvLfiLUQsdwphM1fBUbPoe58AKqoO7MfX2s2T+DYGeErKN9uG2eZzFa
qGSdJZ9KM1VVZIDsQsD6
=xhEN
-----END PGP SIGNATURE-----

--Sig_/5vDmxIEJvhYz0a2s7ZYJ=Fi--
