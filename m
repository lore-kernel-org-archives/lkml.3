Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3GQJut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:50:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36770 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab3GQJur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:50:47 -0400
Message-ID: <51E668B4.1010000@ti.com>
Date: Wed, 17 Jul 2013 12:49:40 +0300
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: <tony@atomide.com>, <benoit.cousson@linaro.org>, <rnayak@ti.com>,
        <peter.ujfalusi@ti.com>, <kishon@ti.com>, <jic23@cam.ac.uk>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <lars@metafoo.de>, <sameo@linux.intel.com>, <ch.naveen@samsung.com>,
        <poeschel@lemonage.de>, <milo.kim@ti.com>, <balajitk@ti.com>,
        <gg@slimlogic.co.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver
References: <1373974023-23521-1-git-send-email-oleksandr.kozaruk@ti.com> <1373974023-23521-3-git-send-email-oleksandr.kozaruk@ti.com> <c8f86766-822b-4fe3-ae2a-e0b12412ef39@email.android.com>
In-Reply-To: <c8f86766-822b-4fe3-ae2a-e0b12412ef39@email.android.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.74]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jonathan,

 >Two very quick comments based on quick glance as it may be a while 
before I can do a full review.

 >We still have channels that are only usable for temperature being 
output to user space as voltage channels? Is the conversion so very hard?

Can you please clarify what should return temperature channel for 
in_tempX_input (processed)? Is it voltage or Celsius degree?
in_tempX_raw should return ADC code? Right?

Regards,
OK.
