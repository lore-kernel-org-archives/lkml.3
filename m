Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaJNGT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 02:19:56 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:49286 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754087AbaJNGTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 02:19:54 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
Message-ID: <543CC015.6090709@smartplayin.com>
Date: Tue, 14 Oct 2014 11:47:57 +0530
From: Kiran Padwal <kiran.padwal@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 3/3] spi: qup: Remove .owner field for driver
References: <1412840528-31508-1-git-send-email-kiran.padwal@smartplayin.com> <20141013130918.GY27755@sirena.org.uk>
In-Reply-To: <20141013130918.GY27755@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 October 2014 06:39 PM, Mark Brown wrote:
> On Thu, Oct 09, 2014 at 01:12:08PM +0530, Kiran Padwal wrote:
>> There is no need to init .owner field.
>>
>> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
>> "mmc: remove .owner field for drivers using module_platform_driver"
>>
>> This patch removes the superfluous .owner field for drivers which
>> use the module_platform_driver API, as this is overridden in
>> platform_driver_register anyway."
> 
> Two problems:
>  - I'm missing patches 1 and 2.

These patches are same like this one,
[1] https://lkml.org/lkml/2014/10/9/58
[2] https://lkml.org/lkml/2014/10/9/52

>  - This only changes one driver but essentially every SPI driver
>    initializes .owner - why is only thi sone driver being changed?
> 

Nothing more intention, but just remove superfluous .owner field for drivers which
use the module_platform_driver API, as this is overridden in
platform_driver_register anyway.

Thanks,
--Kiran
