Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3JNTDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:03:09 -0400
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:35716 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757034Ab3JNTDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:03:08 -0400
Date: Mon, 14 Oct 2013 19:03:06 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <srostedt@redhat.com>
cc: David Miller <davem@davemloft.net>, tj@kernel.org,
        akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu
 operations V4
In-Reply-To: <1381756142.14558.17.camel@fedora>
Message-ID: <00000141b859abba-86b8c5d2-e5ca-4653-a35f-01f34daff28d-000000@email.amazonses.com>
References: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com> <20131011.140814.422793173894221852.davem@davemloft.net> <1381756142.14558.17.camel@fedora>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.14-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Oct 2013, Steven Rostedt wrote:

> On Fri, 2013-10-11 at 14:08 -0400, David Miller wrote:
> >
> > Most sites are rejecting your posting because the CC: list looked like this:
> >
> > Cc:     akpm@linuxfoundation.org
> > Cc:     Steven Rostedt <srostedt@redhat.com>
>
> Also, please remove my Red Hat email address from your address book and
> replace it with rostedt@goodmis.org instead.
>
> I try not to do upstream work from my Red Hat account, and use that only
> for Red Hat internal issues.

Ok.

