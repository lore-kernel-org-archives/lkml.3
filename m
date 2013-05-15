Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab3EOKIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 06:08:36 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52707 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3EOKIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 06:08:35 -0400
X-AuditID: 9c93017e-b7cf8ae000004f65-a8-51935ea0ec6b
From: Namhyung Kim <namhyung@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 8/9] perf report: Add report.percent-limit config variable
References: <1368497347-9628-1-git-send-email-namhyung@kernel.org>
	<1368497347-9628-9-git-send-email-namhyung@kernel.org>
	<CAOJsxLF+4D68oQrcWXyzFgHBcXv4nLvmnSQyCiEYN2CMpRv48Q@mail.gmail.com>
Date: Wed, 15 May 2013 19:08:32 +0900
In-Reply-To: <CAOJsxLF+4D68oQrcWXyzFgHBcXv4nLvmnSQyCiEYN2CMpRv48Q@mail.gmail.com>
	(Pekka Enberg's message of "Tue, 14 May 2013 14:05:38 +0300")
Message-ID: <8761yk5zdr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Tue, 14 May 2013 14:05:38 +0300, Pekka Enberg wrote:
> On Tue, May 14, 2013 at 5:09 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>>
>> Now an user can set a default value of --percent-limit option into the
>> perfconfig file.
>>
>>   $ cat ~/.perfconfig
>>   [report]
>>   percent-limit = 0.1
>>
>> Cc: Andi Kleen <andi@firstfloor.org>
>> Cc: Pekka Enberg <penberg@kernel.org>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
> I'm not totally convinced this is useful. The limit is about "what is
> significant" and that depends on what you are trying to measure.
> There's an (absolute) lower limit somewhere between 0.1 and 1.0 but I
> think we can just pick a reasonable default and  let people use the
> command line switch if they want to override it.

If the limit depends on what is measured, what should be the reasonable
default value?  I just don't know..

I agree that we should pick a default but the config variable doesn't
harm anything in this case too.  Some users might not agree with our
default for their cases and want to use other value.

But I'm not insist on it so strongly, I just gave another way.. ;)

Thanks,
Namhyung
