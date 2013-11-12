Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab3KLXE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:04:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:13134 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757554Ab3KLXEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:04:21 -0500
Date: Tue, 12 Nov 2013 18:04:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [libtraceevent] hrtimer_expire_entry unknown op '{'
Message-ID: <20131112180417.759caafc@gandalf.local.home>
In-Reply-To: <20131112220153.GC5709@swordfish>
References: <20131105093755.GB2272@swordfish.minsk.epam.com>
	<20131105081522.1c8e2012@gandalf.local.home>
	<20131112213152.GB5709@swordfish>
	<20131112165237.3273f4b7@gandalf.local.home>
	<20131112220153.GC5709@swordfish>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 01:01:53 +0300
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
 
> > Do a make install, or copy all the *.so files into ~/.trace-cmd/plugins/
> > and that will go away.
> >
> 
> oh... thanks a lot!
> 
> I just quickly went through http://lwn.net/Articles/341902/
> (' Just download it, go into the directory and run "make" ')

Hmm, good point. I'll have to update the code to let the user know what
to do if it fails to parse. Something like:

 Failed to parse event hrtimer_expire_entry event
  Do you have all the plugins installed?
   Check /usr/lib/trace-cmd/plugins
   If you compiled it yourself, copy the *.so files to ~/.trace-cmd/plugins

-- Steve

> 
> thank you once again!
> 
