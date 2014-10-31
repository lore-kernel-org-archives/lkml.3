Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbaJaIgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:36:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaJaIgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:36:11 -0400
Date: Fri, 31 Oct 2014 09:34:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, acme@kernel.org,
        namhyung@kernel.org, mmarek@suse.cz,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v4 04/14] perf tools: Add kbuild support into
 Makefile.kbuild
Message-ID: <20141031083427.GB27472@krava.brq.redhat.com>
References: <20141024124601.GX14687@kernel.org>
 <1414275639-1053-5-git-send-email-alexis.berlemont@gmail.com>
 <20141029081603.GC3538@krava.brq.redhat.com>
 <20141029230507.GA15701@marx-slim.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029230507.GA15701@marx-slim.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:05:07AM +0100, Alexis Berlemont wrote:

SNIP

> > >  tools/perf/util/Kbuild                             | 126 ++++++
> > >  tools/perf/util/PERF-VERSION-GEN                   |   4 +
> > >  tools/perf/util/generate-cmdlist.sh                |   8 +-
> > >  tools/perf/util/scripting-engines/Kbuild           |  11 +
> > >  tools/perf/util/setup.py                           |   8 +-
> > 
> > so this patch took the perf Makefile (at that time) and changed it to
> > use the kbuild.. but since that time the Makefile.perf came and many
> > other changes, which need to be reflected in Makefile.kbuild
> > 
> > I need to revisit the logic and split the change into more incremental
> > patches (the patchset is too big)
> > 
> > I can redo patches 2,3,4 and get back to you, sounds ok?
> 
> Of course. 
> 
> Which changes in Makefile.perf do you have in mind ? I thought that
> Makefile.kbuild was just supposed to build the few extra dependencies
> (libtraceevent, etc.). I thought that I updated your original patch
> accordingly with the changes before and after the add of
> Makefile.perf.

hm, I just stumbled on QUIET_* stuff definitions in Makefile.kbuild,
(which got moved into scripts some time ago) and assumed this was
the case for the rest of the file ;-)

jirka
