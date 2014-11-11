Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaKKOOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:14:32 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48136 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaKKOOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:14:30 -0500
Date: Tue, 11 Nov 2014 22:14:21 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: kernel@pengutronix.de, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ARM: dts: vf610: USB/GPIO fixes
Message-ID: <20141111141419.GC2704@dragon>
References: <1415106430-6271-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415106430-6271-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 02:07:07PM +0100, Stefan Agner wrote:
> Hi Shawn,
> 
> This patchset collects some vf610 device tree fixes. The first patch
> was part of the "vf610: Add GPIO support" patchset. GPIO support is
> merged by know, so I rebased that on top of your for-next branch.
> 
> The second patch is a USB fix I uncovered while testing the 3rd patch,
> which adds regulators, mainly for proper USB VBUS support, as we have
> them on our carrier boards.
> 
> Stefan Agner (3):
>   ARM: dts: vf610: use new GPIO support
>   ARM: dts: vf610: enable USB misc/phy nodes where necessary

Applied the first two, thanks.

Shawn

>   ARM: dts: vf-colibri: add USB regulators
> 
>  arch/arm/boot/dts/vf-colibri-eval-v3.dtsi | 45 ++++++++++++++++++++++++++++++-
>  arch/arm/boot/dts/vf-colibri.dtsi         | 37 +++++++++++++++++++++++++
>  arch/arm/boot/dts/vf610-twr.dts           |  9 +++++++
>  arch/arm/boot/dts/vfxxx.dtsi              |  1 +
>  4 files changed, 91 insertions(+), 1 deletion(-)
> 
> -- 
> 2.1.3
> 
