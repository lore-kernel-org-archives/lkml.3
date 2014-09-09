Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaIIK3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:29:13 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:46433 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932299AbaIIK3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:29:09 -0400
Message-ID: <540ED671.5020103@itdev.co.uk>
Date: Tue, 09 Sep 2014 11:29:05 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] Input: atmel_mxt_ts: Add of node type to the i2c table
References: <1410249158-18192-1-git-send-email-sjoerd.simons@collabora.co.uk> <540ED495.20609@collabora.co.uk>
In-Reply-To: <540ED495.20609@collabora.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 11:21, Javier Martinez Canillas wrote:
> On 09/09/2014 09:52 AM, Sjoerd Simons wrote:
>> For i2c devices in OF the modalias exposed to userspace is i2c:<node
>> type>, for the Maxtouch driver this is i2c:maxtouch.
>>
>> Add maxtouch to the i2c id table such that userspace can correctly
>> load the module for the device and drop the OF table as it's not
>> needed for i2c devices.
> I see that Lee is working to allow the I2C subsystem to not need an I2C ID
> table to match [0]. I'll let Lee to comment what the future plans are and if
> his series are going to solve your issue since I'm not that familiar with the
> I2C core.
> 
> Best regards,
> Javier
> 
> [0]: https://lkml.org/lkml/2014/6/20/199

I can see the benefit of not having the duplication. Am I correct that
you're saying that it might make more sense to remove the i2c ids rather
than the OF table, if Lee's changes are accepted?
