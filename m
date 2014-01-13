Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaAMUft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:35:49 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30788 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaAMUfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:35:47 -0500
Date: Mon, 13 Jan 2014 23:32:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Borg <cyborg101010@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, abbotti@mev.co.uk,
        Levente Kurusa <levex@linux.com>
Subject: Re: [PATCH] AlarmDev: Changing is_wakeup() to be a function to pass
 checkpatch
Message-ID: <20140113203204.GG7444@mwanda>
References: <1389643836-6170-1-git-send-email-cyborg101010@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389643836-6170-1-git-send-email-cyborg101010@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 08:10:36PM +0000, Joe Borg wrote:
> Signed-off-by Joe Borg <cyborg101010@gmail.com>
> ---
>  drivers/staging/android/alarm-dev.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
> index 647694f..87f2a02 100644
> --- a/drivers/staging/android/alarm-dev.c
> +++ b/drivers/staging/android/alarm-dev.c
> @@ -66,13 +66,15 @@ static struct devalarm alarms[ANDROID_ALARM_TYPE_COUNT];
>   *
>   * Return: 1 if this is a wakeup alarm, otherwise 0
>   */
> -static int is_wakeup(enum android_alarm_type type)
> +static int is_wakeup(enum andriod_alarm_type type)

Levente already pointed out that this breaks the build.  Really
Levente said was spot on and still applies to the v2 of the patch.

regards,
dan carpenter

