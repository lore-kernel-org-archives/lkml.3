Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaBMS0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:26:10 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42250 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaBMS0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:26:09 -0500
Date: Thu, 13 Feb 2014 18:26:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com, sbkim73@samsung.com
Message-ID: <20140213182604.GX28112@sirena.org.uk>
References: <1392291307-21104-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2CKPe999o93Mtx0C"
Content-Disposition: inline
In-Reply-To: <1392291307-21104-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: s5m8767: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2CKPe999o93Mtx0C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 05:05:06PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied both, thanks.

--2CKPe999o93Mtx0C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/Q45AAoJELSic+t+oim9HhUP/idabL5inIOXgI+FTtCUBRh5
ZpAc6MrTanA+0GbPUTjjTomHc4kDEjKO4loFq2DvHtfih3gGYvr9DnKaz4QQobZX
4rB3vKTfIVqgw4feHTzemEU8XuyGCb2Qf6cCybU2INvtZ2/uVaTpfa3kTFJ97x2t
WI07LtmxMSg1nq9bQDR6r4VZmU4O3coJKzAoByePTY19ezTa6o5hqx26wNO4t54p
9nUaEpei4rzkmALZSHUp2whVGQjQNQ/V3WBGOpNDVoJSLgPwU1V+NrgBxdcmIJ2E
qHTw01zvuQuF3ee4zI395N0A7K2jUCIPn7auvoWPOIGeCehi1xR0ucBsooyO+bRl
SNe85f0hEf4ax2stX+4/jCc9Qo1C6RYPnmWuVCI4vmZwrP4/2n0Nb/kpZx9xkQe6
w3FoAhehA33FInBXUWBdLy9lcOY2zzr8R8MdzklWb4VxblIfUrC6Qhf3mVAXKSMB
teI2GB+H7LCwxlesEUlaYdruwo0ZqekBff20BCUQrIm9KMshT1eXDX20/0Ptpkby
RJasNWO9f7S2zOdoDH8IjqNVxJI4k2WDRHw+BZH174Nrl2t3E8g3ZXZwZGXjLZ2l
EI/NwyvWEX3U/uijolMDRd4hO2juzXFDJs303Nrvwoj5rNmSKwdjD5c0R5HbYfJW
USiAloa0+XjTOY6Fhaks
=ReiK
-----END PGP SIGNATURE-----

--2CKPe999o93Mtx0C--
