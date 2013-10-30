Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3J3Vs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:48:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33542 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab3J3VsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:48:23 -0400
Message-ID: <52717EA5.6030208@codeaurora.org>
Date: Wed, 30 Oct 2013 14:48:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 4/6] edac: Document Krait L1/L2 EDAC driver binding
References: <1383164736-1849-1-git-send-email-sboyd@codeaurora.org> <1383164736-1849-5-git-send-email-sboyd@codeaurora.org> <872F86E8-85CE-472B-9546-CDCC96F6F08B@codeaurora.org>
In-Reply-To: <872F86E8-85CE-472B-9546-CDCC96F6F08B@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/13 14:45, Kumar Gala wrote:
> On Oct 30, 2013, at 3:25 PM, Stephen Boyd wrote:
>
>> @@ -75,3 +77,50 @@ Example:
>> 			reg = <0x101>;
>> 		};
>> 	};
>> +
>> +If the compatible string contains "qcom,krait" there shall be an interrupts
>> +property containing the L1/CPU error interrupt number. There shall also be an
> 'also be a'

ok

>
>> +l2-cache node containing the following properties:
> Is the L1 interrupt not per core L1 cache (even if they are OR together at PIC)?

Yes it is per CPU. That is what the 0xf part of the cpus interrupts
property is showing.

>
>> +
>> + - compatible: Shall contain at least "cache"
>> + - cache-level: Must be 2
>> + - interrupts: Shall contain the L2 error interrupt
>> +
>> +Example:
>> +
>> +	cpus {
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +		interrupts = <1 9 0xf04>;
>> +		compatible = "qcom,krait";
>>


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

