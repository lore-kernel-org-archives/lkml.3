Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaE3HcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:32:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:51395 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaE3Hb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:31:58 -0400
Date: Fri, 30 May 2014 09:31:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: gleb@kernel.org, pbonzini@redhat.com, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] perf: Allow guest PEBS for KVM owned counters
Message-ID: <20140530073153.GA20167@laptop.programming.kicks-ass.net>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401412327-14810-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 06:12:05PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Currently perf unconditionally disables PEBS for guest.
> 
> Now that we have the infrastructure in place to handle
> it we can allow it for KVM owned guest events. For
> the perf needs to know that a event is owned by
> a guest. Add a new state bit in the perf_event for that.
> 

This doesn't make sense; why does it need to be owned?
