Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaKFDer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:34:47 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43447 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaKFDep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:34:45 -0500
MIME-Version: 1.0
In-Reply-To: <1414052218-20157-2-git-send-email-acourbot@nvidia.com>
References: <1414052218-20157-1-git-send-email-acourbot@nvidia.com> <1414052218-20157-2-git-send-email-acourbot@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 6 Nov 2014 12:34:25 +0900
Message-ID: <CAAVeFuJyyiS29c9py0sTcqVh-hRFrK310zLL_G3mxGrVOo-CyA@mail.gmail.com>
Subject: Re: [PATCH] drm/panel: simple: Update calls to gpiod_get*()
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 5:16 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Add the new flags argument to calls of (devm_)gpiod_get*() and
> remove any direction setting code afterwards.
>
> Currently both forms (with or without the flags argument)
> are valid thanks to transitional macros in
> <linux/gpio/consumer.h>. These macros will be removed once
> all consumers are updated and the flags argument will become
> compulsary.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Thierry, are you ok with this patch?
