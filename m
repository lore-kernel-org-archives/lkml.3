Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbaAIT5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 14:57:40 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57878 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295AbaAIT52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:57:28 -0500
Message-ID: <52CEFF27.2000509@codeaurora.org>
Date: Thu, 09 Jan 2014 11:57:27 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 6/7] devicetree: bindings: Document Krait performance
 monitor units (PMU)
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org> <1389221984-10973-7-git-send-email-sboyd@codeaurora.org> <20140109181404.GJ17838@mudshark.cambridge.arm.com>
In-Reply-To: <20140109181404.GJ17838@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/14 10:14, Will Deacon wrote:
> On Wed, Jan 08, 2014 at 10:59:43PM +0000, Stephen Boyd wrote:
>> Document the Krait PMU compatible string.
>>
>> Cc: <devicetree@vger.kernel.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  Documentation/devicetree/bindings/arm/pmu.txt | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/pmu.txt b/Documentation/devicetree/bindings/arm/pmu.txt
>> index 3e1e498fea96..ce7cccb99d87 100644
>> --- a/Documentation/devicetree/bindings/arm/pmu.txt
>> +++ b/Documentation/devicetree/bindings/arm/pmu.txt
>> @@ -16,6 +16,7 @@ Required properties:
>>  	"arm,arm11mpcore-pmu"
>>  	"arm,arm1176-pmu"
>>  	"arm,arm1136-pmu"
>> +	"qcom,krait-pmu"
>>  - interrupts : 1 combined interrupt or 1 per core.
> Might be worth updating the part about interrupts too, given that you've
> added PPI support.

Done.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

