Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3AVHsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:48:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54433 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743Ab3AVHsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:48:39 -0500
Date: Tue, 22 Jan 2013 16:48:26 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 33/33] ASoC: Convert to devm_ioremap_resource()
Message-ID: <20130122074824.GE1766@opensource.wolfsonmicro.com>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-34-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xkXJwpr35CY/Lc3I"
Content-Disposition: inline
In-Reply-To: <1358762966-20791-34-git-send-email-thierry.reding@avionic-design.de>
X-Cookie: You have taken yourself too seriously.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xkXJwpr35CY/Lc3I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 21, 2013 at 11:09:26AM +0100, Thierry Reding wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.

Applied, thanks.

--xkXJwpr35CY/Lc3I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/kQ/AAoJELSic+t+oim9+lgP/RtT2ZaN2eqUjZNYvk28lze2
DyqZeuuk3YeAQuOwlgAvyhPIwWjb/JQFlsti1msIvFP2IdJAIqWlH4ej8cRynh3z
qYcdpYRXJdvntFJHFyRBhJ+LmL6dnhqt3yQssvLChl3Dw3axs/yOFmgWxjUIxU0I
T4kqkLENT8xES/gvqg09rEeEaEkXT4/7iRrUV1CvG2IMfaUKkfmuJKGqypbjjZ/z
GkTLcIVWAXoQOEMNsXc0z1Fntz3budhVpg2XycBKD2OwNI74h91gLv/XL0ahZSV7
A2iz+RqcUlWdMWmY+688owz71bPun2+hOpgM0bC/nqUlD3gd0ritW7YQnrSbxvBA
2Mh+dyt/LwiaAbBXE1nMbk432VkFnwv0M3+tz0uJ7Mew/0eL5BEKpVORS21o1Inu
o+HpA8at6X+AFOBbhhsxk7bFr8NYg/yI7m+U56o1uxs4TjY3tNBcHK+p7DX2uIs0
ZPM93BDwDTSWpqgopJ72p8Zgy2+3pPJ4Kr8IA1QSnyUkqHc2HPe+9AhbOzMAz5xo
bJtTLlKWxoPV9aCtcdPUXiX8Pyev0fKDMd+aYVJNfq+YF0vCMW3NdnwfFSKtAsct
njE4qIuRiyIIqn7xHi7EXR0s7q5jwPYjO3DxpPp073xiC1kT8nrju7lknRLpjAyG
t4s1ciaHCpekeoGJytAF
=l7Ak
-----END PGP SIGNATURE-----

--xkXJwpr35CY/Lc3I--
