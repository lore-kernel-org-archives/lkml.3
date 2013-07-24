Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab3GXOdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:33:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50188 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab3GXOdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:33:43 -0400
Date: Wed, 24 Jul 2013 15:33:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Message-ID: <20130724143340.GE9858@sirena.org.uk>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
 <1374602524-3398-23-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GEvKNWSRjg+pdNz3"
Content-Disposition: inline
In-Reply-To: <1374602524-3398-23-git-send-email-wsa@the-dreams.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 22/27] sound/soc/cirrus: don't check resource with
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GEvKNWSRjg+pdNz3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 08:01:55PM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

Applied, thanks.

--GEvKNWSRjg+pdNz3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7+XAAAoJELSic+t+oim9B7AP/1V6qJDTu2FrInChS7/lLxDJ
CMxt5d8X8wWCa6VqkK5hGbLcFJ6H5UIgC5eiCMJeiO8Bi1mgf0Mh+Leeqv9HbnUm
zumLX4FrLoYHgHfVqcJH5aPhhyoS6atgdoHllVPO1qOhcfrzSY9Er0D64b9jINKp
QYx8/xERfcS7wQPv5bGYQsr3l0Kt/dI7hP/ERy9di6edPxht/HfGPmTJf9YyE9l5
86YxjT9SRZgTXWeZ3USjwmlQIVdzDMkg8/zxjgUMvuJteQzR9VlbXa86Fu3adcr6
3tfDykoiBHofe34Z5vRkkYmA/1k2CQ0Pp94BY0GVhKc5qeIVOowOKwj9Sjxj8BeQ
Igu+uKvCVGDZ3iBPtlRnfRu5lumnHNrPjWvBVeKn2N/muUuYrcogfiXvFUx1r0Br
V2py5jONaKBbU9Tkc8kI7T1m5G1H+Iy1cbKtpMrIC4ZXYqNfSMvnfh3ynMHKXc+V
NV8nl3zX9f77kjhS5kf2mxzYjuyopcsWOlxuVQjd482/3yo9rrEESEOvYm8V20Gz
qaHp2KSl2nHk0GKEqYYrtOsIQSx0+vcE1k7lpk5nOaNRsEYQf4tLbbpxDWN/uATb
31KsD85WX88vPSklqjs+2RpCBrmR41kAzNeiaUO8fHiZ+vuG4M4hVuprZwP6bSQM
ZsqU9JZJY7AmQLPBzzmD
=8Y1S
-----END PGP SIGNATURE-----

--GEvKNWSRjg+pdNz3--
