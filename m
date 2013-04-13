Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3DMBgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 21:36:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59863 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3DMBgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 21:36:17 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 12 Apr 2013 18:36:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anthony Olech <anthony.olech.opensource@diasemi.com>,
        Jean Delvare <khali@linux-fr.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Randy Dunlap <rdunlap@xenotime.net>, lm-sensors@lm-sensors.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V4 6/7] DA9058 HWMON driver
Message-ID: <20130413013630.GC14726@roeck-us.net>
References: <201304121312.r3CDCJte011826@latitude>
 <51682E0C.4090605@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51682E0C.4090605@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 05:53:48PM +0200, Lars-Peter Clausen wrote:
> On 04/12/2013 03:05 PM, Anthony Olech wrote:
> > This is the HWMON component driver of the Dialog DA9058 PMIC.
> > This driver is just one component of the whole DA9058 PMIC driver.
> > It depends on the CORE and ADC component drivers of the DA9058 MFD.
> > 
> > Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> > Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
> 
> Hi,
> 
> can't you use the generic IIO to HWMON bridge driver? And if not it's probably
> better to extent the bridge driver than writing this custom driver.
> 
I like that idea.

Guenter
