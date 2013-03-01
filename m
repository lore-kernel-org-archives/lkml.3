Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab3CAMzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:55:18 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:50412 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3CAMzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:55:16 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthias Fend <matthias.fend@wolfvision.net>
Subject: Re: [PATCH] tools/usb: adapt ffs-test.c to new layout of includes (UAPI)
In-Reply-To: <1362136901-28645-1-git-send-email-andrzej.p@samsung.com>
Organization: http://mina86.com/
References: <1362136901-28645-1-git-send-email-andrzej.p@samsung.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.5 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Fri, 01 Mar 2013 13:55:04 +0100
Message-ID: <xa1tsj4fth3r.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 01 2013, Andrzej Pietrasiewicz wrote:
This fix has already been mailed:

https://patchwork.kernel.org/patch/2169791/

> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
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

iQIcBAEBAgAGBQJRMKUoAAoJECBgQBJQdR/0fLQQAIAZln6cGITOMLNh/ugdGCSh
SiUJ2MxA94u4YJQfWXwuGJxxvWIHfxxYTkXdx5i22W2wTdU+FnoHUqFMaqC/A722
Ua+PH0UaeEGRuElQzYQgEAqC/sACWMS2qJl9oNl7cubuk28eDkfS99Ly4gCrXCEV
ZNEERtza2bKny2Y5vrEOwWiVXv6/6JaHViMih/x1pCXftffmKc8nRy2zxPk6avDS
gfmLDnp4viWXcwO7NRrK/P6z+wyqm5qeBmBxcIjAFMGhNAtvYiNTABTTFT59g9sX
ed8ZToJEZnSrfyUXjCZaaRbVmdPFylUh8s/E4KnRAhhfOUVehvnSIlCelcU6taGq
PopS/zm7DPQEI8gNtDHwn4yvUYd8wGJRqVOVi3uR1gj3c9ErQUqjuId8JrBVmk/r
5yTZAcXGNYAbNrafz4M39uDj0HnN6m0aF1/RAn/y7x/rA7qTg5VBjMLt0gj4E74l
EhMLuasGOfnzTHJrIRWTHofjAFYkcmXRthH3iYV9HiJS5iw+VMNLc7+YVeR9zN05
KCHUbPBqytq+HenRHN/qtbawuTmGhCRZE04oTAH5r4DqGburBL/RzHZ9oDj7Z2If
fYMwiuSUaEaySJUM9O0R9K+E+S59hW5TK2X4DViMIapns6R1c0hsuwki+419if1u
CDIAHff7Ak3fgeex+fnA
=oqBd
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
