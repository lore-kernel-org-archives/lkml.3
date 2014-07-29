Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaG2X4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:56:51 -0400
Received: from ozlabs.org ([103.22.144.67]:43357 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbaG2X4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:56:50 -0400
Date: Wed, 30 Jul 2014 09:56:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140730095642.5f68e01d@canb.auug.org.au>
In-Reply-To: <20140725144522.32c1f6b5@canb.auug.org.au>
References: <20140725144522.32c1f6b5@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/jUG3yYENU/XGCvEVAizmTNB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jUG3yYENU/XGCvEVAizmTNB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 25 Jul 2014 14:45:22 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi all,
>=20
> After merging the tip tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> arch/powerpc/kernel/time.c:743:6: error: conflicting types for 'update_vs=
yscall_old'
>  void update_vsyscall_old(struct timespec *wall_time, struct timespec *wt=
m,
>       ^
> In file included from arch/powerpc/kernel/time.c:77:0:
> include/linux/timekeeper_internal.h:114:13: note: previous declaration of=
 'update_vsyscall_old' was here
>  extern void update_vsyscall_old(struct timespec *ts, struct timespec *wt=
m,
>              ^
>=20
> Caused by commit 4a0e637738f0 ("clocksource: Get rid of cycle_last").
>=20
> I have used the tip tree from next-20140724 for today.

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/jUG3yYENU/XGCvEVAizmTNB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT2DTAAAoJEMDTa8Ir7ZwVHRQP/jFuWakuVUabUPR2MF8WTTq5
1SaRylZ2PRW4Qzt28oJvaZbFLuqBcrgs8+LI6FsdKTKF3GUV91OSFAeHuk7W0bms
/KzCKdwg/JzO8O6jsnAR+c26xl2HvfE2/DaVHRDJ4xD8gcKY++O+Qq1IHLZe8P9N
WSIp4EgFIvbDWe4ATlJLp2NVAIXTwPKWk8QBl63aECqu7kMD9vs2FmqPZZ7E0sr+
X4GMsX7sxFDUZ6SXA1KX5rkAElc4QPQTh0VuVJaRktEi9UCuLPev0PdybMb/svQr
0Bi1OzLUZKW7SOIQtXUKyznRSMZCYoe2kTTelFINIHYbcS8nc4Dx9SdDb9mfMT8m
ta3gezfai1JilYlhXuJUoWtO0Fnu4kALq47cCo1tZL6+xHC32XfMSB1wH2KbqIl/
vUQthnI/wV4fz8TXtHHCuAvA5zQOizK7jDDVd/7YVu3jFVDQQbPHpSLQdMZYEXAv
IBisql5IK4Ur4kAn8a/PwmjOtac/g18uAMQaMS6zrMEKQq6P7xq+3saKQmXQ6y6S
TN51tI98Gkg1D1pC2NPOMpsVnbZ0jh0JKNV6O6B98XDETAknLM5JpahAuQ63aqdT
AEzV/ES8zHbP+vGx9qpEmMa3WF+R17jIJ6UxK1Ex6rvxyZKwJzA3hGO7FTADiVWE
N5RNUeEhzCVTVczZAscP
=Ppve
-----END PGP SIGNATURE-----

--Sig_/jUG3yYENU/XGCvEVAizmTNB--
