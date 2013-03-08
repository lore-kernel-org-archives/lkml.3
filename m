Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3CHGET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:04:19 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:44268 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab3CHGEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:04:16 -0500
Date: Thu, 7 Mar 2013 22:04:10 -0800
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] x86, mm, numa: Move successful path handling code
 later
Message-ID: <20130308060410.GH14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
 <1362718720-27048-7-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362718720-27048-7-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static int __init numa_register_memblks(struct numa_meminfo *mi)

After this patch, the above name is a bit misleading, I think.

> +out:

Maybe register: would fit better?

> +	/* Finally register nodes. */
> +	for_each_node_mask(nid, node_possible_map) {
> +		u64 start = PFN_PHYS(max_pfn);

Thanks.

-- 
tejun
