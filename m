Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048AbaE3TZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:25:24 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49091 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbaE3TZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:25:21 -0400
Date: Fri, 30 May 2014 20:25:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Make I2C ID tables non-mandatory for DT'ed and/or
 ACPI'ed devices
Message-ID: <20140530192516.GA4319@lee--X1>
References: <1401452797-29521-1-git-send-email-lee.jones@linaro.org>
 <1401452797-29521-2-git-send-email-lee.jones@linaro.org>
 <20140530123656.GC2742@katana>
 <20140530133405.GB29731@lee--X1>
 <20140530174800.GA4917@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140530174800.GA4917@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Would you mind telling me what I have changed that affects drivers
> > registering via Sysfs?
> 
> Check Documentation/i2c/instantiating-devices, method 4. If a driver
> does not have i2c_device_id, then this method won't work because the
> newly created device has no of_node or ACPI_node and nothing will match.
> Looking at the bigger picture, I'd really like to keep this feature.
> People use it.

Right, I read the function which provides the functionality, but my
point is; I don't think my patch changes the semantics in a way which
would adversely affect this option.  If you think that it does, can you
specify how please?

Does the sysfs method create a i2c_device_id table?  If not, how does
it probe successfully pre-patch?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
