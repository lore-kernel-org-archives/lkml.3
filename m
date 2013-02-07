Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab3BGTJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:09:33 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:38141 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab3BGTJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:09:27 -0500
Date: Thu, 7 Feb 2013 20:09:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] perf, amd: Enable northbridge performance counters
 on AMD family 15h
Message-ID: <20130207190921.GC25223@gmail.com>
References: <1360171589-6381-1-git-send-email-jacob.shin@amd.com>
 <1360171589-6381-7-git-send-email-jacob.shin@amd.com>
 <20130207175703.GA3398@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207175703.GA3398@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jacob Shin <jacob.shin@amd.com> wrote:

> On Wed, Feb 06, 2013 at 11:26:29AM -0600, Jacob Shin wrote:
> > On AMD family 15h processors, there are 4 new performance counters
> > (in addition to 6 core performance counters) that can be used for
> > counting northbridge events (i.e. DRAM accesses). Their bit fields are
> > almost identical to the core performance counters. However, unlike the
> > core performance counters, these MSRs are shared between multiple
> > cores (that share the same northbridge). We will reuse the same code
> > path as existing family 10h northbridge event constraints handler
> > logic to enforce this sharing.
> > 
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> 
> Hi Ingo, could you please apply this one to tip as well? I 
> recieved tip-bot emails for all other patches in this series 
> except for this last one 6/6.
> 
> Or was that intentional? If so, what other changes are 
> required/ recommended?

Was waiting for Stephane's ack.

Thanks,

	Ingo
