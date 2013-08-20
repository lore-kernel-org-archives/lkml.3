Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab3HTVSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:18:35 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44967 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3HTVSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:18:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Fabio Estevam <festevam@gmail.com>, Liu Ying <Ying.Liu@freescale.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAOMZO5Afjp-zPzUaNE63L7Y2LjZbSrLupAJ_jFnf1Gg1+hx0Nw@mail.gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com>
 <1376987932-5540-2-git-send-email-Ying.Liu@freescale.com>
 <CAOMZO5Afjp-zPzUaNE63L7Y2LjZbSrLupAJ_jFnf1Gg1+hx0Nw@mail.gmail.com>
Message-ID: <20130820211827.4443.97943@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 1/3] ARM: imx6q: refactor some ldb related clocks
Date: Tue, 20 Aug 2013 14:18:27 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Fabio Estevam (2013-08-20 08:40:52)
> On Tue, Aug 20, 2013 at 5:38 AM, Liu Ying <Ying.Liu@freescale.com> wrote:
> 
> > diff --git a/Documentation/devicetree/bindings/clock/imx6q-clock.txt b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
> > index 5a90a72..90e923e 100644
> > --- a/Documentation/devicetree/bindings/clock/imx6q-clock.txt
> > +++ b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
> > @@ -89,8 +89,6 @@ clocks and IDs.
> >         gpu3d_shader            74
> >         ipu1_podf               75
> >         ipu2_podf               76
> > -       ldb_di0_podf            77
> > -       ldb_di1_podf            78
> >         ipu1_di0_pre            79
> >         ipu1_di1_pre            80
> >         ipu2_di0_pre            81
> 
> This causes a 'hole' in the clock numbering scheme: 74, 75, 76, 79, 80, etc

How does this fit in with the idea of having a stable binding/ABI? Seems
like changing this would be a bad idea for devices in the field that
have older DTBs.

Regards,
Mike

> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
