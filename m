Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbbAGXGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:06:22 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:36171 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbbAGXGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:06:19 -0500
Date: Wed, 7 Jan 2015 18:06:15 -0500
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
Message-ID: <20150107230615.GA28630@htj.dyndns.org>
References: <87lhlgpyxk.fsf@x220.int.ebiederm.org>
 <CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
 <54AB2992.6060707@nod.at>
 <CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
 <54ACFC38.5070007@nod.at>
 <87fvbmir9q.fsf@x220.int.ebiederm.org>
 <20150107193059.GA1857@mail.hallyn.com>
 <87bnma6xwv.fsf@x220.int.ebiederm.org>
 <20150107224430.GA28414@htj.dyndns.org>
 <878uhe42km.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uhe42km.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 05:02:17PM -0600, Eric W. Biederman wrote:
> Ignoring namespace details for a moment. The following should be
> possible with a unified hierarchy.  If it is not it is a show stopper
> of a regression.

The -o SUBSYS option doesn't exist.  Jesus, at least get yourself
familiar with the basics before claiming random stuff.

-- 
tejun
