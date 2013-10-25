Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3JYTKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 15:10:02 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:63314 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3JYTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 15:10:00 -0400
Date: Fri, 25 Oct 2013 16:09:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: RFP: Fixing "-ga -ag -g fp -g dwarf" was Re: [PATCHSET 0/8] perf
 tools: Fix scalability problem on callchain merging (v5)
Message-ID: <20131025190951.GC1853@ghostprotocols.net>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <20131011055829.GA4975@gmail.com>
 <20131011073448.GA11064@krava.redhat.com>
 <52581511.2010909@gmail.com>
 <52581737.8090309@gmail.com>
 <20131012165319.GB15116@gmail.com>
 <5259A63B.5050406@gmail.com>
 <20131013052328.GA22563@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131013052328.GA22563@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Oct 13, 2013 at 07:23:28AM +0200, Ingo Molnar escreveu:
> * David Ahern <dsahern@gmail.com> wrote:
> > On 10/12/13 10:53 AM, Ingo Molnar wrote:
> > >* David Ahern <dsahern@gmail.com> wrote:
> > >>On 10/11/13 9:11 AM, David Ahern wrote:
> > >>>It would be nice to fix the callchain arg handler to not attempt to
> > >>>process the next argument if it is not fp or dwarf.

> > >>Specifically, something like this which maintains syntax and default
> > >>fp option:

> > >Lets not maintain a broken syntax please - breaking the very simple -ga
> > >was the primary regression to begin with, so lets fix that.

> > I think I did with the second follow up patch: -ga -ag -g fp -g
> > dwarf should all work properly with fp the default for -g.

> Acked-by: Ingo Molnar <mingo@kernel.org>

Can I have this one submitted?

I guess I found it but it was malformed, didn't apply.

- Arnaldo
