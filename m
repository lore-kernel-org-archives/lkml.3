Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaKOU7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 15:59:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36978 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbaKOU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 15:59:36 -0500
Date: Sat, 15 Nov 2014 21:59:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: Christian Resell <christian.resell@gmail.com>, m.chehab@samsung.com,
        devel@driverdev.osuosl.org, askb23@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        yongjun_wei@trendmicro.com.cn, hans.verkuil@cisco.com,
        pali.rohar@gmail.com, fengguang.wu@intel.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: bcm2048: fix coding style error
Message-ID: <20141115205934.GB21240@amd>
References: <20141115194337.GF15904@Kosekroken.jensen.com>
 <20141115201218.GC8088@t400>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115201218.GC8088@t400>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-11-15 21:12:18, Konrad Zapalowicz wrote:
> On 11/15, Christian Resell wrote:
> > Simple style fix (checkpatch.pl: "space prohibited before that ','").
> > For the eudyptula challenge (http://eudyptula-challenge.org/).
> 
> Nice, however we do not need the information about the 'eudyptula
> challenge' in the commit message.
> 
> If you want to include extra information please do it after the '---'
> line (just below the signed-off). You will find more details in the
> SubmittingPatches (chapter 15) of the kernel documentation.

Greg is staging tree maintainer... And if single extra space is all
you can fix in the driver, perhaps it is not worth the patch?

									Pavel

> Thanks,
> Konrad
>  
> > Signed-off-by: Christian F. Resell <christian.resell@gmail.com>
> > ---
> > diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> > index 2bba370..bdc6854 100644
> > --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> > +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> > @@ -2707,7 +2707,7 @@ static int __exit bcm2048_i2c_driver_remove(struct i2c_client *client)
> >   *	bcm2048_i2c_driver - i2c driver interface
> >   */
> >  static const struct i2c_device_id bcm2048_id[] = {
> > -	{ "bcm2048" , 0 },
> > +	{ "bcm2048", 0 },
> >  	{ },
> >  };
> >  MODULE_DEVICE_TABLE(i2c, bcm2048_id);
> > _______________________________________________
> > devel mailing list
> > devel@linuxdriverproject.org
> > http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
