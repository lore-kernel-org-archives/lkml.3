Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaILUsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:48:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:40133 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaILUsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:48:33 -0400
Date: Fri, 12 Sep 2014 17:48:29 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Borislav Petkov <bp@suse.de>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 11/14] tools lib api: Adopt fdarray class from perf's
 evlist
Message-ID: <20140912204829.GB11199@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-12-git-send-email-acme@kernel.org>
 <20140912125822.GA23205@krava.brq.redhat.com>
 <20140912134429.GF1801@kernel.org>
 <20140912141631.GA22187@krava.brq.redhat.com>
 <20140912142225.GI1801@kernel.org>
 <20140912165406.GA7139@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912165406.GA7139@nazgul.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 12, 2014 at 06:54:07PM +0200, Borislav Petkov escreveu:
> On Fri, Sep 12, 2014 at 11:22:25AM -0300, Arnaldo Carvalho de Melo wrote:
> > Yeah, to me as well, but then zfree() was such a nice pick and looked ok
> > at the time :-)
> > 
> > I'm leaving this for later, different patchkit that would sweep thru
> > tools/ and find this pattern, make it use freez() (or some other name),
> > etc.
> 
> freez() sounds like something gets frozen :-P and not freed.

ok, note taken.

I liked it when trying something different from zfree().

I'm not that successfull at landgrabs recently, people at Fedora don't
want to use the 'trace' alias for 'perf trace', even it not being used
by anybody so far.

Ideas of how to name zfree()?

- Arnaldo
