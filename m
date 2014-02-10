Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaBJVkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:40:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40214 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaBJVku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:40:50 -0500
Date: Mon, 10 Feb 2014 21:40:35 +0000
From: Mark Brown <broonie@kernel.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alok Chauhan <alokc@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Kiran Gunda <kgunda@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>
Message-ID: <20140210214035.GF13533@sirena.org.uk>
References: <1391705868-20091-1-git-send-email-iivanov@mm-sol.com>
 <1391705868-20091-3-git-send-email-iivanov@mm-sol.com>
 <20140207073952.GA2610@qualcomm.com>
 <1391766753.27491.60.camel@iivanov-dev>
 <20140207173207.GA19974@qualcomm.com>
 <1392051302.2853.56.camel@iivanov-dev>
 <20140210174738.GA31596@qualcomm.com>
 <1392061304.24621.17.camel@violet>
 <20140210202926.GV1706@sonymobile.com>
 <1392065994.32668.1.camel@violet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rWhLK7VZz0iBluhq"
Content-Disposition: inline
In-Reply-To: <1392065994.32668.1.camel@violet>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: Add Qualcomm QUP SPI controller support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rWhLK7VZz0iBluhq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2014 at 10:59:54PM +0200, Ivan T. Ivanov wrote:
> On Mon, 2014-02-10 at 12:29 -0800, Courtney Cavin wrote:

> > A developer doesn't have to have much skill at all to copy-paste DT
> > configurations around and muck with numbers....  I agree with Andy here,
> > early validation is a good idea here, at the very least, some sanity
> > checks.

> So, probably first variant with just warning will be good enough?=20

I'm not sure it actually adds anything meaningful here - if the error
reporting isn't clear enough on use then that's probably an issue anyway
and we may never even use the default.

--rWhLK7VZz0iBluhq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+UdQAAoJELSic+t+oim9zwUP/izudJhWCEfA5lGLy3AIuXDo
jGKqtDZrVXqoAY0sLtpCCWRLz3lJxfy/U6+LRxpiFJdCMun8im0We0kgWL3MTaNj
wMZ9xBAXOrGxpFtgB7wmC4BnQsUXMmmaHRUBre4pRfPtjGbPtN2KrFsApehgR5JZ
LlmYB7RchVlQQvWUE9ADNfqAMZG+AJVGYRxGXMXELibUr24614zE/VFpbRRxi+8M
IEKMzmHxnpyM7MxJnau0Q/QMgnTm29iLadaQz8ge+1EDjgCuRi9XnKbnknj8lYui
Y0Qrfe6uAjobIL/U1CsvboUd2HlOko3b+y/iPDkqto7DkWf6ieJ4F0ZrXCVbs8HB
y1qPEqk56BdxD8Gdaltz5paiCRQ+u6uISaj3fPa8XrVqlbPDsj/MrGBxkfqC1Yii
Bqh//ytyvZJy9zv5/R8SUm9Cu1M/gVRc020Y5vJgDJBxmWLqJmDiFmeS4EdoZjj4
Xu6p8MzyNDgLxgQOWBh1Cqn1GZSJWVBCy+iaxJfr8xh2z39L3Vfe61vgUBwqM6Gd
rCmyj3CjxpHOjB/7MwQhamiszM1Krk0SQLr1V8PsxTWadYsB4Y5A+bcs6vjvQI3s
oVCGxRWfvIs/U434Fllv45wWMdid/7PoIXOpxc0RavVemzyBh+3rxV2nH23/Fgpp
o/hRQ7c4bMvwVfWaaKBe
=P01a
-----END PGP SIGNATURE-----

--rWhLK7VZz0iBluhq--
