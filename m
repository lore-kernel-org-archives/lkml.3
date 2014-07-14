Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbaGNUlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:41:18 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:57019
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756559AbaGNUlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:41:15 -0400
X-WSS-ID: 0N8PYS9-07-2BW-02
X-M-MSG: 
Message-ID: <53C43FE3.1050008@amd.com>
Date: Mon, 14 Jul 2014 15:38:59 -0500
From: Joel Schopp <joel.schopp@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Timur Tabi <timur@codeaurora.org>, Jungseok Lee <jungseoklee85@gmail.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, <steve.capper@linaro.org>,
        "Arnd Bergmann" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        <Catalin.Marinas@arm.com>, lkml <linux-kernel@vger.kernel.org>,
        <ilho215.lee@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <barami97@gmail.com>, <kvmarm@lists.cs.columbia.edu>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 2/7] arm64: Introduce VA_BITS and translation level
 options
References: <000101cf6dc6$3b93d510$b2bb7f30$@samsung.com>
 <CAOZdJXWCu-zHuQoAUdiieqsKqCfG9BsZariFqQP=NCgQP-zpNA@mail.gmail.com>
In-Reply-To: <CAOZdJXWCu-zHuQoAUdiieqsKqCfG9BsZariFqQP=NCgQP-zpNA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(24454002)(377454003)(479174003)(189002)(199002)(19580405001)(19580395003)(79102001)(68736004)(47776003)(20776003)(80316001)(86362001)(23756003)(31966008)(84676001)(33656002)(83322001)(50986999)(99396002)(83072002)(77096002)(97736001)(15202345003)(64706001)(65956001)(74502001)(4396001)(76482001)(77982001)(46102001)(15975445006)(80022001)(59896001)(74662001)(83506001)(53416004)(21056001)(102836001)(101416001)(107046002)(81542001)(81342001)(50466002)(54356999)(105586002)(95666004)(85306003)(85852003)(92566001)(76176999)(92726001)(36756003)(65816999)(87266999)(87936001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB039;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Joel.Schopp@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree that these patches would be very useful.  I just rebased my fix
for a VTTBR_BADDR_MASK bug on one of these patches that could be pulled
out independently.  See
https://lists.cs.columbia.edu/pipermail/kvmarm/2014-July/010480.html

The original author Jungseok Lee is no longer available to work on
future versions of these patches.  I was thinking that if they didn't
get picked up as they are that with the original author's blessing I
would pick them up and keep them forward ported/resubmitted.  I have an
SOC to test them on.

-Joel

On 07/14/2014 02:53 PM, Timur Tabi wrote:
> On Mon, May 12, 2014 at 4:40 AM, Jungseok Lee <jays.lee@samsung.com> wrote:
>> This patch adds virtual address space size and a level of translation
>> tables to kernel configuration. It facilicates introduction of
>> different MMU options, such as 4KB + 4 levels, 16KB + 4 levels and
>> 64KB + 3 levels, easily.
> Is there a reason why this patch has not yet been picked up?  It
> appears to work just fine, and the change is necessary for ARM SOCs
> that support large amounts of memory.  It seems weird that after so
> many versions, reviews, and ACKs, that it still not in linux-next.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

