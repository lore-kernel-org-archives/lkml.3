Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab3DZTWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:22:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64270 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab3DZTWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:22:18 -0400
Date: Fri, 26 Apr 2013 21:22:08 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Emil Goode <emilgoode@gmail.com>
Cc: airlied@linux.ie, swarren@wwwdotorg.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drm/tegra: Include header drm/drm.h
Message-ID: <20130426192208.GA2945@avionic-0098.mockup.avionic-design.de>
References: <1366998591-8508-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <1366998591-8508-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:kGxCjNgJ7XMmo/9EickQFr91wV5abxbzW3BhmvwZcuo
 slk60b27JE2+nIt1viIIwo39YppXpPQcvLAIRO1Zp8LmnIBWkx
 9gXB6/vJollpDAWSMXCwWVIR346UqFTNM/EWY60qmzl8l18/5P
 /oEkp1KRnUYE+L8BxaHySfJPGdK/YTSMP4BHltXq1UihXjC6OR
 AjRnrdtmWAYKbF8O1SJeP7aieSurn28X3Sfw8OcF1F2gJ6C+Bu
 o2clHBeRG7VAkhkSnV9gmRyAvuNgvGabNyMOzgoCWpkg+kf3yF
 kQLMN51U+PQHwq7FJpAWBFlbDKspsAldK9t4nnsfI6hIJBnMVb
 oaUyNe8oY8E6r6FlOaHQsZV2xZuSvGalzDYj6v0UIOdAETeizL
 /kIk17v9MVlEcVRLtzz5alQo6uK2VQCv5E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 26, 2013 at 07:49:51PM +0200, Emil Goode wrote:
> Include definitions of used types by including drm/drm.h
>=20
> Sparse output:
> /usr/include/drm/tegra_drm.h:21:
> 	found __[us]{8,16,32,64} type without
> 	#include <linux/types.h>
>=20
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>  include/uapi/drm/tegra_drm.h |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
> index 6e132a2..73bde4e 100644
> --- a/include/uapi/drm/tegra_drm.h
> +++ b/include/uapi/drm/tegra_drm.h
> @@ -17,6 +17,8 @@
>  #ifndef _UAPI_TEGRA_DRM_H_
>  #define _UAPI_TEGRA_DRM_H_
> =20
> +#include <drm/drm.h>
> +

sparse complains about linux/types.h not being included, so I wonder if
it makes more sense to include that instead of drm/drm.h. In fact I have
a fix that does exactly that in a local branch and was going to put that
into my fixes branch. It's a bit more lightweight.

On the other hand, some drivers already include drm/drm.h in the public
header so I don't really have any objections to this patch.

Thierry

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRetPgAAoJEN0jrNd/PrOhi2UP/3TYlmERo6RDg/RM/HY5v7dD
JSIsF/RSDWij76GdpLvDTbM7GDXx1WDr7otSg7d8Vup5UsM33+QV+U0taCGS0TcA
HHxof9gcpEW4lPIXfMxXFc/4Ldn1K8KVcJClxmAdUtybPu3nIaXgR6rEp/pOz470
N/33JmN4ZY5OA4IyTPnP4Y41cAC9trpb7gN67/DZdlSN1Ctvrd1tTcoN1MDuk6b1
SFQpLq4l6JxbU0BFPwlY6Y6QSC/xIf4bJ8cYYKVhg0zb9BWufT3bKvxvjXmYh8rB
q3xa8X0UyQ7IgBYb7cU/4TcXTGF/eDEMhfKHBfk716YiZHjhEUomXijAPAqLGG3A
+HGqUpHOWtWCoy9PDk5XrkIWtW8ec/9U6OmkllEHbOwVkGAI8HN1XrZgYn42RZvz
mKB+vN9nO7yMf9aHPzXRuURym/ZMQDWwfUDVVfwxBBBkMBtN5yDyZ6sTL3CYXVFv
xtOhbuResdAn7JDzoqvtz0nho+Py1wdJZA2JamPk12B37JPsOts+mJy6gP6VfGWy
GWE3gNHOqh9Rgaj8fngmkZPsgeOlTLlwadHAGxyZAwKE3gKSUTCAS92cYIb94zUp
bwiYBwQuURhTR6mXA+lfuwpoURw+/FL4UN68jBN/vdpWfoVzWdCQCW27pCfkyAkt
PokQkVFfBUzBI3eGBx3L
=S/VX
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
