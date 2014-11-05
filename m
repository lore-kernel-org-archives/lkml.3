Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaKESOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:14:54 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:29786 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750887AbaKESOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:14:53 -0500
Date: Wed, 5 Nov 2014 13:14:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [RFA][PATCH 0/8] seq_file: Remove return checks of seq_printf()
Message-ID: <20141105131450.40ec4b2d@gandalf.local.home>
In-Reply-To: <20141105175020.GA3895@ZenIV.linux.org.uk>
References: <20141029215602.535533597@goodmis.org>
	<20141104080436.10904a7a@gandalf.local.home>
	<20141105175020.GA3895@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 17:50:21 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Tue, Nov 04, 2014 at 08:04:36AM -0500, Steven Rostedt wrote:
> > On Wed, 29 Oct 2014 17:56:02 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > [ REQUEST FOR ACKS ]
> > 
> > Al,
> > 
> > Can you take a look at these, and give me an Acked-by if they are OK
> > with you?
> 
> Looks sane.  How do you want to handle the merge of that series?

I can push them to Linus with your Acked-by, or if you want, you can
take them as well. You can either use the patches from the list or I can
make a git branch for you to pull from.

-- Steve
