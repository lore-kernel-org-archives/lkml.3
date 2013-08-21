Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab3HUNGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:06:54 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:53490 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3HUNGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:06:52 -0400
Date: Wed, 21 Aug 2013 09:06:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: konrad.wilk@oracle.com, robert.moore@intel.com, lv.zheng@intel.com,
        rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/8] x86, acpi: Move acpi_initrd_override() earlier.
Message-ID: <20130821130647.GB19286@mtj.dyndns.org>
References: <1377080143-28455-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377080143-28455-1-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 21, 2013 at 06:15:35PM +0800, Tang Chen wrote:
> [What are we doing]
> 
> We are trying to initialize acip tables as early as possible. But Linux kernel
> allows users to override acpi tables by specifying their own tables in initrd.
> So we have to do acpi_initrd_override() earlier first.

So, are we now back to making SRAT info as early as possible?  What
happened to just co-locating early allocations close to kernel image?
What'd be the benefit of doing this over that?

Thanks.

-- 
tejun
