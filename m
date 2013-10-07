Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab3JGNuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 09:50:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47111 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab3JGNuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 09:50:37 -0400
Message-ID: <5252BBF5.1060406@ti.com>
Date: Mon, 7 Oct 2013 16:49:41 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, <kishon@ti.com>
CC: <bcousson@baylibre.com>, <pavel@ucw.cz>, <aaro.koskinen@iki.fi>,
        <marek@goldelico.com>, <balbi@ti.com>, <tony@atomide.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ARM: dts: omap3:  Adapt USB OTG to generic PHY framework
References: <1381152493-28055-1-git-send-email-rogerq@ti.com> <1381152493-28055-2-git-send-email-rogerq@ti.com> <5252B9C7.5040109@linutronix.de>
In-Reply-To: <5252B9C7.5040109@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 04:40 PM, Sebastian Andrzej Siewior wrote:
> On 10/07/2013 03:28 PM, Roger Quadros wrote:
>> The generic PHY framewrok expects different properties than the
>> old USB PHY framework. Supply those properties.
>>
>> Fixes USB OTG port on GAT04 and N900 after the Generic PHY framework was
>> merged in greg/usb-next. [1]
> 
> Would it be much pain (and do we want this at all) to add a fallback
> into the kernel or at least a printk pointing out to update the .dts
> for two releases or so? So the user does not need to spent hours to
> figure out why it suddenly stopped working.
> 

I agree with you. 

Also, figuring out which kernel configs to enable for
USB OTG to work on OMAP is a pain in itself to the user.

cheers,
-roger

