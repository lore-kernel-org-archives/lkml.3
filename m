Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbaFALAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 07:00:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49701 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985AbaFALAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 07:00:05 -0400
Date: Sun, 1 Jun 2014 11:59:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Message-ID: <20140601105948.GE5099@sirena.org.uk>
References: <1400838828-30998-1-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PtV1LuJoEDsm7sfb"
Content-Disposition: inline
In-Reply-To: <1400838828-30998-1-git-send-email-s.trumtrar@pengutronix.de>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi: dw-mmio: add oftree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PtV1LuJoEDsm7sfb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2014 at 11:53:48AM +0200, Steffen Trumtrar wrote:
> Allow probing the dw-mmio from devicetree.

This doesn't apply against current code, can you please check and
resend.  Please also try to avoid making up terms like "oftree" - OF or
DT are perfectly fine.

--PtV1LuJoEDsm7sfb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTiwegAAoJELSic+t+oim9CrQQAJJta+RKmLRys10dn8jRERbk
XCfEjIHeKs45C8YzbalbVFIIEnIgN+eq6LQ2FrZxYgXt6AtSXCcje9Juc1y08J17
Q03XaLZg092zaO26THZiM+DnXUrcP8xcX6KXMnCJ+ztySlggJZvPdIOBNmbMjIRM
/MTFEOCHX+2zcanb+dMM0p2TWRpQdFyKziP0MVcHFXq2KZ05DekFwdw8/soTuxAX
M6dM84Z2QlzalWqhNcxR7m7QwNf4TXAx/LaMXZmDTen2/okfOQpRFant425o6jcJ
B9bk+MW6XWvOTEwfGecuEv9A8NHesJBS/SPdmX9Mo2mCoRevzuJfi6YGIEAXDOYu
K2lfTFv8K/eNHiN3Mt7J3nT55JMV/50t34AwuzPJ3MUfpv0BiDgcjCJVwHm7+tYl
ujcF8O/An2BssFHqztcaJjBN5PIpH5XYz7stK5g672/C0dMl33tMAbDuwTwreXtD
6n267R3gJmYDLJS+BQmfkjqbjmv+RZ0SzvE6TNLiTE00U2eu4TPMfisJva/+Qex2
YLd11Lr3LUQL80sCsL4UeLN32oVUfO36x5o0ZklnV+c0rOhpArYvi8xS92QW3/cR
CUwjvgv/OS8BPDmelDJCo4OvnndjAbPNtfpUzKOwys6YyDUFTLqWDShTtyKVxq7Y
Zknfdt0OljpfIw+a3zTy
=zo+x
-----END PGP SIGNATURE-----

--PtV1LuJoEDsm7sfb--
