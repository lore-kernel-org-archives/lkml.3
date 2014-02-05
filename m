Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaBERGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:06:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36363 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaBERGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:06:37 -0500
Date: Wed, 5 Feb 2014 17:06:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140205170632.GD32298@sirena.org.uk>
References: <1391619387-18043-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Km1U/tdNT/EmXiR1"
Content-Disposition: inline
In-Reply-To: <1391619387-18043-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: max14577: Add missing of_node_put
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Km1U/tdNT/EmXiR1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 05, 2014 at 05:56:27PM +0100, Krzysztof Kozlowski wrote:
> Decrease the reference count for 'regulators' device_node, obtained by
> of_get_child_by_name().

Applied, thanks.

--Km1U/tdNT/EmXiR1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8m+VAAoJELSic+t+oim9iA0QAJjz9Ehj8YmPqFcOoAtG40iV
dY1R+AFaDye9Ph3bZN9Hsoi6dg4i0Fv/hHZ7UAYKSoz7xxIBlcUEq3eiz3Ujq2Lq
UxsWWzsTXliFjEFAGK0vEnLmnuNZLSFkCJ8djG6SQTm05/5rFuBG5e6/OwCTdjnD
41s+jJNZd5jyK3GfDWIWrtrZQxtn3zetr2EoRMv3NztZKj6+iD0qpj930fOlqubb
HorN3deCj4n2aXS5XAoXYjXgMuC/OF/9nN5L9TO8JdSZKvYERkFAj/kmhFden3oY
CJQm9+oduP+totZwg4X+V4ImRByJ7Gw7K5b7g1EEK4R8226Nass/b8/r4tNLVeJt
VGyo8RAypH84exeSIAn+RHiJJPUQO6Pk9S1kW7zAefL06H2YWb2AngN5lcFqNpLM
UMEknBAy/ZVDP5RhpsKtphUfblawovXsA+VFY+fDYROTNNEXxEaU0vYfKbhIQ+m0
rDhFbH5GZdBQonr0TNS1IfbloLNTGI/PwcZ99z+HqYW3f4trRPwmwl+dr+wM/hAF
KjvySkPf1SSqzF96TZRqRxQrqvXsEb2u/9WNkg+59cVrtNyU3bEKiIytfpB3TVlS
jRnT4spoiRgGQFP2the8noLtwFTghsFyEP6Uo0A26VE3/OPs3E9NTk6DvOjQWPCD
DSzhfx1L9cLtGrGnHuXX
=P2/6
-----END PGP SIGNATURE-----

--Km1U/tdNT/EmXiR1--
