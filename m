Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaDDHqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:46:32 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:58024 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaDDHq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:46:29 -0400
MIME-Version: 1.0
In-Reply-To: <CALkWK0kcg0SWrwF0w51L5XuwsBvDO2DZ9em4eYdebo4fjEBAZQ@mail.gmail.com>
References: <1395873845-466-1-git-send-email-artagnon@gmail.com>
	<CALkWK0kcg0SWrwF0w51L5XuwsBvDO2DZ9em4eYdebo4fjEBAZQ@mail.gmail.com>
Date: Fri, 4 Apr 2014 09:46:28 +0200
Message-ID: <CAFrcx1njU6Ycia0R7ckSy5V5eoquC7OiAcGOSOHvM2srW5Jn4g@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Pick up libdw without explicit LIBDW_DIR
From: Jean Pihet <jean.pihet@linaro.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        jwboyer@fedoraproject.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 April 2014 23:51, Ramkumar Ramachandra <artagnon@gmail.com> wrote:
> Ramkumar Ramachandra wrote:
>>  tools/perf/config/Makefile | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> Jiri, any comments?
Note: this patch is equivalent to '[PATCH] perf tools: Fix feature
check for libdw dwarf unwind' [1] from Josh Boyer. Jiri, your pick ;-)

[1] http://www.spinics.net/lists/kernel/msg1716729.html

FWIW:
Acked-by: Jean Pihet <jean.pihet@linaro.org>

>
> Ram
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
