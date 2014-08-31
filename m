Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaHaXVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 19:21:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49207 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaHaXVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 19:21:38 -0400
Message-ID: <5403AE00.2030901@infradead.org>
Date: Sun, 31 Aug 2014 16:21:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        eric.piel@tremplin-utc.net, pali.rohar@gmail.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: misc-devices: Rename freefall.c from hpfall.c
 in lis2lv02d
References: <1409491133-14402-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1409491133-14402-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/14 06:18, Masanari Iida wrote:
> hpfall.c was renamed to freefall.c in 3.16.
> But this file still refer to hpfall.c instead of freefall.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/misc-devices/lis3lv02d | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/misc-devices/lis3lv02d b/Documentation/misc-devices/lis3lv02d
> index af815b9..f89960a 100644
> --- a/Documentation/misc-devices/lis3lv02d
> +++ b/Documentation/misc-devices/lis3lv02d
> @@ -59,7 +59,7 @@ acts similar to /dev/rtc and reacts on free-fall interrupts received
>  from the device. It supports blocking operations, poll/select and
>  fasync operation modes. You must read 1 bytes from the device.  The
>  result is number of free-fall interrupts since the last successful
> -read (or 255 if number of interrupts would not fit). See the hpfall.c
> +read (or 255 if number of interrupts would not fit). See the freefall.c
>  file for an example on using the device.
>  
>  
> 

Applied.  Thanks.

-- 
~Randy
