Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3JBBrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:47:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52631 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab3JBBq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:46:59 -0400
Message-ID: <524B7AC9.3070906@ti.com>
Date: Tue, 1 Oct 2013 21:45:45 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <grant.likely@linaro.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] DRA7: DT thermal support
References: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com> <20131001225848.GA12365@kahuna>
In-Reply-To: <20131001225848.GA12365@kahuna>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="jgUARiimWhC3rRT7x7bipJOUg0g8T6UNm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jgUARiimWhC3rRT7x7bipJOUg0g8T6UNm
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01-10-2013 18:58, Nishanth Menon wrote:
> On 14:32-20131001, Eduardo Valentin wrote:
>> Hello all,
>>
>> This is a complementary patch series with themal DT support for DRA7.
>>
>> Although this work depends on the thermal dt parser work [1], I decide=
d
>> to share it before hand. It also depends on DRA7 DT base port support,=

>> which I fetched from Rajendra's tree [2].
>>
>> This patch series has been runtime tested on DRA7-evm.
>>
>> All best,
>>
>> [1] - https://lkml.org/lkml/2013/9/26/787
>> [2] - git://github.com/rrnayak/linux.git out-of-tree/dra-integrated-v3=

>>
>> Eduardo Valentin (7):
>>   arm: dts: add dra7 DSPEVE thermal data
>>   arm: dts: add dra7 IVA thermal data
>>   arm: dts: dra7: add bandgap entry
>>   arm: dts: add cooling properties on dra7 cpu node
>>   arm: dts: dra7: add thermal data
>>   arm: dts: add tmp102 i2c sensor node on dra7-evm
>>   arm: dts: add thermal zones info on tmp102 for DRA7-EVM
>>
>>  arch/arm/boot/dts/dra7-dspeve-thermal.dtsi | 28 +++++++++++++++++++++=
+++++++
>>  arch/arm/boot/dts/dra7-evm.dts             | 23 +++++++++++++++++++++=
++
>>  arch/arm/boot/dts/dra7-iva-thermal.dtsi    | 28 +++++++++++++++++++++=
+++++++
>>  arch/arm/boot/dts/dra7.dtsi                | 27 +++++++++++++++++++++=
+++++-
>>  4 files changed, 105 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm/boot/dts/dra7-dspeve-thermal.dtsi
>>  create mode 100644 arch/arm/boot/dts/dra7-iva-thermal.dtsi
>=20
> +Benoit, Tony, Linux-omap.
> Ref: http://marc.info/?l=3Dlinux-pm&m=3D138065243027014&w=3D2
>=20
> Tony, Benoit,
> The following diff[1] is probably needed to ensure that right audience
> is addressed.

Well, yeah. thinking of this series now I probably should have mentioned
clear that it is not ready for merge. Not only because it depends on a
working in progress I have referred at [1], but because we lack
completely dra7 files (at linus tree we have no files under
arch/arm/boot/dts/*dra7*).  Therefore, I mentioned in this cover letter
that I actually based this work on top of [2] and [1]. Apologies if it
was not clear enough for you.

Just to make clear, the intention of this patch set was to share and use
yet another example of the usage of the work at [1]. Thus the audience
was directed to the cc and to lists I used.

>=20
> Eduardo,
> could you send an updated series with Tony,
> Benoit and linux-omap in the loop?

Well sure, once it has the right dependency in place.

>=20
> [1]
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 284969f..3442671 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5969,6 +5969,7 @@ M:	Tony Lindgren <tony@atomide.com>
>  L:	linux-omap@vger.kernel.org
>  L:	devicetree@vger.kernel.org
>  S:	Maintained
> +F:	arch/arm/boot/dts/*dra7*

I believe, once we have them merged, then I suppose this diff is applicab=
le.

>  F:	arch/arm/boot/dts/*omap*
>  F:	arch/arm/boot/dts/*am3*
> =20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--jgUARiimWhC3rRT7x7bipJOUg0g8T6UNm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJLeskACgkQCXcVR3XQvP1vXgEAxfIMOnftCc+ot8JCIDrAVkrE
6eqiY7kr1B/RAhh7JbYBAL9NNkquEeOqzgDnC8Zc3hTi4FTdObqOIWId6VP2h289
=TMRN
-----END PGP SIGNATURE-----

--jgUARiimWhC3rRT7x7bipJOUg0g8T6UNm--
