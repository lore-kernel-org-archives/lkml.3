Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3ILKcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:32:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41444 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3ILKcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:32:10 -0400
Date: Thu, 12 Sep 2013 12:31:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        pjt@google.com, preeti@linux.vnet.ibm.com, akpm@linux-foundation.org,
        mgorman@suse.de, riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Subject: Re: [PATCH v4 0/3] sched: Limiting idle balance
Message-ID: <20130912103150.GU31370@twins.programming.kicks-ass.net>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jason, could you repost all the 3 patches with the changes we talked
about (Srikar's suggestion, changing the half-time etc..) with fresh
perf numbers so I can apply them all?

