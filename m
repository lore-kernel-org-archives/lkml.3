Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaD1NMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:12:08 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:60293 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbaD1NMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:12:06 -0400
Date: Mon, 28 Apr 2014 15:10:36 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-pwm@vger.kernel.org, broonie@kernel.org, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] FTM PWM adds regmap and endianness support.
Message-ID: <20140428131034.GA15946@ulmo>
References: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21, 2014 at 12:53:07PM +0800, Xiubo Li wrote:
>=20
> Xiubo Li (3):
>   pwm: ftm-pwm: Clean up the code.
>   pwm: ftm-pwm: Convert to direct regmap API usage.
>   pwm: ftm-pwm: Add big-endian support
>=20
>  drivers/pwm/pwm-fsl-ftm.c | 96 ++++++++++++++++++++++++++---------------=
------
>  1 file changed, 53 insertions(+), 43 deletions(-)

This leaves me with only very vague idea of why this is necessary and
why it should be merged.

Please describe in more detail (in both the cover-letter and each
individual patch) why you want me to apply these patches.

Thierry

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXlNKAAoJEN0jrNd/PrOh7mgP/02OkcFVQMoXAGpqQyExAAht
cSwZK1mPhLViEuRCRBOHypo9TtpM3fGgHlHlMbqO5TjWeKMllA/SwqfhF8cBBLpU
BjdYHtAyu2ZVNT1Bv4aLfXA7LuCDkNYTaAoBPuUdkS/dxM4lDHa1We8sauUNVFVp
xm8BxwrczwyS1niMwQJ2YQGbiXTyA7hxE9eqw8fKq4SaBZLVK2kEq/nO/fJaepg3
KyjHgXnldM9X5UlqJn28DXk5Gm0sHSlI7ODIYF8fLPnfhndtk5rThCDyqZFC0s4v
pMSji+0NAlP8deMdRF0low16/ygIAJBhGhq5qmMHFnnVMuyT42SKlrDz7lvTYsaf
YGeFhNB0li0gRVq8cHD1aBHWmFc79PRrmY83a0cPZ7PsfPzD1PjGbAyU81b52/1l
NRkhMpOJ2RTQCe8oNrrFKRoY6hxS6McPP2MVgVAMEpeF/IlXbScXnudMa/UHBnm0
5k2Ymh70s/lqIk/D2Drpw/f7HnJq4xubyAQWIMVW5GsljxkUZQbeLoMgz7Ah0v7/
ajMiX/wQCfxn478i9ZGpg0oRnyIkSxNRrjzhsD/pYWOstvcVa8WhFjh5ujYEJp6i
28gRTj4X4WOaC2v16PLW2hS3eO8/6kEpNxL8Tew/G3SbxwPWHo68gs0qn+XBDNO/
nopQoNt4+PeMhN8IRgK1
=plMi
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
