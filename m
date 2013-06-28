Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3F1LfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:35:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52656 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab3F1LfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:35:08 -0400
Date: Fri, 28 Jun 2013 12:35:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org, rob@landley.net,
        patches@linaro.org
Message-ID: <20130628113505.GG27646@sirena.org.uk>
References: <1372066617-23518-1-git-send-email-sachin.kamat@linaro.org>
 <20130624152553.GT27646@sirena.org.uk>
 <CAK9yfHzBPO1Yr7_qLtw3oZKVVtqDBK_Yj7_r=HrU+94pod+XVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ezliVEEOO3pGSi0a"
Content-Disposition: inline
In-Reply-To: <CAK9yfHzBPO1Yr7_qLtw3oZKVVtqDBK_Yj7_r=HrU+94pod+XVA@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] of/documentation: Update s5m8767-regulator bindings
 document
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ezliVEEOO3pGSi0a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 25, 2013 at 11:56:12AM +0530, Sachin Kamat wrote:

> There is no change in the bindings, but just a correction in the
> documentation to reflect the
> implementation. Earlier when Samsung platforms did not have pinctrl
> driver, legacy GPIO driver
> was used which took those 5 parameters. Now since we are using
> pinctrl, we need only 3 parameters.
> The document was somehow not updated to reflect this change.

So there was a previous change to the code that mistakenly didn't update
the binding document?

--ezliVEEOO3pGSi0a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRzXTlAAoJELSic+t+oim9PfIP/2/4JzoD2LlLJphjgHtWNkIO
+BeyeiTy/CykecuTz//ZracNs2hAP6kH9mWWp472Rsu3A0jmUOdf6HVQ6tFlDjsI
BmOP1+4uxGbs5bxW3c0gHIjukbxjd+JUibMG9J19YSWFpfO1guhkE28Wmhzogicq
pzJi3BIW2FdEu46CSjp5sLKMMz8oGlhtu6KB4+MWJNVghkJLoZnHuyZwMBPlTQ4Y
YaiyadBANtOzPmglSMv6IFQKZbVlXd4NTGVHySM8auck8mTfBBE7L7Wu4V7Z1Au4
M6dnXZR6DLoGELDjR4RdnREZUsQZhHdBf7u06bnWvSpLhidZT7fqLZ1Yn6W9mAF5
TC+VEWdanfBwmUzvJUmZO0w1CwADKf0HMSluV2vVufzWDunllE09dA+58O9/Zk8M
WDqNO8Imon5BCSzjEib1amWJQ0rNoi6A5rourkslhD3EtyUHM8q72tscdyR5zpV9
LE8aZht683hjfhUlcltug4hiO57SI5h5QOlR8DTluhqBVAqZd3LNrk7xjn9pt7Wk
XjFjnskZTIs6e5YOIfs5H6AQ24hKIynaFn2G5fbOMNgGcMG3+ith6vnXKg5hYI/0
foXxBaLxBTqRMrgn/XQErQRpbHgyWfj4TbdBXnTln15uTQ3yjdzxwg3eRra6BHVa
i1R5y9T/27KPfawC6RCO
=5HfP
-----END PGP SIGNATURE-----

--ezliVEEOO3pGSi0a--
