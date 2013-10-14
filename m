Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3JNTXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:23:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35328 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab3JNTXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:23:17 -0400
Message-ID: <525C4487.2030502@ti.com>
Date: Mon, 14 Oct 2013 15:22:47 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
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
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com> <1381300194-13134-1-git-send-email-l.majewski@samsung.com> <20131014074635.77fd9f6e@amdc308.digital.local> <744357E9AAD1214791ACBA4B0B90926301190077@SHSMSX101.ccr.corp.intel.com> <525C4242.2050306@ti.com>
In-Reply-To: <525C4242.2050306@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="Hx5JMLHSnMBrj35brmWa2QDMcRJX6lVoQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Hx5JMLHSnMBrj35brmWa2QDMcRJX6lVoQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 14-10-2013 15:13, Eduardo Valentin wrote:
> On 14-10-2013 01:52, Zhang, Rui wrote:
>> Eduardo,
>>
>> What's your opinion on this patch set?
>> BTW, please send me all the urgent fixes for thermal soc drivers that
> you think should go to 3.12.
>>
>=20
> I will be sending these + one fix on ti soc thermal for 3.12 soon.
>=20
> The new chip support on exynos needs to be reworked and there are coupl=
e
> of new drivers that needs to be reworked too. But those I don't think
> are ready to go now.
>=20

Just to be clear, on this patch set obviously I wont be sending the DT
changes. Those should go via the correct tree.

>> Thanks,
>> rui
>>> -----Original Message-----
>>> From: Lukasz Majewski [mailto:l.majewski@samsung.com]
>>> Sent: Monday, October 14, 2013 1:47 PM
>>> To: Zhang, Rui; Eduardo Valentin; kgene.kim@samsung.com
>>> Cc: Lukasz Majewski; Linux PM list; Lukasz Majewski; linux-kernel;
>>> Bartlomiej Zolnierkiewicz; devicetree@vger.kernel.org; Amit Daniel
>>> Kachhap; linux-samsung-soc@vger.kernel.org
>>> Subject: Re: [PATCH v2 0/5] thermal: exynos: Fixes for v3.12
>>> Importance: High
>>>
>>> Hi Zhang, Eduardo,
>>>
>>>> This patch series is divided into two parts:
>>>> 1. Device tree node definition and enabelement for TMU at Exynos4412=

>>>> (Trats2) 2. Exynos thermal subsystem regressions for v3.12-rc4.
>>>> Several commits were necessary to properly fix regression for TMU
>>> test
>>>> MUX address setting after reset.
>>>>
>>>> Test HW:
>>>> - Exynos4412 - TRATS2 board (Linux v3.12-rc4)
>>>> SHA1: 8b5ede69d24db939f52b47effff2f6fe1e83e08b
>>>>
>>>>
>>>> Lukasz Majewski (5):
>>>>   thermal: exynos: Remove check for thermal device pointer at
>>>>     exynos_report_trigger()
>>>>   thermal: exynos: Provide separate TMU data for Exynos4412
>>>>   thermal: exynos: Provide initial setting for TMU's test MUX addres=
s
>>>>     at Exynos4412
>>>>   ARM: dts: exynos4x12: Device tree node definition for TMU on
>>>>     Exynos4x12
>>>>   ARM: dts: exynos4412-trats2: Enable TMU support at Trats2
>>>>
>>>
>>> Zhang, Eduardo - any comments?
>>>
>>> Would it be possible to add them to v3.12 since they do fix critical
>>> error and regression on Exynos4412.
>>>
>>>
>>>>  arch/arm/boot/dts/exynos4412-trats2.dts         |    5 ++++
>>>>  arch/arm/boot/dts/exynos4x12.dtsi               |   10 ++++++++
>>>>  drivers/thermal/samsung/exynos_thermal_common.c |    2 --
>>>>  drivers/thermal/samsung/exynos_tmu.c            |   12 ++++++---
>>>>  drivers/thermal/samsung/exynos_tmu.h            |    7 +++++-
>>>>  drivers/thermal/samsung/exynos_tmu_data.c       |   30
>>>> ++++++++++++++++++-----
>>>> drivers/thermal/samsung/exynos_tmu_data.h       |   13 +++++++++- 7
>>>> files changed, 65 insertions(+), 14 deletions(-)
>>>>
>>>
>>>
>>>
>>> --
>>> Best regards,
>>>
>>> Lukasz Majewski
>>>
>>> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in=

>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--Hx5JMLHSnMBrj35brmWa2QDMcRJX6lVoQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJcRIcACgkQCXcVR3XQvP3fIQD9GQhnysF0but2Ykmw3iJ68uSO
8NWW55hd3+sUgke7ZroBALx8fDNM0J2PM9UAK3UEpchsb8/7dun/vn+maQtvFdiC
=DC9P
-----END PGP SIGNATURE-----

--Hx5JMLHSnMBrj35brmWa2QDMcRJX6lVoQ--
