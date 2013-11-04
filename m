Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3KDVZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 16:25:48 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:61694 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3KDVZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 16:25:47 -0500
Message-ID: <527810D4.2060109@linaro.org>
Date: Mon, 04 Nov 2013 16:25:40 -0500
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
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-4-git-send-email-dave.long@linaro.org> <20131019163627.GA7837@redhat.com> <52671265.2020107@linaro.org> <20131029154006.GA22344@redhat.com> <20131104194901.GA28022@redhat.com>
In-Reply-To: <20131104194901.GA28022@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/13 14:49, Oleg Nesterov wrote:
> On 10/29, Oleg Nesterov wrote:
>>
>> David. Perhaps we can avoid the new hook altogether? What if we do
>> the simple change below (it ignores powerpc) ?
>>
>> Then arm can add "unsigned long ixol[2]" into its arch_uprobe, and
>> arch_uprobe_analyze_insn() can initialize this member correctly.
>>
>> What do you think?
>
> Seriouly, how about the patch below?
>
> In fact, given that you are going to reimplement set_swbp/orig_insn,
> the new member is not strictly needed (afaics). But it looks more
> clear this way, and we need s/MAX_UINSN_BYTES/sizeof()/ anyway.
>
> Oleg.
>


Sorry for the delay, have not quite been successful in getting this to 
work yet.  Hopefully will have better results shortly.

-dl

