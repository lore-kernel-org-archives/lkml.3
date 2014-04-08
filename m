Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbaDHMdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:33:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46275 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbaDHMdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:33:13 -0400
Message-ID: <5343EC87.700@codeaurora.org>
Date: Tue, 08 Apr 2014 07:33:11 -0500
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:28.0) Gecko/20100101 Firefox/28.0 SeaMonkey/2.25
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: MSM8974: Add pinctrl node
References: <1391700529-11816-1-git-send-email-iivanov@mm-sol.com>	 <1391700529-11816-2-git-send-email-iivanov@mm-sol.com>	 <CAOZdJXVE7MSMBaL+bt0kjw5LEidz-aVp+vrWqQWkye6HdE7EeA@mail.gmail.com> <1396959284.28420.45.camel@iivanov-dev>
In-Reply-To: <1396959284.28420.45.camel@iivanov-dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan T. Ivanov wrote:
>> >I'm confused by this.  Isn't this information already defined in the
>> >pinctrl-msm8x74.c driver?
>> >
>> >static const char * const blsp_spi8_groups[] = {
>> >     "gpio45", "gpio46", "gpio47", "gpio48"
>> >};
> I am not sure that I understand the question. This is one of
> possible ways to describe relationship between pins and functions.
> As they are described is visible what is their real purpose.

Ok, let me rephrase.

The 8x74 pinctrl driver already contains this information.  It already 
defines a "blsp_spi8" group consisting of GPIOs 45, 46, 47, and 48.

This patch adds that same exact information into the device tree.  Why 
are we duplicating that information?  Why add it to the device tree when 
it's already in the driver (and already working).

Also, I don't see any code anywhere that uses these new device tree nodes.

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
