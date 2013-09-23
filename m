Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3IWH6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:58:22 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:42242 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab3IWH6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:58:20 -0400
Date: Mon, 23 Sep 2013 08:58:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Milo Kim <milo.kim@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 4/4] Documentation: add LP3943 DT bindings and document
Message-ID: <20130923075810.GC2185@lee--X1>
References: <1378949700-6384-1-git-send-email-milo.kim@ti.com>
 <20130912152455.GN11227@lee--X1>
 <523F0040.6050900@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <523F0040.6050900@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>+++ b/Documentation/lp3943.txt
> >>@@ -0,0 +1,62 @@
> >>+TI/National Semiconductor LP3943 MFD driver
> >>+===========================================

<snip>

> >Why do you need to document your driver in this way?
> >
> >If this stuff is really important (and most of it really isn't), then
> >put it either in the commit log or in the driver.
> 
> Unnecessary documentation makes it noisy, but I think the LP3943
> still needs the driver documentation for better understanding.
> 
> Many people think LP3943 is just LED driver, but I really want to
> share the application usages - PWM generators and GPIO expanders.
> If the driver just supports LED functionality, then it would be
> created as LED class driver. However, this patch-set enables more
> generic driver usages.
> So, this documentation would be helpful.
> 
> And I want to keep the code and the documentation separate.
> If the link address is changed, then only documentation file will be
> modified, not source file.
> 
> So, I'd like to create the fifth patch-set with new MFD
> documentation subdirectory.
> Additionally, LP3943 platform data example code will be added in the
> 'Documentation/mfd/lp3943.txt'. It's for a platform which doesn't
> support the device tree.

So, I'd actually like to get Sam's opinion on this.

NB: The documentation looks pretty rough at the moment. If we decide
to accept the concept, it will have to be adapted quite a bit before
full acceptance of the document will be granted.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
