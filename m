Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab3HISAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:00:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46434 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab3HISAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:00:37 -0400
Date: Fri, 9 Aug 2013 11:00:35 -0700
From: David Brown <davidb@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [TRIVIAL] ARM: msm: fix compilation error in gpiomux
Message-ID: <20130809180035.GA733@codeaurora.org>
References: <1375857279-18082-1-git-send-email-k.kozlowski@samsung.com>
 <20130807174053.GA17551@codeaurora.org>
 <20130807210804.GB14845@codeaurora.org>
 <1375943536.30982.1.camel@AMDC1943>
 <520418F5.2030804@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <520418F5.2030804@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 03:17:25PM -0700, Rohit Vaswani wrote:
>On 8/7/2013 11:32 PM, Krzysztof Kozlowski wrote:
>> On śro, 2013-08-07 at 14:08 -0700, Stephen Boyd wrote:
>>> On 08/07, David Brown wrote:
>>>> On Wed, Aug 07, 2013 at 08:34:39AM +0200, Krzysztof Kozlowski wrote:
>>>>> Fix compilation error in gpiomux (CONFIG_MSM_GPIOMUX=y):
>>>>> arch/arm/mach-msm/gpiomux.c:24:13: error: static declaration of
>>>>> 	???__msm_gpiomux_write??? follows non-static declaration
>>>>> arch/arm/mach-msm/gpiomux.h:85:6: note: previous declaration of
>>>>> 	???__msm_gpiomux_write??? was here
>>>>>
>>>>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>>> Thanks, I'll pull this in.
>>>>
>>>>   <https://patchwork.kernel.org/patch/2839921/>
>>>>
>>> I believe this is fixed by Rohit's patch that has already been
>>> taken in a pull request?
>>>
>>> https://lkml.org/lkml/2013/7/26/608
>> Yes, Rohit's patch fixes the problem so this is already in linux-msm
>> tree.
>
>David, please can you confirm which pull request has this patch ?

It is in Linus' current tree.  Olof pulled it into the ARM tree on
Sunday, and Linus pulled those fixes yesterday morning.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
