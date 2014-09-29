Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaI2KPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:15:52 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61592 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaI2KPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:15:50 -0400
Message-ID: <542930BC.4040806@gmail.com>
Date: Mon, 29 Sep 2014 15:43:16 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Anders Berg <anders.berg@avagotech.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2] i2c: axxia: Add I2C driver for AXM55xx
References: <1411983159-4692-1-git-send-email-anders.berg@avagotech.com> <54292F74.2030209@gmail.com> <20140929101319.GB1559@katana>
In-Reply-To: <20140929101319.GB1559@katana>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 03:43 PM, Wolfram Sang wrote:
>>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> Error checking on *res*...?
>>
>> We should *return* on platform_get_resource() failure..
>>
>>> +	base = devm_ioremap_resource(&pdev->dev, res);
> Nope. devm_ioremap_resource does that.
>
Yes it will [1]. Thanks for the clarification.

[1]:http://lxr.free-electrons.com/source/lib/devres.c#L117

-- 
Regards,
Varka Bhadram.

