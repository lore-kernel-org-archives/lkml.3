Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422806Ab3FUHdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:33:09 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:63082 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161061Ab3FUHdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:33:07 -0400
Date: Fri, 21 Jun 2013 09:33:01 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] dmaengine: ste_dma40: Declare memcpy config as static
Message-ID: <20130621073301.GA19353@balto.lan>
References: <1371719859-4600-1-git-send-email-fabio.baltieri@linaro.org>
 <20130621031000.GB23141@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621031000.GB23141@intel.com>
X-Operating-System: Linux balto 3.10.0-rc6-00001-g8177a9d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 08:40:00AM +0530, Vinod Koul wrote:
> On Thu, Jun 20, 2013 at 11:17:39AM +0200, Fabio Baltieri wrote:
> > Fix sparse warnings:
> > 
> > drivers/dma/ste_dma40.c:81:26: warning: symbol 'dma40_memcpy_conf_phy' was not declared. Should it be static?
> > drivers/dma/ste_dma40.c:95:26: warning: symbol 'dma40_memcpy_conf_log' was not declared. Should it be static?
> > 
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> Acked-by: Vinod Koul <vinod.koul@intel.com>
> 
> I guess this would be dependent on recent ste_dma40 patches so best way is
> Linus's tree, right?

Yes, but I'm not sure Linus is going to send a third pull request for
dma40 so maybe I should just resend my last two dma40 patches for
arm-soc directly.

Thanks for the Ack.

Fabio

-- 
Fabio Baltieri
