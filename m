Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3IZQIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:08:49 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:54580 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3IZQIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:08:47 -0400
Date: Thu, 26 Sep 2013 12:08:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
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
        imtangchen@gmail.com, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 4/6] x86/mem-hotplug: Support initialize page tables
 in bottom-up
Message-ID: <20130926160842.GC32391@mtj.dyndns.org>
References: <5241D897.1090905@gmail.com>
 <5241DA5B.8000909@gmail.com>
 <20130926144851.GF3482@htj.dyndns.org>
 <52445606.7030108@gmail.com>
 <20130926154813.GA32391@mtj.dyndns.org>
 <52445AB5.8030306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52445AB5.8030306@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 12:03:01AM +0800, Zhang Yanfei wrote:
> Ah, I see. You are saying another issue. He is worrying that if we use
> kexec to load the kernel high, say we have 16GB, we put the kernel in
> 15.99GB (just an example), so we only have less than 100MB above the kernel.
> 
> But as I've explained to him, in almost all the cases, if we want our
> memory hotplug work, we don't do that. And yeah, assume we have this
> problem, it'd fall back to top down and that return backs to patch 2,
> we will trigger the WARN_ONCE, and the admin will know what has happened.

Alright,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
