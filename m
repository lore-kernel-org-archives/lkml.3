Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3IOWrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 18:47:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33072 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab3IOWr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 18:47:28 -0400
Message-ID: <523638FC.1030006@ti.com>
Date: Mon, 16 Sep 2013 07:47:24 +0900
From: Milo Kim <milo.kim@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 0/4] LP3943 MFD driver for a GPIO expander and a PWM
 generator
References: <1378949441-6073-1-git-send-email-milo.kim@ti.com> <20130912152809.GO11227@lee--X1> <20130915111730.GA9765@ulmo>
In-Reply-To: <20130915111730.GA9765@ulmo>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 09/15/2013 08:17 PM, Thierry Reding wrote:
> On Thu, Sep 12, 2013 at 04:28:09PM +0100, Lee Jones wrote:
>>> * Documentation
>>>    From Thierry's suggestion, detailed driver description was moved to
>>>    'Documentation/lp3943.txt'.
>>
>> Really? Why here? Do we really want 1000's of driver docs in /Documentation?

There is no subdirectory for GPIO and PWM documents under 'Documentation'.
That's why I put LP3943 documentation here.

>> No other driver does this (intel gained from a glancing look).

I thought it's no issue because I still found few driver documentations 
in that location.
It sounds like people are moving those into other subdirectories.
Thanks for this information.

> Well, perhaps the top-level Documentation directory isn't optimal, but I
> think it's a lot better than the commit description. Perhaps an 'mfd'
> subdirectory could be created where documentation such as this could be
> put.

I agree Thierry.
If you don't mind, can I create a MFD subdirectory with this patch-set 
in next version, v4?
Any other ideas are welcome.

Best regards,
Milo



