Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbaEPQWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:22:39 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:32777 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaEPQWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:22:38 -0400
MIME-Version: 1.0
In-Reply-To: <001d01cf6f23$00900250$01b006f0$%han@samsung.com>
References: <001d01cf6f23$00900250$01b006f0$%han@samsung.com>
Date: Fri, 16 May 2014 18:22:37 +0200
Message-ID: <CACRpkdYj6o2kz80X3gpQe6ut0g7Nr5=d+KEVRwcmc2U1mzmNwg@mail.gmail.com>
Subject: Re: [PATCH] mfd: ipaq-micro: Use devm_ioremap_resource()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 5:17 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Use devm_ioremap_resource() because devm_request_and_ioremap() is
> obsoleted by devm_ioremap_resource().
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
