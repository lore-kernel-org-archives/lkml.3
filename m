Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab3BAPDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 10:03:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59431 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab3BAPDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 10:03:04 -0500
Date: Fri, 1 Feb 2013 16:03:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org, acme@redhat.com,
        eranian@google.com, jolsa@redhat.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 04/12] perf, x86: Support the TSX intx/intx_cp qualifiers v3
Message-ID: <20130201150302.GN30577@one.firstfloor.org>
References: <1359672710-19528-1-git-send-email-andi@firstfloor.org> <1359672710-19528-5-git-send-email-andi@firstfloor.org> <20130201101628.GB23061@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201101628.GB23061@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> As requested before, please keep those in a completely separate 
> series so that minimal support can be merged upstream. This is 

Hi Ingo, The goal is not to merge "minimal support" but full support.
All of these features have users.  But I subsetted it to make reviewing easier.

I think the initial 10 patch series is reasonable as a first step,
quickly followed by the others. Can you handle it or not? Please be clear on that.

If you can't handle it I'll consider alternatives.

To be honest I find it hard to believe you really have trouble reviewing
those 10 straight forward patches (which have already reviewed by 
others anyways).  There's nothing particularly complicated or risky in
any of them, and you're a experienced kernel code reviewer.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
