Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaCNT5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:57:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47055 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbaCNT5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:57:21 -0400
Date: Fri, 14 Mar 2014 19:57:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140314195710.GH366@sirena.org.uk>
References: <cover.1394533640.git.moinejf@free.fr>
 <bfb5bfeb1b934384d84fab0045ce65c9b2766f31.1394533640.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YvpLBQJFkgiI+gkH"
Content-Disposition: inline
In-Reply-To: <bfb5bfeb1b934384d84fab0045ce65c9b2766f31.1394533640.git.moinejf@free.fr>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/4] ASoC: simple-card: Fix the reference count of
 device nodes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YvpLBQJFkgiI+gkH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2014 at 10:03:40AM +0100, Jean-Francois Moine wrote:
> The reference count of some device nodes is not correctly reset
> at end of card probe.

Applied, thanks.

--YvpLBQJFkgiI+gkH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTI18TAAoJELSic+t+oim99jIP/1ZoMbP1Fs2+xIVLjA9s+cQD
44jkodX2PAkl2zc0W6hWP1E8nrD1ugXhMSsBhjQg2mdfbwTPcTVNVSIzUUNFMvdZ
LnTOPGRr/Xzs5IcjVhPra19AeDgQkaQwaNBofS7GeXHDom4bOWKo0tSIUv21v6MY
yPMHVo9NriHynIt2Wh+OH+x3UaRK9R5wDSC8p3S2gqyRE8/vq3UxFno438vtVN8m
vh5vnG/HY4zeFgKiuXxrjMM0E/l8MMCajq5DCJftd5PmGorl7Fuh7UXKIU6MgsV1
qL1ah3TQSdH7DpWCVqyQdC6d3Yq35LE1B0lG7G8ceMIJlrOEYwYghB2Qe29Tcr0F
gPOsQkwlYaiwgUaLnu2EZrMPEmAA3gcivvDbwBrdtRRdOh6o02OkYPyRZQt6M4w0
K14R1B7onGNNCWHNXzmQtI+BVmI9nbw0T6Oxzn5A2OKpz/1GUHpkVhogEKzSndNd
ERHw8We1YkO+AZ2fKM+o0j+dD7p83VPCcWvgXL7zJ+2wvd5pmCE/xabn3duHU23t
HQs/xVE46HIhFZDdVUvf0BQZokegagdq1q5TjKkExYi7GhyuE9TlD+FWf0lgDiGq
xdaHiNQQWOV3G1icbTLPf06jGH7j5ZUnD0IHYgv+MQZCWz4enkySg6/3H71N/lvw
QIWQtgtC/NLE7OCA7l9E
=DajL
-----END PGP SIGNATURE-----

--YvpLBQJFkgiI+gkH--
