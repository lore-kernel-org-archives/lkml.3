Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172Ab3HNSAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:00:39 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:38868 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760163Ab3HNSAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:00:37 -0400
Date: Wed, 14 Aug 2013 19:00:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mfd: ab8500-gpadc: add CONFIG_PM_RUNTIME to
 runtime_suspend/runtime_resume
Message-ID: <20130814180029.GK4046@lee--X1>
References: <000101ce8f40$0e118070$2a348150$@samsung.com>
 <CACRpkdavPSV9Lz_drJFxuoLMAv9+UAqTzudNYoQT-CK+2sivAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdavPSV9Lz_drJFxuoLMAv9+UAqTzudNYoQT-CK+2sivAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013, Linus Walleij wrote:

> On Fri, Aug 2, 2013 at 7:20 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > Add CONFIG_PM_RUNTIME to runtime_suspend/runtime_resume functions
> > to fix the build warnings when CONFIG_PM_RUNTIME is not selected.
> > This is because runtime PM callbacks defined by SET_RUNTIME_PM_OPS
> > are only used when the CONFIG_PM_RUNTIME is enabled.
> >
> > drivers/mfd/ab8500-gpadc.c:870:12: warning: 'ab8500_gpadc_runtime_suspend' defined but not used [-Wunused-function]
> > drivers/mfd/ab8500-gpadc.c:878:12: warning: 'ab8500_gpadc_runtime_resume' defined but not used [-Wunused-function]
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
