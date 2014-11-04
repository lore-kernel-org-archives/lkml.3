Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaKDOs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:48:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:27173 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751228AbaKDOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:48:56 -0500
Date: Tue, 4 Nov 2014 09:48:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [RFA][PATCH 2/8] netfilter: Remove return values for
 print_conntrack callbacks
Message-ID: <20141104094854.29de09d2@gandalf.local.home>
In-Reply-To: <20141104144632.GA11096@salvia>
References: <20141029215602.535533597@goodmis.org>
	<20141029220107.465008329@goodmis.org>
	<20141104080535.5f651713@gandalf.local.home>
	<20141104142236.GA10239@salvia>
	<20141104093150.7410f6d0@gandalf.local.home>
	<20141104144632.GA11096@salvia>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014 15:46:32 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:


> > Can I get someone to ack 3/8?
> 
> I don't see any 3/8 in my inbox, only 2/8 and 4/8.
> 
> Let me know, thanks.

Strange, you were on the Cc of that patch.

Let me go back and check to make sure that didn't bounce too.

-- Steve
