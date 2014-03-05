Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaCEGhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:37:36 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52995 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbaCEGhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:37:32 -0500
Date: Wed, 5 Mar 2014 01:37:28 -0500
From: Matt Porter <mporter@linaro.org>
To: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>, Alex Elder <elder@linaro.org>
Subject: Re: [PATCH v2] ARM: dts: remove bcm11351-brt.dts
Message-ID: <20140305063728.GB25092@beef>
References: <1392845512-31333-1-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392845512-31333-1-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 04:31:52PM -0500, Matt Porter wrote:
> The BCM11351 BRT board will never see the light of day. Remove the BRT
> dts since it is not maintainable.
> 
> Reviewed-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Matt Porter <mporter@linaro.org>
> ---
> Changes since v1:
> 	- remove bcm11351-brt from Makefile
> 

Applied to mach-bcm for-3.15/dt

-Matt
