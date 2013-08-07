Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab3HGUeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:34:46 -0400
Received: from mail-gh0-f176.google.com ([209.85.160.176]:47803 "EHLO
	mail-gh0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab3HGUep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:34:45 -0400
X-Greylist: delayed 1092 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Aug 2013 16:34:45 EDT
Date: Wed, 7 Aug 2013 17:34:37 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] perf kvm: option to print events that exceed a
 threshold
Message-ID: <20130807203437.GJ2665@ghostprotocols.net>
References: <1375753297-69645-1-git-send-email-dsahern@gmail.com>
 <1375753297-69645-5-git-send-email-dsahern@gmail.com>
 <20130807192725.GD2665@ghostprotocols.net>
 <5202ACF7.3020400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5202ACF7.3020400@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 07, 2013 at 04:24:23PM -0400, David Ahern escreveu:
> On 8/7/13 3:27 PM, Arnaldo Carvalho de Melo wrote:
> >Em Mon, Aug 05, 2013 at 09:41:36PM -0400, David Ahern escreveu:
> >So 'perf trace' has a similar option:
> >
> >[acme@zoo linux]$ perf trace --help
> ><SNIP>
> >         --duration <float>
> >                           show only events with duration > N.M ms
> ><SNIP>
> >
> >While you used:
> >
> >>+		OPT_U64('T', "threshold", &kvm->threshold,
> >>+		    "show events other than HALT that take longer than threshold usecs"),
> >
> >I prefer 'duration', and haven't assigned a single letter to it, they
> >are scarce and we have shell long option completion, what do you think?
> >
> >The term was chosen, for 'perf trace' on the original patchset:
> >
> >http://lwn.net/Articles/415728/
 
> No preference really. I need to send out an update to the man page.
> I can update this patch as well and re-send.

Please. I applied all the other patches, just wait a bit before I run
'male -C tools/perf -f tests/make' on my perf/core before I push it out.

- Arnaldo
