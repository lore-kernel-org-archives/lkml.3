Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3JPOcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:32:55 -0400
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:41413 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab3JPOcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:32:54 -0400
Date: Wed, 16 Oct 2013 14:32:53 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: David Miller <davem@davemloft.net>, tj@kernel.org,
        akpm@linuxfoundation.org, srostedt@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu
 operations V4
In-Reply-To: <20131016103751.GA24897@gmail.com>
Message-ID: <00000141c1af00d5-93f7c2d9-fdc4-4fec-a73d-0c3434bf5d56-000000@email.amazonses.com>
References: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com> <20131011.140814.422793173894221852.davem@davemloft.net> <20131012165120.GA15116@gmail.com> <00000141b912103b-4bbb4dbd-747d-4a6d-8d1a-1a172eda4495-000000@email.amazonses.com>
 <20131016103751.GA24897@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Ingo Molnar wrote:

> > I do not have any control over how my ISP sorts these emails. [...]
>
> Your series from today has proper threading - so after all it _was_
> possible for you to send a patch series correctly?

Well yes with some effort I was able to get funnel this stuff through my
home connection. Problem is that this is a hassle to do. I am going to
have limited availability in the next couple of weeks due to conferences
and vacation. Then I guess I need to see if I can relocate my development
system elsewhere.

