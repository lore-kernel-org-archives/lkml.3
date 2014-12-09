Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbaLIKCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:02:35 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:59914 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbaLIKCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:02:32 -0500
Date: Tue, 9 Dec 2014 10:02:24 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v9 03/19] mfd: max77693: Modify flash cell name
 identifiers
Message-ID: <20141209100224.GV3951@x1>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-4-git-send-email-j.anaszewski@samsung.com>
 <20141209085216.GS3951@x1>
 <5486BE6C.9010408@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5486BE6C.9010408@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Dec 2014, Jacek Anaszewski wrote:

> On 12/09/2014 09:52 AM, Lee Jones wrote:
> >On Wed, 03 Dec 2014, Jacek Anaszewski wrote:
> >
> >>Change flash cell identifiers from max77693-flash to max77693-led
> >>to avoid confusion with NOR/NAND Flash.
> >>
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
> >
> >This is fine by me, so long as you've been through the usual
> >deprecation procedures or this platform is still WiP.
> 
> It was me who added of_compatible for max77693-flash, but the
> related led driver has not been yet merged and there are no
> other drivers depending on it.

Very well.

For my own reference:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
