Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3KESpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:45:19 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:35900 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab3KESpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:45:17 -0500
Message-ID: <52793CBB.5030808@linaro.org>
Date: Tue, 05 Nov 2013 13:45:15 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH] uprobes: introduce arch_uprobe->ixol
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-4-git-send-email-dave.long@linaro.org> <20131019163627.GA7837@redhat.com> <52671265.2020107@linaro.org> <20131029154006.GA22344@redhat.com> <20131104194901.GA28022@redhat.com> <527916F4.1010805@linaro.org> <20131105180110.GA6943@redhat.com>
In-Reply-To: <20131105180110.GA6943@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/13 13:01, Oleg Nesterov wrote:
> On 11/05, David Long wrote:
>>
>> On 11/04/13 14:49, Oleg Nesterov wrote:
>>> On 10/29, Oleg Nesterov wrote:
>>>>
>>> Seriouly, how about the patch below?
>>>
>>> In fact, given that you are going to reimplement set_swbp/orig_insn,
>>> the new member is not strictly needed (afaics). But it looks more
>>> clear this way, and we need s/MAX_UINSN_BYTES/sizeof()/ anyway.
>>>
>>> Oleg.
>>> ---
>>
>> I agree that this is cleaner than another weak callout.  I have it
>> working for ARM now.
>
> OK, I am going to add this patch to my tree, thanks. Can I add your
> acked-by ?
>
> Oleg.
>


yes.

-dl

