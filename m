Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab3JNWYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 18:24:33 -0400
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:33607 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756459Ab3JNWYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 18:24:32 -0400
Date: Mon, 14 Oct 2013 22:24:30 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: David Miller <davem@davemloft.net>, tj@kernel.org,
        akpm@linuxfoundation.org, srostedt@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu
 operations V4
In-Reply-To: <20131012165120.GA15116@gmail.com>
Message-ID: <00000141b912103b-4bbb4dbd-747d-4a6d-8d1a-1a172eda4495-000000@email.amazonses.com>
References: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com> <20131011.140814.422793173894221852.davem@davemloft.net> <20131012165120.GA15116@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="376175846-684171027-1381789342=:21306"
Content-ID: <alpine.DEB.2.02.1310141724110.21306@gentwo.org>
X-SES-Outgoing: 2013.10.14-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--376175846-684171027-1381789342=:21306
Content-Type: TEXT/PLAIN; CHARSET=KOI8-R
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.02.1310141724111.21306@gentwo.org>

On Sat, 12 Oct 2013, Ingo Molnar wrote:

> Another problem is that the patch emails are not properly threaded to the
> 0/6 patch and thus appear out of order and mixed up:
>
> 66216 N C Oct 11 Christoph Lamet (  36) [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu operations V4
> 66217 N C Oct 11 David Miller    (  13) ��>
> 66218 N C Oct 11 Christoph Lamet (  43) ��>[PATCH 1/6] net: ip4_datagram_connect: Use correct form of statistics update
> 66219 N C Oct 11 Eric Dumazet    (  17) � ��>
> 66220 N C Oct 11 Christoph Lamet ( 121) ��>[PATCH 2/6] percpu: Add raw_cpu_ops
> 66221 N C Oct 11 Christoph Lamet ( 189) ��>[PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
> 66222 N C Oct 11 Christoph Lamet (  64) ��>[PATCH 5/6] net: __this_cpu_inc in route.c
> 66223 N C Oct 11 Christoph Lamet ( 103) ��>[PATCH 3/6] mm: Use raw_cpu ops for determining current NUMA node
> 66224 N C Oct 11 Christoph Lamet (  43) ��>[PATCH 4/6] Use raw_cpu_write for initialization of per cpu refcount.
>
> Note how the order is 1,2,6,5,3,4 with no threading instead of 1,2,3,4,5,6
> with proper threading.

Threading is done by quilt and it has been doing that for a pretty long time.

> That won't cause email servers to reject the mails, it just makes the
> patches a bit harder to review.

I do not have any control over how my ISP sorts these emails. You
repeatedly asked me to use quilt 0.60 because I guess you believed that it
could do some magic. I upgraded specially for you. I really do not know
what else to do to appease you. I could chance ISPs hoping that another
will deliver them in sequence but that is not easy to do. Maybe Amazon in
some way borks the headers.

> Most kernel developers tend to use 'git send-email' to send patches to
> lkml, and that method is working pretty reliably.

People are not allowed to use quilt for patches submitted to you?

I just checked and git send-mail does the threading in the same way as
quilt. There would be no change.
--376175846-684171027-1381789342=:21306--
