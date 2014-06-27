Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaF0IyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:54:17 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33804 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaF0IyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:54:15 -0400
Message-ID: <53AD312C.90005@collabora.co.uk>
Date: Fri, 27 Jun 2014 10:54:04 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/14] clk: max77686: Add DT include for MAX77686 PMIC
 clock
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk> <1403806546-31122-4-git-send-email-javier.martinez@collabora.co.uk> <53AD21E5.1030609@suse.de> <53AD22ED.5040303@collabora.co.uk> <53AD2AB7.1090000@suse.de>
In-Reply-To: <53AD2AB7.1090000@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

On 06/27/2014 10:26 AM, Andreas Färber wrote:
> Hi Javier,
> 
> Am 27.06.2014 09:53, schrieb Javier Martinez Canillas:
>> Hello Andreas,
>> 
>> On 06/27/2014 09:48 AM, Andreas Färber wrote:
>>> Am 26.06.2014 20:15, schrieb Javier Martinez Canillas:
>>>> This patch adds a dt-binding include for Maxim 77686
>>>> PMIC clock IDs that can be to be shared between the
>>>
>>> "can be shared"?
>>>
>> 
>> As it should be quite clear right now I'm not a native English speaker.
> 
> Guessed so, me neither. But since it's v5 already and no native speaker
> pointed it out, I took the liberty to do so while verifying that the
> LD02 typo didn't propagate into your bindings documentation (it didn't).
> 
>> I meant
>> that the header file can be included by both Device Tree source files and the
>> max77802 driver.
> 
> AFAIU "clock IDs to be shared" and "clock IDs that can be shared" would
> both be valid, but above a verb is missing (e.g., "can be used to").
> 
> Thanks for your upstreaming efforts, and don't let me discourage you.
> 

No discourage at all, your feedback is highly appreciated and sorry that I
didn't catch all these typos when working on the DT documentation.

> Best regards,
> 
> Andreas
> 

Best regards,
Javier
