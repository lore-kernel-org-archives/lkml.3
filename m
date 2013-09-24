Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3IXCrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 22:47:01 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:51573 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3IXCq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 22:46:59 -0400
Date: Mon, 23 Sep 2013 22:46:54 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, toshi.kani@hp.com,
        liwanp@linux.vnet.ibm.com, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 2/5] memblock: Improve memblock to support allocation
 from lower address.
Message-ID: <20130924024654.GE3482@htj.dyndns.org>
References: <1379064655-20874-1-git-send-email-tangchen@cn.fujitsu.com>
 <1379064655-20874-3-git-send-email-tangchen@cn.fujitsu.com>
 <20130923155027.GD14547@htj.dyndns.org>
 <52408351.8080400@gmail.com>
 <20130923202147.GB28667@mtj.dyndns.org>
 <5240FBEF.10102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5240FBEF.10102@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 24, 2013 at 10:41:51AM +0800, Zhang Yanfei wrote:
> I see. But I think memblock_set_alloc_above_kernel may lose the info
> that we are doing bottom-up allocation. So my idea is we introduce
> pure bottom-up allocation mode in previous patches and we use the
> bottom-up allocation here and limit the start address above the kernel
> , with explicit comments to indicate this.

It probably doesn't matter either way.  I was just a bit bothered that
it's called bottom-up when it implies more including the retry logic.
Its use of bottom-up allocation is really an implementation logic to
achieve the goal of allocating memory above kernel image after all,
but yeah minor point either way.

Thanks.

-- 
tejun
