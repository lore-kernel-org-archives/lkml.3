Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaBTMB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:01:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47322 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaBTMB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:01:56 -0500
Date: Thu, 20 Feb 2014 21:01:46 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Message-ID: <20140220120146.GL2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-18-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r4VtMIrPT4b0rq98"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-18-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 18/23] regulator: tps65910: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r4VtMIrPT4b0rq98
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:18PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--r4VtMIrPT4b0rq98
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBe6nAAoJELSic+t+oim9OL4P/25YTmDwh0mtGJ7TaciPbPxZ
HM7BCuovvV0SigT75rwiZKBdG//+/ZkjhB2tlXR/5vBmn2975bJ7VXUkfZ8VzjbZ
MV2qbu+lyeTz/tdF5ZbO6y2YfMxabq1tqaQODPCBo6dXiu5iI0MkxHdN2FhsP9Kt
LL1bGHC5OBKop8ZUOZFaiqGC3j5HxOMDdps/bq1D1G0tnsijW21LFLSwg2NoCSJc
tuJrrwYbO0I7oEEOoytBLawpj3oav7Y11mYzXSFoXT21F49AaDl6Fih0UWa0gcHE
rM7Oq/taIHDkeYxXY4JxKKBWNNIBBt81RDJyr6lKThyA0673704MuXORmD2IzDii
nxWKNEu5J42lj1KOIGYaqikrrqFbeETV8MWRPyf1w1Aa7AQAvfrA+3PCBYY0rHoS
ggFz00ktZ69/Ymg48TYKro0rG/Nj8pWcFIwRN8ycwBAeISAQfEDF1fKE1cteasnZ
3p4FLwCzVxtz76seqCHVPEtQ3zci+fH1BQB4c10liiTn95aTgow89xUaOsXy5eiL
puQQJqmh59DqrJJoBxtTHW1x0IqrPcjH9smXfhTHdKETM7/m4SFExldYq/cxJjzI
OgPfnucFKzdMa3CQyXbk8JWTIocS/1MnV4rrNwncUIu9ZKWRMoFelHBjTWknkY96
VIqOANEmN1by55EoedKT
=o8Mr
-----END PGP SIGNATURE-----

--r4VtMIrPT4b0rq98--
