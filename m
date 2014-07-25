Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbaGYJkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:40:23 -0400
Received: from [207.46.163.212] ([207.46.163.212]:43774 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757778AbaGYJkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:40:21 -0400
Date: Fri, 25 Jul 2014 11:40:02 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>, <monstr@monstr.eu>,
        Srikanth T <sthokal@xilinx.com>
CC: Vinod Koul <vinod.koul@intel.com>, Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 07/11] Documentation: devicetree: Fix Xilinx VDMA specification
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-8-git-send-email-afaerber@suse.de>
 <53D20C19.5000306@monstr.eu> <53D21983.8060901@suse.de>
In-Reply-To: <53D21983.8060901@suse.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="crfIIdUJAMkCKXOuqAXsVFWHuMsk0AgKa"
X-RCIS-Action: ALLOW
Message-ID: <435f86ce-9588-48c7-b01a-5dd97ea64b13@BL2FFO11FD021.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(199002)(189002)(479174003)(377454003)(164054003)(24454002)(76176999)(85852003)(102836001)(1496007)(77982001)(83506001)(84326002)(81342001)(44976005)(54356999)(64126003)(50986999)(74316001)(21056001)(95666004)(81542001)(87936001)(46102001)(76482001)(79102001)(4396001)(92566001)(92726001)(31966008)(74502001)(31696002)(74662001)(99396002)(86362001)(6806004)(568964001)(106466001)(93886003)(85306003)(19580405001)(20776003)(71186001)(70736001)(65806001)(19580395003)(80022001)(512874002)(83322001)(107046002)(64706001)(104016003)(65956001)(83072002)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB029;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--crfIIdUJAMkCKXOuqAXsVFWHuMsk0AgKa
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Andreas,

On 07/25/2014 10:46 AM, Andreas F=C3=A4rber wrote:
> Hi Michal,
>=20
> Am 25.07.2014 09:49, schrieb Michal Simek:
>> On 07/25/2014 01:00 AM, Andreas F=C3=A4rber wrote:
>>> The specification requires xlnx,data-width, but example and driver us=
e
>>> xlnx,datawidth. Change the specification to match the implementation.=

>>>
>>> Signed-off-by: Andreas F=C3=A4rber <afaerber@suse.de>
>>> ---
>>>  v2: New
>>> =20
>>>  Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma=
=2Etxt b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
>>> index 1405ed0..e4c4d47 100644
>>> --- a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
>>> +++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
>>> @@ -25,7 +25,7 @@ Required child node properties:
>>>  - compatible: It should be either "xlnx,axi-vdma-mm2s-channel" or
>>>  	"xlnx,axi-vdma-s2mm-channel".
>>>  - interrupts: Should contain per channel VDMA interrupts.
>>> -- xlnx,data-width: Should contain the stream data width, take values=

>>> +- xlnx,datawidth: Should contain the stream data width, take values
>>>  	{32,64...1024}.
>=20
> BTW I just notice that this values specification is ambiguous as to
> whether 96 is a valid value or only powers of 2 like 128. Maybe you wan=
t
> to clarify that in a follow-up patch?

really appreciate your help for improving this.
Srikanth T: Can you please look at it?

Thanks,
Michal




--crfIIdUJAMkCKXOuqAXsVFWHuMsk0AgKa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPSJfIACgkQykllyylKDCEYNgCaAvAKKSYq0TbbxLfazbxuSlSC
iuQAn0jWNOa+wTu1Hi4lkzG6GfghYsEo
=qjv8
-----END PGP SIGNATURE-----

--crfIIdUJAMkCKXOuqAXsVFWHuMsk0AgKa--
