Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab3HGIyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:54:12 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50671 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab3HGIyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:54:10 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-35-52020b3085e5
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V9 05/14] perf tools: tidy up sample parsing overflow checking
References: <1375719994-26482-1-git-send-email-adrian.hunter@intel.com>
	<1375719994-26482-6-git-send-email-adrian.hunter@intel.com>
	<87txj1ylb7.fsf@sejong.aot.lge.com> <52020314.7080708@intel.com>
Date: Wed, 07 Aug 2013 17:54:08 +0900
In-Reply-To: <52020314.7080708@intel.com> (Adrian Hunter's message of "Wed, 07
	Aug 2013 11:19:32 +0300")
Message-ID: <87d2ppyj7z.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Aug 2013 11:19:32 +0300, Adrian Hunter wrote:
> On 07/08/13 11:09, Namhyung Kim wrote:
>> On Mon,  5 Aug 2013 19:26:25 +0300, Adrian Hunter wrote:
>>> The size of data retrieved from a sample event must be
>>> validated to ensure it does not go past the end of the
>>> event.  That was being done sporadically and without
>>> considering integer overflows.
>> 
>> Wouldn't it be great if the macro (or something) can do all three things
>> together - checking overflow, getting current value (pointer) and
>> advancing the array to the size?  Is that possible?
>
> Macros are not the answer to everything.

Right.

But I was seeing repeating patterns of the three.. so I asked if there's
a better alternative.

Thanks,
Namhyung
