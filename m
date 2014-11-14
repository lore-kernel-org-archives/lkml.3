Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161816AbaKNTzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:55:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:65241 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753231AbaKNTzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:55:35 -0500
Date: Fri, 14 Nov 2014 14:55:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, bobby.prani@gmail.com, pmladek@suse.cz,
        jack@suse.cz, mcgrof@suse.com, joe@perches.com,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] printk: drop logbuf_cpu volatile qualifier
Message-ID: <20141114145533.633457c3@gandalf.local.home>
In-Reply-To: <54665C24.9060605@linaro.org>
References: <1415992771-9071-1-git-send-email-elder@linaro.org>
	<20141114144515.5b3e7d32@gandalf.local.home>
	<54665C24.9060605@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 13:46:44 -0600
Alex Elder <elder@linaro.org> wrote:

> On 11/14/2014 01:45 PM, Steven Rostedt wrote:
> > On Fri, 14 Nov 2014 13:19:31 -0600
> > Alex Elder <elder@linaro.org> wrote:
> > 
> >> Pranith Kumar posted a patch in which removed the "volatile"
> >> qualifier for the "logbuf_cpu" variable in vprintk_emit().
> >>     https://lkml.org/lkml/2014/11/13/894
> >> In his patch, he used ACCESS_ONCE() for all references to
> >> that symbol to provide whatever protection was intended.
> >>
> >> There was some discussion that followed, and in the end
> >> Stephen Rostedt concluded that not only was "volatile" not
> > 
> > I don't know of a Stephen Rostedt. J
> 
> Sorry.  I'm sure that's a source of annoyance.  -Alex

No problem. If you are wondering about that "J".

  https://www.facebook.com/mcgrof/posts/10104459749108919

It's my new thing. Maybe I can start a trend. J

-- Steve

> 
> >> needed, neither was it required to use ACCESS_ONCE().  I
> >> offered an elaborate description that concluded Stephen
> > 
> > Who is this Stephen you talk about?
> 
> . . .

