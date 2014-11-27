Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbaK0Ozu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:55:50 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:49868 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaK0Ozs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:55:48 -0500
Date: Thu, 27 Nov 2014 14:55:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/4] spi: st: Provide Device Tree binding documentation
Message-ID: <20141127145542.GH4628@x1>
References: <1417088636-11994-1-git-send-email-lee.jones@linaro.org>
 <1417088636-11994-3-git-send-email-lee.jones@linaro.org>
 <20141127130053.GW7712@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141127130053.GW7712@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Mark Brown wrote:

> On Thu, Nov 27, 2014 at 11:43:54AM +0000, Lee Jones wrote:
> 
> > +Required properties:
> > +- compatible	: "st,comms-ssc-spi" or "st,comms-ssc4-spi"
> 
> What do the two different compatible strings mean (for example, should
> ssc4 be used for version 4 and higher or is it just a quirk for that
> version)?

This appears to be historical.  There aren't any functional
differences i.e. we don't match on them.  I believe the former is a
more informal, generic name and the latter is the official name of the
IP block.  The I2C component already upstreamed has the same naming
conventions by the looks of it.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
