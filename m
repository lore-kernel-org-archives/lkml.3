Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3HEOwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:52:22 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:55908 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab3HEOwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:52:19 -0400
Date: Mon, 5 Aug 2013 10:52:12 -0400
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
Subject: Re: [PATCH v2 RESEND 13/18] x86, numa, mem_hotplug: Skip all the
 regions the kernel resides in.
Message-ID: <20130805145212.GA19631@mtj.dyndns.org>
References: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com>
 <1375434877-20704-14-git-send-email-tangchen@cn.fujitsu.com>
 <51FF44B7.8050704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FF44B7.8050704@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 02:22:47PM +0800, Tang Chen wrote:
> I have resent the v2 patch-set. Would you please give some more
> comments about the memblock and x86 booting code modification ?

Patch 13 still seems corrupt.  Is it a problem on my side maybe?
Nope, gmane raw message is corrupt too.

 http://article.gmane.org/gmane.linux.kernel.mm/104549/raw

Can you please verify your mail setup?  It's not very nice to repeat
the same problem.

-- 
tejun
