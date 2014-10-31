Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbaJaU6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:58:31 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:44866 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbaJaU63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:58:29 -0400
MIME-Version: 1.0
In-Reply-To: <20141031182037.GA2680@katana>
References: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1414677578-27412-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20141030141644.GE23852@katana> <2139081.L8ZrMAojpq@avalon> <20141031182037.GA2680@katana>
From: Rob Herring <robherring2@gmail.com>
Date: Sat, 1 Nov 2014 04:58:07 +0800
Message-ID: <CAL_JsqJ_kD-QPoRySPTU+7CG=s66QQAytnXMyiJ3AUz8yRE4tw@mail.gmail.com>
Subject: Re: [PATCH 1/3] of/irq: Export of_irq_get()
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2014 at 2:20 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Thu, Oct 30, 2014 at 04:17:19PM +0200, Laurent Pinchart wrote:
>> On Thursday 30 October 2014 15:16:44 Wolfram Sang wrote:
>> > On Thu, Oct 30, 2014 at 03:59:36PM +0200, Laurent Pinchart wrote:
>> > > The function will be used by the I2C core which can be compiled as a
>> > > module.
>> > >
>> > > Signed-off-by: Laurent Pinchart
>> > > <laurent.pinchart+renesas@ideasonboard.com>
>> >
>> > I think it makes sense if I take this via I2C to get the dependencies
>> > for the later patches right?
>>
>> It would be easier, yes.
>
> Oh, DT maintainers are not on CC. Then I can wait pretty long for an
> ack ;) Fixing that.

Acked-by: Rob Herring <robh@kernel.org>

>
>>
>> > > ---
>> > >
>> > >  drivers/of/irq.c | 1 +
>> > >  1 file changed, 1 insertion(+)
>> > >
>> > > diff --git a/drivers/of/irq.c b/drivers/of/irq.c
>> > > index 1471e0a223a5..0d7765807f49 100644
>> > > --- a/drivers/of/irq.c
>> > > +++ b/drivers/of/irq.c
>> > > @@ -405,6 +405,7 @@ int of_irq_get(struct device_node *dev, int index)
>> > >
>> > >   return irq_create_of_mapping(&oirq);
>> > >
>> > >  }
>> > >
>> > > +EXPORT_SYMBOL_GPL(of_irq_get);
>> > >
>> > >  /**
>> > >
>> > >   * of_irq_get_byname - Decode a node's IRQ and return it as a Linux irq
>> > >   number
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
