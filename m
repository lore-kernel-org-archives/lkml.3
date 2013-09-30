Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3I3OXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:23:30 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54577 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab3I3OX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:23:28 -0400
Message-ID: <52498952.9040604@linaro.org>
Date: Mon, 30 Sep 2013 22:23:14 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Libo Chen <libo.chen@huawei.com>, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 1/4] driver core: introduce helper macro initcall_driver()
References: <1380518035-5319-1-git-send-email-hanjun.guo@linaro.org> <1380518035-5319-2-git-send-email-hanjun.guo@linaro.org> <20130930091622.GW19304@sirena.org.uk>
In-Reply-To: <20130930091622.GW19304@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年09月30日 17:16, Mark Brown wrote:
> On Mon, Sep 30, 2013 at 01:13:52PM +0800, Hanjun Guo wrote:
>> For some devices especially on platform/I2C/SPI bus, they want to
>> be initialized earlier than other devices, so the driver use initcall
>> such as subsys_initcall to make this device initialize earlier.
> We're trying to move away from needing to do this and to using deferred
> probing to resolve init ordering issues.  Should we not be able to
> convert the drivers to module_X_driver()?
Hi Mark,

Thanks for your comments.

That would be great to move away *_initcall in module driver, and
this patch set is not necessary if we can use deferred probe to solve
all the init order issues.

Thanks
Hanjun
