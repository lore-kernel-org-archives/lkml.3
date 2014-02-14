Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaBNA3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:29:43 -0500
Received: from ozlabs.org ([203.10.76.45]:40482 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaBNA3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:29:42 -0500
Date: Fri, 14 Feb 2014 11:29:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 00/10] mm: thrash detection-based file cache sizing v9
Message-Id: <20140214112935.4df6f8ace56725331614556a@canb.auug.org.au>
In-Reply-To: <20140213142407.f2c41f5c6561e708f2453e93@linux-foundation.org>
References: <1391475222-1169-1-git-send-email-hannes@cmpxchg.org>
	<201402130321.s1D3LH41073563@www262.sakura.ne.jp>
	<20140213221126.GP6963@cmpxchg.org>
	<20140213142407.f2c41f5c6561e708f2453e93@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Feb_2014_11_29_35_+1100_M8vuOK9XTKgVAuIj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Feb_2014_11_29_35_+1100_M8vuOK9XTKgVAuIj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 13 Feb 2014 14:24:07 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Thu, 13 Feb 2014 17:11:26 -0500 Johannes Weiner <hannes@cmpxchg.org> w=
rote:
>=20
> > On Thu, Feb 13, 2014 at 12:21:17PM +0900, Tetsuo Handa wrote:
> > > Hello.
> > >=20
> > > I got a lockdep warning shown below, and the bad commit seems to be d=
e055616
> > > \"mm: keep page cache radix tree nodes in check\" as of next-20140212
> > > on linux-next.git.
> >=20
> > Thanks for the report.  There is already a fix for this in -mm:
> > http://marc.info/?l=3Dlinux-mm-commits&m=3D139180637114625&w=3D2
> >=20
> > It was merged on the 7th, so it should show up in -next... any day
> > now?
>=20
> Tomorrow, if Stephen works weekends, which I expect he doesn't ;)

Actually later today (my time), since Friday is not a weekend :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__14_Feb_2014_11_29_35_+1100_M8vuOK9XTKgVAuIj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS/WN0AAoJEMDTa8Ir7ZwVI2gP/2LhyxSwR7YVuiffm16Eegzg
wmC9XiSQcsjiacqd9vcR2jE9YuLJ5xXjrGo5FOn1FutheF6DtUvlNrfUYhhUhNQb
31DDT/JREJ3LwPT94M7trf+euRlUsH+YDiNex/C/h/6V4vYB3cN66vAEI4OhEgUe
r5hFutOfr/9e3m5Has7n9CA/5xM3JvJflJS19XASyGdFB37BvUkYsuKXk3Sp+Pcp
9SSBQSxO55uW3ybrumKgErA0mDh5peauBAT8jnrrNT2jKmOjQLW/vU9BFZcW9J8e
RSb9h5yWM6bpd6BzttqZ/l9AqV625FvpfnY2AGYmc/20yZztJC5DM+9EXoarSqAJ
D3QTzYProcOWVPVCeZiJll+u5QGaEgPu5Xdv1EH+zO5fBQtb6/1qU7ZjIDN2cfBJ
hpo//sr1U9IA92LatRKNTr5m5ytxHzxXYMogL5dsSENApIYrn4ZW/o3clYFGY6OB
WGXvs0agSwUlFMxVKcMXau+GTEKHa7usEY1erbWGRQjht53rXppRXVRxr6ppr/ui
+Xwydm4GS96mAcCsx1uKgRCilKre6ICUlsBDk8t8w0iIxIfoR9ZJqdS5edGk4+ID
m3AUOR5lZrydWWSj8HR8/Y2ZyTBoupWydmucnVc3e+jqqDmi8z5qoVuB+t5P2tU8
h3EeSDznulPdJUo1a1VE
=YYNW
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Feb_2014_11_29_35_+1100_M8vuOK9XTKgVAuIj--
