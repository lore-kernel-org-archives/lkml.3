Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3JCOpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:45:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49741 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3JCOpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:45:40 -0400
From: Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Use of drivers/platform and matching include?
Date: Thu, 3 Oct 2013 09:45:38 -0500
Message-Id: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Mime-Version: 1.0 (Apple Message framework v1283)
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we look at upstreaming more support for the Qualcomm MSM SoCs there are a number of drivers or library like routines that are unique to the MSM platform, we are thinking that putting them under:

drivers/platform/qcom/

would make sense.  In addition there are headers that might need to get shared with drivers in other locations so I wanted to see what the take was on introducing:

include/linux/platform/qcom/

An example driver would be the means we utilize to communicate memory regions between various HW blocks on the SoC.  So a video/media core driver might need access to a header/functions from the memory region driver.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

