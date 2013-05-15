Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab3EOVvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:51:33 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:54944 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab3EOVvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:51:31 -0400
Message-ID: <51940360.3020003@linaro.org>
Date: Wed, 15 May 2013 14:51:28 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Todd Poynor <toddpoynor@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] timerfd: add alarm timers
References: <1368653892-18939-1-git-send-email-toddpoynor@google.com> <1368653892-18939-3-git-send-email-toddpoynor@google.com>
In-Reply-To: <1368653892-18939-3-git-send-email-toddpoynor@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 02:38 PM, Todd Poynor wrote:
> Add support for clocks CLOCK_REALTIME_ALARM and CLOCK_BOOTTIME_ALARM,
> thereby enabling wakeup alarm timers via file descriptors.
>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>

This all looks great to me and has been on my own todo list for awhile.

As I said, I'll queue the alarmtimer changes, and if I can get some acks 
from the fs folks, I'd be happy to queue the timerfd changes.

thanks
-john

