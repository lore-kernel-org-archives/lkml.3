Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab3JKSIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:08:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53525 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3JKSIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:08:16 -0400
Date: Fri, 11 Oct 2013 14:08:14 -0400 (EDT)
Message-Id: <20131011.140814.422793173894221852.davem@davemloft.net>
To: cl@linux.com
Cc: tj@kernel.org, akpm@linuxfoundation.org, srostedt@redhat.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Subject: Re: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu
 operations V4
From: David Miller <davem@davemloft.net>
In-Reply-To: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com>
References: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 11 Oct 2013 11:08:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Most sites are rejecting your posting because the CC: list looked like this:

Cc:	akpm@linuxfoundation.org
Cc:	Steven Rostedt <srostedt@redhat.com>
Cc:	linux-kernel@vger.kernel.org
Cc:	Ingo Molnar <mingo@kernel.org>
Cc:	Peter Zijlstra <peterz@infradead.org>
Cc:	Thomas Gleixner <tglx@linutronix.de>

Please only specify one CC: list with a comma separated list of recipients.

Thanks.
