Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab3DLCXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 22:23:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49631 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab3DLCXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 22:23:17 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQUR7aBP3SURDG610qLOo-4nveGe+39mxDWOhe_0GJqH+A@mail.gmail.com>
References: <4b78b961-eb82-4f32-aa09-345c1c1d39c5@default> <CAE9FiQUR7aBP3SURDG610qLOo-4nveGe+39mxDWOhe_0GJqH+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 21/22] x86, mm: Make init_mem_mapping be able to be called several times
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 11 Apr 2013 19:20:33 -0700
To: Yinghai Lu <yinghai@kernel.org>, Konrad Wilk <konrad.wilk@oracle.com>
CC: Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <b3c007ab-d52e-486c-b1f7-0fe9f8a85241@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please send a replacement patch.

Yinghai Lu <yinghai@kernel.org> wrote:

>On Thu, Apr 11, 2013 at 6:05 PM, Konrad Wilk <konrad.wilk@oracle.com>
>wrote:
>>
>> ----- yinghai@kernel.org wrote:
>>
>>> Prepare to put page table on local nodes.
>>>
>>> Move calling of init_mem_mapping to early_initmem_init.
>>>
>>> Rework alloc_low_pages to alloc page table in following order:
>>>       BRK, local node, low range
>>>
>>> Still only load_cr3 one time, otherwise we would break xen 64bit
>>> again.
>>
>> I have asked you in the previous iteration of the patch to fix that
>comment.
>
>Maybe it is not clear enough.
>
>>
>> Please remove it - as it is misleading. The issue with load_cr3 more
>than
>> once has been fixed under the Xen platform.
>
>Peter, can you remove those two lines?
>or need to resend -v5?
>
>Thanks
>
>Yinghai

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
