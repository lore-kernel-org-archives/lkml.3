Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762341Ab3DKWou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:44:50 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51276 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752968Ab3DKWot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:44:49 -0400
Date: Thu, 11 Apr 2013 18:44:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Linux kernel Wait-Free Concurrent Queue
	Implementation
Message-ID: <20130411224445.GA1125@Krystal>
References: <20130311213602.GB9829@Krystal> <20130411212308.GA21778@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411212308.GA21778@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Wong (normalperson@yhbt.net) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > It is provided as a starting point only. Test cases should be ported
> > from Userspace RCU to kernel space and thoroughly ran on a wide range of
> > architectures before considering this port production-ready.
> 
> Hi Mathieu, any progress on this front?

Nope, I've been busy on other things.

> I'm not sure how to approach
> test cases in the kernel, perhaps taking hints from locking_selftest()
> would be a start.

I guess creating a wfcq_selftest() derived from userspace RCU
test_urcu_wfcq.c might be a good start.

> Fwiw, I've been running wfcqueue+epoll for a few weeks now on my
> personal machines without problems :)

Great!

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
