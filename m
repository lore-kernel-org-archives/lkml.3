Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab3K3JUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 04:20:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57990 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3K3JUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 04:20:38 -0500
Date: Sat, 30 Nov 2013 10:20:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] arch: include/asm/Kbuild: fix preempt.h sort order
Message-ID: <20131130092031.GG16796@laptop.programming.kicks-ass.net>
References: <1385736191-31862-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385736191-31862-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 02:43:11PM +0000, James Hogan wrote:
> Commit a787870924db (sched, arch: Create asm/preempt.h) added the
> generic asm/preempt.h header, but took no notice of the sort order of
> various architecture's include/asm/Kbuild files. Move preempt.h into the
> correct sort position in files which are mostly already sorted.

Oh, I completely failed to notice they're sorted.

Thanks for fixing it up.
