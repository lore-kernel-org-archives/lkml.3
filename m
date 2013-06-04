Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab3FDJOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:14:20 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:44440 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3FDJOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:14:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130530173326.GD3767@intel.com>
References: <CAPgLHd-gjJ6ju3HyhiQi98YFGojvU3aYSTn7SOe4NhQPY1r++w@mail.gmail.com>
	<CACRpkdYBfvr0kA7bd-6Ns78UH7JtBCFDzFxyHLgtReB32O4D+w@mail.gmail.com>
	<20130530173326.GD3767@intel.com>
Date: Tue, 4 Jun 2013 11:14:16 +0200
Message-ID: <CACRpkdZhK6TUAC132vzcaLKqdMTwPma+ZhKG5Y+AUvekNpz6EQ@mail.gmail.com>
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

On Thu, May 30, 2013 at 7:33 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Thu, May 30, 2013 at 09:41:38AM +0200, Linus Walleij wrote:
>> On Thu, May 30, 2013 at 6:32 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>>
>> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> >
>> > In many of the error handling case, the return value 'ret' not set
>> > and 0 will be return from d40_probe() even if error, but we should
>> > return a negative error code instead in those error handling case.
>> > This patch fixed them, and also removed useless variable 'err'.
>> >
>> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> > ---
>> > v1 -> v2: rebased on linux-next.git
>>
>> I've tentatively applied this to my dma40 branch, waiting for Vinod
>> to ACK it.
> I though you wanted me to apply this :)
>
> Nevertheless, Acked-by: Vinod Koul <vinod.koul@intel.com>
>
> Can you CC stable too, pls.

Hm I'm not sending any DMA40 stuff for stable, sorry ...
if you want it to go into stable you'd better pick this
(the v3 version) into the DMA tree.

Let me know how you want it, I've removed it from my
dma40 branch for the time being.

Yours,
Linus Walleij
