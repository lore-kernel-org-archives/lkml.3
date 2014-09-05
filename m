Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaIEXMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:12:44 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59158 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751187AbaIEXMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:12:43 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Sat, 06 Sep 2014 01:32:04 +0200
Message-ID: <8615268.1yl5ssmHZO@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140905224554.GD15723@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <CAM_iQpUbGTxrbJZ_ztf+QUvFowsivQ-jvPCSi7kmth7nstPvaA@mail.gmail.com> <20140905224554.GD15723@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 06, 2014 07:45:54 AM Tejun Heo wrote:
> Hello,
> 
> On Fri, Sep 05, 2014 at 11:12:24AM -0700, Cong Wang wrote:
> > > Rafael, can you please help?
> > 
> > Rafael is known not responsive at least for this topic. :)
> 
> :(

Well, am I?

I haven't commented patches in this thread so far, mostly because other
people have.

How can I help actually?

> > > Shouldn't the primary goal of the comment be explaining why we need
> > > TIF_MEMDIE check there at all anyway?  The deadlock possiblity is not
> > > very obvious.
> > 
> > The changelog is not long enough?? ;-) I hate to copy+paste changelog
> > into comments, changelog is essentially necessary for people to understand
> > kernel code (at least networking) , so I don't think we have to move it
> > into comments in this case.
> 
> It doesn't have to be the same text but the current comment is
> basically content-less.  e.g. it can just say "OOM killer may get
> stuck trying to kill a cgroup frozen task" and actualy provide
> information on what condition the conditional tries to address.

Or something like "We need to check X to prevent Y from happening".

Rafael

