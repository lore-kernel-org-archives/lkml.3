Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaBXULj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 15:11:39 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49051 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaBXULi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 15:11:38 -0500
Date: Mon, 24 Feb 2014 15:11:33 -0500
From: Matt Porter <mporter@linaro.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        ARM Linux List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: Leave sdio1 as disabled on bcm28155-ap
Message-ID: <20140224201133.GX5038@beef>
References: <1391556460-24218-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391556460-24218-1-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 03:27:40PM -0800, Tim Kryger wrote:
> The sdio1 interface pins are routed to an unpopulated daughter card
> connector on the bcm28155-ap board.  Thus there is no need to mark
> this interface as enabled.
> 
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>

Applied to mach-bcm armsoc/for-3.15/dt

-Matt
