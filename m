Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaBTVyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:54:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42698 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaBTVyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:54:41 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH v2] hwrng: msm: switch Kconfig to ARCH_QCOM depends
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <53064C89.4060206@codeaurora.org>
Date: Thu, 20 Feb 2014 15:54:35 -0600
Cc: Richard Kuo <rkuo@codeaurora.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 7BIT
Message-Id: <D66229C0-8768-42BD-87DA-83FAA2328E40@codeaurora.org>
References: <1392912542-5349-1-git-send-email-galak@codeaurora.org> <53064C89.4060206@codeaurora.org>
To: Christopher Covington <cov@codeaurora.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 20, 2014, at 12:42 PM, Christopher Covington <cov@codeaurora.org> wrote:

> On 02/20/2014 11:09 AM, Kumar Gala wrote:
>> We've split Qualcomm MSM support into legacy and multiplatform.  The RNG
>> driver is only relevant on the multiplatform supported SoCs so switch the
>> Kconfig depends to ARCH_QCOM.
>> 
>> CC: Herbert Xu <herbert@gondor.apana.org.au>
>> CC: Stanimir Varbanov <svarbanov@mm-sol.com>
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
>> 
>> Herbert,
>> 
>> If you can ack this I'll send it via linux-qcom/arm-soc tree's
>> 
>> thanks
>> 
>> v2:
>> * Updated help text to remove MSM references, made more generic
>> 
>> drivers/char/hw_random/Kconfig | 6 +++---
>> 1 file changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
>> index 2f2b084..f2b9f8c 100644
>> --- a/drivers/char/hw_random/Kconfig
>> +++ b/drivers/char/hw_random/Kconfig
>> @@ -342,11 +342,11 @@ config HW_RANDOM_TPM
>> 	  If unsure, say Y.
>> 
>> config HW_RANDOM_MSM
>> -	tristate "Qualcomm MSM Random Number Generator support"
> 
>> +	tristate "Qualcomm ARM SoCs Random Number Generator support"
> 
> Can the Hexagon use the PRNG, at least theoretically? If so maybe it'd be
> clearest to leave ARM off.
> 
> Christopher

Fair point.

- k


-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

