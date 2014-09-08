Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaIHTCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:02:06 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:47996 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaIHTCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:02:04 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 8 Sep 2014 15:08:02 -0400 (EDT)
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
In-Reply-To: <20140908185115.GI6758@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1409081506510.2150@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu> <20140908185115.GI6758@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2014, Peter Zijlstra wrote:

> On Mon, Sep 08, 2014 at 01:47:11PM -0400, Vince Weaver wrote:
> > Hello
> > 
> > so I finally had time to run my perf_fuzzer again and it has rapidly 
> > turned up an alarming crash that instant-reboots my core2 test machine.
> 
> Urgh, of course :/

I can trigger it with 3.17-rc4 and 3.17-rc3 but not 3.16 so I'm attempting 
a bisection, so hopefully it turns out to be a real issue and not just 
some sort of compilation artifact.

It takes a while to compile on this machine though so it might be a day or 
so until I have the bisection results.

Vince
