Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3G2UUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:20:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43369 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab3G2UUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:20:34 -0400
Date: Mon, 29 Jul 2013 13:20:31 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 6/9] ARM: msm: Move mach/board.h contents to common.h
Message-ID: <20130729202031.GA20694@codeaurora.org>
References: <1374699274-18388-1-git-send-email-sboyd@codeaurora.org>
 <1374699274-18388-7-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1374699274-18388-7-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 01:54:31PM -0700, Stephen Boyd wrote:
>The contents of mach/board.h are only used by files within
>mach-msm so there is no need to export this file outside of the
>mach-msm directory. Move the contents of the file to common.h to
>allow us to compile MSM in the multi-platform kernel.
>
>Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
>Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>---
> drivers/video/msm/msm_fb.c             |  1 -

It'd be nice to get a framebuffer Ack from this part.

original patch:
  https://patchwork.kernel.org/patch/2833029/

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
