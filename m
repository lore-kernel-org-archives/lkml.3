Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161414Ab3FUNem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 09:34:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39042 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161061Ab3FUNel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 09:34:41 -0400
Date: Fri, 21 Jun 2013 10:34:37 -0300
From: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
To: Robert Richter <rric@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix output directory of Documentation/
Message-ID: <20130621133437.GA2837@ghostprotocols.net>
References: <1367865614-30876-1-git-send-email-rric@kernel.org>
 <20130620134154.GC1083@krava.brq.redhat.com>
 <20130620152603.GC4767@ghostprotocols.net>
 <20130621124939.GB11635@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621124939.GB11635@rric.localhost>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 21, 2013 at 02:50:20PM +0200, Robert Richter escreveu:
> Jiri and Arnaldo,
> 
> On 20.06.13 12:26:03, Arnaldo Carvalho de Melo wrote:
> > Robert, so this one is with:
> > 
> > 	cd tools/perf
> > 	make install-doc
> > 
> > I tested with:
> > 
> > 	make -C tools/perf O=/tmp/build/perf install-doc
> > 
> > and it works, so it is just the in tree build that fails.
> 
> The patch below fixes this. Thanks for reporting.

Ok, I'll fold that with the previous one before pushing to Ingo,

Thanks!

- Arnaldo
