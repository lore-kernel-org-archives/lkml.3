Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114Ab3GWTTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:19:19 -0400
Received: from mail-ye0-f179.google.com ([209.85.213.179]:42963 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933944Ab3GWTTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:19:12 -0400
Date: Tue, 23 Jul 2013 15:19:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
Subject: Re: [PATCH 03/21] x86, acpi, numa, mem-hotplug: Introduce
 MEMBLK_HOTPLUGGABLE to reserve hotpluggable memory.
Message-ID: <20130723191904.GK21100@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-4-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374220774-29974-4-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 03:59:16PM +0800, Tang Chen wrote:
>  /* Definition of memblock flags. */
>  #define MEMBLK_FLAGS_DEFAULT	0x0	/* default flag */
> +#define MEMBLK_HOTPLUGGABLE	0x1	/* hotpluggable region */

Given that all existing APIs are using "memblock", wouldn't it be
better to use "MEMBLOCK_" prefix?  If it's too long, we can just do
MEMBLOCK_HOTPLUG.

Thanks.

-- 
tejun
