Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaGVIPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:15:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60291 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaGVIPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:15:20 -0400
Date: Tue, 22 Jul 2014 10:15:14 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drm/panel: add support for InnoLux N156BGE-L21 panel
Message-ID: <20140722081512.GA18921@ulmo>
References: <20140620201456.GA28814@mithrandir>
 <1406011135-25417-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <1406011135-25417-1-git-send-email-alban.bedel@avionic-design.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2014 at 08:38:55AM +0200, Alban Bedel wrote:
> This panel is used by the Medcom Wide and supported by the
> simple-panel driver.
>=20
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> ---
> v2: * Added the v/hsync pulses for correctness (the panel doesn't
>       really needs them)
>     * Fixed the size to report the physical size in mm
> ---
>  .../bindings/panel/innolux,n156bge-l21.txt         |  7 ++++++
>  drivers/gpu/drm/panel/panel-simple.c               | 25 ++++++++++++++++=
++++++
>  2 files changed, 32 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/panel/innolux,n156b=
ge-l21.txt

Applied, thanks.

I slightly reordered where the new panel was added, since they're sorted
alphabetically by vendor, then device.

Thierry

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzh2PAAoJEN0jrNd/PrOh8akP/j1N6NMocTJB18bVDDUXSc3R
agUIpnGYLu0R+KCDeh9gfTmbxPY+PYzuCYe9597/lfeHnMAaqpu0R6NI2xRtGjyc
wh8ikU/OKCNyTttrlDlttWt4AD8t2NpSwjBEQ5fxHBsbBnfsUCekwnGwquhcpSVo
gv8+sUwAnO3FU7qF+S+NRj2VEpkw4G0CbSSiom4/TFTsWKEkSCQlQFSQNc6IpaBT
nECcCq5f0gr7Th/9VlDbQI08Y/xo/vY8bEvwvNJCdOpaHInzgmE+qVgmR2Z5COVs
N7CWP32mlY6+LB9/Vv0S6UPfDEicn9GlCnXyBpmek7RR3YdkFo0bpl+yUck/4FBE
67jYdoe1SS8atwZB9VMYoPpmhrIgHu5frPfvX3vGOfpRcCIgfpsQxh6KZjxnloHz
ROzrYnlPbTICoUtUHu6LpiboJg1pCd7M5NC6rShBabOykX+GtPAgzBeNDMUolfgx
zw0QdOGFom0LHByWWpgUZ8St+pVbmX3Z6w2qVJfUgsXFQXAUCZk0NYYtCExF8gOp
saoYdSnI8t4v6+UZ/gUwkm3iXJLhRd8h4toDfmZzEwt5BMW+1q4L9hnhfFF03TEW
LZfkNc5AMkhc2TnZ5kQiyTTkccCVOkQVOezj4wsD0xcppqh+2I03/mLa8c4ePcR1
cTc6QFaqRgMUsM+Ew48A
=oAUA
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
