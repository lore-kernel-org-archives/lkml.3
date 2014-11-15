Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaKOV0X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 16:26:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaKOV0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 16:26:21 -0500
Date: Sat, 15 Nov 2014 13:25:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Konrad Zapalowicz <bergo.torino@gmail.com>,
        Christian Resell <christian.resell@gmail.com>, m.chehab@samsung.com,
        devel@driverdev.osuosl.org, askb23@gmail.com,
        linux-kernel@vger.kernel.org, yongjun_wei@trendmicro.com.cn,
        hans.verkuil@cisco.com, pali.rohar@gmail.com, fengguang.wu@intel.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: bcm2048: fix coding style error
Message-ID: <20141115212503.GA21773@kroah.com>
References: <20141115194337.GF15904@Kosekroken.jensen.com>
 <20141115201218.GC8088@t400>
 <20141115205934.GB21240@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115205934.GB21240@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 09:59:34PM +0100, Pavel Machek wrote:
> On Sat 2014-11-15 21:12:18, Konrad Zapalowicz wrote:
> > On 11/15, Christian Resell wrote:
> > > Simple style fix (checkpatch.pl: "space prohibited before that ','").
> > > For the eudyptula challenge (http://eudyptula-challenge.org/).
> > 
> > Nice, however we do not need the information about the 'eudyptula
> > challenge' in the commit message.
> > 
> > If you want to include extra information please do it after the '---'
> > line (just below the signed-off). You will find more details in the
> > SubmittingPatches (chapter 15) of the kernel documentation.
> 
> Greg is staging tree maintainer... And if single extra space is all
> you can fix in the driver, perhaps it is not worth the patch?

I am not the maintainer of drivers/staging/media/ please look at
MAINTAINERS before you make statements like that.

And yes, one space fixes is just fine, that's why the code is in
staging.

greg k-h
