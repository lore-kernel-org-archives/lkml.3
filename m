Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab3HNQpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:45:33 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41806 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab3HNQpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:45:30 -0400
MIME-Version: 1.0
In-Reply-To: <000201ce8f40$2322df90$69689eb0$@samsung.com>
References: <000201ce8f40$2322df90$69689eb0$@samsung.com>
Date: Wed, 14 Aug 2013 18:45:30 +0200
Message-ID: <CACRpkdY1t-g1C9QZJx3E5ytc1BJ+6Jr2h9Xk3scu1K6=Rsgwsg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mfd: ab8500-gpadc: add CONFIG_PM_SLEEP to suspend/resume
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 7:21 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Add CONFIG_PM_SLEEP to suspend/resume functions to fix the build
> warnings when CONFIG_PM_SLEEP is not selected. This is because
> sleep PM callbacks defined by SET_SYSTEM_SLEEP_PM_OPS are only used
> when the CONFIG_PM_SLEEP is enabled.
>
> drivers/mfd/ab8500-gpadc.c:891:12: warning: 'ab8500_gpadc_suspend' defined but not used [-Wunused-function]
> drivers/mfd/ab8500-gpadc.c:903:12: warning: 'ab8500_gpadc_resume' defined but not used [-Wunused-function]
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
