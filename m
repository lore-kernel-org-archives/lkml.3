Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3FYHrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:47:39 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:39029 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3FYHri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:47:38 -0400
Date: Tue, 25 Jun 2013 09:47:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Greg Price <price@MIT.EDU>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf report: Add option to collapse undesired parts of
 call graph
Message-ID: <20130625074734.GD11420@gmail.com>
References: <20121207072726.GY22203@biohazard-cafe.mit.edu>
 <20130111052736.GG3054@ghostprotocols.net>
 <20130623031720.GW22203@biohazard-cafe.mit.edu>
 <20130623215327.GA995@krava.redhat.com>
 <20130624083253.GA28025@gmail.com>
 <20130624231426.GY22203@biohazard-cafe.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624231426.GY22203@biohazard-cafe.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg Price <price@MIT.EDU> wrote:

> > It would also be nice if all these visualization variants were available 
> > in the GTK front-end.
> 
> TBH I'm not really familiar with the GTK front-end, as I mainly use
> the TUI.  At a quick trial, it looks like --blackbox has the expected
> effect on the display there; though with or without --blackbox I can't
> seem to get the entries to expand to show me a call-graph profile, so
> it's hard to demonstrate it fully.  Not sure what I may have done
> wrong in building or running perf to make that not work (or is that
> expected?)
> 
> What changes do you have in mind to make these available in the GTK
> front-end?

I was thinking of something obvious like right-clicking it to make that 
function back boxed away or so? Have no firm ideas - maybe the GTK gents 
on Cc: know how to best integrate such features.

Thanks,

	Ingo
