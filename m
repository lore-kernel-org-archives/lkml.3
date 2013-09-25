Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3IYMfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:35:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37278 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab3IYMfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:35:42 -0400
Date: Wed, 25 Sep 2013 13:35:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Message-ID: <20130925123536.GO3226@sirena.org.uk>
References: <1379960073-23245-1-git-send-email-broonie@kernel.org>
 <1379960073-23245-2-git-send-email-broonie@kernel.org>
 <20130925111954.GG5132@lee--X1>
 <20130925113103.GN3226@sirena.org.uk>
 <20130925114643.GH5132@lee--X1>
 <20130925115502.GI5132@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxIXENaY2CYUgF8u"
Content-Disposition: inline
In-Reply-To: <20130925115502.GI5132@lee--X1>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] mfd: mc13xxx: Move SPI erratum workaround into SPI
 I/O function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wxIXENaY2CYUgF8u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2013 at 12:55:02PM +0100, Lee Jones wrote:

> https://git.linaro.org/gitweb?p=3Dpeople/ljones/mfd.git mfd-asoc

Thanks, could you include the first patch as well please (there's a
dependency for bisection due to the BUG_ONs)?=20

--wxIXENaY2CYUgF8u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQtiVAAoJELSic+t+oim9GqQP/AvyjipTpukMsi2CS4WMZXx6
G40G15YIMGcZxQATl0n9JXSTB2C8Dc4EY0Cy1oALMQMK6PpWibm1n0WyTiBFu1bh
IUFHSaWaZC+TI+1BfT2QzfVZ9PO/aUKqntjhYpx4MMvN+QV/9BCH1We9cF2lk0fy
bslKhYJfFcLksSBOD68pSDI7J3h9V+O3inKuQ6kCqi+NsOf7tQhELqe2VaXu2HQZ
IYMuqiFVwx34MVX1RL5ErrHO9dcGS/ZIpcU+xjH6QsaSbO65NcHB1a3Cnz6UNEte
U7/Ml5lHkSYhtDdJxrL+a6Zd+U5h0MYB0M4etRULKZq6yvrSH9L+WyAs8tW5EYgy
caAs6qi4zTq3mSBb3dU/v1xgIsI6jdhsKDxzExZxOvJbtqlHZaik9Hd3ENPY4zSX
SBnSU3TaWRC5uMhg7eJruviumc9WK5nCwhG9/Z347hlykSpDrnD1gLUpNdcELUSq
gYiZXSiFBO7hWrpg4F/OfPHyDDTZuGX3yrWTMILDxmcYsV2pMxP4b16dXQLvgTNp
cfNp35NeN7ZoZ980xMUcNmPh51i/XpaGlR2XXDtxFd1rVQCEw5fDqBNRqa5OozCp
dnGNg4mB+X7nokBFdHijq6cOuf7SnlHrPAMjPOp74qXbd1vRCISlHFaq0l7PNRor
asXDyv09bK7v3Q27BBc7
=DH6Q
-----END PGP SIGNATURE-----

--wxIXENaY2CYUgF8u--
