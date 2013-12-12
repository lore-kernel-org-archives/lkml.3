Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab3LLLfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:35:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58645 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3LLLfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:35:22 -0500
Date: Thu, 12 Dec 2013 12:35:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2] kernel/locking: mutex: simplify access to the first
 entry in the wait-list
Message-ID: <20131212113511.GG21999@twins.programming.kicks-ass.net>
References: <1386847772-8918-1-git-send-email-andrzej.p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386847772-8918-1-git-send-email-andrzej.p@samsung.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 12:29:32PM +0100, Andrzej Pietrasiewicz wrote:
> Use list_first_entry instead of explicitly accessing the first entry
> with "head".next. The comment one line above becomes obsolete.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> 
> v1..v2:
> 
> - corrected the email address in the second Signed-off-by line

Still invalid; the problem is that you appear to have written the patch
(you send it and you have first sob).

So what is Kyungmin doing in the line? He did not send me your patch.
