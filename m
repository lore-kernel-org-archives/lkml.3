Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301Ab3GWVLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:11:30 -0400
Received: from mail-gg0-f175.google.com ([209.85.161.175]:35585 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934239Ab3GWVL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:11:26 -0400
Date: Tue, 23 Jul 2013 17:11:19 -0400
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
Subject: Re: [PATCH 17/21] page_alloc, mem-hotplug: Improve movablecore to
 {en|dis}able using SRAT.
Message-ID: <20130723211119.GW21100@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-18-git-send-email-tangchen@cn.fujitsu.com>
 <20130723210435.GV21100@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723210435.GV21100@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 05:04:35PM -0400, Tejun Heo wrote:
> On Fri, Jul 19, 2013 at 03:59:30PM +0800, Tang Chen wrote:
> ...
> > Users can specify "movablecore=acpi" in kernel commandline to enable this
> > functionality. For those who don't use memory hotplug or who don't want
> > to lose their NUMA performance, just don't specify anything. The kernel
> > will work as before.
> 
> The param name is pretty obscure and why would the user care where

I mean, having movable zone is required for having any decent chance
of memory hotplug and movable zone implies worse affinity for kernel
data structures, so there's no point in distinguishing memory hotplug
enable/disable and this, right?

-- 
tejun
