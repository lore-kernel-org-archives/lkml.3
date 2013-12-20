Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3LTOhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:37:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54613 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab3LTOhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:37:06 -0500
Message-ID: <52B455F9.8070707@ti.com>
Date: Fri, 20 Dec 2013 09:36:41 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, Sekhar Nori <nsekhar@ti.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] gpio: davinci: reuse for keystone arch
References: <1387361272-20861-1-git-send-email-grygorii.strashko@ti.com> <CACRpkdYcvtWNgJ=JCgpZFdZmypLu7UmtpyTQusRshSGT=EqsVg@mail.gmail.com>
In-Reply-To: <CACRpkdYcvtWNgJ=JCgpZFdZmypLu7UmtpyTQusRshSGT=EqsVg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 December 2013 04:40 AM, Linus Walleij wrote:
> On Wed, Dec 18, 2013 at 11:07 AM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
> 
>> This series is intended to update Davinci GPIO driver and reuse
>> it for Keystone SoCs, because Keystone uses the similar GPIO IP like Davinci.
>> Keystone GPIO IP: supports:
>> - up to 32 GPIO lines;
>> - only unbanked irqs;
>>
>> See Documentation:
>> Keystone - http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
>>
>> This series based on:
>> https://git.kernel.org/cgit/linux/kernel/git/nsekhar/linux-davinci.git/log/?h=v3.14/gpio
>>
>> Changes in v2:
>> - minor comments applied, no functional changes
>>
>> v1: https://lkml.org/lkml/2013/12/12/366
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
Great !!

> For this v2 series.
> 
> Expecting this to go in through the DaVinci tree!
> 
Sekhar, Can you please include these to your DaVinci gpio branch ?

Regards,
Santosh
