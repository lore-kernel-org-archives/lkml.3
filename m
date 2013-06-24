Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3FXUz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:55:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52135 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3FXUzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:55:24 -0400
Date: Mon, 24 Jun 2013 13:55:21 -0700
From: David Brown <davidb@codeaurora.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Mike Frysinger <vapier@gentoo.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Fix dtb dependency to use order-only prerequisites
Message-ID: <20130624205521.GA25530@codeaurora.org>
References: <1372106517-19105-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1372106517-19105-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 01:41:57PM -0700, Doug Anderson wrote:
>The %.dtb dependency is specified to depend on the PHONY "scripts".
>That means that it'll build every time even if the underlying dtb file
>hasn't been touched.  Use an order-only prerequisites to fix this.
>Also mark "dtbs" as PHONY for correctness.
>
>This was broken in (70b0476 ARM: 7513/1: Make sure dtc is built before
>running it).
>
>Reported-by: Mike Frysinger <vapier@gentoo.org>
>Signed-off-by: Doug Anderson <dianders@chromium.org>
>---
> arch/arm/Makefile | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
