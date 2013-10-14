Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3JNTNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:13:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48534 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590Ab3JNTNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:13:23 -0400
Message-ID: <525C4242.2050306@ti.com>
Date: Mon, 14 Oct 2013 15:13:06 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Zhang, Rui" <rui.zhang@intel.com>
CC: Lukasz Majewski <l.majewski@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] thermal: exynos: Fixes for v3.12
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com> <1381300194-13134-1-git-send-email-l.majewski@samsung.com> <20131014074635.77fd9f6e@amdc308.digital.local> <744357E9AAD1214791ACBA4B0B90926301190077@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926301190077@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="TV0irM1TacSJWWEFu7HwS5RSXpCHuiFLA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TV0irM1TacSJWWEFu7HwS5RSXpCHuiFLA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 14-10-2013 01:52, Zhang, Rui wrote:
> Eduardo,
>=20
> What's your opinion on this patch set?
> BTW, please send me all the urgent fixes for thermal soc drivers that
you think should go to 3.12.
>=20

I will be sending these + one fix on ti soc thermal for 3.12 soon.

The new chip support on exynos needs to be reworked and there are couple
of new drivers that needs to be reworked too. But those I don't think
are ready to go now.

> Thanks,
> rui
>> -----Original Message-----
>> From: Lukasz Majewski [mailto:l.majewski@samsung.com]
>> Sent: Monday, October 14, 2013 1:47 PM
>> To: Zhang, Rui; Eduardo Valentin; kgene.kim@samsung.com
>> Cc: Lukasz Majewski; Linux PM list; Lukasz Majewski; linux-kernel;
>> Bartlomiej Zolnierkiewicz; devicetree@vger.kernel.org; Amit Daniel
>> Kachhap; linux-samsung-soc@vger.kernel.org
>> Subject: Re: [PATCH v2 0/5] thermal: exynos: Fixes for v3.12
>> Importance: High
>>
>> Hi Zhang, Eduardo,
>>
>>> This patch series is divided into two parts:
>>> 1. Device tree node definition and enabelement for TMU at Exynos4412
>>> (Trats2) 2. Exynos thermal subsystem regressions for v3.12-rc4.
>>> Several commits were necessary to properly fix regression for TMU
>> test
>>> MUX address setting after reset.
>>>
>>> Test HW:
>>> - Exynos4412 - TRATS2 board (Linux v3.12-rc4)
>>> SHA1: 8b5ede69d24db939f52b47effff2f6fe1e83e08b
>>>
>>>
>>> Lukasz Majewski (5):
>>>   thermal: exynos: Remove check for thermal device pointer at
>>>     exynos_report_trigger()
>>>   thermal: exynos: Provide separate TMU data for Exynos4412
>>>   thermal: exynos: Provide initial setting for TMU's test MUX address=

>>>     at Exynos4412
>>>   ARM: dts: exynos4x12: Device tree node definition for TMU on
>>>     Exynos4x12
>>>   ARM: dts: exynos4412-trats2: Enable TMU support at Trats2
>>>
>>
>> Zhang, Eduardo - any comments?
>>
>> Would it be possible to add them to v3.12 since they do fix critical
>> error and regression on Exynos4412.
>>
>>
>>>  arch/arm/boot/dts/exynos4412-trats2.dts         |    5 ++++
>>>  arch/arm/boot/dts/exynos4x12.dtsi               |   10 ++++++++
>>>  drivers/thermal/samsung/exynos_thermal_common.c |    2 --
>>>  drivers/thermal/samsung/exynos_tmu.c            |   12 ++++++---
>>>  drivers/thermal/samsung/exynos_tmu.h            |    7 +++++-
>>>  drivers/thermal/samsung/exynos_tmu_data.c       |   30
>>> ++++++++++++++++++-----
>>> drivers/thermal/samsung/exynos_tmu_data.h       |   13 +++++++++- 7
>>> files changed, 65 insertions(+), 14 deletions(-)
>>>
>>
>>
>>
>> --
>> Best regards,
>>
>> Lukasz Majewski
>>
>> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--TV0irM1TacSJWWEFu7HwS5RSXpCHuiFLA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJcQkIACgkQCXcVR3XQvP19+gD/VKhnzP2InuUF0/zC1piw/nSk
ZItg+bH4AqeVQZDoaYsA/A7Km5GCqSldU+Mq5XCgIslTyGRwGrmFZnLokLnO9NZi
=5hFc
-----END PGP SIGNATURE-----

--TV0irM1TacSJWWEFu7HwS5RSXpCHuiFLA--
