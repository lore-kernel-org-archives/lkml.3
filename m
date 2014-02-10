Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaBJSCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:02:09 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:38765 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbaBJSCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:02:05 -0500
Date: Mon, 10 Feb 2014 18:01:59 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Laszlo Papp <lpapp@kde.org>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: (max6650) Rename the device ids to  contain the
 hwmon suffix
Message-ID: <20140210180159.GF26997@lee--X1>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
 <20140210160842.GB26997@lee--X1>
 <20140210173811.04ba5964@endymion.delvare>
 <20140210165853.GD26997@lee--X1>
 <20140210184323.456e921c@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140210184323.456e921c@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Might be worth taking the opportunity to swap out these magic numbers
> > > > now.
> > > 
> > > There's nothing magic about them, they tell the driver how many fans
> > > each device supports. If you don't pass them as driver_data you'll have
> > > to derive them from the device name in the probe function.
> > 
> > They're magic in that they're not easily identifiable. In the few
> > moments that I looked at the patch I assumed they were device
> > IDs. They should be clearly defined.
> 
> They could have been device IDs, some drivers do that, and that would
> have been equally fine. driver_data can be anything. Best thing to do
> is to document it right above the device id array if you really find it
> confusing (I don't.) I don't know what else exactly you had in mind,
> but #defining FOUR_FANS as 4 and ONE_FAN as 1 and using that doesn't
> strike me as the best coding practice.

On the contrary. Perhaps the nomenclature can be worked on a little,
but if I saw the aforementioned defines I would have known instantly
what was being defined without searching for co-located comments. Thus
elevating the requirement for me to even mention it. Even when we
use the .data element for very simple information such as device IDs
we do so with a #define.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
