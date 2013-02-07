Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161118Ab3BGSsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:48:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58171 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161002Ab3BGSsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:48:21 -0500
Date: Thu, 7 Feb 2013 18:47:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 03/49] regulator: ab8500: Fix for regulator_set_mode
 functionality
Message-ID: <20130207184755.GB8879@opensource.wolfsonmicro.com>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
 <1360148051-7560-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <1360148051-7560-4-git-send-email-lee.jones@linaro.org>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 06, 2013 at 10:53:25AM +0000, Lee Jones wrote:
> From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
>=20
> Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I applied this and the previous patch squashed together - this fixes
code added in the previous commit!

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRE/bSAAoJELSic+t+oim9nFQP/A/dRS0Pj2ygyraNTfG2a3lS
Kqwndp/UxNSKHC4N3V/G21koJqFXP2rR1OAN878jGT9MenfZyp3jx2Lt3pMI3rJn
K35NzgiZc22ZL0cl4TGlsJoYDwGmPNNQwpXNVyaMCLTa/lTdUwkYfrR2H5PxH7a4
UHjlmVj/WI+zIbUbJjhGCNWfFuxFwPwexU01k74AlItDarYROUQ8lYeHpSfO7sOT
cwqvYDVAR58EqxwLmtHlNVP+sG+LXR+l77P9xQ0f5uAPeue5wpI+yAiDht9TbJ1C
56wLhh9BksXP7ufszH8+W66k6lSp6NfH7k/yDJzOutU27UFyiv8nKIBfQEvuNP0c
DscQ2QbiQYxlHo2qBaO7NUn7ifDj/nY3NVU6YnlSrFtNHC3J8x712HGoYcaVCELt
Rq903O/PO8Ro3Rs/xsOXA23fMoS5IEZCz76e4puoL5Fww3NLKGw2T4bHXaSorS6H
BUZogVhhNB86Qc7kQvQBIGe1HIY1Vd+352VLEro/7xwWT7Wcw1FsjOV+6izs1h23
ZpAlyENvI52MfgJXISCXAS5T7pSoDSmzITKUdA1QXNN/8zImyGZtFyrzYkNrO0+J
zRthOK8/SQ+3IDSALxSesKnsmRBpMClW2GLYhLm0qlm84Au3XOl5zDY4cB57pgwH
LaVPlLdJACrhx96MaEV6
=GYMy
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
