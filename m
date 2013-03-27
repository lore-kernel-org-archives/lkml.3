Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab3C0IxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:53:20 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:56740 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3C0IxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:53:18 -0400
MIME-Version: 1.0
In-Reply-To: <006801ce215d$d2cc90e0$7865b2a0$%han@samsung.com>
References: <006801ce215d$d2cc90e0$7865b2a0$%han@samsung.com>
Date: Wed, 27 Mar 2013 09:53:18 +0100
Message-ID: <CACRpkdZ2SE9OW3GUSO6uO-Q0=CFUQcxZp1VxUAAKPTZ2qsW6bQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: mc33880: use dev_err() instead of printk()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 10:16 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> dev_err() is more preferred than printk().
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Thanks!
Linus Walleij
