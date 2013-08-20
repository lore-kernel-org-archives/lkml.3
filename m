Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab3HTOvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:51:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39474 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3HTOvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:51:49 -0400
Subject: Re: [PATCH v3] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex block
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1376910775.3157.1.camel@hornet>
Date: Tue, 20 Aug 2013 09:51:55 -0500
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <E7A4BEAB-CBFD-41BF-A6DE-981F74FDB2CF@codeaurora.org>
References: <1376507361-26907-1-git-send-email-galak@codeaurora.org> <1376573746.18617.45.camel@hornet> <520EADBC.9090608@wwwdotorg.org> <1376910775.3157.1.camel@hornet>
To: Pawel Moll <pawel.moll@arm.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 19, 2013, at 6:12 AM, Pawel Moll wrote:

> On Fri, 2013-08-16 at 23:54 +0100, Stephen Warren wrote:
>> Indeed, I tend to think that reg-names is a bad idea.
>> 
>> IIRC, the rule for "reg" is that entries must always have a defined
>> order, so that it can always be accessed by integer index. 
> 
> First time I hear about that rule, really...
> 
>> And given
>> that's true, allowing for reg-names just creates confusion since it
>> implies you can look up the index in reg-names and then read reg at that
>> index.
> 
> I actually believe that named resources leave less are for error than
> indexed ones. And this is the message I remember being "spread" in the
> times of static platform devices.
> 
> Pawel

I can understand that reg-names being optional for older bindings to ensure backwards compat, but for newer ones agree that it is less error prone.  This is something we should try to come to some agreement on.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

