Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935223Ab3BTA2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:28:21 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55606 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934171Ab3BTA2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:28:18 -0500
Date: Wed, 20 Feb 2013 11:27:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [GIT PULL UPDATED] workqueue core changes for 3.9-rc1
Message-Id: <20130220112709.cc28b5b07afd6475157bb6ad@canb.auug.org.au>
In-Reply-To: <20130220001925.GZ17414@htj.dyndns.org>
References: <20130219173937.GM17414@htj.dyndns.org>
	<20130219181356.GP17414@htj.dyndns.org>
	<20130220111125.8040fb7cd9c74c80baab6dde@canb.auug.org.au>
	<20130220111413.b9444b48400f808d8921be89@canb.auug.org.au>
	<20130220001925.GZ17414@htj.dyndns.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Feb_2013_11_27_09_+1100_313EHzREIKxiPcII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Feb_2013_11_27_09_+1100_313EHzREIKxiPcII
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, 19 Feb 2013 16:19:25 -0800 Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Feb 20, 2013 at 11:14:13AM +1100, Stephen Rothwell wrote:
> >=20
> > On Wed, 20 Feb 2013 11:11:25 +1100 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
> > >
> > > This is very different from what has been in linux-next (it looks like
> > > you have been cherry-picking fixes from other sources into your for-n=
ext
> > > branch?):
> >=20
> > Or maybe what is in linux-next is a mash up of several different things?
>=20
> Ooh, wq/for-next was combination of wq/for-3.9, wq/for-3.9-cleanups
> and wq/for-3.9-async.  I'm fairly sure all the commits are accounted
> for.  Checking again just in case....
>=20
>   $ git rev-list --pretty --oneline tmp ^next-20130219
>   bd26f12 Merge branch 'for-3.9-async' into tmp
>   0f985c9 Merge branch 'for-3.9-cleanups' into tmp
>   1438ade5 workqueue: un-GPL function delayed_work_timer_fn()
>=20
> tmp is for-3.9 + for-3.9-async + for-3.9-cleanups, so yeah other than
> the last cherry-pick, everything seems to be in order.

Thanks for checking - sorry for the noise.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__20_Feb_2013_11_27_09_+1100_313EHzREIKxiPcII
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJBhdAAoJEECxmPOUX5FEUywP/At57ixpQn58yxZbQsTBnoO8
GRIGDRv/PAUvUD4xMR6akZcKHMF4KwrT8VUXGJOD/7RfjcD5C2tTNCfD6W8f3vNy
y9TeHKOQ220pvkJAVpo85V3oJKUDnPng4u7OWByaYH5Viq+JMRyT/XY6hKKGv7zT
nSSAceWaN7CYRu1s514AZYyqhlhWY+LUKGzQq3GaFv42Hm8x9Sv3BkuMHGkaR/Yj
aSd3zv7eB+dv9mT0Xh/MAvJOhkTs85C17NjG7GpHMrT+Yw2ZC/CI8mo1hWncjmsQ
9UK9NWrEz2BVoH8gRv2Ot5zxHe4UNtliIE17RgHtOoeueILeF9JXNzOJuWgS+NLH
b7sFALFU07ciS8zNK/5vIOMdsxWGSqXZoTlcrQs/RgxykWFFcD2diL8ABLOtvjze
yrdJf4KIEyg1K0e+KMeeQCesmBqi0AIjFwRinCXjIXEiovoE+1Zl0QUhmjbfsemZ
sZhS14gxHqAf2sXH63sQhox8qPyrYa0XmqARXTyeusDHSk0fj9NTdKL8zfngrgxM
Gz11Cj+d+QsiYnmjfaS5VZZuwO4ffmRs+lQCmaCYoRdkBFd9XrO7GoWln39/LfVX
8LCMlEwOY1Wf2ObjDyVboxg9ApHmRxAX1eEIenWhER7z9rU3dOxllcfYjhMuNrN7
ab8iaXdasJwADH1hUXkh
=ZPRX
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Feb_2013_11_27_09_+1100_313EHzREIKxiPcII--
