Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3LMPNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:13:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45356 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3LMPNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:13:19 -0500
Date: Fri, 13 Dec 2013 16:13:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 1/2] perf: fix PERF_EVENT_IOC_PERIOD to force-reset the
 period
Message-ID: <20131213151308.GO21999@twins.programming.kicks-ass.net>
References: <1385560479-11014-1-git-send-email-will.deacon@arm.com>
 <20131212182747.GL12617@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212182747.GL12617@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 06:27:47PM +0000, Will Deacon wrote:
> Hi Peter,
> 
> Do you have any thoughts on the below? It would be good to add your
> signed-off to the patch, since you wrote it originally.
> 

Picked them up, thanks will!
