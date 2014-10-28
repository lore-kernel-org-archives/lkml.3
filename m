Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaJ1NIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:08:10 -0400
Received: from mail-bl2on0122.outbound.protection.outlook.com ([65.55.169.122]:61948
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751846AbaJ1NIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:08:07 -0400
X-WSS-ID: 0NE5OHC-07-GAV-02
X-M-MSG: 
Message-ID: <544F9525.80304@amd.com>
Date: Tue, 28 Oct 2014 08:07:49 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "liviu.dudau@arm.com" <liviu.dudau@arm.com>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com>
 <544C2D67.8000405@suse.de> <544CEC5B.4020104@suse.de>
 <A1BC53C1-A78E-4B0C-879B-F6A462E58C72@suse.de> <544E56DB.7020305@amd.com>
 <544ED462.20601@suse.de>
In-Reply-To: <544ED462.20601@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(51704005)(199003)(479174003)(377454003)(189002)(86362001)(36756003)(76482002)(92566001)(76176999)(120916001)(120886001)(85852003)(44976005)(46102003)(31966008)(93886004)(92726001)(87936001)(80022003)(85306004)(65816999)(20776003)(54356999)(50466002)(21056001)(83506001)(68736004)(106466001)(101416001)(4396001)(97736003)(84676001)(64126003)(95666004)(64706001)(50986999)(107046002)(47776003)(105586002)(33656002)(65956001)(65806001)(23676002)(102836001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB017;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 6:25 PM, Alexander Graf wrote:
>
>
> On 27.10.14 15:29, Suravee Suthikulanit wrote:
>> On 10/26/2014 9:08 AM, Alexander Graf wrote:
>>>>> This option doesn't exist in upstream kernels, does it? Why not just
>>>>>>> make it dtb-y?
>>>>>
>>>>> CONFIG_ARCH_SEATTLE is being added one hunk above.:)
>>> Oops:).
>>>
>>> I'm not convinced we need a config option just for the sake of
>>> compiling a device tree though.
>>>
>>>
>>> Alex
>>>
>>
>> Eventually, we would add other device driver selections when
>> CONFIG_ARCH_SEATTLE=y. At this point, those drivers are still not ready.
>
> Could you please give me some examples of drivers that would depend on
> CONFIG_ARCH_SEATTLE? I like the current way things work without the need
> for such an option, where everything's implemented purely as drivers you
> can opt in our out of.
>
> You don't have a CONFIG_ARCH_SB7XX on x86 either, right? ;)
>
>
> Alex
>

I am not saying that device drivers need to depend on 
CONFIG_ARCH_SEATTLE. I am thinking along the line of an easy way to 
enable SOC without having to manually select each of the required 
drivers to support the SOC. An example is the "ARCH_VEXPRESS".

Suravee

