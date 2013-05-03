Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763621Ab3ECU7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:59:46 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:65351 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3ECU7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:59:44 -0400
Date: Fri, 3 May 2013 22:59:34 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 16/63] ARM: ux500: Remove superfluous 'psize' attribute
 from Audio platform data
Message-ID: <20130503205934.GA20194@balto.lan>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
 <1367591569-32197-17-git-send-email-lee.jones@linaro.org>
 <CACRpkdYPDnvb+_TEf63NsW8ra0ciWAHmp-VHiXPumFJbL=PNXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYPDnvb+_TEf63NsW8ra0ciWAHmp-VHiXPumFJbL=PNXg@mail.gmail.com>
X-Operating-System: Linux balto 3.9.0-rc8-00030-g4cbbd1d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, May 03, 2013 at 10:13:22PM +0200, Linus Walleij wrote:
> On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > 'psize' is used to calculate the maximum DMA burst size. However it
> > is only taken into consideration when editing the DMA channel's
> > configuration. The Audio DMA platform data is only used to allocate
> > a channel, not configure it. That will be done at a later date within
> > the MSP driver.
> >
> > We're also removing comments which are no longer required, as
> > 'data_width' is no longer set in any device's platform data period.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Patch applied.
> 
> Fabio: as I know you have audio working on the ux500
> with the mainline driver: could you confirm that this patch
> does not disturb the audio playback and provide a
> Tested-by?

Sure, I applied just this patch and it still works fine, tested on HREF
with speaker-test.
I have another non-related hack on dmaengine applied though, but Lee is
already aware of it so this is good for me:

Tested-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Thanks,
Fabio

-- 
Fabio Baltieri
