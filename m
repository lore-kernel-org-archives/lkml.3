Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3JMFXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 01:23:35 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46740 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3JMFXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 01:23:34 -0400
Date: Sun, 13 Oct 2013 07:23:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
Message-ID: <20131013052328.GA22563@gmail.com>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <20131011055829.GA4975@gmail.com>
 <20131011073448.GA11064@krava.redhat.com>
 <52581511.2010909@gmail.com>
 <52581737.8090309@gmail.com>
 <20131012165319.GB15116@gmail.com>
 <5259A63B.5050406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5259A63B.5050406@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 10/12/13 10:53 AM, Ingo Molnar wrote:
> >
> >* David Ahern <dsahern@gmail.com> wrote:
> >
> >>On 10/11/13 9:11 AM, David Ahern wrote:
> >>>It would be nice to fix the callchain arg handler to not attempt to
> >>>process the next argument if it is not fp or dwarf.
> >>
> >>Specifically, something like this which maintains syntax and default
> >>fp option:
> >
> >Lets not maintain a broken syntax please - breaking the very simple -ga
> >was the primary regression to begin with, so lets fix that.
> 
> I think I did with the second follow up patch: -ga -ag -g fp -g
> dwarf should all work properly with fp the default for -g.

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
