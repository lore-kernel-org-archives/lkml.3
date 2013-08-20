Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab3HTOuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:50:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39381 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3HTOuC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:50:02 -0400
Subject: Re: [PATCH v3] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex block
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <520EADFC.5000607@wwwdotorg.org>
Date: Tue, 20 Aug 2013 09:50:09 -0500
Cc: ohad@wizery.com, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <8E7F7103-3EE0-41B2-9408-C6C3D33B69B2@codeaurora.org>
References: <1376507361-26907-1-git-send-email-galak@codeaurora.org> <520EADFC.5000607@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 16, 2013, at 5:55 PM, Stephen Warren wrote:

> On 08/14/2013 01:09 PM, Kumar Gala wrote:
>> Add driver for Qualcomm MSM Hardware Mutex block that exists on newer MSM
>> SoC (MSM8974, etc).
> 
>> diff --git a/Documentation/devicetree/bindings/hwlock/msm-tcsr-mutex.txt b/Documentation/devicetree/bindings/hwlock/msm-tcsr-mutex.txt
> 
>> +Required properties:
>> +- compatible: should be "qcom,tcsr-mutex"
>> +- reg: Should contain registers location and length of mutex registers
>> +- reg-names:
>> +	"mutex-base"  - string to identify mutex registers
>> +- qcom,num-locks: the number of locks/mutexes supported
> 
> Doesn't the block support any interrupts? I suppose the interrupts
> property can be optional though even if it does.

No interrupts on the block.

> Aside from the comments re: reg-names, this binding seems fine.
> --

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

