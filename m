Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaHUO4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:56:10 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:46995 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaHUO4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:56:08 -0400
MIME-Version: 1.0
In-Reply-To: <1408566691-3023-1-git-send-email-iacobcatalin@gmail.com>
References: <20140811200931.GA18865@redhat.com>
	<1408566691-3023-1-git-send-email-iacobcatalin@gmail.com>
Date: Thu, 21 Aug 2014 16:56:06 +0200
Message-ID: <CAFTL4hxJ2roTB3tZBmXU3HRetgFSUT0LNVWfX-Y2hbpyXSo2pg@mail.gmail.com>
Subject: Re: nohz fail (was: perf related boot hang.)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-20 22:31 GMT+02:00 Catalin Iacob <iacobcatalin@gmail.com>:
> I've also just hit what seems to be the same panic in 3.17-rc1 (ignore the 1
> local patch, it's an unrelated change in a comment) twice in less than 1
> hour. Hitting this twice in a short amount of time seems to be proof that the
> 3.17 merge window made it trigger more often. Both times I was running a grep
> over a Firefox build tree which was taking a long time.
>
> The stacktraces are slightly different but both have the "cancel timer from a
> timer, followed by nmi" pattern. Pictures of the 2 stacktraces:
> https://drive.google.com/file/d/0B_fRjDygGZSNY0RIc2dyYTExTjg/edit?usp=sharing
> https://drive.google.com/file/d/0B_fRjDygGZSNS1pSWFkteURrOTQ/edit?usp=sharing

Hi Catalin, Dave,

Can you please test the series I just posted: "[RFC PATCH 0/9] nohz:
Nohz full kick fixes"?
It should fix the issues.

Thanks.
