Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaIHIeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:34:08 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34128 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaIHIeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:34:04 -0400
Date: Mon, 8 Sep 2014 14:03:51 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Davis <jim.epost@gmail.com>
Subject: Re: [PATCH] drivers: media: radio: radio-miropcm20.c: include
 missing header file
Message-ID: <20140908083351.GA27547@sudip-PC>
References: <1409299681-28409-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20140906112453.GA9405@sudip-PC>
 <540D63D1.2010402@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540D63D1.2010402@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 10:07:45AM +0200, Hans Verkuil wrote:
> On 09/06/2014 01:24 PM, Sudip Mukherjee wrote:
> > On Fri, Aug 29, 2014 at 01:38:01PM +0530, Sudip Mukherjee wrote:
> >> with -Werror=implicit-function-declaration build failed with error :
> >> error: implicit declaration of function 'inb'
> >> error: implicit declaration of function 'outb'
> >>
> >> Reported-by: Jim Davis <jim.epost@gmail.com>
> >> Signed-off-by: Sudip Mukherjee <sudip@vectorindi.org>
> >> ---
> >>
> >> Jim reported for next-20140828 , but the error still persists in next-20140829 also.
> >>
> >>
> >>  drivers/media/radio/radio-miropcm20.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
> >> index 998919e..3309f7c 100644
> >> --- a/drivers/media/radio/radio-miropcm20.c
> >> +++ b/drivers/media/radio/radio-miropcm20.c
> >> @@ -36,6 +36,7 @@
> >>  #include <media/v4l2-fh.h>
> >>  #include <media/v4l2-event.h>
> >>  #include <sound/aci.h>
> >> +#include<linux/io.h>
> >>  
> >>  #define RDS_DATASHIFT          2   /* Bit 2 */
> >>  #define RDS_DATAMASK        (1 << RDS_DATASHIFT)
> >> -- 
> >> 1.8.1.2
> >>
> > 
> > gentle ping.
> > build fails on next-20140905 also with the attached config (-Werror=implicit-function-declaration)
> 
> I hadn't forgotten this. However, I will be taking the same patch from Randy Dunlap
> instead of yours since his commit log was formatted better, so less work for me :-)
> 
i didnt see his patch before , but now i saw. Indeed his commit log is much more explanatory than mine.

thanks
sudip


> Regards,
> 
> 	Hans
> 
> > 
> > thanks
> > sudip
> > 
> 
