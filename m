Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaJXCiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:38:20 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:53966 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaJXCiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:38:19 -0400
MIME-Version: 1.0
In-Reply-To: <20141024015654.GV14687@kernel.org>
References: <1412556363-26229-1-git-send-email-namhyung@kernel.org>
 <20141013181158.GA28191@krava.redhat.com> <20141015192441.GR3198@kernel.org>
 <20141015200630.GT3198@kernel.org> <87iojcga58.fsf@sejong.aot.lge.com>
 <20141023233542.GR14687@kernel.org> <877fzqe1pa.fsf@sejong.aot.lge.com> <20141024015654.GV14687@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 24 Oct 2014 11:37:58 +0900
X-Google-Sender-Auth: 2eqhLudG6B3CKdaUbFSGQCfaae8
Message-ID: <CAM9d7ci15fRPiB20UtcpZFUTTvoRm7Cb6w=RXpTDkgLcWo=8XQ@mail.gmail.com>
Subject: Re: [PATCHSET 0/5] perf tools: Speed up dwarf callchain
 post-unwinding for libunwind (v4)
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 10:56 AM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
> Em Fri, Oct 24, 2014 at 09:44:17AM +0900, Namhyung Kim escreveu:
>> On Thu, 23 Oct 2014 20:35:42 -0300, Arnaldo Carvalho de Melo wrote:
>> > I'll push later and will drop you a note, so that you can, please, check
>> > if the end result is sane.
>>
>> Thank you!
>
> It should be on my perf/core branch by now.

Looks ok to me.

Thanks,
Namhyung
