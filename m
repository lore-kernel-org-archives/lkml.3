Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3FNGhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 02:37:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33532 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab3FNGhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 02:37:04 -0400
Message-ID: <51BAB9EA.5090805@ti.com>
Date: Fri, 14 Jun 2013 09:36:26 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 1/4] arm: omap: Add phy binding info for musb in plat
 data
References: <1368796954-3499-1-git-send-email-kishon@ti.com> <51A43E0A.8090201@ti.com> <51B9C3B6.1080707@ti.com> <51BAABB0.5060107@ti.com> <20130614054720.GL8164@atomide.com>
In-Reply-To: <20130614054720.GL8164@atomide.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2LWTHKMTPTSUPGLMFEARV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2LWTHKMTPTSUPGLMFEARV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 14/06/13 08:47, Tony Lindgren wrote:
> * Kishon Vijay Abraham I <kishon@ti.com> [130613 22:41]:
>> Hi,
>>
>> On Thursday 13 June 2013 06:35 PM, Tomi Valkeinen wrote:
>>> Hi,
>>>
>>> On 28/05/13 08:18, Kishon Vijay Abraham I wrote:
>>>> Hi Tony,
>>>>
>>>> On Friday 17 May 2013 06:52 PM, Kishon Vijay Abraham I wrote:
>>>>> In order for controllers to get PHY in case of non dt boot, the phy=

>>>>> binding information (phy label) should be added in the platform
>>>>> data of the controller.
>>>>
>>>> This series would be needed to get MUSB working in OMAP3 boards for
>>>> non-dt boot case. Do you think this is good enough to go in this rc =
cycle?
>>>
>>> Did this or some other solution go forward? I'm still unable to boot
>>> with usb-gadget-ethernet with v3.10-rc5.
>>
>> No. I think Tony is ok to take this only during next merge window.
>=20
> Yes I'll apply them to omap-for-v3.11/fixes-non-critical. We really
> should have basic functionaly tested and working always before the
> merge window so we only need to do minimal fixes during the -rc cycle.

I'm mostly interested in the USB gadget ethernet for the boards I have,
but if I'm not mistaken, all USB gadget support for many OMAP boards is
broken in v3.10. Shouldn't that be fixed, no matter if it's a minimal
fix or not? Or is there some other, more minimal, way to fix this?

 Tomi



------enig2LWTHKMTPTSUPGLMFEARV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRurntAAoJEPo9qoy8lh71N4cP/R7ASm0PjLDbXvV7Di89b7EB
h7ntvTdEHXgB/9Y8qWg3lEoX+rdYfBljvI+c8vwSd/Rlydof1Ij7Xt+8j6sRC15d
FcWlvDN060vZGpoPp6d1Dy67HowoTm3QcRtJFFmkiLeM1+otpF/7QmjdtSot6M60
KezKX1+TGrZhDKIjRanM9alMF5ruUquc8jlaQGqPPM7SZzjq4zCuN92ilqFJFDpv
yywCCupBN+ylOGhdmQYVXPLRItpurY733EUi4/anJnCHCzo2DCL9SBQ+VRR44esg
EQPUa7OFZqKI3JivcMbV+ScX9Frti7RweU6qnnBTFLi1SWROUCLTTxTmS5fRPaqb
jiPkoGOMdR41srKMI5hCrvpsR5AXqDT4NmUsgb2PcwzHUJ9IzByOGLUhAuVbdQwU
GQSfu3NduQv9p8EHDfI7H+dEFu7HIAYOcQKqN4maMJJwxKSp55DOP/2KfdcEinDZ
Gs7Py3PAogP39ETeKzz5YEPSR/ACi1CJjJFzZCcTYT2sT6RmAK8iYL6zkKJkutM+
TwBvOYF8d6Cw31caX882NRHT9l2Tv+CRWcwSdH/Jq/hlnCRQs2e3ABijoUtQXjfx
+fyz+JPZGl7uSA1GPGTI//7SQIojOjkiqp60WfStxd6OEtSUgHlF64pDQs/G8fx4
qx3roYyXxPqVzxeJdu5k
=POe6
-----END PGP SIGNATURE-----

------enig2LWTHKMTPTSUPGLMFEARV--
