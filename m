Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaLQOCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:02:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:33599 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaLQOCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:02:43 -0500
Date: Wed, 17 Dec 2014 11:02:35 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 10/18] tools lib: Move asm-generic/bitops/find.h code to
 tools/include and tools/lib
Message-ID: <20141217140235.GB11607@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
 <1418749040-31807-11-git-send-email-acme@kernel.org>
 <20141217134223.GE18257@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217134223.GE18257@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 17, 2014 at 02:42:23PM +0100, Jiri Olsa escreveu:
> On Tue, Dec 16, 2014 at 01:57:12PM -0300, Arnaldo Carvalho de Melo wrote:
> > +++ b/tools/perf/Makefile.perf
> > @@ -233,6 +233,7 @@ LIB_H += ../../include/linux/stringify.h
> >  LIB_H += util/include/linux/bitmap.h
> >  LIB_H += util/include/linux/bitops.h
> >  LIB_H += ../include/asm-generic/bitops/atomic.h 
> > +LIB_H += ../include/asm-generic/bitops/find.h 
> 
> whitespace at the EOLN ;-)

How could this slip thru? /me scratches head, will check, but I thought
that I catched these things with the .git hooks, humm, three new entries
in Makefile.perf has, three doesn't :-\ Will try to plug this in my
machine setups.

- Arnaldo
