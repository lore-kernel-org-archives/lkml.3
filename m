Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3EXNpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 09:45:22 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:57025 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3EXNpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 09:45:21 -0400
Date: Thu, 23 May 2013 12:01:33 +0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 04/14] perf tools: Centralize default columns init in
 perf_hpp__init
Message-ID: <20130523100133.GC3064@ghostprotocols.net>
References: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
 <1355404152-16523-5-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355404152-16523-5-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 13, 2012 at 02:09:02PM +0100, Jiri Olsa escreveu:
> Now when diff command is separated from other standard outputs,
> we can use perf_hpp__init to initialize all standard columns.
> 
> Moving PERF_HPP__OVERHEAD column init back to perf_hpp__init,
> and removing extra enable calls.

Also doesn't apply, couldn't find this function:

void perf_gtk__init_hpp(void);

But it has a prototype in tools/perf/ui/gtk/gtk.h, perhaps its one of
those macro templates? Leftover? please check,

- Arnaldo
