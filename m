Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbaKFAX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 19:23:29 -0500
Received: from mail-bl2on0118.outbound.protection.outlook.com ([65.55.169.118]:56864
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750844AbaKFAXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 19:23:25 -0500
X-WSS-ID: 0NELD2U-07-Q7U-02
X-M-MSG: 
Message-ID: <545ABF6C.1000308@amd.com>
Date: Wed, 5 Nov 2014 18:23:08 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
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
 <5458CE31.3040404@linux.intel.com> <545ABB4C.8010103@amd.com>
In-Reply-To: <545ABB4C.8010103@amd.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(479174003)(377454003)(189002)(164054003)(24454002)(199003)(65816999)(47776003)(31966008)(87936001)(87266999)(92566001)(50986999)(21056001)(54356999)(92726001)(84676001)(65956001)(44976005)(99396003)(76176999)(106466001)(95666004)(2201001)(97736003)(4396001)(93886004)(33656002)(120886001)(101416001)(80316001)(120916001)(68736004)(46102003)(59896002)(36756003)(102836001)(65806001)(107046002)(23746002)(50466002)(83506001)(20776003)(105586002)(86362001)(62966003)(64126003)(77156002)(64706001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0387D64A71
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/2014 6:05 PM, Suravee Suthikulanit wrote:
> - Overall, it seems that msi_domain_alloc() could be quite different
> across architectures. Would it be possible to declare this function as
> weak, and allow arch to override (similar to arch_setup_msi_irq)?

Actually, declaring "msi_domain_ops" as non-static, and allow other code 
to override the .alloc and .free?

Thanks,

Suravee



