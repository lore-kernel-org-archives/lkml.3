Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab3HAISM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:18:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46442 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3HAISI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:18:08 -0400
Date: Thu, 1 Aug 2013 10:17:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 0/9] perf tools: Enhance and correct srcline behavior
Message-ID: <20130801081759.GI3008@twins.programming.kicks-ass.net>
References: <1375325744-26613-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375325744-26613-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 11:55:35AM +0900, Namhyung Kim wrote:
> Hello,
> 
> This patchset tries to fix and enhance current srcline behavior.
> 
> Firstly it doesn't actually sort by srcline info but by ip.  I suspect
> it was because of a performance reason to run external addr2line
> utility.  It showed the srcline info after hist entries were
> collapsed.  Thanks to Roberto, we now have internal implementation of
> addr2line using libbfd so can sort/compare by srcline of entries.

Sweet..
