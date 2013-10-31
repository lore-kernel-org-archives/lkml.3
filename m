Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3JaBUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 21:20:30 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:43255 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3JaBU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 21:20:28 -0400
Message-ID: <5271B012.4060200@atmel.com>
Date: Thu, 31 Oct 2013 09:19:14 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Johan Hovold <jhovold@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] misc: atmel_pwm: set initcall level to subsys
References: <1382459560-26596-1-git-send-email-jhovold@gmail.com> <20131029232249.GA20476@kroah.com> <20131030110705.GA29813@localhost> <201310302146.18248.arnd@arndb.de>
In-Reply-To: <201310302146.18248.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 10/31/2013 04:46, Arnd Bergmann wrote:
> On Wednesday 30 October 2013, Johan Hovold wrote:
>>> I really hate this type of patch, as it's papering over the real
>>> problem.  What happens when someone else moves their driver to this
>>> level?  Then you are back to the original problem.
>>
>> Yes, it's crude, but it's currently the only way to express a preferred
>> probe order.
>
> Does the same problem occur with the generic PWM subsystem?
>
> The atmel_pwm driver apparently is the last PWM driver that has
> not been converted to the generic subsystem yet. Doing that would
> also let us drop the atmel-pwm-bl driver in favor of the generic
> backlight.

The atmel pwm driver is on the way to generic subsystem. more 
information at:
--->8---
PWM: atmel-pwm: add PWM controller driver:
    https://patchwork.kernel.org/patch/2963081/
---<8---

Best Regards,
Bo Shen

