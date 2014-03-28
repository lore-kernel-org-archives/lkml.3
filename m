Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaC1PaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 11:30:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36901 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752433AbaC1PaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 11:30:07 -0400
Date: Fri, 28 Mar 2014 16:26:05 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com
Subject: Re: [PATCH v5 0/7] Add support for the Allwinner A31 DMA Controller
Message-ID: <20140328152605.GU6120@lukather>
References: <1394723659-4995-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pzbqGaOtRNiVr7w4"
Content-Disposition: inline
In-Reply-To: <1394723659-4995-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pzbqGaOtRNiVr7w4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan, Vinod,

On Thu, Mar 13, 2014 at 04:14:12PM +0100, Maxime Ripard wrote:
> Hi,
>=20
> This patchset adds support for the DMA controller found in the
> Allwinner A31 and A23 SoCs.
>=20
> This has been tested using the newly introduced SPI driver on an A31
> EVK. Support for DMA-driven SPI transfers will be the subject of
> another patch serie.

Do you have any comments on this?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--pzbqGaOtRNiVr7w4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTNZSNAAoJEBx+YmzsjxAgzTEP/29xLY+xMVVlvOOS/Cx948di
PemleSQIuFpDD5+BSuJe3FCF2lm2vnVuRJDBHNqtfjWMP8iZBUgf3J3ZmExeoagU
+NwBX11iOT2ShL5IsCubVRVuiOWivK1MtrNXP5qLAHgBph8y4nVplC221C0SAdLP
tGruX9YTvdGbyJHg3RC2DttyyYrT+JkFzJUYSbtoGc6Zq/XcwOKnIc4NdvRI4OSF
HLuOR2Teo/buRhdjLNKkjuT6yGFSWvlbLhNiQi3fdCqWJ7A63oK3SEG+YwgsN3w9
QEYDl6aGzk8bKQzn+IGCajxUtY01x9Zhqhclc9A0s5LTCqVqiAX89yr2hDrEwupI
nIeR7zFWSbeyAqbZkAeya7Bh7ifA8WVEP0eEk0U3Jy+TjHjkcbztVbJ5ziuQRpjA
eD1S1MD3icAD/rxFbTPEaBAqAnAcbXaFvIKOPk4jeTkEubEohb85FyFTuIkiAznN
tfzgeB82/pdFMgtSEbFutXVF50SfCrswhZoMn7nDE7SoQMI8FexEo1WSKHgulFcA
qrj0GHWibBMUkh3KuIgEKoxurid+jU4aGaP44vqSzpIYznnfD+eNJrOSbmKGL5mk
BKF+AU0R5fMFNq+S539GEQMGo3c1D3hyB3xYrGax0hsq9lwt6/fxXIsWp0Cx7qVY
wCfJ6okI3quQ5woUGVXN
=x1oH
-----END PGP SIGNATURE-----

--pzbqGaOtRNiVr7w4--
