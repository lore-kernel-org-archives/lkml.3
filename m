Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3IXMee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:34:34 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:62526 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3IXMec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:34:32 -0400
Date: Tue, 24 Sep 2013 08:34:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
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
        imtangchen@gmail.com, Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: Re: [PATCH 5/6] x86, acpi, crash, kdump: Do reserve_crashkernel()
 after SRAT is parsed.
Message-ID: <20130924123428.GF2366@htj.dyndns.org>
References: <524162DA.30004@cn.fujitsu.com>
 <524164ED.3060201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524164ED.3060201@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 06:09:49PM +0800, Zhang Yanfei wrote:
> From: Tang Chen <tangchen@cn.fujitsu.com>
> 
> Memory reserved for crashkernel could be large. So we should not allocate
> this memory bottom up from the end of kernel image.
> 
> When SRAT is parsed, we will be able to know whihc memory is hotpluggable,
> and we can avoid allocating this memory for the kernel. So reorder
> reserve_crashkernel() after SRAT is parsed.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Assuming this was tested to work.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
