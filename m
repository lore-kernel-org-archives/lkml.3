Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3L1RsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 12:48:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3L1RsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 12:48:20 -0500
Date: Sat, 28 Dec 2013 09:48:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Arthur Schwalbenberg <arthurs578@gmail.com>
Cc: john.stultz@linaro.org, dan.carpenter@oracle.com, cruzjbishop@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 	Staging: Android: Fixed coding issue return parenthesis
 in alarm_dev.c
Message-ID: <20131228174857.GA15772@kroah.com>
References: <1388246608-11272-1-git-send-email-arthurs578@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388246608-11272-1-git-send-email-arthurs578@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 28, 2013 at 11:03:28AM -0500, Arthur Schwalbenberg wrote:
> 	This is a patch to the alarm_dev.c file that fixes up a return is not
> 	a function warning found by the checkpatch.pl tool
> 
> 	Signed-off-by: Arthur Schwalbenberg <arthurs578@gmail.com>

Why the odd indentation?

> ---
>  drivers/staging/android/alarm-dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
> index 647694f..96b2f53 100644
> --- a/drivers/staging/android/alarm-dev.c
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

This change is already in linux-next, right?  I can't apply the same
change more than once to the tree...

greg k-h
