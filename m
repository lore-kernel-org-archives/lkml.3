Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3HBEVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:21:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36464 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3HBEVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:21:05 -0400
Date: Thu, 1 Aug 2013 21:21:03 -0700
From: David Brown <davidb@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [RESEND PATCH 1/2] ARM: msm: Add support for MSM8974
Message-ID: <20130802042103.GA28826@codeaurora.org>
References: <1375406619-14618-1-git-send-email-rvaswani@codeaurora.org>
 <51FB1987.3060806@wwwdotorg.org>
 <51FB2946.2050503@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <51FB2946.2050503@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 08:36:38PM -0700, Rohit Vaswani wrote:
>On 8/1/2013 7:29 PM, Stephen Warren wrote:
>> On 08/01/2013 07:23 PM, Rohit Vaswani wrote:
>>> This patch adds basic board support for MSM8974 which
>>> belongs to the Snapdragon 800 family.
>>> For now, just support a basic machine with device tree.
>>>   arch/arm/boot/dts/msm8974.dts     | 26 ++++++++++++++++++++++++++
>> That's odd. If this is support for an SoC, why not a *.dtsi file rather
>> than *.dts?
>
>I am not sure why I would need a dtsi if I am just adding the 1 file for
>the SoC support ?

The .dts file should be for a specific board, not a general SoC.  Note
the names of the other board .dts files for MSM.  We'll probably want
a msm8974.dtsi at some point, though.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
