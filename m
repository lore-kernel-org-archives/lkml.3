Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab3G2Rnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:43:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36996 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3G2Rnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:43:49 -0400
Date: Mon, 29 Jul 2013 10:43:46 -0700
From: David Brown <davidb@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/6] usb: phy: msm: Move mach depndend code to
 platform data
Message-ID: <20130729174346.GA16352@codeaurora.org>
References: <1375081464-14206-1-git-send-email-iivanov@mm-sol.com>
 <1375081464-14206-2-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1375081464-14206-2-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 10:04:19AM +0300, Ivan T. Ivanov wrote:
>From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
>This patch fix compilation error and is an intermediate step
>before the addition of DeviceTree support for newer targets.
>Fix suggested here: https://lkml.org/lkml/2013/6/19/381
>
>Cc: David Brown <davidb@codeaurora.org>
>Cc: Daniel Walker <dwalker@fifo99.com>
>Cc: Bryan Huntsman <bryanh@codeaurora.org>
>Cc: Felipe Balbi <balbi@ti.com>
>Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>Cc: linux-arm-kernel@lists.infradead.org
>Cc: linux-kernel@vger.kernel.org
>Cc: linux-usb@vger.kernel.org
>
>Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>---
> arch/arm/mach-msm/board-msm7x30.c |   35 +++++++++++++++++++++++
> arch/arm/mach-msm/board-qsd8x50.c |   35 +++++++++++++++++++++++

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
