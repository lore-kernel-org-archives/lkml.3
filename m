Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaC1Opc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 10:45:32 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45112 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaC1Op2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 10:45:28 -0400
Date: Fri, 28 Mar 2014 09:45:23 -0500
From: Clark Williams <clark.williams@gmail.com>
To: RT <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?B?S2xlaW5lLUv2?= =?ISO-8859-1?B?bmln?= 
	<u.kleine-koenig@pengutronix.de>,
        Gary Robertson <gary.robertson@linaro.org>,
        Mike Holmes <mike.holmes@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Kacur <jkacur@gmail.com>
Subject: rt-tests 0.88 released
Message-ID: <20140328094523.7c9e040c@sluggy>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6K+QPWev35RVU+iXeTw4yNC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6K+QPWev35RVU+iXeTw4yNC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I just pushed v0.88 of rt-tests up to kernel.org. This release has a
set of fixes for ARM systems from:

Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>:
  - cyclictest: Fix tracemark output when the latency threshold is hit
    on ARM

Gary S. Robertson <gary.robertson@linaro.org>:
  - cyclictest: Restore CPU affinity function for non-NUMA builds
  - cyclictest: Don't offer --numa option when unavailable

You can pull it with git from here:

git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-tests.git

branch master or tag v0.88

Tarballs available at:

https://www.kernel.org/pub/linux/kernel/people/clrkwllms/

Questions, comments, snide remarks all welcome (well, some more than
others).=20

Clark

--Sig_/6K+QPWev35RVU+iXeTw4yNC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTNYsDAAoJEEersVlSw9Nz+gEQAJxpRiR8xsqaiTYvgu4mC9g7
fW7d3ZtERkvdVqPt9YRh3x6CdmQs5QGRoYcJOpknioohWr1WBUKqOmRD8D62IfDP
nzqEpfOMIuChyUdr5h0I/g+5L7//WjC1LS05hUyOWXl0l1LTGv1AOqtoEIe2u7FD
SMlvK00Y65V7VIrHXRy3B089dKWF3bDi0GRLX4Qwv9zYKj+QbrZbgRhRGyboEJgT
7okn7Ym0/VxHp4q3r4bxobWQ0nK+taoB1fJEHznBTxB/O/M3ceHpM0OzLLwhiv8W
6E90yG69olJZUofg0med5qpzDvbVHwXdiOzCcOpvC+Atcki2d+pybBbKLOBjWAWZ
hLhcnWa1FPFwEHDIK+3yy9PqCT3TPIjoeadYsqavHbQyMmyUGAkIehgv4l2B+Uwd
yrdrT1vyfGtNwJISsLLPDHPVsfNz5PJgX6jfzNQM/JNOtocairZ6At/z6lRHPtem
ry3t1oZMQx1ojURsGdX1qnuexp6CRHaWJR7nYADz4MImwxuQ1ydKI5Bm/TDI+tnD
iY+vMGJAWhl9eSgdgye7vScBYaqBkPJABofW6rFkqOo+v2XGX70lMxQB1Kwycg6A
LVbm68TKIElk4ZtY5ToDeT689FLxO/LUgciUD0fj3TYhe++jfWXDYRFdvBekTgdW
XwpGJf66dJqidYuGiqGq
=9zbX
-----END PGP SIGNATURE-----

--Sig_/6K+QPWev35RVU+iXeTw4yNC--
