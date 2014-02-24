Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaBXRBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:01:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaBXRBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:01:16 -0500
Date: Mon, 24 Feb 2014 16:48:12 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 0/8] perf tools: Update on filtered entries'
 percentage output (v5)
Message-ID: <20140224154812.GB1130@krava.brq.redhat.com>
References: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 05:09:20PM +0900, Namhyung Kim wrote:
> Hello,
> 
> I added --percentage option to perf report to control display of
> percentage of filtered entries.
> 
>  usage: perf report [<options>]
> 
>         --percentage <relative|absolute>
>                           how to display percentage of filtered entries
> 

SNIP

> 
> 
> Namhyung Kim (8):
>   perf tools: Count periods of filtered entries separately
>   perf hists: Add support for showing relative percentage
>   perf report: Add --percentage option
>   perf top: Add --percentage option
>   perf diff: Add --percentage option
>   perf tools: Add hist.percentage config option
>   perf ui/tui: Add 'F' hotkey to toggle percentage output
>   perf tools: Show absolute percentage by default

looks like perf diff command needs more changes to work properly
with filtering.. symbol filtering shows some weird numbers

but that issue was there before.. and will be fixed.. eventually ;-)

Acked-by: Jiri Olsa <jolsa@redhat.com>
for the patchset

thanks,
jirka
