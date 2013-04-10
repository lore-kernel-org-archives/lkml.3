Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937078Ab3DJJsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:48:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50876 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935049Ab3DJJsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:48:19 -0400
Message-ID: <1365587287.30071.34.camel@laptop>
Subject: Re: [PATCH RESEND 0/3] perf, amd: Support for Family 16h L2I
 Performance Counters
From: Peter Zijlstra <peterz@infradead.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 11:48:07 +0200
In-Reply-To: <1365586878.30071.33.camel@laptop>
References: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
	 <1365586878.30071.33.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 11:41 +0200, Peter Zijlstra wrote:
> On Tue, 2013-04-09 at 10:23 -0500, Jacob Shin wrote:
> > Upcoming AMD Family 16h Processors provide 4 new performance counters
> > to count L2 related events. Similar to northbridge counters, these new
> > counters are shared across multiple CPUs that share the same L2 cache.
> > This patchset adds support for these new counters and enforces sharing
> > by leveraging the existing sharing logic used for the northbridge
> > counters.
> 
> If they're separate counters -- not shared with the regular cpu
> counters like the 10h NB counters are, then they should have their own
> PMU driver.
> 
> Similar to the 15h NB counters; which are a separate set of counters
> and no longer overlay the normal counters.

Related; where's the 16h BKDG?

