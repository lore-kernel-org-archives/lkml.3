Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab3EHBK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 21:10:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56270 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3EHBK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 21:10:26 -0400
Date: Wed, 8 May 2013 11:10:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Hogan <james.hogan@imgtec.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] linkage.h: fix build breakage due to symbol prefix
 handling
Message-Id: <20130508111010.f487f60728b8861936ccf57d@canb.auug.org.au>
In-Reply-To: <87a9o8r80u.fsf@rustcorp.com.au>
References: <1367442257-7897-1-git-send-email-james.hogan@imgtec.com>
	<878v3yql7r.fsf@rustcorp.com.au>
	<20130502133737.c2874e483bdc1380a59786f4@canb.auug.org.au>
	<20130502153035.03afb3f75d9bfd4693319e8c@canb.auug.org.au>
	<87a9o8r80u.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__8_May_2013_11_10_10_+1000_W.B17ZkySEvb0.R6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_May_2013_11_10_10_+1000_W.B17ZkySEvb0.R6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Mon, 06 May 2013 14:59:05 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
> > Version from today's merge fix.  Rusty, you should show this to Linus
> > when you ask him to merge your modules tree (assuming it looks right :-=
)).
> >
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Thu, 14 Mar 2013 17:14:41 +1100
> > Subject: [PATCH] cond_syscall and SYSCALL_ALIAS merge fixup
> >
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>=20
> I ended up with something similar, except I didn't remove
> linux/stringify.h from the includes.

Well, the stringify include was only added in Al's patch during this
merge window, so it should be perfectly safe to remove again (now that
all the "stringify" calls have been removed again).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__8_May_2013_11_10_10_+1000_W.B17ZkySEvb0.R6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRiaXyAAoJEECxmPOUX5FEW3gP/0Dq1DcSix9YOOnp8+p9KeKX
FZyCexd6tOuoUUWMIboVfNmNibC10woAgsjhwM43R6JNh6nd+xdW/VOTl7kSheWb
2lT4jLpy9c5rvY2sAJzfF4CkkPy/lJRChTIkq5xZNQHI91D96prBBiP8HLeDAsYX
twMJ+l8kYpSgXJZxNwl/FQkzXK6mNABwxBPxdQjQbyw+yTmgE7BImShoUVep1kNW
FJ/EmERc7AlEaNo94atL4dTcsw7gz2wWXX3kdDdVWSu0VKksA+D6IgreB6VQZILc
QDtz1Q5J/U3gInlAAbyFRXAJGNpoUlujLs6HcW233hMAe9fQWUujTzk9Y7KYZHn6
N0IPFYAPMk+fqzEJ55/BlnFawDZUWVwPPSpnPg/NRCZL+Dqeuj04awapQvv4pZNn
f2esnlfJHT/YKqyFc1pQ1oYiFAgd+YgCu/y72x1/slPUHxL/o5d9ro2wZAajKXfy
tyv+zQ3fVhikzMC2iuN7l1y+xtdgD9h071+KjhTuNpFAowrtsAull8+lz83862c1
PLWwoL0zXqX3lfa+9xsmw1d8Er9FraaYvL2Aly6zWKy3vIpWJrDod6/xavu4NgTL
e8Ja7wT1wfHpaRlmCYAclhmNpuclzLvy+lxItfI1Dbd8fzsKDon/oYc10htnodoN
+NoIXu7alpw018SgTphi
=8IAm
-----END PGP SIGNATURE-----

--Signature=_Wed__8_May_2013_11_10_10_+1000_W.B17ZkySEvb0.R6--
