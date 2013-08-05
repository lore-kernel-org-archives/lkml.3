Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3HEQJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:09:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42618 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3HEQJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:09:30 -0400
Date: Mon, 5 Aug 2013 17:09:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130805160906.GO9858@sirena.org.uk>
References: <20130731131627.GA32631@opensource.wolfsonmicro.com>
 <20130805121728.GA6022@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17ExsrJJVvsc15xs"
Content-Disposition: inline
In-Reply-To: <20130805121728.GA6022@opensource.wolfsonmicro.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v4] ASoC: core: init delayed_work for
 codec-codec links
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17ExsrJJVvsc15xs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 05, 2013 at 01:17:28PM +0100, Richard Fitzgerald wrote:
> We must init the delayed_work for codec-codec links
> otherwise shutting down the DAI chain will fault when
> calling flush_delayed_work_sync() on the linked DAI.

Applied, thanks - please send using a normal patch subject line with no
Re (which makes things get filtered out more easily).

--17ExsrJJVvsc15xs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR/84fAAoJELSic+t+oim95M0P/2UxCLpfcG3JNrUjTRtqDhwb
SrunN2LpEnIvOU6jSOgWna6Hf7qFyvBg48qisuuonb1fOmLpd7La+D3xs2uO8M1w
4OUgz867TBPXmEd0qZv7arE8PLNF5MtxyWTVgsdMsrtMjqBl1oK3CkfwM7IkzN55
lQ4iQsmvks4SnPDy90ueLBm0aBQEvFEAgL71kZ4RcpJf9FaLABuyF4desYe1TcIY
AbT+oQVZOk6gbMgAQJD4TryPNiBs+mGLoYbe9thGGlZgWpU2xgvo7uw1Dcpc9bey
n2+7UO2Eobqzc4MgEylOdHHsQeQdHinCpCQ9kCaT80B5P/Ki25zaouOotQ25z5YB
KR0XXoI+NKkk8al1CYFIA2ae3tjm9Wqgso/ugZMR1gE8sRM5m15ljc/DwVTAN3Ib
E5EB/oabAu6bYs0Xgb1xFwLoum/XqZJkhAuitJKUPpa0qx2ThP1oUY312sAg3T8w
GaGXx1m1q5bxV5q53a2Gz+olJPvSxkhnsPIDG4K1BVdNg6PmPOB1QDN4uwmjIjXw
dIcgmYWD7HSS4jzO9di6xiXuUWPVyhyPjbgblkwqh2X32Lm6y+jRWzHmebxtiEFc
h1loNzU6k4SlqHf7xPqdTFz9w0kJbu2GLUsJBzG5sR1alvkIWg85Vh3+zYA6xbjU
kvHuslu0vKIl5v9CykP+
=bOtY
-----END PGP SIGNATURE-----

--17ExsrJJVvsc15xs--
