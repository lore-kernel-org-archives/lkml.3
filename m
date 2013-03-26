Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3CZWFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:05:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59166 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3CZWFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:05:46 -0400
Date: Wed, 27 Mar 2013 09:05:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree (akpm
 and block tree related)
Message-Id: <20130327090533.72e7cdc6b3420da9c241a8cb@canb.auug.org.au>
In-Reply-To: <20130326144332.6307a66b95268521e89f95b1@linux-foundation.org>
References: <20130326170554.f9f113fa24a1e5ec6d5d1ee6@canb.auug.org.au>
	<20130326195523.GB24935@google.com>
	<20130326131051.a47fe83fdbdab4b824394f18@linux-foundation.org>
	<20130327083535.22ef6a9046f4b53e161481de@canb.auug.org.au>
	<20130326144332.6307a66b95268521e89f95b1@linux-foundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Mar_2013_09_05_33_+1100_pF94xY9Y.AzlEi5_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Mar_2013_09_05_33_+1100_pF94xY9Y.AzlEi5_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 26 Mar 2013 14:43:32 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Wed, 27 Mar 2013 08:35:35 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
>=20
> > Yeah, though a hint might be nice.  It looks like these completion
> > routines just need the batch argument added, right?
>=20
> yup.
>=20
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: block-prep-work-for-batch-completion-fix-2

Good hint :-)

I will add these to the akpm tree.  Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__27_Mar_2013_09_05_33_+1100_pF94xY9Y.AzlEi5_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUhutAAoJEECxmPOUX5FE49UP/30DTAkgKbJk5n3XLJfON2YX
h5943BH/6Adwlf+vHPjnxlfWp9Qw0nSK1Ojimvx5nWBaGQe4zPynessE+764c25R
VR391toe/Z38d1C06dv+HgoXd18vKNofKxRabZvVqE5KVHvekpBEOT8dwto/OaPp
2IrPKG7TD/WeYXDXXMEcJFG4OQ5XnDSAkA0rDatob0pKp8wZgUfxsHA7ljLpk2aJ
t6cQMPous4qKUrVMOf03/jldSskn0GO6K8CWESrChcBpKs1iHArSAtfgBW3TY5/l
2YPrfCxRQMRzvqEbPqIZalCI0EDzzHTi7a6Z+RYVTWg62E9OVJv+NtjysTA9gzVx
JTYUvn/KeoXL13d9w8HH8aSTSSFPWNOSZCou97A0rNzzfQ523PbJ0tUXAKBR/xWO
yggbsYb5sRdcuGT3jIfHaeItW4vbyr2k+dAcqKi8kdwMeNszO1l/fYuhsmIw8rLQ
b0ARuETWJp91fipUq1CdVWahWc6vtthLEqmIvRh+m67mYLtIZ7Fs7qtx6Ccc+paz
FhIez4r74vLkcjtm3ZazdEg1pU78nNP5bSJQwlgZbS0TyxD6KgETEDKPT2iC5Eo+
5zJFGIuQorjG8/cmTg8camjdL6KaIWsvFa12IZd53zYYl9l8Ij9MamwqgLUtYre5
uaTNy2TOdGlfrHOwJbAE
=lGzd
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Mar_2013_09_05_33_+1100_pF94xY9Y.AzlEi5_--
