Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaK1QmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:42:13 -0500
Received: from mail-bn1on0114.outbound.protection.outlook.com ([157.56.110.114]:40544
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751564AbaK1QmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:42:11 -0500
X-WSS-ID: 0NFRD24-08-0AY-02
X-M-MSG: 
From: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "olof@lixom.net" <olof@lixom.net>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "liviu.dudau@arm.com" <liviu.dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Schopp, Joel" <Joel.Schopp@amd.com>
Subject: Re: [PATCH V5] arm64: amd-seattle: Adding device tree for AMD
 Seattle platform
Thread-Topic: [PATCH V5] arm64: amd-seattle: Adding device tree for AMD
 Seattle platform
Thread-Index: AQHQCTSj3p5K+Ym6Hk21WcBAhcb7YJx2fQ2AgACOK4A=
Date: Fri, 28 Nov 2014 16:42:04 +0000
Message-ID: <D09EA4E8.A828%suravee.suthikulpanit@amd.com>
In-Reply-To: <201411281613.11626.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.0.121105
x-originating-ip: [10.177.96.15]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0584FDBC1224BF489E72C6A8C00C7F9E@amd.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(51704005)(479174003)(41574002)(189002)(164054003)(199003)(84676001)(87936001)(92726001)(83506001)(92566001)(120916001)(54356999)(50466002)(46102003)(53416004)(77096003)(97756001)(50986999)(21056001)(77156002)(62966003)(2656002)(110136001)(46406003)(23726002)(86362001)(4396001)(31966008)(106466001)(105586002)(101416001)(107046002)(106116001)(64706001)(95666004)(47776003)(20776003)(99396003)(97736003)(36756003)(44976005)(19580395003)(19580405001)(68736004);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Forefront-PRVS: 04097B7F7F
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/28/14, 22:13, "Arnd Bergmann" <arnd@arndb.de> wrote:

>On Wednesday 26 November 2014, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> 
>> Initial revision of device tree for AMD Seattle Development platform.
>> 
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> Signed-off-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
>> Signed-off-by: Joel Schopp <Joel.Schopp@amd.com>
>> ---
>> V5 Changes:
>>   * Rebase to arm-soc for-next (per Olof)
>>   * Restructure the DTS/DTSI into board and SoC configurations (per
>>Olof)
>>   * Add model property at the top level (per Olof)
>>   * Move pcie0 under smb and change smb's ranges property to empty
>>since pcie
>>     is not in the same range. (per Olof)
>>   * Change v2m0's ranges property (per Arnd)
>>   * Change timer interrupt type to level-trigger (per Marc)
>
>Applied to next/arm64, thanks!

Thank you
>
>Looking at this one more time, I had another question:
>
>> +	smb0: smb {
>> +		compatible = "simple-bus";
>> +		#address-cells = <2>;
>> +		#size-cells = <2>;
>> +		ranges;
>> +
>> +		/* DDR range is 40-bit addressing */
>> +		dma-ranges = <0x80 0x0 0x80 0x0 0x7f 0xffffffff>;
>> +
>
>What is a DDR range?
>
>Also, what is special about the last byte? Did you intentionally
>leave it out? I think when we calculate the dma mask, we will
>use 0x3fffffffff so we don't step on the last byte, which I assume
>is not what you intended.
>
>	Arnd

Hm..probably not then. What I meant is to specify 40-bit addressing for
the memory range starting
from [0x80_0000_0000 - 0x100_0000_0000).

As, I discussed with you on IRC, it should also cover the V2m MSI register
frame, and should be starting from
0. The fix should then be:

dma-ranges = <0 0 0 0 0x100 0x00000000>


I will send a patch out to fix and add better comment for this.

Thanks,

Suravee

