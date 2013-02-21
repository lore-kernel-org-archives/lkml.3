Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3BUGmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:42:24 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:34942 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3BUGmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:42:21 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: maxin.john@gmail.com, gregkh@linuxfoundation.org
Cc: matt.fleming@intel.com, matthias.fend@wolfvision.net, balbi@ti.com,
        linux-usb@vger.kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "Maxin B. John" <maxin.john@enea.com>
Subject: Re: [PATCH] tools: usb: ffs-test: Fix build failure
In-Reply-To: <1361404671-11713-1-git-send-email-maxin.john@gmail.com>
Organization: http://mina86.com/
References: <1361404671-11713-1-git-send-email-maxin.john@gmail.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.5 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Thu, 21 Feb 2013 07:42:09 +0100
Message-ID: <xa1tip5mdv7i.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 21 2013, maxin.john@gmail.com wrote:
> From: "Maxin B. John" <maxin.john@enea.com>
>
> Fixes this build failure:
> gcc -Wall -Wextra -g -lpthread -I../include -o testusb testusb.c
> gcc -Wall -Wextra -g -lpthread -I../include -o ffs-test ffs-test.c
> In file included from ffs-test.c:41:0:
> ../../include/linux/usb/functionfs.h:4:39: fatal error:
> uapi/linux/usb/functionfs.h: No such file or directory
> compilation terminated.
> make: *** [ffs-test] Error 1
>
> Signed-off-by: Maxin B. John <maxin.john@enea.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  tools/usb/ffs-test.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
> index 8674b9e..fe1e66b 100644
> --- a/tools/usb/ffs-test.c
> +++ b/tools/usb/ffs-test.c
> @@ -38,7 +38,7 @@
>  #include <unistd.h>
>  #include <tools/le_byteshift.h>
>=20=20
> -#include "../../include/linux/usb/functionfs.h"
> +#include "../../include/uapi/linux/usb/functionfs.h"
>=20=20
>=20=20
>  /******************** Little Endian Handling ***************************=
*****/
> --=20
> 1.7.7
>

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRJcHBAAoJECBgQBJQdR/0NtkP/2jWuPSiN+5R1Y8DiGzypA1f
LpEKXmd7fzR1eSwQF5DzEyEcRSux3LHl8UXJoxUrQX0aRcWnXCctbLKrstbhL5+Q
XoDTvZqyeYxfKW2IHyhSyvZAwiWx9ufwFpDjBHd3O64shRkm6mrM2qgROAHB4w7D
1zlANOGWPVvXMNQ26stbi1Z+EwyH3I9wtbgsMUFP2IqrIyU+YQXqSEYJXYtzNv60
ocut+EdfxLa/Xg0GcL/QKdvit0umCsj1jGnFUekmsPgl+WukN7QU9dQf6FeZBwwT
GxsSvPon5IV3pNNHM2+1ofy1LGPTRpUFF4WwMtW1kwz/Lednj8dlblMivcAxETaO
IuQsNyLeecr+h7la76VwSR3AZrqcs7XMjvC2zsGELamQIJ+XwejG+Sj+lSEhw9N1
YCesbCgHxXB9z5PlWR41dYBo3ik/7UKzFNxzfZDX4hOXchLpM7o8isqzN4bCfnsr
XnImBEF9CRrYs8sCrXnN7jdJPmnSJIzNtl63biW4tszO8SyeFwuIZd/Cj6Whiv2G
VYWPjX0bNShtD+rdG2L2WPKR6cx5nwcV0MYSDM7fUFXp8w6VXNP/5g/TQiNqVo65
rlEw+7fcxzyWoStgB3NsLkSypvS62xnFP8jsYu3y3PYVm0EatFNTm2uCmWgRrIy/
kPSnTRW+HLpSDgrlEhDO
=AkDf
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
