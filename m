Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbaESRpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:45:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53969 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932438AbaESRpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:45:11 -0400
Message-ID: <537A4324.4060905@free-electrons.com>
Date: Mon, 19 May 2014 19:45:08 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org, Carlo Caione <carlo@caione.org>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 1/3] mfd: AXP22x: add support for APX221 PMIC
References: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com> <1400176305-22737-2-git-send-email-boris.brezillon@free-electrons.com> <20140519172817.GE20435@lee--X1>
In-Reply-To: <20140519172817.GE20435@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 19/05/2014 19:28, Lee Jones wrote:
>> This patch introduces preliminary support for the X-Powers AXP221 PMIC.
>> The AXP221 is typically used on boards using Allwinner's A31 SoC.
>>
>> At the moment, this driver only exposes regulator devices, but other
>> subdevices.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>  drivers/mfd/Kconfig        |  12 +++
>>  drivers/mfd/Makefile       |   1 +
>>  drivers/mfd/axp22x.c       | 237 +++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/axp22x.h | 149 ++++++++++++++++++++++++++++
>>  4 files changed, 399 insertions(+)
>>  create mode 100644 drivers/mfd/axp22x.c
>>  create mode 100644 include/linux/mfd/axp22x.h
> Not a chance.
>
> Farrrr, too much common code with axp20x.c - please merge into one file.
>

This was one of the questions I asked in my cover letter (could you take
a look at it and tell me what's your prefered solution ?) ;-).

I first tried to reuse the axp20x drivers, but ended up copying almost
all definitions, hence I decided to first do a different driver and ask
for advices.

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

