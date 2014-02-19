Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaBSQgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:36:10 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51830 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaBSQgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:36:08 -0500
Date: Thu, 20 Feb 2014 01:35:53 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219163553.GU2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-12-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TWZuhs/Hf4wAGqVJ"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-12-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 12/15] regulator: act8865: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TWZuhs/Hf4wAGqVJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:11:08PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks

--TWZuhs/Hf4wAGqVJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBN1mAAoJELSic+t+oim9JhoP/jI/S35XfkESpygnPZ1uIKKz
MprCLm923Ls9OpNvId0KLh3k/AGMxLWjDL509EN9O7Z63ozM+JEubMotExrW3oEI
NTRaJJwWgns5CPDlMgFM7E8BKdu/+cfp18LAx9BdAOfKoGDmibEXggBX8tXZfgIF
ldFv5YMD+DZmwepOuAssaoDJf8+ZORBfYCVEakwnzpMq6wQZBOvydbgaPxSSiCme
d1iEhwvQva5niFePc8i/oYHiYQeYta00Zfl3bEG66MXzg2D/f7jl5wu4qPxxjEz6
4YfmHsv48Gp6x/D/zvY4qoTX3mSlmri4WrkxCE8YnwtRoFzCMe4zJhtKXNC3muna
VFWzqo0kAs8/43pC4ROUd5ZpX7+LaxdFMb2n5n1qs24sKfsYnw05/g4MAhDFoR49
seC+9jUYPXJOk05+DbUULZ0W/gW8FQ/IC5PDydVRWJKL3ehZZn2LK5BEYPJbjaCs
csCTGYHFXqyH8UHFQnLo0uM6KAS/gb682IJyd8cGUmtwIsxoohDVI+mdYJJgkhvx
agIFeTqQ77lYTblaC/2gMHm5PmAyFNfnY4KThGjsiGL0VB2Fh5S2LC8LNkcGopy8
qtyKDTGsLokWup0LHXGmzUyqSan++eFdgSjqsvHZ3Xn0c5xn4VwyH0eyRfU31pA1
KgEQDl3xQmpS1vjA6UHD
=577B
-----END PGP SIGNATURE-----

--TWZuhs/Hf4wAGqVJ--
