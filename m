Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbaFBUnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:43:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59715 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaFBUnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:43:07 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH 1/2] pci: Add IORESOURCE_BIT entry for PCIe ECAM resources.
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <4495090.ktpdXEyibD@wuerfel>
Date: Mon, 2 Jun 2014 15:43:02 -0500
Cc: Grant Likely <grant.likely@linaro.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
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
Message-Id: <95C66A63-9671-4AD5-9804-6647A305DB99@codeaurora.org>
References: <20140530233034.GH1677@bart.dudau.co.uk> <20140602162306.4AB0FC40476@trevor.secretlab.ca> <2F6515B1-48FE-4ED6-908E-CC1CAD7AF403@codeaurora.org> <4495090.ktpdXEyibD@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 2, 2014, at 2:15 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 02 June 2014 13:09:08 Kumar Gala wrote:
>>> However, what do we do with the 2 cases that exist in upstream that
>>>> are using ranges for cfg space?
>>> 
>>> Ignore them in the core code? Make the specific host controller handle
>>> them I would think.
>> 
>> I just meant, should we ‘break’ their DTs and move them from using ranges to reg?
> 
> dw-pcie is used on a lot of systems, I think we should make the common
> part of that driver always handle config space in a common way, and
> move out the part that parses the ranges property into the individual
> soc-specific glue drivers that want to keep optional backwards compatibility
> with existing dtbs.
> 
> Which one is the other driver?
> 
> 	Arnd

Its imx6 and exynos, havent looked to see if dw-pcie is handling the parsing or not for them.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

