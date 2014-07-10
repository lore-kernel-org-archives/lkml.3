Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaGJWxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:53:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:52076 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751362AbaGJWxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 18:53:19 -0400
Date: Thu, 10 Jul 2014 18:53:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Josef Bacik <jbacik@fb.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] trace-cmd: add the ability to install libtracecmd
Message-ID: <20140710185311.5672b6e6@gandalf.local.home>
In-Reply-To: <1405027367-26570-1-git-send-email-jbacik@fb.com>
References: <1405027367-26570-1-git-send-email-jbacik@fb.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014 17:22:45 -0400
Josef Bacik <jbacik@fb.com> wrote:

> Hello,
> 
> I'm trying to build some custom tracing tools on top of trace-cmd but they
> aren't really usefull outside of Facebook so I don't want to shove them into the
> actual trace-cmd project.  Instead I'd like to be able to just build libtracecmd
> and install that as well as the necessary header files and just link my tools
> against that.  I'm shit at userspace stuff like this, so I've just hacked
> something together that works for me.  I'm mostly hoping somebody will look at
> the Makefile horribleness that I came up with and tell me how to do it right (or
> better yet do it for me!)  The second patch just cleans up some stuff to make
> the shared library more library esque.  Any feedback would be great.  Thanks,
> 

I'm shit at userspace too ;-)  I just like simple makefiles and other
non "autocrap" stuff.

Anyway, I did plan on getting a libtracecmd out someday (at a bottom of
a very long todo list), so I'm all game for this. I was hoping to get
libtraceevent out first. That's now homed in the kernel tools
directory and I've been porting stuff to and from trace-cmd for that as
well. But there's still a bit of work on that front.

I'll have to take a look at your patches and see how they are after I
get some other things out of the way first.

-- Steve
