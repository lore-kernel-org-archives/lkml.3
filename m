Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab3EJCOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 22:14:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55407 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757878Ab3EJCOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 22:14:48 -0400
Message-ID: <1368152071.17344.5.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 22/42] sched/debug: Fix sd->*_idx limit range avoiding
 overflow
From: Ben Hutchings <ben@decadent.org.uk>
To: Namhyung Kim <namhyung.kim@lge.com>, Libin <huawei.libin@huawei.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, jiang.liu@huawei.com,
        guohanjun@huawei.com, Jonghwan Choi <jhbird.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 10 May 2013 03:14:31 +0100
In-Reply-To: <20130423215207.778285571@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
	 <20130423215207.778285571@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-lDzNZ5Whbg+gtP+CktJO"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:4022:769e:a966:672f
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lDzNZ5Whbg+gtP+CktJO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-04-23 at 14:52 -0700, Greg Kroah-Hartman wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: libin <huawei.libin@huawei.com>
>=20
> commit fd9b86d37a600488dbd80fe60cca46b822bff1cd upstream.
>=20
> Commit 201c373e8e ("sched/debug: Limit sd->*_idx range on
> sysctl") was an incomplete bug fix.
[...]

It seems like both these commits ought to be applied to earlier stable
branches.  Or was the lack of range checking a regression after 3.4?

Ben.

--=20
Ben Hutchings
For every action, there is an equal and opposite criticism. - Harrison

--=-lDzNZ5Whbg+gtP+CktJO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUYxYB+e/yOyVhhEJAQrXvA//T4n5rcYrYh8OWcGD9XYQbCxeGWdVHqMZ
s8lm+LS/4yk6Enm4NWy6cFbak7083lF6yKIgURoMdJHvkA6DuUihpYI2nnGReWZb
J0prg93S3EKhxIwjWd2JUdIalOqcv7mp5C//7+15Xex3ExBSZ+YDINFQujwOKJp2
8pkC/PgmVr9/YnxCvO50JHrURKIgyzm6naRsBEpBaSsNumKZY115KIA8InwKulit
eRhmsUhsMLnXKZPLxgBpXHDIUwcUh9C6YwV6nWVXoa/xj1ZAy1WUbRqLNzlzrseq
ave5ZXWmu62M1+I9GB1X1eFoiPL5bPVQPM+REJr4xeocl/ikc+CuPW9wx/nrr2U0
usD9rUPW8YzmKYeUgQZ3oI7e7yWHJIm1eCdYGIJsyeSS2JZTUjz0HpHso3Lz5IFG
1yINbXHDcILhRa3HsfW2hhIe13muGtAoZ6RcXne2QDnGT3iZhnmmhS7YgFq6HNZn
3sxx1O1d0bd2wnN7ZRuiRMuDxBlnyVgh8etLQUQIsGTHFdSTVJMFPN8GdohoKYlR
kamyR2YchYzblSfuZlaQZHrEP3hPhumQQOPFUZLIV0EgFsEaK6rGnT3p3DVz7FoM
VqfgM67jSYDjXlxIgZ/67Dfnlcb7QL+zU57Xk2tljbSPUwy+ppTGRflINC6JYf+4
DTpib96rLX0=
=2IQr
-----END PGP SIGNATURE-----

--=-lDzNZ5Whbg+gtP+CktJO--
