Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbaCRSfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:35:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45076 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaCRSe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:34:59 -0400
Date: Tue, 18 Mar 2014 18:34:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>
Message-ID: <20140318183453.GL11706@sirena.org.uk>
References: <1394187052-591-1-git-send-email-k.kozlowski@samsung.com>
 <1395164052.24909.11.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tvdx/ap0jMH9YXQh"
Content-Disposition: inline
In-Reply-To: <1395164052.24909.11.camel@AMDC1943>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 0/3] regulator: s2mps11: Add support for S2MPS14
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tvdx/ap0jMH9YXQh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 06:34:12PM +0100, Krzysztof Kozlowski wrote:

> Lee Jones in his pull request [1] put also my changes for S2MPS14
> support in MFD sec-core driver. They are needed by this patchset for adding
> suppt for regulators on S2MPS14.

> Do you have time to look at these patches and apply them if they're OK
> (or ACK them)?

Possibly, though we are *very* near to the merge window.

--Tvdx/ap0jMH9YXQh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKJHKAAoJELSic+t+oim9CUoQAJQNE93VJz/xQ0HEBbRfHjmG
yHbbzd0iLrTos0QDbDf8oZei1OWR8o5QKQvLldvC/YUbEi0q3INKHS2U1ZTzrKGp
EFrgVXKYrYVF576PksPmH3QYIQe+VBeDACwGYM2Tx0qE5u8gTZQp7QkKv8oM5LPm
27sGikqCajJ59dutAI3Fv7tcLNri4y4g7q9uNR5FluNSas5qSmoDd2tNuqgDoo13
N8cOa3GmQGNPQWsKKXlSIRr//n2uju+Hl/SB6LwXRo+/U7MPLp3DCeeVZnCRTb7j
/wv1ysGL0IPK0TGuWIjT+Pm/yTVg9zFzIpQT2NTMqOyL9LLhZxsLMYjl7JUjO10D
int/RKUK8S3304ea0LpXbFbHu1CS7UvFDFPgqjfVwHIr24Bt/8F5BxFd6RFhJETR
oPq6K14SMv1MGNXJMTxqnO/vGrUUGde3+OpREzTWxus+YPa3DskSyjMkCVlXHlBU
r46J+CTkmnerlkXQrUqf9ZmkhMME/geb7L/FAPBrUPv+XSDperKq9pAanR+LS5kF
M5C/PZHbaEDR/lTyjjuNDxYCiJGy+JETOVcauokyo6ixkMuYr8S+o6nUkzHTXYzh
YtT1mSnZm1FXnCgjmEGeNqpKIDKpgOou4imoNi+JefnZ+kzOO5QXZF2/VYEHJYvQ
hAEkxNijNyKB/q5chZaF
=eDkE
-----END PGP SIGNATURE-----

--Tvdx/ap0jMH9YXQh--
