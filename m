Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937371Ab3DIKEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:04:42 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62598 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934845Ab3DIKEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:04:40 -0400
Date: Tue, 9 Apr 2013 11:04:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>
Subject: Re: [PATCH 4/5] dmaengine: ste_dma40: Do not configure channels
 during an channel allocation
Message-ID: <20130409100435.GB25316@gmail.com>
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org>
 <1365434591-21569-4-git-send-email-lee.jones@linaro.org>
 <20130409071154.GH3084@gmail.com>
 <201304091136.09629.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304091136.09629.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Apr 2013, Arnd Bergmann wrote:

> On Tuesday 09 April 2013, Lee Jones wrote:
> > According to the DMA documentation allocating a channel and configuring
> > it are two separate actions. By removing the configuration code from the
> > channel allocation path we lighten the burden on the information required to
> > successfully allocate a channel.
> 
> Did you send out the first version again? The text is the same as before.

No, the first commit message implied I'd moved the config code from
'allocate' to 'configure', whereas in reality I just removed it from
'allocate', as it's already in 'configure'.

This changelog is different (and more accurate) than the first.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
