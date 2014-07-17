Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765AbaGQON6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:13:58 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:59052
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933228AbaGQONz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:13:55 -0400
X-WSS-ID: 0N8V0V0-07-FHP-02
X-M-MSG: 
Message-ID: <53C7DA11.2000105@amd.com>
Date: Thu, 17 Jul 2014 09:13:37 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: <linux-arm-kernel@lists.infradead.org>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <pawel.moll@arm.com>, <linux-doc@vger.kernel.org>,
        <Catalin.Marinas@arm.com>, <Harish.Kasiviswanathan@amd.com>,
        <linux-kernel@vger.kernel.org>, <Will.Deacon@arm.com>,
        <linux-pci@vger.kernel.org>, <tglx@linutronix.de>
Subject: Re: [PATCH] irqchip: gic: Add binding probe for ARM GIC400
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1404947104-21345-2-git-send-email-suravee.suthikulpanit@amd.com>
 <2932284.F1eaAf8ArJ@diego> <2621565.f5eISveXXJ@diego>
 <20140717124804.GI13108@titan.lakedaemon.net>
In-Reply-To: <20140717124804.GI13108@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(377454003)(479174003)(189002)(199002)(51704005)(24454002)(36756003)(87936001)(65816999)(76176999)(87266999)(54356999)(92566001)(92726001)(50986999)(33656002)(83506001)(21056001)(99396002)(76482001)(46102001)(77982001)(65806001)(79102001)(97736001)(80022001)(83072002)(85852003)(65956001)(59896001)(4396001)(64706001)(20776003)(47776003)(106466001)(107046002)(74662001)(81542001)(81342001)(64126003)(23756003)(50466002)(86362001)(19580395003)(19580405001)(83322001)(102836001)(101416001)(85306003)(44976005)(31966008)(84676001)(74502001)(68736004)(95666004)(93886003)(105586002);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB045;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/2014 7:48 AM, Jason Cooper wrote:
> On Tue, Jul 15, 2014 at 12:03:03AM +0200, Heiko Stübner wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> Commit 3ab72f9156bb "dt-bindings: add GIC-400 binding" added the
>> "arm,gic-400" compatible string, but the corresponding IRQCHIP_DECLARE
>> was never added to the gic driver.
>>
>> Therefore add the missing irqchip declaration for it.
>>
>> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> Removed additional empty line and adapted commit message to mark it
>> as fixing an issue.
>> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
>> ---
>> As I really need this, I took the liberty of adapting the patch accordingly
>> to make it apply on top of the current irqchip/for-next (or urgent) and
>> explicitly state the fixed issue. Hope that is ok
>>
>>   drivers/irqchip/irq-gic.c | 1 +
>>   1 file changed, 1 insertion(+)
>
> Applied to irqchip/urgent with Will's Ack and Cc'd to stable for v3.14+
>
> thx,
>
> Jason.
>
Thank you,

Suravee

