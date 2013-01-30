Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3A3Q6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:58:33 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55249 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab3A3Q6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:58:30 -0500
Date: Wed, 30 Jan 2013 16:58:24 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] ARM: ux500: correct typo in pinctrl Device Tree node
Message-ID: <20130130165824.GA5078@gmail.com>
References: <1359563102-5934-1-git-send-email-linus.walleij@stericsson.com>
 <51094E50.4000302@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51094E50.4000302@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013, Stephen Warren wrote:

> On 01/30/2013 09:25 AM, Linus Walleij wrote:
> > The preference is to use '-' instead of '_' in compatible strings.
> 
> > diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
> 
> >  		pinctrl {
> > -			compatible = "stericsson,nmk_pinctrl";
> > +			compatible = "stericsson,nmk-pinctrl";
> 
> Is there a driver-side patch which this depends on too?

This seems very strange.

I'm going to reply to this email again with how the patch should look. 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
