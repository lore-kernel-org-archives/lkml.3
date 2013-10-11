Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab3JKOGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:06:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47072 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3JKOGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:06:35 -0400
Date: Fri, 11 Oct 2013 07:06:32 -0700
From: David Brown <davidb@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: stern@rowland.harvard.edu, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        grant.likely@linaro.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] USB: ehci-msm: Add device tree support and binding
 information
Message-ID: <20131011140632.GB13820@codeaurora.org>
References: <1381491970-22896-1-git-send-email-iivanov@mm-sol.com>
 <1381491970-22896-2-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1381491970-22896-2-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:46:10PM +0300, Ivan T. Ivanov wrote:
>From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
>Allows MSM EHCI controller to be specified via device tree.
>
>Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>---
> .../devicetree/bindings/usb/msm-hsusb.txt          |   17 +++++++++++++++++
> drivers/usb/host/ehci-msm.c                        |   15 +++++++++++++--

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
