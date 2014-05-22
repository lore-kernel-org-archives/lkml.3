Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaEVWLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:11:02 -0400
Received: from ozlabs.org ([103.22.144.67]:38437 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbaEVWLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:11:00 -0400
Date: Fri, 23 May 2014 08:10:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ingo Molnar <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paul Mackerras <paulus@samba.org>, <linux-next@vger.kernel.org>
Subject: Re: [PATCH] perf: delete unused variable tmp to fix new build
 warning
Message-ID: <20140523081052.51ffeb1b@canb.auug.org.au>
In-Reply-To: <537DFF4E.4070503@windriver.com>
References: <1400700787-11759-1-git-send-email-paul.gortmaker@windriver.com>
	<20140522122142.GA6650@gmail.com>
	<537DFF4E.4070503@windriver.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/X.q5Czg3XPzCqbazyXkl6Ch"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/X.q5Czg3XPzCqbazyXkl6Ch
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, 22 May 2014 09:44:46 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> Indeed - and I now see that commit when I switch over to my tip repo.
>=20
> However 12665b35b0b4 is not present in linux-next of yesterday or today
> (21/22) for some reason.  The tip/auto-latest merged into next has this:
>=20
> commit 1974363f7e899dc1b9e6e774dc885c7980a7159b
> Merge: 67367e2c3f76 7fd44dacdd80
> Author: Ingo Molnar <mingo@kernel.org>
> Date:   Thu May 8 12:40:28 2014 +0200
>=20
>     Merge branch 'x86/x32'
>=20
> as its top commit.  Today's auto-latest in tip shows a similar merge, but
> with today's date (and it contains Boris' warning fix too.)  Adding Steph=
en
> to CC in case it is something related to linux-next infrastructure.

Ingo and co like to give the tip tree components some pretty good
testing before they expose it to linux-next, though usually there is
not this long a break between updates.  The auto-latest branch has been
updated for today's linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/X.q5Czg3XPzCqbazyXkl6Ch
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfnXyAAoJEMDTa8Ir7ZwVgI0P/1TWmp7D2HS3IW8UBjnc+aBH
QjV59yCIksVrHROOLipuh+GEog87XjX/wPHyq6JZ/CbdlyubptBelNN4RsG11gKm
M91K+nkQ9EjE6TKQmy5E9IGNv6XKa0DWuPEIyyNCVecIgeM4Ek1MCuyTkxPqMxqY
CuO7Kii55efCXEUczyKWYIWecHdPGCgoH/bNAt6byOtCSC3a29B8a+9wc5wAtSX2
T0LtBdTpQ8Bj0JyfSYMW1SW3FCeb4WUZKlkpKt4Arq1xpGgEk7ZhcC6DNaS/Uyjt
qfwaHlm9wE3uEQWsHPYFJQDhsa3dpoI2LAQBE9ZZmn2N1Q4iopDecNwJG2cFb+KP
wpySF9dFNG9ujHKE1Nw8Qr4q20AeBw6zNISAJ+mUVnG+Mz/1sDEvxeIWS9GUYxLq
PMspznWbctURKRrTJOHiPwPG9CJtuE9Sl3VKNeLIqwP2BrhM4gT+H39n5gMxPAIc
ofSUCH0myJIK+WJe6JdMk/zfnB6ey5QRF6pj7VxTURYbvNyqxIrYOhHNXrdANR0Z
VgF5NPlYYMjspABGnHh65qIgtox3wfwNRyHavjgWRsaUDaYGO4Ms2nbTdy3roRIj
e+ONGxVanjWRyqQwBZW9zyz6wOPQ6ItWYIrmG18de7RMVACpXQGcqrS95RYxSGRI
f6KNEeR2CvRpct6l7xvC
=3Xcr
-----END PGP SIGNATURE-----

--Sig_/X.q5Czg3XPzCqbazyXkl6Ch--
