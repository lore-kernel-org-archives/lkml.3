Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaCGPjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:39:48 -0500
Received: from sauhun.de ([89.238.76.85]:58238 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaCGPjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:39:47 -0500
Date: Fri, 7 Mar 2014 16:39:42 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Barry Song <Baohua.Song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Pavel Machek <pavel@ucw.cz>,
        Shawn Guo <shawn.guo@linaro.org>, Marek Vasut <marex@denx.de>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH] reset: Add optional resets and stubs
Message-ID: <20140307153942.GD28943@katana>
References: <1394202623-20229-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8w3uRX/HFJGApMzv"
Content-Disposition: inline
In-Reply-To: <1394202623-20229-1-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8w3uRX/HFJGApMzv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 03:30:23PM +0100, Philipp Zabel wrote:
> This patch adds device_reset_optional and (devm_)reset_control_get_option=
al
> variants that drivers can use to indicate they can function without contr=
ol
> over the reset line. For those functions, stubs are added so the drivers =
can
> be compiled with CONFIG_RESET_CONTROLLER disabled.
> Also, device_reset is annotated with __must_check. Drivers ignoring the r=
eturn
> value should use device_reset_optional instead.
>=20
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Yay, thanks for fixing that! Do you pick it up yourself?


--8w3uRX/HFJGApMzv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTGeg+AAoJEBQN5MwUoCm2OjsP/iTZAwZkkvmJ5pyXVjs+m0dM
lgslGKq07HUaAE40nCmoU7HJoHUVi3/eg/cR+f9NfgJby/rtkybZbV3sDhX8V1CL
MH5vmX4YiQK9PafLahbWRKL4wWPBzXBrfMTS76UaMjx/vzW79nu8qAJAHsLTgPMJ
CE5UQMrWpqaYSF/nk6AoSbH0pi5zXrucH/5oJ+i3SD+Qtu8HJgXXlGMHJky+DbCo
maqUOLp0NcHf26XOwpynSBUCTKZY/VZxL7+aenJ4m4JeaEW0l7LzE0mcIXnInbxg
j9888nlOQOgyNQFFKF/7fSIkPAFDWMR09xQlwq/KKRTVF5SZm3Nw0MIC3h7JCY8n
0K5EXk3axZT4+owB7FScUXmO47CxU1n6NM2MFYl0hiJ1krRS1KwGE3M16M4PNxiH
JxuwQfh7CLPZqqxUaGRfQ6mX2s3VusH7Y5tUTcOOC7pzH/M+gkkERoE4LWmRnhJc
cnnvVNGV5qy1RUofNMI4T9iRP6d+Ks182P2cALlXvvcrNB/QOIgMrGT75N3AUyRU
NjPpiBeHqWyaekBLHqREon81szzBdO9mcvbK/iqnMG+U/xEMCVrgjt5tf/1Nx00H
SEQjR+czw1WwE/NERcdViHpk2ldP7XsUfCOBTiTsRLJ+HkGcYNLXkhE4exRE2aro
eu/4/uZFsJFQtMAp71te
=FaJK
-----END PGP SIGNATURE-----

--8w3uRX/HFJGApMzv--
