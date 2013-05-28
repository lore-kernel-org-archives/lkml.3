Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3E1UkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:40:15 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64814 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab3E1UkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:40:13 -0400
Message-ID: <51A5162A.5060609@linaro.org>
Date: Tue, 28 May 2013 13:40:10 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zoran Markovic <zoran.markovic@linaro.org>
CC: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        Benoit Goby <benoit@android.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCHv2] power: Add option to log time spent in suspend
References: <1369200734-5187-1-git-send-email-zoran.markovic@linaro.org>
In-Reply-To: <1369200734-5187-1-git-send-email-zoran.markovic@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 10:32 PM, Zoran Markovic wrote:
> From: Colin Cross <ccross@android.com>
>
> Below is a patch from android kernel that maintains a histogram of
> suspend times. Please review and provide feedback.
>
> Statistices on the time spent in suspend are kept in
> /sys/kernel/debug/sleep_time.
>
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: Colin Cross <ccross@android.com>
> Cc: Todd Poynor <toddpoynor@google.com>
> Cc: San Mehat <san@google.com>
> Cc: Benoit Goby <benoit@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Colin Cross <ccross@android.com>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> [zoran.markovic@linaro.org: Re-formatted suspend time table to better fit
> expected values. Moved accounting of suspend time into timekeeping core.
> Removed CONFIG_SUSPEND_TIME flag and made the feature conditional on
> CONFIG_DEBUG_FS. Changed the file name to sleep_time to better fit terminology
> in timekeeping core. Changed seq_printf to seq_puts. Tweaked commit message]
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>

Queued for 3.11.

Thanks!
-john

