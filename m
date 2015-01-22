Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbbAVTSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:18:36 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41215 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbbAVTSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:18:34 -0500
Message-ID: <54C14D01.2010506@arm.com>
Date: Thu, 22 Jan 2015 19:18:25 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Mario Smarduch <m.smarduch@samsung.com>, Paul Bolle <pebolle@tiscali.nl>
CC: Valentin Rothberg <valentinrothberg@gmail.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: KVM: CONFIG_LOCK_DEP and CONFIG_LOCK_DETECTOR?
References: <1421919245.13638.50.camel@x220> <54C14BCF.1050902@samsung.com>
In-Reply-To: <54C14BCF.1050902@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/15 19:13, Mario Smarduch wrote:
> On 01/22/2015 01:34 AM, Paul Bolle wrote:
>> Mario,
>>
>> Your commit c64735554c0a ("KVM: arm: Add initial dirty page locking
>> support") is included in today's linux-next (ie, next-20150122). I
>> noticed because a script I use to check linux-next spotted a minor
>> problem with it.
>>
>> This commit added a comment that mentions CONFIG_LOCK_DEP and
>> CONFIG_LOCK_DETECTOR. It seems CONFIG_LOCKDEP and CONFIG_LOCKUP_DETECTOR
>> should be used instead. Is a trivial patch to fix these typos queued
>> somewhere?
>>
>> Thanks,
>>
>>
>> Paul Bolle
>>
> 
> Hi Paul,
>   thanks for spotting that. No there is no trivial patch
> queued, didn't notice it until now. Can I submit a follow
> up trivial patch later?

Yeah, that can definitely wait. I think we have slightly bigger fish to
fry for now... ;-)

If someone sends us a patch once -rc1 is out, we'll queue it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
