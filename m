Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3LENvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:51:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:64196 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932203Ab3LENvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:51:50 -0500
Date: Thu, 5 Dec 2013 08:51:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Henrik Austad <henrik@austad.us>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 tip/core/locking 0/4] Memory-barrier documentation
 updates
Message-ID: <20131205085146.0370ea2a@gandalf.local.home>
In-Reply-To: <20131205122851.GB20562@gmail.com>
References: <20131204224628.GA30159@linux.vnet.ibm.com>
	<20131205105928.GA27382@austad.us>
	<20131205122851.GB20562@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013 13:28:51 +0100
Ingo Molnar <mingo@kernel.org> wrote:
 
> > Just me, or is the 3rd patch missing from lkml?
> 
> It had a Cc: list from hell so vger probably rejected it as spam.
> 

I wish vger wouldn't do that. I wonder how much spam is really flagged
by this one characteristic alone. That is, spam that would have made it
otherwise, but because of the Cc list, it was rejected.

-- Steve
