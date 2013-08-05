Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3HEK5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 06:57:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35551 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3HEK5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 06:57:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: stable: please queue commit 0231bb5 ("perf: Fix event group context move")
References: <51FF5FC9.8080302@huawei.com>
Date: Mon, 05 Aug 2013 11:57:01 +0100
In-Reply-To: <51FF5FC9.8080302@huawei.com> (Li Zefan's message of "Mon, 5 Aug
	2013 16:18:17 +0800")
Message-ID: <87fvuojthe.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan <lizefan@huawei.com> writes:

> Plese consider adding commit 0231bb5336758426b44ccd798ccd3c5419c95d58
> to stable tree. It fixes a real bug, which was explained here:
>
> 	http://thread.gmane.org/gmane.linux.kernel.perf.user/1144
>
> and I've managed to reproduce the bug in 3.4 kernel with the test
> program attached in the above email, and I've confirmed the bug fix.
>
> The effect of the bug is, if we open a group of mixed events(sw/hw)
> and the "disabled" flag is not set and sw events come first, then
> some of the perf events won't be started after the call to perf_event_open().
>
> The bug fix should be applicable to kernels >= 3.0 && <= 3.7.
>
> --
> Li Zefan
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks, I'm queuing it for the 3.5 kernel.

Cheers,
-- 
Luis
