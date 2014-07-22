Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaGVM7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:59:07 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:51654 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaGVM7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:59:05 -0400
Message-ID: <1406033927.32255.33.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] trace-cmd: add trace-record.o to the python shared lib
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        Darren Hart <darren@dvhart.com>
Date: Tue, 22 Jul 2014 14:58:47 +0200
In-Reply-To: <20140721170153.42a0d5d2@gandalf.local.home>
References: <1405975844-2361-1-git-send-email-jbacik@fb.com>
	 <20140721170153.42a0d5d2@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 17:01 -0400, Steven Rostedt wrote:
> Cc'd my python gurus.
> 
> Acks?

> > When trying to use the python library it was giving me an error about not being
> > able to resolve tracecmd_stat_cpu.  This is because we weren't linking
> > trace-record.o to ctracecmd.so.  Fix this in the makefile and now I can import
> > trace-cmd in python properly.  Thanks,

I guess, I don't see anything wrong with that. I don't usually use
ctracecmd.so standalone, only as part of trace-cmd, which may explain
why I didn't see any problem?

johannes

