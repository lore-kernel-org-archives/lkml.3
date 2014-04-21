Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaDUQV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:21:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52702 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaDUQVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:21:54 -0400
Date: Mon, 21 Apr 2014 11:21:52 -0500
From: Andy Gross <agross@codeaurora.org>
To: Christopher Covington <cov@codeaurora.org>
Cc: devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Introduce drivers/soc and add QCOM GSBI driver
Message-ID: <20140421162152.GA32485@qualcomm.com>
References: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
 <535521A0.5050706@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535521A0.5050706@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 09:48:16AM -0400, Christopher Covington wrote:

<snip>

> In that thread, Olof wrote, "The code [going into drivers/soc] isn't the pure
> drivers. Those we find homes for."

Right.  I see this as glue for the most part.  You could argue it's a small
pinctrl, but this doesn't route external pins, it's more to connect pins
internally to the IP block and it's sub-device parts (qup, uart, etc).

> 
> https://lkml.org/lkml/2014/3/2/123
> 
> > The remaining patches add the QCOM GSBI (General Serial Bus Interface) driver,
> > device tree binding information for both the GSBI and child node interaction,
> > and lastly a patch to fix the current MSM serial driver to work correctly with
> > the GSBI changes.
> 
> It's not obvious to me what makes the GSBI driver "impure" and unfit for say
> drivers/bus. Could you perhaps include a brief explanation?

The intent of the gsbi driver is merely to provide/configure the single mux
setting for the devices that share those 4 IO lines.  I don't see this as a full
blown bus.

Regards,

Andy
-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
