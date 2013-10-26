Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab3JZGhq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 02:37:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60163 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3JZGho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 02:37:44 -0400
Subject: Re: [PATCHv6 1/3] Input: twl4030-pwrbutton - add device tree support
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20131025221850.GA8657@earth.universe>
Date: Sat, 26 Oct 2013 01:37:57 -0500
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <085234CB-BD53-4120-AE77-B06FA9314E96@codeaurora.org>
References: <1382626126-12565-1-git-send-email-sre@debian.org> <1382626126-12565-2-git-send-email-sre@debian.org> <FC6F0077-7E61-4F64-94E5-10E8FEF1F1E4@codeaurora.org> <20131025221850.GA8657@earth.universe>
To: Sebastian Reichel <sre@debian.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 25, 2013, at 5:18 PM, Sebastian Reichel wrote:

> On Fri, Oct 25, 2013 at 04:41:20PM -0500, Kumar Gala wrote:
>> On Oct 24, 2013, at 9:48 AM, Sebastian Reichel wrote:
>>> +- interrupt: should be one of the following
>>> +   - <8>: For controllers compatible with twl4030
>> 
>> Just checking, but the interrupt is always 8 for this device?
> 
> Yes. It's currently hardcoded in drivers/mfd/twl-core.c.

The fact that is hard coded in the driver does not imply that it should be in the device tree binding.  Is there an interrupt controller as part of the TWL4030?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

