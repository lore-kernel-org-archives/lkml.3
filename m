Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab3C2Rwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:52:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56062 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756235Ab3C2Rwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:52:40 -0400
Date: Fri, 29 Mar 2013 17:52:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT v2] regulator: ab8500: Update info->update_val only
 when successfully update register
Message-ID: <20130329175237.GJ18316@opensource.wolfsonmicro.com>
References: <1364462580.17483.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7UzVyZa9/PG1X1Ob"
Content-Disposition: inline
In-Reply-To: <1364462580.17483.1.camel@phoenix>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7UzVyZa9/PG1X1Ob
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 28, 2013 at 05:23:00PM +0800, Axel Lin wrote:
> Don't update info->update_val if write to the register fails.

Applied, thanks.

--7UzVyZa9/PG1X1Ob
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRVdTeAAoJELSic+t+oim95JgQAIXmyM/5fAkHE7IbscUpWRbN
+EsYtdU9x2wsyOe2x2d57PKYILpbC7Nvkx1LNaUyLLpVuPjMtS+Kv7dKRYdbUGAz
O67jp7GaLz90f4gQTGWFIuzD4VnFCMau1HzwGDeYhXRPUj/3YZHX+1hbQ3v0Ejmd
gHf49J6BrsY70Wfo54tM4AqzSi15j3OuYG1tlhuF9evmjQj79tdzmc2v+Bo+UeiJ
7/h/OiVhg0l4CA8xqdHPxMg6ltmvvWpd3vs96NkcnwZl6O2rnLTck2qblzSWFXX8
LhYEfW+enJDnFJNUJpDhQ0C2tZgSfXACSXTx56cVotsHZ3KfY2YGxBgAEcxSeH0d
ctNPncN+vgJig8lF+2iKgWcCFtWJ/a62UriFHAcL02d68oZOAAbRqs7b65T1ozkN
Q/TOJOAFGWjIOabasPpN1b9PCTShby9K6qjrLzIg+P1BNkkTkumfBDxGCT8PtIau
yVg2RgJD1YBdzlYsI7bNzY1T6bqCWvm4WcFQXEWW/TT1XO/2vpv9VNFDrXpLdhlK
dMUDYS/XIbDuMKpFal59BxSm/498rhnCMnWvnMdxys9ATnRpu+74zFshB79eEpZS
5hf04aSS51y0dGiCobzfvm/ybP05w3nN4tDaE2LKkAyqcR9AuMfQ2qRhMCO0EKN+
koTHmi3p9dyDGIyJEp+m
=XhOr
-----END PGP SIGNATURE-----

--7UzVyZa9/PG1X1Ob--
