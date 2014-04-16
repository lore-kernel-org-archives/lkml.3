Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161476AbaDPOXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:23:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:60522 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161109AbaDPOXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:23:17 -0400
Date: Wed, 16 Apr 2014 10:23:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, fweisbec@gmail.com,
        mingo@redhat.com, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sched & trace: Add a trace event for wait.
Message-ID: <20140416102310.356dd692@gandalf.local.home>
In-Reply-To: <20140415134916.GT11096@twins.programming.kicks-ass.net>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
	<6d3aa5da995cfdb74b1d1c349c74a8c01ba9cdf6.1397562542.git.yangds.fnst@cn.fujitsu.com>
	<20140415134916.GT11096@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014 15:49:16 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Apr 15, 2014 at 09:32:50PM +0900, Dongsheng Yang wrote:
> > From: Dongsheng <yangds.fnst@cn.fujitsu.com>
> > 
> 
> No changelog, and the tracepoint seems useless to me.
> 

At least patch 1 and 2 need to be combined.

-- Steve
