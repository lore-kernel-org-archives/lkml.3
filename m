Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaHAOhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:37:12 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:30355
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750876AbaHAOhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:37:09 -0400
X-WSS-ID: 0N9MTXP-07-5BB-02
X-M-MSG: 
Message-ID: <53DBA603.9030509@amd.com>
Date: Fri, 1 Aug 2014 09:36:51 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/4 V3] irqchip: gicv2m: Add support for multiple MSI
 for ARM64 GICv2m
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1404947104-21345-5-git-send-email-suravee.suthikulpanit@amd.com>
 <87vbqej2rj.fsf@approximate.cambridge.arm.com>
In-Reply-To: <87vbqej2rj.fsf@approximate.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(164054003)(377454003)(479174003)(189002)(199002)(23756003)(92726001)(102836001)(110136001)(64706001)(20776003)(50986999)(101416001)(83072002)(87936001)(80022001)(92566001)(85852003)(74662001)(74502001)(99396002)(64126003)(105586002)(81542001)(50466002)(95666004)(65806001)(65956001)(106466001)(81342001)(65816999)(36756003)(33656002)(76176999)(47776003)(107046002)(54356999)(87266999)(4396001)(79102001)(31966008)(21056001)(44976005)(83322001)(80316001)(83506001)(76482001)(86362001)(97736001)(77982001)(46102001)(59896001)(84676001)(85306004)(68736004);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029097202E
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/2014 10:16 AM, Marc Zyngier wrote:
> Why do we need this complexity at all? Is there any case where we'd want
> to limit ourselves to a single vector for MSI?

I think the ARM64 GICv2m should not be the limitation for the devices 
multiple MSI if there is no real hardware/design limitation.

> arm64 is a new enough architecture so that we can expect all interrupt controllers to cope
> with that.

I am not sure if I understand this comment.

We are not forcing all interrupt controllers for ARM64 to handle 
multi-MSI.  They have the option to support if multi-MSI if they want 
to. I just think that we should not put the architectural limit here.

Thanks,

Suravee

