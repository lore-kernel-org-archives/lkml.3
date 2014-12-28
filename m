Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaL1LQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 06:16:35 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41228 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaL1LQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 06:16:31 -0500
Message-ID: <549FE688.1060601@gmail.com>
Date: Sun, 28 Dec 2014 20:16:24 +0900
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
CC: Kukjin Kim <kgene@kernel.org>,
        =?UTF-8?B?6rmA7ZWZ7KO8?= <ruppi.kim@hardkernel.com>,
        Humberto Naves <hsnaves@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Johann Pfefferl <johann.pfefferl@siemens.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:PIN CONTROL SUBSY..." <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH v3 3/5] pinctrl: exynos: add exynos5410 SoC specific data
References: <547104D5.4030803@suse.de> <1416695185-5198-1-git-send-email-afaerber@suse.de>
In-Reply-To: <1416695185-5198-1-git-send-email-afaerber@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On 23.11.2014 07:26, Andreas Färber wrote:
> From: Hakjoo Kim <ruppi.kim@hardkernel.com>
>
> Add Samsung EXYNOS5410 SoC specific data to enable pinctrl
> support for all platforms based on EXYNOS5410.
>
> Signed-off-by: Hakjoo Kim <ruppi.kim@hardkernel.com>
> [AF: Rebased onto Exynos5260 and irq_chip consolidation]
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>   v2 -> v3:
>   * Rebased (.svc, .{g,w}eint_{con,mask,pend} fields dropped)
>
>   v1 -> v2:
>   * Filled in Sob from Hakjoo Kim

Any news on this patch? I'd like to ACK it, but apparently it is waiting 
for a rebase.

Sorry for the delay, unfortunately things are a little bit busy on my 
side nowadays.

Best regards,
Tomasz
