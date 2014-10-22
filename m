Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaJVBYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:24:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbaJVBYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:24:12 -0400
Date: Tue, 21 Oct 2014 21:24:05 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Paul Moore <pmoore@redhat.com>
Cc: Steve Grubb <sgrubb@redhat.com>, Eric Paris <eparis@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, serge@hallyn.com, keescook@chromium.org
Subject: Re: [RFC][PATCH] audit: log join and part events to the read-only
 multicast log socket
Message-ID: <20141022012405.GP15532@madcap2.tricolour.ca>
References: <30ef5c1ba42b52953e5684a0322975c3f0fadc77.1412706089.git.rgb@redhat.com>
 <1412708594.3333.94.camel@localhost>
 <2131923.Byl8GhZuQt@x2>
 <1645943.LlOpH1gJUB@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1645943.LlOpH1gJUB@sifl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/21, Paul Moore wrote:
> On Tuesday, October 21, 2014 03:56:10 PM Steve Grubb wrote:
> > audit_log_task_info logs too much information for typical use. There are
> > times when you might want to know everything about what's connecting. But
> > in this case, we don't need anything about groups, saved uids, fsuid, or
> > ppid.
> > 
> > Its a shame we don't have a audit_log_task_info_light function which only
> > records:
> > 
> > pid= auid= uid= subj= comm= exe=  ses= tty=
> 
> This is getting back to my earlier concerns/questions about field ordering, or 
> at the very least I'm going to hijack this conversation and steer it towards 
> field ordering ;)

Well, I've already been pushing it that way because it interferes with
any sort of refactoring that needs to be done to simplify and clean up
the kernel log code.

> Before we go to much farther, I'd really like us to agree that ordering is not 
> important, can we do that?  As a follow up, what do we need to do to make that 
> happen in the userspace tools?

At the very least, as I've suggested, agree on at least one more order,
a canonical one, that can provide a much more firm guide how to present
the keywords so that we're not stuck with an arbitrary order that turns
out not to make sense for some reason or another.

> paul moore

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
