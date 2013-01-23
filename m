Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3AWIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:16:56 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:52430 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3AWIQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:16:55 -0500
Date: Wed, 23 Jan 2013 08:16:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 23/24] ab8500-bm: Fix minor niggles experienced during
 testing
Message-ID: <20130123081650.GE15873@gmail.com>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
 <1358769840-4763-24-git-send-email-lee.jones@linaro.org>
 <20130121191324.GA15037@lizard.mcd01528.sjc.wayport.net>
 <20130122092717.GI6857@gmail.com>
 <20130123062506.GA20858@lizard.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130123062506.GA20858@lizard.gateway.2wire.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013, Anton Vorontsov wrote:

> On Tue, Jan 22, 2013 at 09:27:17AM +0000, Lee Jones wrote:
> > On Mon, 21 Jan 2013, Anton Vorontsov wrote:
> > 
> > > On Mon, Jan 21, 2013 at 12:03:59PM +0000, Lee Jones wrote:
> > > > When compile testing the new AB8500 Battery Management changes
> > > > due for inclusion into upstream, there were a few minor niggles
> > > > which required repairing, or adapting for use against the
> > > > Mainline kernel. This patch is a collection of them all.
> > > 
> > > No. This is the third time I'm saying it: the last time I checked, this is
> > > not how we do development in the mainline.
> > 
> > Okay, all of these changes have now been fixed-up into the patches
> > which caused the issues. I have also added Stable to the patch you
> > requested it on.
> > 
> > How would you like to proceed? Do you want a pull-request, or for me
> > to send the patches to the list again?
> 
> Either way will work.
> 
> Thanks!
> 
> Anton
> 
> p.s. I took another look at the patches, and noticed one issue that is
> constantly there: you place your signed-off-by line on top of everyones',
> but that's wrong. Sign offs are going downwards, not upwards. This is
> quite important since the lines encode how the code "travels" between
> companies and submitters. Currently, one might assume that the origin of
> the code is always Linaro, which is not quite true. (And 'From:' doesn't
> always mean the author, fwiw.)

Thanks for the info. I'll move them all and re-submit.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
