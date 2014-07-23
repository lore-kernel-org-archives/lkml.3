Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbaGWPlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:41:37 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:57950 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077AbaGWPlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:41:35 -0400
MIME-Version: 1.0
In-Reply-To: <1406013463-19218-4-git-send-email-acourbot@nvidia.com>
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
	<1406013463-19218-4-git-send-email-acourbot@nvidia.com>
Date: Wed, 23 Jul 2014 17:41:35 +0200
Message-ID: <CACRpkdbSMSqK3xprZ4FDF1uY=kN-EAj3Ze4a2K3O1n5f-V5+pA@mail.gmail.com>
Subject: Re: [PATCH 3/5] gpio: make gpiochip_get_desc() gpiolib-private
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 9:17 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> As GPIO descriptors are not going to remain unique anymore, having this
> function public is not safe. Restrain its use to gpiolib since we have
> no user outside of it.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied.

Yours,
Linus Walleij
