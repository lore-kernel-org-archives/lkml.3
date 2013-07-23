Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102Ab3GWTUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:20:19 -0400
Received: from mail-gh0-f179.google.com ([209.85.160.179]:50598 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933871Ab3GWTUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:20:16 -0400
Date: Tue, 23 Jul 2013 15:20:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, tglx@linutronix.de, mingo@elte.hu,
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
Subject: Re: [PATCH 01/21] acpi: Print Hot-Pluggable Field in SRAT.
Message-ID: <20130723192009.GL21100@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-2-git-send-email-tangchen@cn.fujitsu.com>
 <20130723184843.GG21100@mtj.dyndns.org>
 <1374606958.10171.2.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374606958.10171.2.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 12:15:58PM -0700, Joe Perches wrote:
> > The following would be more conventional.
> > 
> >   "...10Lx]%s\n", ..., hotpluggable ? " Hot Pluggable" : ""
> > 
> > Also, isn't "Hot Pluggable" a bit too verbose?  "hotplug" should be
> > fine, I think.
> 
> It's also a tiny nit better to use:
> 
> 	pr_info("SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]%s\n",
> 		node, pxm,
> 		(unsigned long long) start, (unsigned long long) end - 1,
> 		hotpluggable ? " Hot Pluggable" : "");
> 
> (or " hotplug")
> 
> so there's no space before newline.

Which was my first point which apparently wasn't clear enough. :)

Thanks.

-- 
tejun
