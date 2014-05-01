Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaEASky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:40:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54158 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaEASkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:40:53 -0400
Date: Thu, 1 May 2014 10:53:07 -0700
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <20140501175307.GD3245@sirena.org.uk>
References: <1398847242-9394-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nDtE8k2pYjsRXajv"
Content-Disposition: inline
In-Reply-To: <1398847242-9394-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: s5m8767: Allow GPIO 0 to be used as
 external control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nDtE8k2pYjsRXajv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2014 at 10:40:41AM +0200, Krzysztof Kozlowski wrote:
> GPIO 0 is a valid GPIO so allow using it as external control for
> regulator.

Applied, thanks.  This is only safe because we don't have any actual
users of platform data - if we do have users of platform data then
things get a bit more tricky since the expectation with platform data is
that zero is the default/do nothing case.

Really if this is an issue it is better to fix things so that GPIO 0
doesn't get used for anything, with DT there's no need to do that since=20
the numbers are all dynamic but it does get a little more tricky in the
platform data case sadly.

--nDtE8k2pYjsRXajv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYon7AAoJELSic+t+oim90eEP/i3bCyJr9/5kEOCzlVWrEymW
cc/sbX/YXgf7abP7cT7p0lfkod6LOZ0YvDynb1Hw3bON9tPlewnEi2ymk3LO8pfQ
Ep85RtjfX31WX+XOoKuiA8dmRmrK+vqQaW9VpDcXr8DdV8SIRG8yKmMmOloBz9n0
RwU7ALrnb+gVl3F0zIobibAc6sPUuPH1bp5+MGg9/uSYbTTCCvRZEiS4chSpFbrZ
tmgu/+7fM4wyGJq3YMb08Zg7tvE071KWKUE7Wkz5PJd2VO6ND6JG3o3hvbazPQnI
a7x5SZX7XgJcN8a44QqiapQMCW2uAjgjExw55rZOQ0hfVmmz895RtRBbYcO0TvN9
GSwNhPaD091s3+Ab66Jys0R3IMEMbvuBvH/Guchlyc40zr1Af3B77iX9uQ9zqX9G
aSTN3EV4OP4cyJDi/FtSGCsLN8Va+CZp8hA31t+H0d+Gl59NHYAr7vTY5UKyFnB8
rvs49CARam811JcJHP1+aZiWfGzvQvcZdg3frM/EZG5NjQUR6Ub7SqOXXypWCgFE
YGYJvzXCgjvDXFTHtoDGjVKwJ+Os5gbvUSUC0BvXqRy7WSBbYfQRMBAEcR0cuPJY
QB+dCjS9DgQCtz1zL6DEe7yKeJ9jWhPr/nTDy7zdDUCHfIkxkGglAmkeAeRd22Am
kHAHesr2j0b9eK696vHa
=ICyu
-----END PGP SIGNATURE-----

--nDtE8k2pYjsRXajv--
