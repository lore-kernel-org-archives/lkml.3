Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaAIS1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:27:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaAIS1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:27:15 -0500
Date: Thu, 9 Jan 2014 10:27:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Evan Hosseini <hosse005@umn.edu>
Cc: john.stultz@linaro.org, cruzjbishop@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]
Message-ID: <20140109182745.GA7132@kroah.com>
References: <1387899903-2890-1-git-send-email-hosse005@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387899903-2890-1-git-send-email-hosse005@umn.edu>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 09:45:03AM -0600, Evan Hosseini wrote:
> ---
> Staging: android: fix parenthesis coding style issue in alarm-dev.c

What happened to your Subject:?

Also, why put the '---' line here?  That means that git will delete
everything else.

> This is a patch to the alarm-dev.c file that fixes up a
>  parenthesis warning found by the checkpatch.pl tool.
> Signed-off-by: Evan Hosseini <hosse005@umn.edu>

Please put a blank line between the changelog info and the
signed-off-by: line.

> 
> ---
>  drivers/staging/android/alarm-dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
> index 647694f..893362f 100644
> --- a/drivers/staging/android/alarm-dev.c
> +++ b/drivers/staging/android/alarm-dev.c
> @@ -68,7 +68,6 @@ static struct devalarm alarms[ANDROID_ALARM_TYPE_COUNT];
>   */
>  static int is_wakeup(enum android_alarm_type type)
>  {
> -	return (type == ANDROID_ALARM_RTC_WAKEUP ||
> -		type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP);
> +	return type == ANDROID_ALARM_RTC_WAKEUP ||
> +	  type == ANDROID_ALARM_ELAPSED_REALTIME_WAKEUP;

This patch doesn't apply to the linux-next tree, as someone else has
already made this change, sorry.

greg k-h
