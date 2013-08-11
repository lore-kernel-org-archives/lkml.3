Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3HKJew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 05:34:52 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33563 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab3HKJes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 05:34:48 -0400
MIME-Version: 1.0
In-Reply-To: <518397C60809E147AF5323E0420B992E3EADAFCF@DBDE04.ent.ti.com>
References: <1371203020-15092-1-git-send-email-avinashphilip@ti.com> <518397C60809E147AF5323E0420B992E3EADAFCF@DBDE04.ent.ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 11 Aug 2013 15:04:26 +0530
Message-ID: <CA+V-a8sNPMbQjh8uxhQ=aOgo4ZfmaKXoOnRsuurzEeWzBKW8WA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] GPIO DT support for da850
To: Sekhar Nori <nsekhar@ti.com>
Cc: "Philip, Avinash" <avinashphilip@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "vinashphilip@ti.com" <vinashphilip@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Fri, Jun 14, 2013 at 3:50 PM, Philip, Avinash <avinashphilip@ti.com> wrote:
> On Fri, Jun 14, 2013 at 15:13:36, Philip, Avinash wrote:
>> With conversion of GPIO davinci driver to platform driver, gpio-davinci driver
>> can support DT boot.
>> This patch series
>> - adds dt binding support for gpio-davinci.
>> - da850 dt support goio.
>>
>> This patch series is based on Linux 3.10-rc4 and is availabel at [1].
>>
>> 1. https://github.com/avinashphilip/am335x_linux/tree/linux_davinci_v3.10_soc_gpio_v310-rc4
>
>
> This patch series has dependency on [PATCH v2 0/7] Convert GPIO Davinci to platform driver
>
> https://lkml.org/lkml/2013/6/14/120
>
What is the status of this patch series is any one taking care of it or
else I can take care of review comments and repost them.

Regards,
--Prabhakar Lad
