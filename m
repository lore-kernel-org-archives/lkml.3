Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3GJWWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:22:13 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:36655 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab3GJWWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:22:12 -0400
Date: Wed, 10 Jul 2013 18:22:06 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] What to do when a maintainer is
 no longer available
Message-ID: <20130710222206.GE28076@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	ksummit-2013-discuss@lists.linuxfoundation.org,
	linux-kernel@vger.kernel.org
References: <1373489151.7458.80.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373489151.7458.80.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Reminder: please cc the relevant mailing lists when proposing a topic
for the kernel summit.)

On Wed, Jul 10, 2013 at 04:45:51PM -0400, Steven Rostedt wrote:
> Recently we lost a major Open Source developer to a tragic accident.
> Seth Vidal wasn't a kernel developer, but his death reminds us of how
> any one of us can leave this planet at any time. The end of last year, a
> major kernel maintainer had an accident that caused him to leave the
> community for several months.
> 
> As with all Open Source projects, the Linux kernel is not a product from
> a company, but it comes from a community. A community made up of people,
> where a single person has large control over vital parts of the kernel.
> Some parts of the kernel is held by several people, but there are
> several people that I could imagine would cause severe disruption if
> something were to happen to them. Do we all have backups that can take
> over if something unexpected happen to us?
> 
> We are not getting any younger. Life's reality is that we can perish at
> any time. I would like to discuss ways that we can help the community to
> move forward in case something happens to any one of us.
> 
> Perhaps we should all have someone as a backup? Let others know who you
> trust to work as the maintainer if something were to happen to you. We
> can have limits to what that person can do in case you are still around
> but only monumentally incapacitated.

I agree this is an important thing to do, but I'm hesitant about
having someone formally annointed as "the successor".  Information in
the MAINTAINERS file can get stale, and removing someone who may not
have as much time, and so has become a bit inactive, and replacing him
or her with someone who might be more active, is a political act which
can cause feelings to be hurt or otherwise lead to drama.

It's for the same reason that we don't have a formally designated
"core team", although people have a pretty good idea who the core
developers are.

That being said, maintainers would be well advised to make sure there
are other people who know enough that they could take over if
something unfortunate happens, and there are a number of ways helping
that process along, including delegating as much as possible in terms
of code reviews, etc., to other subsystem developers.

> I rather have something in place before it happens. Unfortunately, it
> will happen. It's just a matter of time.

It's happened already; for example, when Leonard Zubkoff passed
away in an unfortunate helicopter accident.

   		       	  		  - Ted

> 
> -- Steve
> 
> 
> _______________________________________________
> Ksummit-2013-discuss mailing list
> Ksummit-2013-discuss@lists.linuxfoundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/ksummit-2013-discuss
