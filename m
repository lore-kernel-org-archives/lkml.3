Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3GGOp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 10:45:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab3GGOp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 10:45:58 -0400
Date: Sun, 7 Jul 2013 16:45:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH RESEND] perf sched: Move struct perf_sched definition out
 of cmd_sched()
Message-ID: <20130707144538.GC23433@krava.brq.redhat.com>
References: <1370324779-16921-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370324779-16921-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 02:46:19PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> For some reason it consumed quite amount of compile time when declared
> as local variable, and it disappeared when moved out of the function.
> Moving other variables/tables didn't help.
> 
> On my system this single-file-change build time reduced from 11s to 3s.

cooool.. I spent some time wondering what was the reason in the past, nice! :-)

jirka
