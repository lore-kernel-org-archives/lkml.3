Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab3BGTFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:05:04 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63563 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab3BGTFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:05:02 -0500
X-IronPort-AV: E=Sophos;i="4.84,623,1355126400"; 
   d="scan'208";a="24567138"
From: David Brown <davidb@codeaurora.org>
To: manjunath.goudar@linaro.org
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, stern@rowland.harvard.edu, arnd@linaro.org,
        gregkh@linuxfoundation.org, Greg KH <greg@kroah.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] USB: EHCI: make ehci-msm a separate driver
References: <5113e62e.c84e420a.08c3.ffffbf14@mx.google.com>
Date: Thu, 07 Feb 2013 11:05:01 -0800
In-Reply-To: <5113e62e.c84e420a.08c3.ffffbf14@mx.google.com> (manjunath
	goudar's message of "Thu, 7 Feb 2013 23:04:06 +0530")
Message-ID: <8yaa9rglzc2.fsf@huya.quicinc.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

manjunath.goudar@linaro.org writes:

> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_ALIAS("platform:omap-msm");
> +MODULE_LICENSE("GPL");

omap-msm?  I think you mean msm-ehci.

I don't have any hardware to test this on, so hopefully someone can
chime in after testing it.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
