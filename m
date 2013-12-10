Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab3LJS1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:27:25 -0500
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:45010 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753631Ab3LJS1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:27:22 -0500
X-Greylist: delayed 825 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Dec 2013 13:27:22 EST
Date: Tue, 10 Dec 2013 18:13:35 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/41] percpu: Add raw_cpu_ops
In-Reply-To: <20131210155546.GD1995@gmail.com>
Message-ID: <00000142ddb6d07d-f77cfa15-55a5-4806-891e-2d57894fc46b-000000@email.amazonses.com>
References: <20131203233232.928771708@linux.com> <20131203233251.745099192@linux.com> <20131210153445.GE4610@htj.dyndns.org> <20131210154506.GA1884@gmail.com> <20131210154951.GF4610@htj.dyndns.org> <20131210155546.GD1995@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.10-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Ingo Molnar wrote:

> > Yeah, trying to figure out which should go through which tree.
> > Christoph, should I also pickup 14?  Or can that go through x86?
>
> Well, it appears to have dependencies so I doubt it can be kept
> separate. In any case, provided all debugging is properly productized:

13/14 can be just merged. There are no dependencies on earlier patches.

If you want to merge 18 then you would need to pick up also 15-17.
