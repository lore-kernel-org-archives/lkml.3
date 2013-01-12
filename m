Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3ALC3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 21:29:22 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58948 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab3ALC3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 21:29:21 -0500
Message-ID: <50F0CA7E.2020106@linaro.org>
Date: Fri, 11 Jan 2013 18:29:18 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Miroslav Lichvar <mlichvar@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCHv2] posix-timers: Fix clock_adjtime to always return timex
 data on success
References: <50EF2441.7020507@linaro.org> <1357901938-3098-1-git-send-email-mlichvar@redhat.com>
In-Reply-To: <1357901938-3098-1-git-send-email-mlichvar@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 02:58 AM, Miroslav Lichvar wrote:
> The clock_adj call returns the clock state on success, which may be a
> non-zero value (e.g. TIME_INS), but the modified timex data is copied
> back to the user only when zero value (TIME_OK) was returned. Fix the
> condition to copy the data also with positive return values.
>
> Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>

Thanks for the resend. I've got this in my queue for 3.9

thanks
-john

