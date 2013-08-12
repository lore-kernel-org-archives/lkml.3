Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab3HLOP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:15:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42539 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab3HLOP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:15:56 -0400
Date: Mon, 12 Aug 2013 10:15:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH part2 1/4] acpi: Print Hot-Pluggable Field in SRAT.
Message-ID: <20130812141551.GD15892@htj.dyndns.org>
References: <1375938239-18769-1-git-send-email-tangchen@cn.fujitsu.com>
 <1375938239-18769-2-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375938239-18769-2-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 01:03:56PM +0800, Tang Chen wrote:
> +	pr_info("SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]%s\n",
> +		node, pxm,
> +		(unsigned long long) start, (unsigned long long) end - 1,
> +		hotpluggable ? " Hot Pluggable" : "");

Wouldn't it be better to just print "hotplug"?

Thanks.

-- 
tejun
