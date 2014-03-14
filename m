Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbaCNQtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:49:21 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52273 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbaCNQtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:49:20 -0400
Date: Fri, 14 Mar 2014 12:49:15 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback 
	<bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH v2 0/3] ARM: bcm21664: Add initial support.
Message-ID: <20140314164915.GA25092@beef>
References: <1394097494-29899-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394097494-29899-1-git-send-email-markus.mayer@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 05:18:11PM +0800, Markus Mayer wrote:
> This series adds initial support for the Broadcom BCM21664 mobile SoC.
> 
> The series depends on the series "ARM: bcm281xx: Consolidate code":
>     https://lkml.org/lkml/2014/2/25/548
> 
> Changes since v1:
> 
> - Fixed typo ("21644" -> "21664" in 2 locations) in board_bcm21664.c
> 
> Markus Mayer (3):
>   ARM: DT: bcm21664: Device tree bindings
>   ARM: bcm21664: Add board support.
>   ARM: dts: bcm21664: Add device tree files.

Applied to mach-bcm armsoc/for-3.15/[soc-3|dt]

-Matt
