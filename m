Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab3HAT0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:26:46 -0400
Received: from longford.logfs.org ([213.229.74.203]:59950 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab3HAT0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:26:45 -0400
Date: Thu, 1 Aug 2013 13:54:25 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, Peter Anvin <hpa@zytor.com>, dzickus@redhat.com,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched,x86: optimize switch_mm for multi-threaded
 workloads
Message-ID: <20130801175425.GB3870@logfs.org>
References: <20130731174335.006a58f9@annuminas.surriel.com>
 <CA+55aFx3ZHZrgP3yQwb=ttYUeH1zFVQtUA5dFW1h8FPhjfKgUA@mail.gmail.com>
 <51F98CAB.80100@redhat.com>
 <CA+55aFwj+6P4y8MgGTGbiK_EtfY7LJ_bL_7k9zFYLx4S8F0rJQ@mail.gmail.com>
 <51F99218.4060104@redhat.com>
 <CA+55aFxKSEHSkdsCkTvjwwo4MnEpN0TwJrek2jd1QJCyUTb-=Q@mail.gmail.com>
 <51F999DE.7080200@redhat.com>
 <20130801153727.GA3870@logfs.org>
 <CA+55aFx+_35OosBzwSmwAiw1xuRw5=i4vaSpjxuEc5xqvLZ_Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFx+_35OosBzwSmwAiw1xuRw5=i4vaSpjxuEc5xqvLZ_Rg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 August 2013 10:45:15 -0700, Linus Torvalds wrote:
> On Thu, Aug 1, 2013 at 8:37 AM, Jörn Engel <joern@logfs.org> wrote:
> >
> > Looks like two of Linus' mails didn't make it to vger.kernel.org.
> > They are missing from my inbox and seem to be missing from lkml.org as
> > well.  I only know noticed them because Rik seemingly replied to
> > himself while quoting Linus.
> 
> It's normal.

I agree with everything in your email except this bit.  Even though
technically it is normal now that all email clients are broken in
impressive ways, your words imply that this might even remotely be an
acceptable state of the world.  It is not.

Four-letter words directed at Google (and Apple, and...) seem more
appropriate.

Jörn

--
"Security vulnerabilities are here to stay."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001
