Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab3CHG0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:26:08 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55001 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab3CHG0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:26:06 -0500
Date: Thu, 7 Mar 2013 22:26:02 -0800
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] x86, mm, numa: use numa_meminfo to check
 node_map_pfn alignment
Message-ID: <20130308062602.GI14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
 <1362718720-27048-9-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362718720-27048-9-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:58:34PM -0800, Yinghai Lu wrote:
> We could use numa_meminfo directly instead of memblock nid.
> 
> So we could move down set memblock nid down and only do it one time
> for successful path
> 
> Move node_map_pfn_alignment() to arch/x86/mm as no other user for it.

Please don't move and update in the same patch.  It makes it difficult
to review what's really changing.

Thanks.

-- 
tejun
