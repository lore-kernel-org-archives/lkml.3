Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaDNPLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:11:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52227 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaDNPLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:11:46 -0400
Message-ID: <534BFAAF.3070805@codeaurora.org>
Date: Mon, 14 Apr 2014 10:11:43 -0500
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mathias Nyman <mathias.nyman@linux.intel.com>
CC: Linus <linus.walleij@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>	<1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com> <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com> <534B93BA.6020406@linux.intel.com>
In-Reply-To: <534B93BA.6020406@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 02:52 AM, Mathias Nyman wrote:
>>
>
> This was the conclusion we reached after some discussion with Linus W.
> Initially this was just a GPIO driver, but Linus correctly spotted that
> Baytrail has many pinctrl-like features (like pin muxing, etc) that we
> might need to address in the future.
>
> threads where this was discussed:
>
> http://marc.info/?l=linux-kernel&m=136994203308585&w=2
> http://marc.info/?l=linux-kernel&m=137113578604763&w=2

So this is the interesting part:

> We expect BIOS to set all pin configurations correctly.

This device will only be used on an ACPI system, right?  And isn't ACPI 
supposed to hide all the pinctrl programming from the OS?  I thought 
that was the whole point behind ACPI and the reason why ARM64 isn't 
going to use device trees.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by the Linux Foundation.
