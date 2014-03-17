Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbaCQG57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 02:57:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453AbaCQG55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 02:57:57 -0400
Date: Mon, 17 Mar 2014 07:57:39 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/5] perf tests: Add tip/pid mmap automated tests
Message-ID: <20140317065739.GA2741@krava.brq.redhat.com>
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
 <1394805606-25883-2-git-send-email-jolsa@redhat.com>
 <20140314202421.GA14945@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140314202421.GA14945@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 05:24:21PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Mar 14, 2014 at 03:00:02PM +0100, Jiri Olsa escreveu:
> > Adding automated test for memory maps lookup within
> > multiple machines threads.
> 
>   CC       /tmp/build/perf/arch/x86/util/tsc.o
> tests/mmap-events.c: In function ‘mmap_events’:
> tests/mmap-events.c:157:18: error: declaration of ‘thread’ shadows a global declaration [-Werror=shadow]
> tests/mmap-events.c:46:14: error: shadowed declaration is here [-Werror=shadow]

hum, I thought this one was fixed already.. will check

> tests/mmap-events.c: In function ‘thread’:
> tests/mmap-events.c:54:7: error: ignoring return value of ‘write’, declared with attribute warn_unused_result [-Werror=unused-result]

got this one fixed in new version

thanks,
jirka
