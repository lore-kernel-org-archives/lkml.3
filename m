Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3CBEzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 23:55:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38375 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3CBEzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 23:55:16 -0500
Date: Sat, 2 Mar 2013 15:55:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ftrace tree
Message-Id: <20130302155514.7ff4c87bcc3ebdef0ee9b39f@canb.auug.org.au>
In-Reply-To: <1362198178.1231.83.camel@gandalf.local.home>
References: <20130301134738.ce925e1643a35b0a2c4ff275@canb.auug.org.au>
	<1362192318.1231.67.camel@gandalf.local.home>
	<20130302144229.f41f56c36992497a1530d65f@canb.auug.org.au>
	<1362196529.1231.80.camel@gandalf.local.home>
	<20130302151700.89f98f5c132a913510b5a621@canb.auug.org.au>
	<1362198178.1231.83.camel@gandalf.local.home>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Mar_2013_15_55_14_+1100_yVgkQVEfTpYTPX0C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Mar_2013_15_55_14_+1100_yVgkQVEfTpYTPX0C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Fri, 01 Mar 2013 23:22:58 -0500 Steven Rostedt <rostedt@goodmis.org> wro=
te:
>
> On Sat, 2013-03-02 at 15:17 +1100, Stephen Rothwell wrote:
> > =20
> > > I made some major changes and wanted testing on it as soon as possibl=
e.
> > > I've done tons of testing on my own but I wanted a broader audience. =
Do
> > > you want me to pull my tree and reset it to what is only for 3.9?
> >=20
> > Yes, please.  The reasoning is that until -rc1 is out we don't want to
> > complicate life for people whose code has not yet been merged by
> > reporting problems in code that will not be merged until the next merge
> > window.
>=20
> OK, I reset it to what I based my work on, and that commit is in Linus's
> tree.

Thanks.  It should only be for a few days anyway.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__2_Mar_2013_15_55_14_+1100_yVgkQVEfTpYTPX0C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRMYYyAAoJEECxmPOUX5FEMvUP/jA9Jod9nSSzK/qzn3+vpuzD
PHYPmac5DPKSMXFp7c9d9gYbK+M0blHjpgP9SqJsTMeZ/ZjbsaxMh0Pk+iL7BG/G
CNuyBe1G+wBkQ83oSTnH3VnVnEEzTZnSC6cMRWnQqNBfl92j04S3geQXZkEUQ+So
znF8frcXElXAy9VrsGvop2rsJtnPpeB9qarIIAqppWucEI80tWbR9FaVP1i3YOkZ
Pqe2dewniMFeyca3d/duDTP3+A31+bgtCIWlLtHq+pib3CUwHG/DdI0My7rzdqc7
1PeFXvlzxZSDZLy2cDXryS47hDZc2v3uaUhu25zQKuE/ltyWNNw3gnYDct1axDdg
V+9oEVEArq5VjH6EIPltv7QXvuTVZr2c1JzGOESVgXi4LLSND3+jYUseeXwHUg3H
7nbMu7YJdn4Ptzd8GrjR3VRkS81tyQmlI6usOWLf+TNvt16yo59IKf2msvJM0e91
oOED3SDPN/HkvpQlVo4W2JWhypt83k2EJtRMmcd+mptMXoFUW0a5fZnztRhm/Ox4
nKFLbug6i5y9EsUDk2hVOQ2hxcbNhXctSt/RtB5EkkPzf7XQbAqhdBSd0MzsR8dC
HpZmVEdZja3J5NYPRW7MRn3Ze+3CKZ3qqM9q334dUAEmZrqKu0Jxo3Sh0BsnjKcP
9mY8mpa+2uKN6VPhLzVU
=R57Q
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Mar_2013_15_55_14_+1100_yVgkQVEfTpYTPX0C--
