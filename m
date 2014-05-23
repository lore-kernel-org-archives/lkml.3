Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaEWORl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:17:41 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:60036 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbaEWORj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:17:39 -0400
Message-ID: <537F5889.5080902@mm-sol.com>
Date: Fri, 23 May 2014 17:17:45 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, sboyd@codeaurora.org,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1 5/5] ARM: dts: qcom: Add APQ8084 serial port DT node
References: <1400775885-10296-1-git-send-email-gdjakov@mm-sol.com> <1400775885-10296-6-git-send-email-gdjakov@mm-sol.com> <693A0E52-34CF-4A63-A8D0-A83780F969F0@codeaurora.org>
In-Reply-To: <693A0E52-34CF-4A63-A8D0-A83780F969F0@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 07:32 PM, Kumar Gala wrote:
>
> On May 22, 2014, at 11:24 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
>
>> Add the necessary DT node to probe the serial driver on
>> APQ8084 platforms.
>>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
>> ---
>> arch/arm/boot/dts/qcom-apq8084.dtsi |    7 +++++++
>> 1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/qcom-apq8084.dtsi b/arch/arm/boot/dts/qcom-apq8084.dtsi
>> index 2dcd11e..c346549 100644
>> --- a/arch/arm/boot/dts/qcom-apq8084.dtsi
>> +++ b/arch/arm/boot/dts/qcom-apq8084.dtsi
>> @@ -185,5 +185,12 @@
>> 			reg = <0xfc400000 0x4000>;
>> 		};
>>
>> +		serial@f995e000 {
>
> Mark it disabled in the soc.dtsi and “ok” in the board.
>

Oh, of course!

Thanks,
Georgi

