Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3IJMK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:10:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48962 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3IJMK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:10:26 -0400
Date: Tue, 10 Sep 2013 13:10:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: rob.herring@calxeda.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        rob@landley.net, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20130910121017.GI29403@sirena.org.uk>
References: <1378811888-2268-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WgiIge0Euz4ksITr"
Content-Disposition: inline
In-Reply-To: <1378811888-2268-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: palmas: configure enable time for LDOs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WgiIge0Euz4ksITr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2013 at 04:48:07PM +0530, Laxman Dewangan wrote:
> As per datasheet (Referred TPS65913), the on-time for LDO is
> 500micro second. If LDO6 is in vibrator mode then the on-time
> is 2000us.

Applied, thanks.

--WgiIge0Euz4ksITr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLwwmAAoJELSic+t+oim9dCQQAJpUsIXVyCimwvbS6etMum0j
9F9fhSBnRtfU6NqD5cO7vYafElSnmYSWmUVMsLtHyQYcOmkI/+8LpSa9UtTX35jn
5iaSygTg4thBLDrMdU0JyWuXdh+fZyMlu5u3tTM2Q/XYpvOmLMbzGS7OsCdUcE36
M8GZa9Nk2r/mTAnjQykoIcArj8bI6g5Nv6+MICl4IjIogUUaOkYJnEGJBz/COoZK
jFRd5tFV/DG2/qWGubncvTFheMe9a1ugF+TbVHFz7IUrPUiDr8XNPOuOP6RAv+LT
tQ5qbk3BMVYmzLjW/OjwcG7E47Jq9q7akaCfBD+NZ2ZdOybIjwBDp6tCS1iSYgF0
DwZ15KVpYRSUTabPZtBG9CTKlJQycTWB0gy/FOh3I6IZMcNXkIZBqK+jW5+cFwlz
1D6WTwS+aiREvr5GHigxULZ/GHjPf9k+lfv2uBjfPPKD+dh6SQ7yiVJKIKA3ktyk
6O0JXcCkWu4EJ0PyyY/frP98V+Y6i7eq23n8cowWg+kJavdKOXz3D1wVi3Al3HFv
rckGN++D+WayCmcHDuLGEnupayVdKKMIpz2lP0BUJ+CNdAifzN/dEmF5IqrlPA96
KwWbRxbtoeqW991MfQopBnMx6vIibptDTxHPf/ku5WhvQ1U3TxjjRWyq5xaaM3iI
JO8Sbz0Q1khNar2DA/+Z
=4hDU
-----END PGP SIGNATURE-----

--WgiIge0Euz4ksITr--
