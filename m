Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab3J2QVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:21:47 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37418 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956Ab3J2QVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:21:45 -0400
Date: Tue, 29 Oct 2013 09:21:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Watchdog patches - overview.
Message-ID: <20131029162143.GD9266@roeck-us.net>
References: <20131029090458.GN19704@spo001.leaseweb.com>
 <20131029091139.GA20422@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029091139.GA20422@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 10:11:39AM +0100, Wim Van Sebroeck wrote:
> Hi All,
> 
> > 2) patches that I am reviewing or are on my radar:
> > w83627hf-patches
> > Orion-patches
> > f81865_gpio.c
> > [PATCH V2 0/4] Add watchdog DT nodes and parse it to read PMU registers addresses (Exynos+s3c2410_wdt)
> > [PATCH v4 4/4] ARM: bcm4760: Add restart hook
> > [PATCH] Documentation/watchdog: Update node name in samsung-wdt example
> 
> And also:
> [PATCH v3] Enhanced support for MPC8xx/8xxx watchdog

I had not reviewed on this one, as I think that such enhancements
should really start with a conversion to the watchdog infrastructure.
That is just my personal opinion, of course.

Thanks,
Guenter
