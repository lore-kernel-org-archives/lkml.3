Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaBTLYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:24:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47247 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBTLYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:24:38 -0500
Date: Thu, 20 Feb 2014 20:24:30 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140220112430.GA2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-8-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H/pqNKbIfwjYkiFp"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-8-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 08/23] regulator: max8952: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H/pqNKbIfwjYkiFp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:08PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--H/pqNKbIfwjYkiFp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBeXrAAoJELSic+t+oim9jcoP/joRaHMhBJKLYCbKud4r2nFi
jtNY5uGn1Sl8sUbDzRMWkJm0YYuvbItzEuZBEi+roZ8bSmvHU+IgQrFS6AOwNKJ/
nIPiC9HO+ITo9oiCHt45i0xTvf4maht1CK7wxrrC+LNVNxNvqeSdi0fYKRuPaBNN
21t3czWpKFde1CT31B09KgwzECqUA0RvFYZGNdQXA+qtR4nd5CnWCkXmICWIMRVP
CUdcrhqrjbecnaDZL1/ICsm7ojGxsq1km8DPmvt7RYyV+pVBsuj+AQprVrkl9J+D
wg4tHoYRH/fSCOb/Z4q8Trq8diisDTRdfadqgQA4+/c0QGI4Aez1BMnind8DKr4C
onXM5Uv3Eea01kiC5WQhQlsYE5cvXMVgM8VC8qGTT+TNg1JUltnKOK9J02gHvfwJ
qWr8N3zfNprF3qpfR74/OKyrN5iTn6aNf8lyF3HqqjgMapg5M8TDE8cvHYEpb+LJ
yzBYrK3uj9fFiqHp0OASqEJrCtny+ySn/lf9bcktvQxmkrZkepcgYJBFa/cwRCHR
XB49siW9Id2F6hTwc4pu308nSwlVoFqF9llWZSkv/Br2lyCoFnth26L9XN1Mcdcu
QAMzryPdf9WI8HVQ0obWTLKrPS8LKKnIHSCglzhwY46UopLKrKXQ4kQsnJ210EfH
tUyegQwsvSR74aPkhvxC
=rVbM
-----END PGP SIGNATURE-----

--H/pqNKbIfwjYkiFp--
