Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab3H2UGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:06:50 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:48100 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208Ab3H2UGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:06:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130829200746.GA13366@kroah.com>
References: <alpine.SOC.1.00.1307310017380.19288@math.ut.ee>
	<alpine.SOC.1.00.1308191158220.19642@math.ut.ee>
	<alpine.SOC.1.00.1308291017030.2723@math.ut.ee>
	<20130829092935.GB2235@swordfish>
	<alpine.SOC.1.00.1308291250350.2723@math.ut.ee>
	<CADnq5_OPQD68o80ZGZODOxR3V2M7dU1xEYEhqjDKPcqgGwWYeQ@mail.gmail.com>
	<20130829200746.GA13366@kroah.com>
Date: Thu, 29 Aug 2013 16:06:48 -0400
Message-ID: <CADnq5_PO18Vyphw_75EUxJHYpEcTjpo6BaYE6qt6_az-nWEoxA@mail.gmail.com>
Subject: Re: [PATCH] radeon kms: fix uninitialised hotplug work usage in r100_irq_process()
From: Alex Deucher <alexdeucher@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Meelis Roos <mroos@linux.ee>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 4:07 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Aug 29, 2013 at 02:27:52PM -0400, Alex Deucher wrote:
>> On Thu, Aug 29, 2013 at 6:55 AM, Meelis Roos <mroos@linux.ee> wrote:
>> >> Reported-by: Meelis Roos <mroos@linux.ee>
>> >> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>> >
>> > It works, thank you for quick response!
>> >
>> > Tested-by: Meelis Roos <mroos@linux.ee>
>>
>> Thanks.  I've added it to my patch queue.
>
> Can you add a cc: stable mark if it also is going to affect the stable
> kernels as well?
>

Yes, already done.

Alex

> thanks,
>
> greg k-h
