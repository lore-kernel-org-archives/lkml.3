Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3KFMIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:08:07 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:42195 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab3KFMIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:08:05 -0500
Date: Wed, 6 Nov 2013 12:07:58 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 06/13] ASoC: ux500_pcm: Extend ux500 MSP binding for
 enumeration
Message-ID: <20131106120758.GG30901@lee--X1>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
 <1383732985-18928-7-git-send-email-lee.jones@linaro.org>
 <20131106104658.GE11602@sirena.org.uk>
 <CACRpkdZgi9Egvm585Y9tJpmj0YX-oJBDg-C7pCu91Pf5ALMGLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZgi9Egvm585Y9tJpmj0YX-oJBDg-C7pCu91Pf5ALMGLg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Nov 2013, Linus Walleij wrote:

> On Wed, Nov 6, 2013 at 11:46 AM, Mark Brown <broonie@kernel.org> wrote:
> > On Wed, Nov 06, 2013 at 10:16:18AM +0000, Lee Jones wrote:
> 
> >> + - id               : MSP ID - used during component registration
> >
> > I have no idea what this means or how one would pick the number?  It
> > looks like something purely internal to the driver...
> 
> Actually it's quite common when we have several HW blocks of the
> same thing to add something like an id. For example for different
> GPIO banks.
> 
> But in this case I guess it may make more sense to flag one MSP
> for RX and one for TX or something?
> 
> There are also two more such MSPs for streaming audio to the
> Bluetooth audio portions.

Right, we have 4 of them:

MSP0: Tx and Rx
MSP1: Tx
MSP2: Tx and Rx
MSP3: Rx

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
