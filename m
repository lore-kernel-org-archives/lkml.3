Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3EVJXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:23:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38100 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3EVJXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:23:05 -0400
Date: Wed, 22 May 2013 11:23:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/9] liblockdep: Add public headers for
 pthread_rwlock_t implementation
Message-ID: <20130522092301.GG18810@twins.programming.kicks-ass.net>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
 <1368674141-10796-6-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368674141-10796-6-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:15:37PM -0400, Sasha Levin wrote:
> Both pthreads and lockdep support dealing with rwlocks, so
> here's the liblockdep implementation for those.

I suppose the same comments as for the pthread_mutex_* case...
