Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaCJRLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:11:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47786 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaCJRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:11:09 -0400
Date: Mon, 10 Mar 2014 17:11:03 +0000
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140310171103.GQ28112@sirena.org.uk>
References: <201403041355.s24DtT1K045945@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IhaVjqNYhz9BDJmo"
Content-Disposition: inline
In-Reply-To: <201403041355.s24DtT1K045945@swsrvapps-02.lan>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC V3] drivers/base/regmap: Implementation for
 regmap_multi_reg_write
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IhaVjqNYhz9BDJmo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 04, 2014 at 01:54:02PM +0000, Opensource [Anthony Olech] wrote:
> This is the implementation of regmap_multi_reg_write()
>=20
> There is a new capability 'can_multi_write' that device drivers
> must set in order to use this multi reg write mode.

Applied, thanks.  Please use subject lines consistent with the general
style for the subsystem.

--IhaVjqNYhz9BDJmo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHfIkAAoJELSic+t+oim9IYIP/3h85Cm49rtCodbRYCY422ve
axY2cUOZonRDX6Fjb6b2/DlWMrkZlWYPaXiQo8+AFu2jwhO6ktE2E/oKRa55R8zT
3nIUpT1+vkylGSK5rT1XArgRXqOs2dRrnWSwW8i7czGo94NofxAd+QL23ytyyoH+
ZRwbu1HSAIkhNWBP/wybJzcTAvY0fwbyLiCH9Sk6dpyXJjxo6hM1tWcS/XUZz5pL
pPkln9ZyWxAzQ7DuUUwbRp24QSj+J3JRGMBE7Jg4vbQiTnm/yje/oAxAJzAq0ED2
BnF0cVejk0YJ+SzHu8Pts+dU+BK/Te11ENdWO2jo6fYsOFgmr74dA5G6JvJCWMF/
dUkUPJx8J0KGBzKIp3MftoNNFcf0vjuzfcOKzu7CpJ8FNN/z/Ydk+C8+WMp+FjSc
U3mxMSOCbYupIh9LWfMu4wJq3b5bBnZgtp9bguzAV/19zI3RSL+bkzhC+T1padrw
VCJqCbS2bCKNcklTxV3GOHbGEqV8ik9tdSvC94P/oVJJWMg5wPgEhFYyUgiY5yoq
/zWTcbCPxA7Ynks9pZgL6s6xLftN8UIJK1V26H5HGEE67n6F81ESg/tSyENIkaD/
z8utjtDkAnvXq9T2X6pSPoSrZJYpcY1o5ctp2XE7CVMfz1qcyE7j15TIJnrEs7h/
TtGkgtwHS5kVmGh53hQC
=/OML
-----END PGP SIGNATURE-----

--IhaVjqNYhz9BDJmo--
