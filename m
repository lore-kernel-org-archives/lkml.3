Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaBNJvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:51:42 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:23894 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaBNJvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:51:39 -0500
Message-ID: <52FDE719.4040107@atmel.com>
Date: Fri, 14 Feb 2014 10:51:21 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 0/3] arm: at91: update defconfigs
References: <1392147841-7815-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1392147841-7815-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2014 20:43, Alexandre Belloni :
> A few at91 defconfigs where not updated in a long time, refresh the configs for
> at91sam9rl and at91sam9260/at91sam9g20.
> 
> Alexandre Belloni (3):
>   arm: at91sam9rl: refresh defconfig
>   arm: at91sam9260_9g20: remove useless configuration
>   arm: at91sam9260_9g20: refresh configuration
> 
>  arch/arm/configs/at91sam9260_9g20_defconfig |  9 ++-------
>  arch/arm/configs/at91sam9rl_defconfig       | 10 +++++++---
>  2 files changed, 9 insertions(+), 10 deletions(-)


Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

stacked in at91-3.15-cleanup

Thanks, bye,
-- 
Nicolas Ferre
