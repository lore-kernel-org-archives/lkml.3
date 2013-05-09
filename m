Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3EIOHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:07:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50084 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab3EIOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:07:43 -0400
Date: Thu, 9 May 2013 16:05:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Anthony Olech <anthony.olech@diasemi.com>
Subject: Re: [RFC PATCH 2/8] regulator: Add Dialog DA906x voltage regulators
 support.
In-Reply-To: <201208311100@sw-eng-lt-dc-vm2>
Message-ID: <Pine.LNX.4.64.1305091549300.22179@axis700.grange>
References: <201208241450@sw-eng-lt-dc-vm2> <201208241455@sw-eng-lt-dc-vm2>
 <20120825151020.GB6520@opensource.wolfsonmicro.com> <201208291550@sw-eng-lt-dc-vm2>
 <20120830174738.GH4356@opensource.wolfsonmicro.com> <201208311100@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:etjCuPlJF2DDexazD+Qvj4lek0qeuGqMJHVLV60kOG0
 iKQFXc8JdhlpfeoPeayTuTqXr8mfKe+PTpuZiis8pQm1UUKtGI
 hGI1xtEwm7ULlkX17jcXXDtXsnA9I0XCLpak8yIUikPCLg/27g
 Yx2NqwPmyk62y5w1E6nWkvwmrSHVDpsRRNtsQl5ca5yMoLFITx
 YxSK3ylSyq4Ykcdmda+vlzDAsEgZL8Gz1hRRno/3XwtNJrP6ga
 5JsyIWw8sBbG+TeixB9lD7vX5xO49ITRdpMu+Kxit99qAZ9UzE
 yuCsWW4yF+9E790VB260eoijIkvxGZnLYbIYbpjiRAyJWyN8wq
 oI1zVaQx8SBxy2FHEMiM2zSF5+ZJ7UcaFsHg4tGsxC07skP8+m
 BUHc3+j8Iomwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(trimmed the CC a bit)

Hi Krystian

On Fri, 31 Aug 2012, Krystian Garbaciak wrote:

> > On Wed, Aug 29, 2012 at 03:50:00PM +0100, Krystian Garbaciak wrote:

Sorry for picking up a random mail from this old thread, unfortunately, I 
don't have "0/8" in my archive.

I have to write a driver for the da9063 PMIC. Do you have an idea, whether 
it'd be compatible with this driver? Do you plan to continue your work on 
this driver or would you mind if I try to use these your patches and 
mainline them, preserving your authorship and copyright, of course?

Thanks
Guennadi

> > > Because, for some regulators, this is required: val += fvol->offset,
> > > I was only able to reduce it to the following form.
> > 
> > What on earth makes you say this?  The above is obviously linear.
> > 
> > Besides, you're missing several points here.  One is that you should be
> > using the framework features, another is that you should be implementing
> > _sel.
> 
> Sorry, I've missed an obvious thing here. Instead of adding selector offset at
> runtime, I can substract apropriate voltage from .min_uV. Thanks for pointing
> this out.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
