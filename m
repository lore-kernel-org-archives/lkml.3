Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaKNIX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:23:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbaKNIXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:23:55 -0500
Date: Fri, 14 Nov 2014 09:23:30 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: kan.liang@intel.com, acme@kernel.org, a.p.zijlstra@chello.nl,
        eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org
Subject: Re: [PATCH V2 2/3] perf tool: re-organize
 thread__resolve_callchain_sample
Message-ID: <20141114082330.GA12193@krava.redhat.com>
References: <1415837895-10275-1-git-send-email-kan.liang@intel.com>
 <1415837895-10275-3-git-send-email-kan.liang@intel.com>
 <20141113182123.GA6309@krava.redhat.com>
 <20141113184810.GC4358@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113184810.GC4358@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:48:10AM -0800, Andi Kleen wrote:
> > Any chance you guys could sync on this? ..you're touching the
> > same code.. Andi, maybe you wouldn't mind having this patch
> > instead of your change.. looks like the only extra part is the
> > cpumode resolve.
> 
> Please just merge one of them, and the other can rebase.
> 
> Note the lbr as callgraph has been posted since nearly a year now
> (v1 was in January)
> 

Arnaldo just took it:
http://marc.info/?l=linux-kernel&m=141590608310095&w=2

Kan, please rebase once it's pushed out.

thanks,
jirka
