Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3KAPyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:54:03 -0400
Received: from one.firstfloor.org ([193.170.194.197]:45420 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3KAPyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:54:01 -0400
Date: Fri, 1 Nov 2013 16:53:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 3/3] perf tools: Add -L as short option for call-graph
 for record/top commands
Message-ID: <20131101155359.GB29695@two.firstfloor.org>
References: <1383319394-19046-1-git-send-email-jolsa@redhat.com>
 <1383319394-19046-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383319394-19046-4-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 04:23:14PM +0100, Jiri Olsa wrote:
> Adding -L as short option for call-graph for record/top
> commands. Plus documentation update.

Seems overkill. I guess the long option is enough, and in perf
short options already need to be considered a precious resource,
as they may soon run out.

-Andi
