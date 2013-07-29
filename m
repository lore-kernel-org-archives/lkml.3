Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab3G2AI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 20:08:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58073 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3G2AIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 20:08:54 -0400
Date: Mon, 29 Jul 2013 10:08:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: problem fetching the drm-intel-fixes tree
Message-Id: <20130729100843.8d129b9953ed39e55e1d5a31@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Jul_2013_10_08_43_+1000_.u+JDrzj9Hkp42Tn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Jul_2013_10_08_43_+1000_.u+JDrzj9Hkp42Tn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Trying to fetch the drm-intel-fixes tree
(git://people.freedesktop.org/~danvet/drm-intel#drm-intel-fixes) this
morning produced this error:

fatal: remote error: access denied or repository not exported: ~danvet/drm-=
intel
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Jul_2013_10_08_43_+1000_.u+JDrzj9Hkp42Tn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR9bKPAAoJEECxmPOUX5FEeAMP/Rn4k/F+6Id++ZNJulwZdc2r
C2ihpE/VX8uRKyII7JJanb4++ATY8BYYi7elrhpY4fKZUxUwWVY9CMVTUus3lsAp
U7VykThksQrsfH5DvGMFQMtU+Bmu75aAOenoqb3F+rMURG313OEx0EhJtYO9jiKb
Ax6JsxQiC0zdOEf30R4KJkNsBcwJxxTG0DOVEtVxNNb8oOLiwcm1/CIF4VIbZiU8
j9QHDvADhd17fKt1q13Hx7Q8+yyC+ggVEeiJLfzJNIJkDAtGfBCxoaZi3XUuiRRV
DN0onXXUXdIza/mo7YNOkl1+1y9kZb93rjuiToWXnnFjqV10LTIQBjD41+OO2xIW
Zjwxt6K8SA9D6R6fAAe9wXZUbzLE5Oz4//gYvepeaCuVysdDJcmsE1y/qa7QwITh
ZYsMrsmgsho8R6JAeV5CGgxp1oz4+ByuFKNwzsi4GTl0aBkQHut3SxZ823Z5/KAB
PLQ32GqyVWSAlqLbFm2DK5lQCIMrVHzhc6+lGBKLt+ibi54Cnw3FBVHveUq9w8Im
xTtHzP5vjxGtcRrqJyOI1ypA7mcb70X641tyi3CpS6Q8bVTQ3EymNgJGUTdEnqAx
46ZqIYdeGDUTGhWHp79ffMrUsa128jAH9goTWp854g4XPSTg+27+IjMJvhgJvH/S
063pghxHmCnxOY/VKHDe
=1AJb
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Jul_2013_10_08_43_+1000_.u+JDrzj9Hkp42Tn--
