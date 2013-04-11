Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab3DKHpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:45:09 -0400
Received: from mx16.lb01.inode.at ([62.99.145.18]:44127 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754654Ab3DKHpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:45:03 -0400
From: Michal Bachraty <michal.bachraty@streamunlimited.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Daniel Mack <zonque@gmail.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7] clk: add si5351 i2c common clock driver
Date: Thu, 11 Apr 2013 09:44:47 +0200
Message-ID: <11205025.2MA5VbIUoF@ganymedes>
Organization: Stream Unlimited GmbH
User-Agent: KMail/4.8.4 (Linux/3.2.0-29-generic-pae; KDE/4.8.4; i686; ; )
In-Reply-To: <5165A0FD.5030308@gmail.com>
References: <1365439617-18816-1-git-send-email-sebastian.hesselbarth@gmail.com> <14854575.YAd2OMKOy9@ganymedes> <5165A0FD.5030308@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Authenticated-Sender: michal.bachraty@streamunlimited.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Wednesday, April 10, 2013 19:27:25 Sebastian Hesselbarth wrote:
> Hmm, is there any driver using the clock output? Does it
> clk_prepare_enable() the clock? I tend not to mess with anything the
> bootloader or eeprom config left disabled. It works for me, but here the
> driver will prepare/enable the clock prior use.

For my case, disabled clock outputs in bootloader are correct. I'm working on 
module board with lot of purposes. For one I need to tune frequncy, for other 
not. In some cases I can use  clk_prepare_enable. For now, I need to tune clk, 
so I can't use clk_prepare_enable. Si5351 chip has no problem with enabling 
clock output multiple times, when calling clk_set_rate. So if this feature 
will not be in driver, I need to stay with patch upon driver.

Many thaks for writting driver,

Michal

