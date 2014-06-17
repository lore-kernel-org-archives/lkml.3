Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbaFQOrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:47:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46004 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932972AbaFQOrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:47:01 -0400
Date: Tue, 17 Jun 2014 15:46:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140617144604.GW5099@sirena.org.uk>
References: <1402675045-22460-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T06BQBHjKAm4eKdv"
Content-Disposition: inline
In-Reply-To: <1402675045-22460-1-git-send-email-chiau.ee.chew@intel.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi/pxa2xx: fix incorrect SW mode chipselect setting
 for BayTrail LPSS SPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T06BQBHjKAm4eKdv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2014 at 11:57:25PM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
>=20
> It was observed that after module removal followed by insertion,
> the SW mode chipselect is not properly set. Thus causing transfer
> failure due to incorrect CS toggling.

Applied, thanks.

--T06BQBHjKAm4eKdv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJToFSpAAoJELSic+t+oim9S3EP/j2zdrpytsWPnlPw6umZOjtg
ZIlLVBN6obMRSy3EBtIfxHTA+omTtM03GXPCY1rdVbhNiA+PksCvj0ijL7Lv3Cil
1fJTYfCdvdbvuK7CvaUCRDqLLL9tPX8pbBEoe5o4UeRWKM9AG3qeqbGbFOGTCDVr
7HL4/6usn/xhHevdivLpD1vlR9zF0IKHuN7YRempm08vEDH5nL3Ren4E16tbECnh
bjUMtoCuy2V0pAfdNQMoGjcfw/zDiHyTYpkn0iwR46wOpuhyozlTIWftNT92X1d8
+Zsp1GjEwDBm4py6BkUAVq8KVxk0QKU6YMB4F3ij3euKD6Yqgk3ohOjxPVXBVPau
Ol7qc64+RQmM013d3iO6cVKHaJktRy8X7FSkGNq1pOF6Z48NCfKremz43ErB0QjA
RiAj/9E+ZJRLYonhk4QDCm56iVeYaPrPf2L8TchIwcwJM8uNc3nZef6a/RkFVfa3
ymziccSh7ibPkukhndnUeQgUXOVpQx2AVmLnCqfyn1U2nVwfRkDmyywYdae3nLq8
WouWCDL8HsCmt6w4LUuBWLck8QaRRRwMIhCtjm93GSucb65b5lxwC630bYJNoDXB
ACLxnoH1X3HYUL47+8EJUqj4nWNpbl1xU4klQoUxozMmFdrQt21cdO1Rsk9xKtjo
e9lMlXYlwRtyzZ6qDeLj
=FBcD
-----END PGP SIGNATURE-----

--T06BQBHjKAm4eKdv--
