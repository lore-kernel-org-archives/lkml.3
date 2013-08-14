Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab3HNSAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:00:16 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42099 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3HNSAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:00:15 -0400
Date: Wed, 14 Aug 2013 19:00:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mfd: ab8500-gpadc: add CONFIG_PM_SLEEP to
 suspend/resume
Message-ID: <20130814180006.GJ4046@lee--X1>
References: <000201ce8f40$2322df90$69689eb0$@samsung.com>
 <CACRpkdY1t-g1C9QZJx3E5ytc1BJ+6Jr2h9Xk3scu1K6=Rsgwsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdY1t-g1C9QZJx3E5ytc1BJ+6Jr2h9Xk3scu1K6=Rsgwsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013, Linus Walleij wrote:

> On Fri, Aug 2, 2013 at 7:21 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > Add CONFIG_PM_SLEEP to suspend/resume functions to fix the build
> > warnings when CONFIG_PM_SLEEP is not selected. This is because
> > sleep PM callbacks defined by SET_SYSTEM_SLEEP_PM_OPS are only used
> > when the CONFIG_PM_SLEEP is enabled.
> >
> > drivers/mfd/ab8500-gpadc.c:891:12: warning: 'ab8500_gpadc_suspend' defined but not used [-Wunused-function]
> > drivers/mfd/ab8500-gpadc.c:903:12: warning: 'ab8500_gpadc_resume' defined but not used [-Wunused-function]
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Applied the Ack.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
