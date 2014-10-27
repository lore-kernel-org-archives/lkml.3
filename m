Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaJ0Oan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:30:43 -0400
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:63068
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752920AbaJ0Oam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:30:42 -0400
X-WSS-ID: 0NE3XMY-08-JD2-02
X-M-MSG: 
Message-ID: <544E5701.8000408@amd.com>
Date: Mon, 27 Oct 2014 09:30:25 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
CC: <mark.rutland@arm.com>, <will.deacon@arm.com>, <catalin.marinas@arm.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>, <marc.zyngier@arm.com>,
        <liviu.dudau@arm.com>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com>
 <544D00B1.7070703@suse.de>
In-Reply-To: <544D00B1.7070703@suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(377454003)(24454002)(189002)(479174003)(51704005)(107046002)(102836001)(120886001)(120916001)(99396003)(106466001)(65816999)(92566001)(19580395003)(87266999)(84676001)(54356999)(19580405001)(50986999)(76176999)(85306004)(80316001)(101416001)(105586002)(33656002)(95666004)(76482002)(50466002)(110136001)(36756003)(87936001)(65956001)(65806001)(86362001)(47776003)(64126003)(20776003)(31966008)(4396001)(97736003)(44976005)(23746002)(46102003)(21056001)(80022003)(83506001)(92726001)(64706001)(68736004)(85852003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0377802854
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2014 9:09 AM, Andreas Färber wrote:
> Hi,
>
> Am 24.10.2014 um 14:20 schrieb suravee.suthikulpanit@amd.com:
>> diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
>> index f8001a6..6c27047 100644
>> --- a/arch/arm64/boot/dts/Makefile
>> +++ b/arch/arm64/boot/dts/Makefile
>> @@ -1,6 +1,7 @@
>>   dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
>>   dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>>   dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
>> +dtb-$(CONFIG_ARCH_SEATTLE) += amd-seattle.dtb
>
> It seems these lines are sorted alphabetically, so Seattle should go
> somewhere before Thunder.
>
>>
>>   targets += dtbs
>>   targets += $(dtb-y)
>
> Regards,
> Andreas
>

Ah.. right. I'll fix this and send out V2.

Suravee

