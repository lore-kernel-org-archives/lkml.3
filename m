Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab3JWJTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:19:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37290 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3JWJTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:19:12 -0400
Date: Wed, 23 Oct 2013 10:18:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Yi Zhang <yizhang@marvell.com>
Cc: yizhang.mrvl@gmail.com, zhouqiao@marvell.com, zhangwm@marvell.com,
        linux-kernel@vger.kernel.org
Message-ID: <20131023091817.GI9388@sirena.org.uk>
References: <1382438672-19392-1-git-send-email-yizhang@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Encpt1P6Mxii2VuT"
Content-Disposition: inline
In-Reply-To: <1382438672-19392-1-git-send-email-yizhang@marvell.com>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 77.221.165.98
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] regmap: irq: clear status when disable irq
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Encpt1P6Mxii2VuT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 22, 2013 at 06:44:32PM +0800, Yi Zhang wrote:
> clear the status bit if the mask register doesn't prevent
> the chip level irq from being asserted

Applied, thanks.

--Encpt1P6Mxii2VuT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZ5RWAAoJELSic+t+oim9520P/3AJCsTclIYimrglFCY3MniW
3cDea5Pq5FXT4ak+5/myxT/nLpM73Di9GDq+TfDmtA7bTPgoewRz2dOE6NJjPBm/
xgzudHx1MdzRA5iTjBTxugskrGR9cm1HQsYCuTfrSxesNXA2Ygmy3vG4r+XlIoAj
2Ry5qI11Vg7hs9avPqxLZU4TfLEfk7+LqfdjNfPI5vMCLXaDcApZyOdx+xWSZdkO
KX/obh/PydkI+qj5fymZbFCJJtC0mLQrPsBdmrTp4aczm6B9EX3Ipfsd7a1P54G2
X/s9YmcMn8/jxodCLGVlMsbftidwVKerYuPtyb6bizFQOQTdMx6WTZOkc6DENUNB
1b0+J0LNAeDHFcMdrA85jU7WjiAl9aL+NTq6bexJkkAgCPV0pk+zekB7pqxOs2BB
XcW4lFpMI/4RQTIgsBCBjp8Ix2pBDagxlL+wzmCp124L77WheSpbTIQ6jepPw0K9
SEELPzE9moy6JpmlMIhcMYSPfu4YM2Hw4uU0Seto3H9lueRcBKheDIGc70zWFloG
ndZ9ilCo+WzLrG6DynqBMcDRchLA6vm831aCJZoJJrzkw3+0GKciX4gJT070miJN
/2D0MU7THJ4iOOV52ZX7/9OoI4arGABR9O2e+iGi/l65P+peyMm6xR0NgcmATNYE
g7Q7SG2W55rkERMS2q38
=DieG
-----END PGP SIGNATURE-----

--Encpt1P6Mxii2VuT--
