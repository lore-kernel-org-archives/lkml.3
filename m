Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939AbaKXWO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:14:28 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:60595 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKXWO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:14:26 -0500
MIME-Version: 1.0
In-Reply-To: <1416599058-13836-2-git-send-email-john.stultz@linaro.org>
References: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
	<1416599058-13836-2-git-send-email-john.stultz@linaro.org>
Date: Mon, 24 Nov 2014 14:14:25 -0800
Message-ID: <CAASgrz1GRZNK9+boQLuDaN9G_9SkXkpN+Os+A7nPen1uHQde5g@mail.gmail.com>
Subject: Re: [PATCH 01/12] time: Rename udelay_test.c to test_udelay.c
From: David Riley <davidriley@google.com>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>,
        Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:44 AM, John Stultz <john.stultz@linaro.org> wrote:
> Kees requested that this test module be renamed for consistency sake,
> so this patch renames the udelay_test.c file (recently added to
> tip/timers/core for 3.17) to test_udelay.c
>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Linux-Next <linux-next@vger.kernel.org>
> Cc: David Riley <davidriley@chromium.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Reviewed-by: David Riley <davidriley@chromium.org>
