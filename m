Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3EUH0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:26:31 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62557 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab3EUH01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:26:27 -0400
X-AuditID: 9c93016f-b7cfdae000002fc1-38-519b21a1b455
From: Namhyung Kim <namhyung@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 0/7] perf report/gtk: Add support for hierarchy view
References: <1369116878-12489-1-git-send-email-namhyung@kernel.org>
	<CAOJsxLETg8WMrX+gqYA03Bm4tAsgAKVgbH6aay=NS9L-WmKbpQ@mail.gmail.com>
Date: Tue, 21 May 2013 16:26:25 +0900
In-Reply-To: <CAOJsxLETg8WMrX+gqYA03Bm4tAsgAKVgbH6aay=NS9L-WmKbpQ@mail.gmail.com>
	(Pekka Enberg's message of "Tue, 21 May 2013 10:04:05 +0300")
Message-ID: <87vc6c3iam.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Tue, 21 May 2013 10:04:05 +0300, Pekka Enberg wrote:
> Hello,
>
> On Tue, May 21, 2013 at 9:14 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>> This patchset implements a new feature that collects hist entries in a
>> hierachical manner.  That means lower-level entries are belonged to an
>> upper-level entry.  The entry hierachy is built on the sort keys
>> given, so users can set it whatever they want.  It only shows
>> top-level entries first, and user can expand/collapse it dynamically.
>>
>> This is only implemented in --gtk currently, since it's well-matched
>> to the GTK tree view widget and I didn't want to be bothered with the
>> TUI browser code at this stage. :)
>
> Can use this infrastructure to support call-graphs in the GTK UI?

Yes, I think it's doable.  I don't have an idea how to use both of the
features at the same time though.  Anyway, I'll try to add support for
callchains later.

Thanks,
Namhyung
