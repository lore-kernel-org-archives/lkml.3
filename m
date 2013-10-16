Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab3JPKh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:37:56 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:46540 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760549Ab3JPKhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:37:55 -0400
Date: Wed, 16 Oct 2013 12:37:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: David Miller <davem@davemloft.net>, tj@kernel.org,
        akpm@linuxfoundation.org, srostedt@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu
 operations V4
Message-ID: <20131016103751.GA24897@gmail.com>
References: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com>
 <20131011.140814.422793173894221852.davem@davemloft.net>
 <20131012165120.GA15116@gmail.com>
 <00000141b912103b-4bbb4dbd-747d-4a6d-8d1a-1a172eda4495-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000141b912103b-4bbb4dbd-747d-4a6d-8d1a-1a172eda4495-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> > That won't cause email servers to reject the mails, it just makes the 
> > patches a bit harder to review.
> 
> I do not have any control over how my ISP sorts these emails. [...]

Your series from today has proper threading - so after all it _was_ 
possible for you to send a patch series correctly?

Note that you did not address the other problem that David Miller pointed 
out, the Cc list still looks messed up:

Message-Id: <20131015180050.084352174@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 15 Oct 2013 12:58:53 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, "David S. Miller" <davem@davemloft.net>
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 01/10] net: Replace __get_cpu_var uses

Thanks,

	Ingo
