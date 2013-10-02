Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab3JBB3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:29:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35266 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab3JBB3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:29:12 -0400
Message-ID: <524B76A7.101@ti.com>
Date: Tue, 1 Oct 2013 21:28:07 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <grant.likely@linaro.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] arm: dts: dra7: add bandgap entry
References: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com> <1380652344-18819-4-git-send-email-eduardo.valentin@ti.com> <20131001224645.GC11451@kahuna>
In-Reply-To: <20131001224645.GC11451@kahuna>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="Vo1ERtetX9QxKm2uHovL9jc0UFaGJSDol"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Vo1ERtetX9QxKm2uHovL9jc0UFaGJSDol
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01-10-2013 18:46, Nishanth Menon wrote:
> On 14:32-20131001, Eduardo Valentin wrote:
>> This patch adds bandgap IP entry on DRA7 dtsi device tree file.
>>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  arch/arm/boot/dts/dra7.dtsi | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi=

>> index 3a746c2..4e9b159 100644
>> --- a/arch/arm/boot/dts/dra7.dtsi
>> +++ b/arch/arm/boot/dts/dra7.dtsi
>> @@ -53,6 +53,18 @@
>>  		};
>>  	};
>> =20
>> +	bandgap: bandgap {
> 	would you like to follow bandgap: bandgap@4a0021e0 convention?
> Also, could you move it under ocp?
> I already commented about this previously here:=20
> https://lkml.org/lkml/2013/9/27/300

yes, this can be done.

>=20
>> +		reg =3D <0x4a0021e0 0xc
>> +			0x4a00232c 0xc
>> +			0x4a002380 0x2c
>> +			0x4a0023C0 0x3c
>> +			0x4a002564 0x8
>> +			0x4a002574 0x50>;
>> +		compatible =3D "ti,dra752-bandgap";
>> +		interrupts =3D <GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>;
>> +		#thermal-sensor-cells =3D <1>;
>> +	};
>> +
>>  	gic: interrupt-controller@48211000 {
>>  		compatible =3D "arm,cortex-a15-gic";
>>  		interrupt-controller;


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--Vo1ERtetX9QxKm2uHovL9jc0UFaGJSDol
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJLdqcACgkQCXcVR3XQvP3eSAEAnybI5nl+eEfPcvdDtXgBxaiC
19sq+S1czdf5bTxo0bABAP3Jl/r8PdsojZbCUyDyxP5kjqdHNmWlTnmj1BxkADJ/
=jDIx
-----END PGP SIGNATURE-----

--Vo1ERtetX9QxKm2uHovL9jc0UFaGJSDol--
