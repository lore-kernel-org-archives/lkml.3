Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaEDRyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:54:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbaEDRyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 13:54:01 -0400
Date: Sun, 4 May 2014 19:53:34 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCHSET 00/17] perf report: Add -F option for specifying
 output fields (v4)
Message-ID: <20140504175334.GB1197@krava.brq.redhat.com>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 12:05:37PM +0900, Namhyung Kim wrote:

SNIP

> 
>  * changes in v4:
>   - fix a tui navigation bug
>   - fix a bug in output change of perf diff
>   - move call to perf_hpp__init() out of setup_browser()
>   - fix alignment of some output fields on stdio
> 
>  * changes in v3:
>   - rename to --fields option for consistency  (David)
>   - prevent to add same keys multiple times
>   - change dso sorting to show unknown dsos last
>   - fix minor bugs
> 
>  * changes in v2:
>   - add a cleanup patch using ui__has_annotation()
>   - cleanup default sort order managment
>   - support perf top also
>   - handle elided sort entries properly
>   - add Acked-by's from Ingo
> 
> 
> I pushed the patch series on the 'perf/field-v4' branch in my tree
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

hi,
I tried to merge this with my latest perf/core and got
some conflicts. Looks like it's missing the latest hist
code changes.. could you please rebase?

thanks,
jirka
