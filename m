Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaAPRvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:51:11 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:46501 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaAPRvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:51:09 -0500
Message-ID: <52D81C09.10901@linux.com>
Date: Thu, 16 Jan 2014 18:51:05 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBLd2lhdGtvd3NraQ==?= 
	<michaelflowersky@geekingspree.com>,
        gregkh@linuxfoundation.org, john.stultz@linaro.org,
        dan.carpenter@oracle.com, cruzjbishop@gmail.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: fix parentheses coding style issue
 in alarm-dev.c
References: <1389828756-9397-1-git-send-email-michaelflowersky@geekingspree.com>
In-Reply-To: <1389828756-9397-1-git-send-email-michaelflowersky@geekingspree.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/16/2014 12:32 AM, Michał Kwiatkowski wrote:
> This is a patch to the alarm-dev.c file that removes parentheses which
> should not appear in return statement. This error was found by the
> checkpatch.pl tool.
> 
> Signed-off-by: Michał Kwiatkowski <michaelflowersky@geekingspree.com>
> [...]
> +++ b/drivers/staging/android/alarm-dev.c
> @@ -68,8 +68,8 @@ static struct devalarm alarms[ANDROID_ALARM_TYPE_COUNT];
>   */
>  static int is_wakeup(enum android_alarm_type type)
>  {
> -	return (type == ANDROID_ALARM_RTC_WAKEUP ||
> -		type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP);
> +	return type == ANDROID_ALARM_RTC_WAKEUP ||
> +	       type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP;
>  }

This is the fourth patch that does the exact same, an other similar patch
was already applied, hence this one will not apply. Please base your patches
on -next or the staging.git tree.

-- 
Regards,
Levente Kurusa
