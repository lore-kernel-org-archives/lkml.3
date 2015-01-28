Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbbA1UMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:12:44 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46177 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbbA1UMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:12:41 -0500
Message-ID: <54C90FD7.40601@collabora.co.uk>
Date: Wed, 28 Jan 2015 17:35:35 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-mmc@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] mmc: pwrseq: Document that simple sequence support
 more than one GPIO
References: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk> <1422439819-29854-2-git-send-email-javier.martinez@collabora.co.uk> <54C90F89.1040500@linaro.org>
In-Reply-To: <54C90F89.1040500@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srinivas,

On 01/28/2015 05:34 PM, Srinivas Kandagatla wrote:
>> -- reset-gpios : contains a GPIO specifier. The reset GPIO is asserted at
>> -	initialization and prior we start the power up procedure of the card. It
>> -	will be de-asserted right after the power has been provided to the card.
>> +- reset-gpios : contains a list of GPIO specifiers. The reset GPIOs are asserted
>> +	at initialization and prior we start the power up procedure of the card.
>> +	Will be de-asserted right after the power has been provided to the card.
> Makes sense if you add "They" before last sentence.

Thanks, I'll change it.

Best regards,
Javier

