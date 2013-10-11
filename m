Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab3JKNDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:03:25 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754531Ab3JKNDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:03:24 -0400
Message-ID: <5257F710.5090706@nod.at>
Date: Fri, 11 Oct 2013 15:03:12 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        Chen Gang <gang.chen@asianux.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/arm64: remove atomic_clear_mask() in "include/asm/atomic.h"
References: <5256121A.9030504@asianux.com> <52561269.60900@asianux.com> <20131010100733.GH3817@mudshark.cambridge.arm.com> <52568998.2080108@asianux.com> <20131010142305.GG6199@mudshark.cambridge.arm.com> <525751E2.3020207@asianux.com> <20131011104419.GE14732@mudshark.cambridge.arm.com> <5257E033.3090607@asianux.com> <5257E539.9080902@asianux.com> <CAFLxGvwsx2YfNHiGtjWsANfVW74PT3KneLA-T6SpY4NEp_OSUA@mail.gmail.com> <20131011122846.GK14732@mudshark.cambridge.arm.com>
In-Reply-To: <20131011122846.GK14732@mudshark.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.10.2013 14:28, schrieb Will Deacon:
> On Fri, Oct 11, 2013 at 01:08:17PM +0100, Richard Weinberger wrote:
>> On Fri, Oct 11, 2013 at 1:47 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>> In current kernel wide source code, except other architectures, only
>>> s390 scsi drivers use atomic_clear_mask(), and arm/arm64 need not
>>> support s390 drivers.
>>>
>>> So remove atomic_clear_mask() from "arm[64]/include/asm/atomic.h".
>>
>> Is it really worth removing such a primitive?
>> If someone needs it later he has to implement it from scratch and
>> introduces bugs...
> 
> The version we have (on ARM64 anyway) already has bugs. Given the choice
> between fixing code that has no callers and simply removing it, I'd go for
> the latter.

Yeah, if it's broken and has no real users, send it to hell. :)

Thanks,
//richard

