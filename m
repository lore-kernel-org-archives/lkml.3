Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030585Ab3E3K4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:56:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34431 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030473Ab3E3K4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:56:31 -0400
Date: Thu, 30 May 2013 11:56:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, balbi@ti.com,
        gg@slimlogic.co.uk
Message-ID: <20130530105616.GA24534@sirena.org.uk>
References: <1369909509-25394-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <1369909509-25394-1-git-send-email-kishon@ti.com>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.128.224
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: palmas: Fix "enable_reg" to point to the
 correct reg for SMPS10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 30, 2013 at 03:55:09PM +0530, Kishon Vijay Abraham I wrote:
> regulator_enable_regmap() uses enable_reg to enable the regulator.
> But enable_reg for smps10 points to SMPS10_STATUS which is a
> read-only register. Fixed the same by having enable_reg
> set to SMPS10_CTRL.

Applied, thanks.

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRpzBNAAoJELSic+t+oim9IiwP/1EnMNKoFLjpq0q/gO9ujEEf
awvxhWIIqtGq8tjc/P+TFhjhnC5/uzBTfhNI1TJArZm19TZWu4JInra95BxvL1lj
suuC9wHe7oKnWex+A2QFZTfOKOFnA1dFqVLFjm895DzdV5KC/HXH2FtfDo9aoXDa
Ijp7gvWnjGRF3NLEymw1gRvSGMKok57AL+Z2Q0vDxoJccpHahr7ZjrokH1UHfAyu
A7vXu/NI0J28EVpv2/4n6LxVIetlVYO/17eD4kx7iknmBq0RUh/n83/K9r/KKKms
JXfropMlBy4mvS0FoaQhhwJUI6qe0LYuUMrG1PgcBWB4dxLMVQUCwCOZW2XRPGGH
naD8lVau6DxDOzujNy6y2s2yKzTpxpi6eshen/w2lv5E8W8uqWJsy5e/Y5ZbwwP9
Xbbt6hkwx4z/UsLk1ei78Eu19x3AA8FY4nPOx52ikDcSg1VMX1nQOV6H0firpP7t
kxIoNo6fq8WTuYm734aTeGLfHoI47oOWBgZqNPQe8RDCrE2ACPsqrJaZAiRUfm9o
HdQiYL4Q1pPlOmP7K128ZFY7VfuDQclPM4nbfszlRG6BXmVSo6wdcegfpW1WXLgf
IFMKeK0VSUbhRjdWoUGX469zf9fkSnwz2FymBJzkQ7rE6QpxpGKD1IQ6mwWw/VLW
OSYpv7vBUsogAp/7xAD7
=xjNT
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
