Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaFBMgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:36:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50830 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbaFBMgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:36:35 -0400
Date: Mon, 2 Jun 2014 13:35:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140602123522.GB31751@sirena.org.uk>
References: <1401738379-4107-1-git-send-email-chiau.ee.chew@intel.com>
 <1401738379-4107-3-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <1401738379-4107-3-git-send-email-chiau.ee.chew@intel.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.174
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] clkdev: Export clk_register_clkdev
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 03:46:19AM +0800, Chew Chiau Ee wrote:
> From: Darren Hart <dvhart@linux.intel.com>
>=20
> Allow spi-pxa2xx-pci with common clock framework support to build as a
> module by exporting clk_register_clkdev.

This needs to be patch 1 in the series not patch 2 since the change to
the driver to use the exported symbol depends on this rather than the
other way around.

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjG+HAAoJELSic+t+oim9HHsP/08oE9na1O2jrrSlDv/FlZfR
jHpg1GrlAsBY3fAAZ+yjzySmCtU7Iu4poyF9uCOoJyVNXMvZB4SCKoQEKyeHeIN/
FEemINkUJy8i3W/RFbbhi5Gu65LX9fsirHPtzfpM7Lt/ENZxjpnccOfAKeLyc3/G
2FNh6yPC76rW7WSxAZke3pVP15cSN/F6bN/5EevJytW+OyfBILfRMpD7NQ3We3oT
Z3NfSfHMv19nWOOWunxnJPXCBE5PjgaxntclPPxVDBkiZSQbmbsHgw9QFMfXbPx4
5Ie4DGLB4PbNUgYaaB1O2NwnNWs5glD/w/O259EFE0fpKNcpeN1n4lYbRjyTrTx+
HS0yA7Oq3nYWGX9z9N4IOgsiNll8E2q4EqCI4ntMwkcBTU2kzBVq6ZDoMgTVq1SI
r8Im5ToQQpABmiL3ji12QNSazeR2rwQcoAlPSRD6A+Ca1aXNQEE0/U8+6gqL45eZ
jCEpY0LGDsCC+vco0mOPs/OpplMcy4Q2N7CjaPQV+dJyAhFmQMNMNY2hufK62Nzv
sg+rYtwgk2JF1f4bF+oz+YFSV0RrAM2nSszgbfPctRvKud/Ju2exLkZLxwt3O+Dp
hro2+q422BhwtdOTHnqmqmOF78xpcef2Wh1b9WAgEsWPc9HE8YzwYoP27bmuURfA
k78vRy+ZGFHwO3deWtF+
=EOo3
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
