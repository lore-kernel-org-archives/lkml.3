Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab3AOW0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:26:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36909 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab3AOW0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:26:23 -0500
Date: Wed, 16 Jan 2013 09:26:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Why no Tree for Jan 15?
Message-Id: <20130116092615.6695554671dffee8a58d3ce9@canb.auug.org.au>
In-Reply-To: <CA+icZUUxURMi6Qc+FHCa_sP8LPH4pyOJwTZzv11MJZ9ZdEkxkA@mail.gmail.com>
References: <CA+icZUV=-=DALJRpzrmKrC6oK-CwCyRbHE1VmjrLfmGcemx2JQ@mail.gmail.com>
	<D958900912E20642BCBC71664EFECE3E6E1A6F0BED@BGMAIL02.nvidia.com>
	<CA+icZUUxURMi6Qc+FHCa_sP8LPH4pyOJwTZzv11MJZ9ZdEkxkA@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_Jan_2013_09_26_15_+1100_.JV+V876uaiHK4Zu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Jan_2013_09_26_15_+1100_.JV+V876uaiHK4Zu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Tue, 15 Jan 2013 14:40:01 +0100 Sedat Dilek <sedat.dilek@gmail.com> wrot=
e:
>
> On Tue, Jan 15, 2013 at 2:34 PM, Venu Byravarasu <vbyravarasu@nvidia.com>=
 wrote:
> >>
> >> any reason why there is no Linux-Next for today?
> >
> > Seems Stephen created tree but did not announce it via mail, because
> > when I synced to linux-next today, am seeing below commit from him:
>
> OK, I see.
> This release has two important fixes for me in char-misc-next (mei
> driver) and "mm: fix BUG on madvise early failure".
> Thanks for the information!

Yeah, due to a glitch at my ISP (me :-() the announcement was sent, but
did not leave my ISP's mail server until this morning.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__16_Jan_2013_09_26_15_+1100_.JV+V876uaiHK4Zu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ9deHAAoJEECxmPOUX5FE3KQP/1GMnUH8x/Rjg410XchNjarO
m7lD3TYdgcDgXUJrwkgFK8Gfni1Ica3Eb2fluzu/3jeXo/Qgfrb3edV8m7kDYCLi
QhaoPFKvdz8QBaW1SRF1nghqmsC0SGYfyJzFc/06yEYiB15Lajq1eP/Up7DoXT1Y
Dx+WetduboEcYXDdODfZgLGbKYHg1VotKj3kSqdjYQuZQdKgT05FtLCgmWWfY4Jb
s4ClUbY6tB1yGsYZqayQ89Pw3LS1TIg6xSNu64Z8YxkmQWL7D1GG4ZNiGfeIXccP
vaD4rexLQvAwSiusWsaGnC0OXDqDErB7y7deO3uOYkjnyafclHhb7N9rX+OgRS8A
i5f88bAiLLDIa0TUw3zmHmJk4mGhg3+tDy5r1AVUUIGFkK6xBnArAOrCFrPZ/+lc
0TMMswq+8nuMO5LIQqZTigJidO7WKFNX/tMeVE18xM6WLXGxcIkIi/EZdKt3GXkA
gXPOfFYMW8hSN09s3ODXKMc+naaetI9T2QeccgK5QBfoAcAfOVCThlaaTjVIldoz
oRefqhAGorSD/iDWjFMHB1r1syc1mIMSIvyyRY7XwStk1vKfJn95wd/ltLq5Jdnu
5hHPsMNhPMV26TipNiSYtEm8iw4TxtytEonmasono4HD9E0d2M8p8k8B0CnFmxWY
bI753BZfPYebiSQlr2mX
=yUt5
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Jan_2013_09_26_15_+1100_.JV+V876uaiHK4Zu--
