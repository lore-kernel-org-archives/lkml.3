Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbbAIOFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:05:07 -0500
Received: from omr1.cc.vt.edu ([198.82.141.52]:57750 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbbAIOFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:05:06 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Siddhartha De <siddhartha.de87@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Subject: Re: Fwd: Question about kernel interfaces
In-Reply-To: Your message of "Fri, 09 Jan 2015 18:00:07 +0530."
             <CADxyqMF4Pajd9oA1FOeb=XH9WVw83D_iX7JoS6GKZDkCeZf-Ug@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CADxyqMFnDnFNvTL7Yuzd-1WP9RRddFYAd7UVXmLT2SOMRmOx9g@mail.gmail.com> <CADxyqMHXMjXPVnGSpQSS=_FUpH=Hz-=P1FbcFfJ8Omp3k74dGA@mail.gmail.com> <20150108134849.671ee761@lxorguk.ukuu.org.uk> <CADxyqME4=vnZh4J8BDw63r6L=hA8OpO4GJWxuuOgwuFwHb+8Lg@mail.gmail.com> <CADxyqMGJxNMvXr4YtiZus0g1+a1EdamNbnr54qqitByZa8idkQ@mail.gmail.com>
            <CADxyqMF4Pajd9oA1FOeb=XH9WVw83D_iX7JoS6GKZDkCeZf-Ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1420812234_1896P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Jan 2015 09:03:54 -0500
Message-ID: <37103.1420812234@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1420812234_1896P
Content-Type: text/plain; charset=us-ascii

On Fri, 09 Jan 2015 18:00:07 +0530, Siddhartha De said:

> In what timeframe should we migrate to "pure" sysfs and drop using
> any ioctls (if a sysfs interface exists)?

Pretty much the answer is "you don't", for the wsame reason that there's still
a lot of non-process stuff in /proc - there's no good way to clean up /pron up /
 proc or get rid of ioctl()'s without breaking userspace.

And some ioctl's you can't get rid of because they're part of official
standards (for instance, all to TIO_FOO stuff for controlling a terminal are
part of POSIX - removing them would break code that used to be portable...

Or to put it differently - ioctl() virst appeared in Unix Version 7 in 1979.
>From that, calculate how long it will take to get rid of.


--==_Exmh_1420812234_1896P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVK/fygdmEQWDXROgAQK0rQ//dy6m5i1yyVjKU/NaSsEcwKyDmSf05a5O
TjT2+0AYTtC8cX1QpqTL0hop5CtMFX0lrHZfAWTpO81PlUlEXc4+tk6C+1RBhrPO
+Lbc1M3/2vkbT5yDqbpWdOF6NP4sDM034Z9Hoa3apXt+RCnTSp6PqLJPTWFBiZqO
bDSdTQdeBXNuDjc4lF1ZeYosjnaoQND10HN5S1tbEOOSEyDrKDLIngFs90tX8c4r
fXb0kNd0ODvN86DVHT0sl92ljj3YbTwAVLAQxnENCujnuEPTGkKNYGqbGwLpm2a9
AofHBwvu0XlgY64LgWX30y/IsQQhq+kOm0f6E8cN2FbWwb/3wGYCEu1y6entti3j
8kMqMFTWcKbSd+WBHFYTAtwKoFR6j6QflyWeVAjAywrG4L4OCYghJ9PTI1wI84l1
HnMpS/sC19bCnpx460V4rt+0XQXgo3Vuz1cJTAZkjGOB0ZaR2y024gIVSUMAmW4+
J4EBiA/KXlB8vtEQwAMW70TK2gX52vL8GSAf1RUV9zH+xMn+RJUZjyiBBK3yWyZx
iNyyO/qfiIyyHHoUQTOgLLXzfVDKHbIuThu+LAOanb+Y76eQjTeYCAtBnZTNc1ig
vyLIR+JxrZIFhfeddHnyMjmfUhHW0+31M+whT260n2n4spPc2vZ7hcNzW7II24Ua
YKvpEuLFwwQ=
=y86A
-----END PGP SIGNATURE-----

--==_Exmh_1420812234_1896P--
