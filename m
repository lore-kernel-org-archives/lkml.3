Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab3EPAzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 20:55:14 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55064 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3EPAzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 20:55:12 -0400
X-AuditID: 9c93017d-b7b62ae000004f69-4d-51942e6d3106
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [RFC/PATCH 1/2] perf script: Add --time-filter option
References: <1368609839-19899-1-git-send-email-namhyung@kernel.org>
	<20130515135608.GF17814@two.firstfloor.org>
Date: Thu, 16 May 2013 09:55:09 +0900
In-Reply-To: <20130515135608.GF17814@two.firstfloor.org> (Andi Kleen's message
	of "Wed, 15 May 2013 15:56:08 +0200")
Message-ID: <87wqqz4uc2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Wed, 15 May 2013 15:56:08 +0200, Andi Kleen wrote:
> On Wed, May 15, 2013 at 06:23:58PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The --time-filter option is for limiting samples within a range of
>> time.  A time range looks like <time1>-<time2> and at most one of them
>> can be omitted.  For instance:
>
> It would be more useful for report or inject than for script.
> After all with a script it's trivial to do an own filter.
> Not so easy with report.

Right.  I actually sent the patch 2/2 for report side and it's the main
aim for this patch.  This was included almost for verification. :)

Anyway, I didn't think about the inject command, I will apply it to the
inject too in next spin.

Thanks,
Namhyung
