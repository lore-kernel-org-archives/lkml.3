Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3A2WoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:44:21 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:37373 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3A2WoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:44:19 -0500
Message-ID: <510850BF.7070003@free-electrons.com>
Date: Tue, 29 Jan 2013 23:44:15 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] ARM: sunxi: gpio: Add Allwinner SoCs GPIO drivers
References: <1359405192-1192-1-git-send-email-maxime.ripard@free-electrons.com> <CACRpkdaNz6szEu6v=C97MfUzQzM3rG1hGHtHdO-aWXLCgHQEeQ@mail.gmail.com>
In-Reply-To: <CACRpkdaNz6szEu6v=C97MfUzQzM3rG1hGHtHdO-aWXLCgHQEeQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Le 29/01/2013 23:38, Linus Walleij a écrit :
> On Mon, Jan 28, 2013 at 9:33 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> 
>> The IP responsible for the muxing on the Allwinner SoCs are also
>> handling the GPIOs on the system. This patch adds the needed driver that
>> relies on the pinctrl driver for most of its operations.
>>
>> The number of pins available for GPIOs operations are already declared
>> in the pinctrl driver, we only need to probe a generic driver to handle
>> the banks available for each SoC.
>>
>> This driver has been tested on a A13-Olinuxino.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> 
> Applied to my allwinner branch.
> 
> I'm a bit confused with other patches floating around,
> I hope I'm supposed to apply this first...

Ah, yes, sorry, I forgot to mention the order of the patchset.

This one is indeed the first one, then comes "Add pinctrl/gpio support
for A10 SoCs", and finally "Add support for user LED on the A13-Olinuxino".

Since you already started to merge most of the patches for the sunxi
device tree, maybe the most reasonnable thing to do to avoid merge
conflicts would be for you to merge all of these patches.

Thanks!
Maxime


-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
