Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3KESA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:00:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab3KESAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:00:55 -0500
Date: Tue, 5 Nov 2013 19:01:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH] uprobes: introduce arch_uprobe->ixol
Message-ID: <20131105180110.GA6943@redhat.com>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-4-git-send-email-dave.long@linaro.org> <20131019163627.GA7837@redhat.com> <52671265.2020107@linaro.org> <20131029154006.GA22344@redhat.com> <20131104194901.GA28022@redhat.com> <527916F4.1010805@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527916F4.1010805@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05, David Long wrote:
>
> On 11/04/13 14:49, Oleg Nesterov wrote:
>> On 10/29, Oleg Nesterov wrote:
>>>
>> Seriouly, how about the patch below?
>>
>> In fact, given that you are going to reimplement set_swbp/orig_insn,
>> the new member is not strictly needed (afaics). But it looks more
>> clear this way, and we need s/MAX_UINSN_BYTES/sizeof()/ anyway.
>>
>> Oleg.
>> ---
>
> I agree that this is cleaner than another weak callout.  I have it
> working for ARM now.

OK, I am going to add this patch to my tree, thanks. Can I add your
acked-by ?

Oleg.

