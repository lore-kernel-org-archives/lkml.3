Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab3HNJcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:32:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49372 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3HNJcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:32:03 -0400
Message-ID: <520B4E71.9000907@ti.com>
Date: Wed, 14 Aug 2013 12:31:29 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Benoit Cousson <bcousson@baylibre.com>, <p.zabel@pengutronix.de>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] usb: phy-nop: Use RESET Controller for managing the
 reset line
References: <1374137590-17865-1-git-send-email-rogerq@ti.com> <1374137590-17865-2-git-send-email-rogerq@ti.com> <20130725172855.GJ25415@radagast>
In-Reply-To: <20130725172855.GJ25415@radagast>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

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

Looks like the gpio reset driver might not make it into 3.12.

Now we have two options. 

1) leave the nop-phy driver as it is
2) get rid of using regulator framework for reset line and handle the reset
gpio directly in the nop-phy driver.

Is it already too late to get (2) into 3.12 if I send the patches in a day or 2?

cheers,
-roger

