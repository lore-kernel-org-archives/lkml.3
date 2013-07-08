Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3GHPSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:18:20 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:49008 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3GHPSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:18:18 -0400
Date: Mon, 8 Jul 2013 12:18:10 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf tools: Fix boolean for NO_LIBPYTHON=1 NO_LIBPERL=1
 build
Message-ID: <20130708151810.GA3028@ghostprotocols.net>
References: <1373205339-17550-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373205339-17550-1-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jul 07, 2013 at 03:55:39PM +0200, Jiri Olsa escreveu:
> The build is broken for 'NO_LIBPYTHON=1 NO_LIBPERL=1' switches.
> 
> The reason is that without perl and python support we
> dont have TRUE/FALSE macro definitions in dso and vdso
> objects (added there by commit 7821317).
> 
> Using stdbool.h defines instead which seems to be more
> common in perf code anyway.

Thanks, applied.

- Arnaldo
