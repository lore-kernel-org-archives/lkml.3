Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaAUXuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:50:51 -0500
Received: from ozlabs.org ([203.10.76.45]:42179 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbaAUXus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:50:48 -0500
Date: Wed, 22 Jan 2014 10:50:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH] preempt: Debug for possible missed preemption
 checks
Message-Id: <20140122105040.f5e19a91b4a7277d2495547e@canb.auug.org.au>
In-Reply-To: <20140118200822.5d41ffce@gandalf.local.home>
References: <20140116235751.084728c8@gandalf.local.home>
	<20140116211214.581197e5.akpm@linux-foundation.org>
	<20140118184401.48b32cb3@gandalf.local.home>
	<20140119115253.d6974d9c188c6d9e88d04b80@canb.auug.org.au>
	<20140118200822.5d41ffce@gandalf.local.home>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_Jan_2014_10_50_40_+1100_H5vaabw4oRzS+tPa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Jan_2014_10_50_40_+1100_H5vaabw4oRzS+tPa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Sat, 18 Jan 2014 20:08:22 -0500 Steven Rostedt <rostedt@goodmis.org> wro=
te:
>
> On Sun, 19 Jan 2014 11:52:53 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > Given that the merge window will probably open today or tomorrow, I wou=
ld
> > prefer any new code not intended for 3.14 not be added to linux-next
> > until after v3.14-rc1 to avoid unneeded conflicts.  If, however, Andrew
> > thinks it is still worth the (maybe minimal) pain, then fine.
>=20
> I'm not sure this is even intended for 3.15 either ;-)
>=20
> I'm fine with waiting, to keep from adding any extra pain just before a
> merge window. I guess the question is, is it OK to keep it in
> linux-next for 3.15 even though it may not even go into 3.15?  Depends
> on how useful it proves to be. Perhaps it may require staying in
> linux-next till 3.16.

If it is smallish and doesn't interact with much other stuff, then that
is fine, I guess (I haven't looked at what you are discussing).

It just becomes a pain if it causes non trivial conflicts with real
development (or worse runtime problems for testers).

> Perhaps in order to keep merge windows from being an issue, I can add it
> at each -rc1, and remove it at -rc6, if it didn't catch any bugs. But as
> soon as it does catch a bug, we can say it's worth going into mainline.

As long as its interactions with other code are minor, it is better for
it to stay in once added.  Mainly because part of Andrew's patch queue
sits on top of linux-next, so removing something from linux-next may
cause interesting conflicts in that part.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__22_Jan_2014_10_50_40_+1100_H5vaabw4oRzS+tPa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3wfWAAoJEMDTa8Ir7ZwVnnoP/2l7CP2SCutfmTC1h/7pDxlV
MdviCYNBr00IVr0aa93sGXP8qJn5GcuXFTsxjYObjE63QwroBWSslWnZ3vY6Yizk
LuK1qsiaFQuu8Ad8+lsL66T59MPTXKzjVa1J5wlmOKcL6kfsScIIY+N55FuQXc3e
0zkqzGdGpwGT7lvohZcXW8ETXXRyK05fyzOIKt6MHFjr2MZNaHDvMB2qils9Y5mt
EjEt5qwCqFXuFd9d7fIW0gdNE+cEn2/UI8KLZESV4foxBuO4Qv4qUCcasefir6F4
GoECF7DOmt4OtTdXTs5cg+XNoA+au+rCKdKqB9Jv5W3KVIFFwyf43Vod0poKv6Vo
Mu4uyhID1XWenbxO9VDdHx+zWkfIdmtdczDYEdGQrZmgcC1hi8C5tbd+Z8hxxq2W
1l8QUk8bKfI3galu5I1Ca24BSMTtD35lCLImFbcwtgn9xANhWDyC/h2cBrAZ00gi
AMHj8BeG8Ox4mNXPF++KIBVuzGJGpBBwjMdgaCOm1lK9tvlL7eD8jyiCYXqcd6EO
U3Mv0WzoUBSE2Jc4rECCeb5/PfLF6jHHFBuNPn4kDt9QPt0w9UqItQ3aHj8bZQVg
IP6UaDkcA+5GtvVK3+G8uWZ65u4I9TZ3Mn6I+EUGs1mL0JheLTCDk77dQwrEnQZo
t92bjfIdlpMir7xWOetz
=p6UY
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Jan_2014_10_50_40_+1100_H5vaabw4oRzS+tPa--
