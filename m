Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbaFDDRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 23:17:07 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48614 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbaFDDRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 23:17:05 -0400
Message-ID: <538E8FAA.7010302@hitachi.com>
Date: Wed, 04 Jun 2014 12:16:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] uprobes/x86: Rename arch_uprobe->def into ->dflt,
 minor comment updates
References: <20140601192520.GA14539@redhat.com> <20140603182142.GA5097@gmail.com> <20140603183057.GA31382@redhat.com> <20140603183919.GC7664@gmail.com> <20140603191315.GA32736@redhat.com>
In-Reply-To: <20140603191315.GA32736@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/04 4:13), Oleg Nesterov wrote:
> On 06/03, Ingo Molnar wrote:
>>
>> * Oleg Nesterov <oleg@redhat.com> wrote:
>>
>>> And this is how it was named when I wrote this code. Unfortunately gcc
>>> dislikes this name ;) So I renamed it to ->def. Then I was asked to
>>> rename it and I agree, ->def doesn't look good.
>>>
>>> Could you suggest something better?
>>
>> So exactly what do those fields do? If it's scratch register handling,
>> would it be logical to name it arch_uprobe->scratch, or so?
> 
> Not only, ->fixups encodes other flags. and ->ilen is used by UPROBE_FIX_CALL.
> 
> arch_uprobe->def contains the arguments for default_xol_ops methods, currently
> this handles everything except relative jmp/call insns.
> 
> So perhaps ->dflt is not that ugly in this case? I simply do not see anything
> better. But again, I agree with any name in advance.

Hmm, how about ->defparam ? :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


