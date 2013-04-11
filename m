Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936478Ab3DKVXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:23:15 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:41842 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935400Ab3DKVXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:23:09 -0400
Date: Thu, 11 Apr 2013 21:23:08 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Linux kernel Wait-Free Concurrent Queue
 Implementation
Message-ID: <20130411212308.GA21778@dcvr.yhbt.net>
References: <20130311213602.GB9829@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311213602.GB9829@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> It is provided as a starting point only. Test cases should be ported
> from Userspace RCU to kernel space and thoroughly ran on a wide range of
> architectures before considering this port production-ready.

Hi Mathieu, any progress on this front?  I'm not sure how to approach
test cases in the kernel, perhaps taking hints from locking_selftest()
would be a start.

Fwiw, I've been running wfcqueue+epoll for a few weeks now on my
personal machines without problems :)
