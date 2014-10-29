Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbaJ2OTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:19:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58263 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398AbaJ2OTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:19:51 -0400
Message-ID: <5450F746.4030901@ti.com>
Date: Wed, 29 Oct 2014 16:18:46 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Pavel Machek <pavel@ucw.cz>
CC: =?windows-1252?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>,
        <sre@debian.org>, <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>
Subject: Re: Nokia n900 problems in 3.18-rc1 (was Re: USB Ethernet gadget
 on Nokia n900)
References: <20141019090107.GA19132@amd> <201410262222.39892@pali> <20141026215548.GA9004@amd> <201410262323.17891@pali> <20141027195209.GP2560@atomide.com> <20141027223114.GU2560@atomide.com> <20141028220450.GA27667@amd> <20141028221124.GT2542@atomide.com> <20141029084637.GA30662@amd> <20141029140943.GX2542@atomide.com>
In-Reply-To: <20141029140943.GX2542@atomide.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="kXWSRCf1boGfPtNKKIbKetgC8uJrnE4tA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kXWSRCf1boGfPtNKKIbKetgC8uJrnE4tA
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 29/10/14 16:09, Tony Lindgren wrote:

>> omapfb reports problems, but seems to work ok:
>>
>> [    0.990386] omapfb omapfb: cannot parse default modes
>> [    1.004791] Console: switching to colour frame buffer device 100x30=

>> [    1.073150] omapfb omapfb: using display 'lcd' mode 800x480
>=20
> Tomi, is the default mode warning correct here?

omapfb warns that it couldn't parse kernel cmdline parameters
('omapfb.mode' parameter). I couldn't find in the thread what actual
parameters were used in this case.

Although I don't see why N900 would need any omapfb mode parameters in
the first place, as the LCD has just one mode...

 Tomi



--kXWSRCf1boGfPtNKKIbKetgC8uJrnE4tA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUPdGAAoJEPo9qoy8lh71xp4QAJCnd8J6h3Zekf4y5gK1aJ3X
YvhgAAVRNVSaAh81JpJnmVL+1My/Qjh1VuJt55uEemKfn8vbC75X14Yhn2m6d5yp
gr6zHBckBxQL2nEc11vg+kiYHtg5k1TPGxlnAPeV70+PXLlGjWe4eT3pRa8TR0Gj
hehDB+Ol46K7ptHW9u79rDSC9ajkFX9SWJvLKcmQv6jrSYBGCXOHxivv/KqY4Kg1
Ih0VMl4Sy6OZ0ArHwgNd+FnZUndcHc2EYbK4qtEt00bKxXagYsns1dXl2Jr6vLRx
m/V/CzPYbiuc7mYWjEUacjHeSQenAJyRFvRFlWmYvq4artP8Mj8JOMVwjmbikYjJ
DwafwHQ3+1S2FlP6CYS57XLF9pdPQ6O+KCW3B87bmJcjcmHwBZ8cxzAHzFjWtkl1
FrQDcd+26d7vSU4Jb69xQYk7dXdpT+/dsOoIX8YYm85gb1Q2ahg2IhKoHjR1Njcr
q31RWg7SBanUtIAmr2pmphnScDySO2dh9TmS29a2Wlss2ktrtMF81wZTjnGUjg6Q
NPB9uw63/j4Zm99xNgBWOvIscj3C3XwC9e0Ex2Jk1GENVArI0SLPsuBQSK3QsdBI
OcrFP1IIVSDb8iz25gaRLniCrllJ45RcqPHLyrdarpFfqmx5Ca+sHwaa/Dq0Ichc
wSD08ypifoOkXqn+CxK7
=B1Co
-----END PGP SIGNATURE-----

--kXWSRCf1boGfPtNKKIbKetgC8uJrnE4tA--
