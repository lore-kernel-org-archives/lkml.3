Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaE0Wtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:49:32 -0400
Received: from ozlabs.org ([103.22.144.67]:43159 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbaE0Wta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:49:30 -0400
Date: Wed, 28 May 2014 08:49:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: dedekind1@gmail.com
Cc: Brian Norris <computersforpeace@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincenzo Aliberti <vincenzo.aliberti@gmail.com>
Subject: Re: linux-next: build failure after merge of the l2-mtd tree
Message-ID: <20140528084916.4e05cf26@canb.auug.org.au>
In-Reply-To: <1401187203.1304.125.camel@sauron.fi.intel.com>
References: <20140522153047.62c1721c@canb.auug.org.au>
	<20140526174225.GC5241@norris-Latitude-E6410>
	<20140527095942.0a071e63@canb.auug.org.au>
	<1401187203.1304.125.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/s0JmTu3E.mEWT=h25Qc2W6d"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/s0JmTu3E.mEWT=h25Qc2W6d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Artem,

On Tue, 27 May 2014 13:40:03 +0300 Artem Bityutskiy <dedekind1@gmail.com> w=
rote:
>
> apologies for not informing you about the onwership changes in time. But
> yes, Brian takes care of this tree now.

OK, thanks.

> The URL you have is technically correct, but it is better to use this
> instead:
>=20
> git://git.infradead.org/l2-mtd.git#master

I have changed to use that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/s0JmTu3E.mEWT=h25Qc2W6d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThRZ4AAoJEMDTa8Ir7ZwVUjMP/3AhMPUU9PmRv/vPIe/hMmck
0k1NUXxQaa0/HtvYMVj08LU0aKal+dxJ+jbQp+XQJcAJE1nD3B6F8V+Q2WOTeJNM
2lBKERIksWYXFYR1wJVC9HqYm+OwmLOkXNSkkku5ZZK9tk7qrHUk0SNxjlOGJxz2
FyxTckyQXcdB+aXdFZHXAyHRXJSp13L0XdYPfnP3IC9lxwoxa2FxG+TUIdUvz1dF
AJgb9Wr92qU3LdsF4BQlg+fX2Dj+FE/ztltckvSkewkESDENKZx9Mjh5IN2RWIph
e7eaof+CzEBf1A0XgyVelOMWMt3EWKpEXG2qrQqctb75TrjIiLdTAx11j2dGfoCL
XZn15ADRDqV3zMFRDTOLP8FfYiDAn6AcgbzgC/IqKZE4uQiZbKvdkCqkBbNkEK1A
0n7g0zVwBt43OliOPZxsEYrJPJ8fo9qfY7UW+25m7iCJ2qRujHLaTZPMeizrnA3/
zyldnbxbATttECYZpC3slc6QPW0CdX8cFjg/nDoHxWCjrbholy6SdQIhQAzPVS7B
zNgUXuzqRJtxgEfwFMYKx+mlA+4CLwxSbve9GwyAHJWVDOpLhqskDvw4hAZwDUMp
aHOlZGc/IVfpRGC399GktIWXY62y4bxeSgMUCRX/5wz/oMZ6UCYA4rklCglTGtSV
3kV6HHz8uPi7bQ1nLfLq
=h9VV
-----END PGP SIGNATURE-----

--Sig_/s0JmTu3E.mEWT=h25Qc2W6d--
