Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaFWSi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:38:59 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:59553 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbaFWSi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:38:57 -0400
Message-ID: <53A8743B.8020404@linaro.org>
Date: Mon, 23 Jun 2014 19:38:51 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-ide@vger.kernel.org,
        Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH] phy: qcom: Add driver for QCOM APQ8064 SATA PHY
References: <1403546409-10860-1-git-send-email-srinivas.kandagatla@linaro.org> <C77397FA-1247-4D99-A0AC-9EFE45F7036E@codeaurora.org>
In-Reply-To: <C77397FA-1247-4D99-A0AC-9EFE45F7036E@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/06/14 19:12, Kumar Gala wrote:
>
> On Jun 23, 2014, at 1:00 PM, Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:
>
>> Add a PHY driver for uses with AHCI based SATA controller driver on the
>> APQ8064 family of SoCs.
>>
>> This patch is a forward port plus separating PHY code of SATA driver
>> from Qualcomm's v3.4 andriod kernel.
>>
>> Tested on IFC6410 board.
>>
>> CC: Sujit Reddy Thumma <sthumma@codeaurora.org>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>> ---
>> drivers/phy/Kconfig                 |   7 +
>> drivers/phy/Makefile                |   1 +
>> drivers/phy/phy-qcom-apq8064-sata.c | 358 ++++++++++++++++++++++++++++++++++++
>> 3 files changed, 366 insertions(+)
>> create mode 100644 drivers/phy/phy-qcom-apq8064-sata.c
>
> Did you look at the 3.10 Android kernel tree version of the phy driver?
>
No, I did not get a chance to look at it. I will have a look at it today.
> Also do you have a DT binding spec to go with this?
yes, I did add it into the same binding spec qcom-phy.txt as ipq806x.

I will send this in a different patch.

thanks,
srini
>
> - k
>
