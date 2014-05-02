Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaEBPSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:18:09 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:34789 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaEBPSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:18:06 -0400
Date: Fri, 2 May 2014 11:18:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/7] percpu: Add a DEFINE_PER_CPU_2PAGE_ALIGNED
Message-ID: <20140502151802.GC10204@htj.dyndns.org>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
 <1398723161-21968-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398723161-21968-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 03:12:35PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Needed in a followon patch which needs to naturally align a 8K stack.
> I just put it into the page aligned section. This may cause an extra
> 4K hole if we're unlucky.

Add comment to that effect?  Saying that this should be broken into a
separate section if it ever grows more users?

> Cc: tj@kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
