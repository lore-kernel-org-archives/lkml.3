Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaETB2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 21:28:41 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38924 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaETB2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 21:28:36 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Gioh Kim <gioh.kim@lge.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Laura Abbott <lauraa@codeaurora.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Heesub Shin <heesub.shin@samsung.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>, gurugio@gmail.com
Subject: Re: [RFC][PATCH] CMA: drivers/base/Kconfig: restrict CMA size to non-zero value
In-Reply-To: <537AA6C7.1040506@lge.com>
Organization: http://mina86.com/
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com> <1399509144-8898-3-git-send-email-iamjoonsoo.kim@lge.com> <20140513030057.GC32092@bbox> <20140515015301.GA10116@js1304-P5Q-DELUXE> <5375C619.8010501@lge.com> <xa1tppjdfwif.fsf@mina86.com> <537962A0.4090600@lge.com> <20140519055527.GA24099@js1304-P5Q-DELUXE> <xa1td2f91qw5.fsf@mina86.com> <537AA6C7.1040506@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140520:linux-kernel@vger.kernel.org::LNYn2ifyKnC6ih4Q:0000000000000000000000000000000000K95
X-Hashcash: 1:20:140520:hannes@cmpxchg.org::zSlkX6rdKHGUHC9m:00000000000000000000000000000000000000000000svQ
X-Hashcash: 1:20:140520:m.szyprowski@samsung.com::DpehBMNXwc9B60OL:00000000000000000000000000000000000000mQo
X-Hashcash: 1:20:140520:riel@redhat.com::fs814/VlHp44vhAw:002Ckt
X-Hashcash: 1:20:140520:akpm@linux-foundation.org::MvC5UR8kFGVsFLGR:0000000000000000000000000000000000001oxM
X-Hashcash: 1:20:140520:gunho.lee@lge.com::D9S+OgZ0Wlc0uuhG:0000000000000000000000000000000000000000000029Tq
X-Hashcash: 1:20:140520:minchan.kim@lge.com::eSnn7Oob1UPNDCVp:0000000000000000000000000000000000000000001pLG
X-Hashcash: 1:20:140520:mgorman@suse.de::EgqAtF1Pc0l9gSw7:002dMh
X-Hashcash: 1:20:140520:lauraa@codeaurora.org::fBlpjiFU803kVBRa:00000000000000000000000000000000000000003Tu2
X-Hashcash: 1:20:140520:heesub.shin@samsung.com::GrNmbZd/2TnlTIOg:000000000000000000000000000000000000003zxx
X-Hashcash: 1:20:140520:linux-mm@kvack.org::Z4LMu6ifj6PbkpMe:000000000000000000000000000000000000000000039Gf
X-Hashcash: 1:20:140520:gurugio@gmail.com::D1avq/YQjL6E+fSk:000000000000000000000000000000000000000000003IJZ
X-Hashcash: 1:20:140520:gioh.kim@lge.com::+336yPKE9VnxSnB+:09OyY
X-Hashcash: 1:20:140520:iamjoonsoo.kim@lge.com::8j1E+bLyr/9tOZ27:000000000000000000000000000000000000000H/1L
Date: Mon, 19 May 2014 15:28:24 -1000
Message-ID: <xa1tzjiddyrr.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, May 19 2014, Gioh Kim wrote:
> If CMA option is not selected, __alloc_from_contiguous would not be
> called.  We don't need to the fallback allocation.
>
> And if CMA option is selected and initialized correctly,
> the cma allocation can fail in case of no-CMA-memory situation.
> I thinks in that case we don't need to the fallback allocation also,
> because it is normal case.
>
> Therefore I think the restriction of CMA size option and make CMA work
> can cover every cases.

Wait, you just wrote that if CMA is not initialised correctly, it's fine
for atomic pool initialisation to fail, but if CMA size is initialised
correctly but too small, this is somehow worse situation?  I'm a bit
confused to be honest.

IMO, cma=3D0 command line argument should be supported, as should having
the default CMA size zero.  If CMA size is set to zero, kernel should
behave as if CMA was not enabled at compile time.

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

iQIcBAEBAgAGBQJTeq+5AAoJECBgQBJQdR/0Ns4P/2+MSDCVhcRh8a2OpEG35FsZ
MY48W6w7LnXneI+SS2/Bx3hHbK4PDuF6DViY/thZ0VYEZ3rg0iaD4v8545LRWE5Z
0GUnjPy9/iPX1jJMnhHJChfYD0D3/l6j+io9TcaBDnsTm+i4zY4Y7R2DyPYZIYDA
RRp1JxkCdcVJ3zF6EqM/9hWPZbrrB6WYB46Ig9lG3IBGUsVdNR3TmAhdwx49IAp3
BPWGJIEKji0HHC0mnvgEzf822bwZc2w1DqpzarJhUYEuxvOyqw3E29mCjNwS9ME4
8aIqWlPka1rqTPylLrspz+P0rFfovag4SHVVLUSqOLvvSgUAqDh/20L9j7+qinmB
PyhQLlH5s38n7cfVPn/DKSB1u8Stpjgen/aydHqDHIiHg/Ng6h9Eb3IZoNMkMAIA
jmpAm3zShgkZJNhkCxwHkWn+mUqo3E3o8cmxE6/b2L0VdO06KIzXZ6jsR4Biy/1s
HI/FocpbzbjHbN+PqpJwgmWOn6ih5+CXPXYaVT20hban5v4jPffor5LbhSStWAeE
K7lYCtuLr6APwB/8/TOwzoKNdLicynZd2s0xLw407RTBtr/MF6sGH2p2rcRnKctB
dOsFd7P1jEzPbRM9AtDlNpYBaImiRNNs2nubEEFC+11ciZrs18PEZ7K/ICJQGO/p
0FSiK86mX2eIZFAgZRj/
=Th+9
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
