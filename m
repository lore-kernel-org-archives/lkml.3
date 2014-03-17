Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbaCQRs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:48:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37139 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbaCQRsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:48:24 -0400
Message-ID: <53273566.20208@codeaurora.org>
Date: Mon, 17 Mar 2014 13:48:22 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: msm8974: Move arch-timer out of soc node
References: <1394573058-18561-1-git-send-email-sboyd@codeaurora.org> <5327316B.6040007@codeaurora.org> <26E59402-2F50-4E42-AAF2-AF321CB51799@codeaurora.org>
In-Reply-To: <26E59402-2F50-4E42-AAF2-AF321CB51799@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

On 03/17/2014 01:33 PM, Kumar Gala wrote:
> 
> On Mar 17, 2014, at 12:31 PM, Christopher Covington <cov@codeaurora.org> wrote:
> 
>> Hi Stephen,
>>
>> On 03/11/2014 05:24 PM, Stephen Boyd wrote:
>>> The architected timer is not a register addressable piece of
>>> hardware. Instead it's accessed through cp15 accessors. Move it
>>> to the root of the devicetree to reflect this.
>>
>> I find this confusing, perhaps due to overloading of the word "register".
>> Aren't CP15's a class of coprocessor _registers_? Could it perhaps be clearer
>> to talk about memory-mapped versus CP15-mapped timers?
>>
>> Is "soc" documented somewhere or is it just a name for a container? Assuming
>> the latter, it's not obvious to me why being a child of a system on chip node
>> would imply having memory mapped registers.
> 
> “soc” is a container, since its compatible = "simple-bus”, this implies
> memory mapped register access for nodes inside of it.

That makes sense. Thanks for explaining it.

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
