Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3HARJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:09:51 -0400
Received: from longford.logfs.org ([213.229.74.203]:59944 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3HARJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:09:50 -0400
Date: Thu, 1 Aug 2013 11:37:27 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, Peter Anvin <hpa@zytor.com>, dzickus@redhat.com,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched,x86: optimize switch_mm for multi-threaded
 workloads
Message-ID: <20130801153727.GA3870@logfs.org>
References: <20130731174335.006a58f9@annuminas.surriel.com>
 <CA+55aFx3ZHZrgP3yQwb=ttYUeH1zFVQtUA5dFW1h8FPhjfKgUA@mail.gmail.com>
 <51F98CAB.80100@redhat.com>
 <CA+55aFwj+6P4y8MgGTGbiK_EtfY7LJ_bL_7k9zFYLx4S8F0rJQ@mail.gmail.com>
 <51F99218.4060104@redhat.com>
 <CA+55aFxKSEHSkdsCkTvjwwo4MnEpN0TwJrek2jd1QJCyUTb-=Q@mail.gmail.com>
 <51F999DE.7080200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51F999DE.7080200@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 July 2013 19:12:30 -0400, Rik van Riel wrote:
> On 07/31/2013 06:46 PM, Linus Torvalds wrote:
> > > On 07/31/2013 06:21 PM, Linus Torvalds wrote:

Looks like two of Linus' mails didn't make it to vger.kernel.org.
They are missing from my inbox and seem to be missing from lkml.org as
well.  I only know noticed them because Rik seemingly replied to
himself while quoting Linus.

Message-IDs in question are:
CA+55aFwj+6P4y8MgGTGbiK_EtfY7LJ_bL_7k9zFYLx4S8F0rJQ@mail.gmail.com
CA+55aFxKSEHSkdsCkTvjwwo4MnEpN0TwJrek2jd1QJCyUTb-=Q@mail.gmail.com

I find this disturbing.  Many "modern" mailers seem to be broken in 
more ways than I care to enumerate.  When I tell people, including
otherwise capable programmers, that they use a broken mailer I rarely
get more than a shrug.  But if Linus is incapable of sending mail to 
the kernel mailing list, we are in trouble indeed.  Linus, can you get
this sorted out?

Jörn

--
There are three principal ways to lose money: wine, women, and engineers.
While the first two are more pleasant, the third is by far the more certain.
-- Baron Rothschild
