Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbaHAUIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:08:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:57224 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbaHAUH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:07:59 -0400
Date: Fri, 1 Aug 2014 17:07:53 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf kmem: Do not ignore mmap events
Message-ID: <20140801200753.GD20547@kernel.org>
References: <1406872771-23933-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406872771-23933-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 01, 2014 at 02:59:31PM +0900, Namhyung Kim escreveu:
> The perf kmem command didn't process mmap events for some unknown
> reason and it instead gets symbol info from a running kernel.  This is
> problematic if perf kmem record was run on a different kernel.
> 
> This patch adds the mmap event handlers and reverts the commit
> e727ca73f85d ("perf kmem: Resolve kernel symbols again").
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Thanks, applied.

- Arnaldo
