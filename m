Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaEHQmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:42:14 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60044 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbaEHQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:42:09 -0400
Date: Thu, 8 May 2014 09:41:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, dwmw2@infradead.org, dmitry.torokhov@gmail.com,
        balbi@ti.com, gregkh@linuxfoundation.org, plagnioj@jcrosoft.com,
        jic23@kernel.org, josh.wu@atmel.com, kishon@ti.com,
        linus.walleij@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        nicolas.ferre@atmel.com, ohad@wizery.com, linux@arm.linux.org.uk,
        tony@atomide.com, vinod.koul@intel.com, wim@iguana.be,
        wsa@the-dreams.de, dmaengine@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-watchdog@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/22] Random ARM randconfig fixes in drivers
Message-ID: <20140508164157.GA22224@roeck-us.net>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 04:46:51PM +0200, Arnd Bergmann wrote:
> These are a bunch of fixes I had to do to get all randconfig
> configurations on ARM working. Most of these are really old
> bugs, but there are also some new ones. I don't think any of
> them require a backport to linux-stable.
> 
> I have checked that they are all still required on yesterday's
> linux-next kernel. Please apply on the appropriate trees unless
> there are objections.
> 
Is this series of patches also going to fix arm:allmodconfig ?

Thanks,
Guenter
