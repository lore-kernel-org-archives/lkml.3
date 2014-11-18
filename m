Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaKRH4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:56:52 -0500
Received: from mail-bn1on0054.outbound.protection.outlook.com ([157.56.110.54]:5344
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752933AbaKRH4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:56:50 -0500
Date: Tue, 18 Nov 2014 08:56:29 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        =?UTF-8?B?U8O2cmVuIA==?= =?UTF-8?B?QnJpbmttYW5u?= 
	<soren.brinkmann@xilinx.com>
CC: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <monstr@monstr.eu>, Russell King <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v4 6/6] ARM: zynq: DT: Add OCM controller node
References: <cover.1415962281.git.michal.simek@xilinx.com>
	<0a88d52b5e71fb220ca619180ec9ca746edad2b1.1415962281.git.michal.simek@xilinx.com>
	<546881CA.2020801@suse.de>
	<c52187589f5c4cc6b908d899c2b9f7a6@BN1BFFO11FD036.protection.gbl>
 <CAEgOgz7j3jFbf1HxtimzPDMQ3oRu8AAHhHAUtg1boYjOUV5ygA@mail.gmail.com>
In-Reply-To: <CAEgOgz7j3jFbf1HxtimzPDMQ3oRu8AAHhHAUtg1boYjOUV5ygA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21112.002
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <d7d71aa91adc49e5890fe3d64caed4bf@BN1BFFO11FD034.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(51704005)(377424004)(377454003)(164054003)(199003)(479174003)(24454002)(33646002)(106466001)(19580405001)(120916001)(65956001)(92566001)(19580395003)(65806001)(6806004)(44976005)(104016003)(107046002)(102836001)(77156002)(62966003)(99396003)(31966008)(54356999)(74316001)(50986999)(76176999)(108616004)(87936001)(50466002)(64126003)(23676002)(20776003)(86362001)(21056001)(95666004)(83506001)(4396001)(46102003)(47776003)(64706001)(93886004)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB001;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB001;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB001;
X-Forefront-PRVS: 039975700A
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB001;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2014 12:00 AM, Peter Crosthwaite wrote:
> On Mon, Nov 17, 2014 at 5:32 AM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
>> On Sun, 2014-11-16 at 11:51AM +0100, Andreas Färber wrote:
>>> Hi Michal,
>>>
>>> Am 14.11.2014 um 11:52 schrieb Michal Simek:
>>>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
>>>> index ce2ef5bec4f2..e217fb1c1169 100644
>>>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
>>>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
>>>> @@ -150,6 +150,13 @@
>>>>                     reg = <0xf8006000 0x1000>;
>>>>             };
>>>>
>>>> +           ocmc: memory-controller@f800c000 {
>>>> +                   compatible = "xlnx,zynq-ocmc-1.0";
>>>> +                   interrupt-parent = <&intc>;
>>>> +                   interrupts = <0 3 4>;
>>>> +                   reg = <0xf800c000 0x1000>;
>>>> +           };
>>>> +
>>>>             uart0: serial@e0000000 {
>>>>                     compatible = "xlnx,xuartps", "cdns,uart-r1p8";
>>>>                     status = "disabled";
>>>
>>> Not directly related to this patch: As one can see here, the node order
>>> is quite a mess... According to Olof, nodes should be ordered by unit
>>> address, whereas here some but not all seem ordered by node name. Would
>>> you welcome a cleanup patch, or can you fix that yourself?
>>
>> I wouldn't say it's a mess, just a different property to sort the nodes
>> by. For humans reading the DT, searching for nodes, alphabetical order
>> helps finding the right node, IMHO.
> 
> I do generally find myself asking "whats that thing at that address"
> more than I find myself asking the "wheres that piece of hardware" so
> Andreas' sorting scheme makes more sense to me. Vertically scanning a
> DT to give yourself an overview of the system level address map is
> good too. Wheras alphabetic sorting doesn't mean to much.

IMHO the reason why we have names in DT is that it is easily to read/understand them
that's why name sorting seems to me more reasonable.
Something like machine code and assembler - asm is also sorted by names not by opcode.

Is this strict rule?

Thanks,
Michal
