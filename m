Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaG1O0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:26:54 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:39335 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaG1O0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:26:48 -0400
Date: Mon, 28 Jul 2014 10:26:43 -0400
From: Matt Porter <mporter@linaro.org>
To: Alex Elder <elder@linaro.org>
Cc: bcm@fixthebug.org, bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/4] ARM: SMP: support Broadcom mobile SoCs
Message-ID: <20140728142643.GZ2593@beef>
References: <1404166540-4457-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404166540-4457-1-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 05:15:36PM -0500, Alex Elder wrote:
> This series adds SMP support for two Broadcom mobile SoC families.
> It uses CPU_METHOD_OF_DECLARE() so that SMP operations are assigned
> using device tree rather than adding it to a machine definition in a
> board file.
> 
> The enable method starts a secondary core by writing to a register
> monitored by CPUs spinning in a ROM-based holding pen loop.  The
> address of this register is recorded as a property in the "cpus"
> node of the device tree.
> 
> 					-Alex

Applied the series to mach-bcm for-3.17/[soc|dt]

Thanks,
Matt
