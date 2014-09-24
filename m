Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaIXJH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:07:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36743 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaIXJHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:07:51 -0400
Date: Wed, 24 Sep 2014 10:07:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, boris.brezillon@free-electrons.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20140924090736.GC16977@sirena.org.uk>
References: <1411549019-12663-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Content-Disposition: inline
In-Reply-To: <1411549019-12663-1-git-send-email-voice.shen@atmel.com>
X-Cookie: Your own mileage may vary.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] misc: atmel-ssc: prepare clock only when request
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 04:56:59PM +0800, Bo Shen wrote:
> Prepare SSC clock only when request SSC channel, the clock will be
> enabled when initialize the SSC.

You should send this to the drivers/misc maintainer.

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUIonXAAoJECTWi3JdVIfQU2YH/0dyvuDqAXq2W4MJMrLYOVq2
P7hPHsdmW9MsKvrvhtaWmfXpT/9W4tqV1Pv7tHadR10QiDUgxZ/8r0KoyFAO2UAW
xaQLOCDf+GCnRdc4hrCVvJse7Z00ZhhH4UUbCKe9ci6JXEQ7Xo6EFrqwBcIQC4/3
YkzhjZ2FDOLe9W5g8tVZL+soTPHBP2hTeSDDk3AE+djZf4wO7iwZRxXkl/N1eEjf
QhSfsYyDWQtAcEz2nR8ny+FBz8bKR1EUKVSPK2ykM9pEf0eLGcmlU5qEjf1ZlAoK
cPF7uHv1WaltQmjTBU5RK9eDVwCmjDv8GfhEHu64nV0Le1gke9T+RCjoOrXgnvQ=
=nND2
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
