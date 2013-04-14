Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab3DNMU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 08:20:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58596 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3DNMUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 08:20:25 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 14 Apr 2013 05:20:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.9-rc6 Fixes
Message-ID: <20130414122040.GA16009@roeck-us.net>
References: <20130414071702.GH14155@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414071702.GH14155@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 09:17:03AM +0200, Wim Van Sebroeck wrote:
> Hi Linus,
> 
> Please pull from 'master' branch of
> 	git://www.linux-watchdog.org/linux-watchdog.git
> 
> It will fix compile errors for teh at91rm9200_wdt driver.
> 
> This will update the following files:
> 
>  Kconfig |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> with these Changes:
> 
> commit 09549cd01726a7ff8b102a93e46b059531583ab6
> Author: Nicolas Ferre <nicolas.ferre@atmel.com>
> Date:   Wed Apr 10 14:36:22 2013 +0200
> 
Hi Wim,

What is your take on "watchdog: Fix race condition in registration code" [1] ?

Thanks,
Guenter

[1] http://www.spinics.net/lists/linux-watchdog/msg02291.html,
    https://patchwork.kernel.org/patch/2400801/
