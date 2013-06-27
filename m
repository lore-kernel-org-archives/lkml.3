Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3F0JgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:36:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52108 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3F0JgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:36:24 -0400
Date: Thu, 27 Jun 2013 11:36:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tools: Fixup for removing -f option in perf record
Message-ID: <20130627093609.GO28407@twins.programming.kicks-ass.net>
References: <1372307120-737-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372307120-737-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 01:25:20PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The commit bf3da4014a0c ("perf record: Remove -f/--force option") got
> rid of -f option from perf record.  But this option was used
> internally by various sub-commands so they wouldn't work anymore.
> Also update the example document not to use -f option.

Oh man.. we got rid of -f? Do we now default to over-write existing data
file?
