Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3IPJrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:47:40 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:51723 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3IPJrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:47:39 -0400
Date: Mon, 16 Sep 2013 10:47:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Getz, Robin" <Robin.Getz@analog.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "denis.ciocca@st.com" <denis.ciocca@st.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 27/38] iio: pressure-core: st: Give some indication if
 device probing was successful
Message-ID: <20130916094733.GH3999@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-28-git-send-email-lee.jones@linaro.org>
 <43055af7-991f-4122-b308-a3dcddbbb72a@email.android.com>
 <20130911071053.GD11227@lee--X1>
 <52301963.5030006@metafoo.de>
 <20130911072955.GG11227@lee--X1>
 <FEAE1C531EE4684EBDD22603EC8BE59931CAB11B@NWD2MBX7.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FEAE1C531EE4684EBDD22603EC8BE59931CAB11B@NWD2MBX7.ad.analog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> echo "working:"
> cat /sys/bus/iio/devices/*/name
> 
> isn't too much digging. If you really want to do that on your machine - do so in rc.local

Okay, I was going round the long way, which is why is was difficult:

  /sys/class/i2c-adapter/i2c-2/2-005c/iio\:device2/name

I will revert the "registered" patches.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
