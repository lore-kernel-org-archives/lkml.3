Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab3HTOti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:49:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39309 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3HTOtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:49:36 -0400
Subject: Re: [PATCH v3] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex block
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=utf-8
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1376573746.18617.45.camel@hornet>
Date: Tue, 20 Aug 2013 09:49:42 -0500
Cc: "ohad@wizery.com" <ohad@wizery.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7734F2CE-580D-4D0C-94ED-D0B4ACB19AC8@codeaurora.org>
References: <1376507361-26907-1-git-send-email-galak@codeaurora.org> <1376573746.18617.45.camel@hornet>
To: Pawel Moll <pawel.moll@arm.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 15, 2013, at 8:35 AM, Pawel Moll wrote:

> On Wed, 2013-08-14 at 20:09 +0100, Kumar Gala wrote:
>> +Required properties:
>> +- compatible: should be "qcom,tcsr-mutex"
>> +- reg: Should contain registers location and length of mutex registers
>> +- reg-names:
>> +	"mutex-base"  - string to identify mutex registers
> 
> Just out of curiosity, why is reg-names required? Especially if there
> seem to be only one set of registers?
> 
> Paweł

At one point I thought there was going to be more than one reg region, I can drop it.  However, I dont see any issue with a binding making it required if it desires.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

