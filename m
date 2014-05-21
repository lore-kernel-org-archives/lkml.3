Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaEUPjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:39:44 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56413 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbaEUPjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:39:43 -0400
Message-ID: <537CC8C3.6040600@mm-sol.com>
Date: Wed, 21 May 2014 18:39:47 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        sboyd@codeaurora.org, rvaswani@codeaurora.org, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1 3/4] ARM: qcom: Add APQ8084-MTP board to mach-qcom
References: <1400684225-21381-1-git-send-email-gdjakov@mm-sol.com> <1400684225-21381-4-git-send-email-gdjakov@mm-sol.com> <A6B00F86-FFD3-4FEF-B39E-EAA511565B80@codeaurora.org>
In-Reply-To: <A6B00F86-FFD3-4FEF-B39E-EAA511565B80@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 06:18 PM, Kumar Gala wrote:
>
> On May 21, 2014, at 9:57 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
>
>> Add board compatibility string to the board machine descriptors.
>>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
>> ---
>> arch/arm/mach-qcom/board.c |    1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/mach-qcom/board.c b/arch/arm/mach-qcom/board.c
>> index bae617e..ae0a405 100644
>> --- a/arch/arm/mach-qcom/board.c
>> +++ b/arch/arm/mach-qcom/board.c
>> @@ -18,6 +18,7 @@ static const char * const qcom_dt_match[] __initconst = {
>> 	"qcom,msm8660-surf",
>> 	"qcom,msm8960-cdp",
>> 	"qcom,apq8074-dragonboard",
>> +	"qcom,apq8084-mtp",
>> 	NULL
>> };
>>
>> --
>> 1.7.9.5
>>
>
> Let’s just make this “qcom,apq8084” to cover other future apq8084 based boards.
>
> - k
>

Ok, agree!

Thanks,
Georgi
