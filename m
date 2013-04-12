Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3DLCET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 22:04:19 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:53638 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3DLCES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 22:04:18 -0400
MIME-Version: 1.0
In-Reply-To: <4b78b961-eb82-4f32-aa09-345c1c1d39c5@default>
References: <4b78b961-eb82-4f32-aa09-345c1c1d39c5@default>
Date: Thu, 11 Apr 2013 19:04:17 -0700
X-Google-Sender-Auth: u9oeOJidSepEaDoNXo9_ypQOj9Y
Message-ID: <CAE9FiQUR7aBP3SURDG610qLOo-4nveGe+39mxDWOhe_0GJqH+A@mail.gmail.com>
Subject: Re: [PATCH v4 21/22] x86, mm: Make init_mem_mapping be able to be
 called several times
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Wilk <konrad.wilk@oracle.com>
Cc: Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 6:05 PM, Konrad Wilk <konrad.wilk@oracle.com> wrote:
>
> ----- yinghai@kernel.org wrote:
>
>> Prepare to put page table on local nodes.
>>
>> Move calling of init_mem_mapping to early_initmem_init.
>>
>> Rework alloc_low_pages to alloc page table in following order:
>>       BRK, local node, low range
>>
>> Still only load_cr3 one time, otherwise we would break xen 64bit
>> again.
>
> I have asked you in the previous iteration of the patch to fix that comment.

Maybe it is not clear enough.

>
> Please remove it - as it is misleading. The issue with load_cr3 more than
> once has been fixed under the Xen platform.

Peter, can you remove those two lines?
or need to resend -v5?

Thanks

Yinghai
