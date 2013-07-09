Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3GIUuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 16:50:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab3GIUuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 16:50:01 -0400
Date: Tue, 9 Jul 2013 22:49:13 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [RFC 0/4] perf tools: Remove event types data
Message-ID: <20130709204913.GA24176@krava.brq.redhat.com>
References: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 06:48:55PM +0200, Jiri Olsa wrote:
> hi,
> following up on the 'perf timechart' FIXME note and changing
> its tracepoint match not to use event types data.
> 
> In my tests the old and new timechart outputs look the same,
> so.. any other tester would be appreciated ;-)
> 
> Also as this was the only user of the event types data
> the rest of the patchset is removing it out of the perf.
> 
> The event types data are referenced from the perf data
> file header. The reference (offset & size) stays in the
> header with 0s.
> 
> Also the event types data is already duplicated via the
> event_desc FEATURE, so there's no information loss.
> 
> thanks for comments,
> jirka

forgot to mention, it's available at:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/et1

jirka
