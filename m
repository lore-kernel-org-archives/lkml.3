Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaKDOMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:12:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:4993 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753523AbaKDOMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:12:00 -0500
Date: Tue, 4 Nov 2014 09:11:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
Subject: Re: [RFA][PATCH 2/8] netfilter: Remove return values for
 print_conntrack callbacks
Message-ID: <20141104091157.24066441@gandalf.local.home>
In-Reply-To: <20141104080535.5f651713@gandalf.local.home>
References: <20141029215602.535533597@goodmis.org>
	<20141029220107.465008329@goodmis.org>
	<20141104080535.5f651713@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014 08:05:35 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 29 Oct 2014 17:56:04 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > [ REQUEST FOR ACKS ]
> 
> Can any of the netfilter folks give me an Acked-by for this?
> 

I hope nobody expects Jozsef Kadlecsik to do this, as I'm getting "Mail
Delivery Failures" from him with this message:

>>> kadlec@blackhole.kfki.hu (after RCPT TO): 550 5.7.1 <kadlec@blackhole.kfki.hu>: Recipient address rejected: Access denied. Your site is banned because of the unsolicited mail messages received from it.  

Wow, seems they are banning all Time Warner Cable customers in my area!

-- Steve

