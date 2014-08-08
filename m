Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbaHHN3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:29:39 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54072 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaHHN3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:29:36 -0400
Message-ID: <53E4D0BA.7050106@gmail.com>
Date: Fri, 08 Aug 2014 15:29:30 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org,
        Hakjoo Kim <ruppi.kim@hardkernel.com>
CC: Tarek Dakhran <t.dakhran@samsung.com>, Kevin Hilman <khilman@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [RFC 4/5] ARM: dts: add pinctrl support to Exynos5410
References: <1406549892-5558-1-git-send-email-afaerber@suse.de> <1406549892-5558-5-git-send-email-afaerber@suse.de>
In-Reply-To: <1406549892-5558-5-git-send-email-afaerber@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please see my comment inline.

On 28.07.2014 14:18, Andreas Färber wrote:
> From: Hakjoo Kim <ruppi.kim@hardkernel.com>
> 
> Add the required pin configuration support to Exynos5410 using pinctrl
> interface.

[snip]

> +	pinctrl_0: pinctrl@13400000 {
> +		compatible = "samsung,exynos5410-pinctrl";
> +		reg = <0x13400000 0x1000>;
> +		interrupts = <0 45 0>;

I believe you are missing the wake-up IRQ controller node here, which is
needed to handle the interrupts of EINTW (gpxN) banks.

Best regards,
Tomasz
