Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaKJHk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 02:40:57 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:65243 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaKJHk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 02:40:56 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms on NO_LIBELF=1
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
	<545CE36C.7040906@gmail.com>
Date: Mon, 10 Nov 2014 16:40:53 +0900
In-Reply-To: <545CE36C.7040906@gmail.com> (David Ahern's message of "Fri, 07
	Nov 2014 08:21:16 -0700")
Message-ID: <87a93zv6yi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, 07 Nov 2014 08:21:16 -0700, David Ahern wrote:
> On 11/6/14, 10:20 PM, Namhyung Kim wrote:
>> It worked w/o libelf, but recent change to use vmlinux for kernel
>> symbols break it.
>
> Do you know the recent change (commit id) that broke it?

Nope.  I tried to find it but failed - older versions seems also have
the problem and some of them could not run perf record.  Anyway it looks
like depending some external condition and broken for a while. :(

Thanks,
Namhyung
