Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaI3QDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:03:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36623 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaI3QC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:02:58 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v7 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT binding
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140930152838.GN28481@sonymobile.com>
Date: Tue, 30 Sep 2014 11:02:53 -0500
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <2FC56515-E6AF-4A4D-9B04-70B4A8B2C4C7@codeaurora.org>
References: <1411428329-23172-1-git-send-email-bjorn.andersson@sonymobile.com> <1411428329-23172-2-git-send-email-bjorn.andersson@sonymobile.com> <334C6A04-9607-4E97-A7A7-2FEED5986E57@codeaurora.org> <20140930152838.GN28481@sonymobile.com>
To: Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 30, 2014, at 10:28 AM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:

> On Wed 24 Sep 09:39 PDT 2014, Kumar Gala wrote:
> 
>> 
>> On Sep 22, 2014, at 6:25 PM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:
>> 
> 
> [..]
> 
>>> diff --git a/Documentation/devicetree/bindings/mfd/qcom-rpm.txt b/Documentation/devicetree/bindings/mfd/qcom-rpm.txt
> 
> [..]
> 
>>> +- qcom,ipc:
>>> +     Usage: required
>>> +     Value type: <prop-encoded-array>
>>> +
>>> +     Definition: three entries specifying the outgoing ipc bit used for
>>> +                 signaling the RPM:
>>> +                 - phandle to a syscon node representing the apcs registers
>>> +                 - u32 representing offset to the register within the syscon
>>> +                 - u32 representing the ipc bit within the register
>>> +
>> 
>> Does this really ever differ for the SoCs, and even if it does why do we need
>> to encode it in DT.  Can’t we determine it via the compatible setting?
>> 
> 
> The two offsets could be hard coded, especially based on the compatible.
> 
> But I don't know if it's worth respinning this just to get those two number out
> of here. Also this is now "symmetric" with the smd use cases, where it
> shouldn't be hard coded.

I do think its worth respinning until the DT is agreed to as we shouldn’t be changing the binding.

I’m not sure how being ‘symmetric’ with the smd use case maters if we are treating this RPM support vs RPM-SMD as two different things.

- k
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

