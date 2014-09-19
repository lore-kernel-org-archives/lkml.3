Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbaISGvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 02:51:33 -0400
Received: from mail-bn1on0084.outbound.protection.outlook.com ([157.56.110.84]:20913
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757357AbaISGvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 02:51:31 -0400
Date: Fri, 19 Sep 2014 08:17:15 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Michal Simek <monstr@monstr.eu>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] devicetree: cadence_ttc: Document binding for timer
 width
References: <3537996136ec435ea660da869102d0a019214979.1410964243.git.michal.simek@xilinx.com>
 <20140917161737.GA7983@leverpostej>
 <db43281a-06bc-436b-a082-212d1f95d974@BL2FFO11FD034.protection.gbl>
 <20140918183626.GB10911@leverpostej>
In-Reply-To: <20140918183626.GB10911@leverpostej>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="fn4GrOUcwGX7vwgBrIGGM4VN8OVUwfIBf"
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20950.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <add05eb7-2998-495a-b9c3-f95333b06c7a@BN1BFFO11FD040.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(479174003)(377454003)(164054003)(189002)(24454002)(51704005)(92566001)(92726001)(102836001)(31966008)(54356999)(76176999)(81342003)(81542003)(46102003)(77982003)(6806004)(21056001)(76482002)(80022003)(74662003)(79102003)(93886004)(85306004)(64706001)(20776003)(90102001)(31696002)(64126003)(86362001)(74502003)(512944002)(65956001)(50986999)(65806001)(70736001)(106466001)(104016003)(1496007)(95666004)(33646002)(83322001)(71186001)(44976005)(19580405001)(84326002)(87936001)(74316001)(99396002)(568964001)(83506001)(107046002)(85852003)(19580395003)(4396001)(83072002)(65826006)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB034;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0339F89554
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fn4GrOUcwGX7vwgBrIGGM4VN8OVUwfIBf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/18/2014 08:36 PM, Mark Rutland wrote:
> On Thu, Sep 18, 2014 at 06:07:40AM +0100, Michal Simek wrote:
>> On 09/17/2014 06:17 PM, Mark Rutland wrote:
>>> On Wed, Sep 17, 2014 at 03:30:49PM +0100, Michal Simek wrote:
>>>> From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
>>>>
>>>> Modern TTC implementations can extend the timer width to 32 bit. Thi=
s
>>>> feature is not self identifying so the driver needs to be made aware=

>>>> via device tree.
>>>>
>>>> Signed-off-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
>>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>>> ---
>>>>
>>>>  Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt | 4 +=
+++
>>>>  1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/timer/cadence,ttc-tim=
er.txt b/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
>>>> index 993695c659e1..5439976eca6b 100644
>>>> --- a/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
>>>> +++ b/Documentation/devicetree/bindings/timer/cadence,ttc-timer.txt
>>>> @@ -6,6 +6,9 @@ Required properties:
>>>>  - interrupts : A list of 3 interrupts; one per timer channel.
>>>>  - clocks: phandle to the source clock
>>>>
>>>> +Optional properties:
>>>> +- timer-width: Bit width of the timer. Either 16 or 32 (default 16)=
=2E
>>>
>>> Are we expecting TTC implementations with widths other than 16 or 32?=

>>
>> IRC if you use 32bit timer and setup for example 24bit width it should=
 work
>> too and you are just ignoring that upper bits.
>=20
> Sure, but what I'd like to know is whether we expect HW implementations=

> other than 16 or 32 bit rather than whether or not the driver will work=

> in that case. I'm not saying no to this patch; I'm just curious.

We are trying to find this information.


>>> This looks sane to me, but we might be able to just have a 32-bit-tim=
er
>>> property if we don't expect arbitrary widths.
>>
>> Definitely model different timer width is easily possible to do in qem=
u
>> that's why I think having more generic property timer-width is just be=
tter than
>> having property used just for one case.
>=20
> Ok, so if you want to support that can we change the documentation
> wording to be:
>=20
> - timer-width: Bit width of the timer, necessary if not 16.
>=20
> That implies support for other bit widths, and when the property needs
> to be set (IMO 'default' sounds too much like a driver description than=

> a contract description).

Default one is just option which is used for origin configuration
and we should be backward compatible.
I am OK with this description. Will send v2.

> Does this apply to one timer register, or are multiple registers
> affected?

It applies for all 3 timers. All of them are 16 or 32.

Thanks,
Michal


--fn4GrOUcwGX7vwgBrIGGM4VN8OVUwfIBf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQbymsACgkQykllyylKDCGDEACeIfOroHglokgkE2ZsRIP/QX/a
fc4An0mG7d5LuUjCiicgoZN9PKQVc1lj
=A1jw
-----END PGP SIGNATURE-----

--fn4GrOUcwGX7vwgBrIGGM4VN8OVUwfIBf--
