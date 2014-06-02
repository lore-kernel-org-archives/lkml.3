Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaFBXmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:42:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaFBXmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:42:05 -0400
Date: Tue, 3 Jun 2014 09:41:56 +1000
From: NeilBrown <neilb@suse.de>
To: NeilBrown <neilb@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PULL REQUEST - 3.15] to md bugfixes, tagged for -stable
Message-ID: <20140603094156.40550049@notabene.brown>
In-Reply-To: <20140603093833.1bca3dfb@notabene.brown>
References: <20140603093833.1bca3dfb@notabene.brown>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/noWN1gaj3Aq0J8cCrG+j6WQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/noWN1gaj3Aq0J8cCrG+j6WQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jun 2014 09:38:33 +1000 NeilBrown <neilb@suse.de> wrote:

>=20
> Hi Linus,
> If these could be pulled into 3.15, I'd appreciate it.
> Otherwise they end up in 3.15.y for some y eventually.
>=20
> Thanks,
> NeilBrown
>=20
>=20
> The following changes since commit c7208164e66f63e3ec1759b980878492864107=
41:
>=20
>   Linux 3.15-rc7 (2014-05-25 16:06:00 -0700)
>=20
> are available in the git repository at:
>=20
>   git://neil.brown.name/md=20

Hm.... looks like a bug in git 3.0.  It didn't add the tag name for me like
it used to.

That should be

  git://neil.brown.name/md tags/md/3.15-fixes

NeilBrown

>=20
> for you to fetch changes up to 2ac295a544dcae9299cba13ce250419117ae7fd1:
>=20
>   md: always set MD_RECOVERY_INTR when interrupting a reshape thread. (20=
14-05-29 16:59:06 +1000)
>=20
> ----------------------------------------------------------------
> NeilBrown (2):
>       md: always set MD_RECOVERY_INTR when aborting a reshape or other "r=
esync".
>       md: always set MD_RECOVERY_INTR when interrupting a reshape thread.
>=20
>  drivers/md/md.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)


--Sig_/noWN1gaj3Aq0J8cCrG+j6WQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU40LxDnsnt1WYoG5AQLaxA//QK54mhY26iuDKLfogAai7EA/CPxKE7DH
Ixjk6Voi83Qhh1GV0xsnBdYjT9+j5Br0Rfwxmop8+xpdZkcpoFvhXGh5uP1TAIIM
NCshA7B2wUy0DSiAK5wPD36mDcSRjtr1ekeN9rz8SxuuY0wWE00W/46K2v3OuQWC
kxSdniU1WUCjmKVfDkQTZ2fCiSpOhmcriwHZxXggkycrpSHDi2XiePTTTQ/4USmH
cEDhD4+5WsZWjJ/Yg4f6H5eifpPhSnwFGqbbMdW0g0t5YpdQoyoTY+jkvQt+/g+3
5eOI8qHWDJ4BI0apNWTRjrSGy4K+yczlDNCwIMe1+mi0zByu10pk3OXMyx8znhtB
9SwnQUpZApqY4ZubDANXihFlmaQCy6Y8uA7VXNBt2tfhb52qyEM+se3l8VaM61fT
HqPPQsk0lsGeno2/dzW4hdkjYDITEQbgrSBkj9jOXAPr9j8PVjHH6ui9I5qZDmq9
35ZzFb8ugoWI0YPBLDuipTEnFs/x/rNpkzfNTumFXmPHP24kAiSpz6KgmI6VOiY6
QUwNmHiRwcchhLEZcyOZm3zhuxG8c7m6YqRTeLxfLVJf5fPOn4cd7qQBfBBApHqQ
SNkI8QIAWmg6xYoqHIAoTmSBLuZbd2Asnfuwb8+Hw+MzpAX6enGZQR3Eji2q2GMI
KdMmSDQybDQ=
=nhQZ
-----END PGP SIGNATURE-----

--Sig_/noWN1gaj3Aq0J8cCrG+j6WQ--
