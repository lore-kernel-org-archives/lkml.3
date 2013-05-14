Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3ENDIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 23:08:00 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58614 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3ENDH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 23:07:59 -0400
Message-ID: <5191AA89.6010901@linaro.org>
Date: Tue, 14 May 2013 08:37:53 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        olof@lixom.net, dianders@chromium.org, patches@linaro.org
Subject: Re: [PATCH] ARM: EXYNOS: Update defconfig for Arndale and Origen
 board
References: <1368168599-28507-1-git-send-email-tushar.behera@linaro.org> <87sj1qzaov.fsf@linaro.org>
In-Reply-To: <87sj1qzaov.fsf@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 05:36 AM, Kevin Hilman wrote:
> Tushar Behera <tushar.behera@linaro.org> writes:
> 
>> It updates following drivers for EXYNOS based DT platform.
>>
>> * S5M8767 driver
>> * MAX8997 driver
>> * MMC SDHCI driver
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> 
> I tested this using v3.10-rc1 on Arndale, but still don't get any
> support for the wired network.  Do you know if this is a Kconfig issue,
> or a missing driver?
> 
> I suspect it may be related to the various "unable to find transceiver
> of type USB2 PHY" messages I'm seeing?
> 

Yes, right. The missing USB-PHY components are one of the issues (they
were there in linux-next when I last tested).

Also, on Arndale board, we need to reset the USB hub during EHCI
initialization (a couple of those patches are required, which I am not
sure if we would be able to upstream).

I am collecting a minimal set of patches that would enable USB and wired
network on Arndale with 3.10-rc1 kernel. Once done, I will let you know.

> Thanks,
> 
> Kevin
> 

Thanks for testing.


-- 
Tushar Behera
