Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750975AbaKYIiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:38:19 -0500
Received: from mail-bn1bon0142.outbound.protection.outlook.com ([157.56.111.142]:44269
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750760AbaKYIiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:38:18 -0500
X-WSS-ID: 0NFL6NN-07-0RJ-02
X-M-MSG: 
From: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To: Olof Johansson <olof@lixom.net>
CC: Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>,
        "Will Deacon" <will.deacon@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        Rob Herring <robherring2@gmail.com>, Liviu Dudau <liviu.dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Schopp, Joel" <Joel.Schopp@amd.com>
Subject: Re: [PATCH V4] arm64: amd-seattle: Adding device tree for AMD
 Seattle platform
Thread-Topic: [PATCH V4] arm64: amd-seattle: Adding device tree for AMD
 Seattle platform
Thread-Index: AQHQCDDPK3mlC9v6xEOEmK8G5GOQ9ZxwurUAgAESSoA=
Date: Tue, 25 Nov 2014 08:38:09 +0000
Message-ID: <D09A1695.A205%suravee.suthikulpanit@amd.com>
In-Reply-To: <CAOesGMik=ZxRXFp4aEf1-zK2OvrZ9duuWWpNKRQPUN_n=T39hw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.0.121105
x-originating-ip: [10.177.96.13]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6BA4A09814DE4B46A165591F17FD8D14@amd.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(189002)(51704005)(199003)(479174003)(377454003)(164054003)(174864002)(53416004)(95666004)(31966008)(77096003)(77156002)(62966003)(105586002)(2656002)(97756001)(87936001)(23726002)(120916001)(68736004)(97736003)(83506001)(99396003)(19580395003)(19580405001)(44976005)(36756003)(47776003)(20776003)(50986999)(64706001)(54356999)(84676001)(101416001)(110136001)(50466002)(21056001)(106466001)(46102003)(107046002)(46406003)(86362001)(4396001)(106116001)(92726001)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB202;H:atltwp01.amd.com;FPR:;SPF:None;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB202;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB202;
X-Forefront-PRVS: 040655413E
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB202;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On 11/25/14, 06:09, "Olof Johansson" <olof@lixom.net> wrote:

>Hi Suravee,
>
>Some comments below.
>
>
>On Mon, Nov 24, 2014 at 1:51 PM,  <suravee.suthikulpanit@amd.com> wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>>[...]
>> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
>> index f8001a6..604af09 100644
>> --- a/arch/arm64/boot/dts/Makefile
>> +++ b/arch/arm64/boot/dts/Makefile
>> @@ -1,3 +1,4 @@
>> +dtb-$(CONFIG_ARCH_SEATTLE) += amd-seattle.dtb
>>  dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
>>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>
>For 3.19, we're moving all device tree files on arm64 int per-vendor
>subdirectories.
>
>Can you please prepare this patch to go on top of linux-next (or
>arm-soc for-next) such that it adds this file in the same place?
>
>(Alternatively, we can move it when applying, it's not a huge deal).

No problem. I will provide V5 based with the new directory structure.

>
>
>>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
>> diff --git a/arch/arm64/boot/dts/amd-seattle-periph.dtsi
>>b/arch/arm64/boot/dts/amd-seattle-periph.dtsi
>> new file mode 100644
>> index 0000000..77f565b
>> --- /dev/null
>> +++ b/arch/arm64/boot/dts/amd-seattle-periph.dtsi
>> @@ -0,0 +1,156 @@
>> +/*
>> + * DTS file for AMD Seattle Peripheral
>> + *
>> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
>> + */
>> +
>> +/ {
>> +       motherboard {
>> +               compatible = "simple-bus";
>
>I'm not sure I understand this abstraction. You have a motherboard
>device node, under which you have things like the pl011 UART and SATA
>-- while those blocks really are part of SoC, aren't they? After all,
>you have the pci-e controller as part of the dts file and not the
>dtsi.

Yes, they are parts of the SoC. I will rename the entry to smb,
and I will move the pcie under the smb.
 
>
>Unless you have some underlying motive, it would make more sense to
>keep these at the same toplevel since the "motherboard" doesn't seem
>to be part of the hardware topology as described.

I will restructure the DTS/DTSI and send out V5.

>[..]
>> diff --git a/arch/arm64/boot/dts/amd-seattle.dts
>>b/arch/arm64/boot/dts/amd-seattle.dts
>> new file mode 100644
>> index 0000000..d5fc482
>> --- /dev/null
>> +++ b/arch/arm64/boot/dts/amd-seattle.dts
>> @@ -0,0 +1,89 @@
>> +/*
>> + * DTS file for AMD Seattle
>> + *
>> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
>> + */
>> +
>> +/dts-v1/;
>> +
>> +/include/ "amd-seattle-periph.dtsi"
>> +
>> +/ {
>> +       compatible = "amd,seattle";
>> +       interrupt-parent = <&gic>;
>> +       #address-cells = <2>;
>> +       #size-cells = <2>;
>
>So is this the dts for a specific board? Isn't Seattle the SoC? You
>might want to have a different topmost compatible here to identify the
>board. You should also have a "model" property here to describe what
>the hardware is.
>
>(I'm guessing it's really the development board for Seattle, correct?)

Yes, Seattle is an SoC, and this DTS is meant for the Seattle development
board.

I will add the model property accordingly.


>[..]
>> +
>> +       pcie0: pcie-controller {
>> +               compatible = "pci-host-ecam-generic";
>
>The controller itself should likely go in the SoC dtsi, and only
>per-board additional attributes should go here.

Ok, I will move it.

>
>It's also common to add a status = "disabled" in the dtsi, and
>overriding in the per-system dts with status = "okay" for those IP
>blocks that are actually useful on a particular platform.
>
>So, for example, if the SoC has SATA, but a particular board does not,
>then you wouldn't enable it in the dts.
>
>Also, if you use labels for the nodes in the dts, then you can do a
>flat-format dts where you don't have to exactly duplicate the same
>hierarchy of nodes to override a property (you're already using
>labels). I.e. in this case you could then do (for a board that does
>use sata):
>
>&sata0 {
>        status = "okay";
>};
>
>in the dts (this would go at the top level of the file, not nested
>under other nodes).

This is actually a great idea. Thank you for suggestions. I will adopt
this approach in the V5.

Thanks,

Suravee

