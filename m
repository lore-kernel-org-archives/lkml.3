Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaKEHCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:02:19 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:17342 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaKEHCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:02:17 -0500
X-IronPort-AV: E=Sophos;i="5.07,317,1413270000"; 
   d="scan'208";a="49760412"
Message-ID: <5459CB76.3060601@broadcom.com>
Date: Tue, 4 Nov 2014 23:02:14 -0800
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "Peter Griffin" <peter.griffin@linaro.org>,
        Chris Ball <chris@printf.net>, "Piotr Krol" <pietrushnic@gmail.com>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, <linux-rpi-kernel@lists.infradead.org>,
        Ray Jui <rjui@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCHv2 5/5] mmc: sdhci-bcm2835: add sdhci quirk SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12
References: <Scott Branden <sbranden@broadcom.com> <1414651017-3545-1-git-send-email-sbranden@broadcom.com> <1414651017-3545-6-git-send-email-sbranden@broadcom.com> <5459AEEA.8050503@wwwdotorg.org>
In-Reply-To: <5459AEEA.8050503@wwwdotorg.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-11-04 09:00 PM, Stephen Warren wrote:
> On 10/30/2014 12:36 AM, Scott Branden wrote:
>> SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 is missing and needed for this controller.
>
> This seems fine, although any explanation of why this quirk is needed
> would be useful.
>
I don't know who to talk to at Arasan about this.  Will try hunting 
around a little for more info as to why this is needed to have eMMC and 
SD work properly through our internal testing on other non-2835 chipset 
that shares the same SDHCI controller as 2835.
