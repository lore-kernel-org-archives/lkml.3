Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaLROFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:05:50 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40022 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaLROFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:05:48 -0500
Message-ID: <5492DF0D.3080607@ti.com>
Date: Thu, 18 Dec 2014 16:05:01 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>
CC: Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?B?S3J6eXN6dG9mIEtvesWCbw==?= =?UTF-8?B?d3NraQ==?= 
	<k.kozlowski@samsung.com>,
        <inki.dae@samsung.com>, <linux-fbdev@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <dh09.lee@samsung.com>,
        <linux-kernel@vger.kernel.org>, <kyungmin.park@samsung.com>,
        <kgene@kernel.org>, <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Weird/Unneeded call to msleep in exynos_mipi_dsi_wr_data in exynos_mipi_dsi_common.c
References: <54920A54.2060608@gmail.com> <5492ABE7.1060900@samsung.com>	 <5492D80E.3010906@gmail.com> <1418909978.2236.0.camel@pengutronix.de> <5492DB1A.2020704@gmail.com>
In-Reply-To: <5492DB1A.2020704@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="VJdv1a0WcfBdG5ccDTovVrxNXvv0tl9jm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VJdv1a0WcfBdG5ccDTovVrxNXvv0tl9jm
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 18/12/14 15:48, nick wrote:
> Lucas,
> That's fair do you known of anyone who does have the hardware so we can=
 test my patch. If you do then we can get this fixed rather
> easily.
> Cheers Nick=20
>=20
> On 2014-12-18 08:39 AM, Lucas Stach wrote:
>> Am Donnerstag, den 18.12.2014, 08:35 -0500 schrieb nick:
>>> Krzysztof,
>>> If we look at the code for this function, it already is handling the =
data correctly. In addition  the locks=20
>>> seem to be better protection then msleep. Further more is no reason f=
or this delay as we are neither resetting=20
>>> the hardware or waiting for the hardware here so why is it needed? I =
don't have Exynos based hardware lying
>>> around through to test it.
>>
>> If you can't test it, don't touch it. It's that simple.

There seems to be multiple msleep(20)s in exynos_mipi_dsi_common.c, a
few with /* FIXME */ and a few without any comments. Looks like bad (but
relatively harmless) code to me, but as Lucas said, if you can't test
it, don't touch it.

 Tomi



--VJdv1a0WcfBdG5ccDTovVrxNXvv0tl9jm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUkt8NAAoJEPo9qoy8lh71p8MP/1fXGGsVE1n0j+uRmqziiHyw
FD/g3tEGQ/tdtg+rWbEbpX20rAcLbo3ieFV17rFHrjrcOMvRMPaEjHnIqpM5MCBM
8cs33yx7Ljc+0ge6v567Q4xWIzBlsP3k5W/ebRivRn9NoMLc3A8p4ssh6KAW9GNK
l7Jg1WL4igSgXA4cMAauuUu5jDGCtAywcrG/RHR2tNP1hnkixdfiAHzSodb6xHjI
TXYPHZhCNc8hJevLV9Ux0vv9J18eBj2X15ghB7KWsR6ujYf4gjIn/UNAGxgANoVH
eslWIbZeJB8oA9bOGT9zdG2vF8Hsu/a2IHtNYalxygt5tXPvuTzewmMBxBlQSQ0b
CC80SJH76TePtH/9csf417rusivI96D5kion24JZjGXwvsgkx1rKeThQEEa/tIxe
t0oC1OtnxlpCDpxAHoZoZ6FNAoMZe/+5wWThDrdwsmrHGuTR/epYhKoIS4KxeZkS
9x3k78Iwlu0hxOqb5Q7jeM3/3Ody/RJg/JN17QLJxMWgTk7JIGZpXEst/r3lG3xB
jCmyqjXBP7SWEyEz6MUNM7jxi4oPjVSmgKPZSFdx2H65fjNB6zyCsaMri/IuzUfd
FhXD3VbXyAn4It5WIZjcvdS/MsrkwSmEBKVonTXkqYONGpwEYmMq7bs9gUvMeWSn
LRY0RtZ0ktPOK8UvumK+
=lGJn
-----END PGP SIGNATURE-----

--VJdv1a0WcfBdG5ccDTovVrxNXvv0tl9jm--
