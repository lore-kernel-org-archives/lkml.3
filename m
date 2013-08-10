Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934522Ab3HJQJl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:09:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32967 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934374Ab3HJQJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:09:36 -0400
Message-ID: <5206659F.9070705@zytor.com>
Date: Sat, 10 Aug 2013 09:09:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>  <5205C4BB.6020003@zytor.com> <1376114128.5332.17.camel@marge.simpson.net>
In-Reply-To: <1376114128.5332.17.camel@marge.simpson.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 10:55 PM, Mike Galbraith wrote:
>>
>> Now, here is a bigger question: shouldn't we be deprecating/getting rid
>> of PREEMPT_VOUNTARY in favor of PREEMPT?
> 
> I sure hope not, PREEMPT munches throughput.  If you need PREEMPT, seems
> to me what you _really_ need is PREEMPT_RT (the real deal), so
> eventually depreciating PREEMPT makes more sense to me.
> 

Do you have any quantification of "munches throughput?"  It seems odd
that it would be worse than polling for preempt all over the kernel, but
perhaps the additional locking is what costs.

	-hpa


