Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaENBXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 21:23:40 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:43906 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612AbaENBXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 21:23:38 -0400
X-IronPort-AV: E=Sophos;i="4.97,1048,1389715200"; 
   d="scan'208";a="30487425"
Message-ID: <5372C32B.8050906@cn.fujitsu.com>
Date: Wed, 14 May 2014 09:13:15 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <viro@zeniv.linux.org.uk>, <bcrl@kvack.org>,
        <jmoyer@redhat.com>, <kosaki.motohiro@gmail.com>,
        <kosaki.motohiro@jp.fujitsu.com>, <isimatu.yasuaki@jp.fujitsu.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
        <linux-kernel@vger.kernel.org>, <miaox@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>
Subject: Re: [RESEND v2 PATCH 0/2] Bug fix in aio ring page migration
References: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com> <53217E46.3060100@cn.fujitsu.com> <20140513235840.GD29623@kroah.com>
In-Reply-To: <20140513235840.GD29623@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
Thanks for your attention on this thread.
On 05/14/2014 07:58 AM, Greg Kroah-Hartman wrote:

> On Thu, Mar 13, 2014 at 05:45:42PM +0800, Gu Zheng wrote:
>> This patchset has been applied to linux-next, and these problems also exist
>> in 3.12.y and 3.13.y stable tree.
>> So please merge this patchset to 3.12.y and 3.13.y stable tree.
>>
>> commit 692c9b8c5ee8d263bb8348171f0bebd3d84eb2c1
>> Author: Tang Chen <tangchen@cn.fujitsu.com>
>> Date:   Mon Mar 10 16:15:33 2014 +0800
>>
>>     aio, memory-hotplug: Fix confliction when migrating and accessing ring pages.
>>
>> commit e0f5e0add36d2e3c456cf2f4283673ed834b3c24
>> Author: Tang Chen <tangchen@cn.fujitsu.com>
>> Date:   Mon Mar 10 16:15:34 2014 +0800
>>
>>     aio, mem-hotplug: Add memory barrier to aio ring page migration.
>>
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/fs/aio.c?id=692c9b8c5ee8d263bb8348171f0bebd3d84eb2c1
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/fs/aio.c?id=e0f5e0add36d2e3c456cf2f4283673ed834b3c24
>>
>> https://lkml.org/lkml/2014/3/10/56
>> https://lkml.org/lkml/2014/3/10/58
> 
> I don't see these in Linus's tree, what happened?

These two patches were replaced by the better one from Benjamin, and it has been
merged into upstream.
commit fa8a53c39f3fdde98c9eace6a9b412143f0f6ed6
Author: Benjamin LaHaise <bcrl@kvack.org>
Date:   Fri Mar 28 10:14:45 2014 -0400

    aio: v4 ensure access to ctx->ring_pages is correctly serialised for migration
And I have already received the notify that it has been applied into stable tree.

Best regards,
Gu

> 
> thanks,
> 
> greg k-h
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
> .
> 


