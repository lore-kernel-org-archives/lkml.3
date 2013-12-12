Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3LLJxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:53:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56750 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3LLJxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:53:31 -0500
Date: Thu, 12 Dec 2013 10:53:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kernel/locking: mutex: simplify access to the first
 entry in the wait-list
Message-ID: <20131212095320.GE21999@twins.programming.kicks-ass.net>
References: <1386841541-32244-1-git-send-email-andrzej.p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386841541-32244-1-git-send-email-andrzej.p@samsung.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 10:45:41AM +0100, Andrzej Pietrasiewicz wrote:
> Use list_first_entry instead of explicitly accessing the first entry
> with "head".next. The comment one line above becomes obsolete.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Kyungmin Park <andrzej.p@samsung.com>

This is an invalid sign-off trail.
