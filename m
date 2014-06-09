Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbaFIXlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:41:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41069 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147AbaFIXlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:41:46 -0400
MIME-Version: 1.0
In-Reply-To: <1400106617-17085-1-git-send-email-davidriley@chromium.org>
References: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
	<1400106617-17085-1-git-send-email-davidriley@chromium.org>
Date: Mon, 9 Jun 2014 16:41:45 -0700
Message-ID: <CAASgrz2=NA96ZZe8GRfnZ_m2woLc=QaAizj6yVA8Jgbi-O3rfQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Add test to validate udelay
From: David Riley <davidriley@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Riley <davidriley@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was wondering if there were any comments to this patch or if it was
picked up somewhere?

Thanks,
Dave

On Wed, May 14, 2014 at 3:30 PM, David Riley <davidriley@chromium.org> wrote:
> This change adds a module and a script that makes use of it to
> validate that udelay delays for at least as long as requested
> (as compared to ktime).
>
> Changes since v1:
> - allow udelay() to be 0.5% faster than requested as per feedback
>
> David Riley (2):
>   kernel: time: Add udelay_test module to validate udelay
>   tools: add script to test udelay
>
>  kernel/time/Kconfig       |    7 ++
>  kernel/time/Makefile      |    1 +
>  kernel/time/udelay_test.c |  169 +++++++++++++++++++++++++++++++++++++++++++++
>  tools/time/udelay_test.sh |   66 ++++++++++++++++++
>  4 files changed, 243 insertions(+)
>  create mode 100644 kernel/time/udelay_test.c
>  create mode 100644 tools/time/udelay_test.sh
>
> --
> 1.7.9.5
>
