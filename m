Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3BVNqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 08:46:39 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46797 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3BVNqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 08:46:35 -0500
Date: Fri, 22 Feb 2013 14:46:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] perf, x86: Support full width counting v3
Message-ID: <20130222134630.GA8960@gmail.com>
References: <1361213287-7636-1-git-send-email-andi@firstfloor.org>
 <1361213287-7636-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361213287-7636-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Recent Intel CPUs like Haswell and IvyBridge have a new 
> alternative MSR range for perfctrs that allows writing the 
> full counter width. Enable this range if the hardware reports 
> it using a new capability bit.
> 
> This lowers the overhead of perf stat slightly because it has 
> to do less interrupts to accumulate the counter value. On 
> Haswell it also avoids some problems with TSX aborting when 
> the end of the counter range is reached.

The changelog does not adequately explain why this patch is 
critical for basic Haswell enablement. "Avoids some problems 
with TSX aborting" is not very helpful.

Thanks,

	Ingo
