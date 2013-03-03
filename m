Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab3CCCMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 21:12:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56752 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3CCCMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 21:12:08 -0500
Date: Sun, 3 Mar 2013 13:11:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Arnd <arnd@arndb.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] late arch/metag fixes for v3.9-rc1
Message-Id: <20130303131154.218a17f2ea1cad037ca3859c@canb.auug.org.au>
In-Reply-To: <CAAG0J9_dB0t-pnTW8in8=FpZw__HJF9Auhee4WJ3diOxy1DDrQ@mail.gmail.com>
References: <5130DD94.2060408@imgtec.com>
	<CA+55aFw9qvUdrtEk_83-gEjZMTceONk=AuVsHuTtqOj=jpVPQg@mail.gmail.com>
	<5130F978.9040604@imgtec.com>
	<5131D2F0.2010705@imgtec.com>
	<20130303024851.4be2d2435da42a6010c6c8f8@canb.auug.org.au>
	<CAAG0J9_dB0t-pnTW8in8=FpZw__HJF9Auhee4WJ3diOxy1DDrQ@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__3_Mar_2013_13_11_54_+1100_Srd3F3ze9btBlpqJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__3_Mar_2013_13_11_54_+1100_Srd3F3ze9btBlpqJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Sat, 2 Mar 2013 16:22:15 +0000 James Hogan <james.hogan@imgtec.com> wrot=
e:
>
> On 2 March 2013 15:48, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > On Sat, 2 Mar 2013 10:22:40 +0000 James Hogan <james.hogan@imgtec.com> =
wrote:
> >>
> >> Okay, I've rebased the arch/metag tree onto mainline to make all the
> >> back-merges unnecessary and applied those simple fixes into "Build
> >> infrastructure" and "Various other headers" commits (additionally
> >> trivially removing ARCH_NO_VIRT_TO_BUS which is also now unnecessary).
> >
> > Pleas make sure that what you are submitting to Linus is the same as wh=
at
> > you have in linux-next (i.e. reset your for-next branch as well).
>=20
> Yes, for-next now moved to the rebased version.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__3_Mar_2013_13_11_54_+1100_Srd3F3ze9btBlpqJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRMrFqAAoJEECxmPOUX5FEuW0QAIM03d51+FyTPbP4WqADnP+U
eIvUt4Q9dKxf4tcZDEM0PvEYIAslotZhZsP6cVYUZiBKkJ9EYMCO/ork6hqWUQ9Y
l2V8p5reZX97s5imw+FbSAgYvIvrsfbbLMZJQlJdcpoEEWY5dTBnxlXdfVXvlVJB
W4DFhnTjCGmTnyNkfbX5mjdUXjkSwfutF7bNMomXx/fNJGJVTJGex//hq6DZoAPF
64o/vDVqrQgQc3buuV6MY7384J2ru39zDeIX5vxiRdqHGMzce4FkhWIlRcVw/ZNC
CqNiF6rkBHqTP/UwZadF8MjNJRK7YKS9vHfqRltz8+F29hqURuTCSfpueaIdZJuJ
MuS6tTXsLhiqOCLf7S7SFb9l8b9HFFWakSIwkJMxmGdqD6mA2KTFj6tga9ycHq3F
J0S721RTlOuyipojEw28PN1bUb5IzdueCzb5p+/+YUmSdyUwObnT2lM1B5FCNMdS
s4nO9IKhji+bLwN+w+w6IdKCDnIf1QVezIuyW5jmHMp13PYlaoiPz2oHYa9nxpfZ
8D31SUtu+p6DsIsKXFJCkvHK4BouVJmOBQ5jR3gFlggXWdYnWYLxOJAKlFW7ct4l
BDRLnycWUoHtXN62J/EaBf39w4WEhjG4vPA6AnjrKdC2iB2hJDH9ZgaAOS7989LM
LpwUX1rTT1xsXsJCT5S6
=WWNw
-----END PGP SIGNATURE-----

--Signature=_Sun__3_Mar_2013_13_11_54_+1100_Srd3F3ze9btBlpqJ--
