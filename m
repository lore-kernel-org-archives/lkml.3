Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3AWG2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 01:28:46 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:46701 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3AWG2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 01:28:44 -0500
Date: Tue, 22 Jan 2013 22:25:06 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 23/24] ab8500-bm: Fix minor niggles experienced during
 testing
Message-ID: <20130123062506.GA20858@lizard.gateway.2wire.net>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
 <1358769840-4763-24-git-send-email-lee.jones@linaro.org>
 <20130121191324.GA15037@lizard.mcd01528.sjc.wayport.net>
 <20130122092717.GI6857@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130122092717.GI6857@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 09:27:17AM +0000, Lee Jones wrote:
> On Mon, 21 Jan 2013, Anton Vorontsov wrote:
> 
> > On Mon, Jan 21, 2013 at 12:03:59PM +0000, Lee Jones wrote:
> > > When compile testing the new AB8500 Battery Management changes
> > > due for inclusion into upstream, there were a few minor niggles
> > > which required repairing, or adapting for use against the
> > > Mainline kernel. This patch is a collection of them all.
> > 
> > No. This is the third time I'm saying it: the last time I checked, this is
> > not how we do development in the mainline.
> 
> Okay, all of these changes have now been fixed-up into the patches
> which caused the issues. I have also added Stable to the patch you
> requested it on.
> 
> How would you like to proceed? Do you want a pull-request, or for me
> to send the patches to the list again?

Either way will work.

Thanks!

Anton

p.s. I took another look at the patches, and noticed one issue that is
constantly there: you place your signed-off-by line on top of everyones',
but that's wrong. Sign offs are going downwards, not upwards. This is
quite important since the lines encode how the code "travels" between
companies and submitters. Currently, one might assume that the origin of
the code is always Linaro, which is not quite true. (And 'From:' doesn't
always mean the author, fwiw.)
