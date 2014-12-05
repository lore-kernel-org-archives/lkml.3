Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112AbaLEPhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:37:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbaLEPhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:37:09 -0500
Date: Fri, 5 Dec 2014 13:36:49 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/8] perf tools: Add --buildid-dir option to set cache
 directory
Message-ID: <20141205153649.GC2285@redhat.com>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
 <1417460789-13874-4-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417460789-13874-4-git-send-email-jolsa@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 01, 2014 at 08:06:24PM +0100, Jiri Olsa escreveu:
> Adding --buildid-dir to be able to set specific cache
> directory. It's going to be handy for buildid tests
> coming in shortly.

Thanks, applied.
