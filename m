Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaJMPco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:32:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38036 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbaJMPck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:32:40 -0400
Date: Mon, 13 Oct 2014 10:32:12 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <mina86@mina86.com>,
        <r.baldyga@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH v2] usb: ffs: fix regression when
 quirk_ep_out_aligned_size flag is set
Message-ID: <20141013153212.GE21709@saruman>
Reply-To: <balbi@ti.com>
References: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
 <1412802738-28839-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r7U+bLA8boMOj+mD"
Content-Disposition: inline
In-Reply-To: <1412802738-28839-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--r7U+bLA8boMOj+mD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 02:12:18PM -0700, David Cohen wrote:
> The commit '2e4c7553cd usb: gadget: f_fs: add aio support' broke the
> quirk implemented to align buffer size to maxpacketsize on out endpoint.
> As result, functionfs does not work on Intel platforms using dwc3 driver
> (i.e. Bay Trail and Merrifield). This patch fixes the issue.
>=20
> This code is based on a previous Qiuxu's patch.
>=20
> Fixes: 2e4c7553cd (usb: gadget: f_fs: add aio support)
> Cc: <stable@vger.kernel.org> # v3.16+
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>=20
> Hi,
>=20
> Since this is a feature that worked in past, this is meant for stable
> versions >=3D 3.16 too.
>=20
> v1 to v2: just added Fixes, Cc and Acked-by lines on patch description.

this adds a build warning for use of maybe unitialized data_len. Plese
fix.

--=20
balbi

--r7U+bLA8boMOj+mD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUO/B8AAoJEIaOsuA1yqREDmoP/j/iGFBFMknQfWPusWLf9Gw+
NV6dUNMN9WYxiDyqBUBinwknqkrW31z/w/Ls4Tx4F8wQNM+Z+6x5elccLokk6CML
VRoI51tVr5Wk0QMtYRPelYt+5bbNuZ3hCdlGNo8wWzMTAbnnp7TMCgrTltz4fRRU
t64oFpJCcVGQ11mjdL1imix/xgX+LLHiE49ep57fob5kvE/P1rrtCoRd1WJSzj+K
KpxuCo+owsMyLio1mpw7OCUSnshvojRd6hUVzy0GQpxN2+iF2PwMqgx2Tpr1vEig
iiElZPJj/a2dYJTjxNCN9cbufQ+lUAL9xVKF1R6EUDFAFDtxVZK7tgXoGOHnv3V7
5/fYHEtgrqbNkxf5Lpl4E9sNDqllTOV7awrwBk6KiaRsnIef6aBEgUTxalMr5OqK
WWI3QibJxOJsmzD7xneqYDteM6oEEg537H/02yWWoFUV02ctBwpasaunfgVuyjrt
0k7NxxkNFuDfxqGpOtjSiK46Byrl4K4Iqz+niYAXFon7vT7MmA+HJupib6N4lACX
LBWiPizfzMG51iYnf/8qDCGj9Z3qg1Zmm4NQW3cO8qZtDMHDzWklCiy82WLVE8hO
oj6q5ZZ3PX7Cf8oHFIeAdX3KdUdnXgV+LWpWPicfW0T4DTLZh92C1xyokheapd0D
Jl3/rHTn0W9NoSFkVf42
=LJMf
-----END PGP SIGNATURE-----

--r7U+bLA8boMOj+mD--
