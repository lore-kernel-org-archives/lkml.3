Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3FBH3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 03:29:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33841 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3FBH3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 03:29:47 -0400
Date: Sun, 2 Jun 2013 09:29:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130602072958.GA20057@nazgul.tnic>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <20130531091540.GH14076@nazgul.tnic>
 <20130531093210.GC2132@rric.localhost>
 <20130531122136.GA17843@nazgul.tnic>
 <20130601161555.GE2132@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130601161555.GE2132@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 06:15:55PM +0200, Robert Richter wrote:
> Instead I reviewed the code while developing it with certain goals in
> mind. Most changes I found necessary while building and running a
> modified version during development. That never could be found in a
> patch review. These changes are what we actually want to see in git
> history.

No, we don't. Not if my patches were never a baseline to begin with.

> And your argument that changes should be merged to reduce review
> effort would actually mean to drop all the code you introduce which is
> later removed in my patches (see below for the diff stats).

Yes, absolutely, if we have to. My version is an initial functionality
proposal and nothing more. It is Work-In-Progress, and, as such, is
very much a subject to change, or even a complete rewrite - whatever it
takes.

> I also don't think we need to re-review your patches. Most of it has
> been reviewed and should also not change much to avoid rebase

No, my patches haven't really been reviewed since they've been a moving
target from the very beginning. IOW, you simply stating that fixing
bugs against code which hasn't been the base line and agreed upon
functionality in the first place, is simply unnecessary churn.

If you want to document the goals you had in mind, just write that as
a comment in the code if it is very important or put it in a commit
message.

IOW, my patches were never ready but RFC. Nothing more.

> conflicts. In my point of view they are fine to be applied to a perf
> topic branch. Ingo, would this be ok? There is no messy history if we
> later just apply my patches on top. So no, I don't agree with you here
> to merge some of my patches.

Again, my patches are simply RFC and a moving target functionality-wise.
If you feel that something was done not in the way it should be done,
then pieces of maybe even them all should be thrown away and done right.
Simply redoing them or asking me to change them is all I'm saying.

Thanks.
