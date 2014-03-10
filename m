Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaCJMOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:14:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40914 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaCJMOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:14:31 -0400
Date: Mon, 10 Mar 2014 12:14:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140310121424.GG28112@sirena.org.uk>
References: <1394350032.19772.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ukxn79E1+tniTzNx"
Content-Disposition: inline
In-Reply-To: <1394350032.19772.1.camel@phoenix>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulator: max77693: Remove unnecessary **rdev from
 struct max77693_pmic_dev
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ukxn79E1+tniTzNx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 09, 2014 at 03:27:12PM +0800, Axel Lin wrote:
> Now we are using devm_regulator_register(), so we don't need to allocate *rdev[]
> array to store return value of devm_regulator_register. Use a *rdev variable is
> enough for checking return status.

This doesn't apply with Krzysztof's recent (and more comprehensive)
patch - I think it's now redundant though?  If not can you please
resubmit against current code.

--ukxn79E1+tniTzNx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHaydAAoJELSic+t+oim9tqYP/1efTzV/nu2B4noBmWP7+v8i
gjOFzTtBVxXf2S4OmT9i4pxAXplrECLEPdYG/kgf1F/pLamR4FYG2sRkag1V2bL/
mBdoTR5hyL7pZSrypopiiGRc7/9DWDtZhdIv2UOLJMdENTBUpY0YNxsAzM5t2/1N
3it55WF5z2XaFcpPq3R0qzUKcfcS+E8emViMj+a3ABCX04RQKYwhC5WYIMjY4XlW
dodmemYRJGw1K3Elw5q2ISEdQQXBXnTBMoFmNuZqPeAXBEBGqWHh6dSuhshD0zBv
nVrV8iNpJxdhD1APPPVD0TfTF3d06CZvl0BjC8sDNIrCBtytLVeu7E4A3CByoKyX
PlXomHHjX2yFcBtPJqjfTeIo+pUPMmTp2zy0KdgmpZQsLkL8y0/WFCZegyNPhHda
u22+K0PRfUUgZbMzkUVAkSu3gNfImQ4fsCr7nt77c455Z8EVM5QABMTBaWZlEAgb
fyqKQmN7+PmJBBcFWPZhrVrZ+bf0g6Ftv2Ac1G1W5SO/F7a4jQlPVrKbT7R2/neQ
fRdFPQ9EGvisGY5h3mN2Gete+UWeeRbm9isYViQ6E2wc1RkcqMaUiPSg1/N8YBNX
O11HNZYDO35YyY7TbfNFtmEZW7zucaTLFipPXaQIKPazif0S+ddRm1X7zgTVSzTi
GziRWpzU/dOYciTjkdnU
=paHR
-----END PGP SIGNATURE-----

--ukxn79E1+tniTzNx--
