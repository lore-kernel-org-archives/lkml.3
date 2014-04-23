Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaDWLbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:31:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42753 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaDWLbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:31:04 -0400
Date: Wed, 23 Apr 2014 12:30:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org, lgirdwood@gmail.com,
        sbkim73@samsung.com, jassisinghbrar@gmail.com, kgene.kim@samsung.com
Message-ID: <20140423113050.GU12304@sirena.org.uk>
References: <1398240264-21285-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zvRX+gpdrLDrHMsm"
Content-Disposition: inline
In-Reply-To: <1398240264-21285-1-git-send-email-tushar.behera@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: SAMSUNG: Don't clear clock setting during
 i2s_startup
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zvRX+gpdrLDrHMsm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 01:34:24PM +0530, Tushar Behera wrote:
> In exiting kernel, if DAIFMT flags are set in dai_link and I2S is
> set to run in master mode, the I2S clocks are not getting configured
> resulting in no output.

Applied, thanks.

--zvRX+gpdrLDrHMsm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTV6RnAAoJELSic+t+oim99NcP/Rb5XcfTKcV0/OSjQQneFRsP
LROuCEy4O0ngUB3dgQ12rNCEUfVfFrwDI1ROX21Z1tnQjK903Q5aFkP05Pwatr2r
IRuo687zG37FHY4xHodUBPL7ilhZ5XpsDiJrlHhrvS0K9pzFVE2MdhbtAuTQuaAH
YN4Jyr6ifs+fyKpuxrKhiNQv3A9B/eLHXMjbHf986TEBEQTRi+Jdl5BU+JJZJXJI
eCudbTTat0BDBdZaBuKDElTxlBNdoWpu8lvJBZrXzzaTlvftbUOFgMI9Cn9c68QT
aQroU02xc3z4fpuzpaFMrXlhG+6tlnzokJWZD4XJXP/YC8thiEUWOu755F0lYoGY
QVqPRQM0YiqDimcAgZ/ft53/VNwxn5ZppEQULiHwXXoCibbPzJbB1t4y6jlc6Gyi
rQgLhGcWB3DXgkcl2QLqloSpeQsBZdBLSvj2VE2J6DkHQHmQwJsmEMS+0MP79wvp
5aRPWFki6ktWhgeZTtZchlh5AeGMQE5tOdJu9vZUygGAeL0AkGWrFwMIgJTTZ+Nt
Yfmbdh8qjOxvXKYZYRJkSwRbWZAu2JhHv58ifz75e0cb0akDoxPhj4+CaQZeSaH9
aeKPFZG4KhDtpesSI0STl0bR9QbOQIn3f6MG0/kHuFscTnxuRHxMJWjq6Smp+ZK+
GwGfSJhjbypYFagj1UIb
=zjNv
-----END PGP SIGNATURE-----

--zvRX+gpdrLDrHMsm--
