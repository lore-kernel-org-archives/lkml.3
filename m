Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaKFDe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:34:26 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58894 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaKFDeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:34:23 -0500
MIME-Version: 1.0
In-Reply-To: <5448CE60.7040004@samsung.com>
References: <1414052218-20157-1-git-send-email-acourbot@nvidia.com> <5448CE60.7040004@samsung.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 6 Nov 2014 12:34:01 +0900
Message-ID: <CAAVeFuK0g8w5oqaHUEYBoQSyfEM5pcQAcdGdXSsjPXy-QpWd8g@mail.gmail.com>
Subject: Re: [PATCH] drm/panel: s6e8aa0: Update calls to gpiod_get*()
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 6:46 PM, Andrzej Hajda <a.hajda@samsung.com> wrote:
> On 10/23/2014 10:16 AM, Alexandre Courbot wrote:
>> Add the new flags argument to calls of (devm_)gpiod_get*() and
>> remove any direction setting code afterwards.
>>
>> Currently both forms (with or without the flags argument)
>> are valid thanks to transitional macros in
>> <linux/gpio/consumer.h>. These macros will be removed once
>> all consumers are updated and the flags argument will become
>> compulsary.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>
> It needs patch "gpio: Fix gpio direction flags not getting set" to work
> correctly. It is not yet present in drm-next. Beside this:
>
> Acked-by: Andrzej Hajda <a.hajda@samsung.com>

The required patch is now merged, can we go on with this patch?
