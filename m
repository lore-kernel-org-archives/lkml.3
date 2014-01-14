Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaANV0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:26:08 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:45377 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaANV0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:26:05 -0500
Date: Tue, 14 Jan 2014 18:25:55 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 3/5] perf report: Add --percentage option
Message-ID: <20140114212555.GE29798@ghostprotocols.net>
References: <1389674599-28227-1-git-send-email-namhyung@kernel.org>
 <1389674599-28227-4-git-send-email-namhyung@kernel.org>
 <87zjmy2ryj.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjmy2ryj.fsf@tassilo.jf.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 14, 2014 at 01:07:00PM -0800, Andi Kleen escreveu:
> Namhyung Kim <namhyung@kernel.org> writes:
> >  
> > +--percentage::
> > +	Determine how to display the overhead percentage of filtered
> > entries.
> 
> This should describe also what a "filtered entry" exactly is. It's not clear
> even to me.

Yeah, the text should give some context, mentioning the "Zoom"
operations that can be done in the TUI (DSO, thread, etc) that allows
applying what he is calling "filters".`
 
> -Andi
> 
> > +	"relative" means it's relative to filtered entries only so that the
> > +	sum of shown entries will be always 100%.  "absolute" means it retains
> > +	original value before and after the filter applied.
> > +
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only
