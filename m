Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab3GZHuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:50:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40508 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248Ab3GZHum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:50:42 -0400
Message-ID: <51F22A30.80507@ti.com>
Date: Fri, 26 Jul 2013 10:50:08 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>, <p.zabel@pengutronix.de>
CC: <benoit.cousson@linaro.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] usb: phy-nop: Use RESET Controller for managing the
 reset line
References: <1374137590-17865-1-git-send-email-rogerq@ti.com> <1374137590-17865-2-git-send-email-rogerq@ti.com> <20130725172855.GJ25415@radagast>
In-Reply-To: <20130725172855.GJ25415@radagast>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 08:28 PM, Felipe Balbi wrote:
> On Thu, Jul 18, 2013 at 11:53:05AM +0300, Roger Quadros wrote:
>> Till now we were modelling the RESET line as a voltage regulator and
>> using the regulator framework to manage it.
>>
>> [1] introduces a GPIO based reset controller driver. We use that
>> to manage the PHY reset line, at least for DT boots. For legacy boots,
>> will still need to use the regulator framework for reset lines.
>>
>> [1] - http://thread.gmane.org/gmane.linux.drivers.devicetree/41348
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> that's not in mainline yet, right ? Is it guaranteed that it will hit
> v3.12 merge window ?
> 
Right. It isn't yet. I'm not sure about 3.12. Let's ask Philipp.

Philipp, is your GPIO Reset driver scheduled for 3.12?

cheers,
-roger
