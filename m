Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbaFSKfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 06:35:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbaFSKfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:35:06 -0400
Date: Thu, 19 Jun 2014 12:34:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 00/18] perf tools: Factor ordered samples queue
Message-ID: <20140619103448.GA7619@krava.brq.redhat.com>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
 <53A1EC2E.1010706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A1EC2E.1010706@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 01:44:46PM -0600, David Ahern wrote:

SNIP

> >
> >Also now we have one of our big memory spender under control
> >and the ordered events queue code is put in separated object
> >with clear interface ready to be used by another command
> >like script.
> >
> >Also reachable in here:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> >   perf/core_ordered_events
> >
> 
> I've skimmed through the patches. What happens if you are in the middle of a
> round and the max queue size is reached?

half of the queue (time half) is flushed to make some free space

> I need to find some time for a detailed review, and to run through some
> stress case scenarios. e.g., a couple that come to mind
> perf sched record -- perf bench sched pipe
> perf kvm record while booting a nested VM which causes a lot of VMEXITs

will try.. at least the first one ;-)

thanks for looking on this,
jirka
