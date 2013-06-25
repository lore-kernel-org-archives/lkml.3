Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044Ab3FYFHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 01:07:44 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:53532 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3FYFHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 01:07:43 -0400
Message-ID: <51C92537.2070304@atmel.com>
Date: Tue, 25 Jun 2013 13:05:59 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Wenyou Yang <wenyou.yang@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: at91/PMC: fix at91sam9n12 USB FS init
References: <1372091879-28459-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1372091879-28459-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On 06/25/2013 12:37 AM, Nicolas Ferre wrote:
> at91sam9n12 has Full-speed only USB. So we should add
> it to the list in at91_pllb_usbfs_clock_init() function.
> Moreover, at91sam9n12 has an unusual PMC in the sense that it
> has a PLLB but also has a USB clock register.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>   arch/arm/mach-at91/clock.c                 | 25 +++++++++++++++++++++----
>   arch/arm/mach-at91/include/mach/at91_pmc.h |  3 +++
>   2 files changed, 24 insertions(+), 4 deletions(-)

For this series, test on at91sam9n12ek board, all are OK.

Tested-by: Bo Shen <voice.shen@atmel.com>

Best Regards,
Bo Shen

