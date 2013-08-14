Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab3HNQpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:45:16 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:45392 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab3HNQpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:45:12 -0400
MIME-Version: 1.0
In-Reply-To: <000101ce8f40$0e118070$2a348150$@samsung.com>
References: <000101ce8f40$0e118070$2a348150$@samsung.com>
Date: Wed, 14 Aug 2013 18:45:11 +0200
Message-ID: <CACRpkdavPSV9Lz_drJFxuoLMAv9+UAqTzudNYoQT-CK+2sivAg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: ab8500-gpadc: add CONFIG_PM_RUNTIME to runtime_suspend/runtime_resume
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 7:20 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Add CONFIG_PM_RUNTIME to runtime_suspend/runtime_resume functions
> to fix the build warnings when CONFIG_PM_RUNTIME is not selected.
> This is because runtime PM callbacks defined by SET_RUNTIME_PM_OPS
> are only used when the CONFIG_PM_RUNTIME is enabled.
>
> drivers/mfd/ab8500-gpadc.c:870:12: warning: 'ab8500_gpadc_runtime_suspend' defined but not used [-Wunused-function]
> drivers/mfd/ab8500-gpadc.c:878:12: warning: 'ab8500_gpadc_runtime_resume' defined but not used [-Wunused-function]
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
