Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaA2Bkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 20:40:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42391 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbaA2Bkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 20:40:45 -0500
X-IronPort-AV: E=Sophos;i="4.95,739,1384272000"; 
   d="scan'208";a="9462846"
Message-ID: <52E85A3B.9050703@cn.fujitsu.com>
Date: Wed, 29 Jan 2014 09:32:43 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: David Rientjes <rientjes@google.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Andrew Morton <akpm@linux-foundation.org>, zhangyanfei@cn.fujitsu.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] numa, mem-hotplug: Initialize numa_kernel_nodes in
 numa_clear_kernel_node_hotplug().
References: <1390899916-23566-1-git-send-email-tangchen@cn.fujitsu.com> <1390899916-23566-2-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.02.1401280109360.4244@chino.kir.corp.google.com> <20140128114826.GA26103@gmail.com>
In-Reply-To: <20140128114826.GA26103@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/29 09:39:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/29 09:39:05,
	Serialize complete at 2014/01/29 09:39:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
On 01/28/2014 07:48 PM, Ingo Molnar wrote:

> 
> * David Rientjes <rientjes@google.com> wrote:
> 
>> On Tue, 28 Jan 2014, Tang Chen wrote:
>>
>>> On-stack variable numa_kernel_nodes in numa_clear_kernel_node_hotplug()
>>> was not initialized. So we need to initialize it.
>>>
>>> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
>>> Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>>
>> Reported-by: David Rientjes <rientjes@google.com>
> 
> Agreed. Tang Chen, please also spell it out in the changelog:
> 
>    David Rientjes reported a boot crash, caused by
>    commit XYZ ("foo: bar").
> 
> I find it somewhat annoying that you found time to credit a corporate 
> collegue with a Tested-by tag, who didn't even reply to the whole 
> thread to indicate his testing efforts,

Sorry for missing to indicate the test result, because I am really busy with
some thorny issues. If Tang did not remind me, maybe I'll miss the whole thread.
But I think the "Tested-by:" is the best confirmation of the testing efforts,
it indicates that the guy has nearly completely tested the patch on his environment.

Thanks,
Gu

> but you didn't find the time 
> to credit the original reporter of the bug who also reviewed your 
> patches ...
> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


