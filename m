Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaDWMHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:07:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46597 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaDWMHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:07:16 -0400
Message-ID: <5357ACF1.9070206@codeaurora.org>
Date: Wed, 23 Apr 2014 07:07:13 -0500
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:28.0) Gecko/20100101 Firefox/28.0 SeaMonkey/2.25
MIME-Version: 1.0
To: Mathias Nyman <mathias.nyman@linux.intel.com>
CC: Linus <linus.walleij@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>	<1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com> <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com> <534B93BA.6020406@linux.intel.com> <534BFAAF.3070805@codeaurora.org> <534D0370.50108@linux.intel.com> <535005BA.1040405@codeaurora.org> <5357A80B.8030701@linux.intel.com>
In-Reply-To: <5357A80B.8030701@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathias Nyman wrote:
>
> Helper functions to translate the ACPI GpioIO and GpioInt resources to
> linux gpio numbers can be found in gpio/gpiolib-acpi.c together with
> other ACPI and gpio related helper functions.

Does this also cover pin control and pin muxing?  Sorry, but I sometimes 
I get confused.  It appears to me that the GpioIo and GpioInt functions 
require pin muxing, but I don't see that support in gpiolib-acpi.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
