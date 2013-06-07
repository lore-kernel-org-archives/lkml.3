Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3FGI4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:56:15 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61768 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab3FGI4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:56:10 -0400
X-AuditID: 9c930179-b7c1dae000003992-22-51b1a028908b
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 11/16] perf util: Parse header_page to get proper long size
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
	<1370323231-14022-12-git-send-email-namhyung@kernel.org>
	<20130606153737.GA1011@krava.brq.redhat.com>
Date: Fri, 07 Jun 2013 17:56:08 +0900
In-Reply-To: <20130606153737.GA1011@krava.brq.redhat.com> (Jiri Olsa's message
	of "Thu, 6 Jun 2013 17:37:37 +0200")
Message-ID: <87mwr22tav.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 6 Jun 2013 17:37:37 +0200, Jiri Olsa wrote:
> On Tue, Jun 04, 2013 at 02:20:26PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The header_page file describes the format of the ring buffer page
>> which is used by ftrace (not perf).  And size of "commit" field (I
>> guess it's older name was 'size') represents the real size of long
>> type used for kernel.  So update the pevent's long size.
>> 
> any reason why not merge this one with
>   83ae6eb perf util: Skip reading header_event file

Just try to keep it doing one thing in a patch.  But if you think it'd
better merging it, I'll do it. :)

Thanks,
Namhyung
