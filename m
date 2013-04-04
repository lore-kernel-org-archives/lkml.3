Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607Ab3DDAPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:15:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10189 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3DDAPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:15:46 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-3d-515cc630f961
Message-id: <1365034495.4353.14.camel@kjgkr>
Subject: Re: [PATCH] To add NULL pointer check
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: P J P <ppandit@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Petr Matousek <pmatouse@redhat.com>
Date: Thu, 04 Apr 2013 09:14:55 +0900
In-reply-to: <alpine.LFD.2.03.1304031342550.23577@erqung.pbz>
References: <alpine.LFD.2.03.1304021808410.12716@erqung.pbz>
 <1364958193.4353.4.camel@kjgkr>
 <alpine.LFD.2.03.1304031224180.21402@erqung.pbz>
 <1364975688.4353.7.camel@kjgkr>
 <alpine.LFD.2.03.1304031342550.23577@erqung.pbz>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-FuWwjiBCe5AaaWJ/qsNi"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t8zI12DYzGBBjfblC327D3JYnF51xw2
	i6tXvjNbTDn5g82BxeP9vqtsHp83yQUwRXHZpKTmZJalFunbJXBlzJ94jKmgX7pi/fx+9gbG
	Q2JdjJwcEgImEge/tLNA2GISF+6tZ+ti5OIQEljGKPH3/jxGmKLTWz6zQCQWMUrM2vkQquo1
	o8T6tQfYQap4BXQkHsy/CmYLC+hJvFm+E8jm4GAT0JbYvN8AJCwkoCjxdv9dVhBbREBO4urW
	3WCbmQXSJPa03gezWQRUJa5/esEEYnMK2Eps27CdHWLXM0aJFT+/ghXxC4hKnGz9xAjRXCXR
	0/6KDeJSJYnd7Z1Q9whK/Jh8D+xqCYGP7BJta7ayQmwQkPg2+RALyHESArISmw4wQ/RKShxc
	cYNlAqP4LCRjZyEZBRHXlGjd/psdwtaWWLbwNTOEbSuxbt17qBobiU1XFzBC2PIS29/OYV7A
	yL6KUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIyRq+3cw3j1gfYixCujEicxSosn5wKjPK4k3
	NDYzsjA1MTU2Mrc0o4qwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGSU0Tz9dU
	9V89Gh1nuOiQnIbaxJxL7TYnRc4lrPnI2+9cGv6qsIW5UaVVW+f3il+bTRLyt7P+sw5t1tjc
	YZ8T8dy/5/wxtplb2Ne1S9+OaL2zZyXnwq8Ormc09F88le8TqbLuUd77oIvlTelLkzU3+EuL
	ttdmCVinWTxQn13bZ/i89aj/xSYlluKMREMt5qLiRAB39rAIBwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsVy+t9jAV2DYzGBBnPb5Sz27D3JYnF51xw2
	i6tXvjNbTDn5g82BxeP9vqtsHp83yQUwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZsyfeIypoF+6Yv38fvYGxkNiXYycHBICJhKnt3xmgbDFJC7cW8/WxcjFISSwiFFi
	1s6HUM5rRon1aw+wg1TxCuhIPJh/FcwWFtCTeLN8J5DNwcEmoC2xeb8BSFhIQFHi7f67rCC2
	iICcxNWtu8EWMAukSexpvQ9mswioSlz/9IIJxOYUsJXYtmE7O8SuZ4wSK35+BSviFxCVONn6
	iRGiuUqip/0VG8SlShK72zuh7hGU+DH5HssERsFZSMpmIUlBxDUlWrf/ZoewtSWWLXzNDGHb
	Sqxb9x6qxkZi09UFjBC2vMT2t3OYFzCyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQITgnP
	pHYwrmywOMQowMGoxMO70j8mUIg1say4MvcQowrQnEcbVl9glGLJy89LVRLh3bASKM2bklhZ
	lVqUH19UmpNafIhxIiMwPCYyS4km5wMTWV5JvKGxiZmRpZGZhZGJuTkthZXEeQ+0WgcKCaQn
	lqRmp6YWpBbBHMXEwSnVwFhnLtR13J9T+II0s8q1nouveb/wnXp/fpJh1A23WxsXhrYVR2av
	zuzwnaGnXHXlRWMMO2vyi91/eOb+z77PGG25bH1RypcqTwGFhO2/7LL9+W1FHq38oWAhd3Wm
	qeLDDRyctSXrjje0VjorXBPKUr+revv23GZ7Z44n8x5OXvmZTevsgdbphkosxRmJhlrMRcWJ
	AOXLpnuIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FuWwjiBCe5AaaWJ/qsNi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-04-03 (=EC=88=98), 14:43 +0530, P J P:
> +-- On Wed, 3 Apr 2013, Jaegeuk Kim wrote --+
> | I'm confusing the question because f2fs doesn't use generic_writepages(=
),=20
> | since f2fs_write_data_pages() is linked to a_ops->writepages. In=20
> | do_writepages(), always f2fs_write_data_pages() is triggered instead of=
=20
> | generic_writepages(). Isn't it?
>=20
> Before commit fa9150a84c, when `generic_writepages' returned 0, it did no=
t=20
> abort `f2fs_write_data_pages', as the proposed patch does. I was wonderin=
g if=20
> that's intentional OR if the patch below does it right?
>=20
> =3D=3D=3D
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 7bd22a2..7be750e 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -561,7 +561,7 @@ static int f2fs_write_data_pages(struct address_space=
=20
> *mapping,
>  {
>         struct inode *inode =3D mapping->host;
>         struct f2fs_sb_info *sbi =3D F2FS_SB(inode->i_sb);
> -       int ret;
> +       int ret =3D 0;
>         long excess_nrtw =3D 0, desired_nrtw;
> =20
>         if (wbc->nr_to_write < MAX_DESIRED_PAGES_WP) {
> @@ -572,7 +572,9 @@ static int f2fs_write_data_pages(struct address_space=
 *mapping,
> =20
>         if (!S_ISDIR(inode->i_mode))
>                 mutex_lock(&sbi->writepages);
> -       ret =3D write_cache_pages(mapping, wbc, __f2fs_writepage, mapping=
);
> +       /* deal with chardevs and other special file */
> +       if (mapping->a_ops->writepage)
> +               ret =3D write_cache_pages(mapping, wbc, __f2fs_writepage,=
 mapping);

Why should we take unnecessary locks and an f2fs_submit_bio call?
Thanks,

>         if (!S_ISDIR(inode->i_mode))
>                 mutex_unlock(&sbi->writepages);
>         f2fs_submit_bio(sbi, DATA, (wbc->sync_mode =3D=3D WB_SYNC_ALL));
> =3D=3D=3D
>=20
> Thank you.
> --
> Prasad J Pandit / Red Hat Security Response Team
> DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Jaegeuk Kim
Samsung

--=-FuWwjiBCe5AaaWJ/qsNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRXMX/AAoJEEAUqH6CSFDSlCAP/jHaAzlUX3CnJQ81ZkNoDEW5
6X/R9xu6z/cPBeqqXZJmHit1kHuajS2nAmBYnuYIvNpcjgAumz0VzTff1nN/Oy2D
2tmS00E/rPo+I56wg2Eb9owXc39u1pYJDckFVPLIVRmT9j/3E2qHcGzealb65tyH
ty05Y6I62U8rofKHDLJKMbrNnsV7fyzzgnKF2C16rI0cQVi85Ywlr0UfXepZXLwO
Zj8h/dtL8jA2bzR6JUymQ8KdSw1e7RBLCNEexq3EApYAlSn0sfbFqyhgwiU2uxHo
Iiwi1m0iLoa3cIKEOkeLSwTQjq6KWMwYPKfvMgn7EMTcKVyjCdoXNtC8YXnK9SKq
dZZfFd3Bf8cC0bw1b7MedTuZeE91ze/RCgu63BpO9+tMDH5flzITu/4NF2zkJXQr
ARvksnTViHxOjVjXS86jdA/PvVa8LOxggXP1sFS6HtIIBUGOBMnim8+L0GrXCOI8
gdgBU4AJBp+wp4Y5IjICuGEGFGan5oYnafjqYDMv7NEbR7B/mGnrumgIEI9KCstt
i+ycY3PpyMurt0RIpNEerVJgh8qsPfd6FInus9V0XmSm5T8gDEhJsaBjH/P2ygC+
lycmOjGDA+Q46LqLXCKbNxxQtKq4mcxvN031PBDOIGHBlNls/Ej3do3Q74pHjdPB
NQuoyxicEv2yhLwF3Z1Y
=HLLI
-----END PGP SIGNATURE-----

--=-FuWwjiBCe5AaaWJ/qsNi--

