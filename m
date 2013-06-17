Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3FQPip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:38:45 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:57824 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3FQPio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:38:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130617135028.GE10671@intel.com>
References: <CAPgLHd-gjJ6ju3HyhiQi98YFGojvU3aYSTn7SOe4NhQPY1r++w@mail.gmail.com>
	<CACRpkdYBfvr0kA7bd-6Ns78UH7JtBCFDzFxyHLgtReB32O4D+w@mail.gmail.com>
	<20130530173326.GD3767@intel.com>
	<CACRpkdZhK6TUAC132vzcaLKqdMTwPma+ZhKG5Y+AUvekNpz6EQ@mail.gmail.com>
	<20130612095443.GU4107@intel.com>
	<CACRpkdYS8MYEBs_kcGyOPvcenBALxAXtksRA=+TmkeyOZW=Xzg@mail.gmail.com>
	<20130617135028.GE10671@intel.com>
Date: Mon, 17 Jun 2013 17:38:43 +0200
Message-ID: <CACRpkdYf3cx=-+nZJGCxGJs5TbBAkLwtfaYXWErzn-wnxeFLuQ@mail.gmail.com>
Subject: Re: [PATCH -next v2] dmaengine: ste_dma40: fix error return code in d40_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>, "arm@kernel.org" <arm@kernel.org>
Cc: Wei Yongjun <weiyj.lk@gmail.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Dan Williams <djbw@fb.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 3:50 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Thu, Jun 13, 2013 at 09:49:04AM +0200, Linus Walleij wrote:

>> I haven't sent this patch to ARM SoC so it will not appear from any other source
>> in the merge window or cause any conflicts.
>
> Doesnt apply on my next or -rc6. I think it has some ste dependecies. So either
> we wait and I send this for next -rc2 or you apply with my Ack

I have it queued in my tree so it won't be forgotten.

That said: ARM SoC folks: can you apply this fix directly
to wherever in the ARM SoC tree the DMA40 patches have
ended up? (Looks like next/drivers)

Yours,
Linus Walleij
