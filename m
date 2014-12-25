Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaLYXRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 18:17:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaLYXRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 18:17:34 -0500
Date: Fri, 26 Dec 2014 00:17:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftracetest: Replace usleep with sleep 0.000001
Message-ID: <20141225231725.GA29853@amd>
References: <1418186307-1259-1-git-send-email-mpe@ellerman.id.au>
 <20141220204213.GA16705@amd>
 <20141220170725.776363ac@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141220170725.776363ac@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-12-20 17:07:25, Steven Rostedt wrote:
> On Sat, 20 Dec 2014 21:42:13 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > On Wed 2014-12-10 15:38:27, Michael Ellerman wrote:
> > > usleep is a Fedoraism, it's not generally available on Debian based
> > > systems AFAICS.
> > > 
> > > GNU sleep accepts a floating point argument, so use that instead.
> > > 
> > > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > 
> > Could ftrace user interface be enhanced not to need random delays?
> > 
> 
> Not sure what you are talking about. These "random delays" are not for
> the interface, but instead to force some events to happen and to make
> sure they did.
> 
> As the subject states, this is for "ftracetest" which is the selftests
> for ftrace.
> 
> The usleep is basically a "do something to trigger events", and we
> don't want to wait long in doing it.

Yep, I misunderstood, sorry.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
