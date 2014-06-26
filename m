Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbaFZMQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426AbaFZMQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:16:04 -0400
Date: Thu, 26 Jun 2014 14:14:33 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tool: Carve out ctype.h et al
Message-ID: <20140626121433.GA2600@krava.brq.redhat.com>
References: <1403688184-6917-1-git-send-email-bp@alien8.de>
 <20140625192547.GF1153@krava.brq.redhat.com>
 <20140625203836.GD13845@pd.tnic>
 <20140625211757.GD18773@kernel.org>
 <20140626073802.GC1177@krava.brq.redhat.com>
 <20140626103223.GB1284@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626103223.GB1284@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 12:32:23PM +0200, Borislav Petkov wrote:
> On Thu, Jun 26, 2014 at 09:38:02AM +0200, Jiri Olsa wrote:
> > yep, tip/perf/core maybe plus merges from acme/perf/core and
> > jolsa/perf/core should do it ;-)
> 
> Ok, just did this (jolsa/perf/coreas up-to-date) nd I still can't
> trigger the build failure:
> 
> commit f05523d9b9aaf18fb28acd009dc9142b2da16380
> Merge: 80f0ae409ee9 07100877ea8f
> Author: Borislav Petkov <bp@suse.de>
> Date:   Thu Jun 26 11:59:07 2014 +0200
> 
>     Merge remote-tracking branch 'acme/perf/core' into ptool-v0.5.2
> 
> commit 80f0ae409ee945d598fa982efff53d9f887cc5d5
> Merge: d7933ab727ed 2f88993d53c5
> Author: Borislav Petkov <bp@suse.de>
> Date:   Thu Jun 26 11:58:24 2014 +0200
> 
>     Merge remote-tracking branch 'tip/master' into rc2+-3
> 
> commit d7933ab727ed035bdf420d7381b831ba959cecc5
> Merge: 2a80ff867f35 ce36d9ab3bab
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Jun 25 21:47:28 2014 -0700
> 
>     Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
> 
> 
> 
> Maybe we're having different libraries installed?
> 
> Auto-detecting system features:
> ...                         dwarf: [ on  ]
> ...                         glibc: [ on  ]
> ...                          gtk2: [ on  ]
> ...                      libaudit: [ on  ]
> ...                        libbfd: [ OFF ]
> ...                        libelf: [ on  ]
> ...                       libnuma: [ on  ]
> ...                       libperl: [ on  ]
> ...                     libpython: [ on  ]
> ...                      libslang: [ on  ]
> ...                     libunwind: [ on  ]
> ...            libdw-dwarf-unwind: [ OFF ]
> ...     DWARF post unwind library: libunwind
> 
> jirka?
> 
> Here's the patch again, attached.

this one compiles ok for me

jirka
