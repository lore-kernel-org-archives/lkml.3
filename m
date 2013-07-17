Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3GQTEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:04:16 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:36171 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab3GQTEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:04:15 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <51E668B4.1010000@ti.com>
References: <1373974023-23521-1-git-send-email-oleksandr.kozaruk@ti.com> <1373974023-23521-3-git-send-email-oleksandr.kozaruk@ti.com> <c8f86766-822b-4fe3-ae2a-e0b12412ef39@email.android.com> <51E668B4.1010000@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/2] iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver
From: Jonathan Cameron <jic23@kernel.org>
Date: Wed, 17 Jul 2013 20:04:02 +0100
To: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
CC: tony@atomide.com, benoit.cousson@linaro.org, rnayak@ti.com,
        peter.ujfalusi@ti.com, kishon@ti.com, jic23@cam.ac.uk,
        grant.likely@linaro.org, rob.herring@calxeda.com, lars@metafoo.de,
        sameo@linux.intel.com, ch.naveen@samsung.com, poeschel@lemonage.de,
        milo.kim@ti.com, balajitk@ti.com, gg@slimlogic.co.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org
Message-ID: <7725cc73-4cab-49f5-9c33-ef3b24a7ee57@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Oleksandr Kozaruk <oleksandr.kozaruk@ti.com> wrote:
>Hello Jonathan,
>
> >Two very quick comments based on quick glance as it may be a while 
>before I can do a full review.
>
> >We still have channels that are only usable for temperature being 
>output to user space as voltage channels? Is the conversion so very
>hard?
>
>Can you please clarify what should return temperature channel for 
>in_tempX_input (processed)? Is it voltage or Celsius degree?
Milli degrees centigrade.

>in_tempX_raw should return ADC code? Right?
Yes

See Documentation/ABI/testing/sysfs-bus-iio
>
>Regards,
>OK.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
