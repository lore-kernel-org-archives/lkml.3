Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837Ab3GEO6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:58:44 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:40995 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab3GEO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:58:43 -0400
Date: Fri, 5 Jul 2013 11:58:36 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH RESEND] perf sched: Move struct perf_sched definition out
 of cmd_sched()
Message-ID: <20130705145836.GD2559@ghostprotocols.net>
References: <1370324779-16921-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370324779-16921-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 04, 2013 at 02:46:19PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> For some reason it consumed quite amount of compile time when declared
> as local variable, and it disappeared when moved out of the function.
> Moving other variables/tables didn't help.
> 
> On my system this single-file-change build time reduced from 11s to 3s.

Thanks a lot, applied.

- Arnaldo
