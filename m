Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaGaNTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:19:22 -0400
Received: from [195.154.187.82] ([195.154.187.82]:54120 "EHLO ou.quest-ce.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaGaNTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:19:21 -0400
X-Greylist: delayed 1130 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jul 2014 09:19:20 EDT
Message-ID: <1406811619.4911.10.camel@localhost.localdomain>
From: Yann Droneaud <ydroneaud@opteya.com>
To: Nicholas Krause <xerofoify@gmail.com>,
        Adrian Remonda <adrianremonda@gmail.com>,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, daniel@ffwll.ch, waydi1@gmail.com,
        sumit.semwal@linaro.org, maarten.lankhorst@canonical.com,
        ydroneaud@opteya.com
Date: Thu, 31 Jul 2014 15:00:19 +0200
In-Reply-To: <1406587103-5784-1-git-send-email-mopsfelder@gmail.com>
References: <1406587103-5784-1-git-send-email-mopsfelder@gmail.com>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 37.161.115.126
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: [PATCH] Staging: android: sw_sync.c: fix missing blank line
 after declaration
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le lundi 28 juillet 2014 à 19:38 -0300, Murilo Opsfelder Araujo a
écrit :
> Fix coding style issue.
> 
> Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>

Is this some kind of game ?

The *same* patch was sent three times from three different email
addresses:

  http://lkml.kernel.org/r/1406170403-4506-1-git-send-email-xerofoify@gmail.com

    From: Nicholas Krause <xerofoify@gmail.com>
    Date: Wed, 23 Jul 2014 22:53:23 -0400
    Message-Id: <1406170403-4506-1-git-send-email-xerofoify@gmail.com>
    Subject: [PATCH] staging: Add blank lines in sw_sync.c

  http://lkml.kernel.org/r/1406581660-7863-1-git-send-email-adrianremonda@gmail.com

    From: Adrian Remonda <adrianremonda@gmail.com>
    Date: Mon, 28 Jul 2014 23:07:40 +0200
    Message-Id: <1406581660-7863-1-git-send-email-adrianremonda@gmail.com>
    Subject: [PATCH] Staging: android: Missing a blank line after declarations
     in sw_sync.c This is a patch to the sw_sync.c file that fixes up a missing
     a blank warning found by the checkpatch.pl tool

  http://lkml.kernel.org/r/1406587103-5784-1-git-send-email-mopsfelder@gmail.com

    From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
    Date: Mon, 28 Jul 2014 19:38:23 -0300
    Message-Id: <1406587103-5784-1-git-send-email-mopsfelder@gmail.com>
    Subject: [PATCH] Staging: android: sw_sync.c: fix missing blank line after
     declaration


> ---
>  drivers/staging/android/sw_sync.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
> index a76db3f..863d4b1 100644
> --- a/drivers/staging/android/sw_sync.c
> +++ b/drivers/staging/android/sw_sync.c
> @@ -97,6 +97,7 @@ static void sw_sync_pt_value_str(struct sync_pt *sync_pt,
>  				       char *str, int size)
>  {
>  	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
> +
>  	snprintf(str, size, "%d", pt->value);
>  }
>  
> @@ -156,6 +157,7 @@ static int sw_sync_open(struct inode *inode, struct file *file)
>  static int sw_sync_release(struct inode *inode, struct file *file)
>  {
>  	struct sw_sync_timeline *obj = file->private_data;
> +
>  	sync_timeline_destroy(&obj->obj);
>  	return 0;
>  }

Regards.

-- 
Yann Droneaud
OPTEYA


