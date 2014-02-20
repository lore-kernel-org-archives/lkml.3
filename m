Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaBTMEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:04:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47344 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaBTME3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:04:29 -0500
Date: Thu, 20 Feb 2014 21:04:06 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140220120406.GP2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-22-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bsLiwabNB41xV4cM"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-22-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 22/23] regulator: wm831x-ldo: Remove redundant error
 message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bsLiwabNB41xV4cM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:22PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--bsLiwabNB41xV4cM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBe8zAAoJELSic+t+oim9nGkP/jeGDMkUyLV7AfagqMaJMbXY
nYFPUb6hKcoGys3Uo1GFu1BYm+wT77xri605pp1+SI2HQUV5SzwauX6MvNeBIyU6
AVXQaAzB8ESI7BmC7IMFxtGFsR98vUuWGS4CG/mus5QOHg19NXU1T4QfELTkAh4F
3Dn8FS2RfAYB/obtOJLpz5EWD6/0RHNGc3fDZRBWjDwFFm7SWLy31yJW6aE5O/Dn
oCw9zygPfJEbRLWYjGvmRn62jOTypt2LVmI3hidrLo0QbIjFtxXVUWEBM/ZhxMHT
dqMBv2E7ZJX+wGHxoaZhUC2BMb+6iD6d2cNeT38JCS4t9bdDZZ1LGtGX8a40yb6M
/oD/Pa5gDqAaQEWbG2JRgWR8Ag5PjPUq3uf7AFdlm2nQIMsR8YupS2sX+Zu/emIc
f76FYpyDEXGyfon2ulY5eyC70dQMPTmVTx8EwOJCmM3QI6yGwbLMOYDHDkjns9RA
CrT3DlEVJxNbaXlI+zLixYqhGCRI+HD5UCQmPjY0kzXe7Fu0cnYMZZjmetXqI8sG
pSja5wtesPj4oJAEhZM67wpQnBqS9eqz00n4jB4qT2kHWb2fxMShZdjKgWaw5QhK
LvYX9QejAt7zoRI1BMK4+W9pC0yK2lzZJt8ZT+o5Wv+R/5BUK9tGheeW50pSiBy7
3AAK440T9hqMEGbCyddl
=x8E9
-----END PGP SIGNATURE-----

--bsLiwabNB41xV4cM--
