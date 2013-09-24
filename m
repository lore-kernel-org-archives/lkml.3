Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3IXPoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:44:10 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42755 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3IXPoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:44:07 -0400
Message-ID: <5241B32E.3090803@gmail.com>
Date: Tue, 24 Sep 2013 23:43:42 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, Rik van Riel <riel@redhat.com>,
        jweiner@redhat.com, prarit@redhat.com,
        "x86@kernel.org" <x86@kernel.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        imtangchen@gmail.com
Subject: Re: [PATCH 6/6] mem-hotplug: Introduce movablenode boot option
References: <524162DA.30004@cn.fujitsu.com> <5241655E.1000007@cn.fujitsu.com> <20130924124121.GG2366@htj.dyndns.org> <5241944B.4050103@gmail.com> <5241AEC0.6040505@gmail.com> <20130924153259.GM2366@htj.dyndns.org>
In-Reply-To: <20130924153259.GM2366@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 11:32 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 24, 2013 at 11:24:48PM +0800, Zhang Yanfei wrote:
>> I am now preparing the v5 version. Only in this patch we haven't come to an
>> agreement. So as for the boot option name, after my explanation, do you still
>> have the objection? Or you could suggest a good name for us, that'll be
>> very thankful:)
> 
> No particular idea and my concern about the name isn't very strong.
> It just doesn't seem like a good name to me.  It's a bit obscure and
> we may want to do more things for hotplug later which may not fit the
> param name.  If you guys think it's good enough, please go ahead.
> 

Thanks very much!

I have addressed your comments and finish the v5 version. Please help
checking them again after I send them to the community. Thanks.

-- 
Thanks.
Zhang Yanfei
