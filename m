Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab3BDTiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:38:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37646 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711Ab3BDTiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:38:13 -0500
Date: Mon, 4 Feb 2013 19:38:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 07/73] regulator: ab8500: Fix for regulator_set_mode
 functionality
Message-ID: <20130204193810.GV4720@opensource.wolfsonmicro.com>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
 <1359978868-28736-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FZIkiClxIZ9JeWSb"
Content-Disposition: inline
In-Reply-To: <1359978868-28736-8-git-send-email-lee.jones@linaro.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FZIkiClxIZ9JeWSb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2013 at 11:53:22AM +0000, Lee Jones wrote:
> From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
>=20
> Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
> Reviewed-by: Emeric VIGIER <emeric.vigier@stericsson.com>
> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>

regulator_set_mode() was only added in the previous patch...

--FZIkiClxIZ9JeWSb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREA4cAAoJELSic+t+oim9KBQP/jF0OTeNmHuaoR/1HsekLc7h
26sBeoqlikjhlSCKIOsIsupeNE4RxXI12wK0XCTBW+rg8Vwt4Ye3BIt016RDn+jV
GWBt+Xh0xAEZgAQ2rjGINz4duai8gs9I3BJrRrvxiKGAkjFnmiiTMNRUsuI5e9Ag
YuhS/hrmvJNuxbmXw44TjDOZvoyF2NBdxL/VhMgXiYMQ92oArHj+4+rVLPM37wRK
oU9MULNZwCEYKKNtVfABJCW6B90GInnqLCbYXCetOVj/yj4T63fqniJzuMOoyMxK
bj9e3qLHz+BfQlrtyZWBIuKfFzCr6Ma2V967f4ziIIeEOFWPYxW94diHgO0Fn5/a
YbTFRw24qq6FuKGzun+ePMnzX6Uaye3DXAKkPhxnGJwJB/kCs48nXOVNEHuPYZLh
W/Qx96NuaN27Oc6mxByyUDF1IoVcD9a/qox7CW4eAgqWpZKewnyp21q+BFldSiTn
lDmo73+h22IClOYq+vTAh3eaRCzZ9viXxBKZaLU8Z7fmtyEoqwT0juD2RqBfrmsV
02gvOQr2PWxSCjXw6uC1ZtOUj9ocLB2sx//D1lWfqpweuK81u506YLIwm7ZindtJ
8TCG71SmGtwjV+1VRnhtfNwkR3hneKJXvQbEpR804uE9C2zY2jKpOb5m+asg0yQu
hUXHoraP8thP9YcnJJlw
=JRtO
-----END PGP SIGNATURE-----

--FZIkiClxIZ9JeWSb--
