Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592Ab3EOQht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:37:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33513 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759168Ab3EOQhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:37:48 -0400
Message-ID: <5193B9AA.7020507@ti.com>
Date: Wed, 15 May 2013 12:36:58 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 3/3] arm: dts: add bandgap entry for OMAP4460 devices
References: <1368629928-6723-1-git-send-email-eduardo.valentin@ti.com> <1368629928-6723-4-git-send-email-eduardo.valentin@ti.com> <5193A875.1020000@ti.com>
In-Reply-To: <5193A875.1020000@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2AHSMNFSXBHAXNXAONRQT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2AHSMNFSXBHAXNXAONRQT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 15-05-2013 11:23, Benoit Cousson wrote:
> Hi Eduardo,
>=20
> On 05/15/2013 04:58 PM, Eduardo Valentin wrote:
>> Include bandgap devices for OMAP4460 devices.
>>
>> Cc: "Beno=C3=AEt Cousson" <b-cousson@ti.com>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: linux-omap@vger.kernel.org
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  arch/arm/boot/dts/omap4460.dtsi | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap4=
460.dtsi
>> index 2cf227c..e5bfbfe 100644
>> --- a/arch/arm/boot/dts/omap4460.dtsi
>> +++ b/arch/arm/boot/dts/omap4460.dtsi
>> @@ -29,4 +29,13 @@
>>  			     <0 55 0x4>;
>>  		ti,hwmods =3D "debugss";
>>  	};
>> +
>> +	bandgap {
>> +		reg =3D <0x4a002260 0x4
>> +			0x4a00232C 0x4
>> +			0x4a002378 0x18>;
>> +		compatible =3D "ti,omap4460-bandgap";
>> +		interrupts =3D <0 126 4>; /* talert */
>> +		ti,tshut-gpio =3D <86>;



>=20
> Why do you need a custom attribute for GPIO? Cannot you use the standar=
d
> one?

I believe it was by your suggestion :-), during the first attempts to
send this driver. But could not find the thread link :-( sorry.


I guess the reasoning to mark it as a ti specific is because it will be
used as IRQ line to treat thermal shutdown (in SW).

>=20
> Where is the gpio controller phandle?
>=20
> Usually it looks like this:
>=20
> 	gpios =3D <&gpio1 8 0>;
>=20
>=20
> Regards,
> Benoit
>=20
>=20
>=20



------enig2AHSMNFSXBHAXNXAONRQT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGTuaoACgkQCXcVR3XQvP0mewEA80FWDjFHsyjQKn6zoEavUGEw
Y/jcu3nmm1lZFuG3pagBANQBOpLfSHCykCv38SNWdNV6//KxTJCmQuYEDpG+QZ5d
=LBcc
-----END PGP SIGNATURE-----

------enig2AHSMNFSXBHAXNXAONRQT--
