Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524AbaH1JPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:15:33 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:8116
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934783AbaH1JPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:15:30 -0400
X-WSS-ID: 0NB0F1J-07-W9Z-02
X-M-MSG: 
Message-ID: <53FEF325.20505@amd.com>
Date: Thu, 28 Aug 2014 04:15:17 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>,
        <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <tglx@linutronix.de>, <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2 V4] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
References: <1407942041-3291-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1407942041-3291-2-git-send-email-suravee.suthikulpanit@amd.com>
 <003d01cfb76b$629b43c0$27d1cb40$%han@samsung.com>
In-Reply-To: <003d01cfb76b$629b43c0$27d1cb40$%han@samsung.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(479174003)(377454003)(199003)(189002)(24454002)(85852003)(4396001)(33656002)(90102001)(97736001)(81342001)(101416001)(76482001)(64706001)(20776003)(79102001)(92566001)(80022001)(92726001)(65956001)(102836001)(21056001)(107046002)(47776003)(85306004)(87936001)(105586002)(83322001)(50466002)(36756003)(99396002)(19580395003)(54356999)(106466001)(81542001)(68736004)(44976005)(74502001)(86362001)(50986999)(65816999)(95666004)(31966008)(83072002)(64126003)(46102001)(110136001)(84676001)(19580405001)(77982001)(76176999)(23746002);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB046;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 031763BCAF
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/13/2014 09:56 PM, Jingoo Han wrote:
> On Thursday, August 14, 2014 12:01 AM, Suravee Suthikulpanit wrote:
>>
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> ARM GICv2m specification extends GICv2 to support MSI(-X) with
>> a new set of register frame. This patch introduces support for
>> the non-secure GICv2m register frame. Currently, GICV2m is available
>> in certain version of GIC-400.
>>
>> The patch introduces a new property in ARM gic binding, the v2m subnode.
>> It is optional.
>
> Hi Suravee Suthikulpanit,
>
> I added some minor comments.

Thanks for the cleaning up comments.

Suravee
