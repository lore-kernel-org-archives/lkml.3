Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab3FMHtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:49:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59349 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab3FMHtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:49:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130612095443.GU4107@intel.com>
References: <CAPgLHd-gjJ6ju3HyhiQi98YFGojvU3aYSTn7SOe4NhQPY1r++w@mail.gmail.com>
	<CACRpkdYBfvr0kA7bd-6Ns78UH7JtBCFDzFxyHLgtReB32O4D+w@mail.gmail.com>
	<20130530173326.GD3767@intel.com>
	<CACRpkdZhK6TUAC132vzcaLKqdMTwPma+ZhKG5Y+AUvekNpz6EQ@mail.gmail.com>
	<20130612095443.GU4107@intel.com>
Date: Thu, 13 Jun 2013 09:49:04 +0200
Message-ID: <CACRpkdYS8MYEBs_kcGyOPvcenBALxAXtksRA=+TmkeyOZW=Xzg@mail.gmail.com>
Subject: Re: [PATCH -next v2] dmaengine: ste_dma40: fix error return code in d40_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
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

On Wed, Jun 12, 2013 at 11:54 AM, Vinod Koul <vinod.koul@intel.com> wrote:

>> Let me know how you want it, I've removed it from my
>> dma40 branch for the time being.
>
> Have you removed, Also I see a v3 of this, do you want to ack that before I
> apply

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I haven't sent this patch to ARM SoC so it will not appear from any other source
in the merge window or cause any conflicts.

Yours,
Linus Walleij
