Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3LQUpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:45:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:3442 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab3LQUpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,503,1384329600"; 
   d="scan'208";a="453840626"
Message-ID: <1387313151.3051.39.camel@empanada>
Subject: Re: [PATCH] Tracing events with GPIOs
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 17 Dec 2013 14:45:51 -0600
In-Reply-To: <20131217140502.2aed31aa@gandalf.local.home>
References: <1387239745-2890-1-git-send-email-jjhiblot@traphandler.com>
	 <52AFA5E0.7040707@hitachi.com>
	 <CACh+v5NgwyAD5xy-feykUDXpzVUuF2yFxP35TsnGk3r+LFtRPA@mail.gmail.com>
	 <1387304970.3051.35.camel@empanada>
	 <20131217140502.2aed31aa@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 14:05 -0500, Steven Rostedt wrote:
> On Tue, 17 Dec 2013 12:29:30 -0600
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> 
> > > Tom,
> > > is git://git.yoctoproject.org/linux-yocto-contrib
> > > tzanussi/event-triggers-v11 the right starting point ?
> > > 
> > 
> > Yep, that's the last iteration - I haven't changed anything since then.
> > 
> 
> Is this the same as the last patch series you sent out? I started
> testing them again last week, but they failed some of my tests.

Yeah, that's the same patchset.  I tested it here and didn't see any
problems but I guess your tests must be different/more rigorous - it
would be good to know what failed.  I could also run your test suite
here if that would help.

> Unfortunately, I didn't get a chance to look into why. I'm hoping to
> get that series out to my for-next branch by end of the week, as I'll
> be taking two weeks off starting next week.
> 
> Year end crap is piling up, preventing me from getting real work
> done ;-)

I know what you mean, same here.  ;-)

> 
> -- Steve


