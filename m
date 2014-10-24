Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaJXEe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 00:34:56 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:56926 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJXEez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 00:34:55 -0400
MIME-Version: 1.0
In-Reply-To: <1412838271-11175-2-git-send-email-pang.xunlei@linaro.org>
References: <1412838271-11175-1-git-send-email-pang.xunlei@linaro.org>
	<1412838271-11175-2-git-send-email-pang.xunlei@linaro.org>
Date: Thu, 23 Oct 2014 21:34:54 -0700
Message-ID: <CALAqxLXZFgM4bCWSEgh00wKsxbKLEnV7mha_GavZQJmtRqLBJg@mail.gmail.com>
Subject: Re: [PATCH 2/2] time: Complete NTP adjustment threshold judging conditions
From: John Stultz <john.stultz@linaro.org>
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 12:04 AM, pang.xunlei <pang.xunlei@linaro.org> wrote:
> The clocksource mult-adjustment threshold is [mult-maxadj, mult+maxadj],
> timekeeping_adjust() only deals with the upper threshold, but misses the
> lower threshold.
>
> This patch adds the lower threshold judging condition.
>
> Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>

Added to my 3.19 queue.

thanks!
-john
