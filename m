Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3JWUE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 16:04:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:47192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab3JWUE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:04:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="397512165"
Message-ID: <1382558695.3000.29.camel@empanada>
Subject: Re: Perf Python Scripting Leaks Memory
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org
Date: Wed, 23 Oct 2013 15:04:55 -0500
In-Reply-To: <20131023200149.GA6539@ghostprotocols.net>
References: <5267DF35.5010706@tu-dresden.de>
	 <20131023200149.GA6539@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-23 at 17:01 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Oct 23, 2013 at 04:37:41PM +0200, Joseph Schuchart escreveu:
> >    We are using the Python scripting interface in perf to extract kernel
> >    events relevant for performance analysis of HPC codes. We noticed that the
> >    "perf script" call allocates a significant amount of memory (in the order
> >    of several 100 MiB) during it's run, e.g. 125 MiB for a 25 MiB input file:
> 
> Thanks for the analysis and the bug fix!
> 
> I asked Tom Zanussi and he kindly reviewed your patch and provided an
> Acked-by tag for it, Tom, may I add a Reviewed-by: as well?
> 

Sure.

Reviewed-by: <tom.zanussi@linux.intel.com>

Tom

> Joseph, can I have your Signed-off-by: tag, as documented in:
> 
> Documentation/SubmittingPatches
> 
> In the "12) Sign your work" section?
> 
> Thanks!
> 
> - Arnaldo


