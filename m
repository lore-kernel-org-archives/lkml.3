Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3HAOKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:10:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52689 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab3HAOKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:10:16 -0400
Subject: Re: [PATCH] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex block
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <9EB1A821-7137-4812-B58A-20F669BCA7DD@codeaurora.org>
Date: Thu, 1 Aug 2013 09:10:30 -0500
Cc: "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <0A09DA0F-86B4-4961-88E2-64FA0A4D380D@codeaurora.org>
References: <1375128719-23642-1-git-send-email-galak@codeaurora.org> <E9700EA7-7154-46C5-9258-03F030DF69F6@codeaurora.org> <20130729214035.GC8868@codeaurora.org> <9EB1A821-7137-4812-B58A-20F669BCA7DD@codeaurora.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 29, 2013, at 4:54 PM, Kumar Gala wrote:

> 
> On Jul 29, 2013, at 4:40 PM, Stephen Boyd wrote:
> 
>> On 07/29, Kumar Gala wrote:
>>>> diff --git a/Documentation/devicetree/bindings/arm/msm/tcsr-mutex.txt b/Documentation/devicetree/bindings/arm/msm/tcsr-mutex.txt
>>>> new file mode 100644
>>>> index 0000000..ddd6889
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/arm/msm/tcsr-mutex.txt
>> 
>> Maybe this should go under a new hwspinlock directory?
> 
> Will look for Ohad to comment on this.
> 
>> 
>>>> @@ -0,0 +1,20 @@
>>>> +Qualcomm MSM Hardware Mutex Block:
>>>> +
>>>> +The hardware block provides mutexes utilized between different processors
>>>> +on the SoC as part of the communication protocol used by these processors.
>>>> +
>>>> +Required properties:
>>>> +- compatible: should be "qcom,tcsr-mutex"
>>>> +- reg: Should contain registers location and length of mutex registers
>>>> +- reg-names:
>>>> +	"mutex-base"  - string to identify mutex registers
>>>> +- qcom,num-locks: the number of locks/mutexes supported
>>>> +
>>>> +Example:
>>>> +
>>>> +	qcom,tcsr-mutex@fd484000 {
>> 
>> Maybe it should be hw-mutex@fd484000?
> 
> again, will look for Ohad to make some comment on this.
> 
>>>> +		compatible = "qcom,tcsr-mutex";
>>>> +		reg = <0xfd484000 0x1000>;
>>>> +		reg-names = "mutex-base";
>>>> +		qcom,num-locks = <32>;
>>>> +	};

Ohad, ping.

- k

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

