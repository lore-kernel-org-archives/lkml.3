Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbaEGJEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:04:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44050 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaEGJEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:04:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "arc-linux-dev\@synopsys.com" <arc-linux-dev@synopsys.com>
Subject: Re: ARC patches for stable 3.10
References: <C2D7FE5348E1B147BCA15975FBA230751B1242@IN01WEMBXA.internal.synopsys.com>
	<20140505120835.GB5869@hercules> <5369BB0A.9000503@synopsys.com>
Date: Wed, 07 May 2014 10:03:58 +0100
In-Reply-To: <5369BB0A.9000503@synopsys.com> (Vineet Gupta's message of "Wed,
	7 May 2014 10:18:10 +0530")
Message-ID: <87vbtiq7sx.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vineet Gupta <Vineet.Gupta1@synopsys.com> writes:

> Hi Luis,
>
> On Monday 05 May 2014 05:38 PM, Luis Henriques wrote:
>> On Wed, Apr 30, 2014 at 09:53:05AM +0000, Vineet Gupta wrote:
>>> Hi,
>>>
>>> Please apply the following mainline commits to stable 3.10 as prerequisites for a
>>> patch for 3.15/stable which will follow to Linus right after.
>>>
>>> 147aece29b15051173eb1e767018135361cdba89  (went in 3.11-rc1)
>>> "ARC: Entry Handler tweaks: Simplify branch for in-kernel preemption"
>>>
>>> fce16bc35ae4a45634f3dc348d8d297a25c277cf  (went in 3.12-rc1)
>>> "ARC: Entry Handler tweaks: Optimize away redundant IRQ_DISABLE_SAVE"
>>>
>>> Thx,
>>> -Vineet
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe stable" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> Thank you, I'll queue the 2nd patch for the 3.11 kernel (the 1st one
>> is already applied).
>> 
>> Cheers,
>> --
>> Luís
>
> Thanks for this. FWIW, above patch(es) were just a prerequisite for cleanly
> applying below to 3.1x
>
> 8aa9e85adac6 ARC: !PREEMPT: Ensure Return to kernel mode is IRQ safe
>
> Thx,
> -Vineet

Yes, I understood that and this patch will also be queued for the 3.11
kernel.  Thanks for clarifying.

Cheers,
-- 
Luís
