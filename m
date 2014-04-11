Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaDKWzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:55:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42077 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaDKWy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:54:59 -0400
MIME-Version: 1.0
In-Reply-To: <1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com>
References: <1371555182-12418-1-git-send-email-mathias.nyman@linux.intel.com>
	<1371555182-12418-2-git-send-email-mathias.nyman@linux.intel.com>
Date: Fri, 11 Apr 2014 17:54:56 -0500
Message-ID: <CAOZdJXU2hN+9TE=XN55TZF_W-0hxHZmK5330i6hwrhOERKFetw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] pinctrl: add Intel BayTrail GPIO/pinctrl support
From: Timur Tabi <timur@codeaurora.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Linus <linus.walleij@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 6:33 AM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
>
> Pins may be muxed to alternate function instead of gpio by firmware.
> This driver does not touch the pin muxing and expect firmare
> to set pin muxing and pullup/down properties properly.
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/pinctrl/Kconfig            |   12 +
>  drivers/pinctrl/Makefile           |    1 +
>  drivers/pinctrl/pinctrl-baytrail.c |  543 ++++++++++++++++++++++++++++++++++++


I know it's been ten months since you posted this driver, but I have a
question.  If this driver does not touch the pin muxing, and it
doesn't even call pinctrl_register(), then why is it in
drivers/pinctrl?  It's not a pinctrl driver.  Why isn't this a regular
GPIO drivers in drivers/gpio?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
