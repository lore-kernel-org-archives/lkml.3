Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3EaMVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:21:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42877 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab3EaMV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:21:26 -0400
Date: Fri, 31 May 2013 14:21:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130531122136.GA17843@nazgul.tnic>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <20130531091540.GH14076@nazgul.tnic>
 <20130531093210.GC2132@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130531093210.GC2132@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 11:32:10AM +0200, Robert Richter wrote:
> Hmm, since the changes in the onliner patches are either hard effort
> to find in reviewing/testing or more or less related to the new
> implementation, I better prefer to keep authorship as well to document
> the code development (don't blame me about patch count ;)). We better
> should add a branch (preferable at topic branch in tip?) as soon as
> possible for this.

Yes, you should definitely keep authorship - simply state this in the
commit message, add your SOB, etc. However, I don't want to have messy
history for patches which haven't been reviewed yet. This complicates
review needlessly and makes absolutely no sense for later when you stare
at the history.

Thanks.
