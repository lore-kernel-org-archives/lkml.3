Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaCKOEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:04:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34085 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbaCKOEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:04:30 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 2/3] soc: keystone: add QMSS driver
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <531E2C55.70702@ti.com>
Date: Tue, 11 Mar 2014 09:04:24 -0500
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sandeep Nair <sandeep_n@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <5EE98053-31B8-4679-AAE2-4F026C61D1D4@codeaurora.org>
References: <1393629520-12713-1-git-send-email-santosh.shilimkar@ti.com>	<1393629520-12713-3-git-send-email-santosh.shilimkar@ti.com> <CAL_Jsq+O660oV9FtthG3gTkVOhL0ku-UHSrkt-ROauu1iNpbaA@mail.gmail.com> <531E2C55.70702@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 10, 2014, at 4:19 PM, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:

>>> +  -- reg-names         : Names for the above register regions. The name to be
>>> +                         used is as follows:
>>> +                         - "config" : Queue configuration region.
>>> +                         - "status" : Queue status RAM.
>>> +                         - "region" : Descriptor memory setup region.
>>> +                         - "push"   : Queue Management/Queue Proxy region.
>>> +                         - "pop"    : Queue Management/Queue Proxy region.
>>> +                         - "peek"   : Queue Peek region.
>> 
>> reg-names should be optional. Also you have the order different from
>> reg. Be consistent as to what is the correct order.
>> 
> We thought of using reg-names to remove the ordering to index
> the regs. So if we make the reg-names optional, then indexing
> by order will be used. We can do that.

We keep having this conversation, why does reg-names need to be optional for new bindings?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

