Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967817Ab3E3Hlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:41:45 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:24972 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967621Ab3E3Hli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:41:38 -0400
Message-ID: <51A702AD.7000507@atmel.com>
Date: Thu, 30 May 2013 09:41:33 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Robert Nelson <Robert.Nelson@digikey.com>
Subject: Re: [PATCH v3 0/5] rtc-at91rm9200: add shadow interrupt mask
References: <1364983415-20298-1-git-send-email-jhovold@gmail.com> <1369298335-24597-1-git-send-email-jhovold@gmail.com>
In-Reply-To: <1369298335-24597-1-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/2013 10:38, Johan Hovold :
> This is an update of the shadow-interrupt-mask series against v3.10-rc2.
>
> I guess we need Atmel to confirm that all sam9x5 SoCs are indeed
> affected. If not, then some probing mechanism as the one Doug suggested
> could be implemented on top of (a subset of) these patches. What do you
> say, Nicolas?

No probing mechanism is needed: only sam9x5 are affected.

> Note that the first patch (adding a missing OF compile guard) could be
> applied straight away.
>
> Thanks,
> Johan
>
>
> v3:
>   - rebase against v3.10-rc2
>   - remove some comments

Thanks for rebasing this series.

Best regards,

> v2:
>   - rebase on top of DT-support patch by Joachim Eastwood
>   - add missing brace in DT-id table
>
>
> Johan Hovold (5):
>    rtc-at91rm9200: add match-table compile guard
>    rtc-at91rm9200: add configuration support
>    rtc-at91rm9200: refactor interrupt-register handling
>    rtc-at91rm9200: add shadow interrupt mask
>    rtc-at91rm9200: use shadow IMR on at91sam9x5
>
>   .../bindings/rtc/atmel,at91rm9200-rtc.txt          |   2 +-
>   arch/arm/boot/dts/at91sam9x5.dtsi                  |   2 +-
>   drivers/rtc/rtc-at91rm9200.c                       | 131 +++++++++++++++++----
>   3 files changed, 113 insertions(+), 22 deletions(-)
>


-- 
Nicolas Ferre
