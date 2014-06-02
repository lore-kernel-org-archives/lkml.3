Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbaFBPkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:40:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38943 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaFBPkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:40:37 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH 1/2] pci: Add IORESOURCE_BIT entry for PCIe ECAM resources.
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140602150945.964D4C40381@trevor.secretlab.ca>
Date: Mon, 2 Jun 2014 10:40:30 -0500
Cc: Arnd Bergmann <arnd@arndb.de>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <390B3F94-C058-47D6-82CE-0393E60014FF@codeaurora.org>
References: <20140530233034.GH1677@bart.dudau.co.uk> <1401496601-31983-1-git-send-email-Liviu.Dudau@arm.com> <1401496601-31983-2-git-send-email-Liviu.Dudau@arm.com> <4756033.LkcFQN0chs@wuerfel> <20140602150945.964D4C40381@trevor.secretlab.ca>
To: Grant Likely <grant.likely@linaro.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 2, 2014, at 10:09 AM, Grant Likely <grant.likely@linaro.org> wrote:

> On Sat, 31 May 2014 20:41:04 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Saturday 31 May 2014 01:36:40 Liviu Dudau wrote:
>>> We would like to be able to describe PCIe ECAM resources as
>>> IORESOURCE_MEM blocks while distinguish them from standard
>>> memory resources. Add an IORESOURCE_BIT entry for this case.
>>> 
>>> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>> 
>> I still don't see any value in this at all. What is the advantage
>> of doing this opposed to just having a standardized 'reg' property
>> for a particular compatible string?
> 
> I'm inclined to agree. It doesn't seem appropriate to put config space
> in ranges, and the host controller binding is responsible for
> identifying how config space is memory mapped.
> 
> g.

I don’t agree when it comes to ECAM, but we can drop this for now until someone really does that.

However, what do we do with the 2 cases that exist in upstream that are using ranges for cfg space?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

