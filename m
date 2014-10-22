Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbaJVPvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:51:09 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33542 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbaJVPvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:51:05 -0400
Date: Wed, 22 Oct 2014 16:50:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: PERIER Romain <romain.perier@gmail.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>, robh+dt@kernel.org,
        "pawel.moll" <pawel.moll@arm.com>, mark.rutland@arm.com,
        ijc+devicetree <ijc+devicetree@hellion.org.uk>,
        galak <galak@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        swarren <swarren@wwwdotorg.org>,
        "thierry.reding" <thierry.reding@gmail.com>, gnurou <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v1 1/5] mfd: tps65910: Convert ti,system-power-controller
 DT property to poweroff-source
Message-ID: <20141022155058.GN4939@x1>
References: <1413991587-11110-1-git-send-email-romain.perier@gmail.com>
 <CABgxDoKus_D=ooCz3TqyXP9CTJUgbZVxQSsw4ZgBx1oYaTefbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgxDoKus_D=ooCz3TqyXP9CTJUgbZVxQSsw4ZgBx1oYaTefbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, PERIER Romain wrote:

> This is related to the following subject "[RFC v3 PATCH 1/5] of: Add
> standard property for poweroff capability" and depends on the
> corresponding patch.

Then it should be sent in the same patch-set.

There's nothing I can do with this patch as is.

> 2014-10-22 17:26 GMT+02:00 Romain Perier <romain.perier@gmail.com>:
> > No longer use custom property to define poweroff capability, use the standard
> > DT property instead.
> >
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > ---
> >  drivers/mfd/tps65910.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> > index 7612d89..b8dca8a 100644
> > --- a/drivers/mfd/tps65910.c
> > +++ b/drivers/mfd/tps65910.c
> > @@ -423,8 +423,7 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
> >
> >         board_info->irq = client->irq;
> >         board_info->irq_base = -1;
> > -       board_info->pm_off = of_property_read_bool(np,
> > -                       "ti,system-power-controller");
> > +       board_info->pm_off = of_system_has_poweroff_source(np);
> >
> >         return board_info;
> >  }
> >

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
