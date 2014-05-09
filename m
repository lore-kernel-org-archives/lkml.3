Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaEIJWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:22:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48769 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbaEIJWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:22:11 -0400
Message-ID: <536C9E32.5040308@ti.com>
Date: Fri, 9 May 2014 12:21:54 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: <sonika.jindal@intel.com>
CC: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Archit Taneja <archit@ti.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Subject: Re: [PATCH 01/12] drm: Move DRM_ROTATE bits out of omapdrm into drm_crtc.h
References: <1399622493-31701-1-git-send-email-sonika.jindal@intel.com> <1399622493-31701-2-git-send-email-sonika.jindal@intel.com>
In-Reply-To: <1399622493-31701-2-git-send-email-sonika.jindal@intel.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="oemToEPslohj4MTutTkpHX6nlhXppLO9n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oemToEPslohj4MTutTkpHX6nlhXppLO9n
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/05/14 11:01, sonika.jindal@intel.com wrote:
> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala at linux.intel.com>
>=20
> The rotation property stuff should be standardized among all drivers.
> Move the bits to drm_crtc.h from omap_drv.h.
>=20
> Cc: David Airlie <airlied@linux.ie>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Rob Clark <robdclark@gmail.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Archit Taneja <archit@ti.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> Reviewed-by: Sagar Kamble <sagar.a.kamble@intel.com>
> Tested-by: Sagar Kamble <sagar.a.kamble@intel.com>
> ---
>  drivers/gpu/drm/omapdrm/omap_drv.h |    7 -------
>  include/drm/drm_crtc.h             |    8 ++++++++
>  2 files changed, 8 insertions(+), 7 deletions(-)

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi



--oemToEPslohj4MTutTkpHX6nlhXppLO9n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTbJ4yAAoJEPo9qoy8lh71lJwQAKWWNeMF8bdnZHi7pPwaMswD
Pk15JXUPe5c7e3Z8OoouFlwGj0+K2w6r8DNR9MvXUATh41U+HiXIvHXk+OeV6NIH
N6zUrY/EHB3JiQ9HtdUpkAgCIOltRqTwAGbfVrrTwYUkY5SPhN58Ex8ooshSZCev
SkSWpgxHjSVWENU8ELNN1QZxqhNbTfmifje5PO4vT6bMzlpqbhu0VpPjiWkKMs8b
JAwd83/4tcVvJLuP/dHvdBBqPY9jq2uqGbreVzSlnM545ZqmOmmKVR4SdI8qZunf
R9b4cuf8z5oHSCvzS02Khtgh2onrmuSUlCHbn3pR1xNQGf94J5ug049JH+pWmEAq
rUK5LprpAuy8G+dY53NI4e4Kaw7rQYjLPseZeC9zfNCdsJdH7FWYNQpLOg4uNcQB
sOeOCaYIFk6WyDJDotg4SQrDHTo5D/OF/rnWZx6iW/EdQ44unO6gmx/IBFM+mG4B
g4Khk74WHGzPV9sPLZdnRsxE/8y5ozWkDX6+CzKu/w0yhpJS62usztVKV61y03XV
inSds43tj3y8gK0oROW6iykMmz8z/4Zq0ORopF8/es+XGvDCvFal1im35Y+40XlQ
XCZdq39qxp5b/baTav/5qHYbARZQnuz0d5w4hsMdfgNoMVhlyLUZyYGMuu9sidsP
oArRiKbl4X6E/4Pln1b0
=rYhj
-----END PGP SIGNATURE-----

--oemToEPslohj4MTutTkpHX6nlhXppLO9n--
