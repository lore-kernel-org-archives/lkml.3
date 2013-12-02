Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3LBODh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:03:37 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:44655 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3LBODe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:03:34 -0500
Date: Mon, 2 Dec 2013 14:03:24 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LinusW <linus.walleij@linaro.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [alsa-devel] [PATCH 07/10] ASoC: ux500: Store DMA data in the
 DAI differently in the pdata and DT case
Message-ID: <20131202140324.GH31626@lee--X1>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
 <1384859269-19801-8-git-send-email-lee.jones@linaro.org>
 <CAOesGMiu16f_L=cMWFCNZMjNB9tBK-2LXn02k-R7FhkkgR5-+g@mail.gmail.com>
 <20131202101256.GA29373@lee--X1>
 <20131202135452.GI27568@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131202135452.GI27568@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Dec 2013, Mark Brown wrote:

> On Mon, Dec 02, 2013 at 10:12:56AM +0000, Lee Jones wrote:
> 
> > It's actually my fault. I had two patches round the wrong way in the
> > series. The imediately subsequent patch in the set fixes this issue:
> 
> OK, so what do we do about this?  Is there going to be a revision of
> that patch adding the note about not using the autoconfiguration stuff
> and what (if any) are the dependencies on the arch/arm changes?

I can shoot out a revision no problem.

I'm not aware of any dependencies on the ARM changes. I haven't tested
the arch/arm and sound/soc adaptions orthogonally, but I _think_ the
right decisions should be made depending on the information passed
from platform/dt code.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
