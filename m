Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaJWKCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:02:43 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:39712 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbaJWKCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:02:39 -0400
Date: Thu, 23 Oct 2014 11:02:21 +0100
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
Message-ID: <20141023100221.GA10395@x1>
References: <1413991587-11110-1-git-send-email-romain.perier@gmail.com>
 <CABgxDoKus_D=ooCz3TqyXP9CTJUgbZVxQSsw4ZgBx1oYaTefbw@mail.gmail.com>
 <20141022155058.GN4939@x1>
 <CABgxDoJSLrAOMMA7=ZGd4F6z7_FkojCdjUNi52wbocZk7yJowQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgxDoJSLrAOMMA7=ZGd4F6z7_FkojCdjUNi52wbocZk7yJowQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014, PERIER Romain wrote:

> 2014-10-22 17:50 GMT+02:00 Lee Jones <lee.jones@linaro.org>:
> > On Wed, 22 Oct 2014, PERIER Romain wrote:
> >
> >> This is related to the following subject "[RFC v3 PATCH 1/5] of: Add
> >> standard property for poweroff capability" and depends on the
> >> corresponding patch.
> >
> > Then it should be sent in the same patch-set.
> >
> > There's nothing I can do with this patch as is.
> >
> 
> Even if this patch is already commited and present in "linux-next" ?
> (or in Mark Brown's regulator tree)

Usually it wouldn't be possible to take this, as it would be
difficult to ensure bisectability.  The way we usually deal with this
is to have a shared immutable branch between the effected subsystems,
but we can only do this if the patches are sent as a set.  However, it
appears as though Mark has "of: Add standard property for poweroff
capability" on a tagged branch on its own.  This means, after checking
with Mark that this branch in indeed stable, I can merge it in and
base this commit on top of it.  Not many people setup their repos like
Mark does, so I guess you are lucky this time.

Once I've heard back from Mark, I'll let you know when I apply the
patch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
