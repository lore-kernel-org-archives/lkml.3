Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799Ab3GEDYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 23:24:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63084 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932143Ab3GEDYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 23:24:20 -0400
X-IronPort-AV: E=Sophos;i="4.87,999,1363104000"; 
   d="scan'208";a="7788779"
Message-ID: <51D63B9C.4060204@cn.fujitsu.com>
Date: Fri, 05 Jul 2013 11:21:00 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, zab@redhat.com,
        jmoyer@redhat.com, linux-mm@kvack.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [WiP]: aio support for migrating pages (Re: [PATCH V2 1/2] mm:
 hotplug: implement non-movable version of get_user_pages() called get_user_pages_non_movable())
References: <20130517002349.GI1008@kvack.org> <5195A3F4.70803@cn.fujitsu.com> <20130517143718.GK1008@kvack.org> <519AD6F8.2070504@cn.fujitsu.com> <20130521022733.GT1008@kvack.org> <51B6F107.80501@cn.fujitsu.com> <20130611144525.GB14404@kvack.org> <51D12E7B.6080301@cn.fujitsu.com> <20130702180008.GQ16399@kvack.org> <51D51B66.3000301@cn.fujitsu.com> <20130704114153.GD11006@kvack.org>
In-Reply-To: <20130704114153.GD11006@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/05 11:22:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/05 11:22:47,
	Serialize complete at 2013/07/05 11:22:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 07:41 PM, Benjamin LaHaise wrote:

> On Thu, Jul 04, 2013 at 02:51:18PM +0800, Gu Zheng wrote:
>> Hi Ben,
>>       When I test your patch on kernel 3.10, the kernel panic when aio job
>> complete or exit, exactly in aio_free_ring(), the following is a part of dmesg.
> 
> What is your test case?

Just the one you mentioned in the previous mail:
 http://www.kvack.org/~bcrl/aio/aio-numa-test.c

Thanks,
Gu

> 
> 		-ben
> 


