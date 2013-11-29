Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3K2Sew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 13:34:52 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50006 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3K2Ser (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 13:34:47 -0500
Date: Fri, 29 Nov 2013 15:34:39 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 01/29] perf tools: Remove stackprotector feature check
Message-ID: <20131129183439.GB9876@ghostprotocols.net>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
 <1385638408-23519-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385638408-23519-2-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 28, 2013 at 12:33:00PM +0100, Jiri Olsa escreveu:
> We use -fstack-protector-all option to enable stack protecting
> for all available functions. There's no reason for enabling
> -Wstack-protector to get warning for unprotected functions.
> 
> Removing stackprotector feature check which was used to
> enable the -Wstack-protector option.

Doesn't applies to my perf/core branch.

- Arnaldo
