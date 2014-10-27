Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaJ0PBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:01:00 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:51508 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaJ0PA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:00:59 -0400
Date: Mon, 27 Oct 2014 11:00:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] percpu: Add a DEFINE_PER_CPU_2PAGE_ALIGNED
Message-ID: <20141027150055.GO4436@htj.dyndns.org>
References: <1413349911-3620-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413349911-3620-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 10:11:44PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Needed in a followon patch which needs to naturally align a 8K stack.
> I just put it into the page aligned section. This may cause an extra
> 4K hole if we're unlucky.
> 
> Cc: tj@kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Looks fine to me.  Please feel free to add

 Acked-by: Tejun Heo <tj@kernel.org>

and route any way you see fit.

Thanks.

-- 
tejun
