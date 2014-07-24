Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbaGXPmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:42:25 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:37752 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759185AbaGXPmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:42:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140724135941.GT20303@kernel.org>
References: <1404883694-5342-1-git-send-email-namhyung@kernel.org> <20140724135941.GT20303@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 25 Jul 2014 00:42:04 +0900
X-Google-Sender-Auth: 2iOpSu5zvKjEE1rFKBmqCbwjGp8
Message-ID: <CAM9d7chNnavpxGgOFoZkzOgin+QOGZUgb7v2uRfVGxVNrPza2w@mail.gmail.com>
Subject: Re: [PATCHSET 0/6] perf tools: Honor column width setting
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 10:59 PM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
> Em Wed, Jul 09, 2014 at 02:28:08PM +0900, Namhyung Kim escreveu:
>> Hello,
>>
>> This patchset is to control perf report/top output column width by
>> -w/--column-widths option so that it can fit into the terminal size.
>> The -w option is there for perf report but it ignored by recent output
>> field changed due to some reason.  This patchset fixes it and supports
>> perf top also.
>>
>> This is sometimes useful if your terminal is small and there's some
>> C++ applications which have amazingly long symbol names.  Without this
>> patchset user might not see those symbols on TUI, since it maps
>> left/right arrow keys to other functions.
>>
>> The -w option sets column width starting from the first column
>> (overhead or optional overhead_children column unless -F option is
>> given).  It doesn't make sense to limit those overhead columns so it's
>> not a hard-limit for them.  But it *is* a hard-limit for other columns
>> such as comm, dso, symbol, and so on.  One can use 0 not to
>> limit/force a width for those columns.
>
> Due to the issues pointed out, will wait for a v2 patchset, ok?

Okay.  Will send v2 tomorrow.

Thanks,
Namhyung
