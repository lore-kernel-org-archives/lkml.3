Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3LAJu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 04:50:27 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:52230 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3LAJuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 04:50:20 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, sre@ring0.de
Subject: Re: device-tree based boot on linux-n900 branch
Date: Sun, 1 Dec 2013 10:50:18 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: sre@debian.org, kernel list <linux-kernel@vger.kernel.org>
References: <20131127125149.GA9389@amd.pavel.ucw.cz> <20131130172938.GA5194@amd.pavel.ucw.cz> <20131130231532.GA6688@amd.pavel.ucw.cz>
In-Reply-To: <20131130231532.GA6688@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2106292.LcEy5OkLn7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312011050.18256@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2106292.LcEy5OkLn7
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 01 December 2013 00:15:32 Pavel Machek wrote:
> On Sat 2013-11-30 18:29:38, Pavel Machek wrote:
> > Hi!
> >=20
> > > > > > Hi, I already have this patch prepared for 3.13.
> > > > >=20
> > > > > Cool :-). Do you plan to publish / is there 3.13 based
> > > > > tree I could pull somewhere?
> > > > >=20
> > > > > Thanks,
> > > > >=20
> > > > > 								Pavel
> > > >=20
> > > > Yes, I will rebase n900 patches on top of next 3.13 rc
> > > > release which will have some patches already included.
> > > > I have not created full n900 3.13 branch yet.
> > >=20
> > > New branch 3.13-rc2 is now on gitorious linux-n900 tree:
> > > git://gitorious.org/linux-n900/linux-n900.git
> >=20
> > Branch seems to be named "v3.13-rc2-n900". Thanks!
>=20
> Is this one expected to boot in devicetree-based setup? If so,
> does someone have .config?
>=20
> Thanks,
> 								Pavel

No, this my tree has rx51_defconfig which is used for classic=20
booting with board files.

Sebastian, can you create new rx51_defconfig or at least patch=20
which enable DT booting? Also some steps how to compile DT kernel=20
will be usefull (maybe on http://elinux.org/N900).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2106292.LcEy5OkLn7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKbBloACgkQi/DJPQPkQ1J0EQCfcFdlDLnKdVXRGWgCmjNos0Th
OZ8AoJEueTmOFRjeAtBSrbTXo91VuWw+
=rpjP
-----END PGP SIGNATURE-----

--nextPart2106292.LcEy5OkLn7--
