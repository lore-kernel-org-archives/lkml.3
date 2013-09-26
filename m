Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3IZVHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 17:07:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41470 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3IZVG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 17:06:59 -0400
Subject: Re: [PATCHv4 2/3] ARM: msm: Add support for APQ8074 Dragonboard
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20130926205808.GA3146@codeaurora.org>
Date: Thu, 26 Sep 2013 16:06:52 -0500
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <779B68F7-4E73-4B79-B85E-4E642ABC08C8@codeaurora.org>
References: <1379992406-3541-1-git-send-email-rvaswani@codeaurora.org> <1379992406-3541-2-git-send-email-rvaswani@codeaurora.org> <4E7868D6-56CB-4AF8-8EBF-069966899C23@codeaurora.org> <5243652F.7090408@codeaurora.org> <B0F416B8-042A-49F1-81E9-B217F02AAD1E@codeaurora.org> <52447779.3010908@codeaurora.org> <52448852.9050608@codeaurora.org> <50877C70-6066-4E87-9DEA-9F29D098525B@codeaurora.org> <20130926205808.GA3146@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 26, 2013, at 3:58 PM, David Brown wrote:

> On Thu, Sep 26, 2013 at 02:33:53PM -0500, Kumar Gala wrote:
> 
>>> "ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that any
>>> node that has a reg property must include a unit address in its name
>>> with value matching the first entry in its reg property. Conversely, if
>>> a node does not have a reg property, the node name must not include a
>>> unit address."
>>> 
>>> The soc node we have does not have a reg property ?
>> 
>> Not 100% sure what people will decide on this.  There are a number of
>> examples on the PPC side (arch/powerpc/boot/dts) that are soc@ADDR,
>> but they don't typically have "reg" properties at the soc level.
>> 
>> Let's go ahead w/o the unit address (as you have it) for now.
> 
> What is the address even supposed to mean?  Are we expecting multiple
> 'soc' nodes?


What do we consider to exist under soc in general?  I'd expect the address to be the base of the MMIO register register for on SoC devices (but that's based on my PPC history).

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

