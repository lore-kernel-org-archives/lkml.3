Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3EaJc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:32:27 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:52475 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3EaJcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:32:21 -0400
Date: Fri, 31 May 2013 11:32:10 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130531093210.GC2132@rric.localhost>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <20130531091540.GH14076@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531091540.GH14076@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.05.13 11:15:40, Borislav Petkov wrote:
> On Fri, May 31, 2013 at 10:47:20AM +0200, Robert Richter wrote:
> > Patches base on Boris' patches which I have rebased to latest
> > tip/perf/core. All patches can be found here:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git persistent
> 
> Right, we should merge the fixes/changes to the persistent patches with
> the original ones since they are still WIP anyway.
> 
> Feel free to rework them as you see fit, or, I could do that when I get
> back.

Hmm, since the changes in the onliner patches are either hard effort
to find in reviewing/testing or more or less related to the new
implementation, I better prefer to keep authorship as well to document
the code development (don't blame me about patch count ;)). We better
should add a branch (preferable at topic branch in tip?) as soon as
possible for this.

-Robert
