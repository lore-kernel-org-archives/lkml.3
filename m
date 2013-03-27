Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3C0Itq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:49:46 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:42791 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3C0Itk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:49:40 -0400
MIME-Version: 1.0
In-Reply-To: <006501ce215d$a275fe40$e761fac0$%han@samsung.com>
References: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
	<006501ce215d$a275fe40$e761fac0$%han@samsung.com>
Date: Wed, 27 Mar 2013 09:49:40 +0100
Message-ID: <CACRpkdbzMMrZ66JBFPe5b=rZdKOo=BZFkfbPRZFtUBdEax8KTQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] gpio: max732x: use devm_kzalloc()
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
