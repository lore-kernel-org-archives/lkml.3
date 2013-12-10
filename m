Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3LJSSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:18:18 -0500
Received: from a9-114.smtp-out.amazonses.com ([54.240.9.114]:34998 "EHLO
	a9-114.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754188Ab3LJSSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:18:13 -0500
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Dec 2013 13:18:13 EST
Date: Tue, 10 Dec 2013 18:11:24 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@kernel.org>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/41] percpu: Add raw_cpu_ops
In-Reply-To: <20131210154951.GF4610@htj.dyndns.org>
Message-ID: <00000142ddb4d14d-76263c67-59fa-474b-97b2-deae3a92cf69-000000@email.amazonses.com>
References: <20131203233232.928771708@linux.com> <20131203233251.745099192@linux.com> <20131210153445.GE4610@htj.dyndns.org> <20131210154506.GA1884@gmail.com> <20131210154951.GF4610@htj.dyndns.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.10-54.240.9.114
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Tejun Heo wrote:

> > as we don't want to expand percpu ops without doing proper debugging.
>
> Yeah, trying to figure out which should go through which tree.
> Christoph, should I also pickup 14?  Or can that go through x86?

If you do that then you need to also pick up the patches in between
otherwise the debug functions will get quite loud.

