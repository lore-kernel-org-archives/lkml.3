Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab3K0Tkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:40:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187Ab3K0Tkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:40:31 -0500
Date: Wed, 27 Nov 2013 17:40:11 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCHv2] perf tools: Fix tags/TAGS targets rebuilding
Message-ID: <20131127194011.GB2667@infradead.org>
References: <1385464890-19876-1-git-send-email-jolsa@redhat.com>
 <20131126113108.GE2410@gmail.com>
 <20131126115043.GG1267@krava.brq.redhat.com>
 <20131126120055.GA6103@gmail.com>
 <20131126125412.GJ1267@krava.brq.redhat.com>
 <20131126161316.GA7775@gmail.com>
 <20131126231650.GA1130@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126231650.GA1130@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 27, 2013 at 12:16:50AM +0100, Jiri Olsa escreveu:
> On Tue, Nov 26, 2013 at 05:13:16PM +0100, Ingo Molnar wrote:
> 
> SNIP
> 
> > >  
> > >  #
> > >  # Needed if no target specified:
> > > +# (Except for tags and TAGS targets. The reason is that the
> > > +# Makefile does not treat tags/TAGS as targets but as files
> > > +# and thus won't rebuilt them once they are in place.)
> > 
> > s/rebuilt/rebuild
> > 
> > Btw., could we perhaps change the targets to 'ctags' and 'etags' 
> > instead? (That will make it natural to add 'gtags' in the future, 
> > should anyone want that.)
> 
> my fingers vote against removing 'make tags' (and cscope)
> dont care much about the rest though.. ;-)

Ditto, please leave 'make tags', just like that kernel.

- Arnaldo
