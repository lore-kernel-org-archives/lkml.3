Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaDNKAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:00:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57612 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750968AbaDNKAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:00:03 -0400
Date: Mon, 14 Apr 2014 11:55:53 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PHY: sunxi: replace IS_ERR and PTR_ERR with
 PTR_ERR_OR_ZERO
Message-ID: <20140414095553.GB28585@lukather>
References: <1397205483-24395-1-git-send-email-duanj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ri7MIv52hxsKkbzo"
Content-Disposition: inline
In-Reply-To: <1397205483-24395-1-git-send-email-duanj.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ri7MIv52hxsKkbzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 11, 2014 at 04:38:03PM +0800, Duan Jiong wrote:
> This patch fixes coccinelle error regarding usage of IS_ERR and
> PTR_ERR instead of PTR_ERR_OR_ZERO.
>=20
> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

You should probably send it to Kishon so that he can merge it though.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ri7MIv52hxsKkbzo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTS7CpAAoJEBx+YmzsjxAgGaQQALJqy/RUqsO0gqXnoEa/4wrp
KYpjmu9kNhaa+JXJyCSDHn9E0erY0KyczIEjM1DlIYOIOyKot6fSHrPIJ3MSk0ZB
BiXN3h+bBPZ//+9uq/4aYpUebRoJHBrlq/Ji6MuSiP8Yq9J/xBIK3yU9t7jquZ0p
5Bs1B1r4Q7so5KAkdNcNcN+O0MxBCHB1C+7LnlUFIdYohQYLDls3VdvUZn0BUlWt
COOzdYSRvYhXG8cTgqO4E6GxP9WhcX3GxWvh7qXfYrzWiBzhTj8jNKA+ROn55iJP
ndZZsSj5qOuJw28gnYvhSzqCAjRn9RW66uhkYOU1+YtOvhuldXPg2ESsuRC0Q2kO
eSKl4+h0GtejBF1SPLcSNI/y5CHljrFjT9NT4RG6OtPT2+fMrSw+e0ShkmfPg4ek
k1TC1h4bSQjuqmkq9GQV26k08dvf+QpsyyKigyQ8bCiK+NuPJVWClsnGzgwmMixw
9s5aUPwbZBthyuc8q6G1xdKPqPyxQnx+u5EviuojtY0ecYjIpSYTjppbiaI+fUlL
94HV2g+Hz6oJWtY5wgY+y2cVV3T0fB5IgM8YFhxhuO6WP/Cq6bF6kHwZ2hv5mHY5
cwUQvss5vEgm9RHK8bGNrFxo5Fk/eiEV8u2b6GCaqD1K+EhdPmgC+KVHMTsneTPK
JTjF6Phu8yWlrVq1g1NP
=d0qN
-----END PGP SIGNATURE-----

--ri7MIv52hxsKkbzo--
