Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbbAGXQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:16:34 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:38858 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbbAGXQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:16:31 -0500
Date: Wed, 7 Jan 2015 18:16:27 -0500
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
Message-ID: <20150107231627.GB28630@htj.dyndns.org>
References: <54AB2992.6060707@nod.at>
 <CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
 <54ACFC38.5070007@nod.at>
 <87fvbmir9q.fsf@x220.int.ebiederm.org>
 <20150107193059.GA1857@mail.hallyn.com>
 <87bnma6xwv.fsf@x220.int.ebiederm.org>
 <20150107224430.GA28414@htj.dyndns.org>
 <878uhe42km.fsf@x220.int.ebiederm.org>
 <20150107230615.GA28630@htj.dyndns.org>
 <87fvbm2nni.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvbm2nni.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 05:09:53PM -0600, Eric W. Biederman wrote:
> I may have mistyped the manual command line configuration for specifying
> which controllers appear on a mount point does not alter my point.

Hmmm?  You were talking about the old hierarchies?

> The old options to enable selecting controllers need to continue and
> need to continue to work with a unified hierarchy.
> 
> Anything else is a gratuitious regression.

I have no idea what you're on about.  If the outer system uses unified
hierarchy, the inner system should use that too.  If the outer system
doesn't use unified hierarchy, namespace support has never existed,
and even if it did, the inside could never pick and choose controllers
independent from the outside.  If the outside is co-mounting cpu and
cpuacct, the inside is either also doing that or not mounting either.

-- 
tejun
