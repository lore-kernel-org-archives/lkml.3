Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbbAIRhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:37:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36651 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbbAIRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:37:12 -0500
Date: Fri, 9 Jan 2015 18:37:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC v10 01/19] leds: Add LED Flash class extension to the
 LED subsystem
Message-ID: <20150109173707.GB18076@amd>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-2-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420816989-1808-2-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2015-01-09 16:22:51, Jacek Anaszewski wrote:
> Some LED devices support two operation modes - torch and flash.
> This patch provides support for flash LED devices in the LED subsystem
> by introducing new sysfs attributes and kernel internal interface.
> The attributes being introduced are: flash_brightness, flash_strobe,
> flash_timeout, max_flash_timeout, max_flash_brightness, flash_fault,
> flash_sync_strobe and available_sync_leds. All the flash related
> features are placed in a separate module.
> 
> The modifications aim to be compatible with V4L2 framework requirements
> related to the flash devices management. The design assumes that V4L2
> sub-device can take of the LED class device control and communicate
> with it through the kernel internal interface. When V4L2 Flash sub-device
> file is opened, the LED class device sysfs interface is made
> unavailable.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
