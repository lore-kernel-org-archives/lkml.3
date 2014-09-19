Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbaISTFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:05:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:57994 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757626AbaISTFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:05:15 -0400
Date: Fri, 19 Sep 2014 15:05:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH][linux-next] pnfs/blocklayout: Use do_div for 64 bit
 divide operations
Message-ID: <20140919150504.596d72e8@gandalf.local.home>
In-Reply-To: <CAHQdGtQqDMiu+MTOMd3ywaJzxdFo-MquGktitq-YxOsEhLA4Zg@mail.gmail.com>
References: <20140919133046.7d5ad943@gandalf.local.home>
	<CAHQdGtQqDMiu+MTOMd3ywaJzxdFo-MquGktitq-YxOsEhLA4Zg@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014 14:39:10 -0400
Trond Myklebust <trond.myklebust@primarydata.com> wrote:

> Thanks. I posted a similar bugfix on the linux-nfs mailing list
> yesterday. That hasn't been pushed to linux-next yet because Christoph
> wanted to run it through some QA tests first.

No problem. As long as it gets fixed before it breaks my test suite ;-)

-- Steve
