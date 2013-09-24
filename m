Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3IXQCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:02:16 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:12074 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3IXQCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:02:13 -0400
Message-ID: <1380038410.14046.12.camel@misato.fc.hp.com>
Subject: Re: [PATCH 6/6] mem-hotplug: Introduce movablenode boot option
From: Toshi Kani <toshi.kani@hp.com>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
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
Date: Tue, 24 Sep 2013 10:00:10 -0600
In-Reply-To: <5241AEC0.6040505@gmail.com>
References: <524162DA.30004@cn.fujitsu.com>
	 <5241655E.1000007@cn.fujitsu.com> <20130924124121.GG2366@htj.dyndns.org>
	 <5241944B.4050103@gmail.com> <5241AEC0.6040505@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-24 at 23:24 +0800, Zhang Yanfei wrote:
> Hello tejun,
> 
> On 09/24/2013 09:31 PM, Zhang Yanfei wrote:
> >> This came up during earlier review but never was addressed.  Is
> >> > "movablenode" the right name?  Shouldn't it be something which
> >> > explicitly shows that it's to prepare for memory hotplug?  Also, maybe
> >> > the above param should generate warning if CONFIG_MOVABLE_NODE isn't
> >> > enabled?
> > hmmm...as for the option name, if this option is set, it means, the kernel
> > could support the functionality that a whole node is the so called
> > movable node, which only has ZONE MOVABLE zone in it. So we choose
> > to name the parameter "movablenode".
> > 
> > As for the warning, will add it.
> 
> I am now preparing the v5 version. Only in this patch we haven't come to an
> agreement. So as for the boot option name, after my explanation, do you still
> have the objection? Or you could suggest a good name for us, that'll be
> very thankful:)

I do not think the granularity has to stay as a node, and this option
does nothing to with other devices that may be included in a node.  So,
how about using "movablemem"?

Thanks,
-Toshi


