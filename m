Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3BQK0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 05:26:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63594 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3BQK0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 05:26:34 -0500
Date: Sun, 17 Feb 2013 11:26:30 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Johannes Thumshirn <morbidrsa@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: twl: Fix typo that broke build
Message-ID: <20130217102630.GA20299@avionic-0098.mockup.avionic-design.de>
References: <20130216202114.GA18727@avionic-0098.mockup.avionic-design.de>
 <1361095693-12385-1-git-send-email-morbidrsa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <1361095693-12385-1-git-send-email-morbidrsa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2qm0TgMLlJndPEqVLu7cBgoIWBldKm99qdxrb0bgtS9
 mLzcQ9wuD7bDIQBVepFcMwGMWdhReWhrI+XrgW0NSA1dnN880F
 rBuO1vVwX700imH3uGmQj+txsNk59zvNKZHjV+HWjKOUhPqsIR
 SGnWsg7/V9qBiIHTMdAjoirBZIQcFoZ3C8wMfnOnWEbflL1Y9T
 vSsN8WZEqb9uqVISJ4fwkwvp9W8MGCFGyofFyAzNPe8y1/3bVl
 aUsFiiFsS3uxTB27FnpikowlOr+QQCiqjU2Ll/3zg81VoouJqE
 iiFdsUGfTtc7dOeIj0DoYxiYPT9KpNcIdm6epDjKuinRUVox/w
 LsBCXvVn6HU8yoplzuXas5pHPN7+RPTbDrR0zAkrJlHXBPqrQF
 fJK+d1nk1wXVuUPFl2M3wKZMk5mdbbCtFI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 17, 2013 at 11:08:13AM +0100, Johannes Thumshirn wrote:
> Fix a little type that unfortunately broke the build :-(
> Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
> ---
>  drivers/pwm/pwm-twl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Uh... I hadn't noticed and deemed the patch trivial enough so I didn't
even build test. That'll teach me. =\

Thierry

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRILBWAAoJEN0jrNd/PrOh5GsP/RZMZwbn9pxILDouwlwU51lx
r3wPlPifE5myOhf2lu2RaZhu0pyx3sHWUvFUgHqDulxqy9NsVMRWmPvapIoSsJSR
NmhkF+vVVbXeiwpcK50grkPgzAjGPs/5v/W+H9UIHRBsEqmQrkWVod96xgNcWzbQ
FcAl8Dz8IPH0mKk6uASlYWc1/DzoK/Zw9A848Z9wy2CHAO1SbhcWYfQwWs3jDb/r
2/Y0YecH971kNZazV0k8yDy0AjhAt5uRheh06EqgGUIT0TpedBnQpI4ZGBd4XKki
NN+JikTIQ/ImGmoSBw24f2K63TuMqThIKPkyV2KXQWti/5yYw/BPt5qUi5MBocPc
XpAIJ+TwEPQ4IJzC2pQ8RT5LYlRoLaAN9yt4uiWOG3pbYoqFHFF0Azbcy99+k5NT
WYUuAvKFDUGJQUxpF/gexO56S4vfF+t7+vYhTxjQdwL3B+ecwnC7nM0IDTn4zaK7
/q7ToUlPFCGckJ6Ws9agyuax7EPhHWYW1myVuKGEsfVi6YKm/qKH8CdzpCataljv
aCf3mTEzgPhJQkgLmStvVncgJXGf8gt1e2/KyHEUTAdw8m7DYL+5aJuaZRUdICxI
4XRGvEUthRicsBxIPb5qcHQuO/DU9NlQ6gbXsb0ywoq1KrwF8o3jUaKhDJ+spWVw
Imxeyo1oh1B5+3WLN/e4
=5RkX
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
