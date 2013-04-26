Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3DZQq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:46:57 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40439 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab3DZQq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:46:56 -0400
Date: Fri, 26 Apr 2013 20:46:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Borislav Petkov <bp@alien8.de>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, tytso@mit.edu,
        davem@davemloft.net, fweisbec@gmail.com, oleg@redhat.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel/P4: Robistify P4 PMU types
Message-ID: <20130426164652.GO13008@moon>
References: <20130424072630.GB1780@gmail.com>
 <tip-5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886@git.kernel.org>
 <20130426161328.GA16818@pd.tnic>
 <20130426162444.GC17430@moon>
 <20130426163952.GC15361@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426163952.GC15361@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 06:39:52PM +0200, Borislav Petkov wrote:
>                                              #    0.25  stalled cycles per insn
>            590,855 branches                  #  237.877 M/sec
>             12,882 branch-misses             #    2.18% of all branches
> 	    ^^^^^^^^^^^^^^^^^^^^
> 
> Those above?

Yeah, thanks!
