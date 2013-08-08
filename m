Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966843Ab3HHWgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 18:36:25 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:43302 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966767Ab3HHWgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 18:36:24 -0400
Date: Fri, 9 Aug 2013 00:36:22 +0200 (CEST)
From: Peter Meerwald <p.meerwald@bct-electronic.com>
X-X-Sender: pmeerw@pmeerw.net
To: Bryan Wu <cooloney@gmail.com>
cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] leds-pca9633: Add support for PCA9634
In-Reply-To: <CAK5ve-+nnAGAnFNb6=QuekDMQwJ7w7h7k67dES0=wTN07n-9NA@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1308090013440.21412@pmeerw.net>
References: <1375980335-19943-1-git-send-email-ricardo.ribalda@gmail.com> <1375980335-19943-2-git-send-email-ricardo.ribalda@gmail.com> <CAK5ve-+nnAGAnFNb6=QuekDMQwJ7w7h7k67dES0=wTN07n-9NA@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > Add support for PCA9634 chip, which belongs to the same family as the
> > 9633 but with support for 8 outputs instead of 4.

> Basically I like this method to add a new chip supporting. Please find
> my comments below.

me too :)

> What about just rename the whole file to leds-pca963x.c. And rename
> some pca9633 to pca963x in the driver.

there are other, similar I2C LED driver chips which might be 
handled with the current pca9633 driver, e.g. the pca9685 (which is 
supported under pwm/ by the way)

people have argued that the numbering scheme of chips is hard to 
predict; hence, the driver name should be determined by the first 
device supported to avoid subsequent renaming -- but I have no strong
feelings about this

regards, p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
