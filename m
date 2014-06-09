Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaFITxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:53:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34348 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaFITxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:53:01 -0400
Date: Mon, 9 Jun 2014 20:52:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140609195247.GJ5099@sirena.org.uk>
References: <1402226789-25928-1-git-send-email-shc_work@mail.ru>
 <1402226789-25928-2-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lKueCj4EYK2W7OYQ"
Content-Disposition: inline
In-Reply-To: <1402226789-25928-2-git-send-email-shc_work@mail.ru>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: mc13xxx: Remove unnecessary locks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lKueCj4EYK2W7OYQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 08, 2014 at 03:26:29PM +0400, Alexander Shiyan wrote:
> Read-modify-write sequence is already protected by regmap, so no
> additional locks need. This patch remove such locks from mc13xxx
> regulator driver.

Applied, thanks.

--lKueCj4EYK2W7OYQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTlhCMAAoJELSic+t+oim9/GoP/imSJKastkSqeWTD9+Rw9XZq
0Rl6OHdPrAHktJ79q2uFi8McBvPRmWf75QEDxw4GJSLqWD5oziwD60wh6B928Ajr
ELCfF79MNhztCyQnY+8X1eBwYjpxgPwikAKXWJgo8ldyAmrN1xHXfGzsGmlT+1Hi
U1mUa5M8/oG3Pyar2Nl5LWg1GwFVV/B5y/GUQoIj/WLm4lfy+b3a9I/+E7yxvDzR
uAbUk/8lHR2M2wf63uwbtxGdHEs1699MHbHlPM61LQOCHFXKb0AsfdGGJhSUftYx
rwZzhJci54pb+EzHmV+zpIkSvq6bZAus4ERecKPHyStExQqCI6PIdOg6HlCfTbUe
A+xdVD9W/DnoPKRF6wygoimVGHP8fKiDYVVDPm2QUZh4nG/88F/4GpoETOjGYhyS
LW6TmmocNNSEm3kOWL1ViXNdhg+IzDidDZ9pRGl/HdaUHMKOWaPCTckv64qw0E88
wey90iPNBXV5Ze5DGnyWkolXpATh4oVq8n/gK0teAFHLEr53+RG70nog7YZf1ZFe
ezzVlMHWHOc+UuNnn/4LkvliNJFqZmbp1J9YSOQxyCK3gJxSP08wZwAG7yFl3fCr
MlJtqobA6ddfeOmgmJwKKbqUmmYmhrbuVnaS+zp6WXweMw5jCyjPYUqysm/du8SN
Fi1wd3IN9fYLqwYqufZc
=VP/U
-----END PGP SIGNATURE-----

--lKueCj4EYK2W7OYQ--
