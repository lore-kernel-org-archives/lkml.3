Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbbAGXf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:35:59 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:47053 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbbAGXf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:35:57 -0500
Date: Wed, 7 Jan 2015 18:35:53 -0500
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Message-ID: <20150107233553.GC28630@htj.dyndns.org>
References: <CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
 <54ACFC38.5070007@nod.at>
 <87fvbmir9q.fsf@x220.int.ebiederm.org>
 <20150107193059.GA1857@mail.hallyn.com>
 <87bnma6xwv.fsf@x220.int.ebiederm.org>
 <20150107224430.GA28414@htj.dyndns.org>
 <878uhe42km.fsf@x220.int.ebiederm.org>
 <20150107230615.GA28630@htj.dyndns.org>
 <87fvbm2nni.fsf@x220.int.ebiederm.org>
 <87y4peyxw5.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y4peyxw5.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 05:27:38PM -0600, Eric W. Biederman wrote:
> >> The -o SUBSYS option doesn't exist.  Jesus, at least get yourself
> >> familiar with the basics before claiming random stuff.
> 
> Oh let's see I got that command line option out of /proc/mounts and yes
> it works.  Perhaps it doesn't if I invoke unified hiearchies but the
> option does in fact exist and work.

I meant the -o SUBSYS doesn't exist for unified hierarchy.

> Now I really do need to test report regressions, and send probably send
> regression fixes.  If I understand your strange ranting I think you just
> told me that option that -o SUBSYS does work with unified hierarchies.

What?  Why would -O SUBSYS exist for unified hierarchy?  It's unified
for all controllers.

> Tejun.  I asked you specifically about this case 2 years ago at plumbers
> and you personally told me this would continue to work.  I am going to
> hold you to that.

I have no idea what you're talking about in *THIS* thread.  I'm fully
aware of what was discussed *THEN*.

> Fixing bugs is one thing.  Gratuitious regressions that make supporting
> existing user space applications insane is another.

Can you explain what problem you're actually trying to talk about
without spouting random claims about regressions?

-- 
tejun
