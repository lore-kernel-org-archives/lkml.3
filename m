Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbbATPl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:41:26 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:36968 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbATPlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:41:22 -0500
Date: Tue, 20 Jan 2015 15:41:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 05/19] mfd: max77693: Modify flash cell name
 identifiers
Message-ID: <20150120154115.GD13701@x1>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-6-git-send-email-j.anaszewski@samsung.com>
 <20150120111346.GD13701@x1>
 <54BE50AD.7080801@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BE50AD.7080801@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Jacek Anaszewski wrote:

> On 01/20/2015 12:13 PM, Lee Jones wrote:
> >On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
> >
> >>Change flash cell identifiers from max77693-flash to max77693-led
> >>to avoid confusion with NOR/NAND Flash.
> >
> >This is okay by me, but aren't these ABI yet?
> 
> No, the led driver using it hasn't been merged yet.

Very well.

For my on reference:

Acked-by: Lee Jones <lee.jones@linaro.org>

> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>Cc: Chanwoo Choi <cw00.choi@samsung.com>
> >>Cc: Lee Jones <lee.jones@linaro.org>
> >>---
> >>  drivers/mfd/max77693.c |    4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> >>index a159593..cb14afa 100644
> >>--- a/drivers/mfd/max77693.c
> >>+++ b/drivers/mfd/max77693.c
> >>@@ -53,8 +53,8 @@ static const struct mfd_cell max77693_devs[] = {
> >>  		.of_compatible = "maxim,max77693-haptic",
> >>  	},
> >>  	{
> >>-		.name = "max77693-flash",
> >>-		.of_compatible = "maxim,max77693-flash",
> >>+		.name = "max77693-led",
> >>+		.of_compatible = "maxim,max77693-led",
> >>  	},
> >>  };
> >>
> >
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
