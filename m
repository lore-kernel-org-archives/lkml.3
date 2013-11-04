Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3KDRTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:19:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3KDRTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:19:12 -0500
Date: Mon, 4 Nov 2013 18:18:33 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 3/3] perf tools: Add -L as short option for call-graph
 for record/top commands
Message-ID: <20131104171833.GE2805@krava.brq.redhat.com>
References: <1383319394-19046-1-git-send-email-jolsa@redhat.com>
 <1383319394-19046-4-git-send-email-jolsa@redhat.com>
 <20131101155359.GB29695@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101155359.GB29695@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 04:53:59PM +0100, Andi Kleen wrote:
> On Fri, Nov 01, 2013 at 04:23:14PM +0100, Jiri Olsa wrote:
> > Adding -L as short option for call-graph for record/top
> > commands. Plus documentation update.
> 
> Seems overkill. I guess the long option is enough, and in perf
> short options already need to be considered a precious resource,
> as they may soon run out.

I guess you're right here.. Ingo? I think you wanted this one

jirka
