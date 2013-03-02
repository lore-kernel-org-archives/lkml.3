Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab3CBEt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 23:49:57 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55850 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3CBEt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 23:49:56 -0500
Date: Sat, 2 Mar 2013 15:49:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, jslaby@suse.cz
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
Message-Id: <20130302154935.b5695346222e75562c0327e0@canb.auug.org.au>
In-Reply-To: <20130301.171008.1027312383466468118.davem@davemloft.net>
References: <20130301.164711.326215889038834651.davem@davemloft.net>
	<20130301215609.GA3261@kroah.com>
	<20130301.171008.1027312383466468118.davem@davemloft.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Mar_2013_15_49_35_+1100_ilzl3viJuA=aWCjI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Mar_2013_15_49_35_+1100_ilzl3viJuA=aWCjI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 01 Mar 2013 17:10:08 -0500 (EST) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Greg KH <gregkh@linuxfoundation.org>
> Date: Fri, 1 Mar 2013 13:56:09 -0800
>=20
> > On Fri, Mar 01, 2013 at 04:47:11PM -0500, David Miller wrote:
> >>=20
> >> I'm getting these non-stop right when the hypervisor console registers
> >> on sparc64, and the machine won't boot up properly.  This is with
> >> Linus's current tree.
> >>=20
> >> [511865.556835] console [ttyHV0] enabled
> >> [511865.564555] ------------[ cut here ]------------
> >> [511865.612410] WARNING: at drivers/tty/tty_buffer.c:428 process_one_w=
ork+0x164/0x420()
> >> [511865.627846] tty is NULL
> >=20
> > Sorry about this, I have a patch, from Jiri, to get to Linus after
> > 3.9-rc1 to remove the warning.  It's safe to ignore.  Maybe I should
> > just push it today, I wasn't aware that it was being hit so easily.
>=20
> Ok, next I'm hitting some regression in Al Viro's signal changes when use=
rland
> starts up. :-)

If only we had some way of testing this stuff before it gets into Linus'
tree ... ;-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__2_Mar_2013_15_49_35_+1100_ilzl3viJuA=aWCjI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRMYTfAAoJEECxmPOUX5FEu5cP/0SNS2mAIiOAuwcSzB6uGZ40
7DqrHo4qjUSkyBnF04IMTHfztIYDl0IzxC/epacTjIqM9hr3OlJ+B7HDAtZI9qA6
Q9Q2m6uqdLFuXpiG/i8qnAvgkXn58F1SedfAefWcUEAoOfxANxmIIqRe0K+gYc55
YiO1YjbWd8f2I88niiFLfVnlVtyZV/8k8gdeKdNOOXnazoU+lIWZ0auNEl7M8q4X
dUXw4cMTILvrJgA5gxjvCa3lpzrolyg1YscoCQUaSymI8T/AxwJbS5j8DaOzkhWH
aSqvu0pZhYJFWZFe7xh5paiJyp5hRllyeWJPUt3Ut7eKN1CFaW25RraUAN+bxo6w
Aj+p+85HVXu18FXDmuCAnmEO6bCRQCnG0aE7+x1utCsIButdszm+me2q8UPlsYiL
AiqB93guOKnx/9jjp3bF0ypKTloPsSCp+bDhtzKpQMADk4njCel9TtdIweH9ZwMu
z1GO1q3jPLtvvyC6fci8Tf9NATaNVk0DunRy7h5Qf/95ZyozD5M5xgrMXtffu6IX
QY9zu8ywJ2bLR9Tgtaty6mqP69cecQO1FuQ011wLlStMDK7TM0D2/ZRpw4Zn35UF
mY5woW0G2MYAifKSjNoTYn2Hv3JdUghSsL21uNbMsSqS2mjYAdsFr/zAJZdTpH3Y
0puSJC+CjB7ncLHatDPG
=M7RQ
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Mar_2013_15_49_35_+1100_ilzl3viJuA=aWCjI--
