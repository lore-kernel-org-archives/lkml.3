Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab3KFLW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:22:56 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:56143 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab3KFLWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:22:54 -0500
Date: Wed, 6 Nov 2013 11:22:48 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 06/13] ASoC: ux500_pcm: Extend ux500 MSP binding for
 enumeration
Message-ID: <20131106112248.GE30901@lee--X1>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
 <1383732985-18928-7-git-send-email-lee.jones@linaro.org>
 <20131106104658.GE11602@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131106104658.GE11602@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Nov 2013, Mark Brown wrote:

> On Wed, Nov 06, 2013 at 10:16:18AM +0000, Lee Jones wrote:
> 
> > +++ b/Documentation/devicetree/bindings/sound/ux500-msp.txt
> > @@ -3,6 +3,7 @@
> >  Required properties:
> >   - compatible       :"stericsson,ux500-msp-i2s"
> >   - reg              : Physical base address and length of the device's registers.
> > + - id               : MSP ID - used during component registration
> 
> I have no idea what this means or how one would pick the number?  It
> looks like something purely internal to the driver...

Hmm... yes I guess you're right. I think a match table would be more
appropriate.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
