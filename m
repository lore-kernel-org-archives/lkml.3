Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab3APHMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:12:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55426 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758171Ab3APHMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:12:40 -0500
Date: Wed, 16 Jan 2013 09:12:35 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: remove unused APIs from Tegra PHY.
Message-ID: <20130116071235.GB610@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358245170-22083-1-git-send-email-vbyravarasu@nvidia.com>
 <50F59A43.7050308@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
Content-Disposition: inline
In-Reply-To: <50F59A43.7050308@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 15, 2013 at 11:04:51AM -0700, Stephen Warren wrote:
> On 01/15/2013 03:19 AM, Venu Byravarasu wrote:
> > As tegra_usb_phy_clk_disable/enable() are not being
> > used, removing them.
>=20
> Greg, Felipe,
>=20
> Again if I may, I'll take this through the Tegra tree. I think the next
> set of patches that Venu posts should actually expose the dependencies
> between his USB patches and the Tegra clock framework rework, which are
> why I want to do this.

that should be ok:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9lLjAAoJEIaOsuA1yqRErU8P/AhwZ9if8oh/TntxLmpL6dY4
/FMnCObRifBuhgoF6rEq7Myu6C2o6KjA8YUadNlxV1InXiJIwKm02qGwwiL/jJfj
rgcLAOKhRzOaXTfTftFPVOLD3nUcYbo2bbH5i2gbye9k4dfk5k4YBnzs5aPRbE30
9/gzfQuPMNGmJlAiMLtAYIL2yQdpw2ffxENgK9P6StoVQKR9V535SwA+zT+hCznc
rKLPzRBIWOe1uUU4VW1IN4s+zPoj5bKbsVObVsJxRzy8FIDS6Su2CkO72txikoRm
Y498P21jkSB8zZVS2tMzA0bWj7945tVRv5ZMnl4WXy8qhRSQG5MyNpMOjLjoF0or
GCf68QNpCaGhP2o7zl3f+5Wvrj0HyUNJHl4gn4ARDmrDT4FfK0BkB77idE5jk6ug
fMt69+iOZpjEelFJupLuZJl3pR3g7VwG+5uI60/gH4PwikdLS6NZrU50l/R6lRDH
eP0RNjXggaH6p3Y5OWYr9rtVy2f8l/C/olIqLQEsnbv6A1OocmwsIvBgDNRklrcC
dUvt+eAA5tr+iiqiuDi1VgCDNEnzU5bmqEwtRGnyqC/TGNCKnSQTPKYURJR/bjAU
0W/wOBHEhLFj8tGxCZ5pYkhgPeKBH+zHb7opxwM09L6Bnrfez2tNjUoue9guZU54
aRIH2kCwj7rauznDQjbU
=9Qoj
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
