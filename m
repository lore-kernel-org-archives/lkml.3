Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3GAKCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:02:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58821 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3GAKCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:02:06 -0400
Date: Mon, 1 Jul 2013 11:01:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: lgirdwood@gmail.com, ldewangan@nvidia.com, gg@slimlogic.co.uk,
        sameo@linux.intel.com, j-keerthy@ti.com, linux-kernel@vger.kernel.org
Message-ID: <20130701100136.GA27646@sirena.org.uk>
References: <1372672182-14778-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qcz4xfO8nvR/PV7q"
Content-Disposition: inline
In-Reply-To: <1372672182-14778-1-git-send-email-kishon@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] regulator: palmas: model SMPS10 as two regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qcz4xfO8nvR/PV7q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 01, 2013 at 03:19:42PM +0530, Kishon Vijay Abraham I wrote:
> SMPS10 has two outputs OUT1 and OUT2 and have one input IN1.
> SMPS10-OUT2 is connected to SMPS10-IN1 and can be configured either
> in BOOST mode or BYPASS mode. regulator_enable of SMPS10-OUT2 configures
> it in BOOST mode. For BYPASS mode regulator_allow_bypass() API can be
> used. SMPS10-OUT1 is connected to SMPS10-OUT2 and can be enabled using
> regulator_enable().

This doesn't apply...

--Qcz4xfO8nvR/PV7q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0VN9AAoJELSic+t+oim9HQkQAIXtf0/KycQfAEjh37ha8eAy
/wPVtYX+sRpOnn+g8J2pfBqgaK8EvgxPnIDHHRN6zRRmdlj9FzpRuxGkIBQ1/8SW
q64bEgY2zp4BDx+FlL6Jyalsqp6XXxVTeEmUMXuQWTZP0MjrtFomoCSsp5sAWoFe
DFlbm9H+3eDlbFeGoRumAiw0qKobofVTqK0SKL7fpGFjrZahmFBmYAv3NoYVnc4P
vOWUZk0ytZsaebFNCWJTCXEmiscbnjzpGi+UHRgzcDTR1eM5Qxk5r9/XXZMk/ydn
NgJ2ZnuTqWmF9OqRfxSmGfZ0V42EgYe0RpYOrNLZELJAuJJ3ukhEtk+0JByFEzS5
nTbI23SOrMZO7r2tdvmW23MSmH250/iCKB5uUFGTWM1yxd7G5SOL1nnI01GnlXcr
ATNEJsYbPSZFmYFXGy89e/J7lD9xw/HU0idXA9NAQzynWUa9q2r4FgexoUbVyUsY
jFvuDvhzMbqUfNgnzIuwGk+PWrsZxX0dSSeWXEFi8M2dFGEr29Ptsg0SDjqcXLa3
YgVEJH3DbloRh+8uohemc6gsqWateiPHGXt+913hG+Xzxn2vm2KwozH9e7hpTSQs
Fin6FquCsCCBmbI0paQU/Pq+wGUD7Oy8khkfPSJz+DxEJHYAsTrBcnQjOsrwNt25
GdJLHrJYEjRyzluKuRv9
=E13x
-----END PGP SIGNATURE-----

--Qcz4xfO8nvR/PV7q--
