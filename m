Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab3LENDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:03:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab3LENC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:02:59 -0500
Date: Thu, 5 Dec 2013 14:02:20 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 28/28] perf tools: Add udis86 disassembler feature check
Message-ID: <20131205130220.GH21600@krava.brq.redhat.com>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
 <1386076182-14484-29-git-send-email-jolsa@redhat.com>
 <20131204185024.GC14788@ghostprotocols.net>
 <20131205080513.GA1251@krava.brq.redhat.com>
 <20131205092502.GA16653@gmail.com>
 <20131205094122.GA21600@krava.brq.redhat.com>
 <20131205104546.GC20283@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205104546.GC20283@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 11:45:46AM +0100, Ingo Molnar wrote:

SNIP

> > > 
> > > 1)
> > > 
> > > So, the first problem I can see is in the output:
> > > 
> > > Auto-detecting system features:
> > > ...                     backtrace: [ on  ]
> > > ...                         dwarf: [ on  ]
> > > ...                fortify-source: [ on  ]
> > > ...                         glibc: [ on  ]
> > > ...                          gtk2: [ on  ]
> > > ...                  gtk2-infobar: [ on  ]
> > > ...                      libaudit: [ on  ]
> > > ...                        libbfd: [ on  ]
> > > ...                        libelf: [ on  ]
> > > ...             libelf-getphdrnum: [ on  ]
> > > ...                   libelf-mmap: [ on  ]
> > > ...                       libnuma: [ on  ]
> > > ...                       libperl: [ on  ]
> > > ...                     libpython: [ on  ]
> > > ...             libpython-version: [ on  ]
> > > ...                      libslang: [ on  ]
> > > ...                     libunwind: [ on  ]
> > > ...                       on-exit: [ on  ]
> > > ...            stackprotector-all: [ on  ]
> > > ...                       timerfd: [ on  ]
> > > 
> > > config/Makefile:421: No udis86 support.
> > > 
> > > such a 'no XYZ support' message should only occur if a feature test 
> > > failed. _If_ we decide that 'udis86' support is required for a full 
> > > perf build then there should be a new line saying something like:
> > > 
> > > ...                        udis86: [ OFF ]
> > 
> > hum, just sent v4 that added udis86 into above list ;-)
> > 
> > So.. do we consider 'full perf build' to be build with all
> > possible libraries linked in?
> 
> So my worry is, how widely is libudis86 available in distros? What is 
> the package name on Debian/Ubuntu for example?

I did not find any.. :-\ I can see Fedora and Gentoo

thanks,
jirka
