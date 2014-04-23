Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbaDWPO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:14:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39752 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaDWPOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:14:24 -0400
Message-ID: <5357D8CC.3080501@codeaurora.org>
Date: Wed, 23 Apr 2014 10:14:20 -0500
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:28.0) Gecko/20100101 Firefox/28.0 SeaMonkey/2.25
MIME-Version: 1.0
To: "Westerberg, Mika" <mika.westerberg@intel.com>
CC: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com> <1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com> <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com> <534B93BA.6020406@linux.intel.com> <534BFAAF.3070805@codeaurora.org> <534D0370.50108@linux.intel.com> <535005BA.1040405@codeaurora.org> <5357A80B.8030701@linux.intel.com> <5357ACF1.9070206@codeaurora.org> <20140423135915.GY30677@intel.com>
In-Reply-To: <20140423135915.GY30677@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Westerberg, Mika wrote:
> It doesn't do any pin control nor muxing and I'm not sure if it is
> required. Can you elaborate why you think pin muxing is required with
> GpioIo/GpioInt resources?

How are the pin muxes normally configured in ACPI?  All of our GPIOs 
have a pinmux on them, and so if you want to use the pin for the 
non-default functionality, you need to configure the mux.  Isn't that 
supposed to happen with the through the pinctrl driver?  That is, when 
the kernel parses the ASL, and it seems a command to configure pin #3 to 
function #4, it calls the local pinctrl driver to do that?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
