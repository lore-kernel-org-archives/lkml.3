Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab3BSUNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:13:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46613 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757042Ab3BSUNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:13:22 -0500
Date: Tue, 19 Feb 2013 20:13:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "J, KEERTHY" <j-keerthy@ti.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: Re: [PATCH 4/4] regulator: palmas: Change the DT node property names
 to follow the convention
Message-ID: <20130219201315.GF23508@opensource.wolfsonmicro.com>
References: <1361164460-3251-1-git-send-email-j-keerthy@ti.com>
 <20130219124133.GC23508@opensource.wolfsonmicro.com>
 <DC88CAD03C0052499C1907B327FC63229BBB5C@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zi0sgQQBxRFxMTsj"
Content-Disposition: inline
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229BBB5C@DBDE01.ent.ti.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zi0sgQQBxRFxMTsj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 19, 2013 at 05:10:01PM +0000, J, KEERTHY wrote:

> > This must need an update to the binding document too, and probably any
> > DT files that ended up getting merged for it?

> I have sent a patch with the document update. That is the first patch in
> The series.

You sent the patches as unthreaded mails and didn't CC me on the
first patch so I've not actually seen the documentation.  Incremental
updates like this really ought to be done as part of a single patch
anyway, there's no point in splitting things up and as we've just seen
it can make it harder to review.

--Zi0sgQQBxRFxMTsj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRI9x7AAoJELSic+t+oim9Vy4P/1SsN4FXiFNPparS+18DWpsG
i78Ey0IYsIxET3LZwmRam7CaHRcVQOrR1ls8U44DNmcpClf4bzdxFQWQ202bteiB
0tEcx5LgvB1BbuYLiPdocVZzGHM9orSkv29j4LVUpWbYFa8DoOaOZhbQI35D4Rsf
prFxfFQq++qHmF+tmbJwBtYylg4vXD8OFfNiqI7deg7BTGhle6TYFsmwQjxemM+7
1cSa3zbaasGIGXWhCl+I35prec7b6qgRW77JRolBu1nbciPr83LyHul//tfPmJJG
E3HNJzxClLNtJIPs9HajxKpxtfmVP0/BeNpQH+sX2WsmdfNTAJz76egZIpYqpHqy
sZTAcDRFQhTMaN/0fe0wCmW/UvZyXVkN5nQkTey5TUajibV69qfGs9QO7ewM/irK
6eb8f+Rrs+dpYcPW3+kRRyMeq9mRBqVIAO2HTJ7abaXgOkCuiFDwjUmP/U9eu7QN
38PEBEC8Ri3bSlI8vIesogukqvwL1YBgOcHFtCHaTqQ7qgqJqCEe1j1yO4FJNem7
TL2XvxgfMBtRecmZXkqalhzmB5/utlR9+59JnKBnucM6xaAADscPocIKYfGMtqlV
/LaACWnumMCKiyzsPFK0KAKioEGt7/oKC4RCi6k8WIlA8eT5QRWrQiwMeDiB5E6J
QOeQkdu5kxpshlj0CmTW
=uKQO
-----END PGP SIGNATURE-----

--Zi0sgQQBxRFxMTsj--
