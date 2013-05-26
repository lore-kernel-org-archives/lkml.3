Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3EZNHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 09:07:15 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37561 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab3EZNHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 09:07:13 -0400
MIME-Version: 1.0
In-Reply-To: <51A203D4.6080001@gmail.com>
References: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1369547921-24264-3-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130526090054.GE10651@dhcp22.suse.cz> <CAHGf_=otK_LNgd6S09Fjjo0PfTSF3X0kj+=kGNyaTAze7m-b8w@mail.gmail.com>
 <51A203D4.6080001@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sun, 26 May 2013 09:06:51 -0400
Message-ID: <CAHGf_=pTEvunQ6fJQZ0MGwGmT31LryGmmfRUgC5T3AMzXQmx2w@mail.gmail.com>
Subject: Re: [patch v2 3/6] mm/memory_hotplug: Disable memory hotremove for 32bit
To: Hush Bensen <hush.bensen@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 8:45 AM, Hush Bensen <hush.bensen@gmail.com> wrote:
> 于 2013/5/26 19:58, KOSAKI Motohiro 写道:
>
>>>> As KOSAKI Motohiro mentioned, memory hotplug don't support 32bit since
>>>> it was born,
>>>
>>> Why? any reference? This reasoning is really weak.
>>
>> I have no seen any highmem support in memory hotplug code and I don't
>> think this
>> patch fixes all 32bit highmem issue. If anybody are interesting to
>> support it, it is good thing. But in fact, _now_ it is broken when
>> enable HIGHMEM.
>
>
> But online/offline memory can work well when enable HIGHMEM, isn't it?

If you are lucky.
