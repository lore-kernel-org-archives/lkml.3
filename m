Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaETSPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:15:31 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36994 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaETSP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:15:29 -0400
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
In-Reply-To: <537ABD6F.9090608@lge.com>
Organization: http://mina86.com/
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com> <1399509144-8898-3-git-send-email-iamjoonsoo.kim@lge.com> <20140513030057.GC32092@bbox> <20140515015301.GA10116@js1304-P5Q-DELUXE> <5375C619.8010501@lge.com> <xa1tppjdfwif.fsf@mina86.com> <537962A0.4090600@lge.com> <20140519055527.GA24099@js1304-P5Q-DELUXE> <xa1td2f91qw5.fsf@mina86.com> <537AA6C7.1040506@lge.com> <xa1tzjiddyrr.fsf@mina86.com> <537ABD6F.9090608@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140520:gurugio@gmail.com::V4lMVJrkv5F6fU1H:00000000000000000000000000000000000000000000026Z
X-Hashcash: 1:20:140520:linux-kernel@vger.kernel.org::4D7HRPpHeuGMVN2P:00000000000000000000000000000000000L5
X-Hashcash: 1:20:140520:akpm@linux-foundation.org::Y4QFOEHOHMR36ajs:00000000000000000000000000000000000003b7
X-Hashcash: 1:20:140520:mgorman@suse.de::ZGV4WBpPmOcqrFpf:000Z+V
X-Hashcash: 1:20:140520:heesub.shin@samsung.com::pLr1KFDoWc9UsbEL:000000000000000000000000000000000000000JD6
X-Hashcash: 1:20:140520:linux-mm@kvack.org::7w8j1v5sfnrfpFjS:000000000000000000000000000000000000000000026m0
X-Hashcash: 1:20:140520:lauraa@codeaurora.org::IN9W6H5mamEBPyIX:000000000000000000000000000000000000000024XJ
X-Hashcash: 1:20:140520:minchan.kim@lge.com::C65wTAL03KRed5I2:0000000000000000000000000000000000000000003ouA
X-Hashcash: 1:20:140520:riel@redhat.com::9loRvNMnvQdapPEv:005/8g
X-Hashcash: 1:20:140520:m.szyprowski@samsung.com::8yJb+74zaJSg/7zZ:00000000000000000000000000000000000006qb9
X-Hashcash: 1:20:140520:gunho.lee@lge.com::5QZIBayzTpsiCRsT:000000000000000000000000000000000000000000005ynW
X-Hashcash: 1:20:140520:hannes@cmpxchg.org::QBRnOe1JxuSD4c1t:0000000000000000000000000000000000000000000BGD/
X-Hashcash: 1:20:140520:iamjoonsoo.kim@lge.com::8wfth9g3NLJBmOmi:000000000000000000000000000000000000000DOVt
X-Hashcash: 1:20:140520:gioh.kim@lge.com::rS1rs2a6ZA7WSXZn:0IlCR
Date: Tue, 20 May 2014 08:15:18 -1000
Message-ID: <xa1t4n0k1fm1.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, May 19 2014, Gioh Kim wrote:
> My point is atomic_pool should be able to work with/without CMA.

Agreed.

>> IMO, cma=3D0 command line argument should be supported, as should having
>> the default CMA size zero.  If CMA size is set to zero, kernel should
>> behave as if CMA was not enabled at compile time.

> It's also good if atomic_pool can work well with zero CMA size.

Exactly.

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

iQIcBAEBAgAGBQJTe5u2AAoJECBgQBJQdR/06jEP/iYmW8mK7Wuu6CYGXh/lzz5t
UFw2wQHHnAzZqAxYVKbgUK+XNFAvZ52jWztebNP7XGFqd8Ryn2btWY1/yJEVm63V
OsIlZ/oiam4J0y6vSUS0gA3MzazQ1dvAIs96MEkKBqrcWE8WQlVxIkbr/EAT1vIH
Zn2Jckhupp4LxRtwtYXXX3P1MikYzIzmsAC2uv4IU4N4btw8e+zSRB06G8PhFZmw
YtkHrI9KVYlK5GkoThILXMYjOmO7dErrGXJc6CSSew/TUgsoHnBme96hG+Ahp5Zq
nakbo2m1On7pCZzwv+OcHKdim6QZWUzDqk1OBruubuCY60u8778FLfVwMIMBCE9w
gFda98xgDUCc40e3UmsZR9kbOiZa8IxRvOdPH3WghS2Vz1BI4IGphH9aBBd6kXbY
osUizgtYA646bpuYsq2++YnxgYiIHvE7sjsdu+GyD7JkbSXBYglejXshuO8QKx4D
eE1Y5Ak643kb//UqZgRCe4VcihYzuHnYjT7rcdfFRzT30+2cMoKhPJULJhIP956I
BOBaM/WQiizDc6vSbpDWjoeC8MoZia2ARqF1vhYFcib1rNaQGpK/MI+tOhx4b0Rc
TqljUnVDUg105PcnSaezDSGN3p4yli8F3BYgECuBr/oHrRObjOL/zFPCKV9XXC5z
HcKJdseWFVuWOU0La7xz
=WbUu
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
