Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbaGYIgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:36:14 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:52968
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759774AbaGYIgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:36:11 -0400
Date: Fri, 25 Jul 2014 10:36:03 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>, <monstr@monstr.eu>,
        =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 06/11] ARM: dts: zynq: Add DMAC for Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-7-git-send-email-afaerber@suse.de>
 <bc390439-9a5b-43a1-a70c-a4c6517a6cb6@BN1AFFO11FD005.protection.gbl>
 <53D20F2A.5020209@monstr.eu> <53D21458.3060403@suse.de>
In-Reply-To: <53D21458.3060403@suse.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="jh01ixvfH45lwgIFL8FIOO8wMdfQKlnbu"
X-RCIS-Action: ALLOW
Message-ID: <42796bf5-b27c-4009-894d-9462c85e2bc2@BY2FFO11FD025.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(479174003)(377454003)(199002)(377424004)(51704005)(164054003)(24454002)(71186001)(64706001)(107046002)(79102001)(92726001)(77982001)(54356999)(99396002)(568964001)(104016003)(81342001)(64126003)(4396001)(81542001)(31696002)(76482001)(85852003)(20776003)(1496007)(80022001)(83072002)(87936001)(19580395003)(93886003)(65956001)(83506001)(92566001)(70736001)(44976005)(65806001)(83322001)(106466001)(50986999)(84326002)(95666004)(6806004)(85306003)(74502001)(21056001)(102836001)(19580405001)(86362001)(31966008)(512874002)(76176999)(46102001)(74662001)(74316001)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB016;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jh01ixvfH45lwgIFL8FIOO8wMdfQKlnbu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/25/2014 10:24 AM, Andreas F=C3=A4rber wrote:
> Am 25.07.2014 10:02, schrieb Michal Simek:
>> On 07/25/2014 01:28 AM, S=C3=B6ren Brinkmann wrote:
>>> On Fri, 2014-07-25 at 01:00AM +0200, Andreas F=C3=A4rber wrote:
>>>> Signed-off-by: Andreas F=C3=A4rber <afaerber@suse.de>
>>>> ---
>>>>  v2: New
>>>> =20
>>>>  arch/arm/boot/dts/zynq-7000.dtsi      | 17 +++++++++++++++++
>>>>  arch/arm/boot/dts/zynq-parallella.dts |  4 ++++
>>>>  2 files changed, 21 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zy=
nq-7000.dtsi
>>>> index eed3df0..1a70277 100644
>>>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
>>>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
>>>> @@ -223,6 +223,23 @@
>>>>  			};
>>>>  		};
>>>> =20
>>>> +		dmac_s: dmac@f8003000 {
>>>> +			compatible =3D "arm,pl330", "arm,primecell";
>>>> +			reg =3D <0xf8003000 0x1000>;
>>>> +			status =3D "disabled";
>>> I think for this IP we can omit the 'status' property since it is alw=
ays
>>> enabled. I don't see a reason to override it in each board DT.
>>
>> Done this change myself
>=20
> Fine with me, but allow me to point out that the TRM documents the DMAC=

> being mapped as DMAC S at the above address, and as DMAC NS at F800_400=
0
> (secure vs. non-secure, ch. 4.6, p. 116). Not sure how this would be
> handled driver-wise if not through alternative dt nodes?

Kernel on zynq runs in secure world. All the sw on zynq from beginning ru=
ns in secure world.
I haven't had any time to look at switching kernel to NS.
That's why having dmac in this dts as default configuration in secure wor=
ld
is fine.

It is not about how driver will handle - driver shouldn't care.
It is how users will handle that kernel runs in non secure
and how to change DTS to reflect this.
Bootloader can do this change for example. Or if there is an option
to detect at run time by kernel that we are in NS than kernel itself can
patch dmac node and use different address.
Definitely bootloader or setup correct address by user is preferred way.

Thanks,
Michal



--jh01ixvfH45lwgIFL8FIOO8wMdfQKlnbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPSFvMACgkQykllyylKDCEUXgCeIXT9RPLa3QdhcsmyGTuM2W33
qOoAoJIVvtNryqXw7SIve1LYgxgj53h+
=2/77
-----END PGP SIGNATURE-----

--jh01ixvfH45lwgIFL8FIOO8wMdfQKlnbu--
