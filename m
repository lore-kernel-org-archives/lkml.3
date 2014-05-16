Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbaEPRp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:45:26 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35234 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaEPRpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:45:24 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Gioh Kim <gioh.kim@lge.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Minchan Kim <minchan.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Laura Abbott <lauraa@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>, gurugio@gmail.com
Subject: Re: [RFC][PATCH] CMA: drivers/base/Kconfig: restrict CMA size to non-zero value
In-Reply-To: <5375C619.8010501@lge.com>
Organization: http://mina86.com/
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com> <1399509144-8898-3-git-send-email-iamjoonsoo.kim@lge.com> <20140513030057.GC32092@bbox> <20140515015301.GA10116@js1304-P5Q-DELUXE> <5375C619.8010501@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140516:gunho.lee@lge.com::Ue4lLo8igHVb8nRV:0000000000000000000000000000000000000000000004RN
X-Hashcash: 1:20:140516:mgorman@suse.de::Y44lujPGIM0JmPnH:000Bjk
X-Hashcash: 1:20:140516:minchan.kim@lge.com::sjMe8lbJUCBJaHPf:0000000000000000000000000000000000000000001Q7T
X-Hashcash: 1:20:140516:iamjoonsoo.kim@lge.com::sGmK1jXThI8QbUfE:0000000000000000000000000000000000000001JgU
X-Hashcash: 1:20:140516:gurugio@gmail.com::0PZnxRTmJPUMrBUR:000000000000000000000000000000000000000000002036
X-Hashcash: 1:20:140516:heesub.shin@samsung.com::qGmHIbRzo0P/Oqh1:000000000000000000000000000000000000001y/V
X-Hashcash: 1:20:140516:m.szyprowski@samsung.com::cBDBo5qWerjEa/GC:00000000000000000000000000000000000002vfv
X-Hashcash: 1:20:140516:linux-mm@kvack.org::ljUJEw7y1VSARITh:00000000000000000000000000000000000000000003ILx
X-Hashcash: 1:20:140516:gioh.kim@lge.com::Ii/ezs31gS2GtoH4:06a9M
X-Hashcash: 1:20:140516:hannes@cmpxchg.org::8rA0phc+VyEqPN8c:00000000000000000000000000000000000000000007aMt
X-Hashcash: 1:20:140516:linux-kernel@vger.kernel.org::Jb5P0U8PLV0+qZnC:0000000000000000000000000000000008WAv
X-Hashcash: 1:20:140516:lauraa@codeaurora.org::uOqMWgD9HmNScwhR:0000000000000000000000000000000000000000Gi62
X-Hashcash: 1:20:140516:riel@redhat.com::WH1J3hmqR6TOTnU9:00HiX8
X-Hashcash: 1:20:140516:akpm@linux-foundation.org::trlLagc63vdq1hfI:000000000000000000000000000000000000LXPR
Date: Fri, 16 May 2014 10:45:12 -0700
Message-ID: <xa1tppjdfwif.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, May 16 2014, Gioh Kim wrote:
> If CMA_SIZE_MBYTES is allowed to be zero, there should be defense code
> to check CMA is initlaized correctly. And atomic_pool initialization
> should be done by __alloc_remap_buffer instead of
> __alloc_from_contiguous if __alloc_from_contiguous is failed.

Agreed, and this is the correct fix.

> IMPO, it is more simple and powerful to restrict CMA_SIZE_MBYTES_MAX
> configuration to be larger than zero.

No, because it makes it impossible to have CMA disabled by default and
only enabled if command line argument is given.

Furthermore, your patch does *not* guarantee CMA region to always be
allocated.  If CMA_SIZE_SEL_PERCENTAGE is selected for instance.  Or if
user explicitly passes 0 on command line.

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

iQIcBAEBAgAGBQJTdk6oAAoJECBgQBJQdR/0/uAP/iy4hKtOCEcIenjryq8Y8a6e
A8qqXcLu0Ms9x0Pj6ooWAZiEwgyXMZaTv7ykH3JRGW6JDD4oHLwkCO5ZHXrhT1mf
pPWIhdVJNJsFL8YBEoIWzRzdMFyXsPhezn79dCR4mX/mIMGiZtKEbNc8uTSNJozS
yF0ZPGeevPWBgb5bJVh0ijDm26zyXIXk/aRxHCX5C9XgIS7aZhbKMmG2J2X97NU/
eyuQCPhzzfXKzcDzpZUYm2HhZDaJ/CQKOGQDwTDPVsuktOPeKu5T94+j5cFK9rKW
NG/uTXDWA2B9DsC/OIcmSf/IFFHojWr2i7zaMPK4kXN6Hd+MAr9WNm+aslo8df+J
F8Y2y9Gbu2ZQjBbB2R3Ecz4AJUDZgquOwSG54N+6QZuY+aMKoL3sc7kI+q12mZKS
m2DjnEp6uUPsYo2RUaOotqjHBjiKlfLN6tBpxsP0BFRYyf/KCs7FGG/NS9g5xcU+
fI0h4AXIiA8g+bP1lmcv7BRFefKRZsQLYRuNoFFvzAqz0wmQ5tHpZylE6sEbpHzm
d2dDlVizFPF9QEnLLMFGfOYUZrLLan3jmlCy5+dMKxKF2AdOKFYIrpexb5Io+jRp
kabi/5LDR8ISiULgiQ9NDZyGTCXTmsvkvGQTuYyJhS+bBrQtrlVVL8w5Qx6/WSU1
l9Se161WbizexGWJds28
=oIPD
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
