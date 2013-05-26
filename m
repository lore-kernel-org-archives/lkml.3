Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab3EZMpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 08:45:18 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42339 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3EZMpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 08:45:16 -0400
Message-ID: <51A203D4.6080001@gmail.com>
Date: Sun, 26 May 2013 20:45:08 +0800
From: Hush Bensen <hush.bensen@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:21.0) Gecko/20100101 Thunderbird/21.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Michal Hocko <mhocko@suse.cz>
CC: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [patch v2 3/6] mm/memory_hotplug: Disable memory hotremove for
 32bit
References: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com> <1369547921-24264-3-git-send-email-liwanp@linux.vnet.ibm.com> <20130526090054.GE10651@dhcp22.suse.cz> <CAHGf_=otK_LNgd6S09Fjjo0PfTSF3X0kj+=kGNyaTAze7m-b8w@mail.gmail.com>
In-Reply-To: <CAHGf_=otK_LNgd6S09Fjjo0PfTSF3X0kj+=kGNyaTAze7m-b8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/5/26 19:58, KOSAKI Motohiro 写道:
>>> As KOSAKI Motohiro mentioned, memory hotplug don't support 32bit since
>>> it was born,
>> Why? any reference? This reasoning is really weak.
> I have no seen any highmem support in memory hotplug code and I don't think this
> patch fixes all 32bit highmem issue. If anybody are interesting to
> support it, it is good thing. But in fact, _now_ it is broken when
> enable HIGHMEM.

But online/offline memory can work well when enable HIGHMEM, isn't it?

> So, I just want to mark broken until someone want to support highmem
> and verify overall.
>
> And, yes, this patch is no good. Kconfig doesn't describe why disable
> when highmem.
> So,
>
> depends on 64BIT || !HIGHMEM || BROKEN
>
> maybe clear documentation more.
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

