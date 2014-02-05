Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbaBEVgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:36:24 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50957 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbaBEVgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:36:17 -0500
Date: Wed, 5 Feb 2014 13:35:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: Vladimir Davydov <vdavydov@parallels.com>, akpm@linux-foundation.org,
        penberg@kernel.org, cl@linux.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH v3] slub: fix false-positive lockdep warning in
 free_partial()
In-Reply-To: <20140205163138.51eb8b31@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1402051333380.16853@chino.kir.corp.google.com>
References: <52F1F25F.20402@parallels.com> <1391588133-15469-1-git-send-email-vdavydov@parallels.com> <20140205195837.GA6857@home.goodmis.org> <alpine.DEB.2.02.1402051231250.5616@chino.kir.corp.google.com> <20140205155840.43d6b4ad@gandalf.local.home>
 <alpine.DEB.2.02.1402051301460.14325@chino.kir.corp.google.com> <20140205161952.781e3a0e@gandalf.local.home> <alpine.DEB.2.02.1402051324370.14325@chino.kir.corp.google.com> <20140205163138.51eb8b31@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Steven Rostedt wrote:

> > Looks like you've got something prepared already!  Mind sending it to 
> > Pekka as a patch based on linux-next?
> 
> Sure, and there's another lockdep splat that I'm working on too.
> 

If it's coming from slub, make sure you've applied 
http://marc.info/?l=linux-kernel&m=139147105027693 first which fixes yet 
another slub lockdep issue related to the lockdep assertion.  It's not in 
linux-next yet because it went through -mm instead of Pekka's tree.

> But first, I need to shovel my driveway yet again (We got something
> like 18 inches of snow in the last 24 hours).
> 

Fun!  It's 33 F here today but nobody cares because we have a Super Bowl 
parade in town!
