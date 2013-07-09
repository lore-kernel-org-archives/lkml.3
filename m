Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3GIIwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:52:17 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:64696 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3GIIwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <87zjtwxq77.fsf@sejong.aot.lge.com>
References: <1373019377-12741-1-git-send-email-artagnon@gmail.com> <87zjtwxq77.fsf@sejong.aot.lge.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 9 Jul 2013 14:21:35 +0530
Message-ID: <CALkWK0mHeVnHhzug2pkuAbvnvnynQEbMipzCC702xFt9-3k0tA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Minor perf build fixes
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

Namhyung Kim wrote:
> On Fri,  5 Jul 2013 15:46:13 +0530, Ramkumar Ramachandra wrote:
>> [3/4] introduces a util/perf-perl.h to include <perl.h> with #pragma
>> statements, hence eliminating duplication.  It then updates Context.xs
>> and trace-event-perl.c to use this new header.
>
> I prefer the name being "perl.h" and use #include_next as we include the
> 'util' directory in the compiler search path.
>
> Other than that, the change looks good to me.

Thanks for teaching me about #include_next.  I'll post a re-roll shortly.

>> Also, notice that feature-tests.mak has not been touched in this
>> iteration: the Perl check passes without needing the #pragma
>> statements (although I'm not sure why exactly).
>
> I guess it's because FLAGS_PERL_EMBED doesn't contain the usual perf
> CFLAGS which has -Werror.

Ah.
