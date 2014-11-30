Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaK3MXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:23:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38611 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaK3MXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:23:52 -0500
Date: Sun, 30 Nov 2014 13:23:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, live-patching@vger.kernel.org,
        kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141130122348.GA13426@amd>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <545B98E6.2070009@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545B98E6.2070009@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-06 16:51:02, Jiri Slaby wrote:
> On 11/06/2014, 03:39 PM, Seth Jennings wrote:
> > This commit introduces code for the live patching core.  It implements
> > an ftrace-based mechanism and kernel interface for doing live patching
> > of kernel and kernel module functions.
> 
> Hi,
> 
> nice! So we have something to start with. Brilliant!
> 
> I have some comments below now. Yet, it obviously needs deeper review
> which will take more time.
> 
> > --- /dev/null
> > +++ b/include/linux/livepatch.h
> > @@ -0,0 +1,45 @@
> > +#ifndef _LIVEPATCH_H_
> > +#define _LIVEPATCH_H_
> 
> This should follow the linux kernel naming: LINUX_LIVEPATCH_H
> 
> 
> > +#include <linux/module.h>
> > +
> > +struct lp_func {
> 
> I am not much happy with "lp" which effectively means parallel printer
> support. What about lip?

What about "patch_"?

It is not so big subsystem that additional typing would matter much...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
