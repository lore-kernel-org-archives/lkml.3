Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3IQW4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 18:56:19 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:48809 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3IQW4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:56:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: George Cherian <george.cherian@ti.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Nikolay Balandin <n.a.balandin@gmail.com>
Subject: Re: [PATCH v4 0/3] cleanup of gpio_pcf857x.c
Date: Wed, 18 Sep 2013 00:56:19 +0200
Message-ID: <1695077.V4sgFrjTJR@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CACRpkdYc4UTbpa5W-KY_D7hRUYi9N3Ny1+CPJ-aixeEk3WGHCw@mail.gmail.com>
References: <1378278183-26596-1-git-send-email-george.cherian@ti.com> <CACRpkdYc4UTbpa5W-KY_D7hRUYi9N3Ny1+CPJ-aixeEk3WGHCw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tuesday 17 September 2013 14:51:48 Linus Walleij wrote:
> On Wed, Sep 4, 2013 at 9:03 AM, George Cherian wrote:
> > This patch series
> > 
> >         - removes the irq_demux_work
> >         - Uses devm_request_threaded_irq
> >         - Call the user handler iff gpio_to_irq is done.
> > 
> > v1 --> v2
> > 
> >         Split v1 to 3 patches
> > 
> > v2 --> v3
> > 
> >         Remove the unnecessary dts patches.
> > 
> > v3 --> v4
> > 
> >         Remove gpio->irq (in patch 2)
> 
> Applied all three patches with Kuninoro's ACK.
> 
> However your last iteration was still labeled "v3" in the subject
> so I was a bit confused, but I took all those sent on sep 4.
> 
> Please check the result in my GPIO tree or linux-next and
> make sure it works.
> 
> > Note: these patches were made after applying [1].
> > [1] - [PATCH v5] gpio: pcf857x: Add OF support -
> > https://lkml.org/lkml/2013/8/27/70
>
> Well that patch is not finished, but by rebasing patch 2 with
> patch -p1 < patch2.patch it applied anyway.
> 
> Now Laurent has to finalize his DT bindings on top of your patches instead.

I will do so. At first sight I don't see any conflict issue.

-- 
Regards,

Laurent Pinchart

