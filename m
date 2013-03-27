Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3C0Iu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:50:57 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:57479 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3C0Iu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:50:56 -0400
MIME-Version: 1.0
In-Reply-To: <006601ce215d$af1f6af0$0d5e40d0$%han@samsung.com>
References: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
	<006601ce215d$af1f6af0$0d5e40d0$%han@samsung.com>
Date: Wed, 27 Mar 2013 09:50:53 +0100
Message-ID: <CACRpkda44e2Qy_oxV1t-0A3LcEM10tJXN2h-BY9BJgJFQGQKuA@mail.gmail.com>
Subject: Re: [PATCH 5/6] gpio: mc33880: use devm_kzalloc()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 10:15 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Use devm_kzalloc() to make cleanup paths simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Thanks!
Linus Walleij
