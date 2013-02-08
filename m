Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946295Ab3BHL0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:26:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59613 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946244Ab3BHL0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:26:24 -0500
Date: Fri, 8 Feb 2013 11:26:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: core: Optimize _regulator_do_set_voltage
 if voltage does not change
Message-ID: <20130208112622.GK8879@opensource.wolfsonmicro.com>
References: <1360120188.8965.8.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQ77YLfPrO/qF/pM"
Content-Disposition: inline
In-Reply-To: <1360120188.8965.8.camel@phoenix>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQ77YLfPrO/qF/pM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 06, 2013 at 11:09:48AM +0800, Axel Lin wrote:
> Optimize _regulator_do_set_voltage() for the case selector is equal to
> old_selector. Since the voltage does not change, we don't need to call
> set_voltage_sel() and set_voltage_time_sel() in this case.

Applied, thanks.

--LQ77YLfPrO/qF/pM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFODWAAoJELSic+t+oim9kCYP/jQ1d03SGNtj/+tyqDzUaLkM
CTJ5FZ0zedWbrRxi3quam5Bb+qMqZ49CpKdBVQqQSvPcpYAnaGINQZ/Aos6Sltyx
bXo+klVMfgk5VcfnhlWqBwDKxKyMIn1uxU5iW2Ok6hRxuPy5ifIz1FsX8qt7e+ra
mM/cRkM6tnC6dQBxBL4vC0x0IXnoqGhFKNis+sl1tOR40qd8XRfT6mg+DufZMmdR
HzsJAoRRoHBkmakfHHvN1SqAI2okY1Nfkemrsq5vwgk7BKlyj2CU+Txbd1E+bFTb
LhzR623FF+4CphueT+BW6KNYh0wF5upRg0loJM7zDw0NjuLtMK1WVC6ZaiQGLATx
lqsPdqhBVbT/nihq0drWTGpBYi0/bFSWoidFWyLnrwjl2V1NBYa+YuZA9w3YO8sh
bsZALqL/M+o9NgYkd5O36jRgnMH5HeJ36GlxrTOhz14wq1ExNQQihBhdHU3SpTu5
yJc/iaEuhnw6myQ6LPcJEIX1FzHCqtj7VOExLI98AJ5eLmFrgQLT1OitOyPVeNHO
WD0SWwCk7EY0V8uusLzUWG4n+UzFrPJphnvEsdA9r0WhEp4Tf0Jjd5ZgDPMRh2vd
IgRwPivZPPhnEWkNUy/palPvq8Pboj0KtuA1hKd0qL2o9nbjb/DJvB153NMfAhiE
IU1q3jRUyC+FmLWsnCJs
=Pctk
-----END PGP SIGNATURE-----

--LQ77YLfPrO/qF/pM--
