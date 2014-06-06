Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaFFIX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:23:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:56333 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaFFIX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:23:26 -0400
Date: Fri, 6 Jun 2014 10:23:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] kernel/locking/rtmutex-tester.c: kernel-doc warning
 fix
Message-ID: <20140606082323.GV6758@twins.programming.kicks-ass.net>
References: <1401992965-11256-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FQ9/qgh0YgB02Feu"
Content-Disposition: inline
In-Reply-To: <1401992965-11256-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FQ9/qgh0YgB02Feu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 08:29:25PM +0200, Fabian Frederick wrote:
> attr was added by commit
> 4a0b2b4dbe1335
> ("sysdev: Pass the attribute to the low level sysdev show/store function")
>=20
> and is unused here.

I think tglx has a patch killing this entire file somewhere..

> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  kernel/locking/rtmutex-tester.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/kernel/locking/rtmutex-tester.c b/kernel/locking/rtmutex-tes=
ter.c
> index 1d96dd0..abdc7d1 100644
> --- a/kernel/locking/rtmutex-tester.c
> +++ b/kernel/locking/rtmutex-tester.c
> @@ -266,6 +266,7 @@ static int test_func(void *data)
>  /**
>   * sysfs_test_command - interface for test commands
>   * @dev:	thread reference
> + * @attr:	unused
>   * @buf:	command for actual step
>   * @count:	length of buffer
>   *
> @@ -334,6 +335,7 @@ static ssize_t sysfs_test_command(struct device *dev,=
 struct device_attribute *a
>  /**
>   * sysfs_test_status - sysfs interface for rt tester
>   * @dev:	thread to query
> + * @attr:	unused
>   * @buf:	char buffer to be filled with thread status info
>   */
>  static ssize_t sysfs_test_status(struct device *dev, struct device_attri=
bute *attr,
> --=20
> 1.8.4.5
>=20

--FQ9/qgh0YgB02Feu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkXp7AAoJEHZH4aRLwOS6mxQP/09N4Iu3UQa3CI3iyPnF3/pb
fEOliNqwPKMZvGMWceHQkUocx083yau5YLS+WPt6BUraSEowK99n1Nc0KUuxDPBY
m1JzscNEVl3Ln8SZ3qlWEypLZzhFVx7of4W/p20MtLhM9SquXkKcF0JFIogb91Dy
lEIMo4HZFT4Wmy6WQK3lPz0jYjUiSnfaiTvjDaugEaNCz5EnVHM1JneZIln+91Jw
F70+WUkrxUgYSe6Cdq5qzd6vZbW19pdfuj5WWfopbQ3aANU/OexdUp1yx8UR5JKW
/+FB+dS7WQX1A5w1FUiyM1GVu0CUIbYxUYOKetX8MTRzmlSrQszk47IAaSGeCZeo
FtGYrNJxLawp1oHv8jSdYrQKmz3a4tDmKclZpgcA1/jY4QI30uscU9/COZLZOl9y
/StGbtbTAvW04GtyDv4WxGRBU2C/1kmEwX4FciFM3o9Mbe7apvcN1ifYqfFeT4AJ
b3eEvnVxtdU6Rngd/bX5Rw9MkQXJfuuy4K6Jh9Nrd3srlORj7YOMB0sMS1Gu8hxI
p09QKhkd7HPZa2f++cBbiYHa7MMDGC25yuMFd2s5lSSdyScxRF/XpUFKrZHDbeB8
9MIeF31DUF81H/Ual6m4AIkp472PChtvZGz9GBC8m+5opJ0rhWVF9I1AXW4xMHmw
DXZLTW8G+Elc5UNpSNY2
=n43f
-----END PGP SIGNATURE-----

--FQ9/qgh0YgB02Feu--
