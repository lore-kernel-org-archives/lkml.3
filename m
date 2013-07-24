Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3GXPzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:55:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34605 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab3GXPzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:55:09 -0400
Date: Wed, 24 Jul 2013 08:55:05 -0700
From: David Brown <davidb@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] usb: phy: msm: Move mach dependent code to platform
 data
Message-ID: <20130724155505.GA26371@codeaurora.org>
References: <1372087664-26396-1-git-send-email-iivanov@mm-sol.com>
 <1372087664-26396-2-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1372087664-26396-2-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 06:27:38PM +0300, Ivan T. Ivanov wrote:
>From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
>This patch fix compilation error and is an intermediate step
>before the addition of DeviceTree support for newer targets.
>Fix suggested here: https://lkml.org/lkml/2013/6/19/381
>
>Cc: David Brown <davidb@codeaurora.org>
>Cc: Daniel Walker <dwalker@fifo99.com>
>Cc: Bryan Huntsman <bryanh@codeaurora.org>
>Cc: Russell King <linux@arm.linux.org.uk>
>Cc: Felipe Balbi <balbi@ti.com>
>Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>Cc: Stephen Boyd <sboyd@codeaurora.org>
>Cc: linux-arm-kernel@lists.infradead.org
>Cc: linux-kernel@vger.kernel.org
>
>Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>---
> arch/arm/mach-msm/board-msm7x30.c |   35 +++++++++++++++++++++++
> arch/arm/mach-msm/board-qsd8x50.c |   34 +++++++++++++++++++++++
> drivers/usb/phy/phy-msm-usb.c     |   55 ++++++++++---------------------------
> include/linux/usb/msm_hsusb.h     |    2 ++
> 4 files changed, 85 insertions(+), 41 deletions(-)

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
