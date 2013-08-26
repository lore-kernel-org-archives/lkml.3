Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3HZPbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:31:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26221 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab3HZPbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:31:38 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=K5CnSjgaiocA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=HYTzF2Oq1SkA:10 a=NufY4J3AAAAA:8 a=Gn0JQkc8dqoJdQ6f60gA:9 a=CjuIK1q_8ugA:10 a=re9sYKne76oA:10 a=yYVWLxSIFJnIvuox:21 a=UFOp9KPpXgtf3s3Y:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 26 Aug 2013 11:31:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [guv 04/16] core: Convert __get_cpu_var uses
Message-ID: <20130826113134.5306379d@gandalf.local.home>
In-Reply-To: <00000140bb35f38a-99d5d8ab-6672-42e8-9e91-55cb231c693d-000000@email.amazonses.com>
References: <20130823190135.726207430@linux.com>
	<00000140ac8e2bdd-f0151a00-88ca-4d0b-adbc-007c514b6856-000000@email.amazonses.com>
	<20130826141849.GA6276@home.goodmis.org>
	<00000140bb35f38a-99d5d8ab-6672-42e8-9e91-55cb231c693d-000000@email.amazonses.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 15:20:09 +0000
Christoph Lameter <cl@linux.com> wrote:

> On Mon, 26 Aug 2013, Steven Rostedt wrote:
> 
> > As Tejun said, each commit needs its own change log. Never expect a
> > change lgo from another commit to be read for changes in this commit.
> 
> I can copy the intro into each of the patches?

That probably would be fine.


> >
> > This patch needs to be broken up per subsystem. Or are you just looking
> > for acks from all the maintainers here and you'll pull it in. If that's
> > the case, you should have Cc'd each of the maintainers of the files that
> > this touches.
> 
> I did a breakout by arch, then core and drivers. How fine grained do you
> want them? This touches a significant portion of the kernel source.
> There could be quite a number of maintainers involved.

If you plan on sending the patch, then just get an ack for each of the
maintainers that this code touches. At least Cc them. Yeah, there are a
significant number of maintainers but not that many that it will cause
the email to be bounced from LKML for too many Cc's.

An Acked-by from David Miller will cover all of net/ subsystem. Maybe
make that a separate patch?

I can do the tracing patches.

Thomas Gleixner can ack all the timing changes.

Peter Zijlstra and Ingo Molnar can do the rest of the kernel/ changes.

I assume that Andrew Morton can take care of the mm/ changes and
perhaps even the radix tree changes.

-- Steve

