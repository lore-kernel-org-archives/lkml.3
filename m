Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201Ab3FSIim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:38:42 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:61106 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755Ab3FSIij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:38:39 -0400
MIME-Version: 1.0
In-Reply-To: <201306191022.51630.marex@denx.de>
References: <1371527778-5236-1-git-send-email-chao.xie@marvell.com>
	<1371527778-5236-6-git-send-email-chao.xie@marvell.com>
	<201306191022.51630.marex@denx.de>
Date: Wed, 19 Jun 2013 16:38:38 +0800
Message-ID: <CADApbeiQWOi8SYEFf0bOsf1yn+TgXhwgDWaWFpGk7+nbC9bNDg@mail.gmail.com>
Subject: Re: [PATCH V3 5/5] input: pxa27x-keypad: add device tree support
From: Chao Xie <xiechao.mail@gmail.com>
To: Marek Vasut <marex@denx.de>
Cc: Chao Xie <chao.xie@marvell.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, drwyrm@gmail.com,
        stefan@openezx.org, laforge@openezx.org,
        Robert Jarzmik <robert.jarzmik@free.fr>, sleep_walker@suse.cz,
        slapin@ossfans.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 4:22 PM, Marek Vasut <marex@denx.de> wrote:
> Dear Chao Xie,
>
>> Signed-off-by: Chao Xie <chao.xie@marvell.com>
>> ---
>>  .../devicetree/bindings/input/pxa27x-keypad.txt    |   60 +++++
>>  drivers/input/keyboard/pxa27x_keypad.c             |  232
>> +++++++++++++++++++- 2 files changed, 288 insertions(+), 4 deletions(-)
>>  create mode 100644
>> Documentation/devicetree/bindings/input/pxa27x-keypad.txt
>>
>> diff --git a/Documentation/devicetree/bindings/input/pxa27x-keypad.txt
>> b/Documentation/devicetree/bindings/input/pxa27x-keypad.txt new file mode
>> 100644
>> index 0000000..f8674f7
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/input/pxa27x-keypad.txt
>> @@ -0,0 +1,60 @@
>> +* Marvell PXA Keypad controller
>> +
>> +Required Properties
>> +- compatible : should be "marvell,pxa27x-keypad"
>> +- reg : Address and length of the register set for the device
>> +- interrupts : The interrupt for the keypad controller
>> +- marvell,debounce-interval : How long time the key will be
>
> Is there no generic prop name for this debounce interval?
>
I searched at drivers/input and Documents.
Two drivers use "debounce-interval", gpio-keys.c and stmpe-keypad.c.
They describe the meanings of "debounce-interval" at its own document file.
Some other drivers uses "xxx,debounce-delay-ms" or "debounce-delay-ms"
So it seems that there is no generic prop name for this debounce interval.

> Best regards,
> Marek Vasut
