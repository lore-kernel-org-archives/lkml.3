Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaFYATu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:19:50 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:9260
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752771AbaFYATt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:19:49 -0400
X-WSS-ID: 0N7P7KV-07-R8M-02
X-M-MSG: 
Message-ID: <53AA158E.1040700@amd.com>
Date: Tue, 24 Jun 2014 19:19:26 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: <marc.zyngier@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Liviu.Dudau@arm.com>
Subject: Re: [PATCH 0/2] Introduce ARM GICv2m MSI(-X) support
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140624122639.GL10202@titan.lakedaemon.net>
In-Reply-To: <20140624122639.GL10202@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(479174003)(24454002)(377454003)(189002)(51704005)(199002)(83072002)(21056001)(20776003)(76482001)(97736001)(65816999)(83322001)(50986999)(83506001)(81542001)(76176999)(50466002)(68736004)(59896001)(87266999)(15975445006)(44976005)(101416001)(106466001)(19580405001)(33656002)(46102001)(99396002)(80316001)(105586002)(86362001)(74662001)(79102001)(74502001)(4396001)(65806001)(77982001)(102836001)(23756003)(87936001)(31966008)(65956001)(95666004)(47776003)(64706001)(19580395003)(84676001)(36756003)(64126003)(80022001)(81342001)(85306003)(92566001)(54356999)(85852003)(92726001);DIR:OUT;SFP:;SCL:1;SRVR:BY1PR0201MB0918;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/2014 7:26 AM, Jason Cooper wrote:
> On Mon, Jun 23, 2014 at 07:32:58PM -0500, suravee.suthikulpanit@amd.com wrote:
>> This patch set introduces support for MSI(-X) in GICv2m specification,
>> which is implemented in some variation of GIC400.
>>
>> This depends on and has been tested with the V7 of "Add support for PCI in AArch64"
>> (https://lkml.org/lkml/2014/3/14/320).
>
> Is this a build, boot, or runtime dependency?
>
> thx,
>
> Jason.
>

For all of the above.

Suravee

