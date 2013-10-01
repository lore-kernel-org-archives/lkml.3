Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3JAHWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 03:22:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58843 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3JAHWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 03:22:18 -0400
Date: Tue, 1 Oct 2013 09:22:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: acma@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        jolsa@redhat.com
Subject: Re: perf, x86: Add last TSX PMU code for Haswell v3
Message-ID: <20131001072203.GJ3081@twins.programming.kicks-ass.net>
References: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 02:58:57PM -0700, Andi Kleen wrote:
> [This has kernel and user parts.
> Both sides have been reviewed now, so hopefully it's good
> to merge.]
> [v2: Address Peter's feedback for the kernel parts]
> [v3: Rebased to current tip. Added Ack/Reviewed-by for user tools code]

I merged your previous version yesterday; and did the rebase to current
tip as that was a trivial one; I added Jolsa's ack.

Did I miss anything?
