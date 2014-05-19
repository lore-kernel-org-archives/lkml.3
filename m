Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbaEST7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:59:34 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33681 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaEST7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:59:31 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Gioh Kim <gioh.kim@lge.com>
Cc: Minchan Kim <minchan.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Laura Abbott <lauraa@codeaurora.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Heesub Shin <heesub.shin@samsung.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>, gurugio@gmail.com
Subject: Re: [RFC][PATCH] CMA: drivers/base/Kconfig: restrict CMA size to non-zero value
In-Reply-To: <20140519055527.GA24099@js1304-P5Q-DELUXE>
Organization: http://mina86.com/
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com> <1399509144-8898-3-git-send-email-iamjoonsoo.kim@lge.com> <20140513030057.GC32092@bbox> <20140515015301.GA10116@js1304-P5Q-DELUXE> <5375C619.8010501@lge.com> <xa1tppjdfwif.fsf@mina86.com> <537962A0.4090600@lge.com> <20140519055527.GA24099@js1304-P5Q-DELUXE>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140519:gunho.lee@lge.com::zVqkkDVUDxxFVjW6:0000000000000000000000000000000000000000000003UB
X-Hashcash: 1:20:140519:gioh.kim@lge.com::5pM6QNLNsVjJAWxg:00AJF
X-Hashcash: 1:20:140519:mgorman@suse.de::CgWzJlWj69VMF9Bf:001BDw
X-Hashcash: 1:20:140519:minchan.kim@lge.com::J6jiUN7nf0itFp59:0000000000000000000000000000000000000000000vS/
X-Hashcash: 1:20:140519:hannes@cmpxchg.org::nxmg2kKMHDb0Jzp0:00000000000000000000000000000000000000000001J44
X-Hashcash: 1:20:140519:akpm@linux-foundation.org::wSYpvSlHsyfz7UVC:0000000000000000000000000000000000001aKQ
X-Hashcash: 1:20:140519:iamjoonsoo.kim@lge.com::8wOEE2z+6J0mzLKY:0000000000000000000000000000000000000002UEi
X-Hashcash: 1:20:140519:gurugio@gmail.com::cB12NXFzo3XYJ7s4:000000000000000000000000000000000000000000002vrQ
X-Hashcash: 1:20:140519:lauraa@codeaurora.org::3Cq48wpUQL1glmYC:00000000000000000000000000000000000000003Ouf
X-Hashcash: 1:20:140519:linux-mm@kvack.org::QBrc9vg7mD6oYOYz:00000000000000000000000000000000000000000003JF3
X-Hashcash: 1:20:140519:heesub.shin@samsung.com::Ea1X3VV7n0Ulq1WV:000000000000000000000000000000000000004LxD
X-Hashcash: 1:20:140519:riel@redhat.com::RLjWwFL5mCLCDxNG:004gtu
X-Hashcash: 1:20:140519:m.szyprowski@samsung.com::CCPKH8biEozOZwK4:000000000000000000000000000000000000055Rz
X-Hashcash: 1:20:140519:linux-kernel@vger.kernel.org::3VCiEJMAyLPxgivv:0000000000000000000000000000000004Itv
Date: Mon, 19 May 2014 09:59:22 -1000
Message-ID: <xa1td2f91qw5.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, May 18 2014, Joonsoo Kim wrote:
> I think that this problem is originated from atomic_pool_init().
> If configured coherent_pool size is larger than default cma size,
> it can be failed even if this patch is applied.
>
> How about below patch?
> It uses fallback allocation if CMA is failed.

Yes, I thought about it, but __dma_alloc uses similar code:

	else if (!IS_ENABLED(CONFIG_DMA_CMA))
		addr =3D __alloc_remap_buffer(dev, size, gfp, prot, &page, caller);
	else
		addr =3D __alloc_from_contiguous(dev, size, prot, &page, caller);

so it probably needs to be changed as well.

> -----------------8<---------------------
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 6b00be1..2909ab9 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -379,7 +379,7 @@ static int __init atomic_pool_init(void)
>         unsigned long *bitmap;
>         struct page *page;
>         struct page **pages;
> -       void *ptr;
> +       void *ptr =3D NULL;
>         int bitmap_size =3D BITS_TO_LONGS(nr_pages) * sizeof(long);
>=20=20
>         bitmap =3D kzalloc(bitmap_size, GFP_KERNEL);
> @@ -393,7 +393,7 @@ static int __init atomic_pool_init(void)
>         if (IS_ENABLED(CONFIG_DMA_CMA))
>                 ptr =3D __alloc_from_contiguous(NULL, pool->size, prot, &=
page,
>                                               atomic_pool_init);
> -       else
> +       if (!ptr)
>                 ptr =3D __alloc_remap_buffer(NULL, pool->size, gfp, prot,=
 &page,
>                                            atomic_pool_init);
>         if (ptr) {
>

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTemKaAAoJECBgQBJQdR/0o2UP/2G4b+KPDsHmMb6HsfXWyaPP
cm0tokTR/UKmMO68Pb6Wgsokt34/aS6KCHrVHqni7lxtuR0Zb28gdQaLcya2Lb0S
lhlaoEQcElAUfxTVLAUChlb4L6TZcf7dUOPN317rqepvOp7K98FNENqWhyK5hkSC
5H+SYCB+7rn3+4ApQ/xFL7XCoA7C85qsxnZEa35R/FMVI2zv70xcLIakiV/4XZ3W
eXBsHEj7X1ZRnIBAARA2VBzMaMMAhAUYzSRwTSP+gBqJ53M4bae7FX7Kml81U4ra
V3VtWt78hZ+fY3hljuIPFmICV6vRsbv7Opg2TQHbU5ekKf8Mr8Y+D8Xo/U6hugv+
SjdcC8+Edsa0m4bO6Blhz4GM5eHoX7cOxmyDxIPuGAPRZeiDdmTvduSzfvd6oDZ+
9QvSLi41co0SdSrOuSpc3gtqmIOkFZ3vhgycmZAXmbdI96rq29VB/deqFGaUorgw
X24ENPlMxH2Z/84KV3EAQM+pR2MHZIesxB/7hRbaHVRKCD/wZ1MrtCbg4RAPceSA
1Lyyzsr68yAlcteyA+HxLQAeGh2fwfJ8Bz6iIJR1pBFdeBUj+T6l+cgz8N1YM5HE
dnijLmb6u70SvMAAvhRd0EITICXTHhb2xlhXfiT+jwJfw6+iiYNK3jTP7HNNA7BW
UiWN72LDf6SF0tvtqSm/
=uOv/
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
