Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab3GHFKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 01:10:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55924 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab3GHFKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 01:10:36 -0400
Date: Mon, 8 Jul 2013 15:10:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ian Kent <raven@themaw.net>
Cc: linux-next@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 7/7] autofs - change CONFIG_AUTOFS4_FS to
 CONFIG_AUTOFS_FS
Message-Id: <20130708151023.f29446059a3161fc2e8c9b2d@canb.auug.org.au>
In-Reply-To: <1373017884.2497.10.camel@perseus.fritz.box>
References: <20130701031335.4423.6154.stgit@perseus.fritz.box>
	<20130701031449.4423.58614.stgit@perseus.fritz.box>
	<20130701143924.79f57e7206577a2e7777c0a2@canb.auug.org.au>
	<1373017884.2497.10.camel@perseus.fritz.box>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Jul_2013_15_10_23_+1000_Qs9c/i3MVEV0/Sm+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Jul_2013_15_10_23_+1000_Qs9c/i3MVEV0/Sm+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ian,

On Fri, 05 Jul 2013 17:51:24 +0800 Ian Kent <raven@themaw.net> wrote:
>
> On Mon, 2013-07-01 at 14:39 +1000, Stephen Rothwell wrote:
> >=20
> > On Mon, 01 Jul 2013 11:14:51 +0800 Ian Kent <raven@themaw.net> wrote:
> > >
> > > Signed-off-by: Ian Kent <raven@themaw.net>
> >=20
> > Please don't do this.  Find a simple way to make sure that if
> > CONFIG_AUTOFS4_FS is set, then "make oldconfig"  (or equivalent) will
> > cause CONFIG_AUTOFS_FS to be set the same.
>=20
> I get what your recommending but still can't think of a way to do it,
> any thoughts?

Isn't just having

config AUTOFS4_FS
	tristate
	select AUTOFS_FS

enough?

> Am I correct that's a +1 for an outright rename of autofs4 to autofs
> rather than keeping the autofs4 directory and a compile stub?

I have no opinion :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__8_Jul_2013_15_10_23_+1000_Qs9c/i3MVEV0/Sm+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR2knGAAoJEECxmPOUX5FEKl0P/25QcKb/7e8Bj94jF+MxiVam
whcOkOOA8N/0RU8qN4i5yAPCjSGhHlxtTBu8nggikHeZGwQLh4X0VGA7SPYRvzEh
3nmUFHMTmOZj3A32fTdvvvSS5SvQdnpQBTClNXUF8/bee5bc2M2wbnZB0qQDbKMn
SP5TQNEuZDy/pJ/IqXsYAyGHOy4uD+UaiOTlgcI4DAvUZFkOoCc0r3YKNKq9dSXB
/FMsrZMf/7JI/L/CQ/zNVxbxHnyowi25pnMb2EsjfFJvvucdJnQyTGQbgxCBxmMu
e0PsgXpS8hOM+p+gErdSR2z6um1A5MwpK+dQQj7ps+e2bUQ6Cn5WtHBA4+iaErIg
aY2yyrCJp5EtZ235HS+F6nzp0oPZYYG8wqQ/AZK52Ji7lPMuTK90jytYSoVr0vyC
WjLB0QiEbD7IhP8UikdEUwE6A6TMIYPjpzism6RKVdLi1JaiXUgqCqFpfQvZq/3Z
glJxrc/zNTbqkCgFWNAueZguQF4+GxahOxFIh9Hb0DI1Xjymdqc2UJkWcnBm07is
ybG49o8S0xZbisKeV0/yFt3jQRalPwFJosFLoIce6tutjghYMBjDl4ShW2JjmuVw
dXKffV2PxAhXXA/3FGkXYQ3eAvmussvb8ikKBm4BdomBePYQ2Qecl3wydA/LxQi/
TFz4JUckjaBw3pnc+MGU
=40zN
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Jul_2013_15_10_23_+1000_Qs9c/i3MVEV0/Sm+--
