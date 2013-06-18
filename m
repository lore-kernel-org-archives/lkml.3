Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab3FRUYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:24:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50429 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933069Ab3FRUYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:24:31 -0400
Message-ID: <51C0C1DE.70602@ti.com>
Date: Tue, 18 Jun 2013 16:23:58 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <grant.likely@linaro.org>,
        <linux-pm@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Fabio Stevam <festevam@gmail.com>
Subject: Re: [PATCHv3 2/6] arm: introduce config HAS_BANDGAP
References: <1370637968-23299-1-git-send-email-eduardo.valentin@ti.com> <1370637968-23299-3-git-send-email-eduardo.valentin@ti.com> <20130612170733.GK8164@atomide.com>
In-Reply-To: <20130612170733.GK8164@atomide.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2NVWHIOWHBHRMRVILIALX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2NVWHIOWHBHRMRVILIALX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-06-2013 13:07, Tony Lindgren wrote:
> * Eduardo Valentin <eduardo.valentin@ti.com> [130607 13:53]:
>> Bandgap is a device used to measure temperature on
>> electronic equipments. It is widely used in digital
>> integrated circuits. It is based on the dependency
>> between silicon voltage and temperature.
>>
>> This patch introduce HAS_BANDGAP config entry.
>> This config is a boolean value so that arch
>> code can flag if they feature a bandgap device.
>>
>> This config entry follows the same idea behind
>> ARCH_HAS_CPUFREQ.
>=20
> I suggest you add this to Russell's patch system:
>=20
> Acked-by: Tony Lindgren <tony@atomide.com>

Thanks!

I have add it to Russell's patch system and it has been accepted and
applied.

> =20
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-omap@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: Fabio Stevam <festevam@gmail.com>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  arch/arm/Kconfig            | 3 +++
>>  arch/arm/mach-omap2/Kconfig | 1 +
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index d423d58..bcbdec9 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -174,6 +174,9 @@ config ARCH_HAS_CPUFREQ
>>  	  and that the relevant menu configurations are displayed for
>>  	  it.
>> =20
>> +config ARCH_HAS_BANDGAP
>> +	bool
>> +
>>  config GENERIC_HWEIGHT
>>  	bool
>>  	default y
>> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig=

>> index f49cd51..8620ab5 100644
>> --- a/arch/arm/mach-omap2/Kconfig
>> +++ b/arch/arm/mach-omap2/Kconfig
>> @@ -4,6 +4,7 @@ config ARCH_OMAP
>>  config ARCH_OMAP2PLUS
>>  	bool "TI OMAP2/3/4/5 SoCs with device tree support" if (ARCH_MULTI_V=
6 || ARCH_MULTI_V7)
>>  	select ARCH_HAS_CPUFREQ
>> +	select ARCH_HAS_BANDGAP
>>  	select ARCH_HAS_HOLES_MEMORYMODEL
>>  	select ARCH_OMAP
>>  	select ARCH_REQUIRE_GPIOLIB
>> --=20
>> 1.8.2.1.342.gfa7285d
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2NVWHIOWHBHRMRVILIALX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHAwd4ACgkQCXcVR3XQvP3+wQD+IrY2Sr3db+gxWUFqptvI87XB
grty0MVBcVzm4o4R924A/jB+m6CxCXfrfTqaRaEBZdLFNZTGdd/gAAxHOiIfTqiX
=sySP
-----END PGP SIGNATURE-----

------enig2NVWHIOWHBHRMRVILIALX--
