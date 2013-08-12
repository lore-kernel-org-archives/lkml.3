Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3HLStW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:49:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43157 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab3HLStD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:49:03 -0400
Subject: Re: [RFC PATCH v2 1/3] usb: dwc3: msm: Add device tree binding information
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20130812180438.GC27954@radagast>
Date: Mon, 12 Aug 2013 13:49:07 -0500
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <grant.likely@linaro.org>,
        <idos@codeaurora.org>, <mgautam@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <EA9DC11E-0A4A-4B03-8337-320C1F6D80D3@codeaurora.org>
References: <1376042027-9798-1-git-send-email-iivanov@mm-sol.com> <1376042027-9798-2-git-send-email-iivanov@mm-sol.com> <169628C9-00BA-4E58-BF65-7B180E6BE4ED@codeaurora.org> <20130812180438.GC27954@radagast>
To: <balbi@ti.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 12, 2013, at 1:04 PM, Felipe Balbi wrote:

> On Fri, Aug 09, 2013 at 10:31:58AM -0500, Kumar Gala wrote:
>> 
>> On Aug 9, 2013, at 4:53 AM, Ivan T. Ivanov wrote:
>> 
>>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>>> 
>>> MSM USB3.0 core wrapper consist of USB3.0 IP (SNPS)
>> 
>> probably good to spell out Synopsys rather than SNPS
> 
> Synopsys (the company) has always used snps in their bindings though.

I just meant in the commit message as SNPS wasn't obvious to me and I think when someone comes back and looks the commit message doing "Synopsys (SNPS)" is a little more readable.

- k

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

