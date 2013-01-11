Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab3AKVzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:55:50 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:45556 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab3AKVzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:55:49 -0500
Date: Sat, 12 Jan 2013 00:55:17 +0300
From: Sergei Trofimovich <slyfox@gentoo.org>
To: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>,
        Martin =?UTF-8?B?UMOkcnRlbA==?= <martin.partel@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] um: fix build failure due to mess-up of sig_info
 protorype
Message-ID: <20130112005517.281f2b53@sf>
In-Reply-To: <20121230104043.2090940b@spider.haslach.nod.at>
References: <1356820651-8495-1-git-send-email-slyfox@gentoo.org>
	<1356820651-8495-2-git-send-email-slyfox@gentoo.org>
	<20121230104043.2090940b@spider.haslach.nod.at>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6A3VZzPznmEpDSHrqE=wd.f"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6A3VZzPznmEpDSHrqE=wd.f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 30 Dec 2012 10:40:43 +0100
Richard Weinberger <richard@nod.at> wrote:

> Am Sun, 30 Dec 2012 01:37:31 +0300
> schrieb Sergei Trofimovich <slyfox@gentoo.org>:
>=20
> > arch/um/os-Linux/signal.c:18:8: error: conflicting types for
> > 'sig_info' In file included
> > from /home/slyfox/linux-2.6/arch/um/os-Linux/signal.c:12:0:
> > arch/um/include/shared/as-layout.h:64:15: note: previous declaration
> > of 'sig_info' was here
> >=20
> > Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> > CC: Jeff Dike <jdike@addtoit.com>
> > CC: Richard Weinberger <richard@nod.at>
> > CC: "Martin P=C3=A4rtel" <martin.partel@gmail.com>
> > CC: Al Viro <viro@zeniv.linux.org.uk>
> > CC: user-mode-linux-devel@lists.sourceforge.net
> > CC: user-mode-linux-user@lists.sourceforge.net
> > CC: linux-kernel@vger.kernel.org
> > ---
>=20
> I think both patches need to be backported to -stable.
> I'll add the tag and push the patches ASAP to Linus.

Seems to have got lost.

--=20

  Sergei

--Sig_/6A3VZzPznmEpDSHrqE=wd.f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlDwikUACgkQcaHudmEf86psHwCghy30aJFSkKC9EdSLV22TAOp2
EVgAnRqw6HvtTH9cO2d510ug5M3sAtpw
=emHx
-----END PGP SIGNATURE-----

--Sig_/6A3VZzPznmEpDSHrqE=wd.f--
