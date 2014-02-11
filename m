Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaBKQfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:35:45 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40438 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaBKQfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:35:01 -0500
Date: Tue, 11 Feb 2014 16:34:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        gregkh@linuxfoundation.org
Message-ID: <20140211163452.GQ13533@sirena.org.uk>
References: <1391007448-26245-1-git-send-email-badarkhe.manish@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WZLuFERxa6Y0cbOt"
Content-Disposition: inline
In-Reply-To: <1391007448-26245-1-git-send-email-badarkhe.manish@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4 0/2] devm_* API operation for fixed regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WZLuFERxa6Y0cbOt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 29, 2014 at 08:27:26PM +0530, Manish Badarkhe wrote:
> Use devm_* API operations for fixed regulator driver so that
> driver core will manage resources.

Applied both, thanks.

--WZLuFERxa6Y0cbOt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+lEpAAoJELSic+t+oim9sxUP/3xRw5ABiYKLIlY8PDRKTmNj
PII9zRNXlvout9XzoAfhVUDTjYptwcmTp2/+bL6w7hZXC+o8keyULnQP1AhjguGP
q0iL1ml9LXD7MaaVyAa9TMdc36DkhniBCub/pjy/gBXKGMl28pnkq6gGktmUcH/D
DEuBp7ksJYrvXAXkVuBG31wJebZtF/RzQkJJEBlocIdtmMktX6gTSOVEgYs06zvz
dVIJp0Kpj8iN4ScMRwKJUh5lhConJck2g6WsQRNt2pN5gRTOwB2kRcNQsNfpcKgo
pJ9NYGFLigsp2RmkliN868EokJG7UMGzVU/eIqdubZi59y+051Kt/NV2hcWyyyKR
nWEgrXPyZ8AIGtQ4rgOt9q0b62KDIpa5F4quxDxwsQt24VOFpO63E5vkzoueuiUX
jxl/T4mG9S5fGmeTvoS7imWNZ8lp+9XVZWgk1jzHhnpJRSMsxUL5KhhMBWGmUZq+
wEu4ScMLdXTCSWmFJVMyQ769YZnP+iy8KbSC+I5ZTNmm7q2+jeYVvkPlRI+3Mcmf
FQWgyVwUY4fqwP9Iiourh83wpvgLKw1rQpM+F9sjefOor0SwmKAjKBzI5tD48wxb
/vxTrkq+kb+sRlwMQOR/gsJd4UrYWDA7B2yqHF08L96yQ06588q1SEWxXIH3D44W
NRnI7sZqD5PJ7hWrrqoz
=ZRzO
-----END PGP SIGNATURE-----

--WZLuFERxa6Y0cbOt--
