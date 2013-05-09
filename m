Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3EISYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:24:40 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41055 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3EISYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:24:38 -0400
MIME-Version: 1.0
In-Reply-To: <518B645C.10408@cn.fujitsu.com>
References: <1365728168-32067-1-git-send-email-yinghai@kernel.org>
	<517F7110.6000705@cn.fujitsu.com>
	<518B645C.10408@cn.fujitsu.com>
Date: Thu, 9 May 2013 11:24:38 -0700
X-Google-Sender-Auth: XWE6d6EzOeod97fdl0yTBpbpFmw
Message-ID: <CAE9FiQWPFL0qagAmkcyj_XfjWQtONtomwQPAimKUm+nJi5dHTw@mail.gmail.com>
Subject: Re: [PATCH v4 00/22] x86, ACPI, numa: Parse numa info early
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 1:54 AM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> Hi Yinghai,
>
>
> On 04/30/2013 03:21 PM, Tang Chen wrote:
>>
>> So I suggest to separate the job into 2 parts:
>> 1. Push Yinghai's patch1 ~ patch20, without putting pagetable in local
>> node.
>> And push my work to use SRAT to arrange ZONE_MOVABLE.
>> In this case, we can enable memory hotplug in the kernel first.
>> 2. Merge patch21 and patch22 into the fixing work I am doing now, and push
>> them
>> together when finished.
>>
>
> It has been a long time since this mail and there was no response. I do
> think I
> should move on to push this patch-set. So if you don't mind, I'll rebase and
> push "parse SRAT earlier" part of this patch-set first.
>
> Since putting pagetable in local node will destroy memory hot-remove logic
> for now,
> I will drop "put pagetable in local node" parts now, and merge this part
> into
> the hot-add and hot-remove fix work.

no, no, no, please do not half-done work.

Do it right, and Do it clean.

>
> If you have any thinking of this patch-set, please let me know.

Talked to HPA, and he will put my patchset into tip/x86/mm after v3.10-rc1.

after that we can work on put pagetable on local node for hotadd path.

Thanks

Yinghai
