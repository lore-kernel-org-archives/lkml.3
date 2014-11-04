Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaKDRAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:00:39 -0500
Received: from mail-bn1bbn0109.outbound.protection.outlook.com ([157.56.111.109]:25643
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750901AbaKDRAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:00:37 -0500
X-WSS-ID: 0NEIXWU-08-P3A-02
X-M-MSG: 
Message-ID: <5459062F.6090603@amd.com>
Date: Tue, 4 Nov 2014 11:00:31 -0600
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <jason@lakedaemon.net>, <tglx@linutronix.de>
CC: <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>, <liviu.dudau@arm.com>,
        <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [V10 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m
 MSI(-X)
References: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1415052977-26036-3-git-send-email-suravee.suthikulpanit@amd.com>
 <5458CE31.3040404@linux.intel.com>
In-Reply-To: <5458CE31.3040404@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(428002)(199003)(189002)(24454002)(51704005)(479174003)(164054003)(105586002)(87936001)(106466001)(2201001)(99396003)(15202345003)(65956001)(101416001)(87266999)(65806001)(92726001)(36756003)(20776003)(59896002)(107046002)(120916001)(62966003)(4396001)(68736004)(31966008)(46102003)(83506001)(84676001)(97736003)(19580395003)(47776003)(92566001)(80316001)(64126003)(95666004)(54356999)(77096003)(50466002)(102836001)(65816999)(44976005)(21056001)(33656002)(76176999)(50986999)(99136001)(86362001)(77156002)(64706001)(15975445006)(23746002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03853D523D
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/4/14 07:01, Jiang Liu wrote:
> Hi Suravee,
> 	You may build a two level hierarchy irqdomains. Use the
> utilities in this thread
> http://www.spinics.net/lists/arm-kernel/msg374722.html to build an MSI
> irqdomain to manage MSI controllers
> in PCI devices. And build another irqdomain to manage SPI allocation
> in GICv2.
> 	That is: MSI irqdomain (program MSI registers)  -->
> GIV irqdomain (manage SPIs in GICv2 controller)

That's great. I'll look at this patch in and make use of it to create to 
MSI domain.

Thanks,

Suravee

> Regards!
> Gerry
