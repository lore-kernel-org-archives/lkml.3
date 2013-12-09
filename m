Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3LIRWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:22:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56281 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab3LIRV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:21:57 -0500
Date: Mon, 9 Dec 2013 17:21:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20131209172135.GY29268@sirena.org.uk>
References: <1386573859.5508.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bVncxp9+I3apAFr+"
Content-Disposition: inline
In-Reply-To: <1386573859.5508.0.camel@phoenix>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: pfuze100: Fix address of FABID
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bVncxp9+I3apAFr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 09, 2013 at 03:24:19PM +0800, Axel Lin wrote:
> According to the datasheet, the address of FABID is 0x4. Fix it.

Applied, thanks.

--bVncxp9+I3apAFr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpfwcAAoJELSic+t+oim9eJ0P/irIkkAhah0opH6On3y2jxFg
kj7s0qmYgxFVJsqqgcOwk2v28Duq0xMY62cyQvucu492B9+XcZZXY9j+KDv2rlfP
ZbJClh1aecdkk2/A6pJqqsRlzEkwSizKYb78yKTkxmv1p3qy+eOQ0jwhJpR/i4HN
bJH+rQqulcf0gPzk1I/cOOY21mU3CeOUEN9dm/PO0FEjmxJNdj+r9sOAeZ0AFVB9
WTsrmR/QOKyXa24tWX/Ppl9YA31TpyDIu9sElTyiA99lQZEiubS975cJ+YY/oXqt
Ht7NIMvWnY/OWr1fzJZ++xCGCHBgQf9tKMc3K+mYNK5omak9i4BPjFesozr2sBc7
aue0TS8cAV2Twb8T9GqupXhoJAA1JcUtcOEey0PUbKFRl0QJITGx4TRsgrGd1Hgz
+mtO7ocDhbI24jt+Zz89Y173H/uQovG9JrhpAVmSdDaiPQ+p/TtTEWlAK09o46Kr
Hzjc3tQVS4bJIZ+R70Sd0G9roSPaZaS110lEM8kLWaE1d58qCffGZ+gD9VZFj7MS
rJS1gKMWJGqn7GhyG2txC0NtreOagqgGVuvlvy6ORSBfuiYu9JEefVuF11LDl8JT
FGi52fMmQIhfpUM1dWXILxvQotH0FdZCZD21iVS5WnfIIgZObTHPtwrQRytiAFpI
YBScNhsMAvmJZIQ9kyvT
=eMvE
-----END PGP SIGNATURE-----

--bVncxp9+I3apAFr+--
