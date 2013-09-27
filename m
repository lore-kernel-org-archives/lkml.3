Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab3I0H37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 03:29:59 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60281 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3I0H35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 03:29:57 -0400
Date: Fri, 27 Sep 2013 08:29:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] max77693: remove device wakeup from driver
Message-ID: <20130927072949.GB5100@lee--X1>
References: <1377104014-21910-1-git-send-email-a.hajda@samsung.com>
 <1377104014-21910-2-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377104014-21910-2-git-send-email-a.hajda@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The patch removes wakeup related code from
> the driver and plaftorm data - it is already
> handled by i2c core using I2C_CLIENT_WAKE flag
> from struct i2c_board_info. As a result MFD
> itself do not requires platform data.

I have expanded this to use more than 46 chars of the line
buffer. Please also do this for future submissions.

> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/max77693.c               | 10 ----------
>  include/linux/mfd/max77693-private.h |  1 -
>  include/linux/mfd/max77693.h         |  2 --
>  3 files changed, 13 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
