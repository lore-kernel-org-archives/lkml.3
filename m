Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab3JWJis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:38:48 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:44794 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3JWJiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:38:46 -0400
Message-ID: <52679922.1050004@baylibre.com>
Date: Wed, 23 Oct 2013 11:38:42 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Tony Lindgren <tony@atomide.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ARM: dts: omap5-uevm: Audio related fixes
References: <1382520740-11197-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1382520740-11197-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 23/10/2013 11:32, Peter Ujfalusi wrote:
> Hi,
>
> When the omap5-evm.dts file has been renamed to omap5-uevm.dts and the sEVM
> support got deprecated in favor of uEVM (or Panda5) the content was not
> validated.
> The reset GPIO is different on uEVM compared to sEVM and uEVM does not have
> support for dmic.
>
> Regards,
> Peter

I've just applied your series, let's try to push that for 3.13.

Thanks,
Benoit


> ---
> Peter Ujfalusi (2):
>    ARM: dts: omap5-uevm: Correct twl6040 reset GPIO pinmux
>    ARM: dts: omap5-uevm: Remove pinmux for dmic pins
>
>   arch/arm/boot/dts/omap5-uevm.dts | 12 +-----------
>   1 file changed, 1 insertion(+), 11 deletions(-)
>


-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com
