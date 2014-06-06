Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaFFPGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:06:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:56403 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbaFFPGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:06:21 -0400
Date: Fri, 6 Jun 2014 12:06:16 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/2] perf/tests improvements
Message-ID: <20140606150616.GJ3696@kernel.org>
References: <1402063909-13859-1-git-send-email-acme@kernel.org>
 <20140606145106.GB8865@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606145106.GB8865@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 06, 2014 at 04:51:11PM +0200, Jiri Olsa escreveu:
> On Fri, Jun 06, 2014 at 11:11:47AM -0300, Arnaldo Carvalho de Melo wrote:
> > Hi Jiri,
> > 
> > 	Experimenting with more topic branches, this time for things you're the
> > are the original developer and de facto maintainer, the tools/perf/tests/ harness.
> > 
> > 	This was done on top of your perf/core branch, please let me know if all is
> > ok and then you can try pulling from it or perhaps you could just ack it and then
> > Ingo could pull it directly, opinions? Ingo?
> 
> either way works for me,

Ok, I'll fix up the problem you mentioned and refresh the branch.

- Arnaldo
