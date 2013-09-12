Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab3ILSIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:08:50 -0400
Received: from one.firstfloor.org ([193.170.194.197]:53317 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab3ILSIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:08:48 -0400
Date: Thu, 12 Sep 2013 20:08:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, peterz@infradead.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel: Clean up checkpoint-interrupt
 bits
Message-ID: <20130912180846.GK18242@two.firstfloor.org>
References: <tip-dvb4q0rydkfp00kqat4p5bah@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-dvb4q0rydkfp00kqat4p5bah@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 11:04:34AM -0700, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  2b9e344df384e595db24ac61ae5f780e9b024878
> Gitweb:     http://git.kernel.org/tip/2b9e344df384e595db24ac61ae5f780e9b024878
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Thu, 12 Sep 2013 12:53:44 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 12 Sep 2013 19:13:37 +0200
> 
> perf/x86/intel: Clean up checkpoint-interrupt bits
> 
> Clean up the weird CP interrupt exception code by keeping a CP mask.
> 
> Andi suggested this implementation but weirdly didn't actually
> implement it himself, do so now because it removes the conditional in
> the interrupt handler and avoids the assumption its only on cnt2.

Looks good to me. Thanks.

-Andi
