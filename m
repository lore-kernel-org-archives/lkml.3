Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbaE3SHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 14:07:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40694 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaE3SHe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 14:07:34 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] ARM: qcom: Enable GSBI driver in defconfig
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <5388BFAF.1050204@codeaurora.org>
Date: Fri, 30 May 2014 13:07:28 -0500
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <81F038DE-9849-4510-86F4-EF41169418FA@codeaurora.org>
References: <1401380804-16108-1-git-send-email-galak@codeaurora.org> <5388BFAF.1050204@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 30, 2014, at 12:28 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 05/29/14 09:26, Kumar Gala wrote:
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
>> arch/arm/configs/qcom_defconfig | 1 +
>> 1 file changed, 1 insertion(+)
>> 
>> diff --git a/arch/arm/configs/qcom_defconfig b/arch/arm/configs/qcom_defconfig
>> index bfed753..42ebd72 100644
>> --- a/arch/arm/configs/qcom_defconfig
>> +++ b/arch/arm/configs/qcom_defconfig
>> @@ -131,6 +131,7 @@ CONFIG_RTC_CLASS=y
>> CONFIG_DMADEVICES=y
>> CONFIG_QCOM_BAM_DMA=y
>> CONFIG_STAGING=y
>> +CONFIG_QCOM_GSBI=y
>> CONFIG_COMMON_CLK_QCOM=y
>> CONFIG_MSM_GCC_8660=y
>> CONFIG_MSM_MMCC_8960=y
> 
> It would be good to do this in the multi-platform defconfig as well.
> Otherwise users of that defconfig (i.e. khilman's boot tester) will
> start failing to boot once the DT changes land.
> 
> — 

Will do after 3.16-rc1, as nothing Kevin is booting uses the GSBI.

Trying to decide if we should have some Kconfig dependency here.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

