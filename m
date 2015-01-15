Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbbAOIpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:45:46 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38024 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbbAOIo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:44:59 -0500
Date: Thu, 15 Jan 2015 09:44:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Bruce Merry <bmerry@ska.ac.za>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH] perf bench: fix order of arguments to memcpy_alloc_mem
Message-ID: <20150115084449.GP23965@worktop.programming.kicks-ass.net>
References: <CAOm-9aqxsiC15Q+VGTB9k37-+VcSTaSZZL3xov7zexf4Pqr8NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOm-9aqxsiC15Q+VGTB9k37-+VcSTaSZZL3xov7zexf4Pqr8NQ@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 10:15:34AM +0200, Bruce Merry wrote:
> This was causing the destination instead of the source to be filled.
> As a result, the source was typically all mapped to one zero page,
> and hence very cacheable

Almost right ;-)

Please have a look at Documentation/SubmittingPatches

We require at least a Signed-off-by: tag in order to process patches.

Thanks!
