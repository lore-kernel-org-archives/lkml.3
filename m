Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3I3O2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:28:30 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35372 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3I3O20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:28:26 -0400
Message-ID: <52498A7E.8080606@linaro.org>
Date: Mon, 30 Sep 2013 22:28:14 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Libo Chen <libo.chen@huawei.com>, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 1/4] driver core: introduce helper macro initcall_driver()
References: <1380518035-5319-1-git-send-email-hanjun.guo@linaro.org> <1380518035-5319-2-git-send-email-hanjun.guo@linaro.org> <20130930101500.GA3222@katana>
In-Reply-To: <20130930101500.GA3222@katana>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年09月30日 18:15, Wolfram Sang wrote:
> On Mon, Sep 30, 2013 at 01:13:52PM +0800, Hanjun Guo wrote:
>> For some devices especially on platform/I2C/SPI bus, they want to
>> be initialized earlier than other devices, so the driver use initcall
>> such as subsys_initcall to make this device initialize earlier.
> And this is something we want to get rid of in favor of deferred
> probing.
>
>> But for those drivers, lots of them just do nothing special in
>> xxx_initcall/exit, so introduce a helper macro initcall_driver() to
>> eliminate lots of boilerplate just like module_driver() did.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> So, NACK because using some *_initcall in drivers should not be
> encouraged.

Ok, got it. I agree with you, *_initcall in module driver is really
confusing people :)

Thanks
Hanjun
>
> Thanks,
>
>     Wolfram
>

