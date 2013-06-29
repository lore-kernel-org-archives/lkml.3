Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3F2M1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 08:27:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34627 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3F2M1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 08:27:14 -0400
Date: Sat, 29 Jun 2013 13:26:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130629122648.GO27646@sirena.org.uk>
References: <1372478659.9121.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+Zd8GiRMmFTsS6tU"
Content-Disposition: inline
In-Reply-To: <1372478659.9121.2.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: max77693: Skip register regulator if no
 platform initialization data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+Zd8GiRMmFTsS6tU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 29, 2013 at 12:04:19PM +0800, Axel Lin wrote:
> The code in max77693_pmic_dt_parse_rdata() does skip setting rdata if
> !rmatch[i].init_data. So we may have some empty entries in rdata[].
> We need to skip register regulator if no platform initialization data,
> otherwise we may resiter regulator with invalid settings ( the empty entries
> of rdata[]).

It should be legal to have no init data, this should make the regulator
available read only (allowing the current settings to be read back but
nothing else).

--+Zd8GiRMmFTsS6tU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRztKEAAoJELSic+t+oim9VXkP/1xGbGKrRJ61zXVSHV8lH0Am
8Uv7RQBQvdctV8mPE9Iwicr1BxEpJzkvCZ5PjHmin35fQyrwXEg3Vh0BqIrnKhVL
GvUvigmwcUNcwyk9xY/lvQnv4m/ydhOzzsXVw9CsqO/Et+RYlDQxfptfexP7kELk
iiso1C3ZpTQvFMZqHsB9Z0PgNkyJAAX+1196E7O1vVyc2Bzisx+dygB9Aa9KzPPd
Ae6knXkw5ZWkMbSsSFZQWmIhb95z5tEouuVEuhOFbCXLKmhUNGyVvAR1k97+wd8U
Flj1ZqGy/GtpM677Qy+hTSQHNXM4xsP26EHoc73SCD7rIP2uPxTRFr2mwUpKinrw
L/hUpJfVZBRgLrd2I31BP3a//ojqVm/s4zuTyFShHB24o9Csw0Hvpn/7Vl8vz7UE
60avT7w1vaa1tM+GDMbwIQVF3A3H7vg9G9PS+3b9BR4AmmDIGRmr+qItt8Tc7q0w
95Z5JsBrz7fJTBSp1lZ63Y37cW0swFD9sjam5SFgMyXx1I1z/G9MGar3tfXEsqWb
m139hdqofSklxmQRtotmXUiszYehOHiPfNdIAcDfyYkZRtGWcYtBvKwUXZufoWnS
+iUxpQn5Wz0MwndIqvfRLxLXoBimBVFQ7mCTeo39l5XLTd9FxfrhdkNeFA4ZdKvT
qSUK/2bXTFaaTXABtENj
=pkgx
-----END PGP SIGNATURE-----

--+Zd8GiRMmFTsS6tU--
