Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3HBDgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 23:36:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35636 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3HBDgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:36:40 -0400
Message-ID: <51FB2946.2050503@codeaurora.org>
Date: Thu, 01 Aug 2013 20:36:38 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: David Brown <davidb@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [RESEND PATCH 1/2] ARM: msm: Add support for MSM8974
References: <1375406619-14618-1-git-send-email-rvaswani@codeaurora.org> <51FB1987.3060806@wwwdotorg.org>
In-Reply-To: <51FB1987.3060806@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/2013 7:29 PM, Stephen Warren wrote:
> On 08/01/2013 07:23 PM, Rohit Vaswani wrote:
>> This patch adds basic board support for MSM8974 which
>> belongs to the Snapdragon 800 family.
>> For now, just support a basic machine with device tree.
>>   arch/arm/boot/dts/msm8974.dts     | 26 ++++++++++++++++++++++++++
> That's odd. If this is support for an SoC, why not a *.dtsi file rather
> than *.dts?

I am not sure why I would need a dtsi if I am just adding the 1 file for 
the SoC support ?

Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

