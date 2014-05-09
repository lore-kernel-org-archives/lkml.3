Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaEIJMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:12:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:48131 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaEIJMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:12:17 -0400
Date: Fri, 9 May 2014 11:12:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@kernel.org
Subject: Re: [PATCH] sched,nohz: Change rq->nr_running always using wrappers
Message-ID: <20140509091214.GM30445@twins.programming.kicks-ass.net>
References: <20140508225830.2469.97461.stgit@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uWA6ivsFTdIbDdzo"
Content-Disposition: inline
In-Reply-To: <20140508225830.2469.97461.stgit@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uWA6ivsFTdIbDdzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 03:00:14AM +0400, Kirill Tkhai wrote:
> Sometimes nr_running may cross 2 but interrupt is not being
> sent to rq's cpu. In this case we don't reenable timer.
> Looks like, this may be a reason of rare unexpected effects,
> if nohz is enabled.
>=20
> Patch replaces all places of direct changing of nr_running
> and makes add_nr_running() caring about crossing border.
>=20
> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@kernel.org>

Thanks!

--uWA6ivsFTdIbDdzo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbJvuAAoJEHZH4aRLwOS68Q8QAKgkVNNclSEUveI8Ve+pfd+z
mYQIMJAhB7sHE7byfMccMV8H3D8qTGrU1cZD+0xxIu1FynKjRdVDFXLOsbP/E+11
1KjlBCGf8SRI33I1DSyJ7Ub8uwjRhXk2AjfXt0KDnux5kXNiezN6socK13IUHEXi
i8T46tdmUxo6KEWFSeoBqRzRlCCqLTuXhUbpQnzgIK+TFgnOrOw4XQrabcsJaeah
9WOHcCOZS/lPdJim8iDaalBGdSKj8Tdk/j4niBqV7F7I6C8PfEMwkedLs0ETCT3v
z8B+rrVH5fOvMteDEoW5BXarPwXucewCS/alTooxgk5eTnbD9uaVbAheQrQsnRXk
85eyrFkRJmzJ+8hvUOg8Epbr2B8R2doZfABWxtrrtKONxlGHVQJHB59g0TxpcNjM
4GlRJk4/l6ixwDYz9WU4/n97YUTuwYG/rdb1lZR0uiahebdCA4AecNeEyiBZtBvP
svHbbxCdnRbFdXP6NwIojUSzlygb2F/CO95aVl182cKgZvRp8cJ02z76ozhwjAy0
XqnGlg667rMEB9suX3a22rO8Z/uZaH5P/0yE3khIM490rq8IxiVdI9PVJStmOLdp
bYcyMsIeHGSWACnbKiU51c2mOgJgiNTfFN7Aa9o99Qy6aXGxt5pbLR9HabK+6cgv
2N0nTnJKwHUkBtE5QDSy
=+8Sa
-----END PGP SIGNATURE-----

--uWA6ivsFTdIbDdzo--
