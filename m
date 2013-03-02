Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab3CBXhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 18:37:25 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:55201 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3CBXhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 18:37:24 -0500
Date: Sat, 2 Mar 2013 15:33:35 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com
Subject: Re: [PATCH 00/40] Power: AB8500: Internal development push
Message-ID: <20130302233335.GA25293@lizard.sbx05280.losalca.wayport.net>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On Fri, Feb 15, 2013 at 12:44:30PM +0000, Lee Jones wrote:
> This is the 3rd and final instalment of the push to synchronise
> the ABx500 Battery Management series of internal development patches
> due for Mainline.
> 
> This patch-set submission is for reviewing purposes only. Please
> don't apply patches directly from this patch-set, as there are some
> interdependencies with another patch-set due for the MFD tree. We
> can chat about how to over-come this at a later date.

It looks so much better than the initial series! Frankly, I couldn't find
anything utterly wrong with it. :-)  (I did notice a couple of cosmetic
issues, but considering the amount of work and patches needed rebasing, it
would be insane of me to ask fixing these. :-)

So, I can easily merge it, as long as MFD part is either Acked or handled
somehow else. But I do want to merge the drivers/power/ part via battery
tree -- the part is quite large and thus prone to conflicts if someone
asks me to merge a patch that would touch the same lines.

Thanks so much!

Anton
