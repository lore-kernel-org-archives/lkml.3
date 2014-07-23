Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbaGWKIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:08:49 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:46091 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127AbaGWKIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:08:48 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "waydi1@gmail.com" <waydi1@gmail.com>,
        "swetland@google.com" <swetland@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>
Subject: RE: [PATCH] staging: android: Fixed missing blank line
Thread-Topic: [PATCH] staging: android: Fixed missing blank line
Thread-Index: AQHPokHKPX3m4qRn7Ey277r1/fasOZumZz0AgAcQNZA=
Date: Wed, 23 Jul 2014 10:08:44 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE938F0397E@EU-MBX-04.mgc.mentorg.com>
References: <1405658874-24448-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140718231610.GA29987@kroah.com>
In-Reply-To: <20140718231610.GA29987@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Jul 2014 10:08:46.0367 (UTC) FILETIME=[17374AF0:01CFA65E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, so this is also available in next kernel release version.

Regards
Sanjeev Sharma

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Saturday, July 19, 2014 4:46 AM
To: Sharma, Sanjeev
Cc: devel@driverdev.osuosl.org; waydi1@gmail.com; swetland@google.com; linux-kernel@vger.kernel.org; daniel@ffwll.ch
Subject: Re: [PATCH] staging: android: Fixed missing blank line

On Fri, Jul 18, 2014 at 10:17:54AM +0530, Sanjeev Sharma wrote:
> This patch will add an blank line after declaration reported by 
> checkpatch.pl script.
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/staging/android/sw_sync.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/android/sw_sync.c 
> b/drivers/staging/android/sw_sync.c
> index a76db3f..863d4b1 100644
> --- a/drivers/staging/android/sw_sync.c
> +++ b/drivers/staging/android/sw_sync.c
> @@ -97,6 +97,7 @@ static void sw_sync_pt_value_str(struct sync_pt *sync_pt,
>  				       char *str, int size)
>  {
>  	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
> +
>  	snprintf(str, size, "%d", pt->value);  }
>  
> @@ -156,6 +157,7 @@ static int sw_sync_open(struct inode *inode, 
> struct file *file)  static int sw_sync_release(struct inode *inode, 
> struct file *file)  {
>  	struct sw_sync_timeline *obj = file->private_data;
> +
>  	sync_timeline_destroy(&obj->obj);
>  	return 0;
>  }

I already applied a previous version of this patch, with your gmail address :(
