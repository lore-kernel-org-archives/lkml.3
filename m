Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3DZQY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:24:58 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:44165 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3DZQY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:24:57 -0400
Date: Fri, 26 Apr 2013 20:24:44 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Borislav Petkov <bp@alien8.de>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, tytso@mit.edu,
        davem@davemloft.net, fweisbec@gmail.com, oleg@redhat.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel/P4: Robistify P4 PMU types
Message-ID: <20130426162444.GC17430@moon>
References: <20130424072630.GB1780@gmail.com>
 <tip-5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886@git.kernel.org>
 <20130426161328.GA16818@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426161328.GA16818@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 06:13:28PM +0200, Borislav Petkov wrote:
> 
> I have a P4 and I turn it on from time to time when it's cold in the
> room :-).
> 
> Any particular tests you want me to run on it?
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 15
> model           : 2
> model name      : Intel(R) Pentium(R) 4 CPU 2.60GHz

Cool! Easiest way I think is to run "perf top" (iirc that's the
command for top-like output). And if possible some branch instructions
testing.
