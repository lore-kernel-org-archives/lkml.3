Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3H1PTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:19:18 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:34393 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3H1PTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:19:14 -0400
Date: Wed, 28 Aug 2013 11:19:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/11] x86, memblock: Allocate memory near kernel image
 before SRAT parsed.
Message-ID: <20130828151909.GE9295@htj.dyndns.org>
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 05:37:37PM +0800, Tang Chen wrote:
> Tang Chen (11):
>   memblock: Rename current_limit to current_limit_high in memblock.
>   memblock: Rename memblock_set_current_limit() to
>     memblock_set_current_limit_high().
>   memblock: Introduce lowest limit in memblock.
>   memblock: Introduce memblock_set_current_limit_low() to set lower
>     limit of memblock.
>   memblock: Introduce allocation order to memblock.
>   memblock: Improve memblock to support allocation from lower address.
>   x86, memblock: Set lowest limit for memblock_alloc_base_nid().
>   x86, acpi, memblock: Use __memblock_alloc_base() in
>     acpi_initrd_override()
>   mem-hotplug: Introduce movablenode boot option to {en|dis}able using
>     SRAT.
>   x86, mem-hotplug: Support initialize page tables from low to high.
>   x86, mem_hotplug: Allocate memory near kernel image before SRAT is
>     parsed.

Doesn't apply to -master, -next or tip.  Again, can you please include
which tree and git commit the patches are against in the patch
description?  How is one supposed to know on top of which tree you're
working?  It is in your benefit to make things easier for the prosepct
reviewers.  Trying to guess and apply the patches to different devel
branches and failing isn't productive and frustates your prospect
reviewers who would of course have negative pre-perception going into
the review and this isn't the first time this issue was raised either.

-- 
tejun
