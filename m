Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaG2FCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 01:02:46 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60057 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaG2FCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 01:02:45 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 29 Jul 2014 14:02:46 +0900
From: Minchan Kim <minchan@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/2] perf tools: Ensure --symfs ends with '/'
Message-ID: <20140729050246.GC22707@bbox>
References: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 10:31:47AM +0900, Namhyung Kim wrote:
> Minchan reported that perf failed to load vmlinux if --symfs argument
> doesn't end with '/' character.  So make sure that the symfs always
> ends with the '/'.
> 
> Reported-by: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Both patches work and are handy to me.
Thanks Namhyung.


-- 
Kind regards,
Minchan Kim
