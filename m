Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3FXLt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:49:59 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:59852 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3FXLtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:49:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130621073301.GA19353@balto.lan>
References: <1371719859-4600-1-git-send-email-fabio.baltieri@linaro.org>
	<20130621031000.GB23141@intel.com>
	<20130621073301.GA19353@balto.lan>
Date: Mon, 24 Jun 2013 13:49:54 +0200
Message-ID: <CACRpkdYRqY9yRutfwgEaRAUGiwV38fs=EVpSP1As8OB0piERiQ@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: ste_dma40: Declare memcpy config as static
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 9:33 AM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:
> On Fri, Jun 21, 2013 at 08:40:00AM +0530, Vinod Koul wrote:
>> On Thu, Jun 20, 2013 at 11:17:39AM +0200, Fabio Baltieri wrote:
>> > Fix sparse warnings:
>> >
>> > drivers/dma/ste_dma40.c:81:26: warning: symbol 'dma40_memcpy_conf_phy' was not declared. Should it be static?
>> > drivers/dma/ste_dma40.c:95:26: warning: symbol 'dma40_memcpy_conf_log' was not declared. Should it be static?
>> >
>> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
>> Acked-by: Vinod Koul <vinod.koul@intel.com>
>>
>> I guess this would be dependent on recent ste_dma40 patches so best way is
>> Linus's tree, right?
>
> Yes, but I'm not sure Linus is going to send a third pull request for
> dma40 so maybe I should just resend my last two dma40 patches for
> arm-soc directly.

I've stacked it in my tree, I didn't plan to send another pull
request but I guess I have to, or I'll send it as fixes, so I'm
taking care of this.

Yours,
Linus Walleij
