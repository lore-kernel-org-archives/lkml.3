Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3FCB3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 21:29:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34304 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3FCB3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 21:29:06 -0400
Date: Mon, 3 Jun 2013 11:28:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Lennox Wu <lennox.wu@gmail.com>, linux-c6x-dev@linux-c6x.org,
        Cris <linux-cris-kernel@axis.com>, linux@openrisc.net,
        =?UTF-8?B?SMOldmFyZA==?= Skinnemoen <hskinnemoen@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: Exotic architecture fixes
Message-Id: <20130603112859.7a5ad3a2129493c8c5cd0a48@canb.auug.org.au>
In-Reply-To: <CAMuHMdV5t3BGNYNzCyEH-dYikAtEr2A+BckPi9QtgAUEJDMM0w@mail.gmail.com>
References: <CAMuHMdV8gJew_x1+L3O51sB=JU_EvJ-Y05JxKSsXUi+B43HAJA@mail.gmail.com>
	<CAMuHMdXQZcanJLGG8bs7u1CRb2z00Ho-kv4s5044pDDeUvoKeQ@mail.gmail.com>
	<CAMuHMdV5t3BGNYNzCyEH-dYikAtEr2A+BckPi9QtgAUEJDMM0w@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Jun_2013_11_28_59_+1000_Rothgx6Av6bR+fmf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Jun_2013_11_28_59_+1000_Rothgx6Av6bR+fmf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

[Chen Liqin <liqin.chen@sunplusct.com> removed from cc as that domain
appears to not work :-(]

On Sun, 2 Jun 2013 21:39:38 +0200 Geert Uytterhoeven <geert@linux-m68k.org>=
 wrote:
>
> On Tue, May 28, 2013 at 11:38 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On Thu, May 23, 2013 at 10:09 PM, Geert Uytterhoeven
> > <geert@linux-m68k.org> wrote:
> >> I created a branch where I collected several exotic architecture fixes
> >> (and a few
> >> other trivial fixes):
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git e=
xotic-arch-fixes
> >>
> >> Several of these have been ack'ed (cfr. *-indicators below).
> >> If you reject any of the commits, please scream.
> >> If you want to take any of them yourself, please do so.
> >>
> >> I intend to merge this into my for-next branch after the release of v3=
.10-rc4,
> >> and ask Linus to pull after the release of v3.10-rc5.
>=20
> I merged this in the for-next branch of my repo.

Surely, your for-linus branch would have been a better choice.  And then
maybe merge that into your for-next branch if you really needed these
fixes to continue with m68k work?

> >> Geert Uytterhoeven (32):
> >>       cris: Switch cris to drivers/Kconfig
> >
> > JFYI, this has a trivial conflict with "CRIS: drop unused Kconfig symbo=
ls"
> > in -next.
>=20
> Stephen: cris/for-next and m68k/for-next removed two different hunks from
> arch/cris/arch-v32/drivers/Kconfig. To resolve the conflict, just remove =
both.
> Thanks!

Thanks, fixed it up.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__3_Jun_2013_11_28_59_+1000_Rothgx6Av6bR+fmf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRq/FbAAoJEECxmPOUX5FEtxQQAI8X+9OIaasx7OWNJuXtpjd+
qpOrsfcJZhDsjH6tiHsd846w3hJabsklQBNNnUv/eiYgcWMIOsonf8KwW4EwC/R8
e82ad/vpzZszxuW4oc6164UpRiRxvNQZIavClXgteXapyfNLGJltFnluCiDqUSOr
xay4VTYsemS9CMMFpalLf5PYcz3RKS+DDF7jurXfc53w8ommiALXhVMtI9OHebce
MatRh5nFgNnJ5EU1udTCJ9adWYOq/h1/n1GSujoWIqE5S6169st575Cc7LIlN335
u6Trd9IWBomjzT/DyCzW8vfbUzB+QMxKNJNPvg60QwGj4LmC6yVgtvChQJagcF31
lbHlLfKdtA40U24anbO0zp2OckchpWV8HhOtaTGLP3d2KKf4kBHKHBdhH0yzehL1
2ieHJuNwZ+b1xw1+VYhVGuZ/7+KMEqD2k+T63EkHhp21oQLAQj5fXCnGNhX7H3pj
EjIIFObwfwTdR8Pacf9vbj3vudXNi8hhJKNG5fuSLtQ5ydRQlYCbigSYKQVYPhVI
R+jWVOxJhp0737UuQ9sXnBEMHjsykhvC8aUf4eZj3ubqrsQVEkxaqbgcNtMOWe7z
fSsxe3aVAzIh9d0yXSkcL1Xc62AJa1P8qgcK+9nKEBpGr6/drf09Kkiw3Z4+SE6/
hcZC35aJt05CsFdw7XRR
=exnr
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Jun_2013_11_28_59_+1000_Rothgx6Av6bR+fmf--
