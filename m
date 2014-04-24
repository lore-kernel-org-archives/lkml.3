Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaDXVm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:42:56 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41733 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaDXVmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:42:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFp12-g0EXvnp0z2pQfiFxTRZMK4nK8y0XMUhUeDSOwNEA@mail.gmail.com>
References: <1397847510-17199-1-git-send-email-tim.kryger@linaro.org>
	<CAPDyKFp12-g0EXvnp0z2pQfiFxTRZMK4nK8y0XMUhUeDSOwNEA@mail.gmail.com>
Date: Thu, 24 Apr 2014 14:42:54 -0700
Message-ID: <CAAYSxhoK=6wPqCm3RbRRkftCX6RoN_eGdisSPrxE9mPjBF6M-g@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: Try other signal levels during power up
From: Tim Kryger <tim.kryger@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, Linux MMC <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 1:38 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 18 April 2014 20:58, Tim Kryger <tim.kryger@linaro.org> wrote:

>>  void mmc_power_up(struct mmc_host *host, u32 ocr)
>>  {
>> +       int err;
>> +
>
> The variable err is not needed, since we don't plan on printing it nor
> returning it. Please remove and handle the return code directly in the
> if statements.

Sure.  I'll send out an updated version shortly.

Thanks,
Tim
