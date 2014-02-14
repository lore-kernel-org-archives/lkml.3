Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaBOKKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:10:12 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60686 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaBOKKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:10:07 -0500
Date: Fri, 14 Feb 2014 21:11:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214211157.GD4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-6-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DvpQYQy10PodzGf7"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-6-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 06/16] regulator: max8997: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DvpQYQy10PodzGf7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:52PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--DvpQYQy10PodzGf7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oaaAAoJELSic+t+oim99egP/iMQX7X5P0r3c0SFXJd/FzSE
J59BLb5EKBEYyjuhiGLH+vYD2pf9Kp7c0WYfOkzefDz+APkPS1Igmt8wIkint8m1
zn3CQnF7GaU3NxFa+9pd6gAUBUOlVCw6i0u40dzB8areUNvGW03rMfjbt2JtUyav
uyNVSdDeTy1NrX+eZLLttGa2btTorBUM0z8OZYt1SH+NHd3NDZWcJ+ZjG8MUhICD
HrxCUabt8qDCDhZhUyld9wPSaWECjCur6Z46jBQOV1BDqqOPkZScto1hM59waAHC
MKjKhN//pWdn0txT2UYZLsbrXIZqiVU9WQ2yHiPC7rMp4kKigOQ2+ClOzTY60VjE
fWVLwLn5ErSeyhLXaqx6Xk/sVIIvWNPJ+ymky11OcGA0cTN3WKQYlq8H3FdxpyZD
RbLSPGOH4ZiwzCStDYnU8z1o3mtdBVy4qpUhSJFDxys321h24MGnUrZuDRHbtvFq
beRIdQ4zfgU/mash479nI/x+DJZHZBok/yPo8+ySRa1u/Rac/KIUB8/z+JzOdsKf
5DO6HPK2E15IQDVCtu6uubjPWhS7gc2M8d5/txgRdd0X6sXLKN+1imvNb+bMBEAx
AIoMQTfab/XgddaHtn+UAM5i0IDiXqCNbakFCKjXEfULR+xHnn14iPUzu6hyeitc
WwYjVoLKC/HS2bqymRWB
=SmHz
-----END PGP SIGNATURE-----

--DvpQYQy10PodzGf7--
