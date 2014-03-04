Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbaCDDDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:03:33 -0500
Received: from ozlabs.org ([203.10.76.45]:59404 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935AbaCDDDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:03:32 -0500
Date: Tue, 4 Mar 2014 14:03:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>
Subject: Re: linux-next: build failure after merge of the mfd-lj tree
Message-Id: <20140304140318.06e7a535ed06e9432e5df7d9@canb.auug.org.au>
In-Reply-To: <20140211132552.68b0802fd8742c6d72dfa738@canb.auug.org.au>
References: <20140211132552.68b0802fd8742c6d72dfa738@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Mar_2014_14_03_18_+1100_q/tY3wteNzZ.8xcL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Mar_2014_14_03_18_+1100_q/tY3wteNzZ.8xcL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

On Tue, 11 Feb 2014 13:25:52 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> After merging the mfd-lj tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/mfd/tps65218: struct i2c_device_id is 32 bytes.  The last of 1 is:
> 0x74 0x70 0x73 0x36 0x35 0x32 0x31 0x38 0x00 0x00 0x00 0x00 0x00 0x00 0x0=
0 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0xf0 0x00 0x00 0x00 0x00 0x0=
0 0x00 0x00=20
> FATAL: drivers/mfd/tps65218: struct i2c_device_id is not terminated with =
a NULL entry!
>=20
> Caused by commit cc493e30e3a1 ("mfd: tps65218: Add driver for the
> TPS65218 PMIC").

Now that the otherproblem is fixed, I am getting this one again :-(

> I have used the mfd-lj tree from next-20140210 for today.

Again.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__4_Mar_2014_14_03_18_+1100_q/tY3wteNzZ.8xcL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFUJ7AAoJEMDTa8Ir7ZwV4t0P/0O+PrA83PRezbk4AXPzR0Ii
CHeBdAwAp3RfwuZEWMbhyCIYPKWeOP0fp821Gtve3cKcatY43L7PchjzAJzHFgUh
YCSVOwHMUQbWIytLiBq+PyxJTnd83b5WBsOeMW89rjMHhvpeCHwU9RX7wAYfYcIx
eX2Ekk6QqEn6bXNdGpK0UN1Fwn3EZlCw9WMCMaY67AuHMZhzVUhjKovKPIO3vUqZ
qnzgDFzvkFVOrp8twPE0b/RjK2OibtsKTs70yfrZHR8rdx70b+COd91gXN0jyyGf
IeGSCBxLudHHt33PkFMN5k8nl4urQjpP0envY+u9T9Pc0DcHXjmV3LMNYAA9UDVT
EFSyXpZbhYVIGkmijJnurS1n8YMx2bCYpzsyOJmokLhgDKQC6Rgj0NCfimxmU6ii
BhDklt0fOCnpVzYKR/OHHcu5YoYmMFlTDFT25r+SVuS8Xjld1yrXiJF/y9J0SoXI
0BWqabQhF8ISmSsz6BAr69HCYEveZcPLKqVnd8L7Pq10amgJpuM85CEUiLITPe2F
ZhbVaFBDf8MniyMtdwRU8OAdt9ES6h+RbXzt4DAYpe+2deOtwqmoBwOqvJVtrL5W
GaPo5MDdwtqdM9MKBdGuMERvEPatLx7JSOeQQ69RqWZNNwoUh5pD8q9UwWKe8DMx
CP+3zJK8TBFfE8yEp9L2
=AJty
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Mar_2014_14_03_18_+1100_q/tY3wteNzZ.8xcL--
