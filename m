Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3EOVuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:50:07 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41760 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3EOVuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:50:06 -0400
Message-ID: <5194030A.7040106@linaro.org>
Date: Wed, 15 May 2013 14:50:02 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Todd Poynor <toddpoynor@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] alarmtimer: add functions for timerfd support
References: <1368653892-18939-1-git-send-email-toddpoynor@google.com> <1368653892-18939-2-git-send-email-toddpoynor@google.com>
In-Reply-To: <1368653892-18939-2-git-send-email-toddpoynor@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 02:38 PM, Todd Poynor wrote:
> Add functions needed for hooking up alarmtimer to timerfd:
>
> * alarm_restart: Similar to hrtimer_restart, restart an alarmtimer after
>    the expires time has already been updated (as with alarm_forward).
>
> * alarm_forward_now: Similar to hrtimer_forward_now, move the expires
>    time forward to an interval from the current time of the associated clock.
>
> * alarm_start_relative: Start an alarmtimer with an expires time relative to
>    the current time of the associated clock.
>
> * alarm_expires_remaining: Similar to hrtimer_expires_remaining, return the
>    amount of time remaining until alarm expiry.
>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>

Acked-by: John Stultz <john.stultz@linaro.org>

I'll queue this in my tree for 3.11, but I need to sort out which path 
the timerfd code needs to go upstream.

thanks
-john




