Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3LSXDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:03:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41417 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab3LSXDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:03:53 -0500
Date: Thu, 19 Dec 2013 15:03:51 -0800
From: David Brown <davidb@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/15] usb: phy: msm: Replace custom enum
 usb_mode_type with enum usb_dr_mode
Message-ID: <20131219230351.GB20875@codeaurora.org>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
 <1384267910-32066-7-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1384267910-32066-7-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 04:51:41PM +0200, Ivan T. Ivanov wrote:
>From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
>Use enum usb_dr_mode and drop default usb_dr_mode from platform data.
>
>USB DT bindings states: dr_mode: "...In case this attribute isn't
>passed via DT, USB DRD controllers should default to OTG...",
>so remove redundand field.
>
>Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>---
> arch/arm/mach-msm/board-msm7x30.c |    2 +-
> arch/arm/mach-msm/board-qsd8x50.c |    2 +-

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
