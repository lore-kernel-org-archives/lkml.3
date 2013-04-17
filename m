Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966589Ab3DQOGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:06:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55189 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966386Ab3DQOGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:06:17 -0400
Date: Wed, 17 Apr 2013 15:06:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, sameo@linux.intel.com,
        ian@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/3] regulator: palmas: support for external regulator
 through control outputs
Message-ID: <20130417140614.GO13687@opensource.wolfsonmicro.com>
References: <1366191793-13934-1-git-send-email-ldewangan@nvidia.com>
 <1366191793-13934-2-git-send-email-ldewangan@nvidia.com>
 <516EA8E6.8040403@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XVTPT6MZt3zd/C+/"
Content-Disposition: inline
In-Reply-To: <516EA8E6.8040403@slimlogic.co.uk>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XVTPT6MZt3zd/C+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 17, 2013 at 02:51:34PM +0100, Graeme Gregory wrote:
> This looks good to me with one proviso!

> SYSEN1/2 are not necessarily for regulators as given by the name, they
> are more for use indicating to other chips that power is now
> available/stable.

> But it will not break things to have them exposed in regulator API so I
> shall leave this to Mark.

It's probably reasonable given that things like this normally end up
being part of the power sequencing or used for external regulators.
Applied, thanks.

--XVTPT6MZt3zd/C+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbqxQAAoJELSic+t+oim90aEP/20yLAZAUeZxjmYLKq1bPDKp
SxuyHvrwOv7PivxzOwR5BO4EiYLpgKeScXfrOipHx88sNBDl0uOF1z/o+Cvt1Pdd
S5OC7jUpasWN7W1XrwIMqziiVANxrzjHW2gckD+kDwo7qQfS4rehI8YkUd5AyPw9
WKB11Pu9GiPKch67X3obINEzD38QXHV2oc2J2geZuCA+XPa+8HS3mMug5uDs7Aoj
IW2a9FUxYms+6U2an409T7Uqea62m0XedG92MqXwPM4xhHpVYKcYtJxRy5zHOF1D
E+VAwYHJac9kT+cTzoN6f7F+NeLBI0GC6ujl7coQoo5FeEHawiVmORGHy7uHzZSy
fP/z1vvqMbnjfBniHUYVvHkVQb+rQ9rSRXR2c5aUK+UYqn0FV+im6f/DU/tvPCgY
EinJOAcP7FGMOu8GdOSiNlosaO0hef39aGVyTJsa0dS77ot7MashfDPJNKcIlWU7
YIoPIzsgbG0ILTUHHj5N7WwBAMsp73Z4aaYHbN11jjVFVpAAHHZaVRSn+tFsbI9m
MEYFgr7k7sTuAIL3T9odKLbUz8XGEprDrlkcbM5Dt30A1RQ7C5un7YoD9AES2SNd
vHHpxjzGvOY7F3dXT1LeLyZMeJkEZcJblk0khD3Q91Cx55kZKkafcvf1asJsGDs/
DjnzwhDvcyj0t5PRM4yx
=3HTz
-----END PGP SIGNATURE-----

--XVTPT6MZt3zd/C+/--
