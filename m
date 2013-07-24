Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3GXWlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:41:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57234 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3GXWl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:41:29 -0400
Date: Wed, 24 Jul 2013 15:41:26 -0700
From: David Brown <davidb@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH 0/3] MSM gpio fixes
Message-ID: <20130724224126.GA27678@codeaurora.org>
References: <1374178035-19943-1-git-send-email-davidb@codeaurora.org>
 <CACRpkdbOO8fFEx+PxsdJ9F1dqD6V4_RPZThvTufo9+XhhyuHOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACRpkdbOO8fFEx+PxsdJ9F1dqD6V4_RPZThvTufo9+XhhyuHOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 10:54:42PM +0200, Linus Walleij wrote:
>On Thu, Jul 18, 2013 at 10:07 PM, David Brown <davidb@codeaurora.org> wrote:
>
>> Rohit sent these three fixes out on June 18.  I still need a
>> devicetree ack for the first patch, and would like these to get pulled
>> in for v3.11
>>
>> Rohit Vaswani (3):
>>   ARM: msm: dts: Fix the gpio register address for msm8960
>>   drivers: gpio: msm: Fix the error condition for reading ngpio
>
>OK for these two...
>
>>   ARM: msm: Consolidate gpiomux for older architectures
>
>This does not look like a fix? Surely this can wait for v3.12?

It fixes compilation.  But, it could also wait for v3.12.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
