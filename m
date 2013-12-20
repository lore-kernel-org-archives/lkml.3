Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab3LTB2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:28:13 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:64661 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3LTB2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:28:12 -0500
X-AuditID: 9c93017d-b7c5eae000004296-19-52b39d2a53d2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 2/6] perf tools: Introduce struct perf_log
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
	<1387436411-20160-3-git-send-email-namhyung@kernel.org>
	<20131219132806.GJ4819@ghostprotocols.net>
Date: Fri, 20 Dec 2013 10:28:10 +0900
In-Reply-To: <20131219132806.GJ4819@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Thu, 19 Dec 2013 10:28:06 -0300")
Message-ID: <87mwjwe2fp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Thu, 19 Dec 2013 10:28:06 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 19, 2013 at 04:00:07PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Add new functions to save error messages in a temp file.  It'll be
>> used by some UI front-ends to see the messages.
>
> Do we really have to grow a logging facility like this? Can't we somehow
> openlog/syslog/closelog? Just a first gut reaction, continuing to read
> the series...

I'm not sure.  It's not really a logging facility - I just wanted a way to
save log messages somewhere in order to show them in a TUI window.  My
feeling is that it doesn't need to grow since perf is not a service or so..

Thanks,
Namhyung
