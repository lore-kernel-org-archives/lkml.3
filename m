Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3BOQxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:53:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2854 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3BOQxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:53:40 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1ADFm0T--rEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=mYRWiXiH8qgA:10 a=7_YT7sJRujFhQdEFiykA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360947217.23152.112.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH] printk: Remove separate printk_sched buffers and
 use printk buf instead
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "kay.sievers" <kay.sievers@vrfy.org>
Date: Fri, 15 Feb 2013 11:53:37 -0500
In-Reply-To: <20130215165032.GF7458@quack.suse.cz>
References: <1360112748.2621.25.camel@gandalf.local.home>
	 <20130206230220.GA18329@quack.suse.cz>
	 <20130212122245.GB19583@quack.suse.cz>
	 <1360867691.23152.48.camel@gandalf.local.home>
	 <20130215165032.GF7458@quack.suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 17:50 +0100, Jan Kara wrote:
> On Thu 14-02-13 13:48:11, Steven Rostedt wrote:
> > On Tue, 2013-02-12 at 13:22 +0100, Jan Kara wrote:
> > 
> > > > Anyway, what do you guys think about this version?
> > >   Steven, Andrew, did you have a chance to look at my patches?
> > 
> > Can you resend without being attachments. Patches sent as attachments
> > seldom get reviewed.
>   Well, for example I do review text/plain attachments but that may count
> into 'seldom' ;) I'll send them inline.
> 

The problem is that it makes it difficult to reply with comments. I
haven't looked at the patches yet so I may not have comments, but on my
email client, commenting attachments means that I need to cut and paste
the text to do the comment, which isn't the case for inline patches.

-- Steve


