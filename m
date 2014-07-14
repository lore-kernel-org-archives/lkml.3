Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaGNIaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:30:08 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58725 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaGNIaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:30:04 -0400
Date: Mon, 14 Jul 2014 10:30:00 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH v3 2/4] drm/panel: Set non-continuous clock flag on
 supporting panels
Message-ID: <20140714082959.GM2081@ulmo>
References: <1404822734-8603-1-git-send-email-acourbot@nvidia.com>
 <1404822734-8603-3-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sWvRP97dwRHm9fX+"
Content-Disposition: inline
In-Reply-To: <1404822734-8603-3-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sWvRP97dwRHm9fX+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 09:32:12PM +0900, Alexandre Courbot wrote:
> The LG LD070WX3-SL01 and Panasonic VVX10F004B00 are DSI support
> non-continuous clock mode. Set the MIPI_DSI_CLOCK_NON_CONTINUOUS
> to their definition so host drivers become aware of this capability.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/panel/panel-simple.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Applied, thanks.

Thierry

--sWvRP97dwRHm9fX+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw5UHAAoJEN0jrNd/PrOhRtUP/1TSHac25h0fdOZ+f3MI17Bg
fsZmV6Hq/9K3Bjj21gzOJPUsCycGhSW2bov27HBnWA0ltnC6yA9LxXHZw4L46hmy
exZJmdwGQKWMErnwB3sVH0CCaRv3GKqLEud33JUJDbC+ZKEj880waIHdWzw5Z3wV
Fc+7r9FdTKbkVyUSDGADp5mGtSI/8Hr0AGYGVEOOqorlAhTPNHJHfbFl1f1ejPma
LWnNKKHnFZfeFz9B2J1HBLzvtp2GoYq2ztfY76uL5K30FkFruYl+BtR5e0C4eNIg
Sa2o3iVbdwBE8fAI7ARsqbKoJpMuuqCejwGy32YWy3B/bYdwg3apgjm+i0Vc+k+Z
nm5qPVjO7CE1qHkIGd0rSREzN6WWJKNIcVWCnyK4i6j5Z9Dc/FBbfk6m0T57zPLN
9/3Nbh4hGTZ4b/KhqaiU+xusStoA0/5IokU1iMLs3FPkjMeH+IXxyDPmnYhL7Aua
VFRtD1ZGhlMaO6ZPp7stst/jDnCK8fHE6LaaoQucQDphsfITMpLF0Yx5gwHzwouh
OQ6gdPFnzodCRlTSHHzFGLxq0cKINZMjBDGhmUF8Gblq8WFz4wuBQP0eZ7LVnuAE
K72dB3mDc69EAM7Hrqv2jirxfe8TGhifisjOFx84JeFboOTIG5U5mV1gxBNevB8L
LOXwBBh04IFInNJAFa8E
=zT15
-----END PGP SIGNATURE-----

--sWvRP97dwRHm9fX+--
