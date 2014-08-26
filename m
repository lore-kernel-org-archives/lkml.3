Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaHZV3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:29:38 -0400
Received: from one.firstfloor.org ([193.170.194.197]:33240 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaHZV3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:29:37 -0400
Date: Tue, 26 Aug 2014 23:29:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/5] perf, x86: Remove incorrect model number from
 Haswell perf
Message-ID: <20140826212934.GP4120@two.firstfloor.org>
References: <1409006611-30741-1-git-send-email-andi@firstfloor.org>
 <1409006611-30741-2-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.10.1408262325200.3323@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1408262325200.3323@nanos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So what's the point of making the obvious onliner patch
> 
> -	case 71:
> 
> into something which reorders the sorted case numbers?
 
This was a merging mistake. I'll fix it to be a one liner.

> And of course, this patch is missing any explanation WHY 71 is
> incorrect and how it got there in the first place.

71 is a Broadwell, as you would know if you had read the next patch.

-Andi
