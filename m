Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbaEMHsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:48:33 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40670 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbaEMHsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:48:31 -0400
Date: Tue, 13 May 2014 09:46:30 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: sonika.jindal@intel.com
Cc: David Airlie <airlied@linux.ie>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Dave Airlie <airlied@redhat.com>, Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Archit Taneja <archit@ti.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Subject: Re: [PATCH 01/12] drm: Move DRM_ROTATE bits out of omapdrm into
 drm_crtc.h
Message-ID: <20140513074628.GE6754@ulmo>
References: <1399622493-31701-1-git-send-email-sonika.jindal@intel.com>
 <1399622493-31701-2-git-send-email-sonika.jindal@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YkJPYEFdoxh/AXLE"
Content-Disposition: inline
In-Reply-To: <1399622493-31701-2-git-send-email-sonika.jindal@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YkJPYEFdoxh/AXLE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 01:31:22PM +0530, sonika.jindal@intel.com wrote:
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

This is missing your Signed-off-by line. Also the patch subject says
01/12, where are the other eleven patches?

Thierry

--YkJPYEFdoxh/AXLE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTcc3UAAoJEN0jrNd/PrOhaKUQAJncbPFxTr5tYcP4P31QGLC1
cH+woF8i25ULjG0gNs6dSOipIj20pL36hc3tGXHTYN9nDMMKdcZAlCgZvhA+h32c
IjvThZR+km98vlxNIzyk9bH5XwPo7a4mJ+P+n2VGYsQ92EzJPXHWRDXvFMQW80bS
U3u07VUqVzovnwPVpo2igdltdLXapSWbKd68M3J8sGUtTmYg/Jfk8gxUBGHtFPvK
e4wE3GvZkwonTNonzZ+EQuvZu9MnAbcPEOLCGFCwTXpIj63AMHV7fCHFBXZ+BH9C
F4ZnFHgomdLgn88tNeceP8yES99H7U3z2QTHmGmiKRBkDRkwbKAeDpUIvAVWVi6Z
1aDHOIu5MqNNHss21lXK2EqklYLyucK+UPKQKImUuFHYOlhPKJhq95Ebaqyb7UDG
JKk0I3HZKB080uF/iUzWiLKNUh4O483zujmqRR25heIUXjGI+VRZFlMgxBhQq4eF
VOay2p6j0JQdqQEquUupCXgvQIHTG2qghp/MQoeTNRmonR3BgHh7LNE7Iazx9Hhy
l5YkU+dm++wEV6qolDrvh6fIJhVlmVGYxMyEW7JnRi+po5sHl8aRmRgtKU6sQhIl
hp6BTKP+H10hiyJ/3msLwMccc/1+nDYckGtbdpZjEiDntw4P3x073RWA3QUeL8En
K/EKC5+7/h4+pRMeBeiW
=QoUH
-----END PGP SIGNATURE-----

--YkJPYEFdoxh/AXLE--
