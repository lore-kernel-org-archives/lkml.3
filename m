Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3LETP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:15:29 -0500
Received: from a9-111.smtp-out.amazonses.com ([54.240.9.111]:38359 "EHLO
	a9-111.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809Ab3LETP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:15:27 -0500
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 14:15:27 EST
Date: Thu, 5 Dec 2013 19:09:10 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/41] percpu: Consistent per cpu operations V1
In-Reply-To: <20131204170227.GB6415@gmail.com>
Message-ID: <00000142c429e9ce-10588a45-ce91-4e10-b58a-d5ad18b3ad39-000000@email.amazonses.com>
References: <20131203233232.928771708@linux.com> <20131204084020.GB31737@gmail.com> <00000142be7e005c-7ec3b0da-e975-438e-9203-7fa7ed80c891-000000@email.amazonses.com> <20131204170227.GB6415@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.05-54.240.9.111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Ingo Molnar wrote:

> > They are included. Please read the complete description. Patches 13
> > 14 and 18 implement the preemption checks.
>
> Indeed I missed them. They should probably go first in the series.

The first patches in the series do not affect __this_cpu ops but
only use this_cpu ops. this_cpu_ptr already checks for preemption. The
first patches are therefore indepedent of new preemptin checking
and I hope that they can be immediately merged even if there are further
issues with the other patches.

> > Other than that they are looking fine now. >

Great. Thanks.

