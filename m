Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3LSNiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:38:04 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:46111 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab3LSNhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:37:21 -0500
MIME-Version: 1.0
In-Reply-To: <20131219115833.GA11279@gmail.com>
References: <1387441761-2153-1-git-send-email-tuxoko@gmail.com>
	<20131219115833.GA11279@gmail.com>
Date: Thu, 19 Dec 2013 21:37:19 +0800
Message-ID: <CAK1sfuYn1iLUHWwUTdm755D0YpuAcROsj5rp=4-Vg5qc57bFfw@mail.gmail.com>
Subject: Re: [PATCH] perf config: ignore generated files in feature-checks
From: David Chen <tuxoko@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why not? They're generated files aren't they?

By the way, I just found out that test-* will be built depend on the
detected features.
Should I include them all?

Thanks,
Chunwei Chen

2013/12/19 Ingo Molnar <mingo@kernel.org>:
>
> * Chunwei Chen <tuxoko@gmail.com> wrote:
>
>> Signed-off-by: Chunwei Chen <tuxoko@gmail.com>
>> ---
>>  tools/perf/config/feature-checks/.gitignore |    2 ++
>>  1 file changed, 2 insertions(+)
>>  create mode 100644 tools/perf/config/feature-checks/.gitignore
>>
>> diff --git a/tools/perf/config/feature-checks/.gitignore b/tools/perf/config/feature-checks/.gitignore
>> new file mode 100644
>> index 0000000..9662c68
>> --- /dev/null
>> +++ b/tools/perf/config/feature-checks/.gitignore
>> @@ -0,0 +1,2 @@
>> +test-all
>> +*.d
>
> Why? These are cleaned out on 'make clean'.
>
> Thanks,
>
>         Ingo
