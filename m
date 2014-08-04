Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaHDPxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:53:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:37736 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaHDPx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:53:28 -0400
Date: Mon, 4 Aug 2014 12:35:32 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v3 2/2] perf tools: Default to python version 2
Message-ID: <20140804153532.GF13375@kernel.org>
References: <1406617040-26909-1-git-send-email-namhyung@kernel.org>
 <1406617040-26909-2-git-send-email-namhyung@kernel.org>
 <20140801202149.GB13375@kernel.org>
 <53DCC3F0.6000105@tu-dresden.de>
 <20140802132013.GC13375@kernel.org>
 <53DF8493.6070206@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DF8493.6070206@tu-dresden.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 04, 2014 at 03:03:15PM +0200, Thomas Ilsche escreveu:
> On 2014-08-02 15:20, Arnaldo Carvalho de Melo wrote:
> > Maybe the way python was packaged on f14 is problematic, as you
> > describe, but the fact is that python support is not working on that
> > platform after this patch.
> > 
> > Could you please try to prepare a patch that does as you suggest so that
> > I can try?
> 
> Please try the patch below.
> I tested (compiles and perf script runs) with the combinations:

Thanks, now it works (my perf/core branch + this patch) on:

fedora14 x86_64
fedora19 x86_64
fedora20 x86_64
RHEL6.3 x86_64
opensuse12.3 i386
ubuntu13.10 x86_64 

- Arnaldo
