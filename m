Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbaHVOsC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:48:02 -0400
Received: from mail.kernel.org ([198.145.19.201]:57599 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153AbaHVOsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:48:00 -0400
Date: Fri, 22 Aug 2014 11:47:55 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 2/2] perf hists browser: Consolidate callchain print
 functions in TUI
Message-ID: <20140822144755.GA3473@kernel.org>
References: <1408583746-5540-1-git-send-email-namhyung@kernel.org>
 <1408583746-5540-3-git-send-email-namhyung@kernel.org>
 <20140821154353.GL2892@kernel.org>
 <20140822080236.GB7714@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822080236.GB7714@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 22, 2014 at 10:02:36AM +0200, Ingo Molnar escreveu:
> > > +struct callchain_print_arg {
> > > +	/* for hists browser */
> > > +	unsigned short row;
> > > +	off_t row_offset;
> > > +	bool is_current_entry;
> > > +
> > > +	/* for file dump */
> > > +	FILE *fp;
> > > +	int printed;
> > > +};
> 
> Just a data type definition nitpicking pet peeve of mine, don't 
> you guys too find this vertically aligned form infinitely more 
> readable:
> 
> struct callchain_print_arg {
> 	/* for hists browser */
> 	unsigned short	row;
> 	off_t		row_offset;
> 	bool		is_current_entry;
> 
> 	/* for file dump */
> 	FILE		*fp;
> 	int		printed;
> };
> 
> especially when looking at it via email, without syntax 
> highlighting?

Agreed, will make it so when applying it.

- Arnaldo
