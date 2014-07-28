Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaG1O1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:27:47 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51900 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaG1O1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:27:44 -0400
Date: Mon, 28 Jul 2014 10:27:38 -0400
From: Matt Porter <mporter@linaro.org>
To: Alex Elder <elder@linaro.org>
Cc: bcm@fixthebug.org, devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: bindings: document Broadcom CPU enable method
Message-ID: <20140728142738.GA2593@beef>
References: <1404166185-4168-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404166185-4168-1-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 05:09:45PM -0500, Alex Elder wrote:
> Broadcom mobile SoCs use a ROM-implemented holding pen for
> controlled boot of secondary cores.  A special register is
> used to communicate to the ROM that a secondary core should
> start executing kernel code.  This enable method is currently
> used for members of the bcm281xx and bcm21664 SoC families.
> 
> The use of an enable method also allows the SMP operation vector to
> be assigned as a result of device tree content for these SoCs.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Applied to mach-bcm for-3.17/dt

Thanks,
Matt
