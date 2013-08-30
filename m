Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab3H3GPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 02:15:39 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:50340 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3H3GPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 02:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130830061413.GA29949@gmail.com>
References: <1377841673-17361-1-git-send-email-bob.liu@oracle.com>
	<20130830061413.GA29949@gmail.com>
Date: Fri, 30 Aug 2013 14:15:36 +0800
Message-ID: <CAA_GA1ea84CvnvzisbhCXmNw+tv9ZQc1drgr8VkER-cpE2G1aQ@mail.gmail.com>
Subject: Re: [PATCH] x86: e820: fix memmap kernel boot parameter
From: Bob Liu <lliubbo@gmail.com>
To: Dan Aloni <alonid@stratoscale.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hpa@linux.intel.com,
        Yinghai Lu <yinghai@kernel.org>, jacob.shin@amd.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux-MM <linux-mm@kvack.org>, Bob Liu <bob.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 2:14 PM, Dan Aloni <alonid@stratoscale.com> wrote:
> On Fri, Aug 30, 2013 at 01:47:53PM +0800, Bob Liu wrote:
>>[..]
>> Machine2: bootcmdline in grub.cfg "memmap=0x77ffffff$0x880000000", the result of
>> "cat /proc/cmdline" changed to "memmap=0x77ffffffx880000000".
>>
>> I didn't find the root cause, I think maybe grub reserved "$0" as something
>> special.
>> Replace '$' with '%' in kernel boot parameter can fix this issue.
>
> You are correct with the root cause, however I don't think the patch is needed.
>
> In order to bypass grub's variable evaluation you can simply use escaping
> and replace $ with \$ in your grub config.
>

I see, thank you very much!

-- 
Regards,
--Bob
