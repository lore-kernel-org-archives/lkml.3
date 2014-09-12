Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaILWMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:12:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbaILWMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:12:33 -0400
Date: Sat, 13 Sep 2014 00:12:22 +0200
From: Borislav Petkov <bp@suse.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
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
Message-ID: <20140912221222.GC11443@nazgul.tnic>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-12-git-send-email-acme@kernel.org>
 <20140912125822.GA23205@krava.brq.redhat.com>
 <20140912134429.GF1801@kernel.org>
 <20140912141631.GA22187@krava.brq.redhat.com>
 <20140912142225.GI1801@kernel.org>
 <20140912165406.GA7139@nazgul.tnic>
 <20140912204829.GB11199@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140912204829.GB11199@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 05:48:29PM -0300, Arnaldo Carvalho de Melo wrote:
> I'm not that successfull at landgrabs recently, people at Fedora don't
> want to use the 'trace' alias for 'perf trace', even it not being used
> by anybody so far.

WTF, it's just a name...

> Ideas of how to name zfree()?

zo_free() for "free and zero out" maybe. I always try for the naming to
still be small rather than spelled out.

-- 
Regards/Gruss,
    Boris.
--
