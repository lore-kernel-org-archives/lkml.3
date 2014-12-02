Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbaLBSIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:08:15 -0500
Received: from libra.uberspace.de ([95.143.172.171]:35627 "EHLO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488AbaLBSIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:08:13 -0500
Date: Tue, 2 Dec 2014 19:02:36 +0100
From: Matthias Beyer <mail@beyermatthias.de>
To: pieter@1ago.be
Cc: klmckinney1@gmail.com, gregkh@linuxfoundation.org,
        tapaswenipathak@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: Fix tab between spaces in
 InterfaceMacros.h This is a patch to the InterfaceMacros.h file that fixes
 an added tab instead of a space. Found by the checkpatch.pl tool.
Message-ID: <20141202180236.GA5636@fu.3gs>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <1417541149-18697-1-git-send-email-pieter@1ago.be>
 <20141202173957.GJ2314@fu.hfu-open.fu.hs-furtwangen.de>
 <547DFF2F.7090906@1ago.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <547DFF2F.7090906@1ago.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pieter,

On 02-12-2014 19:04:31, 1Ago - Pieter Waegeman wrote:
> That's weird. I can still see the driver in the 'master' branch on
> https://github.com/torvalds/linux/tree/master/drivers/staging/bcm
> I've cloned from
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>=20
> Or am I doing something wrong?

nope, you've done everything right. BUT the staging stuff gets
developed in the repo/branch from gregkh, so you should base your
patches to drivers/staging on that branch. And there, this driver is
removed already!

Feel free to contact me directly if you get stuck with it!

--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUff66AAoJEJi+S08gyg+UioEP/jpRInV05fhqqfZtHvnRbOzg
sXQNxtyjgJMLc5QTSPD3wOOxD0Xd5ZBItIc3Z+zG4QKFWXgbXQI9B59roYg0xAU8
FsUronGfPm6ebkamQg8V6gFlkTmidb3Xc+OQnkyb/IbkQL3qwDfENmWuRkwDw9df
tm8GyziWdZqfcJ7J4zLZz0qi6Ks/vRVdWLR2us/D9j4rtiyMgrDQHk4s8fQmRETl
vLk6awqMU+GtciLigJtjECQMkAdsg82gIHHPyVTcGJpKFgNAHi4aylGQicupysXK
GotW0pgK7qEkCH9HQBgZjD6e/MwHGxUWnW8kVUp/32tcLWe0uVxioXDxEzsm6uJ9
FIsAmTdub77NgFnp3wT7z3SoqEAPNi84e0yb5RhhJKCPp2rnLFbR3f9iGQElCNi2
U9TfaS1Woy42LHA8jCgsqRtfsUVsDR5yN9Kt0BD1BzJWFJwf1F0w5iPu9E4QZInk
DrSJlOOT6HqmMpoUUk1mPcV1hYzvZklo2JU2nVjQ/bVNSjdIAuhInnN/ZgCW45JZ
S9Q3PDHMVrwk9Zbj0P8BwGzeG0Uam8R1o/e28qhzL07YchM3s9gPsgAvujHWqo0f
z+V+67KMWlQVFd+NwQZjp/l9OfQ/XvnjNvkaTvsAkWKPXPgIKYaDZxuzhzOGw5cz
egu9lfZxpu+34liAmInL
=DcIG
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
