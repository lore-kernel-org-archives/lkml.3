Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaFYDEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 23:04:39 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:19847
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752599AbaFYDEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 23:04:38 -0400
X-WSS-ID: 0N7PF75-08-221-02
X-M-MSG: 
Message-ID: <53AA3C28.4080200@amd.com>
Date: Tue, 24 Jun 2014 22:04:08 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm/gic: Add supports for GICv2m MSI(-X)
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1403569980-12913-3-git-send-email-suravee.suthikulpanit@amd.com>
 <53A94A46.1010801@arm.com>
In-Reply-To: <53A94A46.1010801@arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(51914003)(189002)(199002)(24454002)(479174003)(377454003)(164054003)(81542001)(46102001)(50986999)(19580395003)(64126003)(65806001)(77982001)(95666004)(102836001)(65816999)(59896001)(50466002)(64706001)(23746002)(79102001)(107046001)(92726001)(85852003)(47776003)(84676001)(20776003)(106466001)(92566001)(87936001)(83072002)(68736004)(4396001)(83506001)(81342001)(80022001)(36756003)(97736001)(105586002)(74662001)(101416001)(54356999)(76176999)(33656002)(44976005)(21056001)(85306003)(99396002)(86362001)(76482001)(74502001)(83322001)(65956001)(31966008)(87266999);DIR:OUT;SFP:;SCL:1;SRVR:BN3PR0201MB0914;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/2014 4:52 AM, Marc Zyngier wrote:
> Overall, this requires to be re-architected. If you want to have a look
> at the way I did the GICv3 ITS support:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
> gicv3/its
>
> Thanks,

Thanks for the review comments. I'll take a look at the GICv3 and 
re-architect for the V2 patch set.

Suravee

