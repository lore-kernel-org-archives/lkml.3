Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbaGXOEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:04:12 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:37824 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758977AbaGXOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:04:10 -0400
MIME-Version: 1.0
In-Reply-To: <1406127413-10672-1-git-send-email-acourbot@nvidia.com>
References: <1406127413-10672-1-git-send-email-acourbot@nvidia.com>
Date: Thu, 24 Jul 2014 16:04:09 +0200
Message-ID: <CACRpkdbUp3=FtFyCgVKDFHwG51STBW88=-aJbn9x3iHxnK-R_w@mail.gmail.com>
Subject: Re: [PATCH] gpio: remove useless check in gpiolib_sysfs_init()
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 4:56 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> An iterator variable cannot be NULL in its loop.
>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied.

Yours,
Linus Walleij
