Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaETLEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:04:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:33272 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaETLEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:04:34 -0400
Date: Tue, 20 May 2014 13:04:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: spinlock recursion in migrate_swap_stop
Message-ID: <20140520110431.GX2485@laptop.programming.kicks-ass.net>
References: <5371122D.6020605@oracle.com>
 <537AB86B.4020901@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537AB86B.4020901@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:05:31PM -0400, Sasha Levin wrote:
> ping? It seems to be easy enough to reproduce on -next, I'd be happy to try
> debug patches/fixes.

Does this fuzzing you do also include hotplug? If so, does disabling
that make this problem go away?
