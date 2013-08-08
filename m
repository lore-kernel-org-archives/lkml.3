Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab3HHQAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 12:00:44 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:60687 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3HHQAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:00:42 -0400
Date: Thu, 8 Aug 2013 13:00:34 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/8] perf tools: add symbol filter to struct machine
Message-ID: <20130808160034.GI6102@ghostprotocols.net>
References: <1375961547-30267-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375961547-30267-1-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 08, 2013 at 02:32:19PM +0300, Adrian Hunter escreveu:
> Here are some patches that add symbol filter to struct machine as
> we briefly discussed on irc.
> 
> The first patch puts the symbol filter on both struct machine and
> struct machines so that guest machines added later inherit the same
> symbol filter.
> 
> The next 4 patches change the tools to set the machines symbol filter.
> 
> The final 3 patches remove symbol filter as a parameter in some cases
> where it is redundant.

Thanks, applied!

- Arnaldo
